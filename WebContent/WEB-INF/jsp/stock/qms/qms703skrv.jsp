<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="qms703skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="qms703skrv"  />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="Z018" storeId="printDataStore"/>	<!-- 출력 데이터 -->
	<t:ExtComboStore comboType="WU"/> <!-- 작업장 (사용여부)-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="bpr300ukrvLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="bpr300ukrvLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="bpr300ukrvLevel3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var gsReportGubun = '${gsReportGubun}'	//레포트 구분
function appMain() {

	 var gubunStore = Unilite.createStore('gubunComboStore', {
        fields: ['text', 'value'],
        data :  [
            {'text':'자재발주'  , 'value':'1'},
            {'text':'외주발주'  , 'value':'2'}
        ]
    });

	/**
	 *   Model 정의
	 */
	Unilite.defineModel('qms703skrvModel', {
		fields: [
			{name: 'COMP_CODE'     	, text: '법인코드'			, type: 'string'},
			{name: 'DIV_CODE'     		, text: '사업장'			, type: 'string'},
			{name: 'WKORD_NUM'     	, text: '작업지시번호'	, type: 'string'},
			{name: 'LOT_NO'   			, text: 'LOT_NO'		, type: 'string'},
			{name: 'ITEM_CODE'     	, text: '품목코드'			, type: 'string'},
			{name: 'ITEM_NAME'     	, text: '품목명'			, type: 'string'},
			{name: 'SPEC'     				, text: '형명(규격)'		, type: 'string'},
			{name: 'WKORD_Q'  			, text: '생산수량'			, type: 'uniQty'},
			{name: 'CUSTOM_CODE'  	, text: '거래처'			, type: 'string'},
			{name: 'CUSTOM_NAME'  	, text: '거래처명'			, type: 'string'},
			{name: 'NATION_NAME'  	, text: '국가'				, type: 'string'},
			{name: 'PRODT_DATE'  		, text: '생산일'			, type: 'uniDate'},
			{name: 'UPN_CODE'  		, text: 'UPN 코드'		, type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 */
	var masterStore = Unilite.createStore('qms703skrvMasterStore1', {
		model: 'qms703skrvModel',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'qms703skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();

			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {
						  var recordCount = masterStore.getCount();
						  if(recordCount > 0){
							  masterGrid.getSelectionModel().selectAll();
							  Ext.getCmp("printButtonQms703skrv").enable();
							  panelResult.uniOpt.inLoading = false;
							  panelResult.unmask();
						  }
					}
				}
			});
		}
	});


	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout: {type : 'uniTable', columns :4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_SHOP_CODE', '');
					fn_WorkshopSet('2');
			/* 		if(Ext.getCmp('optRadioBoxIds').getChecked()[0].inputValue == '0'){
						fn_WorkshopSet('0');
					}else{
						fn_WorkshopSet('1');
					} */
				}
			}
		},{
			fieldLabel: '계획일',
			xtype: 'uniDateRangefield',
			startFieldName: 'PRODT_WKORD_DATE_FR',
			endFieldName: 'PRODT_WKORD_DATE_TO',
			startDate: UniDate.get('tomorrow'),
			endDate: UniDate.get('endOfMonth'),
			width: 315,
			allowBlank: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {

		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {

		    }

		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType:'WU',
			allowBlank: false,
			colspan: 1,
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
		}, {
            text: '엑셀출력',
            itemId: 'printButtonQms703skrv',
            id: 'printButtonQms703skrv',
            xtype: 'button',
            margin: '0 0 0 100',
            disabled: true,
            handler: function() {
                if(!panelResult.getInvalidMessage()){
					return false;
				}
                var ITEM_LEVEL2_1 = 'N';
                var ITEM_LEVEL2_2 = 'N';
                var ITEM_LEVEL2_3 = 'N';
                if( panelResult.getValue('ITEM_LEVEL2_1') == true ){
                	ITEM_LEVEL2_1 = 'Y';
                }else if( panelResult.getValue('ITEM_LEVEL2_2') == true ){
                	ITEM_LEVEL2_2 = 'Y';
                }else if( panelResult.getValue('ITEM_LEVEL2_3') == true ){
                	ITEM_LEVEL2_3 = 'Y';
                }

                window.open(CPATH + '/stock/qms703skrvExcelDown.do?DIV_CODE=' + panelResult.getValue('DIV_CODE')
                			+ '&PRODT_WKORD_DATE_FR=' + UniDate.getDbDateStr(panelResult.getValue('PRODT_WKORD_DATE_FR'))
                			+ '&PRODT_WKORD_DATE_TO=' + UniDate.getDbDateStr(panelResult.getValue('PRODT_WKORD_DATE_TO'))
                			+ '&ITEM_LEVEL1=' 		  + panelResult.getValue('ITEM_LEVEL1')
                			+ '&ITEM_LEVEL2_1=' 	  + ITEM_LEVEL2_1
                			+ '&ITEM_LEVEL2_2=' 	  + ITEM_LEVEL2_2
                			+ '&ITEM_LEVEL2_3=' 	  + ITEM_LEVEL2_3
                			+ '&WORK_SHOP_CODE=' 	  + panelResult.getValue('WORK_SHOP_CODE'), "_self");
            }
	    },{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 3 0',
			colspan : 4,
			items	: [{
				fieldLabel	: '<t:message code="system.label.base.itemgroup" default="품목분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('bpr300ukrvLevel1Store')
			},{
				xtype: 'uniCheckboxgroup',
				fieldLabel: '',
				padding: '0 0 0 0',
				margin: '0 0 0 30',
				items: [{
					boxLabel: '완제품',
					width: 80,
					name: 'ITEM_LEVEL2_1',
					inputValue: 'Y',
					checked: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					boxLabel: '시제품',
					width: 80,
					name: 'ITEM_LEVEL2_2',
					inputValue: 'Y',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					boxLabel: '샘플',
					width: 80,
					name: 'ITEM_LEVEL2_3',
					inputValue: 'Y',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				}]
			}]
		}]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     */
	var masterGrid = Unilite.createGrid('qms703skrvGrid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useSqlTotal			: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			},
			state: {
				useState: true,
				useStateList: true
			}
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
		store: masterStore,
		columns: [
			{dataIndex: 'WKORD_NUM'		,width: 100},

			{dataIndex: 'ITEM_CODE'		,width: 100},
			{dataIndex: 'ITEM_NAME'		,width: 250},
			{dataIndex: 'SPEC'     			,width: 150},
			{dataIndex: 'LOT_NO'			,width: 100, align:'center'},
			{dataIndex: 'WKORD_Q'    		,width: 100},
			{dataIndex: 'CUSTOM_CODE'	,width: 100, hidden: true},
			{dataIndex: 'CUSTOM_NAME'	,width: 150},
			{dataIndex: 'NATION_NAME'	,width: 120},
			{dataIndex: 'PRODT_DATE'		,width: 100},
			{dataIndex: 'UPN_CODE'     	,width: 100}
		]
	});

	function fn_WorkshopSet(opt){
		var workStore = panelResult.getField('WORK_SHOP_CODE').getStore();
		if(opt == '0'){
			Ext.each(workStore.data.items, function(record, index){
				if(record.get('option') == panelResult.getValue('DIV_CODE') && record.get('refCode1') == 'B'){
					 panelResult.setValue('WORK_SHOP_CODE', record.get('value'));
					 return false;
				}
			});
		}else if(opt == '1'){
			Ext.each(workStore.data.items, function(record, index){
				if(record.get('option') == panelResult.getValue('DIV_CODE') && record.get('refCode1') == 'D'){
					 panelResult.setValue('WORK_SHOP_CODE', record.get('value'));
					 return false;
				}
			});
		}else{
			Ext.each(workStore.data.items, function(record, index){
				if(record.get('option') == panelResult.getValue('DIV_CODE') && record.get('refCode1') == 'D'){
					 panelResult.setValue('WORK_SHOP_CODE', record.get('value'));
					 return false;
				}
			});
		}

	}

	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		}
		],
		id: 'qms703skrvApp',
		fnInitBinding: function() {

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('PRODT_WKORD_DATE_FR',UniDate.get('today'));
			panelResult.setValue('PRODT_WKORD_DATE_TO',UniDate.get('endOfMonth'));
			panelResult.setValue('ITEM_LEVEL1', '100');
			fn_WorkshopSet('2');


			UniAppManager.setToolbarButtons(['reset'], true);
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;   //필수체크
			masterStore.loadStoreRecords();
		},
        onResetButtonDown:function() {

        	panelResult.clearForm();
        	masterGrid.reset();
        	masterStore.clearData();
        	UniAppManager.app.fnInitBinding();
        },
        onPrintButtonDown: function() {

		}
	});




};
</script>