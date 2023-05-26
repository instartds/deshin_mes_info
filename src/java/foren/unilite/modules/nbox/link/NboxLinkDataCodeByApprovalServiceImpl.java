package foren.unilite.modules.nbox.link;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("nboxLinkDataCodeByApprovalService")
public class NboxLinkDataCodeByApprovalServiceImpl extends TlabAbstractServiceImpl implements NboxLinkDataCodeByApprovalService  {
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
		logger.debug("\n nboxLinkDataCodeByApprovalService.selects: {}", param );
		
		Map rv = new HashMap();
		List list = super.commonDao.list("nboxLinkDataCodeByApprovalService.selects", param);
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
	public boolean save( LoginVO user, String DocumentID, List<Map<String, Object>> LinkDataList) throws Exception{
		logger.debug("\n save nboxLinkDataCodeByApprovalService.save: {}", LinkDataList );
		
		if( LinkDataList.size() > 0) {
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("S_COMP_CODE",user.getCompCode());
			param.put("DocumentID", DocumentID);
			
			this.deletes(param);
			
			for(Map<String, Object> LinkData : LinkDataList) {
				
				LinkData.put("DocumentID", DocumentID);
				LinkData.put("DataID", (String)LinkData.get("id"));
				LinkData.put("DataValue", (String)LinkData.get("value"));
				LinkData.put("DataValueName", (String)LinkData.get("rawValue"));
				
				LinkData.put("S_COMP_CODE", user.getCompCode());
				LinkData.put("S_USER_ID", user.getUserID());
				LinkData.put("S_LANG_CODE", user.getLanguage());
				
				_save(LinkData);
			}
		} 

		return true;
		
	}
	
	public boolean _save(Map<String,Object> param) throws Exception{
		super.commonDao.insert("nboxLinkDataCodeByApprovalService.insert", param);
		return true;
	}
	
	/**
	 *  문서의 삭제
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	
	@ExtDirectMethod(group = "nbox")
	public int deletes(Map param) throws Exception {
		logger.debug("\n deletes: {}", param );
		return (int)super.commonDao.delete("nboxLinkDataCodeByApprovalService.deletes", param);
	}
	
}
