<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb530ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb530ukr" /> 	<!-- 사업장 --> 
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
	var getStDt 	 	= ${getStDt};
	var getToDt 	 	= ${getToDt};
	var budgNameList 	= ${budgNameList};
	var chargeInfoList 	= ${chargeInfoList};
	var fields		 	= createModelField(budgNameList);
	var columns		 	= createGridColumn(budgNameList);
	var fields2		 	= createModelField2(budgNameList);
	var columns2	 	= createGridColumn2(budgNameList);
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb530ukrService.selectList',
			update: 'afb530ukrService.updateDetail',
			create: 'afb530ukrService.insertDetail',
			destroy: 'afb530ukrService.deleteDetail',
			syncAll: 'afb530ukrService.saveAll'
		}
	});
	
	Unilite.defineModel('Afb510Model', {
		fields:fields
	});		// End of Ext.define('afb530ukrModel', {
	
	Unilite.defineModel('Afb510Model2', {
	   fields:fields2
	});
	  
	/* Store 정의(Service 정의) @type
	 */					
	var MasterStore = Unilite.createStore('Afb510MasterStore',{
		model: 'Afb510Model',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
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
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
       		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						/*var master = batch.operations[0].getResultSet();
						panelSearch.setValue("ORDER_NUM", master.ORDER_NUM);*/
						//3.기타 처리
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
					} 
				};
				this.syncAllDirect(config);
			} else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	var MasterStore2 = Unilite.createStore('Afb510MasterStore2',{
		model: 'Afb510Model2',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'afb530ukrService.selectList2'                	
            }
        },
        listeners:{
        	load:function(store, records, successful, eOpts) {
        		if(successful)	{
        		   var masterRecords = MasterStore.data.filterBy(MasterStore.filterNewOnly);  
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
			var BUDG_YYYYMM_PLUS = UniDate.add(panelSearch.getValue('BUDG_YYYYMM'), {months:+1}) 
			BUDG_YYYYMM_PLUS = UniDate.getDbDateStr(BUDG_YYYYMM_PLUS)										//날짜형식 YYYYMMDD로 변환
			BUDG_YYYYMM_PLUS = BUDG_YYYYMM_PLUS.substring(0,6)												//날짜형식 YYYYMM으로 자르기
			param.BUDG_YYYYMM_PLUS = BUDG_YYYYMM_PLUS
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
		    		fieldLabel: '예산년월', 
		    		xtype: 'uniMonthfield',
		    		name: 'BUDG_YYYYMM',
	    			allowBlank: false,
					listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				      		panelResult.setValue('BUDG_YYYYMM', newValue);
							UniAppManager.app.fnSetStDate(newValue);
//							UniAppManager.app.fnSetStDate2(newValue);
							UniAppManager.app.fnSetToDate(newValue);
				     	}
				    }
		    	},
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
							},
							applyextparam: function(popup){							
								popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('BUDG_YYYYMM'))});
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
		            holdable: 'hold',
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
					hidden: true,
					width: 200
				},{ 
	    			fieldLabel: '당기종료년월',
	    			name:'TO_DATE',
					xtype: 'uniMonthfield',
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
		}
	});	// end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
	    		fieldLabel: '예산년월', 
	    		xtype: 'uniMonthfield',
	    		name: 'BUDG_YYYYMM',
	    		allowBlank: false,
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			      		panelSearch.setValue('BUDG_YYYYMM', newValue);
						UniAppManager.app.fnSetStDate(newValue);
//						UniAppManager.app.fnSetStDate2(newValue);
						UniAppManager.app.fnSetToDate(newValue);
			     	}
			    }
	    	},
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
							panelSearch.setValue('BUDG_CODE', '');
							panelSearch.setValue('BUDG_NAME', '');
							panelResult.setValue('BUDG_CODE', '');
							panelResult.setValue('BUDG_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('BUDG_YYYYMM'))});
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
	            holdable: 'hold',
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
	
	var otherSearch = Unilite.createSearchForm('otherorderForm', {		// 예산 참조
    	layout : {type : 'uniTable', columns : 2},
        items:[{
	    		fieldLabel: '예산년월', 
	    		xtype: 'uniMonthfield',
	    		name: 'BUDG_YYYYMM',
	            readOnly: true
	    	},{
	            xtype: 'uniCombobox',
	            name: 'BUDG_TYPE',
	            comboType:'AU',
				comboCode:'A132',
	            fieldLabel: '수지구분',
            	value: '2',
	            holdable: 'hold',
	            allowBlank:false,
	            readOnly: true
	         },
	         Unilite.popup('BUDG',{
			        fieldLabel: '예산과목',
				    valueFieldName:'BUDG_CODE_FR',
				    textFieldName:'BUDG_NAME_FR',
					applyextparam: function(popup){							
						popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('BUDG_YYYYMM'))});
						popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
					}
		    }),
	         Unilite.popup('BUDG',{
			        fieldLabel: '~',
			        labelWidth: 15,
				    valueFieldName:'BUDG_CODE_TO',
				    textFieldName:'BUDG_NAME_TO',
					applyextparam: function(popup){							
						popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('BUDG_YYYYMM'))});
						popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
					}
		    }),
	         Unilite.popup('DEPT',{
			        fieldLabel: '부서',
				    valueFieldName:'DEPT_CODE_FR',
				    textFieldName:'DEPT_NAME_FR'
		    }),
	         Unilite.popup('DEPT',{
			        fieldLabel: '~',
			        labelWidth: 15,
				    valueFieldName:'DEPT_CODE_TO',
				    textFieldName:'DEPT_NAME_TO'
		    }),{ 
    			fieldLabel: '당기시작년월',
    			name:'ST_DATE',
				xtype: 'uniTextfield',
				holdable:'hold',
				hidden: true,
				width: 200
			},{ 
    			fieldLabel: '당기종료년월',
    			name:'TO_DATE',
				xtype: 'uniMonthfield',
				holdable:'hold',
				hidden: true,
				width: 200
			}
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
					text: '예산 참조',
					handler: function() {
						openotherWindow();
					}
				}]
			})
		}],	
		selModel: 'rowmodel',
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
		store: MasterStore,
        uniOpt: {
            expandLastColumn: false,
            useRowNumberer: false,
            copiedRow: true
        },
        columns:columns,
        listeners: {
//	        beforeedit  : function( editor, e, eOpts ) {
//	        	if(!e.record.phantom) {
//	        		if(UniUtils.indexOf(e.field, ['BUDG_CONF_I', 'BUDG_CONF_I01', 'BUDG_CONF_I02', 'BUDG_CONF_I03', 'BUDG_CONF_I04', 'BUDG_CONF_I05', 'BUDG_CONF_I06',
//	        									  'BUDG_CONF_I07', 'BUDG_CONF_I08', 'BUDG_CONF_I09', 'BUDG_CONF_I10', 'BUDG_CONF_I11', 'BUDG_CONF_I12'])) 
//					{ 
//						return true;
//      				} else {
//      					return false;
//      				}
//	        	} else {
//	        		if(UniUtils.indexOf(e.field, ['BUDG_CONF_I', 'BUDG_CONF_I01', 'BUDG_CONF_I02', 'BUDG_CONF_I03', 'BUDG_CONF_I04', 'BUDG_CONF_I05', 'BUDG_CONF_I06',
//	        									  'BUDG_CONF_I07', 'BUDG_CONF_I08', 'BUDG_CONF_I09', 'BUDG_CONF_I10', 'BUDG_CONF_I11', 'BUDG_CONF_I12']))
//				   	{
//						return true;
//      				} else {
//      					return false;
//      				}
//	        	}
//	        }
		},
		setEstiData: function(record) {						// 이동출고참조 셋팅
       		var grdRecord = this.getSelectedRecord();
       		grdRecord.set('COMP_CODE'		, UserInfo.compCode);
			Ext.each(budgNameList, function(item, index) {
				var name = 'BUDG_NAME_L'+(index + 1);
				grdRecord.set(name	,record[name]);
			});
			grdRecord.set('BUDG_YYYYMM'		, record['BUDG_YYYYMM']);
			grdRecord.set('DEPT_CODE'		, record['DEPT_CODE']);
			grdRecord.set('DEPT_NAME'		, record['DEPT_NAME']);
			grdRecord.set('BUDG_CODE'		, record['BUDG_CODE']);
			grdRecord.set('BUDG_NAME'		, record['BUDG_NAME']);
			grdRecord.set('IWALL_YYYYMM'	, record['IWALL_YYYYMM']);
			grdRecord.set('IWALL_AMT_I'		, record['BUDG_AMT_I']);
			grdRecord.set('IWALL_DATE'		, UniDate.get('today'));
			grdRecord.set('USER_CODE'		, chargeInfoList[0].CHARGE_CODE);
			grdRecord.set('USER_NAME'		, chargeInfoList[0].CHARGE_NAME);
		}                
    });
    
    function openotherWindow() {    	//편성예산 참조	
  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		otherSearch.setValue('BUDG_YYYYMM', panelSearch.getValue('BUDG_YYYYMM'));
  		otherSearch.setValue('BUDG_CODE_FR', panelSearch.getValue('BUDG_CODE'));
  		otherSearch.setValue('BUDG_NAME_FR', panelSearch.getValue('BUDG_ANME'));
  		otherSearch.setValue('BUDG_CODE_TO', panelSearch.getValue('BUDG_CODE'));
  		otherSearch.setValue('BUDG_NAME_TO', panelSearch.getValue('BUDG_NAME'));
  		otherSearch.setValue('ST_DATE', panelSearch.getValue('ST_DATE'));
  		otherSearch.setValue('TO_DATE', panelSearch.getValue('TO_DATE'));
  		otherSearch.setValue('BUDG_TYPE', panelSearch.getValue('BUDG_TYPE'));   
  		otherSearch.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));  
  		otherSearch.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));  		
  		MasterStore2.loadStoreRecords();
  		
		if(!otherWindow) {
			otherWindow = Ext.create('widget.uniDetailWindow', {
                title: '예산참조',
                width: 1000,				                
                height: 650,
                layout:{type:'vbox', align:'stretch'},
                
                items: [otherSearch, otherGrid],
                tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							MasterStore2.loadStoreRecords();
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
					},{
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
				  		otherSearch.setValue('BUDG_CODE_FR', panelSearch.getValue('BUDG_CODE'));
				  		otherSearch.setValue('BUDG_NAME_FR', panelSearch.getValue('BUDG_NAME'));
				  		otherSearch.setValue('BUDG_CODE_TO', panelSearch.getValue('BUDG_CODE'));
				  		otherSearch.setValue('BUDG_NAME_TO', panelSearch.getValue('BUDG_NAME'));
				  		otherSearch.setValue('BUDG_TYPE', panelSearch.getValue('BUDG_TYPE'));   
				  		otherSearch.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));  
				  		otherSearch.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME')); 
				  		otherSearch.setValue('ST_DATE', panelSearch.getValue('ST_DATE'));
				  		otherSearch.setValue('TO_DATE', panelSearch.getValue('TO_DATE')); 		
				  		MasterStore2.loadStoreRecords();
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
    			showSummaryRow: false
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',			
    			showSummaryRow: false
    		}
    	],
    	layout : 'fit',
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
		store: MasterStore2,
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
        listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(!e.record.phantom) {
	        		if(UniUtils.indexOf(e.field, ['BUDG_CODE', 'BUDG_NAME', 'BUDG_TOT_I'])) 
					{ 
						return false;
      				} else {
      					return true;
      				}
	        	} else {
	        		if(UniUtils.indexOf(e.field, ['BUDG_CODE', 'BUDG_NAME', 'BUDG_TOT_I']))
				   	{
						return false;
      				} else {
      					return true;
      				}
	        	}
	        }

        },
       	returnData: function()	{
			//masterGrid.reset();
       		var records = this.getSelectedRecords();
       		Ext.each(records, function(record,i) {	
		       	UniAppManager.app.onNewDataButtonDown();
		       	masterGrid.setEstiData(record.data);								        
		    }); 
			this.getStore().remove(records);
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
		id : 'Afb510App',
		fnInitBinding : function() {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('BUDG_YYYYMM');
			panelSearch.setValue('BUDG_YYYYMM', UniDate.get('today'));
			panelResult.setValue('BUDG_YYYYMM', UniDate.get('today'));
			panelSearch.setValue('ST_DATE',getStDt[0].STDT.substring(0, 4));
			panelSearch.setValue('TO_DATE',getToDt[0].STDT.substring(0, 6));
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
			MasterStore.loadStoreRecords();
//			UniAppManager.setToolbarButtons(['reset', 'delete'], true);
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			MasterStore.saveStore();
//			MasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
//			return panelSearch.setAllFieldsReadOnly(false);
//			return panelResult.setAllFieldsReadOnly(false);
//			panelSearch.clearForm();
//			panelResult.clearForm();
//			otherSearch.clearForm();
//			masterGrid.reset();
//			otherGrid.reset();
//			MasterStore.removeAll();
//			MasterStore2.removeAll();
//			this.fnInitBinding();
			return panelSearch.setAllFieldsReadOnly(false);
			return panelResult.setAllFieldsReadOnly(false);
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			MasterStore.removeAll();
			this.fnInitBinding();
		},
		onNewDataButtonDown: function()	{		// 행추가 
			var budgYyyyMm    		= '';	   
			var deptCode      		= '';	   
			var deptName      		= '';	   
			var budgCode      		= '';	   
			var budgName      		= '';	   
			var iwallAmtI     		= '';	   
			var iwallYyyyMm   		= '';	   
			var iwallDate      		= '';	      
			
			var r = {
				'BUDG_YYYYMM' 	: budgYyyyMm,
				'DEPT_CODE' 	: deptCode,
				'DEPT_NAME' 	: deptName,
				'BUDG_CODE' 	: budgCode,
				'BUDG_NAME' 	: budgName,
				'IWALL_AMT_I' 	: iwallAmtI,
				'IWALL_YYYYMM' 	: iwallYyyyMm,
				'IWALL_DATE' 	: iwallDate
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
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1);
					otherSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1);
				}else{
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4));
					otherSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4));
				}
			}
        },
        fnSetToDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
	    		panelSearch.setValue('TO_DATE', getToDt[0].STDT.substring(0, 6));
	    		otherSearch.setValue('TO_DATE', getToDt[0].STDT.substring(0, 6));
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
			{name: 'BUDG_YYYYMM'			, text: '예산년월'				, type: 'string'},
			{name: 'DEPT_CODE'				, text: '부서'				, type: 'string'},
			{name: 'DEPT_NAME'				, text: '부서명'				, type: 'string'},
			{name: 'USER_CODE'				, text: 'USER_CODE'			, type: 'string'},
			{name: 'UPDATE_DB_USER'			, text: '수정자'				, type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '수정일'				, type: 'uniDate'},
			{name: 'BUDG_CODE'				, text: '예산코드'				, type: 'string'},
			{name: 'BUDG_NAME'				, text: '예산코드명'			, type: 'string'},
			// 예산명(쿼리읽어서 컬럼 셋팅)
			{name: 'IWALL_YYYYMM'			, text: '이월년월'				, type: 'string'},
			{name: 'IWALL_AMT_I'			, text: '이월예산금액'			, type: 'uniPrice'},
			{name: 'IWALL_DATE'				, text: '이월일자'				, type: 'uniDate'},
			{name: 'USER_NAME'				, text: '이월담당자'			, type: 'string'},
			{name: 'COMP_CODE'				, text: '법인코드'				, type: 'string'}
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
//			{dataIndex: 'BUDG_YYYYMM'					, width: 120},
			{dataIndex: 'DEPT_CODE'						, width: 80},
			{dataIndex: 'DEPT_NAME'						, width: 200},
//			{dataIndex: 'USER_CODE'						, width: 120},
//			{dataIndex: 'UPDATE_DB_USER'				, width: 120},
//			{dataIndex: 'UPDATE_DB_TIME'				, width: 120},
			{dataIndex: 'BUDG_CODE'						, width: 133},
			{dataIndex: 'BUDG_NAME'		    			, width: 200}
			// 예산명(쿼리읽어서 컬럼 셋팅)
		];
		// 예산명(쿼리읽어서 컬럼 셋팅)
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_L'+(index + 1);
			columns.push({dataIndex: dataIndex,		width: 110});	
		});
		columns.push({dataIndex: 'IWALL_YYYYMM'			, width: 80}); 
		columns.push({dataIndex: 'IWALL_AMT_I'			, width: 133}); 
		columns.push({dataIndex: 'IWALL_DATE'			, width: 80}); 
		columns.push({dataIndex: 'USER_NAME'			, width: 150}); 
//		columns.push({dataIndex: 'COMP_CODE'			, width: 100}); 
		return columns;
	}	
	
	// 모델필드 생성
	function createModelField2(budgNameList) {
		var fields = [
			{name: 'BUDG_YYYYMM'		, text: '예산년월'				, type: 'string'},
			{name: 'DEPT_CODE'			, text: '부서'				, type: 'string', maxLength: 7},
			{name: 'DEPT_NAME'			, text: '부서명'				, type: 'string', maxLength: 7},
			{name: 'BUDG_CODE'			, text: '예산코드'				, type: 'string'},
			{name: 'BUDG_NAME'			, text: '예산코드명'			, type: 'string'},
			// 예산명(쿼리읽어서 컬럼 셋팅)
			{name: 'BUDG_TOT_I'			, text: '이월가능예산'			, type: 'uniPrice'},
			{name: 'IWALL_YYYYMM'		, text: '이월년월'				, type: 'string', align: 'center'},
			{name: 'BUDG_AMT_I'			, text: '이월예산'				, type: 'uniPrice', maxLength: 13},
			{name: 'EDIT_YN	'			, text: 'EDIT_YN'			, type: 'string'},
			{name: 'COMP_CODE'			, text: '법인코드'				, type: 'string'}
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
//			{dataIndex: 'BUDG_YYYYMM'					, width: 120},
			{dataIndex: 'DEPT_CODE'						, width: 80},
			{dataIndex: 'DEPT_NAME'						, width: 200},
			{dataIndex: 'BUDG_CODE'						, width: 133},
			{dataIndex: 'BUDG_NAME'		    			, width: 200}
			// 예산명(쿼리읽어서 컬럼 셋팅)
		];
		// 예산명(쿼리읽어서 컬럼 셋팅)
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_L'+(index + 1);
			columns.push({dataIndex: dataIndex,		width: 110});	
		});
		columns.push({dataIndex: 'BUDG_TOT_I'				, width: 133}); 
		columns.push({dataIndex: 'IWALL_YYYYMM'				, width: 133, align: 'center'}); 
		columns.push({dataIndex: 'BUDG_AMT_I'				, width: 133}); 
//		columns.push({dataIndex: 'EDIT_YN	'				, width: 100}); 
//		columns.push({dataIndex: 'COMP_CODE'				, width: 100}); 
		return columns;
	}
	
	Unilite.createValidator('validator01', {
		store: MasterStore2,
		grid: otherGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "IWALL_YYYYMM" :		// 이월년월
					if(record.get('BUDG_YYYYMM').substring(0, 4) > newValue.substring(0, 4) || record.get('BUDG_YYYYMM').substring(0, 4) < newValue.substring(0, 4)) {
						alert("이월년월은 예산년도의 예산년월 사이에서 입력하십시오.");	
						break;
					} else if(panelSearch.getValue('BUDG_YYYYMM') >= newValue) {
						alert("이월년월이 예산년월보다 같거나 또는 예산년월보다 이전일 수 없습니다.");	
						break;
					}
				break;
				
				case "BUDG_AMT_I" :			// 이월예산
					if(record.get('BUDG_TOT_I') < newValue) {
						alert("이월예산금액이 이월가능금액보다 클 수 없습니다.");	
						break;
					}
				break;
			}
			return rv;
		}
	})
};
</script>