package foren.unilite.modules.human.hbs;

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

@Controller
public class HbsCrystalReportController  extends UniliteCommonController {
  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

  final static String            RPT_PATH           = "/WEB-INF/Reports2011/Human";
  public final static String     FILE_TYPE_OF_PHOTO = "employeePhoto";
  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;


  /**
   * 연봉계약서 출력
   * @param _req
   * @param user
   * @param reportType
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/human/hbs700crkrPrint.do", method = RequestMethod.GET)
  public ModelAndView hbs700crkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
     CrystalReportDoc cDoc = new CrystalReportDoc();
     CrystalReportFactory clientDoc = null;

     Map param = _req.getParameterMap();

     Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
     String sql="";

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

         sql = dao.mappedSqlString("hbs700rkrServiceImpl.selectPrimaryDataList", param);


         // 직원 사진용 경로를 전달(일반 design용 이미지 경로는 config 파일에 따름)
         String imagePath = "C:" + ConfigUtil.getUploadBasePath(FILE_TYPE_OF_PHOTO) + File.separator;
         File directory = new File(imagePath);
         if (!directory.exists()) {
             directory.mkdirs();
         }
         param.put("HUMAN_IMAGE_PATH", imagePath);

         List subReports = new ArrayList();
         Map<String, String> subMap = new HashMap<String, String>();
         subMap.put("NAME", "hbs700rkr_sub01");
         subMap.put("SQL", dao.mappedSqlString("hbs700rkrServiceImpl.ds_sub01", param));
         subReports.add(subMap);

 /*     // 직원 사진용 경로를 전달(일반 design용 이미지 경로는 config 파일에 따름)
         String imagePath = "C:" + ConfigUtil.getUploadBasePath(FILE_TYPE_OF_PHOTO) + File.separator;
         File directory = new File(imagePath);
         if (!directory.exists()) {
             directory.mkdirs();
         }
         param.put("HUMAN_IMAGE_PATH", imagePath);

         sql = dao.mappedSqlString("hum963rkrServiceImpl.selectPrimaryDataList", param);

         List subReports = new ArrayList();
         Map<String, String> subMap = new HashMap<String, String>();
         subMap.put("NAME", "hum963rkr_sub1.rpt");
         subMap.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub01", param));
         subReports.add(subMap);

         Map<String, String> subMap2 = new HashMap<String, String>();
         subMap2.put("NAME", "hum963rkr_sub2.rpt");
         subMap2.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub02", param));
         subReports.add(subMap2);

         Map<String, String> subMap3 = new HashMap<String, String>();
         subMap3.put("NAME", "hum963rkr_sub3.rpt");
         subMap3.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub03", param));
         subReports.add(subMap3);

         Map<String, String> subMap4 = new HashMap<String, String>();
         subMap4.put("NAME", "hum963rkr_sub4.rpt");
         subMap4.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub04", param));
         subReports.add(subMap4);

         Map<String, String> subMap5 = new HashMap<String, String>();
         subMap5.put("NAME", "hum963rkr_sub5.rpt");
         subMap5.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub05", param));
         subReports.add(subMap5);

         Map<String, String> subMap6 = new HashMap<String, String>();
         subMap6.put("NAME", "hum963rkr_sub6.rpt");
         subMap6.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub06", param));
         subReports.add(subMap6);

         Map<String, String> subMap7 = new HashMap<String, String>();
         subMap7.put("NAME", "hum963rkr_sub7.rpt");
         subMap7.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub07", param));
         subReports.add(subMap7);

         Map<String, String> subMap8 = new HashMap<String, String>();
         subMap8.put("NAME", "hum963rkr_sub8.rpt");
         subMap8.put("SQL", dao.mappedSqlString("hum963rkrServiceImpl.ds_sub08", param));
         subReports.add(subMap8);
         */
         clientDoc = cDoc.generateReport(RPT_PATH+"/hbs700rkr", "hbs700rkr", param,  sql ,subReports, request);
     }catch (Throwable e2) {
           logger.debug("   >>>>>>>  queryId : hbs700rkrServiceImpl.selectPrimaryDataList " + sql);
           e2.getStackTrace();
     }
     clientDoc.setPrintFileName("hbs700rkr");
     clientDoc.setReportType(reportType);

     return ViewHelper.getCrystalReportView(clientDoc);
  }

}
