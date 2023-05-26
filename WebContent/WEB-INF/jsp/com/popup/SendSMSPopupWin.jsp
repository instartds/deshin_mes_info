<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.SendSMS");
%>
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	

	var gsMsgType	= 0;
	
	Unilite.defineModel('${PKGNAME}.SendSMSPopupModel', {
		fields: [
			{name: 'COMP_CODE'			,text:'COMP_CODE'	,type:'string'	},
			{name: 'CUSTOM_CODE'		,text:'<t:message code="system.label.common.clientcode" default="고객번호"/>'		,type:'string'	},
			{name: 'CUSTOM_NAME'		,text:'<t:message code="system.label.common.clientname" default="고객명"/>'			,type:'string'	},
			{name: 'SMS_MOBIL'				,text:'<t:message code="system.label.human.phoneno" default="연락처"/>'			,type:'string'		,allowBlank: false},
			{name: 'SUBJECT'					,text:'<t:message code="system.label.common.title" default="제목"/>'			,type:'string'	},
			{name: 'SMS_DESC'				,text:'<t:message code="system.label.common.smsdesc" default="전송내용"/>'		,type:'string'		,allowBlank: false}
		]
	});



	Ext.define('${PKGNAME}', {
		extend		: 'Unilite.com.BaseJSPopupApp',
		uniOpt		: {
			btnQueryHide	: false,		//조회 버튼 숨김여부
			btnSubmitHide	: true,			//확인 버튼 숨김여부
			btnCloseHide	: false			//닫기 버튼 숨김여부
		},
		constructor	: function(config) {
			var me = this;
			if (config) {
				Ext.apply(me, config);
			}
			var wParam = this.param;
			var t1= false, t2 = false;
			if( Ext.isDefined(wParam)) {
				if(wParam['TYPE'] == 'VALUE') {
					t1 = true;
					t2 = false;
					
				} else {
					t1 = false;
					t2 = true;
				}
			};
			
			
			me.panelSearch = Unilite.createSearchForm('smsSearchForm',{
				region	: 'north',
				border	: true,
				padding	: 1,
				layout	: {
					type		: 'uniTable', 
					columns		: 2, 
					tableAttrs	: {style: {width: '100%'}}/*,
					tdAttrs		: {style: 'border : 1px solid #ced9e7;'}*/
				},
				items: [
					Unilite.popup('AGENT_CUST_MULTI', { 
						fieldLabel		: '<t:message code="system.label.common.custom" default="거래처"/>', 
						valueFieldName	: 'CUSTOM_CODE',
						textFieldName	: 'CUSTOM_NAME',
						tdAttrs			: {width: 350},
						validateBlank	: false,
						listeners		: {
							'onSelected': {
								fn: function(records, type  ){
									me.panelSearch.setValue('CUSTOM_CODE', '');
									me.panelSearch.setValue('CUSTOM_NAME', '');
									Ext.each(records, function(record,i) {
										console.log('record',record);
										me.onNewDataButtonDown();
										me.masterGrid.setItemData(record);
									}); 
								},
								scope: this
							},
//							'onClear' : function(type)	{
//								var grdRecord = me.masterGrid.uniOpt.currentRecord;
//								grdRecord.set('CUSTOM_CODE'		,'');
//								grdRecord.set('CUSTOM_NAME'		,'');
//								grdRecord.set('DELIVERY_UNION'	,'');
//							},
							applyextparam: function(popup){
								popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
								popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
							}
						}
					}
				),{
					xtype		: 'uniCombobox',
					fieldLabel	: '<t:message code="system.label.common.customclass" default="거래처분류"/>',
					name		: 'AGENT_TYPE',
					comboType	: 'AU',
					comboCode	: 'B055'
				},{
					xtype		: 'uniTextfield',
					fieldLabel	: '<t:message code="system.label.common.sendphone" default="발신번호"/>',
					name		: 'SEND_PHONE',
					allowBlank	: false,
					readOnly	: true,
					listeners	:{
						change: function(field, newValue, oldValue, eOpts) {
							var phoneNo = newValue.replace(/-/gi,'');
							if(!Ext.isEmpty(phoneNo) && isNaN(phoneNo)){
								alert(Msg.sMB074);							//숫자만 입력가능합니다.
								me.panelSearch.setValue('SEND_PHONE', oldValue);
							}
						}
					}
				},{
					xtype	: 'button',
					text	: '<t:message code="system.label.common.smssend" default="SMS전송"/>',
					id		: 'btnSendSms',
					tdAttrs	: {align: 'right'},
					colspan	: 2,
					width	: 100,
					handler	: function() {
						if(!me.panelSearch.getInvalidMessage()) return false;
						
						var selRecords = me.masterGrid.getSelectionModel().getSelection();
						Ext.each(selRecords, function(selRecord, index) {
							if(Ext.isEmpty(selRecord.get('SMS_MOBIL'))) {
								alert('SMS를 전송할 연락처가 등록되어있지 않습니다.');
								return false;
							} else if(Ext.isEmpty(selRecord.get('SMS_DESC'))) {
								alert('SMS에 전송될 내용이 등록되어있지 않습니다.');
								return false;
							} else {
								selRecord.phantom		= true;
								selRecord.data.MSG_TYPE	= gsMsgType;
								me.buttonStore.insert(index, selRecord);
				
								if (selRecords.length == index +1) {
									me.buttonStore.saveStore();
								}
							}
						})
					}
				}]
			});
		
		
			me.smsPanel = Unilite.createSearchForm('smsPanel',{
				layout	: {
					type		: 'uniTable', 
					columns		: 2, 
					tableAttrs	: {width: '100%'},
					tdAttrs		: {align: 'center'/*, style: 'border : 1px solid #ced9e7;'*/}
				},
				region	: 'west',
				border	: true,
				padding	: '1',
				flex	: 1,
				items	: [{
					xtype		: 'uniTextfield',
					fieldLabel	: '<t:message code="system.label.common.title" default="제목"/>',
					name		: 'SUBJECT',
					labelWidth	: 30,
					width		: '98%',
					colspan		: 2,
					listeners	:{
						change: function(combo, newValue, oldValue, eOpts) {
							var grdRecords = me.masterGrid.getSelectionModel().getSelection();
							Ext.each(grdRecords, function(grdRecord, index) {
								if(!Ext.isEmpty(grdRecord)) {
									grdRecord.set('SUBJECT', newValue);
								}
							});
						}
					}
				},{
					xtype		: 'textareafield',
					fieldLabel	: '',
					name		: 'SMS_DESC',
					width		: '98%',
					height		: 260,
					colspan		: 2,
					listeners	:{
						change: function(combo, newValue, oldValue, eOpts) {
							var grdRecords = me.masterGrid.getSelectionModel().getSelection();
							Ext.each(grdRecords, function(grdRecord, index) {
								if(!Ext.isEmpty(grdRecord)) {
									grdRecord.set('SMS_DESC', newValue);
								}
							});
							//메세지 길이에 따라 SMS type 변경
							stringByteLength = me.fnCountByte(newValue);
							if (gsMsgType == 5 && stringByteLength <= 90) {
//								if(confirm('단문메세지로 변경하시겠습니까?')) {
									gsMsgType	= 0;
									Ext.getCmp('MSG_TYPE').setHtml("<font color = 'blue' ><b>단문</b></font>");
//								}
							}
							if (gsMsgType == 0 && stringByteLength > 90) {
//								if(confirm('장문메세지로 변경하시겠습니까?')) {
									gsMsgType	= 5;
									Ext.getCmp('MSG_TYPE').setHtml("<font color = 'red' ><b>장문</b></font>");
//								} else {
//									me.smsPanel.setValue('SMS_DESC', oldValue);
//									return false;
//								}
							} else if (stringByteLength > 2000) {
								alert('문자(mms)는 최대 2000Byte까지 전송할 수 있습니다.')
								me.smsPanel.setValue('SMS_DESC', oldValue);
								return false;
							}
							me.smsPanel.setValue('BYTE', stringByteLength);
//							alert(stringByteLength + " Bytes");
						}
					}
				},{
					xtype	: 'component',
					id		: 'MSG_TYPE',
					html	: "<font color = 'blue' ><b>단문</b></font>",
					style	: { 
						textAlign: 'center' 
					},
					width	: 40
				},{
					xtype		: 'uniNumberfield',
					fieldLabel	: '<t:message code="system.label.common.size" default="크기"/>',
					name		: 'BYTE',
					value		: 0,
					disabled	: true,
					labelWidth	: 70,
					width		: '98%',
					listeners	:{
						change: function(combo, newValue, oldValue, eOpts) {
						}
					}
				}]
			});
			
			
			me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
				store	: Unilite.createStoreSimple('${PKGNAME}.SendSMSPopupStore',{
					model	: '${PKGNAME}.SendSMSPopupModel',
					autoLoad: false,
					proxy	: {
						type: 'direct',
						api	: {
							read: 'popupService.selectSMSData'
						}
					},
					uniOpt	: {
								isMaster	: false,
								editable	: true,
								deletable	: false,
								useNavi 	: false
					},
					listeners: {
						load: function(store, records, successful, eOpts) {
							me.smsPanel.clearForm();
							me.smsPanel.setValue('BYTE', 0);
							me.masterGrid.getSelectionModel().selectAll();
							if(records.length == 0) {
								Ext.getCmp('btnSendSms').disable();
								me.smsPanel.getField('SUBJECT').disable();
								me.smsPanel.getField('SMS_DESC').disable();
							}
						}
					}
				}),
				region	: 'east',
				flex	: 1.5,
				uniOpt	:{
					onLoadSelectFirst	: false,
					expandLastColumn	: false,
					useRowNumberer		: false,
					dblClickToEdit		: true,
					excel				: {	
						useExcel	: false,
						exportGroup	: false, 
						onlyData	: false
					},	
					state				: {		
						useState	: false,	
						useStateList: false	
					},
					pivot : {
						use : false
					}
				},
				selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
					listeners: {
						select: function(grid, selectRecord, index, rowIndex, eOpts ){
							if(this.selected.getCount() > 0) {
								Ext.getCmp("btnSendSms").enable();
								me.smsPanel.getField('SUBJECT').enable();
								me.smsPanel.getField('SMS_DESC').enable();
							}
							//SMS 보낼 제목 관련 로직
							if(!Ext.isEmpty(selectRecord.get('SUBJECT'))) {
								me.smsPanel.setValue('SUBJECT', selectRecord.get('SUBJECT'));
							} else {
								if (!Ext.isEmpty(me.smsPanel.getValue('SUBJECT'))) {
									selectRecord.set('SUBJECT', me.smsPanel.getValue('SUBJECT'));
								} else {
									me.smsPanel.setValue('SUBJECT', '');
								}
							}
							//SMS 보낼 내용 관련 로직
							if(!Ext.isEmpty(selectRecord.get('SMS_DESC'))) {
								me.smsPanel.setValue('SMS_DESC', selectRecord.get('SMS_DESC'));
							} else {
								if (!Ext.isEmpty(me.smsPanel.getValue('SMS_DESC'))) {
									selectRecord.set('SMS_DESC', me.smsPanel.getValue('SMS_DESC'));
								} else {
									me.smsPanel.setValue('SMS_DESC', '');
								}
							}
						},
						
						deselect:  function(grid, selectRecord, index, eOpts ){
							if (this.selected.getCount() <= 0) {				//체크된 데이터가 0개일  때는 버튼 비활성화
								Ext.getCmp('btnSendSms').disable();
								me.smsPanel.getField('SUBJECT').disable();
								me.smsPanel.getField('SMS_DESC').disable();
							}
							//SMS 보낼 제목 관련 로직
							if(!Ext.isEmpty(selectRecord.get('SUBJECT'))) {
								selectRecord.set('SUBJECT', '');
							}
							//SMS 보낼 내용 관련 로직
							if(!Ext.isEmpty(selectRecord.get('SMS_DESC'))) {
								selectRecord.set('SMS_DESC', '');
							}
						}
					}
				}),
				dockedItems	: [{			
					xtype	: 'toolbar',
					dock	: 'top',
					items	: [{
						xtype	: 'uniBaseButton',
						text	: '<t:message code="system.label.common.btnReset" default="신규"/>',
						tooltip : '<t:message code="system.label.common.reset2" default="초기화"/>',
						iconCls	: 'icon-reset',
						width	: 26,
						height	: 26,
						itemId	: 'sub_reset',
						handler	: function() { 
							me.masterGrid.reset();
							me.masterGrid.getStore().clearData();
							me.fnInitBinding();
						}
					},{
						xtype	: 'uniBaseButton',
						text	: '<t:message code="system.label.common.add" default="추가"/>',
						tooltip	: '<t:message code="system.label.common.add" default="추가"/>',
						iconCls	: 'icon-new',
						width	: 26,
						height	: 26,
						itemId	: 'sub_newData',
						handler	: function() { 
							me.masterGrid.createRow(null, null, me.masterGrid.getStore().getCount() - 1);
							me.masterGrid.getSelectionModel().selectAll();
						}
					}]
				}],
				columns		: [
					{ dataIndex: 'COMP_CODE'			, width: 80		, hidden: true},
					{ dataIndex: 'CUSTOM_CODE'			, width: 70		,
						'editor': Unilite.popup('AGENT_CUST_MULTI_G',{
							textFieldName	: 'CUSTOM_CODE',
							DBtextFieldName	: 'CUSTOM_CODE',
							allowBlank		: false,
							listeners		: { 
								'onSelected': {
									fn: function(records, type  ){
										Ext.each(records, function(record,i) {
											console.log('record',record);
											if(i==0) {
												me.masterGrid.setItemData(record);
											} else {
												me.onNewDataButtonDown();
												me.masterGrid.setItemData(record);
											}
										}); 
									},
									scope: this
								},
//								'onClear' : function(type)	{
//									var grdRecord = me.masterGrid.uniOpt.currentRecord;
//									grdRecord.set('CUSTOM_CODE'		,'');
//									grdRecord.set('CUSTOM_NAME'		,'');
//									grdRecord.set('DELIVERY_UNION'	,'');
//								},
								'applyextparam': function(popup){
//									popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
//									popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
								}
							}
						})
					},
					{ dataIndex: 'CUSTOM_NAME'			, width: 200,
						'editor': Unilite.popup('AGENT_CUST_MULTI_G',{
							allowBlank		: false,
							listeners		: {
								'onSelected': {
									fn: function(records, type  ){
										Ext.each(records, function(record,i) {
											console.log('record',record);
											if(i==0) {
												me.masterGrid.setItemData(record);
											} else {
												me.onNewDataButtonDown();
												me.masterGrid.setItemData(record);
											}
										}); 
									},
									scope: this
								},
								'onClear' : function(type)	{
//									var grdRecord = me.masterGrid.uniOpt.currentRecord;
//									grdRecord.set('CUSTOM_CODE'		,'');
//									grdRecord.set('CUSTOM_NAME'		,'');
//									grdRecord.set('DELIVERY_UNION'	,'');
								},
								'applyextparam': function(popup){
//									popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
//									popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
								}
							}
						})
					},
					{ dataIndex: 'SMS_MOBIL'			, flex: 1},
					{ dataIndex: 'SUBJECT'				, width: 140 	, hidden: true},
					{ dataIndex: 'SMS_DESC'				, flex: 1 		, hidden: true}
				],
				listeners: {
					beforeedit: function( editor, e, eOpts ) {
						if (UniUtils.indexOf(e.field, ['SMS_MOBIL'])){
							return true;
						} else {
							return false;
						}
					},
					edit : function( editor, context, eOpts ) {
						if (UniUtils.indexOf(context.field, ['SMS_MOBIL'])) {
							var phoneNo = context.record.get('SMS_MOBIL').replace(/-/gi,'');
							if(!Ext.isEmpty(phoneNo) && isNaN(phoneNo)){
								context.record.set('SMS_MOBIL', '');
								alert(Msg.sMB074);							//숫자만 입력가능합니다.
								return false;
							}
						}
					}
				},
				setItemData: function(record) {
					var grdRecord = this.getSelectedRecord();
					grdRecord.set('COMP_CODE'		,UserInfo.compCode);
					grdRecord.set('CUSTOM_CODE'		,record['CUSTOM_CODE']);
					grdRecord.set('CUSTOM_NAME'		,record['CUSTOM_NAME']);
					grdRecord.set('SMS_MOBIL'		,record['SMS_MOBIL']);
				}
			});
			
			
			//전송 버튼 이벤트 (sms 테이블에 insert)
			me.directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
				api: {
					create	: 'popupService.sendSMS',
					syncAll	: 'popupService.saveSMS'
				}
			});	
			me.buttonStore = Unilite.createStore('sendSMSButtonStore',{	  
				uniOpt: {
					isMaster	: false,			// 상위 버튼 연결 
					editable	: false,			// 수정 모드 사용 
					deletable	: false,			// 삭제 가능 여부 
					useNavi		: false				// prev | newxt 버튼 사용
				},
				proxy		: me.directButtonProxy,
				saveStore	: function() {			 
					var inValidRecs	= this.getInvalidRecords();
					var toCreate	= this.getNewRecords();
		
					var paramMaster = me.panelSearch.getValues();
					
					if(inValidRecs.length == 0) {
						config = {
							params	: [paramMaster],
							success : function(batch, option) {
								//return 값 저장
								var master = batch.operations[0].getResultSet();
								
								me.buttonStore.clearData();
								if(confirm(Msg.fsbMsgB0076 + '\n전송 창을 닫으시겠습니까?')){
									me._onCloseBtnDown();
								};
//								me.onQueryButtonDown();
							},
		
							failure: function(batch, option) {
								me.buttonStore.clearData();
							}
						};
						this.syncAllDirect(config);
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
		
		
			config.items = [
				me.panelSearch,
				{
					xtype		: 'container',
					region		: 'center',
					layout		: {type:'hbox', align:'stretch'},
					flex		: 1,
					items		: [
						me.smsPanel,
						me.masterGrid
					]
				}
			]
			me.callParent(arguments);
		},
		initComponent : function(){	
			var me  = this;
			me.masterGrid.focus();
			this.callParent();		
		},
		fnInitBinding : function(param) {
			var me		= this;
			var frm		= me.panelSearch.getForm();
			var rdo		= frm.findField('RDO');
	
			if( Ext.isDefined(param)) {
				me.panelSearch.setValues(param);
			}
			
			//발신자 번호 set
			popupService.selectSendPhon({}, function(provider, response) {
				if(!Ext.isEmpty(provider)) {
					me.panelSearch.setValue('SEND_PHONE'	, provider);
				}
			});
			
			Ext.getCmp('btnSendSms').disable();
			me.smsPanel.getField('SUBJECT').disable();
			me.smsPanel.getField('SMS_DESC').disable();
			gsMsgType	= 0;
			if(!Ext.isEmpty(me.panelSearch.getValue('CUSTOM_CODE'))) {
				this._dataLoad();
			}
		},
		onQueryButtonDown : function()	{
			this._dataLoad();
		},
		onNewDataButtonDown : function()	{
			var me				= this;
			me.masterGrid.createRow(null, null, me.masterGrid.getStore().getCount() - 1);
			me.masterGrid.getSelectionModel().selectAll();
		},
		_dataLoad : function() {
			var me		= this;
			var param	= me.panelSearch.getValues();
			console.log( "_dataLoad: ", param );
			me.isLoading = true;
			me.masterGrid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
		},
		//문자열 byte 계산 함수
		fnCountByte : function(s,b,i,c){
			for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?2:c>>7?2:1);				//가장 빠름
//			s.replace(/[\0-\x7f]|([0-\u07ff]|(.))/g,"$&$1$2").length;		//정규식 이용한 방법
//			~-encodeURI(s).split(/%..|./).length;						//encodeURI 이용한 방법
			return b
		}
	});

