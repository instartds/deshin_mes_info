package foren.unilite.modules.human.hpa;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("hpa620ukrService")
public class Hpa620ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 연간입퇴사자 목록 조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("hpa350ukrServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public String selectcaltype(Map param) throws Exception {
		return (String) super.commonDao.select("hpa620ukrServiceImpl.selectcaltype", param);
	}
	
	/**
	 * 컬럼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectColumns(LoginVO loginVO) throws Exception {
		return (List)super.commonDao.list("hpa350ukrServiceImpl.selectColumns" ,loginVO);
	}
	
	
/*	public List<Map> updateHpa350t(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{
			if (param.get("FLAG").toString().equals("U")) {
				super.commonDao.update("hpa350ukrServiceImpl.update", param);
				param.put("FLAG", "U");
			} */
		/*	else {
				super.commonDao.update("hpa350ukrServiceImpl.update", param);
				param.put("FLAG", "D");
			}*/
			
/*
	   @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")	
		public List<Map> updateHpa350t(List<Map> paramList) throws Exception {
			for(Map param :paramList )	{
				String WAGERS_DATA = "";
				Iterator<String> keys = param.keySet().iterator();
		        while( keys.hasNext() ){
		            String key = keys.next();
		            String value = param.get(key).toString();
		            if (key.indexOf("WAGES_") != -1) {
		            	WAGERS_DATA = WAGERS_DATA + key + ":" + value + "|";
		            }
		        }
		        if (WAGERS_DATA.length() == WAGERS_DATA.lastIndexOf("|") + 1) {
		        	WAGERS_DATA = WAGERS_DATA.substring(0, (WAGERS_DATA.length() - 1));
		        }
		        param.put("WAGERS_DATA", WAGERS_DATA);
				super.commonDao.update("hpa350ukrServiceImpl.update", param);
			}
			return paramList;
	}
	*/   
/*		public List<Map> deleteHpa350t(List<Map> paramList) throws Exception {
			for(Map param :paramList )	{
				super.commonDao.update("hpa350ukrServiceImpl.update", param);
			}
			return paramList;
		
}*/
	   /**
	    * 년차 생성 존재 여부 체크
	    */
	   @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
		public Integer  yearCheck(Map param) throws Exception {		
		   Integer cnt = (Integer) super.commonDao.select("hpa620ukrServiceImpl.yearCheck", param);		//수불내역 있는지 확인 있으면 삭제 불가..
		   return cnt; 
		}
	   

	   /**
	    * 년차 기준
	    */	  
		public Map loadStdYyyy(LoginVO loginVO) throws Exception {
		   Map<String, String> param = new HashMap();
		   param.put("S_COMP_CODE", loginVO.getCompCode());
		   return (Map) super.commonDao.queryForObject("hpa620ukrServiceImpl.selectList", param);
		}
	   
	   
	   /**
		 * 년차생성 프로시져 실행 
		 */
//		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
//		public Map procHpa620(Map param, LoginVO loginVO) throws Exception {
//			if(param.get("DIV_CODE").equals("")){			
//				param.put("DIV_CODE", "'%'");
//			}
//			
//			String date1 = (String) param.get("YEAR_DT_FR");
//			String date2 = (String) param.get("YEAR_DT_TO");
//			String date3 = (String) param.get("YEAR_USE_DT_FR");
//			String date4 = (String) param.get("YEAR_USE_DT_TO");
//		
//			param.put("YEAR_DT_FR", date1.replace(".", ""));
//			param.put("YEAR_DT_TO", date2.replace(".", ""));
//			param.put("YEAR_USE_DT_FR", date3.replace(".", ""));
//			param.put("YEAR_USE_DT_TO", date4.replace(".", ""));
//			
//			param.put("S_COMP_CODE", loginVO.getCompCode());
//			param.put("USER_ID", loginVO.getUserID());
//			
////			String arr[] = param.toString().split(",");		
////			for(int i=0;i<arr.length;i++){
////				System.out.println(arr[i]);
////			}
//
//			Map result = (Map)super.commonDao.queryForObject("hpa620ukrServiceImpl.proc", param);
//			System.out.println("==========================result==========================");
//			System.out.println(result.toString());
//			
//			return result;
//		}
		
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
		public Object  spStart(Map spParam, LoginVO user) throws Exception {
//			String deptCd = (String) spParam.get("DEPTS").toString().replace("[", "");
//			String depts = deptCd.replace("]", "");
//			String arryDeptCd[] = depts.split(", ");
//			String stDeptCd = arryDeptCd[0];
//			String edDeptCd = arryDeptCd[arryDeptCd.length -1];
//			
//			spParam.put("DEPT_CODE_FR", stDeptCd);
//			spParam.put("DEPT_CODE_TO", edDeptCd);.
			if(spParam.get("YEAR_TYPE").equals("1")){
				spParam.put("DUTY_YYYY", spParam.get("YYYY"));		//회기말기준일시 년차년월로 넘어감
				spParam.put("YEAR_DATE_FR", spParam.get("YEAR_DT_FR"));		
				spParam.put("YEAR_DATE_TO", spParam.get("YEAR_DT_TO"));
				
			}else if(spParam.get("YEAR_TYPE").equals("2")){
				spParam.put("DUTY_YYYY", spParam.get("BASE_YYYY_MM"));//입사월기준일시 기준년월로 넘어감
				spParam.put("YEAR_DATE_FR", spParam.get("BASE_DATE_FR"));		
				spParam.put("YEAR_DATE_TO", spParam.get("BASE_DATE_TO"));	
				
			}else if(spParam.get("YEAR_TYPE").equals("3")){		//상하반기 구분일시
//				if(spParam.get("YEAR_HALF").equals("1")){	//상반기일시 상반기 날짜 SET
//					spParam.put("YEAR_DATE_FR", spParam.get("YEAR_STD_FR_MM"));		
//					spParam.put("YEAR_DATE_TO", spParam.get("YEAR_STD_TO_MM"));		
//				}else{										//하반기일시 하반기 날짜 SET
//					spParam.put("YEAR_DATE_FR", spParam.get("YEAR_STD_FR_MM_2"));		
//					spParam.put("YEAR_DATE_TO", spParam.get("YEAR_STD_TO_MM_2"));		
//				}				
			}
			Map errorMap = (Map) super.commonDao.select("hpa620ukrServiceImpl.USP_HUMAN_HAT620UKR", spParam);
			if(!ObjUtils.isEmpty(errorMap.get("errorDesc"))){
				String errorDesc = (String) errorMap.get("errorDesc");
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			}else{
				return true;
			}	
		}
}
	
