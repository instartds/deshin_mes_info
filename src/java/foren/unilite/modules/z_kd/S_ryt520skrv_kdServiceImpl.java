package foren.unilite.modules.z_kd;

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
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bor.Bor100ukrvModel;

@Service("s_ryt520skrv_kdService")
public class S_ryt520skrv_kdServiceImpl extends TlabAbstractServiceImpl {
    private final Logger    logger  = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "tlabMenuService")
     TlabMenuService tlabMenuService;
    /**
     *  조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    
    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)      // 조회(temp)
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("s_ryt520skrv_kdService.selectList", param);
    }
    
    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)      // 조회(temp)
    public List<Map<String, Object>> selectList2(Map param) throws Exception {
        return super.commonDao.list("s_ryt520skrv_kdService.selectList2", param);
    }

    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)      // 조회(temp)
    public List<Map<String, Object>> getMonthDiff(Map param) throws Exception {
        return super.commonDao.list("s_ryt520skrv_kdService.getMonthDiff", param);
    }
    
    /**
    *
    * 마스터 기안상태 조회
    * @param param
    * @return
    * @throws Exception
    */
   @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
   public List<Map<String, Object>> selectGwData(Map param) throws Exception {
       return super.commonDao.list("s_ryt520skrv_kdService.selectGwData", param);
   }
   
   /**
    *  기안버튼 눌렀을때 번호생성(UPDATE)
    *
    * @param param
    * @return
    * @throws Exception
    */
   @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)  /* 기안버튼 눌렀을때 번호생성(UPDATE) */
   public List<Map<String, Object>> makeDraftNum(Map param) throws Exception {
       return super.commonDao.list("s_ryt520skrv_kdService.makeDraftNum", param);
   }
   
   @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
   public List<Map<String, Object>> editMonth(Map param) throws Exception {
       return super.commonDao.list("s_ryt520skrv_kdService.editMonth", param);
   }
        
}