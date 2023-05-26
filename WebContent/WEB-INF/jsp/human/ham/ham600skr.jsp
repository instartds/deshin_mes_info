<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ham600skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ham600skr" /> 			<!-- 사업장 -->
	
	
	<t:ExtComboStore items="${COMBO_DEPTS2}" storeId="authDeptsStore" /> <!--권한부서-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	colData = ${colData};
// 	console.log(colData);
	
	var fields1 = createModelField1(colData);
	var columns1 = createGridColumn1(colData);
	var fields2 = createModelField2(colData);
	var columns2 = createGridColumn2(colData);
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Ham600skrModel1', {
	    fields: fields1
	});//End of Unilite.defineModel('Ham600skrModel1', {
		
	Unilite.defineModel('Ham600skrModel2', {
		fields: fields2
	});//End of Unilite.defineModel('Ham600skrModel2', {
		
	Unilite.defineModel('Ham600skrModel3', {
		fields: [
				{name: 'TOT_DAY' 		, text: '달력일수'		, type: 'string'},
				{name: 'SUN_DAY' 		, text: '일요일'		, type: 'string'},
				{name: 'WEEK_DAY' 		, text: '총근무일수'	, type: 'string'},
				{name: 'DED_DAY' 		, text: '차감일수'		, type: 'string'},
				{name: 'DED_TIME' 		, text: '차감시간'		, type: 'string'},
				{name: 'WORK_DAY' 		, text: '실근무일수'	, type: 'string'},
				{name: 'WORK_TIME' 		, text: '실근무시간'	, type: 'string'},
				{name: 'WEEK_GIVE' 		, text: '주차지급일수'	, type: 'string'},
				{name: 'FULL_GIVE' 		, text: '만근지급일수'	, type: 'string'},
				{name: 'MONTH_GIVE' 	, text: '월차지급일수'	, type: 'string'},
				{name: 'MENS_GIVE' 		, text: '보건지급일수'	, type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ham600skrMasterStore1', {
		model: 'Ham600skrModel1',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'ham600skrService.selectList'                	
			}
		},
		loadStoreRecords: function() {
//			var param= Ext.getCmp('searchForm').getValues();			
			var param= Ext.getCmp('panelResultForm').getValues();
			
			param.DEPT_AUTH = UserInfo.deptAuthYn;
//			alert( ' UserInfo.deptAuthYn :::' +  UserInfo.deptAuthYn);
			
			console.log( param );
			this.load({
				params: param
			});
		}
	});//End of var directMasterStore1 = Unilite.createStore('ham600skrMasterStore1', {

	var directMasterStore2 = Unilite.createStore('ham600skrMasterStore2', {
		model: 'Ham600skrModel2',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'ham600skrService.selectList2'                	
			}
		},
		listeners: {
	        load: function(store, records) {
	        //alert(store.getCount());        
	            if (store.getCount() == 0) {
					// not working.....
	            	var form1 = Ext.getCmp('resultForm1');
		            var form2 = Ext.getCmp('resultForm2');
	            	form1.reset();
	            	form2.reset();
	            	Ext.each(panelResult1.getForm().getFields().items, function(field){
                        field.setValue('');
                 	});
	            	Ext.each(panelResult2.getForm().getFields().items, function(field){
                        field.setValue('');
                 	});	           
	            }
	        }
	    },
		loadStoreRecords: function() {
//			var param= Ext.getCmp('searchForm').getValues();			
			var param= Ext.getCmp('panelResultForm').getValues();		
			
			param.DEPT_AUTH = UserInfo.deptAuthYn;
//            alert( ' UserInfo.deptAuthYn :::' +  UserInfo.deptAuthYn);
			
			
			console.log( param );
			this.load({
				params: param
			});
		}
	});//End of var directMasterStore1 = Unilite.createStore('ham600skrMasterStore1', {
	
	var directMasterStore3 = Unilite.createStore('ham600skrMasterStore3', {
		model: 'Ham600skrModel3',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'ham600skrService.selectList3'                	
			}
		},
        listeners: {
	        load: function(store, records) {
	            var form1 = Ext.getCmp('resultForm1');
	            var form2 = Ext.getCmp('resultForm2');
	            if (store.getCount() > 0) {
	            	form1.loadRecord(records[0]);
	            	form2.loadRecord(records[0]);
	            }
	        }
	    },
		loadStoreRecords: function(person_numb) {
//			var param= Ext.getCmp('searchForm').getValues();
			var param= Ext.getCmp('panelResultForm').getValues();
			
			
			
			param.PERSON_NUMB = person_numb;
			console.log( param );
			this.load({
				params: param
			});
		}
	});//End of var directMasterStore1 = Unilite.createStore('ham600skrMasterStore1', {	
		
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

//	var panelSearch = Unilite.createSearchPanel('searchForm',{
//		title: '검색조건',
//		defaultType: 'uniSearchSubPanel',
//		collapsed: UserInfo.appOption.collapseLeftSearch,
//        listeners: {
//	        collapse: function () {
//	        	panelResult.show();
//	        },
//	        expand: function() {
//	        	panelResult.hide();
//	        }
//	    },
//		items: [{	
//			title: '기본정보',
//			itemId: 'search_panel1',
//			layout: {type: 'uniTable', columns: 1},
//           	defaultType: 'uniTextfield',
//			items: [{
//				fieldLabel: '근태월', 
//				name: 'DUTY_YYYYMMDD', 
//				xtype: 'uniMonthfield',
//				allowBlank: false,
//				listeners: {
//					change: function(field, newValue, oldValue, eOpts) {						
//						panelResult.setValue('DUTY_YYYYMMDD', newValue);
//					}
//				}    
//			},{
//				fieldLabel: '사업장',
//				name:'DIV_CODE', 
//				xtype: 'uniCombobox',
//		        multiSelect: true, 
//		        typeAhead: false,
//		        comboType:'BOR120',
//				width: 325,
//				listeners: {
//					change: function(field, newValue, oldValue, eOpts) {						
//						panelResult.setValue('DIV_CODE', newValue);
//					}
//				}
//			},
//			Unilite.treePopup('DEPTTREE',{
//				fieldLabel: '부서',
//				valueFieldName:'DEPT',
//				textFieldName:'DEPT_NAME' ,
//				valuesName:'DEPTS' ,
//				DBvalueFieldName:'TREE_CODE',
//				DBtextFieldName:'TREE_NAME',
//				selectChildren:true,
//				textFieldWidth:89,
//				validateBlank:true,
//				width:300,
//				autoPopup:true,
//				useLike:true,
//				listeners: {
//	                'onValueFieldChange': function(field, newValue, oldValue  ){
//	                    	panelResult.setValue('DEPT',newValue);
//	                },
//	                'onTextFieldChange':  function( field, newValue, oldValue  ){
//	                    	panelResult.setValue('DEPT_NAME',newValue);
//	                },
//	                'onValuesChange':  function( field, records){
//	                    	var tagfield = panelResult.getField('DEPTS') ;
//	                    	tagfield.setStoreData(records)
//	                }
//				}
//			}),
//				Unilite.popup('Employee',{
//				fieldLabel: '사원',
//			  	valueFieldName:'PERSON_NUMB',
//			    textFieldName:'NAME',
//				validateBlank:false,
//				autoPopup:true,
//				listeners: {
//					/*onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
//						},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('PERSON_NUMB', '');
//						panelResult.setValue('NAME', '');
//					}*/
//					onValueFieldChange: function(field, newValue){
//						panelResult.setValue('PERSON_NUMB', newValue);								
//					},
//					onTextFieldChange: function(field, newValue){
//						panelResult.setValue('NAME', newValue);				
//					}
//				}
//			})]
//		}]
//	});//End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
	
	var panelResult = Unilite.createSimpleForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
					fieldLabel: '근태월', 
					name: 'DUTY_YYYYMMDD', 
					xtype: 'uniMonthfield',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
//							panelSearch.setValue('DUTY_YYYYMMDD', newValue);
						}
					}    
				},{
					fieldLabel: '사업장',
					name:'DIV_CODE', 
					xtype: 'uniCombobox',
			        multiSelect: true, 
			        typeAhead: false,
			        comboType:'BOR120',
					width: 325,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
//							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				},
				
				
				
//		        Unilite.treePopup('DEPTTREE',{
//					fieldLabel: '부서',
//					valueFieldName:'DEPT',
//					textFieldName:'DEPT_NAME' ,
//					valuesName:'DEPTS' ,
//					DBvalueFieldName:'TREE_CODE',
//					DBtextFieldName:'TREE_NAME',
//					selectChildren:true,
//					textFieldWidth:89,
//					validateBlank:true,
//					width:300,
//					autoPopup:true,
//					useLike:true,
//					listeners: {
//		                'onValueFieldChange': function(field, newValue, oldValue  ){
////		                    	panelSearch.setValue('DEPT',newValue);
//		                },
//		                'onTextFieldChange':  function( field, newValue, oldValue  ){
////		                    	panelSearch.setValue('DEPT_NAME',newValue);
//		                },
//		                'onValuesChange':  function( field, records){
////		                    	var tagfield = panelSearch.getField('DEPTS') ;
////		                    	tagfield.setStoreData(records)
//		                }
//					}
//				}),
				{
                    fieldLabel: '부서',
                    name: 'DEPTS2',
                    xtype: 'uniCombobox',
                    width:300,
                    multiSelect: true,
                    store:  Ext.data.StoreManager.lookup('authDeptsStore'),
                    disabled:false,
                    hidden:false,
                    allowBlank:false
                },
                Unilite.treePopup('DEPTTREE',{
                    itemId : 'deptstree',
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
                    useLike:true
                }), 
				
				
				
				Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					/*onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
							panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
					}*/
					
					onValueFieldChange: function(field, newValue){
//						panelSearch.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
//						panelSearch.setValue('NAME', newValue);				
					}
				}
			})]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid1 = Unilite.createGrid('ham600skrGrid1', {
    	// for tab
    	title: '일근태',
		layout: 'fit',
		region: 'center',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
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
		store: directMasterStore1,
        columns: columns1
	});//End of var masterGrid = Unilite.createGrid('ham600skrGrid1', {   
	
	/**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
	var masterGrid2 = Unilite.createGrid('ham600skrGrid2', {
		//flex: 1.5,
		region: 'center',
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: false,			
			onLoadSelectFirst	: true,
			useMultipleSorting	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
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
		store: directMasterStore2,
        columns: columns2,
        selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
        listeners: {
            selectionchange: function(grid, selNodes ){
            	if (typeof selNodes[0] != 'undefined') {
            	  console.log(selNodes[0].data.PERSON_NUMB);
                  var person_numb = selNodes[0].data.PERSON_NUMB;
                  directMasterStore3.loadStoreRecords(person_numb);
                }
            }
        }
	});//End of var masterGrid2 = Unilite.createGrid('ham600skrGrid2', {   
	
	var panelResult1 = Unilite.createSimpleForm('resultForm1',{
		padding: '10 0 0 0',
		layout: {
        	type: 'uniTable',
        	columns : 2,
        	tableAttrs: {align:'left'}
        },
        flex: 0.7,
        items: [
			{   
				xtype: 'uniNumberfield', 
				fieldLabel: '달력일수',
				name: 'TOT_DAY', 
				width: 200,
				readOnly:true
			},{ 
				xtype: 'uniNumberfield',
				fieldLabel: '일요일',
				name: 'SUN_DAY', 
				width: 200,
				readOnly:true
			},{ 
				xtype: 'uniNumberfield',
				fieldLabel: '총근무일수',
				name: 'WEEK_DAY', 
				width: 200,
				readOnly:true
			},
			{
				xtype: 'panel',
				border: 0
			},
			{ 
				xtype: 'uniNumberfield',
				fieldLabel: '차감일수',
				name: 'DED_DAY', 
				width: 200,
				readOnly:true
			},{ 
				xtype: 'uniNumberfield',
				fieldLabel: '차감시간',
				name: 'DED_TIME', 
				width: 200,
				readOnly:true
			},{ 
				xtype: 'uniNumberfield',
				fieldLabel: '실근무일수',
				name: 'WORK_DAY', 
				width: 200,
				readOnly:true
			},{ 
				xtype: 'uniNumberfield',
				fieldLabel: '실근무시간',
				name: 'WORK_TIME', 
				width: 200,
				readOnly:true
			}]
    });
	
	var panelResult2 = Unilite.createSimpleForm('resultForm2',{
		padding: '10 0 0 0',
		defaultType: 'uniNumberfield',
		layout: {
        	type: 'uniTable',
        	columns : 1,
        	tableAttrs: {align:'left'}
        },
        flex: 0.3,
	    items: [
				{ 
					fieldLabel: '주차지급일수',
					name: 'WEEK_GIVE', 
					width:200,
					readOnly:true
				},{ 
					fieldLabel: '만근지급일수',
					name: 'FULL_GIVE', 
					width:200,
					readOnly:true
				},{ 
					fieldLabel: '월차지급일수',
					name: 'MONTH_GIVE', 
					width:200,
					readOnly:true
				},{ 
					fieldLabel: '보건지급일수',
					name: 'MENS_GIVE', 
					width:200,
					readOnly:true
				}]
    });
		
	var tab2main = Ext.create('Ext.panel.Panel', {
		id: 'ham600skrTab2',		
		title: '월근태',
		layout: {
		    type: 'vbox',
		    align : 'stretch',
		    pack  : 'start'
		},
		items:[
			masterGrid2,
			{
				layout: 'hbox',
				flex: 0.3,
				items: [
					panelResult1, panelResult2
				        ]
			}]
	});
		
	var tab = Unilite.createTabPanel('tabPanel',{     	 
        region: 'center',
	    activeTab: 0,
	    items: [
	         masterGrid1,
	         tab2main
	    ],
	    listeners:{
	    	beforetabchange: function( tabPanel, newCard, oldCard, eOpts )	{
    			if(!UniAppManager.app.isValidSearchForm()){
					return false;
				}	
    		},
    		tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
    			if(newCard.getItemId() == 'ham600skrGrid1')	{
    				UniAppManager.app.onQueryButtonDown();
    			}else if(newCard.getItemId() == 'ham600skrTab2') {
    				UniAppManager.app.onQueryButtonDown();
    			}
    		}
    	}
	});	
	
	Unilite.Main({
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            	tab, panelResult
	     	]
	     }
//	         panelSearch
	    ], 
		id: 'ham600skrApp',
		fnInitBinding: function() {
//			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
//			panelSearch.setValue('DUTY_YYYYMMDD',UniDate.get('today'));
			panelResult.setValue('DUTY_YYYYMMDD',UniDate.get('today'));
			
//			var activeSForm ;
//			if(!UserInfo.appOption.collapseLeftSearch)	{
//				activeSForm = panelSearch;
//			}else {
//				activeSForm = panelResult;
//			}
//			activeSForm.onLoadSelectText('DUTY_YYYYMMDD');
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			
			
			var viewLocked = masterGrid1.getView();
			var viewNormal = masterGrid1.getView();
			
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
	    	viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
	    	viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);
	    	viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
	    	
	    	UniHuman.deptAuth(UserInfo.deptAuthYn, panelResult, "deptstree", "DEPTS2");
	    	
	    	
		},
		
		
		
		onQueryButtonDown: function()	{		
			var activeTabId = tab.getActiveTab().getId();		

			if(activeTabId == 'ham600skrGrid1'){
				if(!this.isValidSearchForm()){
					return false;
				}
				directMasterStore1.loadStoreRecords();
				
				var viewLocked = masterGrid1.getView();
				var viewNormal = masterGrid1.getView();
				
				viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    	viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    	viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    	viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			}
			else if(activeTabId == 'ham600skrTab2'){
				if(!this.isValidSearchForm()){
					return false;
				}
				directMasterStore2.loadStoreRecords();
				
				var viewLocked = masterGrid2.getView();
				var viewNormal = masterGrid2.getView();
				
				viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    	viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    	viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    	viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			}		
		}/*	
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult1.clearForm();
			panelResult2.clearForm();
			masterGrid1.reset();
			masterGrid2.reset();
			
			this.fnInitBinding();
		},*/
	});//End of Unilite.Main( {

	
	// 모델 필드 생성 grid1
	function createModelField1(colData) {
		var fields = [
						{name: 'DIV_NAME' 		, text: '사업장'	, type: 'string'},
						{name: 'DEPT_NAME' 		, text: '부서'	, type: 'string'},
						{name: 'POST_NAME' 		, text: '직위'	, type: 'string'},
						{name: 'NAME' 			, text: '성명'	, type: 'string'},
						{name: 'PERSON_NUMB' 	, text: '사번'	, type: 'string'},
						{name: 'DUTY_YYYYMMDD' 	, text: '근태일자'	, type: 'uniDate'},
						{name: 'DUTY_CODE' 		, text: '근태구분'	, type: 'string'},
						{name: 'DUTY_FR_D' 		, text: '일자'	, type: 'uniDate'},
						{name: 'DUTY_FR_H' 		, text: '시'		, type: 'string'},
						{name: 'DUTY_FR_M' 		, text: '분'		, type: 'string'},
				    	{name: 'DUTY_TO_D' 		, text: '일자'	, type: 'string'},
				    	{name: 'DUTY_TO_H' 		, text: '시'		, type: 'string'},
				    	{name: 'DUTY_TO_M' 		, text: '분'		, type: 'string'}
					];
					
		Ext.each(colData, function(item, index){
			fields.push({name: 'NUM' + index, text: item.DUTY_NAME, type:'uniPrice' });
		});
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성 grid1
	function createGridColumn1(colData) {
		var columns = [
		   			{dataIndex: 'DIV_NAME',		width: 130, summaryType: 'totaltext' , 
		   					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
		   				}
	            	},
					{dataIndex: 'DEPT_NAME',	width: 160},
					{dataIndex: 'POST_NAME',	width: 100, summaryType: 'totaltext'},
					{dataIndex: 'NAME',			width: 100},
					{dataIndex: 'PERSON_NUMB',	width: 100},
					{dataIndex: 'DUTY_YYYYMMDD',width: 100, summaryType: 'humsum'},
					{dataIndex: 'DUTY_CODE',	width: 100},
					{text:'출근일자',
						columns:[ 
							{dataIndex: 'DUTY_FR_D', width:100},
							{dataIndex: 'DUTY_FR_H', width:66 , align:'right'},
							{dataIndex: 'DUTY_FR_M', width:66 , align:'right'}
					]},
					{text:'퇴근일자',
						columns:[ 
							{dataIndex: 'DUTY_TO_D', width:100},
							{dataIndex: 'DUTY_TO_H', width:66 , align:'right'},
							{dataIndex: 'DUTY_TO_M', width:66 , align:'right'}
					]}
				];
					
		Ext.each(colData, function(item, index){
			columns.push({dataIndex: 'NUM' + index,		width: 100,   summaryType: 'sum' ,decimalPrecision:2, format:'0,000.00'});	
		});
// 		console.log(columns);
		return columns;
	}
	
	// 모델 필드 생성 grid2
	function createModelField2(colData) {
		var fields = [
						{name: 'DIV_NAME' 		, text: '사업장'	, type: 'string' , 
		   						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					        	return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
			   				}
		            	},
						{name: 'DEPT_NAME' 		, text: '부서'	, type: 'string'},
						{name: 'POST_NAME' 		, text: '직위'	, type: 'string'},
						{name: 'NAME' 			, text: '성명'	, type: 'string'},
						{name: 'PERSON_NUMB' 	, text: '사번'	, type: 'string'}
					];
					
		Ext.each(colData, function(item, index){
			fields.push({name: 'DUTY_NUM' + index, text: '일수', type:'int' });
			fields.push({name: 'DUTY_TIME' + index, text: '시간', type:'float' });
		});
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성 grid2
	function createGridColumn2(colData) {
		var columns = [
		   			{dataIndex: 'DIV_NAME',		width: 130, summaryType: 'totaltext' , 
	   						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				        	return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
		   				}
	            	},
					{dataIndex: 'DEPT_NAME',	width: 160},
					{dataIndex: 'POST_NAME',	width: 88, summaryType: 'totaltext'},
					{dataIndex: 'NAME',			width: 88},
					{dataIndex: 'PERSON_NUMB',	width: 88}
				];
					
		Ext.each(colData, function(item, index){
			columns.push(
				{text:item.DUTY_NAME,
					columns:[ 
						{dataIndex: 'DUTY_NUM' + index, width:66 , summaryType: 'sum'},
						{dataIndex: 'DUTY_TIME' + index, width:66,summaryType: 'sum' ,decimalPrecision:2, format:'0,000.00'}
				]}
			);
		});
// 		console.log(columns);
		return columns;
	}
/*	
	// Grid 의 summary row의  표시 /숨김 적용
    function setGridSummary(store, grid, viewable){
    	if (store.getCount() > 0) {
            if (viewable) {
            	viewLocked.getFeature('masterGridTotal').enable();
            	viewNormal.getFeature('masterGridTotal').enable();
            } else {
            	viewLocked.getFeature('masterGridTotal').disable();
            	viewNormal.getFeature('masterGridTotal').disable();
            }
            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(viewable);
            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(viewable);
    	}
    }
		*/
};


</script>
