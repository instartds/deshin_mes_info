Ext.override(Ext.selection.CellModel, {
	setCurrentPosition: function(pos, suppressEvent, /* private */ preventCheck) {
        var me = this,
            last = me.selection,
            view;

        // onSelectChange uses lastSelection and nextSelection
        me.lastSelection = last;

        // Normalize it into an Ext.grid.CellContext if necessary
         //pos = pos.isCellContext ? pos : new Ext.grid.CellContext(me.primaryView).setPosition(pos);
        if (pos) {
        	if(pos.view) {
        		view = pos.view;
        	} else {
        		view = me.primaryView
        	}           
        	pos = pos.isCellContext ? pos : new Ext.grid.CellContext(view).setPosition(pos);
        }
        if (!preventCheck && last) {
            // If the position is the same, jump out & don't fire the event
        	// record 가 같아도 cellmode 에서 cell 이동이 가능하도록 pos 를 null로 처리하지 않는다.
//            if (pos && (pos.record === last.record && pos.columnHeader === last.columnHeader && pos.view === last.view)) {
//                pos = null;
//            } else {
                me.onCellDeselect(me.selection, suppressEvent);
//            }
        }

        if (pos) {
            me.nextSelection = pos;
            // set this flag here so we know to use nextSelection
            // if the node is updated during a select
            me.selecting = true;
            me.onCellSelect(me.nextSelection, suppressEvent);
            me.selecting = false;
            // Deselect triggered by new selection will kill the selection property, so restore it here.
            return (me.selection = pos);
        }
        // <debug>
        // Enforce code correctness in unbuilt source.
        return null;
        // </debug>
    },
    onViewRefresh: function(view) {
        var me = this,
            pos = me.getCurrentPosition(),
            newPos,
            headerCt = view.headerCt,
            record, columnHeader;

        // Re-establish selection of the same cell coordinate.
        // DO NOT fire events because the selected 
        if (pos && pos.view === view) {
            record = pos.record;
            columnHeader = pos.columnHeader;

            // After a refresh, recreate the selection using the same record and grid column as before
            if (columnHeader && !columnHeader.isDescendantOf(headerCt)) {
                // column header is not a child of the header container
                // this happens when the grid is reconfigured with new columns
                // make a best effor to select something by matching on id, then text, then dataIndex
                columnHeader = headerCt.queryById(columnHeader.id) || 
                               headerCt.down('[text="' + columnHeader.text + '"]') ||
                               headerCt.down('[dataIndex="' + columnHeader.dataIndex + '"]');
            }

            // If we have a columnHeader (either the column header that already exists in
            // the headerCt, or a suitable match that was found after reconfiguration)
            // AND the record still exists in the store (or a record matching the id of
            // the previously selected record) We are ok to go ahead and set the selection
            if (pos.record) {
                if (columnHeader && (view.store.indexOfId(record.getId()) !== -1)) {
                    newPos = new Ext.grid.CellContext(view).setPosition({
                        row: record,
                        column: columnHeader
                    });
                    me.setCurrentPosition(newPos);
                }
            } else {
                me.selection = null;
            }
        }
    }
});

Ext.override(Ext.view.Table, {
	getCellByPosition: function(position, returnDom) {
        if (position) {
            var row   = this.getNode(position.row, true);
            
            header = this.ownerCt.getColumnManager().getHeaderAtIndex(position.column);
            
            /*
            var columns  = this.ownerCt.getColumnManager().getColumns();            
            //position 의 위치값을 렌더링된 dom에서 추출했기 때무네 visible 컬럼만 비교
            var visibleColumns = [];
             Ext.Array.each(columns, function(col, index) {
	        	if(col.isVisible())
	        		visibleColumns.push(col);
	    	});
	    	
	    	header = visibleColumns[position.column] || null; */               
            

            if (header && row) {
                return Ext.fly(row).down(this.getCellSelector(header), returnDom);
            }
        }
        return false;
    }
});

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
             
             me.store.each(function(record, idx) {
             	var node = Ext.fly(me.view.getNode(idx));	// view 안의 row
             	             	
             	if( !Ext.isEmpty(node)) {
             		if(me.lockedGrid ) {
             			count += me._searchValue(me.lockedGrid.getView(), idx);
             			count += me._searchValue(me.normalGrid.getView(), idx);
             		} else {
		        		count += me._searchValue(me.getView(), idx);
             		}
             	}
             }, me);

             // results found
             if (me.currentIndex !== null) {                 
             	 if(me.getSelectionModel().isCellModel) {
             	 	me.getSelectionModel().select(me.currentIndex);
             	 }else{
             	 	me.getSelectionModel().select(me.currentIndex.row);
             	 }
             	 
                 me.down('tbtext[itemId="searchStatus"]').setText(count + ' matche(s) found.');
             }
         }

         // no results found
         if (me.currentIndex === null) {
             me.getSelectionModel().deselectAll();
         }

         // force textfield focus
         me.down('textfield[name=searchField]').focus();
     },
    /*onTextFieldChange: function() {
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
             
             
             me.store.each(function(record, idx) {
             	var node = Ext.fly(me.view.getNode(idx));
             	if( !Ext.isEmpty(node)) {
	                 var td = Ext.fly(me.view.getNode(idx)).down('td'),
	                     cell, matches, cellHTML;
	                 while(td) {
	                     cell = td.down('.x-grid-cell-inner');
	                     matches = cell.dom.innerHTML.match(me.tagsRe);
	                     cellHTML = cell.dom.innerHTML.replace(me.tagsRe, me.tagsProtect);
	                     
	                     // populate indexes array, set currentIndex, and replace wrap matched string in a span
	                     cellHTML = cellHTML.replace(me.searchRegExp, function(m) {
	                        count += 1;
	                        if (Ext.Array.indexOf(me.indexes, idx) === -1) {
	                            me.indexes.push(idx);
	                        }
	                        if (me.currentIndex === null) {
	                            me.currentIndex = idx;
	                        }
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
             	}
             }, me);

             // results found
             if (me.currentIndex !== null) {
                 me.getSelectionModel().select(me.currentIndex);
                 me.down('tbtext[itemId="searchStatus"]').setText(count + ' matche(s) found.');
             }
         }

         // no results found
         if (me.currentIndex === null) {
             me.getSelectionModel().deselectAll();
         }

         // force textfield focus
         me.down('textfield[name=searchField]').focus();
     },*/
     /**
     * Finds all strings that matches the searched value in each grid cells.
     * @return {Number} The count to matches
     * @private
     */ 
	 _searchValue: function(view, idxRow) {
    	var me = this,
    		 idxCol = -1,
             count = 0;
        
        //var position = {row: idxRow, columns: []};     
        
    	var td = Ext.fly(view.getNode(idxRow)).down('.x-grid-cell'),
             cell, matches, cellHTML;
             
        while(td) {
        	 idxCol += 1;
        	 
             cell = td.down('.x-grid-cell-inner');	// div elem
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
     * Selects the previous row containing a match.
     * @private
     */   
    onPreviousClick: function() {
        var me = this,
            idxRow = -1;
        var selModel = me.getSelectionModel();
        
        var pos = new Ext.grid.CellContext(me.currentIndex.view).setPosition({row: me.currentIndex.row, column: me.currentIndex.column});
        
        Ext.Array.each(me.indexes, function(object, index) {
        	if(object.row == pos.row && object.column == pos.column)
        		idxRow = index;
    	});

    	if ((idxRow ) !== -1) {                        
            pos.row 		= (idxRow == 0 ? me.indexes[me.indexes.length - 1].row : me.indexes[idxRow - 1].row);
    		pos.column 		= (idxRow == 0 ? me.indexes[me.indexes.length - 1].column : me.indexes[idxRow - 1].column);
    		pos.view 		= (idxRow == 0 ? me.indexes[me.indexes.length - 1].view : me.indexes[idxRow - 1].view);
    		pos 			= new Ext.grid.CellContext(pos.view).setPosition({row: pos.row, column: pos.column});
    		me.currentIndex = pos;  
    		
        	if(selModel.isCellModel) {
	            selModel.select(me.currentIndex);
        	} else {
        		selModel.select(me.currentIndex.row);
        	}
         }
    },
    
    /**
     * Selects the next row containing a match.
     * @private
     */    
    onNextClick: function() {
        var me = this,
            idxRow = -1;
        var selModel = me.getSelectionModel();
            
        var pos = new Ext.grid.CellContext(me.currentIndex.view).setPosition({row: me.currentIndex.row, column: me.currentIndex.column});   
        
        Ext.Array.each(me.indexes, function(object, index) {
         	if(selModel.isCellModel) {
        		if(object.row == pos.row && object.column == pos.column) idxRow = index;
         	}else{
         		if(object.row == pos.row) idxRow = index;
         	}
    	});
        
        if ((idxRow ) !== -1) {
           	pos.row 		= (idxRow == (me.indexes.length - 1) ? me.indexes[0].row : me.indexes[idxRow + 1].row) ;
    		pos.column 		= (idxRow == (me.indexes.length - 1) ? me.indexes[0].column : me.indexes[idxRow + 1].column) ;
    		pos.view 		= (idxRow == (me.indexes.length - 1) ? me.indexes[0].view : me.indexes[idxRow + 1].view) ;
    		pos 			= new Ext.grid.CellContext(pos.view).setPosition({row: pos.row, column: pos.column});
    		me.currentIndex = pos;
        	
        	if(selModel.isCellModel) {       		
	            selModel.select(me.currentIndex);
        	} else {
        		selModel.select(me.currentIndex.row);
        	}
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
    }
});