<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx425ukr"	>
	<t:ExtComboStore comboType="BOR120" pgmId="atx425ukr"	/> <!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120"	comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A084" /> <!-- 감가상각자산구분 -->
	</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsTaxRate: '${gsTaxRate}'
};
var resetButtonFlag = '';

function appMain() {
	var baseInfo = {
		gsBillDivCode	: '${gsBillDivCode}',
		gsReportGubun	: '${gsReportGubun}'
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx425ukrService.dataCheck',
			//read: 'atx425ukrService.selectList',
			update: 'atx425ukrService.updateDetail',
			create: 'atx425ukrService.insertDetail',
			destroy: 'atx425ukrService.deleteDetail',
			syncAll: 'atx425ukrService.saveAll'
		}
	});
	/**
	 *	Model 정의
	 * @type
	 */

	Unilite.defineModel('Atx425ukrModel', {
		fields: [
			{name: 'SAVE_FLAG'					,text: 'SAVE_FLAG'			,type: 'string'},
			{name: 'FR_PUB_DATE'				,text: 'FR_PUB_DATE'		,type: 'uniDate'},
			{name: 'TO_PUB_DATE'				,text: 'TO_PUB_DATE'		,type: 'uniDate'},
			{name: 'BILL_DIV_CODE'				,text: 'BILL_DIV_CODE'		,type: 'string'},
			{name: 'SEQ'						,text: 'SEQ'				,type: 'int'},
			{name: 'ACQ_DATE'					,text: '취득일자'				,type: 'uniDate',allowBlank:false},
			{name: 'CUSTOM_CODE'				,text: '고객코드'				,type: 'string',allowBlank:false},
			{name: 'CUSTOM_NAME'				,text: '상호'					,type: 'string'},
			{name: 'COMPANY_NUM'				,text: '사업자등록번호'			,type: 'string',maxLength:10},
			{name: 'ASST_DIVI'					,text: '자산구분'				,type: 'string',comboType:'AU', comboCode:'A084',allowBlank:false},
			{name: 'SUPPLY_AMT_I'				,text: '공급가액'				,type: 'uniPrice',allowBlank:false},
			{name: 'TAX_AMT_I'					,text: '세액'					,type: 'uniPrice'},
			{name: 'CASE_NUM'					,text: '건수'					,type: 'uniQty',allowBlank:false},
			{name: 'UPDATE_DB_USER'				,text: 'UPDATE_DB_USER'		,type: 'string'},
			{name: 'UPDATE_DB_TIME'				,text: 'UPDATE_DB_TIME'		,type: 'string'},
			{name: 'COMP_CODE'					,text: '법인코드'				,type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('atx425ukrMasterStore1',{
		model: 'Atx425ukrModel',
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			allDeletable: true,		// 전체삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords : function()	{
			var param = Ext.getCmp('searchForm').getValues();
			param.PUB_DATE_FR = panelSearch.getField('PUB_DATE_FR').getStartDate();
			param.PUB_DATE_TO = panelSearch.getField('PUB_DATE_TO').getEndDate();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			
			var paramMaster = panelSearch.getValues();
			paramMaster.PUB_DATE_FR = panelSearch.getField('PUB_DATE_FR').getStartDate();
			paramMaster.PUB_DATE_TO = panelSearch.getField('PUB_DATE_TO').getEndDate();
			
			var rv = true;
			if(inValidRecs.length == 0 ) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var param= sumTable.getValues();
						param.PUB_DATE_FR = panelSearch.getField('PUB_DATE_FR').getStartDate();
						param.PUB_DATE_TO = panelSearch.getField('PUB_DATE_TO').getEndDate();
						param.BILL_DIV_CODE = panelSearch.getValue("BILL_DIV_CODE");
						
						sumTable.getForm().submit({
						params : param,
							success : function(form, action) {
				 				sumTable.getForm().wasDirty = false;
								sumTable.resetDirtyStatus();
								UniAppManager.setToolbarButtons('save', false);
								UniAppManager.updateStatus(Msg.sMB011, true);// "저장되었습니다.
							}
						});
						
						panelSearch.setValue('reRefButtonClick','');
						directMasterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records.length > 0){
					UniAppManager.app.setSumTableValue();
				} else {
					UniAppManager.app.addReference();
				}
			},
			add: function(store, records, index, eOpts) {
				sumTable.setValue('SAVE_FLAG_MASTER','N');
				UniAppManager.app.setSumTableValue();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				sumTable.setValue('SAVE_FLAG_MASTER','U');
				UniAppManager.app.setSumTableValue();
			},
			remove: function(store, record, index, isMove, eOpts) {
				var recordsFirst = directMasterStore.data.items[0];
				
				if(!Ext.isEmpty(recordsFirst)){
					sumTable.setValue('SAVE_FLAG_MASTER','U');
				}else{
					sumTable.setValue('SAVE_FLAG_MASTER','D');
				}
				UniAppManager.app.setSumTableValue();
			}
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
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
			title: '기본정보',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items : [{
	 			fieldLabel: '계산서일',
					xtype: 'uniMonthRangefield',
					startFieldName: 'PUB_DATE_FR',
					endFieldName: 'PUB_DATE_TO',
					width: 470,
					startDD:'first',
					endDD:'last',
					holdable: 'hold',
					allowBlank: false,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
						panelResult.setValue('PUB_DATE_FR',newValue);
						}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PUB_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel: '신고사업장',
				name: 'BILL_DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode	: 'BILL',
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{
				xtype: 'button',
				text: '재참조',
				width: 100,
				margin: '0 0 0 120',
//				id:'temp20',
				handler : function() {
					if(!UniAppManager.app.checkForNewDetail()){
						return false;
					}else{
						var param = {"PUB_DATE_FR": panelSearch.getField('PUB_DATE_FR').getStartDate(),
							"PUB_DATE_TO": panelSearch.getField('PUB_DATE_TO').getEndDate(),
							"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE')
						};
						atx425ukrService.dataCheck(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								if(confirm('기존자료가 존재합니다. 재참조하는 경우 기존자료는 삭제됩니다. 재참조하시겠습니까?')) {
									sumTable.clearForm();
									masterGrid.reset();
									directMasterStore.clearData();
									var param = {"PUB_DATE_FR": panelSearch.getField('PUB_DATE_FR').getStartDate(),
										"PUB_DATE_TO": panelSearch.getField('PUB_DATE_TO').getEndDate(),
										"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE')
									};
									atx425ukrService.reReference(param, function(provider, response)	{
										if(!Ext.isEmpty(provider)){
											Ext.each(provider, function(record,i){
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setNewDataATX100T(record);
											});
										}
									});
									sumTable.setValue('SAVE_FLAG_MASTER','N');
									panelSearch.setValue('reRefButtonClick','DandN');
								}else{
									return false;
								}
							}else{
								sumTable.clearForm();
								masterGrid.reset();
								directMasterStore.clearData();
								var param = {"PUB_DATE_FR": panelSearch.getField('PUB_DATE_FR').getStartDate(),
									"PUB_DATE_TO": panelSearch.getField('PUB_DATE_TO').getEndDate(),
									"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE')
								};
								atx425ukrService.reReference(param, function(provider, response)	{
									if(!Ext.isEmpty(provider)){
										Ext.each(provider, function(record,i){
											UniAppManager.app.onNewDataButtonDown();
											masterGrid.setNewDataATX100T(record);
										});
									}
								});
								sumTable.setValue('SAVE_FLAG_MASTER','N');
								panelSearch.setValue('reRefButtonClick','DandN');
							}
						});
					}
				}
			},{
				xtype: 'button',
				text: '합계표',
				width: 100,
				margin: '0 0 0 120',
//				id:'temp20',
				handler : function() {
					var me = this;
					//panelSearch.getEl().mask('로딩중...','loading-indicator'); // 오류로 인해 주석
					var param = {
						"PUB_DATE_FR": panelResult.getField('PUB_DATE_FR').getStartDate(),
						"PUB_DATE_TO": panelResult.getField('PUB_DATE_TO').getEndDate(),
						"BILL_DIV_CODE": panelResult.getValue('BILL_DIV_CODE')
					};
					
					// Clip report
					var reportGubun	= baseInfo.gsReportGubun;
					if(reportGubun.toUpperCase() == 'CLIP'){
						param.PGM_ID				= 'atx425ukr';
						param.MAIN_CODE				= 'A126';
						var win = Ext.create('widget.ClipReport', {
							url		: CPATH+'/accnt/atx420clukr.do',
							prgID	: 'atx420ukr',
							extParam: param
						});
						win.center();
						win.show();
						
					// jasper Report
					} else {
						var win = Ext.create('widget.PDFPrintWindow', {
							url: CPATH+'/atx/atx420rkrPrint.do',
							prgID: 'atx420rkr',
							extParam: param
							});
						win.center();
						win.show();
					}
				}
			},{
				xtype: 'button',
				text: '명세서',
				width: 100,
				margin: '0 0 0 120',
//				id:'temp20',
				handler : function() {
					var me = this;
					//panelSearch.getEl().mask('로딩중...','loading-indicator');// 오류로 인해 주석
					var param = {
						"PUB_DATE_FR": panelResult.getField('PUB_DATE_FR').getStartDate(),
						"PUB_DATE_TO": panelResult.getField('PUB_DATE_TO').getEndDate(),
						"BILL_DIV_CODE": panelResult.getValue('BILL_DIV_CODE')
					};
					// Clip report
					var reportGubun	= baseInfo.gsReportGubun;
					if(reportGubun.toUpperCase() == 'CLIP'){
						param.PGM_ID				= 'atx425ukr';
						param.MAIN_CODE				= 'A126';
						var win = Ext.create('widget.ClipReport', {
							url		: CPATH+'/accnt/atx425clukr.do',
							prgID	: 'atx425ukr',
							extParam: param
						});
						win.center();
						win.show();
						
					// jasper Report
					} else {
						var win = Ext.create('widget.PDFPrintWindow', {
							url: CPATH+'/atx/atx425rkrPrint.do',
							prgID: 'atx425rkr',
							extParam: param
						});
						win.center();
						win.show();
					}
				}
		 	},{
		 		xtype:'uniTextfield',
		 		name:'reRefButtonClick',
		 		text:'재참조버튼클릭관련',
		 		hidden:true
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
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					});
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3,
			tableAttrs: { width: '100%'},
			tdAttrs: { align : 'center'/*,width:200*/}
		},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '계산서일',
			xtype: 'uniMonthRangefield',
			startFieldName: 'PUB_DATE_FR',
			endFieldName: 'PUB_DATE_TO',
			width: 470,
			startDD:'first',
			endDD:'last',
			holdable: 'hold',
			allowBlank: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PUB_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PUB_DATE_TO',newValue);
				}
			}
		},{
			fieldLabel: '신고사업장',
			name: 'BILL_DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			comboCode	: 'BILL',
			holdable: 'hold',
			width: 250,
			allowBlank: false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('BILL_DIV_CODE', newValue);
				}
			}
		},{
			xtype: 'container',
			id:'temp5',
			margin: '0 10 0 0',
			width:370,
			layout: {
				type: 'hbox',
				align: 'center',
				pack:'center',
				tdAttrs: { align : 'right',width:'100%'}
			},
			items:[{
				xtype: 'button',
				text: '재참조',
				width: 100,
				margin: '0 5 0 0',
				handler : function() {
					if(!UniAppManager.app.checkForNewDetail()){
						return false;
					}else{
						var param = {"PUB_DATE_FR": panelResult.getField('PUB_DATE_FR').getStartDate(),
							"PUB_DATE_TO": panelResult.getField('PUB_DATE_TO').getEndDate(),
							"BILL_DIV_CODE": panelResult.getValue('BILL_DIV_CODE')
						};
						atx425ukrService.dataCheck(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								if(confirm('기존자료가 존재합니다. 재참조하는 경우 기존자료는 삭제됩니다. 재참조하시겠습니까?')) {
									sumTable.clearForm();
									masterGrid.reset();
									directMasterStore.clearData();
									var param = {"PUB_DATE_FR": panelResult.getField('PUB_DATE_FR').getStartDate(),
										"PUB_DATE_TO": panelResult.getField('PUB_DATE_TO').getEndDate(),
										"BILL_DIV_CODE": panelResult.getValue('BILL_DIV_CODE')
									};
									atx425ukrService.reReference(param, function(provider, response)	{
										if(!Ext.isEmpty(provider)){
											Ext.each(provider, function(record,i){
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setNewDataATX100T(record);
											});
										}
									});
									sumTable.setValue('SAVE_FLAG_MASTER','N');
									panelSearch.setValue('reRefButtonClick','DandN');
					 			}else{
					 				return false;
					 			}
			 				}else{
			 					sumTable.clearForm();
								masterGrid.reset();
								directMasterStore.clearData();
								var param = {"PUB_DATE_FR": panelResult.getField('PUB_DATE_FR').getStartDate(),
									"PUB_DATE_TO": panelResult.getField('PUB_DATE_TO').getEndDate(),
									"BILL_DIV_CODE": panelResult.getValue('BILL_DIV_CODE')
								};
								atx425ukrService.reReference(param, function(provider, response)	{
									if(!Ext.isEmpty(provider)){
										Ext.each(provider, function(record,i){
											UniAppManager.app.onNewDataButtonDown();
											masterGrid.setNewDataATX100T(record);
										});
									}
								});
								sumTable.setValue('SAVE_FLAG_MASTER','N');
								panelSearch.setValue('reRefButtonClick','DandN');
			 				}
						});
					}
				}
			},{
				xtype: 'button',
				text: '합계표',
				width: 100,
				margin: '0 5 0 0',
	//			id:'temp20',
				handler : function() {
					var me = this;
					//panelSearch.getEl().mask('로딩중...','loading-indicator');// 오류로 인해 주석
					var param = {
						"PUB_DATE_FR": panelResult.getField('PUB_DATE_FR').getStartDate(),
						"PUB_DATE_TO": panelResult.getField('PUB_DATE_TO').getEndDate(),
						"BILL_DIV_CODE": panelResult.getValue('BILL_DIV_CODE')
					};
					
					// Clip report
					var reportGubun	= baseInfo.gsReportGubun;
					if(reportGubun.toUpperCase() == 'CLIP'){
						param.PGM_ID				= 'atx425ukr';
						param.MAIN_CODE				= 'A126';
						var win = Ext.create('widget.ClipReport', {
							url		: CPATH+'/accnt/atx420clukr.do',
							prgID	: 'atx420ukr',
							extParam: param
						});
						win.center();
						win.show();
						
					// jasper Report
					} else {
						var win = Ext.create('widget.PDFPrintWindow', {
							url: CPATH+'/atx/atx420rkrPrint.do',
							prgID: 'atx420rkr',
							extParam: param
						});
						win.center();
						win.show();
					}
				}
			},{
				xtype: 'button',
				text: '명세서',
				width: 100,
				margin: '0 0 0 0',
	//			id:'temp20',
				handler : function() {
					var me = this;
					//panelSearch.getEl().mask('로딩중...','loading-indicator');// 오류로 인해 주석
					var param = {
						"PUB_DATE_FR": panelResult.getField('PUB_DATE_FR').getStartDate(),
						"PUB_DATE_TO": panelResult.getField('PUB_DATE_TO').getEndDate(),
						"BILL_DIV_CODE": panelResult.getValue('BILL_DIV_CODE')
					};
					
					// Clip report
					var reportGubun	= baseInfo.gsReportGubun;
					if(reportGubun.toUpperCase() == 'CLIP'){
						param.PGM_ID				= 'atx425ukr';
						param.MAIN_CODE				= 'A126';
						var win = Ext.create('widget.ClipReport', {
							url		: CPATH+'/accnt/atx425clukr.do',
							prgID	: 'atx425ukr',
							extParam: param
						});
						win.center();
						win.show();
						
					// jasper Report
					} else {
						var win = Ext.create('widget.PDFPrintWindow', {
							url: CPATH+'/atx/atx425rkrPrint.do',
							prgID: 'atx425rkr',
							extParam: param
						});
						win.center();
						win.show();
					}
				}
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
					var labelText = '';
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					});
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	//unilite.createForm으로 생성 할것 , title로 만들어 운영할것(cls:'moduleNameBox'이런식으로 css줄수있음), 테이블 구조로 만들것
	//flex기능은 tdAttrs{whidth:100%}이런식으로 줄것,
	var sumTable = Unilite.createForm('detailForm', { //createForm
		padding:'0 0 0 0',
		 title:'2. 감각상각자산 취득내역 합계',
		//border: 0,
		disabled: false,
		flex: 1.5,
		bodyPadding: 10,
		region: 'center',
		layout: {type: 'uniTable', columns: 5,
			tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		defaults:{width: 140},
		items: [
			{ xtype: 'uniTextfield', name:'SAVE_FLAG_MASTER', hidden:true},
			{ xtype: 'component',	html:'감각상각자산종류'},
			{ xtype: 'component',	html:'건 수'},
			{ xtype: 'component',	html:'공 급 가 액'},
			{ xtype: 'component',	html:'세 액'},
			{ xtype: 'component',	html:'비 고'},

			{ xtype: 'component', html:'⑤합&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계'},
			{ xtype: 'uniNumberfield', name:'NUM_TOT', value:0, readOnly:true},
			{ xtype: 'uniNumberfield', name:'SUPPLY_AMT_TOT', value:0, readOnly:true},
			{ xtype: 'uniNumberfield', name:'TAX_AMT_TOT', value:0, readOnly:true},
			{ xtype: 'uniTextfield', name:'REMARK_TOT', value:'', readOnly:true},

			{ xtype: 'component',	html:'⑥건&nbsp; 물,&nbsp;&nbsp; 구&nbsp; 축&nbsp; 물'},
			{ xtype: 'uniNumberfield', name:'NUM_1', value:0, readOnly:true},
			{ xtype: 'uniNumberfield', name:'SUPPLY_AMT_1', value:0, readOnly:true},
			{ xtype: 'uniNumberfield', name:'TAX_AMT_1', value:0, readOnly:true},
			{ xtype: 'uniTextfield', name:'REMARK_1', value:'', readOnly:true},

			{ xtype: 'component',	html:'⑦기&nbsp;&nbsp;&nbsp; 계&nbsp;&nbsp;&nbsp;&nbsp; 장&nbsp;&nbsp;&nbsp; 치'},
			{ xtype: 'uniNumberfield', name:'NUM_2', value:0, readOnly:true},
			{ xtype: 'uniNumberfield', name:'SUPPLY_AMT_2', value:0, readOnly:true},
			{ xtype: 'uniNumberfield', name:'TAX_AMT_2', value:0, readOnly:true},
			{ xtype: 'uniTextfield', name:'REMARK_2', value:'', readOnly:true},

			{ xtype: 'component',	html:'&nbsp;⑧차&nbsp; 량&nbsp;&nbsp;&nbsp; 운&nbsp; 반&nbsp; 구&nbsp;'},
			{ xtype: 'uniNumberfield', name:'NUM_3', value:0, readOnly:true},
			{ xtype: 'uniNumberfield', name:'SUPPLY_AMT_3', value:0, readOnly:true},
			{ xtype: 'uniNumberfield', name:'TAX_AMT_3', value:0, readOnly:true},
			{ xtype: 'uniTextfield', name:'REMARK_3', value:'', readOnly:true},

			{ xtype: 'component',	html:'&nbsp;⑨기타 감가상각자산&nbsp;'},
			{ xtype: 'uniNumberfield', name:'NUM_4', value:0, readOnly:true},
			{ xtype: 'uniNumberfield', name:'SUPPLY_AMT_4', value:0, readOnly:true},
			{ xtype: 'uniNumberfield', name:'TAX_AMT_4', value:0, readOnly:true},
			{ xtype: 'uniTextfield', name:'REMARK_4', value:'', readOnly:true}
		],
		api: {
			load: 'atx425ukrService.selectForm'	,
			submit: 'atx425ukrService.syncMaster'
		}
//		,
//		listeners:{
//			dirtychange : function ( form, dirty, eOpts )	{
//				if(!sumTable.uniOpt.inLoading && dirty)	{
//					UniAppManager.setToolbarButtons('save',true);
//				}
//			},
//			validitychange	: function ( form, valid, eOpts )	{
//				if(!sumTable.uniOpt.inLoading)	{
//					UniAppManager.setToolbarButtons('save',true);
//				}
//			}
//		}
	});

	var masterGrid = Unilite.createGrid('atx425ukrGrid1', {
		region:'south',
		store: directMasterStore,
		excelTitle: '건물등 감가상각자산 취득명세서',
			uniOpt: {
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: true,
			copiedRow:false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false, enableGroupingMenu:false},
					{id : 'masterGridTotal', 	ftype: 'uniSummary', 		showSummaryRow: false} ],
		columns:	[
			{ dataIndex: 'SAVE_FLAG'					, width: 66, hidden: true},
			{ dataIndex: 'FR_PUB_DATE'					, width: 66, hidden: true},
			{ dataIndex: 'TO_PUB_DATE'					, width: 66, hidden: true},
			{ dataIndex: 'BILL_DIV_CODE'				, width: 60, hidden: true},
			{ dataIndex: 'SEQ'							, width: 60, hidden: true},
			{ dataIndex: 'ACQ_DATE'						, width: 73},
			{ dataIndex: 'CUSTOM_CODE'					, width:150,
				editor: Unilite.popup('CUST_G',{
					textFieldName: 'CUSTOM_CODE',
					DBtextFieldName: 'CUSTOM_CODE',
//						extParam: {'CUSTOM_TYPE': ['1','2']},
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type	){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'CUSTOM_NAME'					, width:300,
				editor: Unilite.popup('CUST_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type	){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
					}
				})
			},
			{ dataIndex: 'COMPANY_NUM'					, width: 113,
				editor: {
					maxLength: 10
				}
			},
			{ dataIndex: 'ASST_DIVI'					, width: 113},
			{ dataIndex: 'SUPPLY_AMT_I'					, width: 166},
			{ dataIndex: 'TAX_AMT_I'					, width: 166},
			{ dataIndex: 'CASE_NUM'						, width: 66},
			{ dataIndex: 'UPDATE_DB_USER'				, width: 133, hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'				, width: 133, hidden: true},
			{ dataIndex: 'COMP_CODE'					, width: 80, hidden: true}
		],
		listeners:{
			beforeedit	: function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['ACQ_DATE','CUSTOM_CODE','CUSTOM_NAME','COMPANY_NUM','ASST_DIVI','SUPPLY_AMT_I','TAX_AMT_I','CASE_NUM'])){
					return true;
				}else{
					return false;
				}
			}
		},
		setNewDataATX100T:function(record){
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('FR_PUB_DATE'			,record['FR_PUB_DATE']);
			grdRecord.set('TO_PUB_DATE'			,record['TO_PUB_DATE']);
			grdRecord.set('BILL_DIV_CODE'		,record['BILL_DIV_CODE']);
			grdRecord.set('ACQ_DATE'			,record['ACQ_DATE']);
			grdRecord.set('CUSTOM_CODE'			,record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			,record['CUSTOM_NAME']);
			grdRecord.set('COMPANY_NUM'			,record['COMPANY_NUM']);
			grdRecord.set('ASST_DIVI'			,record['ASST_DIVI']);
			grdRecord.set('SUPPLY_AMT_I'		,record['SUPPLY_AMT_I']);
			grdRecord.set('TAX_AMT_I'			,record['TAX_AMT_I']);
			grdRecord.set('CASE_NUM'			,record['CASE_NUM']);
			grdRecord.set('COMP_CODE'			,record['COMP_CODE']);
		},
		addNewData:function(records){
			Ext.each(records, function(record,i){
				if(!UniAppManager.app.checkForNewDetail()) return false;
				
				var data = record;
				var seq = directMasterStore.max('SEQ');
				if(!seq) {
					seq = 1;
				}
				else {
					seq += 1;
				}
				
				var r = {
					  SEQ			: seq
					, FR_PUB_DATE	: data['FR_PUB_DATE']
					, TO_PUB_DATE	: data['TO_PUB_DATE']
					, BILL_DIV_CODE	: panelSearch.getValue('BILL_DIV_CODE')
					, ACQ_DATE		: data['ACQ_DATE']
					, CUSTOM_CODE	: data['CUSTOM_CODE']
					, CUSTOM_NAME	: data['CUSTOM_NAME']
					, COMPANY_NUM	: data['COMPANY_NUM']
					, ASST_DIVI		: data['ASST_DIVI']
					, SUPPLY_AMT_I	: data['SUPPLY_AMT_I']
					, TAX_AMT_I		: data['TAX_AMT_I']
					, CASE_NUM		: data['CASE_NUM']
					, COMP_CODE		: data['COMP_CODE']
				};
				
				var grdRecord = masterGrid.createRow(r);
			});
		}
	});

	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			items:[
				sumTable,
				{
					border: false,
					flex: 2.5,
					layout: {type: 'vbox', align: 'stretch'},
					region: 'south',
					items: [{
						title :'3. 거래처별 감가상각 자산취득명세',
						region: 'center',
						border: false
					},masterGrid
					]
				},panelResult
			]
		},
			panelSearch
		],
		id	: 'atx425ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['newData','reset'],false);

			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PUB_DATE_FR');
			this.setDefault();
		},
		onQueryButtonDown : function()	{

			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				panelSearch.setValue('reRefButtonClick','');
				var param= panelSearch.getValues();
				param.PUB_DATE_FR = panelSearch.getField('PUB_DATE_FR').getStartDate();
				param.PUB_DATE_TO = panelSearch.getField('PUB_DATE_TO').getEndDate();
				sumTable.getForm().load({params: param});
				directMasterStore.loadStoreRecords();
				UniAppManager.setToolbarButtons(['newData','reset'],true);
				panelResult.setAllFieldsReadOnly(true);
			}


		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;

			var seq = directMasterStore.max('SEQ');
			if(!seq){
				seq = 1;
			}else{
				seq += 1;
			}
			var billDivCode = panelSearch.getValue('BILL_DIV_CODE');

			var r = {
				SEQ: seq,
				BILL_DIV_CODE: billDivCode
			};
			masterGrid.createRow(r,'ACQ_DATE');
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		},
		addReference:function()	{
			var param = panelSearch.getValues();
			param.PUB_DATE_FR = panelSearch.getField('PUB_DATE_FR').getStartDate();
			param.PUB_DATE_TO = panelSearch.getField('PUB_DATE_TO').getEndDate();
			
			Ext.getBody().mask();
			atx425ukrService.reReference(param, function(records){
				Ext.getBody().unmask();
				if(records)	{
					masterGrid.addNewData(records);
				}
			});
			
		},
		onResetButtonDown: function() {
			resetButtonFlag = 'Y';
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			sumTable.clearForm();
			directMasterStore.clearData();
			UniAppManager.setToolbarButtons('save',false);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();

			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){
							masterGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
						isNewData = false;
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		setDefault: function() {
			if(resetButtonFlag != 'Y'){
				panelSearch.setValue('PUB_DATE_FR',UniDate.get('startOfMonth'));//추후 uniMonthRangefield holdable 기능 추가시 uniMonthRangefield로 변경필요
				panelSearch.setValue('PUB_DATE_TO',UniDate.get('endOfMonth'));
				panelSearch.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
				panelResult.setValue('PUB_DATE_FR',UniDate.get('startOfMonth'));
				panelResult.setValue('PUB_DATE_TO',UniDate.get('endOfMonth'));
				panelResult.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
			}
			sumTable.setValue('NUM_TOT',0);
			sumTable.setValue('SUPPLY_AMT_TOT',0);
			sumTable.setValue('TAX_AMT_TOT',0);
			sumTable.setValue('REMARK_TOT','');
			sumTable.setValue('NUM_1',0);
			sumTable.setValue('SUPPLY_AMT_1',0);
			sumTable.setValue('TAX_AMT_1',0);
			sumTable.setValue('REMARK_1','');
			sumTable.setValue('NUM_2',0);
			sumTable.setValue('SUPPLY_AMT_2',0);
			sumTable.setValue('TAX_AMT_2',0);
			sumTable.setValue('REMARK_2','');
			sumTable.setValue('NUM_3',0);
			sumTable.setValue('SUPPLY_AMT_3',0);
			sumTable.setValue('TAX_AMT_3',0);
			sumTable.setValue('REMARK_3','');
			sumTable.setValue('NUM_4',0);
			sumTable.setValue('SUPPLY_AMT_4',0);
			sumTable.setValue('TAX_AMT_4',0);
			sumTable.setValue('REMARK_4','');
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		},
		setSumTableValue:function() {
			sumTable.uniOpt.inLoading = true;
			sumTable.setValue('NUM_TOT',0);
			sumTable.setValue('SUPPLY_AMT_TOT',0);
			sumTable.setValue('TAX_AMT_TOT',0);
			sumTable.setValue('NUM_1',0);
			sumTable.setValue('SUPPLY_AMT_1',0);
			sumTable.setValue('TAX_AMT_1',0);
			sumTable.setValue('NUM_2',0);
			sumTable.setValue('SUPPLY_AMT_2',0);
			sumTable.setValue('TAX_AMT_2',0);
			sumTable.setValue('NUM_3',0);
			sumTable.setValue('SUPPLY_AMT_3',0);
			sumTable.setValue('TAX_AMT_3',0);
			sumTable.setValue('NUM_4',0);
			sumTable.setValue('SUPPLY_AMT_4',0);
			sumTable.setValue('TAX_AMT_4',0);

			var records = directMasterStore.data.items;
			Ext.each(records, function(record,i){
				if(record.get('ASST_DIVI')=='10'){
					sumTable.setValue('NUM_1',sumTable.getValue('NUM_1') + record.get('CASE_NUM'));
					sumTable.setValue('SUPPLY_AMT_1',sumTable.getValue('SUPPLY_AMT_1') + record.get('SUPPLY_AMT_I'));
					sumTable.setValue('TAX_AMT_1',sumTable.getValue('TAX_AMT_1') + record.get('TAX_AMT_I'));
				}
				else if(record.get('ASST_DIVI')=='20'){
					sumTable.setValue('NUM_2',sumTable.getValue('NUM_2') + record.get('CASE_NUM'));
					sumTable.setValue('SUPPLY_AMT_2',sumTable.getValue('SUPPLY_AMT_2') + record.get('SUPPLY_AMT_I'));
					sumTable.setValue('TAX_AMT_2',sumTable.getValue('TAX_AMT_2') + record.get('TAX_AMT_I'));
				}
				else if(record.get('ASST_DIVI')=='30'){
					sumTable.setValue('NUM_3',sumTable.getValue('NUM_3') + record.get('CASE_NUM'));
					sumTable.setValue('SUPPLY_AMT_3',sumTable.getValue('SUPPLY_AMT_3') + record.get('SUPPLY_AMT_I'));
					sumTable.setValue('TAX_AMT_3',sumTable.getValue('TAX_AMT_3') + record.get('TAX_AMT_I'));
				}
				else if(record.get('ASST_DIVI')=='90'){
					sumTable.setValue('NUM_4',sumTable.getValue('NUM_4') + record.get('CASE_NUM'));
					sumTable.setValue('SUPPLY_AMT_4',sumTable.getValue('SUPPLY_AMT_4') + record.get('SUPPLY_AMT_I'));
					sumTable.setValue('TAX_AMT_4',sumTable.getValue('TAX_AMT_4') + record.get('TAX_AMT_I'));
				}
			});
			sumTable.setValue('NUM_TOT',sumTable.getValue('NUM_1')+sumTable.getValue('NUM_2')+sumTable.getValue('NUM_3')+sumTable.getValue('NUM_4'));
			sumTable.setValue('SUPPLY_AMT_TOT',sumTable.getValue('SUPPLY_AMT_1')+sumTable.getValue('SUPPLY_AMT_2')+sumTable.getValue('SUPPLY_AMT_3')+sumTable.getValue('SUPPLY_AMT_4'));
			sumTable.setValue('TAX_AMT_TOT',sumTable.getValue('TAX_AMT_1')+sumTable.getValue('TAX_AMT_2')+sumTable.getValue('TAX_AMT_3')+sumTable.getValue('TAX_AMT_4'));

			sumTable.uniOpt.inLoading = false;
		},
		fnCheckBizNo:function(nValue) {
			var lTot, lTmp, sChkDigit
			var lTotNew, sChkDigitNew

			if(nValue == ""){
				return true;
			}else if(!Ext.isNumeric(nValue)){
				return false;
			}else if(nValue.length() != 10){
				return false;
			}

			lTot = 0;
			lTotNew = 0;

			lTot = nValue.substr(0,1) * 1
			lTot = lTot + nValue.substr(1,1) * 3
			lTot = lTot + nValue.substr(2,1) * 7
			lTot = lTot + nValue.substr(3,1) * 1
			lTot = lTot + nValue.substr(4,1) * 3
			lTot = lTot + nValue.substr(5,1) * 7
			lTot = lTot + nValue.substr(6,1) * 1
			lTot = lTot + nValue.substr(7,1) * 3

			lTotNew = nValue.substr(0,1) * 1
			lTotNew = lTotNew + nValue.substr(1,1) * 3
			lTotNew = lTotNew + nValue.substr(2,1) * 7
			lTotNew = lTotNew + nValue.substr(3,1) * 1
			lTotNew = lTotNew + nValue.substr(4,1) * 3
			lTotNew = lTotNew + nValue.substr(5,1) * 7
			lTotNew = lTotNew + nValue.substr(6,1) * 1
			lTotNew = lTotNew + nValue.substr(7,1) * 3

			lTmp = nValue.substr(1,1) * 3

		}
	});

	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "SUPPLY_AMT_I" :
					record.set("TAX_AMT_I", Math.floor(newValue * (BsaCodeInfo.gsTaxRate / 100)));
					break;
				case "COMPANY_NUM" :
					if(Unilite.validate('bizno', newValue) != true)	{
				 		if(confirm(Msg.sMB173+"\n"+Msg.sMB175))	{
				 			record.set("COMPANY_NUM",newValue);
				 			break;
				 		}else{
				 			return false;
				 		}
				 	}
				 	break;
			}
			return rv;
		}
	});

};


</script>
