<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sat600ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sat600ukrv" />				<!-- 사업장 -->
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

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sat600ukrvService.selectList',
			create	: 'sat600ukrvService.insertDetail',
			destroy	: 'sat600ukrvService.deleteDetail',
			syncAll	: 'sat600ukrvService.saveAll'
		}
	});

	

	//마스터 모델
	Unilite.defineModel('sat600ukrvModel',{
		fields: [
 			  {name : 'DIV_CODE'        , text : '사업장코드'     	, type : 'string'   , allowBlank : false   , comboType: "BOR120" , editable : false}
 			, {name : 'INOUT_NUM'       , text : '출고번호'        , type : 'string'              }
 			, {name : 'INOUT_SEQ'       , text : '출고순번'        , type : 'int'                 }
 			, {name : 'REQ_NO'          , text : '출고요청번호'     	, type : 'string'   , editable : false }
 			, {name : 'REQ_SEQ'         , text : '요청순번'      	, type : 'int'      , editable : false }
 			, {name : 'ASST_CODE'       , text : '자산코드'     	, type : 'string'   , allowBlank : false   , editable : false }
			, {name : 'ASST_NAME'       , text : '자산명'      	, type : 'string'   , allowBlank : false   , editable : false }
			, {name : 'SERIAL_NO'       , text : 'S/N'          , type : 'string'   , allowBlank : false   , editable : false }
			, {name : 'ASST_INFO'       , text : '자산정보'  		, type : 'string'   , comboType: "AU"	,comboCode:"S178" , editable : false }
			, {name : 'ASST_GUBUN'      , text : '구분'  			, type : 'string'  	, comboType: "AU"	,comboCode:"S179" , editable : false }
			, {name : 'ASST_STATUS'     , text : '현재상태'  		, type : 'string'  	, comboType: "AU"	,comboCode:"S177" , editable : false}
			
		]
	});// End of Unilite.defineModel('Ssa101ukrvModel',{

	// 마스터 스토어 정의
	var masterStore = Unilite.createStore('sat600ukrvStore',{
		model	: 'sat600ukrvModel',
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
								panelResult.setValue('INOUT_NUM', batch.operations[0]._resultSet.INOUT_NUM);
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
				var grid = Ext.getCmp('sat600ukrvGrid');
				if(!Ext.isEmpty(inValidRecs))	{
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		}
	});

	//마스터 폼
	var panelResult =  Unilite.createForm('resultForm',{
		region: 'north',	
    	disabled : false,
    	bodyStyle : {'background-color':'#fff;border-width: 0px;'},
		layout : {type : 'uniTable', columns : 4, tableAttrs:{width : 1200}},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			tdAttrs     : {width : 400},
			value		: UserInfo.divCode
		},{
			fieldLabel	: '출고번호',
			name		: 'INOUT_NUM',
			tdAttrs     : {width : 500},
			readOnly    : true
		},{
			xtype       : 'button',
			text        : '출고요청참조',
			width       : 100,
			tdAttrs     : { valign : 'top', width : 110, style : 'padding-right:10px;'},
			rowspan     : 11,
			handler     : function()	{
				if(UniAppManager.app._needSave() && !Ext.isEmpty(panelResult.getValue("REQ_NO")))	{
					Unilite.messageBox("저장할 데이터가 있습니다. 저장 후 실행하세요.");
					return;
				}
				openReqPopup(panelResult.getValues());
			}
		},{
			xtype   : 'button',
			text    : '인수증',
			width       : 100,
			rowspan     : 11,
			tdAttrs     : { valign : 'top', width : 200},
			handler : function() {
				if(UniAppManager.app._needSave())	{
					Unilite.messageBox("저장할 데이터가 있습니다. 저장 후 실행하세요.");
					return;
				}
				var params = panelResult.getValues();
				if(!Ext.isEmpty(params.INOUT_NUM))	{
					panelResult.printBtn(params, 'TAKE');
				} else {
					Unilite.messageBox("출력할 데이터가 없습니다.");
				}
			}
		},Unilite.popup('USER',{
			fieldLabel	: '출고자',
			valueFieldName:'INOUT_USER',
			textFieldName:'INOUT_USER_NAME',
			allowBlank	: false
		}),{
			fieldLabel	: '출고일',
			name		: 'INOUT_DATE',
			xtype       : 'uniDatefield',
			allowBlank	: false,
			value       : UniDate.today()
		},{
			fieldLabel	: '비고',
			name		: 'REMARK',
			width       : 860,
			colspan     : 2
		},{
			fieldLabel	: '출고요청일',
			name		: 'REQ_DATE',
			xtype       : 'uniDatefield',
			readOnly    : true,
			colspan     : 2,
			value       : UniDate.today()
		},{
			fieldLabel	: '납품처',
			readOnly    : true,
			name		: 'CUSTOM_NAME'
		},Unilite.popup('CUST',{
			fieldLabel  : '대리점',
			readOnly    : true,
			valueFieldName:'AGENT_CUSTOM_CODE',
			textFieldName:'AGENT_CUSTOM_NAME'
		}),{
			xtype       : 'uniTextfield',
			fieldLabel  : '수령지',
			name        : 'DELIVERY_ADDRESS',
			width       : 860,
			colspan     : 2,
			readOnly : true
		},{
			fieldLabel	: '사용구분',
			name		: 'USE_GUBUN',
			xtype       : 'uniCombobox',
			comboType   : 'AU',
			comboCode   : 'S178',
			readOnly    : true,
			allowBlank	: false
		},{
			xtype       :'container',
			layout      : 'hbox',
			items       :[
				{	
					fieldLabel : '사용기간',
					xtype : 'uniDatefield',
					width : 180,
					name  : 'USE_FR_DATE',
					readOnly : true
				},{
					hideLable : true,	
					fieldLabel : '',
					width : 85,
					xtype : 'uniTimefield',
					name  : 'USE_FR_TIME',
					readOnly : true
				},{	
					fieldLabel : '~',
					labelWidth : 15,
					xtype : 'uniDatefield',
					name  : 'USE_TO_DATE',
					width : 110,
					readOnly : true
				},{
					hideLable : true,	
					fieldLabel : '',
					xtype : 'uniTimefield',
					name  : 'USE_TO_TIME',
					width : 85,
					readOnly : true
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
						inputValue :'Y',
						readOnly    : true
					}]
				},{
					xtype      : 'uniNumberfield',
					hideLabel  : true,
					suffixTpl  : 'SET&nbsp;',
					width      : 80,
					name       : 'BUTTON_G7_SET',
					readOnly    : true,
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
						inputValue :'Y',
						readOnly    : true
					}]
				},{
					xtype      : 'uniNumberfield',
					fieldLabel : '',
					hideLabel  : true,
					suffixTpl  : 'SET&nbsp;',
					width      : 80,
					name       : 'BUTTON_G5_SET',
					readOnly    : true,
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
			itemId      : 'FS_YN',
			name		: 'FS_YN',
			xtype       : 'uniRadiogroup',
			comboType   : 'AU',
			comboCode   : 'B131',
			allowBlank  : false,
			width       : 250,
			readOnly    : true
		},{
			fieldLabel	: '게이트웨이업체',
			name		: 'GATEWAY_CUST_NM',
			readOnly    : true
		},{
			fieldLabel	: '게이트웨이요청',
			itemId		: 'GATEWAT_YN',
			name		: 'GATEWAT_YN',
			xtype       : 'uniRadiogroup',
			comboType   : 'AU',
			comboCode   : 'B131',
			readOnly    : true,
			allowBlank  : false,
			width       : 250	
		},Unilite.popup('USER',{
			fieldLabel	: '출고요청자',
			readOnly    : true,
			valueFieldName:'REQ_USER',
			textFieldName:'REQ_USER_NAME',
			readOnly    : true
		}),{
			fieldLabel	: '배송방법',
			name		: 'DELIVERY_METH',
			xtype       : 'uniCombobox',
			readOnly    : true,
			comboType   : 'AU',
			comboCode   : 'S175'
		},{
			fieldLabel	: '출고요청사항',
			name		: 'REQ_REMARK',
			width       : 860,
			readOnly    : true,
			colspan     : 2
		},{
			fieldLabel	: '입고번호',
			name		: 'IN_NUM',
			width       : 750,
			readOnly    : true,
			hidden      : true,
			colspan     : 2
		},{
			fieldLabel	: '출고요청번호',
			name		: 'REQ_NO',
			width       : 810,
			readOnly    : true,
			hidden      : true,
			colspan     : 2
		}],
		setReadOnlyInData:function(b)	{
			panelResult.getField("DIV_CODE").setReadOnly(b);
			panelResult.getField("INOUT_NUM").setReadOnly(b);
			panelResult.getField("INOUT_USER").setReadOnly(b);
			panelResult.getField("INOUT_USER_NAME").setReadOnly(b);
			panelResult.getField("INOUT_DATE").setReadOnly(b);
			panelResult.getField("REMARK").setReadOnly(b);
		},
		api: {
			load: 'sat600ukrvService.selectMaster',
			submit: 'sat600ukrvService.syncMaster'				
		},
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {				
				if(basicForm.isDirty())	{
					UniAppManager.setToolbarButtons('save', true);
				}
			}
		},
		printBtn:function(record, gubun){
			var param				= {};
			param['DIV_CODE']		= record.DIV_CODE;
			param['REQ_NO']			= record.REQ_NO; // 출고요청번호
			param['PGM_ID']			= 'sat200skrv';       
			param['GUBUN']			= gubun;         // 신청서 : 'APPLY', 인수증 : 'TAKE'
			param['MAIN_CODE']		= 'S036';

			var win = Ext.create('widget.ClipReport', {
				url		 : CPATH+'/sales/sat200clskrv.do',
				prgID	 : 'sat200skrv',
				extParam : param
			});
			win.center();
			win.show();
		}
	});// End of var panelResult = Unilite.createSearchForm('searchForm',{
		
	// 마스터 그리드
	var masterGrid = Unilite.createGrid('sat600ukrvGrid',{
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
	var reqWin;
	function openReqPopup(param)	{
		
		if(!reqWin)	{
			Unilite.defineModel('reqModel',{
				fields: [
		 			  {name : 'DIV_CODE'        	, text : '사업장코드'     	, type : 'string' , comboType: "BOR120" }
		 			, {name : 'REQ_NO'          	, text : '출고요청번호'     	, type : 'string' }
		 			, {name : 'REQ_DATE'            , text : '출고요청일'      	, type : 'uniDate'}
					, {name : 'CUSTOM_NAME'         , text : '납품처'         	, type : 'string' }
					, {name : 'SAT210T_COUNT'       , text : '수량' 	        , type : 'int'    }
					, {name : 'USE_GUBUN'           , text : '사용구분'        , type : 'string' , comboType: "AU"	,comboCode:"S178"}
					, {name : 'REQ_USER'            , text : '출고요청자'     	, type : 'string' }
					, {name : 'REQ_USER_NAME'       , text : '출고요청자'     	, type : 'string' }
					, {name : 'REQ_REMARK'          , text : '요청사항'       	, type : 'string' }
					, {name : 'ASST_STATUS'         , text : '현재상태'  		, type : 'string' , comboType: "AU"	,comboCode:"S177"}
					, {name : 'AGENT_CUSTOM_CODE'   , text : '대리점 거래처코드'  	, type : 'string' }
			        , {name : 'AGENT_CUSTOM_NAME'   , text : '대리점 거래처명'   	, type : 'string' }
				    , {name : 'USE_FR_DATE'         , text : '사용기간FR'     	, type : 'string' }
					, {name : 'USE_FR_TIME'         , text : '사용기간FR'     	, type : 'string' }
					, {name : 'USE_TO_DATE'         , text : '사용기간TO'	   	, type : 'string' } 
					, {name : 'USE_TO_TIME'         , text : '사용기간TO'     	, type : 'string' }
					, {name : 'DELIVERY_ADDRESS'    , text : '수령지'        	, type : 'string' }
					, {name : 'BUTTON_G7_YN'        , text : 'G7버튼 Y/N'    	, type : 'string' } 
					, {name : 'BUTTON_G7_SET'       , text : 'G7버튼 SET'    	, type : 'string' } 
					, {name : 'BUTTON_G5_YN'        , text : 'G5버튼 Y/N'    	, type : 'string' } 
					, {name : 'BUTTON_G5_SET'       , text : 'G5버튼 SET'    	, type : 'string' }
				    , {name : 'FS_YN'	            , text : 'FS지원Y/N'	   	, type : 'string' } 
				    , {name : 'GATEWAY_CUST_NM'	    , text : '게이트웨이업체명'	, type : 'string' } 
				    , {name : 'GATEWAT_YN'	        , text : '게이트웨이Y/N' 	, type : 'string' }
				    , {name : 'DELIVERY_METH'	    , text : '배송방법'	   	, type : 'string' } 
				]
			});
			reqWin = Ext.create('widget.uniDetailWindow', {
				title: '출고요청참고',
				width: 1100,
				height:600,
				
				layout: {type:'vbox', align:'stretch'},				 
				items: [{
						itemId:'search',
						xtype:'uniSearchForm',
						layout:{type:'uniTable',columns:3},
						items:[
							{
								fieldLabel	: '사업장',
								name		: 'DIV_CODE',
								xtype		: 'uniCombobox',
								comboType	: 'BOR120',
								allowBlank	: false,
								value		: UserInfo.divCode
							},{
								fieldLabel	: '납품처',
								name		: 'CUSTOM_NAME'
							},{
								fieldLabel	: '자산',
								name		: 'ASST'
							}	
						]
					},
					Unilite.createGrid('', {
						itemId:'grid',
						layout : 'fit',
						store: Unilite.createStoreSimple('reqStore', {
							model: 'reqModel' ,
							proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
								api: {
									read : 'sat600ukrvService.selectReqList'
								}
							}),
							loadStoreRecords : function() {
								var param= reqWin.down('#search').getValues();
								this.load({
									params: param
								});
							}
						}),
						selModel:'rowmodel',
						uniOpt:{
							onLoadSelectFirst : true,
							useLoadFocus:true
						},
						columns: [  
							  {dataIndex : 'REQ_DATE'        , width : 80  }
							, {dataIndex : 'CUSTOM_NAME'     , width : 120 }
							, {dataIndex : 'SAT210T_COUNT'   , width : 70  }
							, {dataIndex : 'USE_GUBUN'       , width : 100 }
							, {dataIndex : 'REQ_USER'        , width : 100 }
							, {dataIndex : 'ASST_STATUS'     , width : 100 }
							, {dataIndex : 'REQ_NO'          , width : 100 }
						]
						,listeners: {									   
								onGridDblClick:function(grid, record, cellIndex, colName) {
									grid.ownerGrid.returnData();
									reqWin.hide();
								},
								onGridKeyDown: function(grid, keyCode, e) {
									if(e.getKey() == Ext.EventObject.ENTER) {
										var selectRecord = grid.getSelectedRecord();
										if(selectRecord) {
											grid.returnData();
											reqWin.hide();
										}
									}
								}
						 }
						,returnData: function() {
							var record = this.getSelectedRecord();  
							if(Ext.isEmpty(record)) {
								Unilite.messageBox(Msg.sMA0256);
								return false;
							} else {
								panelResult.setValues(record.data);
								UniAppManager.app.loadReqDetail(record.data);
							}
						}
					})
					   
				],
				tbar:  ['->',
					 {
						itemId : 'searchtBtn',
						text: '조회',
						handler: function() {
							var form = reqWin.down('#search');
							var store = Ext.data.StoreManager.lookup('reqStore');
							store.loadStoreRecords();
						},
						disabled: false
					},
					 {
						itemId : 'submitBtn',
						text: '확인',
						handler: function() {
							reqWin.down('#grid').returnData()
							reqWin.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							reqWin.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
							reqWin.down('#search').clearForm();
							reqWin.down('#grid').reset();
						},
					beforeclose: function( panel, eOpts )  {
							reqWin.down('#search').clearForm();
							reqWin.down('#grid').reset();
						},
					show: function( panel, eOpts ) {
							var form = reqWin.down('#search');
							form.clearForm();
							form.setValue("DIV_CODE", reqWin.param.DIV_CODE);
							var store = Ext.data.StoreManager.lookup('reqStore')
							store.loadStoreRecords();
						 }
					}
				});
		}
		reqWin.param = param;
		reqWin.center();	  
		reqWin.show();
	}
	
	Unilite.Main( {
		id			: 'sat600ukrvApp',
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
			if(param && (!Ext.isEmpty(param.REQ_NO) || !Ext.isEmpty(param.INOUT_NUM))){
				panelResult.setValues(param);
				if(param.REQ_NO && Ext.isEmpty(param.INOUT_NUM))	{
					masterStore.loadData({});
					Ext.getBody().mask();
					sat600ukrvService.selectReqList(param, function(responseText) {
						Ext.getBody().unmask();
						if(responseText && responseText.length > 0 )	{	
							panelResult.setValues(responseText[0]);
							panelResult.setValue('INOUT_USER', UserInfo.userID);
							panelResult.setValue('INOUT_USER_NAME', UserInfo.userName);
							panelResult.setValue('INOUT_DATE', UniDate.today());
							UniAppManager.app.loadReqDetail(responseText[0]);
						}
					})
					
				} else if(param.INOUT_NUM)	{
					this.onQueryButtonDown()
				}
			} else {
				panelResult.setReadOnlyInData(false);
				panelResult.uniOpt.inLoading = true;
				panelResult.setValue('FS_YN' , 'Y');
				panelResult.setValue('GATEWAT_YN' , 'Y');
				panelResult.uniOpt.inLoading = false;
			}
		},
		setDefault: function() {
			panelResult.setReadOnlyInData(false);

			masterStore.uniOpt.deletable	= true;
			masterStore.uniOpt.allDeletable	= true;
			
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('INOUT_USER', UserInfo.userID);
			panelResult.setValue('INOUT_USER_NAME', UserInfo.userName);
			panelResult.setValue('INOUT_DATE', UniDate.today());
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			panelResult.down('#FS_YN').setReadOnly(true);
			panelResult.down('#GATEWAT_YN').setReadOnly(true);  
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {
			if(Ext.isEmpty(panelResult.getValue("DIV_CODE")) || Ext.isEmpty(panelResult.getValue("INOUT_NUM"))) return;	//필수체크
			panelResult.getForm().load({
				params : {
					'DIV_CODE' : panelResult.getValue("DIV_CODE"), 
					'INOUT_NUM' : panelResult.getValue("INOUT_NUM")
				},
				success : function(form, action)	{
					if(!Ext.isEmpty(form.getFieldValues().IN_NUM))	{
						panelResult.setReadOnlyInData(true);
						masterStore.uniOpt.deletable	= false;
						masterStore.uniOpt.allDeletable	= false;
						UniAppManager.setToolbarButtons(['delete','deleteAll'], false);
					}
					masterStore.loadStoreRecords();
				}
			})
			
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
				 'REQ_NO'     : param.REQ_NO,
				 'REQ_SEQ'    : param.REQ_SEQ,
				 'INOUT_NUM'  : panelResult.getValue("INOUT_NUM"),
				 'INOUT_SEQ'  : masterStore.max('INOUT_SEQ')+1,
			    };
			masterGrid.createRow(r, null);
		},
		onSaveDataButtonDown: function(config) {
			if(panelResult.getInvalidMessage())	{
				if(masterStore.isDirty()) {
					masterStore.saveStore();
				} else if(panelResult.isDirty()) {
					panelResult.submit({
						success:function(form, action)	{
							if(Ext.isEmpty(panelResult.getValue('INOUT_NUM') ) )	{
								panelResult.uniOpt.inLoading = true;
								panelResult.setValue('INOUT_NUM', action.result.INOUT_NUM);
								panelResult.uniOpt.inLoading = false;
								UniAppManager.setToolbarButtons(['deleteAll'],true);
							} 
							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							UniAppManager.updateStatus('<t:message code="system.message.commonJS.store.saved" default="저장되었습니다."/>');
							UniAppManager.setToolbarButtons('save',false);
						}
					});
				} 
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(Ext.isEmpty(selRow)){
				Unilite.messageBox("삭제할 행을 선택하세요.")
				return;
			}
			if(selRow && selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(selRow && confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			if(confirm('삭제 하시겠습니까?')) {
				var divCode = panelResult.getValue('DIV_CODE')
				var inoutNum = panelResult.getValue('INOUT_NUM');
				sat600ukrvService.deleteAll({
							DIV_CODE : divCode,
							INOUT_NUM : inoutNum
						}, function(responseText){
							if(responseText) {
								UniAppManager.updateStatus("삭제되었습니다.");
								UniAppManager.app.onResetButtonDown();
							}
						});
			}
		},
		loadReqDetail : function(param) {
			masterStore.loadData({});
			Ext.getBody().mask();
			sat600ukrvService.selectReqDetailList(param, function(responseText)	{
				Ext.getBody().unmask();
				if(responseText && responseText.length > 0)		{
					Ext.each(responseText, function(newRecord) {
						UniAppManager.app.onNewDataButtonDown(newRecord);
					});
				}
			});
			
		}
	});// End of Unilite.Main( {
};
</script>
