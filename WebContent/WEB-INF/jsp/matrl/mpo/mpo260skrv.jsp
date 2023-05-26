<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo260skrv">
	<t:ExtComboStore comboType="BOR120" pgmId="mpo260skrv"/>				<!-- 사업장 -->
</t:appConfig>

<style type="text/css">
.x-change-cell {
	background-color: #FFFFC6;
}

.x-change-cell2 {
	text-align: center;
}
</style>

<script type="text/javascript" >

function appMain() {
	var labelPrintWindow;//라벨출력
	var gsSelRecord;
	var BsaCodeInfo = {
		gsSiteCode : '${gsSiteCode}'
	};
	var labelPrintHiddenYn = true;
	if(BsaCodeInfo.gsSiteCode == 'SHIN'){
		labelPrintHiddenYn = false;
	}

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title		: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.purchase.issuedate2" default="납품일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'ISSUE_DATE_FR',
				endFieldName	: 'ISSUE_DATE_TO',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('ISSUE_DATE_FR', newValue);
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('ISSUE_DATE_TO', newValue);
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.purchase.partners" default="협력사"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				allowBlank		: true,
//				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE', newValue);
						if(Ext.isEmpty(newValue)) {
							panelSearch.setValue('CUSTOM_NAME', newValue);
							panelResult.setValue('CUSTOM_NAME', newValue);
						}
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);
					},
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
					}
				}
			}),{
				xtype		: 'uniTextfield',
				fieldLabel	: '<t:message code="system.label.purchase.issuenum" default="납품번호"/>',
				name		: 'ISSUE_NUM',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ISSUE_NUM', newValue);
					}
				}
			},{
				xtype		: 'uniTextfield',
				fieldLabel	: '발주번호',
				name		: 'ORDER_NUM',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_NUM', newValue);
					}
				}
			},{
				xtype	: 'button',
				text	: '<t:message code="system.label.sales.specificationprint" default="거래명세서출력"/>',
				itemId	: 'printButton',
				margin	: '0 0 0 120',
				handler	: function() {
					if(Ext.isEmpty(detailGrid.getSelectedRecord())) {
						Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
						return false;
					}
					var param	= panelSearch.getValues();
					param.GUBUN	= BsaCodeInfo.gsSiteCode;
					var win = Ext.create('widget.ClipReport', {
						url		: CPATH+'/vmi/vmi210clukrv.do',
						prgID	: 'mpo260skrv',
						extParam: param
					});
					win.center();
					win.show();
				}
			},{
				xtype		: 'uniTextfield',
				fieldLabel	: 'ISSUE_NUMS',
				name		: 'ISSUE_NUMS',
				hidden		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			readOnly	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.purchase.issuedate2" default="납품일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ISSUE_DATE_FR',
			endFieldName	: 'ISSUE_DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('ISSUE_DATE_FR', newValue);
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('ISSUE_DATE_TO', newValue);
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.partners" default="협력사"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			allowBlank		: true,
//			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('CUSTOM_NAME', newValue);
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);
				},
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			xtype		: 'uniTextfield',
			fieldLabel	: '<t:message code="system.label.purchase.issuenum" default="납품번호"/>',
			name		: 'ISSUE_NUM',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ISSUE_NUM', newValue);
				}
			}
		},{
			xtype		: 'uniTextfield',
			fieldLabel	: '발주번호',
			name		: 'ORDER_NUM',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_NUM', newValue);
				}
			}
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.sales.specificationprint" default="거래명세서출력"/>',
			itemId	: 'printButton',
			margin	: '0 0 0 95',
			handler	: function() {
				if(Ext.isEmpty(detailGrid.getSelectedRecord())) {
					Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
					return false;
				}
				var param = panelSearch.getValues();
				param.GUBUN= BsaCodeInfo.gsSiteCode;
				var win = Ext.create('widget.ClipReport', {
					url		: CPATH+'/vmi/vmi210clukrv.do',
					prgID	: 'mpo260skrv',
					extParam: param
				});
				win.center();
				win.show();
			}
		}]
	});



	Unilite.defineModel('mpo260skrvModel', {
		fields: [
			{name: 'DIV_CODE'		,text: 'DIV_CODE'																,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: 'CUSTOM_CODE'															,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.purchase.partners" default="협력사"/>'		,type: 'string'},
			{name: 'ISSUE_NUM'		,text: '<t:message code="system.label.purchase.issuenum" default="납품번호"/>'		,type: 'string'},
			{name: 'ISSUE_SEQ'		,text: '<t:message code="system.label.purchase.seq" default="순번"/>'				,type: 'int'},
			{name: 'ORDER_NUM'		,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'			,type: 'string'},
			{name: 'ORDER_SEQ'		,text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'			,type: 'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.purchase.item" default="품목"/>'			,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'		,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.purchase.spec" default="규격"/>'			,type: 'string'},
			{name: 'ORDER_UNIT'		,text: '<t:message code="system.label.purchase.unit" default="단위"/>'			,type: 'string'},
			{name: 'ORDER_DATE'		,text: '<t:message code="system.label.purchase.podate" default="발주일"/>'			,type: 'uniDate'},
			{name: 'DVRY_DATE'		,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'	,type: 'uniDate'},
			{name: 'DVRY_ESTI_DATE'	,text: '<t:message code="system.label.purchase.dvryestidate" default="납품예정일"/>'	,type: 'uniDate'},
			{name: 'TOTAL_ISSUE_Q'	,text: '납품예정량'		                                                            ,type: 'uniQty'},
			{name: 'ORDER_Q'		,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'			,type: 'uniQty'},
			{name: 'UN_Q'			,text: '<t:message code="system.label.purchase.undeliveryqty" default="미납량"/>'	,type: 'uniQty'},
			{name: 'ORDER_P'        ,text: '납품단가'                                                                  ,type: 'uniUnitPrice'},
			{name: 'PACK_UNIT_Q'	,text: '<t:message code="system.label.sales.packunitq" default="BOX입수"/>'		,type: 'uniQty'},
			{name: 'BOX_Q'			,text: '<t:message code="system.label.sales.boxq" default="BOX수"/>'				,type: 'uniQty'},
			{name: 'EACH_Q'			,text: '<t:message code="system.label.sales.eachq" default="낱개"/>'				,type: 'uniQty'},
			{name: 'LOSS_Q'			,text: '<t:message code="system.label.sales.lossq" default="LOSS여분"/>'			,type: 'uniQty'},
			{name: 'ISSUE_Q'		,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>'			,type: 'uniQty'},
			{name: 'ISSUE_DATE'		,text: 'ISSUE_DATE'																,type: 'uniDate'},
			{name: 'SO_NUM'			,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'			,type: 'string'},
			{name: 'SO_SEQ'			,text: '<t:message code="system.label.purchase.soseq" default="수주순번"/>'			,type: 'int'},
			{name: 'SOF_CUSTOM_NAME',text: '수주처'		,type:'string'},
			{name: 'SOF_ITEM_NAME'	,text: '수주품명'		,type:'string'},
			{name: 'ISSUE_DATE'		,text: '<t:message code="system.label.purchase.issuedate2" default="납품일"/>'		,type:'uniDate'},
			{name: 'DVRY_TIME'		,text: '<t:message code="system.label.purchase.deliverytime4" default="납품시간"/>'	, type:'uniTime' , format:'Hi'}

		]
	});

	var detailStore = Unilite.createStore('mpo260skrvDetailStore',{
		model	: 'mpo260skrvModel',
		proxy	: {
			type: 'direct',
			api	: {
				read: 'mpo260skrvService.selectList'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			allDeletable: false,	// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= panelResult.getValues();
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(store.getCount() > 0){
					panelSearch.down('#printButton').setDisabled(false);
					panelResult.down('#printButton').setDisabled(false);
				} else {
					panelSearch.down('#printButton').setDisabled(true);
					panelResult.down('#printButton').setDisabled(true);
				}
			}
		}
	});

	var detailGrid = Unilite.createGrid('mpo260skrvGrid', {
		store	: detailStore,
		region	: 'center',
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var detailData	= detailStore.data.items;
					//한번에 하나의 납품번호만 선택되도록 변경
//					var needSelect	= grid.selected.items;
					var needSelect	= [];
					var issueNums	= panelSearch.getValue('ISSUE_NUMS');

					Ext.each(detailData, function(detailDatum,i) {
						if(detailDatum.get('ISSUE_NUM') == selectRecord.get('ISSUE_NUM')) {
							needSelect.push(detailDatum);
						}
					});
					detailGrid.getSelectionModel().select(needSelect);

					//출력을 위해 납품번호 set
//					//한번에 하나의 납품번호만 선택되도록 변경
//					if(Ext.isEmpty(issueNums) && !Ext.isEmpty(selectRecord.get('ISSUE_NUM'))) {
						issueNums = selectRecord.get('ISSUE_NUM');
//					} else if(!Ext.isEmpty(selectRecord.get('ISSUE_NUM'))) {
//						issueNums = issueNums + ',' + selectRecord.get('ISSUE_NUM');
//					}
					panelSearch.setValue('ISSUE_NUMS', issueNums);
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var detailData	= detailStore.data.items;
					var needDeSelect= [];
					var issueNums	= panelSearch.getValue('ISSUE_NUMS');

					Ext.each(detailData, function(detailDatum,i) {
						if(detailDatum.get('ISSUE_NUM') == selectRecord.get('ISSUE_NUM')) {
							needDeSelect.push(detailDatum);
						}
					});
					detailGrid.getSelectionModel().deselect(needDeSelect);

					//출력을 위해 납품번호 set
					var deletedNum0	= selectRecord.get('ISSUE_NUM') + ',';
					var deletedNum1	= ',' + selectRecord.get('ISSUE_NUM');
					var deletedNum2	= selectRecord.get('ISSUE_NUM');
					//20200117로직 수정
					if(deletedNum0 != ',') {
						issueNums = issueNums.split(deletedNum0).join("");
					}
					if(deletedNum1 != ',') {
						issueNums = issueNums.split(deletedNum1).join("");
					}
					issueNums = issueNums.split(deletedNum2).join("");
					panelSearch.setValue('ISSUE_NUMS', issueNums);
				}
			}
		}),
		uniOpt	: {
			expandLastColumn	: true,
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
				useState	: true,
				useStateList: true
			}
		},
		columns: [
			{ dataIndex: 'ISSUE_NUM'		, width: 110	, align:'center',tdCls:'x-change-cell'},
			{ dataIndex: 'ISSUE_SEQ'		, width: 60		, align:'center',tdCls:'x-change-cell'},
			{ dataIndex: 'SO_NUM'			, width: 100	, hidden: false},
			{ dataIndex: 'SO_SEQ'			, width: 80		, hidden: true},
			{ dataIndex: 'SOF_CUSTOM_NAME'	, width: 150	, hidden: false},
			{ dataIndex: 'SOF_ITEM_NAME'	, width: 200	, hidden: false},
			{ dataIndex: 'CUSTOM_NAME'		, width: 200	, hidden: false},
			{ dataIndex: 'ISSUE_DATE'		, width: 90 },
			{ dataIndex: 'DVRY_TIME'		, width: 90 , tdCls:'x-change-cell2'},
			{ dataIndex: 'ORDER_NUM'		, width: 120},
			{ dataIndex: 'ORDER_SEQ'		, width: 80		, align:'center'},
			{ dataIndex: 'ITEM_CODE'		, width: 120},
			{ dataIndex: 'ITEM_NAME'		, width: 250},
			{ dataIndex: 'SPEC'				, width: 120},
			{ dataIndex: 'ORDER_UNIT'		, width: 60		, align:'center'},
			{ dataIndex: 'ORDER_DATE'		, width: 90},
			{ dataIndex: 'DVRY_DATE'		, width: 90},
			{ dataIndex: 'DVRY_ESTI_DATE'	, width: 90},
			{ dataIndex: 'TOTAL_ISSUE_Q'	, width: 100},
			{ dataIndex: 'ORDER_Q'			, width: 100},
			{ dataIndex: 'UN_Q'				, width: 100},
			{ dataIndex: 'ORDER_P'          , width: 100},
			{ dataIndex: 'PACK_UNIT_Q'		, width: 100	, tdCls:'x-change-cell'},
			{ dataIndex: 'BOX_Q'			, width: 100	, tdCls:'x-change-cell'},
			{ dataIndex: 'EACH_Q'			, width: 100	, tdCls:'x-change-cell'},
			{ dataIndex: 'LOSS_Q'			, width: 100	, tdCls:'x-change-cell'},
			{ dataIndex: 'ISSUE_Q'			, width: 100	, tdCls:'x-change-cell'},
			{
				text	: '<t:message code="system.label.purchase.label" default="라벨"/>',
				xtype	: 'widgetcolumn',
				hidden	: labelPrintHiddenYn,
				width	: 120,
				widget	: {
					xtype		: 'button',
					text		: '<t:message code="system.label.purchase.labelprint" default="라벨출력"/>',
					listeners	: {
						buffer	: 1,
						click	: function(button, event, eOpts) {
							gsSelRecord = event.record.data;
							openLabelPrintWindow(gsSelRecord);
						}
					}
				}
			}
		],
		listeners: {
		}
	});



	/***************************
	 *라벨 출력 코드
	 *2019-12-09
	 ***************************/
	var labelPrintSearch = Unilite.createSearchForm('labelPrintForm', {
		//layout		: {type:'vbox', align:'center', pack: 'center' },
		layout	: {type : 'uniTable', columns : 1},
		border:true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.oemitemcode" default="품번"/>',
			name		: 'LABEL_ITEM_CODE',
			xtype		: 'uniTextfield',
			margin 	: '0 0 0 0',
			hidden		: false,
			readOnly	: true,
			fieldStyle: 'text-align: center;',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel: '입고일',
				xtype: 'uniDatefield',
				name: 'DVRY_ESTI_DATE',
				value:UniDate.get('today'),
	//			fieldStyle: 'text-align: center;background-color: yellow; background-image: none;',
				readOnly : false,
				allowBlank:false
		},{
			fieldLabel: 'ORDER_NUM',
			xtype: 'uniTextfield',
			name: 'ORDER_NUM',
			hidden: true,
			readOnly : false,
			allowBlank:false
		},{
			fieldLabel: 'ORDER_SEQ',
			xtype: 'uniNumberfield',
			name: 'ORDER_SEQ',
			hidden: true,
			readOnly : false,
			allowBlank:false
		},{
			fieldLabel	: '<t:message code="system.label.sales.packunitq" default="BOX입수"/>',
			xtype		: 'uniNumberfield',
			name		: 'PACK_UNIT_Q',
			value		: 1,
			allowBlank	: true,
			hidden	: false,
			fieldStyle: 'text-align: center;'
			//holdable	: 'hold'
		},{
			fieldLabel	: '<t:message code="system.label.sales.boxq" default="BOX수"/>',
			xtype		: 'uniNumberfield',
			name		: 'BOX_Q',
			value		: 1,
			allowBlank	: true,
			hidden	: false,
			fieldStyle: 'text-align: center;'
			//holdable	: 'hold'
		},{
			fieldLabel	: '<t:message code="system.label.sales.eachq" default="낱개"/>',
			xtype		: 'uniNumberfield',
			name		: 'EACH_Q',
			value		: 1,
			allowBlank	: true,
			hidden	: false,
			fieldStyle: 'text-align: center;'
			//holdable	: 'hold'
		},{
			fieldLabel	: '<t:message code="system.label.product.qty" default="수량"/>',
			xtype		: 'uniNumberfield',
			name		: 'ISSUE_QTY',
			value		: 1,
			allowBlank	: true,
			hidden	: false,
			fieldStyle: 'text-align: center;'
			//holdable	: 'hold'
		},{
			fieldLabel	: '<t:message code="system.label.purchase.printqty" default="출력매수"/>',
			xtype		: 'uniNumberfield',
			name		: 'LABEL_QTY',
			margin 	: '0 0 0 0',
			value		: 1,
			allowBlank	: true,
			hidden	: false,
			fieldStyle: 'text-align: center;'
			//holdable	: 'hold'
		}, {
			xtype: 'radiogroup',
			fieldLabel: '구분',
			id: 'PRINT_GUBUN',
			items: [{
				boxLabel: '라벨',
				width: 70,
				name: 'PRINT_GUBUN',
				inputValue: 'A',
				checked: true
			}, {
				boxLabel: 'A4',
				width: 70,
				inputValue: 'B',
				name: 'PRINT_GUBUN'
			}]
		},{	xtype		: 'container',
			defaultType	: 'uniTextfield',
			margin		: '0 0 0 60',
			layout		: {type : 'uniTable', columns : 2,align:'center', pack: 'center'},
			items		: [{
				xtype	: 'button',
				name	: 'labelPrint',
				text	: '<t:message code="system.label.product.labelprint" default="라벨출력"/>',
				width	: 80,
				hidden	: false,
				handler : function() {
					var param			= panelSearch.getValues();
					param["ISSUE_NUM"]	= gsSelRecord.ISSUE_NUM;
					param["ORDER_NUM"]	= labelPrintSearch.getValue('ORDER_NUM');
					param["ORDER_SEQ"]	= labelPrintSearch.getValue('ORDER_SEQ');
					param["PRINT_CNT"]	= labelPrintSearch.getValue('LABEL_QTY');
					if(labelPrintSearch.getValue('BOX_Q') > 0){//박스 입수, 수량을 사용했을 경우
						param["ISSUE_QTY"]= labelPrintSearch.getValue('PACK_UNIT_Q');
						if(labelPrintSearch.getValue('EACH_Q') == 0){
							param["LAST_QTY"]= labelPrintSearch.getValue('PACK_UNIT_Q');
						} else {
							param["LAST_QTY"]= labelPrintSearch.getValue('EACH_Q');
						}
					} else {
						param["ISSUE_QTY"]= labelPrintSearch.getValue('ISSUE_QTY');
						param["LAST_QTY"]= labelPrintSearch.getValue('ISSUE_QTY');
					}
					param["DVRY_ESTI_DATE"]			= UniDate.getDbDateStr(labelPrintSearch.getValue('DVRY_ESTI_DATE'));
					param["PRINT_GUBUN"]			= labelPrintSearch.getValue('PRINT_GUBUN').PRINT_GUBUN;
					param["sTxtValue2_fileTitle"]	= '라벨 출력';
					param["RPT_ID"]					= 'vmi210clukrv';
					param["PGM_ID"]					= 'vmi210ukrv';
					param["MAIN_CODE"]				= 'M030';
					if(BsaCodeInfo.gsSiteCode == 'SHIN'){
						param.GUBUN='SHIN';
					} else {
						param.GUBUN='STANDARD';
					}
					var win  = Ext.create('widget.ClipReport', {
						url		: CPATH+'/vmi/vmi210clukrv_label.do',
						prgID	: 'vmi210ukrv',
						extParam: param
					});
					win.center();
					win.show();
				}
			},{
				xtype	: 'button',
				name	: 'btnCancel',
				text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
				width	: 80,
				hidden	: false,
				handler	: function() {
					labelPrintSearch.clearForm();
					labelPrintWindow.hide();
					labelPrintWindow = '';
				}
			}]
		}]
	});

	function openLabelPrintWindow( gsSelRecord ) {
		//if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!labelPrintWindow) {
			labelPrintWindow = Ext.create('widget.uniDetailWindow', {
				title		: '<t:message code="system.label.purchase.label" default="라벨"/><t:message code="system.label.purchase.print" default="출력"/>',
				width		: 300,
				height		: 285,
				resizable	: false,
				layout		:{type:'vbox', align:'stretch'},
				items		: [labelPrintSearch],
				listeners	: {
					beforehide	: function(me, eOpt) {
						labelPrintSearch.clearForm();
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function ( me, eOpts ) {
						//var selectedDetailRecord = detailGrid.getSelectedRecord();
						labelPrintSearch.setValue('LABEL_ITEM_CODE'	, gsSelRecord.ITEM_CODE );
						labelPrintSearch.setValue('ORDER_NUM'		, gsSelRecord.ORDER_NUM );
						labelPrintSearch.setValue('ORDER_SEQ'		, gsSelRecord.ORDER_SEQ );
						labelPrintSearch.setValue('PACK_UNIT_Q'		, gsSelRecord.PACK_UNIT_Q );
						labelPrintSearch.setValue('BOX_Q'			, gsSelRecord.BOX_Q );
						labelPrintSearch.setValue('EACH_Q'			, gsSelRecord.EACH_Q );
						labelPrintSearch.setValue('ISSUE_QTY'		, gsSelRecord.ISSUE_Q );
						if(gsSelRecord.BOX_Q > 0){
							fn_printQtyCal();
						} else {
							labelPrintSearch.setValue('LABEL_QTY', 1);
						}
						if(Ext.isEmpty(gsSelRecord.DVRY_ESTI_DATE)){
							labelPrintSearch.setValue('DVRY_ESTI_DATE', UniDate.get('today') );
						} else {
							labelPrintSearch.setValue('DVRY_ESTI_DATE', gsSelRecord.DVRY_ESTI_DATE );
						}
					},
					show: function(me, eOpts) {
					}
				}
			})
		}
		labelPrintWindow.center();
		labelPrintWindow.show();
	}

	function fn_printQtyCal(){
		var packUnitQ = 0; //박스입수
		var boxQ	  = 0; //박스수
		var eachQ	  = 0; //낱개
		//var issueQty  = 0; //총수량
		var labelQty  = 0; //라벨출력매수
		packUnitQ = labelPrintSearch.getValue('PACK_UNIT_Q');
		boxQ	  = labelPrintSearch.getValue('BOX_Q');
		eachQ	  = labelPrintSearch.getValue('EACH_Q');
		labelQty  =  boxQ;
		if(eachQ > 0){
			labelQty =  labelQty + 1;
		}
		//labelPrintSearch.setValue('ISSUE_QTY', issueQty);
		labelPrintSearch.setValue('LABEL_QTY', labelQty);
	}



	Unilite.Main({
		id			: 'mpo260skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			this.setDefault();

			//초기화 시 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			detailGrid.getStore().loadData({});

			this.fnInitBinding();
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()) return;	//필수체크
			panelSearch.setValue('ISSUE_NUMS', '');

			detailStore.loadStoreRecords();
		},
		setDefault: function(){
			panelSearch.setValue('ISSUE_NUMS'	, '');
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('ISSUE_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('ISSUE_DATE_TO', UniDate.get('today'));
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('ISSUE_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('ISSUE_DATE_TO', UniDate.get('today'));

			panelSearch.down('#printButton').setDisabled(true);
			panelResult.down('#printButton').setDisabled(true);
			UniAppManager.setToolbarButtons(['reset'], true);
		}
	});
};
</script>