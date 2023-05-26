<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bpr130ukrv_mit">
	<t:ExtComboStore comboType="BOR120" />				<!-- 사업장 -->
	
	<t:ExtComboStore comboType="AU" comboCode="B010" />	<!-- 사용여부(예/아니오) -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />	<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B018" />	<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" />	<!-- 세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B083" />	<!-- BOM PATH 정보 -->
	<t:ExtComboStore comboType="AU" comboCode="B097" />	<!-- 구성여부 -->
	<t:ExtComboStore comboType="AU" comboCode="M105" />	<!-- 사급구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var excelWindow;	//본사 품목마스터 업로드 윈도우 생성

	//엑셀업로드 window의 Grid Model (품목 마스터정보)
	Unilite.Excel.defineModel('excel.s_bpr130ukrv_mit_sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'		, text: 'EXCEL_JOBID'	, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.base.itemname2" default="품명"/>'					, type: 'string'},
			{name: 'APLY_START_DATE'	, text: '<t:message code="system.label.base.priceapplystartdate" default="단가적용시작일"/>'	, type: 'uniDate'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B013'},
			{name: 'SALE_UNIT'			, text: '<t:message code="system.label.base.salesunit" default="판매단위"/>'				, type: 'string'	, comboType: 'AU'	, comboCode: 'B013'},
			{name: 'TAX_TYPE'			, text: '<t:message code="system.label.base.taxtype" default="세구분"/>'					, type: 'string'	, comboType: 'AU'	, comboCode: 'B059'},
			{name: 'USE_YN'				, text: '<t:message code="system.label.base.useyn" default="사용여부"/>'					, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'}
		]
	});
	
	//엑셀업로드 window의 Grid Model (품목 마스터정보)
	Unilite.Excel.defineModel('excel.s_bpr130ukrv_mit_sheet02', {
		fields: [
			{name: '_EXCEL_JOBID'		, text: 'EXCEL_JOBID'	, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.base.itemname2" default="품명"/>'					, type: 'string'},
			{name: 'APLY_START_DATE'	, text: '<t:message code="system.label.base.priceapplystartdate" default="단가적용시작일"/>'	, type: 'uniDate'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B013'},
			{name: 'SALE_UNIT'			, text: '<t:message code="system.label.base.salesunit" default="판매단위"/>'				, type: 'string'	, comboType: 'AU'	, comboCode: 'B013'},
			{name: 'TAX_TYPE'			, text: '<t:message code="system.label.base.taxtype" default="세구분"/>'					, type: 'string'	, comboType: 'AU'	, comboCode: 'B059'},
			{name: 'USE_YN'				, text: '<t:message code="system.label.base.useyn" default="사용여부"/>'					, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'}
		]
	});


	var updateForm = Unilite.createForm('updateForm', {
	 	region		: 'center',
		autoScroll	: true,
		border		: false,
		disabled	: false,
		padding		: '0 0 0 1',
		layout		: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5, width: '100%'} , tdAttrs: {valign:'top'}},
		xtype		: 'container',
		defaultType	: 'container',
		items		: [{
			layout		: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5, width: '80%'}, tdAttrs: {valign:'top'}},
			defaultType	: 'uniFieldset',
			defaults	: {padding: '10 15 10 10'},
			items		: [{
				html	: "<font color = 'red' >※ Excel 통합문서(*.xls, *.xlsx) 파일만 업로드를 허용합니다.</font>",
				xtype	: 'component'
			},{
				title	: 'AS 품목 마스터 정보',
				defaults: {type: 'uniTextfield', labelWidth:100},
				layout	: {type: 'uniTable', columns: 1, tableAttrs: {cellpadding:5, width: '100%'}},
				items	: [{
					fieldLabel	: '사업장',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					allowBlank	: false,
					value		: UserInfo.divCode,
					enableKeyEvents:false,
					listeners	: {
						change:function( combo, newValue, oldValue, eOpts ) {
						}
					}
				},{
					html	: "<font color = 'black' > ※  사업장을 선택한 후, 아래 '품목 업로드' 버튼을 클릭하여 등록할 품목마스터정보(엑셀파일)를 선택하고 '업로드' 버튼을 클릭하세요. </br>&nbsp;&nbsp;&nbsp;&nbsp; (업로드 할 엑셀파일의 '첫 번째 시트명' 및 '첫 행의 컬럼명'은 엑셀양식에 있는 명칭을 따라야 합니다.) </font>",
					xtype	: 'component',
					padding	: '0 0 10 30'
				},{
					text	: '품목 업로드',
					xtype	: 'button',
					tdAttrs	: {align: 'center'},
					width	: 110,
					handler	: function() {
						openExcelWindow();
					}
				}]
			}]
		}]
	});

	Unilite.Main({
		id			: 's_bpr130ukrv_mitApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				 updateForm 
			]
		}],
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['query', 'newData', 'reset'], false);
		}
	});


	function openExcelWindow() {
		var me		= this;
		var vParam	= {};
		var appName	= 'Unilite.com.excel.ExcelUpload';
		if(!Ext.isEmpty(excelWindow)) {
			excelWindow.extParam.DIV_CODE = updateForm.getValue('DIV_CODE');
		}
		if(!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: 's_bpr130ukrv_mit_Item',
				width	: 600,
				height	: 400,
				modal	: false,
				closeAction	: 'hide',
				extParam: { 
					'PGM_ID'	: 's_bpr130ukrv_mit_Item',
					'DIV_CODE'	: updateForm.getValue('DIV_CODE')
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid02',
						title		: '품목 마스터정보 엑셀업로드',
						useCheckbox	: false,
						model		: 'excel.s_bpr130ukrv_mit_sheet01',
						readApi		: 's_bpr130ukrv_mitService.selectExcelUploadSheet',
						columns		: [	
							{dataIndex: '_EXCEL_JOBID'		, width: 80	, hidden: true},
							{dataIndex: 'COMP_CODE'			, width: 93	},
							{dataIndex: 'ITEM_CODE'			, width: 100},
							{dataIndex: 'ITEM_NAME'			, width: 100},
							{dataIndex: 'APLY_START_DATE'	, width: 80},
							{dataIndex: 'STOCK_UNIT'		, width: 80	, align: 'center'},
							{dataIndex: 'SALE_UNIT'			, width: 80	, align: 'center'},
							{dataIndex: 'TAX_TYPE'			, width: 70	, align: 'center'},
							{dataIndex: 'USE_YN'			, width: 70}
						]
					}
				],
				listeners: {
					close: function() {
						this.hide();
						var excelWindow;
					},
					show:function() {
					}
				},
				onApply:function() {
					excelWindow.getEl().mask('로딩중...','loading-indicator');
					var me		= this;
					var grid	= this.down('#grid02');
					var records	= grid.getStore().getAt(0);	
					if (!Ext.isEmpty(records)) {
						var param	= {
							"_EXCEL_JOBID"	: records.get('_EXCEL_JOBID'),
							"DIV_CODE"		: updateForm.getValue('DIV_CODE')
						};
						excelUploadFlag = "Y"
						s_bpr130ukrv_mitService.insertUploadSheet(param, function(provider, response) {
							if (!Ext.isEmpty(provider) && provider == 1) {
								s_bpr130ukrv_mitService.getErrMsg(param, function(provider, response) {
									if (Ext.isEmpty(provider)) {
										me.down('tabpanel').setActiveTab(1);
										UniAppManager.updateStatus('Upload 되었습니다.');
										me.hide();
									} else {
										Unilite.messageBox(provider);
										return false;
									}
								});
							}
//								//로그테이블 삭제
//								s_bpr130ukrv_mitService.deleteLog({}, function(provider, response) {});
//							});
							excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();
						});
						excelUploadFlag = "N"
					} else {
						Unilite.messageBox ("업로드할 파일을 선택하십시오.");
						this.unmask();  
					}
					//버튼세팅
					UniAppManager.setToolbarButtons('newData'	, true);
					UniAppManager.setToolbarButtons('delete'	, false);
				},
				_setToolBar: function() {
					var me = this;
					me.tbar = ['->',{
						xtype	: 'button',
						text	: '업로드',
						tooltip	: '업로드',
						width	: 60,
						handler: function() {
							me.jobID = null;
							me.uploadFile();
						}
					},{
						xtype	: 'button',
						text	: '적용',
						tooltip	: '적용',
						width	: 60,
						handler	: function() { 
							var grids	= me.down('grid');
							var isError	= false;
							if(Ext.isDefined(grids.getEl())) {
								grids.getEl().mask();
							}
							Ext.each(grids, function(grid, i) {   
								var records = grid.getStore().data.items;
								return Ext.each(records, function(record, i) {
									if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
										console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
										isError = true;	 
										return false;
									}
								});
							}); 
							if(Ext.isDefined(grids.getEl())) {
								grids.getEl().unmask();
							}
							if(!isError) {
								me.onApply();
							}else {
								Unilite.messageBox("에러가 있는 행은 적용이 불가능합니다.");
							}
						}
					},{
						xtype: 'tbspacer'
					},{
						xtype: 'tbseparator'
					},{
						xtype: 'tbspacer'
					},{
						xtype: 'button',
						text : '닫기',
						tooltip : '닫기', 
						handler: function() { 
							me.close();
							me.hide();
						}
					}]
				 }
			});
		}
		excelWindow.center();
		excelWindow.show();
	};


};
</script>