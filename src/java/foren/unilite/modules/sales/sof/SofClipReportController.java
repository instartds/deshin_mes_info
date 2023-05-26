package foren.unilite.modules.sales.sof;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
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

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileOutputStream;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.clipsoft.clipreport.export.option.PDFOption;
import com.clipsoft.clipreport.oof.OOFDocument;
import com.clipsoft.clipreport.server.service.ClipReportExport;
import com.ibm.icu.util.Calendar;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.sales.sof.Sof120skrvServiceImpl;


@Controller
public class SofClipReportController  extends UniliteCommonController {

  final static String            CRF_PATH           = "/clipreport4/crf/human/";
  final static String            CRF_PATH2           = "Clipreport4/Sales/";

  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

  @Resource( name = "sof120skrvService" )
  private Sof120skrvServiceImpl sof120skrvService;

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;

  @RequestMapping(value = "/sales/sof120clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
   public ModelAndView sof120clskrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();
	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String crfFile = CRF_PATH2  + ObjUtils.getSafeString(param.get("RPT_ID5"));
	  ReportUtils.clipReportLogoPath(param, dao, request);
	  ReportUtils.clipReportSteampPath(param, dao, request);
	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Report use data
	  List<Map<String, Object>> report_data = sof120skrvService.clipselect(param);

	  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
      Map<String, Object> subReportMap = new HashMap<String ,Object>();
      subReportMap.put("SOF120SKRV2_01", "SQLDS2");
      subReportMap.put("SOF120SKRV2_02", "SQLDS2");
      subReportMap.put("SOF120SKRV2_03", "SQLDS2");
      subReportMap.put("SOF120SKRV2_04", "SQLDS2");
      subReportMap.put("SOF120SKRV2_05", "SQLDS2");

      List<Map<String, Object>> subReport_data = sof120skrvService.clipselectsub(param);
      subReportMap.put("SUB_DATA", subReport_data);
      subReports.add(subReportMap);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
      String resultKey = doc.generateReport(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request);

      Map<String, Object> rMap = new HashMap<String, Object>();
      rMap.put("success", "true");
      rMap.put("resultKey", resultKey);
      return ViewHelper.getJsonView(rMap);
   }

  @RequestMapping(value = "/sales/sof120clskrv_5.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView sof120clskrv_5Print(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();
	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String crfFile = CRF_PATH2  + ObjUtils.getSafeString(param.get("RPT_ID6"));
	  ReportUtils.clipReportLogoPath(param, dao, request);
	  ReportUtils.clipReportSteampPath(param, dao, request);
	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Report use data
	  List<Map<String, Object>> report_data = sof120skrvService.clipselect(param);

	  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
     Map<String, Object> subReportMap = new HashMap<String ,Object>();
     subReportMap.put("SOF120SKRV2_5_01", "SQLDS2");

     List<Map<String, Object>> subReport_data = sof120skrvService.clipselectsub(param);
     subReportMap.put("SUB_DATA", subReport_data);
     subReports.add(subReportMap);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
     String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

     Map<String, Object> rMap = new HashMap<String, Object>();
     rMap.put("success", "true");
     rMap.put("resultKey", resultKey);
     return ViewHelper.getJsonView(rMap);
  }

  /*
   * 거래명세서(수주) FAX 보내기
   */
  @RequestMapping(value = "/sales/sof120clskrv_fax.do", method = {RequestMethod.GET,RequestMethod.POST})
  public void sof120clskrvFax(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

	  ClipReportDoc doc = new ClipReportDoc();
	  ClipReportExport docPdf = new ClipReportExport();
	  Map param = _req.getParameterMap();
	  String filePath = "";
	  String filePath2 = "";
	  String fileName = "";
	  String faxTitle = "";
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  ReportUtils.clipReportLogoPath(param, dao, request);
	  ReportUtils.clipReportSteampPath(param, dao, request);
	  String crfFile = CRF_PATH2  + ObjUtils.getSafeString(param.get("RPT_ID5"));
	  SimpleDateFormat dateFormat;
	  Date today = new Date();
	  dateFormat = new SimpleDateFormat("yyyy-MM-dd");

	  CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
	  CodeDetailVO cdo = null;
	  //pdf가 저장될 경로 가져오기
	  cdo = codeInfo.getCodeInfo("S148", (String) param.get("DEAL_REPORT_TYPE")); //pdf파일 다운 경로 (S148의 refCode3의 값)
	  filePath = cdo.getRefCode3();//pdf파일 다운 경로 (S148의 refCode3의 값)
	  filePath2 =  cdo.getRefCode4();//pdf파일 다운 경로 (S148의 refCode4의 값)
	  faxTitle  = cdo.getCodeName();
	  fileName = dateFormat.format(today) + "_" + cdo.getCodeName() + "_" + user.getUserName();//pdf파일명 형식(시스템날짜_프로그램id_로그인유저명)
	  param.put("FILE_NAME", fileName + ".pdf");//fax보낼 pdf파일명
	  param.put("FAX_TITLE", cdo.getCodeName());//팩스 제목


	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Report use data
	  List<Map<String, Object>> report_data = sof120skrvService.clipselect(param);

	  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
     Map<String, Object> subReportMap = new HashMap<String ,Object>();
     subReportMap.put("SOF120SKRV2_01", "SQLDS2");
     subReportMap.put("SOF120SKRV2_02", "SQLDS2");
     subReportMap.put("SOF120SKRV2_03", "SQLDS2");
     subReportMap.put("SOF120SKRV2_04", "SQLDS2");
     subReportMap.put("SOF120SKRV2_05", "SQLDS2");

     List<Map<String, Object>> subReport_data = sof120skrvService.clipselectsub(param);
     subReportMap.put("SUB_DATA", subReport_data);
     subReports.add(subReportMap);

     //clireport 프로퍼티 경로 가져오기
	 	String propertyPath =  ReportUtils.clipReportPropertyPath(request);
	 	logger.debug(":::::clipReport-Property-Path:::::- " + propertyPath);
	 	logger.debug(":::::param:::::- " + param);
	 	logger.debug(":::::filePath:::::- " + filePath);
	 	logger.debug(":::::fileFullPath:::::- " + filePath + fileName + ".pdf");
	 	logger.debug(":::::fileFullPath2:::::- " + filePath2 + fileName + ".pdf");


	 	//pdf파일 다운을 위한 oof생성
	     OOFDocument oof = doc.createOof(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request );
	    // fileDelete(filePath + fileName + ".pdf");//pdf저장 전 파일 삭제
	     File localFileSave = new File( filePath + fileName + ".pdf" ); //경로와 저장될 pdf 파일명을 입력 (filePath + fileName +".pdf")
	     FileOutputStream fileStream = new FileOutputStream(localFileSave);

	     PDFOption option = null;
	     docPdf.createExportForPDF(request, fileStream, propertyPath, oof, option);
	     fileStream.close();
	     // 시간 출력 포맷
	     SimpleDateFormat fmt = new SimpleDateFormat("HH:mm:ss");
	     Calendar cal = Calendar.getInstance() ;
	     logger.debug(":::::TIME1:::::" + fmt.format(cal.getTime())) ;
	     Thread.sleep(5000);
	     Calendar cal2 = Calendar.getInstance() ;
	     logger.debug(":::::TIME2:::::" + fmt.format(cal2.getTime())) ;
	     FileInputStream fis = new FileInputStream(localFileSave);
	     NtlmPasswordAuthentication auth = new NtlmPasswordAuthentication(null, "administrator", "tlsjwlERP_db2018");
	     //String copyPath = "smb://121.170.176.149/pdf_test/111111111122222223333333333333.pdf";
	     String copyPath = filePath2 + fileName + ".pdf";
   	     SmbFile sDestFile = null;
   	     //sDestFile = new SmbFile("smb://guest@192.168.1.90/pdf_test/"+ fileName + ".pdf");
   	     sDestFile = new SmbFile(copyPath, auth);
   	     SmbFileOutputStream smbfos = new SmbFileOutputStream(sDestFile);

   	    BufferedInputStream bin = new BufferedInputStream(fis);
 	    BufferedOutputStream bout = new BufferedOutputStream(smbfos);

   	   /*  int data = 0;
	     while((data = fis.read()) != -1) {
	    	 smbfos.write(data);
	     }*/

 	     int data = 0;
 	     byte[] buffer = new byte[1024];
	     while((data = bin.read(buffer, 0, 1024)) != -1) {
	    	 bout.write(buffer, 0, data);
	     }

	     bout.close();
	     bin.close();

	     fis.close();
	     smbfos.close();

	     Thread.sleep(8000);
	     sof120skrvService.insertFax(param);


  }

  /*
   * 택배비명세서(수주) FAX 보내기
   */
  @RequestMapping(value = "/sales/sof120clskrv_5_fax.do", method = {RequestMethod.GET,RequestMethod.POST})
  public void sof120clskrv_5_Fax(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();
	  ClipReportExport docPdf = new ClipReportExport();
	  Map param = _req.getParameterMap();
	  String crfFile = CRF_PATH2+"sof120clskrv_5.crf";
	  String filePath = "";
	  String fileName = "";
	  String faxTitle = "";

	  SimpleDateFormat dateFormat;
	  Date today = new Date();
	  dateFormat = new SimpleDateFormat("yyyy-MM-dd");

	  CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
	  CodeDetailVO cdo = null;
	  //pdf가 저장될 경로 가져오기
	  cdo = codeInfo.getCodeInfo("S148", (String) param.get("DEAL_REPORT_TYPE")); //pdf파일 다운 경로 (S148의 refCode3의 값)
	  filePath = cdo.getRefCode3();//pdf파일 다운 경로 (S148의 refCode3의 값)
	  filePath = filePath + "\\";
	  faxTitle  = cdo.getCodeName();
	  fileName = dateFormat.format(today) + "_" + cdo.getCodeName() + "_" + user.getUserID();//pdf파일명 형식(시스템날짜_프로그램id_로그인유저id)
	  param.put("FILE_NAME", fileName + ".pdf");//fax보낼 pdf파일명
	  param.put("FAX_TITLE", cdo.getCodeName());//팩스 제목

	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Report use data
	  List<Map<String, Object>> report_data = sof120skrvService.clipselect(param);

	  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
      Map<String, Object> subReportMap = new HashMap<String ,Object>();
      subReportMap.put("SOF120SKRV2_5_01", "SQLDS2");

      List<Map<String, Object>> subReport_data = sof120skrvService.clipselectsub(param);
      subReportMap.put("SUB_DATA", subReport_data);
      subReports.add(subReportMap);

     //clireport 프로퍼티 경로 가져오기
	 	String propertyPath =  ReportUtils.clipReportPropertyPath(request);
	 	System.out.println(":::::clipReport-Property-Path:::::- " + propertyPath);
	 	System.out.println(":::::param:::::- " + param);

	 	//pdf파일 다운을 위한 oof생성
	     OOFDocument oof = doc.createOof(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request );
	     fileDelete(filePath + fileName + ".pdf");//pdf저장 전 파일 삭제
	     File localFileSave = new File( filePath + fileName + ".pdf" ); //경로와 저장될 pdf 파일명을 입력 (filePath + fileName +".pdf")
	     FileOutputStream fileStream = new FileOutputStream(localFileSave);

	     PDFOption option = null;
	     docPdf.createExportForPDF(request, fileStream, propertyPath, oof, option);
	     sof120skrvService.insertFax(param);
  }

  /*
   * 거래명세서(수주) E-MAIL 보내기
   */
  @RequestMapping(value = "/sales/sof120clskrv_email.do", method = {RequestMethod.GET,RequestMethod.POST})
  public void sof120clskrvEmail(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();
	  ClipReportExport docPdf = new ClipReportExport();
	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  ReportUtils.clipReportLogoPath(param, dao, request);
	  ReportUtils.clipReportSteampPath(param, dao, request);
	  String crfFile = CRF_PATH2  + ObjUtils.getSafeString(param.get("RPT_ID5"));
	  String filePath = "";
	  String filePath2 = "";
	  String fileName = "";
	  String faxTitle = "";

	  SimpleDateFormat dateFormat;
	  Date today = new Date();
	  dateFormat = new SimpleDateFormat("yyyy-MM-dd");

	  CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
	  CodeDetailVO cdo = null;
	  //pdf가 저장될 경로 가져오기
	  cdo = codeInfo.getCodeInfo("S148",(String) param.get("DEAL_REPORT_TYPE")); //pdf파일 다운 경로 (S148의 refCode3의 값)
	  filePath = cdo.getRefCode3();//pdf파일 다운 경로 (S148의 refCode3의 값)
	  filePath2 =  cdo.getRefCode4();//pdf파일 다운 경로 (S148의 refCode4의 값)
	  faxTitle  = cdo.getCodeName();
	  fileName = dateFormat.format(today) + "_" + cdo.getCodeName() + "_" + user.getUserName();//pdf파일명 형식(시스템날짜_프로그램id_로그인유저id)
	  param.put("FILE_NAME", fileName + ".pdf");//fax보낼 pdf파일명
	  param.put("FAX_TITLE", cdo.getCodeName());//팩스 제목

	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Report use data
	  List<Map<String, Object>> report_data = sof120skrvService.clipselect(param);

	  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
     Map<String, Object> subReportMap = new HashMap<String ,Object>();
     subReportMap.put("SOF120SKRV2_01", "SQLDS2");
     subReportMap.put("SOF120SKRV2_02", "SQLDS2");
     subReportMap.put("SOF120SKRV2_03", "SQLDS2");
     subReportMap.put("SOF120SKRV2_04", "SQLDS2");
     subReportMap.put("SOF120SKRV2_05", "SQLDS2");

     List<Map<String, Object>> subReport_data = sof120skrvService.clipselectsub(param);
     subReportMap.put("SUB_DATA", subReport_data);
     subReports.add(subReportMap);

     //clireport 프로퍼티 경로 가져오기
	 	String propertyPath =  ReportUtils.clipReportPropertyPath(request);
	 	logger.debug(":::::clipReport-Property-Path:::::- " + propertyPath);
	 	logger.debug(":::::param:::::- " + param);
	 	logger.debug(":::::filePath:::::- " + filePath);
	 	logger.debug(":::::fileFullPath:::::- " + filePath + fileName + ".pdf");

	 	//pdf파일 다운을 위한 oof생성
	     OOFDocument oof = doc.createOof(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request );
	     fileDelete(filePath + fileName + ".pdf");//pdf저장 전 파일 삭제
	     File localFileSave = new File( filePath + fileName + ".pdf" ); //경로와 저장될 pdf 파일명을 입력 (filePath + fileName +".pdf")
	     logger.debug(":::::fileFullPath2:::::- " + filePath2 + fileName + ".pdf");
	     FileOutputStream fileStream = new FileOutputStream(localFileSave);


	     PDFOption option = null;
	     docPdf.createExportForPDF(request, fileStream, propertyPath, oof, option);
	     fileStream.close();
	     Thread.sleep(8000);
	     // 시간 출력 포맷
	    /* SimpleDateFormat fmt = new SimpleDateFormat("HH:mm:ss");
	     Calendar cal = Calendar.getInstance() ;
	     logger.debug(":::::TIME1:::::" + fmt.format(cal.getTime())) ;
	     Thread.sleep(8000);
	     Calendar cal2 = Calendar.getInstance() ;
	     logger.debug(":::::TIME2:::::" + fmt.format(cal2.getTime())) ;
	     FileInputStream fis = new FileInputStream(localFileSave);
	     NtlmPasswordAuthentication auth = new NtlmPasswordAuthentication(null, "administrator", "5#qnfrhrl~!");
	     //String copyPath = "smb://121.170.176.149/pdf_test/111111111122222223333333333333.pdf";
	     String copyPath = filePath2 + fileName + ".pdf";

	     try {

	   	     SmbFile sDestFile = null;
	   	     //sDestFile = new SmbFile("smb://guest@192.168.1.90/pdf_test/"+ fileName + ".pdf");
	   	     sDestFile = new SmbFile(copyPath, auth);
	   	     SmbFileOutputStream smbfos = new SmbFileOutputStream(sDestFile);

	   	  int data = 0;

		     while((data=fis.read())!=-1) {

		    	 smbfos.write(data);

		     }
		     fis.close();
		     smbfos.close();

	     } catch (Exception e) {

	    	 e.printStackTrace();

	     }*/


	     param.put("FILE_INFO", filePath + fileName + ".pdf");
	     //생성한 pdf파일(첨부)과 화면에서 입력한 내용들로 메일 전송
	     sof120skrvService.sendMail(param, user);
  }

  /*
   * 택배비명세서(수주) E-MAIL 보내기
   */
  @RequestMapping(value = "/sales/sof120clskrv_5_email.do", method = {RequestMethod.GET,RequestMethod.POST})
  public void sof120clskrv_5_Email(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();
	  ClipReportExport docPdf = new ClipReportExport();
	  Map param = _req.getParameterMap();
	  String crfFile = CRF_PATH2+"sof120clskrv_5.crf";
	  String filePath = "";
	  String fileName = "";
	  String faxTitle = "";

	  SimpleDateFormat dateFormat;
	  Date today = new Date();
	  dateFormat = new SimpleDateFormat("yyyy-MM-dd");

	  CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
	  CodeDetailVO cdo = null;
	  //pdf가 저장될 경로 가져오기
	  cdo = codeInfo.getCodeInfo("S148", (String) param.get("DEAL_REPORT_TYPE")); //pdf파일 다운 경로 (S148의 refCode3의 값)
	  filePath = cdo.getRefCode3();//pdf파일 다운 경로 (S148의 refCode3의 값)
	  filePath = filePath + "\\";
	  faxTitle  = cdo.getCodeName();
	  fileName = dateFormat.format(today) + "_" + cdo.getCodeName() + "_" + user.getUserID();//pdf파일명 형식(시스템날짜_프로그램id_로그인유저id)
	  param.put("FILE_NAME", fileName + ".pdf");//fax보낼 pdf파일명
	  param.put("FAX_TITLE", cdo.getCodeName());//팩스 제목

	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Report use data
	  List<Map<String, Object>> report_data = sof120skrvService.clipselect(param);

	  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
      Map<String, Object> subReportMap = new HashMap<String ,Object>();
      subReportMap.put("SOF120SKRV2_5_01", "SQLDS2");

      List<Map<String, Object>> subReport_data = sof120skrvService.clipselectsub(param);
      subReportMap.put("SUB_DATA", subReport_data);
      subReports.add(subReportMap);

     //clireport 프로퍼티 경로 가져오기
	 	String propertyPath =  ReportUtils.clipReportPropertyPath(request);
	 	System.out.println(":::::clipReport-Property-Path:::::- " + propertyPath);
	 	System.out.println(":::::param:::::- " + param);

	 	//pdf파일 다운을 위한 oof생성
	     OOFDocument oof = doc.createOof(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request );
	     fileDelete(filePath + fileName + ".pdf");//pdf저장 전 파일 삭제
	     File localFileSave = new File( filePath + fileName + ".pdf" ); //경로와 저장될 pdf 파일명을 입력 (filePath + fileName +".pdf")
	     FileOutputStream fileStream = new FileOutputStream(localFileSave);

	     PDFOption option = null;
	     docPdf.createExportForPDF(request, fileStream, propertyPath, oof, option);
	     param.put("FILE_INFO", filePath + fileName + ".pdf");
	     //생성한 pdf파일(첨부)과 화면에서 입력한 내용들로 메일 전송
	     sof120skrvService.sendMail(param, user);
  }
   /*
    * 파일 삭제
    */
	public static void fileDelete(String file_path) {

        if(null!=file_path){

            File del_File = new File(file_path);

            if(del_File.exists()){
                // System.out.println(del_File.getName() + " 파일을 삭제합니다");
                del_File.delete();
            }
        }
	}
}
