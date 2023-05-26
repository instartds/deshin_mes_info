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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.utils.AES256DecryptoUtils;
import foren.unilite.utils.AES256EncryptoUtils;

@Service( "atx111ukrService" )
public class Atx111ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 세금계산서엑셀업로드 세금계산서 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("atx111ukrServiceImpl.selectList", param);
    }
    
    // sync All
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        if (paramList != null) {
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("updateList")) {
                    updateList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("deleteList")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                }
            }
            //수정
            if (updateList != null) this.updateList(updateList, paramMaster, user);
            //삭제
            if (deleteList != null) this.deleteList(deleteList, paramMaster, user);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    /**
     * 수정
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public List<Map> updateList( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        for (Map param : paramList) {
            if (dataMaster.get("ISSUE_GUBUN").equals("3") && ObjUtils.isEmpty(param.get("BROK_COMPANY_NUM"))) {
                throw new UniDirectValidateException(this.getMessage("발행구분이 [위수탁발행]일 경우, 수탁사업장등록번호는 필수 입력사항 입니다", user));
            }
            if (param.get("COMPANY_NUM").toString().length() > 12) {
                param.put("COMPANY_NUM", "");
            }
            super.commonDao.update("atx111ukrServiceImpl.updateList", param);
        }
        return paramList;
    }
    
    /**
     * 삭제
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void deleteList( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        for (Map param : paramList) {
            super.commonDao.delete("atx111ukrServiceImpl.deleteList", param);
        }
        return;
    }
    
    /**
     * 엑셀업로드 관련
     * 
     * @param jobID
     * @param param
     */
    public void excelValidate( String jobID, Map param ) throws Exception {
        //주민등록번호 암호화
        AES256EncryptoUtils encrypto = new AES256EncryptoUtils();
        
        //에러메세지 처리
        String ERR_FLAG = "";
        String errorDesc = "";
        
        Object excelCheck = super.commonDao.select("atx111ukrServiceImpl.beforeExcelCheck", param);
        
        //템프 테이블에 insert 시, 오류가 없으면...
        if (ObjUtils.isEmpty(excelCheck)) {
            //업로드 된 데이터 가져오기
            List<Map> getData = (List<Map>)super.commonDao.list("atx111ukrServiceImpl.getData", param);
            
            if (!getData.isEmpty()) {
                for (Map data : getData) {
                    param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
                    param.put("COMPANY_NUM", data.get("COMPANY_NUM"));
                    String billType = (String)data.get("BILL_TYPE");				//11:세금계산서, 20:계산서
                    String companyNum = (String)data.get("COMPANY_NUM");				//11:세금계산서, 20:계산서
                    if (ObjUtils.isNotEmpty(billType)) {
                        //업로드 된 데이터가 "세금계산서" 일 경우, 부가세가 0이면 오류 메세지 update
                        if (billType.equals("11")) {
                            if (ObjUtils.isEmpty(data.get("TAX_AMT")) || ObjUtils.parseDouble(data.get("TAX_AMT")) == 0.000000) {
                                ERR_FLAG = "Y";
                                param.put("MSG", "세금계산서의 세액은 '0'일 수 없습니다. \n 데이터를 확인하세요.");
                                super.commonDao.update("atx111ukrServiceImpl.insertErrorMsg", param);
                                
                            }
                            
                            //업로드 된 데이터가 "계산서" 일 경우, 부가세가 0이 아니면 오류 메세지 update	            		
                        } else {
                            if (ObjUtils.parseDouble(data.get("TAX_AMT")) != 0.000000) {
                                ERR_FLAG = "Y";
                                param.put("MSG", "계산서의 세액은 '0'이어야 합니다. \n 데이터를 확인하세요.");
                                super.commonDao.update("atx111ukrServiceImpl.insertErrorMsg", param);
                            }
                        }
                        
                    } else {		//"계산서 구분을 선택하여 다시 업로드 해 주십시오" 메세지 update
                        ERR_FLAG = "Y";
                        param.put("MSG", "계산서 구분을 선택하여 다시 업로드 해 주십시오.");
                        super.commonDao.update("atx111ukrServiceImpl.insertErrorMsg", param);
                    }
                    if (!ERR_FLAG.equals("Y")) {
                        if (companyNum.length() >= 13) {
                            param.put("TOP_NUM", encrypto.encryto(companyNum));
                            param.put("COMPANY_NUM", "");
                            super.commonDao.update("atx111ukrServiceImpl.updateTopNum", param);
                        }
                    }
                }
                
                if (!ERR_FLAG.equals("Y")) {
                    //실제 테이블에 UPDATE
                    try {
                        super.commonDao.update("atx111ukrServiceImpl.excelValidate", param);
                        
                    } catch (Exception e) {
                        param.put("MSG", "데이터 업로드 중 오류가 발생했습니다. \n 관리자에게 문의하시기 바랍니다.");
                        super.commonDao.update("atx111ukrServiceImpl.insertErrorMsg", param);
                    }
                }
            }
        }
    }
    
    /**
     * 에러 메세지 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public Object getErrMsg( Map param, LoginVO user ) throws Exception {
        return super.commonDao.select("atx111ukrServiceImpl.getErrMsg", param);
    }
    
    /**
     * SP호출을 위한 로그테이블 생성 / SP 호출 로직
     * 
     * @param paramList
     * @param paramMaster
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> callProcedure( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        if (paramList != null) {
            List<Map> insertList = null;
            
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("runProcedure")) {
                    insertList = (List<Map>)dataListMap.get("data");
                }
            }
            if (insertList != null) this.runProcedure(insertList, paramMaster, user);
        }
        
        paramList.add(0, paramMaster);
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    private void runProcedure( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        //주민등록번호 암호화
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        String returnStr = "";
        
        //1.로그테이블에서 사용할 Key 생성      
        String keyValue = getLogKey();
        
        //2.로그테이블에 KEY_VALUE 업데이트
        for (Map param : paramList) {
            param.put("KEY_VALUE", keyValue);
            String repreNum = (String)param.get("COMPANY_NUM");
            if (repreNum.length() > 12) {
                returnStr = decrypto.decryto(repreNum);
                param.put("COMPANY_NUM", returnStr); 			//복호화 되어 있는 값
                param.put("COMPANY_NUM_EXPOS", repreNum); 		//암호화 되어 있는 값
            }
            super.commonDao.insert("atx111ukrServiceImpl.insertLogTable", param);
        }
        
        //SP에서 작성한 변수에 맞추기
        //SP 호출시 넘길 MAP 정의
        Map<String, Object> spParam = new HashMap<String, Object>();
        //작업 구분 (N:자동기표, D:기표취소)
        String oprFlag = (String)dataMaster.get("OPR_FLAG");
        //language type
        String langType = (String)dataMaster.get("LANG_TYPE");
        //에러메세지 처리
        String errorDesc = "";
        
        //OPR_FLAG 값에 따라 다른 SP 호출로직 구현
        //반영취소이면..
        if (oprFlag.equals("D")) {
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("OPR_FLAG", oprFlag);
            spParam.put("LANG_TYPE", langType);
            spParam.put("USER_ID", user.getUserID());
            spParam.put("ERROR_DESC", "");
            super.commonDao.queryForObject("atx111ukrServiceImpl.cancelSlip", spParam);
            
            //세금계산서 반영이면
        } else if (oprFlag.equals("A")) {
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("OPR_FLAG", oprFlag);
            spParam.put("LANG_TYPE", langType);
            spParam.put("USER_ID", user.getUserID());
            spParam.put("ERROR_DESC", "");
            super.commonDao.queryForObject("atx111ukrServiceImpl.runAutoSlip", spParam);
            
            //거래처 확인이면
        } else {
            throw new UniDirectValidateException("");//sp필요
        }
        
        errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        if (!ObjUtils.isEmpty(errorDesc)) {
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        }
        
        return;
    }
}
