<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ham800skr"  >
	<t:ExtComboStore comboType="BOR120"  />
	<t:ExtComboStore comboType="AU" comboCode="H032" /> <!-- 지급구분 --> 
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
	Unilite.defineModel('Ham800skrModel1', {
	    fields: [
			{name: 'WAGES_CODE'		, text: '지급내역'	, type: 'string'},
	    	{name: 'AMOUNT_I'		, text: '지급금액'	, type: 'uniPrice'}
		]
	});//End of Unilite.defineModel('Ham800skrModel1', {
	
	Unilite.defineModel('Ham800skrModel2', {
	    fields: [
	    	{name: 'DED_CODE'		, text: '공제내역'	, type: 'string'},
	    	{name: 'DED_AMOUNT_I'	, text: '공제금액'	, type: 'uniPrice'}
		]
	});//End of Unilite.defineModel('Ham800skrModel2', {
		
	Unilite.defineModel('Ham800skrModel3', {
	    fields: [
	    	{name: 'DEPT_NAME'		, text: '부서'		, type: 'string'},
	    	{name: 'POST_CODE'		, text: '직위'		, type: 'string'},
	    	{name: 'ABIL_CODE'		, text: '직책'		, type: 'string'},
    		{name: 'EMPLOY_TYPE'	, text: '사원구분'		, type: 'string'},
	    	{name: 'PAY_CODE'		, text: '급여지급방식'	, type: 'string'},
	    	{name: 'TAX_CODE'		, text: '세액구분'		, type: 'string'},
	    	{name: 'SUPP_TOTAL_I'	, text: '지급총액'		, type: 'uniPrice'},
	    	{name: 'DED_TOTAL_I'	, text: '공제총액'		, type: 'uniPrice'},
	    	{name: 'REAL_AMOUNT_I'	, text: '실지급액'		, type: 'uniPrice'}
		]
	});//End of Unilite.defineModel('Ham800skrModel3', {	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ham800skrMasterStore1',{
		model: 'Ham800skrModel1',
		uniOpt: {
			isMaster : false,			// 상위 버튼 연결 
			editable : false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi  : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'ham800skrService.selectList1'                	
			}
		},
		listeners : {
	       /* load : function(store) {
	            if (store.getCount() > 0) {
	            	showSummaryRow('grid1', true);
	            }
	        }*/
	    },
		loadStoreRecords: function(person_numb){
			/*if (person_numb != null && person_numb != '') {
				panelSearch.getForm().setValues({'PERSON_NUMB' : person_numb});
				panelResult.getForm().setValues({'PERSON_NUMB' : person_numb});
				// TODO : 이름 삽입
				//panelSearch.getForm().setValues({'NAME' : person_numb});
				//panelResult.getForm().setValues({'NAME' : person_numb});
			}*/
			var param= Ext.getCmp('searchForm').getValues();
// 			if (person_numb != null && person_numb != '') {
// 				param.PERSON_NUMB = person_numb;
// 			}
			console.log( param );
			this.load({
				params: param
			});
		}
	});//End of var directMasterStore1 = Unilite.createStore('ham800skrMasterStore1',{

	var directMasterStore2 = Unilite.createStore('ham800skrMasterStore2',{
		model: 'Ham800skrModel2',
		uniOpt: {
			isMaster : false,			// 상위 버튼 연결 
			editable : false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi  : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'ham800skrService.selectList2'                	
			}
		},
		listeners : {
	        /*load : function(store) {
	            if (store.getCount() > 0) {
	            	showSummaryRow('grid2', true);
	            }
	        }*/
	    },
		loadStoreRecords: function(person_numb){
			/*if (person_numb != null && person_numb != '') {
				panelSearch.getForm().setValues({'PERSON_NUMB' : person_numb});		
				panelResult.getForm().setValues({'PERSON_NUMB' : person_numb});	
			}*/
			var param= Ext.getCmp('searchForm').getValues();
// 			if (person_numb != null && person_numb != '') {
// 				param.PERSON_NUMB = person_numb;
// 			}
			console.log( param );
			this.load({
				params: param
			});
		}
	});
	
	var directMasterStore3 = Unilite.createStore('ham800skrMasterStore3',{
		model: 'Ham800skrModel3',
		uniOpt: {
			isMaster : false,			// 상위 버튼 연결 
			editable : false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi  : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'ham800skrService.selectList3'                	
			}
		},
		listeners: {
	        load: function(store, records) {
	            var form = Ext.getCmp('resultForm');
	            if (store.getCount() > 0) {
	            	form.loadRecord(store.data.first());
	            } else {
	            	form.reset();
	            }
	            //checkAvailableNavi();
	        }
	    }
		,
		loadStoreRecords: function(person_numb){
		/*	if (person_numb != null && person_numb != '') {
				panelSearch.getForm().setValues({'PERSON_NUMB' : person_numb});
				panelResult.getForm().setValues({'PERSON_NUMB' : person_numb});
			}*/
			var param= Ext.getCmp('searchForm').getValues();
// 			if (person_numb != null && person_numb != '') {
// 				param.PERSON_NUMB = person_numb;
// 			}
			console.log( param );
			this.load({
				params: param
			});
		}
	});
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',		
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '기본정보', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '지급구분', 
				name: 'SUPP_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'H032', 
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SUPP_TYPE', newValue);
					}
				}   
			},{
				fieldLabel: '급여년월', 
				name: 'PAY_YYYYMM', 
				xtype: 'uniMonthfield',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_YYYYMM', newValue);
					}
				}
			},
				Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				allowBlank: false,
				listeners: {
					/*onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					}*/
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			})]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	
	var panelResult = Unilite.createSimpleForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
	    	items: [{ 
		        	fieldLabel: '지급구분',
		        	name: 'SUPP_TYPE', 
		        	xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'H032', 
					allowBlank: false,
		        	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('SUPP_TYPE', newValue);
						}
					}
	        	},{
					fieldLabel: '급여년월', 
					name: 'PAY_YYYYMM', 
					xtype: 'uniMonthfield',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('PAY_YYYYMM', newValue);
						}
					}    
				},
				Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				colspan:2,
				validateBlank:false,
				autoPopup:true,
				allowBlank: false,
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
						panelSearch.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('NAME', newValue);				
					}
				}
			})]
    });
	 
	 var panelEast = Unilite.createForm('resultForm',{
	 	disabled :false
	 	,layout: 'fit'
    	,region: 'east',  
	    //layout: {type: 'vbox', align : 'stretch'},
	    items: [{	
	    	xtype:'panel',
	    	border: false,
	        defaultType: 'uniTextfield',
	        layout: {type: 'uniTable', columns : 1},
	        padding:'50,0,0,0',
	        items: [
	        	{fieldLabel: '부서'			, name: 'DEPT_NAME' 		, readOnly:true},
				{fieldLabel: '직위'			, name: 'POST_CODE' 		, readOnly:true}, 
				{fieldLabel: '직책'			, name: 'ABIL_CODE' 		, readOnly:true},
				{fieldLabel: '사원구분'		, name:'EMPLOY_TYPE' 		, readOnly:true},
				{fieldLabel: '급여지급방식'		, name:'PAY_CODE' 			, readOnly:true},
				{fieldLabel: '세액구분'		, name:'TAX_CODE'   		, readOnly:true},
				{
		        	xtype: 'component',
		        	tdAttrs: {height: 30}
		        },
				{fieldLabel: '지급총액'		, name:'SUPP_TOTAL_I' 		,xtype : 'uniNumberfield', readOnly:true},
				{fieldLabel: '공제총액'		, name:'DED_TOTAL_I' 		,xtype : 'uniNumberfield', readOnly:true},
				{fieldLabel: '실지급액'		, name:'REAL_AMOUNT_I'		,xtype : 'uniNumberfield', readOnly:true}
			]
		}]

    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid1 = Unilite.createGrid('ham800skrGrid1', {
		layout: 'fit',
		region: 'west',
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
		store: directMasterStore1,
		columns: [
			{dataIndex: 'WAGES_CODE'		, width: 180
			,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            }},
			{dataIndex: 'AMOUNT_I'			, width: 250, summaryType:'sum'}
		] 
	});//End of var masterGrid = Unilite.createGrid('ham800skrGrid1', {   
	
	var masterGrid2 = Unilite.createGrid('ham800skrGrid2', {
		layout: 'fit',
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
			id: 'masterGridSubTotal2',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false
		},{
			id: 'masterGridTotal2',		
			ftype: 'uniSummary',			
			showSummaryRow: false
			}
    	],
		store: directMasterStore2,
		columns: [
			{dataIndex: 'DED_CODE'			, width: 180
			,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            }},
			{dataIndex: 'DED_AMOUNT_I'		, width: 250, summaryType:'sum'}
		] 
	});
   Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			//flex: 2,
			/*items:[
			 	panelResult, masterGrid1, masterGrid2, panelEast 
			]	*/
			
			items:[
				panelResult, masterGrid1, masterGrid2,
				{	flex: 0.8,
					region : 'east',
					xtype : 'container',
					layout : 'fit',
					items : [ panelEast ]
				}
			]
		}		
		,panelSearch
		],
		id: 'ham800skrApp',
		fnInitBinding: function() {
			panelSearch.setValue('SUPP_TYPE',1);
			panelResult.setValue('SUPP_TYPE',1);
			
			panelSearch.setValue('PAY_YYYYMM',UniDate.get('today'));
			panelResult.setValue('PAY_YYYYMM',UniDate.get('today'));
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('SUPP_TYPE');
			
			UniAppManager.setToolbarButtons('reset', false);
			
			/*var viewLocked = masterGrid1.lockedGrid.getView();
			var viewNormal = masterGrid1.normalGrid.getView();
			var viewLocked2 = masterGrid2.lockedGrid.getView();
			var viewNormal2 = masterGrid2.normalGrid.getView();
			
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
	    	viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
	    	viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);
	    	viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);	
			
			viewLocked2.getFeature('masterGridSubTotal2').toggleSummaryRow(false);
	    	viewLocked2.getFeature('masterGridTotal2').toggleSummaryRow(false);
	    	viewNormal2.getFeature('masterGridSubTotal2').toggleSummaryRow(false);
	    	viewNormal2.getFeature('masterGridTotal2').toggleSummaryRow(false);*/
		},
		onQueryButtonDown: function()	{
			var detailform = panelSearch.getForm();
			if(!this.isValidSearchForm()){
				return false;
			}
			if (detailform.isValid()) {
				directMasterStore1.loadStoreRecords('');				
				directMasterStore2.loadStoreRecords('');
				directMasterStore3.loadStoreRecords('');	
				

				var viewNormal = masterGrid1.getView();
				
				var viewNormal2 = masterGrid2.getView();
				
		    	viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    	viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	
				
		    	viewNormal2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
		    	viewNormal2.getFeature('masterGridTotal2').toggleSummaryRow(true);
			}
		}
		/*onPrevDataButtonDown: function() {
			console.log('Go Prev > '+data[0].PV_D);
			directMasterStore1.loadStoreRecords(data[0].PV_D);				
			directMasterStore2.loadStoreRecords(data[0].PV_D);
			directMasterStore3.loadStoreRecords(data[0].PV_D);
		},
		onNextDataButtonDown: function() {
			console.log('Go Next >'+data[0].NX_D);
			directMasterStore1.loadStoreRecords(data[0].NX_D);				
			directMasterStore2.loadStoreRecords(data[0].NX_D);
			directMasterStore3.loadStoreRecords(data[0].NX_D);
		},*/
	});//End of Unilite.Main( {
	
	// 선택된 사원의 전후로 데이터가 있는지 검색함
/*	function checkAvailableNavi(){
		var param= Ext.getCmp('searchForm').getValues();
		console.log(param);
		Ext.Ajax.request({
			url     : CPATH+'/human/checkAvailableNavi.do',
			params: param,
			success: function(response){
				data = Ext.decode(response.responseText);
				console.log(data);
				var prevBtnAvailable = (data[0].PV_D == 'BOF' ? false : true)
				var nextBtnAvailable = (data[0].NX_D == 'EOF' ? false : true)
				UniAppManager.setToolbarButtons('prev', prevBtnAvailable);
				UniAppManager.setToolbarButtons('next', nextBtnAvailable);
// 				UniAppManager.setToolbarButtons('prev', true);
// 				UniAppManager.setToolbarButtons('next', true);
			},
			failure: function(response){
				console.log(response);
			}
		});
	}*/
	/*
	function showSummaryRow(grid, viewable) {
		if (grid == null || grid == '') {
			Ext.msg.Alert('오류', '오류가 발생하였습니다.');
			return false;
		} else {
			var useGrid = (grid == 'grid1' ? masterGrid1 : masterGrid2);
			var gridSummary = (grid == 'grid1' ? 'masterGridTotal1' : 'masterGridTotal2'); 
			
			//var viewLocked = useGrid.lockedGrid.getView();
			//var viewNormal = useGrid.normalGrid.getView();
		    viewLocked.getFeature(gridSummary).toggleSummaryRow(viewable);
		    viewNormal.getFeature(gridSummary).toggleSummaryRow(viewable);
		    //useGrid.getView().refresh();
		}
	}*/
};


</script>
