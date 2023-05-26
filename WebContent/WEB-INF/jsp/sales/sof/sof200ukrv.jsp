<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof200ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="S011" /> <!--마감여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!-- 영업담당 -->	  
	<t:ExtComboStore comboType="BOR120" pgmId="sof200ukrv"  /><!-- 사업장 -->		
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>

<script type="text/javascript" >
/**
 * 수주마감 등록
 */
function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {		
			read	: 'sof200ukrvService.selectDetailList',
			update  : 'sof200ukrvService.updateDetail',
			syncAll : 'sof200ukrvService.saveAll'
		}
	});
	/**
	 * Model 정의 
	 */
	Unilite.defineModel('Sof200ukrvModel', {		
		fields: [{name: 'ORDER_STATUS'		,text: '<t:message code="system.label.sales.closingyn" default="마감여부"/>' 			,type: 'string', comboType: 'AU', comboCode: 'S011' },			
				 {name: 'ORDER_DATE'		,text: '<t:message code="system.label.sales.sodate" default="수주일"/>' 			,type: 'uniDate'},			
				 {name: 'CUSTOM_CODE2'		,text: '<t:message code="system.label.sales.client" default="고객"/>'			,type: 'string'},			
				 {name: 'CUSTOM_NAME2'		,text: '<t:message code="system.label.sales.clientname" default="고객명"/>'			,type: 'string'},			
				 {name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string'},			
				 {name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'},			
				 {name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'				,type: 'string'},			
				 {name: 'ORDER_UNIT'		,text: '<t:message code="system.label.sales.unit" default="단위"/>'				,type: 'string', displayField: 'value'},			
				 {name: 'TRANS_RATE'		,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				,type: 'uniQty'},			
				 {name: 'ORDER_UNIT_Q'		,text: '<t:message code="system.label.sales.soqty" default="수주량"/>'			,type: 'uniQty'},			
				 {name: 'ISSUE_REQ_Q'		,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'			,type: 'uniQty'},			
				 {name: 'OUTSTOCK_Q'		,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>'			,type: 'uniQty'},			
				 {name: 'RETURN_Q'			,text: '<t:message code="system.label.sales.returnqty" default="반품량"/>'			,type: 'uniQty'},			
				 {name: 'ORDER_REM_Q'		,text: '<t:message code="system.label.sales.undeliveryqty" default="미납량"/>'			,type: 'uniQty'},			
				 {name: 'SALE_Q'			,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'			,type: 'uniQty'},			
				 {name: 'STOCK_UNIT'		,text: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'			,type: 'string', displayField: 'value'},			
				 {name: 'STOCK_Q'			,text: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/><t:message code="system.label.sales.soqty" default="수주량"/>'		,type: 'uniQty'},			
				 {name: 'MONEY_UNIT'		,text: '<t:message code="system.label.sales.currency" default="화폐"/>'				,type: 'string'},			
				 {name: 'ORDER_P'			,text: '<t:message code="system.label.sales.price" default="단가"/>'				,type: 'uniUnitPrice'},			
				 {name: 'ORDER_O'			,text: '<t:message code="system.label.sales.soamount" default="수주액"/>'			,type: 'uniPrice'},			
				 {name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'				,type: 'uniER'},			
				 {name: 'SO_AMT_WON'		,text: '<t:message code="system.label.sales.exchangeamount" default="환산액"/>'			,type: 'uniPrice'},			
				 {name: 'TAX_TYPE'			,text: '<t:message code="system.label.sales.taxationyn" default="과세여부"/>'			,type: 'string'},			
				 {name: 'ORDER_TAX_O'		,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'				,type: 'uniPrice'},		
				 
				 //20170831-추가
				 {name: 'CLOSE_REMARK'		,text: '<t:message code="system.label.sales.closingreason" default="마감사유"/>'			,type: 'string'},			
				 {name: 'CLOSE_ID'			,text: '<t:message code="system.label.sales.closinguser" default="마감사용자"/>'			,type: 'string'},			
				 {name: 'CLOSE_DATE'		,text: '<t:message code="system.label.sales.clostingdate2" default="마감일시"/>'			,type: 'uniDate'},		
				 {name: 'CLOSE_REMARK_bak'	,text: '<t:message code="system.label.sales.closingreason" default="마감사유"/>'			,type: 'string'},	
				 {name: 'CLOSE_ID_bak'		,text: '<t:message code="system.label.sales.closinguser" default="마감사용자"/>'			,type: 'string'},	
				 {name: 'CLOSE_DATE_bak'	,text: '<t:message code="system.label.sales.clostingdate2" default="마감일시"/>'			,type: 'uniDate'},
				 
				 {name: 'ORDER_TYPE'		,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'			,type: 'string', comboType: 'AU', comboCode: 'S002'},			
				 {name: 'ORDER_TYPE_NM'		,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'			,type: 'string'},			
				 {name: 'ORDER_NUM'			,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'			,type: 'string'},			
				 {name: 'SER_NO'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'				,type: 'string'},			
				 {name: 'ORDER_PRSN'		,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			,type: 'string', comboType: 'AU', comboCode: 'S010'},			
				 {name: 'ORDER_PRSN_NM'		,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			,type: 'string'},			
				 {name: 'PO_NUM'			,text: '<t:message code="system.label.sales.pono2" default="P/O 번호"/>'			,type: 'string'},			
				 {name: 'DVRY_DATE2'		,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'			,type: 'uniDate'},			
				 {name: 'PROD_END_DATE'		,text: '<t:message code="system.label.sales.productionfinishrequestdate" default="생산완료요청일"/>'		,type: 'uniDate'},			
				 {name: 'PROD_Q'			,text: '<t:message code="system.label.sales.productionrequestqty" default="생산요청량"/>'			,type: 'uniQty'},			
				 {name: 'OUT_DIV_CODE'		,text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'			,type: 'string', comboType: 'BOR120'},
				 {name: 'SORT_KEY'			,text: 'SORT_KEY'		,type: 'string'},			
				 {name: 'UPDATE_DB_USER'	,text: '<t:message code="system.label.sales.updateuser" default="수정자"/>'			,type: 'string'},			
				 {name: 'UPDATE_DB_TIME'	,text: '<t:message code="system.label.sales.updatedate" default="수정일"/>'			,type: 'uniDate'}				 
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 */					
	var detailStore = Unilite.createStore('sof200ukrvDetailStore1',{
			model: 'Sof200ukrvModel',
			uniOpt : {
				isMaster	: true,			// 상위 버튼 연결 
				editable	: true,			// 수정 모드 사용 
				deletable  : false,			// 삭제 가능 여부 
				useNavi	: false			// prev | next 버튼 사용
			},
			autoLoad : false,
			proxy	: directProxy,
			loadStoreRecords : function()	{
				var param= masterForm.getValues();			
				console.log(param);
				this.load({
					params : param
				});				
			},
			saveStore: function() {				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				
				var that = this;
				config = {
					params: [masterForm.getValues()],
					success: function(batch, option) {
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.app.onQueryButtonDown();
					} 
				};
				this.syncAllDirect(config);
			}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 */
	var masterForm = Unilite.createSearchPanel('searchForm', {		
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType : 'uniSearchSubPanel',
		collapsed:true,
		width:380,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{	
			title		: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
				itemId	  : 'search_panel1',
				layout	  : {type: 'uniTable', columns: 1},
				defaultType : 'uniTextfield',
			items : [{					
				fieldLabel : '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype	  : 'uniCombobox',
				comboType  : 'BOR120',
				allowBlank : false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
						}
					}				
			}, { 
				fieldLabel	 : '<t:message code="system.label.sales.sodate" default="수주일"/>',
				xtype		  : 'uniDateRangefield',
				startFieldName : 'ORDER_DATE_FR',
				endFieldName	: 'ORDER_DATE_TO',
				width		  : 470,
				startDate	  : UniDate.get('startOfMonth'),
				endDate		: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_TO',newValue);
					}
				}
			}, {
				fieldLabel	 : '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name			: 'ORDER_PRSN', 
				xtype		  : 'uniCombobox', 
				comboType	  : 'AU',
				comboCode	  : 'S010',
				listeners : {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
				name		: 'OUT_DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('OUT_DIV_CODE', newValue);
						}
					}
				},
			Unilite.popup('AGENT_CUST',{
				fieldLabel	 : '<t:message code="system.label.sales.custom" default="거래처"/>', 
				valueFieldName : 'CUSTOM_CODE', 
				textFieldName  : 'CUSTOM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_CODE', newValue);

						if(!Ext.isObject(oldValue)) {
							masterForm.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_NAME', newValue);

						if(!Ext.isObject(oldValue)) {
							masterForm.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_CODE', '');
						}
					}
				}
			}),
			Unilite.popup('DIV_PUMOK',{
				fieldLabel	 : '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName : 'ITEM_CODE', 
				textFieldName  : 'ITEM_NAME', 
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_CODE', newValue);
						
						if(!Ext.isObject(oldValue)) {
							masterForm.setValue('ITEM_NAME', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_NAME', newValue);
						
						if(!Ext.isObject(oldValue)) {
							masterForm.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel : '<t:message code="system.label.sales.closingyn" default="마감여부"/>',
				name		: 'ORDER_STATUS', 
				xtype	  : 'uniCombobox', 
				comboType  : 'AU',
				comboCode  : 'S011',
				listeners  : {
					change : function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_STATUS', newValue);
					}
				}
				
			}, {
				fieldLabel : '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name		: 'ORDER_TYPE',
				xtype	  : 'uniCombobox',
				comboType  : 'AU',
				comboCode  : 'S002',
				listeners  : {
					change : function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel : '<t:message code="system.label.sales.sono" default="수주번호"/>',
				xtype	  : 'uniTextfield',
				name		: 'ORDER_NUM_FR',
				listeners  : {
					change : function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_NUM_FR', newValue);
					}
				}
			},{
				fieldLabel : '~',
				xtype	  : 'uniTextfield',
				name		: 'ORDER_NUM_TO',
				listeners  : {
					change : function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_NUM_TO', newValue);
					}
				}
			}, {
				xtype	  : 'radiogroup',
				fieldLabel : ' ',				
				items : [{
					boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
					name		: 'RDO_SELECT',
					inputValue : '1',
					width	  : 70
				}, {
					boxLabel	: '<t:message code="system.label.sales.issuecomplateexclusive" default="출고완료 미포함"/>',
					name		: 'RDO_SELECT' ,
					inputValue : '2',
					width	  : 150,
					checked	: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(panelResult){
							panelResult.getField('RDO_SELECT').setValue(newValue.RDO_SELECT);
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			}]		
		}, {	
			title		: '<t:message code="system.label.sales.etcinfo" default="기타정보"/>',
				itemId	  : 'search_panel2',
				layout	  : {type: 'uniTable', columns: 1},
				defaultType : 'uniTextfield',
			items : [{ 
				fieldLabel	 : '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
				xtype		  : 'uniDateRangefield',
				startFieldName : 'DVRY_DATE_FR',
				endFieldName	: 'DVRY_DATE_TO',
				width		  : 470
			}]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1 1',
		border:true,
		items: [{					
				fieldLabel : '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype	  : 'uniCombobox',
				comboType  : 'BOR120',
				allowBlank : false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {							
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
				
			}, { 
				fieldLabel	 : '<t:message code="system.label.sales.sodate" default="수주일"/>',
				xtype		  : 'uniDateRangefield',
				startFieldName : 'ORDER_DATE_FR',
				endFieldName	: 'ORDER_DATE_TO',
				width		  : 470,
				colspan		: 2,
				startDate	  : UniDate.get('startOfMonth'),
				endDate		: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(masterForm) {
						masterForm.setValue('ORDER_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(masterForm) {
						masterForm.setValue('ORDER_DATE_TO',newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel	 : '<t:message code="system.label.sales.custom" default="거래처"/>', 
				valueFieldName : 'CUSTOM_CODE', 
				textFieldName  : 'CUSTOM_NAME',
				colspan		: 2,
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						masterForm.setValue('CUSTOM_CODE', newValue);

						if(!Ext.isObject(oldValue)) {
							masterForm.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						masterForm.setValue('CUSTOM_NAME', newValue);

						if(!Ext.isObject(oldValue)) {
							masterForm.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_CODE', '');
						}
					}
				}
			}),{
				fieldLabel	 : '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name			: 'ORDER_PRSN', 
				xtype		  : 'uniCombobox', 
				comboType	  : 'AU',
				comboCode	  : 'S010',
				listeners : {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('ORDER_PRSN', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel	 : '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName : 'ITEM_CODE', 
				textFieldName  : 'ITEM_NAME',
				validateBlank	: false,
				colspan		: 2,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						masterForm.setValue('ITEM_CODE', newValue);
						
						if(!Ext.isObject(oldValue)) {
							masterForm.setValue('ITEM_NAME', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						masterForm.setValue('ITEM_NAME', newValue);
						
						if(!Ext.isObject(oldValue)) {
							masterForm.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel : '<t:message code="system.label.sales.closingyn" default="마감여부"/>',
				name		: 'ORDER_STATUS', 
				xtype	  : 'uniCombobox', 
				comboType  : 'AU',
				comboCode  : 'S011',
				colspan		: 2,
				listeners  : {
					change : function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('ORDER_STATUS', newValue);
					}
				}
			},{
				fieldLabel : '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name		: 'ORDER_TYPE',
				xtype	  : 'uniCombobox',
				comboType  : 'AU',
				comboCode  : 'S002',
				listeners  : {
					change : function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel : '<t:message code="system.label.sales.sono" default="수주번호"/>',
				xtype	  : 'uniTextfield',
				name		: 'ORDER_NUM_FR',
				listeners  : {
					change : function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('ORDER_NUM_FR', newValue);
					}
				}
			}, {
				fieldLabel : '~',
				xtype	  : 'uniTextfield',
				name		: 'ORDER_NUM_TO',
				labelWidth : 10,
				listeners  : {
					change : function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('ORDER_NUM_TO', newValue);
					}
				}
			},{
				xtype	  : 'radiogroup',
				fieldLabel : ' ',
				items : [{
					boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
					name		: 'RDO_SELECT',
					inputValue : '1',
					width	  : 70
				}, {
					boxLabel	: '<t:message code="system.label.sales.issuecomplateexclusive" default="출고완료 미포함"/>',
					name		: 'RDO_SELECT' ,
					inputValue : '2',
					width	  : 150,
					checked	: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(masterForm){
							masterForm.getField('RDO_SELECT').setValue(newValue.RDO_SELECT);
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
				name		: 'OUT_DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
			//	multiSelect: true,
			//	typeAhead: false,				
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						masterForm.setValue('OUT_DIV_CODE', newValue);
					}
				}
			}]
	});
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 */
	var masterGrid = Unilite.createGrid('sof200ukrvGrid1', {
		// for tab		
		layout : 'fit',
		region : 'center',
		store  : detailStore,
		uniOpt : {
		 useLiveSearch	  : true,
		 expandLastColumn  : false,
		 onLoadSelectFirst : false
		},
		selModel :  Ext.create('Ext.selection.CheckboxModel', {checkOnly : true, toggleOnClick:false}),
		columns:  [{ dataIndex: 'ORDER_STATUS'	, 				width: 63, locked: true, readOnly: true},  
					{ dataIndex: 'ORDER_DATE'	 , 				width: 93, locked: true},  
					{ dataIndex: 'CUSTOM_CODE2'	, 				width: 70 ,hidden:true},  
					{ dataIndex: 'CUSTOM_NAME2'	, 				width: 130, locked: true},  
					{ dataIndex: 'ITEM_CODE'	  , 			width: 120, locked: true},  
					{ dataIndex: 'ITEM_NAME'	  , 			width: 150, locked: true},  
					{ dataIndex: 'SPEC'			, 				width: 120, locked: true},  
					{ dataIndex: 'ORDER_UNIT'	 , 				width: 70, align:'center'},  
					{ dataIndex: 'TRANS_RATE'	 , 				width: 53},  
					{ dataIndex: 'ORDER_UNIT_Q'	, 				width: 80},  
					{ dataIndex: 'ISSUE_REQ_Q'	, 				width: 90},  
					{ dataIndex: 'OUTSTOCK_Q'	 , 				width: 80},  
					{ dataIndex: 'RETURN_Q'		, 				width: 80},  
					{ dataIndex: 'ORDER_REM_Q'	, 				width: 80},  
					{ dataIndex: 'SALE_Q'		 , 				width: 80},  
					{ dataIndex: 'STOCK_UNIT'	 , 				width: 70  ,hidden:true},  
					{ dataIndex: 'STOCK_Q'		, 				width: 100 ,hidden:true},  
					{ dataIndex: 'MONEY_UNIT'	 , 				width: 53  ,hidden:true},  
					{ dataIndex: 'ORDER_P'		, 				width: 110 },  
					{ dataIndex: 'ORDER_O'		, 				width: 110 },  
					{ dataIndex: 'EXCHG_RATE_O'	, 				width: 66 ,hidden:true},  
					{ dataIndex: 'SO_AMT_WON'	 , 				width: 100},  
					{ dataIndex: 'TAX_TYPE'		, 				width: 66, align:'center'},  
					{ dataIndex: 'ORDER_TAX_O'	, 				width: 86},
					
					//20170831 - 추가
					{ dataIndex: 'CLOSE_REMARK'	 , 				width: 120},  
					{ dataIndex: 'CLOSE_ID'		, 				width: 80},  
					{ dataIndex: 'CLOSE_DATE'	, 				width: 93},
					
					{ dataIndex: 'ORDER_TYPE'	 , 				width: 100,hidden:true},  
					{ dataIndex: 'ORDER_TYPE_NM'  , 			width: 120},  
					{ dataIndex: 'ORDER_NUM'	  , 			width: 120},  
					{ dataIndex: 'SER_NO'		 , 				width: 53},
					{ dataIndex: 'ORDER_PRSN'	 , 				width: 80 ,hidden:true},
					{ dataIndex: 'ORDER_PRSN_NM'  , 			width: 80},
					{ dataIndex: 'PO_NUM'		 , 				width: 110},
					{ dataIndex: 'DVRY_DATE2'	 , 				width: 93},
					{ dataIndex: 'PROD_END_DATE'  , 			width: 100},
					{ dataIndex: 'PROD_Q'		 , 				width: 100},
					{ dataIndex: 'OUT_DIV_CODE'	 , 				width: 50 ,hidden:true},
					{ dataIndex: 'SORT_KEY'		, 				width: 10 ,hidden:true},
					{ dataIndex: 'UPDATE_DB_USER' , 			width: 66 ,hidden:true},
					{ dataIndex: 'UPDATE_DB_TIME' , 			width: 93 ,hidden:true }					
		],
		listeners: { 
			select: function(grid, record, index, eOpts ){
				record.set('ORDER_STATUS'	, record.get("ORDER_STATUS") == 'Y'?	'N'	: 'Y');
				if(record.get("ORDER_STATUS") == 'Y') {
					if(!Ext.isEmpty(record.get('CLOSE_REMARK_bak'))) {
						record.set('CLOSE_REMARK'	, record.get('CLOSE_REMARK_bak'));
					} else {
						record.set('CLOSE_REMARK'	, '');
					}
					
					if(!Ext.isEmpty(record.get('CLOSE_ID_bak'))) {
						record.set('CLOSE_ID'	, record.get('CLOSE_ID_bak'));
					} else {
						record.set('CLOSE_ID'		, UserInfo.userID);
					}
					
					if(!Ext.isEmpty(record.get('CLOSE_DATE_bak'))) {
						record.set('CLOSE_DATE'	, record.get('CLOSE_DATE_bak'));
					} else {
						record.set('CLOSE_DATE'		, new Date());
					}
					
				} else {
					if(!Ext.isEmpty(record.get('CLOSE_REMARK'))) {
						record.set('CLOSE_REMARK_bak'	, record.get('CLOSE_REMARK'));
					}
					if(!Ext.isEmpty(record.get('CLOSE_ID'))) {
						record.set('CLOSE_ID_bak'	, record.get('CLOSE_ID'));
					}
					if(!Ext.isEmpty(record.get('CLOSE_DATE'))) {
						record.set('CLOSE_DATE_bak'	, record.get('CLOSE_DATE'));
					}
					record.set('CLOSE_REMARK'	, '');
					record.set('CLOSE_ID'		, '');
					record.set('CLOSE_DATE'		, '');
				}
			},
			deselect:  function(grid, record, index, eOpts ){
				record.set('ORDER_STATUS'	, record.get("ORDER_STATUS") == 'Y'?	'N'	: 'Y');
				if(record.get("ORDER_STATUS") == 'N') {
					if(!Ext.isEmpty(record.get('CLOSE_REMARK'))) {
						record.set('CLOSE_REMARK_bak'	, record.get('CLOSE_REMARK'));
					}
					if(!Ext.isEmpty(record.get('CLOSE_ID'))) {
						record.set('CLOSE_ID_bak'	, record.get('CLOSE_ID'));
					}
					if(!Ext.isEmpty(record.get('CLOSE_DATE'))) {
						record.set('CLOSE_DATE_bak'	, record.get('CLOSE_DATE'));
					}
					record.set('CLOSE_REMARK'	, '');
					record.set('CLOSE_ID'		, '');
					record.set('CLOSE_DATE'		, '');
					
				} else {
					if(!Ext.isEmpty(record.get('CLOSE_REMARK_bak'))) {
						record.set('CLOSE_REMARK'	, record.get('CLOSE_REMARK_bak'));
					} else {
						record.set('CLOSE_REMARK'	, '');
					}
					
					if(!Ext.isEmpty(record.get('CLOSE_ID_bak'))) {
						record.set('CLOSE_ID'	, record.get('CLOSE_ID_bak'));
					} else {
						record.set('CLOSE_ID'		, UserInfo.userID);
					}
					
					if(!Ext.isEmpty(record.get('CLOSE_DATE_bak'))) {
						record.set('CLOSE_DATE'	, record.get('CLOSE_DATE_bak'));
					} else {
						record.set('CLOSE_DATE'		, new Date());
					}
				}
			},
	 		beforeedit  : function( editor, e, eOpts ) {
	 			if(e.record.data.ORDER_STATUS == 'Y' && this.getSelectionModel().isSelected(e.record) == true) {
		 			if (UniUtils.indexOf(e.field, ['CLOSE_REMARK'])){
						return true;
					} else {
		 				return false;
		 			}
	 			} else {
	 				return false;
	 			}
	 		}
		}
		
	}); 
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid,
				panelResult
			] 
		},masterForm],
		id  : 'sof200ukrvApp',
		fnInitBinding : function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			masterForm.setValue('ORDER_DATE_TO',UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_TO',UniDate.get('today'));
			masterForm.setValue('ORDER_STATUS','N');
			panelResult.setValue('ORDER_STATUS','N');
			/*masterForm.getField('RDO_SELECT').setValue('1');
			panelResult.getField('RDO_SELECT').setValue('2');*/
			UniAppManager.setToolbarButtons(['detail','reset'],false);
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('save',false);	
			masterForm.setValue('OUT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('OUT_DIV_CODE',UserInfo.divCode);
		
		},
		onQueryButtonDown : function()	{
			masterGrid.getStore().loadStoreRecords();
		},
		onSaveDataButtonDown : function() {
			detailStore.saveStore();
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterGrid.getStore().clearData();
			this.fnInitBinding();
		}
	});
};
</script>