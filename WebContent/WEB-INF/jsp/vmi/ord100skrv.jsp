<%--
'   프로그램명 : 주문현황
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'   최종수정자 :
'   최종수정일 :
'   버	  전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ord100skrv" saveAuth="true">
	<t:ExtComboStore comboType="BOR120" pgmId="ord100skrv"/>	<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="ZM11"/>			<!-- 배송방법 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >
MODIFY_AUTH = 'true';
function appMain() {
	var statusStore = Unilite.createStore('statusComboStore', {  
		fields	: ['text', 'value'],
		data	: [
			{'text':'대기'	, 'value':'1'},
			{'text':'주문확정'	, 'value':'2'},
			{'text':'수주확정'	, 'value':'9'},
			{'text':'취소'	, 'value':'8'}
		]
	});

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Ord100skrvModel', {
		fields: [  	 
			{name: 'DIV_CODE'		, text: '사업장'		, type: 'string'},
			{name: 'SO_DATE'		, text: '주문일'		, type: 'uniDate'},
			{name: 'ITEM_CODE'		, text: '품목코드'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '품명'		, type: 'string'},
			{name: 'TRANS_RATE'		, text: '입수'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000', allowBlank:false},
			{name: 'ORDER_UNIT'		, text: '판매단위'		, type: 'string'},
			{name: 'ORDER_Q'		, text: '주문량'		, type: 'uniQty'},
			{name: 'ORDER_P'		, text: '단가'		, type: 'uniUnitPrice'},
			{name: 'ORDER_O'		, text: '금액'		, type: 'uniPrice'},
			{name: 'ORDER_TAX_O'	, text: '부가세액'		, type: 'uniPrice'},
			{name: 'ORDER_TOT_O'	, text: '합계'		, type: 'uniPrice'},
			{name: 'DVRY_DATE'		, text: '납기일'		, type: 'uniDate'},
			//20190711 추가
			{name: 'POSS_DVRY_DATE'	, text: '납기예정일'		, type: 'uniDate'},
			{name: 'REMARK'			, text: '사용자 비고'	, type: 'string'},
			{name: 'SO_NUM'			, text: '주문번호'		, type: 'string'},
			{name: 'SO_SEQ'			, text: '주문순번'		, type: 'string'},
			{name: 'STATUS_FLAG'	, text: '상태'		, type: 'string'	, xtype: 'uniCombobox'	, store: statusStore},
			{name: 'STATUS_REMARK'	, text: '사유'		, type: 'string'},
			//20210326 추가
			{name: 'DELIV_METHOD'	, text: '배송방법'		, type: 'string', comboType: 'AU', comboCode: 'ZM11', allowBlank: false},
			{name: 'RECEIVER_NAME'	, text: '수령자명'		, type: 'string'},
			{name: 'TELEPHONE_NUM1'	, text: '수령자 연락처'	, type: 'string'},
			{name: 'ZIP_NUM'		, text: '우편번호'		, type: 'string'},
			{name: 'ADDRESS1'		, text: '주소'		, type: 'string'},
			{name: 'INVOICE_NUM'	, text: '송장번호'		, type: 'string'},	//20210408 추가
			{name: 'ADDRESS'		, text: '주소'		, type: 'string'}   // 20210422 추가
		]
	});//End of Unilite.defineModel('Ord100skrvModel2', {

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('ord100skrvMasterStore1',{
		model	: 'Ord100skrvModel',
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
				read: 'ord100skrvService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param = panelResult.getValues();
			param.STATUS_FLAG = Ext.getCmp('statusFlag').getChecked()[0].inputValue;
			this.load({
				params : param
			});
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
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title		: '검색조건',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items		: [{	
			title		: '기본정보', 	
   			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [
				{
				fieldLabel: '업체명',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				readOnly     : true,
				value: UserInfo.divCode
				,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '주문일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'SO_DATE_FR',
				endFieldName	: 'SO_DATE_TO',
				width			: 315,
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('SO_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('SO_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel		: '납기일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'DVRY_DATE_FR',
				endFieldName	: 'DVRY_DATE_TO',
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DVRY_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DVRY_DATE_TO',newValue);
					}
				}
			},
			Unilite.popup('VMI_PUMOK', {
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function( elm, newValue, oldValue) {						
						panelSearch.setValue('ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_NAME', '');
							panelSearch.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue) {
						panelSearch.setValue('ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup) {
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 2},
				width	: 300,
				items	: [{
					xtype		: 'radiogroup',
					fieldLabel	: ' ',
					layout		: {type : 'uniTable', columns : 3},
					id			: 'statusFlag',
					items		: [{
						boxLabel	: '전체', 
						width		: 70,
						name		: 'STATUS_FLAG',
						inputValue	: '',
						checked		: true
					},{
						boxLabel	: '대기', 
						width		: 70,
						name		: 'STATUS_FLAG',
						inputValue	: '1' 
					},{
						boxLabel	: '주문확정', 
						width		: 70,
						name		: 'STATUS_FLAG',
						inputValue	: '2'
					},{
						boxLabel	: '수주확정', 
						width		: 70,
						name		: 'STATUS_FLAG',
						inputValue	: '9'
					},{
						boxLabel	: '취소', 
						width		: 70,
						name		: 'STATUS_FLAG',
						inputValue	: '8'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('STATUS_FLAG').setValue(newValue.STATUS_FLAG);
						}
					}
				}]
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

					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
				//	this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});		//End of var panelSearch = Unilite.createSearchForm('searchForm',{	

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
				fieldLabel: '업체명',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				readOnly     : true,
				value: UserInfo.divCode
				,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},
			{
			fieldLabel		: '주문일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'SO_DATE_FR',
			endFieldName	: 'SO_DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('SO_DATE_FR',newValue);	
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('SO_DATE_TO',newValue);
				}
			}
		},{
			fieldLabel		: '납기일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'DVRY_DATE_FR',
			endFieldName	: 'DVRY_DATE_TO',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('DVRY_DATE_FR',newValue);	
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('DVRY_DATE_TO',newValue);
				}
			}
		},
		Unilite.popup('VMI_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function( elm, newValue, oldValue) {						
					panelResult.setValue('ITEM_CODE', newValue);
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_NAME', '');
						panelSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function( elm, newValue, oldValue) {
					panelResult.setValue('ITEM_NAME', newValue);
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			width	: 300,
			colspan		: 2,
			items	: [{
				xtype		: 'radiogroup',
				fieldLabel	: ' ',
				id			: 'statusFlag2',
				items		: [{
					boxLabel	: '전체', 
					width		: 55,
					name		: 'STATUS_FLAG',
					inputValue	: '',
					checked		: true  
				},{
					boxLabel	: '대기', 
					width		: 55,
					name		: 'STATUS_FLAG',
					inputValue	: '1' 
				},{
					boxLabel	: '주문확정', 
					width		: 80,
					name		: 'STATUS_FLAG',
					inputValue	: '2'
				},{
					boxLabel	: '수주확정', 
					width		: 80,
					name		: 'STATUS_FLAG',
					inputValue	: '9'
				},{
					boxLabel	: '취소', 
					width		: 55,
					name		: 'STATUS_FLAG',
					inputValue	: '8'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('STATUS_FLAG').setValue(newValue.STATUS_FLAG);
					}
				}
			}]
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '주문자',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME', 
			hidden			: true,
			readOnly		: true
		})],
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

					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
				//	this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});	



	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('ord100skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns	: [
			{dataIndex: 'DIV_CODE'			, width: 100 ,hidden: true},
			{dataIndex: 'SO_DATE'			, width: 80 ,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
				}
			},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 160},
			{dataIndex: 'TRANS_RATE'		, width: 80 },
			{dataIndex: 'ORDER_UNIT'		, width: 80 , align: 'center'},
			{dataIndex: 'ORDER_Q' 			, width: 90 , summaryType: 'sum'},
			{dataIndex: 'ORDER_P'			, width: 90 },
			{dataIndex: 'ORDER_O'			, width: 90 , summaryType: 'sum'},
			{dataIndex: 'ORDER_TAX_O'		, width: 90 , summaryType: 'sum'},
			{dataIndex: 'ORDER_TOT_O'		, width: 90 , summaryType: 'sum'},
			{dataIndex: 'DVRY_DATE'			, width: 100},
			//20190711 추가
			{dataIndex: 'POSS_DVRY_DATE'	, width: 100},
			{dataIndex: 'REMARK'			, width: 150},
			{dataIndex: 'ADDRESS'			, width: 200},
			{dataIndex: 'SO_NUM'			, width: 130},
			{dataIndex: 'SO_SEQ'			, width: 80 , align: 'center'},
			{dataIndex: 'STATUS_FLAG'		, width: 80 , align: 'center'},
			{dataIndex: 'STATUS_REMARK'		, width: 150},
			//20210326 추가
			{dataIndex: 'DELIV_METHOD'		, width: 100, hidden: true, align: 'center'},
			{dataIndex: 'RECEIVER_NAME'		, width: 100, hidden: true},
			{dataIndex: 'TELEPHONE_NUM1'	, width: 120, hidden: true},
			{dataIndex: 'ZIP_NUM'			, width: 100, hidden: true, align: 'center'},
			{dataIndex: 'ADDRESS1'			, width: 200, hidden: true},
			{dataIndex: 'INVOICE_NUM'		, width: 100, hidden: true,				//20210408 추가
				renderer: function (val, meta, record) {
					if (!Ext.isEmpty(val)) {
						return '<div style="color: blue">' + val + '</div>';
					} else {
						return '';
					}
				}
			}
		],
		selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		listeners: {
			selectionchange:function( model1, selected, eOpts ){
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ){	//20210408 추가
				//클릭 시, 송장 조회화면 팝업 open
				if(grid.panel.headerCt.getHeaderAtIndex(cellIndex).dataIndex == 'INVOICE_NUM' && !Ext.isEmpty(thisRecord.get('INVOICE_NUM'))) {
					openSearchPopup(thisRecord.get('INVOICE_NUM'))
				}
			}/*,
			afterrender: function(grid) {
				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				this.contextMenu.add({
					text: '수주등록 바로가기',   iconCls : '',
					handler: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						var params = {
								sender: me,
								'PGM_ID': 'sof100skrv',
								COMP_CODE: UserInfo.compCode,
								DIV_CODE: panelResult.getValue('DIV_CODE'),
								ORDER_NUM: record.data.ORDER_NUM
							}
							var rec = {data : {prgID : 'sof100ukrv', 'text':''}};
							parent.openTab(rec, '/sales/sof100ukrv.do', params);
						}
					}
				);
			}*/
		}
	});		//End of  var masterGrid1 = Unilite.createGrid('ord100skrvGrid1', {



	Unilite.Main({
		id			: 'ord100skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid1, panelResult
			]
		},
		panelSearch
		],
		fnInitBinding : function() {
			var PGM_TITLE = '주문현황';
			UniAppManager.setPageTitle(PGM_TITLE);
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('SO_DATE_FR'	, UniDate.get('startOfMonth'));
			panelResult.setValue('SO_DATE_FR'	, UniDate.get('startOfMonth'));
			panelSearch.setValue('SO_DATE_TO'	, UniDate.get('today'));
			panelResult.setValue('SO_DATE_TO'	, UniDate.get('today'));

			panelResult.setValue('CUSTOM_CODE'	, UserInfo.customCode);
			panelResult.setValue('CUSTOM_NAME'	, UserInfo.customName);
		},
		onQueryButtonDown : function(){		
			directMasterStore1.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid1.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		}
	});



	//20210408 추가
	function openSearchPopup(invoiceNum) {
		var url		= 'http://nplus.doortodoor.co.kr/web/detail.jsp?slipno=' + invoiceNum;
		var option	= 'scrollbars=no, left=100, top=100, width=700, height=700';
		window.open(url, null, option);
	}
};
</script>
