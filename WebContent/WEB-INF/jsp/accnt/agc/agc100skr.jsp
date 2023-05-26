<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc100skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var BsaCodeInfo =  {
	gsFinancialY: '${gsFinancialY}'
};

var getStDt = ${getStDt};

function appMain() {  
	var providerSTDT ='';
	var gbHideLabel = true;
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agc100skrModel', {
	    fields: [
	    	{name: 'ACCNT'				, text: '계정코드'				,type: 'string'},
	    	{name: 'BDR_AMT_I'   		, text: '잔액' 				,type: 'uniPrice'},
		    {name: 'SDR_AMT_TOT_I'		, text: '누계'				,type: 'uniPrice'},
		    {name: 'MDR_AMT_TOT_I' 		, text: '합계' 				,type: 'uniPrice'},
		    {name: 'ACCNT_NAME'  		, text: '계정과목'	 			,type: 'string'},
		    {name: 'MCR_AMT_TOT_I' 		, text: '합계'				,type: 'uniPrice'},
		    {name: 'SCR_AMT_TOT_I'		, text: '누계' 				,type: 'uniPrice'},
		    {name: 'BCR_AMT_I'   		, text: '잔액' 				,type: 'uniPrice'},
		    {name: 'SUBJECT_DIVI'		, text: 'SUBJECT_DIVI'		,type: 'string'},
		    
		    {name: 'SEQ'				, text: '순번' 				,type: 'string'},
		    {name: 'ACCNT_DIVI'   		, text: 'ACCNT_DIVI' 		,type: 'string'}
		    
		]          
	});
	
	
	Unilite.defineModel('Agc100skrModel2', {
	    fields: [
	    	{name: 'ACCNT'				, text: '계정코드'				,type: 'string'},
	    	{name: 'BDR_AMT_I'   		, text: '잔액' 				,type: 'uniPrice'},
		    {name: 'SDR_AMT_TOT_I'		, text: '누계'				,type: 'uniPrice'},
		    {name: 'MDR_AMT_TOT_I' 		, text: '합계' 				,type: 'uniPrice'},
		    {name: 'ACCNT_NAME'  		, text: '계정과목' 				,type: 'string'},
		    {name: 'MCR_AMT_TOT_I' 		, text: '합계'				,type: 'uniPrice'},
		    {name: 'SCR_AMT_TOT_I'		, text: '누계' 				,type: 'uniPrice'},
		    {name: 'BCR_AMT_I'   		, text: '잔액' 				,type: 'uniPrice'},
		    {name: 'SUBJECT_DIVI'		, text: 'SUBJECT_DIVI'		,type: 'string'},
		    
		    {name: 'SEQ'				, text: '순번' 				,type: 'string'},
		    {name: 'ACCNT_DIVI'   		, text: 'ACCNT_DIVI' 		,type: 'string'}
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
	var directMasterStore = Unilite.createStore('agc100skrMasterStore1',{
		model: 'Agc100skrModel',
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
                read: 'agc100skrService.selectList1'
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
			
			// 누락된 계정 조회
			UniAppManager.app.fnGetOmitCnt('1');
		}
	});
	
	var directMasterStore2 = Unilite.createStore('agc100skrMasterStore2',{
		model: 'Agc100skrModel2',
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
                read: 'agc100skrService.selectList2'
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
			
			// 누락된 계정 조회
			UniAppManager.app.fnGetOmitCnt('2');
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
	        	fieldLabel: '기준일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_DATE',newValue);
						UniAppManager.app.fnSetStDate(newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}   	
			    }
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '과목구분',
				id:'rdoSubjectDiviS',
				items: [{
					boxLabel: '과목', 
					width: 70, 
					name: 'SUB_JECT_DIVI',
					inputValue: '1',
					checked: true  
				},{
					boxLabel : '세목', 
					width: 70,
					name: 'SUB_JECT_DIVI',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('SUB_JECT_DIVI').setValue(newValue.SUB_JECT_DIVI);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '잔액계산기준',
				id:'rdoCalcJanAmtS',
				items: [{
					boxLabel: '잔액별 잔액', 
					width: 85, 
					name: 'CALC_JAN_AMT',
					inputValue: '1',
					checked: true  
				},{
					boxLabel : '잔액별 합계', 
					width: 85,
					name: 'CALC_JAN_AMT',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('CALC_JAN_AMT').setValue(newValue.CALC_JAN_AMT);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
		 		fieldLabel: 'MSG_NO',
		 		xtype: 'uniTextfield',
		 		name: 'MSG_NO',
		 		hidden: true
			},{
		 		fieldLabel: 'MSG_DESC',
		 		xtype: 'uniTextfield',
		 		name: 'MSG_DESC',
		 		hidden: true
			}]
		},{
			title:'추가정보',
			id: 'search_panel2',
			itemId:'search_panel2',
    		defaultType: 'uniTextfield',
    		layout : {type : 'uniTable', columns : 1},
    		defaultType: 'uniTextfield',
    		
    		items:[{
		 		fieldLabel: '당기시작년월',
		 		xtype: 'uniMonthfield',
		 		name: 'ST_DATE',
		 		allowBlank:false
			},{
		 		fieldLabel: '재무제표양식차수',
		 		name:'FORM_DIVISION', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'A093',
		 		value : BsaCodeInfo.gsFinancialY,
		 		allowBlank:false
			},{
				xtype: 'radiogroup',
				fieldLabel: '과목명',
				id:'rdoRefItemS',
				items: [{
					boxLabel: '과목명1',
					width: 70, 
					name: 'REF_ITEM',
					inputValue: '0',
					checked: true
				},{
					boxLabel : '과목명2',
					width: 70,
					name: 'REF_ITEM',
					inputValue: '1'
				},{
					boxLabel: '과목명3', 
					width: 70, 
					name: 'REF_ITEM',
					inputValue: '2' 
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
				fieldLabel: '조건',
				xtype: 'checkboxgroup',
				width: 400, 
				items: [{
					boxLabel: '값이 0인 계정도 포함',
					name: 'ZERO_ACCOUNT',
					inputValue: 'Y',
					uncheckedValue: 'N'
				}]
			}]
		},{
			xtype:'container',
			padding: '0 0 0 10',
			html: '<b>※ 조회하기 전, [회계-기초등록-집계항목설정] 프로그램에서</br> [집계항목적용] 버튼을 눌러 주세요.</b>',
			style: {
				color: 'blue'
			}
		}],
		api: {
	 		load: 'agc100skrService.selectMsg'	
		}	
	});	//end panelSearch  
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
				fieldLabel: '기준일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('FR_DATE',newValue);
						UniAppManager.app.fnSetStDate(newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('TO_DATE',newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
			},{
				xtype: 'radiogroup',
				fieldLabel: '과목구분',	
				items: [{
					boxLabel: '과목', 
					width: 70, 
					name: 'SUB_JECT_DIVI',
					inputValue: '1',
					checked: true  
				},{
					boxLabel : '세목', 
					width: 70,
					name: 'SUB_JECT_DIVI',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('SUB_JECT_DIVI').setValue(newValue.SUB_JECT_DIVI);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: '잔액계산기준',
				items: [{
					boxLabel: '잔액별 잔액', 
					width: 85, 
					name: 'CALC_JAN_AMT',
					inputValue: '1',
					checked: true  
				},{
					boxLabel : '잔액별 합계', 
					width: 85,
					name: 'CALC_JAN_AMT',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('CALC_JAN_AMT').setValue(newValue.CALC_JAN_AMT);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
				xtype:'container',
				padding: '0 0 5 10',
				html: '<b>※ 조회하기 전, [회계-기초등록-집계항목설정] 프로그램에서 [집계항목적용] 버튼을 눌러 주세요.</b>',
				style: {
					color: 'blue'
				},
				colspan: 3
			}]	
	});
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */

	var masterGrid = Unilite.createGrid('agc100skrGrid1', {
		title: '당월포함',
		layout : 'fit',
		store : directMasterStore, 
		uniOpt:{
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
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
		store: directMasterStore,
		tbar: [{
			text:'출력',
			handler: function() {
				UniAppManager.app.fnGotoPrintPage('1');
			}
		}],
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
			{dataIndex : 'ACCNT'					, width: 80},
			{dataIndex : 'SEQ'					, width: 80 ,hidden:true},
			{text : '차변',
				columns:[{ dataIndex: 'BDR_AMT_I'   		, width: 120, summaryType: 'sum'},
						 { dataIndex: 'SDR_AMT_TOT_I'		, width: 120, summaryType: 'sum'},
						 { dataIndex: 'MDR_AMT_TOT_I' 		, width: 120, summaryType: 'sum'}
			]},
			{dataIndex: 'ACCNT_NAME'  		, width: 206	, align: 'center'},
			{text : '대변',
				columns:[{ dataIndex: 'MCR_AMT_TOT_I' 	, width: 120, summaryType: 'sum'},
						 { dataIndex: 'SCR_AMT_TOT_I'	, width: 120, summaryType: 'sum'},
						 { dataIndex: 'BCR_AMT_I'   	, width: 120, summaryType: 'sum'}
			]},
			{dataIndex: 'ACCNT_DIVI'		, width: 100 ,hidden:true},	
			{dataIndex: 'SUBJECT_DIVI'		, width: 100 ,hidden:true}	
		],
		/*listeners: {
          	onGridDblClick:function(grid, record, cellIndex, colName) {
				var params = {
					action:'select',
					'PGM_ID'			: 'agc100skr',
					'FR_DATE' 			: panelSearch.getValue('FR_DATE'),
					'TO_DATE' 			: panelSearch.getValue('TO_DATE'),
					'ACCNT_DIV_CODE'	: panelSearch.getValue('ACCNT_DIV_CODE'),
					'ST_DATE'			: panelSearch.getValue('ST_DATE'),
					'ACCNT' 			: record.data['ACCNT'],	
					'ACCNT_NAME' 		: record.data['ACCNT_NAME']
				}
          		if (record.data['ACCNT_DIVI'] == '0'){
	          		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
					parent.openTab(rec1, '/accnt/agb110skr.do', params);	
          		}
          	}
		},*/
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts )	{
	        	if (record.data['ACCNT_DIVI'] == '0'){
	        		view.ownerGrid.setCellPointer(view, item);
	        	}
        	},
        	onGridDblClick :function( grid, record, cellIndex, colName ) {
                masterGrid.gotoAgb110(record);
        	}
        	
        	
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
			if (record.data['ACCNT_DIVI'] == '0'){
      			//menu.showAt(event.getXY());
      			return true;
			}
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '보조부',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAgb110(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAgb110:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 'agc100skr',
					'FR_DATE' 			: panelSearch.getValue('FR_DATE'),
					'TO_DATE' 			: panelSearch.getValue('TO_DATE'),
					'ACCNT_DIV_CODE'	: panelSearch.getValue('ACCNT_DIV_CODE'),
					'ST_DATE'			: panelSearch.getValue('ST_DATE'),
					'ACCNT' 			: record.data['ACCNT'],	
					'ACCNT_NAME' 		: record.data['ACCNT_NAME']
				}
          		if (record.data['ACCNT_DIVI'] == '0'){
	          		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
					parent.openTab(rec1, '/accnt/agb110skr.do', params);	
          		}
			}
    	},
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('ACCNT_DIVI') == '4') {
					cls = 'x-change-cell_light';
				}else if(record.get('ACCNT_DIVI') == '5'){
					cls = 'x-change-cell_medium_light';
				} else if(record.get('ACCNT_DIVI') == '6'){ 
					cls = 'x-change-cell_normal';
				} else if(record.get('ACCNT_NAME') == '합계') {
					cls = 'x-change-cell_dark';
				}
				if(record.get('SUBJECT_DIVI') == '2'){
					cls = 'x-change-celltext_darkred';	
				}
				return cls;
	        }
	    }              	        
    });
    
    var masterGrid2 = Unilite.createGrid('agc100skrGrid2', {
    	title: '당월미포함',
    	layout : 'fit',
    	uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
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
        store : directMasterStore2, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'출력',
        	handler: function() {
				UniAppManager.app.fnGotoPrintPage('2');
        	}
        }],
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
        	{dataIndex : 'ACCNT'				, width: 80},
        	{dataIndex : 'SEQ'					, width: 80 ,hidden:true},
        	{text : '차변',
        		columns:[{ dataIndex: 'BDR_AMT_I'   		, width: 180, summaryType: 'sum'},
						 { dataIndex: 'SDR_AMT_TOT_I'		, width: 180, summaryType: 'sum'}
			]},
			{dataIndex: 'ACCNT_NAME'  		, width: 206	, align: 'center'},
			{text : '대변',
        		columns:[{ dataIndex: 'SCR_AMT_TOT_I' 	, width: 180, summaryType: 'sum'},
						 { dataIndex: 'BCR_AMT_I'	, width: 180, summaryType: 'sum'}
			]},
			{dataIndex: 'ACCNT_DIVI'		, width: 100 , hidden:true},
			{dataIndex: 'SUBJECT_DIVI'		, width: 100  , hidden:true}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts )	{
	        	if (record.data['ACCNT_DIVI'] == '0'){
	        		view.ownerGrid.setCellPointer(view, item);
	        	}
        	},
        	onGridDblClick :function( grid, record, cellIndex, colName ) {
                masterGrid2.gotoAgb110(record);
            }
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
			if (record.data['ACCNT_DIVI'] == '0'){
      			//menu.showAt(event.getXY());
      			return true;
			}
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '보조부',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAgb110(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAgb110:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 'agc100skr',
					'FR_DATE' 			: panelSearch.getValue('FR_DATE'),
					'TO_DATE' 			: panelSearch.getValue('TO_DATE'),
					'ACCNT_DIV_CODE'	: panelSearch.getValue('ACCNT_DIV_CODE'),
					'ST_DATE'			: panelSearch.getValue('ST_DATE'),
					'ACCNT' 			: record.data['ACCNT'],	
					'ACCNT_NAME' 		: record.data['ACCNT_NAME']
				}
          		if (record.data['ACCNT_DIVI'] == '0'){
	          		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
					parent.openTab(rec1, '/accnt/agb110skr.do', params);	
          		}
			}
    	},
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('ACCNT_DIVI') == '4') {
					cls = 'x-change-cell_light';
				} else if(record.get('ACCNT_DIVI') == '6' || record.get('ACCNT_DIVI') == '5'){ 
					cls = 'x-change-cell_normal';
				} else if(record.get('ACCNT_NAME') == '합계') {
					cls = 'x-change-cell_dark';
				}
				if(record.get('SUBJECT_DIVI') == '2'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
	        }
	    }           	        
    });
    
    var tab = Unilite.createTabPanel('tabPanel',{
    	region:'center',
	    items: [
	         masterGrid,
	         masterGrid2
	    ],
	    listeners:  {
	     	beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
	     		var newTabId = newCard.getId();
					console.log("newCard:  " + newCard.getId());
					console.log("oldCard:  " + oldCard.getId());
					
				switch(newTabId)	{
					case 'agc100skrGrid1':
						directMasterStore.loadStoreRecords();
						break;
						
					case 'agc100skrGrid2':
						directMasterStore2.loadStoreRecords();
						break;
						
					default:
						break;
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
		id : 'agc100skrApp',
		fnInitBinding : function() {
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
			panelSearch.setValue('ST_DATE',getStDt[0].STDT);
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE', UniDate.get('today'));
			panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE', UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.app.fnSetOmitLabel(); // label setting
		},
		onQueryButtonDown : function()	{		
			var activeTabId = tab.getActiveTab().getId();
			if(!this.isValidSearchForm()){
				return false;
			} else {
				if(activeTabId == 'agc100skrGrid1'){
					var param= Ext.getCmp('searchForm').getValues();
					panelSearch.getForm().load({
						params : param,
						success: function(form, action) {
							directMasterStore.loadStoreRecords();
						}
					});				
				} else if(activeTabId == 'agc100skrGrid2') {
					var param= Ext.getCmp('searchForm').getValues();
					panelSearch.getForm().load({
						params : param,
						success: function(form, action) {
							directMasterStore2.loadStoreRecords();
							
						}
					});
				}
				
			}
		},
		fnSetStDate:function(newValue) {
			if(newValue == null){
				return false;
			}else{
				if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
		},
		fnGotoPrintPage:function(type) {
			var params = {
					'PGM_ID'		: 'agc100skr',
					'FR_DATE'		: panelSearch.getValue('FR_DATE'),
					'TO_DATE'		: panelSearch.getValue('TO_DATE'),
					'DIV_CODE'		: panelSearch.getValue('ACCNT_DIV_CODE'),
					'SUB_JECT_DIVI'	: Ext.getCmp('rdoSubjectDiviS').getValue(),
					'CALC_JAN_AMT'	: Ext.getCmp('rdoCalcJanAmtS').getValue(),
					'ST_DATE'		: panelSearch.getValue('ST_DATE'),
					'FORM_DIVISION'	: panelSearch.getValue('FORM_DIVISION'),
					'REF_ITEM'		: Ext.getCmp('rdoRefItemS').getValue(),
					'ZERO_ACCOUNT'	: panelSearch.getValue('ZERO_ACCOUNT'),
					'MON_ICD_YN'	: type
			}
			//전송
			var rec1 = {data : {prgID : 'agc100rkr', 'text':''}};
			parent.openTab(rec1, '/accnt/agc100rkr.do', params);
		},
		// 누락된 계정정보 label 세팅
		fnSetOmitLabel:function(){
			var masterTbar = masterGrid._getToolBar();
			var i = masterTbar[0].items.length -4; 
			masterTbar[0].insert(i++,{
				xtype : 'label',
				style : 'color:#ff0000;font-weight: bold;font-size:11px',
				id    : 'omission_cnt1',
				text  : ' ',		//	'※ 0건의 계정이 누락되어있습니다.'
				hidden: gbHideLabel
			});
			
			var master2Tbar = masterGrid2._getToolBar();
			var j = master2Tbar[0].items.length -4; 
			master2Tbar[0].insert(j++,{
				xtype : 'label',
				style : 'color:#ff0000;font-weight: bold;font-size:11px',
				id    : 'omission_cnt2',
				text  : ' ',		//	'※ 0건의 계정이 누락되어있습니다.'
				hidden: gbHideLabel
			});
		},
		// 누락된 계정정보 조회
		fnGetOmitCnt:function(id){
			agc100skrService.selectOmitCnt({'GUBUN' : panelSearch.getValue("FORM_DIVISION")}, function(provider, result ) {
				var cnt = '0';
				var accnt_nm = '';
				if(provider){
					gbHideLabel	= (Number(provider.OMIT_CNT) == 0 ? true : false);
					
					cnt			= Number(provider.OMIT_CNT) - 1;
					accnt_nm	= provider.ACCNT_NAME + (cnt > 0 ? ' 외 ' + String(cnt) + '건의' : '');
				}
				Ext.getCmp('omission_cnt'+id).setHtml('※ ' + accnt_nm + ' 계정이 누락되어있습니다. 시산표 설정을 확인하시기 바랍니다.');
				Ext.getCmp('omission_cnt'+id).setHidden(gbHideLabel);
			});
		}
	});
};


</script>
