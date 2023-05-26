  //@charset UTF-8
  
  Ext.define('Unilite.com.grid.UniGridMultiSorter', {
    alternateClassName: ['UniGridMultiSorter'],
    singleton: true,	
	createSorterButtonConfig: function ( grid, config ) {
	        config = config || {};
	        
	        var btn =  {
	        	xtype:'segmentedbutton',
	        	sortData:config.sortData,
	        	itemId : 'btn_'+config.column.dataIndex,
	        	reorderable: true,
	            items:[
	            	{
	            		text:config.text,
	            		itemId:'textbtn',
	            		reorderable: false,
	            		listeners: {
			                click: function(button, e) {
			                    UniGridMultiSorter.changeSortDirection(grid, button, true);
			                }
			            },
			            iconCls: 'sort-' + config.sortData.direction.toLowerCase()
	            	
	            	},
	            	{
	            		text:'  ',
	            		width:16,
	            		iconCls:'sort-close',
	            		tooltip:'삭제',
	            		reorderable: false,
	            		uniOpt:{
							grid:grid,
							btnItemId : 'btn_'+config.column.dataIndex
						},
	            		handler:function(btn,event)	{
			            	var grid = btn.uniOpt.grid;
			            	var gBtn = btn.up('#'+btn.uniOpt.btnItemId);
							grid.uniSortingToolbar.remove(gBtn, true);
							//var sorter = UniGridMultiSorter.getSorters(grid);
							UniGridMultiSorter.doSort(grid);
							grid.fireEvent("afterlayout", grid);
						}
	            	}
	            ]};
	        return btn;
	},
    doSort: function (grid) {
    	grid.suspendEvents();
        var sorter = this.getSorters(grid);
        //console.log("doSort S", sorter, new Date().getTime());
        if(sorter.length == 0)	{
        	sorter = [{property: "id",direction: "ASC"}];
        	grid.store.sort(sorter);
        }else {
        	
			grid.store.sort(sorter);
        }
        //console.log("doSort F", new Date().getTime());
        console.log(" doSort sorters : ", sorter)
        grid.resumeEvents();
	},
    changeSortDirection: function (grid, button, changeDirection) {
    		var sortBtn = button.sortData ? button : button.up('segmentedbutton');
	        var sortData = sortBtn.sortData,
	        	textBtn = sortBtn.down('#textbtn'),
	            iconCls  = textBtn.iconCls;
	        
	        if (sortData) {
	            if (changeDirection !== false) {
	                sortBtn.sortData.direction = Ext.String.toggle(sortBtn.sortData.direction, "ASC", "DESC");
	                
	                textBtn.setIconCls(Ext.String.toggle(iconCls, "sort-asc", "sort-desc"));
	            }
	            grid.store.clearFilter();
	            this.doSort(grid);
	        }
	    },
	 getSorters: function (grid) {
	        var sorters = [];
	 		if(grid.uniSortingToolbar ) {
		        Ext.each(grid.uniSortingToolbar.query('segmentedbutton'), function(button) {
		            sorters.push(button.sortData);
		        }, this);
	 		}
	        return sorters;
	 },
	 // Grid header에서 Sorting시 SortingToolBar내용 제거 후 전달된 column을 다시 생성함.
	 clearSortingToolbar: function(grid, column, pDirection) {
	        var sortBtns = [];
	 		if(grid.uniSortingToolbar ) {
	 			 Ext.each(grid.uniSortingToolbar.query('segmentedbutton'), function(button) {
		            sortBtns.push(button);
		        }, this);
	 		
	 		}
	 		if(column) {
	 			for (var i = 0; i < sortBtns.length; ++i) {
	 				if(sortBtns[i].sortData.property == column.dataIndex)	{
	 					grid.uniSortingToolbar.remove(sortBtns[i], true);
	 				}
				}
				var btnText = column.text.replace(/<span(?:.*?)>(?:.*?)<\/span>/g,'');
	 			var newButton = this.createSorterButtonConfig( grid, {
		                text: btnText,
		                column:column,
		                sortData: {
		                    property: column.dataIndex,
		                    direction: pDirection,
		                    mode:'multi'
		                }
		            });
		            sortBtns = grid.uniSortingToolbar.query('segmentedbutton');
		            var idx = 0;
		            if(sortBtns != null && sortBtns.length > 0)	{
		            	idx = sortBtns.length;
		            }
		            grid.uniSortingToolbar.insert(idx,newButton);
		            UniGridMultiSorter.doSort(grid);
		            grid.fireEvent("afterlayout", grid);
	 		}
	 		
	 	
	 }
    	
});