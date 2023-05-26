package foren.unilite.modules.base.bif;

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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;

@Service( "bif100ukrvService" )
public class Bif100ukrvServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
	
    /**
     * 프로그램/메세지 조회
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("bif100ukrvServiceImpl.selectList", param);
    }
    
    /**
     * 발신자/수신자 정보
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectUserList( Map param ) throws Exception {
        return super.commonDao.list("bif100ukrvServiceImpl.selectUserList", param);
    }
    
    
    /** 저장 **/
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "base" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        if (paramList != null) {
            List<Map> insertList = null;
           	List<Map> updateList = null;
            List<Map> deleteList = null;
            
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteList")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertList")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateList")) {
                	updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if(deleteList != null) this.deleteList(deleteList, user);
            if(insertList != null) this.insertList(insertList, user);
            if(updateList != null) this.updateList(updateList, user);				
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public Integer insertList( List<Map> paramList, LoginVO user ) throws Exception {    
        for (Map param : paramList) {
        	Map  seqMap =  (Map) super.commonDao.select("bif100ukrvServiceImpl.getSeq", param);
        	if(seqMap != null)	{
        		param.put("SEQ", ObjUtils.parseInt(seqMap.get("SEQ")));
        	}
            super.commonDao.update("bif100ukrvServiceImpl.insertList", param);
        }
        return 1;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public Integer deleteList( List<Map> paramList, LoginVO user ) throws Exception {
       
        for (Map param : paramList) {
            super.commonDao.delete("bif100ukrvServiceImpl.deleteList", param);
        }
        return 1;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public Integer updateList( List<Map> paramList, LoginVO user ) throws Exception {
       
        for (Map param : paramList) {
            super.commonDao.update("bif100ukrvServiceImpl.updateList", param);
        }
        return 1;
    }
    
    
    /** 저장 **/
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "base" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAllUser( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> deleteList = null;
            
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteUserList")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertUserList")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } 
            }
            if(deleteList != null) this.deleteUserList(deleteList, user);
            if(insertList != null) this.insertUserList(insertList, user);
        }
        paramList.add(0, paramMaster);
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public Integer insertUserList( List<Map> paramList, LoginVO user) throws Exception {    
        for (Map param : paramList) {
            super.commonDao.update("bif100ukrvServiceImpl.insertUserList", param);

        }
        return 1;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked", "unused" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public Integer deleteUserList( List<Map> paramList, LoginVO user ) throws Exception {
       
        for (Map param : paramList) {
            super.commonDao.delete("bif100ukrvServiceImpl.deleteUserList", param);
        }
        return 1;
    }
    
    /**
     * 메세지 전송 결과 조회
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectLogList( Map param ) throws Exception {
        return super.commonDao.list("bif100ukrvServiceImpl.selectLogList", param);
    }
    
    @ExtDirectMethod( group = "base" )
    public Integer insertLog( Map param, LoginVO user) throws Exception {
    	String keyValue = this.getLogKey();
    	param.put("KEY_VALUE", keyValue);
    	param.put("S_COMP_CODE", user.getCompCode());
    	param.put("S_USER_ID", user.getUserID());
    	
        super.commonDao.update("bif100ukrvServiceImpl.insertLog", param);        
        return 1;
    }
}
