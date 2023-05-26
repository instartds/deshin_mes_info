package foren.unilite.modules.nbox.approval;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.nbox.approval.model.NboxDocPathModel;

@Service("nboxDocPathService")
public class NboxDocPathServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "nboxDocPathLineService")
	private NboxDocPathLineService nboxDocPathLineService;
	
	@Resource(name = "nboxDocPathRcvUserService")
	private NboxDocPathRcvUserService nboxDocPathRcvUserService;
	
	/**
	 * detail조회
	 * 
	 * @param param
	 * @return 
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "nbox")
	public Map select(Map param, HttpServletRequest request) throws Exception {
		logger.debug("\n nboxDocPathService.select : {}", param );
		
		/* Main Info */
		Map rv = new HashMap();
		Map details = (Map)super.commonDao.select("nboxDocPathService.select", param);

		rv.put("records", details);
		return rv;
	}
	
	/**
	 * 저장(추가,수정)
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "nbox")
	public ExtDirectFormPostResult save(
			NboxDocPathModel _docPath, 
			@RequestParam("DOCLINES") String[] DOCLINES, 
			@RequestParam("DOUBLELINES") String[] DOUBLELINES, 
			@RequestParam("RCVUSERS") String[] RCVUSERS,
			@RequestParam("REFUSERS") String[] REFUSERS,
			LoginVO user) throws Exception {
		
		logger.debug("\n save NboxDocPathModel : {}", _docPath );
		
		ExtDirectFormPostResult resp = new ExtDirectFormPostResult(true);
		
		_docPath.setS_USER_ID(user.getUserID());
		_docPath.setS_COMP_CODE(user.getCompCode());
		_docPath.setS_LANG_CODE(user.getLanguage());
		
		switch(_docPath.getActionType()){
			case "C":
			case "U":	
				// Master
				switch(_docPath.getActionType()){
					case "C":
						Map Object = (Map)super.commonDao.select("nboxDocPathService.createPathID",_docPath);
						_docPath.setPathID((String)Object.get("PathID"));
						super.commonDao.insert("nboxDocPathService.insert", _docPath);
						
						break;
					case "U":
						super.commonDao.update("nboxDocPathService.update", _docPath);
						break;
					default:
						break;
				}
				
				List<Map<String, Object>> DocLineList = stringArrayToListMap(DOCLINES);
				List<Map<String, Object>> DoubleLineList = stringArrayToListMap(DOUBLELINES);
				List<Map<String, Object>> RcvUserList = stringArrayToListMap(RCVUSERS);
				List<Map<String, Object>> RefUserList = stringArrayToListMap(REFUSERS);
				
				nboxDocPathLineService.save(user, _docPath.getPathID(), "A", DocLineList) ;
				nboxDocPathLineService.save(user, _docPath.getPathID(), "B", DoubleLineList) ;
				nboxDocPathRcvUserService.save(user, _docPath.getPathID(), "C", RcvUserList) ;
				nboxDocPathRcvUserService.save(user, _docPath.getPathID(), "R", RefUserList) ;
				
				break;
			case "D":
				Map<String,Object> param = new HashMap<String,Object>();
				param.put("PathID", _docPath.getPathID());
				
				super.commonDao.delete("nboxDocPathService.delete", param);
				param.put("LineType", "A");
				super.commonDao.delete("nboxDocPathLineService.deletes", param);
				param.put("LineType", "B");
				super.commonDao.delete("nboxDocPathLineService.deletes", param);
				param.put("RcvType", "C");
				super.commonDao.delete("nboxDocPathRcvUserService.deletes", param);
				param.put("RcvType", "R");
				super.commonDao.delete("nboxDocPathRcvUserService.deletes", param);
				
				break;
			default:
				break;
		}

		return resp; 
	}
	
	private List<Map<String, Object>> stringArrayToListMap(String[] stringArray) throws Exception {
		logger.debug("\n groupwareMenuService.strArrToListMap: {}", stringArray);
		
		List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
	
		for(String strTemp :stringArray )	{
			listMap.add(stringToMap(strTemp.replace((char)11, ',')));
		}
		
		return listMap;
	}
		
	private Map<String, Object> stringToMap(String strTemp) throws Exception {
		logger.debug("\n groupwareMenuService.strToMap: {}", strTemp);
		
		if (strTemp == null) return null;
		
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> mapObj = mapper.readValue(strTemp, new TypeReference<Map<String, Object>>() {});
		
		return mapObj;
	}

}
