package foren.unilite.modules.base.bsa;

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
import foren.unilite.com.service.impl.TlabMenuService;

@Service( "bsa500ukrvService" )
public class Bsa500ukrvServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "tlabMenuService" )
    TlabMenuService      tlabMenuService;
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "Base" )
    public List<Map<String, Object>> selectList( Map param, LoginVO user ) throws Exception {
        param.put("S_USER_NAME", user.getUserName());
        return super.commonDao.list("bsa500ukrvService.selectList", param);
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "Base" )
    public List<Map> insertPrograms( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.insert("bsa500ukrvService.insertPrograms", param);
        }
        tlabMenuService.reload();
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "Base" )
    public List<Map> deletePrograms( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("bsa500ukrvService.deletePrograms", param);
        }
        tlabMenuService.reload(true);
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "Base" )
    public List<Map> updatePrograms( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("bsa500ukrvService.updatePrograms", param);
        }
        tlabMenuService.reload();
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "Base" )
    public List<Map<String, Object>> selectProgramList( Map param ) throws Exception {
        return super.commonDao.list("bsa500ukrvService.selectProgramList", param);
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
                if (dataListMap.get("method").equals("deletePrograms")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertPrograms")) {
                    insertList = (List<Map>)dataListMap.get("data");
                    
                } else if (dataListMap.get("method").equals("updatePrograms")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deletePrograms(deleteList);
            if (insertList != null) this.insertPrograms(insertList, user);
            if (updateList != null) this.updatePrograms(updateList);
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
