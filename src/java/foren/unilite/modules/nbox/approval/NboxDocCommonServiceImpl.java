package foren.unilite.modules.nbox.approval;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.utils.ConfigUtil;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;

@Service("nboxDocCommonService")
public class NboxDocCommonServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	

	/**
	 * 회사결재문서함
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "nbox")
	public Map selectCabinetItem(Map param) throws Exception {
		logger.debug("\n nboxDocCommonService.selectCabinetItem: {}", param );
		
		Map rv = new HashMap();
		List list =super.commonDao.list("nboxDocCommonService.selectCabinetItem", param);
		
		rv.put("records", list);
		return rv;
	}
	
	/**
	 * div_code
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "nbox")
	public Map selectDivCodeItem(Map param) throws Exception {
		logger.debug("\n nboxDocCommonService.selectDivCodeItem: {}", param );
		
		Map rv = new HashMap();
		List list =super.commonDao.list("nboxDocCommonService.selectDivCodeItem", param);
		
		rv.put("records", list);
		return rv;
	}	
	
	
	/**
	 * 결재경로리스트
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "nbox")
	public Map selectDocPath(Map param) throws Exception {
		logger.debug("\n nboxDocCommonService.selectDocPath: {}", param );
		
		Map rv = new HashMap();
		List list =super.commonDao.list("nboxDocCommonService.selectDocPath", param);
		
		rv.put("records", list);
		return rv;
	}	
	
	/**
	 * dept tree 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 
	*/
	@ExtDirectMethod(value = ExtDirectMethodType.TREE_LOAD , group = "nbox")
	public UniTreeNode selectDeptTree(Map param) throws Exception {
		logger.debug("\n nboxDocCommonService.selectDeptTree: {}", param );
		
		try{
		if (this.isMenuAuthByDivCode(param))
			param.put("AUTH_FLAG", "1");
		else
			param.put("AUTH_FLAG", "0");
		
		logger.debug("\n nboxDocCommonService.selectDeptTree: {}", param );
		
		List<GenericTreeDataMap> deptList = super.commonDao.list("nboxDocCommonService.selectDeptTree", param);
		
		logger.debug("\n nboxDocCommonService.deptList.size(): {}", deptList.size() );
		
		return UniTreeHelper.makeTreeAndGetRootNode(deptList);
		} catch (Exception e) {
			logger.debug("\n nboxDocCommonService.deptList.Exception: {}", e.getMessage() );
			return null;
		}
	}
	
	public Boolean isMenuAuthByDivCode(Map param) throws Exception {
		logger.debug("\n nboxDocCommonService.isMenuAuthByDivCode: {}", param );
		param.put("PGM_ID","nboxdocwrite");
		
		int cnt = (int)super.commonDao.select("nboxDocCommonService.getMenuAuthByDivCodeCnt", param);
		
		if (cnt > 0)
			return Boolean.TRUE;
		else
			return Boolean.FALSE;
	}
	
	/**
	 * 결재양식리스트
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "nbox")
	public Map selectDocFormItem(Map param) throws Exception {
		logger.debug("\n selectDocFormItem.selectDocFormItem: {}", param );

		if (this.isMenuAuthByDivCode(param))
			param.put("AUTH_FLAG", "1");
		else
			param.put("AUTH_FLAG", "0");
		
		Map rv = new HashMap();
		List list =super.commonDao.list("nboxDocCommonService.selectDocFormItem", param);
		
		rv.put("records", list);
		return rv;
	}	
	
	/**
	 * 개인결재문서함
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "nbox")
	public Map selectMyCabinetItem(Map param) throws Exception {
		logger.debug("\n nboxDocCommonService.selectMyCabinetItem: {}", param );
		
		Map rv = new HashMap();
		List list =super.commonDao.list("nboxDocCommonService.selectMyCabinetItem", param);
		
		rv.put("records", list);
		return rv;
	}
	
	
	
	
	@ExtDirectMethod(group = "nbox")
	public Map getInterfaceForm(Map param) throws Exception {
		logger.debug("\n nboxDocCommonService.getInterfaceForm: {}", param );
		Map rv = new HashMap();
		Map details = (Map)super.commonDao.select("nboxDocCommonService.getInterfaceForm", param);

		rv.put("records", details);
		return rv;
	}
	
}
