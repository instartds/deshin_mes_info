package foren.unilite.modules.z_kodi;

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
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("s_pms300ukrv_kodiService")
public class S_pms300ukrv_kodiServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	

	/**
	 * 수주정보 Master 조회 
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public Object a(Map param) throws Exception {
		return super.commonDao.select("s_pms300ukrv_kodiServiceImpl.a", param);
	}
	
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("s_pms300ukrv_kodiServiceImpl.selectMaster", param);
	}
	
	
	/**
	 * 
	 * 생산정보 Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("s_pms300ukrv_kodiServiceImpl.selectDetailList", param);
	}

	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mpo")
	public List<Map<String, Object>>  inspecQtyCheck(Map param) throws Exception {
		
		return  super.commonDao.list("s_pms300ukrv_kodiServiceImpl.inspecQtyCheck", param);
	}
	

	/**
	 * 
	 * 생산량 참조 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectEstiList(Map param) throws Exception {
		return super.commonDao.list("s_pms300ukrv_kodiServiceImpl.selectEstiList", param);
	}

	
	/**
	 * 접수등록(통합) 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
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
				if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
				if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
				if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";
	
				for(Map param:  dataList) {
					param.put("KEY_VALUE", keyValue);
					param.put("OPR_FLAG", oprFlag);
					param.put("data", super.commonDao.insert("s_pms300ukrv_kodiServiceImpl.insertLogMaster", param));			
	
			
					Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
					
					String prodtNums = (String) dataMaster.get("PRODT_NUMS");
		
					//4.저장 Stored Procedure 실행
			        Map<String, Object> spParam = new HashMap<String, Object>();
			
			        spParam.put("KeyValue", keyValue);
			        spParam.put("LangCode", user.getLanguage());
			        
			
			        super.commonDao.queryForObject("s_pms300ukrv_kodiServiceImpl.spReceiving", spParam);
			        
			        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
			        
			      //5.저장후update 실행
			        Map<String, Object> upParam = new HashMap<String, Object>();
			        
			        upParam.put("PRODT_NUMS", prodtNums);
			        upParam.put("COMP_CODE", user.getCompCode());
			        upParam.put("DIV_CODE", param.get("DIV_CODE"));
			        upParam.put("ITEM_CODE", param.get("ITEM_CODE"));
			        upParam.put("LOT_NO", param.get("LOT_NO"));
			        upParam.put("USER_ID",	user.getUserID());
			        upParam.put("STATUS",	oprFlag);
					
			        if(upParam.get("STATUS").equals("N")) {
			        	String receiptNum =  ObjUtils.getSafeString(spParam.get("RECEIPT_NUM"));
			        	upParam.put("RECEIPT_NUM",	receiptNum);
			        }else if(upParam.get("STATUS").equals("D")) {			        	
			        	upParam.put("RECEIPT_NUM",	param.get("RECEIPT_NUM"));
			        }
			        
			    	//생산실적정보에 접수번호, 순번 update처리
					if(upParam.get("STATUS").equals("N")) {
						super.commonDao.update("s_pms300ukrv_kodiServiceImpl.updatePmr200t", upParam);
					}else if(upParam.get("STATUS").equals("D")) {
						super.commonDao.update("s_pms300ukrv_kodiServiceImpl.updatePmr200t2", upParam);
					}	        
		
			        if(!ObjUtils.isEmpty(errorDesc)){
			            dataMaster.put("RECEIPT_NUM", "");
			            String[] messsage = errorDesc.split(";");
			            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			        } else {        	
			            dataMaster.put("RECEIPT_NUM", ObjUtils.getSafeString(spParam.get("RECEIPT_NUM")));                
			            
			        }
			}
		}    
  
      paramList.add(0, paramMaster);
      return  paramList;
     }
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // INSERT
    public Integer insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        
        return 0;
    } 
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // UPDATE
    public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        
        return 0;
    } 
    
    
    @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
    public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
        
        return 0;
    }
}
