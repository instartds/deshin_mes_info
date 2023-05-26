<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mro200ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var outDivCode=UserInfo.divCode;
function appMain() {   

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		
		api: {
			read: 'mro200ukrvService.selectDetailList',
			update: 'mro200ukrvService.updateDetail',
			create: 'mro200ukrvService.insertDetail',
			destroy: 'mro200ukrvService.deleteDetail',
			syncAll: 'mro200ukrvService.saveAll'
		}
	});
	
	/**
	 * main Model 정의 
	 * @type  
	 */
	Unilite.defineModel('mro200ukrvModel', {
	    fields: [  	 
	    	{name:'DIV_CODE'            ,text: '<t:message code="system.label.product.division" default="사업장"/>'	,type: 'string',editable:false},
			{name:'REQ_YYYYMM'     		,text: '<t:message code="system.label.product.requestmonth" default="요청월"/>'		,type:'string' , allowBlank: false,editable:false},
			{name:'REQ_DATE'			,text: '<t:message code="system.label.product.requestdate" default="요청일"/>'		,type: 'uniDate'},
//			{name:'SER_NO'     			,text: '<t:message code="system.label.product.seq" default="순번"/>'		,type:'int'	, allowBlank: false},
			{name:'ITEM_CODE'     		,text: '<t:message code="system.label.product.item" default="품목"/>'		,type:'string'	, allowBlank: false},
			{name:'ITEM_NAME'      		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'		,type:'string'	, allowBlank: false},
			{name:'SPEC'       			,text: '<t:message code="system.label.product.spec" default="규격"/>'			,type:'string'	},
			{name:'REQ_Q'				,text: '<t:message code="system.label.product.requestqty" default="요청량"/>'		,type: 'uniQty'},
			{name:'REQ_P'				,text: '<t:message code="system.label.product.requestprice" default="요청단가"/>'		,type: 'uniUnitPrice'},
			{name:'REQ_O'				,text: '<t:message code="system.label.product.requestamount" default="요청금액"/>'		,type: 'uniPrice'},
			{name:'WORKSHOP'			,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'	,type: 'string'},
			{name:'WORKSHOP_NAME'		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		,type: 'string'},
			{name:'PJT_CODE'			,text: '<t:message code="system.label.product.projectcode" default="프로젝트코드"/>'	,type: 'string'},
			{name:'REMARK'     			,text: '<t:message code="system.label.product.remarks" default="비고"/>'			,type:'string'}
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
	var directMasterStore1 = Unilite.createStore('mro200ukrvMasterStore1',{
		model: 'mro200ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()	{
			var param= panelSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
			
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		

					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('mro200ukrvGrid1');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
//				 alert(Msg.sMB083);
			}
		}
	});
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
    	defaultType: 'uniSearchSubPanel',
    	listeners: {
        	collapse: function () {
            	panelResult.show();
        	},
        	expand: function() {
        		panelResult.hide();
        	}
    	},
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				value: UserInfo.divCode,
				allowBlank: false,
				listeners:{
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
				
					}
				}
				},
				Unilite.popup('DIV_PUMOK', { // 20210824 추가: 품목 조회조건 정규화
		  			fieldLabel: '품목',
		  			valueFieldName: 'ITEM_CODE',
		  			textFieldName: 'ITEM_NAME',
                    useBarcodeScanner: false,
	                validateBlank: false,
                    listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						},
                applyextparam: function(popup){
                    var divCode = panelSearch.getValue('DIV_CODE');
                    popup.setExtParam({'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
                }
                }
        }),{
                fieldLabel: '<t:message code="system.label.product.requestmonth" default="요청월"/>',
                xtype     : 'uniMonthfield',
                name      : 'REQ_YYYYMM',
                allowBlank: false,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('REQ_YYYYMM', newValue);
			     	}
			    }
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
		          		var labelText = invalid.items[0]['fieldLabel']+' : ';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
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
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
	    items: [{	
	    	xtype:'container',
	    	padding:'0 5 5 5',
	        defaultType: 'uniTextfield',
	        layout: {type: 'uniTable', columns : 3},
	        items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				value: UserInfo.divCode,
				allowBlank: false,
				listeners:{
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
				
					}
				}
				},Unilite.popup('DIV_PUMOK', { // 20210824 추가: 품목 조회조건 정규화
		  			fieldLabel: '품목',
		  			valueFieldName: 'ITEM_CODE',
		  			textFieldName: 'ITEM_NAME',
                    useBarcodeScanner: false,
	                validateBlank: false,
                    listeners: {						
                    onValueFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						},
                        applyextparam: function(popup){
                            var divCode = panelResult.getValue('DIV_CODE');
                            popup.setExtParam({'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
                        }
                    }
            }),{
                fieldLabel: '<t:message code="system.label.product.requestmonth" default="요청월"/>',
                xtype     : 'uniMonthfield',
                name      : 'REQ_YYYYMM',
                allowBlank: false,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelSearch.setValue('REQ_YYYYMM', newValue);
			     	}
			    }
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
		          		var labelText = invalid.items[0]['fieldLabel']+' : ';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
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
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid1 = Unilite.createGrid('mro200ukrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
    	store: directMasterStore1,
    	features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],
        columns: [        			
			{dataIndex: 'DIV_CODE'      	, width: 120,hidden:true}, 	
			{dataIndex: 'REQ_DATE'      	, width: 80},
//			{dataIndex: 'SER_NO'      		, width: 120}, 							 							
			{dataIndex: 'REQ_YYYYMM'      	, width: 120,hidden:true}, 							 										 							 							
			{dataIndex: 'ITEM_CODE'      	, width: 120,
        		editor: Unilite.popup('DIV_PUMOK_G', {
        			textFieldName: 'ITEM_CODE',
                    DBtextFieldName: 'ITEM_CODE',
                    useBarcodeScanner: false,
	                autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var record=masterGrid1.uniOpt.currentRecord;
								record.set("ITEM_CODE",records[0].ITEM_CODE);
								record.set("ITEM_NAME",records[0].ITEM_NAME);
								record.set("SPEC",records[0].SPEC);
								record.set("REQ_P",records[0].PURCHASE_BASE_P);
							},
							scope: this
						},
						'onClear': function(type) {
							var record=masterGrid1.uniOpt.currentRecord;
							record.set("ITEM_CODE",'');
							record.set("ITEM_NAME",'');
							record.set("SPEC",'');
							record.set("REQ_P",0);
						},
						applyextparam: function(popup){
							var divCode = panelResult.getValue('DIV_CODE');
                            popup.setExtParam({'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})}, 							 							
			{dataIndex: 'ITEM_NAME'      	, width: 150,
	        		editor: Unilite.popup('DIV_PUMOK_G', {
	        			autoPopup: true,
						listeners: {
							'onSelected': {
								fn: function(records, type) {
									var record=masterGrid1.uniOpt.currentRecord;
									record.set("ITEM_CODE",records[0].ITEM_CODE);
									record.set("ITEM_NAME",records[0].ITEM_NAME);
									record.set("SPEC",records[0].SPEC);
									record.set("REQ_P",records[0].PURCHASE_BASE_P);
								},
								scope: this
							},
							'onClear': function(type) {
								var record=masterGrid1.uniOpt.currentRecord;
								record.set("ITEM_CODE",'');
								record.set("ITEM_NAME",'');
								record.set("SPEC",'');
								record.set("REQ_P",0);
							},
							applyextparam: function(popup){	
								var divCode = panelResult.getValue('DIV_CODE');
                                popup.setExtParam({'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
							}
						}
					})}, 							 							
			{dataIndex: 'SPEC'      		, width: 150}, 							 							
			{dataIndex: 'REQ_Q'      		, width: 150}, 							 							
			{dataIndex: 'REQ_P'      		, width: 150}, 							 							
			{dataIndex: 'REQ_O'      		, width: 150}, 							 							
			{dataIndex:'WORKSHOP'			, width: 80,
        		editor: Unilite.popup('WORK_SHOP_G', {
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var record=masterGrid1.uniOpt.currentRecord;
								record.set("WORKSHOP",records[0].TREE_CODE);
								record.set("WORKSHOP_NAME",records[0].TREE_NAME);
							},
							scope: this
						},
						'onClear': function(type) {
							var record=masterGrid1.uniOpt.currentRecord;
							record.set("WORKSHOP",'');
							record.set("WORKSHOP_NAME",'');
						},
						applyextparam: function(popup){				
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'TYPE_LEVEL': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex:'WORKSHOP_NAME'			, width: 150 ,
        		editor: Unilite.popup('WORK_SHOP_G', {
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var record=masterGrid1.uniOpt.currentRecord;
								record.set("WORKSHOP",records[0].TREE_CODE);
								record.set("WORKSHOP_NAME",records[0].TREE_NAME);
							},
							scope: this
						},
						'onClear': function(type) {
							var record=masterGrid1.uniOpt.currentRecord;
							record.set("WORKSHOP",'');
							record.set("WORKSHOP_NAME",'');
						},
						applyextparam: function(popup){		
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'TYPE_LEVEL': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'PJT_CODE'      	, width: 150,
        		editor: Unilite.popup('PJT_TREE_G', {
					extParam: { DIV_CODE: outDivCode},
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var record=masterGrid1.uniOpt.currentRecord;
								record.set("PJT_CODE",records[0].PJT_CODE);
							},
							scope: this
						},
						'onClear': function(type) {
							var record=masterGrid1.uniOpt.currentRecord;
							record.set("PJT_CODE",'');
						},
						applyextparam: function(popup){							
							var divCode = panelResult.getValue('DIV_CODE');
                            popup.setExtParam({'PJT_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			}, 							 							
			{dataIndex: 'REMARK'      		, width: 150} 							 							
		],
        listeners: {
        	render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			 	var store = grid.getStore();
			    grid.getEl().on('click', function(e, t, eOpt) {
					
			    });
			}
           ,beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom) 
				{
					if (UniUtils.indexOf(e.field,['ITEM_CODE'])) {
						return false;
					}
/*				}else
				{
					if (UniUtils.indexOf(e.field,['SER_NO'])) {
						return false;
					}*/
				}
			},
        	selectionchange:function( model1, selected, eOpts ){
          	}
        },
       	returnCell: function(record){
        }
    });
    
    Unilite.Main( {
    	borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[panelResult,
					{
						region : 'west',
						xtype : 'container',
						layout : 'fit',
//						width : 1000, 
						flex : 200,
						items : [ masterGrid1 ]
					}
				]	
			}		
			,panelSearch 
		], 
		id: 'mro200ukrvApp',
		fnInitBinding: function(params) {
			panelSearch.setValue('REQ_YYYYMM',UniDate.get('startOfMonth'));
			panelResult.setValue('REQ_YYYYMM',UniDate.get('startOfMonth'));
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['newData'], true);
			this.onQueryButtonDown();
		},
		onQueryButtonDown : function()	{	
			if(!panelSearch.setAllFieldsReadOnly(true)){return};
			directMasterStore1.loadStoreRecords();	
			UniAppManager.setToolbarButtons('reset',true);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		setDefault: function() {
			panelSearch.setValue('REQ_YYYYMM',UniDate.get('startOfMonth'));
			panelResult.setValue('REQ_YYYYMM',UniDate.get('startOfMonth'));
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();		
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();										
			UniAppManager.setToolbarButtons('save', false);	
		},
		onResetButtonDown: function() {		// 새로고침 버튼
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			directMasterStore1.loadData({});
			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save', false);
		},
		onNewDataButtonDown: function()	{
			
				 var REQ_YYYYMM		 =  UniDate.getDbDateStr(panelResult.getValue('REQ_YYYYMM')).substr(0,6);
//				 var seq = directMasterStore1.max('SER_NO');
//	        	 if(!seq) seq = 1;
//	        	 else  seq += 1;
	        	 var REQ_DATE		 =  dateToString(new Date());
                 var TREE_CODE       =  '';
                 var TREE_NAME     	 =  '';
                 var SPEC     		 =  '';
                 var REQ_Q      	 =   0;
                 var REQ_P      	 =   0;
                 var REQ_O      	 =   0;
                 var WORKSHOP      	 =   '';
                 var PJT_CODE      	 =   '';
                 var remark          =  '';
                 
                 var r = {
                		 DIV_CODE		 : UserInfo.divCode,
                		 REQ_YYYYMM		 : REQ_YYYYMM,
                		 REQ_DATE		 : REQ_DATE,
//                		 SER_NO		 	 : seq,
                		 TREE_CODE       : TREE_CODE,
                		 TREE_NAME       : TREE_NAME,
                		 SPEC      		 : SPEC,
                		 REQ_Q      	 : REQ_Q,
                		 REQ_P      	 : REQ_P,
                		 REQ_O      	 : REQ_O,
                		 WORKSHOP      	 : WORKSHOP,
                		 PJT_CODE        : PJT_CODE,
                   		 REMARK          : remark
                };
                masterGrid1.createRow(r, masterGrid1.getStore().getCount() - 1);
		},
        checkForNewDetail:function() { 
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onSaveDataButtonDown: function(config) {
			//총인원 체크
			var selected = masterGrid1.getSelectedRecord();
			if(directMasterStore1.isDirty()){
			 directMasterStore1.saveStore();
			}
		},
		rejectSave: function() {
			var rowIndex = masterGrid1.getSelectedRowIndex();
				masterGrid1.select(rowIndex);
				directMasterStore1.rejectChanges();
				
				if(rowIndex >= 0){
					masterGrid1.getSelectionModel().select(rowIndex);
					var selected = masterGrid1.getSelectedRecord();
				}
				directMasterStore1.onStoreActionEnable();

		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('mro200ukrvFileUploadPanel');
        	if(detailStore.isDirty() || fp.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		onDeleteDataButtonDown: function() {
			
    		if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
        		masterGrid1.deleteSelectedRow();
    		}
			
			if(masterGrid1.getStore().getCount() >0){
    			UniAppManager.setToolbarButtons('save', true);
			}
		},
		fnCalOrderAmt: function(rtnRecord, sType, nValue) { 
			var dOrderUnitQ= sType =='Q' ? nValue : Unilite.nvl(rtnRecord.get('REQ_Q'),0);
			var dOrderUnitP= sType =='P' ? nValue : Unilite.nvl(rtnRecord.get('REQ_P'),0);
			var dOrderO= sType =='O' ? nValue : Unilite.nvl(rtnRecord.get('REQ_O'),0); 
			var dOrderQ;
			var dOrderP;
			
			if(sType == 'P' || sType == 'Q'){
				dOrderO = (dOrderUnitQ * (dOrderUnitP * 1000)) / 1000
				dOrderO = dOrderO.toFixed(3);
				rtnRecord.set('REQ_O', dOrderO);
				
				dOrderQ = dOrderUnitQ;
				rtnRecord.set('REQ_Q', dOrderQ);
				
				dOrderP = dOrderUnitP ;
				rtnRecord.set('REQ_P', dOrderP);
				
			}else if(sType == 'O'){
				if(Math.abs(dOrderUnitQ) > '0'){
					rtnRecord.set('REQ_P', dOrderUnitP);
				}else{
					rtnRecord.set('ORDER_P', '0');
				}
			}
		}
	});
    Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {	
				case "REQ_Q" : //발주순번
					if(newValue < 0){
						rv='<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
						break;	
					}
					UniAppManager.app.fnCalOrderAmt(record, "Q", newValue);
				break;
				
				case "REQ_P" :
					if(newValue < 0){
						rv='<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
						break;	
					}
					UniAppManager.app.fnCalOrderAmt(record, "P", newValue);
					break;
					
				case "REQ_O":
					if(newValue < 0){
						rv='<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
						break;	
					}
					UniAppManager.app.fnCalOrderAmt(record, "O", newValue);
					break;
			}
			return rv;
		}
	});
	
};

</script>
