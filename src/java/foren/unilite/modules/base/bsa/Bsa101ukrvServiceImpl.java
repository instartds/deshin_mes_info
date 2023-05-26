package foren.unilite.modules.base.bsa;

import java.util.ArrayList;
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
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;

@Service( "bsa101ukrvService" )
public class Bsa101ukrvServiceImpl extends TlabAbstractServiceImpl {
    private final Logger      logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "tlabCodeService" )
    protected TlabCodeService tlabCodeService;
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "base" )
    public List<Map<String, Object>> selectMasterCodeList( Map param ) throws Exception {
        return super.commonDao.list("bsa101ukrvService.selectMasterCodeList", param);
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectDetailSales( Map param ) throws Exception {
        return super.commonDao.list("bsa101ukrvService.selectDetailSales", param);
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectDetailPayments( Map param ) throws Exception {
        return super.commonDao.list("bsa101ukrvService.selectDetailPayments", param);
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectDetailBuy( Map param ) throws Exception {
        return super.commonDao.list("bsa101ukrvService.selectDetailBuy", param);
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectDetailInout( Map param ) throws Exception {
        return super.commonDao.list("bsa101ukrvService.selectDetailInout", param);
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectDetailCard( Map param ) throws Exception {
        return super.commonDao.list("bsa101ukrvService.selectDetailCard", param);
    }
    
    /** arc020ukr **/
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> Payments( Map param ) throws Exception {
        return super.commonDao.list("bsa101ukrvService.Payments", param);
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> comp( Map param ) throws Exception {
        return super.commonDao.list("bsa101ukrvService.comp", param);
    }
    
    /** **/
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "base", value = ExtDirectMethodType.STORE_READ )
    public List<List<Map>> selectForm( Map param ) throws Exception {
        List<List<Map>> resultList = new ArrayList<List<Map>>();
        
        resultList.add(commonDao.list("bsa101ukrvService.selectS012", param));
        /*
         * resultList.add(commonDao.list("bsa101ukrvService.selectS022", param)); resultList.add(commonDao.list("bsa101ukrvService.selectS026", param)); resultList.add(commonDao.list("bsa101ukrvService.selectS019", param)); resultList.add(commonDao.list("bsa101ukrvService.selectS028", param)); resultList.add(commonDao.list("bsa101ukrvService.selectS025", param)); resultList.add(commonDao.list("bsa101ukrvService.selectS031", param)); resultList.add(commonDao.list("bsa101ukrvService.selectS029", param)); resultList.add(commonDao.list("bsa101ukrvService.selectS033", param)); resultList.add(commonDao.list("bsa101ukrvService.selectS034", param)); resultList.add(commonDao.list("bsa101ukrvService.selectS035", param)); resultList.add(commonDao.list("bsa101ukrvService.selectS025", param));
         */
        
        return resultList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public List<Map> insertCodes( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            //
            Map<String, Object> chkData = (Map<String, Object>)super.commonDao.select("bsa101ukrvService.chkCode", param);
            if (chkData != null && ObjUtils.parseInt(chkData.get("CNT")) > 0) throw new UniDirectValidateException(this.getMessage("2627", user));
            
            if (param.get("SYSTEM_CODE_YN") == "") param.put("SYSTEM_CODE_YN", null);  // SYSTEM_CODE_YN 은 null 가능한 numeric field 이므로 blank를 넣을 수 없음
            super.commonDao.insert("bsa101ukrvService.insertCode", param);
        }
        // 공통코드 인스턴스 갱신
        //tlabCodeService.reload();
        
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "base" )
    public List<Map> updateCodes( List<Map> paramList ) throws Exception {
        
        for (Map param : paramList) {
            if (param.get("SYSTEM_CODE_YN") == "") param.put("SYSTEM_CODE_YN", null);  // SYSTEM_CODE_YN 은 null 가능한 numeric field 이므로 blank를 넣을 수 없음			
            super.commonDao.update("bsa101ukrvService.updateCode", param);
        }
        // 공통코드 인스턴스 갱신
        //tlabCodeService.reload();
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( group = "base" )
    public List<Map> deleteCodes( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            super.commonDao.update("bsa101ukrvService.deleteCode", param);
        }
        // 공통코드 인스턴스 갱신
        //tlabCodeService.reload();
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( group = "base" )
    public List<Map<String, Object>> selectDetailCodeList( Map param ) throws Exception {
        return super.commonDao.list("bsa101ukrvService.selectDetailCodeList", param);
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "base" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> updateList2 = null;
            
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteCodes")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertCodes")) {
                    insertList = (List<Map>)dataListMap.get("data");
                    
                } else if (dataListMap.get("method").equals("updateCodes")) {
                    updateList = (List<Map>)dataListMap.get("data");
                    
                } else if (dataListMap.get("method").equals("updateSales")) {
                    updateList2 = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteCodes(deleteList);
            if (insertList != null) this.insertCodes(insertList, user);
            if (updateList != null) this.updateCodes(updateList);
            
            if (updateList2 != null) this.updateSales(updateList2, user);
            
            tlabCodeService.reload(true);
            
            //tlabCodeService.reload();
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )		// UPDATE
    public Integer updateSales( List<Map> paramList, LoginVO user ) throws Exception {
        Map compCodeMap = new HashMap();
        compCodeMap.put("S_COMP_CODE", user.getCompCode());
        List<Map> chkList = (List<Map>)super.commonDao.list("bsa101ukrvService.checkCompCode", compCodeMap);
        for (Map param : paramList) {
            for (Map checkCompCode : chkList) {
                param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
                super.commonDao.update("bsa101ukrvService.updateSales", param);
            }
        }
        return 0;
    }
    
}
