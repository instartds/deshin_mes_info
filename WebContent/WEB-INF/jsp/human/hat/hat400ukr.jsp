<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat400ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 --> 
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hat400ukrModel', {
		fields: [
			{name: 'DUTY_YYYYMMDD'			, text: '<t:message code="system.label.human.dutyyyymmdd" default="근무일"/>'	, type: 'uniDate', editable: false},
			{name: 'DIV_CODE'						, text: '<t:message code="system.label.human.division" default="사업장"/>'	, type: 'string', comboType: 'BOR120', editable: false},
			{name: 'DEPT_CODE'						, text: '<t:message code="system.label.human.department" default="부서"/>'	, type: 'string', editable: false},
			{name: 'DEPT_NAME'					, text: '<t:message code="system.label.human.deptname" default="부서명"/>'	, type: 'string', editable: false},
			{name: 'POST_CODE'						, text: '<t:message code="system.label.human.postcode" default="직위"/>'	, type: 'string', comboType:'AU', comboCode:'H005' , editable: false},
			{name: 'NAME'								, text: '<t:message code="system.label.human.name" default="성명"/>'	, type: 'string', editable: false},
			{name: 'PERSON_NUMB'				, text: '<t:message code="system.label.human.personnumb" default="사번"/>'	, type: 'string', editable: false},
			{name: 'WORK_TEAM'					, text: '<t:message code="system.label.human.workteam1" default="교대조"/>'	, type: 'string', comboType:'AU', comboCode:'H004'},
			{name: 'FLAG'									, text: 'FLAG'	, type: 'string', editable: false}
		]
	});//End of Unilite.defineModel('Hat400ukrModel', {
		
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'hat400ukrService.selectList',
			destroy: 'hat400ukrService.deleteHat400t',
			update: 'hat400ukrService.updateHat400t',
			syncAll: 'hat400ukrService.saveAll'
		}
	});	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hat400ukrMasterStore1', {
		model: 'Hat400ukrModel',
		uniOpt: {
			isMaster: true,		// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,		// 삭제 가능 여부 
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		listeners : {
	        load : function(store) {
	            if (store.getCount() > 1) {
	            	UniAppManager.setToolbarButtons('deleteAll', true);
	            }
	        }
	    },
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
		},saveStore : function(config)	{				
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{	
				directMasterStore.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		panelSearch.setValue('DVRY_DATE_FR_H', panelSearch.getValue('DVRY_DATE_FR'));
           		panelSearch.setValue('DVRY_DATE_TO_H', panelSearch.getValue('DVRY_DATE_TO'));
           		panelSearch.setValue('DIV_CODE_H', panelSearch.getValue('DIV_CODE'));
           		panelSearch.setValue('DEPT_CODE_H', panelSearch.getValue('DEPT_CODE'));
           		panelSearch.setValue('DEPT_NAME_H', panelSearch.getValue('DEPT_NAME'));
           		panelSearch.setValue('PAY_CODE_H', panelSearch.getValue('PAY_CODE'));
           		panelSearch.setValue('PAY_PROV_FLAG_H', panelSearch.getValue('PAY_PROV_FLAG'));
           		panelSearch.setValue('PAY_GUBUN_H', panelSearch.getValue('PAY_GUBUN'));
           		panelSearch.setValue('WORK_TEAM_H', panelSearch.getValue('WORK_TEAM'));
           		panelSearch.setValue('PERSON_NUMB_H', panelSearch.getValue('PERSON_NUMB'));
           		panelSearch.setValue('NAME_H', panelSearch.getValue('NAME'));
           	}
		}
	});//End of var directMasterStore = Unilite.createStore('hat400ukrMasterStore1', {

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',		
		region: 'west',
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
			title: '<t:message code="system.label.human.basisinfo" default="기본정보"/>', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{ 
				fieldLabel: '<t:message code="system.label.human.workprod" default="근무기간"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'DVRY_DATE_FR',
	        	endFieldName: 'DVRY_DATE_TO',
	        	width: 470,
	        	allowBlank: false,                	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('DVRY_DATE_FR', newValue);						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DVRY_DATE_TO', newValue);				    		
			    	}
			    }
	        },{
    			fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
    			name: 'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
    		},
				Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
					validateBlank: 'text',
					listeners: {
		//				onSelected: {
		//					fn: function(records, type) {
		//						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
		//						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
		//                	},
		//					scope: this
		//				},
		//				onClear: function(type)	{
		//					panelSearch.setValue('PERSON_NUMB', '');
		//					panelSearch.setValue('NAME', '');
		//				}
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_NAME', newValue);				
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
				name: 'PAY_CODE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H028',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
				name: 'PAY_PROV_FLAG', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H031',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_PROV_FLAG', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
				name: 'PAY_GUBUN', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H011',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_GUBUN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.workteam" default="근무조"/>',
				name: 'WORK_TEAM', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H004',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_TEAM', newValue);
					}
				}
			},			
		     	Unilite.popup('Employee',{ 
				
				autoPopup: true,
//				validateBlank: false,
				listeners: {
	//				onSelected: {
	//					fn: function(records, type) {
	//						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
	//						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
	//                	},
	//					scope: this
	//				},
	//				onClear: function(type)	{
	//					panelSearch.setValue('PERSON_NUMB', '');
	//					panelSearch.setValue('NAME', '');
	//				}
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			}),{ 
				fieldLabel: '<t:message code="system.label.human.workprod" default="근무기간"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'DVRY_DATE_FR_H',
	        	endFieldName: 'DVRY_DATE_TO_H',
	        	width: 470,
	        	hidden: true
	        },{
    			fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
    			name: 'DIV_CODE_H',
    			xtype: 'uniCombobox',
    			comboType: 'BOR120',
	        	hidden: true
    		},
				Unilite.popup('DEPT',{
	        		hidden: true,
	        		valueFieldName:'DEPT_CODE_H',
			    	textFieldName:'DEPT_NAME_H',
					listeners: {
		//				onSelected: {
		//					fn: function(records, type) {
		//						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
		//						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
		//                	},
		//					scope: this
		//				},
		//				onClear: function(type)	{
		//					panelSearch.setValue('PERSON_NUMB', '');
		//					panelSearch.setValue('NAME', '');
		//				}
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_NAME', newValue);				
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
				name: 'PAY_CODE_H', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H028',
				hidden: true
			},{
				fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
				name: 'PAY_PROV_FLAG_H', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H031',
				hidden: true
			},{
				fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
				name: 'PAY_GUBUN_H', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H011',
				hidden: true
			},{
				fieldLabel: '<t:message code="system.label.human.workteam" default="근무조"/>',
				name: 'WORK_TEAM_H', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H004',
				hidden: true
			},			
		     	Unilite.popup('Employee',{ 
				hidden: true,
        		valueFieldName:'PERSON_NUMB_H',
		    	textFieldName:'NAME_H'
			})]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '<t:message code="system.label.human.workprod" default="근무기간"/>',
        	xtype: 'uniDateRangefield',
        	startFieldName: 'DVRY_DATE_FR',
        	endFieldName: 'DVRY_DATE_TO',
        	width: 470,
        	allowBlank: false,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DVRY_DATE_FR', newValue);						
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DVRY_DATE_TO', newValue);				    		
		    	}
		    }
        },{
			fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
			Unilite.popup('DEPT',{
				fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
				validateBlank: 'text',
				listeners: {
	//				onSelected: {
	//					fn: function(records, type) {
	//						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
	//						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
	//                	},
	//					scope: this
	//				},
	//				onClear: function(type)	{
	//					panelSearch.setValue('PERSON_NUMB', '');
	//					panelSearch.setValue('NAME', '');
	//				}
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('DEPT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('DEPT_NAME', newValue);				
					}
				}
		}),{
			fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
			name: 'PAY_CODE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H028',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
			name: 'PAY_PROV_FLAG', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H031',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_PROV_FLAG', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
			name: 'PAY_GUBUN', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H011',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_GUBUN', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.human.workteam" default="근무조"/>',
			name: 'WORK_TEAM', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H004',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_TEAM', newValue);
				}
			}
		},			
	     	Unilite.popup('Employee',{ 
			
			autoPopup: true,
//			validateBlank: false,
			listeners: {
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
//						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
//                	},
//					scope: this
//				},
//				onClear: function(type)	{
//					panelSearch.setValue('PERSON_NUMB', '');
//					panelSearch.setValue('NAME', '');
//				}
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		})]	
    });
    
    var detailForm = Unilite.createSearchForm('hat400ukrDetailForm',{
		padding:'0 1 0 1',
		border:true,
		region: 'center',
	    items: [{	
	    	xtype:'container',
	        defaultType: 'uniTextfield',
//	        flex: 1,
	        layout: {
	        	type: 'uniTable',
	        	columns : 2
	        },
	        items: [{
				fieldLabel: '<t:message code="system.label.human.applyworkteam" default="적용근무조"/>',
				xtype: 'uniCombobox',
				name: 'apply_work_team',
				comboType: 'AU',
				comboCode: 'H004',
				allowBlank: false
			},{
				xtype: 'button',
				text: '<t:message code="system.label.human.allapply" default="전체적용"/>',
				margin: '0 0 0 10',
				handler: function(){
					var apply_work_team_value = detailForm.getValue('apply_work_team');
					if (apply_work_team_value == null) {
						Ext.Msg.alert('<t:message code="system.label.human.warntitle" default="경고"/>','<t:message code="system.message.human.message030" default="적용 할 근무조를 먼저 선택하여 주세요."/>');
					} else {
						Ext.Msg.confirm('<t:message code="system.label.human.allapply" default="전체적용"/>', '<t:message code="system.message.human.message031" default="전체 적용하시겠습니까?"/>', function(btn){
							if (btn == 'yes') {
								var param = panelSearch.getValues();
								param.WORK_TEAM = apply_work_team_value;
								hat400ukrService.workBatch(param, function(provider1, response)	{
									masterGrid.getStore().loadStoreRecords();
								});
//							var records = masterGrid.getStore().data.items;
//						 	Ext.each(records, function(rec, i){
//						 		var param = {DUTY_YYYYMMDD: UniDate.getDbDateStr(rec.get('DUTY_YYYYMMDD')), PERSON_NUMB: rec.get('PERSON_NUMB'), WORK_TEAM: apply_work_team_value}
//						 		
//						 	});
						 	
//							var selectedModel = masterGrid.getStore().getRange();
//							var records = masterGrid.getStore().data.items;
//							Ext.each(records, function(record,i){
//				            	record.set('WORK_TEAM2', apply_work_team_value);				            	
//							});
//							alert('Y');
//								UniAppManager.app.onSaveDataButtonDown();
							}
						});
					}			
				}
			}]
		}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('hat400ukrGrid1', {
		layout: 'fit',
		region: 'south',
		flex: 1,
		uniOpt:{	
			expandLastColumn: false,
   			useRowNumberer: false,
   			useGroupSummary: false	
        },
		store: directMasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		columns: [ 
			{ dataIndex:'DUTY_YYYYMMDD'	,	width: 100, editable: false},
			{ dataIndex:'DIV_CODE'		,	width: 160, editable: false},
			{ dataIndex:'DEPT_CODE'		,	width: 110, hidden: true},
			{ dataIndex:'DEPT_NAME'		,	width: 180},
			{ dataIndex:'POST_CODE'		,	width: 110, editable: false},
			{ dataIndex:'NAME'			,	width: 90},
			{ dataIndex:'PERSON_NUMB'	,	width: 110},
			{ dataIndex:'WORK_TEAM'		,	minWidth: 180, flex: 1},
			{ dataIndex:'FLAG'			,	width: 66, hidden: true}
		],
	   listeners: {
             selectionchange: function(grid, selNodes ){
             	UniAppManager.setToolbarButtons('delete', true);
             }
         }
	});//End of var masterGrid = Unilite.createGrid('hat400ukrGrid1', {   

	Unilite.Main( {
		border: false,
		borderItems:[{
			region:'center',
			layout: {type: 'vbox', align: 'stretch'},
			border: false,
			items:[
				panelResult, detailForm, masterGrid
			]
		},
		panelSearch  	
		],
		id: 'hat400ukrApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DVRY_DATE_FR',UniDate.get('today'));
			panelSearch.setValue('DVRY_DATE_TO',UniDate.get('today'));
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DVRY_DATE_FR',UniDate.get('today'));
			panelResult.setValue('DVRY_DATE_TO',UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('reset', false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DVRY_DATE_FR');
		},
		onQueryButtonDown: function() {	
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.get('FLAG') === 'N') {
				masterGrid.deleteSelectedRow();
			} else {
				Ext.Msg.confirm('<t:message code="system.label.human.delete" default="삭제"/>', '<t:message code="system.message.human.message032" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>', function(btn){
					if (btn == 'yes') {
						masterGrid.deleteSelectedRow();
//						masterGrid.getStore().sync({							
//								success: function(response) {
//// 									masterGrid.getStore().load();
//	 								masterGrid.getView().refresh();
//					            },
//					            failure: function(response) {
//// 					            	masterGrid.getStore().load();
//	 								masterGrid.getView().refresh();
//					            }
//						});
					}
				});				
			}
			if (directMasterStore.isDirty()) {
				UniAppManager.setToolbarButtons('save', true);				
			}
		},
		onSaveDataButtonDown: function() {
			if(directMasterStore.isDirty()) {
				directMasterStore.saveStore();
			}
		},
		onDeleteAllButtonDown : function() {
			Ext.Msg.confirm('<t:message code="system.label.human.delete" default="삭제"/>', '<t:message code="system.message.human.message032" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>', function(btn){
				if (btn == 'yes') {
					var param = panelSearch.getValues();					
					hat400ukrService.deleteAllHat400t(param, function(provider1, response)	{
						masterGrid.getStore().loadStoreRecords();
					});
				}
			});			
		}
	});//End of Unilite.Main( {
};


</script>
