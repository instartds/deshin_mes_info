<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp260ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="pmp260ukrv" />			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore comboType="WU" /><!-- 작업장-->
	<t:ExtComboStore comboType="AU" comboCode="B013"/> <!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B014"/> <!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A" />	<!-- 가공창고 -->
	<t:ExtComboStore comboType="AU" comboCode="P120"/> <!-- 대체여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" storeId="itemAccountPrintStore"/>  <!-- 품목계정  -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript" src="<c:url value='/resources/js/jsbarcode/jquery-barcode.js' />" ></script>
<script type="text/javascript" >


var searchInfoWindow;	//SearchInfoWindow : 검색창
var referProductionPlanWindow;//생산계획참조
var wkordBarcodeWindow;//제조지시 바코드 팝업
var searchOrderWindow;
var loadChk = 'N';//작업지시량 수정시 디테일 항목의 작업지시량도 변화되는데 항상 체크로직에 타지 않도록 수정

var gswkordnumflag = '';
var gsoprflag = '';

var BsaCodeInfo = {
	gsUseWorkColumnYn	: '${gsUseWorkColumnYn}',	//작업 관련컬럼(작업자, 작업호기, 작업시간, 주야구분) 사용여부
	gsAutoType			: '${gsAutoType}',
	gsAutoNo			: '${gsAutoNo}',			//생산자동채번여부
	gsBadInputYN		: '${gsBadInputYN}',		//자동입고시 불량입고 반영여부
	gsChildStockPopYN	: '${gsChildStockPopYN}',	//자재부족수량 팝업 호출여부
	gsShowBtnReserveYN	: '${gsShowBtnReserveYN}',	//BOM PATH 관리여부
	gsManageLotNoYN		: '${gsManageLotNoYN}',		//재고와 작업지시LOT 연계여부

	gsLotNoInputMethod	: '${gsLotNoInputMethod}',	//LOT 연계여부
	gsLotNoEssential	: '${gsLotNoEssential}',
	gsEssItemAccount	: '${gsEssItemAccount}',

	gsLinkPGM			: '${gsLinkPGM}',			//등록 PG 내 링크 ID 설정
	gsGoodsInputYN		: '${gsGoodsInputYN}',		//상품등록 가능여부
	gsSetWorkShopWhYN	: '${gsSetWorkShopWhYN}',	//작업장의 가공창고 설정여부
	gsMoldCode			: '${gsMoldCode}',			//작업지시 설비여부
	gsEquipCode			: '${gsEquipCode}',			//작업지시 금형여부
	gsReportGubun		: '${gsReportGubun}',		//레포트 구분
	gsCompName			: '${gsCompName}',			//출력 관련해서 제이월드 report만 따로 사용... 하기 위해 comp_name 가져오는 로직

	gsSiteCode			: '${gsSiteCode}',
	gsIfCode			: '${gsIfCode}',            //작업지시데이터 연동여부
	gsIfSiteCode		: '${gsIfSiteCode}'         //작업지시데이터 연동주소
};


var refItemWindow;  //벌크품목 팝업
//var output ='';
//for(var key in BsaCodeInfo){
// output += key + ':' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

function appMain() {

	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoOrderNum = true;
	}

	var isMoldCode = false;
	if(BsaCodeInfo.gsMoldCode=='N') {
		isMoldCode = true;
	}

	var isEquipCode = false;
	if(BsaCodeInfo.gsEquipCode=='N') {
		isEquipCode = true;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'pmp260ukrvService.selectDetailList',
			update	: 'pmp260ukrvService.updateDetail',
			create	: 'pmp260ukrvService.insertDetail',
			destroy	: 'pmp260ukrvService.deleteDetail',
			syncAll	: 'pmp260ukrvService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmp260ukrvService.selectWorkNum'
		}
	});

	//20170517 - 사용 안 함(주석)
	/*var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmp260ukrvService.selectProgInfo'
		}
	});*/

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3
//			, tdAttrs: {style: 'border : 1px solid #ced9e7;'}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
				xtype	: 'uniTextfield',
				name	: 'WK_PLAN_NUM',
				hidden	: true
			},{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name: 'DIV_CODE',
				value : UserInfo.divCode,
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				colspan: 2,
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
							var param = {"S_COMP_CODE": UserInfo.compCode,
	                         "DIV_CODE": newValue};
							pmp260ukrvService.selectIfSite(param, function(provider, response) {
								var records = response.result;
								if(!Ext.isEmpty(provider)) {
									Ext.each(records, function(record,i) {

									BsaCodeInfo.gsIfCode =  provider[0]['REF_CODE1'];
									BsaCodeInfo.gsIfSiteCode =  provider[0]['REF_CODE2'];
										});
								}
							});
					}
				}
			},{
			xtype: 'container',
			rowspan: 5,
			layout: {type: 'uniTable', columns:2},
			items: [{
				title: '<t:message code="system.label.product.reference2" default="참고사항"/>',
				margin: '0 0 0 200',
				xtype: 'uniFieldset',
				itemId:'personalForm_1',
				layout:{type: 'uniTable', columns:1, tableAttrs:{cellpadding:1}, tdAttrs: {valign:'top'}},
				autoScroll:false,
				defaultType:'uniTextfield',
				items:[{
					xtype: 'container',
					layout: {type: 'uniTable', columns: 1},
					items: [{
			            fieldLabel: '수주번호',
			            name: 'ORDER_NUM',
			            xtype: 'uniTextfield',
//2020-11-18 작업지시 이중저장오류 원인 확인하기 위해 readOnly처리함
			            readOnly : true,
//2020-11-18 END
			            listeners: {
//2020-11-18 작업지시 이중저장오류 원인 확인하기 위해 임시로 수주번호 수정로직 주석처리함
//			                render: function(p) {
//			                    p.getEl().on('click', function(p) {
//			                    	 if(Ext.isEmpty(panelResult.getValue('ORDER_NUM'))){
//			                         openSearchOrderWindow();
//			                    	 }
//		                    });
//			                }
//2020-11-18 END

//			                change: function(field, newValue, oldValue, eOpts) {
//			                    if (Ext.isEmpty(newValue)) {
//			                        masterForm.setValues({
//						                'ORDER_NUM': '',
//						                'PROJECT_NO': '',
//						                'FR_DATE': '',
//						                'TO_DATE': '',
//						                'AS_CUSTOMER_CD': '',
//						                'AS_CUSTOMER_NAME': ''
//									});
//			                    }
//			                }
			            }
			        },

					/*				{
						fieldLabel: '<t:message code="system.label.product.sono" default="수주번호"/>',
						xtype: 'uniTextfield',
						name: 'ORDER_NUM',
//								holdable: 'hold'
						readOnly : true
					},*/{
						fieldLabel: 'ORDER_SEQ',
						xtype: 'uniTextfield',
						name: 'ORDER_SEQ',
						hidden: true,
						readOnly : true
					},{
						fieldLabel: '<t:message code="system.label.product.soqty" default="수주량"/>',
						xtype: 'uniNumberfield',
						name: 'ORDER_Q',
						readOnly : true,
						value: '0.00'
					},{
						fieldLabel: '<t:message code="system.label.product.deliverydate" default="납기일"/>',
						xtype: 'uniDatefield',
						name: 'DVRY_DATE',
						readOnly : true
					},{
						fieldLabel: '<t:message code="system.label.product.custom" default="거래처"/>',
						xtype: 'uniTextfield',
						name: 'CUSTOM_NAME',
						colspan: 1,
						readOnly : true,
						//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터)
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								var cgCustom = panelResult.getValue('CUSTOM_NAME');
//								if(Ext.isEmpty(cgCustom)) return false;

								var records = detailStore.data.items;
								Ext.each(records, function(record,i){
									record.set('CUSTOM_NAME',cgCustom);
								});
							}
						}
					},{
						fieldLabel: 'CUSTOM_CODE',
						xtype: 'uniTextfield',
						name: 'CUSTOM_CODE',
						hidden:true
					}]
				}]
			}]
		},{
			fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			xtype: 'uniTextfield',
			name: 'WKORD_NUM',
			colspan: BsaCodeInfo.gsSiteCode == 'KODI'? 1 : 3,
			holdable: 'hold',
			readOnly: isAutoOrderNum,
			holdable: isAutoOrderNum ? 'readOnly':'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(newValue)){
						if(BsaCodeInfo.gsReportGubun == 'CLIP'){
							UniAppManager.setToolbarButtons(['printPreview'],true);
							UniAppManager.setToolbarButtons(['directPrint'],true);
						}else{
							UniAppManager.setToolbarButtons(['print'],true);
						}
					}

				}
			}
		},{
				xtype:'button',
				text:'<div style="color: red">제조지시 바코드</div>',
				disabled:false,
				itemId:'btnWkordBarcode',
				width: 100,
				hidden: BsaCodeInfo.gsSiteCode == 'KODI'? false : true,
				margin: '0, 0, 0, -300',
				handler: function(){
					if(!Ext.isEmpty(panelResult.getValue('WKORD_NUM'))){
						openWkordBarcodeWindow();
					}else{
						Unilite.messageBox('작업지시번호가 비어 있습니다.' + '\n' + '작업지시내역을 조회하신 다음 다시 시도해주세요.');
					}
				}
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType: 'WU',
			holdable: 'hold',
			colspan: 3,
			allowBlank:false,
			listeners: {
				beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						store.clearFilter();
						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						 store.filterBy(function(record){
							 return record.get('option') == panelResult.getValue('DIV_CODE');
						})
					}else{
						store.filterBy(function(record){
							return false;
					})
					}
				}
			}
		},
				//{
//				xtype: 'radiogroup',
//				fieldLabel: '<t:message code="system.label.product.reworkorderyn" default="재작업지시여부"/>',
//				id:'rework1',
//				items: [{
//					boxLabel: '<t:message code="system.label.product.yes" default="예"/>',
//					width: 70,
//					name: 'REWORK_YN',
//					inputValue: 'Y'
//				},{
//					boxLabel : '<t:message code="system.label.product.no" default="아니오"/>',
//					width: 70,
//					name: 'REWORK_YN',
//					inputValue: 'N',
//					checked: true
//				}],
//				listeners: {
//					change: function(field, newValue, oldValue, eOpts) {
//
//						panelResult.getField('REWORK_YN').setValue(newValue.REWORK_YN);
//
//						if(Ext.getCmp('reworkRe').getChecked()[0].inputValue =='Y'){
//							panelSearch.getField('EXCHG_TYPE').setReadOnly( false );
//							panelSearch.setValue('EXCHG_TYPE', "B");
//
//							panelResult.getField('EXCHG_TYPE').setReadOnly( false );
//							panelResult.setValue('EXCHG_TYPE', "B");
//
//						}else if(Ext.getCmp('reworkRe').getChecked()[0].inputValue =='N'){
//							panelSearch.setValue('EXCHG_TYPE', "");
//							panelSearch.getField('EXCHG_TYPE').setReadOnly( true );
//
//							panelResult.setValue('EXCHG_TYPE', "");
//							panelResult.getField('EXCHG_TYPE').setReadOnly( true );
//
//						}
//					}
//				}
//			},
			{
				xtype: 'container',
				layout: { type: 'uniTable', columns: 2},
				defaultType: 'uniTextfield',
				defaults : {enforceMaxLength: true},
//				colspan: 3,
				items:[
					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
						valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						holdable: 'hold',
						valueFieldWidth:150,
						textFieldWidth:170,
						allowBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('SPEC',records[0]["SPEC"]);
									panelResult.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);
									panelResult.setValue('LOT_NO', '');
									panelResult.getField('PRODT_DATE').focus();
									panelResult.getField('PRODT_DATE').blur();
								},
								scope: this
							},
							onClear: function(type) {

								panelResult.setValue('SPEC','');
								panelResult.setValue('PROG_UNIT','');
								panelResult.setValue('LOT_NO', '');

							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
						}
				}),{
					name:'SPEC',
					xtype:'uniTextfield',
					holdable: 'hold',
					readOnly:true
				}]
			},{
				xtype: 'container',
				layout: { type: 'uniTable', columns: 2},
				colspan: 2,
				items:[{
					fieldLabel: '벌크품목',
					xtype: 'uniTextfield',
		            name: 'REF_ITEM_CODE',
//				 	allowBlank:false,
					listeners: {
						render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                 openRefItemWindow();
                            });
                        }
					}
				},{
					fieldLabel: '',
					xtype: 'uniTextfield',
		            name: 'REF_ITEM_NAME',
//				 	allowBlank:false,
					listeners: {
						render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                 openRefItemWindow();
                            });
                        }
					}
				}]
			},{
				fieldLabel: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
				xtype: 'uniDatefield',
				name: 'PRODT_WKORD_DATE',
				labelWidth: 90,
//				holdable: 'hold',
				allowBlank:false,
				value: new Date(),
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
				fieldLabel: '<t:message code="system.label.product.mfglotnum" default="제조LOT번호"/>',
				xtype:'uniTextfield',
//				labelWidth: 400,
				name: 'LOT_NO',
				colspan: 2,
//				holdable: 'hold',
//				readOnly: isAutoOrderNum,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						var store = detailGrid.getStore();
						UniAppManager.app.suspendEvents();
						Ext.each(store.data.items, function(record, index) {
							record.set('LOT_NO', panelResult.getValue('LOT_NO'));
						});
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype: 'uniDatefield',
				name: 'PRODT_START_DATE',
//				holdable: 'hold',
				allowBlank:false,
				value: new Date(),  //20210426 수정: 날짜 입력
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
				fieldLabel: '<t:message code="system.label.product.makedate" default="제조일자"/>',
				xtype: 'uniDatefield',
				name: 'PRODT_DATE',
//				labelWidth: 400,
//				holdable: 'hold',
				colspan: 1,
				listeners: {
					//20210426 수정: 필드변경 관련 로직 수정
					focus: function(field, event, eOpts) {
						if(Ext.isEmpty(panelResult.getValue('ITEM_CODE'))){
							alert('작업지시를 할 품목을 입력해주세요.');
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
			},{
				xtype: 'container',
				rowspan: 4,
				layout: {type: 'uniTable', columns:1},
				margin: '25, 0, 0, 50',
				items: [{
							xtype:'button',
							text:'<div style="color: blue"><t:message code="system.label.product.packagingorder" default="포장지시서"/></div>',
							disabled:false,
							itemId:'btnPrint1',
							width: 100,
							hidden: false,
							margin: '-30, 0, 0, 230',
							handler: function(){
							  if(!panelResult.getInvalidMessage()) return;   //필수체크
							  		sTopWkordNum = panelResult.getValue("WKORD_NUM");
									  if(Ext.isEmpty(sTopWkordNum)){
									      Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
									      return;
									  }
								    if(!panelResult.getInvalidMessage()) return;   //필수체크
								  		sTopWkordNum = panelResult.getValue("WKORD_NUM");
										  if(Ext.isEmpty(sTopWkordNum)){
										      Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
										      return;
										  }


								if(BsaCodeInfo.gsSiteCode == 'NOVIS' || BsaCodeInfo.gsSiteCode == 'COV'){
									var param = panelResult.getValues();
									if(BsaCodeInfo.gsCompName == '(주)제이월드'){
										param["DEPT_NAME"] = '1';
									}else{
										param["DEPT_NAME"] = '0';
									}
									param["USER_LANG"] = UserInfo.userLang;
									param["PGM_ID"]= PGM_ID;
									param["MAIN_CODE"] = 'P010';//생산용 공통 코드
									param["sTxtValue2_fileTitle"]='작업지시서';
									var win = null;
									if(BsaCodeInfo.gsReportGubun == 'CLIP'){
										win = Ext.create('widget.ClipReport', {
											url: CPATH+'/prodt/pmp110clrkrv.do',
											prgID: 'pmp260ukrv',
											extParam: param
										});
									}else{
										win = Ext.create('widget.CrystalReport', {
											url: CPATH + '/prodt/pmp110crkrv.do',
											extParam: param
										});
									}

									win.center();
									win.show();
								}else{

								  var param = {
										  WKORD_NUM	: sTopWkordNum,
										  ITEM_CODE : panelResult.getValue("ITEM_CODE"),
										  DIV_CODE : panelResult.getValue("DIV_CODE"),
										  USER_LANG : UserInfo.userLang,
										  PGM_ID : PGM_ID,
										  MAIN_CODE : 'P010',//생산용 공통 코드
									      sTxtValue2_fileTitle : '<t:message code="system.label.product.packagingorder" default="포장지시서"/>'
										}
									var win = null;
									win = Ext.create('widget.ClipReport', {
										url: CPATH+'/prodt/pmp260clrkrv_1.do',
										prgID: 'pmp260ukrv',
										extParam: param
									});
									win.center();
									win.show();
								}

							}
						},{
							xtype:'button',
							text:'<div style="color: red"><t:message code="system.label.product.mfgorder" default="작업지시서"/></div>',
							disabled:false,
							itemId:'btnPrint2',
							width: 100,
							hidden: false,
							margin: '-20, 0, 0, 230',
							handler: function(){
							  if(!panelResult.getInvalidMessage()) return;   //필수체크
							  		sTopWkordNum = panelResult.getValue("WKORD_NUM");
									  if(Ext.isEmpty(sTopWkordNum)){
									      Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
									      return;
									  }
									/*   var selRecord = detailGrid.getStore().getAt(0)
									  if(selRecord.get('PROD_DRAW_YN') == 'N'){
										  alert('품목 ' + panelResult.getValue('ITEM_CODE')  + '[' + panelResult.getValue('ITEM_NAME') + ']의\n공정도가 등록돼 있지 않습니다.');
										  return false;
									  } */
									  var param = {
											  WKORD_NUM	: sTopWkordNum,
											  ITEM_CODE : panelResult.getValue("ITEM_CODE"),
											  DIV_CODE : panelResult.getValue("DIV_CODE"),
											  USER_LANG : UserInfo.userLang,
											  PGM_ID : PGM_ID,
											  MAIN_CODE : 'P010',//생산용 공통 코드
										      sTxtValue2_fileTitle : '<t:message code="system.label.product.mfgorder" default="작업지시서"/>'
											}
										var win = null;
										win = Ext.create('widget.ClipReport', {
											url: CPATH+'/prodt/pmp260clrkrv_2.do',
											prgID: 'pmp260ukrv',
											extParam: param
										});
										win.center();
										win.show();
							}
						},{
							xtype:'button',
							text:'<div style="color: red"><t:message code="system.label.product.weighingorder" default="칭량지시서"/></div>',
							disabled:true,
							itemId:'btnPrint3',
							width: 100,
							hidden: false,
							margin: '-10, 0, 0, 230',
							handler: function(){
							  if(!panelResult.getInvalidMessage()) return;   //필수체크
							  		sTopWkordNum = panelResult.getValue("WKORD_NUM");
									  if(Ext.isEmpty(sTopWkordNum)){
									      Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
									      return;
									  }
									  var param = {
											  WKORD_NUM	: sTopWkordNum,
											  ITEM_CODE : panelResult.getValue("ITEM_CODE"),
											  USER_LANG : UserInfo.userLang,
											  DIV_CODE : panelResult.getValue("DIV_CODE"),
											  PGM_ID : 'pmp260ukrv_3',
											  MAIN_CODE : 'P010',//생산용 공통 코드
										      sTxtValue2_fileTitle : '<t:message code="system.label.product.weighingorder" default="칭량지시서"/>'
											}
										var win = null;
										win = Ext.create('widget.ClipReport', {
											url: CPATH+'/prodt/pmp260clrkrv_3.do',
											prgID: 'pmp260ukrv',
											extParam: param
										});
										win.center();
										win.show();
							}
						},{
							xtype:'button',
							text:'<div style="color: red"><t:message code="system.label.product.mfgorder" default="제조지시서"/><t:message code="system.label.product.old" default="(구)"/></div>',
							disabled:false,
							itemId:'btnPrint4',
							width: 100,
							hidden: false,
							margin: '0, 0, 0, 230',
							handler: function(){
							  if(!panelResult.getInvalidMessage()) return;   //필수체크
							  		sTopWkordNum = panelResult.getValue("WKORD_NUM");
									  if(Ext.isEmpty(sTopWkordNum)){
									      Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
									      return;
									  }
									  var selRecord = detailGrid.getStore().getAt(0)
									  if(selRecord.get('PROD_DRAW_YN') == 'N'){
										  Unilite.messageBox('품목 ' + panelResult.getValue('ITEM_CODE')  + '[' + panelResult.getValue('ITEM_NAME') + ']의\n공정도가 등록돼 있지 않습니다.');
										  return false;
									  }
									  var param = {
											  WKORD_NUM	: sTopWkordNum,
											  ITEM_CODE : panelResult.getValue("ITEM_CODE"),
											  USER_LANG : UserInfo.userLang,
											  DIV_CODE : panelResult.getValue("DIV_CODE"),
											  PGM_ID : PGM_ID,
											  MAIN_CODE : 'P010',//생산용 공통 코드
										      sTxtValue2_fileTitle : '<t:message code="system.label.product.mfgorder" default="작업지시서"/><t:message code="system.label.product.old" default="(구)"/>'
											}
										var win = null;
										win = Ext.create('widget.ClipReport', {
											url: CPATH+'/prodt/pmp260clrkrv_4.do',
											prgID: 'pmp260ukrv',
											extParam: param
										});
										win.center();
										win.show();
							}
						}]
			},{
				fieldLabel: '<t:message code="system.label.product.completiondate" default="완료예정일"/>',
				xtype: 'uniDatefield',
				name: 'PRODT_END_DATE',
//				holdable: 'hold',
				allowBlank:false,
				value: new Date(),
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
				fieldLabel: '<t:message code="system.label.product.expirationdate" default="유통기한"/>',
				xtype: 'uniDatefield',
				name: 'EXPIRATION_DATE',
//				labelWidth: 400,
//				holdable: 'hold',
				colspan: 3,
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
			},{
				xtype: 'container',
				layout: { type: 'uniTable', columns: 2},
				defaultType: 'uniTextfield',
				defaults : {enforceMaxLength: true},
				items:[{
					fieldLabel: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
					xtype: 'uniNumberfield',
					name: 'WKORD_Q',
					value: '0.00',
					holdable: 'hold',
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if(loadChk == 'N'){
								var cgWkordQ = panelResult.getValue('WKORD_Q');

								if(Ext.isEmpty(cgWkordQ)) return false;
								var records = detailStore.data.items;

								Ext.each(records, function(record,i){
									record.set('WKORD_Q',(cgWkordQ * record.get("PROG_UNIT_Q")));
								});
							}
						}
					}
				},{
					name:'PROG_UNIT',
					xtype:'uniTextfield',
					holdable: 'hold',
					width: 50,
					readOnly:true,
					fieldStyle: 'text-align: center;'
				}]
			},{
				fieldLabel: '<t:message code="system.label.product.entryuser" default="등록자"/>',
//				labelWidth: 400,
				name: 'WKORD_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'P510',
				colspan: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						var store = detailGrid.getStore();
						Ext.each(store.data.items, function(record, index) {
							record.set('WKORD_PRSN', newValue);
						});
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.specialremark" default="특기사항"/>',
				xtype:'uniTextfield',
				name: 'ANSWER',
				holdable: 'hold',
				width: 565,
				height: 80,
				colspan: 2,
				rowspan:2,
				autoscroll:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						var cgRemark = panelResult.getValue('ANSWER');
						if(Ext.isEmpty(cgRemark)) return false;

						var records = detailStore.data.items;
						Ext.each(records, function(record,i){
							record.set('REMARK',cgRemark);
						});
					}
				}
			},{
				xtype: 'component',
				width: 100,
				height: 40
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.product.reworkorderyn" default="재작업지시여부"/>',
				id:'reworkRe',
				labelWidth: 300,
				items: [{
					boxLabel: '<t:message code="system.label.product.yes" default="예"/>',
					width: 70,
					name: 'REWORK_YN',
					inputValue: 'Y'
				},{
					boxLabel : '<t:message code="system.label.product.no" default="아니오"/>',
					width: 70,
					name: 'REWORK_YN',
					inputValue: 'N',
					checked: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.REWORK_YN =='Y'){

							panelResult.getField('EXCHG_TYPE').setReadOnly( false );
							panelResult.setValue('EXCHG_TYPE', "B");

						}else if(newValue.REWORK_YN =='N'){

							panelResult.setValue('EXCHG_TYPE', "");
							panelResult.getField('EXCHG_TYPE').setReadOnly( true );
						}
					}
				}
			},
			Unilite.popup('PROJECT',{
					fieldLabel: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>',
					valueFieldName: 'PJT_CODE',
//					holdable: 'hold',

					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							var store = detailGrid.getStore();
							Ext.each(store.data.items, function(record, index) {
								record.set('PJT_CODE', newValue);
							});
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
			}),
			/*Unilite.popup('LOT_NO',{
					fieldLabel: 'LOT_NO',
					valueFieldName: 'LOT_NO',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelSearch.setValue('LOT_NO', panelResult.getValue('LOT_NO'));
							},
							scope: this
						},
						onClear: function(type) {
							panelSearch.setValue('LOT_NO', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							popup.setExtParam({'ITEM_CODE': panelSearch.getValue('ITEM_CODE')});
							popup.setExtParam({'ITEM_NAME': panelSearch.getValue('ITEM_NAME')});
						}
					}
			})*/{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.product.forceclosing" default="강제마감"/>',
//				labelWidth: 400,
				id:'workEndYnRe',
				items: [{
					boxLabel: '<t:message code="system.label.product.yes" default="예"/>',
					width: 70,
					name: 'WORK_END_YN',
					inputValue: 'Y',
					readOnly : true
				},{
					boxLabel : '<t:message code="system.label.product.no" default="아니오"/>',
					width: 70,
					name: 'WORK_END_YN',
					inputValue: 'N',
					checked: true,
					readOnly : true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!panelResult.uniOpt.inLoading) {
							var msg = '작업지시를 마감하시겠습니까?';
							if(newValue.WORK_END_YN == 'N') {
								msg = '작업지시를 취소하시겠습니까?';
							}
							if(confirm(msg)){
								if(!Ext.isEmpty(panelResult.getValue("DIV_CODE")) && !Ext.isEmpty(panelResult.getValue("WKORD_NUM"))) {
									var param = {
										'DIV_CODE' : panelResult.getValue("DIV_CODE"),
										'WKORD_NUM': panelResult.getValue("WKORD_NUM"),
										'WORK_END_YN' : newValue.WORK_END_YN
									}
									pmp260ukrvService.closeWok(param, function(respnseText, response){
										UniAppManager.app.onQueryButtonDown();
									});
								} else {
									Unilite.messageBox('<t:message code="system.label.product.division" default="사업장"/>, <t:message code="system.label.product.workorderno" default="작업지시번호"/> 를 입력하세요.')

								}
							}
							else{
								setTimeout(function() {
									panelResult.uniOpt.inLoading = true;
									field.setValue({WORK_END_YN:oldValue.WORK_END_YN});
									panelResult.uniOpt.inLoading = false;
								},10);
							}
						}
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.inventoryexchangetype" default="재고대체유형"/>',
				labelWidth: 300,
				name:'EXCHG_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU' ,
				comboCode:'P120',
				holdable: 'hold',
				hidden : false,
				readOnly : true
			},{
				xtype: 'component',
				colspan: 3,
				padding: '0 0 0 0',
				height: 3
//			tdAttrs: {style: 'border-top: 1px solid #cccccc;padding-top: 2px;' }
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
						Unilite.messageBox(labelText+Msg.sMB083);
						invalid.items[0].focus();
					} else {
						var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) ) {
								if (item.holdable == 'hold') {
									item.setReadOnly(true);
									//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터)
									if(Ext.isEmpty(panelResult.getValue('ORDER_NUM'))) {
										panelResult.getField('CUSTOM_NAME').setReadOnly( false );
									} else {
										panelResult.getField('CUSTOM_NAME').setReadOnly( true );
									}
								}
							}
							if(item.isPopupField) {
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
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						}
						if(item.isPopupField) {
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

	/** 긴급작업지시 마스터 정보를 가지고 있는 Grid
	 */
	Unilite.defineModel('pmp260ukrvDetailModel', {
		fields: [
			{name: 'LINE_SEQ'			,text: '<t:message code="system.label.product.routingorder" default="공정순서"/>'			,type:'int', allowBlank: false},
			{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string', allowBlank: false},
			{name: 'PROG_WORK_NAME'		,text: '<t:message code="system.label.product.routingname" default="공정명"/>'			 ,type:'string'},
			{name: 'EQUIP_CODE'			,text: '<t:message code="system.label.product.facilities" default="설비"/>'			,type:'string', allowBlank: true},
			{name: 'EQUIP_NAME'			,text: '<t:message code="system.label.product.facilitiesname" default="설비명"/>'			 ,type:'string', allowBlank: true},
			{name: 'MOLD_CODE'			,text: '<t:message code="system.label.product.moldcode" default="금형코드"/>'			,type:'string', allowBlank: true},
			{name: 'MOLD_NAME'			,text: '<t:message code="system.label.product.moldname" default="금형명"/>'			 ,type:'string', allowBlank: true},
			{name: 'PROG_UNIT_Q'		,text: '<t:message code="system.label.product.originunitqty" default="원단위량"/>'		,type:'uniFC', allowBlank: false},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		,type:'uniQty', allowBlank: false},
			//20180705(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
			{name: 'PRODT_PRSN'			,text: '<t:message code="system.label.product.worker" default="작업자"/>'				,type:'string',comboType:'AU',comboCode:'P505'},
			{name: 'PRODT_MACH'			,text: '<t:message code="system.label.product.Workingmachine" default="작업호기"/>'		 ,type:'string',comboType:'AU',comboCode:'P506'},
			{name: 'PRODT_TIME'			,text: '<t:message code="system.label.product.workhour" default="작업시간"/>'				,type:'string'},
			{name: 'DAY_NIGHT'			,text: '<t:message code="system.label.product.daynightclass" default="주야구분"/>'		,type:'string',comboType:'AU',comboCode:'P507'},

			{name: 'PROG_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>'			 ,type:'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value', allowBlank: false},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'				,type:'string'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'			,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			,type:'string' , comboType: 'WU'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'		,type:'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'			,type:'uniDate'},
			{name: 'PRODT_WKORD_DATE'	,text: '<t:message code="system.label.product.workstartdate" default="작업시작일"/>'		 ,type:'uniDate'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'			 ,type:'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.product.remarks" default="비고"/>'			,type:'string'},
			{name: 'WK_PLAN_NUM'		,text: '<t:message code="system.label.product.planno" default="계획번호"/>'		 ,type:'string'},
			{name: 'LINE_END_YN'		,text: '<t:message code="system.label.product.lastyn" default="최종여부"/>'		 ,type:'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'			 ,type:'string'},
			{name: 'WORK_END_YN'		,text: '<t:message code="system.label.product.closingyn" default="마감여부"/>'		,type:'string'},
			{name: 'REWORK_YN'			,text: '<t:message code="system.label.product.reworkorderyn2" default="재작업지시유무"/>'	,type:'string'},
			{name: 'STOCK_EXCHG_TYPE'	,text: '<t:message code="system.label.product.inventoryexchangetype" default="재고대체유형"/>'		,type:'string'},
			{name: 'STD_TIME'			,text: '<t:message code="system.label.product.standardtime" default="표준시간"/>'			,type:'int'},
			{name: 'CAVIT_BASE_Q'		,text: '<t:message code="system.label.product.cavityq" default="Cavity수"/>'		,type:'int'},
			{name: 'CAPA_HR'			,text: 'Capa/Hr'		,type:'int'},
			{name: 'CAPA_DAY'			,text: 'Capa/Day'		,type:'int'},

			//Hidden : true
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type:'string'},
			{name: 'PJT_CODE'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type:'string'},
			{name: 'LOT_NO'				,text: 'LOT_NO'			,type:'string'},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'			,type:'string'},
			{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'			,type:'uniDate'},
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'			,type:'string'},
			{name: 'WKORD_PRSN'			,text: 'WKORD_PRSN'		,type:'string'},
			//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터)
			{name: 'CUSTOM_NAME'				,text: 'CUSTOM_NAME'			,type:'string'},

			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.product.custom" default="거래처"/>'			, type: 'string'},
			{name: 'PROD_DRAW_YN'		, text: 'PROD_DRAW_YN'			, type: 'string'},


			{name: 'ORDER_NUM'		, text: 'ORDER_NUM'			, type: 'string'},
			{name: 'ORDER_SEQ'		, text: 'ORDER_SEQ'			, type: 'string'},
			{name: 'ORDER_Q'		, text: 'ORDER_Q'			, type: 'uniQty'},
			{name: 'DVRY_DATE'		, text: 'DVRY_DATE'			, type: 'uniDate'}
		]
	});


	/** Master Store 정의(Service 정의)
	 * @type
	 */
	var detailStore = Unilite.createStore('pmp260ukrvDetailStore', {
		model: 'pmp260ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,		 // 상위 버튼 연결
			editable: true,		 // 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			allDeletable: true,	// 전체 삭제 가능 여부
			useNavi : false		 // prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			loadChk = 'Y'; //조회해서 마스터폼에 값 넣을 때에는 작업지시량 체인지 이벤트 안 타도록 체크 변수 값 Y으로 넣어줌
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

			var wkordNum = panelResult.getValue('WKORD_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['WKORD_NUM'] != wkordNum) {
					record.set('WKORD_NUM', wkordNum);
				}
			})
//			var lotNo = panelSearch.getValue('LOT_NO');
//			Ext.each(list, function(record, index) {
//				if(record.data['LOT_NO'] != lotNo) {
//					record.set('LOT_NO', lotNo);
//				}
//			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				//if(config==null) {
					/* syncAll 수정
					 * config = {
							success: function() {
											detailForm.getForm().wasDirty = false;
											detailForm.resetDirtyStatus();
											console.log("set was dirty to false");
											UniAppManager.setToolbarButtons('save', false);
										}
							};*/
					config = {
							params: [paramMaster],
							success: function(batch, option) {
								var master = batch.operations[0].getResultSet();
								panelResult.setValue("WKORD_NUM", master.WKORD_NUM);
								panelResult.setValue("LOT_NO", master.LOT_NO);

								panelResult.getForm().wasDirty = false;
								panelResult.resetDirtyStatus();
								console.log("set was dirty to false");

//                             신규입력/전체삭제 flag값 조회하기
								var fparam = {"S_COMP_CODE": UserInfo.compCode,
								"DIV_CODE": panelResult.getValue('DIV_CODE'),
								"KEY_VALUE": master.KEY_VALUE};

							    pmp260ukrvService.selectInterfaceFlag(fparam, function(providerf, responsef) {
								var recordsf = responsef.result;
									if(!Ext.isEmpty(providerf)) {
										gswkordnumflag = providerf[0]['WKORD_NUM'];
										gsoprflag = providerf[0]['OPR_FLAG'];

//								작업지시데이터 MES연동사용시
										if(BsaCodeInfo.gsIfCode == 'Y'){
											if((gswkordnumflag=='' && gsoprflag=='D')||(gsoprflag=='N')||(gsoprflag=='U')){

												var param = {"S_COMP_CODE": UserInfo.compCode,
												"DIV_CODE": panelResult.getValue('DIV_CODE'),
												"KEY_VALUE": master.KEY_VALUE,
												"SITE_GUBUN": UserInfo.deptName
												};

												pmp260ukrvService.selectInterfaceInfo(param, function(provider, response) {
												var records = response.result;
												if(!Ext.isEmpty(provider)) {
//													Ext.each(records, function(record,i) {
														var sparam = {
														if_seq      : provider[0]['IF_SEQ'],
														company_no  : provider[0]['COMPANY_NO'],
														prdctn_dt   : provider[0]['PRDCTN_DT'],
														prdctn_product_no  : provider[0]['PRDCTN_PRODUCT_NO'],
														prdctn_product_cd  : provider[0]['PRDCTN_PRODUCT_CD'],
														prdctn_product_nm  : provider[0]['PRDCTN_PRODUCT_NM'],
														plan_outtrn      : provider[0]['PLAN_OUTTRN'],
														acmslt_outtrn   : provider[0]['ACMSLT_OUTTRN'],
														unit_cd         : provider[0]['UNIT_CD'],
														erp_lot_no      : provider[0]['ERP_LOT_NO'],
														packng_qy       : provider[0]['PACKNG_QTY'],
														member_no       : provider[0]['MEMBER_NO'],
														ordr_i_or_d     : provider[0]['ORDR_I_OR_D'],
														order_num     	: provider[0]['ORDER_NUM'],
														wrkshp_ty		: provider[0]['WRKSHP_TY']
														};

														Ext.Ajax.request({
														url	: BsaCodeInfo.gsIfSiteCode,
														method:'POST',
														params	: sparam,
														cors: true,	// 브라우저가 IE8 이상인 경우 XMLHttpRequest 대신 XDomainRequest 개체를 사용 설정
														useDefaultXhrHeader : false,	// Ajax 요청과 함께 보낼 헤더 사용 유무
		//												async	: true,
														success	: function(response){
															if(!Ext.isEmpty(response)){
															Unilite.messageBox('MES연동데이터  전송되었습니다.');
															}
														},
														failure: function (response, options) {
														    alert( "failed: " + response.responseText );

														  }
														});

	//												});

													}
												});
											}
										}
									if (detailStore.count() == 0) {
										UniAppManager.app.onResetButtonDown();
									}else{
										detailStore.loadStoreRecords();

										//20190123 저장로직 진행 후, 인쇄미리보기 / 인쇄 버튼 활성화
										if(BsaCodeInfo.gsReportGubun == 'CLIP'){
											UniAppManager.setToolbarButtons(['printPreview'],true);
											UniAppManager.setToolbarButtons(['directPrint'],true); //printPreview:인쇄미리보기, directPrint:인쇄
										}else{
											UniAppManager.setToolbarButtons(['print'],true);
										}
									}
									UniAppManager.setToolbarButtons('save', false);
									}
							    });
							}
					};
				//}
				//this.syncAll(config);
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('pmp260ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				// alert(Msg.sMB083);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {

				if(store.count() > 0){
					Ext.each(records, function(record,i){
                		 if(record.get('LINE_END_YN') == 'Y'){
                			 panelResult.setValues(record.data);
                		 }
                	 });
				}
//				if(records[0] != null){
//					panelResult.uniOpt.inLoading = true;
//					panelResult.setValues(records[0].data);
//					panelResult.uniOpt.inLoading = false;
//					detailStore.commitChanges();
//				}
				loadChk = 'N';//조회한 다음에 마스터폼에 값 넣을 때에는 작업지시량 체인지 이벤트 타지 않도록 체크 변수 값 Y로 넣어준 후 다시 이벤트 타도록 N으로 세팅
			}
		}
	});

	/**
	 * Master Grid 정의(Grid Panel)
	 * @type
	 */
	var detailGrid = Unilite.createGrid('pmp260ukrvGrid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
			expandLastColumn: true,
			useRowNumberer: false
		},
		tbar: [{
            itemId: 'requestBtn',
            text: '<div style="color: blue"><t:message code="system.label.product.productionplanreference" default="생산계획참조"/></div>',
            handler: function() {
					openProductionPlanWindow();
                }
        },'-',{
			itemId: 'reqIssueLinkBtn',
			text: '<div style="color: red"><t:message code="system.label.product.allocationqtyadjust" default="예약량조정"/></div>',
			handler: function() {
				if(!UniAppManager.app.checkForNewDetail()) return false;
				/* 기본 필수값을 입력하지 않을 경우 팅겨냄*/
				else{
					if(Ext.isEmpty(panelResult.getValue('WKORD_NUM'))){
						Unilite.messageBox('<t:message code="system.message.product.datacheck002" default="선택된 자료가 없습니다."/>');
						return false;
					}
					else{
						var params = {
							'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
							'WORK_SHOP_CODE'	: panelResult.getValue('WORK_SHOP_CODE'),
							'PRODT_WKORD_DATE': panelResult.getValue('PRODT_WKORD_DATE'),
							'WKORD_NUM'		 : panelResult.getValue('WKORD_NUM')
						}
						var rec = {data : {prgID : 'pmp160ukrv', 'text':'<t:message code="system.label.product.allocationqtyadjust" default="예약량조정"/>'}};
						parent.openTab(rec, '/prodt/pmp160ukrv.do', params);
					}
				}
			}
		},'-'],
		store: detailStore,
		columns: [
			{dataIndex:'LINE_SEQ'			, width: 120},
			{dataIndex:'PROG_WORK_CODE'		, width: 120 ,locked: false,
				editor: Unilite.popup('PROG_WORK_CODE_G', {
						textFieldName: 'PROG_WORK_NAME',
						DBtextFieldName: 'PROG_WORK_NAME',
						extParam: {SELMODEL: 'MULTI'},
						autoPopup: true,
						listeners: {'onSelected': {
										fn: function(records, type) {
											Ext.each(records, function(record,i) {
												if(i==0) {

													detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
												}else{
													UniAppManager.app.onNewDataButtonDown();
													detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
												}
											});
										},
										scope: this
									},
									'onClear': function(type) {
										detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
									},
									applyextparam: function(popup){
										popup.setExtParam({'DIV_CODE'		: panelResult.getValue('DIV_CODE')});
										popup.setExtParam({'WORK_SHOP_CODE' : panelResult.getValue('WORK_SHOP_CODE')});
//										popup.setExtParam({'SELMODEL' : 'MULTI'});
									}
					}
				})
			},

			{dataIndex: 'PROG_WORK_NAME'	, width: 206,
				editor: Unilite.popup('PROG_WORK_CODE_G', {
							textFieldName: 'PROG_WORK_NAME',
							DBtextFieldName: 'PROG_WORK_NAME',
							extParam: {SELMODEL: 'MULTI'},
							autoPopup: true,
							listeners: {'onSelected': {
											fn: function(records, type) {
												Ext.each(records, function(record,i) {
													if(i==0) {
														detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
													}else{
														UniAppManager.app.onNewDataButtonDown();
														detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
													}
												});
											},
											scope: this
										},
										'onClear': function(type) {
											var grdRecord = detailGrid.getSelectedRecord();
											detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
										},
										applyextparam: function(popup){
											popup.setExtParam({'DIV_CODE'		: panelResult.getValue('DIV_CODE')});
											popup.setExtParam({'WORK_SHOP_CODE' : panelResult.getValue('WORK_SHOP_CODE')});
//											popup.setExtParam({'SELMODEL' : 'MULTI'});
										}
						}
				})
			},
			{dataIndex: 'LOT_NO'			, width: 100, hidden: true},
			{dataIndex: 'PROG_UNIT_Q'		, width: 146,format:'0,000.000000',editor:{format:'0,000.000000'}},
			{dataIndex: 'WKORD_Q'			, width: 206},

			//20180705(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
			{dataIndex: 'PRODT_PRSN'		, width: 150},
			{dataIndex: 'PRODT_MACH'		, width: 100},
			{dataIndex: 'PRODT_TIME'		, width: 100},
			{dataIndex: 'DAY_NIGHT'			, width: 100},

			{dataIndex: 'PROG_UNIT'			, width: 50, align: 'center'},
			{dataIndex: 'PRODT_START_DATE'	, width: 100 },
			{dataIndex: 'PRODT_END_DATE'	, width: 100 },
			{dataIndex: 'STD_TIME'			, width: 100},
			{dataIndex: 'EQUIP_CODE'		, width: 110, hidden: isEquipCode
				,'editor' : Unilite.popup('EQU_MACH_CODE_G',{
								textFieldName:'EQU_MACH_NAME',
								DBtextFieldName: 'EQU_MACH_NAME',
								autoPopup: true,
								listeners: {'onSelected': {
									fn: function(records, type) {
										var grdRecord = detailGrid.uniOpt.currentRecord;
										grdRecord.set('EQUIP_CODE',records[0]['EQU_MACH_CODE']);
										grdRecord.set('EQUIP_NAME',records[0]['EQU_MACH_NAME']);
									},
									scope: this
								},
								'onClear': function(type) {
									grdRecord = detailGrid.getSelectedRecord();
									grdRecord.set('EQUIP_CODE', '');
									grdRecord.set('EQUIP_NAME', '');
								},
								applyextparam: function(popup){
									var param =panelResult.getValues();
									popup.setExtParam({'DIV_CODE': param.DIV_CODE});
								}
							}
				})
			},
			{dataIndex: 'EQUIP_NAME'		, width: 200, hidden: isEquipCode
				,'editor' : Unilite.popup('EQU_MACH_CODE_G',{
						textFieldName:'EQU_MACH_NAME',
						DBtextFieldName: 'EQU_MACH_NAME',
						autoPopup: true,
						listeners: {'onSelected': {
									fn: function(records, type) {
										var grdRecord = detailGrid.uniOpt.currentRecord;
										grdRecord.set('EQUIP_CODE',records[0]['EQU_MACH_CODE']);
										grdRecord.set('EQUIP_NAME',records[0]['EQU_MACH_NAME']);
									},
									scope: this
								},
								'onClear': function(type) {
									grdRecord = detailGrid.getSelectedRecord();
									grdRecord.set('EQUIP_CODE', '');
									grdRecord.set('EQUIP_NAME', '');
								},
								applyextparam: function(popup){
									var param =panelResult.getValues();
									popup.setExtParam({'DIV_CODE': param.DIV_CODE});
								}
						 }
				})
			},
			{dataIndex: 'MOLD_CODE'			, width: 110, hidden: isMoldCode
				,'editor' : Unilite.popup('EQU_MOLD_CODE_G',{
							textFieldName:'EQU_MOLD_NAME',
							DBtextFieldName: 'EQU_MOLD_NAME',
							autoPopup: true,
							listeners: {'onSelected': {
									fn: function(records, type) {
										grdRecord = detailGrid.getSelectedRecord();
										Ext.each(records, function(record,i) {
											grdRecord.set('MOLD_CODE',records[0]['EQU_MOLD_CODE']);
											grdRecord.set('MOLD_NAME',records[0]['EQU_MOLD_NAME']);
											grdRecord.set('CAVIT_BASE_Q', record.CAVIT_BASE_Q);
											if(record.CAVIT_BASE_Q != 0 && record.CYCLE_TIME != 0){
												grdRecord.set('CAPA_HR', 3600/record.CYCLE_TIME * record.CAVIT_BASE_Q );
												grdRecord.set('CAPA_DAY',(3600/record.CYCLE_TIME * record.CAVIT_BASE_Q)* grdRecord.get('STD_TIME'));
											}else{
												grdRecord.set('CAPA_HR', 0);
												grdRecord.set('CAPA_DAY',0);
											}
										});
									},
									scope: this
								},
								'onClear': function(type) {
									grdRecord = detailGrid.getSelectedRecord();
									grdRecord.set('MOLD_CODE', '');
									grdRecord.set('MOLD_NAME', '');
									grdRecord.set('CAVIT_BASE_Q', record.CAVIT_BASE_Q);
									grdRecord.set('CAPA_HR' , '');
									grdRecord.set('CAPA_DAY','');
								},
								applyextparam: function(popup){
									var param =panelResult.getValues();
									popup.setExtParam({'DIV_CODE': param.DIV_CODE});
								}
							}
				})
			},
			{dataIndex: 'MOLD_NAME'			, width: 200, hidden: isMoldCode
				,'editor' : Unilite.popup('EQU_MOLD_CODE_G',{
							textFieldName:'EQU_MOLD_NAME',
							DBtextFieldName: 'EQU_MOLD_NAME',
							autoPopup: true,
							listeners: {'onSelected': {
									fn: function(records, type) {
										grdRecord = detailGrid.getSelectedRecord();
										Ext.each(records, function(record,i) {
											grdRecord.set('MOLD_CODE',records[0]['EQU_MOLD_CODE']);
											grdRecord.set('MOLD_NAME',records[0]['EQU_MOLD_NAME']);
											grdRecord.set('CAVIT_BASE_Q', record.CAVIT_BASE_Q);
											if(record.CAVIT_BASE_Q != 0 && record.CYCLE_TIME != 0){
												grdRecord.set('CAPA_HR', 3600/record.CYCLE_TIME * record.CAVIT_BASE_Q );
												grdRecord.set('CAPA_DAY',(3600/record.CYCLE_TIME * record.CAVIT_BASE_Q)* grdRecord.get('STD_TIME'));
											}else{
												grdRecord.set('CAPA_HR', 0);
												grdRecord.set('CAPA_DAY',0);
											}
										});
									},
									scope: this
								},
								'onClear': function(type) {
									grdRecord = detailGrid.getSelectedRecord();
									grdRecord.set('MOLD_CODE', '');
									grdRecord.set('MOLD_NAME', '');
									grdRecord.set('CAVIT_BASE_Q', record.CAVIT_BASE_Q);
									grdRecord.set('CAPA_HR', '');
									grdRecord.set('CAPA_DAY','');
								},
								applyextparam: function(popup){
									var param =panelResult.getValues();
									popup.setExtParam({'DIV_CODE': param.DIV_CODE});
								}
							}
				})
			},
			{dataIndex: 'CAVIT_BASE_Q'		, width: 100 },
			{dataIndex: 'CAPA_HR'			, width: 100},
			{dataIndex: 'CAPA_DAY'			, width: 100 },
			{dataIndex: 'DIV_CODE'			, width: 100 , hidden: true},
			{dataIndex: 'WKORD_NUM'			, width: 100 , hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100 , hidden: true},
			{dataIndex: 'PRODT_WKORD_DATE'	, width: 100 , hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 100 , hidden: true},
			{dataIndex: 'ITEM_NAME'			, width: 100 , hidden: true},
			{dataIndex: 'REMARK'			, width: 500 },
			{dataIndex: 'WK_PLAN_NUM'		, width: 100 , hidden: true},
			{dataIndex: 'LINE_END_YN'		, width: 100 , hidden: true},
			{dataIndex: 'SPEC'				, width: 100 , hidden: true},
			{dataIndex: 'WORK_END_YN'		, width: 100 , hidden: true},
			{dataIndex: 'REWORK_YN'			, width: 100 , hidden: true},
			{dataIndex: 'STOCK_EXCHG_TYPE'	, width: 100 , hidden: true},
			// ColDate
			{dataIndex: 'PROJECT_NO'		, width: 100 , hidden: true},
			{dataIndex: 'PJT_CODE'			, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 100 , hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 100 , hidden: true},
			{dataIndex: 'WKORD_PRSN'		, width: 100 , hidden: true},
			//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터)
			{dataIndex: 'CUSTOM_NAME'			, width: 100 , hidden: true},
			{dataIndex: 'CUSTOM_CODE'			, width: 100 , hidden: true},
			{dataIndex: 'PROD_DRAW_YN'			, width: 50 , hidden: true}
		],
		listeners: {

			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom || !e.record.phantom) {
					if (UniUtils.indexOf(e.field,
											['WKORD_Q','PROG_UNIT','DIV_CODE', 'WKORD_NUM','WORK_SHOP_CODE'
											,'PRODT_WKORD_DATE','ITEM_CODE','ITEM_NAME','WK_PLAN_NUM','LINE_END_YN','SPEC','WORK_END_YN'
											,'REWORK_YN','STOCK_EXCHG_TYPE','PROJECT_NO','PJT_CODE'/*,'LOT_NO'*/,'UPDATE_DB_USER','UPDATE_DB_TIME','COMP_CODE'
											,'CUSTOM_NAME','CUSTOM_CODE'
											]))
							return false;
				}
				if(!e.record.phantom){
					if (UniUtils.indexOf(e.field,
											['PROG_WORK_CODE','PROG_WORK_NAME','DIV_CODE', 'WKORD_NUM','WORK_SHOP_CODE'
											,'PRODT_WKORD_DATE','ITEM_CODE','ITEM_NAME','REMARK','WK_PLAN_NUM','LINE_END_YN','SPEC','WORK_END_YN'
											,'REWORK_YN','STOCK_EXCHG_TYPE','PROJECT_NO','PJT_CODE'/*,'LOT_NO'*/,'UPDATE_DB_USER','UPDATE_DB_TIME','COMP_CODE'
											//20180705(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
//										, 'PRODT_PRSN', 'PRODT_MACH', 'PRODT_TIME', 'DAY_NIGHT'
											,'CUSTOM_NAME','CUSTOM_CODE'
											]))
							return false;
				}
				else{ return true }
			}
		},
		disabledLinkButtons: function(b) {
			this.down('#reqIssueLinkBtn').setDisabled(b);
		},
		setItemData: function(record, dataClear, grdRecord) {
			//var grdRecord = detailGrid.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('PROG_WORK_CODE'		, '');
				grdRecord.set('PROG_WORK_NAME'		, '');
				grdRecord.set('PROG_UNIT'				,panelResult.getValue('PROG_UNIT'));
				grdRecord.set('STD_TIME'				, '');
			}else{
				grdRecord.set('PROG_WORK_CODE'		, record['PROG_WORK_CODE']);
				grdRecord.set('PROG_WORK_NAME'		, record['PROG_WORK_NAME']);
				grdRecord.set('STD_TIME'				, record['STD_TIME']);
				if(grdRecord.get['PROG_UNIT'] != ''){
					grdRecord.set('PROG_UNIT'			, record['PROG_UNIT']);
				}
				else{
					grdRecord.set('PROG_UNIT'			, panelResult.getValue('PROG_UNIT'));
				}
			}
		},
		setEstiData: function(record, dataClear, grdRecord) {
			var grdRecord = detailGrid.getSelectedRecord();
			grdRecord.set('DIV_CODE'		,record['DIV_CODE']);
			grdRecord.set('ITEM_CODE'		 ,record['ITEM_CODE']);
			grdRecord.set('LINE_SEQ'		,record['LINE_SEQ']);
			grdRecord.set('PROG_WORK_CODE'	,record['PROG_WORK_CODE']);
			grdRecord.set('PROG_WORK_NAME'	,record['PROG_WORK_NAME']);
			grdRecord.set('PROG_UNIT_Q'		,record['PROG_UNIT_Q']);
			grdRecord.set('WKORD_Q'			,record['PROG_UNIT_Q'] * panelResult.getValue('WKORD_Q'));
			grdRecord.set('PROG_UNIT'		 ,record['PROG_UNIT']);
		},
		setBeforeNewData: function(record, dataClear, grdRecord) {
			var grdRecord = detailGrid.getSelectedRecord();
			grdRecord.set('DIV_CODE'		,record['DIV_CODE']);
			grdRecord.set('ITEM_CODE'		 ,record['ITEM_CODE']);
			grdRecord.set('LINE_SEQ'		,record['LINE_SEQ']);
			grdRecord.set('PROG_WORK_CODE'	,record['PROG_WORK_CODE']);
			grdRecord.set('PROG_WORK_NAME'	,record['PROG_WORK_NAME']);
			grdRecord.set('PROG_UNIT_Q'		,record['PROG_UNIT_Q']);
			grdRecord.set('WKORD_Q'			,record['PROG_UNIT_Q'] * panelResult.getValue('WKORD_Q'));
			grdRecord.set('PROG_UNIT'		 ,record['PROG_UNIT']);
		}
	});

	/**
	 * 작업지시를 검색하기 위한 Search Form, Grid, Inner Window 정의
	 */
	 //조회창 폼 정의
	var productionNoSearch = Unilite.createSearchForm('productionNoSearchForm', {
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
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
				comboType: 'WU',
				allowBlank:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						store.clearFilter();

						if(!Ext.isEmpty(productionNoSearch.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == productionNoSearch.getValue('DIV_CODE');
							});
						}else{
							store.filterBy(function(record){
								return false;
							});
						}
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_PRODT_DATE',
				endFieldName: 'TO_PRODT_DATE',
				width: 350,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},
				Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
						valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);

								},
								scope: this
							},
							onClear: function(type) {

							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
					}
			}),{
				fieldLabel: '<t:message code="system.label.product.lotno" default="LOT번호"/>',
				xtype: 'uniTextfield',
				name:'LOT_NO',
				width:315
			},{
				fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
				xtype: 'uniTextfield',
				name:'WKORD_NUM',
				width:315
			}]
	}); // createSearchForm

	// 조회창 모델 정의
	Unilite.defineModel('productionNoMasterModel', {
		fields: [
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	 , type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'				, type: 'string'},
			{name: 'PRODT_WKORD_DATE'	, text: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>'		, type: 'uniDate'},
			{name: 'PRODT_START_DATE'	, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	 , type: 'uniDate'},
			{name: 'PRODT_END_DATE'		, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'		, type: 'uniDate'},
			{name: 'WKORD_Q'			, text: '<t:message code="system.label.product. wkordq" default="작지수량"/>'			, type: 'uniQty'},
			{name: 'WK_PLAN_NUM'		, text: '<t:message code="system.label.product.planno" default="계획번호"/>'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		 , type: 'string' , comboType: 'WU'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'		, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.product.seq" default="순번"/>'		, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'		, type: 'uniQty'},
			{name: 'REMARK'				, text: '<t:message code="system.label.product.remarks" default="비고"/>'			 , type: 'string'},
			{name: 'PRODT_Q'			, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		, type: 'uniQty'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'				, type: 'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'PJT_CODE'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'LOT_NO'				, text: 'LOT_NO'			, type: 'string'},

			{name: 'WORK_END_YN'		, text: '<t:message code="system.label.product.forceclosingflag" default="강제마감여부"/>'		, type: 'string'},

			{name: 'CUSTOM_NAME'				, text: '<t:message code="system.label.product.custom" default="거래처"/>'		 , type: 'string'},
			{name: 'REWORK_YN'			, text: '<t:message code="system.label.product.reworkorderyn" default="재작업지시여부"/>'	, type: 'string'},
			{name: 'STOCK_EXCHG_TYPE'	, text: '<t:message code="system.label.product.inventoryexchangetype" default="재고대체유형"/>'		, type: 'string'},
			{name: 'WKORD_PRSN'			, text: 'WKORD_PRSN'		, type: 'string'}
		]
	});

	//조회창 스토어 정의
	var productionNoMasterStore = Unilite.createStore('productionNoMasterStore', {
		model: 'productionNoMasterModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: directProxy2,
		loadStoreRecords : function() {
			var param= productionNoSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var productionNoMasterGrid = Unilite.createGrid('pmp260ukrvproductionNoMasterGrid', {
		// title: '기본',
		layout : 'fit',
		store: productionNoMasterStore,
		uniOpt:{
			useRowNumberer: false
		},
		columns: [
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 120 },
			{ dataIndex: 'WKORD_NUM'		, width: 120 },
			{ dataIndex: 'ITEM_CODE'		, width: 100 },
			{ dataIndex: 'ITEM_NAME'		, width: 166 },
			{ dataIndex: 'SPEC'				, width: 100 },
			{ dataIndex: 'PRODT_WKORD_DATE'	, width: 80 },
			{ dataIndex: 'PRODT_START_DATE'	, width: 80 },
			{ dataIndex: 'PRODT_END_DATE'	, width: 80 },
			{ dataIndex: 'WKORD_Q'			, width: 73 },
			{ dataIndex: 'WK_PLAN_NUM'		, width: 100 ,hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 0	,hidden: true},

			{ dataIndex: 'ORDER_NUM'		, width: 100	},
			{ dataIndex: 'ORDER_SEQ'		, width: 50	},
			{ dataIndex: 'ORDER_Q'			, width: 0	,hidden: true},
			{ dataIndex: 'REMARK'			, width: 100 },
			{ dataIndex: 'PRODT_Q'			, width: 0	,hidden: true},
			{ dataIndex: 'DVRY_DATE'		, width: 0	,hidden: true},
			{ dataIndex: 'STOCK_UNIT'		, width: 33,hidden: true},
			{ dataIndex: 'PROJECT_NO'		, width: 100 },
			{ dataIndex: 'PJT_CODE'			, width: 100 },
			{ dataIndex: 'LOT_NO'			, width: 133 },
			{ dataIndex: 'WORK_END_YN'		, width: 100 ,hidden: true},
			{ dataIndex: 'CUSTOM_NAME'			, width: 100 ,hidden: true},
			{ dataIndex: 'CUSTOM_CODE'			, width: 100 ,hidden: true},
			{ dataIndex: 'REWORK_YN'		, width: 100 ,hidden: true},
			{ dataIndex: 'STOCK_EXCHG_TYPE'	, width: 100 ,hidden: true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				this.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				searchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelResult.uniOpt.inLoading = true;
			panelResult.getField('REWORK_YN').setValue(record.get('REWORK_YN'));

			panelResult.setValues({
				'DIV_CODE':record.get('DIV_CODE'),				/*사업장*/		'WKORD_NUM':record.get('WKORD_NUM'),				/*작업지시번호*/
				'WORK_SHOP_CODE':record.get('WORK_SHOP_CODE'),	/* 작업장*/	'ITEM_CODE':record.get('ITEM_CODE'),				/*품목코드*/
				'ITEM_NAME':record.get('ITEM_NAME'),/*품목명*/		'SPEC':record.get('SPEC'),						 /*규격*/
				'PRODT_WKORD_DATE':record.get('PRODT_WKORD_DATE'),	'PRODT_START_DATE':record.get('PRODT_START_DATE'),
				'PRODT_END_DATE':record.get('PRODT_END_DATE'),		'LOT_NO':record.get('LOT_NO'),
				'WKORD_Q':record.get('WKORD_Q'),						'PROG_UNIT':record.get('STOCK_UNIT'),
				'PROJECT_NO':record.get('PROJECT_NO'),				'ANSWER':record.get('REMARK'),
				'PJT_CODE':record.get('PJT_CODE'),					'WORK_END_YN':record.get('WORK_END_YN'),
				'ORDER_NUM':record.get('ORDER_NUM'),/* 수주번호*/		 'ORDER_SEQ':record.get('ORDER_SEQ'),/* 수주순번*/
				'ORDER_Q':record.get('ORDER_Q'),				/* 수주량*/
				'DVRY_DATE':record.get('DVRY_DATE'),/* 납기일*/		'CUSTOM_NAME':record.get('CUSTOM_NAME'),
				'PROG_UNIT':record.get('STOCK_UNIT'),					'EXCHG_TYPE':record.get('STOCK_EXCHG_TYPE'),
				'WKORD_PRSN' : record.get('WKORD_PRSN'),			'CUSTOM_CODE':record.get('CUSTOM_CODE')
			});

			panelResult.getField('DIV_CODE').setReadOnly( true );
			panelResult.getField('WKORD_NUM').setReadOnly( true );
			panelResult.getField('WORK_SHOP_CODE').setReadOnly( true );
			panelResult.getField('ITEM_CODE').setReadOnly( true );
			panelResult.getField('ITEM_NAME').setReadOnly( true );
			panelResult.getField('REWORK_YN').setReadOnly( true );
			panelResult.getField('PROG_UNIT').setReadOnly( true );
			panelResult.getField('WORK_END_YN').setReadOnly( false );

//2020-11-18 작업지시 이중저장오류 원인 확인하기 위해 임시로 수주번호 수정로직 주석처리함
//			if(!Ext.isEmpty(panelResult.getValue('ORDER_NUM'))){
//				panelResult.getField('ORDER_NUM').setReadOnly(true);
//				}else{
//					panelResult.getField('ORDER_NUM').setReadOnly(false);
//			}
//2020-11-18 END
			Ext.getCmp('reworkRe').setReadOnly(true);
			Ext.getCmp('workEndYnRe').setReadOnly(false);

			detailGrid.down('#requestBtn').setDisabled(true); // 데이터 Set 될때 생산계획 참조 Disabled
			//fn_printChk(record.get("ITEM_ACCOUNT")); //품목계정에 따른 출력 버튼 활성화
			panelResult.uniOpt.inLoading = false;
		}
	});

	//조회창 메인
	function opensearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.product.workorderinfo" default="작업지시정보"/>',
				width: 830,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [productionNoSearch, productionNoMasterGrid],
				tbar:['->',
					{	itemId : 'searchBtn',
						text: '<t:message code="system.label.product.inquiry" default="조회"/>',
						handler: function() {
							if(!productionNoSearch.getInvalidMessage()) {
								return false;
							}
							productionNoMasterStore.loadStoreRecords();
						},
						disabled: false
					}, {
						itemId : 'closeBtn',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							searchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						productionNoSearch.clearForm();
						productionNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts ){
						productionNoSearch.clearForm();
						productionNoMasterGrid.reset();
					},
					show: function( panel, eOpts ) {
						productionNoSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
						productionNoSearch.setValue('WORK_SHOP_CODE',panelResult.getValue('WORK_SHOP_CODE'));
						productionNoSearch.setValue('ITEM_CODE',panelResult.getValue('ITEM_CODE'));
						productionNoSearch.setValue('ITEM_NAME',panelResult.getValue('ITEM_NAME'));

						productionNoSearch.setValue('FR_PRODT_DATE',UniDate.get('startOfMonth'));
						productionNoSearch.setValue('TO_PRODT_DATE',UniDate.get('today'));
					}
				}
			})
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
	}



	/** 생산계획을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//생산계획 참조 폼 정의
	var productionPlanSearch = Unilite.createSearchForm('productionPlanForm', {
		layout :{type : 'uniTable', columns : 2},
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
			comboType: 'WU'
		},{
			fieldLabel: '<t:message code="system.label.product.plandate" default="계획일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'OUTSTOCK_REQ_DATE_FR',
			endFieldName: 'OUTSTOCK_REQ_DATE_TO',
			width: 315,
			startDate: UniDate.get('today'),			/* DB today */
			endDate: UniDate.get('todayForMonth'),	/* DB today + 1달*/
			allowBlank:false
		},
			Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		})]
	});

//	//생산계획 참조 입력set 데이터용
//	var productionPlanInputForm = Unilite.createSearchForm('productionPlanInputFormForm', {
//		layout :{type : 'uniTable', columns : 2},
//		items: [{
//			fieldLabel: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
//			xtype: 'uniDatefield',
//			name: 'PRODT_WKORD_DATE',
//			holdable: 'hold',
//			allowBlank:false,
//			value: new Date()
//		},{
//			fieldLabel: 'LOT_NO',
//			xtype:'uniTextfield',
//			labelWidth: 271,
//			name: 'LOT_NO'
//		},{
//			fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
//			xtype: 'uniDatefield',
//			name: 'PRODT_START_DATE',
//			holdable: 'hold',
//			allowBlank:false,
//			value: new Date()
//		},{
//			fieldLabel: '<t:message code="system.label.product.completiondate" default="완료예정일"/>',
//			xtype: 'uniDatefield',
//			name: 'PRODT_END_DATE',
//			holdable: 'hold',
//			labelWidth: 271,
//			allowBlank:false,
//			value: new Date()
//		},{
//			xtype: 'container',
//			layout: { type: 'uniTable', columns: 3},
//			defaultType: 'uniTextfield',
//			defaults : {enforceMaxLength: true},
//			items:[{
//				fieldLabel: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
//				xtype: 'uniNumberfield',
//				name: 'WKORD_Q',
//				value: '0.00',
//				holdable: 'hold',
//				allowBlank:false
//			},{
//				name:'PROG_UNIT',
//				xtype:'uniTextfield',
//				holdable: 'hold',
//				width: 50,
//				readOnly:true,
//				fieldStyle: 'text-align: center;'
//			}]
//		}]
//	});

	Unilite.defineModel('pmp260ukrvProductionPlanModel', {
		fields: [
			{name: 'GUBUN'				, text: '<t:message code="system.label.product.selection" default="선택"/>'				, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.mfgplace" default="제조처"/>'				, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				, type: 'string' , comboType: 'WU'},
			{name: 'WK_PLAN_NUM'		, text: '<t:message code="system.label.product.productionplanno" default="생산계획번호"/>'	, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'					, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'					, type: 'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value'},
			{name: 'WK_PLAN_Q'			, text: '<t:message code="system.label.product.planqty" default="계획량"/>'				, type: 'uniQty'},
			{name: 'WKORD_Q'			, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'			, type: 'uniQty'},
			{name: 'WKORD_REMAIN_Q'		, text: '<t:message code="system.label.product.balanceqty" default="잔량"/>'				, type: 'uniQty'},
			{name: 'PRODUCT_LDTIME'		, text: '<t:message code="system.label.product.mfglt" default="제조 L/T"/>'				, type: 'string'},
			{name: 'PRODT_START_DATE'	, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'		, type: 'uniDate'},
			{name: 'PRODT_PLAN_DATE'	, text: '<t:message code="system.label.product.planfinisheddate" default="계획완료일"/>'		, type: 'uniDate'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.product.seq" default="순번"/>'						, type: 'string'},
			{name: 'ORDER_DATE'			, text: '<t:message code="system.label.product.sodate" default="수주일"/>'					, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'					, type: 'uniQty'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.product.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.product.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'EXPIRATION_DAY'		, text: 'EXPIRATION_DAY'																		, type: 'int'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'PJT_CODE'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			, type: 'string'}
		]
	});

	var productionPlanStore = Unilite.createStore('pmp260ukrvProductionPlanStore', {
		model: 'pmp260ukrvProductionPlanModel',
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
				read	: 'pmp260ukrvService.selectEstiList'
			}
		},
		loadStoreRecords : function() {
			var param= productionPlanSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var productionPlanGrid = Unilite.createGrid('pmp260ukrvproductionPlanGrid', {
		layout : 'fit',
		store: productionPlanStore,
		selModel: 'rowmodel',
		uniOpt:{
			onLoadSelectFirst : true
		},
		columns: [
			{dataIndex: 'GUBUN'				, width:0,hidden: true},
			{dataIndex: 'DIV_CODE'			, width:0,hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width:100
//				listeners:{
//					render:function(elm) {
//						var tGrid = elm.getView().ownerGrid;
//						elm.editor.on('beforequery',function(queryPlan, eOpts){
//
//							var grid = tGrid;
//							var record = grid.uniOpt.currentRecord;
//
//							var store = queryPlan.combo.store;
//							store.clearFilter();
//							store.filterBy(function(item){
//								return item.get('option') == record.get('DIV_CODE');
//							})
//						});
//						elm.editor.on('collapse',function(combo,eOpts ) {
//							var store = combo.store;
//							store.clearFilter();
//						});
//					}
//				}
			},
			{dataIndex: 'WK_PLAN_NUM'		, width:100,hidden: true},
			{dataIndex: 'ITEM_CODE'			, width:100},
			{dataIndex: 'ITEM_NAME'			, width:126},
			{dataIndex: 'SPEC'				, width:120},
			{dataIndex: 'STOCK_UNIT'		, width:40, align: 'center'},
			{dataIndex: 'WK_PLAN_Q'			, width:73},
			{dataIndex: 'WKORD_Q'			, width:100},
			{dataIndex: 'WKORD_REMAIN_Q'	, width:73},
			{dataIndex: 'PRODUCT_LDTIME'	, width:80},
			{dataIndex: 'PRODT_START_DATE'	, width:73},
			{dataIndex: 'PRODT_PLAN_DATE'	, width:73},
			{dataIndex: 'ORDER_NUM'			, width:93},
			{dataIndex: 'ORDER_SEQ'			, width:66},
			{dataIndex: 'ORDER_DATE'		, width:73},
			{dataIndex: 'ORDER_Q'			, width:73},
			{dataIndex: 'CUSTOM_CODE'		, width:100},
			{dataIndex: 'CUSTOM_NAME'		, width:100},
			{dataIndex: 'DVRY_DATE'			, width:73 ,hidden: true},
			{dataIndex: 'EXPIRATION_DAY'	, width:73 ,hidden: true},
			{dataIndex: 'PROJECT_NO'		, width:80 ,hidden: true},
			{dataIndex: 'PJT_CODE'			, width:80 ,hidden: true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				// if(!productionPlanInputForm.getInvalidMessage()) return;
				productionPlanGrid.returnData(record);
				referProductionPlanWindow.hide();
				panelResult.getField('REWORK_YN').setReadOnly( false );
			}
//			selectionchange: function( grid, selected, eOpts ) {
//				var record = selected[0];
//				if(record){
//					productionPlanInputForm.setValue('PRODT_START_DATE',record.get('PRODT_START_DATE'));
//					productionPlanInputForm.setValue('PRODT_END_DATE',record.get('PRODT_PLAN_DATE'));
//					productionPlanInputForm.setValue('WKORD_Q',record.get('WKORD_REMAIN_Q'));
//					productionPlanInputForm.setValue('PROG_UNIT',record.get('STOCK_UNIT'));
//				}
//			}
		},
		returnData: function(record) {
			panelResult.uniOpt.inLoading = true;
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
				panelResult.getField('REWORK_YN').setReadOnly( false );
			}
			panelResult.getField('REWORK_YN').setValue(record.get('REWORK_YN'));

			panelResult.setValues({
				'DIV_CODE':record.get('DIV_CODE'),	/*사업장*/
				'WKORD_NUM':record.get('WKORD_NUM'),				/*작업지시번호*/
				'WORK_SHOP_CODE':record.get('WORK_SHOP_CODE'), /* 작업장*/
				'ITEM_CODE':record.get('ITEM_CODE'),				/*품목코드*/
				'ITEM_NAME':record.get('ITEM_NAME'),/*품목명*/
				'SPEC':record.get('SPEC'),						 /*규격*/
				'PROJECT_NO':record.get('PROJECT_NO'),
				'ANSWER':record.get('REMARK'),
				'PJT_CODE':record.get('PJT_CODE'),
				'WORK_END_YN':record.get('WORK_END_YN'),
				'ORDER_NUM':record.get('ORDER_NUM'),/* 수주번호*/
				'ORDER_SEQ':record.get('ORDER_SEQ'),/* 수주순번*/
				'ORDER_Q':record.get('ORDER_Q'),				/* 수주량*/
				'DVRY_DATE':record.get('DVRY_DATE'),/* 납기일*/
				'CUSTOM_NAME':record.get('CUSTOM_NAME'),
				'CUSTOM_CODE':record.get('CUSTOM_CODE'),
				'PROG_UNIT':record.get('STOCK_UNIT'),
				'EXCHG_TYPE':record.get('STOCK_EXCHG_TYPE'),
				'WKORD_Q':record.get('WKORD_REMAIN_Q'),
				'WK_PLAN_NUM':record.get('WK_PLAN_NUM'),
				'PRODT_START_DATE':record.get('PRODT_START_DATE'),
				'PRODT_WKORD_DATE':new Date(),
				'PRODT_END_DATE':record.get('PRODT_PLAN_DATE'),
				'LOT_NO':record.get('LOT_NO'),
				'PROG_UNIT':record.get('STOCK_UNIT')
			});
			if(record.get('EXPIRATION_DAY') != 0){
				panelResult.setValue('EXPIRATION_DATE',UniDate.getDbDateStr(UniDate.add(panelResult.getValue('PRODT_WKORD_DATE'), {months: +record.get('EXPIRATION_DAY'), days:-1})));
			}else{
				panelResult.setValue('EXPIRATION_DATE', '');
			}

			Ext.getCmp('reworkRe').setReadOnly(false);
			Ext.getCmp('workEndYnRe').setReadOnly(true);

			panelResult.getField('DIV_CODE').setReadOnly( true );
			panelResult.getField('WKORD_NUM').setReadOnly( true );
			if(!Ext.isEmpty(panelResult.getValue('WORK_SHOP_CODE'))){
				panelResult.getField('WORK_SHOP_CODE').setReadOnly( true );
				UniAppManager.app.onNewDataButtonDown();
			}else{
				panelResult.getField('WORK_SHOP_CODE').setReadOnly( false );
			}
			panelResult.getField('ITEM_CODE').setReadOnly( true );
			panelResult.getField('ITEM_NAME').setReadOnly( true );
			panelResult.getField('EXCHG_TYPE').setReadOnly( true );
			panelResult.getField('PROG_UNIT').setReadOnly( true );
			panelResult.getField('WKORD_Q').setReadOnly( false );
			panelResult.getField('ANSWER').setReadOnly( false );

			detailGrid.down('#requestBtn').setDisabled(true);
			panelResult.uniOpt.inLoading = false;
		}
	});


	function openProductionPlanWindow() {
		if(!referProductionPlanWindow) {
			referProductionPlanWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.product.productionplaninfo" default="생산계획정보"/>',
				width: 830,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [productionPlanSearch, productionPlanGrid],
				tbar:['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.product.inquiry" default="조회"/>',
						handler: function() {
							if(!productionPlanSearch.getInvalidMessage()) return;
							productionPlanStore.loadStoreRecords();
						},
						disabled: false
					},
					{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.product.apply" default="적용"/>',
						handler: function() {
							//if(!productionPlanInputForm.getInvalidMessage()) return;
							productionPlanGrid.returnData();
							referProductionPlanWindow.hide();
						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.product.afterapplyclose" default="적용 후 닫기"/>',
						handler: function() {
							//if(!productionPlanInputForm.getInvalidMessage()) return;
							productionPlanGrid.returnData();
							referProductionPlanWindow.hide();

						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							referProductionPlanWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						//requestSearch.clearForm();
						//requestGrid,reset();
					},
					beforeclose: function( panel, eOpts ){
						//requestSearch.clearForm();
						//requestGrid,reset();
					},
					beforeshow: function ( me, eOpts ) {
						productionPlanSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
						productionPlanSearch.setValue('WORK_SHOP_CODE',panelResult.getValue('WORK_SHOP_CODE'));
						productionPlanSearch.setValue('ITEM_CODE',panelResult.getValue('ITEM_CODE'));
						productionPlanSearch.setValue('ITEM_NAME',panelResult.getValue('ITEM_NAME'));
//						productionPlanInputForm.setValue('PRODT_WKORD_DATE',panelResult.getValue('PRODT_WKORD_DATE'));
//						productionPlanInputForm.setValue('PRODT_START_DATE',panelResult.getValue('PRODT_START_DATE'));
//						productionPlanInputForm.setValue('PRODT_END_DATE',panelResult.getValue('PRODT_END_DATE'));
						//productionPlanSearch.setValue('OUTSTOCK_REQ_DATE_FR',UniDate.get('today'));
						//productionPlanSearch.setValue('TO_PRODT_DATE',UniDate.get('todayForMonth'));
						productionPlanStore.loadStoreRecords();
					}
				}
			})
		}
		referProductionPlanWindow.center();
		referProductionPlanWindow.show();
	}



	var refItemProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmp260ukrvService.selectRefItem'
		}
	});

	Unilite.defineModel('refItemModel', {
		fields: [
			{name: 'ITEM_CODE'			,text: '품목'			,type:'string'},
			{name: 'ITEM_NAME'			,text: '품명'			,type:'string'},
			{name: 'SPEC'				,text: '규격'			,type:'string'},
			{name: 'STOCK_UNIT'			,text: '단위'			,type:'string'},
			{name: 'ORDER_NUM'			,text: '수주번호'		,type:'string'},
			{name: 'CUSTOM_NAME'		,text: '거래처'		,type:'string'},
			{name: 'WKORD_NUM'			,text: '작업지시번호'	,type:'string'},
			{name: 'WKORD_Q'			,text: '지시수량'		,type:'uniQty'},
			{name: 'PASS_Q'					,text: '양품량'		,type:'uniQty'},
			{name: 'PRODT_WKORD_DATE'	,text: '지시일'		,type:'uniDate'},
			{name: 'LOT_NO'				,text: '제조LOT번호'	,type:'string'},
			{name: 'PRODT_DATE'			,text: '제조일자'		,type:'uniDate'},
			{name: 'EXPIRATION_DATE'	,text: '유통기한'		,type:'uniDate'}
		]
	});

	var refItemStore = Unilite.createStore('refItemStore', {
		model: 'refItemModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false,		 // 상위 버튼 연결
			editable: false,		 // 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			allDeletable: false,	// 전체 삭제 가능 여부
			useNavi : false		 // prev | next 버튼 사용
		},
		proxy: refItemProxy,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			this.load({
				params : param
			});
		}
	});
	var refItemGrid = Unilite.createGrid('refItemGrid', {
		store	: refItemStore,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn	: false,
			useLiveSearch		: false,
			useContextMenu		: false,
			useMultipleSorting	: false,
			useGroupSummary		: false,
			useRowNumberer		: false,
			onLoadSelectFirst	: false,
			filter: {
				useFilter	: false,
				autoCreate	: false
			},
			state: {
				useState	: false,
				useStateList: false
			}
		},
		selModel:'rowmodel',
		columns: [
			{ dataIndex: 'ITEM_CODE'				, width: 100 },
			{ dataIndex: 'ITEM_NAME'				, width: 200 },
			{ dataIndex: 'SPEC'						, width: 120 },
			{ dataIndex: 'STOCK_UNIT'				, width: 80 },
			{ dataIndex: 'ORDER_NUM'				, width: 120 },
			{ dataIndex: 'CUSTOM_NAME'				, width: 200 },
			{ dataIndex: 'WKORD_NUM'				, width: 120 },
			{ dataIndex: 'WKORD_Q'					, width: 100 },
			{ dataIndex: 'PASS_Q'					, width: 100 },
			{ dataIndex: 'PRODT_WKORD_DATE'			, width: 100 },
			{ dataIndex: 'LOT_NO'					, width: 120 },
			{ dataIndex: 'PRODT_DATE'				, width: 100 },
			{ dataIndex: 'EXPIRATION_DATE'			, width: 100 }
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				panelResult.setValue('REF_ITEM_CODE',record.get('ITEM_CODE'));
				panelResult.setValue('REF_ITEM_NAME',record.get('ITEM_NAME'));
				panelResult.setValue('LOT_NO',record.get('LOT_NO'));
				panelResult.setValue('PRODT_DATE',record.get('PRODT_DATE'));
				panelResult.setValue('EXPIRATION_DATE',record.get('EXPIRATION_DATE'));
                refItemWindow.hide();

			}
		}
	});
/**
 * 벌크품목 팝업 윈도우
 */
	 function openRefItemWindow() {
        if(!refItemWindow) {
            refItemWindow = Ext.create('widget.uniDetailWindow', {
                title: '벌크품목 팝업',
                width: 1200,
                height: 500,
                layout: {type:'vbox', align:'stretch'},
                items: [refItemGrid],
                tbar: ['->',{
                    itemId : 'closeBtn',
                    text: '닫기',
                    handler: function() {
                        refItemWindow.hide();
                    },
                    disabled: false
                }],
				listeners : {
					beforehide: function(me, eOpt) {
						refItemGrid.reset();
						refItemStore.clearData();
					},
					beforeshow: function ( me, eOpts ) {
						refItemStore.loadStoreRecords();
					}
				}
            })
        }
        refItemWindow.center();
        refItemWindow.show();
    };


	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
	    layout: {
	        type: 'uniTable',
	        columns: 3
	    },
	    trackResetOnLoad: true,
	    items: [{
	            fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
	            name: 'DIV_CODE',
	            xtype: 'uniCombobox',
	            comboType: 'BOR120',
	            value: UserInfo.divCode,
	            allowBlank: false,
	            listeners: {
	                change: function(combo, newValue, oldValue, eOpts) {
	                    combo.changeDivCode(combo, newValue, oldValue, eOpts);
	                    var field = orderNoSearch.getField('ORDER_PRSN');
	                    field.fireEvent('changedivcode', field, newValue, oldValue, eOpts); // panelResult의
	                    // 필터링
	                    // 처리
	                    // 위해..
	                }
	            }
	        }, {
	            fieldLabel: '<t:message code="unilite.msg.sMS122" default="수주일"/>',
	            xtype: 'uniDateRangefield',
	            startFieldName: 'FR_ORDER_DATE',
	            endFieldName: 'TO_ORDER_DATE',
	            width: 350,
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	            colspan: 2
	        }, {
	            fieldLabel: '<t:message code="unilite.msg.sMS573" default="sMS669"/>',
	            name: 'ORDER_PRSN',
	            xtype: 'uniCombobox',
	            comboType: 'AU',
	            comboCode: 'S010',
	            onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
	                if (eOpts) {
	                    combo.filterByRefCode('refCode1', newValue, eOpts.parent);
	                } else {
	                    combo.divFilterByRefCode('refCode1', newValue, divCode);
	                }
	            }
	        },
	        Unilite.popup('AGENT_CUST', {
	            fieldLabel: '<t:message code="unilite.msg.sMSR213" default="거래처"/>',
	            validateBlank: false,
	            colspan: 2,
	            listeners: {
	                applyextparam: function(popup) {
	                    popup.setExtParam({
	                        'AGENT_CUST_FILTER': ['1', '3']
	                    });
	                    popup.setExtParam({
	                        'CUSTOM_TYPE': ['1', '3']
	                    });
	                }
	            }
	        }),
	        // Unilite.popup('AGENT_CUST',{fieldLabel:'프로젝트' , valueFieldName:'PROJECT_NO',
	        // textFieldName:'PROJECT_NAME', validateBlank: false}),
	        Unilite.popup('DIV_PUMOK', {
	            colspan: 2,
	            listeners: {
	                applyextparam: function(popup) {
	                    popup.setExtParam({
	                        'DIV_CODE': orderNoSearch.getValue('DIV_CODE')
	                    });
	                }
	            }
	        }),
	        {
	            fieldLabel: '<t:message code="unilite.msg.sMS832" default="판매유형"/>',
	            name: 'ORDER_TYPE',
	            xtype: 'uniCombobox',
	            comboType: 'AU',
	            comboCode: 'S002'
	        },
	        {
	            fieldLabel: '<t:message code="unilite.msg.sMSR281" default="PO번호"/>',
	            name: 'PO_NUM'
	        }
	    ]
	}); // createSearchForm

    // 검색 모델(디테일)
    Unilite.defineModel('orderNoDetailModel', {
        fields: [
             { name: 'DIV_CODE'     ,text:'<t:message code="unilite.msg.sMS631" default="사업장"/>'           ,type: 'string' ,comboType:'BOR120'}
            ,{ name: 'ITEM_CODE'    ,text:'<t:message code="unilite.msg.sMR004" default="품목코드"/>'       	,type: 'string' }
            ,{ name: 'ITEM_NAME'    ,text:'<t:message code="unilite.msg.sMR349" default="품명"/>'     		,type: 'string' }
            ,{ name: 'SPEC'         ,text:'<t:message code="unilite.msg.sMSR033" default="규격"/>'    		,type: 'string' }

            ,{ name: 'ORDER_DATE'   ,text:'<t:message code="unilite.msg.sMS122" default="수주일"/>'        	,type: 'uniDate'}
            ,{ name: 'DVRY_DATE'    ,text:'<t:message code="unilite.msg.sMS123" default="납기일"/>'        	,type: 'uniDate'}

            ,{ name: 'ORDER_Q'      ,text:'<t:message code="unilite.msg.sMS543" default="수주량"/>'        	,type: 'uniQty' }
            ,{ name: 'ORDER_TYPE'   ,text:'<t:message code="unilite.msg.sMS832" default="판매유형"/>'       	,type: 'string' ,comboType:'AU', comboCode:'S002'}
            ,{ name: 'ORDER_PRSN'   ,text:'<t:message code="unilite.msg.sMS669" default="수주담당"/>'       	,type: 'string' ,comboType:'AU', comboCode:'S010'}
            ,{ name: 'PO_NUM'       ,text:'<t:message code="unilite.msg.sMSR281" default="PO번호"/>'      	,type: 'string' }
            ,{ name: 'PROJECT_NO'   ,text:'<t:message code="unilite.msg.sMR161" default="프로젝트번호"/>'       	,type: 'string' }
            ,{ name: 'ORDER_NUM'    ,text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>'       	,type: 'string' }
            ,{ name: 'SER_NO'       ,text:'<t:message code="unilite.msg.sMS783" default="수주순번"/>'       	,type: 'string' }
            ,{ name: 'CUSTOM_CODE'  ,text:'<t:message code="unilite.msg.sMSR213" default="거래처"/>'       	,type: 'string' }
            ,{ name: 'CUSTOM_NAME'  ,text:'<t:message code="unilite.msg.sMSR279" default="거래처명"/>'      	,type: 'string' }
            ,{ name: 'COMP_CODE'    ,text:'COMP_CODE'       ,type: 'string' }
            ,{ name: 'PJT_CODE'     ,text:'프로젝트코드'        	                                         		,type: 'string' }
            ,{ name: 'PJT_NAME'     ,text:'프로젝트'                                                        	,type: 'string' }
            ,{ name: 'FR_DATE'      ,text:'시작일'			                                                  	,type: 'string' }
            ,{ name: 'TO_DATE'      ,text:'종료일'         	                                              	,type: 'string' }
        ]
    });

 // 검색 스토어(디테일)
    var orderNoDetailStore = Unilite.createStore('orderNoDetailStore', {
        model: 'orderNoDetailModel',
        autoLoad: false,
        uniOpt: {
            isMaster: false, // 상위 버튼 연결
            editable: false, // 수정 모드 사용
            deletable: false, // 삭제 가능 여부
            useNavi: false // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 'sof100ukrvService.selectOrderNumDetailList'
            }
        },
        loadStoreRecords: function() {
            var param = orderNoSearch.getValues();
            var authoInfo = pgmInfo.authoUser; // 권한정보(N-전체,A-자기사업장>5-자기부서)
            var deptCode = UserInfo.deptCode; // 부서코드
            if (authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))) {
                param.DEPT_CODE = deptCode;
            }
            var outdivCode = panelResult.getValue('DIV_CODE'); //수주검색에 출고사업장 조건 추가
            param.OUT_DIV_CODE = outdivCode;

            console.log(param);
            this.load({
                params: param
            });
        }
    });

    // 검색 그리드(디테일)
    var orderNoDetailGrid = Unilite.createGrid('sof100ukrvOrderNoDetailGrid', {
        layout: 'fit',
        store: orderNoDetailStore,
        uniOpt: {
            useRowNumberer: false
        },
        columns: [
        	 { dataIndex: 'DIV_CODE'			,  width: 80 }
            ,{ dataIndex: 'ITEM_CODE'			,  width: 120 }
            ,{ dataIndex: 'ITEM_NAME'			,  width: 150 }
            ,{ dataIndex: 'SPEC'				,  width: 150 }
            ,{ dataIndex: 'ORDER_DATE'			,  width: 80 }
            ,{ dataIndex: 'DVRY_DATE'			,  width: 80 		,hidden:true}
            ,{ dataIndex: 'ORDER_Q'				,  width: 80 }
            ,{ dataIndex: 'ORDER_TYPE'			,  width: 90 }
            ,{ dataIndex: 'ORDER_PRSN'			,  width: 90 		,hidden:true}
            ,{ dataIndex: 'PO_NUM'				,  width: 100 }
            ,{ dataIndex: 'PROJECT_NO'			,  width: 90 }
            ,{ dataIndex: 'ORDER_NUM'			,  width: 120 }
            ,{ dataIndex: 'SER_NO'				,  width: 70 		,hidden:true}
            ,{ dataIndex: 'CUSTOM_CODE'			,  width: 120	 	,hidden:true}
            ,{ dataIndex: 'CUSTOM_NAME'			,  width: 200 }
            ,{ dataIndex: 'COMP_CODE'			,  width: 80 		,hidden:true}
            ,{ dataIndex: 'PJT_CODE'			,  width: 120 		,hidden:true}
            ,{ dataIndex: 'PJT_NAME'			,  width: 200 }
            ,{ dataIndex: 'FR_DATE'				,  width: 80	 	,hidden:true}
            ,{ dataIndex: 'TO_DATE'				,  width: 80 		,hidden:true}
        ],
        listeners: {
            onGridDblClick: function(grid, record, cellIndex, colName) {
                orderNoDetailGrid.returnData(record)
                searchOrderWindow.hide();
            }
        } // listeners
        ,
        returnData: function(record) {
            if (Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            panelResult.setValues({
                'ORDER_NUM': record.get('ORDER_NUM'),
                'ORDER_SEQ': record.get('SER_NO'),
                'DVRY_DATE': record.get('DVRY_DATE'),
                'ORDER_Q': record.get('ORDER_Q'),
                'CUSTOM_NAME': record.get('CUSTOM_NAME')
            });

        }
    });

    function openSearchOrderWindow() {
        if (!searchOrderWindow) {
            searchOrderWindow = Ext.create('widget.uniDetailWindow', {
                title: '수주번호검색',
                width: 1000,
                height: 580,
                layout: {
                    type: 'vbox',
                    align: 'stretch'
                },
                items: [orderNoSearch, orderNoDetailGrid],
                tbar: [
                       '->',{
                    itemId: 'searchBtn',
                    text: '조회',
                    handler: function() {
                        orderNoDetailStore.loadStoreRecords();
                    },
                    disabled: false
                }, {
                    itemId: 'closeBtn',
                    text: '닫기',
                    handler: function() {
                        searchOrderWindow.hide();
                    },
                    disabled: false
                }],
                listeners: {
                    beforehide: function(me, eOpt) {
                        orderNoSearch.clearForm();
                        orderNoDetailGrid.reset();
                        orderNoDetailStore.clearData();
                    },
                    beforeclose: function(panel, eOpts) {
                    },
                    show: function(panel, eOpts) {
                    	orderNoSearch.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
                    	orderNoSearch.setValue('FR_ORDER_DATE', UniDate.get('startOfMonth'));
                    	orderNoSearch.setValue('TO_ORDER_DATE', UniDate.get('today'));
                    }
                }
            })
        }
        searchOrderWindow.center();
        searchOrderWindow.show();
    }

    //작업지시 바코드폼
  	var wkordBarcodeForm = Unilite.createSearchForm('wkordBarcodeForm', {
  		layout	: {type : 'uniTable', columns : 1},
  		tdAttrs	: {align: 'center'},
  		border:true,
  		items	: [{		xtype: 'component',
									border: true,
									id:'barcodeValue',
									padding: '0 0 0 0',
									margin:'0 0 0 75',
									hidden:false,
									height: 65,
									width: 350
									//tdAttrs: {style: 'border-top: 1px; border:solid; #cccccc;padding-top: 2px;' }
					}]
  	});

	function openWkordBarcodeWindow() {
 		//if(!UniAppManager.app.checkForNewDetail()) return false;
 		if(!wkordBarcodeWindow) {
 			wkordBarcodeWindow = Ext.create('widget.uniDetailWindow', {
 				title		: '작업지시바코드',
 				width		: 350,
 				height		: 140,
 		 		//resizable	: false,
 				layout		:{type:'vbox', align:'stretch'},
 				tdAttrs	: {align: 'center'},
 				tbar:['->',{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							wkordBarcodeWindow.hide();
						},
						disabled: false
					}
				],
 				items		: [wkordBarcodeForm],
 				listeners	: {
 					beforehide	: function(me, eOpt) {

 					},
 					beforeclose: function( panel, eOpts ) {

 					},
 					beforeshow: function ( me, eOpts ) {

 					},
					show: function(me, eOpts) {
						$("#barcodeValue").barcode(panelResult.getValue('WKORD_NUM'), "code128");
					}
 				}
 			})
 		}
 		wkordBarcodeWindow.center();
 		wkordBarcodeWindow.show();
 	}







	/** main app
	 */
	Unilite.Main ({
		id		: 'pmp100ukrvApp',
		uniOpt	: {
			useDirectPrint: BsaCodeInfo.gsReportGubun == 'CLIP' ? true : false //인쇄미리보기, 인쇄(미리보기 없이 인쇄) 버튼 사용
		},
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid
			]
		}],
        uniOpt:{
        	showToolbar: true
//        	forceToolbarbutton:true
        },
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);

			if(BsaCodeInfo.gsReportGubun == 'CLIP'){
				UniAppManager.setToolbarButtons(['printPreview'],false);
				UniAppManager.setToolbarButtons(['directPrint'],false); //printPreview:인쇄미리보기, directPrint:인쇄
			}else{
				UniAppManager.setToolbarButtons(['print'],false);
			}

			detailGrid.disabledLinkButtons(false);
			this.setDefault(params);

			var requestBtn = detailGrid.down('#requestBtn')


		},
		onQueryButtonDown: function() {
			var orderNo = panelResult.getValue('WKORD_NUM');
			if(Ext.isEmpty(orderNo)) {
				opensearchInfoWindow();
//				productionNoMasterStore.loadStoreRecords();

			} else {
				//20170517 - 주석
//				detailGrid.getStore().setProxy(directProxy);/* proxy 변경 후 조회 */
				detailStore.loadStoreRecords();
//				panelSearch.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
				panelResult.getField('WKORD_Q').setReadOnly( false );
				panelResult.getField('ANSWER').setReadOnly( false );

			}
		},
		onNewDataButtonDown: function() {
			if(!this.checkForNewDetail()) return false;
			//Detail Grid Default 값 설정
			var param = panelResult.getValues();


			var count = detailGrid.getStore().getCount();
			if(count <= 0) {

				pmp260ukrvService.selectProgInfo(param, function(provider, response) {
					var records = response.result;
					if(!Ext.isEmpty(provider)) {
							Ext.each(records, function(record,i) {
								var seq = detailStore.max('SER_NO');
								if(!seq) seq = 1;
								else seq += 1;
								var linSeq = detailStore.max('LINE_SEQ');
								if(!linSeq) linSeq = 1;
								else linSeq += 1;
								var compCode		= UserInfo.compCode;
								var divCode			= panelResult.getValue('DIV_CODE');
								var wkordNum		= panelResult.getValue('WKORD_NUM');
								var workShopCode	= panelResult.getValue('WORK_SHOP_CODE');
								var itemCode		= panelResult.getValue('ITEM_CODE');
								var itemName		= panelResult.getValue('ITEM_NAME');
								var spec			= panelResult.getValue('SPEC');
								var prodtStartDate	= panelResult.getValue('PRODT_START_DATE');
								var prodtEndDate	= panelResult.getValue('PRODT_END_DATE');
								var prodtWkordDate	= panelResult.getValue('PRODT_WKORD_DATE');
								var lotNo			= panelResult.getValue('LOT_NO');
								var wkordQ			= panelResult.getValue('WKORD_Q');
								var progUnit		= panelResult.getValue('PROG_UNIT');
								var projectNo		= panelResult.getValue('PROJECT_NO');
								var pjtCode			= panelResult.getValue('PJT_CODE');
								var answer			= panelResult.getValue('ANSWER');
								var workEndYn		= Ext.getCmp('workEndYnRe').getChecked()[0].inputValue;
								var exchgType		= panelResult.getValue('EXCHG_TYPE');
								var reworkYn		= Ext.getCmp('reworkRe').getChecked()[0].inputValue;
								var progUnitQ		= 1;
								var wkPlanNum		= panelResult.getValue('WK_PLAN_NUM');
								//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터)
								var customName			= panelResult.getValue('CUSTOM_NAME');
								var customCode			= panelResult.getValue('CUSTOM_CODE');

								var r = {
									SER_NO			: seq,
									LINE_SEQ		: linSeq,
									COMP_CODE		: compCode,
									DIV_CODE		: divCode,
									WKORD_NUM		: wkordNum,
									WORK_SHOP_CODE	: workShopCode,
									ITEM_CODE		: itemCode,
									ITEM_NAME		: itemName,
									SPEC			: spec,
									PRODT_WKORD_DATE: prodtWkordDate,
									PRODT_START_DATE: prodtStartDate,
									PRODT_END_DATE	: prodtEndDate,
									LOT_NO			: lotNo,
									WKORD_Q			: wkordQ,
									PROG_UNIT		: progUnit,
									PROJECT_NO		: projectNo,
									REMARK			: answer,
									PJT_CODE		: pjtCode,
									WORK_END_YN		: workEndYn,
									STOCK_EXCHG_TYPE: exchgType,
									REWORK_YN		: reworkYn,
									PROG_UNIT_Q		: progUnitQ,
									WK_PLAN_NUM		: wkPlanNum,
									//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터)
									CUSTOM_NAME			: customName,
									CUSTOM_CODE		: customCode
								};
								detailGrid.createRow(r);
								detailGrid.setBeforeNewData(record);
							});
						}else{

							var seq = detailStore.max('SER_NO');
							if(!seq) seq = 1;
							else seq += 1;
							var linSeq = detailStore.max('LINE_SEQ');
							if(!linSeq) linSeq = 1;
							else linSeq += 1;
							var compCode		= UserInfo.compCode;
							var divCode			= panelResult.getValue('DIV_CODE');
							var wkordNum		= panelResult.getValue('WKORD_NUM');
							var workShopCode	= panelResult.getValue('WORK_SHOP_CODE');
							var itemCode		= panelResult.getValue('ITEM_CODE');
							var itemName		= panelResult.getValue('ITEM_NAME');
							var spec			= panelResult.getValue('SPEC');
							var prodtStartDate	= panelResult.getValue('PRODT_START_DATE');
							var prodtEndDate	= panelResult.getValue('PRODT_END_DATE');
							var prodtWkordDate	= panelResult.getValue('PRODT_WKORD_DATE');
							var lotNo			= panelResult.getValue('LOT_NO');
							var wkordQ			= panelResult.getValue('WKORD_Q');
							var progUnit		= panelResult.getValue('PROG_UNIT');
							var projectNo		= panelResult.getValue('PROJECT_NO');
							var pjtCode			= panelResult.getValue('PJT_CODE');
							var answer			= panelResult.getValue('ANSWER');
							var workEndYn		= Ext.getCmp('workEndYnRe').getChecked()[0].inputValue;
							var exchgType		= panelResult.getValue('EXCHG_TYPE');
							var reworkYn		= Ext.getCmp('reworkRe').getChecked()[0].inputValue;
							var progUnitQ		= 1;
							var wkPlanNum		= panelResult.getValue('WK_PLAN_NUM');
							//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터)
							var customName			= panelResult.getValue('CUSTOM_NAME');
							var customCode			= panelResult.getValue('CUSTOM_CODE');

							var r = {
								SER_NO			: seq,
								LINE_SEQ		: linSeq,
								COMP_CODE		: compCode,
								DIV_CODE		: divCode,
								WKORD_NUM		: wkordNum,
								WORK_SHOP_CODE	: workShopCode,
								ITEM_CODE		: itemCode,
								ITEM_NAME		: itemName,
								SPEC			: spec,
								PRODT_WKORD_DATE: prodtWkordDate,
								PRODT_START_DATE: prodtStartDate,
								PRODT_END_DATE	: prodtEndDate,
								LOT_NO			: lotNo,
								WKORD_Q			: wkordQ,
								PROG_UNIT		: progUnit,
								PROJECT_NO		: projectNo,
								REMARK			: answer,
								PJT_CODE		: pjtCode,
								WORK_END_YN		: workEndYn,
								STOCK_EXCHG_TYPE: exchgType,
								REWORK_YN		: reworkYn,
								PROG_UNIT_Q		: progUnitQ,
								WK_PLAN_NUM		: wkPlanNum,
								//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터)
								CUSTOM_NAME			: customName,
								CUSTOM_CODE		: customCode
							};
							detailGrid.createRow(r);


						}
					});
				} else {
					var seq = detailStore.max('SER_NO');
					if(!seq) seq = 1;
					else seq += 1;
					var linSeq = detailStore.max('LINE_SEQ');
					if(!linSeq) linSeq = 1;
					else linSeq += 1;
					var compCode		= UserInfo.compCode;
					var divCode			= panelResult.getValue('DIV_CODE');
					var wkordNum		= panelResult.getValue('WKORD_NUM');
					var workShopCode	= panelResult.getValue('WORK_SHOP_CODE');
					var itemCode		= panelResult.getValue('ITEM_CODE');
					var itemName		= panelResult.getValue('ITEM_NAME');
					var spec			= panelResult.getValue('SPEC');
					var prodtStartDate	= panelResult.getValue('PRODT_START_DATE');
					var prodtEndDate	= panelResult.getValue('PRODT_END_DATE');
					var prodtWkordDate	= panelResult.getValue('PRODT_WKORD_DATE');
					var lotNo			= panelResult.getValue('LOT_NO');
					var wkordQ			= panelResult.getValue('WKORD_Q');
					var progUnit		= panelResult.getValue('PROG_UNIT');
					var projectNo		= panelResult.getValue('PROJECT_NO');
					var pjtCode			= panelResult.getValue('PJT_CODE');
					var answer			= panelResult.getValue('ANSWER');
					var workEndYn		= Ext.getCmp('workEndYnRe').getChecked()[0].inputValue;
					var exchgType		= panelResult.getValue('EXCHG_TYPE');
					var reworkYn		= Ext.getCmp('reworkRe').getChecked()[0].inputValue;
					var progUnitQ		= 1;
					var wkPlanNum		= panelResult.getValue('WK_PLAN_NUM');
					//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터)
					var customName			= panelResult.getValue('CUSTOM_NAME');
					var customCode			= panelResult.getValue('CUSTOM_CODE');

					var r = {
						SER_NO			: seq,
						LINE_SEQ		: linSeq,
						COMP_CODE		: compCode,
						DIV_CODE		: divCode,
						WKORD_NUM		: wkordNum,
						WORK_SHOP_CODE	: workShopCode,
						ITEM_CODE		: itemCode,
						ITEM_NAME		: itemName,
						SPEC			: spec,
						PRODT_WKORD_DATE: prodtWkordDate,
						PRODT_START_DATE: prodtStartDate,
						PRODT_END_DATE	: prodtEndDate,
						LOT_NO			: lotNo,
						WKORD_Q			: wkordQ,
						PROG_UNIT		: progUnit,
						PROJECT_NO		: projectNo,
						REMARK			: answer,
						PJT_CODE		: pjtCode,
						WORK_END_YN		: workEndYn,
						STOCK_EXCHG_TYPE: exchgType,
						REWORK_YN		: reworkYn,
						PROG_UNIT_Q		: progUnitQ,
						WK_PLAN_NUM		: wkPlanNum,
						//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터)
						CUSTOM_NAME			: customName,
						CUSTOM_CODE		: customCode
					};
					detailGrid.createRow(r);
				}
			UniAppManager.app.setReadOnly(true);
			panelResult.getField('WKORD_Q').setReadOnly( false );
			panelResult.getField('ANSWER').setReadOnly( false );
		},
		onResetButtonDown: function() {
			panelResult.uniOpt.inLoading = true;
			this.suspendEvents();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitBinding();
			panelResult.getField('WKORD_NUM').focus();

			//20170517 - setReadOnly 호출도록 변경
			UniAppManager.app.setReadOnly(false);

			Ext.getCmp('reworkRe').setReadOnly(false);
			Ext.getCmp('workEndYnRe').setReadOnly(true);

//2020-11-18 작업지시 이중저장오류 원인 확인하기 위해 임시로 수주번호 수정로직 주석처리함
//			panelResult.getField('ORDER_NUM').setReadOnly(false);
//2020-11-18 END

			panelResult.getField('WORK_END_YN').setValue('N');
			panelResult.getField('REWORK_YN').setValue('N')

			this.setDefault();

			detailGrid.down('#requestBtn').setDisabled(false);
			panelResult.uniOpt.inLoading = false;

		},
		onSaveDataButtonDown: function(config) {
			/*var progUnitQ = detailStore.data.items.PROG_UNIT_Q;

			Ext.each(progUnitQ, function(record,i){

				if(record.get('PROG_UNIT_Q',(progUnitQ)) > 1){
					alret("tttt");
				}

			});*/

			detailStore.saveStore();
//			UniAppManager.app.onQueryButtonDown();
			if(panelResult.getField('WKORD_NUM') != ''){
				//panelSearch.getField('REWORK_YN').setReadOnly( false ); test
//			Ext.getCmp('workEndYn').setReadOnly(true);
				Ext.getCmp('workEndYnRe').setReadOnly(true);
			}
			else{
				//panelSearch.getField('REWORK_YN').setReadOnly( true ); test
//				Ext.getCmp('workEndYn').setReadOnly(false);
				Ext.getCmp('workEndYnRe').setReadOnly(false);
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					detailGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{								//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.product.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/

						/*---------삭제전 로직 구현 끝-----------*/
						if(deletable){
							detailGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('pmp260ukrvAdvanceSerch');
			if(as.isHidden()) {
				as.show();
			} else {
				as.hide()
			}
		},
		onPrintButtonDown: function () {
			if(!panelResult.getInvalidMessage()) return;	//필수체크

			if(Ext.isEmpty(panelResult.getValue('WKORD_NUM'))){
				Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
				return;
			}

			var param = panelResult.getValues();
			if(BsaCodeInfo.gsCompName == '(주)제이월드'){
				param["DEPT_NAME"] = '1';
			}else{
				param["DEPT_NAME"] = '0';
			}
			param["USER_LANG"] = UserInfo.userLang;
			param["PGM_ID"]= PGM_ID;
			param["MAIN_CODE"] = 'P010';//생산용 공통 코드
			param["sTxtValue2_fileTitle"]='작업지시서';
			var win = null;
			if(BsaCodeInfo.gsReportGubun == 'CLIP'){
				win = Ext.create('widget.ClipReport', {
					url: CPATH+'/prodt/pmp110clrkrv.do',
					prgID: 'pmp260ukrv',
					extParam: param
				});
			}else{
				win = Ext.create('widget.CrystalReport', {
					url: CPATH + '/prodt/pmp110crkrv.do',
					extParam: param
				});
			}

			win.center();
			win.show();
		},
		onDirectPrintButtonDown: function() { // 인쇄 버튼 handler : 미리보기 없이 인쇄
			if(!panelResult.getInvalidMessage()) return;	//필수체크

			if(Ext.isEmpty(panelResult.getValue('WKORD_NUM'))){
				Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
				return;
			}
			var param = panelResult.getValues();
			if(BsaCodeInfo.gsCompName == '(주)제이월드'){
				param["DEPT_NAME"] = '1';
			}else{
				param["DEPT_NAME"] = '0';
			}
			param["USER_LANG"] = UserInfo.userLang;
			param["PGM_ID"]= PGM_ID;
			param["MAIN_CODE"] = 'P010';//생산용 공통 코드
			param["sTxtValue2_fileTitle"]='작업지시서';
			var win = null;
			if(BsaCodeInfo.gsReportGubun == 'CLIP'){
				win = Ext.create('widget.ClipReport', {
					url: CPATH+'/prodt/pmp110clrkrv.do',
					prgID: 'pmp260ukrv',
					uniOpt:{
						directPrint:true
					},
					extParam: param
				});
			}else{
				win = Ext.create('widget.CrystalReport', {
					url: CPATH + '/prodt/pmp110crkrv.do',
					uniOpt:{
						directPrint:true
					},
					extParam: param
				});
			}
//			var win = Ext.create('widget.ClipReport', {
//				url: CPATH+'/prodt/pmp110clrkrv.do',
//				prgID: 'pmp260ukrv',
//				uniOpt:{
//					directPrint:true
//				},
//				extParam: param
//			});
			win.center();
			win.show();

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
		confirmSaveData: function(config) {
			var fp = Ext.getCmp('pmp260ukrvFileUploadPanel');
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

			panelResult.setValue('DIV_CODE', UserInfo.divCode );
			panelResult.setValue('PRODT_WKORD_DATE',new Date());
			panelResult.setValue('PRODT_START_DATE',new Date());
			panelResult.setValue('PRODT_END_DATE',new Date());
			panelResult.setValue('WKORD_Q',0.00);
			panelResult.setValue('ORDER_Q',0.00);
			panelResult.setValue('PRODT_DATE', panelResult.getValue('PRODT_WKORD_DATE'));


//			panelSearch.getField('SPEC').setReadOnly(true);
//			panelResult.getField('SPEC').setReadOnly(true);
			panelResult.getField('PROG_UNIT').setReadOnly(true);
			panelResult.getField('WORK_END_YN').setReadOnly(true);

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);

			panelResult.getField('DIV_CODE').setReadOnly(false);
			panelResult.getField('WKORD_NUM').setReadOnly(true);
			panelResult.getField('EXCHG_TYPE').setReadOnly(true);

			//20190124 추가 : 화면 오픈 시, 거래처 필드 수정가능하도록 변경
			panelResult.getField('CUSTOM_NAME').setReadOnly( false );

			prodtCommonService.checkReportInfo({"PGM_ID" : PGM_ID}, function(provider, response) {
				if(Ext.isEmpty(provider)){
					UniAppManager.setToolbarButtons('print', false);
				}else{
					UniAppManager.setToolbarButtons('print', true);
				}
			});
			panelResult.getField('SPEC').setReadOnly( true );


			this.processParams(params);

			if(BsaCodeInfo.gsSiteCode == 'NOVIS'){
				panelResult.down('#btnPrint1').setText('<div style="color: blue">작업지시서</div>');
				panelResult.down('#btnPrint2').setHidden(true);
				panelResult.down('#btnPrint4').setHidden(true);


			}


		},
		processParams: function(params) {
			if(!Ext.isEmpty(params)){
				this.uniOpt.appParams = params;
				if(params.PGM_ID == 'ppl113ukrv') {
					if(!Ext.isEmpty(params.WKORD_NUM)){
						panelResult.setValues({
							'DIV_CODE':			params.DIV_CODE,
							'WKORD_NUM':		params.WKORD_NUM,
							'WORK_SHOP_CODE':	params.WORK_SHOP_CODE
						});

		   				detailStore.loadStoreRecords();

							panelResult.getField('WORK_SHOP_CODE').setReadOnly( true );
							panelResult.getField('ITEM_CODE').setReadOnly( true );
							panelResult.getField('ITEM_NAME').setReadOnly( true );
							panelResult.getField('SPEC').setReadOnly( true );

							panelResult.getField('WKORD_Q').setReadOnly( false );
							panelResult.getField('ANSWER').setReadOnly( false );

//
		   			}else{

						panelResult.setValues({
							'DIV_CODE':			params.DIV_CODE,
							'WKORD_NUM':		params.WKORD_NUM,
							'WORK_SHOP_CODE':	params.WORK_SHOP_CODE,
							'ITEM_CODE':		params.ITEM_CODE,
							'ITEM_NAME':		params.ITEM_NAME,
							'SPEC':				params.SPEC,
							'PROJECT_NO':		params.PROJECT_NO,

							'ORDER_NUM':		params.ORDER_NUM,
							'ORDER_SEQ':		params.SEQ,
							'ORDER_Q':			params.ORDER_UNIT_Q,
							'DVRY_DATE':		UniDate.getDbDateStr(params.DVRY_DATE),

							'WKORD_Q':			params.WK_PLAN_Q,
							'WK_PLAN_NUM':		params.WK_PLAN_NUM,
							'CUSTOM_NAME':		params.CUSTOM_NAME,
							'PRODT_START_DATE':	UniDate.getDbDateStr(params.PRODT_PLAN_DATE),
							'PROG_UNIT': params.STOCK_UNIT
						});
//
//						panelResult.setValue('PRODT_START_DATE',params.PRODT_PLAN_DATE,false);
	//					if(record.get('EXPIRATION_DAY') != 0){
	//						panelResult.setValue('EXPIRATION_DATE',UniDate.getDbDateStr(UniDate.add(panelResult.getValue('PRODT_WKORD_DATE'), {months: +record.get('EXPIRATION_DAY'), days:-1})));
	//					}else{
	//						panelResult.setValue('EXPIRATION_DATE', '');
	//					}

						detailGrid.reset();
						detailStore.clearData();

						Ext.getCmp('reworkRe').setReadOnly(false);
						Ext.getCmp('workEndYnRe').setReadOnly(true);

						panelResult.getField('DIV_CODE').setReadOnly( true );
						panelResult.getField('WKORD_NUM').setReadOnly( true );
						if(!Ext.isEmpty(panelResult.getValue('WORK_SHOP_CODE'))){
							panelResult.getField('WORK_SHOP_CODE').setReadOnly( true );
							UniAppManager.app.onNewDataButtonDown();
						}else{
							panelResult.getField('WORK_SHOP_CODE').setReadOnly( false );
						}
						panelResult.getField('ITEM_CODE').setReadOnly( true );
						panelResult.getField('ITEM_NAME').setReadOnly( true );
						panelResult.getField('EXCHG_TYPE').setReadOnly( true );
						panelResult.getField('PROG_UNIT').setReadOnly( true );
						panelResult.getField('WKORD_Q').setReadOnly( false );
						panelResult.getField('ANSWER').setReadOnly( false );

						detailGrid.down('#requestBtn').setDisabled(true);

					}
				}
			}
		},
		setReadOnly: function(flag) {
			panelResult.getField('DIV_CODE').setReadOnly(true);
			panelResult.getField('WKORD_NUM').setReadOnly(true);
			panelResult.getField('WORK_END_YN').setReadOnly(flag);
			panelResult.getField('EXCHG_TYPE').setReadOnly(flag);
			Ext.getCmp('reworkRe').setReadOnly(flag);

			//20190123 추가(PMP100T.CUSTOM_NAME 저장할 데이터)
			if(Ext.isEmpty(panelResult.getValue('ORDER_NUM'))) {
				panelResult.getField('CUSTOM_NAME').setReadOnly( false );
			} else {
				panelResult.getField('CUSTOM_NAME').setReadOnly( true );
			}
		},
		checkForNewDetail:function() {
			if(panelResult.setAllFieldsReadOnly(true)){
				return panelResult.setAllFieldsReadOnly(true);
			}
		}
	});

	/*선택한 품목의 품목계정에 따른 출력 버튼 활성화*/
	function fn_printChk( itemAccount ){
		var itemAccountPrintStore = 	Ext.data.StoreManager.lookup('itemAccountPrintStore');//품목계정별 출력양식 활성화를 위해 품목계정 정보를 가져옴
		Ext.each(itemAccountPrintStore.data.items, function(comboData, idx)	{
			if(comboData.get('value') == itemAccount){
				if(comboData.get('refCode3') == '10'){
					panelResult.down('#btnPrint1').setDisabled(false); //btnPrint1 포장지시서
					panelResult.down('#btnPrint2').setDisabled(true);  //btnPrint2 제조지시서
					panelResult.down('#btnPrint3').setDisabled(true);  //btnPrint3 칭량지시서
				}else if(comboData.get('refCode3') == '20'){
					panelResult.down('#btnPrint1').setDisabled(true);
					panelResult.down('#btnPrint2').setDisabled(false);
					panelResult.down('#btnPrint3').setDisabled(false);
				}else{
					panelResult.down('#btnPrint1').setDisabled(true);
					panelResult.down('#btnPrint2').setDisabled(true);
					panelResult.down('#btnPrint3').setDisabled(true);
				}
			}
		});
	}


	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PROG_UNIT_Q" : // 원단위량
					var wkordQ = panelResult.getValue("WKORD_Q");

					if(newValue <= 0 ){
						//0보다 큰수만 입력가능합니다.
						rv='<t:message code="system.message.product.message023" default="입력한 값이 0보다 큰 수이어야 합니다."/>';
						break;
					}
					if(newValue > 0){
						record.set('WKORD_Q',(newValue * wkordQ));
						break;
						// 작업지시량 = 원단위량 * newValue
					}break;

				case "WKORD_Q", "LINE_SEQ": // 작업지시량 , 공정순번

					if(newValue <= 0 ){
							//0보다 큰수만 입력가능합니다.
							rv='<t:message code="system.message.product.message023" default="입력한 값이 0보다 큰 수이어야 합니다."/>';
							break;
					}break;
				case "PROG_UNIT" : //
					// 정확한 코드를 입력하시오 sMB081
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