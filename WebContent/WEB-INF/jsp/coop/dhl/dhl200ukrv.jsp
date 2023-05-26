<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="dhl200ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="YP14"/>	<!-- 결제구분 	-->
	<t:ExtComboStore comboType="AU" comboCode="YP22"/>	<!-- 접수구분 	-->
	<t:ExtComboStore comboType="AU" comboCode="YP23"/>	<!-- 소포구분	-->
	<t:ExtComboStore comboType="AU" comboCode="YP24"/>	<!-- 선불구분 	-->
	<t:ExtComboStore comboType="AU" comboCode="YP26"/>	<!-- 픽업 NO 	-->
	<t:ExtComboStore comboType="AU" comboCode="B010"/>	<!-- 사용여부 	-->
	<t:ExtComboStore comboType="BOR120" pgmId="dhl200ukrv"/><!-- 사업장   	-->
</t:appConfig>
<style type= "text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
function appMain() {
	
var BsaCodeInfo = {	
	ReceiptUser: ${ReceiptUser},
	gsLoginUser: '${gsLoginUser}'
	
};	
	
	var systemYNStore = Unilite.createStore('dhl200ukrvsYNStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'취소'		, 'value':'0'},
			        {'text':'확정'		, 'value':'1'}
	    		]
	});
	/**
	 * Model 정의 
	 * @type 
	 */
	
	Unilite.defineModel('dhl200ukrvModel', {
		// pkGen : user, system(default)
	    fields: [
				 {name: 'COMP_CODE' 		,text:'법인코드' 		,type:'string'	},
				 {name: 'DIV_CODE' 			,text:'사업장' 		,type:'string'	,comboType : "BOR120"},
				 {name: 'RECEIPT_NO' 		,text:'접수번호' 		,type:'string'	},
				 {name: 'PICKUP_YN' 		,text:'PICKUP_YN' 	,type:'string'	,store: Ext.data.StoreManager.lookup('dhl200ukrvsYNStore')},
				 {name: 'PICKUP_YN_FLAG' 	,text:'픽업여부' 		,type:'string'	,store: Ext.data.StoreManager.lookup('dhl200ukrvsYNStore')},
				 {name: 'PICKUP_DATE' 		,text:'픽업일자' 		,type:'uniDate'	},
				 {name: 'PICKUP_NO' 		,text:'픽업NO' 		,type:'string'	, comboType:"AU", comboCode:"YP26" /*, defaultValue: 1*/},
				 {name: 'BILL_NUM' 			,text:'매출번호' 		,type:'string'	},
				 {name: 'COLLECT_NUM' 		,text:'수금번호' 		,type:'string'	},
				 {name: 'SEND_USER' 		,text:'픽업확인' 		,type:'string'	, comboType:"AU", comboCode:"YP25"},
				 {name: 'RECEIPT_DATE' 		,text:'접수일자' 		,type:'uniDate'	},
				 {name: 'RECEIPT_TIME' 		,text:'접수시간' 		,type:'string'	},
				 {name: 'RECEIPT_TYPE' 		,text:'접수구분' 		,type:'string'	, comboType:"AU", comboCode:"YP22"},
				 {name: 'INVOICE_NO' 		,text:'송장번호' 		,type:'string'	},
				 {name: 'SENDER' 			,text:'발송인' 		,type:'string'	},
				 {name: 'PAYMENT_TYPE' 		,text:'선불구분' 		,type:'string'	, comboType:"AU", comboCode:"YP24"},
				 {name: 'WEIGHT' 			,text:'무게(KG)' 		,type:'number'	},
				 {name: 'COLLECT_TYPE' 		,text:'결제구분' 		,type:'string'	, comboType:"AU", comboCode:"YP14", editable: false},
				 {name: 'CHARGE_AMT' 		,text:'요금' 			,type:'uniPrice'},
				 {name: 'RECIPIENT' 		,text:'수신지' 		,type:'string'	},
				 {name: 'ITEM_NAME' 		,text:'취급품목' 		,type:'string'	},
				 {name: 'RECEIPT_USER' 		,text:'접수담당' 		,type:'string',allowBlank:false, comboType:"AU", comboCode:"YP25"	},
				 {name: 'REMARK' 			,text:'비고' 			,type:'string'	},
				 
				 /* 2015.08.12 외상거래 추가 */
				 {name: 'CUSTOM_CODE' 		,text:'외상거래처' 		,type:'string'	},
				 {name: 'CUSTOM_NAME' 		,text:'외상거래처명' 		,type:'string'	}
			]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'dhl200ukrvService.selectList',
			update: 'dhl200ukrvService.updateDetail',
			create: 'dhl200ukrvService.insertDetail',
			destroy: 'dhl200ukrvService.deleteDetail',
			syncAll: 'dhl200ukrvService.saveAll'
		}
	});	  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('dhl200ukrvMasterStore',{
			model: 'dhl200ukrvModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
            	allDeletable: true,		// 전체 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('dhl200ukrvSearchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
			,saveStore : function(config)	{
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					config = {
						success: function(batch, option) {
							directMasterStore.loadStoreRecords();
						}
					};
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			/*,saveStore : function(config)	{
				
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
       			var toUpdate = this.getUpdatedRecords();
       			Ext.each(toUpdate, function(toUpdate, index){
       				toUpdate.STATUS = 'update';
       			});
       			
       			var toDelete = this.getRemovedRecords();
				var list = [].concat(toUpdate,toCreate);
				
				//alert(list[0].STATUS);
				var listLength = list.length;
				console.log("inValidRecords : ", inValidRecs);
	로직추가필요	if(inValidRecs.length == 0 ){ 
					var param = {COMP_CODE: masterGrid.get('COMP_CODE'), DIV_CODE: masterGrid.get('DIV_CODE'), RECEIPT_NO: masterGrid.get('RECEIPT_NO')}   
					Ext.each(list, function(record, index) {
						if(list[index].STATUS == 'update' && record.phantom){
							dhl200ukrvService.getAutoNum(param,function(provider, response){
								if(!Ext.isEmpty(provider)){
									
									
									
								}
								if(listLength == index+1){
									directMasterStore.syncAllDirect();
									return false;
								}
							});
						}else{					//update
							if(listLength == index+1){
								directMasterStore.syncAllDirect();
								return false;
							}
						}						
					});		
					if(Ext.isEmpty(list)){		//delete
						directMasterStore.syncAllDirect();	
					}
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}*/
            
		});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('dhl200ukrvSearchForm',{
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		defaults: {
			autoScroll:true
	  	},
	    items: [{     
			title: '기본정보',   
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
        	items: [{	
        		xtype: 'container',
        		layout: {type: 'uniTable', columns:1},
        		items: [{
	        		fieldLabel: '사업장',
	        		name: 'DIV_CODE',
	        		value : UserInfo.divCode,
	        		xtype: 'uniCombobox',
	        		comboType: 'BOR120',
	        		holdable: 'hold',
	        		allowBlank: false,
	        		listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							var field = panelResult.getField('SEND_USER');	
							field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
	        	},{
					fieldLabel: '접수구분',
					name: 'RECEIPT_TYPE' ,
					xtype: 'uniCombobox' ,
					comboType: 'AU',
					comboCode: 'YP22',
	        		allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('RECEIPT_TYPE', newValue);
							//masterGrid.set('RECEIPT_TYPE',newValue);
						}
					}
				}, {
					fieldLabel: '접수일자',
					xtype: 'uniDateRangefield',
					startFieldName: 'RECEIPT_DATE_FR',
					endFieldName: 'RECEIPT_DATE_TO',
					width: 350,                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('RECEIPT_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('RECEIPT_DATE_TO',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
				    		
				    	}
				    }
				},{
		    		fieldLabel: '픽업일자',
			 		xtype: 'uniDatefield',
	        		allowBlank: false,
			 		name: 'PICKUP_DATE',
			 		value: UniDate.get('today'),
			 		listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('PICKUP_DATE', newValue);
							}
						}
				},{
					fieldLabel: '픽업NO',
	        		allowBlank: false,
					name: 'PICKUP_NO' ,
					xtype: 'uniCombobox' ,
					comboType: 'AU',
					comboCode: 'YP26',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('PICKUP_NO', newValue);
						}
					}
				}
				,{
					fieldLabel: '픽업확인',
					name: 'SEND_USER' ,
					xtype: 'uniCombobox' ,
					comboType: 'AU',
					comboCode: 'YP25',
					onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
						if(eOpts){
							combo.filterByRefCode('refCode1', newValue, eOpts.parent);
						}else{
							combo.divFilterByRefCode('refCode1', newValue, divCode);
						}
					},
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('SEND_USER', newValue);
						}
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
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		holdable: 'hold',
        		allowBlank: false,
        		listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelSearch.getField('SEND_USER');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
        	},{
				fieldLabel: '접수구분',
				name: 'RECEIPT_TYPE' ,
				xtype: 'uniCombobox' ,
        		allowBlank: false,
				comboType: 'AU',
				comboCode: 'YP22',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('RECEIPT_TYPE', newValue);
					}
				}
			}, {
				fieldLabel: '접수일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'RECEIPT_DATE_FR',
				endFieldName: 'RECEIPT_DATE_TO',
				width: 350,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('RECEIPT_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('RECEIPT_DATE_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
			    		
			    	}
			    }
			},{
	    		fieldLabel: '픽업일자',
		 		xtype: 'uniDatefield',
        		allowBlank: false,
		 		name: 'PICKUP_DATE',
		 		value: UniDate.get('today'),
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('PICKUP_DATE', newValue);
						}
					}
			},{
				fieldLabel: '픽업NO',
				name: 'PICKUP_NO' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'YP26',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PICKUP_NO', newValue);
					}
				}
			},{
				fieldLabel: '픽업확인',
				name: 'SEND_USER' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'YP25',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SEND_USER', newValue);
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
    });
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('dhl200ukrvGrid', {
    	region:'center',
    	store: directMasterStore,
        layout : 'fit',
        selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: false,
        	listeners: {        		
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			if(Ext.isEmpty(record.get('PICKUP_NO'))){
        				record.set('PICKUP_NO'	, panelSearch.getValue('PICKUP_NO'));	
        			}
        			if(Ext.isEmpty(record.get('PICKUP_DATE'))){
        				record.set('PICKUP_DATE', panelSearch.getValue('PICKUP_DATE'));	
        			}
        			if(Ext.isEmpty(record.get('SEND_USER'))){
        				record.set('SEND_USER', panelSearch.getValue('SEND_USER'));	
        			}
        		},
				select: function(grid, record, index, eOpts ){
					/*var picupYN = record.set('PICKUP_YN'  , '1');	//픽업여부
					if(picupYN == "1"){	//예
						record.set('PICKUP_YN'  , '0');
					}else{				//아니오
						record.set('PICKUP_YN'  , '1');
					}					
					record.set('PICKUP_DATE', panelSearch.getValue('PICKUP_DATE'));
				   	record.set('PICKUP_NO'	, panelSearch.getValue('PICKUP_NO'));
				   	record.set('SEND_USER'  , panelSearch.getValue('SEND_USER'));*/
					if(record.get('PICKUP_YN') == "0"){
						record.set('PICKUP_YN_FLAG','1');	//예
					}else{
						record.set('PICKUP_YN_FLAG','0'); //아니오
					}
				},
				deselect:  function(grid, record, index, eOpts ){
					record.set('PICKUP_YN_FLAG','');
        		}
        	}
        }),
        features: [ //{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
		uniOpt:{
			onLoadSelectFirst : false,
			useRowNumberer: false,
        	expandLastColumn: true,
            useMultipleSorting: false,
            useToggleSummary: false,
            excel: {
				useExcel: true,			
				exportGroup : true
			}
        },
       /* uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: true,
            useMultipleSorting: false,
            useToggleSummary: false,
            excel: {
				useExcel: true,			
				exportGroup : true
			}
        },*/
        border:true,
		columns:[
				 {dataIndex:'COMP_CODE' 		,width:100  ,hidden:true},
				 {dataIndex:'DIV_CODE' 			,width:100	,hidden:true},
				 {dataIndex:'RECEIPT_NO' 		,width:150	,hidden:true},
				 {dataIndex:'PICKUP_YN' 		,width:100  ,align : "center",hidden:true },
				 {dataIndex:'PICKUP_YN_FLAG' 	,width:100  ,align : "center" },
				 {dataIndex:'PICKUP_DATE' 		,width:100	},
				 {dataIndex:'PICKUP_NO' 		,width:100  },
				 {dataIndex:'BILL_NUM' 			,width:115  }, 
				 {dataIndex:'COLLECT_NUM' 		,width:115  },
				 {dataIndex:'SEND_USER' 		,width:100  },
				 {dataIndex:'RECEIPT_DATE' 		,width:100	},
				 {dataIndex:'RECEIPT_TIME' 		,width:100	,align : "center"},
				 {dataIndex:'RECEIPT_TYPE' 		,width:100  },
				 {dataIndex:'INVOICE_NO' 		,width:100	},
				 {dataIndex:'SENDER' 			,width:100	},
				 {dataIndex:'PAYMENT_TYPE' 		,width:100	},
				 {dataIndex:'WEIGHT'    		,width:100  ,format:'0,000.0',editor:{format:'0,000.0'}},
				 {dataIndex:'COLLECT_TYPE' 		,width:100,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	            		return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
	            }  },
				 {dataIndex: 'CUSTOM_CODE'   	, width: 100,
					editor: Unilite.popup('AGENT_CUST_G', {		
	// 				textFieldName: 'CUST_CREDIT_NAME_V',
	 				DBtextFieldName: 'CUSTOM_CODE',
	 				extParam: {AGENT_TYPE: '2'},
	 				listeners: {'onSelected': {
						fn: function(records, type) {				 										
							Ext.each(records, function(record,i) {				 															
								if(i==0) {
									var grdRecord = masterGrid.getSelectedRecord(); 
									grdRecord.set('CUSTOM_CODE',record['CUSTOM_CODE'] );
									grdRecord.set('CUSTOM_NAME',record['CUSTOM_NAME'] );
								}
							}); 
						},
						scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
					}
		 		})},
				 {dataIndex: 'CUSTOM_NAME'			, width: 166,
						editor: Unilite.popup('AGENT_CUST_G', {	
						extParam: {AGENT_TYPE: '2'},
		 				listeners: {'onSelected': {
							fn: function(records, type) {				 										
								Ext.each(records, function(record,i) {				 															
									if(i==0) {
										var grdRecord = masterGrid.getSelectedRecord(); 
										grdRecord.set('CUSTOM_CODE',record['CUSTOM_CODE'] );
										grdRecord.set('CUSTOM_NAME',record['CUSTOM_NAME'] );
									}
								}); 
							},
							scope: this
							},
							'onClear': function(type) {
								var grdRecord = masterGrid.getSelectedRecord();
								grdRecord.set('CUSTOM_CODE','');
								grdRecord.set('CUSTOM_NAME','');
							}
						}
			 	 })},
				 {dataIndex:'CHARGE_AMT' 		,width:100, summaryType: 'sum'	},
				 {dataIndex:'RECIPIENT' 		,width:100	},
				 {dataIndex:'ITEM_NAME' 		,width:100	},
				 {dataIndex:'RECEIPT_USER' 		,width:100	},
				 {dataIndex:'REMARK' 			,width:100	}
         ],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.field=='RECEIPT_USER' || e.field== 'SEND_USER' ) {
//					var outDivCode = panelSearch.getValue('DIV_CODE');
//					var combo = e.column.field;
					
//					if(e.rowIdx == 5) {								
//						combo.store.clearFilter();
//						combo.store.filter('refCode1', outDivCode);
//						
//					}else{
//						combo.store.clearFilter();
//					}
//				
//					combo.filterByRefCode('refCode1', outDivCode);
//					return true;
				}
				if(e.record.data.COLLECT_TYPE != '3')	{
					if(e.field=='CUSTOM_CODE' || e.field=='CUSTOM_NAME') return false;
				}
				
				if (UniUtils.indexOf(e.field, 
						[ 'PICKUP_YN', 'PICKUP_YN_FLAG', 'BILL_NUM', 'COLLECT_NUM',
						  'COMP_CODE', 'DIV_CODE', 'RECEIPT_DATE', 'RECEIPT_TIME', 'RECEIPT_TYPE', 'INVOICE_NO', 'SENDER', 'PAYMENT_TYPE',
						  'WEIGHT'  , 'CHARGE_AMT' , 'RECIPIENT' , 'ITEM_NAME',  'RECEIPT_USER', 'REMARK',  'CUSTOM_CODE', 'CUSTOM_NAME'  ])){
				return false;		  
			   }else{
			   		if(e.record.get('PICKUP_YN') == "1"){
			   			return false;
			   		}
			   }
				
				
				
				
			}
		}
    });

    
    Unilite.Main({
    	id  : 'dhl200ukrvApp',
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		masterGrid, panelResult
         	]	
      	},
      	panelSearch     
      	],	
		autoButtonControl : false,
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('PICKUP_NO',"1");
			panelResult.setValue('PICKUP_NO',"1");
			panelSearch.setValue('RECEIPT_DATE_FR',UniDate.add(UniDate.today(),  {days: -1}));
			panelSearch.setValue('RECEIPT_DATE_TO',UniDate.get('today'));
			panelResult.setValue('RECEIPT_DATE_FR',UniDate.add(UniDate.today(),  {days: -1}));
			panelResult.setValue('RECEIPT_DATE_TO',UniDate.get('today'));
			panelSearch.setValue('PICKUP_DATE',UniDate.get('today'));
			panelResult.setValue('PICKUP_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons(['reset'],true);			
			UniAppManager.setToolbarButtons(['detail'],false);
			this.setDefault();
		},
		onQueryButtonDown : function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			else{
				panelSearch.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			}
			directMasterStore.loadStoreRecords();
			var viewNormal = masterGrid.getView();
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	
		},
		fnGetSendUserDivCode: function(subCode){	//사업장의 첫번째 영업담당자 가져오기..
        	var fRecord ='';
        	Ext.each(BsaCodeInfo.receiptUser, function(item, i)	{
        		if(item['refCode1'] == subCode) {
        			fRecord = item['codeNo'];
        			return false;
        		}
        	});
        	return fRecord;
        },
		setDefault: function() {
			var field = panelSearch.getField('SEND_USER');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('SEND_USER');			
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");	
			
			var sendUser = UniAppManager.app.fnGetSendUserDivCode(UserInfo.divCode);		//사업장의 첫번째 영업담당자 set 
			
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('SEND_USER',BsaCodeInfo.gsLoginUser); ////사업장에 따른 접수담당자 불러와야함
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('SEND_USER',BsaCodeInfo.gsLoginUser); ////사업장에 따른 접수담당자 불러와야함
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
		},
		onSaveDataButtonDown: function (config, record) {
			var counterr = 0;
			records = directMasterStore.data.items;
			Ext.each(records, function(record,i) {
				if(record.get("COLLECT_TYPE") == '3' && Ext.isEmpty(record.get("CUSTOM_CODE")))	{
						counterr += 1;
						return false;
				}
			});
			if(counterr == 0){
					directMasterStore.saveStore(config);
			}else{
				alert('결제구분이 외상일 경우 \n 외상거래처코드는 필수입력사항 입니다.')
			}
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onDeleteAllButtonDown: function() {			
			var records = directMasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true
						
						if(deletable){		
							MasterGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}													
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
			
		},
		rejectSave: function()	{
			directMasterStore.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
		} 	
		, confirmSaveData: function()	{
            	if(directMasterStore.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
            }
	});
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			switch(fieldName) {
/*				case "RECEIPT_TIME" :
					if(Ext.isNumeric(newValue)) {
						var a = newValue;
						var i = (a.substring(0,2)+ ":"+ a.substring(2,4));
						record.set('RECEIPT_TIME', i);
					}if(!Ext.isNumeric(newValue)){
						rv = '숫자를 입력해주세요'
					}
					break;*/
			}return rv;
		}
	})
}; // main


</script>


