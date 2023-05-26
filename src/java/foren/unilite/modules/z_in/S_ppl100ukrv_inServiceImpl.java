package foren.unilite.modules.z_in;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_ppl100ukrv_inService")
public class S_ppl100ukrv_inServiceImpl  extends TlabAbstractServiceImpl {

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_in")
	public List<Map<String, Object>>  selectDetailList(Map param) throws Exception {
		return  super.commonDao.list("s_ppl100ukrv_inServiceImpl.selectDetailList", param);
	}

	/**
	 * saveall
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_in")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			//if(deleteList != null) this.deleteDetail(deleteList, user);
			//if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sof")
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		try {
			for(Map param : paramList )	{
				super.commonDao.update("s_ppl100ukrv_inServiceImpl.insertDetail", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return;
	}
	
	
}
