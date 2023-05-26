<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="abh300skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A103" /> <!-- 입출금 구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="A023" /> <!--결의회계구분-->	     
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('abh300skrModel', {		
	    fields: [{name: 'CUSTOM_CODE'	, text: Msg.sMAW116  		, type: 'string'},			 	 	
				 {name: 'CUSTOM_NAME'	, text: Msg.sMAP022			, type: 'string'},	
				 {name: 'SAVE_CODE'     , text: '통장코드'             , type: 'string'},
                 {name: 'SAVE_NAME'     , text: '통장명'              , type: 'string'},
				 {name: 'ACCT_NO'		, text: Msg.sMAW236 		, type: 'string'},
				 {name: 'ACCT_NO_EXPOS' , text: '계좌번호'		 	,type: 'string', allowBlank: false, defaultValue:'***************'},
				 {name: 'INOUT_DATE'	, text: Msg.fSbMsgA0356 	, type: 'string'},			 	 	
				 {name: 'TX_AMT_CH'		, text: Msg.sMAW501 		, type: 'uniPrice'},			 	 	
				 {name: 'TX_AMT_DH'		, text: Msg.sMAW502			, type: 'uniPrice'},			 	 	
				 {name: 'JAN_AMT_I'		, text: Msg.sMAW049 		, type: 'uniPrice'},				//잔액은 필요없음->다시 필요함		 	 	
				 {name: 'CURR_UNIT'		, text: Msg.sMAW771 		, type: 'string'},			 	 	
				 {name: 'REMARK'		, text: Msg.sMAW179 		, type: 'string'}			 	 	
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('abh300skrMasterStore',{
		model: 'abh300skrModel',
		uniOpt : {
        	isMaster	: false,			// 상위 버튼 연결 
        	editable	: false,			// 수정 모드 사용 
        	deletable	: false,			// 삭제 가능 여부 
            useNavi 	: false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
            	   read: 'abh300skrService.selectList'                	
            }
        },
        
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
          	load: function(store, records, successful, eOpts) {

				//조회된 데이터가 있을 때, 합계 보이게 설정 변경
				var viewNormal = masterGrid.getView();
				if(store.getCount() > 0){
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				
				}else{
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
		    		alert (Msg.sMB015)
				}
				
			}          		
      	}			
	});
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */ 
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title		: '검색조건',         
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{     
			title	: '기본정보',   
			itemId	: 'search_panel1',
			layout	: {type: 'uniTable', columns: 1},
	    	items	: [{ 
    			fieldLabel	: '거래일자',
		        xtype		: 'uniDateRangefield',
		        startFieldName: 'AC_DATE_FR',
		        endFieldName: 'AC_DATE_TO',
		        startDate	: UniDate.get('today'),
		        endDate		: UniDate.get('today'),
		        allowBlank	: false,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('AC_DATE_FR', newValue);						
//						panelResult.setValue('AC_DATE_TO', newValue);						
                	}
//			    	if(panelSearch) {
//						panelSearch.setValue('AC_DATE_TO',newValue);
//			    	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('AC_DATE_TO', newValue);			    		
			    	}
			    }
	        },{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox',
		        multiSelect	: true, 
		        typeAhead	: false,
		        // value:UserInfo.divCode,
		        comboType	: 'BOR120',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('BANK',{ 
			    fieldLabel	: '은행', 
			    valueFieldName: 'BANK_CODE',
				textFieldName: 'BANK_NAME',
				listeners	: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('BANK_CODE', panelSearch.getValue('BANK_CODE'));
							panelResult.setValue('BANK_NAME', panelSearch.getValue('BANK_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('BANK_CODE', '');
						panelResult.setValue('BANK_NAME', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('BANK_BOOK',{ 
			    fieldLabel	: '통장',
			    valueFieldName: 'SAVE_CODE',
				textFieldName: 'SAVE_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('SAVE_CODE', panelSearch.getValue('SAVE_CODE'));
							panelResult.setValue('SAVE_NAME', panelSearch.getValue('SAVE_NAME'));	
							panelSearch.setValue('BANK_CODE', records[0].BANK_CD);
							panelSearch.setValue('BANK_NAME', records[0].BANK_NM);		 	
							panelResult.setValue('BANK_CODE', records[0].BANK_CD);
							panelResult.setValue('BANK_NAME', records[0].BANK_NM);	
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('SAVE_CODE', '');
						panelResult.setValue('SAVE_NAME', '');
//						panelSearch.setValue('BANK_CODE', '');
//						panelSearch.setValue('BANK_NAME', '');	
//						panelResult.setValue('BANK_CODE', '');
//						panelResult.setValue('BANK_NAME', '');		
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}	   
			}), {
		    	xtype		: 'uniTextfield',
		    	fieldLabel	: '적요',
		    	name		: 'REMARK',
	    		width		: 325,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('REMARK', newValue);
					}
				}
		    },{
		 		fieldLabel	: '화폐',
		 		name		: 'MONEY_UNIT', 
		 		xtype		: 'uniCombobox',
		 		comboType	: 'AU',
		 		comboCode	: 'B004',
		 		displayField: 'value',
		 		listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MONEY_UNIT', newValue);
					}
				}
	 		},{
		 		fieldLabel	: '입출구분',
		 		name		: 'INOUT_GB', 
		 		xtype		: 'uniCombobox',
		 		comboType	: 'AU',
		 		comboCode	: 'A103',
		 		listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('INOUT_GB', newValue);
					}
				}
	 		}, {               
                //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                name:'DEC_FLAG',
                xtype: 'uniTextfield',
                hidden: true
            }]
		}]
	});	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs	: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{ 
			fieldLabel	: '거래일자',
	        xtype		: 'uniDateRangefield',
	        startFieldName: 'AC_DATE_FR',
	        endFieldName: 'AC_DATE_TO',
	        startDate	: UniDate.get('today'),
	        endDate		: UniDate.get('today'),
	        allowBlank	: false,                	
	        tdAttrs		: {width: 380},  
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('AC_DATE_FR', newValue);						
//					panelSearch.setValue('AC_DATE_TO', newValue);						
            	}
//		    	if(panelResult) {
//					panelResult.setValue('AC_DATE_TO',newValue);
//		    	}

		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('AC_DATE_TO', newValue);			    		
		    	}
		    }
        },{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE', 
			xtype		: 'uniCombobox',
	        multiSelect	: true, 
	        typeAhead	: false,
	        // value:UserInfo.divCode,
	        comboType	: 'BOR120',
	        colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('BANK',{ 
		    fieldLabel	: '은행', 
		    valueFieldName: 'BANK_CODE',
			textFieldName: 'BANK_NAME',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('BANK_CODE', panelResult.getValue('BANK_CODE'));
						panelSearch.setValue('BANK_NAME', panelResult.getValue('BANK_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('BANK_CODE', '');
					panelSearch.setValue('BANK_NAME', '');
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('BANK_BOOK',{ 
		    fieldLabel	: '통장', 
		    valueFieldName: 'SAVE_CODE',
			textFieldName: 'SAVE_NAME',
			colspan		: 2,
			listeners	: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('SAVE_CODE', panelResult.getValue('SAVE_CODE'));
						panelSearch.setValue('SAVE_NAME', panelResult.getValue('SAVE_NAME'));	
						panelResult.setValue('BANK_CODE', records[0].BANK_CD);
						panelResult.setValue('BANK_NAME', records[0].BANK_NM);	
						panelSearch.setValue('BANK_CODE', records[0].BANK_CD);
						panelSearch.setValue('BANK_NAME', records[0].BANK_NM);		 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('SAVE_CODE', '');
					panelSearch.setValue('SAVE_NAME', '');
//					panelResult.setValue('BANK_CODE', '');
//					panelResult.setValue('BANK_NAME', '');	
//					panelSearch.setValue('BANK_CODE', '');
//					panelSearch.setValue('BANK_NAME', '');	
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}	   
		}),{
	    	xtype		: 'uniTextfield',
	    	fieldLabel	: '적요',
	    	name		: 'REMARK',
	    	width		: 325,
	 		listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('REMARK', newValue);
				}
			}
	    },{
	 		fieldLabel	: '화폐',
	 		name		: 'MONEY_UNIT', 
	 		xtype		: 'uniCombobox',
	 		comboType	: 'AU',
	 		comboCode	: 'B004', 
	 		displayField: 'value',
	 		listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('MONEY_UNIT', newValue);
				}
			}
	    },{
	 		fieldLabel	: '입출구분',
	 		name		: 'INOUT_GB', 
	 		xtype		: 'uniCombobox',
	 		comboType	: 'AU',
	 		comboCode	: 'A103',
	 		listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('INOUT_GB', newValue);
				}
			}
	    }]	
    }); 
    
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('abh300skrGrid', {
    	// for tab    	
        layout	: 'fit',
        region	: 'center',
    	store	: masterStore,
		uniOpt	: {					
			useMultipleSorting	: true,		
		    useLiveSearch		: true,		
		    onLoadSelectFirst	: false,			
		    dblClickToEdit		: false,		
		    useGroupSummary		: false,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
			useRowContext		: false,	
		    filter: {				
				useFilter		: true,
				autoCreate		: true
			}			
		},				
//        tbar: [{
//        	text:'상세보기',
//        	handler: function() {
//        		var record = masterGrid.getSelectedRecord();
//	        	if(record) {
//	        		openDetailWindow(record);
//	        	}
//        	}
//        }],
		tbar: [
        
        ],
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [ { dataIndex: 'CUSTOM_CODE'	, width: 80			, hidden: true },
					{ dataIndex: 'CUSTOM_NAME'	, width: 120 },
					{ dataIndex: 'SAVE_CODE' , width: 120 },
					{ dataIndex: 'SAVE_NAME' , width: 200 },
					{ dataIndex: 'ACCT_NO'		, width: 120 , 	hidden: true
/*						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						       return Unilite.renderSummaryRow(summaryData, metaData, '소계', Msg.sMAP025);
				    	}*/
			   		},
			   		{ dataIndex: 'ACCT_NO_EXPOS'		, width: 120 ,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						       return Unilite.renderSummaryRow(summaryData, metaData, '소계', Msg.sMAP025);
				    	}
			   		},			   		
					{ dataIndex: 'INOUT_DATE'	, width: 100 },
					{ dataIndex: 'TX_AMT_CH'	, width: 130		, summaryType: 'sum' },
					{ dataIndex: 'TX_AMT_DH'	, width: 130		, summaryType: 'sum' },
					{ dataIndex: 'JAN_AMT_I'	, width: 130 },
					{ dataIndex: 'CURR_UNIT'	, width: 80 },
					{ dataIndex: 'REMARK'		, flex: 1			, minWidth: 200 }
        ] ,
		listeners:{
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="ACCT_NO_EXPOS") {
					grid.ownerGrid.openCryptPopup(record);
				}
			}			
		},
		openCryptPopup:function( record )	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('ACCT_NO'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'ACCT_NO_EXPOS', 'ACCT_NO', params);
			}
				
		}        
    });   	
    
    var decrypBtn = Ext.create('Ext.Button',{
        text:'복호화',
        width: 80,
        handler: function() {
            var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
            if(needSave){
               alert(Msg.sMB154); //먼저 저장하십시오.
               return false;
            }
            panelSearch.setValue('DEC_FLAG', 'Y');
            UniAppManager.app.onQueryButtonDown();
            panelSearch.setValue('DEC_FLAG', '');
        }
    });
    
    Unilite.Main( {
		borderItems:[{
			region	:'center',
			layout	: 'border',
			border	: false,
			items	:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id  : 'abh300skrApp',
		
		fnInitBinding : function() {
			if((Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE == ''){					//회계담당자가 없을 경우 알림 메세지
				Ext.Msg.alert('확인',Msg.sMA0054);
			}
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			//초기화 시 합계 행 안 보이게 설정
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
            
			var tbar = masterGrid._getToolBar();
            tbar[0].insert(tbar.length + 1, decrypBtn);
            
			//초기화 시 거래일자로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE_FR');

		},
		
		onQueryButtonDown : function()	{			
			if(!this.isValidSearchForm()){
				return false;
			}
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			masterGrid.getStore().loadStoreRecords();
		}
	});
};


</script>
