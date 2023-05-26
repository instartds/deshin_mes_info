package foren.unilite.modules.base.bsa;

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
//import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.DevFreeUtils;

/**
 * <pre>
 * 사용자별 부서 권한등록
 * </pre>
 * 
 */
@Service( "bsa570ukrvService" )
public class Bsa570ukrvServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @Transactional( readOnly = true )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "bsa" )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return (List)super.commonDao.list("bsa570ukrvServiceImpl.selectList", param);
    }
    
    
    /**
     *  저장
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "bsa" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        List<Map> insertList = null;
        List<Map> updateList = null;
        List<Map> deleteList = null;
        
        if (paramList != null) {
            
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteList")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertList")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateList")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteList(deleteList);
            if (insertList != null) this.insertList(insertList, user);
            if (updateList != null) this.updateList(updateList);
        }
        
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /**
     * 선택된 행을 추가함
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bsa" )
    public List<Map> insertList( List<Map> paramList, LoginVO user ) throws Exception {
        try {
            for (Map param : paramList) {
                super.commonDao.insert("bsa570ukrvServiceImpl.insertList", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(DevFreeUtils.errorMsg(e.getMessage()));
        }
        return paramList;
    }
    
    /**
     * 선택된 행을 수정함
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bsa" )
    public List<Map> updateList( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("bsa570ukrvServiceImpl.updateList", param);
        }
        return paramList;
    }
    
    /**
     * 
     * 선택된 행을 삭제함
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "bsa" )
    public List<Map> deleteList( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.delete("bsa570ukrvServiceImpl.deleteList", param);
        }
        return paramList;
    }
    
}
