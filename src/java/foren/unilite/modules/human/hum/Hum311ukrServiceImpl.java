package foren.unilite.modules.human.hum;

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

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.sec.license.LicenseManager;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("hum311ukrService")
public class Hum311ukrServiceImpl extends TlabAbstractServiceImpl  {
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
		return  super.commonDao.list("hum311ukrService.select", param);
	}
	
/*	*//**
	 * 보증인1 주민번호 중복조회
	 * @param param
	 * @return
	 * @throws Exception
	 *//*
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hum")
	public Object  chkFamilyRepreNum(Map param) throws Exception {		
		return  super.commonDao.select("hum311ukrService.chkFamilyRepreNum", param);
	}
	
	*//**
	 * 보증인2 주민번호 중복조회
	 * @param param
	 * @return
	 * @throws Exception
	 *//*
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "hum")
	public Object  chkFamilyRepreNum2(Map param) throws Exception {		
		return  super.commonDao.select("hum311ukrService.chkFamilyRepreNum2", param);
	}*/
	
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
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")		// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("hum311ukrService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				for(Map checkCompCode : chkList) {
					 if(param.get("GUARANTOR1_ZIP_CODE") != null)	{
			    		param.put("GUARANTOR1_ZIP_CODE", param.get("GUARANTOR1_ZIP_CODE").toString().replace("-",""));	// 보증인1 우편번호
			    	 }
					 if(param.get("GUARANTOR2_ZIP_CODE") != null)	{
			    		param.put("GUARANTOR2_ZIP_CODE", param.get("GUARANTOR2_ZIP_CODE").toString().replace("-",""));	// 보증인2 우편번호
			    	 }
					 if(param.get("GUARANTOR1_RES_NO") != null)	{
			    		param.put("GUARANTOR1_RES_NO", param.get("GUARANTOR1_RES_NO").toString().replace("-",""));		// 보증인1 주민번호
			    	 }
					 if(param.get("GUARANTOR2_RES_NO") != null)	{
			    		param.put("GUARANTOR2_RES_NO", param.get("GUARANTOR2_RES_NO").toString().replace("-",""));		// 보증인2 주민번호
			    	 }
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("hum311ukrService.insertDetail", param);
				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("hum311ukrService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 if(param.get("GUARANTOR1_ZIP_CODE") != null)	{
			    		param.put("GUARANTOR1_ZIP_CODE", param.get("GUARANTOR1_ZIP_CODE").toString().replace("-",""));	// 보증인 1우편번호
		    	 }
				 if(param.get("GUARANTOR2_ZIP_CODE") != null)	{
		    		param.put("GUARANTOR2_ZIP_CODE", param.get("GUARANTOR2_ZIP_CODE").toString().replace("-",""));		// 보증인 2 우편번호
		    	 }
				 if(param.get("GUARANTOR1_RES_NO") != null)	{
		    		param.put("GUARANTOR1_RES_NO", param.get("GUARANTOR1_RES_NO").toString().replace("-",""));		// 보증인1 주민번호
		    	 }
				 if(param.get("GUARANTOR2_RES_NO") != null)	{
		    		param.put("GUARANTOR2_RES_NO", param.get("GUARANTOR2_RES_NO").toString().replace("-",""));		// 보증인2 주민번호
		    	 }
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hum311ukrService.updateDetail", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "hum", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("hum311ukrService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hum311ukrService.deleteDetail", param);
			 }
		 }
		 return 0;
	}
}
