package foren.unilite.modules.accnt.atx;

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
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("atx410ukrService")
public class Atx410ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)	/* 조회 */
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("atx410ukrServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)	/* SEQ조회 */
	public List<Map<String, Object>> selectSeq(Map param) throws Exception {
		return super.commonDao.list("atx410ukrServiceImpl.selectMaxSeq", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail")) {
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
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("atx410ukrServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList )	{
//				for(Map checkCompCode : chkList) {
//					param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					super.commonDao.update("atx410ukrServiceImpl.insertDetail", param);
//				}
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("atx410ukrServiceImpl.checkCompCode", compCodeMap);
		for(Map param :paramList )	{
//			for(Map checkCompCode : chkList) {
//				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("atx410ukrServiceImpl.updateDetail", param);
//			}
		}
		return 0;
	}
	
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("atx410ukrServiceImpl.checkCompCode", compCodeMap);
		for(Map param :paramList )	{
//			for(Map checkCompCode : chkList) {
//				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("atx410ukrServiceImpl.deleteDetail", param);
//			}
		}
		return 0;
	}
}
