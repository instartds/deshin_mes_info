package foren.unilite.modules.prodt.pip;

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


@Service("pip100ukrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Pip100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	/**
	 * 원단재고정보 데이터체크
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> checkDataP200(Map param) throws Exception{
		return super.commonDao.list("pip100ukrvServiceImpl.checkDataP200", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public String deleteAllLogic(Map param) throws Exception {
		String rtnV = "";
		super.commonDao.delete("pip100ukrvServiceImpl.deleteAllLogic", param);
		
		rtnV = "Y";
		return rtnV;
	}



	/**
	 * 원단품목 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> subSelectList(Map param) throws Exception{
		return super.commonDao.list("pip100ukrvServiceImpl.subSelectList", param);
	}

	/**
	 * 원단재고정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> p200SelectList(Map param) throws Exception{
		return super.commonDao.list("pip100ukrvServiceImpl.p200SelectList", param);
	}

	/**
	 * 참조:재고 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> ref1SelectList(Map param) throws Exception{
		return super.commonDao.list("pip100ukrvServiceImpl.ref1SelectList", param);
	}

	/**
	 * 절단 소요량정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> p100SelectList(Map param) throws Exception{
		return super.commonDao.list("pip100ukrvServiceImpl.p100SelectList", param);
	}

	/**
	 * 참조:소요량 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> ref2SelectList(Map param) throws Exception{
		return super.commonDao.list("pip100ukrvServiceImpl.ref2SelectList", param);
	}

	/**
	 * 최적화결과 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map> selectList(Map param) throws Exception{
		return super.commonDao.list("pip100ukrvServiceImpl.selectList", param);
	}



	/**
	 * 원단재고정보 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> p200SaveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
/*		Map map=(Map) super.commonDao.select("pip100ukrvServiceImpl.existMaster", dataMaster);
		if(map==null){
			super.commonDao.insert("pip100ukrvServiceImpl.insertMaster", dataMaster);
		}else{
			super.commonDao.update("pip100ukrvServiceImpl.updateMaster", dataMaster);
		}*/
		
		if(paramList != null)   {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("p200DeleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("p200InsertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("p200UpdateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.p200DeleteDetail(deleteList, user);
			if(insertList != null) this.p200InsertDetail(insertList, user);
			if(updateList != null) this.p200UpdateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public void p200InsertDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.insert("pip100ukrvServiceImpl.p200InsertDetail", param);
		}
		return;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public void p200UpdateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )  {
			super.commonDao.update("pip100ukrvServiceImpl.p200UpdateDetail", param);
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public void p200DeleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList ) {
			 super.commonDao.delete("pip100ukrvServiceImpl.p200DeleteDetail", param);
		 }
		 return;
	}



	/**
	 * 절단소요량정보 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> p100SaveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
	/*	Map map=(Map) super.commonDao.select("pip100ukrvServiceImpl.existMaster", dataMaster);
		if(map==null){
			super.commonDao.insert("pip100ukrvServiceImpl.insertMaster", dataMaster);
		}else{
			super.commonDao.update("pip100ukrvServiceImpl.updateMaster", dataMaster);
		}*/

		if(paramList != null)   {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("p100DeleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("p100InsertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("p100UpdateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.p100DeleteDetail(deleteList, user);
			if(insertList != null) this.p100InsertDetail(insertList, user);
			if(updateList != null) this.p100UpdateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public void p100InsertDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.insert("pip100ukrvServiceImpl.p100InsertDetail", param);
		}
		return;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public void p100UpdateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )  {
			super.commonDao.update("pip100ukrvServiceImpl.p100UpdateDetail", param);
		}
		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public void p100DeleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {
			 super.commonDao.delete("pip100ukrvServiceImpl.p100DeleteDetail", param);
		}
		return;
	}



	/**
	 * 최적화계산 SP
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public String optimizingCutOff (Map param, LoginVO user) throws Exception {
		String rtnV = "N";
		Map<String, Object> spParam = new HashMap<String, Object>();
		
		//CreateType = paramData.get("CREATE_LOC");

		spParam.put("COMP_CODE"	, user.getCompCode());
		spParam.put("DIV_CODE"	, param.get("DIV_CODE"));
		spParam.put("ITEM_CODE"	, param.get("ITEM_CODE"));
		spParam.put("EXEC_CNT"	, param.get("EXEC_CNT"));
		spParam.put("USER_ID", user.getUserID());

		super.commonDao.queryForObject("pip100ukrvServiceImpl.spOptimizingCutOff", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
			if(errorDesc.equals("82007;")) {
				rtnV = this.getMessage(messsage[0], user);
				
			} else {
				throw new UniDirectValidateException(this.getMessage(messsage[0], user));
			}
		} else {
			rtnV = "Y";
		}

		return rtnV;
	}



	/**
	 * 작업지시 버튼 로직
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> wkordSaveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		if(paramList != null) {
			List<Map> wkordInsertDetail = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("wkordInsertDetail")) {
					wkordInsertDetail = (List<Map>)dataListMap.get("data");
				}
			}
			if(wkordInsertDetail != null) this.wkordInsertDetail(wkordInsertDetail, user);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public void wkordInsertDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			//20181220 - 제이월드 재단작업지시 로직 호출 (정규로 쓰려면 공통코드로 구분해서 다른 로직 호출하는 기능 필요)
			Object r = super.commonDao.queryForObject("pip100ukrvServiceImpl.insertPMP", param);
			
			if(!ObjUtils.isEmpty(r)){
				Map<String, Object>	rMap = (Map<String, Object>) r;
				if(!"".equals(rMap.get("ERROR_CODE")))	{
//					String[] sErr = rMap.get("ERROR_CODE").toString().split(";");
					throw new UniDirectValidateException(rMap.get("ERROR_CODE").toString());
				}
			}
		}
		return;
	}
}
