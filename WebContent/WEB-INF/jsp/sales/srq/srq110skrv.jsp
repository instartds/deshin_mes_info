<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="srq110skrv"  >
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형 -->
	<t:ExtComboStore comboType="BOR120" pgmId="srq110skrv"/>  <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
.x-change-row-gray {
	background-color: #eaeaea;
}
</style>
<script type="text/javascript" >

function appMain() {
	/** 검색조건 (Search Panel)
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
            xtype       : 'uniCombobox',
            comboType   : 'BOR120',
            value       : UserInfo.divCode,
            allowBlank  : false
		},{
			fieldLabel		: '납기일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'DVRY_DATE_FR',
			endFieldName	: 'DVRY_DATE_TO',
			textFieldWidth	: 150,
			allowBlank		: false
		},{
			fieldLabel	: '판매유형',
			name		: 'ORDER_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S002'
		},
		Unilite.popup('CUST',{
			fieldLabel		: '거래처',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			DBvalueFieldName: 'CUSTOM_CODE',
			DBtextFieldName	: 'CUSTOM_NAME',
			valueFieldWidth	: 100,
			textFieldWidth	: 150,
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),
		Unilite.popup('ITEM',{
			fieldLabel		: '품목',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			DBvalueFieldName: 'ITEM_CODE',
			DBtextFieldName	: 'ITEM_NAME',
			valueFieldWidth	: 100,
			textFieldWidth	: 150,
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '비고',
			name		: 'REMARK',
			xtype		: 'uniTextfield'
		},{
	 		fieldLabel	: 'PGM_ID',
			name		: 'PGM_ID',
			xtype		: 'uniTextfield',
			hidden		: true,
			value		: PGM_ID
		}],
		setAllFieldsReadOnly: function(b) {//필수조건검색 공란일시 메시지출력
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
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					// this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )   {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)   {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				// this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )   {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)   {
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

	/** Model 정의
	 */
	Unilite.defineModel('Srq110skrvModel', {
		fields: [
			{name: 'DVRY_DATE'			,text: '납기일'		,type: 'uniDate'},
			{name: 'CUSTOM_CODE'		,text: '거래처코드'		,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '거래처명'		,type: 'string'},
			{name: 'ORDER_TYPE'			,text: '판매유형코드'		,type: 'string'},
			{name: 'ORDER_TYPE_NAME'	,text: '판매유형'		,type: 'string'},
			{name: 'ITEM_CODE'			,text: '품목코드'		,type: 'string'},
			{name: 'ITEM_NAME'			,text: '품목명'		,type: 'string'},
			{name: 'SPEC'				,text: '규격'			,type: 'string'},
			{name: 'ORG_ORDER_Q'		,text: '수주량'		,type: 'uniQty'},
			{name: 'ORDER_Q'			,text: '미납량'		,type: 'uniQty'},
			{name: 'ORDER_UNIT'			,text: '판매단위'		,type: 'string'},
			{name: 'TRANS_RATE'			,text: '입수'			,type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},		//20200512 수정: 입수 type 변경
			{name: 'ORDER_UNIT_Q'		,text: '재고단위수량'		,type: 'uniQty'},
			{name: 'ORDER_NUM'			,text: '수주번호'		,type: 'string'},
			{name: 'SER_NO'				,text: '수주순번'		,type: 'string'},
			{name: 'ORDER_DATE'			,text: '수주일'		,type: 'uniDate'},
			{name: 'REMARK'				,text: '비고'			,type: 'string'},
			{name: 'REMARK_INTER'		,text: '내부비고'		,type: 'string'},
			{name: 'PRINT_YN'			,text: '인쇄여부'		,type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 */
	var directMasterStore = Unilite.createStore('srq110skrvMasterStore',{
		model	: 'Srq110skrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'srq110skrvService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
	});

	/** Master Grid 정의(Grid Panel)
	 */
	var masterGrid = Unilite.createGrid('srq110skrvGrid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer		: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch		: true,		//찾기 버튼 사용 여부
			useRowContext		: false,
			onLoadSelectFirst	: false,
			filter: {						//필터 사용 여부
				useFilter	: true,
				autoCreate	: true
			}
		},
		//20200512 추가: 그리드 합계로직 추가 중 중지 - 체크박스 있는 그리드에서는 불가
/*		tbar:[{
			fieldLabel		: '<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>',
			xtype			: 'uniNumberfield',
			itemId			: 'selectionSummary',
			format			: '0,000.0000',
			decimalPrecision: 4,
			value			: 0,
			labelWidth		: 110,
			readOnly		: true
		}],*/
		selModel : Ext.create("Ext.selection.CheckboxModel", {
			checkOnly : false
		}),
		features: [ 
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns	: [
			{ dataIndex: 'DVRY_DATE'		, width: 100},
			{ dataIndex: 'CUSTOM_CODE'		, width: 100},
			{ dataIndex: 'CUSTOM_NAME'		, width: 200},
			{ dataIndex: 'ORDER_TYPE'		, width: 100 , hidden: true},
			{ dataIndex: 'ORDER_TYPE_NAME'	, width: 150},
			{ dataIndex: 'ITEM_CODE'		, width: 100},
			{ dataIndex: 'ITEM_NAME'		, width: 200},
			{ dataIndex: 'SPEC'				, width: 150},
			{ dataIndex: 'ORG_ORDER_Q'		, width: 80},
			{ dataIndex: 'ORDER_Q'			, width: 80},
			{ dataIndex: 'ORDER_UNIT'		, width: 100},
			{ dataIndex: 'TRANS_RATE'		, width: 80},
			{ dataIndex: 'ORDER_UNIT_Q'		, width: 100},
			{ dataIndex: 'ORDER_NUM'		, width: 150},
			{ dataIndex: 'SER_NO'			, width: 80 , align:'right'},
			{ dataIndex: 'ORDER_DATE'		, width: 100},
			{ dataIndex: 'REMARK'			, width: 150},
			{ dataIndex: 'REMARK_INTER'		, width: 150},
			{ dataIndex: 'PRINT_YN'			, width: 80, align:'center'}
		],
		//20200512 추가: 그리드 합계로직 추가 중 중지 - 체크박스 있는 그리드에서는 불가
		listeners:{/*
			selectionchange:function( grid, selection, eOpts ) {
				if(selection && selection.startCell) {
					var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary");
					if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex) {
						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
						var sum = 0;
						for(var i=startIdx; i <= endIdx; i++){
							var record = store.getAt(i);
							sum += record.get(columnName);
						}
						this.down('#selectionSummary').setValue(sum);
					} else {
						this.down('#selectionSummary').setValue(0);
					}
				}
			}*/
		},
		viewConfig:{
			forceFit	: true,
			stripeRows	: false,
			getRowClass	: function(record,rowIndex,rowParams,store){
				var cls = '';
				if(record.get('PRINT_YN')=="Y"){
					cls = 'x-change-row-gray';
				}
				return cls;
			}
		}
	});


	Unilite.Main({
		id			: 'srq110skrvApp',
		borderItems	: [{
			region	: 'center' ,
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid 
			]
		}],
		fnInitBinding: function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue("DVRY_DATE_FR"	, UniDate.get('startOfMonth'));
			panelResult.setValue("DVRY_DATE_TO"	, UniDate.get('today'));
			panelResult.setValue("PGM_ID"		, PGM_ID);
			UniAppManager.setToolbarButtons('save'	, false);
			UniAppManager.setToolbarButtons('reset'	, false);
		},
		onQueryButtonDown: function()   {
			var isTrue = panelResult.setAllFieldsReadOnly(true);
			if(!isTrue){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('print', true);
		},
		onResetButtonDown:function(){
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
			var win;
			var selectedRecords = masterGrid.getSelectedRecords();

			if(Ext.isEmpty(selectedRecords)){
				Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
				return;
			}

			var orderNumRecords;
			Ext.each(selectedRecords, function(record, idx) {
				if(idx == 0) {
					orderNumRecords = record.get('ORDER_NUM') +'|'+ record.get('SER_NO');
				} else {
					orderNumRecords = orderNumRecords + ',' + record.get('ORDER_NUM') +'|'+ record.get('SER_NO');
				}
			});

			var param = panelResult.getValues();
			param["dataCount"] = selectedRecords.length;
			param["ORDER_NUM"] = orderNumRecords;
			 win = Ext.create('widget.ClipReport', {
				url		: CPATH+'/sales/srq110clskrv.do',
				prgID	: 'srq110skrv',
				extParam: param
			});
			win.center();
			win.show();

			baseCommonService.printLogSave(param, function(provider2, response){ });
			UniAppManager.app.onQueryButtonDown();
		}
	});
};
</script>