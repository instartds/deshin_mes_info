<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx530ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A024" /> 	<!-- 의제매입세액공제율 -->
	</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >


function appMain() {
	var gsSaveCheck = '';
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx530ukrService.selectList',
			update: 'atx530ukrService.updateDetail',
			create: 'atx530ukrService.insertDetail',
			destroy: 'atx530ukrService.deleteDetail',
			syncAll: 'atx530ukrService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Atx530ukrModel', {
	    fields: [
	    	{name: 'FR_PUB_DATE'			   	,text: 'FR_PUB_DATE' 				,type: 'string'},
	    	{name: 'TO_PUB_DATE'			   	,text: 'TO_PUB_DATE' 				,type: 'string'},
	    	{name: 'BILL_DIV_CODE'			   	,text: 'BILL_DIV_CODE' 				,type: 'string'},
	    	{name: 'SEQ'					   	,text: '일련번호' 						,type: 'int'      , allowBlank: false, maxLength : 5},
	    	{name: 'COMPANY_NUM'			   	,text: '주민등록번호(또는 사업자등록번호)' 	,type: 'string'   , allowBlank: false, maxLength : 14},
	    	{name: 'CUSTOM_NAME'			   	,text: '성명(또는 상호)' 				,type: 'string'   , allowBlank: false, maxLength : 40},
	    	{name: 'BILL_DATE'				   	,text: '거래일자' 						,type: 'uniDate'  , allowBlank: false, maxLength : 10},
	    	{name: 'TOT_AMT_I'	    		   	,text: '공급대가' 						,type: 'uniPrice'},
	    	{name: 'SUPPLY_AMT_I'			   	,text: '공급가액' 						,type: 'uniPrice' , allowBlank: false, maxLength : 30},
	    	{name: 'TAX_AMT_I'				   	,text: '부가가치세' 					,type: 'uniPrice' , allowBlank: false, maxLength : 30},
	    	{name: 'INSERT_DB_USER'			   	,text: 'INSERT_DB_USER' 			,type: 'string'},
	    	{name: 'INSERT_DB_TIME'			   	,text: 'INSERT_DB_TIME' 			,type: 'string'},
	    	{name: 'UPDATE_DB_USER'			   	,text: 'UPDATE_DB_USER' 			,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'			   	,text: 'UPDATE_DB_TIME' 			,type: 'string'},
	    	{name: 'COMP_CODE'		   			,text: 'COMP_CODE' 					,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('atx530ukrMasterStore1',{
		model: 'Atx530ukrModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();	
			
			// 검색조건의 From의 월의 첫째날 ~ To의 월의 마지막날 구하는 식
			var temp = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + '01';
			var lastDay = (new Date(temp.substring(0,4), temp.substring(4,6), 0)).getDate();   // 해당 날짜의 마지막날자 구하기 new Date('년도' , '월' , 0 ).getDate()
			var to_date = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + lastDay;
			
			param.FR_PUB_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(0, 6) + '01';
			param.TO_PUB_DATE = to_date;
			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			var paramMaster= panelSearch.getValues();
			var temp = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + '01';
			var lastDay = (new Date(temp.substring(0,4), temp.substring(4,6), 0)).getDate();   // 해당 날짜의 마지막날자 구하기 new Date('년도' , '월' , 0 ).getDate()
			var to_date = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + lastDay;
			
			paramMaster.FR_PUB_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(0, 6) + '01';
			paramMaster.TO_PUB_DATE = to_date;

			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						directMasterStore.loadStoreRecords();
						//UniAppManager.updateStatus('현금매출 명세가 저장되었습니다.');// "저장되었습니다.
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				if(Ext.isEmpty(records)){
					//alert('해당자료가 없습니다');
					if(tableView.getValue('DATA_YN') == "Y"){
						UniAppManager.setToolbarButtons(['query', 'newData', 'reset','deleteAll'],true);
						UniAppManager.setToolbarButtons(['delete', 'save', 'print'],false);
					}else{
						UniAppManager.setToolbarButtons(['query', 'newData', 'reset', 'save'],true);
						UniAppManager.setToolbarButtons(['delete', 'deleteAll', 'print'],false);
					}
				}else{
					UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'print','deleteAll'],true);
					UniAppManager.setToolbarButtons(['delete', 'save'],false);
				}
			}
		}
	});

	/**
	 * 검색조건 (Search Panel)
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
		    items : [{
	        	fieldLabel: '계산서일',
				xtype: 'uniMonthRangefield',  
		        startFieldName: 'FR_PUB_DATE',
		        endFieldName: 'TO_PUB_DATE',
		        width: 470,
		        allowBlank: false,
		        holdable:'hold',
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_PUB_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_PUB_DATE',newValue);
			    	}
			    }
			},{
				fieldLabel: '신고사업장', 
				name: 'BILL_DIV_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode: 'BILL',
				allowBlank: false,
				holdable:'hold',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{
		    	xtype: 'container',
		    	margin: '0 0 0 60', 
		    	layout: {type : 'uniTable', columns : 2},
		    	items:[{
		    		xtype: 'button',
		    		text: '재참조',
		    		width: 100,
		    		margin: '0 0 0 0',   
		    		id:'search_ReCompute',
		    		handler : function() {
	    			if(confirm(Msg.sMA0103)){	
						var me = this;
						panelSearch.getEl().mask('로딩중...','loading-indicator');
						var param = panelSearch.getValues();
							
						var temp = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + '01';
						var lastDay = (new Date(temp.substring(0,4), temp.substring(4,6), 0)).getDate();   // 해당 날짜의 마지막날자 구하기 new Date('년도' , '월' , 0 ).getDate()
						var from_date = UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(0, 6) + '01';
						var to_date   = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + lastDay;
		
						param.FR_PUB_DATE = from_date;
						param.TO_PUB_DATE = to_date;
						param.S_COMP_CODE = UserInfo.compCode;
						
						atx530ukrService.atx530recal(param, function(provider, response) {
							if(provider != null) {
								tableView.setValue('CREDIT_CNT' , provider.data.CREDIT_CNT);
								tableView.setValue('CREDIT_AMT' , provider.data.CREDIT_AMT);
								tableView.setValue('CASH_CNT' , provider.data.CASH_CNT);
								tableView.setValue('CASH_AMT' , provider.data.CASH_AMT);
								tableView.setValue('CASHSALE_CNT' , provider.data.CASHSALE_CNT);
								tableView.setValue('CASHSALE_AMT' , provider.data.CASHSALE_AMT);
								
								if(provider.data.DATA_YN == 'Y'){
									gsSaveCheck = 'U'
								}else{
									gsSaveCheck = 'N'
								}
								UniAppManager.app.computeAll();
							}
 							panelSearch.getEl().unmask();
						});
	    			}
				}
		    	},{
		    		xtype: 'button',
		    		text: '출력',
		    		width: 100,
		    		margin: '0 0 0 0',  
	    			id:'search_Preview',
		    		handler : function() {
						var me = this;
						panelSearch.getEl().mask('로딩중...','loading-indicator');
						var param = panelSearch.getValues();
						UniAppManager.app.onPrintButtonDown();
	   				}
		    	}]
		    }]		
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
   				if(invalid.length > 0) {
					r=false;
   					var labelText = ''
   	
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}
				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});   
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
        	fieldLabel: '계산서일',
			xtype: 'uniMonthRangefield',  
	        startFieldName: 'FR_PUB_DATE',
	        endFieldName: 'TO_PUB_DATE',
	        width: 470,
	        allowBlank: false,
	        holdable:'hold',
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_PUB_DATE',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_PUB_DATE',newValue);
		    	}
		    }
		},{
			fieldLabel: '신고사업장', 
			name: 'BILL_DIV_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			comboCode: 'BILL',
			allowBlank: false,
			holdable:'hold',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('BILL_DIV_CODE', newValue);
				}
			}
		},{
	    	xtype: 'container',
	    	margin: '-2 0 3 150', 
	    	layout: {type : 'uniTable', columns : 2},
	    	items:[{
	    		xtype: 'button',
	    		text: '재참조',
	    		width: 100,
	    		//margin: '0 0 0 120',    
	    		id:'result_ReCompute',
	    		handler : function() {
	    			if(confirm(Msg.sMA0103)){	
						var me = this;
						panelSearch.getEl().mask('로딩중...','loading-indicator');
						var param = panelSearch.getValues();
							
						var temp = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + '01';
						var lastDay = (new Date(temp.substring(0,4), temp.substring(4,6), 0)).getDate();   // 해당 날짜의 마지막날자 구하기 new Date('년도' , '월' , 0 ).getDate()
						var from_date = UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(0, 6) + '01';
						var to_date   = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + lastDay;
		
						param.FR_PUB_DATE = from_date;
						param.TO_PUB_DATE = to_date;
						param.S_COMP_CODE = UserInfo.compCode;
						
						atx530ukrService.atx530recal(param, function(provider, response) {
							if(provider != null) {
								tableView.setValue('CREDIT_CNT' , provider.data.CREDIT_CNT);
								tableView.setValue('CREDIT_AMT' , provider.data.CREDIT_AMT);
								tableView.setValue('CASH_CNT' , provider.data.CASH_CNT);
								tableView.setValue('CASH_AMT' , provider.data.CASH_AMT);
								tableView.setValue('CASHSALE_CNT' , provider.data.CASHSALE_CNT);
								tableView.setValue('CASHSALE_AMT' , provider.data.CASHSALE_AMT);
								
								if(provider.data.DATA_YN == 'Y'){
									gsSaveCheck = 'U'
								}else{
									gsSaveCheck = 'N'
								}
								UniAppManager.app.computeAll();
							}
 							panelSearch.getEl().unmask();
						});
	    			}
				}
	    	},{
	    		xtype: 'button',
	    		text: '출력',
	    		width: 100,
	    		//margin: '0 0 0 120', 
	    		id:'result_Preview',
	    		handler : function() {
					var me = this;
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					var param = panelSearch.getValues();
					UniAppManager.app.onPrintButtonDown();
   				}
	    	}]
	    }],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
   				if(invalid.length > 0) {
					r=false;
   					var labelText = ''
   	
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}
				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});   
	
	var tableView = Unilite.createForm('detailForm', { //createForm
		padding:'0 0 0 0',
	    title:'<증빙별 공급가액 집계>',
		//border: 0,
		disabled: false,
		flex: 1.5,
		xtype: 'container',
		bodyPadding: 10,
		region: 'center',
		layout: {type: 'uniTable', columns: 11, 
			tableAttrs: {style: 'border : 0px solid #ced9e7;'},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		style: {
			marginTop: '3px !important',
			font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
		},
		defaults:{width: 140},
		items:[
			{ xtype: 'component',  html:'공급가액'		,width: 20	,rowspan:4},
			{ xtype: 'component',  html:'합계'		,width: 100	,rowspan:2,colspan:2},
			{ xtype: 'component',  html:'현금매출*'		,width: 100	,rowspan:2,colspan:2},
			{ xtype: 'component',  html:'법인영수증 매출'	,width: 300	,colspan:6},
			
			{ xtype: 'component',  html:'세금계산서**'	,width: 100	,colspan:2},
			{ xtype: 'component',  html:'신용카드'		,width: 100	,colspan:2},
			{ xtype: 'component',  html:'현금영수증'		,width: 100	,colspan:2},
			
			{ xtype: 'component',  html:'건수'},
			{ xtype: 'component',  html:'금액'},
			{ xtype: 'component',  html:'건수'},
			{ xtype: 'component',  html:'금액'},
			{ xtype: 'component',  html:'건수'},
			{ xtype: 'component',  html:'금액'},
			{ xtype: 'component',  html:'건수'},
			{ xtype: 'component',  html:'금액'},
			{ xtype: 'component',  html:'건수'},
			{ xtype: 'component',  html:'금액'},
			
			{ xtype: 'uniNumberfield', name:'TOT_CNT'		, value:'0', readOnly:true},
			{ xtype: 'uniNumberfield', name:'TOT_AMT'		, value:'0', readOnly:true},
			{ xtype: 'uniNumberfield', name:'CASHSALE_CNT'	, value:'0', readOnly:true},
			{ xtype: 'uniNumberfield', name:'CASHSALE_AMT'	, value:'0', readOnly:true},
			{ xtype: 'uniNumberfield', name:'BILL_CNT'		, value:'0'},
			{ xtype: 'uniNumberfield', name:'BILL_AMT'		, value:'0'},
			{ xtype: 'uniNumberfield', name:'CREDIT_CNT'	, value:'0'},
			{ xtype: 'uniNumberfield', name:'CREDIT_AMT'	, value:'0'},
			{ xtype: 'uniNumberfield', name:'CASH_CNT'		, value:'0'},
			{ xtype: 'uniNumberfield', name:'CASH_AMT'		, value:'0'},
			{ xtype: 'uniTextfield'  , name:'DATA_YN'		, hidden: true},
			{
			    xtype:'component', 
			    html:'</br></br></br>※작성방법</br></br>1. 세금계산서 발급분 중 "부가가치세 시행령" 제53조 제2항에 의해 주민등록번호를 적은 분은 현금매출*에 포함하여 적습니다.</br>2. 세금계산서를 발급한 후 신용카드 매출전표를 발행한 경우에는 세금계산서**에만 적습니다.',
			    width: 900,
			    colspan:11,
			    tdAttrs: {style: 'border : 0px', align : 'left'},
		        	border: false,
			    style: {
			    	marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
		        	color: 'blue'
				}
			}
		],api: {
	 		load: 'atx530ukrService.tableView',
	 		submit: 'atx530ukrService.syncMaster'
		}
	});
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('atx530ukrGrid1', {
        layout : 'fit',
        region:'center',
    	store: directMasterStore,
    	excelTitle: '현금매출명세서',
        uniOpt: {
    		expandLastColumn: false,
		 	copiedRow: true
//		 	useContextMenu: true,
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
    	columns: [
    	    { text : '현금매출 명세(현금매출 내용을 적음)',
       		columns: [        
       			{ dataIndex: 'FR_PUB_DATE'			   	   		, 	width: 66, hidden:true},         
       			{ dataIndex: 'TO_PUB_DATE'			   	   		, 	width: 66, hidden:true},         
       			{ dataIndex: 'BILL_DIV_CODE'			   	   	, 	width: 66, hidden:true},         
       			{ dataIndex: 'SEQ'		   		   	   			, 	width: 86},         
				{ text: '의 뢰 인',
					columns: [
						{ dataIndex: 'COMPANY_NUM'					   	, 	width: 300,
								'editor' : Unilite.popup('CUST_G',{	            
								textFieldName:'COMPANY_NUM',
								DBtextFieldName:'COMPANY_NUM',
								autoPopup:true,
								listeners: {	
					                'onSelected':  function(records, type  ){
					                    	var grdRecord = masterGrid.uniOpt.currentRecord;
					                    	grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
					                    	grdRecord.set('COMPANY_NUM',records[0]['COMPANY_NUM']);
					                },
					                'onClear':  function( type  ){
					                    	var grdRecord = masterGrid.uniOpt.currentRecord;
					                    	grdRecord.set('CUSTOM_NAME','');
					                    	grdRecord.set('COMPANY_NUM','');
					                }
				            	} //listeners
							}) 		
						 }, 	
						{ dataIndex: 'CUSTOM_NAME'     		   	   		, 	width: 400,
							'editor' : Unilite.popup('CUST_G',{	            
							textFieldName:'CUSTOM_NAME',
							autoPopup:true,
							listeners: {	
				                'onSelected':  function(records, type  ){
				                    	var grdRecord = masterGrid.uniOpt.currentRecord;
				                    	grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
				                    	grdRecord.set('COMPANY_NUM',records[0]['COMPANY_NUM']);
				                },
				                'onClear':  function( type  ){
				                    	var grdRecord = masterGrid.uniOpt.currentRecord;
				                    	grdRecord.set('CUSTOM_NAME','');
				                    	grdRecord.set('COMPANY_NUM','');
				                }
			            	} //listeners
						}) 		
						}
					]
				},
				{ dataIndex: 'BILL_DATE'		   		   	   	, 	width: 100},
				{ text: '거 래 금 액',
					columns: [
               			{ dataIndex: 'TOT_AMT_I'			   	   		, 	width: 133 , summaryType: 'sum'},         
               			{ dataIndex: 'SUPPLY_AMT_I'			   	   		, 	width: 133 , summaryType: 'sum'},         
               			{ dataIndex: 'TAX_AMT_I'			   	   		, 	width: 133 , summaryType: 'sum'}
               		]
				},
           		{ dataIndex: 'INSERT_DB_USER'		   	   		, 	width: 0, hidden:true},         
           		{ dataIndex: 'INSERT_DB_TIME'		   	   		, 	width: 0, hidden:true},         
           		{ dataIndex: 'UPDATE_DB_USER'		   	   		, 	width: 0, hidden:true},         
           		{ dataIndex: 'UPDATE_DB_TIME'		   	   		, 	width: 0, hidden:true},
           		{ dataIndex: 'COMP_CODE'	    			  	, 	width: 0, hidden:true}
        	]
		}],
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(panelSearch.getValue('BILL_DIV_CODE') == '00'){
	        		return false;
	        	}
	        	else{
	        		if(UniUtils.indexOf(e.field, ['SEQ', 'TOT_AMT_I'])) {
						return false;
					}
	        	}
	        }
		}
    });   
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			items:[
				tableView,
				{
					border: false,	
					flex: 2.5,
					layout: {type: 'vbox', align: 'stretch'},
					region: 'south',
					items: [{
						title :'<현금매출 명세(현금매출 내용을 적음)>',
						region: 'center',
						border: false
					},masterGrid
					]				
				},panelResult
			]	
		},
			panelSearch
		],
		id  : 'atx510ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('newData',false);
			
			panelSearch.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));
        	panelSearch.setValue('TO_PUB_DATE',UniDate.get('endOfMonth'));
        	panelSearch.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
        	panelResult.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));
        	panelResult.setValue('TO_PUB_DATE',UniDate.get('endOfMonth'));
        	panelResult.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
        	
        	panelSearch.down('#search_ReCompute').setDisabled(true);
        	panelResult.down('#result_ReCompute').setDisabled(true);

			this.fnInitMaster();
			this.fnLockMaster(true);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_PUB_DATE');
		},
		onPrintButtonDown: function() {
			var billDiviCode = panelSearch.getValue('BILL_DIV_CODE');
			var temp = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + '01';
			var lastDay = (new Date(temp.substring(0,4), temp.substring(4,6), 0)).getDate();   // 해당 날짜의 마지막날자 구하기 new Date('년도' , '월' , 0 ).getDate()
			var from_date = UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(0, 6) + '01';
			var to_date   = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + lastDay;
			var param= {
				FR_PUB_DATE : from_date,
				TO_PUB_DATE : to_date,
				BILL_DIV_CODE : billDiviCode
			};
			param.ACCNT_DIV_NAME = panelSearch.getField('BILL_DIV_CODE').getRawValue();
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/atx/atx530ukrPrint.do',
				prgID: 'atx530ukr',
				extParam: param
				});
			win.center();
			win.show();   				
		},
		onQueryButtonDown : function()	{	
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				var temp = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + '01';
				var lastDay = (new Date(temp.substring(0,4), temp.substring(4,6), 0)).getDate();   // 해당 날짜의 마지막날자 구하기 new Date('년도' , '월' , 0 ).getDate()
				
				var from_date = UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(0, 6) + '01';
				var to_date   = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + lastDay;
				var billDivCode = panelSearch.getValue('BILL_DIV_CODE');

				var param= {
					FR_PUB_DATE   : from_date,
					TO_PUB_DATE   : to_date,
					BILL_DIV_CODE : billDivCode
				}
				tableView.getForm().load({
					params : param,
					success: function(form, action) {
						directMasterStore.loadStoreRecords();
						panelResult.setAllFieldsReadOnly(true);
					}
				});	
				
				if(tableView.getValue('DATA_YN') == 'Y'){
					gsSaveCheck = 'U'
				}else{
					gsSaveCheck = 'N'
				}
				
				if(panelSearch.getValue('BILL_DIV_CODE') == '00'){
					this.fnLockMaster(true);
				}else{
					panelSearch.down('#search_ReCompute').setDisabled(false);
        			panelResult.down('#result_ReCompute').setDisabled(false);
					
					this.fnLockMaster(false);
				}
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
			
			var temp = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + '01';
			var lastDay = (new Date(temp.substring(0,4), temp.substring(4,6), 0)).getDate();   // 해당 날짜의 마지막날자 구하기 new Date('년도' , '월' , 0 ).getDate()
			var from_date = UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(0, 6) + '01';
			var to_date   = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + lastDay;	
			
			var frPubDate = from_date;
			var toPubDate = to_date;
			var billDivCode = panelSearch.getValue('BILL_DIV_CODE');
			var compCode = UserInfo.compCode;
			
			var seq = directMasterStore.max('SEQ');
        	if(!seq) seq = 1;
        	else  seq += 1;

            	 var r = {
            	 	FR_PUB_DATE		: frPubDate,
            	 	TO_PUB_DATE		: toPubDate,
            	 	BILL_DIV_CODE	: billDivCode,
            	 	SEQ  			: seq,
            	 	COMP_CODE   	: compCode
		        };
				masterGrid.createRow(r);
				
				panelSearch.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			},
		onResetButtonDown: function() {	
			
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			
			panelSearch.down('#search_ReCompute').setDisabled(true);
        	panelResult.down('#result_ReCompute').setDisabled(true);
			
			this.fnInitMaster();
			this.fnLockMaster(true);
			
			masterGrid.reset();
			directMasterStore.clearData();
			
			UniAppManager.setToolbarButtons('query',true);
			UniAppManager.setToolbarButtons(['reset', 'newData', 'save', 'delete', 'deleteAll', 'print'],false);
		},
		onSaveDataButtonDown: function(config) {	
			if(!tableView.getInvalidMessage()) return false;
			
			var inValidRecs = directMasterStore.getInvalidRecords();
			
			if(inValidRecs.length != 0 )	{
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				return false;
			}
			
			if(tableView.getValue('DATA_YN') == 'Y'){
				gsSaveCheck = 'U'
			}else{
				gsSaveCheck = 'N'
			}
			
			var temp = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + '01';
			var lastDay = (new Date(temp.substring(0,4), temp.substring(4,6), 0)).getDate();   // 해당 날짜의 마지막날자 구하기 new Date('년도' , '월' , 0 ).getDate()
			var from_date = UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(0, 6) + '01';
			var to_date   = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + lastDay;
			
			var rowNum 		= '1';
			var SaveCheck 	= gsSaveCheck;
			var frPubDate	= from_date;
			var toPubDate   = to_date;
			var billDivCode = panelSearch.getValue('BILL_DIV_CODE');
			var totCnt      = tableView.getValue('TOT_CNT');
			var totAmt      = tableView.getValue('TOT_AMT');
			var billCnt     = tableView.getValue('BILL_CNT');
			var billAmt     = tableView.getValue('BILL_AMT');
			var creditCnt   = tableView.getValue('CREDIT_CNT');
			var creditAmt   = tableView.getValue('CREDIT_AMT');
			var cashCnt     = tableView.getValue('CASH_CNT');
			var cashAmt     = tableView.getValue('CASH_AMT');
			var cashSaleCnt = tableView.getValue('CASHSALE_CNT'); 
			var cashSaleAmt = tableView.getValue('CASHSALE_AMT'); 

			var param = {		
				ROWNUM			: rowNum,
				SAVE_CHECK		: SaveCheck,
	
				FR_PUB_DATE 	: frPubDate,
				TO_PUB_DATE 	: toPubDate,
				BILL_DIV_CODE	: billDivCode,   
				
				TOT_CNT         : totCnt,     	             
				TOT_AMT         : totAmt,                  
				BILL_CNT        : billCnt,                
				BILL_AMT        : billAmt,                 
				CREDIT_CNT      : creditCnt,               
				CREDIT_AMT      : creditAmt,               
				CASH_CNT        : cashCnt,                 
				CASH_AMT        : cashAmt,                 
				CASHSALE_CNT    : cashSaleCnt,             
				CASHSALE_AMT    : cashSaleAmt            
			}
			tableView.getForm().submit({
				params : param,
				success : function(form, action) {
		 			tableView.getForm().wasDirty = false;
					directMasterStore.saveStore();
					tableView.resetDirtyStatus();											
					UniAppManager.setToolbarButtons('save', false);	
		            UniAppManager.updateStatus('증빙별 공급가액 집계가 저장되었습니다.');// "저장되었습니다.
		            UniAppManager.app.onQueryButtonDown();
				}	
			});
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
			
			this.computeAll()
		},
		onDeleteAllButtonDown: function() {		
			gsSaveCheck = 'D';
			/*var records = directMasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{*/									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = true;
					if(confirm('전체삭제 하시겠습니까?')) {		
						var deletable = true;
						
						if(deletable){		
							var temp = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + '01';
							var lastDay = (new Date(temp.substring(0,4), temp.substring(4,6), 0)).getDate();   // 해당 날짜의 마지막날자 구하기 new Date('년도' , '월' , 0 ).getDate()
							var from_date = UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(0, 6) + '01';
							var to_date   = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + lastDay;
							
							var SaveCheck 	= gsSaveCheck;
							var frPubDate	= from_date;
							var toPubDate   = to_date;
							var billDivCode = panelSearch.getValue('BILL_DIV_CODE');
	
				
							var param = {		
								SAVE_CHECK		: SaveCheck,
								FR_PUB_DATE 	: frPubDate,
								TO_PUB_DATE 	: toPubDate,
								BILL_DIV_CODE	: billDivCode  
							}			
							masterGrid.reset();	
							tableView.getForm().submit({
								params : param,
								success : function(form, action) {
						 			tableView.getForm().wasDirty = false;
									directMasterStore.saveStore();
									tableView.resetDirtyStatus();											
									UniAppManager.setToolbarButtons('save', false);	
						            UniAppManager.updateStatus('증빙별 공급가액 집계가 삭제 되었습니다.');// "삭제되었습니다.
						            UniAppManager.app.onQueryButtonDown();
								}	
							});
						}
						isNewData = false;	
							
					}
					/*return false;
				}*/
			//});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		//Lock Master Data
		fnLockMaster: function(sBool){
			tableView.getField('BILL_CNT').setReadOnly(sBool);
			tableView.getField('BILL_AMT').setReadOnly(sBool);
			tableView.getField('CREDIT_CNT').setReadOnly(sBool);
			tableView.getField('CREDIT_AMT').setReadOnly(sBool);
			tableView.getField('CASH_CNT').setReadOnly(sBool);
			tableView.getField('CASH_AMT').setReadOnly(sBool);	
		},
		
		//Init Master Data
		fnInitMaster: function() {
			tableView.setValue('TOT_CNT',0);
        	tableView.setValue('TOT_AMT',0);
        	tableView.setValue('BILL_CNT',0);
        	tableView.setValue('BILL_AMT',0);
        	tableView.setValue('CREDIT_CNT',0);
        	tableView.setValue('CREDIT_AMT',0);
        	tableView.setValue('CASH_CNT',0);
        	tableView.setValue('CASH_AMT',0);
        	tableView.setValue('CASHSALE_CNT',0);
        	tableView.setValue('CASHSALE_AMT',0);
        	tableView.setValue('DATA_YN' , 'N');
		},
		
		//합계 계산 - ATX531t가 변경되었을 때
		computeAll: function(newValue){
			var results = masterGrid.getStore().sumBy(function(record, id) {
				return true;
			}, 
			['TOT_AMT_I', 'SUPPLY_AMT_I' , 'TAX_AMT_I']);
			
			dSupplyAmtTot = results.SUPPLY_AMT_I;			// 공급가액
			dTaxAmtTot	  = results.TAX_AMT_I;				// 부가가치세
			dAmtTot		  = results.TOT_AMT_I;
			
			var count = masterGrid.getStore().getCount(); 
			
			// 현금매출
			tableView.setValue('CASHSALE_CNT', count);
			if(!Ext.isEmpty(newValue)){
        		tableView.setValue('CASHSALE_AMT', dSupplyAmtTot + newValue);	// 금액
			}else{
				tableView.setValue('CASHSALE_AMT', dSupplyAmtTot);
			}
        	//합계
        	var tot_cnt = tableView.getValue('BILL_CNT') + tableView.getValue('CREDIT_CNT') + tableView.getValue('CASH_CNT') + tableView.getValue('CASHSALE_CNT');
        	var tot_amt = tableView.getValue('BILL_AMT') + tableView.getValue('CREDIT_AMT') + tableView.getValue('CASH_AMT') + tableView.getValue('CASHSALE_AMT');
        	
        	tableView.setValue('TOT_CNT', tot_cnt);
        	tableView.setValue('TOT_AMT', tot_amt);
        	
        	UniAppManager.setToolbarButtons('save', true);	
        	
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "SUPPLY_AMT_I" :	// 공급가액
					record.set('TAX_AMT_I', newValue * 0.1);
					record.set('TOT_AMT_I', newValue + record.get('TAX_AMT_I'));
					UniAppManager.app.computeAll(newValue);
				break;
				
				case "TAX_AMT_I" :	// 부가가치세
					record.set('TOT_AMT_I', newValue + record.get('SUPPLY_AMT_I'));
					UniAppManager.app.computeAll();
				break;
			}
			return rv;
		}
	});
	
	Unilite.createValidator('validator02', {
		forms: {'formA:':tableView},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			var count = masterGrid.getStore().getCount();
			switch(fieldName) {	
				case "BILL_CNT" :	// 세금계산서 - 건수
					if(newValue < 0 && !Ext.isEmpty(newValue))	{
						rv=Msg.sMB076;	//양수만 입력 가능합니다.
						break;
					}
					UniAppManager.app.computeAll();
					break;
				break;
				case "BILL_AMT" :	// 세금계산서 - 금액
					if(newValue < 0 && !Ext.isEmpty(newValue))	{
						rv=Msg.sMB076;	//양수만 입력 가능합니다.
						break;
					}
					UniAppManager.app.computeAll();
					break;
				break;
				
				
				case "CREDIT_CNT" :	// 신용카드 - 건수
					if(newValue < 0 && !Ext.isEmpty(newValue))	{
						rv=Msg.sMB076;	//양수만 입력 가능합니다.
						break;
					}
					UniAppManager.app.computeAll();
					break;
				break;
				
				case "CREDIT_AMT" :	// 신용카드 - 금액
					if(newValue < 0 && !Ext.isEmpty(newValue))	{
						rv=Msg.sMB076;	//양수만 입력 가능합니다.
						break;
					}
					UniAppManager.app.computeAll();
					break;
				break;
				
				
				case "CASH_CNT" :	// 현금영수증 - 건수
					if(newValue < 0 && !Ext.isEmpty(newValue))	{
						rv=Msg.sMB076;	//양수만 입력 가능합니다.
						break;
					}
					UniAppManager.app.computeAll();
					break;
				break;
				
				case "CASH_AMT" :	// 현금영수증 - 금액
					if(newValue < 0 && !Ext.isEmpty(newValue))	{
						rv=Msg.sMB076;	//양수만 입력 가능합니다.
						break;
					}
					UniAppManager.app.computeAll();
					break;	
				break;
			}
			return rv;
		}
	});
};
</script>
