<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afs100ukr"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A049"/>	<!-- 예적금구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>	<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B001"/>	<!-- ? -->
	<t:ExtComboStore comboType="AU" comboCode="A004"/>	<!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A020"/>	<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="A392"/>	<!-- 가수금 IN_GUBUN -->
	<t:ExtComboStore comboType="AU" comboCode="BS25"/>	<!-- 계좌집금 유형 (통합계좌서비스 대상)-->
	<t:ExtComboStore comboType="AU" comboCode="BS26"/>	<!-- CMS 계좌 유형 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >
var useColList		= ${useColList};
var gsChargeCode	= Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};	//ChargeCode 관련 전역변수
var bankAccountDetailGridWindow;												// 계좌번호 상세
/*
 * var output =''; for(var key in useColList) { output += key + ' : ' +
 * useColList[key] + '\n'; } alert(output);
 */

var BsaCodeInfo = {	//컨트롤러에서 값을 받아옴
	gsMoneyUnit: 		'${gsMoneyUnit}'
};

function appMain() {  
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'afs100ukrService.selectList',
			update	: 'afs100ukrService.updateDetail',
			create	: 'afs100ukrService.insertDetail',
			destroy	: 'afs100ukrService.deleteDetail',
			syncAll	: 'afs100ukrService.saveAll'
		}
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Afs100ukrModel', {
		fields: [
			{name: 'SAVE_CODE'				, text: '통장코드'				,type: 'string', allowBlank: false , maxlength: 16},
			{name: 'SAVE_NAME'				, text: '통장명'				,type: 'string', allowBlank: false},
			{name: 'BANK_CODE'				, text: '은행코드'				,type: 'string', allowBlank: false},
			{name: 'BANK_NAME'				, text: '은행명'				,type: 'string'},
			{name: 'BANK_ACCOUNT'			, text: '계좌번호(DB)'			,type: 'string', allowBlank: false, editable: false},
			{name: 'BANK_ACCOUNT_EXPOS'		, text: '계좌번호'				,type: 'string', allowBlank: false, defaultValue:'***************'},
			{name: 'ACCNT'					, text: '계정코드'				,type: 'string', allowBlank: false},
			{name: 'ACCNT_NM'				, text: '계정과목'				,type: 'string'},
			{name: 'MONEY_UNIT'				, text: '화폐단위'				,type: 'string', comboType:'AU', comboCode:'B004', displayField: 'value'},
			{name: 'BANK_KIND'				, text: '계좌종류'				,type: 'string', comboType:'AU', comboCode:'A049'},
			{name: 'DIV_CODE'				, text: '사업장'				,type: 'string', comboType:'BOR120'},
			{name: 'UPDATE_DB_USER'			, text: '수정자'				,type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '수정일'				,type: 'string'},
			{name: 'USE_YN'					, text: '사용유무'				,type: 'string', comboType:'AU', comboCode:'A004'},
			{name: 'EXP_AMT_I'				, text: '마이너스대출한도액'		,type: 'uniPrice'},
			{name: 'MAIN_SAVE_YN'			, text: '주지급계좌여부'			,type: 'string', comboType:'AU', comboCode:'A020', allowBlank: false},
			{name: 'IN_GUBUN'				, text: '구분'				,type: 'string', comboType:"AU", comboCode:"A392"},
			{name: 'IF_YN'					, text: '통합계좌서비스 대상'		,type: 'string', comboType:'AU', comboCode:'BS25', allowBlank: false},
			{name: 'MAIN_CMS_YN'			, text: 'CMS 수금계좌 유형'		,type: 'string', comboType:'AU', comboCode:'BS26', allowBlank: false},
			{name: 'COMP_CODE'				, text: '법인코드' 				,type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('afs100ukrMasterStore1',{
		model	: 'Afs100ukrModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function() {
			var paramMaster	= panelSearch.getValues();
			var inValidRecs	= this.getInvalidRecords();
			var rv			= true;
			if(inValidRecs.length == 0 ) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
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
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '검색조건',
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
		items: [{
			title		: '기본정보', 	
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [
				Unilite.popup('BANK_BOOK',{
					fieldLabel		: '통장코드', 
					valueFieldName	: 'BANK_BOOK_CODE',
					textFieldName	: 'BANK_BOOK_NAME',
					validateBlank	: 'text',
					listeners		: {
						onValueFieldChange: function(field, newValue) {
							panelResult.setValue('BANK_BOOK_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue) {
							panelResult.setValue('BANK_BOOK_NAME', newValue);
						}
					}
				})
			]		
		},{	//복호화 플래그(복호화 버튼 누를시 플래그 'Y')
			name	: 'DEC_FLAG', 
			xtype	: 'uniTextfield',
			hidden	: true
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm2',{
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [
			Unilite.popup('BANK_BOOK',{
				fieldLabel		: '통장코드', 
				valueFieldName	: 'BANK_BOOK_CODE',
				textFieldName	: 'BANK_BOOK_NAME',
				validateBlank	: 'text',
				listeners		: {
					onValueFieldChange: function(field, newValue) {
						panelSearch.setValue('BANK_BOOK_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue) {
						panelSearch.setValue('BANK_BOOK_NAME', newValue);
					}
				}
			})
		]
	});	

	var masterGrid = Unilite.createGrid('atx425ukrGrid1', {
		region		: 'center',
		store		: directMasterStore,
		excelTitle	: '통장정보등록',
		uniOpt		: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: false,
			onLoadSelectFirst	: true,
			copiedRow			: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false,	enableGroupingMenu:false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [
			{dataIndex: 'SAVE_CODE'				, width: 120},
			{dataIndex: 'SAVE_NAME'				, width: 200},
			{dataIndex: 'BANK_CODE'				, width: 120,
				editor: Unilite.popup('BANK_G',{
					DBtextFieldName	: 'BANK_CODE',
					popupWidth		: 360,
					popupHeight		: 450,  
					autoPopup		: true ,
					listeners		: { 
						'onSelected': {
							fn: function(records, type  ) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
								grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE','');
							grdRecord.set('BANK_NAME','');
						}
					}
				})
			},
			{dataIndex: 'BANK_NAME'				, width: 120,
				editor: Unilite.popup('BANK_G',{
					popupWidth	: 360,  
					popupHeight	: 450,  
					autoPopup	: true ,
					listeners	: { 
						'onSelected': {
							fn: function(records, type ) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
								grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE','');
							grdRecord.set('BANK_NAME','');
						}
					}
				})
			},
			{dataIndex: 'BANK_ACCOUNT'			, width: 150 ,hidden:true},
			{dataIndex: 'BANK_ACCOUNT_EXPOS'	, width: 120 /*,
				editor: Unilite.popup('CIPHER_BANKACCNT_G',{
					textFieldName	: 'BANK_ACCOUNT_EXPOS',
					DBtextFieldName	: 'DECRYP_WORD',
					autoPopup		: true ,
					listeners		: { 
						onSelected: {
							fn: function(records, type ) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('BANK_ACCOUNT',records[0]["INC_WORD"]);
							grdRecord.set('BANK_ACCOUNT_EXPOS','**************');
							},
							scope: this
						},
						onClear : function(type) {
							 var grdRecord = masterGrid.uniOpt.currentRecord;
//							 grdRecord.set('BANK_ACCOUNT','');
//							 grdRecord.set('BANK_ACCOUNT_CP','');
						},
						applyextparam: function(popup) {
							 var grdRecord = masterGrid.uniOpt.currentRecord;
							 popup.setExtParam({'BANK_ACCOUNT': grdRecord.get('BANK_ACCOUNT')});
							 popup.setExtParam({'POPUP_YN': 'N'});
						}
					}
				}) */
			},	
			{dataIndex: 'ACCNT'					, width: 120,
				editor: Unilite.popup('ACCNT_G',{
					DBtextFieldName	: 'ACCNT_CODE',
					autoPopup		: true ,
					listeners		: { 
						onSelected: {
							fn: function(records, type  ) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ACCNT',records[0]['ACCNT_CODE']);
								grdRecord.set('ACCNT_NM',records[0]['ACCNT_NAME']);
							},
							scope: this
						},
						onClear : function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT','');
							grdRecord.set('ACCNT_NM','');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup) {
								var param = {
									'ADD_QUERY' : "group_yn = 'N' and slip_sw = 'Y' and (substring(spec_divi,1,1) = 'B' or substring(spec_divi,1,1) = 'C')",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
				})
			},
			{dataIndex: 'ACCNT_NM'				, width: 120,
				editor: Unilite.popup('ACCNT_G',{
					autoPopup	: true ,
					listeners	: { 
						onSelected: {
							fn: function(records, type  ) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ACCNT',records[0]['ACCNT_CODE']);
								grdRecord.set('ACCNT_NM',records[0]['ACCNT_NAME']);
							}, 
							scope: this
						},
						onClear : function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT','');
							grdRecord.set('ACCNT_NM','');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup) {
								var param = {
									'ADD_QUERY' : "group_yn = 'N' and slip_sw = 'Y' and (substring(spec_divi,1,1) = 'B' or substring(spec_divi,1,1) = 'C')",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
				})
			},
			{dataIndex: 'MONEY_UNIT'			, width: 88},
			{dataIndex: 'BANK_KIND'				, width: 120},
			{dataIndex: 'DIV_CODE'				, width: 120},
			{dataIndex: 'UPDATE_DB_USER'		, width: 120,hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 120,hidden:true},
			{dataIndex: 'USE_YN'				, width: 80,align:'center'},
			{dataIndex: 'EXP_AMT_I'				, width: 150},
			{dataIndex: 'MAIN_SAVE_YN'			, width: 120,align:'center'},
			{dataIndex: 'IN_GUBUN'				, width: 100  },
			{dataIndex: 'IF_YN'					, width: 150,align:'center'},
			{dataIndex: 'MAIN_CMS_YN'			, width: 150,align:'center'},
			{dataIndex: 'COMP_CODE'				, width: 120,hidden:true}
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {	
				if(e.record.phantom == true) {
					if(UniUtils.indexOf(e.field, ['UPDATE_DB_USER','UPDATE_DB_TIME','COMP_CODE'])) {
						return false;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['SAVE_CODE','UPDATE_DB_USER','UPDATE_DB_TIME','COMP_CODE'])) {
						return false;
					}
				}
				if(e.field == "BANK_ACCOUNT_EXPOS") {
					//e.grid.openCryptPopup( e.record );
					return false;
				}
//				if(e.record.data.BANK_ACCOUNT != '') {
//					var grdRecord = masterGrid.uniOpt.currentRecord;
//					grdRecord.set('BANK_ACCOUNT_CP','***************');
//				}
			},
			afterrender:function() {
				UniAppManager.app.setHiddenColumn();
			},
			onGridDblClick:function(grid, record, cellIndex, colName, td) {
				if(colName =="BANK_ACCOUNT_EXPOS") {
					grid.ownerGrid.openCryptPopup(record);
				}
			}
			/*
				 * , beforecelldblclick : function( view, td, cellIndex, record,
				 * tr, rowIndex, e, eOpts ) { var columnName =
				 * view.eventPosition.column.dataIndex; if(columnName ==
				 * 'BANK_ACCOUNT_DISP') {
				 * bankAccountDetailForm.setValue('BANK_CODE',
				 * record.get('BANK_CODE'));
				 * bankAccountDetailForm.setValue('BANK_NAME',
				 * record.get('BANK_NAME'));
				 * bankAccountDetailForm.setValue('SAVE_NAME',
				 * record.get('SAVE_NAME'));
				 * bankAccountDetailForm.setValue('BANK_ACCOUNT',
				 * record.get('BANK_ACCOUNT'));
				 * openbankAccountDetailGridWindow(); } else { return false; } }
				 */
		},
		openCryptPopup:function( record ) {
			if(record) {
				var params = {'BANK_ACCOUNT': record.get('BANK_ACCOUNT'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'BANK_ACCOUNT_EXPOS', 'BANK_ACCOUNT', params);
			}
		}
	});



	var bankAccountDetailForm = Unilite.createForm('bankAccountDetailForm',{
		region	: 'center',
		layout	: {type : 'uniTable', columns : 1},
		padding	: '1 1 1 1',
//		border	: true,
//		split	: true,
		disabled: false,
		items	: [{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 1},
			padding	: '10 10 10 10',
			items	: [{
				fieldLabel	: '은행코드',
				name		: 'BANK_CODE',
				xtype		: 'uniTextfield',
				readOnly	: true
			},{
				fieldLabel	: '은행명',
				name		: 'BANK_NAME',
				xtype		: 'uniTextfield',
				readOnly	: true
			},{
				fieldLabel	: '통장명',
				name		: 'SAVE_NAME',
				xtype		: 'uniTextfield',
				readOnly	: true
			},{
				fieldLabel	: '계좌번호',
				name		: 'BANK_ACCOUNT1',
				xtype		: 'uniTextfield',
				readOnly	: true
			}]
		}]
	});

	function openbankAccountDetailGridWindow() {
		if(!bankAccountDetailGridWindow) {
			bankAccountDetailGridWindow = Ext.create('widget.uniDetailWindow', {
				title	: '계좌번호 상세',
				width	: 500,
				height	: 220,
				layout	: {type:'vbox', align:'stretch'},
				items	: [bankAccountDetailForm],
				tbar	: ['->',{
					itemId : 'closeBtn',
					text: '닫기',
					handler: function() {
						bankAccountDetailGridWindow.hide();
// draftNoGrid.reset();
						bankAccountDetailForm.clearForm();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					show: function ( panel, eOpts ) {
// bankAccountDetailForm.setValue('BANK_CODE', record.get('BANK_CODE'));
// bankAccountDetailForm.setValue('BANK_NAME','3');
// bankAccountDetailForm.setValue('SAVE_NAME','3');
// bankAccountDetailForm.setValue('BANK_ACCOUNT','3');
					}
				}
			})
		}
		bankAccountDetailGridWindow.center();
		bankAccountDetailGridWindow.show();
	}

	var decrypBtn = Ext.create('Ext.Button',{
		text	: '복호화',
		width	: 80,
		handler	: function() {
			var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
			if(needSave) {
				Unilite.messageBox(Msg.sMB154); //먼저 저장하십시오.
				return false;
			}
			panelSearch.setValue('DEC_FLAG', 'Y');
			UniAppManager.app.onQueryButtonDown();
			panelSearch.setValue('DEC_FLAG', '');
		}
	});



	Unilite.Main({
		id			: 'afs100ukrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid,panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			if((Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE == '') {
				Ext.Msg.alert('확인',Msg.sMA0054);
			} else {
				UniAppManager.setToolbarButtons(['reset', 'newData'], true);
				UniAppManager.setToolbarButtons(['save'], false);

				var tbar = masterGrid._getToolBar();
				tbar[0].insert(tbar.length + 1, decrypBtn);

				panelResult.getField('BANK_BOOK_CODE').focus(); 
				// this.setDefault();
			}
		},
		onQueryButtonDown: function() {
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function() {
			var compCode	= UserInfo.compCode;
			var useYn		= 'Y';
			var mainSaveYn	= 'N';
			var ifYn		= 'N';
			var mainCmsYn	= 'N';
			var moneyUnit	= BsaCodeInfo.gsMoneyUnit;
			var bankAccount	= '';
			var r			= {
				COMP_CODE			: compCode,
				USE_YN 				: useYn,
				MAIN_SAVE_YN		: mainSaveYn,
				IF_YN				: ifYn,
				MAIN_CMS_YN			: mainCmsYn,
				MONEY_UNIT			: moneyUnit,
				BANK_ACCOUNT_EXPOS	: bankAccount
			};
			masterGrid.createRow(r,'SAVE_CODE');
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		setHiddenColumn: function() {
			Ext.each(useColList, function(record, idx) {
				if(record.REF_CODE4 == 'True') {
					if(masterGrid.getColumn(record.REF_CODE3)) {
						masterGrid.getColumn(record.REF_CODE3).setVisible(false);
					} else {
						alert('컬럼명 오류 :: ' + record.REF_CODE3);
					}
				}
			});
		}
	});



	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
// case "BANK_ACCOUNT_CP" : // 계좌번호디스플레이
// if(isNaN(newValue)) {
// rv = Msg.sMB074; //숫자만 입력가능합니다.
// break;
// }
// if(newValue) {
// //var bankAccount = record.get('BANK_ACCOUNT');
// //var bankAccountDisp = record.get('BANK_ACCOUNT_DISP');
// record.set('BANK_ACCOUNT',newValue);
// }
// break;
			}
			return rv;
		}
	});	
};
</script>