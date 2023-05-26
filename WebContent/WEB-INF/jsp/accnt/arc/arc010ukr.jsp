<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="arc010ukr"  >
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'arc010ukrService.selectList',
			update: 'arc010ukrService.updateDetail',
			create: 'arc010ukrService.insertDetail',
			destroy: 'arc010ukrService.deleteDetail',
			syncAll: 'arc010ukrService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Arc010ukrModel', {
	    fields: [  	  
	    	{name: 'RECE_COMP_CODE'		      		, text: '회사코드'		 		,type: 'string'   , allowBlank: false},
	    	{name: 'RECE_COMP_NAME'		      		, text: '회사명'		 		,type: 'string'},
	    	{name: 'BASE_DATE'		      		, text: '기준일'		 		,type: 'uniDate'  , allowBlank: false},
	    	{name: 'FEE_RATE'		      		, text: '요율(%)'		 		,type: 'float', decimalPrecision:2, format:'0,000.00', allowBlank: false},
	    	{name: 'BASE_FEE'		      		, text: '기본대행료'		 	,type: 'uniPrice'},
	    	{name: 'REMARK'		      			, text: '비고'		 		,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('arc010ukrMasterStore',{
		model: 'Arc010ukrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,			// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			var paramMaster= panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						directMasterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
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
                fieldLabel: '기준일',
                xtype: 'uniDatefield',
                name: 'BASE_DATE',                    
//                value: UniDate.get('today'),              
//                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('BASE_DATE', newValue);
                    }
                }
		      },
				Unilite.popup('COMP',{
	                fieldLabel: '회사명', 
	                valueFieldName:'RECE_COMP_CODE',
	                textFieldName:'RECE_COMP_NAME',
	                validateBlank: false,
	                listeners: {
	                    onValueFieldChange: function(field, newValue){
	                        panelResult.setValue('RECE_COMP_CODE', newValue);                                
	                    },
	                    onTextFieldChange: function(field, newValue){
	                        panelResult.setValue('RECE_COMP_NAME', newValue);                
	                    }
	                }
	            })
			]		
		}]
	});	  
	
	var panelResult = Unilite.createSearchForm('resultForm2',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
            fieldLabel: '기준일',
            xtype: 'uniDatefield',
            name: 'BASE_DATE',                    
//            value: UniDate.get('today'),              
//            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('BASE_DATE', newValue);
                }
            }
          },
			Unilite.popup('COMP',{
                fieldLabel: '회사명', 
                valueFieldName:'RECE_COMP_CODE',
                textFieldName:'RECE_COMP_NAME',
                validateBlank: false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelSearch.setValue('RECE_COMP_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelSearch.setValue('RECE_COMP_NAME', newValue);                
                    }
                }
            })
		]
	});	
		
    var masterGrid = Unilite.createGrid('arc010ukrGrid', {
        region:'center',
    	store: directMasterStore,
    	excelTitle: '대행수수료 요율등록',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: false,
			onLoadSelectFirst: true,
			copiedRow:true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false , enableGroupingMenu:false},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [
        	{dataIndex: 'RECE_COMP_CODE'		      	,		width: 120,
	        	editor: Unilite.popup('COMP_G',{
					autoPopup   : true ,
					listeners:{ 
						onSelected: {
	                    	fn: function(records, type  ){
	                    		var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('RECE_COMP_CODE',records[0].COMP_CODE);
								grdRecord.set('RECE_COMP_NAME',records[0].COMP_NAME);
	                    	},
                    		scope: this
          	   			},
						onClear : function(type)	{
	                  		var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('RECE_COMP_CODE','');
							grdRecord.set('RECE_COMP_NAME','');
	                  	}
					}
				})
        	},
        	{dataIndex: 'RECE_COMP_NAME'		      	,		width: 200,
        		editor: Unilite.popup('COMP_G',{
					autoPopup   : true ,
					listeners:{ 
						onSelected: {
	                    	fn: function(records, type  ){
	                    		var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('RECE_COMP_CODE',records[0].COMP_CODE);
								grdRecord.set('RECE_COMP_NAME',records[0].COMP_NAME);
	                    	},
                    		scope: this
          	   			},
						onClear : function(type)	{
	                  		var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('RECE_COMP_CODE','');
							grdRecord.set('RECE_COMP_NAME','');
	                  	}
					}
				})
        	},
        	{dataIndex: 'BASE_DATE'		      	,		width: 100},	
        	{dataIndex: 'FEE_RATE'		      	,		width: 120},	
        	{dataIndex: 'BASE_FEE'		      	,		width: 120},	
        	{dataIndex: 'REMARK'		      	,		flex: 1}		
		],
		listeners: {
        	beforeedit: function( editor, e, eOpts ) {
	        	if(e.record.phantom == false) {
	        		if(UniUtils.indexOf(e.field, ['RECE_COMP_CODE', 'RECE_COMP_NAME', 'BASE_DATE'])) {
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
			border: false,
			items:[
				masterGrid,panelResult
			]	
		},
			panelSearch  	
		],
		id: 'arc010ukrApp',
		fnInitBinding : function() {
			
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);

		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			var baseDate   = UniDate.get('today')
            var r = {
        	 	BASE_DATE    : baseDate
	        };
			masterGrid.createRow(r,'COMP_CODE');			
		},
		onResetButtonDown: function() {		
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {				
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		}
	});
};


</script>
