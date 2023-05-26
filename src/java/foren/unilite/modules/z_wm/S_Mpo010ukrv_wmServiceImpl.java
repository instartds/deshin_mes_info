package foren.unilite.modules.z_wm;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import com.clipsoft.clipreport.export.option.PDFOption;
import com.clipsoft.clipreport.oof.OOFDocument;
import com.clipsoft.clipreport.server.service.ClipReportExport;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.email.EmailSendServiceImpl;
import foren.unilite.modules.com.report.ReportUtils;

import org.apache.commons.codec.binary.Base64;


@Service("s_mpo010ukrv_wmService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Mpo010ukrv_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	//메일 접송 로직 구현을 위해 추가 - 20201016 추가
	@Resource( name = "emailSendService" )
	private EmailSendServiceImpl emailSendService;


	/**
	 * 20201016 추가 - 사용자 서명 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public Map getUserSign(Map param) throws Exception {
		return (Map) super.commonDao.select("s_mpo010ukrv_wmServiceImpl.getUserSign", param);
	}



	/**
	 * 매입접수등록 조회(master)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "matrl")
	public Object selectMaster(Map param, LoginVO user) throws Exception {
		return super.commonDao.select("s_mpo010ukrv_wmServiceImpl.selectMaster", param);
	}

	/**
	 * 매입접수등록 조회(detail)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map> selectDetail(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_mpo010ukrv_wmServiceImpl.selectDetail", param);
	}



	/**
	 * 매입요청 참조 쿼리 - 20200923 추가
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map> requestRefPopupList(Map param, LoginVO user) throws Exception {
		List<Map> r = super.commonDao.list("s_mpo010ukrv_wmServiceImpl.requestRefPopupList", param);
		//20210216 주석: 쿼리에서 처리
//		if (!ObjUtils.isEmpty(r)) {
//			for (Map rMap : r) {
//				//계좌번호 '***************' 표시
//				if(!ObjUtils.isEmpty(rMap.get("BANK_ACCOUNT"))) {
//					rMap.put("BANK_ACCOUNT_EXPOS", "***************");
//				}
//				//20210115 추가: 주민번호(사실 생년월일) '***************' 표시
//				if(!ObjUtils.isEmpty(rMap.get("REPRE_NUM"))) {
//					rMap.put("REPRE_NUM_EXPOS", "***************");
//				}
//			}
//		}
		return r;
	}



	/**
	 * 조회팝업 쿼리
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map> searchPopupList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_mpo010ukrv_wmServiceImpl.searchPopupList", param);
	}






	/**매입접수등록(master) 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
	public ExtDirectFormPostResult saveMaster(S_Mpo010ukrv_wmModel dataMaster, LoginVO user, BindingResult result) throws Exception {
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		
		if (ObjUtils.isEmpty(dataMaster.getRECEIPT_NUM())) {
			Map receiptNumMap = new HashMap();
			receiptNumMap = (Map<String, Object>) super.commonDao.select("s_mpo010ukrv_wmServiceImpl.getReceiptNum", dataMaster);
			dataMaster.setRECEIPT_NUM((String) receiptNumMap.get("RECEIPT_NUM"));
		} else {
			//20200921 추가: 상태가 '접수'가 아닐 때는 수정 안 됨
			Integer checkData = (Integer) super.commonDao.select("s_mpo010ukrv_wmServiceImpl.checkControlStatus", dataMaster);
			if(checkData != null) {
				throw new UniDirectValidateException("진행상태가 [접수]가 아닌 데이터는 수정할 수 없습니다.");
			}
		}
		super.commonDao.update("s_mpo010ukrv_wmServiceImpl.saveMaster", dataMaster);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("RECEIPT_NUM", dataMaster.getRECEIPT_NUM());
		return extResult;
	}



	/**매입접수등록(detail) 저장
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		dataMaster.put("S_COMP_CODE", user.getCompCode());
		dataMaster.put("S_USER_ID"	, user.getUserID());

		if (ObjUtils.isEmpty(dataMaster.get("RECEIPT_NUM"))) {
			Map receiptNumMap = new HashMap();
			receiptNumMap = (Map<String, Object>) super.commonDao.select("s_mpo010ukrv_wmServiceImpl.getReceiptNum", dataMaster);
			dataMaster.put("RECEIPT_NUM", (String) receiptNumMap.get("RECEIPT_NUM"));
		}
		super.commonDao.update("s_mpo010ukrv_wmServiceImpl.saveMaster", dataMaster);

		if(paramList != null) {
			List<Map> insertDetail = null;
			List<Map> updateDetail = null;
			List<Map> deleteDetail = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail")) {
					insertDetail = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail")) {
					updateDetail = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail")) {
					deleteDetail = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertDetail != null) this.insertDetail(insertDetail, user, dataMaster);
			if(updateDetail != null) this.updateDetail(updateDetail, user, dataMaster);
			if(deleteDetail != null) this.deleteDetail(deleteDetail, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		try {
			for(Map param : paramList ) {
				if(ObjUtils.isEmpty(param.get("RECEIPT_NUM"))) {
					param.put("RECEIPT_NUM", paramMaster.get("RECEIPT_NUM"));
				}
				super.commonDao.insert("s_mpo010ukrv_wmServiceImpl.insertDetail", param);
			}
		}catch(Exception e){
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("s_mpo010ukrv_wmServiceImpl.updateDetail", param);
		}
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		 for(Map param :paramList ) {
			try {
				super.commonDao.delete("s_mpo010ukrv_wmServiceImpl.deleteDetail", param);
				//DETAIL DATA가 없으면 MASTER DATA 삭제
				int detailCount = (int) super.commonDao.select("s_mpo010ukrv_wmServiceImpl.checkDetailData", param);
				if(detailCount == 0) {
					super.commonDao.delete("s_mpo010ukrv_wmServiceImpl.deleteMaster", param);
				}
			}catch(Exception e) {
				throw new  UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return 0;
	}





	/**
	 * 메일 전송을 위해 유저sign binary로 변경하는 로직 - 20201229 추가
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public String converImage(Map param, LoginVO user) throws Exception {
		String PRE_PROCESS	= (String) param.get("USER_SIGN");
		String WHOLE_SIGN	= "";												//최종 데이터
		String TXT_PART1	= "";												//사용자 서명 중, text 앞 부분
		String TXT_PART2	= "";												//사용자 서명 중, text 뒷 부분
		String IMG_PART		= "";												//사용자 서명 중, image 부분
		String IMG_FILE		= "";												//IMG_PART에서 추출한 image 파일명
		String IMG_PATH		= "";												//IMG_PART에서 추출한 image 파일 경로
		String filePath		= ConfigUtil.getString("common.upload.temp");		//20201229 수정: omegaplus.xml에서 경로 읽어오도록 수정

		if(PRE_PROCESS.contains("<img")) {
			TXT_PART1					= PRE_PROCESS.substring(0, PRE_PROCESS.indexOf("<img"));
			TXT_PART2					= PRE_PROCESS.substring(PRE_PROCESS.indexOf("bin\">") + 5);
			IMG_PART					= PRE_PROCESS.substring(PRE_PROCESS.indexOf("<img"), PRE_PROCESS.indexOf("bin\">") + 5);
			IMG_PATH					= IMG_PART.substring(0, IMG_PART.lastIndexOf("/") + 1);
			IMG_FILE					= IMG_PART.substring(IMG_PART.lastIndexOf("/") + 1, IMG_PART.lastIndexOf("\""));
			//이미지 파일 binary로 변경
			byte[] imageBytes			= extractBytes(filePath + IMG_FILE);	//20201229 수정: omegaplus.xml에서 경로 읽어오도록 수정
			String baseIncodingBytes	= Base64.encodeBase64String(imageBytes);
			//변경된 binary 데이터 적용
			IMG_PART					= IMG_PART.replace(IMG_PATH + IMG_FILE, "<img src=\"data:image/png;base64," + baseIncodingBytes);
			WHOLE_SIGN					= TXT_PART1 + IMG_PART + TXT_PART2;
		} else {
			//이미지 파일이 없을 때는 SIGN 데이터 그대로 리턴
			WHOLE_SIGN = PRE_PROCESS;
		}
		return WHOLE_SIGN;
	}
	/**
	 * 이미지 / 해당 경로 byte로 변경 - 20201229 추가
	 * @param inmageName
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("resource")
	public static byte[] extractBytes(String inmageName) throws Exception {
		File imgPath				= new File(inmageName);
		FileInputStream fis			= new FileInputStream(imgPath);
		ByteArrayOutputStream baos	= new ByteArrayOutputStream();
		int len						= 0;
		byte[] buf					= new byte[1024];

		while((len = fis.read(buf)) != -1) {
			baos.write(buf, 0, len);
		}
		byte[] fileArray = baos.toByteArray();
		return fileArray;
	}

	/**
	 * 메일 접송 로직 추가 - 20201016 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public Map sendMail(Map param, LoginVO user, HttpServletRequest request) throws Exception {
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