package foren.unilite.modules.matrl.mpo;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mpo151rkrvService")
public class Mpo151rkrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 수주현황- 품목별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("mpo151rkrvServiceImpl.selectList", param);
	}

	/**
	 * 구매계획서 마스터
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")
	public List<Map<String, Object>>  selectMasterList(Map param) throws Exception {
		return  super.commonDao.list("mpo151rkrvServiceImpl.selectMasterList", param);
	}
	
	/**
	 *  저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null) {
			List<Map> updateList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				} 
			}
			if(updateList != null) this.updateList(updateList,  dataMaster);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "matrl")
	public void  updateList(List<Map> paramList, Map<String, Object> dataMaster) throws Exception {
		for(Map<String, Object> param : paramList)	{
		  
		  param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
		  super.commonDao.update("mpo151rkrvServiceImpl.updatePrintYn", param);
		}
	}
}
