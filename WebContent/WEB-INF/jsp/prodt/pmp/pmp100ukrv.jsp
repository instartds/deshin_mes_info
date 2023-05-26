<%--
'	프로그램명 : 일괄제조오더등록 (생산)
'
'	작	성	자 : (주)포렌 개발실
'	작	성	일 :
'
'	최종수정자 :
'	최종수정일 :
'
'	버		전 : OMEGA Plus V6.0.0
--%>


<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp100ukrv"	>
	<t:ExtComboStore comboType="BOR120" pgmId="pmp100ukrv" />			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />		<!-- 작업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"	/>				<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B014"	/>				<!-- 조달구분 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore comboType="WU"/> <!-- 작업장 (사용여부)-->
	<t:ExtComboStore comboType="AU" comboCode="P506"	/>				<!-- 작업호기 -->
	<t:ExtComboStore comboType="AU" comboCode="P507"	/>				<!-- 주야구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A" />					<!-- 가공창고 -->
	<t:ExtComboStore comboType="AU" comboCode="P510"	/>				<!-- 등록자 -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var searchInfoWindow;	// searchInfoWindow : 조회창
var referProductionPlanWindow;	// 생산계획참조
var refWindow;	// 생산계획참조
var sWkordNum;
var sAutoLotNo;
var sTopWkordNum;
var workShopCodeCount = 1;
var BsaCodeInfo = {
	gsUseWorkColumnYn	: '${gsUseWorkColumnYn}',	//작업 관련컬럼(작업자, 작업호기, 작업시간, 주야구분) 사용여부
	gsAutoType			: '${gsAutoType}',			// "P005"	'생산자동채번여부
	gsChildStockPopYN	: '${gsChildStockPopYN}',	//'자재부족수량 팝업 호출여부
	gsShowBtnReserveYN	: '${gsShowBtnReserveYN}',	//'BOM PATH 관리여부
	gsManageLotNoYN		: '${gsManageLotNoYN}',		//'재고와 작업지시LOT 연계여부

	grsManageLotNo		: '${grsManageLotNo}',		// LOT 연계여부
	gsLotNoInputMethod	: '${gsLotNoInputMethod}',	// grsManageLotNo(0)
	gsLotNoEssential	: '${gsLotNoEssential}',	// grsManageLotNo(1)
	gsEssItemAccount	: '${gsEssItemAccount}',	// grsManageLotNo(2)
	gsReportGubun		: '${gsReportGubun}',		//레포트 구분
	gsCompName			: '${gsCompName}'			//출력 관련해서 제이월드 report만 따로 사용... 하기 위해 comp_name 가져오는 로직
};
var gsRowIndex = 0 ;
var gsSeqNo = 0;
function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmp100ukrvService.selectDetailList',
			update: 'pmp100ukrvService.updateDetail',
			create: 'pmp100ukrvService.insertDetail',
			destroy: 'pmp100ukrvService.deleteDetail',
			syncAll: 'pmp100ukrvService.saveAll'
		}
	});



	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden: false,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},//,tableAttrs:{width:'100%'}
		padding:'1 1 1 1',
		border:true,
			items: [{
				xtype: 'uniTextfield',
				name: 'WK_PLAN_NUM',
				hidden: true
			},{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name: 'DIV_CODE',
				value : UserInfo.divCode,
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				holdable: 'hold',
				width: 230,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', '');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType:'WU',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						store.clearFilter();

						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == panelResult.getValue('DIV_CODE');
							});
						} else{
							store.filterBy(function(record){
								return false;
							});
						}
					}
				}
			},{
				xtype: 'container',
				layout:{type:'uniTable',columns:5},
				colspan:1,
				items:[{
					xtype:'button',
					text:'<t:message code="system.label.product.productionplanreference" default="생산계획참조"/>',
					itemId:'btnWorkPlan',
					handler: function(){
						openProductionPlanWindow();
					}
				},{
					xtype:'button',
					margin: '0 0 0 2',
					text:'<t:message code="system.label.product.wholeworkorderrelease" default="일괄작지전개"/>',
					itemId:'btnExp',
					handler: function(){
						UniAppManager.app.onQueryButtonDown();
					}
				},{
					xtype:'button',
					text:'<t:message code="system.label.product.workorderpartpopup" default="작지분할팝업"/>',
					disabled:true,
					itemId:'btnPart',
					margin: '0 0 0 4',
					handler: function(){
						openRefWindow();
					}
				},
//				{
//					xtype:'button',
//					text:"자재예약경로조회",
//					disabled:true,
//					itemId:'btnReserve',
//
//					margin: '0 0 0 6',
//					handler: function(){
//
//
//					}
//				},
				{
					xtype:'button',
					text:'<t:message code="system.label.product.mfgorderprint" default="제조지시서출력"/>',
					disabled:true,
					itemId:'btnPrint',
					margin: '0 0 0 6',
					handler: function(){
						if(!panelResult.getInvalidMessage()) return;	//필수체크

						if(Ext.isEmpty(sTopWkordNum)){
							Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
							return;
						}

						var param = panelResult.getValues();

						param["printGubun"] = '1';
						param["USER_LANG"] = UserInfo.userLang;

						param["sTxtValue2_fileTitle"]='작업지시서';
						param["PGM_ID"]= PGM_ID;
						param["MAIN_CODE"] = 'P010';	//생산용 공통 코드
//						if(BsaCodeInfo.gsCompName == '(주)제이월드'){
//							param["DEPT_NAME"] = '1';
//						} else{
//							param["DEPT_NAME"] = '0';
//						}
						var win = null;
						if(BsaCodeInfo.gsReportGubun == 'CLIP'){
							if(BsaCodeInfo.gsCompName == '(주)제이월드'){
							   param["DEPT_NAME"] = '1';

								param["WKORD_NUM"] = sTopWkordNum;
								param["TOP_WKORD_NUM"] = sTopWkordNum;
								win = Ext.create('widget.ClipReport', {
									url: CPATH+'/prodt/pmp100clrkrv.do',
									prgID: 'pmp100ukrv',
									extParam: param
								});

								win.center();
								win.show();
							}else{
								var wkordNumList;
								Ext.each(detailStore.data.items, function(record, idx) {
									if(idx ==0) {
										wkordNumList= record.get("WKORD_NUM");
									} else {
										wkordNumList= wkordNumList	+ ',' + record.get("WKORD_NUM");
									}

								});

								param["DEPT_NAME"] = '0';

								param["WKORD_NUM"] = wkordNumList;
								param["dataCount"] = detailStore.data.items.length;

					        	win = Ext.create('widget.ClipReport', {
					                url: CPATH+'/prodt/pmp190clrkrv.do',
					                prgID: 'pmp190skrv',
					                extParam: param
					            });
								win.center();
								win.show();

							}

						}else if(BsaCodeInfo.gsReportGubun == 'EXCEL'){
							//노비스바이오에서는 EXCEL에 해당값들 SET 하는 방식 사용
							var itemCode = '';
							Ext.each(detailStore.data.items, function(record, idx) {
								if(record.get('WKORD_NUM') == sTopWkordNum){
									itemCode = record.get('ITEM_CODE');
								}
							});

							var p = {
								ITEM_CODE : itemCode,
								MAIN_CODE : 'P010',
								PGM_ID : PGM_ID
							};
							pmp100ukrvService.selectExcelFile(p, function(provider, response){
								if(!Ext.isEmpty(provider)){
									if(provider.FILE_ID != ''){
			                			window.open(CPATH + '/prodt/pmp100rkrvExcelDown.do?DIV_CODE=' + panelResult.getValue('DIV_CODE')  + '&' + 'TOP_WKORD_NUM=' + sTopWkordNum + '&' + 'FILE_ID=' + provider.FILE_ID + '&' + 'FILE_PATH=' + provider.FILE_PATH + '&' + 'FILE_EXT=' + provider.FILE_EXT + '&' + 'GUBUN=' + provider.GUBUN , "_self");
									}else{
										Unilite.messageBox('해당 품목에 대한 파일이 없습니다.');
									}
								}else{
									Unilite.messageBox('해당 품목에 대한 파일이 없습니다.');
								}
							})
						}else{
							param["sTopWkordNum"] = sTopWkordNum;
							win = Ext.create('widget.CrystalReport', {
								url: CPATH+'/prodt/pmp100crkrv.do',
								extParam: param
							});
							win.center();
							win.show();
						}



					}
				},{
					xtype:'button',
					text:'<t:message code="system.label.product.issuerequestprint" default="출고요청서출력"/>',
					disabled:true,
					itemId:'btnPrint2',
					margin: '0 0 0 8',
					handler: function(){
						if(!panelResult.getInvalidMessage()) return;	//필수체크

						if(Ext.isEmpty(sTopWkordNum)){
							Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
							return;
						}

						var param = panelResult.getValues();

						param["printGubun"] = '2';
						param["USER_LANG"] = UserInfo.userLang;

						param["sTxtValue2_fileTitle"]='자재출고요청서';
						param["PGM_ID"]= PGM_ID;
						param["MAIN_CODE"] = 'P010';	//생산용 공통 코드
						if(BsaCodeInfo.gsCompName == '(주)제이월드'){
							param["DEPT_NAME"] = '1';
						} else{
							param["DEPT_NAME"] = '0';
						}
						var win = null;
						if(BsaCodeInfo.gsReportGubun == 'CLIP'){
							param["WKORD_NUM"] = sTopWkordNum;
							win = Ext.create('widget.ClipReport', {
								url: CPATH+'/prodt/pmp100clrkrv.do',
								prgID: 'pmp100ukrv',
								extParam: param
							});
						} else{
							param["sTopWkordNum"] = sTopWkordNum;
							win = Ext.create('widget.CrystalReport', {
								url: CPATH+'/prodt/pmp100crkrv.do',
								extParam: param
							});
						}
						win.center();
						win.show();
					}
				}]
			},{
				xtype: 'container',
				layout: { type: 'uniTable', columns: 3},
				defaultType: 'uniTextfield',
				defaults : {enforceMaxLength: true},
				colspan:2,
				items:[
					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
						valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						holdable: 'hold',
						allowBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('SPEC',records[0]["SPEC"]);
									panelResult.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);
									panelResult.getField('PRODT_DATE').focus();
									panelResult.getField('PRODT_DATE').blur();
								},
								scope: this
							},
							onClear: function(type) {
								panelResult.setValue('SPEC','');
								panelResult.setValue('PROG_UNIT','');

							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
						}
				}),{
					name:'SPEC',
					xtype:'uniTextfield',
					readOnly:true,
					holdable: 'hold'
				}]
			},{
				xtype:'container',
				layout: {type: 'uniTable', columns: 1},
				rowspan:4,
				border:true,
				defaultType: 'uniTextfield',
				items: [{
					xtype:'label',
					html:'<div style="color:#0033CC;font-weight: bold">[ '+'<t:message code="system.label.product.reference2" default="참고사항"/>'+' ]</div>'

				},{
					fieldLabel: '<t:message code="system.label.product.sono" default="수주번호"/>',
					xtype: 'uniTextfield',
					name: 'ORDER_NUM',
					readOnly: true
				},{
					fieldLabel: 'ORDER_SEQ',
					xtype: 'uniTextfield',
					name: 'ORDER_SEQ',
					hidden: true,
					readOnly : true
				},{
					fieldLabel: '<t:message code="system.label.product.soqty" default="수주량"/>',
					xtype: 'uniTextfield',
					name: 'ORDER_Q',
					xtype: 'uniNumberfield',
					decimalPrecision:0,
					readOnly: true
				},{
					fieldLabel: '<t:message code="system.label.product.deliverydate" default="납기일"/>',
					xtype: 'uniDatefield',
					name: 'DVRY_DATE',
					readOnly: true
				},{
					fieldLabel: '<t:message code="system.label.product.custom" default="거래처"/>',
					xtype: 'uniTextfield',
					name: 'CUSTOM_CODE',
					readOnly: true,
					holdable: 'hold',
					//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터) - 저장할 때 한번에 넣도록 로직 수정
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
//							var cgCustom = panelResult.getValue('CUSTOM_CODE');
//							if(Ext.isEmpty(cgCustom)) return false;
//
//							var records = detailStore2.data.items;
//							Ext.each(records, function(record,i){
//								record.set('CUSTOM',cgCustom);
//							});
						}
					}
				}]
			},{
				fieldLabel: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
				xtype: 'uniDatefield',
				value: new Date(),
				name: 'PRODT_WKORD_DATE',
				allowBlank:false,
				holdable: 'hold',
				width: 230,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//20210426 추가: 작업지시일 순서체크로직 추가
						if(Ext.isDate(newValue)) {
							if(!checkDateSeq()) {
								panelResult.setValue('PRODT_WKORD_DATE', '');
								return false;
							}
						}
						var store = detailGrid.getStore();
						Ext.each(store.data.items, function(record, index) {
							record.set('PRODT_WKORD_DATE', newValue);
						});
					}
				}
			},{
				xtype: 'container',
				layout: { type: 'uniTable', columns: 3},
				defaultType: 'uniTextfield',
				defaults : {enforceMaxLength: true},
				colspan:1,
				items:[{
					fieldLabel: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
					xtype: 'uniNumberfield',
					name: 'WKORD_Q',
					value: '0.00',
					holdable: 'hold',
					allowBlank:false
				},{
					name:'PROG_UNIT',
					xtype:'uniTextfield',
					width: 50,
					readOnly:true
				},{
					fieldLabel: '<t:message code="system.label.product.entryuser" default="등록자"/>',
					name: 'WKORD_PRSN',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'P510',
					holdable: 'hold',
					labelWidth:40
				}]
			},{
				fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype: 'uniDatefield',
				value: new Date(),
				name: 'PRODT_START_DATE',
				allowBlank:false,
				holdable: 'hold',
				width: 230,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//20210426 추가: 착수예정일 순서체크로직 추가
						if(Ext.isDate(newValue)) {
							if(!checkDateSeq('2')) {			//20210428 수정: 함수 호출 시 FLAGE값 넘기도록 수정
								panelResult.setValue('PRODT_START_DATE', '');
								return false;
							}
						}
						var store = detailGrid.getStore();
						Ext.each(store.data.items, function(record, index) {
							record.set('PRODT_START_DATE', newValue);
						});
					}
				}
			},{
				xtype: 'container',
				layout: { type: 'uniTable', columns: 3},
				defaultType: 'uniTextfield',
				defaults : {enforceMaxLength: true},
				colspan:1,
				items:[
					Unilite.popup('DIV_PUMOK',{
							fieldLabel: '<t:message code="system.label.product.manageno" default="관리번호"/>',
							valueFieldName: 'TEST_CODE',
							textFieldName: 'TEST_NAME',
							hidden:true,
							holdable: 'hold'
				}),
					Unilite.popup('PROJECT',{
							fieldLabel: '<t:message code="system.label.product.project" default="프로젝트"/>',
							valueFieldName: 'PJT_CODE',
							textFieldName: 'PROJECT_NO',
							holdable: 'hold',
							textFieldWidth: 150
				}),{
					fieldLabel: '<t:message code="system.label.product.makedate" default="제조일자"/>',
					xtype: 'uniDatefield',
					name: 'PRODT_DATE',
	//				holdable: 'hold',
					listeners: {
						//20210426 수정: 필드변경 관련 로직 수정
						focus: function(field, event, eOpts) {
						if(Ext.isEmpty(panelResult.getValue('ITEM_CODE'))){
							alert('작업지시를 할 품목을 입력해주세요.');	//20210423 수정: 메세지 수정 - <t:message code="system.message.product.message064" default="작업지시를 할 품목을 입력해주세요."/> -> 작업지시를 할 품목을 입력해주세요.
							panelResult.getField('ITEM_CODE').focus();
						}
					},
						blur: function(field, The, eOpts){
						//20210426 주석: 필드변경 관련 로직 수정
//						if(!Ext.isEmpty(panelResult.getValue('ITEM_CODE'))){
							if(!Ext.isEmpty(field.getValue()) && Ext.isDate(field.getValue())){
								var param = panelResult.getValues();
								pmp110ukrvService.selectExpirationdate(param, function(provider, response) {
									if(!Ext.isEmpty(provider) && provider.EXPIRATION_DAY != 0)	{
										panelResult.setValue('EXPIRATION_DATE', UniDate.getDbDateStr(UniDate.add(field.getValue(), {months: + provider.EXPIRATION_DAY , days:-1})));
									}else{
										//alert('유효기간을 설정하지 않은 품목입니다. 유효기간을 설정해주세요.');
										panelResult.setValue('EXPIRATION_DATE', '');
									}
								});
							}else{
								panelResult.setValue('PRODT_DATE', panelResult.getValue('PRODT_WKORD_DATE'));
							}
//						}else{
//							alert('작업지시를 할 품목을 입력해주세요.');	//20210423 수정: 메세지 수정 - <t:message code="system.message.product.message064" default="작업지시를 할 품목을 입력해주세요."/> -> 작업지시를 할 품목을 입력해주세요.
//						}
						},
						change: function(field, newValue, oldValue, eOpts) {
						//20210426 추가: 제조일자 순서체크로직 추가
						if(Ext.isDate(newValue)) {
							if(!checkDateSeq()) {
								panelResult.setValue('PRODT_DATE', '');
								return false;
							}
						}
						var store = detailGrid.getStore();
						Ext.each(store.data.items, function(record, index) {
							record.set('PRODT_DATE', newValue);
						});
					  }
					}
				}]
			},{
				fieldLabel: '<t:message code="system.label.product.completiondate" default="완료예정일"/>',
				xtype: 'uniDatefield',
				value: new Date(),
				name: 'PRODT_END_DATE',
				holdable: 'hold',
				allowBlank:false,
				width: 230,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//20210426 추가: 완료예정일 순서체크로직 추가
						if(Ext.isDate(newValue)) {
							if(!checkDateSeq('4')) {			//20210428 수정: 함수 호출 시 FLAGE값 넘기도록 수정
								panelResult.setValue('PRODT_END_DATE', '');
								return false;
							}
						}
						var store = detailGrid.getStore();
						Ext.each(store.data.items, function(record, index) {
							record.set('PRODT_END_DATE', newValue);
						});
					}
				}
			},{
				xtype: 'container',
				layout: { type: 'uniTable', columns: 3},
				defaultType: 'uniTextfield',
				defaults : {enforceMaxLength: true},
				items:[
				Unilite.popup('LOT_NO',{
					fieldLabel: 'LOT_NO',
					valueFieldName: 'LOT_CODE',
					textFieldName: 'LOT_NAME',
					holdable: 'hold',
					validateBlank:false
				}),{
					fieldLabel: '<t:message code="system.label.product.expirationdate" default="유통기한"/>',
					xtype: 'uniDatefield',
					name: 'EXPIRATION_DATE',
					holdable: 'hold',
	//				labelWidth: 400,
	//				holdable: 'hold',
	//				colspan: 3,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						//20210426 추가: 유통기한 순서체크로직 추가
						if(Ext.isDate(newValue)) {
							if(!checkDateSeq()) {
								panelResult.setValue('EXPIRATION_DATE', '');
								return false;
							}
						}
							var store = detailGrid.getStore();
							Ext.each(store.data.items, function(record, index) {
								record.set('EXPIRATION_DATE', newValue);
							});
						}
					}
				}]
			},{
				fieldLabel: '<t:message code="system.label.product.remarks" default="비고"/>',
				xtype: 'textarea',
				width: 720,
				name: 'REMARK',
				holdable: 'hold',
				colspan:4
			}
	/*		{
				xtype: 'container',
				layout: { type: 'uniTable', columns: 2},
				defaultType: 'uniTextfield',
				defaults : {enforceMaxLength: true},
				items:[
				Unilite.popup('LOT_NO',{
					fieldLabel: 'LOT_NO',
					valueFieldName: 'LOT_CODE',
					textFieldName: 'LOT_NAME',
					holdable: 'hold'
				}),{
					fieldLabel: '<t:message code="system.label.product.remarks" default="비고"/>',
					xtype: 'uniTextfield',
					name: 'REMARK',
					holdable: 'hold'
				}]
			}
			*/
		],
		setAllFieldsReadOnly: function(b,c) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {

				} else {
					if(c){
						var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) ) {
								if (item.holdable == 'hold') {
									item.setReadOnly(true);
									//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터)
									if(Ext.isEmpty(panelResult.getValue('ORDER_NUM'))) {
										panelResult.getField('CUSTOM_CODE').setReadOnly( false );
									} else {
										panelResult.getField('CUSTOM_CODE').setReadOnly( true );
									}
								}
							}
							if(item.isPopupField) {
								var popupFC = item.up('uniPopupField')	;
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})
					}
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
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



	/** Model 정의
	 *
	 * @type
	 */
	Unilite.defineModel('pmp100ukrvDetailModel', {
		fields: [
			{name: 'GUBUN'				,text: '<t:message code="system.label.product.selection" default="선택"/>'					,type:'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'					,type:'string',comboType: 'BOR120'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'					,type:'string',comboType:'WU'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'							,type:'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'					,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'							,type:'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>'							,type:'string'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'			,type:'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'			,type:'uniDate'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'				,type:'uniQty'},
			//20180705(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
			{name: 'PRODT_PRSN'			,text: '<t:message code="system.label.product.worker" default="작업자"/>'						,type:'string',comboType:'AU',comboCode:'P505'},
			{name: 'PRODT_MACH'			,text: '<t:message code="system.label.product.Workingmachine" default="작업호기"/>'				,type:'string'	,comboType:'AU',comboCode:'P506'},
			{name: 'PRODT_TIME'			,text: '<t:message code="system.label.product.workhour" default="작업시간"/>'					,type:'string'},
			{name: 'DAY_NIGHT'			,text: '<t:message code="system.label.product.daynightclass" default="주야구분"/>'				,type:'string'	,comboType:'AU',comboCode:'P507'},

			{name: 'SUPPLY_TYPE'		,text: '<t:message code="system.label.product.procurementclassification" default="조달구분"/>'	,type:'string',comboType:'AU',comboCode:'B014'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'				,type:'string'},
			{name: 'WK_PLAN_NUM'		,text: '<t:message code="system.label.product.productionplanno" default="생산계획번호"/>'	 		,type:'string'},
			{name: 'PRODUCT_LDTIME'		,text: '<t:message code="system.label.product.mfglt" default="제조 L/T"/>'						,type:'string'},
			{name: 'SEQ_NO'				,text: '<t:message code="system.label.product.number" default="번호"/>'						,type:'uniQty'},
			{name: 'REF_GUBUN'			,text: '<t:message code="system.label.product.applyclass" default="반영구분"/>'					,type:'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				,type:'string'},
			{name: 'PJT_CODE'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				,type:'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.product.remarks" default="비고"/>'						,type:'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'						,type:'string'},
			{name: 'CHECK_YN'			,text: '<t:message code="system.label.product.selectyn" default="선택여부"/>'					,type:'string'}
		]
	});

	Unilite.defineModel('pmp100ukrvDetailModel2', {
		fields: [
			{name: 'LINE_SEQ'			,text: '<t:message code="system.label.product.routingorder" default="공정순서"/>'			,type:'string'},
			{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'},
			{name: 'PROG_WORK_NAME'		,text: '<t:message code="system.label.product.routingname" default="공정명"/>'				,type:'string'},
			{name: 'PROG_UNIT_Q'		,text: '<t:message code="system.label.product.originunitqty" default="원단위량"/>'			,type:'uniQty'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'			,type:'uniQty'},
			{name: 'PROG_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>'						,type:'string',comboType:'AU',comboCode:'B013'},
			{name: 'PROG_RATE'			,text: '<t:message code="system.label.product.routingprocessrate" default="공정진척율(%)"/>'	,type:'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'				,type:'string'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'			,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				,type:'string'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'		,type:'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'		,type:'uniDate'},
			{name: 'PRODT_WKORD_DATE'	,text: '<t:message code="system.label.product.workstartdate" default="작업시작일"/>'			,type:'uniDate'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'						,type:'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.product.remarks" default="비고"/>'					,type:'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'					,type:'string'},
			{name: 'WK_PLAN_NUM'		,text: '<t:message code="system.label.product.planno" default="계획번호"/>'					,type:'string'},
			{name: 'LINE_END_YN'		,text: '<t:message code="system.label.product.lastroutingyn" default="최종공정여부"/>'		,type:'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'						,type:'string'},
			{name: 'WORK_END_YN'		,text: '<t:message code="system.label.product.closingyn" default="마감여부"/>'				,type:'string'},

			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
			{name: 'PJT_CODE'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
			{name: 'SEQ_NO'				,text: '<t:message code="system.label.product.number" default="번호"/>'					,type:'uniQty'},
			{name: 'TOP_WKORD_NUM'		,text: '<t:message code="system.label.product.manageno" default="관리번호"/>'				,type:'string'},
			{name: 'EQUIP_CODE'			,text: '<t:message code="system.label.product.facilities" default="설비"/>'				,type:'string'},
			{name: 'EQUIP_NAME'			,text: '<t:message code="system.label.product.facilitiesname" default="설비명"/>'			,type:'string'},
			{name: 'MOLD_CODE'			,text: '<t:message code="system.label.product.moldcode" default="금형코드"/>'				,type:'string'},
			{name: 'MOLD_NAME'			,text: '<t:message code="system.label.product.moldname" default="금형명"/>'				,type:'string'},

			{name: 'STD_TIME'			,text: '표준시간'		,type:'int'},
			{name: 'CAVIT_BASE_Q'		,text: 'Cavity 수'	,type:'int'},
			{name: 'CAPA_HR'			,text: 'Capa/Hr'	,type:'int'},
			{name: 'CAPA_DAY'			,text: 'Capa/Day'	,type:'int'},
			//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터)
			{name: 'CUSTOM'				,text: 'CUSTOM'		,type:'string'}
		]
	});



	/** Store 정의(Service 정의)
	 *
	 * @type
	 */
	var detailStore = Unilite.createStore('pmp100ukrvDetailStore', {
		model: 'pmp100ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,		 // 상위 버튼 연결
			editable: true,		 // 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi : false		 // prev | next 버튼 사용
		},
		proxy: directProxy,
		/*
		 * syncAll 수정 proxy: { type: 'direct', api: { read:
		 * 'pmp100ukrvService.selectDetailList', update:
		 * 'pmp100ukrvService.updateDetail', create:
		 * 'pmp100ukrvService.insertDetail', destroy:
		 * 'pmp100ukrvService.deleteDetail', syncAll:
		 * 'pmp100ukrvService.syncAll' } },
		 */
		listeners: {
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			}
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			param.TYPE='1';
			this.load({
				params : param,
				callback: function(records, operation, success) {
					console.log(records);
					if(records != null && records.length>0){
						UniAppManager.app.fnDisable();
						detailStore2.loadStoreRecords(records[0].data);
					}
				}
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
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			// 1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	// syncAll 수정\
			if(inValidRecs.length == 0) {
				var toCreate = this.getNewRecords();
				var toUpdate = this.getUpdatedRecords();
				var list = [].concat(toUpdate, toCreate);

//				var masterRecords = detailGrid.getStore().getData().items;;
				var masterRecords = list;
				detailStore2.clearFilter();
				var detailRecords = detailGrid2.getStore().getData().items;
				var masterArray = [];
				var detailArray = [];
				if(masterRecords != null && masterRecords.length > 0){
					masterRecords.forEach(function(e){
						var dataObj = e.data;
						if(dataObj.CHECK_YN == 'Y'){
							dataObj.PRODT_START_DATE1=UniDate.getDateStr(dataObj.PRODT_START_DATE);
							dataObj.PRODT_END_DATE1=UniDate.getDateStr(dataObj.PRODT_END_DATE);
							if(!Ext.isEmpty(panelResult.getValue('LOT_NAME'))){
								dataObj.LOT_NO = panelResult.getValue('LOT_NAME');
							}
							dataObj.PJT_CODE = panelResult.getValue('PJT_CODE');
							dataObj.PROJECT_NO = panelResult.getValue('PROJECT_NO');
							dataObj.REMARK = panelResult.getValue('REMARK');
							dataObj.WKORD_PRSN = panelResult.getValue('WKORD_PRSN');
							dataObj.PRODT_DATE = UniDate.getDbDateStr(panelResult.getValue('PRODT_DATE'));

							dataObj.ORDER_NUM = panelResult.getValue('ORDER_NUM');
							dataObj.ORDER_SEQ = panelResult.getValue('ORDER_SEQ');

							masterArray.push(dataObj);

							if(detailRecords != null && detailRecords.length > 0){
								for(var i = 0; i<detailRecords.length;i++){
									var dataObj2 = detailRecords[i].data;
									if(dataObj.SEQ_NO == dataObj2.SEQ_NO){
										dataObj2.PRODT_START_DATE1=UniDate.getDateStr(dataObj.PRODT_START_DATE);
										dataObj2.PRODT_END_DATE1=UniDate.getDateStr(dataObj.PRODT_END_DATE);
										dataObj2.PRODT_WKORD_DATE1=UniDate.getDateStr(panelResult.getValue('PRODT_WKORD_DATE'));//입력조건의 작업지시일
										dataObj2.LOT_NO = dataObj.LOT_NO;
										dataObj2.PJT_CODE = panelResult.getValue('PJT_CODE');
										dataObj2.PROJECT_NO = panelResult.getValue('PROJECT_NO');
										dataObj2.REMARK = panelResult.getValue('REMARK');
										dataObj2.WKORD_PRSN = panelResult.getValue('WKORD_PRSN');
										dataObj2.PRODT_DATE = UniDate.getDbDateStr(panelResult.getValue('PRODT_DATE'));

										//20180705(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
										dataObj2.PRODT_PRSN = dataObj.PRODT_PRSN;
										dataObj2.PRODT_MACH = dataObj.PRODT_MACH;
										dataObj2.PRODT_TIME = dataObj.PRODT_TIME;
										dataObj2.DAY_NIGHT	= dataObj.DAY_NIGHT;

										//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터)
										dataObj2.CUSTOM	= panelResult.getValue('CUSTOM_CODE');

										dataObj2.ORDER_NUM = panelResult.getValue('ORDER_NUM');
										dataObj2.ORDER_SEQ = panelResult.getValue('ORDER_SEQ');

										dataObj2.EXPIRATION_DATE = UniDate.getDateStr(panelResult.getValue('EXPIRATION_DATE'));

										dataObj2.SUPPLY_TYPE = dataObj.SUPPLY_TYPE;

										detailArray.push(dataObj2);
									}
								}
							}
						}
					});
				}
				paramMaster.masterArray = masterArray;
				paramMaster.detailArray = detailArray;
				paramMaster.sWkordNum	= null;
				paramMaster.sTopWkordNum	= null;

				Ext.getBody().mask('<t:message code="system.label.product.loading" default="로딩중..."/>','loading-indicator');
				pmp100ukrvService.saveAll(paramMaster, function(provider, response) {
					if(!Ext.isEmpty(provider)){
						UniAppManager.updateStatus(UniUtils.getMessage('system.message.commonJS.store.saved','저장되었습니다.'));
						sWkordNum = provider['sWkordNum'];
						sAutoLotNo = provider['sAutoLotNo'];
						sTopWkordNum = provider['sTopWkordNum'];
						detailStore.saveAfterOper();
					}
					Ext.getBody().unmask();
				});
				//this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('pmp100ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		saveAfterOper: function(){
			var masterRecords = detailGrid.getStore().getData().items;
			var detailRecords = detailGrid2.getStore().getData().items;

			if(masterRecords != null && masterRecords.length > 0){
				for(var	i = 0; i < masterRecords.length; i++){
					var e = masterRecords[i];
					var dataObj = e.data;
					if(dataObj.CHECK_YN == 'Y'){
						if(sWkordNum && sWkordNum.hasOwnProperty(dataObj.SEQ_NO)){
							e.set('WKORD_NUM',sWkordNum[dataObj.SEQ_NO]);
							e.set('LOT_NO',sAutoLotNo[dataObj.SEQ_NO]);
							//e.set('CHECK_YN','N');

							if(detailRecords != null && detailRecords.length > 0){
								for(var j = 0; j<detailRecords.length;j++){
									var dataObj2 = detailRecords[j].data;
									if(dataObj.SEQ_NO == dataObj2.SEQ_NO){
										detailRecords[j].set('WKORD_NUM',sWkordNum[dataObj.SEQ_NO]);
										detailRecords[j].set('LOT_NO',sAutoLotNo[dataObj.SEQ_NO]);
										detailRecords[j].commit();
									}
								}
							}
						}
						e.set('REF_GUBUN','Y');
						detailGrid.getSelectionModel().deselect(e);
						e.commit();
					}
				}
				UniAppManager.app.fnFindProgWork(masterRecords[0].data);
				if(sWkordNum && JSON.stringify(sWkordNum) !== "{}"){
					panelResult.down('#btnPrint').setDisabled(false);
					panelResult.down('#btnPrint2').setDisabled(false);
					UniAppManager.setToolbarButtons('save', false);
				} else{
					panelResult.down('#btnPrint').setDisabled(true);
					panelResult.down('#btnPrint2').setDisabled(true);
				}
				panelResult.down('#btnPart').setDisabled(true);
				//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터) - 저장 후에는 수정할 수 없음
				panelResult.getField('CUSTOM_CODE').setReadOnly( true );
			}
		}
	});

	var detailStore2 = Unilite.createStore('pmp100ukrvDetailStore2', {
		model: 'pmp100ukrvDetailModel2',
		autoLoad: false,
		uniOpt: {
			isMaster: true,		 // 상위 버튼 연결
			editable: true,		 // 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi : false		 // prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function(p) {
			var param= panelResult.getValues();
			param.TYPE='2';
			param.MRP_CONTROL_NUM = p.MRP_CONTROL_NUM;
			console.log(param);
			this.load({
				params : param,
				callback: function(records, operation, success) {
					console.log(records);
					if(records != null && records.length>0){
						UniAppManager.app.fnFindProgWork(null);
					}

					var detailRecords = detailStore.data.items;
					Ext.each(detailRecords, function(rec, idx) {

						var param={
							"DIV_CODE"		 : panelResult.getValue("DIV_CODE"),
							"WORK_SHOP_CODE" : rec.get("WORK_SHOP_CODE"),			//20200311 수정panelResult.getValue('WORK_SHOP_CODE'),
							"PROD_ITEM_CODE" : panelResult.getValue("ITEM_CODE"),
							"ITEM_CODE"		 : rec.get("ITEM_CODE")
							
						}
			        	pmp110ukrvService.selectProgInfo(param, function(provider, response) {
			                if(!Ext.isEmpty(provider)){
			                	detailStore2.clearFilter();

			                	var records = detailStore2.data.items;
								for(var i = records.length-1; i>=0; i--){
									var e = records[i];
									if(e && e.get("SEQ_NO") == rec.get("SEQ_NO")){
										detailStore2.remove(e);
									}
								}

			                	provider.forEach(function(e){
									var r = e;

									if(!r.PROG_UNIT){
										r.PROG_UNIT = panelResult.getValue("PROG_UNIT");
									}
									r.WKORD_Q = rec.get("WKORD_Q");
									r.PROG_RATE = 0;
									r.DIV_CODE = panelResult.getValue("DIV_CODE");
									r.WKORD_NUM = '';

									r.WORK_SHOP_CODE = rec.get('WORK_SHOP_CODE');
									r.PRODT_START_DATE = rec.get("PRODT_START_DATE");
									r.PRODT_END_DATE = rec.get("PRODT_END_DATE");
									r.PRODT_WKORD_DATE = rec.get("PRODT_START_DATE");
									r.ITEM_CODE = rec.get("ITEM_CODE");
									r.REMARK = panelResult.getValue("REMARK");
									r.WK_PLAN_NUM = panelResult.getValue("WK_PLAN_NUM");
									r.LINE_END_YN = 'Y';
									r.ITEM_NAME = panelResult.getValue("ITEM_NAME");
									r.SPEC = panelResult.getValue("SPEC");
									r.WORK_END_YN = 'N';
									r.PROJECT_NO = panelResult.getValue("PROJECT_NO");
									r.PJT_CODE = panelResult.getValue("PJT_CODE");
									r.LOT_NO = panelResult.getValue("LOT_NO");
									r.SEQ_NO = rec.get("SEQ_NO");
									r.TOP_WKORD_NUM = '';
									detailStore2.insert(detailStore2.getCount(), r);

								});

								detailStore2.filterBy (function(rec){
									if(gsSeqNo > 0){
										if(gsSeqNo == rec.get("SEQ_NO")){
											return true;
										} else{
											return false;
										}
									} else{
										return false;
									}
								});
			                }
			        	});
					});
				}
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

			var orderNum = panelResult.getValue('ORDER_NUM');
			var orderSeq = panelResult.getValue('ORDER_SEQ');
			Ext.each(list, function(record, index) {
				if(record.data['ORDER_NUM'] != orderNum) {
					record.set('ORDER_NUM', orderNum);
				}else if(record.data['ORDER_SEQ'] != orderSeq){
					record.set('ORDER_SEQ', orderSeq);
				}
			});
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			// 1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	// syncAll 수정
			if(inValidRecs.length == 0) {
					config = {
						params: [paramMaster],
						success: function(batch, option) {
							// 2.마스터 정보(Server 측 처리 시 가공)
							var master = batch.operations[0].getResultSet();
							panelResult.setValue("ORDER_NUM", master.ORDER_NUM);

							// 3.기타 처리
							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);

						}
					};
				// }
				// this.syncAll(config);
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('pmp100ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				// alert(Msg.sMB083);
			}
		}
	});



	var detailGrid = Unilite.createGrid('pmp100ukrvGrid', {
		layout: 'fit',
		region:'north',
		uniOpt: {
			expandLastColumn: true,
			useRowNumberer: false,
			onLoadSelectFirst : false
		},
		tbar: [{
			xtype: 'splitbutton',
			itemId:'refTool',
			text: '<t:message code="system.label.product.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'requestBtn',
					text: '<t:message code="system.label.product.productionplanreference" default="생산계획참조"/>',
					handler: function() {
						openProductionPlanWindow();

					}
				},{
					itemId: 'workBtn',
					text: '<t:message code="system.label.product.wholeworkorderrelease" default="일괄작지전개"/>',
					handler: function() {
					}
				},{
					itemId: 'dismemberBtn',
					text: '<t:message code="system.label.product.workorderpart" default="작지분할"/>',
					handler: function() {
					}
				}]
			})
		}/*,{
			xtype: 'splitbutton',
			itemId:'procTool',
			text: '<t:message code="system.label.product.processbutton" default="프로세스..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'selectAllBtn',
					text: '<t:message code="system.label.product.selectall" default="전체선택"/>',
					handler: function() {
						openProductionPlanWindow();

						}
				},{
					itemId: 'preparationDirectiveBtn',
					text: '제조지시서출력',
					handler: function() {
						openProductionPlanWindow();

						}
				}]
			})
		}*/
		],
//		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		selModel : Ext.create("Ext.selection.CheckboxModel", {
			singleSelect : true ,
			checkOnly : true,
			showHeaderCheckbox :true,
			onHeaderClick: function(headerCt, header, e) {
				var me		= this,
					store	= me.store,
					column	= me.column,
					isChecked, records, i, len,
					selections, selection;

				if (me.showHeaderCheckbox !== false && header === me.column && me.mode !== 'SINGLE') {
					e.stopEvent();
					isChecked = header.el.hasCls(Ext.baseCSSPrefix + 'grid-hd-checker-on');
					selections = this.getSelection();
					if (selections.length > 0) {
						records = [];
						selections = this.getSelection();
						for (i = 0, len = selections.length; i < len; ++i) {
							selection = selections[i];
							if (store.indexOf(selection) > -1) {
								records.push(selection);
							}
						}
						if (records.length > 0) {
							me.deselect(records);
						}
					} else {
						me.selectAll();
					}
				}
			},
			listeners: {
//				beforeselect: function(rowSelection, record, index, eOpts) {
//                    var count = detailGrid2.getStore().getCount();
//                    if(count == 0){
//                        return false;
//                    }
//                },
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					gsRowIndex = index;
					gsSeqNo = selectRecord.get("SEQ_NO");

					UniAppManager.app.fnFindProgWork(selectRecord.data);
					if(selectRecord.get("CHECK_YN")=='Y'){
						selectRecord.set("CHECK_YN",'N');
					} else{
						selectRecord.set("CHECK_YN",'Y');
					}
				},
				deselect:	function(grid, selectRecord, index, eOpts ){
					if(selectRecord.get("CHECK_YN")=='Y'){
						selectRecord.set("CHECK_YN",'N');
					} else{
						selectRecord.set("CHECK_YN",'Y');
					}
					var selectAll = detailGrid.getSelectedRecords();
					if(Ext.isEmpty(selectAll)){
						UniAppManager.app.fnFindProgWork(null);
					}
				}
			}
		}),
		store: detailStore,
		columns: [
			{dataIndex: 'GUBUN'				, width: 40	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 80},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100,
				listeners:{
					render:function(elm){
						elm.editor.on('beforequery',function(queryPlan, eOpts)  {
							var store = queryPlan.combo.store;
							var selRecord =  detailGrid.uniOpt.currentRecord;
							store.clearFilter();
							if(!Ext.isEmpty(selRecord.get('DIV_CODE'))){
								store.filterBy(function(record){
									return record.get('option') == selRecord.get('DIV_CODE');
								});
							}else{
								store.filterBy(function(record){
									return false;
								});
							}
						}),
						elm.editor.on('collapse',function(combo,  eOpts )	{
							var store = combo.store;
							store.clearFilter();
						});
					}
				}
			},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 250},
			{dataIndex: 'SPEC'				, width: 100},
			{dataIndex: 'STOCK_UNIT'		, width: 80},
			{dataIndex: 'PRODT_START_DATE'	, width: 100},
			{dataIndex: 'PRODT_END_DATE'	, width: 100},
			{dataIndex: 'WKORD_Q'			, width: 100},

			//20180705(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
			{dataIndex: 'PRODT_PRSN'		, width: 150},
			{dataIndex: 'PRODT_MACH'		, width: 100},
			{dataIndex: 'PRODT_TIME'		, width: 100},
			{dataIndex: 'DAY_NIGHT'			, width: 100},

			{dataIndex: 'SUPPLY_TYPE'		, width: 75},
			{dataIndex: 'WKORD_NUM'			, width: 130},
			{dataIndex: 'WK_PLAN_NUM'		, width: 115},
			{dataIndex: 'PRODUCT_LDTIME'	, width: 66 , hidden: true},
			{dataIndex: 'SEQ_NO'			, width: 66 , hidden: true},
			{dataIndex: 'REF_GUBUN'			, width: 53 , hidden: true},
			{dataIndex: 'PROJECT_NO'		, width: 66 , hidden: true},
			{dataIndex: 'PJT_CODE'			, width: 66 , hidden: true},
			{dataIndex: 'REMARK'			, width: 66 , hidden: true},
			{dataIndex: 'LOT_NO'			, width: 80 , hidden: false}
		],
		listeners: {
			beforeselect	: function( grid, record, index, eOpts ) {
				if(record.data.REF_GUBUN == 'Y'){
					//alert("Record has been saved!");
					return false;
				}
			},
			beforeedit	: function( editor, e, eOpts ) {
				if(e.record.data.REF_GUBUN == 'Y'){
					return false;
				}
				if(UniUtils.indexOf(e.field, ['PRODT_START_DATE','PRODT_END_DATE','WKORD_Q','SUPPLY_TYPE','WORK_SHOP_CODE', 'LOT_NO'
											//20180705(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
											, 'PRODT_PRSN', 'PRODT_MACH', 'PRODT_TIME', 'DAY_NIGHT'
											, 'DIV_CODE'
											])){
					return true;
				}else{
					return false;
				}
			},
			selectionchangerecord:function(selected) {
				//20190122 선택되지 않는 ROW 선택시, 기존 선택된 ROW 체크해제 됨 -> 주석
//				UniAppManager.app.fnFindProgWork(selected.data);
			}

		},
		disabledLinkButtons: function(b) {
		},
		setEstiData:function(record) {},
		setRefData: function(record) {}
	});

	var detailGrid2 = Unilite.createGrid('pmp100ukrvGrid2', {
		layout: 'fit',
		region:'center',
		uniOpt: {
			expandLastColumn: true,
			useRowNumberer: false
		},
		store: detailStore2,
		columns: [
			{dataIndex: 'LINE_SEQ'			, width: 100},
			{dataIndex: 'PROG_WORK_CODE'	, width: 120,
				editor: Unilite.popup('PROG_WORK_CODE_G', {
					textFieldName: 'PROG_WORK_NAME',
					DBtextFieldName: 'PROG_WORK_NAME',
					//extParam: {SELMODEL: 'MULTI'},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid2.setItemData(record,false, detailGrid2.uniOpt.currentRecord);
									} else{
										UniAppManager.app.onNewDataButtonDown();
										detailGrid2.setItemData(record,false, detailGrid2.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid2.setItemData(null,true, detailGrid2.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE'		: panelResult.getValue('DIV_CODE')});
							//popup.setExtParam({'WORK_SHOP_CODE' : panelResult.getValue('WORK_SHOP_CODE')
						}
					}
				})
			},
			{dataIndex: 'PROG_WORK_NAME'	, width: 150,
				editor: Unilite.popup('PROG_WORK_CODE_G', {
					textFieldName: 'PROG_WORK_NAME',
					DBtextFieldName: 'PROG_WORK_NAME',
					//extParam: {SELMODEL: 'MULTI'},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid2.setItemData(record,false, detailGrid2.uniOpt.currentRecord);
									} else{
										UniAppManager.app.onNewDataButtonDown();
										detailGrid2.setItemData(record,false, detailGrid2.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = detailGrid2.getSelectedRecord();
							detailGrid2.setItemData(null,true, detailGrid2.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE'		: panelResult.getValue('DIV_CODE')})
							//popup.setExtParam({'WORK_SHOP_CODE' : panelResult.getValue('WORK_SHOP_CODE')
						}
					}
				})
			},
			{dataIndex: 'PROG_UNIT_Q'		, width: 120},
			{dataIndex: 'WKORD_Q'			, width: 140},
			{dataIndex: 'PROG_UNIT'			, width: 140},
			{dataIndex: 'STD_TIME'			, width: 100},
			{dataIndex: 'EQUIP_CODE'		, width: 110,
				'editor' : Unilite.popup('EQU_MACH_CODE_G',{
						textFieldName:'EQU_MACH_NAME',
						DBtextFieldName: 'EQU_MACH_NAME',
						autoPopup: true,
						listeners: {
							'onSelected': {
							fn: function(records, type) {
								var grdRecord = detailGrid2.uniOpt.currentRecord;
								grdRecord.set('EQUIP_CODE',records[0]['EQU_MACH_CODE']);
								grdRecord.set('EQUIP_NAME',records[0]['EQU_MACH_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							grdRecord = detailGrid2.getSelectedRecord();
							grdRecord.set('EQUIP_CODE', '');
							grdRecord.set('EQUIP_NAME', '');
						},
						applyextparam: function(popup){
							var param = panelResult.getValues();
							popup.setExtParam({'DIV_CODE': param.DIV_CODE});
						}
					}
				})
			},
			{dataIndex: 'EQUIP_NAME'		, width: 200,
				'editor' : Unilite.popup('EQU_MACH_CODE_G',{
					textFieldName:'EQU_MACH_NAME',
					DBtextFieldName: 'EQU_MACH_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
								fn: function(records, type) {
									var grdRecord = detailGrid2.uniOpt.currentRecord;
									grdRecord.set('EQUIP_CODE',records[0]['EQU_MACH_CODE']);
									grdRecord.set('EQUIP_NAME',records[0]['EQU_MACH_NAME']);
								},
								scope: this
							},
							'onClear': function(type) {
								grdRecord = detailGrid2.getSelectedRecord();
								grdRecord.set('EQUIP_CODE', '');
								grdRecord.set('EQUIP_NAME', '');
							},
							applyextparam: function(popup){
								var param = panelResult.getValues();
								popup.setExtParam({'DIV_CODE': param.DIV_CODE});
							}
					}
				})
			},
			{dataIndex: 'MOLD_CODE'			, width: 110,
				'editor' : Unilite.popup('EQU_MOLD_CODE_G',{
					textFieldName:'EQU_MOLD_NAME',
					DBtextFieldName: 'EQU_MOLD_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								grdRecord = detailGrid2.getSelectedRecord();
								Ext.each(records, function(record,i) {
									grdRecord.set('MOLD_CODE',records[0]['EQU_MOLD_CODE']);
									grdRecord.set('MOLD_NAME',records[0]['EQU_MOLD_NAME']);
									grdRecord.set('CAVIT_BASE_Q', record.CAVIT_BASE_Q);
									if(record.CAVIT_BASE_Q != 0 && record.CYCLE_TIME != 0){
										grdRecord.set('CAPA_HR', 3600/record.CYCLE_TIME * record.CAVIT_BASE_Q );
										grdRecord.set('CAPA_DAY',(3600/record.CYCLE_TIME * record.CAVIT_BASE_Q)* grdRecord.get('STD_TIME'));
									} else{
										grdRecord.set('CAPA_HR', 0);
										grdRecord.set('CAPA_DAY',0);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							grdRecord = detailGrid2.getSelectedRecord();
							grdRecord.set('MOLD_CODE', '');
							grdRecord.set('MOLD_NAME', '');
							grdRecord.set('CAVIT_BASE_Q', record.CAVIT_BASE_Q);
							grdRecord.set('CAPA_HR' , '');
							grdRecord.set('CAPA_DAY','');
						},
						applyextparam: function(popup){
							var param = panelResult.getValues();
							popup.setExtParam({'DIV_CODE': param.DIV_CODE});
						}
					}
				})
			},
			{dataIndex: 'MOLD_NAME'			, width: 200,
				'editor' : Unilite.popup('EQU_MOLD_CODE_G',{
					textFieldName:'EQU_MOLD_NAME',
					DBtextFieldName: 'EQU_MOLD_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								grdRecord = detailGrid2.getSelectedRecord();
								Ext.each(records, function(record,i) {
									grdRecord.set('MOLD_CODE',records[0]['EQU_MOLD_CODE']);
									grdRecord.set('MOLD_NAME',records[0]['EQU_MOLD_NAME']);
									grdRecord.set('CAVIT_BASE_Q', record.CAVIT_BASE_Q);
									if(record.CAVIT_BASE_Q != 0 && record.CYCLE_TIME != 0){
										grdRecord.set('CAPA_HR', 3600/record.CYCLE_TIME * record.CAVIT_BASE_Q );
										grdRecord.set('CAPA_DAY',(3600/record.CYCLE_TIME * record.CAVIT_BASE_Q)* grdRecord.get('STD_TIME'));
									} else{
										grdRecord.set('CAPA_HR', 0);
										grdRecord.set('CAPA_DAY',0);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							grdRecord = detailGrid2.getSelectedRecord();
							grdRecord.set('MOLD_CODE', '');
							grdRecord.set('MOLD_NAME', '');
							grdRecord.set('CAVIT_BASE_Q', record.CAVIT_BASE_Q);
							grdRecord.set('CAPA_HR', '');
							grdRecord.set('CAPA_DAY','');
						},
						applyextparam: function(popup){
							var param = panelResult.getValues();
							popup.setExtParam({'DIV_CODE': param.DIV_CODE});
						}
					}
				})
			},
			{dataIndex: 'CAVIT_BASE_Q'		, width: 100 },
			{dataIndex: 'CAPA_HR'			, width: 100 },
			{dataIndex: 'CAPA_DAY'			, width: 100 },
			{dataIndex: 'REMARK'			, width: 500 },
			{dataIndex: 'PROG_RATE'			, width: 53 , hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 73 , hidden: true},
			{dataIndex: 'WKORD_NUM'			, width: 130, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 80 , hidden: true},
			{dataIndex: 'PRODT_START_DATE'	, width: 75 , hidden: true},
			{dataIndex: 'PRODT_END_DATE'	, width: 100, hidden: true},
			{dataIndex: 'PRODT_WKORD_DATE'	, width: 140, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 140, hidden: true},
			{dataIndex: 'LOT_NO'			, width: 73 , hidden: true},
			{dataIndex: 'WK_PLAN_NUM'		, width: 115, hidden: true},
			{dataIndex: 'LINE_END_YN'		, width: 66 , hidden: true},
			{dataIndex: 'ITEM_NAME'			, width: 66 , hidden: true},
			{dataIndex: 'SPEC'				, width: 53 , hidden: true},
			{dataIndex: 'WORK_END_YN'		, width: 66 , hidden: true},
			{dataIndex: 'PROJECT_NO'		, width: 66 , hidden: true},
			{dataIndex: 'PJT_CODE'			, width: 66 , hidden: true},
			{dataIndex: 'SEQ_NO'			, width: 66 , hidden: true},
			{dataIndex: 'TOP_WKORD_NUM'		, width: 66 , hidden: true},
			//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터)
			{dataIndex: 'CUSTOM'			, width: 100, hidden: false}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				return true;
			}
		},
		disabledLinkButtons: function(b) {
		},
		setItemData: function(record, dataClear, grdRecord) {
			//var grdRecord = detailGrid.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('PROG_WORK_CODE'	, '');
				grdRecord.set('PROG_WORK_NAME'	, '');
				grdRecord.set('PROG_UNIT'		, panelResult.getValue('PROG_UNIT'));
				grdRecord.set('STD_TIME'		, '');
			} else{
				grdRecord.set('PROG_WORK_CODE'	, record['PROG_WORK_CODE']);
				grdRecord.set('PROG_WORK_NAME'	, record['PROG_WORK_NAME']);
				grdRecord.set('STD_TIME'		, record['STD_TIME']);
				if(grdRecord.get['PROG_UNIT'] != ''){
					grdRecord.set('PROG_UNIT'	, record['PROG_UNIT']);
				}
				else{
					grdRecord.set('PROG_UNIT'	, panelResult.getValue('PROG_UNIT'));
				}
			}
		},
		setEstiData:function(record) {},
		setRefData: function(record) {}
	});



	// 생산계획 참조
	var productionPlanSearch = Unilite.createSearchForm('productionPlanForm', {
		layout :	{type : 'uniTable', columns : 2},
		items: [{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			hidden:true
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType:'WU',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();

					if(!Ext.isEmpty(productionPlanSearch.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == productionPlanSearch.getValue('DIV_CODE');
						});
					} else{
						store.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.plandate" default="계획일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'PRODT_PLAN_DATE_FR',
			endFieldName: 'PRODT_PLAN_DATE_TO',
			width: 315,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('endOfMonth'),
			allowBlank:false
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
			validateBlank:false,
			valueFieldName: 'ITEM_CODE',
			textFieldName:'ITEM_NAME'
		})]
	});

	Unilite.defineModel('pmp100ukrvProductionPlanModel', {
		fields: [
			{name: 'GUBUN'				, text: '<t:message code="system.label.product.selection" default="선택"/>'				, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.mfgplace" default="제조처"/>'				, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				, type: 'string', comboType:'WU'},
			{name: 'WK_PLAN_NUM'		, text: '<t:message code="system.label.product.productionplanno" default="생산계획번호"/>'	, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'					, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'					, type: 'string'},
			{name: 'WK_PLAN_Q'			, text: '<t:message code="system.label.product.planqty" default="계획량"/>'				, type: 'uniQty'},
			{name: 'PRODUCT_LDTIME'		, text: '<t:message code="system.label.product.mfglt" default="제조 L/T"/>'				, type: 'string'},
			{name: 'PRODT_START_DATE'	, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'		, type: 'uniDate'},
			{name: 'PRODT_PLAN_DATE'	, text: '<t:message code="system.label.product.planfinisheddate" default="계획완료일"/>'		, type: 'uniDate'},
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'			, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'			, text: 'ORDER_SEQ'					, type: 'int'},
			{name: 'ORDER_DATE'			, text: '<t:message code="system.label.product.sodate" default="수주일"/>'					, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'					, type: 'uniQty'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.product.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'EXPIRATION_DAY'		, text: 'EXPIRATION_DAY'																		, type: 'int'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'PJT_CODE'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			, type: 'string'}
		]
	});

	var productionPlanStore = Unilite.createStore('pmp100ukrvProductionPlanStore', {
		model: 'pmp100ukrvProductionPlanModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'pmp100ukrvService.selectEstiList'
			}
		},
		listeners:{
		/*	load:function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
					var estiRecords = new Array();

					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);

						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
									console.log("record :", record);
									if(( record.data['ESTI_NUM'] == item.data['ESTI_NUM'])
									 &&( record.data['ESTI_SEQ'] == item.data['ESTI_SEQ']))
									{
										estiRecords.push(item);
									}
							});

						});
						store.remove(estiRecords);
					}
				}
			}*/
		},
		loadStoreRecords : function() {
			var param= productionPlanSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var productionPlanGrid = Unilite.createGrid('pmp100ukrvproductionPlanGrid', {
		layout : 'fit',
		store: productionPlanStore,
//		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
//		uniOpt:{
//			onLoadSelectFirst : false
//		},
		selModel:'rowmodel',
		columns: [
			{dataIndex: 'GUBUN'				, width:0	,hidden: true},
			{dataIndex: 'DIV_CODE'			, width:0	,hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width:100},
			{dataIndex: 'WK_PLAN_NUM'		, width:100,hidden: true},
			{dataIndex: 'ITEM_CODE'			, width:100},
			{dataIndex: 'ITEM_NAME'			, width:200},
			{dataIndex: 'SPEC'				, width:100},
			{dataIndex: 'STOCK_UNIT'		, width:40},
			{dataIndex: 'WK_PLAN_Q'			, width:73},
			{dataIndex: 'PRODUCT_LDTIME'	, width:80},
			{dataIndex: 'PRODT_START_DATE'	, width:80},
			{dataIndex: 'PRODT_PLAN_DATE'	, width:80},
			{dataIndex: 'WKORD_NUM'			, width:115},
			{dataIndex: 'ORDER_NUM'			, width:115},
			{dataIndex: 'ORDER_SEQ'			, width:80,hidden: true},
			{dataIndex: 'ORDER_DATE'		, width:80},
			{dataIndex: 'ORDER_Q'			, width:73},
			{dataIndex: 'CUSTOM_CODE'		, width:100},
			{dataIndex: 'DVRY_DATE'			, width:80 ,hidden: true},
			{dataIndex: 'EXPIRATION_DAY'	, width:73 ,hidden: true},
			{dataIndex: 'PROJECT_NO'		, width:80 ,hidden: true},
			{dataIndex: 'PJT_CODE'			, width:80 ,hidden: true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				this.returnData(record);
				referProductionPlanWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
				if(Ext.isEmpty(record)) {
					return false;
				}
			}
			panelResult.setValues({
				'DIV_CODE'			: record.get('DIV_CODE'),		/*사업장*/					/*작업지시번호*/
				'WORK_SHOP_CODE'	: record.get('WORK_SHOP_CODE'),	/* 작업장*/
				'ITEM_CODE'			: record.get('ITEM_CODE'),	/*품목코드*/
				'ITEM_NAME'			: record.get('ITEM_NAME'),		/*품목명*/
				'SPEC'				: record.get('SPEC'),		/*규격*/
				'PRODT_START_DATE'	: record.get('PRODT_START_DATE'),
				'PRODT_END_DATE'	: record.get('PRODT_PLAN_DATE'),
				'LOT_NO'			: record.get('LOT_NO'),
				'WKORD_Q'			: record.get('WK_PLAN_Q'),
				'PROG_UNIT'			: record.get('STOCK_UNIT'),
				'PROJECT_NO'		: record.get('PROJECT_NO'),
				'PJT_CODE'			: record.get('PJT_CODE'),
				'ORDER_NUM'			: record.get('ORDER_NUM'),		/* 수주번호*/
				'ORDER_SEQ'			: record.get('ORDER_SEQ'),
				'ORDER_Q'			: record.get('ORDER_Q'),	/* 수주량*/
				'DVRY_DATE'			: record.get('DVRY_DATE'),		/* 납기일*/
				'CUSTOM_CODE'		: record.get('CUSTOM_CODE'),
				'WK_PLAN_NUM'		: record.get('WK_PLAN_NUM')
//				,'PRODT_WKORD_DATE':productionPlanSearch.getValue('PRODT_PLAN_DATE_FR')
			});

			if(record.get('EXPIRATION_DAY') != 0){
				panelResult.setValue('EXPIRATION_DATE',UniDate.getDbDateStr(UniDate.add(panelResult.getValue('PRODT_WKORD_DATE'), {months: +record.get('EXPIRATION_DAY'), days:-1})));
			}else{
				panelResult.setValue('EXPIRATION_DATE', '');
			}
			panelResult.getField('DIV_CODE').setReadOnly( true );
			panelResult.getField('WORK_SHOP_CODE').setReadOnly( true );
			panelResult.getField('ITEM_CODE').setReadOnly( true );
			panelResult.getField('ITEM_NAME').setReadOnly( true );
			panelResult.getField('SPEC').setReadOnly( true );
			panelResult.getField('PROG_UNIT').setReadOnly( true );

			//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터)
			if(Ext.isEmpty(panelResult.getValue('ORDER_NUM'))) {
				panelResult.getField('CUSTOM_CODE').setReadOnly( false );
			} else {
				panelResult.getField('CUSTOM_CODE').setReadOnly( true );
			}
		}
	});

	function openProductionPlanWindow() {
		//if(!UniAppManager.app.checkForNewDetail()) return false;
		productionPlanSearch.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
		if(!referProductionPlanWindow) {
			referProductionPlanWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.product.productionplaninfo" default="생산계획정보"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [productionPlanSearch, productionPlanGrid],
				tbar:	['->',
						{	itemId : 'saveBtn',
							width	: 80,
							text: '<t:message code="system.label.product.inquiry" default="조회"/>',
							handler: function() {
								productionPlanStore.loadStoreRecords();
							},
							disabled: false
						},
						{	itemId : 'confirmBtn',
							width	: 80,
							text: '<t:message code="system.label.product.planapply" default="계획적용"/>',
							handler: function() {
								productionPlanGrid.returnData();
								referProductionPlanWindow.hide();
							},
							disabled: false
//										},{ itemId : 'confirmCloseBtn',
//											text: '<t:message code="system.label.product.soapplyclose" default="수주적용후 닫기"/>',
//											handler: function() {
//												productionPlanGrid.returnData();
//												referProductionPlanWindow.hide();
//											},
//											disabled: false
						},{
							itemId : 'closeBtn',
							width	: 80,
							text: '<t:message code="system.label.product.close" default="닫기"/>',
							handler: function() {
								referProductionPlanWindow.hide();
							},
							disabled: false
						}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						// requestSearch.clearForm();
						// requestGrid,reset();
					},
					beforeclose: function( panel, eOpts ) {
						// requestSearch.clearForm();
						// requestGrid,reset();
					},
					beforeshow: function ( me, eOpts ) {
						productionPlanSearch.setValue('WORK_SHOP_CODE', panelResult.getValue('WORK_SHOP_CODE'));
						productionPlanStore.loadStoreRecords();
					}
				}
			})
		}
		referProductionPlanWindow.show();
		referProductionPlanWindow.center();
	}
	<%@include file="./pmp100ukrp2v.jsp"%>



	Unilite.Main ({
		id			: 'pmp100ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid, detailGrid2
			]
		}],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['query', 'newData'], false);
			detailGrid.disabledLinkButtons(false);

			panelResult.down('#btnWorkPlan').setDisabled(false);
			panelResult.down('#btnExp').setDisabled(false);
			panelResult.down('#btnPart').setDisabled(true);
			panelResult.down('#btnPrint').setDisabled(true);
			panelResult.down('#btnPrint2').setDisabled(true);

			this.setDefault(params);
		},
		fnProgSeqInfo: function(record){
			if(!record.get("ITEM_CODE")){
				return false;
			}
			var param= record.data;
			pmp110ukrvService.selectProgInfo(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider && provider.length > 0){
						provider.forEach(function(e){
							var r = e;
							if(!r.PROG_UNIT){
								r.PROG_UNIT = panelResult.getValue("PROG_UNIT");
							}
							r.WKORD_Q = record.get("WKORD_Q");
							r.PROG_RATE = 0;
							r.DIV_CODE = panelResult.getValue("DIV_CODE");
							r.WKORD_NUM = '';

							r.WORK_SHOP_CODE = record.get("WORK_SHOP_CODE");
							r.PRODT_START_DATE = record.get("PRODT_START_DATE");
							r.PRODT_END_DATE = record.get("PRODT_END_DATE");
							r.PRODT_WKORD_DATE = record.get("PRODT_START_DATE");
							r.ITEM_CODE = record.get("ITEM_CODE");
							r.REMARK = panelResult.getValue("REMARK");
							r.WK_PLAN_NUM = panelResult.getValue("WK_PLAN_NUM");
							r.LINE_END_YN = 'Y';
							r.ITEM_NAME = panelResult.getValue("ITEM_NAME");
							r.SPEC = panelResult.getValue("SPEC");
							r.WORK_END_YN = 'N';
							r.PROJECT_NO = panelResult.getValue("PROJECT_NO");
							r.PJT_CODE = panelResult.getValue("PJT_CODE");
							r.LOT_NO = panelResult.getValue("LOT_NO");
							r.SEQ_NO = record.get("SEQ_NO");
							r.TOP_WKORD_NUM = '';
							detailStore2.insert(detailStore2.getCount(), r);
							//UniAppManager.app.fnFindProgWork(record.data);
							//detailGrid2.createRow(r);
						})
					}
				}
			});
		},
		onQueryButtonDown: function() {
			if(panelResult.setAllFieldsReadOnly(true)){
				if(panelResult.getValue("PRODT_START_DATE")>panelResult.getValue("PRODT_END_DATE")){
					Unilite.messageBox('<t:message code="system.message.product.message021" default="착수예정일은 완료예정일보다 이후 날짜일 수 없습니다."/>');
					return false;
				}
				if(panelResult.getValue("PRODT_START_DATE")<panelResult.getValue("PRODT_WKORD_DATE")){
					Unilite.messageBox('<t:message code="system.message.product.message022" default="착수예정일은 작업지시일보다 이전 날짜일 수 없습니다."/>');
					return false;
				}
				if(panelResult.getValue("WKORD_Q")< 0){
					Unilite.messageBox('<t:message code="system.message.product.message023" default="입력한 값이 0보다 큰 수이어야 합니다."/>');
					return false;
				}
				if(!panelResult.getInvalidMessage())
					return false;

				detailGrid.getStore().loadStoreRecords();
			}
		},
		onNewDataButtonDown: function(p) {
			var record = detailGrid.getSelectedRecord();
			var store = detailGrid.getStore()
			var index = store.getCount();
			if(record){
				index = detailGrid.getStore().indexOf(record)+1;
			}
			var r = {};
			if(p){
				r = p;
			}
			store.insert(index,r);
			detailGrid.getSelectionModel().selectNext();
		},
		onResetButtonDown: function() {
			sWkordNum = null;
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailGrid2.reset();
			this.fnInitBinding();
			//panelResult.getField('CUSTOM_CODE').focus();
		},
		onSaveDataButtonDown: function(config) {
			var selectRecords = detailGrid.getSelectedRecords();
			if(Ext.isEmpty(selectRecords)){
				Unilite.messageBox('선택된 데이터가 없습니다.');
				return false;
			}
			var cnt = 0;
			Ext.each(selectRecords, function(record,index){
				if(Ext.isEmpty(record.get('WORK_SHOP_CODE'))){
					cnt += 1;
				}
			})
			if(cnt > 0){
				Unilite.messageBox('선택된 데이터의 작업장값을 확인해 주십시오');
				return false;
			}

			detailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			} else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('ISSUE_REQ_Q') > 0 || selRow.get('OUTSTOCK_Q') > 0 ) {
					Unilite.messageBox('<t:message code="system.message.product.message024" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
				} else {
					detailGrid.deleteSelectedRow();
				}
			}
			// fnOrderAmtSum 호출(grid summary 이용)
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('pmp100ukrvAdvanceSerch');
			if(as.isHidden()) {
				as.show();
			} else {
				as.hide()
			}
		},
		rejectSave: function() {
			var rowIndex = detailGrid.getSelectedRowIndex();
			detailGrid.select(rowIndex);
			detailStore.rejectChanges();

			if(rowIndex >= 0){
				detailGrid.getSelectionModel().select(rowIndex);
				var selected		= detailGrid.getSelectedRecord();
				var selected_doc_no	= selected.data['DOC_NO'];
				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {
					}
				);
			}
			detailStore.onStoreActionEnable();
		},
		confirmSaveData: function(config) {
			var fp = Ext.getCmp('pmp100ukrvFileUploadPanel');
			if(detailStore.isDirty() || fp.isDirty()) {
				if(confirm(Msg.sMB061)) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function(params) {
			if(Ext.isEmpty(BsaCodeInfo.gsUseWorkColumnYn) || BsaCodeInfo.gsUseWorkColumnYn != 'Y') {
				detailGrid.getColumn('PRODT_PRSN').setHidden(true);
				detailGrid.getColumn('PRODT_MACH').setHidden(true);
				detailGrid.getColumn('PRODT_TIME').setHidden(true);
				detailGrid.getColumn('DAY_NIGHT').setHidden(true);
			}
			panelResult.setValue('DIV_CODE',UserInfo.divCode);

			panelResult.setValue('PRODT_WKORD_DATE',new Date());
			panelResult.setValue('PRODT_START_DATE',new Date());
			panelResult.setValue('PRODT_END_DATE',new Date());
			panelResult.setValue('WKORD_Q',0);
			panelResult.setValue('PRODT_DATE',new Date());

			panelResult.getField('DIV_CODE').setReadOnly( false );
			panelResult.getField('WORK_SHOP_CODE').setReadOnly( false );
			panelResult.getField('ITEM_CODE').setReadOnly( false );
			panelResult.getField('ITEM_NAME').setReadOnly( false );

			//20190124 추가 : 화면 오픈 시, 거래처 필드 수정가능하도록 변경
			panelResult.getField('CUSTOM_CODE').setReadOnly( false );


			if(BsaCodeInfo.gsReportGubun == 'EXCEL'){
				panelResult.down('#btnPrint2').setHidden(true);
			}else{
				panelResult.down('#btnPrint2').setHidden(false);
			}

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);

			this.processParams(params);
		},
		processParams: function(params) {
			if(!Ext.isEmpty(params)){
				this.uniOpt.appParams = params;
				if(params.PGM_ID == 'ppl101ukrv') {
					panelResult.setValue('WORK_SHOP_CODE',params.WORK_SHOP_CODE);
					panelResult.setValue('ITEM_CODE',params.ITEM_CODE);
					panelResult.setValue('ITEM_NAME',params.ITEM_NAME);
					panelResult.setValue('SPEC',params.SPEC);
					panelResult.setValue('WKORD_Q',params.WKORD_Q);
					panelResult.setValue('PROG_UNIT',params.STOCK_UNIT);
				}
			}
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
				Unilite.messageBox('<t:message code="system.label.product.custom" default="거래처"/>:<t:message code="system.message.product.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}

			//여신한도 확인
			if(!panelResult.fnCreditCheck()) {
				return false;
			}

			//마스터 데이타 수정 못 하도록 설정
			return panelResult.setAllFieldsReadOnly(true);
		},
		fnDisable:function() {
			panelResult.setAllFieldsReadOnly(true,true);
			panelResult.down('#btnWorkPlan').setDisabled(true);
			panelResult.down('#btnExp').setDisabled(true);
			panelResult.down('#btnPart').setDisabled(false);
		},
		fnFindProgWork:function(p) {
			//if(detailStore2.getCount() == 0){
			//	detailGrid.getSelectionModel().deselect(gsRowIndex);
			//}
			if(!Ext.isEmpty(p) && p.WORK_SHOP_CODE == "") {
				detailGrid.getSelectionModel().deselect(gsRowIndex);
			}
			n=0;
			detailStore2.clearFilter();
			detailStore2.filterBy (function(record){
				if(!Ext.isEmpty(p)){
					if(p.SEQ_NO == record.get('SEQ_NO')){
						n=n+1;
						return true;
					} else{
						return false;
					}
				} else{
					return false;
				}
			});
			if(n == 0) {
                detailGrid.getSelectionModel().deselect(gsRowIndex);
			}
			//console.log("[selectRowIndex]" + gsRowIndex);
		},
		setDetailRecordFilter: function(record,fieldName,newValue){
			var detailRecords = detailGrid2.getStore().getData().items;

			if(detailRecords != null && detailRecords.length > 0){
				detailRecords.forEach(function(e){
						var dataObj = e.data;
						if(dataObj.SEQ_NO == record.get("SEQ_NO")){
							e.set(fieldName,newValue);
						}
				});
			}
		}
	});



	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			//console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if(newValue == oldValue){
				return rv;
			}
			//console.log(newValue +"+"+ oldValue);
			switch(fieldName) {
				case "DIV_CODE":
					record.set('WORK_SHOP_CODE','');


				break;
				case "WORK_SHOP_CODE":
//					if(workShopCodeCount==1){
						var param={
							"DIV_CODE"		: panelResult.getValue("DIV_CODE"),
							"WORK_SHOP_CODE": newValue,
							"ITEM_CODE"		: record.get("ITEM_CODE")
						}


	        	pmp110ukrvService.selectProgInfo(param, function(provider, response) {
	                if(!Ext.isEmpty(provider)){
	                	detailStore2.clearFilter();

	                	var records = detailStore2.data.items;
	                	//console.log('detailStore2.data.items.length >>> ' + String(records.length));
						for(var i = records.length-1; i>=0; i--){
							var e = records[i];
							//console.log('i >>> ' + String(i) + ', e.get("SEQ_NO") >>> ' + String(e.get("SEQ_NO")) + ', record.get("SEQ_NO") >>> ' + String(record.get("SEQ_NO")) + ', e.get("SEQ_NO") == record.get("SEQ_NO") >>> ' + String(e.get("SEQ_NO") == record.get("SEQ_NO")));
							if(e && e.get("SEQ_NO") == record.get("SEQ_NO")){
								console.log('removed detail Record >>> ', {'type':type, 'record':e});
								detailStore2.remove(e);
							}
						}

	                	provider.forEach(function(e){
	                		console.log('inserted detail Record >>> ', {'type':type, 'record':e});
							var r = e;

							if(!r.PROG_UNIT){
								r.PROG_UNIT = panelResult.getValue("PROG_UNIT");
							}
							r.WKORD_Q = record.get("WKORD_Q");
							r.PROG_RATE = 0;
							r.DIV_CODE = record.get("DIV_CODE");
							r.WKORD_NUM = '';

							r.WORK_SHOP_CODE = newValue;
							r.PRODT_START_DATE = record.get("PRODT_START_DATE");
							r.PRODT_END_DATE = record.get("PRODT_END_DATE");
							r.PRODT_WKORD_DATE = record.get("PRODT_START_DATE");
							r.ITEM_CODE = record.get("ITEM_CODE");
							r.REMARK = panelResult.getValue("REMARK");
							r.WK_PLAN_NUM = panelResult.getValue("WK_PLAN_NUM");
							r.LINE_END_YN = 'Y';
							r.ITEM_NAME = panelResult.getValue("ITEM_NAME");
							r.SPEC = panelResult.getValue("SPEC");
							r.WORK_END_YN = 'N';
							r.PROJECT_NO = panelResult.getValue("PROJECT_NO");
							r.PJT_CODE = panelResult.getValue("PJT_CODE");
							r.LOT_NO = panelResult.getValue("LOT_NO");
							r.SEQ_NO = record.get("SEQ_NO");
							r.TOP_WKORD_NUM = '';
							detailStore2.insert(detailStore2.getCount(), r);
							//detailGrid2.createRow(r);
							//UniAppManager.app.fnFindProgWork(record.obj.data);


							//var r = Ext.create(detailStore2.model);
							//r.set('PROG_UNIT', panelResult.getValue("PROG_UNIT"));
							//r.set('WKORD_Q', record.get("WKORD_Q"));
							//r.set('PROG_RATE', 0);
							//r.set('DIV_CODE', panelResult.getValue("DIV_CODE"));
							//r.set('WKORD_NUM', '');
							//r.set('WORK_SHOP_CODE', newValue);
							//r.set('PRODT_START_DATE', record.get("PRODT_START_DATE"));
							//r.set('PRODT_END_DATE', record.get("PRODT_END_DATE"));
							//r.set('PRODT_WKORD_DATE', record.get("PRODT_START_DATE"));
							//r.set('ITEM_CODE', record.get("ITEM_CODE"));
							//r.set('REMARK', panelResult.getValue("REMARK"));
							//r.set('WK_PLAN_NUM', panelResult.getValue("WK_PLAN_NUM"));
							//r.set('LINE_END_YN', 'Y');
							//r.set('ITEM_NAME', panelResult.getValue("ITEM_NAME"));
							//r.set('SPEC', panelResult.getValue("SPEC"));
							//r.set('WORK_END_YN', 'N');
							//r.set('PROJECT_NO', panelResult.getValue("PROJECT_NO"));
							//r.set('PJT_CODE', panelResult.getValue("PJT_CODE"));
							//r.set('LOT_NO', panelResult.getValue("LOT_NO"));
							//r.set('SEQ_NO', record.get("SEQ_NO"));
							//r.set('TOP_WKORD_NUM', '');

							//r.set('LINE_SEQ', e['LINE_SEQ']);
							//r.set('PROG_WORK_CODE', e['PROG_WORK_CODE']);
							//r.set('PROG_WORK_NAME', e['PROG_WORK_NAME']);
							//r.set('PROG_UNIT_Q', e['PROG_UNIT_Q']);

							//detailStore2.insert(detailStore2.getCount(), r);
						});

						detailStore2.filterBy (function(record){
							if(gsSeqNo > 0){
								if(gsSeqNo == record.get("SEQ_NO")){
									return true;
								} else{
									return false;
								}
							} else{
								return false;
							}
						});
	                } else{
						Unilite.messageBox('<t:message code="system.message.product.message025" default="해당 작업장에 대한 공정정보가 없습니다. 공정수순등록에서 공정정보를 입력하십시오."/>');
						record.set('WORK_SHOP_CODE',oldValue);
						return false;
					}
	        	});


						/*

						Ext.Ajax.request({
							url	 : CPATH+'/prodt/selectProgInfo.do',
							params	: param,
							async	: false,
							success : function(response){
								if(response.status == "200"){
									var provider = JSON.parse(response.responseText);
									if(provider && provider.length > 0){
										var records = detailStore2.data.items;
										for(var i = records.length-1; i>=0; i--){
											var e = records[i];
											if(e && e.get("SEQ_NO") == record.get("SEQ_NO")){
												detailStore2.remove(e);
											}
										}

										provider.forEach(function(e){
											var r = e;
											if(!r.PROG_UNIT){
												r.PROG_UNIT = panelResult.getValue("PROG_UNIT");
											}
											r.WKORD_Q = record.get("WKORD_Q");
											r.PROG_RATE = 0;
											r.DIV_CODE = panelResult.getValue("DIV_CODE");
											r.WKORD_NUM = '';

											r.WORK_SHOP_CODE = newValue;
											r.PRODT_START_DATE = record.get("PRODT_START_DATE");
											r.PRODT_END_DATE = record.get("PRODT_END_DATE");
											r.PRODT_WKORD_DATE = record.get("PRODT_START_DATE");
											r.ITEM_CODE = record.get("ITEM_CODE");
											r.REMARK = panelResult.getValue("REMARK");
											r.WK_PLAN_NUM = panelResult.getValue("WK_PLAN_NUM");
											r.LINE_END_YN = 'Y';
											r.ITEM_NAME = panelResult.getValue("ITEM_NAME");
											r.SPEC = panelResult.getValue("SPEC");
											r.WORK_END_YN = 'N';
											r.PROJECT_NO = panelResult.getValue("PROJECT_NO");
											r.PJT_CODE = panelResult.getValue("PJT_CODE");
											r.LOT_NO = panelResult.getValue("LOT_NO");
											r.SEQ_NO = record.get("SEQ_NO");
											r.TOP_WKORD_NUM = '';
											detailStore2.insert(detailStore2.getCount(), r);
											UniAppManager.app.fnFindProgWork(record.obj.data);
											//detailGrid2.createRow(r);
										})



									} else{
										rv='<t:message code="system.message.product.message025" default="해당 작업장에 대한 공정정보가 없습니다. 공정수순등록에서 공정정보를 입력하십시오."/>';
									}
								}
							}
						});



						*/

//					}
//					workShopCodeCount++;
//					if(workShopCodeCount==4){
//						workShopCodeCount=1
//					}
//					if(rv != true){
//						workShopCodeCount=1;
//					}

				break;

				case "PRODT_START_DATE" :
					var sPlWkordDt = newValue;
					var sEnWkordDt = record.get("PRODT_END_DATE");
					var sEnMasterDt = panelResult.getValue("PRODT_END_DATE");
					var txtStWkordDt = panelResult.getValue("PRODT_START_DATE");
					var txtWkOrdDate = panelResult.getValue("PRODT_WKORD_DATE");
					if(sPlWkordDt >　sEnWkordDt){
						rv='<t:message code="system.message.product.message021" default="착수예정일은 완료예정일보다 이후 날짜일 수 없습니다."/>';
						break;

					} else if(sEnWkordDt >　sEnMasterDt){
						rv='<t:message code="system.message.product.message026" default="완료예정일이 범위를 초과했습니다."/>';
						break;

					} else if(txtWkOrdDate >　sPlWkordDt){
						rv='<t:message code="system.message.product.message022" default="착수예정일은 작업지시일보다 이전 날짜일 수 없습니다."/>';
						break;
					}

					UniAppManager.app.setDetailRecordFilter(record,fieldName,newValue);

				break;

				case "PRODT_END_DATE" :
					var sPlWkordDt = record.get("PRODT_START_DATE");
					var sEnWkordDt = newValue;
					var sEnMasterDt = panelResult.getValue("PRODT_END_DATE");
					var txtStWkordDt = panelResult.getValue("PRODT_START_DATE");
					if(sPlWkordDt >　sEnWkordDt){
						rv='<t:message code="system.message.product.message021" default="착수예정일은 완료예정일보다 이후 날짜일 수 없습니다."/>';
						break;

					} else if(sEnWkordDt >　sEnMasterDt){
						rv='<t:message code="system.message.product.message026" default="완료예정일이 범위를 초과했습니다."/>';
						break;

					}

					/*
					else if(txtStWkordDt >　sPlWkordDt){
						rv='<t:message code="system.message.product.message022" default="착수예정일은 작업지시일보다 이전 날짜일 수 없습니다."/>';
						break;
					}
					*/

					UniAppManager.app.setDetailRecordFilter(record,fieldName,newValue);
				break;

				case "WKORD_Q" :
					if(newValue <= 0){
						rv=Msg.sMB074;
						break;
					}

					var records = detailStore2.data.items;
					Ext.each(records, function(r,i){
						if(r.get("SEQ_NO") == record.get("SEQ_NO")){
							r.set('WKORD_Q',(newValue * r.get("PROG_UNIT_Q")));
						}
					});
				break;
				default:
				break;
			}
			return rv;
		}
	}); // validator
	
	
	//20210426 추가: 날짜 우선순위 체크로직, 20210428 수정: 수정하는 필드에 따라서 체크로직 변경하도록 수정 (FLAG)
	function checkDateSeq(FLAG) {
		var prodtWkordDate	= panelResult.getValue('PRODT_WKORD_DATE');		//작업지시일
		var prodtStartDate	= panelResult.getValue('PRODT_START_DATE');		//착수예정일
		var prodtDate		= panelResult.getValue('PRODT_DATE');			//제조일자
		var prodtEndDate	= panelResult.getValue('PRODT_END_DATE');		//완료예정일
		var exprrationDate	= panelResult.getValue('EXPIRATION_DATE');		//유통기한

		//(참고) Uilite.messageBox로 처리했을 때 메세지가 2번 발생하여 alert 사용
		if(prodtWkordDate > prodtStartDate && !Ext.isEmpty(prodtWkordDate) && !Ext.isEmpty(prodtStartDate)){
			//20210428 수정
			if(FLAG == '2') {
				alert('<t:message code="system.message.product.message022" default="착수예정일은 작업지시일보다 이전 날짜일 수 없습니다."/>');
				return false;
			} else {
				panelResult.setValue('PRODT_START_DATE'	, prodtWkordDate);
				panelResult.setValue('PRODT_END_DATE'	, prodtWkordDate);
				var store = detailGrid.getStore();
				Ext.each(store.data.items, function(record, index) {
					record.set('PRODT_START_DATE', prodtWkordDate);
					record.set('PRODT_END_DATE', prodtWkordDate);
				});
				return true;
			}
//			alert('<t:message code="system.message.product.message022" default="착수예정일은 작업지시일보다 이전 날짜일 수 없습니다."/>');
//			return false;
		} else if(prodtWkordDate > prodtEndDate && !Ext.isEmpty(prodtWkordDate) && !Ext.isEmpty(prodtEndDate)){
			//20210428 수정
			if(FLAG == '4') {
				alert('완료예정일은 작업지시일보다 이전 날짜일 수 없습니다.');
				return false;
			} else {
				panelResult.setValue('PRODT_END_DATE', prodtWkordDate);
				var store = detailGrid.getStore();
				Ext.each(store.data.items, function(record, index) {
					record.set('PRODT_END_DATE', prodtWkordDate);
				});
				return true;
			}
//			alert('완료예정일은 작업지시일보다 이전 날짜일 수 없습니다.');
//			return false;
		} else if(prodtStartDate > prodtEndDate && !Ext.isEmpty(prodtStartDate) && !Ext.isEmpty(prodtEndDate)){
			//20210428 수정
			if(FLAG == '4') {
				alert('<t:message code="system.message.product.message021" default="착수예정일은 완료예정일보다 이후 날짜일 수 없습니다."/>');
				return false;
			} else {
				panelResult.setValue('PRODT_END_DATE', prodtStartDate);
				var store = detailGrid.getStore();
				Ext.each(store.data.items, function(record, index) {
					record.set('PRODT_END_DATE', prodtStartDate);
				});
				return true;
			}
//			alert('<t:message code="system.message.product.message021" default="착수예정일은 완료예정일보다 이후 날짜일 수 없습니다."/>');
//			return true;
//		} else if(prodtDate < prodtStartDate && !Ext.isEmpty(prodtDate) && !Ext.isEmpty(prodtStartDate)){			//20210428 주석
//			alert('제조일자는 착수예정일 이전 날짜일 수 없습니다.');
//			return false;
		} else if(exprrationDate < prodtEndDate && !Ext.isEmpty(exprrationDate) && !Ext.isEmpty(prodtEndDate)){
			//20210428 수정
			if(FLAG == '4') {
				panelResult.setValue('EXPIRATION_DATE', prodtEndDate);
				var store = detailGrid.getStore();
				Ext.each(store.data.items, function(record, index) {
					record.set('EXPIRATION_DATE', prodtEndDate);
				});
				return true;
			} else {
				alert('<t:message code="system.message.product.message021" default="착수예정일은 완료예정일보다 이후 날짜일 수 없습니다."/>');
				return false;
			}
//			alert('유통기한은 완료예정일 이전 날짜일 수 없습니다.');
//			return false;
//		} else if(exprrationDate < prodtDate && !Ext.isEmpty(exprrationDate) && !Ext.isEmpty(prodtDate)){			//20210428 주석
//			alert('유통기한은 제조일자 이전 날짜일 수 없습니다.');
//			return false;
		} else { 
			return true;
		}
	}
};

</script>