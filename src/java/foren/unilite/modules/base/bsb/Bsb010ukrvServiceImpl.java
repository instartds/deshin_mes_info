package foren.unilite.modules.base.bsb;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabBadgeService;
import foren.unilite.com.service.impl.TlabMenuService;

@Service( "bsb010ukrvService" )
public class Bsb010ukrvServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "tlabBadgeService" )
    TlabBadgeService      tlabBadgeService;
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "Base" )
    public List<Map<String, Object>> selectList( Map param, LoginVO user ) throws Exception {
        param.put("S_USER_NAME", user.getUserName());
        return super.commonDao.list("bsb010ukrvService.selectList", param);
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "Base" )
    public List<Map> insert( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.insert("bsb010ukrvService.insert", param);
        }
        tlabBadgeService.reload();
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "Base" )
    public List<Map> delete( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("bsb010ukrvService.delete", param);
        }
        tlabBadgeService.reload();
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "Base" )
    public List<Map> update( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("bsb010ukrvService.update", param);
        }
        tlabBadgeService.reload();
        return paramList;
    }
    
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "base" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("delete")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insert")) {
                    insertList = (List<Map>)dataListMap.get("data");
                    
                } else if (dataListMap.get("method").equals("update")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.delete(deleteList);
            if (insertList != null) this.insert(insertList, user);
            if (updateList != null) this.update(updateList);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "Base" )
    public Integer syncAll( Map param ) throws Exception {
        logger.debug("syncAll:" + param);
        return 0;
    }
    
}
