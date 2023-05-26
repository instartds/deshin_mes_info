package foren.unilite.modules.human.hpe;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("hpe600rkrService")
public class Hpe600rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 간이지급명세서(근로소득-마스터) 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpe")
	public List<Map<String, Object>> selectWorkPayPrintMaster( Map param ) throws Exception {
		return super.commonDao.list("hpe600rkrServiceImpl.selectWorkPayPrintMaster", param);
	}

	/**
	 * 간이지급명세서(근로소득-디테일) 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpe")
	public List<Map<String, Object>> selectWorkPayPrintDetail( Map param ) throws Exception {
		return super.commonDao.list("hpe600rkrServiceImpl.selectWorkPayPrintDetail", param);
	}

	/**
	 * 간이지급명세서(거주자사업소득-마스터) 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpe")
	public List<Map<String, Object>> selectBusiPayLiveInMaster( Map param ) throws Exception {
		return super.commonDao.list("hpe600rkrServiceImpl.selectBusiPayLiveInMaster", param);
	}

	/**
	 * 간이지급명세서(거주자사업소득-디테일) 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpe")
	public List<Map<String, Object>> selectBusiPayLiveInDetail( Map param ) throws Exception {
		return super.commonDao.list("hpe600rkrServiceImpl.selectBusiPayLiveInDetail", param);
	}

	/**
	 * 간이지급명세서(비거주자사업소득-마스터) 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpe")
	public List<Map<String, Object>> selectBusiPayLiveOutMaster( Map param ) throws Exception {
		return super.commonDao.list("hpe600rkrServiceImpl.selectBusiPayLiveOutMaster", param);
	}

	/**
	 * 간이지급명세서(비거주자사업소득-디테일) 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpe")
	public List<Map<String, Object>> selectBusiPayLiveOutDetail( Map param ) throws Exception {
		return super.commonDao.list("hpe600rkrServiceImpl.selectBusiPayLiveOutDetail", param);
	}
	
}
