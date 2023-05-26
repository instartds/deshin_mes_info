package foren.unilite.modules.accnt.atx;

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



@Service("atx100ukrService")
public class Atx100ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	/**
	 * 
	 * 입렵경로에 따라 생성경로 변경 관련 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public Object  getPubPath(Map param) throws Exception {	
		return  super.commonDao.select("atx100ukrServiceImpl.getPubPath", param);
	}
	/**
	 * 링크 이동프로그램ID관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>>  getLinkID(Map param) throws Exception {
		return  super.commonDao.list("atx100ukrServiceImpl.getLinkID", param);
	}
	
	/**
	 * 증빙유형 콤보 관련
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getProofKind(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("atx100ukrServiceImpl.getProofKind", param);
		
	}
	/**
	 * 부가세조정 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("atx100ukrServiceImpl.selectList", param);
	}
	
	/**
     * 부가세CHECK btn
     * @param spParam
     * @param user
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unchecked", "rawtypes" } )
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public Object fnChkAmt (Map spParam, LoginVO user) throws Exception {
        //AES256DecryptoUtils  decrypto = new AES256DecryptoUtils();
        
        spParam.put("S_COMP_CODE", user.getCompCode()); 
        spParam.put("S_LANG_CODE", user.getLanguage());
        spParam.put("S_LOGIN_ID", user.getUserID());
        
        super.commonDao.queryForObject("spUspAccntAtx100tukrFnChkAmt", spParam);
        
        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));                
        if(!ObjUtils.isEmpty(errorDesc)){
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
        }else{
            /*
            
            //job_yn = 'n' 검색 후 복호화 (바디)
            List<Map<String, Object>> bodyList = null;
            Map prm = null;
            
            bodyList = super.commonDao.list("abh200ukrServiceImpl.selectBodyList", prm);
            
            if (bodyList.size() > 0) {
                try {
                    
                    //Body
                    for(Map map2 : bodyList) {
                        map2.put("FIELD_002", seed.decryto((String)map2.get("FIELD_002")));
                        map2.put("JOB_YN", "Y");
                        super.commonDao.update("abh200ukrServiceImpl.updateBody", map2); 
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new Exception(e.getMessage());
                }
            }
            return true;
        */}
        return spParam;
    }
	

	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
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
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{
				
				//부가세마감여부 체크로직 추가 
				Map<String, Object> fnCheckCloseDate = (Map<String, Object>)super.commonDao.select("atx100ukrServiceImpl.fnCheckCloseDate", param);
				if(fnCheckCloseDate.get("TAX_CLOSE_FG").equals("Y")){
					throw new  UniDirectValidateException(this.getMessage("55536", user));
				}else{
	//				super.commonDao.select("atx100ukrServiceImpl.selectGetTxNum", param);
					Map<String, Object> getTxNum = (Map<String, Object>)super.commonDao.select("atx100ukrServiceImpl.selectGetTxNum", param);
					if(ObjUtils.parseInt(getTxNum.get("TX_NUM")) == 0){
						param.put("TX_NUM", 1);
					}else{
						param.put("TX_NUM", getTxNum.get("TX_NUM"));
					}
					super.commonDao.update("atx100ukrServiceImpl.insertDetail", param);
				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			//부가세마감여부 체크로직 추가 
			Map<String, Object> fnCheckCloseDate = (Map<String, Object>)super.commonDao.select("atx100ukrServiceImpl.fnCheckCloseDate", param);
			if(fnCheckCloseDate.get("TAX_CLOSE_FG").equals("Y")){
				throw new  UniDirectValidateException(this.getMessage("55536", user));
			}else{
				if(param.get("NEW_PUB_DATE").equals("Y")){
					Map<String, Object> getTxNum = (Map<String, Object>)super.commonDao.select("atx100ukrServiceImpl.selectGetTxNum", param);
					if(ObjUtils.parseInt(getTxNum.get("TX_NUM")) == 0){
						param.put("TX_NUM", 1);
					}else{
						param.put("TX_NUM", getTxNum.get("TX_NUM"));
					}
					if(param.get("sReflectinSlipAlert").equals("Y")){
						super.commonDao.insert("atx100ukrServiceImpl.ReflectinSlip", param);
					}				
					super.commonDao.insert("atx100ukrServiceImpl.updateDetail", param);
				}else{
					if(param.get("sReflectinSlipAlert").equals("Y")){
						super.commonDao.insert("atx100ukrServiceImpl.ReflectinSlip", param);
					}
					super.commonDao.insert("atx100ukrServiceImpl.updateDetail", param);
				}
			}
		}
		 return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			//부가세마감여부 체크로직 추가 
			Map<String, Object> fnCheckCloseDate = (Map<String, Object>)super.commonDao.select("atx100ukrServiceImpl.fnCheckCloseDate", param);
			if(fnCheckCloseDate.get("TAX_CLOSE_FG").equals("Y")){
				throw new  UniDirectValidateException(this.getMessage("55536", user));
			}else{
				try {
					super.commonDao.delete("atx100ukrServiceImpl.deleteDetail", param);
				}catch(Exception e)	{
					throw new  UniDirectValidateException(this.getMessage("547",user));
				}
			}
		 }
		 return 0;
	}
	
	
	
}
