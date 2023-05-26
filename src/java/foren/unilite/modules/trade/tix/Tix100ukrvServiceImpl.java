package foren.unilite.modules.trade.tix;

import java.util.ArrayList;
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
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service("tix100ukrvService")
public class Tix100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "trade")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("tix100ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "trade")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map>  saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);
		List<Map> dataList = new ArrayList<Map>();
		//List<List<Map>> resultList = new ArrayList<List<Map>>();
		for(Map paramData: paramList) {   
			String methodString=paramData.get("method").toString();
			dataList = (List<Map>) paramData.get("data");
			if(methodString=="insert"|methodString.equals("insert"))
			{
				for(Map param:  dataList) {
				
					Object object=super.commonDao.select("tix100ukrvServiceImpl.checkSerNo", param);
					if(!ObjUtils.isEmpty(object)){
						Integer checkSerNo=Integer.valueOf(object.toString())+1;
						param.put("CHARGE_SER", checkSerNo+1);
					}else{
						param.put("CHARGE_SER", 1);
					}
					super.commonDao.insert("tix100ukrvServiceImpl.saveAll", param);
				}
			}else if(methodString=="update"|methodString.equals("update"))
			{
				for(Map param:  dataList) {
					Map checkSlipMap = (Map)super.commonDao.select("tix100ukrvServiceImpl.checkSlip", param);
					if(checkSlipMap.containsKey("SLIP_YN") && checkSlipMap.get("SLIP_YN").equals("Y")) {
						throw new UniDirectValidateException(this.getMessage("54362", user));
					}
					
					super.commonDao.update("tix100ukrvServiceImpl.update", param);
				}
			}else if(methodString=="delete"|methodString.equals("delete")){
				for (Map param : dataList) {
					Map checkSlipMap = (Map)super.commonDao.select("tix100ukrvServiceImpl.checkSlip", param);
					if(checkSlipMap.containsKey("SLIP_YN") && checkSlipMap.get("SLIP_YN").equals("Y")) {
						throw new UniDirectValidateException(this.getMessage("54362", user));
					}
					
					super.commonDao.delete("tix100ukrvServiceImpl.delete", param);
				}
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	/**
	 * 수주  수정
	 */
	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params)		{
			super.commonDao.update("tix100ukrvServiceImpl.update", param);
		}		
		return params;
	}
	
	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete(List<Map> params, LoginVO user) throws Exception {
		return null;
	}
	
	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert(List<Map> params, LoginVO user) throws Exception {
		for(Map param: params)		{
			super.commonDao.insert("tix100ukrvServiceImpl.insert", param);
		}		
		return params;
	}
}
