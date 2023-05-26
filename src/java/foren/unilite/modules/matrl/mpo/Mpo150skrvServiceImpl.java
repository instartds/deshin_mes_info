package foren.unilite.modules.matrl.mpo;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;

import com.clipsoft.clipreport.export.option.PDFOption;
import com.clipsoft.clipreport.oof.OOFDocument;
import com.clipsoft.clipreport.server.service.ClipReportExport;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.email.EmailSendServiceImpl;
import foren.unilite.modules.com.report.ReportUtils;

@Service("mpo150skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Mpo150skrvServiceImpl  extends TlabAbstractServiceImpl {
	@InjectLogger
	public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	final static String            CRF_PATH           = "Clipreport4/Matrl/";

	@Resource( name = "emailSendService" )
	private EmailSendServiceImpl emailSendService;


	  @Resource(name = "tlabAbstractDAO")
	  protected TlabAbstractDAO dao;

	  @Resource( name = "mpo502ukrvService" )
	  private Mpo502ukrvServiceImpl mpo502ukrvService;

	  @Resource( name = "mpo150rkrvService" )
	  private Mpo150rkrvServiceImpl mpo150rkrvService;


	/**
	 * 화면 초기화용 로그인 유저 메일 주소, 사용자명
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Map<String, Object>  getLoginUserMailInfo(Map param) throws Exception {
		return  (Map<String, Object>) super.commonDao.select("mpo150skrvServiceImpl.getLoginUserMailInfo", param);
	}

	/**
	 * 화면 초기화용 메일 주소, 사용자명, 메일 pasword 가져오기
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Map<String, Object>  getUserMailInfo(Map param) throws Exception {
		return  (Map<String, Object>) super.commonDao.select("mpo150skrvServiceImpl.getUserMailInfo", param);
	}

	/**
	 * 발주서메일전송
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("mpo150skrvServiceImpl.selectList", param);
	}

	/**
	 * 발주서메일전송
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
		return  super.commonDao.list("mpo150skrvServiceImpl.selectList2", param);
	}

	/**
	 * 발주서메일전송_양평공사
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  selectList_yp(Map param) throws Exception {
		return  super.commonDao.list("mpo150skrvServiceImpl.selectList_yp", param);
	}
   /*
	*//**
	 * 저장
	 * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 *//*
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)   {
			List<Map> deleteList = null;
			List<Map> insertList = null;
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
//			if(insertList != null) this.insertList(insertList, dataMaster, user);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}*/

	/**
	 * 메일 발송
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Map sendMail(Map param, LoginVO user, HttpServletRequest request) throws Exception {

		logger.debug(":::::param:::::- " + param);
		String customForm = (String) param.get("CUSTOM_FORM");
		if(customForm.equals("Y")){//커스톰 폼 사용여부 Y인 경우에만 파일 첨부 발송
			  ClipReportDoc doc = new ClipReportDoc();
			  ClipReportExport docPdf = new ClipReportExport();
			  String filePath = "";
			  String filePath2 = "";
			  String fileName = "";
			  String replaceFileName = "";
			  SimpleDateFormat dateFormat;
			  Date today = new Date();
			  dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			  String mailFormat = (String) param.get("MAIL_FORMAT");
			  Map<String, Object> PDF_PATH = new HashMap<String, Object>();

			  PDF_PATH = (Map<String, Object>) super.commonDao.select("mpo150skrvServiceImpl.getPdfFilePath", param);
			  logger.debug("[[PDF_DOWN_PATH]]" + PDF_PATH);
			  logger.debug("[[param]]" + param);
			//  filePath = "D:\\PDF_DOWN\\";//pdf파일 다운 경로
			  filePath = (String) PDF_PATH.get("PDF_DOWN_PATH");//pdf파일 다운 경로 (M416의 refCode2의 값)
			  replaceFileName = (String) param.get("MAIL_SUBJECT");
			  replaceFileName = replaceFileName.substring(0, replaceFileName.indexOf("|"));
			  replaceFileName = replaceFileName.replace("*", "");

			  fileName = dateFormat.format(today) + "_" + replaceFileName ;//pdf파일명 형식(시스템날짜_프로그램id_로그인유저명)
			  String crfFile = null;
			  ReportUtils.setCreportPram(user, param, dao);
			  ReportUtils.setCreportSanctionParam(param, dao);
			  if(mailFormat.equals("1")){
				  logger.debug("[[국문]]" );
				  crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));//국문
			  }else{
				  logger.debug("[[영문]]" );
				  param.put("MAIL_SUBJECT",(String)param.get("MAIL_SUBJECT_ENG"));
				  param.put("SUBJECT",(String)param.get("MAIL_SUBJECT_ENG"));
				  fileName = dateFormat.format(today) + "_" + (String) param.get("CUSTOM_FULL_NAME") + "_PURCHASE_ORDER";
				  crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID6"));//영문
			  }


			  //로고, 스탬프 패스 추가
			  ReportUtils.clipReportLogoPath(param, dao, request);
			  ReportUtils.clipReportSteampPath(param, dao, request);
			//Image 경로 
			  String imagePath = doc.getImagePath();
			  param.put("CUSTOM_NAME", "");
			  param.put("ORDER_TYPE", "");
			  param.put("MAIL_FORM", mailFormat);
			  //Main Report
			  List<Map<String, Object>> report_data = mpo150rkrvService.mainReport(param);

			//clireport 프로퍼티 경로 가져오기
			 	String propertyPath =  ReportUtils.clipReportPropertyPath(request);
			 	logger.debug(":::::clipReport-Property-Path:::::- " + propertyPath);
			 	logger.debug(":::::fileFullPath:::::- " + filePath + fileName + ".pdf");


		      //String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

			 	//pdf파일 다운을 위한 oof생성
			     OOFDocument oof = doc.createOof(crfFile, "JDBC1","SQLDS1", param, report_data, null, request );
			     File localFileSave = new File( filePath + fileName + ".pdf" ); //경로와 저장될 pdf 파일명을 입력 (filePath + fileName +".pdf")

		    	 FileOutputStream fileStream = new FileOutputStream(localFileSave);
		 	     param.put("FILE_INFO", filePath + fileName + ".pdf");
		 	     PDFOption option = null;
		 	     docPdf.createExportForPDF(request, fileStream, propertyPath, oof, option);
		 	     fileStream.close();
		 	     Thread.sleep(3000);
		}

	 	String to = ObjUtils.getSafeString(param.get("REAL_MAIL_ID"));
		String from = ObjUtils.getSafeString(param.get("FROM_EMAIL"));
		String remark = "";
		
		if(ObjUtils.isNotEmpty(param.get("MAIL_REMARK"))){
			remark = param.get("MAIL_REMARK").toString().replaceAll("\n", "<br/>");
		}
		
		//실제 메일발송
		Map contentsMap = new HashMap();
		contentsMap.put("SUBJECT", param.get("SUBJECT"));
		contentsMap.put("TO", param.get("CUST_MAIL_ID"));
		contentsMap.put("FROM", param.get("FROM_EMAIL"));
		contentsMap.put("TEXT", remark + param.get("CONTENTS"));
		contentsMap.put("CC", param.get("FROM_EMAIL")+";"+param.get("CUST_MAIL_ID_REF"));
		contentsMap.put("BCC", param.get("BCC"));
		contentsMap.put("COMP_CODE",user.getCompCode());
		contentsMap.put("FILE_INFO", param.get("FILE_INFO"));
		emailSendService.sendMail(contentsMap);

		String rtnVal = "1";

		param.put("STATUS", rtnVal);
		param.put("S_COMP_CODE", user.getCompCode());

		if(rtnVal.equals("1")){ //전송 성공시 전송상태값 업데이트
			super.commonDao.update("mpo150skrvServiceImpl.updateMailYn", param);
		}
		return param;
	}

	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteList(List<Map> params, LoginVO user) throws Exception {

	}

	/**
	 * 발주서 메일 사이트 양식 사용 여부
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public int getCustomFormYn(Map param) throws Exception {
		return  (int) super.commonDao.select("mpo150skrvServiceImpl.getCustomFormYn", param);
	}

	/**
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mrt")
	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("mpo150skrvServiceImpl.mainReport", param);
	}

	/**
	 *
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mrt")
	public List<Map<String, Object>>  mainReport2(Map param) throws Exception {
		return  super.commonDao.list("mpo150skrvServiceImpl.mainReport2", param);
	}
}
