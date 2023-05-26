package foren.unilite.modules.human.hpe;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.AES256DecryptoUtils;

@Service("hpe100ukrService")
public class Hpe100ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 지급명세서 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpe")
	public List<Map<String, Object>> selectList( Map param, LoginVO user ) throws Exception {
		return super.commonDao.list("hpe100ukrServiceImpl.selectList", param);
	}
	
	/**
	 * 소득명세 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpe")
	public List<Map<String, Object>> selectDetail( Map param, LoginVO user ) throws Exception {
		return super.commonDao.list("hpe100ukrServiceImpl.selectDetail", param);
	}

	/**
	 * 마스터데이터 저장
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpe")
	public List<Map> saveMaster(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map<String, Object>> deleteList = null;
			List<Map<String, Object>> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteMaster")) {
					deleteList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateMaster")) {
					updateList = (List<Map<String, Object>>)dataListMap.get("data");
				}
			}
			Map<String,Object> param = new HashMap<String,Object>();
			if(deleteList != null) {
				this.deleteMaster(deleteList);
				param = deleteList.get(0);
			}
			if(updateList != null) {
				this.updateMaster(updateList);
				param = updateList.get(0);
			}
		}
		paramList.add(0, paramMaster);
				
		return paramList;
	}

	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> deleteMaster(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("hpe100ukrServiceImpl.deleteMaster", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> updateMaster(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("hpe100ukrServiceImpl.updateMaster", param);
		}
		return paramList;		
	}

	/**
	 * 디테일데이터 저장
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpe")
	public List<Map> saveDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map<String, Object>> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map<String, Object>>)dataListMap.get("data");
				}
			}
			Map<String,Object> param = new HashMap<String,Object>();
			if(updateList != null) {
				this.updateDetail(updateList);
				param = updateList.get(0);
			}
		}
		paramList.add(0, paramMaster);
				
		return paramList;
	}

	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> updateDetail(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("hpe100ukrServiceImpl.updateDetail", param);
		}
		return paramList;		
	}
	
	/**
	 * 집계자료가져오기
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hpe" )
	public Map<String, Object> fnGetPayAmt( Map param, LoginVO user ) throws Exception {
		Map<String, Object> spResult = new HashMap();
		Map result = new HashMap();
		String errorDesc = "";
		
		spResult = (Map)super.commonDao.select("hpe100ukrServiceImpl.fnGetPayAmt", param);
		if(spResult != null) {
			errorDesc = ObjUtils.getSafeString(spResult.get("ERROR_DESC"));
			if (!ObjUtils.isEmpty(errorDesc)) {
				throw new UniDirectValidateException(this.getMessage(errorDesc, user) + "\n" + errorDesc);
			}
		}else {
			throw new UniDirectValidateException("오류!");
		}
		result.put("ERROR_DESC", "success");
		
		return result;
	}

	/**
	 * 마감여부 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hpe" )
	public Map<String, Object> fnGetCloseAll( Map param, LoginVO user ) throws Exception {
		return (Map)super.commonDao.select("hpe100ukrServiceImpl.fnGetCloseAll", param);
    }
    
	/**
	 * 전제마감/마감취소
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hpe" )
	public Map<String, Object> fnSetCloseAll( Map param, LoginVO user ) throws Exception {
		super.commonDao.update("hpe100ukrServiceImpl.fnSetCloseAll", param);
		return param;
    }
    
}
