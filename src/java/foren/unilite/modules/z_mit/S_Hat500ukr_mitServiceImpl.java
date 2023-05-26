package foren.unilite.modules.z_mit;

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


@Service("s_hat500ukr_mitService")
public class S_Hat500ukr_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	private String DutyRule = "";
	
	/**
	 * 근태 기준 조회 (Y: 출퇴근 시간, N: 근무 시간)
	 * @param comp_code
	 * @return
	 * @throws Exception
	 */
	public String getDutyRule(String comp_code) throws Exception{
		DutyRule = (String) super.commonDao.selectByPk("s_hat500ukr_mitServiceImpl.getDutyRule", comp_code);
		return DutyRule;
	}
	
	/** ----------미사용----------
	 * 전체 근태코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List getAllDutycode(Map param) throws Exception {
		return (List)super.commonDao.list("s_hat500ukr_mitServiceImpl.getAllDutycode" ,param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List getDutycodeTime(Map param) throws Exception {
		return (List)super.commonDao.list("s_hat500ukr_mitServiceImpl.getDutycodeTime" ,param);
	}
	
	/**
	 * 근태코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List getDutycode(Map param) throws Exception {
		return (List)super.commonDao.list("s_hat500ukr_mitServiceImpl.getDutycode" ,param);
	}
	
	/**
	 * 근태코드 콤보박스 리스트 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
//	public List getComboList(Map param) throws Exception {
//		return (List)super.commonDao.list("s_hat500ukr_mitServiceImpl.getComboList" ,param);
//	}
	/**
	 * 근태구분 콤보박스 리스트 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getComboList(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("s_hat500ukr_mitServiceImpl.getComboList", param);
		
	}
	
	/**
	 * 근태구분 콤보박스 리스트 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getComboList2(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("s_hat500ukr_mitServiceImpl.getComboList2", param);
		
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
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {
		
		List dutyCode = getDutycode(param);		
		param.put("DUTY_CODE", dutyCode);
		logger.debug(param+"");
		return (List) super.commonDao.list("s_hat500ukr_mitServiceImpl.selectList", param);
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
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> updateList(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{
			if (DutyRule != "") {
				if (DutyRule.equals("Y")) {
					if(param.get("FLAG").equals("N")){
						super.commonDao.update("s_hat500ukr_mitServiceImpl.insertList_DutyRule_Y", param);
					}else{
						super.commonDao.update("s_hat500ukr_mitServiceImpl.updateList_DutyRule_Y", param);
					}
					
				} else {
					// 1.기존의 데이터를 모두 삭제
					super.commonDao.delete("s_hat500ukr_mitServiceImpl.deleteList_DutyRule_N", param);
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
						super.commonDao.insert("s_hat500ukr_mitServiceImpl.insertList_DutyRule_N01", map);
					}
					// 3. 등록 안 된 근태 0값으로 인서트함
					super.commonDao.insert("s_hat500ukr_mitServiceImpl.insertList_DutyRule_N02", param);
					// 4. 근태코드가 입력 된 경우 DUTY_NUM을 1로 수정함
					
					if (param.get("NUMN").equals("1") && param.get("NUMC") != "") {
						super.commonDao.update("s_hat500ukr_mitServiceImpl.updateList_DutyRule_N", param);
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
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> deleteList(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{
			if (DutyRule != "") {
				if (DutyRule.equals("Y")) {
					super.commonDao.update("s_hat500ukr_mitServiceImpl.deleteList_DutyRule_Y", param);
				} else {
					super.commonDao.update("s_hat500ukr_mitServiceImpl.deleteList_DutyRule_N", param);
				}
			}
		}
		return paramList;
	}
}
