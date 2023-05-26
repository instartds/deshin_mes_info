<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv120ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="biv120ukrv"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020"/>						<!-- 품목계정 -->
	<t:ExtComboStore comboType="OU" storeId="whList"/>						<!-- 창고(사용여부 Y) -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>			<!-- 창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList"/>	<!-- 창고-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store"/>
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">

var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	gsSumTypeLot	: '${gsSumTypeLot}',
	gsSumTypeCell	: '${gsSumTypeCell}'
};
var gsWhCellCode= '';			//20210510 추가: 행 추가 시, panel의 창고에 대한 기본 창고cell값 그리드에 set하기 위해 추가
var sumtypeCell = true;			//20210510 추가: 재고합산유형( 창고 Cell 합산에 따라 컬럼설정)
if(BsaCodeInfo.gsSumTypeCell =='Y') {
	sumtypeCell = false;
}

/*var output ='';
	for(var key in BsaCodeInfo){
 		output += key + '  :  ' + BsaCodeInfo[key] + '\n';
	}
	alert(output);*/

var outDivCode = UserInfo.divCode;

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'biv120ukrvService.selectMaster',
			update	: 'biv120ukrvService.updateDetail',
			create	: 'biv120ukrvService.insertDetail',
			destroy	: 'biv120ukrvService.deleteDetail',
			syncAll	: 'biv120ukrvService.saveAll'
		}
	});

	var panelSearch = Unilite.createSearchPanel('searchForm', {		// 메인
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				child:'WH_CODE',
				value: '01',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},
			Unilite.popup('COUNT_DATE', {
				fieldLabel: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>',
				//fieldStyle: 'text-align: center;',
				allowBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var countDATE = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
							countDATE = countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
							panelSearch.setValue('COUNT_DATE', countDATE);
							panelResult.setValue('COUNT_DATE', panelSearch.getValue('COUNT_DATE'));
							panelSearch.setValue('WH_CODE', records[0]['WH_CODE']);
							panelResult.setValue('WH_CODE', panelSearch.getValue('WH_CODE'));
							panelSearch.setValue('COUNT_DATE2', records[0]['COUNT_CONT_DATE']);
							panelResult.setValue('COUNT_DATE2', panelSearch.getValue('COUNT_DATE2'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('COUNT_DATE', '');
						panelResult.setValue('WH_CODE', '');
						panelResult.setValue('COUNT_DATE2', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						popup.setExtParam({'WH_CODE': panelSearch.getValue('WH_CODE')});
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
				name:'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{ // 20210811 수정: 품목 조회조건 표준화
					fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
//					autoPopup: true,
					validateBlank: false,
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
		   }),{
				fieldLabel: '<t:message code="system.label.inventory.stockcountingapplydate" default="실사반영일"/>',
				name: 'COUNT_DATE2',
				xtype: 'uniDatefield',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('COUNT_DATE2', newValue);
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.inventory.differenceqty" default="차이수량"/></br><t:message code="system.label.inventory.viewyn" default="조회여부"/>',
				items : [{
					boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
					name: 'DIFF_YN',
					inputValue: 'Y',
					width:80,
					checked: true
				}, {
					boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
					name: 'DIFF_YN' ,
					inputValue: 'N',
					width:80
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('DIFF_YN').setValue(newValue.DIFF_YN);
					}
				}
			}]
		},{
			title:'추가정보',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				xtype: 'uniCheckboxgroup',
				padding: '0 0 0 0',
				fieldLabel: ' ',
				id: 'ZERO_CK',
				items: [{
					boxLabel: '<t:message code="system.label.inventory.systemqtyzeroexcept" default="전산수량 0제외"/>',
					width: 120,
					name: 'BOOK_ZERO',
					inputValue: 'Y'
				},{
					boxLabel: '<t:message code="system.label.inventory.stockcountingqtyzeroexcept" default="실사수량 0제외"/>',
					width: 120,
					name: 'CONT_ZERO',
					inputValue: 'Y'
				}]
			},{
				fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1' ,
				xtype: 'uniCombobox' ,
				store: Ext.data.StoreManager.lookup('itemLeve1Store') ,
				child: 'ITEM_LEVEL2'
			},{
				fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2' ,
				xtype: 'uniCombobox' ,
				store: Ext.data.StoreManager.lookup('itemLeve2Store') ,
				child: 'ITEM_LEVEL3'
			},{
				fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3' ,
				xtype: 'uniCombobox' ,
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
				levelType:'ITEM'
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
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				value: '01',
				child:'WH_CODE',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WH_CODE', newValue);
						//20210510 추가: 창고변경 시, 창고에 설정되어 있는 기본창고cell 가져오는 로직 추가
						var param = {
							DIV_CODE: panelResult.getValue('DIV_CODE'),
							WH_CODE	: newValue
						}
						stockCommonService.getWhCellCode(param, function(provider, response) {
							if(!Ext.isEmpty(provider)) {
								gsWhCellCode = provider;
							}
						})
					}
				}
			},
			Unilite.popup('COUNT_DATE', {
				fieldLabel: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>',
				colspan: 2,
				//fieldStyle: 'text-align: center;',
				allowBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var countDATE = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
							countDATE = countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
							panelResult.setValue('COUNT_DATE', countDATE);
							panelSearch.setValue('COUNT_DATE', panelResult.getValue('COUNT_DATE'));
							panelResult.setValue('WH_CODE', records[0]['WH_CODE']);
							panelSearch.setValue('WH_CODE', panelResult.getValue('WH_CODE'));
							panelResult.setValue('COUNT_DATE2', records[0]['COUNT_CONT_DATE']);
							panelSearch.setValue('COUNT_DATE2', panelResult.getValue('COUNT_DATE2'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('COUNT_DATE', '');
						panelSearch.setValue('WH_CODE', '');
						panelSearch.setValue('COUNT_DATE2', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						popup.setExtParam({'WH_CODE': panelResult.getValue('WH_CODE')});
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
				name:'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{ // 20210811 수정: 품목 조회조건 표준화
					fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					validateBlank: false,
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {						
							panelSearch.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
		   }),{
				fieldLabel: '<t:message code="system.label.inventory.stockcountingapplydate" default="실사반영일"/>',
				name: 'COUNT_DATE2',
				xtype: 'uniDatefield',
				readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('COUNT_DATE2', newValue);
						}
					}
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.inventory.differenceqty" default="차이수량"/></br><t:message code="system.label.inventory.viewyn" default="조회여부"/>',
				items : [{
					boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
					name: 'DIFF_YN',
					inputValue: 'Y',
					width:80,
					checked: true
				}, {
					boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
					name: 'DIFF_YN' ,
					inputValue: 'N',
					width:80
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('DIFF_YN').setValue(newValue.DIFF_YN);
					}
				}
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
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});



	Unilite.defineModel('Biv120ukrvModel', {		// 메인
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>'						, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.inventory.division" default="사업장"/>'							, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'							, type: 'string'},
			{name: 'COUNT_DATE'			, text: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>'				, type: 'uniDate'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>'						, type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'ITEM_LEVEL1'		, text: '<t:message code="system.label.inventory.large" default="대"/>'								, type: 'string'},
			{name: 'ITEM_LEVEL2'		, text: '<t:message code="system.label.inventory.middle" default="중"/>'								, type: 'string'},
			{name: 'ITEM_LEVEL3'		, text: '<t:message code="system.label.inventory.small" default="소"/>'								, type: 'string'},
			{name: 'ITEM_LEVEL_NAME1'	, text: '<t:message code="system.label.inventory.large" default="대"/>'								, type: 'string'},
			{name: 'ITEM_LEVEL_NAME2'	, text: '<t:message code="system.label.inventory.middle" default="중"/>'								, type: 'string'},
			{name: 'ITEM_LEVEL_NAME3'	, text: '<t:message code="system.label.inventory.small" default="소"/>'								, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.inventory.item" default="품목"/>'								, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'							, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.inventory.spec" default="규격"/>'								, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'					, type: 'string', displayField: 'value'},
			{name: 'UNIT_WGT'			, text: '<t:message code="system.label.inventory.unitweight" default="단위중량"/>'						, type: 'string'},
			{name: 'WGT_UNIT'			, text: '<t:message code="system.label.inventory.weightunit" default="중량단위"/>'						, type: 'string'},
			{name: 'WH_CELL_CODE'		, text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'					, type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList')},	//20210510 수정: 콤보로 변경
			{name: 'WH_CELL_NAME'		, text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'					, type: 'string'},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'							, type: 'string'},
			{name: 'GOOD_STOCK_BOOK_Q'	, text: '<t:message code="system.label.inventory.good" default="양품"/>'								, type: 'uniQty'},
			{name: 'BAD_STOCK_BOOK_Q'	, text: '<t:message code="system.label.inventory.defect" default="불량"/>'							, type: 'uniQty'},
			{name: 'GOOD_STOCK_BOOK_W'	, text: '<t:message code="system.label.inventory.good" default="양품"/>'								, type: 'string'},
			{name: 'BAD_STOCK_BOOK_W'	, text: '<t:message code="system.label.inventory.defect" default="불량"/>'							, type: 'string'},
			{name: 'GOOD_STOCK_Q'		, text: '<t:message code="system.label.inventory.good" default="양품"/>'								, type: 'uniQty'/*, allowBlank: false*/},
			{name: 'BAD_STOCK_Q'		, text: '<t:message code="system.label.inventory.defect" default="불량"/>'							, type: 'uniQty'},
			{name: 'GOOD_STOCK_W'		, text: '<t:message code="system.label.inventory.good" default="양품"/>'								, type: 'string'},
			{name: 'BAD_STOCK_W'		, text: '<t:message code="system.label.inventory.defect" default="불량"/>'							, type: 'string'},
			{name: 'COUNT_FLAG'			, text: '<t:message code="system.label.inventory.processstatus" default="진행상태"/>'					, type: 'string'},
			{name: 'COUNT_CONT_DATE'	, text: '<t:message code="system.label.inventory.applyyearmonth" default="반영년월"/>'					, type: 'uniDate'},
			{name: 'OVER_GOOD_STOCK_Q'	, text: '<t:message code="system.label.inventory.good" default="양품"/>'								, type: 'uniQty'},
			{name: 'OVER_BAD_STOCK_Q'	, text: '<t:message code="system.label.inventory.defect" default="불량"/>'							, type: 'uniQty'},
			{name: 'REMARK'				, text: '<t:message code="system.label.inventory.remarks" default="비고"/>'							, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: '<t:message code="system.label.inventory.writer" default="작성자"/>'							, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '<t:message code="system.label.inventory.writtentiem" default="작성시간"/>'						, type: 'uniDate'},
			{name: 'GOOD_STOCK_BOOK_I'	, text: '<t:message code="system.label.inventory.systeminventoryamount" default="전산재고금액"/>'			, type: 'uniPrice'},
			{name: 'GOOD_STOCK_I'		, text: '<t:message code="system.label.inventory.stockcountinginventoryamount" default="실사재고금액"/>'	, type: 'uniPrice'}
		]
	});//End of Unilite.defineModel('Biv120ukrvModel', {

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('biv120ukrvMasterStore1',{		// 메인
		model	: 'Biv120ukrvModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			/*var cOUNTdATE = panelSearch.getValue('COUNT_DATE').replace('.','');
			param.COUNT_DATE = cOUNTdATE;	*/
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records[0])){
					if(records[0].get('REF_CODE1') == 'Y'){
						masterGrid.getColumn("WH_CELL_CODE").setHidden(false);
//						masterGrid.getColumn("WH_CELL_NAME").setHidden(false);		//20210510 주석: name만 사용
					}else{
						masterGrid.getColumn("WH_CELL_CODE").setHidden(true);
//						masterGrid.getColumn("WH_CELL_NAME").setHidden(true);		//20210510 주석: name만 사용
					}
				}
			}
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			/*var orderNum = panelSearch.getValue('ORDER_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['ORDER_NUM'] != orderNum) {
					record.set('ORDER_NUM', orderNum);
				}
			})*/
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						/*var master = batch.operations[0].getResultSet();
						panelSearch.setValue("ORDER_NUM", master.ORDER_NUM);*/
						//3.기타 처리
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('biv120ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('biv120ukrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer	: false,
			useContextMenu	: true
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'COMP_CODE'						, width:66	, hidden: true},
			{dataIndex: 'DIV_CODE'						, width:80	, hidden: true},
			{dataIndex: 'WH_CODE'						, width:80	, hidden: true},
			{dataIndex: 'COUNT_DATE'					, width:80	, hidden: true},
			{dataIndex: 'ITEM_ACCOUNT'					, width:120},
			{text: '<t:message code="system.label.inventory.itemgroup" default="품목분류"/>',
				columns:[
					{dataIndex: 'ITEM_LEVEL1'			, width:100 },
					{dataIndex: 'ITEM_LEVEL2'			, width:100 },
					{dataIndex: 'ITEM_LEVEL3'			, width:100 },
					{dataIndex: 'ITEM_LEVEL_NAME1'		, width:100, hidden: true},
					{dataIndex: 'ITEM_LEVEL_NAME2'		, width:100, hidden: true},
					{dataIndex: 'ITEM_LEVEL_NAME3'		, width:100, hidden: true}
				]
			},
			{dataIndex: 'ITEM_CODE'						, width:110,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					extParam		: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup		: true,
					listeners		: {
						'onSelected': {
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
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'						, width:160,
				editor: Unilite.popup('DIV_PUMOK_G', {
					extParam	: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
					autoPopup	: true,
					listeners	: {
						'onSelected': {
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
						}
					}
				})
			},
			{dataIndex: 'SPEC'							, width:150 },
			{dataIndex: 'STOCK_UNIT'					, width:100	, displayField: 'value'},
			{dataIndex: 'UNIT_WGT'						, width:100	, hidden: true},
			{dataIndex: 'WGT_UNIT'						, width:80	, hidden: true},
			{dataIndex: 'WH_CELL_CODE'					, width:100	, hidden: true	, align: 'center',
				//20210510 추가
				listeners:{
					render:function(elm) {
						elm.editor.on(
							'beforequery',function(queryPlan, eOpts) {
								var store	= queryPlan.combo.store;
								var record	= masterGrid.uniOpt.currentRecord;
								store.clearFilter();
								store.filterBy(function(item){
									return item.get('option') == panelResult.getValue('WH_CODE');
								})
							}
						)
					}
				},
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filterBy(function(item){
						return item.get('option') == panelResult.getValue('WH_CODE');
					})
				}
			},
			{dataIndex: 'WH_CELL_NAME'					, width:80	, hidden: true},
			{dataIndex: 'LOT_NO'						, width:120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, Ext.String.format('{0} ', value), '<t:message code="system.label.inventory.total" default="총계"/>');
				}
			},
			{text:'<t:message code="system.label.inventory.systemqty" default="전산수량"/>',
				columns:[
					{dataIndex: 'GOOD_STOCK_BOOK_Q'		, width:100, summaryType: 'sum'},
					{dataIndex: 'BAD_STOCK_BOOK_Q'		, width:100,hidden: true}
				]
			},
			{dataIndex: 'GOOD_STOCK_BOOK_I'				, width:120	, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_BOOK_W'				, width:80	, hidden: true},
			{dataIndex: 'BAD_STOCK_BOOK_W'				, width:80	, hidden: true},
			{text:'<t:message code="system.label.inventory.stockcountingqty" default="실사수량"/>',
				columns:[
					{dataIndex: 'GOOD_STOCK_Q'			, width:100, summaryType: 'sum'},
					{dataIndex: 'BAD_STOCK_Q'			, width:100,hidden: true}
				]
			},
			{dataIndex: 'GOOD_STOCK_I'					, width:120	, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_W'					, width:80	, hidden: true},
			{dataIndex: 'BAD_STOCK_W'					, width:80	, hidden: true},
			{dataIndex: 'COUNT_FLAG'					, width:80	, hidden: true},
			{dataIndex: 'COUNT_CONT_DATE'				, width:80	, hidden: true},
			{text:'<t:message code="system.label.inventory.shortage" default="과부족"/>',
				columns:[
					{dataIndex: 'OVER_GOOD_STOCK_Q'		, width:100, summaryType: 'sum'},
					{dataIndex: 'OVER_BAD_STOCK_Q'		, width:100, summaryType: 'sum'}
				]
			},
			{dataIndex: 'REMARK'						, width:200 },
			{dataIndex: 'UPDATE_DB_USER'				, width:80	, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'				, width:80	, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
					if(UniUtils.indexOf(e.field, ['GOOD_STOCK_Q', 'BAD_STOCK_Q', 'REMARK'])) {
						return true;
					} else {
						return false;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'GOOD_STOCK_Q', 'BAD_STOCK_Q', 'REMARK','LOT_NO'])) {
						return true;
					} else {
						if(BsaCodeInfo.gsSumTypeCell == 'Y' && UniUtils.indexOf(e.field, ['WH_CELL_CODE'])) {			///20210510 추가: cell관리일 경우, 신규행은 창고cell 수정 가능하도록 로직 추가
							return true;
						}
						return false;
					}
				}
			}
		},
		////품목정보 팝업에서 선택된 데이타가 그리드에 추가되는 함수, 품목팝업의 onSelected/onClear 이벤트가 일어날때 호출됨
		setItemData: function(record, dataClear, grdRecord) {
			//var grdRecord = this.getSelectedRecord();
			if(dataClear) {
				grdRecord.set('ITEM_ACCOUNT'			, '');
				grdRecord.set('ITEM_LEVEL1'				, '');
				grdRecord.set('ITEM_LEVEL2'				, '');
				grdRecord.set('ITEM_LEVEL3'				, '');
				grdRecord.set('ITEM_CODE'				, '');
				grdRecord.set('ITEM_NAME'				, '');
				grdRecord.set('SPEC'					, '');
				grdRecord.set('STOCK_UNIT'				, '');
				grdRecord.set('GOOD_STOCK_BOOK_Q'		, 0);
				grdRecord.set('BAD_STOCK_BOOK_Q'		, 0);
				grdRecord.set('GOOD_STOCK_Q'			, 0);
				grdRecord.set('BAD_STOCK_Q'				, 0);
				grdRecord.set('REMARK'					, '');
			} else {
				grdRecord.set('ITEM_ACCOUNT'			, record['ITEM_ACCOUNT']);
				grdRecord.set('ITEM_LEVEL1'				, record['ITEM_LEVEL_NAME1']);
				grdRecord.set('ITEM_LEVEL2'				, record['ITEM_LEVEL_NAME2']);
				grdRecord.set('ITEM_LEVEL3'				, record['ITEM_LEVEL_NAME3']);
				grdRecord.set('ITEM_CODE'				, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'				, record['ITEM_NAME']);
				grdRecord.set('SPEC'					, record['SPEC']);
				grdRecord.set('STOCK_UNIT'				, record['STOCK_UNIT']);
				grdRecord.set('GOOD_STOCK_BOOK_Q'		, record['GOOD_STOCK_BOOK_']);
				grdRecord.set('BAD_STOCK_BOOK_Q'		, record['BAD_STOCK_BOOK_Q']);
				grdRecord.set('GOOD_STOCK_Q'			, record['GOOD_STOCK_Q']);
				grdRecord.set('BAD_STOCK_Q'				, record['BAD_STOCK_Q']);
				grdRecord.set('REMARK'					, record['REMARK']);
				//UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('WH_CODE'));
			}
		}
	});



	Unilite.Main({
		id			: 'biv120ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			UniAppManager.setToolbarButtons('newData', false);
			this.setDefault();
		},
		onQueryButtonDown: function() {		// 조회버튼 눌렀을떄
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore1.loadStoreRecords();
			UniAppManager.setToolbarButtons('newData', true);
		},
		setDefault: function() {		// 기본값
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		},
		onResetButtonDown: function() {		// 초기화
			gsWhCellCode = '';				//20210510 추가
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.reset();
			this.fnInitBinding();
			panelSearch.getField('WH_CODE').focus();
			panelResult.getField('WH_CODE').focus();
			directMasterStore1.clearData();
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore1.saveStore();
		},
		rejectSave: function() {	// 저장
			var rowIndex = masterGrid.getSelectedRowIndex();
			masterGrid.select(rowIndex);
			directMasterStore1.rejectChanges();

			if(rowIndex >= 0){
				masterGrid.getSelectionModel().select(rowIndex);
				var selected		= masterGrid.getSelectedRecord();
				var selected_doc_no	= selected.data['DOC_NO'];
				bdc100ukrvService.getFileList({DOC_NO: selected_doc_no}, function(provider, response) {
				});
			}
			directMasterStore1.onStoreActionEnable();
		},
		confirmSaveData: function(config)	{	// 저장하기전 원복 시키는 작업
			var fp = Ext.getCmp('biv120ukrvFileUploadPanel');
			if(masterStore.isDirty() || fp.isDirty()) {
				if(confirm('<t:message code="system.message.inventory.message015" default="변경된 내용을 저장하시겠습니까?"/>'))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			var selRow1 = masterGrid.getSelectedRecord();
			if(selRow1.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.inventory.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
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
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
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
							masterGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
						isNewData = false;
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		onNewDataButtonDown: function()	{				// 행추가
			var compCode	= UserInfo.compCode;
			var divCode		= panelSearch.getValue('DIV_CODE');
			var whCode		= panelSearch.getValue('WH_CODE');
			var whCellCode	= BsaCodeInfo.gsSumTypeCell == 'Y' ? gsWhCellCode : '';				//20210510 수정: panelSearch.getValue('WH_CELL_CODE'); -> gsWhCellCode
			var countDate	= panelSearch.getValue('COUNT_DATE');

			var r = {
				COMP_CODE	: compCode,
				DIV_CODE	: divCode,
				WH_CODE		: whCode,
				WH_CELL_CODE: whCellCode,				//20210510 추가
				COUNT_DATE	: countDate
			};
			masterGrid.createRow(r);
			panelSearch.setAllFieldsReadOnly(true);
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		}
	});

	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			switch(fieldName) {
				case "GOOD_STOCK_Q" :
					if(newValue < 0) {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
					}else{
						record.set('OVER_GOOD_STOCK_Q', (record.get('GOOD_STOCK_BOOK_Q')  - newValue) * -1 );
					}
					break;

				case "BAD_STOCK_Q" :
					if(newValue < 0) {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
					}else{
						record.set('OVER_BAD_STOCK_Q', (record.get('BAD_STOCK_BOOK_Q')  - newValue) * -1 );
					}
					break;

				case "GOOD_STOCK_W" :
					if(newValue < 0) {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
					}
					break;

				case "BAD_STOCK_W" :
					if(newValue < 0) {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
					}
					break;
			}
			return rv;
		}
	});
};
</script>