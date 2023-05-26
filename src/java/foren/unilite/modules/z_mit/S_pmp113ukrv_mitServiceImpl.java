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


@Service("s_pmp113ukrv_mitService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_pmp113ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 자재소요량 마스터 정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception{
		return super.commonDao.list("s_pmp113ukrv_mitServiceImpl.selectMasterList", param);
	}	

	/**
	 * 자재소요량 디테일 정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception{
		return super.commonDao.list("s_pmp113ukrv_mitServiceImpl.selectDetailList", param);
	}





	/**
	 * 엑셀업로드 체크로직
	 * @param jobID
	 * @param param
	 * @throws Exception
	 */
	public void excelValidate(String jobID, Map param) throws Exception {	// 엑셀 Validate
		return;
	}

	/**
	 * 소요량 계산로직
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map<String, Object>> calcRequirement (Map param) throws Exception{
		return super.commonDao.list("s_pmp113ukrv_mitServiceImpl.calcRequirement", param);
	}
}