package foren.unilite.modules.sales.sat;

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
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service("sat100ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Sat100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("sat100ukrvServiceImpl.selectList", param);
	}

	@ExtDirectMethod(group = "sales")
	public Map<String, Object> selectDupPK(Map param) throws Exception {
		return (Map<String, Object>) super.commonDao.select("sat100ukrvServiceImpl.selectDupPK", param);
	}
	
	@ExtDirectMethod(group = "sales")
	public Map<String, Object> selectDupSerialNo(Map param) throws Exception {
		return (Map<String, Object>) super.commonDao.select("sat100ukrvServiceImpl.selectDupSerialNo", param);
	}
	
	@ExtDirectMethod(group = "sales")
	public List<Map<String, Object>> checkDelete(Map param) throws Exception {
		return super.commonDao.list("sat100ukrvServiceImpl.checkDelete", param);
	}

	/**
	 *  저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		List<Map> insert = null;
		List<Map> update = null;
		List<Map> delete = null;

		for(Map param: paramList) {
			if(param.get("method").equals("insert")) {
				insert = (List<Map>)param.get("data");
			} else if(param.get("method").equals("update")) {
				update = (List<Map>)param.get("data");
			} else if(param.get("method").equals("delete")) {
				delete = (List<Map>)param.get("data");
			}
		}
		
		if(delete != null) this.delete(delete, user, dataMaster);
		if(insert != null) this.insert(insert, user, dataMaster);
		if(update != null) this.update(update, user, dataMaster);

		paramList.add(0, paramMaster);

		return  paramList;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer insert(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param: paramList)		{
			super.commonDao.insert("sat100ukrvServiceImpl.insert", param);
		}
		return 0;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer update(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param: paramList)		{
			super.commonDao.update("sat100ukrvServiceImpl.update", param);
		}
		return 0;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void delete(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param: paramList)		{
			super.commonDao.update("sat100ukrvServiceImpl.delete", param);
		}
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer updateStatus(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param: paramList)		{
			super.commonDao.update("sat100ukrvServiceImpl.updateStatus", param);
		}
		return 0;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer updateStatus(Map param, LoginVO user) throws Exception {
		super.commonDao.update("sat100ukrvServiceImpl.updateStatus", param);
		return 0;
	}
}
