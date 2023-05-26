package foren.unilite.modules.z_kocis;

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
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;



@Service("s_afb980ukrkocisService")
public class S_Afb980ukrkocisServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="accntCommonService")
    private AccntCommonServiceImpl accntCommonService;
	
	
	/**
     * 이체결의 subGrid 관련
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectSubList1(Map param) throws Exception {
        return super.commonDao.list("s_afb980ukrkocisServiceImpl.selectSubList1", param);
    }
	
	/**
     * 마감관리 search
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("s_afb980ukrkocisServiceImpl.selectList", param);
    }
	
	
	
	/**
     * 결재요청전 결재상태 체크 관련
     * @param param 검색항목
     * @return
     * @throws Exception
     */ 
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> beforeCheckRequest(Map param) throws Exception {
        return super.commonDao.list("s_afb980ukrkocisServiceImpl.beforeCheckRequest", param);
    }
    
	
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public Object beforeUpdateRequest (Map param, LoginVO user) throws Exception {

        return super.commonDao.update("s_afb980ukrkocisServiceImpl.beforeUpdateRequest", param);
       
    }
    
    
	/**
	 * 채권등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object selectForm(Map param) throws Exception {
		
		return super.commonDao.select("s_afb980ukrkocisServiceImpl.selectForm", param);
		/*if(param.get("RE_REFERENCE").equals("Y")){
			return super.commonDao.select("atx300ukrServiceImpl.selectListSecond", param);
		}else{
			if( super.commonDao.select("atx300ukrServiceImpl.selectListFirst", param) == null){
				return super.commonDao.select("atx300ukrServiceImpl.selectListSecond", param);
			}else{
				return super.commonDao.select("atx300ukrServiceImpl.selectListFirst", param);
			}
		}*/
	}
	
	/**
	 * 이관 및 진행 정보
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object selectForm2(Map param) throws Exception {
		return super.commonDao.select("s_afb980ukrkocisServiceImpl.selectForm2", param);
	}
	


	
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncMaster(S_Afb980ukrkocisModel param, LoginVO user,  BindingResult result) throws Exception {

		param.setS_USER_ID(user.getUserID());
		param.setS_COMP_CODE(user.getCompCode());
		param.setS_DEPT_CODE(user.getDeptCode());
		
		/*List<Map> saveCheck = (List<Map>) super.commonDao.list("s_afb980ukrkocisServiceImpl.beforeCheckSave", param);
		
		if(saveCheck != null && saveCheck.size() > 0){
    		if(saveCheck.get(0).get("CLOSE_FG").equals("Y")){
    		    throw new  UniDirectValidateException(this.getMessage("54100", user));    //[54100] 이미 마감된 자료 입니다.
    		}
		}*/
		
	/*	
		if(param.getSAVE_FLAG().equals("") || param.getSAVE_FLAG().equals("N")){
 
		    
		    super.commonDao.insert("s_afb980ukrkocisServiceImpl.insertForm", param);
		
		}else if(param.getSAVE_FLAG().equals("U")){
		   
	        super.commonDao.update("s_afb980ukrkocisServiceImpl.updateForm", param);
			
		}else if(param.getSAVE_FLAG().equals("D")){
		    
		    super.commonDao.delete("s_afb980ukrkocisServiceImpl.deleteForm", param);
			
		}*/
		List<Map> saveCheck = (List<Map>) super.commonDao.list("s_afb980ukrkocisServiceImpl.checkAFB910T", param);
		if(ObjUtils.isNotEmpty(saveCheck)){
		    super.commonDao.update("s_afb980ukrkocisServiceImpl.updateForm", param);    
		}else{
		    super.commonDao.insert("s_afb980ukrkocisServiceImpl.insertForm", param);
		}
		
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		
		return extResult;
	}
	
	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public Object updateDC (Map param, LoginVO user) throws Exception {
        
        Object objRtn = "";
        
        Map beforeCheckUpdateDC = (Map) super.commonDao.select("s_afb980ukrkocisServiceImpl.beforeCheckUpdateDC", param);
        if(ObjUtils.isNotEmpty(beforeCheckUpdateDC)){
            if(beforeCheckUpdateDC.get("GW_STATUS").equals("1")){
                super.commonDao.update("s_afb980ukrkocisServiceImpl.updateDC", param);
            }else{
                String line = System.getProperty("line.separator");   //줄바꿈관련 각 운영체제에 맞추기 위해
                String errMessage = "기안중취소 처리할 수 없습니다.\n상태 : " + beforeCheckUpdateDC.get("CODE_NAME");
                errMessage = errMessage.replace("\n",line);
                objRtn = errMessage;
            }
        }
        
        return objRtn;
    }
	
	
}
