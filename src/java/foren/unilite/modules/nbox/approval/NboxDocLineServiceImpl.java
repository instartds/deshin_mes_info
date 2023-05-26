package foren.unilite.modules.nbox.approval;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("nboxDocLineService")
public class NboxDocLineServiceImpl extends TlabAbstractServiceImpl implements NboxDocLineService {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 결재라인 리스트 조회
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public Map selects(Map param) throws Exception {
		String filePath = ConfigUtil.getString("nbox.upload.sign");
		param.put("FILEPATH", filePath);
		
		logger.debug("\n selects: {}", param );
		
		Map rv = new HashMap();
		List list = super.commonDao.list("nboxDocLineService.selects", param);
		
		logger.debug("\n save nboxDocLineService.selects: {}", param );
		// 이중결재가 아닌 경우, 조회된 데이터가 없다면, 기안자 자신을 조회한다.
		if(param.get("SignType") != null && param.get("SignType").toString().equals("B") ){
			
		}else if(param.get("LineType") == null || param.get("LineType").toString().equals("A") ){
			if (list.size() == 0)
				list = super.commonDao.list("nboxDocLineService.selectEmpty", param);
		}
		
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
	public boolean save(LoginVO user, String DocumentID, List<Map<String, Object>> DocLineList) throws Exception {
		logger.debug("\n save nboxDocLineService.save: {}", DocLineList );
		
		if( DocLineList.size() > 0) {
			
			Map<String,Object> param = new HashMap<String,Object>();
			Map<String,Object> param1 = new HashMap<String,Object>();
			param.put("DocumentID", DocumentID);
			
			this.deletes(param);
			
			int Seq = 0 ;
			for(Map<String, Object> DocLine : DocLineList) {
				
				DocLine.put("SignFlag", "N");
				if( Seq == 0 )
					DocLine.put("SignFlag", "Y");
				
				DocLine.put("DocumentID", DocumentID);
				DocLine.put("S_COMP_CODE", user.getCompCode());
				DocLine.put("S_USER_ID", user.getUserID());
				DocLine.put("S_LANG_CODE", user.getLanguage());
				DocLine.put("Length", DocLineList.size());
				
				Seq++ ;
				
				DocLine.put("Seq", Seq);
				
				 _save(DocLine);
				
			}
			
		} 
		return true;
	}
	
	public boolean _save(Map<String,Object> param) throws Exception{
		logger.debug("\n nboxDocLineService.insert: {}", param );
		super.commonDao.insert("nboxDocLineService.insert", param);
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
		return (int)super.commonDao.delete("nboxDocLineService.deletes", param);
	}

}
