package foren.unilite.modules.human.hpa;

import java.io.File;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
 
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.crystalreport.CrystalReportDoc;
import foren.framework.web.crystalreport.CrystalReportFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class HpaCrystalReportController  extends UniliteCommonController {
  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

  final static String            RPT_PATH           = "/WEB-INF/Reports2011/Human";

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;

  @Resource(name = "hpa900rkrService")
  protected Hpa900rkrServiceImpl hpa900rkrService;

  /**
   * 사원명부(성남도시개발공사)
   * @param _req
   * @param user
   * @param reportType
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
    @RequestMapping(value = "/human/hpa900crkr.do", method = RequestMethod.GET)
    public ModelAndView hpa900crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
       CrystalReportDoc cDoc = new CrystalReportDoc();
       CrystalReportFactory clientDoc = null;

       Map param = _req.getParameterMap();
       
       ReportUtils.setCreportPram(user, param,dao);
	   ReportUtils.setCreportSanctionParam(param, dao);
       
       Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
       String sql="";

       /*dao.update("hpa900rkrServiceImpl.createTable", param);

       Map wagesMap = new HashMap();

	   List<Map> wList1 = (List<Map>) dao.list("hpa900rkrServiceImpl.selectWages1", param);

		for(Map wCode : wList1) {

			wCode.put("SEQ",      wCode.get("SEQ"));
			wCode.put("SUB_CODE", wCode.get("SUB_CODE"));
			wCode.put("CODE_NAME", wCode.get("CODE_NAME"));

      		dao.insert("hpa900rkrServiceImpl.insertWages1", wCode);

		 }

		List<Map> wList2 = (List<Map>) dao.list("hpa900rkrServiceImpl.selectWages2", param);

		for(Map wCode : wList2) {

			wCode.put("SEQ",      wCode.get("SEQ"));
			wCode.put("SUB_CODE", wCode.get("SUB_CODE"));
			wCode.put("CODE_NAME", wCode.get("CODE_NAME"));

      		dao.insert("hpa900rkrServiceImpl.insertWages2", wCode);

		 }

		List<Map> wList3 = (List<Map>) dao.list("hpa900rkrServiceImpl.selectWages3", param);

		for(Map wCode : wList3) {

			wCode.put("SEQ",      wCode.get("SEQ"));
			wCode.put("WAGES_CODE", wCode.get("WAGES_CODE"));
			wCode.put("WAGES_NAME", wCode.get("WAGES_NAME"));
			wCode.put("WAGES_SEQ", wCode.get("WAGES_SEQ"));

      		dao.insert("hpa900rkrServiceImpl.insertWages3", wCode);

		 }
	   */
       try{
    	   //급여명세서
    	   if(param.get("DOC_KIND").equals("5")){
    		   sql = dao.mappedSqlString("hpa900rkrServiceImpl.selectListPrint1356", param);
    	   //급여명세서(1/2)
    	   }if(param.get("DOC_KIND").equals("6")){
    		   sql = dao.mappedSqlString("hpa900rkrServiceImpl.selectListPrint1356", param);
    	   //부서별지급대장
    	   }if(param.get("DOC_KIND").equals("1")){
    		   sql = dao.mappedSqlString("hpa900rkrServiceImpl.selectListPrint1356", param);
    	   //부서별집계표
    	   }if(param.get("DOC_KIND").equals("2")){
    		   sql = dao.mappedSqlString("hpa900rkrServiceImpl.selectListPrint2", param);
    	   //사업장별지급대장1
    	   }if(param.get("DOC_KIND").equals("3")){
    		   sql = dao.mappedSqlString("hpa900rkrServiceImpl.selectListPrint1356", param);
    	   //사업장별지급대장2
    	   }if(param.get("DOC_KIND").equals("4")){
    		   sql = dao.mappedSqlString("hpa900rkrServiceImpl.selectListPrint4", param);
    	   }
    	  




    	   if(param.get("DOC_KIND").equals("5")){

    		   if(param.get("GUNTAE").equals("Y")){
    			   List subReports = new ArrayList();

                   Map<String, String> subMap = new HashMap<String, String>();
                   subMap.put("NAME", "hpa910kr_sub.rpt");
                   subMap.put("SQL", dao.mappedSqlString("hpa900rkrServiceImpl.selectSubListPrint12356", param));
                   subReports.add(subMap);

                   clientDoc = cDoc.generateReport(RPT_PATH+"/hpa910kr", "hpa910kr", param,  sql ,subReports, request);

    		   } else {
    			   List subReports = new ArrayList();

                   Map<String, String> subMap = new HashMap<String, String>();
                   subMap.put("NAME", "hpa913kr_sub.rpt");
                   subMap.put("SQL", dao.mappedSqlString("hpa900rkrServiceImpl.selectSubListPrint12356", param));
                   subReports.add(subMap);

                   clientDoc = cDoc.generateReport(RPT_PATH+"/hpa913kr", "hpa913kr", param,  sql ,subReports, request);
    		   }


           } if(param.get("DOC_KIND").equals("6")){

    		   if(param.get("GUNTAE").equals("Y")){
    			   List subReports = new ArrayList();

                   Map<String, String> subMap = new HashMap<String, String>();
                   subMap.put("NAME", "hpa912kr_sub.rpt");
                   subMap.put("SQL", dao.mappedSqlString("hpa900rkrServiceImpl.selectSubListPrint12356", param));
                   subReports.add(subMap);

                   clientDoc = cDoc.generateReport(RPT_PATH+"/hpa912kr", "hpa912kr", param,  sql ,subReports, request);

    		   } else {
    			   List subReports = new ArrayList();

                   Map<String, String> subMap = new HashMap<String, String>();
                   subMap.put("NAME", "hpa914kr_sub.rpt");
                   subMap.put("SQL", dao.mappedSqlString("hpa900rkrServiceImpl.selectSubListPrint12356", param));
                   subReports.add(subMap);

                   clientDoc = cDoc.generateReport(RPT_PATH+"/hpa914kr", "hpa914kr", param,  sql ,subReports, request);
    		   }


           } if(param.get("DOC_KIND").equals("1")){
        	   
        	   
        	   List subReports = new ArrayList();

               Map<String, String> subMap = new HashMap<String, String>();
               subMap.put("NAME", "hpa900az_sub.rpt");
               subMap.put("SQL", dao.mappedSqlString("hpa900rkrServiceImpl.selectSubListPrint12356", param));
               subReports.add(subMap);
               
               Map<String, String> subMap2 = new HashMap<String, String>();
               subMap2.put("NAME", "san_top_sub.rpt");
               subMap2.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
 	           subReports.add(subMap2);

               clientDoc = cDoc.generateReport(RPT_PATH+"/hpa900kr", "hpa900kr", param,  sql ,subReports, request);
        	   

           } if(param.get("DOC_KIND").equals("2")){
        	   
        	   
        	   List subReports = new ArrayList();

               Map<String, String> subMap = new HashMap<String, String>();
               subMap.put("NAME", "hpa900az_sub.rpt");
               subMap.put("SQL", dao.mappedSqlString("hpa900rkrServiceImpl.selectSubListPrint12356", param));
               subReports.add(subMap);
               
               Map<String, String> subMap2 = new HashMap<String, String>();
               subMap2.put("NAME", "san_top_sub.rpt");
               subMap2.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
 	           subReports.add(subMap2);

               clientDoc = cDoc.generateReport(RPT_PATH+"/hpa901kr", "hpa901kr", param,  sql ,subReports, request);
        	   

           } if(param.get("DOC_KIND").equals("3")){
        	   
        	   
        	   List subReports = new ArrayList();

               Map<String, String> subMap = new HashMap<String, String>();
               subMap.put("NAME", "hpa900az_sub.rpt");
               subMap.put("SQL", dao.mappedSqlString("hpa900rkrServiceImpl.selectSubListPrint12356", param));
               subReports.add(subMap);
               
               Map<String, String> subMap2 = new HashMap<String, String>();
               subMap2.put("NAME", "san_top_sub.rpt");
               subMap2.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
 	           subReports.add(subMap2);
        	   
               /*Map<String, String> subMap = new HashMap<String, String>();
               subMap.put("NAME", "san_top_sub.rpt");
               subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
 	           subReports.add(subMap);*/

               clientDoc = cDoc.generateReport(RPT_PATH+"/hpa903kr", "hpa903kr", param,  sql ,subReports, request);
        	   

           }if(param.get("DOC_KIND").equals("4")){
        	   
        	   
        	   List subReports = new ArrayList();

               Map<String, String> subMap = new HashMap<String, String>();
               subMap.put("NAME", "hpa900az_sub.rpt");
               subMap.put("SQL", dao.mappedSqlString("hpa900rkrServiceImpl.selectSubListPrint4", param));
               subReports.add(subMap);
               
               Map<String, String> subMap2 = new HashMap<String, String>();
               subMap2.put("NAME", "san_top_sub.rpt");
               subMap2.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
 	           subReports.add(subMap2);

               clientDoc = cDoc.generateReport(RPT_PATH+"/hpa904kr", "hpa904kr", param,  sql ,subReports, request);
           }

       }catch (Throwable e2) {
             logger.debug("   >>>>>>>  queryId : hpa900rkrServiceImpl.selectSubListPrint12356 " + sql);
             e2.getStackTrace();
       }
       clientDoc.setReportType(reportType);

       return ViewHelper.getCrystalReportView(clientDoc);
    }

    /**
     * 입금의뢰서 출력
     * @param _req
     * @param user
     * @param reportType
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/human/hpa980rkrPrint.do", method = RequestMethod.GET)
    public ModelAndView hpa980rkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
       CrystalReportDoc cDoc = new CrystalReportDoc();
       CrystalReportFactory clientDoc = null;

       Map param = _req.getParameterMap();
       param.put("COMP_CODE", user.getCompCode());

       Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
       String sql="";
       String deptCodes =  (String) param.get("DEPT_CODES");
	   	if(param.get("DEPT_CODES")!=null){
			String[] depts = deptCodes.toString().split(",");

			param.put("DEPT_CODE", depts);
		}
     //레포트 제목 출력 관련
       if(ObjUtils.isEmpty(param.get("PT_TITLENAME"))){
           param.put("PT_TITLENAME", "");
       }
       //레포트 회사명 출력 관련
       if(ObjUtils.isEmpty(user.getCompName())){
           param.put("S_COMP_NAME", "");
       }else{
           param.put("S_COMP_NAME", user.getCompName());
       }
       //레포트 출력일 출력 관련
       Date nDate = new Date();
       String sDate = "";
       SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
       sDate = sdf.format(nDate);

       if(ObjUtils.isEmpty(param.get("PT_OUTPUTDATE"))){
           param.put("PT_OUTPUTDATE", sDate);
       }



       try{

    	   // 직원 사진용 경로를 전달(일반 design용 이미지 경로는 config 파일에 따름)
           String imagePath = "C:" + ConfigUtil.getUploadBasePath("") + File.separator;
           String gbn = "";
           File directory = new File(imagePath);
           if (!directory.exists()) {
               directory.mkdirs();
           }
           param.put("HUMAN_IMAGE_PATH", imagePath);
           gbn = (String) param.get("GBN");
           logger.debug("[[rptParam]]" + param);
           if(gbn.equals("1")){

        	   sql = dao.mappedSqlString("hpa980rkrServiceImpl.selectPrimaryDataList", param);

	           List subReports = new ArrayList();
	           Map<String, String> subMap = new HashMap<String, String>();
	           subMap.put("NAME", "hpa980rkr_sub01");
	           subMap.put("SQL", dao.mappedSqlString("hpa980rkrServiceImpl.ds_sub01", param));
	           subReports.add(subMap);

	           clientDoc = cDoc.generateReport(RPT_PATH+"/hpa980rkr", "hpa980rkr", param,  sql ,subReports, request);

           }else{

        	   sql = dao.mappedSqlString("hpa980rkrServiceImpl.selectPrimaryDataList2", param);
        	   clientDoc = cDoc.generateReport(RPT_PATH+"/hpa981rkr", "hpa981rkr", param,  sql ,null, request);

           }


       }catch (Throwable e2) {
             logger.debug("   >>>>>>>  queryId : hpa980rkrServiceImpl.selectPrimaryDataList " + sql);
             e2.getStackTrace();

       }
       clientDoc.setPrintFileName("hpa980rkr");
       clientDoc.setReportType(reportType);

       return ViewHelper.getCrystalReportView(clientDoc);
    }
    
    
    
    
    /**
     * 년월차지급조서 출력
     * @param _req
     * @param user
     * @param reportType
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
      @RequestMapping(value = "/human/hpa700crkr.do", method = RequestMethod.GET)
      public ModelAndView hpa700crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
         CrystalReportDoc cDoc = new CrystalReportDoc();
         CrystalReportFactory clientDoc = null;

         Map param = _req.getParameterMap();
         
         ReportUtils.setCreportPram(user, param,dao);
  	   	 ReportUtils.setCreportSanctionParam(param, dao);
         
         Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
         String sql="";

         try{
      	   
           //부서별 지급대장
      	   if(param.get("DOC_KIND").equals("1")){
      		   sql = dao.mappedSqlString("hpa700rkrServiceImpl.selectList1", param);
      		   
      		   List subReports = new ArrayList();
      		   
	      	   Map<String, String> subMap = new HashMap<String, String>();
	           subMap.put("NAME", "san_top_sub.rpt");
	           subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
	           subReports.add(subMap);

      		   clientDoc = cDoc.generateReport(RPT_PATH+"/hpa700p1", "hpa700p1", param,  sql ,subReports, request);
      		   
      	   //부서별 집계표
      	   }if(param.get("DOC_KIND").equals("2")){
      		   sql = dao.mappedSqlString("hpa700rkrServiceImpl.selectList2", param);   
      		   
      		   List subReports = new ArrayList();
      		   
      		   Map<String, String> subMap = new HashMap<String, String>();
	           subMap.put("NAME", "san_top_sub.rpt");
	           subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
	           subReports.add(subMap);

    		   clientDoc = cDoc.generateReport(RPT_PATH+"/hpa700p2", "hpa700p2", param,  sql ,subReports, request);
    		   
    	   //명세서
      	   }if(param.get("DOC_KIND").equals("3")){
      		   sql = dao.mappedSqlString("hpa700rkrServiceImpl.selectList3", param);
      		   
      		   List subReports = new ArrayList();
      		   
	      	   Map<String, String> subMap = new HashMap<String, String>();
	           subMap.put("NAME", "hpa710kr_sub.rpt");
	           subMap.put("SQL", dao.mappedSqlString("hpa700rkrServiceImpl.selectList3_sub", param));
	           subReports.add(subMap);
      		   

    		   clientDoc = cDoc.generateReport(RPT_PATH+"/hpa700p3", "hpa700p3", param,  sql ,subReports, request);
      	   }
      	  




         }catch (Throwable e2) {
               logger.debug("   >>>>>>>  queryId : hpa700rkrServiceImpl.selectList " + sql);
               e2.getStackTrace();
         }
         clientDoc.setReportType(reportType);

         return ViewHelper.getCrystalReportView(clientDoc);
      }
    
    
    
}
