package foren.unilite.modules.human.hum;

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


@Service("hum110ukrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Hum110ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 엑셀 업로드한 인사기본자료 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List getSelectList(Map param) throws Exception {
		return (List)super.commonDao.list("hum110ukrServiceImpl.getSelectList" ,param);
	}
	
	/**
	 * UPLOAD 전 데이터 존재여부 체크
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public void excelValidate(String jobID, Map param) {
		logger.debug("validate: {}", jobID);
		List<Map> getData = (List<Map>) super.commonDao.list("hum110ukrServiceImpl.checkData", param);

		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData )  {
				param.put("PERSON_NUMB", data.get("PERSON_NUMB"));
			}
		}
	}
	

	/**
	 * 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보 
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");

		// 확정일 경우
		if(dataMaster != null && "Y".equals(dataMaster.get("CONFIRM_YN")) && paramList != null){
			List<Map> dataList = (List<Map>)paramList.get(0).get("data");
			this.confirmList(dataList);
			
		// 저장, 삭제
		} else if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteList(deleteList);
			if(insertList != null) this.insertList(insertList);
			if(updateList != null) this.updateList(updateList);
		}
		
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
	/**
	 * 추가
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public void insertList(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{
			 super.commonDao.insert("hum110ukrServiceImpl.insertList", param);
		}	
		return;
	}

	/**
	 * 수정
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public void updateList(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{
			 super.commonDao.update("hum110ukrServiceImpl.updateList", param);
		}	
		return;
	}

	/**
	 * 삭제
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public void deleteList(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{
			 super.commonDao.delete("hum110ukrServiceImpl.deleteList", param);
		}	
		return;
	}
	
	
	/**
	 * 인사마스터 반영
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public void confirmList(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{
			// insert 성공시 PROC_YN 컬럼에 Y세팅
			if(super.commonDao.insert("hum110ukrServiceImpl.insertHum100T", param) > 0){
				super.commonDao.update("hum110ukrServiceImpl.updateConfirm", param);
			}
		}	
		return;
	}
}