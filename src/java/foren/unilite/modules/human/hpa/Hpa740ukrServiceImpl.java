package foren.unilite.modules.human.hpa;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.google.gson.Gson;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hpa740ukrService")
public class Hpa740ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 * 서비스 연결
	 */
	@Resource(name="hpa740ukrService")
	private Hpa740ukrServiceImpl hpa740ukrService;
	
	/**
	 * 근무조현황 목록 조회
	 * 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {
		List dutyCode = (List)super.commonDao.list("hpa740ukrServiceImpl.selectWagescode" ,loginVO.getCompCode());
		param.put("WAGES_CODE", dutyCode);
		
		String arr[] = param.toString().split(",");		
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
						
		return (List) super.commonDao.list("hpa740ukrServiceImpl.selectList", param);
	}
	
	/**
	 * 근태코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectWagescode(String comp_code) throws Exception {
		return (List)super.commonDao.list("hpa740ukrServiceImpl.selectWagescode" ,comp_code);
	}
	
	
	//Insert
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> insertList(List<Map> paramList,  LoginVO user) throws Exception {
		
		for(Map param :paramList )	{
			

			List<Map> dutyCode = (List<Map>)super.commonDao.list("hpa740ukrServiceImpl.selectWagescode" ,user.getCompCode());
			
			param.put("PAY_YYYYMM", ((String) param.get("PAY_YYYYMM")).replace(".", ""));

			for(Map subParam :dutyCode )	{
				
				param.put("WAGES_CODE", param.get("CODE_"+ ObjUtils.getSafeString(subParam.get("WAGES_CODE"))));
				param.put("AMOUNT_I", param.get("WAGES_"+ ObjUtils.getSafeString(subParam.get("WAGES_CODE"))));
			
			super.commonDao.update("hpa740ukrServiceImpl.insertList", param);
			
			}
			
		}
		return paramList;
	}
	
	//Update
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> updateList(List<Map> paramList,  LoginVO user) throws Exception {
		
							
		for(Map param :paramList )	{	
					
			
			List<Map> dutyCode = (List<Map>)super.commonDao.list("hpa740ukrServiceImpl.selectWagescode" ,user.getCompCode());
			
			param.put("PAY_YYYYMM", ((String) param.get("PAY_YYYYMM")).replace(".", ""));

			for(Map subParam :dutyCode )	{
				
				param.put("WAGES_CODE", param.get("CODE_"+ ObjUtils.getSafeString(subParam.get("WAGES_CODE"))));
				param.put("AMOUNT_I", param.get("WAGES_"+ ObjUtils.getSafeString(subParam.get("WAGES_CODE"))));
			
			super.commonDao.update("hpa740ukrServiceImpl.updateList", param);
			
			}
			
			//super.commonDao.update("hpa740ukrServiceImpl.updateList", param);
		}
		return paramList;
	}
	
	//Delete
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> deleteList(List<Map> paramList,  LoginVO user) throws Exception {
		
		for(Map param :paramList )	{		
			
			List<Map> dutyCode = (List<Map>)super.commonDao.list("hpa740ukrServiceImpl.selectWagescode" ,user.getCompCode());
			
			
			param.put("PAY_YYYYMM", ((String) param.get("PAY_YYYYMM")).replace(".", ""));
			
			for(Map subParam :dutyCode )	{
				
				param.put("WAGES_CODE", param.get("CODE_"+ ObjUtils.getSafeString(subParam.get("WAGES_CODE"))));
				param.put("AMOUNT_I", param.get("WAGES_"+ ObjUtils.getSafeString(subParam.get("WAGES_CODE"))));
				
				//param.put("PAY_YYYYMM", param.get("PAY_YYYYMM"));
				
				
				
			
			super.commonDao.update("hpa740ukrServiceImpl.deleteList", param);
			
			}
			
			/*String arr[] = param.toString().split(",");
			for(int i=0;i<arr.length;i++){
				System.out.println(arr[i]);
			}*/			
			
			//super.commonDao.update("hpa740ukrServiceImpl.deleteList", param);							
		}
		
		return paramList;
	}
	
	// sync All
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpa")
	 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	 public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		 
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
				if(insertList != null) this.insertList(insertList, user);
				if(updateList != null) this.updateList(updateList, user);				
				if(deleteList != null) this.deleteList(deleteList, user);
			}
		 	paramList.add(0, paramMaster);
			
		 	return  paramList;
	}
	
	/**
	 * 전월데이터 생성
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
   	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
       
   	public Map<String, Object> procSP( Map param, LoginVO user ) throws Exception {
   			
		Map<String, Object> spParam = new HashMap<String, Object>();
		
		spParam.put("COMP_CODE",  user.getCompCode());
		spParam.put("PAY_YYYYMM", param.get("PAY_YYYYMM"));
		spParam.put("LOGIN_ID",   user.getUserID());
		spParam.put("RE_TRY",     param.get("RE_TRY"));

		super.commonDao.queryForObject("hpa740ukrServiceImpl.procSP", spParam);
		//super.commonDao.update("hpa740ukrServiceImpl.procSP", spParam);

		return spParam;
	}
}
