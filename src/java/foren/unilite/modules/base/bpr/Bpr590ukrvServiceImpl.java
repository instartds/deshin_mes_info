package foren.unilite.modules.base.bpr;

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


@Service("bpr590ukrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Bpr590ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	/**
	 * 공정별 작업지시번호 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map> selectList(Map param) throws Exception{
		return super.commonDao.list("bpr590ukrvServiceImpl.selectList", param);
	}



	/**
	 * 공정별 작업지시번호 등록
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)   {
			
			Map paramMap = new HashMap();
			paramMap.put("S_COMP_CODE", user.getCompCode());
			
			Map checkAllDiv = (Map) super.commonDao.select("bpr590ukrvServiceImpl.checkAllDiv", paramMap);
		 
			String allDivYn = "N";
			
			if(ObjUtils.isNotEmpty(checkAllDiv)){
				allDivYn = ObjUtils.getSafeString(checkAllDiv.get("SUB_CODE"));
			}
			
			List<Map> allDivList = null;
			allDivList =  super.commonDao.list("bpr590ukrvServiceImpl.selectDivList", paramMap);
			
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
//				if(dataListMap.get("method").equals("deleteDetail")) {
//					deleteList = (List<Map>)dataListMap.get("data");
//				}else if(dataListMap.get("method").equals("insertDetail")) {
//					insertList = (List<Map>)dataListMap.get("data");
//				} else 
				if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
//			if(deleteList != null) this.deleteDetail(deleteList, user);
//			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user, allDivYn, allDivList);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}
	
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
//	public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {
//		for(Map param : paramList ) {
//			super.commonDao.insert("bpr590ukrvServiceImpl.insertDetail", param);
//		}
//		return;
//	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public void updateDetail(List<Map> paramList, LoginVO user, String allDivYn, List<Map> allDivList) throws Exception {
		for(Map param :paramList )  {
			
			if(allDivYn.equals("Y")){
				if(allDivList != null){
					for(Map addParams : allDivList){
						param.put("DIV_CODE", addParams.get("DIV_CODE"));
						super.commonDao.update("bpr590ukrvServiceImpl.updateDetail", param);
					}
				}
				
			}else{
				super.commonDao.update("bpr590ukrvServiceImpl.updateDetail", param);
			}
		}
		return;
	}

//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
//	public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
//		 for(Map param :paramList ) {
//			 super.commonDao.delete("bpr590ukrvServiceImpl.deleteDetail", param);
//		 }
//		 return;
//	}



}
