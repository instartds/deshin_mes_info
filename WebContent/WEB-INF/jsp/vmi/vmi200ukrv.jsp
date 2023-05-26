<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="vmi200ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />	<!-- 사업장 -->
	<t:ExtComboStore comboType="OU" />		<!-- 창고-->
	<t:ExtComboStore comboType="WU" />		<!-- 작업장  -->

	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 발주상태 -->

</t:appConfig>

<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
</style>

<script type="text/javascript" >
var getVmiUserLevel = '${getVmiUserLevel}';
var PGM_TITLE = "납품예정등록";
var SAVE_AUTH = "true";
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
			read	: 'vmi200ukrvService.selectList',
			create	: 'vmi200ukrvService.insertDetail',
			update	: 'vmi200ukrvService.updateDetail',
			destroy	: 'vmi200ukrvService.deleteDetail',
			syncAll	: 'vmi200ukrvService.saveAll'
		}
	});




	Unilite.defineModel('detailModel', {
		fields: [

			{name: 'IF_YN_CHK'	 	,text: '<t:message code="system.label.purchase.selection" default="선택"/>' 			,type: 'boolean'},
			{name: 'IF_YN'	 		,text: '<t:message code="system.label.purchase.ifyn" default="접수상태"/>' 				,type: 'string',store:gubunStore},
			{name: 'IF_YN_DUMMY'	,text: 'IF_YN_DUMMY' 	,type: 'string'},
			{name: 'INOUT_DATE'	 	,text: '입고일' 			,type: 'uniDate'},
			{name: 'DIV_CODE'	 	,text: 'DIV_CODE' 		,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: 'CUSTOM_CODE' 	,type: 'string'},
			{name: 'ORDER_NUM'	 	,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>' 					,type: 'string'},
			{name: 'ORDER_DATE'	 	,text: '<t:message code="system.label.purchase.podate" default="발주일"/>' 				,type: 'uniDate'},
			{name: 'ORDER_SEQ'	 	,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 					,type: 'string'},
			{name: 'ITEM_CODE'	 	,text: '<t:message code="system.label.purchase.item" default="품목"/>' 					,type: 'string'},
			{name: 'ITEM_NAME'	 	,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>' 				,type: 'string'},
			{name: 'SPEC'	 	 	,text: '<t:message code="system.label.purchase.spec" default="규격"/>' 					,type: 'string'},
			{name: 'ORDER_Q'	 	,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>' 					,type: 'uniQty'},
			{name: 'DVRY_DATE'	 	,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>' 			,type: 'uniDate'},
			{name: 'DVRY_ESTI_DATE'	,text: '<t:message code="system.label.purchase.dvryestidate" default="납품예정일"/>'			,type: 'uniDate'},
			{name: 'WH_CODE'	 	,text: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>' 	,type: 'string',comboType: 'OU'},
			{name: 'INSTOCK_Q'	 	,text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>' 			,type: 'uniQty'},
			{name: 'CONTROL_STATUS'	,text: '<t:message code="system.label.purchase.postatus" default="발주상태"/>' 	 			,type: 'string',comboType:'AU', comboCode:'M002'},
			{name: 'REMARK'	 		,text: '<t:message code="system.label.purchase.remarks" default="비고"/>' 	 			,type: 'string'},
			{name: 'SO_NUM'	 	 	,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>' 		 			,type: 'string'},
			{name: 'SO_SEQ'	 		,text: '<t:message code="system.label.purchase.soseq" default="수주순번"/>' 	 			,type: 'int'},
			{name: 'SO_PLACE'		,text: '<t:message code="system.label.purchase.soplace" default="수주처"/>'				,type: 'string'},
			{name: 'SO_PLACE_NAME'	,text: '<t:message code="system.label.purchase.soplacename" default="수주처명"/>'			,type: 'string'},
			{name: 'SO_ITEM_NAME'	,text: '<t:message code="system.label.purchase.soitemname" default="수주품목명"/>'			,type: 'string'}

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

		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			},
			metachange:function( store, meta, eOpts ){
			}
		}
	});

	var detailGrid = Unilite.createGrid('detailGrid', {
		store: detailStore,
		region: 'center',
		layout: 'fit',
		uniOpt: {
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
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if(selectRecord.get('IF_YN') == 'N'){
						selectRecord.set('IF_YN','Y');
	    			}else{
	    				selectRecord.set('IF_YN','N');
	    				selectRecord.set('DVRY_ESTI_DATE','');
	    				
	    			}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					selectRecord.set('IF_YN',selectRecord.get('IF_YN_DUMMY'));
	    			if(selectRecord.get('IF_YN_DUMMY') == 'N'){
	    				selectRecord.set('DVRY_ESTI_DATE','');
	    				
	    			}					
				}
			}
		}),
		columns: [
			{ dataIndex: 'IF_YN_CHK'		,width: 66, xtype: 'checkcolumn',align:'center',tdCls:'x-change-cell', hidden: true,
				listeners:{
					checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
    					var grdRecord = detailGrid.getStore().getAt(rowIndex);
			    		if(checked == true){
			    			if(grdRecord.get('IF_YN') == 'N'){
			    				grdRecord.set('IF_YN','Y');
			    			}else{
			    				grdRecord.set('IF_YN','N');
			    				grdRecord.set('DVRY_ESTI_DATE','');
			    			}
			    		}else{
			    			grdRecord.set('IF_YN',grdRecord.get('IF_YN_DUMMY'));
			    			if(grdRecord.get('IF_YN_DUMMY') == 'N'){
			    				grdRecord.set('DVRY_ESTI_DATE','');
			    				
			    			}
			    		}
    				}
				}
			},
			{ dataIndex: 'IF_YN'		,width: 80,align:'center'},
			{ dataIndex: 'INOUT_DATE'	, width: 90},
			{ dataIndex: 'SO_NUM'	 	  , width: 100, hidden: true},
			{ dataIndex: 'SO_SEQ'	  	  , width: 80, hidden: true},
			{ dataIndex: 'SO_PLACE'		  , width: 100 ,hidden : true},
			{ dataIndex: 'SO_PLACE_NAME'  , width: 120 ,hidden : true},
			{ dataIndex: 'SO_ITEM_NAME'	  , width: 250 ,hidden : true},
			{ dataIndex: 'ORDER_NUM'	, width: 120},
			{ dataIndex: 'ORDER_DATE'	, width: 90},
			{ dataIndex: 'ORDER_SEQ'	, width: 60,align:'center'},
			{ dataIndex: 'ITEM_CODE'	, width: 120},
			{ dataIndex: 'ITEM_NAME'	, width: 250},
			{ dataIndex: 'SPEC'	 	 	, width: 120},
			{ dataIndex: 'ORDER_Q'	 	, width: 100},
			{ dataIndex: 'DVRY_DATE'	, width: 90},
			{ dataIndex: 'DVRY_ESTI_DATE' , width: 90,tdCls:'x-change-cell'},
			{ dataIndex: 'WH_CODE'	 	  , width: 120},
			{ dataIndex: 'INSTOCK_Q'	  , width: 100},
			{ dataIndex: 'CONTROL_STATUS' , width: 100,align:'center'},
			{ dataIndex: 'REMARK'	 	  , width: 300}

		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['IF_YN_CHK', 'DVRY_ESTI_DATE'])) {
					return true;
				} else {
					return false;
				}
			}
		}
	});
	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region:'north',
		layout: {type : 'uniTable', columns : 3},
		padding: '1 1 1 1',
		border: true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			readOnly: false
		},{
			fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315
		},{ xtype: 'button',
			text: '<t:message code="system.label.purchase.popaperprint" default="발주서출력"/>',
			itemId: 'printButton',
			margin: '0 0 0 20',
			handler : function() {

				var param = panelSearch.getValues();
				var selectedRecords = detailGrid.getSelectedRecords();
				if(Ext.isEmpty(selectedRecords)){
					alert('출력할 데이터를 선택하여 주십시오.');
					return;
				}
				var orderNums = '';
				Ext.each(selectedRecords, function(selectedRecord, index){
					if(index ==0) {
						orderNums	= orderNums + selectedRecord.get('ORDER_NUM');
					}else{
						orderNums	= orderNums + ',' + selectedRecord.get('ORDER_NUM');
					}
				});
				param.ORDER_NUMS = orderNums;
				param.dataCount  = selectedRecords.length;
				param.PGM_ID = 'mpo150rkrv';  //프로그램ID
				param.MAIN_CODE = 'M030'; //해당 모듈의 출력정보를 가지고 있는 공통코드
				param.sTxtValue2_fileTitle = '발 주 서';
					var win = Ext.create('widget.ClipReport', {
						url: CPATH+'/matrl/mpo150clrkrv.do',
						prgID: 'mpo150rkrv',
						extParam: param
					});
				win.center();
				win.show();
			}
		},
        Unilite.popup('AGENT_CUST', {
            fieldLabel: '<t:message code="system.label.purchase.partners" default="협력사"/>',
            valueFieldName: 'CUSTOM_CODE',
            textFieldName: 'CUSTOM_NAME',
			allowBlank: false
        }),
        {
			fieldLabel: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'DVRY_DATE_FR',
			endFieldName: 'DVRY_DATE_TO',
			width: 315,
			colspan: 2
		},
		Unilite.popup('DIV_PUMOK', {
			fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			width: 325,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
        {
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:300,
			items :[{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.purchase.ifyn" default="접수상태"/>',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width: 60,
					name: 'IF_YN',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.purchase.notconfirm" default="미확인"/>',
					width: 70,
					name: 'IF_YN',
					inputValue: 'N'
				},{
					boxLabel: '<t:message code="system.label.purchase.confirm" default="확인"/>',
					width: 60,
					name: 'IF_YN',
					inputValue: 'Y'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						setTimeout(function(){
							UniAppManager.app.onQueryButtonDown();
						}, 50);
					}
				}
			}]
		}]
	});

	Unilite.Main({
		id			: 'vmi200ukrvApp',
		border		: false,
		borderItems	: [{
			id		: 'pageAll',
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelSearch, detailGrid
			]
		}],
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

			detailStore.loadStoreRecords();
		},
		onSaveDataButtonDown: function(config) {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크

			detailStore.saveStore();
		},
		fnInitInputFields: function(){
			UniAppManager.setPageTitle(PGM_TITLE);
			MODIFY_AUTH = true;
			panelSearch.setValue("DIV_CODE", UserInfo.divCode);
			panelSearch.setValue("CUSTOM_CODE", UserInfo.customCode);
			panelSearch.setValue("CUSTOM_NAME", UserInfo.customName);

			if(getVmiUserLevel == '0'){
				panelSearch.getField('CUSTOM_CODE').setReadOnly(false);
				panelSearch.getField('CUSTOM_NAME').setReadOnly(false);
			}else{
				panelSearch.getField('CUSTOM_CODE').setReadOnly(true);
				panelSearch.getField('CUSTOM_NAME').setReadOnly(true);
			}

			panelSearch.setValue("ORDER_DATE_FR", UniDate.get('startOfMonth'));
			panelSearch.setValue("ORDER_DATE_TO", UniDate.get('today'));

			panelSearch.getField('IF_YN').setValue('');

			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','save'], false);
		}
	});
};
</script>
