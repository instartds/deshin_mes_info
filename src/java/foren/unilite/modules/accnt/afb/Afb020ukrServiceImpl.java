package foren.unilite.modules.accnt.afb;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;

@Service("afb020ukrService")
public class Afb020ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	/**
	 *  부서 목록 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.TREE_LOAD, group = "base")
	public UniTreeNode selectList(Map param) throws Exception {		
		/**
		*1. result Class 확인(foren.framework.lib.tree.GenericTreeDataMap)!
		*2. SQL의 수행 결과 순서는 parent가 child보더 먼저 나오게 구성 되어야 함.
		*3. id와 parentId는 필수 !
		*4. 최상의 node는 parentId가 root로 지정 되어야 함.
		*/
		List<GenericTreeDataMap> menuList = super.commonDao.list("afb020ukrServiceImpl.selectTreeList", param);
		return UniTreeHelper.makeTreeAndGetRootNode( menuList);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public List<Map>  updateMulti(List<Map> paramList, LoginVO user) throws Exception {
		logger.debug("\n updateMulti: {}",paramList );
		for(Map param :paramList )	{	
			 super.commonDao.update("afb020ukrServiceImpl.update", param);
		}
		return paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
				
		Map<String, Object> rMap;

		if(paramList != null)	{
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateMulti")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}
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
}
