package foren.unilite.modules.accnt.sf_cms;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.com.common.CMSIntfServiceImpl;


@Service("sf_cms330skrvService")
public class Sf_cms330skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger    logger  = LoggerFactory.getLogger(this.getClass());

	@Resource(name="cMSIntfService")
	private CMSIntfServiceImpl cMSIntfService;
	
	/**
	 * 은행 리스트 
	 * BCM100T 
	 * CUSTOM_TYPE = '4'
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getBankCode(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("sf_cms100skrvService.getBankCode", param);
	}
	
	/**
	 *  메인그리드 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetail(Map param, LoginVO loginVO) throws Exception {
		cMSIntfService.getCMSData(param, loginVO);
		return super.commonDao.list("sf_cms330skrvService.selectDetail", param);
	}

}
