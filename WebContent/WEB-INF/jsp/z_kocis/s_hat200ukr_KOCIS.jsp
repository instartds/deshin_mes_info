<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat200ukr_KOCIS"  >
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 --> 
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="H181" /> <!-- 사원그룹 --> 
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	var colData = ${colData};
	console.log(colData);
	
	var fields = createModelField(colData);
	var columns = createGridColumn(colData);
	

	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hat200ukrModel', {
		fields: fields
	});
	
	Unilite.defineModel('Hat200ukrModel2', {
		fields: [
				{name: 'TOT_DAY' 		, text: '달력일수'		, type: 'string'},
				{name: 'WEEK_DAY' 		, text: '총근무일수'		, type: 'string'},
				{name: 'DED_DAY' 		, text: '차감일수'		, type: 'string'},
				{name: 'WORK_DAY' 		, text: '실근무일수'		, type: 'string'},
				{name: 'SUN_DAY' 		, text: '일요일'		, type: 'string'},
				{name: 'SAT_DAY' 		, text: '토요일'		, type: 'string'},				
				{name: 'DED_TIME' 		, text: '차감시간'		, type: 'string'},				
				{name: 'WORK_TIME' 		, text: '실근무시간'		, type: 'string'},
				{name: 'EXTEND_WORK_TIME' 		, text: '연장근로'		, type: 'string'},
				{name: 'NON_WEEK_DAY' 		, text: '휴무일수'		, type: 'string'},
				{name: 'WEEK_GIVE' 		, text: '주차지급일수'	, type: 'string'},
				{name: 'FULL_GIVE' 		, text: '만근지급일수'	, type: 'string'},
				{name: 'MONTH_GIVE' 	, text: '월차지급일수'	, type: 'string'},
				{name: 'MENS_GIVE' 		, text: '보건지급일수'	, type: 'string'}
		         ]
	});//End of Unilite.defineModel('Hat200ukrModel', {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_hat200ukrService_KOCIS.selectList',
			destroy: 's_hat200ukrService_KOCIS.deleteHat200',
			update: 's_hat200ukrService_KOCIS.updateHat200',
			syncAll: 's_hat200ukrService_KOCIS.saveAll'
		}
	});	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hat200ukrMasterStore1', {
		model: 'Hat200ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,		// 삭제 가능 여부 
			allDeletable: true,		// 전체삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
		},
		saveStore : function(config)	{				
			var inValidRecs = this.getInvalidRecords();
			var config = {					
				success: function(batch, option) {
					directMasterStore.loadStoreRecords();
					UniAppManager.setToolbarButtons('save', false);
				 } 
			};
			if(inValidRecs.length == 0 )	{	
				directMasterStore.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
		
	});
	
	var directMasterStore2 = Unilite.createStore('hat200ukrMasterStore2', {
		model: 'Hat200ukrModel2',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 's_hat200ukrService_KOCIS.selectList2'                	
			}
		},
		listeners: {
	        load: function(store, records) {
	            var form1 = Ext.getCmp('detailForm1');
	            var form2 = Ext.getCmp('detailForm2');
	            if (store.getCount() > 0) {
	            	form1.loadRecord(records[0]);
	            	form2.loadRecord(records[0]);
	            }
	            else{
	            	form1.clearForm();
	            	form2.clearForm();
	            }
	        }
	    },
		loadStoreRecords: function(person_numb){
			var param= Ext.getCmp('searchForm').getValues();
			param.PERSON_NUMB = person_numb;
			console.log(param);
			this.load({
				params: param
			});
		}
		
	});
	
	//End of var directMasterStore = Unilite.createStore('hat200ukrMasterStore1', {

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',		
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
				fieldLabel: '근태년월',
				xtype: 'uniMonthfield',
				name: 'DUTY_YYYYMM',                    
				value: new Date(),                    
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DUTY_YYYYMM', newValue);
					}
				}
			},
			{ 
	        	fieldLabel: '기관',
	        	name: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120',
	        	value :'01',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}      	
        	},{
				fieldLabel: '급여지급방식',
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
				fieldLabel: '지급차수',
				name: 'PAY_PROV_FLAG', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H031',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_PROV_FLAG', newValue);
					}
				}
			}/*,
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true,
				listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			})*/,{
				fieldLabel: '고용형태',
				name: 'PAY_GUBUN', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H011',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_GUBUN', newValue);
					}
				}
			},			
		     	Unilite.popup('Employee',{
                fieldLabel:'직원',
				validateBlank: false,
				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
//	                	},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('PERSON_NUMB', '');
//						panelResult.setValue('NAME', '');
//					}
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			})]
		},{	
			title: '추가정보', 	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [/*{
				fieldLabel: '사원구분',
				name: 'EMPLOY_TYPE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H031'
			},*/{
				fieldLabel: '사원그룹',
				name: 'SUB_CODE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H031'
			}]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '근태년월',
			xtype: 'uniMonthfield',
			name: 'DUTY_YYYYMM',                    
			value: new Date(),                    
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DUTY_YYYYMM', newValue);
				}
			}
		},
		{ 
        	fieldLabel: '기관',
        	name: 'DIV_CODE', 
        	xtype: 'uniCombobox', 
        	comboType:'BOR120',
        	value :'01',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}      	
    	},{
			fieldLabel: '급여지급방식',
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
			fieldLabel: '지급차수',
			name: 'PAY_PROV_FLAG', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H031',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_PROV_FLAG', newValue);
				}
			}
		}/*,
		Unilite.treePopup('DEPTTREE',{
			fieldLabel: '부서',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth:89,
			validateBlank:true,
			width:300,
			autoPopup:true,
			useLike:true,
			listeners: {
                'onValueFieldChange': function(field, newValue, oldValue  ){
                    	panelSearch.setValue('DEPT',newValue);
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
                    	panelSearch.setValue('DEPT_NAME',newValue);
                },
                'onValuesChange':  function( field, records){
                    	var tagfield = panelSearch.getField('DEPTS') ;
                    	tagfield.setStoreData(records)
                }
			}
		})*/,{
			fieldLabel: '고용형태',
			name: 'PAY_GUBUN', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H011',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_GUBUN', newValue);
				}
			}
		},			
	     	Unilite.popup('Employee',{ 
			fieldLabel:'직원',
			validateBlank: false,
			listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
//	                	},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('PERSON_NUMB', '');
//						panelResult.setValue('NAME', '');
//					}
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		})]	
    });
    
	var detailForm1 = Unilite.createSearchForm('detailForm1',{
		padding:'1 1 1 1',
		flex: 2,
		border:true,
		region: 'west',
		layout : {type : 'uniTable', columns : 1},
	    items: [{	
	    	xtype:'container',
	        defaultType: 'uniTextfield',
	        flex: 1,
	        layout: {
	        	type: 'uniTable',
	        	columns : 3
	        },
	        defaults: { labelWidth: 130, readOnly: true, fieldStyle: "text-align:right;"},
	        items: [
	        	{   
					xtype: 'uniTextfield', 
					fieldLabel: '달력일수',
					name: 'TOT_DAY'
				},
	        	{ 
					xtype: 'uniTextfield',
					fieldLabel: '일요일',
					name: 'SUN_DAY'
				},
	        	{
	        		fieldLabel: '연장근로',
	        		name: 'EXTEND_WORK_TIME'
	        	},
				{ 
					xtype: 'uniTextfield',
					fieldLabel: '총근무일수',
					name: 'WEEK_DAY'
				},
				{ 
					xtype: 'uniTextfield',
					fieldLabel: '토요일',
					name: 'SAT_DAY'
				},	        	
	        	{
	        		fieldLabel: '휴무일수',	        	
	        		name: 'NON_WEEK_DAY'
				},
				{ 
					xtype: 'uniTextfield',
					fieldLabel: '차감일수',
					name: 'DED_DAY'
				},
				{ 
					xtype: 'uniTextfield',
					fieldLabel: '차감시간',
					name: 'DED_TIME'
				},	        	
	        	{
	        		fieldLabel: '휴일일수',	        	
	        		name: 'HOLIDAY'
				},
				{ 
					xtype: 'uniTextfield',
					fieldLabel: '실근무일수',
					name: 'WORK_DAY'
				},
				{ 
					xtype: 'uniTextfield',
					fieldLabel: '실근무시간',
					name: 'WORK_TIME'
				}
	        ]
		}]
    });
    
    var detailForm2 = Unilite.createSearchForm('detailForm2',{
		padding:'1 1 1 1',
		flex: 1,
		border:true,
		region: 'center',
		layout : {type : 'uniTable', columns : 1},
	    items: [{
	    	xtype:'container',
	        defaultType: 'uniTextfield',
	        layout: {
	        	type: 'uniTable',
	        	columns : 1
	        },
	        defaults: { labelWidth: 150, readOnly: true, fieldStyle: "text-align:right;"},
	        items: [
	        	{ 
					fieldLabel: '주차지급일수',
					name: 'WEEK_GIVE'
				},
				{ 
					fieldLabel: '만근지급일수',
					name: 'FULL_GIVE'
				},{ 
					fieldLabel: '월차지급일수',
					name: 'MONTH_GIVE'
				},{ 
					fieldLabel: '보건지급일수',
					name: 'MENS_GIVE'
				}
	        ]
		}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('hat200ukrGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true
//		 	copiedRow: true
//		 	useContextMenu: true,
        },
//         tbar: [{
//         	text:'상세보기',
//         	handler: function() {
//         		var record = masterGrid.getSelectedRecord();
// 	        	if(record) {
// 	        		openDetailWindow(record);
// 	        	}
//         	}
//         }],
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false 
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
// 		selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : false }),
		store: directMasterStore,
		columns: columns,
		listeners: {
            selectionchange: function(grid, selNodes ){
				if (typeof selNodes[0] != 'undefined') {
            	  console.log(selNodes[0].data.PERSON_NUMB);
                  var person_numb = selNodes[0].data.PERSON_NUMB;
                  directMasterStore2.loadStoreRecords(person_numb);
                  UniAppManager.app.setToolbarButtons('delete', true);
                }
				
            },            
            uniOnChange: function(grid, dirty, eOpts) {	
            	alert("change");
				UniAppManager.app.setToolbarButtons('save', true);
			}
		}
	});//End of var masterGrid = Unilite.createGr100id('hat200ukrGrid1', {   
                                                 
	Unilite.Main( {
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult, 
				{	xtype: 'container',
					region: 'south',
//					layout: 'border',
					layout: {type: 'hbox'},
					items:[
						detailForm1, detailForm2
					]
				}
			]
		},
			panelSearch  	
		],
		id: 'hat200ukrApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('newData',false);
			UniAppManager.setToolbarButtons('delete',false);
			UniAppManager.setToolbarButtons('save',false);
			masterGrid.on('edit', function(editor, e) {
				UniAppManager.setToolbarButtons('save',true);
			})
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
            
            if(UserInfo.divCode == "01") {
                panelSearch.getField('DIV_CODE').setReadOnly(false);
                panelResult.getField('DIV_CODE').setReadOnly(false);
            }
            else {
                panelSearch.getField('DIV_CODE').setReadOnly(true);
                panelResult.getField('DIV_CODE').setReadOnly(true);
            }
            
			activeSForm.onLoadSelectText('DUTY_YYYYMM');
		},
		onQueryButtonDown: function() {		
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			console.log("viewLocked: ", viewLocked);
//			console.log("viewNormal: ", viewNormal);
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
//		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);
//		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onSaveDataButtonDown: function() {
			if(directMasterStore.isDirty()) {
				directMasterStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {			
			var records = directDetailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						if(record.get('ACCOUNT_Q') != 0)
							{
								alert('<t:message code="unilite.msg.sMM008"/>');
							}else{
						
						var deletable = true;
						if(deletable){		
							detailGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;							
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		onDeleteAllButtonDown : function() {
			Ext.Msg.confirm('삭제', '전체행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
				if (btn == 'yes') {
					directMasterStore.removeAll();
					directMasterStore.saveStore();
				}
			});			
		},
		dutyCheck: function(fieldName, record, newValue, oldValue, e){		//입력전 체크
			var param = {PAY_CODE: record.get('PAY_CODE'), DUTY_CODE: e.column.DUTY_CODE}
			s_hat200ukrService_KOCIS.wirteCheck(param, function(provider, response)	{
				fieldName.indexOf('DUTY_NUM') > -1 ? activeField = 'DUTY_NUM' : activeField = 'DUTY_TIME';
				switch(activeField) {				
					case "DUTY_NUM" :
						if(Ext.isEmpty(provider)){
							record.set(fieldName, oldValue);
							alert(Msg.sMB379);
							return false;
						}else if(provider[0].COTR_TYPE != "2"){
							record.set(fieldName, oldValue);
							alert(Msg.sMH1206);
							return false;
							
						}
						if(Ext.isEmpty(record.get('PERSON_NUMB'))){
							alert(Msg.sMH1082);
							record.set(fieldName, oldValue);
							return false;							
						}
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							alert(Msg.sMB076);	//양수만 입력 가능합니다.
							record.set(fieldName, oldValue);
							return false;
						}
						if(Ext.isEmpty(record.get('FLAG'))){
							record.set('FLAG', 'U');
						}
						if(e.column.DUTY_CODE == "25"){	//보건
							if(record.get('SEX_CODE') == "M"){
								alert(Msg.sMH912);
								record.set(fieldName, oldValue);
								return false;
							}
							if(newValue > 1){
								alert(Msg.sMH1203);
								record.set(fieldName, oldValue);
								return false;
							}
							if(record.get('DAYDIFF') < newValue){
								alert(Msg.sMH1037);
								record.set(fieldName, oldValue);
								return false;
							}
						}
						if(e.column.DUTY_CODE == "20"){	//년차사용유무체크 및 수량 체크
							if(record.get('YEAR_GIVE') == "N"){
								alert(Msg.sMH913);
								record.set(fieldName, oldValue);
								return false;
							}
							//년차 등록 관련 프로그램 없다고 하여 사용량 계산하여 체크하는 부분 주석처리
//							if(newValue > record.get('YEAR_NUM')){
//								alert(Msg.sMH914);
//								record.set(fieldName, oldValue);
//								return false;
//							}
						}
						if(e.column.DUTY_CODE == "10"){	//무휴
							if(record.get('DAYDIFF') < newValue){
								alert(Msg.sMH1037);
								record.set(fieldName, oldValue);
								return false;
							}
						}
						if(e.column.DUTY_CODE == "11"){ //결근
							if(record.get('DAYDIFF') < newValue){
								alert(Msg.sMH1037);
								record.set(fieldName, oldValue);
								return false;
							}
						}
						if(e.column.DUTY_CODE == "22"){ //월차
							if(record.get('DAYDIFF') < newValue){
								alert(Msg.sMH1037);
								record.set(fieldName, oldValue);
								return false;
							}
						}
					break;	
						
					case "DUTY_TIME" :
						if(Ext.isEmpty(provider)){
							record.set(fieldName, oldValue);
							alert(Msg.sMB379);
							return false;
						}else if(provider[0].COTR_TYPE != "1"){
							record.set(fieldName, oldValue);
							alert(Msg.sMH1207);
							return false;
							
						}
						if(Ext.isEmpty(record.get('PERSON_NUMB'))){
							alert(Msg.sMH1082);
							record.set(fieldName, oldValue);
							return false;							
						}
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							alert(Msg.sMB076);	//양수만 입력 가능합니다.
							record.set(fieldName, oldValue);
							return false;
						}
						if(Ext.isEmpty(record.get('FLAG'))){
							record.set('FLAG', 'U');
						}
						if(e.column.DUTY_CODE == "25"){	//보건
							if(record.get('SEX_CODE') == "M"){
								alert(Msg.sMH912);
								record.set(fieldName, oldValue);
								return false;
							}
							if(newValue > 1){
								alert(Msg.sMH1203);
								record.set(fieldName, oldValue);
								return false;
							}
							if(record.get('DAYDIFF') < newValue){
								alert(Msg.sMH1037);
								record.set(fieldName, oldValue);
								return false;
							}
						}
						if(e.column.DUTY_CODE == "20"){	//년차사용유무체크 및 수량 체크
							if(record.get('YEAR_GIVE') == "N"){
								alert(Msg.sMH913);
								record.set(fieldName, oldValue);
								return false;
							}
//							if(newValue > record.get('YEAR_NUM')){
//								alert(Msg.sMH914);
//								record.set(fieldName, oldValue);
		//						return false;
//							}
						}
//						if(e.column.DUTY_CODE == "10"){	//무휴
//							if(record.get('DAYDIFF') < newValue){
//								alert(Msg.sMH1037);
//								record.set(fieldName, oldValue);
//								return false;
//							}
//						}
//						if(e.column.DUTY_CODE == "11"){ //결근
//							if(record.get('DAYDIFF') < newValue){
//								alert(Msg.sMH1037);
//								record.set(fieldName, oldValue);
//								return false;
//							}
//						}
//						if(e.column.DUTY_CODE == "22"){ //월차
//							if(record.get('DAYDIFF') < newValue){
//								alert(Msg.sMH1037);
//								record.set(fieldName, oldValue);
//								return false;
//							}
//						}
					break;	
				}
				
			});
		}
	});//End of Unilite.Main( {
		
	// 모델 필드 생성
	function createModelField(colData) {
		
		var fields = [
						{name: 'FLAG',				 text: ' ', 	editable:false,		type: 'string'},
						{name: 'DIV_CODE',			 text: '기관', 	editable:false,		type: 'string', comboType:'BOR120', comboCode:'1234'},
						{name: 'DEPT_NAME',		     text: '부서', 	editable:false,		type: 'string'},
						{name: 'NAME',				 text: '성명', 	editable:false,		type: 'string'},
						{name: 'PERSON_NUMB',        text: '사번', 	editable:false,		type: 'string'},
						{name: 'DUTY_YYYYMM',	     text: '연월', 	editable:false,		type: 'string'},
						{name: 'PAY_PROV_FLAG',	     text: '지급차수', editable:false,		type: 'string'},
						{name: 'DUTY_FROM',	         text: '연월첫일', editable:false,		type: 'string'},
						{name: 'DUTY_TO',          	 text: '연월말일', editable:false,		type: 'string'},
						{name: 'DEPT_CODE',	         text: '부서', 	editable:false,		type: 'string'},
						{name: 'DEPT_CODE2',	     text: '부서', 	editable:false,		type: 'string'}						
					];
					
		Ext.each(colData, function(item, index){
			fields.push({name: 'DUTY_NUM' + item.SUB_CODE, text:'일수', type:'string'});
			fields.push({name: 'DUTY_TIME' + item.SUB_CODE, text:'시간', type:'string'});
		});
		
		fields.push({name: 'REMARK',	text: '비고',	type: 'string'});
		
		console.log(fields);
// 		alert(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {		
		
		var columns = [
					{dataIndex: 'FLAG',			width: 30, align: 'center'},
					{dataIndex: 'DIV_CODE',			width: 130},
					{dataIndex: 'DEPT_NAME',		width: 150, hidden: true},
					{dataIndex: 'NAME',				width: 120},
					{dataIndex: 'PERSON_NUMB',		width: 80, hidden: true},
					{dataIndex: 'DUTY_YYYYMM',		width: 100, hidden: true},
					{dataIndex: 'PAY_PROV_FLAG',		width: 100, hidden: true},
					{dataIndex: 'DUTY_FROM',		width: 100, hidden: true},
					{dataIndex: 'DUTY_TO',		width: 100, hidden: true},
					{dataIndex: 'DEPT_CODE',		width: 100, hidden: true},
					{dataIndex: 'DEPT_CODE2',		width: 100, hidden: true}
				];
					
		Ext.each(colData, function(item, index){
			columns.push({text: item.CODE_NAME,
				columns:[ 
					{dataIndex: 'DUTY_NUM' + item.SUB_CODE, width:50, summaryType:'sum', DUTY_CODE: item.SUB_CODE, align: 'right',
						renderer: function(value, metaData, record) {							
							return Ext.util.Format.number(value, '0.0');
						}
					},
					{dataIndex: 'DUTY_TIME' + item.SUB_CODE, width:50, summaryType:'sum', DUTY_CODE: item.SUB_CODE, align: 'right',
						renderer: function(value, metaData, record) {							
							return Ext.util.Format.number(value, '0.00');
						}
					}
			]});
		});
		columns.push({dataIndex: 'REMARK',		minWidth: 200, flex: 1});
		console.log(columns);
		return columns;
	}
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var activeField = '';
			UniAppManager.app.dutyCheck(fieldName, record, newValue, oldValue, e);					
			
			return rv;
//			setTimeout( rv, 100);
		}
	}); // validator
};


</script>