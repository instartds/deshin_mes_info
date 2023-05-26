package api.foren.pda2.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
 
@SuppressWarnings("unchecked")
@Service("pdaCommonService")
public class PdaCommonServiceImpl extends TlabAbstractServiceImpl {

	public List<Map> getCommonCodeList(Map<String, Object> params) {
		return super.commonDao.list("pdaCommonService.getCommonCodeList", params);
	}
	
	public List<Map> getWhcodeList(Map<String, Object> params) {
		return super.commonDao.list("pdaCommonService.getWhcodeList", params);
	}
	public List<Map<String, Object>> searchWorkShop(Map<String, Object> params) {
		return super.commonDao.list("pdaCommonService.searchWorkShop", params);
	}
	public Map<String, Object> searchStockQ(Map<String,Object> params){
		return (Map<String, Object>) super.commonDao.select("pdaCommonService.searchStockQ",params);
	}

	
}
