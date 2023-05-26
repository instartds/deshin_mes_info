// @charset UTF-8
Ext.define("Unilite.main.MainTreeForSystemMenu", {
			extend : "Unilite.main.MainTree",

			initComponent : function() {
				/* Navigation 메뉴 헤더에 툴바 구현으로 삭제
				Ext.apply(this, {
							tbar : ['->',
                                    {
										//text : 'Expand All',
                                        iconCls : 'icon-expandAll',
										scope : this, 
										handler : this.onExpandAllClick
									}, {
										//text : 'Collapse All',
                                        iconCls : 'icon-collapsedAll',
										scope : this,
										handler : this.onCollapseAllClick
									}]
						});// apply
				*/		
				this.callParent();
			},

			onExpandAllClick : function() {
				var me = this, toolbar = me.down('toolbar');

				me.getEl().mask('Expanding tree...');
				toolbar.disable();

				this.expandAll(function() {
							me.getEl().unmask();
							toolbar.enable();
						});
			},

			onCollapseAllClick : function() {
				var toolbar = this.down('toolbar');

				toolbar.disable();
				this.collapseAll(function() {
							toolbar.enable();
						});
			}
});
        
        