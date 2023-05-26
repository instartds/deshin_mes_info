<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sat300ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sat300ukrv" />				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S175"/>						<!-- 배송방법 -->
	<t:ExtComboStore comboType="AU" comboCode="S178"/>						<!-- 자산정보 -->
	<t:ExtComboStore comboType="AU" comboCode="S179"/>						<!-- 구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S177"/>						<!-- 현재상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B131"/>						<!-- 예/아니오 -->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>
<script type="text/javascript">

function appMain() {
	
	var outYnStore = Ext.create('Ext.data.Store', {
	    fields: ['value', 'text'],
	    data : [
	        {'value':'1', 'text':'출고요청'},
	        {'value':'2', 'text':'연장이동신청'}
	    ]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sat300ukrvService.selectList',
			create	: 'sat300ukrvService.insertDetail',
			update	: 'sat300ukrvService.updateDetail',
			destroy	: 'sat300ukrvService.deleteDetail',
			syncAll	: 'sat300ukrvService.saveAll'
		}
	});

	

	//마스터 모델
	Unilite.defineModel('sat300ukrvModel',{
		fields: [
 			  {name : 'DIV_CODE'        , text : '사업장코드'     	, type : 'string'   , allowBlank : false   , comboType: "BOR120" , editable : false}
 			, {name : 'RESERVE_NO'      , text : '예약번호'     	, type : 'string'   , editable : false }
 			, {name : 'RESERVE_SEQ'     , text : '예약순번'      	, type : 'string'   , editable : false }
 			, {name : 'ASST_CODE'       , text : '자산코드'     	, type : 'string'   , allowBlank : false   , editable : false }
 			, {name : 'REQ_YN'          , text : '출고요청여부'     	, type : 'string'   , allowBlank : false   , editable : false , comboType: "AU"	,comboCode:"B131", defaultValue :'N'}
 			, {name : 'ASST_NAME'       , text : '자산명'      	, type : 'string'   , allowBlank : false   , editable : false }
			, {name : 'SERIAL_NO'       , text : 'S/N'          , type : 'string'   , allowBlank : false   , editable : false }
			, {name : 'ASST_INFO'       , text : '자산정보'  		, type : 'string'   , comboType: "AU"	,comboCode:"S178" , editable : false }
			, {name : 'ASST_GUBUN'      , text : '구분'  			, type : 'string'  	, comboType: "AU"	,comboCode:"S179" , editable : false }
			, {name : 'ASST_STATUS'     , text : '현재상태'  		, type : 'string'  	, comboType: "AU"	,comboCode:"S177" , editable : false}
			
		]
	});// End of Unilite.defineModel('Ssa101ukrvModel',{

	// 마스터 스토어 정의
	var masterStore = Unilite.createStore('sat300ukrvStore',{
		model	: 'sat300ukrvModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,	// 삭제 가능 여부
			allDeletable: true,	// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param		= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			// 1. 마스터 정보 파라미터 구성
			var paramMaster = panelResult.getValues();	// syncAll 수정

			if((inValidRecs.length == 0)) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						if(batch.operations && batch.operations.length > 0 && batch.operations[0]._resultSet)	{
							
							if(batch.operations[0]._resultSet.DELETEALL == "Y")	{
								UniAppManager.app.onResetButtonDown();
								return;
							} else {
								panelResult.uniOpt.inLoading = true;
								panelResult.setValue('RESERVE_NO', batch.operations[0]._resultSet.RESERVE_NO);
								panelResult.uniOpt.inLoading = false;
							}
						}
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus()
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.setToolbarButtons(['deleteAll'],true);
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('sat300ukrvGrid');
				if(!Ext.isEmpty(inValidRecs))	{
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		},
		listeners : {
			load : function(store, records) {
				if(records && records.length > 0){
					masterStore.uniOpt.deletable	= true;
					masterStore.uniOpt.allDeletable	= true;
					UniAppManager.setToolbarButtons(['deleteAll'], true);
					UniAppManager.setToolbarButtons(['delete'], true);
					var deletable = false; 
					Ext.each(records, function(record)	{
						if(record.get("REQ_YN")=="Y")	{
							panelResult.setAllFieldsReadOnly(true);
							masterStore.uniOpt.allDeletable	= false;
							UniAppManager.setToolbarButtons(['deleteAll'], false);
						} else {
							deletable = true;
							masterStore.uniOpt.deletable	= true;
							UniAppManager.setToolbarButtons(['delete'], true);
						}
					});
					if(!deletable)	{
						masterStore.uniOpt.deletable	= false;
						UniAppManager.setToolbarButtons(['delete'], false);
					}
				}
			}
		}
	});

	//마스터 폼
	var panelResult =  Unilite.createForm('resultForm',{
		region: 'north',	
    	disabled : false,
    	bodyStyle : {'background-color':'#fff;border-width: 0px;'},
		layout : {type : 'uniTable', columns : 3, tableAttrs:{width : 1050, border : 0}},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			tdAttrs     : {width : 350},
			value		: UserInfo.divCode
		},{
			fieldLabel	: '예약번호',
			name		: 'RESERVE_NO',
			tdAttrs     : {width : 500},
			readOnly    : true
		},{
			xtype       : 'button',
			text        : '자산참조',
			tdAttrs     : { valign : 'top', width : 200},
			rowspan     : 9,
			handler     : function()	{
				var asstPopup = panelResult.down('#ASST_POPUP');
				asstPopup.openPopup();
			}
		},Unilite.popup('AS_ASST',
			{
				hidden : true,
				extParam  : {'ASST_STATUS' : '예약'},
				itemId : 'ASST_POPUP',
				popupWidth: 1100,
				listeners : {
					onSelected : function(records, type) {
						var insertedData = masterStore.getData();
						var messages = '';
						if(records) {
							Ext.each(records, function(record, idx) {
								var checkAsstCode = true;
								
								if(!Ext.isEmpty(insertedData))	{
									Ext.each(insertedData.items, function(record2, idx) {
										if(record.ASST_CODE == record2.get("ASST_CODE"))	{
											checkAsstCode = false;
											messages = messages + record2.get("ASST_NAME")+'('+record2.get("ASST_CODE")+')'+'\n';
											return;
										}
									});
								}
								if(checkAsstCode)	{
									UniAppManager.app.onNewDataButtonDown(record);
								} 
							});
							if(!Ext.isEmpty(messages)) {
								Unilite.messageBox('이미 추가되어 있는 자산코드가 있습니다.', messages);
							}
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE"), 'SELMODEL':'MULTI'});
					}
				}
			}
		),{
			fieldLabel	: '예약요청일',
			name		: 'RESERVE_DATE',
			xtype       : 'uniDatefield',
			allowBlank	: false,
			value       : UniDate.today()
		},{
			fieldLabel	: '예약출고일',
			name		: 'REQ_OUT_DATE',
			xtype       : 'uniDatefield',
			allowBlank	: false,
			value       : UniDate.today()
		},{
			fieldLabel	: '납품처',
			allowBlank	: false,
			name		: 'CUSTOM_NAME'
		},Unilite.popup('CUST',{
			fieldLabel  : '대리점',
			allowBlank	: false,
			valueFieldName:'AGENT_CUSTOM_CODE',
			textFieldName:'AGENT_CUSTOM_NAME'
		}),{
			xtype       : 'uniTextfield',
			fieldLabel  : '수령지',
			name        : 'DELIVERY_ADDRESS',
			width       : 810,
			colspan     : 2
		},{
			fieldLabel	: '사용구분',
			name		: 'USE_GUBUN',
			xtype       : 'uniCombobox',
			comboType   : 'AU',
			comboCode   : 'S178',
			allowBlank	: false
		},{
			xtype       :'container',
			layout      : 'hbox',
			items       :[
				{	
					fieldLabel : '사용기간',
					xtype : 'uniDatefield',
					width : 180,
					name  : 'USE_FR_DATE'
				},{
					hideLable : true,	
					fieldLabel : '',
					width : 85,
					xtype : 'uniTimefield',
					name  : 'USE_FR_TIME'
				},{	
					fieldLabel : '~',
					labelWidth : 15,
					xtype : 'uniDatefield',
					name  : 'USE_TO_DATE',
					width : 110
				},{
					hideLable : true,	
					fieldLabel : '',
					xtype : 'uniTimefield',
					name  : 'USE_TO_TIME',
					width : 85
				}
			]
		},{
			xtype       : 'container',
			layout      : 'hbox',
			items       :[
				{
					fieldLabel : '버튼스위치',
					xtype : 'uniCheckboxgroup',
					items : [{
						name  : 'BUTTON_G7_YN',
						boxLabel  : 'G7',
						inputValue :'Y'
					}]
				},{
					xtype      : 'uniNumberfield',
					hideLabel  : true,
					suffixTpl  : 'SET&nbsp;',
					width      : 80,
					name       : 'BUTTON_G7_SET',
					listeners  : {
						change : function(field, newValue, oldValue)	{
							if(newValue != oldValue && newValue > 0)	{
									panelResult.setValue("BUTTON_G7_YN", "Y")
							}else if(newValue == 0 || Ext.isEmpty(newValue))	{
								panelResult.setValue("BUTTON_G7_YN", "")
							}
						}
					}
				},{
					fieldLabel : '/',
					labelWidth : 10,
					xtype : 'uniCheckboxgroup',
					items : [{
						name  : 'BUTTON_G5_YN',
						boxLabel  : 'G5',
						inputValue :'Y'
					}]
				},{
					xtype      : 'uniNumberfield',
					fieldLabel : '',
					hideLabel  : true,
					suffixTpl  : 'SET&nbsp;',
					width      : 80,
					name       : 'BUTTON_G5_SET',
					listeners : {
						change : function(field, newValue, oldValue)	{
							if(newValue != oldValue && newValue > 0)	{
									panelResult.setValue("BUTTON_G5_YN", "Y")
							}else if(newValue == 0 || Ext.isEmpty(newValue))	{
								panelResult.setValue("BUTTON_G5_YN", "")
							}
						}
					}
				}
			]
		},{
			fieldLabel	: 'FS 지원여부',
			name		: 'FS_YN',
			xtype       : 'uniRadiogroup',
			comboType   : 'AU',
			comboCode   : 'B131',
			width       : 250,
			allowBlank  : false	
		},{
			fieldLabel	: '게이트웨이업체',
			name		: 'GATEWAY_CUST_NM'
		},{
			fieldLabel	: '게이트웨이요청',
			name		: 'GATEWAT_YN',
			xtype       : 'uniRadiogroup',
			comboType   : 'AU',
			comboCode   : 'B131',
			allowBlank  : false,
			width       : 250
		},Unilite.popup('USER',{
			fieldLabel	: '예약요청자',
			valueFieldName:'REQ_USER',
			textFieldName:'REQ_USER_NAME',
			allowBlank	: false
		}),{
			fieldLabel	: '배송방법',
			name		: 'DELIVERY_METH',
			xtype       : 'uniCombobox',
			allowBlank	: false,
			comboType   : 'AU',
			comboCode   : 'S175'
		},{
			fieldLabel	: '예약요청사항',
			name		: 'REMARK',
			width       : 810,
			colspan     : 2
		}],
		setAllFieldsReadOnly: function(b) {
			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(item.isPopupField) {
					var popupFC = item.up('uniPopupField');
					popupFC.setReadOnly(b);
				} else {
					item.setReadOnly(b);
				}
			})
		},
		api: {
			load: 'sat300ukrvService.selectMaster',
			submit: 'sat300ukrvService.syncMaster'				
		},
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
				if(basicForm.isDirty())	{
					UniAppManager.setToolbarButtons('save', true);
				}
			}
		}
	});// End of var panelResult = Unilite.createSearchForm('searchForm',{
		
	// 마스터 그리드
	var masterGrid = Unilite.createGrid('sat300ukrvGrid',{
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: false,
			onLoadSelectFirst	: false
		},
		columns	: [
			  {dataIndex : 'ASST_CODE'      , width : 100 }
			, {dataIndex : 'ASST_NAME'      , width : 150 }
			, {dataIndex : 'SERIAL_NO'      , width : 150 }
			, {dataIndex : 'ASST_INFO'      , width : 100 }
			, {dataIndex : 'ASST_STATUS'    , width : 100 }
			, {dataIndex : 'ASST_GUBUN'     , width : 100 }
			, {dataIndex : 'REQ_YN'     	, width : 100 ,hidden:true}
			
		]
	});

	Unilite.Main( {
		id			: 'sat300ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		}],
		fnInitBinding: function(param) {
			UniAppManager.setToolbarButtons(['reset']	, true);
			UniAppManager.setToolbarButtons(['query']	, false);
			panelResult.clearForm();
			this.setDefault();
			if(param && ( !Ext.isEmpty(param.RESERVE_NO) || !Ext.isEmpty(param.ASST_DATA))){
				panelResult.setValues(param);
				if(param.ASST_DATA)	{
					masterStore.loadData({});
					panelResult.setValue('RESERVE_DATE' , UniDate.today());
					panelResult.setValue('OUT_DATE' , UniDate.today());
					panelResult.setValue('USE_FR_DATE' , UniDate.today());
					panelResult.setValue('USE_FR_TIME' , '0800');
					panelResult.setValue('USE_TO_DATE', UniDate.get('todayForMonth'));
					panelResult.setValue('USE_TO_TIME' , '1700');
					if(Ext.isEmpty(param.FS_YN))	{
						panelResult.setValue('FS_YN' , 'Y');
					}
					if(Ext.isEmpty(param.GATEWAT_YN))	{
						panelResult.setValue('GATEWAT_YN' , 'Y');
					}
					panelResult.setValues(param);
					Ext.each(param.ASST_DATA, function(data){
						UniAppManager.app.onNewDataButtonDown(data);
					})
				} else if(param.RESERVE_NO)	{
					this.onQueryButtonDown();
				}
			} else {
				panelResult.uniOpt.inLoading = true;
				panelResult.setValue('RESERVE_DATE' , UniDate.today());
				panelResult.setValue('OUT_DATE' , UniDate.today());
				panelResult.setValue('USE_FR_DATE' , UniDate.today());
				panelResult.setValue('USE_FR_TIME' , '0800');
				panelResult.setValue('USE_TO_DATE', UniDate.get('todayForMonth'));
				panelResult.setValue('USE_TO_TIME' , '1700');
				panelResult.setValue('FS_YN' , 'Y');
				panelResult.setValue('GATEWAT_YN' , 'Y');
				panelResult.uniOpt.inLoading = false;
			}
		},
		setDefault: function() {
			masterStore.uniOpt.deletable	= true;
			masterStore.uniOpt.allDeletable	= true;
			
			panelResult.setAllFieldsReadOnly(false);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('REQ_USER', UserInfo.userID);
			panelResult.setValue('REQ_USER_NAME', UserInfo.userName);
			panelResult.setValue('RESERVE_DATE', UniDate.today());
			panelResult.setValue('REQ_OUT_DATE', UniDate.today());
			panelResult.setValue('USE_FR_DATE', UniDate.today());
			panelResult.setValue('USE_FR_TIME' , '0800');
			panelResult.setValue('USE_TO_DATE', UniDate.today());
			panelResult.setValue('USE_TO_TIME' , '1700');
			
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();

			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {
			if(Ext.isEmpty(panelResult.getValue("DIV_CODE")) || Ext.isEmpty(panelResult.getValue("RESERVE_NO"))) return;	//필수체크
			panelResult.getForm().load({
				params : {
					'DIV_CODE' : panelResult.getValue("DIV_CODE"), 
					'RESERVE_NO' : panelResult.getValue("RESERVE_NO")
				},
				success : function(form, action)	{
					masterStore.loadStoreRecords();
				},
				failure : function(form, action)	{
					Unilite.messageBox("조회된 내용이 없습니다.");
					UniAppManager.app.onResetButtonDown()
				}
			});
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterStore.loadData({});
			this.fnInitBinding();
		},
		onNewDataButtonDown: function(param) {
			var r = {
				 'DIV_CODE'   : param.DIV_CODE,
				 'ASST_CODE'  : param.ASST_CODE,
				 'ASST_NAME'  : param.ASST_NAME,
				 'SERIAL_NO'  : param.SERIAL_NO,
				 'ASST_INFO'  : param.ASST_INFO,
				 'ASST_STATUS': param.ASST_STATUS,
				 'ASST_GUBUN' : param.ASST_GUBUN,
				 'RESERVE_NO'     : panelResult.getValue("RESERVE_NO"),
				 'RESERVE_SEQ'    : masterStore.max('RESERVE_SEQ')+1,
			    };
			masterGrid.createRow(r, null);
		},
		onSaveDataButtonDown: function(config) {
			if(panelResult.getInvalidMessage())	{
				if(masterStore.isDirty()) {
					masterStore.saveStore();
				} else if(panelResult.isDirty()) {
					Ext.getBody().mask();
					panelResult.submit({
						success:function(form, action)	{
							Ext.getBody().unmask();
							if(Ext.isEmpty(panelResult.getValue('RESERVE_NO') ) )	{
								panelResult.uniOpt.inLoading = true;
								panelResult.setValue('RESERVE_NO', action.result.RESERVE_NO);
								panelResult.uniOpt.inLoading = false;
								UniAppManager.setToolbarButtons(['deleteAll'],true);
							} 
							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							UniAppManager.updateStatus('<t:message code="system.message.commonJS.store.saved" default="저장되었습니다."/>');
							UniAppManager.setToolbarButtons('save',false);
						}, 
						failure :function(form, action)	{
							Ext.getBody().unmask();
						}
					});
				} 
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow && selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(selRow.get("REQ_YN")=="Y") {
				Unilite.messageBox("출고요청된 자산은 삭제할 수 없습니다.");
			}else if(selRow && confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			var allData = masterStore.getData().items;
			var allDeletable = true;
			Ext.each(allData, function(data){
				if(data.get("REQ_YN") == "Y")	{
					allDeletable = false;
				}
			})
			if(!allDeletable)	{
				Unilite.messageBox("출고요청이 있는 자산이 있어 전체삭제할 수 없습니다.");
				return;
			}
			
			if(confirm('삭제 하시겠습니까?')) {
				var divCode = panelResult.getValue('DIV_CODE')
				var reserveNo = panelResult.getValue('RESERVE_NO');
				sat300ukrvService.deleteAll({
							DIV_CODE : divCode,
							RESERVE_NO : reserveNo
						}, function(responseText){
							if(responseText) {
								UniAppManager.updateStatus("삭제되었습니다.");
								UniAppManager.app.onResetButtonDown();
							}
						});
			}
		}
	});// End of Unilite.Main( {
};
</script>
