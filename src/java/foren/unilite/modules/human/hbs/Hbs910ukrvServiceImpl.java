package foren.unilite.modules.human.hbs;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jfree.util.Log;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.utils.FileUtil;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("hbs910ukrvService")
public class Hbs910ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 인사자료목록조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hbs")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		logger.debug("Hpa910ukrvServiceImpl.selectList");
		return (List) super.commonDao.list("Hbs910ukrvServiceImpl.selectList", param);
	}

	@ExtDirectMethod(group = "hbs")
	public List selectColumns(LoginVO loginVO) throws Exception {
		return (List)super.commonDao.list("Hbs910ukrvServiceImpl.selectColumns" ,loginVO);
	}
	
	@ExtDirectMethod(group = "hbs")
	public Integer updateList(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("Hbs910ukrvServiceImpl.checkCompCode", compCodeMap);
		
		for(Map param :paramList )	{
			
				for(Map checkCompCode : chkList) {
					param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					super.commonDao.update("Hbs910ukrvServiceImpl.updateList", param);
				}
			
		}
		return 0;
	}

	/**
	 *추가
	 */
	 @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
		public Integer insertList(List<Map> paramList, LoginVO user) throws Exception {		
			try {
				Map compCodeMap = new HashMap();
				compCodeMap.put("S_COMP_CODE", user.getCompCode());
				List<Map> chkList = (List<Map>) super.commonDao.list("Hbs910ukrvServiceImpl.checkCompCode", compCodeMap);
				
				for(Map param : paramList )	{	
					String personnumb = (String) super.commonDao.select("Hbs910ukrvServiceImpl.checkPersonNumb", param);
					logger.debug("[[personnumb]]" + personnumb );
					logger.debug("[[personnumb]]" + param.get("PERSON_NUMB") );
					if(!param.get("PERSON_NUMB").equals(personnumb)){
						for(Map checkCompCode : chkList) {
							 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
							 super.commonDao.insert("Hbs910ukrvServiceImpl.insertList", param);
						}
					}
				}	
			} catch(Exception e){
				throw new  UniDirectValidateException(this.getMessage("2627", user));
			}
			return 0;
		}	
	 
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteList(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("Hbs910ukrvServiceImpl.checkCompCode", compCodeMap);
		for(Map param :paramList )	{	
			for(Map checkCompCode : chkList) {
				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.delete("Hbs910ukrvServiceImpl.deleteList", param);
			}
		}
		return 0;
	} 

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	public List<Map> syncAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		 
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList")) {		
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}	
			
			//저장하는 버튼에 따라 다른 로직 구현
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

			if(insertList != null) this.insertList(insertList, user);
			if(updateList != null){
				if (ObjUtils.parseInt(dataMaster.get("FLAG")) == 0) { 
					this.updateList(updateList, user);
				} else if (ObjUtils.parseInt(dataMaster.get("FLAG")) == 1){
					this.insertList(updateList, user);
				} else if (ObjUtils.parseInt(dataMaster.get("FLAG")) == 2){
					this.deleteList(updateList, user);
				} 
			}
			if(deleteList != null) this.deleteList(deleteList, user);
		}
			
	 	paramList.add(0, paramMaster);
				
	 	return  paramList;
	}
}
