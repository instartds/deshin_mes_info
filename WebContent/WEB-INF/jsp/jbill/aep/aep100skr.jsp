<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep100skr"  >
    <t:ExtComboStore comboType="AU" comboCode="J647" />         <!-- 유형 -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {

	var directProxyReceipt = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'aep100skrService.insertReceiptDetail',
            syncAll: 'aep100skrService.saveReceiptAll'
        }
    }); 
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('aep100skrModel', {
		fields: [
		    {name: 'RNUM'                   , text: '순번'          , type: 'string'},
		    {name: 'COST_CENTER'            , text: '귀속부서코드'    , type: 'string'},
		    {name: 'COST_CENTER_NM'         , text: '귀속부서명'      , type: 'string'},
		    {name: 'ACCT_CD'                , text: '계정코드'       , type: 'string'},
		    {name: 'ACCT_NM'                , text: '계정명'        , type: 'string'},
		    {name: 'ACCT_AMT'               , text: '집행금액계'     , type: 'uniPrice'},
		    {name: 'CARD_ACCT_AMT'          , text: '법인카드사용금액' , type: 'uniPrice'},
		    {name: 'EES_ACCT_AMT'           , text: '실물증빙사용금액'  , type: 'uniPrice'},
		    {name: 'TAX_ACCT_AMT'           , text: '세금계산사용금액'  , type: 'uniPrice'},
		    {name: 'WTS_ACCT_AMT'           , text: '원천세사용금액'   , type: 'uniPrice'}
		]	});
	
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
    var directDetailStore = Unilite.createStore('aep100skrDetailStore',{
        model: 'aep100skrModel',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {          
                read: 'aep100skrService.selectList'                  
            }
        },
        loadStoreRecords : function()	{
        	var param= Ext.getCmp('searchForm').getValues();			
        	console.log( param );
        	this.load({
        		params : param
        	});
        }
   });
   
    var receiptButtonStore = Unilite.createStore('ButtonStore',{     
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxyReceipt,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            var paramMaster = panelResult.getValues();  //syncAll 수정
//          param.FR_INPUT_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        
                        UniAppManager.app.onQueryButtonDown();
                     },
                     failure: function(batch, option) {
                     
                        
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('aep100skrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
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
			items: [{ 
    			fieldLabel: '회계년월',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'stGlYm',
		        endFieldName: 'endGlYm',
		        startDate: UniDate.get('startOfMonth'),
        		endDate: UniDate.get('today'),
				allowBlank: false,		        
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('stGlYm',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('endGlYm',newValue);
			    	}
			    }
	        },
            Unilite.popup('DEPT',{
                fieldLabel: '발생부서',
                valueFieldName:'makeCostCenter',
                textFieldName:'makeCostCenterDesc',
                validateBlank:false,
                autoPopup:true,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {                                                                                               
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    },
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('makeCostCenter', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('makeCostCenterDesc', newValue);             
                    }
                }
            }),
            Unilite.popup('DEPT',{
                fieldLabel: '귀속부서',
                valueFieldName:'kostlCode',
                textFieldName:'kostlNm',
                validateBlank:false,
                autoPopup:true,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {                                                                                               
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    },
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('kostlCode', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('kostlNm', newValue);             
                    }
                }
            }),
			Unilite.popup('Employee',{
				fieldLabel: '사용자',
			  	valueFieldName:'useId',
			    textFieldName:'useNm',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {				 																							
						},
						scope: this
					},
					onClear: function(type)	{
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('useId', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('useNm', newValue);				
					}
				}
			})
		]}]     	
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
    	items: [{ 
            fieldLabel: '회계년월',
            xtype: 'uniDateRangefield',
            startFieldName: 'stGlYm',
            endFieldName: 'endGlYm',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            allowBlank: false,              
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('stGlYm',newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('endGlYm',newValue);
                }
            }
        },
        Unilite.popup('DEPT',{
            fieldLabel: '발생부서',
            valueFieldName:'makeCostCenter',
            textFieldName:'makeCostCenterDesc',
            validateBlank:false,
            autoPopup:true,
            listeners: {
                onSelected: {
                    fn: function(records, type) {                                                                                               
                    },
                    scope: this
                },
                onClear: function(type) {
                },
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('makeCostCenter', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('makeCostCenterDesc', newValue);             
                }
            }
        }),
        Unilite.popup('DEPT',{
            fieldLabel: '귀속부서',
            valueFieldName:'kostlCode',
            textFieldName:'kostlNm',
            validateBlank:false,
            autoPopup:true,
            listeners: {
                onSelected: {
                    fn: function(records, type) {                                                                                               
                    },
                    scope: this
                },
                onClear: function(type) {
                },
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('kostlCode', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('kostlNm', newValue);             
                }
            }
        }),
        Unilite.popup('Employee',{
            fieldLabel: '사용자',
            valueFieldName:'useId',
            textFieldName:'useNm',
            validateBlank:false,
            autoPopup:true,
            listeners: {
                onSelected: {
                    fn: function(records, type) {                                                                                                           
                    },
                    scope: this
                },
                onClear: function(type) {
                },
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('useId', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('useNm', newValue);                
                }
            }
        })]
    });
   
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var detailGrid = Unilite.createGrid('aep100skrGrid', {
        region: 'center',
        layout: 'fit',
    	uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			onLoadSelectFirst: false,
			useRowNumberer: false,
			expandLastColumn: false,
			useRowContext: true,
    		state: {
				useState: true,			
				useStateList: true		
			}
        },
		features: [{
			id: 'detailGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false						
		},{
			id: 'detailGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		store: directDetailStore,
        columns: [
            {dataIndex: 'RNUM'                   ,            width: 120},
            {dataIndex: 'COST_CENTER'            ,            width: 120},
            {dataIndex: 'COST_CENTER_NM'         ,            width: 120},
            {dataIndex: 'ACCT_CD'                ,            width: 120,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
                }
            },
            {dataIndex: 'ACCT_NM'                ,            width: 120},
            {dataIndex: 'ACCT_AMT'               ,            width: 120, summaryType: 'sum'},
            {dataIndex: 'CARD_ACCT_AMT'          ,            width: 120, summaryType: 'sum'},
            {dataIndex: 'EES_ACCT_AMT'           ,            width: 120, summaryType: 'sum'},
            {dataIndex: 'TAX_ACCT_AMT'           ,            width: 120, summaryType: 'sum', hidden: true},
            {dataIndex: 'WTS_ACCT_AMT'           ,            width: 120, summaryType: 'sum'}            
        ],
        listeners: {
        	listeners: {  
        	},
        	beforeedit: function(editor, e){      		
        	} 
    	}
    });
   
   
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                detailGrid, panelResult
	     	]
        },
            panelSearch
        ], 
    id  : 'aep100skrApp',
    fnInitBinding : function() {
        UniAppManager.setToolbarButtons('reset',true);
        UniAppManager.setToolbarButtons(['newData', 'save', 'delete'], false);
            var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('stGlYm');
			panelSearch.setValue('makeCostCenter', UserInfo.deptCode);
			panelSearch.setValue('makeCostCenterDesc', UserInfo.deptName);
			panelSearch.setValue('kostlCode', UserInfo.deptCode);
			panelSearch.setValue('kostlNm', UserInfo.deptName);
			panelSearch.setValue('useId', UserInfo.userID);
            panelSearch.setValue('useNm', UserInfo.userName);
			
			panelResult.setValue('makeCostCenter', UserInfo.deptCode);
            panelResult.setValue('makeCostCenterDesc', UserInfo.deptName);
            panelResult.setValue('kostlCode', UserInfo.deptCode);
            panelResult.setValue('kostlNm', UserInfo.deptName);
            panelResult.setValue('useId', UserInfo.userID);
            panelResult.setValue('useNm', UserInfo.userName);

        },
        onQueryButtonDown : function()   {
        	if(!panelResult.getInvalidMessage()) return;   //필수체크
        	
        	directDetailStore.loadStoreRecords();
            var viewNormal = detailGrid.getView();
            viewNormal.getFeature('detailGridSubTotal').toggleSummaryRow(true);
            viewNormal.getFeature('detailGridTotal').toggleSummaryRow(true);
        },
		/*onNewDataButtonDown : function() {			
			var r = {
				JOIN_DATE: UniDate.get('today')	
			};
			detailGrid.createRow(r, '');
		},*/
		onSaveDataButtonDown : function() {
//			directDetailStore.saveStore();
		},
		/*onDeleteDataButtonDown : function()	{
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				detailGrid.deleteSelectedRow();
			}
		},*/
		onResetButtonDown : function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			this.fnInitBinding();
		}
   });
};
</script>