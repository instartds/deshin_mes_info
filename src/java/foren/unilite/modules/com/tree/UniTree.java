package foren.unilite.modules.com.tree;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import foren.framework.lib.tree.GenericTree;
import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.lib.tree.GenericTreeNode;

public class UniTree extends GenericTree<GenericTreeDataMap> {

    private static final Log logger = LogFactory.getLog(UniTree.class);
    
    /**
     * id 기반 
     */
    private Map<String, UniTreeNode> menuMap = new HashMap<String, UniTreeNode>();
    /**
     * menu_id 기반 
     * @param menuMap
     */
    public void setMenuMap(Map<String, UniTreeNode> menuMap) {
        this.menuMap = menuMap;
    }
    
    
    
	   /**
     * Menu ID로 노드를 찾아 옮
     * @param menuID
     * @return
     */
    public UniTreeNode getNodeByID(String menuID) {
        if(menuID != null) {
            return getNodeByID( (UniTreeNode) this.getRoot(), menuID);
        } else {
            return null;
        }
    }

    private UniTreeNode getNodeByID(UniTreeNode element, String menuID) {
    	UniTreeNode returnNode = null;
        if(element !=null) {
            GenericTreeDataMap item = element.getData();
            //logger.debug(" menuID = " + menuID);
            if(menuID.equals(item.getId())) {
                returnNode=  (UniTreeNode) element;
            }else {
                for (GenericTreeNode<GenericTreeDataMap> data :  element.getChildren()) {
                    
                    returnNode= getNodeByID((UniTreeNode)data, menuID);
                    if(returnNode != null) {
                        break;
                    }
                }
            }
        }
        return returnNode;
    }
}