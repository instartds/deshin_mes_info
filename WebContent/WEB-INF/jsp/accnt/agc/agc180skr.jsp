<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc180skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var BsaCodeInfo =  {
	gsFinancialY: '${gsFinancialY}'
}

function appMain() {   
	
	var getStDt = ${getStDt};
	
	var fnGetSession = ${fnGetSession};

	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agc180skrModel', {
	    fields: [  	  
	    	{name: 'GBN'				, text: 'GRP' 			,type: 'string'},
		    {name: 'SEQ'				, text: '순번'			,type: 'string'},
		    {name: 'ACCNT_CD'			, text: '계정코드' 		,type: 'string'},
		    {name: 'ACCNT_NAME'			, text: '과목'			,type: 'string'},
		    {name: 'AMT_I1'				, text: '금액'			,type: 'uniPrice'},
		    {name: 'BLANK_FIELD1'		, text: 'BLANK_FIELD1'	,type: 'uniPrice'},
		    {name: 'AMT_I2'				, text: '금액'			,type: 'uniPrice'},
		    {name: 'BLANK_FIELD2'		, text: 'BLANK_FIELD2'	,type: 'uniPrice'},
		    {name: 'AMT_I3'				, text: '금액'			,type: 'uniPrice'}
		]          
	});
	
	Unilite.defineModel('Agc180skrModel2', {
	    fields: [  	  
	    	{name: 'GBN'				, text: 'GRP' 			,type: 'string'},
		    {name: 'SEQ'				, text: '순번'			,type: 'string'},
		    {name: 'ACCNT_CD'			, text: '계정코드' 		,type: 'string'},
		    {name: 'ACCNT_NAME'			, text: '과목'			,type: 'string'},
		    {name: 'AMT_I1'				, text: '3개월'			,type: 'uniPrice'},
		    {name: 'AMT_I2'				, text: '누적'			,type: 'uniPrice'},
		    {name: 'AMT_I3'				, text: '3개월'			,type: 'uniPrice'},
		    {name: 'AMT_I4'				, text: '누적'			,type: 'uniPrice'},
		    {name: 'AMT_I5'				, text: '누적'			,type: 'uniPrice'},
		    {name: 'AMT_I6'				, text: '누적'			,type: 'uniPrice'},
		    {name: 'DIS_DIVI'			, text: 'DIS_DIVI'		,type: 'string'},
		    {name: 'OPT_DIVI'			, text: 'OPT_DIVI'		,type: 'string'},  
		    {name: 'BLANK_FIELD1'		, text: 'BLANK_FIELD1'	,type: 'string'},
		    {name: 'BLANK_FIELD2'		, text: 'BLANK_FIELD2'	,type: 'string'}
		]          
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('agc180skrMasterStore1',{
		model: 'Agc180skrModel',
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
                read: 'agc180skrService.selectList1'                	
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
	
	
	var directMasterStore2 = Unilite.createStore('agc180skrMasterStore2',{
		model: 'Agc180skrModel2',
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
                read: 'agc180skrService.selectList2'                	
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
	        	fieldLabel: '당기전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'THIS_DATE_FR',
				endFieldName: 'THIS_DATE_TO',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('THIS_DATE_FR',newValue);
						UniAppManager.app.fnSetStDate(newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('THIS_DATE_TO',newValue);
			    		UniAppManager.app.fnSetEdDate(newValue);
			    	}   	
			    }
			},{ 
	        	fieldLabel: '전기전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'PREV_DATE_FR',
				endFieldName: 'PREV_DATE_TO',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('PREV_DATE_FR',newValue);
						UniAppManager.app.fnSetMdDate(newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PREV_DATE_TO',newValue);
			    	}   	
			    }
			},{ 
	        	fieldLabel: '전전기전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'PPREV_DATE_FR',
				endFieldName: 'PPREV_DATE_TO',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('PPREV_DATE_FR',newValue);
						UniAppManager.app.fnSetLastDate(newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PPREV_DATE_TO',newValue);
			    	}   	
			    }
			},{ 
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				multiSelect: true, 
		        typeAhead: false,
				value : UserInfo.divCode,
				comboType: 'BOR120',
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
		 		fieldLabel: '당기시작년월',
		 		xtype: 'uniMonthfield',
		 		name: 'THIS_START_DATE',
		 		allowBlank:false
			},{
		 		fieldLabel: '전기시작년월',
		 		xtype: 'uniMonthfield',
		 		name: 'PREV_DATE',
		 		allowBlank:false
			},{
		 		fieldLabel: '전전기시작년월',
		 		xtype: 'uniMonthfield',
		 		name: 'PPREV_DATE',
		 		allowBlank:false
			},{
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
        	fieldLabel: '당기전표일',
			xtype: 'uniDateRangefield',  
			startFieldName: 'THIS_DATE_FR',
			endFieldName: 'THIS_DATE_TO',
			allowBlank:false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('THIS_DATE_FR',newValue);
					UniAppManager.app.fnSetStDate(newValue);
            	}   
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('THIS_DATE_TO',newValue);
		    		UniAppManager.app.fnSetEdDate(newValue);
		    	}   	
		    }
		},{ 
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			multiSelect: true, 
	        typeAhead: false,
			value : UserInfo.divCode,
			comboType: 'BOR120',
				width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{ 
        	fieldLabel: '전기전표일',
			xtype: 'uniDateRangefield',  
			startFieldName: 'PREV_DATE_FR',
			endFieldName: 'PREV_DATE_TO',
			allowBlank:false,
			width: 315,
			colspan:2,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('PREV_DATE_FR',newValue);
            	}   
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('PREV_DATE_TO',newValue);
		    	}   	
		    }
		},{ 
        	fieldLabel: '전전기전표일',
			xtype: 'uniDateRangefield',  
			startFieldName: 'PPREV_DATE_FR',
			endFieldName: 'PPREV_DATE_TO',
			allowBlank:false,
			width: 315,
			colspan:2,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('PPREV_DATE_FR',newValue);
            	}   
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('PPREV_DATE_TO',newValue);
		    	}   	
		    }
		}]	
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('agc180skrGrid1', {
    	title: '대차대조표',
    	layout : 'fit',
        store : directMasterStore1, 
        uniOpt : {
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
				useFilter	: true,		
				autoCreate	: true		
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
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'출력',
	        	handler:function()	{
	        		if(masterGrid.getSelectedRecords().length > 0 ){
		    			alert("출력 레포트를 만들어주세요.");
			    		}
			    		else{
			    			alert("선택된 자료가 없습니다.");
			    		}
	        		}
        	}
        ],
        columns: [        
        	{dataIndex: 'GBN'				, width: 66 , hidden: true}, 				
			{dataIndex: 'SEQ'				, width: 66 , hidden: true},
			{dataIndex: 'ACCNT_CD'			, width: 66 , hidden: true},
			{dataIndex: 'ACCNT_NAME'		, width: 293},
			{itemId:'CHANGE_NAME1',
				columns:[ {dataIndex: 'AMT_I1'   		, width: 226 }
						  //{dataIndex: 'BLANK_FIELD1'   	, width: 66 }
					]
			},
			{itemId:'CHANGE_NAME2',
				columns:[ {dataIndex: 'AMT_I2'   		, width: 226 }
						  //{dataIndex: 'BLANK_FIELD2'   	, width: 66 }
					]
			},
			{itemId:'CHANGE_NAME3',
				columns:[ {dataIndex: 'AMT_I3'   		, width: 226 }
						  //{dataIndex: 'BLANK_FIELD1'   	, width: 66 }
					]
			}
		]              	        
    });  
    
    
    var masterGrid2 = Unilite.createGrid('agc180skrGrid2', {
    	title: '손익계산서',
    	layout : 'fit',
        store : directMasterStore2, 
        uniOpt : {
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
				useFilter	: true,		
				autoCreate	: true		
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
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'출력',
	        	handler:function()	{
	        		if(masterGrid2.getSelectedRecords().length > 0 ){
		    			alert("출력 레포트를 만들어주세요.");
			    		}
			    		else{
			    			alert("선택된 자료가 없습니다.");
			    		}
	        		}
        	}
        ],
        columns: [        
        	{dataIndex: 'GBN'				, width: 66 , hidden: true}, 				
			{dataIndex: 'SEQ'				, width: 66 , hidden: true},
			{dataIndex: 'ACCNT_CD'			, width: 66 , hidden: true},
			{dataIndex: 'ACCNT_NAME'		, width: 293},
			
			{itemId:'CHANGE_NAME4',
				columns:[ {dataIndex: 'AMT_I1'   	, width: 113},
						  {dataIndex: 'AMT_I2'   	, width: 113}
					]
			},
			
			{itemId:'CHANGE_NAME5',
				columns:[ {dataIndex: 'AMT_I3'   	, width: 113},
						  {dataIndex: 'AMT_I4'   	, width: 113}
					]
			},
			
			{itemId:'CHANGE_NAME6',
				columns:[ {dataIndex: 'AMT_I5'   	, width: 226}
					]
			},
			
			{itemId:'CHANGE_NAME7',
				columns:[ {dataIndex: 'AMT_I6'   	, width: 226}
					]
			}
			//{dataIndex: 'BLANK_FIELD1'		, width: 66 , hidden: true},
			//{dataIndex: 'BLANK_FIELD2'		, width: 66 , hidden: true},
			//{dataIndex: 'BLANK_FIELD3'		, width: 66 , hidden: true}
		]              	        
    }); 
    
    var tab = Unilite.createTabPanel('tabPanel',{
    	region:'center',
	    items: [
	         masterGrid,
	         masterGrid2
	    ],
	    listeners:{
    		beforetabchange: function( tabPanel, newCard, oldCard, eOpts )	{
    			
    			if(!UniAppManager.app.fnCheckData(true)){
					return false;
				}
    			if(!UniAppManager.app.isValidSearchForm()){
					return false;
				}
    		},
    		tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
    			
    			if(newCard.getItemId() == 'agc180skrGrid1')	{
						
					masterGrid.down('#CHANGE_NAME1').setText('제 ' + UniAppManager.app.fnCallSession() + ' 기');
					masterGrid.down('#CHANGE_NAME2').setText('제 ' + UniAppManager.app.fnCallSessionMd() + ' 기');
					masterGrid.down('#CHANGE_NAME3').setText('제 ' + UniAppManager.app.fnCallSessionLast() + ' 기');	
    				
    				UniAppManager.app.onQueryButtonDown();
    				
    			}else if(newCard.getItemId() == 'agc180skrGrid2') {
					
					var param = {DATE: parseInt(UniDate.getDbDateStr(panelSearch.getValue('THIS_DATE_TO')).substring(4, 6))};								   
					
					accntCommonService.fnGetTermDivi(param, function(provider, response)	{
						if(provider){	
							masterGrid2.down('#CHANGE_NAME4').setText('제 ' + UniAppManager.app.fnCallSession() + ' 기 ' + provider.SUB_CODE + '분기'); 
						}
					});
					
					var param 	= {DATE: parseInt(UniDate.getDbDateStr(panelSearch.getValue('PREV_DATE_TO')).substring(4, 6))};								   
					
					accntCommonService.fnGetTermDivi(param, function(provider, response)	{
						if(provider){
							masterGrid2.down('#CHANGE_NAME5').setText('제 ' + UniAppManager.app.fnCallSessionMd() + ' 기 '	+  provider.SUB_CODE + '분기');
						}
					});
					
					
					var thisTermDivi	  =	UniAppManager.app.sThisTermDivi();
					var prevTermDivi	  =	UniAppManager.app.sPrevTermDivi();
					
					masterGrid2.down('#CHANGE_NAME6').setText('제 ' + UniAppManager.app.fnCallSessionMd() + ' 기 연간');
					masterGrid2.down('#CHANGE_NAME7').setText('제 ' + UniAppManager.app.fnCallSessionLast() + ' 기 연간');
    				
    				
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
		id : 'agc180skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			/* 전기시작년월 */
			var prevDate = UniDate.getDbDateStr(getStDt[0].STDT).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6) + UniDate.getDbDateStr(getStDt[0].STDT).substring(6, 8); 
			/* 전전기 시작년월 */
			var ppreDate = UniDate.getDbDateStr(getStDt[0].STDT).substring(0, 4)-2 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6) + UniDate.getDbDateStr(getStDt[0].STDT).substring(6, 8);
	
			
			panelSearch.setValue('THIS_START_DATE',getStDt[0].STDT);		/* 당기시작년월  */
			panelSearch.setValue('PREV_DATE', prevDate);					/* 전기시작년월	*/
			panelSearch.setValue('PPREV_DATE', ppreDate);					/* 전전기시작년월 */
			
			
			var thisDate = UniDate.get('today');
			
			panelSearch.setValue('THIS_DATE_FR',getStDt[0].STDT);			/* 당기전표일 fr */
			panelResult.setValue('THIS_DATE_FR',getStDt[0].STDT);
			
			panelSearch.setValue('THIS_DATE_TO',UniDate.get('today'));		/* 당기전표일 to */
			panelResult.setValue('THIS_DATE_TO',UniDate.get('today'));
			
			
			panelSearch.setValue('PREV_DATE_FR',prevDate);					/* 전기전표일 fr */
			panelResult.setValue('PREV_DATE_FR',prevDate);
					
			panelSearch.setValue('PREV_DATE_TO' ,UniDate.add(panelSearch.getValue('THIS_DATE_FR'), {days:-1})); 	/* 전기전표일 to */
			panelResult.setValue('PREV_DATE_TO' ,UniDate.add(panelSearch.getValue('THIS_DATE_FR'), {days:-1}));
			
			
			panelSearch.setValue('PPREV_DATE_FR',ppreDate);					/* 전전기전표일 fr */
			panelResult.setValue('PPREV_DATE_FR',ppreDate);
			
			panelSearch.setValue('PPREV_DATE_TO' ,UniDate.add(panelSearch.getValue('PREV_DATE_FR'), {days:-1})); 	/* 전전기전표일 to */
			panelResult.setValue('PPREV_DATE_TO' ,UniDate.add(panelSearch.getValue('PREV_DATE_FR'), {days:-1}));
			
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			
			if(UniAppManager.app.fnCallSession(true)){
				masterGrid.down('#CHANGE_NAME1').setText('제 ' + UniAppManager.app.fnCallSession() + ' 기');
			}
			
			if(UniAppManager.app.fnCallSessionMd(true)){
				masterGrid.down('#CHANGE_NAME2').setText('제 ' + UniAppManager.app.fnCallSessionMd() + ' 기');
			}
			
			if(UniAppManager.app.fnCallSessionLast(true)){
				masterGrid.down('#CHANGE_NAME3').setText('제 ' + UniAppManager.app.fnCallSessionLast() + ' 기');
			}
			
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.isValidSearchForm()){
				return false;
			}else{
				if(!UniAppManager.app.fnCheckData(true)){
					return false;
				}else{
					var activeTabId = tab.getActiveTab().getId();			
					if(activeTabId == 'agc180skrGrid1'){			
						masterGrid.down('#CHANGE_NAME1').setText('제 ' + UniAppManager.app.fnCallSession() + ' 기');
						masterGrid.down('#CHANGE_NAME2').setText('제 ' + UniAppManager.app.fnCallSessionMd() + ' 기');
						masterGrid.down('#CHANGE_NAME3').setText('제 ' + UniAppManager.app.fnCallSessionLast() + ' 기');	

						directMasterStore1.loadStoreRecords();				
					}
					else if(activeTabId == 'agc180skrGrid2'){
						
						var param = {DATE: parseInt(UniDate.getDbDateStr(panelSearch.getValue('THIS_DATE_TO')).substring(4, 6))};								   
					
						accntCommonService.fnGetTermDivi(param, function(provider, response)	{
							if(provider){	
								masterGrid2.down('#CHANGE_NAME4').setText('제 ' + UniAppManager.app.fnCallSession() + ' 기 ' + provider.SUB_CODE + '분기'); 
							}
						});
						
						var param 	= {DATE: parseInt(UniDate.getDbDateStr(panelSearch.getValue('PREV_DATE_TO')).substring(4, 6))};								   
						
						accntCommonService.fnGetTermDivi(param, function(provider, response)	{
							if(provider){
								masterGrid2.down('#CHANGE_NAME5').setText('제 ' + UniAppManager.app.fnCallSessionMd() + ' 기 '	+  provider.SUB_CODE + '분기');
							}
						});
						
						
						var thisTermDivi	  =	UniAppManager.app.sThisTermDivi();
						var prevTermDivi	  =	UniAppManager.app.sPrevTermDivi();
						
						masterGrid2.down('#CHANGE_NAME6').setText('제 ' + UniAppManager.app.fnCallSessionMd() + ' 기 연간');
						masterGrid2.down('#CHANGE_NAME7').setText('제 ' + UniAppManager.app.fnCallSessionLast() + ' 기 연간');
						directMasterStore2.loadStoreRecords();				
					}
				}
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
        fnCallSession:function(){
			var sStDate 	= UniDate.getDbDateStr(panelSearch.getValue('THIS_START_DATE')).substring(0, 6);		/* 입력된 당기시작년월 */								   
			var sThisStDate = UniDate.getDbDateStr(getStDt[0].STDT).substring(0, 6);								
			/* 기본 당기시작년월 */ 
			var sSession	= fnGetSession[0].SESSION;
			
			if(sStDate < sThisStDate){
				
				var sessionCalc = UniDate.getDbDateStr(sThisStDate).substring(0, 4) - UniDate.getDbDateStr(sStDate).substring(0, 4);
				
				var sSession = sSession - sessionCalc; 
			}

			var fanalSession 	= sSession;
			
			return fanalSession;
		},
		fnCallSessionMd:function(){
			var sStDate 	= UniDate.getDbDateStr(panelSearch.getValue('PREV_DATE')).substring(0, 6);											/* 입력된 당기시작년월 */								   
			var sThisStDate = (UniDate.getDbDateStr(getStDt[0].STDT).substring(0, 4)-1) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6);	/* 기본 당기시작년월 */ 
			var sSession	= fnGetSession[0].SESSION -1;
			
			if(sStDate < sThisStDate){
				
				var sessionCalc = UniDate.getDbDateStr(sThisStDate).substring(0, 4) - UniDate.getDbDateStr(sStDate).substring(0, 4);
				
				var sSession = sSession - sessionCalc; 
			}

			var fnCallSessionMd 	= sSession;
			
			return fnCallSessionMd;
		},
		fnCallSessionLast:function(){
			var sStDate 	= UniDate.getDbDateStr(panelSearch.getValue('PPREV_DATE')).substring(0, 6);												/* 입력된 당기시작년월 */								   
			var sThisStDate = (UniDate.getDbDateStr(getStDt[0].STDT).substring(0, 4)-2) + UniDate.getDbDateStr(getStDt[0].STDT).substring(0, 6);	/* 기본 당기시작년월 */ 
			var sSession	= fnGetSession[0].SESSION - 2;
			
			if(sStDate < sThisStDate){
				
				var sessionCalc = UniDate.getDbDateStr(sThisStDate).substring(0, 4) - UniDate.getDbDateStr(sStDate).substring(0, 4);
				
				var sSession = sSession - sessionCalc; 
			}

			var fnCallSessionLast 	= sSession;
			
			return fnCallSessionLast;
		},
		
		sThisTermDivi:function(){
			var param = {DATE: parseInt(UniDate.getDbDateStr(panelSearch.getValue('THIS_DATE_TO')).substring(4, 6))};								   
					
			var sThisTermDivi = '';
			
			accntCommonService.fnGetTermDivi(param, function(provider, response)	{
				//if(provider){
					var sThisTermDivi = provider.SUB_CODE
				//}
			});

			return sThisTermDivi;
		},
		
		sPrevTermDivi:function(){
			var param 	= {DATE: parseInt(UniDate.getDbDateStr(panelSearch.getValue('PREV_DATE_TO')).substring(4, 6))};								   
			
			var sPrevTermDivi = '';
			
			accntCommonService.fnGetTermDivi(param, function(provider, response)	{
				//if(provider){
					var sPrevTermDivi = provider.SUB_CODE
				//}
			});

			return sPrevTermDivi;
		},
		
		fnCheckData:function(newValue){
			var thisDateFr = panelSearch.getField('THIS_DATE_FR').getSubmitValue();  // 당기전표일 FR
			var thisDataTo = panelSearch.getField('THIS_DATE_TO').getSubmitValue();  // 당기전표일 TO
			// 전기전표일
			var prevDateFr = panelSearch.getField('PREV_DATE_FR').getSubmitValue();  // 전기전표일 FR
			var prevDateTo = panelSearch.getField('PREV_DATE_TO').getSubmitValue();  // 전기전표일 TO
			
			var pprevDateFr = panelSearch.getField('PPREV_DATE_FR').getSubmitValue();  // 전전기전표일 FR
			var pprevDateTo = panelSearch.getField('PPREV_DATE_TO').getSubmitValue();  // 전전기전표일 TO
			
			var thisStartDate = panelSearch.getField('THIS_START_DATE').getSubmitValue();  	// 당기시작년월
			var prevStartDate = panelSearch.getField('PREV_DATE').getSubmitValue();  		// 전기시작년월
			var pprevStartDate = panelSearch.getField('PPREV_DATE').getSubmitValue();  		// 전전기시작년월

			var r= true
			
			if(thisDateFr > thisDataTo) {
				alert('당기전표일: 시작일이 종료일보다 클수는 없습니다.');
				//당기전표일: 시작일이 종료일보다 클수는 없습니다.
				//alert('<t:message code="unilite.msg.sMAW036"/>' + '<t:message code="unilite.msg.sMB084"/>');
				panelSearch.setValue('THIS_DATE_FR',thisDateFr);
				panelResult.setValue('THIS_DATE_FR',thisDateFr);						
				panelSearch.getField('THIS_DATE_FR').focus();
				r = false;
				return false;
			}

			if(prevDateFr > prevDateTo) {
				alert('전기전표일: 시작일이 종료일보다 클수는 없습니다.');
				
				//전기전표일: 시작일이 종료일보다 클수는 없습니다.
				//alert('<t:message code="unilite.msg.sMAW037"/>' + '<t:message code="unilite.msg.sMB084"/>');
				panelSearch.setValue('PREV_DATE_FR',prevDateFr);
				panelResult.setValue('PREV_DATE_FR',prevDateFr);						
				panelSearch.getField('PREV_DATE_FR').focus();
				r = false;
				return false;
			}
			
			if(thisDateFr < prevDateTo) {
				alert('전기전표일이 당기전표일보다 클 수 없습니다.');
				//전기전표일이 당기전표일보다 클 수 없습니다.
				//alert('<t:message code="unilite.msg.sMA0324"/>');
				panelSearch.setValue('PREV_DATE_FR',prevDateFr);
				panelResult.setValue('PREV_DATE_FR',prevDateFr);						
				panelSearch.getField('PREV_DATE_FR').focus();
				r = false;
				return false;
			}
			
			if(pprevDateFr > pprevDateTo) {
				alert('전전기표 종료일이 전전기전표 시작일 보다 작을 수 없습니다.: 시작일이 종료일보다 클수는 없습니다.');
				
				//전기전표일: 시작일이 종료일보다 클수는 없습니다.
				//alert('<t:message code="unilite.msg.sMAW037"/>' + '<t:message code="unilite.msg.sMB084"/>');
				panelSearch.setValue('PPREV_DATE_FR',prevDateFr);
				panelResult.setValue('PPREV_DATE_FR',prevDateFr);						
				panelSearch.getField('PPREV_DATE_FR').focus();
				r = false;
				return false;
			}
			
			if(prevDateFr < pprevDateTo) {
				alert('전기전표 종료일이 전전기전표 시작일 작을을 수 없습니다..');
				//전기전표일이 당기전표일보다 클 수 없습니다.
				//alert('<t:message code="unilite.msg.sMA0324"/>');
				panelSearch.setValue('PPREV_DATE_FR',prevDateFr);
				panelResult.setValue('PPREV_DATE_FR',prevDateFr);						
				panelSearch.getField('PPREV_DATE_FR').focus();
				r = false;
				return false;
			}
			return r;
		},
		fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
		    		panelSearch.setValue('PREV_DATE_FR', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(newValue).substring(4, 6) + UniDate.getDbDateStr(newValue).substring(6, 8));  	/* 전기 전표일 fr*/
		    		panelResult.setValue('PREV_DATE_FR', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(newValue).substring(4, 6) + UniDate.getDbDateStr(newValue).substring(6, 8));  	/* 전기 전표일 fr*/
		    		
		    		panelSearch.setValue('PPREV_DATE_FR', UniDate.getDbDateStr(newValue).substring(0, 4)-2 + UniDate.getDbDateStr(newValue).substring(4, 6) + UniDate.getDbDateStr(newValue).substring(6, 8));  	/* 전전기 전표일 fr*/
		    		panelResult.setValue('PPREV_DATE_FR', UniDate.getDbDateStr(newValue).substring(0, 4)-2 + UniDate.getDbDateStr(newValue).substring(4, 6) + UniDate.getDbDateStr(newValue).substring(6, 8));  	/* 전전기 전표일 fr*/
		    		
		    		
					panelSearch.setValue('THIS_START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));	/* 당기시작년월 */
					panelSearch.setValue('PREV_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));	/* 전기시작년월 */
					panelSearch.setValue('PPREV_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-2 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));	/* 전전기시작년월 */
					
				}else{
					panelSearch.setValue('PREV_DATE_FR', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(newValue).substring(4, 6) + UniDate.getDbDateStr(newValue).substring(6, 8));
					panelResult.setValue('PREV_DATE_FR', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(newValue).substring(4, 6) + UniDate.getDbDateStr(newValue).substring(6, 8));
					
					panelSearch.setValue('PPREV_DATE_FR', UniDate.getDbDateStr(newValue).substring(0, 4)-2 + UniDate.getDbDateStr(newValue).substring(4, 6) + UniDate.getDbDateStr(newValue).substring(6, 8));
					panelResult.setValue('PPREV_DATE_FR', UniDate.getDbDateStr(newValue).substring(0, 4)-2 + UniDate.getDbDateStr(newValue).substring(4, 6) + UniDate.getDbDateStr(newValue).substring(6, 8));
					
					panelSearch.setValue('THIS_START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
					panelSearch.setValue('PREV_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
					panelSearch.setValue('PPREV_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-2 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
        },
        fnSetMdDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('PREV_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));	/* 전기시작년월 */
					
				}else{
					panelSearch.setValue('PREV_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
        },
        fnSetLastDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('PPREV_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));	/* 전기시작년월 */
					
				}else{
					panelSearch.setValue('PPREV_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
        },
        fnSetEdDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
		    		panelSearch.setValue('PREV_DATE_TO', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(newValue).substring(4, 6) + UniDate.getDbDateStr(newValue).substring(6, 8));  	/* 전기 전표일 to*/
					panelResult.setValue('PREV_DATE_TO', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(newValue).substring(4, 6) + UniDate.getDbDateStr(newValue).substring(6, 8));  	/* 전기 전표일 to*/
					
					panelSearch.setValue('PPREV_DATE_TO', UniDate.getDbDateStr(newValue).substring(0, 4)-2 + UniDate.getDbDateStr(newValue).substring(4, 6) + UniDate.getDbDateStr(newValue).substring(6, 8));  	/* 전전기 전표일 to*/
					panelResult.setValue('PPREV_DATE_TO', UniDate.getDbDateStr(newValue).substring(0, 4)-2 + UniDate.getDbDateStr(newValue).substring(4, 6) + UniDate.getDbDateStr(newValue).substring(6, 8));  	/* 전전기 전표일 to*/
				}else{
					panelSearch.setValue('PREV_DATE_TO', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(newValue).substring(4, 6) + UniDate.getDbDateStr(newValue).substring(6, 8));
					panelResult.setValue('PREV_DATE_TO', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(newValue).substring(4, 6) + UniDate.getDbDateStr(newValue).substring(6, 8));
					
					panelSearch.setValue('PPREV_DATE_TO', UniDate.getDbDateStr(newValue).substring(0, 4)-2 + UniDate.getDbDateStr(newValue).substring(4, 6) + UniDate.getDbDateStr(newValue).substring(6, 8));
					panelResult.setValue('PPREV_DATE_TO', UniDate.getDbDateStr(newValue).substring(0, 4)-2 + UniDate.getDbDateStr(newValue).substring(4, 6) + UniDate.getDbDateStr(newValue).substring(6, 8));
				}
			}
        }
	});
};


</script>
