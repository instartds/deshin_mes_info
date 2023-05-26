<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="abh900skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('abh900skrModel', {		
	    fields: [
	    	
	    	{name: 'VIR_ACCTNO'       ,text: '가상계좌번호'         ,type: 'string'},   	
	    	{name: 'INOUT_DATE'       ,text: '거래일자' 			,type: 'uniDate'},
	    	{name: 'INOUT_TIME'       ,text: '거래시간'            ,type: 'string'},
			{name: 'CUSTOM_CODE'      ,text: Msg.sMAW170 		,type: 'string'},			 	 	
			{name: 'CUSTOM_NAME'      ,text: Msg.sMAW258 		,type: 'string'},			 	 	
			{name: 'COMPANY_NUM'      ,text: Msg.fSbMsgA0113 	,type: 'string'},		
            {name: 'MONEY_UNIT'       ,text: '화폐단위'            ,type: 'string'},
			{name: 'IN_AMT_I'         ,text: '거래금액' 			,type: 'uniPrice'},		
			{name: 'INCOME_NAME'      ,text: '입금처명'            ,type: 'string'},  
            {name: 'BANK_CODE'        ,text: '은행코드'            ,type: 'string'},
            {name: 'BANK_NAME'        ,text: '은행명'             ,type: 'string'}
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('abh900skrMasterStore',{
		model: 'abh900skrModel',
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
            	   read: 'abh900skrService.selectList'                	
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
		        startFieldName: 'INOUT_DATE_FR',
		        endFieldName: 'INOUT_DATE_TO',
		        startDate	: UniDate.get('today'),
		        endDate		: UniDate.get('today'),
		        allowBlank	: false,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('INOUT_DATE_FR', newValue);						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('INOUT_DATE_TO', newValue);			    		
			    	}
			    }
	        },
			Unilite.popup('CUST',{ 
		    	fieldLabel	: '거래처', 
		    	popupWidth	: 710,
				autoPopup   : false ,
		    	valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				extParam	: {'CUSTOM_TYPE': ['1','2','3']},
		    	listeners	: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}/*,
	    			onTextSpecialKey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	UniAppManager.app.onQueryButtonDown();  
	                	}
	                }*/
				}
			}), {
		    	xtype		: 'uniTextfield',
		    	fieldLabel	: '가상계좌번호',
		    	name		: 'VIR_ACCTNO',
		 		listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('VIR_ACCTNO', newValue);
					}
				}
		    }]
		}]
	});	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel	: '거래일자',
	        xtype		: 'uniDateRangefield',
	        startFieldName: 'INOUT_DATE_FR',
	        endFieldName: 'INOUT_DATE_TO',
	        startDate	: UniDate.get('today'),
	        endDate		: UniDate.get('today'),
	        allowBlank	: false,                	
	        tdAttrs: {width: 380},  
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_FR', newValue);							
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('INOUT_DATE_TO', newValue);			    		
		    	}
		    }
        },   	
		Unilite.popup('CUST',{ 
	    	fieldLabel	: '거래처', 
	    	popupWidth	: 710,
			autoPopup   : false ,
	    	valueFieldName: 'CUSTOM_CODE',
			textFieldName: 'CUSTOM_NAME',
			extParam	: {'CUSTOM_TYPE': ['1','2','3']},
	    	listeners	: {				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}/*,
    			onTextSpecialKey: function(elm, e){
                    if (e.getKey() == e.ENTER) {
                    	UniAppManager.app.onQueryButtonDown();  
                	}
                }*/
			}
		}), {
	    	xtype		: 'uniTextfield',
	    	fieldLabel	: '가상계좌번호',
	    	name		: 'VIR_ACCTNO',
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('VIR_ACCTNO', newValue);
				}
			}
	    }]	
    }); 
    
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('abh900skrGrid', {
    	// for tab    	
        layout	: 'fit',
        region	: 'center',
    	store	: masterStore,
		uniOpt : {					
			useMultipleSorting	: true,		
		    useLiveSearch		: true,		
		    onLoadSelectFirst	: false,			
		    dblClickToEdit		: false,		
		    useGroupSummary		: false,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
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
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [ 
        	{ dataIndex: 'VIR_ACCTNO' ,        width: 120 ,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', Msg.sMAP025);
                }
            },
            { dataIndex: 'INOUT_DATE' ,        width: 100 },
            { dataIndex: 'INOUT_TIME' ,        width: 100 },
            { dataIndex: 'CUSTOM_CODE',        width: 100 },
            { dataIndex: 'CUSTOM_NAME',        width: 120 },
            { dataIndex: 'COMPANY_NUM',        width: 130 },
            { dataIndex: 'MONEY_UNIT' ,        width: 80 },
            { dataIndex: 'IN_AMT_I'   ,        width: 100, summaryType: 'sum'},
            { dataIndex: 'INCOME_NAME',        width: 100 },
            { dataIndex: 'BANK_CODE'  ,        width: 100 },
            { dataIndex: 'BANK_NAME'  ,        width: 100 }
        ]  
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
		id  : 'abh900skrApp',
		
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			//초기화 시 합계 행 안 보이게 설정
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);

			//초기화 시 거래일자로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('INOUT_DATE_FR');

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
