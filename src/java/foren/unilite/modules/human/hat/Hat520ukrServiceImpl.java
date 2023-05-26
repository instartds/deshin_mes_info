package foren.unilite.modules.human.hat;

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


@Service("hat520ukrService")
public class Hat520ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 일근태현황조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("hat520ukrServiceImpl.selectDataList", param);
	}
	
	/**
	 * 근태코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hat", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> getDutyList(Map param) throws Exception {
		return (List)super.commonDao.list("hat520ukrServiceImpl.getDutyList" ,param);
	}

	/**
	 * 근태구분 콤보박스 리스트 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getComboList(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("hat520ukrServiceImpl.getComboList", param);
	}

	/**
	 * 근무조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "hat", value = ExtDirectMethodType.STORE_READ)
	public Object getWorkTeam(Map param) throws Exception {
		return super.commonDao.select("hat520ukrServiceImpl.getWorkTeam", param);
	}
	/*public String getWorkTeam(Map param) throws Exception {
		String rv = "fail";
		try {
			rv = super.commonDao.queryForObject("hat520ukrServiceImpl.getWorkTeam" ,param).toString();
		} catch (NullPointerException e) {
			logger.debug("No data!!");
			return rv;
		}
		return rv;
	}*/
	/**
	 * 일근태시간등록 저장
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
			if(insertList != null) this.insertList(insertList, user);
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
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hat")
	public List<Map> insertList(List<Map> paramList, LoginVO user) throws Exception {
		try{
			for(Map param :paramList ) {
				super.commonDao.insert("hat520ukrServiceImpl.insertList", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}	
		return paramList;
	}
	
	/**
	 * 선택된 행을 수정함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hat")
	public List<Map> updateList(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("hat520ukrServiceImpl.updateList", param);
		}
		return paramList;
	}
	
	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hat")
	public List<Map> deleteList(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("hat520ukrServiceImpl.deleteList", param);
		}
		return paramList;
	}
	
	
}
