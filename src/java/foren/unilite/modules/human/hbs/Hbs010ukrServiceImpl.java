package foren.unilite.modules.human.hbs;

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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("hbs010ukrService")
public class Hbs010ukrServiceImpl extends TlabAbstractServiceImpl{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "tlabCodeService")
	 protected TlabCodeService tlabCodeService;
	
	/**
	 * 조회
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbs")
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {
		return (List) super.commonDao.list("hbs010ukrServiceImpl.selectList", param);
	}
	
	/**
	 * 입력
	 */
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer insertHbs010(List<Map> paramList,LoginVO loginVO) throws Exception {		
		try {
			for(Map param : paramList )	{			 
					 param.put("COMP_CODE", loginVO.getCompCode());
					 super.commonDao.update("hbs010ukrServiceImpl.insert", param);
				}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", loginVO));
		}
		return 0;
	}
		
	/**
	 * 수정
	 */
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer updateHbs010(List<Map> paramList, LoginVO loginVO) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", loginVO.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("hbs010ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hbs010ukrServiceImpl.update", param);
			 }
		 }
		 return 0;
	}
	
	/**
	 * 삭제
	 */
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer deleteHbs010(List<Map> paramList,  LoginVO loginVO) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", loginVO.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("hbs010ukrServiceImpl.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("hbs010ukrServiceImpl.delete", param);
			 }
		 }
		 return 0;
	}
	
	// sync All
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hbs")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> syncAll(List<Map> paramList, Map paramMaster, LoginVO loginVO) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteHbs010")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertHbs010")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateHbs010")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteHbs010(deleteList, loginVO);
			if(insertList != null) this.insertHbs010(insertList, loginVO);
			if(updateList != null) this.updateHbs010(updateList, loginVO);		
			
			tlabCodeService.reload(true);
            	
		}
		paramList.add(0, paramMaster);
		logger.debug("syncAll:" + paramList);
		return  paramList;
	}
	
}
