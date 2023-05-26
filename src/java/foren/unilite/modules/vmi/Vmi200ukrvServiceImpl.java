package foren.unilite.modules.vmi;

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
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;

import com.google.gson.Gson;

import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.sales.SalesCommonServiceImpl;


@Service("vmi200ukrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Vmi200ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	/**
	 * 납품예정정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "vmi")
	public List<Map> selectList(Map param) throws Exception{
		return super.commonDao.list("vmi200ukrvServiceImpl.selectList", param);
	}



	/**
	 * 납품예정정보 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "vmi")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)   {
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
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "vmi")
	public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.insert("vmi200ukrvServiceImpl.insertDetail", param);
		}
		return;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "vmi")
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )  {
			super.commonDao.update("vmi200ukrvServiceImpl.updateDetail", param);
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "vmi")
	public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList ) {
			 super.commonDao.delete("vmi200ukrvServiceImpl.deleteDetail", param);
		 }
		 return;
	}



}
