package foren.unilite.modules.nbox.approval;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("nboxDocPathLineService")
public class NboxDocPathLineServiceImpl extends TlabAbstractServiceImpl implements NboxDocPathLineService {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 리스트 조회
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public Map selects(Map param, HttpServletRequest request) throws Exception {
		logger.debug("\n nboxDocPathLineService.selects : {}", param );
		
		Map rv = new HashMap();
		List list = super.commonDao.list("nboxDocPathLineService.selects", param);
		
		if(param.get("LineType").equals("A")){
			if( list.size() == 0 )
				list = super.commonDao.list("nboxDocPathLineService.emptySelects", param);
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
	public boolean save(LoginVO user, String PathID, String LineType, List<Map<String, Object>> dataList) throws Exception {
		logger.debug("\n save nboxDocPathLineService.save: {} dataList", dataList );
		
		if(dataList.size() > 0) {
			
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("PathID", PathID);
			param.put("LineType", LineType);
			super.commonDao.delete("nboxDocPathLineService.deletes", param);
			
			for(Map<String,Object> data : dataList){
				
				data.put("PathID", PathID);
				data.put("S_COMP_CODE", user.getCompCode());
				data.put("S_USER_ID", user.getUserID());
				data.put("S_LANG_CODE", user.getLanguage());
				
				_save(data);
			}
		}

		return true;
	}
	
	public boolean _save(Map<String,Object> param) throws Exception{
		super.commonDao.insert("nboxDocPathLineService.insert", param);
		return true;
	}
	
	
	/**
	 *  삭제
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public int deletes(Map param) throws Exception {
		logger.debug("\n deletes: {}", param );
		return (int)super.commonDao.delete("nboxDocPathLineService.deletes", param);
	}
}
