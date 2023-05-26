package foren.unilite.modules.z_kocis;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.multidb.cubrid.sp.SP_ACCNT_AFB800UKR;



@Service("s_afb800ukrkocisService")
public class S_Afb800ukrkocisServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	

	/**
	 * 마스터 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		
	public List<Map<String, Object>>  selectMaster(Map param) throws Exception {	
		
		return super.commonDao.list("s_afb800ukrkocisServiceImpl.selectMaster", param);
		
	}
	/**
	 * 디테일 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		
	public List<Map<String, Object>>  selectDetail(Map param) throws Exception {	
		
		return super.commonDao.list("s_afb800ukrkocisServiceImpl.selectDetail", param);
		
	}



	
	/**마스터만 저장시**/
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncMaster(S_Afb800ukrkocisModel param, LoginVO user, BindingResult result) throws Exception {


		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		param.setKEY_VALUE(keyValue);
		param.setCOMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
		param.setOPR_FLAG("U");
		

		super.commonDao.insert("s_afb800ukrkocisServiceImpl.insertLogMaster", param);
		
		
	
		//4.수입결의등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KEY_VALUE", keyValue);
        spParam.put("LANG_TYPE", user.getLanguage());
        spParam.put("USER_ID", user.getUserID());
        
        String inDraftNo = "";
        String errorDesc = "";
        
//        Map<String, Object> resultSp = SP_ACCNT_AFB700UKR.USP_ACCNT_AFB700UKR(spParam);

//        payDraftNo = (String) resultSp.get("RTN_PAY_DRAFT_NO");
//        errorDesc = (String) resultSp.get("ERROR_DESC");
        
        
        String resultSp = (String) super.commonDao.select("s_afb800ukrkocisServiceImpl.spAfb800ukr", spParam);
        
        int idx = resultSp.indexOf("|"); 
        
        inDraftNo = resultSp.substring(0, idx);
        
        errorDesc = resultSp.substring(idx+1);
        
        if(!ObjUtils.isEmpty(errorDesc)){
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
        }
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

		return extResult;
	}
	
	/**
	 * 수입결의등록(SP)-> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//logger.debug("[saveAll] paramMaster:" + paramMaster);
		//logger.debug("[saveAll] paramDetail:" + paramList);

		
		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		//2.수입결의등록마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		dataMaster.put("KEY_VALUE", keyValue);
		dataMaster.put("COMP_CODE", user.getCompCode());

		if (ObjUtils.isEmpty(dataMaster.get("IN_DRAFT_NO") )) {
			dataMaster.put("OPR_FLAG", "N");
		} else {
			dataMaster.put("OPR_FLAG", "U");
		}

		super.commonDao.insert("s_afb800ukrkocisServiceImpl.insertLogMaster", dataMaster);
		
		//3.수입결의등록디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
	
				if(param.get("method").equals("insertDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "N") );	
				} else if(param.get("method").equals("updateDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "U") );	
				} else if(param.get("method").equals("deleteDetail")) {
					param.put("data", insertLogDetails(dataList, keyValue, "D") );	
				}
			}
		}

		
		Map<String, Object> spParam = new HashMap<String, Object>();

        spParam.put("KEY_VALUE", keyValue);
        spParam.put("LANG_TYPE", user.getLanguage());
        spParam.put("USER_ID", user.getUserID());
        
        String inDraftNo = "";
        String errorDesc = "";
//  try{
        String resultSp = (String) super.commonDao.select("s_afb800ukrkocisServiceImpl.spAfb800ukr", spParam);
        
        int idx = resultSp.indexOf("|"); 
        
        inDraftNo = resultSp.substring(0, idx);
        errorDesc = resultSp.substring(idx+1);
      
//        inDraftNo = (String) resultSp.get("RTN_IN_DRAFT_NO");
//        errorDesc = (String) resultSp.get("ERROR_DESC");
//        
        if(!ObjUtils.isEmpty(errorDesc)){
            dataMaster.put("IN_DRAFT_NO", "");
//          String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
        } else {
            //마스터에 SET
            dataMaster.put("IN_DRAFT_NO", inDraftNo);
            //그리드에 SET
            for(Map param: paramList) {
                dataList = (List<Map>)param.get("data");    
                if(param.get("method").equals("insertDetail")) {
                    List<Map> datas = (List<Map>)param.get("data");
                    for(Map data: datas){
                        data.put("IN_DRAFT_NO", inDraftNo);
                    }
                }
            }   
        }
		
		
		
		
		
		
	/*	//4.수입결의등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		spParam.put("UserId", user.getUserID());
		
		super.commonDao.queryForObject("spUspAccntAfb800ukr", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		String inDraftNo = ObjUtils.getSafeString(spParam.get("InDraftNo"));

		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("IN_DRAFT_NO", "");
//			String[] messsage = errorDesc.split(";");
		    throw new  Exception(errorDescthis.getMessage(messsage[0], user));
		} else {
			//마스터에 SET
			dataMaster.put("IN_DRAFT_NO", inDraftNo);
			//그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");	
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("IN_DRAFT_NO", inDraftNo);
					}
				}
			}	
		}*/
		
		//5.수입결의마스터 정보 + 수입결의디테일 정보 결과셋 리턴
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	/**
	 * 수입결의등록 로그정보 저장
	 */
	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			
			super.commonDao.insert("s_afb800ukrkocisServiceImpl.insertLogDetail", param);
		}		

		return params;
	}
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{
				super.commonDao.update("s_afb800ukrkocisServiceImpl.insertDetail", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.insert("s_afb800ukrkocisServiceImpl.updateDetail", param);
		}
		 return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 try {
				 super.commonDao.delete("s_afb800ukrkocisServiceImpl.deleteDetail", param);
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
	    	}	
		 }
		 return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Object afb800ukrDelA (Map spParam, LoginVO user) throws Exception {
		
		super.commonDao.queryForObject("spUspAccntAfb800ukrDelA", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));				
		if(!ObjUtils.isEmpty(errorDesc)){
		    throw new  Exception(errorDesc);
		}else{
			return true;
		}
	}
}