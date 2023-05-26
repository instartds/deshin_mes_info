<%--
'	프로그램명 : 발주현황조회_외주통합 (구매)
'
'	작	성	자 : (주)포렌 개발실
'	작	성	일 :
'
'	최종수정자 :
'	최종수정일 :
'
'	버		전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo151rkrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo151rkrv" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />			<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" />			<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" />			<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="M002" />			<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" />			<!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />			<!-- 계정구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" />
	<t:ExtComboStore comboType="AU" comboCode="I008" />			<!-- 입고유무 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsOrderPrsn: '${gsOrderPrsn}'
};
function appMain() {

	var gubunStore = Unilite.createStore('gubunComboStore', {
		fields	: ['text', 'value'],
		data	:	[
			{'text':'구매', 'value':'1'},
			{'text':'외주', 'value':'2'}
		]
	});

	var printYnStore = Unilite.createStore('printYnComboStore', {
		fields	: ['text', 'value'],
		data	:	[
			{'text':'출력', 'value':'Y'},
			{'text':'미출력', 'value':'N'}
		]
	});


	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Mpo151rkrvModel', {
		fields: [
			{name:'ORDER_TYPE'		,text:'<t:message code="system.label.purchase.classfication" default="구분"/>'		,type: 'string'},
			{name:'ITEM_CODE'		,text:'<t:message code="system.label.purchase.item" default="품목"/>'					,type:'string'},
			{name:'ITEM_NAME'		,text:'<t:message code="system.label.purchase.itemname2" default="품명"/>'			,type:'string'},
			{name:'SPEC'			,text:'<t:message code="system.label.purchase.spec" default="규격"/>'					,type:'string'},
			{name:'CUSTOM_CODE'		,text:'<t:message code="system.label.purchase.custom" default="거래처"/>'				,type:'string', allowBlank : false},
			{name:'CUSTOM_NAME'		,text:'<t:message code="system.label.purchase.customname" default="거래처명"/>'		,type:'string'},
			{name:'PROJECT_NO'		,text:'<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		,type:'string'},
			{name:'PJT_NAME'		,text:'<t:message code="system.label.purchase.projectname" default="프로젝트명"/>'		,type:'string'},
			{name:'REMARK1'			,text:'<t:message code="system.label.purchase.remarks" default="비고"/>'				,type:'string'},
			{name:'ORDER_DATE'		,text:'<t:message code="system.label.purchase.podate" default="발주일"/>'				,type:'uniDate'},
			{name:'DVRY_DATE'		,text:'<t:message code="system.label.purchase.deliverydate" default="납기일"/>'		,type:'uniDate'},
			{name:'ORDER_Q'			,text:'<t:message code="system.label.purchase.poqty" default="발주량"/>'				,type:'uniQty'},
			{name:'ORDER_P'			,text:'<t:message code="system.label.purchase.pounitprice" default="발주단가"/>'		,type:'uniUnitPrice'},
			{name:'ORDER_O'			,text:'<t:message code="system.label.purchase.poamount" default="발주금액"/>'			,type:'uniPrice'},
			{name:'TEMP_INOUT_Q'	,text:'<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'			,type:'uniQty'},
			{name:'TEMP_INOUT_DATE'	,text:'<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'		,type:'uniDate'},
			{name:'INSTOCK_Q'		,text:'<t:message code="system.label.purchase.receiptqty" default="입고량"/>'			,type:'uniQty'},
			{name:'INSTOCK_O'		,text:'<t:message code="system.label.purchase.receiptamount" default="입고금액"/>'		,type:'uniPrice'},
			{name:'END_ORDER_Q'		,text:'<t:message code="system.label.purchase.endorderqty" default="마감량"/>'			,type:'uniQty'},
			{name:'END_ORDER_O'		,text:'<t:message code="system.label.purchase.endorderamt" default="마감금액"/>'		,type:'uniPrice'},
			{name:'AGREE_STATUS'	,text:'<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'		,type:'string',comboType:'AU' ,comboCode:'M007'},
			{name:'CONTROL_STATUS'	,text:'<t:message code="system.label.purchase.status" default="상태"/>'				,type:'string',comboType:'AU' ,comboCode:'M002'},
			{name:'ORDER_NUM'		,text:'<t:message code="system.label.purchase.pono" default="발주번호"/>'				,type:'string'},
			{name: 'IN_DIV_CODE'	,text: '<t:message code="system.label.purchase.receiptdivision" default="입고사업장"/>'	,type: 'string',  comboType: 'BOR120'},
			//20191029 추가: 수주번호, 수주처, 수주품목명
			{name: 'SO_NUM'			, text:'<t:message code="system.label.purchase.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'SO_CUSTOM_NAME'	, text:'<t:message code="system.label.purchase.soplace" default="수주처"/>'			, type: 'string'},
			{name: 'SO_ITEM_NAME'	, text:'<t:message code="system.label.purchase.soitemname" default="수주품목명"/>'		, type: 'string'},
			{name: 'PRINT_YN'		, text:'<t:message code="system.label.purchase.printyn" default="출력여부"/>'			, type: 'string', store : Ext.data.StoreManager.lookup('printYnComboStore')},
			{name: 'PRINT_YN2'		, text:'<t:message code="system.label.purchase.printyn2" default="구매계획서출력"/>'	, type: 'string', store : Ext.data.StoreManager.lookup('printYnComboStore')}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mpo151rkrvMasterStore1', {
		model: 'Mpo151rkrvModel',
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read: 'mpo151rkrvService.selectList',
				update: 'mpo151rkrvService.updateList',
				syncAll	: 'mpo151rkrvService.saveAll'
			}
		}),
		loadStoreRecords: function(){
			var param = Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore: function(config) {
			var inValidRecs = this.getInvalidRecords();
			var paramMaster = Ext.getCmp('resultForm').getValues();
			if(inValidRecs.length == 0) {
				config.params = [paramMaster]
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				//child:'WH_CODE',
				allowBlank: false,
				value:UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						//var field = panelResult.getField('ORDER_PRSN');
						//field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
						//var field2 = panelResult.getField('WH_CODE');
						//field2.getStore().clearFilter(true);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE_FR',
				textFieldName: 'CUSTOM_NAME_FR',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_CODE_FR', newValue);
								panelResult.setValue('CUSTOM_CODE_FR', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_NAME_FR', '');
									panelResult.setValue('CUSTOM_NAME_FR', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_NAME_FR', newValue);
								panelResult.setValue('CUSTOM_NAME_FR', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_CODE_FR', '');
									panelResult.setValue('CUSTOM_CODE_FR', '');
								}
							},
				            applyextparam: function(popup){
				                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
		                	}
					}
			}),{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name		: 'ORDER_TYPE',
				holdable	: 'hold',
				width		: 250,
				items		: [{
					boxLabel	: '<t:message code="system.label.purchase.domesticdeman" default="내수"/>',
					name		: 'ORDER_TYPE',
					inputValue	: '2',
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.sales.outsourcing" default="외주"/>',
					name		: 'ORDER_TYPE',
					inputValue	: '4'
				},{
					boxLabel	: '<t:message code="system.label.trade.import" default="수입"/>',
					name		: 'ORDER_TYPE',
					inputValue	: '6'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('ORDER_TYPE').setValue(newValue.ORDER_TYPE);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
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
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_CODE', newValue);
								panelResult.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_NAME', '');
									panelResult.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_NAME', newValue);
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_CODE', '');
									panelResult.setValue('ITEM_CODE', '');
								}
							},
						applyextparam: function(popup){	// 2021.08 표준화 작업
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			})]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			//child:'WH_CODE',
			allowBlank: false,
			value:UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					//var field = panelSearch.getField('ORDER_PRSN');
					//field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
					//var field2 = panelSearch.getField('WH_CODE');
					//field2.getStore().clearFilter(true);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName: 'CUSTOM_CODE_FR',
			textFieldName: 'CUSTOM_NAME_FR',
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('CUSTOM_CODE_FR', newValue);
							panelResult.setValue('CUSTOM_CODE_FR', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME_FR', '');
								panelResult.setValue('CUSTOM_NAME_FR', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('CUSTOM_NAME_FR', newValue);
							panelResult.setValue('CUSTOM_NAME_FR', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE_FR', '');
								panelResult.setValue('CUSTOM_CODE_FR', '');
							}
						},
			            applyextparam: function(popup){
			                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
			                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
			            	}
				}
		}),{
			fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank: false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_TO',newValue);
				}
			}
		},{
			text	: '<div style="color: red"><t:message code="system.label.purchase.printyn2" default="구매계획서출력"/></div>',
			xtype	: 'button',
			margin	: '0 0 0 20',
			disabled: false,
			handler	: function(){
				var param = panelResult.getValues();
				var selectedDetails = masterGrid.getSelectedRecords();
				if(Ext.isEmpty(selectedDetails)){
					Unilite.messageBox('<t:message code="system.message.sales.message140" default="출력할 데이터가 없습니다."/>');
					return;
				} else {
					Ext.each(selectedDetails, function(record, idx){
						record.set('PRINT_YN2', 'Y');
					})
				}
				if(directMasterStore1.isDirty())	{
					var config = {
							useSavedMessage	: false,
							success : function()	{
								param.PGM_ID= 'mpo151rkrv';
								param.MAIN_CODE= 'M030';
								param.ORDER_TYPE = panelResult.getValue('ORDER_TYPE').ORDER_TYPE;
								var orderNumList;
				
								Ext.each(selectedDetails, function(record, idx) {
									if(idx ==0) {
										orderNumList= record.get("ORDER_NUM");
										} else {
										orderNumList= orderNumList	+ ',' + record.get("ORDER_NUM");
									}
								});
				
								param["dataCount"] = selectedDetails.length;
								param["ORDER_NUM"] = orderNumList;
				
								var win = Ext.create('widget.ClipReport', {
									url: CPATH+'/matrl/mpo151_2clrkrv.do',
									prgID: 'mpo151rkrv',
									extParam: param
								});
								//win.center();
								win.show();
							}
					}
					directMasterStore1.saveStore(config)
				} else {
					param.PGM_ID= 'mpo151rkrv';
					param.MAIN_CODE= 'M030';
					param.ORDER_TYPE = panelResult.getValue('ORDER_TYPE').ORDER_TYPE;
					var orderNumList;
	
					Ext.each(selectedDetails, function(record, idx) {
						if(idx ==0) {
							orderNumList= record.get("ORDER_NUM");
							} else {
							orderNumList= orderNumList	+ ',' + record.get("ORDER_NUM");
						}
					});
	
					param["dataCount"] = selectedDetails.length;
					param["ORDER_NUM"] = orderNumList;
	
					var win = Ext.create('widget.ClipReport', {
						url: CPATH+'/matrl/mpo151_2clrkrv.do',
						prgID: 'mpo151rkrv',
						extParam: param
					});
					//win.center();
					win.show();
				}
			}
		},{
			text	: '<div style="color: red"><t:message code="system.label.purchase.popaperprint" default="발주서출력"/></div>',
			xtype	: 'button',
			width   : 100,
			margin	: '0 0 0 40',
			handler	: function(){
				var param = panelResult.getValues();
				var selectedDetails = masterGrid.getSelectedRecords();
				if(Ext.isEmpty(selectedDetails)){
					Unilite.messageBox('<t:message code="system.message.sales.message140" default="출력할 데이터가 없습니다."/>');
					return;
				} else {
					Ext.each(selectedDetails, function(record, idx){
						record.set('PRINT_YN', 'Y');
					})
				}
				if(directMasterStore1.isDirty())	{
					var config = {
							useSavedMessage	: false,
							success : function()	{
								param.PGM_ID= 'mpo151rkrv';
								param.MAIN_CODE= 'M030';
								param.ORDER_TYPE = panelResult.getValue('ORDER_TYPE').ORDER_TYPE;
								var orderNumList;
				
								Ext.each(selectedDetails, function(record, idx) {
									if(idx ==0) {
										orderNumList= record.get("ORDER_NUM");
										} else {
										orderNumList= orderNumList	+ ',' + record.get("ORDER_NUM");
									}
								});
				
								param["dataCount"] = selectedDetails.length;
								param["ORDER_NUM"] = orderNumList;
				
								var win = Ext.create('widget.ClipReport', {
									url: CPATH+'/matrl/mpo151_clrkrv.do',
									prgID: 'mpo151rkrv',
									extParam: param
								});
								win.show();
							}
					}
					directMasterStore1.saveStore(config);
				} else {
					param.PGM_ID= 'mpo151rkrv';
					param.MAIN_CODE= 'M030';
					param.ORDER_TYPE = panelResult.getValue('ORDER_TYPE').ORDER_TYPE;
					var orderNumList;
	
					Ext.each(selectedDetails, function(record, idx) {
						if(idx ==0) {
							orderNumList= record.get("ORDER_NUM");
							} else {
							orderNumList= orderNumList	+ ',' + record.get("ORDER_NUM");
						}
					});
	
					param["dataCount"] = selectedDetails.length;
					param["ORDER_NUM"] = orderNumList;
	
					var win = Ext.create('widget.ClipReport', {
						url: CPATH+'/matrl/mpo151_clrkrv.do',
						prgID: 'mpo151rkrv',
						extParam: param
					});
					win.show();
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_CODE', newValue);
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_NAME', newValue);
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}
						},
					applyextparam: function(popup){	// 2021.08 표준화 작업
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		}),{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name		: 'ORDER_TYPE',
			holdable	: 'hold',
			width		: 250,
			items		: [{
				boxLabel	: '<t:message code="system.label.purchase.domesticdeman" default="내수"/>',
				name		: 'ORDER_TYPE',
				inputValue	: '2',
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.sales.outsourcing" default="외주"/>',
				name		: 'ORDER_TYPE',
				inputValue	: '4'
			},{
				boxLabel	: '<t:message code="system.label.trade.import" default="수입"/>',
				name		: 'ORDER_TYPE',
				inputValue	: '6'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('ORDER_TYPE').setValue(newValue.ORDER_TYPE);
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('mpo151rkrvGrid1', {
		store: directMasterStore1,
		layout: 'fit',
		region: 'center',
		excelTitle: '<t:message code="system.label.purchase.postatusinquiry" default="발주현황조회"/>',
		uniOpt: {
			useGroupSummary: true,
			useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: false,
			onLoadSelectFirst: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true,
			dock: 'bottom'
		}],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
				}
			}
		}),
		viewConfig:{
			getRowClass : function(record,rowIndex,rowParams,store){
				var cls = '';
				if(record.get('CONTROL_STATUS')=="1"){	//발주중
					cls = 'x-change-cell_row1';
				}else if(record.get('CONTROL_STATUS')=="3"){	//계산서처리
					cls = 'x-change-cell_row2';
				}else if(record.get('CONTROL_STATUS')=="9"){	//마감
					cls = 'x-change-cell_row3';
				}
				return cls;
			}
		},
		columns: [
			{dataIndex:'ORDER_NUM'			,width: 150/*, align:'center'*/},		//20200409 수정: width(110 -> 150), 가운데정렬 주석
			{dataIndex:'ORDER_DATE'			,width: 90},
			{dataIndex:'CUSTOM_CODE'		,width: 90},
			{dataIndex:'CUSTOM_NAME'		,width: 120},
			{dataIndex:'ITEM_CODE'			,width: 200},
			{dataIndex:'DVRY_DATE'			,width: 90,hidden: true},
			{dataIndex:'ORDER_Q'			,width: 90, summaryType: 'sum'},
			{dataIndex:'ORDER_O'			,width: 90, summaryType: 'sum'},
			{dataIndex:'INSTOCK_Q'			,width: 90, summaryType: 'sum',hidden: true},
			{dataIndex:'INSTOCK_O'			,width: 90, summaryType: 'sum',hidden: true},
			{dataIndex:'PROJECT_NO'			,width: 90,hidden: true},
			{dataIndex:'PJT_NAME'			,width: 90,hidden: true},
			{dataIndex:'REMARK1'			,width: 170,hidden: true},
			{dataIndex:'TEMP_INOUT_Q'		,width: 90, summaryType: 'sum',hidden: true},
			{dataIndex:'TEMP_INOUT_DATE'	,width: 90,hidden: true},
			{dataIndex:'END_ORDER_Q'		,width: 90, summaryType: 'sum',hidden: true},
			{dataIndex:'END_ORDER_O'		,width: 90, summaryType: 'sum',hidden: true},
			{dataIndex:'AGREE_STATUS'		,width: 90, align:'center',hidden: true},
			{dataIndex:'CONTROL_STATUS'		,width: 90,hidden: true},
			//20191029 추가: 수주번호, 수주처, 수주품목명
			{ dataIndex: 'SO_NUM'			,width:100 ,hidden: true},
			{ dataIndex: 'SO_CUSTOM_NAME'	,width:150 ,hidden: true},
			{ dataIndex: 'SO_ITEM_NAME'		,width:200 ,hidden: true},
			{ dataIndex: 'PRINT_YN'			,width:100 , align: 'center', hidden: false},
			{ dataIndex: 'PRINT_YN2'		,width:100 , align: 'center', hidden: false}
		],
		listeners:{
		}
	});



	Unilite.Main({
		id: 'mpo151rkrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		setDefault: function() {
			panelSearch.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('ORDER_DATE_TO',UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO',UniDate.get('today'));
			panelSearch.setValue('DIV_CODE'		,UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		,UserInfo.divCode);
		},
		fnInitBinding: function() {
			panelSearch.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('ORDER_DATE_TO',UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO',UniDate.get('today'));
			panelSearch.setValue('DIV_CODE'		,UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		,UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown: function() {
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		onPrintButtonDown: function(){
		}
	});
};
</script>