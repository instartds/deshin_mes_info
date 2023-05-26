package foren.unilite.modules.zDevelopPractice;

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


@Service("practice8Service")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Practice8ServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	/**
	 * 공정별 작업지시번호 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public List<Map> selectList(Map param) throws Exception{
		return super.commonDao.list("practice8ServiceImpl.selectList", param);
	}



	/**
	 * 공정별 작업지시번호 등록
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)   {
			
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
			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}
	
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
//	public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {
//		for(Map param : paramList ) {
//			super.commonDao.insert("sof130ukrvServiceImpl.insertDetail", param);
//		}
//		return;
//	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )  {
			
			super.commonDao.update("practice8ServiceImpl.updateDetail", param);

		}
		return;
	}

//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
//	public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
//		 for(Map param :paramList ) {
//			 super.commonDao.delete("sof130ukrvServiceImpl.deleteDetail", param);
//		 }
//		 return;
//	}



}
