package foren.unilite.modules.human.hum;

import java.sql.SQLException;
import java.util.HashMap;
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
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.AES256DecryptoUtils;

@Service( "hum300ukrService" )
public class Hum300ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    
    /**
     * 소득자 목록 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */  
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "human" )
    public List<Map<String, Object>> selectList( Map param, LoginVO user ) throws Exception {
        return super.commonDao.list("hum300ukrServiceImpl.selectList", param);
    }
    
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "human" )
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
            if (deleteList != null) this.deleteList(deleteList, user, paramMaster);
            if (insertList != null) this.insertList(insertList, user, paramMaster);
            if (updateList != null) this.updateList(updateList, user, paramMaster);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "human" )
    public void insertList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
//        try {
            Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
            
            for (Map param : paramList) {
            	
            	String compNum = ObjUtils.getSafeString(param.get("COMP_NUM"));
            	String compZipCode = ObjUtils.getSafeString(param.get("COMP_ZIP_CODE"));
            	String zipCode = ObjUtils.getSafeString(param.get("ZIP_CODE"));
            	String repreNum = ObjUtils.getSafeString(param.get("REPRE_NUM"));
            	String foreignNum = ObjUtils.getSafeString(param.get("FOREIGN_NUM"));
            	
                param.put("ZIP_CODE", param.get("ZIP_CODE").toString().replace("-", "")); /* 개인주소 우편번호 */
                param.put("REPRE_NUM", param.get("REPRE_NUM").toString().replace("-", "")); /* 주민등록번호 */
                param.put("FOREIGN_NUM", param.get("FOREIGN_NUM").toString().replace("-", "")); /* 외국인등록번호 */
                
                String checkValueName = "";
                List<Map> checkName = (List<Map>)super.commonDao.list("hum300ukrServiceImpl.checkName", param);//hum100t에 동일한 주민등록번호 체크
                if (!checkName.isEmpty()) {
                    checkValueName = ObjUtils.getSafeString(checkName.get(0).get("NAME"));
                }
                if (!ObjUtils.isEmpty(checkValueName)) {
                    String line = System.getProperty("line.separator");   //줄바꿈관련 각 운영체제에 맞추기 위해
                    String errMessage = "동일한 주민등록번호가 등록된 소득자가 존재합니다.\n이미 등록 되있는 소득자 성명 : " + checkValueName + "\n현재 등록 하려는 소득자 성명 : " + param.get("NAME");
                    errMessage = errMessage.replace("\n", line);
                    throw new  UniDirectValidateException(errMessage);
                }
                String checkValueName2 = "";
                List<Map> checkName2 = (List<Map>)super.commonDao.list("hum300ukrServiceImpl.checkPersonNumb", param);//hum100t에 동일한 사번 체크
                if (!checkName2.isEmpty()) {
                	checkValueName2 = ObjUtils.getSafeString(checkName2.get(0).get("NAME"));
                }
                if (!ObjUtils.isEmpty(checkValueName2)) {
                    String line = System.getProperty("line.separator");   //줄바꿈관련 각 운영체제에 맞추기 위해
                    String errMessage = "동일한 사번이 등록된 소득자가 존재합니다.\n이미 등록 되있는 소득자 성명 : " + checkValueName2 + "\n현재 등록 하려는 소득자 성명 : " + param.get("NAME");
                    errMessage = errMessage.replace("\n", line);
                    throw new  UniDirectValidateException(errMessage);
                } else {
                	super.commonDao.insert("hum300ukrServiceImpl.insertList", param);
                }
                
                param.put("ZIP_CODE", zipCode);
                param.put("REPRE_NUM", repreNum);
                param.put("FOREIGN_NUM", foreignNum);
            }
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "human" )
    public void updateList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        for (Map param : paramList) {
        	String compNum = ObjUtils.getSafeString(param.get("COMP_NUM"));
        	String compZipCode = ObjUtils.getSafeString(param.get("COMP_ZIP_CODE"));
        	String zipCode = ObjUtils.getSafeString(param.get("ZIP_CODE"));
        	String repreNum = ObjUtils.getSafeString(param.get("REPRE_NUM"));
        	String foreignNum = ObjUtils.getSafeString(param.get("FOREIGN_NUM"));
        	
            param.put("ZIP_CODE", param.get("ZIP_CODE").toString().replace("-", "")); /* 개인주소 우편번호 */
            param.put("REPRE_NUM", param.get("REPRE_NUM").toString().replace("-", "")); /* 주민등록번호 */
            param.put("FOREIGN_NUM", param.get("FOREIGN_NUM").toString().replace("-", "")); /* 외국인등록번호 */
            String checkValueName = "";
            List<Map> checkName = (List<Map>)super.commonDao.list("hum300ukrServiceImpl.checkName", param);//hum100t에 동일한 주민등록번호 체크
            if (!checkName.isEmpty()) {
                checkValueName = ObjUtils.getSafeString(checkName.get(0).get("NAME"));
            }
            if (!ObjUtils.isEmpty(checkValueName)) {
                String line = System.getProperty("line.separator");   //줄바꿈관련 각 운영체제에 맞추기 위해
                String errMessage = "동일한 주민등록번호가 등록된 소득자가 존재합니다.\n이미 등록 되있는 소득자 성명 : " + checkValueName + "\n현재 등록 하려는 소득자 성명 : " + param.get("NAME");
                errMessage = errMessage.replace("\n", line);
                throw new  UniDirectValidateException(errMessage);
            }
            super.commonDao.update("hum300ukrServiceImpl.updateList", param);
            
            param.put("ZIP_CODE", zipCode);
            param.put("REPRE_NUM", repreNum);
            param.put("FOREIGN_NUM", foreignNum);
        }
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "human" )
    public void deleteList( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        for (Map param : paramList) {
        	super.commonDao.delete("hum300ukrServiceImpl.deleteList", param);   
        }
        return;
    }
}
