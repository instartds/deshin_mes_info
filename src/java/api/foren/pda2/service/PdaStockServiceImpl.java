package api.foren.pda2.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pdaStockService")
@SuppressWarnings("unchecked")
public class PdaStockServiceImpl extends TlabAbstractServiceImpl {

	public List<Map<String, Object>> searchStock(Map<String, Object> params) {
		return super.commonDao.list("pdaStockService.searchStock", params);
	}

	public List<Map<String, Object>> searchCellStock(Map<String, Object> params) {
		return super.commonDao.list("pdaStockService.searchCellStock", params);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> saveReplace(Map<String, Object> params) {
		return (Map<String, Object>) super.commonDao.select("pdaStockService.saveReplace", params);
	}
}
