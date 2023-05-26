package foren.unilite.modules.z_wm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;

import com.google.gson.Gson;

import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_esa100rkrv_wmService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Esa100rkrv_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * detailGrid 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map> selectList(Map param) throws Exception{
		return super.commonDao.list("s_esa100rkrv_wmServiceImpl.selectList", param);
	}



	/**
	 * AS 요청서 출력(MASTER)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map<String, Object>> printASMasterData(Map param) throws Exception{
		return super.commonDao.list("s_esa100rkrv_wmServiceImpl.printASMasterData", param);
	}

	/**
	 * AS 요청서 출력(DETAIL)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map<String, Object>> printASDetailData(Map param) throws Exception{
		return super.commonDao.list("s_esa100rkrv_wmServiceImpl.printASDetailData", param);
	}

	/**
	 * AS 요청서 출력(상담내역)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List<Map<String, Object>> printASOutLineData(Map param) throws Exception{
		return super.commonDao.list("s_esa100rkrv_wmServiceImpl.printASOutLineData", param);
	}
}