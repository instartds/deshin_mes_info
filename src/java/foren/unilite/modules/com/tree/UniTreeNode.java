package foren.unilite.modules.com.tree;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import foren.framework.lib.tree.GenericTreeDataMap;
import foren.framework.lib.tree.GenericTreeNode;

/**
 * 
 * @author Thomas
 *
 */
public class UniTreeNode extends GenericTreeNode<GenericTreeDataMap> {

	private static final Log logger = LogFactory.getLog(UniTreeNode.class);

	public UniTreeNode() {
		super();
	}
	
	public Boolean getExpanded() {
		if(this.getData() != null) {
			return this.getData().getExpanded();
		} else {
			return false;
		}
	}



	public void setExpanded(Boolean expanded) {
		if(this.getData() != null) {
			 this.getData().setExpanded(expanded);
		}
	}

	public UniTreeNode(GenericTreeDataMap item) {
		this();
		if (item != null) {
			this.setData(item);
		}
	}
}
