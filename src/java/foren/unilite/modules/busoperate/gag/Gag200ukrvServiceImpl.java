package foren.unilite.modules.busoperate.gag;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import javax.annotation.Resource;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.base.gdr.Gdr100ukrvServiceImpl;


@Service("gag200ukrvService")
public class Gag200ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@Resource(name="gdr100ukrvService")
	private Gdr100ukrvServiceImpl gdr100ukrvService;
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gag200ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "busoperate")
	public Object  selectCheckDriver(Map param) throws Exception {	
		return  super.commonDao.select("gag200ukrvServiceImpl.selectCheckDriver", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_SYNCALL)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map>  update(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		
		for(Map data :paramList )	{
			List<Map>dataList = (List<Map>)data.get("data");
			for(Map param :dataList )	{
				super.commonDao.update("gag200ukrvServiceImpl.save", param);	
				this.driverUpdate(param, param.get("FIXED_DRIVER1"), param.get("FIXED_DRIVER1_TEAM_CODE"),  user);
				this.driverUpdate(param, param.get("FIXED_DRIVER2"), param.get("FIXED_DRIVER2_TEAM_CODE"), user);
				this.driverUpdate(param, param.get("NOTFIXED_DRIVER1"), param.get("NOTFIXED_DRIVER1_TEAM_CODE"), user);
				this.driverUpdate(param, param.get("NOTFIXED_DRIVER2"), param.get("NOTFIXED_DRIVER2_TEAM_CODE"), user);
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	
	private void driverUpdate(Map param, Object driver, Object teamCode, LoginVO user) throws Exception {
		if(ObjUtils.isNotEmpty(driver))	{
			Map driverMap = new HashMap();
			driverMap.put("S_COMP_CODE", param.get("S_COMP_CODE"));
			driverMap.put("COMP_CODE", param.get("S_COMP_CODE"));
			driverMap.put("DIV_CODE", param.get("DIV_CODE"));
			driverMap.put("DRIVER_CODE", driver);
			
			List<Map<Object, String>> rList= gdr100ukrvService.selectList(driverMap);
			if(ObjUtils.isNotEmpty(rList))	{
				if(ObjUtils.isEmpty(rList.get(0).get("WORK_TEAM_CODE")))	{
					List<Map> paramList = new ArrayList<Map>();
					driverMap.put("WORK_TEAM_CODE", teamCode);
					paramList.add(driverMap);
					gdr100ukrvService.update(paramList, user);
				}
			}
		}
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  driverList(Map param) throws Exception {	
		return  super.commonDao.list("gag200ukrvServiceImpl.driverList", param);
	}
	
	@ExtDirectMethod(group = "busoperate")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}

}
