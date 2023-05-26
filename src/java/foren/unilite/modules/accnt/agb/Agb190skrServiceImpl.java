package foren.unilite.modules.accnt.agb;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service( "agb190skrService" )
public class Agb190skrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @ExtDirectMethod( group = "Accnt" )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        
        List<Map> sumValue = (List<Map>)super.commonDao.list("agb190skrServiceImpl.selectList", param);
        List<Map<String, Object>> newData = new ArrayList();
        
        String acDate = "누  계";
        String gubun = "5";
        String janDivi = "";
        
        double drAmtI = 0.0;		// 차변 
        double crAmtI = 0.0;		// 대변
        double bAmtI = 0.0;		// 잔액
        
        for (int i = 0; i < sumValue.size(); i++) {
            newData.add(sumValue.get(i));
            
            String accnt = (String)sumValue.get(i).get("ACCNT");
            
            String nextAccnt = "";
            String beforeAccnt = "";
            janDivi = (String)sumValue.get(i).get("JAN_DIVI");
            
            if (sumValue.size() > i + 1) {
                nextAccnt = (String)sumValue.get(i + 1).get("ACCNT");
            }
            if (i > 0) {
                beforeAccnt = (String)sumValue.get(i - 1).get("ACCNT");
            }
            if (( sumValue.get(i).get("GUBUN").equals("1") || sumValue.get(i).get("GUBUN").equals("3") ) && !accnt.equals(beforeAccnt)) {
                drAmtI = ObjUtils.parseDouble(sumValue.get(i).get("DR_AMT_I"));
                crAmtI = ObjUtils.parseDouble(sumValue.get(i).get("CR_AMT_I"));
                bAmtI = ObjUtils.parseDouble(sumValue.get(i).get("B_AMT_I"));
            }
            
            if (( sumValue.get(i).get("GUBUN").equals("1") || sumValue.get(i).get("GUBUN").equals("3") || !sumValue.get(i).get("GUBUN").equals("4") ) && accnt.equals(beforeAccnt)) {
                drAmtI += ObjUtils.parseDouble(sumValue.get(i).get("DR_AMT_I"));
                crAmtI += ObjUtils.parseDouble(sumValue.get(i).get("CR_AMT_I"));
                bAmtI += ObjUtils.parseDouble(sumValue.get(i).get("B_AMT_I"));
            }
            
            if (!accnt.equals(nextAccnt)) { // 누계를 만들어 할 조건		
                if (i > 0) {	//첫째행 아닐시	
                    if (!accnt.equals(beforeAccnt)) {	// 새로운 계정과목의 첫째 행 일시
                        //double preAmtI =  ObjUtils.parseDouble(sumValue.get(i-1).get("B_AMT_I")); //이전행 잔액			
                        
                    } else if (ObjUtils.parseInt(sumValue.get(i).get("GUBUN")) < 4) {  //이월금액, 날짜포함 일시
                        double preAmtI = ObjUtils.parseDouble(sumValue.get(i - 1).get("B_AMT_I")); //이전행 잔액
                        double localDrAmtI = ObjUtils.parseDouble(sumValue.get(i).get("DR_AMT_I")); //현재행 차변
                        double localCrAmtI = ObjUtils.parseDouble(sumValue.get(i).get("CR_AMT_I")); //현재행 대변
                        
                        if (ObjUtils.parseInt(sumValue.get(i - 1).get("GUBUN")) == 4) { //위에 행이 소계일시는 전전 row잔액을 가져와야함
                            preAmtI = ObjUtils.parseDouble(sumValue.get(i - 2).get("B_AMT_I")); //전전행 잔액
                        }
                        if (janDivi.equals("1")) {
                            sumValue.get(i).put("B_AMT_I", preAmtI + localDrAmtI - localCrAmtI);
                        } else if (janDivi.equals("2")) {
                            sumValue.get(i).put("B_AMT_I", preAmtI - localDrAmtI + localCrAmtI);
                        }
                    }
                }
                
                Map mergeData = new HashMap();
                mergeData.put("AC_DATE", acDate);
                mergeData.put("GUBUN", gubun);
                mergeData.put("DR_AMT_I", drAmtI);  // value 는 계산된값
                mergeData.put("CR_AMT_I", crAmtI);  // value 는 계산된값	
                
                if (janDivi.equals("1")) {
                    mergeData.put("B_AMT_I", drAmtI - crAmtI);
                } else if (janDivi.equals("2")) {
                    mergeData.put("B_AMT_I", crAmtI - drAmtI);
                }
                //mergeData.put("B_AMT_I" , bAmtI);  // value 는 계산된값
                
                newData.add(mergeData);
                drAmtI = 0.0;
                crAmtI = 0.0;
                bAmtI = 0.0;
                
            } else {	//누계row가 아닐시
                if (i > 0) {	//첫째행 아닐시	
                    if (!accnt.equals(beforeAccnt)) {	// 새로운 계정과목의 첫째 행 일시
                    
                    } else if (ObjUtils.parseInt(sumValue.get(i).get("GUBUN")) < 4) {  //이월금액, 날짜포함 일시
                        double preAmtI = ObjUtils.parseDouble(sumValue.get(i - 1).get("B_AMT_I")); //이전행 잔액
                        double localDrAmtI = ObjUtils.parseDouble(sumValue.get(i).get("DR_AMT_I")); //현재행 차변
                        double localCrAmtI = ObjUtils.parseDouble(sumValue.get(i).get("CR_AMT_I")); //현재행 대변
                        
                        if (ObjUtils.parseInt(sumValue.get(i - 1).get("GUBUN")) == 4) { //위에 행이 소계일시는 전전 row잔액을 가져와야함
                            preAmtI = ObjUtils.parseDouble(sumValue.get(i - 2).get("B_AMT_I")); //전전행 잔액
                        }
                        if (janDivi.equals("1")) {
                            sumValue.get(i).put("B_AMT_I", preAmtI + localDrAmtI - localCrAmtI);
                        } else if (janDivi.equals("2")) {
                            sumValue.get(i).put("B_AMT_I", preAmtI - localDrAmtI + localCrAmtI);
                        }
                    }
                }
            }
        }
        return newData;
    }
}
