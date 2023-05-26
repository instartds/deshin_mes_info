package foren.unilite.modules.human.hat;

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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hat510ukrService")
public class Hat510ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	private String DutyRule = "";
	
	/**
	 * 근태 기준 조회 (Y: 출퇴근 시간, N: 근무 시간)
	 * @param comp_code
	 * @return
	 * @throws Exception
	 */
	public String getDutyRule(String comp_code) throws Exception{
		DutyRule = (String) super.commonDao.selectByPk("hat500ukrServiceImpl.getDutyRule", comp_code);
		return DutyRule;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List getDutycodeTime(Map param) throws Exception {
		return (List)super.commonDao.list("hat510ukrServiceImpl.getDutycodeTime" ,param);
	}
	
	/**
	 * 직위 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map getPostName(Map param) throws Exception {
		Map result = (Map) super.commonDao.select("hat510ukrServiceImpl.getPostName", param);
		return result;
	}
	
	/** ----------미사용----------
	 * 전체 근태코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List getAllDutycode(Map param) throws Exception {
		return (List)super.commonDao.list("hat500ukrServiceImpl.getAllDutycode" ,param);
	}
	
	/**
	 * 근태코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
	public List getDutycode(Map param) throws Exception {
		return (List)super.commonDao.list("hat500ukrServiceImpl.getDutycode" ,param);
	}
	
	/**
	 * 근태코드 콤보박스 리스트 조회
	 * @param param
	 * @return
	 * @throws Ex
	 * ception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
	public List getComboList(Map param) throws Exception {
		return (List)super.commonDao.list("hat510ukrServiceImpl.getComboList" ,param);
	}
	
	/**
	 * 근태 등록 목록 조회
	 * 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {
		
		List dutyCode = getDutycode(param);		
		param.put("DUTY_CODE", dutyCode);
		logger.debug(param+"");
		return (List) super.commonDao.list("hat510ukrServiceImpl.selectList", param);
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
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteList(deleteList);
			if(updateList != null) this.updateList(updateList);				
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
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hat")
	public List<Map> updateList(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{
			if (DutyRule != "") {
				if (DutyRule.equals("Y")) {
					if(param.get("FLAG").equals("N")){
						//if(!ObjUtils.isEmpty(param.get("DUTY_FR_D")) && !ObjUtils.isEmpty(param.get("DUTY_TO_D"))){
							super.commonDao.update("hat510ukrServiceImpl.insertList_DutyRule_Y", param);
							param.put("FLAG", "");
						//}
					}else{
						super.commonDao.update("hat510ukrServiceImpl.updateList_DutyRule_Y", param);
					}					
				} else {
					// 1.기존의 데이터를 모두 삭제
					super.commonDao.delete("hat510ukrServiceImpl.deleteList_DutyRule_N", param);
					// 2. 새로운 데이터를 다시 인서트 함
					param.put("DUTY_RULE", DutyRule);
					List<Map> dutyCode = getDutycode(param);
					for (Map item : dutyCode) {
						Map map = new HashMap();
						String index = (String) item.get("SUB_CODE");
						map.put("DUTY_YYYYMMDD", param.get("DUTY_YYYYMMDD"));
						map.put("PERSON_NUMB", param.get("PERSON_NUMB"));
						map.put("WORK_TEAM", param.get("WORK_TEAM"));
						map.put("S_USER_ID", param.get("S_USER_ID"));
						map.put("S_COMP_CODE", param.get("S_COMP_CODE"));
						map.put("DUTY_CODE", index);
						map.put("DUTY_NUM", param.get("TIMEN"+index).toString());
						map.put("DUTY_TIME", param.get("TIMET"+index).toString());
						map.put("DUTY_MINU", param.get("TIMEM"+index).toString());
						super.commonDao.insert("hat510ukrServiceImpl.insertList_DutyRule_N01", map);
					}
					// 3. 등록 안 된 근태 0값으로 인서트함
					super.commonDao.insert("hat510ukrServiceImpl.insertList_DutyRule_N02", param);
					// 4. 근태코드가 입력 된 경우 DUTY_NUM을 1로 수정함
					
					if (param.get("NUMN").equals("1") && param.get("NUMC") != "") {
						super.commonDao.update("hat510ukrServiceImpl.updateList_DutyRule_N", param);
					}
				}
			}
		}
		return paramList;
	}
	
	/**
	 * 근무조 삭제
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hat")
	public List<Map> deleteList(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{
			if (DutyRule != "") {
				if (DutyRule.equals("Y")) {
					super.commonDao.update("hat510ukrServiceImpl.deleteList_DutyRule_Y", param);
				} else {
					super.commonDao.update("hat510ukrServiceImpl.deleteList_DutyRule_N", param);
				}
			}
		}
		return paramList;
	}
	
	// sync All
	@ExtDirectMethod(group = "hat")
	public Integer syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return 0;
	}
	
}
