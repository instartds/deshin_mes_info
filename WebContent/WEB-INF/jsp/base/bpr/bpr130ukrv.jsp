<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr130ukrv">
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
	var excelWindow;	//거래처마스터 업로드 윈도우 생성
	var excelWindow2;	//품목마스터 업로드 윈도우 생성
	//20191024 BOM 업로드 관련내용 추가
	var excelWindow3;	//BOM 업로드 윈도우 생성
	//20200302 추가: bom업로드와 bom업로드II를 구분하지 위해 추가
	var gsBomFlag;		//BOM 업로드 윈도우 생성

	//엑셀업로드 window의 Grid Model (거래처 마스터정보)
	Unilite.Excel.defineModel('excel.bpr130ukrv.sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'		, text: 'EXCEL_JOBID'	, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.base.companycode" default="법인코드"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.base.customcode" default="거래처코드"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.base.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'COMPANY_NUM'		, text: '<t:message code="system.label.base.businessnumber" default="사업자번호"/>'		, type: 'string'},
			{name: 'TOP_NAME'			, text: '<t:message code="system.label.base.representativename" default="대표자명"/>'	, type: 'string'},
			{name: 'CUSTOM_TYPE'		, text: '<t:message code="system.label.base.businessconditions" default="업태"/>'		, type: 'string'},
			{name: 'COMP_TYPE'			, text: '<t:message code="system.label.base.businesstype" default="업종"/>'			, type: 'string'},
			{name: 'USE_YN'				, text: '<t:message code="system.label.base.tradeyn" default="거래유무"/>'				, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'}
		]
	});

	//엑셀업로드 window의 Grid Model (품목 마스터정보)
	Unilite.Excel.defineModel('excel.bpr130ukrv.sheet02', {
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

	//엑셀업로드 window의 Grid Model (BOM정보): 	//20191024 BOM 업로드 관련내용 추가
	Unilite.Excel.defineModel('excel.bpr130ukrv.sheet03', {
		fields: [
			{name: '_EXCEL_JOBID'		, text: 'EXCEL_JOBID'	, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				, type: 'string'},
			{name: 'PROD_ITEM_CODE'		, text: '<t:message code="system.label.base.parentitemcode" default="모품목코드"/>'			, type: 'string'},
			{name: 'CHILD_ITEM_CODE'	, text: '<t:message code="system.label.base.childitemcode" default="자품목코드"/>'			, type: 'string'},
			{name: 'START_DATE'			, text: '<t:message code="system.label.base.startdate" default="시작일"/>'					, type: 'uniDate'},
			{name: 'PATH_CODE'			, text: '<t:message code="system.label.base.pathinfo" default="PATH정보"/>'				, type: 'string'	, comboType: 'AU'	, comboCode: 'B083'},
			{name: 'SEQ'				, text: '<t:message code="system.label.base.seq" default="순번"/>'						, type: 'int'},
			{name: 'GRANT_TYPE'			, text: '사급'			, type: 'string'	, comboType: 'AU'	, comboCode: 'M105'},
			{name: 'UNIT_Q'				, text: '<t:message code="system.label.base.originunitqty" default="원단위량"/>'			, type: 'float'		, decimalPrecision: 6, format:'0,000.000000'},
			{name: 'PROD_UNIT_Q'		, text: '<t:message code="system.label.base.parentitembaseqty" default="모품목기준수"/>'		, type: 'number'},
			{name: 'LOSS_RATE'			, text: '<t:message code="system.label.base.lossrate" default="LOSS율"/>'				, type: 'number'},
			{name: 'USE_YN'				, text: '<t:message code="system.label.base.useyn" default="사용여부"/>'					, type: 'string'	, comboType: 'AU'	, comboCode: 'B018'},
			{name: 'BOM_YN'				, text: '<t:message code="system.label.base.compyn" default="구성여부"/>'					, type: 'string'	, defaultValue:'1' , comboType: 'AU', comboCode:'B097'}
		]
	});



	var updateForm = Unilite.createForm('updateForm', {
	 	region		: 'center',
		flex		: 4,
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
				title	: '거래처 마스터 정보',
				defaults: {type: 'uniTextfield', labelWidth:100},
				layout	: {type: 'uniTable', columns: 1, tableAttrs: {cellpadding:5, width: '100%'}},
				items	: [{
					html	: "<font color = 'black' > ※ 아래 '거래처 업로드' 버튼을 클릭하여 등록하실 거래처마스터정보(엑셀파일)를 선택하신 후, '업로드' 버튼을 클릭하세요. </br>&nbsp;&nbsp;&nbsp;&nbsp; (업로드 할 엑셀파일의 '첫 번째 시트명' 및 '첫 행의 컬럼명'은 엑셀양식에 있는 명칭을 따라야 합니다.) </font>",
					xtype	: 'component',
					padding	: '0 0 10 30'
				},{
					text	: '거래처 업로드',
					xtype	: 'button',
					tdAttrs	: {align: 'center'},
					width	: 110,
					handler	: function() {
						openExcelWindow();
					}
				}]
			},{
				title	: '품목 마스터 정보',
				defaults: {type: 'uniTextfield', labelWidth:100},
				layout	: {type: 'uniTable', columns: 1, tableAttrs: {cellpadding:5, width: '100%'}},
				items	: [{
					fieldLabel	: '업로드 유형',
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
					html	: "<font color = 'black' > ※ 위 '업로드 유형'에서 사업장을 선택한 후, 아래 '품목 업로드' 버튼을 클릭하여 등록할 품목마스터정보(엑셀파일)를 선택하고 '업로드' 버튼을 클릭하세요. </br>&nbsp;&nbsp;&nbsp;&nbsp; (업로드 할 엑셀파일의 '첫 번째 시트명' 및 '첫 행의 컬럼명'은 엑셀양식에 있는 명칭을 따라야 합니다.) </font>",
					xtype	: 'component',
					padding	: '0 0 10 30'
				},{
					text	: '품목 업로드',
					xtype	: 'button',
					tdAttrs	: {align: 'center'},
					width	: 110,
					handler	: function() {
						openExcelWindow2();
					}
				}]
			},{	//20191024 BOM 업로드 관련내용 추가
				title	: 'BOM 정보',
				defaults: {type: 'uniTextfield', labelWidth:100},
				layout	: {type: 'uniTable', columns: 1, tableAttrs: {cellpadding:5, width: '100%'}},
				items	: [{
					fieldLabel	: '업로드 유형',
					name		: 'DIV_CODE2',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					allowBlank	: false,
					value		: UserInfo.divCode,
					enableKeyEvents:false,
					listeners	: {
						change:function( combo, newValue, oldValue, eOpts ) {
						}
					}
				},{	//20200302 수정: bom업로드, bom업로드(II)에 대한 설명 추가
					html	: "<font color = 'black' > ※ 위 '업로드 유형'에서 사업장을 선택한 후, 아래 'BOM 업로드' 버튼을 클릭하여 등록할 BOM 정보(엑셀파일)를 선택하고 '업로드' 버튼을 클릭하세요. </br>&nbsp;&nbsp;&nbsp;&nbsp; (업로드 할 엑셀파일의 '첫 번째 시트명' 및 '첫 행의 컬럼명'은 엑셀양식에 있는 명칭을 따라야 합니다.). </br></br>&nbsp;&nbsp; -. BOM 업로드 :  일자별로 이력관리를 하면서 BOM을 업로드합니다.</br>&nbsp;&nbsp; -. BOM 업로드II :  일자와 상관없이 모품목에 해당하는 자품목 전체 삭제 후 업로드합니다. </font>",
					xtype	: 'component',
					padding	: '0 0 10 30'
				},{
					xtype	: 'container',
					layout	: {type:'uniTable', align:'center'},
					tdAttrs	: {align: 'center'},
					items	: [{
						//20191217 bom 다운로드 기능 추가
						text	: '전체 BOM 다운로드',
						xtype	: 'button',
						width	: 130,
						handler	: function() {
//							Ext.getCmp('bpr130ukrvApp').mask();
							var form	= panelFileDown;
							var param	= updateForm.getValues();
							form.submit({
								params	: param,
								success	: function() {
//									Ext.getCmp('bpr130ukrvApp').unmask();
								},
								failure: function(form, action){
//									Ext.getCmp('bpr130ukrvApp').unmask();
								}
							});
						}
					},{
						text	: 'BOM 업로드',
						xtype	: 'button',
						width	: 130,
						handler	: function() {
							gsBomFlag = 'I';
							openExcelWindow3();
						}
					},{	//20200302 추가: 
						text	: 'BOM 업로드II',
						xtype	: 'button',
						width	: 130,
						handler	: function() {
							gsBomFlag = 'II';
							openExcelWindow3();
						}
					}]
				}]
			}]
		}]
	});



	//20191217 bom 다운로드 기능 추가
	var panelFileDown = Unilite.createForm('FileDownForm', {
		url				: CPATH + '/base/bpr130ukrv_BOM_ExcelDown.do',
		layout			: {type: 'uniTable', columns: 1},
		disabled		: false,
		autoScroll		: false,
		standardSubmit	: true,  
		items			: []
	});



	Unilite.Main({
		id			: 'bpr130ukrvApp',
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
//			excelWindow.extParam.BILL_TYPE = panelResult.getValue('BILL_TYPE');
		}
		if(!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: 'bpr130ukrv_Custom',
				width	: 600,
				height	: 400,
				modal	: false,
				closeAction	: 'hide',
				extParam: { 
					'PGM_ID' : 'bpr130ukrv_Custom'
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid01',
						title		: '거래처 마스터정보 엑셀업로드',
						useCheckbox	: false,
						model		: 'excel.bpr130ukrv.sheet01',
						readApi		: 'bpr130ukrvService.selectExcelUploadSheet1',
						columns		: [	
							{dataIndex: '_EXCEL_JOBID'	, width: 80		, hidden: true},
							{dataIndex: 'COMP_CODE'		, width: 93		, hidden: true},
							{dataIndex: 'CUSTOM_CODE'	, width: 100},
							{dataIndex: 'CUSTOM_NAME'	, width: 100},
							{dataIndex: 'COMPANY_NUM'	, width: 100},
							{dataIndex: 'TOP_NAME'		, width: 80},
							{dataIndex: 'CUSTOM_TYPE'	, width: 80},
							{dataIndex: 'COMP_TYPE'		, width: 80},
							{dataIndex: 'USE_YN'		, width: 70}
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
					var grid	= this.down('#grid01');
					var records	= grid.getStore().getAt(0);
					if (!Ext.isEmpty(records)) {
						var param	= {
							"_EXCEL_JOBID"	: records.get('_EXCEL_JOBID')
						};
						excelUploadFlag = "Y"
						bpr130ukrvService.insertUploadSheet1(param, function(provider, response) {
							bpr130ukrvService.getErrMsg1(param, function(provider, response) {
								if (Ext.isEmpty(provider)) {
									me.down('tabpanel').setActiveTab(1);
									Unilite.messageBox('Upload 되었습니다.');
									me.hide();
								} else {
									Unilite.messageBox(provider);
									return false;
								}
//								//로그테이블 삭제
//								bpr130ukrvService.deleteLog({}, function(provider, response) {});
							});
							excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();
						});
						excelUploadFlag = "N"
					} else {
						Unilite.messageBox (Msg.fSbMsgH0284);
						this.unmask();  
					}
					//버튼세팅
					UniAppManager.setToolbarButtons('newData',	true);
					UniAppManager.setToolbarButtons('delete',	false);
				},
				_setToolBar: function() {
					var me = this;
					me.tbar = ['->',{
						xtype	: 'button',
						text	: '업로드',
						tooltip	: '업로드',
						width	: 60,
						handler	: function() {
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

	function openExcelWindow2() {
		var me		= this;
		var vParam	= {};
		var appName	= 'Unilite.com.excel.ExcelUpload';
		if(!Ext.isEmpty(excelWindow2)) {
			excelWindow2.extParam.DIV_CODE = updateForm.getValue('DIV_CODE');
		}
		if(!excelWindow2) {
			excelWindow2 = Ext.WindowMgr.get(appName);
			excelWindow2 = Ext.create( appName, {
				excelConfigName: 'bpr130ukrv_Item',
				width	: 600,
				height	: 400,
				modal	: false,
				closeAction	: 'hide',
				extParam: { 
					'PGM_ID'	: 'bpr130ukrv_Item',
					'DIV_CODE'	: updateForm.getValue('DIV_CODE')
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid02',
						title		: '품목 마스터정보 엑셀업로드',
						useCheckbox	: false,
						model		: 'excel.bpr130ukrv.sheet02',
						readApi		: 'bpr130ukrvService.selectExcelUploadSheet2',
						columns		: [	
							{dataIndex: '_EXCEL_JOBID'		, width: 80	, hidden: true},
							{dataIndex: 'COMP_CODE'			, width: 93	, hidden: true},
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
						var excelWindow2;
					},
					show:function() {
					}
				},
				onApply:function() {
					excelWindow2.getEl().mask('로딩중...','loading-indicator');
					var me		= this;
					var grid	= this.down('#grid02');
					var records	= grid.getStore().getAt(0);	
					if (!Ext.isEmpty(records)) {
						var param	= {
							"_EXCEL_JOBID"	: records.get('_EXCEL_JOBID'),
							"DIV_CODE"		: updateForm.getValue('DIV_CODE')
						};
						excelUploadFlag = "Y"
						bpr130ukrvService.insertUploadSheet2(param, function(provider, response) {
							if (!Ext.isEmpty(provider) && provider == 1) {
								bpr130ukrvService.getErrMsg2(param, function(provider, response) {
									if (Ext.isEmpty(provider)) {
										me.down('tabpanel').setActiveTab(1);
										Unilite.messageBox('Upload 되었습니다.');
										me.hide();
									} else {
										Unilite.messageBox(provider);
										return false;
									}
								});
							}
//								//로그테이블 삭제
//								bpr130ukrvService.deleteLog({}, function(provider, response) {});
//							});
							excelWindow2.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();
						});
						excelUploadFlag = "N"
					} else {
						Unilite.messageBox (Msg.fSbMsgH0284);
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
		excelWindow2.center();
		excelWindow2.show();
	};

	//20191024 BOM 업로드 관련내용 추가
	function openExcelWindow3() {
		var me		= this;
		var vParam	= {};
		var appName	= 'Unilite.com.excel.ExcelUpload';
		if(!Ext.isEmpty(excelWindow3)) {
			excelWindow3.extParam.DIV_CODE = updateForm.getValue('DIV_CODE');
		}
		if(!excelWindow3) {
			excelWindow3 = Ext.WindowMgr.get(appName);
			excelWindow3 = Ext.create( appName, {
				excelConfigName: 'bpr130ukrv_BOM',
				width	: 600,
				height	: 400,
				modal	: false,
				closeAction	: 'hide',
				extParam: { 
					'PGM_ID'		: 'bpr130ukrv_BOM',
					'S_COMP_CODE'	: UserInfo.compCode,
					'DIV_CODE'		: updateForm.getValue('DIV_CODE2')
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid03',
						title		: 'BOM 업로드',
						useCheckbox	: false,
						model		: 'excel.bpr130ukrv.sheet03',
						readApi		: 'bpr130ukrvService.selectExcelUploadSheet3',
						columns		: [	
							{dataIndex: '_EXCEL_JOBID'		, width: 80	, hidden: true},
							{dataIndex: 'COMP_CODE'			, width: 93	, hidden: true},
							{dataIndex: 'DIV_CODE'			, width: 93	, hidden: true},
							{dataIndex: 'PROD_ITEM_CODE'	, width: 100},
							{dataIndex: 'CHILD_ITEM_CODE'	, width: 100},
							{dataIndex: 'START_DATE'		, width: 80},
							{dataIndex: 'USE_YN'			, width: 80	, align: 'center'},
							{dataIndex: 'BOM_YN'			, width: 70	, align: 'center'}
						]
					}
				],
				listeners: {
					close: function() {
						this.hide();
						var excelWindow3;
					},
					show:function() {
					}
				},
				onApply:function() {
					excelWindow3.getEl().mask('로딩중...','loading-indicator');
					var me		= this;
					var grid	= this.down('#grid03');
					var records	= grid.getStore().getAt(0);	
					if (!Ext.isEmpty(records)) {
						var param	= {
							'_EXCEL_JOBID'	: records.get('_EXCEL_JOBID'),
							'DIV_CODE'		: updateForm.getValue('DIV_CODE'),
							'BOM_FLAG'		: gsBomFlag
						};
						excelUploadFlag = "Y"
						bpr130ukrvService.insertUploadSheet3(param, function(provider, response) {
							if (!Ext.isEmpty(provider) && provider == 1) {
								bpr130ukrvService.getErrMsg3(param, function(provider, response) {
									if (Ext.isEmpty(provider)) {
										me.down('tabpanel').setActiveTab(1);
										Unilite.messageBox('Upload 되었습니다.');
										me.hide();
									} else {
										Unilite.messageBox(provider);
										return false;
									}
								});
							}
//								//로그테이블 삭제
//								bpr130ukrvService.deleteLog({}, function(provider, response) {});
//							});
							excelWindow3.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();
						});
						excelUploadFlag = "N"
					} else {
						Unilite.messageBox (Msg.fSbMsgH0284);
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
		excelWindow3.center();
		excelWindow3.show();
	};
};
</script>