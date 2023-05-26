<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aba500ukr">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A098"/>	<!-- 카드구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A010"/>	<!-- 법인/개인구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A004"/>	<!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A028"/>	<!-- 신용카드회사 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>


<script type="text/javascript" >
//var re = new RegExp(/^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}/,'g');

function appMain() {  
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'aba500ukrService.selectList',
			update	: 'aba500ukrService.updateDetail',
			create	: 'aba500ukrService.insertDetail',
			destroy	: 'aba500ukrService.deleteDetail',
			syncAll	: 'aba500ukrService.saveAll'
		}
	});

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Aba500ukrModel', {
		fields: [
			{name: 'CRDT_NUM'				, text: '신용카드코드'	,type: 'string',allowBlank:false},
			{name: 'CRDT_NAME'				, text: '카드명'		,type: 'string',allowBlank:false},
			{name: 'CRDT_FULL_NUM'			, text: '신용카드번호'	,type: 'string',allowBlank:false},
			{name: 'CRDT_FULL_NUM_EXPOS'	, text: '신용카드번호'	,type: 'string',allowBlank:false, defaultValue:'***************'},
			{name: 'CRDT_DIVI'				, text: '법인/개인'		,type: 'string',comboType:'AU', comboCode:'A010',allowBlank:false},
			{name: 'CRDT_KIND'				, text: '카드종류'		,type: 'string',comboType:'AU', comboCode:'A028'},
			{name: 'EXPR_DATE'				, text: '유효년월'		,type: 'uniMonth'/*,allowBlank:false*//*, convert:function(v) {return UniDate.getMonthStr(v,'Ym')}*/},
			{name: 'PERSON_NUMB'			, text: '사번'		,type: 'string'},
			{name: 'NAME'					, text: '성명'		,type: 'string'},
			{name: 'CRDT_GBN'				, text: '카드구분'		,type: 'string',comboType:'AU', comboCode:'A098',allowBlank:false},
			{name: 'USE_YN'					, text: '사용유무'		,type: 'string',comboType:'AU', comboCode:'A004'},
			{name: 'CANC_DATE'				, text: '해지일'		,type: 'uniDate'},
			{name: 'REMARK'					, text: '비고'		,type: 'string'},
			{name: 'BANK_CODE'				, text: '결제은행'		,type: 'string'},
			{name: 'BANK_NAME'				, text: '결제은행명'		,type: 'string'},
			{name: 'ACCOUNT_NUM'			, text: '결제계좌번호'	,type: 'string'},
			{name: 'ACCOUNT_NUM_EXPOS'		, text: '결제계좌번호'	,type: 'string', defaultValue:'***************'},
			{name: 'SET_DATE'				, text: '결제일'		,type: 'string'},
			{name: 'CRDT_COMP_CD'			, text: '카드사코드'		,type: 'string'},
			{name: 'CRDT_COMP_NM'			, text: '카드사명'		,type: 'string'},
			{name: 'LIMIT_AMT'				, text: '한도액'		,type: 'uniPrice'},
			{name: 'UPDATE_DB_USER'			, text: '수정자'		,type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '수정일'		,type: 'string'},
			{name: 'COMP_CODE'				, text: '법인코드'		,type: 'string',allowBlank:false}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('aba500ukrMasterStore1',{
		model	: 'Aba500ukrModel',
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
						//20210812 로직 추가: 저장 후, 재조회
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
				var recordsFirst = directMasterStore.data.items[0];
				if(!Ext.isEmpty(recordsFirst)){
					informationForm.enable();
//					informationForm.setReadOnly(false);
//					UniAppManager.app.setFormField(recordsFirst);
					informationForm.setActiveRecord(recordsFirst);
				} else {
					//20210812 로직 추가: 삭제 후 데이터가 없을 때, 클리어 하도록 로직 추가
					UniAppManager.app.onResetButtonDown();
				}
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
			items: [
				Unilite.popup('CREDIT_NO',{
					fieldLabel: '신용카드', 
					valueFieldName:'CREDIT_NO_CODE',
					textFieldName:'CREDIT_NO_NAME',
					validateBlank : 'text',
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('CREDIT_NO_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('CREDIT_NO_NAME', newValue);
						}
					}
//					listeners: {
//						onSelected: {
//							fn: function(records, type) {
//								panelResult.setValue('CREDIT_NO_CODE', panelSearch.getValue('CREDIT_NO_CODE'));
//								panelResult.setValue('CREDIT_NO_NAME', panelSearch.getValue('CREDIT_NO_NAME'));
//							},
//							scope: this
//						},
//						onClear: function(type) {
//							panelResult.setValue('CREDIT_NO_CODE', '');
//							panelResult.setValue('CREDIT_NO_NAME', '');
//						}
//					}
				}), {			   
					//복호화 플래그(복호화 버튼 누를시 플래그 'Y')
					name:'DEC_FLAG', 
					xtype: 'uniTextfield',
					hidden: true
				}
			]		
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm2',{
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [
			Unilite.popup('CREDIT_NO',{
				fieldLabel: '신용카드', 
				valueFieldName:'CREDIT_NO_CODE',
				textFieldName:'CREDIT_NO_NAME',
//validateBlank : false,
				validateBlank : 'text',
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('CREDIT_NO_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('CREDIT_NO_NAME', newValue);
						}
					}
//				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelSearch.setValue('CREDIT_NO_CODE', panelResult.getValue('CREDIT_NO_CODE'));
//							panelSearch.setValue('CREDIT_NO_NAME', panelResult.getValue('CREDIT_NO_NAME'));
//						},
//						scope: this
//					},
//					onClear: function(type) {
//						panelSearch.setValue('CREDIT_NO_CODE', '');
//						panelSearch.setValue('CREDIT_NO_NAME', '');
//					}
//				}
			})
		]
	});	

	var informationForm = Unilite.createForm('detailForm', { //createForm
//		padding:'10 10 10 10',
//		title :'신용카드 & 결제은행 정보',
//		split:true,
		border: false,
		defaults : {labelWidth: 150,enforceMaxLength: true},
		disabled: false,
		region: 'east',
		masterGrid: masterGrid,
		items: [{
				xtype: 'component',
				border: false,
				html: "<font color= 'blue'><b>&nbsp;&nbsp;&nbsp;&nbsp;※ 신용카드정보</br>&nbsp;</b></font>"
			},{
				fieldLabel: '법인/개인구분',
				name: 'CRDT_DIVI',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A010',
				allowBlank: false
				
			},{
				fieldLabel: '카드종류',
				name: 'CRDT_KIND',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A028',
				allowBlank: false
				
			},{
				fieldLabel: '카드명',
				name: 'CRDT_NAME',
				xtype: 'uniTextfield',
				padding:'0 0 0 0',
				margin:'0 0 0 0',
				maxLength:20,
				allowBlank: false
				
			},{
				xtype: 'container',
				padding:'0 0 0 0',
				margin:'0 0 0 0',
				border: false,
				layout: {type : 'uniTable', columns : 2},
				defaults : {labelWidth: 150,enforceMaxLength: true},
				width:600,
//				height:'100%',
				items :[{
					fieldLabel: '카드코드',
					name: 'CRDT_NUM',
					id:'crdt_num',
					xtype: 'uniTextfield',
//					height:'100%',
					padding:'0 0 0 0',
					margin:'0 0 0 0',
					maxLength:20,
					allowBlank: false,
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
//							if(isNaN(newValue)){
//								Ext.Msg.alert('확인','숫자만 입력가능합니다.');
//								informationForm.setValue('CRDT_NUM','');
//							}
						}
					}
				},{
					xtype: 'component',
					html: '&nbsp;(신용카드POPUP이나 전표입력시 코드로 사용)',
					padding:'0 0 0 0',
					margin:'0 0 0 0',
					border: false
				}]
			},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 2},
				defaults : {labelWidth: 150,enforceMaxLength: true},
				width:600,
				items :[
					/*{
						fieldLabel:'카드번호(full number)',
						name:'DECRYP_WORD',
						xtype: 'uniTextfield',
						readOnly:true,
						focusable:false,
						
						listeners:{
							afterrender:function(field) {
								field.getEl().on('dblclick', field.onDblclick);
							}
						},
						onDblclick:function(event, elm) {
							informationForm.openCryptCardNoPopup();
						}
					},*/{ 
						fieldLabel:'카드번호(full number)',
						name :'CRDT_FULL_NUM_EXPOS',
						xtype: 'uniTextfield',
						readOnly:true,
						focusable:false,
						//hideLabel:true,
						allowBlank: false,
						listeners:{
							afterrender:function(field) {
								field.getEl().on('dblclick', field.onDblclick);
							}
						},
						onDblclick:function(event, elm) {
							informationForm.openCryptCardNoPopup();
						}
					},
				   /*Unilite.popup('CIPHER_CARDNO',{
						fieldLabel: '카드번호(full number)', 
						valueFieldName:'DECRYP_WORD',
						textFieldName:'CRDT_FULL_NUM_EXPOS',
						padding:'1 0 0 0',
						margin:'1 0 3 0',
						autoPopup   : true ,
						listeners: {
							onSelected: {
								
								fn: function(records, type) {
									//alert(records[0]["INC_WORD"]);							
									informationForm.setValue('CRDT_FULL_NUM', records[0]["INC_WORD"]);
									informationForm.setValue('CRDT_FULL_NUM_EXPOS', '***************');
								},
								scope: this
							},
							onClear: function(type) {
								informationForm.setValue('CRDT_FULL_NUM', '');
								informationForm.setValue('CRDT_FULL_NUM_EXPOS', '');
							},
							applyextparam: function(popup){
								 popup.setExtParam({'CRDT_FULL_NUM': informationForm.getValue('CRDT_FULL_NUM')});
						   }
						}
				}),*/{
					xtype: 'component',
					html: '&nbsp;(부가세신고와 브랜치법인카드와 연계시 사용)',
					border: false
				}]
			},{
				fieldLabel: '카드번호(db실사용)',
				name: 'CRDT_FULL_NUM',
				xtype: 'uniTextfield',
				maxLength:50,
				width: 400,
				hidden: true
			},{
				fieldLabel: '유효년월',
				name: 'EXPR_DATE',
				xtype: 'uniMonthfield'
//				allowBlank: false
			},
				Unilite.popup('Employee',{
				fieldLabel: '사번/성명', 
				valueFieldName:'PERSON_NUMB',
				textFieldName:'NAME',
				autoPopup   : true 
				
			}),
			{
				fieldLabel: '카드구분',
				name: 'CRDT_GBN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A098',
				allowBlank: false
				
			},{
				fieldLabel: '사용유무',
				name: 'USE_YN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A004',
				allowBlank: false
				
			},{
				fieldLabel: '해지일',
				xtype: 'uniDatefield',
				name: 'CANC_DATE'
									
			},{
				fieldLabel: '비고',
				name: 'REMARK',
				xtype: 'uniTextfield',
				maxLength:50,
				width: 400
				
			},{		
				xtype: 'component',
				border: false,
				html: "<font color= 'blue'><b></br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;※ 결제은행정보</br>&nbsp;</b></font>"
			}, 
			Unilite.popup('BANK',{
				fieldLabel: '은행', 
				valueFieldName:'BANK_CODE',
				textFieldName:'BANK_NAME',
				popupWidth: 360,
				 padding:'0 0 1 0',
				margin:'0 0 1 0',
//				validateBlnak :false
				autoPopup   : true 
			}), 
			{ 
				fieldLabel:'계좌번호',
				name :'ACCOUNT_NUM_EXPOS',
				readOnly:true,
				focusable:false,
				listeners:{
					afterrender:function(field) {
						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick:function(event, elm) {
					informationForm.openCryptBankAccntPopup();
				}
			},
			{
				fieldLabel: '계좌번호(DB)',
				name: 'ACCOUNT_NUM',
				xtype: 'uniTextfield',
				maxLength:50,
				width: 400,
				hidden: true				
			},
			{
				xtype: 'container',
//				padding:'0 0 0 0',
//				margin:'0 0 0 0',
				layout: {type : 'uniTable', columns : 2
//					tdAttrs: {style: 'border : 1px solid #ced9e7;',height: 1}
//					tdAttrs: {style: 'padding-top: 0px; padding-bottom: 0px'  }  
				},
				defaults : {labelWidth: 150,enforceMaxLength: true},
				width:600,
				items :[{
					fieldLabel: '결제일',
					name: 'SET_DATE',
					xtype: 'uniNumberfield',
					padding:'0 0 1 0',
				margin:'0 0 1 0',
					maxLength:2,
					tdAttrs: {style: 'padding-top: 0px; padding-bottom: 0px'  }  
//					tdAttrs: {style: 'border : 1px solid #ced9e7;',height: 1}
				},{
					xtype: 'component',
					html: '&nbsp;일',
					padding:'0 0 1 0',
				margin:'0 0 1 0',
					height: 20,
					border: false,
					tdAttrs: {style: 'padding-top: 0px; padding-bottom: 0px'  }  
//					tdAttrs: {style: 'border : 1px solid #ced9e7;',height: 1}
				}]
			},
			
			/*{
				fieldLabel: '결제일',
				name: 'SET_DATE',
				xtype: 'uniNumberfield',
				maxLength:2,
				suffixTpl: '일'
			},*/
			Unilite.popup('CUST',{
				fieldLabel: '신용카드사',
				valueFieldName:'CRDT_COMP_CD',
				textFieldName:'CRDT_COMP_NM',
				extParam: {'CUSTOM_TYPE': ['1','2']},
//				validateBlank : true
				 padding:'0 0 0 0',
				margin:'0 0 0 0',
				autoPopup   : true
			}),
			{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 2
//					tdAttrs: {style: 'border : 1px solid #ced9e7;'}
				},
				defaults : {labelWidth: 150,enforceMaxLength: true},
				width:600,
				items :[{
					fieldLabel: '한도액',
					name: 'LIMIT_AMT',
					xtype: 'uniNumberfield',
					maxLength:30
					
				},{
					xtype: 'component',
					html: '&nbsp;원',
					border: false
				}]
			}
			/*{
				fieldLabel: '한도액',
				name: 'LIMIT_AMT',
				xtype: 'uniNumberfield',
				maxLength:30,
				suffixTpl: '원'
				
			}*/
			
		],
		openCryptBankAccntPopup:function(  ) {
			var record = this;
			if(this.activeRecord) {
				var params = {'BANK_ACCOUNT': this.getValue('ACCOUNT_NUM'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('form', record, 'ACCOUNT_NUM_EXPOS', 'ACCOUNT_NUM', params);
//				var params = {'BANK_ACCNT_CODE': this.getValue('ACCOUNT_NUM'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'};
//				Unilite.popupCipherComm('form', record, 'ACCOUNT_NUM_EXPOS', 'ACCOUNT_NUM', params);
			}
		},
		openCryptCardNoPopup:function(  ) {
			var record = this;
			if(this.activeRecord) {
				var params = {'CRDT_FULL_NUM':this.getValue('CRDT_FULL_NUM'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'Y'};
				//Unilite.popupCryptCipherCardNo('form', record, 'CRDT_FULL_NUM_EXPOS', 'CRDT_FULL_NUM', params);
				Unilite.popupCipherComm('form', record, 'CRDT_FULL_NUM_EXPOS', 'CRDT_FULL_NUM', params);
			}
		}
	});

	var masterGrid = Unilite.createGrid('atx425ukrGrid1', {
		store		: directMasterStore,
		region		: 'center',
		excelTitle	: '신용카드정보등록',
//		split		: true,
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
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		columns	: [
			{dataIndex: 'CRDT_NUM'				, width: 100},
			{dataIndex: 'CRDT_NAME'				, width: 120},
			{dataIndex: 'CRDT_FULL_NUM_EXPOS'	, width: 135,align:'center'},
			{dataIndex: 'CRDT_FULL_NUM'			, width: 135, hidden: true
				/*renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					return (val.substring(0,4) + '-' + val.substring(4,8) + '-' + val.substring(8,12) + '-' + val.substring(12));
				}*/
			},
			{dataIndex: 'CRDT_DIVI'				, width: 80,hidden: false,align:'center'},
			{dataIndex: 'CRDT_KIND'				, width: 88, hidden: false,align:'center'},
			{dataIndex: 'EXPR_DATE'				, width: 88, hidden: false,align:'center'},
			{dataIndex: 'PERSON_NUMB'			, width: 100,hidden: false},
			{dataIndex: 'NAME'					, width: 100,hidden: false},
			{dataIndex: 'CRDT_GBN'				, width: 100, hidden: false,align:'center'},
			{dataIndex: 'USE_YN'				, width: 66, hidden: false,align:'center'},
			{dataIndex: 'CANC_DATE'				, width: 88, hidden: false},
			{dataIndex: 'REMARK'				, width: 150, hidden: false},
			{dataIndex: 'BANK_CODE'				, width: 66, hidden: false},
			{dataIndex: 'BANK_NAME'				, width: 133,hidden: false},
			{dataIndex: 'ACCOUNT_NUM'			, width: 133,hidden: true},
			{dataIndex: 'ACCOUNT_NUM_EXPOS'		, width: 133,hidden: false,align:'center'},
			{dataIndex: 'SET_DATE'				, width: 66, hidden: false},
			{dataIndex: 'CRDT_COMP_CD'			, width: 88, hidden: false},
			{dataIndex: 'CRDT_COMP_NM'			, width: 120, hidden: false},
			{dataIndex: 'LIMIT_AMT'				, width: 66, hidden: false},
			{dataIndex: 'UPDATE_DB_USER'		, width: 66, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 90, hidden: true},
			{dataIndex: 'COMP_CODE'				, width: 88, hidden: true}
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				return false;
			},
			selectionchangerecord:function(selected) {
				informationForm.setActiveRecord(selected);
				informationForm.uniOpt.inLoading = true;
				if(!Ext.isEmpty(selected.data.UPDATE_DB_TIME)){
					Ext.getCmp('crdt_num').setReadOnly(true);
				}else{
					Ext.getCmp('crdt_num').setReadOnly(false);
				}
				
				if(!Ext.isEmpty(selected.data.CRDT_FULL_NUM)){
					informationForm.setValue('CRDT_FULL_NUM_EXPOS', '***************');
				}else{
					informationForm.setValue('CRDT_FULL_NUM_EXPOS', '');
				}
				
				if(!Ext.isEmpty(selected.data.ACCOUNT_NUM)){
					informationForm.setValue('ACCOUNT_NUM_EXPOS', '***************');
				}else{
					informationForm.setValue('ACCOUNT_NUM_EXPOS', '');
				}
				informationForm.uniOpt.inLoading = false;
			},
			onGridDblClick:function(grid, record, cellIndex, colName, td) {
				if(colName =="CRDT_FULL_NUM_EXPOS") {
					grid.ownerGrid.openCryptCardNoPopup(record);
				}else if(colName =="ACCOUNT_NUM_EXPOS") {
					grid.ownerGrid.openCryptAcntNumPopup(record);
				}
			}
		},
		openCryptCardNoPopup:function( record ) {
			if(record) {
				var params = {'CRDT_FULL_NUM': record.get('CRDT_FULL_NUM'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'CRDT_FULL_NUM_EXPOS', 'CRDT_FULL_NUM', params);
			}
		},
		openCryptAcntNumPopup:function( record ) {
			if(record) {
				var params = {'BANK_ACCOUNT': record.get('ACCOUNT_NUM'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'ACCOUNT_NUM_EXPOS', 'ACCOUNT_NUM', params);
			}
		}
	});

	//복호화 버튼 정의
	var decrypBtn = Ext.create('Ext.Button',{
		text	: '복호화',
		width	: 80,
		handler	: function() {
			var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
			if(needSave){
				Unilite.messageBox(Msg.sMB154); //먼저 저장하십시오.
				return false;
			}
			panelSearch.setValue('DEC_FLAG', 'Y');
			UniAppManager.app.onQueryButtonDown();
			panelSearch.setValue('DEC_FLAG', '');
		}
	});



	Unilite.Main({
		id			: 'aba500ukrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [{
				border	: false,
				split	: true,
				flex	: 1,
				layout	: {type: 'hbox', align: 'stretch'},
				region	: 'west',
				items	: [masterGrid]
			},{
				border	: true,	
//				split	: true,
				padding	: '1 1 1 1',
				flex	: 1.5,
				title	:'신용카드 정보',
				layout	: {type: 'hbox', align: 'stretch'},
				region	: 'center',
				items	: [informationForm]
			},
			panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			UniAppManager.setToolbarButtons(['save'], false);
			informationForm.disable();
//			informationForm.setReadOnly(true);

			//복호화버튼 그리드 툴바에 추가가
			var tbar = masterGrid._getToolBar();
			tbar[0].insert(tbar.length + 1, decrypBtn);
//			panelResult.getField('CREDIT_NO_CODE').focus(); 
		},
		onQueryButtonDown: function() {
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function() {
//			informationForm.clearForm();
			informationForm.enable();
//			informationForm.setReadOnly(false);
			var compCode= UserInfo.compCode;
			var useYn	= 'Y';
			var crdtGbn	= '1';
			var crdtNum	= '';

			var r = {
				COMP_CODE			: compCode,
				CRDT_GBN			: crdtGbn,
				USE_YN				: useYn,
				CRDT_FULL_NUM_EXPOS	: crdtNum
			};
			masterGrid.createRow(r);
			informationForm.getField('CRDT_DIVI').focus();
		},
		onResetButtonDown: function() {
			//20210812 수정: 신규 버튼 후, 추가 버튼 눌렀을 때 입력필드 활성화 되지 않는 현상 발생하여 일괄 수정
			panelSearch.clearForm();
			panelResult.clearForm();
			informationForm.clearForm();
			directMasterStore.loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
//				var nextSelRow = masterGrid.getSelectedRecord();
//				UniAppManager.app.setFormField(nextSelRow);
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
//				var nextSelRow = masterGrid.getSelectedRecord();
//				UniAppManager.app.setFormField(nextSelRow);
			}
		}
	});



	Unilite.createValidator('validator01', {
		store	: directMasterStore,
		grid	: masterGrid,
		forms	: {'formA:':informationForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName){
				case "EXPR_DATE":
					if(Ext.isEmpty(newValue)){
						break;
					}else{
						record.set('EXPR_DATE',UniDate.getDbDateStr(newValue).substring(0, 6));
					}
					break;
				case "SET_DATE":
					if(Ext.isEmpty(newValue)){
						break;
					}else{
						if(newValue > 31){
//							rv='<t:message code = "unilite.msg.sMA0026"/>';	
							Ext.Msg.alert("확인","일자 형식으로 입력하십시오.");
//							return oldValue;
							informationForm.setValue('SET_DATE','');
						}
					}
					break;
			}
			return rv;
		}
	}); // validator
};
</script>