<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sbs150ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B015" opts='1;3'/>
	<t:ExtComboStore comboType="AU" comboCode="B055" />
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('sbs150ukrvModel', {
		fields: [
			{name: 'CUSTOM_CODE'	,text:'<t:message code="system.label.sales.client" default="고객"/>'				,type:'string'	,editable:false},
			{name: 'DVRY_CUST_SEQ'	,text:'<t:message code="system.label.sales.seq" default="순번"/>'					,type:'integer'	,editable:false, allowBlank:false},
			{name: 'DVRY_CUST_NM'	,text:'<t:message code="system.label.sales.deliveryplacename" default="배송처명"/>'	,type:'string'	,allowBlank:false, maxLength: 40},
			{name: 'DVRY_CUST_PRSN'	,text:'<t:message code="system.label.sales.charger" default="담당자"/>'			,type:'string'	,maxLength: 20},
			{name: 'DVRY_CUST_TEL'	,text:'<t:message code="system.label.sales.phoneno1" default="전화번호"/>'			,type:'string'	,maxLength: 20},
			{name: 'DVRY_CUST_FAX'	,text:'<t:message code="system.label.sales.faxno" default="팩스번호"/>'				,type:'string'	,maxLength: 20},
			{name: 'DVRY_CUST_ZIP'	,text:'<t:message code="system.label.sales.zipcode" default="우편번호"/>'			,type:'string'	,maxLength: 6},
			{name: 'DVRY_CUST_ADD'	,text:'<t:message code="system.label.sales.address" default="주소"/>'				,type:'string'	,maxLength: 200},
			{name: 'REMARK'			,text:'<t:message code="system.label.sales.remarks" default="비고"/>'				,type:'string'	,maxLength: 1000},
			{name: 'BARCODE'		,text:'<t:message code="system.label.sales.barcode" default="바코드"/>'			,type:'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('sbs150ukrvMasterStore',{
		model	: 'sbs150ukrvModel',
		uniOpt	: {
			isMaster	: true,		//상위 버튼 연결 
			editable	: true,		//수정 모드 사용 
			deletable	: true,		//삭제 가능 여부 
			useNavi		: true		//prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read	: 'sbs150ukrvService.selectList',
				update	: 'sbs150ukrvService.updateMulti',
				create	: 'sbs150ukrvService.insertMulti',
				destroy	: 'sbs150ukrvService.deleteMulti',
				syncAll	: 'sbs150ukrvService.syncAll'
			}
		},
		insertRecord : function(index, params) {
			var seq = this.max('DVRY_CUST_SEQ');
			if(!seq) seq = 1;
			else  seq += 1;
			var r =  Ext.create ('sbs150ukrvModel', {
				CUSTOM_CODE		: params["CUSTOM_CODE"],
				DVRY_CUST_SEQ	: seq
			});
			this.insert(index, r);
			return r;
		},
		loadStoreRecords : function() {
			var customRecord = Ext.getCmp('sbs150ukrvGrid2').getSelectedRecord();
			if(customRecord) {
				var param= customRecord.data;
				console.log( param );
				this.load({
					params : param
				});
			}
		},
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 ) {
				this.syncAll({});
				//masterGrid.reset();
				//this.loadStoreRecords();
				//Ext.getCmp('sbs150ukrvApp').onQueryButtonDown();
			} else {
				Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
			}
		}
	});

	Unilite.defineModel('sbs150ukrvModel2', {
		fields: [
			{name: 'CUSTOM_CODE'	,text:'<t:message code="system.label.sales.client" default="고객"/>'			,type:'string'},
			{name: 'CUSTOM_NAME'	,text:'<t:message code="system.label.sales.clientname" default="고객명"/>'		,type:'string'},
			{name: 'CUSTOM_TYPE'	,text:'고객구분'	,type:'string'},
			{name: 'AGENT_TYPE'		,text:'<t:message code="system.label.sales.clienttype" default="고객분류"/>'	,type:'string'},
			{name: 'TOP_NAME'		,text:'대표자'		,type:'string'},
			{name: 'TELEPHON'		,text:'<t:message code="system.label.sales.phoneno1" default="전화번호"/>'		,type:'string'},
			{name: 'ADDRESS'		,text:'<t:message code="system.label.sales.address" default="주소"/>'			,type:'string'}
		]
	});

	var customCodeStore = Unilite.createStore('customCodeStore',{
		model	: 'sbs150ukrvModel2',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sbs150ukrvService.customCodeList'
			}
		},
		loadStoreRecords : function() {
			var sFrm= Ext.getCmp('searchForm');
			var rv	= true;
			if(sFrm.checkManadatory(['FROM_CUSTOM_CODE','TO_CUSTOM_CODE']) == true ) {
				if(sFrm.getValue('FROM_CUSTOM_CODE') > sFrm.getValue('FROM_CUSTOM_CODE')) {
					rv = false;
					Unilite.messageBox(Msg.sMS257);
				}
			}
			if(rv) {
				var param= sFrm.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
		}
	});



	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('searchForm',{
		layout	: {type : 'uniTable', columns : 4},
		items	: [{
			fieldLabel	: '고객구분',
			name		: 'AREA_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B015'
		}, 
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.client" default="고객"/>',
			valueFieldName	: 'FROM_CUSTOM_CODE',
			textFieldName	: 'FROM_CUSTOM_NAME',
			DBvalueFieldName: 'CUSTOM_CODE',
			DBtextFieldName	: 'CUSTOM_NAME',
			textFieldWidth	: 130
		}),{
			xtype: 'displayfield',
			value: '&nbsp;~&nbsp;'
		},
		Unilite.popup('AGENT_CUST',{
			hideLabel		: true,
			valueFieldName	: 'TO_CUSTOM_CODE',
			textFieldName	: 'TO_CUSTOM_NAME',
			DBvalueFieldName: 'CUSTOM_CODE',
			DBtextFieldName	: 'CUSTOM_NAME',
			textFieldWidth	: 130
		}),{
			fieldLabel	: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
			name		: 'AREA_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B055',
			colspan		: 4
		}]
	});



	/** Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('sbs150ukrvGrid', {
		store	: directMasterStore,
		columns	: [
			{ dataIndex: 'CUSTOM_CODE'		, width: 80	, hidden: true},
			{ dataIndex: 'DVRY_CUST_SEQ'	, width: 60},
			{ dataIndex: 'DVRY_CUST_NM'		, width: 170},
			{ dataIndex: 'DVRY_CUST_PRSN'	, width: 100},
			{ dataIndex: 'DVRY_CUST_TEL'	, width: 100},
			{ dataIndex: 'DVRY_CUST_FAX'	, width: 100, hidden: true},
			{ dataIndex: 'DVRY_CUST_ZIP'	, width: 90	, hidden: true},
			{ dataIndex: 'DVRY_CUST_ADD'	, width: 150},
			{ dataIndex: 'REMARK'			, flex: 1}
		]
	});

	var customCodeGrid = Unilite.createGrid('sbs150ukrvGrid2', {
		store	: customCodeStore,
		columns	: [
			{ dataIndex: 'CUSTOM_CODE'	, width: 80},
			{ dataIndex: 'CUSTOM_NAME'	, width: 150},
			{ dataIndex: 'CUSTOM_TYPE'	, width: 80	, hidden: true},
			{ dataIndex: 'AGENT_TYPE'	, width: 80	, hidden: true},
			{ dataIndex: 'TOP_NAME'		, width: 80	, hidden: true},
			{ dataIndex: 'TELEPHON'		, width: 80	, hidden: true},
			{ dataIndex: 'ADDRESS'		, width: 150, hidden: true}
		],
		listeners: {
			selectionchange: function( grid, selected, eOpts ) {
				Ext.getCmp('sbs150ukrvGrid').getStore().loadStoreRecords();
			}
		}
	});

	var grids = {
		xtype	: 'container',
		flex	: 1,
		layout	: 'border',
		defaults: {
			collapsible	: false,
			split		: true
		},
		items	: [ {
			region	: 'west',
			xtype	: 'container',
			width	: 250,
			layout	: 'fit',
			items	: [ customCodeGrid ]
		}, {
			region	: 'center',
			xtype	: 'container',
			layout	: 'fit',
			flex	: 1,
			items	: [ masterGrid ]
		}]
	};



	Unilite.Main( {
		id		: 'sbs150ukrvApp',
		items	: [panelSearch, grids],
		fnInitBinding : function() {
			this.setToolbarButtons('newData',true);
		},
		onQueryButtonDown : function() {
			customCodeGrid.getStore().loadStoreRecords();
		},
		onNewDataButtonDown : function() {
			if(customCodeGrid.getSelectedRowIndex() >= 0) {
				var param	= customCodeGrid.getSelectedRecord().data;
				var rowIndex= masterGrid.getSelectedRowIndex(0);
				var r = directMasterStore.insertRecord(rowIndex, param);
			} else {
				Unilite.messageBox('고객코드을 선택하세요.');
			}
		},
		onSaveDataButtonDown: function () {
			masterGrid.getStore().saveStore();
		},
		onDeleteDataButtonDown : function() {
			masterGrid.deleteSelectedRow();
		},
		onPrevDataButtonDown:  function() {
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function() {
			masterGrid.selectNextRow();
		},
		onResetButtonDown:function() {
			var frm			= Ext.getCmp('searchForm');
			var grid		= masterGrid;
			var customGrid	= customCodeGrid;
			frm.reset();
			masterGrid.reset();
			customCodeGrid.reset();
		}
	});
};
</script>