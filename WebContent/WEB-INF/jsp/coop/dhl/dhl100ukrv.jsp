<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="dhl100ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="YP14"/>	<!-- 결제구분 	-->
	<t:ExtComboStore comboType="AU" comboCode="YP22"/>	<!-- 접수구분 	-->
	<t:ExtComboStore comboType="AU" comboCode="YP23"/>	<!-- 소포구분	-->
	<t:ExtComboStore comboType="AU" comboCode="YP24"/>	<!-- 선불구분 	-->
	<t:ExtComboStore comboType="AU" comboCode="YP25"/>	<!-- 접수담당 	-->
	<t:ExtComboStore comboType="AU" comboCode="YP26"/>	<!-- 픽업 NO 	-->
	<t:ExtComboStore comboType="AU" comboCode="B010"/>	<!-- 사용여부 	-->
	<t:ExtComboStore comboType="BOR120" pgmId="dhl100ukrv"/><!-- 사업장   	-->
</t:appConfig>
<style type= "text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
function appMain() {

var BsaCodeInfo = {	
	gsReceiptType: ${gsReceiptType},	// 송장번호와 YP22의 REF_CODE1 의 길이값 확인 
	ReceiptUser: ${ReceiptUser},
	gsLoginUser: '${gsLoginUser}'
};	

var systemYNStore = Unilite.createStore('dhl200ukrvsYNStore', {
    fields: ['text', 'value'],
	data :  [
		        {'text':'아니오'		, 'value':'0'},
		        {'text':'예'		, 'value':'1'}
    		]
});
/*var Autotype = true;	
	records = directMasterStore.data.items;
	Ext.each(records, function(record,i) {
		if(record.get("COLLECT_TYPE") == '3')	{
			Autotype = false;	
		}
	});*/

/*
var output ='';
for(var key in BsaCodeInfo){
	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/
	/**
	 * Model 정의 
	 * @type 
	 */
	
	Unilite.defineModel('dhl100ukrvModel', {
		// pkGen : user, system(default)
	    fields: [
				 {name: 'COMP_CODE' 		,text:'법인코드' 		,type:'string'	},
				 {name: 'DIV_CODE' 			,text:'사업장' 		,type:'string'	,comboType : "BOR120"},
				 {name: 'RECEIPT_NO' 		,text:'NO' 			,type:'string'	},
				 {name: 'INVOICE_NO' 		,text:'송장번호' 		,type:'string'	,allowBlank:false},
				 {name: 'BILL_NUM'	 		,text:'BILL_NUM' 	,type:'string', editable: false	},
				 {name: 'COLLECT_NUM'	 	,text:'COLLECT_NUM' ,type:'string', editable: false	},
				 {name: 'RECEIPT_NO' 		,text:'NO' 			,type:'string'	},
				 {name: 'RECEIPT_TYPE' 		,text:'접수구분' 		,type:'string'	,allowBlank:false , comboType:"AU", comboCode:"YP22"},
				 {name: 'SENDER' 			,text:'발송인' 		,type:'string'	,allowBlank:false},
				 {name: 'PACKAGE_TYPE' 		,text:'소포구분' 		,type:'string'	,allowBlank:false , comboType:"AU", comboCode:"YP23"},
				 {name: 'WEIGHT' 			,text:'무게(KG)' 		,type:'number'	,allowBlank:false},
				 {name: 'PAYMENT_TYPE' 		,text:'선불구분' 		,type:'string'	,allowBlank:false , comboType:"AU", comboCode:"YP24"},
				 {name: 'COLLECT_TYPE' 		,text:'결제구분' 		,type:'string'	,allowBlank:false , comboType:"AU", comboCode:"YP14"},
				 {name: 'CHARGE_AMT' 		,text:'요금' 			,type:'uniPrice',allowBlank:false},
				 {name: 'RECIPIENT' 		,text:'수신지' 		,type:'string'	,allowBlank:false},
				 {name: 'ITEM_NAME' 		,text:'취급품목' 		,type:'string'	,allowBlank:false},
				 {name: 'RECEIPT_DATE' 		,text:'접수일자' 		,type:'uniDate'	},
				 {name: 'RECEIPT_TIME' 		,text:'접수시간' 		,type:'string'	,allowBlank:false },
				 {name: 'RECEIPT_USER' 		,text:'접수담당' 		,type:'string'	,allowBlank:false, comboType:"AU", comboCode:"YP25" },
				 {name: 'PICKUP_YN' 		,text:'픽업여부' 		,type:'string', store: Ext.data.StoreManager.lookup('dhl200ukrvsYNStore'),defaultValue: '0', editable: false	},
				 {name: 'PICKUP_DATE' 		,text:'픽업일자' 		,type:'uniDate'	},
				 {name: 'PICKUP_NO' 		,text:'픽업 NO' 		,type:'string'	, comboType:"AU", comboCode:"YP26"},
				 {name: 'SEND_USER' 		,text:'픽업확인' 		,type:'string'	, comboType:"AU", comboCode:"YP25"},
				 {name: 'REMARK' 			,text:'비고' 			,type:'string'	},
				 
				 
				 /* 2015.08.12 외상거래 추가 */
				 {name: 'CUSTOM_CODE' 		,text:'외상거래처' 			,type:'string'	},
				 {name: 'CUSTOM_NAME' 		,text:'외상거래처명' 		,type:'string'	},
				 {name: 'POS_NO' 			,text:'POS_NO' 			,type:'string', defaultValue: '0314'},
				 {name: 'POS_RECEIPT_NO' 	,text:'POS_RECEIPT_NO' 	,type:'string'	}
			]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'dhl100ukrvService.selectList',
			update: 'dhl100ukrvService.updateDetail',
			create: 'dhl100ukrvService.insertDetail',
			destroy: 'dhl100ukrvService.deleteDetail',
			syncAll: 'dhl100ukrvService.saveAll'
		}
	});	  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('dhl100ukrvMasterStore',{
			model: 'dhl100ukrvModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
            	allDeletable: true,		// 전체 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('dhl100ukrvSearchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		if(!Ext.isEmpty(records)){
	           			panelSearch.setAllFieldsReadOnly(true);
						panelResult.setAllFieldsReadOnly(true);
	           		}
           		}
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			,saveStore : function()	{
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
				Ext.each(toCreate, function(cRecord, index){
       				cRecord.STATUS = 'create';
       			});
       			var toUpdate = this.getUpdatedRecords();       			
       			var toDelete = this.getRemovedRecords();
				var list = [].concat(toUpdate,toCreate);
				
				//alert(list[0].STATUS);
				var listLength = list.length;
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 ){ 
					
					Ext.each(list, function(record, index) {
						var param = {"DIV_CODE": record.get("DIV_CODE"), "RECEIPT_NO": record.get("RECEIPT_NO")}
						dhl100ukrvService.existBillNumCheck(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){	//픽업 등록되어 있을시 수정 불가
								alert("매출번호 또는 수금번호가 등록된 건은 수정할수 없습니다.\n재조회후 작업해 주세요.");
								return false;
							}else{
								var param = {DIV_CODE: panelSearch.getValue('DIV_CODE'), RECEIPT_DATE: UniDate.getDbDateStr(panelSearch.getValue('RECEIPT_DATE'))}
								if(list[index].STATUS == 'create' && record.phantom){
									dhl100ukrvService.getAutoNum(param,function(provider, response){
										if(!Ext.isEmpty(provider)){
											record.set('RECEIPT_NO',provider['RECEIPT_NO']);
											record.set('POS_RECEIPT_NO',provider['RECEIPT_NO'].substr(13,16));
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
							}				
						});			
					});		
					if(Ext.isEmpty(list)){		//delete
						directMasterStore.syncAllDirect();	
					}
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}	
			}          
		});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('dhl100ukrvSearchForm',{
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
		items:[{
			title: '기본정보', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',   			
	    	items:[{
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
						var field = panelResult.getField('RECEIPT_USER');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
        	},{
	    		fieldLabel: '접수일자',
		 		xtype: 'uniDatefield',
		 		name: 'RECEIPT_DATE',
		 		value: UniDate.get('today'),
		 		allowBlank:false,
		 		holdable: 'hold',
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('RECEIPT_DATE', newValue);
						}
					}
			},{
				fieldLabel: '접수담당',
				name: 'RECEIPT_USER' ,
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
						panelResult.setValue('RECEIPT_USER', newValue);
					}
				}
			},{
				fieldLabel: '접수구분',
				name: 'RECEIPT_TYPE' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'YP22',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RECEIPT_TYPE', newValue);
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
  					//this.unmask();
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
        		colspan:3,
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		holdable: 'hold',
        		allowBlank: false,
        		listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelSearch.getField('RECEIPT_USER');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
        	},{
	    		fieldLabel: '접수일자',
		 		xtype: 'uniDatefield',
		 		name: 'RECEIPT_DATE',
		 		value: UniDate.get('today'),
		 		allowBlank:false,
		 		holdable: 'hold',
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('RECEIPT_DATE', newValue);
						}
					}
			},{
				fieldLabel: '접수담당',
				name: 'RECEIPT_USER' ,
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
						panelSearch.setValue('RECEIPT_USER', newValue);
					}
				}
			},{
				fieldLabel: '접수구분',
				name: 'RECEIPT_TYPE' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'YP22',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('RECEIPT_TYPE', newValue);
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
						//this.mask();
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
  					//this.unmask();
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
    var masterGrid = Unilite.createGrid('dhl100ukrvGrid', {
    	region:'center',
    	store: directMasterStore,
        layout : 'fit',        
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: true,
            useMultipleSorting: false,
            useToggleSummary: false,
            excel: {
				useExcel: true,			
				exportGroup : true
			}
        },
        features: [ //{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        border:true,
		columns:[
				 {dataIndex:'COMP_CODE' 		,width:100  ,hidden:true},
				 {dataIndex:'DIV_CODE' 			,width:100	,hidden:true},
				 {dataIndex:'RECEIPT_NO' 		,width:125	},				 
				 {dataIndex:'INVOICE_NO' 		,width:100	,
				 useBarcodeScanner: false
				 },
				 {dataIndex:'BILL_NUM' 			,width:115, hidden: true	},
				 {dataIndex:'COLLECT_NUM' 		,width:115, hidden: true	},
				 {dataIndex:'RECEIPT_TYPE' 		,width:100	},
				 {dataIndex:'SENDER' 			,width:100  },
				 {dataIndex:'PACKAGE_TYPE' 		,width:100	},
				 {dataIndex:'WEIGHT'    		,width:100  ,format:'0,000.0',editor:{format:'0,000.0'}},
				 {dataIndex:'PAYMENT_TYPE' 		,width:100	},
				 {dataIndex:'COLLECT_TYPE' 		,width:100,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	            		return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
	            }},		 
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
				 {dataIndex:'CHARGE_AMT' 		,width:100, summaryType: 'sum'  },
				 {dataIndex:'RECIPIENT' 		,width:100	},
				 {dataIndex:'ITEM_NAME' 		,width:100	},
				 {dataIndex:'RECEIPT_DATE' 		,width:100	,hidden:true},
				 {dataIndex:'RECEIPT_TIME' 		,width:100	,align : "center"},
				 {dataIndex:'RECEIPT_USER' 		,width:100	},
				 {dataIndex:'PICKUP_YN' 		,width:100  /*,align : "center" ,xtype : 'checkcolumn', disabled: true*/},
				 //픽업등록에서만 픽업할수 있게 수정
//				 	listeners : {
//				 		checkchange : function( field, rowIndex, checked, eOpts ){  //
//				 			
//							if(checked == true){
//								var grid = masterGrid;
//					   			var grdRecord = grid.getStore().getAt(rowIndex);		
//					   			grdRecord.set('PICKUP_DATE'			, panelSearch.getValue('RECEIPT_DATE'));
//					   			grdRecord.set('PICKUP_NO'			, 1);
//							}
//							else if(checked == false){
//								var grid = masterGrid;
//					   			var grdRecord = grid.getStore().getAt(rowIndex);		
//					   			grdRecord.set('PICKUP_DATE'			, '');
//					   			grdRecord.set('PICKUP_NO'			, '');
//					   			grdRecord.set('SEND_USER'			, '');
//							}
//					 	}
//				 	 }
				 {dataIndex:'PICKUP_DATE' 		,width:100	},
				 {dataIndex:'PICKUP_NO' 		,width:100	},
				 {dataIndex:'SEND_USER' 		,width:100	},
				 {dataIndex:'REMARK' 			,width:100	},
				 {dataIndex:'POS_NO' 			,width:100, hidden: true	},
				 {dataIndex:'POS_RECEIPT_NO'	,width:100, hidden: true	}
         ],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
//				var param = {"DIV_CODE": e.record.get("DIV_CODE"), "RECEIPT_NO": e.record.get("RECEIPT_NO")}
//				dhl100ukrvService.existBillNumCheck(param, function(provider, response)	{
//					if(!Ext.isEmpty(provider)){	//픽업 등록되어 있을시 수정 불가
//						alert("매출번호 또는 수금번호가 등록된 건은 수정할수 없습니다.");
//						return false;
//					}else{
						if(!Ext.isEmpty(e.record.get('BILL_NUM')) || !Ext.isEmpty(e.record.get('COLLECT_NUM'))){						
							alert("매출번호 또는 수금번호가 등록된 건은 수정할수 없습니다.");
							return false;
						}
						if (UniUtils.indexOf(e.field, 
								['COMP_CODE', 'DIV_CODE', 'RECEIPT_NO','PICKUP_DATE','PICKUP_NO']))
							return false;
						if(e.record.phantom)	{
							if (UniUtils.indexOf(e.field, 
									['PICKUP_DATE','PICKUP_NO']))
							return false;
						}
						if(e.record.data.COLLECT_TYPE != '3')	{
							if(e.field=='CUSTOM_CODE' || e.field=='CUSTOM_NAME') return false;
						}
//					}				
//				});	
				
			}	
		}
    });
    

    	
    Unilite.Main({
    	id  : 'dhl100ukrvApp',
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
			panelSearch.setValue('RECEIPT_DATE',UniDate.get('today'));
			panelResult.setValue('RECEIPT_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons(['reset','newData','detail'],true);	
			this.setDefault();
		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('str103ukrvFileUploadPanel');
        	if(detailStore.isDirty() || fp.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		onQueryButtonDown : function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false ){
				return false;
			}
			directMasterStore.loadStoreRecords();
			var viewNormal = masterGrid.getView();
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);			
		},
		fnGetreceiptUserDivCode: function(subCode){	//사업장의 첫번째 영업담당자 가져오기..
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
			/*영업담당 filter set*/
			var field = panelSearch.getField('RECEIPT_USER');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('RECEIPT_USER');			
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");	
			
			var receiptUser = UniAppManager.app.fnGetreceiptUserDivCode(UserInfo.divCode);		//사업장의 첫번째 영업담당자 set 
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('RECEIPT_USER',BsaCodeInfo.gsLoginUser); 
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('RECEIPT_USER',BsaCodeInfo.gsLoginUser); 
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
		},
		onNewDataButtonDown : function()	{
			function leadingZeros(n, digits) {
			var zero = '';
			n = n.toString();	
		  		if (n.length < digits) {
		    		for (var i = 0; i < digits - n.length; i++)
		      		zero += '0';
		  		}
		  		return zero + n;
			}
			var today = new Date();
			
			var compCode = UserInfo.compCode;
			var divCode  = panelSearch.getValue('DIV_CODE');
			
			var receiptUser = UserInfo.userName;
        	 if(!Ext.isEmpty(panelSearch.getValue('RECEIPT_USER')))	{
        	 	receiptUser = panelSearch.getValue('RECEIPT_USER');
        	 }
			var receiptType = panelSearch.getValue('RECEIPT_TYPE');
			var receiptTime = leadingZeros(today.getHours(), 2) + ':' + leadingZeros(today.getMinutes(), 2);
			var receiptDate = panelSearch.getValue('RECEIPT_DATE');
		
			
			var r = {
				COMP_CODE : compCode,
				DIV_CODE  : divCode,
				
				RECEIPT_USER : receiptUser,
				RECEIPT_TYPE : receiptType,
				RECEIPT_TIME : receiptTime,
				RECEIPT_DATE : receiptDate
				//RECEIPT_NO: receiptNo
			}
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
			masterGrid.createRow(r);
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
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
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{				
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				var record = masterGrid.getSelectedRecord();
				var param = {"DIV_CODE": record.get("DIV_CODE"), "RECEIPT_NO": record.get("RECEIPT_NO")}
				dhl100ukrvService.existBillNumCheck(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){	//픽업 등록되어 있을시 수정 불가
						alert("매출번호 또는 수금번호가 등록된 건은 삭제할수 없습니다.\n재조회후 작업해 주세요.");
						return false;
					}else{
						masterGrid.deleteSelectedRow();
					}
				});
				
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
							masterGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}													
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				MasterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
			
		},
		fnLength: function(length)	{
        	var fRecord ='';
        	Ext.each(BsaCodeInfo.gsReceiptType, function(item, i)	{
        		if(length == item['refCode1']) {
        			fRecord = item['codeNo'];
        		}
        	});
        	return fRecord;
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
				case "COLLECT_TYPE" :
					record.set('CUSTOM_CODE', '');
					record.set('CUSTOM_NAME', '');
					break;
			}return rv;
		}
	});
};
</script>