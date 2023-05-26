<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr105ukrv"  >
<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="B020" /><!-- 품목계정 -->
</t:appConfig>
<script type="text/javascript" >
//var detailWin;
var excelWindow;	// 엑셀참조

function appMain() {
	/**
	 * Master Model
	 */				
	 
	Unilite.defineModel('bpr105ukrvModel', {
		fields: [
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'},
			{ name: '',  			text: '', 		type : 'string'}
		]
	});
	
	var masterGrid = Unilite.createGrid('biv105ukrvGrid', {		
	layout : 'fit',
        region:'center',
    	uniOpt: {
			expandLastColumn: false,
		 	useRowNumberer: true,
		 	useContextMenu: true
        },
        margin: 0,
         tbar: [{
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
		}],
        store: directMasterStore,
        features: [ 
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	    {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} 
    	],
		columns: [
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80},
			{dataIndex: '' 		 		 	, 		width: 80}
		],
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(!e.record.phantom) {
	        		if(UniUtils.indexOf(e.field, ['SALES_TYPE', 'PURCHASE_TYPE', 'SALE_P', 'PURCHASE_P', 'PURCHASE_RATE', 
	        									  'GOOD_STOCK_Q', 'BAD_STOCK_Q', 'AVERAGE_P', 'STOCK_I', 'LOT_NO'])) 
					{ 
						return true;
      				} else {
      					return false;
      				}
	        	} else {
	        		if(UniUtils.indexOf(e.field, ['SALES_TYPE', 'PURCHASE_TYPE', 'SALE_P', 'PURCHASE_P', 'PURCHASE_RATE', 
	        									  'GOOD_STOCK_Q', 'BAD_STOCK_Q', 'AVERAGE_P', 'STOCK_I', 'LOT_NO']))
				   	{
						return true;
      				} else {
      					return false;
      				}
	        	}
	        }
		},
		setExcelData: function(record) {
			var CountDate = UniDate.getDbDateStr(panelSearch.getValue('COUNT_DATE')).substring(0, 6);
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
			grdRecord.set('' 			, record['']);
		}
    });	//End of var masterGrid = Unilite.createGrid('biv105ukrvGrid1', { 
	
	// 엑셀참조
	Unilite.Excel.defineModel('excel.biv105.sheet01', {
	    fields: [
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'},
	    	{name: '' 		 		 ,text:''		,type: 'string'}
	    ]
	});
	
	function openExcelWindow() {
		
			var me = this;
	        var vParam = {};
	        var appName = 'Unilite.com.excel.ExcelUploadWin';

            
            if(!excelWindow) {
            	excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
                		modal: false,
                		excelConfigName: 'biv105',
                		/*extParam: { 
                			'DIV_CODE': panelSearch.getValue('DIV_CODE'),
                			'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')
                		},*/
                        grids: [{
                        		itemId: 'grid01',
                        		title: '기초재고정보',                        		
                        		useCheckbox: true,
                        		model : 'excel.biv105.sheet01',
                        		readApi: 'biv105ukrvService.selectExcelUploadSheet1',
                        		columns: [
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80},
                        			{dataIndex: '' 		 		 	, 		width: 80}
                        		]
                        }],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
                        },
                        onApply:function()	{
							//excelWindow.getEl().mask('로딩중...','loading-indicator');
                        	var grid = this.down('#grid01');
                			var records = grid.getSelectionModel().getSelection();       		
							Ext.each(records, function(record,i){	
						        	UniAppManager.app.onNewDataButtonDown();
						        	masterGrid.setExcelData(record.data);
						        	//masterGrid.fnCulcSet(record.data);
						    }); 
							grid.getStore().remove(records);
                		}
                 });
            }
            excelWindow.center();
            excelWindow.show();
	}
	
	/**
	 * Master Store
	 */
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bpr105ukrvService.selectDetailList',
			update: 'bpr105ukrvService.updateDetail',
			create: 'bpr105ukrvService.insertDetail',
			destroy: 'bpr105ukrvService.deleteDetail',
			syncAll: 'bpr105ukrvService.saveAll'
		}
	});
	var directMasterStore = Unilite.createStore('bpr105ukrvMasterStore',{
			model: 'bpr105ukrvModel',
           	autoLoad: false,
        	uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
           	proxy: directProxy
			,listeners: {
	            write: function(proxy, operation){
	                if (operation.action == 'destroy') {
	                	Ext.getCmp('goodDetailForm').reset();			         
	                }
            	}
        	}
        	,loadStoreRecords : function()	{
				var param= panelSearch.getValues();
				param.FR_DIV_CODE = panelResult.getValue('FR_DIV_CODE');
				console.log( param );
				this.load({
					params : param,
					callback : function(records, operation, success) {
						if(success)	{
    						
						}
					}
				});
				
			}
			,saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
	
				var toCreate = this.getNewRecords();
	       		var toUpdate = this.getUpdatedRecords();        		
	       		var toDelete = this.getRemovedRecords();
	       		var list = [].concat(toUpdate, toCreate);
	       		console.log("inValidRecords : ", inValidRecs);
				console.log("list:", list);
				console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
				
				//1. 마스터 정보 파라미터 구성
				var paramMaster= panelSearch.getValues();	//syncAll 수정
				paramMaster.MONEY_UNIT = BsaCodeInfo.gsMoneyUnit;

				
				
				if(inValidRecs.length == 0) {
					config = {
						params: [paramMaster],
						
						success: function(batch, option) {
							//2.마스터 정보(Server 측 처리 시 가공)
							/*var master = batch.operations[0].getResultSet();
							panelSearch.setValue("ORDER_NUM", master.ORDER_NUM);*/
							//3.기타 처리
							panelSearch.getForm().wasDirty = false;
							panelSearch.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);		
						} 
					};
					this.syncAllDirect(config);
				} else {
	                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
       		defaultType: 'uniTextfield',
	   		items : [{					
					fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					value: '01',
					holdable: 'hold',
					child:'WH_CODE',
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '업로드 일자',
					name: 'COUNT_DATE',
					xtype: 'uniDatefield',
					value: new Date(),
					holdable: 'hold',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('COUNT_DATE', newValue);
						}
					}
				},{
					name: 'ITEM_ACCOUNT',
					fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
					xtype:'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				}, 
				Unilite.popup('DIV_PUMOK',{ 
		        	fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
		        	valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME', 
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));	
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
		   })]
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

				   	Unilite.messageBox(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 1},
		items: [{     
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
       		defaultType: 'uniTextfield',
	   		items : [{					
					fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					value: '01',
					holdable: 'hold',
					child:'WH_CODE',
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '업로드 일자',
					name: 'COUNT_DATE',
					xtype: 'uniDatefield',
					value: new Date(),
					holdable: 'hold',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('COUNT_DATE', newValue);
						}
					}
				},{
					name: 'ITEM_ACCOUNT',
					fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
					xtype:'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				}, 
				Unilite.popup('DIV_PUMOK',{ 
		        	fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
		        	valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME', 
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
								panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));	
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
		   })]
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

				   	Unilite.messageBox(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}	
    });
	   
     Unilite.Main({
      	id  : 'bpr105ukrvApp',
		borderItems : [{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
			this.setDefault();
		},
	    onQueryButtonDown: function () {    	// 조회버튼 눌렀을떄    
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			UniAppManager.setToolbarButtons('newData', true); 	
			directMasterStore.loadStoreRecords();
		},
		setDefault: function() {		// 기본값
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.getForm().wasDirty = false;
         	panelSearch.resetDirtyStatus();                            
         	UniAppManager.setToolbarButtons('save', false); 
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
			directMasterStore.clearData();
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			var a = panelSearch.getValue('COUNT_DATE');
			var sBasisYyyymm = UniDate.getDbDateStr(a).substring(0, 4) + "년 " + UniDate.getDbDateStr(a).substring(4, 6) + "월 ";
			if(confirm(Msg.sMB104 + ' ' + sBasisYyyymm + Msg.sMB105)) {
				directMasterStore.saveStore();
			} else {
				
			}
		},
		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			var selRow1 = masterGrid.getSelectedRecord();
			if(selRow1.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onNewDataButtonDown : function()	{        	 
        	 var moneyUnit = UserInfo.currency;
        	 var saleDate = UniDate.get('today');
        	 var r = {
				MONEY_UNIT: moneyUnit,
				SALE_DATE: saleDate,
				DIV_CODE: panelSearch.getValue('DIV_CODE')
	        };	        
			masterGrid.createRow(r);
			//openDetailWindow(null, true);
		},
		onPrevDataButtonDown:  function()	{			
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();			
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		},
		/**
		 *  삭제
		 *	@param 
		 *	@return
		 */
		 onDeleteDataButtonDown: function() {
		 	var record = masterGrid.getSelectedRecord();
		 	var param= {ITEM_CODE : record.get('ITEM_CODE'), DIV_CODE: record.get('DIV_CODE')}
		 	bpr105ukrvService.checkExistBpr400tInfo(param, function(provider, response)	{
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {				
						masterGrid.deleteSelectedRow();		
				}
			});
			
		},
		/**
		 *  저장
		 *	@param 
		 *	@return
		 */
		onSaveDataButtonDown: function (config) {
			var rtnrecord = masterGrid.getSelectedRecord();
			if(!Ext.isEmpty(rtnrecord)){
				if(Ext.isEmpty(rtnrecord.get('SALE_DATE'))){
					rtnrecord.set('SALE_DATE', UniDate.get('today'))
				}
			}
//			rtnrecord.set('TO_DIV_CODE', panelSearch.getValue('TO_DIV_CODE'))
			directMasterStore.saveStore(config);			
		}
		,onResetButtonDown:function() {			
			panelSearch.clearForm();			
//			goodDetailForm.clearForm();
			directMasterStore.removeAll();
			if(activeSubGrid) activeSubGrid.reset();
			detailForm.show();
			
			goodDetailForm.hide();
			bookDetailForm.hide();
			activeSubGrid = detailFormSubGrid;
			this.fnInitBinding();
		},
		onSaveAndQueryButtonDown : function()	{
			this.onSaveDataButtonDown();
			//this.onQueryButtonDown();
		},
		saveStoreEvent: function(str, newCard)	{
			var config = null;
			this.onSaveDataButtonDown(config);
		}, // end saveStoreEvent()
//		
//		rejectSave: function()	{
//			var rowIndex = masterGrid.getSelectedRowIndex();			
//			directMasterStore.rejectChanges();
//			if(masterGrid.getStore().getCount() > 0)	{
//				masterGrid.select(rowIndex);
//			}
//			directMasterStore.onStoreActionEnable();
//		} // end rejectSave()
		
		rejectSave: function() {			
			directMasterStore.rejectChanges();	
			directMasterStore.onStoreActionEnable();
		},
		 confirmSaveData: function(config)	{
        	if(directMasterStore.isDirty() )	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
					goodDetailForm.resetDirtyStatus();
					//if (detailWin.isVisible())	detailWin.hide();
				}
			}			
        }
	});
	
	Unilite.createValidator('masterGridValidator', {
		store : directMasterStore,
		grid: masterGrid,
		forms: {'formA:':goodDetailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			if(fieldName == "SALE_BASIS_P" )	{	
					if(newValue < 0 ) {
						 rv='<t:message code="unilite.msg.sMB076" default="양수만 입력가능합니다."/>';
					}else{
						var rtnRecord = masterGrid.getSelectedRecord();
						rtnRecord.set('BF_SALE_BASIS_P', rtnRecord.get('SALE_BASIS_P'));
						rtnRecord.set('SALE_DATE', UniDate.get('today'));
					}
					
			}
			return rv;
		}
	}); // validator
};


</script>

