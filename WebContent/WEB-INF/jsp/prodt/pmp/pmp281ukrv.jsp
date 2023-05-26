<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp281ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp281ukrv" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="OU" />		<!-- 창고-->
	<t:ExtComboStore comboType="WU" />		<!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /><!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /><!-- 수불담당 -->

</t:appConfig>

<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
#window-1215-body {
	width: 800px;
}
#ext-element-47 {
	width: 800px;
}
.x-btn.my-over {
    background: blue;
}
/*Ext is not consistent */
.x-btn.x-btn-my-pressed {
    background: Red !important;
}
.x-btn-my-pressed {
    background: Red !important;
}
.keyboardInputInitiator {
    float:left !important;
    margin-top:-20px !important;
    margin-left:140px !important;
}

.my-button-right{

  background: url('<c:url value="/extjs_6.2.0/resources/theme-classic/images/tools/tool-sprites.gif" />') ;
  transform:scale(4,2.1)!important;
  background-position: 0 -165px;
}
.my-button-left{
  background-image: url('<c:url value="/extjs_6.2.0/resources/theme-classic/images/tools/tool-sprites.gif" />');
  transform:scale(4,2.1)!important;
  background-position: 0 -180px;

}
.x-tool-img{

	 transform:scale(4,2.1)!important;
}
/*#btnWkord:hover {

}*/
</style>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script type="text/javascript" src="<c:url value='/resources/js/virtualKeyboard/keyboard.js' />" ></script>
<link rel="stylesheet" type="text/css" href='<c:url value="/resources/js/virtualKeyboard/keyboard.css" />'>
<script type="text/javascript" >

var searchPop1Window;	//팝업 윈도우1
var searchPop2Window;	//팝업 윈도우2
var lotNoList = null;
var firstLoadGubun = 'N';
var scaleIframe = '';
var weighing = 'N';
var gsRecord ;
var gbBtnWkordPressed = false;
var gbBtnNotOutPressed = false;
var gbBtnOutPressed = false;
var gsprintYn ;
var gsKioskUrl;
var gsBeforeLotNo;
var gsFrameHeight = 760;
var gsScanLotCode = '';
function appMain() {

	var gsOutGubun 		 = '${gsOutGubun}';
	var gsInOutPrsn 	 = '${gsInOutPrsn}';
	var gsKioskConUrl 	 = '${gsKioskConUrl}';
	var gsInOutPrsnLogin = '${gsInOutPrsnLogin}';
	var gubunStore = Unilite.createStore('gubunComboStore', {
        fields: ['text', 'value'],
        data :  [
            {'text':'<t:message code="system.label.purchase.confirm" default="확인"/>'  , 'value':'Y'},
            {'text':'<t:message code="system.label.purchase.notconfirm" default="미확인"/>'  , 'value':'N'}
        ]
    });
	var divideStore = Unilite.createStore('divideComboStore', {
        fields: ['text', 'value'],
        data :  [
            {'text':'10'  , 'value':'10'},
            {'text':'20'  , 'value':'20'},
            {'text':'30'  , 'value':'30'},
            {'text':'40'  , 'value':'40'},
            {'text':'50'  , 'value':'50'},
            {'text':'60'  , 'value':'60'},
            {'text':'70'  , 'value':'70'},
            {'text':'80'  , 'value':'80'},
            {'text':'90'  , 'value':'90'},
            {'text':'100'  , 'value':'100'},
            {'text':'200'  , 'value':'200'},
            {'text':'300'  , 'value':'300'},
            {'text':'400'  , 'value':'400'},
            {'text':'500'  , 'value':'500'}

        ]
    });



	var pop2Proxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 'pmp281ukrvService.pop2SelectList',
			create	: 'pmp281ukrvService.insertPop2',
			update	: 'pmp281ukrvService.updatePop2',
//			destroy	: 'pmp281ukrvService.deleteDetail',
			syncAll	: 'pmp281ukrvService.savePop2'
		}
	});
	var pop1_2Proxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 'pmp281ukrvService.pop1_2SelectList',
//			create	: 'pmp281ukrvService.insertPop2',
//			update	: 'pmp281ukrvService.updatePop2',
			destroy	: 'pmp281ukrvService.deletePop1_2',
			syncAll	: 'pmp281ukrvService.savePop1_2'
		}
	});
	Unilite.defineModel('detailModel', {
		fields: [
//			{name: 'AA1'			,text: '<t:message code="system.label.product.seq" default="순번"/>' 			,type: 'int'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>' 			,type: 'string'},
			{name: 'WEEK_NUM'			,text: '<t:message code="system.label.product.planweeknum" default="계획주차"/>' 			,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.itemnum" default="품번"/>' 			,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname2" default="품명"/>' 			,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.product.spec" default="규격"/>' 			,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>' 			,type: 'string'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workqty" default="작업량"/>' 			,type: 'uniQty'},
			{name: 'ITEM_ACCOUNT'			,text: '<t:message code="system.label.product.itemaccount" default="품목계정"/>' 			,type: 'string',comboType:'AU', comboCode:'B020' },
			{name: 'LOT_NO'			,text: 'LOT NO'			,type: 'string'},
			{name: 'GUBUN'			,text: '칭량상태' 			,type: 'string'},
			{name: 'PMR_STATUS'		,text: '제조실적상태' 			,type: 'string'},

			{name: 'PRODT_WKORD_DATE'			,text: 'PRODT_WKORD_DATE'			,type: 'string'}

		]
	});

	var detailStore = Unilite.createStore('detailStore',{
		model: 'detailModel',
		proxy: {
			type: 'direct',
			api: {
				read: 'pmp281ukrvService.selectList'
			}
		},
		autoLoad: false,
		uniOpt: {
			isMaster: true,	// 상위 버튼 연결
			editable: false,		// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			var scanCode = panelSearch.getValue('WKORD_NUM').split("/");
			param.WKORD_NUM = scanCode[0];
			this.load(
				{params : param,
					callback : function(records, operation, success) {
						if(success)	{


							if(!Ext.isEmpty(panelSearch.getValue('WKORD_NUM'))) {
								if(Ext.isEmpty(records)) {
									beep();
									Unilite.messageBox('<t:message code="system.message.inventory.message013" default="해당자료가 없습니다."/>');
									panelSearch.setValue('WKORD_NUM', '');
	//									return false;
								}else{

									if (!searchPop2Window) {
											searchPop2Window = Ext.create('widget.uniDetailWindow', {
												id: 'pop2Page',
												title: '팝업',
												width: 1270,
												height:760,
												modal: true,
												layout: 'border',
												hidden:false,
												items: [pop2Search,
														{layout: {type: 'hbox', align: 'stretch'},
															xtype	: 'container',
															region: 'center',
															tdAttrs : {align: 'right'},
															defaults: {holdable: 'hold'},
															margin      : '0 0 2 0',
															items	: [pop2Grid,
																		 {      xtype: 'splitter',
																		 		id:'split1',
																		        height: 20,
																		        width:20,
																				collapseDirection: 'right'

																		     },
																		{layout: {type: 'vbox', align: 'stretch'},
																			xtype	: 'panel',
																			region: 'east',
																			id:'balancePanel1',
																			//collapsible: true,
																			height: 500,
																			collapseDirection: 'left',
																			tdAttrs : {align: 'right'},
																			flex:1,
																			defaults: {holdable: 'hold'},
																			margin      : '0 0 2 0',
																			items	: [
																						pop2SearchBalance,panelSearch2
																		   	],
																		   	listeners	: {
																				collapse: function () {
																					$(".x-tool-tool-el.x-tool-img.x-tool-expand-right").hide();
																					pop2Grid.down('#collapsedBtn').setHidden(false);
																					pop2Grid.down('#expandBtn').setHidden(true);
																				},
																				expand: function() {
																					$(".x-tool-tool-el.x-tool-img.x-tool-expand-right").hide();
																					pop2Grid.down('#collapsedBtn').setHidden(true);
																					pop2Grid.down('#expandBtn').setHidden(false);
																				}
																			}
																		 }
														   			]
														   }






													],
												tbar: ['->',{
													itemId: 'searchBtn',
													text: '<t:message code="system.label.product.inquiry" default="조회"/>',
													minWidth: 100,
													handler: function() {
								//						if(!pop2Search.getInvalidMessage()) return;	//필수체크
														//fieldStyle	: 'text-align: center;',
														pop2Store.loadStoreRecords();
														//this.fireEvent('mouseover', this, e);
														//Ext.getCmp('pop2Page').down('#searchBtn').setBackground-image('-ms-linear-gradient(top, #e4f3ff, #d9edff 48%, #c2d8f2 52%, #c6dcf6)');
													},
													disabled: false
												},{
													itemId: 'confirmBtn',
													text: '저장',
													hidden: true,
													minWidth:100,
													handler: function() {
														if(!pop2Search.getInvalidMessage()) return;	//필수체크
								                		Ext.getCmp('pop2Page').getEl().mask('저장 중...','loading-indicator');
														pop2Store.saveStore();
													},
													disabled: false
												},{
													itemId: 'closeBtn',
													text: '<t:message code="system.label.product.close" default="닫기"/>',
													minWidth: 100,
													hidden: false,
													handler: function() {
														searchPop2Window.hide();
														//팝업닫을 때 기존 저울 연결을 끊습니다.
														//scaleIframe = $("#iFrameBalance-iframeEl").get(0).contentWindow;
														//scaleIframe.postMessage({ command: "disConnectStomp" }, '*');

													},
													disabled: false
												}],
												listeners: {
													beforehide: function(me, eOpt) {
														pop2Search.clearForm();
														pop2Grid.reset();
														pop2Store.clearData();
														firstLoadGubun = 'N';

													},
													beforeclose: function(panel, eOpts) {
													},
													beforeshow: function(panel, eOpts) {
														pop2Search.setValue('PRINT_YN',true);
														pop2Search.setValue('PRINT_Q',1);
								//						pop2Search.setValue('INOUT_PRSN',panelSearch.getValue('INOUT_PRSN'));
														pop2Search.getField('TYPE_AB').setValue('A');//수동
														pop2SearchBalance.setHidden(false);


													},
													show: function(panel, eOpts) {
														firstLoadGubun = 'Y';

														pop1Search.setValue('SCAN_CODE','');
														pop2Store.loadStoreRecords();
														Ext.getCmp('balancePanel1').expand();
														//pop2Search.getField('INOUT_Q').focus();
														pop2Search.getField('LOT_NO').focus();
														var param = pop2SearchBalance.getValues();
														$("#split1").append('<div id="split1-collapseEl" data-ref="collapseEl" role="presentation" class="x-collapse-el x-layout-split-right" style="margin-left:8px;transform:scale(2.5,2);" id="splitChildDiv"></div>');


													}
												}
											})

								}
										searchPop2Window.center();
										searchPop2Window.show();
										searchPop2Window.hide();


										scaleIframe = $("#iFrameBalance-iframeEl").get(0).contentWindow;
										if(weighing == 'N'){
												setTimeout( function() {
															scaleIframe.postMessage({
															command: 'setValue',	//명령어
															id: '키오스크0', 	//연계아이디
															lotNo: "",	//로트번호
															item: "",	//출고품목
															outStock: {qty:1, unit: 'G'},	//출고단위
															errorRange: 1,	//오차
															erpLoginID: UserInfo.userID	//erp 로그인 아이디
															}, '*');
															setTimeout( function() {
																scaleIframe.postMessage({ command: "connectStomp" }, '*')
																weighing = 'Y';
															}, 2000 );
												}, 1000 );
											}



											pop1Search.setHidden(false);
											detailGrid.setHidden(true);
											pop1Grid.setHidden(false);
											pop1_2Grid.setHidden(true);
											pop1Grid.setRegion('center');
											detailGrid.setRegion('south');
											pop1_2Grid.setRegion('west');
											pop1Store.loadStoreRecords();
											var selectedRecord = detailGrid.getSelectedRecord();
											pop1Search.setValue('WKORD_NUM',selectedRecord.get('WKORD_NUM'));
											pop1Search.setValue('PRODT_WKORD_DATE',selectedRecord.get('PRODT_WKORD_DATE'));
											pop1Search.setValue('ITEM_CODE',selectedRecord.get('ITEM_CODE'));
											pop1Search.setValue('WKORD_Q',selectedRecord.get('WKORD_Q'));
											pop1Search.setValue('STOCK_UNIT',selectedRecord.get('STOCK_UNIT'));
											pop1Search.setValue('ITEM_NAME',selectedRecord.get('ITEM_NAME'));
											pop1Search.setValue('INOUT_DATE_2',UniDate.get('today'));
											setTimeout( function() {
												pop1Search.getField('SCAN_CODE').focus();
											}, 50 );
												}
											}
						}
						setTimeout( function() {
							panelSearch.getField('WKORD_NUM').focus();
						}, 50 );
					}
				}
			);
		}
		/*saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						detailStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);

			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},

		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			},
			metachange:function( store, meta, eOpts ){
			}
		}*/
	});

	var detailGrid = Unilite.createGrid('detailGrid', {
		store: detailStore,
		region: 'center',
		layout: 'fit',
		title: '<div style="font-family: Gulim ;font-weight: bold; font-size: 24px;color: blue;"> 작업지시내역 </div>',
		uniOpt: {
			expandLastColumn: true,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: true,
			onLoadSelectFirst: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			}
		},
		selModel: 'rowmodel',
		columns: [
//			{ dataIndex: 'AA1'					, width: 100},
			{ dataIndex: 'WKORD_NUM'			, width: 160},
			{ dataIndex: 'WEEK_NUM'				, width: 100},
			{ dataIndex: 'ITEM_CODE'			, width: 120},
			{ dataIndex: 'ITEM_NAME'			, width: 300},
			{ dataIndex: 'SPEC'					, width: 100},
			{ dataIndex: 'STOCK_UNIT'			, width: 100,align:'center'},
			{ dataIndex: 'WKORD_Q'				, width: 150},
			{ dataIndex: 'ITEM_ACCOUNT'			, width: 100,align:'center'},
			{ dataIndex: 'LOT_NO'				, width: 100},
			{ dataIndex: 'GUBUN'				, width: 100,align:'center'},
			{ dataIndex: 'PMR_STATUS'			, width: 140,align:'center'}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
					panelSearch.setValue('WKORD_NUM', '');

					pop1Search.setHidden(false);
					detailGrid.setHidden(true);
					pop1Grid.setHidden(false);
					pop1_2Grid.setHidden(true);
					pop1Grid.setRegion('center');
					detailGrid.setRegion('south');
					pop1_2Grid.setRegion('west');
					pop1Store.loadStoreRecords();
					var selectedRecord = detailGrid.getSelectedRecord();
					pop1Search.setValue('WKORD_NUM',selectedRecord.get('WKORD_NUM'));
					pop1Search.setValue('PRODT_WKORD_DATE',selectedRecord.get('PRODT_WKORD_DATE'));
					pop1Search.setValue('ITEM_CODE',selectedRecord.get('ITEM_CODE'));
					pop1Search.setValue('WKORD_Q',selectedRecord.get('WKORD_Q'));
					pop1Search.setValue('STOCK_UNIT',selectedRecord.get('STOCK_UNIT'));
					pop1Search.setValue('ITEM_NAME',selectedRecord.get('ITEM_NAME'));
					pop1Search.setValue('INOUT_DATE_2',UniDate.get('today'));
					setTimeout( function() {
						pop1Search.getField('SCAN_CODE').focus();
					}, 50 );
					pop1Search.down('#btnWeighingPop').setHidden(false);
					pop1Search.down('#btnLabel').setHidden(true);
					setTimeout( function() {
						Ext.getCmp('btnWkord').setText('<div style="color: blue;font-size:20p;text-shadow:none;">작업지시내역</div>');
						Ext.getCmp('btnNotOut').setText('<div style="color: blue;font-size:24px;text-shadow: 1px 1px 1px gray;">미출고현황</div>');
						Ext.getCmp('btnOut').setText('<div style="color: blue;font-size:20px;text-shadow:none;">출고현황</div>');
						$('#btnWkord').removeClass('x-btn-over');
						$('#btnOut').removeClass('x-btn-over');
					},100)
				/*	pop1Search.down('#btnPrint3').setHidden(true);
					pop1Search.down('#btnNotOut').setHidden(false);*/
			}, afterrender: function(grid) {
				//$('#btnWkord').attr('class','x-btn x-unselectable x-btn-default-small x-btn-over');
						//function openSearchPop2Window() {





					}

		}
		/*listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['WKORD_NUM'])) {
					return true;
				} else {
					return false;
				}
			}
		}*/

	});


	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region:'north',
		layout: {type : 'uniTable', columns : 4},
		padding: '1 1 1 1',
		border: true,
//		defaults:{
//			labelWidth:140,
//			width:375
//		},
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
			name: 'DIV_CODE',
			xtype:'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			value: UserInfo.divCode,
			holdable: 'hold',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelSearch.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..

				}
			}
		},{
			fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			name:'WKORD_NUM',
			labelWidth: 200,
			xtype:'uniTextfield',
			listeners: {
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						if(!panelSearch.getInvalidMessage()){
							panelSearch.setValue('WKORD_NUM','');
							panelSearch.getField('WKORD_NUM').focus();
							return;   //필수체크
						}
						var newValue = panelSearch.getValue('WKORD_NUM');

						if(!Ext.isEmpty(newValue)) {
							detailStore.loadStoreRecords();
//							setTimeout( function() {
//								var record = detailGrid.getSelectedRecord();
//								if(Ext.isEmpty(record)) {
//									beep();
//									Ext.Msg.alert('확인','<t:message code="system.message.inventory.message013" default="해당자료가 없습니다."/>');
//									panelSearch.setValue('WKORD_NUM', '');
////									return false;
//								}else{
//									openSearchPop1Window();
//								}
//			   				}, 500 );
						}
					}
				}
			}
		},{
			fieldLabel: '수불담당자',
//			margin: '0 0 0 -100',
			name: 'INOUT_PRSN',
			xtype: 'uniCombobox',
			labelWidth: 200,
			comboType:'AU',
			colspan	 : 2,
			comboCode:'B024',
			allowBlank:false,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.getField('WKORD_NUM').focus();
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.product.selectprinter" default="프린터 선택"/>',
			id:'selectPrinterchk',
//			margin: '0 0 0 -60',
//			labelWidth: 100,
			labelWidth: 200,
			hidden: true,
			width: 500,
			items: [{
				boxLabel: 'TOSHIBA(소)',
				width: 150,
				name: 'SELPRINTER',
				inputValue: 'TOSHIBA',
				checked: true
			},{
				boxLabel : 'ZEBRA(대)',
				width: 150,
				name: 'SELPRINTER',
				inputValue: 'ZEBRA'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					/* if(newValue.REWORK_YN =='Y'){

						panelResult.getField('EXCHG_TYPE').setReadOnly( false );
						panelResult.setValue('EXCHG_TYPE', "B");

					}else if(newValue.REWORK_YN =='N'){

						panelResult.setValue('EXCHG_TYPE', "");
						panelResult.getField('EXCHG_TYPE').setReadOnly( true );
					} */
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			name: 'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B020'
		},{ //$('#toolbar-1802-innerCt').addClass('x-btn');
			fieldLabel: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'PRODT_WKORD_DATE_FR',
			endFieldName: 'PRODT_WKORD_DATE_TO',
//			startDate: UniDate.get('startOfMonth'),
			labelWidth: 180,
			endDate: UniDate.get('today'),
			startDateFieldWidth : 120,
			endDateFieldWidth:120,
			pickerWidth 	: 386,
  			pickerHeight 	: 280
			//width: 475
			,listeners: {
	            	 el: {
		            		mouseover: function(e, elem, eOpts) {

		            		},mouseout: function(e, elem, eOpts) {


		            		},click: function(e, elem, eOpts) {
		            				/*$('.x-btn-inner-default-toolbar-small').removeClass("x-btn-inner");
										var winIds = $('.x-toolbar,x-docked,x-toolbar-default,x-docked-top,x-toolbar-docked-top,x-toolbar-default-docked-top,x-box-layout-ct');
										if(Ext.isEmpty(winIds[5])){
											return false;
										}
										var winChildNodes = winIds[5].children[1];
										var winChildNodes2 = winChildNodes.childNodes
										//alert(winChildNodes.childNodes[0].childNodes);
										for(var i=0; i<winChildNodes.childNodes[0].childElementCount; i++){
											if(i == 0){
												$('#'+ winChildNodes.childNodes[0].childNodes[i].id).css("left","0px");
											}else if(i == 1){
												$('#'+ winChildNodes.childNodes[0].childNodes[i].id).css("left","62px");
											}else if(i == 2){
												$('#'+ winChildNodes.childNodes[0].childNodes[i].id).css("left","124px");
											}else if(i == 3){
												$('#'+ winChildNodes.childNodes[0].childNodes[i].id).css("left","186px");
											}else if(i == 4){
												$('#'+ winChildNodes.childNodes[0].childNodes[i].id).css("left","224px");
											}else if(i == 5){
												$('#'+ winChildNodes.childNodes[0].childNodes[i].id).css("left","262px");
											}else if(i == 6){
												$('#'+ winChildNodes.childNodes[0].childNodes[i].id).css("left","300px");
											}else if(i == 7){
												$('#'+ winChildNodes.childNodes[0].childNodes[i].id).css("left","334px");
											}

										}

										var winId3 = $('.x-window-body,x-window-body-default,x-box-layout-ct,x-window-body-default,x-resizable,x-window-body-resizable,x-window-body-default-resizable').attr('id');
										$('#' + winId3).css("top","49px");
										var winId4 = $('.x-window,x-layer,x-window-default,x-border-box,x-resizable,x-window-resizable,x-window-default-resizable,x-unselectable').attr('id');
										$('#' + winId4).css("height","300px");
										$('#' + winIds[5].children[1].id).css("height","22px");
										var winId5 = $('.x-css-shadow').attr('id')
										$('#' + winId5).css("height","296px");*/

		            		}
	            	 }
				}
		},{
			xtype: 'radiogroup',
			fieldLabel: '칭량상태',
//			margin: '0 0 0 -60',
//			labelWidth: 100,
			labelWidth: 180,
			colspan	 : 2,
			items: [{
				boxLabel: '전체',
				width: 60,
				name: 'GUBUN',
				inputValue: ''
			},{
				boxLabel : '대기',
				width: 60,
				name: 'GUBUN',
				inputValue: 'B',
				checked: true
			},{
				boxLabel : '진행',
				width: 60,
				name: 'GUBUN',
				inputValue: 'C'
			},{
				boxLabel : '완료',
				width: 60,
				name: 'GUBUN',
				inputValue: 'D'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					setTimeout( function() {
						UniAppManager.app.onQueryButtonDown();
							pop1Search.setHidden(true);
							detailGrid.setHidden(false);
							pop1Grid.setHidden(true);
							pop1_2Grid.setHidden(true);
							pop1Grid.setRegion('south');
							detailGrid.setRegion('center');
							pop1_2Grid.setRegion('west');
							Ext.getCmp('btnWkord').setText('<div style="color: blue;font-size:24px;text-shadow: 1px 1px 1px gray;">작업지시내역</div>');
							Ext.getCmp('btnNotOut').setText('<div style="color: blue;font-size:20px;text-shadow:none;">미출고현황</div>');
							Ext.getCmp('btnOut').setText('<div style="color: blue;font-size:20px;text-shadow:none;">출고현황</div>');
							$('#btnNotOut').removeClass('x-btn-over');
							$('#btnOut').removeClass('x-btn-over');
	   				}, 50 );
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '제조실적상태',
			labelWidth: 180,
			hidden: true,
			items: [{
				boxLabel: '전체',
				width: 80,
				name: 'PMR_STATUS',
				inputValue: '',
				checked: true
			},{
				boxLabel : '미완료',
				width: 80,
				name: 'PMR_STATUS',
				inputValue: 'A'
			},{
				boxLabel : '완료',
				width: 80,
				name: 'PMR_STATUS',
				inputValue: 'B'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					setTimeout( function() {
						UniAppManager.app.onQueryButtonDown();



	   				}, 100 );
				}
			}
		},{     xtype       : 'button',
	            text        : '<div style="color: blue">작업지시내역</div>',
	            width       : 160,
	            height		: 50,
	            margin      : '0 0 2 50',
	            itemId:'btnWkord',
	            id:'btnWkord'  ,
	            //pressed		: false,
	            //enableToggle: true,
	            tdAttrs     : {align: 'left'},
	            handler     : function(btn) {

							pop1Search.setHidden(true);
							detailGrid.setHidden(false);
							pop1Grid.setHidden(true);
							pop1_2Grid.setHidden(true);
							pop1Grid.setRegion('south');
							detailGrid.setRegion('center');
							pop1_2Grid.setRegion('west');
							 if(!panelSearch.getInvalidMessage()) return;   //필수체크
								panelSearch.getField('DIV_CODE').setReadOnly(true);
								panelSearch.getField('INOUT_PRSN').setReadOnly(true);
								detailStore.loadStoreRecords();
								setTimeout( function() {
										Ext.getCmp('btnWkord').setText('<div style="color: blue;font-size:24px;text-shadow: 1px 1px 1px gray;">작업지시내역</div>');
										Ext.getCmp('btnNotOut').setText('<div style="color: blue;font-size:20px;text-shadow:none;">미출고현황</div>');
										Ext.getCmp('btnOut').setText('<div style="color: blue;font-size:20px;text-shadow:none;">출고현황</div>');
										$('#btnNotOut').removeClass('x-btn-over');
										$('#btnOut').removeClass('x-btn-over');
								},100)

									if (!searchPop2Window) {
											searchPop2Window = Ext.create('widget.uniDetailWindow', {
												id: 'pop2Page',
												title: '팝업',
												width: 1270,
												height:760,
												modal: true,
												layout: 'border',
												hidden:false,
												items: [pop2Search,
														{layout: {type: 'hbox', align: 'stretch'},
															xtype	: 'container',
															region: 'center',
															tdAttrs : {align: 'right'},
															defaults: {holdable: 'hold'},
															margin      : '0 0 2 0',
															items	: [pop2Grid,
																		 {      xtype: 'splitter',
																		 		id:'split1',
																		        height: 20,
																		        width:20,
																				collapseDirection: 'right'

																		     },
																		{layout: {type: 'vbox', align: 'stretch'},
																			xtype	: 'panel',
																			region: 'east',
																			id:'balancePanel1',
																			//collapsible: true,
																			height: 500,
																			collapseDirection: 'left',
																			tdAttrs : {align: 'right'},
																			flex:1,
																			defaults: {holdable: 'hold'},
																			margin      : '0 0 2 0',
																			items	: [
																						pop2SearchBalance,panelSearch2
																		   	],
																		   	listeners	: {
																				collapse: function () {
																					$(".x-tool-tool-el.x-tool-img.x-tool-expand-right").hide();
																					pop2Grid.down('#collapsedBtn').setHidden(false);
																					pop2Grid.down('#expandBtn').setHidden(true);
																				},
																				expand: function() {
																					$(".x-tool-tool-el.x-tool-img.x-tool-expand-right").hide();
																					pop2Grid.down('#collapsedBtn').setHidden(true);
																					pop2Grid.down('#expandBtn').setHidden(false);
																				}
																			}
																		 }
														   			]
														   }






													],
												tbar: ['->',{
													itemId: 'searchBtn',
													text: '<t:message code="system.label.product.inquiry" default="조회"/>',
													minWidth: 100,
													handler: function() {
								//						if(!pop2Search.getInvalidMessage()) return;	//필수체크
														//fieldStyle	: 'text-align: center;',
														pop2Store.loadStoreRecords();
														//this.fireEvent('mouseover', this, e);
														//Ext.getCmp('pop2Page').down('#searchBtn').setBackground-image('-ms-linear-gradient(top, #e4f3ff, #d9edff 48%, #c2d8f2 52%, #c6dcf6)');
													},
													disabled: false
												},{
													itemId: 'confirmBtn',
													text: '저장',
													hidden: true,
													minWidth:100,
													handler: function() {
														if(!pop2Search.getInvalidMessage()) return;	//필수체크
								                		Ext.getCmp('pop2Page').getEl().mask('저장 중...','loading-indicator');
														pop2Store.saveStore();
													},
													disabled: false
												},{
													itemId: 'closeBtn',
													text: '<t:message code="system.label.product.close" default="닫기"/>',
													minWidth: 100,
													hidden: false,
													handler: function() {
														searchPop2Window.hide();
														//팝업닫을 때 기존 저울 연결을 끊습니다.
														//scaleIframe = $("#iFrameBalance-iframeEl").get(0).contentWindow;
														//scaleIframe.postMessage({ command: "disConnectStomp" }, '*');

													},
													disabled: false
												}],
												listeners: {
													beforehide: function(me, eOpt) {
														pop2Search.clearForm();
														pop2Grid.reset();
														pop2Store.clearData();
														firstLoadGubun = 'N';

													},
													beforeclose: function(panel, eOpts) {
													},
													beforeshow: function(panel, eOpts) {
														pop2Search.setValue('PRINT_YN',true);
														pop2Search.setValue('PRINT_Q',1);
								//						pop2Search.setValue('INOUT_PRSN',panelSearch.getValue('INOUT_PRSN'));
														pop2Search.getField('TYPE_AB').setValue('A');//수동
														pop2SearchBalance.setHidden(false);


													},
													show: function(panel, eOpts) {
														firstLoadGubun = 'Y';

														pop1Search.setValue('SCAN_CODE','');
														pop2Store.loadStoreRecords();
														Ext.getCmp('balancePanel1').expand();
														//pop2Search.getField('INOUT_Q').focus();
														pop2Search.getField('LOT_NO').focus();
														var param = pop2SearchBalance.getValues();
														$("#split1").append('<div id="split1-collapseEl" data-ref="collapseEl" role="presentation" class="x-collapse-el x-layout-split-right" style="margin-left:8px;transform:scale(2.5,2);" id="splitChildDiv"></div>');


													}
												}
											})

								}
								searchPop2Window.center();
								searchPop2Window.show();
								searchPop2Window.hide();


		//}

					scaleIframe = $("#iFrameBalance-iframeEl").get(0).contentWindow;
					if(weighing == 'N'){
							setTimeout( function() {
										scaleIframe.postMessage({
										command: 'setValue',	//명령어
										id: '키오스크0', 	//연계아이디
										lotNo: "",	//로트번호
										item: "",	//출고품목
										outStock: {qty:1, unit: 'G'},	//출고단위
										errorRange: 1,	//오차
										erpLoginID: UserInfo.userID	//erp 로그인 아이디
										}, '*');
										setTimeout( function() {
											scaleIframe.postMessage({ command: "connectStomp" }, '*')
											weighing = 'Y';
										}, 2000 );
							}, 1000 );
						}

					/*		$('#btnNotOut').attr('class','x-btn x-unselectable x-btn-default-small');
							$('#btnOut').attr('class','x-btn x-unselectable x-btn-default-small');
							Ext.getCmp('btnWkord').pressed = false;
							Ext.getCmp('btnWkord').toggle(false);*/


					},listeners: {
			            	 el: {
				            		mouseover: function(e, elem, eOpts) {
									//$('#btnWkord').attr('class','x-btn x-unselectable x-btn-default-small');
										//$('#btnWkord').removeClass('x-btn-over');
							         },
						            mouseout: function(e, elem, eOpts) {
									//$('#btnWkord').attr('class','x-btn x-unselectable x-btn-default-small');
						            	//return false;
						            	//$('#btnWkord').removeClass('x-btn-pressed');

						            }, blur: function(e, elem, eOpts){
									//$('#btnWkord').attr('class','x-btn x-unselectable x-btn-default-small');
						            //	$('#btnWkord').css('opacity') = '0.6';
						            	//$('#btnWkord').removeClass('x-btn-pressed');
							        }
				            	 },toggle: function(e, elem, eOpts){
									//alert('toggle');
										//$('#btnWkord').attr('class','x-btn x-unselectable x-btn-default-small x-btn-over');
										//Ext.getCmp('btnWkord').toggle = true
				            	 },beforetoggle: function(e, elem, eOpts){
									//alert('beforetoggle');
				            	 	/*if(elem == false){
											Ext.getCmp('btnWkord').toggle(true);
										//	$('#btnWkord').attr('class','x-btn x-unselectable x-btn-default-small x-btn-over');
											elem = true;
											return false;
										}*/
				            	 }
				    }
		  },{   xtype       : 'button',
	            text        : '<div style="color: blue">미출고현황</div>',
	            width       : 160,
	            height		: 50,
	            margin      : '0 0 2 -30',
	            itemId:'btnNotOut',
	            //enableToggle: true,
	            id	  :'btnNotOut',
	            tdAttrs     : {align: 'left'},
	            handler     : function(btn) {

							var selectedRecord = detailGrid.getSelectedRecord();
							if(Ext.isEmpty(selectedRecord)){
								alert('선택한 작업지시 내역이 없습니다.\n작업지시내역 버튼을 눌러 조회한 후 작업지시번호를 선택해주세요.');
								return false;
							}
							pop1Search.setHidden(false);
							detailGrid.setHidden(true);
							pop1Grid.setHidden(false);
							pop1_2Grid.setHidden(true);
							pop1Grid.setRegion('center');
							detailGrid.setRegion('south');
							pop1_2Grid.setRegion('west');
							pop1Store.loadStoreRecords();
							pop1Search.setValue('WKORD_NUM',selectedRecord.get('WKORD_NUM'));
							pop1Search.setValue('PRODT_WKORD_DATE',selectedRecord.get('PRODT_WKORD_DATE'));
							pop1Search.setValue('ITEM_CODE',selectedRecord.get('ITEM_CODE'));
							pop1Search.setValue('WKORD_Q',selectedRecord.get('WKORD_Q'));
							pop1Search.setValue('STOCK_UNIT',selectedRecord.get('STOCK_UNIT'));
							pop1Search.setValue('ITEM_NAME',selectedRecord.get('ITEM_NAME'));
							pop1Search.setValue('INOUT_DATE_2',UniDate.get('today'));
							setTimeout( function() {
								pop1Search.getField('SCAN_CODE').focus();
							}, 50 );
							pop1Search.setTitle('<div style="font-family: Gulim;font-weight: bold; font-size: 24px;color: blue;"> 미출고현황 </div>');
							pop1Search.down('#btnWeighingPop').setHidden(false);
							pop1Search.down('#btnLabel').setHidden(true);
							Ext.getCmp('btnWkord').pressed = false;
							Ext.getCmp('btnWkord').toggle(false);
								setTimeout( function() {
									Ext.getCmp('btnWkord').setText('<div style="color: blue;font-size:20p;text-shadow:none;">작업지시내역</div>');
									Ext.getCmp('btnNotOut').setText('<div style="color: blue;font-size:24px;text-shadow: 1px 1px 1px gray;">미출고현황</div>');
									Ext.getCmp('btnOut').setText('<div style="color: blue;font-size:20px;text-shadow:none;">출고현황</div>');
									$('#btnWkord').removeClass('x-btn-over');
									$('#btnOut').removeClass('x-btn-over');
								},100)

							/*var field = panelSearch.down('#btnWkord');
							field.fireEvent('click', field, UserInfo.divCode, null, null, "DIV_CODE");*/
						/*
							$('#btnWkord').addClass('x-unselectable');
							$('#btnWkord').addClass('x-btn-default-small');*/
							//$('#btnOut').attr('class','x-btn x-unselectable x-btn-default-small');
					},listeners: {
							toggle: function(e, elem, eOpts){
									/*var selectedRecord = detailGrid.getSelectedRecord();
									if(Ext.isEmpty(selectedRecord)){
										Ext.getCmp('btnNotOut').toggle(false);
										return false;
									}

									if(elem == false){
										Ext.getCmp('btnNotOut').toggle(true);

									}*/

			            	 },beforetoggle: function(e, elem, eOpts){
							/*	Ext.getCmp('btnWkord').pressed = false;
								Ext.getCmp('btnWkord').toggle(false);*/
								//Ext.getCmp('btnWkord').enableToggle = false;
								//var field = panelSearch.down('#btnWkord');
								//field.fireEvent('click', field, UserInfo.divCode, null, null, "DIV_CODE");
			            	 }
					}
		   },{  xtype       : 'button',
	            text        : '<div style="color: blue">출고현황</div>',
	            width       : 160,
	            height		: 50,
	            margin      : '0 0 2 -315',
	            itemId		: 'btnOut',
	            id			: 'btnOut',
	            //enableToggle: true,
	            tdAttrs     : {align: 'left'},
	            handler     : function(btn) {
							var selectedRecord = detailGrid.getSelectedRecord();
							if(Ext.isEmpty(selectedRecord)){
								alert('선택한 작업지시 내역이 없습니다.\n작업지시내역 버튼을 눌러 조회한 후 작업지시번호를 선택해주세요.');
								return false;
							}
							pop1Search.setHidden(false);
							detailGrid.setHidden(true);
							pop1Grid.setHidden(true);
							pop1_2Grid.setHidden(false);
							pop1Grid.setRegion('south');
							detailGrid.setRegion('west');
							pop1_2Grid.setRegion('center');
							pop1_2Store.loadStoreRecords();
							pop1Search.setTitle('<div style="font-family: Gulim;font-weight: bold; font-size: 24px;color: blue;"> 출고현황 </div>');

							pop1Search.down('#btnLabel').setHidden(false);
							pop1Search.down('#btnWeighingPop').setHidden(true);
							//pop1Search.down('#btnLabel').show();
							pop1Search.setValue('WKORD_NUM',selectedRecord.get('WKORD_NUM'));
							pop1Search.setValue('PRODT_WKORD_DATE',selectedRecord.get('PRODT_WKORD_DATE'));
							pop1Search.setValue('ITEM_CODE',selectedRecord.get('ITEM_CODE'));
							pop1Search.setValue('WKORD_Q',selectedRecord.get('WKORD_Q'));
							pop1Search.setValue('STOCK_UNIT',selectedRecord.get('STOCK_UNIT'));
							pop1Search.setValue('ITEM_NAME',selectedRecord.get('ITEM_NAME'));
							pop1Search.setValue('INOUT_DATE_2',UniDate.get('today'));
//							$('#btnWkord').attr('class','x-btn x-unselectable x-btn-default-small');
//							$('#btnNotOut').attr('class','x-btn x-unselectable x-btn-default-small');

							gbBtnWkordPressed = false;
							gbBtnNotOutPressed = false;
							gbBtnOutPressed = true;
							setTimeout( function() {
								Ext.getCmp('btnWkord').setText('<div style="color: blue;font-size:20px;text-shadow: none;">작업지시내역</div>');
								Ext.getCmp('btnNotOut').setText('<div style="color: blue;font-size:20px;text-shadow: none;">미출고현황</div>');
								Ext.getCmp('btnOut').setText('<div style="color: blue;font-size:24px;text-shadow: 1px 1px 1px gray;">출고현황</div>');
								$('#btnWkord').removeClass('x-btn-over');
								$('#btnNotOut').removeClass('x-btn-over');
							},100)


					},listeners: {
//				            	 el: {
//				            		mouseover: function(e, elem, eOpts) {
//										$('#btnOut').addClass('x-btn-over');
//
//									//$('#btnWkord').attr('class','x-btn x-unselectable x-btn-default-small ');
//										//Ext.getCmp('btnWkord').setDisabled(false);
//							        },
//						            mouseout: function(e, elem, eOpts) {
//										$('#btnOut').removeClass('x-btn-over');
//
//										if(gbBtnOutPressed) {
//											$('#toolbar-1802-innerCt').removeClass('x-btn-pressed');
//											$('#btnNotOut').removeClass('x-btn-pressed');
//											$('#btnOut').addClass('x-btn-pressed');
//										}
//										else {
//											$('#btnWkord').removeClass('x-btn-pressed');
//											$('#btnNotOut').removeClass('x-btn-pressed');
//											$('#btnOut').removeClass('x-btn-pressed');
//
//											if(gbBtnNotOutPressed) {
//												$('#btnNotOut').addClass('x-btn-pressed');
//											}
//											if(gbBtnWkordPressed) {
//												$('#btnWkord').addClass('x-btn-pressed');
//											}
//										};
//
//						            	//return false;
//
//						            }, blur: function(e, elem, eOpts){
//									//$('#btnWkord').attr('class','x-btn x-unselectable x-btn-default-small');
//						            //	$('#btnWkord').css('opacity') = '0.6';
//							        }
//				            	 },

				            		mouseover: function(e, elem, eOpts) {
								//		$('#btnOut').addClass('x-btn-over');

									//$('#btnWkord').attr('class','x-btn x-unselectable x-btn-default-small ');
										//Ext.getCmp('btnWkord').setDisabled(false);
							        },
						            mouseout: function(e, elem, eOpts) {
									/*	$('#btnOut').removeClass('x-btn-over');

										if(gbBtnOutPressed) {
											$('#btnWkord').removeClass('x-btn-pressed');
											$('#btnNotOut').removeClass('x-btn-pressed');
											$('#btnOut').addClass('x-btn-pressed');
										}
										else {
											$('#btnWkord').removeClass('x-btn-pressed');
											$('#btnNotOut').removeClass('x-btn-pressed');
											$('#btnOut').removeClass('x-btn-pressed');

											if(gbBtnNotOutPressed) {
												$('#btnNotOut').addClass('x-btn-pressed');
											}
											if(gbBtnWkordPressed) {
												$('#btnWkord').addClass('x-btn-pressed');
											}
										};*/

						            	//return false;

						            },
							toggle: function(e, elem, eOpts){
//									var selectedRecord = detailGrid.getSelectedRecord();
//									if(Ext.isEmpty(selectedRecord)){
//										Ext.getCmp('btnOut').toggle(false);
//										return false;
//									}
//									if(elem == false){
//										Ext.getCmp('btnOut').toggle(true);
//										return false;
//									}

			            	 },beforetoggle: function(e, elem, eOpts){

			            	 }
					}
		   },{layout	: {type:'uniTable', column:2},
				xtype	: 'container',
				tdAttrs : {align: 'right'},
				defaults: {holdable: 'hold'},
			//	margin      : '0 0 2 120',
				items	: [	{  xtype        : 'button',
					            text        : '<div style="color: blue">신규</div>',
					            width       : 140,
					            height		: 50,
					            margin      : '0 0 2 -5',
					            itemId		:'btnReset',

					            handler     : function(btn) {
											panelSearch.clearForm();
											detailGrid.reset();
											detailStore.clearData();
											pop1Search.setHidden(true);
											detailGrid.setHidden(false);
											pop1Grid.setHidden(true);
											pop1_2Grid.setHidden(true);
											pop1Grid.setRegion('south');
											detailGrid.setRegion('center');
											pop1_2Grid.setRegion('west');
											UniAppManager.app.fnInitInputFields();


									}
						   },{  xtype       : 'button',
					            text        : '<div style="color: blue">닫기</div>',
					            width       : 140,
					            height		: 50,
					            margin      : '0 0 2 -260',
					            itemId		:'btnClose',
					           // tdAttrs     : {align: 'right'},
					            handler     : function(btn) {
											if(weighing == 'Y'){
												scaleIframe.postMessage({ command: "disConnectStomp" }, '*');
											}
											self.close();
								}
						   }
			   			]
			   }
		]
	});

	var pop1Search = Unilite.createSearchForm('pop1SearchForm', {
		layout: {
			type: 'uniTable',
			columns: 4
		},
	//	font-family: '굴림',Gulim, tahoma, arial, verdana, sans-serif;
		region:'north',
		padding: '1 1 1 1',
		border: true,
		title: '<div style="font-family: Malgun Gothic;font-weight: bold; font-size: 22px;color: blue;"> 미출고현황 </div>',
//		trackResetOnLoad: true,
		defaults: {readOnly:true, labelWidth:115,width:280},
		items: [{
			fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			name:'WKORD_NUM',
			labelWidth: 120,
/*			labelWidth: 150,
			width: 320,*/
			xtype:'uniTextfield'
		},{
	        fieldLabel: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
	        name: 'PRODT_WKORD_DATE',
	        xtype: 'uniDatefield'
		},{
			fieldLabel:'<t:message code="system.label.product.scancode" default="스캔코드"/>',
			name:'SCAN_CODE',
			xtype:'uniTextfield',
			readOnly:false,
			colspan: 2,
			listeners: {
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						var newValue = pop1Search.getValue('SCAN_CODE');
						if(!Ext.isEmpty(newValue)) {
							var records = pop1Store.data.items;
							var cnt = 0;

							var scanCodeSplit = pop1Search.getValue('SCAN_CODE').split('$');

							Ext.each(records,function(record, index){
								if(record.get('ITEM_CODE') == scanCodeSplit[0]){
									cnt = cnt + 1;
									pop1Grid.getSelectionModel().select(index);
									pop2Search.setValue('ITEM_CODE',record.get('ITEM_CODE'));
									pop2Search.setValue('ITEM_NAME',record.get('ITEM_NAME'));
									pop2Search.setValue('SPEC',record.get('SPEC'));
									pop2Search.setValue('OUTSTOCK_REQ_Q',record.get('OUTSTOCK_REQ_Q'));
									pop2Search.setValue('WH_CODE',record.get('WH_CODE'));

									pop2Search.setValue('PMP200T_WH_CODE',record.get('PMP200T_WH_CODE'));

									pop2Search.setValue('WORK_SHOP_CODE',record.get('WORK_SHOP_CODE'));
									pop2Search.setValue('OUTSTOCK_NUM',record.get('OUTSTOCK_NUM'));
									pop2Search.setValue('REF_WKORD_NUM',pop1Search.getValue('WKORD_NUM'));
									pop2Search.setValue('PATH_CODE',record.get('PATH_CODE'));

									pop2Search.setValue('OUTSTOCK_JAN_Q',record.get('OUTSTOCK_JAN_Q'));
									pop2Search.setValue('INOUT_Q',record.get('OUTSTOCK_JAN_Q'));
									pop2Search.setValue('INOUT_Q_TOT',record.get('OUTSTOCK_JAN_Q'));
								}
							});
							$('.x-btn-inner-default-toolbar-small').addClass("x-btn-inner");
							$('#pop2Page').css("height",gsFrameHeight);
							if(cnt > 0){
								//openSearchPop2Window();\
								searchPop2Window.center();
								searchPop2Window.show();
								gsScanLotCode = scanCodeSplit[1];
								pop2Search.getField('LOT_NO').focus();
							}else{
								beep();
								Unilite.messageBox('<t:message code="system.message.inventory.message013" default="해당자료가 없습니다."/>');
								panelSearch.setValue('SCAN_CODE', '');

							}

//							detailStore.loadStoreRecords();
//							setTimeout( function() {
//								var record = detailGrid.getSelectedRecord();
//								if(Ext.isEmpty(record)) {
//									beep();
//									Ext.Msg.alert('확인','<t:message code="system.message.inventory.message013" default="해당자료가 없습니다."/>');
//									panelSearch.setValue('WKORD_NUM', '');
////									return false;
//								}else{
//									openSearchPop1Window();
//								}
//			   				}, 500 );
						}
					}
				}
			}
		},{
			fieldLabel:'<t:message code="system.label.product.makeitem" default="제조품목"/>',
			name:'ITEM_CODE',
			xtype:'uniTextfield'
		},{
			fieldLabel: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
			xtype: 'uniNumberfield',
			name: 'WKORD_Q'
		},{
			fieldLabel:'<t:message code="system.label.product.unit" default="단위"/>',
			name:'STOCK_UNIT',
			xtype:'uniTextfield',
			colspan: 2
//			xtype:'uniCombobox',
//			comboType: 'AU',
//			comboCode:'B013'
		},{
			fieldLabel:'<t:message code="system.label.product.itemname2" default="품명"/>',
			name:'ITEM_NAME',
			xtype:'uniTextfield',
			width:560
		},{
	        fieldLabel: '출고일자',
	        name: 'INOUT_DATE_2',
	        xtype: 'uniDatefield',
			value: UniDate.get('today'),
			readOnly:false
		},{
			fieldLabel: '<t:message code="system.label.product.printq" default="인쇄수량"/>',
			xtype: 'uniNumberfield',
			name: 'PRINT_Q',
			value: 1,
			width: 220,
			readOnly:false

		},{     xtype       : 'button',
	            text        : '<div style="color: blue">칭량출고 팝업</div>',
	            width       : 150,
	            height		: 50,
	            margin      : '0 0 2 20',
	            itemId		:'btnWeighingPop',
	            tdAttrs     : {align: 'right'},
	            handler     : function(btn) {
								var record = pop1Grid.getSelectedRecord();
								panelSearch.setValue('SCAN_CODE', '');
								$('.x-btn-inner-default-toolbar-small').addClass("x-btn-inner");
								pop2Search.setValue('ITEM_CODE',record.get('ITEM_CODE'));
								pop2Search.setValue('ITEM_NAME',record.get('ITEM_NAME'));
								pop2Search.setValue('SPEC',record.get('SPEC'));
								pop2Search.setValue('OUTSTOCK_REQ_Q',record.get('OUTSTOCK_REQ_Q'));
								pop2Search.setValue('WH_CODE',record.get('WH_CODE'));

								pop2Search.setValue('PMP200T_WH_CODE',record.get('PMP200T_WH_CODE'));

								pop2Search.setValue('WORK_SHOP_CODE',record.get('WORK_SHOP_CODE'));
								pop2Search.setValue('OUTSTOCK_NUM',record.get('OUTSTOCK_NUM'));
								pop2Search.setValue('REF_WKORD_NUM',record.get('REF_WKORD_NUM'));
								pop2Search.setValue('PATH_CODE',record.get('PATH_CODE'));

								pop2Search.setValue('PROD_ITEM_NAME',pop1Search.getValue('ITEM_NAME'));
								pop2Search.setValue('WKORD_NUM',pop1Search.getValue('WKORD_NUM'));
								pop2Search.setValue('STOCK_UNIT',pop1Search.getValue('STOCK_UNIT'));



								pop2Search.setValue('OUTSTOCK_JAN_Q',record.get('OUTSTOCK_JAN_Q'));
								pop2Search.setValue('INOUT_Q',record.get('OUTSTOCK_JAN_Q'));
								pop2Search.setValue('INOUT_Q_TOT',record.get('OUTSTOCK_JAN_Q'));
								pop2SearchBalance.setHidden(false);
								//openSearchPop2Window();

								//searchPop2Window.center();
								searchPop2Window.show();
								$('#pop2Page').css("height",gsFrameHeight);

				}
		   },{  xtype       : 'button',
	            text        : '<div style="color: blue">라벨 출력</div>',
	            width       : 150,
	            height		: 50,
	            margin      : '0 0 2 20',
	            hidden		: true,
	            itemId		:'btnLabel',
	            tdAttrs     : {align: 'right'},
	            handler     : function(btn) {
						var selectedRecords = pop1_2Grid.getSelectedRecords();
						var printDatas = '';
						var param = panelSearch.getValues();
						var sItemCode = '';
						var sWkordNum = '';
						var sLotNo = '';
						var sInoutQ = '';
						var sInoutPrsn = '';
						var sStockUnit = '';
						var sPrintQ = '';
						var sOutStockReqQ = '';
						var sJanOutStockReqQ = '';
						var whCode = '';
						var inOutDate2 = '';

						Ext.each(selectedRecords, function(selectedRecord, index){
							sItemCode 		 = selectedRecord.data.ITEM_CODE;
							sWkordNum 		 = pop1Search.getValue('WKORD_NUM');
							sLotNo 			 = selectedRecord.data.LOT_NO;
							sInoutQ 		 = selectedRecord.data.INOUT_Q;
							sInoutPrsn  	 = panelSearch.getValue('INOUT_PRSN');
							sStockUnit  	 = selectedRecord.data.STOCK_UNIT;
							sPrintQ 		 = pop1Search.getValue('PRINT_Q');
							sOutStockReqQ    = selectedRecord.data.OUTSTOCK_REQ_Q;
							sJanOutStockReqQ = selectedRecord.data.OUTSTOCK_REQ_Q - selectedRecord.data.INOUT_Q;
							whCode 			 = pop2Search.getValue('WH_CODE');
							inOutDate2 		 = UniDate.getDbDateStr(selectedRecord.data.INOUT_DATE_2);

							if(index ==0) {
								printDatas		= printDatas + sItemCode + '^' + sWkordNum + '^' + sLotNo + '^' + sInoutQ  + '^'	+ sInoutPrsn + '^' + sStockUnit + '^' + sPrintQ + '^' + sOutStockReqQ + '^'+ sJanOutStockReqQ	+ '^' + whCode + '^' + inOutDate2

							}else{
								printDatas		= printDatas + ',' + sItemCode + '^' + sWkordNum + '^' + sLotNo + '^' + sInoutQ  + '^'	+ sInoutPrsn + '^' + sStockUnit + '^' + sPrintQ + '^' + sOutStockReqQ + '^'+ sJanOutStockReqQ	+ '^' + whCode + '^' + inOutDate2
							}
						})
					/*	var param = {
							//PROD_ITEM_NAME,ITEM_NAME 특문 관련 해서 쿼리에서 추출
							//'PROD_ITEM_NAME':pop2Search.getValue('PROD_ITEM_NAME'),	//제품명
							//'ITEM_NAME' :pop2Search.getValue('ITEM_NAME'), 	//원료명
							'ITEM_CODE' :selectedRecord.data.ITEM_CODE, 	//원료코드
							'WKORD_NUM' :pop1Search.getValue('WKORD_NUM'), 	//작지NO
							'LOT_NO' :selectedRecord.data.LOT_NO, //시험의뢰번호
							//'' :pop2Search.getValue(''), TIME 현재시간
							'INOUT_Q' :selectedRecord.data.INOUT_Q, 	//출고량  W / T
							'INOUT_PRSN' :panelSearch.getValue('INOUT_PRSN'),	//칭량자

							'STOCK_UNIT' :selectedRecord.data.STOCK_UNIT,	//단위

							'PRINT_Q' : pop1Search.getValue('PRINT_Q'), //인쇄수량

							'OUTSTOCK_REQ_Q' : selectedRecord.data.OUTSTOCK_REQ_Q,
							'JAN_Q' : selectedRecord.data.OUTSTOCK_REQ_Q - selectedRecord.data.INOUT_Q,

							'WH_CODE' : pop2Search.getValue('WH_CODE'),

							'INOUT_DATE_2' : UniDate.getDbDateStr(selectedRecord.data.INOUT_DATE_2)
						}*/

						param["PRINT_DATAS"] = printDatas;
						param["dataCount"] 	 = selectedRecords.length;
						param["USER_LANG"]   = UserInfo.userLang;
						param["PGM_ID"]= PGM_ID;
						param["MAIN_CODE"] = 'P010';//생산용 공통 코드
						param["DIV_CODE"] = panelSearch.getValue('DIV_CODE');
						param["SEL_PRINT"] = Ext.getCmp('selectPrinterchk').getChecked()[0].inputValue;
						param["WKORD_NUM"] = pop1Search.getValue('WKORD_NUM');

						var win = null;
						win = Ext.create('widget.ClipReport', {
							url: CPATH+'/prodt/pmp281clukrv.do',
							prgID: 'pmp281ukrv',
							extParam: param
						});
			//			win.center();	팝업에서 호출시 위치 못찾는현상 때문에 제거
						win.show();

				}
		   }]
	});


	Unilite.defineModel('pop1Model', {
		fields: [
			{ name: 'SEQ'		,text:'<t:message code="system.label.product.seq" default="순번"/>'	,type: 'int'},
			{ name: 'ITEM_CODE'		,text:'<t:message code="system.label.product.itemnum" default="품번"/>'	,type: 'string'},
			{ name: 'ITEM_NAME'		,text:'<t:message code="system.label.product.itemname2" default="품명"/>'	,type: 'string'},
			{ name: 'SPEC'		,text:'<t:message code="system.label.product.spec" default="규격"/>'	,type: 'string'},
			{ name: 'STOCK_UNIT'		,text:'<t:message code="system.label.product.unit" default="단위"/>'	,type: 'string'},
			{ name: 'OUTSTOCK_REQ_Q'		,text:'<t:message code="system.label.product.realrequiredqty" default="실소요량"/>'	,type : 'float', decimalPrecision: 3, format:'0,000.000'},
			{ name: 'STOCK_Q'		,text:'<t:message code="system.label.product.onhandstock" default="현재고"/>'	,type : 'float', decimalPrecision: 3, format:'0,000.000'},
			{ name: 'LOCATION'		,text:'<t:message code="system.label.product.stockplace" default="재고위치"/>'	,type: 'string'},
			{ name: 'WH_CODE'		,text:'WH_CODE'	,type: 'string'},

			{ name: 'PMP200T_WH_CODE'		,text:'PMP200T_WH_CODE'	,type: 'string'},

			{ name: 'WORK_SHOP_CODE'		,text:'WORK_SHOP_CODE'	,type: 'string'},
			{ name: 'OUTSTOCK_NUM'		,text:'OUTSTOCK_NUM'	,type: 'string'},
			{ name: 'REF_WKORD_NUM'		,text:'REF_WKORD_NUM'	,type: 'string'},
			{ name: 'PATH_CODE'   		,text:'PATH_CODE'	,type: 'string'},
			{ name: 'OUTSTOCK_JAN_Q'		,text:'출고후 잔량'	,type : 'float', decimalPrecision: 3, format:'0,000.000'}

		]
	});

	var pop1Store = Unilite.createStore('pop1Store', {
		model: 'pop1Model',
		autoLoad: false,
		uniOpt: {
			isMaster: false,	// 상위 버튼 연결
			editable: false,	// 수정 모드 사용
			deletable: false,	// 삭제 가능 여부
			useNavi: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'pmp281ukrvService.pop1SelectList'
			}
		},
		loadStoreRecords: function() {
			var param = panelSearch.getValues();
			if(Ext.isEmpty(gsOutGubun)){
				param.OUT_GUBUN = '2';
			}else{
				param.OUT_GUBUN = gsOutGubun;
			}
			if(Ext.isEmpty(panelSearch.getValue('WKORD_NUM'))){
				var selectMainRecord = detailGrid.getSelectedRecord();
				param.WKORD_NUM = selectMainRecord.get('WKORD_NUM');
			}
			this.load({
				params: param
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
				setTimeout( function() {
					pop1Search.getField('SCAN_CODE').focus();
				},1000)
			}
		}
	});

	var pop1Grid = Unilite.createGrid('pop1Grid', {
		store: pop1Store,
		layout: 'fit',
		region: 'south',
		uniOpt: {
			expandLastColumn: false,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			onLoadSelectFirst: true,
			useRowNumberer: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			},
			useLoadFocus:false
		},
		selModel: 'rowmodel',
		columns: [
			{ dataIndex: 'SEQ'	, width: 80,align:'center'},
			{ dataIndex: 'ITEM_CODE'	, width: 120},
			{ dataIndex: 'ITEM_NAME'	, width: 250},
			{ dataIndex: 'SPEC'	, width: 100},
			{ dataIndex: 'STOCK_UNIT'	, width: 70,align:'center'},
			{ dataIndex: 'OUTSTOCK_REQ_Q'	, width: 120},
			{ dataIndex: 'OUTSTOCK_JAN_Q'	, width: 150},
			{ dataIndex: 'STOCK_Q'	, width: 120},
			{ dataIndex: 'LOCATION'	, width: 120}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				panelSearch.setValue('SCAN_CODE', '');

				pop2Search.setValue('ITEM_CODE',record.get('ITEM_CODE'));
				pop2Search.setValue('ITEM_NAME',record.get('ITEM_NAME'));
				pop2Search.setValue('SPEC',record.get('SPEC'));
				pop2Search.setValue('OUTSTOCK_REQ_Q',record.get('OUTSTOCK_REQ_Q'));
				pop2Search.setValue('WH_CODE',record.get('WH_CODE'));

				pop2Search.setValue('PMP200T_WH_CODE',record.get('PMP200T_WH_CODE'));

				pop2Search.setValue('WORK_SHOP_CODE',record.get('WORK_SHOP_CODE'));
				pop2Search.setValue('OUTSTOCK_NUM',record.get('OUTSTOCK_NUM'));
				pop2Search.setValue('REF_WKORD_NUM',record.get('REF_WKORD_NUM'));
				pop2Search.setValue('PATH_CODE',record.get('PATH_CODE'));

				pop2Search.setValue('PROD_ITEM_NAME',pop1Search.getValue('ITEM_NAME'));
				pop2Search.setValue('WKORD_NUM',pop1Search.getValue('WKORD_NUM'));
				pop2Search.setValue('STOCK_UNIT',pop1Search.getValue('STOCK_UNIT'));



				pop2Search.setValue('OUTSTOCK_JAN_Q',record.get('OUTSTOCK_JAN_Q'));
				pop2Search.setValue('INOUT_Q',record.get('OUTSTOCK_JAN_Q'));
				pop2Search.setValue('INOUT_Q_TOT',record.get('OUTSTOCK_JAN_Q'));
				pop2SearchBalance.setHidden(false);
				//openSearchPop2Window();
				searchPop2Window.center();
				searchPop2Window.show();
				pop2Search.getField('LOT_NO').focus();
				$('#pop2Page').css("height",gsFrameHeight);
			}
		}
	});

	Unilite.defineModel('pop1_2Model', {
		fields: [
			{ name: 'SEQ'		,text:'<t:message code="system.label.product.seq" default="순번"/>'	,type: 'int'},
			{ name: 'ITEM_CODE'		,text:'<t:message code="system.label.product.itemnum" default="품번"/>'	,type: 'string'},
			{ name: 'ITEM_NAME'		,text:'<t:message code="system.label.product.itemname2" default="품명"/>'	,type: 'string'},
			{ name: 'SPEC'		,text:'<t:message code="system.label.product.spec" default="규격"/>'	,type: 'string'},
			{ name: 'STOCK_UNIT'		,text:'<t:message code="system.label.product.unit" default="단위"/>'	,type: 'string'},
			{ name: 'OUTSTOCK_REQ_Q'		,text:'<t:message code="system.label.product.realrequiredqty" default="실소요량"/>'	,type : 'float', decimalPrecision: 3, format:'0,000.000'},
			{ name: 'INOUT_Q'		,text:'출고량'	,type : 'float', decimalPrecision: 3, format:'0,000.000'},
			{ name: 'LOCATION'		,text:'<t:message code="system.label.product.stockplace" default="재고위치"/>'	,type: 'string'},
			{ name: 'INOUT_NUM'		,text:'INOUT_NUM'	,type: 'string'},
			{ name: 'INOUT_SEQ'		,text:'INOUT_SEQ'	,type: 'string'},
			{ name: 'OUTSTOCK_NUM'		,text:'OUTSTOCK_NUM'	,type: 'string'},
			{ name: 'REF_WKORD_NUM'		,text:'REF_WKORD_NUM'	,type: 'string'},
			{ name: 'PATH_CODE'   		,text:'PATH_CODE'	,type: 'string'},
			{ name: 'LOT_NO'   		,text:'LOT NO'	,type: 'string'},
			{ name: 'INOUT_DATE_2'   		,text:'INOUT_DATE_2'	,type: 'string'},
			{ name: 'WH_CODE'   		,text:'출고창고'	,type: 'string'}
		]
	});

	var pop1_2Store = Unilite.createStore('pop1_2Store', {
		model: 'pop1_2Model',
		autoLoad: false,
		uniOpt: {
			isMaster: false,	// 상위 버튼 연결
			editable: false,	// 수정 모드 사용
			deletable: false,	// 삭제 가능 여부
			useNavi: false		// prev | newxt 버튼 사용
		},
		proxy: pop1_2Proxy,
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						pop1Store.loadStoreRecords();
						pop1_2Store.loadStoreRecords();

                    	//Ext.getCmp('pop1Page').getEl().unmask();

					},
					failure: function(form, action){
                    	Ext.getCmp('pop1Page').getEl().unmask();
						pop1_2Store.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);

			} else {
				pop1_2Grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords: function() {
			var param = panelSearch.getValues();
			if(Ext.isEmpty(panelSearch.getValue('WKORD_NUM'))){
				var selectMainRecord = detailGrid.getSelectedRecord();
				param.WKORD_NUM = selectMainRecord.get('WKORD_NUM');
			}
			this.load({
				params: param
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
			}
		}
	});

	var pop1_2Grid = Unilite.createGrid('pop1_2Grid', {
		store: pop1_2Store,
		layout: 'fit',
		uniOpt: {
			expandLastColumn: false,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			onLoadSelectFirst:false,
			useRowNumberer: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			},
			useLoadFocus:false
		},
		tbar:  ['->',{
			itemId : 'deleteBtn',
			text: '삭제',
			handler: function() {
				var selectedRecord = pop1_2Grid.getSelectedRecord();

				if(Ext.isEmpty(selectedRecord)){
					Unilite.messageBox('선택된 데이터가 없습니다.');
					return false;
				}

				var selRow = pop1_2Grid.getSelectedRecord();
				if(confirm('선택된 행을 삭제 합니다. 삭제 하시겠습니까?')) {

                	//Ext.getCmp('pop1Page').getEl().mask('저장 중...','loading-indicator');

					pop1_2Grid.deleteSelectedRow();
					pop1_2Store.saveStore();
				}
			}
		}],
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false }),
		columns: [
			{ dataIndex: 'SEQ'	, width: 80,align:'center'},
			{ dataIndex: 'ITEM_CODE'	, width: 120},
			{ dataIndex: 'ITEM_NAME'	, width: 250},
			{ dataIndex: 'SPEC'	, width: 100},
			{ dataIndex: 'STOCK_UNIT'	, width: 70,align:'center'},
			{ dataIndex: 'OUTSTOCK_REQ_Q'	, width: 120},
			{ dataIndex: 'INOUT_Q'	, width: 120},
			{ dataIndex: 'LOCATION'	, width: 120},
			{ dataIndex: 'LOT_NO'	, width: 120},
			{ dataIndex: 'INOUT_DATE_2'	, width: 120, hidden: true},
			{ dataIndex: 'WH_CODE'	, width: 120}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {

					pop1_2Grid.deleteSelectedRow();
					pop1_2Store.saveStore();
				}
			}
		}
	});

	/* var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab: 0,
	    region: 'center',
	    items: [{
	    	title: '미출고현황',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[pop1Grid],
	    	id: 'tab1'
	    },{
	    	title: '출고현황',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[pop1_2Grid],
	    	id: 'tab2'
	    }],
		listeners : {
			beforetabchange : function ( tabPanel, newCard, oldCard, eOpts )  {
//				if(!panelResult.getInvalidMessage()) return false;   // 필수체크
			},
			tabChange : function ( tabPanel, newCard, oldCard, eOpts )  {
				var newTabId = newCard.getId();

				if(newTabId == 'tab2'){
					pop1Search.getField('SCAN_CODE').setReadOnly(true);
				}else{
					pop1Search.getField('SCAN_CODE').setReadOnly(false);
				}
			}
	    }
	});*/


	function openSearchPop1Window() {
		if (!searchPop1Window) {
			searchPop1Window = Ext.create('widget.uniDetailWindow', {
				id: 'pop1Page',
				title: '팝업',
				width: 1000,
				height: 580,
				layout: {
					type: 'vbox',
					align: 'stretch'
				},
				items: [pop1Search, tab],
				tbar: ['->',{
					itemId: 'searchBtn',
					text: '<t:message code="system.label.product.inquiry" default="조회"/>',
					minWidth: 100,
					handler: function() {
						if(!pop1Search.getInvalidMessage()) return;	//필수체크
						pop1Store.loadStoreRecords();
						pop1_2Store.loadStoreRecords();
					},
					disabled: false
				},{
					itemId: 'closeBtn',
					text: '<t:message code="system.label.product.close" default="닫기"/>',
					minWidth: 100,
					handler: function() {
						searchPop1Window.hide();

					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						pop1Search.clearForm();
						pop1Grid.reset();
						pop1Store.clearData();
						pop1_2Grid.reset();
						pop1_2Store.clearData();
						panelSearch.setValue('WKORD_NUM', '');
					},
					beforeclose: function(panel, eOpts) {
					},
					beforeshow: function(panel, eOpts) {
						var selectedRecord = detailGrid.getSelectedRecord();

						pop1Search.setValue('WKORD_NUM',selectedRecord.get('WKORD_NUM'));
						pop1Search.setValue('PRODT_WKORD_DATE',selectedRecord.get('PRODT_WKORD_DATE'));
						pop1Search.setValue('ITEM_CODE',selectedRecord.get('ITEM_CODE'));
						pop1Search.setValue('WKORD_Q',selectedRecord.get('WKORD_Q'));
						pop1Search.setValue('STOCK_UNIT',selectedRecord.get('STOCK_UNIT'));
						pop1Search.setValue('ITEM_NAME',selectedRecord.get('ITEM_NAME'));

						pop1Search.setValue('INOUT_DATE_2',UniDate.get('today'));
					},
					show: function(panel, eOpts) {
						pop1Store.loadStoreRecords();
						pop1_2Store.loadStoreRecords();

						setTimeout( function() {
							pop1Search.getField('SCAN_CODE').focus();
						}, 50 );
					}
				}
			})
		}
		searchPop1Window.center();
		searchPop1Window.show();
	}

	var pop2Search = Unilite.createSearchForm('pop2SearchForm', {
/*		layout: {
			type: 'uniTable',
			columns: 4
		},*/
		layout	: {type : 'uniTable', columns : 5, tableAttrs: {width: '99.5%'}},
		region:'north',
		//width: 1270,
		defaults: {readOnly:true},
		padding: '1 1 1 1',
		border: true,
//		trackResetOnLoad: true,
		items: [{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 4},
			defaultType: 'uniTextfield',
			defaults : {readOnly:true},
			colspan:5,
			items:[{
				fieldLabel:'<t:message code="system.label.product.issueitemnum" default="출고품번"/>',
				name:'ITEM_CODE',
				xtype:'uniTextfield'
			},{
				name:'ITEM_NAME',
				xtype:'uniTextfield',
				width:250
			},{
				name:'SPEC',
				xtype:'uniTextfield',
				width:100
			},{
				name:'WH_CODE',
				xtype:'uniTextfield',
				hidden:true
			},{
				xtype: 'radiogroup',
				fieldLabel: '칭량방법',
				labelWidth: 110,
				readOnly: true,
				items: [{
					boxLabel: '수동' , width: 80, name: 'TYPE_AB', inputValue: 'A', checked: true, readOnly: true
				}, {
					boxLabel: '자동' , width: 80, name: 'TYPE_AB', inputValue: 'B' , readOnly: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.TYPE_AB == 'A'){
							pop2Search.setValue('INOUT_Q', pop2Search.getValue('JAN_OUTSTOCK_REQ_Q'));
							pop2Search.setValue('INOUT_Q_TOT', pop2Search.getValue('JAN_OUTSTOCK_REQ_Q'));
							var selectedRecord = pop2Grid.getSelectedRecord();
							if(!Ext.isEmpty(selectedRecord)){

								selectedRecord.set('INOUT_Q',pop2Search.getValue('JAN_OUTSTOCK_REQ_Q'));
								selectedRecord.set('INOUT_Q_TOT',pop2Search.getValue('JAN_OUTSTOCK_REQ_Q'));
							}
						}else{
							//로직 보류
						}
					}
				}
			}]
		},{
			fieldLabel: 'LOT NO',
			xtype: 'uniTextfield',
			name: 'LOT_NO',
			id  : 'scanLotNo',
	/*		labelWidth: 110,
			width: 240,*/
			readOnly:false,
			allowBlank:true,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
			/*		if(pop2Search.getValue('LOT_KEYIN_YN') == true){
						var selectedRecord = pop2Grid.getSelectedRecord();
						selectedRecord.set('LOT_NO',newValue);
					}*/
				},specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						var scanCodeSplit = pop2Search.getValue('LOT_NO').split('$');//바코드 데이터가 품목코드와 lotno로 구성됨
						//var newValue = pop2Search.getValue('LOT_NO');
						var newValueLot = scanCodeSplit[1];
						var j = 0;
						Ext.each( pop2Store.data.items, function(record, i){
								if(record.get('LOT_NO') == newValueLot){
									j = j + 1;
								}
						});

						if(pop2Search.getValue('PACKING_YN') == true){
							if(Ext.isEmpty(pop2Search.getValue('DIVIDE_QTY'))){
								alert('지시분할 수량을 입력해주세요.');
								pop2Search.getField('DIVIDE_QTY').focus();
								return false;
							}
							if(j == 0){//현재 lot정보가 없는 경우, 지시분할 선택 후 최초의 상태
									pop2Store.loadStoreRecords('Y');
							}else{ // 이미 조회된 lot정보가 있으면 그 다음부터는 행추가로 진행
								var selRecord = pop2Grid.getSelectedRecord();

								var r = {
													DIV_CODE: panelSearch.getValue('DIV_CODE'),
													ITEM_CODE: pop2Search.getValue('ITEM_CODE'),
													WH_CODE: pop2Search.getValue('WH_CODE'),
													PMP200T_WH_CODE : pop2Search.getValue('PMP200T_WH_CODE'),
													INOUT_Q			: pop2Search.getValue('DIVIDE_QTY'),
													INOUT_DATE_2 : UniDate.getDbDateStr(UniDate.get('today')),
													LOT_NO: scanCodeSplit[1],
													WORK_SHOP_CODE: pop2Search.getValue('WORK_SHOP_CODE'),
													OUTSTOCK_NUM: pop2Search.getValue('OUTSTOCK_NUM'),
													REF_WKORD_NUM: pop2Search.getValue('REF_WKORD_NUM'),
													PATH_CODE: pop2Search.getValue('PATH_CODE'),
													INOUT_DATE_1: selRecord.get('INOUT_DATE_1'),
													STOCK_Q: selRecord.get('STOCK_Q'),
													JAN_Q: selRecord.get('STOCK_Q') ,
													LOCATION: selRecord.get('LOCATION'),
													STOCK_UNIT: selRecord.get('STOCK_UNIT')
												}
											pop2Grid.createRow(r);
									   /*  	data = new Object();
									     	data.records = [];
									    	Ext.each(pop2Store.data.items, function(record, i){
										      if(newValue == record.get('LOT_NO') || pop2Grid.getSelectionModel().isSelected(record) == true) {
										       data.records.push(record);
										      }
									     	});
								pop2Grid.getSelectionModel().select(data.records);*/
								pop2Search.setValue('LOT_NO','');
								pop2Search.getField('LOT_NO').focus();
								pop2Search.setValue('INOUT_Q_TOT',pop2Store.sum('INOUT_Q'));
								var selRecord2 = pop2Grid.getSelectedRecord();
								selRecord2.set('JAN_Q', selRecord.get('STOCK_Q') - pop2Store.sum('INOUT_Q'));

							}
					}else{
											if(!Ext.isEmpty(newValueLot)) {
											var chkErr = false;
											var oldLot = '';
											var selRowIdx = 0;
											var selOk  = false;
											var firstLot = '';
											Ext.each( pop2Store.data.items, function(record, i){
												if(record.get('LOT_NO') == newValueLot){
													selRowIdx = i;
													selOk = true;
												}
												if(i == 0){
													firstLot = record.get('LOT_NO')
												}
											});
											Ext.each( pop2Store.data.items, function(record, i){
												if(record.get('LOT_NO') < newValueLot){
													oldLot = record.get('LOT_NO');
													chkErr = true;
												}
											});

											if(chkErr == true && selOk == true){
												if(confirm("스캔한 LOT_NO보다 더 이전에 생산된 LOT이  있습니다.\n그래도 현재 LOT으로 진행하시겠습니까?"))	{
													pop2Grid.getSelectionModel().select(selRowIdx);
												}else{
													pop2Grid.getSelectionModel().select(0);
										    		pop2Search.setValue('LOT_NO',firstLot);
													return false;
												}
											}else if(chkErr == false && selOk == true){
												pop2Grid.getSelectionModel().select(selRowIdx);
											}else if(chkErr == true && selOk == false){
												alert('현재 스캔한 LOT이 재고에 없습니다.\n다른 LOT을 선택해주세요.');
												pop2Search.setValue('LOT_NO',firstLot);
												pop2Grid.getSelectionModel().select(0);

												return false;
										    }else {
										    	alert('현재 스캔한 LOT이 재고에 없습니다.\n다른 LOT을 선택해주세요.');
										    	pop2Grid.getSelectionModel().select(0);
										    	pop2Search.setValue('LOT_NO',firstLot);
												return false;
										    }
									}
								}

							}
				}
			}

		}/*,{
				fieldLabel	: 'LOT직접입력',
				xtype		: 'uniCheckboxgroup',
				labelWidth: 120,
				items		: [{
					boxLabel: '',
					//width	: 350,
					name	: 'LOT_KEYIN_YN',
					checked	: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {

						}
					}
				}]
		}*/,{
			fieldLabel: '<t:message code="system.label.product.realrequiredqty" default="실소요량"/>',
			xtype: 'uniNumberfield',
			name: 'OUTSTOCK_REQ_Q',
			//margin: '0 0 0 -120',
			decimalPrecision: 3,
			format:'0,000.000'
		},{
			fieldLabel: '출고후 소요량잔량',
			xtype: 'uniNumberfield',
			//margin: '0 0 0 -420',
			labelWidth: 200,
			colspan: 3,
			name: 'JAN_OUTSTOCK_REQ_Q',
			decimalPrecision: 3,
			format:'0,000.000'
		},{
			fieldLabel: '<t:message code="system.label.product.issueqty" default="출고량"/>',
			xtype: 'uniNumberfield',
			name: 'INOUT_Q',
			readOnly:false,
			allowBlank:false,
			decimalPrecision: 3,
			format:'0,000.000',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					var selectedRecord = pop2Grid.getSelectedRecord();
					if(!Ext.isEmpty(selectedRecord)){
						selectedRecord.set('INOUT_Q',newValue);
						selectedRecord.set('JAN_Q',selectedRecord.get('STOCK_Q') - newValue);
						pop2Search.setValue('JAN_Q',selectedRecord.get('STOCK_Q') - newValue);
					}
				}

			}

		},{
			fieldLabel: '누적 출고량',
			xtype: 'uniNumberfield',
			name: 'INOUT_Q_TOT',
			labelWidth:150,
			margin: '0 0 0 -33',
			width: 300,
			readOnly:true,
			allowBlank:true,
			decimalPrecision: 3,
			format:'0,000.000',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {

				}

			}

		},{
			fieldLabel: '<t:message code="system.label.product.printq" default="인쇄수량"/>',
			xtype: 'uniNumberfield',
			labelWidth: 150,
			name: 'PRINT_Q',
			width: 200,
			margin: '0 0 0 -90',
			readOnly:false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					setTimeout( function() {
								if(pop2Search.getValue('PACKING_YN') == true){
									pop2Search.setValue('LOT_NO','');
									pop2Search.getField('LOT_NO').focus();
								}
					},10)
				},blur: function(field, The, eOpts){
								if(pop2Search.getValue('PACKING_YN') == true){
									pop2Search.setValue('LOT_NO','');
									pop2Search.getField('LOT_NO').focus();
								}
				},
				afterrender:function(cmp){
					                    cmp.inputEl.set({ //see http://jsfiddle.net/4TSDu/19/
					                        autocomplete:'on'
					                    });

					                    // simply attach this to the change event from dom element
					                    cmp.inputEl.dom.addEventListener('change', function(){
					                        cmp.setValue(this.value);
					                    });

					                    //focus on field
					                    cmp.inputEl.dom.focus();

					                    // see http://www.greywyvern.com/code/javascript/keyboard
					                    VKI_attach(cmp.inputEl.dom);
					}

			}
		},{	xtype: 'container',
			layout: {type : 'table', columns : 1},
			tdAttrs: {align: 'left'},
			margin: '0 0 0 -80',
	    	items:[{
				fieldLabel	: '바코드출력',
				xtype		: 'uniCheckboxgroup',
				labelWidth: 100,
				items		: [{
					boxLabel: '',
					name	: 'PRINT_YN',
					width   : 50,
					checked	: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							setTimeout( function() {
							if(pop2Search.getValue('PACKING_YN') == true){
								pop2Search.setValue('LOT_NO','');
								pop2Search.getField('LOT_NO').focus();
										}
							},10)
						}
					}
				}]
			}

        ]
	},{	xtype: 'container',
			layout: {type : 'table', columns : 2},
			margin : '0 0 0 -100',
			width: 400,
	    	items:[{
				fieldLabel	: '지시분할',
				labelWidth: 100,
				xtype		: 'uniCheckboxgroup',
				items		: [{
					boxLabel: '',
					name	: 'PACKING_YN',
					width   : 50,
					checked	: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if(newValue == true){
								pop2Search.getField('DIVIDE_QTY').setHidden(false);
								pop2Search.setValue('LOT_NO','');
								pop2Search.setValue('INOUT_Q_TOT','');
								pop2Grid.reset();
								pop2Store.clearData();
								pop2Search.getField('DIVIDE_QTY').focus();
							}else{
								pop2Search.getField('DIVIDE_QTY').setHidden(true);
								pop2Search.setValue('DIVIDE_QTY', '1');
							/*	var selectedRecord = pop2Grid.getSelectedRecord();
								divideQ	= pop2Search.getValue('INOUT_Q')
								selectedRecord.set('DIVIDE_Q', divideQ);*/
								pop2Search.setValue('PRINT_Q', 1);
								pop2Search.setValue('INOUT_Q_TOT','');
								pop2Store.loadStoreRecords();
							}
						}
			      	}
				},{	fieldLabel: '패킹수량',
					name: 'DIVIDE_QTY',
					xtype: 'uniTextfield',
					width: 200,
					margin : '0 0 0 -20',
					//fieldStyle: 'margin-right:-40px',
					fieldStyle: 'text-align:right !important',
					value:'1',
					hidden:true,
					readOnly: true,
					allowBlank: true,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {

								pop2Search.getField('LOT_NO').focus();

							},blur: function(field, event, eOpts ) {
								/*var selectedRecords = pop2Grid.getSelectedRecords();
								var divideQ = 0;

								 Ext.each(selectedRecords, function(record, i){
									record.set('INOUT_Q',pop2Search.getValue('DIVIDE_QTY'));
									pop2Search.setValue('INOUT_Q',pop2Search.getValue('DIVIDE_QTY'));
									record.set('DIVIDE_Q',pop2Search.getValue('DIVIDE_QTY'));
									record.set('JAN_Q', record.get('STOCK_Q') - pop2Search.getValue('DIVIDE_QTY'));
									pop2Search.setValue('JAN_Q',record.get('STOCK_Q') - pop2Search.getValue('DIVIDE_QTY'));
									pop2Search.setValue('WH_CODE',record.get('WH_CODE'));
								 })*/
								//pop2Search.setValue('PRINT_Q', 1);
								pop2Search.setValue('INOUT_Q',pop2Search.getValue('DIVIDE_QTY'));
								pop2Search.getField('LOT_NO').focus();

							},afterrender:function(cmp){
					                    cmp.inputEl.set({ //see http://jsfiddle.net/4TSDu/19/
					                        autocomplete:'on'
					                    });

					                    // simply attach this to the change event from dom element
					                    cmp.inputEl.dom.addEventListener('change', function(){
					                        cmp.setValue(this.value);
					                        pop2Search.getField('LOT_NO').focus();
					                    });

					                    //focus on field
					                    cmp.inputEl.dom.focus();

					                    // see http://www.greywyvern.com/code/javascript/keyboard
					                    VKI_attach(cmp.inputEl.dom);
					                }
						}
				}/*,{
						fieldLabel: '분할수량2',
						xtype: 'uniNumberfield',
						name: 'DIVIDE_QTY3',
						id: 'DIVIDE_QTY2',
						labelWidth:150,
						margin: '0 0 0 -270',
						width: 300,
						readOnly:false,
						allowBlank:true,

					//	fieldStyle	: 'background: url(http://localhost:8080/g3erp/resources/js/virtualKeyboard/keyboard.png) no-repeat right;',

						decimalPrecision: 3,
						format:'0,000.000',
						    listeners: {
					                afterrender:function(cmp){
					                    cmp.inputEl.set({ //see http://jsfiddle.net/4TSDu/19/
					                        autocomplete:'on'
					                    });

					                    // simply attach this to the change event from dom element
					                    cmp.inputEl.dom.addEventListener('change', function(){
					                        cmp.setValue(this.value);
					                    });

					                    //focus on field
					                    cmp.inputEl.dom.focus();

					                    // see http://www.greywyvern.com/code/javascript/keyboard
					                    VKI_attach(cmp.inputEl.dom);
					                }
            				}

					}*/]
			}
        	]
		},{
			name:'WORK_SHOP_CODE',
			xtype:'uniTextfield',
			hidden:true
		},{
			name:'OUTSTOCK_NUM',
			xtype:'uniTextfield',
			hidden:true
		},{
			name:'REF_WKORD_NUM',
			xtype:'uniTextfield',
			hidden:true
		},{
			name:'PATH_CODE',
			xtype:'uniTextfield',
			hidden:true
		},{
			fieldLabel:'PROD_ITEM_NAME',
			name:'PROD_ITEM_NAME',
			xtype:'uniTextfield',
			hidden:true
		},{
			fieldLabel:'WKORD_NUM',
			name:'WKORD_NUM',
			xtype:'uniTextfield',
			hidden:true
		}/*,{
			fieldLabel:'INOUT_PRSN',
			name:'INOUT_PRSN',
			xtype:'uniTextfield',
			hidden:true
		}*/,{
			fieldLabel:'STOCK_UNIT',
			name:'STOCK_UNIT',
			xtype:'uniTextfield',
			hidden:true
		},{
			fieldLabel:'OUTSTOCK_JAN_Q',
			xtype: 'uniNumberfield',
			name: 'OUTSTOCK_JAN_Q',
			decimalPrecision: 3,
			format:'0,000.000',
			hidden:true
		},{
			name:'PMP200T_WH_CODE',
			xtype:'uniTextfield',
			hidden:true
		},{
			fieldLabel:'JAN_Q',
			xtype: 'uniNumberfield',
			name: 'JAN_Q',
			decimalPrecision: 3,
			format:'0,000.000',
			hidden:true
		}
		]
	});

	var pop2SearchBalance = Unilite.createSearchForm('pop2BalanceSearchForm', {
		defaults: {readOnly:true},
		padding: '1 1 1 1',
		border: true,
		split:true,
		region:'center',
		flex:1.5,
		height: 500,
//		trackResetOnLoad: true,
		items: [{	xtype:'uxiframe',
							id		: 'iFrameBalance',
							//src	: "http://211.115.212.39:9999/mes/weighing/weighing.do",
							src		: gsKioskConUrl,
							layout	: 'fit',
							padding	: '10 1 1 1',
							width   : '100%'/*,
							height  : '600'*/
						}

		]
	});

	var panelSearch2 = Unilite.createSearchForm('panelSearch2', {
		region:'south',
		layout : {type : 'uniTable', columns : 2, tableAttrs: {width: '99.5%'}},
		padding: '1 1 1 1',
		margin :'-3 0 0 0',
		border: true,
//		defaults:{
//			labelWidth:140,
//			width:375
//		},
		items: [{     xtype       : 'button',
	            text        : '<div style="color: blue">0점조정</div>',
	            width       : 140,
	            height		: 50,
	            margin      : '0 0 2 140',
	            itemId:'btnZeroChk',
	            tdAttrs: {align: 'right'},
	            handler     : function(btn) {
								setTimeout( function() {
									if(confirm("0점 조정을 진행하시겠습니까?"))	{
										setTimeout( function() {
											scaleIframe = $("#iFrameBalance-iframeEl").get(0).contentWindow;
											scaleIframe.postMessage({ command: "requestZero" }, '*');

										},100)
									} else {
											return false;
									}
								},100)
					}
		  },{     xtype       : 'button',
	            text        : '<div style="color: blue">칭량확인</div>',
	            width       : 140,
	            height		: 50,
	            margin      : '0 0 2 0',
	            itemId:'btnPrint1',
	            tdAttrs: {align: 'right'},
	            handler     : function(btn) {

							setTimeout( function() {
								scaleIframe = $("#iFrameBalance-iframeEl").get(0).contentWindow;
								var tet = scaleIframe.postMessage({ command: "getValue" }, '*');
								gsprintYn = pop2Search.getValue('PRINT_YN');

								setTimeout( function() {

									if(confirm("칭량한 내역만큼 출고하시겠습니까?\n확인을 누르시면 데이터가 저장됩니다."))	{
										setTimeout( function() {
											if(!pop2Search.getInvalidMessage()) return;	//필수체크
											Ext.getCmp('pop2Page').getEl().mask('저장 중...','loading-indicator');
											gsRecord  = pop2Grid.getSelectedRecord();
											pop2Store.saveStore();
											if(gsprintYn == false){
												setTimeout( function() {
												 searchPop2Window.hide();
												 	pop1Search.getField('SCAN_CODE').focus();
												},100)
											}

										},100)
									} else {
											return false;
									}
								},1000)
							},500)



					}
		  }
		]
	});


	Unilite.defineModel('pop2Model', {
		fields: [
			{ name: 'DIV_CODE'   		,text:'DIV_CODE'	,type: 'string'},
			{ name: 'LOT_NO'   		,text:'LOT NO'	,type: 'string',allowBlank:false},
			{ name: 'INOUT_DATE_1'   		,text:'<t:message code="system.label.product.receiptdate2" default="입고일자"/>'	,type: 'uniDate'},
			{ name: 'INOUT_DATE_2'   		,text:'출고일자'	,type: 'uniDate',allowBlank:false},
			{ name: 'STOCK_Q'   		,text:'<t:message code="system.label.product.onhandstock" default="현재고"/>'	,type : 'float', decimalPrecision: 3, format:'0,000.000'},
			{ name: 'INOUT_Q'   		,text:'<t:message code="system.label.product.issueqty" default="출고량"/>'	,type : 'float', decimalPrecision: 3, format:'0,000.000',allowBlank:false},
			{ name: 'JAN_Q'   		,text:'<t:message code="system.label.product.issueqtybalanceqty" default="출고후 잔량"/>'	,type : 'float', decimalPrecision: 3, format:'0,000.000'},
			{ name: 'LOCATION'   		,text:'<t:message code="system.label.product.stockplace" default="재고위치"/>'	,type: 'string'},

			{ name: 'PATH_CODE'   		,text:'PATH_CODE'	,type: 'string'},
			{ name: 'WH_CODE'   		,text:'출고창고'	,type: 'string',comboType:'OU'},

			{ name: 'PMP200T_WH_CODE'   		,text:'PMP200T_WH_CODE'	,type: 'string'},

			{ name: 'WORK_SHOP_CODE'   		,text:'WORK_SHOP_CODE'	,type: 'string'},
			{ name: 'OUTSTOCK_NUM'   		,text:'OUTSTOCK_NUM'	,type: 'string'},
			{ name: 'REF_WKORD_NUM'   		,text:'REF_WKORD_NUM'	,type: 'string'}



		]
	});

	var pop2Store = Unilite.createStore('pop2Store', {
		model: 'pop2Model',
		autoLoad: false,
		uniOpt: {
			isMaster: false,	// 상위 버튼 연결
			editable: true,	// 수정 모드 사용
			deletable: false,	// 삭제 가능 여부
			useNavi: false		// prev | newxt 버튼 사용
		},
		proxy: pop2Proxy,
		loadStoreRecords: function( scanYn ) {
//			var params = Ext.merge(pop2Search.getValues(), panelSearch.getValues());

			var param = panelSearch.getValues();

//			param.INOUT_PRSN = pop2Search.getValue('INOUT_PRSN');
			param.WORK_SHOP_CODE = pop2Search.getValue('WORK_SHOP_CODE');
			param.OUTSTOCK_NUM = pop2Search.getValue('OUTSTOCK_NUM');
			param.REF_WKORD_NUM = pop2Search.getValue('REF_WKORD_NUM');
			param.PATH_CODE = pop2Search.getValue('PATH_CODE');//selectPop1Record.get('PATH_CODE');

			param.ITEM_CODE = pop2Search.getValue('ITEM_CODE');

			param.OUTSTOCK_REQ_Q = pop2Search.getValue('OUTSTOCK_REQ_Q');

			param.PMP200T_WH_CODE = pop2Search.getValue('PMP200T_WH_CODE');

			if(Ext.isEmpty(pop1Search.getValue('SCAN_CODE'))){
				var selectPop1Record = pop1Grid.getSelectedRecord();
//				param.ITEM_CODE = selectPop1Record.get('ITEM_CODE');
				param.LOT_NO = '';

			}else{
				var scanCodeSplit = pop1Search.getValue('SCAN_CODE').split('$');
//				param.ITEM_CODE = scanCodeSplit[0];
				param.LOT_NO = scanCodeSplit[1];

//				var selectPop1Record = pop1Grid.getSelectedRecord();
////				pop2Search.setValue('OUTSTOCK_JAN_Q',selectPop1Record.get('OUTSTOCK_JAN_Q'));
//				pop2Search.setValue('INOUT_Q',selectPop1Record.get('OUTSTOCK_JAN_Q'));
			}
			if(! Ext.isEmpty(scanYn)){
				var scanCodeSplit2 = pop2Search.getValue('LOT_NO').split('$');
				param.LOT_NO =  scanCodeSplit2[1]
				if(Ext.isEmpty(scanCodeSplit2[1])){
					param.LOT_NO = ' ';
				}
				param.SCAN_YN = scanYn;
			}
			var lotNo = param.LOT_NO;
			pop2Search.setValue('INOUT_Q_TOT','');
			this.load({
				params : param,
				callback : function(records, operation, success) {
					if(success)	{

							if(Ext.isEmpty(records)) {
							/*	var r = {
									DIV_CODE: panelSearch.getValue('DIV_CODE'),
									ITEM_CODE: pop2Search.getValue('ITEM_CODE'),
									WH_CODE: pop2Search.getValue('WH_CODE'),

									PMP200T_WH_CODE: pop2Search.getValue('PMP200T_WH_CODE'),

									INOUT_DATE_2 : UniDate.getDbDateStr(UniDate.get('today')),
									LOT_NO: lotNo,
									WORK_SHOP_CODE: pop2Search.getValue('WORK_SHOP_CODE'),
									OUTSTOCK_NUM: pop2Search.getValue('OUTSTOCK_NUM'),
									REF_WKORD_NUM: pop2Search.getValue('REF_WKORD_NUM'),
									PATH_CODE: pop2Search.getValue('PATH_CODE')

								}
								pop2Grid.createRow(r);*/
								//alert('해당 LOT_NO가 재고에 없습니다.');


							}else{

								var selectedRecord = pop2Grid.getSelectedRecord();
								var selectPop1Record = pop1Grid.getSelectedRecord();
	//							selectedRecord.set('INOUT_Q',pop2Search.getValue('OUTSTOCK_JAN_Q'));
								if(firstLoadGubun == 'Y'){
									lotNoList = new Array();
									Ext.each(records, function(record, idx) {
								   		lotNoList.push(record.get('LOT_NO'));
									});
								}
								if(! Ext.isEmpty(scanYn)){

										setTimeout( function() {
											selectedRecord.set('INOUT_Q',pop2Search.getValue('INOUT_Q'));
											selectedRecord.set('JAN_Q',selectedRecord.get('STOCK_Q') - pop2Search.getValue('INOUT_Q'));
										},500)
								}else{
										var param = {
											DIV_CODE: panelSearch.getValue('DIV_CODE'),
											WKORD_NUM: pop1Search.getValue('WKORD_NUM'),
											OUTSTOCK_REQ_Q: pop2Search.getValue('OUTSTOCK_REQ_Q'),
											PATH_CODE: pop2Search.getValue('PATH_CODE'),
											ITEM_CODE: pop2Search.getValue('ITEM_CODE'),
											lotNoList: lotNoList
										};
						  				pmp281ukrvService.getJanOutstockReqQ(param, function(provider, response) {
						  					if(!Ext.isEmpty(provider)) {
											/*	pop2Search.setValue('JAN_OUTSTOCK_REQ_Q', provider.JAN_OUTSTOCK_REQ_Q);
												pop2Search.setValue('INOUT_Q',provider.JAN_OUTSTOCK_REQ_Q);
												selectedRecord.set('INOUT_Q',provider.JAN_OUTSTOCK_REQ_Q);*/

												pop2Search.setValue('JAN_OUTSTOCK_REQ_Q', selectPop1Record.get('OUTSTOCK_JAN_Q'));
												pop2Search.setValue('INOUT_Q',selectPop1Record.get('OUTSTOCK_JAN_Q'));
												selectedRecord.set('INOUT_Q',selectPop1Record.get('OUTSTOCK_JAN_Q'));

												selectedRecord.set('JAN_Q', selectedRecord.get('STOCK_Q') - pop2Search.getValue('INOUT_Q'));
												pop2Search.setValue('JAN_Q', selectedRecord.get('STOCK_Q') - pop2Search.getValue('INOUT_Q'));

						  					}else{
												pop2Search.setValue('JAN_OUTSTOCK_REQ_Q', 0);
												pop2Search.setValue('INOUT_Q',0);
												selectedRecord.set('INOUT_Q',0);

												selectedRecord.set('JAN_Q', selectedRecord.get('STOCK_Q') - pop2Search.getValue('INOUT_Q'));
												pop2Search.setValue('JAN_Q', selectedRecord.get('STOCK_Q') - pop2Search.getValue('INOUT_Q'));
						  					}
						  				});
								}

				  				firstLoadGubun = 'N';
							}
							setTimeout( function() {
								if(pop2Search.getValue('PACKING_YN') == true){
									pop2Search.setValue('LOT_NO','');
									pop2Search.getField('LOT_NO').focus();
								}
							},100)

						}else{
							setTimeout( function() {
								if(pop2Search.getValue('PACKING_YN') == true){
									pop2Search.setValue('LOT_NO','');
									pop2Search.getField('LOT_NO').focus();
								}
							},100)
						}
				}
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			//1. 마스터 정보 파라미터 구성
			var paramMaster= pop2Search.getValues();	//syncAll 수정

			if(inValidRecs.length == 0 ) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
//                        Ext.getCmp('pageAll').getEl().unmask();

						pop1Store.loadStoreRecords();
						pop1_2Store.loadStoreRecords();
						pop2Store.loadStoreRecords();
						if(gsprintYn == true){
							UniAppManager.app.onPrintButtonDown();
						}
                    	Ext.getCmp('pop2Page').getEl().unmask();

//						searchPop2Window.hide();
					},
					failure: function(form, action){
                    	Ext.getCmp('pop2Page').getEl().unmask();
					}
				};
				this.syncAllDirect(config);

			} else {
				pop2Grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(pop2Search.getValue('PACKING_YN') == true){
						pop2Grid.getSelectionModel().select(0);
					setTimeout( function() {

							pop2Search.setValue('INOUT_Q_TOT',pop2Store.sum('INOUT_Q'));

					},100)
				}else{
					if(! Ext.isEmpty(gsScanLotCode)){
						var selRowIdx = 0;
						Ext.each( pop2Store.data.items, function(record, i){
								if(record.get('LOT_NO') == gsScanLotCode){
									selRowIdx = i;
								}
						});
						pop2Grid.getSelectionModel().select(selRowIdx);
					}else{
						pop2Grid.getSelectionModel().select(0);
					}
				}
				gsScanLotCode = '';
			}
		}
	});

	var pop2Grid = Unilite.createGrid('pop2Grid', {
		store: pop2Store,
		flex: 1,
		region:'west',
		//collapsible: true,
		height: 500,
		collapseDirection: 'left',
	/*	split:{
			hidden:false,
			width: 20
		},*/
		uniOpt: {
			expandLastColumn: false,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			onLoadSelectFirst: false,
			useRowNumberer: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			},
			useLoadFocus:false
		},
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, mode:'SINGLE',toggleOnClick:false , showHeaderCheckbox : false,
            listeners: {
		                select: function(grid, selectRecord, index, rowIndex, eOpts ){
							/*	 var records = pop2Store.data.items;
					 			 var lotNo = selectRecord.get('LOT_NO');
								 data = new Object();
								 data.records = [];
								 var isErr = false;
								 Ext.each(records, function(record, i){
									 if( pop2Grid.getSelectionModel().isSelected(record) == true) {
										 if(!Ext.isEmpty(lotNo) && lotNo != record.get('LOT_NO')){
											 isErr = true;
											// return false;
									 	 }else{
									 		data.records.push(record);
									 	 }
									 }
								 });
								 pop2Grid.getSelectionModel().select(data.records);
								 if(isErr == true){
									 return false;
								 }*/

		                },
		                deselect:  function(grid, selectRecord, index, eOpts ){
							/*   var records = pop2Store.data.items;
							     data = new Object();
							     data.records = [];
							     Ext.each(records, function(record, i){
							      if(pop2Grid.getSelectionModel().isSelected(record) == true) {
							       data.records.push(record);
										//       requestNoDetailGrid.getSelectionModel().select(i);
							      }
							     });
							     if(Ext.isEmpty(data.records)){
							     	pop2Grid.getSelectionModel().select(selectRecord);
							     }*/
		                }
		            }
		}),
		tbar:  ['->',{
			itemId : 'deleteBtn',
			text: '삭제',
			margin:'0 5 0 0',
			handler: function() {
				var selectedRecord = pop2Grid.getSelectedRecord();

				if(Ext.isEmpty(selectedRecord)){
					Unilite.messageBox('선택된 데이터가 없습니다.');
					return false;
				}

				var selRow = pop2Grid.getSelectedRecord();
				if(confirm('선택된 행을 삭제 합니다. 삭제 하시겠습니까?')) {

                	//Ext.getCmp('pop1Page').getEl().mask('저장 중...','loading-indicator');
					pop2Grid.deleteSelectedRow();
				}
				var lotChk = 0;
				Ext.each(pop2Store.data.items,function(pop2Rec, index){
					if(selRow.get('LOT_NO') == pop2Rec.get('LOT_NO')){
						lotChk =  lotChk + 1;
					}
				});
				setTimeout( function() {
					if(lotChk == 0){
						pop2Search.setValue('INOUT_Q', pop2Search.getValue('OUTSTOCK_REQ_Q'));
					}
					if(pop2Search.getValue('PACKING_YN') == true){
						pop2Search.setValue('INOUT_Q_TOT',pop2Store.sum('INOUT_Q'));
					}
				},100);

			}
		},{
			itemId : 'expandBtn',
			id: 'expandBtn',
			text: '',
			border: false,
			width:55,
			height:30,
			iconCls: 'my-button-right',
			margin:'0 -2 0 0',
			//overCls: 'x-tool x-box-item x-tool-default x-tool-after-title x-tool-pressed',

			//fieldStyle: 'transform : scale(2);',
			handler: function() {
				Ext.getCmp('balancePanel1').setConfig('collapsed', true);
				$(".x-tool-tool-el.x-tool-img.x-tool-expand-right").hide();
				//$('#expandBtn').addClass('x-tool-pressed');
				//$('#collapsedBtn').removeClass('x-tool-pressed');
				pop2Grid.down('#collapsedBtn').setHidden(false);
				pop2Grid.focus();
				pop2Grid.down('#expandBtn').setHidden(true);
			}
		},{
			itemId : 'collapsedBtn',
			id: 'collapsedBtn',
			text: '',
			width:55,
			height:30,
			hidden: true,
			border: false,
			iconCls: 'my-button-left',
			margin:'0 -2 0 0',
			//overCls: 'x-tool x-box-item x-tool-default x-tool-after-title x-tool-pressed',

			handler: function() {
				Ext.getCmp('balancePanel1').setConfig('collapsed', false);
				//$(".x-tool-tool-el.x-tool-img.x-tool-expand-left").hide();
				//$('#collapsedBtn').addClass('x-tool-pressed');
				//$('#expandBtn').removeClass('x-tool-pressed');
				pop2Grid.focus();
				pop2Grid.down('#expandBtn').setHidden(false)
				pop2Grid.down('#collapsedBtn').setHidden(true);
			}
		}
		],
		columns: [
			{ dataIndex: 'WH_CODE'	, width: 140},
			{ dataIndex: 'LOT_NO'	, width: 110},
			{ dataIndex: 'INOUT_DATE_1'	, width: 110},
			{ dataIndex: 'INOUT_DATE_2'	, width: 110},
			{ dataIndex: 'INOUT_Q'	, width: 110, summaryType: 'sum'},
			{ dataIndex: 'JAN_Q'	, width: 150},
			{ dataIndex: 'STOCK_Q'	, width: 110},
			{ dataIndex: 'LOCATION'	, width: 150},

			{ dataIndex: 'PMP200T_WH_CODE'	, width: 100,hidden:true}
//			{ dataIndex: 'WORK_SHOP_CODE'	, width: 100},
//			{ dataIndex: 'OUTSTOCK_NUM'	, width: 100},
//			{ dataIndex: 'REF_WKORD_NUM'	, width: 100}
//			,{ dataIndex: 'PATH_CODE'	, width: 100}


		],
		listeners:{
			beforeselect: function(rowSelection, record, index, eOpts) {
					if(Ext.isEmpty(gsBeforeLotNo)){
						gsBeforeLotNo  = record.get('LOT_NO');
					}
					if(gsBeforeLotNo != record.get('LOT_NO')){
						if(pop2Search.getValue('PACKING_YN') == true){
							var pop2AllRec = pop2Store.data.items;

							Ext.each(pop2AllRec,function(pop2Rec, index){
								pop2Rec.set('INOUT_Q',0);
								pop2Rec.set('JAN_Q',pop2Rec.get('STOCK_Q'));

								pop2Rec.set('INOUT_DATE_2',pop1Search.getValue('INOUT_DATE_2'));
								pop2Rec.commit();
							});
							record.set('INOUT_Q',pop2Search.getValue('INOUT_Q'));
							record.set('JAN_Q', record.get('STOCK_Q') - pop2Search.getValue('INOUT_Q'));
							pop2Search.setValue('JAN_Q',record.get('STOCK_Q') - pop2Search.getValue('INOUT_Q'));
							pop2Search.setValue('WH_CODE',record.get('WH_CODE'));
						}
					}
    		},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0){
					pop2Search.setValue('LOT_NO',selected[0].get('LOT_NO'));
					gsBeforeLotNo = selected[0].get('LOT_NO');
					var pop1GridSelRecord = pop1Grid.getSelectedRecord();
					var outstockReqQ = pop2Search.getValue('OUTSTOCK_REQ_Q');	//소요량
					var janOutstockReqQ = 0;
					if(!Ext.isEmpty(pop1GridSelRecord)){
						janOutstockReqQ = pop1GridSelRecord.get('OUTSTOCK_JAN_Q');
					}
					//var janOutstockReqQ = pop1GridSelRecord.get('OUTSTOCK_JAN_Q');	//남은소요량
					var errorRangeQ = outstockReqQ * 0.01;						//오차범위수량
					var calcRate = 1;											//남은 측정할 량대비 오차량의 비율
					var calcQty = 1;											//계산된 출고량,지시분할이 아닐 경우에는 소요량이 됨
					if(pop2Search.getValue('PACKING_YN') == true){

						calcQty = 0;
						if(pop2Store.count() == 1){
							calcQty = janOutstockReqQ;
							calcRate = (errorRangeQ / calcQty) * 100
							calcRate = Math.floor(calcRate * 100)/100
						}else{
							Ext.each(pop2Store.data.items,function(pop2Rec, index){
								if (pop2Grid.getSelectionModel().isSelected(pop2Rec) == false){
									calcQty += pop2Rec.get('INOUT_Q');
								}
							});

							calcQty  = janOutstockReqQ - calcQty ;
							calcRate = (errorRangeQ / calcQty) * 100
							calcRate = Math.floor(calcRate * 100)/100
						}

					}else{
						calcQty  = janOutstockReqQ;
						calcRate = (errorRangeQ / calcQty) * 100
						calcRate = Math.floor(calcRate * 100)/100
					}

//					pop2Search.setValue('INOUT_Q',selected[0].get('INOUT_Q'));
					setTimeout( function() {
//						var selectedRecord = pop2Grid.getSelectedRecord();
						if(pop2Search.getValue('PACKING_YN') == false){
							var pop2AllRec = pop2Store.data.items;

							Ext.each(pop2AllRec,function(pop2Rec, index){
								pop2Rec.set('INOUT_Q',0);
								pop2Rec.set('JAN_Q',pop2Rec.get('STOCK_Q'));

								pop2Rec.set('INOUT_DATE_2',pop1Search.getValue('INOUT_DATE_2'));
								pop2Rec.commit();
							});

							selected[0].set('INOUT_Q',pop2Search.getValue('INOUT_Q'));
							selected[0].set('JAN_Q', selected[0].get('STOCK_Q') - pop2Search.getValue('INOUT_Q'));


							pop2Search.setValue('JAN_Q',selected[0].get('STOCK_Q') - pop2Search.getValue('INOUT_Q'));
							pop2Search.setValue('WH_CODE',selected[0].get('WH_CODE'));

						}else{

					/*		if(gsLotNo == selected[0].get('LOT_NO')){
								console.log(gsLotNo)
							}else{

							}*/
						}

					}, 50 );

						//팝업으로 데이터를 셋팅합니다.
						scaleIframe = $("#iFrameBalance-iframeEl").get(0).contentWindow;
						setTimeout( function() {

										scaleIframe.postMessage({
										command: 'setValue',	//명령어
										id: '키오스크0', 	//연계아이디
										lotNo: selected[0].data.LOT_NO,	//로트번호
										item: pop2Search.getValue('ITEM_NAME'),	//출고품목
										outStock: {qty: calcQty, unit:pop1GridSelRecord.get('STOCK_UNIT')},	//출고기준수량 , 단위
										errorRange: calcRate,	//오차
										erpLoginID: UserInfo.userID	//erp 로그인 아이디
										}, '*');

						}, 1000 );

				}
			},

			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['INOUT_DATE_2'])){
					return true;
				}else{
					return false;
				}
			}
		}
	/*	listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['LOT_NO'])){
					return true;
				}else{
					return false;
				}
			}
		}*/
	});



		//메세지 받았을 때
	window.addEventListener("message", function(e) {
	var msg = e.data;

	switch (msg.command) {
	        case 'scaleValue': //저울의 무게데이터 요청시의 응답입니다
	         setTimeout( function() {
				if(!Ext.isEmpty(msg.value)){
					var scaleValue = msg.value ;
					scaleValue = String(scaleValue);
					scaleValue =scaleValue.match(/(\d*\.?\d+)/g);
					pop2Search.setValue('INOUT_Q',scaleValue,false);
				}
		      },1000)


	        // document.querySelector('#scaleData').value = msg.value;

	        	break;
	        case 'frameHeight': //저울과 연결 하였을 때 iframe의 높이를 반환합니다
	        	//document.querySelector('#scale-frame').style.height = msg.height + 'px';
	         gsFrameHeight = msg.height + 260;
	         searchPop2Window.setHeight(msg.height + 260);
	         pop2SearchBalance.setHeight(msg.height + 260);
	         $('#pop2Page').css("height",msg.height + 260);
	        	break;
	        default:
	        	console.log(msg);
	        	break;
	    	}
	});



	Unilite.Main({
		id: 'pmp281ukrvApp',
		borderItems: [{
			id: 'pageAll',
			region: 'center',
			layout: 'border',
			border: false,
			items: [
				panelSearch,pop1Search,detailGrid, pop1Grid, pop1_2Grid
			]
		}],
		uniOpt:{showKeyText:false,
				showToolbar: false
//        	forceToolbarbutton:true
		},
		fnInitBinding: function() {
			this.fnInitInputFields();
		/*	var BsaCodeInfo = [] ;
			 BsaCodeInfo.push ({
				'id'	: '111',		// 작업지시와 생산실적 LOT 연계여부 설정 값
				'amount': 150
			});
			 BsaCodeInfo.push ({
				'id'	: '222',		// 작업지시와 생산실적 LOT 연계여부 설정 값
				'amount': 100
			});
			alert(BsaCodeInfo[1].id);*/
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitInputFields();
		},
		onQueryButtonDown: function() {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
			panelSearch.getField('DIV_CODE').setReadOnly(true);
			panelSearch.getField('INOUT_PRSN').setReadOnly(true);
			detailStore.loadStoreRecords();
		},
		onSaveDataButtonDown: function(config) {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크

			detailStore.saveStore();
		},
		fnInitInputFields: function(){
			panelSearch.setValue("DIV_CODE", UserInfo.divCode);
			MODIFY_AUTH = true;
			//panelSearch.setValue("PRODT_WKORD_DATE_FR", "");
			panelSearch.setValue("PRODT_WKORD_DATE_FR", UniDate.get('twoMonthsAgo'));
			//panelSearch.setValue("ITEM_ACCOUNT", "30");
			panelSearch.setValue("PRODT_WKORD_DATE_TO", UniDate.get('today'));
			//panelSearch.setValue("DIV_CODE", "01");
			//panelSearch.setValue("INOUT_PRSN", "01");
			//panelSearch.setValue("WKORD_NUM", "01P20200526001");
			var field = panelSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			panelSearch.getField('INOUT_PRSN').setReadOnly(false);
			panelSearch.getField('SELPRINTER').setValue('TOSHIBA');
			panelSearch.setValue('INOUT_PRSN',gsInOutPrsnLogin);
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','delete','save'], false);
			pop1Search.setHidden(true);
			pop1Grid.setHidden(true);
			pop1_2Grid.setHidden(true);
			setTimeout( function() {
				panelSearch.getField('WKORD_NUM').focus();
			}, 50 );

		},
		onPrintButtonDown: function() {

			if(pop2Search.getValue('PACKING_YN') == true){

						var printDatas = '';
						var param = panelSearch.getValues();
						var sItemCode = '';
						var sWkordNum = '';
						var sLotNo = '';
						var sInoutQ = '';
						var sInoutPrsn = '';
						var sStockUnit = '';
						var sPrintQ = '';
						var sOutStockReqQ = '';
						var sJanOutStockReqQ = '';
						var whCode = '';
						var inOutDate2 = '';

						Ext.each(pop2Store.data.items, function(selectedRecord, index){
							sItemCode 		 = selectedRecord.data.ITEM_CODE;
							sWkordNum 		 = pop1Search.getValue('WKORD_NUM');
							sLotNo 			 = selectedRecord.data.LOT_NO;
							sInoutQ 		 = selectedRecord.data.INOUT_Q;
							sInoutPrsn  	 = panelSearch.getValue('INOUT_PRSN');
							sStockUnit  	 = pop1Search.getValue('STOCK_UNIT');
							sPrintQ 		 = pop1Search.getValue('PRINT_Q');
							sOutStockReqQ    = selectedRecord.data.OUTSTOCK_REQ_Q;
							sJanOutStockReqQ = selectedRecord.data.OUTSTOCK_REQ_Q - selectedRecord.data.INOUT_Q;
							whCode 			 = pop2Search.getValue('WH_CODE');
							inOutDate2 		 = UniDate.getDbDateStr(selectedRecord.data.INOUT_DATE_2);

							if(index ==0) {
								printDatas		= printDatas + sItemCode + '^' + sWkordNum + '^' + sLotNo + '^' + sInoutQ  + '^'	+ sInoutPrsn + '^' + sStockUnit + '^' + sPrintQ + '^' + sOutStockReqQ + '^'+ sJanOutStockReqQ	+ '^' + whCode + '^' + inOutDate2

							}else{
								printDatas		= printDatas + ',' + sItemCode + '^' + sWkordNum + '^' + sLotNo + '^' + sInoutQ  + '^'	+ sInoutPrsn + '^' + sStockUnit + '^' + sPrintQ + '^' + sOutStockReqQ + '^'+ sJanOutStockReqQ	+ '^' + whCode + '^' + inOutDate2
							}
						})
					/*	var param = {
							//PROD_ITEM_NAME,ITEM_NAME 특문 관련 해서 쿼리에서 추출
							//'PROD_ITEM_NAME':pop2Search.getValue('PROD_ITEM_NAME'),	//제품명
							//'ITEM_NAME' :pop2Search.getValue('ITEM_NAME'), 	//원료명
							'ITEM_CODE' :selectedRecord.data.ITEM_CODE, 	//원료코드
							'WKORD_NUM' :pop1Search.getValue('WKORD_NUM'), 	//작지NO
							'LOT_NO' :selectedRecord.data.LOT_NO, //시험의뢰번호
							//'' :pop2Search.getValue(''), TIME 현재시간
							'INOUT_Q' :selectedRecord.data.INOUT_Q, 	//출고량  W / T
							'INOUT_PRSN' :panelSearch.getValue('INOUT_PRSN'),	//칭량자

							'STOCK_UNIT' :selectedRecord.data.STOCK_UNIT,	//단위

							'PRINT_Q' : pop1Search.getValue('PRINT_Q'), //인쇄수량

							'OUTSTOCK_REQ_Q' : selectedRecord.data.OUTSTOCK_REQ_Q,
							'JAN_Q' : selectedRecord.data.OUTSTOCK_REQ_Q - selectedRecord.data.INOUT_Q,

							'WH_CODE' : pop2Search.getValue('WH_CODE'),

							'INOUT_DATE_2' : UniDate.getDbDateStr(selectedRecord.data.INOUT_DATE_2)
						}*/

						param["PRINT_DATAS"] = printDatas;
						param["dataCount"] 	 = pop2Store.count();
						param["USER_LANG"]   = UserInfo.userLang;
						param["PGM_ID"]= PGM_ID;
						param["MAIN_CODE"] = 'P010';//생산용 공통 코드
						param["DIV_CODE"] = panelSearch.getValue('DIV_CODE');
						param["SEL_PRINT"] = Ext.getCmp('selectPrinterchk').getChecked()[0].inputValue;
						param["WKORD_NUM"] = pop1Search.getValue('WKORD_NUM');
						var win = null;
						win = Ext.create('widget.ClipReport', {
							url: CPATH+'/prodt/pmp281clukrv.do',
							prgID: 'pmp281ukrv',
							extParam: param
						});
			//			win.center();	팝업에서 호출시 위치 못찾는현상 때문에 제거
						win.show();
						searchPop2Window.hide();
			}else{
					var pop2SelectR = gsRecord;

					var param = {
						//PROD_ITEM_NAME,ITEM_NAME 특문 관련 해서 쿼리에서 추출
						//'PROD_ITEM_NAME':pop2Search.getValue('PROD_ITEM_NAME'),	//제품명
						//'ITEM_NAME' :pop2Search.getValue('ITEM_NAME'), 	//원료명
						'ITEM_CODE' :pop2Search.getValue('ITEM_CODE'), 	//원료코드
						'WKORD_NUM' :pop1Search.getValue('WKORD_NUM'), 	//작지NO
						'LOT_NO' :pop2Search.getValue('LOT_NO'), //시험의뢰번호
						//'' :pop2Search.getValue(''), TIME 현재시간
						'INOUT_Q' :gsRecord.get('INOUT_Q'), 	//출고량  W / T
						'INOUT_PRSN' :panelSearch.getValue('INOUT_PRSN'),	//칭량자

						'STOCK_UNIT' :pop1Search.getValue('STOCK_UNIT'),	//단위

						'PRINT_Q' : pop2Search.getValue('PRINT_Q'), //인쇄수량

						'OUTSTOCK_REQ_Q' : pop2Search.getValue('OUTSTOCK_REQ_Q'),
						'JAN_Q' : pop2Search.getValue('JAN_Q'),

						'WH_CODE' : pop2Search.getValue('WH_CODE'),

						'INOUT_DATE_2' : UniDate.getDbDateStr(pop2SelectR.get('INOUT_DATE_2'))
					}
					param["USER_LANG"] = UserInfo.userLang;
					param["PGM_ID"]= PGM_ID;
					param["MAIN_CODE"] = 'P010';//생산용 공통 코드
					param["DIV_CODE"] = panelSearch.getValue('DIV_CODE');
					param["SEL_PRINT"] = Ext.getCmp('selectPrinterchk').getChecked()[0].inputValue;
					var win = null;
					win = Ext.create('widget.ClipReport', {
						url: CPATH+'/prodt/pmp280clukrv.do',
						prgID: 'pmp281ukrv',
						extParam: param
					});
		//			win.center();	팝업에서 호출시 위치 못찾는현상 때문에 제거
					win.show();

					searchPop2Window.hide();

		}
	 }



	});

	function beep() {
		audioCtx = new(window.AudioContext || window.webkitAudioContext)();

		var oscillator = audioCtx.createOscillator();
		var gainNode = audioCtx.createGain();

		oscillator.connect(gainNode);
		gainNode.connect(audioCtx.destination);

		gainNode.gain.value = 0.1;				//VOLUME 크기
		oscillator.frequency.value = 4100;
		oscillator.type = 'sine';				//sine, square, sawtooth, triangle

		oscillator.start();

		setTimeout(
			function() {
			  oscillator.stop();
			},
			1000									//길이
		);
	};
};
</script>

