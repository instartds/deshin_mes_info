<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep110skr"  >
    <t:ExtComboStore comboType="AU" comboCode="J647" />         <!-- 유형 -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {

	var directProxyReceipt = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create	: 'aep110skrService.insertReceiptDetail',
            syncAll	: 'aep110skrService.saveReceiptAll'
        }
    }); 
    
   
    
   /** Model 정의 
    * @type 
    */

	Unilite.defineModel('aep110skrModel', {
		fields: [
		    {name: 'RNUM'                   , text: '순번'			, type: 'string'},
		    {name: 'REG_NM'		            , text: '사용자'		 	, type: 'string'},
		    {name: 'COST_CENTER_NM'         , text: '회계년월'			, type: 'string'},
		    {name: 'ACCNT_NAME'             , text: '계정명'			, type: 'string'},
		    {name: 'COST_DEPT_NM'           , text: '귀속부서명'		, type: 'string'},
		    {name: 'ACCT_AMT'               , text: '예산금액'			, type: 'uniPrice'},
		    {name: 'CARD_ACCT_AMT'          , text: '예산잔액'			, type: 'uniPrice'},
		    {name: 'EES_ACCT_AMT'           , text: '집행금액계'		, type: 'uniPrice'},
		    {name: 'TAX_ACCT_AMT'           , text: '법인카드'			, type: 'uniPrice'},
		    {name: 'WTS_ACCT_AMT'           , text: '실물증빙'			, type: 'uniPrice'},
		    {name: 'TEST10'         	    , text: '원천세'			, type: 'uniPrice'}
		]	});
	
		
		
   /** Store 정의(Service 정의)
    * @type 
    */               
    var masterStore = Unilite.createStore('aep110skrDetailStore',{
        model	: 'aep110skrModel',
        uniOpt	: {
            isMaster	: true,        	// 상위 버튼 연결 
            editable	: false,    	// 수정 모드 사용 
            deletable	: false,       	// 삭제 가능 여부 
            useNavi		: false       	// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: {
            type: 'direct',
            api	: {          
                read: 'aep110skrService.selectList'                  
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
   


   /** 검색조건 (Search Panel)
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
		items		: [{	
			title		: '기본정보', 	
   			itemId		: 'search_panel1',
           	layout		: {type: 'uniTable', columns: 1},
           	defaultType	: 'uniTextfield',           	
			items		: [{ 
    			fieldLabel: '회계년월',
		        xtype: 'uniMonthRangefield',
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
			Unilite.popup('ACCNT',{ 
		    	fieldLabel: '계정코드',
		    	valueFieldName: 'ACCOUNT_CODE',
				textFieldName: 'ACCOUNT_NAME',
//				holdable  : 'hold',
		    	listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCOUNT_CODE', panelSearch.getValue('ACCOUNT_CODE'));
							panelResult.setValue('ACCOUNT_NAME', panelSearch.getValue('ACCOUNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCOUNT_CODE', '');
						panelResult.setValue('ACCOUNT_NAME', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('DEPT',{
				fieldLabel		: '발생부서',
			  	valueFieldName	: 'DEPT_CODE',
			    textFieldName	: 'DEPT_NAME',
				validateBlank	: false,
				autoPopup		: true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_NAME', newValue);				
					}
				}
			}),
            Unilite.popup('DEPT',{
                fieldLabel: '귀속부서',
                valueFieldName:'COST_DEPT_CD',
                textFieldName:'COST_DEPT_NM',
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
                        panelResult.setValue('COST_DEPT_CD', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('COST_DEPT_NM', newValue);             
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
            xtype: 'uniMonthRangefield',
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
		Unilite.popup('ACCNT',{ 
	    	fieldLabel: '계정코드', 
	    	popupWidth: 600,
	    	valueFieldName: 'ACCOUNT_CODE',
			textFieldName: 'ACCOUNT_NAME',
			colspan:4,
			holdable  : 'hold',
	    	listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ACCOUNT_CODE', panelResult.getValue('ACCOUNT_CODE'));
						panelSearch.setValue('ACCOUNT_NAME', panelResult.getValue('ACCOUNT_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ACCOUNT_CODE', '');
					panelSearch.setValue('ACCOUNT_NAME', '');
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
        Unilite.popup('DEPT',{
            fieldLabel: '발생부서',
            valueFieldName:'DEPT_CODE',
            textFieldName:'DEPT_NAME',
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
                    panelSearch.setValue('DEPT_CODE', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('DEPT_NAME', newValue);             
                }
            }
        }),
        Unilite.popup('DEPT',{
            fieldLabel: '귀속부서',
            valueFieldName:'COST_DEPT_CD',
            textFieldName:'COST_DEPT_NM',
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
                    panelSearch.setValue('COST_DEPT_CD', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('COST_DEPT_NM', newValue);             
                }
            }
        })]
    });
   
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var detailGrid = Unilite.createGrid('aep110skrGrid', {
		store	: masterStore,
        region	: 'center',
        layout	: 'fit',
    	uniOpt	: {
    		useGroupSummary		: false,
    		useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			onLoadSelectFirst	: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		state				: {
				useState	: true,			
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
        columns: [
            {dataIndex: 'REG_NM'				, width: 140},
            {dataIndex: 'COST_CENTER_NM'		, width: 120},
            {dataIndex: 'ACCNT_NAME'			, width: 200,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
                }
            },
            {dataIndex: 'COST_DEPT_NM'          , width: 180},
            {dataIndex: 'ACCT_AMT'              , width: 140		, summaryType: 'sum'},
            {dataIndex: 'CARD_ACCT_AMT'         , width: 140		, summaryType: 'sum'},
            {dataIndex: 'EES_ACCT_AMT'          , width: 140		, summaryType: 'sum'},
            {dataIndex: 'TAX_ACCT_AMT'          , width: 140		, summaryType: 'sum'},
            {dataIndex: 'WTS_ACCT_AMT'          , width: 140		, summaryType: 'sum'},            
            {dataIndex: 'TEST10'           		, width: 140		, summaryType: 'sum'}            
        ],    
        listeners: {
        	listeners: {  
        	},
        	beforeedit: function(editor, e){      		
        	} 
    	}
    });
   
   
    Unilite.Main( {
    	id  : 'aep110skrApp',
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
			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			
			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
            panelResult.setValue('DEPT_NAME', UserInfo.deptName);
        },

        onQueryButtonDown : function()   {
			if(!this.isValidSearchForm()){
				return false;
			}
        	masterStore.loadStoreRecords();
            var viewNormal = detailGrid.getView();
            viewNormal.getFeature('detailGridSubTotal').toggleSummaryRow(true);
            viewNormal.getFeature('detailGridTotal').toggleSummaryRow(true);
        },

		onResetButtonDown : function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			detailGrid.reset();
			masterStore.getStore().loadData({});
			this.fnInitBinding();
		}
   });
};
</script>