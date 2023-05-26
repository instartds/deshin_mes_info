package foren.unilite.modules.sales.sea;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("sea300skrvService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class Sea300skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 조회팝업 쿼리
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> searchPopupList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("sea300skrvServiceImpl.searchPopupList", param);
	}

	/**
	 * 원재료  데이터 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectDetail(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("sea300skrvServiceImpl.selectDetail", param);
	}

	/**
	 * 임가공비 데이터 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectDetail2(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("sea300skrvServiceImpl.selectDetail2", param);
	}


	/**
	 * 집계항목 데이터 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectDetail3(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("sea300skrvServiceImpl.selectDetail3", param);
	}

}