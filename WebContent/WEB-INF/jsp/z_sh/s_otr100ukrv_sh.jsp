<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_otr100ukrv_sh">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M201"/>	<!-- 구매담당 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

var BsaCodeInfo = { // 컨트롤러에서 값을 받아옴
	gsExchgRegYN	: '${gsExchgRegYN}',	//'대체품목 등록여부(공통코드 B081에서 설정)
	gsCheckMath		: '${gsCheckMath}'		//'외주입고시 외주출고량 체크방법
};

var outDivCode = UserInfo.divCode;
var beforeRowIndex;				//마스터그리드 같은row중복 클릭시 다시 load되지 않게
var refferReplaceItemWindow;	//대체품목참조

function appMain() {
	var bExchgRegYN = false;	//hidden false
	if(BsaCodeInfo.gsExchgRegYN =='N')  {
		bExchgRegYN = true;	 //hidden true
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_otr100ukrv_shService.selectDetail',
			update	: 's_otr100ukrv_shService.updateDetail',
			create	: 's_otr100ukrv_shService.insertDetail',
			destroy	: 's_otr100ukrv_shService.deleteDetail',
			syncAll	: 's_otr100ukrv_shService.saveAll'
		}
	});

	/** 검색조건 (Search Panel)
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
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				holdable: 'hold',
				allowBlank: false
			},{
				fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_ORDER_DATE',
				endFieldName: 'TO_ORDER_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width:320,
				holdable: 'hold',
				allowBlank:false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('FR_ORDER_DATE', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('TO_ORDER_DATE', newValue);
					}
				}
			},
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				allowBlank: false,
				holdable: 'hold',
				extParam: {'CUSTOM_TYPE': ['1','2']},
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelResult.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				holdable: 'hold',
				comboType: 'AU',
				comboCode: 'M201',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.pono" default="발주번호"/>',
				name:'ORDER_NUM',
				xtype: 'uniTextfield',
				holdable: 'hold',
				hidden	: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_NUM', newValue);
					}
				}
			},{	//20200120 조회조건용 발주번호 필드 추가
				fieldLabel: '<t:message code="system.label.purchase.pono" default="발주번호"/>',
				name:'ORDER_NUM_SEARCH',
				xtype: 'uniTextfield',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_NUM_SEARCH', newValue);
					}
				}
			},{	//20200120 조회조건용 수주번호 필드 추가
				fieldLabel: '<t:message code="system.label.purchase.sono" default="수주번호"/>',
				name:'SOF_ORDER_NUM',
				xtype: 'uniTextfield',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SOF_ORDER_NUM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.poseq" default="발주순번"/>',
				name:'ORDER_SEQ',
				xtype: 'uniNumberfield',
				hidden: true,
				readOnly:false
			},{
				fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
				name:'ORDER_DATE',
				xtype: 'uniDatefield',
				hidden: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				name:'ITEM_CODE',
				hidden	: true,
				xtype: 'uniTextfield'
			},{
				fieldLabel: '<t:message code="system.label.purchase.remarks" default="비고"/>',
				name:'REMARK',
				xtype: 'hiddenfield'
			},{
				fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				name:'PROJECT_NO',
				xtype: 'hiddenfield'
			},{
				fieldLabel: '<t:message code="system.label.purchase.poqty" default="발주량"/>',
				name:'ORDER_Q',
				xtype: 'hiddenfield'
			},{
				fieldLabel: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>',
				name:'CONTROL_STATUS',
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
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )   {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)   {
							var popupFC = item.up('uniPopupField')  ;
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
					if(Ext.isDefined(item.holdable) )   {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)   {
						var popupFC = item.up('uniPopupField')  ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	}); // End of var masterForm = Unilite.createSearchForm('searchForm',{   !UserInfo.appOption.collapseLeftSearch,

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
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = masterForm.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					masterForm.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_ORDER_DATE',
			endFieldName: 'TO_ORDER_DATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width:320,
			holdable: 'hold',
			allowBlank:false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(masterForm) {
					masterForm.setValue('FR_ORDER_DATE', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(masterForm) {
					masterForm.setValue('TO_ORDER_DATE', newValue);
				}
			}
		},{	//20200120 조회조건용 발주번호 필드 추가
			fieldLabel: '<t:message code="system.label.purchase.pono" default="발주번호"/>',
			name:'ORDER_NUM_SEARCH',
			xtype: 'uniTextfield',
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('ORDER_NUM_SEARCH', newValue);
				}
			}
		},
		Unilite.popup('CUST', {
			fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			allowBlank: false,
			holdable: 'hold',
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
				onClear: function(type) {
					masterForm.setValue('CUSTOM_CODE', '');
					masterForm.setValue('CUSTOM_NAME', '');
				}
			}
		}), {
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name:'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M201',
			holdable: 'hold',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				/*
				if(eOpts){
					combo.filterByRefCode('refCode4', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode4', newValue, divCode);
				}
				*/
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('ORDER_PRSN', newValue);
				}
			}
		},{	//20200120 조회조건용 수주번호 필드 추가
			fieldLabel: '<t:message code="system.label.purchase.sono" default="수주번호"/>',
			name:'SOF_ORDER_NUM',
			xtype: 'uniTextfield',
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('SOF_ORDER_NUM', newValue);
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
						if(Ext.isDefined(item.holdable) )   {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)   {
							var popupFC = item.up('uniPopupField')  ;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )   {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)   {
						var popupFC = item.up('uniPopupField')  ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});


	Unilite.defineModel('S_otr100ukrv_shModel1', {		// 메인1
		fields: [
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			,type: 'string'},
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.purchase.division" default="사업장"/>'				,type: 'string'},
			//20200120 추가: SOF_ORDER_NUM, SOF_ORDER_SEQ, SOF_CUSTOM_NAME, SOF_ITEM_NAME
			{name: 'SOF_ORDER_NUM'	,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'					,type: 'string'},
			{name: 'SOF_ORDER_SEQ'	,text: '<t:message code="system.label.purchase.seq" default="순번"/>'						,type: 'int'},
			{name: 'SOF_CUSTOM_NAME',text: '<t:message code="system.label.purchase.soplace" default="수주처"/>'				,type: 'string'},
			{name: 'SOF_ITEM_NAME'	,text: '<t:message code="system.label.purchase.soitemname" default="수주품목명"/>'			,type: 'string'},
			{name: 'ORDER_DATE'		,text: '<t:message code="system.label.purchase.podate" default="발주일"/>'					,type: 'uniDate'},
			{name: 'ORDER_NUM'		,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'					,type: 'string'},
			{name: 'ORDER_SEQ'		,text: '<t:message code="system.label.purchase.seq" default="순번"/>'						,type: 'int'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.purchase.spec" default="규격"/>'					,type: 'string'},
			{name: 'G_SORT_KEY'		,text: 'G_SORT_KEY'	 ,type: 'string'},
			{name: 'ORDER_UNIT_Q'	,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'					,type: 'uniQty'},
			{name: 'ORDER_UNIT'		,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			,type: 'string'},
			{name: 'MONEY_UNIT'		,text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				,type: 'string'},
			{name: 'ORDER_UNIT_P'	,text: '<t:message code="system.label.purchase.price" default="단가"/>'					,type: 'uniUnitPrice'},
			{name: 'ORDER_O'		,text: '<t:message code="system.label.purchase.amount" default="금액"/>'					,type: 'uniPrice'},
			{name: 'ORDER_Q'		,text: '<t:message code="system.label.purchase.inventoryunitqty" default="재고단위량"/>'		,type: 'uniQty'},
			{name: 'ORDER_P'		,text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>'	,type: 'uniUnitPrice'},
			{name: 'DVRY_DATE'		,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			,type: 'uniDate'},
			{name: 'ORDER_PRSN'		,text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'		,type: 'string', comboType:'AU', comboCode:'M201'},
			{name: 'CONTROL_STATUS'	,text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'			,type: 'string', comboType:'AU', comboCode:'M002'},
			{name: 'ORDER_REQ_NUM'	,text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'	,type: 'string'},
			{name: 'REMARK'			,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					,type: 'string'},
			{name: 'PROJECT_NO'		,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			,type: 'string'}
		]
	});
	Unilite.defineModel('S_otr100ukrv_shModel2', {		// 메인2
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				,type: 'string', defaultValue: UserInfo.compCode},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'					,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>'				,type: 'string'},
			{name: 'ORDER_ITEM_CODE'	,text: '<t:message code="system.label.purchase.poitemcode" default="발주품목코드"/>'				,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						,type: 'string'},
			{name: 'ORDER_SEQ'			,text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'						,type: 'int'},
			{name: 'SEQ'				,text: '<t:message code="system.label.purchase.seq" default="순번"/>'							,type: 'int', allowBlank: false},
			{name: 'PATH_CODE'			,text: '<t:message code="system.label.purchase.bomcomppathcode" default="BOM구성경로코드"/>'		,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'						,type: 'string'},
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.purchase.allocationdate" default="예약일"/>'				,type: 'uniDate'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'				,type: 'string', comboType: 'AU', comboCode: 'B013', displayField: 'value' },
			{name: 'ALLOC_Q'			,text: '<t:message code="system.label.purchase.allocationqty" default="예약량"/>'				,type: 'float', allowBlank: false, decimalPrecision: 6, format:'0,000.000000'},
			{name: 'PAB_STOCK_Q'		,text: '<t:message code="system.label.purchase.availableinventoryqty" default="가용재고량"/>'	,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'SHORTAGE_Q'			,text: '<t:message code="system.label.purchase.shortageqty" default="부족수량"/>'				,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
//			{name: 'EXCHG_EXIST_YN'		,text: '대체품존재여부'	,type: 'string', comboType:'AU', comboCode:'B081'},
//			{name: 'REF_ITEM_CODE'		,text: '대체전품목코드'	,type: 'string'},
//			{name: 'REF_ITEM_NAME'		,text: '대체전품목명'		,type: 'string'},
//			{name: 'EXCHG_YN'			,text: '대체여부'		,type: 'string', comboType:'AU', comboCode:'B081'},
			{name: 'OUTSTOCK_Q'			,text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'					,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'UNIT_Q'				,text: '<t:message code="system.label.purchase.originunitqty" default="원단위량"/>'				,type: 'float', allowBlank: false, decimalPrecision: 6, format:'0,000.000000'},
			{name: 'LOSS_RATE'			,text: '<t:message code="system.label.purchase.lossrate" default="Loss율"/>'					,type: 'uniPercent'},
			{name: 'CONTROL_STATUS'		,text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'				,type: 'string', comboType:'AU', comboCode:'M010', allowBlank: false},
			{name: 'GRANT_TYPE'			,text: '<t:message code="system.label.purchase.subcontractdivision" default="사급구분"/>'		,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'						,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				,type: 'string'},
			{name: 'NEED_Q'				,text: '<t:message code="system.label.purchase.needqty" default="필요수량"/>'					,type: 'float'},
			{name: 'OUT_DIV_CODE'		,text: '<t:message code="system.label.purchase.outdivcode" default="출고사업장"/>'				,type: 'string', comboType:'BOR120'},
			{name: 'OUT_DATE'			,text: '<t:message code="system.label.purchase.issuedate" default="출고일"/>'					,type: 'uniDate'},
			{name: 'OUT_SEQ'			,text: '<t:message code="system.label.purchase.outseq" default="출고순번"/>'					,type: 'int'}
		]
	});


	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_otr100ukrv_shMasterStore1',{	 // 메인1
		model: 'S_otr100ukrv_shModel1',
		uniOpt : {
			isMaster: true,		 // 상위 버튼 연결
			editable: false,		// 수정 모드 사용
			deletable: false,	   // 삭제 가능 여부
			useNavi : false		 // prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				   read: 's_otr100ukrv_shService.selectMaster'
			}
		},
		loadStoreRecords : function()   {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function() {}
	});	 // End of var directMasterStore1 = Unilite.createStore('S_otr100ukrv_shMasterStore1',{

	var directMasterStore2 = Unilite.createStore('s_otr100ukrv_shMasterStore2',{	 // 메인2
		model: 'S_otr100ukrv_shModel2',
		uniOpt : {
			isMaster: true,		 // 상위 버튼 연결
			editable: true,		 // 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi : false		 // prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords : function()   {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},

		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {

						//masterForm.getForm().wasDirty = false;
						//masterForm.resetDirtyStatus();
						//console.log("set was dirty to false");
						directMasterStore2.loadStoreRecords();

						UniAppManager.setToolbarButtons('save', false);
					}
				};
				//alert("syncAllDirect() before");
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_otr100ukrv_shGrid2');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});	 // End of var directMasterStore2 = Unilite.createStore('S_otr100ukrv_shMasterStore2')



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('s_otr100ukrv_shGrid1', {
		layout : 'fit',
		region:'center',
		uniOpt:{	expandLastColumn: true,
					useRowNumberer: false,
					useMultipleSorting: true
		},
		selModel: 'rowmodel',
		store: directMasterStore1,
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',	  showSummaryRow: false} ],
		columns:  [
			{ dataIndex: 'COMP_CODE'			, width:68,hidden:true},
			{ dataIndex: 'DIV_CODE'				, width:68,hidden:true},
			//20200120 추가: SOF_ORDER_NUM, SOF_ORDER_SEQ, SOF_CUSTOM_NAME, SOF_ITEM_NAME
			{ dataIndex: 'SOF_ORDER_NUM'		, width:106},
			{ dataIndex: 'SOF_ORDER_SEQ'		, width:50, align: 'center'},
			{ dataIndex: 'SOF_CUSTOM_NAME'		, width:140},
			{ dataIndex: 'SOF_ITEM_NAME'		, width:160},
			{ dataIndex: 'ORDER_DATE'			, width:76, locked: false},
			{ dataIndex: 'ORDER_NUM'			, width:106, locked: false},
			{ dataIndex: 'ORDER_SEQ'			, width:50, align: 'center'},
			{ dataIndex: 'ITEM_CODE'			, width: 93,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										masterGrid1.setItemData(record,false);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid1.setItemData(record,false);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid1.setItemData(null,true);
						}
					}
				})
			},
			{ dataIndex: 'ITEM_NAME'			, width: 160,
				editor: Unilite.popup('DIV_PUMOK_G', {
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
					autoPopup: true,
					listeners: {'onSelected': {
							fn: function(records, type) {
							console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										masterGrid1.setItemData(record,false);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid1.setItemData(record,false);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid1.setItemData(null,true);
						}
					}
				})
			},
			{ dataIndex: 'SPEC'					, width:150},
			{ dataIndex: 'G_SORT_KEY'			, width:126,hidden:true},
			{ dataIndex: 'ORDER_UNIT_Q'			, width:86},
			{ dataIndex: 'ORDER_UNIT'			, width:88, align: 'center'},
			{ dataIndex: 'MONEY_UNIT'			, width:46},
			{ dataIndex: 'ORDER_UNIT_P'			, width:80},
			{ dataIndex: 'ORDER_O'				, width:106},
			{ dataIndex: 'ORDER_Q'				, width:100,hidden:true},
			{ dataIndex: 'ORDER_P'				, width:100,hidden:true},
			{ dataIndex: 'DVRY_DATE'			, width:76},
			{ dataIndex: 'ORDER_PRSN'			, width:66},
			{ dataIndex: 'CONTROL_STATUS'		, width:80},
			{ dataIndex: 'ORDER_REQ_NUM'		, width:100},
			{ dataIndex: 'REMARK'				, width:133},
			{ dataIndex: 'PROJECT_NO'			, width:133}
		],
		listeners: {
			//contextMenu의 복사한 행 삽입 실행 전
			beforePasteRecord: function(rowIndex, record) {
				if(!UniAppManager.app.checkForNewDetail()) return false;
					var seq = directMasterStore2.max('ORDER_SEQ');
					if(!seq) seq = 1;
					else  seq += 1;
					record.ORDER_SEQ = seq;

					return true;
			},
			//contextMenu의 복사한 행 삽입 실행 후
			afterPasteRecord: function(rowIndex, record) {
				masterForm.setAllFieldsReadOnly(true);
			},
			selectionchange: function( grid, selected, eOpts ){
				var record = selected[0];
				if(!Ext.isEmpty(record)){
					masterForm.setValue('ORDER_NUM',record.get('ORDER_NUM'));
					masterForm.setValue('ORDER_SEQ',record.get('ORDER_SEQ'));
					masterForm.setValue('ORDER_DATE',record.get('ORDER_DATE'));
					masterForm.setValue('ITEM_CODE',record.get('ITEM_CODE'));
					masterForm.setValue('CONTROL_STATUS',record.get('CONTROL_STATUS'));
					masterForm.setValue('ORDER_Q',record.get('ORDER_Q'));
					masterForm.setValue('PROJECT_NO',record.get('PROJECT_NO'));
					masterForm.setValue('REMARK',record.get('REMARK'));
					directMasterStore2.loadStoreRecords(record);
				}
			},
			 beforedeselect : function ( gird, record, index, eOpts ){
				if(directMasterStore2.isDirty()) {
					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
						var inValidRecs = directMasterStore2.getInvalidRecords();
						if(inValidRecs.length > 0 ) {
							alert(Msg.sMB083);
							return false;
						}else {
							directMasterStore2.saveStore();
						}
					}
//				  Ext.Msg.show({
//					   title:'확인',
//					   msg: Msg.sMB017 + "\n" + Msg.sMB061,
//					   buttons: Ext.Msg.YESNOCANCEL,
//					   icon: Ext.Msg.QUESTION,
//					   fn: function(res) {
//						  //console.log(res);
//						  if (res === 'yes' ) {
//							  var inValidRecs = mba030ukrvs3_2Store.getInvalidRecords();
//							  if(inValidRecs.length > 0 ) {
//								  alert(Msg.sMB083);
//								  return false;
//							  }else {
//								  mba030ukrvs3_2Store.saveStore();
//							  }
//							  saveTask.delay(500);
//						  } else if(res === 'cancel') {
//							  return false;
//						  }
//					   }
//				  });
				}
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('s_otr100ukrv_shGrid2', {
		layout : 'fit',
		region:'center',
		split	: true,
		uniOpt:{	expandLastColumn: true,
					useRowNumberer: false,
					useMultipleSorting: true
		},
		tbar: [
		{
			itemId : 'refBtn',
			text:'<t:message code="system.label.purchase.subitemapply" default="대체품목 적용"/>',
			hidden: true,
			handler: function() {
				var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
				if(needSave) {
					alert(Msg.sMB154); //먼저 저장하십시오.
					return false;
				}
				var masterRec = masterGrid1.getSelectedRecord();
				var replaceRec = replaceItemGrid.getSelectedRecord();
				if(Ext.isEmpty(masterRec) || Ext.isEmpty(replaceRec)) return false;
				var controlStat = masterRec.get('CONTROL_STATUS');
				if(Ext.isEmpty(controlStat)){
					alert('<t:message code="system.message.purchase.message037" default="발주정보가 선택되지 않았습니다."/>');
					return false;
				}else if(controlStat > '1'){
					alert(Msg.fStMsgS0102); //진행상태가 발주중인것 만 추가할 수 있습니다. 진행상태를확인하십시요.
					return false;
				}
				openReplaceItemWindow();
			}
		 }],
		store: directMasterStore2,
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',	  showSummaryRow: false} ],
		columns:  [
			{ dataIndex: 'COMP_CODE'			, width:66,hidden:true},
			{ dataIndex: 'DIV_CODE'				, width:66,hidden:true},
			{ dataIndex: 'CUSTOM_CODE'			, width:66,hidden:true},
			{ dataIndex: 'ORDER_ITEM_CODE'		, width:66,hidden:true},
			{ dataIndex: 'ORDER_NUM'			, width:133,hidden:true},
			{ dataIndex: 'ORDER_SEQ'			, width:66,hidden:true},
			{ dataIndex: 'SEQ'					, width:50, align: 'center'},
			{ dataIndex: 'PATH_CODE'			, width:50,hidden:true},
			{ dataIndex: 'ITEM_CODE'			, width: 93,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {'onSelected': {
							fn: function(records, type) {
								//console.log('=======POPUP returned records : ', records);
								//alert('=======POPUP returned records : ', records);
								Ext.each(records, function(record,i) {
									//console.log('record',record);
									//alert('=======POPUP returned one record : ', record);
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
			{ dataIndex: 'ITEM_NAME'			, width: 160,
				editor: Unilite.popup('DIV_PUMOK_G', {
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
					autoPopup: true,
					listeners: {'onSelected': {
							fn: function(records, type) {
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
			{ dataIndex: 'SPEC'					, width:150},
			{ dataIndex: 'OUT_SEQ'				, width:66,hidden: false},
			{ dataIndex: 'ORDER_DATE'			, width:100},
			{ dataIndex: 'STOCK_UNIT'			, width:80, align: 'center'},
			{ dataIndex: 'ALLOC_Q'				, width:100, xtype: 'uniNnumberColumn'},
			{ dataIndex: 'PAB_STOCK_Q'			, width:100, hidden: bExchgRegYN, xtype: 'uniNnumberColumn'},
			{ dataIndex: 'SHORTAGE_Q'			, width:100, hidden: bExchgRegYN, xtype: 'uniNnumberColumn'},
//			{ dataIndex: 'EXCHG_EXIST_YN'		, width:120, hidden: bExchgRegYN, align: 'center'},
//			{ dataIndex: 'REF_ITEM_CODE'		, width:106, hidden: bExchgRegYN},
//			{ dataIndex: 'REF_ITEM_NAME'		, width:133, hidden: bExchgRegYN},
//			{ dataIndex: 'EXCHG_YN'				, width:66, hidden: bExchgRegYN},
			{ dataIndex: 'OUTSTOCK_Q'			, width:100, xtype: 'uniNnumberColumn'},
			{ dataIndex: 'UNIT_Q'				, width:100, xtype: 'uniNnumberColumn'},
			{ dataIndex: 'LOSS_RATE'			, width:100},
			{ dataIndex: 'CONTROL_STATUS'		, width:100, align: 'center'},
			{ dataIndex: 'GRANT_TYPE'			, width:80, hidden:true},
			{ dataIndex: 'OUT_DIV_CODE'			, width:80},
			{ dataIndex: 'OUT_DATE'				, width:100},
			{ dataIndex: 'REMARK'				, width:170},
			{ dataIndex: 'PROJECT_NO'			, width:120},
			{ dataIndex: 'NEED_Q'				, width:133, hidden:true},
			{ dataIndex: 'INOUT_Q'				, width:100, hidden:true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
					if(UniUtils.indexOf(e.field, ['ALLOC_Q', 'CONTROL_STATUS', 'REMARK', 'PROJECT_NO', 'UNIT_Q', 'OUT_DIV_CODE', 'OUT_DATE']))
					{
						return true;
					} else {
						return false;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['SEQ', 'ITEM_CODE', 'ITEM_NAME', 'ALLOC_Q', 'UNIT_Q',
												  'LOSS_RATE', 'CONTROL_STATUS', 'REMARK', 'PROJECT_NO','OUT_DIV_CODE', 'OUT_DATE']))
					{
						return true;
					} else {
						return false;
					}
				}
			}
		},
		setItemData: function(record, dataClear) {
			var grdRecord = this.getSelectedRecord();
			if(dataClear) {
				grdRecord.set('ITEM_CODE'	, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'	, record['ITEM_NAME']);
				grdRecord.set('SPEC'		, record['SPEC']);
				grdRecord.set('STOCK_UNIT'	, record['STOCK_UNIT']);
			} else {
				grdRecord.set('ITEM_CODE'	, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'	, record['ITEM_NAME']);
				grdRecord.set('SPEC'		, record['SPEC']);
				grdRecord.set('STOCK_UNIT'	, record['STOCK_UNIT']);
			}
		},
		setReplaceItemData: function(record) {
			var grdRecord = this.getSelectedRecord();
			var seq = directMasterStore2.max('SEQ');
			if(!seq) seq = 1;
			else  seq += 1;
			grdRecord.set('COMP_CODE'			, record['COMP_CODE']	  );
			grdRecord.set('DIV_CODE'			, record['DIV_CODE']	   );
			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']	);
			grdRecord.set('ORDER_ITEM_CODE'		, record['ORDER_ITEM_CODE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']	  );
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']	  );
			grdRecord.set('SEQ'					, seq					  );
			grdRecord.set('PATH_CODE'			, record['PATH_CODE']	  );
			grdRecord.set('ORDER_DATE'			, record['ORDER_DATE']	 );
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']	 );
			grdRecord.set('ALLOC_Q'				, record['ALLOC_Q']		);
			grdRecord.set('PAB_STOCK_Q'			, record['PAB_STOCK_Q']	);
			grdRecord.set('SHORTAGE_Q'			, record['SHORTAGE_Q']	 );
			grdRecord.set('OUTSTOCK_Q'			, record['OUTSTOCK_Q']	 );
			grdRecord.set('LOSS_RATE'			, record['LOSS_RATE']	  );
			grdRecord.set('CONTROL_STATUS'		, record['CONTROL_STATUS'] );
			grdRecord.set('GRANT_TYPE'			, record['GRANT_TYPE']	 );
			grdRecord.set('REMARK'				, record['REMARK']		 );
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']	 );
			grdRecord.set('NEED_Q'				, record['NEED_Q']		 );
			grdRecord.set('INOUT_Q'				, record['INOUT_Q']		);
			grdRecord.set('ITEM_CODE'			, record['EXCHG_ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['EXCHG_ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']		   );
			grdRecord.set('UNIT_Q'				, record['UNIT_Q']		 );
			grdRecord.set('ALLOC_Q'				, record['ALLOC_Q']		);
			grdRecord.set('OUT_ALLOC_Q'			, record['OUT_ALLOC_Q']	);
		}
	});

	/**
	 * 대체품목를 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//대체품목 참조 폼 정의
	var replaceItemSearch = Unilite.createSearchForm('str103ukrvreplaceItemForm', {
		layout :  {type : 'uniTable', columns : 1},
		items :[{
			xtype: 'uniTextfield',
			fieldLabel: '<t:message code="system.label.purchase.originpoqty" default="원발주량"/>',
			name: 'ORIGIN_ORDER_Q',
			readOnly: true
	   },{
			xtype: 'uniTextfield',
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			readOnly: true
	   },{
			xtype: 'uniTextfield',
			fieldLabel: '<t:message code="system.label.purchase.parentitemcode" default="모품목코드"/>',
			name: 'PROD_ITEM_CODE',
			readOnly: true
	   },{
			xtype: 'uniTextfield',
			fieldLabel: '<t:message code="system.label.purchase.childitemcode" default="자품목코드"/>',
			name: 'CHILD_ITEM_CODE',
			readOnly: true
	   }/*,{
			xtype: 'uniTextfield',
			fieldLabel: '대체품목코드',
			name: 'EXCHG_ITEM_CODE',
			readOnly: true
	   }*/]
	});
	//대체품목 참조 모델 정의
	Unilite.defineModel('str103ukrvReplaceItemModel', {
		fields: [
				 //HIDDEN 자식아이템 정보
				{name: 'COMP_CODE'		  ,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		   ,type: 'string', defaultValue: UserInfo.compCode},
				{name: 'DIV_CODE'		   ,text: '<t:message code="system.label.purchase.division" default="사업장"/>'			,type: 'string'},
				{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>'			,type: 'string'},
				{name: 'ORDER_ITEM_CODE'	,text: '<t:message code="system.label.purchase.poitemcode" default="발주품목코드"/>'		   ,type: 'string'},
				{name: 'ORDER_NUM'		  ,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'		   ,type: 'string'},
				{name: 'ORDER_SEQ'		  ,text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'		   ,type: 'int'},
				{name: 'SEQ'				,text: '<t:message code="system.label.purchase.seq" default="순번"/>'			 ,type: 'int', allowBlank: false},
				{name: 'PATH_CODE'		  ,text: '<t:message code="system.label.purchase.bomcomppathcode" default="BOM구성경로코드"/>'  ,type: 'string'},
				{name: 'ORDER_DATE'		 ,text: '<t:message code="system.label.purchase.allocationdate" default="예약일"/>'			,type: 'uniDate'},
				{name: 'STOCK_UNIT'		 ,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		   ,type: 'string', comboType: 'AU', comboCode: 'B013', displayField: 'value'},
				{name: 'ALLOC_Q'			,text: '<t:message code="system.label.purchase.allocationqty" default="예약량"/>'			,type: 'float', allowBlank: false, decimalPrecision: 6, format:'0,000.000000'},
				{name: 'PAB_STOCK_Q'		,text: '<t:message code="system.label.purchase.availableinventoryqty" default="가용재고량"/>'	  ,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
				{name: 'SHORTAGE_Q'		 ,text: '<t:message code="system.label.purchase.shortageqty" default="부족수량"/>'		   ,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
				{name: 'OUTSTOCK_Q'		 ,text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'			,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
				{name: 'LOSS_RATE'		  ,text: '<t:message code="system.label.purchase.lossrate" default="Loss율"/>'		  ,type: 'uniPercent'},
				{name: 'CONTROL_STATUS'	 ,text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'		   ,type: 'string', comboType:'AU', comboCode:'M010', allowBlank: false},
				{name: 'GRANT_TYPE'		 ,text: '<t:message code="system.label.purchase.subcontractdivision" default="사급구분"/>'		   ,type: 'string'},
				{name: 'REMARK'			 ,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			 ,type: 'string'},
				{name: 'PROJECT_NO'		 ,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		,type: 'string'},
				{name: 'NEED_Q'			 ,text: '<t:message code="system.label.purchase.needqty" default="필요수량"/>'		   ,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
				{name: 'INOUT_Q'			,text: '<t:message code="system.label.purchase.tranqty" default="수불량"/>'		   ,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
				//HIDDEN

				//SHOW 대체아이템 정보
				{name: 'EXCHG_ITEM_CODE'	,text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		   ,type : 'string' },
				{name: 'EXCHG_ITEM_NAME'	,text:'<t:message code="system.label.purchase.itemname" default="품목명"/>'			,type : 'string' },
				{name: 'SPEC'			   ,text:'<t:message code="system.label.purchase.spec" default="규격"/>'			  ,type : 'string' },
				{name: 'UNIT_Q'			 ,text:'<t:message code="system.label.purchase.originunitqty" default="원단위량"/>'		   ,type : 'float', decimalPrecision: 6, format:'0,000.000000' },
				{name: 'ALLOC_Q'			,text:'<t:message code="system.label.purchase.calculationallocationqty" default="계산예약량"/>'		  ,type : 'float', decimalPrecision: 6, format:'0,000.000000' },
				{name: 'OUT_ALLOC_Q'		,text:'<t:message code="system.label.purchase.issuereservedqty" default="출고예약량"/>'		  ,type : 'float', decimalPrecision: 6, format:'0,000.000000' }
				//SHOW
		]
	});

	//대체품목 참조 스토어 정의
	var replaceItemStore = Unilite.createStore('str103ukrvReplaceItemStore', {
			model: 'str103ukrvReplaceItemModel',
			autoLoad: false,
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false		 // prev | newxt 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read	: 's_otr100ukrv_shService.selectReplaceItemList'
				}
			}

			,loadStoreRecords : function()  {
				var param = masterGrid2.getSelectedRecord().data;
				param.ORDER_UNIT_Q = masterGrid1.getSelectedRecord().get('ORDER_UNIT_Q');
				param.ORDER_DATE = UniDate.getDbDateStr(param.ORDER_DATE);
				console.log( param );
				this.load({
					params : param
				});
			},
			listeners:{
				load:function(store, records, successful, eOpts)	{

				}
			}
	});
	//대체품목 참조 그리드 정의
	var replaceItemGrid = Unilite.createGrid('str103ukrvreplaceItemGrid', {
		// title: '기본',
		layout : 'fit',
		store: replaceItemStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false, mode: 'SIMPLE' }),
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns:  [
				   { dataIndex: 'COMP_CODE'		  ,  width: 100, hidden: true },
				   { dataIndex: 'DIV_CODE'		   ,  width: 100, hidden: true },
				   { dataIndex: 'CUSTOM_CODE'		,  width: 100, hidden: true },
				   { dataIndex: 'ORDER_ITEM_CODE'	,  width: 100, hidden: true },
				   { dataIndex: 'ORDER_NUM'		  ,  width: 100, hidden: true },
				   { dataIndex: 'ORDER_SEQ'		  ,  width: 100, hidden: true },
				   { dataIndex: 'SEQ'				,  width: 100, hidden: true },
				   { dataIndex: 'PATH_CODE'		  ,  width: 100, hidden: true },
				   { dataIndex: 'ORDER_DATE'		 ,  width: 100, hidden: true },
				   { dataIndex: 'STOCK_UNIT'		 ,  width: 100, hidden: true },
				   { dataIndex: 'ALLOC_Q'			,  width: 100, hidden: true },
				   { dataIndex: 'PAB_STOCK_Q'		,  width: 100, hidden: true, xtype: 'uniNnumberColumn' },
				   { dataIndex: 'SHORTAGE_Q'		 ,  width: 100, hidden: true, xtype: 'uniNnumberColumn' },
				   { dataIndex: 'OUTSTOCK_Q'		 ,  width: 100, hidden: true, xtype: 'uniNnumberColumn' },
				   { dataIndex: 'LOSS_RATE'		  ,  width: 100, hidden: true },
				   { dataIndex: 'CONTROL_STATUS'	 ,  width: 100, hidden: true },
				   { dataIndex: 'GRANT_TYPE'		 ,  width: 100, hidden: true },
				   { dataIndex: 'REMARK'			 ,  width: 100, hidden: true },
				   { dataIndex: 'PROJECT_NO'		 ,  width: 100, hidden: true },
				   { dataIndex: 'NEED_Q'			 ,  width: 100, hidden: true, xtype: 'uniNnumberColumn' },
				   { dataIndex: 'INOUT_Q'			,  width: 100, hidden: true, xtype: 'uniNnumberColumn' },


				   { dataIndex: 'EXCHG_ITEM_CODE'				 ,  width: 100 },
				   { dataIndex: 'EXCHG_ITEM_NAME'				 ,  width: 180 },
				   { dataIndex: 'SPEC'							,  width: 120 },
				   { dataIndex: 'UNIT_Q'						  ,  width: 100, xtype: 'uniNnumberColumn' },
				   { dataIndex: 'ALLOC_Q'						 ,  width: 100, xtype: 'uniNnumberColumn' },
				   { dataIndex: 'OUT_ALLOC_Q'					 ,  width: 100, xtype: 'uniNnumberColumn' }
		  ]
	   ,listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {

			}
		}
		,returnData: function() {
			var records = this.getSelectedRecords();
			masterGrid2.deleteSelectedRow();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid2.setReplaceItemData(record.data);
			});
			this.deleteSelectedRow();
//			directMasterStore1.fnOrderAmtSum();
		}

	});

	//대체품목 참조 메인
	function openReplaceItemWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!refferReplaceItemWindow) {
			refferReplaceItemWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.subitem" default="대체품목"/>',
				width: 830,
				height: 580,
				hidden: true,
				layout:{type:'vbox', align:'stretch'},

				items: [/*replaceItemSearch*/ replaceItemGrid],
				tbar:  ['->',
										{   itemId : 'saveBtn',
											text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
											handler: function() {
												replaceItemStore.loadStoreRecords();
											},
											disabled: false
										},
										{   itemId : 'confirmBtn',
											text: '<t:message code="system.label.purchase.apply" default="적용"/>',
											handler: function() {
												replaceItemGrid.returnData();
											},
											disabled: false
										},
										{   itemId : 'confirmCloseBtn',
											text: '<t:message code="system.label.purchase.afterapplyclose" default="적용 후 닫기"/>',
											handler: function() {
												replaceItemGrid.returnData();
												refferReplaceItemWindow.hide();
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											text: '<t:message code="system.label.purchase.close" default="닫기"/>',
											handler: function() {
												if(directMasterStore1.getCount() == 0){
													masterForm.setAllFieldsReadOnly(false);
													panelResult.setAllFieldsReadOnly(false);
												}
												refferReplaceItemWindow.hide();
											},
											disabled: false
										}
								]
							,
				listeners : {beforehide: function(me, eOpt) {
											//replaceItemSearch.clearForm();
											//replaceItemGrid.reset();
										},
							 beforeclose: function( panel, eOpts )  {
											//replaceItemSearch.clearForm();
											//replaceItemGrid.reset();
										},
							  beforeshow: function ( me, eOpts )	{
								var masterRecord = masterGrid1.getSelectedRecord();
								var detailRecord = masterGrid2.getSelectedRecord();
								replaceItemSearch.setValue('ORIGIN_ORDER_Q',masterRecord.get('ORDER_UNIT_Q'));
								replaceItemSearch.setValue('DIV_CODE',detailRecord.get('DIV_CODE'));
								replaceItemSearch.setValue('PROD_ITEM_CODE',detailRecord.get('ORDER_ITEM_CODE'));
								replaceItemSearch.setValue('CHILD_ITEM_CODE',detailRecord.get('ITEM_CODE'));
//								replaceItemSearch.setValue('EXCHG_ITEM_CODE',detailRecord.get('EXCHG_ITEM_CODE'));
								replaceItemStore.loadStoreRecords();
							 }
				}
			})
		}
		refferReplaceItemWindow.center();
		refferReplaceItemWindow.show();
	}
	Unilite.Main( {
		borderItems:[{
				layout: {type: 'vbox', align: 'stretch'},
				region: 'center',
				items: [panelResult, masterGrid1/*,{xtype: 'splitter'}*/, masterGrid2]
			},
			masterForm
		],
		id  : 's_otr100ukrv_shApp',
		fnInitBinding : function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			this.setDefault();
			masterForm.setValue('ORDER_PRSN',BsaCodeInfo.gsOrderPrsn);
			panelResult.setValue('ORDER_PRSN',BsaCodeInfo.gsOrderPrsn);

		},
		onQueryButtonDown : function()  {   // 조회버튼 눌렀을때
			if(masterForm.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid1.getStore().loadStoreRecords();
			panelResult.setAllFieldsReadOnly(true);
			beforeRowIndex = -1;

			UniAppManager.setToolbarButtons('newData', true);
		},

		setDefault: function() {		// 기본값
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('FR_ORDER_DATE', UniDate.get('startOfMonth'));
			masterForm.setValue('TO_ORDER_DATE', UniDate.get('today'));
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('FR_ORDER_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('TO_ORDER_DATE', UniDate.get('today'));
			UniAppManager.setToolbarButtons('save', false);
		},

		onResetButtonDown: function() {	 // 초기화
			this.suspendEvents();
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid1.reset();
			masterGrid2.reset();
			this.fnInitBinding();
			masterForm.getField('CUSTOM_CODE').focus();
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore2.saveStore();
		},
		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			var selRow1 = masterGrid2.getSelectedRecord();
			if(selRow1.phantom === true)	{
				masterGrid2.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid2.deleteSelectedRow();
			}
		},

		onNewDataButtonDown: function() {	   // 행추가
			if(!this.checkForNewDetail()) return false;

			//외주입고시 체크방법
//		  if(BsaCodeInfo.gsCheckMath =='1') {
//			  alert(Msg.fStMsgS0101);//외주출고량 체크방법이 [외주 발주량 기준]일 경우 추가할 수 없습니다. 대체품목으로 등록하십시오.
//			  return false;
//		  }

			var controlStat = masterGrid1.getSelectedRecord().get('CONTROL_STATUS');
			var selectedRecord = masterGrid2.getSelectedRecord();
			if(Ext.isEmpty(controlStat)){
				alert('<t:message code="system.message.purchase.message037" default="발주정보가 선택되지 않았습니다."/>');
				return false;
			}else if(controlStat > '1'){
				alert(Msg.fStMsgS0102); //진행상태가 발주중인것 만 추가할 수 있습니다. 진행상태를확인하십시요.
				return false;
			}
			var orderNum = masterForm.getValue('ORDER_NUM');
			var orderSeq = masterForm.getValue('ORDER_SEQ');
			var seq = directMasterStore2.max('SEQ');
			if(!seq) seq = 1;
			else  seq += 1;
			var divCode = masterForm.getValue('DIV_CODE');
			var customCode = masterForm.getValue('CUSTOM_CODE');
			var orderItemCode = masterForm.getValue('ITEM_CODE');
			var orderDate = masterForm.getValue('ORDER_DATE');
			var controlStatus = '1';
			var allocQ = masterForm.getValue('ORDER_Q');
			var needQ = masterForm.getValue('ORDER_Q');
			var pabStockQ = '0';
			var shortageQ = '0';
			var exchgExistYn = 'N';
			var exchgYn = 'N';
			var unitQ = '1';
			var lossRate = '0';
			var outstockQ = '0';
			var controlStatus ='1';
			var grantType = '2';
			var Remark = masterForm.getValue('REMARK');
			var projectNo = masterForm.getValue('PROJECT_NO');

			var selItemCode = selectedRecord.get('ITEM_CODE');
			var outDate = selectedRecord.get('OUT_DATE');
			var outDivCode = selectedRecord.get('OUT_DIV_CODE');
			var itemName = selectedRecord.get('ITEM_NAME');
			var spec = selectedRecord.get('SPEC');
			var stockUnit = selectedRecord.get('STOCK_UNIT');

			var r = {
				ORDER_NUM: orderNum,
				ORDER_SEQ: orderSeq,
				COMP_CODE: UserInfo.compCode,
				DIV_CODE: divCode,
				CUSTOM_CODE: customCode,
				ORDER_ITEM_CODE: orderItemCode,
				ORDER_DATE: orderDate,
				SEQ: seq,
				ALLOC_Q: 0,
				NEED_Q: needQ,
				PAB_STOCK_Q: pabStockQ,
				SHORTAGE_Q: shortageQ,
				EXCHG_EXIST_YN: exchgExistYn,
				EXCHG_YN: exchgYn,
				UNIT_Q: unitQ,
				LOSS_RATE: lossRate,
				OUTSTOCK_Q: outstockQ,
				CONTROL_STATUS: controlStatus,
				GRANT_TYPE: grantType,
				REMARK: Remark,
				PROJECT_NO: projectNo,
				OUT_SEQ: seq,
				ITEM_CODE: selItemCode,
				OUT_DATE : outDate,
				OUT_DIV_CODE : outDivCode,
				SPEC: spec,
				ITEM_NAME: itemName,
				STOCK_UNIT: stockUnit
			};
			masterGrid2.createRow(r, 'ITEM_CODE', seq-2);  //행 생성시 default값 세팅 및 포커스 지정
			masterForm.setAllFieldsReadOnly(true);
		},

		checkForNewDetail: function() {
			if(directMasterStore1.getCount() < 1)   {
				alert('<t:message code="system.message.purchase.message038" default="조회된 발주정보가 없습니다."/>');
				return false;
			}
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('ORDER_NUM')))	{
				alert('<t:message code="unilite.msg.sMS990" default="발주번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}
			return masterForm.setAllFieldsReadOnly(true);
		 },

		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())   {
				as.show();
			}else {
				as.hide()
			}
		}
	});

	Unilite.createValidator('validator01', {
		store: directMasterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "SEQ" :	// 순번
					if(newValue <= 0) {
						rv= '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
				break;

				case "UNIT_Q" : // 원단위량
					if(newValue <= '0') {
						rv= '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					var mRecord = masterGrid1.getSelectedRecord();
					record.set('ALLOC_Q',(newValue * mRecord.get('ORDER_Q') * ('1' + (record.get('LOSS_RATE') / 100))));
					record.set('NEED_Q',(newValue * mRecord.get('ORDER_Q') * ('1' + (record.get('LOSS_RATE') / 100))));
				break;

				case "LOSS_RATE" : // Loss율
					if(newValue < '0') {
						rv= '<t:message code="system.message.purchase.message039" default="Loss율은 0보다 커야 합니다."/>';
						break;
					}
					if(newValue > '50') {
						rv= '<t:message code="system.message.purchase.message040" default="50이하의 양수만 입력가능합니다."/>';
						break;
					}
					record.set('ALLOC_Q',(record.get('UNIT_Q') * record.get('ORDER_Q') * ('1' + (record.get('LOSS_RATE') / 100))));
					record.set('NEED_Q',(record.get('UNIT_Q') * record.get('ORDER_Q') * ('1' + (record.get('LOSS_RATE') / 100))));
				break;

				case "ALLOC_Q" : // 예약량(재고단위)
					if(newValue <= '0') {
						rv= '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					if(record.get('ALLOC_Q') < record.get('OUTSTOCK_Q')) {
						rv= '<t:message code="system.message.purchase.message041" default="예약량은 출고량보다 작을 수 없습니다."/>';
						break;
					}
				break;

				case "CONTROL_STATUS" : // 진행상태
					if (!(newValue < '2' || newValue == '9' )) {
						rv= '<t:message code="system.message.purchase.message035" default="선택할 수 없는 코드입니다."/>'
						break;
					}
				break;
			}
			return rv;
		}
	});
};
</script>