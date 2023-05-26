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
import foren.unilite.modules.nbox.approval.model.NboxDocLineModel;

@Service("nboxDocBasisService")
public class NboxDocBasisServiceImpl extends TlabAbstractServiceImpl implements NboxDocBasisService {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 근거문서 리스트 조회
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public Map selects(Map param) throws Exception {
		logger.debug("\n selects: {}", param );
		Map rv = new HashMap();
		List list = super.commonDao.list("nboxDocBasisService.selects", param);
		
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
	 * 근거문서 리스트 조회
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public Map selectByDoc(Map param) throws Exception {
		logger.debug("\n selectDocBasis: {}", param );
		Map rv = new HashMap();
		List list = super.commonDao.list("nboxDocBasisService.selectByDoc", param);
		
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
	public boolean save(LoginVO user, String DocumentID, List<Map<String, Object>> DocBasisList) throws Exception {
		logger.debug("\n save DOCBASIS.save: {}", DocBasisList );
		
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("DocumentID", DocumentID);
		
		this.deletes(param);
		
		if( DocBasisList.size() > 0) {
			
			for(Map<String, Object> DocBasis : DocBasisList) {
				
				DocBasis.put("DocumentID", DocumentID);
				DocBasis.put("S_COMP_CODE", user.getCompCode());
				DocBasis.put("S_USER_ID", user.getUserID());
				DocBasis.put("S_LANG_CODE", user.getLanguage());
				
				_save(DocBasis);
			}
		} 

		return true;
	}
	
	public boolean _save(Map<String,Object> param) throws Exception{
		super.commonDao.insert("nboxDocBasisService.insert", param);
		return true;
	}
	
	/**
	 *  문서의 근거문서 삭제
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public int deletes(Map param) throws Exception {
		logger.debug("\n deletes: {}", param );
		return (int)super.commonDao.delete("nboxDocBasisService.deletes", param);
	}
	
	

}
