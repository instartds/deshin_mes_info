package foren.unilite.modules.z_yp;

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
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;



@Service( "s_bcm105ukrv_ypService" )
@SuppressWarnings( { "unchecked", "rawtypes" } )
public class S_bcm105ukrv_ypServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	/**
	 * 메인 data 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */ 
	@ExtDirectMethod( group = "z_yp", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		
		return  super.commonDao.list("s_bcm105ukrv_ypServiceImpl.selectList", param);
	}
	
	/**
	 * 검색POPUP
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */ 
	@ExtDirectMethod( group = "z_yp", value = ExtDirectMethodType.STORE_READ )
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		
		return  super.commonDao.list("s_bcm105ukrv_ypServiceImpl.selectList2", param);
	}
	
	
	
	
	
	
	/** 저장 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "z_yp" )
	@Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
	public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
		
		if (paramList != null) {
			List<Map> insertDetail = null;
			List<Map> updateDetail = null;
			List<Map> deleteDetail = null;
			
			for (Map dataListMap : paramList) {
				if (dataListMap.get("method").equals("insertDetail")) {
					insertDetail = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("updateDetail")) {
					updateDetail = (List<Map>)dataListMap.get("data");
				} else if (dataListMap.get("method").equals("deleteDetail")) {
					deleteDetail = (List<Map>)dataListMap.get("data");
				}
			}
			if (deleteDetail != null) this.deleteDetail(deleteDetail, user, dataMaster);
			if (insertDetail != null) this.insertDetail(insertDetail, user, dataMaster);
			if (updateDetail != null) this.updateDetail(updateDetail, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		
		return paramList;
	}
	
	/** 추가 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
	public Integer insertDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		/* 데이터 insert */
		try {
			for (Map param : paramList) {
				super.commonDao.insert("s_bcm105ukrv_ypServiceImpl.insertDetail", param);
			}
		} catch (Exception e) {
			throw new UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}
	
	/** 수정 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
	public Integer updateDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("s_bcm105ukrv_ypServiceImpl.updateDetail", param);
		}
		return 0;
	}
	
	/** 삭제 **/
	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp" )
	public Integer deleteDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
		for (Map param : paramList) {
			try {
				super.commonDao.delete("s_bcm105ukrv_ypServiceImpl.deleteDetail", param);
				
			} catch (Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}
}
