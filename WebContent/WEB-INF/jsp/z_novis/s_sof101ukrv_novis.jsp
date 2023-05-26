<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sof101ukrv_novis"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_sof101ukrv_novis" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />					<!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" />					<!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="S065" />					<!--주문구분-->
	<t:ExtComboStore comboType="AU" comboCode="B055" />					<!-- 거래처분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_sof101ukrv_novisService.selectList',
			update	: 's_sof101ukrv_novisService.updateDetail',
//			create	: 's_sof101ukrv_novisService.insertDetail',
//			destroy	: 's_sof101ukrv_novisService.deleteDetail',
			syncAll	: 's_sof101ukrv_novisService.saveAll'
		}
	});



	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_sof101ukrv_novisModel', {
		fields: [
			{name: 'COMP_CODE'		,text:'COMP_CODE'	,type:'string'},
			{name: 'DIV_CODE'		,text:'DIV_CODE'	,type:'string'},
			{name: 'ORDER_DATE'		,text:'수주일자'		,type:'uniDate'},
			{name: 'CUSTOM_CODE'	,text:'<t:message code="system.label.sales.custom" default="거래처"/>'			,type:'string'},
			{name: 'CUSTOM_NAME'	,text:'<t:message code="system.label.sales.customname" default="거래처명"/>'	,type:'string'},
			{name: 'ITEM_CODE'		,text:'<t:message code="system.label.sales.item" default="품목"/>'			,type:'string'},
			{name: 'ITEM_NAME'		,text:'<t:message code="system.label.sales.itemname" default="품목명"/>'		,type:'string'},
			{name: 'SPEC'			,text:'<t:message code="system.label.sales.spec" default="규격"/>'			,type:'string'},
			{name: 'ORDER_UNIT'		,text:'<t:message code="system.label.sales.unit" default="단위"/>'			,type:'string', displayField: 'value'},
			{name: 'TRANS_RATE'		,text:'<t:message code="system.label.sales.containedqty" default="입수"/>'	,type:'string'},
			{name: 'DVRY_DATE'		,text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'	,type:'uniDate'},
			{name: 'INIT_DVRY_DATE'	,text:'최초납기일'		,type: 'uniDate'},
			{name: 'ORDER_Q'		,text:'<t:message code="system.label.sales.soqty" default="수주량"/>'			,type:'uniQty'},
			{name: 'ORDER_P'		,text:'단가'			,type:'uniUnitPrice'},
			{name: 'ORDER_O'		,text:'금액'			,type:'uniPrice'},
			{name: 'ORDER_TAX_O'	,text:'부가세'			,type:'uniPrice'},
			{name: 'TOT_ORDER_TAX_O',text:'합계금액'		,type:'uniPrice'},
			{name: 'INOUT_Q'		,text:'<t:message code="system.label.sales.issueqty" default="출고량"/>'		,type:'uniQty'},
			{name: 'INOUT_P'		,text:'<t:message code="system.label.sales.issueprice" default="출고단가"/>'	,type:'uniUnitPrice'},
			{name: 'INOUT_I'		,text:'출고액'			,type:'uniPrice'},
			{name: 'RETURN_Q'		,text:'<t:message code="system.label.sales.returnqty" default="반품량"/>'		,type:'uniQty'},
			{name: 'RETURN_P'		,text:'반품단가'		,type:'uniUnitPrice'},
			{name: 'RETURN_I'		,text:'반품액'			,type:'uniPrice'},
			{name: 'SALE_Q'			,text:'<t:message code="system.label.sales.salesqty" default="매출량"/>'		,type:'uniQty'},
			{name: 'SALE_P'			,text:'매출단가'		,type:'uniUnitPrice'},
			{name: 'SALE_AMT_O'		,text:'<t:message code="system.label.sales.salesamount" default="매출액"/>'	,type:'uniPrice'},
			{name: 'ORDER_TYPE'		,text:'<t:message code="system.label.sales.sellingtype" default="판매유형"/>'	,type:'string',comboType:'AU', comboCode:'S002'},
			{name: 'SO_KIND'		,text:'<t:message code="system.label.sales.ordertype" default="주문구분"/>'		,type:'string',comboType:'AU', comboCode:'S065'},
			{name: 'ORDER_PRSN'		,text:'<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,type:'string',comboType:'AU', comboCode:'S010'},
			{name: 'ORDER_NUM'		,text:'<t:message code="system.label.sales.sono" default="수주번호"/>'			,type:'string'},
			{name: 'SER_NO'			,text:'<t:message code="system.label.sales.seq" default="순번"/>'				,type:'integer'},
			{name: 'STATUS'			,text:'상태'			,type:'string',comboType:'AU', comboCode:'S046'},
			{name: 'ORDER_STATUS_NM',text:'<t:message code="system.label.sales.closingyn" default="마감여부"/>'		,type:'string'},
			{name: 'REMARK'			,text:'비고'			,type:'string'},
			{name: 'REASON1'		,text:'특이사항'		,type:'string'},
			{name: 'REASON2'		,text:'원료'			,type:'string'},
			{name: 'REASON3'		,text:'부자재'			,type:'string'},
			{name: 'REASON4'		,text:'기타'			,type:'string'},
			//	제재
			{name: 'PLAN_DATE1'		,text:'계획'			,type:'uniDate'},
			{name: 'COMP_DATE1'		,text:'완료'			,type:'uniDate'},
			//	품목허가
			{name: 'PLAN_DATE2'		,text:'계획'			,type:'uniDate'},
			{name: 'COMP_DATE2'		,text:'완료'			,type:'uniDate'},
			//	광고심의
			{name: 'PLAN_DATE3'		,text:'계획'			,type:'uniDate'},
			{name: 'COMP_DATE3'		,text:'완료'			,type:'uniDate'},
			//	원료입고
			{name: 'PLAN_DATE4'		,text:'계획'			,type:'uniDate'},
			{name: 'COMP_DATE4'		,text:'완료'			,type:'uniDate'},
			//	부자재입고
			{name: 'PLAN_DATE5'		,text:'계획'			,type:'uniDate'},
			{name: 'COMP_DATE5'		,text:'완료'			,type:'uniDate'},
			//	기타
			{name: 'PLAN_DATE6'		,text:'계획'			,type:'uniDate'},
			{name: 'COMP_DATE6'		,text:'완료'			,type:'uniDate'},
			//	생산
			{name: 'PLAN_DATE7'		,text:'계획'			,type:'uniDate'},
			{name: 'COMP_DATE7'		,text:'완료'			,type:'uniDate'},
			//	자가품질
			{name: 'PLAN_DATE8'		,text:'계획'			,type:'uniDate'},
			{name: 'COMP_DATE8'		,text:'완료'			,type:'uniDate'},
			//	출고
			{name: 'PLAN_DATE9'		,text:'계획'			,type:'uniDate'},
			{name: 'COMP_DATE9'		,text:'완료'			,type:'uniDate'},
			//	예비컬럼
			{name: 'PLAN_DATE10'	,text:'계획'			,type:'uniDate'},
			{name: 'COMP_DATE10'	,text:'완료'			,type:'uniDate'},
			{name: 'REASON'			,text:'납기변경사유'		,type:'string'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('s_sof101ukrv_novisMasterStore1',{
		model	: 's_sof101ukrv_novisModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: directProxy,
		loadStoreRecords: function() {
			var param = panelSearch.getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore: function() {
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);
			console.log("list:", list);

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	// syncAll 수정
			
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						//기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);

						UniAppManager.app.onQueryButtonDown();

						if(directMasterStore.getCount() == 0) {
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('scn100ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});



	/** 검색조건 (Search Panel)
	 * @type 
	 */
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
		items		: [{
			title	: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId	: 'search_panel1',
			layout	: {type: 'vbox', align: 'stretch'},
			items	: [{
				xtype	: 'container',
				layout	: {type:'uniTable', columns:1},
				items	: [{
					fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
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
					fieldLabel		: '<t:message code="system.label.sales.sodate" default="수주일"/>',
					xtype			: 'uniDateRangefield',
					startFieldName	: 'ORDER_DATE_FR',
					endFieldName	: 'ORDER_DATE_TO',
					allowBlank		: false,
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('ORDER_DATE_FR', newValue);
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('ORDER_DATE_TO', newValue);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
					name		: 'TXT_ORDER_TYPE',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'S002',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TXT_ORDER_TYPE', newValue);
						}
					}
				},{
					xtype		: 'radiogroup',
					fieldLabel	: '<t:message code="system.label.base.classfication" default="구분"/>',
					itemId		: 'COMPLETE_YN',
					items		: [{
						boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
						name		: 'COMPLETE_YN',
						inputValue	: 'A',
						width		: 60
					},{
						boxLabel	: '<t:message code="system.label.sales.completion" default="완료"/>',
						name		: 'COMPLETE_YN',
						inputValue	: 'Y',
						width		: 60
					},{
						boxLabel	: '<t:message code="system.label.sales.incompleted" default="미완료"/>',
						name		: 'COMPLETE_YN' ,
						inputValue	: 'N',
						width		: 80,
						checked		: true
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('COMPLETE_YN', newValue.COMPLETE_YN);
						}
					}
				},
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
					name			: 'CUSTOM_CODE',
					validateBlank	: false,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('CUSTOM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('CUSTOM_NAME', newValue);
						}
					}
				}),
				Unilite.popup('DIV_PUMOK',{
					fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
					name			: 'ITEM_CODE',
					validateBlank	: false,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ITEM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ITEM_NAME', newValue);
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
				})]
			}]
		},{
			title		: '<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id			: 'search_panel2',
			itemId		: 'search_panel2',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [
				Unilite.popup('DEPT',{
					fieldLabel		: '<t:message code="system.label.sales.department" default="부서"/>',
					valueFieldName	: 'DEPT_CODE',
					textFieldName	: 'DEPT_NAME'
			}),{
				fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name		: 'ORDER_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010'
			},{
				fieldLabel	: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
				name		: 'AGENT_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B055'
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>',
				validateBlank	: false,
				valueFieldName	: 'TXT_MANAGE_CUST_CODE',
				textFieldName	: 'TXT_MANAGE_CUST_NAME',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER': '3'});
						popup.setExtParam({'CUSTOM_TYPE': '3'});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'ITEM_LEVEL2'
			},{
				fieldLabel	: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child		: 'ITEM_LEVEL3'
			},{
				fieldLabel	: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name		: 'ITEM_LEVEL3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve3Store')
			},
			Unilite.popup('ITEM2',{
				fieldLabel		: '대표품목',
				name			: 'ITEM_GROUP',
				validateBlank	: false,
				popupWidth		: 710
			}),{
				fieldLabel	: '주문번호',
				name		: 'TXT_SO_NUM',
				width		: 325
			},{
				fieldLabel	: '주문자',
				name		: 'TXT_CUSTOMER_ID',
				width		: 325
			},{
				fieldLabel	: '전화번호1',
				name		: 'TXT_TELPHONE1',
				width		: 325
			},{
				fieldLabel	: '전화번호2',
				name		: 'TXT_TELPHONE2',
				width		: 325
			},{
				fieldLabel	: '<t:message code="system.label.sales.address" default="주소"/>',
				name		: 'TXT_ADDRESS',
				width		: 325
			}]
		}]
	});	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.sodate" default="수주일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ORDER_DATE_FR',
			endFieldName	: 'ORDER_DATE_TO',
			allowBlank		: false,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_FR', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_TO', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
			name		: 'TXT_ORDER_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S002',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXT_ORDER_TYPE', newValue);
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="" default="조건"/>',
			//itemId		: '',
			items		: [{
				boxLabel	: '<t:message code="" default="상세"/>',
				name		: 'CONDITION',
				inputValue	: 'D',
				width		: 60,
				checked		: true
			},{
				boxLabel	: '<t:message code="" default="요약"/>',
				name		: 'CONDITION',
				inputValue	: 'S',
				width		: 60
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					var colList = ['ORDER_P', 'ORDER_O', 'ORDER_TAX_O', 'TOT_ORDER_TAX_O', 'DVRY_DATE', 'INIT_DVRY_DATE', 'ORDER_PRSN', 'INOUT_Q', 'REMARK'];
					var grid = Ext.getCmp('s_sof101ukrv_novisGrid1');
					
					if(newValue.CONDITION == 'D') {
						Ext.each(colList, function(colName, index) {
							var colIdx = grid.getColumnIndex(colName);
							grid.columns[colIdx].show();
						});
					}
					else {
						Ext.each(colList, function(colName, index) {
							var colIdx = grid.getColumnIndex(colName);
							grid.columns[colIdx].hide();
						});
					}
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.base.classfication" default="구분"/>',
			itemId		: 'COMPLETE_YN',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
				name		: 'COMPLETE_YN',
				inputValue	: 'A',
				width		: 60
			},{
				boxLabel	: '<t:message code="system.label.sales.completion" default="완료"/>',
				name		: 'COMPLETE_YN',
				inputValue	: 'Y',
				width		: 60
			},{
				boxLabel	: '<t:message code="system.label.sales.incompleted" default="미완료"/>',
				name		: 'COMPLETE_YN' ,
				inputValue	: 'N',
				width		: 80,
				checked		: true
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('COMPLETE_YN', newValue.COMPLETE_YN);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			name			: 'CUSTOM_CODE',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);
				}
			}
		}),
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			name			: 'ITEM_CODE',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				},
				applyextparam: function(popup) {
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		})]
	});



	/** master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_sof101ukrv_novisGrid1', {
		store	: directMasterStore,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: true,
			onLoadSelectFirst	: false,
			copiedRow			: false
		},
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns	: [
			{ dataIndex: 'ORDER_TYPE'		, width:106,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex: 'ORDER_DATE'		, width:86  },
			{ dataIndex: 'CUSTOM_CODE'		, width:100 },
			{ dataIndex: 'CUSTOM_NAME'		, width:133 },
			{ dataIndex: 'ITEM_CODE'		, width:100 },
			{ dataIndex: 'ITEM_NAME'		, width:166 },
			{ dataIndex: 'SPEC'				, width:133 },
//			{ dataIndex: 'ORDER_UNIT'		, width:66	, align:'center' },
//			{ dataIndex: 'TRANS_RATE'		, width:100	, align:'right' },
			{ dataIndex: 'ORDER_Q'			, width:106	, summaryType:'sum' },
			{ dataIndex: 'ORDER_P'			, width:106 },
			{ dataIndex: 'ORDER_O'			, width:106	, summaryType:'sum' },
			{ dataIndex: 'ORDER_TAX_O'		, width:106	, summaryType:'sum' },
			{ dataIndex: 'TOT_ORDER_TAX_O'	, width:106	, summaryType:'sum' },
			{ dataIndex: 'DVRY_DATE'		, width:86  },
			{ dataIndex: 'INIT_DVRY_DATE'	, width:86  },
			{ dataIndex: 'ORDER_PRSN'		, width:100 },
			{ dataIndex: 'INOUT_Q'			, width:106	, summaryType:'sum' },
//			{ dataIndex: 'INOUT_P'			, width:106 },
//			{ dataIndex: 'INOUT_I'			, width:106	, summaryType:'sum' },
//			{ dataIndex: 'RETURN_Q'			, width:106	, summaryType:'sum' },
//			{ dataIndex: 'RETURN_P'			, width:106 },
//			{ dataIndex: 'RETURN_I'			, width:106	, summaryType:'sum' },
//			{ dataIndex: 'SALE_Q'			, width:106	, summaryType:'sum' },
//			{ dataIndex: 'SALE_P'			, width:106 },
//			{ dataIndex: 'SALE_AMT_O'		, width:106	, summaryType:'sum' },
//			{ dataIndex: 'SO_KIND'			, width:106 },
//			{ dataIndex: 'ORDER_NUM'		, width:106 },
//			{ dataIndex: 'SER_NO'			, width:66	, align:'center' },
//			{ dataIndex: 'STATUS'			, width:106 },
//			{ dataIndex: 'ORDER_STATUS_NM'	, width:106 },
			{ dataIndex: 'REMARK'			, width:106 },
			{ dataIndex: 'REASON1'			, width:106 },
			{ text		: '원부자재 진행내역',
			  columns	: [
//					{ dataIndex: 'REASON2'			, width:106 },
//					{ dataIndex: 'REASON3'			, width:106 },
//					{ dataIndex: 'REASON4'			, width:106 }
					{	text	: '제재',
						columns	: [
							{ dataIndex: 'PLAN_DATE1'		, width:106 },
							{ dataIndex: 'COMP_DATE1'		, width:106 }
						]
					},
					{	text	: '품목허가',
						columns	: [
							{ dataIndex: 'PLAN_DATE2'		, width:106 },
							{ dataIndex: 'COMP_DATE2'		, width:106 }
						]
					},
					{	text	: '광고심의',
						columns	: [
							{ dataIndex: 'PLAN_DATE3'		, width:106 },
							{ dataIndex: 'COMP_DATE3'		, width:106 }
						]
					},
					{	text	: '원료입고',
						columns	: [
							{ dataIndex: 'PLAN_DATE4'		, width:106 },
							{ dataIndex: 'COMP_DATE4'		, width:106 }
						]
					},
					{	text	: '부자재입고',
						columns	: [
							{ dataIndex: 'PLAN_DATE5'		, width:106 },
							{ dataIndex: 'COMP_DATE5'		, width:106 }
						]
					},
					{	text	: '생산',
						columns	: [
							{ dataIndex: 'PLAN_DATE7'		, width:106 },
							{ dataIndex: 'COMP_DATE7'		, width:106 }
						]
					},
					{	text	: '자가품질',
						columns	: [
							{ dataIndex: 'PLAN_DATE8'		, width:106 },
							{ dataIndex: 'COMP_DATE8'		, width:106 }
						]
					},
					{	text	: '출고',
						hidden	: true,
						columns	: [
							{ dataIndex: 'PLAN_DATE9'		, width:106 },
							{ dataIndex: 'COMP_DATE9'		, width:106 }
						]
					},
					{	text	: '기타',
						columns	: [
							{ dataIndex: 'PLAN_DATE6'		, width:106 },
							{ dataIndex: 'COMP_DATE6'		, width:106 }
						]
					}
				]
			},
			{ dataIndex: 'REASON'			, width:106 }
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['REASON1', 'REASON2', 'REASON3', 'REASON4'
								, 'PLAN_DATE1', 'COMP_DATE1', 'PLAN_DATE2', 'COMP_DATE2'
								, 'PLAN_DATE3', 'COMP_DATE3', 'PLAN_DATE4', 'COMP_DATE4'
								, 'PLAN_DATE5', 'COMP_DATE5', 'PLAN_DATE6', 'COMP_DATE6'
								, 'PLAN_DATE7', 'COMP_DATE7', 'PLAN_DATE8', 'COMP_DATE8'
								, 'PLAN_DATE9', 'COMP_DATE9', 'PLAN_DATE10', 'COMP_DATE10'])){
					return true;
				} else {
					return false;
				}
			}
		}
	});



	Unilite.Main({
		id			: 's_sof101ukrv_novisApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
		panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('COMPLETE_YN'	, 'N');

			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelResult.setValue('COMPLETE_YN'	, 'N');
//			UniAppManager.setToolbarButtons('reset', false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});

			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
				directMasterStore.saveStore();
		}
	});
};
</script>