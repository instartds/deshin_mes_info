package foren.unilite.modules.nbox.approval;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.nbox.approval.model.NboxDocCommentModel;

@Service("nboxDocCommentService")
public class NboxDocCommentServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 댓글 리스트 조회
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public Map selects(Map param) throws Exception {
		logger.debug("\n selects: {}", param );
		Map rv = new HashMap();
		List list = super.commonDao.list("nboxDocCommentService.selects", param);
		
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
	 *  댓글 조회
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public Map select(Map param) throws Exception {
		logger.debug("\n select: {}", param );
		Map rv = new HashMap();
		Map details = (Map) super.commonDao.select("nboxDocCommentService.select", param);
		
		rv.put("records", details);
		return rv;
	}
	
	/**
	 * 댓글 저장
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "nbox")
	public ExtDirectFormPostResult save(NboxDocCommentModel param, LoginVO user) throws Exception {
		ExtDirectFormPostResult resp = new ExtDirectFormPostResult(true);
		
		param.setS_USER_ID(user.getUserID());
		param.setS_COMP_CODE(user.getCompCode());
		param.setS_LANG_CODE(user.getLanguage());
		
		logger.debug("\n saveComment: {}", param );
		
		if( param.getSeq().isEmpty() || param.getSeq().equals(null))
			super.commonDao.insert("nboxDocCommentService.insert", param);
		else
			super.commonDao.update("nboxDocCommentService.update", param);
		
		return resp;
	}
	
	/**
	 *  문서의 댓글 삭제
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public int deletes(Map param) throws Exception {
		logger.debug("\n deletes: {}", param );
		return (int)super.commonDao.delete("nboxDocCommentService.deletes", param);
	}
	
	/**
	 *  댓글 삭제
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public int delete(Map param) throws Exception {
		logger.debug("\n nboxDocCommentService.delete: {}", param);
		return (int)super.commonDao.delete("nboxDocCommentService.delete", param);
	}

}
