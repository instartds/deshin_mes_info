package foren.unilite.modules.z_yp;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.AES256DecryptoUtils;

@Service( "w_bsa000skrv_ypService" )
public class W_bsa000skrv_ypServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 공지사항 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "z_yp", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList1( Map param ) throws Exception {
        return super.commonDao.list("w_bsa000skrv_ypServiceImpl.selectList", param);
    }
    
    /**
     * 주문현황 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "z_yp", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList2( Map param ) throws Exception {
        
        return super.commonDao.list("w_bsa000skrv_ypServiceImpl.selectList2", param);
    }
    
    /**
     * 단가 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "z_yp", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList3( Map param ) throws Exception {
        
        return super.commonDao.list("w_bsa000skrv_ypServiceImpl.selectList3", param);
    }
    
    /**
     * 공지사항 조회수 업데이트
     */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_yp")
    public Object  updateCnt(Map params, LoginVO user) throws Exception {
        super.commonDao.update("w_bsa000skrv_ypServiceImpl.updateCnt", params);
        return true;
    }
}
