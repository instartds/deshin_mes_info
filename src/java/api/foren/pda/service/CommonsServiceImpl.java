package api.foren.pda.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import foren.framework.exception.UniDirectException;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("commonsService")
public class CommonsServiceImpl extends TlabAbstractServiceImpl {

	/**
	 * 获取出入库list列表
	 */
	public List<Map> searchAllComboboxList(Map param) throws UniDirectException {
		return super.commonDao.list("commonsService.searchAllComboboxList", param);
	}

	/**
	 * custom
	 * 
	 * @param param
	 * @return
	 * @throws UniDirectException
	 */
	public List<Map> selectCustomList(Map param) throws UniDirectException {
		return super.commonDao.list("commonsService.agentCustPopup", param);
	}

	public Map selectCaseSensitiveYN(Map param) throws UniDirectException {
		return (Map) super.commonDao.select("commonsService.selectCaseSensitiveYN", param);
	}

}
