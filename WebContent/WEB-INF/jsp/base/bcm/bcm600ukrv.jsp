<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm600ukrv">
	<t:ExtComboStore comboType="AU" comboCode="B046"/>	<!-- 완료구분 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >
function appMain() {
	var selectedGrid = 'bcm600ukrvGrid1';			// Grid1 createRow Default

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bcm600ukrvService.selectMaster',
			update	: 'bcm600ukrvService.updateMaster',
			create	: 'bcm600ukrvService.insertMaster',
			destroy	: 'bcm600ukrvService.deleteMaster',
			syncAll	: 'bcm600ukrvService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bcm600ukrvService.selectDetail',
			update	: 'bcm600ukrvService.updateDetail',
			create	: 'bcm600ukrvService.insertDetail',
			destroy	: 'bcm600ukrvService.deleteDetail',
			syncAll	: 'bcm600ukrvService.saveAll2'
		}
	});



	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Bcm600ukrvModel1', {
		fields: [
			{name: 'UPDATE_DB_USER'	,text: '<t:message code="system.label.base.writer" default="작성자"/>'			,type: 'string'},
			{name: 'UPDATE_DB_TIME'	,text: '<t:message code="system.label.base.writtentiem" default="작성시간"/>'	,type: 'string'},
			{name: 'PJT_CODE'		,text: '<t:message code="system.label.base.projectno" default="프로젝트번호"/>'	,type: 'string', allowBlank: false},
			{name: 'PJT_NAME'		,text: '<t:message code="system.label.base.projectname" default="프로젝트명"/>'	,type: 'string', allowBlank: false},
			{name: 'PJT_AMT'		,text: '<t:message code="system.label.base.amount" default="금액"/>'			,type: 'uniPrice'},
			{name: 'FR_DATE'		,text: '<t:message code="system.label.base.startdate" default="시작일"/>'		,type: 'uniDate', allowBlank: false},
			{name: 'TO_DATE'		,text: '<t:message code="system.label.base.enddate" default="종료일"/>'		,type: 'uniDate', allowBlank: false},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.base.custom" default="거래처"/>'			,type: 'string', allowBlank: false},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.base.customname" default="거래처명"/>'	,type: 'string', allowBlank: false},
			{name: 'START_DATE'		,text: '<t:message code="system.label.base.startdate2" default="개시일"/>'		,type: 'uniDate'},
			{name: 'SAVE_CODE'		,text: '<t:message code="system.label.base.bankbookcode" default="통장코드"/>'	,type: 'string'},
			{name: 'SAVE_NAME'		,text: '<t:message code="system.label.base.bankbook" default="통장명"/>'		,type: 'string'},
			{name: 'DIVI'			,text: '<t:message code="system.label.base.completion" default="완료구분"/>'	,type: 'string', comboType:'AU', comboCode:'B046'},
			{name: 'COMP_CODE'		,text: 'COMP_CODE'	,type: 'string'}
		]
	});		//End of Unilite.defineModel('Bcm600ukrvModel', {

	Unilite.defineModel('Bcm600ukrvModel2', {
		fields: [
			{name: 'UPDATE_DB_USER'	,text: '<t:message code="system.label.base.writer" default="작성자"/>'			,type: 'string'},
			{name: 'UPDATE_DB_TIME'	,text: '<t:message code="system.label.base.writtentiem" default="작성시간"/>'	,type: 'string'},
			{name: 'PJT_CODE'		,text: '<t:message code="system.label.base.projectno" default="프로젝트번호"/>'	,type: 'string'},
			{name: 'INPUT_DATE'		,text: '<t:message code="system.label.base.caldate" default="일자"/>'			,type: 'uniDate', allowBlank: false},
			{name: 'AMT'			,text: '<t:message code="system.label.base.amount" default="금액"/>'			,type: 'uniPrice'},
			{name: 'BEFORE_AMT'		,text: '<t:message code="system.label.base.acashadvance" default="선수금"/>'	,type: 'uniPrice'},
			{name: 'REMARK'			,text: '<t:message code="system.label.base.remark" default="적요"/>'			,type: 'string'},
			{name: 'COMP_CODE'		,text: 'COMP_CODE'	,type: 'string'}
		]
	});		//End of Unilite.defineModel('Bcm600ukrvModel', {



	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('bcm600ukrvMasterStore',{
		proxy	: directProxy,
		model	: 'Bcm600ukrvModel1',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
//				if(records[0] != null){
//					panelSearch.setValue('PJT_CODE',records[0].get('PJT_CODE'));
//					if(panelSearch.getValue('PJT_CODE') != ''){
//						directDetailStore.loadStoreRecords(records);
//					}
//				} else {
//					panelSearch.setValue('PJT_CODE', ''); 
//					detailGrid.getStore().removeAll();
//				}
			}
		},
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			//var rv = true;
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						//panelResult.resetDirtyStatus();
						if(directDetailStore.isDirty()) {
							directDetailStore.saveStore();
						}
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});		// End of var directMasterStore = Unilite.createStore('bcm600ukrvMasterStore1',{

	var directDetailStore = Unilite.createStore('bcm600ukrvDetailStore',{
		model	: 'Bcm600ukrvModel2',
		proxy	: directProxy2,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(record) {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore : function(config) {	
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				/*
				var records = this.getData();
				Ext.each(records, function(record,i) {
					Unilite.messageBox(record[i].PJT_CODE);
				});
				*/
				config = {
					success: function(batch, option) {
						//panelResult.resetDirtyStatus();
						if(directMasterStore.isDirty()) {
							directMasterStore.saveStore();
						}
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect();
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		//20200310 추가
		_onStoreLoad: function ( store, records, successful, eOpts ) {
			var records1	= directMasterStore.data.items;
			var records2	= directDetailStore.data.items;
			var allrecords	= [].concat(records1, records2);
			if(allrecords.length > 0) {
				UniAppManager.setToolbarButtons(['newData', 'delete'], true);
			}
			if(directMasterStore.isDirty() || directMasterStore.isDirty()) {
				UniAppManager.setToolbarButtons(['save'], true);
			}
			if(this.uniOpt.isMaster) {
				if(records) {
					if(records.length > 0) {
						var msg = records.length + Msg.sMB001;				//'건이 조회되었습니다.';
						UniAppManager.updateStatus(msg, true);
					}
				}
			}
		}
	});		// End of var directDetailStore = Unilite.createStore('bcm600ukrvDetailStore',{



	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
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
			title		: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
   			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.base.projectno" default="프로젝트번호"/>',
				xtype		: 'uniTextfield',
				name		: 'PROJECT_CODE',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PROJECT_CODE', newValue);
					},
					onClear: function(type) {
						panelResult.setValue('PROJECT_CODE', '');
					}
				}
			},{ 
				fieldLabel	: '<t:message code="system.label.base.projectname" default="프로젝트명"/>',
				xtype		: 'uniTextfield',
				name		: 'PROJECT_NAME',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PROJECT_NAME', newValue);
					},
					onClear: function(type) {
						panelResult.setValue('PROJECT_NAME', '');
					}
				}
			},
			Unilite.popup('CUST', {
				fieldLabel		: '<t:message code="system.label.base.custom" default="거래처"/>',
				valueFieldName	: 'CUST_CODE', 
				textFieldName	: 'CUST_NAME',
				validateBlank	: false,			//20210803 추가
				popupWidth		: 710,
				listeners		: {
					//20210803 수정: 조회조건 팝업설정에 맞게 변경
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUST_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUST_NAME', '');
							panelResult.setValue('CUST_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUST_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUST_CODE', '');
							panelResult.setValue('CUST_CODE', '');
						}
//					},
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('CUST_CODE', panelSearch.getValue('CUST_CODE'));
//							panelResult.setValue('CUST_NAME', panelSearch.getValue('CUST_NAME'));
//						},
//						scope: this
//					},
//					onClear: function(type) {
//						panelResult.setValue('CUST_CODE', '');
//						panelResult.setValue('CUST_NAME', '');
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.base.completion" default="완료구분"/>',
				name		: 'STATE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B046',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('STATE', newValue);
					}
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.base.periodcondition" default="기간조건"/>',
				id			: 'rdoSelectPnl',
				labelWidth	: 90,
				items: [{
					boxLabel	: '<t:message code="system.label.base.startdate" default="시작일"/>', 
					width		: 70,
					name		: 'rdoSelect',
					inputValue	: '1', 
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.base.enddate" default="종료일"/>', 
					width		: 70, 
					name		: 'rdoSelect', 
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
						//Unilite.messageBox("========" + newValue.rdoSelect);
						//panelResult.setValue('rdoSelect', newValue.rdoSelect);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.product.period" default="기간"/>',
				startFieldName	: 'FR_DATE',
				endFieldName	: 'TO_DATE',
				xtype			: 'uniDateRangefield',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('FR_DATE',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('TO_DATE',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
						
					}
				}
			},{
				fieldLabel	: '조회후 선택된 프로젝트번호',
				name		: 'PJT_CODE',
				xtype		: 'uniTextfield',
				hidden		: true
			}]
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r = false;
					var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					  var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});		// End of var panelSearch = Unilite.createSearchForm('searchForm',{	

	var panelResult = Unilite.createSearchForm('resultForm',{
		weight	: -100,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.base.projectno" default="프로젝트번호"/>',
			xtype		: 'uniTextfield',
			name		: 'PROJECT_CODE',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PROJECT_CODE', newValue);
				},
				onClear: function(type) {
					panelSearch.setValue('PROJECT_CODE', '');
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.base.projectname" default="프로젝트명"/>',
			xtype		: 'uniTextfield',
			name		: 'PROJECT_NAME',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PROJECT_NAME', newValue);
				},
				onClear: function(type) {
					panelSearch.setValue('PROJECT_NAME', '');
				}
			}
		},
		Unilite.popup('CUST', {
			fieldLabel		: '<t:message code="system.label.base.custom" default="거래처"/>',
			valueFieldName	: 'CUST_CODE', 
			textFieldName	: 'CUST_NAME',
			validateBlank	: false,		//20210803 수정: 주석 해제
//			labelWidth		: 150,
			popupWidth		: 710,
			listeners		: {
				//20210803 수정: 조회조건 팝업설정에 맞게 변경
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUST_CODE', newValue);
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUST_NAME', '');
						panelResult.setValue('CUST_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUST_NAME', newValue);
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUST_CODE', '');
						panelResult.setValue('CUST_CODE', '');
					}
//				},
//				onSelected: {
//					fn: function(records, type) {
//						panelResult.setValue('CUST_CODE', panelSearch.getValue('CUST_CODE'));
//						panelResult.setValue('CUST_NAME', panelSearch.getValue('CUST_NAME'));
//					},
//					scope: this
//				},
//				onClear: function(type) {
//					panelResult.setValue('CUST_CODE', '');
//					panelResult.setValue('CUST_NAME', '');
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.base.completion" default="완료구분"/>',
			name		: 'STATE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B046',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('STATE', newValue);
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.base.periodcondition" default="기간조건"/>',
			id			: 'rdoSelectRlt',
			items		: [{
				boxLabel	: '<t:message code="system.label.base.startdate" default="시작일"/>',
				width		: 80,
				name		: 'rdoSelect',
				inputValue	: '1', 
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.base.enddate" default="종료일"/>',
				width		: 60,
				name		: 'rdoSelect',
				inputValue	: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
					//Unilite.messageBox("========" + newValue.rdoSelect);
					//panelSearch.setValue('rdoSelect', newValue.rdoSelect);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.product.period" default="기간"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FR_DATE',newValue);
					//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TO_DATE',newValue);
					//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
				}
			}
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
					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					  var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
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



	/** Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid= Unilite.createGrid('bcm600ukrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,		//20200310 추가
			expandLastColumn	: true,
			useLiveSearch		: true,
			useContextMenu		: false,		//20200310 수정: true -> false
			useMultipleSorting	: true,
			useGroupSummary		: false,
			//useRowNumberer	: false,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		features: [
			{id : 'MasterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id : 'MasterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns:  [
			{dataIndex:'UPDATE_DB_USER'				, width: 0,hidden:true},
			{dataIndex:'UPDATE_DB_TIME'				, width: 0,hidden:true},
			{dataIndex:'PJT_CODE'					, width: 100}, 
			{dataIndex:'PJT_NAME'					, width: 300}, 
			{dataIndex:'PJT_AMT'					, width: 133}, 
			{dataIndex:'FR_DATE'					, width: 86},  
			{dataIndex:'TO_DATE'					, width: 86},  
			{dataIndex:'CUSTOM_CODE'				, width: 86,
				editor: Unilite.popup('AGENT_CUST_G', {
 				DBtextFieldName: 'CUSTOM_CODE',
 				extParam: {AGENT_TYPE: '4'},
				autoPopup: true,			
 				listeners: {'onSelected': {
						fn: function(records, type) {
							Ext.each(records, function(record,i) {
								if(i==0) {
									var grdRecord = masterGrid.getSelectedRecord(); 
									grdRecord.set('CUSTOM_CODE',record['CUSTOM_CODE'] );
									grdRecord.set('CUSTOM_NAME',record['CUSTOM_NAME'] );
								}
							}); 
						},
						scope: this
					},
					'onClear': function(type) {
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('CUSTOM_CODE','');
						grdRecord.set('CUSTOM_NAME','');
					}
				}
			})},  
			{dataIndex:'CUSTOM_NAME'				, width: 166,
				editor: Unilite.popup('AGENT_CUST_G', {
 				DBtextFieldName: 'CUSTOM_CODE',
 				extParam: {AGENT_TYPE: '4'},
				autoPopup: true,			
 				listeners: {'onSelected': {
						fn: function(records, type) {
							Ext.each(records, function(record,i) {
								if(i==0) {
									var grdRecord = masterGrid.getSelectedRecord(); 
									grdRecord.set('CUSTOM_CODE',record['CUSTOM_CODE'] );
									grdRecord.set('CUSTOM_NAME',record['CUSTOM_NAME'] );
								}
							}); 
						},
						scope: this
					},
					'onClear': function(type) {
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('CUSTOM_CODE','');
						grdRecord.set('CUSTOM_NAME','');
					}
				}
			})},   
			{dataIndex:'START_DATE'					, width: 86},
			{dataIndex:'SAVE_CODE'					, width: 66,
				editor: Unilite.popup('BANK_BOOK_G', {
					DBtextFieldName: 'BANK_BOOK_NAME',
					autoPopup: true,			
					listeners: {'onSelected': {
							fn: function(records, type) {
								Ext.each(records, function(record,i) {
									if(i==0) {
										var grdRecord = masterGrid.getSelectedRecord(); 
										grdRecord.set('SAVE_CODE',record['BANK_BOOK_CODE'] );
										grdRecord.set('SAVE_NAME',record['BANK_BOOK_NAME'] );
									}
								}); 
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('SAVE_CODE','');
							grdRecord.set('SAVE_NAME','');
						}
					}
			})},	
			{dataIndex:'SAVE_NAME'					, width: 120,
				editor: Unilite.popup('BANK_BOOK_G', {
					DBtextFieldName: 'BANK_BOOK_NAME',
					autoPopup: true,
					listeners: {'onSelected': {
							fn: function(records, type) {
								Ext.each(records, function(record,i) {
									if(i==0) {
										var grdRecord = masterGrid.getSelectedRecord(); 
										grdRecord.set('SAVE_CODE',record['BANK_BOOK_CODE'] );
										grdRecord.set('SAVE_NAME',record['BANK_BOOK_NAME'] );
									}
								}); 
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('SAVE_CODE','');
							grdRecord.set('SAVE_NAME','');
						}
					}
			})},			
			{dataIndex:'DIVI'						, width: 100, align: 'center'},
			{dataIndex:'COMP_CODE'					, width: 0,hidden:true}
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {	//Retrieves the top level element representing this component
					//20200310 추가
					var oldGrid = Ext.getCmp(selectedGrid);
					grid.changeFocusCls(oldGrid);
					if(directDetailStore.isDirty()){			//Returns true if the value of this Field has been changed from its originalValue. Will return false if the field is disabled or has not been rendered 
						//Unilite.messageBox(Msg.sMB154);
						//return;
					}
					selectedGrid = girdNm
					//20200310 주석
//					UniAppManager.setToolbarButtons(['newData', 'delete'], true);
				});
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if (UniUtils.indexOf(e.field,['PJT_CODE']))
						return false;
				}
			},
			//20200310 주석
//			selectionchangerecord:function(record , selected) {
//				panelSearch.setValue('PJT_CODE',record.get('PJT_CODE'));
//				directDetailStore.loadStoreRecords(record);
//			},
			//20200310 추가
			beforeselect: function(grid, selected, index, rowIndex, eOpts ){
				if(directDetailStore.isDirty()) {
					if(confirm('<t:message code="system.message.sales.message020" default="내용이 변경되었습니다."/> <t:message code="system.message.sales.message021" default="변경된 내용을 저장하시겠습니까?"/>'))	{
						UniAppManager.app.onSaveDataButtonDown();
					} else {
						return false;
					}
				}
			},
			select: function(grid, selected, index, rowIndex, eOpts ){
				if(!Ext.isEmpty(selected)) {
					panelSearch.setValue('PJT_CODE', selected.get('PJT_CODE'));
					directDetailStore.loadStoreRecords();
				} else {
					directDetailStore.loadData({});
				}
			}
		}
	});

	var detailGrid = Unilite.createGrid('bcm600ukrvGrid2', {
		store	: directDetailStore,
		layout	: 'fit',
		region	: 'south',
		uniOpt	: {
			expandLastColumn	: true,
			useLiveSearch		: true,
			useContextMenu		: false,		//20200310 수정: true -> false
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useRowNumberer		: false,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		features: [
			{id : 'MasterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id : 'MasterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns:  [
			{dataIndex:'UPDATE_DB_USER'	, width:0,hidden:true},
			{dataIndex:'UPDATE_DB_TIME'	, width:0,hidden:true},
			{dataIndex:'PJT_CODE'		, width:90,hidden:true},
			{dataIndex:'INPUT_DATE'		, width:86},
			{dataIndex:'AMT'			, width:133},
			{dataIndex:'BEFORE_AMT'		, width:133},
			{dataIndex:'REMARK'			, width:133},
			{dataIndex:'COMP_CODE'		, width:0,hidden:true}
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					//20200310 추가
					var oldGrid = Ext.getCmp(girdNm);
					grid.changeFocusCls(selectedGrid);
					if(directMasterStore.isDirty()){
						//Unilite.messageBox(Msg.sMB154);
						//return;
					}
					selectedGrid = girdNm
					//20200310 주석
//					UniAppManager.setToolbarButtons(['newData', 'delete'], true);
				});
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if (UniUtils.indexOf(e.field,['INPUT_DATE']))
						return false;
				}
			}
		}
	});		// End of var detailGrid= Unilite.createGrid('bcm600ukrvGrid2', {



	Unilite.Main({
		id			: 'bcm600ukrvApp',
		borderItems	: [{
		region		: 'center',
		layout		: 'border',
		border		: false,
		items		: [
			panelResult, masterGrid, detailGrid
		]},
		panelSearch
		],
		fnInitBinding: function() {
			//panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons('detail',false);
			panelSearch.setValue('TO_DATE', UniDate.get('today'));
			panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth', panelSearch.getValue('TO_DATE')));
			panelResult.setValue('TO_DATE', UniDate.get('today'));
			panelResult.setValue('FR_DATE', UniDate.get('startOfMonth', panelSearch.getValue('TO_DATE')));
		},
		onQueryButtonDown: function() {	
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			detailGrid.getStore().loadData({});
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons(['reset','newData', 'delete'],true);
		},
		onNewDataButtonDown : function() {
			if(selectedGrid == 'bcm600ukrvGrid1'){
				if(directDetailStore.isDirty()) {
					if(confirm('<t:message code="system.message.sales.message020" default="내용이 변경되었습니다."/> <t:message code="system.message.sales.message021" default="변경된 내용을 저장하시겠습니까?"/>'))	{
						UniAppManager.app.onSaveDataButtonDown();
					} else {
						return false;
					}
				}
				var r = {
					DIVI: 'N'
				};
				masterGrid.createRow(r, 'PJT_CODE', masterGrid.getStore().getCount()-1);
				panelSearch.setAllFieldsReadOnly(true);
				UniAppManager.setToolbarButtons('save', true);
			}
			else if(selectedGrid == 'bcm600ukrvGrid2'){
				var selRow = masterGrid.getSelectedRecord();
				//Unilite.messageBox(selRow.get('PJT_CODE'));
				var pjtCode  = selRow.get('PJT_CODE');
				if(Ext.isEmpty(pjtCode)){
					Unilite.messageBox("먼저 상단그리드 선택행의 프로젝트번호를 입력해 주세요");
					return;
				};
				var statCode  = selRow.get('DIVI');
				if(statCode == 'Y'){
					Unilite.messageBox('<t:message code="unilite.msg.sMB027"/>');
					return;
				};
				var r = {
					PJT_CODE	: pjtCode,
					AMT			: 0
				};
				detailGrid.createRow(r, 'INPUT_DATE', detailGrid.getStore().getCount()-1);
				panelSearch.setAllFieldsReadOnly(true);
				UniAppManager.setToolbarButtons('save', true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.setAllFieldsReadOnly(false);
			masterGrid.getStore().loadData({});
			detailGrid.getStore().loadData({});

			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save', false);
		},
		onSaveDataButtonDown: function(config) {
			if(directMasterStore.isDirty()) {
				directMasterStore.saveStore();
			} else if(directDetailStore.isDirty()) {
				directDetailStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			if(selectedGrid == 'bcm600ukrvGrid1'){
				var selIndex = masterGrid.getSelectedRowIndex();
				var selRow = masterGrid.getSelectedRecord();
				var statCode  = selRow.get('DIVI');
				if(statCode == 'Y'){
					Unilite.messageBox('<t:message code="unilite.msg.sMB027"/>');
					return;
				};
				if(selRow.phantom != true && directDetailStore.getCount() > 0 ) {
					//Unilite.messageBox("등록한 날자별 금액이 존재하는 프로젝트번호는 삭제가 불가능 합니다.");
					Unilite.messageBox('<t:message code="unilite.msg.sMB028"/>');
					return;
				} else if(confirm('현재행을 삭제 합니다.\n삭제 하시겠습니까?')) {
					masterGrid.deleteSelectedRow(selIndex);
//					masterGrid.getStore().onStoreActionEnable();
				}
			} else if(selectedGrid == 'bcm600ukrvGrid2'){
				var mstSelRow = masterGrid.getSelectedRecord();
				var statCode  = mstSelRow.get('DIVI');
				if(statCode == 'Y'){
					Unilite.messageBox('<t:message code="unilite.msg.sMB027"/>');
					return;
				};	
				var selIndex = detailGrid.getSelectedRowIndex();
				var selRow = detailGrid.getSelectedRecord();
				if(selRow.phantom == true)
					detailGrid.deleteSelectedRow();
				else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					detailGrid.deleteSelectedRow();
				}
			}
		}
	});		// End of Unilite.Main({



	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			switch(fieldName) {
				case "AMT" : // 금액
					if(newValue <= '0') {
						rv= Msg.sMB076;	
						break;
					}
					if(record.get('AMT') < record.get('BEFORE_AMT')) {
						//rv= Msg.sMM338;	
						rv= "금액이 선수금보다 작을수 없습니다";
						break;
					}
				break;

				case "BEFORE_AMT" : // 선수금
					if(newValue <= '0') {
						rv= Msg.sMB076;	
						break;
					}
					if(record.get('AMT') < record.get('BEFORE_AMT')) {
						//rv= Msg.sMM338;	
						rv= "금액이 선수금보다 작을수 없습니다";
						break;
					}
				break;
			}
			return rv;
		}
	});
};
</script>