<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo201ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo201ukrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P401" /> <!-- 확정여부 --> 
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->  
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->	
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="MPO200ukrvLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="MPO200ukrvLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="MPO200ukrvLevel3Store" />
		<t:ExtComboStore comboType="OU" />										<!-- 창고-->
</t:appConfig>
<script type="text/javascript" >
var referPurchaseWindow;	//구매요청참조
var BsaCodeInfo = {	
	gsApproveYN: '${gsApproveYN}'
};
var CustomCodeInfo = {
	gsUnderCalBase: ''
};

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
			read: 'mpo201ukrvService.gridDown',
			update: 'mpo201ukrvService.updateDetail',
			create: 'mpo201ukrvService.insertDetail',
			destroy: 'mpo201ukrvService.deleteDetail',
			syncAll: 'mpo201ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('Mpo201ukrvModel', {
	    fields: [  	 	
	    	{name: 'COMP_CODE'		,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			,type: 'string'},
	    	{name: 'DIV_CODE'		,text: '<t:message code="system.label.purchase.division" default="사업장"/>'			,type: 'string',comboType:'BOR120'},
	    	{name: 'CONFIRM_YN'		,text: '확정여부'			,type: 'string',allowBlank: false,comboType:'AU', comboCode:'P401'},
	    	{name: 'ORDER_NUM'		,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'			,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: '매입처'			,type: 'string', allowBlank: false},
			{name: 'CUSTOM_NAME'	,text: '매입처명'			,type: 'string', allowBlank: false},
			{name: 'ORDER_DATE'		,text: '<t:message code="system.label.purchase.podate" default="발주일"/>'			,type: 'uniDate', allowBlank: false},
			{name: 'ORDER_PRSN'		,text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'			,type: 'string', allowBlank: false,comboType:'AU', comboCode:'M201'},
			{name: 'MONEY_UNIT'		,text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				,type: 'string'},
			{name: 'AGREE_PRSN'		,text: '<t:message code="system.label.purchase.approvaluser" default="승인자"/>'			,type: 'string'}
		]  
	});	
	Unilite.defineModel('Mpo201ukrvModel2', {
	    fields: [  	 	
	    	{name: 'COMP_CODE'		,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			,type: 'string'},
	    	{name: 'DIV_CODE'		,text: '<t:message code="system.label.purchase.division" default="사업장"/>'			,type: 'string',comboType:'BOR120'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'				,type: 'string'},
			{name: 'ORDER_NUM'		,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'			,type: 'string'},
			{name: 'AUTHOR1'		,text: '저자'				,type: 'string'},
			{name: 'PUBLISHER'		,text: '출판사'			,type: 'string'},
			{name: 'ORDER_Q'		,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'			,type: 'uniQty', allowBlank: false},
			{name: 'ORDER_UNIT'		,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			,type: 'string'},
			{name: 'ORDER_UNIT_P'	,text: '<t:message code="system.label.purchase.price" default="단가"/>'				,type: 'uniUnitPrice', allowBlank: false},
			{name: 'ORDER_O'		,text: '<t:message code="system.label.purchase.amount" default="금액"/>'				,type: 'uniPrice', allowBlank: false},
			{name: 'DVRY_DATE'		,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			,type: 'uniDate', allowBlank: false},
			{name: 'WH_CODE'		,text: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>'			,type: 'string', allowBlank: false,  comboType   : 'OU'},
			{name: 'REMARK'			,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				,type: 'string'},
			{name: 'MONEY_UNIT'		,text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'			,type: 'string'},
			{name: 'SAVE_T'			,text: '저장ON체크컬럼'		,type: 'string'},
			{name: 'ORDER_SEQ'		,text: '<t:message code="system.label.purchase.seq" default="순번"/>'				,type: 'int'}
		]  
	});	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore1 = Unilite.createStore('mpo201ukrvMasterStore1',{
		model: 'Mpo201ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable: false,			// 삭제 가능 여부 
	        useNavi: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'mpo201ukrvService.gridUp'                	
			}
		},	
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
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(masterForm.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log(param);
			this.load({
				params : param
			});
		}
	});	
	
	var directMasterStore2 = Unilite.createStore('mpo201ukrvMasterStore2', {
		model: 'Mpo201ukrvModel2',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
			autoLoad: false,
			proxy: directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
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
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("ORDER_NUM_G", master.ORDER_NUM);
						var orderNum = masterForm.getValue('ORDER_NUM_G');
						Ext.each(list, function(record, index) {
							if(record.data['ORDER_NUM'] != orderNum) {
								record.set('ORDER_NUM', orderNum);
							}
						})
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
						
						directMasterStore1.loadStoreRecords();
						masterGrid2.reset();
					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('mpo201ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var masterForm = Unilite.createSearchPanel('searchForm', {		
		title: '구매오더확정조건',
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
				value: UserInfo.divCode,
				child: 'WH_CODE',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('ORDER_PRSN');	
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
			{
				fieldLabel: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>',
				name: 'WH_CODE', 
				xtype: 'uniCombobox', 
				comboType   : 'OU',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '구매예정일',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_EXPECTED_FR',
				endFieldName: 'ORDER_EXPECTED_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank: false,
				holdable: 'hold',
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_EXPECTED_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_EXPECTED_TO',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name:'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M001'
			},
			Unilite.popup('CUST', {
				fieldLabel: '매입처',
				valueFieldName:'CUSTOM_CODE',
		    	textFieldName:'CUSTOM_NAME',
				extParam:{'CUSTOM_TYPE':'2'},
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
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
				fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M201',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode4', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode4', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_PRSN', newValue);
						masterForm.setValue('ORDER_PRSN_G',newValue);
					}
				}
			},{
				fieldLabel: '그리드1의 매입처코드',
				xtype: 'uniTextfield',
				name: 'CUSTOM_CODE_G',
				hidden: true
			},{
			    fieldLabel: '그리드1의 발주일자',
			    name: 'ORDER_REQ_DATE_G',
			    xtype: 'uniDatefield',
			  	width : 200,
				hidden: true
			},{
			    fieldLabel: '그리드1의 발주번호',
			    name: 'ORDER_NUM_G',
			    xtype: 'uniTextfield',
			   	width : 200,
				hidden: true
			},{
			    fieldLabel: '그리드1의 화폐단위',
			    name: 'MONEY_UNIT_G',
			    xtype: 'uniTextfield',
			  	width : 200,
				hidden: true
			},{
			    fieldLabel: '그리드1의 구매담당',
			    name: 'ORDER_PRSN_G',
			    xtype: 'uniTextfield',
			   	width : 200,
				hidden: true
			},{
			    fieldLabel: '승인방법',
			    name: 'AGREE_STATUS_G',
			    xtype: 'uniTextfield',
			  	width : 200,
				hidden: true
			},{
			    fieldLabel: '<t:message code="system.label.purchase.approvaluser" default="승인자"/>',
			    name: 'AGREE_PRSN_G',
			    xtype: 'uniTextfield',
			 	width : 200,
				hidden: true
			},{
			    fieldLabel: '승인일',
			    name: 'AGREE_DATE_G',
			    xtype: 'uniTextfield',
			  	width : 200,
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
							var popupFC = item.up('uniPopupField');							
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
						var popupFC = item.up('uniPopupField');	
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
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			holdable: 'hold',
			value: UserInfo.divCode,
			child: 'WH_CODE',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					combo.changeDivCode(combo, newValue, oldValue, eOpts);						
					var field = masterForm.getField('ORDER_PRSN');
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
			fieldLabel: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>',
			name: 'WH_CODE', 
			xtype: 'uniCombobox', 
			comboType   : 'OU',
			allowBlank: false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					masterForm.setValue('WH_CODE', newValue);
				}
			}
		},{
			fieldLabel: '구매예정일',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_EXPECTED_FR',
			endFieldName: 'ORDER_EXPECTED_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315,
			allowBlank: false,
			holdable: 'hold',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
               	if(masterForm) {
					masterForm.setValue('ORDER_EXPECTED_FR',newValue);
               	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(masterForm) {
		    		masterForm.setValue('ORDER_EXPECTED_TO',newValue);
		    	}
		    }
		},
		Unilite.popup('CUST', {
			fieldLabel: '매입처',
			valueFieldName:'CUSTOM_CODE',
		   	textFieldName:'CUSTOM_NAME',
			extParam: {'CUSTOM_TYPE': ['1','2']},  
			listeners: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
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
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name:'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M201',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode4', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode4', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					masterForm.setValue('ORDER_PRSN', newValue);
					masterForm.setValue('ORDER_PRSN_G',newValue);
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
    });	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid= Unilite.createGrid('mpo201ukrvGrid', {
    	region: 'center' ,
        layout: 'fit',
        excelTitle: '구매오더 조정/확정',
        selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false, mode: 'single'}), 
		uniOpt: {
			allowDeselect : false,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			onLoadSelectFirst : false,
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
        	{dataIndex:'CONFIRM_YN'		, width: 88},
        	{dataIndex:'ORDER_NUM'		, width: 88 ,hidden: true},
        	{dataIndex:'CUSTOM_CODE'	, width: 88},
        	{dataIndex:'CUSTOM_NAME'	, width: 150},
        	{dataIndex:'ORDER_DATE'		, width: 138},
        	{dataIndex:'ORDER_PRSN'		, width: 88,align:'center'},
        	{dataIndex:'MONEY_UNIT'		, width: 88,align:'center',hidden:true},
        	{dataIndex:'AGREE_PRSN'		, width: 80,hidden: true}
        ],
        listeners: {
         	select: function(grid, record, index, eOpts ){	
        		UniAppManager.setToolbarButtons('save',false);
        			UniAppManager.app.grid1Select();
	        },
			deselect:  function(grid, record, index, eOpts ){
			},
			beforeedit: function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['ORDER_PRSN','REMARK'])){
					if(e.field=='ORDER_PRSN') {
						var divCode = e.grid.getSelectedRecord().get('DIV_CODE');
						var combo = e.column.field;
						combo.filterByRefCode('refCode4', divCode);
					}
					return true;
				}else{
					return false;
				}
			}
		}
    });	
    
    var masterGrid2 = Unilite.createGrid('mpo201ukrvGrid2', {
		layout: 'fit',
		region: 'south',
		excelTitle: '구매오더 조정/확정(detail)',
		selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true }), 
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			onLoadSelectFirst : false,
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
		store: directMasterStore2,
		columns: [
				{dataIndex: 'COMP_CODE'			,width:80 ,hidden:true},
				{dataIndex: 'DIV_CODE'			,width:80 ,hidden:true},
				{dataIndex: 'ITEM_CODE'			,width:100
				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
            	}},
				{dataIndex: 'ITEM_NAME'			,width:300},
				{dataIndex: 'ORDER_NUM'			,width:80 ,hidden:true},
				{dataIndex: 'AUTHOR1'			,width:80 ,align:'center',hidden:true},
				{dataIndex: 'PUBLISHER'			,width:80 ,align:'center',hidden:true},
				{dataIndex: 'ORDER_Q'			,width:80 ,summaryType: 'sum'},
				{dataIndex: 'ORDER_UNIT'		,width:80 ,align:'center'},
				{dataIndex: 'ORDER_UNIT_P'		,width:80},
				{dataIndex: 'ORDER_O'			,width:80 ,summaryType: 'sum'},
				{dataIndex: 'DVRY_DATE'			,width:80},
				{dataIndex: 'WH_CODE'			,width:120 ,align:'center'},
				{dataIndex: 'REMARK'			,width:80},
				{dataIndex: 'MONEY_UNIT'		,width:80 ,align:'center',hidden:true},
				{dataIndex: 'SAVE_T'			,width:10 ,hidden:true},
				{dataIndex: 'ORDER_SEQ'			,width:40 ,hidden:false}
		],
		listeners: {
			select: function(grid, record, index, eOpts ){					
				var records = masterGrid2.getSelectedRecords();
				if(records.length > '0'){
					record.set('SAVE_T','ON');
				}
          	},
			deselect:  function(grid, record, index, eOpts ){
				record.set('SAVE_T','');
			},
			selectionchange: function(){
				var records = masterGrid2.getSelectedRecords();
				if(records.length > '0'){
					UniAppManager.setToolbarButtons('save',true);
				}else if(records.length < '1'){
					UniAppManager.setToolbarButtons('save',false);
				}
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['ORDER_Q','ORDER_UNIT_P','ORDER_O'])){
					return true;
				}else{
					return false;
				}
			}
		}
	});

	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid,masterGrid2, panelResult
			]
		},
			masterForm  	
		],	
		id: 'mpo201ukrvApp',
		fnInitBinding: function(params) {
			masterForm.setValue('DEPT_CODE',UserInfo.deptCode);
			masterForm.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			this.setDefault(params);
		},
		onQueryButtonDown: function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore1.loadStoreRecords();
				beforeRowIndex = -1;
				masterGrid2.reset();
			}
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterGrid2.reset();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			directMasterStore1.clearData();
			directMasterStore2.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function() {
			if(masterForm.getValue('ORDER_PRSN_G')==null){
				alert('구매 담당자를 입력하세요');
			}else{
				directMasterStore2.saveStore();
			}
		},
		setDefault: function(params) {
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();				
			masterForm.setValue('ORDER_TYPE'			,'1');
			masterForm.setValue('DIV_CODE'				,UserInfo.divCode);
			panelResult.setValue('DIV_CODE'				,UserInfo.divCode);
			masterForm.setValue('ORDER_EXPECTED_FR'		,UniDate.get('startOfMonth'));
			masterForm.setValue('ORDER_EXPECTED_TO'		,UniDate.get('today'));
				
			panelResult.setValue('ORDER_EXPECTED_FR'	,UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_EXPECTED_TO'	,UniDate.get('today'));
			UniAppManager.setToolbarButtons('save', false);
			
			var field = masterForm.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('ORDER_PRSN');			
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");	
			mpo201ukrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('WH_CODE'		,provider['WH_CODE']);
					panelResult.setValue('WH_CODE'		,provider['WH_CODE']);
					UniAppManager.app.processParams(params);
					if(params && params.DIV_CODE){
						UniAppManager.app.onQueryButtonDown();
					}
				}
			})
		},
		checkForNewDetail:function() { 
			return masterForm.setAllFieldsReadOnly(true),
			 	   panelResult.setAllFieldsReadOnly(true);
        },
        grid1Select:function() {
        	var records = masterGrid.getSelectedRecords();
	        Ext.each(records,  function(record, index, records){
	        	masterForm.setValue('ORDER_REQ_DATE_G'	,record.get('ORDER_DATE'));
	        	masterForm.setValue('ORDER_NUM_G'		,record.get('ORDER_NUM'));
	        	masterForm.setValue('CUSTOM_CODE_G'		,record.get('CUSTOM_CODE'));
	        	masterForm.setValue('ORDER_PRSN_G'		,record.get('ORDER_PRSN'));
	        	masterForm.setValue('MONEY_UNIT_G'		,record.get('MONEY_UNIT'));	
	        	masterForm.setValue('AGREE_STATUS_G'	,BsaCodeInfo.gsApproveYN);
	        	masterForm.setValue('AGREE_PRSN_G'		,record.get('AGREE_PRSN'));
	        	if(BsaCodeInfo.gsApproveYN == '2'){
	        		masterForm.setValue('AGREE_DATE_G'	,UniDate.get('today'));
	        	}
	        	directMasterStore2.loadStoreRecords(record);
    		});		
        },
        processParams: function(params) {
			this.uniOpt.appParams = params;		
			if(params) {
				if(params.action == 'newMpo060') {
					masterForm.setValue('DIV_CODE'			, params.DIV_CODE);
					panelResult.setValue('DIV_CODE'			, params.DIV_CODE);
					masterForm.setValue('DEPT_CODE'			, params.DEPT_CODE);
					panelResult.setValue('DEPT_CODE'		, params.DEPT_CODE);
					masterForm.setValue('DEPT_NAME'			, params.DEPT_NAME);
					panelResult.setValue('DEPT_NAME'		, params.DEPT_NAME);
					masterForm.setValue('WH_CODE'			, params.WH_CODE);
					panelResult.setValue('WH_CODE'			, params.WH_CODE);
					masterForm.setValue('ORDER_PRSN'		, params.ORDER_PRSN);
					panelResult.setValue('ORDER_PRSN'		, params.ORDER_PRSN);
					masterForm.setValue('ORDER_EXPECTED_FR' , params.ORDER_EXPECTED_FR);
					panelResult.setValue('ORDER_EXPECTED_FR', params.ORDER_EXPECTED_FR);
					masterForm.setValue('ORDER_EXPECTED_TO' , params.ORDER_EXPECTED_TO);
					panelResult.setValue('ORDER_EXPECTED_TO', params.ORDER_EXPECTED_TO);
				}
			}
		}
	});	
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ORDER_PRSN" : //구매담당
					masterForm.setValue('ORDER_PRSN_G',newValue);
					break;	
			}
				return rv;
		}
	});
	
	Unilite.createValidator('validator02', {
		store: directMasterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ORDER_Q" :
					if(record.get('OREDER_UNIT_P') != '' ){
						record.set('ORDER_O',newValue * record.get('ORDER_UNIT_P'));
					}else if(record.get('ORDER_UNIT_P') == ''){
						record.set('ORDER_UNIT_P',record.get('ORDER_O') / newValue);
					}
					break;
				case "ORDER_UNIT_P" :
					record.set('ORDER_O',record.get('ORDER_Q') * newValue);
					break;
				case "ORDER_O" :
					record.set('ORDER_UNIT_P', newValue / record.get('ORDER_Q'));
					break;
			}
				return rv;
		}
	});
};
</script>
