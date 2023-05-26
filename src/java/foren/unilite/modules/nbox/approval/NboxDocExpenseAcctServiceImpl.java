package foren.unilite.modules.nbox.approval;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("nboxDocExpenseAcctService")
public class NboxDocExpenseAcctServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
		
	/**
	 * 리스트 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "nbox")
	public Map selects(Map param) throws Exception {
		logger.debug("\n nboxDocExpenseAcctService.selects: {}", param );
		
		Map rv = new HashMap();
		List list = super.commonDao.list("nboxDocExpenseAcctService.selects", param);
		
		int totalCount = 0;
		if(list.size() > 0 ) {
			Map rec = (Map) list.get(0);
			totalCount = (Integer)rec.get("TOTALCOUNT");
		}
		
		rv.put("records", list);
		rv.put("total", totalCount);
		
		return rv;
	}
	
	/**
	 * 저장(추가,수정,삭제)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public boolean save(Map<String, Object> param,
			LoginVO user) throws Exception {
		
		List<String> NewRecords = (List)param.get("C");
		List<String> UpdateRecords = (List)param.get("U");
		List<String> RemoveRecords = (List)param.get("D");
		
		logger.debug("\n nboxDocExpenseAcctService.save NewRecords.length: {}",  NewRecords.size());
		logger.debug("\n nboxDocExpenseAcctService.save UpdateRecords.length: {}",  UpdateRecords.size());
		logger.debug("\n nboxDocExpenseAcctService.save RemoveRecords.length: {}",  RemoveRecords.size());
		
		if(RemoveRecords.size() > 0 ){
			List<Map<String, Object>> RemoveRecordList = stringArrayToListMap(RemoveRecords);
			
			for(Map<String, Object> record : RemoveRecordList) {
				record.put("S_COMP_CODE", user.getCompCode());
				record.put("S_USER_ID", user.getUserID());
				record.put("S_LANG_CODE", user.getLanguage());
				
				this.delete(record);
			}
		};
		
		if(UpdateRecords.size() > 0 ){
			List<Map<String, Object>> UpdateRecordList = stringArrayToListMap(UpdateRecords);
			
			for(Map<String, Object> record : UpdateRecordList) {
				record.put("S_COMP_CODE", user.getCompCode());
				record.put("S_USER_ID", user.getUserID());
				record.put("S_LANG_CODE", user.getLanguage());
				
				this.update(record);
			}
		};
		
		if(NewRecords.size() > 0 ){
			List<Map<String, Object>> NewRecordList = stringArrayToListMap(NewRecords);
			
			for(Map<String, Object> record : NewRecordList) {
				record.put("S_COMP_CODE", user.getCompCode());
				record.put("S_USER_ID", user.getUserID());
				record.put("S_LANG_CODE", user.getLanguage());
				
				this.insert(record);
			}
		};
		
		return true; 
	}
	
	/**
	 * 저장(추가)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public boolean insert(Map param) throws Exception {	
		logger.debug("\n nboxDocExpenseAcctService.insert: {}", param );
		super.commonDao.insert("nboxDocExpenseAcctService.insert", param);
				
		return true;
	}
	
	/**
	 * 저장(수정)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public boolean update(Map param) throws Exception {	
		logger.debug("\n nboxDocExpenseAcctService.update: {}", param );
		super.commonDao.update("nboxDocExpenseAcctService.update", param);
				
		return true;
	}
	
	/**
	 * 저장(삭제)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public boolean delete(Map param) throws Exception {	
		logger.debug("\n nboxDocExpenseAcctService.delete: {}", param );
		super.commonDao.delete("nboxDocExpenseAcctService.delete", param);
				
		return true;
	}
	
	private List<Map<String, Object>> stringArrayToListMap(String[] stringArray) throws Exception {
		logger.debug("\n nboxDocExpenseAcctService.strArrToListMap: {}", stringArray);
		
		List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
	
		for(String strTemp :stringArray )	{
			listMap.add(stringToMap(strTemp.replace((char)11, ',')));
		}
		
		return listMap;
	}
	
	private List<Map<String, Object>> stringArrayToListMap(List<String> stringArray) throws Exception {
		logger.debug("\n nboxDocExpenseAcctService.strArrToListMap: {}", stringArray);
		
		List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
	
		for(String strTemp :stringArray )	{
			listMap.add(stringToMap(strTemp.replace((char)11, ',')));
		}
		
		return listMap;
	}
		
	private Map<String, Object> stringToMap(String strTemp) throws Exception {
		logger.debug("\n nboxDocExpenseAcctService.strToMap: {}", strTemp);
		
		if (strTemp == null) return null;
		
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> mapObj = mapper.readValue(strTemp, new TypeReference<Map<String, Object>>() {});
		
		return mapObj;
	}
	
}
