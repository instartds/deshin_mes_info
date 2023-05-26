package foren.unilite.modules.accnt.agc;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.base.bor.Bor120ukrvServiceImpl;


@Controller
public class AgcReportController  extends UniliteCommonController {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
    private final Logger logger1 = LoggerFactory.getLogger(this.getClass());
    
    @Resource(name = "bor120ukrvService")
    private Bor120ukrvServiceImpl bor120ukrvService;
    
    @Resource(name = "agc150skrService")
    private Agc150skrServiceImpl agc150skrService;
    
    /**
     * 현급출납장 출력
     * @param _req
     * @return
     * @throws Exception
     */
   @RequestMapping(value = "/agc/agc130rkrPrint.do", method = RequestMethod.GET)
    public ModelAndView agc130rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
       String[] subReportFileNames = {
    		   "top_Payment"
       };
       
       // Report와 SQL용 파라미터 구성
        Map<String, Object> param = _req.getParameterMap();
        param.put("S_COMP_CODE", user.getCompCode());
        // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
        // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
        String fileName = "";
        String rtype = param.get("TYPE").toString();
//        logger.debug("****rtype****:"+rtype);
        switch (rtype){
	        case "10":
	        case "20":
	        case "30":
	        case "31":
	        case "32":
	        	fileName="agc130rkr";
	        	break;
	        case "40":
	        	fileName="agc131rkr";
        	break;
	        case "35":
	        	fileName="agc132rkr";
        	break;
    	
	        
        }
        
        if (param.get("PAGE_TYPE").equals("1")){  //横向打印
        	fileName = fileName+"_L";
        }
        
        
        JasperFactory jf = jasperService.createJasperFactory("agc130rkr", fileName,  param);   // "폴더명" , "파일명" , "파라미터
        List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
        jf.setReportType(reportType);
        // SubReport 파일명 목록을 전달
        // 레포트 수행시 compile을 상황에 따라 수행함.
        jf.setSubReportFiles(subReportFileNames);
        
        // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
        //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
        //param construct
        
        // Primary data source
        
        param.put("DIVI", rtype);
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
        jf.addParam("TITLE", codeInfo.getCodeInfo("A054", rtype).getCodeName());
        jf.addParam("THIS_DATE_FR", param.get("THIS_DATE_FR"));
        jf.addParam("THIS_DATE_TO", param.get("THIS_DATE_TO"));
        jf.addParam("PREV_DATE_FR", param.get("PREV_DATE_FR"));
        jf.addParam("PREV_DATE_TO", param.get("PREV_DATE_TO"));
//        jf.addParam("DIV_NAME", user.getDivName());
        
        if (param.get("DIV_CODE")!=null){
	        Map divi = (Map) jasperService.getDao().select("bor120ukrvServiceImpl.selectList", param);
	        jf.addParam("DIV_NAME", divi.get("DIV_NAME"));
        }
        
        jf.addParam("COMP_NAME", user.getCompName());
        jf.addParam("AMT_UNIT", codeInfo.getCodeInfo("B042", param.get("AMT_UNIT").toString()).getCodeName());
        jf.addParam("THIS_SESSION", param.get("THIS_SESSION"));
        jf.addParam("PREV_SESSION", param.get("PREV_SESSION"));
        jf.addParam("TYPE", param.get("TYPE"));
        
//        Date currentTime = new Date();
//        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//        String dateString = formatter.format(currentTime);
//        jf.addParam("CURRENT_TIME", dateString);
        String strQuery="";
        switch (rtype){//10;20;30;31;32;40;35
        	case "10":
        		strQuery= "agc130skrService.selectList1";
        	break;
        	case "20":
        		strQuery= "agc130skrService.selectList2";
        	break;
        	case "30":
        		strQuery= "agc130skrService.selectList3";
        	break;
        	case "31":
        		strQuery= "agc130skrService.selectList4";
        	break;
        	case "32":
        		strQuery= "agc130skrService.selectList5";
        	break;
        	case "40":
        		strQuery= "agc130skrService.selectList6";
        	break;
        	case "35":
        		strQuery= "agc130skrService.selectList7";
        	break;
        }
    	jflist.addAll(jasperService.selectList(strQuery, param));
        jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));	
       
        jf.setList(jflist);

        return ViewHelper.getJasperView(jf);
    }
   /**
    * 현급출납장 출력
    * @param _req
    * @return
    * @throws Exception
    */
  @RequestMapping(value = "/agc/agc100rkrPrint.do", method = RequestMethod.GET)
   public ModelAndView agc100rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
      String[] subReportFileNames = {
    		  "top_Payment"
      };
      // Report와 SQL용 파라미터 구성
       Map<String, Object> param = _req.getParameterMap();
       param.put("S_COMP_CODE", user.getCompCode());
       // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
       // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
       String fileName = "";
       if (param.get("MON_ICD_YN").equals("1")){ 
    	   fileName = "agc100rkr";
	       if (param.get("PG_LW").equals("2")){  //横向打印
	       	fileName = fileName+"_L";
	       }
       }else{
    	   fileName = "agc101rkr";
	       if (param.get("PG_LW").equals("2")){  //横向打印
	       	fileName = fileName+"_L";
	       }
       }
       
       Map map = (Map) jasperService.getDao().select("agc100rkrServiceImpl.selectMsg");
       if(map!=null){
    	   param.put("MSG_DESC",map.get("MSG_DESC"));
       }
       JasperFactory jf = jasperService.createJasperFactory("agc100rkr", fileName,  param);   // "폴더명" , "파일명" , "파라미터
       List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
       jf.setReportType(reportType);
       // SubReport 파일명 목록을 전달
       // 레포트 수행시 compile을 상황에 따라 수행함.
       jf.setSubReportFiles(subReportFileNames);
       
       // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
       //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
       //param construct
       
       // Primary data source
       
      
       String accntDivCode = ObjUtils.getSafeString(param.get("ACCNT_DIV_CODE"));
       if(accntDivCode != null){
       	String[] arry = accntDivCode.split(",");
       	param.put("ACCNT_DIV_CODE" , arry);
       }
       
       String accntDivName = ObjUtils.getSafeString(param.get("ACCNT_DIV_NAME"));
       if(accntDivName != null){
       	String[] arry1 = accntDivName.split(",");
       	param.put("ACCNT_DIV_NAME" , arry1);
       }
       

       if (param.get("FR_DATE")!=null)
       {
	        
	        jf.addParam("SLIP_DATE", param.get("FR_DATE").toString().substring(0, 4)
			          +"."+param.get("FR_DATE").toString().substring(4, 6)
			          +"."+param.get("FR_DATE").toString().substring(6, 8)+"~"
			          +param.get("TO_DATE").toString().substring(0, 4)
			          +"."+param.get("TO_DATE").toString().substring(4, 6)
			          +"."+param.get("TO_DATE").toString().substring(6, 8));
       }

       
   	     jflist.addAll(jasperService.selectList("agc100rkrServiceImpl.selectList", param));
   	     param.put("PGM_ID","agc100rkr");
         jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));	

       jf.setList(jflist);

       return ViewHelper.getJasperView(jf);
   }
  /**
   * 현급출납장 출력
   * @param _req
   * @return
   * @throws Exception
   */
 @RequestMapping(value = "/agc/agc110rkrPrint.do", method = RequestMethod.GET)
  public ModelAndView agc110rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
     String[] subReportFileNames = {
    		 "top_Payment"
     };
     // Report와 SQL용 파라미터 구성
      Map<String, Object> param = _req.getParameterMap();
      param.put("S_COMP_CODE", user.getCompCode());
      // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
      // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
      Map gsFrDateMap = (Map) jasperService.getDao().select("agc110rkrServiceImpl.selectFnDate", param);
      if(gsFrDateMap != null){
    	 String frDate = param.get("START_DATE") + ObjUtils.getSafeString(gsFrDateMap.get("STDATE")).substring(4,8);
    	 param.put("FR_DATE",frDate);
    	 
    	 SimpleDateFormat fmt =new SimpleDateFormat("yyyyMMdd");
    	 int date = fmt.parse(frDate).getMonth();
    	 String mNum = ObjUtils.getSafeString(gsFrDateMap.get("STDATE")).substring(4,6);
    	 for(int loop = 0;loop<=11;loop++){
    		 int index = (date + loop)%12+1;
				if(loop < 9){
					if(index<=9){
						param.put("MONTH_0"+(loop+1), "0"+index);
					}else{
						param.put("MONTH_0"+(loop+1), index+"");
					}
				
				}else{
					if(index<=9){
						param.put("MONTH_"+(loop+1), "0"+index);
					}else{
						param.put("MONTH_"+(loop+1), index+"");
					}
					
				}
			}
    	 System.out.println("&&&&"+param.toString());
      }

      Map gsToDateMap = (Map) jasperService.getDao().select("agc110rkrServiceImpl.selectToDate", param);
      if(gsToDateMap != null){
    	 String toDate = ObjUtils.getSafeString(gsToDateMap.get("TODATE")).substring(4,8);
    	 if("12".equals(toDate.substring(0,2))){
    		 toDate = param.get("START_DATE") + toDate;
    	 }else{
    		 toDate = (Integer.parseInt( ObjUtils.getSafeString(param.get("START_DATE")))+1) + toDate;
    	 }
    	 param.put("TO_DATE",toDate);
      }
      
      Map msgMap = (Map) jasperService.getDao().select("agc110rkrServiceImpl.selectMsg", param);
      if(msgMap != null){
    	 String msgStr = ObjUtils.getSafeString(msgMap.get("MSG_DESC"));
    	 param.put("MSG_DESC",msgStr);
      }
      
      JasperFactory jf = jasperService.createJasperFactory("agc110rkr", "agc110rkr",  param);   // "폴더명" , "파일명" , "파라미터
      List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
      jf.setReportType(reportType);
      // SubReport 파일명 목록을 전달
      // 레포트 수행시 compile을 상황에 따라 수행함.
      jf.setSubReportFiles(subReportFileNames);
     
      String accntDivCode = ObjUtils.getSafeString(param.get("ACCNT_DIV_CODE"));
      if(accntDivCode != null){
      	String[] arry = accntDivCode.split(",");
      	param.put("ACCNT_DIV_CODE" , arry);
      }
      
      
  	  jflist.addAll(jasperService.selectList("agc110rkrServiceImpl.selectListToPrint", param));
     
      jf.setList(jflist);
      param.put("PGM_ID","agc110rkr");
      jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));	

      return ViewHelper.getJasperView(jf);
  }
 
	/**
	 * add by Chen.Rd
	 * 
	 * @param _req
	 * @param user
	 * @param request
	 * @param reportType
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/agc/agc150rkrPrint.do", method = RequestMethod.GET)
	public ModelAndView agc150rkrPrint(
			ExtHtttprequestParam _req,
			LoginVO user,
			HttpServletRequest request,
			@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType)
			throws Exception {
		String[] subReportFileNames = {"top_Payment"};
		// Report와 SQL용 파라미터 구성
		Map<String, Object> param = _req.getParameterMap();
		param.put("S_COMP_CODE", user.getCompCode());
		// Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
		// 기본 경로 체계가 아닌 경우 File 전달 방식을 이용
		

		JasperFactory jf = jasperService.createJasperFactory("agc150rkr", param); // "폴더명" , "파일명" ,
															// "파라미터
		List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
		jf.setReportType(reportType);
		// SubReport 파일명 목록을 전달
		// 레포트 수행시 compile을 상황에 따라 수행함.
		jf.setSubReportFiles(subReportFileNames);
		
		Map map = new HashMap<String, Object>();
		map.put("S_CONP_CODE", user.getCompCode());
		String dcString = "";
		for (int i = 1; i < 7; i++) {
			String accntDivCode = ObjUtils.getSafeString(param.get("DIV_CODE" + i));
			if (accntDivCode != null && !accntDivCode.equals("")) {
				dcString += (dcString.length() > 0 ? "," + accntDivCode : accntDivCode);
				String[] arry = accntDivCode.split(",");
				param.put("DIV_CODE" + i, arry);
				map.put("DIV_CODE", arry[0]);
				jf.addParam("DIV_NAME_0"+i, bor120ukrvService.selectByDivCodeAndCompCode(map).get(0).get("DIV_NAME")+(arry.length>1?" 외 "+ (arry.length-1) + "개 사업장":""));
			}
		}
		String[] arry = dcString.split(",");
		param.put("DIV_CODE", arry);
		
//		if(agc150skrService.existTableAGB100T()>0)
//			agc150skrService.dropTempTableAGB100T();
//		agc150skrService.createTableAGB100T(param);
		switch (param.get("ACCOUNT_NAME").toString()) {
		case "1":
			param.put("ACCNT_NAME", "ACCNT_NAME");
			param.put("AC_FULL_NAME", "AC_FULL_NAME");
			break;
		case "2":
			param.put("ACCNT_NAME", "ACCNT_NAME2");
			param.put("AC_FULL_NAME", "ACCNT_NAME2");
			break;
		case "3":
			param.put("ACCNT_NAME", "ACCNT_NAME3");
			param.put("AC_FULL_NAME", "ACCNT_NAME3");
			break;
		default:
			param.put("ACCNT_NAME", "ACCNT_NAME");
			param.put("AC_FULL_NAME", "AC_FULL_NAME");
			break;
		}

		jf.addParam("AC_DATE", param.get("DATE_FR").toString().substring(0, 4)
				+"."+param.get("DATE_FR").toString().substring(4, 6)
				+"."+param.get("DATE_FR").toString().substring(6)
				+"~"+param.get("DATE_TO").toString().substring(0, 4)
				+"."+param.get("DATE_TO").toString().substring(4, 6)
				+"."+param.get("DATE_TO").toString().substring(6));
		jf.setList(jflist);
		switch (param.get("DIVI").toString()) {
		case "10":
			param.put("PGM_ID", "agc150rkr10");
			jflist.addAll(getRateValueList1(jasperService.selectList("agc150rkrService.selectDetailList1", param)));
			jf.addParam("DEFUAL_TITLE", 1);
			break;
		case "20":
			param.put("PGM_ID", "agc150rkr20");
			jflist.addAll(getRateValueList2(jasperService.selectList("agc150rkrService.selectDetailList2", param)));
			jf.addParam("DEFUAL_TITLE", 2);
			break;
		case "30":
			param.put("PGM_ID", "agc150rkr30");
			jflist.addAll(getRateValueList3(jasperService.selectList("agc150rkrService.selectDetailList2", param)));
			jf.addParam("DEFUAL_TITLE", 3);
			break;
		default:
			param.put("PGM_ID", "agc150rkr10");
			jflist.addAll(getRateValueList1(jasperService.selectList("agc150rkrService.selectDetailList1", param)));
			jf.addParam("DEFUAL_TITLE", 1);
			break;
		}
		List<Map<String, Object>>  initList = jasperService.selectList("commonReportServiceImpl.fnInit", param);
		for(Map<String, Object> item:initList){
			for (Map.Entry<String, Object> entry : item.entrySet()){
				if(entry.getValue().equals("Y"))
					jf.addParam(entry.getKey(), true);
				else if(entry.getValue().equals("N"))
					jf.addParam(entry.getKey(), true);
				else
					jf.addParam(entry.getKey(), entry.getValue());
			}
		}
		List<Map<String, Object>> amtUnit = jasperService.selectList("agc150rkrService.selectAmtUnit", param);
		jf.addParam("AMT_UNIT", amtUnit.isEmpty()?"":amtUnit.get(0).get("CODE_NAME"));
		jf.addSubDS("DS_SUB01", initList);

		return ViewHelper.getJasperView(jf);
	}
 
	@SuppressWarnings( { "unchecked", "rawtypes" } )
    private List<Map<String, Object>> getRateValueList1(List<Map<String, Object>> list){
		double[] rate1999 = {0,0,0,0,0,0};
		double[] rate5000 = {0,0,0,0,0,0};
		for(Map item:list){
			if(item.get("ACCNT_CD").equals("1999")){
				rate1999[0] = Double.valueOf(item.get("AMT_I1").toString());
				rate1999[1] = Double.valueOf(item.get("AMT_I2").toString());
				rate1999[2] = Double.valueOf(item.get("AMT_I3").toString());
				rate1999[3] = Double.valueOf(item.get("AMT_I4").toString());
				rate1999[4] = Double.valueOf(item.get("AMT_I5").toString());
				rate1999[5] = Double.valueOf(item.get("AMT_I6").toString());
			}
			if(item.get("ACCNT_CD").equals("5000")){
				rate5000[0] = Double.valueOf(item.get("AMT_I1").toString());
				rate5000[1] = Double.valueOf(item.get("AMT_I2").toString());
				rate5000[2] = Double.valueOf(item.get("AMT_I3").toString());
				rate5000[3] = Double.valueOf(item.get("AMT_I4").toString());
				rate5000[4] = Double.valueOf(item.get("AMT_I5").toString());
				rate5000[5] = Double.valueOf(item.get("AMT_I6").toString());
			}
		}
		for(Map item:list){
			int accnt_cd = Integer.valueOf(item.get("ACCNT_CD").toString());
			if(accnt_cd <= 2000){
				for(int i=1;i<7;i++){
					if(rate1999[i-1]!=0)
						item.put("RATE_"+i, new BigDecimal( ( Double.valueOf(item.get("AMT_I"+i).toString()) ) / rate1999[i-1]*100).setScale(2, BigDecimal.ROUND_HALF_UP));
					else{
						item.put("RATE_"+i, BigDecimal.ZERO);
					}
				}
					
			}else {
				for(int i=1;i<7;i++){
					if(rate5000[i-1]!=0)
						item.put("RATE_"+i, new BigDecimal( ( Double.valueOf(item.get("AMT_I"+i).toString()) ) / rate5000[i-1]*100).setScale(2, BigDecimal.ROUND_HALF_UP));
					else{
						item.put("RATE_"+i, BigDecimal.ZERO);
					}
				}
			}
		}
		return list;
	}
	
	@SuppressWarnings( { "unchecked", "rawtypes" } )
	private List<Map<String, Object>> getRateValueList2(List<Map<String, Object>> list){
		double[] rate1000 = {0,0,0,0,0,0};
		for(Map item:list){
			if(item.get("ACCNT_CD").equals("1000")){
				rate1000[0] = Double.valueOf(item.get("AMT_I1").toString());
				rate1000[1] = Double.valueOf(item.get("AMT_I2").toString());
				rate1000[2] = Double.valueOf(item.get("AMT_I3").toString());
				rate1000[3] = Double.valueOf(item.get("AMT_I4").toString());
				rate1000[4] = Double.valueOf(item.get("AMT_I5").toString());
				rate1000[5] = Double.valueOf(item.get("AMT_I6").toString());
			}
		}
		for(Map item:list){
			for(int i=1;i<7;i++){
				if(rate1000[i-1]!=0)
					item.put("RATE_"+i, new BigDecimal( ( Double.valueOf(item.get("AMT_I"+i).toString()) ) / rate1000[i-1]*100).setScale(2, BigDecimal.ROUND_HALF_UP));
				else{
					item.put("RATE_"+i, BigDecimal.ZERO);
				}
			}
		}
		return list;
	}
	@SuppressWarnings( { "unchecked", "rawtypes" } )
	
	private List<Map<String, Object>> getRateValueList3(List<Map<String, Object>> list){
		double[] rate7000 = {0,0,0,0,0,0};
		for(Map item:list){
			if(item.get("ACCNT_CD").equals("7000")){
				rate7000[0] = Double.valueOf(item.get("AMT_I1").toString());
				rate7000[1] = Double.valueOf(item.get("AMT_I2").toString());
				rate7000[2] = Double.valueOf(item.get("AMT_I3").toString());
				rate7000[3] = Double.valueOf(item.get("AMT_I4").toString());
				rate7000[4] = Double.valueOf(item.get("AMT_I5").toString());
				rate7000[5] = Double.valueOf(item.get("AMT_I6").toString());
			}
		}
		for(Map item:list){
			for(int i=1;i<7;i++){
				if(rate7000[i-1]!=0)
					item.put("RATE_"+i, new BigDecimal( ( Double.valueOf(item.get("AMT_I"+i).toString()) ) / rate7000[i-1]*100).setScale(2, BigDecimal.ROUND_HALF_UP));
				else{
					item.put("RATE_"+i, BigDecimal.ZERO);
				}
			}
		}
		return list;
	}
 
   /**
    * 현급출납장 출력
    * @param _req
    * @return
    * @throws Exception
    */
  @RequestMapping(value = "/agc/agc170rkrPrint.do", method = RequestMethod.GET)
   public ModelAndView agc170rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
      String[] subReportFileNames = {
    		  "top_Payment"
      };
      
      // Report와 SQL용 파라미터 구성
       Map param = _req.getParameterMap();
       param.put("S_COMP_CODE", user.getCompCode());
       // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
       // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
       String fileName = "";
       String rtype = param.get("TYPE").toString();
       fileName="agc170rkr";
       JasperFactory jf = jasperService.createJasperFactory("agc170rkr", fileName,  param);   // "폴더명" , "파일명" , "파라미터
       List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();
       jf.setReportType(reportType);
       // SubReport 파일명 목록을 전달
       // 레포트 수행시 compile을 상황에 따라 수행함.
       jf.setSubReportFiles(subReportFileNames);
       
       // 도장 파일(일반 design용 이미지 경로는 config 파일에 따름)           
       //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
       //param construct
       
       // Primary data source
       
       param.put("DIVI", rtype);
       CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
       jf.addParam("TITLE", codeInfo.getCodeInfo("A054", rtype).getCodeName());
//       jf.addParam("DIV_NAME", user.getDivName());
       
       if (param.get("DIV_CODE")!=null){
	        Map divi = (Map) jasperService.getDao().select("bor120ukrvServiceImpl.selectList", param);
	        jf.addParam("DIV_NAME", divi.get("DIV_NAME"));
       }
       jf.addParam("START_DATE", param.get("START_DATE"));
       jf.addParam("COMP_NAME", user.getCompName());
       jf.addParam("AMT_UNIT", codeInfo.getCodeInfo("B042", param.get("AMT_UNIT").toString()).getCodeName());
       jf.addParam("TYPE", param.get("TYPE"));

       String strQuery="";
       switch (rtype){
       	case "20":
       		strQuery= "agc170skrService.selectList1";
       	break;
       
       	case "30":
       		strQuery= "agc170skrService.selectList2";
       	break;
       	
       }
   	jflist.addAll(jasperService.selectList(strQuery, param));
       jf.addSubDS("DS_SUB01", jasperService.selectList("commonReportServiceImpl.fnInit", param));	
      
       jf.setList(jflist);

       return ViewHelper.getJasperView(jf);
   }
    
}
