package foren.unilite.modules.z_kocis;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.multidb.cubrid.fn.CommonServiceImpl_KOCIS_CUBRID;

/**
 * 해외문화홍보원 - 거래처정보등록
 * 
 * @author Administrator
 */
@Service( "s_bcm100ukrvService_KOCIS" )
public class S_Bcm100ukrvServiceImpl_KOCIS extends TlabAbstractServiceImpl {
    private final Logger                   logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource( name = "commonServiceImpl_KOCIS_CUBRID" )
    private CommonServiceImpl_KOCIS_CUBRID commonServiceImpl_KOCIS_CUBRID;
    
    /**
     * 거래처 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "z_kocis" )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        
        return super.commonDao.list("s_bcm100ukrvService_KOCIS.getDataList", param);
    }
    
    /**
     * 거래처코드 중복 체크
     * 
     * @param param
     * @return
     */
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "z_kocis" )
    public Object chkPK( Map param ) {
        return super.commonDao.select("s_bcm100ukrvService_KOCIS.insertQuery06", param);
    }
    
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "z_kocis" )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteDetail")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertDetail")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteDetail(deleteList, user);
            if (insertList != null) this.insertDetail(insertList, user);
            if (updateList != null) this.updateDetail(updateList, user);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /**
     * 거래처 입력
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis" )
    public void insertDetail( List<Map> paramList, LoginVO user ) throws Exception {
        try {
            for(Map param : paramList ) { 
                Map subMap = new HashMap();
                subMap.put("S_COMP_CODE", user.getCompCode());
                subMap.put("S_DEPT_CODE", user.getDeptCode());
                subMap.put("S_USER_ID", user.getDeptCode());
                if (ObjUtils.isEmpty(param.get("CUSTOM_CODE"))) {
                    Map customCode = (Map) super.commonDao.select("s_bcm100ukrvService_KOCIS.getAutoCustomCode_kocis", subMap);
                    param.put("CUSTOM_CODE", ObjUtils.getSafeString(customCode.get("CUSTOM_CODE")));
                }
                super.commonDao.insert("s_bcm100ukrvService_KOCIS.insertMulti", param);
            }
        }catch(Exception e){
            throw new  UniDirectValidateException(this.getMessage("2627", user));
        }
        return ;
        
        
        
        
        /*
        
        int r = 0;
        
        String sDemo = "N";
        boolean license = UniliteUtil.IsExceedUser("C");
        if (license) sDemo = "Y";
        
        //공통코드(B107:타법인 복사여부)에 따라 법인정보 조회
        try {
            Map<String, Object> uMap = new HashMap<String, Object>();
            uMap.put("S_COMP_CODE", user.getCompCode());
            List<Map<String, Object>> rsInfoList = (List<Map<String, Object>>)super.commonDao.list("s_bcm100ukrvService_KOCIS.insertQuery01", uMap);
            
            for (Map param : paramList) {
                
                String sOrgCompCode = param.get("COMP_CODE").toString();
                
                for (Map rsInfo : rsInfoList) {
                    Map compCodeMap = new HashMap();
                    compCodeMap.put("S_COMP_CODE", user.getCompCode());
                    if (ObjUtils.isEmpty(param.get("CUSTOM_CODE"))) {
                        List<Map> customCode = (List<Map>)super.commonDao.list("s_bcm100ukrvService_KOCIS.getAutoCustomCode", compCodeMap);
                        param.put("CUSTOM_CODE", customCode.get(0).get("CUSTOM_CODE"));
                    }
                    
                    param.put("START_DATE", UniliteUtil.chgDateFormat(param.get("START_DATE")));
                    param.put("STOP_DATE", UniliteUtil.chgDateFormat(param.get("STOP_DATE")));
                    param.put("CREDIT_YMD", UniliteUtil.chgDateFormat(param.get("CREDIT_YMD")));
                    if (param.get("TOP_NUM") != null) param.put("TOP_NUM", param.get("TOP_NUM").toString().replace("-", ""));
                    if (param.get("COMPANY_NUM") != null) param.put("COMPANY_NUM", param.get("COMPANY_NUM").toString().replace("-", ""));
                    
                    if (param.get("ZIP_CODE") != null) {
                        param.put("ZIP_CODE", param.get("ZIP_CODE").toString().replace("-", ""));
                    }
                    
                    r = super.commonDao.update("s_bcm100ukrvService_KOCIS.insertMulti", param);
                    if ("Y".equals(sDemo)) {
                        if (!license) {
                            Map<String, Object> customCnt = (Map<String, Object>)super.commonDao.select("s_bcm100ukrvService_KOCIS.insertQuery01", param);
                            if (Integer.parseInt(customCnt.get("CNT").toString()) > 100) {
                                throw new UniDirectValidateException(this.getMessage("52104", user));
                            }
                        }
                    }
                    
                }
                //            param.put("COMP_CODE", sOrgCompCode);
                //            param.put("CUSTOM_NAME1", param.get("CUSTOM_NAME") + "-CHANGE ON SERVER");
                
            }
        } catch (Exception e) {
            logger.debug(e.toString());
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        
        return paramList;*/
    }
    
    /**
     * 거래처 수정
     * 
     * @param paramList
     * @param loginVO
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis" )
    public void updateDetail( List<Map> paramList, LoginVO user ) throws Exception {
        for(Map param :paramList )  {   
            super.commonDao.update("s_bcm100ukrvService_KOCIS.updateMulti", param);
        }
         return ;
        
     /*   
        int r = 0;
        
        String sDemo = "N";
        boolean license = UniliteUtil.IsExceedUser("C");
        if (license) sDemo = "Y";
        try {
            //공통코드(B107:타법인 복사여부)에 따라 법인정보 조회
            Map<String, Object> uMap = new HashMap<String, Object>();
            uMap.put("S_COMP_CODE", user.getCompCode());
            List<Map<String, Object>> rsInfoList = (List<Map<String, Object>>)super.commonDao.list("s_bcm100ukrvService_KOCIS.insertQuery01", uMap);
            
            for (Map param : paramList) {
                
                String sOrgCompCode = param.get("COMP_CODE").toString();
                
                for (Map rsInfo : rsInfoList) {
                    param.put("START_DATE", UniliteUtil.chgDateFormat(param.get("START_DATE")));
                    param.put("STOP_DATE", UniliteUtil.chgDateFormat(param.get("STOP_DATE")));
                    param.put("CREDIT_YMD", UniliteUtil.chgDateFormat(param.get("CREDIT_YMD")));
                    if (param.get("TOP_NUM") != null) param.put("TOP_NUM", param.get("TOP_NUM").toString().replace("-", ""));
                    if (param.get("COMPANY_NUM") != null) param.put("COMPANY_NUM", param.get("COMPANY_NUM").toString().replace("-", ""));
                    
                    if (!sOrgCompCode.equals(rsInfo.get("COMP_CODE"))) {
                        param.put("COMP_CODE", rsInfo.get("COMP_CODE"));
                    }
                    if (param.get("ZIP_CODE") != null) {
                        param.put("ZIP_CODE", param.get("ZIP_CODE").toString().replace("-", ""));
                    }
                    
                    r = super.commonDao.update("bcm100ukrvServiceImpl.updateMulti", param);
                    
                    if ("Y".equals(sDemo)) {
                        if (!license) {
                            Map<String, Object> customCnt = (Map<String, Object>)super.commonDao.select("s_bcm100ukrvService_KOCIS.insertQuery01", param);
                            if (Integer.parseInt(customCnt.get("CNT").toString()) > 100) {
                                // FIXME Message 처리 52104
                                throw new UniDirectValidateException(this.getMessage("52104", user));
                            }
                        }
                    }
                    param.put("COMP_CODE", sOrgCompCode);
                    //                param.put("CUSTOM_NAME1", param.get("CUSTOM_NAME") + "-CHANGE ON SERVER");
                }
                
            }
        } catch (Exception e) {
            logger.debug(e.getMessage());
            throw new UniDirectValidateException(this.getMessage("0", user));
        }
        return paramList;*/
    }
    
    /**
     * 거래처 삭제
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis" )
    public void deleteDetail( List<Map> paramList, LoginVO user ) throws Exception {
        for(Map param :paramList )  {
            try {
                super.commonDao.delete("s_bcm100ukrvService_KOCIS.deleteMulti", param);
            }catch(Exception e)    {
                   throw new  UniDirectValidateException(this.getMessage("547",user));
           }
        }
        return;
     
    }
    
    @SuppressWarnings( "rawtypes" )
    @ExtDirectMethod( group = "z_kocis" )
    public Integer syncAll( Map param ) throws Exception {
        logger.debug("syncAll:" + param);
        return 0;
    }
    
   
    
    /**
     * 거래처 빠른등록
     * 
     * @param paramList
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "rawtypes", "unchecked" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis" )
    public List<Map> insertSimple( List<Map> paramList, LoginVO user ) throws Exception {
        try {
            for (Map param : paramList) {
                Map subMap = new HashMap();
                subMap.put("S_COMP_CODE", user.getCompCode());
                subMap.put("S_DEPT_CODE", user.getDeptCode());
                subMap.put("S_USER_ID", user.getDeptCode());
                if (ObjUtils.isEmpty(param.get("CUSTOM_CODE"))) {
                    Map customCode = (Map) super.commonDao.select("s_bcm100ukrvService_KOCIS.getAutoCustomCode_kocis", subMap);
                    param.put("CUSTOM_CODE", ObjUtils.getSafeString(customCode.get("CUSTOM_CODE")));
                }
                
                super.commonDao.insert("s_bcm100ukrvService_KOCIS.insertFast", param);
            }
        } catch (Exception e) {
            throw new Exception(e.getMessage());
//            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        return paramList;
    }
  
    
}
