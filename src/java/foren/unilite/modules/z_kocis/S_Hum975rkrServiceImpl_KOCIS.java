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

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_hum975rkrService_KOCIS")
public class S_Hum975rkrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	

	/**
	 * 증명번호 마지막번호 참조
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public Map fnHum975ini(Map param) throws Exception {
		
		List<Map> qureyValue = (List<Map>) super.commonDao.list("s_hum975rkrServiceImpl_KOCIS.fnHum975ini", param);	 // 증명번호 check
		String certi ="0";
		if(qureyValue != null && qureyValue.size() > 0){
			certi = (String) qureyValue.get(0).get("CERTI_NUM");
		}
		List<Map>masterName  = (List<Map>) super.commonDao.list("s_hum975rkrServiceImpl_KOCIS.fnHum975ini1", param); // 대표자명 가져오기
//		String codeName = (String) masterName.get(0).get("CODE_NAME");
		
		List<Map>postName 	 = (List<Map>) super.commonDao.list("s_hum975rkrServiceImpl_KOCIS.fnHum975ini2", param); // 인사카드 / 증명서 등 직위 표시 방법
		
//		String refCode = (String) postName.get(0).get("REF_CODE2");
		
		List<Map>loginPerson = (List<Map>) super.commonDao.list("s_hum975rkrServiceImpl_KOCIS.fnHum975ini3", param); // (공공) 인사카드 / 증명서 로그인 사용자 사번
//		String personNumb = (String) loginPerson.get(0).get("PERSON_NUMB");
		
		
		
		java.util.Calendar cal = java.util.Calendar.getInstance();
		int year = cal.get (cal.YEAR);
		
		String rsNUM  = "";       // 증명번호
		String sDate = String.valueOf(year);
		
		String aRefConfig0 = "";  // 대표자명
		String aRefConfig1 = "";  // 직위 표시방법
		String aRefConfig2 = "";  // 사번
		
		/* 증명번호 로직 */
		if(!qureyValue.isEmpty()){
			int certi_num  = Integer.parseInt(certi);
			int certi_YYYY = 0;
			if(certi.length() >= 4){
				certi_YYYY = Integer.parseInt(certi.substring(0, 4));
			}else{
				certi_YYYY = Integer.parseInt(certi);
			}
			
			if(certi_num == 0 || certi_YYYY < year){
				rsNUM = sDate +  "001";
			}else{
				int cert_Plus = certi_num + 1;
				rsNUM = String.valueOf(cert_Plus);
			}	
		}else{
			rsNUM = sDate +  "001";
		}
		
		/* 대표자명 로직 */
		if(!masterName.isEmpty()){
			if(masterName.size() == 0){
				aRefConfig0 = "이사장";
			}else{
				if(masterName.get(0).get("CODE_NAME") != ""){
					aRefConfig0 = (String) masterName.get(0).get("CODE_NAME");
				}else{
					aRefConfig0 = "이사장";
				}
			}
		}
		
		/* 직위 표시 로직 */
		if(!postName.isEmpty()){
			if(postName.size() == 0){
				aRefConfig1 = "1";
			}else{
				aRefConfig1 = (String) postName.get(0).get("REF_CODE2");
			}
		}
		
		
		/* 로그인 사용자 로직 */
		if(!loginPerson.isEmpty()){
			if(loginPerson.size() == 0){
				aRefConfig2 = "*";
			}else{
				aRefConfig2 = (String) loginPerson.get(0).get("PERSON_NUMB");
			}
		}
		
		Map dataParam = new HashMap();
		
		dataParam.put("rsNUM", rsNUM);  			// 
		dataParam.put("aRefConfig0", aRefConfig0);  // 
		dataParam.put("aRefConfig1", aRefConfig1);  // 
		dataParam.put("aRefConfig2", aRefConfig2);  // 

		return dataParam;
	}
	
	

	/**
	 * 경력 Grid 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("s_hum975rkrServiceImpl_KOCIS.gridSelect", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			List<Map> profNumInsert = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} else if(dataListMap.get("method").equals("insertProfNum")) {
					profNumInsert = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);		
			if(profNumInsert != null) this.insertProfNum(profNumInsert, user);		
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")		// INSERT
	public void  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{			 
				 super.commonDao.update("s_hum975rkrServiceImpl_KOCIS.insertDetail", param);
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}

	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {

		 for(Map param :paramList )	{	
			 super.commonDao.update("s_hum975rkrServiceImpl_KOCIS.updateDetail", param);
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "hum", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {

		 for(Map param :paramList )	{	
			 super.commonDao.update("s_hum975rkrServiceImpl_KOCIS.deleteDetail", param);
		 }
		 return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")		// UPDATE 증명번호
	public Integer insertProfNum(List<Map> paramList, LoginVO user) throws Exception {

		 for(Map param :paramList )	{	
			 if(super.commonDao.select("s_hum975rkrServiceImpl_KOCIS.selectProfNum", param) == null){
				 super.commonDao.update("s_hum975rkrServiceImpl_KOCIS.insertProfNum", param);
			 }
		 }
		 return 0;
	} 

	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_READ)			// HUM975T 전체 삭제 로직
	public Object fnDeleteAllData(Map param) throws Exception {
		return super.commonDao.update("s_hum975rkrServiceImpl_KOCIS.fnDeleteAllData", param);
	}

}
