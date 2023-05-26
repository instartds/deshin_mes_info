<%--
'   프로그램명 : 입고등록 (영업 양평)
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
<t:appConfig pgmId="s_str120ukrv_yp">
	<t:ExtComboStore comboType="BOR120" pgmId="s_str120ukrv_yp"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" />						<!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />						<!-- 판매단위 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />			<!-- 창고 -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!-- 창고Cell -->
	<t:ExtComboStore comboType="AU" comboCode="B021" />						<!-- 양불구분 -->
	<t:ExtComboStore comboType="WU" />										<!-- 작업장-->
	<t:ExtComboStore comboType="OU" />										<!-- 창고-->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>
<script type="text/javascript">



var searchInfoWindow;			//searchInfoWindow : 검색창
var referProdtWindow;			//생산량참조
var referInspecResultWindow;	//검사결과 참조
var alertWindow;			//alertWindow : 경고창
var gsText			= ''	//바코드 알람 팝업 메세지

var BsaCodeInfo = {
	gsAutoType		: '${gsAutoType}',
	gsMoneyUnit		: '${gsMoneyUnit}',
	gsInspecFlag	: '${gsInspecFlag}',
	gsSumTypeCell	: '${gsSumTypeCell}',
	gsWkShopDivCode	: ${gsWkShopDivCode}
};
/*var output ='';
for(var key in BsaCodeInfo){
	output += key + ':' + BsaCodeInfo[key] + '\n';
}
alert(output);*/

var sumtypeCell = false;//시/분/초 필드 처리여부
	if(BsaCodeInfo.gsSumTypeCell =='Y')	{
		sumtypeCell = true;
}
var CustomCodeInfo = {
	gsAgentType		: '',
	gsCustCrYn		: '',
	gsUnderCalBase	: ''
};
var outDivCode = UserInfo.divCode;


function appMain() {
	/** 자동채번 여부
	 */
	var isAutoInOutNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoInOutNum = true;
	}

	var sumtypeCell = true;						//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeCell =='Y') {
		sumtypeCell = false;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_str120ukrv_ypService.selectDetailList',
			update	: 's_str120ukrv_ypService.updateDetail',
			create	: 's_str120ukrv_ypService.insertDetail',
			destroy	: 's_str120ukrv_ypService.deleteDetail',
			syncAll	: 's_str120ukrv_ypService.saveAll'
		}
	});

/*	//창고에 따른 창고cell 콤보load..
	var cbStore = Unilite.createStore('hat510ukrsComboStoreGrid',{
		autoLoad: false,
		fields: [
				{name: 'SUB_CODE', type : 'string'},
				{name: 'CODE_NAME', type : 'string'}
				],
		proxy: {
			type: 'direct',
			api: {
				read: 'salesCommonService.fnRecordCombo'
			}
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			param.COMP_CODE= UserInfo.compCode;
			param.DIV_CODE = UserInfo.divCode;
			param.TYPE = 'BSA225T';
			console.log( param );
			this.load({
				params: param
			});
		}
	});*/



	/** 수주의 마스터 정보를 가지고 있는 Form
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
			name: 'INOUT_PRSN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B024',
			allowBlank:false,
			holdable: 'hold',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.receiptdate" default="입고일"/>',
			name: 'INOUT_DATE',
			xtype: 'uniDatefield',
			allowBlank:false,
			value: UniDate.get('today'),
			holdable: 'hold',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.receiptno" default="입고번호"/>',
			name: 'INOUT_NUM',
			xtype: 'uniTextfield',
			readOnly: isAutoInOutNum,
			allowBlank: isAutoInOutNum,
			holdable: 'hold',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.receiptwarehouse" default="입고창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			comboType   : 'OU',
			allowBlank:false,
			child: 'WH_CELL_CODE',
			holdable: 'hold',
			listeners: {
				expand: function(combo, eOpts ){
					var form = panelResult.getForm();
					var inoutPrsn = form.findField('INOUT_PRSN');
					if(inoutPrsn.getValue() == "" || inoutPrsn.getValue() == null){
						alert('<t:message code="unilite.msg.sMS285" default="담당을 먼저 선택하셔야 합니다."/>');
						panelResult.getField('WH_CODE').collapse();
						panelResult.getField('INOUT_PRSN').expand();
					}
				},
				change: function(combo, newValue, oldValue, eOpts) {
					panelResult.getField('BARCODE').focus();
//					cbStore.loadStoreRecords();
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.receiptwarehousecell" default="입고창고Cell"/>',
			name	: 'WH_CELL_CODE',
			xtype	: 'uniCombobox',
			store	: Ext.data.StoreManager.lookup('whCellList'),
			holdable: 'hold',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.barcode" default="바코드"/>',
			name		: 'BARCODE',
			xtype		: 'uniTextfield',
			readOnly	: false,
			fieldStyle	: 'IME-MODE: inactive',				//IE에서만 적용 됨
//			autoCreate	: {tag: 'input', type: 'text', size: '20', style :'IME-MODE:DISABLED' ,autocomplete: 'off', maxlength: '8'},
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						if(!panelResult.getInvalidMessage()) return;	//필수체크

						var newValue = panelResult.getValue('BARCODE');
						if(!Ext.isEmpty(newValue)) {
							//detailGrid에 데이터 존재여부 확인
							fnEnterBarcode(newValue);
							panelResult.setValue('BARCODE', '');
						}
					}
				}
			}
		}/*, {
			fieldLabel: '창고Cell',
			name: 'WH_CELL_CODE',
			xtype: 'uniCombobox',
			store: cbStore,
			allowBlank:false,
			holdable: 'hold',
			listeners: {
				expand: function(combo, eOpts ){
					var form = panelResult.getForm();
					var whCode = form.findField('WH_CODE');
					if(Ext.isEmpty(whCode.getValue())){
						alert('창고를 먼저 선택하셔야 합니다.');
						panelResult.getField('WH_CELL_CODE').collapse();
//						panelResult.getField('WH_CODE').expand();
					}
				},
				change: function(combo, newValue, oldValue, eOpts) {
					panelResult.setValue('WH_CELL_CODE', newValue);
				}
			}
		}*/],
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

					alert(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable)) {
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
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record)	{
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});





	/** 수주의 디테일 정보를 가지고 있는 Grid
	 */
	//마스터 모델 정의
	Unilite.defineModel('s_str120ukrv_ypDetailModel', {
		fields: [
			{name: 'INOUT_METH'			,text: '<t:message code="system.label.sales.tranmethod" default="수불방법"/>' 			,type: 'string', allowBlank: false},
			{name: 'INOUT_CODE_TYPE'	,text: '<t:message code="system.label.sales.tranplacedivision" default="수불처구분"/>'			,type: 'string', allowBlank: false},
			{name: 'INOUT_DATE'			,text: '<t:message code="system.label.sales.transdate" default="수불일"/>'			,type: 'uniDate'},
			{name: 'INOUT_PRSN'			,text: '<t:message code="system.label.sales.charger" default="담당자"/>'		,type: 'string'},
			{name: 'INOUT_NUM'			,text: '<t:message code="system.label.sales.tranno" default="수불번호"/>'			,type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.trantype" default="수불유형"/>'			,type: 'string', allowBlank: false},
			{name: 'INOUT_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'			,type: 'int', allowBlank: false},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'SPEC'			 	,text: '<t:message code="system.label.sales.spec" default="규격"/>'			,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.sales.unit" default="단위"/>'			,type: 'string'},
			{name: 'ITEM_STATUS'		,text: '<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>'			,type: 'string', comboType: 'AU', comboCode: 'B021', allowBlank: false},
			{name: 'INOUT_Q'			,text: '<t:message code="system.label.sales.receiptqty" default="입고량"/>'			,type: 'uniQty', allowBlank: false},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.sales.receiptwarehouse" default="입고창고"/>'			,type: 'string', comboType: 'OU', child: 'WH_CELL_CODE'},
			{name: 'WH_CELL_CODE'		,text: '<t:message code="system.label.sales.receiptwarehousecell" default="입고창고Cell"/>'	,type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','DIV_CODE']},
			{name: 'INOUT_CODE'			,text: '<t:message code="system.label.sales.workcenter" default="작업장"/>'		,type: 'string', comboType: 'WU', allowBlank: false},
			{name: 'TO_DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'			,type: 'string', comboType: 'BOR120', child: 'WH_CODE'},
			{name: 'ORG_CD'				,text: '<t:message code="system.label.sales.division" default="사업장"/>'			,type: 'string', comboType: 'BOR120', child: 'WH_CODE'},
			{name: 'ORIGINAL_Q'			,text: '<t:message code="system.label.sales.prevtranqty" default="이전수불량"/>'			,type: 'uniQty'},
			{name: 'NOTIN_Q'			,text: '<t:message code="system.label.sales.unreceiptqty" default="미입고량"/>'			,type: 'uniQty'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'		,type: 'string'},
			{name: 'INOUT_P'			,text: '<t:message code="system.label.sales.price" default="단가"/>'				,type: 'uniUnitPrice'},
			{name: 'INOUT_I'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'},
			{name: 'INOUT_FOR_P'		,text: '<t:message code="system.label.sales.foreigntranprice" default="외화수불단가"/>'			,type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O'		,text: '<t:message code="system.label.sales.foreigntranamount" default="외화수불금액"/>'			,type: 'uniFC'},
			{name: 'BASIS_P'			,text: '<t:message code="system.label.sales.basisprice" default="기준단가"/>'			,type: 'uniUnitPrice'},
			{name: 'ITEM_ACCOUNT'	 	,text: 'ITEM_ACCOUNT'	,type: 'string'},
			{name: 'BASIS_NUM'			,text: '<t:message code="system.label.sales.productionresultno" default="생산실적번호"/>'			,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'		,type: 'string'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.sales.workorderno" default="작업지시번호"/>'			,type: 'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'			,type: 'string', allowBlank: false},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.sales.updateuser" default="수정자"/>'		,type: 'string', defaultValue: UserInfo.userID},
			{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.sales.updatedate" default="수정일"/>'			,type: 'uniDate'},
			{name: 'DIV_CODE'		 	,text: '<t:message code="system.label.sales.division" default="사업장"/>'			,type: 'string'},
			{name: 'SORT_KEY'		 	,text: 'SORT_KEY'		,type: 'string'},
			{name: 'INSPEC_NUM'			,text: '<t:message code="system.label.sales.inspecno" default="검사번호"/>'			,type: 'string'},
			{name: 'COMP_CODE'			,text: 'COMP_CODE'		,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.sales.remarks" default="비고"/>'			,type: 'string'}
		]
	});
	//마스터 스토어 정의
	var detailStore = Unilite.createStore('s_str120ukrv_ypDetailStore', {
		model	: 's_str120ukrv_ypDetailModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: directProxy,
		loadStoreRecords: function() {
			var param = panelResult.getValues();
			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success)	{
						panelResult.setLoadRecord(records[0]);
					}
				}
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);

			var inoutNum = panelResult.getValue('INOUT_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['INOUT_NUM'] != inoutNum) {
					record.set('INOUT_NUM', inoutNum);
				}
			})

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("INOUT_NUM", master.INOUT_NUM);

						//3.기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						if(detailStore.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_str120ukrv_ypGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				// alert('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
		}
	});
	//마스터 그리드 정의
	var detailGrid = Unilite.createGrid('s_str120ukrv_ypGrid', {
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer	: false
		},
		tbar	: [{
			xtype	: 'splitbutton',
			itemId	: 'refTool',
			text	: '<t:message code="system.label.sales.reference" default="참조..."/>',
			iconCls	: 'icon-referance',
			menu	: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId	: 'requestBtn',
					text	: '<t:message code="system.label.sales.productionqtyrefernoinspec" default="생산량참조(비검사품)"/>',
					hidden	: true,
					handler	: function() {
						openProdtWindow();
					}
				}, {
					itemId	: 'refBtn',
					text	: '<t:message code="system.label.sales.inspecresultrefer" default="검사결과참조"/>',
					hidden	: true,
					handler	: function() {
						openInspecResultWindow();
					}
				}/*, {
					itemId: 'scmBtn',
					text: '업체발주참조(SCM)',
					handler: function() {
							openScmWindow();
						}
				}, {
					itemId: 'excelBtn',
					text: '엑셀참조',
					handler: function() {
							openExcelWindow();
						}
				}*/]
			})
		}],
		store: detailStore,
		columns: [ { dataIndex: 'INOUT_METH'		, width: 66, hidden: true },
				{ dataIndex: 'INOUT_CODE_TYPE'		, width: 66, hidden: true },
				{ dataIndex: 'INOUT_DATE'			, width: 66 , hidden: true},
				{ dataIndex: 'INOUT_PRSN'			, width: 66, hidden: true },
				{ dataIndex: 'INOUT_NUM'			, width: 133, hidden: true},
				{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 66, hidden: true },
				{ dataIndex: 'INOUT_SEQ'			, width: 66},
				{ dataIndex: 'WH_CODE'				, width: 85, hidden: false},
				{ dataIndex: 'WH_CELL_CODE'			, width: 110, hidden: sumtypeCell},
				{ dataIndex: 'ITEM_CODE'			, width: 130,
					editor: Unilite.popup('DIV_PUMOK_G', {
					 							textFieldName: 'ITEM_CODE',
					 							DBtextFieldName: 'ITEM_CODE',
					 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
												autoPopup: true,
												listeners: {'onSelected': {
														fn: function(records, type) {
																console.log('records : ', records);
																Ext.each(records, function(record,i) {
																					if(i==0) {
																						detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
																					} else {
																						UniAppManager.app.onNewDataButtonDown();
																						detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
																					}
																});
														},
														scope: this
												},
												'onClear': function(type) {
													detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
												}
										}
									})
					},
					{dataIndex: 'ITEM_NAME',		width: 150,
					 editor: Unilite.popup('DIV_PUMOK_G', {
					 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
												listeners: {'onSelected': {
														fn: function(records, type) {
																console.log('records : ', records);
																Ext.each(records, function(record,i) {
																					if(i==0) {
																						detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
																					} else {
																						UniAppManager.app.onNewDataButtonDown();
																						detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
																					}
																});
														},
														scope: this
												},
												'onClear': function(type) {
													detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
												}
										}
									})
				},
				{ dataIndex: 'SPEC'			 		, width: 133},
				{ dataIndex: 'STOCK_UNIT'			, width: 46 },
				{ dataIndex: 'ITEM_STATUS'			, width: 80 },
				{ dataIndex: 'INOUT_Q'				, width: 100},
				{ dataIndex: 'INOUT_CODE'			, width: 100 },
				{ dataIndex: 'TO_DIV_CODE'			, width: 66, hidden: true },
				{ dataIndex: 'ORG_CD'				, width: 120 },
				{ dataIndex: 'ORIGINAL_Q'			, width: 80, hidden: true },
				{ dataIndex: 'NOTIN_Q'				, width: 80, hidden: true },
				{ dataIndex: 'MONEY_UNIT'			, width: 66, hidden: true },
				{ dataIndex: 'INOUT_P'				, width: 66, hidden: true },
				{ dataIndex: 'INOUT_I'				, width: 66, hidden: true },
				{ dataIndex: 'INOUT_FOR_P'			, width: 66, hidden: true },
				{ dataIndex: 'INOUT_FOR_O'			, width: 100, hidden: true },
				{ dataIndex: 'BASIS_P'				, width: 100, hidden: true },
				{ dataIndex: 'ITEM_ACCOUNT'	 		, width: 66, hidden: true },
				{ dataIndex: 'BASIS_NUM'			, width: 120, hidden: true},
				{ dataIndex: 'PROJECT_NO'			, width: 93 },
				{ dataIndex: 'WKORD_NUM'			, width: 130 },
				{ dataIndex: 'LOT_NO'				, width: 120/*,
					editor: Unilite.popup('LOTNO_G', {
						textFieldName: 'LOTNO_CODE',
						DBtextFieldName: 'LOTNO_CODE',
						extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
						listeners: {'onSelected': {
								fn: function(records, type) {
									console.log('records : ', records);
									var rtnRecord;
									Ext.each(records, function(record,i) {
										if(i==0){
											rtnRecord = detailGrid.uniOpt.currentRecord
										}else{
											rtnRecord = detailGrid.getSelectedRecord()
										}
										rtnRecord.set('LOT_NO'		, record['LOT_NO']);
										rtnRecord.set('WH_CODE'		, record['WH_CODE']);
										rtnRecord.set('WH_CELL_CODE'	 , record['WH_CELL_CODE']);
									});
								},
								scope: this
							},
							'onClear': function(type) {
								var rtnRecord = detailGrid.uniOpt.currentRecord;
								rtnRecord.set('LOT_NO', '');
							},
							applyextparam: function(popup){
								var record = detailGrid.getSelectedRecord();
								var divCode = panelResult.getValue('DIV_CODE');
//								var customCode = panelResult.getValue('CUSTOM_CODE');
//								var customName = panelResult.getValue('CUSTOM_NAME');
								var itemCode = record.get('ITEM_CODE');
								var itemName = record.get('ITEM_NAME');
								var whCode = record.get('WH_CODE');
								var whCellCode = record.get('WH_CELL_CODE');
								var stockYN = 'Y'
								popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode, 'S_WH_CELL_CODE': whCellCode, 'STOCK_YN': stockYN});
							}
						}
					})*/
				},
				{ dataIndex: 'UPDATE_DB_USER'		, width: 6, hidden: true},
				{ dataIndex: 'UPDATE_DB_TIME'		, width: 6, hidden: true},
				{ dataIndex: 'DIV_CODE'		 		, width: 6, hidden: true},
				{ dataIndex: 'SORT_KEY'		 		, width: 6, hidden: true},
				{ dataIndex: 'INSPEC_NUM'			, width: 133},
				{ dataIndex: 'REMARK'				, width: 166},
				{ dataIndex: 'COMP_CODE'			, width: 33 , hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
//				if (UniUtils.indexOf(e.field, 'LOT_NO')){
//					if(Ext.isEmpty(e.record.data.WH_CODE)){
//						alert('출고창고를 입력하십시오.');
//						return false;
//					}
//					if(Ext.isEmpty(e.record.data.WH_CELL_CODE)){
//						alert('출고창고 CELL코드를 입력하십시오.');
//						return false;
//					}
//					if(Ext.isEmpty(e.record.data.ITEM_CODE)){
//						alert(Msg.sMS003);
//						return false;
//					}
//				}
				if(e.record.phantom){			//신규일때
					if(e.record.data.INOUT_METH == '2')	{
						if(e.field=='SPEC') return false;
						if(e.field=='STOCK_UNIT') return false;
						if(e.field=='BASIS_NUM') return false;
						if(e.field=='WKORD_NUM') return false;
						if(e.field=='TO_DIV_CODE') return false;
						if(e.field=='ORG_CD') return false;
					}else{
						if(e.field=='INOUT_METH'	) return false;
						if(e.field=='INOUT_CODE_TYPE') return false;
						if(e.field=='INOUT_DATE'	) return false;
						if(e.field=='INOUT_PRSN'	) return false;
						if(e.field=='INOUT_NUM'		) return false;
						if(e.field=='INOUT_TYPE_DETAIL') return false;
						if(e.field=='INOUT_SEQ'		) return false;
						if(e.field=='ITEM_CODE'		) return false;
						if(e.field=='ITEM_NAME'		) return false;
						if(e.field=='SPEC'			) return false;
						if(e.field=='STOCK_UNIT'	) return false;
//						if(e.field=='ITEM_STATUS'	) return false;
//						if(e.field=='INOUT_Q'		) return false;
						if(e.field=='WH_CODE'		) return false;
//						if(e.field=='WH_CELL_CODE'	) return false;
						if(e.field=='INOUT_CODE'	) return false;
						if(e.field=='TO_DIV_CODE'	) return false;
						if(e.field=='ORG_CD'		) return false;
						if(e.field=='ORIGINAL_Q'	) return false;
						if(e.field=='NOTIN_Q'		) return false;
						if(e.field=='MONEY_UNIT'	) return false;
						if(e.field=='INOUT_P'		) return false;
						if(e.field=='INOUT_I'		) return false;
						if(e.field=='INOUT_FOR_P'	) return false;
						if(e.field=='INOUT_FOR_O'	) return false;
						if(e.field=='BASIS_P'		) return false;
						if(e.field=='ITEM_ACCOUNT'	) return false;
						if(e.field=='BASIS_NUM'		) return false;
						if(e.field=='PROJECT_NO'	) return false;
						if(e.field=='WKORD_NUM'		) return false;
						if(e.field=='LOT_NO'		) return false;
						if(e.field=='UPDATE_DB_USER') return false;
						if(e.field=='UPDATE_DB_TIME') return false;
						if(e.field=='DIV_CODE'		) return false;
						if(e.field=='SORT_KEY'		) return false;
						if(e.field=='INSPEC_NUM'	) return false;
						if(e.field=='COMP_CODE'		) return false;
//						if(e.field=='REMARK'		) return false;
					}
				}else{
					if(e.field=='INOUT_METH'	) return false;
					if(e.field=='INOUT_CODE_TYPE') return false;
					if(e.field=='INOUT_DATE'	) return false;
					if(e.field=='INOUT_PRSN'	) return false;
					if(e.field=='INOUT_NUM'		) return false;
					if(e.field=='INOUT_CODE'	) return false;
					if(e.field=='LOT_NO'		) return false;
					if(e.field=='INOUT_TYPE_DETAIL') return false;
					if(e.field=='INOUT_SEQ'		) return false;
					if(e.field=='ITEM_CODE'		) return false;
					if(e.field=='ITEM_NAME'		) return false;
					if(e.field=='SPEC'			) return false;
					if(e.field=='STOCK_UNIT'	) return false;
					if(e.field=='ITEM_STATUS'	) return false;
//					if(e.field=='INOUT_Q'		) return false;
					if(e.field=='WH_CODE'		) return false;
//					if(e.field=='WH_CELL_CODE'	) return false;
//					if(e.field=='INOUT_CODE'	) return false;
					if(e.field=='TO_DIV_CODE'	) return false;
					if(e.field=='ORG_CD'		) return false;
					if(e.field=='ORIGINAL_Q'	) return false;
					if(e.field=='NOTIN_Q'		) return false;
					if(e.field=='MONEY_UNIT'	) return false;
					if(e.field=='INOUT_P'		) return false;
					if(e.field=='INOUT_I'		) return false;
					if(e.field=='INOUT_FOR_P'	) return false;
					if(e.field=='INOUT_FOR_O'	) return false;
					if(e.field=='BASIS_P'		) return false;
					if(e.field=='ITEM_ACCOUNT'	) return false;
					if(e.field=='BASIS_NUM'		) return false;
//					if(e.field=='PROJECT_NO'	) return false;
					if(e.field=='WKORD_NUM'		) return false;
//					if(e.field=='LOT_NO'		) return false;
					if(e.field=='UPDATE_DB_USER') return false;
					if(e.field=='UPDATE_DB_TIME') return false;
					if(e.field=='DIV_CODE'		) return false;
					if(e.field=='SORT_KEY'		) return false;
					if(e.field=='INSPEC_NUM'	) return false;
					if(e.field=='COMP_CODE'		) return false;
//					if(e.field=='REMARK'		) return false;

					if(e.record.data.INOUT_METH == '1')	{
						if(e.field=='INOUT_CODE') return false;
						if(e.field=='PROJECT_NO') return false;
						if(e.field=='LOT_NO') return false;
					}
				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
//			var grdRecord = this.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		,"");
				grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('STOCK_UNIT'		,"");
				grdRecord.set('BASIS_P'			,0);
				grdRecord.set('INOUT_FOR_P'		,0);
				grdRecord.set('ITEM_ACCOUNT'	,"");
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('BASIS_P'			, record['BASIS_P']);
				grdRecord.set('INOUT_FOR_P'		, record['BASIS_P']);
				grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
			}
		},
		setProdtData:function(record) {			//생산량 참조
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('INOUT_METH'			, '1');
			grdRecord.set('INOUT_CODE'			, record['WORK_SHOP_CODE']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('ITEM_STATUS'			, record['ITEM_STATUS']);
			grdRecord.set('INOUT_Q'				, record['NOTIN_Q']);
			grdRecord.set('ORIGINAL_Q'			, 0);
			grdRecord.set('NOTIN_Q'				, record['NOTIN_Q']);
			grdRecord.set('INOUT_P'				, record['BASIS_P']);
			grdRecord.set('INOUT_I'				,(record['NOTIN_Q'] * record['BASIS_P']));
			grdRecord.set('INOUT_FOR_P'			, record['BASIS_P']);
			grdRecord.set('INOUT_FOR_O'			,(record['NOTIN_Q'] * record['BASIS_P']));
			grdRecord.set('BASIS_NUM'			, record['PRODT_NUM']);
			grdRecord.set('TO_DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('ORG_CD'				, record['DIV_CODE']);
			grdRecord.set('BASIS_P'				, record['BASIS_P']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('WKORD_NUM'			, record['WKORD_NUM']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('DIV_CODE'			, UserInfo.divCode);
			grdRecord.set('COMP_CODE'			, UserInfo.compCode);
			panelResult.getField('BARCODE').focus();
		},
		setRefData: function(record) {		//검사결과 참조
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('INOUT_METH'			,'1');
			grdRecord.set('INOUT_CODE'			, record['WORK_SHOP_CODE']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('ITEM_STATUS'			, record['ITEM_STATUS']);
			grdRecord.set('INOUT_Q'				, record['NOTIN_Q']);
			grdRecord.set('ORIGINAL_Q'			, 0);
			grdRecord.set('NOTIN_Q'				, record['NOTIN_Q']);
			grdRecord.set('INOUT_P'				, record['INOUT_P']);
			grdRecord.set('INOUT_I'				,(record['NOTIN_Q'] * record['BASIS_P']));
			grdRecord.set('INOUT_FOR_P'			, record['BASIS_P']);
			grdRecord.set('INOUT_FOR_O'			,(record['NOTIN_Q'] * record['BASIS_P']));
			grdRecord.set('BASIS_NUM'			, record['PRODT_NUM']);
			grdRecord.set('TO_DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('ORG_CD'				, record['DIV_CODE']);
			grdRecord.set('BASIS_P'				, record['BASIS_P']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('WKORD_NUM'			, record['WKORD_NUM']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('DIV_CODE'			, UserInfo.divCode);
			grdRecord.set('INSPEC_NUM'			, record['INSPEC_NUM']);
			grdRecord.set('INSPEC_SEQ'			, record['INSPEC_SEQ']);
			grdRecord.set('COMP_CODE'			, record['UserInfo.compCode']);
			panelResult.getField('BARCODE').focus();
	}
	});





	/** 수주정보를 검색하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//검색창 폼 정의
	var inNoSearch = Unilite.createSearchForm('inNoSearchForm', {
		layout	: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
			name		: 'INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024'
		}, {
			 fieldLabel		: '<t:message code="system.label.sales.receiptdate" default="입고일"/>',
			 xtype			: 'uniDateRangefield',
			 startFieldName	: 'INOUT_DATE_FR',
			 endFieldName	: 'INOUT_DATE_TO',
			 startDate		: UniDate.get('startOfMonth'),
			 endDate		: UniDate.get('today'),
			 width			: 315
		}, {
			fieldLabel	: '<t:message code="system.label.sales.receiptwarehouse" default="입고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType: 'OU'

		},
			Unilite.popup('DIV_PUMOK',{
		}), {
			fieldLabel	: '<t:message code="system.label.sales.lotno" default="LOT번호"/>',
			name		: '',
			xtype		: 'uniTextfield'
		}, {
			fieldLabel	: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			name		: 'PROJECT_NO',
			xtype		: 'uniTextfield'
		}, {
			xtype	: 'hiddenfield',
			items	: [{
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				name		: 'DIV_CODE'
			}]
		}]
	}); // createSearchForm
	//검색창 모델 정의
	Unilite.defineModel('inNoMasterModel', {
		fields: [
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.sales.spec" default="규격"/>'					, type: 'string'},
			{name: 'INOUT_DATE'		, text: '<t:message code="system.label.sales.receiptdate" default="입고일"/>'			, type: 'uniDate'},
			{name: 'INOUT_Q'		, text: '<t:message code="system.label.sales.receiptqty" default="입고량"/>'			, type: 'uniQty'},
			{name: 'INOUT_PRSN'		, text: '<t:message code="system.label.sales.trancharge" default="수불담당"/>'			, type: 'string', comboType: 'AU', comboCode: 'B024'},
			{name: 'INOUT_NUM'		, text: '<t:message code="system.label.sales.receiptno" default="입고번호"/>'			, type: 'string'},
			{name: 'PROJECT_NO'		, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>'				, type: 'string'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.sales.receiptwarehouse" default="입고창고"/>'	, type: 'string', comboType: 'OU'},
			{name: 'WH_CELL_CODE'	, text: '<t:message code="system.label.sales.receiptwarehousecell" default="입고창고Cell"/>'		, type: 'string'},
			{name: 'WH_CELL_NAME'	, text: '<t:message code="system.label.sales.receiptwarehousecellname" default="입고창고Cell명"/>'		, type: 'string'},
			{name: 'LOT_NO'			, text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'				, type: 'string'}
		]
	});
	//검색창 스토어 정의
	var inNoMasterStore = Unilite.createStore('inNoMasterStore', {
		model	: 'inNoMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read : 's_str120ukrv_ypService.selectInNumMasterList'
			}
		},
		loadStoreRecords : function()	{
			var param= inNoSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색창 그리드 정의
	var orderNoMasterGrid = Unilite.createGrid('s_str120ukrv_ypInNoMasterGrid', {
		// title: '기본',
		layout	: 'fit',
		store	: inNoMasterStore,
		uniOpt	: {
			useRowNumberer: false
		},
		columns	: [
			{ dataIndex: 'ITEM_CODE'	, width: 120 },
			{ dataIndex: 'ITEM_NAME'	, width: 133 },
			{ dataIndex: 'SPEC'			, width: 133 },
			{ dataIndex: 'INOUT_DATE'	, width: 73},
			{ dataIndex: 'INOUT_Q'	 	, width: 100 },
			{ dataIndex: 'INOUT_PRSN'	, width: 80},
			{ dataIndex: 'INOUT_NUM'	, width: 100 },
			{ dataIndex: 'PROJECT_NO'	, width: 100 },
			{ dataIndex: 'DIV_CODE'		, width: 66, hidden: true},
			{ dataIndex: 'WH_CODE'		, width: 93},
			{ dataIndex: 'WH_CELL_CODE'	, width: 133, hidden: true },
			{ dataIndex: 'WH_CELL_NAME'	, width: 133 },
			{ dataIndex: 'LOT_NO'		, width: 100 }
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				searchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelResult.setValues({'INOUT_PRSN':record.get('INOUT_PRSN'), 'INOUT_DATE':record.get('INOUT_DATE'),
								'INOUT_NUM':record.get('INOUT_NUM'), 'WH_CODE':record.get('WH_CODE')});
		}
	});
	//검색창 메인 (openSearchInfoWindow)
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '입고번호검색',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [inNoSearch, orderNoMasterGrid],
				tbar	:['->',{
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						inNoMasterStore.loadStoreRecords();
					},
					disabled: false
				}, {
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						searchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt)	{
						inNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						inNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					show: function( panel, eOpts )	{
						inNoSearch.setValue('INOUT_PRSN'	, panelResult.getValue('INOUT_PRSN'));
						inNoSearch.setValue('WH_CODE'		, panelResult.getValue('WH_CODE'));
						inNoSearch.setValue('INOUT_DATE_FR'	, UniDate.get('startOfMonth', panelResult.getValue('INOUT_DATE')));
						inNoSearch.setValue('INOUT_DATE_TO'	, panelResult.getValue('INOUT_DATE'));
					}
				}
			})
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
	}



	/** 생산실적내역을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//생산량참조 폼 정의
	var prodtSearch = Unilite.createSearchForm('prodtForm', {
		layout :{type : 'uniTable', columns : 3},
		items :[{
			fieldLabel: '<t:message code="system.label.sales.productiondate" default="생산일"/>',
			xtype: 'uniDateRangefield',
			width: 315,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			startFieldName: 'PRODT_DATE_FR',
			endFieldName: 'PRODT_DATE_TO',
			colspan: 3
		}, {
			fieldLabel: '<t:message code="system.label.sales.warehouse" default="창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			comboType	: 'OU'
		},
			Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>' ,
			validateBlank: false,
			colspan: 2
		}),{
			fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120'
		}, {
			fieldLabel: '<t:message code="system.label.sales.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType: 'WU'
		}, {
			fieldLabel: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			name: 'PROJECT_NO',
			xtype: 'uniTextfield'
		},{
			xtype: 'hiddenfield',
			name: 'H_DIV_CODE',
			value: UserInfo.divCode
		}]
	});
	//생산량참조 모델 정의
	Unilite.defineModel('s_str120ukrv_ypProdtModel', {
		fields: [
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'			, type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.sales.spec" default="규격"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'		,text: '<t:message code="system.label.sales.unit" default="단위"/>'			, type: 'string', displayField: 'value'},
			{name: 'PROD_DT'		,text: '<t:message code="system.label.sales.productiondate" default="생산일"/>'		, type: 'uniDate'},
			{name: 'PRODT_Q'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		, type: 'uniQty'},
			{name: 'NOTIN_Q'		,text: '<t:message code="system.label.sales.unreceiptqty" default="미입고량"/>'		, type: 'uniQty'},
			{name: 'WORK_SHOP_CODE'	,text: '<t:message code="system.label.sales.workcentercode" default="작업장코드"/>'		, type: 'string'},
			{name: 'WK_SHOP_NM'		,text: '<t:message code="system.label.sales.workcenter" default="작업장"/>'	, type: 'string'},
			{name: 'PRODT_NUM'		,text: '<t:message code="system.label.sales.productionresultno" default="생산실적번호"/>'		, type: 'string'},
			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.sales.workorderno" default="작업지시번호"/>'		, type: 'string'},
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'		, type: 'string', comboType: 'BOR120'},
			{name: 'REMARK'			,text: '<t:message code="system.label.sales.remarks" default="비고"/>'		, type: 'string'},
			{name: 'PROJECT_NO'		,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'	, type: 'string'},
			{name: 'LOT_NO'			,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'		, type: 'string'},
			{name: 'BASIS_P'		,text: '<t:message code="system.label.sales.basisprice" default="기준단가"/>'		, type: 'uniPrice'},
			{name: 'SORT_KEY'		,text: 'SORT_KEY'	, type: 'string'},
			{name: 'WH_CODE'		,text: '<t:message code="system.label.sales.mainwarehouse" default="주창고"/>'		, type: 'string', comboType	: 'OU'},
			{name: 'PRODT_DATE'		,text: '<t:message code="system.label.sales.productiondate" default="생산일"/>'		, type: 'uniDate'},
			{name: 'ITEM_STATUS'	,text: '<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>'		, type: 'string', comboType: 'AU', comboCode: 'B021'}
		]
	});
	//생산량참조 스토어 정의
	var prodtStore = Unilite.createStore('s_str120ukrv_ypProdtStore', {
		model	: 's_str120ukrv_ypProdtModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read	: 's_str120ukrv_ypService.selectProdtList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful)	{
					var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
					var deleteRecords = new Array();

					if(masterRecords.items.length > 0)	{
						console.log("store.items :", store.items);
						console.log("records", records);

						Ext.each(records, function(item, i)	{
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								if(record.data['WKORD_NUM'] == item.data['WKORD_NUM']
								&& record.data['ITEM_CODE'] == item.data['ITEM_CODE']) {
									deleteRecords.push(item);
								}
							});
						});
						store.remove(deleteRecords);
					}
				}
			}
		},
		loadStoreRecords : function()	{
			var param= prodtSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//생산량참조 그리드 정의
	var prodtGrid = Unilite.createGrid('s_str120ukrv_ypProdtGrid', {
		// title: '기본',
		layout	: 'fit',
		store	: prodtStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick: false, mode: 'SIMPLE' }),
		uniOpt	: {
			onLoadSelectFirst : false
		},
		columns: [
			{ dataIndex: 'ITEM_CODE'		, width: 120 },
			{ dataIndex: 'ITEM_NAME'		, width: 120 },
			{ dataIndex: 'SPEC'				, width: 120 },
			{ dataIndex: 'STOCK_UNIT'		, width: 40 },
			{ dataIndex: 'PROD_DT'			, width: 73 },
			{ dataIndex: 'PRODT_Q'			, width: 86 },
			{ dataIndex: 'NOTIN_Q'			, width: 86 },
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 86, hidden: true },
			{ dataIndex: 'WK_SHOP_NM'		, width: 86 },
			{ dataIndex: 'PRODT_NUM'		, width: 93, hidden: true },
			{ dataIndex: 'WKORD_NUM'		, width: 120 },
			{ dataIndex: 'DIV_CODE'			, width: 80 },
			{ dataIndex: 'REMARK'			, width: 80, hidden: true },
			{ dataIndex: 'PROJECT_NO'		, width: 93 },
			{ dataIndex: 'LOT_NO'			, width: 93 },
			{ dataIndex: 'BASIS_P'			, width: 80, hidden: true },
			{ dataIndex: 'SORT_KEY'			, width: 80, hidden: true },
			{ dataIndex: 'WH_CODE'			, width: 80 },
			{ dataIndex: 'PRODT_DATE'		, width: 66, hidden: true },
			{ dataIndex: 'ITEM_STATUS'		, width: 66}
		],
		listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {
				}
			},
			returnData: function()	{
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				detailGrid.setProdtData(record.data);
			});
			this.deleteSelectedRow();
		}
	});
	//생산량참조 메인
	function openProdtWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
//		prodtSearch.setValue('WH_CODE'		, panelResult.getValue('WH_CODE'));
		prodtSearch.setValue('PRODT_DATE_FR', UniDate.get('startOfMonth'));
		prodtSearch.setValue('PRODT_DATE_TO', UniDate.get('today'));
		prodtSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));

		if(!referProdtWindow) {
			referProdtWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.productionqtyrefernoinspec" default="생산량참조(비검사품)"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},

				items: [prodtSearch, prodtGrid],
				tbar:['->', {
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						prodtStore.loadStoreRecords();
					},
					disabled: false
				},
				{	itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.receiptapply" default="입고적용"/>',
					handler	: function() {
						prodtGrid.returnData();
					},
					disabled: false
				},
				{	itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.sales.receiptapplyclose" default="입고적용후 닫기"/>',
					handler	: function() {
						prodtGrid.returnData();
						referProdtWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						referProdtWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt)	{
						//prodtSearch.clearForm();
						//prodtGrid,reset();
					},
					beforeclose: function( panel, eOpts )	{
						//prodtSearch.clearForm();
						//prodtGrid,reset();
					},
					beforeshow: function ( me, eOpts )	{
						prodtStore.loadStoreRecords();
					}
				}
			})
		}
		referProdtWindow.center();
		referProdtWindow.show();
	}



	/** 검사결과를 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//검사결과 참조 폼 정의
	var inspecResultSearch = Unilite.createSearchForm('s_str120ukrv_ypInspecResultForm', {
		layout	: {type : 'uniTable', columns : 3},
		items	: [{
			fieldLabel: '<t:message code="system.label.sales.productiondate" default="생산일"/>',
			xtype: 'uniDateRangefield',
			width: 315,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			startFieldName: 'PRODT_DATE_FR',
			endFieldName: 'PRODT_DATE_TO',
			colspan: 3
		}, {
			fieldLabel: '<t:message code="system.label.sales.warehouse" default="창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			comboType	: 'OU'
		},
			Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>' ,
			validateBlank: false,
			colspan: 2
		}),{
			fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120'
		}, {
			fieldLabel: '<t:message code="system.label.sales.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType: 'WU'
		}, {
			fieldLabel: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			name: 'PROJECT_NO',
			xtype: 'uniTextfield'
		}]
	});
	//검사결과 참조 모델 정의
	Unilite.defineModel('s_str120ukrv_ypInspecResultModel', {
		fields: [
			{ name: 'ITEM_CODE'			, text:'<t:message code="system.label.sales.item" default="품목"/>'			,type : 'string' },
			{ name: 'ITEM_NAME'			, text:'<t:message code="system.label.sales.itemname" default="품목명"/>'		,type : 'string' },
			{ name: 'SPEC'				, text:'<t:message code="system.label.sales.spec" default="규격"/>'			,type : 'string' },
			{ name: 'STOCK_UNIT'		, text:'<t:message code="system.label.sales.unit" default="단위"/>'			,type : 'string' , displayField: 'value'},
			{ name: 'PROD_DT'			, text:'<t:message code="system.label.sales.productiondate" default="생산일"/>'			,type : 'uniDate' },
			{ name: 'INSPEC_DATE'		, text:'<t:message code="system.label.sales.inspecdate" default="검사일"/>'			,type : 'uniDate' },
			{ name: 'PRODT_Q1'			, text:'<t:message code="system.label.sales.productionqty" default="생산량"/>'			,type : 'uniQty' },
			{ name: 'PRODT_Q'			, text:'<t:message code="system.label.sales.inspecqty" default="검사량"/>'			,type : 'uniQty' },
			{ name: 'NOTIN_Q'			, text:'<t:message code="system.label.sales.unreceiptqty" default="미입고량"/>'			,type : 'uniQty' },
			{ name: 'ITEM_STATUS'		, text:'<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>'			,type : 'string', comboType: 'AU', comboCode: 'B021' },
			{ name: 'WORK_SHOP_CODE'	, text:'<t:message code="system.label.sales.workcentercode" default="작업장코드"/>'			,type : 'string' },
			{ name: 'WK_SHOP_NM'		, text:'<t:message code="system.label.sales.workcenter" default="작업장"/>'	,type : 'string' },
			{ name: 'WH_CODE'			, text:'<t:message code="system.label.sales.warehouse" default="창고"/>'			,type : 'string' },
			{ name: 'WH_NM'				, text:'<t:message code="system.label.sales.warehousename" default="창고명"/>'			,type : 'string' },
			{ name: 'PRODT_NUM'			, text:'<t:message code="system.label.sales.productionresultno" default="생산실적번호"/>'			,type : 'string' },
			{ name: 'WKORD_NUM'			, text:'<t:message code="system.label.sales.workorderno" default="작업지시번호"/>'			,type : 'string' },
			{ name: 'DIV_CODE'			, text:'<t:message code="system.label.sales.division" default="사업장"/>' 		,type : 'string', comboType: 'BOR120'},
			{ name: 'PROJECT_NO'		, text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'	,type : 'string' },
			{ name: 'LOT_NO'			, text:'<t:message code="system.label.sales.lotno" default="LOT번호"/>' 		,type : 'string' },
			{ name: 'BASIS_P'			, text:'<t:message code="system.label.sales.basisprice" default="기준단가"/>'			,type : 'uniUnitPrice' },
			{ name: 'SORT_KEY'			, text:'SORT_KEY'		,type : 'string' },
			{ name: 'INSPEC_NUM'		, text:'검사번호'			,type : 'string' },
			{ name: 'INSPEC_SEQ'		, text:'순번'			,type : 'string' }
		]
	});
	//검사결과 참조 스토어 정의
	var inspecResultStore = Unilite.createStore('s_str120ukrv_ypInspecResultStore', {
		model	: 's_str120ukrv_ypInspecResultModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false				// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read	: 's_str120ukrv_ypService.inspecResult'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(successful)	{
					var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
					var deleteRecords = new Array();

					if(masterRecords.items.length > 0)	{
						console.log("store.items :", store.items);
						console.log("records", records);

						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);

								if(record.data['WKORD_NUM'] == item.data['WKORD_NUM']
								&& record.data['ITEM_CODE'] == item.data['ITEM_CODE']) {
									deleteRecords.push(item);
								}
							});
						});
						store.remove(deleteRecords);
					}
				}
			}
		},
		loadStoreRecords : function()	{
			var param= inspecResultSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검사결과 참조 그리드 정의
	var inspecResultGrid = Unilite.createGrid('s_str120ukrv_ypInspecResultGrid', {
		// title: '기본',
		layout	: 'fit',
		store	: inspecResultStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick: false, mode: 'SIMPLE' }),
		uniOpt	: {
			onLoadSelectFirst : false
		},
		columns: [
			{ dataIndex: 'INSPEC_NUM'			, width: 120 },
			{ dataIndex: 'INSPEC_SEQ'			, width: 50, align:'center' },
			{ dataIndex: 'WORK_SHOP_CODE'		, width: 86, hidden: true },
			{ dataIndex: 'WK_SHOP_NM'			, width: 86 },
			{ dataIndex: 'ITEM_CODE'			, width: 93 },
			{ dataIndex: 'ITEM_NAME'			, width: 150 },
			{ dataIndex: 'SPEC'					, width: 120 },
			{ dataIndex: 'STOCK_UNIT'			, width: 40, align:'center' },
			{ dataIndex: 'PROD_DT'				, width: 86 },
			{ dataIndex: 'INSPEC_DATE'			, width: 86 },
			{ dataIndex: 'PRODT_Q1'				, width: 86 },
			{ dataIndex: 'PRODT_Q'				, width: 86 },
			{ dataIndex: 'NOTIN_Q'				, width: 86 },
			{ dataIndex: 'ITEM_STATUS'			, width: 80, align:'center'},

			{ dataIndex: 'WH_CODE'				, width: 80 },
			{ dataIndex: 'WH_NM'				, width: 80 },
			{ dataIndex: 'PRODT_NUM'			, width: 93, hidden: true },
			{ dataIndex: 'WKORD_NUM'			, width: 120 },
			{ dataIndex: 'DIV_CODE'				, width: 80 },
			{ dataIndex: 'LOT_NO'				, width: 93 },
			{ dataIndex: 'PROJECT_NO'			, width: 93 },
			{ dataIndex: 'BASIS_P'				, width: 80, hidden: true },
			{ dataIndex: 'SORT_KEY'				, width: 80, hidden: true }
		] ,
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function()	{
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				detailGrid.setRefData(record.data);
			});
			this.deleteSelectedRow();
		}
	});
	//검사결과 참조 메인
	function openInspecResultWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
//		inspecResultSearch.setValue('WH_CODE'		, panelResult.getValue('WH_CODE'));
		inspecResultSearch.setValue('PRODT_DATE_FR'	, UniDate.get('startOfMonth'));
		inspecResultSearch.setValue('PRODT_DATE_TO'	, UniDate.get('today'));
		inspecResultSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));

		if(!referInspecResultWindow) {
			referInspecResultWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.inspecresultrefer" default="검사결과참조"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [inspecResultSearch, inspecResultGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						inspecResultStore.loadStoreRecords();
					},
					disabled: false
				},{	itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.receiptapply" default="입고적용"/>',
					handler	: function() {
						inspecResultGrid.returnData();
					},
					disabled: false
				},{	itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.sales.receiptapplyclose" default="입고적용후 닫기"/>',
					handler	: function() {
						inspecResultGrid.returnData();
						referInspecResultWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						referInspecResultWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt)	{
						//inspecResultSearch.clearForm();
						//inspecResultGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						//inspecResultSearch.clearForm();
						//inspecResultGrid.reset();
					},
					beforeshow: function ( me, eOpts )	{
						inspecResultStore.loadStoreRecords();
					}
				}
			})
		}
		referInspecResultWindow.center();
		referInspecResultWindow.show();
	}

	function fnCreateLotNo(date, certType) {
		if(!date) {
			var date = UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'));
		}
		var charater	= new Array('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L');

		var year		= date.substring(2,4);
		var month		= charater[(date.substring(4,6) - 1)];
		var day			= date.substring(6,8);
		if(Ext.isEmpty(certType)) {
			certType = '0';
		}

		var lotNo		= 'YP' + day + month + year + '00' + certType;

		return lotNo
	}

	/** main app
	 */
	Unilite.Main({
		id			: 's_str120ukrv_ypApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid
			]
		}],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
			this.setDefault();

			var requestBtn	= detailGrid.down('#requestBtn');
			var refBtn		= detailGrid.down('#refBtn');
			if(BsaCodeInfo.gsInspecFlag=="Y")	{
				requestBtn.setText('<t:message code="system.label.sales.productionqtyrefernoinspec" default="생산량참조(비검사품)"/>');
				requestBtn.show();
				refBtn.show();
			}else {
				requestBtn.setText('<t:message code="system.label.sales.productionqtyrefer" default="생산량참조"/>');
				requestBtn.show();
//				refBtn.show();
//			}
//			var whCell = panelResult.getForm().findField('WH_CELL_CODE');
//			if(BsaCodeInfo.gsSumTypeCell=="Y")	{
//				whCell.show();
			}
		},
		onQueryButtonDown: function() {
			var inoutNo = panelResult.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow()
			} else {
				detailStore.loadStoreRecords();
				UniAppManager.setToolbarButtons(['newData'], false);
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/** Detail Grid Default 값 설정
				 */
				var seq = detailStore.max('INOUT_SEQ');
				if(!seq) seq = 1;
				else seq += 1;

				var inoutMeth		= '2';
				var inoutCodeType	= '3';
				var itemStatus		= '1';		//양불 구분
				var inoutCodeType	= '3';
				var inoutTypeDetail	= '11';
				var moneyUnit		= BsaCodeInfo.gsMoneyUnit;


				var inoutDate = '';
				if(!Ext.isEmpty(panelResult.getValue('INOUT_DATE')))	{
					inoutDate = panelResult.getValue('INOUT_DATE');
				} else {
					inoutDate= new Date();
				}

				var inoutNum = '';
				if(!Ext.isEmpty(panelResult.getValue('INOUT_NUM')))	{
					inoutNum = panelResult.getValue('INOUT_NUM');
				}

				var inoutprsn = '';
				if(!Ext.isEmpty(panelResult.getValue('INOUT_PRSN')))	{
					inoutprsn = panelResult.getValue('INOUT_PRSN');
				}

				var whCode = '';
				if(!Ext.isEmpty(panelResult.getValue('WH_CODE')))	{
					whCode = panelResult.getValue('WH_CODE');
				}

				if(BsaCodeInfo.gsSumTypeCell=='Y')	{
					var whCellCode = '';
					if(!Ext.isEmpty(panelResult.getValue('WH_CELL_CODE')))	{
						whCellCode = panelResult.getValue('WH_CELL_CODE');
					}
				}
				//LOT_NO 채번하여 입력
				var lotNo			= fnCreateLotNo(UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE')));
				var r = {
					INOUT_SEQ			: seq,
					INOUT_METH			: inoutMeth,
					INOUT_CODE_TYPE		: inoutCodeType,
					INOUT_DATE			: inoutDate,
					INOUT_NUM			: inoutNum,
					ITEM_STATUS			: itemStatus,
					INOUT_PRSN			: inoutprsn,
					INOUT_CODE_TYPE		: inoutCodeType,
					WH_CODE				: whCode,
					WH_CELL_CODE		: whCellCode,
					INOUT_TYPE_DETAIL	: inoutTypeDetail,
					MONEY_UNIT			: moneyUnit,
					LOT_NO: lotNo
				};

				detailGrid.createRow(r, 'ITEM_CODE', detailGrid.getStore().getCount() - 1);
				panelResult.setAllFieldsReadOnly(true);
			},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitBinding();
			panelResult.getField('WH_CODE').focus();
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('ISSUE_REQ_Q') > 0 || selRow.get('OUTSTOCK_Q') > 0 ) {
					alert('<t:message code="unilite.msg.sMS216" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
				}else {
					detailGrid.deleteSelectedRow();
				}
			}
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
							alert(Msg.sMS042); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
							return false;
						}
						Ext.each(records, function(record,i) {
							if(BsaCodeInfo.gsInoutAutoYN == "N" && record.get('ACCOUNT_Q') > 0) {//동시매출발생이 아닌 경우,매출존재체크 제외
								alert(Msg.sMS335);	//매출이 진행된 건은 수정/삭제할 수 없습니다.
								deletable = false;
								return false;
							}
							if(record.get('SALE_C_YN') == "Y"){
								alert(Msg.sMS214);	//계산서가 마감된 건은 수정/삭제가 불가능합니다.
								deletable = false;
								return false;
							}
						});
						/*---------삭제전 로직 구현 끝----------*/

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
		setDefault: function() {
			panelResult.setValue('INOUT_DATE',new Date());

			if(BsaCodeInfo.gsAutoType=='Y')	{
				panelResult.getField('INOUT_NUM').setReadOnly(true);
			} else {
				panelResult.getField('INOUT_NUM').setReadOnly(true);
			}

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelResult.getValue('INOUT_NUM')))	{
				alert('<t:message code="system.label.sales.receiptno" default="입고번호"/>:<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return panelResult.setAllFieldsReadOnly(true);
		},
		fnGetWkShopDivCode: function(wkShopCode){	//작업장의 사업장 가져오기
			var wkDivCode ='';
			Ext.each(BsaCodeInfo.gsWkShopDivCode, function(item, i)	{
				if(item['S_CODE4'] == wkShopCode) {
					wkDivCode = item['S_CODE2'];
				}
			});
			return wkDivCode;
		}
	});



	//바코드 입력 로직 (lot_no)
	function fnEnterBarcode(newValue) {
		var barcodeItemCode	= newValue.split('|')[0].toUpperCase();
		var barcodeLotNo	= newValue.split('|')[1];
		var barcodeInoutQ	= newValue.split('|')[2];
		var flag = true;

		if(!Ext.isEmpty(barcodeLotNo)) {
			barcodeLotNo = barcodeLotNo.toUpperCase();
		}

		//동일한 LOT_NO 입력되었을 경우 처리
		var records  = detailStore.data.items;		//비교할 records 구성
		Ext.each(records, function(record, i) {
			if(record.get('LOT_NO').toUpperCase() == barcodeLotNo) {
				beep();
				gsText = '<t:message code="system.label.sales.message005" default="동일한  Lot No.(이)가 이미 등록되었습니다."/>'
				openAlertWindow(gsText);
				flag = false;
				return false;
			}
		});

		if(flag) {
			//품질(검사)대상 여부 확인
			var param = {
				ITEM_CODE	: barcodeItemCode
			}
			s_str120ukrv_ypService.getItemInfo(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					if(provider[0].INSPEC_YN == 'Y') {			//품질(검사)대상이 'Y'일 경우, 검사참조 쿼리 실행
						var yParam = {
							ITEM_CODE		: barcodeItemCode,
							LOT_NO			: barcodeLotNo,
							INOUT_Q			: barcodeInoutQ,
							WH_CODE			: panelResult.getValue('WH_CODE'),
							DIV_CODE		: UserInfo.divCode
						}
						s_str120ukrv_ypService.inspecResult(yParam, function(yProvider, yResponse){
							if(!Ext.isEmpty(yProvider)){
								Ext.each(yProvider, function(barcodeInfo, i) {
									barcodeInfo.NOTIN_Q = barcodeInoutQ
									UniAppManager.app.onNewDataButtonDown();
									detailGrid.setRefData(barcodeInfo);
								});
							} else {
								beep();
								gsText = '<t:message code="system.label.sales.message003" default="입력하신 품목 정보가 없습니다."/>';
								openAlertWindow(gsText);
								Ext.getBody().unmask();
								panelResult.getField('BARCODE').focus();
								return false;
							}
						});

					} else {									//품질(검사)대상이 'N'일 경우, 생산실적 참조 쿼리 실행
						var nParam = {
							ITEM_CODE		: barcodeItemCode,
							LOT_NO			: barcodeLotNo,
							INOUT_Q			: barcodeInoutQ,
							WH_CODE			: panelResult.getValue('WH_CODE'),
							DIV_CODE		: UserInfo.divCode
						}
						s_str120ukrv_ypService.selectProdtList(nParam, function(nProvider, nResponse){
							if(!Ext.isEmpty(nProvider)){
								Ext.each(nProvider, function(barcodeInfo, i) {
//									barcodeInfo.NOTIN_Q = barcodeInoutQ
									UniAppManager.app.onNewDataButtonDown();
									detailGrid.setProdtData(barcodeInfo);
								});
							} else {
								beep();
								gsText = '<t:message code="system.label.sales.message003" default="입력하신 품목 정보가 없습니다."/>';
								openAlertWindow(gsText);
								Ext.getBody().unmask();
								panelResult.getField('BARCODE').focus();
								return false;
							}
						});
					}
				}
			});
		}
	}





	//경고창
	var alertSearch = Unilite.createSearchForm('alertSearch', {
		layout	: {type : 'uniTable', columns : 1
		, tdAttrs: {width: '100%', align : 'center', style: 'background-color: #dfe8f6;'}		//cfd9e7
		},
		items	:[{
			xtype	: 'component',
			itemId	: 'TEXT_TEST',
			width	: 330,
			height	: 50,
			html	: '',
			style	: {
				marginTop	: '3px !important',
				font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
            }
		},{
			xtype	: 'container',
			padding	: '0 0 0 0',
			align	: 'center',
			items	: [{
				xtype	: 'button',
				text	: '확인',
				width	: 80,
				handler	: function() {
					alertWindow.hide();
				},
				disabled: false
			}]
		}]
	});
	function openAlertWindow() {
		if(!alertWindow) {
			alertWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="unilite.msg.warnTitle" default="경고"/>',
				width	: 350,
				height	: 120,
				layout	: {type:'vbox', align:'stretch'},
				items	: [alertSearch],
				listeners : {
					beforehide: function(me, eOpt) {
						alertSearch.clearForm();
					},
					beforeclose: function( panel, eOpts ) {
						alertSearch.clearForm();
					},
					beforeshow: function( panel, eOpts ) {
						alertSearch.down('#TEXT_TEST').setHtml(gsText);
					}/*,
					specialkey:function(field, event)	{
						if(event.getKey() == event.ENTER) {
							beep();
						}
					}*/
				}
			})
		}
		alertWindow.center();
		alertWindow.show();
	}



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




	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			//alert(type+ " : " + fieldName+ " : " +newValue+ " : " +oldValue+ " : " +record)
			var rv = true;
			if(record.get('INOUT_METH') == "1"){	//참조해서 온경우
				switch(fieldName) {
					case "INOUT_SEQ" :
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						break;

					case "INOUT_Q" :	//입고량
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						var notinQ = record.get('NOTIN_Q');
						var originQ = record.get('ORIGINAL_Q');
						if(newValue > notinQ + originQ ){
							rv = '<t:message code="unilite.msg.sMS222" default="입고량은 미입고량을 초과할수 없습니다." />'
							break;
						}else{
							var sInvPrice = record.get('BASIS_P');
							record.set('INOUT_FOR_O', sInvPrice * newValue);
							break;
						}
					case "LOT_NO" :	////구현해야함
						break;
				}

			}else{		//예외 - 바로 추가한 경우
				switch(fieldName) {
					case "INOUT_SEQ" :
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						break;

					case "INOUT_Q" :	//입고량
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						var sInvPrice = record.get('BASIS_P');
						record.set('INOUT_FOR_O', sInvPrice * newValue);
						break;


					case "INOUT_CODE" :	//작업장
							var wkDivCode = UniAppManager.app.fnGetWkShopDivCode(newValue);
							record.set('ORG_CD', wkDivCode);
							record.set('TO_DIV_CODE', wkDivCode);
							record.set('DIV_CODE', wkDivCode);	////맞나????
							break;

					case "LOT_NO" :	////구현해야함
						break;

					case "WH_CODE" :
						if(!Ext.isEmpty(newValue)){
							record.set('WH_NAME',e.column.field.getRawValue());
							record.set('WH_CELL_CODE', "");
							record.set('WH_CELL_NAME', "");
							record.set('LOT_NO', "");
						}else{
							record.set('WH_CODE', "");
							record.set('WH_CELL_CODE', "");
							record.set('WH_CELL_NAME', "");
							record.set('LOT_NO', "");
						}
						if(!Ext.isEmpty(record.get('ITEM_CODE'))){
							UniSales.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('DIV_CODE'), record.get('ITEM_STATUS'), record.get('ITEM_CODE'),newValue);

						}
						//그리드 창고cell콤보 reLoad..
//						cbStore.loadStoreRecords(newValue);
						break;

					case "WH_CELL_CODE" :
						record.set('WH_CELL_NAME',e.column.field.getRawValue());
						break;
				}
			}
			return rv;
		}
	}); // validator
}
</script>
