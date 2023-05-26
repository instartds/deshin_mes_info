package foren.unilite.modules.z_kocis;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;

@Service( "s_Afb400ukrService_KOCIS" )
public class S_Afb400ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @ExtDirectMethod( value = ExtDirectMethodType.TREE_LOAD, group = "accnt" )
    public UniTreeNode selectList( Map param ) throws Exception {
        /**
         * 1. result Class 확인(foren.framework.lib.tree.GenericTreeDataMap)! 2. SQL의 수행 결과 순서는 parent가 child보더 먼저 나오게 구성 되어야 함. 3. id와 parentId는 필수 ! 4. 최상의 node는 parentId가 root로 지정 되어야 함.
         */
        List<GenericTreeDataMap> menuList = super.commonDao.list("s_Afb400ukrServiceImpl_KOCIS.selectList", param);
        return UniTreeHelper.makeTreeAndGetRootNode(menuList);
    }
    
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )		// afb400t조회
    public List<Map<String, Object>> selectAfb400t( Map param ) throws Exception {
        return super.commonDao.list("s_Afb400ukrServiceImpl_KOCIS.selectAfb400t", param);
    }
    
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )		// afb410t조회
    public List<Map<String, Object>> selectAfb410t( Map param ) throws Exception {
        return super.commonDao.list("s_Afb400ukrServiceImpl_KOCIS.selectAfb410t", param);
    }
    
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )		// 전년도 자료복사
    public int insertDataCopy( Map param ) throws Exception {
        //return super.commonDao.list("s_Afb400ukrServiceImpl_KOCIS.insertDataCopy", param);
        return super.commonDao.update("s_Afb400ukrServiceImpl_KOCIS.insertDataCopy", param);
    }
    
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )		// 전년도 자료삭제
    public List<Map<String, Object>> deleteDataCopy( Map param ) throws Exception {
        return super.commonDao.list("s_Afb400ukrServiceImpl_KOCIS.deleteDataCopy", param);
    }
    
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )		// 삭제전 afb410t조회
    public List<Map<String, Object>> selectAfb410tBeforeSave( Map param ) throws Exception {
        return super.commonDao.list("s_Afb400ukrServiceImpl_KOCIS.selectAfb410tBeforeSave", param);
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public List<Map> insertMulti( List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
        

        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        logger.debug("\n insertMulti: {}", paramList);
        for (Map param : paramList) {
            
            Map chkMap = (Map)super.commonDao.select("s_Afb400ukrServiceImpl_KOCIS.checkPK", param);
            if (ObjUtils.parseInt(chkMap.get("CNT")) > 0) {
                logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  CNT:{}", ObjUtils.parseInt(chkMap.get("CNT")));
                throw new UniDirectValidateException(this.getMessage("2627", user));
            }
            
            param.put("AC_GUBUN", dataMaster.get("AC_GUBUN"));
            super.commonDao.insert("s_Afb400ukrServiceImpl_KOCIS.insert", param);
            
        }
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public List<Map> updateMulti( List<Map> paramList, LoginVO user ) throws Exception {
        logger.debug("\n updateMulti: {}", paramList);
        for (Map param : paramList) {
            super.commonDao.update("s_Afb400ukrServiceImpl_KOCIS.update", param);
        }
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public List<Map> deleteMulti( List<Map> paramList, LoginVO user ) throws Exception {
        logger.debug("\n deleteMulti: {}", paramList);
        for (Map param : paramList) {
            super.commonDao.update("s_Afb400ukrServiceImpl_KOCIS.delete", param);
        }
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "base" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        Map<String, Object> rMap;
        
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteMulti")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertMulti")) {
                    insertList = (List<Map>)dataListMap.get("data");
                    
                } else if (dataListMap.get("method").equals("updateMulti")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteMulti(deleteList, user);
            if (insertList != null) this.insertMulti(insertList, user, paramMaster);
            if (updateList != null) this.updateMulti(updateList, user);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public Integer syncAll( Map param ) throws Exception {
        logger.debug("syncAll:" + param);
        return 0;
    }
}
