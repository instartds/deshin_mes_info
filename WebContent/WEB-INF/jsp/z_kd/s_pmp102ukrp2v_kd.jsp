<%@page language="java" contentType="text/html; charset=utf-8"%>
var refSearch = Unilite.createSearchForm('refForm', {
            layout :  {type : 'uniTable', columns : 3},
                           
              
			    items: [{
		        	fieldLabel: '작업장',
		        	name: 'WORK_SHOP_CODE',
		        	xtype: 'uniCombobox', 
		        	readOnly:true,
		        	colspan:3,
		        	store: Ext.data.StoreManager.lookup('wsList')
		        },{
					name:'SEQ_NO',
					hidden:true,
					xtype:'uniTextfield'
				},{
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			defaults : {enforceMaxLength: true},
	    			colspan:2,
	    			items:[
	    				Unilite.popup('DIV_PUMOK',{ 
				        	fieldLabel: '품목코드1',
				        	valueFieldName: 'ITEM_CODE1', 
							textFieldName: 'ITEM_NAME1',
							holdable: 'hold',
							allowBlank:false,
				        	listeners: {
								onSelected: {
									fn: function(records, type) {
										console.log('records : ', records);
																		
										refSearch.setValue('SPEC1',records[0]["SPEC"]);
										refSearch.setValue('WKORD_Q1',0);
										refSearch.setValue('PROG_UNIT1',records[0]["STOCK_UNIT"]);
										refSearch.setValue('SUPPLY_TYPE1',records[0]["SUPPLY_TYPE"]);
			                    	},
									scope: this
								},
								onClear: function(type)	{
									refSearch.setValue('SPEC1','');
									
									refSearch.setValue('PROG_UNIT1','');
									refSearch.setValue('SUPPLY_TYPE1','');
								},
								applyextparam: function(popup){							
									popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
								}
							}
				   }),{
						name:'SPEC1',
						xtype:'uniTextfield',
						readOnly:true,
						holdable: 'hold',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								
							}
		        		}
					}]
		        },{
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			defaults : {enforceMaxLength: true},
	    			colspan:1,
	    			items:[{
				    	fieldLabel: '작업지시량',
					 	xtype: 'uniNumberfield',
					 	name: 'WKORD_Q1',
					 	value: '0.00',
					 	holdable: 'hold',
					 	allowBlank:false,
					 	listeners: {
							change: function(field, newValue, oldValue, eOpts) {}
		        		}
					},{
						name:'PROG_UNIT1',
						xtype:'uniTextfield',
						width: 50,
						readOnly:true,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
							}
		        		}
					},{
						name:'SUPPLY_TYPE1',
						xtype:'uniTextfield',
						hidden:true
					
					}]
		    	
		        },{
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			defaults : {enforceMaxLength: true},
	    			colspan:2,
	    			items:[
	    				Unilite.popup('DIV_PUMOK',{ 
				        	fieldLabel: '품목코드2',
				        	valueFieldName: 'ITEM_CODE2', 
							textFieldName: 'ITEM_NAME2',
							holdable: 'hold',
							
				        	listeners: {
								onSelected: {
									fn: function(records, type) {
										console.log('records : ', records);
																		
										refSearch.setValue('SPEC2',records[0]["SPEC"]);
										refSearch.setValue('WKORD_Q2',0);
										refSearch.setValue('PROG_UNIT2',records[0]["STOCK_UNIT"]);
										refSearch.setValue('SUPPLY_TYPE2',records[0]["SUPPLY_TYPE"]);
			                    	},
									scope: this
								},
								onClear: function(type)	{
									refSearch.setValue('SPEC2','');
									
									refSearch.setValue('WKORD_Q2',0);
									refSearch.setValue('PROG_UNIT2','');
									refSearch.setValue('SUPPLY_TYPE2','');
									
								},
								applyextparam: function(popup){							
									popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
								}
							}
				   }),{
						name:'SPEC2',
						xtype:'uniTextfield',
						readOnly:true,
						holdable: 'hold',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								
							}
		        		}
					}]
		        },{
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			defaults : {enforceMaxLength: true},
	    			colspan:1,
	    			items:[{
				    	fieldLabel: '작업지시량',
					 	xtype: 'uniNumberfield',
					 	name: 'WKORD_Q2',
					 	value: '0.00',
					 	holdable: 'hold',
					 	
					 	listeners: {
							change: function(field, newValue, oldValue, eOpts) {}
		        		}
					},{
						name:'PROG_UNIT2',
						xtype:'uniTextfield',
						width: 50,
						readOnly:true,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
							}
		        		}
					},{
						name:'SUPPLY_TYPE2',
						xtype:'uniTextfield',
						hidden:true
					
					}]
		    	
		        },{
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			defaults : {enforceMaxLength: true},
	    			colspan:2,
	    			items:[
	    				Unilite.popup('DIV_PUMOK',{ 
				        	fieldLabel: '품목코드3',
				        	valueFieldName: 'ITEM_CODE3', 
							textFieldName: 'ITEM_NAME3',
							holdable: 'hold',
							
				        	listeners: {
								onSelected: {
									fn: function(records, type) {
										console.log('records : ', records);
																		
										refSearch.setValue('SPEC3',records[0]["SPEC"]);
										refSearch.setValue('WKORD_Q3',0);
										refSearch.setValue('PROG_UNIT3',records[0]["STOCK_UNIT"]);
										refSearch.setValue('SUPPLY_TYPE3',records[0]["SUPPLY_TYPE"]);
			                    	},
									scope: this
								},
								onClear: function(type)	{
									refSearch.setValue('SPEC3','');
									refSearch.setValue('WKORD_Q3',0);
									refSearch.setValue('PROG_UNIT3','');
									refSearch.setValue('SUPPLY_TYPE3','');
									
								},
								applyextparam: function(popup){							
									popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
								}
							}
				   }),{
						name:'SPEC3',
						xtype:'uniTextfield',
						readOnly:true,
						holdable: 'hold',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								
							}
		        		}
					}]
		        },{
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			defaults : {enforceMaxLength: true},
	    			colspan:1,
	    			items:[{
				    	fieldLabel: '작업지시량',
					 	xtype: 'uniNumberfield',
					 	name: 'WKORD_Q3',
					 	value: '0.00',
					 	holdable: 'hold',
					 	
					 	listeners: {
							change: function(field, newValue, oldValue, eOpts) {}
		        		}
					},{
						name:'PROG_UNIT3',
						xtype:'uniTextfield',
						width: 50,
						readOnly:true,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
							}
		        		}
					},{
						name:'SUPPLY_TYPE3',
						xtype:'uniTextfield',
						hidden:true
					
					}]
		    	
		        },{
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			defaults : {enforceMaxLength: true},
	    			colspan:2,
	    			items:[
	    				Unilite.popup('DIV_PUMOK',{ 
				        	fieldLabel: '품목코드',
				        	valueFieldName: 'ITEM_CODE4', 
							textFieldName: 'ITEM_NAME4',
							holdable: 'hold',
							
				        	listeners: {
								onSelected: {
									fn: function(records, type) {
										console.log('records : ', records);
																		
										refSearch.setValue('SPEC4',records[0]["SPEC"]);
										refSearch.setValue('WKORD_Q4',0);
										refSearch.setValue('PROG_UNIT4',records[0]["STOCK_UNIT"]);
										refSearch.setValue('SUPPLY_TYPE4',records[0]["SUPPLY_TYPE"]);
			                    	},
									scope: this
								},
								onClear: function(type)	{
									refSearch.setValue('SPEC4','');
									refSearch.setValue('WKORD_Q4',0);
									refSearch.setValue('PROG_UNIT4','');
									refSearch.setValue('SUPPLY_TYPE4','');
									
								},
								applyextparam: function(popup){							
									popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
								}
							}
				   }),{
						name:'SPEC4',
						xtype:'uniTextfield',
						readOnly:true,
						holdable: 'hold',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								
							}
		        		}
					}]
		        },{
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			defaults : {enforceMaxLength: true},
	    			colspan:1,
	    			items:[{
				    	fieldLabel: '작업지시량',
					 	xtype: 'uniNumberfield',
					 	name: 'WKORD_Q4',
					 	value: '0.00',
					 	holdable: 'hold',
					 	
					 	listeners: {
							change: function(field, newValue, oldValue, eOpts) {}
		        		}
					},{
						name:'PROG_UNIT4',
						xtype:'uniTextfield',
						width: 50,
						readOnly:true,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
							}
		        		}
					},{
						name:'SUPPLY_TYPE4',
						xtype:'uniTextfield',
						hidden:true
					
					}]
		    	
		        },{
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			defaults : {enforceMaxLength: true},
	    			colspan:2,
	    			items:[
	    				Unilite.popup('DIV_PUMOK',{ 
				        	fieldLabel: '품목코드5',
				        	valueFieldName: 'ITEM_CODE', 
							textFieldName: 'ITEM_NAME',
							holdable: 'hold',
							
				        	listeners: {
								onSelected: {
									fn: function(records, type) {
										console.log('records : ', records);
																		
										refSearch.setValue('SPEC5',records[0]["SPEC"]);
										refSearch.setValue('WKORD_Q5',0);
										refSearch.setValue('PROG_UNIT5',records[0]["STOCK_UNIT"]);
										refSearch.setValue('SUPPLY_TYPE5',records[0]["SUPPLY_TYPE"]);
			                    	},
									scope: this
								},
								onClear: function(type)	{
									refSearch.setValue('SPEC5','');
									refSearch.setValue('WKORD_Q5',0);
									refSearch.setValue('PROG_UNIT5','');
									refSearch.setValue('SUPPLY_TYPE5','');
									
								},
								applyextparam: function(popup){							
									popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
								}
							}
				   }),{
						name:'SPEC5',
						xtype:'uniTextfield',
						readOnly:true,
						holdable: 'hold',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								
							}
		        		}
					}]
		        },{
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			defaults : {enforceMaxLength: true},
	    			colspan:1,
	    			items:[{
				    	fieldLabel: '작업지시량',
					 	xtype: 'uniNumberfield',
					 	name: 'WKORD_Q5',
					 	value: '0.00',
					 	holdable: 'hold',
					 	
					 	listeners: {
							change: function(field, newValue, oldValue, eOpts) {}
		        		}
					},{
						name:'PROG_UNIT5',
						xtype:'uniTextfield',
						width: 50,
						readOnly:true,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
							}
		        		}
					},{
						name:'SUPPLY_TYPE5',
						xtype:'uniTextfield',
						hidden:true
					
					}]
		    	
		        }
		        ],
		        returnData: function() {
					if(refSearch.getValue("ITEM_CODE1")=='' || refSearch.getValue("ITEM_NAME1")=='') {
						alert(Msg.sMB083);
						return false;
					}
					var dataArray= [];
					var record = detailGrid.getSelectedRecord();
					
					for(var i = 1;i <= 5; i++){
						if(refSearch.getValue("WKORD_Q"+i) && refSearch.getValue("WKORD_Q"+i) != 0){
							
							var dataObj = {};
							if(record){
								if(i == 1 && record.get("ITEM_CODE") ==  refSearch.getValue("ITEM_CODE"+i)){
									if(record.get("WKORD_Q") != refSearch.getValue("WKORD_Q"+i)){
										record.set("WKORD_Q",refSearch.getValue("WKORD_Q"+i));
									}
									continue;
								}
								str = JSON.stringify(record.data), //系列化对象
        						dataObj = JSON.parse(str); //还原			
        						delete dataObj["id"];  
        						dataObj.PRODT_END_DATE = record.data.PRODT_END_DATE;
        						dataObj.PRODT_START_DATE = record.data.PRODT_START_DATE;
        						dataObj.CHECK_YN = 'N';
							}
							dataObj.ITEM_CODE = refSearch.getValue("ITEM_CODE"+i);
							dataObj.ITEM_NAME = refSearch.getValue("ITEM_NAME"+i);
							dataObj.SPEC = refSearch.getValue("SPEC"+i);
							dataObj.WKORD_Q = refSearch.getValue("WKORD_Q"+i);
							dataObj.PROG_UNIT = refSearch.getValue("PROG_UNIT"+i);
							dataObj.SUPPLY_TYPE = refSearch.getValue("SUPPLY_TYPE"+i);
							
							dataArray.push(dataObj);
							
						}
					}
					if(!dataArray || dataArray.length == 0){
						return false;
					}
					var seqNo = detailStore.max('SEQ_NO');
					var addRecord=[];
					for(var i = 0; i < dataArray.length; i++){
						var dataObj = dataArray[i];
						seqNo = seqNo + 1;
						dataObj.SEQ_NO = seqNo;
						UniAppManager.app.onNewDataButtonDown(dataObj);
						var record = detailGrid.getSelectedRecord();
						addRecord.push(record);
					}
					for(var i = 0; i < addRecord.length; i++){
						var record = addRecord[i];
						UniAppManager.app.fnProgSeqInfo(record);
					}
					
					refWindow.hide();
				},
				fnPopupDelData: function(record) {
					
//		        	var detailRecords = detailStore.getData().items;
//							
//					if(detailRecords != null && detailRecords.length > 0){
//						detailRecords.forEach(function(e){
//								var dataObj = e.data;
//								if(dataObj.SEQ_NO == record.get("SEQ_NO") && dataObj.ITEM_CODE == record.get("ITEM_CODE") ){
//									detailStore.remove(e);
//										
//								}
//										
//						
//						});
//						
//					}
      
				}
	})
function openRefWindow() {
		var record = detailGrid.getSelectedRecord();
		if(!record){
			alert("한개 행열을 선택해 주십시오");
			return false;
		}
		
	
		if(!refWindow) {
			refWindow = Ext.create('widget.uniDetailWindow', {
                title: '생산계획정보',
                width: 830,				                
                
                layout:{type:'vbox', align:'stretch'},
                
                items: [refSearch],
                tbar:  ['->',
								        
										 
										{	itemId : 'confirmCloseBtn',
											text: '수주적용 후 닫기',
											handler: function() {
												refSearch.returnData();
												
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											text: '닫기',
											handler: function() {
												refWindow.hide();
											},
											disabled: false
										}
							    ]
							,
                listeners : {beforehide: function(me, eOpt)	{
                							// requestSearch.clearForm();
                							// requestGrid,reset();
                						},
                			 beforeclose: function( panel, eOpts )	{
											// requestSearch.clearForm();
                							// requestGrid,reset();
                			 			},
                			 beforeshow: function ( me, eOpts )	{
                			 	refSearch.clearForm();
								var record = detailGrid.getSelectedRecord();
								if(record){
									refSearch.setValues({
										"WORK_SHOP_CODE":record.get("WORK_SHOP_CODE"),
										"SEQ_NO":record.get("SEQ_NO"),
										"ITEM_CODE1":record.get("ITEM_CODE"),
										"ITEM_NAME1":record.get("ITEM_NAME"),
										"SPEC1":record.get("SPEC"),
										"WKORD_Q1":record.get("WKORD_Q"),
										"STOCK_UNIT1":record.get("STOCK_UNIT"),
										"SUPPLY_TYPE1":record.get("SUPPLY_TYPE")
										
									});
								}
                			 }
                }
			})
		}
		
		refWindow.show();
    }