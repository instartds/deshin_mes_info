package foren.unilite.modules.human.ham;

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
import foren.unilite.utils.AES256DecryptoUtils;

@Service( "ham850ukrService" )
public class Ham850ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "ham" )
    public List<Map<String, Object>> selectList( Map param, LoginVO loginVO ) throws Exception {
        AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
        
        if (param.get("DEC_FLAG").equals("Y")) {
            param.put("S_COMP_CODE", loginVO.getCompCode());
            param.put("S_USER_ID", loginVO.getUserID());
            
            if (param.get("QUARTER_TYPE").equals("1")) {
                param.put("SUPP_DATE_FR", "01");
                param.put("SUPP_DATE_TO", "03");
            } else if (param.get("QUARTER_TYPE").equals("2")) {
                param.put("SUPP_DATE_FR", "04");
                param.put("SUPP_DATE_TO", "06");
            } else if (param.get("QUARTER_TYPE").equals("3")) {
                param.put("SUPP_DATE_FR", "07");
                param.put("SUPP_DATE_TO", "09");
            } else if (param.get("QUARTER_TYPE").equals("4")) {
                param.put("SUPP_DATE_FR", "10");
                param.put("SUPP_DATE_TO", "12");
            }
            
            List<Map> decList = (List<Map>)super.commonDao.list("ham850ukrServiceImpl.selectList", param);
            
            if (!ObjUtils.isEmpty(decList)) {
                for (Map decMap : decList) {
                    if (!ObjUtils.isEmpty(decMap.get("REPRE_NUM"))) {
                        try {
                            //decryto() second 파라미터 : "RR"-주민번호   "RP"-여권번호   "RV"-비자번호  "RB"-계좌번호   "RC"-신용카드번호   "RF"-외국인 등록번호
                            decMap.put("REPRE_NUM_EXPOS", decrypto.decryto(decMap.get("REPRE_NUM").toString(), "RR"));
                        } catch (Exception e) {
                            decMap.put("REPRE_NUM_EXPOS", "데이타 오류(" + decMap.get("REPRE_NUM").toString() + ")");
                        }
                    } else {
                        decMap.put("REPRE_NUM_EXPOS", "");
                    }
                }
            }
            return (List)decList;
            
        } else {
            param.put("S_COMP_CODE", loginVO.getCompCode());
            param.put("S_USER_ID", loginVO.getUserID());
            
            if (param.get("QUARTER_TYPE").equals("1")) {
                param.put("SUPP_DATE_FR", "01");
                param.put("SUPP_DATE_TO", "03");
            } else if (param.get("QUARTER_TYPE").equals("2")) {
                param.put("SUPP_DATE_FR", "04");
                param.put("SUPP_DATE_TO", "06");
            } else if (param.get("QUARTER_TYPE").equals("3")) {
                param.put("SUPP_DATE_FR", "07");
                param.put("SUPP_DATE_TO", "09");
            } else if (param.get("QUARTER_TYPE").equals("4")) {
                param.put("SUPP_DATE_FR", "10");
                param.put("SUPP_DATE_TO", "12");
            }
            
            return (List)super.commonDao.list("ham850ukrServiceImpl.selectList", param);
        }
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "hum" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        if (paramList != null) {
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteDetail")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteDetail(deleteList, user);
            if (updateList != null) this.updateDetail(updateList, user);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )		// UPDATE
    public Integer updateDetail( List<Map> paramList, LoginVO user ) throws Exception {
        Map compCodeMap = new HashMap();
        compCodeMap.put("S_COMP_CODE", user.getCompCode());
        List<Map> chkList = (List<Map>)super.commonDao.list("ham850ukrServiceImpl.checkCompCode", compCodeMap);
        
        for (Map param : paramList) {
            String pay = (String)param.get("PAY_YYYYMM");
            String supp = (String)param.get("SUPP_YYYYMM");
            param.put("PAY_YYYYMM", pay.replace(".", ""));
            param.put("SUPP_YYYYMM", supp.replace(".", ""));
            
            String arr[] = param.toString().split(",");
            for (int i = 0; i < arr.length; i++) {
                System.out.println(arr[i]);
            }
            
            super.commonDao.update("ham850ukrServiceImpl.update1", param);
            super.commonDao.update("ham850ukrServiceImpl.update2", param);
            super.commonDao.update("ham850ukrServiceImpl.update3", param);
        }
        return 0;
    }
    
    @ExtDirectMethod( group = "hum", needsModificatinAuth = true )		// DELETE
    public Integer deleteDetail( List<Map> paramList, LoginVO user ) throws Exception {
        Map compCodeMap = new HashMap();
        compCodeMap.put("S_COMP_CODE", user.getCompCode());
        List<Map> chkList = (List)super.commonDao.list("ham850ukrServiceImpl.checkCompCode", compCodeMap);
        for (Map param : paramList) {
            String pay = (String)param.get("PAY_YYYYMM");
            String supp = (String)param.get("SUPP_YYYYMM");
            param.put("PAY_YYYYMM", pay.replace(".", ""));
            param.put("SUPP_YYYYMM", supp.replace(".", ""));
            super.commonDao.update("ham850ukrServiceImpl.delete", param);
        }
        return 0;
    }
}
