package foren.unilite.modules.base.bsa;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service( "bsa580ukrvService" )
public class Bsa580ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 사용자별 법인 권한 등록 그리드1
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( group = "bsa", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> selectList( Map param ) throws Exception {
	    return super.commonDao.list("bsa580ukrvServiceImpl.selectList", param);
	}
	
	/**
	 * 사용자별 법인 권한 등록 그리드2
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( group = "bsa", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> selectListDetailAbove( Map param ) throws Exception {
	    return super.commonDao.list("bsa580ukrvServiceImpl.selectListDetailAbove", param);
	}
	
	/**
	 * 사용자별 법인 권한 등록 그리드3
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( group = "bsa", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> selectListDetailBelow( Map param ) throws Exception {
	    return super.commonDao.list("bsa580ukrvServiceImpl.selectListDetailBelow", param);
	}
	
	
	/** 저장 **/
	@SuppressWarnings( { "rawtypes", "unchecked" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "bsa" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		
		if (paramList != null) {
			List<Map> insertList = null;
			List<Map> deleteList = null;
			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
				else if (dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			if (deleteList != null) this.deleteDetail(deleteList, user, paramMaster);
			if (insertList != null) this.insertDetail(insertList, user, paramMaster);
		}
		paramList.add(0, paramMaster);
		
		return paramList;
	}
	
	@SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bsa" )
	public Integer insertDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		try {
			Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
			for (Map param : paramList) {
				param.put("USER_ID", dataMaster.get("USER_ID"));
				super.commonDao.update("bsa580ukrvServiceImpl.insertDetail", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}
	
	@SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bsa" )
	public Integer deleteDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		try {
			Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
			for (Map param : paramList) {
				param.put("USER_ID", dataMaster.get("USER_ID"));
				super.commonDao.update("bsa580ukrvServiceImpl.deleteDetail", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}

}
