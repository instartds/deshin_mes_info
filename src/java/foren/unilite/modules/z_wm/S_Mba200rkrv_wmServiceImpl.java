package foren.unilite.modules.z_wm;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.clipsoft.clipreport.export.option.PDFOption;
import com.clipsoft.clipreport.oof.OOFDocument;
import com.clipsoft.clipreport.server.service.ClipReportExport;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.dao.TlabAbstractDAO;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.email.EmailSendServiceImpl;
import foren.unilite.modules.com.report.ReportUtils;

@Service("s_mba200rkrv_wmService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Mba200rkrv_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger		= LoggerFactory.getLogger(this.getClass());

	final static String CRF_PATH	= "Clipreport4/Z_wm/";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "emailSendService" )
	private EmailSendServiceImpl emailSendService;


	/**
	 * master data 조회
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("s_mba200rkrv_wmServiceImpl.selectList1", param);
	}

	/**
	 * detail data 조회
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("s_mba200rkrv_wmServiceImpl.selectList2", param);
	}





	/**
	 * 견적서 출력
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> printMasterData(Map param) throws Exception {
		return super.commonDao.list("s_mba200rkrv_wmServiceImpl.printMasterData", param);
	}

	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> printDetailData(Map param) throws Exception {
		return super.commonDao.list("s_mba200rkrv_wmServiceImpl.printDetailData", param);
	}





	/**
	 * 메일 발송
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("static-access")
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Map sendMail(Map param, LoginVO user, HttpServletRequest request) throws Exception {
		ClipReportDoc doc		= new ClipReportDoc();
		ClipReportExport docPdf	= new ClipReportExport();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile			= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));//국문
		//clireport 프로퍼티 경로 가져오기
		String propertyPath		= ReportUtils.clipReportPropertyPath(request);

		//report 생성을 위한 변수 정제
		String[] receipInfoArry		= param.get("receipInfo").toString().split(",");
		List<Map> receipInfoList	= new ArrayList<Map>();

		for(int i=0; i<receipInfoArry.length; i++){
			Map map = new HashMap();
			map.put("RECEIP_INFO", receipInfoArry[i]);
			receipInfoList.add(map);
		}
		param.put("RECEIP_INFO_LIST", receipInfoList);

		//Main Report
		List<Map<String, Object>> report_data = this.printMasterData(param);

		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();

		//SUB REPORT 1
		List<Map<String, Object>> subReport_data1 = this.printDetailData(param);
		subReportMap.put("DATA_SET", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);

		//report파일 생성을 위한 작업
		SimpleDateFormat dateFormat;
		String filePath		= "";
		String fileName		= "";
		Date today			= new Date();
		dateFormat			= new SimpleDateFormat("yyyy-MM-dd");
		filePath			= "D:\\PDF_ESTI_DOC\\";																			//pdf파일 다운 경로
		fileName			= dateFormat.format(today) + "_견적서(" + ObjUtils.getSafeString(param.get("CUSTOM_NM")) + ")";	//pdf파일명 형식(시스템날짜_프로그램id_로그인유저명)

		//폴더가 존재하지 않을 경우, 폴더 생성
		File confirmFolder = new File(filePath);
		if(!confirmFolder.exists()) {
			confirmFolder.mkdirs();
		}

		OOFDocument oof		= doc.createOof(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request );			//pdf파일 다운을 위한 oof생성
		File localFileSave	= new File( filePath + fileName + ".pdf" );														//경로와 저장될 pdf 파일명을 입력 (filePath + fileName +".pdf")

		FileOutputStream fileStream = new FileOutputStream(localFileSave);
		param.put("FILE_INFO", filePath + fileName + ".pdf");
		PDFOption option = null;
		docPdf.createExportForPDF(request, fileStream, propertyPath, oof, option);
		fileStream.close();
		Thread.sleep(3000);

		//실제 메일발송
		Map contentsMap = new HashMap();
		contentsMap.put("SUBJECT"	, param.get("SUBJECT"));							//제목
		contentsMap.put("TO"		, ObjUtils.getSafeString(param.get("RECI_EMAIL")));	//보내는 사람
		contentsMap.put("FROM"		, ObjUtils.getSafeString(param.get("SEND_EMAIL")));	//받는 사람
		contentsMap.put("TEXT"		, param.get("CONTENTS"));							//본문
		contentsMap.put("CC"		, "");												//참조
		contentsMap.put("BCC"		, "");												//숨은 참조
		contentsMap.put("COMP_CODE"	, user.getCompCode());
		contentsMap.put("FILE_INFO"	, param.get("FILE_INFO"));
		emailSendService.sendMail(contentsMap);

		String rtnVal = "1";
		param.put("STATUS"			, rtnVal);

		return param;
	}
}