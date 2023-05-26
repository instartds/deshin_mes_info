<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="scp100skrv"  >
<t:ExtComboStore comboType="AU" comboCode="S065"/>	<!-- 주문 구분		-->
<t:ExtComboStore comboType="AU" comboCode="A028"/>	<!-- 매입사 코드		-->
<t:ExtComboStore comboType="AU" comboCode="YP33"/>	<!-- 복사기 매출구분		-->
<t:ExtComboStore comboType="BOR120" pgmId="scp100skrv"/> 						<!-- 사업장 -->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	gsCollectTypeDetail: ${gsCollectTypeDetail}
};

function appMain() {
	var excelWindow;	// 엑셀참조
	var outDivCode = UserInfo.divCode;
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'scp100skrvService.selectMaster',
			update: 'scp100skrvService.updateDetail',
			create: 'scp100skrvService.insertDetail',
			destroy: 'scp100skrvService.deleteDetail',
			syncAll: 'scp100skrvService.saveAll'
		}
	});
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('scp100skrvModel', {
		fields: [{name: 'COMP_CODE'		    	,text:'법인코드'			,type: 'string' ,defaultValue:'MASTER'},				 
				 {name: 'DIV_CODE'		    	,text:'사업장코드'			,type: 'string'},
				 {name: 'SALE_DATE'		    	,text:'매출일'			,type: 'uniDate'},
				 {name: 'DEPT_CODE'		    	,text:'부서코드'			,type: 'string'},
				 {name: 'BILL_SEQ'		    	,text:'순번'				,type: 'int'},
				 {name: 'ITEM_CODE'	    		,text:'품목'				,type: 'string'},				 
				 {name: 'ITEM_NAME'    			,text:'품명'				,type: 'string'},				 
				 {name: 'SALE_P'		    	,text:'단가'				,type: 'uniPrice'},				 
				 {name: 'SALE_Q'		    	,text:'수량'				,type: 'uniQty'},				 
				 {name: 'SALE_AMT_O'			,text:'판매가'			,type: 'uniPrice'},				 
				 {name: 'CARD_CUST_CODE'	    ,text:'신용카드사'			,type: 'string'},				 
				 {name: 'COLLECT_TYPE_DETAIL'	,text:'매입사'			,type: 'string', comboType: 'AU', comboCode: 'A028'},
				 {name: 'CARD_NO'		    	,text:'카드번호'			,type: 'string'},				 
				 {name: 'CARD_ACC_NUM'			,text:'승인번호'			,type: 'string'},				 
				 {name: 'APPVAL_TIME'	    	,text:'승인시간'			,type: 'string'},
				 {name: 'REMARK'	    		,text:'비고'				,type: 'string'},
				 {name: 'COLLECT_TYPE'	    	,text:'복사기매출구분'		,type: 'string'}
			]
	});
	
	Unilite.Excel.defineModel('excel.scp100.sheet01', {
		fields: [{name: 'COMP_CODE'		    	,text:'법인코드'			,type: 'string'},				 
				 {name: 'DIV_CODE'		    	,text:'사업장코드'			,type: 'string'},
				 {name: 'SALE_DATE'		    	,text:'매출일'			,type: 'uniDate'},
				 {name: 'DEPT_CODE'		    	,text:'부서코드'			,type: 'string'},
				 {name: 'BILL_SEQ'		    	,text:'순번'				,type: 'int'},
				 {name: 'ITEM_CODE'	    		,text:'품목'				,type: 'string'},				 
				 {name: 'ITEM_NAME'    			,text:'품명'				,type: 'string'},				 
				 {name: 'SALE_P'		    	,text:'단가'				,type: 'uniPrice'},				 
				 {name: 'SALE_Q'		    	,text:'수량'				,type: 'uniQty'},				 
				 {name: 'SALE_AMT_O'			,text:'판매가'			,type: 'uniPrice'},				 
				 {name: 'CARD_CUST_CODE'	    ,text:'신용카드사'			,type: 'string'},				 
				 {name: 'COLLECT_TYPE_DETAIL'	,text:'매입사'			,type: 'string', comboType: 'AU', comboCode: 'A028'},
				 {name: 'CARD_NO'		    	,text:'카드번호'			,type: 'string'},				 
				 {name: 'CARD_ACC_NUM'			,text:'승인번호'			,type: 'string'},				 
				 {name: 'APPVAL_TIME'	    	,text:'승인시간'			,type: 'string'},
				 {name: 'REMARK'	    		,text:'비고'				,type: 'string'}
		]
	});

	/*function openExcelWindow() {
		//if(!UniAppManager.app.checkForNewDetail()) return false;
		var me = this;
	    var vParam = {};
	    var appName = 'Unilite.com.excel.ExcelUploadWin';

        if(!excelWindow) {
        	excelWindow =  Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
	    		modal: false,
	    		excelConfigName: 'scp100',
	    		extParam: { 
	    			'DIV_CODE': panelSearch.getValue('DIV_CODE'),
	    			'SALE_DATE': panelSearch.getValue('SALE_DATE'),
	    			'DEPT_CODE': panelSearch.getValue('DEPT_CODE')
	    		},
	            grids: [{
	            	itemId: 'grid01',
	            	title: '복사기 매출업로드',                        		
	            	useCheckbox: true,
	            	model : 'excel.scp100.sheet01',
	            	readApi: 'scp100skrvService.selectExcelUploadSheet1',
	            	columns: [
                 		{dataIndex: 'COMP_CODE'		   		,	width: 100, hidden:true},
						{dataIndex: 'DIV_CODE'		   		,	width: 100, hidden:true},
						{dataIndex: 'DEPT_CODE'			   	,	width: 150, hidden:true},
						{dataIndex: 'SALE_DATE'			   	,	width: 150, hidden:true},
						{dataIndex: 'BILL_SEQ'			   	,	width: 150, hidden:true},
						{dataIndex: 'ITEM_CODE'	   			,	width: 150,
								editor: Unilite.popup('DIV_PUMOK_G', {		
							 		textFieldName: 'ITEM_CODE',
							 		DBtextFieldName: 'ITEM_CODE',
							 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
									listeners: {'onSelected': {
											fn: function(records, type) {
												console.log('records : ', records);
												Ext.each(records, function(record,i) {
													console.log('record',record);
													if(i==0) {
														masterGrid.setItemData(record,false);
													} else {
														UniAppManager.app.onNewDataButtonDown();
														masterGrid.setItemData(record,false);
													}
												}); 
											},
											scope: this
										},
										'onClear': function(type) {
											masterGrid.setItemData(null,true);
										}
									}
								})
						},
						{dataIndex: 'ITEM_NAME'		   		,	width: 150,
						editor: Unilite.popup('ITEM_G', {		
		 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
									listeners: {'onSelected': {
												fn: function(records, type) {
													console.log('records : ', records);
													Ext.each(records, function(record,i) {
														console.log('record',record);
														if(i==0) {
															MasterGrid.setItemData(record,false);
														} else {
															UniAppManager.app.onNewDataButtonDown();
															MasterGrid.setItemData(record,false);
														}
													}); 
												},
												scope: this
											},
											'onClear': function(type) {
												MasterGrid.setItemData(null,true);
											}
									}
							})
						},
						{dataIndex: 'SALE_P'			   		,	width: 120},
						{dataIndex: 'SALE_Q'			   		,	width: 100},
						{dataIndex: 'SALE_AMT_O'			   	,	width: 120},
						{dataIndex: 'CARD_CUST_CODE'			,	width: 150},
						{dataIndex: 'COLLECT_TYPE_DETAIL'		,	width: 150},
						{dataIndex: 'CARD_NO'			   		,	width: 150},
						{dataIndex: 'CARD_ACC_NUM'			   	,	width: 150},
						{dataIndex: 'APPVAL_TIME'			   	,	width: 150},
						{dataIndex: 'REMARK'			   		,	width: 150}
					],
                    listeners: {
		            	afterrender: function(grid) {	
					    	var me = this;
					    	this.contextMenu = Ext.create('Ext.menu.Menu', {});
					     	this.contextMenu.add({	
									text: '품목등록',   iconCls : '',
							        handler: function(menuItem, event) {	
							        	var records = grid.getSelectionModel().getSelection();
							         	var record = records[0];
										var params = {
											appId: UniAppManager.getApp().id,
											sender: me,
											action: 'excelNew',
											_EXCEL_JOBID: excelWindow.jobID,			
											_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'),	
											ITEM_CODE: record.get('ITEM_CODE')
										}
										var rec = {data : {prgID : 'bpr100ukrv', 'text':''}};									
										parent.openTab(rec, '/base/bpr100ukrv.do', params);														
							                	}
							});
						    me.on('cellcontextmenu', function( view, cell, cellIndex, record, row, rowIndex, event ) {
					        	event.stopEvent();
					        	if(record.get('_EXCEL_HAS_ERROR') == 'Y')
								me.contextMenu.showAt(event.getXY());
							});
						}
		            }
                }],
                listeners: {
                	close: function() {
                    	this.hide();
                    }
          		},
            	onApply:function()	{
                	var grid = this.down('#grid01');
                	var records = grid.getSelectionModel().getSelection();       		
					Ext.each(records, function(record,i){	
						UniAppManager.app.onNewDataButtonDown();
						MasterGrid.setExcelData(record.data);								        
					}); 
					grid.getStore().remove(records);
                }
              });
            }
            excelWindow.center();
            excelWindow.show();
	}*/
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var MasterStore = Unilite.createStore('scp100skrvMasterStore',{
			model: 'scp100skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,		// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			},
			listeners: {
           	load: function(store, records, successful, eOpts) {
           		
           	}   	
		},
		saveStore : function(config)	{	
// var paramMaster= [];
// var app = Ext.getCmp('bpr100ukrvApp');
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	var list = [].concat(toUpdate, toCreate);
            	console.log("toUpdate",toUpdate);
            	console.log("inValidRecords : ", inValidRecs);
				console.log("list:", list);
				console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

            	var rv = true;
       	
            	
				if(inValidRecs.length == 0 )	{										
					config = {
// params: [paramMaster],
							success: function(batch, option) {								
								panelResult.resetDirtyStatus();
								UniAppManager.setToolbarButtons('save', false);			
							 } 
					};					
					this.syncAllDirect(config);
				}else {
					MasterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners:{
				update:function( store, record, operation, modifiedFieldNames, eOpts )	{
// panelResult.setActiveRecord(record);
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
					fieldLabel: '사업장',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					//holdable: 'hold',
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '매출일',
					xtype: 'uniDateRangefield',
					startFieldName: 'SALE_DATE_FR',
					endFieldName: 'SALE_DATE_TO',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					allowBlank: false,
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('SALE_DATE_FR',newValue);			
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('SALE_DATE_TO',newValue);			    		
				    	}
				    }
				},{					
					fieldLabel: '매출구분',
					name:'COLLECT_TYPE',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'YP33',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('COLLECT_TYPE', newValue);
						}
					}
				}
			]
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
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    items: [
    		{					
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				//holdable: 'hold',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '매출일',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('SALE_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('SALE_DATE_TO',newValue);			    		
			    	}
			    }
			},{					
				fieldLabel: '매출구분',
				name:'COLLECT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'YP33',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('COLLECT_TYPE', newValue);
					}
				}
			}
		],
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
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		}
    });
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var MasterGrid= Unilite.createGrid('scp100skrvGrid', {
	    	region: 'center' ,
	        layout : 'fit',
	        store : MasterStore,
	        width:400,
	         margin: 0,
	         /*tbar: [{
				xtype: 'splitbutton',
	           	itemId:'refTool',
				text: '참조...',
				iconCls : 'icon-referance',
				menu: Ext.create('Ext.menu.Menu', {
					items: [{
						itemId: 'excelBtn',
						text: '엑셀참조',
			        	handler: function() {
				        	openExcelWindow();
				        }
					}]
				})
			}],*/
	        uniOpt:{
	        	expandLastColumn: true,
	    		useLiveSearch: true,
				useContextMenu: true,
				useMultipleSorting: true,
	    		useGroupSummary: false,
				useRowNumberer: false,
				filter: {
					useFilter: true,
					autoCreate: true
				}
	        },
	    	features: [
	    		{id : 'MasterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
	    	    {id : 'MasterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
	    	],
	        columns: [
				{dataIndex: 'COMP_CODE'		   			,	width: 100, hidden:true},
				{dataIndex: 'DIV_CODE'		   			,	width: 100, hidden:true},
				{dataIndex: 'DEPT_CODE'			   		,	width: 150, hidden:true},
				{dataIndex: 'SALE_DATE'			   		,	width: 100},
				{dataIndex: 'COLLECT_TYPE'				,	width: 130},
				{dataIndex: 'BILL_SEQ'			   		,	width: 150, hidden:true},
				{dataIndex: 'ITEM_CODE'	   				,	width: 120,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				    	return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
	            	},
					editor: Unilite.popup('ITEM_G', {		
							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
							listeners: {'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										Ext.each(records, function(record,i) {
											console.log('record',record);
											if(i==0) {
												MasterGrid.setItemData(record,false);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												MasterGrid.setItemData(record,false);
											}
										}); 
									},
									scope: this
								},
								'onClear': function(type) {
									MasterGrid.setItemData(null,true);
								}
							}
					})
				},
				{dataIndex: 'ITEM_NAME'		   		,	width: 130,
					editor: Unilite.popup('ITEM_G', {		
	 						extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
							listeners: {'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										Ext.each(records, function(record,i) {
											console.log('record',record);
											if(i==0) {
												MasterGrid.setItemData(record,false);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												MasterGrid.setItemData(record,false);
											}
										}); 
													},
												scope: this
								},
								'onClear': function(type) {
									MasterGrid.setItemData(null,true);
								}
							}
						})
				},
				{dataIndex: 'SALE_P'			   		,	width: 80 },
				{dataIndex: 'SALE_Q'			   		,	width: 80 , summaryType: 'sum'},
				{dataIndex: 'SALE_AMT_O'			   	,	width: 120 , summaryType: 'sum'},
				{dataIndex: 'CARD_CUST_CODE'			,	width: 130},
				{dataIndex: 'COLLECT_TYPE_DETAIL'		,	width: 130},
				{dataIndex: 'CARD_NO'			   		,	width: 140},
				{dataIndex: 'CARD_ACC_NUM'			   	,	width: 100},
				{dataIndex: 'APPVAL_TIME'			   	,	width: 150},
				{dataIndex: 'REMARK'			   		,	width: 150}
			],
			listeners: {
		        beforeedit  : function( editor, e, eOpts ) {
		        	if(e.record.phantom == false) {
		        		if(UniUtils.indexOf(e.field, ['SALE_P', 'SALE_Q', 'COLLECT_TYPE_DETAIL'])) 
						{ 
							return true;
	      				} else {
	      					return false;
	      				}
		        	} else {
		        		if(UniUtils.indexOf(e.field, ['SALE_P', 'SALE_Q', 'COLLECT_TYPE_DETAIL']))
					   	{
							return true;
	      				} else {
	      					return false;
	      				}
		        	}
		        }
			},
	        setItemData: function(record, dataClear) {
	       		var grdRecord = this.getSelectedRecord();
	       		if(dataClear) {
					grdRecord.set('ITEM_CODE'	,"");
	       			grdRecord.set('ITEM_NAME'	,"");
				}
	       		else {
	       			grdRecord.set('ITEM_CODE'	, record['ITEM_CODE']);
	       			grdRecord.set('ITEM_NAME'	, record['ITEM_NAME']);
				}
	    	}
	/*    	setExcelData: function(record) {
				var grdRecord = this.getSelectedRecord();
				grdRecord.set('COMP_CODE'	    			, record['COMP_CODE']);
				grdRecord.set('DIV_CODE'		    		, record['DIV_CODE']);
				grdRecord.set('SALE_DATE'		    		, panelSearch.getValue('SALE_DATE'));
				//grdRecord.set('DEPT_CODE'		    		, panelSearch.getValue('DEPT_CODE'));
				grdRecord.set('BILL_SEQ'		    		, record['BILL_SEQ']);
				grdRecord.set('ITEM_CODE'	    			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'    				, record['ITEM_NAME']);
				grdRecord.set('SALE_P'		    			, record['SALE_P']);
				grdRecord.set('SALE_Q'		    			, record['SALE_Q']);
				grdRecord.set('SALE_AMT_O'					, record['SALE_AMT_O']);
				grdRecord.set('CARD_CUST_CODE'	    		, record['CARD_CUST_CODE']);
				grdRecord.set('COLLECT_TYPE_DETAIL'			, record['COLLECT_TYPE_DETAIL']);
				grdRecord.set('CARD_NO'		    			, record['CARD_NO']);
				grdRecord.set('CARD_ACC_NUM'				, record['CARD_ACC_NUM']);
				grdRecord.set('APPVAL_TIME'	    			, record['APPVAL_TIME']);
				grdRecord.set('REMARK'	    				, record['REMARK']);
			}*/
    });		//End of var MasterGrid
    

    /**
	 * Main 정의(Main 정의)
	 * @type 
	 */
    Unilite.Main ({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		MasterGrid, panelResult
         	]	
      	},
      	panelSearch     
      	],
		id: 'scp100skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('SALE_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('SALE_DATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('newData', false);
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			MasterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('newData', false);
		},
		onNewDataButtonDown: function(record)	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
				var seq 		  		= MasterStore.max('BILL_SEQ');
	            if(!seq) seq = 1;
	            else  seq += 1;
	            var divCode       		= panelSearch.getValue('DIV_CODE');
	            //var deptCode 	  		= panelSearch.getValue('DEPT_CODE');
	            var saleDate      		= panelSearch.getValue('SALE_DATE');
			    var saleP         		= 0;
	            var saleQ         		= 0;
	            var saleAmtO      		= 0;
	            var cardCustCode		= Ext.data.StoreManager.lookup('CBS_AU_A028').getAt(0).get('value');
	            var collectTypeDetail	= UniAppManager.app.fnGetCollectTypeDetailCode(null, cardCustCode) ;
	            var compCode			= UserInfo.compCode; 
	       
	            var r = {
					DIV_CODE          	: divCode,
					//DEPT_CODE		  	: deptCode,
					SALE_DATE		  	: saleDate,
					BILL_SEQ          	: seq,
					//ITEM_CODE   	  	: itemCode,
					//ITEM_NAME		  	: itemName,
					SALE_P			  	: saleP,
					SALE_Q			  	: saleQ,
					SALE_AMT_O		  	: saleAmtO,
					CARD_CUST_CODE  	: cardCustCode,
					COLLECT_TYPE_DETAIL	: collectTypeDetail,
					COMP_CODE			: compCode
					//CARD_NO		  	: cardNo,
					//CARD_ACC_NUM	  	: cardAccNum,
					//APPVAL_TIME	  	: appvalTime,
					//BILL_PRSN		  	: billPrsn
					
	            };
	            MasterGrid.createRow(r, 'ITEM_CODE', MasterGrid.getStore().getCount()-1);
				panelSearch.setAllFieldsReadOnly(true);
				UniAppManager.setToolbarButtons('save', true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			MasterGrid.reset();
			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save', false);
			MasterStore.clearData();
		},
		onSaveDataButtonDown: function(config) {
				MasterStore.saveStore(config);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onDeleteDataButtonDown: function() {
			var Grid1 = UniAppManager.app.down('#scp100skrvGrid');
			var selRow = MasterGrid.getSelectedRecord();
			if(selRow.phantom === true)
				MasterGrid.deleteSelectedRow();
			else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				MasterGrid.deleteSelectedRow();
			}
		},
		
		rejectSave: function() {
			var rowIndex = MasterGrid1.getSelectedRowIndex();
			MasterGrid.select(rowIndex);
			MasterStore.rejectChanges();
			if(rowIndex >= 0){
				MasterGrid.getSelectionModel().select(rowIndex);
				var selected = DetailGrid.getSelectedRecord();
				
				var selected_doc_no = selected.data['DOC_NO'];
  				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {															
					}
				);
			}
			MasterStore.onStoreActionEnable();
		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('scp100skrvFileUploadPanel');
        	if(MasterStore.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		fnGetCollectTypeDetailCode: function(rtnRecord, collectTypeDetailCode)	{        	
        	var fRecord = '';
        	Ext.each(BsaCodeInfo.gsCollectTypeDetail, function(item, i)	{
        		
        		if(item['codeNo'] == collectTypeDetailCode) {
        			fRecord = item['collectTypeDetail'];
        			if(Ext.isEmpty(fRecord)){
        				fRecord = item['codeNo']
        			}
        		}
        	})
        	return fRecord;
        }
	});
	
	Unilite.createValidator('validator01', {
		store: MasterStore,
		grid: MasterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "SALE_P" :	// 단가
					record.set('SALE_AMT_O',(newValue * record.get('SALE_Q')));
				break;
				
				case "SALE_Q" :	// 수량
					record.set('SALE_AMT_O',(newValue * record.get('SALE_P')));
				break;
			}
			return rv;
		}
	})
};
</script>
