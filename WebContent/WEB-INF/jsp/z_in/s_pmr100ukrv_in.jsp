<%--
'   프로그램명 : 생산실적등록 (생산)
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'   최종수정자 :
'   최종수정일 :
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr100ukrv_in"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"/>				<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>				<!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="P003"/>				<!-- 불량유형 -->
	<t:ExtComboStore comboType="AU" comboCode="P002"/>				<!-- 특기사항 분류 -->
	<t:ExtComboStore comboType="AU" comboCode="P507"/>				<!-- 작업조 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />	<!--창고-->
	<t:ExtComboStore comboType="OU" />								<!-- 창고-->
	<t:ExtComboStore comboType="WU" />								<!-- 작업장-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고Cell-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList2" />	<!--창고Cell-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsManageLotNoYN: '${gsManageLotNoYN}',	 // 작업지시와 생산실적 LOT 연계여부 설정 값
	gsChkProdtDateYN: '${gsChkProdtDateYN}',// 착수예정일 체크여부
	glEndRate: '${glEndRate}',
	gsSumTypeCell: '${gsSumTypeCell}'		  // 재고합산유형 : 창고 Cell 합산

};
/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/



var outDivCode = UserInfo.divCode;
var checkDraftStatus = false;
var outouProdtSave; // 생산실적 자동입고
var needSave = false;
var checkNewData = false;

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 작업실적 등록
		api: {
			read: 's_pmr100ukrv_inService.selectDetailList'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 작업지시별 등록
		api: {
			read: 's_pmr100ukrv_inService.selectDetailList2',
			update: 's_pmr100ukrv_inService.updateDetail2',
			create: 's_pmr100ukrv_inService.insertDetail2',
			destroy: 's_pmr100ukrv_inService.deleteDetail2',
			syncAll: 's_pmr100ukrv_inService.saveAll2'
		}
	});

	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 공정별 등록1
		api: {
			read: 's_pmr100ukrv_inService.selectDetailList3',
			update: 's_pmr100ukrv_inService.updateDetail3',
			create: 's_pmr100ukrv_inService.insertDetail3',
			destroy: 's_pmr100ukrv_inService.deleteDetail3',
			syncAll: 's_pmr100ukrv_inService.saveAll3'
		}
	});

	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 공정별 등록2
		api: {
			read: 's_pmr100ukrv_inService.selectDetailList4',
			update: 's_pmr100ukrv_inService.updateDetail4',
			create: 's_pmr100ukrv_inService.insertDetail4',
			destroy: 's_pmr100ukrv_inService.deleteDetail4',
			syncAll: 's_pmr100ukrv_inService.saveAll4'
		}
	});

	var directProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 불량내역 등록
		api: {
			read: 's_pmr100ukrv_inService.selectDetailList5',
			update: 's_pmr100ukrv_inService.updateDetail5',
			create: 's_pmr100ukrv_inService.insertDetail5',
			destroy: 's_pmr100ukrv_inService.deleteDetail5',
			syncAll: 's_pmr100ukrv_inService.saveAll5'
		}
	});

	var directProxy6 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 특기사항 등록
		api: {
			read: 's_pmr100ukrv_inService.selectDetailList6',
			update: 's_pmr100ukrv_inService.updateDetail6',
			create: 's_pmr100ukrv_inService.insertDetail6',
			destroy: 's_pmr100ukrv_inService.deleteDetail6',
			syncAll: 's_pmr100ukrv_inService.saveAll6'
		}
	});

	var masterForm = Unilite.createSearchPanel('s_pmr100ukrv_inMasterForm', {
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120' ,
				allowBlank:false,
				holdable: 'hold',
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
				  		panelResult.setValue('DIV_CODE', newValue);
						masterForm.setValue('WORK_SHOP_CODE','');
				 	}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
				endFieldName:'PRODT_START_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				holdable: 'hold',
				width: 315,
				textFieldWidth:170,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_START_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_START_DATE_TO',newValue);
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: ' ',
				id: 'rdoSelect',
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '',
				 	holdable: 'hold'
				},{
					boxLabel : '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'CONTROL_STATUS',
					holdable: 'hold',
					inputValue: '2',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.product.closing" default="마감"/>',
					width: 60,
					name: 'CONTROL_STATUS',
					holdable: 'hold',
					inputValue: '8'
				},{
					boxLabel : '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'CONTROL_STATUS',
					holdable: 'hold',
					inputValue: '9'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('CONTROL_STATUS').setValue(newValue.CONTROL_STATUS);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
				  		panelResult.setValue('WORK_SHOP_CODE', newValue);
				 	},
					beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var prStore = panelResult.getField('WORK_SHOP_CODE').store;
						store.clearFilter();
						prStore.clearFilter();
						if(!Ext.isEmpty(masterForm.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == masterForm.getValue('DIV_CODE');
							});
							prStore.filterBy(function(record){
								return record.get('option') == masterForm.getValue('DIV_CODE');
							});
						}else{
							store.filterBy(function(record){
								return false;
							});
							prStore.filterBy(function(record){
								return false;
							});
						}
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					holdable: 'hold',
					validateBlank:false,
					textFieldName: 'ITEM_NAME',
					valueFieldName: 'ITEM_CODE',
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ITEM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ITEM_NAME', newValue);
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						}
					}
			}),{
		 		fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
		 		xtype: 'uniTextfield',
		 		name: 'WKORD_NUM',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WKORD_NUM', newValue);
					}
				}
			},{
		 		fieldLabel: '<t:message code="system.label.product.lotno" default="LOT번호"/>',
		 		xtype: 'uniTextfield',
		 		name: 'LOT_NO',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('LOT_NO', newValue);
					}
				}
			},{
				xtype: 'uniCheckboxgroup',
				fieldLabel: ' ',
				items: [{
					boxLabel: '2, 3중 포장',
					//width: 100,
					name: 'PACK_TYPE',
					inputValue: '1',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('PACK_TYPE', newValue);
						}
					}
				}]
			},{
		 		fieldLabel: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
		 		xtype: 'uniTextfield',
		 		name: 'WKORD_Q',
				holdable: 'hold',
		 		hidden: true
			},{
		 		fieldLabel: '<t:message code="system.label.product.routingcode" default="공정코드"/>',
		 		xtype: 'uniTextfield',
		 		name: 'PROG_WORK_CODE',
				holdable: 'hold',
		 		hidden: true
			},{
		 		fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
		 		xtype: 'uniTextfield',
		 		name: 'ITEM_CODE1',
				holdable: 'hold',
		 		hidden: true
			},{
		 		fieldLabel: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>',
		 		xtype: 'uniTextfield',
		 		name: 'PRODT_NUM',
				holdable: 'hold',
		 		hidden: true
			},{
		 		fieldLabel: 'RESULT_TYPE',
		 		xtype: 'uniTextfield',
		 		name: 'RESULT_TYPE',
		 		hidden: true
			}]
		}],
		/*api: {
			load: 's_pmr100ukrv_inService.selectDetailList',
			submit: 's_pmr100ukrv_inService.syncMaster'
		},
		listeners: {
			dirtychange: function(basicForm, dirty, eOpts) {
				console.log("onDirtyChange");
				UniAppManager.setToolbarButtons('save', true);
			}
		},*/
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
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120' ,
				allowBlank:false,
				holdable: 'hold',
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
				  		masterForm.setValue('DIV_CODE', newValue);
						panelResult.setValue('WORK_SHOP_CODE','');
				 	}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
				endFieldName:'PRODT_START_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				holdable: 'hold',
				textFieldWidth:170,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(masterForm) {
						masterForm.setValue('PRODT_START_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(masterForm) {
						masterForm.setValue('PRODT_START_DATE_TO',newValue);
					}
				}
			},{
		 		fieldLabel: '<t:message code="system.label.product.lotno" default="LOT번호"/>',
		 		xtype: 'uniTextfield',
		 		name: 'LOT_NO',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('LOT_NO', newValue);
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: ' ',
				id: 'rdoSelect2',
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'CONTROL_STATUS',
					holdable: 'hold',
					inputValue: ''
				},{
					boxLabel : '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'CONTROL_STATUS',
					holdable: 'hold',
					inputValue: '2',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.product.closing" default="마감"/>',
					width: 60,
					name: 'CONTROL_STATUS',
					holdable: 'hold',
					inputValue: '8'
				},{
					boxLabel : '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'CONTROL_STATUS',
					holdable: 'hold',
					inputValue: '9'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.getField('CONTROL_STATUS').setValue(newValue.CONTROL_STATUS);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
				  		masterForm.setValue('WORK_SHOP_CODE', newValue);
				 	},
					beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var prStore = masterForm.getField('WORK_SHOP_CODE').store;
						store.clearFilter();
						prStore.clearFilter();
						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == panelResult.getValue('DIV_CODE');
							});
							prStore.filterBy(function(record){
								return record.get('option') == panelResult.getValue('DIV_CODE');
							});
						}else{
							store.filterBy(function(record){
								return false;
							});
							prStore.filterBy(function(record){
								return false;
							});
						}
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					validateBlank:false,
					textFieldName: 'ITEM_NAME',
					valueFieldName: 'ITEM_CODE',
					holdable: 'hold',
					listeners: {
						onValueFieldChange: function(field, newValue){
							masterForm.setValue('ITEM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							masterForm.setValue('ITEM_NAME', newValue);
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						}
					}
			}),{
		 		fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
		 		xtype: 'uniTextfield',
		 		name: 'WKORD_NUM',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('WKORD_NUM', newValue);
					}
				}
			},{
				xtype: 'uniCheckboxgroup',
				fieldLabel: ' ',
				items: [{
					boxLabel: '2, 3중 포장',
					//width: 100,
					name: 'PACK_TYPE',
					inputValue: '1',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							masterForm.setValue('PACK_TYPE', newValue);
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

	Unilite.defineModel('s_pmr100ukrv_inDetailModel', {
		fields: [
			{name: 'CONTROL_STATUS'		,text: '<t:message code="system.label.product.status" default="상태"/>'			,type:'string' , comboType:"AU", comboCode:"P001"},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'		,type:'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'		,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'			,type:'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>'			,type:'string'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		,type:'uniQty'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'		,type:'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.workenddate" default="작업완료일"/>'		,type:'uniDate'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'	,type:'string'},
			{name: 'PJT_CODE'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type:'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.product.remarks" default="비고"/>'			,type:'string'},
			//Hidden: true
			{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'		,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'		,type:'string' ,comboType: 'WU'},
			{name: 'WORK_Q'				,text: '<t:message code="system.label.product.workqty" default="작업량"/>'		,type:'uniQty'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		,type:'uniQty'},
			{name: 'WK_PLAN_NUM'		,text: '<t:message code="system.label.product.workplanno" default="작업계획번호"/>'		,type:'string'},
			{name: 'LINE_END_YN'		,text: '<t:message code="system.label.product.lastroutingexistyn" default="최종공정유무"/>'		,type:'string'},
			{name: 'WORK_END_YN'		,text: '<t:message code="system.label.product.closingyn" default="마감여부"/>'		,type:'string'},
			{name: 'LINE_SEQ'			,text: '<t:message code="system.label.product.routingorder" default="공정순서"/>'		,type:'string'},
			{name: 'PROG_UNIT'			,text: '<t:message code="system.label.product.routingresultunit" default="공정실적단위"/>'		,type:'string'},
			{name: 'PROG_UNIT_Q'		,text: '<t:message code="system.label.product.routingunitqty" default="공정원단위량"/>'		,type:'uniQty'},
			{name: 'OUT_METH'			,text: '<t:message code="system.label.product.issuemethod" default="출고방법"/>'		,type:'string'},
			{name: 'AB'					,text: ' '			,type:'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'		,type:'string'},
			{name: 'RESULT_YN'			,text: '<t:message code="system.label.product.receiptmethod" default="입고방법"/>'		,type:'string'},
			{name: 'INSPEC_YN'			,text: '<t:message code="system.label.product.receiptmethod" default="입고방법"/>'		,type:'string'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.product.basiswarehouse" default="기준창고"/>'		,type:'string'},
			{name: 'BASIS_P'			,text: '<t:message code="system.label.product.inventoryamount" default="재고금액"/>'		,type:'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'		,type:'string'}
		]
	});

	var detailStore = Unilite.createStore('s_pmr100ukrv_inDetailStore', {
		model: 's_pmr100ukrv_inDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= masterForm.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)) {
					//masterForm.setAllFieldsReadOnly(true);
					//panelResult.setAllFieldsReadOnly(true);
					masterForm.getField('DIV_CODE').setReadOnly(true);
				   // masterForm.getField('WORK_SHOP_CODE').setReadOnly(true);
					panelResult.getField('DIV_CODE').setReadOnly(true);
					//panelResult.getField('WORK_SHOP_CODE').setReadOnly(true);

//					UniAppManager.setToolbarButtons(['newData', 'delete'], false);
				} else {
//					UniAppManager.app.onResetButtonDown();
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var detailGrid = Unilite.createGrid('s_pmr100ukrv_inGrid', {
		store: detailStore,
		layout: 'fit',
		region:'center',
		uniOpt: {
			expandLastColumn: false,
			onLoadSelectFirst: false,
			useRowNumberer: false
		},
		tbar: [{
			xtype	: 'splitbutton',
			itemId	: 'refTool',
			text	: '<t:message code="system.label.product.processbutton" default="프로세스..."/>',
			iconCls	: 'icon-referance',
			menu	: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId	: 'requestBtn',
					text	: '<t:message code="system.label.product.employeestatusentry" default="인원현황등록"/>',
					handler	: function() {
						if(masterForm.setAllFieldsReadOnly(true) == false){
							return false;
						} else{
							var params = {
								'DIV_CODE'				: masterForm.getValue('DIV_CODE'),
								'PRODT_START_DATE_FR'	: masterForm.getValue('PRODT_START_DATE_FR'),
								'PRODT_START_DATE_TO'	: masterForm.getValue('PRODT_START_DATE_TO'),
								'WORK_SHOP_CODE'		: masterForm.getValue('WORK_SHOP_CODE')
							}
							var rec = {data : {prgID : 'pmr800ukrv', 'text':'<t:message code="system.label.product.employeestatusentry" default="인원현황등록"/>'}};
							parent.openTab(rec, '/prodt/pmr800ukrv.do', params);
						}
					}
				}]
			})
		}],
		columns: [
			{dataIndex: 'CONTROL_STATUS'  	, width: 53  ,locked:false},
			{dataIndex: 'WORK_SHOP_CODE' 	, width: 120},
			{dataIndex: 'WKORD_NUM'			, width: 120  ,locked:false},
			{dataIndex: 'ITEM_CODE'			, width: 100 ,locked:false},
			{dataIndex: 'ITEM_NAME'			, width: 170 ,locked:false},
			{dataIndex: 'SPEC'				, width: 150 ,locked:false},
			{dataIndex: 'STOCK_UNIT'		, width: 53  , align:'center' ,locked:false},
			{dataIndex: 'WKORD_Q'		 	, width: 100  ,locked:false},
			{dataIndex: 'PRODT_START_DATE'	, width: 86},
			{dataIndex: 'PRODT_END_DATE'  	, width: 86},
			{dataIndex: 'LOT_NO'  			, width: 120},
			{dataIndex: 'PROJECT_NO'	  	, width: 120},
			{dataIndex: 'REMARK'		  	, width: 180},
//			{dataIndex: 'PJT_CODE'			, width: 133},
			{dataIndex: 'PROG_WORK_CODE' 	, width: 80 ,hidden:true},

			{dataIndex: 'WORK_Q'	  		, width: 80 ,hidden:true},
			{dataIndex: 'PRODT_Q'			, width: 80 ,hidden:true},
			{dataIndex: 'WK_PLAN_NUM'		, width:80 ,hidden:true},
			{dataIndex: 'LINE_END_YN'  		, width: 80 ,hidden:true},
			{dataIndex: 'WORK_END_YN'		, width: 80 ,hidden:true},
			{dataIndex: 'LINE_SEQ'	  		, width: 80 ,hidden:true},
			{dataIndex: 'PROG_UNIT'	  		, width: 80 ,hidden:true},
			{dataIndex: 'PROG_UNIT_Q'		, width: 80 ,hidden:true},
			{dataIndex: 'OUT_METH'			, width: 80 ,hidden:true},
			{dataIndex: 'AB'				, width: 80 ,hidden:true},

			{dataIndex: 'RESULT_YN'	  		, width: 10 ,hidden:true},
			{dataIndex: 'INSPEC_YN'  		, width: 80 ,hidden:true},
			{dataIndex: 'WH_CODE'			, width: 80 ,hidden:true},
			{dataIndex: 'BASIS_P'	  		, width: 80 ,hidden:true},
			{dataIndex: 'DIV_CODE'	 		, width: 10 ,hidden:true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
				 	return false;
				} else {
					return false;
				}
			},
			deselect:	function(grid, record, index, eOpts ){
				var a = 0;
			},
			beforeselect: function(grid, record, index, eOpts){
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 's_pmr100ukrv_inGrid2'){
					if(directMasterStore2.isDirty()){
						if(confirm('내용이 변경되었습니다. 변경된 내용을 저장하시곘습니까?')){
							UniAppManager.app.onSaveDataButtonDown();
							return false;
						}

					}
				} else if(activeTabId == 's_pmr100ukrv_inGrid3_1'){
					if(directMasterStore3.isDirty()){
						if(confirm('내용이 변경되었습니다. 변경된 내용을 저장하시곘습니까?')){
							UniAppManager.app.onSaveDataButtonDown();
							return false;
						}

					}
				} else if(activeTabId == 's_pmr100ukrv_inGrid5'){
					if(directMasterStore5.isDirty()&&needSave == true && !checkNewData){
						if(confirm('내용이 변경되었습니다. 변경된 내용을 저장하시곘습니까?')){
							UniAppManager.app.onSaveDataButtonDown();
							return false;
						}

					}
				} else {
					if(directMasterStore6.isDirty()){
						if(confirm('내용이 변경되었습니다. 변경된 내용을 저장하시곘습니까?')){
							UniAppManager.app.onSaveDataButtonDown();
							return false;
						}

					}
				}
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ) {
				var a = 0;
			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
					var activeTabId = tab.getActiveTab().getId();

					this.returnCell(record);
					if(activeTabId == 's_pmr100ukrv_inGrid2'){
						directMasterStore2.loadStoreRecords();
					} else if(activeTabId == 's_pmr100ukrv_inGrid3_1'){
						directMasterStore3.loadStoreRecords();
					} else if(activeTabId == 's_pmr100ukrv_inGrid5'){
						directMasterStore3.loadStoreRecords();		//20200423 추가: 불량내역등록탭의 불량수량 표시하기 위해 추가
						directMasterStore5.loadStoreRecords();
					} else {
						directMasterStore6.loadStoreRecords();
					}
				}
			}
		},
		returnCell: function(record){
			var itemCode	= record.get("ITEM_CODE");
			var prodtNum	= record.get("PRODT_NUM");
			masterForm.setValues({'ITEM_CODE1':itemCode});
			masterForm.setValues({'PRODT_NUM':prodtNum});
		},
		disabledLinkButtons: function(b) {
			this.down('#refTool').menu.down('#requestBtn').setDisabled(b);
		}
	});



	/** 작업지시별등록 정의
	 * @type
	 */
	Unilite.defineModel('s_pmr100ukrv_inModel2', {  //Pmr100ns3v.htm
		fields: [
			{name: 'PRODT_DATE'		,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'			,type:'uniDate'},
			{name: 'PRODT_Q'		,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'			,type:'uniQty', allowBlank:false},
			{name: 'GOOD_PRODT_Q'	,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'			,type:'uniQty', allowBlank:true},
			{name: 'BAD_PRODT_Q'	,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'			,type:'uniQty'},
			{name: 'DAY_NIGHT'	  ,text: '<t:message code="system.label.product.workteam" default="작업조"/>'		  ,type:'string', comboType: 'AU', comboCode: 'P507', defaultValue: '1' },
			{name: 'MAN_HOUR'		,text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'			,type:'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'WKORD_Q'		,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'			,type:'uniQty'},
			{name: 'PRODT_SUM'		,text: '<t:message code="system.label.product.productiontotal" default="생산누계"/>'			,type:'uniQty'},
			{name: 'JAN_Q'			,text: '<t:message code="system.label.product.productionleftqty" default="생산잔량"/>'			,type:'uniQty'},
			{name: 'IN_STOCK_Q'		,text: '<t:message code="system.label.product.receiptqty" default="입고량"/>'			,type:'uniQty'},
			{name: 'LOT_NO'			,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			,type:'string',maxLength: 6},
			{name: 'REMARK'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'				,type:'string'},
			{name: 'PROJECT_NO'		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type:'string'},
			{name: 'PJT_CODE'		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
			{name: 'FR_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(<t:message code="system.label.product.start" default="시작"/>)'		,type:'string'},
			{name: 'TO_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(<t:message code="system.label.product.end" default="종료"/>)'		,type:'string'},
			//Hidden:true
			{name: 'NEW_DATA'		,text: 'NEW_DATA'			,type:'string'},
			{name: 'PRODT_NUM'		,text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'			,type:'string'},
			{name: 'PROG_WORK_CODE'	,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'},
			{name: 'UPDATE_DB_USER'	,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'			,type:'string'},
			{name: 'UPDATE_DB_TIME'	,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'			,type:'uniDate'},
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'			,type:'string'},
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'			,type:'string'},
			{name: 'WORK_SHOP_CODE'	,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			,type:'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.product.item" default="품목"/>'			,type:'string'},
			{name: 'CONTROL_STATUS'	,text: 'CONTROL_STATUS'	,type:'string'},
			{name: 'GOOD_WH_CODE'	,text: '<t:message code="system.label.product.goodreceiptwarehouse" default="양품입고창고"/>'			,type:'string'},
			{name: 'GOOD_PRSN'		,text: '<t:message code="system.label.product.goodreceiptincharge" default="양품입고담당"/>'			,type:'string'},
			{name: 'BAD_WH_CODE'	,text: '<t:message code="system.label.product.defectreceiptwarehouse" default="불량입고창고"/>'			,type:'string'},
			{name: 'BAD_PRSN'		,text: '<t:message code="system.label.product.defectreceiptincharge" default="불량입고담당"/>'			,type:'string'},
			//20180605 추가
			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.defectreceiptincharge" default="불량입고담당"/>'			,type:'string'}
		]
	});

	/** 공정별등록 정의 center
	 * @type
	 */
	Unilite.defineModel('s_pmr100ukrv_inModel3', {  //Pmr100ns1v.htm
		fields: [
			{name: 'SEQ'			,text: '<t:message code="system.label.product.seq" default="순번"/>'				,type:'string'},
			{name: 'PROG_WORK_NAME'	,text: '<t:message code="system.label.product.routingname" default="공정명"/>'			,type:'string'},
			{name: 'PROG_UNIT'		,text: '<t:message code="system.label.product.unit" default="단위"/>'				,type:'string'},
			{name: 'PROG_WKORD_Q'	,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'			,type:'uniQty'},
			{name: 'SUM_Q'			,text: '<t:message code="system.label.product.productiontotal2" default="생산계"/>'			,type:'uniQty'},
			{name: 'PRODT_DATE'		,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'			,type:'uniDate'	, allowBlank:false},
			{name: 'PASS_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'			,type:'uniQty'	, allowBlank:false},
			{name: 'GOOD_WORK_Q'	,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'			,type:'uniQty'	},
			{name: 'BAD_QC_Q'	,text: '<t:message code="" default="QC불량"/>'			,type:'uniQty'	, editable: false},										//20200424 수정: 	, editable: false
			{name: 'BAD_PROG_Q'	,text: '<t:message code="" default="분주불량"/>'			,type:'uniQty'	, editable: false},										//20200424 수정: 	, editable: false
			{name: 'BAD_WORK_Q'		,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'			,type:'uniQty'	, editable: false},		//20200424 수정: 	, editable: false
			{name: 'DAY_NIGHT'	  ,text: '<t:message code="system.label.product.workteam" default="작업조"/>'		  ,type:'string', comboType: 'AU', comboCode: 'B080', defaultValue:'1' },
			{name: 'MAN_HOUR'		,text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'			,type:'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'JAN_Q'			,text: '<t:message code="system.label.product.productionleftqty" default="생산잔량"/>'			,type:'uniQty'},
			{name: 'LOT_NO'			,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			,type:'string',maxLength: 6},
			{name: 'FR_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(시작)'		,type:'string'},
			{name: 'TO_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(종료)'		,type:'string'},
			{name: 'REMARK'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'				,type:'string'},
			//Hidden: true
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'			,type:'string'},
			{name: 'PROG_WORK_CODE'	,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'},
			{name: 'WORK_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'			,type:'string'},
			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			,type:'string'},
			{name: 'LINE_END_YN'	,text: '<t:message code="system.label.product.lastyn" default="최종여부"/>'			,type:'string'},
			{name: 'WK_PLAN_NUM'	,text: '<t:message code="system.label.product.planno" default="계획번호"/>'			,type:'string'},
			{name: 'PRODT_NUM'		,text: ''				,type:'string'},
			{name: 'CONTROL_STATUS'	,text: ''				,type:'string'},
			{name: 'UPDATE_DB_USER'	,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'			,type:'string'},
			{name: 'UPDATE_DB_TIME'	,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'			,type:'uniDate'},
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'			,type:'string'},
			{name: 'GOOD_WH_CODE'	,text: '<t:message code="system.label.product.goodreceiptwarehouse" default="양품입고창고"/>'			,type:'string'},
			{name: 'GOOD_PRSN'		,text: '<t:message code="system.label.product.goodreceiptincharge" default="양품입고담당"/>'			,type:'string'},
			{name: 'BAD_WH_CODE'	,text: '<t:message code="system.label.product.defectreceiptwarehouse" default="불량입고창고"/>'			,type:'string'},
			{name: 'BAD_PRSN'		,text: '<t:message code="system.label.product.defectreceiptincharge" default="불량입고담당"/>'			,type:'string'},
			{name: 'MOLD_CODE'		,text: 'MOLD_CODE'			,type:'string'},
			{name: 'CAVIT_BASE_Q'	,text: 'CAVIT_BASE_Q'		,type:'uniQty'},
			{name: 'PRODT_START_TIME'			,text: '시작시간'			,type:'string' 	, maxLength: 4},
			{name: 'PRODT_END_TIME'				,text: '종료시간'			,type:'string' 	, maxLength: 4},

			{name: 'WORK_SHOP_CODE'		,text: 'WORK_SHOP_CODE'			,type:'string'},
			{name: 'ITEM_CODE'		,text: 'ITEM_CODE'			,type:'string'}

		]
	});

	/** 공정별등록 정의 east
	 * @type
	 */
	Unilite.defineModel('s_pmr100ukrv_inModel4', {  //Pmr100ns1v.htm
		fields: [
			{name: 'PRODT_NUM'		,text: '<t:message code="system.label.product.productionno" default="생산번호"/>'			,type:'string'},
			{name: 'PRODT_DATE'		,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'			,type:'uniDate'},
			{name: 'PASS_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'			,type:'uniQty'},
			{name: 'GOOD_WORK_Q'	,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'			,type:'uniQty'},

			{name: 'BAD_QC_Q'	,text: '<t:message code="" default="QC불량"/>'			,type:'uniQty'	},
			{name: 'BAD_PROG_Q'	,text: '<t:message code="" default="분주불량"/>'			,type:'uniQty'	},

			{name: 'BAD_WORK_Q'		,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'			,type:'uniQty'},
			{name: 'DAY_NIGHT'	  ,text: '<t:message code="system.label.product.workteam" default="작업조"/>'		  ,type:'string', comboType: 'AU', comboCode: 'P507', defaultValue:'1' },
			{name: 'MAN_HOUR'		,text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'			,type:'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'IN_STOCK_Q'		,text: '<t:message code="system.label.product.receiptqty" default="입고량"/>'			,type:'uniQty'},
			{name: 'LOT_NO'			,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			,type:'string'},
			{name: 'FR_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(시작)'		,type:'string'},
			{name: 'TO_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(종료)'		,type:'string'},
			{name: 'REMARK'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'				,type:'string'},
			//Hidden: true
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'			,type:'string'},
			{name: 'PROG_WKORD_Q'	,text: ''				,type:'uniQty'},
			{name: 'CAL_PASS_Q'		,text: ''				,type:'uniQty'},
			{name: 'PROG_WORK_CODE'	,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'},
			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			,type:'string'},
			{name: 'WK_PLAN_NUM'	,text: '<t:message code="system.label.product.planno" default="계획번호"/>'			,type:'string'},
			{name: 'LINE_END_YN'	,text: '<t:message code="system.label.product.lastyn" default="최종여부"/>'			,type:'string'},
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'			,type:'string'},
			{name: 'CONTROL_STATUS'	,text: ''				,type:'string'},
			{name: 'GOOD_WH_CODE'	,text: '<t:message code="system.label.product.goodreceiptwarehouse" default="양품입고창고"/>'			,type:'string'},
			{name: 'GOOD_PRSN'		,text: '<t:message code="system.label.product.goodreceiptincharge" default="양품입고담당"/>'			,type:'string'},
			{name: 'BAD_WH_CODE'	,text: '<t:message code="system.label.product.defectreceiptwarehouse" default="불량입고창고"/>'			,type:'string'},
			{name: 'BAD_PRSN'		,text: '<t:message code="system.label.product.defectreceiptincharge" default="불량입고담당"/>'			,type:'string'},
			{name: 'PRODT_START_TIME'			,text: '시작시간'			,type:'string' 	, maxLength: 4},
			{name: 'PRODT_END_TIME'				,text: '종료시간'			,type:'string' 	, maxLength: 4},
			{name: 'WORK_SHOP_CODE'		,text: 'WORK_SHOP_CODE'			,type:'string'},
			{name: 'ITEM_CODE'		,text: 'ITEM_CODE'			,type:'string'}

		]
	});

	/** 불량내역등록
	 * @type
	 */
	Unilite.defineModel('s_pmr100ukrv_inModel5', {
		fields: [
			{name: 'CHECK_VALUE'				,text: 'CHECK_VALUE'		,type:'string'},
			{name: 'WKORD_NUM'	 		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string', allowBlank:false},
			{name: 'PROG_WORK_NAME'		,text: '<t:message code="system.label.product.routingname" default="공정명"/>'			,type:'string', allowBlank:false},
			{name: 'PRODT_DATE'			,text: '<t:message code="system.label.product.occurreddate" default="발생일"/>'			,type:'uniDate', allowBlank:false},
			{name: 'BAD_CODE'			,text: '<t:message code="system.label.product.defecttype" default="불량유형"/>'			,type:'string', allowBlank:false, comboType: 'AU', comboCode: 'P003'},
			{name: 'BAD_Q'		 		,text: '<t:message code="system.label.product.qty" default="수량"/>'				,type:'uniQty'},
			{name: 'REMARK'				,text: '<t:message code="system.label.product.issueandmeasures" default="문제점 및 대책"/>'		,type:'string'},
			//Hidden : true
			{name: 'DIV_CODE'	 		,text: '<t:message code="system.label.product.division" default="사업장"/>'			,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'			,type:'string'},
			{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type:'string'},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'			,type:'string'},
			{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'			,type:'uniDate'},
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'			,type:'string'}
		]
	});

	/** 특기사항등록
	 * @type
	 */
	Unilite.defineModel('s_pmr100ukrv_inModel6', {
		fields: [
			{name: 'WKORD_NUM'	 	,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string'},
			{name: 'PROG_WORK_NAME'	,text: '<t:message code="system.label.product.routingname" default="공정명"/>'			,type:'string', allowBlank:false},
			{name: 'PRODT_DATE'		,text: '<t:message code="system.label.product.occurreddate" default="발생일"/>'			,type:'uniDate', allowBlank:false},
			{name: 'CTL_CD1'		,text: '<t:message code="system.label.product.specialremarkclass" default="특기사항 분류"/>'	,type:'string', allowBlank:false, comboType: 'AU', comboCode: 'P002'},
			{name: 'TROUBLE_TIME'  	,text: '<t:message code="system.label.product.occurredtime" default="발생시간"/>'			,type:'int'},
			{name: 'TROUBLE'		,text: '<t:message code="system.label.product.summary" default="요약"/>'				,type:'string'},
			{name: 'TROUBLE_CS'		,text: '<t:message code="system.label.product.reason" default="원인"/>'				,type:'string'},
			{name: 'ANSWER'			,text: '<t:message code="system.label.product.action" default="조치"/>'				,type:'string'},
			{name: 'SEQ'			,text: ''				,type:'string'},
			//Hidden : true
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'		,type:'string'},
			{name: 'WORK_SHOP_CODE' ,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'		,type:'string'},
			{name: 'PROG_WORK_CODE' ,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'},
			{name: 'UPDATE_DB_USER' ,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'			,type:'string'},
			{name: 'UPDATE_DB_TIME'	,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'			,type:'uniDate'},
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'			,type:'string'}
		]
	});




	var directMasterStore2 = Unilite.createStore('s_pmr100ukrv_inMasterStore2',{
		model: 's_pmr100ukrv_inModel2',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy2,
		loadStoreRecords : function()	{
			var param	= masterForm.getValues();
			var record	= detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.WKORD_Q			= record.get('WKORD_Q');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
			}
			console.log(param);
			this.load({
				params		: param,
				callback	: function(records, operation, success) {
					if(success)	{
						directMasterStore2.commitChanges();
					}
				}
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate, toDelete);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));


			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				var detailRecord = detailGrid.getSelectedRecord();
//				var saveFlag	= true;

				var fnCal = 0;
				var prodtSum	= this.sumBy(function(record, id){
									return true
								  }, ['PRODT_Q']);
				var A = detailRecord.get('WKORD_Q');			//작업지시량
				var D = detailRecord.get('LINE_END_YN');

				if(D == 'Y') {
					fnCal = ( prodtSum.PRODT_Q / A ) * 100
				} else {
					fnCal = 0;
				}
				if(fnCal > (100 * (BsaCodeInfo.glEndRate / 100))) {
//					saveFlag	= false;
					alert('<t:message code="system.message.product.message009" default="초과 생산 실적 범위를 벗어났습니다."/>');
					return false;
				}

//				if (saveFlag) {

//					if(fnCal >= '10' /*|| ((fnCal < '95') && detailRecord.get('CONTROL_STATUS') == '9')*/) {
//						if(confirm('<t:message code="system.message.product.confirm004" default="완료하시겠습니까?"/>')) {
							Ext.each(list, function(record2,i) {
								record2.set('CONTROL_STATUS', '9');
							});
//
//						} else {
//							Ext.each(list, function(record2,i) {
//								if(detailRecord.get('CONTROL_STATUS') == '9') {
//									record2.set('CONTROL_STATUS', '3');
//								}
//							});
//						}
//					}else{
//						Ext.each(list, function(record2,i) {
//							if(detailRecord.get('CONTROL_STATUS') == '9') {
//								record2.set('CONTROL_STATUS', '3');
//							}
//						});
//					}
//				}
//				if (!saveFlag) {
//					saveFlag = true;
//					return false;
//				}

				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						var record = detailGrid.getSelectedRecord();
						if(!Ext.isEmpty(master.CONTROL_STATUS)) {
							record.set("CONTROL_STATUS", master.CONTROL_STATUS);
							detailGrid.getStore().commitChanges();
						}
						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						directMasterStore2.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr100ukrv_inGrid2');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				var wkordQ = detailGrid.getSelectedRecord().get('WKORD_Q');
				if(!Ext.isEmpty(records)) {
					var prodtSum = 0;
					var janQ	 = wkordQ;
					Ext.each(records, function(record,i) {
						prodtSum = prodtSum + record.get('PRODT_SUM');
						janQ	 = janQ - record.get('PRODT_Q');
						record.set('PRODT_SUM'	, prodtSum);
						record.set('JAN_Q'		, janQ);
					});
				}
			}
		}
	});

	var directMasterStore3 = Unilite.createStore('s_pmr100ukrv_inMasterStore3',{
		model: 's_pmr100ukrv_inModel3',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy3,
		loadStoreRecords : function()	{
			var param	= masterForm.getValues();
			var record	= detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.WKORD_Q			= record.get('WKORD_Q');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
				param.USER_ID	= UserInfo.userID;
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정

			//2. 초과실적 체크로직
			if(inValidRecs.length == 0) {
				var detailRecord = detailGrid.getSelectedRecord();
				var saveFlag= true;
				var fnCal	= 0;
				Ext.each(list, function(record,i) {
					var prodtSum	= record.get('SUM_Q') + record.get('PASS_Q');
					var A = record.get('PROG_WKORD_Q');			//작업지시량
					var D = record.get('LINE_END_YN');

					if(D == 'Y') {
						fnCal = ( prodtSum / A ) * 100
					} else {
						fnCal = 0;
					}
					if(fnCal > (100 * (BsaCodeInfo.glEndRate / 100))) {
						saveFlag	= false;
						alert('<t:message code="system.message.product.message009" default="초과 생산 실적 범위를 벗어났습니다."/>');
						return false;
					}
					if (D == 'Y') {
//						if(fnCal >= '10'/* || ((fnCal < '95') && detailRecord.get('CONTROL_STATUS') == '9')*/) {
//							if(confirm('<t:message code="system.message.product.confirm004" default="완료하시겠습니까?"/>')) {
								record.set('CONTROL_STATUS', '9');
//
//							} else {
//								if(detailRecord.get('CONTROL_STATUS') == '9') {
//									record.set('CONTROL_STATUS', '3');
//								}
//							}
//						}else{
//							if(detailRecord.get('CONTROL_STATUS') == '9') {
//								record.set('CONTROL_STATUS', '3');
//							}
//						}
					}
				});

				if (!saveFlag) {
					return false;
				}

				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						var record = detailGrid.getSelectedRecord();
						if(!Ext.isEmpty(master.CONTROL_STATUS)) {
							record.set("CONTROL_STATUS", master.CONTROL_STATUS);
							detailGrid.getStore().commitChanges();
						}

						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						directMasterStore3.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr100ukrv_inGrid3');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				var totBadQ = 0;
				Ext.each(records, function(record,i) {
					totBadQ = totBadQ + record.get('BAD_WORK_Q');
				});
				panelResult.setValue('TOT_BAD_Q',totBadQ);
				Ext.getCmp('TOT_BAD_PROG').setValue(totBadQ);
			},
			add: function(store, records, index, eOpts) {
				console.log(store);
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				console.log(store);
			},
			remove: function(store, record, index, isMove, eOpts) {
				console.log(store);
			}
		}
	});

	var directMasterStore4 = Unilite.createStore('s_pmr100ukrv_inMasterStore4',{
		model: 's_pmr100ukrv_inModel4',
		uniOpt: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy4,
		loadStoreRecords : function(record)	{
			var param= masterForm.getValues();
			if(!Ext.isEmpty(record)) {
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.WKORD_Q			= record.get('WKORD_Q');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate, toDelete);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			var masterGrid3Record = masterGrid3.getSelectedRecord();
			paramMaster.MOLD_CODE = masterGrid3Record.get('MOLD_CODE');
			paramMaster.CAVIT_BASE_Q = masterGrid3Record.get('CAVIT_BASE_Q');
			if(inValidRecs.length == 0) {
				var saveFlag	= true;
				var fnCal		= 0;
				var prodtSum	= this.sumBy(function(record, id){
					return true
				  }, ['PASS_Q']);

				Ext.each(list, function(record,i) {
					var detailRecord = detailGrid.getSelectedRecord();
					var A = detailRecord.get('WKORD_Q');			//작업지시량
					var D = record.get('LINE_END_YN');

					if(D == 'Y') {
						fnCal = ( prodtSum.PASS_Q / A ) * 100
					} else {
						fnCal = 0;
					}
					if(fnCal > (100 * (BsaCodeInfo.glEndRate / 100))) {
						saveFlag	= false;
						alert('<t:message code="system.message.product.message009" default="초과 생산 실적 범위를 벗어났습니다."/>');
						return false;
					}
					if (D == 'Y') {
//						if(fnCal >= '10'/* || ((fnCal < '95') && detailRecord.get('CONTROL_STATUS') == '9')*/) {
//							if(confirm('<t:message code="system.message.product.confirm004" default="완료하시겠습니까?"/>')) {
								record.set('CONTROL_STATUS', '9');
//
//							} else {
//								if(detailRecord.get('CONTROL_STATUS') == '9') {
//									record.set('CONTROL_STATUS', '3');
//								}
//							}
//						}else{
//							if(detailRecord.get('CONTROL_STATUS') == '9') {
//								record.set('CONTROL_STATUS', '3');
//							}
//						}
					}
				});

				if (!saveFlag) {
					return false;
				}


				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						var record = detailGrid.getSelectedRecord();
						if(!Ext.isEmpty(master.CONTROL_STATUS)) {
							record.set("CONTROL_STATUS", master.CONTROL_STATUS);
							detailGrid.getStore().commitChanges();
						}
						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						directMasterStore3.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr100ukrv_inGrid4');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				console.log(store);
			},
			add: function(store, records, index, eOpts) {
				console.log(store);
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				console.log(store);
			},
			remove: function(store, record, index, isMove, eOpts) {
			if(store.isDirty()){
				UniAppManager.setToolbarButtons('save', true);
			}
			}
		}
	});

	var directMasterStore5 = Unilite.createStore('s_pmr100ukrv_inMasterStore5',{
		model: 's_pmr100ukrv_inModel5',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy5,
		loadStoreRecords : function()	{
			var param	= masterForm.getValues();
			var record	= detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.WKORD_Q			= record.get('WKORD_Q');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			var record	= detailGrid.getSelectedRecord();
			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(!Ext.isEmpty(record)) {
				paramMaster.WKORD_NUM			= record.get('WKORD_NUM');
			}
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						/* var master = batch.operations[0].getResultSet();
						masterForm.setValue("INOUT_NUM", master.T0T_BAD);
						Ext.getCmp('TOT_BAD').setValue(master.T0T_BAD);  */

						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr100ukrv_inGrid5');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				var tot = 0;
				Ext.each(records, function(record,i) {
						if(Ext.isEmpty(record.data.CHECK_VALUE))
							{
								record.set('CHECK_VALUE', 'N');
								checkNewData = true;
							}
						tot = tot + record.data.BAD_Q;
					});
				 UniAppManager.setToolbarButtons(['save'], false);
				 Ext.getCmp('TOT_BAD').setValue(tot);
			  },
			update:function( store, records, operation, modifiedFieldNames, eOpts )	{
				checkNewData = false;
			},
			add: function(store, records, index, eOpts) {
			},
		   remove: function(store, record, index, isMove, eOpts) {
		   }
		}
	});

	var directMasterStore6 = Unilite.createStore('s_pmr100ukrv_inMasterStore6',{
		model: 's_pmr100ukrv_inModel6',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy6,
		loadStoreRecords : function()	{
			var param	= masterForm.getValues();
			var record	= detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.WKORD_Q			= record.get('WKORD_Q');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
					/*	var master = batch.operations[0].getResultSet();
						masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
						*/
						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr100ukrv_inGrid6');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{

			}
		}
	});



	var masterGrid2 = Unilite.createGrid('s_pmr100ukrv_inGrid2', {
		layout : 'fit',
		region:'center',
		title : '<t:message code="system.label.product.workorderperentry" default="작업지시별등록"/>',
		store : directMasterStore2,
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: true,
			useMultipleSorting: false
		},
		sortableColumns: false,
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary', 		showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'PRODT_DATE'		, width: 80},
			{dataIndex: 'PRODT_Q'			, width: 93},
			{dataIndex: 'GOOD_PRODT_Q'		, width: 93},
			{dataIndex: 'BAD_PRODT_Q'		, width: 93},
			//{dataIndex: 'DAY_NIGHT'		 , width: 93},
			{dataIndex: 'MAN_HOUR'			, width: 93},
			{dataIndex: 'WKORD_Q'			, width: 100 , hidden: true},
			{dataIndex: 'PRODT_SUM'			, width: 93},
			{dataIndex: 'JAN_Q'				, width: 93},
			{dataIndex: 'IN_STOCK_Q'		, width: 93},
			{dataIndex: 'LOT_NO'			, width: 93},

//			{dataIndex: 'PJT_CODE'	 		, width: 93},
			{dataIndex: 'FR_SERIAL_NO'		, width: 120},
			{dataIndex: 'TO_SERIAL_NO'		, width: 120},
			{dataIndex: 'REMARK'			, width: 200},
			{dataIndex: 'PROJECT_NO'		, width: 93},
			{dataIndex: 'NEW_DATA'			, width: 90 , hidden: true},
			{dataIndex: 'PRODT_NUM'			, width: 90 , hidden: true},
			{dataIndex: 'PROG_WORK_CODE'	, width: 80 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width: 80 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 80 , hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 80 , hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 80, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 80, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 80, hidden: true},
			{dataIndex: 'CONTROL_STATUS'	, width: 80, hidden: true},
			{dataIndex: 'GOOD_WH_CODE'		, width: 80, hidden: true},
			{dataIndex: 'GOOD_PRSN'			, width: 80, hidden: true},
			{dataIndex: 'BAD_WH_CODE'		, width: 80, hidden: true},
			{dataIndex: 'BAD_PRSN'			, width: 80, hidden: true},
			//20180605 추가
			{dataIndex: 'WKORD_NUM'			, width: 80, hidden: true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
				 	if(UniUtils.indexOf(e.field)) {
						return false;
	  				} else {
	  					return false;
	  				}
				} else {
					if(UniUtils.indexOf(e.field, ['PRODT_DATE', 'PRODT_Q','DAY_NIGHT','GOOD_PRODT_Q', 'BAD_PRODT_Q', 'MAN_HOUR', 'LOT_NO', 'REMARK', 'FR_SERIAL_NO', 'TO_SERIAL_NO','PROJECT_NO']))
					{
						return true;
					} else {
						return false;
					}
				}
			},
			render: function(grid, eOpts) {
				grid.getEl().on('click', function(e, t, eOpt) {
					var detailRecord = detailGrid.getSelectedRecord();
					if(!Ext.isEmpty(detailRecord)) {
						if(detailRecord.get('CONTROL_STATUS') == '9') {
							UniAppManager.setToolbarButtons(['newData'], false);
						} else {
							UniAppManager.setToolbarButtons(['newData'], true);
						}
					}
				});
			},
			cellclick	: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ){
				if(grid.getStore().count() > 0) {
					UniAppManager.setToolbarButtons(['delete'], true);
				}
			}
		},
		setOutouProdtSave: function(grdRecord) {
			grdRecord.set('GOOD_WH_CODE'		, outouProdtSaveSearch.getValue('GOOD_WH_CODE'));
			grdRecord.set('GOOD_WH_CELL_CODE'	, outouProdtSaveSearch.getValue('GOOD_WH_CELL_CODE'));
			grdRecord.set('GOOD_PRSN' 			, outouProdtSaveSearch.getValue('GOOD_PRSN'));
			grdRecord.set('BAD_WH_CODE' 		, outouProdtSaveSearch.getValue('BAD_WH_CODE'));
			grdRecord.set('BAD_WH_CELL_CODE'	, outouProdtSaveSearch.getValue('BAD_WH_CELL_CODE'));
			grdRecord.set('BAD_PRSN'			, outouProdtSaveSearch.getValue('BAD_PRSN'));
		}
	});

	var masterGrid3 = Unilite.createGrid('s_pmr100ukrv_inGrid3', {
//		split: true,
		layout	: 'fit',
		region	: 'center',
		flex	: 7,
		title	: '<t:message code="system.label.product.routingperentry" default="공정별등록"/>',
		store	: directMasterStore3,
		sortableColumns: false,

		uniOpt	:{
			userToolbar		: false,
			expandLastColumn: false,
			useRowNumberer	: true,
			useMultipleSorting: true,
			onLoadSelectFirst : true
		},
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary', showSummaryRow: false}
		],
		columns: [
			//{dataIndex: 'SEQ'				, width: 35},

			{dataIndex: 'PROG_WORK_NAME'	, width: 120},
			{dataIndex: 'PROG_UNIT'			, width: 50 , align:'center' },
			{dataIndex: 'PROG_WKORD_Q'		, width: 100},
			{dataIndex: 'SUM_Q'				, width: 66},
			{dataIndex: 'PRODT_DATE'		, width: 86 , align:'center' },
			{dataIndex: 'PASS_Q'			, width: 90},
			{dataIndex: 'GOOD_WORK_Q'		, width: 90},

			{dataIndex: 'BAD_QC_Q'		, width: 90},
			{dataIndex: 'BAD_PROG_Q'		, width: 90},

			{dataIndex: 'BAD_WORK_Q'		, width: 90},
			//{dataIndex: 'DAY_NIGHT'		 , width: 66},
			{dataIndex: 'PRODT_START_TIME'		 , width: 80,  align: 'center',
				renderer:function(value){
					var timeFormat = '00:00';
					if(value != 0){
						   if(value.substring(0,2)<=24&&value.substring(2,4)<=60){
							   timeFormat = value.substring(0,2) +":"+ value.substring(2,4)
						   }else{
							   timeFormat = '00:00';
						   }
					   }
					   return timeFormat;
				}
			},
			{dataIndex: 'PRODT_END_TIME'		 , width: 80,  align: 'center',
				renderer:function(value){
					var timeFormat = '00:00';
					if(value != 0){
						   if(value.substring(0,2)<=24&&value.substring(2,4)<=60){
							   timeFormat = value.substring(0,2) +":"+ value.substring(2,4)
						   }else{
							   timeFormat = '00:00';
						   }
					   }
					   return timeFormat;
				}
			},
			{dataIndex: 'MAN_HOUR'			, width: 90},
			{dataIndex: 'JAN_Q'				, width: 76},
			{dataIndex: 'LOT_NO'			, width: 93},
			{dataIndex: 'FR_SERIAL_NO'		, width: 120},
			{dataIndex: 'TO_SERIAL_NO'		, width: 120},
			{dataIndex: 'REMARK'			, flex: 1	,minWidth: 100},

			{dataIndex: 'DIV_CODE'			, width: 10	, hidden: true},
			{dataIndex: 'PROG_WORK_CODE'	, width: 10	, hidden: true},
			{dataIndex: 'WORK_Q'			, width: 10	, hidden: true},
			{dataIndex: 'WKORD_NUM'			, width: 10	, hidden: true},
			{dataIndex: 'LINE_END_YN'		, width: 10	, hidden: true},
			{dataIndex: 'WK_PLAN_NUM'		, width: 10	, hidden: true},
			{dataIndex: 'PRODT_NUM'			, width: 10	, hidden: true},
			{dataIndex: 'CONTROL_STATUS'	, width: 10	, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width: 10	, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 10	, hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 10	, hidden: true},
			{dataIndex: 'GOOD_WH_CODE'		, width: 80	, hidden: true},
			{dataIndex: 'GOOD_PRSN'			, width: 80	, hidden: true},
			{dataIndex: 'BAD_WH_CODE'		, width: 80	, hidden: true},
			{dataIndex: 'BAD_PRSN'			, width: 80	, hidden: true},
	  	{dataIndex: 'WORK_SHOP_CODE', width: 80	, hidden: true},
  		{dataIndex: 'ITEM_CODE'			, width: 80	, hidden: true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
				var detailRecord = detailGrid.getSelectedRecord();
				if(detailRecord.get('CONTROL_STATUS') == '9') {
					//unilite상에서 두 컬럼이 수정이 되나 저장은 안됨 (투입공수나 생산량 둘 중에 하나는 0이 아니어야 하는데 둘다 수정 불가능) - 그냥 return false 처리
//					if(UniUtils.indexOf(e.field, ['FR_SERIAL_NO', 'TO_SERIAL_NO'])) {
//						return true;
//	  				} else {
	  					return false;
//	  				}

				} else {
					if(UniUtils.indexOf(e.field, ['PRODT_DATE', 'PASS_Q','DAY_NIGHT','GOOD_WORK_Q', 'BAD_QC_Q','BAD_PROG_Q', 'BAD_WORK_Q', 'MAN_HOUR', 'FR_SERIAL_NO', 'TO_SERIAL_NO', 'LOT_NO', 'LOT_NO','PRODT_START_TIME','PRODT_END_TIME'])) {
						return true;
	  				} else {
	  					return false;
	  				}
				}
			},
			render: function(grid, eOpts) {
//				var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
//					activeGridId = girdNm;
					//UniAppManager.setToolbarButtons(['newData', 'delete'], false);
				});
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ) {
			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
					directMasterStore4.loadData({})
					directMasterStore4.loadStoreRecords(record);
				}
		  	}
		},
		setOutouProdtSave: function(grdRecord) {
			grdRecord.set('GOOD_WH_CODE'		, outouProdtSaveSearch.getValue('GOOD_WH_CODE'));
			grdRecord.set('GOOD_WH_CELL_CODE'	, outouProdtSaveSearch.getValue('GOOD_WH_CELL_CODE'));
			grdRecord.set('GOOD_PRSN' 			, outouProdtSaveSearch.getValue('GOOD_PRSN'));
			grdRecord.set('BAD_WH_CODE' 		, outouProdtSaveSearch.getValue('BAD_WH_CODE'));
			grdRecord.set('BAD_WH_CELL_CODE'	, outouProdtSaveSearch.getValue('BAD_WH_CELL_CODE'));
			grdRecord.set('BAD_PRSN'			, outouProdtSaveSearch.getValue('BAD_PRSN'));
		}
	});

	var masterGrid4 = Unilite.createGrid('s_pmr100ukrv_inGrid4', {
		split: true,
		layout : 'fit',
		selModel: 'rowmodel',
		region:'center',
		flex: 3,
		title : '<t:message code="system.label.product.resultsstatus" default="실적현황"/>',
		store : directMasterStore4,
		uniOpt:{
			userToolbar:false,
			expandLastColumn: false,
			useRowNumberer: true,
			useMultipleSorting: true
		},
		sortableColumns: false,
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary', 		showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'PRODT_NUM'			, width: 100, hidden: true},
			{dataIndex: 'PRODT_DATE'		, width: 80, summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.total" default="총계"/>');
					}},
			{dataIndex: 'PASS_Q'			, width: 66		, summaryType: 'sum'},
			{dataIndex: 'GOOD_WORK_Q'		, width: 66		, summaryType: 'sum'},
			{dataIndex: 'BAD_QC_Q'		, width: 76		, summaryType: 'sum'},
			{dataIndex: 'BAD_PROG_Q'		, width: 76		, summaryType: 'sum'},
			{dataIndex: 'BAD_WORK_Q'		, width: 76		, summaryType: 'sum'},
			{dataIndex: 'PRODT_START_TIME'		 , width: 76,  align: 'center',
				renderer:function(value){
					var timeFormat = '00:00';
					if(value != 0){
						   if(value.substring(0,2)<=24&&value.substring(2,4)<=60){
							   timeFormat = value.substring(0,2) +":"+ value.substring(2,4)
						   }else{
							   timeFormat = '00:00';
						   }
					   }
					   return timeFormat;
				}
			},
			{dataIndex: 'PRODT_END_TIME'		 , width: 76,  align: 'center',
				renderer:function(value){
					var timeFormat = '00:00';
					if(value != 0){
						   if(value.substring(0,2)<=24&&value.substring(2,4)<=60){
							   timeFormat = value.substring(0,2) +":"+ value.substring(2,4)
						   }else{
							   timeFormat = '00:00';
						   }
					   }
					   return timeFormat;
				}
			},
			//{dataIndex: 'DAY_NIGHT'		 , width: 66	 },
			{dataIndex: 'MAN_HOUR'			, width: 76		, summaryType: 'sum'},
			{dataIndex: 'IN_STOCK_Q'		, width: 76		, summaryType: 'sum'},
			{dataIndex: 'LOT_NO'			, width: 80		, hidden: true},
			{dataIndex: 'FR_SERIAL_NO'		, width: 120	, hidden: true},
			{dataIndex: 'TO_SERIAL_NO'		, width: 120	, hidden: true},
			{dataIndex: 'REMARK'			, width: 80		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'PROG_WKORD_Q'		, width: 66		, hidden: true},
			{dataIndex: 'CAL_PASS_Q'		, width: 66		, hidden: true},
			{dataIndex: 'PROG_WORK_CODE'	, width: 66		, hidden: true},
			{dataIndex: 'WKORD_NUM'			, width: 66		, hidden: true},
			{dataIndex: 'WK_PLAN_NUM'		, width: 80		, hidden: true},
			{dataIndex: 'LINE_END_YN'		, width: 106	, hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 106	, hidden: true},
			{dataIndex: 'GOOD_WH_CODE'		, width: 80		, hidden: true},
			{dataIndex: 'GOOD_PRSN'			, width: 80		, hidden: true},
			{dataIndex: 'BAD_WH_CODE'		, width: 80		, hidden: true},
			{dataIndex: 'BAD_PRSN'			, width: 80		, hidden: true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {},
			render: function(grid, eOpts) {
//				var girdNm = grid.getItemId();
					grid.getEl().on('click', function(e, t, eOpt) {
	//					activeGridId = girdNm;
						UniAppManager.setToolbarButtons(['newData'], false);
						if(grid.getStore().count() > 0) {
								UniAppManager.setToolbarButtons(['delete'], true);
						}
					});
			}
		},
		setOutouProdtSave: function(grdRecord) {
			grdRecord.set('GOOD_WH_CODE'		, outouProdtSaveSearch.getValue('GOOD_WH_CODE'));
			grdRecord.set('GOOD_WH_CELL_CODE'	, outouProdtSaveSearch.getValue('GOOD_WH_CELL_CODE'));
			grdRecord.set('GOOD_PRSN' 			, outouProdtSaveSearch.getValue('GOOD_PRSN'));
			grdRecord.set('BAD_WH_CODE' 		, outouProdtSaveSearch.getValue('BAD_WH_CODE'));
			grdRecord.set('BAD_WH_CELL_CODE'	, outouProdtSaveSearch.getValue('BAD_WH_CELL_CODE'));
			grdRecord.set('BAD_PRSN'			, outouProdtSaveSearch.getValue('BAD_PRSN'));
		}
	});

	var masterGrid5 = Unilite.createGrid('s_pmr100ukrv_inGrid5', {
		layout : 'fit',
		region:'center',
		title : '<t:message code="system.label.product.defectdetailsentry" default="불량내역등록"/>',
		store : directMasterStore5,
		tbar: [{
				xtype	: 'uniTextfield',
				itemId	: 'TOT_BAD_PROG',
				id		: 'TOT_BAD_PROG',
				fieldLabel:'불량수량',
				readOnly: true,
				margin: '0 30 0 0'
			},{
				xtype	: 'uniTextfield',
				itemId	: 'TOT_BAD',
				id		: 'TOT_BAD',
				fieldLabel:'불량수량합계',
				readOnly: true
			}],
		uniOpt:{	expandLastColumn: true,
					useRowNumberer: true,
					useMultipleSorting: true
		},
		sortableColumns: false,
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary', 		showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'CHECK_VALUE'		, width: 60, hidden: true},
			{dataIndex: 'WKORD_NUM'			, width: 120},
			{dataIndex: 'PROG_WORK_NAME'	, width: 166,
				'editor': Unilite.popup('PROG_WORK_CODE_G',{
					textFieldName : 'PROG_WORK_NAME',
					DBtextFieldName : 'PROG_WORK_NAME',
					autoPopup: true,
					listeners: { 'onSelected': {
						fn: function(records, type  ){
							var grdRecord = masterGrid5.uniOpt.currentRecord;
							grdRecord.set('PROG_WORK_CODE',records[0]['PROG_WORK_CODE']);
							grdRecord.set('PROG_WORK_NAME',records[0]['PROG_WORK_NAME']);
						},
						scope: this
					},
					'onClear' : function(type)	{
						var grdRecord = masterGrid5.uniOpt.currentRecord;
						grdRecord.set('PROG_WORK_CODE','');
						grdRecord.set('PROG_WORK_NAME','');
					},
					applyextparam: function(popup){
						var param =  panelResult.getValues();
						record = detailGrid.getSelectedRecord();
						popup.setExtParam({'DIV_CODE': param.DIV_CODE});
						popup.setExtParam({'ITEM_CODE': record.get('ITEM_CODE')});
						popup.setExtParam({'WORK_SHOP_CODE': record.get('WORK_SHOP_CODE')});
					}
				}
			})},
			{dataIndex: 'PRODT_DATE'		, width: 100},
			{dataIndex: 'BAD_CODE'			, width: 150},			//20200428 수정: 사이즈 변경 )106 -> 150
			{dataIndex: 'BAD_Q'				, width: 100},
			{dataIndex: 'REMARK'			, width: 600},
			{dataIndex: 'DIV_CODE'			, width: 80 , hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 80 , hidden: true},
			{dataIndex: 'PROG_WORK_CODE'	, width: 80 , hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 80 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width: 80 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 80 , hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 80 , hidden: true}
		]
		,
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if (UniUtils.indexOf(e.field,
											['PROG_WORK_CODE','PROG_WORK_NAME','PRODT_DATE','BAD_CODE']))
						return false
				}if(!e.record.phantom||e.record.phantom){
					if (UniUtils.indexOf(e.field,
											['WKORD_NUM']))
						return false
				}
			},
			render: function(grid, eOpts) {
				grid.getEl().on('click', function(e, t, eOpt) {
					UniAppManager.setToolbarButtons(['newData'], true);
					if(grid.getStore().count() > 0) {
						UniAppManager.setToolbarButtons(['delete'], true);
					} else {
						UniAppManager.setToolbarButtons(['delete'], false);
					}
				});
			}
		}
	});

	var masterGrid6 = Unilite.createGrid('s_pmr100ukrv_inGrid6', {
		layout : 'fit',
		region:'center',
		title : '<t:message code="system.label.product.specialremarkentry" default="특기사항등록"/>',
		store : directMasterStore6,
		uniOpt:{	expandLastColumn: false,
					useRowNumberer: true,
					useMultipleSorting: true
		},
		sortableColumns: false,
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary', 		showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'WKORD_NUM'	 		, width: 120 , hidden: true},
			{dataIndex: 'PROG_WORK_NAME'		, width: 166 ,
					'editor': Unilite.popup('PROG_WORK_CODE_G',{
					textFieldName : 'PROG_WORK_NAME',
					DBtextFieldName : 'PROG_WORK_NAME',
					autoPopup: true,
					listeners: { 'onSelected': {
						fn: function(records, type  ){
							var grdRecord = masterGrid6.uniOpt.currentRecord;
							grdRecord.set('PROG_WORK_CODE',records[0]['PROG_WORK_CODE']);
							grdRecord.set('PROG_WORK_NAME',records[0]['PROG_WORK_NAME']);
						},
						scope: this
					  },
					  'onClear' : function(type)	{
							var grdRecord = masterGrid6.uniOpt.currentRecord;
							grdRecord.set('PROG_WORK_CODE','');
							grdRecord.set('PROG_WORK_NAME','');
					  },
					  applyextparam: function(popup){
							var param =  panelResult.getValues();
							record = detailGrid.getSelectedRecord();
							popup.setExtParam({'DIV_CODE': param.DIV_CODE});
							popup.setExtParam({'ITEM_CODE': record.get('ITEM_CODE')});
							popup.setExtParam({'WORK_SHOP_CODE': record.get('WORK_SHOP_CODE')});
					  }
					}
				})},
			{dataIndex: 'PRODT_DATE'	 		, width: 100},
			{dataIndex: 'CTL_CD1'			, width: 106},
			{dataIndex: 'TROUBLE_TIME'  		, width: 100},
			{dataIndex: 'TROUBLE'			, width: 166},
			{dataIndex: 'TROUBLE_CS'			, width: 166},
			{dataIndex: 'ANSWER'				, width: 800},
			{dataIndex: 'SEQ'				, width: 0},
			//Hidden : true
			{dataIndex: 'DIV_CODE'  			, width: 0 , hidden:true},
			{dataIndex: 'WORK_SHOP_CODE'		, width: 0 , hidden:true},
			{dataIndex: 'PROG_WORK_CODE'		, width: 0 , hidden:true},
			{dataIndex: 'UPDATE_DB_USER'		, width: 0 , hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'  		, width: 0 , hidden:true},
			{dataIndex: 'COMP_CODE'			, width: 0 , hidden:true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if (UniUtils.indexOf(e.field,
											['PROG_WORK_CODE','PROG_WORK_NAME','PRODT_DATE','CTL_CD1']))
						return false
				}if(!e.record.phantom||e.record.phantom){
					if (UniUtils.indexOf(e.field,
											['WKORD_NUM']))
						return false
				}
			},
			render: function(grid, eOpts) {
				grid.getEl().on('click', function(e, t, eOpt) {
					UniAppManager.setToolbarButtons(['newData'], true);
					if(grid.getStore().count() > 0) {
						UniAppManager.setToolbarButtons(['delete'], true);
					} else {
						UniAppManager.setToolbarButtons(['delete'], false);
					}
				});
			}
		}
	});



	var tab = Unilite.createTabPanel('tabPanel',{
		split: true,
		border : false,
		region:'south',
		items: [
			masterGrid5,
			{	layout: {type: 'hbox', align: 'stretch'},
				title : '<t:message code="system.label.product.routingperentry" default="공정별등록"/>' ,
				id: 's_pmr100ukrv_inGrid3_1',
				items: [
					masterGrid3,
					masterGrid4
				]
			},
			masterGrid6
		],
		listeners:  {
			beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )   {
				if(!UniAppManager.app.isValidSearchForm()){
					return false;
				}
				if(UniAppManager.app._needSave()) {
					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
						UniAppManager.app.onSaveDataButtonDown();
						return false;
					}
				}
			},
			tabChange:  function ( tabPanel, newCard, oldCard, eOpts ) {
//				UniAppManager.setToolbarButtons(['newData', 'delete'], false);

				var newTabId	= newCard.getId();
				var record		= detailGrid.getSelectedRecord();
				if(!Ext.isEmpty(record)) {
					if(newTabId == 's_pmr100ukrv_inGrid2'){
						directMasterStore2.loadStoreRecords(record);
						UniAppManager.setToolbarButtons(['newData'], true);
					} else if(newTabId == 's_pmr100ukrv_inGrid3_1'){
						directMasterStore3.loadStoreRecords(record);
						UniAppManager.setToolbarButtons(['newData'], false);
					} else if(newTabId == 's_pmr100ukrv_inGrid5'){
						directMasterStore3.loadStoreRecords(record);	//20200423 추가: 불량내역등록탭의 불량수량 표시하기 위해 추가
						directMasterStore5.loadStoreRecords(record);
						UniAppManager.setToolbarButtons(['newData'], true);
					} else {
						directMasterStore6.loadStoreRecords(record);
						UniAppManager.setToolbarButtons(['newData'], true);
					}
				}
			}
		}
	});

	var outouProdtSaveSearch = Unilite.createSearchForm('outouProdtSaveForm', {		// 생산실적 자동입고
		layout: {type : 'uniTable', columns : 2},
		height: 200,
		items:[
			{
				xtype: 'container',
				html: '※ <t:message code="system.label.product.goodreceipt" default="양품입고"/>',
				colspan: 2,
				style: {
					color: 'blue'
				}
			},{
				fieldLabel: '<t:message code="system.label.product.receiptwarehouse" default="입고창고"/>',
				name:'GOOD_WH_CODE',
				allowBlank: false,
				xtype: 'uniCombobox',
				comboType   : 'OU',
				child: 'GOOD_WH_CELL_CODE',	//20200423 추가
//				colspan: 2,					//20200423 주석
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						outouProdtSaveSearch.setValue('BAD_WH_CODE',newValue);
					}
				}
			},{	//20200423 추가
                fieldLabel: '<t:message code="system.label.product.goodwarehousecell" default="양품창고cell"/>',
                name: 'GOOD_WH_CELL_CODE',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('whCellList'),
				allowBlank: false,
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {

                    }
                }
            },{
				fieldLabel: '<t:message code="system.label.product.receiptcharger" default="입고담당자"/>',
				name:'GOOD_PRSN',
				allowBlank: false,
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						outouProdtSaveSearch.setValue('BAD_PRSN',newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.gooditemqty" default="양품량"/>',
				name:'GOOD_Q',
				xtype: 'uniNumberfield'
			},{
				xtype: 'container',
				html: '※ <t:message code="system.label.product.defectreceipt" default="불량입고"/>',
				colspan: 2,
				style: {
					color: 'blue'
				}
			},{
				fieldLabel: '<t:message code="system.label.product.receiptwarehouse" default="입고창고"/>',
				name:'BAD_WH_CODE',
				allowBlank: true,
				xtype: 'uniCombobox',
				child: 'BAD_WH_CELL_CODE',	//20200423 추가
				comboType   : 'OU'
//				colspan: 2				//20200423 주석
			},{	//20200423 추가
                fieldLabel: '<t:message code="system.label.product.badwarehousecell" default="불량창고cell"/>',
                name: 'BAD_WH_CELL_CODE',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('whCellList2'),
				allowBlank: true,
                listeners: {
                	render: function(combo, eOpts){
                    }
                }
            },{
				fieldLabel: '<t:message code="system.label.product.receiptcharger" default="입고담당자"/>',
				name:'BAD_PRSN',
				allowBlank: true,
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024'
			},{
				fieldLabel: '<t:message code="system.label.product.defectqty" default="불량수량"/>',
				name:'BAD_Q',
				xtype: 'uniNumberfield'//,
//				margin: '10 10 10 10'				//20200423 주석: 왜?? ?
			}
		],
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

	function openoutouProdtSave() { 	// 생산실적 자동입고
		if(!outouProdtSave) {
			outouProdtSave = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.product.productionautoinput" default="생산실적 자동입고"/>',
				width: 550,
				height: 230,
				layout: {type:'vbox', align:'stretch'},
				items: [outouProdtSaveSearch],
				tbar:  ['->',
					{itemId : 'saveBtn',
					text: '<t:message code="system.label.product.confirm" default="확인"/>',
					handler: function() {
						var activeTabId = tab.getActiveTab().getId();
						if(activeTabId == 's_pmr100ukrv_inGrid2') {	// 작업지시별 등록
							if(outouProdtSaveSearch.setAllFieldsReadOnly(true) == false){
								return false;
							} else {
								if(!Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_Q'))){
									if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_WH_CODE'))){
										alert('<t:message code="system.message.product.message061" default="불량 입고창고를 선택해 주십시오."/>');
										return false;
									}else if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_PRSN'))){
										alert('<t:message code="system.message.product.message062" default="불량 입고담당자를 선택해 주십시오."/>');
										return false;
									}else if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_WH_CELL_CODE'))){
										alert('<t:message code="system.message.product.message065" default="불량 입고창고cell을 선택해 주십시오."/>');
										return false;
									}
								}

								var records = masterGrid2.getStore().getNewRecords();
								Ext.each(records, function(record,i) {
									masterGrid2.setOutouProdtSave(record);
								});
								outouProdtSave.hide();
								directMasterStore2.saveStore();
							}
						}
						if(activeTabId == 's_pmr100ukrv_inGrid3_1') {	// 공정별 등록
							if(outouProdtSaveSearch.setAllFieldsReadOnly(true) == false){
								return false;
							} else {
								//공정별등록 그리드 관련 로직

								if(!Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_Q')) && outouProdtSaveSearch.getValue('BAD_Q') > 0){
									if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_WH_CODE'))){
										alert('불량 입고창고를 선택해 주십시오.');
										return false;
									}else if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_PRSN'))){
										alert('불량 입고담당자를 선택해 주십시오.');
										return false;
									}else if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_WH_CELL_CODE'))){
										alert('<t:message code="system.message.product.message065" default="불량 입고창고cell을 선택해 주십시오."/>');
										return false;
									}
								}
								var updateData = masterGrid3.getStore().getUpdatedRecords();
								if(!Ext.isEmpty(updateData)) {
									Ext.each(updateData, function(updateRecord,i) {
										if(updateRecord.get('LINE_END_YN') == 'Y'){
											masterGrid3.setOutouProdtSave(updateRecord);
										}
									});
									outouProdtSave.hide();
									directMasterStore3.saveStore();
								}

								//실적현황 그리드 관련 로직
								var deleteData = masterGrid4.getStore().getRemovedRecords();	//실적현황 그리드의 삭제된 데이터
								if(!Ext.isEmpty(deleteData)) {
									Ext.each(deleteData, function(deleteRecord,i) {
										if(deleteRecord.get('LINE_END_YN') == 'Y'){
											masterGrid4.setOutouProdtSave(deleteRecord);
										}
									});
									outouProdtSave.hide();
									directMasterStore4.saveStore();
								}

							}
						}
					},
					disabled: false
					}, {
						itemId : 'CloseBtn',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							outouProdtSave.hide();
						}
					}
				],
				listeners: {
					beforehide: function(me, eOpt) {
						outouProdtSaveSearch.clearForm();
					},
					beforeshow: function( panel, eOpts )	{
						var activeTabId = tab.getActiveTab().getId();
						var detailRecord = detailGrid.getSelectedRecord();
						if(activeTabId == 's_pmr100ukrv_inGrid2') {	// 작업지시별 등록
							var record = masterGrid2.getSelectedRecord();
							outouProdtSaveSearch.setValue('GOOD_Q',record.get('GOOD_PRODT_Q'));
							outouProdtSaveSearch.setValue('BAD_Q',record.get('BAD_PRODT_Q'));

							outouProdtSaveSearch.setValue('GOOD_WH_CODE',detailRecord.get('WH_CODE'));

							if(!Ext.isEmpty(record.get('BAD_PRODT_Q'))){
								outouProdtSaveSearch.setValue('BAD_WH_CODE',detailRecord.get('WH_CODE'));
							}
						}
						if(activeTabId == 's_pmr100ukrv_inGrid3_1') {	// 공정 등록
							var records = directMasterStore3.data.items;

							Ext.each(records, function(record,i) {
								if(record.get('LINE_END_YN') == 'Y'){
									outouProdtSaveSearch.setValue('GOOD_Q'				, record.get('GOOD_WORK_Q'));
									outouProdtSaveSearch.setValue('BAD_Q'				, record.get('BAD_WORK_Q'));
									outouProdtSaveSearch.setValue('GOOD_WH_CODE'		, record.get('GOOD_WH_CODE'));
									outouProdtSaveSearch.setValue('GOOD_WH_CELL_CODE'	, '00');			//20200427 추가: '00' 기본값 세팅
									outouProdtSaveSearch.setValue('GOOD_PRSN'			, record.get('GOOD_PRSN'));
									outouProdtSaveSearch.setValue('BAD_PRSN'			, record.get('BAD_PRSN'));
									if(!Ext.isEmpty(record.get('BAD_WORK_Q'))){
										outouProdtSaveSearch.setValue('BAD_WH_CODE'		, record.get('BAD_WH_CODE'));
										outouProdtSaveSearch.setValue('BAD_WH_CELL_CODE', '00');			//20200427 추가: '00' 기본값 세팅
									}
								}
							});
						}
					}
				}
			})
		}
		outouProdtSave.center();
		outouProdtSave.show();
	}

	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border : false,
			items:[
				detailGrid, tab, panelResult
			]
		},
			masterForm
		],
		id: 's_pmr100ukrv_inApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			detailGrid.disabledLinkButtons(false);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
			//모든 탭 초기화 후, detailGrid 조회
			directMasterStore2.loadData({})
			directMasterStore3.loadData({})
			directMasterStore4.loadData({})
			directMasterStore5.loadData({})
			directMasterStore6.loadData({})

			detailStore.loadStoreRecords();
			UniAppManager.setToolbarButtons(['newData'], true);
		},
		onNewDataButtonDown: function()	{
			//if(!this.checkForNewDetail()) return false;
			var selectedDetailGrid = detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(selectedDetailGrid)) {
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 's_pmr100ukrv_inGrid2') {
					var allRecords = directMasterStore2.data.items;
					var cnt = 0;
					Ext.each(allRecords,function(r,i){
						if(r.phantom == true){
							cnt = cnt + 1;
						}
					})
					if(cnt == 0){
						var record = detailGrid.getSelectedRecord();
						var wkordNum = record.get('WKORD_NUM');
						//var prodtNum = masterForm.getValue('PRODT_NUM');
						var seq = detailStore.max('PRODT_Q');
						if(!seq) seq = 1;
						else  seq += 1;
						var prodtDate	= UniDate.get('today');
						var progWorkCode = record.get('PROG_WORK_CODE');
						var wkordQ	= record.get('WKORD_Q');
						var prodtQ	= 0; //생산량
						var goodProdtQ= 0; //양품량
						var badProdtQ	= 0; //불량량
						var manHour	  = 0; //투입공수
						var lotNo		= record.get('LOT_NO');
						var remark	= record.get('REMARK');
						var projectNo	= record.get('PROJECT_NO');
						var pjtCode	  = record.get('PJT_CODE');
						var divCode	  = masterForm.getValue('DIV_CODE');
						var workShopCode = masterForm.getValue('WORK_SHOP_CODE');
						var itemCode	  = masterForm.getValue('ITEM_CODE1');
						var controlStatus= Ext.getCmp('rdoSelect').getChecked()[0].inputValue
						var newData		= 'N';

						var r = {
							WKORD_NUM		:wkordNum,
							//PRODT_NUM		:prodtNum,
							PRODT_Q			:seq,
							PRODT_DATE		:prodtDate,
							PROG_WORK_CODE	:progWorkCode,
							WKORD_Q			:wkordQ,
							PRODT_Q			:prodtQ,
							GOOD_PRODT_Q	:goodProdtQ,
							BAD_PRODT_Q		:badProdtQ,
							MAN_HOUR		:manHour,
							LOT_NO			:lotNo,
							REMARK			:remark,
							PROJECT_NO		:projectNo,
							PJT_CODE		:pjtCode,
							DIV_CODE		:divCode,
							WORK_SHOP_CODE	:workShopCode,
							ITEM_CODE		:itemCode,
							CONTROL_STATUS	:controlStatus,
							NEW_DATA		:newData
							//COMP_CODE		:compCode
						};
						masterGrid2.createRow(r, 'PRODT_Q', masterGrid2.getStore().getCount() - 1);
					}else{
						return false;
					}
				} else if(activeTabId == 's_pmr100ukrv_inGrid5') {
					 var record			= detailGrid.getSelectedRecord();
					 var divCode		= masterForm.getValue('DIV_CODE');
					 var prodtDate		= UniDate.get('today');
					 var workShopcode	= record.get('WORK_SHOP_CODE');
					 var wkordNum		= record.get('WKORD_NUM');
					 var itemCode		= record.get('ITEM_CODE');
					 var progWorkName	= '';
					 var badCode		= '';
					 var badQ			= 0;
					 var remark			= '';

					 var r = {
						DIV_CODE			: divCode,
						PRODT_DATE			: prodtDate,
						WORK_SHOP_CODE		: workShopcode,
						WKORD_NUM			: wkordNum,
						ITEM_CODE	 		: itemCode,
						PROG_WORK_NAME		: progWorkName,
						BAD_CODE			: badCode,
						BAD_Q				: badQ,
						REMARK				: remark
						//COMP_CODE			:compCode
					};
					masterGrid5.createRow(r);
				} else if(activeTabId == 's_pmr100ukrv_inGrid6') {
					var record = detailGrid.getSelectedRecord();
					 var divCode		= masterForm.getValue('DIV_CODE');
					 var prodtDate		= UniDate.get('today');
					 var workShopcode	= record.get('WORK_SHOP_CODE');
					 var wkordNum		= record.get('WKORD_NUM');
					 var itemCode		= record.get('ITEM_CODE');
					 var progWorkName	= '';
					 var ctlCd1			= '';
					 var troubleTime	= '';
					 var trouble		= '';
					 var troubleCs		= '';
					 var answer			= '';

					 var r = {
						DIV_CODE				: divCode,
						PRODT_DATE				: prodtDate,
						WORK_SHOP_CODE			: workShopcode,
						WKORD_NUM				: wkordNum,
						ITEM_CODE				: itemCode,
						PROG_WORK_NAME			: progWorkName,
						CTL_CD1					: ctlCd1,
						TROUBLE_TIME			: troubleTime,
						TROUBLE					: trouble,
						TROUBLE_CS				: troubleCs,
						ANSWER					: answer
						//COMP_CODE				:compCode
					};
					masterGrid6.createRow(r);
				}
				masterForm.setAllFieldsReadOnly(false);
			} else {
				alert(Msg.sMA0256);
				return false;
			}
		},
		onResetButtonDown: function() {		// 새로고침 버튼
			this.suspendEvents();
			masterForm.clearForm();
			panelResult.clearForm();

			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			masterGrid2.reset();
			masterGrid3.reset();
			masterGrid4.reset();
			masterGrid5.reset();
			masterGrid6.reset();
			this.fnInitBinding();
			detailStore.clearData();
			directMasterStore2.clearData();
			directMasterStore3.clearData();
			directMasterStore4.clearData();
			directMasterStore5.clearData();
			directMasterStore6.clearData();
		},
		onDeleteDataButtonDown: function() {
			var selectedDetailGrid = detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(selectedDetailGrid)) {
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 's_pmr100ukrv_inGrid2') {
					var selRow = masterGrid2.getSelectedRecord();
					if(selRow.phantom === true)	{
						masterGrid2.deleteSelectedRow();
					}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						masterGrid2.deleteSelectedRow();
					}
				} else if(activeTabId == 's_pmr100ukrv_inGrid3_1') {	//masterGrid3은 삭제로직 없음, masterGrid4가 삭제
					var selRow = masterGrid4.getSelectedRecord();
					if(selRow.phantom === true)	{
						masterGrid4.deleteSelectedRow();
					}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						masterGrid4.deleteSelectedRow();
					}
				} else if(activeTabId == 's_pmr100ukrv_inGrid5') {
					var selRow = masterGrid5.getSelectedRecord();
					if(selRow.phantom === true)	{
						masterGrid5.deleteSelectedRow();
					}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						masterGrid5.deleteSelectedRow();
					}
				} else if(activeTabId == 's_pmr100ukrv_inGrid6') {
					var selRow = masterGrid6.getSelectedRecord();
					if(selRow.phantom === true)	{
						masterGrid6.deleteSelectedRow();
					}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						masterGrid6.deleteSelectedRow();
					}
				}
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('s_pmr100ukrv_inAdvanceSerch');
			if(as.isHidden())	{
				as.show();
			} else {
				as.hide()
			}
		},
		onSaveDataButtonDown: function(config) {
			var activeTabId = tab.getActiveTab().getId();
			var selectDetailRecord = detailGrid.getSelectedRecord();

			//detailStore.saveStore();
			if(activeTabId == 's_pmr100ukrv_inGrid2') {						// 작업지시별 등록
				masterForm.setValue('RESULT_TYPE', "1");
				var inValidRecs	= masterGrid2.getStore().getInvalidRecords();
				var newData		= masterGrid2.getStore().getNewRecords();

				if(inValidRecs.length == 0) {
					if(newData && newData.length > 0) {
						if(selectDetailRecord.get('RESULT_YN') == '2'){
							openoutouProdtSave();
						}else{
							directMasterStore2.saveStore();
						}
					} else {
						directMasterStore2.saveStore();
					}
				} else {
					var grid = Ext.getCmp('s_pmr100ukrv_inGrid2');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}

			} else if(activeTabId == 's_pmr100ukrv_inGrid3_1') {				// 공정별 등록
				masterForm.setValue('RESULT_TYPE', "2");
				var inValidRecs1	= masterGrid3.getStore().getInvalidRecords();
				var inValidRecs2	= masterGrid4.getStore().getInvalidRecords();
				var updateData		= masterGrid3.getStore().getUpdatedRecords();	//공정별 등록 그리드의 수정된 데이터
				var deleteData		= masterGrid4.getStore().getRemovedRecords();	//실적현황 그리드의 삭제된 데이터

				//공정별 등록 그리드의 수정된 데이터 관련 로직
				if(inValidRecs1.length == 0) {
					if(updateData && updateData.length > 0) {
						if(selectDetailRecord.get('RESULT_YN') == '2'){
							var cnt = 0;
							Ext.each(updateData, function(updateRecord,i) {
								if(updateRecord.get('LINE_END_YN') == 'Y'){
									cnt = cnt + 1;
								}
							});
							if(cnt > 0){
								openoutouProdtSave();
							}else{
								directMasterStore3.saveStore();

							}
						}else{
							directMasterStore3.saveStore();
						}
					}
				} else {
					var grid = Ext.getCmp('s_pmr100ukrv_inGrid3');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs1);
				}

				//실적현황 그리드의 삭제된 데이터 관련 로직
				if(inValidRecs2.length == 0) {
					if(deleteData && deleteData.length > 0) {
						/*
						 * 실적현황 삭제시 팝업이 뜨면 안되고 바로 삭제 되어야 함
						 * if(selectDetailRecord.get('RESULT_YN') == '2'){
							var cnt = 0;
							Ext.each(deleteData, function(deleteRecord,i) {
								if(deleteRecord.get('LINE_END_YN') == 'Y'){
									cnt = cnt + 1;
								}
							});
							if(cnt > 0){
								openoutouProdtSave();
							}else{
								directMasterStore4.saveStore();

							}
						}else{
							directMasterStore4.saveStore();
						}*/
						directMasterStore4.saveStore();
					}
				} else {
					var grid = Ext.getCmp('s_pmr100ukrv_inGrid3');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs2);
				}
			} else if(activeTabId == 's_pmr100ukrv_inGrid5') {	// 불량내역 등록
				masterForm.setValue('RESULT_TYPE', "3");
				directMasterStore5.saveStore();
				needSave = false;
			} else if(activeTabId == 's_pmr100ukrv_inGrid6') {	// 특기사항 등록
				masterForm.setValue('RESULT_TYPE', "4");
				directMasterStore6.saveStore();
			}
		},
		rejectSave: function() {
			var rowIndex = detailGrid.getSelectedRowIndex();
			detailGrid.select(rowIndex);
			detailStore.rejectChanges();

			if(rowIndex >= 0){
				detailGrid.getSelectionModel().select(rowIndex);
				var selected = detailGrid.getSelectedRecord();

				var selected_doc_no = selected.data['DOC_NO'];
  				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {
					}
				);
			}
			detailStore.onStoreActionEnable();

		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('s_pmr100ukrv_inFileUploadPanel');
			if(detailStore.isDirty() || fp.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('PRODT_START_DATE_FR',UniDate.get('startOfMonth'));
			masterForm.setValue('PRODT_START_DATE_TO',UniDate.get('today'));
			masterForm.setValue('CONTROL_STATUS','2');
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('PRODT_START_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('PRODT_START_DATE_TO',UniDate.get('today'));
			panelResult.setValue('CONTROL_STATUS','2');
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		}
	});




	/**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {

			}
			return rv;
		}
	}); // validator

	Unilite.createValidator('validator02', {
		store: directMasterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PRODT_Q" :	// 생산량
					if(newValue < 0) {
						rv= '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
						break;
					}
					record.set('GOOD_PRODT_Q', newValue);
				break;

				case "GOOD_PRODT_Q" :	// 양품량
					var record1 = masterGrid2.getSelectedRecord();
					if(newValue > record1.get('PRODT_Q')) {
						alert('<t:message code="system.message.product.message011" default="양품량은 생산량 보다 많을 수 없습니다."/>');
						break;
					}
					record.set('BAD_PRODT_Q', record.get('PRODT_Q') - newValue);
				break;

				case "BAD_PRODT_Q" :	// 불량량
					if(newValue > "PRODT_Q") {
						alert('<t:message code="system.message.product.message012" default="불량량은 생산량 보다 많을 수 없습니다."/>');
						break;
					}
					record.set('GOOD_PRODT_Q', record.get('PRODT_Q') - newValue);
				break;

				case "MAN_HOUR" :	// 투입공수
					if(newValue < 0) {
						rv= '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
						break;
					}
				break;

				case "LOT_NO" :	// LOT_NO
					if(UniBase.fnDateCheckValidator(newValue) == false){
						rv='<t:message code="system.message.product.message037" default="유효한 날짜를 입력하여 주십시오."/>';
						break;
					}
				break;
			}
			return rv;
		}
	}); // validator

	Unilite.createValidator('validator03', {
		store: directMasterStore3,
		grid: masterGrid3,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PASS_Q" :	// 생산량
					if(newValue < 0) {
						rv= '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
						break;
					}

					var badQ = record.get('BAD_WORK_Q')

					record.set('GOOD_WORK_Q', newValue - badQ);
					//record.set('BAD_WORK_Q', 0);
					record.set('WORK_Q'		, newValue - badQ);
				break;

				case "GOOD_WORK_Q" :	// 양품량

					if(newValue > record.get('PASS_Q')) {
						alert('<t:message code="system.message.product.message011" default="양품량은 생산량 보다 많을 수 없습니다."/>');
						break;
					}
					record.set('BAD_WORK_Q', record.get('PASS_Q') - newValue);
				  break;

				case "BAD_QC_Q" :   //QC수량
					record.set('BAD_WORK_Q', record.get('BAD_PROG_Q') + newValue);
					record.set('GOOD_WORK_Q', record.get('PASS_Q') - record.get('BAD_WORK_Q'));
					break;

				case "BAD_PROG_Q" :   //분주불량수량
					record.set('BAD_WORK_Q', record.get('BAD_QC_Q') + newValue);
					record.set('GOOD_WORK_Q', record.get('PASS_Q') - record.get('BAD_WORK_Q'));
					break;

				case "BAD_WORK_Q" :	// 불량량
					if(newValue > record.get('PASS_Q')) {
						alert('<t:message code="system.message.product.message012" default="불량량은 생산량 보다 많을 수 없습니다."/>');
						break;
					}
					record.set('GOOD_WORK_Q', record.get('PASS_Q') - newValue);
				  break;

				case "MAN_HOUR" :	// 투입공수
					if(newValue < 0) {
						rv= '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
						break;
					}
				break;
				case "LOT_NO" :	// LOT_NO
					if(UniBase.fnDateCheckValidator(newValue) == false){
						rv='<t:message code="system.message.product.message037" default="유효한 날짜를 입력하여 주십시오."/>';
						break;
					}
				break;


				case "PRODT_START_TIME" :
					var startTime =  '2000/01/01 '+ newValue.substring(0,2) +':'+newValue.substring(2,4)+':'+'00';
					var prodtStartTime = new Date(startTime);
					var endTime =  '2000/01/01 '+ record.get('PRODT_END_TIME').substring(0,2) +':'+record.get('PRODT_END_TIME').substring(2,4)+':'+'00';
					var prodtEndTime = new Date(endTime);
					var tot = parseInt(prodtEndTime - prodtStartTime) / 1000 / 60;
					if(prodtEndTime > prodtStartTime || tot<0){
						tot=0;
						break;
					}
					record.set('MAN_HOUR',tot);
				break;

				case "PRODT_END_TIME" :
					var endTime =  '2000/01/01 '+ newValue.substring(0,2) +':'+newValue.substring(2,4)+':'+'00';
					var prodtEndTime = new Date(endTime);
					var startTime =  '2000/01/01 '+ record.get('PRODT_START_TIME').substring(0,2) +':'+record.get('PRODT_START_TIME').substring(2,4)+':'+'00';
					var prodtStartTime = new Date(startTime);
					var tot = parseInt(prodtEndTime - prodtStartTime) / 1000 / 60;
					if(prodtEndTime < prodtStartTime || tot<0){
						tot=0;
						break;
					}
					record.set('MAN_HOUR',tot);
				break;
			}
			return rv;
		}
	});

	Unilite.createValidator('validator05', {
		store: directMasterStore5,
		grid: masterGrid5,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			case "BAD_Q" :	// 수량
				if(newValue < 0) {
					rv= '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
					break;
				}

					record.set('CHECK_VALUE','C');
					needSave = true;


				if(newValue < oldValue){
					Ext.getCmp('TOT_BAD').setValue(parseInt(Ext.getCmp('TOT_BAD').getValue()) - (oldValue-newValue) );
				}else if(newValue > oldValue){
					if(Ext.getCmp('TOT_BAD').getValue()==0){
						Ext.getCmp('TOT_BAD').setValue((newValue-oldValue));
					}else{
						Ext.getCmp('TOT_BAD').setValue(parseInt(Ext.getCmp('TOT_BAD').getValue()) + (newValue-oldValue) );
					}

				}
				if(!Ext.isEmpty(record.obj.getModified('BAD_Q'))){
					if(record.obj.modified.BAD_Q == newValue){
						record.set('CHECK_VALUE',record.obj.getModified('CHECK_VALUE'));
					}
				}
			break;
			}
			return rv;
		}
	});

	Unilite.createValidator('validator06', {
		store: directMasterStore6,
		grid: masterGrid6,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "TROUBLE_TIME" :	// 발생시간
					if(newValue < 0) {
						rv= '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
						break;
					}
				break;
			}
			return rv;
		}
	});
}
</script>