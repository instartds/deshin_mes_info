package foren.unilite.modules.human.hat;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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


@Service("hat420ukrService")
public class Hat420ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 조기출근계획/승인등록 조회
	 * 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {		
//		param.put("DIFF", (List) super.commonDao.list("hat420ukrServiceImpl.duty_yyyymmdd", param));		
		
		String arr[] = param.toString().split(",");		
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
		
		return (List) super.commonDao.list("hat420ukrServiceImpl.selectList", param);		
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
				if(dataListMap.get("method").equals("deleteHat420t")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateHat420t")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteHat420t(deleteList);
			if(updateList != null) this.updateHat420t(updateList);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 조기출근계획/승인등록 입력 및 수정	
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> updateHat420t(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{
			String arr[] = param.toString().split(",");
			for(int i=0;i<arr.length;i++){
				System.out.println(arr[i]);
			}
			
			if(param.get("FLAG").equals("N")){
				super.commonDao.update("hat420ukrServiceImpl.insert", param);
			}else{
				super.commonDao.update("hat420ukrServiceImpl.update", param);
			}
					
		}
		return paramList;
	}
	
	/**
	 * 조기출근계획/승인등록 삭제
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> deleteHat420t(List<Map> paramList) throws Exception {
		
		for(Map param :paramList )	{
			super.commonDao.update("hat420ukrServiceImpl.delete", param);
		}
		return paramList;
	}
	
	// sync All
//	@ExtDirectMethod(group = "hat")
//	public Integer syncAll(Map param) throws Exception {
//		logger.debug("syncAll:" + param);
//		return  0;
//	}
}
