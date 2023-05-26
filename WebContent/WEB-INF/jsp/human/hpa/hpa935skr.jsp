<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa935skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="hpa935skr" /> 			<!-- 사업장 -->>
	
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
	Unilite.defineModel('hpa935skrModel', {
		fields: [ 
			{name: 'COMP_CODE'		,	text: '법인코드'		, type: 'string'},
	    	{name: 'PERSON_NUMB'	,	text: '사번'			, type: 'string'},
	    	{name: 'NAME'			,	text: '성명'			, type: 'string'},
    		{name: 'BANKBOOK_NAME'	,	text: '예금주'		, type: 'string'},
	    	{name: 'BANK_CODE'		,	text: '은행코드'		, type: 'string'},
	    	{name: 'BANK_NAME'		,	text: '은행명'		, type: 'string'},
	    	{name: 'BANK_ACCOUNT'	,	text: '계좌번호'		, type: 'string'},
	    	{name: 'REAL_AMOUNT_I'	,	text: '입금액'		, type: 'int'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hpa935skrMasterStore1', {
		model: 'hpa935skrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'hpa935skrService.selectList'                	
			}
		},
		loadStoreRecords: function(){
//			var param= Ext.getCmp('searchForm').getValues();			
			var param= Ext.getCmp('panelResultForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});	
		},groupField: 'BANK_CODE'
	});

	/**
	 * 검색조건
	 * @type 
	 */	
	var panelResult = Unilite.createSimpleForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
					fieldLabel: '급여년월',
					id: 'PAY_YYYYMM',
					xtype: 'uniMonthfield',
					name: 'PAY_YYYYMM',
					labelWidth:90,
					value: new Date(),
			        tdAttrs: {width: 300},
					allowBlank: false
	                
	            },{
					fieldLabel: '사업장',
					name:'DIV_CODE', 
					xtype: 'uniCombobox',
			        multiSelect: false, 
			        typeAhead: false,
			        comboType:'BOR120',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
	//						panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				}
			]
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('hpa935skrGrid1', {
    	// for tab    	
		layout: 'fit',
		region:'center',
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
			showSummaryRow: true
		},{
			id: 'masterGridTotal',		
			ftype: 'uniSummary',			
			showSummaryRow: true
			}
    	],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'COMP_CODE'		, width: 120, hidden:true}, 				
			{dataIndex: 'PERSON_NUMB'	, width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
			
			{dataIndex: 'NAME'			, width: 100 },
			{dataIndex: 'BANKBOOK_NAME'	, width: 100},
			{dataIndex: 'BANK_CODE'		, width: 90},
			{dataIndex: 'BANK_NAME'		, width: 150},
			{dataIndex: 'BANK_ACCOUNT'	, width: 140},
			{dataIndex: 'REAL_AMOUNT_I'	, width: 100, summaryType: 'sum' ,xtype:'uniNnumberColumn', format: UniFormat.Price}
		] 
	});//End of var masterGrid = Unilite.createGrid('hpa935skrGrid1', {   

	Unilite.Main({
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            	masterGrid, panelResult
	     	]
	     }
//	         panelSearch
	    ], 
		id: 'hpa935skrApp',
		fnInitBinding: function() {
//			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
//			panelSearch.setValue('DATE',UniDate.get('today'));
			panelResult.setValue('PAY_YYYYMM',new Date());
			
			
//			var activeSForm ;
//			if(!UserInfo.appOption.collapseLeftSearch)	{
//				activeSForm = panelSearch;
//			}else {
//				activeSForm = panelResult;
//			}
//			activeSForm.onLoadSelectText('DIV_CODE');
			
//			UniAppManager.setToolbarButtons('detail',false);
//			UniAppManager.setToolbarButtons('reset',false);
//			UniAppManager.setToolbarButtons('save',false);
			
//			UniHuman.deptAuth(UserInfo.deptAuthYn, panelSearch, "deptstree", "DEPTS2");
			//UniHuman.deptAuth(UserInfo.deptAuthYn, panelResult, "deptstree", "DEPTS2");
			
			
		},
		onQueryButtonDown: function() {			
			
			if(!this.isValidSearchForm()){
                return false;
            }
						
			masterGrid.getStore().loadStoreRecords();
			
			//var viewLocked = masterGrid.getView();
			//var viewNormal = masterGrid.getView();
		    //viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    //viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    //viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    //viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}/*,
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			
			this.fnInitBinding();
		}*/
	});//End of Unilite.Main( {
};


</script>
