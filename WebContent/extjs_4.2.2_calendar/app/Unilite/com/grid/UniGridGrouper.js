  //@charset UTF-8
  
  Ext.define('Unilite.com.grid.UniGridGrouper', {
    alternateClassName: ['UniGridGrouper'],
    singleton: true,
	createGroupButtonConfig: function ( grid, config ) {
			grid.uniGroupingToolbar.removeAll();
			
	        config = config || {};
	        Ext.applyIf(config, {
	            listeners: {
	                click: function(button, e) {

	                }
	            },
	            //iconCls: 'sort-' + config.sortData.direction.toLowerCase(),
	            reorderable: true,
	            xtype: 'button'
	        });
	        return config;
	},
    doGroupSummary: function (grid) {
    	
    	grid.suspendEvents();
        
        var store = grid.getStore();
        var drops = this.getDrops(grid);
        
        if( (store.getCount() > 0) && !Ext.isEmpty(drops) ) {
			
        	//group
	        store.clearGrouping();
		    store.group(drops[0].dataIndex, 'ASC');
	
		    //summary
		    var view;
		    if(grid.lockedGrid) {
			    view = grid.lockedGrid.getView();
				view.getFeature('masterGridSubTotal').toggleSummaryRow( view.getFeature('masterGridSubTotal').showSummaryRow );
				view.getFeature('masterGridTotal').toggleSummaryRow( view.getFeature('masterGridTotal').showSummaryRow );
				view.refresh();
				
				view = grid.normalGrid.getView();
				view.getFeature('masterGridSubTotal').toggleSummaryRow( view.getFeature('masterGridSubTotal').showSummaryRow );
				view.getFeature('masterGridTotal').toggleSummaryRow( view.getFeature('masterGridTotal').showSummaryRow );
				view.refresh();
		    } else {
		    	view = grid.getView();
				view.getFeature('masterGridSubTotal').toggleSummaryRow( view.getFeature('masterGridSubTotal').showSummaryRow );
				view.getFeature('masterGridTotal').toggleSummaryRow( view.getFeature('masterGridTotal').showSummaryRow );
				view.refresh();
		    }
		    
        };

        grid.resumeEvents();
	},
	 getDrops: function (grid) {
	        var drops = [];
	 		if(grid.uniGroupingToolbar ) {
		        Ext.each(grid.uniGroupingToolbar.query('button'), function(button) {
		            drops.push(button.groupData);
		        }, this);
	 		}
	        return drops;
	 },
	 // Grid header에서 Grouping시 GroupingToolBar내용 제거 후 전달된 column을 다시 생성함.
	 clearGroupingToolbar: function(grid, column, pDirection) {
	        var sortBtns = [];
	 		if(grid.uniGroupingToolbar ) {
	 			 Ext.each(grid.uniGroupingToolbar.query('button'), function(button) {
		            sortBtns.push(button);
		        }, this);
	 			//for (var i = 0; i < sortBtns.length; ++i) {
	 			//	grid.uniGroupingToolbar.remove(sortBtns[i], true);
	 			//	console.log('remove');
				//}
				grid.uniGroupingToolbar.removeAll();
	 		}
	 		if(column) {
	 			
				var btnText = column.text.replace(/<span(?:.*?)>(?:.*?)<\/span>/g,'');
	 			var newButton = this.createGroupButtonConfig( grid, {
		                text: btnText,
		                groupData: {
		                    dataIndex: column.dataIndex,
		                    direction: pDirection
		                }
		            });
		            grid.uniGroupingToolbar.insert(0,newButton);
	 		}
	 		
	 	
	 }
    	
});