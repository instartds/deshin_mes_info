package foren.unilite.modules.human.hpb;

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

@Service( "hpb300ukrService" )
public class Hpb300ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 소득자 목록 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "hpb" )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return (List)super.commonDao.list("hpb300ukrServiceImpl.selectList", param);
    }
    
    /**
     * 부서 조회 권한
     * 
     * @param param
     * @return
     * @throws Exception
     */
    public List userDept( LoginVO loginVO ) throws Exception {
        Map<String, String> param = new HashMap<String, String>();
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("S_USER_ID", loginVO.getUserID());
        return (List)super.commonDao.list("hpb300ukrServiceImpl.userDept", param);
    }
    
    /**
     * 소득자코드 중복 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( value = ExtDirectMethodType.FORM_LOAD, group = "hpb" )
    public Map chkFamilyRepreNum( Map param ) throws Exception {
        return (Map)super.commonDao.select("hpb300ukrServiceImpl.chkFamilyRepreNum", param);
    }
    
    /**
     * 공통코드 H175 사업기타소득자코드 거래처코드기준 자동채번 및 반영여부에 따른 코드 채번 관련
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "hpb" )
    public Object getAutoCustomCode( Map param ) throws Exception {
        return super.commonDao.select("hpb300ukrServiceImpl.getAutoCustomCode", param);
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "hpb" )
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
            if (deleteList != null) this.deleteDetail(deleteList, user, paramMaster);
            if (insertList != null) this.insertDetail(insertList, user, paramMaster);
            if (updateList != null) this.updateDetail(updateList, user, paramMaster);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hpb" )
    public void insertDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
//        try {
            Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
            
            for (Map param : paramList) {
            	String compNum = ObjUtils.getSafeString(param.get("COMP_NUM"));
            	String compZipCode = ObjUtils.getSafeString(param.get("COMP_ZIP_CODE"));
            	String zipCode = ObjUtils.getSafeString(param.get("ZIP_CODE"));
            	String repreNum = ObjUtils.getSafeString(param.get("REPRE_NUM"));
            	String foreignNum = ObjUtils.getSafeString(param.get("FOREIGN_NUM"));
            	
                param.put("COMP_NUM", param.get("COMP_NUM").toString().replace("-", "")); /* 사업자등록번호 */
                param.put("COMP_ZIP_CODE", param.get("COMP_ZIP_CODE").toString().replace("-", "")); /* 회사주소 우편번호 */
                param.put("ZIP_CODE", param.get("ZIP_CODE").toString().replace("-", "")); /* 개인주소 우편번호 */
                param.put("REPRE_NUM", param.get("REPRE_NUM").toString().replace("-", "")); /* 주민등록번호 */
                param.put("FOREIGN_NUM", param.get("FOREIGN_NUM").toString().replace("-", "")); /* 외국인등록번호 */
                
                String checkValueName = "";
                List<Map> checkName = (List<Map>)super.commonDao.list("hpb300ukrServiceImpl.checkName", param);//hpb100t에 동일한 주민등록번호 체크
                if (!checkName.isEmpty()) {
                    checkValueName = ObjUtils.getSafeString(checkName.get(0).get("NAME"));
                }
                if (!ObjUtils.isEmpty(checkValueName)) {
                    String line = System.getProperty("line.separator");   //줄바꿈관련 각 운영체제에 맞추기 위해
                    String errMessage = "동일한 주민등록번호로 등록된 소득자가 존재합니다.\n이미 등록 되있는 소득자 성명 : " + checkValueName + "\n현재 등록 하려는 소득자 성명 : " + param.get("NAME");
                    errMessage = errMessage.replace("\n", line);
                    throw new Exception(errMessage);
                } else {
                    if (!ObjUtils.isEmpty(dataMaster.get("AUTO_CODE"))) {
                        if (dataMaster.get("AUTO_CODE").equals("Y")) {
                            Map compCodeMap = new HashMap();
                            compCodeMap.put("S_COMP_CODE", user.getCompCode());
                            List<Map> customCode = (List<Map>)super.commonDao.list("hpb300ukrServiceImpl.getAutoCustomCode", compCodeMap);
                            if (!customCode.isEmpty()) {
                                param.put("PERSON_NUMB", customCode.get(0).get("CUSTOM_CODE"));
                            }
                            String checkValue1 = "";
                            List<Map> checkTopNum = (List<Map>)super.commonDao.list("hpb300ukrServiceImpl.checkTopNum", param);//bcm100t에 주민등록번호 비교
                            if (!checkTopNum.isEmpty()) {
                                checkValue1 = ObjUtils.getSafeString(checkTopNum.get(0).get("CUSTOM_CODE"));
                                param.put("PERSON_NUMB", checkValue1);
                                
                                super.commonDao.insert("hpb300ukrServiceImpl.insertList", param);
                                super.commonDao.update("hpb300ukrServiceImpl.updateListAutoCustom", param);
                                
                            } else {
                                super.commonDao.insert("hpb300ukrServiceImpl.insertList", param);
                                super.commonDao.update("hpb300ukrServiceImpl.insertListAutoCustom", param);
                            }
                            
                            if (!ObjUtils.isEmpty(param.get("BANK_ACCOUNT"))) {
                                String checkValue2 = "";
                                List<Map> checkBankBookNum = (List<Map>)super.commonDao.list("hpb300ukrServiceImpl.checkBankBookNum", param);//bcm130t에 계좌번호 비교
                                
                                //UPDATE 시 BOOK_NAME 생성. 은행이름+계좌번호 뒤 5자리
                                String returnStr = "";
                                AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
                                
                                String bankAccnt = (String)param.get("BANK_ACCOUNT");
                                returnStr = decrypto.getDecrypto("1", bankAccnt);
                                param.put("BANK_ACCOUNT_DEC", returnStr);
                                
                                if (checkBankBookNum.isEmpty()) {
                                    super.commonDao.insert("hpb300ukrServiceImpl.insertListAutoBankAccount", param);
                                }
                            }
                            
                            
                        } else {
                            super.commonDao.insert("hpb300ukrServiceImpl.insertList", param);
                            
                        }
                    } else {
                        super.commonDao.insert("hpb300ukrServiceImpl.insertList", param);
                    }
                }
                
                param.put("COMP_NUM", compNum);
                param.put("COMP_ZIP_CODE", compZipCode);
                param.put("ZIP_CODE", zipCode);
                param.put("REPRE_NUM", repreNum);
                param.put("FOREIGN_NUM", foreignNum);
            }
//        } catch (SQLException e) {
//        		String errCode=String.valueOf(e.getErrorCode()); 
//                throw new UniDirectValidateException(this.getMessage(errCode, user));
//	    } catch (Exception e) {
//	            throw new UniDirectValidateException(this.getMessage("2627", user));	    
//	    }
//        
//        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hpb" )
    public void updateDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        for (Map param : paramList) {
        	
        	String compNum = ObjUtils.getSafeString(param.get("COMP_NUM"));
        	String compZipCode = ObjUtils.getSafeString(param.get("COMP_ZIP_CODE"));
        	String zipCode = ObjUtils.getSafeString(param.get("ZIP_CODE"));
        	String repreNum = ObjUtils.getSafeString(param.get("REPRE_NUM"));
        	String foreignNum = ObjUtils.getSafeString(param.get("FOREIGN_NUM"));
        	
            param.put("COMP_NUM", param.get("COMP_NUM").toString().replace("-", "")); /* 사업자등록번호 */
            param.put("COMP_ZIP_CODE", param.get("COMP_ZIP_CODE").toString().replace("-", "")); /* 회사주소 우편번호 */
            param.put("ZIP_CODE", param.get("ZIP_CODE").toString().replace("-", "")); /* 개인주소 우편번호 */
            param.put("REPRE_NUM", param.get("REPRE_NUM").toString().replace("-", "")); /* 주민등록번호 */
            param.put("FOREIGN_NUM", param.get("FOREIGN_NUM").toString().replace("-", "")); /* 외국인등록번호 */
            if (!ObjUtils.isEmpty(dataMaster.get("AUTO_CODE"))) {
                if (dataMaster.get("AUTO_CODE").equals("Y")) {
                    
                    super.commonDao.update("hpb300ukrServiceImpl.updateList", param);
                    super.commonDao.update("hpb300ukrServiceImpl.updateListAutoCustom", param);
                    
                    if (!ObjUtils.isEmpty(param.get("BANK_ACCOUNT"))) {
                        String checkValue3 = "";
                        List<Map> checkBankBookNum = (List<Map>)super.commonDao.list("hpb300ukrServiceImpl.checkBankBookNum", param);//bcm130t에 계좌번호 비교
                        
                        //UPDATE 시 BOOK_NAME 생성. 은행이름+계좌번호 뒤 5자리
                        String returnStr = "";
                        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
                        
                        String bankAccnt = (String)param.get("BANK_ACCOUNT");
                        returnStr = decrypto.getDecrypto("1", bankAccnt);
                        param.put("BANK_ACCOUNT_DEC", returnStr);
                        
                        if (checkBankBookNum.isEmpty()) {
                            super.commonDao.insert("hpb300ukrServiceImpl.insertListAutoBankAccount", param);
                        }
                    }
                } else {
                    super.commonDao.update("hpb300ukrServiceImpl.updateList", param);
                }
            } else {
                super.commonDao.update("hpb300ukrServiceImpl.updateList", param);
            }
            
            param.put("COMP_NUM", compNum);
            param.put("COMP_ZIP_CODE", compZipCode);
            param.put("ZIP_CODE", zipCode);
            param.put("REPRE_NUM", repreNum);
            param.put("FOREIGN_NUM", foreignNum);
        }
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hpb" )
    public void deleteDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        for (Map param : paramList) {
            String checkValue4 = "";
            List<Map> beforeDeleteCheck1 = (List<Map>)super.commonDao.list("hpb300ukrServiceImpl.beforeDeleteCheck1", param);
            
            if (!beforeDeleteCheck1.isEmpty()) {
                throw new UniDirectValidateException(this.getMessage("547", user)); // 삭제불가 
            } else {
                if (!ObjUtils.isEmpty(dataMaster.get("AUTO_CODE"))) {
                    if (dataMaster.get("AUTO_CODE").equals("Y")) {
                        Map<String, Object> beforeDeleteCheck2 = (Map<String, Object>)super.commonDao.select("hpb300ukrServiceImpl.beforeDeleteCheck2", param);
                        
                        if (Integer.parseInt(beforeDeleteCheck2.get("CNT").toString()) > 0) {
                            throw new UniDirectValidateException(this.getMessage("547", user));
                        } else {
                            List<Map> beforeDeleteCheck3 = (List<Map>)super.commonDao.list("hpb300ukrServiceImpl.beforeDeleteCheck3", param);
                            if (!beforeDeleteCheck3.isEmpty()) {
                                super.commonDao.delete("hpb300ukrServiceImpl.deleteList", param);
                            } else {
                                super.commonDao.delete("hpb300ukrServiceImpl.deleteListAutoCustom", param);
                                super.commonDao.delete("hpb300ukrServiceImpl.deleteListAutoBankAccount", param);
                            }
                        }
                    } else {
                        super.commonDao.delete("hpb300ukrServiceImpl.deleteList", param);
                    }
                } else {
                    super.commonDao.delete("hpb300ukrServiceImpl.deleteList", param);
                }
            }
        }
        return;
    }
    
    /*
    *//**
       * 결과폼 저장
       * 
       * @param param
       * @return
       * @throws Exception
       */
    /*
     * @ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "hpb") public ExtDirectFormPostResult submitList(Hpb300ukrModel hpb300ukrModel, LoginVO loginVO, BindingResult result) throws Exception { hpb300ukrModel.setS_COMP_CODE(loginVO.getCompCode()); hpb300ukrModel.setS_USER_ID(loginVO.getUserID()); Map<String, String> map = new HashMap<String, String>(); map.put("S_COMP_CODE", loginVO.getCompCode()); map.put("DED_TYPE", hpb300ukrModel.getDED_TYPE()); map.put("PERSON_NUMB", hpb300ukrModel.getPERSON_NUMB()); int cnt = (int)chkFamilyRepreNum(map).get("CNT"); // update if (cnt > 0) { logger.debug("update!"); // 사업자 번호의 '-'를 제거함. hpb300ukrModel.setCOMP_NUM(hpb300ukrModel.getCOMP_NUM().replaceAll("-", "")); super.commonDao.update("hpb300ukrServiceImpl.updateList", hpb300ukrModel); // insert } else { logger.debug("insert!"); super.commonDao.insert("hpb300ukrServiceImpl.insertList", hpb300ukrModel); } ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result); return
     * extResult; }
     *//**
       * 추가를 위한 더미 메소드 실제 동작은 form post를 통해서 이루어짐
       * 
       * @param paramList
       * @return
       * @throws Exception
       */
    /*
     * @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpb") public Integer insertList(List<Map> paramList) throws Exception { return 0; }
     *//**
       * 수정을 위한 더미 메소드 실제 동작은 form post를 통해서 이루어짐
       * 
       * @param paramList
       * @return
       * @throws Exception
       */
    /*
     * @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpb") public Integer updateList(List<Map> paramList) throws Exception { return 0; }
     *//**
       * 선택된 행을 삭제함
       * 
       * @param param
       * @return
       * @throws Exception
       *//*
         * @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpb") public List<Map> deleteList(List<Map> paramList) throws Exception { for(Map param :paramList ) { super.commonDao.delete("hpb300ukrService.deleteList", param); } return paramList; }
         * @ExtDirectMethod(group = "hpb") public Integer syncAll(Map param) throws Exception { logger.debug("syncAll:" + param); return 0; }
         */
}
