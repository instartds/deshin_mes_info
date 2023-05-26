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

@Service("nboxDocRcvUserService")
public class NboxDocRcvUserServiceImpl extends TlabAbstractServiceImpl implements NboxDocRcvUserService {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 참조/수신  리스트 조회
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public Map selects(Map param) throws Exception {
		logger.debug("\n selectRcvUsers: {}", param );
		Map rv = new HashMap();
		List list = super.commonDao.list("nboxDocRcvUserService.selects", param);
		
		rv.put("records", list);
		
		return rv;
	}	
	
	
	/**
	 * 저장(추가,수정)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public boolean save(LoginVO user, String DocumentID, String RcvType, List<Map<String, Object>> RcvUserList) throws Exception {
		logger.debug("\n save nboxDocRcvUserService.save: {}", RcvType );
		logger.debug("\n save nboxDocRcvUserService.save: {}", RcvUserList );
		
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("DocumentID", DocumentID);
		param.put("RcvType", RcvType);
		
		this.deletes(param);
		
		if( RcvUserList.size() > 0) {
			
			for(Map<String, Object> RcvUser: RcvUserList) {
				
				RcvUser.put("DocumentID", DocumentID);
				RcvUser.put("RcvType", RcvType);
				
				RcvUser.put("S_COMP_CODE", user.getCompCode());
				RcvUser.put("S_USER_ID", user.getUserID());
				RcvUser.put("S_LANG_CODE", user.getLanguage());
				
				_save(RcvUser);
			}
		} 

		return true;
	}
	
	public boolean _save(Map<String,Object> param) throws Exception{
		super.commonDao.insert("nboxDocRcvUserService.insert", param);
		return true;
	}
	
	
	/**
	 *  문서의 결재라인 삭제
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public int deletes(Map param) throws Exception {
		logger.debug("\n deletes: {}", param );
		return (int)super.commonDao.delete("nboxDocRcvUserService.deletes", param);
	}
	
	@ExtDirectMethod(group = "nbox")
	public Map selectReadCheck(Map param) throws Exception {
		logger.debug("\n selectReadCheck.param : {}", param );
		
		Map rv = new HashMap();
		List list =super.commonDao.list("nboxDocRcvUserService.selectReadCheck", param);
		
		int totalCount = 0;
		if(list.size() > 0 ) {
			Map rec = (Map) list.get(0);
			totalCount = (Integer)rec.get("TOTALCOUNT");
		}
		
		rv.put("records", list);
		rv.put("total", totalCount);
		
		return rv;
	}	
}
