package api.foren.pda2.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("pdaModelService")
public class PdaModelServiceImpl extends TlabAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PdaStockInServiceImpl.class);

	public Map<String, Object> searchModel(Map<String, Object> params) {
		return (Map<String, Object>) super.commonDao.select("pdaModelService.selectModel", params);
	}

	public List<Map<String, Object>> searchModelItems(Map<String, Object> params) {
		return super.commonDao.list("pdaModelService.selectModelItems", params);
	}

}
