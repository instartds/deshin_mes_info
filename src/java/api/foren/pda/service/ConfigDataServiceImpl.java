package api.foren.pda.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import foren.framework.exception.UniDirectException;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("configDataService")
public class ConfigDataServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * po master list
	 */
	public List<Map> selectConfigDataList(Map param) throws UniDirectException {
		return super.commonDao.list("configDataServiceImpl.selectConfigDataList", param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public List<Map> saveConfigData(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		for (Map param : paramList) {
			if (param.get("DATA_CODE") != null) {
				Map map = (Map) super.commonDao.select("configDataServiceImpl.selectConfigDataList", param);
				if (map == null) {
					super.commonDao.insert("configDataServiceImpl.insertCode", param);
				} else {
					super.commonDao.update("configDataServiceImpl.updateCode", param);
				}
			}

		}

		return paramList;
	}

}
