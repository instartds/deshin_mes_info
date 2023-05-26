package foren.unilite.modules.z_kocis;

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


@Service("s_hrt110ukrService_KOCIS")
public class S_Hrt110ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 연차수당, 퇴직금 콤보박스 내용을 조회함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectComboList01(Map param) throws Exception {
		return (List) super.commonDao.list("s_hrt110ukrServiceImpl_KOCIS.selectComboList01", param);
	}
	
	/**
	 * 우측 계산식분류 내용을 조회함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectComboList02(Map param) throws Exception {
		return (List) super.commonDao.list("s_hrt110ukrServiceImpl_KOCIS.selectComboList02", param);
	}
	
	/**
	 * 폼데이터를 조회함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hrt")
	public Map loadFormData(Map param) throws Exception {
		return (Map) super.commonDao.select("s_hrt110ukrServiceImpl_KOCIS.loadFormData", param);
	}
	
	/**
	 * 결과폼 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "hrt")
	public ExtDirectFormPostResult submitFormData(S_Hrt110ukrModel_KOCIS s_hrt110ukrModel_KOCIS, LoginVO loginVO, BindingResult result) throws Exception {
		s_hrt110ukrModel_KOCIS.setS_COMP_CODE(loginVO.getCompCode());
		s_hrt110ukrModel_KOCIS.setS_USER_ID(loginVO.getUserID());
		
		super.commonDao.update("s_hrt110ukrServiceImpl_KOCIS.submitFormData", s_hrt110ukrModel_KOCIS);
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
		return (List) super.commonDao.list("s_hrt110ukrServiceImpl_KOCIS.selectList01", param);
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
			super.commonDao.insert("s_hrt110ukrServiceImpl_KOCIS.insertList01", param);
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
			super.commonDao.update("s_hrt110ukrServiceImpl_KOCIS.updateList01", param);
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
			super.commonDao.delete("s_hrt110ukrServiceImpl_KOCIS.deleteList01", param);
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
		return (List) super.commonDao.list("s_hrt110ukrServiceImpl_KOCIS.selectList02", param);
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
			super.commonDao.insert("s_hrt110ukrServiceImpl_KOCIS.insertList02", param);
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
			super.commonDao.update("s_hrt110ukrServiceImpl_KOCIS.updateList02", param);
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
			super.commonDao.delete("s_hrt110ukrServiceImpl_KOCIS.deleteList02", param);
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
		return (List) super.commonDao.list("s_hrt110ukrServiceImpl_KOCIS.selectList03", param);
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
		List datas = (List)super.commonDao.list("s_hrt110ukrServiceImpl_KOCIS.getListData" ,param);
		if (datas.size() > 0) {
			param.put("Datas", datas);
			param.put("loopIndex", datas.size());
			// 계산식 반환용 전체 데이터를 조회
			List totalDatas = (List)super.commonDao.list("s_hrt110ukrServiceImpl_KOCIS.getListTotalData" ,param);
			param.put("totalDatas", totalDatas);
		}
		List<Map<String, Object>> result = (List)super.commonDao.list("s_hrt110ukrServiceImpl_KOCIS.selectList04" ,param);
		return result;
	}
	
	
	/**
	 * 계산식을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hrt")
	public int insertList04(String paramStr) throws Exception {
		
		Gson gson = new Gson();
		S_Hrt110ukrModel_KOCIS[] hrt110ukrModelArray = gson.fromJson(paramStr, S_Hrt110ukrModel_KOCIS[].class);
		int result = 0;
		
		for (int i = 0; i < hrt110ukrModelArray.length; i ++) {
			result = super.commonDao.insert("s_hrt110ukrServiceImpl_KOCIS.insertList04", hrt110ukrModelArray[i]);
		}

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
			super.commonDao.delete("s_hrt110ukrServiceImpl_KOCIS.deleteList04", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(group = "hrt")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
	
	
}
	
