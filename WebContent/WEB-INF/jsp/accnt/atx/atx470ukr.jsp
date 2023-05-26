<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx470ukr">
	<t:ExtComboStore comboType="BOR120"/>			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">

var getTaxBase		= '${getTaxBase}';
var getAppNum		= '${getAppNum}';
var getCompanyNum	= '${getCompanyNum}';
var gsGridFlag		= false;				//20200722 추가: form validator 정상동작 하지 않아 로직 변경하면서 추가

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'atx470ukrService.selectList',
			update	: 'atx470ukrService.updateDetail',
			create	: 'atx470ukrService.insertDetail',
			destroy	: 'atx470ukrService.deleteDetail',
			syncAll	: 'atx470ukrService.saveAll'
		}
	});

	/** Model 정의 
	 * @type
	 */
	Unilite.defineModel('atx470ukrModel', {
		fields: [
			{name: 'COMP_CODE'			,text: '법인코드'				,type: 'string'	,allowBlank: false},
			{name: 'FR_PUB_DATE'		,text: '신고기간FR'				,type: 'string'	,allowBlank: false},
			{name: 'TO_PUB_DATE'		,text: '신고기간TO'				,type: 'string'	,allowBlank: false},
			{name: 'DIV_CODE'			,text: '사업장명'				,type: 'string'	,allowBlank: false, comboType: 'BOR120'},
			{name: 'ADDR'				,text: '사업장 소재지'			,type: 'string'	,allowBlank: false},
			{name: 'AMT_S1'				,text: '매출과표</br>(과세)'		,type: 'uniPrice', style: {textAlign: 'center'}},
			{name: 'TAX_S1'				,text: '매출세액</br>(과세)'		,type: 'uniPrice', style: {textAlign: 'center'}},
			{name: 'AMT_S2'				,text: '매출과표</br>(영세)'		,type: 'uniPrice', style: {textAlign: 'center'}},
			{name: 'SUM_TAX_SALES'		,text: '매출세액</br>합계'		,type: 'uniPrice', style: {textAlign: 'center'}},
			{name: 'AMT_P1'				,text: '매입과표</br>(과세)'		,type: 'uniPrice', style: {textAlign: 'center'}},
			{name: 'TAX_P1'				,text: '매입세액</br>(과세)'		,type: 'uniPrice', style: {textAlign: 'center'}},
			{name: 'AMT_P2'				,text: '매입과표</br>(의제등)'		,type: 'uniPrice', style: {textAlign: 'center'}},
			{name: 'TAX_P2'				,text: '매입세액</br>(의제등)'		,type: 'uniPrice', style: {textAlign: 'center'}},
			{name: 'SUM_TAX_PURCHASE'	,text: '매입세액</br>합계'		,type: 'uniPrice', style: {textAlign: 'center'}},
			{name: 'AMT_T1'				,text: '가산세'				,type: 'uniPrice'},
			{name: 'AMT_T2'				,text: '공제세액'				,type: 'uniPrice'},
			{name: 'SUM_TAX_REFUND'		,text: '납부세액</br>(환급세액)'	,type: 'uniPrice', style: {textAlign: 'center'}},
			{name: 'AMT_I1'				,text: '내부거래</br>(반출액)'		,type: 'uniPrice', style: {textAlign: 'center'}},
			{name: 'AMT_I2'				,text: '내부거래</br>(반입액)'		,type: 'uniPrice', style: {textAlign: 'center'}},
			{name: 'REMARK1'			,text: '비고'					,type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('atx470ukrMasterStore1',{
		model	: 'atx470ukrModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function() {
			var param			= Ext.getCmp('resultForm').getValues();
			param.FR_PUB_DATE	= panelResult.getField('FR_PUB_DATE').getStartDate();
			param.TO_PUB_DATE	= panelResult.getField('TO_PUB_DATE').getEndDate();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				var paramMaster			= panelResult.getValues();
				paramMaster.FR_PUB_DATE	= panelResult.getField('FR_PUB_DATE').getStartDate();
				paramMaster.TO_PUB_DATE	= panelResult.getField('TO_PUB_DATE').getEndDate();

				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						panelResult.setValue('RE_REFERENCE','');
						directMasterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				//20200722 추가: form validator 정상동작 하지 않아 로직 변경
				if(gsGridFlag) {
					UniAppManager.app.setSumDetailFormValue(record);
				}
				gsGridFlag = true;
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				console.log("onStoreLoad");
				if(records) {
					if(records.length > 0) {
						detailForm.enable(true);
						if(records[0].data.SAVE_FLAG == 'N'){
							masterGrid.reset();
							directMasterStore.clearData();
							Ext.each(records, function(record,i){
								UniAppManager.app.onNewDataButtonDown();
								masterGrid.setNewDataATX100T(record.data);
							});
							detailForm.setActiveRecord(records[0]);
							panelResult.setValue('RE_REFERENCE_SAVE', 'Y');
							UniAppManager.setToolbarButtons('save', true);
						} else{
							panelResult.setValue('RE_REFERENCE_SAVE', '');
						}
						//'건이 조회되었습니다.';
						var msg = records.length + Msg.sMB001;
						UniAppManager.updateStatus(msg, true);
					}
				}
			}
		}
	});

	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5,
			tableAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width: '100%'},
			tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/align : 'left'}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{ 
			fieldLabel		: '신고기간',
			xtype			: 'uniMonthRangefield',
			startFieldName	: 'FR_PUB_DATE',
			endFieldName	: 'TO_PUB_DATE',
			startDD			: 'first',
			endDD			: 'last',
			holdable		: 'hold',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},{
			xtype		: 'button',
			text		: '재참조',
			width		: 100,
			margin		: '0 0 0 0',
			tableAttrs	: {width: '100%'},
			tdAttrs		: {align : 'right'},
			handler		: function() {
				if(!UniAppManager.app.checkForNewDetail()){
					return false;
				} else{
					var param = {"FR_PUB_DATE": panelResult.getField('FR_PUB_DATE').getStartDate(),
						"TO_PUB_DATE": panelResult.getField('TO_PUB_DATE').getEndDate()
					};
					atx470ukrService.dataCheck(param, function(provider, response) {
						if(!Ext.isEmpty(provider)){
							if(confirm('이미 데이터가 존재합니다. 다시 생성하시면 기존 데이터가 삭제됩니다. 그래도 생성하시겠습니까?')) {
								panelResult.setValue('RE_REFERENCE','Y');
								UniAppManager.app.onQueryButtonDown();
								panelResult.setValue('RE_REFERENCE', '');
								UniAppManager.setToolbarButtons('save', true);
							} else{
								return false;
							}
						} else{
							panelResult.setValue('RE_REFERENCE','Y');
							UniAppManager.app.onQueryButtonDown();
							panelResult.setValue('RE_REFERENCE', '');
							UniAppManager.setToolbarButtons('save', true);
						}
					});
				}
			}
		},{
			xtype		: 'button',
			text		: '출력',
			width		: 100,
			margin		: '0 0 0 0',
			tableAttrs	: {width: '100%'},
			tdAttrs		: {align : 'left'},
			handler		: function() {
				var param = {
					'PGM_ID'		: 'atx470ukr',
					'MAIN_CODE'		: 'A126',
					'FR_PUB_DATE'	: panelResult.getField('FR_PUB_DATE').getStartDate(),
					'TO_PUB_DATE'	: panelResult.getField('TO_PUB_DATE').getEndDate()
				};
				var win = Ext.create('widget.ClipReport', {
					url		: CPATH+'/accnt/atx470clukr.do',
					prgID	: 'atx470ukr',
					extParam: param
				});
				win.center();
				win.show();
			}
		},{
			xtype	: 'uniTextfield',
			name	: 'RE_REFERENCE',
			text	: '재참조버튼클릭관련',
			hidden	: true
		},{
			xtype	: 'uniTextfield',
			name	: 'RE_REFERENCE_SAVE',
			text	: '재참조버튼클릭관련저장플래그',
			hidden	: true
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r				= false;
					var labelText	= ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
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

	var detailForm = Unilite.createSearchForm('atx470ukrPanelSearch',{
		region		: 'center', 
		flex		: 2.5,
		autoScroll	: true,
		border		: true,
		padding		: '1 1 1 1',
		layout		: {type : 'uniTable', columns : 1},
		items		: [{
			xtype	: 'component',
			height	: 10
		},{
			layout	: {type : 'uniTable', columns : 2},
			padding	: '1 1 1 1',
			xtype	: 'container',
			defaults: {enforceMaxLength: true},
			items	: [{ 
				fieldLabel	: '사업장 상호',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				holdable	: 'hold',
				colspan		: 2
			},{ 
				fieldLabel	: '사업장 소재지',
				name		: 'ADDR',
				xtype		: 'uniTextfield',
				allowBlank	: false,
				holdable	: 'hold',
				maxLength	: 200,
				width		: 420,
				colspan		: 2
			},{ 
				fieldLabel	: '비고',
				name		: 'REMARK1',
				xtype		: 'uniTextfield',
				maxLength	: 100,
				width		: 420
			}]
		},{
			xtype	: 'component',
			height	: 10
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 1},
			border	: true,
			padding	: '1 1 1 1',
			items:[{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 10},
				items	: [{
					xtype: 'component',
					width: 10
				},{
					title	: '매출',
					xtype	: 'fieldset',
					padding	: '0 10 10 10',
					defaults: {readOnly: false, xtype: 'uniNumberfield', enforceMaxLength: true},
					layout	: {type: 'uniTable' , columns: 3,
						tableAttrs	: {width: '100%'},
						tdAttrs		: {align: 'center'}
					},
					items: [{
						xtype	: 'component',
						html	: ''
					},{
						xtype	: 'component',
						html	: '매출과세표준'
					},{
						xtype	: 'component',
						html	: '세액'
					},{
						xtype	: 'component',
						html	: '과세&nbsp;',
						tdAttrs	: {align : 'right'}
					},{
						xtype		: 'uniNumberfield',
						name		: 'AMT_S1',
						type		: 'uniPrice',
						maxLength	: 30,
						//20200722 추가: form validator 정상동작 하지 않아 로직 변경
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
							},
							blur: function(field, The, eOpts){
								gsGridFlag = false;
								detailForm.setValue('TAX_S1', field.value * 0.1);
							}
						}
					},{
						xtype		: 'uniNumberfield',
						name		: 'TAX_S1',
						type		: 'uniPrice',
						maxLength	: 30
					},{
						xtype	: 'component',
						html	: '영세&nbsp;',
						tdAttrs	: {align : 'right'}
					},{
						xtype	: 'uniNumberfield',
						name	: 'AMT_S2',
						type	: 'uniPrice'
					},{
						xtype	: 'uniNumberfield',
						name	: 'TAX_S2',
						type	: 'uniPrice',
						readOnly: true
					},{
						xtype	: 'component',
						html	: ' '
					},{
						xtype	: 'component',
						html	: ' '
					},{
						xtype	: 'component',
						html	: ' ',
						tdAttrs	: {height: 27}
					},{
						xtype	: 'component',
						html	: ''
					},{
						xtype	: 'component',
						html	: ''
					},{
						xtype	: 'component',
						html	: '1) 매출세액합계',
						style	: {
							marginTop	: '3px !important',
							font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif,weight:bold',
							color		: 'blue'
						},
						tdAttrs: {align : 'center'}
					},{
						xtype	: 'component',
						html	: ''
					},{
						xtype	: 'component',
						html	: ''
					},{
						xtype	: 'uniNumberfield',
						name	: 'SUM_TAX_SALES',
						type	: 'uniPrice',
						readOnly: true
					}]
				},{
					xtype: 'component',
					width: 10
				},{
					title	: '매입',
					xtype	: 'fieldset',
					padding	: '0 10 10 10',
					defaults: {readOnly: false, xtype: 'uniNumberfield', enforceMaxLength: true},
					layout	: {type: 'uniTable' , columns: 3,
						tableAttrs	: {width: '100%'},
						tdAttrs		: {align: 'center', width: '100%'}
					},
					items: [{
						xtype	: 'component',
						html	: ''
					},{
						xtype	: 'component',
						html	: '매입과세표준'
					},{
						xtype	: 'component',
						html	: '세액'
					},{
						xtype	: 'component',
						html	: '과세&nbsp;',
						tdAttrs	: {align : 'right'}
					},{
						xtype		: 'uniNumberfield',
						name		: 'AMT_P1',
						type		: 'uniPrice',
						maxLength	: 30,
						listeners	: {
							//20200722 추가: form validator 정상동작 하지 않아 로직 변경
							change: function(field, newValue, oldValue, eOpts) {
							},
							blur: function(field, The, eOpts){
								gsGridFlag = false;
								detailForm.setValue('TAX_P1', field.value * 0.1);
							}
						}
					},{
						xtype		: 'uniNumberfield',
						name		: 'TAX_P1',
						type		: 'uniPrice',
						maxLength	: 30
					},{
						xtype	: 'component',  
						html	: '의제 등&nbsp;',
						tdAttrs	: {align: 'right'}
					},{
						xtype		: 'uniNumberfield',
						name		: 'AMT_P2',
						type		: 'uniPrice',
						listeners	: {
							//20200722 추가: form validator 정상동작 하지 않아 로직 변경
							change: function(field, newValue, oldValue, eOpts) {
							},
							blur: function(field, The, eOpts){
								gsGridFlag = false;
								detailForm.setValue('TAX_P2', field.value * 0.1);
							}
						}
					},{
						xtype	: 'uniNumberfield',
						name	: 'TAX_P2',
						type	: 'uniPrice'
					},{
						xtype	: 'component',
						html	: ' '
					},{
						xtype	: 'component',
						html	: ' '
					},{
						xtype	: 'component',
						html	: ' ',
						tdAttrs	: {height: 27}
					},{
						xtype	: 'component',
						html	: ' '
					},{
						xtype	: 'component',
						html	: ' '
					},{
						xtype	: 'component',  
						html	: '2) 매입세액합계',
						style	: {
							marginTop	: '3px !important',
							font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif,weight:bold',
							color		: 'blue'
						},
						tdAttrs: {align: 'center'}
					},{
						xtype	: 'component',
						html	: ' '
					},{
						xtype	: 'component',
						html	: ' '
					},{
						xtype	: 'uniNumberfield',
						name	: 'SUM_TAX_PURCHASE',
						readOnly: true
					}]
				},{
					xtype: 'component',
					width: 10
				},{
					title	: '기타',
					xtype	: 'fieldset',
					padding	: '0 10 10 10',
					defaults: {readOnly: false, xtype: 'uniNumberfield', enforceMaxLength: true},
					layout	: {type: 'uniTable' , columns: 2,
						tableAttrs	: {width: '100%'},
						tdAttrs		: {align : 'center'}
					},
					items	: [{
						xtype	: 'component',
						html	: ' ',
						colspan	: 2,
						height	: 67
					},{
						xtype	: 'component',
						html	: ' '
					},{
						xtype	: 'component',
						html	: '3) 기타세액',
						style	: {
							marginTop	: '3px !important',
							font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif,weight:bold',
							color		: 'blue'
						},
						tdAttrs	: {align : 'center'}
					},{
						xtype	: 'component',
						html	: '가산세(+)&nbsp;'
					},{
						xtype		: 'uniNumberfield',
						name		: 'AMT_T1',
						type		: 'uniPrice',
						maxLength	: 30
					},{
						xtype	: 'component',
						html	: '공제세액(-)&nbsp;'
					},{
						xtype	: 'uniNumberfield',
						name	: 'AMT_T2',
						type	: 'uniPrice'
					}]
				},{
					xtype: 'component',
					width: 10
				},{
					title	: '납부',
					xtype	: 'fieldset',
					padding	: '0 10 10 10',
					defaults: {readOnly: false, xtype: 'uniNumberfield',enforceMaxLength: true},
					layout	: {type: 'uniTable', columns: 1,
						tableAttrs	: {width: '100%'},
						tdAttrs		: {align: 'center'}
					},
					items: [{
						xtype	: 'component',
						html	: ' ',
						colspan	: 2,
						height	: 91
					},{
						xtype	: 'component',
						html	: ' '
					},{
						xtype	: 'component',
						html	: '납부세액(환급세액)',
						style	: {
							marginTop	: '3px !important',
							font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif,weight:bold',
							color		: 'blue'
						},
						tdAttrs	: {align : 'center'}
					},{
						xtype		: 'uniNumberfield',
						name		: 'SUM_TAX_REFUND',
						type		: 'uniPrice',
						maxLength	: 30,
						readOnly	: true
					}]
				},{
					xtype: 'component',
					width: 10
				},{
					title	: '내부거래',
					xtype	: 'fieldset',
					padding	: '0 10 10 10',
					defaults: {readOnly: false, xtype: 'uniNumberfield', enforceMaxLength: true},
					layout	: {type: 'uniTable' , columns: 2,
						tableAttrs	: {width: '100%'},
						tdAttrs		: {align : 'center'}
					},
					items	: [{
						xtype	: 'component',
						html	: ' ',
						colspan	: 2,
						height	: 67
					},{
						xtype	: 'component',
						html	: ' '
					},{
						xtype	: 'component',
						html	: '4) 내부거래',
						style	: {
							marginTop	: '3px !important',
							font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif,weight:bold',
							color		: 'blue'
						},
						tdAttrs	: {align : 'center'}
					},{
						xtype	: 'component',
						html	: '반출액&nbsp;'
					},{
						xtype		: 'uniNumberfield',
						name		: 'AMT_I1',
						type		: 'uniPrice',
						maxLength	: 30
					},{
						xtype	: 'component',
						html	: '반입액&nbsp;'
					},{
						xtype	: 'uniNumberfield',
						name	: 'AMT_I2',
						type	: 'uniPrice'
					}]
				}]
			}]
		},{
			xtype: 'component',
			html:' '
		}],
		setAllFieldsReadOnly: function(b) {	
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r				= false;
					var labelText	= ''
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
		},
		setLoadRecord: function() {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('atx470ukrGrid1', {
		store		: directMasterStore,
		flex		: 1.5,
		region		: 'south',
		excelTitle	: '사업장별 부가가치세 과세표준 및 납부세액(환급세액) 신고명세서',
		uniOpt		: {
			useGroupSummary		: false,
			useLiveSearch		: false,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			onLoadSelectFirst	: true,
			filter				: {
				useFilter		: false,
				autoCreate		: false
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns:  [
			{dataIndex: 'COMP_CODE'			, width: 90,hidden:true},
			{dataIndex: 'FR_PUB_DATE'		, width: 90,hidden:true},
			{dataIndex: 'TO_PUB_DATE'		, width: 90,hidden:true},
			{dataIndex: 'DIV_CODE'			, width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'ADDR'				, width: 130},
			{dataIndex: 'AMT_S1'			, width: 100,summaryType: 'sum'},
			{dataIndex: 'TAX_S1'			, width: 90,summaryType: 'sum'},
			{dataIndex: 'AMT_S2'			, width: 100,summaryType: 'sum'},
			{dataIndex: 'SUM_TAX_SALES'		, width: 90,summaryType: 'sum',
				style: {
					font	: '10px "굴림",Gulim,tahoma,arial,verdana,sans-serif,weight:bold',
					color	: 'blue'
				},
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if (val != 0){
						return '<span style= "color:' + 'blue' + '">' + Ext.util.Format.number(val, '0,000') + '</span>';
					}
					return Ext.util.Format.number(val, '0,000');
				}
			},
			{dataIndex: 'AMT_P1'			, width: 100,summaryType: 'sum'},
			{dataIndex: 'TAX_P1'			, width: 90,summaryType: 'sum'},
			{dataIndex: 'AMT_P2'			, width: 90,summaryType: 'sum'},
			{dataIndex: 'TAX_P2'			, width: 90,summaryType: 'sum'},
			{dataIndex: 'SUM_TAX_PURCHASE'	, width: 90,summaryType: 'sum',
				style: {
					font	: '10px "굴림",Gulim,tahoma,arial,verdana,sans-serif,weight:bold',
					color	: 'blue'
				},
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if (val != 0){
						return '<span style= "color:' + 'blue' + '">' + Ext.util.Format.number(val, '0,000') + '</span>';
					}
					return Ext.util.Format.number(val, '0,000');
				}
			},
			{dataIndex: 'AMT_T1'			, width: 90,summaryType: 'sum'},
			{dataIndex: 'AMT_T2'			, width: 90,summaryType: 'sum'},
			{dataIndex: 'SUM_TAX_REFUND'	, width: 90,summaryType: 'sum',
				style: {
					font	: '10px "굴림",Gulim,tahoma,arial,verdana,sans-serif,weight:bold',
					color	: 'blue'
				},
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if (val != 0){
						return '<span style= "color:' + 'blue' + '">' + Ext.util.Format.number(val, '0,000') + '</span>';
					}
					return Ext.util.Format.number(val, '0,000');
				}
			},
			{dataIndex: 'AMT_I1'			, width: 90,summaryType: 'sum'},
			{dataIndex: 'AMT_I2'			, width: 90,summaryType: 'sum'},
			{dataIndex: 'REMARK1'			, width: 90}
		],
		listeners:{
			beforeedit: function( editor, e, eOpts ) {
				return false;
			},
			selectionchangerecord: function(selected) {
				detailForm.setActiveRecord(selected);
			}
		},
		setNewDataATX100T:function(record){
			//20200722 추가: form validator 정상동작 하지 않아 로직 변경 (gsGridFlag = false; 추가)
			var grdRecord = this.getSelectedRecord();
			gsGridFlag = false;
			grdRecord.set('COMP_CODE'		, record['COMP_CODE']);
			gsGridFlag = false;
			grdRecord.set('FR_PUB_DATE'		, record['FR_PUB_DATE']);
			gsGridFlag = false;
			grdRecord.set('TO_PUB_DATE'		, record['TO_PUB_DATE']);
			gsGridFlag = false;
			grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			gsGridFlag = false;
			grdRecord.set('ADDR'			, record['ADDR']);
			gsGridFlag = false;
			grdRecord.set('AMT_S1'			, record['AMT_S1']);
			gsGridFlag = false;
			grdRecord.set('TAX_S1'			, record['TAX_S1']);
			gsGridFlag = false;
			grdRecord.set('AMT_S2'			, record['AMT_S2']);
			gsGridFlag = false;
			grdRecord.set('SUM_TAX_SALES'	, record['SUM_TAX_SALES']);
			gsGridFlag = false;
			grdRecord.set('AMT_P1'			, record['AMT_P1']);
			gsGridFlag = false;
			grdRecord.set('TAX_P1'			, record['TAX_P1']);
			gsGridFlag = false;
			grdRecord.set('AMT_P2'			, record['AMT_P2']);
			gsGridFlag = false;
			grdRecord.set('TAX_P2'			, record['TAX_P2']);
			gsGridFlag = false;
			grdRecord.set('SUM_TAX_PURCHASE', record['SUM_TAX_PURCHASE']);
			gsGridFlag = false;
			grdRecord.set('AMT_T1'			, record['AMT_T1']);
			gsGridFlag = false;
			grdRecord.set('AMT_T2'			, record['AMT_T2']);
			gsGridFlag = false;
			grdRecord.set('AMT_I1'			, record['AMT_I1']);
			gsGridFlag = false;
			grdRecord.set('AMT_I2'			, record['AMT_I2']);
			gsGridFlag = false;
			grdRecord.set('REMARK1'			, record['REMARK1']);
			gsGridFlag = false;
			//납부세액 계산
			grdRecord.set('SUM_TAX_REFUND'	, record['SUM_TAX_SALES'] - record['SUM_TAX_PURCHASE'] + record['AMT_T1'] - record['AMT_T2']);
		}
	});



	Unilite.Main({
		id			: 'atx470ukrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				detailForm, masterGrid, panelResult
			]
		}],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['newData','save'], false);
			UniAppManager.setToolbarButtons('reset', true);
			this.setDefault();
		},
		onQueryButtonDown : function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			} else{
				directMasterStore.loadStoreRecords();
				return panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function() {
			if(!this.checkForNewDetail()) return false;

			var frPubDate	= panelResult.getField('FR_PUB_DATE').getStartDate();
			var toPubDate	= panelResult.getField('TO_PUB_DATE').getEndDate();
			var compCode	= UserInfo.compCode;
			var r			= {
				FR_PUB_DATE	: frPubDate,
				TO_PUB_DATE	: toPubDate,
				COMP_CODE	: compCode
			};
			masterGrid.createRow(r);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			panelResult.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			detailForm.clearForm();
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
			} else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){
							masterGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
						isNewData = false;	
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		setDefault: function() {
//			if(getTaxBase == '5'){
//				panelResult.setValue('txtCompanyNum', getCompanyNum);
//				panelResult.setValue('txtAppNum'	, getAppNum);
//			}
			detailForm.disable(true);
			panelResult.setValue('FR_PUB_DATE', UniDate.get('today'));
			panelResult.setValue('TO_PUB_DATE', UniDate.get('today'));

			panelResult.onLoadSelectText('FR_PUB_DATE');
		},
		checkForNewDetail:function() {
			return panelResult.setAllFieldsReadOnly(true);
		},
		setSumDetailFormValue:function(record) {
			//20200722 추가: form validator 정상동작 하지 않아 로직 변경
			gsGridFlag = false;
			detailForm.setValue('SUM_TAX_SALES'		, detailForm.getValue('TAX_S1'));
			gsGridFlag = false;
			detailForm.setValue('SUM_TAX_PURCHASE'	, detailForm.getValue('TAX_P1') + detailForm.getValue('TAX_P2'));
			gsGridFlag = false;
			detailForm.setValue('SUM_TAX_REFUND'	, detailForm.getValue('SUM_TAX_SALES') - detailForm.getValue('SUM_TAX_PURCHASE')
													+ detailForm.getValue('AMT_T1') - detailForm.getValue('AMT_T2'));
			if(record) {
				gsGridFlag = false;
				record.set('AMT_S1'				, detailForm.getValue('AMT_S1'));
				gsGridFlag = false;
				record.set('TAX_S1'				, detailForm.getValue('TAX_S1'));
				gsGridFlag = false;
				record.set('AMT_P1'				, detailForm.getValue('AMT_P1'));
				gsGridFlag = false;
				record.set('TAX_P1'				, detailForm.getValue('TAX_P1'));
				gsGridFlag = false;
				record.set('AMT_P2'				, detailForm.getValue('AMT_P2'));
				gsGridFlag = false;
				record.set('TAX_P2'				, detailForm.getValue('TAX_P2'));
				gsGridFlag = false;
				record.set('AMT_T1'				, detailForm.getValue('AMT_T1'));
				gsGridFlag = false;
				record.set('AMT_T2'				, detailForm.getValue('AMT_T2'));
				gsGridFlag = false;
				record.set('AMT_I1'				, detailForm.getValue('AMT_I1'));
				gsGridFlag = false;
				record.set('AMT_I2'				, detailForm.getValue('AMT_I2'));

				gsGridFlag = false;
				record.set('SUM_TAX_SALES'		, detailForm.getValue('SUM_TAX_SALES'));
				gsGridFlag = false;
				record.set('SUM_TAX_PURCHASE'	, detailForm.getValue('SUM_TAX_PURCHASE'));
				gsGridFlag = false;
				record.set('SUM_TAX_REFUND'		, detailForm.getValue('SUM_TAX_REFUND'));
			}
		}
	});



	//20200722 주석: form validator 정상동작 하지 않아 로직 변경 후 주석처리
/*	Unilite.createValidator('validator01', {
		store	: directMasterStore,
		grid	: masterGrid,
		forms	: {'formA:': detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			switch(fieldName){
				case 'AMT_S1':
					detailForm.setValue('TAX_S1', newValue * 0.1);
					UniAppManager.app.setSumDetailFormValue(record);
					break;

				case 'AMT_P1':
					detailForm.setValue('TAX_P1', newValue * 0.1);
					UniAppManager.app.setSumDetailFormValue(record);
					break;

				case 'AMT_P2':
					detailForm.setValue('TAX_P2', newValue * 0.1);
					UniAppManager.app.setSumDetailFormValue(record);
					break;

				case fieldName:
					UniAppManager.app.setSumDetailFormValue(record);
				break;
			}
			return rv;
		}
	});*/
};
</script>