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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("hat400ukrService")
public class Hat400ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 근무조현황 목록 조회
	 * 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list("hat400ukrServiceImpl.selectList", param);
	}
	
	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteHat400t")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateHat400t")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteHat400t(deleteList);
			if(updateList != null) this.updateHat400t(updateList);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 근무조 등록 / 업데이트	
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> updateHat400t(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{
			if (param.get("FLAG").toString().equals("U")) {
				super.commonDao.update("hat400ukrServiceImpl.update_exist", param);
			} else {
				super.commonDao.update("hat400ukrServiceImpl.update", param);
			}
			param.put("FLAG", "U");
		}
		return paramList;
	}
		
	/**
	 * 근무조 일괄 등록
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public void  workBatch(Map param, LoginVO user) throws Exception {
		super.commonDao.update("hat400ukrServiceImpl.workBatch", param);		
	}
	
	/**
	 * 근무조 삭제
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> deleteHat400t(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{
			if (param.get("FLAG").toString().equals("U")) {
				super.commonDao.delete("hat400ukrServiceImpl.delete", param);
			}
		}	
		return paramList;
	}
	
	/**
	 * 근무조 전체삭제
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> deleteAllHat400t(List<Map> paramList) throws Exception {		
		for(Map param :paramList )	{			
			super.commonDao.delete("hat400ukrServiceImpl.deleteAll", param);			
		}	
		return paramList;
	}
	
}
