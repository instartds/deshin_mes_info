Ext.define("Unilite.com.view.UniActionContainer", {
	extend : "Ext.Component",
	alias : "widget.uniActionContainer",
	initComponent : function() {
		this.style = "cursor: pointer;", this.cls = "dropdown";
		this.callParent()
	},
	onClick:Ext.emptyFn,
	listeners : {
		afterrender : function(b) {
				b.el.addListener("click", function(d, a) {
							this.onClick(this.el);
						}, this)
		}
	}
}); // Ext.define
