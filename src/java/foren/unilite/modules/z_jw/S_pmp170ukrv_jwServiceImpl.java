package foren.unilite.modules.z_jw;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_pmp170ukrv_jwService")
public class S_pmp170ukrv_jwServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 작업호기/시간 관리 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_jw")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("s_pmp170ukrv_jwServiceImpl.selectList", param);
	}
	/**
	 * 작업호기/시간 관리 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_jw")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		List<Map> dataList = new ArrayList<Map>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			if(paramData.get("method").equals("updateDetail"))	
				this.updateDetail(dataList, dataMaster, user);
		}

		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(group = "z_jw", value = ExtDirectMethodType.STORE_MODIFY)
	private void updateDetail(List<Map> paramList, Map paramMaster, LoginVO user) {
		for(Map param :paramList )	{
			super.commonDao.update("s_pmp170ukrv_jwServiceImpl.updateDetail", param);
		}
		return;
	}
}
