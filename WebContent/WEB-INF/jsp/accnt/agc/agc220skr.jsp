<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc220skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
//var fnSetFormTitle = ${fnSetFormTitle};
var BsaCodeInfo =  {
	gsFinancialY: '${gsFinancialY}'
}

function appMain() {     
	
//	var len = fnSetFormTitle.length; 
//	var tabTitle1 ='손익계산서';
//	var tabTitle2 ='제조원가명세서';
	
	//var hideTab1 = true;
	//var hideTab2 = true;
	
	
/*	for(var i=0 ; i < len ; i++) { 
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
	}*/
	
	var getStDt = ${getStDt};// 당기시작년월
	var getstMonth =  UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6);	//getStDt[0].STDT;
	
	//alert(getstMonth);
	
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
	Unilite.defineModel('agc220skrModel', {
	    fields: [  	  
	    	{name: 'GBN'				, text: 'GBN' 		,type: 'string'},
	    	{name: 'SEQ'				, text: 'SEQ' 		,type: 'string'},
		    {name: 'ACCNT_CD'			, text: '항목코드'		,type: 'string'},
		    {name: 'ACCNT'				, text: '항목코드'		,type: 'string'},
		    {name: 'ACCNT_NAME'			, text: '항목명' 		,type: 'string'},
		    {name: 'TOTAL_MONTH_AMT'	, text: '계'			,type: 'uniPrice'},
		    {name: 'THIS_MONTH_AMT'		, text: '월'			,type: 'uniPrice'},
		    {name: 'PRE_MONTH_AMT'		, text: '월'			,type: 'uniPrice'},
		    {name: 'INC_DEC_AMT'		, text: '증감액'		,type: 'uniPrice'},
		    {name: 'INC_DEC_RATE'		, text: '증감율(%)'	,type: 'uniPercent'}
		    
		]          
	});
	
	Unilite.defineModel('agc220skrModel2', {
	    fields: [  	  
	    	{name: 'GBN'				, text: 'GBN' 			,type: 'string'},
	    	{name: 'SEQ'				, text: 'SEQ' 			,type: 'string'},
		    {name: 'ACCNT_CD'			, text: '항목코드'			,type: 'string'},
		    {name: 'ACCNT'				, text: '항목코드'			,type: 'string'},
		    {name: 'ACCNT_NAME'			, text: '항목명' 			,type: 'string'},
		    {name: 'TOTAL_MONTH_AMT'	, text: '계'				,type: 'uniPrice'},
		    {name: 'THIS_MONTH_AMT'		, text: '당기누적(월누적)'	,type: 'uniPrice'},
		    {name: 'PRE_MONTH_AMT'		, text: '전기누적(월누적)'	,type: 'uniPrice'},
		    {name: 'INC_DEC_AMT'		, text: '증감액'			,type: 'uniPrice'},
		    {name: 'INC_DEC_RATE'		, text: '증감율(%)'		,type: 'uniPercent'}
		    
		]             
	});
	
	Unilite.defineModel('agc220skrModel3', {
	    fields: [  	  
	    	{name: 'GBN'				, text: 'GBN' 			,type: 'string'},
	    	{name: 'SEQ'				, text: 'SEQ' 			,type: 'string'},
		    {name: 'ACCNT_CD'			, text: '항목코드'			,type: 'string'},
		    {name: 'ACCNT'				, text: '항목코드'			,type: 'string'},
		    {name: 'ACCNT_NAME'			, text: '항목명' 			,type: 'string'},
		    {name: 'MONTH_TOTAL'		, text: '계'				,type: 'uniPrice'},
		    {name: 'MONTH01'			, text: '1/4분기'			,type: 'uniPrice'},
		    {name: 'MONTH02'			, text: '2/4분기'			,type: 'uniPrice'},
		    {name: 'MONTH03'			, text: '3/4분기'			,type: 'uniPrice'},
		    {name: 'MONTH04'			, text: '4/4분기'			,type: 'uniPrice'},
		    {name: 'PRE_MONTH_TOTAL'	, text: '계'				,type: 'uniPrice'},
		    {name: 'PRE_MONTH01'		, text: '1/4분기'			,type: 'uniPrice'},
		    {name: 'PRE_MONTH02'		, text: '2/4분기'			,type: 'uniPrice'},
		    {name: 'PRE_MONTH03'		, text: '3/4분기'			,type: 'uniPrice'},
		    {name: 'PRE_MONTH04'		, text: '4/4분기'			,type: 'uniPrice'},
		    {name: 'INC_DEC_AMT'		, text: '증감액'			,type: 'uniPrice'},
		    {name: 'INC_DEC_RATE'		, text: '증감율(%)'		,type: 'uniPercent'}
		    
		    
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
	var directMasterStore = Unilite.createStore('agc220skrMasterStore1',{
		model: 'agc220skrModel',
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
                read: 'agc220skrService.selectList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore2 = Unilite.createStore('agc220skrMasterStore2',{
		model: 'agc220skrModel2',
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
                read: 'agc220skrService.selectList2'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore3 = Unilite.createStore('agc220skrMasterStore3',{
		model: 'agc220skrModel3',
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
                read: 'agc220skrService.selectList3'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			param.ST_MONTH = getstMonth;
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
		 		xtype: 'container',
				items:[{
				 		fieldLabel: '기준년월',
				 		xtype: 'uniMonthfield',
				 		id: 'START_DATE1',
				 		name: 'START_DATE',
				 		value: UniDate.get('today'),
				 		allowBlank:false,
					 	listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('START_DATE', newValue);
							}
						}
					},{
					xtype: 'uniYearField',
		            fieldLabel: '기준년도',
		            id: 'BASE_YEARS1',
		            name: 'BASE_YEARS',
		            allowBlank:false,
		            width:250
		       }]
			},
		/*	{
                xtype: 'uniYearField',
                id: 'BASE_YEARS1',
                fieldLabel: '기준년도',
                name: 'BASE_YEARS',
                allowBlank:false,
                width:250
            },*/
			{ 
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
			xtype: 'container',
				items:[{
				 		fieldLabel: '기준년월',
				 		xtype: 'uniMonthfield',
				 		id: 'START_DATE2',
				 		name: 'START_DATE',
				 		value: UniDate.get('today'),
				 		allowBlank:false,
					 	listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('START_DATE', newValue);
							}
						}
					},{
					xtype: 'uniYearField',
		            fieldLabel: '기준년도',
		            id: 'BASE_YEARS2',
		            name: 'BASE_YEARS',
		            allowBlank:false,
		            width:250
		       }]
		},
/*		{
			xtype: 'container',
				items:[{
			
		            xtype: 'uniYearField',
		            fieldLabel: '기준년도',
		            id: 'BASE_YEARS2',
		            name: 'BASE_YEARS',
		            allowBlank:false,
		            width:250
		            
		       }]     
        },*/	
		{ 
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
    
    var masterGrid = Unilite.createGrid('agc220skrGrid1', {
    	title  : '전월대비',
    	//hidden : hideTab1,
    	//excelTitle: '월별재무제표' + '   (' + tabTitle1 + ')',
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
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
/*    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	          	if(record.get('ACCNT') != ''){
					cls = 'x-change-celltext_darkred';
				}
				return cls;
	        }
	    },*/
        columns: [        
        	{dataIndex: 'GBN'				, width: 180 ,hidden: true},
        	{dataIndex: 'SEQ'				, width: 180 ,hidden: true}, 
			{dataIndex: 'ACCNT_CD'			, width: 80	},
			{dataIndex: 'ACCNT'				, width: 180 ,hidden: true},
			{dataIndex: 'ACCNT_NAME'		, width: 230 , renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}},
			{dataIndex: 'TOTAL_MONTH_AMT'	, width: 106},
			{dataIndex: 'THIS_MONTH_AMT'	, width: 106},
			{dataIndex: 'PRE_MONTH_AMT'		, width: 110},
			{dataIndex: 'INC_DEC_AMT'		, width: 110},
			{dataIndex: 'INC_DEC_RATE'		, width: 110}
			
			
			/*{dataIndex: 'MONTH05'		, width: 110},
			{dataIndex: 'MONTH06'		, width: 110},
			{dataIndex: 'MONTH07'		, width: 110},
			{dataIndex: 'MONTH08'		, width: 110},
			{dataIndex: 'MONTH09'		, width: 110},
			{dataIndex: 'MONTH10'		, width: 110},
			{dataIndex: 'MONTH11'		, width: 110},
			{dataIndex: 'MONTH12'		, width: 110}*/
			/*{dataIndex: 'DIS_DIVI'		, width: 100 , hidden: true},
			{dataIndex: 'OPT_DIVI'		, width: 100 , hidden: true},
			{dataIndex: 'ACCNT'			, width: 100 , hidden: true}*/
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts, column )	{
	        	view.ownerGrid.setCellPointer(view, item);
        	}
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
        	if(record.get('ACCNT') == ''){
        		return false;
        	}else{	
      			return true;
        	}
      	}
    });
    
    var masterGrid2 = Unilite.createGrid('agc220skrGrid2', {
    	title  : '전기대비(월누적)',
    	//hidden : hideTab2,
    	//excelTitle: '월별재무제표' + '   (' + tabTitle2 + ')',
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
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
/*    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	          	if(record.get('ACCNT') != ''){
					cls = 'x-change-celltext_darkred';
				}
				return cls;
	        }
	    },*/
        columns: [        
        	{dataIndex: 'GBN'				, width: 180 ,hidden: true},
        	{dataIndex: 'SEQ'				, width: 180 ,hidden: true}, 
			{dataIndex: 'ACCNT_CD'			, width: 80	},
			{dataIndex: 'ACCNT'				, width: 180 ,hidden: true},
			{dataIndex: 'ACCNT_NAME'		, width: 230 , renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}},
			{dataIndex: 'TOTAL_MONTH_AMT'	, width: 120},
			{dataIndex: 'THIS_MONTH_AMT'	, width: 130},
			{dataIndex: 'PRE_MONTH_AMT'		, width: 130},
			{dataIndex: 'INC_DEC_AMT'		, width: 130},
			{dataIndex: 'INC_DEC_RATE'		, width: 130}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts, column )	{
	        	view.ownerGrid.setCellPointer(view, item);
        	}
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
        	if(record.get('ACCNT') == ''){
        		return false;
        	}else{	
      			return true;
        	}
      	}
    });
    
    var masterGrid3 = Unilite.createGrid('agc220skrGrid3', {
    	title  : '전기대비(분기누계)',
    	//hidden : hideTab2,
    	//excelTitle: '월별재무제표' + '   (' + tabTitle2 + ')',
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
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
/*    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	          	if(record.get('ACCNT') != ''){
					cls = 'x-change-celltext_darkred';
				}
				return cls;
	        }
	    },*/
        columns: [        
        	{dataIndex: 'GBN'				, width: 180 ,hidden: true},
			{dataIndex: 'ACCNT_CD'			, width: 80	},
			{dataIndex: 'ACCNT'				, width: 180 ,hidden: true},
			{dataIndex: 'ACCNT_NAME'		, width: 230 , renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}},
			
			{text : '당기',
        		columns:[{ dataIndex: 'MONTH_TOTAL' , width: 120, summaryType: 'sum'}, 				
						 { dataIndex: 'MONTH01'		, width: 120, summaryType: 'sum'}, 				
						 { dataIndex: 'MONTH02'   	, width: 120, summaryType: 'sum'},
						 { dataIndex: 'MONTH03'   	, width: 120, summaryType: 'sum'},
						 { dataIndex: 'MONTH04'   	, width: 120, summaryType: 'sum'}
			]},
			
	/*		{dataIndex: 'MONTH_TOTAL'		, width: 120},
			{dataIndex: 'MONTH01'			, width: 130},
			{dataIndex: 'MONTH02'			, width: 130},
			{dataIndex: 'MONTH03'			, width: 130},
			{dataIndex: 'MONTH04'			, width: 130},*/
			
			{text : '전기',
        		columns:[{ dataIndex: 'PRE_MONTH_TOTAL' , width: 120, summaryType: 'sum'}, 				
						 { dataIndex: 'PRE_MONTH01'		, width: 120, summaryType: 'sum'}, 				
						 { dataIndex: 'PRE_MONTH02'   	, width: 120, summaryType: 'sum'},
						 { dataIndex: 'PRE_MONTH03'   	, width: 120, summaryType: 'sum'},
						 { dataIndex: 'PRE_MONTH04'   	, width: 120, summaryType: 'sum'}
			]},
			/*{dataIndex: 'PRE_MONTH_TOTAL'	, width: 120},
			{dataIndex: 'PRE_MONTH01'		, width: 130},
			{dataIndex: 'PRE_MONTH02'		, width: 130},
			{dataIndex: 'PRE_MONTH03'		, width: 130},
			{dataIndex: 'PRE_MONTH04'		, width: 130},*/
			{dataIndex: 'INC_DEC_AMT'		, width: 130},
			{dataIndex: 'INC_DEC_RATE'		, width: 130}

			
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts, column )	{
	        	view.ownerGrid.setCellPointer(view, item);
        	}
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
        	if(record.get('ACCNT') == ''){
        		return false;
        	}else{	
      			return true;
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
					
				//Ext.getCmp('START_DATE1').setHidden(false); 
	            //Ext.getCmp('START_DATE2').setHidden(false);
				//Ext.getCmp('BASE_YEARS1').setHidden(true);
				//Ext.getCmp('BASE_YEARS2').setHidden(true);
				
				
    			if(newCard.getItemId() == 'agc220skrGrid1')	{
    			
    				Ext.getCmp('START_DATE1').setHidden(false); 
		            Ext.getCmp('START_DATE2').setHidden(false);
					Ext.getCmp('BASE_YEARS1').setHidden(true);
					Ext.getCmp('BASE_YEARS2').setHidden(true);
				
					//changeColumns(month);
    				//UniAppManager.app.onQueryButtonDown();
    			}else if(newCard.getItemId() == 'agc220skrGrid2') {	
    
    				Ext.getCmp('START_DATE1').setHidden(false); 
		            Ext.getCmp('START_DATE2').setHidden(false);
					Ext.getCmp('BASE_YEARS1').setHidden(true);
					Ext.getCmp('BASE_YEARS2').setHidden(true);
					
					//changeColumns2(month);
    				//UniAppManager.app.onQueryButtonDown();
    			}else if(newCard.getItemId() == 'agc220skrGrid3') {	
    				
					//changeColumns2(month);
    				Ext.getCmp('START_DATE1').setHidden(true); 
		            Ext.getCmp('START_DATE2').setHidden(true);
					Ext.getCmp('BASE_YEARS1').setHidden(false);
					Ext.getCmp('BASE_YEARS2').setHidden(false);
					
    				//UniAppManager.app.onQueryButtonDown();
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
		id : 'agc220skrApp',
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
			
			UniDate.get('startOfMonth')
			
			panelSearch.setValue('START_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('START_DATE',UniDate.get('startOfMonth'));
			
			var value = Ext.getCmp('searchForm').getForm().findField('START_DATE').getValue();		 		
			var month = new Date(value).getMonth() + 1;										       
			changeColumns(month);
			
			panelSearch.setValue('BASE_YEARS',new Date().getFullYear());
			panelResult.setValue('BASE_YEARS',new Date().getFullYear());
			
			Ext.getCmp('START_DATE1').setHidden(false); 
            Ext.getCmp('START_DATE2').setHidden(false);
			Ext.getCmp('BASE_YEARS1').setHidden(true);
			Ext.getCmp('BASE_YEARS2').setHidden(true);
			
			//alert(getStDt);
			
			
		},
		onQueryButtonDown : function()	{	
			if(!this.isValidSearchForm()){
				return false;
			}
			var activeTabId = tab.getActiveTab().getId();		
	
			if(activeTabId == 'agc220skrGrid1'){	
				var value = Ext.getCmp('searchForm').getForm().findField('START_DATE').getValue();		 		
				var month = new Date(value).getMonth() + 1;										       
				changeColumns(month);
				directMasterStore.loadStoreRecords();				
			}else if (activeTabId == 'agc220skrGrid2'){	
				directMasterStore2.loadStoreRecords();			
			}else if (activeTabId == 'agc220skrGrid3'){	
				directMasterStore3.loadStoreRecords();			
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
	
	function changeColumns(month) {
			for(var i = 0; i < 2; i++) {
				var newMonth = parseInt(month) - i;
				newMonth = (newMonth == 0) ? 12 : newMonth;
				newMonth = (newMonth > 12) ? (newMonth - 12)  : newMonth;
				newMonth = (newMonth < 0)  ? (newMonth + 12)  : newMonth;
				newMonth = (newMonth < 10) ?   newMonth + '월' : newMonth +'월';
				masterGrid.columns[i+7].setText(newMonth);	
			}
		}
};


</script>
