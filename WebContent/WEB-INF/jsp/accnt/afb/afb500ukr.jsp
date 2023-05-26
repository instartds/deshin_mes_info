<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb500ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb500ukr" /> 	<!-- 사업장 --> 
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
	var getStDt 	 = ${getStDt};
	var budgNameList = ${budgNameList};
	var fields	= createModelField(budgNameList);
	var columns	= createGridColumn(budgNameList);
	
	Unilite.defineModel('Afb500Model', {
		fields:fields
	});		// End of Ext.define('afb500ukrModel', {
	
	var directProxy= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read   : 'afb500ukrService.selectList'
			,create : 'afb500ukrService.insertDetail'
        	,update : 'afb500ukrService.updateDetail'
			,destroy: 'afb500ukrService.deleteDetail'
			,syncAll: 'afb500ukrService.saveAll'
		}
	});
	
	/* Store 정의(Service 정의) @type
	 */					
	var MasterStore = Unilite.createStore('Afb500MasterStore',{
		model: 'Afb500Model',
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
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		var recordsFirst = MasterStore.data.items[0];
				if(!Ext.isEmpty(recordsFirst)){
           			if(recordsFirst.data.DATA_TYPE == 'N') {
           				masterGrid.reset();
						MasterStore.clearData();
		           		Ext.each(records, function(record,i) {	
			        		UniAppManager.app.onNewDataButtonDown();
			        		masterGrid.setNewDataAFB500T(record.data);								        
				    	});
				    	UniAppManager.setToolbarButtons('save', false);	
           			}
           		}
			}
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
		            holdable: 'hold',
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
				        //validateBlank:false,
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
							applyextparam: function(popup) {							
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
				        //validateBlank:false,
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
							applyextparam: function(popup) {							
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
		            	holdable: 'hold',
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
	 		load: 'afb500ukrService.selectDeptBudg'	
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
            	holdable: 'hold',
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
			        //validateBlank:false,
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
						applyextparam: function(popup) {							
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
	            	holdable: 'hold',
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
					extParam: {'ADD_QUERY': "GROUP_YN = N'N' AND USE_YN = N'Y'"},
			        //validateBlank:false,
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
						applyextparam: function(popup) {							
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
	
    /* Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var masterGrid = Unilite.createGrid('Afb500Grid1', {
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
		store: MasterStore,
		uniOpt: {						
			useMultipleSorting	: true,			
		    useLiveSearch		: false,			
		    onLoadSelectFirst	: true,				
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
        columns:columns,
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(!e.record.phantom) {
	        		if(UniUtils.indexOf(e.field, ['BUDG_I', 'BUDG_I01', 'BUDG_I02', 'BUDG_I03', 'BUDG_I04', 'BUDG_I05', 'BUDG_I06',
	        									  'BUDG_I07', 'BUDG_I08', 'BUDG_I09', 'BUDG_I10', 'BUDG_I11', 'BUDG_I12'])) 
					{ 
						return true;
      				} else {
      					return false;
      				}
	        	} else {
	        		if(UniUtils.indexOf(e.field, ['BUDG_I', 'BUDG_I01', 'BUDG_I02', 'BUDG_I03', 'BUDG_I04', 'BUDG_I05', 'BUDG_I06',
	        									  'BUDG_I07', 'BUDG_I08', 'BUDG_I09', 'BUDG_I10', 'BUDG_I11', 'BUDG_I12']))
				   	{
						return true;
      				} else {
      					return false;
      				}
	        	}
	        }
		},
		setNewDataAFB500T: function(record) {
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('COMP_CODE'			,record['COMP_CODE']);
			grdRecord.set('AC_YYYY'				,record['AC_YYYY']);
			grdRecord.set('DEPT_CODE'			,record['DEPT_CODE']);
			grdRecord.set('BUDG_CODE'		   	,record['BUDG_CODE']);
			grdRecord.set('CAL_DIVI'			,record['CAL_DIVI']);
			Ext.each(budgNameList, function(item, index) {
				var name = 'BUDG_NAME_L'+(index + 1);
				grdRecord.set(name	,record[name]);
			});
			grdRecord.set('BUDG_I'				,record['BUDG_I']);
			grdRecord.set('BUDG_I01'			,record['BUDG_I01']);
			grdRecord.set('BUDG_I02'			,record['BUDG_I02']);
			grdRecord.set('BUDG_I03'			,record['BUDG_I03']);
			grdRecord.set('BUDG_I04'			,record['BUDG_I04']);
			grdRecord.set('BUDG_I05'			,record['BUDG_I05']);
			grdRecord.set('BUDG_I06'			,record['BUDG_I06']);
			grdRecord.set('BUDG_I07'			,record['BUDG_I07']);
			grdRecord.set('BUDG_I08'			,record['BUDG_I08']);
			grdRecord.set('BUDG_I09'			,record['BUDG_I09']);
			grdRecord.set('BUDG_I10'			,record['BUDG_I10']);
			grdRecord.set('BUDG_I11'			,record['BUDG_I11']);
			grdRecord.set('BUDG_I12'			,record['BUDG_I12']);
			grdRecord.set('INSERT_DB_USER'		,record['INSERT_DB_USER']);
			grdRecord.set('INSERT_DB_TIME'		,record['INSERT_DB_TIME']);
			grdRecord.set('UPDATE_DB_USER'		,record['UPDATE_DB_USER']);
			grdRecord.set('UPDATE_DB_TIME'		,record['UPDATE_DB_TIME']);
			grdRecord.set('FR_BUDG_YYYYMM'		,record['FR_BUDG_YYYYMM']);
			grdRecord.set('DATA_TYPE'			,record['DATA_TYPE']);
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
		id : 'Afb500App',
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
			panelSearch.setValue('BUDG_TYPE', '2');
			panelResult.setValue('BUDG_TYPE', '2');
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
			UniAppManager.setToolbarButtons('reset',true);
		},
		onResetButtonDown: function() {
			return panelSearch.setAllFieldsReadOnly(false);
			return panelResult.setAllFieldsReadOnly(false);
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			MasterStore.removeAll();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			MasterStore.saveStore();
//			MasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{		// 행추가
			var compCode		= '';	        
			var acYyyy			= '';	        
			var deptCode		= '';		    
			var budgCode		= '';         
			var calDivi			= '';
			var budgI			= 0;			
			var budgI01			= 0;	        
			var budgI02			= 0;	        
			var budgI03			= 0;	        
			var budgI04			= 0;	        
			var budgI05			= 0;	        
			var budgI06			= 0;	        
			var budgI07			= 0;	        
			var budgI08			= 0;	        
			var budgI09			= 0;	        
			var budgI10			= 0;	        
			var budgI11			= 0;	        
			var budgI12			= 0;	        
			var frBudgYyyyMm	= '';	    
			var dataType		= '';	        
			
			var r = {
				COMP_CODE		: compCode,	
				AC_YYYY			: acYyyy,	
				DEPT_CODE		: deptCode,		
				BUDG_CODE		: budgCode,    
				CAL_DIVI		: calDivi,		
				BUDG_I			: budgI,			
				BUDG_I01		: budgI01,	
				BUDG_I02		: budgI02,	
				BUDG_I03		: budgI03,	
				BUDG_I04		: budgI04,	
				BUDG_I05		: budgI05,	
				BUDG_I06		: budgI06,	
				BUDG_I07		: budgI07,	
				BUDG_I08		: budgI08,	
				BUDG_I09		: budgI09,	
				BUDG_I10		: budgI10,	
				BUDG_I11		: budgI11,	
				BUDG_I12		: budgI12,	
				FR_BUDG_YYYYMM	: frBudgYyyyMm,	
				DATA_TYPE		: dataType	
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
        }
	});
	
	// 모델필드 생성
	function createModelField(budgNameList) {
		var fields = [
			{name: 'COMP_CODE'			, text: '법인코드'				, type: 'string'},
			{name: 'AC_YYYY'			, text: '사업년도'				, type: 'string'},
			{name: 'DEPT_CODE'			, text: '부서코드'				, type: 'string'},
			{name: 'BUDG_CODE'			, text: '예산코드'				, type: 'string'},
			// 예산명(쿼리읽어서 컬럼 셋팅)
			{name: 'CAL_DIVI'			, text: '계산방법'				, type: 'string'},
			{name: 'BUDG_I'				, text: '년차예산'				, type: 'uniPrice'},
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
		columns.push({dataIndex: 'BUDG_I'					, width: 106, summaryType: 'sum'}); 
		columns.push({dataIndex: 'BUDG_I01'					, width: 106, summaryType: 'sum'}); 
		columns.push({dataIndex: 'BUDG_I02'					, width: 106, summaryType: 'sum'}); 
		columns.push({dataIndex: 'BUDG_I03'					, width: 106, summaryType: 'sum'}); 
		columns.push({dataIndex: 'BUDG_I04'					, width: 106, summaryType: 'sum'}); 
		columns.push({dataIndex: 'BUDG_I05'					, width: 106, summaryType: 'sum'}); 
		columns.push({dataIndex: 'BUDG_I06'					, width: 106, summaryType: 'sum'}); 
		columns.push({dataIndex: 'BUDG_I07'					, width: 106, summaryType: 'sum'}); 
		columns.push({dataIndex: 'BUDG_I08'					, width: 106, summaryType: 'sum'}); 
		columns.push({dataIndex: 'BUDG_I09'					, width: 106, summaryType: 'sum'}); 
		columns.push({dataIndex: 'BUDG_I10'					, width: 106, summaryType: 'sum'}); 
		columns.push({dataIndex: 'BUDG_I11'					, width: 106, summaryType: 'sum'}); 
		columns.push({dataIndex: 'BUDG_I12'					, width: 106, summaryType: 'sum'}); 
//		columns.push({dataIndex: 'INSERT_DB_USER'			, width: 85, hidden: true}); 
//		columns.push({dataIndex: 'INSERT_DB_TIME'			, width: 85, hidden: true}); 
//		columns.push({dataIndex: 'UPDATE_DB_USER'			, width: 85, hidden: true}); 
//		columns.push({dataIndex: 'UPDATE_DB_TIME'			, width: 85, hidden: true}); 
//		columns.push({dataIndex: 'FR_BUDG_YYYYMM'			, width: 85, hidden: true}); 
//		columns.push({dataIndex: 'DATA_TYPE'				, width: 85, hidden: true}); 
		return columns;
	}	
	
	Unilite.createValidator('validator01', {
		store: MasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if (newValue == "") newValue = 0;
			switch(fieldName) {
				case "BUDG_I" :			// 년차예산
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_I01',(newValue % 12) + Math.floor((newValue / 12)));
					//record.set('BUDG_I01',Math.floor(newValue / 12));
					record.set('BUDG_I02',Math.floor(newValue / 12));
					record.set('BUDG_I03',Math.floor(newValue / 12));
					record.set('BUDG_I04',Math.floor(newValue / 12));
					record.set('BUDG_I05',Math.floor(newValue / 12));
					record.set('BUDG_I06',Math.floor(newValue / 12));
					record.set('BUDG_I07',Math.floor(newValue / 12));
					record.set('BUDG_I08',Math.floor(newValue / 12));
					record.set('BUDG_I09',Math.floor(newValue / 12));
					record.set('BUDG_I10',Math.floor(newValue / 12));
					record.set('BUDG_I11',Math.floor(newValue / 12));
					record.set('BUDG_I12',Math.floor(newValue / 12));
				break;
				
				case "BUDG_I01" :		// 01월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_I',(newValue + record.get('BUDG_I02') + record.get('BUDG_I03') + record.get('BUDG_I04') + record.get('BUDG_I05') + record.get('BUDG_I06')
										  + record.get('BUDG_I07') + record.get('BUDG_I08') + record.get('BUDG_I09') + record.get('BUDG_I10') + record.get('BUDG_I11') + record.get('BUDG_I12')));
				break;
				
				case "BUDG_I02" :		// 02월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_I',(record.get('BUDG_I01') + newValue + record.get('BUDG_I03') + record.get('BUDG_I04') + record.get('BUDG_I05') + record.get('BUDG_I06')
										  + record.get('BUDG_I07') + record.get('BUDG_I08') + record.get('BUDG_I09') + record.get('BUDG_I10') + record.get('BUDG_I11') + record.get('BUDG_I12')));
				break;
				
				case "BUDG_I03" :		// 03월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_I',(record.get('BUDG_I01') + record.get('BUDG_I02') + newValue + record.get('BUDG_I04') + record.get('BUDG_I05') + record.get('BUDG_I06')
										  + record.get('BUDG_I07') + record.get('BUDG_I08') + record.get('BUDG_I09') + record.get('BUDG_I10') + record.get('BUDG_I11') + record.get('BUDG_I12')));
				break;
				
				case "BUDG_I04" :		// 04월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_I',(record.get('BUDG_I01') + record.get('BUDG_I02') + record.get('BUDG_I03') + newValue + record.get('BUDG_I05') + record.get('BUDG_I06')
										  + record.get('BUDG_I07') + record.get('BUDG_I08') + record.get('BUDG_I09') + record.get('BUDG_I10') + record.get('BUDG_I11') + record.get('BUDG_I12')));
				break;
				
				case "BUDG_I05" :		// 05월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_I',(record.get('BUDG_I01') + record.get('BUDG_I02') + record.get('BUDG_I03') + record.get('BUDG_I04') + newValue + record.get('BUDG_I06')
										  + record.get('BUDG_I07') + record.get('BUDG_I08') + record.get('BUDG_I09') + record.get('BUDG_I10') + record.get('BUDG_I11') + record.get('BUDG_I12')));
				break;
				
				case "BUDG_I06" :		// 06월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_I',(record.get('BUDG_I01') + record.get('BUDG_I02') + record.get('BUDG_I03') + record.get('BUDG_I04') + record.get('BUDG_I05') + newValue
										  + record.get('BUDG_I07') + record.get('BUDG_I08') + record.get('BUDG_I09') + record.get('BUDG_I10') + record.get('BUDG_I11') + record.get('BUDG_I12')));
				break;
				
				case "BUDG_I07" :		// 07월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_I',(record.get('BUDG_I01') + record.get('BUDG_I02') + record.get('BUDG_I03') + record.get('BUDG_I04') + record.get('BUDG_I05')+ record.get('BUDG_I06')
										   + newValue + record.get('BUDG_I08') + record.get('BUDG_I09') + record.get('BUDG_I10') + record.get('BUDG_I11') + record.get('BUDG_I12')));
				break;
				
				case "BUDG_I08" :		// 08월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_I',(record.get('BUDG_I01') + record.get('BUDG_I02') + record.get('BUDG_I03') + record.get('BUDG_I04') + record.get('BUDG_I05')+ record.get('BUDG_I06')
										   + record.get('BUDG_I07') + newValue + record.get('BUDG_I09') + record.get('BUDG_I10') + record.get('BUDG_I11') + record.get('BUDG_I12')));
				break;
				
				case "BUDG_I09" :		// 09월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_I',(record.get('BUDG_I01') + record.get('BUDG_I02') + record.get('BUDG_I03') + record.get('BUDG_I04') + record.get('BUDG_I05')+ record.get('BUDG_I06')
										   + record.get('BUDG_I07') + record.get('BUDG_I08') + newValue + record.get('BUDG_I10') + record.get('BUDG_I11') + record.get('BUDG_I12')));
				break;
				
				case "BUDG_I10" :		// 10월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_I',(record.get('BUDG_I01') + record.get('BUDG_I02') + record.get('BUDG_I03') + record.get('BUDG_I04') + record.get('BUDG_I05')+ record.get('BUDG_I06')
										   + record.get('BUDG_I07') + record.get('BUDG_I08') + record.get('BUDG_I09') + newValue + record.get('BUDG_I11') + record.get('BUDG_I12')));
				break;
				
				case "BUDG_I11" :		// 11월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_I',(record.get('BUDG_I01') + record.get('BUDG_I02') + record.get('BUDG_I03') + record.get('BUDG_I04') + record.get('BUDG_I05')+ record.get('BUDG_I06')
										   + record.get('BUDG_I07') + record.get('BUDG_I08') + record.get('BUDG_I09') + record.get('BUDG_I10') + newValue + record.get('BUDG_I12')));
				break;
				
				case "BUDG_I12" :		// 12월
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					record.set('BUDG_I',(record.get('BUDG_I01') + record.get('BUDG_I02') + record.get('BUDG_I03') + record.get('BUDG_I04') + record.get('BUDG_I05')+ record.get('BUDG_I06')
										   + record.get('BUDG_I07') + record.get('BUDG_I08') + record.get('BUDG_I09') + record.get('BUDG_I10') + record.get('BUDG_I11') + newValue));
				break;
			}
			return rv;
		}
	})
};
</script>