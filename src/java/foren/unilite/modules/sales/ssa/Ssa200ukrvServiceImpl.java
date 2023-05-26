package foren.unilite.modules.sales.ssa;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("ssa200ukrvService")
public class Ssa200ukrvServiceImpl  extends TlabAbstractServiceImpl {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 선매출정산 마스터 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	

		return  super.commonDao.list("ssa200ukrvServiceImpl.selectList", param);
	}
	
	/**
	 * 선매출정산 디테일 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  detailList(Map param) throws Exception {
		return  super.commonDao.list("ssa200ukrvServiceImpl.detailList", param);
	}
	
	/**
	 * 선매출정산 저장
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {						
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
				if(updateList != null) this.updateDetail(updateList, user, paramMaster);			
			}			
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	/**
	 * 선매출정산 정산여부 N일시 저장
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */		
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer  updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		for(Map param : paramList )	{
			param.put("MDIV_CODE", dataMaster.get("MDIV_CODE"));
			param.put("MBILL_NUM", dataMaster.get("MBILL_NUM"));
			param.put("MBILL_SEQ", dataMaster.get("MBILL_SEQ"));
			param.put("MCREATE_LOC", dataMaster.get("MCREATE_LOC"));
			if("N".equals(param.get("STATUS"))){	//정산여부 아니오일시
				Object r = super.commonDao.queryForObject("ssa200ukrvServiceImpl.insertTypeN", param);
				if(!ObjUtils.isEmpty(r)){
					Map<String, Object>	rMap = (Map<String, Object>) r;
					if(!"".equals(rMap.get("ERROR_CODE")))	{
						String[] sErr = rMap.get("ERROR_CODE").toString().split(";");
						throw new UniDirectValidateException(this.getMessage(sErr[0], user));
					}
				}
				
			}else{									//정산여부 예일시
				Object r = super.commonDao.queryForObject("ssa200ukrvServiceImpl.insertTypeY", param);
				if(!ObjUtils.isEmpty(r)){
					Map<String, Object>	rMap = (Map<String, Object>) r;
					if(!"".equals(rMap.get("ERROR_CODE")))	{
						String[] sErr = rMap.get("ERROR_CODE").toString().split(";");
						throw new UniDirectValidateException(this.getMessage(sErr[0], user));
					}
				}							
			}					 
		}		
		return 0;
	}
	
	@ExtDirectMethod(group = "sales")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
	
}
