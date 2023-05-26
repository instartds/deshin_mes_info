<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb551skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb555skr" /> 	<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A003"  /> 		<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> 		<!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매입일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매출일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 부가세조정입력구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" />			<!-- 수지구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" />			<!-- 금액단위 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var getStDt = ${getStDt};
	var budgNameList = ${budgNameList};
	var amtPointList = ${amtPointList};
	var fields	= createMasterModelField(budgNameList);
	var gridModelfields	= createModelField(budgNameList);
	var gridSubModelfields	= createSubModelField(budgNameList);
	var columns	= createGridColumn(budgNameList);
	
	Unilite.defineModel('Afb555Model1', {
		fields: fields
	});		// End of Ext.define('afb555skrModel', {
	
	
	Unilite.defineModel('Afb555GridModel', {
		fields: gridModelfields,
    	associations:[{
        	type: 'hasMany',                    
            model: 'Afb555SubGridModel', 
            name : 'sub'
        }]	
	});
	  
	Unilite.defineModel('Afb555SubGridModel', {
		fields: gridSubModelfields
	});
	/* Store 정의(Service 정의) @type
	 */					
	var MasterStore = Unilite.createStore('Afb555MasterStore',{
		model: 'Afb555Model1',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'afb555skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			param.budgNameInfoList = budgNameList;	//예산목록	
			param.amtPointInfoList = amtPointList;		//amtPoint	
			console.log( param );
			Ext.getBody().mask('Loading');
			this.load({
				params : param,
				callback:function()	{
					Ext.getBody().unmask();
				}
			});
		},
		//groupField: 'BUDG_CODE'
		listeners:{
			load:function(store, records, successful, operation, eOpts )	{
				if(successful)	{
					var gStore = Ext.StoreManager.lookup('Afb555MasterGroupStore');
					
					var gStoreDataArr = new Array();
					
					Ext.each(records, function(record, idx){
						var chk = true;
						if(idx < (records.length-1))	{
							if(records[idx+1].data['BUDG_CODE'] != record.data['BUDG_CODE'])	{
								chk = false;
							}
							Ext.each(budgNameList, function(budgName, i){
								if(records[idx+1].data['BUDG_NAME_'+(i+1)] != record.data['BUDG_NAME_'+(i+1)])	{
									chk = false;
								}
							})
							
							if(!chk) {
								gStoreDataArr.push(record.data);
							}
						} /*else if(idx < (records.length-1)) 	{
							gStoreDataArr.push(record.data);
						}*/
					});
					
					gStore.loadData(gStoreDataArr)
				}else {
					gStore.loadData({});
				}
			}
		}
		
	});
	
	var masterGroupStore = Unilite.createStore('Afb555MasterGroupStore',{
		model: 'Afb555GridModel',
		listeners:{
			datachanged:function(store)	{
				var expander = masterGrid.getPlugin('subtable');
				
				for(var i=0; i < store.getCount() ; i++)	{
					//expander.toggleRow(i, store.getAt(i));
				}
			}
		}
	});
	
	
	var masterSubStore = Unilite.createStore('Afb555MasterSubStore',{
		model: 'Afb555SubGridModel'
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
    	width: 380,
        defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '기본정보', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{ 
		        	fieldLabel: '기안(추산)년월',
					xtype: 'uniMonthRangefield',  
					startFieldName: 'FR_MONTH',
					endFieldName: 'TO_MONTH',
					allowBlank:false,
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FR_MONTH',newValue);			
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('TO_MONTH',newValue);			    		
				    	}
				    }
				},
		        Unilite.popup('DEPT',{
				        fieldLabel: '부서',
					    valueFieldName:'DEPT_CODE',
					    textFieldName:'DEPT_NAME',
				        //validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
									panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('DEPT_CODE', '');
								panelResult.setValue('DEPT_CODE', '');
								panelSearch.setValue('DEPT_NAME', '');
								panelSearch.setValue('DEPT_NAME', '');
							}
						}
			    }),{
		    		xtype: 'uniCheckboxgroup',	
		    		//padding: '0 0 0 0',
		    		fieldLabel: ' ',
		    		items: [{
		    			boxLabel: '하위부서포함',
		    			width: 130,
		    			name: 'LOWER_DEPT',
			        	inputValue: 'Y',
						uncheckedValue: 'N',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('LOWER_DEPT', newValue);
							}
						}
		    		}]
		        },
		        Unilite.popup('AC_PROJECT',{
				        fieldLabel: '프로젝트',
					    valueFieldName:'AC_PROJECT_CODE',
					    textFieldName:'AC_PROJECT_NAME',
				        //validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('AC_PROJECT_CODE', panelSearch.getValue('AC_PROJECT_CODE'));
									panelResult.setValue('AC_PROJECT_NAME', panelSearch.getValue('AC_PROJECT_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('AC_PROJECT_CODE', '');
								panelResult.setValue('AC_PROJECT_CODE', '');
								panelSearch.setValue('AC_PROJECT_NAME', '');
								panelSearch.setValue('AC_PROJECT_NAME', '');
							}
						}
			    }),
	        	 Unilite.popup('BUDG',{
				        fieldLabel: '예산과목',
					    valueFieldName:'BUDG_CODE',
					    textFieldName:'BUDG_NAME',
				        //validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
									panelSearch.setValue('BUDG_NAME', records[0][name]);	
									panelResult.setValue('BUDG_CODE', panelSearch.getValue('BUDG_CODE'));
									panelResult.setValue('BUDG_NAME', panelSearch.getValue('BUDG_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('BUDG_CODE', '');
								panelResult.setValue('BUDG_NAME', '');
								panelSearch.setValue('BUDG_CODE', '');
								panelSearch.setValue('BUDG_NAME', '');
							}
						}
				    })
				]	
			},{
				title: '추가정보',	
		   		itemId: 'search_panel2',
		        layout: {type: 'uniTable', columns: 1},
		        defaultType: 'uniTextfield',
				items: [{
			            xtype: 'uniCombobox',
			            name: 'BUDG_TYPE',
			            comboType:'AU',
						comboCode:'A132',
		            	value: '2',
			            fieldLabel: '수지구분'
			         },{
						xtype: 'radiogroup',		            		
						fieldLabel: '지출결의없이 마감된 예산기안자료 포함여부',
						labelWidth: 250,
						id: 'RDO_SELECT',
						items: [{
							boxLabel: '포함', 
							width: 50,
							name: 'RDO',
							inputValue: 'IN',
							checked: true  
						},{
							boxLabel: '예산코드', 
							width: 70,
							name: 'RDO',
							inputValue: 'EX'
						}]
					},
				{ 
	    			fieldLabel: '당기시작년월',
	    			name:'ST_DATE',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: true,
					width: 200
				},{ 
	    			fieldLabel: 'DEPT_CODE',
	    			name:'DEPT_CODE2',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: true,
					width: 200
				},{ 
	    			fieldLabel: 'CHARGE_GUBUN',
	    			name:'CHARGE_GUBUN',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: true,
					width: 200
				},{ 
	    			fieldLabel: 'ACCDEPT_GUBUN',
	    			name:'ACCDEPT_GUBUN',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: true,
					width: 200
				},{ 
	    			fieldLabel: 'ACCDEPT_USEYN',
	    			name:'ACCDEPT_USEYN',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: true,
					width: 200
				},{ 
	    			fieldLabel: 'REF_CODE1',
	    			name:'REF_CODE1',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: true,
					width: 200
				},{ 
	    			fieldLabel: 'AMT_POINT',
	    			name:'AMT_POINT',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: true,
					width: 200
				}
			]	
		}],
		setAllFieldsReadOnly: function(b) { 
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });                      
		        if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		},
		api: {
	 		load: 'afb555skrService.selectDeptBudg'	
		}
	});	// end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
        	fieldLabel: '기안(추산)년월',
			xtype: 'uniMonthRangefield',  
			startFieldName: 'FR_MONTH',
			endFieldName: 'TO_MONTH',
			allowBlank:false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelSearch.setValue('FR_MONTH',newValue);			
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelSearch.setValue('TO_MONTH',newValue);			    		
		    	}
		    }
		},{
			xtype: 'container',
			layout : {type : 'uniTable'},
			items:[
		         Unilite.popup('DEPT',{
				        fieldLabel: '부서',
					    valueFieldName:'DEPT_CODE',
					    textFieldName:'DEPT_NAME',
				        //validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
									panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('DEPT_CODE', '');
								panelSearch.setValue('DEPT_CODE', '');
								panelResult.setValue('DEPT_NAME', '');
								panelResult.setValue('DEPT_NAME', '');
							}
						}
			    }),{
		    		xtype: 'uniCheckboxgroup',	
//			    		padding: '-2 0 0 -100',
		    		fieldLabel: '',
		    		items: [{
		    			boxLabel: '하위부서포함',
		    			width: 130,
		    			name: 'LOWER_DEPT',
			        	inputValue: 'Y',
						uncheckedValue: 'N',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('LOWER_DEPT', newValue);
							}
						}
		    		}]
		        }
		]},
        Unilite.popup('AC_PROJECT',{
		        fieldLabel: '프로젝트',
			    valueFieldName:'AC_PROJECT_CODE',
			    textFieldName:'AC_PROJECT_NAME',
		        //validateBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('AC_PROJECT_CODE', panelResult.getValue('AC_PROJECT_CODE'));
							panelSearch.setValue('AC_PROJECT_NAME', panelResult.getValue('AC_PROJECT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('AC_PROJECT_CODE', '');
						panelResult.setValue('AC_PROJECT_CODE', '');
						panelSearch.setValue('AC_PROJECT_NAME', '');
						panelSearch.setValue('AC_PROJECT_NAME', '');
					}
				}
	    }),
    	 Unilite.popup('BUDG',{
		        fieldLabel: '예산과목',
			    valueFieldName:'BUDG_CODE',
			    textFieldName:'BUDG_NAME',
		        //validateBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
							panelResult.setValue('BUDG_NAME', records[0][name]);	
							panelSearch.setValue('BUDG_CODE', panelResult.getValue('BUDG_CODE'));
							panelSearch.setValue('BUDG_NAME', panelResult.getValue('BUDG_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('BUDG_CODE', '');
						panelResult.setValue('BUDG_NAME', '');
						panelSearch.setValue('BUDG_CODE', '');
						panelSearch.setValue('BUDG_NAME', '');
					}
				}
		    })
		],	
		setAllFieldsReadOnly: function(b) { 
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });                      
		        if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
    /* Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var masterGrid = Unilite.createGrid('Afb555Grid1', {
    	features: [{
    			id: 'masterGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: false
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',			
    			showSummaryRow: false
    		}
    	],
    	layout : 'fit',
        region : 'center',
		store: masterGroupStore,
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: true,
			expandLastColumn	: true,
			onLoadSelectFirst 	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer: false
		},
		selModel:'rowmodel',
		 plugins: [{
            ptype: "subtable",
            pluginId:"subtable",
            association: 'sub',
            store: masterSubStore,
            scrollable :true,
            selectRowOnExpand : true,
            rowBodyCls: "x-subtable-rowbody",
            rowBodyTpl: ['<div style="overflow:auto;"><table cellpadding="0" cellspacing="0" border="0" class="' + Ext.baseCSSPrefix + 'grid-subtable">',
		        '{%',
		            'this.owner.onRenderData(out, values);',
		        '%}',
		        '</table></div>'
		    ],
		    onRenderData:function(out, rowValues) {
		        var me = this,
		            columns = me.columns,
		            numColumns = columns.length,
		            associatedRecords = me.getAssociatedRecords(rowValues.record),
		            recCount = associatedRecords.length,
		            rec, column, i, j, value;
		
		        out.push('<thead>');
		        for (j = 0; j < numColumns; j++) {
		            out.push('<th class="' + Ext.baseCSSPrefix + 'grid-subtable-header">', columns[j].text, '</th>');
		        }
		        out.push('</thead><tbody>');
		        for (i = 0; i < recCount; i++) {
		            rec = associatedRecords[i];
		            out.push('<tr>');
		            for (j = 0; j < numColumns; j++) {
		                column = columns[j];
		                value = rec.get(column.dataIndex);
		                if (column.renderer && column.renderer.call) {
		                    value = column.renderer.call(column.scope || me, value, {}, rec);
		                }
		                out.push('<td class="' + Ext.baseCSSPrefix + 'grid-subtable-cell"');
		                var strStyle = ' style="';
		                if (column.width != null) {
		                    strStyle = strStyle+'width:' + column.width + 'px;';
		                }
		                if (column.xtype == 'numbercolumn') {
		                	strStyle = strStyle+'text-align:right;';
		                }else  if(column.align != null) {
		                    strStyle = strStyle+'text-align:' + column.align + ';';
		                }
		                out.push(strStyle+'"');
		                var formatValue = value;
		                if(column.xtype == 'numbercolumn')	{
		                	formatValue = Ext.util.Format.number(value, column.format);
		                }
		                out.push('><div class="' + Ext.baseCSSPrefix + 'grid-cell-inner">', formatValue, '</div></td>');
		            }
		            out.push('</tr>');
		        }
		        out.push('</tbody>');
		    },
            getAssociatedRecords: function(record) {
		       
		         var result =   Ext.Array.push(MasterStore.data.filterBy(function(r) {
		         	var chk = true;
		         	if(r.get('BUDG_CODE') != record.get('BUDG_CODE'))	{
						chk = false;
					}
					Ext.each(budgNameList, function(budgName, i){
						if(r.get('BUDG_NAME_'+(i+1)) != record.get('BUDG_NAME_'+(i+1)))	{
							chk = false;
						}
					})
		         	return  chk;
		         } ).items);
		       
		        return result;
		    },
		    
            columns: [        
            	
				{dataIndex: 'DRAFT_NO'			,text:'기안(추산)번호'	, width: 100}, 
				{dataIndex: 'DRAFT_TITLE'		,text:'기안건명'		, width: 233}, 
				{dataIndex: 'DRAFT_DATE'		,text:'기안일'			, width: 80, xtype:'uniDateColumn'}, 
				{dataIndex: 'DRAFT_AMT'			,text:'기안(추산)금액'	, width: 110,xtype:'numbercolumn', format:UniFormat.Price }, 
				{dataIndex: 'CLOSE_YN'			,text:'기안마감여부'	, width: 90}, 
				{dataIndex: 'PAY_DRAFT_NO'		,text:'수입/지출번호'	, width: 110}, 
				{dataIndex: 'PAY_TITLE'			,text:'수입/지출건명'	, width: 233}, 
				{dataIndex: 'SLIP_DATE'			,text:'수입/지출일'		, width: 80, xtype:'uniDateColumn'}, 
				{dataIndex: 'PAY_AMT'			,text:'수입/지츨금액'	, width: 110, xtype:'numbercolumn', format:UniFormat.Price }, 
				{dataIndex: 'TRANS_DATE'		,text:'이체일자'		, width: 80, xtype:'uniDateColumn', align:'center'}, 
				{dataIndex: 'TRANS_AMT'			,text:'이체금액'		, width: 110, xtype:'numbercolumn', format:UniFormat.Price }, 
				{dataIndex: 'NON_PAY_AMT'		,text:'미지급액'		, width: 110, xtype:'numbercolumn', format:UniFormat.Price }, 
				{dataIndex: 'DRAFT_REMIND_AMT'	,text:'기안(추산)잔액'	, width: 110, xtype:'numbercolumn', format:UniFormat.Price}
			]
        }],
        columns: columns,
        
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{ 
        		view.ownerGrid.setCellPointer(view, item);
//        		if(UniUtils.indexOf(e.field, ['DRAFT_NO', 'DRAFT_TITLE', 'DRAFT_DATE', 'DRAFT_AMT', 'CLOSE_YN'])) {
//        			view.ownerGrid.setCellPointer(view, item);
//        		} else if(UniUtils.indexOf(e.field, ['PAY_DRAFT_NO', 'PAY_TITLE', 'SLIP_DATE', 'PAY_AMT'])) {
//        			view.ownerGrid.setCellPointer(view, item);
//        		}
        	}
        },
		onItemcontextmenu:function( menu, grid, record, item, index, event, e, eOpts )	{          		
//      		if(UniUtils.indexOf(e.field, ['DRAFT_NO', 'DRAFT_TITLE', 'DRAFT_DATE', 'DRAFT_AMT', 'CLOSE_YN'])) {
//    			menu.down('#linkAfb700ukr').hide();
//    			menu.down('#linkAfb600ukr').show();
//    		} else if(UniUtils.indexOf(field, ['PAY_DRAFT_NO', 'PAY_TITLE', 'SLIP_DATE', 'PAY_AMT'])) {
//    			menu.down('#linkAfb600ukr').hide();
//    			menu.down('#linkAfb700ukr').show();
//    		}
			if(record.get('BUDG_TYPE') == '1') {
				menu.down('#linkAfb600ukr').hide();
				menu.down('#linkAfb700ukr').hide();
				menu.down('#linkAfb800ukr').show();
			} else {
				menu.down('#linkAfb600ukr').show();
				menu.down('#linkAfb700ukr').show();
				menu.down('#linkAfb800ukr').hide();
			}
        	return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '예산기안(추산)등록 보기',   
	            	itemId	: 'linkAfb600ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb600(param.record);
	            	}
	        	},{	text: '지출결의등록 이동',   
	            	itemId	: 'linkAfb700ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb700(param.record);
	            	}
	        	},{	text: '수입결의등록 이동',   
	            	itemId	: 'linkAfb800ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb800(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAfb600:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 'afb555skr',
					'DRAFT_NO' 			: record.data['DRAFT_NO']
				}
		  		var rec1 = {data : {prgID : 'afb600ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb600ukr.do', params);
			}
    	},
		gotoAfb700:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 'afb555skr',
					'PAY_DRAFT_NO' 		: record.data['PAY_DRAFT_NO']
				}
		  		var rec1 = {data : {prgID : 'afb700ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb700ukr.do', params);
			}
    	},
		gotoAfb800:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 'afb555skr',
					'DRAFT_DATE' 		: record.data['DRAFT_DATE'],
					'DRAFT_NO' 			: record.data['DRAFT_NO'],
					'TITLE' 			: record.data['DRAFT_TITLE'],
					'STATUS' 			: record.data['DRAFT_TITLE']
				}
		  		var rec1 = {data : {prgID : 'afb800ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb800ukr.do', params);
			}
    	}
    });   
    
 
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		], 
		id : 'Afb555App',
		fnInitBinding : function(params) {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_MONTH');
			var param= Ext.getCmp('searchForm').getValues();
			panelSearch.setValue('ST_DATE',getStDt[0].STDT.substring(0, 4));
			panelSearch.setValue('FR_MONTH', UniDate.get('startOfYear'));
			panelResult.setValue('FR_MONTH', UniDate.get('startOfYear'));
			panelSearch.setValue('TO_MONTH', UniDate.get('endOfMonth'));
			panelResult.setValue('TO_MONTH', UniDate.get('endOfMonth'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			param.budgNameInfoList = budgNameList;	//예산목록
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
		},
		onQueryButtonDown : function()	{		
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}	
			var param= Ext.getCmp('searchForm').getValues();
			panelSearch.getForm().load({
				params : param,
				success: function(form, action) {
					MasterStore.loadStoreRecords();
				}
			});
		},
        fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
	    		panelSearch.setValue('ST_DATE', newValue)
			}
        },
        //링크로 넘어오는 params 받는 부분 (Agj100skr)
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'afb540skr') {
				panelSearch.setValue('FR_YYYYMM',params.FR_YYYYMM);
				panelSearch.setValue('TO_YYYYMM',params.TO_YYYYMM);
				panelSearch.setValue('BUDG_CODE',params.BUDG_CODE);
				panelSearch.setValue('BUDG_NAME',params.BUDG_NAME);
				panelSearch.setValue('DEPT_CODE',params.DEPT_CODE);
				panelSearch.setValue('DEPT_NAME',params.DEPT_NAME);
				panelSearch.setValue('BUDG_TYPE',params.BUDG_TYPE);
				panelSearch.setValue('RDO',params.RDO);
				panelSearch.setValue('MONEY_UNIT',params.MONEY_UNIT);
				panelSearch.setValue('AC_PROJECT_CODE',params.AC_PROJECT_CODE);
				panelSearch.setValue('AC_PROJECT_NAME',params.AC_PROJECT_NAME);
				panelResult.setValue('FR_YYYYMM',params.FR_YYYYMM);
				panelResult.setValue('TO_YYYYMM',params.TO_YYYYMM);
				panelResult.setValue('BUDG_CODE',params.BUDG_CODE);
				panelResult.setValue('BUDG_NAME',params.BUDG_NAME);
				panelResult.setValue('DEPT_CODE',params.DEPT_CODE);
				panelResult.setValue('DEPT_NAME',params.DEPT_NAME);
				panelResult.setValue('BUDG_TYPE',params.BUDG_TYPE);
				panelResult.setValue('RDO',params.RDO);
				panelResult.setValue('MONEY_UNIT',params.MONEY_UNIT);
				panelResult.setValue('AC_PROJECT_CODE',params.AC_PROJECT_CODE);
				panelResult.setValue('AC_PROJECT_NAME',params.AC_PROJECT_NAME);
				
			}
			MasterStore.loadStoreRecords();
        }
	});
	
	// 모델필드 생성
	function createMasterModelField(budgNameList) {
		var fields = [
			{name: 'TYPE_FLAG'					, text: 'TYPE_FLAG'				, type: 'string'},
			{name: 'SEQ'						, text: '순번'					, type: 'int'},
			{name: 'BUDG_CODE'					, text: '예산코드'					, type: 'string'},
			// 예산과목명
			{name: 'BUDG_CONF_I'				, text: '연간예산금액'				, type: 'uniPrice'},
			{name: 'BUDG_BALN_I'				, text: '예산잔액'					, type: 'uniPrice'},
			{name: 'DRAFT_NO'					, text: '기안(추산)번호'			, type: 'string'},
			{name: 'DRAFT_TITLE'				, text: '기안건명'					, type: 'string'},
			{name: 'DRAFT_DATE'					, text: '기안일'					, type: 'uniDate'},
			{name: 'DRAFT_AMT'					, text: '기안(추산)금액'			, type: 'uniPrice'},
			{name: 'CLOSE_YN'					, text: '기안마감여부'				, type: 'string'},
			{name: 'PAY_DRAFT_NO'				, text: '수입/지출번호'				, type: 'string'},
			{name: 'PAY_TITLE'					, text: '수입/지출건명'				, type: 'string'},
			{name: 'SLIP_DATE'					, text: '수입/지출일'				, type: 'uniDate'},
			{name: 'PAY_AMT'					, text: '수입/지츨금액'				, type: 'uniPrice'},
			{name: 'TRANS_DATE'					, text: '이체일자'					, type: 'uniDate'},
			{name: 'TRANS_AMT'					, text: '이체금액'					, type: 'uniPrice'},
			{name: 'NON_PAY_AMT'				, text: '미지급액'					, type: 'uniPrice'},
			{name: 'DRAFT_REMIND_AMT'			, text: '기안(추산)잔액'			, type: 'uniPrice'},
			{name: 'BUDG_TYPE'					, text: '수지구분'					, type: 'string', comboType: 'AU', comboCode: 'A132'}
	    ];
					
		Ext.each(budgNameList, function(item, index) {
			var name = 'BUDG_NAME_'+(index + 1);
			fields.push({name: name, text: item.CODE_NAME, type:'string' });
		});
		console.log(fields);
		return fields;
	}
	
	function createModelField(budgNameList) {
		var fields = [
			{name: 'TYPE_FLAG'					, text: 'TYPE_FLAG'				, type: 'string'},
			{name: 'SEQ'						, text: '순번'					, type: 'int'},
			{name: 'BUDG_CODE'					, text: '예산코드'					, type: 'string'},
			// 예산과목명
			{name: 'BUDG_CONF_I'				, text: '연간예산금액'				, type: 'uniPrice'},
			{name: 'BUDG_BALN_I'				, text: '예산잔액'					, type: 'uniPrice'}
			
	    ];
					
		Ext.each(budgNameList, function(item, index) {
			var name = 'BUDG_NAME_'+(index + 1);
			fields.push({name: name, text: item.CODE_NAME, type:'string' });
		});
		console.log(fields);
		return fields;
	}
	
	
	function createSubModelField(budgNameList) {
		var fields = [
			
			{name: 'SEQ'						, text: '순번'					, type: 'int'},
			{name: 'sub'						},
			
			
			{name: 'DRAFT_NO'					, text: '기안(추산)번호'			, type: 'string'},
			{name: 'DRAFT_TITLE'				, text: '기안건명'					, type: 'string'},
			{name: 'DRAFT_DATE'					, text: '기안일'					, type: 'uniDate'},
			{name: 'DRAFT_AMT'					, text: '기안(추산)금액'			, type: 'uniPrice'},
			{name: 'CLOSE_YN'					, text: '기안마감여부'				, type: 'string'},
			{name: 'PAY_DRAFT_NO'				, text: '수입/지출번호'				, type: 'string'},
			{name: 'PAY_TITLE'					, text: '수입/지출건명'				, type: 'string'},
			{name: 'SLIP_DATE'					, text: '수입/지출일'				, type: 'uniDate'},
			{name: 'PAY_AMT'					, text: '수입/지츨금액'				, type: 'uniPrice'},
			{name: 'TRANS_DATE'					, text: '이체일자'					, type: 'uniDate'},
			{name: 'TRANS_AMT'					, text: '이체금액'					, type: 'uniPrice'},
			{name: 'NON_PAY_AMT'				, text: '미지급액'					, type: 'uniPrice'},
			{name: 'DRAFT_REMIND_AMT'			, text: '기안(추산)잔액'			, type: 'uniPrice' , convert:function(value){return Ext.util.Format.number(value, UniFormat.Price)}},
			{name: 'BUDG_TYPE'					, text: '수지구분'					, type: 'string', comboType: 'AU', comboCode: 'A132'},
			{name: 'BUDG_CODE'					, text: '예산코드'					, type: 'string', reference: {parent: 'Afb555GridModel'}}
			
			
	    ];
			
		
		console.log(fields);
		return fields;
	}
	function createGridColumn(budgNameList) {
		var columns = [        
        	{dataIndex: 'TYPE_FLAG'					, width: 53, hidden: true}, 	
        	{dataIndex: 'SEQ'						, width: 53, hidden: true}, 
        	{dataIndex: 'BUDG_CODE'					, width: 133, renderer:function(value){return '<div style="color:blue">'+value+'</div>'}}
			// 예산명(쿼리읽어서 컬럼 셋팅)
		];
		// 예산명(쿼리읽어서 컬럼 셋팅)
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_'+(index + 1);
			columns.push({dataIndex: dataIndex,		width: 110, renderer:function(value){return '<div style="color:blue">'+value+'</div>'}});	
		});
		columns.push({dataIndex: 'BUDG_CONF_I'						, width: 100,renderer:function(value){return '<div style="color:blue">'+Ext.util.Format.number(value, UniFormat.Price)+'</div>'}}); 
		columns.push({dataIndex: 'BUDG_BALN_I'						, width: 100,renderer:function(value){return '<div style="color:blue">'+Ext.util.Format.number(value, UniFormat.Price)+'</div>'}}); 
		/*columns.push({dataIndex: 'DRAFT_NO'							, width: 100}); 
		columns.push({dataIndex: 'DRAFT_TITLE'						, width: 233}); 
		columns.push({dataIndex: 'DRAFT_DATE'						, width: 80}); 
		columns.push({dataIndex: 'DRAFT_AMT'						, width: 110}); 
		columns.push({dataIndex: 'CLOSE_YN'							, width: 90}); 
		columns.push({dataIndex: 'PAY_DRAFT_NO'						, width: 110}); 
		columns.push({dataIndex: 'PAY_TITLE'						, width: 233}); 
		columns.push({dataIndex: 'SLIP_DATE'						, width: 80}); 
		columns.push({dataIndex: 'PAY_AMT'							, width: 110}); 
		columns.push({dataIndex: 'TRANS_DATE'						, width: 80}); 
		columns.push({dataIndex: 'TRANS_AMT'						, width: 110}); 
		columns.push({dataIndex: 'NON_PAY_AMT'						, width: 110}); 
		columns.push({dataIndex: 'DRAFT_REMIND_AMT'					, width: 110}); 
		columns.push({dataIndex: 'BUDG_TYPE'						, width: 80, hidden: true}); */
		return columns;
	}	
	

	
	/*
	// 그리드 컬럼 생성
	function createGridColumn(budgNameList) {
		var columns = [        
        	{dataIndex: 'TYPE_FLAG'					, width: 53, hidden: true}, 	
        	{dataIndex: 'SEQ'						, width: 53, hidden: true}, 
        	{dataIndex: 'BUDG_CODE'					, width: 133}
			// 예산명(쿼리읽어서 컬럼 셋팅)
		];
		// 예산명(쿼리읽어서 컬럼 셋팅)
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_'+(index + 1);
			columns.push({dataIndex: dataIndex,		width: 110});	
		});
		columns.push({dataIndex: 'BUDG_CONF_I'						, width: 100}); 
		columns.push({dataIndex: 'BUDG_BALN_I'						, width: 100}); 
		columns.push({dataIndex: 'DRAFT_NO'							, width: 100}); 
		columns.push({dataIndex: 'DRAFT_TITLE'						, width: 233}); 
		columns.push({dataIndex: 'DRAFT_DATE'						, width: 80}); 
		columns.push({dataIndex: 'DRAFT_AMT'						, width: 110}); 
		columns.push({dataIndex: 'CLOSE_YN'							, width: 90}); 
		columns.push({dataIndex: 'PAY_DRAFT_NO'						, width: 110}); 
		columns.push({dataIndex: 'PAY_TITLE'						, width: 233}); 
		columns.push({dataIndex: 'SLIP_DATE'						, width: 80}); 
		columns.push({dataIndex: 'PAY_AMT'							, width: 110}); 
		columns.push({dataIndex: 'TRANS_DATE'						, width: 80}); 
		columns.push({dataIndex: 'TRANS_AMT'						, width: 110}); 
		columns.push({dataIndex: 'NON_PAY_AMT'						, width: 110}); 
		columns.push({dataIndex: 'DRAFT_REMIND_AMT'					, width: 110}); 
		columns.push({dataIndex: 'BUDG_TYPE'						, width: 80, hidden: true}); 
		return columns;
	}	*/
	
	function createGridColumn_tmp(budgNameList) {
		var columns = [        
        	{dataIndex: 'TYPE_FLAG'					, width: 53, hidden: true}, 	
        	{dataIndex: 'SEQ'						, width: 53, hidden: true}, 
        	{dataIndex: 'BUDG_CODE'					, width: 133}
			// 예산명(쿼리읽어서 컬럼 셋팅)
		];
		// 예산명(쿼리읽어서 컬럼 셋팅)
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_'+(index + 1);
			columns.push({dataIndex: dataIndex,		width: 110});	
		});
		columns.push({dataIndex: 'BUDG_CONF_I'						, width: 100}); 
		columns.push({dataIndex: 'BUDG_BALN_I'						, width: 100}); 
		columns.push({dataIndex: 'DRAFT_NO'							, width: 100}); 
		columns.push({dataIndex: 'DRAFT_TITLE'						, width: 233}); 
		columns.push({dataIndex: 'DRAFT_DATE'						, width: 80}); 
		columns.push({dataIndex: 'DRAFT_AMT'						, width: 110}); 
		columns.push({dataIndex: 'CLOSE_YN'							, width: 90}); 
		columns.push({dataIndex: 'PAY_DRAFT_NO'						, width: 110}); 
		columns.push({dataIndex: 'PAY_TITLE'						, width: 233}); 
		columns.push({dataIndex: 'SLIP_DATE'						, width: 80}); 
		columns.push({dataIndex: 'PAY_AMT'							, width: 110}); 
		columns.push({dataIndex: 'TRANS_DATE'						, width: 80}); 
		columns.push({dataIndex: 'TRANS_AMT'						, width: 110}); 
		columns.push({dataIndex: 'NON_PAY_AMT'						, width: 110}); 
		columns.push({dataIndex: 'DRAFT_REMIND_AMT'					, width: 110}); 
		columns.push({dataIndex: 'BUDG_TYPE'						, width: 80, hidden: true}); 
		return columns;
	}
};
</script>
