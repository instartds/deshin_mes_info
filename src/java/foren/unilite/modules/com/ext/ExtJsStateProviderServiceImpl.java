package foren.unilite.modules.com.ext;

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
import foren.framework.model.LoginVO;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.menu.UniModuleModel;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.tags.ExtJsStateProviderService;

 
@Service("extJsStateProviderService")
public class ExtJsStateProviderServiceImpl  extends TlabAbstractServiceImpl implements ExtJsStateProviderService  
{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	//public final static String BEAN_ID = "extJsStateProviderService";
	@Resource(name="tlabMenuService")
	TlabMenuService menuService ;
	
	
	@Resource(name="tlabCodeService")
	TlabCodeService tlabCodeService ;
	
	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(group = "com")
	public Map updateState(Map param) throws Exception {
		String type = ObjUtils.getSafeString(param.get("type"));
		String pgmId = ObjUtils.getSafeString(param.get("PGM_ID"));
		if(!ObjUtils.isEmpty(pgmId)) {
			logger.debug("Param: {}", param);
			int cnt =(Integer) super.commonDao.select("extJsStateProviderServiceImpl.chkeckExists", param);
			if(cnt>0) {
				 super.commonDao.update("extJsStateProviderServiceImpl.updateOne", param);
				
			} else {
	
				 super.commonDao.insert("extJsStateProviderServiceImpl.insertOne", param);
			}
		}
		Map rv = new HashMap();
		rv.put("success", true);
		return rv;
		//return (List) super.commonDao.update("extJsStateProviderServiceImpl.update", param);
	}
	
	/**
	 * 그리드 설정정보 저장
	 * @param param
	 * @param login
	 * @param result
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "com")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public ExtDirectFormPostResult saveState(foren.unilite.com.tags.ExtJsStateProviderModel param1, LoginVO login,  BindingResult result) throws Exception {
		
		foren.unilite.modules.com.ext.ExtJsStateProviderModel param = new foren.unilite.modules.com.ext.ExtJsStateProviderModel();
		
		//framework jar 안의 ExtJsStateProviderModel을 myBatis에 퍼라미터로 넘기면 인식을 못함.
		//module 안의 ExtJsStateProviderModel 을 사용.
		param.setS_COMP_CODE(login.getCompCode());
		param.setS_USER_ID(login.getUserID());		
		
		param.setCOMP_CODE(param1.getCOMP_CODE());
		param.setDEFAULT_YN(param1.getDEFAULT_YN());
		param.setPGM_ID(param1.getPGM_ID());
		param.setQLIST_YN(param1.getQLIST_YN());
		param.setS_AUTHORITY_LEVEL(param1.getS_AUTHORITY_LEVEL());
		param.setSHT_DESC(param1.getSHT_DESC());
		param.setSHT_ID(param1.getSHT_ID());
		param.setSHT_INFO(param1.getSHT_INFO());
		param.setSHT_NAME(param1.getSHT_NAME());
		param.setSHT_SEQ(param1.getSHT_SEQ());
		param.setSHT_TYPE(param1.getSHT_TYPE());
		param.setCOLUMN_INFO(param1.getCOLUMN_INFO());
		param.setBASE_SHT_INFO(param1.getBASE_SHT_INFO());
		
		param.setTEMPC_01(param1.getTEMPC_01());
		param.setTEMPC_02(param1.getTEMPC_02());
		param.setTEMPC_03(param1.getTEMPC_03());
		param.setTEMPN_01(param1.getTEMPN_01());
		param.setTEMPN_02(param1.getTEMPN_02());
		param.setTEMPN_03(param1.getTEMPN_03());
		param.setUSER_ID(param1.getUSER_ID());
		
		int shtSeq = param.getSHT_SEQ();
		String defaultYN = param.getDEFAULT_YN();
		
		//int cnt =(Integer) super.commonDao.select("extJsStateProviderServiceImpl.chkeckExists", param);
		if(defaultYN.equals("Y")){	//현재 그리드의 기본설정 적용이면 우선 해당 그리드의 모든 설정에 대해 기본설정을 N 으로 
			super.commonDao.update("extJsStateProviderServiceImpl.updateDefaultN", param);
		}
		
		if(shtSeq > 0) {
			super.commonDao.update("extJsStateProviderServiceImpl.updateOne", param);
			
		} else {
			//param.setSHT_SEQ((Integer) super.commonDao.select("extJsStateProviderServiceImpl.autoShtSeq", param));
			super.commonDao.insert("extJsStateProviderServiceImpl.insertOne", param);
		}
		
		//super.commonDao.update("hum100ukrServiceImpl.saveHUM710", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("SHT_SEQ", param.getSHT_SEQ());
		
		return extResult;
	}
	/*
	public ExtDirectFormPostResult saveState(ExtJsStateProviderModel param, LoginVO login,  BindingResult result) throws Exception {
		param.setS_COMP_CODE(login.getCompCode());
		param.setS_USER_ID(login.getUserID());		
		
		int shtSeq = param.getSHT_SEQ();
		String defaultYN = param.getDEFAULT_YN();
		
		ObjUtils.getSafeString(spParam.get("ErrorDesc"))
		//int cnt =(Integer) super.commonDao.select("extJsStateProviderServiceImpl.chkeckExists", param);
		if(defaultYN.equals("Y")){	//현재 그리드의 기본설정 적용이면 우선 해당 그리드의 모든 설정에 대해 기본설정을 N 으로 
			super.commonDao.update("extJsStateProviderServiceImpl.updateDefaultN", param);
		}
		
		if(shtSeq > 0) {
			super.commonDao.update("extJsStateProviderServiceImpl.updateOne", param);
			
		} else {
			//param.setSHT_SEQ((Integer) super.commonDao.select("extJsStateProviderServiceImpl.autoShtSeq", param));
			super.commonDao.insert("extJsStateProviderServiceImpl.insertOne", param);
		}
		
		//super.commonDao.update("hum100ukrServiceImpl.saveHUM710", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		extResult.addResultProperty("SHT_SEQ", param.getSHT_SEQ());
		
		return extResult;
	}*/
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "com")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
        
        List<Map> updateList = new ArrayList<Map>();
        List<Map> deleteList = new ArrayList<Map>();
        
        if (paramList != null) {
            for (Map param : paramList) {
                dataList = (List<Map>)param.get("data");
                
                if (param.get("method").equals("updateOne")) {
                    updateList.addAll((List<Map>)param.get("data"));
                } else if (param.get("method").equals("deleteOne")) {
                    deleteList.addAll((List<Map>)param.get("data"));
                }
            }
            
            deleteOne(deleteList, user);
            updateOne(updateList, user);
        }
        
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "com")
	public void updateOne(List<Map> paramList,  LoginVO login) throws Exception {
		for(Map param : paramList){
			super.commonDao.update("extJsStateProviderServiceImpl.updateOne", param);
		}
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "com")
	public void deleteOne(List<Map> paramList,  LoginVO login) throws Exception {
		for(Map param : paramList){
			super.commonDao.delete("extJsStateProviderServiceImpl.deleteOne", param);
		}
	}
	
	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(group = "com")
	public List<Map<String, Object>> selectStateList(Map param) throws Exception {
		CodeInfo codeInfo = tlabCodeService.getCodeInfo(ObjUtils.getSafeString(param.get("S_COMP_CODE")));
		List<CodeDetailVO> cdo = codeInfo.getCodeList("B251");
		String userId = GStringUtils.toLowerCase(ObjUtils.getSafeString(param.get("S_USER_ID")));
		for(CodeDetailVO cdMap : cdo)	{
			if(userId.equals(GStringUtils.toLowerCase(cdMap.getRefCode1())))	{
				param.put("ADMIN", cdMap.getRefCode1());
			}
		}
		return super.commonDao.list("extJsStateProviderServiceImpl.selectStateList", param);
	}
	

	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(group = "com")
	public Object selectStateInfo(Map param) throws Exception {
		return super.commonDao.selectByPk("extJsStateProviderServiceImpl.selectOne", param);
	}
	
	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(group = "com")
	public Object selectStateCheck(Map param) throws Exception {
		return super.commonDao.select("extJsStateProviderServiceImpl.stateCheck", param);
	}
	
	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(group = "com")
	public Object resetState(Map param) throws Exception {
		param.put("SHT_INFO", "");
		return super.commonDao.update("extJsStateProviderServiceImpl.updateOne", param);
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "com")
	public void updateStateDefault(Map param,  LoginVO login) throws Exception {
		super.commonDao.update("extJsStateProviderServiceImpl.updateStateDefault", param);
	}
	
}
