package foren.unilite.modules.human.hbs;

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

@Service("hbs211ukrService")
public class Hbs211ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "employeePhoto";
	
	/**
	 * 담당업무별수당
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("hbs211ukrServiceImpl.selectList", param);
    }
	


	/**저장**/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hbs")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        
        if(paramList != null)   {
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
                
        return  paramList;
    }
    
    
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")
    public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {       	
    	
        for(Map param : paramList ) {
        	
        	int chk = 0 ;
        	
        	chk = (int) super.commonDao.select("hbs211ukrServiceImpl.selectHbs211PkChk", param);	//insert전 pk로 데이터 존재 여부 체크
        	
           	if( chk >= 1 ){
            	
	    		String sCompCode 	= (String) param.get("S_COMP_CODE");
	    		String payGradeYyyy = (String) param.get("PAY_GRADE_YYYY");
	    		String jobCode 		= (String) param.get("JOB_CODE");
	    		String wagesCode 	= (String) param.get("WAGES_CODE");
	    		String jobNm 			= (String) super.commonDao.select("hbs211ukrServiceImpl.selectJobCodeNm", jobCode);
	        	
	    		throw new  UniDirectValidateException(payGradeYyyy + "년도 [[" + jobNm +"]]의 수당이 이미 등록돼있습니다.");//데이터 존재 하면 저장 취소
    		
    	    }
           	
            super.commonDao.insert("hbs211ukrServiceImpl.insertDetail", param);
        }   
        return;
    }   
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")
    public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        for(Map param :paramList )  {
            
            super.commonDao.update("hbs211ukrServiceImpl.updateDetail", param);
        }
         return;
    } 
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbs")
    public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
         for(Map param :paramList ) {

             super.commonDao.delete("hbs211ukrServiceImpl.deleteDetail", param);
         }
         return;
    }
    
}
