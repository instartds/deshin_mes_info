<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_axt121ukr_kd"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="s_axt121ukr_kd"/>             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU"    comboCode="B038"/>             <!-- 결제방법 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_axt121ukr_kdService.selectList',
			update	: 's_axt121ukr_kdService.updateDetail',
			create	: 's_axt121ukr_kdService.insertDetail',
			destroy	: 's_axt121ukr_kdService.deleteDetail',
			syncAll	: 's_axt121ukr_kdService.saveAll'
		}
	});
	
	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('s_axt121ukr_kdModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '법인코드'			, type: 'string'	},
			{name: 'DIV_CODE'			, text: '사업장코드'			, type: 'string'	},
			{name: 'AC_YYYYMM'			, text: '전표년월'			, type: 'string'	, allowBlank: false	, format:'YYYY.MM'},
			{name: 'PAY_YYYYMM'			, text: '지급년월'			, type: 'string'	, allowBlank: false	, format:'YYYY.MM'},
			{name: 'SET_METH'			, text: '결제방법'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B038'},
			{name: 'CUSTOM_CODE'		, text: '거래처코드'			, type: 'string'	, allowBlank: false},
			{name: 'CUSTOM_NAME'		, text: '거래처명'			, type: 'string'	},
			{name: 'AMT_I'				, text: '전표금액'			, type: 'uniPrice'	},
			{name: 'JAN_AMT_I'			, text: '이전잔액'			, type: 'uniPrice'	},
			{name: 'PAY_AMT_I'			, text: '지급금액'			, type: 'uniPrice'	, allowBlank: false},
			{name: 'REMAIN_AMT_I'		, text: '잔액'			, type: 'uniPrice'	},
			{name: 'REMARK'				, text: '비고'			, type: 'string'	}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_axt121ukr_kdMasterStore1',{
		model: 's_axt121ukr_kdModel',
		uniOpt : {
			isMaster: true,            // 상위 버튼 연결
			editable: true,            // 수정 모드 사용
			deletable:true,            // 삭제 가능 여부
			useNavi : false            // prev | newxt 버튼 사용

		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords : function()    {
			var param = Ext.getCmp('panelResultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			
			var paramMaster = panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_axt121ukr_kdGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120'
		},{
			fieldLabel  : '전표년월',
			name        : 'AC_YYYYMM',
			xtype       : 'uniMonthfield',
			id          : 'stMonth',
			value       : new Date(),
			allowBlank  : false
		},{
            fieldLabel  : '결제방법',
            name        : 'SET_METH',
            xtype       : 'uniCombobox',
            comboType   : 'AU',
            comboCode   : 'B038',
			listeners	: {
				afterrender: {
					fn: function (combo) {
						var store = combo.getStore()
						var rec = { value: '', text: '' };
						store.insert(0, rec);
					}
				}
			}
        },
        Unilite.popup('CUST',{
			fieldLabel: '거래처',
			popupWidth: 710,
			autoPopup   : true ,
			allowBlank  : true,
			valueFieldName: 'CUSTOM_CODE_FR',
			textFieldName: 'CUSTOM_NAME_FR',
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
					panelResult.setValue('CUSTOM_CODE_FR', '');
					panelResult.setValue('CUSTOM_NAME_FR', '');
				},
				applyextparam: function(popup){
				}
//				onTextSpecialKey: function(elm, e){
//					if (e.getKey() == e.ENTER) {
//						UniAppManager.app.onQueryButtonDown();
//					}
//				}
			}
		}),
		Unilite.popup('CUST',{
			fieldLabel: '~',
			popupWidth: 710,
			autoPopup   : true ,
			allowBlank  : true,
			colspan:3,
			valueFieldName: 'CUSTOM_CODE_TO',
			textFieldName: 'CUSTOM_NAME_TO',
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
					panelResult.setValue('CUSTOM_CODE_TO', '');
					panelResult.setValue('CUSTOM_NAME_TO', '');
				},
				applyextparam: function(popup){
				}
//				onTextSpecialKey: function(elm, e){
//					if (e.getKey() == e.ENTER) {
//						UniAppManager.app.onQueryButtonDown();
//					}
//				}
			}
		})],
		setAllFieldsReadOnly: function(b) {
			var r = true;
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});                      
				if(invalid.length > 0) {
					r=false;
					var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
					
					return r;
				}
			}
			
			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) ) {
					if (item.holdable == 'hold') {
						item.setReadOnly(b);
					}
				}
				if(item.isPopupField) {
					var popupFC = item.up('uniPopupField') ;       
					if(popupFC.holdable == 'hold') {
						popupFC.setReadOnly(b);
					}
				}
			});
			return r;
		}
	});

	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_axt121ukr_kdGrid1', {
		region: 'center',
		layout: 'fit',
		uniOpt:{
			expandLastColumn: false,    //마지막 컬럼 * 사용 여부
			useRowNumberer: true,        //첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,        //찾기 버튼 사용 여부
			useRowContext: false,
			onLoadSelectFirst    : true,
			filter: {                    //필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false}
		],
		store: directMasterStore1,
		columns:  [
			{ dataIndex: 'COMP_CODE'			, width: 100	, hidden:true},
			{ dataIndex: 'DIV_CODE'				, width: 100	, hidden:true},
			{ dataIndex: 'AC_YYYYMM'			, width: 90		, align:'center'},
			{ dataIndex: 'CUSTOM_CODE'			, width: 80		,
				'editor' : Unilite.popup('AGENT_CUST_G',{
					textFieldName:'CUSTOM_NAME',
					DBtextFieldName:'CUSTOM_NAME',
					autoPopup: true,
					listeners: {
						'onSelected':  function(records, type  ){
							var grdRecord = masterGrid.uniOpt.currentRecord;
							var record = masterGrid.getSelectedRecord();
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('SET_METH',records[0]['SET_METH']);
							
							var param = {
								CUSTOM_CODE	: records[0]['CUSTOM_CODE'],
								DIV_CODE	: panelResult.getValue('DIV_CODE'),
								AC_YYYYMM	: UniDate.getDbDateStr(grdRecord.get('AC_YYYYMM'))
							};
							
							s_axt121ukr_kdService.fnGetAmtI(param, function(provider, response)  {
								if(!Ext.isEmpty(provider)){
									grdRecord.set('AMT_I' , provider[0]['AMT_I']);
									grdRecord.set('PAY_AMT_I' , provider[0]['PAY_AMT_I']);
									grdRecord.set('REMAIN_AMT_I' , provider[0]['REMAIN_AMT_I']);
								}
							});
						}
					}
				})
			},
			{ dataIndex: 'CUSTOM_NAME'			, width: 133	,
				'editor' : Unilite.popup('AGENT_CUST_G',{
					textFieldName:'CUSTOM_NAME',
					DBtextFieldName:'CUSTOM_NAME',
					autoPopup: true,
					listeners: {
						'onSelected':  function(records, type  ){
							var grdRecord = masterGrid.uniOpt.currentRecord;
							var record = masterGrid.getSelectedRecord();
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('SET_METH',records[0]['SET_METH']);
							
							var param = {
								CUSTOM_CODE	: records[0]['CUSTOM_CODE'],
								DIV_CODE	: panelResult.getValue('DIV_CODE'),
								AC_YYYYMM	: UniDate.getDbDateStr(grdRecord.get('AC_YYYYMM'))
							};
							
							s_axt121ukr_kdService.fnGetAmtI(param, function(provider, response)  {
								if(!Ext.isEmpty(provider)){
									grdRecord.set('AMT_I' , provider[0]['AMT_I']);
									grdRecord.set('PAY_AMT_I' , provider[0]['PAY_AMT_I']);
									grdRecord.set('REMAIN_AMT_I' , provider[0]['REMAIN_AMT_I']);
								}
							});
						}
					}
				})
			},
			{ dataIndex: 'SET_METH'				, width: 80},
			{ dataIndex: 'AMT_I'				, width: 100},
			{ dataIndex: 'JAN_AMT_I'			, width: 100	, hidden:true	},
			{ dataIndex: 'PAY_AMT_I'			, width: 100},
			{ dataIndex: 'REMAIN_AMT_I'			, width: 100},
			{ dataIndex: 'PAY_YYYYMM'			, width: 90		, align:'center'},
			{ dataIndex: 'REMARK'				, width: 300}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['CUSTOM_CODE','CUSTOM_NAME', 'PAY_AMT_I', 'PAY_YYYYMM', 'AC_YYYYMM', 'REMARK'])) {
					return true;
				} else {
					return false;
				}
			}
		}
	});

	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		}
		],
		id  : 's_axt121ukr_kdApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			
			panelResult.setValue('AC_YYYYMM', new Date());
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			
			masterGrid.getStore().loadStoreRecords();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
		},
		onNewDataButtonDown: function()	{
			var divCode		= panelResult.getValue('DIV_CODE');
			var payDate		= panelResult.getValue('AC_YYYYMM');
			var mon			= payDate.getMonth() + 1;
			var dateString	= payDate.getFullYear() + '.' + (mon > 9 ? mon : '0' + mon);
			var mRecord		= masterGrid.getSelectedRecord();
			
			var r = {
				COMP_CODE : 'MASTER',
				DIV_CODE : divCode,
				AC_YYYYMM	: dateString,
				PAY_YYYYMM	: dateString,
				AMT_I: 0,
				PAY_AMT_I: 0
			};
			
			if(!Ext.isEmpty(mRecord)) {
				var preJamAmtI = this.getLastRemainAmt(divCode, dateString, mRecord.get('CUSTOM_CODE'), mRecord.get('AMT_I'));
				r = {
					COMP_CODE		: 'MASTER',
					DIV_CODE		: divCode,
					AC_YYYYMM		: dateString,
					PAY_YYYYMM		: '',
					SET_METH		: mRecord.get('SET_METH'),
					CUSTOM_CODE		: mRecord.get('CUSTOM_CODE'),
					CUSTOM_NAME		: mRecord.get('CUSTOM_NAME'),
					AMT_I			: mRecord.get('AMT_I'),
					JAN_AMT_I		: preJamAmtI,
					PAY_AMT_I		: 0,
					REMAIN_AMT_I	: preJamAmtI,
					REMARK			: ''
				};
			}
			
			masterGrid.createRow(r);
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			} else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown:function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			
			this.fnInitBinding();
		},
		getLastRemainAmt:function(divCode, acYM, custCd, oriAmtI) {
			var payYM		= '000001';
			var remainAmtI	= 0;
			var bUpdateYN	= false;
			
			Ext.each(masterGrid.getStore().data.items, function(record, index){
				if (record.get('DIV_CODE')	== divCode	&&
					record.get('AC_YYYYMM').replace('.', '')	== acYM.replace('.', '')		&&
					record.get('CUSTOM_CODE')	== custCd	) {
					if(record.get('PAY_YYYYMM').replace('.', '') > payYM.replace('.', '')) {
						payYM		= record.get('PAY_YYYYMM').replace('.', '');
						remainAmtI	= record.get('REMAIN_AMT_I');
						bUpdateYN	= true;
					}
				}
			});
			
			if(!bUpdateYN) {
				remainAmtI = oriAmtI;
			}
			
			return remainAmtI;
		}
	});

	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "AC_YYYYMM":
					var customCode = record.get('CUSTOM_CODE');
					var num_check = /[0-9]/;
					
					if (!num_check.test(newValue)) {
						Ext.Msg.alert(Msg.sMB099, Msg.sMB074);
						record.set('AC_YYYYMM', oldValue);
						return false;
					}
					if(!Ext.isEmpty(customCode)){
						var param = {
							CUSTOM_CODE	: record.get('CUSTOM_CODE'),
							DIV_CODE	: panelResult.getValue('DIV_CODE'),
							AC_YYYYMM	: UniDate.getDbDateStr(newValue)
						};
						
						s_axt121ukr_kdService.fnGetAmtI(param, function(provider, response) {
							if(!Ext.isEmpty(provider)){
								record.set('AMT_I' , provider[0]['AMT_I']);
								record.set('PAY_AMT_I' , provider[0]['PAY_AMT_I']);
								//record.set('REMAIN_AMT_I' , provider[0]['REMAIN_AMT_I']);
								record.set('JAN_AMT_I'		, UniAppManager.app.getLastRemainAmt(param.DIV_CODE, param.AC_YYYMM, param.CUSTOM_CODE, provider[0]['AMT_I']));
								record.set('REMAIN_AMT_I'	, UniAppManager.app.getLastRemainAmt(param.DIV_CODE, param.AC_YYYMM, param.CUSTOM_CODE, provider[0]['AMT_I']));
							}
						});
					}
					break;
					
				case "CUSTOM_CODE" :
					if(Ext.isEmpty(record.get("AC_YYYYMM"))) {
						rv = '거래처 입력 전 전표년월을 먼저 입력해주세요.';
						break;
					}
					break;

				case "PAY_AMT_I" :
					if(newValue <= 0){
						rv = '<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					if(Ext.isEmpty(record.get("CUSTOM_CODE"))){
						rv = '지급금액 입력 전 거래처를 먼저 입력해주세요.'
						break;
					}
					if(record.get("JAN_AMT_I") < newValue){
						rv = '지급금액이 전표금액보다 클 수는 없습니다.'
						break;
					}
					
					record.set("REMAIN_AMT_I", record.get("JAN_AMT_I") - newValue);
					break;

				case "PAY_YYYYMM":
					var num_check = /[0-9]/;
					
					if (!num_check.test(newValue)) {
						Ext.Msg.alert(Msg.sMB099, Msg.sMB074);
						record.set('AC_YYYYMM', oldValue);
						return false;
					}
					break;
			}
			return rv;
		}
	});
};
</script>
