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


@Service("s_sof103skrv_wmService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_Sof103skrv_wmServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());



	/**
	 * 주문 조회(WM) - SOF110T
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_sof103skrv_wmServiceImpl.selectList", param);
	}

	/**
	 * 주문 조회(WM) - S_SOF115T_WM
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectList2(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_sof103skrv_wmServiceImpl.selectList2", param);
	}
}