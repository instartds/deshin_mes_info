package foren.unilite.modules.z_kocis;

import java.nio.charset.StandardCharsets;
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
import foren.unilite.modules.accnt.atx.Atx300ukrModel;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.multidb.cubrid.sp.SP_ACCNT_AFB700UKR;



@Service("s_afb700ukrkocisService")
public class S_Afb700ukrkocisServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	
	
	/**
	 * 마스터 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kocis")		
	public List<Map<String, Object>>  selectMaster(Map param) throws Exception {	
		
		return super.commonDao.list("s_afb700ukrkocisServiceImpl.selectMaster", param);
		
	}
	/**
	 * 디테일 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_kocis")		
	public List<Map<String, Object>>  selectDetail(Map param) throws Exception {	
		
		return super.commonDao.list("s_afb700ukrkocisServiceImpl.selectDetail", param);
		
	}
	
	/**마스터만 저장시**/
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "z_kocis")
	public ExtDirectFormPostResult syncMaster(S_Afb700ukrkocisModel param, LoginVO user, BindingResult result) throws Exception {

		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			

		//2.지출결의등록마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
//		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

//		param.put("KEY_VALUE", keyValue);
//		param.put("COMP_CODE", user.getCompCode());
//		param.put("OPR_FLAG", "U");
		param.setKEY_VALUE(keyValue);
		param.setS_COMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
        param.setS_DEPT_CODE(user.getDeptCode());
        param.setS_DIV_CODE(user.getDivCode());
		param.setOPR_FLAG("U");
		
		if(param.getNEXT_GUBUN() == "true"){
	        param.setNEXT_GUBUN("Y");
        }else{
            param.setNEXT_GUBUN("N");
        }
		
		super.commonDao.insert("s_afb700ukrkocisServiceImpl.insertLogMaster", param);
		
        Map<String, Object> spParam = new HashMap<String, Object>();

        spParam.put("KEY_VALUE", keyValue);
        spParam.put("LANG_TYPE", user.getLanguage());
        spParam.put("USER_ID", user.getUserID());
        
        String payDraftNo = "";
        String errorDesc = "";
        
//        Map<String, Object> resultSp = SP_ACCNT_AFB700UKR.USP_ACCNT_AFB700UKR(spParam);

//        payDraftNo = (String) resultSp.get("RTN_PAY_DRAFT_NO");
//        errorDesc = (String) resultSp.get("ERROR_DESC");
        
        
        String resultSp = (String) super.commonDao.select("s_afb700ukrkocisServiceImpl.spAfb700ukr", spParam);
        
        int idx = resultSp.indexOf("|"); 
        
        payDraftNo = resultSp.substring(0, idx);
        
        errorDesc = resultSp.substring(idx+1);
        
        if(!ObjUtils.isEmpty(errorDesc)){
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
        }
        
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

		return extResult;
	}
	
	/**
	 * 지출결의등록(SP)-> 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_kocis")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//logger.debug("[saveAll] paramMaster:" + paramMaster);
		//logger.debug("[saveAll] paramDetail:" + paramList);


		//1.로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			
		//2.지출결의등록마스터 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		dataMaster.put("KEY_VALUE", keyValue);
		dataMaster.put("COMP_CODE", user.getCompCode());
 
		if (ObjUtils.isEmpty(dataMaster.get("PAY_DRAFT_NO") )) {
			dataMaster.put("OPR_FLAG", "N");
		} else {
			dataMaster.put("OPR_FLAG", "U");
		}

		if(dataMaster.get("NEXT_GUBUN") == "true"){
		    dataMaster.put("NEXT_GUBUN", "Y");
		}else{
		    dataMaster.put("NEXT_GUBUN", "N");
		}
		    
		
		super.commonDao.insert("s_afb700ukrkocisServiceImpl.insertLogMaster", dataMaster);
		
		//3.지출결의등록디테일 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
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
        
        String payDraftNo = "";
        String errorDesc = "";
        
        String resultSp = (String) super.commonDao.select("s_afb700ukrkocisServiceImpl.spAfb700ukr", spParam);
        System.out.println("리턴 : " + resultSp ); 
        int idx = resultSp.indexOf("|"); 
        
        payDraftNo = resultSp.substring(0, idx);
        errorDesc = resultSp.substring(idx+1);
      

        if(!ObjUtils.isEmpty(errorDesc)){
            dataMaster.put("PAY_DRAFT_NO", "");
//          String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
        } else {
            //마스터에 SET
            dataMaster.put("PAY_DRAFT_NO", payDraftNo);
            //그리드에 SET
            for(Map param: paramList) {
                dataList = (List<Map>)param.get("data");    
                if(param.get("method").equals("insertDetail")) {
                    List<Map> datas = (List<Map>)param.get("data");
                    for(Map data: datas){
                        data.put("PAY_DRAFT_NO", payDraftNo);
                    }
                }
            }   
        }
        
//  }catch(Exception e){   
//      throw new  UniDirectValidateException("SQL 에러");
//      
//  }
        
        
		
/*		//4.지출결의등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		spParam.put("UserId", user.getUserID());
		
		super.commonDao.queryForObject("spUspAccntAfb700ukr", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		String payDraftNo = ObjUtils.getSafeString(spParam.get("PayDraftNo"));

		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("PAY_DRAFT_NO", "");
//			String[] messsage = errorDesc.split(";");
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			//마스터에 SET
			dataMaster.put("PAY_DRAFT_NO", payDraftNo);
			//그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");	
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("PAY_DRAFT_NO", payDraftNo);
					}
				}
			}	
		}*/
		
		//5.지출결의마스터 정보 + 지출결의디테일 정보 결과셋 리턴
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	/**
	 * 지출결의등록 로그정보 저장
	 */
	public List<Map> insertLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
		for(Map param: params)		{
			param.put("KEY_VALUE", keyValue);
			param.put("OPR_FLAG", oprFlag);
			
			if(param.get("PAY_DIVI").equals("C0010")){
			    if(ObjUtils.isEmpty(param.get("CHECK_NO"))){
			        throw new  UniDirectValidateException("지급방법이 수표이면 수표번호를 입력해 주십시오.");
			    }
			}
			super.commonDao.insert("s_afb700ukrkocisServiceImpl.insertLogDetail", param);
		}		

		return params;
	}
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{
				super.commonDao.update("s_afb700ukrkocisServiceImpl.insertDetail", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			super.commonDao.insert("s_afb700ukrkocisServiceImpl.updateDetail", param);
		}
		 return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 try {
				 super.commonDao.delete("s_afb700ukrkocisServiceImpl.deleteDetail", param);
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
	    	}	
		 }
		 return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kocis")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public Object afb700ukrDelA (Map spParam, LoginVO user) throws Exception {
		
//		spParam.put("CompCode", user.getCompCode());  
//		spParam.put("LangCode", user.getLanguage());
		
		
		String encryptPass = "";
		String decryptPass = "";
		List temp1 = new ArrayList();
		List temp2 = new ArrayList();
		
		encryptPass = (String) spParam.get("PASSWORD");	// 암호화된 패스워드
		
		int textSize = encryptPass.length();
		
		for (int i = 0; i < textSize; i++){
			
			int encryptInt1 = 0;
			int encryptInt2 = 0;
			String encryptStr = encryptPass;
			encryptInt1 = encryptStr.charAt(i);
			temp1.add(i, Integer.toString(encryptInt1));
			
			if((i + 1) < textSize){
				encryptInt2 = encryptStr.charAt(i + 1);
				temp2.add(i, Integer.toString(encryptInt2));
			}
		}
		for (int i = 0; i < textSize; i = i+2) {
			int t1 = 0;
			int t2 = 0;
			int sumt3 = 0;
			t1 = Integer.parseInt((String) temp1.get(i));
			t2 = Integer.parseInt((String) temp2.get(i));
			
			sumt3 = t1 - t2;
			char tempC = (char) sumt3;
			decryptPass += tempC;

		}
		spParam.put("PASSWORD", decryptPass);	//복호화된 패스워드
		
		super.commonDao.queryForObject("spUspAccntAfb700ukrDelA", spParam);
//		super.commonDao.update("spUspAccntAfb700ukrDelA", spParam);		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));				
		if(!ObjUtils.isEmpty(errorDesc)){
//			String[] messsage = errorDesc.split(";");
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}else{
			return true;
		}
	}
	
}