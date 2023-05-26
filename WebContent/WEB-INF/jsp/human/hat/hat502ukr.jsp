<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat502ukr"  >       
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 --> 
	<t:ExtComboStore comboType="AU" comboCode="H033" /> <!-- 근태코드 -->
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="H156" /> 				<!-- 반영여부 -->
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
	Unilite.defineModel('hat502ukrModel', {
		fields: [
			{name: 'DUTY_YYYYMMDD'		, text: '적용년월일'		, type: 'uniDate', editable: false},
			{name: 'BASIS_NUM'		    , text: '근거번호'			, type: 'string' },
	        {name: 'USER_ID'		    , text: '등록자아이디'		, type: 'string' },
	        {name: 'USER_NAME'          , text: '사용자명' 			, type: 'string' },	
	        {name: 'DRAFT_STATUS'		, text: '반영여부'			,type:'string'	,comboType:'AU',comboCode:'H156'},
	        {name: 'WORK_TEAM'    		, text: '근무조'			, type: 'string', comboType:'AU', comboCode:'H004'},
			{name: 'DIV_CODE'			, text: '사업장'			, type: 'string', comboType: 'BOR120'},
			{name: 'DEPT_CODE'			, text: '부서코드'			, type: 'string'},
			{name: 'DEPT_NAME'			, text: '부서명'			, type: 'string'},
			{name: 'DUTY_CODE'			, text: '신청근태'			, type: 'string', comboType:'AU', comboCode:'H033', allowBlank: false, maxLength: 20},
			{name: 'DUTY_FR_D'			, text: '기간From'				, type: 'uniDate'},
			{name: 'DUTY_FR_H'			, text: '시간From'				, type: 'string', maxLength: 2},
			{name: 'DUTY_FR_M'			, text: '분From'				, type: 'string', maxLength: 2},
			{name: 'DUTY_TO_D'			, text: '기간To'				, type: 'uniDate'},
			{name: 'DUTY_TO_H'    		, text: '시간To'				, type: 'string', maxLength: 2},
			{name: 'DUTY_TO_M'    		, text: '분To'				, type: 'string', maxLength: 2},			
			{name: 'POST_CODE'			, text: '직위'				, type: 'string', comboType:'AU', comboCode:'H005' },
			{name: 'NAME'				, text: '성명'				, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사번'				, type: 'string'},
			{name: 'REMARK'				, text: '사유'				, type: 'string'},
			{name: 'INSERT_DB_USER'     , text: 'INSERT_DB_TIME'   	, type: 'string'	},
		    {name: 'UPDATE_DB_USER'     , text: 'INSERT_DB_USER'	, type: 'string', defaultValue: UserInfo.userID}			
		]
	});//End of Unilite.defineModel('hat502ukrModel', {
		
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'hat502ukrService.insertList',
			read: 'hat502ukrService.selectList',
			destroy: 'hat502ukrService.deleteList',
			update: 'hat502ukrService.updateList',
			syncAll: 'hat502ukrService.saveAll'
		}
	});	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hat502ukrMasterStore1', {
		model: 'hat502ukrModel',
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
		}
//        saveStore : function()	{				
//			var inValidRecs = this.getInvalidRecords();
//			if(inValidRecs.length == 0 )	{
//				config = {
////					params: [paramMaster],
//					success: function(batch, option) {
//						
//					 } 
//				};
//				this.syncAllDirect(config);				
//			}else {    				
//				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
//			}
//		},		
//		listeners: {
//           	load: function(store, records, successful, eOpts) {
//           		panelSearch.setValue('DVRY_DATE_FR_H', panelSearch.getValue('DVRY_DATE_FR'));
//           		panelSearch.setValue('DVRY_DATE_TO_H', panelSearch.getValue('DVRY_DATE_TO'));
//           		panelSearch.setValue('DIV_CODE_H', panelSearch.getValue('DIV_CODE'));
//           		panelSearch.setValue('DEPT_CODE_H', panelSearch.getValue('DEPT_CODE'));
//           		panelSearch.setValue('DEPT_NAME_H', panelSearch.getValue('DEPT_NAME'));
//           		panelSearch.setValue('PAY_CODE_H', panelSearch.getValue('PAY_CODE'));
//           		panelSearch.setValue('PAY_PROV_FLAG_H', panelSearch.getValue('PAY_PROV_FLAG'));
//           		panelSearch.setValue('PAY_GUBUN_H', panelSearch.getValue('PAY_GUBUN'));
//           		panelSearch.setValue('WORK_TEAM_H', panelSearch.getValue('WORK_TEAM'));
//           		panelSearch.setValue('PERSON_NUMB_H', panelSearch.getValue('PERSON_NUMB'));
//           		panelSearch.setValue('NAME_H', panelSearch.getValue('NAME'));
//           	}
//		}
	});//End of var directMasterStore = Unilite.createStore('hat502ukrMasterStore1', {

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',		
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
			title: '기본정보', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{ 
				fieldLabel: '적용년월일',
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
    			fieldLabel: '사업장',
    			name: 'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType: 'BOR120',
    			value:'01',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
    		},
				Unilite.popup('DEPT',{
					fieldLabel: '부서',
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
			}),			
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
			})
//				{ 
//				fieldLabel: '근무기간',
//	        	xtype: 'uniDateRangefield',
//	        	startFieldName: 'DVRY_DATE_FR_H',
//	        	endFieldName: 'DVRY_DATE_TO_H',
//	        	width: 470,
//	        	hidden: true
//	        },{
//    			fieldLabel: '사업장',
//    			name: 'DIV_CODE_H',
//    			xtype: 'uniCombobox',
//    			comboType: 'BOR120',
//	        	hidden: true
//    		},
//				Unilite.popup('DEPT',{
//	        		hidden: true,
//	        		valueFieldName:'DEPT_CODE_H',
//			    	textFieldName:'DEPT_NAME_H',
//					listeners: {
//		//				onSelected: {
//		//					fn: function(records, type) {
//		//						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
//		//						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
//		//                	},
//		//					scope: this
//		//				},
//		//				onClear: function(type)	{
//		//					panelSearch.setValue('PERSON_NUMB', '');
//		//					panelSearch.setValue('NAME', '');
//		//				}
//						onValueFieldChange: function(field, newValue){
//							panelResult.setValue('DEPT_CODE', newValue);								
//						},
//						onTextFieldChange: function(field, newValue){
//							panelResult.setValue('DEPT_NAME', newValue);				
//						}
//					}
//			}),{
//				fieldLabel: '급여지급방식',
//				name: 'PAY_CODE_H', 
//				xtype: 'uniCombobox',
//				comboType: 'AU',
//				comboCode: 'H028',
//				hidden: true
//			},{
//				fieldLabel: '지급차수',
//				name: 'PAY_PROV_FLAG_H', 
//				xtype: 'uniCombobox',
//				comboType: 'AU',
//				comboCode: 'H031',
//				hidden: true
//			},{
//				fieldLabel: '고용형태',
//				name: 'PAY_GUBUN_H', 
//				xtype: 'uniCombobox',
//				comboType: 'AU',
//				comboCode: 'H011',
//				hidden: true
//			},{
//				fieldLabel: '근무조',
//				name: 'WORK_TEAM_H', 
//				xtype: 'uniCombobox',
//				comboType: 'AU',
//				comboCode: 'H004',
//				hidden: true
//			},			
//		     	Unilite.popup('Employee',{ 
//				hidden: true,
//        		valueFieldName:'PERSON_NUMB_H',
//		    	textFieldName:'NAME_H'
//			})
			]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '적용년월일',
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
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			value:'01',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
			Unilite.popup('DEPT',{
				fieldLabel: '부서',
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
		}),			
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

	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('hat502ukrGrid1', {
		layout: 'fit',
		region: 'center',
		flex: 1,
		uniOpt:{	
			expandLastColumn: false,
   			useRowNumberer: false,
   			useGroupSummary: false,
   			copiedRow: true
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
			{dataIndex: 'DIV_CODE'     		, width: 130, hidden: true},
			{ dataIndex:'USER_ID'		,	width: 100},
			{ dataIndex:'USER_NAME'		,	width: 160, hidden: true},
			{ dataIndex:'BASIS_NUM'		,	width: 160, hidden: true},
			{ dataIndex:'DRAFT_STATUS'	,	width: 66},    
			{ dataIndex:'DUTY_YYYYMMDD'	,	width: 100, hidden: true},
			{ dataIndex:'PERSON_NUMB'	,	width: 110
				,editor: Unilite.popup('Employee_G', {
					autoPopup: true,
					DBtextFieldName: 'PERSON_NUMB',
					listeners: {'onSelected': {
									fn: function(records, type) {
											console.log('records : ', records);
											var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
											grdRecord.set('DIV_CODE', records[0].DIV_CODE);
											//grdRecord.set('DUTY_YYYYMMDD', masterGrid.get('DUTY_FR_D'));
											grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
											grdRecord.set('DEPT_CODE', records[0].DEPT_CODE);
											grdRecord.set('NAME', records[0].NAME);
											grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
											//근무조 컬럼에 데이터를 넣음
											var params = {
												S_COMP_CODE: UserInfo.compCode, 
												DUTY_YYYYMMDD: dateChange(grdRecord.get('DUTY_YYYYMMDD')),
												PERSON_NUMB: records[0].PERSON_NUMB
											}												
											hat502ukrService.getWorkTeam(params, function(provider, response)	{							
												if(!Ext.isEmpty(provider)){
													grdRecord.set('WORK_TEAM', provider);
												}													
											});
										},
									scope: this
									},
								'onClear': function(type) {
									var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
									grdRecord.set('WORK_TEAM', '');
									grdRecord.set('DIV_CODE', '');
									//grdRecord.set('DUTY_YYYYMMDD', '');
									grdRecord.set('DEPT_NAME', '');
									grdRecord.set('DEPT_CODE', '');
									grdRecord.set('NAME', '');
									grdRecord.set('PERSON_NUMB', '');
									}
					}
				})
			},			
			{ dataIndex:'NAME'			,	width: 90
				,editor: Unilite.popup('Employee_G', {
						autoPopup: true,
						listeners: {'onSelected': {
										fn: function(records, type) {
												console.log('records : ', records);
												console.log(records);
												var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
												grdRecord.set('DIV_CODE', records[0].DIV_CODE);
												//grdRecord.set('DUTY_YYYYMMDD', panelSearch.getValue('DUTY_YYYYMMDD'));
												grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
												grdRecord.set('DEPT_CODE', records[0].DEPT_CODE);
												grdRecord.set('NAME', records[0].NAME);
												grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
												//근무조 컬럼에 데이터를 넣음
												var params = {
													S_COMP_CODE: UserInfo.compCode, 
													DUTY_YYYYMMDD: dateChange(grdRecord.get('DUTY_YYYYMMDD')),
													PERSON_NUMB: records[0].PERSON_NUMB
												}												
												hat502ukrService.getWorkTeam(params, function(provider, response)	{							
													if(!Ext.isEmpty(provider)){
														grdRecord.set('WORK_TEAM', provider);
													}													
												});			
											},
										scope: this
										},
									'onClear': function(type) {
										var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
										grdRecord.set('DIV_CODE', '');
										//grdRecord.set('DUTY_YYYYMMDD', '');
										grdRecord.set('DEPT_NAME', '');
										grdRecord.set('DEPT_CODE', '');
										grdRecord.set('NAME', '');
										grdRecord.set('PERSON_NUMB', '');
										}
					}
				})			
			},
			{ dataIndex:'WORK_TEAM'		,	width: 90},
			{ dataIndex:'DEPT_CODE'		,	width: 90, hidden: true},
			{ dataIndex:'DEPT_NAME'		,	width: 90},			
			{ dataIndex:'DUTY_CODE'		,	width: 90},
			{ dataIndex:'DIV_CODE'		,	width: 160, hidden: true},
			{dataIndex: 'DUTY_FR_D'			, width: 110, editor:
				{
			        xtype: 'datefield',
			        allowBlank: false,
			        format: 'Y/m/d'
			    }
			},
			{dataIndex: 'DUTY_FR_H'			, width: 90, align: 'right'},
			{dataIndex: 'DUTY_FR_M'			, width: 66, align: 'right'},
			{dataIndex: 'DUTY_TO_D'			, width: 110, editor: 
				{
			        xtype: 'datefield',
			        allowBlank: false,
			        format: 'Y/m/d'
			    }
			},
			{dataIndex: 'DUTY_TO_H'    		, width: 90, align: 'right'},
			{dataIndex: 'DUTY_TO_M'    		, width: 66, align: 'right'},			
			{ dataIndex:'REMARK'		,	width: 110}
		],
	   listeners: {
             selectionchange: function(grid, selNodes ){
             	UniAppManager.setToolbarButtons('delete', true);
             },
             beforeedit: function( editor, e, eOpts ) {
		        	/*if(e.record.phantom == true) {		// 신규일 때
		        		if(UniUtils.indexOf(e.field, ['OCCUR_DATE'])) {
							return false;
						}
		        	}*/
		        	if(!e.record.phantom == true) { // 신규가 아닐 때
		        		if(UniUtils.indexOf(e.field, ['DRAFT_STATUS', 'WORK_TEAM'])) {
							return false;
						}
		        	}
		        	if(!e.record.phantom == true || e.record.phantom == true) { 	// 신규이던 아니던
		        		if(UniUtils.indexOf(e.field, ['DRAFT_STATUS', 'WORK_TEAM'])) {
							return false;
						}
		        	}
		        }
         }
	});//End of var masterGrid = Unilite.createGrid('hat502ukrGrid1', {   

	Unilite.Main( {
		border: false,
		borderItems:[{
			region:'center',
			layout: {type: 'vbox', align: 'stretch'},
			border: false,
			items:[
				panelResult, masterGrid
			]
		},
		panelSearch  	
		],
		id: 'hat502ukrApp',
		fnInitBinding: function() {
			//panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DVRY_DATE_FR',UniDate.get('today'));
			panelSearch.setValue('DVRY_DATE_TO',UniDate.get('today'));
			
			//panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DVRY_DATE_FR',UniDate.get('today'));
			panelResult.setValue('DVRY_DATE_TO',UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('newData', true);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DVRY_DATE_FR');
		},
		onQueryButtonDown: function() {	
//			if(panelSearch.setAllFieldsReadOnly(true) == false){
//				return false;
//			}
//			if(panelResult.setAllFieldsReadOnly(true) == false){
//				return false;
//			}
			masterGrid.getStore().loadStoreRecords();	
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
//			var detailform = panelSearch.getForm();
//			if (detailform.isValid()) {
//				masterGrid.getStore().loadStoreRecords();
//				panelSearch.getForm().getFields().each(function(field) {
//				      field.setReadOnly(true);
//				});
//				panelResult.getForm().getFields().each(function(field) {
//				      field.setReadOnly(true);
//				});
//				UniAppManager.setToolbarButtons('reset', true);
//			} else {
//				var invalid = panelSearch.getForm().getFields()
//						.filterBy(function(field) {
//							return !field.validate();
//						});
//
//				if (invalid.length > 0) {
//					r = false;
//					var labelText = ''
//
//					if (Ext
//							.isDefined(invalid.items[0]['fieldLabel'])) {
//						var labelText = invalid.items[0]['fieldLabel']
//								+ '은(는)';
//					} else if (Ext
//							.isDefined(invalid.items[0].ownerCt)) {
//						var labelText = invalid.items[0].ownerCt['fieldLabel']
//								+ '은(는)';
//					}
//
//					Ext.Msg.alert('확인', labelText + Msg.sMB083);
//					invalid.items[0].focus();
//				}
//			}
		},
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			//if(selRow.get('FLAG') === 'N') {
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			} else {
				Ext.Msg.confirm('삭제', '현재행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
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
		onNewDataButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
//			panelSearch.getForm().getFields().each(function(field) {
//			      field.setReadOnly(true);
//			});
//			panelResult.getForm().getFields().each(function(field) {
//			      field.setReadOnly(true);
//			});
			var divCode = panelResult.getValue('DIV_CODE');
			var record = {
					USER_ID: UserInfo.userID,
					DIV_CODE: divCode,
					DUTY_YYYYMMDD: UniDate.get('today'),
					DUTY_FR_D: UniDate.get('today'),
					DUTY_FR_H: '00',
					DUTY_FR_M: '00',
					DUTY_TO_D: UniDate.get('today'),
					DUTY_TO_H: '00',
					DUTY_TO_M: '00',
					DRAFT_STATUS: 'N'
			};
			masterGrid.createRow(record, 'PERSON_NUMB');
//			UniAppManager.setToolbarButtons('delete', true);
//			UniAppManager.setToolbarButtons('save', true);
		},		
		onSaveDataButtonDown: function() {
//			if(directMasterStore.isDirty()) {
//				directMasterStore.saveStore();
//			}
			if (masterGrid.getStore().isDirty()) {
				// 입력데이터 validation
				if (!checkValidaionGrid()) {
					return false;
				}
				//masterGrid.getStore().saveStore();
				directMasterStore.saveStore();
			}			
		},
		onResetButtonDown : function() {
			panelSearch.getForm().getFields().each(function(field) {
			      field.setReadOnly(false);
			});
			panelResult.getForm().getFields().each(function(field) {
			      field.setReadOnly(false);
			});
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();;
		},		
		onDeleteAllButtonDown : function() {
			Ext.Msg.confirm('삭제', '전체행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
				if (btn == 'yes') {
					var param = panelSearch.getValues();					
					hat502ukrService.deleteAllHat400t(param, function(provider1, response)	{
						masterGrid.getStore().loadStoreRecords();
					});
				}
			});			
		}
	});//End of Unilite.Main( {
	
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				
				case "DUTY_FR_D" :	// 양품재고
					/*if(newValue < '0') {
						rv= Msg.sMB076;	
						break;
					}*/
					if(newValue) {
						record.set('DUTY_YYYYMMDD',newValue);
					}

				break;
				
				case "PERSON_NUMB" :	// 양품재고
					/*if(newValue < '0') {
						rv= Msg.sMB076;	
						break;
					}*/
					var DUTY_YYYYMMDD = record.get('DUTY_YYYYMMDD');
					if(newValue) {
						record.set('BASIS_NUM',newValue);
					}

				break;				
				
				
//				case "SALE_P"  :	// 판매가
//					if(newValue == '') {
//						record.set('SALE_P','0');
//					}
//					if(newValue < '0') {
//						rv= Msg.sMB076;	
//						break;
//					}
//					var sPurchaseRate = record.get('PURCHASE_RATE');
//					var sSaleP = newValue;
//					var sPurchaseP = record.get('PURCHASE_P');
//					if(sSaleP == 0) {
//						sPurchaseP = 0;
//					} else {
//						sPurchaseP = sSaleP * (sPurchaseRate / 100);
//					}
//					record.set('PURCHASE_P',sPurchaseP);
//					record.set('AVERAGE_P',record.get('PURCHASE_P'));
//					record.set('STOCK_I',(record.get('STOCK_Q') * record.get('AVERAGE_P')));
//				break;
			}
			return rv;
		}
	})	
	

	// 쿼리 조건에 이용하기 위하여 근태년월의 형식을 변경함
	function dateChange(value) {
		if (value == null || value == '') return '';
		var year = value.getFullYear();
		var mon = value.getMonth() + 1;
		var day = value.getDate();   
		return year + '' + (mon >= 10 ? mon : '0' + mon) + '' + (day >= 10 ? day : '0' + day);
	}		
		
	// insert, update 전 입력값  검증(시작/종료 시간)
	 function checkValidaionGrid() {
		 // 시작시간/종료시간 검증
		 var rightTimeInputed = true;
		 // 필수 입력항목 입력 여부 검증
		 var necessaryFieldInputed = true;
		 var MsgTitle = '확인';
		 var MsgErr01 = '시작시간이 종료 시간 보다 클 수 없습니다.';
		 var MsgErr02 = '은(는) 필수 입력 항목 입니다.';

		 var selectedModel = masterGrid.getStore().getRange();
		 Ext.each(selectedModel, function(record,i){
			 
		 	var date_fr = parseInt(dateChange(record.data.DUTY_FR_D));
		 	var date_to = parseInt(dateChange(record.data.DUTY_TO_D));
		 	var fr_time = parseInt(record.data.DUTY_FR_H + record.data.DUTY_FR_M);
			var to_time = parseInt(record.data.DUTY_TO_H + record.data.DUTY_TO_M);
		 
			 if ( (date_fr != '' && date_to == '') || (date_fr == '' && date_to != '') ) {
//			 	alert("a");
				 rightTimeInputed = false;
				 return;
			 } else if (date_fr != '' && date_to != '') {
//			 	alert(date_fr + "//" + date_to);
				 if ((date_fr > date_to)) {		// 기간from이 기간 to보다 클때
//				 	alert("b");
					 rightTimeInputed = false;
					 return;
				 } else {
					if (date_fr == date_to && fr_time > to_time) {
//						alert(date_fr + "//" + date_to + "//" + fr_time + "//" + to_time);
//						alert("c");
						rightTimeInputed = false;
						return;
					}
				 }
			 }
			 
//			 if (record.data.WORK_TEAM == '') {
//				 MsgErr02 = '근무조' + MsgErr02;
//				 necessaryFieldInputed = false;
//				 return;
//			 } else if (record.data.DIV_CODE == '') {
//				 MsgErr02 = '사업장' + MsgErr02;
//				 necessaryFieldInputed = false;
//				 return;
//			 } else if (record.data.DEPT_NAME == '') {
//				 MsgErr02 = '부서' + MsgErr02;
//				 necessaryFieldInputed = false;
//				 return;
//			 } else if (record.data.POST_CODE == '') {
//				 MsgErr02 = '직위' + MsgErr02;
//				 necessaryFieldInputed = false;
//				 return;
//			 } else if (record.data.NAME == '') {
//				 MsgErr02 = '성명' + MsgErr02;
//				 necessaryFieldInputed = false;
//				 return;
//			 } else if (record.data.PERSON_NUMB == '') {
//				 MsgErr02 = '사번' + MsgErr02;
//				 necessaryFieldInputed = false;
//				 return;
//			 } else if (record.data.DUTY_CODE == '') {
//				 MsgErr02 = '근태구분' + MsgErr02;
//				 necessaryFieldInputed = false;
//				 return;
//			 }
			 
		 });
		 if (!rightTimeInputed) {
			 Ext.Msg.alert(MsgTitle, MsgErr01);
			 return rightTimeInputed;
		 }
		 if (!necessaryFieldInputed) {
			 Ext.Msg.alert(MsgTitle, MsgErr02);
			 return necessaryFieldInputed;
		 }
		 return true;
	 }	
};


</script>
