package foren.unilite.modules.base.bsa;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

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
import ch.ralscha.extdirectspring.util.ParametersResolver;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;


@Service("bsa600ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Bsa600ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("bsa600ukrvServiceImpl.selectList", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insert")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update")) {
					updateList = (List<Map>)dataListMap.get("data");
				} 
			}
			if(deleteList != null) this.delete(deleteList, user);
			if(insertList != null) this.insert(insertList, user);
			if(updateList != null) this.update(updateList, user);
		}
		paramList.add(0, paramMaster);

		return paramList;
	}
	
	@ExtDirectMethod(group = "base")
	public Integer  insert(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList) {
			//FILE_NO 생성
			if (ObjUtils.isEmpty(param.get("FILE_NO"))) {
				String fileNo = (String) super.commonDao.select("bsa600ukrvServiceImpl.getKey", param); 
				param.put("FILE_NO", fileNo);
			}
			super.commonDao.update("bsa600ukrvServiceImpl.insert", param);
			// 첨부파일 입력/삭제
			Map rFileMap = this.syncFileList(param, user);
		}
		return 0;
	}
	
	@ExtDirectMethod(group = "base")
	public Integer  update(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList) {
			//FILE_NO 생성
			if (ObjUtils.isEmpty(param.get("FILE_NO"))) {
				String fileNo = (String) super.commonDao.select("bsa600ukrvServiceImpl.getKey", param); 
				param.put("FILE_NO", fileNo);
			}
			super.commonDao.update("bsa600ukrvServiceImpl.update", param);
			// 첨부파일 입력/삭제
			this.syncFileList(param, user);
		}
		return 0;
	}
	
	@ExtDirectMethod(group = "base")
	public Integer  delete(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("bsa600ukrvServiceImpl.delete", param);
			// 첨부파일 입력/삭제
			this.syncFileList(param, user);
		}
		return 0;
	}

	private Map syncFileList(Map param, LoginVO user) throws Exception {
		Map rtn = null;
		if(!ObjUtils.isEmpty(param.get("ADD_FID")) || !ObjUtils.isEmpty(param.get("DEL_FID"))) {
			List<Map> paramList = new ArrayList<Map>();
			Map fParam = new HashMap();
			fParam.put("DOC_NO"		, param.get("FILE_NO"));
			fParam.put("FILE_NO"	, param.get("FILE_NO"));
			fParam.put("ADD_FIDS"	, param.get("ADD_FID"));
			fParam.put("DEL_FIDS"	, param.get("DEL_FID"));
			fParam.put("S_COMP_CODE", user.getCompCode());
			fParam.put("S_USER_ID"	, user.getUserID());
			fParam.put("S_DEPT_CODE", user.getDeptCode());
			fParam.put("AUTH_LEVEL"	, user.getAuthorityLevel());
			fParam.put("BULLETIN_ID", param.get("BULLETIN_ID"));
			paramList.add(fParam);
			
			if(!ObjUtils.isEmpty(param.get("ADD_FID"))) {
				String[] fids =  ObjUtils.getSafeString(param.get("ADD_FID")).split(",");
				 for(String fid : fids) {
					fParam.put("FID", fid);
					super.commonDao.update("bsa600ukrvServiceImpl.uploadFile", fParam);
				 }
				
			}else if(!ObjUtils.isEmpty(param.get("DEL_FID"))) {
				String[] fids =  ObjUtils.getSafeString(param.get("DEL_FID")).split(",");
				 for(String fid : fids) {
					fParam.put("FID", fid);
					super.commonDao.update("bsa600ukrvServiceImpl.deleteFile", fParam);
					super.commonDao.update("bsa600ukrvServiceImpl.updateBSA600T", fParam);
				}
			}
		}
		return rtn;
	}
}
