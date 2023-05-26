package foren.unilite.modules.z_wm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;


@Service("s_bsa315ukrv_wmService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Bsa315ukrv_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "bdc100ukrvService")
	private Bdc100ukrvService bdc100ukrvService;


	/**
	 * 사용자 서명 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "base")
	public Object selectMaster(Map param, LoginVO user) throws Exception {
		return (Map) super.commonDao.select("s_bsa315ukrv_wmServiceImpl.selectMaster", param);
	}

	/**
	 * 사용자 서명  저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public ExtDirectFormPostResult saveMaster(S_Bsa315ukrv_wmModel dataMaster, LoginVO user, BindingResult result) throws Exception {
		super.commonDao.update("s_bsa315ukrv_wmServiceImpl.saveMaster", dataMaster);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("USER_SIGN", dataMaster.getUSER_SIGN());
		return extResult;
	}




	/**
	 * 파일업로드 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base")
	public List<Map<String, Object>> getFileList(Map param,  LoginVO login) throws Exception {
		param.put("S_COMP_CODE", login.getCompCode());
		return super.commonDao.list("s_bsa315ukrv_wmServiceImpl.getFileList", param);
	}

	/**
	 * 파일업로드 저장
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.FORM_POST)
	public ExtDirectFormPostResult saveFile(S_Bsa315ukrv_wmModel param, LoginVO login, BindingResult result) throws Exception {
		String docNo = param.getDOC_NO();
		param.setCOMP_CODE(login.getCompCode());
		if (docNo != null && !"".equals(docNo)) {
			// 첨부파일 입력/삭제
			Map rFileMap = this.syncFileList(param, login);
			if(!ObjUtils.isEmpty(rFileMap)) {
				param.setFILE_NO(ObjUtils.getSafeString( rFileMap.get("DOC_NO")));
			}
			
		}else {
			param.setDOC_NO(createDocNo(param, login));
			Map rFileMap = this.syncFileList(param, login);
			if(!ObjUtils.isEmpty(rFileMap)) {
				param.setFILE_NO(ObjUtils.getSafeString( rFileMap.get("DOC_NO")));
			}
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("DOC_NO", param.getDOC_NO());
		return extResult;
	}

	private Map syncFileList(S_Bsa315ukrv_wmModel param, LoginVO login) throws Exception {
		List<Map> rList	= null;
		Map rtn			= null;
		if(!ObjUtils.isEmpty(param.getADD_FID()) || !ObjUtils.isEmpty(param.getDEL_FID())) {
			List<Map> paramList = new ArrayList<Map>();
			Map fParam = new HashMap();
			fParam.put("DOC_NO"		, param.getFILE_NO());
			fParam.put("ADD_FIDS"	, param.getADD_FID());
			fParam.put("DEL_FIDS"	, param.getDEL_FID());
			fParam.put("S_COMP_CODE", login.getCompCode());
			fParam.put("S_USER_ID"	, login.getUserID());
			fParam.put("S_DEPT_CODE", login.getDeptCode());
			fParam.put("AUTH_LEVEL"	, login.getAuthorityLevel());
			paramList.add(fParam);
			if(ObjUtils.isEmpty(param.getFILE_NO()))	{
				rList = bdc100ukrvService.insertMulti(paramList, login);
			}else {
				rList = bdc100ukrvService.updateMulti(paramList, login);
			}
		}
		if (!ObjUtils.isEmpty(rList)) rtn = rList.get(0);
		return rtn;
	}

	private String createDocNo(S_Bsa315ukrv_wmModel param, LoginVO login)	{		//파일번호 자동채번	 
		return (String) super.commonDao.select("s_bsa315ukrv_wmServiceImpl.getAutoNumComp", param);
	}
}