<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb210skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A081" /> 		<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B042"  /> 		<!-- 금액단위 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {   
	
var getStDt			= Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;			//당기시작월 관련 전역변수
	gsStDate		= getStDt[0].STDT.substring(0,4);
	gsFcDate		= getStDt[0].TODT;
	gsChargeCode	= Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};	//ChargeCode 관련 전역변수
	gsChargeDivi	= fnGetRefCode();										//부서 확인 - 현업부서의 경우 다른부서 조회 불가
	
	
	gsTodayYear     = UniDate.getDbDateStr(UniDate.get('today')).substring(0, 4);
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afb210Model', {
	   fields: [
			{name: 'DEPT_CODE'		, text: '부서코드'			, type: 'string'},
			{name: 'DEPT_NAME'		, text: '부서명'			, type: 'string'},
			{name: 'ACCNT_CD'		, text: '계정코드'			, type: 'string'},
			{name: 'ACCNT'			, text: '계정과목'			, type: 'string'},
			{name: 'ACCNT_NAME'		, text: '계정과목명'			, type: 'string'},
			{name: 'OPT_DIVI'		, text: 'OPT_DIVI'		, type: 'string'},
			{name: 'BUDG1'			, text: '예산'			, type: 'uniPrice'},
			{name: 'RESULT1'		, text: '실적'			, type: 'uniPrice'},
			{name: 'BALANCE1'		, text: '차액'			, type: 'uniPrice'},
			{name: 'ACHIEVE_RATE1'	, text: '달성률'			, type: 'uniPercent'},
			{name: 'BUDG2'			, text: '예산'			, type: 'uniPrice'},  
			{name: 'RESULT2'		, text: '실적'			, type: 'uniPrice'},  
			{name: 'BALANCE2'		, text: '차액'			, type: 'uniPrice'},  
			{name: 'ACHIEVE_RATE2'	, text: '달성률'			, type: 'uniPercent'},
			{name: 'BUDG_T1'		, text: '예산'			, type: 'uniPrice'},  
			{name: 'RESULT_T1'		, text: '실적'			, type: 'uniPrice'},  
			{name: 'BALANCE_T1'		, text: '차액'			, type: 'uniPrice'},  
			{name: 'ACHIEVE_T1'		, text: '달성률'			, type: 'uniPercent'},
			{name: 'BUDG3'			, text: '예산'			, type: 'uniPrice'},  
			{name: 'RESULT3'		, text: '실적'			, type: 'uniPrice'},  
			{name: 'BALANCE3'		, text: '차액'			, type: 'uniPrice'},  
			{name: 'ACHIEVE_RATE3'	, text: '달성률'			, type: 'uniPercent'},
			{name: 'BUDG4'			, text: '예산'			, type: 'uniPrice'},  
			{name: 'RESULT4'		, text: '실적'			, type: 'uniPrice'},  
			{name: 'BALANCE4'		, text: '차액'			, type: 'uniPrice'},  
			{name: 'ACHIEVE_RATE4'	, text: '달성률'			, type: 'uniPercent'},
			{name: 'BUDG_T3'		, text: '예산'			, type: 'uniPrice'},  
			{name: 'RESULT_T3'		, text: '실적'			, type: 'uniPrice'},  
			{name: 'BALANCE_T3'		, text: '차액'			, type: 'uniPrice'},  
			{name: 'ACHIEVE_T3'		, text: '달성률'			, type: 'uniPercent'},
			{name: 'ACCNT_DIVI'		, text: 'ACCNT_DIVI'	, type: 'string'}
	    ]
	});		// End of Ext.define('Afb210skrModel', {
	
	Unilite.defineModel('Afb210Model2', {
	   fields: [
			{name: 'DEPT_CODE'			, text: '부서코드'			, type: 'string'},
			{name: 'DEPT_NAME'			, text: '부서명'			, type: 'string'},
			{name: 'ACCNT_CD'			, text: '계정코드'			, type: 'string'},
			{name: 'ACCNT'				, text: '계정과목'			, type: 'string'},
			{name: 'ACCNT_NAME'			, text: '계정과목명'			, type: 'string'},
			{name: 'OPT_DIVI'			, text: 'OPT_DIVI'		, type: 'string'},
			{name: 'BUDG1'				, text: '예산'			, type: 'uniPrice'},  
			{name: 'RESULT1'			, text: '실적'			, type: 'uniPrice'},  
			{name: 'BALANCE1'			, text: '차액'			, type: 'uniPrice'},  
			{name: 'ACHIEVE_RATE1'		, text: '달성률'			, type: 'uniPercent'},
			{name: 'BUDG2'				, text: '예산'			, type: 'uniPrice'},  
			{name: 'RESULT2'			, text: '실적'			, type: 'uniPrice'},  
			{name: 'BALANCE2'			, text: '차액'			, type: 'uniPrice'},  
			{name: 'ACHIEVE_RATE2'		, text: '달성률'			, type: 'uniPercent'},
			{name: 'BUDG_T'				, text: '예산'			, type: 'uniPrice'},  
			{name: 'RESULT_T'			, text: '실적'			, type: 'uniPrice'},  
			{name: 'BALANCE_T'			, text: '차액'			, type: 'uniPrice'},  
			{name: 'ACHIEVE_T'			, text: '달성률'			, type: 'uniPercent'},
			{name: 'ACCNT_DIVI'			, text: 'ACCNT_DIVI'	, type: 'string'}
	    ]
	});	
	  
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('afb210MasterStore1',{
		model: 'Afb210Model',
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'afb210skrService.selectList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );

			var date		= panelSearch.getValue('BUDGET_YYMM')
			var sFrDate		= date + '01';
			var sToDate		= date + '12';
				
			param.sFrDate	= sFrDate;
			param.sToDate	= sToDate;
			
			this.load({
				params : param
			});
		}
	});
	
	var masterStore2 = Unilite.createStore('afb210MasterStore2',{
		model: 'Afb210Model2',
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'afb210skrService.selectList2'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );

			var date		= panelSearch.getValue('BUDGET_YYMM')
			var sFrDate		= date + '01';
			var sToDate		= date + '12';
				
			param.sFrDate	= sFrDate;
			param.sToDate	= sToDate;
			
			this.load({
				params : param
			});
		}
	});
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
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
	    		fieldLabel	: '예산년도', 
				xtype		: 'uniYearField',
	            name		: 'BUDGET_YYMM',
				value		: gsTodayYear,
	    		allowBlank	: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BUDGET_YYMM', newValue);
					}
				}
	    	},
			Unilite.popup('DEPT', { 
				fieldLabel		: '부서', 
				valueFieldName	: 'DEPT_CODE',
				textFieldName	: 'DEPT_NAME',
				holdable		: 'hold',
				listeners		: {
			    	onValueFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_CODE', newValue);	
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_NAME', newValue);	
					}
				}
			})
		]},{
			title	: '추가정보', 	
	   		itemId	: 'search_panel2',
	        layout	: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items	: [{
        		fieldLabel	: '금액단위',
        		name		: 'AMT_UNIT',
        		xtype		: 'uniCombobox',
        		comboType	: 'AU',
        		allowBlank	: false,
        		comboCode	: 'B042',
        		value		: '1'
			},{
				xtype		: 'radiogroup',		            		
				fieldLabel	: '과목구분',						            		
				id			: 'rdoSelect',
				items		: [{
					boxLabel	: '과목', 
					width		: 70, 
					name		: 'rdoSelect',
        			inputValue	: '1',
					checked		: true  
				},{
					boxLabel	: '세목', 
					width		: 70,
        			inputValue	: '2',
					name		: 'rdoSelect'
				}]
			}]
		}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4
//		tableAttrs	: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs		: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
    		fieldLabel	: '예산년도', 
			xtype		: 'uniYearField',
            name		: 'BUDGET_YYMM',
			value		: gsTodayYear,
    		allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BUDGET_YYMM', newValue);
				}
			}
    	},
		Unilite.popup('DEPT', { 
			fieldLabel		: '부서', 
			valueFieldName	: 'DEPT_CODE',
			textFieldName	: 'DEPT_NAME',
			holdable		: 'hold',
			listeners		: {
		    	onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_CODE', newValue);	
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_NAME', newValue);	
				}
			}
		})
		]
	});
	
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('afb210Grid1', {
    	layout	: 'fit',
        region	: 'center',
        title	: '분기별',
		store	: masterStore,
    	features: [{
    		id		: 'masterGridSubTotal',
    		ftype	: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id		: 'masterGridTotal', 	
    		ftype	: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	uniOpt : {						
			useMultipleSorting	: true,			
		    useLiveSearch		: true,			
		    onLoadSelectFirst	: false,				
		    dblClickToEdit		: false,			
		    useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: false,			
			useRowContext		: true,		
		    filter: {					
				useFilter		: true,	
				autoCreate		: true	
			}				
		},
    	sortableColumns	: false,
		selModel		: 'rowmodel',
        columns: [
        	{ 
          		text:'부서',
           		columns:[ 
        			{dataIndex: 'DEPT_CODE'			, width: 66}, 	
        			{dataIndex: 'DEPT_NAME'			, width: 100}
        		]
        	},{ 
          		text:'계정과목',
           		columns:[ 
		        	{dataIndex: 'ACCNT_CD'			, width: 100, hidden: true}, 	
		        	{dataIndex: 'ACCNT'				, width: 66, 
						//합계행은 계정과목 생략
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get('ACCNT') == '0' || record.get('ACCNT') == '99999'){
								return '';
							}else{
								return val;
							}
						}				
					}, 	
		        	{dataIndex: 'ACCNT_NAME'		, width: 133}
		        ]
        	},
        	{		dataIndex: 'OPT_DIVI'			, width: 66, hidden: true},
        	{ 
          		text:'1분기',
           		columns:[ 
		        	{dataIndex: 'BUDG1'				, width: 100}, 	
		        	{dataIndex: 'RESULT1'			, width: 100}, 	
		        	{dataIndex: 'BALANCE1'			, width: 100}, 	
		        	{dataIndex: 'ACHIEVE_RATE1'		, width: 66}
		        ]
        	},{ 
          		text:'2분기',
           		columns:[ 
		        	{dataIndex: 'BUDG2'				, width: 100}, 	
		        	{dataIndex: 'RESULT2'			, width: 100}, 	
		        	{dataIndex: 'BALANCE2'			, width: 100}, 	
		        	{dataIndex: 'ACHIEVE_RATE2'		, width: 66}
		        ]
        	},{ 
          		text:'상반기계',
           		columns:[ 
		        	{dataIndex: 'BUDG_T1'			, width: 100}, 	
		        	{dataIndex: 'RESULT_T1'			, width: 100}, 	
		        	{dataIndex: 'BALANCE_T1'		, width: 100}, 	
		        	{dataIndex: 'ACHIEVE_T1'		, width: 66}
		        ]
        	},{ 
          		text:'3분기',
           		columns:[ 
		        	{dataIndex: 'BUDG3'				, width: 100}, 	
		        	{dataIndex: 'RESULT3'			, width: 100}, 	
		        	{dataIndex: 'BALANCE3'			, width: 100}, 	
		        	{dataIndex: 'ACHIEVE_RATE3'		, width: 66}
		        ]
        	},{ 
          		text:'4분기',
           		columns:[ 
		        	{dataIndex: 'BUDG4'				, width: 100}, 	
		        	{dataIndex: 'RESULT4'			, width: 100}, 	
		        	{dataIndex: 'BALANCE4'			, width: 100}, 	
		        	{dataIndex: 'ACHIEVE_RATE4'		, width: 66}
        		]
        	},{ 
          		text:'하반기계',
          		columns:[ 
		        	{dataIndex: 'BUDG_T3'			, width: 100}, 	
		        	{dataIndex: 'RESULT_T3'			, width: 100}, 	
		        	{dataIndex: 'BALANCE_T3'		, width: 100}, 	
		        	{dataIndex: 'ACHIEVE_T3'		, width: 66}
		        ]
        	},
        	{		dataIndex: 'ACCNT_DIVI'			, width: 66,	hidden: true}
		],
	
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
				columnName			= grid.eventPosition.column.dataIndex;
			if (Ext.isEmpty(record.get('ACCNT')) || record.get('ACCNT') == '99999' || record.get('ACCNT') == '0' || columnName == 'DEPT_CODE' || columnName == 'DEPT_NAME'
																				|| columnName == 'ACCNT' || columnName == 'ACCNT_NAME'){
	  			return false;
			} else {
	  			return true;
			}
  		},
        uniRowContextMenu:{
			items: [{
	        		text: '월차예산실적비교표 보기',   
	            	itemId	: 'linkAfb220ukr',
	            	handler: function(menuItem, event) {
	            		var findLastLetter	= columnName.substring(columnName.length-1, columnName.length)
	            		var findLast3Letter	= columnName.substring(columnName.length-3, columnName.length)

	            		//링크시 넘길 예산년월 값 계산
	            		if (findLastLetter == '1') {
	            			if (findLast3Letter == '_T1') {											//상반기
								var budgetYyyymmFr		= panelSearch.getValue('BUDGET_YYMM') + '01';
	       						var budgetYyyymmTo		= panelSearch.getValue('BUDGET_YYMM') + '06';
	            				
	            			} else {																//1분기
	            				var budgetYyyymmFr		= panelSearch.getValue('BUDGET_YYMM') + '01';
	       						var budgetYyyymmTo		= panelSearch.getValue('BUDGET_YYMM') + '03';
	            			}
	            		} else if (findLastLetter == '2') {											//2분기
							var budgetYyyymmFr		= panelSearch.getValue('BUDGET_YYMM') + '04';
       						var budgetYyyymmTo		= panelSearch.getValue('BUDGET_YYMM') + '06';

	            		} else if (findLastLetter == '3') {
	            			if (findLast3Letter == '_T3') {											//하반기
								var budgetYyyymmFr		= panelSearch.getValue('BUDGET_YYMM') + '07';
	       						var budgetYyyymmTo		= panelSearch.getValue('BUDGET_YYMM') + '12';
	            				
	            			} else {																//3분기
	            				var budgetYyyymmFr		= panelSearch.getValue('BUDGET_YYMM') + '07';
	       						var budgetYyyymmTo		= panelSearch.getValue('BUDGET_YYMM') + '09';
	            			}
	            		} else {																	//4분기
            				var budgetYyyymmFr		= panelSearch.getValue('BUDGET_YYMM') + '10';
       						var budgetYyyymmTo		= panelSearch.getValue('BUDGET_YYMM') + '12';
	            		}

            			var param = {
	            			'PGM_ID'		: 'afb210skr',
							'BUDGET_YYMM_FR': budgetYyyymmFr,
							'BUDGET_YYMM_TO': budgetYyyymmTo,
							'DEPT_CODE'		: panelSearch.getValue('DEPT_CODE'),
							'DEPT_NAME'		: panelSearch.getValue('DEPT_NAME'),
							'AMT_UNIT'		: panelSearch.getValue('AMT_UNIT'),
							'rdoSelect'		: panelSearch.getValue('rdoSelect')
							
	            		};
	            		masterGrid.gotoAfb220skr(param);
	            	}
	        	}
	        ]
	    },
		gotoAfb220skr:function(record)	{
			if(record)	{
		    	var params = record
			}
	  		var rec1 = {data : {prgID : 'afb220skr', 'text':''}};							
			parent.openTab(rec1, '/accnt/afb220skr.do', params);
    	},
    	
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(Ext.isEmpty(record.get('ACCNT')) || record.get('ACCNT') == '0'){
					cls = 'x-change-cell_normal';
				} else if (record.get('ACCNT') == '99999') {
					cls = 'x-change-cell_dark';
				}
				if(record.get('ACCNT_DIVI') == '2'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
	        }
	    }
    });  
    
    var masterGrid2 = Unilite.createGrid('afb210Grid2', {
    	layout	: 'fit',
        region	: 'center',
        title	: '반기별',
		store	: masterStore2,
    	features: [{
    		id		: 'masterGridSubTotal',
    		ftype	: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id		: 'masterGridTotal', 	
    		ftype	: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	uniOpt : {						
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
    	sortableColumns	: false,
		selModel		: 'rowmodel',
        columns: [
	        { 
          		text:'부서',
           		columns:[ 
		        	{dataIndex: 'DEPT_CODE'					, width: 66}, 	
		        	{dataIndex: 'DEPT_NAME'					, width: 100}
		        ]
	        },
        	{		dataIndex: 'ACCNT_CD'					, width: 100,	hidden: true}, 
        	{ 
          		text:'계정과목',
           		columns:[ 
		        	{dataIndex: 'ACCNT'						, width: 66}, 	
		        	{dataIndex: 'ACCNT_NAME'				, width: 133}, 	
		        	{dataIndex: 'OPT_DIVI'					, width: 66,	hidden: true}
		        ]
	        },{ 
          		text:'상반기',
           		columns:[ 
		        	{dataIndex: 'BUDG1'						, width: 100}, 	
		        	{dataIndex: 'RESULT1'					, width: 100}, 	
		        	{dataIndex: 'BALANCE1'					, width: 100}, 	
		        	{dataIndex: 'ACHIEVE_RATE1'				, width: 66}, 	
		        	{dataIndex: 'OPT_DIVI'					, width: 66,	hidden: true}
		        ]
	        },{ 
          		text:'하반기',
           		columns:[ 
		        	{dataIndex: 'BUDG2'						, width: 100}, 	
		        	{dataIndex: 'RESULT2'					, width: 100}, 	
		        	{dataIndex: 'BALANCE2'					, width: 100}, 	
		        	{dataIndex: 'ACHIEVE_RATE2'				, width: 66}
		        ]
	        },{ 
           		text:'년',
           		columns:[ 
		        	{dataIndex: 'BUDG_T'					, width: 100}, 	
		        	{dataIndex: 'RESULT_T'					, width: 100}, 	
		        	{dataIndex: 'BALANCE_T'					, width: 100}, 	
		        	{dataIndex: 'ACHIEVE_T'					, width: 66}
		        ]
	        }, 	
        	{		dataIndex: 'ACCNT_DIVI'					, width: 66,	hidden: true}
		],
	
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
				columnName			= grid.eventPosition.column.dataIndex;
			if (Ext.isEmpty(record.get('ACCNT')) || record.get('ACCNT') == '99999' || record.get('ACCNT') == '0' || columnName == 'DEPT_CODE' || columnName == 'DEPT_NAME'
																				|| columnName == 'ACCNT' || columnName == 'ACCNT_NAME'){
	  			return false;
			} else {
	  			return true;
			}
  		},
        uniRowContextMenu:{
			items: [{
	        		text: '월차예산실적비교표 보기',   
	            	itemId	: 'linkAfb220ukr',
	            	handler: function(menuItem, event) {
	            		var findLastLetter	= columnName.substring(columnName.length-1, columnName.length)

	            		//링크시 넘길 예산년월 값 계산
	            		if (findLastLetter == '1') {												//상반기
							var budgetYyyymmFr		= panelSearch.getValue('BUDGET_YYMM') + '01';
       						var budgetYyyymmTo		= panelSearch.getValue('BUDGET_YYMM') + '06';

   						} else if (findLastLetter == '2') {											//하반기
							var budgetYyyymmFr		= panelSearch.getValue('BUDGET_YYMM') + '07';
       						var budgetYyyymmTo		= panelSearch.getValue('BUDGET_YYMM') + '12';

	            		} else {																	//년
            				var budgetYyyymmFr		= panelSearch.getValue('BUDGET_YYMM') + '01';
       						var budgetYyyymmTo		= panelSearch.getValue('BUDGET_YYMM') + '12';
	            		}

            			var param = {
	            			'PGM_ID'		: 'afb210skr',
							'BUDGET_YYMM_FR': budgetYyyymmFr,
							'BUDGET_YYMM_TO': budgetYyyymmTo,
							'DEPT_CODE'		: panelSearch.getValue('DEPT_CODE'),
							'DEPT_NAME'		: panelSearch.getValue('DEPT_NAME'),
							'AMT_UNIT'		: panelSearch.getValue('AMT_UNIT'),
							'rdoSelect'		: panelSearch.getValue('rdoSelect')
							
	            		};
	            		masterGrid.gotoAfb220skr(param);
	            	}
	        	}
	        ]
	    },
		gotoAfb220skr:function(record)	{
			if(record)	{
		    	var params = record
			}
	  		var rec1 = {data : {prgID : 'afb220skr', 'text':''}};							
			parent.openTab(rec1, '/accnt/afb220skr.do', params);
    	},
    	
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(Ext.isEmpty(record.get('ACCNT')) || record.get('ACCNT') == '0'){
					cls = 'x-change-cell_normal';
				} else if (record.get('ACCNT') == '99999') {
					cls = 'x-change-cell_dark';
				}
				if(record.get('ACCNT_DIVI') == '2'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
	        }
	    } 
    });  
    
    var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab:  0,
	    region: 'center',
	    items:  [
	         masterGrid,
	         masterGrid2
	    ]
    });
    
	 Unilite.Main( {
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
		id : 'afb210App',
		fnInitBinding : function() {
//			초기화 시 예산년도로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('BUDGET_YYMM');

			//버튼 초기화
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false;
			}
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'afb210Grid1'){				
				masterStore.loadStoreRecords();				
			}
			if(activeTabId == 'afb210Grid2'){				
				masterStore2.loadStoreRecords();				
			}
		}
	});
	
	function fnGetRefCode(){
		var param = {
			ADD_QUERY1	: "ISNULL(REF_CODE2,'') AS REF_CODE2",
			ADD_QUERY2	: '',
			MAIN_CODE	: 'A009',
			SUB_CODE	: gsChargeCode[0].SUB_CODE
		}
		accntCommonService.fnGetRefCodes(param, function(provider, response)	{
			if (provider.REF_CODE2 == '2') {
				panelSearch.setValue('DEPT_CODE', UserInfo.deptCode)
				panelSearch.setValue('DEPT_NAME', UserInfo.deptName)
				panelSearch.getField('DEPT_CODE').setReadOnly(true);
				panelSearch.getField('DEPT_NAME').setReadOnly(true);
				
				panelResult.setValue('DEPT_CODE', UserInfo.deptCode)
				panelResult.setValue('DEPT_NAME', UserInfo.deptName)
				panelResult.getField('DEPT_CODE').setReadOnly(true);
				panelResult.getField('DEPT_NAME').setReadOnly(true);
				
				return provider.REF_CODE2;
			}
//			gsChargeDiviCo = gsAuParam(0);
		});
	}

};
</script>
