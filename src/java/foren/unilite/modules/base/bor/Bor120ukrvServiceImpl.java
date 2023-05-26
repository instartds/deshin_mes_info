package foren.unilite.modules.base.bor;

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

@Service( "bor120ukrvService" )
public class Bor120ukrvServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 사업장정보 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "base" )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("bor120ukrvServiceImpl.selectList", param);
    }
    
    /**
     * add by Chen.Rd
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "base" )
    public List<Map<String, Object>> selectByDivCodeAndCompCode( Map param ) throws Exception {
        return super.commonDao.list("bor120ukrvServiceImpl.selectByDivCodeAndCompCode", param);
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public List<Map> insertMulti( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            String orgZipCode = ObjUtils.getSafeString(param.get("ZIP_CODE"));
            String orgRepreNo = ObjUtils.getSafeString(param.get("REPRE_NO"));
            String orgCompanyNum = ObjUtils.getSafeString(param.get("COMPANY_NUM"));
            String orgTaxNum = ObjUtils.getSafeString(param.get("TAX_NUM"));
            
            if (!ObjUtils.isEmpty(param.get("ZIP_CODE"))) {
                param.put("ZIP_CODE", ObjUtils.getSafeString(param.get("ZIP_CODE")).replace("-", ""));
            }
            if (!ObjUtils.isEmpty(param.get("REPRE_NO"))) {
                param.put("REPRE_NO", ObjUtils.getSafeString(param.get("REPRE_NO")).replace("-", ""));
            }
            if (!ObjUtils.isEmpty(param.get("COMPANY_NUM"))) {
                param.put("COMPANY_NUM", ObjUtils.getSafeString(param.get("COMPANY_NUM")).replaceAll("\\-", ""));
            }
            if (!ObjUtils.isEmpty(param.get("TAX_NUM"))) {
                param.put("TAX_NUM", ObjUtils.getSafeString(param.get("TAX_NUM")).replace("-", ""));
            }
            super.commonDao.insert("bor120ukrvServiceImpl.insert", param);
            
            param.put("ZIP_CODE", orgZipCode);
            param.put("REPRE_NO", orgRepreNo);
            param.put("COMPANY_NUM", orgCompanyNum);
            param.put("TAX_NUM", orgTaxNum);
        }
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public List<Map> updateMulti( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            String orgZipCode = ObjUtils.getSafeString(param.get("ZIP_CODE"));
            String orgRepreNo = ObjUtils.getSafeString(param.get("REPRE_NO"));
            String orgCompanyNum = ObjUtils.getSafeString(param.get("COMPANY_NUM"));
            String orgTaxNum = ObjUtils.getSafeString(param.get("TAX_NUM"));
            
            if (!ObjUtils.isEmpty(param.get("ZIP_CODE"))) {
                param.put("ZIP_CODE", ObjUtils.getSafeString(param.get("ZIP_CODE")).replace("-", ""));
            }
            if (!ObjUtils.isEmpty(param.get("REPRE_NO"))) {
                param.put("REPRE_NO", ObjUtils.getSafeString(param.get("REPRE_NO")).replace("-", ""));
            }
            if (!ObjUtils.isEmpty(param.get("COMPANY_NUM"))) {
                param.put("COMPANY_NUM", ObjUtils.getSafeString(param.get("COMPANY_NUM")).replace("-", ""));
            }
            if (!ObjUtils.isEmpty(param.get("TAX_NUM"))) {
                param.put("TAX_NUM", ObjUtils.getSafeString(param.get("TAX_NUM")).replace("-", ""));
            }
            int r = super.commonDao.update("bor120ukrvServiceImpl.update", param);
            
            param.put("ZIP_CODE", orgZipCode);
            param.put("REPRE_NO", orgRepreNo);
            param.put("COMPANY_NUM", orgCompanyNum);
            param.put("TAX_NUM", orgTaxNum);
        }
        return paramList;
    }
    
    @SuppressWarnings( { "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )
    public List<Map> deleteMulti( List<Map> paramList ) throws Exception {
        for (Map param : paramList) {
            int r = super.commonDao.update("bor120ukrvServiceImpl.delete", param);
        }
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
                if (dataListMap.get("method").equals("deleteMulti")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertMulti")) {
                    insertList = (List<Map>)dataListMap.get("data");
                    
                } else if (dataListMap.get("method").equals("updateMulti")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteMulti(deleteList);
            if (insertList != null) this.insertMulti(insertList);
            if (updateList != null) this.updateMulti(updateList);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
}
