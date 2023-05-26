package foren.unilite.modules.accnt.atx;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.AES256DecryptoUtils;

@Service( "atx326ukrService" )
public class Atx326ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectFormHeader( Map param ) throws Exception {
        return super.commonDao.list("atx326ukrServiceImpl.selectFormHeader", param);
    }
    
    /**
     * 신용카드매출전표수령명세서 (신용카드관련
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt")
    public List<Map<String, Object>> selectCreditCardList( Map param ) throws Exception {
        if (param.get("RE_REFERENCE").equals("Y")) {
            return super.commonDao.list("atx326ukrServiceImpl.selectCreditCardListSecond", param);
        } else {
            if (super.commonDao.list("atx326ukrServiceImpl.selectCreditCardListFirst", param).isEmpty()) {
                return super.commonDao.list("atx326ukrServiceImpl.selectCreditCardListSecond", param);
            } else {
                return super.commonDao.list("atx326ukrServiceImpl.selectCreditCardListFirst", param);
            }
        }
    }
    
    /**
     * 신용카드매출전표수령명세서 (현금영수증관련
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectCashList( Map param ) throws Exception {
        if (param.get("RE_REFERENCE").equals("Y")) {
            return super.commonDao.list("atx326ukrServiceImpl.selectCashListSecond", param);
        } else {
        	List<Map<String, Object>> firstList = super.commonDao.list("atx326ukrServiceImpl.selectCashListFirst", param);
            if (firstList.isEmpty()) {
                return super.commonDao.list("atx326ukrServiceImpl.selectCashListSecond", param);
            } else {
                return firstList;
            }
        }
    }
    
    /**
     * 재참조버튼 관련 체크
     * 
     * @param param
     * @return
     * @throws Exception
     */
    
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> dataCheck( Map param ) throws Exception {
    	List<Map<String,Object>>	rList = super.commonDao.list("atx326ukrServiceImpl.selectCreditCardListFirst", param);
    	List<Map<String,Object>>	rList2 = super.commonDao.list("atx326ukrServiceImpl.selectCashListFirst", param);
    	rList.addAll(rList2);
        return rList;
    }
    
    /** 디테일 저장 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
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
            Map<String, Object> paramMasterData = (Map<String, Object>) paramMaster.get("data");
            if (deleteList != null) this.deleteDetail(deleteList, user, paramMaster);
            if (insertList != null) this.insertDetail(insertList, user, paramMaster);
            if (updateList != null) this.updateDetail(updateList, user, paramMaster);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer insertDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        try {
            Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
            // dataMaster.put("COMP_CODE", user.getCompCode());
            // if(dataMaster.get("reRefButtonClick").equals("DandN")){
            // super.commonDao.delete("atx326ukrServiceImpl.reReferenceDelete",
            // dataMaster);
            // }
            
            if (dataMaster.get("RE_REFERENCE_SAVE").equals("Y")) {
                super.commonDao.delete("atx326ukrServiceImpl.deleteDetail", dataMaster);
            }
            for (Map param : paramList) {
                param.put("FR_PUB_DATE", dataMaster.get("FR_PUB_DATE"));
                param.put("TO_PUB_DATE", dataMaster.get("TO_PUB_DATE"));
                param.put("BILL_DIVI_CODE", dataMaster.get("BILL_DIVI_CODE"));
                super.commonDao.update("atx326ukrServiceImpl.insertDetail", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        
        return 0;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer updateDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        for (Map param : paramList) {
            super.commonDao.insert("atx326ukrServiceImpl.updateDetail", param);
        }
        return 0;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer deleteDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        super.commonDao.delete("atx326ukrServiceImpl.deleteDetail", dataMaster);
        return 0;
    }
    
    /** 디테일 저장 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll2( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
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
            // if(deleteList != null) this.deleteDetail2(deleteList, user,
            // paramMaster);
            Map<String, Object> paramMasterData = (Map<String, Object>) paramMaster.get("data");
            if (insertList != null) this.insertDetail2(insertList, user, paramMaster);
            // if(updateList != null) this.updateDetail2(updateList, user,
            // paramMaster);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Integer insertDetail2( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        try {
            Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
            // dataMaster.put("COMP_CODE", user.getCompCode());
            // if(dataMaster.get("reRefButtonClick").equals("DandN")){
            // super.commonDao.delete("atx326ukrServiceImpl.reReferenceDelete",
            // dataMaster);
            // }

            logger.debug("############################# 2 dataMaster.get(\"RE_REFERENCE_SAVE\") " + paramMaster.get("RE_REFERENCE_SAVE"));
            if (dataMaster.get("RE_REFERENCE_SAVE").equals("Y")) {
                super.commonDao.delete("atx326ukrServiceImpl.deleteDetail", dataMaster);
            }
            for (Map param : paramList) {
                param.put("FR_PUB_DATE", dataMaster.get("FR_PUB_DATE"));
                param.put("TO_PUB_DATE", dataMaster.get("TO_PUB_DATE"));
                param.put("BILL_DIVI_CODE", dataMaster.get("BILL_DIVI_CODE"));
                super.commonDao.update("atx326ukrServiceImpl.insertDetail", param);
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        
        return 0;
    }
    
    /**
     * 파일 생성전 처리
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes", "unused" } )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public Map<String, Object> fnGetFileCheck( Map spParam, LoginVO user ) throws Exception {
        Map<String, Object> spResult = new HashMap();
        Map result = new HashMap();
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        String errorDesc = "";
        
        logger.info("FR_PUB_DATE :; {}", spParam.get("FR_PUB_DATE"));
        logger.info("TO_PUB_DATE :; {}", spParam.get("TO_PUB_DATE"));
        logger.info("BILL_DIVI_CODE :; {}", spParam.get("BILL_DIVI_CODE"));
        logger.info("WRITE_DATE :; {}", spParam.get("WRITE_DATE"));
        
        spParam.put("COMP_CODE", user.getCompCode());
        spParam.put("USER_ID", user.getUserID());
        spParam.put("FR_PUB_DATE", ( (String)spParam.get("FR_PUB_DATE") ).substring(0, 6));
        spParam.put("TO_PUB_DATE", ( (String)spParam.get("TO_PUB_DATE") ).substring(0, 6));
        
        List<Map<String, Object>> decrypList = (List<Map<String, Object>>)super.commonDao.list("atx326ukrServiceImpl.selectFileList", spParam);
        String MEM_NUM = "";
        
//        for (Map dec : decrypList) {
//            dec.put("ORG_MEM_NUM", (String)dec.get("MEM_NUM"));
//            
//            MEM_NUM = decrypto.getDecrypto("1", (String)dec.get("MEM_NUM"));
//            
//            dec.put("MEM_NUM", MEM_NUM);
//            dec.put("COMP_CODE", user.getCompCode());
//            dec.put("BILL_DIVI_CODE", (String)spParam.get("BILL_DIVI_CODE"));
//            dec.put("FR_PUB_DATE", ( (String)spParam.get("FR_PUB_DATE") ).substring(0, 6));
//            dec.put("TO_PUB_DATE", ( (String)spParam.get("TO_PUB_DATE") ).substring(0, 6));
//            
//            super.commonDao.update("atx326ukrServiceImpl.updateDecrypto", dec);
//        }
        
        result.put("ERROR_DESC", "success");
        
        return result;
    }
    
    /**
     * 신용카드매출전표수령명세서 파일저장
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "accnt" )
    public Map<String, Object> fnGetFileText( Map param ) throws Exception {
        return (Map)super.commonDao.queryForObject("atx326ukrServiceImpl.fnGetFileText", param);
    }
    
    /**
     * 복호화 했던 필드 초기화
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    public int updateInit( Map spParam, LoginVO user ) throws Exception {
        
        logger.info("FR_PUB_DATE :; {}", spParam.get("FR_PUB_DATE"));
        logger.info("TO_PUB_DATE :; {}", spParam.get("TO_PUB_DATE"));
        logger.info("BILL_DIVI_CODE :; {}", spParam.get("BILL_DIVI_CODE"));
        logger.info("WRITE_DATE :; {}", spParam.get("WRITE_DATE"));
        
        spParam.put("COMP_CODE", user.getCompCode());
        spParam.put("USER_ID", user.getUserID());
        spParam.put("FR_PUB_DATE", ( (String)spParam.get("FR_PUB_DATE") ).substring(0, 6));
        spParam.put("TO_PUB_DATE", ( (String)spParam.get("TO_PUB_DATE") ).substring(0, 6));
        
        // HPB100T테이블에서 암호화 대상 조회후 T_HPB100T테이블에 복호화된걸 insert함.. sp에서 T_HPB100T를
        // 참조해 파일 생성함..
        List<Map<String, Object>> decrypList = (List<Map<String, Object>>)super.commonDao.list("atx326ukrServiceImpl.selectFileList", spParam);
        
//        for (Map dec : decrypList) {
//            dec.put("ORG_MEM_NUM", (String)dec.get("MEM_NUM"));
//            
//            dec.put("MEM_NUM", null);
//            dec.put("COMP_CODE", user.getCompCode());
//            dec.put("BILL_DIVI_CODE", (String)spParam.get("BILL_DIVI_CODE"));
//            dec.put("FR_PUB_DATE", ( (String)spParam.get("FR_PUB_DATE") ).substring(0, 6));
//            dec.put("TO_PUB_DATE", ( (String)spParam.get("TO_PUB_DATE") ).substring(0, 6));
//            
//            super.commonDao.update("atx326ukrServiceImpl.updateDecrypto", dec);
//        }
        
        return 0;
    }
}
