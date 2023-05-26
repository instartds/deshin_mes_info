<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv330skrv"  >

	<t:ExtComboStore comboType="BOR120" comboCode="B001"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 				<!-- 계정구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> 				<!-- 수불담당 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>		<!-- 창고 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Biv330skrvModel', {
		fields: [
			{name: 'ITEM_ACCOUNT',				text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',			type: 'string'},
			{name: 'ACCOUNT1',					text: '<t:message code="system.label.inventory.itemaccountcode" default="품목계정코드"/>',	type: 'string'},
			{name: 'ITEM_CODE',					text: '<t:message code="system.label.inventory.item" default="품목"/>',					type: 'string'},
			{name: 'ITEM_NAME',					text: '<t:message code="system.label.inventory.itemname2" default="품명"/>',				type: 'string'},
			{name: 'SPEC',						text: '<t:message code="system.label.inventory.spec" default="규격"/>',					type: 'string'},
			{name: 'STOCK_UNIT',				text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',		type: 'string'},
			{name: 'INOUT_DATE',				text: '<t:message code="system.label.inventory.transdate" default="수불일"/>',				type: 'uniDate'},
			{name: 'STOCK_Q',					text: '<t:message code="system.label.inventory.basicqty" default="기초수량"/>',				type: 'uniQty'},
			{name: 'IN_Q',						text: '<t:message code="system.label.inventory.receiptqty" default="입고량"/>',			type: 'uniQty'},
			{name: 'OUT_Q',						text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>',				type: 'uniQty'},
			{name: 'RET_Q',						text: '<t:message code="system.label.inventory.returnqty" default="반품량"/>',				type: 'uniQty'},
			{name: 'END_STOCK_Q',				text: '<t:message code="system.label.inventory.endstockqty" default="기말재고량"/>',			type: 'uniQty'},
			{name: 'INOUT_CODE_TYPE',			text: '<t:message code="system.label.inventory.tranplacedivision" default="수불처구분"/>',	type: 'string'},
			{name: 'INOUT_CODE_NAME',			text: '<t:message code="system.label.inventory.tranplace" default="수불처"/>',	 			type: 'string'},
			{name: 'DIV_CODE_NAME',				text: '<t:message code="system.label.inventory.trandivision" default="수불사업장"/>',		type: 'string'},
			{name: 'WH_CODE_CODE',				text: '<t:message code="system.label.inventory.tranwarehousecode" default="수불창고코드"/>',	type: 'string'},
			{name: 'WH_CODE_NAME',				text: '<t:message code="system.label.inventory.tranwarehouse" default="수불창고"/>',		type: 'string'},
			{name: 'INOUT_TYPE_DETAIL_NAME',	text: '<t:message code="system.label.inventory.trantype" default="수불유형"/>',				type: 'string'},
			{name: 'INOUT_PRSN_NAME',			text: '<t:message code="system.label.inventory.charger" default="담당자"/>',				type: 'string'},
			{name: 'INOUT_NUM',					text: '<t:message code="system.label.inventory.tranno" default="수불번호"/>',				type: 'string'},
			{name: 'INOUT_SEQ',					text: '<t:message code="system.label.inventory.transeq" default="수불순번"/>',				type: 'string'},
			{name: 'CREATE_LOC_NAME',			text: '<t:message code="system.label.inventory.creationpath" default="생성경로"/>',			type: 'string'},
			{name: 'INOUT_MATH_NAME',			text: '<t:message code="system.label.inventory.tranmethod" default="수불방법"/>',			type: 'string'},
			{name: 'ITEM_STATUS',				text: '<t:message code="system.label.inventory.itemstatus" default="품목상태"/>',			type: 'string'},
			{name: 'STOCK_I',					text: '<t:message code="system.label.inventory.basicamount" default="기초금액"/>',			type: 'uniPrice'},
			{name: 'IN_I',						text: '<t:message code="system.label.inventory.receiptamount" default="입고금액"/>',		type: 'uniPrice'},
			{name: 'OUT_I',						text: '<t:message code="system.label.inventory.issueamount" default="출고금액"/>',			type: 'uniPrice'},
			{name: 'RET_I',						text: '<t:message code="system.label.inventory.returnamount" default="반품액"/>',			type: 'uniPrice'},
			{name: 'END_STOCK_I',				text: '<t:message code="system.label.inventory.inventoryamount" default="재고금액"/>',		type: 'uniPrice'},
			{name: 'LOT_NO',					text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',				type: 'string'},
			//20181217 추가
			{name: 'MAKE_DATE',					text: '<t:message code="system.label.inventory.mfgdate" default="제조일"/>',				type: 'uniDate'},
			{name: 'MAKE_LOT_NO',				text: '<t:message code="system.label.inventory.mfglot" default="제조LOT"/>',				type: 'string'},
			{name: 'ORDER_NUM',					text: '<t:message code="system.label.inventory.workorderno" default="작업지시번호"/>',		type: 'string'},
			//20181031 추가
			{name: 'INOUT_PRSN',				text: '<t:message code="system.label.inventory.trancharger" default="수불담당자"/>',			type: 'string', comboType: 'AU', comboCode: 'B024'},
			{name: 'INSERT_DB_USER',			text: '<t:message code="system.label.inventory.accntperson" default="입력자"/>',			type: 'string'},
			{name: 'INSERT_DB_TIME',			text: '<t:message code="system.label.inventory.inputdate" default="입력일"/>',				type: 'string'}
		]
	});

	Unilite.defineModel('Biv330skrvModel2', {
		fields: [
			{name: 'ITEM_ACCOUNT',				text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',				type: 'string'},
			{name: 'ACCOUNT1',					text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',				type: 'string'},
			{name: 'ITEM_CODE',					text: '<t:message code="system.label.inventory.item" default="품목"/>',					type: 'string'},
			{name: 'ITEM_NAME',					text: '<t:message code="system.label.inventory.itemname2" default="품명"/>',				type: 'string'},
			{name: 'SPEC',						text: '<t:message code="system.label.inventory.spec" default="규격"/>',					type: 'string'},
			{name: 'STOCK_UNIT',				text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',		type: 'string'},
			{name: 'INOUT_DATE',				text: '<t:message code="system.label.inventory.transdate" default="수불일"/>',				type: 'uniDate'},
			{name: 'STOCK_Q',					text: '<t:message code="system.label.inventory.basicqty" default="기초수량"/>',				type: 'uniQty'},
			{name: 'IN_Q',						text: '<t:message code="system.label.inventory.receiptqty" default="입고량"/>',			type: 'uniQty'},
			{name: 'OUT_Q',						text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>',				type: 'uniQty'},
			{name: 'RET_Q',						text: '<t:message code="system.label.inventory.returnqty" default="반품량"/>',				type: 'uniQty'},
			{name: 'END_STOCK_Q',				text: '<t:message code="system.label.inventory.inventoryqty" default="재고량"/>',			type: 'uniQty'},
			{name: 'INOUT_CODE_TYPE',			text: '<t:message code="system.label.inventory.tranplacedivision" default="수불처구분"/>',	type: 'string'},
			{name: 'INOUT_CODE_NAME',			text: '<t:message code="system.label.inventory.tranplace" default="수불처"/>',				type: 'string'},
			{name: 'DIV_CODE_NAME',				text: '<t:message code="system.label.inventory.division" default="사업장"/>',				type: 'string'},
			{name: 'WH_CODE_CODE',				text: '<t:message code="system.label.inventory.tranwarehousecode" default="수불창고코드"/>',	type: 'string'},
			{name: 'WH_CODE_NAME',				text: '<t:message code="system.label.inventory.tranwarehouse" default="수불창고"/>',		type: 'string'},
			{name: 'INOUT_TYPE_DETAIL_NAME',	text: '<t:message code="system.label.inventory.trantype" default="수불유형"/>',				type: 'string'},
			{name: 'INOUT_PRSN_NAME',			text: '<t:message code="system.label.inventory.charger" default="담당자"/>',				type: 'string'},
			{name: 'INOUT_NUM',					text: '<t:message code="system.label.inventory.tranno" default="수불번호"/>',				type: 'string'},
			{name: 'INOUT_SEQ',					text: '<t:message code="system.label.inventory.transeq" default="수불순번"/>',				type: 'string'},
			{name: 'CREATE_LOC_NAME',			text: '<t:message code="system.label.inventory.creationpath" default="생성경로"/>',			type: 'string'},
			{name: 'INOUT_MATH_NAME',			text: '<t:message code="system.label.inventory.tranmethod" default="수불방법"/>',			type: 'string'},
			{name: 'ITEM_STATUS',				text: '<t:message code="system.label.inventory.itemstatus" default="품목상태"/>',			type: 'string'},
			{name: 'STOCK_I',					text: '<t:message code="system.label.inventory.basicamount" default="기초금액"/>',			type: 'uniPrice'},
			{name: 'IN_I',						text: '<t:message code="system.label.inventory.receiptamount" default="입고금액"/>',		type: 'uniPrice'},
			{name: 'OUT_I',						text: '<t:message code="system.label.inventory.issueamount" default="출고금액"/>',			type: 'uniPrice'},
			{name: 'RET_I',						text: '<t:message code="system.label.inventory.returnamount" default="반품액"/>',			type: 'uniPrice'},
			{name: 'END_STOCK_I',				text: '<t:message code="system.label.inventory.inventoryamount" default="재고금액"/>',		type: 'uniPrice'},
			{name: 'LOT_NO',					text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',				type: 'string'},
			//20181031 추가
			{name: 'INOUT_PRSN',				text: '<t:message code="system.label.inventory.trancharger" default="수불담당자"/>',			type: 'string', comboType: 'AU', comboCode: 'B024'},
			{name: 'INSERT_DB_USER',			text: '<t:message code="system.label.inventory.accntperson" default="입력자"/>',			type: 'string'},
			{name: 'INSERT_DB_TIME',			text: '<t:message code="system.label.inventory.inputdate" default="입력일"/>',				type: 'string'} //uniDate
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('biv330skrvMasterStore1',{
		model: 'Biv330skrvModel',
		uniOpt : {
			isMaster: true,				// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false				// prev | newxt 버튼 사용
				//비고(*) 사용않함
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'biv330skrvService.selectMaster'
			}
		}
		,loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			if(param.EVAL_FLAG == null) {
				param.EVAL_FLAG = ''
			}
			console.log( param );
			this.load({
				params: param
			});
		}
	});

	var directMasterStore2 = Unilite.createStore('biv330skrvMasterStore2',{
		model: 'Biv330skrvModel2',
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
				//비고(*) 사용않함
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'biv330skrvService.selectMaster2'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			if(param.EVAL_FLAG == null) {
				param.EVAL_FLAG = ''
			}
			console.log( param );
			this.load({
				params: param
			});
		}
	});


	/** 검색조건 (Search Panel)
	 * @type
	 */
/*	var panelSearch = Unilite.createSearchPanel('searchForm',{
		collapsed: true,
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '기본정보',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
				items: [{
					fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					comboCode: 'B001',
					child:'WH_CODE',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
					name: 'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
//					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},{
					fieldLabel: '수불일',
	 				width: 315,
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_INOUT_DATE',
					endFieldName: 'TO_INOUT_DATE',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
//					allowBlank:false,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FR_INOUT_DATE',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();

						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('TO_INOUT_DATE',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
						}
					}
				},
					Unilite.popup('DIV_PUMOK',{
							fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
							valueFieldName: 'ITEM_CODE',
							textFieldName: 'ITEM_NAME',
							listeners: {
								onSelected: {
									fn: function(records, type) {
										console.log('records : ', records);
										panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
										panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
									},
									scope: this
								},
								onClear: function(type)	{
									panelResult.setValue('ITEM_CODE', '');
									panelResult.setValue('ITEM_NAME', '');
								},
								applyextparam: function(popup){
									popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								}
							}
				}),{
						fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
						name:'WH_CODE',
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('whList'),
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WH_CODE', newValue);
						}
					}
				},{
					fieldLabel: '실사포함',
					name: 'EVAL_FLAG',
					xtype: 'checkboxfield',
					inputValue: '1',
					//inputValue: '',
					//checked: false,
					listeners: {
						change: function (checkbox, newVal, oldVal) {
							panelResult.setValue('EVAL_FLAG', newVal);
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
				}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
*/
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			comboCode: 'B001',
			child:'WH_CODE',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
			name: 'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B020',
//			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.transdate" default="수불일"/>',
			width: 315,
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_INOUT_DATE',
			endFieldName: 'TO_INOUT_DATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			colspan: 2,
//			allowBlank:false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			validateBlank: false,
			autoPopup: true,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				}
			}
		},
		Unilite.popup('LOT_NO',{
			fieldLabel: 'LOT NO',
			holdable: 'hold',
			validateBlank:false,
			valueFieldName: 'LOT_NO',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						panelResult.setValue('LOT_NO',records[0].LOT_NO);
//						panelResult.setValue('ITEM_CODE', records[0].ITEM_CODE);
//						panelResult.setValue('ITEM_NAME', records[0].ITEM_NAME);
					},
					scope: this
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
//					popup.setExtParam({'ITEM_CODE': panelResult.getValue('ITEM_CODE')});
//					popup.setExtParam({'ITEM_NAME': panelResult.getValue('ITEM_NAME')});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.inventory.stockcountingadjust" default="실사조정"/>',
			name: 'EVAL_FLAG',
			xtype: 'checkboxfield',
			inputValue: '1',
			//inputValue: '',
			//checked: false,
			listeners: {
				change: function (checkbox, newVal, oldVal) {
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
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('biv330skrvGrid1', {
		region: 'center' ,
		layout : 'fit',
		title: '<t:message code="system.label.inventory.itemby" default="품목별"/>',
		excelTitle: '<t:message code="system.label.inventory.periodinoutstatusitemby" default="기간별수불현황조회(품목별)"/>',
		store : directMasterStore1,
		uniOpt:{	expandLastColumn: true,
					useRowNumberer: false,
					useMultipleSorting: true
		},
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
			{dataIndex: 'ITEM_ACCOUNT',			width: 93,	locked:false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.total" default="총계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
			},
			{dataIndex: 'ACCOUNT1',  				width: 66,	hidden:true},
			{dataIndex: 'ITEM_CODE',				width: 110,	locked:false},
			{dataIndex: 'ITEM_NAME',				width: 140,	locked:false},
			{dataIndex: 'SPEC',						width: 120,	hidden:true},
			{dataIndex: 'STOCK_UNIT',				width: 66,	locked:false},
			{dataIndex: 'INOUT_DATE',				width: 80,	locked:false},
			{dataIndex: 'STOCK_Q',  				width: 86},
			{dataIndex: 'IN_Q',  					width: 86,	summaryType: 'sum'},
			{dataIndex: 'OUT_Q',					width: 86,	summaryType: 'sum'},
			{dataIndex: 'RET_Q',					width: 86,	summaryType: 'sum'},
			{dataIndex: 'END_STOCK_Q',				width: 106},
			{dataIndex: 'INOUT_CODE_TYPE',			width: 100},
			{dataIndex: 'INOUT_CODE_NAME',			width: 100},
			{dataIndex: 'DIV_CODE_NAME',			width: 100, hidden:true },
			{dataIndex: 'WH_CODE_CODE',				width: 85},
			{dataIndex: 'WH_CODE_NAME',				width: 100},
			{dataIndex: 'INOUT_TYPE_DETAIL_NAME',	width: 100},
			{dataIndex: 'INOUT_PRSN_NAME',			width: 100,	hidden:true},
			{dataIndex: 'INOUT_NUM',				width: 110,	hidden:true},
			{dataIndex: 'INOUT_SEQ',				width: 73,	hidden:true},
			{dataIndex: 'CREATE_LOC_NAME',			width: 100,	hidden:true},
			{dataIndex: 'INOUT_MATH_NAME',			width: 100,	hidden:true},
			{dataIndex: 'ITEM_STATUS',				width: 100,	hidden:true},
			{dataIndex: 'STOCK_I',					width: 100,	hidden:true},
			{dataIndex: 'IN_I',						width: 100, summaryType: 'sum',	hidden:true},
			{dataIndex: 'OUT_I',					width: 100, summaryType: 'sum',	hidden:true},
			{dataIndex: 'RET_I',					width: 100, summaryType: 'sum',	hidden:true},
			{dataIndex: 'END_STOCK_I',				width: 106,	hidden:true},
			{dataIndex: 'LOT_NO',					width: 106},
			//20181217 추가
			{dataIndex: 'MAKE_DATE',				width: 80 ,	hidden:true},
			{dataIndex: 'MAKE_LOT_NO',				width: 106,	hidden:true},
			{dataIndex: 'ORDER_NUM',				width: 110,	hidden:true},
			//20181031 추가
			{dataIndex: 'INOUT_PRSN',				width: 106},
			{dataIndex: 'INSERT_DB_USER',			width: 86},
			{dataIndex: 'INSERT_DB_TIME',			width: 150}
		]
	});

	var masterGrid2 = Unilite.createGrid('biv330skrvGrid2', {
		region: 'center' ,
		layout : 'fit',
		title: '<t:message code="system.label.inventory.warehouseby" default="창고별"/>',
		excelTitle: '<t:message code="system.label.inventory.periodinoutstatuswarehouseby" default="기간별수불현황조회(창고별)"/>',
		store : directMasterStore2,
		uniOpt:{	expandLastColumn: true,
					useRowNumberer: false,
					useMultipleSorting: true
		},
		features: [ {id : 'masterGridSubTotal2', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal2',	ftype: 'uniSummary',	  showSummaryRow: true}
		],
		columns:  [
			{dataIndex: 'ACCOUNT1',  				width: 66,	locked:false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.total" default="총계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
			},
			{dataIndex: 'ITEM_ACCOUNT',				width: 93,	locked:false},
			{dataIndex: 'ITEM_CODE',				width: 110,	locked:false},
			{dataIndex: 'ITEM_NAME',				width: 140,	locked:false},
			{dataIndex: 'SPEC',						width: 120,	locked:false},
			{dataIndex: 'STOCK_UNIT',				width: 66,	locked:false},
			{dataIndex: 'INOUT_DATE',				width: 80,	locked:false},
			{dataIndex: 'STOCK_Q',  				width: 86},
			{dataIndex: 'IN_Q',  					width: 86,	summaryType: 'sum'},
			{dataIndex: 'OUT_Q',					width: 86,	summaryType: 'sum'},
			{dataIndex: 'RET_Q',					width: 86,	summaryType: 'sum'},
			{dataIndex: 'END_STOCK_Q',				width: 106},
			{dataIndex: 'INOUT_CODE_TYPE',			width: 100},
			{dataIndex: 'INOUT_CODE_NAME',			width: 100},
			{dataIndex: 'DIV_CODE_NAME',			width: 100, hidden:true },
			{dataIndex: 'WH_CODE_CODE',				width: 85},
			{dataIndex: 'WH_CODE_NAME',				width: 100},
			{dataIndex: 'INOUT_TYPE_DETAIL_NAME',	width: 100},
			{dataIndex: 'INOUT_PRSN_NAME',			width: 100},
			{dataIndex: 'INOUT_NUM',				width: 110},
			{dataIndex: 'INOUT_SEQ',				width: 73},
			{dataIndex: 'CREATE_LOC_NAME',			width: 100},
			{dataIndex: 'INOUT_MATH_NAME',			width: 100},
			{dataIndex: 'ITEM_STATUS',				width: 100},
			{dataIndex: 'STOCK_I',					width: 86},
			{dataIndex: 'IN_I',						width: 100,	summaryType: 'sum'},
			{dataIndex: 'OUT_I',					width: 100,	summaryType: 'sum'},
			{dataIndex: 'RET_I',					width: 100,	summaryType: 'sum'},
			{dataIndex: 'END_STOCK_I',				width: 106},
			{dataIndex: 'LOT_NO',					width: 106},
			{dataIndex: 'INOUT_PRSN',				width: 106},
			{dataIndex: 'INSERT_DB_USER',			width: 86},
			{dataIndex: 'INSERT_DB_TIME',			width: 150}
		]
	});

	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab:  0,
		region: 'center',
		items:  [
			 masterGrid,
			 masterGrid2
		]
	});

	Unilite.Main( {
		borderItems: [{
		region:'center',
		layout: 'border',
		border: false,
		items:[
			tab, panelResult
		]
		}
		//panelSearch
		],
		id  : 'biv330skrvApp',
		fnInitBinding : function(params) {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
			if(Ext.isEmpty(params && params.ITEM_ACCOUNT)) {
				biv330skrvService.userWhcode({}, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						panelResult.setValue('WH_CODE',provider['WH_CODE']);
					}
				})
			}
			this.processParams(params);
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params && params.ITEM_ACCOUNT) {

				panelResult.setValue('DIV_CODE',params.DIV_CODE);
				panelResult.setValue('ITEM_ACCOUNT',params.ITEM_ACCOUNT);
				panelResult.setValue('FR_INOUT_DATE',params.INOUT_DATE_FR);
				panelResult.setValue('TO_INOUT_DATE',params.INOUT_DATE_TO);
				panelResult.setValue('ITEM_CODE',params.ITEM_CODE);
				panelResult.setValue('ITEM_NAME',params.ITEM_NAME);
				panelResult.setValue('WH_CODE',params.WH_CODE);

				masterGrid.getStore().loadStoreRecords();

				/*panelSearch.getField('DIV_CODE').setReadOnly( true );
				panelSearch.getField('ITEM_ACCOUNT').setReadOnly( true );
				panelSearch.getField('ITEM_CODE').setReadOnly( true );
				panelSearch.getField('ITEM_NAME').setReadOnly( true );
				panelSearch.getField('WH_CODE').setReadOnly( true );

				panelResult.getField('DIV_CODE').setReadOnly( true );
				panelResult.getField('ITEM_ACCOUNT').setReadOnly( true );
				panelResult.getField('ITEM_CODE').setReadOnly( true );
				panelSearch.getField('ITEM_NAME').setReadOnly( true );
				panelResult.getField('WH_CODE').setReadOnly( true );*/
			}
		},
		onQueryButtonDown : function()	{
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			var activeTabId = tab.getActiveTab().getId();
			var viewNormal = masterGrid.getView();
//			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal2 = masterGrid2.getView();
//			var viewLocked2 = masterGrid2.lockedGrid.getView();
			if(activeTabId == 'biv330skrvGrid1'){
				directMasterStore1.loadStoreRecords();
				console.log("viewNormal : ",viewNormal);
//				console.log("viewLocked : ",viewLocked);
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//				viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//				viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			}
			else if(activeTabId == 'biv330skrvGrid2'){
				directMasterStore2.loadStoreRecords();
				console.log("viewNormal2 : ",viewNormal2);
//				console.log("viewLocked2 : ",viewLocked2);
				viewNormal2.getFeature('masterGridTotal2').toggleSummaryRow(true);
				viewNormal2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
//				viewLocked2.getFeature('masterGridTotal2').toggleSummaryRow(true);
//				viewLocked2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
			}
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();

			masterGrid.getStore().loadData({});
//			masterGrid.reset();
//			panelResult.clearForm();
			this.fnInitBinding();
			panelResult.getField('ITEM_ACCOUNT').focus();

			directMasterStore1.clearData();
			panelResult.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('TO_INOUT_DATE', UniDate.get('today'));
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>
