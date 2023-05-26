<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mba200rkrv_wm">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M007"/>	<!-- 승인여부 (1: 미승인, 2: 승인) -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>	<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="Z001"/>	<!-- 단가구분(H-홈페이지, C-카페, Z-기타(기본값, REF1 = 'Y')) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM01"/>	<!-- 접수구분(10:홈페이지, 20:T전화, 30:카페, 40:입찰) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM03"/>	<!-- 진행상태(A-접수, B-도착, C-분해작업중, D-분해작업완료, E-검사, F-) -->
	<t:ExtComboStore comboType="OU"/>
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >
var initFlag	= true;
var isLastMail	= false;				//메일 전송 시, 마지막 메일여부 확인
var BsaCodeInfo	= {
	sendMailAddr	: '${sendMailAddr}'	//사용자의 발신메일주소 
}

function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('INSPEC_PRSN', '');
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			validateBlank	: false,
			colspan			: 2,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					if(Ext.isEmpty(newValue)) {
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_PRSN',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'RECEIPT_DATE_FR',
			endFieldName	: 'RECEIPT_DATE_TO'
		},{
			fieldLabel	: '불량포함여부',
			xtype		: 'radiogroup',
			labelWidth	: 150,
			items		: [{
				boxLabel	: '포함',
				name		: 'rdoSelect',
				inputValue	: '1',
				width		: 70
			},{
				boxLabel	: '미포함',
				name		: 'rdoSelect',
				inputValue	: '2',
				width		: 60
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!initFlag) {
						masterGrid.down('#printBtn').disable();
						masterGrid.down('#mailSend').disable();
						directMasterStore1.loadStoreRecords(newValue.rdoSelect);
						directMasterStore2.loadStoreRecords(newValue.rdoSelect);
					}
				}
			}
		},{
			fieldLabel	: '발신메일',
			xtype		: 'uniTextfield',
			name		: 'SEND_EMAIL',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]
	});


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_mba200rkrv_wmService.selectList1'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_mba200rkrv_wmService.selectList2'
		}
	});

	Unilite.defineModel('s_mba200rkrv_wmModel1', {
		fields: [
			//S_MPO010T_WM (MASTER)
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'	, allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'	, allowBlank: false	, comboType: 'BOR120'},
			{name: 'AGREE_STATUS'	, text: '승인여부'		, type: 'string'	, comboType:'AU' , comboCode: 'M007'},
			{name: 'AGREE_DATE'		, text: '승인일'		, type: 'uniDate'},
			{name: 'AGREE_PRSN'		, text: '승인자'		, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'CUSTOM_PRSN'	, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'		, type: 'string'},
			{name: 'E_MAIL'			, text: '수신메일'		, type: 'string'},
			{name: 'ORDER_PRSN'		, text: '영업담당'		, type: 'string'	, comboType:'AU' , comboCode: 'S010'},
			{name: 'RECEIPT_DATE'	, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'		, type: 'uniDate'},
			{name: 'PRICE_TYPE'		, text: '<t:message code="system.label.common.priceclass" default="단가구분"/>'			, type: 'string'	, comboType:'AU' , comboCode: 'Z001'},
			//S_MPO020T_WM (DETAIL)
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.unit" default="단위"/>'				, type: 'string'},
			{name: 'RECEIPT_NUM'	, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'		, type: 'string'},
			{name: 'RECEIPT_SEQ'	, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'		, type: 'int'}
		]
	});

	Unilite.defineModel('s_mba200rkrv_wmModel2', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'	, type: 'string', allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string', allowBlank: false},
			{name: 'INSPEC_NUM'		, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'		, type: 'string'},
			{name: 'INSPEC_SEQ'		, text: '<t:message code="system.label.purchase.seq" default="순번"/>'			, type: 'int'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'			, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.unit" default="단위"/>'			, type: 'string'},
			{name: 'GOOD_INSPEC_Q'	, text: '양품수량'		, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q'	, text: '불량수량'		, type: 'uniQty'},
			{name: 'RECEIPT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'			, type: 'uniUnitPrice'},
			{name: 'RECEIPT_O'		, text: '<t:message code="system.label.purchase.amount" default="금액"/>'			, type: 'uniPrice'},
			{name: 'RECEIPT_NUM'	, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'	, type: 'string'},
			{name: 'RECEIPT_SEQ'	, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'	, type: 'int'},
			{name: 'CONFIRM_YN'		, text: '단가확정여부'	, type: 'string'},
			{name: 'CONFIRM_DATE'	, text: '단가확정일'		, type: 'uniDate'},
			{name: 'CONFIRM_PRSN'	, text: '단가확정자'		, type: 'string'},
			{name: 'RECEIPT_DATE'	, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'	, type: 'uniDate'},
			{name: 'CONFIRM_YN'		, text: '확정여부'		, type: 'string'	, comboType:'AU' , comboCode:'P401'}
		]
	});

	var directMasterStore1 = Unilite.createStore('s_mba200rkrv_wmMasterStore1', {
		model	: 's_mba200rkrv_wmModel1',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(newValue){
			var param = panelResult.getValues();
			if(newValue || newValue == '') {
				param.rdoSelect = newValue;
			}
			console.log(param);
			this.load({
				params : param
			});
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

	var directMasterStore2 = Unilite.createStore('s_mba200rkrv_wmMasterStore2', {
		model	: 's_mba200rkrv_wmModel2',
		proxy	: directProxy2,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(newValue){
			var param = panelResult.getValues();
			if(newValue || newValue == '') {
				param.rdoSelect = newValue;
			}
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				directMasterStore2.filterBy(function(record){
					return record.get('RECEIPT_NUM') == 'ZZZZZ';
				})
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	var masterGrid = Unilite.createGrid('s_mba200rkrv_wmGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			useLiveSearch		: true,
			expandLastColumn	: true,
			useRowNumberer		: false
		},
		tbar: [{
			itemId	: 'printBtn',
			text	: '<div style="color: blue">견적서 출력</div>',
			width	: 100,
			handler	: function() {
				if(!panelResult.getInvalidMessage()){
					return false;
				}
				//출력할 데이터를 찾기 위한 기준데이터 생성
				var selectedMasters	= masterGrid.getSelectedRecords();
				var receipInfo;
				Ext.each(selectedMasters, function(record, idx) {
					if(idx ==0) {
						receipInfo = record.get('RECEIPT_NUM') + '/' + record.get('RECEIPT_SEQ');
					} else {
						receipInfo = receipInfo + ',' + record.get('RECEIPT_NUM') + '/' + record.get('RECEIPT_SEQ');
					}
				});

				var param			= panelResult.getValues();
				param.PGM_ID		= 's_mba200rkrv_wm';
				param.MAIN_CODE		= 'Z012';
				param.dataCount		= selectedMasters.length;
				param.receipInfo	= receipInfo;

				var win = Ext.create('widget.ClipReport', {
					url			: CPATH+'/z_wm/s_mba200clrkrv_wm.do',
					prgID		: 's_mba200rkrv_wm',
					extParam	: param,
					submitType	: 'POST'
				});
				win.center();
				win.show();
			}
		},{
			itemId	: 'mailSend',
			text	: '<div style="color: blue"><t:message code="system.label.purchase.mailsend" default="메일전송"/></div>',
			width	: 100,
			handler	: function() {
				var records = masterGrid.getSelectionModel().getSelection();
				if(Ext.isEmpty(records)) {
					Unilite.messageBox('선택된 데이터가 없습니다.');
					return false;
				}
				var errCnt		= 0;
				var data		= new Object();
				data.records	= {};
				data.info		= [];
				Ext.each(records, function(rec, i){
					if(Ext.isEmpty(rec.get('E_MAIL'))){						//이메일 등록여부 확인
						errCnt++;
					}
				});
				if(errCnt != 0) {
					Unilite.messageBox('메일 주소가 누락 되었습니다.');
					return false;
				}
				Ext.getCmp('s_mba200rkrv_wmApp').getEl().mask('이메일 전송 중...','loading-indicator');
				//메일 전송을 위한 데이터 정제
				Ext.each(records, function(rec, i){
					if(Ext.isEmpty(data.records[rec.data.RECEIPT_NUM])) {
						//data.records.push(record);
						data.records[rec.data.RECEIPT_NUM]	= '';
						data.records[rec.data.RECI_EMAIL]	= '';
						data.records[rec.data.CUSTOM_NM]	= '';
					}
					if(data.records[rec.data.RECEIPT_NUM] == '') {
						data.records[rec.data.RECEIPT_NUM]	= rec.data.RECEIPT_NUM + '/' + rec.data.RECEIPT_SEQ;
						data.records[rec.data.RECI_EMAIL]	= rec.data.E_MAIL;
						data.records[rec.data.CUSTOM_PRSN]	= rec.data.CUSTOM_PRSN;
						data.info.push({
							'KEY'			: rec.data.RECEIPT_NUM,
							'RECEIPT_INFO'	: data.records[rec.data.RECEIPT_NUM],
							'RECI_EMAIL'	: data.records[rec.data.RECI_EMAIL],
							'CUSTOM_NM'		: data.records[rec.data.CUSTOM_PRSN]
						});
					} else {
						data.records[rec.data.RECEIPT_NUM] = data.records[rec.data.RECEIPT_NUM] + ','+ rec.data.RECEIPT_NUM + '/' + rec.data.RECEIPT_SEQ;
						Ext.each(data.info, function(record2, i){
							if(record2.KEY == rec.data.RECEIPT_NUM) {
								record2.RECEIPT_INFO= data.records[rec.data.RECEIPT_NUM];
							}
						});
					}
				});
				//메일 전송 데이터 생성 및 전송
				Ext.each(data.info, function(rec, i){
					if(data.info.length == i + 1){
						isLastMail = true;
					}
					UniAppManager.app.makeContents(rec);
				});
			}
		}, '-'],
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var records = directMasterStore1.data.items;
					data = new Object();
					data.records = [];
					Ext.each(records, function(record, i){
						if(selectRecord.get('RECEIPT_NUM') == record.get('RECEIPT_NUM') || masterGrid.getSelectionModel().isSelected(record) == true) {
							data.records.push(record);
						}
					});
					masterGrid.getSelectionModel().select(data.records);
					masterGrid.down('#printBtn').enable();
					masterGrid.down('#mailSend').enable();
				},
				deselect: function(grid, selectRecord, index, eOpts ){
					var records = directMasterStore1.data.items;
					data = new Object();
					data.records = [];
					Ext.each(records, function(record, i){
						if(selectRecord.get('RECEIPT_NUM') == record.get('RECEIPT_NUM')) {
							data.records.push(record);
						}
					});
					masterGrid.getSelectionModel().deselect(data.records);

					if (this.selected.getCount() == 0) {
						masterGrid.down('#printBtn').disable();
						masterGrid.down('#mailSend').disable();
						directMasterStore2.clearFilter();
						directMasterStore2.filterBy(function(record){
							return record.get('RECEIPT_NUM') == 'ZZZZZ';
						})
					}
				}
			}
		}),
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'AGREE_STATUS'		, width: 80	, hidden: true},
//			{dataIndex: 'CUSTOM_CODE'		, width: 100},
			{dataIndex: 'CUSTOM_NAME'		, width: 150},
			{dataIndex: 'CUSTOM_PRSN'		, width: 120},
			{dataIndex: 'RECEIPT_DATE'		, width: 80},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'ORDER_UNIT'		, width: 80	, align:'center'},
			{dataIndex: 'PRICE_TYPE'		, width: 100, align:'center'},
			{dataIndex: 'E_MAIL'			, width: 200},
			{dataIndex: 'ORDER_PRSN'		, width: 120},
			{dataIndex: 'RECEIPT_NUM'		, width: 120},
			{dataIndex: 'RECEIPT_SEQ'		, width: 80	, align:'center'},
			{dataIndex: 'CONFIRM_YN'		, width: 100, hidden: true},
			{dataIndex: 'AGREE_DATE'		, width: 100, hidden: true},
			{dataIndex: 'AGREE_PRSN'		, width: 100, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.field=='E_MAIL') {
					return true;
				} else {
					return false;
				}
			},
			selectionchange: function( grid, selected, eOpts ){
				directMasterStore2.clearFilter();
				//선택된 행의 저장된 데이터만 detailGrid에 보여주도록 filter
				if(selected && selected[0]) {
					directMasterStore2.filterBy(function(record){
						return record.get('RECEIPT_NUM') == selected[0].get('RECEIPT_NUM')
							&& record.get('RECEIPT_SEQ') == selected[0].get('RECEIPT_SEQ');
					})
				} else {
					directMasterStore2.filterBy(function(record){
						return record.get('RECEIPT_NUM') == 'ZZZZZ';
					})
				}
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ){
				directMasterStore2.clearFilter();
				//선택된 행의 저장된 데이터만 detailGrid에 보여주도록 filter
				if(thisRecord) {
					directMasterStore2.filterBy(function(record){
						return record.get('RECEIPT_NUM') == thisRecord.get('RECEIPT_NUM')
							&& record.get('RECEIPT_SEQ') == thisRecord.get('RECEIPT_SEQ');
					})
				}
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('s_mba200rkrv_wmGrid2', {
		store	: directMasterStore2,
		layout	: 'fit',
		region	: 'south',
		uniOpt	: {
			useLiveSearch	: true,
			expandLastColumn: true
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'INSPEC_NUM'	, width: 120, hidden: true},
			{dataIndex: 'INSPEC_SEQ'	, width: 66	, hidden: true, align:'center'},
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 150},
			{dataIndex: 'SPEC'			, width: 150},
			{dataIndex: 'ORDER_UNIT'	, width: 80	, align:'center'},
			{dataIndex: 'GOOD_INSPEC_Q'	, width: 100},
			{dataIndex: 'BAD_INSPEC_Q'	, width: 100},
			{dataIndex: 'RECEIPT_P'		, width: 100},
			{dataIndex: 'RECEIPT_O'		, width: 100},
			{dataIndex: 'RECEIPT_NUM'	, width: 120, hidden: true}
		],
		listeners: {
		}
	});



	Unilite.Main({
		id			: 's_mba200rkrv_wmApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, masterGrid2, panelResult
			]
		}],
		fnInitBinding : function() {
			initFlag = true;
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('RECEIPT_DATE_TO'	, UniDate.get('today'));
			panelResult.setValue('RECEIPT_DATE_FR'	, UniDate.add(panelResult.getValue('RECEIPT_DATE_TO'), {weeks: -1}));
			panelResult.setValue('SEND_EMAIL'		, BsaCodeInfo.sendMailAddr);
			panelResult.setValue('rdoSelect'		, '1');
			masterGrid.down('#printBtn').disable();
			masterGrid.down('#mailSend').disable();
			UniAppManager.setToolbarButtons(['reset'], true);
			initFlag = false;
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) {
				return false;
			}
			masterGrid.down('#printBtn').disable();
			masterGrid.down('#mailSend').disable();
			masterGrid2.getStore().loadData({});
			directMasterStore1.loadStoreRecords();
			directMasterStore2.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			directMasterStore1.loadData({});
			directMasterStore2.loadData({});
			this.fnInitBinding();
		},
		//메일전송 로직
		makeContents: function(masterRec) {
			var param			= panelResult.getValues();
			param.SUBJECT		= '견적서 보내드립니다.';
			param.CONTENTS		= '견적서를 첨부파일로 보내드립니다. 감사합니다.';
			param.receipInfo	= masterRec.RECEIPT_INFO;
			param.RECI_EMAIL	= masterRec.RECI_EMAIL;
			param.CUSTOM_NM		= masterRec.CUSTOM_NM;
			param.PGM_ID		= 's_mba200rkrv_wm';
			param.MAIN_CODE		= 'Z012';
			s_mba200rkrv_wmService.sendMail(param, function(provider, response) {
				if(provider){
					if(provider.STATUS == "1"){
						if(isLastMail){
							UniAppManager.updateStatus('<t:message code="system.message.purchase.message063" default="메일이 전송 되었습니다."/>');
						}
					}else{
						Unilite.messageBox('<t:message code="system.message.purchase.message062" default="메일 전송중 오류가 발생하였습니다. 관리자에게 문의 바랍니다."/>');
					}
					if(isLastMail) {
						Ext.getCmp('s_mba200rkrv_wmApp').getEl().unmask();
						isLastMail = false;
					}
				}
			});
		}
	});



	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			switch(fieldName) {
					case 'E_MAIL' :
						var mRecords = directMasterStore1.data.items;
						Ext.each(mRecords, function(mRecord, idx) {
							if(record.get('RECEIPT_NUM') == mRecord.get('RECEIPT_NUM')) {
								mRecord.set('E_MAIL', newValue);
							}
						});
						directMasterStore1.commitChanges();
					break;
			}
			return rv;
		}
	});
};
</script>