<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sva300ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sva300ukrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->	
	
</t:appConfig>
<script type="text/javascript" >

/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);
*/

var outDivCode = UserInfo.divCode;

function appMain() {   
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'sva300ukrvService.gridDown',
			update: 'sva300ukrvService.updateDetail',
			create: 'sva300ukrvService.insertDetail',
			destroy: 'sva300ukrvService.deleteDetail',
			syncAll: 'sva300ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('Sva300ukrvModel', {
	    fields: [  	 	    
			{name: 'COMP_CODE'	 	 ,text: '법인코드' 		,type: 'string'},
	    	{name: 'CUSTOM_CODE'	 ,text: '자판기번호' 		,type: 'string'},
	    	{name: 'CUSTOM_NAME'	 ,text: '자판기명' 		,type: 'string'},
	    	{name: 'WH_CODE'	 	 ,text: '창고명' 			,type: 'string',store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'ADDR1'	 	 	 ,text: '위치' 			,type: 'string'}
		]  
	});		//End of Unilite.defineModel('Sva300ukrvModel', {
	
	Unilite.defineModel('Sva300ukrvModel2', {
		fields: [  	 	    
			{name: 'COMP_CODE'	 			,text: '법인코드' 				,type: 'string'},
	    	{name: 'DIV_CODE'	 			,text: '사업장' 				,type: 'string'},
	    	{name: 'POS_NO'	 	 			,text: '자판기번호' 			,type: 'string'},
	    	{name: 'ITEM_CODE'	 			,text: '품목코드' 				,type: 'string',allowBlank:false},
	    	{name: 'ITEM_NAME'	 			,text: '품명' 				,type: 'string'},
	    	{name: 'INIT_Q'	 				,text: '기초재고' 				,type: 'uniQty'}
		]  
	});		//End of Unilite.defineModel('Sva300ukrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore1 = Unilite.createStore('sva300ukrvMasterStore1',{
		model: 'Sva300ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
           	editable: false,			// 수정 모드 사용 
           	deletable: false,			// 삭제 가능 여부 
	        useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
		proxy: {
				type: 'direct',
				api: {			
					read: 'sva300ukrvService.gridUp'                	
				}
			},
		loadStoreRecords: function() {
			var param= masterForm.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
	       	load: function(store, records, successful, eOpts) {
	       		if(records[0] != null){
	       			masterForm.setValue('GRID_CUSTOM_CODE',records[0].get('CUSTOM_CODE'));
	       			
	       			
	       		if((masterForm.getValue('GRID_CUSTOM_CODE') != '')) {
	       			directMasterStore2.loadStoreRecords(records);
	       		}
	       		}else{
	       			masterForm.setValue('GRID_CUSTOM_CODE','');
	       			
	           			masterGrid2.getStore().removeAll();
				}
			},
           	add: function(store, records, index, eOpts) {
           		
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           		
           	},
           	remove: function(store, record, index, isMove, eOpts) {	
           	}
		}
		
		
	});		// End of var directMasterStore1 = Unilite.createStore('sva300ukrvMasterStore1',{
	
	var directMasterStore2 = Unilite.createStore('sva300ukrvMasterStore2', {
		model: 'Sva300ukrvModel2',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
			autoLoad: false,
			/*proxy: {
				type: 'direct',
				api: {			
					read: 'sva300ukrvService.gridDown'                	
				}
			},*/
			proxy: directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
	//		param.DATE = UniDate.get('today'),
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
				var paramMaster= masterForm.getValues();
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
	});//End of var directMasterStore2 = Unilite.createStore('mms200ukrvMasterStore2', {
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var masterForm = Unilite.createSearchPanel('searchForm', {		
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
			items:[{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				holdable: 'hold',
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{ 
				fieldLabel: '기준년월',
				name: 'BASIS_YYYYMM',
	            xtype: 'uniMonthfield',
	            value: UniDate.get('today'),
	            allowBlank: false,
	            width: 200,
	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BASIS_YYYYMM', newValue);
					}
				}
	        },
			Unilite.popup('CUST', {
				fieldLabel: '자판기번호',
				valueFieldName:'CUSTOM_CODE',
		    	textFieldName:'CUSTOM_NAME',
				extParam:{'CUSTOM_TYPE': '5'},  
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
			}),
			{ 
				fieldLabel: '그리드의 자판기번호값',
				name: 'GRID_CUSTOM_CODE', 
				xtype: 'uniTextfield',
				hidden: true
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
    });		// End of var masterForm = Unilite.createSearchForm('searchForm',{    
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				holdable: 'hold',
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},{ 
				fieldLabel: '기준년월',
				name: 'BASIS_YYYYMM',
	            xtype: 'uniMonthfield',
	            value: UniDate.get('today'),
	            allowBlank: false,
	            width: 200,
	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('BASIS_YYYYMM', newValue);
					}
				}
	        },
			Unilite.popup('CUST', {
				fieldLabel: '자판기번호',
				valueFieldName:'CUSTOM_CODE',
		    	textFieldName:'CUSTOM_NAME',
				extParam:{'CUSTOM_TYPE': '5'}, 
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
			})],
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
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
   
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid= Unilite.createGrid('sva300ukrvGrid', {
    	region: 'west',
        layout: 'fit',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
	        onLoadSelectFirst : false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,   //그리드 설정 (우측)버튼 사용 여부
				useStateList: false  //그리드 설정 (죄측)목록 사용 여부
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
      			{dataIndex: 'COMP_CODE'		,width:80,hidden:true},
				{dataIndex: 'CUSTOM_CODE'	,width:100},
				{dataIndex: 'CUSTOM_NAME'	,width:200},
				{dataIndex: 'WH_CODE'		,width:150},
				{dataIndex: 'ADDR1'	 		,width:300}
        ],
        listeners: {
        	cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					masterForm.setValue('GRID_CUSTOM_CODE',record.get('CUSTOM_CODE'));
				
//					masterForm.setValue('SALE_COMMON_P',record.get('SALE_COMMON_P'));
					directMasterStore2.loadStoreRecords(record);
					UniAppManager.setToolbarButtons(['newData'], true);
				}
				beforeRowIndex = rowIndex;
			},
        	
			beforeedit  : function( editor, e, eOpts ) {
			
			}
		}
    });		// End of masterGrid= Unilite.createGrid('sva300ukrvGrid', {

	var masterGrid2 = Unilite.createGrid('sva300ukrvGrid2', {
		layout: 'fit',
		region: 'center',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
	        onLoadSelectFirst : false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'masterGridTotal', 	
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: directMasterStore2,
		columns: [
				{dataIndex: 'COMP_CODE'		,width:80,hidden:true},
				{dataIndex: 'DIV_CODE'		,width:80,hidden:true},
				{dataIndex: 'POS_NO'		,width:80,hidden:true},
				{dataIndex: 'ITEM_CODE'	 	,width:120,
					editor: Unilite.popup('DIV_PUMOK_G', {		
						textFieldName: 'ITEM_CODE',
						DBtextFieldName: 'ITEM_CODE',
						extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
						//validateBlank: false,
						useBarcodeScanner: false,
						listeners: {'onSelected': {
										fn: function(records, type) {
											console.log('records : ', records);
											Ext.each(records, function(record,i) {
												console.log('record',record);
												if(i==0) {
													masterGrid2.setItemData(record,false);
												} else {
													UniAppManager.app.onNewDataButtonDown();
													masterGrid2.setItemData(record,false);
												}
											}); 
										},
									scope: this
									},
									'onClear': function(type) {
										var a = masterGrid2.uniOpt.currentRecord.get('ITEM_CODE');
										
										masterGrid2.setItemData(null,true);
									//	if(masterGrid.uniOpt.currentRecord.get('ITEM_CODE') != ''){
										masterGrid2.uniOpt.currentRecord.set('ITEM_CODE',a);
									//	alert(a);
										if(a != ''){
											alert("미등록상품입니다.");
										}
										
									//	}
									}
						}
					})
				},
				{dataIndex: 'ITEM_NAME'	 	,width:300,
					editor: Unilite.popup('DIV_PUMOK_G', {
						extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
						listeners: {'onSelected': {
							fn: function(records, type) {
			                    console.log('records : ', records);
			                    Ext.each(records, function(record,i) {													                   
				        			if(i==0) {
										masterGrid2.setItemData(record,false);
				        			} else {
				        				UniAppManager.app.onNewDataButtonDown();
				        				masterGrid2.setItemData(record,false);
				        			}
								}); 
							},
							scope: this
							},
						'onClear': function(type) {
								masterGrid2.setItemData(null,true);
							}
						}
					})
				},
				{dataIndex: 'INIT_Q'		,width:80}
		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				UniAppManager.setToolbarButtons(['delete'], true);
				UniAppManager.setToolbarButtons(['newData'], true);
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom){
					
					if (UniUtils.indexOf(e.field, 
							['ITEM_CODE','ITEM_NAME','INIT_Q']))
							{	
								return true;
							}else{
								return false;
							}					
				}else{
					if(UniUtils.indexOf(e.field,['INIT_Q']))
						{	
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
       			grdRecord.set('ITEM_CODE'		,"");
       			grdRecord.set('ITEM_NAME'		,"");
       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
       			
       		}
		}
	});//End of var masterGrid = Unilite.createGrid('sva300ukrvGrid1', {
    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, masterGrid2, panelResult
			]
		},
			masterForm  	
		],	
		id: 'sva300ukrvApp',
		fnInitBinding: function() {
			//masterForm.getField('CUSTOM_CODE').focus();
			//panelResult.getField('CUSTOM_CODE').focus();
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			this.setDefault();
		},
		onQueryButtonDown: function()	{
			/*masterForm.setAllFieldsReadOnly(false);
			var orderNo = masterForm.getValue('ORDER_NUM');
			if(Ext.isEmpty(orderNo)) {
				openSearchInfoWindow() 
			} else {*/
			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				/*var param= masterForm.getValues();
				masterForm.uniOpt.inLoading=true;
				masterForm.getForm().load({
					params: param,
					success: function()	{
						masterForm.setAllFieldsReadOnly(true)

						masterForm.uniOpt.inLoading=false;
					},
					failure: function(form, action) {
                        masterForm.uniOpt.inLoading=false;
                    }
				})*/
				directMasterStore1.loadStoreRecords();	
				beforeRowIndex = -1;	
				
				UniAppManager.setToolbarButtons(['delete'], false);
				masterForm.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				var compCode = UserInfo.compCode; 
				var divCode = masterForm.getValue('DIV_CODE');
				var posCode = masterForm.getValue('GRID_CUSTOM_CODE');
				
            	 var r = {
            	 	COMP_CODE:		compCode,
            	 	DIV_CODE:		divCode,
            	 	POS_NO:			posCode
            	 
		        };
				masterGrid2.createRow(r);
				
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterGrid2.reset();
			panelResult.clearForm();
			UniAppManager.setToolbarButtons(['newData'], false);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore2.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid2.getSelectedRecord();
			if(selRow.phantom === true)	{				
				masterGrid2.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
//				if(selRow.get('ITEM_CODE') > 1)
//				{
//					alert('<t:message code="unilite.msg.sMM435"/>');
//				}else{
					masterGrid2.deleteSelectedRow();
//				}
			}
		},
		setDefault: function() {
        	masterForm.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	masterForm.setValue('BASIS_YYYYMM',UniDate.get('today'));
        	panelResult.setValue('BASIS_YYYYMM',UniDate.get('today'));
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
		},
		checkForNewDetail:function() { 			
			return masterForm.setAllFieldsReadOnly(true);
        }
		
		
	});		// End of Unilite.Main({
};
</script>
