package foren.unilite.modules.prodt.pbs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("pbs510ukrvService")
public class Pbs510ukrvServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 * 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {

		return  super.commonDao.list("pbs510ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectOpeningTime(Map param) throws Exception {

		return  super.commonDao.list("pbs510ukrvServiceImpl.selectOpeningTime", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectTimeInfoStore(Map param) throws Exception {

		return  super.commonDao.list("pbs510ukrvServiceImpl.selectTimeInfoStore", param);
	}
	
	/**
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramList:" + paramList);
		
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		List<Map> dataList = new ArrayList<Map>();
		
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			for(Map param:  dataList) {
				param.put("STD_DATE", dataMaster.get("STD_DATE"));
				param.put("OPENING_TIME", dataMaster.get("OPENING_TIME"));
//				 int b1 = ("true".equals(dataMaster.get("TIME1")) ? 50 : 40;
//				param.put("TIME1", dataMaster.get("TIME1"));
				
				logger.debug("[saveAll] param:" + param);
				
				super.commonDao.update("pbs510ukrvServiceImpl.update", param);
			}
		}

		paramList.add(0, paramMaster);
		return  paramList;
	}

}
