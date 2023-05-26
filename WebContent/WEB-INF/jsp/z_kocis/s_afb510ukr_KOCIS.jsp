<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb510ukr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_afb510ukr_KOCIS" /> 	<!-- 사업장 --> 
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

var otherWindow; // 편성예산 참조

function appMain() {
	var getStDt 	 = ${getStDt};
	var budgNameList = ${budgNameList};
	var fields		 = createModelField(budgNameList);
	var columns		 = createGridColumn(budgNameList);
	var fields2		 = createModelField2(budgNameList);
	var columns2	 = createGridColumn2(budgNameList);
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_afb510ukrService_KOCIS.selectList',
			update: 's_afb510ukrService_KOCIS.updateDetail',
			create: 's_afb510ukrService_KOCIS.insertDetail',
			destroy: 's_afb510ukrService_KOCIS.deleteDetail',
			syncAll: 's_afb510ukrService_KOCIS.saveAll'
		}
	});
	
	Unilite.defineModel('Afb510Model', {
		fields:fields
	});		// End of Ext.define('afb510ukrModel', {
	
	Unilite.defineModel('Afb510Model2', {
	   fields:fields2
	});
	  
	/* Store 정의(Service 정의) @type
	 */					
	var masterStore = Unilite.createStore('Afb510masterStore',{
		model: 'Afb510Model',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: true,				// 수정 모드 사용
            deletable:true,				// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.budgNameInfoList = budgNameList;		//예산목록	
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	if(inValidRecs.length == 0 )	{										
				config = {
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	var masterStore2 = Unilite.createStore('Afb510masterStore2',{
		model: 'Afb510Model2',
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
                read: 's_afb510ukrService_KOCIS.selectList2'                	
            }
        },
        listeners:{
        	load:function(store, records, successful, eOpts) {
        		if(successful)	{
        		   var masterRecords = masterStore.data.filterBy(masterStore.filterNewOnly);  
        		   var refRecords = new Array();
        		   if(masterRecords.items.length > 0) {
        		   		console.log("store.items :", store.items);
        		   		console.log("records", records);
        		   		Ext.each(records, 
            		   		function(item, i) {           			   								
		   						Ext.each(masterRecords.items, function(record, i) {
		   								console.log("record :", record);
	   							});		
            			   	}
            			);
            			store.remove(refRecords);
        			}
        		}
        	}
        },
        loadStoreRecords: function() {
			var param= otherSearch.getValues();
			param.budgNameInfoList = budgNameList;		//예산목록	
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
    	width: 360,
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
		            xtype: 'uniYearField',
		            name: 'AC_YYYY',
		            fieldLabel: '사업년도',
		            fieldStyle: 'text-align: center;',
		            allowBlank:false,
		            //holdable: 'hold',
		            listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AC_YYYY', newValue);
							UniAppManager.app.fnSetStDate(newValue);
						}
					}
		         },
		         Unilite.popup('BUDG',{
				        fieldLabel: '예산과목',
					    valueFieldName:'BUDG_CODE_FR',
					    textFieldName:'BUDG_NAME_FR',
						extParam: {'ADD_QUERY': "GROUP_YN = N'N' AND USE_YN = N'Y'"},
				        validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
									panelSearch.setValue('BUDG_NAME_FR', records[0][name]);	
									panelResult.setValue('BUDG_CODE_FR', panelSearch.getValue('BUDG_CODE_FR'));
									panelResult.setValue('BUDG_NAME_FR', panelSearch.getValue('BUDG_NAME_FR'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('BUDG_CODE_FR', '');
								panelResult.setValue('BUDG_NAME_FR', '');
								panelSearch.setValue('BUDG_CODE_FR', '');
								panelSearch.setValue('BUDG_NAME_FR', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
								popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
							}
						}
			    }),
		         Unilite.popup('BUDG',{
				        fieldLabel: '~',
					    valueFieldName:'BUDG_CODE_TO',
					    textFieldName:'BUDG_NAME_TO',
						extParam: {'ADD_QUERY': "GROUP_YN = N'N' AND USE_YN = N'Y'"},
				        validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
									panelSearch.setValue('BUDG_NAME_TO', records[0][name]);	
									panelResult.setValue('BUDG_CODE_TO', panelSearch.getValue('BUDG_CODE_TO'));
									panelResult.setValue('BUDG_NAME_TO', panelSearch.getValue('BUDG_NAME_TO'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('BUDG_CODE_TO', '');
								panelResult.setValue('BUDG_NAME_TO', '');
								panelSearch.setValue('BUDG_CODE_TO', '');
								panelSearch.setValue('BUDG_NAME_TO', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
								popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
							}
						}
			    }),{
		            xtype: 'uniCombobox',
		            name: 'BUDG_TYPE',
		            comboType:'AU',
					comboCode:'A132',
		            fieldLabel: '수지구분',
	            	value: '2',
		            //holdable: 'hold',
		            allowBlank:false,
		            listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BUDG_TYPE', newValue);
						}
					}
		         },
		         Unilite.popup('DEPT',{
				        fieldLabel: '부서',
					    valueFieldName:'DEPT_CODE',
					    textFieldName:'DEPT_NAME',
		            	allowBlank:false,
		           	 	//holdable: 'hold',
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
	    			fieldLabel: '당기시작년월',
	    			name:'ST_DATE',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: false,
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
		}
	});	// end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
	            xtype: 'uniYearField',
	            name: 'AC_YYYY',
	            fieldLabel: '사업년도',
	            fieldStyle: 'text-align: center;',
	            allowBlank:false,
	            //holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AC_YYYY', newValue);
						UniAppManager.app.fnSetStDate(newValue);
					}
				}
	         },
	         Unilite.popup('BUDG',{
			        fieldLabel: '예산과목',
				    valueFieldName:'BUDG_CODE_FR',
				    textFieldName:'BUDG_NAME_FR',
					extParam: {'ADD_QUERY': "GROUP_YN = N'N' AND USE_YN = N'Y'"},
			        validateBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
								panelResult.setValue('BUDG_NAME_FR', records[0][name]);	
								panelSearch.setValue('BUDG_CODE_FR', panelResult.getValue('BUDG_CODE_FR'));
								panelSearch.setValue('BUDG_NAME_FR', panelResult.getValue('BUDG_NAME_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('BUDG_CODE_FR', '');
							panelSearch.setValue('BUDG_NAME_FR', '');
							panelResult.setValue('BUDG_CODE_FR', '');
							panelResult.setValue('BUDG_NAME_FR', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
							popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
						}
					}
		    }),{
	            xtype: 'uniCombobox',
	            name: 'BUDG_TYPE',
	            comboType:'AU',
				comboCode:'A132',
	            fieldLabel: '수지구분',
            	value: '2',
	            //holdable: 'hold',
	            allowBlank:false,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BUDG_TYPE', newValue);
					}
				}
	         },
	         Unilite.popup('DEPT',{
			        fieldLabel: '부서',
				    valueFieldName:'DEPT_CODE',
				    textFieldName:'DEPT_NAME',
	            	allowBlank:false,
		            //holdable: 'hold',
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
		    }),
	         Unilite.popup('BUDG',{
			        fieldLabel: '~',
				    valueFieldName:'BUDG_CODE_TO',
				    textFieldName:'BUDG_NAME_TO',
				    validateBlank: false,
					extParam: {'ADD_QUERY': "GROUP_YN = N'N' AND USE_YN = N'Y'"},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
								panelResult.setValue('BUDG_NAME_TO', records[0][name]);	
								panelSearch.setValue('BUDG_CODE_TO', panelResult.getValue('BUDG_CODE_TO'));
								panelSearch.setValue('BUDG_NAME_TO', panelResult.getValue('BUDG_NAME_TO'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('BUDG_CODE_TO', '');
							panelResult.setValue('BUDG_NAME_TO', '');
							panelSearch.setValue('BUDG_CODE_TO', '');
							panelSearch.setValue('BUDG_NAME_TO', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
							popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
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
	
	var otherSearch = Unilite.createSearchForm('otherorderForm', {		// 편성예산 참조
    	layout : {type : 'uniTable', columns : 3},
        items:[{
	            xtype: 'uniYearField',
	            name: 'AC_YYYY',
	            fieldLabel: '사업년도',
	            fieldStyle: 'text-align: center;',
	            allowBlank:false,
				readOnly: true
	         },
	         Unilite.popup('BUDG',{
			        fieldLabel: '예산과목',
				    valueFieldName:'BUDG_CODE_FR',
				    textFieldName:'BUDG_NAME_FR',
				    validateBlank: false,
					extParam: {'ADD_QUERY': "GROUP_YN = N'N' AND USE_YN = N'Y'"}
		    }),{
	            xtype: 'uniCombobox',
	            name: 'BUDG_TYPE',
	            comboType:'AU',
				comboCode:'A132',
	            fieldLabel: '수지구분',
            	value: '2',
	            allowBlank:false,
				readOnly: true
	         },
	         Unilite.popup('DEPT',{
			        fieldLabel: '부서',
				    valueFieldName:'DEPT_CODE',
				    textFieldName:'DEPT_NAME',
	            	allowBlank:false,
					readOnly: true
		    }),
	         Unilite.popup('BUDG',{
			        fieldLabel: '~',
				    valueFieldName:'BUDG_CODE_TO',
				    textFieldName:'BUDG_NAME_TO',
				    validateBlank: false,
					extParam: {'ADD_QUERY': "GROUP_YN = N'N' AND USE_YN = N'Y'"}
		    })
		]
    });
	
    /* Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var masterGrid = Unilite.createGrid('Afb510Grid1', {
    	tbar: [{
			xtype: 'splitbutton',
           	itemId:'orderTool',
			text: '참조...',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'MoveReleaseBtn',
					text: '편성예산 참조',
					handler: function() {
						openotherWindow();
					}
				}]
			})
		}],	
    	features: [{
    			id: 'masterGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: true
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',			
    			showSummaryRow: true
    		}
    	],
    	layout : 'fit',
        region : 'center',
		store: masterStore,
		uniOpt : {
			useMultipleSorting	: true,			 
    		useLiveSearch		: false,			
    		onLoadSelectFirst	: false,		
    		dblClickToEdit		: false,		
    		useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: false,		
			useRowContext		: false,	// rink 항목이 있을경우만 true			
			filter: {
				useFilter	: true,		
				autoCreate	: true		
			}
		},
        columns:columns,
        listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(!e.record.phantom) {
	        		if(UniUtils.indexOf(e.field, ['BUDG_CONF_I', 'BUDG_CONF_I01', 'BUDG_CONF_I02', 'BUDG_CONF_I03', 'BUDG_CONF_I04', 'BUDG_CONF_I05', 'BUDG_CONF_I06',
	        									  'BUDG_CONF_I07', 'BUDG_CONF_I08', 'BUDG_CONF_I09', 'BUDG_CONF_I10', 'BUDG_CONF_I11', 'BUDG_CONF_I12'])) 
					{ 
						return true;
      				} else {
      					return false;
      				}
	        	} else {
	        		if(UniUtils.indexOf(e.field, ['BUDG_CONF_I', 'BUDG_CONF_I01', 'BUDG_CONF_I02', 'BUDG_CONF_I03', 'BUDG_CONF_I04', 'BUDG_CONF_I05', 'BUDG_CONF_I06',
	        									  'BUDG_CONF_I07', 'BUDG_CONF_I08', 'BUDG_CONF_I09', 'BUDG_CONF_I10', 'BUDG_CONF_I11', 'BUDG_CONF_I12']))
				   	{
						return true;
      				} else {
      					return false;
      				}
	        	}
	        }
		},
		setEstiData: function(record) {						// 이동출고참조 셋팅
       		var grdRecord = this.getSelectedRecord();
       		grdRecord.set('COMP_CODE'		, UserInfo.compCode);
			grdRecord.set('AC_YYYY'			, record['AC_YYYY']);
			grdRecord.set('DEPT_CODE'		, record['DEPT_CODE']);
			grdRecord.set('BUDG_CODE'		, record['BUDG_CODE']);
			grdRecord.set('CAL_DIVI'		, record['CAL_DIVI']);
			Ext.each(budgNameList, function(item, index) {
				var name = 'BUDG_NAME_L'+(index + 1);
				grdRecord.set(name	,record[name]);
			});
			grdRecord.set('BUDG_CONF_I'		, record['BUDG_CONF_I']);
			grdRecord.set('BUDG_CONF_I01'	, record['BUDG_CONF_I01']);
			grdRecord.set('BUDG_CONF_I02'	, record['BUDG_CONF_I02']);
			grdRecord.set('BUDG_CONF_I03'	, record['BUDG_CONF_I03']);
			grdRecord.set('BUDG_CONF_I04'	, record['BUDG_CONF_I04']);
			grdRecord.set('BUDG_CONF_I05'	, record['BUDG_CONF_I05']);
			grdRecord.set('BUDG_CONF_I06'	, record['BUDG_CONF_I06']);
			grdRecord.set('BUDG_CONF_I07'	, record['BUDG_CONF_I07']);
			grdRecord.set('BUDG_CONF_I08'	, record['BUDG_CONF_I08']);
			grdRecord.set('BUDG_CONF_I09'	, record['BUDG_CONF_I09']);
			grdRecord.set('BUDG_CONF_I10'	, record['BUDG_CONF_I10']);
			grdRecord.set('BUDG_CONF_I11'	, record['BUDG_CONF_I11']);
			grdRecord.set('BUDG_CONF_I12'	, record['BUDG_CONF_I12']);
			grdRecord.set('INSERT_DB_USER'	, record['INSERT_DB_USER']);
			grdRecord.set('INSERT_DB_TIME'	, record['INSERT_DB_TIME']);
			grdRecord.set('UPDATE_DB_USER'	, record['UPDATE_DB_USER']);
			grdRecord.set('UPDATE_DB_TIME'	, record['UPDATE_DB_TIME']);
			grdRecord.set('FR_BUDG_YYYYMM'	, record['FR_BUDG_YYYYMM']);
			grdRecord.set('DATA_TYPE'		, record['DATA_TYPE']);
		}
    });
    
    function openotherWindow() {    	//편성예산 참조	
  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		otherSearch.setValue('AC_YYYY', panelSearch.getValue('AC_YYYY'));
  		otherSearch.setValue('BUDG_CODE_FR', panelSearch.getValue('BUDG_CODE_FR'));
  		otherSearch.setValue('BUDG_ANME_FR', panelSearch.getValue('BUDG_ANME_FR'));
  		otherSearch.setValue('BUDG_CODE_TO', panelSearch.getValue('BUDG_CODE_TO'));
  		otherSearch.setValue('BUDG_ANME_TO', panelSearch.getValue('BUDG_ANME_TO'));
  		otherSearch.setValue('BUDG_TYPE', panelSearch.getValue('BUDG_TYPE'));   
  		otherSearch.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));  
  		otherSearch.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));  		
  		//masterStore2.loadStoreRecords();
  		
		if(!otherWindow) {
			otherWindow = Ext.create('widget.uniDetailWindow', {
                title: '편성예산참조',
                width: 1000,				                
                height: 650,
                layout:{type:'vbox', align:'stretch'},
                
                items: [otherSearch, otherGrid],
                tbar:  [
					{	itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							masterStore2.loadStoreRecords();
						},
						disabled: false
					},{	itemId : 'confirmBtn',
						text: '적용',
						handler: function() {
							otherGrid.returnData();
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						text: '적용 후 닫기',
						handler: function() {
							otherGrid.returnData();
							otherWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					},'->',{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							otherWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{
                		otherSearch.clearForm();
                		otherGrid.reset();
                	},
                	beforeclose: function(panel, eOpts) {
						otherSearch.clearForm();
                		otherGrid.reset();
                	},
                	beforeshow: function (me, eOpts)	{
                		otherSearch.setValue('AC_YYYY', panelSearch.getValue('AC_YYYY'));
				  		otherSearch.setValue('BUDG_CODE_FR', panelSearch.getValue('BUDG_CODE_FR'));
				  		otherSearch.setValue('BUDG_ANME_FR', panelSearch.getValue('BUDG_ANME_FR'));
				  		otherSearch.setValue('BUDG_CODE_TO', panelSearch.getValue('BUDG_CODE_TO'));
				  		otherSearch.setValue('BUDG_ANME_TO', panelSearch.getValue('BUDG_ANME_TO'));
				  		otherSearch.setValue('BUDG_TYPE', panelSearch.getValue('BUDG_TYPE'));   
				  		otherSearch.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));  
				  		otherSearch.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));  		
				  		//masterStore2.loadStoreRecords();
        			}
                }
			})
		}
		otherWindow.show();
    }
    
    var otherGrid = Unilite.createGrid('Afb510Grid2', {		// 편성예산참조
    	features: [{
    			id: 'masterGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: true
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',			
    			showSummaryRow: true
    		}
    	],
    	layout : 'fit',
//    	tbar: [{
//        	text:'전체선택',
//        	handler: function() {
//        		masterStore2.rejectChanges( );
//        		Ext.each(masterStore.data.items, function(item, idx){
//        			if(item.get('GUBUN') == 'AFB510T')	{
//        				item.set('CHOICE', true);
//        			} else {
//        				item.set('CHOICE', false);
//        			}
//        		})
//        	}
//        },{
//        	text:'취소',
//        	handler: function() {
//        		masterStore2.rejectChanges( );
//        		Ext.each(masterStore.data.items, function(item, idx){
//        			if(item.get('GUBUN') == 'AFB510T')	{
//        				item.set('CHOICE', true);
//        			} else {
//        				item.set('CHOICE', false);
//        			}
//        		})
//        	}
//        }],
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
		store: masterStore2,
		uniOpt: {						
			useMultipleSorting	: true,			
		    useLiveSearch		: false,			
		    onLoadSelectFirst	: false,				
		    dblClickToEdit		: true,			
		    useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: false,			
			useRowContext		: false,		
		    filter: {					
				useFilter		: false,	
				autoCreate		: false	
			}
        },
        columns:columns2, 
       	returnData: function()	{
			masterGrid.reset();
       		var records = this.getSelectedRecords();
       		Ext.each(records, function(record,i) {	
		       	UniAppManager.app.onNewDataButtonDown();
		       	masterGrid.setEstiData(record.data);								        
		    }); 
			this.getStore().remove(records);
       	}/*,
    	beforeedit:function( editor, context, eOpts )	{
    		if(context.field == 'CHOICE')	{
    			return false;
    		}
    		if(!context.record.get('CHOICE'))	{
    			return false;
    		}
    	}*/
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
		id : 'Afb510App',
		fnInitBinding : function() {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_YYYY');
			panelSearch.setValue('ST_DATE',getStDt[0].STDT.substring(0, 4));
			panelSearch.setValue('AC_YYYY', new Date().getFullYear());
			panelResult.setValue('AC_YYYY', new Date().getFullYear());
			panelResult.setValue('AC_YYYY', new Date().getFullYear());
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			//param.budgNameInfoList = budgNameList;	//예산목록
		},
		onQueryButtonDown : function()	{		
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}	
			masterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons(['reset', 'delete'], true);
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			masterStore.saveStore();
		},
		onResetButtonDown: function() {
//			return panelSearch.setAllFieldsReadOnly(false);
//			return panelResult.setAllFieldsReadOnly(false);
//			panelSearch.clearForm();
//			panelResult.clearForm();
//			otherSearch.clearForm();
//			masterGrid.reset();
//			otherGrid.reset();
//			masterStore.removeAll();
//			masterStore2.removeAll();
//			this.fnInitBinding();
			return panelSearch.setAllFieldsReadOnly(false);
			return panelResult.setAllFieldsReadOnly(false);
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.removeAll();
			this.fnInitBinding();
		},
		onNewDataButtonDown: function()	{		// 행추가 
			var acYyyy      		= '';	   
			var deptCode    		= '';	   
			var budgCode    		= '';	   
			var calDivi     		= '';	   
			var budgGubun   		= '';	   
			var gubun       		= '';	   
			var gubunName   		= '';	   
			var budgConfI   		= '';	   
			var budgConfI01 		= '';	   
			var budgConfI02 		= '';	   
			var budgConfI03 		= '';	   
			var budgConfI04 		= '';	   
			var budgConfI05 		= '';	   
			var budgConfI06 		= '';	   
			var budgConfI07 		= '';	   
			var budgConfI08 		= '';	   
			var budgConfI09 		= '';	   
			var budgConfI10 		= '';	   
			var budgConfI11 		= '';	   
			var budgConfI12 		= '';	   
			var budgI01     		= '';	   
			var budgI01     		= '';	   
			var budgI02     		= '';	   
			var budgI03     		= '';	   
			var budgI04     		= '';	   
			var budgI05     		= '';	   
			var budgI06     		= '';	   
			var budgI07     		= '';	   
			var budgI08     		= '';	   
			var budgI09     		= '';	   
			var budgI10     		= '';	   
			var budgI12     		= '';		   
			var frBudgYyyyMm		= '';	   
			var dataType     		= '';	   
			
			var r = {
				'AC_YYYY'			: acYyyy,
				'DEPT_CODE'			: deptCode,
				'BUDG_CODE'		   	: budgCode,
				'CAL_DIVI'			: calDivi,
				'BUDG_GUBUN'		: budgGubun,
				'GUBUN'				: gubun,
				'GUBUN_NAME'		: gubunName,
				'BUDG_CONF_I'		: budgConfI,
				'BUDG_CONF_I01'		: budgConfI01,
				'BUDG_CONF_I02'		: budgConfI02,
				'BUDG_CONF_I03'		: budgConfI03,
				'BUDG_CONF_I04'		: budgConfI04,
				'BUDG_CONF_I05'		: budgConfI05,
				'BUDG_CONF_I06'		: budgConfI06,
				'BUDG_CONF_I07'		: budgConfI07,
				'BUDG_CONF_I08'		: budgConfI08,
				'BUDG_CONF_I09'		: budgConfI09,
				'BUDG_CONF_I10'		: budgConfI10,
				'BUDG_CONF_I11'		: budgConfI11,
				'BUDG_CONF_I12'		: budgConfI12,
				'BUDG_I01'			: budgI01,
				'BUDG_I02'			: budgI01,
				'BUDG_I03'			: budgI02,
				'BUDG_I04'			: budgI03,
				'BUDG_I05'			: budgI04,
				'BUDG_I06'			: budgI05,
				'BUDG_I07'			: budgI06,
				'BUDG_I08'			: budgI07,
				'BUDG_I09'			: budgI08,
				'BUDG_I10'			: budgI09,
				'BUDG_I11'			: budgI10,
				'BUDG_I12'			: budgI12,
				'FR_BUDG_YYYYMM'	: frBudgYyyyMm,
				'DATA_TYPE'			: dataType
			}
			masterGrid.createRow(r);
		},
		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			var selRow1 = masterGrid.getSelectedRecord();
			if(selRow1.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
        fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
	    		panelSearch.setValue('ST_DATE', newValue)
			}
        },
        checkForNewDetail: function() { 
        	if(panelSearch.setAllFieldsReadOnly(true) == false) {
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false) {
				return false;
			}	
			return panelSearch.setAllFieldsReadOnly(true);
			return panelResult.setAllFieldsReadOnly(true);
        }
	});
	
	// 모델필드 생성
	function createModelField(budgNameList) {
		var fields = [
			{name: 'COMP_CODE'			, text: '법인코드'				, type: 'string'},
			{name: 'AC_YYYY'			, text: '사업년도'				, type: 'string'},
			{name: 'DEPT_CODE'			, text: '부서코드'				, type: 'string'},
			{name: 'BUDG_CODE'			, text: '예산과목'				, type: 'string'},
			// 예산명(쿼리읽어서 컬럼 셋팅)
			{name: 'CAL_DIVI'			, text: '계산방법'				, type: 'string'},
			{name: 'BUDG_GUBUN'			, text: '구분'				, type: 'string'},
			{name: 'GUBUN'				, text: '구분'				, type: 'string'},
			{name: 'GUBUN_NAME'			, text: '구분'				, type: 'string'},
			{name: 'BUDG_CONF_I'		, text: '년차예산'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I01'		, text: '1월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I02'		, text: '2월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I03'		, text: '3월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I04'		, text: '4월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I05'		, text: '5월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I06'		, text: '6월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I07'		, text: '7월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I08'		, text: '8월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I09'		, text: '9월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I10'		, text: '10월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I11'		, text: '11월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I12'		, text: '12월'				, type: 'uniPrice'},
			{name: 'BUDG_I01'			, text: '1월'				, type: 'uniPrice'},
			{name: 'BUDG_I02'			, text: '2월'				, type: 'uniPrice'},
			{name: 'BUDG_I03'			, text: '3월'				, type: 'uniPrice'},
			{name: 'BUDG_I04'			, text: '4월'				, type: 'uniPrice'},
			{name: 'BUDG_I05'			, text: '5월'				, type: 'uniPrice'},
			{name: 'BUDG_I06'			, text: '6월'				, type: 'uniPrice'},
			{name: 'BUDG_I07'			, text: '7월'				, type: 'uniPrice'},
			{name: 'BUDG_I08'			, text: '8월'				, type: 'uniPrice'},
			{name: 'BUDG_I09'			, text: '9월'				, type: 'uniPrice'},
			{name: 'BUDG_I10'			, text: '10월'				, type: 'uniPrice'},
			{name: 'BUDG_I11'			, text: '11월'				, type: 'uniPrice'},
			{name: 'BUDG_I12'			, text: '12월'				, type: 'uniPrice'},
			{name: 'INSERT_DB_USER'		, text: '입력자'				, type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: '입력일'				, type: 'uniDate'},
			{name: 'UPDATE_DB_USER'		, text: '수정자'				, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '수정일'				, type: 'uniDate'},
			{name: 'FR_BUDG_YYYYMM'		, text: 'FR_BUDG_YYYYMM'	, type: 'uniDate'},
			{name: 'DATA_TYPE'			, text: 'DATA_TYPE'			, type: 'string'}
	    ];
					
		Ext.each(budgNameList, function(item, index) {
			var name = 'BUDG_NAME_L'+(index + 1);
			fields.push({name: name, text: item.CODE_NAME, type:'string' });
		});
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(budgNameList) {
		var columns = [        
//        	{dataIndex: 'COMP_CODE'					, width: 100, hidden: true}, 	
//			{dataIndex: 'AC_YYYY'					, width: 100, hidden: true}, 	
//			{dataIndex: 'DEPT_CODE'					, width: 120, hidden: true}, 	
			{dataIndex: 'BUDG_CODE'					, width: 133,
	    		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
	        	}
	        } 
			// 예산명(쿼리읽어서 컬럼 셋팅)
		];
		// 예산명(쿼리읽어서 컬럼 셋팅)
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_L'+(index + 1);
			columns.push({dataIndex: dataIndex,		width: 110});	
		});
//		columns.push({dataIndex: 'CAL_DIVI'					, width: 100, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_GUBUN'    			, width: 106, hidden: true});
//		columns.push({dataIndex: 'GUBUN'    				, width: 106, hidden: true});
//		columns.push({dataIndex: 'GUBUN_NAME'    			, width: 106, hidden: true});
		columns.push({dataIndex: 'BUDG_CONF_I'   			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I01' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I02' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I03' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I04' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I05' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I06' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I07' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I08' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I09' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I10' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I11' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I12' 			, width: 106, summaryType: 'sum'});
//		columns.push({dataIndex: 'BUDG_I01'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I02'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I03'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I04'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I05'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I06'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I07'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I08'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I09'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I10'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I11'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I12'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'INSERT_DB_USER'			, width: 85, hidden: true}); 
//		columns.push({dataIndex: 'INSERT_DB_TIME'			, width: 85, hidden: true}); 
//		columns.push({dataIndex: 'UPDATE_DB_USER'			, width: 85, hidden: true}); 
//		columns.push({dataIndex: 'UPDATE_DB_TIME'			, width: 85, hidden: true}); 
//		columns.push({dataIndex: 'FR_BUDG_YYYYMM'			, width: 85, hidden: true}); 
//		columns.push({dataIndex: 'DATA_TYPE'				, width: 85, hidden: true}); 
		return columns;
	}	
	
	// 모델필드 생성
	function createModelField2(budgNameList) {
		var fields = [
//			{name: 'CHOICE'				, text: '선택'				, type: 'boolean'},
			{name: 'COMP_CODE'			, text: '법인코드'				, type: 'string'},
			{name: 'AC_YYYY'			, text: '사업년도'				, type: 'string'},
			{name: 'DEPT_CODE'			, text: '부서코드'				, type: 'string'},
			{name: 'BUDG_CODE'			, text: '예산과목'				, type: 'string'},
			// 예산명(쿼리읽어서 컬럼 셋팅)
			{name: 'CAL_DIVI'			, text: '계산방법'				, type: 'string'},
			{name: 'BUDG_I01'			, text: '1월'				, type: 'uniPrice'},
			{name: 'BUDG_I02'			, text: '2월'				, type: 'uniPrice'},
			{name: 'BUDG_I03'			, text: '3월'				, type: 'uniPrice'},
			{name: 'BUDG_I04'			, text: '4월'				, type: 'uniPrice'},
			{name: 'BUDG_I05'			, text: '5월'				, type: 'uniPrice'},
			{name: 'BUDG_I06'			, text: '6월'				, type: 'uniPrice'},
			{name: 'BUDG_I07'			, text: '7월'				, type: 'uniPrice'},
			{name: 'BUDG_I08'			, text: '8월'				, type: 'uniPrice'},
			{name: 'BUDG_I09'			, text: '9월'				, type: 'uniPrice'},
			{name: 'BUDG_I10'			, text: '10월'				, type: 'uniPrice'},
			{name: 'BUDG_I11'			, text: '11월'				, type: 'uniPrice'},
			{name: 'BUDG_I12'			, text: '12월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I'		, text: '년차예산'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I01'		, text: '1월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I02'		, text: '2월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I03'		, text: '3월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I04'		, text: '4월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I05'		, text: '5월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I06'		, text: '6월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I07'		, text: '7월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I08'		, text: '8월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I09'		, text: '9월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I10'		, text: '10월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I11'		, text: '11월'				, type: 'uniPrice'},
			{name: 'BUDG_CONF_I12'		, text: '12월'				, type: 'uniPrice'},
			{name: 'INSERT_DB_USER'		, text: '입력자'				, type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: '입력일'				, type: 'uniDate'},
			{name: 'UPDATE_DB_USER'		, text: '수정자'				, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '수정일'				, type: 'uniDate'},
			{name: 'FR_BUDG_YYYYMM'		, text: 'FR_BUDG_YYYYMM'	, type: 'uniDate'},
			{name: 'DATA_TYPE'			, text: 'DATA_TYPE'			, type: 'string'}
	    ];
					
		Ext.each(budgNameList, function(item, index) {
			var name = 'BUDG_NAME_L'+(index + 1);
			fields.push({name: name, text: item.CODE_NAME, type:'string' });
		});
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn2(budgNameList) {
		var columns = [    
//        	{dataIndex: 'CHOICE'					, width: 50, xtype : 'checkcolumn'},    
//        	{dataIndex: 'COMP_CODE'					, width: 100, hidden: true}, 	
//			{dataIndex: 'AC_YYYY'					, width: 100, hidden: true}, 	
//			{dataIndex: 'DEPT_CODE'					, width: 120, hidden: true}, 	
			{dataIndex: 'BUDG_CODE'					, width: 133,
	    		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
	        	}
	        } 
			// 예산명(쿼리읽어서 컬럼 셋팅)
		];
		// 예산명(쿼리읽어서 컬럼 셋팅)
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_L'+(index + 1);
			columns.push({dataIndex: dataIndex,		width: 110});	
		});
//		columns.push({dataIndex: 'CAL_DIVI'					, width: 100, hidden: true}); 
//		columns.push({dataIndex: 'GUBUN_NAME'    			, width: 106, hidden: true});
		columns.push({dataIndex: 'BUDG_CONF_I'   			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I01' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I02' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I03' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I04' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I05' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I06' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I07' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I08' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I09' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I10' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I11' 			, width: 106, summaryType: 'sum'});
		columns.push({dataIndex: 'BUDG_CONF_I12' 			, width: 106, summaryType: 'sum'});
//		columns.push({dataIndex: 'BUDG_I01'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I02'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I03'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I04'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I05'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I06'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I07'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I08'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I09'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I10'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I11'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'BUDG_I12'					, width: 106, hidden: true}); 
//		columns.push({dataIndex: 'INSERT_DB_USER'			, width: 85, hidden: true}); 
//		columns.push({dataIndex: 'INSERT_DB_TIME'			, width: 85, hidden: true}); 
//		columns.push({dataIndex: 'UPDATE_DB_USER'			, width: 85, hidden: true}); 
//		columns.push({dataIndex: 'UPDATE_DB_TIME'			, width: 85, hidden: true}); 
//		columns.push({dataIndex: 'FR_BUDG_YYYYMM'			, width: 85, hidden: true}); 
//		columns.push({dataIndex: 'DATA_TYPE'				, width: 85, hidden: true}); 
		return columns;
	}
	
	Unilite.createValidator('validator01', {
		store: masterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "BUDG_CONF_I" :			// 년차예산
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_CONF_I01',(newValue % 12) + Math.floor((newValue / 12)));
					//record.set('BUDG_I01',Math.floor(newValue / 12));
					record.set('BUDG_CONF_I02',Math.floor(newValue / 12));
					record.set('BUDG_CONF_I03',Math.floor(newValue / 12));
					record.set('BUDG_CONF_I04',Math.floor(newValue / 12));
					record.set('BUDG_CONF_I05',Math.floor(newValue / 12));
					record.set('BUDG_CONF_I06',Math.floor(newValue / 12));
					record.set('BUDG_CONF_I07',Math.floor(newValue / 12));
					record.set('BUDG_CONF_I08',Math.floor(newValue / 12));
					record.set('BUDG_CONF_I09',Math.floor(newValue / 12));
					record.set('BUDG_CONF_I10',Math.floor(newValue / 12));
					record.set('BUDG_CONF_I11',Math.floor(newValue / 12));
					record.set('BUDG_CONF_I12',Math.floor(newValue / 12));
				break;
				
				case "BUDG_CONF_I01" :		// 01월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_CONF_I',(newValue + record.get('BUDG_CONF_I02') + record.get('BUDG_CONF_I03') + record.get('BUDG_CONF_I04') + record.get('BUDG_CONF_I05') + record.get('BUDG_CONF_I06')
										  + record.get('BUDG_CONF_I07') + record.get('BUDG_CONF_I08') + record.get('BUDG_CONF_I09') + record.get('BUDG_CONF_I10') + record.get('BUDG_CONF_I11') + record.get('BUDG_CONF_I12')));
				break;
				
				case "BUDG_CONF_I02" :		// 02월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_CONF_I',(record.get('BUDG_CONF_I01') + newValue + record.get('BUDG_CONF_I03') + record.get('BUDG_CONF_I04') + record.get('BUDG_CONF_I05') + record.get('BUDG_CONF_I06')
										  + record.get('BUDG_CONF_I07') + record.get('BUDG_CONF_I08') + record.get('BUDG_CONF_I09') + record.get('BUDG_CONF_I10') + record.get('BUDG_CONF_I11') + record.get('BUDG_CONF_I12')));
				break;
				
				case "BUDG_CONF_I03" :		// 03월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_CONF_I',(record.get('BUDG_CONF_I01') + record.get('BUDG_CONF_I02') + newValue + record.get('BUDG_CONF_I04') + record.get('BUDG_CONF_I05') + record.get('BUDG_CONF_I06')
										  + record.get('BUDG_CONF_I07') + record.get('BUDG_CONF_I08') + record.get('BUDG_CONF_I09') + record.get('BUDG_CONF_I10') + record.get('BUDG_CONF_I11') + record.get('BUDG_CONF_I12')));
				break;
				
				case "BUDG_CONF_I04" :		// 04월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_CONF_I',(record.get('BUDG_CONF_I01') + record.get('BUDG_CONF_I02') + record.get('BUDG_CONF_I03') + newValue + record.get('BUDG_CONF_I05') + record.get('BUDG_CONF_I06')
										  + record.get('BUDG_CONF_I07') + record.get('BUDG_CONF_I08') + record.get('BUDG_CONF_I09') + record.get('BUDG_CONF_I10') + record.get('BUDG_CONF_I11') + record.get('BUDG_CONF_I12')));
				break;
				
				case "BUDG_CONF_I05" :		// 05월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_CONF_I',(record.get('BUDG_CONF_I01') + record.get('BUDG_CONF_I02') + record.get('BUDG_CONF_I03') + record.get('BUDG_CONF_I04') + newValue + record.get('BUDG_CONF_I06')
										  + record.get('BUDG_CONF_I07') + record.get('BUDG_CONF_I08') + record.get('BUDG_CONF_I09') + record.get('BUDG_CONF_I10') + record.get('BUDG_CONF_I11') + record.get('BUDG_CONF_I12')));
				break;
				
				case "BUDG_I06" :		// 06월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_CONF_I',(record.get('BUDG_CONF_I01') + record.get('BUDG_CONF_I02') + record.get('BUDG_CONF_I03') + record.get('BUDG_CONF_I04') + record.get('BUDG_CONF_I05') + newValue
										  + record.get('BUDG_CONF_I07') + record.get('BUDG_CONF_I08') + record.get('BUDG_CONF_I09') + record.get('BUDG_CONF_I10') + record.get('BUDG_CONF_I11') + record.get('BUDG_CONF_I12')));
				break;
				
				case "BUDG_CONF_I07" :		// 07월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_CONF_I',(record.get('BUDG_CONF_I01') + record.get('BUDG_CONF_I02') + record.get('BUDG_CONF_I03') + record.get('BUDG_CONF_I04') + record.get('BUDG_CONF_I05')+ record.get('BUDG_CONF_I06')
										   + newValue + record.get('BUDG_CONF_I08') + record.get('BUDG_CONF_I09') + record.get('BUDG_CONF_I10') + record.get('BUDG_CONF_I11') + record.get('BUDG_CONF_I12')));
				break;
				
				case "BUDG_CONF_I08" :		// 08월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_CONF_I',(record.get('BUDG_CONF_I01') + record.get('BUDG_CONF_I02') + record.get('BUDG_CONF_I03') + record.get('BUDG_CONF_I04') + record.get('BUDG_CONF_I05')+ record.get('BUDG_CONF_I06')
										   + record.get('BUDG_CONF_I07') + newValue + record.get('BUDG_CONF_I09') + record.get('BUDG_CONF_I10') + record.get('BUDG_CONF_I11') + record.get('BUDG_CONF_I12')));
				break;
				
				case "BUDG_CONF_I09" :		// 09월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_CONF_I',(record.get('BUDG_CONF_I01') + record.get('BUDG_CONF_I02') + record.get('BUDG_CONF_I03') + record.get('BUDG_CONF_I04') + record.get('BUDG_CONF_I05')+ record.get('BUDG_CONF_I06')
										   + record.get('BUDG_CONF_I07') + record.get('BUDG_CONF_I08') + newValue + record.get('BUDG_CONF_I10') + record.get('BUDG_CONF_I11') + record.get('BUDG_CONF_I12')));
				break;
				
				case "BUDG_I10" :		// 10월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_CONF_I',(record.get('BUDG_CONF_I01') + record.get('BUDG_CONF_I02') + record.get('BUDG_CONF_I03') + record.get('BUDG_CONF_I04') + record.get('BUDG_CONF_I05')+ record.get('BUDG_CONF_I06')
										   + record.get('BUDG_CONF_I07') + record.get('BUDG_CONF_I08') + record.get('BUDG_CONF_I09') + newValue + record.get('BUDG_CONF_I11') + record.get('BUDG_CONF_I12')));
				break;
				
				case "BUDG_CONF_I11" :		// 11월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_CONF_I',(record.get('BUDG_CONF_I01') + record.get('BUDG_CONF_I02') + record.get('BUDG_CONF_I03') + record.get('BUDG_CONF_I04') + record.get('BUDG_CONF_I05')+ record.get('BUDG_CONF_I06')
										   + record.get('BUDG_CONF_I07') + record.get('BUDG_CONF_I08') + record.get('BUDG_CONF_I09') + record.get('BUDG_CONF_I10') + newValue + record.get('BUDG_CONF_I12')));
				break;
				
				case "BUDG_CONF_I12" :		// 12월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_CONF_I',(record.get('BUDG_CONF_I01') + record.get('BUDG_CONF_I02') + record.get('BUDG_CONF_I03') + record.get('BUDG_CONF_I04') + record.get('BUDG_CONF_I05')+ record.get('BUDG_CONF_I06')
										   + record.get('BUDG_CONF_I07') + record.get('BUDG_CONF_I08') + record.get('BUDG_CONF_I09') + record.get('BUDG_CONF_I10') + record.get('BUDG_CONF_I11') + newValue));
				break;
			}
			return rv;
		}
	})
};
</script>
