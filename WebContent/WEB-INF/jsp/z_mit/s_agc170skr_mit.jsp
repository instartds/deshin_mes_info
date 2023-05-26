<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_agc170skr_mit"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var fnSetFormTitle = ${fnSetFormTitle};
var BsaCodeInfo =  {
	gsFinancialY: '${gsFinancialY}'
}

function appMain() {     
	
	var len = fnSetFormTitle.length; 
	var tabTitle1 ='손익계산서';
	var tabTitle2 ='제조원가명세서';
	var tabTitle3 ='도급원가명세서';
	
	var hideTab1 = true;
	var hideTab2 = true;
	var hideTab3 = true;
	
	for(var i=0 ; i < len ; i++) { 
		if(fnSetFormTitle[i].SUB_CODE == '20'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab1 = false;
			}
			tabTitle1 = fnSetFormTitle[i].CODE_NAME;
		}
		if(fnSetFormTitle[i].SUB_CODE == '30'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab2 = false;
			}
			tabTitle2 = fnSetFormTitle[i].CODE_NAME;
		}
		if(fnSetFormTitle[i].SUB_CODE == '31'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab3 = false;
			}
			tabTitle3 = fnSetFormTitle[i].CODE_NAME;
		}
	}
	
	var getStDt = ${getStDt};// 당기시작년월
	
	
	/*function getMonth(index, mon) {
	 		var now2 = new Date();
	 		if (mon == '') {
	 			var month = now2.getMonth() +1 -index ;
	 		}  else {
	 			var month = mon -1 - index;	
	 		}
// 	 		alert(month);
		 	month = (month == 0) ? 12 : month;
 			month = (month < 0) ? (month + 12)  : month;
 			
 			return month < 10 ? '0' + month + '월' : month +'월';
					
		}*/
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('S_agc170skr_mitModel', {
	    fields: [  	  
	    	{name: 'GRP'			, text: 'GRP' 		,type: 'string'},
		    {name: 'ACCNT_CD'		, text: '항목코드'		,type: 'string'},
		    {name: 'ACCNT_NAME'		, text: '항목명' 		,type: 'string'},
		    {name: 'TOT_AMT_I1'		, text: '항목금액'		,type: 'uniPrice'},
		    {name: 'TOT_AMT_I2'		, text: '항목합계'		,type: 'uniPrice'},
		    {name: 'MONTH01'		, text: '1월'		,type: 'uniPrice'},
		    {name: 'MONTH02'		, text: '2월'		,type: 'uniPrice'},
		    {name: 'MONTH03'		, text: '3월'		,type: 'uniPrice'},
		    {name: 'MONTH04'		, text: '4월'		,type: 'uniPrice'},
		    {name: 'MONTH05'		, text: '5월'		,type: 'uniPrice'},
		    {name: 'MONTH06'		, text: '6월'		,type: 'uniPrice'},
		    {name: 'MONTH07'		, text: '7월'		,type: 'uniPrice'},
		    {name: 'MONTH08'		, text: '8월'		,type: 'uniPrice'},
		    {name: 'MONTH09'		, text: '9월'		,type: 'uniPrice'},
		    {name: 'MONTH10'		, text: '10월'		,type: 'uniPrice'},
		    {name: 'MONTH11'		, text: '11월'		,type: 'uniPrice'},
		    {name: 'MONTH12'		, text: '12월'		,type: 'uniPrice'},
		    {name: 'DIS_DIVI'		, text: 'DIS_DIVI'	,type: 'string'},
		    {name: 'OPT_DIVI'		, text: 'OPT_DIVI'	,type: 'string'},
		    {name: 'ACCNT'			, text: 'ACCNT'		,type: 'string'}
		    
		]          
	});
	
	Unilite.defineModel('S_agc170skr_mitModel2', {
	    fields: [  	  
	    	{name: 'GRP'			, text: 'GRP' 		,type: 'string'},
		    {name: 'ACCNT_CD'		, text: '항목코드'		,type: 'string'},
		    {name: 'ACCNT_NAME'		, text: '항목명' 		,type: 'string'},
		    {name: 'TOT_AMT_I1'		, text: '항목금액'		,type: 'uniPrice'},
		    {name: 'TOT_AMT_I2'		, text: '항목합계'		,type: 'uniPrice'},
		    {name: 'MONTH01'		, text: '1월'		,type: 'uniPrice'},
		    {name: 'MONTH02'		, text: '2월'		,type: 'uniPrice'},
		    {name: 'MONTH03'		, text: '3월'		,type: 'uniPrice'},
		    {name: 'MONTH04'		, text: '4월'		,type: 'uniPrice'},
		    {name: 'MONTH05'		, text: '5월'		,type: 'uniPrice'},
		    {name: 'MONTH06'		, text: '6월'		,type: 'uniPrice'},
		    {name: 'MONTH07'		, text: '7월'		,type: 'uniPrice'},
		    {name: 'MONTH08'		, text: '8월'		,type: 'uniPrice'},
		    {name: 'MONTH09'		, text: '9월'		,type: 'uniPrice'},
		    {name: 'MONTH10'		, text: '10월'		,type: 'uniPrice'},
		    {name: 'MONTH11'		, text: '11월'		,type: 'uniPrice'},
		    {name: 'MONTH12'		, text: '12월'		,type: 'uniPrice'},
		    {name: 'DIS_DIVI'		, text: 'DIS_DIVI'	,type: 'string'},
		    {name: 'OPT_DIVI'		, text: 'OPT_DIVI'	,type: 'string'},
		    {name: 'ACCNT'			, text: 'ACCNT'		,type: 'string'}
		    
		]          
	});
	
	Unilite.defineModel('S_agc170skr_mitModel3', {
	    fields: [  	  
	    	{name: 'GRP'			, text: 'GRP' 		,type: 'string'},
		    {name: 'ACCNT_CD'		, text: '항목코드'		,type: 'string'},
		    {name: 'ACCNT_NAME'		, text: '항목명' 		,type: 'string'},
		    {name: 'TOT_AMT_I1'		, text: '항목금액'		,type: 'uniPrice'},
		    {name: 'TOT_AMT_I2'		, text: '항목합계'		,type: 'uniPrice'},
		    {name: 'MONTH01'		, text: '1월'		,type: 'uniPrice'},
		    {name: 'MONTH02'		, text: '2월'		,type: 'uniPrice'},
		    {name: 'MONTH03'		, text: '3월'		,type: 'uniPrice'},
		    {name: 'MONTH04'		, text: '4월'		,type: 'uniPrice'},
		    {name: 'MONTH05'		, text: '5월'		,type: 'uniPrice'},
		    {name: 'MONTH06'		, text: '6월'		,type: 'uniPrice'},
		    {name: 'MONTH07'		, text: '7월'		,type: 'uniPrice'},
		    {name: 'MONTH08'		, text: '8월'		,type: 'uniPrice'},
		    {name: 'MONTH09'		, text: '9월'		,type: 'uniPrice'},
		    {name: 'MONTH10'		, text: '10월'		,type: 'uniPrice'},
		    {name: 'MONTH11'		, text: '11월'		,type: 'uniPrice'},
		    {name: 'MONTH12'		, text: '12월'		,type: 'uniPrice'},
		    {name: 'DIS_DIVI'		, text: 'DIS_DIVI'	,type: 'string'},
		    {name: 'OPT_DIVI'		, text: 'OPT_DIVI'	,type: 'string'},
		    {name: 'ACCNT'			, text: 'ACCNT'		,type: 'string'}
		    
		]          
	});
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('s_agc170skr_mitMasterStore1',{
		model: 'S_agc170skr_mitModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 's_agc170skr_mitService.selectList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			//param.START_DATE = param.START_DATE.substring(0, 4) + "01";
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore2 = Unilite.createStore('s_agc170skr_mitMasterStore2',{
		model: 'S_agc170skr_mitModel2',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 's_agc170skr_mitService.selectList2'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			//param.START_DATE = param.START_DATE.substring(0, 4) + "01";
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore3 = Unilite.createStore('s_agc170skr_mitMasterStore3',{
		model: 'S_agc170skr_mitModel3',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 's_agc170skr_mitService.selectList3'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			//param.START_DATE = param.START_DATE.substring(0, 4) + "01";
			console.log( param );
			this.load({
				params : param
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
        collapsed:true,
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
				fieldLabel: '조회기간',
	 		    //width: 315,
	            xtype: 'uniMonthRangefield',
	            startFieldName: 'START_DATE',
	            endFieldName: 'END_DATE',
		        //startDD: 'first',
		        //endDD: 'last',
		        allowBlank: false,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('START_DATE', newValue);						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('END_DATE', newValue);				    		
			    	}
			    }
			},{ 
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}
		]},{
			title:'추가정보',
			id: 'search_panel2',
			itemId:'search_panel2',
    		defaultType: 'uniTextfield',
    		layout : {type : 'uniTable', columns : 1},
    		defaultType: 'uniTextfield',
    		items:[{
		 		fieldLabel: '금액단위',
		 		name:'AMT_UNIT', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'B042',
		 		allowBlank:false,
		 		listeners: {
				    afterrender: function(combo) {
				        var recordSelected = combo.getStore().getAt(0);                     
				        combo.setValue(recordSelected.get('value'));
				    }
				}
	 		},{
		 		fieldLabel: '재무제표양식차수',
		 		name:'GUBUN', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'A093',
		 		value: BsaCodeInfo.gsFinancialY,
		 		allowBlank:false
	 		},{
				xtype: 'radiogroup',		            		
				fieldLabel: '과목출력',
				items: [{
					boxLabel: '한다', 
					width: 70, 
					name: 'PRINT',
					inputValue: '1'
				},{
					boxLabel : '안한다', 
					width: 70,
					name: 'PRINT',
					inputValue: '2',
					checked: true 
				}]
	 		},{
				xtype: 'radiogroup',		            		
				fieldLabel: '과목명',		
				items: [{
					boxLabel: '과목명1', 
					width: 70, 
					name: 'ACCOUNT_NAME',
					inputValue: '0'
				},{
					boxLabel : '과목명2', 
					width: 70,
					name: 'ACCOUNT_NAME',
					inputValue: '1'
				},{
					boxLabel: '과목명3', 
					width: 70, 
					name: 'ACCOUNT_NAME',
					inputValue: '2' 
				}]
	 		}]			
		}]
	});	//end panelSearch  
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '조회기간',
 		    //width: 315,
            xtype: 'uniMonthRangefield',
            startFieldName: 'START_DATE',
            endFieldName: 'END_DATE',
	        //startDD: 'first',
	        //endDD: 'last',
            allowBlank: false,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('START_DATE', newValue);						
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('END_DATE', newValue);				    		
		    	}
		    }
		},{ 
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
	        multiSelect: true, 
	        typeAhead: false,
	        value:UserInfo.divCode,
	        comboType:'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('s_agc170skr_mitGrid1', {
    	title  : tabTitle1,
    	hidden : hideTab1,
    	excelTitle: '월별재무제표' + '   (' + tabTitle1 + ')',
    	layout : 'fit',
        store : directMasterStore, 
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowNumberer		: true,				
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		sortableColumns : false,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
//	          	if(record.get('ACCNT') != ''){
//					cls = 'x-change-celltext_darkred';
//				}
	          	if(record.get('DIS_DIVI') == '3') {
	          		if(record.get('OPT_DIVI') == '5') {
	          			var accnt = record.get('ACCNT_CD');
	          			if(accnt.substring(accnt.length - 3, accnt.length) == "000" || accnt.substring(accnt.length - 3, accnt.length) == "999") {
	          				cls = 'x-change-cell_normal';
	          			}
	          			else {
	          				cls = 'x-change-cell_medium_light';
	          			}
	          		}
	          		else {
	          			cls = 'x-change-cell_light';
	          		}
				}
				
				return cls;
	        }
	    },
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'출력',
	        	handler: function() {
	        		UniAppManager.app.fnGotoAgc170rkr('20');  
            	}
        	}
        ],
        columns: [        
        	{dataIndex: 'GRP'			, width: 180 ,hidden: true}, 				
			{dataIndex: 'ACCNT_CD'		, width: 80	},
			{dataIndex: 'ACCNT_NAME'	, width: 230 , renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}},
			{dataIndex: 'TOT_AMT_I1'	, width: 106},
			{dataIndex: 'TOT_AMT_I2'	, width: 106},
			{dataIndex: 'MONTH01'		, width: 110},
			{dataIndex: 'MONTH02'		, width: 110},
			{dataIndex: 'MONTH03'		, width: 110},
			{dataIndex: 'MONTH04'		, width: 110},
			{dataIndex: 'MONTH05'		, width: 110},
			{dataIndex: 'MONTH06'		, width: 110},
			{dataIndex: 'MONTH07'		, width: 110},
			{dataIndex: 'MONTH08'		, width: 110},
			{dataIndex: 'MONTH09'		, width: 110},
			{dataIndex: 'MONTH10'		, width: 110},
			{dataIndex: 'MONTH11'		, width: 110},
			{dataIndex: 'MONTH12'		, width: 110}
			/*{dataIndex: 'DIS_DIVI'		, width: 100 , hidden: true},
			{dataIndex: 'OPT_DIVI'		, width: 100 , hidden: true},
			{dataIndex: 'ACCNT'			, width: 100 , hidden: true}*/
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts, column )	{
	        	view.ownerGrid.setCellPointer(view, item);
        	},
        	onGridDblClick :function( grid, record, cellIndex, colName ) {
        		if(record.get('ACCNT') == ''){
        			return false;
        		}
                masterGrid.gotoAgc170skr(record);
        	}
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
        	if(record.get('ACCNT') == ''){
        		return false;
        	}else{	
      			return true;
        	}
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '보조부 보기',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAgc170skr(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAgc170skr:function(record)	{
	    	if(record)	{	
	    		var stDate = panelSearch.getValue('START_DATE');
	    		var frDate = UniDate.getDbDateStr(stDate).substring(0, 6) + '01'
	    		var toDate = UniDate.getDbDateStr(stDate).substring(0, 4) + '1231'
   		
	    		var params = {
			    		action:'select',
				    	'PGM_ID' 			: 'agc170skr',   	
				    	'ST_DATE'			: stDate,
				    	'FR_DATE'	    	: frDate,
				    	'TO_DATE'			: toDate,
				    	'ACCNT'				: record.data['ACCNT'],
				    	'ACCNT_NAME'		: record.data['ACCNT_NAME'],
				    	'DIV_CODE'			: panelSearch.getValue('DIV_CODE'),
				    	'DIV_NAME'			: panelSearch.getValue('DIV_NAME')
		    		}
	    		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb110skr.do', params);	
	    	}
	    }
    });
    
    var masterGrid2 = Unilite.createGrid('s_agc170skr_mitGrid2', {
    	title  : tabTitle2,
    	hidden : hideTab2,
    	excelTitle: '월별재무제표' + '   (' + tabTitle2 + ')',
    	layout : 'fit',
        store : directMasterStore2, 
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowNumberer		: true,				
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		sortableColumns : false,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
//	          	if(record.get('ACCNT') != ''){
//					cls = 'x-change-celltext_darkred';
//				}
	          	if(record.get('DIS_DIVI') == '3') {
	          		if(record.get('OPT_DIVI') == '5') {
	          			var accnt = record.get('ACCNT_CD');
	          			if(accnt.substring(accnt.length - 3, accnt.length) == "000" || accnt.substring(accnt.length - 3, accnt.length) == "999") {
	          				cls = 'x-change-cell_normal';
	          			}
	          			else {
	          				cls = 'x-change-cell_medium_light';
	          			}
	          		}
	          		else {
	          			cls = 'x-change-cell_light';
	          		}
				}
				
				return cls;
	        }
	    },
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'출력',
	        	handler:function()	{
	        		UniAppManager.app.fnGotoAgc170rkr('30');
	        	}
        	}
        ],
        columns: [        
        	{dataIndex: 'GRP'			, width: 180 , hidden: true}, 				
			{dataIndex: 'ACCNT_CD'		, width: 80	},
			{dataIndex: 'ACCNT_NAME'	, width: 230 , renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}},
			{dataIndex: 'TOT_AMT_I1'	, width: 106},
			{dataIndex: 'TOT_AMT_I2'	, width: 106},
			{dataIndex: 'MONTH01'		, width: 110},
			{dataIndex: 'MONTH02'		, width: 110},
			{dataIndex: 'MONTH03'		, width: 110},
			{dataIndex: 'MONTH04'		, width: 110},
			{dataIndex: 'MONTH05'		, width: 110},
			{dataIndex: 'MONTH06'		, width: 110},
			{dataIndex: 'MONTH07'		, width: 110},
			{dataIndex: 'MONTH08'		, width: 110},
			{dataIndex: 'MONTH09'		, width: 110},
			{dataIndex: 'MONTH10'		, width: 110},
			{dataIndex: 'MONTH11'		, width: 110},
			{dataIndex: 'MONTH12'		, width: 110}
			/*{dataIndex: 'DIS_DIVI'		, width: 100 , hidden: true},
			{dataIndex: 'OPT_DIVI'		, width: 100 , hidden: true},
			{dataIndex: 'ACCNT'			, width: 100 , hidden: true}*/
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts, column )	{
	        	view.ownerGrid.setCellPointer(view, item);
        	},
        	onGridDblClick :function( grid, record, cellIndex, colName ) {
        		if(record.get('ACCNT') == ''){
        			return false;
        		}
                masterGrid2.gotoAgc170skr2(record);
        	}
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
        	if(record.get('ACCNT') == ''){
        		return false;
        	}else{	
      			return true;
        	}
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '보조부 보기',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid2.gotoAgc170skr2(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAgc170skr2:function(record)	{
	    	if(record)	{	
	    		var stDate = panelSearch.getValue('START_DATE');
	    		var frDate = UniDate.getDbDateStr(stDate).substring(0, 6) + '01'
	    		var toDate = UniDate.getDbDateStr(stDate).substring(0, 4) + '1231'
   		
	    		var params = {
			    		action:'select',
				    	'PGM_ID' 			: 'agc170skr',   	
				    	'ST_DATE'			: stDate,
				    	'FR_DATE'	    	: frDate,
				    	'TO_DATE'			: toDate,
				    	'ACCNT'				: record.data['ACCNT'],
				    	'ACCNT_NAME'		: record.data['ACCNT_NAME'],
				    	'DIV_CODE'			: panelSearch.getValue('DIV_CODE'),
				    	'DIV_NAME'			: panelSearch.getValue('DIV_NAME')
		    		}
	    		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb110skr.do', params);	
	    	}
	    }
    });
    
    var masterGrid3 = Unilite.createGrid('s_agc170skr_mitGrid3', {
    	title  : tabTitle3,
    	hidden : hideTab3,
    	excelTitle: '월별재무제표' + '   (' + tabTitle3 + ')',
    	layout : 'fit',
        store : directMasterStore3, 
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowNumberer		: true,				
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		sortableColumns : false,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
//	          	if(record.get('ACCNT') != ''){
//					cls = 'x-change-celltext_darkred';
//				}
	          	if(record.get('DIS_DIVI') == '3') {
	          		if(record.get('OPT_DIVI') == '5') {
	          			var accnt = record.get('ACCNT_CD');
	          			if(accnt.substring(accnt.length - 3, accnt.length) == "000" || accnt.substring(accnt.length - 3, accnt.length) == "999") {
	          				cls = 'x-change-cell_normal';
	          			}
	          			else {
	          				cls = 'x-change-cell_medium_light';
	          			}
	          		}
	          		else {
	          			cls = 'x-change-cell_light';
	          		}
				}
				
				return cls;
	        }
	    },
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'출력',
	        	handler:function()	{
	        		UniAppManager.app.fnGotoAgc170rkr('31');
	        	}
        	}
        ],
        columns: [        
        	{dataIndex: 'GRP'			, width: 180 , hidden: true}, 				
			{dataIndex: 'ACCNT_CD'		, width: 80	},
			{dataIndex: 'ACCNT_NAME'	, width: 230 , renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}},
			{dataIndex: 'TOT_AMT_I1'	, width: 106},
			{dataIndex: 'TOT_AMT_I2'	, width: 106},
			{dataIndex: 'MONTH01'		, width: 110},
			{dataIndex: 'MONTH02'		, width: 110},
			{dataIndex: 'MONTH03'		, width: 110},
			{dataIndex: 'MONTH04'		, width: 110},
			{dataIndex: 'MONTH05'		, width: 110},
			{dataIndex: 'MONTH06'		, width: 110},
			{dataIndex: 'MONTH07'		, width: 110},
			{dataIndex: 'MONTH08'		, width: 110},
			{dataIndex: 'MONTH09'		, width: 110},
			{dataIndex: 'MONTH10'		, width: 110},
			{dataIndex: 'MONTH11'		, width: 110},
			{dataIndex: 'MONTH12'		, width: 110}
			/*{dataIndex: 'DIS_DIVI'		, width: 100 , hidden: true},
			{dataIndex: 'OPT_DIVI'		, width: 100 , hidden: true},
			{dataIndex: 'ACCNT'			, width: 100 , hidden: true}*/
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts, column )	{
	        	view.ownerGrid.setCellPointer(view, item);
        	},
        	onGridDblClick :function( grid, record, cellIndex, colName ) {
        		if(record.get('ACCNT') == ''){
        			return false;
        		}
                masterGrid3.gotoAgc170skr3(record);
        	}
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
        	if(record.get('ACCNT') == ''){
        		return false;
        	}else{	
      			return true;
        	}
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '보조부 보기',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid3.gotoAgc170skr3(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAgc170skr3:function(record)	{
	    	if(record)	{	
	    		var stDate = panelSearch.getValue('START_DATE');
	    		var frDate = UniDate.getDbDateStr(stDate).substring(0, 6) + '01'
	    		var toDate = UniDate.getDbDateStr(stDate).substring(0, 4) + '1231'
   		
	    		var params = {
			    		action:'select',
				    	'PGM_ID' 			: 'agc170skr',   	
				    	'ST_DATE'			: stDate,
				    	'FR_DATE'	    	: frDate,
				    	'TO_DATE'			: toDate,
				    	'ACCNT'				: record.data['ACCNT'],
				    	'ACCNT_NAME'		: record.data['ACCNT_NAME'],
				    	'DIV_CODE'			: panelSearch.getValue('DIV_CODE'),
				    	'DIV_NAME'			: panelSearch.getValue('DIV_NAME')
		    		}
	    		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb110skr.do', params);	
	    	}
	    }
    });
     var tab = Unilite.createTabPanel('tabPanel',{
    	region:'center',
	    items: [
	         masterGrid,
	         masterGrid2,
	         masterGrid3
	    ],
	    listeners:{
    		beforetabchange: function( tabPanel, newCard, oldCard, eOpts )	{
    			if(!UniAppManager.app.isValidSearchForm()){
					return false;
				}	
    		},
    		tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
				var value = Ext.getCmp('searchForm').getForm().findField('START_DATE').getValue();		 		
				var month = new Date(value).getMonth() + 1;	
					
    			if(newCard.getItemId() == 's_agc170skr_mitGrid1')	{					       
					//changeColumns(month);
    				UniAppManager.app.onQueryButtonDown();
    			}else if(newCard.getItemId() == 's_agc170skr_mitGrid2') {						       
					//changeColumns2(month);
    				UniAppManager.app.onQueryButtonDown();
    			}else if(newCard.getItemId() == 's_agc170skr_mitGrid3') {						       
					//changeColumns3(month);
    				UniAppManager.app.onQueryButtonDown();
    			}
    		}
    	}
    });
    
	Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
					tab, panelResult
				]
			},
			panelSearch  	
		], 
		id : 's_agc170skr_mitApp',
		fnInitBinding : function() {
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('START_DATE');
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			panelResult.setValue('START_DATE',getStDt[0].STDT);
			
			var EDDT = UniAppManager.app.addMonth(getStDt[0].STDT, 11);
			EDDT = EDDT.substring(0, 6);
			
			panelSearch.setValue('END_DATE',EDDT);
			panelResult.setValue('END_DATE',EDDT);
			
			var stDate = Ext.getCmp('searchForm').getValues().START_DATE;
			var edDate = Ext.getCmp('searchForm').getValues().END_DATE;
			
			UniAppManager.app.fnSetGridHeaderMonth(masterGrid , stDate, edDate);
			UniAppManager.app.fnSetGridHeaderMonth(masterGrid2, stDate, edDate);
			UniAppManager.app.fnSetGridHeaderMonth(masterGrid3, stDate, edDate);
			
		},
		onQueryButtonDown : function()	{	
			if(!this.isValidSearchForm()){
				return false;
			}
			var activeTabId = tab.getActiveTab().getId();		
	
			var stDate = Ext.getCmp('searchForm').getValues().START_DATE;
			var edDate = Ext.getCmp('searchForm').getValues().END_DATE;
			
			if(stDate.substring(0, 4) != edDate.substring(0, 4)) {
				alert("회기를 초과하여 조회하실 수 없습니다.");
				return;
			}
			
			if(activeTabId == 's_agc170skr_mitGrid1'){
				directMasterStore.loadStoreRecords();
				UniAppManager.app.fnSetGridHeaderMonth(masterGrid, stDate, edDate);
			}else if (activeTabId == 's_agc170skr_mitGrid2'){
				directMasterStore2.loadStoreRecords();
				UniAppManager.app.fnSetGridHeaderMonth(masterGrid2, stDate, edDate);
			}else if (activeTabId == 's_agc170skr_mitGrid3'){
				directMasterStore3.loadStoreRecords();
				UniAppManager.app.fnSetGridHeaderMonth(masterGrid3, stDate, edDate);
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		//20200619 수정: 신규 프로그램 월별재무제표출력(MIT) (s_agc170rkr_mit)로 링크 설정
		fnGotoAgc170rkr: function(type) {
			var params = {
				PGM_ID			: 's_agc170skr_mit',
				START_DATE		: panelSearch.getValue('START_DATE'),
				END_DATE		: panelSearch.getValue('END_DATE'),
				DIV_CODE		: panelSearch.getValue('DIV_CODE'),
				AMT_UNIT		: panelSearch.getValue('AMT_UNIT'),
				ACCOUNT_NAME	: panelSearch.getValues().ACCOUNT_NAME,
				PRINT			: panelSearch.getValues().PRINT,
				GUBUN			: panelSearch.getValue('GUBUN'),
				TYPE			: type
			};
			var rec = {data : {prgID : 's_agc170rkr_mit', 'text':''}};
			parent.openTab(rec, '/z_mit/s_agc170rkr_mit.do', params); 
        },
        fnSetGridHeaderMonth : function(grid, dtFr, dtTo) {
        	//var dtSt = dtFr.substring(0, 4) + "01";
        	var dtSt = dtFr.substring(0, 6);
        	dtSt = UniDate.getDbDateStr(dtSt);
        	//dtTo = UniDate.getDbDateStr(dtTo);
        	
        	for(var i = 0; i < 12; i++) {
        		var mon = this.addMonth(dtSt, i);
        		grid.columns[i+6].setText(mon.substring(0, 4) + '년 ' + mon.substring(4, 6) + '월');
        		
        		if(mon.substring(0, 6) >= dtFr && mon.substring(0, 6) <= dtTo) {
        			grid.columns[i+6].setHidden(false);
        		}
        		else {
        			grid.columns[i+6].setHidden(true);	//true
        		}
        	}
        },
        addMonth : function(dt, m) {
        	dt = dt.substring(0, 4) + "-" + dt.substring(4, 6) + "-" + dt.substring(6, 8);
        	var newDt = new Date(dt);
        	newDt.setMonth(newDt.getMonth() + m);
        	return String(newDt.getFullYear()) + (newDt.getMonth() + 1 < 10 ? "0" : "") + String(newDt.getMonth() + 1) + (newDt.getDate() < 10 ? "0" : "") + String(newDt.getDate());
        }
	});
	
	function changeColumns(month) {
			for(var i = 0; i < 12; i++) {
				var newMonth = parseInt(month) + i;
				newMonth = (newMonth == 0) ? 12 : newMonth;
				newMonth = (newMonth > 12) ? (newMonth - 12)  : newMonth;
				newMonth = (newMonth < 0)  ? (newMonth + 12)  : newMonth;
				newMonth = (newMonth < 10) ?   newMonth + '월' : newMonth +'월';
				masterGrid.columns[i+6].setText(newMonth);	
			}
	}
		
	function changeColumns2(month) {
			for(var i = 0; i < 12; i++) {
				var newMonth = parseInt(month) + i;
				newMonth = (newMonth == 0) ? 12 : newMonth;
				newMonth = (newMonth > 12) ? (newMonth - 12)  : newMonth;
				newMonth = (newMonth < 0)  ? (newMonth + 12)  : newMonth;
				newMonth = (newMonth < 10) ?   newMonth + '월' : newMonth +'월';
				masterGrid2.columns[i+6].setText(newMonth);	
			}
	}	
	
	function changeColumns3(month) {
		for(var i = 0; i < 12; i++) {
			var newMonth = parseInt(month) + i;
			newMonth = (newMonth == 0) ? 12 : newMonth;
			newMonth = (newMonth > 12) ? (newMonth - 12)  : newMonth;
			newMonth = (newMonth < 0)  ? (newMonth + 12)  : newMonth;
			newMonth = (newMonth < 10) ?   newMonth + '월' : newMonth +'월';
			masterGrid3.columns[i+6].setText(newMonth);	
		}
}	
};


</script>
