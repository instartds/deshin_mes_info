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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;

@Service( "bsa421ukrvService" )
public class Bsa421ukrvServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "tlabMenuService" )
    TlabMenuService      tlabMenuService;
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "Base" )
    public List<Map<String, Object>> selectList( Map param, LoginVO user ) throws Exception {
        param.put("S_USER_NAME", user.getUserName());
        return super.commonDao.list("bsa421ukrvService.selectList", param);
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "Base" )
    public List<Map> insertPrograms( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
        	Map shtSeq = (Map) super.commonDao.select("bsa421ukrvService.selectSeq", param);
        	if(shtSeq == null)	{
        		param.put("SHT_SEQ", 1);
        	}else {
        		param.put("SHT_SEQ", ObjUtils.parseInt(shtSeq.get("SHT_SEQ")));
        	}
            super.commonDao.insert("bsa421ukrvService.insertPrograms", param);
        }
        tlabMenuService.reload();
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "Base" )
    public List<Map> deletePrograms( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("bsa421ukrvService.deletePrograms", param);
        }
        tlabMenuService.reload(true);
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "Base" )
    public List<Map<String, Object>> selectProgramList( Map param ) throws Exception {
        return super.commonDao.list("bsa421ukrvService.selectProgramList", param);
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
                    
                } 
            }
            if (deleteList != null) this.deletePrograms(deleteList);
            if (insertList != null) this.insertPrograms(insertList, user);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
}
