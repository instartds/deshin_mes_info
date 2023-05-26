package foren.unilite.modules.accnt.agj;

import java.util.ArrayList;
import java.util.HashMap;
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

@Service( "agj231ukrService" )
public class Agj231ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 전표승인 - 일반전표 목록 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "Accnt" )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        
        return (List)super.commonDao.list("agj231ukrServiceImpl.selectList", param);
    }
    
    /**
     * 전표승인 - 전표번호 목록 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "Accnt" )
    public List<Map<String, Object>> selectExList( Map param ) throws Exception {
        
        return (List)super.commonDao.list("agj231ukrServiceImpl.selectEXList", param);
    }
    
    /**
     * 전표승인 - 저장
     * 
     * @param paramList
     * @param paramMaster
     * @param user
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "Accnt" )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        //로그테이블에서 사용할 Key 생성		
        String keyValue = getLogKey();
        
        //로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
        List<Map> dataList = new ArrayList<Map>();
        
        Map sParam = new HashMap();
        
        Map autoMap = (Map)super.commonDao.select("agj231ukrServiceImpl.getMaxAutoNum", sParam);
        int i = Integer.parseInt(autoMap.get("MAX_AUTO_NUM").toString());
        if (paramList != null) {
            for (Map param : paramList) {
                dataList = (List<Map>)param.get("data");
                for (Map paramData : dataList) {
                    paramData.put("KEY_VALUE", keyValue);
                    paramData.put("AUTO_NUM", i);
                    super.commonDao.update("agj231ukrServiceImpl.insertLog", paramData);
                    i++;
                }
                
            }
        }
        
        //Stored Procedure 실행
        sParam.put("CompCode", user.getCompCode());
        sParam.put("KeyValue", keyValue);
        sParam.put("UserID", user.getUserID());
        sParam.put("UserLang", user.getLanguage());
        
        super.commonDao.queryForObject("agj231ukrServiceImpl.SP_ACCNT_ApproveSlip", sParam);
        
        String errorDesc = ObjUtils.getSafeString(sParam.get("ErrorDesc"));
        
        if (ObjUtils.isNotEmpty(errorDesc)) {
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        } else {
            
            if (paramList != null) {
                List<Map> dataList2 = new ArrayList<Map>();
                for (Map param : paramList) {
                    dataList2 = (List<Map>)param.get("data");
                    for (Map paramData : dataList2) {
                        Map rMap = (Map)super.commonDao.select("agj231ukrServiceImpl.selectLog", paramData);
                        paramData.put("SLIP_NUM", rMap.get("SLIP_NUM"));
                        paramData.put("AP_STS", rMap.get("AP_STS"));
                        paramData.put("AC_DATE", rMap.get("AC_DATE"));
                        paramData.put("AP_DATE", rMap.get("AP_DATE"));
                        
                        paramData.put("AP_CHARGE_CODE", rMap.get("AP_CHARGE_CODE"));
                        paramData.put("AP_CHARGE_NAME", rMap.get("AP_CHARGE_NAME"));
                        
                        paramData.put("CHK", false);
                    }
                }
                //super.commonDao.update("agj231ukrServiceImpl.deleteLog", sParam);
            }
        }
        
        paramList.add(0, paramMaster);
        return paramList;
    }
    
    @ExtDirectMethod( group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public List<Map> insert( List<Map> params ) throws Exception {
        return params;
    }
    
    @ExtDirectMethod( group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public List<Map> update( List<Map> params ) throws Exception {
        return params;
    }
    
    @ExtDirectMethod( group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public List<Map> delete( List<Map> params ) throws Exception {
        return params;
    }
    
}
