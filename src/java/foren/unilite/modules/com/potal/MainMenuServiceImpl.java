package foren.unilite.modules.com.potal;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.lib.tree.GenericTreeNode;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.menu.MenuItemModel;
import foren.unilite.com.menu.MenuNode;
import foren.unilite.com.menu.MenuTree;
import foren.unilite.com.menu.ProgramAuthModel;
import foren.unilite.com.menu.UniModuleModel;
import foren.unilite.com.service.impl.TlabAbstractCommonServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;

@Service("mainMenuService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class MainMenuServiceImpl extends TlabAbstractCommonServiceImpl {
	private static final Logger logger = LoggerFactory.getLogger(MainMenuServiceImpl.class);
	
	@Resource(name="tlabMenuService")
	TlabMenuService menuService ;
	
//	@ExtDirectMethod(value = ExtDirectMethodType.TREE_LOAD, group = "com")
//	public GenericTreeNode  selectList(Map param) throws Exception {
//		MenuTree mTree = menuService.getMenuTree(Unilite.BASIC_COMP_CODE);
//		 GenericTreeNode<MenuItemModel>  root = mTree.getRoot();
//		return root;
//	}
	
	//'tlabMenuServiceImpl.getMenuList'

	/**
	 * 모듈에 따른 메뉴 목록을 돌려줌.
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.TREE_LOAD, group = "com")
	public GenericTreeNode<MenuItemModel> getMenuList(Map param, LoginVO user) throws Exception {
//		TlabMenuService menuService = SystemUtils.getMenuService() ;
		MenuTree meneTree = menuService.getMenuTree(user.getCompCode());
		
		String module = ObjUtils.getSafeString(param.get("moduleId"),"11");
		Map<String,ProgramAuthModel> pgmUserMap = menuService.getPgmUserList(param);
		
		String menuDisplayYn = "Y";//(String) super.commonDao.select("selectUserMenuDisplayYN", param);
				
		MenuNode mNode =  meneTree.getNodeByMenuID(module);
		setUserViewMenu(mNode, pgmUserMap, menuDisplayYn);
		setCategoryView(mNode);
		return  mNode;
		
//		List<GenericTreeNode<MenuItemModel>> nodes = mNode.getChildren();
		
		
	}
	
	/**
	 * 사용자가 볼수 있는 메뉴 인지 표시 
	 * @param mNode
	 * @param pgmUserMap
	 * @return
	 */
	private GenericTreeNode<MenuItemModel> setUserViewMenu(GenericTreeNode<MenuItemModel> mNode, Map pgmUserMap, String menuDisplayYn) {
		if(mNode != null) {
			for(GenericTreeNode<MenuItemModel> node : mNode.getChildren()) {
				String pgmId = node.getData().getMenuID();
				if(pgmUserMap.containsKey(pgmId)) {
					node.getData().setViewYN(true);
					ProgramAuthModel pgmInfo = (ProgramAuthModel)pgmUserMap.get(pgmId);
					node.getData().setAuthoUser(ObjUtils.getSafeString(pgmInfo.getAUTHO_USER()));
				} else {
					node.getData().setViewYN(false);
				}
				//숨김메뉴 제거
				if("0".equals(node.getData().getMenuType()))	{
					if(!node.hasChildren() ){
						node.getData().setHideYN(true);
					}
				}
				if (node.hasChildren()) {
					mNode = setUserViewMenu(node, pgmUserMap, menuDisplayYn);
				}
			}
		}
		return mNode;
		
	}
	
	private GenericTreeNode<MenuItemModel> setCategoryView(GenericTreeNode<MenuItemModel> mNode) {
		if(mNode != null) {
			boolean checkViewYn = false;
			for(GenericTreeNode<MenuItemModel> node : mNode.getChildren()) {
				if(node != null && node.getNumberOfChildren() == 0 && node.getData().isViewYN())	{
					checkViewYn = true;
				} else if(node != null && node.getNumberOfChildren() > 0 )	{
					if(setCategoryView(node).getData().isViewYN())	{
						checkViewYn = true;
					}
					//logger.debug("######### node viewYN : "+node.getData().getMenuName()+" . viewYN : "+checkViewYn);
				}
			}
			mNode.getData().setViewYN(checkViewYn);
			//logger.debug("######### mNode viewYN : "+mNode.getData().getMenuName()+" . viewYN : "+checkViewYn);
		}
		return mNode;
		
	}
	
	/**
	 * MyMenu에 특정 프로그램 등록 
	 * 
	 * @param param : pgmId
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.SIMPLE, group = "com")
	public Object addMyMenu(Map param, LoginVO user) throws Exception {	
			logger.debug("Param : {}", param);
			String pgmId = ObjUtils.getSafeString(param.get("pgmId"),"");
			//param.put("PGM_ID", pgmId.substring(pgmId.indexOf(".")+1)) ;
			param.put("PGM_ID", pgmId) ;
			Integer chk = (Integer)super.commonDao.select("mainMenuServiceImpl.checkMyMenu", param);
			//chk =0;
			if(chk < 1) {
				super.commonDao.insert("mainMenuServiceImpl.addMyMenu", param);
			} else{
				throw new Exception("이미 MyMenu에 등록 되어 있습니다.");
			}
			return null;
	}
	
	/**
	 * MyMenu에서 지정 프로그램 삭제
	 * 
	 * 
	 * @param param (pgmId)
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.SIMPLE, group = "com")
	public Object removeMyMenu(Map param, LoginVO user) throws Exception {	
			logger.debug("Param : {}", param);
			String pgmId = ObjUtils.getSafeString(param.get("pgmId"),"");
			//param.put("PGM_ID", pgmId.substring(pgmId.indexOf(".")+1)) ;
			param.put("PGM_ID", pgmId) ;
			super.commonDao.insert("mainMenuServiceImpl.removeMyMenu", param);
			return null;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.TREE_LOAD, group = "com")
	public Object getMyMenuList(Map<String, Object> param, LoginVO user) throws Exception {
//		TlabMenuService menuService = SystemUtils.getMenuService() ;
//		MenuTree meneTree = menuService.getMenuTree(user.getCompCode());
//		List<UniModuleModel> modules = menuService.getModules(user.getCompCode());
//	  List<Map<String,Object>> rv = new ArrayList<Map<String,Object>>();
		
		List<Map<String,Object>> myMenuList = super.commonDao.list("mainMenuServiceImpl.selectMyMenu", param);
		
		List<Map<String,Object>> myMenus = new ArrayList<Map<String,Object>>();
		int i = 0;
		for(Map<String,Object> item: myMenuList) {
			item.put("index", i);
			item.put("leaf", true);
			if("true".equals(item.get("viewYN") )) {
				item.put("viewYN", true);
			} else {
				item.put("cls","x-tree-node-text-disable");
				item.put("iconCls","x-tree-leaf-disable");
				item.put("viewYN", false);
				
			}
			myMenus.add(item);
			i++;
		}
		
		return  myMenus;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "com")
	public Object updateMyMenuList(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{
			super.commonDao.delete("mainMenuServiceImpl.updateMyenu", param);
		}
		return  paramList;
	}
	
	/**
	 * 사용안함(백업용)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
//	@ExtDirectMethod(value = ExtDirectMethodType.TREE_LOAD, group = "com")
//	public Object getMyMenuListWithModules(Map param, LoginVO user) throws Exception {
////		TlabMenuService menuService = SystemUtils.getMenuService() ;
//		MenuTree meneTree = menuService.getMenuTree(user.getCompCode());
//		
//		List<UniModuleModel> modules = menuService.getModules(user.getCompCode());
//		
//		List<Map<String,Object>> myMenuList = super.commonDao.list("mainMenuServiceImpl.selectMyMenuWithModules", param);
//		List<Map> rv = new ArrayList();
//		
//		for (Map<String,Object> item : myMenuList) {
//			String pid = ObjUtils.getSafeString( item.get("pid"));
//			String pgmId = ObjUtils.getSafeString( item.get("prgID"));
//			if("root".equals(pid)) {
//				if(isValidModule(modules, pgmId)) {
//					item.put("leaf", false);
//					item.put("expanded", true);
//					rv.add(item);
//				}
//			} else {
//				//Map<String, List> pNode =  treeMap.get(pid);
//				Map<String, List> pNode =  getPnode(rv,pid,"prgID");
//				if(pNode == null) {
//					logger.debug("Pnode not found {} {}", pid, pgmId); 
//				} else {
//					List children = (List) pNode.get("children");
//					if( children == null) {
//						children = new ArrayList();
//					}
//					item.put("leaf", true);
//					children.add(item);
//					pNode.put("children", children);
//				}
//				
//			}
//		}
//
//
//		List<Map<String,Object>> myMenus = new ArrayList();
//		for(Map<String, Object> item: rv) {
//			Object children = item.get("children");
//			if(children instanceof List) {
//				myMenus.add(item);
//			} else {
//				//item.put("leaf", true);
//			}
//		}
//		return  myMenus;
//	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.TREE_LOAD, group = "com")
	public Object getProcessMenu(Map param) throws Exception {
		List<Map<String,Object>> rawProcessMenus = super.commonDao.list("mainMenuServiceImpl.selectProcessMenu", param);
		List<Map<String,Object>> rv = new ArrayList<Map<String,Object>>();
		
		boolean isFirstMenu = true;
		for (Map<String,Object> item : rawProcessMenus) {
			String pid = ObjUtils.getSafeString( item.get("pid"));
			String pgmId = ObjUtils.getSafeString( item.get("prgID"));
			if("root".equals(pid)) {
				item.put("leaf", false);
				if(isFirstMenu) {
					item.put("expanded", true);
					isFirstMenu = false;
				}
				rv.add(item);
			} else {
				//Map<String, List> pNode =  treeMap.get(pid);
				Map<String, Object> pNode =  getPnode(rv,pid,"prgID");
				if(pNode == null) {
					logger.debug("Pnode not found {} {}", pid, pgmId); 
				} else {
					List children = (List) pNode.get("children");
					if( children == null) {
						children = new ArrayList();
					}
					item.put("leaf", true);
					children.add(item);
					pNode.put("children", children);
				}
				
			}
		}
		List<Map<String, Object>> processMenus = new ArrayList<Map<String, Object>>();
		for(Map<String, Object> item: rv) {
			Object children = item.get("children");
			if(children instanceof List) {
				processMenus.add(item);
			} else {
				item.put("leaf", true);
			}
		}
//		StringBuffer json = ObjUtils.toJsonStr(myMenus);
		return  processMenus;
	}
	
	private boolean isValidModule(List<UniModuleModel> list, String id) {
		for(UniModuleModel item : list) {
			if(id.equals(item.getId())) {
				return true;
			}
		}
		return false;
	}
	private Map<String, Object> getPnode(List<Map<String, Object>> list, String pid, String name) {
		for( Map<String, Object> rec : list) {
			if(pid.equals(rec.get(name))) {
				return rec;
			}
		}
		return null;
		
	}
	
	@ExtDirectMethod( group = "main")
	public Object searchMenu(Map param, LoginVO user) throws Exception {
		String lang = user.getLanguage();
		String targetField = "PGM_NAME";
		if( "en".equals(lang)) {
			targetField = "PGM_NAME_EN";
		} else if( "zh".equals(lang)) {
			targetField = "PGM_NAME_CN";
		} else if( "ja".equals(lang)) {
			targetField = "PGM_NAME_JP";
		}else if( "ja".equals(lang)) {
			targetField = "PGM_NAME_VI";
		}
		param.put("TARGET_FIELD", targetField);
		List<Map<String,Object>> list = super.commonDao.list("mainMenuServiceImpl.searchMenu", param);
		Map<String, Object> rv = new HashMap<String, Object>();
		int totalCount = 0;
		if(list.size() > 0 ) {
			Map<String,Object> rec =  list.get(0);
			totalCount = (Integer)rec.get("TotalCount");
		}
		rv.put("total", totalCount);
		rv.put("records", list);
		
		return rv;
	}
	
	/**
	 * 외부사용자 메뉴 가져오기 (양평공사)
	 * */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "com")
	public List<Map<String, Object>> getExtUserMenu(Map param) throws Exception {
		return  super.commonDao.list("mainMenuServiceImpl.getExtUserMenu", param);
	}




	/**
	 * 20210302 추가: 운송장 대역폭 확인로직 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "com")
	public Object getInvoiceNumCount(Map param) throws Exception {
		return super.commonDao.select("mainMenuServiceImpl.getInvoiceNumCount", param);
	}
}