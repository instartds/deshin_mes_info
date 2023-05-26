<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sva100ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sva100ukrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->	
	<t:ExtComboStore items="${COMBO_VENDING_MACHINE_NO}" storeId="MachineNo" /><!--자판기명-->	
	
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
			read: 'sva100ukrvService.gridDown',
			update: 'sva100ukrvService.updateDetail',
			create: 'sva100ukrvService.insertDetail',
			destroy: 'sva100ukrvService.deleteDetail',
			syncAll: 'sva100ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('Sva100ukrvModel', {
	    fields: [  	 	    
			{name: 'COMP_CODE'	 		 ,text: '법인코드' 		,type: 'string'},
	   // 	{name: 'DIV_CODE'	 		 ,text: '사업장' 			,type: 'string'},
	    	{name: 'POS_NO'	 			 ,text: '자판기번호' 		,type: 'string'},
	    	{name: 'POS_NAME'	 		 ,text: '자판기명' 		,type: 'string'},
	    	{name: 'WH_CODE'	 	 	 ,text: '창고명' 			,type: 'string',store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'LOCATION'	 	 	 ,text: '위치' 			,type: 'string'}
		]  
	});		//End of Unilite.defineModel('Sva100ukrvModel', {
	
	Unilite.defineModel('Sva100ukrvModel2', {
		fields: [  	 	    
			{name: 'COMP_CODE'	 			,text: '법인코드' 				,type: 'string'},
	    	{name: 'DIV_CODE'	 			,text: '사업장' 				,type: 'string'},
	    	{name: 'POS_NO'	 	 			,text: '자판기번호' 			,type: 'string'},
	    	{name: 'COLUMN_NO'	 			,text: '컬럼번호' 				,type: 'int',allowBlank:false},
	    	{name: 'ITEM_CODE'	 			,text: '품목코드' 				,type: 'string',allowBlank:false},
	    	{name: 'ITEM_NAME'	 			,text: '품명' 				,type: 'string'},
	    	{name: 'SALE_P'	 				,text: '단가' 				,type: 'uniPrice',allowBlank:false},
	    	{name: 'BEFORE_CNT'	 			,text: '현도수' 				,type: 'uniQty'}
		]  
	});		//End of Unilite.defineModel('Sva100ukrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore1 = Unilite.createStore('sva100ukrvMasterStore1',{
		model: 'Sva100ukrvModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
           	editable: false,			// 수정 모드 사용 
           	deletable: false,			// 삭제 가능 여부 
	        useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
		proxy: {
				type: 'direct',
				api: {			
					read: 'sva100ukrvService.gridUp'                	
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
	       			masterForm.setValue('GRID_CUSTOM_CODE',records[0].get('POS_NO'));
	       			UniAppManager.setToolbarButtons(['newData'], true);
	       			
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
		
		
	});		// End of var directMasterStore1 = Unilite.createStore('sva100ukrvMasterStore1',{
	
	var directMasterStore2 = Unilite.createStore('sva100ukrvMasterStore2', {
		model: 'Sva100ukrvModel2',
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
					read: 'sva100ukrvService.gridDown'                	
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
			var inValidRecs = this.getInvalidRecords();
        	
        	var rv = true;
        	
			if(inValidRecs.length == 0 )	{
				this.syncAllDirect();
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
//				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '자판기',
				name:'POS_CODE', 
				xtype: 'uniCombobox',
				store:Ext.data.StoreManager.lookup('MachineNo'),
		        multiSelect: true, 
		        typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('POS_CODE', newValue);
					}
				}
			},
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
//				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '자판기',
				name:'POS_CODE', 
				xtype: 'uniCombobox',
				store:Ext.data.StoreManager.lookup('MachineNo'),
		        multiSelect: true, 
		        typeAhead: false,
				width: 400,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('POS_CODE', newValue);
						}
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
    var masterGrid= Unilite.createGrid('sva100ukrvGrid', {
    	region: 'west',
        layout: 'fit',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
//	        onLoadSelectFirst : false,
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
		//		{dataIndex: 'DIV_CODE'		,width:80,hidden:false},
				{dataIndex: 'POS_NO'	,width:100},
				{dataIndex: 'POS_NAME'	,width:200},
				{dataIndex: 'WH_CODE'		,width:150},
				{dataIndex: 'LOCATION'	 		,width:300}
        ],
        listeners: {
        	cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					masterForm.setValue('GRID_CUSTOM_CODE',record.get('POS_NO'));
				
//					masterForm.setValue('SALE_COMMON_P',record.get('SALE_COMMON_P'));
					directMasterStore2.loadStoreRecords(record);
					UniAppManager.setToolbarButtons(['newData'], true);
				}
				beforeRowIndex = rowIndex;
			},
        	
			beforeedit  : function( editor, e, eOpts ) {
			
			}
		}
    });		// End of masterGrid= Unilite.createGrid('sva100ukrvGrid', {

	var masterGrid2 = Unilite.createGrid('sva100ukrvGrid2', {
		layout: 'fit',
		region: 'center',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
//	        onLoadSelectFirst : false,
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
				{dataIndex: 'COLUMN_NO' 	,width:80},
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
													masterGrid2.setItemData(record,false, masterGrid2.uniOpt.currentRecord);
												} else {
													UniAppManager.app.onNewDataButtonDown();
													masterGrid2.setItemData(record,false, masterGrid2.getSelectedRecord());
												}
											}); 
										},
									scope: this
									},
									'onClear': function(type) {
										var a = masterGrid2.uniOpt.currentRecord.get('ITEM_CODE');
										
										masterGrid2.setItemData(null,true, masterGrid2.uniOpt.currentRecord);
									//	if(masterGrid.uniOpt.currentRecord.get('ITEM_CODE') != ''){
										masterGrid2.uniOpt.currentRecord.set('ITEM_CODE',a);
									//	alert(a);
										if(a != ''){
											alert("미등록상품입니다.");
										}
										
									//	}
									},
									applyextparam: function(popup){							
										popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
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
										masterGrid2.setItemData(record,false, masterGrid2.uniOpt.currentRecord);
				        			} else {
				        				UniAppManager.app.onNewDataButtonDown();
				        				masterGrid2.setItemData(record,false, masterGrid2.uniOpt.currentRecord);
				        			}
								}); 
							},
							scope: this
							},
						'onClear': function(type) {
								masterGrid2.setItemData(null,true, masterGrid2.uniOpt.currentRecord);
							},
							applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
						}
					})
				},
				{dataIndex: 'SALE_P'		,width:80},
				{dataIndex: 'BEFORE_CNT'	,width:80}
		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				UniAppManager.setToolbarButtons(['delete'], true);
				UniAppManager.setToolbarButtons(['newData'], true);
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom){
					
					if (UniUtils.indexOf(e.field, 
							['COLUMN_NO','ITEM_CODE','ITEM_NAME','BEFORE_CNT']))
							{	
								return true;
							}else{
								return false;
							}					
				}else{
					if(UniUtils.indexOf(e.field,['ITEM_CODE','BEFORE_CNT']))
						{	
							return true;
						}else{
							return false;
						}
				}
			}
		},
		
		setItemData: function(record, dataClear, grdRecord) {
//       		var grdRecord = this.getSelectedRecord();
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'		,"");
       			grdRecord.set('ITEM_NAME'		,"");
       			grdRecord.set('SALE_P'			,"");
       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
       			grdRecord.set('SALE_P'				, record['SALE_BASIS_P']);
       		}
		}
	});//End of var masterGrid = Unilite.createGrid('sva100ukrvGrid1', {
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
		id: 'sva100ukrvApp',
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
				
				var seq = directMasterStore2.max('COLUMN_NO');
            	 if(!seq){
            	 	seq = 1;
            	 }else{
            	 	seq += 1;
            	 }

            	 var r = {
            	 	COMP_CODE:		compCode,
            	 	DIV_CODE:		divCode,
            	 	COLUMN_NO: 		seq,
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
