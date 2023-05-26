package foren.unilite.modules.accnt.afb;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("afb121ukrService")
public class Afb121ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	/**
	 * 전용가능금액,예산잔액,이월가능금액
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public Object getPosBudgAmt(Map param) throws Exception {
		return super.commonDao.list("afb121ukrServiceImpl.getPosBudgAmt", param);
	}	
	
	/**
	 * 마스터그리드 조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */		
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map<String, Object>> selectList(Map param, LoginVO user) throws Exception {		
		return (List) super.commonDao.list("afb121ukrServiceImpl.selectList", param);
	}

	
	/**
	 * 결재요청 시, 예산전용신청번호(DIVERT_SMT_NUM) 자동채번하여 해당 컬럼에 입력하기 위한 로직
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map<String, Object>> getAutoNo (Map param, LoginVO user) throws Exception {		
		return (List) super.commonDao.list("afb121ukrServiceImpl.getAutoNo", param);
	}

	
	/**
	 * 마스터그리드 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
					
				}else if(dataListMap.get("method").equals("insertList")) {		
					insertList = (List<Map>)dataListMap.get("data");
					
				} else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteList(deleteList);
			if(insertList != null) this.insertList(insertList, user);
			if(updateList != null) this.updateList(updateList);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	/**
	 * 선택된 행을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> insertList(List<Map> paramList, LoginVO user) throws Exception {
		try{
			for(Map param :paramList ) {
				super.commonDao.insert("afb121ukrServiceImpl.insertList", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}	
		return paramList;
	}
	
	/**
	 * 선택된 행을 수정함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> updateList(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("afb121ukrServiceImpl.updateList", param);
		}
		return paramList;
	}
	
	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public List<Map> deleteList(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("afb121ukrServiceImpl.deleteList", param);
		}
		return paramList;
	}
	
    
    /**결재요청 버튼**/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAllRequest(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

        String keyValue = getLogKey();          

        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        List<Map> dataList = new ArrayList<Map>();
        List<List<Map>> resultList = new ArrayList<List<Map>>();
        
        /*Map<String, Object> autoSpParam = new HashMap<String, Object>();
        
        
        SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
        Date dateGet = new Date ();
        String dateGetString = dateFormat.format(dateGet);
        
        
        autoSpParam.put("COMP_CODE", user.getCompCode());
        autoSpParam.put("DIV_CODE", "");
        autoSpParam.put("TABLE_ID","AFB121T");
        autoSpParam.put("PREFIX", "A");
        autoSpParam.put("BASIS_DATE", dateGetString); 
        autoSpParam.put("AUTO_TYPE", "1");

        super.commonDao.queryForObject("afb121ukrServiceImpl.spAutoNum", autoSpParam);
        
        
        String divertSmtNum = (String) ObjUtils.getSafeString(autoSpParam.get("KEY_NUMBER"));*/
        
        
        //afb121t 에 
        
        String userCompCode = user.getCompCode();
        if(paramList != null)   {
            for(Map param: paramList) {
                
//                param.put("APRV_COMMENT", dataMaster.get("APRV_COMMENT"));
                dataList = (List<Map>)param.get("data");
    
                if(param.get("method").equals("insertDetailRequest")) {
                    param.put("data", insertRequestLogDetails(dataList, keyValue, "N",userCompCode) );  
                }
            }
        }

        Map<String, Object> spParam = new HashMap<String, Object>();

        spParam.put("COMP_CODE", user.getCompCode());
        spParam.put("KEY_VALUE", keyValue);
        spParam.put("APRV_TYPE", "DV");
        spParam.put("SLIP_TYPE", "");
        spParam.put("USER_ID"  , user.getUserID());
        super.commonDao.queryForObject("uspJoinsAccntAprvCheckAfb121ukr", spParam);
        
        
        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

        if(!ObjUtils.isEmpty(errorDesc)){
//            dataMaster.put("ELEC_SLIP_NO", "");
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
        } else {
           
            Map<String, Object> spParam2 = new HashMap<String, Object>();

            spParam2.put("COMP_CODE", user.getCompCode());
            spParam2.put("KEY_VALUE", keyValue);
            spParam2.put("APRV_TYPE", "DV");
            spParam2.put("USER_ID"  , user.getUserID());
            super.commonDao.queryForObject("uspJoinsAccntAprvBufAfb121ukr", spParam2);
            
            
            String errorDesc2 = ObjUtils.getSafeString(spParam2.get("ErrorDesc"));

            if(!ObjUtils.isEmpty(errorDesc2)){
//                dataMaster.put("ELEC_SLIP_NO", "");
                String[] messsage = errorDesc2.split(";");
                throw new  UniDirectValidateException(this.getMessage(errorDesc2, user));
            }else{

                Map<String, Object> spParam3 = new HashMap<String, Object>();

                spParam3.put("COMP_CODE", user.getCompCode());
                spParam3.put("KEY_VALUE", keyValue);
                spParam3.put("APRV_TYPE", "DV");
                spParam3.put("USER_ID"  , user.getUserID());
                super.commonDao.queryForObject("uspJoinsAccntAprvMainAfb121ukr", spParam3);
                
                
                String errorDesc3 = ObjUtils.getSafeString(spParam3.get("ErrorDesc"));

                if(!ObjUtils.isEmpty(errorDesc3)){
//                    dataMaster.put("ELEC_SLIP_NO", "");
                    String[] messsage = errorDesc3.split(";");
                    throw new  UniDirectValidateException(this.getMessage(errorDesc3, user));
                }else{

                    
                }
                
            }
        }
        
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
    /**
     * 버튼 -> 선택된 디테일 정보 로그 저장
     */
    public List<Map> insertRequestLogDetails(List<Map> params, String keyValue, String oprFlag, String userCompCode) throws Exception {

//        Map paramIns = params.get(0);
//        paramIns.put("KEY_VALUE", keyValue);
//        paramIns.put("OPR_FLAG", oprFlag);
//        paramIns.put("DIVERT_SMT_NUM", divertSmtNum);
//        super.commonDao.insert("afb121ukrServiceImpl.insertRequestLogDetail", paramIns);
        
        for(Map param: params)      {
            Map<String, Object> autoSpParam = new HashMap<String, Object>();
            SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
            Date dateGet = new Date ();
            String dateGetString = dateFormat.format(dateGet);
            
            
            autoSpParam.put("COMP_CODE", userCompCode);
            autoSpParam.put("DIV_CODE", "");
            autoSpParam.put("TABLE_ID","AFB121T");
            autoSpParam.put("PREFIX", "A");
            autoSpParam.put("BASIS_DATE", dateGetString); 
            autoSpParam.put("AUTO_TYPE", "1");

            super.commonDao.queryForObject("afb121ukrServiceImpl.spAutoNum", autoSpParam);
            
            
//            String divertSmtNum = (String) ObjUtils.getSafeString(autoSpParam.get("KEY_NUMBER"));
            
            param.put("KEY_VALUE", keyValue);
            param.put("OPR_FLAG", oprFlag);
            param.put("DIVERT_SMT_NUM", autoSpParam.get("KEY_NUMBER"));
            super.commonDao.update("afb121ukrServiceImpl.updateRequestDetail", param);
            super.commonDao.insert("afb121ukrServiceImpl.insertRequestLogDetail", param);
            
        }     
        return params;
    }
    
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
    public void insertDetailRequest(List<Map> params, LoginVO user) throws Exception {
        return;
    }
}
