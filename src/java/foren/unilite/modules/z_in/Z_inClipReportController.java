package foren.unilite.modules.z_in;

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
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.z_in.S_mtr110skrv_inServiceImpl;	//20200520 추가, 20200521 수정: 신규프로그램으로 대체  (matrl.mtr.Mtr110skrvServiceImpl -> z_in.S_mtr110skrv_inServiceImpl)
import foren.unilite.modules.z_in.S_mms510ukrv_inServiceImpl;
import foren.unilite.modules.z_in.S_pmp100skrv_inServiceImpl;
import foren.unilite.modules.z_in.S_sof130rkrv_inServiceImpl;
import foren.unilite.modules.com.report.CommonReportServiceImpl;

@Controller
public class Z_inClipReportController  extends UniliteCommonController {
 @InjectLogger
  public static Logger logger;
  final static String            CRF_PATH           = "/clipreport4/Sales/";
  final static String            CRF_PATH2          = "Clipreport4/Z_in/";

  @Resource( name = "s_mms510ukrv_inService" )
  private S_mms510ukrv_inServiceImpl s_mms510ukrv_inService;

  @Resource( name = "s_pmp100skrv_inService" )
  private S_pmp100skrv_inServiceImpl s_pmp100skrv_inService;

  @Resource( name = "s_sof130rkrv_inService" )
  private S_sof130rkrv_inServiceImpl s_sof130rkrv_inService;

  @Resource( name = "s_opo100ukrv_inService" )
  private S_opo100ukrv_inServiceImpl s_opo100ukrv_inService;

  @Resource(name="s_str410skrv_inService")
  private S_str410skrv_inServiceImpl s_str410skrv_inService;

  //20200520 추가, 20200521 수정: 신규프로그램으로 대체  (mtr110skrvService -> s_mtr110skrv_inService)
  @Resource(name="s_mtr110skrv_inService")
  private S_mtr110skrv_inServiceImpl s_mtr110skrv_inService;


  @Resource(name="commonReportService")
  private CommonReportServiceImpl commonReportService;


  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;


  @RequestMapping(value = "/z_in/s_mms510clukrv_in.do", method = {RequestMethod.GET,RequestMethod.POST})
   public ModelAndView s_mms510clukrv_inPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Main Report
	  List<Map<String, Object>> report_data = s_mms510ukrv_inService.selectList2(param);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
      String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

      Map<String, Object> rMap = new HashMap<String, Object>();
      rMap.put("success", "true");
      rMap.put("resultKey", resultKey);
      return ViewHelper.getJsonView(rMap);
   }

  @RequestMapping(value = "/z_in/s_pmp100clskrv_in.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView s_pmp100clskrv_inPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Main Report
	  List<Map<String, Object>> report_data = s_pmp100skrv_inService.selectMainList(param);

	  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
	     Map<String, Object> subReportMap = new HashMap<String ,Object>();
	     subReportMap.put("Report1", "SQLDS2");

	    List<Map<String, Object>> subReport_data = s_pmp100skrv_inService.selectList(param);
	     subReportMap.put("SUB_DATA", subReport_data);
	     subReports.add(subReportMap);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
     String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

     Map<String, Object> rMap = new HashMap<String, Object>();
     rMap.put("success", "true");
     rMap.put("resultKey", resultKey);
     return ViewHelper.getJsonView(rMap);
  }

  @RequestMapping(value = "/z_in/s_sof130clrkrv_in.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView s_sof130clrkrv_inPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();
	  Map param = _req.getParameterMap();
	  List orderNumList = new ArrayList();

	  String crfFile = CRF_PATH2+"s_sof130clrkrv_in.crf";

	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Report use data
	  List<Map<String, Object>> report_data = s_sof130rkrv_inService.clipselect(param);


	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
     String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

     Map<String, Object> rMap = new HashMap<String, Object>();
     rMap.put("success", "true");
     rMap.put("resultKey", resultKey);
     return ViewHelper.getJsonView(rMap);
  }

  @RequestMapping(value = "/z_in/s_sof130clrkrv_in2.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView s_sof130clrkrv_in2Print(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();
	  Map<String, Object> param = _req.getParameterMap();

	  String crfFile = CRF_PATH2+"s_sof130clrkrv_in2.crf";

	  //Report use data
	  List<Map<String, Object>> report_data = s_sof130rkrv_inService.clipselect(param);

     String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

     Map<String, Object> rMap = new HashMap<String, Object>();
     rMap.put("success", "true");
     rMap.put("resultKey", resultKey);

     return ViewHelper.getJsonView(rMap);
  }

  @RequestMapping(value = "/z_in/s_opo100clukrv_in.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView s_opo100ukrv_inPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Main Report
	  List<Map<String, Object>> report_data = s_opo100ukrv_inService.selectPrintList(param);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
     String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

     Map<String, Object> rMap = new HashMap<String, Object>();
     rMap.put("success", "true");
     rMap.put("resultKey", resultKey);
     return ViewHelper.getJsonView(rMap);
  }

  @RequestMapping(value = "/z_in/s_str410skrv_in_clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_str410clskrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH  + ObjUtils.getSafeString(param.get("RPT_ID1"));
		ReportUtils.clipReportLogoPath(param, dao, request);
		ReportUtils.clipReportSteampPath(param, dao, request);
		//Image 경로
		String imagePath = doc.getImagePath();

		//Report use data
		List<Map<String, Object>> report_data = s_str410skrv_inService.clipselect(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("STR410SKRV2_01", "SQLDS2");
		subReportMap.put("STR410SKRV2_02", "SQLDS2");
		subReportMap.put("STR410SKRV2_03", "SQLDS2");
		subReportMap.put("STR410SKRV2_04", "SQLDS2");
		subReportMap.put("STR410SKRV2_05", "SQLDS2");

		List<Map<String, Object>> subReport_data = s_str410skrv_inService.clipselectsub(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


	/**
	 * 택배비명세서 (str410clskrv_5)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_str410skrv_in_clskrv_5.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_str410skrv_in_clskrv_5Print(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		ReportUtils.clipReportLogoPath(param, dao, request);
		ReportUtils.clipReportSteampPath(param, dao, request);
		//Image 경로
		String imagePath = doc.getImagePath();

		//Report use data
		List<Map<String, Object>> report_data = s_str410skrv_inService.clipselect(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("STR410SKR_5_01", "SQLDS2");

		List<Map<String, Object>> subReport_data = s_str410skrv_inService.clipselectsub(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


	/**
	 * 20200520 추가: 입고현황 조회(mtr110skrv) - 라벨출력(INNO), 20200521 수정: 신규프로그램으로 대체
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_mtr110clskrv_in.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_mtr110clskrv_in(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));

		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = s_mtr110skrv_inService.getPrintData(param);			//20200521 수정: 신규프로그램으로 대체  (mtr110skrvService -> s_mtr110skrv_inService)

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}



	/**
	 * 일단 거래명세서 fax (str410clskrv_fax)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_str410skrv_in_clskrv_fax.do", method = {RequestMethod.GET,RequestMethod.POST})
	public void s_str410skrv_in_clskrv_fax(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		try{

			ClipReportDoc doc = new ClipReportDoc();
			ClipReportExport docPdf = new ClipReportExport();

			//Image 경로
			String imagePath = doc.getImagePath();

			Map param = _req.getParameterMap();
			ReportUtils.setCreportPram(user, param, dao);
			ReportUtils.setCreportSanctionParam(param, dao);
			String crfFile = CRF_PATH  + ObjUtils.getSafeString(param.get("RPT_ID1"));
			ReportUtils.clipReportLogoPath(param, dao, request);
			ReportUtils.clipReportSteampPath(param, dao, request);

			//FAX관련 설정 정보 가져오기 start
		 	String fileName = "";
			CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
			CodeDetailVO cdo = null;
			cdo = codeInfo.getCodeInfo("B917", "1");
			String pdfDownPath = cdo.getRefCode2(); //REF_CODE2(PDF다운경로): FAX전송을 위한 PDF다운 경로
			String copyPath    = cdo.getRefCode3(); //REF_CODE3(복사할 주소)  : PDF로 다운받은 파일을 FAX전송 서비스가 있는 서버의 특정 폴더로 이동시켜야 FAX전송이 됨
			SimpleDateFormat dateFormat;
			Date today = new Date();
			dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			//clipreport 프로퍼티 경로 가져오기
		 	String propertyPath =  ReportUtils.clipReportPropertyPath(request);
		 	fileName = dateFormat.format(today) + "_" +"거래명세서" + "_" + user.getUserName()+ ".pdf";//pdf파일명 형식(시스템날짜_프로그램id_로그인유저명)
		 	copyPath = copyPath + fileName;
		 	param.put("FILE_NAME", fileName);
		 	param.put("FAX_TITLE", "거래명세서");
			//FAX관련 설정 가져오기 end

			//Report use data
			List<Map<String, Object>> report_data = s_str410skrv_inService.clipselect(param);

			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("STR410SKRV2_01", "SQLDS2");
			subReportMap.put("STR410SKRV2_02", "SQLDS2");
			subReportMap.put("STR410SKRV2_03", "SQLDS2");
			subReportMap.put("STR410SKRV2_04", "SQLDS2");
			subReportMap.put("STR410SKRV2_05", "SQLDS2");

			List<Map<String, Object>> subReport_data = s_str410skrv_inService.clipselectsub(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);


		 	 //pdf파일 다운을 위한 oof생성
			 OOFDocument oof = doc.createOof(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request );
			 File localFileSave = new File( pdfDownPath + fileName ); //경로와 저장될 pdf 파일명을 입력 (filePath + fileName +".pdf") "D:\\PDF_DOWN\\2021-03-22_거래명세서_오메가+1.pdf"
			 FileOutputStream fileStream = new FileOutputStream(localFileSave);

			 PDFOption option = null;
			 docPdf.createExportForPDF(request, fileStream, propertyPath, oof, option);
			 fileStream.close();

			 Map<String, Object> authInfo = new HashMap<String, Object>();
			 authInfo.put("AUTH1", "faxUser");
			 authInfo.put("AUTH2", "5megaPlus_2018");

			 //FAX전송을 위해 만들어 놓은 PDF파일은 FAX전송 서비스가 있는 폴더로 복사하는 함수
			// ReportUtils.clipReportPdfCopy(localFileSave, copyPath, param, authInfo, dao, user);

		}catch(Exception e){

			throw new Exception("FAX전송 중 오류가 발생했습니다.");

		}


	}

	/**
	 * 택배비명세서 fax (str410clskrv_fax)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_str410skrv_in_clskrv_5_fax.do", method = {RequestMethod.GET,RequestMethod.POST})
	public void s_str410skrv_in_clskrv_5_fax(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		try{

			ClipReportDoc doc = new ClipReportDoc();
			ClipReportExport docPdf = new ClipReportExport();

			//Image 경로
			String imagePath = doc.getImagePath();

			Map param = _req.getParameterMap();
			ReportUtils.setCreportPram(user, param, dao);
			ReportUtils.setCreportSanctionParam(param, dao);
			String crfFile = CRF_PATH  + ObjUtils.getSafeString(param.get("RPT_ID5"));
			ReportUtils.clipReportLogoPath(param, dao, request);
			ReportUtils.clipReportSteampPath(param, dao, request);

			/*
			 * FAX관련 설정 정보 가져오기 start
			 */
			 	String fileName = "";
				CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(user.getCompCode());
				CodeDetailVO cdo = null;
				cdo = codeInfo.getCodeInfo("B917", "1");
				String pdfDownPath = cdo.getRefCode2(); 		//REF_CODE2(PDF다운경로): FAX전송을 위한 PDF다운 경로
				String copyPath    = cdo.getRefCode3(); 		//REF_CODE3(복사할 주소)  : PDF로 다운받은 파일을 FAX전송 서비스가 있는 서버의 특정 폴더로 이동시켜야 FAX전송이 됨
				SimpleDateFormat dateFormat;
				Date today = new Date();
				dateFormat = new SimpleDateFormat("yyyy-MM-dd");
				//clipreport 프로퍼티 경로 가져오기
			 	String propertyPath =  ReportUtils.clipReportPropertyPath(request);
			 	fileName = dateFormat.format(today) + "_" +"택배비명세서" + "_" + user.getUserName()+ ".pdf";//pdf파일명 형식(시스템날짜_프로그램id_로그인유저명)
			 	copyPath = copyPath + fileName;
			 	param.put("FILE_NAME", fileName);
			 	param.put("FAX_TITLE", "택배비명세서");
			/*
			 * FAX관련 설정 가져오기 end
			 */

			 	//Report use data
				List<Map<String, Object>> report_data = s_str410skrv_inService.clipselect(param);

				List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
				Map<String, Object> subReportMap = new HashMap<String ,Object>();
				subReportMap.put("STR410SKR_5_01", "SQLDS2");

				List<Map<String, Object>> subReport_data = s_str410skrv_inService.clipselectsub(param);
				subReportMap.put("SUB_DATA", subReport_data);
				subReports.add(subReportMap);


		 	 //pdf파일 다운을 위한 oof생성
			 OOFDocument oof = doc.createOof(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request );
			 File localFileSave = new File( pdfDownPath + fileName ); //경로와 저장될 pdf 파일명을 입력 (filePath + fileName +".pdf") "D:\\PDF_DOWN\\2021-03-22_거래명세서_오메가+1.pdf"
			 FileOutputStream fileStream = new FileOutputStream(localFileSave);

			 PDFOption option = null;
			 docPdf.createExportForPDF(request, fileStream, propertyPath, oof, option);
			 fileStream.close();

			 Map<String, Object> authInfo = new HashMap<String, Object>();
			 authInfo.put("AUTH1", "faxUser");
			 authInfo.put("AUTH2", "5megaPlus_2018");

			 //FAX전송을 위해 만들어 놓은 PDF파일은 FAX전송 서비스가 있는 폴더로 복사하는 함수
			 ReportUtils.clipReportPdfCopy(localFileSave, copyPath, param, authInfo, dao, user);

		}catch(Exception e){

			throw new Exception("FAX전송 중 오류가 발생했습니다.");

		}


	}
}