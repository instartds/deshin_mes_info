<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo140ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />	<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 계정구분 -->
<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
</t:appConfig>

<style type="text/css">
</style>

<script type="text/javascript" >

function appMain() {
	var gubunStore = Unilite.createStore('gubunComboStore', {  
        fields: ['text', 'value'],
        data :  [
            {'text':'<t:message code="system.label.purchase.confirm" default="확인"/>'  , 'value':'Y'},
            {'text':'<t:message code="system.label.purchase.notconfirm" default="미확인"/>'  , 'value':'N'}
        ]
    });
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 'mpo140ukrvService.selectList',
//			create	: 'mpo140ukrvService.insertDetail',
			update	: 'mpo140ukrvService.updateDetail',
//			destroy	: 'mpo140ukrvService.deleteDetail',
			syncAll	: 'mpo140ukrvService.saveAll'
		}
	});
	
	Unilite.defineModel('detailModel', {
		fields: [
			
			{name: 'DIV_CODE'			, text: 'DIV_CODE'		, type: 'string'},
			{name: 'ORDER_NUM'			, text: 'ORDER_NUM'		, type: 'string'},
			{name: 'ORDER_SEQ'			, text: 'ORDER_SEQ'		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'		, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'		, type: 'string'},
			{name: 'ORDER_DATE'		, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'		, type: 'uniDate'},
			{name: 'DVRY_DATE'		, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'		, type: 'uniDate'},
			{name: 'REASON'			, text: '미입고사유'		, type: 'string'},
			
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.pounit2" default="발주단위"/>'		, type: 'string'	, comboType: 'AU', comboCode: 'B013'},

			{name: 'ORDER_UNIT_Q'	, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'		, type: 'uniQty'},
			{name: 'ORDER_UNIT_P'   , text: '<t:message code="system.label.purchase.pounitprice" default="발주단가"/>'      , type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_O'   , text: '<t:message code="system.label.purchase.poamount" default="발주금액"/>'      , type: 'uniPrice'},
			{name: 'RECEIPT_Q'		, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'		, type: 'uniQty'},

			{name: 'ORDER_UNIT_Q_I'	, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'		, type: 'uniQty'},
			{name: 'ORDER_UNIT_O_I'	, text: '<t:message code="system.label.purchase.receiptamount" default="입고금액"/>'		, type: 'uniPrice'},
			{name: 'NOTORDER_UNIT_Q', text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'		, type: 'uniQty'},

			
			{name: 'REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'		, type: 'string'}

            
            
        ]
	});	

	var detailStore = Unilite.createStore('detailStore',{
		model: 'detailModel',
		proxy: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,	// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
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
		groupField: 'CUSTOM_NAME',
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	}
		}
	});

	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region:'north',
		layout: {type : 'uniTable', columns :4},
		padding: '1 1 1 1',
		border: true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value: UserInfo.divCode
		},{
			fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank: true,
			width: 315
		},{
			fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name: 'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M001'
		},{
			fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			name: 'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B020'
		}]
	});

	var detailGrid = Unilite.createGrid('detailGrid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
//            userToolbar:false,
			expandLastColumn: false,
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
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		store: detailStore,
		columns: [
			{dataIndex: 'ITEM_CODE'		, width: 113,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.itemtotal" default="품목계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
            }},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'CUSTOM_CODE'		, width: 60 , hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 150},
			{dataIndex: 'ORDER_DATE'		, width: 80},
			{dataIndex: 'DVRY_DATE'			, width: 80},
			{dataIndex: 'REASON'			, width: 250,
                renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
              		metaData.tdCls='x-change-cell_bg_FFFFC6';

                    return val;
                }   
            },
			{dataIndex: 'ORDER_UNIT'		, width: 66},
			
			{dataIndex: 'ORDER_UNIT_Q'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_P'      , width: 100, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_O'      , width: 100, summaryType: 'sum'},
			{dataIndex: 'RECEIPT_Q'			, width: 100, summaryType: 'sum'},

			//20181022 추가
			{dataIndex: 'ORDER_UNIT_Q_I'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_O_I'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'NOTORDER_UNIT_Q'	, width: 100, summaryType: 'sum'},

			{dataIndex: 'REMARK'			, width: 250}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['REASON'])) {
					return true;
				} else {
					return false;
				}
			}
		}
	});
	Unilite.Main({
		borderItems: [{
			id: 'pageAll',
			region: 'center',
			layout: 'border',
			border: false,
			items: [
				panelSearch, detailGrid
			]
		}],
		id: 'mpo140ukrvApp',
		fnInitBinding: function() {
			this.fnInitInputFields();
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
			detailStore.loadStoreRecords();
		},
		onSaveDataButtonDown: function(config) {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
		
			detailStore.saveStore();
		},
		fnInitInputFields: function(){
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			
			panelSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
			
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','delete','save'], false);
		}
	});
	
};
</script>