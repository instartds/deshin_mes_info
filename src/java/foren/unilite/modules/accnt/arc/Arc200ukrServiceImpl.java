package foren.unilite.modules.accnt.arc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;



@Service("arc200ukrService")
public class Arc200ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	@Resource(name = "bdc100ukrvService")
    private Bdc100ukrvService bdc100ukrvService;
	/**
	 * 법무채권등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object selectForm(Map param) throws Exception {
		
		return super.commonDao.select("arc200ukrServiceImpl.selectForm", param);
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
	 * 관리일지
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("arc200ukrServiceImpl.selectList", param);
	}

	
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncMaster(Arc200ukrModel param, LoginVO user,  BindingResult result) throws Exception {

		param.setS_USER_ID(user.getUserID());
		param.setS_COMP_CODE(user.getCompCode());
		
	    List<Map> saveCheck = (List<Map>) super.commonDao.list("arc200ukrServiceImpl.beforeCheckSave", param);
	        
	    if(saveCheck != null && saveCheck.size() > 0){
            if(saveCheck.get(0).get("CLOSE_FG").equals("Y")){
                throw new  UniDirectValidateException(this.getMessage("54100", user));    //[54100] 이미 마감된 자료 입니다.
            }
        }
    		if(param.getSAVE_FLAG().equals("") || param.getSAVE_FLAG().equals("N")){
    			
    			Map<String, Object> spParam = new HashMap<String, Object>();
    			
    			spParam.put("COMP_CODE", user.getCompCode());
    			spParam.put("DIV_CODE", "");
    			spParam.put("TABLE_ID","ARC200T");
    			spParam.put("PREFIX", "A");
    			spParam.put("BASIS_DATE", param.getCONF_RECE_DATE());
    			spParam.put("AUTO_TYPE", "");
    
    			super.commonDao.queryForObject("arc200ukrServiceImpl.spAutoNum", spParam);
    			
    			param.setCONF_RECE_NO(ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
    			
    			super.commonDao.insert("arc200ukrServiceImpl.insertForm", param);
    			super.commonDao.insert("arc200ukrServiceImpl.insertDetail", param);
    			
    		}else if(param.getSAVE_FLAG().equals("U")){
    			super.commonDao.update("arc200ukrServiceImpl.updateForm", param);
    			super.commonDao.update("arc200ukrServiceImpl.updateDetail", param);
    			
    		}else if(param.getSAVE_FLAG().equals("D")){
    			super.commonDao.delete("arc200ukrServiceImpl.deleteForm", param);
    			super.commonDao.delete("arc200ukrServiceImpl.deleteDetail", param);
    			
    		}
        
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		
		extResult.addResultProperty("CONF_RECE_NO", ObjUtils.getSafeString(param.getCONF_RECE_NO()));
		return extResult;
	}
	
	
	
	/**
     * 파일업로드 조회
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    @ExtDirectMethod(group = "accnt")
    public List<Map<String, Object>> getFileList(Map param,  LoginVO login) throws Exception {
        param.put("S_COMP_CODE", login.getCompCode());
        return super.commonDao.list("arc200ukrServiceImpl.getFileList", param);
    }   
    /**
     * 파일업로드 저장
     * 
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.FORM_POST)
    public ExtDirectFormPostResult saveFile(Arc200ukrModel param, LoginVO login, BindingResult result) throws Exception {

        String docNo = param.getDOC_NO();
        param.setS_COMP_CODE(login.getCompCode());
        if (docNo != null && !"".equals(docNo)) {           
            // 첨부파일 입력/삭제
            Map rFileMap = this.syncFileList(param, login);
            if(!ObjUtils.isEmpty(rFileMap)) {
                
                param.setFILE_NO(ObjUtils.getSafeString( rFileMap.get("DOC_NO")));
            }
            
        }else {
            param.setDOC_NO(createDocNo(param, login));         
            // 첨부파일 등록          
            Map rFileMap = this.syncFileList(param, login);         
            if(!ObjUtils.isEmpty(rFileMap)) {
                param.setFILE_NO(ObjUtils.getSafeString( rFileMap.get("DOC_NO")));
            }           
        }
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
        extResult.addResultProperty("DOC_NO", param.getDOC_NO());
        return extResult;
    }
    private Map syncFileList(Arc200ukrModel param, LoginVO login) throws Exception {
        List<Map> rList = null;
        Map rtn = null;
        if(!ObjUtils.isEmpty(param.getADD_FID()) || !ObjUtils.isEmpty(param.getDEL_FID()))  {
            
            List<Map> paramList = new ArrayList<Map>();
            Map fParam = new HashMap();
            logger.debug("@@@@@@@@@@@@@@@@@@@@@"+param.getFILE_NO());
            fParam.put("DOC_NO", param.getFILE_NO());
            fParam.put("ADD_FIDS", param.getADD_FID());
            fParam.put("DEL_FIDS", param.getDEL_FID());
            fParam.put("S_COMP_CODE", login.getCompCode());
            fParam.put("S_USER_ID", login.getUserID());
            fParam.put("S_DEPT_CODE", login.getDeptCode());
            fParam.put("AUTH_LEVEL", login.getAuthorityLevel());
            paramList.add(fParam);
            if(ObjUtils.isEmpty(param.getFILE_NO()))    {
                rList = bdc100ukrvService.insertMulti(paramList, login);
            }else {
                rList = bdc100ukrvService.updateMulti(paramList, login);
            }
        }
        if (!ObjUtils.isEmpty(rList))   rtn = rList.get(0);
        return rtn;
    }
    
    
    private String createDocNo(Arc200ukrModel param, LoginVO login)    {       //파일번호 자동채번     
        return (String) super.commonDao.select("arc200ukrServiceImpl.getAutoNumComp", param);
    }
}
