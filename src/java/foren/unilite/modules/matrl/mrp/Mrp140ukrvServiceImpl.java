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

@Service("mrp140ukrvService")
public class Mrp140ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")      // 계획년도의 주간 카렌더가 존재 하는지 확인
    public List<Map<String, Object>>  planYear(Map param) throws Exception {  
        return  super.commonDao.list("mrp140ukrvService.planYear", param);
    }
	
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")      // 초기값 구하기
//    public List<Map<String, Object>>  baseDate(Map param) throws Exception {  
//        return  super.commonDao.list("mrp140ukrvService.baseDate", param);
//    }
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")      // DEFAULT SETTING
    public List<Map<String, Object>>  defaultSet(Map param) throws Exception {  
        return  super.commonDao.list("mrp140ukrvService.defaultSet", param);
    }
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "matrl")      // 실행,삭제 버튼 클릭 
    public List<Map<String, Object>>  syncMaster(Map param) throws Exception {  
        return  super.commonDao.list("mrp140ukrvService.syncMaster", param);
    }

	
	//    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")      // 계획기간FR 바꿀때
//    public List<Map<String, Object>>  planDateFrSet(Map param) throws Exception {  
//        return  super.commonDao.list("mrp140ukrvService.planDateFrSet", param);
//    }
//	
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")      // 1~16주까지 구하기
//    public List<Map<String, Object>>  selectWeek(Map param) throws Exception {  
//        return  super.commonDao.list("mrp140ukrvService.selectWeek", param);
//    }
//	
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")      // 탭1
//    public List<Map<String, Object>>  selectList1(Map param) throws Exception { 
//	    List<Map> sYear = (List<Map>) super.commonDao.list("mrp140ukrvService.selectYear", param);
//	    for(int i=0; i<sYear.size(); i++){
//	        param.put("sYear"+i, sYear.get(i).get("SYEAR"));
//	    }
//        List<Map> sWeek = (List<Map>) super.commonDao.list("mrp140ukrvService.selectWeek", param);
//	    for(int i=0; i<sWeek.size(); i++){
//            param.put("sWeek"+i, sWeek.get(i).get("CAL_NO"));
//        }
//        List<Map> refCode = (List<Map>) super.commonDao.list("mrp140ukrvService.selectRefCode", param);
//        if(refCode.isEmpty()) {
//            param.put("USE_CUSTOM", "N");
//        } else {
//            param.put("USE_CUSTOM", refCode.get(0).get("REF_CODE1"));
//        }
//	    return  super.commonDao.list("mrp140ukrvService.selectList1", param);
//    }
//	
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")      // 탭2
//    public List<Map<String, Object>>  selectList2(Map param) throws Exception { 
//        List<Map> refCode = (List<Map>) super.commonDao.list("mrp140ukrvService.selectRefCode", param);
//        if(refCode.isEmpty()) {
//            param.put("USE_CUSTOM", "N");
//        } else {
//            param.put("USE_CUSTOM", refCode.get(0).get("REF_CODE1"));
//        }
//        return  super.commonDao.list("mrp140ukrvService.selectList2", param);
//    }
//	
//	
//	
}
