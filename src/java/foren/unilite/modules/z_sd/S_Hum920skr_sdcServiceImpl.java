package foren.unilite.modules.z_sd;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_hum920skr_sdcService")
public class S_Hum920skr_sdcServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 사원조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map<String, Object>> selectDataList(Map param) throws Exception {
		
		return (List) super.commonDao.list("s_hum920skr_sdcService.selectDataList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map<String, Object>> selectList(Map param, LoginVO user) throws Exception {
		
		String checkTable = "HUM100T";
		
		Map checkRejoining = new HashMap();
		checkRejoining.put("S_COMP_CODE", user.getCompCode());
		
		Map<String, Object> chkYN = null;
		chkYN = (Map<String, Object>)super.commonDao.select("s_hum920skr_sdcService.checkRejoiningYn", checkRejoining);
		
		if(!ObjUtils.isEmpty(chkYN)){   
			if(chkYN.get("REF_CODE1").equals("Y")){
				checkTable = "HUM100TV";
			}else{
				checkTable = "HUM100T";
			}
		}
		param.put("CHECK_REJOINING", checkTable);
		
		return (List) super.commonDao.list("s_hum920skr_sdcService.selectList", param);
	}


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map<String, Object>> checkLicenseTab(Map param) throws Exception {
		
		return (List) super.commonDao.list("s_hum920skr_sdcService.checkLicenseTab", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map<String, Object>> checkOnlyHuman(Map param) throws Exception {
		
		return (List) super.commonDao.list("s_hum920skr_sdcService.checkOnlyHuman", param);
	}
	
}
