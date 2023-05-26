package foren.unilite.modules.accnt.afb;

import java.util.ArrayList;
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

@Service( "afb600skrService" )
public class Afb600skrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )		// BUDG_NAME컬럼수
    public List<Map<String, Object>> selectBudgName( Map param ) throws Exception {
        return super.commonDao.list("afb600skrServiceImpl.selectBudgName", param);
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )		// 메인
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        super.commonDao.list("afb600skrServiceImpl.selectBudgName", param);
        return super.commonDao.list("afb600skrServiceImpl.selectList", param);
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public List<Map> insertDetail( List<Map> params, LoginVO user ) throws Exception {
        return params;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public List<Map> updateDetail( List<Map> params, LoginVO user ) throws Exception {
        return params;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_MODIFY )
    public List<Map> deleteDetail( List<Map> params, LoginVO user ) throws Exception {
        return params;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )	// 저장
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        logger.debug("[saveAll] paramDetail:" + paramList);
        
        //1.로그테이블에서 사용할 KeyValue 생성
        String keyValue = getLogKey();
        
        //2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
        List<Map> dataList = new ArrayList<Map>();
        
        for (Map paramData : paramList) {
            
            dataList = (List<Map>)paramData.get("data");
            String oprFlag = "N";
            if (paramData.get("method").equals("insertDetail")) oprFlag = "N";
            if (paramData.get("method").equals("updateDetail")) oprFlag = "U";
            if (paramData.get("method").equals("deleteDetail")) oprFlag = "D";
            
            for (Map param : dataList) {
                param.put("KEY_VALUE", keyValue);
                param.put("OPR_FLAG", oprFlag);
                param.put("data", super.commonDao.update("afb600skrServiceImpl.insertLogAfb600tc", param));
            }
        }
        //4.매출저장 Stored Procedure 실행
        Map<String, Object> spParam = new HashMap<String, Object>();
        
        spParam.put("KeyValue", keyValue);
        spParam.put("LangCode", user.getLanguage());
        spParam.put("UserId", user.getUserID());
        //spParam.put("", value)
        
        super.commonDao.queryForObject("afb600skrServiceImpl.spReceiving", spParam);
        
        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
        
        //출하지시 마스터 출하지시 번호 update
        
        if (!ObjUtils.isEmpty(errorDesc)) {
            //String[] messsage = errorDesc.split(";");
            //throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
            //throw new  Exception(errorDesc);
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        }
        
        paramList.add(0, paramMaster);
        return paramList;
    }
}
