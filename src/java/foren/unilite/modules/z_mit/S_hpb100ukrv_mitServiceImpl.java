package foren.unilite.modules.z_mit;

import java.sql.SQLException;
import java.util.HashMap;
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
import foren.unilite.utils.AES256DecryptoUtils;

@Service( "s_hpb100ukrv_mitService" )
public class S_hpb100ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    

    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hpb" )
    public List<Map<String, Object>> selectDetailList( Map param, LoginVO user ) throws Exception {
        return super.commonDao.list("s_hpb100ukrv_mitServiceImpl.selectList", param);
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "hpb" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        if (paramList != null) {
            List<Map> updateList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("updateDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (updateList != null) this.updateDetail(updateList, user, paramMaster);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
 
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hpb" )
    public void updateDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        for (Map param : paramList) {
        	param.put("ZIP_CODE", param.get("ZIP_CODE").toString().replace("-", ""));
        	super.commonDao.update("s_hpb100ukrv_mitServiceImpl.updateList", param);   
        }
        return;
    }
    
    
}
