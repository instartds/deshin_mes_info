package foren.unilite.modules.base.bsa;

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
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("bsa350ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Bsa350ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 외부사용자 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("bsa350ukrvServiceImpl.selectList", param);
	}



	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				} 
			}
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		try {
			//암호화여부 및 비밀번호 대소문자 구분 여부 체크
			boolean bSecurityFlag = false;
			String sCaseSensitiveYN = "N";
			
			Map<String, Object> setInfo = this.checkEncryptYN();
			if (setInfo == null) {
				bSecurityFlag	= false;
			} else {
				bSecurityFlag	= true;
				sCaseSensitiveYN= (String)setInfo.get("CASE_SENS_YN");
			}
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());

			List<Map> chkList = (List<Map>) super.commonDao.list("bsa350ukrvServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList) {
				//20210426 추가: 사용자 ID 중복체크
				Map<String, String> chkUniqueId = (Map<String, String>)super.commonDao.select("bsa350ukrvServiceImpl.checkUniqueID", param);
				if (chkUniqueId != null) {
					throw new UniDirectValidateException(this.getMessage("52113", user));
				}
				String strSecurityFlag = ( bSecurityFlag ) ? "True" : "False";
				param.put("bSecurityFlag"	, strSecurityFlag);
				param.put("FAIL_CNT"		, 0);
				for(Map checkCompCode : chkList) {
					param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					if ("N".equals(sCaseSensitiveYN)) {
						param.put("PASSWORD", param.get("PASSWORD").toString().toUpperCase());
					}
					String pw = ObjUtils.getSafeString(param.get("PASSWORD"));
					if (!"*".equals(pw)) {
						param.put("NEW_PASSWORD", pw);
					}
					super.commonDao.update("bsa350ukrvServiceImpl.insertDetail", param);
					super.commonDao.update("bsa350ukrvServiceImpl.insertDetail2", param);
				}
			}	
		}catch(Exception e){
			throw new UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		boolean bSecurityFlag = false;
		String sCaseSensitiveYN = "N";
		
		Map<String, Object> setInfo = this.checkEncryptYN();
		if (setInfo == null) bSecurityFlag = false;
		else {
			bSecurityFlag = true;
			sCaseSensitiveYN = (String)setInfo.get("CASE_SENS_YN");
		}
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("bsa350ukrvServiceImpl.checkCompCode", compCodeMap);
		for(Map param : paramList ) {
			//20210426 추가
			String sUserPwd = param.get("PASSWORD").toString();
			String strSecurityFlag = ( bSecurityFlag ) ? "True" : "False";
			param.put("bSecurityFlag", strSecurityFlag);
			param.put("FAIL_CNT", 0);
			if ("N".equals(sCaseSensitiveYN)) {
				param.put("PASSWORD", param.get("PASSWORD").toString().toUpperCase());
			}
			String pw = ObjUtils.getSafeString(param.get("PASSWORD"));
			if (!"*".equals(pw)) {
				param.put("NEW_PASSWORD", pw);
			}
			for(Map checkCompCode : chkList) {
				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.insert("bsa350ukrvServiceImpl.updateDetail", param);
				super.commonDao.insert("bsa350ukrvServiceImpl.updateDetail2", param);
				super.commonDao.update("bsa350ukrvServiceImpl.insertPasswordLog", param);
			}
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer deleteDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("bsa350ukrvServiceImpl.checkCompCode", compCodeMap);
		for(Map param :paramList ) {
			for(Map checkCompCode : chkList) {
				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				try {
					super.commonDao.delete("bsa350ukrvServiceImpl.deleteDetail", param);
					super.commonDao.delete("bsa350ukrvServiceImpl.deleteDetail2", param);
				}catch(Exception e) {
						throw new UniDirectValidateException(this.getMessage("547",user));
				}
			}
		}
		return 0;
	}
    /**
	 * 비밀번호 로그 저장
	 * @return
	 */
	 @SuppressWarnings( { "unchecked" } )
	 public void  insertPasswordLog(Map param) throws Exception { 
	     super.commonDao.update("bsa350ukrvServiceImpl.insertPasswordLog", param);
	 }
	 
	/**
	 * 20210426 추가: 비밀번호 암호화 체크 및 대소문자 구분 여부
	 * @return
	 */
	private Map<String, Object> checkEncryptYN() {
		return (Map<String, Object>)super.commonDao.select("bsa350ukrvServiceImpl.checkEncryptYN");
	}
}