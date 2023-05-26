<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bbs888skrv"  >
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>	
<script type="text/javascript" >

var popupWin;
function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm',{
		weight	:-100,
		region	: 'center',
		layout	: {type : 'uniTable', columns : 2, tableAttrs: {cellpadding: 5}},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{ 
			xtype	: 'button',
			text	: '<t:message code="system.label.base.commancodemenureload" default="공통코드 &amp; 메뉴 Reload"/>',
			width	: 220,
			colspan : 2,
			handler	: function() {
				Ext.getBody().mask();
				bsa400ukrvService.reloadAll({'a':'a'}, function(provider, response){
					console.log("provider : ", provider);
					console.log("response : ", response);
					Ext.getBody().unmask();
				})
			}
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.base.menureload" default="메뉴 Reload"/>',
			width	: 220,
			colspan : 2,
			handler	: function() {
				Ext.getBody().mask();
				bsa400ukrvService.reloadMenu({}, function(provider, response){
					console.log("provider : ", provider);
					console.log("response : ", response);
					Ext.getBody().unmask();
				})
			}
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.base.commancodereload" default="공통코드 Reload"/>',
			width	: 220,
			handler	: function() {
				bsa400ukrvService.reloadCode({}, function(provider, response){
					console.log("provider : ", provider);
					console.log("response : ", response);
					Ext.getBody().unmask();
				})
			}
		},{
			xtype	: 'button',
			text	: '공통코드보기',
			width	: 100,
			handler	: function() {
				if(popupWin == null) {
					Unilite.defineModel('codeModel', {
						fields : [
							{name: 'MAIN_CODE',		text: '<t:message code="system.label.base.commoncode" default="종합코드"/>',		type: 'string',	allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
							{name: 'CODE_NAME',		text: '<t:message code="system.label.base.commoncodename" default="종합코드명"/>',	type: 'string',	allowBlank:false},
							{name: 'CODE_NAME_EN',	text: '<t:message code="system.label.base.commoncodename" default="종합코드명"/>(<t:message code="system.label.base.english" default="영어"/>)',		type : 'string'},
							{name: 'CODE_NAME_CN',	text: '<t:message code="system.label.base.commoncodename" default="종합코드명"/>(<t:message code="system.label.base.chinese" default="중국어"/>)',		type : 'string'},
							{name: 'CODE_NAME_JP',	text: '<t:message code="system.label.base.commoncodename" default="종합코드명"/>(<t:message code="system.label.base.japanese" default="일본어"/>)',	type : 'string'},
							{name: 'CODE_NAME_VI',	text: '<t:message code="system.label.base.commoncodename" default="종합코드명"/>(<t:message code="system.label.base.vietnamese" default="베트남어"/>)',	type : 'string'},
							{name: 'SYSTEM_CODE_YN',text: '<t:message code="system.label.base.system" default="시스템"/>',				type: 'string',	allowBlank:false, comboType : 'AU', comboCode : 'B018', defaultValue:'2'},
							{name: 'SUB_LENGTH',	text: '<t:message code="system.label.base.length" default="길이"/>',				type: 'int',		allowBlank:false},
							{name: 'REF_CODE1',		text: '<t:message code="system.label.base.refer1" default="관련1"/>',				type: 'string'},
							{name: 'REF_CODE2',		text: '<t:message code="system.label.base.refer2" default="관련2"/>',				type: 'string'},
							{name: 'REF_CODE3',		text: '<t:message code="system.label.base.refer3" default="관련3"/>',				type: 'string'},
							{name: 'REF_CODE4',		text: '<t:message code="system.label.base.refer4" default="관련4"/>',				type: 'string'},
							{name: 'REF_CODE5',		text: '<t:message code="system.label.base.refer5" default="관련5"/>',				type: 'string'},
							{name: 'REF_CODE6',		text: '<t:message code="system.label.base.refer6" default="관련6"/>',				type: 'string'},
							{name: 'REF_CODE7',		text: '<t:message code="system.label.base.refer7" default="관련7"/>',				type: 'string'},
							{name: 'REF_CODE8',		text: '<t:message code="system.label.base.refer8" default="관련8"/>',				type: 'string'},
							{name: 'REF_CODE9',		text: '<t:message code="system.label.base.refer9" default="관련9"/>',				type: 'string'},
							{name: 'REF_CODE10',	text: '<t:message code="system.label.base.reter10" default="관련10"/>',			type: 'string'},
							{name: 'SUB_CODE',		text: '<t:message code="system.label.base.subcode" default="상세코드"/>',			type: 'string', defaultValue:'$'	},
							{name: 'USE_YN',		text: '<t:message code="system.label.base.useyn" default="사용여부"/>',				type: 'string', defaultValue:'Y'	, comboType : 'AU', comboCode : 'B010'},
							{name: 'SORT_SEQ',		text: '<t:message code="system.label.base.arrangeorder" default="정렬순서"/>',		type: 'string', defaultValue:1}
						]
					});

					var codeStore = Unilite.createStore('codeStore', {
						model: 'codeModel' ,
						proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
							api: {
								read : 'bsa400ukrvService.selectCodes'
							}
						}),
						loadStoreRecords : function() {
							this.load();
						},
						sorters: [{
							property: 'MAIN_CODE',
							direction: 'ASC'
						},{
							property: 'SUB_CODE',
							direction: 'ASC'
						}]
					});

					popupWin = Ext.create('widget.uniDetailWindow', {
						title	: '메모리 코드정보',
						width	: 600,
						height	: 800,
						layout	: {type:'vbox', align:'stretch'},
						items	: [
							Unilite.createGrid('', {
								itemId	: 'grid',
								layout	: 'fit',
								store	: codeStore,
								selModel: 'rowmodel',
								uniOpt	: {
									onLoadSelectFirst	: true,
									filter				: {
										useFilter	: true,		//컬럼 filter 사용 여부
										autoCreate	: true		//컬럼 필터 자동 생성 여부
									}
								},
								columns: [
									{dataIndex : 'MAIN_CODE'	, width : 80	, sort:true},
									{dataIndex : 'SUB_CODE'		, width : 150},
									{dataIndex : 'CODE_NAME'	, width : 150},
									{dataIndex : 'REF_CODE1'	, width : 110},
									{dataIndex : 'REF_CODE2'	, width : 110},
									{dataIndex : 'REF_CODE3'	, width : 110},
									{dataIndex : 'REF_CODE4'	, width : 110},
									{dataIndex : 'REF_CODE5'	, width : 110},
									{dataIndex : 'REF_CODE6'	, width : 110},
									{dataIndex : 'REF_CODE7'	, width : 110},
									{dataIndex : 'REF_CODE8'	, width : 110},
									{dataIndex : 'REF_CODE9'	, width : 110},
									{dataIndex : 'REF_CODE10'	, width : 110}
								]
							})
						],
						tbar: ['->',{
							itemId	: 'searchtBtn',
							text	: '조회',
							handler	: function() {
								var store = Ext.data.StoreManager.lookup('codeStore')
								store.loadStoreRecords();
							},
							disabled: false
						},{
							itemId	: 'closeBtn',
							text	: '닫기',
							handler	: function() {
								popupWin.hide();
							},
							disabled: false
						}],
						listeners : {
							beforehide: function(me, eOpt) {
								popupWin.down('#grid').reset();
							},
							beforeclose: function( panel, eOpts ) {
								popupWin.down('#grid').reset();
							},
							show: function( panel, eOpts ) {
								Ext.data.StoreManager.lookup('codeStore').loadStoreRecords();
							}
						}
					});
				}
				popupWin.center();
				popupWin.show();
			}
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.base.commanbadgeload" default="알림 Reload"/>',
			width	: 220,
			colspan : 2,
			handler	: function() {
				badgeService.reload(null, function(provider, response){
					console.log("provider : ", provider);
					console.log("response : ", response);
					Ext.getBody().unmask();
				})
			}
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.base.passwordupdate" default="비밀번호 암호화 (SHA256) update"/>',
			width	: 220,
			colspan : 2,
			handler	: function() {
				bbs888skrvService.encryptPW({}, function(provider, response){
					console.log("provider : ", provider);
					console.log("response : ", response);
					Ext.getBody().unmask();
				})
			}
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.base.smspopuptest" default="SMS 팝업test"/>',
			colspan : 2,
			hidden	: true,			//20210121 주석
			handler	: function() {
				this.openPopup();
			},
			//공통팝업(SMS 전송팝업 호출)
			app			: 'Unilite.app.popup.SendSMS',
			api			: 'popupService.sendSMS',
			openPopup	: function() {
				var me				= this;
				var param			= {};
				param['TYPE']		= 'TEXT';
				param['pageTitle']	= me.pageTitle;
				if(me.app) { 
					var fn = function() {
						var oWin = Ext.WindowMgr.get(me.app);
						if(!oWin) {
							oWin = Ext.create( me.app, {
								id				: me.app,
								callBackFn		: me.processResult,
								callBackScope	: me,
								popupType		: 'TEXT',
								width			: 750,
								height			: 450,
								title			: 'SMS 전송',
								param			: param
							});
						}
						oWin.fnInitBinding(param);
						oWin.center();
						oWin.show();
					}
				}
			Unilite.require(me.app, fn, this, true);
			}
		},{	//20210121: 엑셀파일의 폴더명 읽어서 폴더 파일 생성 TEST
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 2},
			colspan	: 2,
			hidden	: true,
			items	: [{
				fieldLabel	: '생성할 경로',
				xtype		: 'uniTextfield',
				name		: 'PATH',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				xtype	: 'button',
				text	: '폴더 일괄생성',
				margin	: '0 0 4 5',
				handler	: function() {
					var param = {
						PATH: panelResult.getValue('PATH')
					}
					pjwTestService.makDirectory(param, function(provider, response){
						Unilite.messageBox(provider);
					});
				}
			},{
				xtype	: 'component',
				html	: '폴더 생성할 위치를 입력하신 후, 폴더 일괄생성 버튼을 눌러주세요(PJW_TEST 테이블 사용)',
				margin	: '0 0 0 25',
				colspan	: 2,
				width	: 300,
				style	: {
					color: 'blue'
				}
			}]
		}]
	});



	Unilite.Main( {
		id			: 'bbs888skrvApp',
		borderItems	: [
			panelResult
		],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'prev', 'next'], false);
		},
		onQueryButtonDown : function() {
		},
		onNewDataButtonDown: function() {
		},
		onResetButtonDown: function() {
		},
		onSaveDataButtonDown: function(config) {
		},
		onDeleteDataButtonDown: function() {
		},
		rejectSave: function() {
		},
		confirmSaveData: function(config) {
		},
		onDetailButtonDown:function() {
		}
	});
}
</script>