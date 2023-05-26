<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afn201ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A031" /> <!-- 어음수표구분 조건 콤보 -->
	<t:ExtComboStore comboType="AU" comboCode="A064" /> <!-- 어음처리구분 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var excelWindow; 

function appMain() {  
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afn201ukrService.selectList',
			update: 'afn201ukrService.updateDetail',
			create: 'afn201ukrService.insertDetail',
			destroy: 'afn201ukrService.deleteDetail',
			syncAll: 'afn201ukrService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afn201ukrModel', {
	    fields: [  	  
	    	{name: 'NOTE_DIVI'			, text: '어음수표구분' 		,type: 'string',comboType:'AU',comboCode:'A031',allowBlank:false},
		    {name: 'NOTE_NUM' 			, text: '어음수표번호'		,type: 'string',allowBlank:false},
		    {name: 'BANK_CODE'			, text: '은행코드' 		,type: 'string',allowBlank:false},
		    {name: 'BANK_NAME'   	 	, text: '은행명' 			,type: 'string'},
		    {name: 'INSOCK_DATE'	 	, text: '입고일' 			,type: 'uniDate',allowBlank:false},
		    {name: 'FLOAT_DATE'			, text: '발행일' 			,type: 'uniDate'},
		    {name: 'SET_DATE'			, text: '결제일' 			,type: 'uniDate'},
		    {name: 'PROC_SW' 			, text: '처리구분' 		,type: 'string',comboType:'AU',comboCode:'A064',allowBlank:false},
		    {name: 'UPDATE_DB_USER'		, text: '수정자' 			,type: 'string'},
		    {name: 'UPDATE_DB_TIME'		, text: '수정일' 			,type: 'uniDate'},
		    {name: 'COMP_CODE'			, text: '법인코드' 		,type: 'string'}
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
	var directMasterStore = Unilite.createStore('afn201ukrMasterStore1',{
		model: 'Afn201ukrModel',
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
		 		fieldLabel: '어음수표구분',
		 		name:'NOTE_DIVI', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'A031',
		 		listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('NOTE_DIVI', newValue);
					}
				}
	 		},
			Unilite.popup('BANK',{ 
		    	fieldLabel: '은행코드', 
		    	valueFieldName:'BANK_CODE',
		    	textFieldName:'BANK_NAME',
		    	popupWidth: 500,
				autoPopup   : true ,
		    	validateBlank : 'text',
			    listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('BANK_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('BANK_NAME', newValue);				
					}
				}
//		    	listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('BANK_CODE', panelSearch.getValue('BANK_CODE'));
//							panelResult.setValue('BANK_NAME', panelSearch.getValue('BANK_NAME'));
//	                	},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('BANK_CODE', '');
//						panelResult.setValue('BANK_NAME', '');
//					}
//				}
			}),{
				fieldLabel: '입고일',
				xtype: 'uniDateRangefield',
				startFieldName: 'INSOCK_DATE_FR',
				endFieldName: 'INSOCK_DATE_TO',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('INSOCK_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('INSOCK_DATE_TO',newValue);
			    	}
			    }
			},{
 					fieldLabel:'어음번호', 
 					xtype: 'uniTextfield',
 					name: 'NOTE_NUM_FR',
 					listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('NOTE_NUM_FR', newValue);
					}
				}
 					
			},{
 					fieldLabel:'~', 
 					xtype: 'uniTextfield',
 					name: 'NOTE_NUM_TO',
 					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('NOTE_NUM_TO', newValue);
						},
		    			specialkey: function(elm, e){
		                    if (e.getKey() == e.ENTER) {
		                    	UniAppManager.app.onQueryButtonDown();  
		                	}
		                }
					}	
			}]		
		}]
	});	  
	
	var panelResult = Unilite.createSearchForm('resultForm2',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
	 		fieldLabel: '어음수표구분',
	 		name:'NOTE_DIVI', 
	 		xtype: 'uniCombobox',
	 		comboType:'AU',
	 		comboCode:'A031',
	 		listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('NOTE_DIVI', newValue);
				}
			}
 		},
		Unilite.popup('BANK',{ 
	    	fieldLabel: '은행코드', 
	    	valueFieldName:'BANK_CODE',
	    	textFieldName:'BANK_NAME',
	    	popupWidth: 500,
			autoPopup   : true ,
	    	colspan:2,
	    	validateBlank : 'text',
			    listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('BANK_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('BANK_NAME', newValue);				
					}
				}
//	    	listeners: {
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('BANK_CODE', panelResult.getValue('BANK_CODE'));
//						panelSearch.setValue('BANK_NAME', panelResult.getValue('BANK_NAME'));
//                	},
//					scope: this
//				},
//				onClear: function(type)	{
//					panelSearch.setValue('BANK_CODE', '');
//					panelSearch.setValue('BANK_NAME', '');
//				}
//			}
		}),{
			fieldLabel: '입고일',
			xtype: 'uniDateRangefield',
			startFieldName: 'INSOCK_DATE_FR',
			endFieldName: 'INSOCK_DATE_TO',
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('INSOCK_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('INSOCK_DATE_TO',newValue);
		    	}
		    }
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:600,
			items :[{
				fieldLabel:'어음번호', 
				xtype: 'uniTextfield',
				name: 'NOTE_NUM_FR', 
				width:250,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('NOTE_NUM_FR', newValue);
					}
				}
			},{
				xtype:'component', 
				html:'~',
				style: {
			        marginTop: '3px !important',
			        font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
			    }
			},{
 				fieldLabel:'', 
				xtype: 'uniTextfield',
				name: 'NOTE_NUM_TO', 
				width:155,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('NOTE_NUM_TO', newValue);
					},
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	UniAppManager.app.onQueryButtonDown();  
	                	}
	                }
				}
			}]
		}]
	});	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('afn201ukrGrid1', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore, 
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: true,
			onLoadSelectFirst: true,
			copiedRow:true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
		store: directMasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        tbar: [{
            text: '엑셀 Upload',
            handler: function() {
                openExcelWindow();
            }
        }],
        columns: [        
        	{dataIndex: 'NOTE_DIVI'			, Width: 80 ,align:'center'}, 				
			{dataIndex: 'NOTE_NUM' 			, width: 150}, 				
			{dataIndex: 'BANK_CODE'			, width: 80,
				editor: Unilite.popup('BANK_G',{
					textFieldName: 'BANK_CODE',
					DBtextFieldName: 'BANK_CODE',
			  		autoPopup: true,
					listeners:{ 
						'onSelected': {
	                    	fn: function(records, type  ){
	                    		var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
								grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
	                    	},
                    		scope: this
          	   			},
						'onClear' : function(type)	{
	                  		var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE','');
							grdRecord.set('BANK_NAME','');
	                  	}
					}
				})
			}, 				
			{dataIndex: 'BANK_NAME'   		, width: 150,
				editor: Unilite.popup('BANK_G',{
			  		autoPopup: true,
					listeners:{
						'onSelected': {
	                    	fn: function(records, type  ){
	                    		var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
								grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
	                    	},
                    		scope: this
          	   			},
						'onClear' : function(type)	{
	                  		var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE','');
							grdRecord.set('BANK_NAME','');
	                  	}
					}
				})
			}, 				
			{dataIndex: 'INSOCK_DATE'		, width: 120}, 				
			{dataIndex: 'FLOAT_DATE'		, width: 120}, 				
			{dataIndex: 'SET_DATE'			, width: 120}, 				
			{dataIndex: 'PROC_SW' 			, width: 80 ,align:'center'}, 				
			{dataIndex: 'UPDATE_DB_USER'	, width: 80 ,hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 80 ,hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 80 ,hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom){
					return true;				
				}else{
					if (UniUtils.indexOf(e.field, 
						['INSOCK_DATE','FLOAT_DATE','SET_DATE','PROC_SW']))
						{	
							return true;
						}else{
							return false;
						}
				}
			}
		}
    });
    
    function openExcelWindow() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUpload';
        
        if(!excelWindow) { 
            excelWindow = Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
                modal: false,
                excelConfigName: 'afn201ukr',
                width: 600,
                height: 200,
                extParam: { 
                    'PGM_ID' : 'afn201ukr'
                },
                listeners: {
                    close: function() {
                        this.hide();
                    }
                },
                uploadFile: function() {
                    var me = this,
                    frm = me.down('#uploadForm');
                    frm.submit({
                        params: me.extParam,
                        waitMsg: 'Uploading...',
                        success: function(form, action) {
                            me.jobID = action.result.jobID;
                            me.readGridData(me.jobID);
                            me.down('tabpanel').setActiveTab(1);
                            Ext.Msg.alert('Success', 'Upload 되었습니다.');
                            
                            me.hide();
                                
                            UniAppManager.app.onQueryButtonDown();
                        },
                        failure: function(form, action) {
                            Ext.Msg.alert('Failed', action.result.msg);
                        }
                        
                    });
                },
                _setToolBar: function() {
                    var me = this;
                    me.tbar = [
                        {
                            xtype: 'button',
                            text : '업로드',
                            tooltip : '업로드', 
                            handler: function() { 
                                me.jobID = null;
                                me.uploadFile();
                            }
                        },
                        '->',
                        {
                            xtype: 'button',
                            text : '닫기',
                            tooltip : '닫기', 
                            handler: function() { 
                                me.hide();
                            }
                        }
                    ]
                 }
            });
        }
        excelWindow.center();
        excelWindow.show();
    };
    
	 Unilite.Main( {
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
		id: 'afn201ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('NOTE_DIVI');
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			var compCode = UserInfo.compCode;
			var insockDate = UniDate.get('today');
			var procSw	 = '2'
            	 
            	 
            	 
            	 var r = {
            	 	COMP_CODE : compCode,
            	 	INSOCK_DATE : insockDate,
            	 	PROC_SW : procSw
		        };
				masterGrid.createRow(r,'NOTE_DIVI');
				
			},
		onResetButtonDown: function() {		
			panelSearch.reset();
			masterGrid.reset();
			panelResult.reset();
			
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
//				if(selRow.get('ACCOUNT_Q') != 0)
//				{
//					alert('<t:message code="unilite.msg.sMM008"/>');
//				}else{
					masterGrid.deleteSelectedRow();
//				}
			}
		},
		onDeleteAllButtonDown: function() {			
			var records = directMasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						
						var deletable = true;
						if(deletable){		
							masterGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;	
							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		}
	});
};


</script>
