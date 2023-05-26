  //@charset UTF-8
  
  Ext.define('Unilite.com.grid.UniGridMultiSorter', {
    alternateClassName: ['UniGridMultiSorter'],
    singleton: true,
	createSorterButtonConfig: function ( grid, config ) {
	        config = config || {};
	        Ext.applyIf(config, {
	            listeners: {
	                click: function(button, e) {
	                    UniGridMultiSorter.changeSortDirection(grid, button, true);
	                }
	            },
	            iconCls: 'sort-' + config.sortData.direction.toLowerCase(),
	            reorderable: true,
	            xtype: 'button'
	        });
	        return config;
	},
    doSort: function (grid) {
    	grid.suspendEvents();
        var sorter = this.getSorters(grid);
        //console.log("doSort S", sorter, new Date().getTime());
        grid.store.sort(sorter);
        //console.log("doSort F", new Date().getTime());
        grid.resumeEvents();
	},
    changeSortDirection: function (grid, button, changeDirection) {
	        var sortData = button.sortData,
	            iconCls  = button.iconCls;
	        
	        if (sortData) {
	            if (changeDirection !== false) {
	                button.sortData.direction = Ext.String.toggle(button.sortData.direction, "ASC", "DESC");
	                button.setIconCls(Ext.String.toggle(iconCls, "sort-asc", "sort-desc"));
	            }
	            grid.store.clearFilter();
	            this.doSort(grid);
	        }
	    },
	 getSorters: function (grid) {
	        var sorters = [];
	 		if(grid.uniSortingToolbar ) {
		        Ext.each(grid.uniSortingToolbar.query('button'), function(button) {
		            sorters.push(button.sortData);
		        }, this);
	 		}
	        return sorters;
	 },
	 // Grid header에서 Sorting시 SortingToolBar내용 제거 후 전달된 column을 다시 생성함.
	 clearSortingToolbar: function(grid, column, pDirection) {
	        var sortBtns = [];
	 		if(grid.uniSortingToolbar ) {
	 			 Ext.each(grid.uniSortingToolbar.query('button'), function(button) {
		            sortBtns.push(button);
		        }, this);
	 			//for (var i = 0; i < sortBtns.length; ++i) {
	 			//	grid.uniSortingToolbar.remove(sortBtns[i], true);
	 			//	console.log('remove');
				//}
				grid.uniSortingToolbar.removeAll();
	 		}
	 		if(column) {
	 			
				var btnText = column.text.replace(/<span(?:.*?)>(?:.*?)<\/span>/g,'');
	 			var newButton = this.createSorterButtonConfig( grid, {
		                text: btnText,
		                sortData: {
		                    property: column.dataIndex,
		                    direction: pDirection
		                }
		            });
		            grid.uniSortingToolbar.insert(0,newButton);
	 		}
	 		
	 	
	 }
    	
});