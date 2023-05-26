package foren.unilite.modules.pos.prm;

import java.util.ArrayList;
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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("prm100ukrvService")
public class Prm100ukrvServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@ExtDirectMethod(group = "pos", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  selectPromo(Map param) throws Exception {
	
		return  super.commonDao.list("prm100ukrvServiceImpl.selectPromo", param);
	}
	
	@ExtDirectMethod(group = "pos", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("prm100ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "pos")
	public Object chkItem(Map param) throws Exception {
	
		return  super.commonDao.select("prm100ukrvServiceImpl.chkItem", param);
	}
	
	@ExtDirectMethod(group = "pos", value = ExtDirectMethodType.STORE_SYNCALL)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		List<Map> dataList = new ArrayList<Map>();
		if(paramList != null)	{
			for(Map param: paramList) {
				
				if(param.get("method").equals("delete"))  param.put("data", delete((List<Map>)param.get("data")) );  
				if(param.get("method").equals("insert"))  {
					List<Map> insertList = insert((List<Map>)param.get("data"));
					param.put("data",  insertList);	
					if(insertList.size() > 0)	{
						
						dataMaster.put("PROMO_CD", ObjUtils.getSafeString(insertList.get(0).get("PROMO_CD")));
					}
				}
				if(param.get("method").equals("update"))  param.put("data", update((List<Map>)param.get("data")) );	
				
			}
		}	
		paramList.add(0, paramMaster);
		return  paramList;
	}	
	
	@ExtDirectMethod(group = "pos", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  delete(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			super.commonDao.update("prm100ukrvServiceImpl.deleteList", param);
			param.put("PROMO_YYYY","");
			param.put("PROMO_CD","");
			param.put("MIX_NATCH_TYPE","");
			updateBpr200(param);
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "pos", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  insert(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			Map r = (Map)super.commonDao.queryForObject("prm100ukrvServiceImpl.insertList", param);	
			if(ObjUtils.isEmpty(param.get("PROMO_CD")))	{
				logger.debug("@@@@@@@@@@@@@@@@@@@@@    PROMO_CD :{}", r.get("PROMO_CD"));
				for(Map keyparam :paramList )	{
					keyparam.put("PROMO_CD", r.get("PROMO_CD"));
				}
			}
			updateBpr200(param);		
			
		}
		return  paramList;
	}
	
	@ExtDirectMethod(group = "pos", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map>  update(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			super.commonDao.update("prm100ukrvServiceImpl.updateList", param);	
			updateBpr200(param);
		}
		return  paramList;
	}
	
	private void updateBpr200(Map param)	{		
		if(ObjUtils.isNotEmpty(param.get("ITEM_CODE")) && "2". equals(ObjUtils.getSafeString( param.get("PROMO_CLASS") ) ) )	{  //혼합할인(PROMO_CLASS = "2")인 경우만 실행
			super.commonDao.update("prm100ukrvServiceImpl.updateBpr200", param);	
		}
	}
	
}
