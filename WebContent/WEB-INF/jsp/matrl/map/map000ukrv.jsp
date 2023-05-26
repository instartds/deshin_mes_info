<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map000ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="map000ukrv"   /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->	
</t:appConfig>
<script type="text/javascript" >
var BsaCodeInfo = {
	gsDefaultMoney: '${gsDefaultMoney}'
};

var excelWindow;	// 엑셀참조
/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/


var outDivCode = UserInfo.divCode;

function appMain() {   
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'map000ukrvService.selectList',
			update: 'map000ukrvService.updateDetail',
			create: 'map000ukrvService.insertDetail',
			destroy: 'map000ukrvService.deleteDetail',
			syncAll: 'map000ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('Map000ukrvModel', {
	    fields: [  	 	
	    	{name: 'COMP_CODE'		,text: 'COMP_CODE'	,type: 'string'},
	    	{name: 'DIV_CODE'		,text: '<t:message code="system.label.purchase.division" default="사업장"/>'		,type: 'string'},
	    	{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		,type: 'string', allowBlank: false},
	    	{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		,type: 'string', allowBlank: false},
	    	{name: 'MONEY_UNIT'		,text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'		,type: 'string',comboType:'AU', comboCode:'B004', displayField: 'value', allowBlank: false},
	    	{name: 'BASIS_AMT_O'	,text: '기초잔액'		,type: 'uniPrice'},
	    	{name: 'CREATE_LOC'		,text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'		,type: 'string'}
		]  
	});		//End of Unilite.defineModel('Map000ukrvModel', {
	
	Unilite.Excel.defineModel('excel.map000.sheet01', {
		fields: [
				
		    	{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		,type: 'string'},
		    	{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		,type: 'string'},
		    	{name: 'MONEY_UNIT'		,text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'		,type: 'string'},
		    	{name: 'BASIS_AMT_O'	,text: '기초잔액'		,type: 'uniPrice'}
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore1 = Unilite.createStore('map000ukrvMasterStore1',{
		model: 'Map000ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable: true,			// 삭제 가능 여부 
           	allDeletable: true,
	        useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
			
		proxy: directProxy,
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();	
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			
			var paramMaster= masterForm.getValues();
				//paramMaster.BASIS_YYYYMM = UniDate.getDbDateStr(masterForm.getValue('BASIS_YYYYMM'));
				var inValidRecs = this.getInvalidRecords();
            	
            	var rv = true;
            	
				if(inValidRecs.length == 0 )	{
					config = {
							params: [paramMaster]
					};
				this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
	});		// End of var directMasterStore1 = Unilite.createStore('map000ukrvMasterStore1',{
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var masterForm = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',           	
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				holdable: 'hold',
				//value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
					/*	if(Ext.getCmp('baseYM') ==''){
							Ext.getCmp('baseYM').setReadOnly(false);
						}*/
						panelResult.setValue('DIV_CODE', newValue);
					
					var param = {"DIV_CODE": masterForm.getValue('DIV_CODE')};
					map000ukrvService.checkBasisYM(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
							masterForm.setValue('BASIS_YYYYMM', provider['BASIS_YYYYMM']);
							panelResult.setValue('BASIS_YYYYMM', provider['BASIS_YYYYMM']);
								Ext.getCmp('baseYM').setReadOnly(true);
								Ext.getCmp('baseYM2').setReadOnly(true);
						}else{
							masterForm.setValue('BASIS_YYYYMM', '');
							panelResult.setValue('BASIS_YYYYMM', '');
								Ext.getCmp('baseYM').setReadOnly(false);
								Ext.getCmp('baseYM2').setReadOnly(false);
						}
					})
				}

				}
			},{ 
				fieldLabel: '기초년월',
				id: 'baseYM',
				name: 'BASIS_YYYYMM',
	            xtype: 'uniMonthfield',
	    //        value: UniDate.get('today'),
	            allowBlank: false,
	            width: 200,
	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BASIS_YYYYMM', newValue);
						
					//	masterForm.setValue('LAST_YYYYMM',UniDate.add(newValue, {months:-1}));
					}
				}
	        },{
	        	fieldLabel: '최종마감년월',
	        	name:'LAST_YYYYMM',
	        	xtype: 'uniMonthfield',
	        	hidden:false
	        },{
				fieldLabel: '거래처분류',
				name:'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AGENT_TYPE', newValue);
					}
				}
			},
			Unilite.popup('CUST', { 
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
				valueFieldName: 'CUSTOM_CODE',
		   	 	textFieldName: 'CUSTOM_NAME',
				extParam: {'CUSTOM_TYPE': ['1','2']},
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
								panelResult.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
					}
				}
			}),Unilite.popup('AGENT_CUST_MULTI_G', { 
		   	 	textFieldName: 'CUSTOM_NAME_M',
		   	 	itemId: 'customPopField',
		   	 	hidden: true,
		   	 	autoPopup: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							Ext.each(records, function(record,i) {
								console.log('record',record);
								if(i==0) {
									UniAppManager.app.onNewDataButtonDown();
									masterGrid.setItemData(record,false);
								} else {
									UniAppManager.app.onNewDataButtonDown();
									masterGrid.setItemData(record,false);
								}
							}); 
                    	},
						scope: this
					}
				}
			}),{
		    	xtype: 'container',
		    	padding: '10 0 0 40',
		    	layout: {
		    		type: 'hbox',
					pack:'center'
		    	},
		    	items:[{
		    		xtype: 'button',
		    		text: '거래처복사',
		    		handler: function() {
		    			var field = masterForm.down('#customPopField');
		    			field.openPopup('VALUE');
		    			//field.openPopup('TEXT');
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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
    });		// End of var masterForm = Unilite.createSearchForm('searchForm',{    
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				holdable: 'hold',
			//	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('DIV_CODE', newValue);
						
						var param = {"DIV_CODE": panelResult.getValue('DIV_CODE')};
						map000ukrvService.checkBasisYM(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
							panelResult.setValue('BASIS_YYYYMM', provider['BASIS_YYYYMM']);
							masterForm.setValue('BASIS_YYYYMM', provider['BASIS_YYYYMM']);
								Ext.getCmp('baseYM').setReadOnly(true);
								Ext.getCmp('baseYM2').setReadOnly(true);
							}else{
							masterForm.setValue('BASIS_YYYYMM', '');
							panelResult.setValue('BASIS_YYYYMM', '');
								Ext.getCmp('baseYM').setReadOnly(false);
								Ext.getCmp('baseYM2').setReadOnly(false);
							}
						})
					}
				}
			},{ 
				fieldLabel: '기초년월',
				id: 'baseYM2',
				name: 'BASIS_YYYYMM',
	            xtype: 'uniMonthfield',
	            allowBlank: false,
	            width: 200,
	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('BASIS_YYYYMM', newValue);
					}
				}
	        },{
				fieldLabel: '거래처분류',
				name:'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('AGENT_TYPE', newValue);
					}
				}
			},
			Unilite.popup('CUST', { 
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
				valueFieldName: 'CUSTOM_CODE',
		   	 	textFieldName: 'CUSTOM_NAME',
				extParam: {'CUSTOM_TYPE': ['1','2']},
				listeners: {
					onSelected: {
						fn: function(records, type) {
							masterForm.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
							masterForm.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
								masterForm.setValue('CUSTOM_CODE', '');
								masterForm.setValue('CUSTOM_NAME', '');
					}
				}
			}),Unilite.popup('AGENT_CUST_MULTI_G', { 
		   	 	textFieldName: 'CUSTOM_NAME_M',
		   	 	itemId: 'customPopField2',
		   	 	hidden: true,
		   	 	autoPopup: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							Ext.each(records, function(record,i) {
								console.log('record',record);
								if(i==0) {
									UniAppManager.app.onNewDataButtonDown();
									masterGrid.setItemData(record,false);
								} else {
									UniAppManager.app.onNewDataButtonDown();
									masterGrid.setItemData(record,false);
								}
							}); 
                    	},
						scope: this
					}
				}
			}),{
		    		xtype: 'button',
		    		text: '거래처복사',
		    		handler: function() {
		    			var field = panelResult.down('#customPopField2');
		    			field.openPopup('VALUE');
		    			//field.openPopup('TEXT');
		    		}
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{

    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid= Unilite.createGrid('map000ukrvGrid', {
    	region: 'center' ,
        layout: 'fit',
        excelTitle: '거래처별 기초잔액등록',
        tbar: [{
				xtype: 'splitbutton',
	           	itemId:'refTool',
				text: '<t:message code="system.label.purchase.reference" default="참조..."/>',
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
			}],
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns: [
        	{dataIndex:'COMP_CODE'		, width: 88 ,hidden: true},
        	{dataIndex:'DIV_CODE'		, width: 88 ,hidden: true},
        	//{dataIndex:'BASIS_YYYYMM'	, width: 88 },
        	{dataIndex: 'CUSTOM_CODE'	 	,width:106,
					editor: Unilite.popup('CUST_G',{
						textFieldName: 'CUSTOM_CODE',
						DBtextFieldName: 'CUSTOM_CODE',
		   	 			autoPopup: true,	
						listeners:{ 
							'onSelected': {
		                    	fn: function(records, type  ){
//			                    	var grdRecord = masterGrid.getSelectedRecord();
		                    		var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
									grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
		                    	},
	                    		scope: this
              	   			},
							'onClear' : function(type)	{
//		                  		var grdRecord = masterGrid.getSelectedRecord();
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE','');
								grdRecord.set('CUSTOM_NAME','');
		                  	}
						}
					})
				},
				{dataIndex: 'CUSTOM_NAME'	 	,width:150,
					editor: Unilite.popup('CUST_G',{
		   	 			autoPopup: true,	
						listeners:{ 
							'onSelected': {
		                    	fn: function(records, type  ){
//			                    	var grdRecord = masterGrid.getSelectedRecord();
		                    		var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
									grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
		                    	},
	                    		scope: this
              	   			},
							'onClear' : function(type)	{
//		                  		var grdRecord = masterGrid.getSelectedRecord();
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE','');
								grdRecord.set('CUSTOM_NAME','');
		                  	}
						}
					})
				},
        	{dataIndex:'MONEY_UNIT'		, width: 88,align:'center'},
        	{dataIndex:'BASIS_AMT_O'	, width: 138},
        	{dataIndex:'CREATE_LOC'	 	, width: 88 ,hidden: true}
        ],
        listeners: {
			beforeedit  : function( editor, e, eOpts ) {
			if(e.record.phantom){
				if(UniUtils.indexOf(e.field, ['CUSTOM_CODE','CUSTOM_NAME','MONEY_UNIT','BASIS_AMT_O'])){
					return true;
				}else{
					return false;
				}
			} else {
				if(e.field == 'BASIS_AMT_O'){
					return true;
				}else{
					return false;
				}
			}
			}
		},
        setItemData: function(record, dataClear) {
       		var grdRecord = this.getSelectedRecord();
       		if(dataClear) {
       	
       		} else {
       			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
       			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
	
       		}
		},
	    	setExcelData: function(record) {
				var grdRecord = this.getSelectedRecord();
				
				grdRecord.set('CUSTOM_CODE'		    		, record['CUSTOM_CODE']);
				grdRecord.set('CUSTOM_NAME'		    		, record['CUSTOM_NAME']);
				grdRecord.set('MONEY_UNIT'	    			, record['MONEY_UNIT']);
				grdRecord.set('BASIS_AMT_O'    				, record['BASIS_AMT_O']);
			}
    });		// End of masterGrid= Unilite.createGrid('map000ukrvGrid', {
	
    function openExcelWindow() {
		//if(!UniAppManager.app.checkForNewDetail()) return false;
		var me = this;
	    var vParam = {};
	    var appName = 'Unilite.com.excel.ExcelUploadWin';

        if(!excelWindow) {
        	excelWindow =  Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
	    		modal: false,
	    		excelConfigName: 'map000',
	    		
	            grids: [{
	            	itemId: 'grid01',
	            	title: '거래처 기초잔액 업로드',                        		
	            	useCheckbox: true,
	            	model : 'excel.map000.sheet01',
	            	readApi: 'map000ukrvService.selectExcelUploadSheet',
	            	columns: [
                 		
			        	
			        	{dataIndex: 'CUSTOM_CODE'	 ,width:106,
								editor: Unilite.popup('CUST_G',{
									textFieldName: 'CUSTOM_CODE',
									DBtextFieldName: 'CUSTOM_CODE',
		   	 						autoPopup: true,		
									listeners:{ 
										'onSelected': {
					                    	fn: function(records, type  ){
//						                    	var grdRecord = masterGrid.getSelectedRecord();
					                    		var grdRecord = masterGrid.uniOpt.currentRecord;
												grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
												grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
					                    	},
				                    		scope: this
			              	   			},
										'onClear' : function(type)	{
//					                  		var grdRecord = masterGrid.getSelectedRecord();
											var grdRecord = masterGrid.uniOpt.currentRecord;
											grdRecord.set('CUSTOM_CODE','');
											grdRecord.set('CUSTOM_NAME','');
					                  	}
									}
								})
							},
						{dataIndex:'CUSTOM_NAME'	, width: 88},
			        	{dataIndex:'MONEY_UNIT'		, width: 88},
			        	{dataIndex:'BASIS_AMT_O'	, width: 138}
					],
                    listeners: {
		            	afterrender: function(grid) {	
					    	var me = this;
					    	this.contextMenu = Ext.create('Ext.menu.Menu', {});
					     	this.contextMenu.add({	
									text: '거래처등록',   iconCls : '',
							        handler: function(menuItem, event) {	
							        	var records = grid.getSelectionModel().getSelection();
							         	var record = records[0];
										var params = {
											appId: UniAppManager.getApp().id,
											sender: me,
											action: 'excelNew',
											_EXCEL_JOBID: excelWindow.jobID,			
											_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'),	
											CUSTOM_CODE: record.get('CUSTOM_CODE')
										}
										var rec = {data : {prgID : 'bcm100ukrv', 'text':''}};									
										parent.openTab(rec, '/base/bcm100ukrv.do', params);														
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
						masterGrid.setExcelData(record.data);								        
					}); 
					grid.getStore().remove(records);
                }
              });
            }
            excelWindow.center();
            excelWindow.show();
	}
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			masterForm  	
		],	
		id: 'map000ukrvApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			var param = {"DIV_CODE": masterForm.getValue('DIV_CODE')};
			map000ukrvService.checkBasisYM(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
				masterForm.setValue('BASIS_YYYYMM', provider['BASIS_YYYYMM']);
				panelResult.setValue('BASIS_YYYYMM', provider['BASIS_YYYYMM']);
			
					if(provider['BASIS_YYYYMM'] != null){
						Ext.getCmp('baseYM').setReadOnly(true);
						Ext.getCmp('baseYM2').setReadOnly(true);
					}else{
						Ext.getCmp('baseYM').setReadOnly(false);
						Ext.getCmp('baseYM2').setReadOnly(false);
					}
				}
			});
			
			//if(!Ext.isEmpty(masterForm.getValue('BASIS_YYYYMM'))){
		/*	if(masterForm.getValue('BASIS_YYYYMM') != null){
				Ext.getCmp('baseYM').setReadOnly(true);
			}*/
		//	panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			/*if(masterForm.getValue('BASIS_YYYYMM') != ''){	//재검토
				Ext.getCmp('baseYM').setReadOnly(true);
			}else{
				Ext.getCmp('baseYM').setReadOnly(false);
			}*/
			UniAppManager.setToolbarButtons(['newData','reset', 'prev', 'next'], true);
			this.setDefault();
		},
		onQueryButtonDown: function()	{
			if(!UniAppManager.app.checkForNewDetail() || !UniAppManager.app.checkForNewDetail2()){
				return false;
			}else{
				directMasterStore1.loadStoreRecords();	
			}
		},
		onNewDataButtonDown: function()	{
			
			if(!this.checkForNewDetail()||!this.checkForNewDetail2()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
            	 var divCode = masterForm.getValue('DIV_CODE');
            	 var moneyUnit = BsaCodeInfo.gsDefaultMoney; 
				var createLoc = '1'; 
            	 var r = {
					
					DIV_CODE: divCode,  
					MONEY_UNIT: moneyUnit,
					CREATE_LOC: createLoc
		        };
				masterGrid.createRow(r);
			//	masterForm.setAllFieldsReadOnly(false);
			},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
		//	this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {	
			
				directMasterStore1.saveStore();
			
			
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{				
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				
					masterGrid.deleteSelectedRow();
				
			}
		},
		onDeleteAllButtonDown: function() {			
			var records = directMasterStore1.data.items;
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
		},
		setDefault: function() {
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
		},
		checkForNewDetail:function() { 
			return masterForm.setAllFieldsReadOnly(true);
				 //  panelResult.setAllFieldsReadOnly(true);
        },
        checkForNewDetail2:function() { 
			return  panelResult.setAllFieldsReadOnly(true);
        }
        
		
		
	});		// End of Unilite.Main({
	
	Unilite.createValidator('formValidator', {
		forms: {'formA:':masterForm},		
		validate: function( type, fieldName, newValue, oldValue) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			switch(fieldName) {	
				case "BASIS_YYYYMM" :
					masterForm.setValue('LAST_YYYYMM',UniDate.add(newValue, {months:-1}));
				break;
			}
			return rv;
		}
	}); 
	Unilite.createValidator('formValidator2', {
		forms: {'formA:':panelResult},		
		validate: function( type, fieldName, newValue, oldValue) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			switch(fieldName) {	
				case "BASIS_YYYYMM" :
					masterForm.setValue('LAST_YYYYMM',UniDate.add(newValue, {months:-1}));
				break;
			}
			return rv;
		}
	}); 
};
</script>
