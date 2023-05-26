<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mrt200ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mrt200ukrv"   /> <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="YP04" /> <!-- 반품처 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="YP08" /> <!-- 조건 -->
	<t:ExtComboStore comboType="AU" comboCode="YP09" /> <!-- 형태 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

var SearchInfoWindow;	//조회버튼 누르면 나오는 조회창
var BsaCodeInfo = {	
//	gsInoutTypeDetail: '${gsInoutTypeDetail}',
	gsDefaultData: '${gsDefaultData}',
	gsInTypeAccountYN: ${gsInTypeAccountYN},
	gsExcessRate: '${gsExcessRate}',
	gsInvstatus: '${gsInvstatus}',
	gsProcessFlag: '${gsProcessFlag}',
	gsInspecFlag: '${gsInspecFlag}',
	gsMap100UkrLink: '${gsMap100UkrLink}',
	gsSumTypeLot: '${gsSumTypeLot}',
	gsSumTypeCell: '${gsSumTypeCell}',
	gsDefaultMoney: '${gsDefaultMoney}',
	gsInOutPrsn: '${gsInOutPrsn}',
	gsAutoType: '${gsAutoType}'
};
var CustomCodeInfo = {
	gsUnderCalBase: ''
};
/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/


//var gsInoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_M106').getAt(0).get('value');
var outDivCode = UserInfo.divCode;


var aa = 0;

function appMain() {
	
	var closeStore = Unilite.createStore('mrt200ukrvCloseStore', {  
	    fields: ['text', 'value'],
		data :  [
			        {'text':'마감'	, 'value':'Y'},
			        {'text':'미마감'	, 'value':'N'}
	    		]
	});
	
	
	var isAutoInoutNum = false;
	if(BsaCodeInfo.gsAutoType=='Y')	{
		isAutoInoutNum = true;
	}
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mrt200ukrvService.selectList',
			update: 'mrt200ukrvService.updateDetail',
			create: 'mrt200ukrvService.insertDetail',
			destroy: 'mrt200ukrvService.deleteDetail',
			syncAll: 'mrt200ukrvService.saveAll'
		}
	});	
	
	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Mrt200ukrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'          ,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>' 			,type: 'string'},
	    	{name: 'DIV_CODE'       	,text: '<t:message code="system.label.purchase.division" default="사업장"/>' 			,type: 'string',comboType:'BOR120'},
	    	{name: 'RETURN_SEQ'         ,text: '순번(반품접수순번)' 	,type: 'int'},
	    	{name: 'RETURN_NUM'         ,text: '반품접수번호' 		,type: 'string'},
	    	{name: 'CNT'         		,text: '매입처 단/복수' 		,type: 'string'},
	    	{name: 'ITEM_CODE'          ,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>' 			,type: 'string',allowBlank: false},
	    	{name: 'ITEM_NAME'          ,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>' 			,type: 'string',allowBlank: false},
	    	{name: 'SPEC'         		,text: '<t:message code="system.label.purchase.spec" default="규격"/>' 			,type: 'string'},
	    	{name: 'ORDER_UNIT'         ,text: '<t:message code="system.label.purchase.unit" default="단위"/>' 			,type: 'string'},
	    	{name: 'LOT_NO'         	,text: 'LOT NO' 		,type: 'string'},
	    	{name: 'LOT_ASSIGNED_YN'    ,text: 'LOT예약' 			,type: 'string'},
	    	{name: 'PURCHASE_TYPE'      ,text: '조건' 			,type: 'string',comboType:'AU',comboCode:'YP08',allowBlank: false},
	    	{name: 'SALES_TYPE'         ,text: '형태' 			,type: 'string',comboType:'AU',comboCode:'YP09',allowBlank: false},
	    	{name: 'GOOD_STOCK_Q'       ,text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>' 			,type: 'uniQty'},
	    	{name: 'SALE_BASIS_P'       ,text: '판매가' 			,type: 'uniUnitPrice',allowBlank: false},
	    	{name: 'PURCHASE_RATE'      ,text: '매입율' 			,type: 'uniER',allowBlank: false},
	    	{name: 'ORDER_UNIT_FOR_P'   ,text: '매입가' 			,type: 'uniUnitPrice',allowBlank: false},
	    	{name: 'ORDER_UNIT_Q'       ,text: '<t:message code="system.label.purchase.qty" default="수량"/>' 			,type: 'uniQty',allowBlank: false},
	    	{name: 'RETURN_CONFIRM_Q'   ,text: '반품확정수량' 		,type: 'uniQty'},
	    	{name: 'CLOSE_YN'   	    ,text: '마감여부' 		    ,type: 'string',store: Ext.data.StoreManager.lookup('mrt200ukrvCloseStore'),allowBlank: false},
	    	{name: 'ORDER_UNIT_FOR_O'   ,text: '<t:message code="system.label.purchase.amount" default="금액"/>' 			,type: 'uniPrice',allowBlank: false},
	    	{name: 'REMARK'         	,text: '<t:message code="system.label.purchase.remarks" default="비고"/>' 			,type: 'string'},
	    	{name: 'WH_CODE'         	,text: '<t:message code="system.label.purchase.warehouse" default="창고"/>' 			,type: 'string'},
	    	{name: 'SORT_SEQ'			, text:'<t:message code="system.label.purchase.seq" default="순번"/>'     		,type: 'int'},
	    	
	    	{name: 'LOT_ASSIGNED_YN_DUMMY'    ,text: 'LOT_ASSIGNED_YN_DUMMY' 		,type: 'string'},
	    	{name: 'PURCHASE_RATE_DUMMY'      ,text: 'PURCHASE_RATE_DUMMY' 			,type: 'string'},
	    	{name: 'ORDER_UNIT_FOR_P_DUMMY'   ,text: 'ORDER_UNIT_FOR_P_DUMMY' 		,type: 'string'},
	    	{name: 'SALES_TYPE_DUMMY'    	  ,text: 'SALES_TYPE_DUMMY' 			,type: 'string'},
	    	{name: 'PURCHASE_TYPE_DUMMY'      ,text: 'PURCHASE_TYPE_DUMMY' 			,type: 'string'},
	    	{name: 'ORDER_UNIT_FOR_O_DUMMY'   ,text: 'ORDER_UNIT_FOR_O_DUMMY' 		,type: 'string'}
	    	
	    	
		]
	});
	
	Unilite.defineModel('inoutNoMasterModel', {		//조회버튼 누르면 나오는 조회창
	    fields: [
	    	{name: 'CUSTOM_NAME'       		    		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'    	, type: 'string'},
	    	{name: 'RETURN_DATE'       		    		, text: '반품일'    	, type: 'uniDate'},
	    	{name: 'CUSTOM_CODE'       		    		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'   , type: 'string'},
	    	{name: 'WH_CODE'          		    		, text: '반품창고'    	, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'DIV_CODE'         		    		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'    	, type: 'string',comboType:'BOR120'},
	    	{name: 'DEPT_CODE'         		    		, text: '<t:message code="system.label.purchase.department" default="부서"/>'    	, type: 'string'},
	    	{name: 'DEPT_NAME'         		    		, text: '<t:message code="system.label.purchase.department" default="부서"/>'    	, type: 'string'},
	    	{name: 'RETURN_CODE' 	     		    	, text: '반품처'    	, type: 'string',comboType:'AU', comboCode:'YP04'},
	    	{name: 'INOUT_PRSN' 	     		    	, text: '반품담당'    	, type: 'string',comboType:'AU', comboCode:'B024'},
	    	{name: 'RETURN_NUM'        		    		, text: '반품번호'    	, type: 'string'},
	    	{name: 'SUM_ORDER_UNIT_Q'   				, text: '<t:message code="system.label.purchase.qty" default="수량"/>' 		, type: 'uniPrice'},
	    	{name: 'SUM_ORDER_UNIT_FOR_O'   			, text: '<t:message code="system.label.purchase.amount" default="금액"/>' 		, type: 'uniPrice'},
	    	{name: 'MONEY_UNIT'        		    		, text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'    	, type: 'string'}
	    	
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mrt200ukrvMasterStore1', {
		model: 'Mrt200ukrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부 
			allDeletable: true,
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			
			var totRecords = directMasterStore1.data.items;
			Ext.each(totRecords, function(record, index) {
				record.set('SORT_SEQ', index+1);
			});
			
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("RETURN_NUM", master.RETURN_NUM);
						panelResult.setValue("RETURN_NUM", master.RETURN_NUM);
				/*		var inoutNum = masterForm.getValue('RETURN_NUM');
						Ext.each(list, function(record, index) {
							if(record.data['RETURN_NUM'] != inoutNum) {
								record.set('RETURN_NUM', inoutNum);
							}
						})*/
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
//						directMasterStore1.loadStoreRecords();
						
						if (directMasterStore1.count() == 0) {   
							UniAppManager.app.onResetButtonDown();
						}else{
							directMasterStore1.loadStoreRecords();	
						}
					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('mrt200ukrvGrid1');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		var count = masterGrid.getStore().getCount();
					if(count > 0) {	
						UniAppManager.setToolbarButtons(['print'], true);
					}
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		}
	});//End of var directMasterStore1 = Unilite.createStore('mrt200ukrvMasterStore1', {
	var inoutNoMasterStore = Unilite.createStore('inoutNoMasterStore', {	//조회버튼 누르면 나오는 조회창
		model: 'inoutNoMasterModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 'mrt200ukrvService.selectinoutNoMasterList'
            }
        }
        ,loadStoreRecords : function()	{
			var param= inoutNoSearch.getValues();			
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(inoutNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

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
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				holdable: 'hold',
				child:'WH_CODE',
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('INOUT_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
						var field2 = panelResult.getField('WH_CODE');		
						field2.getStore().clearFilter(true);
					}
				}
			},
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							masterForm.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){							
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						
						if(authoInfo == "A"){	//자기사업장	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),
			Unilite.popup('CUST', {
					fieldLabel: '매입처',
					valueFieldName:'CUSTOM_CODE',
			    	textFieldName:'CUSTOM_NAME',
					allowBlank: false,
					holdable: 'hold',
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
//								CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
								masterForm.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
//								masterForm.setValue('EXCHG_RATE_O', '1');
								masterForm.setValue('RETURN_CODE',records[0]["RETURN_CODE"]);
								panelResult.setValue('RETURN_CODE',records[0]["RETURN_CODE"]);
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
		        fieldLabel: '반품일',
		        name: 'RETURN_DATE',
		        xtype: 'uniDatefield',
		       	value: UniDate.get('today'),
		     	allowBlank: false,
		     	holdable: 'hold',
		     	width : 200,
		     	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RETURN_DATE', newValue);
					}
				}
			},{
				fieldLabel: '반품창고',
				name: 'WH_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList'),
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '반품처', 
				name: 'RETURN_CODE', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'YP04', 
//				allowBlank: false,
//				holdable: 'hold',
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RETURN_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.trancharge" default="수불담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				holdable: 'hold',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('INOUT_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '반품접수번호',
				xtype: 'uniTextfield',
				name:'RETURN_NUM',
//				readOnly: isAutoInoutNum
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>', 
				name: 'MONEY_UNIT', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B004',
				displayField: 'value',
				allowBlank: false,
				holdable: 'hold',
				fieldStyle: 'text-align: center;',
				hidden:true
			},/*{
				fieldLabel: '<t:message code="system.label.purchase.exchangerate" default="환율"/>',
				name:'EXCHG_RATE_O',
				xtype: 'uniTextfield',
				allowBlank: false,
				holdable: 'hold'
			},{
				fieldLabel: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
				name: 'CREATE_LOC',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M505',
				holdable: 'hold',
				hidden:false
			},*/{
				fieldLabel:'ITEM_CODE',
				name:'ITEM_CODE',
				xtype: 'uniTextfield',
				hidden: true
				
			},{
				fieldLabel:'ORDER_UNIT',
				name:'ORDER_UNIT',
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

	});//End of var masterForm = Unilite.createSearchForm('searchForm', {
	var panelResult = Unilite.createSearchForm('resultForm2',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				holdable: 'hold',
				child:'WH_CODE',
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);						
					var field = masterForm.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					masterForm.setValue('DIV_CODE', newValue);
					var field2 = masterForm.getField('WH_CODE');		
						field2.getStore().clearFilter(true);
				}
				}
			},
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							masterForm.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
							masterForm.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							masterForm.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						masterForm.setValue('DEPT_CODE', '');
						masterForm.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){							
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						
						if(authoInfo == "A"){	//자기사업장	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),
			{
				fieldLabel: '반품창고',
				name: 'WH_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList'),
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('WH_CODE', newValue);
					}
				}
			},{
		        fieldLabel: '반품일',
		        name: 'RETURN_DATE',
		        xtype: 'uniDatefield',
		       	value: UniDate.get('today'),
		     	allowBlank: false,
		     	holdable: 'hold',
		     	width : 200,
		     	colspan: 2,
		     	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('RETURN_DATE', newValue);
					}
				}
			},
			Unilite.popup('CUST', {
				fieldLabel: '매입처',
				valueFieldName:'CUSTOM_CODE',
		    	textFieldName:'CUSTOM_NAME',
				allowBlank: false,
				holdable: 'hold',
				extParam: {'CUSTOM_TYPE': ['1','2']},
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
//							CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
							masterForm.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
//							masterForm.setValue('EXCHG_RATE_O', '1');
							masterForm.setValue('RETURN_CODE',records[0]["RETURN_CODE"]);
							panelResult.setValue('RETURN_CODE',records[0]["RETURN_CODE"]);
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
			}),
			{
				fieldLabel: '반품처', 
				name: 'RETURN_CODE', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'YP04', 
//				allowBlank: false,
//				holdable: 'hold',
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('RETURN_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.trancharge" default="수불담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				holdable: 'hold',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('INOUT_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '반품접수번호',
				xtype: 'uniTextfield',
				name:'RETURN_NUM',
				readOnly: true
//				readOnly: isAutoInoutNum
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
    
    var inoutNoSearch = Unilite.createSearchForm('inoutNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 3},
	    trackResetOnLoad: true,
	    items: [
			{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				child:'WH_CODE',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);						
						var field = inoutNoSearch.getField('INOUT_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					}
				}
			},
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				applyextparam: function(popup){							
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장
					
					if(authoInfo == "A"){	//자기사업장	
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						
					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}),	
			{
				fieldLabel: '반품창고', 
				name: 'WH_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList')
			},
			Unilite.popup('CUST',{ 
				fieldLabel: '매입처', 
				valueFieldName: 'CUSTOM_CODE',
		   	 	textFieldName: 'CUSTOM_NAME',
				
				validateBlank: false,
				extParam: {'CUSTOM_TYPE': ['1','2']}
			}),
			{
				fieldLabel: '반품일',
				xtype: 'uniDateRangefield',
				startFieldName: 'RETURN_DATE_FR',
				endFieldName: 'RETURN_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315
			},{
				fieldLabel: '<t:message code="system.label.purchase.trancharge" default="수불담당"/>', 
				name: 'INOUT_PRSN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B024',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			}]
    }); // createSearchForm
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('mrt200ukrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		excelTitle: '반품접수등록',
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
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		store: directMasterStore1,
		columns: [        
               		 { dataIndex: 'COMP_CODE'                  , 	width:88,hidden:true},        
               		 { dataIndex: 'DIV_CODE'       	           , 	width:88,hidden:true},  
               		 { dataIndex: 'SORT_SEQ'				   , 	width:60,align: 'center' },
               		 { dataIndex: 'RETURN_SEQ'         	       , 	width:60,align:'center',hidden: true},
               		 { dataIndex: 'RETURN_NUM'                 , 	width:120,hidden:true},
               		 { dataIndex: 'CNT'				   		   , 	width:100,align: 'center',
	               		 renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
	        			if(record.get('CNT') == '복수'){
	                        return '<div style= "background-color:' + '#fed9fe' + '">' + val + '</div>';
	        			}else{
	        				return val;
	        			}
	                }
               		 },
               		 { dataIndex: 'ITEM_CODE'                  , 	width:120,
               		 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
		        	},
               		 editor: Unilite.popup('DIV_PUMOK_G', {		
					 							textFieldName: 'ITEM_CODE',
					 							DBtextFieldName: 'ITEM_CODE',
					 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					 							useBarcodeScanner: false,
		                    					autoPopup: true,
												listeners: {'onSelected': {
																fn: function(records, type) {
																		console.log('records : ', records);
																		Ext.each(records, function(record,i) {
																							console.log('record',record);
																							if(i==0) {
																								masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
																							} else {
																								UniAppManager.app.onNewDataButtonDown();
																								masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
																							}
																		}); 
																		setTimeout(function(){
																			if(masterGrid.uniOpt.currentRecord.get('ORDER_UNIT_FOR_P') <=0 ){
																				alert('해당되는 매입처의 제품이 아닙니다');	
																			}
																		}
																			, 1000
																			
																		)
																	},
																scope: this
																},
															'onClear': function(type) {
																	var a = masterGrid.uniOpt.currentRecord.get('ITEM_CODE');
																	
																	masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
																	
																	masterGrid.uniOpt.currentRecord.set('ITEM_CODE',a);
																	if(aa == 0){
																//	alert(a);
																		if(a != ''){
																			alert("미등록상품입니다.");
																			aa++;
																		}
																	}else{
																		aa=0;	
																	}
															},
													applyextparam: function(popup){							
														popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
													}
												}
										})
               		 
               		 },        
               		 { dataIndex: 'ITEM_NAME'                  , 	width:250,
               		 editor: Unilite.popup('DIV_PUMOK_G', {
					 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
		                    					autoPopup: true,
												listeners: {'onSelected': {
																fn: function(records, type) {
													                    console.log('records : ', records);
													                    Ext.each(records, function(record,i) {													                   
																		        			if(i==0) {
																								masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
																		        			} else {
																		        				UniAppManager.app.onNewDataButtonDown();
																		        				masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
																		        			}
																		}); 
																	},
																scope: this
															},
															'onClear': function(type) {
																masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
															},
													applyextparam: function(popup){							
														popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
													}
													}
										})
               		 
               		 },        
               		 { dataIndex: 'SPEC'         		       , 	width:88,hidden:true},        
               		 { dataIndex: 'ORDER_UNIT'                 , 	width:88,hidden:true},        
               		 { dataIndex: 'LOT_NO'         	           , 	width:150,
               		 editor: Unilite.popup('LOTNO_G', {		
		 							textFieldName: 'LOTNO_CODE',
		 							DBtextFieldName: 'LOTNO_CODE',
	//			 							var grdRecord = masterGrid.getSelectedRecord(),
	//	 							extParam: {  DIV_CODE: '02', WH_CODE: masterForm, CUSTOM_CODE: masterForm.getValue('CUSTOM_CODE')/*,CUSTOM_NAME: masterForm.getValue('CUSTOM_NAME')*/},
	//			 										WH_CODE: masterGrid.currentRecord.get('WH_CODE'), ITEM_CODE: masterGrid.currentRecord.get('ITEM_CODE'), 
	//			 										ITEM_NAME: masterGrid.currentRecord.get('ITEM_NAME'), POPUP_TYPE: 'GRID_CODE'},
		 							
	//			 							WH_CODE: grdRecord.get('WH_CODE')},
		 							//validateBlank: false,
		 							//useBarcodeScanner: false,
		                    		autoPopup: true,
									listeners: {'onSelected': {
										fn: function(records, type) {
												var rtnRecord;
												Ext.each(records, function(record,i) {
													if(i==0){
														rtnRecord = masterGrid.uniOpt.currentRecord
													}else{
														rtnRecord = masterGrid.getSelectedRecord()
													}
													
													rtnRecord.set('LOT_ASSIGNED_YN_DUMMY', rtnRecord.get('LOT_ASSIGNED_YN'));  
													rtnRecord.set('PURCHASE_RATE_DUMMY', rtnRecord.get('PURCHASE_RATE'));        
													rtnRecord.set('ORDER_UNIT_FOR_P_DUMMY', rtnRecord.get('ORDER_UNIT_FOR_P'));     
													rtnRecord.set('SALES_TYPE_DUMMY', rtnRecord.get('SALES_TYPE'));       	 
													rtnRecord.set('PURCHASE_TYPE_DUMMY', rtnRecord.get('PURCHASE_TYPE'));        
													rtnRecord.set('ORDER_UNIT_FOR_O_DUMMY', rtnRecord.get('ORDER_UNIT_FOR_O'));     
													
													
													
													rtnRecord.set('LOT_NO', record['LOT_NO']);
													rtnRecord.set('LOT_ASSIGNED_YN', 'Y');
//													rtnRecord.set('TEMP_ORDER_UNIT_Q', record['STOCK_Q']);
//													rtnRecord.set('ORDER_UNIT_Q', 0);
													rtnRecord.set('PURCHASE_RATE', record['PURCHASE_RATE']);
													rtnRecord.set('ORDER_UNIT_FOR_P', record['PURCHASE_P']);
//													rtnRecord.set('INOUT_P', record['PURCHASE_P']);
//													rtnRecord.set('ORDER_UNIT_P', record['PURCHASE_P']);
													rtnRecord.set('SALES_TYPE', record['SALES_TYPE']);
													rtnRecord.set('PURCHASE_TYPE', record['PURCHASE_TYPE']);
													rtnRecord.set('ORDER_UNIT_FOR_O', record['PURCHASE_P'] * rtnRecord.get('ORDER_UNIT_Q'));		
												
	//												if(i==0) { 
	//													masterGrid.setLotData(record,false);
	//												} 
												}); 
											},
										scope: this
										},
										'onClear': function(type) {
										/*		
											rtnRecord.set('LOT_NO', '');
											rtnRecord.set('LOT_ASSIGNED_YN', 'N');
//											rtnRecord.set('TEMP_ORDER_UNIT_Q', '');
											rtnRecord.set('PURCHASE_RATE', 0);
											rtnRecord.set('ORDER_UNIT_FOR_P', 0);
//											rtnRecord.set('INOUT_P', 0);
//											rtnRecord.set('ORDER_UNIT_P', 0);
											rtnRecord.set('SALES_TYPE', '');
											rtnRecord.set('PURCHASE_TYPE', '');*/
											var rtnRecord = masterGrid.uniOpt.currentRecord;
//											rtnRecord.set('LOT_ASSIGNED_YN'	, "N");
											
											rtnRecord.set('LOT_ASSIGNED_YN', rtnRecord.get('LOT_ASSIGNED_YN_DUMMY'));  
											rtnRecord.set('PURCHASE_RATE', rtnRecord.get('PURCHASE_RATE_DUMMY'));        
											rtnRecord.set('ORDER_UNIT_FOR_P', rtnRecord.get('ORDER_UNIT_FOR_P_DUMMY'));     
											rtnRecord.set('SALES_TYPE', rtnRecord.get('SALES_TYPE_DUMMY'));       	 
											rtnRecord.set('PURCHASE_TYPE', rtnRecord.get('PURCHASE_TYPE_DUMMY'));        
											rtnRecord.set('ORDER_UNIT_FOR_O', rtnRecord.get('ORDER_UNIT_FOR_O_DUMMY'));
											
											
											
//											rtnRecord.set('ITEM_CODE_DUMMY',rtnRecord.get('ITEM_CODE'));
//											rtnRecord.set('ITEM_CODE',rtnRecord.get('ITEM_CODE_DUMMY'));
//											masterGrid.setItemData(rtnRecord,false, masterGrid.getSelectedRecord());
//											masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
//											rtnRecord.set('ITEM_CODE',rtnRecord.get('ITEM_CODE_DUMMY'));
										},
										applyextparam: function(popup){
											var record = masterGrid.getSelectedRecord();
											var divCode = masterForm.getValue('DIV_CODE');
//											var customCode = masterForm.getValue('CUSTOM_CODE'); 
//											var customName = masterForm.getValue('CUSTOM_NAME'); 
											var itemCode = record.get('ITEM_CODE');
											var itemName = record.get('ITEM_NAME');
											var whCode = record.get('WH_CODE');
//											var whCellCode = record.get('WH_CELL_CODE');
											var stockYN = 'Y'
											popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode /*'S_WH_CELL_CODE': whCellCode,*/ /*'S_CUSTOM_CODE': customCode, 'S_CUSTOM_NAME': customName*//*, 'STOCK_YN': stockYN*/});
										}									
									}
							})
               		 },        
               		 { dataIndex: 'LOT_ASSIGNED_YN'            , 	width:70,align:'center'},        
               		 { dataIndex: 'PURCHASE_TYPE'              , 	width:80,align:'center'},        
               		 { dataIndex: 'SALES_TYPE'                 , 	width:80,align:'center'},        
               		 { dataIndex: 'GOOD_STOCK_Q'         	   , 	width:88},        
               		 { dataIndex: 'SALE_BASIS_P'               , 	width:88},        
               		 { dataIndex: 'PURCHASE_RATE'              , 	width:88},        
               		 { dataIndex: 'ORDER_UNIT_FOR_P'           , 	width:88},        
               		 { dataIndex: 'ORDER_UNIT_Q'               , 	width:88,summaryType: 'sum'},
               		 { dataIndex: 'RETURN_CONFIRM_Q'           , 	width:88,hidden:false},
               		 { dataIndex: 'CLOSE_YN'           		   , 	width:88,align:'center'},
               		 
               		 { dataIndex: 'ORDER_UNIT_FOR_O'           , 	width:88,summaryType: 'sum'},        
               		 { dataIndex: 'REMARK'         	           , 	width:200},
               		 { dataIndex: 'WH_CODE'         	       , 	width:88,hidden:true}
               		 
        ],
        listeners: {
        	afterrender: function(masterGrid) {	
					    	var me = this;
					    	this.contextMenu = Ext.create('Ext.menu.Menu', {});
					     	this.contextMenu.add({	
									text: '상품정보 등록',   iconCls : '',
									id: 'mrt200ukrvMenu1',
							        handler: function(menuItem, event) {	
							        	var records = masterGrid.getSelectionModel().getSelection();
							         	var record = records[0];
										var params = {
											appId: UniAppManager.getApp().id,
											sender: me,
											action: 'new',
//											_EXCEL_JOBID: excelWindow.jobID,			
//											_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'),	
											ITEM_CODE: record.get('ITEM_CODE'),
											DIV_CODE: record.get('DIV_CODE')
										}
										var rec = {data : {prgID : 'bpr101ukrv', 'text':''}};									
										parent.openTab(rec, '/base/bpr101ukrv.do', params);														
							                	}
							});
							this.contextMenu.add({	
									text: '도서정보 등록',   iconCls : '',
									id: 'mrt200ukrvMenu2',
							        handler: function(menuItem, event) {	
							        	var records = masterGrid.getSelectionModel().getSelection();
							         	var record = records[0];
										var params = {
											appId: UniAppManager.getApp().id,
											sender: me,
											action: 'newB',
//											_EXCEL_JOBID: excelWindow.jobID,			
//											_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'),	
											ITEM_CODE: record.get('ITEM_CODE'),
											DIV_CODE: record.get('DIV_CODE')
										}
										var rec = {data : {prgID : 'bpr102ukrv', 'text':''}};									
										parent.openTab(rec, '/base/bpr102ukrv.do', params);														
							                	}
							});
						   /* me.on('cellcontextmenu', function( view, cell, cellIndex, record, row, rowIndex, event ) {
					        	event.stopEvent();
					        	if(record.get('ITEM_CODE') == '')
								me.contextMenu.showAt(event.getXY());
							});*/
						},
						itemmousedown: function(grid, record, item, index, e, eOpts  ){
//				var records = masterGrid.getSelectionModel().getSelection();
    			if(record){
    				if(record.get('ITEM_ACCOUNT') == "00"){
						Ext.getCmp('mrt200ukrvMenu1').hide();
						Ext.getCmp('mrt200ukrvMenu2').show();
					}else if(record.get('ITEM_ACCOUNT') != "00" && !Ext.isEmpty(record.get('ITEM_ACCOUNT'))){
						Ext.getCmp('mrt200ukrvMenu2').hide();
						Ext.getCmp('mrt200ukrvMenu1').show();
					}else if(Ext.isEmpty(record.get('ITEM_ACCOUNT'))){
						Ext.getCmp('mrt200ukrvMenu1').show();
						Ext.getCmp('mrt200ukrvMenu2').show();
					}
    			}
			},
			cellclick: function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ){
				this.contextMenu.hide();				
			},
						
		beforeedit : function( editor, e, eOpts ) {
			if (UniUtils.indexOf(e.field, 'LOT_NO')){
				if(Ext.isEmpty(e.record.data.ITEM_CODE)){
					alert(Msg.sMS003);
					return false;
				}
			}
			/*if(e.record.data.RETURN_CONFIRM_Q > 0){
				alert('<t:message code="확정수량이 존재 합니다.\n 수정 할 수 없습니다."/>');
				return false;
			}*/
			
				if(e.record.phantom == true){
					if(UniUtils.indexOf(e.field, ['COMP_CODE','DIV_CODE','RETURN_SEQ','SPEC','ORDER_UNIT',
												  'GOOD_STOCK_Q','ORDER_UNIT_FOR_O','RETURN_NUM','RETURN_CONFIRM_Q','PURCHASE_TYPE',
												  'SALES_TYPE','SALE_BASIS_P','PURCHASE_RATE','ORDER_UNIT_FOR_P','CNT','LOT_ASSIGNED_YN','WH_CODE'])){
						return false;
					}else{
						return true;
					}
				}else{
					if(UniUtils.indexOf(e.field, ['COMP_CODE','DIV_CODE','RETURN_SEQ','SPEC','ORDER_UNIT',
												  'GOOD_STOCK_Q','ORDER_UNIT_FOR_O','RETURN_NUM','RETURN_CONFIRM_Q','PURCHASE_TYPE',
												  'SALES_TYPE','SALE_BASIS_P','PURCHASE_RATE','ORDER_UNIT_FOR_P','CNT','LOT_ASSIGNED_YN','WH_CODE'])){
						return false;	
					}else{
						return true;
					}	
				}
//			
		
/*			if(e.record.data.ACCOUNT_Q != '0'){
				return false;
			}
			if(!Ext.isEmpty(e.record.data.RETURN_NUM)){
				if(e.record.phantom == false){
//					return true;
					if(UniUtils.indexOf(e.field, ['ORDER_UNIT_Q','REMARK'])){
						return true;
					}else{
						return false;
					}
				}else{
					if(UniUtils.indexOf(e.field, ['INOUT_SEQ','INOUT_TYPE_DETAIL','ITEM_CODE','ITEM_NAME','PURCHASE_RATE','ORDER_UNIT_FOR_P','ORDER_UNIT_Q','REMARK', 'LOT_NO', 'PURCHASE_TYPE', 'SALES_TYPE'])){
						return true;
					}else{
						return false;
					}	
				}
			}else{
				if(UniUtils.indexOf(e.field, ['INOUT_SEQ','INOUT_TYPE_DETAIL','ITEM_CODE','ITEM_NAME','PURCHASE_RATE','ORDER_UNIT_FOR_P','ORDER_UNIT_Q','REMARK','LOT_NO', 'PURCHASE_TYPE', 'SALES_TYPE' ])){
						return true;
					}else{
						return false;
					}	
			}*/
			
		/*	if(!Ext.isEmpty(e.record.data.ORDER_NUM)){
				if(e.record.phantom){
					if(e.record.ORDER_TYPE == '3'){
						if(e.field == 'BL_NUM') return true;
					}else{
						if(e.field == 'BL_NUM') return false;
					}
					if(e.field == 'EXCHG_RATE_O')return true;
					if(e.field == 'MONEY_UNIT')return true;
					if(e.field == 'ACCOUNT_YNC')return true;
					if(e.field == 'ORDER_UNIT_Q')return true;
					if(e.field == 'INOUT_TYPE_DETAIL')return true;
					if(e.field == 'ITEM_STATUS')return true;
					if(e.field == 'INOUT_SEQ')return true;
					if(e.field == 'INOUT_I')return true;
					if(e.field == 'INOUT_P')return true;
					if(e.field == 'PRICE_YN')return true;
					if(e.field == 'LOT_NO')return true;
					if(e.field == 'ORDER_UNIT_P')return true;
					if(e.field == 'ORDER_UNIT_I')return true;
					if(e.field == 'ORDER_UNIT_FOR_P')return true;
					if(e.field == 'ORDER_UNIT_FOR_O')return true;
					if(e.field == 'REMARK')return true;
					if(e.field == 'PROJECT_NO')return true;
					if(e.field == 'TRANS_COST')return true;
					if(e.field == 'TARIFF_AMT')return true;
					else{
						return false;
					}
				}
			}else{
				if(e.record.phantom){
					if(e.record.ORDER_TYPE == '3'){
						if(e.field == 'BL_NUM') return true;
					}else{
						if(e.field == 'BL_NUM') return false;
					}
					if(e.record.phantom){
						if(e.field == 'ITEM_CODE') return true;
						if(e.field == 'ITEM_NAME') return true;
						if(e.field == 'INOUT_METH') return true;
						if(e.field == 'WH_CODE') return true;
						if(e.field == 'WH_CELL_CODE') return true;
						if(e.field == 'ORDER_TYPE') return true;
						if(e.field == 'INOUT_SEQ') return true;
					}else{
						if(e.field == 'ITEM_CODE') return false;
						if(e.field == 'ITEM_NAME') return false;
						if(e.field == 'INOUT_METH') return false;
						if(e.field == 'WH_CODE') return false;
						if(e.field == 'WH_CELL_CODE') return false;
						if(e.field == 'ORDER_TYPE') return false;
						if(e.field == 'INOUT_SEQ') return false;
					}
					if(e.field == 'ORDER_UNIT_P')return true;
					if(e.field == 'ORDER_UNIT_I')return true;
					if(e.field == 'ORDER_UNIT_FOR_P')return true;
					if(e.field == 'ORDER_UNIT_FOR_O')return true;
					if(e.field == 'ORDER_UNIT')return true;
					if(e.field == 'REMARK')return true;
					if(e.field == 'PROJECT_NO')return true;
					if(e.field == 'TRANS_COST')return true;
					if(e.field == 'TARIFF_AMT')return true;
					if(e.field == 'LOT_NO')return true;
					if(e.record.data.ORDER_UNIT != e.record.data.STOCK_UNIT){
						if(e.field == 'TRNS_RATE')return true;
					}else{
						if(e.field == 'TRNS_RATE')return false;
					}
				}else{
					return false;
				}
			}
			if(e.record.phantom == false )
				{
					if(e.record.data.RECEIPT_Q == e.record.data.INSPEC_Q)	{
      					if(e.field=='RECEIPT_Q') return false;
      					if(e.field=='LOT_NO') return false;
						if(e.field=='REMARK') return false;
						if(e.field=='RECEIPT_PRSN') return false;
						if(e.field=='PROJECT_NO') return false;
      				}else {
      					if(e.field=='RECEIPT_Q') return true;
      					if(e.field=='LOT_NO') return true;
						if(e.field=='REMARK') return true;
						if(e.field=='RECEIPT_PRSN') return true;
						if(e.field=='PROJECT_NO') return true;
      				}
					if(e.field=='RECEIPT_SEQ') return false;
					if(e.field=='ITEM_CODE') return false;
					if(e.field=='ITEM_NAME') return false;
					if(e.field=='SPEC') return false;
					if(e.field=='ORDER_UNIT') return false;
					if(e.field=='NOT_RECEIPT_Q') return false;
					if(e.field=='INSPEC_Q') return false;
					if(e.field=='ORDER_NUM') return false;
					if(e.field=='ORDER_SEQ') return false;
					if(e.field=='TRADE_FLAG_YN') return false;
				}
				else if(e.record.phantom )	{					
						if(e.field=='LOT_NO') return true;
						if(e.field=='REMARK') return true;
						if(e.field=='RECEIPT_Q') return true;
						if(e.field=='RECEIPT_PRSN') return true;
						if(e.field=='PROJECT_NO') return true;
						if(e.field=='RECEIPT_SEQ') return false;
						if(e.field=='ITEM_CODE') return false;
						if(e.field=='ITEM_NAME') return false;
						if(e.field=='SPEC') return false;
						if(e.field=='ORDER_UNIT') return false;
						if(e.field=='NOT_RECEIPT_Q') return false;
						if(e.field=='INSPEC_Q') return false;
						if(e.field=='ORDER_NUM') return false;
						if(e.field=='ORDER_SEQ') return false;
						if(e.field=='TRADE_FLAG_YN') return false;
      			}*/
			}
		},
        setItemData: function(record, dataClear, grdRecord) {
//       		var grdRecord = this.uniOpt.currentRecord;
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'			, "");
       			grdRecord.set('ITEM_NAME'			, "");
       			grdRecord.set('SPEC'				, ""); 
				grdRecord.set('STOCK_UNIT'			, "");
				grdRecord.set('ORDER_UNIT'			, "");
				grdRecord.set('TRNS_RATE'			, 0);
				grdRecord.set('ITEM_ACCOUNT'		, "");				
				masterForm.setValue('ITEM_CODE'		, "");
				masterForm.setValue('ORDER_UNIT'	, "");
				grdRecord.set('ORDER_UNIT_FOR_P'	, 0);
				grdRecord.set('ORDER_UNIT_P'		, 0);
				grdRecord.set('SALE_BASIS_P'		, 0);
				
				
				grdRecord.set('GOOD_STOCK_Q'		, "");
				grdRecord.set('BAD_STOCK_Q'			, "");
				grdRecord.set('PURCHASE_TYPE'		, "");
				grdRecord.set('SALES_TYPE'			, "");
				grdRecord.set('PURCHASE_RATE'		, "");
				grdRecord.set('TAX_TYPE'			, "");
				
				
				grdRecord.set('ORDER_UNIT_Q'		, 0);
				grdRecord.set('ORDER_UNIT_FOR_O'	, 0);
				
				
				grdRecord.set('CLOSE_YN'	, "N");
				
       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);

       			grdRecord.set('SPEC'				, record['SPEC']); 
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
				grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
				grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			//	grdRecord.set('ORDER_UNIT_FOR_P'    , record['ORDER_P']);
				grdRecord.set('SALE_BASIS_P'		, record['SALE_BASIS_P']);
				grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);	
				
				grdRecord.set('ORDER_UNIT_Q'		, 0);
				grdRecord.set('ORDER_UNIT_FOR_O'	, 0);
				
				
				grdRecord.set('CLOSE_YN'	, "N");
				
				masterForm.setValue('ITEM_CODE',record['ITEM_CODE']);
				masterForm.setValue('ORDER_UNIT',record['ORDER_UNIT']);
				
				
				
				var param = {"ITEM_CODE": record['ITEM_CODE'],
							"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE'),
							"DIV_CODE": masterForm.getValue('DIV_CODE'),
							"MONEY_UNIT": masterForm.getValue('MONEY_UNIT'),
							"ORDER_UNIT": masterForm.getValue('ORDER_UNIT'),
							"RETURN_DATE": masterForm.getValue('RETURN_DATE')
				};
					mrt200ukrvService.fnOrderPrice(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
					grdRecord.set('PURCHASE_TYPE', provider['PURCHASE_TYPE']);
					grdRecord.set('SALES_TYPE', provider['SALES_TYPE']);
					grdRecord.set('ORDER_UNIT_FOR_P', provider['ORDER_P']);
					grdRecord.set('ORDER_UNIT_P', (provider['ORDER_P'] * grdRecord.get('EXCHG_RATE_O')));
					grdRecord.set('PURCHASE_RATE', provider['PURCHASE_RATE']);
					grdRecord.set('INOUT_FOR_P', (provider['ORDER_P'] / grdRecord.get('TRNS_RATE')));
					grdRecord.set('INOUT_P', (provider['ORDER_P'] / grdRecord.get('TRNS_RATE') * grdRecord.get('EXCHG_RATE_O')));
					
					}
				})
				
				
//				var param = {"ITEM_CODE": record['ITEM_CODE']};
//					mrt200ukrvService.fnSaleBasisP(param, function(provider, response)	{
//					if(!Ext.isEmpty(provider)){
//					grdRecord.set('SALE_BASIS_P', provider['SALE_BASIS_P']);
//					}
//				})
				
				
				
				
				//UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
       			UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );
       		}
		}
    });   
	
    var inoutNoMasterGrid = Unilite.createGrid('mrt200ukrvinoutNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
        // title: '기본',
        layout : 'fit',   
        excelTitle: '반품접수등록(반품접수번호검색)',
		store: inoutNoMasterStore,
		uniOpt:{	
			expandLastColumn: false,
			useRowNumberer: false
		},
        columns:  [ 
			{ dataIndex: 'CUSTOM_NAME'       		    ,  width:166},
			{ dataIndex: 'RETURN_DATE'       		    ,  width:80},
			{ dataIndex: 'CUSTOM_CODE'       		    ,  width:100,hidden:true},
			{ dataIndex: 'WH_CODE'          		    ,  width:120,align:'center'},
			{ dataIndex: 'DIV_CODE'         		    ,  width:100},
			{ dataIndex: 'DEPT_CODE'         		    ,  width:100,hidden:true},
			{ dataIndex: 'DEPT_NAME'         		    ,  width:100,align:'center'},
			{ dataIndex: 'RETURN_CODE' 	     		    ,  width:100},
			{ dataIndex: 'INOUT_PRSN' 	     		    ,  width:80,align:'center'},
			{ dataIndex: 'RETURN_NUM'        		    ,  width:146},
			{ dataIndex: 'SUM_ORDER_UNIT_Q' 	     	,  width:100},
			{ dataIndex: 'SUM_ORDER_UNIT_FOR_O' 	    ,  width:100},
			{ dataIndex: 'MONEY_UNIT'        		    ,  width:88,hidden:true}
		],
        listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				inoutNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
				masterForm.setAllFieldsReadOnly(true);

			}
		},
		returnData: function(record)	{
          	if(Ext.isEmpty(record))	{
          		record = this.getSelectedRecord();
          	}
          	masterForm.setValues({
          		'DIV_CODE':record.get('DIV_CODE'),
          		'RETURN_DATE':record.get('RETURN_DATE'), 
          		'RETURN_NUM':record.get('RETURN_NUM'),
          		'WH_CODE':record.get('WH_CODE'),
          		'CUSTOM_CODE':record.get('CUSTOM_CODE'),
          		'CUSTOM_NAME':record.get('CUSTOM_NAME'),
          		'DEPT_CODE':record.get('DEPT_CODE'),
          		'DEPT_NAME':record.get('DEPT_NAME'),
          		'RETURN_CODE':record.get('RETURN_CODE'),
          		'MONEY_UNIT':record.get('MONEY_UNIT')
          		});


          	panelResult.setValues({
          		/*'INOUT_DATE':record.get('INOUT_DATE'), 
          		'RETURN_NUM':record.get('RETURN_NUM'),
          		'WH_CODE':record.get('WH_CODE'),*/
          		'DIV_CODE':record.get('DIV_CODE'),
          		'RETURN_DATE':record.get('RETURN_DATE'), 
          		'RETURN_NUM':record.get('RETURN_NUM'),
          		'WH_CODE':record.get('WH_CODE'),
          		'CUSTOM_CODE':record.get('CUSTOM_CODE'),
          		'CUSTOM_NAME':record.get('CUSTOM_NAME'),
          		'DEPT_CODE':record.get('DEPT_CODE'),
          		'DEPT_NAME':record.get('DEPT_NAME'),
          		'RETURN_CODE':record.get('RETURN_CODE'),
          		'MONEY_UNIT':record.get('MONEY_UNIT')
          	/*	'EXCHG_RATE_O':record.get('EXCHG_RATE_O'),
          		'MONEY_UNIT':record.get('MONEY_UNIT')*/
          		});
          }
    });
    
    function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '반품접수번호검색',
                width: 1150,				                
                height: 380,
                layout: {type:'vbox', align:'stretch'},	                
                items: [inoutNoSearch, inoutNoMasterGrid], //inoutNoDetailGrid],
                tbar:  ['->',
			        {	
			        	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							inoutNoMasterStore.loadStoreRecords();
						},
						disabled: false
					}, {
						itemId : 'inoutNoCloseBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
		    ],
				listeners : {
					beforehide: function(me, eOpt)	{
						inoutNoSearch.clearForm();
						inoutNoMasterGrid.reset();
						//inoutNoDetailGrid.reset();	                							
					},
					 beforeclose: function( panel, eOpts )	{
						inoutNoSearch.clearForm();
						inoutNoMasterGrid.reset();
						//inoutNoDetailGrid.reset();
		 			},
					 show: function( panel, eOpts )	{
			    		inoutNoSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
				 		inoutNoSearch.setValue('RETURN_DATE_FR',UniDate.get('startOfMonth', masterForm.getValue('RETURN_DATE')));
				 		inoutNoSearch.setValue('RETURN_DATE_TO',masterForm.getValue('RETURN_DATE'));
				 		inoutNoSearch.setValue('WH_CODE',masterForm.getValue('WH_CODE'));
				 		inoutNoSearch.setValue('CUSTOM_CODE',masterForm.getValue('CUSTOM_CODE'));
				 		inoutNoSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
				 		inoutNoSearch.setValue('INOUT_PRSN',masterForm.getValue('INOUT_PRSN'));
				 		inoutNoSearch.setValue('DEPT_CODE',masterForm.getValue('DEPT_CODE'));
				 		inoutNoSearch.setValue('DEPT_NAME',masterForm.getValue('DEPT_NAME'));
//				 		inoutNoSearch.setValue('RETURN_CODE',masterForm.getValue('RETURN_CODE'));
				 		
			    	/*	inoutNoSearch.setValue('ORDER_PRSN',masterForm.getValue('ORDER_PRSN'));
			    		inoutNoSearch.setValue('CUSTOM_CODE',masterForm.getValue('CUSTOM_CODE'));
			    		inoutNoSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
			    		inoutNoSearch.setValue('ORDER_TYPE',masterForm.getValue('ORDER_TYPE'));
			    		*/
					 }
                }		
			})
		}
		SearchInfoWindow.show();
		SearchInfoWindow.center();
    }
    
    Unilite.Main( {
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
		id  : 'mrt200ukrvApp',
		fnInitBinding: function(){
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);
			this.setDefault();
			/*masterForm.setValue('DEPT_CODE',UserInfo.deptCode);
			masterForm.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);*/
//			masterForm.setValue('INOUT_PRSN',BsaCodeInfo.gsInOutPrsn);
//			panelResult.setValue('INOUT_PRSN',BsaCodeInfo.gsInOutPrsn);
			/*mrt200ukrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			});*/
			
		},
		onQueryButtonDown: function() {         
			masterForm.setAllFieldsReadOnly(false);
			var inoutNo = masterForm.getValue('RETURN_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow() 
			} else {
			//	var param= masterForm.getValues();
			//	masterForm.getForm().load({params: param})
				directMasterStore1.loadStoreRecords();	
				masterForm.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			};
/*			
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ",viewLocked);
			console.log("viewNormal: ",viewNormal);
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	*/			
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				 var inoutNum = masterForm.getValue('RETURN_NUM');
				 var seq = directMasterStore1.max('RETURN_SEQ');
            	 if(!seq){
            	 	seq = 1;
            	 }else{
            	 	seq += 1;
            	 }
            	 var sortSeq = directMasterStore1.max('SORT_SEQ');
            	 if(!sortSeq){
            	 	sortSeq = 1;
            	 }else{
            	 	sortSeq += 1;
            	 }
            	 var compCode = UserInfo.compCode;   
            	 var divCode  = masterForm.getValue('DIV_CODE');   	
            	              
            	 var lotNo	  = '';       
            	 var lotAssignedYN = 'N';
            	 var purchaseType  = '';
            	 var salesType	   = '';   
//            	 var goodStockQ	   =   
//            	 var saleBasisP	   =  
//            	 var purchaseRate  =   
//            	 var orderUnitForP =
//            	 var orderUnitQ    =    
//            	 var orderUnitForO =
            	 var remark		   = ''; 
            	 var whCode		   = masterForm.getValue('WH_CODE');
            	 var closeYN	   = 'N';
            	 
           // 	 var compCode =  ??확인 필요
            	 
            	 
            	 var r = {
            	 	COMP_CODE:			compCode,
					DIV_CODE:			divCode,    	
					RETURN_SEQ:			seq,     		
//					ITEM_CODE:itemCode,      
//					ITEM_NAME:itemName,       
//					SPEC:     		
//					ORDER_UNIT:         
					LOT_NO:				lotNo,        	
					LOT_ASSIGNED_YN:	lotAssignedYN,    
					PURCHASE_TYPE:		purchaseType,      
					SALES_TYPE:			salesType,         
//					GOOD_STOCK_Q:		goodStockQ,         	
//					SALE_BASIS_P:		saleBasisP,       
//					PURCHASE_RATE:		purchaseRate,      
//					ORDER_UNIT_FOR_P:	orderUnitForP,   
//					ORDER_UNIT_Q:		orderUnitQ,       
//					ORDER_UNIT_FOR_O:	orderUnitForO,   
					REMARK:				remark,
					WH_CODE:			whCode,
					CLOSE_YN:			closeYN,
					SORT_SEQ: sortSeq
		        };
				masterGrid.createRow(r,'ITEM_CODE');
				masterForm.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		
		onSaveDataButtonDown: function(config) {				
			directMasterStore1.saveStore();
		},
		
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				
				
				masterGrid.deleteSelectedRow();
				
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('RETURN_CONFIRM_Q') > 0)
				{
					alert('<t:message code="확정수량이 존재 합니다.\n 삭제 할 수 없습니다."/>');
				}else{
					masterGrid.deleteSelectedRow();
				}
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
						if(record.get('RETURN_CONFIRM_Q') > 0)
							{
								alert('<t:message code="확정수량이 존재 합니다.\n 삭제 할 수 없습니다."/>');
							}else{						
						var deletable = true;
						if(deletable){		
							masterGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;							
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
		checkForNewDetail:function() { 
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('RETURN_NUM')))	{
				alert('<t:message code="unilite.msg.sMS533" default="반품번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}
			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return masterForm.setAllFieldsReadOnly(true);
        },
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		
		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('searchForm').getValues();
	
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/mrt/mrt200rkrPrint.do',
	            prgID: 'mrt200rkr',
	               extParam: {
	                  RETURN_NUM : param.RETURN_NUM,
	                  DIV_CODE  : param.DIV_CODE
	               }
	            });
	            win.center();
	            win.show();
	               
	      },
		setDefault: function() {
			UniAppManager.setToolbarButtons(['print'], false);
        	masterForm.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	masterForm.setValue('RETURN_DATE',UniDate.get('today'));
        	panelResult.setValue('RETURN_DATE',UniDate.get('today'));
//        	masterForm.setValue('CREATE_LOC','1');
//        	panelResult.setValue('CREATE_LOC','1');
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
			var field = masterForm.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('INOUT_PRSN');			
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");	
			field = inoutNoSearch.getField('INOUT_PRSN');			
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
		},
		
 		fnInTypeAccountYN:function(subCode){
 			var fRecord ='';
        	Ext.each(BsaCodeInfo.gsInTypeAccountYN, function(item, i)	{
        		if(item['codeNo'] == subCode && !Ext.isEmpty(item['refCode4'])) {
        			fRecord = item['refCode4'];
        		}
        	});
        	if(Ext.isEmpty(fRecord)){
        		fRecord = 'N'
        	}
        	return fRecord;
        },
        cbStockQ: function(provider, params)	{  
	    	var rtnRecord = params.rtnRecord;
			
			//var dStockQ = Unilite.nvl(provider['STOCK_Q'], 0);
			//var dOrderQ = Unilite.nvl(rtnRecord.get('ORDER_Q'), 0);
			//var lTrnsRate = rtnRecord.get('TRANS_RATE');
			
	    	var dGoodStockQ = provider['GOOD_STOCK_Q'];
//	    	var dBadStockQ = provider['BAD_STOCK_Q'];
			rtnRecord.set('GOOD_STOCK_Q', dGoodStockQ);
//			rtnRecord.set('BAD_STOCK_Q', dBadStockQ);
	    }
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
					
				case "RETURN_SEQ" :
					if(newValue != ''){
						if(newValue <= 0){
							rv='<t:message code="unilite.msg.sMB076"/>';
							break;
						}
//						else if(clng(grdsheet1.TextMatrix(lRow,lCol)) != fnCDbl(grdsheet1.TextMatrix(lRow,lCol))){ //?
//							rv='<t:message code="unilite.msg.sMB087"/>';
//						}
					}
					
				case "ITEM_CODE" :
					if(record.get('ACCOUNT_YNC') == 'N'){
						record.set('PRICE_YN','N');
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
						

					}
					break;
				case "ITEM_NAME" :
					if(record.get('ACCOUNT_YNC') == 'N'){
						record.set('PRICE_YN','N');
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
						

					}
					break;
				case "ORDER_UNIT_Q" :	//입고량
					if(newValue != oldValue){		
						if(record.get('ITEM_CODE') == ''){
							rv='<t:message code="unilite.msg.sMM033"/>';
							break;
						}
					}
				/*	var order_q = newValue;
					var lot_q = record.get('TEMP_ORDER_UNIT_Q');//로트팝업에서 넘겨받는 수량
					if(!Ext.isEmpty(lot_q) && lot_q!= 0){
						if(order_q > lot_q){
							rv = "반품량은 lot재고량을 초과할 수 없습니다. 현재고: " + lot_q;
							break;
						}
					}*/
					var dInoutQ3 = newValue * record.get('TRNS_RATE');
					
					if(!(newValue < '0')){
						if(record.get('ORDER_NUM') != ''){
							
							//var dTempQ =0;
							var dOrderQ = record.get('ORDER_Q');	//발주량
							var dInoutQ = newValue * record.get('TRNS_RATE');	//입력한 입고량  * 입수
							var dNoInoutQ =  record.get('NOINOUT_Q');	//미입고량
							
							var dEnableQ = (dOrderQ + dOrderQ * record.get('EXCESS_RATE') / 100) / record.get('TRNS_RATE');	
											//(발주량 + 발주량 * 과입고허용률 / 100) / 입수
							var dTempQ = ((dOrderQ - dNoInoutQ + dInoutQ - record.get('ORIGINAL_Q')) / record.get('TRNS_RATE'));
											// ( 발주량 - 미입고량 + (입력한 입고량*입수) - 기존입고량	) / 입수

							if(dNoInoutQ > 0){
								if(dTempQ > dEnableQ){
									 dEnableQ = (dNoInoutQ + record.get('ORIGINAL_Q')) / record.get('TRNS_RATE') + (dEnableQ - (dOrderQ / record.get('TRNS_RATE')));
									//	(미입고량 + 기존입고량) / 입수 + (1100 - 발주량 /입수 )
									rv='<t:message code = "unilite.msg.sMM351"/>' + '<t:message code = "unilite.msg.sMM534"/>' + ":" + dEnableQ;
									break;
								}
							}
						}
					}
					
						
					record.set('INOUT_Q',dInoutQ3);
					
					if(BsaCodeInfo.gsInvstatus == '+'){
						if(record.get('STOCK_CARE_YN') == 'Y'){
							if(newValue < 0){
								var dInoutQ1 = 0;
								var dOriginalQ = 0;
								
								dInoutQ1 = dInoutQ1 + newValue;
								dOriginalQ = dOriginalQ + record.get('ORIGINAL_Q');
								
								if(record.get('ITEM_STATUS') == '1'){
									dStockQ = record.get('GOOD_STOCK_Q');	
								}else{
									dStockQ = record.get('BAD_STOCK_Q');	
								}
								
								if((dStockQ - dOriginalQ) < dInoutQ1 * -1){
									rv='<t:message code = "unilite.msg.sMM349"/>'+" : " + (dStockQ - dOriginalQ) ;
										record.set('INOUT_Q', oldValue);
								}
							}
						}
					}
					
					if(!Ext.isEmpty(record.get('ORDER_UNIT_P')) && record.get('ORDER_UNIT_P') != 0){
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_P') * newValue));	//자사금액= 자사단가 * 입력한입고량
						
						var param = {"COMP_CODE": record.get('COMP_CODE'),
									"ITEM_CODE": record.get('ITEM_CODE'),
									"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE'),
									"ORDER_UNIT_P": record.get('ORDER_UNIT_P'),
									"ORDER_UNIT_Q" : newValue
									};
									
					mrt200ukrvService.fnGetCalcTaxAmt(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
						record.set('INOUT_I', provider['INOUT_I']);
						record.set('INOUT_TAX_AMT', provider['INOUT_TAX_AMT']);
						record.set('INOUT_TOTAL_I', provider['INOUT_TOTAL_I']);//record.get('ORDER_UNIT_I') + record.get('INOUT_TAX_AMT'));
						
//						record.set('INOUT_I',record.get('ORDER_UNIT_I'));	//자사금액(재고) = 자사금액
						}
					});
					//	record.set('ORDER_UNIT_I') = 
				//보류 반올림		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
					}else{
						record.set('ORDER_UNIT_I','0'); 
					}
					
					if(record.get('ORDER_UNIT_FOR_P') != ''){
						record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_FOR_P') * newValue));	//구매금액 = 구매단가 * 입력한 입고량
						//record.set('ORDER_UNIT_FOR_O') = 
				//보류 반올림		Math.round(record.get('ORDER_UNIT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_FOR_O")), top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
						record.set('INOUT_FOR_O',record.get('ORDER_UNIT_FOR_O'));	//재고단위금액  = 구매금액
					}else{
						record.set('ORDER_UNIT_FOR_O','0');
					}

					record.set('INOUT_P',(record.get('ORDER_UNIT_P') / record.get('TRNS_RATE')));	//자사단가(재고) = 자사단가 / 입수
					record.set('INOUT_I',record.get('ORDER_UNIT_I'));	//자사금액(재고) = 자사금액
					record.set('INOUT_FOR_O',record.get('ORDER_UNIT_FOR_O'));	//재고단위금액  = 구매금액  
					

					
				break;
				case "INOUT_P" :	//자사단가(재고)
					if((record.get('ACCOUNT_YNC')== 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')){
						if(newValue <= 0){
							rv='<t:message code = "unilite.msg.sMM375"/>';
							break;
						}
					}else{
						if(newValue < 0){
							rv='<t:message code = "unilite.msg.sMM376"/>';
							break;
						}
					}
					
					record.set('INOUT_I', (record.get('INOUT_Q') * newValue));	//자사금액(재고) = 재고단위 수량 * 입력한 자사단가(재고)
					//record.set('INOUT_I') = 
			//보류 반올림		Math.round(record.get('INOUT_I'),CustomCodeInfo.gsUnderCalBase);
					//fnRound(grdsheet1.TextMatrix(grdsheet1.Row, grdsheet1.colindex("INOUT_I")),top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
				
                    if(record.get('EXCHG_RATE_O') != 0){
                    	record.set('INOUT_FOR_P',(newValue / record.get('EXCHG_RATE_O')));	//재고단위단가 = 입력한 자사단가(재고) / 환율
                    	record.set('INOUT_FOR_O',(record.get('INOUT_Q') * newValue / record.get('EXCHG_RATE_O')));	//재고단위금액 = 재고단위수량 * 입력한 자사단가(재고) / 환율
                    	//record.set('INOUT_FOR_O') = 
             //보류 반올림       	Math.round(record.get('INOUT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
                    	//fnRound(grdsheet1.TextMatrix(grdsheet1.Row, grdsheet1.colindex("INOUT_FOR_O")),top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
                    }else{
                    	record.set('INOUT_FOR_O','0');
                    	record.set('INOUT_FOR_P','0');
                    }

					break;
				case "INOUT_I" :	//자사금액(재고)
					if(newValue < 0){
						rv='<t:message code = "unilite.msg.sMB076"/>';
						break;
					}
                    
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_P',(newValue / record.get('INOUT_Q')));	// 자사단가(재고) = 입력한 자사금액(재고) / 재고단위수량
					}else{
						record.set('INOUT_P','0');	
					}
					
					if(record.get('EXCHG_RATE_O') != 0){
                    	record.set('INOUT_FOR_P',(record.get('INOUT_P') / record.get('EXCHG_RATE_O')));	//재고단위단가 = 자사단가(재고) / 환율
                    	record.set('INOUT_FOR_O',(newValue / record.get('EXCHG_RATE_O')));	//재고단위금액 = 입력한 자사금액(재고) / 환율
                    	//record.set('INOUT_FOR_O' =
           //보류 반올림         	Math.round(record.get('INOUT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
                    	//fnRound(grdsheet1.TextMatrix(grdsheet1.Row, grdsheet1.colindex("INOUT_FOR_O")),top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
                    }else{
                    	record.set('INOUT_FOR_O','0');
                    	record.set('INOUT_FOR_P','0');
                    }

					break;
//				case "ORDER_UNIT" :
				case "TRNS_RATE" :	//입수
					if(newValue <= 0){
						rv='<t:message code = "unilite.msg.sMB076"/>';
						break;
					}
					
					if(record.get('ORDER_UNIT_Q') != ''){
						record.set('INOUT_Q',record.get('ORDER_UNIT_Q') * newValue); 	//재고단위수량 = 입고량 * 입력한 입수
					}else{
						record.set('INOUT_Q','0');
					}
					
					
					
					if(record.get('ORDER_UNIT_P') != ''){
						record.set('INOUT_P',(record.get('ORDER_UNIT_P') / newValue));	//자사단가(재고) = 자사단가 / 입력한 입수
					}else{
						record.set('INOUT_P','0');
					}
					
					if(record.get('ORDER_UNIT_FOR_P') != ''){
						record.set('INOUT_FOR_P',(record.get('ORDER_UNIT_FOR_P') / newValue));	//재고단위단가 = 구매단가 / 입력한 입수
					}else{
						record.set('INOUT_FOR_P','0');
					}
					break;
				case "ORDER_UNIT_P":	//자사단가
					if((record.get('ACCOUNT_YNC') == 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')){
						if(newValue <= 0){
							rv='<t:message code = "unilite.msg.sMM375"/>';
							break;
						}					
					}else{
						if(newValue < 0){
							rv='<t:message code = "unilite.msg.sMM376"/>';
							break;
						}
						
					}
					
					record.set('INOUT_P',(newValue / record.get('TRNS_RATE')));	//자사단가(재고) = 입력한 자사단가 / 입수
					record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * newValue));	//자사금액 = 입고량 * 입력한 자사단가
					//record.set('ORDER_UNIT_I') = 
				//보류 반올림	Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
					//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")),top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
                    record.set('INOUT_I',(record.get('ORDER_UNIT_I')));	//자사금액(재고) = 자사금액
                    //record.set('INOUT_I') = 
               //보류 반올림     Math.round(record.get('INOUT_I'),CustomCodeInfo.gsUnderCalBase);
                    //fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("INOUT_I")), top.sWonflag,top.goCnn.GetFSET("M_FSET_IS"));
                    
                    if(record.get('EXCHG_RATE_O') != 0){
                    	record.set('INOUT_FOR_P',(record.get('INOUT_P') / record.get('EXCHG_RATE_O')));	//재고단위단가 = 자사단가(재고)/환율
                    	record.set('ORDER_UNIT_FOR_P',(newValue / record.get('EXCHG_RATE_O')));	//	구매단가 = 입력한 자사단가 / 환율
                    	record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_Q') * newValue / record.get('EXCHG_RATE_O')));	//구매금액 = 입고량 * 입력한 자사단가 / 환율
                    	//record.set('ORDER_UNIT_FOR_O') = 
               //보류 반올림     	Math.round(record.get('ORDER_UNIT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
                    	//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_FOR_O")),top.sWonflag, top.goCnn.GetFSET("M_FSET_OS")); 
                    	
                    	record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
                    	//record.set('INOUT_FOR_O') = 
               //보류 반올림     	Math.round(record.get('INOUT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
                    	//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("INOUT_FOR_O")),top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
                    	
                    }else{
                    	record.set('INOUT_FOR_O','0');
                    	record.set('INOUT_FOR_P','0');
                    	record.set('ORDER_UNIT_FOR_O','0');
                    	record.set('ORDER_UNIT_FOR_P','0');
                    }

                    break;
				case "ORDER_UNIT_I" :	//자사금액
					if(record.get('ORDER_UNIT_Q') != ''){
						if((newValue <= 0) && (record.get('ORDER_UNIT_Q') > 0)){
							rv='<t:message code = "unilite.msg.sMB076"/>';
							break;
						}else if((newValue >= 0) && (record.get('ORDER_UNIT_Q') < 0)){
							rv='<t:message code = "unilite.msg.sMB077"/>';
							break;
						}
					}
					
					//record.set('INOUT_I') = 
		//보류 반올림			Math.round(newValue,CustomCodeInfo.gsUnderCalBase);
					//fnRound(grdsheet1.TextMatrix(lRow,lCol), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_P',(record.get('INOUT_I') / record.get('INOUT_Q')));	//자사단가(재고) = 자사금액(재고) / 재고단위수량
						record.set('ORDER_UNIT_P',(newValue / record.get('ORDER_UNIT_Q')));	//자사단가 = 입력한 자사금액 / 입고량
					}else{
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_P','0');
					}
					
					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_P') / record.get('EXCHG_RATE_O')));	//재고단위단가 = 자사단가(재고) / 환율
						record.set('ORDER_UNIT_FOR_P',(record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O')));	//구매단가 = 자사단가 / 환율
						record.set('ORDER_UNIT_FOR_O',(newValue / record.get('EXCHG_RATE_O')));	//구매금액 = 입력한 자사금액 / 환율
						//record.set('ORDER_UNIT_FOR_O') = 
			//보류 반올림			Math.round(record.get('ORDER_UNIT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_FOR_O")),top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
						record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					}else{
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}

                    break;
				case "PURCHASE_RATE" :	//매입율& 단가 & 수량 & 판매가 관계 추가
                	record.set("ORDER_UNIT_FOR_P",record.get('SALE_BASIS_P') * newValue / 100);
                	record.set("ORDER_UNIT_FOR_O",(record.get('SALE_BASIS_P') * newValue / 100)* record.get("ORDER_UNIT_Q"));
                	
                	record.set("INOUT_FOR_P",record.get("ORDER_UNIT_FOR_P")/record.get("TRNS_RATE"));
                	record.set("INOUT_FOR_O",record.get("INOUT_FOR_P")*record.get("ORDER_UNIT_Q") * record.get("TRNS_RATE"));
                	
                	record.set("INOUT_P",record.get("ORDER_UNIT_FOR_P") / record.get("TRNS_RATE") * record.get("EXCHG_RATE_O"));
                	record.set("INOUT_I",record.get("INOUT_P") * record.get("ORDER_UNIT_Q") * record.get("TRNS_RATE"));
                	
                	record.set("ORDER_UNIT_P",record.get("ORDER_UNIT_FOR_P") * record.get("EXCHG_RATE_O"));
                	record.set("ORDER_UNIT_I",record.get("ORDER_UNIT_P") * record.get("ORDER_UNIT_Q"));
                	
                	
                	var param = {"COMP_CODE": record.get('COMP_CODE'),
									"ITEM_CODE": record.get('ITEM_CODE'),
									"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE'),
									"ORDER_UNIT_P": record.get('ORDER_UNIT_P'),
									"ORDER_UNIT_Q" : record.get('ORDER_UNIT_Q')
									};
					mrt200ukrvService.fnGetCalcTaxAmt(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
						record.set('INOUT_I', provider['INOUT_I']);
						record.set('INOUT_TAX_AMT', provider['INOUT_TAX_AMT']);
						record.set('INOUT_TOTAL_I', provider['INOUT_TOTAL_I']);//record.get('ORDER_UNIT_I') + record.get('INOUT_TAX_AMT'));

						
						
						}
					});
                    break; 	
				case "ORDER_UNIT_FOR_P":	//구매단가
					if((record.get('ACCOUNT_YNC')== 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')){
						if(newValue <= 0){
							rv='<t:message code = "unilite.msg.sMM375"/>';
							break;
						}
					}else{
						if(newValue < 0){
							rv='<t:message code = "unilite.msg.sMM376"/>';
							break;
						}
						
					}
					record.set("PURCHASE_RATE", newValue / record.get("SALE_BASIS_P") * 100);	//매입율& 단가 & 수량 & 판매가 관계 추가
					//record.set('ORDER_UNIT_FOR_O') = 
		//보류 반올림			Math.round((record.get('ORDER_UNIT_Q') * newValue),CustomCodeInfo.gsUnderCalBase);
					record.set('ORDER_UNIT_FOR_O', record.get('ORDER_UNIT_Q') * newValue);
					//fnRound(fnCDbl(grdsheet1.TextMatrix(lRow,grdsheet1.colindex("ORDER_UNIT_Q")))  *  fnCDbl(grdsheet1.TextMatrix(lRow,	grdsheet1.colindex("ORDER_UNIT_FOR_P"))), top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
					record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}

				
					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P',(newValue * record.get('EXCHG_RATE_O')));	//자사단가 = 입력한 구매단가 * 환율
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));	//자사금액 = 입고량 * 자사단가
						
						record.set('INOUT_FOR_P',(newValue / record.get('TRNS_RATE')));
						record.set('INOUT_P',(newValue / record.get('TRNS_RATE') * record.get('EXCHG_RATE_O')));
						record.set('INOUT_I', (record.get('INOUT_P') * record.get('ORDER_UNIT_Q')));
						
						
						
						var param = {"COMP_CODE": record.get('COMP_CODE'),
									"ITEM_CODE": record.get('ITEM_CODE'),
									"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE'),
									"ORDER_UNIT_P": record.get('ORDER_UNIT_P'),
									"ORDER_UNIT_Q" : record.get('ORDER_UNIT_Q')
									};
					mrt200ukrvService.fnGetCalcTaxAmt(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
						record.set('INOUT_I', provider['INOUT_I']);
						record.set('INOUT_TAX_AMT', provider['INOUT_TAX_AMT']);
						record.set('INOUT_TOTAL_I', provider['INOUT_TOTAL_I']);//record.get('ORDER_UNIT_I') + record.get('INOUT_TAX_AMT'));

						
						
						}
					});
						
						
						
						//record.set('ORDER_UNIT_I') = 
				//보류 반올림		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS")); 
						//record.set('INOUT_I') = 
				//보류 반올림		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag,top.goCnn.GetFSET("M_FSET_IS"));
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					break;
					
				case "EXCHG_RATE_O" :	//환율
					if((record.get('ACCOUNT_YNC')== 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')){
						if(newValue <= 0){
							rv='<t:message code = "unilite.msg.sMM375"/>';
							break;
						}
					}else{
						if(newValue < 0){
							rv='<t:message code = "unilite.msg.sMM376"/>';
							break;
						}
					}
					
					//record.set('ORDER_UNIT_FOR_O') = 
		//보류 반올림			Math.round((record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_FOR_P')),CustomCodeInfo.gsUnderCalBase);
					//fnRound(fnCDbl(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_Q")))  *  fnCDbl(grdsheet1.TextMatrix(lRow,grdsheet1.colindex("ORDER_UNIT_FOR_P"))), top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
					record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}

				
					if(newValue != 0){
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * newValue));	//자사단가(재고) = 재고단위단가 * 입력한 환율
						record.set('ORDER_UNIT_P',(record.get('ORDER_UNIT_FOR_P') * newValue));	
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));
						//record.set('ORDER_UNIT_I') = 
			//보류 반올림			Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS")); 
						//record.set('INOUT_I') = 
			//보류 반올림			Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					break;
		
				case "ORDER_UNIT_FOR_O" : //구매금액
					if(record.get('ORDER_UNIT_Q') != ''){
						if((newValue <= 0) && (record.get('ORDER_UNIT_Q') > 0)){
							rv='<t:message code = "unilite.msg.sMB076"/>';
							break;
						}else if((newValue >= 0) && (record.get('ORDER_UNIT_Q') < 0)){
							rv='<t:message code = "unilite.msg.sMB077"/>';
							break;
						}
					}
					
					//record.set('INOUT_FOR_O') = 
			//보류 반올림 		Math.round(newValue,CustomCodeInfo.gsUnderCalBase);
					//fnRound(grdsheet1.TextMatrix(lRow,lCol) , top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
						record.set('ORDER_UNIT_FOR_P',(newValue / record.get('ORDER_UNIT_Q')));	//구매단가 = 입력한 구매금액 / 입고량
					}else{
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}
					
					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P',(record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가 = 구매단가 * 환율
						record.set('ORDER_UNIT_I',(newValue * record.get('EXCHG_RATE_O')));	//자사금액 = 입력한 구매금액 * 환율
						//record.set('ORDER_UNIT_I') = 
			//보류 반올림			Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")),top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
						//record.set('INOUT_I') = 
			//보류 반올림			Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")),top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"))
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}

                    break;
		
				case "MONEY_UNIT" :
			//			"mms510ukrs1v
			//			1392줄~1404줄"
									
			//			"mms510ukrs1v
			//			1406줄~1416줄"
					if(newValue == BsaCodeInfo.gsDefaultMoney){
						record.set('EXCHG_RATE_O','1');	
					}//else
					
					//record.set('ORDER_UNIT_FOR_O') = 
		//보류 반올림			Math.round((record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_FOR_P')),CustomCodeInfo.gsUnderCalBase);
				
					record.set('ORDER_UNIT_FOR_O', record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_FOR_P'));	//구매금액 = 입고량 * 구매단가
					//fnRound(fnCDbl(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_Q"))) * fnCDbl(grdsheet1.TextMatrix(lRow,grdsheet1.colindex("ORDER_UNIT_FOR_P"))), top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
					record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}

					
					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P',(record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가 = 구매단가 * 환율
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));	//자사금액 = 입고량 * 자사단가
						//record.set('ORDER_UNIT_I') = 
				//보류 반올림		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
						//record.set('INOUT_I') = 
				//보류 반올림		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")),top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					break;
	
				case "INOUT_TYPE_DETAIL" :
				record.set('ACCOUNT_YNC', UniAppManager.app.fnInTypeAccountYN(newValue));
				
					if(record.get('ACCOUNT_YNC') == 'N'){
						record.set('PRICE_YN','N');
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
						

					}else{
						record.set('PRICE_YN','Y');	
					}
					break;
	
				case "ACCOUNT_YNC":
					if(newValue == 'N'){
						record.set('PRICE_YN','N');	
					}
					break;
				case "PRICE_YN":
					if(newValue == 'Y'){
						if((record.get('INOUT_P') == 0) || (record.get('ORDER_UNIT_P') == 0)){
							rv='<t:message code = "unilite.msg.sMM327"/>';	
							break;
						}
					}
					break;
				case "PROJECT_NO":
				//	UniAppManager.app.fnPlanNumChange(); //fnPlanNumChange 만들어야함
					break;
				case "TRANS_COST":
					if(newValue < 0){
						rv='<t:message code = "unilite.msg.sMM376"/>';	
						break;
					}
					
				case "TARIFF_AMT":
					if(newValue < 0){
						rv='<t:message code = "unilite.msg.sMM376"/>';	
						break;
					}
	/*				
*//*							이전값 != 입력값 일때
			If "" & grdSheet1.TextMatrix(lRow,0) = " " Then               '갱신될 자료
			       grdSheet1.TextMatrix(lRow,0)    =        "U"
			       glAffectedCnt = glAffectedCnt + 1
			End If
			
			
			'        변경된 자료가 존재함으로 저장할 수 있음
			If top.goCnn.bEnableSaveBtn = 0 Then        
			   top.goCnn.bEnableSaveBtn        = 1
			    grdSheet1.RowData(grdSheet1.row) = "S"
			End If*/
	//				break;
			}
				return rv;
						}
			});	
	Unilite.createValidator('validator02', {
		forms: {'formA:':masterForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {				
				case "EXCHG_RATE_O" :  // 환율
					if(masterForm.getValue('MONEY_UNIT') == BsaCodeInfo.gsDefaultMoney){
							if(newValue != '1'){
								rv='<t:message code = "unilite.msg.sMM336"/>';
								break;
							}
					}
					break;
				
			}
			return rv;
		}
	}); // validator02			
			
};

</script>