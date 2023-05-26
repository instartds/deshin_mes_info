package foren.unilite.modules.z_kd;

import java.util.List;
import java.util.Map;

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


@Service("s_mtr902skrv_kdService")
public class S_mtr902skrv_kdServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 디테일조회  
     * @param param
     * @return
     * @throws Exception
     */
    @Transactional(readOnly = true)
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return (List) super.commonDao.list("s_mtr902skrv_kdServiceImpl.selectList", param);
    }
    
    /**
     * 
     * 기안번호 검색
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectDraftNo(Map param) throws Exception {
        return super.commonDao.list("s_mtr902skrv_kdServiceImpl.selectDraftNo", param);
    }
    
    /**
     * 
     * 마스터 기안상태 조회
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectGwData(Map param) throws Exception {
        return super.commonDao.list("s_mtr902skrv_kdServiceImpl.selectGwData", param);
    }
    
    /**
     *  기안버튼 눌렀을때 번호생성(UPDATE)
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)               /* 기안버튼 눌렀을때 번호생성(UPDATE) */
    public List<Map<String, Object>> makeDraftNum(Map param) throws Exception {
        return super.commonDao.list("s_mtr902skrv_kdServiceImpl.makeDraftNum", param);
    }
}
