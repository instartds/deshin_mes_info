package foren.unilite.modules.matrl.mrp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("Mrp170ukrvService")
public class Mrp170ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")      // DEFAULT SETTING
    public Map<String, Object>  getMasterHead(Map param) throws Exception {  
        return  (Map<String, Object>) super.commonDao.select("Mrp170ukrvService.getMasterHead", param);
    }
	
	/**
	 * ROP 실행
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY,group = "matrl")     // 실행
    public Object procButton(Map param, LoginVO user) throws Exception {         // SP 로 실행
        Map errorMap = (Map) super.commonDao.select("Mrp170ukrvService.USP_MATRL_Mrp170ukrv", param);
        if(!ObjUtils.isEmpty(errorMap.get("errorDesc"))){
            String errorDesc = (String) errorMap.get("errorDesc");
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
        }else{
            return true;
        }       
    }
}
