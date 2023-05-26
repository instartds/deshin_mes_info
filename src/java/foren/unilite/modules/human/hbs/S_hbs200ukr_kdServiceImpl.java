package foren.unilite.modules.human.hbs;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_hbs200ukr_kdService")
public class S_hbs200ukr_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 금호봉 탭 컬럼 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List getColumnData(String comp_code) throws Exception {
		return (List)super.commonDao.list("s_hbs200ukr_kdServiceImpl.getColumnData" ,comp_code);
	}
	
	/**
	 * 급호봉조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		
		List wages_codeList = getColumnData(param.get("S_COMP_CODE").toString());		
		param.put("WAGES_CODE", wages_codeList);
		
		return (List) super.commonDao.list("s_hbs200ukr_kdServiceImpl.selectList", param);
	}
	
	/**
	 * 급호봉등록  저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hbs")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteList(deleteList);
			if(insertList != null) this.insertList(insertList,user);		
			if(updateList != null) this.updateList(updateList);	
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 선택된 행을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")
	public List<Map> insertList(List<Map> paramList, LoginVO user) throws Exception {				
		for(Map param :paramList ) {
			List<Map> stdCodeList = (List)super.commonDao.list("s_hbs200ukr_kdServiceImpl.getColumnData", param);
			for(Map stdParam :stdCodeList ) {
				param.put("WAGES_CODE", stdParam.get("WAGES_CODE"));
				param.put("WAGES_I", param.get("STD" + stdParam.get("WAGES_CODE")));
				super.commonDao.insert("s_hbs200ukr_kdServiceImpl.insertList", param);
			}			
		}
		return paramList;
	}
	
	/**
	 * 선택된 행을 수정함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")
	public List<Map> updateList(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			List<Map> stdCodeList = (List)super.commonDao.list("s_hbs200ukr_kdServiceImpl.getColumnData", param);
			for(Map stdParam :stdCodeList ) {
				param.put("WAGES_CODE", stdParam.get("WAGES_CODE"));
				param.put("WAGES_I", param.get("STD" + stdParam.get("WAGES_CODE")));
				super.commonDao.insert("s_hbs200ukr_kdServiceImpl.updateList", param);
			}			
		}
		return paramList;
	}
	

	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")
	public List<Map> deleteList(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.list("s_hbs200ukr_kdServiceImpl.deleteList", param);
		}
		return paramList;
	}	
	

}
