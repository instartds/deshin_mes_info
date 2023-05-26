package foren.unilite.modules.human.hum;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class HumReportController  extends UniliteCommonController {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
    
    /**
     * add Chen.Rd
     * 인사기록 카드 출력(PDF) 단건 
     * @param _req
     * @return
     * @throws Exception
     */
       @RequestMapping(value = "/human/hum961rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView hum961rkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           String[] subReportFileNames = { 
           };
           
           // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
            param.put("S_COMP_CODE", user.getCompCode());
            
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            JasperFactory jf  = jasperService.createJasperFactory("hum961rkr", param);
            jf.setReportType(reportType);
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
            
            // 직원 사진용 경로를 전달(일반 design용 이미지 경로는 config 파일에 따름)    
            String imagePath = (ConfigUtil.getUploadBasePath(HumController.FILE_TYPE_OF_PHOTO) + File.separator).replace("\\", "/");
            File directory = new File(imagePath);
    		if (!directory.exists()) {
    			directory.mkdirs();
    		}
            jf.addParam("HUMAN_IMAGE_PATH", imagePath);
            // Primary data source
            
           
            List<Map<String, Object>> list = jasperService.selectList("hum961rkrServiceImpl.selectList", param);
            for(Map item:list){
            	String fileName = item.get("PERSON_NUMB").toString()+".jpg";
            	File imagefile = new File(imagePath+fileName);
        		if (!imagefile.exists()) {
        			if(item.get("IMG_FILE")!=null&&item.get("IMG_FILE").equals("")){
     	         	   try {   
     	                    byte[] bytes = (byte[]) item.get("IMG_FILE");   
     	                    ByteArrayInputStream bais = new ByteArrayInputStream(bytes);   
     	                    BufferedImage bi =ImageIO.read(bais);
     	                    File file = new File(imagePath,fileName);//可以是jpg,png,gif格式   
     	                    ImageIO.write(bi, "jpg", file);//不管输出什么格式图片，此处不需改动   
     	                    item.put("IMG_FILE", fileName);
     	                } catch (IOException e) {   
     	                    e.printStackTrace();   
     	                } 
                 	}else{
                 		item.put("IMG_FILE", null);
                 	}
        		}else{
        			item.put("IMG_FILE", fileName);
        		}
            	param.put("PERSON_NUMB", item.get("PERSON_NUMB"));
            	List<Map<String, Object>> sublist1 = jasperService.selectList("hum961rkrServiceImpl.selectSubList1", param);
            	int i=0;
            	for(Map sub1:sublist1){
            		if(item.get("PERSON_NUMB").equals(sub1.get("PERSON_NUMB"))){
            			item.put("ENTR_DATE_"+i, sub1.get("ENTR_DATE"));
            			item.put("GRAD_DATE_"+i, sub1.get("GRAD_DATE"));
            			item.put("SCHOOL_NAME_"+i, sub1.get("SCHOOL_NAME"));
            			i++;
            		}
            		if(i>2) break;
            	}
            	
            	List<Map<String, Object>> sublist2 = jasperService.selectList("hum961rkrServiceImpl.selectSubList2", param);
            	i=0;
            	for(Map sub2:sublist2){
            		if(item.get("PERSON_NUMB").equals(sub2.get("PERSON_NUMB"))){
            			item.put("MERITS_YEARS1_"+i, sub2.get("MERITS_YEARS1"));
            			item.put("MERITS_GRADE1_"+i, sub2.get("MERITS_GRADE1"));
            			item.put("MERITS_YEARS2_"+i, sub2.get("MERITS_YEARS2"));
            			item.put("MERITS_GRADE2_"+i, sub2.get("MERITS_GRADE2"));
            			i++;
            		}
            		if(i>2) break;
            	}
            	List<Map<String, Object>> sublist3 = jasperService.selectList("hum961rkrServiceImpl.selectSubList3", param);
            	i=0;
            	for(Map sub3:sublist3){
            		if(item.get("PERSON_NUMB").equals(sub3.get("PERSON_NUMB"))){
            			item.put("DEPT_NAME_"+i, sub3.get("DEPT_NAME"));
            			item.put("CARR_DATE_"+i, sub3.get("CARR_DATE"));
            			item.put("JOB_NAME_"+i, sub3.get("JOB_NAME"));
            			i++;
            		}
            		if(i>3) break;
            	}
            }
            
            
            jf.setList(list);
            // sub report data sources
//            jf.addSubDS("DS_SUB01", sublist1);
//            jf.addSubDS("DS_SUB02", sublist2);
//            jf.addSubDS("DS_SUB03", sublist3);
//           
            
            // 레포트 자체의 SQL 사용시에만 사용 
            //super.jasperService.setDbConnection(jParam);
            


            return ViewHelper.getJasperView(jf);
        }
       
       
    
    
    /**
     * 인사기록 카드 출력(PDF) 단건 
     * @param _req
     * @return
     * @throws Exception
     */
       @RequestMapping(value = "/human/hum960rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView hum960rkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           String[] subReportFileNames = { 
                           "hum960rkr_sub01",
                           "hum960rkr_sub02" ,
                           "hum960rkr_sub03",
                           "hum960rkr_sub04",
                           "hum960rkr_sub05",
                           "hum960rkr_sub06",
                           "hum960rkr_sub07",
                           "hum960rkr_sub08",
                           "hum960rkr_sub09",
                           "hum960rkr_sub10",
                           "hum960rkr_sub11"
           };
           
           // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
            param.put("COMP_CODE", user.getCompCode());
            
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            JasperFactory jf  = jasperService.createJasperFactory("hum960rkr", param);
            jf.setReportType(reportType);
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
            
            // 직원 사진용 경로를 전달(일반 design용 이미지 경로는 config 파일에 따름)  
            String imagePath = ConfigUtil.getUploadBasePath(HumController.FILE_TYPE_OF_PHOTO) + File.separator;
            File directory = new File(imagePath);
    		if (!directory.exists()) {
    			directory.mkdirs();
    		}
            jf.addParam("HUMAN_IMAGE_PATH", imagePath);
            
            // Primary data source
            
            List<Map<String,Object>> list = jasperService.selectList("hum960rkrServiceImpl.selectPrimaryDataList", param);
            if(list != null && list.size() > 0){
            	
            	for(Map<String,Object> map : list){
            		File file =new File(imagePath, map.get("PERSON_NUMB")+".jpg");
            		if (!file.exists()) {
	            		if(map.get("IMG_FILE") != null){
		            		try { 
		            			byte[] fileData = (byte[])map.get("IMG_FILE");
		            			ByteArrayInputStream bais = new ByteArrayInputStream(fileData);
		            			BufferedImage bufImg = ImageIO.read(bais);
		            			if(bufImg != null){
		            				ImageIO.write(bufImg, "jpg", file);
		            			}
				    			} catch (IOException e) {   
				                    e.printStackTrace();   
				                } 
		            	 }
            		}
            	}
            }
            jf.setList(list);
            // sub report data sources
            jf.addSubDS("DS_SUB01", jasperService.selectList("hum960rkrServiceImpl.ds_sub01", param));
            jf.addSubDS("DS_SUB02", jasperService.selectList("hum960rkrServiceImpl.ds_sub02", param));
            jf.addSubDS("DS_SUB03", jasperService.selectList("hum960rkrServiceImpl.ds_sub03", param));
            jf.addSubDS("DS_SUB04", jasperService.selectList("hum960rkrServiceImpl.ds_sub04", param));
            jf.addSubDS("DS_SUB05", jasperService.selectList("hum960rkrServiceImpl.ds_sub05", param));
            jf.addSubDS("DS_SUB06", jasperService.selectList("hum960rkrServiceImpl.ds_sub06", param));
            jf.addSubDS("DS_SUB07", jasperService.selectList("hum960rkrServiceImpl.ds_sub07", param));
            jf.addSubDS("DS_SUB08", jasperService.selectList("hum960rkrServiceImpl.ds_sub08", param));
            jf.addSubDS("DS_SUB09", jasperService.selectList("hum960rkrServiceImpl.ds_sub09", param));
            jf.addSubDS("DS_SUB10", jasperService.selectList("hum960rkrServiceImpl.ds_sub10", param));
            jf.addSubDS("DS_SUB11", jasperService.selectList("hum960rkrServiceImpl.ds_sub11", param));
            
            // 레포트 자체의 SQL 사용시에만 사용 
            //super.jasperService.setDbConnection(jParam);
            


            return ViewHelper.getJasperView(jf);
        }
       
       
   
       
       /**
        * 인사기록 카드 출력(PDF) 단건 
        * @param _req
        * @return
        * @throws Exception
        */
          @RequestMapping(value = "/human/hum962rkrPrint.do", method = RequestMethod.GET)
           public ModelAndView hum962rkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
              String[] subReportFileNames = { 
                                          
              };
              
              // Report와 SQL용 파라미터 구성
               Map param = _req.getParameterMap();
               param.put("COMP_CODE", user.getCompCode());
               
               // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
               // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
               JasperFactory jf  = null;
               
               String fileName="";
               String strPrintType = param.get("PRINT_TYPE").toString();
               String strAddYn     = param.get("ADD_YN").toString();
               String strQuery = "hum962rkrServiceImpl.";
               
               if (strAddYn.equals("Y")){
            	   fileName ="hum962rkr2";
            	   jf=jasperService.createJasperFactory("hum962rkr",fileName, param);
                   jf.setReportType(reportType);
            	   subReportFileNames = new String[]{
                           "hum962rkr_sub01",
                           "hum962rkr_sub02" ,
                           "hum962rkr_sub03",
                           "hum962rkr2_sub04",
                           "hum962rkr2_sub05",
                           "hum962rkr_sub06",
                           "hum962rkr_sub07",
                           "hum962rkr_sub08",
                           "hum962rkr_sub09",
                           "hum962rkr_sub10",
                           "hum962rkr2_sub11",
                           "hum962rkr_sub12",
                           "hum962rkr2_sub13" 
            	   };
            	   jf.addSubDS("DS_SUB01", jasperService.selectList("hum962rkrServiceImpl.ds_sub01", param));
                   jf.addSubDS("DS_SUB02", jasperService.selectList("hum962rkrServiceImpl.ds_sub02", param));
                   jf.addSubDS("DS_SUB03", jasperService.selectList("hum962rkrServiceImpl.ds_sub03", param));
                   jf.addSubDS("DS_SUB04", jasperService.selectList("hum962rkrServiceImpl.ds_sub04", param));
                   jf.addSubDS("DS_SUB05", jasperService.selectList("hum962rkrServiceImpl.ds_sub05", param));
                   jf.addSubDS("DS_SUB06", jasperService.selectList("hum962rkrServiceImpl.ds_sub06", param));
                   jf.addSubDS("DS_SUB07", jasperService.selectList("hum962rkrServiceImpl.ds_sub07", param));
                   jf.addSubDS("DS_SUB08", jasperService.selectList("hum962rkrServiceImpl.ds_sub08", param));
                   jf.addSubDS("DS_SUB09", jasperService.selectList("hum962rkrServiceImpl.ds_sub09", param));
                   jf.addSubDS("DS_SUB10", jasperService.selectList("hum962rkrServiceImpl.ds_sub10", param));
                   jf.addSubDS("DS_SUB11", jasperService.selectList("hum962rkrServiceImpl.ds_sub11", param));
                   jf.addSubDS("DS_SUB12", jasperService.selectList("hum962rkrServiceImpl.ds_sub12", param));
                   jf.addSubDS("DS_SUB13", jasperService.selectList("hum962rkrServiceImpl.ds_sub13", param));
               }else{
            	   if (strPrintType.equals("2")){
            		   fileName ="hum962rkr3";
            		   jf=jasperService.createJasperFactory("hum962rkr",fileName, param);
                       jf.setReportType(reportType);
            		   subReportFileNames = new String[]{
                               "hum962rkr3_sub01",
                               "hum962rkr3_sub02" ,
                               "hum962rkr3_sub03",
                               "hum962rkr3_sub04",
                	   };
                	   jf.addSubDS("DS_SUB31", jasperService.selectList("hum962rkrServiceImpl.ds_sub31", param));
                       jf.addSubDS("DS_SUB32", jasperService.selectList("hum962rkrServiceImpl.ds_sub32", param));
                       jf.addSubDS("DS_SUB33", jasperService.selectList("hum962rkrServiceImpl.ds_sub33", param));
                       jf.addSubDS("DS_SUB34", jasperService.selectList("hum962rkrServiceImpl.ds_sub34", param));
                      
            	   }else
            	   {
            		   fileName ="hum962rkr1";
            		   jf=jasperService.createJasperFactory("hum962rkr",fileName, param);
                       jf.setReportType(reportType);
            		   subReportFileNames = new String[]{
                               "hum962rkr_sub01",
                               "hum962rkr_sub02" ,
                               "hum962rkr_sub03",
                               "hum962rkr_sub04",
                               "hum962rkr_sub05",
                               "hum962rkr_sub06",
                               "hum962rkr_sub07",
                               "hum962rkr_sub08",
                               "hum962rkr_sub09",
                               "hum962rkr_sub10",
                               "hum962rkr_sub11",
                               "hum962rkr_sub12",
                	   };
                	   jf.addSubDS("DS_SUB01", jasperService.selectList("hum962rkrServiceImpl.ds_sub01", param));
                       jf.addSubDS("DS_SUB02", jasperService.selectList("hum962rkrServiceImpl.ds_sub02", param));
                       jf.addSubDS("DS_SUB03", jasperService.selectList("hum962rkrServiceImpl.ds_sub03", param));
                       jf.addSubDS("DS_SUB04", jasperService.selectList("hum962rkrServiceImpl.ds_sub04", param));
                       jf.addSubDS("DS_SUB05", jasperService.selectList("hum962rkrServiceImpl.ds_sub05", param));
                       jf.addSubDS("DS_SUB06", jasperService.selectList("hum962rkrServiceImpl.ds_sub06", param));
                       jf.addSubDS("DS_SUB07", jasperService.selectList("hum962rkrServiceImpl.ds_sub07", param));
                       jf.addSubDS("DS_SUB08", jasperService.selectList("hum962rkrServiceImpl.ds_sub08", param));
                       jf.addSubDS("DS_SUB09", jasperService.selectList("hum962rkrServiceImpl.ds_sub09", param));
                       jf.addSubDS("DS_SUB10", jasperService.selectList("hum962rkrServiceImpl.ds_sub10", param));
                       jf.addSubDS("DS_SUB11", jasperService.selectList("hum962rkrServiceImpl.ds_sub11", param));
                       jf.addSubDS("DS_SUB12", jasperService.selectList("hum962rkrServiceImpl.ds_sub12", param));
        		   }
               }
               
               // SubReport 파일명 목록을 전달
               // 레포트 수행시 compile을 상황에 따라 수행함.
               if (strPrintType.equals("1")){
            	   strQuery +="selectList1";
            	   
               }else{
            	   strQuery +="selectList2";
               }
               jf.setSubReportFiles(subReportFileNames);
               
               // 직원 사진용 경로를 전달(일반 design용 이미지 경로는 config 파일에 따름)          
               jf.addParam("HUMAN_IMAGE_PATH", ConfigUtil.getUploadBasePath(HumController.FILE_TYPE_OF_PHOTO) + File.separator);
               jf.addParam("REPRE_NAME", param.get("REPRE_NAME"));
               
               // Primary data source
               jf.setList(jasperService.selectList(strQuery, param));
               // 레포트 자체의 SQL 사용시에만 사용 
               //super.jasperService.setDbConnection(jParam);

               return ViewHelper.getJasperView(jf);
           }
   
       /**
        * 인사기록 카드 출력(PDF) 단건 
        * @param _req
        * @return
        * @throws Exception
        */
          @RequestMapping(value = "/human/hum980rkrPrint.do", method = RequestMethod.GET)
           public ModelAndView hum980rkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
              String[] subReportFileNames = { 
                              "hum980rkr_sub01",
                              "hum980rkr_sub02" ,
                              "hum980rkr_sub03",
                              "hum980rkr_sub04",
                              "hum980rkr_sub05",
                              "hum980rkr_sub06_1",
                              "hum980rkr_sub06_2",
                              "hum980rkr_sub07",
                              "hum980rkr_sub08",
                              "hum980rkr_sub09",
                           
              };
              
              // Report와 SQL용 파라미터 구성
               Map param = _req.getParameterMap();
               param.put("COMP_CODE", user.getCompCode());
               
               // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
               // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
               JasperFactory jf  = jasperService.createJasperFactory("hum980rkr", param);
               jf.setReportType(reportType);
               // SubReport 파일명 목록을 전달
               // 레포트 수행시 compile을 상황에 따라 수행함.
               jf.setSubReportFiles(subReportFileNames);
               
               // 직원 사진용 경로를 전달(일반 design용 이미지 경로는 config 파일에 따름)          
               String imagePath = ConfigUtil.getUploadBasePath(HumController.FILE_TYPE_OF_PHOTO) + File.separator;
               File directory = new File(imagePath);
	       		if (!directory.exists()) {
	       			directory.mkdirs();
	       		}
	               jf.addParam("HUMAN_IMAGE_PATH", imagePath);
               
               // Primary data source
               List<Map<String,Object>> list = jasperService.selectList("hum980rkrServiceImpl.selectPrimaryDataList", param);
               if(list != null && list.size() > 0){
              	 
               	for(Map<String,Object> map : list){
               		File file =new File(imagePath, map.get("PERSON_NUMB")+".jpg");
            		if (!file.exists()) {
	               		if(map.get("IMG_FILE") != null){
		               		try { 
		               			byte[] fileData = (byte[])map.get("IMG_FILE");
		               			ByteArrayInputStream bais = new ByteArrayInputStream(fileData);
		               			BufferedImage bufImg = ImageIO.read(bais);
		               			if(bufImg != null){
		            				ImageIO.write(bufImg, "jpg", file);
		            			}
		   		    			} catch (IOException e) {   
		   		                    e.printStackTrace();   
		   		                } 
		               	 }
	            	}
               	}
               }
               jf.setList(list);
               // sub report data sources
               jf.addSubDS("DS_SUB01", jasperService.selectList("hum980rkrServiceImpl.ds_sub01", param));
               jf.addSubDS("DS_SUB02", jasperService.selectList("hum980rkrServiceImpl.ds_sub02", param));
               jf.addSubDS("DS_SUB03", jasperService.selectList("hum980rkrServiceImpl.ds_sub03", param));
               jf.addSubDS("DS_SUB04", jasperService.selectList("hum980rkrServiceImpl.ds_sub04", param));
               jf.addSubDS("DS_SUB05", jasperService.selectList("hum980rkrServiceImpl.ds_sub05", param));
               jf.addSubDS("DS_SUB06_1", jasperService.selectList("hum980rkrServiceImpl.ds_sub06", param));
               jf.addSubDS("DS_SUB06_2", jasperService.selectList("hum980rkrServiceImpl.ds_sub07", param));
               jf.addSubDS("DS_SUB07", jasperService.selectList("hum980rkrServiceImpl.ds_sub08", param));
               jf.addSubDS("DS_SUB08", jasperService.selectList("hum980rkrServiceImpl.ds_sub09", param));
               // 레포트 자체의 SQL 사용시에만 사용 
               //super.jasperService.setDbConnection(jParam);
               


               return ViewHelper.getJasperView(jf);
           }
       /**
        * 사원명부출력
        * @param _req
        * @return
        * @throws Exception
        */
      @RequestMapping(value = "/hum/hum950rkrPrint.do", method = RequestMethod.GET)
       public ModelAndView hum950rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
          String[] subReportFileNames = {
          };
          
          // Report와 SQL용 파라미터 구성
           Map param = _req.getParameterMap();
           param.put("S_COMP_CODE", user.getCompCode());

           // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
           // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
           
           JasperFactory jf = null;
           if(param.get("DOC_KIND").equals("1")){
        	   jf  = jasperService.createJasperFactory("hum950rkr", "Hum950rkr1",  param);   // "폴더명" , "파일명" , "파라미터
           }else if(param.get("DOC_KIND").equals("2")){
        	   jf  = jasperService.createJasperFactory("hum950rkr", "Hum950rkr1",  param);
           }else if(param.get("DOC_KIND").equals("3")){
        	   jf  = jasperService.createJasperFactory("hum950rkr", "Hum950rkr1",  param);
           }

           jf.setReportType(reportType);
           // SubReport 파일명 목록을 전달
           // 레포트 수행시 compile을 상황에 따라 수행함.
           //jf.setSubReportFiles(subReportFileNames);
           
           // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)        
           //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request)); 
           // Primary data source
           
           String deptCode = ObjUtils.getSafeString(param.get("DEPT_CODE"));
           if(deptCode != null){
        	   String[] arry = deptCode.split(",");
        	   param.put("DEPT_CODE" , arry);
           }
           
           jf.setList(jasperService.selectList("hum950rkrServiceImpl.fnHum950nQ", param));

           return ViewHelper.getJasperView(jf);
       } 
       
       
       /**
        * 재직/경력 증명서 출력
        * @param _req
        * @return
        * @throws Exception
        */
      @RequestMapping(value = "/hum/hum970rkrPrint.do", method = RequestMethod.GET)
       public ModelAndView hum970rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
          String[] subReportFileNames = {
          };
          
          // Report와 SQL용 파라미터 구성
           Map param = _req.getParameterMap();
           param.put("S_COMP_CODE", user.getCompCode());

           // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
           // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
           
           JasperFactory jf = null;
           if(param.get("DOC_KIND").equals("3")){
        	   jf  = jasperService.createJasperFactory("hum970rkr", "hum971rkr",  param);   // "폴더명" , "파일명" , "파라미터
           }else{
        	   jf  = jasperService.createJasperFactory("hum970rkr", "hum970rkr",  param);
           }

           jf.setReportType(reportType);
           // SubReport 파일명 목록을 전달
           // 레포트 수행시 compile을 상황에 따라 수행함.
           //jf.setSubReportFiles(subReportFileNames);
           
           // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
           jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
           
           // Primary data source
           jf.setList(jasperService.selectList("hum970rkrServiceImpl.fnHum970nQ", param));

           return ViewHelper.getJasperView(jf);
       } 
      
      /**
       * 재직/경력증명서 출력 (공공)
       * @param _req
       * @return
       * @throws Exception
       */
         @RequestMapping(value = "/hum/hum975rkrPrint.do", method = RequestMethod.GET)
          public ModelAndView hum975rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
             String[] subReportFileNames = { 
                             "hum975rkr2.sub01",
                             "hum975rkr2.sub02" ,
                             "hum975rkr2.sub03" 
             };
             
             // Report와 SQL용 파라미터 구성
              Map param = _req.getParameterMap();
              param.put("COMP_CODE", user.getCompCode());
              
              // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
              // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
              
              JasperFactory jf = null;
              if(param.get("DOC_KIND").equals("1")){
           	   jf  = jasperService.createJasperFactory("hum975rkr", "hum975rkr1",  param);   // "폴더명" , "파일명" , "파라미터
              }else{
           	   jf  = jasperService.createJasperFactory("hum975rkr", "hum975rkr2",  param);
              }
              
              jf.setReportType(reportType);
              // SubReport 파일명 목록을 전달
              // 레포트 수행시 compile을 상황에 따라 수행함.
              jf.setSubReportFiles(subReportFileNames);
              
              // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
              jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
              
              // Primary data source
              jf.setList(jasperService.selectList("hum975rkrServiceImpl.fnHum975nQ", param));
              if(!param.get("DOC_KIND").equals("1")){
	              // sub report data sources
	              jf.addSubDS("DS_SUB01", jasperService.selectList("hum975rkrServiceImpl.ds_sub01", param));
	              jf.addSubDS("DS_SUB02", jasperService.selectList("hum975rkrServiceImpl.ds_sub02", param));
	              jf.addSubDS("DS_SUB03", jasperService.selectList("hum975rkrServiceImpl.ds_sub03", param));
              }
              // 레포트 자체의 SQL 사용시에만 사용 
              //super.jasperService.setDbConnection(jParam);
              


              return ViewHelper.getJasperView(jf);
          }
         
         
         
         
         /**
          * 
          * @param _req
          * @return
          * @throws Exception
          */
            @RequestMapping(value = "/hum/hum315rkrPrint.do", method = RequestMethod.GET)
             public ModelAndView hum315rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
                String[] subReportFileNames = { 

                };
                
                // Report와 SQL용 파라미터 구성
                 Map param = _req.getParameterMap();
                 param.put("COMP_CODE", user.getCompCode());
                 
                 // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
                 // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
                 
                 JasperFactory jf = jasperService.createJasperFactory("hum315rkr", "hum315rkr",  param);

                 jf.setReportType(reportType);
                 // SubReport 파일명 목록을 전달
                 // 레포트 수행시 compile을 상황에 따라 수행함.
                 jf.setSubReportFiles(subReportFileNames);
                 
                 // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
                // jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
                 
                 
             //    String divCode = ObjUtils.getSafeString(param.get("DIV_CODE"));
                 String deptCode = ObjUtils.getSafeString(param.get("DEPT_CODE"));
                 
                 List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

                 Map dataParam = new HashMap();
                 
                     dataParam.put("S_COMP_CODE"   , param.get("COMP_CODE"));
                     dataParam.put("PERSON_NUMB"    , param.get("PERSON_NUMB"));
                     dataParam.put("RDO_TYPE"   , param.get("RDO_TYPE"));
                     dataParam.put("FR_REPRE_NUM"      , param.get("FR_REPRE_NUM"));
                     dataParam.put("TO_REPRE_NUM"    , param.get("TO_REPRE_NUM"));
                     dataParam.put("REL_CODE"  , param.get("REL_CODE"));
                     dataParam.put("SCHSHIP_CODE" , param.get("SCHSHIP_CODE"));
                     dataParam.put("PAY_GUBUN" , param.get("PAY_GUBUN"));
                     dataParam.put("EMPLOY_GUBUN" , param.get("EMPLOY_GUBUN"));
                     dataParam.put("COST_POOL" , param.get("COST_POOL"));
                     dataParam.put("PAY_PROV_FLAG" , param.get("PAY_PROV_FLAG"));
                     dataParam.put("PERSON_GROUP" , param.get("PERSON_GROUP"));
                     
  
                    /* if(divCode != null){
                         String[] arry  = divCode.split(",");
                         dataParam.put("DIV_CODE"     , arry);
                      }   */
                     if(deptCode != null){
                         String[] arry2  = deptCode.split(",");
                         dataParam.put("DEPTS"     , arry2);
                      }  
                     
                     
                     
                     
                 // Primary data source
                 jf.setList(jasperService.selectList("hum315skrService.selectList", param));
                 
                 
                 
                 // sub report data sources
                 
                 // 레포트 자체의 SQL 사용시에만 사용 
                 //super.jasperService.setDbConnection(jParam);
                 


                 return ViewHelper.getJasperView(jf);
             }
            
            
            /**
             * 재직/경력증명서 출력 (공공)
             * @param _req
             * @return
             * @throws Exception
             */
               @RequestMapping(value = "/hum/hum102rkrPrint.do", method = RequestMethod.GET)
                public ModelAndView hum102rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
     
                   // Report와 SQL용 파라미터 구성
                    Map param = _req.getParameterMap();
                    param.put("S_COMP_CODE", user.getCompCode());
                    
                    // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
                    // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
                    
                    JasperFactory jf = null;
                    jf  = jasperService.createJasperFactory("hum102rkr", "hum102rkr",  param);   // "폴더명" , "파일명" , "파라미터
                    
                    jf.setReportType(reportType);
                    
                    // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
                    jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
                    
                    // Primary data source
                    jf.setList(jasperService.selectList("hum102rkrService.selectList", param));
                    
                    
                    // 레포트 자체의 SQL 사용시에만 사용 
                    //super.jasperService.setDbConnection(jParam);
                    


                    return ViewHelper.getJasperView(jf);
                }
               
               /**
                * 재직/경력증명서 출력 (공공)
                * @param _req
                * @return
                * @throws Exception
                */
                  @RequestMapping(value = "/hum/hum101rkrPrint.do", method = RequestMethod.GET)
                   public ModelAndView hum101rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
        
                      // Report와 SQL용 파라미터 구성
                       Map param = _req.getParameterMap();
                       param.put("S_COMP_CODE", user.getCompCode());
                       
                       // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
                       // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
                       
                       JasperFactory jf = null;
                       jf  = jasperService.createJasperFactory("hum101rkr", "hum101rkr",  param);   // "폴더명" , "파일명" , "파라미터
                       
                       jf.setReportType(reportType);
                       
                       // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
                       //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
                       
                       // Primary data source
                       jf.setList(jasperService.selectList("hum101rkrServiceImpl.selectList", param));
                       
                       
                       // 레포트 자체의 SQL 사용시에만 사용 
                       //super.jasperService.setDbConnection(jParam);
                       


                       return ViewHelper.getJasperView(jf);
                   }          
                  
      /**
       * 사원명부출력
       * @param _req
       * @return
       * @throws Exception
       */
     @RequestMapping(value = "/hum/hum930rkrPrint.do", method = RequestMethod.GET)
      public ModelAndView hum930rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
         String[] subReportFileNames = {
         };
         
         // Report와 SQL용 파라미터 구성
          Map param = _req.getParameterMap();
          param.put("S_COMP_CODE", user.getCompCode());

          // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
          // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
          
          JasperFactory jf = null;
          if(param.get("DOC_KIND").equals("1")){
       	   jf  = jasperService.createJasperFactory("hum930rkr", "Hum933p",  param);   // "폴더명" , "파일명" , "파라미터
          }else if(param.get("DOC_KIND").equals("2")){
       	   jf  = jasperService.createJasperFactory("hum930rkr", "Hum934p",  param);
          }else if(param.get("DOC_KIND").equals("3")){
       	   jf  = jasperService.createJasperFactory("hum930rkr", "Hum935p",  param);
          }
          
          jf.setReportType(reportType);
        
          
//          String deptCode = ObjUtils.getSafeString(param.get("DEPTS"));
//          if(deptCode != null){
//       	   String[] arry = deptCode.split(",");
//       	   param.put("DEPT_CODE" , arry);
//          }
          if(param.get("DOC_KIND").equals("1")){
        	     jf.setList(jasperService.selectList("hum930rkrServiceImpl.selectListToPrint1", param));
             }else if(param.get("DOC_KIND").equals("2")){
            	 jf.setList(jasperService.selectList("hum930rkrServiceImpl.selectListToPrint2", param));
             }else if(param.get("DOC_KIND").equals("3")){
            	 jf.setList(jasperService.selectList("hum930rkrServiceImpl.selectListToPrint3", param));
             }
          

          return ViewHelper.getJasperView(jf);
      } 
}
