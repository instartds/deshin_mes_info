package foren.unilite.modules.sales.str;

import java.util.ArrayList;
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

@Service("str410ukrvService")
public class Str410ukrvServiceImpl  extends TlabAbstractServiceImpl {	
    private final Logger logger = LoggerFactory.getLogger(this.getClass()); 
    
	/**
	 * 
	 * 전자거래명세서 발행 MASTER 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  selectMaster(Map param) throws Exception {	
		return  super.commonDao.list("str410ukrvServiceImpl.selectMaster", param); 
	}
	
	/**
	 * 
	 * 전자거래명세서 발행 Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  selectDetail(Map param) throws Exception {	
		return  super.commonDao.list("str410ukrvServiceImpl.selectDetail", param); 
	}
	
	/**
	 * 
	 * 연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  getGsBillYN(Map param) throws Exception {	
		return  super.commonDao.list("str410ukrvServiceImpl.getGsBillYN", param); 
	}
	
	/**
     * 저장
     * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
     * @param paramMaster 폼(마스터 정보)의 기본 정보
     * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
     * @throws Exception
     */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
    public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
    logger.debug("[saveAll] paramDetail:" + paramList);

     //1.로그테이블에서 사용할 KeyValue 생성
     String keyValue = getLogKey();      
       
     //2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
     List<Map> dataList = new ArrayList<Map>();
     List<List<Map>> resultList = new ArrayList<List<Map>>();
     
     for(Map paramData: paramList) {   
      
         dataList = (List<Map>) paramData.get("data");
         String oprFlag = "N";
         if(paramData.get("method").equals("insertDetail")) oprFlag="N";
         if(paramData.get("method").equals("updateDetail")) oprFlag="U";
         if(paramData.get("method").equals("deleteDetail")) oprFlag="D";
   
         for(Map param:  dataList) {
           param.put("KEY_VALUE", keyValue);
           param.put("OPR_FLAG", oprFlag);
           param.put("data", super.commonDao.insert("str410ukrvServiceImpl.insertLogMaster", param));
         }
     }
   //4.매출저장 Stored Procedure 실행
           Map<String, Object> spParam = new HashMap<String, Object>();

           spParam.put("KeyValue", keyValue);
           spParam.put("LangCode", user.getLanguage());

           super.commonDao.queryForObject("str410ukrvServiceImpl.spReceiving", spParam);
           
           String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
           
           //출하지시 마스터 출하지시 번호 update
           Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

//           if(!ObjUtils.isEmpty(errorDesc)){
//               dataMaster.put("INOUT_NUM", "");
//               String[] messsage = errorDesc.split(";");
//               throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
//           } else {
//               dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InoutNum")));
//           }
     
     paramList.add(0, paramMaster);
     return  paramList;
    }
    
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
        return params;
    }
    
    
    @SuppressWarnings("rawtypes")
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {    
        return params;
    }
    
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
    public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
        
    }
}
