<%--
'	프로그램명 : 주문확정
'	작   성   자 : 시너지 시스템즈 개발팀
'	작   성   일 :
'	최종수정자 :
'	최종수정일 :
'	버	 전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ord109ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ord109ukrv"/>	<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>			<!-- 상태   -->
	<t:ExtComboStore comboType="AU" comboCode="B039"/>			<!-- 출고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="ZM11"/>			<!-- 배송방법 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >
	var protocol = ("https:" == document.location.protocol) ? "https" : "http";
	if(protocol == "https") {
		document.write(unescape("%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	} else {
		document.write(unescape("%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	}
</script><!-- Unilite.popup('ZIP',..) -->

<script type="text/javascript" >

var BsaCodeInfo = {
	gsAgentType	: '${gsAgentType}',
	gsMoneyUnit	: '${gsMoneyUnit}',
	gsVatRate	: '${gsVatRate}'
}
var gsResetButton	= false;

function appMain() {
	/** Proxy 정의 
	 *  @type 
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ord109ukrvService.selectList',
//			create	: 'ord109ukrvService.insertDetail',
			update	: 'ord109ukrvService.updateDetail',
			destroy	: 'ord109ukrvService.deleteDetail',
			syncAll	: 'ord109ukrvService.saveAll'
		}
	});

	/** Model 정의 
	 *  @type 
	 */
	Unilite.defineModel('ord109ukrvModel', {
		fields: [
			{name: 'SO_DATE'		, text: '주문일'		, type: 'uniDate'},
			{name: 'ITEM_CODE'		, text: '품목코드'		, type: 'string', allowBlank:false},
			{name: 'ITEM_NAME'		, text: '품명'		, type: 'string', allowBlank:false},
			{name: 'TRNS_RATE'		, text: '입수'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000', allowBlank:false},
			{name: 'ORDER_UNIT'		, text: '판매단위'		, type: 'string', comboType:'AU',comboCode:'B013', displayField: 'value', allowBlank:false},
			{name: 'ORDER_Q'		, text: '주문량'		, type: 'uniQty', allowBlank:false},
			{name: 'ORDER_P'		, text: '단가'		, type: 'uniUnitPrice', allowBlank:false},
			{name: 'ORDER_O'		, text: '금액'		, type: 'uniPrice'},
			{name: 'ORDER_TAX_O'	, text: '부가세액'		, type: 'uniPrice'},
			{name: 'ORDER_TOT_O'	, text: '합계'		, type: 'uniPrice'},
			{name: 'REMARK'			, text: '사용자 비고'	, type: 'string'},
			{name: 'SO_NUM'			, text: '주문번호'		, type: 'string'},
			{name: 'SO_SEQ'			, text: '주문순번'		, type: 'int'},
			{name: 'SO_ITEM_SEQ'	, text: '주문품목순번'	, type: 'int'},
			{name: 'STATUS_FLAG'	, text: '상태'		, type: 'string'},
			{name: 'SALE_CUST_CD'	, text: '주문자'		, type: 'string'},
			{name: 'AGENT_TYPE'		, text: '고객분류'		, type: 'string'},
			{name: 'STATUS_FLAG'	, text: '주문상태'		, type: 'string'},		//1:대기, 2:주문확정, 8:취소, 9:수주확정
			{name: 'DVRY_DATE'		, text: '납기일'		, type: 'uniDate'},
			{name: 'SAVE_FLAG'		, text: '저장FLAG'	, type: 'string'},
			{name: 'TAX_TYPE'		, text: '세구분'		, type: 'string'},
			{name: 'TAX_CALC_TYPE'	, text: '세액계산법'		, type: 'string'},
			{name: 'VAT_RATE'		, text: '세율'		, type: 'string'},
			{name: 'ADDRESS'		, text: '주소'		, type: 'string'},
			//20210319 추가
			{name: 'DELIV_METHOD'	, text: '배송방법'		, type: 'string', comboType: 'AU', comboCode: 'ZM11'},
			{name: 'RECEIVER_NAME'	, text: '수령자명'		, type: 'string'},
			{name: 'TELEPHONE_NUM1'	, text: '수령자 연락처'	, type: 'string'},
			{name: 'ZIP_NUM'		, text: '우편번호'		, type: 'string'},
			{name: 'ADDRESS1'		, text: '주소'		, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 *  @type 
	 */
	var directMasterStore = Unilite.createStore('ord109ukrvMasterStore',{
		proxy	: directProxy,
		model	: 'ord109ukrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function(STATUS_FLAG) {
			if(gsResetButton) {
				gsResetButton = false;
				return false;
			}
			var param= panelResult.getValues();
			//라디오 값이 있을 경우, set
			if(!Ext.isEmpty(STATUS_FLAG)) {
				param.STATUS_FLAG = STATUS_FLAG;
			}
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);
			//20210319 추가
			var saveFlag	= true;
			Ext.each(list, function(record, index) {
				if (!Ext.isEmpty(record.get('SAVE_FLAG'))																				//저장할 데이터 이고,
				&& (record.get('DELIV_METHOD') == '01' || record.get('DELIV_METHOD') == '02' || record.get('DELIV_METHOD') == '03')		//배송방법이 택배이면
				&& (Ext.isEmpty(record.get('RECEIVER_NAME')) || Ext.isEmpty(record.get('TELEPHONE_NUM1')) || Ext.isEmpty(record.get('ZIP_NUM')) || Ext.isEmpty(record.get('ADDRESS1')))) {	//수령자 정보는 필수
					Unilite.messageBox('택배배송일 경우, 수령자 정보(수령자명, 연락처, 우편번호, 주소)는 필수 입력 입니다.');
					saveFlag = false;
					return false;
				}
			});
			if(!saveFlag) {
				return false;
			}

			// 1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	// syncAll 수정

			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();

						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('ord109ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				panelResult.setValue('SAVE_FLAG', '');
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				//20210319 추가
				if(!Ext.isEmpty(record.get('TELEPHONE_NUM1') && modifiedFieldNames == 'TELEPHONE_NUM1')) {
					record.set('TELEPHONE_NUM1', record.get('TELEPHONE_NUM1').replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3"));
				}
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		_onStoreLoad: function ( store, records, successful, eOpts ) {
		}
	});


	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5
//			,tableAttrs: {width: '100%'}
//			,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '업체명',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			readOnly	: true,
			value		: UserInfo.divCode
		},
		Unilite.popup('VMI_PUMOK',{
			fieldLabel		: '품목',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			tdAttrs			: {width: 300},
			listeners: {
                onValueFieldChange: function( elm, newValue, oldValue) {						
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function( elm, newValue, oldValue) {
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_CODE', '');
					}
				},
                applyextparam: function(popup){
                    popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                }
            }
		}),{
			fieldLabel		: '납기일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'DVRY_DATE_FR',
			endFieldName	: 'DVRY_DATE_TO',
			tdAttrs			: {width: 300},
			holdable		: 'hold',
			listeners		: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '주문자',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME', 
			hidden			: true,
			readOnly		: true
		}),{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			width	: 300,
			tdAttrs	: {width: 300},
			items	: [{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.common.status" default="상태"/>',
				id			: 'statusFlag',
				items		: [{
					boxLabel	: '주문대기', 
					width		: 80,
					name		: 'STATUS_FLAG',
					inputValue	: '1',
					checked		: true
				},{
					boxLabel	: '주문확정', 
					width		: 80,
					name		: 'STATUS_FLAG',
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						directMasterStore.loadStoreRecords(newValue.STATUS_FLAG);
						UniAppManager.setToolbarButtons('reset', true);

						if(newValue.STATUS_FLAG == '1') {
							directMasterStore.uniOpt.editable	= true;
							directMasterStore.uniOpt.deletable	= true;
							panelResult.down('#btnConfirm').setText('주문확정');
							
							// tbar show
							Ext.getCmp('txtAddr').setHidden(false);
							Ext.getCmp('btnAddr').setHidden(false);
						} else {
							directMasterStore.uniOpt.editable	= false;
							directMasterStore.uniOpt.deletable	= false;
							panelResult.down('#btnConfirm').setText('주문취소');
							
							// tbar hidden
							Ext.getCmp('txtAddr').setHidden(true);
							Ext.getCmp('btnAddr').setHidden(true);
						}
					}
				}
			}]
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			tdAttrs	: {align: 'right'},
			padding	: '0 0 3 0',
			items	: [{
				xtype	: 'button',
				text	: '주문확정',	
				itemId	: 'btnConfirm',
				name	: 'CONFIRM',
				width	: 110,	
				handler	: function() {
					if(masterGrid.selModel.getCount() == 0) {
						Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
						return false;
					}
					var records = masterGrid.getSelectedRecords()
					Ext.each(records, function(record, index) {
						//주문확정
						if(Ext.getCmp('statusFlag').getChecked()[0].inputValue == '1') {
							record.set('SAVE_FLAG', 'Y');
							panelResult.setValue('SAVE_FLAG', 'Y');
						//주문취소
						} else {
							record.set('SAVE_FLAG', 'N');
							panelResult.setValue('SAVE_FLAG', 'N');
						}
					});
					directMasterStore.saveStore();
				}
			}
		]},{
			fieldLabel	: 'SAVE_FLAG',
			xtype		: 'uniTextfield',
			name		: 'SAVE_FLAG',
			hidden		: true
		}],
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

					Unilite.messageBox(labelText+Msg.sMB083);
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
							var popupFC = item.up('uniPopupField');
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
						var popupFC = item.up('uniPopupField');
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
	 *  @type 
	 */
	var masterGrid = Unilite.createGrid('ord109ukrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center', 
		uniOpt	: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ 
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
				},
				deselect: function(grid, selectRecord, index, eOpts ){
				}
			}
		}),
		columns: [
			{
				xtype		: 'rownumberer', 
				sortable	: false,
				align		: 'center !important',
				resizable	: true, 
				width		: 35
			},
			{dataIndex: 'SO_DATE'			, width: 80	, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
				}
			},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'TRNS_RATE'			, width: 80 },
			{dataIndex: 'ORDER_UNIT'		, width: 90 , align: 'center'},
			{dataIndex: 'ORDER_Q' 			, width: 90 , summaryType: 'sum'},
			{dataIndex: 'ORDER_P'			, width: 90},
			{dataIndex: 'ORDER_O'			, width: 90	, summaryType: 'sum'},
			{dataIndex: 'ORDER_TAX_O'		, width: 90	, summaryType: 'sum'},
			{dataIndex: 'ORDER_TOT_O'		, width: 90	, summaryType: 'sum'},
			{dataIndex: 'DVRY_DATE'			, width: 80 },
			{dataIndex: 'REMARK'			, width: 220},
			{dataIndex: 'ADDRESS'			, width: 300},
			{dataIndex: 'SO_NUM'			, width: 130},
			{dataIndex: 'SO_SEQ'			, width: 80	},
			{dataIndex: 'SO_ITEM_SEQ'		, width: 80	, hidden: true},
			{dataIndex: 'SALE_CUST_CD'		, width: 80	, hidden: true},
			{dataIndex: 'AGENT_TYPE'		, width: 80	, hidden: true},
			{dataIndex: 'STATUS_FLAG'		, width: 80	, hidden: true},
			{dataIndex: 'SAVE_FLAG'			, width: 80	, hidden: true},
			//20210319 추가
			{dataIndex: 'DELIV_METHOD'		, width: 100, hidden: true, align: 'center'},
			{dataIndex: 'RECEIVER_NAME'		, width: 100, hidden: true},
			{dataIndex: 'TELEPHONE_NUM1'	, width: 120, hidden: true},
			{dataIndex: 'ZIP_NUM'			, width: 100, hidden: true,
				editor: Unilite.popup('ZIP_G',{
					textFieldName	: 'ZIP_NUM',
					DBtextFieldName	: 'ZIP_NUM',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ADDRESS1', records[0]['ZIP_NAME'] + ' ' + records[0]['ADDR2']);
								grdRecord.set('ZIP_NUM'	, records[0]['ZIP_CODE']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ADDRESS1', '');
							grdRecord.set('ZIP_NUM'	, '');
						},
						applyextparam: function(popup){
							var grdRecord	= masterGrid.uniOpt.currentRecord;
							var paramAddr	= grdRecord.get('ADDRESS1');	//우편주소 파라미터로 넘기기
							if(Ext.isEmpty(paramAddr)){
								popup.setExtParam({'GBN': 'post'});			//검색조건을 우편번호에서 주소로 바꾸는 구분값
							} else {
								popup.setExtParam({'GBN': 'addr'});			//검색조건을 우편번호에서 주소로 바꾸는 구분값
							}
							popup.setExtParam({'ADDR': paramAddr});
						}
					}
				})
			},
			{dataIndex: 'ADDRESS1'			, width: 200, hidden: true},
			{dataIndex: 'TAX_TYPE'	        , width: 120, hidden: true},
			{dataIndex: 'TAX_CALC_TYPE'	    , width: 120, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['ORDER_Q','DVRY_DATE','REMARK','DELIV_METHOD', 'ADDRESS'])) {		//20210319 추가: DELIV_METHOD
					return true;
				} else {
					//20210319 추가
					if(e.record.get('DELIV_METHOD') == '01' || e.record.get('DELIV_METHOD') == '02' || e.record.get('DELIV_METHOD') == '03') {
						if(UniUtils.indexOf(e.field, ['RECEIVER_NAME','TELEPHONE_NUM1','ZIP_NUM','ADDRESS1'])) {
							return true;
						}
					}
					return false;
				}
			// tbar 추가
			}, render : function(grid, eOpt) {

				var tbar = grid._getToolBar();
				var i = tbar[0].items.length -3;   // 앞에 버튼 뒤에 오도록 length 조절
				
				// Text 추가
				tbar[0].insert(i++,{
					fieldLabel	: '주소입력부',
					xtype		: 'uniTextfield',
					id			: 'txtAddr',
					width       : 300,
					labelWidth	: 70,
		    		});
				
				// 버튼 추가
				tbar[0].insert(i++,{
		        	xtype	: 'button',
	        		id		: 'btnAddr',
		        	text	: '일괄반영',
		        	handler	: function()	{
		        		var records = masterGrid.getSelectionModel().getSelection();
						if(records.length > 0){
							var address = Ext.getCmp('txtAddr').getValue();
							if(Ext.isEmpty(address)){
								alert('주소를 입력하십시요.');
								return false;
							}
	
							Ext.each(records, function(record, i){
								record.set("ADDRESS" , address);
							});
						} else {
							alert('데이터를 선택하세요');
							return false;
						}
						Ext.getCmp('txtAddr').setValue('');
		        	}
		    	});
			}
		}
	});



	Unilite.Main({
		id			: 'ord109ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		}],
		fnInitBinding : function(params) {
			var PGM_TITLE = '주문확정';
			UniAppManager.setPageTitle(PGM_TITLE);
			//자료수정권한 부여
			MODIFY_AUTH = true;
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('CUSTOM_CODE'	, UserInfo.customCode);
			panelResult.setValue('CUSTOM_NAME'	, UserInfo.customName);
			panelResult.getField('STATUS_FLAG').setValue('1');
			
			UniAppManager.setToolbarButtons('reset', false);
			gsResetButton	= false;

			if(!Ext.isEmpty(params && params.PGM_ID)){
				if(params.PGM_ID == 'ord100ukrv') {
					var formPram = params.formPram;
					panelResult.setValue('CUSTOM_CODE'	, formPram.CUSTOM_CODE);
					panelResult.setValue('CUSTOM_NAME'	, formPram.CUSTOM_NAME);
					panelResult.setValue('DVRY_DATE_FR'	, formPram.DVRY_DATE);
					panelResult.setValue('DVRY_DATE_TO'	, formPram.DVRY_DATE);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},
		onQueryButtonDown : function(){
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			directMasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {
			gsResetButton	= true;
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		},
		onDeleteDataButtonDown: function() {
			var selRow	= masterGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)) {
				if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid.deleteSelectedRow();
					masterGrid.getSelectionModel().deselectAll();
				}
			} else {
				Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
				return false;
			}
		},
		onSaveDataButtonDown: function(config) {
			if(!panelResult.getInvalidMessage()) return;	//필수체크

			var records = masterGrid.getSelectedRecords()
			Ext.each(records, function(record, index) {
				//주문확정
				if(Ext.getCmp('statusFlag').getChecked()[0].inputValue == '1') {
					record.set('SAVE_FLAG', 'Y');
					panelResult.setValue('SAVE_FLAG', 'Y');
				//주문취소
				} else {
					record.set('SAVE_FLAG', 'N');
					panelResult.setValue('SAVE_FLAG', 'N');
				}
			});
			directMasterStore.saveStore();
		}
	});



	Unilite.createValidator('validator01', {
		store	: directMasterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ORDER_Q":
					if(newValue <= 0) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('ORDER_Q',oldValue);
						break
					}
					var digit			= UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
					var numDigitOfPrice	= UniFormat.Price.length - digit;
					var sOrderP			= record.get('ORDER_P');
					var sOrderQ			= newValue;
					var sTaxType		= record.get('TAX_TYPE');
					var sTaxInoutType	= record.get('TAX_CALC_TYPE');
					var sVatRate		= record.get('VAT_RATE');
					var dOrderAmtO		= 0;
					var dTaxAmtO		= 0;
					var dAmountI		= 0;
					var sWonCalcBas     = record.get('WON_CALC_BAS');

					if(sTaxInoutType == '1') {
						dOrderAmtO	= Unilite.multiply(sOrderP, sOrderQ);
						dTaxAmtO	= Unilite.multiply(dOrderAmtO, sVatRate) / 100;
						dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderAmtO	, '3'	, numDigitOfPrice);
						dTaxAmtO	= UniSales.fnAmtWonCalc(dTaxAmtO	, '2'	, numDigitOfPrice);
					} else if(sTaxInoutType == '2') {
						dAmountI	= Unilite.multiply(sOrderP, sOrderQ);
						dTemp		= UniSales.fnAmtWonCalc(Unilite.multiply((dAmountI / ( sVatRate + 100 )), 100), '2', numDigitOfPrice);
						dTaxAmtO	= UniSales.fnAmtWonCalc(Unilite.multiply(dTemp, sVatRate) / 100, '2', numDigitOfPrice);
						//	dOrderAmtO	= UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice) ;
							dOrderAmtO	= UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), sWonCalcBas, numDigitOfPrice) ;
					}

					
					if(sTaxType == '2') {
						//dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderO, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice);
						dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderO, sWonCalcBas, numDigitOfPrice);
						dTaxAmtO	= 0;
					}
					record.set('ORDER_O'	, dOrderAmtO);
					record.set('ORDER_TAX_O', dTaxAmtO);
					record.set('ORDER_TOT_O', dOrderAmtO + dTaxAmtO);

					//20190711 수량변경 시, 체크박스 체크로직 추가
					if(newValue != oldValue) {
						var me			= masterGrid.getSelectionModel();
						var selections	= me.getSelection();

						selections.push(record.obj);

						if (selections.length > 0) {
							me.select(selections);
						}
					}
				break;				
				case "REMARK":
					if(newValue != oldValue) {
						var me			= masterGrid.getSelectionModel();
						var selections	= me.getSelection();
						selections.push(record.obj);

						if (selections.length > 0) {
							me.select(selections);
						}
					}
				break;
				
				case  "DVRY_DATE":
					if(newValue != oldValue) {
						var me			= masterGrid.getSelectionModel();
						var selections	= me.getSelection();
						selections.push(record.obj);

						if (selections.length > 0) {
							me.select(selections);
						}
					}
				break;

				//20210319 추가
				case  "DELIV_METHOD":
				case  "RECEIVER_NAME":
				case  "ZIP_NUM":
				case  "ADDRESS1":
					if(newValue != oldValue) {
						var me			= masterGrid.getSelectionModel();
						var selections	= me.getSelection();
						selections.push(record.obj);

						if (selections.length > 0) {
							me.select(selections);
						}
					}
				break;

				case "TELEPHONE_NUM1" :
					if(!Ext.isEmpty(newValue)) {
						if(!tel_check(newValue)) {
							rv = '올바른 전화번호를 입력하세요.'
							record.set('TELEPHONE_NUM1', oldValue);
							break;
						}
					}
					if(newValue != oldValue) {
						var me			= masterGrid.getSelectionModel();
						var selections	= me.getSelection();
						selections.push(record.obj);

						if (selections.length > 0) {
							me.select(selections);
						}
					}
				break;
			}
			return rv;
		}
	});



	//20210319 추가
	function tel_check(str) {
		str = str.replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
		var regTel = /^(050[2-8]{1}|01[016789]{1}|070|02|0[3-9]{1}[0-9]{1})-[0-9]{3,4}-[0-9]{4}$/;
		if(!regTel.test(str)) {
			return false;
		}
		return true;
	}
};
</script>
