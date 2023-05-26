<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sat200ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sat200ukrv" />				<!-- 사업장 -->
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
			read	: 'sat200ukrvService.selectList',
			create	: 'sat200ukrvService.insertDetail',
			update	: 'sat200ukrvService.updateDetail',
			destroy	: 'sat200ukrvService.deleteDetail',
			syncAll	: 'sat200ukrvService.saveAll'
		}
	});

	

	//마스터 모델
	Unilite.defineModel('sat200ukrvModel',{
		fields: [
 			  {name : 'DIV_CODE'        , text : '사업장코드'     	, type : 'string'   , allowBlank : false   , comboType: "BOR120" , editable : false}
 			, {name : 'REQ_NO'          , text : '출고요청번호'     	, type : 'string'   , editable : false }
 			, {name : 'REQ_SEQ'         , text : '요청순번'      	, type : 'string'   , editable : false }
 			, {name : 'ASST_CODE'       , text : '자산코드'     	, type : 'string'   , allowBlank : false   , editable : false }
 			, {name : 'OUT_YN'          , text : '자산코드'     	, type : 'string'   , allowBlank : false   , editable : false , defaultValue :'N'}
 			, {name : 'ASST_NAME'       , text : '자산명'      	, type : 'string'   , allowBlank : false   , editable : false }
			, {name : 'SERIAL_NO'       , text : 'S/N'          , type : 'string'   , allowBlank : false   , editable : false }
			, {name : 'ASST_INFO'       , text : '자산정보'  		, type : 'string'   , comboType: "AU"	,comboCode:"S178" , editable : false }
			, {name : 'ASST_GUBUN'      , text : '구분'  			, type : 'string'  	, comboType: "AU"	,comboCode:"S179" , editable : false }
			, {name : 'ASST_STATUS'     , text : '현재상태'  		, type : 'string'  	, comboType: "AU"	,comboCode:"S177" , editable : false}
			, {name : 'RESERVE_NO'      , text : '예약번호'  		, type : 'string'  	, editable : false}
			, {name : 'RESERVE_SEQ'     , text : '예약순번'  		, type : 'int'  	, editable : false}
			, {name : 'RESERVE_YN'      , text : '예약여부'  		, type : 'string'  	, editable : false}
			
			
		]
	});// End of Unilite.defineModel('Ssa101ukrvModel',{

	// 마스터 스토어 정의
	var masterStore = Unilite.createStore('sat200ukrvStore',{
		model	: 'sat200ukrvModel',
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
								panelResult.setValue('REQ_NO', batch.operations[0]._resultSet.REQ_NO);
								panelResult.setValue('REQ_NO', batch.operations[0]._resultSet.REQ_NO);
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
				var grid = Ext.getCmp('sat200ukrvGrid');
				if(!Ext.isEmpty(inValidRecs))	{
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		},
		listeners : {
			load : function(store, records) {
				if(records && records.length > 0){
					Ext.each(records, function(record)	{
						if(record.get("OUT_YN")=="Y")	{
							panelResult.setAllFieldsReadOnly(true);
							masterStore.uniOpt.deletable	= false;
							masterStore.uniOpt.allDeletable	= false;
							UniAppManager.setToolbarButtons(['delete','deleteAll'], false);
						}
					});
				}
			}
		}
	});

	//마스터 폼
	var panelResult =  Unilite.createForm('resultForm',{
		region: 'north',	
    	disabled : false,
    	bodyStyle : {'background-color':'#fff;border-width: 0px;'},
		layout : {type : 'uniTable', columns : 3, tableAttrs:{width : 1050}},
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
			fieldLabel	: '출고요청번호',
			name		: 'REQ_NO',
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
				itemId : 'ASST_POPUP',
				popupWidth: 1100,
				extParam  : {'ASST_STATUS' : 'S'},
				listeners : {
					onSelected : function(records, type) {
						var insertedData = masterStore.getData();
						var messages = '';
						if(records) {
							
							var checkReserveUser = true;
							var checkReserveMsg = '';
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
								if(record.RESERVE_STATUS == "Y" && record.RESERVE_USER_ID != UserInfo.userID)	{
									checkReserveUser = false;
									checkReserveMsg = checkReserveMsg + record.ASST_NAME+'('+record.ASST_CODE+')'+' 예약담당자가 아닙니다.\n';
									return;
								}
								if(!checkReserveUser)	{
									return;
								}
								if(checkAsstCode && checkReserveUser)	{
									UniAppManager.app.onNewDataButtonDown(record);
								}
								
							});
							panelResult.setValue("DIV_CODE", records[0].DIV_CODE);
							if(!Ext.isEmpty(messages)) {
								Unilite.messageBox('이미 추가되어 있는 자산코드가 있습니다.', messages);
							}

							if(!Ext.isEmpty(checkReserveMsg)) {
								Unilite.messageBox('예약담당자만 출고요청할 수 있습니다.', checkReserveMsg, '', {'showDetail' : true });
							}
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE"), 'SELMODEL':'MULTI'});
					}
				}
			}
		),{
			fieldLabel	: '출고요청일',
			name		: 'REQ_DATE',
			xtype       : 'uniDatefield',
			allowBlank	: false,
			value       : UniDate.today()
		},{
			fieldLabel	: '출고예정일',
			name		: 'OUT_DATE',
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
			fieldLabel	: '출고요청자',
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
			fieldLabel	: '출고요청사항',
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
					if(item.name != "REQ_NO") {
						item.setReadOnly(b);
					}
				}
			})
		},
		api: {
			load: 'sat200ukrvService.selectMaster',
			submit: 'sat200ukrvService.syncMaster'				
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
	var masterGrid = Unilite.createGrid('sat200ukrvGrid',{
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
		]
	});

	Unilite.Main( {
		id			: 'sat200ukrvApp',
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
			masterStore.loadData({});
			this.setDefault();
			if(param && (!Ext.isEmpty(param.REQ_NO) || !Ext.isEmpty(param.ASST_DATA) )){
				panelResult.setValue('REQ_DATE' , UniDate.today());
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
				if(param.ASST_DATA && Ext.isEmpty(param.RESERVE_NO))	{
					masterStore.loadData({});
					Ext.each(param.ASST_DATA, function(data){
						UniAppManager.app.onNewDataButtonDown(data);
					})
				} else if( param.ASST_DATA && param.RESERVE_NO)	{
					if(param.RESERVE_STATUS == "Y" && param.RESERVE_USER_ID && param.RESERVE_USER_ID != UserInfo.userID)	{
						Unilite.messageBox("예약담당자가 아닙니다ㅏ. 예약된 자산은 예약자만 출고 요청할 수 있습니다.");
						this.setDefault();
						return;
					}
					
					panelResult.setValues(param);
					panelResult.setValue('REQ_DATE' , UniDate.today());
					panelResult.setValue('OUT_DATE' , UniDate.today());
					Ext.each(param.ASST_DATA, function(data){
						UniAppManager.app.onNewDataButtonDown(data);
					})
				}else if(param.REQ_NO)	{
					this.onQueryButtonDown();
				}
			} else if(param && param.REQ_NO)	{
				this.onQueryButtonDown();
			} else {
				panelResult.uniOpt.inLoading = true;
				panelResult.setValue('REQ_DATE' , UniDate.today());
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
			
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();

			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {
			if(Ext.isEmpty(panelResult.getValue("DIV_CODE")) || Ext.isEmpty(panelResult.getValue("REQ_NO"))) return;	//필수체크
			panelResult.getForm().load({
				params : {
					'DIV_CODE' : panelResult.getValue("DIV_CODE"), 
					'REQ_NO' : panelResult.getValue("REQ_NO")
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
			var reserveYn = "";
			if(!Ext.isEmpty(param.RESERVE_YN)) {
				reserveYn = param.RESERVE_YN;
			} else if(!Ext.isEmpty(param.RESERVE_NO)) {
				reserveYn = 'Y';
			}
		
			var r = {
				 'DIV_CODE'   : param.DIV_CODE,
				 'ASST_CODE'  : param.ASST_CODE,
				 'ASST_NAME'  : param.ASST_NAME,
				 'SERIAL_NO'  : param.SERIAL_NO,
				 'ASST_INFO'  : param.ASST_INFO,
				 'ASST_STATUS': param.ASST_STATUS,
				 'ASST_GUBUN' : param.ASST_GUBUN,
				 'RESERVE_NO' : param.RESERVE_NO,
				 'RESERVE_SEQ': param.RESERVE_SEQ,
				 'RESERVE_YN' : reserveYn,
				 'REQ_NO'     : panelResult.getValue("REQ_NO"),
				 'REQ_SEQ'    : masterStore.max('REQ_SEQ')+1,
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
							if(Ext.isEmpty(panelResult.getValue('REQ_NO') ) )	{
								panelResult.uniOpt.inLoading = true;
								panelResult.setValue('REQ_NO', action.result.REQ_NO);
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
			}else if(selRow && confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			if(confirm('삭제 하시겠습니까?')) {
				var divCode = panelResult.getValue('DIV_CODE')
				var reqNo = panelResult.getValue('REQ_NO');
				sat200ukrvService.deleteAll({
							DIV_CODE : divCode,
							REQ_NO : reqNo
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
