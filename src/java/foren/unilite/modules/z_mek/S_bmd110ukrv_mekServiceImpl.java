package foren.unilite.modules.z_mek;

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
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("s_bmd110ukrv_mekService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_bmd110ukrv_mekServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)	/* 조회1 */
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("s_bmd110ukrv_mekService.selectMasterList", param);
	}
	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetail(Map param) throws Exception {
		return  super.commonDao.list("s_bmd110ukrv_mekService.selectDetailList", param);
	}



	/*
	 * Detail 등록
	 * 
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			List<Map> updateDetail = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail")) {
					updateDetail = (List<Map>)dataListMap.get("data");
				} 
			}
			if(updateDetail != null) this.updateDetail(updateDetail, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	/**
	 * Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map dataMaster) throws Exception {
		for(Map param :paramList )	{
			param.put("NEW_MODEL_UNI_CODE", dataMaster.get("MODEL_UNI_CODE"));
			if("1".equals(param.get("save"))) {
				super.commonDao.update("s_bmd110ukrv_mekService.updateDetail", param);
			} else if("0".equals(param.get("save"))) {
				super.commonDao.update("s_bmd110ukrv_mekService.deleteDetail", param);
			}
		} 
		return 0;
	}

	/**
	 * Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer deleteDetail(Map param, LoginVO user) throws Exception {
		super.commonDao.update("s_bmd110ukrv_mekService.deleteDetail", param);
		return 0;
	}
}