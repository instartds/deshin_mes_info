package foren.unilite.modules.sales.spp;

import java.io.File;
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
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.sales.spp.Srp100rkrvServiceImpl;


@Controller
public class SppClipReportController  extends UniliteCommonController {

  final static String            CRF_PATH           = "/clipreport4/crf/human/";
  final static String            CRF_PATH2           = "/Clipreport4/Sales/";

  @Resource( name = "srp100rkrvService" )
  private Srp100rkrvServiceImpl srp100rkrvService;

  @Resource( name = "spp100ukrvService" )
  private Spp100ukrvServiceImpl spp100ukrvService;

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;

  @RequestMapping(value = "/sales/spp100clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView spp100ukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
      ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  //이미지경로추가
	  ReportUtils.clipReportLogoPath(param, dao,request);
	  ReportUtils.clipReportSteampPath(param, dao, request);

	  System.out.println("[[[[Print Param]]]]" + param);

      String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5")); // 공통코드에서 경로를 가져오기 위해서...

      //Image 경로
      String imagePath = doc.getImagePath();

      //스탬프 패스 추가
	  ReportUtils.clipReportSteampPath(param, dao, request);

      //Main Report
      List<Map<String, Object>> report_data = spp100ukrvService.mainReport(param);

      //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
      String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

      Map<String, Object>rMap = new HashMap<String, Object>();
      rMap.put("success", "true");
      rMap.put("resultKey", resultKey);

	  return ViewHelper.getJsonView(rMap);
  }

  @RequestMapping(value = "/sales/srp100clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
   public ModelAndView srp100clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  //이미지경로추가
	  ReportUtils.clipReportLogoPath(param, dao,request);
	  ReportUtils.clipReportSteampPath(param, dao, request);
	  //String crfFile = CRF_PATH2+"srp100clrkrv_cov.crf";
	  String crfFile = CRF_PATH2+ ObjUtils.getSafeString(param.get("RPT_ID1"));

	  //Image 경로 
	  String imagePath = doc.getImagePath();

	  //Main Report
	  List<Map<String, Object>> report_data = srp100rkrvService.mainReport(param);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
      String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

      Map<String, Object> rMap = new HashMap<String, Object>();
      rMap.put("success", "true");
      rMap.put("resultKey", resultKey);
      return ViewHelper.getJsonView(rMap);
   }


  @RequestMapping(value = "/sales/spp100clukrv_fax.do", method = {RequestMethod.GET,RequestMethod.POST})
  public void spp100ukrvPrintFax(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
	  try{
		  ClipReportDoc doc = new ClipReportDoc();
	      ClipReportExport docPdf = new ClipReportExport();

		  Map param = _req.getParameterMap();
		  ReportUtils.setCreportPram(user, param, dao);
		  ReportUtils.setCreportSanctionParam(param, dao);
		  //이미지경로추가
		  ReportUtils.clipReportLogoPath(param, dao,request);
		  ReportUtils.clipReportSteampPath(param, dao, request);

		  System.out.println("[[[[Print Param]]]]" + param);

	      String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5")); // 공통코드에서 경로를 가져오기 위해서...


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
			 	fileName = dateFormat.format(today) + "_" +"견적서" + "_" + user.getUserName()+ ".pdf";//pdf파일명 형식(시스템날짜_프로그램id_로그인유저명)
			 	copyPath = copyPath + fileName;
			 	param.put("FILE_NAME", fileName);
			 	param.put("FAX_TITLE", "견적서");
			/*
			 * FAX관련 설정 가져오기 end
			 */


	      //Image 경로
	      String imagePath = doc.getImagePath();

	      //스탬프 패스 추가
		  ReportUtils.clipReportSteampPath(param, dao, request);

	      //Main Report
	      List<Map<String, Object>> report_data = spp100ukrvService.mainReport(param);

		 //pdf파일 다운을 위한 oof생성
		 OOFDocument oof = doc.createOof(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request );
		 File localFileSave = new File( pdfDownPath + fileName ); //경로와 저장될 pdf 파일명을 입력 (filePath + fileName +".pdf") "D:\\PDF_DOWN\\2021-03-22_거래명세서_오메가+1.pdf"
		 FileOutputStream fileStream = new FileOutputStream(localFileSave);

		 PDFOption option = null;
		 docPdf.createExportForPDF(request, fileStream, propertyPath, oof, option);
		 fileStream.close();

		 Map<String, Object> authInfo = new HashMap<String, Object>();
		 authInfo.put("AUTH1", "administrator");
		 authInfo.put("AUTH2", "1111");

		 //FAX전송을 위해 만들어 놓은 PDF파일은 FAX전송 서비스가 있는 폴더로 복사하는 함수
		 ReportUtils.clipReportPdfCopy(localFileSave, copyPath, param, authInfo, dao, user);

	  }catch (Exception e){

		  throw new Exception("FAX전송 중 오류가 발생했습니다.");

	  }

  }
}
