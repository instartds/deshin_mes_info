package foren.unilite.modules.z_wm;

import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("s_ssa700skrv_wmService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Ssa700skrv_wmServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());



	/**
	 * 매출 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_ssa700skrv_wmServiceImpl.selectList", param);
	}

	/**
	 * 매입 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectList2(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_ssa700skrv_wmServiceImpl.selectList2", param);
	}

	/**
	 * 현금 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectList3(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_ssa700skrv_wmServiceImpl.selectList3", param);
	}

	/**
	 * 채권/채무 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectList4(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_ssa700skrv_wmServiceImpl.selectList4", param);
	}

	/**
	 * 현재고금액 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectList5(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_ssa700skrv_wmServiceImpl.selectList5", param);
	}
}