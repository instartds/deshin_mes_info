package foren.unilite.modules.human.heg;

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


@Service("heg150ukrService")
@SuppressWarnings({"unchecked", "rawtypes"})
public class Heg150ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	java.util.Calendar cal = java.util.Calendar.getInstance();
	
	/**
	 * 해외출장등록 조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("heg150ukrServiceImpl.selectList", param);
	}
	

	
	

	/**
	 * 해외출장등록 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
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
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> insertList(List<Map> paramList, LoginVO user) throws Exception {
		try{
			for(Map param :paramList) {
				//신청번호 자동채번 로직 (년도 뒤 2자리 + 개월 + 순번)
				String newBasisNum	= "";
				String year			= ObjUtils.getSafeString(cal.get( cal.YEAR )).substring(2, 4);
				String month		= ObjUtils.getSafeString(cal.get( cal.MONTH ) + 1) ;
				if(month.length() == 1) {
					month = '0' + month;
				}
				String basisNum	= year + month;
				param.put("FIND_BASIS_NUM", basisNum);
				
				String getMaxSeq = (String) super.commonDao.select("heg150ukrServiceImpl.getMaxSeq", param);
				newBasisNum = ObjUtils.getSafeString((ObjUtils.parseInt(getMaxSeq) + 1));
				
				param.put("BASIS_NUM", newBasisNum);
				
				
				super.commonDao.insert("heg150ukrServiceImpl.insertList", param);
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
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> updateList(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("heg150ukrServiceImpl.updateList", param);
		}
		return paramList;
	}
	
	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> deleteList(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("heg150ukrServiceImpl.deleteList", param);
		}
		return paramList;
	}
	
	
}
