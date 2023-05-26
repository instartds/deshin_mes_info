<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sat400ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sat400ukrv" />				<!-- 사업장 -->
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
	
	var gubunStore = Ext.create('Ext.data.Store', {
	    fields: ['value', 'text'],
	    data : [
	        {'value':'1', 'text':'연장'},
	        {'value':'2', 'text':'이동'}
	    ]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sat400ukrvService.selectList',
			create	: 'sat400ukrvService.insertDetail',
			update	: 'sat400ukrvService.updateDetail',
			destroy	: 'sat400ukrvService.deleteDetail',
			syncAll	: 'sat400ukrvService.saveAll'
		}
	});

	

	//마스터 모델
	Unilite.defineModel('sat400ukrvModel',{
		fields: [
 			  {name : 'DIV_CODE'        , text : '사업장코드'     	, type : 'string'   , allowBlank : false   , comboType: "BOR120" , editable : false}
 			, {name : 'CHANGE_NO'       , text : '이동/연장요청번호'     	, type : 'string'   , editable : false }
 			, {name : 'CHANGE_SEQ'      , text : '이동/연장요청순번'      	, type : 'string'   , editable : false }
 			, {name : 'ASST_CODE'       , text : '자산코드'     	, type : 'string'   , allowBlank : false   , editable : false }
 			, {name : 'ASST_NAME'       , text : '자산명'      	, type : 'string'   , allowBlank : false   , editable : false }
			, {name : 'SERIAL_NO'       , text : 'S/N'          , type : 'string'   , allowBlank : false   , editable : false }
			, {name : 'ASST_INFO'       , text : '자산정보'  		, type : 'string'   , comboType: "AU"	,comboCode:"S178" , editable : false }
			, {name : 'ASST_GUBUN'      , text : '구분'  			, type : 'string'  	, comboType: "AU"	,comboCode:"S179" , editable : false }
			, {name : 'ASST_STATUS'     , text : '현재상태'  		, type : 'string'  	, comboType: "AU"	,comboCode:"S177" , editable : false}
			, {name : 'REQ_NO'          , text : '출고요청번호'     	, type : 'string'   , editable : false }
 			, {name : 'REQ_SEQ'         , text : '요청순번'      	, type : 'string'   , editable : false }
 			
		]
	});// End of Unilite.defineModel('Ssa101ukrvModel',{

	// 마스터 스토어 정의
	var masterStore = Unilite.createStore('sat400ukrvStore',{
		model	: 'sat400ukrvModel',
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
			if(paramMaster.GUBUN == "2" && Ext.isEmpty(paramMaster.MOVE_CUST_NM) )	{
				Unilite.messageBox("자산 이동의 경우 이동납품처는 필수입니다.");
				return;
			}
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
								panelResult.setValue('CHANGE_NO', batch.operations[0]._resultSet.CHANGE_NO);
								panelResult.setValue('CHANGE_NO', batch.operations[0]._resultSet.CHANGE_NO);
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
				var grid = Ext.getCmp('sat400ukrvGrid');
				if(!Ext.isEmpty(inValidRecs))	{
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		},
		listeners : {
			load : function(store, records) {
				if(records && records.length > 0){
					Ext.each(records, function(record)	{

						if(!Ext.isEmpty(record.get("IN_NUM")) || !Ext.isEmpty(record.get("NEXT_CHANGE_NO"))) {
							
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
		layout : {type : 'uniTable', columns : 3, tableAttrs:{width : '100%'}},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '사업장',
			labelWidth  : 110,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			tdAttrs     : {width : 350},
			value		: UserInfo.divCode
		},{
			fieldLabel	: '구분',
			name		: 'GUBUN',
			xtype       : 'uniRadiogroup',
			items : [
				{name:'GUBUN', boxLabel:'이동' , inputValue : '2' , width : 80 },
				{name:'GUBUN', boxLabel:'연장' , inputValue : '1' , width : 80 }
			],
			listeners :{
				change : function(field, newValue, oldValue){
					if(newValue.GUBUN != oldValue.GUBUN){
						var moveCustNm = panelResult.down("#MOVE_CUST_NM");
						var outDate    = panelResult.down("#OUT_DATE");
						if(newValue.GUBUN == "1")	{
							moveCustNm.hide();
							outDate.hide();
						} else {
							moveCustNm.show();
							outDate.show();
						}
					}
				}
			}
		},{
			xtype       : 'button',
			text        : '출고참조',
			tdAttrs     : { valign : 'top', width : '50%'},
			rowspan     : 8,
			handler     : function()	{
				if(UniAppManager.app._needSave() && !Ext.isEmpty(panelResult.getValue("REQ_NO")))	{
					Unilite.messageBox("저장할 데이터가 있습니다. 저장 후 실행하세요.");
					return;
				}
				openReqPopup(panelResult.getValues());
			}
		},{
			xtype :'component',
			html  : '&nbsp;'
		},{
			fieldLabel	: '이동/연장 번호',
			name		: 'CHANGE_NO',
			tdAttrs     : {width : 350},
			readOnly    : true
		},{
			fieldLabel	: '연장/이동요청일',
			name		: 'RESERVE_DATE',
			labelWidth  : 110,
			xtype       : 'uniDatefield',
			allowBlank	: false,
			value       : UniDate.today(),
			listeners   :{
				change  : function(field, newValue, oldValue)	{
					if(!panelResult.uniOpt.inLoading && newValue != oldValue && Ext.isDate(newValue)) {
						var param = panelResult.getValues();
						if(!Ext.isEmpty(param.REQ_NO))	{
							param.RESERVE_DATE = UniDate.getDbDateStr(newValue);
							// 출고일, 이전 이동/연장 요청일 체크
							Ext.getBody().mask();
							sat400ukrvService.selectCheckReserveDate(param, function(responseText){
								Ext.getBody().unmask();
								if(!Ext.isEmpty(responseText))	{
									Unilite.messageBox(responseText.MAX_DATE+" 이후에 요청 가능합니다.");
									panelResult.uniOpt.inLoading = true;
									panelResult.setValue("RESERVE_DATE", responseText.RESERVE_DATE);
									panelResult.uniOpt.inLoading = false;
								}
							});
						}
					}
				}
			}
		},{ 
			xtype       : 'container',
			layout      : {type : 'hbox', align :'stretch'},
			height      : 23,
			width       : 350,
			tdAttrs     : { style :'margin-top: 2px;'},
			items       : [{
				fieldLabel	: '출고일',
				name		: 'OUT_DATE', 
				itemId      : 'OUT_DATE',
				xtype       : 'uniDatefield',
				allowBlank	: false,
				readOnly    : true,
				value       : UniDate.today()
			}]
			
		},{
			fieldLabel	: '현납품처',
			allowBlank	: false,
			labelWidth  : 110,
			name		: 'CUSTOM_NAME',
			readOnly    : true
		},{ 
			xtype       : 'container',
			layout      : {type : 'hbox', align :'stretch'},
			height      : 23,
			width       : 350,
			tdAttrs     : { style :'margin-top: 2px;'},
			items       : [{
				fieldLabel	: '이동납품처',
				xtype       : 'uniTextfield',
				itemId      : 'MOVE_CUST_NM',
				name		: 'MOVE_CUST_NM',
				readOnly    : true
			}]
		},{
			fieldLabel	: '사용구분',
			name		: 'USE_GUBUN',
			labelWidth  : 110,
			readOnly    : true,
			xtype       : 'uniCombobox',
			comboType   : 'AU',
			comboCode   : 'S178',
			allowBlank	: false
		},{
			fieldLabel	: '사용기간',
			startFieldName: 'USE_FR_DATE',
			endFieldName  : 'USE_TO_DATE',
			allowBlank	: false,
			xtype       : 'uniDateRangefield',
			startDate   : UniDate.today(),
			endDate     : UniDate.get('endOfMonth')
		},Unilite.popup('USER',{
			fieldLabel	: '연장/이동요청자',
			labelWidth  : 110,
			valueFieldName:'REQ_USER',
			textFieldName:'REQ_USER_NAME',
			allowBlank	: false
		}),{
			fieldLabel	: '예상반납일',
			name		: 'RETURN_DATE',
			xtype       : 'uniDatefield',
			allowBlank	: false,
			value       : UniDate.today()
		},{
			fieldLabel	: '연장이동사항',
			name		: 'REMARK',
			labelWidth  : 110,
			width       : 785,
			colspan     : 2
		},{
			fieldLabel	: '출고요청번호',
			name		: 'REQ_NO',
			hidden      : true
		},{
			fieldLabel	: '입고번호',
			name		: 'IN_NUM',
			hidden      : true
		},{
			fieldLabel	: '이후 연장정보',
			name		: 'NEXT_CHANGE_NO',
			hidden      : true
		}],
		setAllFieldsReadOnly: function(b) {
			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(item.isPopupField) {
					var popupFC = item.up('uniPopupField');
					popupFC.setReadOnly(b);
				} else {
					if(item.name != 'CHANGE_NO' && item.name != 'CUSTOM_NAME')	{
						item.setReadOnly(b);
					}
				}
			});
			 
		},
		api: {
			load: 'sat400ukrvService.selectMaster',
			submit: 'sat400ukrvService.syncMaster'				
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
	var masterGrid = Unilite.createGrid('sat400ukrvGrid',{
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

	var outWin;
	function openReqPopup(param)	{
		
		if(!outWin)	{
			Unilite.defineModel('outModel',{
				fields: [
		 			  {name : 'DIV_CODE'        	, text : '사업장코드'     	, type : 'string'   , comboType: "BOR120" }
		 			, {name : 'ASST_CODE'          	, text : '자산코드'     	, type : 'string'   }
		 			, {name : 'ASST_NAME'          	, text : '자산명'     		, type : 'string'   }
		 			, {name : 'SERIAL_NO'          	, text : 'S/N'     		, type : 'string'   }
		 			, {name : 'ASST_INFO'          	, text : '자산정보'     	, type : 'string'   }
		 			, {name : 'ASST_STATUS'         , text : '현재상태'     	, type : 'string'   }
		 			, {name : 'ASST_GUBUN'          , text : '자산구분'     	, type : 'string'   }
		 			, {name : 'BASIS_NUM'          	, text : '출고번호'     	, type : 'string'   }
		 			, {name : 'OUT_DATE'            , text : '출고일'      	, type : 'uniDate'  }
					, {name : 'CUSTOM_NAME'         , text : '납품처'         	, type : 'string'   }
					, {name : 'SAT600T_COUNT'   	, text : '수량' 			, type : 'int'   }
					, {name : 'USE_FR_DATE'         , text : '시작사용기간'     	, type : 'uniDate'  }
					, {name : 'USE_TO_DATE'         , text : '종료사용기간'     	, type : 'uniDate'  }
					, {name : 'REQ_NO'          	, text : '출고요청번호'     	, type : 'string'   }
					, {name : 'RESERVE_STATUS'      , text : '예약여부'        , type : 'string'   }
					, {name : 'RESERVE_DATE'        , text : '예약일'         	, type : 'uniDate'   }
					, {name : 'RETURN_DATE'         , text : '반납예정일'      	, type : 'uniDate'   }
					, {name : 'USE_GUBUN'      		, text : '사용구분'        , type : 'string'   } 
					, {name : 'REQ_NO'         		, text : '요청번호'      	, type : 'string'   }
					, {name : 'REQ_SEQ'      		, text : '요청순번'        , type : 'string'   } 
				]
			});
			outWin = Ext.create('widget.uniDetailWindow', {
				title: '출고참고',
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
						store: Unilite.createStoreSimple('outStore', {
							model: 'outModel' ,
							proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
								api: {
									read : 'sat400ukrvService.selectOutList'
								}
							}),
							loadStoreRecords : function() {
								var param= outWin.down('#search').getValues();
								this.load({
									params: param
								});
							}
						}),
						selModel: Ext.create("Ext.selection.CheckboxModel", { checkOnly : false }),
						uniOpt:{
							onLoadSelectFirst : false,
							useLoadFocus:true
						},
						columns: [  
							  {dataIndex : 'OUT_DATE'       , width : 80  }
							, {dataIndex : 'CUSTOM_NAME'    , width : 150 }
							, {dataIndex : 'ASST_CODE'      , width : 100 }
							, {dataIndex : 'ASST_NAME'      , width : 150 }
							, {dataIndex : 'USE_FR_DATE'    , width : 100 }
							, {dataIndex : 'USE_TO_DATE'    , width : 100 }
							, {dataIndex : 'RESERVE_STATUS' , width : 80  , align : 'center'}
							, {dataIndex : 'RESERVE_DATE'   , width : 80  }
							, {dataIndex : 'RETURN_DATE'    , width : 80  }
							, {dataIndex : 'REQ_NO'         , width : 110 }
							, {dataIndex : 'REQ_SEQ'        , width : 110 }
						]
						,listeners: {									   
								onGridDblClick:function(grid, record, cellIndex, colName) {
									grid.ownerGrid.returnData();
									outWin.hide();
								},
								onGridKeyDown: function(grid, keyCode, e) {
									if(e.getKey() == Ext.EventObject.ENTER) {
										var selectRecord = grid.getSelectedRecord();
										if(selectRecord) {
											grid.returnData();
											outWin.hide();
										}
									}
								},
								beforeselect : function(grid, record, index, eOpts){
									var me = this;
									return me.checkSelection(record, false);
								},
								select : function(grid, record, index, eOpts) {
									var gridPanel = this;
									var selRecord = new Array(), deselRecord = new Array();
									Ext.each(gridPanel.store.data.items, function(rec, idx){
										if(record.get("REQ_NO") == rec.get("REQ_NO")) {
											if(gridPanel.checkSelection(rec, true)) {
												selRecord.push(rec)
											} 
										} else {
											deselRecord.push(rec)
										}
									});
									grid.select(selRecord);
									grid.deselect(deselRecord);
								}
						 }
						,returnData: function() {
							var records = this.getSelectedRecords();  
							if(Ext.isEmpty(records) && records.length > 0) {
								Unilite.messageBox(Msg.sMA0256);
								return false;
							} else {
								
								panelResult.clearForm();
								UniAppManager.app.setDefault();
								panelResult.setValues(records[0].data);
								if(Ext.isEmpty(panelResult.getValue('RESERVE_DATE')))	{
									panelResult.setValue('RESERVE_DATE', UniDate.today());
								}
								Ext.each(records, function(record){
									UniAppManager.app.onNewDataButtonDown(record.data);
								});
							}
						},
						checkSelection : function(record, silent)	{
							if(record.get("RESERVE_YN") =="Y")	{
								if(!silent) Unilite.messageBox("예약된 자산은 선택하실 수 없습니다.");
								return false;
							}
							return true;
						}
					})
					   
				],
				tbar:  ['->',
					 {
						itemId : 'searchtBtn',
						text: '조회',
						handler: function() {
							var form = outWin.down('#search');
							var store = Ext.data.StoreManager.lookup('outStore');
							store.loadStoreRecords();
						},
						disabled: false
					},
					 {
						itemId : 'submitBtn',
						text: '확인',
						handler: function() {
							outWin.down('#grid').returnData()
							outWin.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							outWin.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
							outWin.down('#search').clearForm();
							outWin.down('#grid').reset();
						},
					beforeclose: function( panel, eOpts )  {
							outWin.down('#search').clearForm();
							outWin.down('#grid').reset();
						},
					show: function( panel, eOpts ) {
							var form = outWin.down('#search');
							form.clearForm();
							form.setValue("DIV_CODE", outWin.param.DIV_CODE);
							var store = Ext.data.StoreManager.lookup('outStore')
							store.loadStoreRecords();
						 }
					}
				});
		}
		outWin.param = param;
		outWin.center();	  
		outWin.show();
	}
	
	Unilite.Main( {
		id			: 'sat400ukrvApp',
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
			if(param && ( !Ext.isEmpty(param.CHANGE_NO)  || !Ext.isEmpty(param.ASST_DATA)) ){
				panelResult.setValues(param);
				if(param.ASST_DATA)	{
					masterStore.loadData({});
					panelResult.setValue('GUBUN' , '2');
					panelResult.setValue('DIV_CODE', UserInfo.divCode);
					panelResult.setValue('REQ_USER', UserInfo.userID);
					panelResult.setValue('REQ_USER_NAME', UserInfo.userName);
					panelResult.setValue('DIV_CODE', UserInfo.divCode);
					panelResult.setValue("RESERVE_DATE", UniDate.today());
					panelResult.setValue("RETURN_DATE", UniDate.get('nextWeek'));
					panelResult.setValue("OUT_DATE", UniDate.today());
					panelResult.setValue('USE_FR_DATE', UniDate.today());
					panelResult.setValue('USE_TO_DATE', UniDate.get('todayForMonth'));
					panelResult.setValues(param);
					if(Ext.isEmpty(param.CUSTOM_NAME) && !Ext.isEmpty(param.NOW_LOC))	{
						panelResult.setValue("CUSTOM_NAME", param.NOW_LOC);
					} 
					Ext.each(param.ASST_DATA, function(data){
						UniAppManager.app.onNewDataButtonDown(data);
					})	
				
				} else if(param.CHANGE_NO)	{
					this.onQueryButtonDown();
				}
			} 
		},
		setDefault: function() {
			masterStore.uniOpt.deletable	= true;
			masterStore.uniOpt.allDeletable	= true;
			
			panelResult.setAllFieldsReadOnly(false);
			panelResult.uniOpt.inLoading = true;
			panelResult.setValue('GUBUN' , '2');
			var moveCustNm = panelResult.down("#MOVE_CUST_NM");
			moveCustNm.show();
			
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('REQ_USER', UserInfo.userID);
			panelResult.setValue('REQ_USER_NAME', UserInfo.userName);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue("RESERVE_DATE", UniDate.today());
			panelResult.setValue("RETURN_DATE", UniDate.get('nextWeek'));
			panelResult.setValue("OUT_DATE", UniDate.today());
			panelResult.setValue('USE_FR_DATE' , UniDate.today());
			panelResult.setValue('USE_FR_TIME' , '0800');
			panelResult.setValue('USE_TO_DATE', UniDate.get('todayForMonth'));
			panelResult.setValue('USE_TO_TIME' , '1700');
			
			panelResult.uniOpt.inLoading = false;
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();

			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {
			panelResult.setAllFieldsReadOnly(false);
			
			if(Ext.isEmpty(panelResult.getValue("DIV_CODE")) || Ext.isEmpty(panelResult.getValue("CHANGE_NO"))) return;	//필수체크
			panelResult.getForm().load({
				params : {
					'DIV_CODE' : panelResult.getValue("DIV_CODE"), 
					'CHANGE_NO' : panelResult.getValue("CHANGE_NO")
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
					 'CHANGE_NO'  : panelResult.getValue("CHANGE_NO"),
					 'CHANGE_SEQ' : masterStore.max('CHANGE_SEQ')+1,
					 'REQ_NO'     : param.REQ_NO,
					 'REQ_SEQ'    : param.REQ_SEQ
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
							if(Ext.isEmpty(panelResult.getValue('CHANGE_NO') ) )	{
								panelResult.uniOpt.inLoading = true;
								panelResult.setValue('CHANGE_NO', action.result.CHANGE_NO);
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
				var changeNo = panelResult.getValue('CHANGE_NO');
				var gubun = panelResult.getValues().GUBUN;
				sat400ukrvService.deleteAll({
							DIV_CODE  : divCode,
							CHANGE_NO : changeNo,
							GUBUN     : gubun
						}, function(responseText){
							if(responseText) {
								UniAppManager.updateStatus("삭제되었습니다.");
								UniAppManager.app.onResetButtonDown();
							}
						});
			}
		},
		loadOutDetail : function(params) {
			masterStore.loadData({});
			UniAppManager.app.onNewDataButtonDown(params);
			/*sat400ukrvService.selectOutDetailList(param, function(responseText)	{
				Ext.getBody().unmask();
				if(responseText && responseText.length > 0)		{
					Ext.each(responseText, function(newRecord) {
						UniAppManager.app.onNewDataButtonDown(newRecord);
					});
				}
				
			});

			Ext.getBody().mask();
			param.RESERVE_DATE = UniDate.getDbDateStr(panelResult.getValue("RESERVE_DATE"));
			sat400ukrvService.selectCheckReserveDate(param, function(responseText)	{
				Ext.getBody().unmask();
				if(responseText && responseText.RESERVE_DATE)	{
					panelResult.setValue("RESERVE_DATE", responseText.RESERVE_DATE);
				}
			}) 
			*/
			
		}
	});// End of Unilite.Main( {
};
</script>
