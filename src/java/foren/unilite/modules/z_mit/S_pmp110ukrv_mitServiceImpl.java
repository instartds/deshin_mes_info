package foren.unilite.modules.z_mit;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.z_yp.S_bcm100ukrv_ypModel;


@Service("s_pmp110ukrv_mitService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_pmp110ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	/**
	 * 레포트 데이터 유무 체크
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public Map dataCheck(Map param) throws Exception{
		return (Map) super.commonDao.select("s_pmp110ukrv_mitServiceImpl.dataCheck", param);
	}
	
	/**
	 * 레포트 타입 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public Map selectFormType(Map param) throws Exception{
		return (Map) super.commonDao.select("s_pmp110ukrv_mitServiceImpl.selectFormType", param);
	}
	
	/**
	 * SUB ASS'Y 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList1(Map param) throws Exception{
		return super.commonDao.list("s_pmp110ukrv_mitServiceImpl.selectList1", param);
	}	
	
	/**
	 * 소요자재 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList1_2(Map param) throws Exception{
		return super.commonDao.list("s_pmp110ukrv_mitServiceImpl.selectList1_2", param);
	}
	/**
	 * 중간검사성적서 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList2(Map param) throws Exception{
		return super.commonDao.list("s_pmp110ukrv_mitServiceImpl.selectList2", param);
	}
	

	
	/**
	 * 소요자재 조회 B
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList2_B(Map param) throws Exception{
		return super.commonDao.list("s_pmp110ukrv_mitServiceImpl.selectList2_B", param);
	}
	
	
	
	/**
	 * 태그 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectList_t(Map param) throws Exception{
		return super.commonDao.list("s_pmp110ukrv_mitServiceImpl.selectList_t", param);
	}	
	
}
