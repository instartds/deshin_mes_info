<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_tex900ukrv_kd">
	<t:ExtComboStore comboType="BOR120"/>			 <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var SearchInfoWindow;	// 검색창
var ReferenceWindow;	// 참조


function appMain() {
	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_tex900ukrv_kdService.selectList',
			update	: 's_tex900ukrv_kdService.updateDetail',
			create	: 's_tex900ukrv_kdService.insertDetail',
			destroy	: 's_tex900ukrv_kdService.deleteDetail',
			syncAll	: 's_tex900ukrv_kdService.saveAll'
		}
	});


	var returnNoSearch = Unilite.createSearchForm('returnNoSearchForm', {	// 조회팝업
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120'
		},{
			fieldLabel: '결정일자',
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_RETURN_DATE',
			endFieldName: 'TO_RETURN_DATE',
			width: 350,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},{
			fieldLabel: '환급번호',
			name:'RETURN_NO',
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('RETURN_NO', newValue);
				}
			}
		},{
			fieldLabel: '비고',
			name:'REMARK',
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('REMARK', newValue);
				}
			}
		},{
			fieldLabel: 'HS NO',
			name:'HS_NO',
			xtype: 'uniTextfield',
			hidden:true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]
	});

	var otherBlSearch = Unilite.createSearchForm('otherblForm', {			// 선적참조
		layout :  {type : 'uniTable', columns : 2},
		items :[{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120'
		},{
			fieldLabel: '선적일자',
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_ED_DATE',
			endFieldName: 'TO_ED_DATE',
			width: 350,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel	 : '거래처',
			valueFieldName : 'CUSTOM_CODE',
			textFieldName  : 'CUSTOM_NAME',
			listeners : {
				'onSelected': {
					fn: function(records, type) {
						masterForm.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						masterForm.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
					},
					scope: this
				},
				'onClear': function(type)   {
					masterForm.setValue('CUSTOM_CODE', '');
					masterForm.setValue('CUSTOM_NAME', '');
				}
			}
		}),{
			fieldLabel: '수출신고번호',
			name:'ED_NO',
			xtype: 'uniTextfield'
		}]
	});



	/** Model 정의
	 */
	Unilite.defineModel('s_tex900ukrv_kdModel', {		// 관세환급등록
		fields: [
			{name: 'DIV_CODE'		,text: '사업장'		,type: 'string'		, xtype: 'uniCombobox', comboType: 'BOR120', allowBlank: false},
			{name: 'RETURN_NO'		,text: '환급번호'		,type: 'string'},
			{name: 'SEQ'			,text: '순번'			,type: 'int'},
			{name: 'CUSTOM_CODE'	,text: '거래처'		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '거래처명'		,type: 'string'},
			{name: 'ED_DATE'		,text: '신고일자'		,type: 'uniDate'},
			{name: 'ED_NO'			,text: '수출신고번호'		,type: 'string'},
			{name: 'MONEY_UNIT'		,text: '화폐단위'		,type: 'string'},
			{name: 'RT_TARGET_AMT'	,text: '수출환급대상액'	,type: 'uniPrice'	, allowBlank: false},
			{name: 'BL_SER_NO'		,text: '선적번호'		,type: 'string'},
			{name: 'RETURN_DATE'	,text: '결정일자'		,type: 'uniDate'},
			{name: 'EXCHG_RATE_O'	,text: '환율'			,type: 'uniER'},
			{name: 'RETURN_RATE'	,text: '환급율'		,type: 'uniPercent'	, allowBlank: false},
			{name: 'RETURN_AMT'		,text: '환급액'		,type: 'uniPrice'	, allowBlank: false},
			{name: 'HS_NO'			,text: 'HS_NO'		,type: 'string'},
			{name: 'REMARK'			,text: '비고'			,type: 'string'},
			{name: 'INSERT_DB_USER'	,text: '입력자'		,type: 'string'},
			{name: 'INSERT_DB_TIME'	,text: '입력한 날짜'		,type: 'string'},
			{name: 'UPDATE_DB_USER'	,text: '수정자'		,type: 'string'},
			{name: 'UPDATE_DB_TIME'	,text: '수정한 날짜'		,type: 'string'},
			//20191213 추가
			{name: 'WON_CALC_BAS'	,text: '원미만 계산법'	,type: 'string'}
		]
	});

	Unilite.defineModel('returnNoMasterModel', {		// 조회 팝업
		fields: [
			{name: 'DIV_CODE'		,text: '사업장'		,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120', allowBlank: false},
			{name: 'RETURN_NO'		,text: '환급번호'		,type: 'string'},
			{name: 'RETURN_DATE'	,text: '결정일자'		,type: 'uniDate'},
			{name: 'EXCHG_RATE_O'	,text: '환율'			,type: 'uniER'},
			{name: 'RETURN_AMT'		,text: '환급액'		,type: 'uniPrice'},
			{name: 'HS_NO'			,text: 'HS_NO'		,type: 'string'},
			{name: 'RETURN_RATE'	,text: '환급율'		,type: 'string'},
			{name: 'REMARK'			,text: '비고'			,type: 'string'},
			{name: 'INSERT_DB_USER'	,text: '입력자'		,type: 'string'},
			{name: 'INSERT_DB_TIME'	,text: '입력한 날짜'		,type: 'string'},
			{name: 'UPDATE_DB_USER'	,text: '수정자'		,type: 'string'},
			{name: 'UPDATE_DB_TIME'	,text: '수정한 날짜'		,type: 'string'}
		]
	});

	Unilite.defineModel('s_tex900ukrv_kdOTHERModel', {	// 선적 참조
		fields: [
			{name: 'CHECK_FLAG'		, text: '선택'		,type: 'string'},
			{name: 'DIV_CODE'		,text: '사업장'		,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120', allowBlank: false},
			{name: 'CUSTOM_CODE'	,text: '거래처'		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '거래처명'		,type: 'string'},
			{name: 'ED_DATE'		,text: '신고일자'		,type: 'uniDate'},
			{name: 'ED_NO'			,text: '수출신고번호'		,type: 'string'},
			{name: 'BL_SER_NO'		,text: '선적번호'		,type: 'string'},
			{name: 'BL_AMT_WON'		,text: '수출환급대상액'	,type: 'uniPrice'},
			//20191213 추가
			{name: 'WON_CALC_BAS'	,text: '원미만 계산법'	,type: 'string'}
		]
	});



	/** Store 정의(Service 정의)
	 */
	var directMasterStore = Unilite.createStore('s_tex900ukrv_kdMasterStore1',{	// 관세환급등록
		model: 's_tex900ukrv_kdModel',
		proxy: directProxy,
		uniOpt: {
			isMaster	: true,	// 상위 버튼 연결
			editable	: true,	// 수정 모드 사용
			deletable	: true,	// 삭제 가능 여부
			useNavi		: false	// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= masterForm.getValues();
			console.log(param);
			this.load({
				params : param,
				callback: function(records, operation, success){
					console.log(records);
					if(success){
						if(masterGrid.getStore().getCount() == 0){
							Ext.getCmp('GW').setDisabled(true);
						}else if(masterGrid.getStore().getCount() != 0){
							UniBase.fnGwBtnControl('GW', directMasterStore.data.items[0].data.GW_FLAG);
						}
					}
				}
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var returnNo = masterForm.getValue('RETURN_NO');
			Ext.each(list, function(record, index) {
				if(record.data['RETURN_NO'] != returnNo) {
					record.set('RETURN_NO', returnNo);
				}
			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			// 1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	// syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						// 2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("RETURN_NO", master.RETURN_NO);
						panelResult.setValue("RETURN_NO", master.RETURN_NO);

						// 3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						if (directMasterStore.count() == 0) {
							UniAppManager.app.onResetButtonDown();
						}else{
							directMasterStore.loadStoreRecords();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_tex900ukrv_kdGrid');
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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

	var returnNoMasterStore = Unilite.createStore('returnNoMasterStore', {		// 조회 팝업
		model: 'returnNoMasterModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 's_tex900ukrv_kdService.selectDetailList'
			}
		},
		loadStoreRecords: function() {
			var param= returnNoSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});
		}
	});

	var otherBlStore = Unilite.createStore('s_tex900ukrv_kdotherBlStore', {		// 선적참조
		model: 's_tex900ukrv_kdOTHERModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 's_tex900ukrv_kdService.selectBlNumMasterList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(successful)  {
					var masterRecords = directMasterStore.data.filterBy(directMasterStore.filterNewOnly);
					var estiRecords = new Array();

					if(masterRecords.items.length > 0)   {
						console.log("store.items :", store.items);
						console.log("records", records);

						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i)   {
								console.log("record :", record);
								if( (record.data['BL_SER_NO'] == item.data['BL_SER_NO'])) {
									estiRecords.push(item);
								}
							});
						});
						store.remove(estiRecords);
					}
				}
			}
		},
		loadStoreRecords : function()  {
			var param= otherBlSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	/** 검색조건 (Search Panel)
	 */
	var masterForm = Unilite.createSearchPanel('s_tex900ukrv_kdMasterForm',{
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			},
			uniOnChange: function(basicForm, dirty, eOpts) {
				if(basicForm.getField('REMARK').isDirty()){
					UniAppManager.setToolbarButtons('save', true);
				} else if(directMasterStore.getCount() != 0 && masterForm.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				}
			}
		},
		items: [{
			title: '기본정보',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				holdable: 'hold',
				allowBlank:false,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '결정일자',
				name:'RETURN_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('RETURN_DATE', newValue);
					}
				}
			},{
				fieldLabel: '환급번호',
				name:'RETURN_NO',
				xtype: 'uniTextfield',
				holdable: 'hold',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('RETURN_NO', newValue);
					}
				}
			},
			Unilite.popup('HS',{
				fieldLabel: 'HS NO',
				valueFieldName:'HS_NO',
				textFieldName:'HS_NAME',
				popupWidth:750,
				valueFieldWidth: 100,
				textFieldOnly: false,
				autoPopup: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('HS_NO', records[0].HS_NO);
							panelResult.setValue('HS_NAME', records[0].HS_NAME);
						},
						scope: this
					},
					onClear: function(type)	{
					}
				}
			}),{
				fieldLabel: '환급율',
				name:'RETURN_RATE',
				xtype: 'uniNumberfield',
				type	: 'uniPercent',
				holdable: 'hold',
				allowBlank:false,
				suffixTpl: '%',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('RETURN_RATE', newValue);
						var count = masterGrid.getStore().getCount();
						if(count > 0) {
						}
					}
				}
			},{
				fieldLabel: '비고',
				name:'REMARK',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('REMARK', newValue);
					}
				}
			}]
		}],
		api: {
//			load: 's_tex900ukrv_kdService.selectMaster',
			submit: 's_tex900ukrv_kdService.syncMaster'
		},
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
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	}); // End of var panelSearch = Unilite.createSearchForm('searchForm',{

	var panelResult = Unilite.createSearchForm('resultForm',{	// 메인상단에 있는
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [
			{
			fieldLabel: '사업장',						  // 사업장 콤보박스
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank: false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				masterForm.setValue('DIV_CODE', newValue);
				}
			}
			},{
				fieldLabel: '결정일자',
				xtype: 'uniDatefield',
				colspan: 2,
				name:'RETURN_DATE',
				value: UniDate.get('today'),
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('RETURN_DATE', newValue);
					}
				}
			},{
				fieldLabel: '환급번호',
				name:'RETURN_NO',
				xtype: 'uniTextfield',
				holdable: 'hold',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('RETURN_NO', newValue);
					}
				}
			},Unilite.popup('HS',{
				fieldLabel: 'HS NO',
				valueFieldName:'HS_NO',
				textFieldName:'HS_NAME',
				popupWidth:750,
				valueFieldWidth: 100,
				textFieldOnly: false,
				autoPopup: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							masterForm.setValue('HS_NO', records[0].HS_NO);
							masterForm.setValue('HS_NAME', records[0].HS_NAME);
						},
						scope: this
					},
					onClear: function(type)	{
					}
				}
			}),{
				fieldLabel: '환급율',
				name:'RETURN_RATE',
				xtype: 'uniNumberfield',
				type	: 'uniPercent',
				holdable: 'hold',
				suffixTpl: '%',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('RETURN_RATE', newValue);
					}
				}
			},{
				fieldLabel: '비고',
				name:'REMARK',
				width:592,
				colspan:2,
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('REMARK', newValue);
					}
				}
			}
		],
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
				if(basicForm.getField('REMARK').isDirty()){
					UniAppManager.setToolbarButtons('save', true);
				}
			}
		},
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
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});



	/** Master Grid1 정의(Grid Panel)
	 */
	var masterGrid = Unilite.createGrid('s_tex900ukrv_kdGrid', {						// 관세환급등록 그리드
		store: directMasterStore,
		layout : 'fit',
		region:'center',
		uniOpt: {
			expandLastColumn: true
		},
		tbar: [{
			xtype: 'splitbutton',
			itemId:'orderTool',
			text: '참조...',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'ReferenceBtn',
					text: '선적참조',
					handler: function() {
						openReferenceWindow();
					}
				}]
			})
		},{
			itemId : 'GWBtn',
			id:'GW',
			iconCls : 'icon-referance'  ,
			text:'기안',
			handler: function() {
				var param = panelResult.getValues();
				param.DRAFT_NO = '0';
				if(panelResult.getValue('RETURN_NO') == '') {
					alert('환급번호가 없습니다.');
					return false;
				}
				UniAppManager.app.requestApprove();
			}
		}],
		features: [
			{id: 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: true},
			{id: 'masterGridTotal',		ftype: 'uniSummary',			showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'DIV_CODE'			, width: 120, hidden:true},
			{dataIndex: 'RETURN_NO'			, width: 110,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{dataIndex: 'SEQ'				, width: 66, align: 'center'},
			{dataIndex: 'CUSTOM_CODE'		, width: 100},
			{dataIndex: 'CUSTOM_NAME'		, width: 150},
			{dataIndex: 'ED_DATE'			, width: 100},
			{dataIndex: 'ED_NO'				, width: 100},
			{dataIndex: 'RT_TARGET_AMT'		, width: 120, summaryType: 'sum'},
			{dataIndex: 'RETURN_RATE'		, width: 120},
			{dataIndex: 'RETURN_AMT'		, width: 120, summaryType: 'sum'},
			{dataIndex: 'BL_SER_NO'			, width: 120},
			{dataIndex: 'REMARK'			, width: 300},
			{dataIndex: 'INSERT_DB_USER'	, width: 80 , hidden: true},
			{dataIndex: 'INSERT_DB_TIME'	, width: 80 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width: 80 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 80 , hidden: true},
			{dataIndex: 'WON_CALC_BAS'		, width: 80 , hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['RT_TARGET_AMT', 'RETURN_RATE', 'RETURN_AMT', 'REMARK'])) {
					return true;
				} else {
					return false;
				}
			}
		},
		setEstiData:function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('RETURN_NO',		record['RETURN_NO']);
			grdRecord.set('CUSTOM_CODE',	record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME',	record['CUSTOM_NAME']);
			grdRecord.set('ED_DATE',		record['ED_DATE']);
			grdRecord.set('ED_NO',			record['ED_NO']);
			grdRecord.set('BL_SER_NO',		record['BL_SER_NO']);
			grdRecord.set('RT_TARGET_AMT',	record['BL_AMT_WON']);
			//20191213 추가
			var digit = UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
			var numDigitOfPrice	= UniFormat.Price.length - digit;
			grdRecord.set('WON_CALC_BAS',	record['WON_CALC_BAS']);
			grdRecord.set('RETURN_AMT',		UniSales.fnAmtWonCalc(Unilite.multiply(record['BL_AMT_WON'], grdRecord.get('RETURN_RATE')) / 100, grdRecord.get('WON_CALC_BAS'), 0));
		}
	}); // End of var masterGrid1 = Unilite.createGrid('s_tex900ukrv_kdGrid1', {

	var returnNoMasterGrid = Unilite.createGrid('s_tex900ukrv_kdreturnNoMasterGrid', {	// 조회 팝업 그리드
		layout : 'fit',
		store: returnNoMasterStore,
		uniOpt:{
					useRowNumberer: false
		},
		columns:  [
					 { dataIndex: 'DIV_CODE'			,  width: 120, hidden:true},
					 { dataIndex: 'RETURN_DATE'		 ,  width: 100},
					 { dataIndex: 'RETURN_NO'		   ,  width: 133},
					 { dataIndex: 'HS_NO'			   ,  width: 133},
					 { dataIndex: 'EXCHG_RATE_O'		,  width: 80,  hidden: true},
					 { dataIndex: 'RETURN_RATE'		 ,  width: 100, align: 'right'},
					 { dataIndex: 'RETURN_AMT'		  ,  width: 100},
					 { dataIndex: 'REMARK'			  ,  width: 400}
		  ] ,
		  listeners: {
			  onGridDblClick: function(grid, record, cellIndex, colName) {
					returnNoMasterGrid.returnData(record);
					UniAppManager.app.onQueryButtonDown();
					SearchInfoWindow.hide();
			  }
		  },
		  returnData: function(record)  {
				if(Ext.isEmpty(record)) {
					record = this.getSelectedRecord();
				}
				masterForm.setValues({
					'DIV_CODE':record.get('DIV_CODE'),
					'RETURN_NO':record.get('RETURN_NO'),
					'HS_NO':record.get('HS_NO'),
					'HS_NAME':record.get('HS_NAME'),
					'RETURN_RATE':record.get('RETURN_RATE'),
					'REMARK':record.get('REMARK')
				});
				panelResult.setValues({
					'DIV_CODE':record.get('DIV_CODE'),
					'RETURN_NO':record.get('RETURN_NO'),
					'HS_NO':record.get('HS_NO'),
					'HS_NAME':record.get('HS_NAME'),
					'RETURN_RATE':record.get('RETURN_RATE'),
					'REMARK':record.get('REMARK')
				});
		  }
	});

	var otherBlGrid = Unilite.createGrid('s_tex900ukrv_kdotherBlGrid', {				// 선적참조 그리드
		// title: '기본',
		layout : 'fit',
		store: otherBlStore,
		selModel : Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick : false }),
		uniOpt : {
				onLoadSelectFirst : false
			},
		columns:  [
			{ dataIndex: 'CHECK_FLAG'		,  width: 33 , hidden: true},
			{ dataIndex: 'DIV_CODE'			,  width: 120},
			{ dataIndex: 'CUSTOM_CODE'		,  width: 86},
			{ dataIndex: 'CUSTOM_NAME'		,  width: 86},
			{ dataIndex: 'ED_DATE'			, width: 100},
			{ dataIndex: 'ED_NO'			, width: 100},
			{ dataIndex: 'BL_SER_NO'		, width: 120},
			{ dataIndex: 'BL_AMT_WON'		, width: 120}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setEstiData(record.data);
			});
		}
	});



	function openSearchInfoWindow() {	// 조회검색 팝업창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '환급번호검색',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [returnNoSearch, returnNoMasterGrid], // returnNoDetailGrid],
				tbar:  ['->',
							{
								itemId : 'saveBtn',
								text: '조회',
								handler: function() {
									returnNoMasterStore.loadStoreRecords();
								},
								disabled: false
							}, {
								itemId : 'closeBtn',
								text: '닫기',
								handler: function() {
									SearchInfoWindow.hide();
								},
								disabled: false
							}
						],
				listeners : {
							 beforeshow: function( panel, eOpts )   {
								returnNoSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
								returnNoSearch.setValue('RETURN_NO',masterForm.getValue('RETURN_NO'));
								returnNoSearch.setValue('REMARK',masterForm.getValue('REMARK'));
								returnNoSearch.setValue('HS_NO',masterForm.getValue('HS_NO'));
								returnNoMasterStore.loadStoreRecords();
							 }
						}
					})
				}
				SearchInfoWindow.show();
				SearchInfoWindow.center();
			}

	function openReferenceWindow() {	// 선적참조
		if(!UniAppManager.app.checkForNewDetail()) return false;

		otherBlSearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
		otherBlSearch.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
		otherBlSearch.setValue('DIV_CODE', masterForm.getValue('DIV_CODE'));
		otherBlStore.loadStoreRecords();

		if(!ReferenceWindow) {
			ReferenceWindow = Ext.create('widget.uniDetailWindow', {
				title: '선적참조',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [otherBlSearch, otherBlGrid],
				tbar:  ['->',
										{   itemId : 'saveBtn',
											text: '조회',
											handler: function() {
												otherBlStore.loadStoreRecords();
											},
											disabled: false
										},{ itemId : 'confirmBtn',
											text: '수출환급등록',
											handler: function() {
												otherBlGrid.returnData();
												ReferenceWindow.hide();
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											text: '닫기',
											handler: function() {
												ReferenceWindow.hide();
											},
											disabled: false
										}
								]
							,
				listeners : {beforehide: function(me, eOpt) {
											// otherBlSearch.clearForm();
											// otherBlGrid,reset();
										},
							 beforeclose: function( panel, eOpts )  {
											// otherBlSearch.clearForm();
											// otherBlGrid,reset();
										},
							 beforeshow: function ( me, eOpts ) {
								otherBlStore.loadStoreRecords();
							 }
				}
			})
		}

		ReferenceWindow.show();
		ReferenceWindow.center();
	}



	Unilite.Main({
		id			: 's_tex900ukrv_kdApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			masterForm
		],
		fnInitBinding: function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			masterForm.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('RETURN_DATE'	, UniDate.get('today'));
			masterForm.setValue('RETURN_DATE'	, UniDate.get('today'));
			panelResult.setValue('RETURN_RATE'	, 0.3);
			masterForm.setValue('RETURN_RATE'	, 0.3);
			UniAppManager.setToolbarButtons(['save'],false);
		},
		onQueryButtonDown: function() {
			var returnNo = masterForm.getValue('RETURN_NO');
			if(Ext.isEmpty(returnNo)) {
				openSearchInfoWindow()
			} else {
				directMasterStore.loadStoreRecords();
				if(masterForm.setAllFieldsReadOnly(true) == false){
					return false;
				}
				if(panelResult.setAllFieldsReadOnly(true) == false){
					return false;
				}
			}
			UniAppManager.setToolbarButtons('reset', true);
		},
		checkForNewDetail:function() {
			return masterForm.setAllFieldsReadOnly(true);
			return panelResult.setAllFieldsReadOnly(true);
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			var records = directMasterStore.data.items ;
			var edDateChk = 0;
			Ext.each(records, function(item, i)   {
				if( Ext.isEmpty(item.get("ED_DATE")) ){
					edDateChk = 1;
					return false;
				}
			})
			if(edDateChk == 1){
				alert("신고일이 비어있습니다.\n선적등록에서 신고일을 입력해주세요.");
				return false;
			}
			if(masterForm.isDirty())	{
				this.fnMasterSave();
			} else if(directMasterStore.isDirty()) {
				directMasterStore.saveStore();
			}
		},
		fnMasterSave: function(){
			var param = masterForm.getValues();
			masterForm.submit({
				params: param,
				success:function(comp, action)  {
					if(directMasterStore.isDirty()) {
						directMasterStore.saveStore();
					} else {
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.updateStatus(Msg.sMB011);
					}
				},
				failure: function(form, action){
				}
			});
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterForm.getField('RETURN_NO').setReadOnly(true);
			panelResult.getField('RETURN_NO').setReadOnly(true);
			this.fnInitBinding();
			//UniAppManager.setToolbarButtons('reset', false);
		},
		onNewDataButtonDown: function() {	   // 행추가
			if(!this.checkForNewDetail()) return false;
			var grdRecord	= otherBlGrid.getSelectedRecord();
			var divCode		= masterForm.getValue('DIV_CODE');
			var compCode	= UserInfo.compCode;
			var seq = directMasterStore.max('SEQ');
			if(!seq) seq = 1;
			else  seq += 1;

			var me = this;
			var r = {
				DIV_CODE	: divCode,
				SEQ			: seq,
				CUSTOM_CODE	: grdRecord.get('CUSTOM_CODE'),
				CUSTOM_NAME	: grdRecord.get('CUSTOM_NAME'),
				ED_DATE		: grdRecord.get('ED_DATE'),
				ED_NO		: grdRecord.get('ED_NO'),
				BL_SER_NO	: grdRecord.get('BL_SER_NO'),
				RETURN_NO	: masterForm.getValue('RETURN_NO'),
				COMP_CODE	: compCode,
				//20191213 추가
				RETURN_RATE	: masterForm.getValue('RETURN_RATE')
			};
			masterGrid.createRow(r, null, masterGrid.getStore().getCount() - 1);
			UniAppManager.setToolbarButtons('reset', true);
		},
		onDeleteDataButtonDown: function() {
			var record = masterGrid.getSelectedRecord();
			if(record.phantom === true) {
				masterGrid.deleteSelectedRow();
			} else {
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						masterGrid.deleteSelectedRow();
				}
			}
		},
		requestApprove: function(){	 //결재 요청
			var gsWin = window.open('about:blank','payviewer','width=500,height=500');
			var frm			= document.f1;
			var compCode	= UserInfo.compCode;
			var divCode		= panelResult.getValue('DIV_CODE');
			var returnNo	= panelResult.getValue('RETURN_NO');
			var spText		= 'EXEC omegaplus_kdg.unilite.USP_GW_S_TEX900UKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + returnNo + "'";
			var spCall		= encodeURIComponent(spText);

//			frm.action = '/payment/payreq.php';
/*			 frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_tex900ukrv_kd&draft_no=" + '0' + "&sp=" + spCall/* + Base64.encode();
			frm.target   = "payviewer";
			frm.method   = "post";
			frm.submit(); */

			var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_tex900ukrv_kd&draft_no=" + '0' + "&sp=" + spCall/* + Base64.encode()*/;
			UniBase.fnGw_Call(gwurl,frm,'GW'); /*end*/
		}
	});



	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
				//20191213 추가
				var digit = UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.Price.length - digit;

			switch(fieldName) {
				case "RT_TARGET_AMT" :  // 수출환급대상액
					if(newValue == '1') {
						record.set('RT_TARGET_AMT','0');
					} else if(newValue) {
						//20191213 수정
						record.set('RETURN_AMT', UniSales.fnAmtWonCalc(Unilite.multiply(newValue, record.get('RETURN_RATE')) / 100, record.get('WON_CALC_BAS'), 0));
					}
					break;
				//20191213 추가
				case "RETURN_RATE" :  // 환급율
						record.set('RETURN_AMT', UniSales.fnAmtWonCalc(Unilite.multiply(newValue, record.get('RT_TARGET_AMT')) / 100, record.get('WON_CALC_BAS'), 0));
					break;
			}
			return true;
		}
	});
};
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>