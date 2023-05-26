//@charset UTF-8
// http://pastebin.com/aReGA9Vi
// JavaScript keycode : http://unixpapa.com/js/key.html 
// http://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes

var UNI_GRID_NEW_VAL="";
/*******************************************
 * UniAbstractGridPanel 
 */
Ext.define('Ext.overide.grid.NavigationModel', {
    override: 'Ext.grid.NavigationModel',	
    
    onKeyDown: function(keyEvent) {
        // If we are in the middle of an animated node expand, jump to next sibling.
        // The first child record is in a temp animation DIV and will be removed, so will blur.
        var newRecord = keyEvent.record.isExpandingOrCollapsing ? null : keyEvent.view.walkRecs(keyEvent.record, 1),
            pos = this.getPosition();

        if (newRecord) {
            pos.setRow(newRecord);

            // If no cell at the current column, move towards row start
            if (!pos.getCell(true)) {
                pos.navigate(-1);
            }
            this.setPosition(pos, null, keyEvent);
        }
    },
    
    processViewEvent: function(view, record, row, recordIndex, event) {
        var key = event.getKey();
		console.log("(key === event.TAB && event.shiftKey)", (key === event.TAB && event.shiftKey))
        console.log("(key === )", key)
        // In actionable mode, we only listen for TAB, F2 and ESC to exit actionable mode
        if (view.actionableMode && key !== event.ENTER) {
            this.map.ignoreInputFields = false;
            
            if (/*key === event.ENTER || */(key === event.TAB && event.shiftKey) || key === event.TAB || key === event.ESC || key === event.F2) {
                return event;
            }
        }
        // In navigation mode, we process all keys
        else {
            this.map.ignoreInputFields = true;

            // Ignore TAB key in navigable mode
            return ( (key === event.TAB && event.shiftKey)|| key === event.TAB /*|| key === event.ENTER*/)  ? null : event;
        }
    },
    
    onKeyEnter:function(keyEvent)	{
    	//this.onKeyTab(keyEvent);
    	var position = keyEvent.position,
            view = position.view;
    	if(view.ownerGrid.uniOpt.useNavigationModel)	{
    		this.onKeyRight(keyEvent);
    	}
    },
    
   onKeyRight: function(keyEvent) {
   		var position = keyEvent.position,
            view = position.view;
        
   		if(keyEvent.keyCode ==13 && view.store.uniOpt.editable && keyEvent.position.isLastColumn() && !keyEvent.position.column.isLocked() && view.ownerGrid.uniOpt.enterKeyCreateRow)	{
   			UniAppManager.app.onNewDataButtonDown();
   			return;
   		}else {
   		
	        var newPosition = this.move('right', keyEvent);
	
	        if (newPosition) {
	            this.setPosition(newPosition, null, keyEvent);
	        }/*else {
	        	var position = keyEvent.position.clone(),
	            view = position.view;
	        	if(view.ownerGrid.uniOpt.enterKeyCreateRow)	{
	        		if(UniAppManager.app) {
	        			UniAppManager.app.onNewDataButtonDown();
	        			newPosition = this.move('right', keyEvent);
	        			if (newPosition) {
				            this.setPosition(newPosition, null, keyEvent);
				        }
	        		}
	        	}
	        }*/
   		}
    },
    onKeyTab: function(keyEvent) {
        var forward = !keyEvent.shiftKey,
            position = keyEvent.position.clone(),
            view = position.view,
            cell = keyEvent.position.cellElement,
            tabbableChildren = Ext.fly(cell).findTabbableElements(),
            focusTarget,
            actionables = view.ownerGrid.actionables,
            len = actionables.length,
			plugin = view.ownerGrid.view.editingPlugin,
            i;
        // We control navigation when in actionable mode.
        // no TAB events must navigate.
        if(!view.ownerGrid.uniOpt.hasEnterKeyCreateRow)	{	// EnterKey로 행 추가 된경우 이 이벤트를 실행하지 않는다.
	        if(!keyEvent.position.column.isLocked() && keyEvent.position.isLastColumn())	{
	        	view.getSelectionModel().select(view.getStore().getAt(keyEvent.position.rowIdx+1));
	        }
	        if((keyEvent.position.isLastColumn() && keyEvent.position.rowIdx == (view.ownerGrid.getStore().getCount()-1)) && !keyEvent.position.column.isLocked() && plugin.getActiveEditor() && view.ownerGrid.uniOpt.enterKeyCreateRow)	{
	        	return;
	        }
	        
	        keyEvent.preventDefault();
	
	        // Find the next or previous tabbable in this cell.
	        focusTarget = tabbableChildren[Ext.Array.indexOf(tabbableChildren, keyEvent.target) + (forward ? 1 : -1)];
	
	        // If we are exiting the cell:
	        // Find next cell if possible, otherwise, we are exiting the row
	        while (!focusTarget && (cell = cell[forward ? 'nextSibling' : 'previousSibling'])) {
	
	            // Move position pointer to point to the new cell
	            position.setColumn(view.getHeaderByCell(cell));
	
	            // Inform all Actionables that we intend to activate this cell.
	            // If they are actionable, they will show/insert tabbable elements in this cell.
	            for (i = 0; i < len; i++) {
	                actionables[i].activateCell(position);
	            }
	            
	            // If there are now tabbable elements in this cell (entering a row restores tabbability)
	            // and Actionables also show/insert tabbables), then focus in the current direction.
	            if ((tabbableChildren = Ext.fly(cell).findTabbableElements()).length) {
	                focusTarget = tabbableChildren[forward ? 0 : tabbableChildren.length - 1];
	            }
	        }
	
	        // We found a focus target either in the cell or in a sibling cell in the direction of navigation.
	        if (focusTarget) {
	            // Keep actionPosition synched
	            this.actionPosition = position.view.actionPosition = position;
				
	            var targetColumn =Ext.fly(focusTarget)
	            targetColumn.focus();
	            
	            // input text 선택
				var targetField = targetColumn.el.dom.select();
				if(targetField) {
					targetField.focus(10);						
					setTimeout(function(){if(targetField.dom) targetField.dom.select() }, 1000);
				}
								
	            return;
	        }
	
	        // IE, which does not blur on removal from DOM of focused element must be kicked to blur the focused element
	        // which Actionables react to.
	        if (Ext.isIE) {
	            view.el.focus();
	        }
	        
	        // We need to exit the row
	        view.onRowExit(keyEvent.item, keyEvent.item[forward ? 'nextSibling' : 'previousSibling'], forward);
	        
        }else {
        	view.ownerGrid.uniOpt.hasEnterKeyCreateRow = false;
        }
    }
});

Ext.define('Ext.overide.grid.CellEditor', {
    override: 'Ext.grid.CellEditor',	
    
    onSpecialKey: function(field, event) {
    	
    	var me = this,
            key = event.getKey(),
            complete = me.completeOnEnter && key === event.ENTER,
            cancel = me.cancelOnEsc && key === event.ESC,
            view = me.editingPlugin.view;
            
		/*if( event.getKey() == 13 )	{
    		return;
    	}*/
        if (complete || cancel) {
            // Do not let the key event bubble into the NavigationModel after we're don processing it.
            // We control the navigation action here; we focus the cell.
            event.stopEvent();

            // Maintain visibility so that focus doesn't leak.
            // We need to direct focusback to the owning cell.
            if (complete) {
                me.completeEdit(true);
            } else if (cancel) {
                me.cancelEdit(true);
            }

            view.getNavigationModel().setPosition(me.context, null, event);
            view.ownerGrid.setActionableMode(false);
            
        }
    }
});

Ext.define('Ext.overide.grid.plugin.Editing', {
    override: 'Ext.grid.plugin.Editing',
	onCellClick: function(view, cell, colIdx, record, row, rowIdx, e) {
        // Make sure that the column has an editor.  In the case of CheckboxModel,
        // calling startEdit doesn't make sense when the checkbox is clicked.
        // Also, cancel editing if the element that was clicked was a tree expander.
        var expanderSelector = view.expanderSelector,
        // Use getColumnManager() in this context because colIdx includes hidden columns.
            columnHeader = view.ownerCt.getColumnManager().getHeaderAtIndex(colIdx),
            editor = columnHeader.getEditor(record);
		if(view && view.ownerGrid.uniOpt && !view.ownerGrid.uniOpt.dblClickToEdit)	{
			return;	
		}
        if (editor && this.shouldStartEdit(editor) && (!expanderSelector || !e.getTarget(expanderSelector))) {
            view.ownerGrid.setActionableMode(true, e.position);
        }
        if(editor && editor.el){
	  	    // input text 선택
			var targetField = editor.el.down('.x-form-field');
			if(targetField) {
				targetField.focus(10);						
				setTimeout(function(){if(targetField.dom && Ext.isFunction(targetField.dom.select))targetField.dom.select(); }, 100);
			}
        }
		
    }
}),

Ext.define('Unilite.com.grid.UniAbstractGridPanel', {
	getEditor: function(me) {
		var editing = Ext.create('Ext.grid.plugin.CellEditing', {
						//clicksToMoveEditor: 1,
						ptype: 'cellediting',
						clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
						autoCancel : false,
						selectOnFocus:true,
						listeners: {
							beforeedit: function(editor, e, eOpts) {
								if(!me._getStoreEditable(me))	return false;
								if(Ext.getBody().isMasked())	{
									return false;
								}
								me.uniOpt.currentRecord = e.record;
								if( (e.column.uniOPT && e.column.uniOPT.isPk ) || (e.column.isLink) ) {
									if( e.record.phantom) {
										return true;
									} else {
										//UniApp.updateStatus( '추가건만 수정이 가능합니다.');
										return false;
									}
								}else {
									var targetField = editor.view.el.down('.x-form-field');
									if(targetField) {
										targetField.focus(10);						
										setTimeout(function(){if(Ext.isFunction(targetField.dom.select)) targetField.dom.select() }, 1000);
									}
									
								}
								
								return true;
							},
							specialkey:function( ed, field, event, eOpts )	{
								var key = event.event.keyCode;
								var me = this;
								if( key == event.TAB || key == event.ENTER )	{
									event.stopEvent();
									if (ed) {
						                ed.onEditorTab(e);
						                var view = ed.editingPlugin.context.view,
						            			grid = ed.editingPlugin.context.grid,
									            position = ed.editingPlugin.context,
									            direction = e.shiftKey ? 'left' : 'right',
									            navi = view.getNavigationModel();
						            	
						        	}
						        	if(event.getKey() === event.TAB){
						        		var navi = me.view.getNavigationModel();
					            		navi.fireNavigateEvent(event);
					            	}
									
								}
								console.log("specialkey : "+event.getKey(), event.shiftKey);
							}
						}
			});
		return editing;
	}, // getEditor
	// private
	setColumnInfo: function( me, col, fields) {
		if(! Ext.isDefined(col)) {
			console.error( "column is undefined !!! - ",col);
			return false;
		}

		// 기본 속성 등록
		Ext.applyIf(col, me.columnDefaults);
		
		//locking grid 의 경우 layout:fit으로 주면 5.1/6.0에서 summary 가 제대로 안보임.
		//locking grid 는 기본 hbox 를 사용하는데, hbox로 변경하면 오류. borde 로  강제 설정
		//locking grid 의 경우 application 에서 layout 을 지정하지 않는 것이 가장 좋음.
		if(col.locked || col.lockable) {
			if(me.layout && me.layout === 'fit') {
				Ext.apply(me, {layout: 'border'});
				Ext.apply(me.config, {layout: 'border'});
			}
		}
		
		if( col.isLink == true ) {
			Ext.applyIf(col, {'tdCls': 'GRID_COL_HREF'});
		}
		// 모델을 참조
		if(col.dataIndex) {
			var field = this._getField(fields, col.dataIndex);
			if (Ext.isDefined(field)) {
				var isFieldEditable = Unilite.nvl(field['editable'], true);
				//var colEditable  = Unilite.nvl(col,editable, true);
				var columnEditable = false;
				var lAllowBlank = Unilite.nvl(field['allowBlank'],true);
				//console.log(field['text'], editable, lAllowBlank);
				// 1.헤더명칭 등록(Model참조)
				var text = field['text'];
				if (!text) {
					text = col.dataIndex;
				}
				if( field.isPk) {
					Ext.applyIf(col, {uniOPT:{} });
					Ext.applyIf(col.uniOPT, {	'isPk' : field.isPk	});
				}
				//Ext.applyIf(col, {	'text' : text	});
				// mouse cursor 설정 
				var storeEditable = this._getStoreEditable(me);
				if(storeEditable && isFieldEditable && Unilite.nvl(col.editable, true)) {

					if(lAllowBlank == false) {
						text = "<span style='color:#f00 !important;font-weight:bold'>*</span>" + text;
					}
					columnEditable = true;
					Ext.applyIf(col, {'tdCls': 'GRID_COL_EDITABLE'});
				}
				Ext.applyIf(col, {	'text' : text	});
				if(  Ext.isDefined(col.editor)) {
					columnEditable = false;
				}
				// 타입 설정
				var fieldType = field['type'];
				var fieldFormat = field['format'];
				
				if(fieldType ) {
					
					//var t = fieldType.type;	//4.2.2 uniTypes 를 사용하는 경우
					var t = fieldType;			//5.0.1
					var editListeners = {};
					var editorConfing = {
						'allowBlank' : lAllowBlank
					};
					if(field.minLength) {
						Ext.applyIf(editorConfing, {'minLength': field.minLength });
					}
					if(field.maxLength) {
						Ext.applyIf(editorConfing, {'maxLength': field.maxLength, 'enforceMaxLength': field.maxLength });
					}
					if(field.minValue) {
						Ext.applyIf(editorConfing, {'minValue': field.minValue });
					}
					if(field.maxValue) {
						Ext.applyIf(editorConfing, {'maxValue': field.maxValue });
					}
					/*
					 * maxLength 와 함께 셋팅
					 * if(field.enforceMaxLength) {
						Ext.apply(editorConfing, {'enforceMaxLength': field.enforceMaxLength})
					}*/
					
					//minLength / MaxLength
					//console.log(col.dataIndex, "TYPE", t, "-",fieldType, fieldFormat, lAllowBlank)
					if( t ==  'string') {
						Ext.applyIf(col, {align: 'left' });
						Ext.applyIf(editorConfing, {xtype : 'textfield' });
					} else if( t ==  'number') {
						Ext.applyIf(col, {align: 'right' , xtype:'numbercolumn' });
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' });
					} else  if( t ==  'int' || t ==  'integer') {
						Ext.applyIf(col, {align: 'right', xtype:'numbercolumn' , format:'0,000'});
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' });
					} else if( t ==  'float') {
						Ext.applyIf(col, {align: 'right', xtype:'numbercolumn'  ,format:field.format});
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' , decimalPrecision:field.decimalPrecision});						
					} else  if( t ==  'uniNumber') {
						Ext.applyIf(col, {align: 'right', xtype:'numbercolumn' , format:''});
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' });
					}  else if( t ==  'bool' || t == 'boolean') {
						Ext.applyIf(col, {
									xtype: 'booleancolumn',
									trueText: 'Yes',
    								falseText: 'No'});
						Ext.applyIf(col, {align: 'center' });
						Ext.applyIf(editorConfing, {xtype : 'checkboxfield' });
						
					} else if( t ==  'date' || t ==  'uniDate') {
						Ext.applyIf(col, {align: 'center', xtype: 'uniDateColumn' });
						//Ext.applyIf(col, {format: Unilite.dateFormat });
						
						// 날자 Editor 설정 
						Ext.applyIf(editorConfing, {
							xtype : 'uniDatefield',
						    format: Unilite.dateFormat 
						 });
					} else if(t ==  'uniQty') {
						var deP = UniFormat.Qty.indexOf('.') > -1 ? UniFormat.Qty.length-1 - UniFormat.Qty.indexOf('.') : 0;
						Ext.applyIf(col, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Qty });
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' , decimalPrecision: deP, maxLength:deP==0? 39:46, enforceMaxLength: deP==0? 39:46});						
					} else if(t ==  'uniPrice') {
						var deP = UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0;
						Ext.applyIf(col, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price });
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' , decimalPrecision: deP , maxLength:deP==0? 39:46, enforceMaxLength: deP==0? 39:46});						
					} else if(t ==  'uniUnitPrice') {
						var deP = UniFormat.UnitPrice.indexOf('.') > -1 ? UniFormat.UnitPrice.length-1 - UniFormat.UnitPrice.indexOf('.') : 0;
						Ext.applyIf(col, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.UnitPrice });
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' , decimalPrecision: deP , maxLength:deP==0? 39:46, enforceMaxLength: deP==0? 39:46});
					} else if(t ==  'uniPercent') {
						var deP = UniFormat.Percent.indexOf('.') > -1 ? UniFormat.Percent.length-1 - UniFormat.Percent.indexOf('.') : 0;
						Ext.applyIf(col, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Percent });
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' , decimalPrecision: deP , maxLength:deP==0? 39:46, enforceMaxLength: deP==0? 39:46});
					} else if(t ==  'uniFC') {
						var deP = UniFormat.FC.indexOf('.') > -1 ? UniFormat.FC.length-1 - UniFormat.FC.indexOf('.') : 0;
						Ext.applyIf(col, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.FC });
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' , decimalPrecision: deP, maxLength:deP==0? 39:46, enforceMaxLength: deP==0? 39:46});
					} else if(t ==  'uniER') {
						var deP = UniFormat.ER.indexOf('.') > -1 ? UniFormat.ER.length-1 - UniFormat.ER.indexOf('.') : 0;
						Ext.applyIf(col, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.ER });
						Ext.applyIf(editorConfing, {xtype : 'uniNumberfield' , decimalPrecision: deP , maxLength:deP==0? 39:46, enforceMaxLength: deP==0? 39:46});
					} else if(t ==  'uniTime') {
						if(field.format) {
							if(field.format == 'His') {
								Ext.applyIf(col, {align: 'center' , 
									xtype:'uniTimeColumn', 
									format:'H:i:s' });
								Ext.applyIf(editorConfing, {
									xtype : 'uniTimefield',
									hideTrigger: true,
									autoSelect: false,
									increment: 1,
									format : "H:i:s",
									altFormats :'H|H:i|Hi|H:i:s|His',	
	    							submitFormat:'His'
	    							
								});
							}
						} else {
							Ext.applyIf(col, {align: 'center' , xtype:'uniTimeColumn' });
							Ext.applyIf(editorConfing, {xtype : 'uniTimefield'});
						}
					} else if(t ==  'uniYear') {
						Ext.applyIf(col, {align: 'right' , xtype:'string' });
						Ext.applyIf(editorConfing, {xtype : 'textfield' });
					} else if(t ==  'uniPassword') {
						Ext.applyIf(col, {'renderer' : function(val) { 
							if(Ext.isEmpty(val)) {
								return '';
							}else{
								return '********';
							}
						}});
						Ext.applyIf(editorConfing, {inputType :'password' });
					}
					
					if(columnEditable){
						Ext.applyIf(col, {'editor' : editorConfing});
					}
					
					//filter 설정
					if(Ext.isDefined(me.uniOpt.filter) && me.uniOpt.filter.useFilter && me.uniOpt.filter.autoCreate) {
						Ext.applyIf(col, {filter: me.getColumnFilterType( fieldType) });
					}
					
				} // type && editor && filter (AUTO)
				
				/*
				if(fieldFormat )  {
					if(fieldFormat == 'price') {
						Ext.apply(col, {align: 'right' , xtype:'uniPriceColumn' });
					}
				}
				
				*/
				// 콤보 설정(code) comboType:'AU', comboCode:'CB23' 
				var isCombo = false;
				if(field.comboType) {	
					var combo = Unilite.form.createCombobox(field); // Unilite.js
					if(col.renderer)	{
						Ext.apply(col, {renderer:  Unilite.grid.comboRenderer(combo, col.renderer) });
					}else {
						Ext.apply(col, {renderer:  Unilite.grid.comboRenderer(combo) });
					}
					if(columnEditable) {
						Ext.apply(col, {editor:  combo });
					}
					isCombo = true;
				} else if(field.store) {
					var combo = Unilite.form.createCombobox(field);
					if(col.renderer)	{
						Ext.apply(col, {renderer:  Unilite.grid.comboRenderer(combo, col.renderer) });
					}else {
						Ext.apply(col, {renderer:  Unilite.grid.comboRenderer(combo) });
					}
					if(columnEditable) {
						Ext.apply(col, {editor:  combo });
					}
					
					isCombo = true;
				}
				
				if(isCombo) {
					Ext.apply(col, {doSort:  function(state) {
							console.log("do custom Sort for combobox");
							var ds = this.up('grid').getStore();
			                var field = this.getSortParam();
			                var colx = col; //col.renderer;
			                ds.sort({
			                    property: field,
			                    direction: state,
			                    transform: function(val) {
			                    	var t = colx.renderer(val);
			                    	if (t == undefined ) {
			                    		t = "";
			                    	}
			                    	//console.log( "transfer : " + val + " => " + t);
			                    	return t
			                    }

			                });
						}						
					}); //Ext.apply					
				} // if
			}
		} // col.dateindex
		
		
		if(col.tooltip) {
			Ext.applyIf(col, {renderer :function(value, metadata,record) { metadata.tdAttr = 'data-qtip="' + value + '"'; return value; } });
		}
		// column merge 처리용
		if(Ext.isArray(col.columns)) {
			//console.log(col.columns);
			for (var i = 0, len = col.columns.length; i < len; i++) {
				this.setColumnInfo(me, col.columns[i], fields );
			}
		}
		
	},
	    // grid의 store가 수정 가능한지 확인 
	_getStoreEditable : function(grid) {
		var storeEditable = false;
		if(grid.store.uniOpt) {
			if( grid.store.uniOpt.editable ) {
				storeEditable = true;
			}
		}
		return storeEditable;
	},
		// private
	_getField : function(fields, id) {
		var srchField;
		if (fields) {

			for (var i = 0, len = fields.length; i < len; i++) {
				var field = fields[i];
				if (field['name'] == id) {
					srchField = field;
					break;
				}
			}
		}
		return srchField;
	},
	/**
	 * 새로운 행을 추가 하고 편집을 시작 한다.
	 * @param {} record
	 * @param {} startEditColumnName
	 * @param {} rowIndex
	 * @return {}
	 */
	createRow:function(grid, values, startEditColumnName, rowIndex, newRecord) {
		
		//현재행 다음줄 부터
		if(!rowIndex && rowIndex != 0)  {
			rowIndex = grid.getSelectedRowIndex();
		}else if(rowIndex >= grid.getStore().getCount())  {
			rowIndex = grid.getSelectedRowIndex();
		}		
		rowIndex = (rowIndex < 0)? 0 : rowIndex +1;
		console.log("rowIndex = " ,rowIndex );
		
		if(!newRecord) {
			//update cls 표시되게 하기 위해 행 추가 후 값 setting
			//newRecord =  Ext.create (grid.store.model, values);
			newRecord =  Ext.create (grid.store.model);
			if(values)	{
				Ext.each(Object.keys(values), function(key, idx){
					newRecord.set(key, values[key]);
				});
			}
		}
		
		newRecord.phantom = true;
		console.log("newRowIndex 1= " ,rowIndex );
		//newRecord = grid.store.insert(rowIndex, newRecord);
		grid.store.insert(rowIndex, newRecord);
		//console.log("newRowIndex 2= " ,rowIndex );
		if(grid.getSelectionModel().isCellModel) {
			
		}else{
			//grid.getSelectionModel().select(rowIndex);
			//grid.select(rowIndex);
			grid.selectById(newRecord.getId());
		}
		
		var columnIndex = 0;
		var columns = grid.getVisibleColumns();
		if(startEditColumnName)	{
			Ext.each(columns, function(column, idx) {
				if(column.dataIndex && column.dataIndex == startEditColumnName)	{
					columnIndex = idx;
				}
			});
			if(columns && columns[0].xtype == "rownumberer" )	{
				//columnIndex = columnIndex-1
			}
		}
		var view = grid.getView() ;
		if(view.lockedView)	{
			view = view.lockedView	
		}
		
		if(Ext.isFunction(view.getNavigationModel) && view.getNavigationModel())	{
			var navi = view.getNavigationModel();
			navi.setPosition(rowIndex, columnIndex);
			//view.scrollTo(0, navi.getPosition().getCell().getY());
			/*navi.fireEvent('cellkeydown', function(){
			
			})
			*/
			//var newPosition = navi.move('right', navi.getPosition().getCell().getX());
			//navi.setPosition(newPosition);   
        }
		/*if(startEditColumnName)	{
			if(grid.editingPlugin)	{
				var columns = grid.getColumns();
				var columnIndex;
				Ext.each(columns, function(column, idx) {
					if(column.dataIndex && column.dataIndex == startEditColumnName)	{
						columnIndex = idx;
					}
				});
				if(columnIndex)	{
					grid.editingPlugin.startEditByPosition({row: rowIndex,column: columnIndex});  
					//grid.getEditor().completeEdit();
				}
				//grid.editingPlugin.startEditByPosition(newRecord,grid.getColumn(startEditColumnName));  
			}
		}else {
			var view = grid.getView() ;
			if(view.lockedView)	{
				view = view.lockedView	
			}
			if(Ext.isFunction(view.getNavigationModel) && view.getNavigationModel())	{
	       	 	view.getNavigationModel().setPosition(rowIndex, 0);
	       	 	
	        }
		}*/
		
		/*else {
			var view = grid.getView() ;
			var lockedView;
			if(view.lockedView)	{
				lockedView = view.lockedView;
				view = view.normalView;	
			}
			
			if(view)	{
				view.refresh();	
				if (view.getScrollable() && view.bufferedRenderer) {
		            view.scrollTo(0, view.bufferedRenderer.getScrollHeight(), grid.uniOpt.animatedScroll);
		            view.refresh();
					
		        }else {
		        	//view.refresh();
		        	if (view.getScrollable())	{
		        		view.scrollTo(0, view.getScrollY(), grid.uniOpt.animatedScroll);
		        		view.refresh();
		        	}
		        }
		        if(Ext.isFunction(view.getNavigationModel) && view.getNavigationModel() && grid.uniOpt.animatedScroll)	{
		       	 	view.getNavigationModel().setPosition(rowIndex, 0);
		       	 	
		        }
		        
			}
			
		
		}*/
		
		return newRecord;
	},	

	/**
	 * 현재 선택된 행에서 수정모드로 진입.
	 * @param {} columnName
	 */
	startEdit: function(grid, columnName, val) {
		var me = grid, column = 0, edit;
		if( typeof columnName == "string") {
			column = me.getColumn(columnName);
		} else if ( typeof columnName == "number") {
			column = columnName;
		}
		if(this._getStoreEditable(me)) {
			var edit = this.getEditing(grid);
			var vrow = this.getSelectedRecord(grid);
			edit.startEditByPosition({
	            row: vrow,
	            column: column
	        });
		}
		
	},
	/**
	 * 
	 * @return {}
	 */
	getEditing:function(grid) {
		return grid.editing;
	},
	
	getSelectedRecords: function(grid) {
		return grid.getSelectionModel().getSelection();
	},
	getSelectedRecord:function(grid) {
		var selectedRecords = this.getSelectedRecords(grid);
		if(selectedRecords && selectedRecords.length > 0 ) {
			return selectedRecords[0];
		}		
	},
	getColumnFilterType: function(t) {
		var filterType = '';
		if( t ==  'string') {
			filterType = 'string';
		} else if( t ==  'number') {
			filterType = 'numeric';
		} else  if( t ==  'int' || t ==  'integer') {
			filterType = 'numeric';
		} else if( t ==  'float') {
			filterType = 'numeric';	
		} else if( t ==  'bool' || t == 'boolean') {
			filterType = 'uniList';
			
		} else if( t ==  'date' || t ==  'uniDate') {
			filterType = 'date';
		} else if(t ==  'uniQty') {
			filterType = 'numeric';					
		} else if(t ==  'uniPrice') {
			filterType = 'numeric';					
		} else if(t ==  'uniUnitPrice') {
			filterType = 'numeric';
		} else if(t ==  'uniPercent') {
			filterType = 'numeric';
		} else if(t ==  'uniFC') {
			filterType = 'numeric';
		} else if(t ==  'uniER') {
			filterType = 'numeric';
		} else if(t ==  'uniTime') {
			filterType = 'string';
		} else if(t ==  'uniYear') {
			filterType = 'string';
		} else {
			filterType = 'string';
		}
		
		return filterType;
	}
});  // UniAbstractGridPanel
