package foren.unilite.modules.coop.cpa;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("cpa310ukrvService")
public class Cpa310ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.STORE_READ)			// 조회쿼리
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("cpa310ukrvService.selectMasterList", param);
	}
	
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.STORE_READ)			// 조회쿼리2
	public List<Map<String, Object>> selectMaster2(Map param) throws Exception {
		return super.commonDao.list("cpa310ukrvService.selectMasterList2", param);
	}
	
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.STORE_READ)			// 저장전 확인
	public List<Map<String, Object>> selectMaster3(Map param) throws Exception {
		return super.commonDao.list("cpa310ukrvService.selectMasterList3", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "coop")
	 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	 public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		super.commonDao.queryForObject("cpa310ukrvService.updateCpa300t", dataMaster);
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 출고 Detail 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
		
		return params;
	}
	
	/**
	 * 출고 Detail 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		
		return params;
	}
	
	/**
	 * 출고 Detail 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
	
	}
	
	
}
