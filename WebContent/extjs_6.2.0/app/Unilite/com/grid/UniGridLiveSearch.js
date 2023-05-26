//Ext.override(Ext.selection.CellModel, {
//	setCurrentPosition: function(pos, suppressEvent, /* private */ preventCheck) {
//        var me = this,
//            last = me.selection,
//            view;
//
//        // onSelectChange uses lastSelection and nextSelection
//        me.lastSelection = last;
//
//        // Normalize it into an Ext.grid.CellContext if necessary
//         //pos = pos.isCellContext ? pos : new Ext.grid.CellContext(me.primaryView).setPosition(pos);
//        if (pos) {
//        	if(pos.view) {
//        		view = pos.view;
//        	} else {
//        		view = me.primaryView
//        	}           
//        	pos = pos.isCellContext ? pos : new Ext.grid.CellContext(view).setPosition(pos);
//        }
//        if (!preventCheck && last) {
//            // If the position is the same, jump out & don't fire the event
//        	// record 가 같아도 cellmode 에서 cell 이동이 가능하도록 pos 를 null로 처리하지 않는다.
////            if (pos && (pos.record === last.record && pos.columnHeader === last.columnHeader && pos.view === last.view)) {
////                pos = null;
////            } else {
//                me.onCellDeselect(me.selection, suppressEvent);
////            }
//        }
//
//        if (pos) {
//            me.nextSelection = pos;
//            // set this flag here so we know to use nextSelection
//            // if the node is updated during a select
//            me.selecting = true;
//            me.onCellSelect(me.nextSelection, suppressEvent);
//            me.selecting = false;
//            // Deselect triggered by new selection will kill the selection property, so restore it here.
//            return (me.selection = pos);
//        }
//        // <debug>
//        // Enforce code correctness in unbuilt source.
//        return null;
//        // </debug>
//    },
//    onViewRefresh: function(view) {
//        var me = this,
//            pos = me.getCurrentPosition(),
//            newPos,
//            headerCt = view.headerCt,
//            record, columnHeader;
//
//        // Re-establish selection of the same cell coordinate.
//        // DO NOT fire events because the selected 
//        if (pos && pos.view === view) {
//            record = pos.record;
//            columnHeader = pos.columnHeader;
//
//            // After a refresh, recreate the selection using the same record and grid column as before
//            if (columnHeader && !columnHeader.isDescendantOf(headerCt)) {
//                // column header is not a child of the header container
//                // this happens when the grid is reconfigured with new columns
//                // make a best effor to select something by matching on id, then text, then dataIndex
//                columnHeader = headerCt.queryById(columnHeader.id) || 
//                               headerCt.down('[text="' + columnHeader.text + '"]') ||
//                               headerCt.down('[dataIndex="' + columnHeader.dataIndex + '"]');
//            }
//
//            // If we have a columnHeader (either the column header that already exists in
//            // the headerCt, or a suitable match that was found after reconfiguration)
//            // AND the record still exists in the store (or a record matching the id of
//            // the previously selected record) We are ok to go ahead and set the selection
//            if (pos.record) {
//                if (columnHeader && (view.store.indexOfId(record.getId()) !== -1)) {
//                    newPos = new Ext.grid.CellContext(view).setPosition({
//                        row: record,
//                        column: columnHeader
//                    });
//                    me.setCurrentPosition(newPos);
//                }
//            } else {
//                me.selection = null;
//            }
//        }
//    }
//});
//
//Ext.override(Ext.view.Table, {
//	getCellByPosition: function(position, returnDom) {
//        if (position) {
//            var row   = this.getNode(position.row, true);
//            
//            header = this.ownerCt.getColumnManager().getHeaderAtIndex(position.column);
//            
//            /*
//            var columns  = this.ownerCt.getColumnManager().getColumns();            
//            //position 의 위치값을 렌더링된 dom에서 추출했기 때무네 visible 컬럼만 비교
//            var visibleColumns = [];
//             Ext.Array.each(columns, function(col, index) {
//	        	if(col.isVisible())
//	        		visibleColumns.push(col);
//	    	});
//	    	
//	    	header = visibleColumns[position.column] || null; */               
//            
//
//            if (header && row) {
//                return Ext.fly(row).down(this.getCellSelector(header), returnDom);
//            }
//        }
//        return false;
//    }
//});

Ext.define('Unilite.com.grid.UniGridLiveSearch', {
    /**
     * @private
     * search value initialization
     */
    searchValue: null,
    
    /**
     * @private
     * The row indexes where matching strings are found. (used by previous and next buttons)
     */
    indexes: [],
    
    /**
     * @private
     * The row index of the first search, it could change if next or previous buttons are used.
     */
    currentIndex: null,
    
    /**
     * @private
     * The generated regular expression used for searching.
     */
    searchRegExp: null,
    
    /**
     * @private
     * Case sensitive mode.
     */
    caseSensitive: false,
    
    /**
     * @private
     * Regular expression mode.
     */
    regExpMode: false,
    
    /**
     * @cfg {String} matchCls
     * The matched string css classe.
     */
    matchCls: 'x-livesearch-match',
    
    defaultStatusText: '0 matche(s) found.',
    
    // detects html tag
    tagsRe: /<[^>]*>/gm,
    
    // DEL ASCII code
    tagsProtect: '\x0f',
    
    // detects regexp reserved word
    regExpProtect: /\\|\/|\+|\\|\.|\[|\]|\{|\}|\?|\$|\*|\^|\|/gm,
    
    
    
    /**
     * In normal mode it returns the value with protected regexp characters.
     * In regular expression mode it returns the raw value except if the regexp is invalid.
     * @return {String} The value to process or null if the textfield value is blank or invalid.
     * @private
     */
    getSearchValue: function() {
        var me = this,
            value = me.down('textfield[name=searchField]').getValue();
            
        if (value === '') {
            return null;
        }
        if (!me.regExpMode) {
            value = value.replace(me.regExpProtect, function(m) {
                return '\\' + m;
            });
        } else {
            try {
                new RegExp(value);
            } catch (error) {
            	me.down('tbtext[itemId="searchStatus"]').setText(error.message);
                return null;
            }
            // this is stupid
            if (value === '^' || value === '$') {
                return null;
            }
        }

        return value;
    },
    
    /**
     * Finds all strings that matches the searched value in each grid cells.
     * @private
     */
     onTextFieldChange: function() {
         var me = this,
             count = 0;

         me.view.refresh();
         // reset the statusbar
         me.down('tbtext[itemId="searchStatus"]').setText(me.defaultStatusText);

         me.searchValue = me.getSearchValue();
         me.indexes = [];
         me.currentIndex = null;

         if (me.searchValue !== null) {
             me.searchRegExp = new RegExp(me.searchValue, 'g' + (me.caseSensitive ? '' : 'i'));
             
             count = me._searchText(me.getView());
             me.store.each(function(record, idx) {
             	var node = Ext.fly(me.view.getNode(idx));	// view 안의 row
             	             	
             	if( !Ext.isEmpty(node)) {
		        	//count += me._searchValue(me.getView(), idx);
             		if(me.lockedGrid)	{
             			me._setHighlite(me.lockedGrid.getView(), idx);
             			me._setHighlite(me.normalGrid.getView(), idx);
             		}else {
             			me._setHighlite(me.getView(), idx);
             		}
             	}
             }, me);

             if (me.currentIndex !== null ) {                 
             	 if(me.getSelectionModel().isCellModel) {
             	 	me.getSelectionModel().select(me.currentIndex.record);
             	 }else{
             	 	me.getSelectionModel().select(me.currentIndex.record);
             	 }
             } else {
            	 if(me.indexes && me.indexes.length > 0 )	{
            		 me.currentIndex = me.indexes[0];
            		 me.getSelectionModel().select(me.currentIndex.record);
            		 var gridPlugins = me.getPlugins();
            		 var gridPlug = me.getPlugins().filter(
            				 function(plugin){
            					 return plugin.ptype == 'bufferedrenderer';
            				});
            		 
            		 if(gridPlug && gridPlug.length > 0)	{
            			 gridPlug[0].scrollTo(me.currentIndex.rowIndex);
            		 }
            	 } 
             }
             me.down('tbtext[itemId="searchStatus"]').setText(count + ' matche(s) found.');
         }

         // no results found
         if (Ext.isEmpty(me.indexes)) {
             me.getSelectionModel().deselectAll();
         }

         // force textfield focus
         me.down('textfield[name=searchField]').focus();
     },
   
     /**
     * Finds all strings that matches the searched value in each grid cells.
     * @return {Number} The count to matches
     * @private
     */ 
	 _searchValue: function(view, idxRow) {
    	var me = this,
    		 idxCol = -1,
             count = 0,
             cellSelector = view.cellSelector,
             innerSelector = view.innerSelector;
        
        //var position = {row: idxRow, columns: []};     
        
    	var td = Ext.fly(view.getNode(idxRow)).down(cellSelector),
             cell, matches, cellHTML;
             
        while(td) {
        	 idxCol += 1;
        	 
             cell = td.down(innerSelector);	// div elem
             matches = cell.dom.innerHTML.match(me.tagsRe);
             cellHTML = cell.dom.innerHTML.replace(me.tagsRe, me.tagsProtect);
             
             // populate indexes array, set currentIndex, and replace wrap matched string in a span
             cellHTML = cellHTML.replace(me.searchRegExp, function(m) {
                count += 1;              
                
                var pos = new Ext.grid.CellContext(view).setPosition({row: idxRow, column: idxCol});//{row: idxRow, column: idxCol, view: view}; 
                
                
               // if (Ext.Array.indexOf(me.indexes, idxRow) === -1) {
                    me.indexes.push(pos);
                //}
                if (me.currentIndex === null) {	// when first found
                    me.currentIndex = pos;
                }
//                if (Ext.Array.indexOf(me.indexes, idxRow) === -1) {
//                	me.indexes.push(idxRow);
//                }
//                if (me.currentIndex === null) {
//                    me.currentIndex = idxRow;
//                }
                
                return '<span class="' + me.matchCls + '">' + m + '</span>';
             });
             // restore protected tags
             Ext.each(matches, function(match) {
                cellHTML = cellHTML.replace(me.tagsProtect, match); 
             });
             // update cell html
             cell.dom.innerHTML = cellHTML;
             td = td.next();
         }
         
         return count;
    },
    
    /**
     * Finds all strings that matches the searched value in store data.
     * @return {Number} The count to matches
     * @private
     */ 
	 _searchText: function(view, idxRow) {
    	var me = this,
    	    store = this.store,
            count = 0;
    	   tempCount = 0
    	var visibleColums = me.getVisibleColumns();
        store.each(function(record, rowId) {
        	Ext.each(visibleColums, function(column,idx) {
        		count += ((record.get(column.dataIndex)||'').toString().match(me.searchRegExp) || []).length;
        		if(count > tempCount )	{
        			var index = {
        					"columnIndex" : idx,
        					"dataIndex" : column.dataIndex,
        					"record" : record,
        					"rowIndex" : rowId
        			}
        			me.indexes.push(index);
        			tempCount = count;
        		}
        	});
        })
    	
         
         return count;
    },
    
    _setHighlite:function(view, idxRow)	{
    	var me = this,
		 idxCol = -1,
        cellSelector = view.cellSelector,
        innerSelector = view.innerSelector;
    	var tdDom = Ext.fly(view.getNode(idxRow));
        if(tdDom)	{
        	var td = Ext.fly(view.getNode(idxRow)).down(cellSelector),
	        	cell, matches, cellHTML;
	        
		   while(td) {
		   	 idxCol += 1;
		   	 
		        cell = td.down(innerSelector);	// div elem
		        matches = cell.dom.innerHTML.match(me.tagsRe);
		        cellHTML = cell.dom.innerHTML.replace(me.tagsRe, me.tagsProtect);
		
		        cellHTML = cellHTML.replace(me.searchRegExp, function(m) {
		                     
		           
		           var pos = new Ext.grid.CellContext(view).setPosition({row: idxRow, column: idxCol});//{row: idxRow, column: idxCol, view: view}; 
		           
		               //me.indexes.push(pos);
		
		           if (me.currentIndex === null) {	// when first found
		               me.currentIndex = { 
	            		   "columnIndex" : idxCol,  
        					"dataIndex" : pos.column.dataIndex,
        					"record" : pos.record,
        					"rowIndex" : idxRow
	        		   }
		           }
		
		           
		           return '<span class="' + me.matchCls + '">' + m + '</span>';
		        });
		        Ext.each(matches, function(match) {
		           cellHTML = cellHTML.replace(me.tagsProtect, match); 
		        });
		        // update cell html
		        cell.dom.innerHTML = cellHTML;
		        td = td.next();
		    }
        }
	    
    },
    
    /**
     * Selects the previous row containing a match.
     * @private
     */   
    onPreviousClick: function() {
        var me = this,
             idx;
 
    	 if(me.currentIndex){
	         Ext.Array.filter(me.indexes, function(row, index){
	        	 if(me.currentIndex.record.id == row.record.id && me.currentIndex.columnIndex == row.columnIndex )	{
	        		 idx = index;
	        	 }
	         });
    	 
	    	 var lastRowIndex = me.currentIndex.rowIndex;
	         me.currentIndex = me.indexes[idx - 1] || me.indexes[me.indexes.length - 1];
	         //me.getSelectionModel().select(me.currentIndex);
	         if(me.getSelectionModel().isCellModel) {
	      	 	me.getSelectionModel().select(me.currentIndex.record);
	      	 }else{
	      	 	me.getSelectionModel().select(me.currentIndex.record);
	      	 }
	         var navi = me.getView().getNavigationModel();
	         navi.setPosition(lastRowIndex, me.currentIndex.columnIndex); //bufferedRenderer.scrollTo 에서 column 위치를 못 찾으므로 해당 컬럼으로 미리 이동
	         navi.setPosition(me.currentIndex.rowIndex, me.currentIndex.columnIndex);
    	}
    },
    
    /**
     * Selects the next row containing a match.
     * @private
     */    
    onNextClick: function() {
    	var me = this,
             idx;
 
    	 if(me.currentIndex){
	         Ext.Array.filter(me.indexes, function(row, index){
	        	 if(me.currentIndex.record.id == row.record.id && me.currentIndex.columnIndex == row.columnIndex )	{
	        		 idx = index;
	        	 }
	         });
    	 
	    	 var lastRowIndex = me.currentIndex.rowIndex;
	         me.currentIndex = me.indexes[idx + 1] || me.indexes[0];
	         //me.getSelectionModel().select(me.currentIndex);
	         if(me.getSelectionModel().isCellModel) {
	      	 	me.getSelectionModel().select(me.currentIndex.record);
	      	 }else{
	      	 	me.getSelectionModel().select(me.currentIndex.record);
	      	 }
	         var navi = me.getView().getNavigationModel();
	         navi.setPosition(lastRowIndex, me.currentIndex.columnIndex); //bufferedRenderer.scrollTo 에서 column 위치를 못 찾으므로 해당 컬럼으로 미리 이동
	         navi.setPosition(me.currentIndex.rowIndex, me.currentIndex.columnIndex);
    	 }
    },
    
    /**
     * Switch to case sensitive mode.
     * @private
     */    
    caseSensitiveToggle: function(checkbox, checked) {
        this.caseSensitive = checked;
        this.onTextFieldChange();
    },
    
    /**
     * Switch to regular expression mode
     * @private
     */
    regExpToggle: function(checkbox, checked) {
        this.regExpMode = checked;
        this.onTextFieldChange();
    },
    onClearSearch:function()	{
    	var me = this;
    	me.searchValue= null;
        me.indexes = [];
        me.currentIndex = null;
        me.searchRegExp= null;
    },
    hideSearchBar : function()	{
    	var me = this;
    	if(me.uniSearchToolbar) {
			var wrapper = me.uniSearchToolbar.up('toolbar');
			if(wrapper && !wrapper.isHidden( )) {
        		me.onClearSearch();				
				wrapper.hide();
			}
		}
    }
});