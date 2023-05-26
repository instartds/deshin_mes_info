package foren.unilite.modules.base.bpr;

import java.util.ArrayList;
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
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.modules.com.tree.UniTreeHelper;
import foren.unilite.modules.com.tree.UniTreeNode;

@Service("bpr620ukrvService")
public class Bpr620ukrvServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 * 제조BOM 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "base")
	public UniTreeNode selectList(Map param, LoginVO user) throws Exception {
		List<GenericTreeDataMap> treeList = super.commonDao.list("bpr620ukrvServiceImpl.selectList", param);
		return  UniTreeHelper.makeTreeAndGetRootNode(treeList);
	}
	@ExtDirectMethod(group = "base")
	public List<Map> updateCodes(List<Map> paramList,LoginVO user) throws Exception {
		 for(Map param :paramList )	{	
		 super.commonDao.update("bpr620ukrvServiceImpl.updateCodes", param);
		 }
		 return paramList;
	} 
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception{
		if(paramList!=null){
			List<Map> updateList=null;
			for(Map datalistMap:paramList){
				if(datalistMap.get("method").equals("updateCodes")){
					updateList=(List<Map>) datalistMap.get("data");
				}
			}
			if(updateList!=null) this.updateCodes(updateList,user);		
		}
		paramList.add(0, paramMaster);
		return paramList;
	}
}
