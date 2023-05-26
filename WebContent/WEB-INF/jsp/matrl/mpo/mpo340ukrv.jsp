<%--
'   프로그램명 : 발주납기변경 등록
'   작   성   자 : 시너지시스템즈개발실
'   작   성   일 : 2021.04
'   최종수정자 :
'   최종수정일 :
'   버	  전 : OMEGA Plus V6.2.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo340ukrv">
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />					<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="Z019"/>                  <!-- 입고에정일변경사유 -->
	

</t:appConfig>

<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-change-cell {
		background-color: #FFFFC6;
	}
</style>

<script type="text/javascript" >


function appMain() {
	var gubunStore = Unilite.createStore('gubunComboStore', {
		fields	: ['text', 'value'],
		data	:	[
			{'text':'구매'	, 'value':'1'},
			{'text':'외주'	, 'value':'2'}
		]
	})

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		disabled: false,
		items	: [{ 
			fieldLabel	: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false
		},{
			fieldLabel		: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ORDER_DATE_FR',
			endFieldName	: 'ORDER_DATE_TO',
			startDate	: UniDate.get('threeMonthsAgo'),
			endDate		: UniDate.get('today')
		},{
			fieldLabel	: '<t:message code="system.label.sales.pono" default="발주번호"/>', 
			xtype		: 'uniTextfield',
			name		: 'PO_NUM',
			isteners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
		},{
				fieldLabel	: '<t:message code="system.label.purchase.classfication" default="구분"/>',
				name		: 'GUBUN',
				xtype		: 'uniCombobox',
				store		: gubunStore,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			},	
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>' ,
			valueFieldName: 'CUSTOM_CODE_FR',
			textFieldName: 'CUSTOM_NAME_FR',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
						if(Ext.isEmpty(newValue)) {
								panelResult.setValue('CUSTOM_CODE_FR', newValue);
								panelResult.setValue('CUSTOM_NAME_FR', newValue);
							}
					},
				onTextFieldChange: function(field, newValue){
					},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.sono" default="수주번호"/>',
			xtype		: 'uniTextfield',
			name		: 'ORDER_NUM'
		},{
			fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			name		: 'ITEM_ACCOUNT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},

		Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					validateBlank	: false,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							if(Ext.isEmpty(newValue)) {
								panelResult.setValue('ITEM_CODE', newValue);
								panelResult.setValue('ITEM_NAME', newValue);
							}
						},
						onTextFieldChange: function(field, newValue){
						},
						applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}			
		}),
		Unilite.popup('PROJECT',{
					fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
					valueFieldName:'PROJECT_NO',
					validateBlank	: false
			})
		]	
	});


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'mpo340ukrvService.selectList',
			update	: 'mpo340ukrvService.updateDetail',
			syncAll	: 'mpo340ukrvService.saveAll'
		}
	});

	/** Model 정의 
	 * @type
	 */
	Unilite.defineModel('Mpo340ukrvModel', {
		fields: [
		{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.classfication" default="구분"/>'				, type:'string'},
		{name: 'IN_DIV_CODE'		, text: '<t:message code="system.label.purchase.receiptdivision" default="입고사업장"/>'			, type:'string' , comboType: 'BOR120'},
		{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type:'string'},
		{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'				, type:'string'},
		{name: 'PO_NUM'				, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						, type:'string'},
		{name: 'ORDER_DATE'			, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'					, type:'uniDate'},
		{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'						, type:'int'},	
		{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.item" default="품목"/>'						, type:'string'},
		{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'					, type:'string'},
		{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'						, type:'string'},
		{name: 'ORDER_Q'			, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'						, type:'uniQty'},
		{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				, type:'uniQty'},
		{name: 'INIT_DVRY_DATE'		, text: '최초납기일'	 	,type: 'uniDate' },
		{name: 'DVRY_DATE'			, text: '변경납기일'	 	,type: 'uniDate'		,allowBlank:false},
		{name: 'REASON'				, text: '납기변경사유'	,type: 'string'	, comboType: 'AU', comboCode: 'Z019'		,allowBlank:false},
		{name: 'PROJECT_NO'			, text: '<t:message code="system.label.sales.project" default="프로젝트"/>'						, type:'string'},
		{name: 'PJT_NAME'			, text: '<t:message code="system.label.purchase.projectname" default="프로젝트명"/>'				, type:'string'},
		{name: 'SO_NUM'				, text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'						, type:'string'},
		{name: 'SO_CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.soplace" default="수주처"/>'					, type:'string'},
		{name: 'SO_ITEM_NAME'		, text: '<t:message code="system.label.purchase.soitemname" default="수주품목명"/>'				, type:'string'}
		
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('mpo340ukrvMasterStore1', {
		model	: 'Mpo340ukrvModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		//상위 버튼 연결 
			editable	: true,		//수정 모드 사용 
			deletable	: false,	//삭제 가능 여부 
			useNavi		: false		//prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(){
			var param = Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params	: param
			});	
		},
		saveStore: function(config) {
			var inValidRecs	= this.getInvalidRecords();
			if(inValidRecs.length == 0) {
				if(config == null) {
					config = {success : function() {
						masterStore.loadStoreRecords();
					}};
				}
				this.syncAllDirect(config);
			} else {
				 masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
	listeners: {
			load: function(store, records, successful, eOpts) {						//조회
				if(!Ext.isEmpty(records)){
				}
			},
			write: function(proxy, operation){										//추가
				if (operation.action == 'destroy') {
				}
			},
			remove: function( store, records, index, isMove, eOpts ) {				//삭제
				if(store.count() == 0) {
				}
			}
		}
	});

	/** Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('mpo340ukrvGrid1', {
		store	: masterStore,
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: true,
			expandLastColumn	: true,
			useRowNumberer		: true,
			dblClickToEdit		: true,
			useMultipleSorting	: true
			},
			columns:[
			{dataIndex:'ORDER_TYPE'			,width: 40},
			{dataIndex:'IN_DIV_CODE'		,width: 100},
			{dataIndex:'CUSTOM_CODE'		,width: 90},
			{dataIndex:'CUSTOM_NAME'		,width: 120},
			{dataIndex:'PO_NUM'				,width: 120},
			{dataIndex:'ORDER_DATE'			,width: 90},
			{dataIndex:'ORDER_SEQ'			,width: 80},
			{dataIndex:'ITEM_CODE'			,width: 200},
			{dataIndex:'ITEM_NAME'			,width: 200},
			{dataIndex:'SPEC'				,width: 200},
			{dataIndex:'ORDER_Q'			,width: 90 , summaryType: 'sum'},
			{dataIndex:'INSTOCK_Q'			,width: 90 , summaryType: 'sum'},
			{dataIndex:'INIT_DVRY_DATE'		,width: 100 },
			{dataIndex:'DVRY_DATE'			,width: 100 },
			{dataIndex:'REASON'				,width: 100 },
			{dataIndex:'PROJECT_NO'			,width: 95},
			{dataIndex:'PJT_NAME'			,width: 90},
			{dataIndex:'SO_NUM'				,width:100, hidden: false},
			{dataIndex:'SO_CUSTOM_NAME'		,width:100, hidden: false},
			{dataIndex:'SO_ITEM_NAME'		,width:150, hidden: false}
			
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (!e.record.phantom){
					if (UniUtils.indexOf(e.field, ['DVRY_DATE','REASON'])){
						return true;
					}
				}
				return false;
			}
		}
	});


	Unilite.Main({
		id			: 'mpo340ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		}],
		fnInitBinding: function(params) {
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_FR', UniDate.get('threeMonthsAgo'));
			panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));
			UniAppManager.setToolbarButtons(['reset'], true);

		},
		onQueryButtonDown: function() {									//조회버튼
		if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {									//신규버튼
			panelResult.clearForm();
			masterStore.loadData({});
			
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {						//저장버튼
			//필수 입력값 체크
			if (!panelResult.getInvalidMessage()) { 
				return false;
			}
			masterStore.saveStore(config);
		}
	
	});


};
</script>