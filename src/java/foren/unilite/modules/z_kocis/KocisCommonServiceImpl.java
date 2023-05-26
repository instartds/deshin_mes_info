package foren.unilite.modules.z_kocis;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.accnt.agj.Agj100ukrServiceImpl;
import foren.unilite.modules.accnt.agj.Agj200ukrServiceImpl;
import foren.unilite.multidb.cubrid.fn.CommonServiceImpl_KOCIS_CUBRID;

@Service( "kocisCommonService" )
public class KocisCommonServiceImpl extends TlabAbstractServiceImpl {
    
    private final Logger                   logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "agj100ukrService" )
    private Agj100ukrServiceImpl           agj100ukrService;
    
    @Resource( name = "agj200ukrService" )
    private Agj200ukrServiceImpl           agj200ukrService;
    @Resource( name = "commonServiceImpl_KOCIS_CUBRID" )
    private CommonServiceImpl_KOCIS_CUBRID commonServiceImpl_KOCIS_CUBRID;
    
    /**
     * KOCIS IDX값 채번관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "z_kocis", value = ExtDirectMethodType.STORE_READ )
    public Map fnGetIdx( Map param ) throws Exception {
        return (Map)super.commonDao.select("kocisCommonService.fnGetIdx", param);
    }
    
    /**
     * KOCIS 결의번호 채번관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( group = "z_kocis", value = ExtDirectMethodType.STORE_READ )
    public Map fnGetDocNo( Map param ) throws Exception {
        return (Map)super.commonDao.select("kocisCommonService.fnGetDocNo", param);
    }
    
    /**
     * KOCIS 예산사용가능금액 관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "z_kocis", value = ExtDirectMethodType.STORE_READ )
    public Object fnGetBudgetPossAmt_Kocis( Map param ) throws Exception {
        
        if (ObjUtils.isEmpty(param.get("DRAFT_SEQ"))) {
            param.put("DRAFT_SEQ", 0);
        }
        String DRAFT_NO = param.get("DRAFT_NO") == null ? "" : (String)param.get("DRAFT_NO");
        param.put("DRAFT_NO", DRAFT_NO);
        if (DRAFT_NO.equals("")) {
            return commonServiceImpl_KOCIS_CUBRID.fnPossibleBudgAmt(param);
        } else {
            return (Map)super.commonDao.select("kocisCommonService.fnGetBudgetPossAmt_Kocis", param);
        }
    }

    /**
     * KOCIS BANK_NUM 값 관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "z_kocis", value = ExtDirectMethodType.STORE_READ )
    public Map fnGetBankNum( Map param ) throws Exception {
        return (Map)super.commonDao.select("kocisCommonService.fnGetBankNum", param);
    }
}
