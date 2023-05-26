<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr210ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />	<!-- 창고 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />	<!-- 작업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />				<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B035"/>				<!-- 수불타입 -->
		<t:ExtComboStore comboType="OU" />										<!-- 창고-->
		<t:ExtComboStore comboType="WU" />        <!-- 작업장-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsManageLotNoYN: '${gsManageLotNoYN}',	 // 작업지시와 생산실적 LOT 연계여부 설정 값 
	gsChkProdtDateYN: '${gsChkProdtDateYN}',// 착수예정일 체크여부
	glEndRate: '${glEndRate}',
	gsSumTypeCell: '${gsSumTypeCell}'		  // 재고합산유형 : 창고 Cell 합산
	
};
/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/



var outDivCode = UserInfo.divCode;

function appMain() {	 

var alertWindow;			//alertWindow : 경고창
var gsText			= ''	//바코드 알람 팝업 메세지

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'pmr210ukrvService.selectDetailList',
			update	: 'pmr210ukrvService.updateDetail',
			create	: 'pmr210ukrvService.insertDetail',
			destroy	: 'pmr210ukrvService.deleteDetail',
			syncAll	: 'pmr210ukrvService.saveAll'
		}
	});



	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			holdable	: 'hold',
			value		: outDivCode,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			holdable	: 'hold',
			comboType: 'WU',
	 		allowBlank	: false,
	 		listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(newValue)) {
						var param = {
							WORK_SHOP_CODE : newValue
						}
						pmr210ukrvService.getWhCode(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								panelResult.setValue('WH_CODE', provider[0].WH_CODE);
							} else {
								panelResult.setValue('WH_CODE', '');
							}
						});
						panelResult.getField('REF_WKORD_NUM').focus();
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
			xtype		: 'uniDatefield',
			name		: 'INOUT_DATE',
	   		value		: UniDate.get('today'),
			holdable	: 'hold',
			colspan		: 3,
	 		allowBlank	: false
		},{
			fieldLabel	: '<t:message code="system.label.product.issuewarehouse" default="출고창고"/>',
			name		: 'WH_CODE', 
			xtype		: 'uniCombobox', 
			comboType   : 'OU',
			holdable	: 'hold',
	 		allowBlank	: false
		},{
	 		fieldLabel	: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
	 		xtype		: 'uniTextfield',
	 		name		: 'REF_WKORD_NUM',
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						if(!panelResult.getInvalidMessage()) return false;
						var newValue = panelResult.getValue('REF_WKORD_NUM');
						if(!Ext.isEmpty(newValue)) {
							detailGrid.focus();
							fnGetOutstockData(newValue);
//							panelResult.setValue('REF_WKORD_NUM', '');
						}
					}
				}
			}
		},{
	 		fieldLabel	: '<t:message code="system.label.product.lotno" default="LOT번호"/>',
	 		xtype		: 'uniTextfield',
	 		name		: 'BARCODE',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						if(!panelResult.getInvalidMessage()) return false;
						var newValue = panelResult.getValue('BARCODE');
						if(!Ext.isEmpty(newValue)) {
							detailGrid.focus();
							fnEnterBarcode(newValue);
							panelResult.setValue('BARCODE', '');
						}
					}
				}
			}
		},{
			xtype	: 'component',
			width	: 80
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.product.labelprint" default="라벨출력"/>',
			id		: 'btnPrint',
			width	: 80,
			handler	: function() {
			}
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
					alert(labelText+Msg.sMB083);
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
	
	
	
	Unilite.defineModel('pmr210ukrvDetailModel', {
		fields: [
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.companycode" default="법인코드"/>'				,type:'string'},
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'				,type:'string'},
			{name: 'OUTSTOCK_NUM'	,text: '<t:message code="system.label.product.issuerequestno" default="출고요청번호"/>'				,type:'string'},
			{name: 'REF_WKORD_NUM'	,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'				,type:'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.product.itemcode" default="품목코드"/>'				,type:'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type:'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.product.spec" default="규격"/>'					,type:'string'},
			{name: 'STOCK_UNIT'		,text: '<t:message code="system.label.product.unit" default="단위"/>'					,type:'string' , comboType:'AU', comboCode:'B013'},
			{name: 'PATH_CODE'		,text: '자재 BOM Path Code'	,type:'uniQty'},
			{name: 'INOUT_NUM'		,text: '<t:message code="system.label.product.tranno" default="수불번호"/>'				,type:'string'},
			{name: 'INOUT_SEQ'		,text: '<t:message code="system.label.product.transeq" default="수불순번"/>'				,type:'string'},
			{name: 'INOUT_DATE'		,text: '<t:message code="system.label.product.transdate" default="수불일"/>'				,type:'uniDate'},
			{name: 'INOUT_TYPE'		,text: '<t:message code="system.label.product.trantype1" default="수불타입"/>'				,type:'string'},

			{name: 'OUTSTOCK_REQ_Q'	,text: '<t:message code="system.label.product.issuerequestqty" default="출고요청량"/>'				,type:'uniQty'},
			{name: 'LOT_NO'			,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			,type:'string', allowBlank: false},
			{name: 'OUTSTOCK_Q'		,text: '<t:message code="system.label.product.issueqty" default="출고량"/>'				,type:'uniQty', allowBlank: false},
			{name: 'WH_CODE'		,text: '<t:message code="system.label.product.issuewarehouse" default="출고창고"/>'				,type:'string' ,comboType   : 'OU'},
			{name: 'REMAIN_Q'		,text: '<t:message code="system.label.product.balanceqty" default="잔량"/>'					,type:'uniQty'},
			{name: 'REMARK'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'					,type:'string'},
			{name: 'PROJECT_NO'		,text: 'Project No.'		,type:'string'},
			{name: 'PJT_CODE'		,text: '<t:message code="system.label.product.projectcode" default="프로젝트코드"/>'				,type:'string'},
			
			{name: 'PRODT_INOUT_NUM',text: 'PRODT_INOUT_NUM'	,type:'string'},
			{name: 'PRODT_INOUT_SEQ',text: 'PRODT_INOUT_SEQ'	,type:'string'},
			{name: 'QUERY_YN'		,text: 'QUERY_YN'			,type:'string'}
		]
	});
	
	var detailStore = Unilite.createStore('pmr210ukrvDetailStore', {
		model: 'pmr210ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
//		saveStore : function()	{},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)) {
					panelResult.setAllFieldsReadOnly(true);
					
					UniAppManager.setToolbarButtons(['newData', 'delete'], false);
				} else {
					UniAppManager.app.onResetButtonDown();
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				
				UniAppManager.setToolbarButtons('save', false);	
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});
	
	/** detail Grid1 정의(Grid Panel)
	 * @type 
	 */
	var detailGrid = Unilite.createGrid('pmr210ukrvGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			onLoadSelectFirst	: false,
			useRowNumberer		: false
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick: false,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if (this.selected.getCount() > 0) {
						Ext.getCmp('btnPrint').enable();
//						selectRecord.set('QUERY_YN', 'Y');
//						UniAppManager.setToolbarButtons('save', true);
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var toDelete = detailStore.getRemovedRecords();
//					selectRecord.set('QUERY_YN', '');
					if (/*toDelete.length == 0 && */this.selected.getCount() == 0) {
//						UniAppManager.setToolbarButtons('save', false);
						Ext.getCmp('btnPrint').disable();
					}
				}
			}
		}),
		columns	: [
			{dataIndex: 'COMP_CODE'			, width: 100		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100		, hidden: true},
			{dataIndex: 'OUTSTOCK_NUM'		, width: 120		, hidden: true},
			{dataIndex: 'REF_WKORD_NUM'		, width: 120},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 170},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'STOCK_UNIT'		, width: 80 },
			{dataIndex: 'PATH_CODE'			, width: 100		, hidden: true},
			{dataIndex: 'INOUT_NUM'			, width: 100		, hidden: true},
			{dataIndex: 'INOUT_SEQ'			, width: 100		, hidden: true},
			{dataIndex: 'INOUT_DATE'		, width: 100		, hidden: true},
			{dataIndex: 'INOUT_TYPE'		, width: 100		, hidden: true},

			{dataIndex: 'OUTSTOCK_REQ_Q'	, width: 100},
			{dataIndex: 'LOT_NO'			, width: 100},
			{dataIndex: 'OUTSTOCK_Q'		, width: 100},
			{dataIndex: 'WH_CODE'			, width: 100},
			{dataIndex: 'REMAIN_Q'			, width: 100},
			{dataIndex: 'REMARK'			, width: 100		, hidden: false},
			{dataIndex: 'PROJECT_NO'		, width: 100		, hidden: true},
			{dataIndex: 'PJT_CODE'			, width: 100		, hidden: true},
			
			{dataIndex: 'PRODT_INOUT_NUM'	, width: 100		, hidden: true},
			{dataIndex: 'PRODT_INOUT_SEQ'	, width: 100		, hidden: true},
			{dataIndex: 'QUERY_YN'			, width: 100		, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false || e.record.get('QUERY_YN') == 'Y') {
					if(UniUtils.indexOf(e.field, ['OUTSTOCK_Q'])/* && e.record.get('REMAIN_Q') > 0*/) {
						return true;
					}
					return false;
					
				} else {
//					if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'LOT_NO', 'REMARK', 'OUTSTOCK_Q'])) {
//						return true;
//					}
					return false;
				}
			}
		}
	});
	
	
	
	Unilite.Main( {
		id			: 'pmr210ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				detailGrid,  panelResult
			]	
		}],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons('save', false);	
			this.setDefault();
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
			Ext.getCmp('btnPrint').disable();
			
			detailStore.loadStoreRecords();
			panelResult.setAllFieldsReadOnly(true);
		},
		onNewDataButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
			records = detailStore.data.items;
			var r = {
				COMP_CODE		: UserInfo.compCode,
				DIV_CODE		: outDivCode, 
				OUTSTOCK_NUM	: records[0].get('OUTSTOCK_NUM'),
				REF_WKORD_NUM	: panelResult.getValue('REF_WKORD_NUM'),
				PATH_CODE		: records[0].get('PATH_CODE')
			};
			detailGrid.createRow(r);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {		// 새로고침 버튼
			this.suspendEvents();
			panelResult.clearForm();
			
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			this.fnInitBinding();
			detailStore.clearData();
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				detailGrid.deleteSelectedRow();
				var deSelect = detailGrid.getSelectedRecords();
				detailGrid.getSelectionModel().deselect(deSelect);
			}
		},
//		onSaveDataButtonDown: function(config) {
//			detailStore.saveStore();
//		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'		, outDivCode);
			panelResult.setValue('INOUT_DATE'	, UniDate.get('today'));
			Ext.getCmp('btnPrint').disable();
			
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);	
		}
	});
	
	
	
	/** 작업지시번호 바코드 입력 시
	 */
	function fnGetOutstockData(newValue) {
		panelResult.setAllFieldsReadOnly(true);
		var flag = true;
		//동일한 작업지시번호 입력여부 확인
		var records  = detailStore.data.items;		//비교할 records 구성
		Ext.each(records, function(record, i) {
			if(record.get('REF_WKORD_NUM') == newValue) {
				beep();
				gsText = '<t:message code="system.message.product.message001" default="동일한 작업지시번호(이)가 이미 등록되었습니다."/>';
				openAlertWindow(gsText);
				flag = false;
				return false;
			}
		});
		
		if(flag) {
			//PMP350T에서 OUTSTOCK_Q - PRODT_Q > 인 데이터 조회
			var param = {
				DIV_CODE		: panelResult.getValue('DIV_CODE'),
				WORK_SHOP_CODE	: panelResult.getValue('WORK_SHOP_CODE'),
				REF_WKORD_NUM	: newValue
			}
			pmr210ukrvService.getOutstockData(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					Ext.each(provider, function(outStockInfo, i) {
//						outStockInfo.phantom = true;
						outStockInfo.WH_CODE = panelResult.getValue('WH_CODE')
						detailStore.insert(i, outStockInfo);
						detailStore.commitChanges();
						UniAppManager.setToolbarButtons('save', false);
					});
				} else {
					beep();
					gsText = '<t:message code="system.message.product.message002" default="입력하신 작업지시번호의 데이터가 존재하지 않습니다.."/>';
					openAlertWindow(gsText);
					Ext.getBody().unmask();
					panelResult.setValue('REF_WKORD_NUM', '');
					panelResult.getField('REF_WKORD_NUM').focus();
					panelResult.setAllFieldsReadOnly(false);
					return false;
				}
				
				panelResult.getField('BARCODE').focus();
			});
		}
	}
	
	
	
	/** LOT_NO 바코드 입력 시
	 */
	function fnEnterBarcode(newValue) {
		var needSelect		= Ext.isEmpty(detailGrid.getSelectedRecords())? [] : detailGrid.getSelectedRecords();
		var barcodeItemCode	= newValue.split('|')[0].toUpperCase();
		var barcodeLotNo	= newValue.split('|')[1];
		var barcodeInoutQ	= newValue.split('|')[2];
		var count			= 0;
		
		if(!Ext.isEmpty(barcodeLotNo)) {
			barcodeLotNo = barcodeLotNo.toUpperCase();
		}

		var param = {
			ITEM_CODE		: barcodeItemCode,
			LOT_NO			: barcodeLotNo,
			WH_CODE			: panelResult.getValue('WH_CODE'),
			DIV_CODE		: panelResult.getValue('DIV_CODE'),
			GSFIFO			: 'N'
		}
		str105ukrvService.getFifo(param, function(provider, response){
			if(!Ext.isEmpty(provider)){
				if(!Ext.isEmpty(provider[0].ERR_MSG)) {
					beep();
					gsText = provider[0].ERR_MSG;
					openAlertWindow(gsText);
					panelResult.getField('BARCODE').focus();
					return false;
					
				} else {
					//동일한 LOT_NO 존재여부 확인하여 체크하는 로직
					var records = detailStore.data.items;		//비교할 records 구성
					Ext.each(records, function(record, i) {
						if(record.get('ITEM_CODE').toUpperCase() == barcodeItemCode && record.get('LOT_NO').toUpperCase() == barcodeLotNo) {
							var outstockQ = barcodeInoutQ;
							if(record.get('REMAIN_Q') == 0) {
								beep();
								gsText = '<t:message code="system.message.product.message003" default="동일한 품목이 입력 되었습니다."/>';
								openAlertWindow(gsText);
								panelResult.getField('BARCODE').focus();
								count++;
							} else {
								var remainQ = record.get('REMAIN_Q') - parseInt(outstockQ);
								if(remainQ < 0) {
									remainQ = 0;
								}
								record.set('OUTSTOCK_Q'	, parseInt(outstockQ));
								record.set('REMAIN_Q'	, remainQ);
								count++;
							}
							var sm = detailGrid.getSelectionModel();
							var selRecords = detailGrid.getSelectionModel().getSelection();
							selRecords.push(record);
							sm.select(selRecords);
							panelResult.getField('BARCODE').focus();
						}
					});
		
					if(count == 0) {
						beep();
						gsText = '<t:message code="system.label.sales.message004" default="입력한 품목의 작업지시 정보가 없습니다."/>';
						openAlertWindow(gsText);
						panelResult.getField('BARCODE').focus();
						return false;
					}
				}
			}
		});
	}
	


	//경고창
	var alertSearch = Unilite.createSearchForm('alertSearch', {
		layout	: {type : 'uniTable', columns : 1
		, tdAttrs: {width: '100%', align : 'center', style: 'background-color: #dfe8f6;'}		//cfd9e7
		},
		items	:[{
			xtype	: 'component',
			itemId	: 'TEXT_TEST',
			width	: 330,
			height	: 50,
			html	: '',
			style	: {
				marginTop	: '3px !important',
				font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
            }
		},{
			xtype	: 'container',
			padding	: '0 0 0 0',
			align	: 'center',
			items	: [{
				xtype	: 'button',
				text	: '확인',
				width	: 80,
				handler	: function() {
					alertWindow.hide();
				},
				disabled: false
			}]
		}]
	}); 
	function openAlertWindow() {
		if(!alertWindow) {
			alertWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.product.warntitle" default="경고"/>',
				width	: 350,
				height	: 120,
				layout	: {type:'vbox', align:'stretch'},
				items	: [alertSearch],
				listeners : {
					beforehide: function(me, eOpt) {
						alertSearch.clearForm();
					},
					beforeclose: function( panel, eOpts ) {
						alertSearch.clearForm();
					},
					beforeshow: function( panel, eOpts ) {
						alertSearch.down('#TEXT_TEST').setHtml(gsText);
					}/*,
					specialkey:function(field, event)	{
						if(event.getKey() == event.ENTER) {
							beep();
						}
					}*/
				}		
			})
		}
		alertWindow.center();
		alertWindow.show();
	}

	
	

	
	
	function beep() {
		audioCtx = new(window.AudioContext || window.webkitAudioContext)();
	
		var oscillator = audioCtx.createOscillator();
		var gainNode = audioCtx.createGain();
	
		oscillator.connect(gainNode);
		gainNode.connect(audioCtx.destination);
	
		gainNode.gain.value = 0.1;				//VOLUME 크기
		oscillator.frequency.value = 4100;
		oscillator.type = 'sine';				//sine, square, sawtooth, triangle
	
		oscillator.start();
	
		setTimeout(
			function() {
			  oscillator.stop();
			},
			1000									//길이
		);
	};

	
	
	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "OUTSTOCK_Q" :	// 생산량
					if(newValue < '0') {
						rv= Msg.sMB076;	
						break;
					}
					record.set('REMAIN_Q', record.get('REMAIN_Q') - newValue + oldValue);
				break;
			}
			return rv;
		}
	}); // validator
}
</script>