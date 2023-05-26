package foren.unilite.modules.prodt.pmr;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;

import com.google.gson.Gson;

import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.sales.SalesCommonServiceImpl;


@Service("wkordininfoukrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class WkordininfoukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	/**
	 * 공정코드, ip, status 값 받는 용
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @throws Exception
	 */
/*
	
	@RequestMapping(value = "/wkordSts", method = RequestMethod.GET)
	@ResponseBody
	public String wkordSts( Map param) throws Exception {

		super.commonDao.insert("wkordininfoukrvServiceImpl.wkordSts", param);
		
		return "OK";
	}
*/
	/**
	 * 공정별 작업지시번호 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> selectList(Map param) throws Exception{
		return super.commonDao.list("wkordininfoukrvServiceImpl.selectList", param);
	}



	/**
	 * 공정별 작업지시번호 등록
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
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
	
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
//	public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {
//		for(Map param : paramList ) {
//			super.commonDao.insert("wkordininfoukrvServiceImpl.insertDetail", param);
//		}
//		return;
//	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )  {
			if(ObjUtils.isEmpty(param.get("WKORD_NUM"))){
				super.commonDao.delete("wkordininfoukrvServiceImpl.deleteDetail", param);
			}else{
				super.commonDao.update("wkordininfoukrvServiceImpl.updateDetail", param);
			}
		}
		return;
	}

//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
//	public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
//		 for(Map param :paramList ) {
//			 super.commonDao.delete("wkordininfoukrvServiceImpl.deleteDetail", param);
//		 }
//		 return;
//	}



}
