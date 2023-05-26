package foren.unilite.modules.z_kocis;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.accnt.afb.Afb300ukrModel;

@Service( "s_Afb300ukrService_KOCIS" )
public class S_Afb300ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 예산업무설정
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "accnt" )
    public Object selectForm( Map param ) throws Exception {
        return super.commonDao.select("s_afb300ukrServiceImpl_KOCIS.selectForm", param);
        
    }
    
    /**
     * AFB300T 데이터 체크
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectCheckDataCopy1( Map param ) throws Exception {
        return super.commonDao.list("s_afb300ukrServiceImpl_KOCIS.selectCheckDataCopy1", param);
    }
    
    /**
     * AFB400T 데이터 체크
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectCheckDataCopy2( Map param ) throws Exception {
        return super.commonDao.list("s_afb300ukrServiceImpl_KOCIS.selectCheckDataCopy2", param);
    }
    
    /** 저장 **/
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_POST, group = "accnt" )
    public ExtDirectFormPostResult syncMaster( Afb300ukrModel param, LoginVO user, BindingResult result ) throws Exception {
        
        param.setS_USER_ID(user.getUserID());
        param.setS_COMP_CODE(user.getCompCode());
        
        if (param.getSAVE_FLAG().equals("D")) {
            super.commonDao.update("s_afb300ukrServiceImpl_KOCIS.deleteForm", param);
        } else {
            
            if (param.getOnDataCopy().equals("on")) {
                super.commonDao.update("s_afb300ukrServiceImpl_KOCIS.deleteForm2", param);
                super.commonDao.update("s_afb300ukrServiceImpl_KOCIS.insertDataCopy", param);
            } else {
                super.commonDao.update("s_afb300ukrServiceImpl_KOCIS.deleteForm", param);
                super.commonDao.update("s_afb300ukrServiceImpl_KOCIS.insertForm", param);
            }
        }
        
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
        
        return extResult;
    }
}
