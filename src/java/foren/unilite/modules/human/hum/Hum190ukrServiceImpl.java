package foren.unilite.modules.human.hum;

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

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.sec.license.LicenseManager;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("hum190ukrService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class Hum190ukrServiceImpl extends TlabAbstractServiceImpl	{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/**
	 * 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		List<Map> resultList = super.commonDao.list("hum190ukrService.select", param);
		
		for(Map oneList: resultList) {	 
			//만나이 계산을 위한 로직
			if(ObjUtils.isNotEmpty(oneList.get("BIRTH_DATE"))) {
				//생일을 년/월/일로 나눠 변수에 입력
				String birthDate= ObjUtils.getSafeString(oneList.get("BIRTH_DATE"));
				int birthYear	= ObjUtils.parseInt(birthDate.substring(0, 4));
				int birthMonth	= ObjUtils.parseInt(birthDate.substring(4, 6));
				int birthDay	= ObjUtils.parseInt(birthDate.substring(6, 8));
				
				//오늘 날짜를 년/월/일로 나눠 변수에 입력
		        Calendar current = Calendar.getInstance();
		        int currentYear  = current.get(Calendar.YEAR);
		        int currentMonth = current.get(Calendar.MONTH) + 1;
		        int currentDay   = current.get(Calendar.DAY_OF_MONTH);
		       
		        int age = currentYear - birthYear;
		        //생일 안 지난 경우 -1
		        if (birthMonth * 100 + birthDay > currentMonth * 100 + currentDay)  {
		            age--;
		        }
				oneList.put("PERSON_AGE", age);
				
			} else {
				oneList.put("PERSON_AGE", "");
			}
		}
		return resultList;
	}
	


	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hum")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);				
		}
		paramList.add(0, paramMaster);
		
		return	paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")		// INSERT
	public Integer	insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			for(Map param : paramList )	{			 
				 super.commonDao.update("hum190ukrService.insertDetail", param);
			}	
		}catch(Exception e){
			throw new	UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		 for(Map param :paramList )	{	
			 super.commonDao.update("hum190ukrService.updateDetail", param);
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "hum", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,	LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		 for(Map param :paramList )	{	
			 super.commonDao.update("hum190ukrService.deleteDetail", param);
		 }
		 return 0;
	}
	
	
	
	
	
	
    /**
     * SP호출을 위한 로그테이블 생성 / SP 호출 로직
     * 
     * @param paramList
     * @param paramMaster
     */
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "hum" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> callProcedure( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        if (paramList != null) {
            List<Map> insertList = null;
            
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("runProcedure")) {
                    insertList = (List<Map>)dataListMap.get("data");
                }
            }
            if (insertList != null) this.runProcedure(insertList, paramMaster, user);
        }
        
        paramList.add(0, paramMaster);
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "hum" )
    private void runProcedure( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        //1.로그테이블에서 사용할 Key 생성      
        String keyValue = getLogKey();
        
        //2.로그테이블에 KEY_VALUE 업데이트
        for (Map param : paramList) {
            param.put("KEY_VALUE", keyValue);
            super.commonDao.insert("hum190ukrService.insertLogTable", param);
        }
        
        //SP에서 작성한 변수에 맞추기
        //SP 호출시 넘길 MAP 정의
        Map<String, Object> spParam = new HashMap<String, Object>();
        //에러메세지 처리
        String errorDesc = "";
        
		spParam.put("KeyValue"		, keyValue);
		spParam.put("LangCode"		, user.getLanguage());
		spParam.put("S_COMP_CODE"	, user.getCompCode());
		spParam.put("S_USER_ID"		, user.getUserID());
        super.commonDao.queryForObject("hum190ukrService.runAutoSlip", spParam);
        
        errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        if (!ObjUtils.isEmpty(errorDesc)) {
            throw new UniDirectValidateException(this.getMessage(errorDesc, user));
        }
        
        return;
    }
}
