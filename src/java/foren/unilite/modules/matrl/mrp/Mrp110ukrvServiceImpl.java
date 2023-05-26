package foren.unilite.modules.matrl.mrp;

import java.util.ArrayList;
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

@Service("Mrp110ukrvService")
public class Mrp110ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")      // 미확정 전환오더 존재 체크
    public Map<String, Object>  checkMrpData(Map param) throws Exception {  
        return  (Map<String, Object>) super.commonDao.select("Mrp110ukrvService.checkMrpData", param);
    }
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")      // 계획년도의 주간 카렌더가 존재 하는지 확인
    public List<Map<String, Object>>  planYear(Map param) throws Exception {  
        return  super.commonDao.list("Mrp110ukrvService.planYear", param);
    }
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")      // 계획기간 구하기
    public List<Map<String, Object>>  baseDate(Map param) throws Exception {  
        return  super.commonDao.list("Mrp110ukrvService.baseDate", param);
    }
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")      // 재고 및 값 반영 여부
    public List<Map<String, Object>>  baseYN(Map param) throws Exception {  
        return  super.commonDao.list("Mrp110ukrvService.baseYN", param);
    }	
	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")      // mrp 전개(실행)
    public List<Map<String, Object>>  spCall(Map param) throws Exception {  
        return  super.commonDao.list("Mrp110ukrvService.spCall", param);
    }           
}
