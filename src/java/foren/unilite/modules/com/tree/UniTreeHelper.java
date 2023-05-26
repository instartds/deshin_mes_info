package foren.unilite.modules.com.tree;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.lib.tree.GenericTreeNode;

public class UniTreeHelper {
	private final Logger	logger	= LoggerFactory.getLogger(UniTreeHelper.class);
	/**
     * Build Menu List and Menu-Auth List
     * 
     * @param menuList
     * @param menuLevelList
     * @return
     */
    public static UniTreeNode makeTreeAndGetRootNode(List<GenericTreeDataMap> menuList) {
    	
        UniTree tree = new UniTree();
        Map<String, UniTreeNode> menuMap = new HashMap<String, UniTreeNode>();
        
        // 가상 root 를 미리 만들어줌.
        UniTreeNode root = new UniTreeNode();
        GenericTreeDataMap<String,Object> m = new GenericTreeDataMap<String,Object>();
        m.put("id", "root");
        root.setData(m);
        tree.setRoot(root);
        
        for (GenericTreeDataMap item : menuList) {
            UniTreeNode node = new UniTreeNode(item);
            UniTreeNode pNode = null;
            //String id = (String) item.getId();
            // if ("1".equals(id)) {
            //    tree.setRoot(node);
            //} else {
                pNode = tree.getNodeByID(item.getParentId());
            //}
            if (pNode != null) {
                pNode.addChild(node);
                setExpandedOfParent(node);
            }
            menuMap.put(item.getId(), node);
            // uriMap.put(item.getUrl(), item.getMenuID());
        }
        
        tree.setMenuMap(menuMap);
        return (UniTreeNode) tree.getRoot();
    }
    /**
     * 상위 노드까지 모누 expanded 를 true로 바꾼다.
     * @param node
     * @param expanded
     */
    private static void setExpandedOfParent(UniTreeNode node) {
    	if(node.getExpanded()) {
    		UniTreeNode pNode = (UniTreeNode) node.getParent();
    		if(pNode != null && pNode.getExpanded() != true) {
    			pNode.setExpanded(true);
    			setExpandedOfParent(pNode);
    			/*
    			// true일때는 하나의 자식만 true 여도 펼쳐 지지만 닫을때는 자식 모두가 닫혀 있어야 함.
    			if(expanded ) {
    				setExpanded(pNode, expanded);
    			} else {
    				List<GenericTreeNode<GenericTreeDataMap>>  children = pNode.getChildren();
    				boolean allCollapsed = true;
    				for(GenericTreeNode<GenericTreeDataMap> child : children) {
    					UniTreeNode tChild = (UniTreeNode) child;
    					if(tChild.getExpanded()) {
    						allCollapsed = false;
    						break;
    					}
    				}
    				if(allCollapsed) {
    					setExpanded(pNode, false);
    				}
    			}
    			*/
    		}
    	}
    }
}
