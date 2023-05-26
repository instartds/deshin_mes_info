package foren.unilite.modules.nbox.approval;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("nboxDocExpenseDetailService")
public class NboxDocExpenseDetailServiceImpl extends TlabAbstractServiceImpl implements NboxDocExpenseDetailService {
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
		logger.debug("\n selects: {}", param );
		
		Map rv = new HashMap();
		List list =super.commonDao.list("nboxDocExpenseDetailService.selects", param);
		
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
	 * 추가
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public boolean insert(LoginVO user, String DocumentID, List<Map<String, Object>> DocExpenseDetailList) throws Exception {
		logger.debug("\n _expenseDetail.size : {}", DocExpenseDetailList.size() );
		
		if( DocExpenseDetailList.size() > 0) {
			for(Map<String, Object> DocExpenseDetail : DocExpenseDetailList){
				
				DocExpenseDetail.put("DocumentID", DocumentID);
				DocExpenseDetail.put("S_COMP_CODE", user.getCompCode());
				DocExpenseDetail.put("S_LANG_CODE", user.getLanguage());
				DocExpenseDetail.put("S_USER_ID", user.getUserID());
				
				_insert(DocExpenseDetail);
			}
		}
		
		return true; 
	}
	
	public int _insert(Map<String, Object> DocExpenseDetail) throws Exception {
		
		int r = super.commonDao.insert("nboxDocExpenseDetailService.insert", DocExpenseDetail);
		return r; 
	}
	
	/**
	 * 수정
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public boolean update(LoginVO user, List<Map<String, Object>> DocExpenseDetailList) throws Exception {

		logger.debug("\n _expenseDetail.size : {}", DocExpenseDetailList.size() );
		
		if( DocExpenseDetailList.size() > 0) {
			for(Map<String, Object> DocExpenseDetail : DocExpenseDetailList){
				
				DocExpenseDetail.put("S_COMP_CODE", user.getCompCode());
				DocExpenseDetail.put("S_LANG_CODE", user.getLanguage());
				DocExpenseDetail.put("S_USER_ID", user.getUserID());
				
				_update(DocExpenseDetail);
			}
		}
		
		return true;  
	}
	
	public int _update(Map<String, Object> DocExpenseDetail) throws Exception {
		int r = super.commonDao.insert("nboxDocExpenseDetailService.update", DocExpenseDetail);
		return r; 
	}
	
	/**
	 * 삭제
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public boolean delete(LoginVO user, List<Map<String, Object>> DocExpenseDetailList) throws Exception {

		logger.debug("\n _expenseDetail.size : {}", DocExpenseDetailList.size() );
		
		if( DocExpenseDetailList.size() > 0) {
			
			for(Map<String, Object> DocExpenseDetail : DocExpenseDetailList){
				
				DocExpenseDetail.put("S_COMP_CODE", user.getCompCode());
				DocExpenseDetail.put("S_LANG_CODE", user.getLanguage());
				DocExpenseDetail.put("S_USER_ID", user.getUserID());
				
				_delete(DocExpenseDetail);
			}
		}
		
		return true;  
	}
	
	public int _delete(Map<String, Object> DocExpenseDetail) throws Exception {
		int r = super.commonDao.insert("nboxDocExpenseDetailService.delete", DocExpenseDetail);
		return r; 
	}
}
