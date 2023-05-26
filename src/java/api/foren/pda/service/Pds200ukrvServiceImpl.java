package api.foren.pda.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.exception.UniDirectException;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
/**
 * 박스패킹등록 箱包装注册
 * @author Administrator
 *
 */
@Service("pds200ukrvService")
public class Pds200ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectBoxDetailList(Map param) throws Exception {
		return super.commonDao.list("pds200ukrvServiceImpl.selectBoxDetailList", param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveBoxPakage(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		for(Map param: paramList) {			
			String oprFlag =  param.get("CRUD").toString();
//			Map map = (Map) super.commonDao.select("pds200ukrvServiceImpl.selectDataList", param);
			if( "D".equals(oprFlag)){
				super.commonDao.insert("pds200ukrvServiceImpl.deleteCode", param);
			}else{
				if("N".equals(oprFlag)){
					Map map = (Map) super.commonDao.select("pds200ukrvServiceImpl.selectDataList", param);
					if(map == null){
						super.commonDao.insert("pds200ukrvServiceImpl.insertCode", param);
					}
					
				}
				
			}
				
			
		}
		
		return  paramList;
	}
	

	
}
