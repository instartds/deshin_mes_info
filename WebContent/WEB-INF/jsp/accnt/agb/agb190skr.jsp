<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb190skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->        
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >



function appMain() {     
	var getStDt = ${getStDt};			/* 당기시작년월 */
    var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
	var blnAmtI = 0;
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb190skrModel', {
	    fields: [  	 
	    	{name: 'GUBUN'   			, text: 'GUBUN' 		,type: 'string'},
		    {name: 'GUBUN1' 			, text: 'GUBUN1'		,type: 'string'},
		    {name: 'JAN_DIVI'   		, text: 'JAN_DIVI' 		,type: 'string'},
		    {name: 'INPUT_DIVI'   		, text: 'INPUT_DIVI' 	,type: 'string'},
		    {name: 'INPUT_PATH'   		, text: 'INPUT_PATH' 	,type: 'string'},
		    {name: 'DIV_CODE'   		, text: '사업장' 			,type: 'string'},
	    
	    	{name: 'PEND_CD'   			, text: '관리항목명칭코드' 	,type: 'string'},
		    {name: 'PEND_NAME' 			, text: '관리항목명칭'		,type: 'string'},
		    {name: 'ACCNT'   			, text: '계정코드' 		,type: 'string'},
		    {name: 'ACCNT_NAME'			, text: '계정과목명' 		,type: 'string'},
		    {name: 'AC_DATE'    		, text: '전표일' 			,type: 'string'},
		    {name: 'SLIP_NUM'   		, text: '번호' 			,type: 'string'},
		    {name: 'SLIP_SEQ'  			, text: '순번' 			,type: 'string'},
		    {name: 'REMARK'   			, text: '적요' 			,type: 'string'},
		    {name: 'DR_AMT_I'	 		, text: '차변금액' 		,type: 'uniPrice'},
		    {name: 'CR_AMT_I'   		, text: '대변금액' 		,type: 'uniPrice'},
		    {name: 'B_AMT_I'  	 		, text: '잔액' 			,type: 'uniPrice'}
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
	var directMasterStore = Unilite.createStore('agb190skrMasterStore1',{
		model: 'Agb190skrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,		// 수정 모드 사용 
            deletable:false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agb190skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}/*,
		listeners: {
			
			load : function(store, records, successful, operation, eOpts){
				if(successful){
					Ext.each(records, function(record, rowIndex){
						
						var preRecord = store.getAt(rowIndex - 1);
						
						
							if(record.get('GUBUN') != '4'){
								
								if(record.get('GUBUN') == '1') {			// 이월금액
									blnAmtI = record.get('B_AMT_I');	
								
								} else if (record.get('GUBUN') == '4') {	// 소계
									blnAmtI = 0;
									
								} else if(record.get('GUBUN') == '6') {		// 누계
									
									blnAmtI = record.get('B_AMT_I');
									
								} else {
										if(blnAmtI == 0) {
											if(record.get('JAN_DIVI') =='1'){
												if(preRecord == null){
													blnAmtI = record.get('DR_AMT_I') - record.get('CR_AMT_I')
												}
												else{
													blnAmtI = preRecord.get('B_AMT_I') + record.get('DR_AMT_I') - record.get('CR_AMT_I');
												}
											}
											else if(record.get('JAN_DIVI') =='2'){
												if(preRecord == null){
													blnAmtI = preRecord.get('B_AMT_I') - record.get('DR_AMT_I') + record.get('CR_AMT_I');
												}
												else{
													blnAmtI =  record.get('DR_AMT_I') + record.get('CR_AMT_I')
												}
											}
										} else {
											if(record.get('JAN_DIVI') =='1'){
												blnAmtI = blnAmtI + record.get('DR_AMT_I') - record.get('CR_AMT_I');
											}
											else if(record.get('JAN_DIVI') =='2'){
												blnAmtI = blnAmtI - record.get('DR_AMT_I') + record.get('CR_AMT_I');
											}
									}
							record.set('B_AMT_I', blnAmtI);
							}
						}
					});	
					store.commitChanges();
				}
				
			}
		}*/
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
		        fieldLabel: '전표일',
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
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
			},
				Unilite.popup('MANAGE',{
				itemId :'MANAGE',
				fieldLabel: '관리항목',
				allowBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('MANAGE_CODE', panelSearch.getValue('MANAGE_CODE'));
							panelResult.setValue('MANAGE_NAME', panelSearch.getValue('MANAGE_NAME'));
							/**
							 * 관리항목 팝업을 작동했을때의 동적 필드 생성(항상 FR과 TO필드 2개를 생성 해준다..) 
							 * 생성된 필드가 팝업일시 필드name은 아래와 같음
							 * 				FR 필드								TO 필드
							 *  valueFieldName    textFieldName	 ~	 valueFieldName	  textFieldName
							 * DYNAMIC_CODE_FR, DYNAMIC_NAME_FR  ~  DYNAMIC_CODE_TO, DYNAMIC_NAME_TO
							 * --------------------------------------------------------------------------
							 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음
							 * 		FR 필드				 ~				TO 필드
							 * 	DYNAMIC_CODE_FR			 ~			DYNAMIC_CODE_TO
							 * */
							var param = {AC_CD : panelSearch.getValue('MANAGE_CODE')};
							accntCommonService.fnGetAcCode(param, function(provider, response)	{
								var dataMap = provider;
								UniAccnt.changeFields(panelSearch, dataMap, panelResult);
								UniAccnt.changeFields(panelResult, dataMap, panelSearch);
								
								masterGrid.getColumn('PEND_CD').setText(provider.AC_NAME);
								masterGrid.getColumn('PEND_NAME').setText(provider.AC_NAME + '명');
							});
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('MANAGE_CODE', '');
						panelResult.setValue('MANAGE_NAME', '');
						/**
						 * onClear시 removeField..
						 */
						UniAccnt.removeField(panelSearch, panelResult);
					},
					applyextparam: function(popup){							
						
					}
				}
			}),{
			  	xtype: 'container',
			  	//colspan:  ?,
			  	itemId: 'formFieldArea1', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			 },
				Unilite.popup('ACCNT',{ 
			    	fieldLabel: '계정과목', 
			    	valueFieldName: 'ACCNT_CODE_FR',
					textFieldName: 'ACCNT_NAME_FR',
					autoPopup:true,
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ACCNT_CODE_FR', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ACCNT_NAME_FR', newValue);				
						},
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                		'ADD_QUERY' : " (GROUP_YN = 'N')",
                                		'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                                }
                                popup.setExtParam(param);
                            }
                        }
					}
			}),   	
				Unilite.popup('ACCNT',{ 
					fieldLabel: '~',
					valueFieldName: 'ACCNT_CODE_TO',
					textFieldName: 'ACCNT_NAME_TO',
					autoPopup:true,
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ACCNT_CODE_TO', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ACCNT_NAME_TO', newValue);				
						},
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                		'ADD_QUERY' : " (GROUP_YN = 'N')",
                                		'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                                }
                                popup.setExtParam(param);
                            }
                        }
					}
				})
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
			 		name: 'START_DATE',
			 		allowBlank:false
				},{
					xtype: 'radiogroup',		            		
					fieldLabel: '과목명',	
					id:'accountNameSe',
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
		items: [		    
	    	{ 
		        fieldLabel: '전표일',
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
//				textFieldWidth:170
				
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
			},
				Unilite.popup('MANAGE',{
				itemId :'MANAGE',
				fieldLabel: '관리항목',
				allowBlank:false,
				colspan: 2,
				listeners: {
					
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('MANAGE_CODE', panelResult.getValue('MANAGE_CODE'));
							panelSearch.setValue('MANAGE_NAME', panelResult.getValue('MANAGE_NAME'));
							/**
							 * 관리항목 팝업을 작동했을때의 동적 필드 생성(항상 FR과 TO필드 2개를 생성 해준다..) 
							 * 생성된 필드가 팝업일시 필드name은 아래와 같음
							 * 				FR 필드								TO 필드
							 *  valueFieldName    textFieldName	 ~	 valueFieldName	  textFieldName
							 * DYNAMIC_CODE_FR, DYNAMIC_NAME_FR  ~  DYNAMIC_CODE_TO, DYNAMIC_NAME_TO
							 * --------------------------------------------------------------------------
							 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음
							 * 		FR 필드				 ~				TO 필드
							 * 	DYNAMIC_CODE_FR			 ~			DYNAMIC_CODE_TO
							 * */
							var param = {AC_CD : panelResult.getValue('MANAGE_CODE')};
							accntCommonService.fnGetAcCode(param, function(provider, response)	{
								var dataMap = provider;
								UniAccnt.changeFields(panelResult, dataMap, panelSearch);
								UniAccnt.changeFields(panelSearch, dataMap, panelResult);
								
								masterGrid.getColumn('PEND_CD').setText(provider.AC_NAME);
								masterGrid.getColumn('PEND_NAME').setText(provider.AC_NAME + '명');
							});
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('MANAGE_CODE', '');
						panelSearch.setValue('MANAGE_NAME', '');
						/**
						 * onClear시 removeField..
						 */
						UniAccnt.removeField(panelSearch, panelResult);
					},
					applyextparam: function(popup){							
						
					}
				}
			}),{
			  	xtype: 'container',
			  	colspan: 2,
			  	itemId: 'formFieldArea1', 
			  	layout: {
			   		type: 'table', 
			   		columns:2,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			 },
				Unilite.popup('ACCNT',{
		    	fieldLabel: '계정과목',
		    	valueFieldName: 'ACCNT_CODE_FR',
				textFieldName: 'ACCNT_NAME_FR',
				autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('ACCNT_CODE_FR', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('ACCNT_NAME_FR', newValue);				
					},
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                            	'ADD_QUERY' : " (GROUP_YN = 'N')",
                            	'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            	
                            }
                            popup.setExtParam(param);
                        }
                    }
				}
	    	}),   	
				Unilite.popup('ACCNT',{ 
					fieldLabel: '~',
					valueFieldName: 'ACCNT_CODE_TO',
					textFieldName: 'ACCNT_NAME_TO',
					autoPopup:true,
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('ACCNT_CODE_TO', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('ACCNT_NAME_TO', newValue);				
						},
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                		'ADD_QUERY' : " (GROUP_YN = 'N')",
                                		'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                                }
                                popup.setExtParam(param);
                            }
                        }
					}
			})]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('agb190skrGrid1', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore, 
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: true,			
			onLoadSelectFirst: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			},
			excel: {
				useExcel: true,			//엑셀 다운로드 사용 여부
				exportGroup : false, 		//group 상태로 export 여부
				onlyData:false,
				summaryExport:false
			}
		},
		enableColumnHide :false,
        sortableColumns : false,
		store: directMasterStore,
        tbar: [{
        	text:'관리항목별원장출력',
        	handler: function() {
					var params = {
						'FR_DATE'		: panelSearch.getValue('FR_DATE'),
						'TO_DATE'		: panelSearch.getValue('TO_DATE'),
						'ACCNT_DIV_CODE': panelSearch.getValue('ACCNT_DIV_CODE'),
						'MANAGE_CODE'	: panelSearch.getValue('MANAGE_CODE'),
						'MANAGE_NAME'	: panelSearch.getValue('MANAGE_NAME'),
						'DYNAMIC_CODE_FR'	: panelSearch.getValue('DYNAMIC_CODE_FR'),
						'DYNAMIC_NAME_FR'	: panelSearch.getValue('DYNAMIC_NAME_FR'),
						'DYNAMIC_CODE_TO'	: panelSearch.getValue('DYNAMIC_CODE_TO'),
						'DYNAMIC_NAME_TO'	: panelSearch.getValue('DYNAMIC_NAME_TO'),
						'ACCNT_CODE_FR'	: panelSearch.getValue('ACCNT_CODE_FR'),
						'ACCNT_NAME_FR'	: panelSearch.getValue('ACCNT_NAME_FR'),
						'ACCNT_CODE_TO'	: panelSearch.getValue('ACCNT_CODE_TO'),
						'ACCNT_NAME_TO'	: panelSearch.getValue('ACCNT_NAME_TO'),
						'START_DATE'	: panelSearch.getValue('START_DATE'),	
						'ACCOUNT_NAME'	: panelSearch.getValues().ACCOUNT_NAME
					}
				
        		//전송
          		var rec1 = {data : {prgID : 'agb190rkr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb190rkr.do', params);	
        	}
        }],			
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false,
    		enableGroupingMenu:false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false,
    		enableGroupingMenu:false 
    	}],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('GUBUN') == '1'){
					cls = 'x-change-cell_light';
				}
				else if(record.get('GUBUN') == '4') {
					cls = 'x-change-cell_normal';
				}
				else if(record.get('GUBUN') == '5') {
					cls = 'x-change-cell_dark';
				}
				return cls;
	        }
	    },
        columns: [        
        	{dataIndex: 'GUBUN'   		, width: 120 , hidden: true },
			{dataIndex: 'GUBUN1' 		, width: 93  , hidden: true },
        	{dataIndex: 'PEND_CD'   	, width: 120 },
			{dataIndex: 'PEND_NAME' 	, width: 300 },		
			{dataIndex: 'ACCNT'   		, width: 110 },			
			{dataIndex: 'ACCNT_NAME'	, width: 250 },			
			{dataIndex: 'AC_DATE'   	, width: 100 ,align : 'center'},	
			{dataIndex: 'SLIP_NUM'  	, width: 60  ,align : 'center'},		
			{dataIndex: 'SLIP_SEQ'  	, width: 60  ,align : 'center'},			
			{dataIndex: 'REMARK'   		, width: 300 },			
			{dataIndex: 'DR_AMT_I'		, width: 130 },		
			{dataIndex:	'CR_AMT_I'  	, width: 130 },
			{dataIndex:	'B_AMT_I' 		, width: 130 }
			//{dataIndex: 'JAN_DIVI'   	, width: 120 , hidden: true},			
			//{dataIndex: 'INPUT_DIVI'	, width: 120 , hidden: true},
			//{dataIndex:	'INPUT_PATH'  	, width: 120 , hidden: true},
			//{dataIndex:	'DIV_CODE' 		, width: 120 , hidden: true}
		],
		listeners: {
          	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
            	if (record.get('GUBUN') == '3') {
        			masterGrid.gotoAgb(record);
            	}
            }
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{     
        	if(record.get("GUBUN") == '3'){
	      		if(record.get('INPUT_PATH') == '2') {
					menu.down('#linkAgj200ukr').hide();
		      		menu.down('#linkDgj100ukr').hide();
		      		
					menu.down('#linkAgj205ukr').show();
				} else if(record.get('INPUT_PATH') == 'Z3') {
					menu.down('#linkAgj200ukr').hide();
		      		menu.down('#linkAgj205ukr').hide();
		      		
					menu.down('#linkDgj100ukr').show();
				} else {
					menu.down('#linkAgj205ukr').hide();
		      		menu.down('#linkDgj100ukr').hide();
		      		
					menu.down('#linkAgj200ukr').show();
				}
	      		return true;
        	}
      	},       
      	uniRowContextMenu:{
			items: [
	             {	text: '회계전표입력 이동',   
	            	itemId	: 'linkAgj200ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAgb(param.record);
	            	}
	        	},{	text: '회계전표입력(전표번호별) 이동',  
	            	itemId	: 'linkAgj205ukr', 
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAgb(param.record);
	            	}
	        	},{	text: 'Dgj100urk',  
	            	itemId	: 'linkDgj100ukr', 
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAgb(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAgb:function(record)	{
			if(record)	{
				
				var AcDate = record.data['AC_DATE'].substring(0, 4) + record.data['AC_DATE'].substring(5, 7) + record.data['AC_DATE'].substring(8, 10);
						
				var params = {

					action:'select',
					'PGM_ID'	 : 'agb190skr',
					'AC_DATE' 	 : AcDate,	   /* gsParam(0) */
					'AC_DATE' 	 : AcDate,	   /* gsParam(1) */	
					'INPUT_PATH' : record.data['INPUT_PATH'],  /* gsParam(2) */	
					'SLIP_NUM'   : record.data['SLIP_NUM'],	   /* gsParam(3) */	
					'SLIP_SEQ'   : record.data['SLIP_SEQ'],	   /* gsParam(4) */	
					//''   : record.data[''],/* gsParam(5) */	
					'DIV_CODE'   : record.data['DIV_CODE']	   /* gsParam(6) */	
				}
				if(record.data['INPUT_DIVI'] == '2'){	
					var rec = {data : {prgID : 'agj205ukr', 'text':''}};									
					parent.openTab(rec, '/accnt/agj205ukr.do', params);
				}
				else if(record.data['INPUT_PATH'] == 'Z3'){
					var rec = {data : {prgID : 'dgj100ukr', 'text':''}};									
					parent.openTab(rec, '/accnt/dgj100ukr.do', params);
				}
				else{
					var rec = {data : {prgID : 'agj200ukr', 'text':''}};									
					parent.openTab(rec, '/accnt/agj200ukr.do', params);
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
					masterGrid, panelResult
				]
			},
			panelSearch  	
		],
		id : 'agb190skrApp',
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
				
			panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
		},
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.isValidSearchForm()){
				return false;
			}else{
				directMasterStore.loadStoreRecords();	
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
		
		processParams: function(params) {
			this.uniOpt.appParams = params;
			
			if(params.PGM_ID == 'agb180skr') {
				panelSearch.setValue('FR_DATE',params.FR_DATE);
				panelSearch.setValue('TO_DATE',params.TO_DATE);
				
				panelResult.setValue('FR_DATE',params.FR_DATE);
				panelResult.setValue('TO_DATE',params.TO_DATE);
				
				panelSearch.setValue('START_DATE',params.START_DATE);
				
				panelSearch.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelResult.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				
				panelSearch.setValue('MANAGE_CODE',params.MANAGE_CODE);
				panelSearch.setValue('MANAGE_NAME',params.MANAGE_NAME);
				
				panelResult.setValue('MANAGE_CODE',params.MANAGE_CODE);
				panelResult.setValue('MANAGE_NAME',params.MANAGE_NAME);

				var param = {AC_CD : panelSearch.getValue('MANAGE_CODE')};
				accntCommonService.fnGetAcCode(param, function(provider, response)	{
					var dataMap = provider;
					UniAccnt.changeFields(panelSearch, dataMap, panelResult);
					UniAccnt.changeFields(panelResult, dataMap, panelSearch);
					
					masterGrid.getColumn('PEND_CD').setText(provider.AC_NAME);
					masterGrid.getColumn('PEND_NAME').setText(provider.AC_NAME + '명');
					
					panelSearch.setValue('DYNAMIC_CODE_FR',params.PEND_CD);
					panelSearch.setValue('DYNAMIC_NAME_FR',params.PEND_NAME);
					panelSearch.setValue('DYNAMIC_CODE_TO',params.PEND_CD);
					panelSearch.setValue('DYNAMIC_NAME_TO',params.PEND_NAME);
					
					panelResult.setValue('DYNAMIC_CODE_FR',params.PEND_CD);
					panelResult.setValue('DYNAMIC_NAME_FR',params.PEND_NAME);
					panelResult.setValue('DYNAMIC_CODE_TO',params.PEND_CD);
					panelResult.setValue('DYNAMIC_NAME_TO',params.PEND_NAME);
					
					panelSearch.setValue('ACCNT_CODE_FR',params.ACCNT_CODE);
					panelSearch.setValue('ACCNT_NAME_FR',params.ACCNT_NAME);
					panelSearch.setValue('ACCNT_CODE_TO',params.ACCNT_CODE);
					panelSearch.setValue('ACCNT_NAME_TO',params.ACCNT_NAME);
					
					panelSearch.setValue('DEPT_CODE_FR',params.DEPT_CODE_FR);
					panelSearch.setValue('DEPT_NAME_FR',params.DEPT_NAME_FR);
					panelSearch.setValue('DEPT_CODE_TO',params.DEPT_CODE_TO);
					panelSearch.setValue('DEPT_NAME_TO',params.DEPT_NAME_TO);

					panelResult.setValue('ACCNT_CODE_FR',params.ACCNT_CODE);
					panelResult.setValue('ACCNT_NAME_FR',params.ACCNT_NAME);
					panelResult.setValue('ACCNT_CODE_TO',params.ACCNT_CODE);
					panelResult.setValue('ACCNT_NAME_TO',params.ACCNT_NAME);
					
					panelSearch.getField('ACCOUNT_NAME').setValue(params.ACCOUNT_NAME);
					
					
					masterGrid.getStore().loadStoreRecords();
					
				});
			}
		},
		
		fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
        }
	});
};


</script>
