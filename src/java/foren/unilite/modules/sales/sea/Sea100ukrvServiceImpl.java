package foren.unilite.modules.sales.sea;

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


@Service("sea100ukrvService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class Sea100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 견적의뢰등록 데이터 조회(master)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "sales")
	public Object selectMaster(Map param, LoginVO user) throws Exception {
		return super.commonDao.select("sea100ukrvServiceImpl.selectMaster", param);
	}

	/**
	 * 견적의뢰등록 데이터 조회(detail)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectDetail(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("sea100ukrvServiceImpl.selectDetail", param);
	}



	/**
	 * 조회팝업 쿼리
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> searchPopupList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("sea100ukrvServiceImpl.searchPopupList", param);
	}






	/**매입접수등록(master) 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public ExtDirectFormPostResult saveMaster(Sea100ukrvModel dataMaster, LoginVO user, BindingResult result) throws Exception {
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());

		if (ObjUtils.isEmpty(dataMaster.getESTI_NUM())) {
			Map estiNum	= new HashMap();
			estiNum		= (Map<String, Object>) super.commonDao.select("sea100ukrvServiceImpl.getEstiNum", dataMaster);
			dataMaster.setESTI_NUM((String) estiNum.get("ESTI_NUM"));
		}
		super.commonDao.update("sea100ukrvServiceImpl.saveMaster", dataMaster);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("ESTI_NUM", dataMaster.getESTI_NUM());
		return extResult;
	}



	/**매입접수등록(detail) 저장
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//1. master data 저장
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		dataMaster.put("S_COMP_CODE", user.getCompCode());
		dataMaster.put("S_USER_ID"	, user.getUserID());

		if (ObjUtils.isEmpty(dataMaster.get("ESTI_NUM"))) {
			Map estiNum	= new HashMap();
			estiNum		= (Map<String, Object>) super.commonDao.select("sea100ukrvServiceImpl.getEstiNum", dataMaster);
			dataMaster.put("ESTI_NUM", (String) estiNum.get("ESTI_NUM"));
		}
		super.commonDao.update("sea100ukrvServiceImpl.saveMaster", dataMaster);

		//2. detail data 저장
		List<Map> insertDetail = null;
		List<Map> updateDetail = null;
		List<Map> deleteDetail = null;

		if(paramList != null) {
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail")) {
					insertDetail = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
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

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		try {
			for(Map param : paramList ) {
				if(ObjUtils.isEmpty(param.get("ESTI_NUM"))) {
					param.put("ESTI_NUM", paramMaster.get("ESTI_NUM"));
				}
				super.commonDao.insert("sea100ukrvServiceImpl.insertDetail", param);
			}
		} catch(Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.update("sea100ukrvServiceImpl.updateDetail", param);
		}
		return 0;
	} 

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		for(Map param : paramList) {
			try {
				super.commonDao.delete("sea100ukrvServiceImpl.deleteDetail", param);
				//DETAIL DATA가 없으면 MASTER DATA 삭제
				int detailCount = (int) super.commonDao.select("sea100ukrvServiceImpl.checkDetailData", param);
				if(detailCount == 0) {
					super.commonDao.delete("sea100ukrvServiceImpl.deleteMaster", param);
				}
			}catch(Exception e) {
				throw new  UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return 0;
	}



	/**
	 * 첨부파일 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public List<Map<String, Object>> getFileList(Map param,  LoginVO login) throws Exception {
		param.put("S_COMP_CODE", login.getCompCode());
		return super.commonDao.list("sea100ukrvServiceImpl.getFileList", param);
	}











	/**
	 * 메일 전송을 위해 유저sign binary로 변경하는 로직 - 20201229 추가
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
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
}