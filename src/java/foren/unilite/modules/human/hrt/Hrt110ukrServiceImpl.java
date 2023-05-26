package foren.unilite.modules.human.hrt;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import com.google.gson.Gson;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("hrt110ukrService")
public class Hrt110ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 연차수당, 퇴직금 콤보박스 내용을 조회함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectComboList01(Map param) throws Exception {
		return (List) super.commonDao.list("hrt110ukrServiceImpl.selectComboList01", param);
	}
	
	/**
	 * 우측 계산식분류 내용을 조회함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectComboList02(Map param) throws Exception {
		return (List) super.commonDao.list("hrt110ukrServiceImpl.selectComboList02", param);
	}
	
	/**
	 * 폼데이터를 조회함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hrt")
	public Map loadFormData(Map param) throws Exception {
		return (Map) super.commonDao.select("hrt110ukrServiceImpl.loadFormData", param);
	}
	
	/**
	 * 결과폼 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "hrt")
	public ExtDirectFormPostResult submitFormData(Hrt110ukrModel hrt110ukrModel, LoginVO loginVO, BindingResult result) throws Exception {
		hrt110ukrModel.setS_COMP_CODE(loginVO.getCompCode());
		hrt110ukrModel.setS_USER_ID(loginVO.getUserID());
		
		super.commonDao.update("hrt110ukrServiceImpl.submitFormData", hrt110ukrModel);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			
		return extResult;
	}
	
	/**
	 * 누진적용 기준을 조회함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList01(Map param) throws Exception {
		return (List) super.commonDao.list("hrt110ukrServiceImpl.selectList01", param);
	}
	
	/**
	 * 선택된 행을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hrt")
	public List<Map> insertList01(List<Map> paramList, LoginVO loginVO) throws Exception {
		
		for(Map param :paramList ) {
			super.commonDao.insert("hrt110ukrServiceImpl.insertList01", param);
		}
		return paramList;
	}
	
	/**
	 * 선택된 행을 수정함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hrt")
	public List<Map> updateList01(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("hrt110ukrServiceImpl.updateList01", param);
		}
		return paramList;
	}
	
	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hrt")
	public List<Map> deleteList01(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("hrt110ukrServiceImpl.deleteList01", param);
		}
		return paramList;
	}
	
	
	/**
	 * 임원 누진 적용기준을 조회함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList02(Map param) throws Exception {
		return (List) super.commonDao.list("hrt110ukrServiceImpl.selectList02", param);
	}
	
	/**
	 * 선택된 행을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hrt")
	public List<Map> insertList02(List<Map> paramList, LoginVO loginVO) throws Exception {
		
		for(Map param :paramList ) {
			super.commonDao.insert("hrt110ukrServiceImpl.insertList02", param);
		}
		return paramList;
	}
	
	/**
	 * 선택된 행을 수정함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hrt")
	public List<Map> updateList02(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("hrt110ukrServiceImpl.updateList02", param);
		}
		return paramList;
	}
	
	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hrt")
	public List<Map> deleteList02(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("hrt110ukrServiceImpl.deleteList02", param);
		}
		return paramList;
	}
	
	/**
	 * 계산식항목을 조회함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList03(Map param) throws Exception {
		return (List) super.commonDao.list("hrt110ukrServiceImpl.selectList03", param);
	}
	
	/**
	 * 계산식 반환용 데이터를 조합후 반환
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList04(Map param) throws Exception {
		// 반복용 계산식 데이터를 조회
		List datas = (List)super.commonDao.list("hrt110ukrServiceImpl.getListData" ,param);
		if (datas.size() > 0) {
			param.put("Datas", datas);
			param.put("loopIndex", datas.size());
			// 계산식 반환용 전체 데이터를 조회
			List totalDatas = (List)super.commonDao.list("hrt110ukrServiceImpl.getListTotalData" ,param);
			param.put("totalDatas", totalDatas);
		}
		List<Map<String, Object>> result = (List)super.commonDao.list("hrt110ukrServiceImpl.selectList04" ,param);
		return result;
	}
	
	
	/**
	 * 계산식을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hrt")
	public Object insertList04(String paramStr, LoginVO user) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		int r = 0;
		try {
			Gson gson = new Gson();
			Hrt110ukrModel[] hrt110ukrModelArray = gson.fromJson(paramStr, Hrt110ukrModel[].class);
			
			for (int i = 0; i < hrt110ukrModelArray.length; i ++) {
				r += super.commonDao.insert("hrt110ukrServiceImpl.insertList04", hrt110ukrModelArray[i]);
			}
		}catch (Exception e){
			r = 0;
			result.put("ErrorMessage", e.toString());	
		}
		result.put("rv", r);
		return result;
	}
	
		
	/**
	 * 선택된 행을 삭제함(계산식)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hrt")
	public List<Map> deleteList04(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("hrt110ukrServiceImpl.deleteList04", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(group = "hrt")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> saveAll02(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList02")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList02")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList02")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteList02(deleteList);
			if(insertList != null) this.insertList02(insertList, user);
			if(updateList != null) this.updateList02(updateList);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> saveAll04(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		
		if(paramList != null)	{
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList04")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}			
			if(deleteList != null) this.deleteList04(deleteList);		
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
}
	
