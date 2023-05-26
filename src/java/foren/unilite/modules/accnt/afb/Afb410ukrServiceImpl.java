package foren.unilite.modules.accnt.afb;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

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
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;

@Service("afb410ukrService")
public class Afb410ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.TREE_LOAD, group = "accnt")			// 조회
	public UniTreeNode selectList(Map param) throws Exception {		
		/**
		*1. result Class 확인(foren.framework.lib.tree.GenericTreeDataMap)!
		*2. SQL의 수행 결과 순서는 parent가 child보더 먼저 나오게 구성 되어야 함.
		*3. id와 parentId는 필수 !
		*4. 최상의 node는 parentId가 root로 지정 되어야 함.
		*/
		List<GenericTreeDataMap> menuList = super.commonDao.list("afb410ukrServiceImpl.selectList", param);
		return UniTreeHelper.makeTreeAndGetRootNode( menuList);
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)		// 삭제전 afb500t조회
    public List<Map<String, Object>>  selectAfb500tBeforeSave(Map param) throws Exception {
        return super.commonDao.list("afb410ukrServiceImpl.selectAfb500tBeforeSave", param);
    }
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)		// 삭제전 afb510t조회
    public List<Map<String, Object>>  selectAfb510tBeforeSave(Map param) throws Exception {
        return super.commonDao.list("afb410ukrServiceImpl.selectAfb510tBeforeSave", param);
    }
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")			// 저장
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
				
		Map<String, Object> rMap;

		if(paramList != null)	{
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteMulti")) {
					deleteList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateMulti")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}
			if(deleteList != null) this.deleteMulti(deleteList,user);
			if(updateList != null) this.updateMulti(updateList,user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public Integer  syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")			// 수정
	public List<Map>  updateMulti(List<Map> paramList, LoginVO user) throws Exception {
		logger.debug("\n updateMulti: {}",paramList );
		for(Map param :paramList )	{	
			Map chkMap = (Map)super.commonDao.select("afb410ukrServiceImpl.selectAfb410tBeforeSave", param);
			if(ObjUtils.parseInt(chkMap.get("CNT")) > 0) {
				super.commonDao.update("afb410ukrServiceImpl.update", param);  
			} else {
				super.commonDao.update("afb410ukrServiceImpl.insert", param);
			}
		}
		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")			// 삭제
	public List<Map>  deleteMulti(List<Map> paramList, LoginVO user) throws Exception {
		logger.debug("\n deleteMulti: {}",paramList );
		for(Map param :paramList )	{	
			 super.commonDao.update("afb410ukrServiceImpl.delete", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)		// 타부서복사 복사
	public int  insertDataCopy(Map param) throws Exception {
        //return super.commonDao.list("afb410ukrServiceImpl.insertDataCopy", param);
        return super.commonDao.update("afb410ukrServiceImpl.insertDataCopy", param);
    }
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)		// 타부서복사 삭제
	public List<Map<String, Object>>  deleteDataCopy(Map param) throws Exception {
        return super.commonDao.list("afb410ukrServiceImpl.deleteDataCopy", param);
    }
	
	
}
