<%--
'   프로그램명 : 발주승인등록 (구매)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo120ukrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="mpo120ukrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" /> <!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 출고유형 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var BsaCodeInfo = {
	gsLinkedPgmID: '${gsLinkedPgmID}'
};

/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/

var gsAgreePrsn = UserInfo.userID;
var gsAgreePrsn2 = UserInfo.userName;

function appMain() {     
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo120ukrvService.selectMasterList',
			update: 'mpo120ukrvService.AgreeUpdate',
			create: 'mpo120ukrvService.insertDetail',
			destroy: 'mpo120ukrvService.deleteDetail',
			syncAll: 'mpo120ukrvService.saveAll'
		}
	});	
	
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('Mpo120ukrvModel', {
		fields: [  	 
			{name: 'ORDER_NUM'    		,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'		,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		,type: 'string'},
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.purchase.podate" default="발주일"/>'		,type: 'uniDate'},
			{name: 'ORDER_TYPE'   		,text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'		,type: 'string',comboType:'AU',	comboCode:'M001'},
			{name: 'SUM_ORDER'    		,text: '<t:message code="system.label.purchase.potatal" default="발주총액"/>'		,type: 'uniPrice'},
			{name: 'MONEY_UNIT'   		,text: '<t:message code="system.label.purchase.currency" default="화폐"/>'			,type: 'string'},
			{name: 'AGREE_STATUS' 		,text: '승인상태'		,type: 'string',comboType:'AU', comboCode:'M007'},
			{name: 'AGREE_STATUS_HIDE' 	,text: '승인상태hide'	,type: 'string'},
			{name: 'AGREE_PRSN'			,text: '<t:message code="system.label.purchase.approvaluser" default="승인자"/>'		,type: 'string'},
			{name: 'AGREE_DATE'			,text: '승인일'		,type: 'uniDate'},
			{name: 'ORDER_PRSN'			,text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'		,type: 'string',comboType:'AU',comboCode:'M201'},
			{name: 'RECEIPT_TYPE'		,text: '지급유형'		,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			,type: 'string'},
			{name: 'COMP_CODE'    		,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		,type: 'string'},
			{name: 'DIV_CODE'     		,text: '<t:message code="system.label.purchase.division" default="사업장"/>'		,type: 'string',comboType:'BOR120'}
		]  
	});			
	Unilite.defineModel('Mpo120ukrvModel2', {
	    fields: [ 			
			{name: 'ITEM_CODE'	    ,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		,type: 'string'},
			{name: 'ITEM_NAME'	    ,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'SPEC'		    ,text: '<t:message code="system.label.purchase.spec" default="규격"/>'			,type: 'string'},
			{name: 'ORDER_UNIT_Q'   ,text: '<t:message code="system.label.purchase.qty" default="수량"/>'			,type: 'uniQty'},
			{name: 'ORDER_UNIT_P'   ,text: '<t:message code="system.label.purchase.price" default="단가"/>'			,type: 'uniUnitPrice'},
			{name: 'ORDER_O'		,text: '<t:message code="system.label.purchase.amount" default="금액"/>'			,type: 'uniPrice'},
			{name: 'DVRY_DATE'	    ,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'		,type: 'uniDate'},
			{name: 'REMARK'			,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			,type: 'string'},
			{name: 'PROJECT_NO'		,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		,type: 'string'}	
		]  
	});		
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	
	var directMasterStore1 = Unilite.createStore('mpo120ukrvMasterStore1',{
		model: 'Mpo120ukrvModel',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(records[0] != null){
           			masterForm.setValue('ORDER_NUM',records[0].get('ORDER_NUM'));
	           		if(masterForm.getValue('ORDER_NUM') != ''){
	           				directMasterStore2.loadStoreRecords(records);
	           		}
           		}else{
           			masterForm.setValue('ORDER_NUM',''); 
           			masterGrid2.getStore().removeAll();
           		}
				if(masterForm.getValue('AGREE_STATUS') == '2'){
					Ext.getCmp('frToDate').setReadOnly(true);
				}else{
					Ext.getCmp('frToDate').setReadOnly(false);
				}
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {	
           	}
		},
        loadStoreRecords: function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});			
		},
		saveStore : function()	{	
			var paramMaster= masterForm.getValues();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						directMasterStore1.loadStoreRecords();
				 	} 
				};
				this.syncAllDirect(config);
			}else {
				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});		
	
	var directMasterStore2 = Unilite.createStore('mpo120ukrvMasterStore2',{
		model: 'Mpo120ukrvModel2',
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
            	   read: 'mpo120ukrvService.selectDetailList'                	
            }
        },
        loadStoreRecords: function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
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
		    items : [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value:UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('ORDER_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('CUST', { 
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
				valueFieldName: 'CUSTOM_CODE',
		   	 	textFieldName: 'CUSTOM_NAME',
				extParam: {'CUSTOM_TYPE': ['1','2']},
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								masterForm.setValue('CUSTOM_CODE', newValue);
								panelResult.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									masterForm.setValue('CUSTOM_NAME', '');
									panelResult.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								masterForm.setValue('CUSTOM_NAME', newValue);
								panelResult.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									masterForm.setValue('CUSTOM_CODE', '');
									panelResult.setValue('CUSTOM_CODE', '');
								}
							},
				            applyextparam: function(popup){
				                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
		                	}
					}
			}),{
	        	fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'ORDER_DATE_FR',
	        	endFieldName:'ORDER_DATE_TO',
	        	width: 315,
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.poclass" default="발주유형"/>',
				name:'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M001',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>',
				id:'AGREE_STATUS',
				name:'AGREE_STATUS',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M007',
				allowBlank:false,
				value : '1',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AGREE_STATUS2', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M201',
				//20170517 - 주석처리(연세대에서 사용한 로직)
//				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
//					if(eOpts){
//						combo.filterByRefCode('refCode4', newValue, eOpts.parent);
//					}else{
//						combo.divFilterByRefCode('refCode4', newValue, divCode);
//					}
//				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '승인자코드',
				name:'AGREE_PRSN1',
				xtype: 'uniTextfield',
				value: gsAgreePrsn,
				hidden:true
			},{
				fieldLabel: '<t:message code="system.label.purchase.approvaluser" default="승인자"/>',
				name:'AGREE_PRSN',
				xtype: 'uniTextfield',
				value: gsAgreePrsn2,
				readOnly: true
			},{
		 		fieldLabel: '승인일',
		 		id:'frToDate',
		 		xtype: 'uniDatefield',
		 		name: 'FR_DATE',
		 		value: UniDate.get('today'),
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('FR_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.pono" default="발주번호"/>',
				xtype:'uniTextfield',
				name:'ORDER_NUM',
				hidden:true
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
			value:UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					combo.changeDivCode(combo, newValue, oldValue, eOpts);						
					var field = masterForm.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					masterForm.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('CUST', { 
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
			valueFieldName: 'CUSTOM_CODE',
	   	 	textFieldName: 'CUSTOM_NAME',
			extParam: {'CUSTOM_TYPE': ['1','2']},
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							masterForm.setValue('CUSTOM_CODE', newValue);
							panelResult.setValue('CUSTOM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								masterForm.setValue('CUSTOM_NAME', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							masterForm.setValue('CUSTOM_NAME', newValue);
							panelResult.setValue('CUSTOM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								masterForm.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_CODE', '');
							}
						},
			            applyextparam: function(popup){
			                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
			                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
			            	}
				}
		}),{
        	fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
        	xtype: 'uniDateRangefield',
        	startFieldName: 'ORDER_DATE_FR',
        	endFieldName:'ORDER_DATE_TO',
        	width: 315,
        	startDate: UniDate.get('startOfMonth'),
        	endDate: UniDate.get('today'),
        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(masterForm) {
					masterForm.setValue('ORDER_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(masterForm) {
		    		masterForm.setValue('ORDER_DATE_TO',newValue);
		    	}
		    }
		},{
			fieldLabel: '<t:message code="system.label.purchase.poclass" default="발주유형"/>',
			name:'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M001',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					masterForm.setValue('ORDER_TYPE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>',
			id:'AGREE_STATUS2',
			name:'AGREE_STATUS',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M007',
			allowBlank:false,
			value : '1',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					masterForm.setValue('AGREE_STATUS', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name:'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M201',
			//20170517 - 주석처리(연세대에서 사용한 로직)
//			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
//				if(eOpts){
//					combo.filterByRefCode('refCode4', newValue, eOpts.parent);
//				}else{
//					combo.divFilterByRefCode('refCode4', newValue, divCode);
//				}
//			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					masterForm.setValue('ORDER_PRSN', newValue);
				}
			}
		},{
			fieldLabel: '승인자코드',
			name:'AGREE_PRSN1',
			xtype: 'uniTextfield',
			value: gsAgreePrsn,
			hidden:true
		},{
			fieldLabel: '<t:message code="system.label.purchase.approvaluser" default="승인자"/>',
			name:'AGREE_PRSN',
			xtype: 'uniTextfield',
			value: gsAgreePrsn2,
			readOnly: true
		},{
	 		fieldLabel: '승인일',
	 		id:'frToDate2',
	 		xtype: 'uniDatefield',
	 		name: 'FR_DATE',
	 		value: UniDate.get('today'),
	 		allowBlank:false,
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					masterForm.setValue('FR_DATE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.pono" default="발주번호"/>',
			xtype:'uniTextfield',
			name:'ORDER_NUM',
			hidden:true
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
    
    var masterGrid1= Unilite.createGrid('mpo120ukrvGrid1', {
        layout:'fit',
        region:'center',
        flex	: 2,
        excelTitle: '발주승인등록',
        selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: false,
        	listeners: {        		
        		beforeselect: function(rowSelection, record, index, eOpts) {
        		},
				select: function(grid, record, index, eOpts ){					
					var records = masterGrid1.getSelectedRecords();
					if(records.length > '0'){
						UniAppManager.setToolbarButtons('save',true);
					}
					if(record.get('AGREE_STATUS')=='1'){
						record.set('AGREE_STATUS_HIDE','2');	//신규라고 알려주기 위해 임의로 컬럼 생성
					}else{
						record.set('AGREE_STATUS_HIDE','1');
					}
	          	},
				deselect:  function(grid, record, index, eOpts ){
					record.set('AGREE_STATUS_HIDE','');
					var records = masterGrid1.getSelectedRecords();
					if(records.length < '1'){
						UniAppManager.setToolbarButtons('save',false);
					}
        		}
        	}
        }),
		uniOpt: {
			onLoadSelectFirst: false,  
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
        columns:  [
        	{dataIndex:'ORDER_NUM'  		, width: 120},
        	{dataIndex:'CUSTOM_CODE'		, width: 100},
        	{dataIndex:'CUSTOM_NAME'		, width: 166},
        	{dataIndex:'ORDER_DATE'			, width: 100},
        	{dataIndex:'ORDER_TYPE'  		, width: 80 ,align:'center'},
        	{dataIndex:'SUM_ORDER'   		, width: 100},
        	{dataIndex:'MONEY_UNIT'  		, width: 80 ,align:'center'},
        	{dataIndex:'AGREE_STATUS'		, width: 76 ,hidden:false ,align:'center'},
        	{dataIndex:'AGREE_STATUS_HIDE'	, width: 76 ,hidden:true},
        	{dataIndex:'AGREE_PRSN'			, width: 76 ,hidden:true},
        	{dataIndex:'AGREE_DATE'			, width: 76 ,hidden:true},
        	{dataIndex:'ORDER_PRSN'			, width: 80},
        	{dataIndex:'RECEIPT_TYPE'		, width: 80 ,hidden:true},
        	{dataIndex:'REMARK'				, width: 147},
        	{dataIndex:'COMP_CODE'   		, width: 80 ,hidden:true},
        	{dataIndex:'DIV_CODE'    		, width: 80 ,hidden:true}	
        ] ,
        listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				var params = {
					'ORDER_NUM' : masterForm.getValue('ORDER_NUM')
				}
				var rec = {data : {prgID : BsaCodeInfo.gsLinkedPgmID}};							
					parent.openTab(rec, '/matrl/'+BsaCodeInfo.gsLinkedPgmID+'.do', params);	
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					masterForm.setValue('ORDER_NUM',record.get('ORDER_NUM'));
					directMasterStore2.loadStoreRecords(record);
				}
				beforeRowIndex = rowIndex;
			}
        }
    });		
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
	var masterGrid2= Unilite.createGrid('mpo120ukrvGrid2', {
		split: true,
		layout:'fit',
        region:'south',
        flex	: 1,
        excelTitle: '발주승인등록(detail)',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
    	store: directMasterStore2,
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns:  [
        	{dataIndex:'ITEM_CODE'	    , width:100},
        	{dataIndex:'ITEM_NAME'	    , width:250},
        	{dataIndex:'SPEC'		    , width:95},
        	{dataIndex:'ORDER_UNIT_Q'   , width:75},
        	{dataIndex:'ORDER_UNIT_P'   , width:75},
        	{dataIndex:'ORDER_O'		, width:110},
        	{dataIndex:'DVRY_DATE'	    , width:70},
        	{dataIndex:'REMARK'			, width:100},
        	{dataIndex:'PROJECT_NO'		, width:353}
    	] 
	});		
    
    Unilite.Main({ 
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid1,masterGrid2, panelResult
			]
		},
			masterForm  	
		],
		id: 'mpo120ukrvApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			var field = masterForm.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('ORDER_PRSN');			
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");	
			masterForm.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			masterForm.setValue('ORDER_DATE_TO',UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO',UniDate.get('today'));
			masterForm.setValue('FR_DATE',UniDate.get('today'));
			panelResult.setValue('FR_DATE',UniDate.get('today'));
			masterForm.setValue('AGREE_STATUS','1');
			panelResult.setValue('AGREE_STATUS','1');
			masterForm.setValue('AGREE_PRSN',gsAgreePrsn2);
			panelResult.setValue('AGREE_PRSN',gsAgreePrsn2);
			masterForm.setValue('AGREE_PRSN1',gsAgreePrsn);
			panelResult.setValue('AGREE_PRSN1',gsAgreePrsn);
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown: function()	{
			if(masterForm.setAllFieldsReadOnly(true) == false) {
        		return false;
			}else{
			directMasterStore1.loadStoreRecords();
			beforeRowIndex = -1;
			}	
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid1.reset();
			masterGrid2.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		}
	});	
};
</script>