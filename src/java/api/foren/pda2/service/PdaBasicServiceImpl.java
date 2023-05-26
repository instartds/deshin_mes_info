package api.foren.pda2.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pdaBasicService")
@SuppressWarnings("all")
public class PdaBasicServiceImpl extends TlabAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PdaBasicServiceImpl.class);

	public Map selectCaseSensitiveYN(Map<String, Object> params) {
		return (Map) super.commonDao.select("pdaBasicService.selectCaseSensitiveYN", params);
	}

	public List<Map> selectConfigList(Map<String, Object> params) {
		return super.commonDao.list("pdaBasicService.selectConfigList", params);
	}

	public List<Map> selectCommonInfoList(Map<String, Object> params) {
		return super.commonDao.list("pdaBasicService.selectCommonInfoList", params);
	}

	public Integer saveConfig(Map<String, Object> params) {
		return super.commonDao.update("pdaBasicService.updateConfigList", params);
	}

	public Map<String, Object> getStockItem(Map<String, Object> params) {
		return (Map<String, Object>) super.commonDao.select("pdaBasicService.getStockItem", params);
	}
	
	public Map<String, Object> getBaseItem(Map<String, Object> params) {
		return (Map<String, Object>) super.commonDao.select("pdaBasicService.getBasicItem", params);
	}
	
	public Map<String, Object> getUnApplyItemByCode(Map<String, Object> params) {
		return (Map<String, Object>) super.commonDao.select("pdaBasicService.getUnApplyItemByCode", params);
	}

	public List<Map> getPdaPgmInfoList(Map<String, Object> params) {
		return super.commonDao.list("pdaBasicService.getPdaPgmInfoList", params);
	}
	public List<Map> getWhcodeList(Map<String, Object> params) {
		return super.commonDao.list("pdaBasicService.getWhcodeList", params);
	}

}
