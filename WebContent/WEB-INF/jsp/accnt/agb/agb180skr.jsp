<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb180skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->        
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	var getStDt = ${getStDt};			/* 당기시작년월 */
    var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
	var sPendCode  = ''; /* 레포트용 */
	var sPendName  = ''; /* 레포트용 */
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb180skrModel', {
	    fields: [  	  
	    	{name: 'GRP'				, text: '' 			,type: 'string'},
		    {name: 'PEND_CD'			, text: '관리항목명칭코드',type: 'string'},
		    {name: 'PEND_NAME'			, text: '관리항목명칭' 	,type: 'string'},
		    {name: 'ACCNT'   			, text: '계정코드' 	,type: 'string'},
		    {name: 'ACCNT_NAME' 		, text: '계정과목명' 	,type: 'string'},
		    {name: 'BUSI_AMT'   		, text: '거래합계' 	,type: 'uniPrice'},
		    {name: 'WAL_AMT_I'  		, text: '이월금액' 	,type: 'uniPrice'},
		    {name: 'DR_AMT_I'			, text: '차변금액' 	,type: 'uniPrice'},
		    {name: 'CR_AMT_I'  			, text: '대변금액' 	,type: 'uniPrice'},
		    {name: 'JAN_AMT_I'  		, text: '잔액' 		,type: 'uniPrice'}
		   
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
	var directMasterStore = Unilite.createStore('agb180skrMasterStore1',{
		model: 'Agb180skrModel',
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
                read: 'agb180skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		/*groupField: 'PEND_CD'*/
		
		listeners: {
          	load: function(store, records, successful, eOpts) {
				//조회된 데이터가 있을 때, 그리드에 포커스 가도록 변경
				if(store.getCount() > 0){
		    		masterGrid.focus();
				//조회된 데이터가 없을 때, 패널의 첫번째 필드에 포커스 가도록 변경
	    		}else{
					var activeSForm ;		
					if(!UserInfo.appOption.collapseLeftSearch)	{	
						activeSForm = panelSearch;	
					}else {		
						activeSForm = panelResult;	
					}		
					activeSForm.onLoadSelectText('FR_DATE');	
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
								
								sPendCode  = provider.AC_NAME; 
								sPendName  = provider.AC_NAME + '명'; 
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
			 },{
				xtype: 'radiogroup',		            		
				fieldLabel: '거래합계',
				id:'printKind',
				items: [{
					boxLabel: '미출력', 
					width: 70, 
					name: 'SUM',
					inputValue: '1',
					checked: true  
				},{
					boxLabel : '출력', 
					width: 70,
					name: 'SUM',
					inputValue: '2'
				}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('SUM').setValue(newValue.SUM);
							
							if(!UniAppManager.app.isValidSearchForm()){
								return false;
							}else{
								if(newValue.SUM == '1' ){
									masterGrid.getColumn('BUSI_AMT').setVisible(false);
									masterGrid.reset();
									UniAppManager.app.onQueryButtonDown();
								}else if(newValue.SUM == '2' ){
									masterGrid.getColumn('BUSI_AMT').setVisible(true);
									masterGrid.reset();
									UniAppManager.app.onQueryButtonDown();
								}					
							}		
						}
					}
				},
				Unilite.popup('ACCNT',{ 
			    	fieldLabel: '계정과목', 
			    	valueFieldName: 'ACCNT_CODE_FR',
					textFieldName: 'ACCNT_NAME_FR',
					autoPopup:false,
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
					autoPopup:false,
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
		},{
    		xtype: 'uniCheckboxgroup',		            		
    		fieldLabel: '출력조건',
    		items: [{
    			boxLabel: '관리항목명칭별 페이지 처리',
    			width: 150,
    			name: 'CHECK',
    			inputValue: 'A',
    			uncheckedValue: 'B'
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
								
								sPendCode  = provider.AC_NAME; 
								sPendName  = provider.AC_NAME + '명'; 
								
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
				xtype: 'radiogroup',		            		
				fieldLabel: '거래합계',
				items: [{
					boxLabel: '미출력', 
					width: 70, 
					name: 'SUM',
					inputValue: '1',
					checked: true  
				},{
					boxLabel : '출력', 
					width: 70,
					name: 'SUM',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {		
						panelSearch.getField('SUM').setValue(newValue.SUM);
						
						if(!UniAppManager.app.isValidSearchForm()){
							return false;
						}else{
							if(newValue.SUM == '1' ){
								masterGrid.getColumn('BUSI_AMT').setVisible(false);
								masterGrid.reset();
								UniAppManager.app.onQueryButtonDown();
							}else if(newValue.SUM == '2' ){
								masterGrid.getColumn('BUSI_AMT').setVisible(true);
								masterGrid.reset();
								UniAppManager.app.onQueryButtonDown();
							}			
						}	
					}
				}
			},{
			  	xtype: 'container',
			  	colspan: 3,
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
				autoPopup:false,
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
					autoPopup:false,
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
    
    var masterGrid = Unilite.createGrid('agb180skrGrid1', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore,
        selModel : 'rowmodel',
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: true,			
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}	
		},
        tbar: [{
        	text:'관리항목별집계표출력',
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
						'SUM'			: panelSearch.getValues().SUM,
						'ACCOUNT_NAME'	: panelSearch.getValues().ACCOUNT_NAME,
						'CHECK'	: panelSearch.getValues().CHECK
					}
				
        		//전송
          		var rec1 = {data : {prgID : 'agb180rkr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb180rkr.do', params);	
        	}
        }],			
		store: directMasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: true
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: true
    	}],
        columns: [        
        	//{dataIndex: 'GRP'			, width: 50	 , hidden:true}, 				
			{dataIndex: 'PEND_CD'		, width: 120 }, 				
			{dataIndex: 'PEND_NAME'		, width: 300 
			,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},				
			{dataIndex: 'ACCNT'   		, width: 110 }, 				
			{dataIndex: 'ACCNT_NAME'	, width: 250 }, 
			{dataIndex: 'WAL_AMT_I' 	, width: 130 , summaryType: 'sum' }, 	
			{dataIndex: 'BUSI_AMT'   	, width: 130 , summaryType: 'sum' },
			{dataIndex: 'DR_AMT_I'		, width: 130 , summaryType: 'sum' }, 				
			{dataIndex: 'CR_AMT_I'  	, width: 130 , summaryType: 'sum' }, 				
			{dataIndex: 'JAN_AMT_I' 	, width: 130 , summaryType: 'sum' }			
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	if(record.get('DR_AMT_I') != '0') {
	        		view.ownerGrid.setCellPointer(view, item);
	        	} else if(record.get('CR_AMT_I') != '0') {
	        		view.ownerGrid.setCellPointer(view, item);
	        	}
        	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
				masterGrid.gotoAgb180skr(record);
            }
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
      		return true;
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '관리항목별원장 보기',   
	                itemId:'agbItem',
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAgb180skr(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAgb180skr:function(record)	{
			if(record)	{
		    	var params = {
		    		action:'select',
			    	'PGM_ID' 			: 'agb180skr',
			    	'FR_DATE' 			:  panelSearch.getValue('FR_DATE'),								/* gsParam(0) */
			    	'TO_DATE' 			:  panelSearch.getValue('TO_DATE'),								/* gsParam(1) */
			    	'ACCNT_DIV_CODE' 	:  panelSearch.getValue('ACCNT_DIV_CODE'),						/* gsParam(2) */
			    	
			    	'MANAGE_CODE'		:  panelSearch.getValue('MANAGE_CODE'),  						/* gsParam(7) */
			    	'MANAGE_NAME'		:  panelSearch.getValue('MANAGE_NAME'), 						/* gsParam(8) */	
			    	'PEND_CD'			:  record.data['PEND_CD'],  									/* gsParam(11) */
			    	'PEND_NAME'			:  record.data['PEND_NAME'],	  	 							/* gsParam(12) */		
			    	
			    	'ACCNT_CODE' 		:  record.data['ACCNT'],										/* gsParam(13) */	
			    	'ACCNT_NAME' 		:  record.data['ACCNT_NAME'],									/* gsParam(14) */
			    		
			    	'START_DATE' 		:  panelSearch.getValue('START_DATE'),							/* gsParam(15) */
			    	'ACCOUNT_NAME'		:  Ext.getCmp('accountNameSe').getChecked()[0].inputValue		/* gsParam(16) */
		    	}
		    	var rec1 = {data : {prgID : 'agb190skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb190skr.do', params);	    	
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
		id : 'agb180skrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			
			masterGrid.getColumn('BUSI_AMT').hidden = true;
			
			
			panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
			
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
			
		},
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.isValidSearchForm()){
				return false;
			}else{
				directMasterStore.loadStoreRecords();	
				var viewNormal = masterGrid.getView();
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
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
		onPrintButtonDown: function() {
//	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
//	         var params = Ext.getCmp('searchForm').getValues();
//	         var record      = masterGrid.getSelectedRecord();
//			 var divName     = '';
//	         var prgId       = '';
//	         var outputType  = '';
//			 
//			 if(panelSearch.getValue('ACCNT_DIV_CODE') == '' || panelSearch.getValue('ACCNT_DIV_CODE') == null ){
//			 	divName = Msg.sMAW002;  // 전체
//			 }else{
//			 	divName = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
//			 }
//			 
//			 //
//			 if(Ext.getCmp('printKind').getChecked()[0].inputValue  == '1'){
//			 	prgId      = 'agb180rkr'; 	// 거래합계 미출력
//			 	outputType = 'N';
//			 }else{
//			 	prgId      = 'agb181rkr';    // 거래합계 출력
//			 	outputType = 'Y';
//			 }
//		         
//	         var win = Ext.create('widget.PDFPrintWindow', {
//	            url: CPATH+'/accnt/agb180rkrPrint.do',
//	            prgID: prgId,
//	               extParam: {
//	                  COMP_CODE		 		: UserInfo.compCode,
//	                  FR_DATE  				: params.FR_DATE,			/* 전표일 FR */
//	                  TO_DATE				: params.TO_DATE,			/* 전표일 TO */
//	                  ACCNT_DIV_CODE		: params.ACCNT_DIV_CODE,	/* 사업장 CODE*/
//	                  ACCNT_DIV_NAME		: divName,					/* 사업장 NAME */
//	                  
//	                  MANAGE_CODE			: params.MANAGE_CODE,		/* 관리항목*/   
//	                  DYNAMIC_CODE_FR		: params.DYNAMIC_CODE_FR,	/*관리항목 팝업을 작동했을때의 동적 필드*/
//	                  DYNAMIC_CODE_TO       : params.DYNAMIC_CODE_TO,
//	                  
//	                  ACCNT_CODE_FR			: params.ACCNT_CODE_FR,		/* 계정과목 FR */
//	                  ACCNT_NAME_FR			: params.ACCNT_NAME_FR,
//	                  ACCNT_CODE_TO			: params.ACCNT_CODE_TO,		/* 계정과목 TO */
//	                  ACCNT_NAME_TO			: params.ACCNT_NAME_TO,
//	                  	
//	                  START_DATE			: params.START_DATE,
//	                  
//	                  ACCOUNT_NAME			: params.ACCOUNT_NAME,		/* 과목명 */
//	                  SUM					: params.SUM,				/* 거래합계 */
//	                  OUTPUT_TYPE			: outputType,
//	                  
//	                  S_PEND_CODE			: sPendCode,
//	                  S_PEND_NAME			: sPendName,
//	                  
//	                  
//	                  CHECK					: params.CHECK
//	               	}
//	            });
//	            win.center();
//	            win.show();     
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
