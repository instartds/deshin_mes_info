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
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;

@Service( "s_Afb410ukrService_KOCIS" )
public class S_Afb410ukrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.TREE_LOAD, group = "accnt" )			// 조회
    public UniTreeNode selectList( Map param ) throws Exception {
        /**
         * <pre>
         * 1. result Class 확인(foren.framework.lib.tree.GenericTreeDataMap)!
         * 2. SQL의 수행 결과 순서는 parent가 child보더 먼저 나오게 구성 되어야 함.
         * 3. id와 parentId는 필수 !
         * 4. 최상의 node는 parentId가 root로 지정 되어야 함.
         * </pre>
         */
        List<GenericTreeDataMap> menuList = super.commonDao.list("s_Afb410ukrServiceImpl_KOCIS.selectList", param);
        return UniTreeHelper.makeTreeAndGetRootNode(menuList);
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )		// 삭제전 afb500t조회
    public List<Map<String, Object>> selectAfb500tBeforeSave( Map param ) throws Exception {
        return super.commonDao.list("s_Afb410ukrServiceImpl_KOCIS.selectAfb500tBeforeSave", param);
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )		// 삭제전 afb510t조회
    public List<Map<String, Object>> selectAfb510tBeforeSave( Map param ) throws Exception {
        return super.commonDao.list("s_Afb410ukrServiceImpl_KOCIS.selectAfb510tBeforeSave", param);
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "base" )			// 저장
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        if (paramList != null) {
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteMulti")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateMulti")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteMulti(deleteList, user);
            if (updateList != null) this.updateMulti(updateList, user);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public Integer syncAll( Map param ) throws Exception {
        logger.debug("syncAll:" + param);
        return 0;
    }
    
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )			// 수정
    public List<Map> updateMulti( List<Map> paramList, LoginVO user ) throws Exception {
        logger.debug("\n updateMulti: {}", paramList);
        for (Map param : paramList) {
            Map chkMap = (Map)super.commonDao.select("s_Afb410ukrServiceImpl_KOCIS.selectAfb410tBeforeSave", param);
            if (ObjUtils.parseInt(chkMap.get("CNT")) > 0) {
                super.commonDao.update("s_Afb410ukrServiceImpl_KOCIS.update", param);
            } else {
                super.commonDao.update("s_Afb410ukrServiceImpl_KOCIS.insert", param);
            }
        }
        return paramList;
    }
    
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )			// 삭제
    public List<Map> deleteMulti( List<Map> paramList, LoginVO user ) throws Exception {
        logger.debug("\n deleteMulti: {}", paramList);
        for (Map param : paramList) {
            super.commonDao.update("s_Afb410ukrServiceImpl_KOCIS.delete", param);
        }
        return paramList;
    }
    
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )		// 타부서복사 복사
    public int insertDataCopy( Map param ) throws Exception {
        //return super.commonDao.list("s_Afb410ukrServiceImpl_KOCIS.insertDataCopy", param);
        return super.commonDao.update("s_Afb410ukrServiceImpl_KOCIS.insertDataCopy", param);
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )		// 타부서복사 삭제
    public List<Map<String, Object>> deleteDataCopy( Map param ) throws Exception {
        return super.commonDao.list("s_Afb410ukrServiceImpl_KOCIS.deleteDataCopy", param);
    }
    
}
