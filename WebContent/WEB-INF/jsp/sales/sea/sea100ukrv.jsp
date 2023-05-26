<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sea100ukrv">
	<t:ExtComboStore comboType="BOR120"/>									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>						<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="SE01"/>						<!-- 견적기준 -->
	<t:ExtComboStore comboType="AU" comboCode="SE06"/>						<!-- 생산파트 -->
	<t:ExtComboStore comboType="AU" comboCode="SE07"/>						<!-- 연구파트 -->
	<t:ExtComboStore comboType="AU" comboCode="SE08"/>						<!-- 충전단위 -->
	<t:ExtComboStore comboType="AU" comboCode="SE09"/>						<!-- 자재구분 -->	<%-- 20210907 추가  --%>
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-component.x-html-editor-input.x-box-item.x-component-default {
		border-top: 1px solid #b5b8c8;
	}
	.editorCls {height:100%;}
</style>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js"/>'>
</script>
<script type="text/javascript" >

function appMain() {
	var SearchInfoWindow;	//검색창
	var gsInitFlag	= true;
	var gsIhight	= 170;	//미리보기 할 이미지 파일 크기
	var gsIwidth	= 170;	//미리보기 할 이미지 파일 크기
	var gsRefCode1;			//충전단위에 따른 로직 수행하기 위해 추가
	var BsaCodeInfo	= {
		gsUseApprovalYn: '${gsUseApprovalYn}'	//견적승인사용여부
	}


	/* master 정보 form
	 */
	var panelResult = Unilite.createForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 4
//			, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//			, tdAttrs	: {style: 'border : 1px solid #ced9e7;'/*, valign : 'top'*/}
		},
		padding		: '1 1 1 1',
		disabled	: false,
		border		: true,
		api			: {
			load	: 'sea100ukrvService.selectMaster',
			submit	: 'sea100ukrvService.saveMaster'
		},
		items	: [{ 
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelResult.getField('SALE_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
//			holdable		: 'hold',
//			allowBlank		: false,		//20210818 수정: 주석, 부분입력 가능하도록 변경
			validateBlank	: false,		//20210818 추가: 부분입력 가능하도록 변경
			listeners		: {
				//20210818 수정: 조회조건 팝업설정에 맞게 변경
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_CODE', '');
					}
				},
//				onSelected: {
//					fn: function(records, type) {
//					},
//					scope: this
//				},
//				onClear: function(type) {
//				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '견적의뢰일',
			xtype		: 'uniDatefield',
			name		: 'ESTI_REQ_DATE',
//			holdable	: 'hold',
			allowBlank	: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
//			holdable	: 'hold',
			allowBlank	: false,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '견적의뢰번호',
			xtype		: 'uniTextfield',
			name		: 'ESTI_NUM',
			readOnly	: true
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			validateBlank	: false,
//			holdable		: 'hold',
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelResult.setValue('ESTI_ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelResult.setValue('ESTI_ITEM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.poqty" default="발주량"/>',
			xtype		: 'uniNumberfield',
			name		: 'ESTI_QTY',
//			holdable	: 'hold',
			allowBlank	: false,
			value		: 0
		},{
			fieldLabel	: '충전단위',
			name		: 'FILL_UNIT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE08',
//			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					var commonCodes = Ext.data.StoreManager.lookup('CBS_AU_SE08').data.items;
					Ext.each(commonCodes, function(commonCode, i) {
						if(commonCode.get('value') == newValue) {
							gsRefCode1 = commonCode.get('refCode1');
						}
					});
					var records = detailStore.data.items;
					if(gsRefCode1 == 'Y') {
						var specGravity = 0;
					} else {
						var specGravity = 1;
					}
					Ext.each(records, function(record,i) {
						record.set('SPEC_GRAVITY', specGravity);
					});
				}
			}
		},{
			fieldLabel	: '생산파트',
			name		: 'PROD_PART',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE06',
//			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '연구파트',
			name		: 'RES_PART',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE07',
//			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '견적기준',
			name		: 'ESTI_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE01',
//			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '자재구분',
			name		: 'MAT_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE09',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
//		},{
//			xtype	: 'component',
//			hidden	: BsaCodeInfo.gsUseApprovalYn == 'Y' ? true:false,
//			width	: 100
		},
		Unilite.popup('USER_SINGLE',{
			fieldLabel		: '<t:message code="system.label.sales.approvaluser" default="승인자"/>',
			autoPopup		: true,
//			holdable		: 'hold',
			hidden			: BsaCodeInfo.gsUseApprovalYn == 'Y' ? false:true,
			colspan			: 4,
			listeners		: {
				'onSelected': {
					fn: function(records, type ){
						panelResult.setValue('AGREE_PRSN', records[0].USER_ID);
					},
					scope: this
				},
				'onClear' : function(type)	{
					panelResult.setValue('AGREE_PRSN', '');
				}
			} 
		}),{
			fieldLabel	: 'BOM 포장사양',
			xtype		: 'textarea',
			name		: 'BOM_SPEC',
			width		: 573,
			height		: 50,
			colspan		: 2,
			listeners	: {
				focus: function(field, event, eOpts) {
				}
			}
		},{
			fieldLabel	: '특이사항',
			xtype		: 'textarea',
			name		: 'REMARK',
			width		: 490,
			height		: 50,
			colspan		: 2,
			listeners	: {
				focus: function(field, event, eOpts) {
				}
			}
		},{
			xtype		: 'uniTextfield',
			fieldLabel	: '용기/부자재 사진',
			name		: 'CASE_SM_REMARK',
			colspan		: 4,
			width		: '100%',
			hidden		: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype		: 'uniTextfield',
			fieldLabel	: 'AGREE_YN',
			name		: 'AGREE_YN',
			value		: BsaCodeInfo.gsUseApprovalYn == 'Y' ? 'Y':'',
			hidden		: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype		: 'uniTextfield',
			fieldLabel	: 'AGREE_PRSN',
			name		: 'AGREE_PRSN',
			hidden		: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype		: 'uniTextfield',
			fieldLabel	: 'ESTI_ITEM_CODE',
			name		: 'ESTI_ITEM_CODE',
			hidden		: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype		: 'uniTextfield',
			fieldLabel	: 'ESTI_ITEM_NAME',
			name		: 'ESTI_ITEM_NAME',
			hidden		: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		}],
		listeners: {
			uniOnChange:function( basicForm, dirty, eOpts ) {
				console.log("onDirtyChange");
				if(basicForm.getField('DIV_CODE').isDirty()
				|| basicForm.getField('CUSTOM_CODE').isDirty()		|| basicForm.getField('CUSTOM_NAME').isDirty()
				|| basicForm.getField('ESTI_REQ_DATE').isDirty()	|| basicForm.getField('SALE_PRSN').isDirty()
				|| basicForm.getField('ESTI_NUM').isDirty()			|| basicForm.getField('ESTI_REQ_DATE').isDirty()
				|| basicForm.getField('ESTI_ITEM_CODE').isDirty()	|| basicForm.getField('ESTI_ITEM_NAME').isDirty()
				|| basicForm.getField('ESTI_QTY').isDirty()			|| basicForm.getField('FILL_UNIT').isDirty()
				|| basicForm.getField('PROD_PART').isDirty()		|| basicForm.getField('RES_PART').isDirty()
				|| basicForm.getField('ESTI_TYPE').isDirty()		|| basicForm.getField('AGREE_PRSN').isDirty()
				|| basicForm.getField('BOM_SPEC').isDirty()			|| basicForm.getField('REMARK').isDirty()
				|| basicForm.getField('CASE_SM_REMARK').isDirty()	|| basicForm.getField('MAT_TYPE').isDirty()) {				//20210907 추가: || basicForm.getField('MAT_TYPE').isDirty()
					if(!gsInitFlag) {
						UniAppManager.setToolbarButtons(['save', 'reset'], true);
					}
				}
			}
		}
	});



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sea100ukrvService.selectDetail',
			update	: 'sea100ukrvService.updateDetail',
			create	: 'sea100ukrvService.insertDetail',
			destroy	: 'sea100ukrvService.deleteDetail',
			syncAll	: 'sea100ukrvService.saveAll'
		}
	});

	Unilite.defineModel('sea100ukrvModel', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'	, type: 'string'	, editable: false, allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string'	, editable: false, allowBlank: false	, comboType: 'BOR120'},
			{name: 'ESTI_NUM'		, text: '<t:message code="system.label.sales.estimateno" default="견적번호"/>'		, type: 'string'	, editable: false},
			{name: 'ESTI_SEQ'		, text: '<t:message code="system.label.sales.estimateseq" default="견적순번"/>'		, type: 'int'		, editable: false},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'FILL_NAME'		, text: '<t:message code="system.label.sales.contents" default="내용물"/>'			, type: 'string'/*, allowBlank: false*/},										//20210907 수정: allowBlank: false 주석
			{name: 'FILL_QTY'		, text: '충진량'				, type: 'float'	, allowBlank: false, decimalPrecision: 2, format:'0,0000.00', allowBlank: false},									//20210706 수정: 충진량, 비중 소수점 2째자리까지 표현되도록 수정
			{name: 'LAB_NO'			, text: 'LAB No.'			, type: 'string'/*, allowBlank: false*/},			//20210907 수정: allowBlank: false 주석
//			{name: 'LAB_PRSN'		, text: '연구담당'				, type: 'string'},									//제외
			{name: 'LAB_SRAL_NO'	, text: 'LAB_SRAL_NO'		, type: 'string'},									//20210907 추가: 
			{name: 'SPEC_GRAVITY'	, text: '<t:message code="system.label.base.gravity" default="비중"/>'			, type: 'float'	/*, allowBlank: false*/, decimalPrecision: 2, format:'0,0000.00'},	//20210706 수정: 충진량, 비중 소수점 2째자리까지 표현되도록 수정, 20210907 수정: allowBlank: false 주석
			{name: 'EDIT_FLAG'	    , text: '저장여부'			    , type: 'string' /*, allowBlank: false*/ } 
		]
	});

	var detailStore = Unilite.createStore('sea100ukrvDetailStore',{
		model	: 'sea100ukrvModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			allDeletable: false,	// 전체 삭제
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param = panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);
			var isErr		= false;

			//충전단위.ref_code1 == 'Y'이면 비중컬럼 필수체크
			if(gsRefCode1 == 'Y') {
				Ext.each(list, function(record, i) {
					if(record.get('SPEC_GRAVITY') == 0) {
						isErr = true;
						return false;
					}
				});
			}
			if(isErr) {
				Unilite.messageBox('충진단위[' + panelResult.getValue('FILL_UNIT') + ']의 비중적용여부가 [Y]인 경우, 비중은 필수 입력 입니다.');
				return false;
			}

			var paramMaster = panelResult.getValues();
			if(inValidRecs.length == 0) {
				if(config == null) {
					config = {
						params	: [paramMaster],
						success	: function(batch, option) {
							if(Ext.isEmpty(panelResult.getValue('ESTI_NUM'))) {
								var master = batch.operations[0].getResultSet();
								panelResult.setValue('ESTI_NUM', master.ESTI_NUM);
							}
							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);
	
							if(detailStore.getCount() == 0){
								UniAppManager.app.onResetButtonDown();
							} else {
								UniAppManager.app.onQueryButtonDown();
							}
						}
					};
				}
				this.syncAllDirect(config);
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
					setPanelReadOnly(true);
					//충전단위에 따른 로직 수행하기 위해 전역변수 기본값 설정 / 컬럼 속성 설정
					var commonCodes = Ext.data.StoreManager.lookup('CBS_AU_SE08').data.items;
					Ext.each(commonCodes, function(commonCode, i) {
						if(commonCode.get('value') == panelResult.getValue('FILL_UNIT')) {
							gsRefCode1 = commonCode.get('refCode1');
						}
					});
					//미리보기 데이터 설정
					var images = panelResult.getValue('CASE_SM_REMARK');
					if(!Ext.isEmpty(images)) {
						var imagesArray = images.split(',');
						var html;
						Ext.each(imagesArray, function(image, i) {
							if(i == 0) {
								html = '<style="float: left;"><img src="' + CHOST + CPATH + '/fileman/download/' + image + '.bin' + '" Height= "' + gsIhight + '" Width= "' + gsIwidth + '"/>';
							} else {
								html = html + '<img src="' + CHOST + CPATH + '/fileman/download/' + image + '.bin' + '" Height= "' + gsIhight + '" Width= "' + gsIwidth + '"/>';
							}
						});
						previewForm.down('#preViewField').setHtml(html);
					}
				}
			},
			write: function(proxy, operation){
//				if (operation.action == 'destroy') {
//					Ext.getCmp('panelResult').reset();
//				}
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
//				panelResult.setActiveRecord(record);
			},
			remove: function( store, records, index, isMove, eOpts ) {
//				if(store.count() == 0) {
//					panelResult.clearForm();
//					panelResult.disable();
//				}
			}
		}/*,
		//20210409 추가: deleteAll, save 버튼관련 수정
		_onStoreDataChanged: function( store, eOpts ) {
			if(this.uniOpt.isMaster) {
				if(store.count() == 0) {
					UniApp.setToolbarButtons(['delete'], false);
					Ext.apply(this.uniOpt.state, {'btn':{'delete': false}});
					if(this.uniOpt.useNavi) {
						UniApp.setToolbarButtons(['prev','next'], false);
					}
				} else {
					if(this.uniOpt.deletable) {
						UniApp.setToolbarButtons(['delete'], true);
						if(this.uniOpt.allDeletable){
							UniApp.setToolbarButtons(['deleteAll'], true);
						}
						Ext.apply(this.uniOpt.state, {'btn':{'delete':true}});
					}
					if(this.uniOpt.useNavi) {
						UniApp.setToolbarButtons(['prev','next'], true);
					}
				}
				if(store.isDirty() || panelResult.isDirty()) {											//20210409 추가
					UniApp.setToolbarButtons(['save'], true);
				} else {
					UniApp.setToolbarButtons(['save'], false);
				}
			}
		}*/
	});

	var detailGrid = Unilite.createGrid('sea100ukrvGrid', {
		store	: detailStore,
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		features: [ {id : 'detailGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'detailGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns:[
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'ESTI_NUM'			, width: 100	, hidden: true},
			{dataIndex: 'ESTI_SEQ'			, width: 100	, hidden: true},
			{dataIndex: 'LAB_SRAL_NO'		, width: 100	, hidden: true},
			{dataIndex: 'LAB_NO'			, width: 180,
				editor: Unilite.popup('LAB_NO_G',{
					validateBlank	: false,		//20210907 수정: false -> true
//					autoPopup		: true,			//20210907 주석
//					autoLoad		: true,
					listeners		:{
						scope:this,
						onValueFieldChange: function(field, newValue, oldValue){
							var grdRecord = detailGrid.uniOpt.currentRecord;
							if(!Ext.isObject(oldValue)) {
								grdRecord.set('FILL_NAME'	,'');
								grdRecord.set('LAB_SRAL_NO'	,'');							//20210907 추가
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							var grdRecord = detailGrid.uniOpt.currentRecord;
							if(!Ext.isObject(oldValue)) {
								grdRecord.set('FILL_NAME'	,'');
								grdRecord.set('LAB_SRAL_NO'	,'');							//20210907 추가
							}
						},
						onSelected: function(records, type ) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('LAB_NO'		, records[0]['LAB_NO']);
							grdRecord.set('FILL_NAME'	, records[0]['SAMPLE_NAME']);
							//grdRecord.set('LAB_SRAL_NO'	, records[0]['LAB_SRAL_NO']);	//20210907 추가
							grdRecord.set('LAB_SRAL_NO'	, records[0]['SAMPLE_KEY']);	//20210907 추가
						},
						onClear:function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('FILL_NAME'	,'');
							grdRecord.set('LAB_SRAL_NO'	,'');							//20210907 추가
						},
						'applyextparam': function(popup){
							popup.setExtParam({'MAX_YN': 'Y'});							//20210818 추가: 동일 거래처/lab no 일 때, 최근 데이터만 보여주기 위해 추가
						}
					}
				})
			},
			{dataIndex: 'ITEM_CODE'			, width: 110	, hidden: true ,
/*				editor: Unilite.popup('DIV_PUMOK_G',{
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: { 
						'onSelected': {
							fn: function(records, type){
								Ext.each(records, function(record, i) {
									if(i==0) {
										detailGrid.setItemData(record, false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record, false, detailGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear' : function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				}),*/
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					detailGrid.down('#SummaryAmt').setValue(metaData.record.get('GOOD_RECEIPT_O') + metaData.record.get('BAD_RECEIPT_O'));
					return Unilite.renderSummaryRow(summaryData, metaData, '', '계');
				}
			},
			{dataIndex: 'FILL_NAME'			, width: 200},
			{dataIndex: 'FILL_QTY'			, width: 120},
//			{dataIndex: 'LAB_PRSN'			, width: 110},			//제외
			{dataIndex: 'SPEC_GRAVITY'		, width: 100},
			{dataIndex: 'EDIT_FLAG'		    , width: 100, hidden: true}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			},
			beforeedit: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE', 'ESTI_NUM', 'ESTI_SEQ'])){
					return false;
				}
				if(gsRefCode1 != 'Y') {
					if (UniUtils.indexOf(e.field, ['SPEC_GRAVITY'])){
						return false;
					}
				}
				//위 필드 제외, 모두 수정 가능 - 뒷단로직 발생 시, 저장하면서 체크
//				if (e.record.phantom) {
//					return true;
//				} else {
//					return false;
//				}
			},
			selectionchangerecord:function(selected) {
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		}/*,
		onItemcontextmenu:function( menu, grid, record, item, index, event, e, eOpts ) {
			return true;
		},
		uniRowContextMenu:{
			items: [{
				text	: '기간별 수불현황 조회(WM)',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					detailGrid.gotoS_biv360skrv_wm(param.record);
				}
			}]
		},
		gotoS_biv360skrv_wm:function(record) {
			if(record) {
				var params		= {
					action			: 'select',
					'PGM_ID'		: PGM_ID,
					'DIV_CODE'		: record.get('DIV_CODE'),
					'ITEM_CODE'		: record.get('ITEM_CODE'),
					'ITEM_NAME'		: record.get('ITEM_NAME'),
					'ORDER_DATE_FR'	: UniDate.get('sixMonthsAgo'),
					'ORDER_DATE_TO'	: UniDate.get('today')
				}
				var rec1= {data: {prgID: 's_biv360skrv_wm', 'text': ''}};
				parent.openTab(rec1, '/z_wm/s_biv360skrv_wm.do', params, CHOST+CPATH);
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(!dataClear) {
				grdRecord.set('ITEM_CODE', record.ITEM_CODE);
				grdRecord.set('ITEM_NAME', record.ITEM_NAME);
			} else {
				grdRecord.set('ITEM_CODE', '');
				grdRecord.set('ITEM_NAME', '');
			}
		}*/
	});


	//첨부파일 이미지 보여주는 필드
	var previewForm = Unilite.createSearchForm('detailForm', {
		region		: 'center',
		layout		: {type : 'container', columns : 3
//			, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//			, tdAttrs	: {style: 'border : 1px solid #ced9e7;', width: '100%'/*, align : 'center'*/}
		},
		disabled	: false,
		border		: true,
		padding		: '0',
		autoScroll	: true,
		width		: '100%',
		height		: 200,
		items		: [{
			xtype	: 'component',
			html	: '<div style="color: blue"><B>※ 용기/부자재 사진</div>',
			height	: 20,
			padding	: '3 0 10 10',
			colspan	: 3
		},{
			xtype		: 'component',
			itemId		: 'preViewField',
			height		: 170,
			padding		: '0 0 5 10',
			colspan		: 3,
			listeners	: {
				click: {
				}
			}
		}]
	});
	//파일첨부
	var fileUploadForm = Unilite.createSimpleForm('fileUploadForm',{
		region	: 'east',
		disabled: false,
		border	: false,
/*		api		: {
			 load	: 's_bsa315ukrv_wmService.getFileList',		//조회 api
			 submit	: 's_bsa315ukrv_wmService.saveFile'			//저장 api
		},*/
		items	: [{
			fieldLabel	: '첨부파일',
			xtype		: 'xuploadpanel',
			itemId		: 'fileUploadPanel',
			width		: 600,
			height		: 200,
			colspan		: 1,
			bbar		: ['->',{
				text	: 'upload',
				id		: 'uploadButton',
				itemId	: 'uploadButton',
				handler	: function() {
					var imagesArray	= fileUploadForm.down('xuploadpanel').store.data.items;
					var html, caseSmRemark;

					//미리보기 데이터 생성
					if(!Ext.isEmpty(imagesArray)) {
						Ext.each(imagesArray, function(image, i) {
							if(i == 0) {
								html = '<style="float: left;"><img src="' + CHOST + CPATH + '/fileman/download/' + image.get('fid') + '.bin' + '" Height= "' + gsIhight + '" Width= "' + gsIwidth + '"/>';
								caseSmRemark = image.get('fid');
							} else {
								html = html + '<img src="' + CHOST + CPATH + '/fileman/download/' + image.get('fid') + '.bin' + '" Height= "' + gsIhight + '" Width= "' + gsIwidth + '"/>';
								caseSmRemark = caseSmRemark + ',' + image.get('fid');
							}
						});
					} else {
						caseSmRemark = '';
					}
					panelResult.setValue('CASE_SM_REMARK', caseSmRemark);		//최종 이미지 정보를 저장하기 위해 panel에 set
					//미리보기 화면에 show
					previewForm.down('#preViewField').setHtml(html);
					fileUploadForm.down('#uploadButton').disable();
				}
			}],
			listeners	: {
				change: function(xup) {
//					var fp			= fileUploadForm.down('xuploadpanel');
//					var addFiles	= fp.getAddFiles();
//					var removeFiles	= fp.getRemoveFiles();
					fileUploadForm.down('#uploadButton').enable();
				},
				uploadcomplete : function(xup){
				}
			}
		}],
		loadForm: function() {
			this.reset();
			this.resetDirtyStatus();
			//첨부파일
			var fp	= fileUploadForm.down('xuploadpanel');
			var fid	= panelResult.getValue('CASE_SM_REMARK');
			if(!Ext.isEmpty(fid)) {
				sea100ukrvService.getFileList({DOC_NO : fid}, function(provider, response) {
					fp.loadData(response.result);
				})
			} else {
				fp.clear();
			}
		}
	});

	var filePanel = Ext.create('Ext.panel.Panel', {
		region	: 'south',
		layout	: {
			type	: 'uniTable',
			columns	: 2,
			width	: '100%',
			tdAttrs	: {width: '100%'}
		},
		items	: [
			previewForm, fileUploadForm 
		]
	});


	/* 검색 팝업
	 */
	var searchPopupPanel = Unilite.createSearchForm('searchPopupPanel', {
		layout	: {type: 'uniTable', columns: 3},
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = searchPopupPanel.getField('SALE_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},{
			fieldLabel		: '견적의뢰일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_ESTI_REQ_DATE',
			endFieldName	: 'TO_ESTI_REQ_DATE'
		},{
			fieldLabel	: '견적의뢰번호',
			xtype		: 'uniTextfield',
			name		: 'ESTI_NUM'
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.status" default="상태"/>',
			xtype		: 'radiogroup',
			itemId		: 'AGREE_YN',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
				name		: 'AGREE_YN',
				inputValue	: 'A',
				width		: 50,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.sales.approved" default="승인"/>',
				name		: 'AGREE_YN',
				inputValue	: 'Y',
				width		: 50
			},{
				boxLabel	: '<t:message code="system.label.sales.unapproved" default="미승인"/>',
				name		: 'AGREE_YN',
				inputValue	: 'N',
				width		: 60
			}]
		}]
	});
	Unilite.defineModel('searchPopupModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string', comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'ESTI_REQ_DATE'		, text: '견적의뢰일'		, type: 'uniDate'},
			{name: 'SALE_PRSN'			, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string', comboType: 'AU' , comboCode: 'S010'},
			{name: 'ESTI_NUM'			, text: '견적의뢰번호'	, type: 'string'},
			{name: 'ESTI_ITEM_CODE'		, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ESTI_ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname2" default="품명"/>'				, type: 'string'},
			{name: 'ESTI_QTY'			, text: '<t:message code="system.label.sales.estimateqty" default="견적수량"/>'			, type: 'uniQty'},
			{name: 'FILL_UNIT'			, text: '충전단위'		, type: 'string'},
			{name: 'PROD_PART'			, text: '생산파트'		, type: 'string'},
			{name: 'RES_PART'			, text: '연구파트'		, type: 'string'},
			{name: 'ESTI_TYPE'			, text: '견적기준'		, type: 'string', comboType: 'AU' , comboCode: 'S010'},
			{name: 'AGREE_PRSN'			, text: '<t:message code="system.label.sales.approvaluser" default="승인자"/>'			, type: 'string'},
			{name: 'BOM_SPEC'			, text: 'BOM포장사양'	, type: 'string'},
			{name: 'REMARK'				, text: '특이사항'		, type: 'string'}
		]
	});
	var searchPopupStore = Unilite.createStore('searchPopupStore', {
		model	: 'searchPopupModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'sea100ukrvService.searchPopupList'
			}
		},
		loadStoreRecords : function() {
			var param = searchPopupPanel.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	var searchPopupGrid = Unilite.createGrid('sea100ukrvsearchPopupGrid', {
		store	: searchPopupStore,
		layout	: 'fit',
		uniOpt	:{
			expandLastColumn: true,
			useRowNumberer	: true
		},
		selModel: 'rowmodel',
		columns	: [
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100},
			{dataIndex: 'CUSTOM_CODE'		, width: 120	, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 140},
			{dataIndex: 'ESTI_REQ_DATE'		, width: 90},
			{dataIndex: 'ESTI_NUM'			, width: 120},
			{dataIndex: 'ESTI_ITEM_CODE'	, width: 100	, hidden: true},
			{dataIndex: 'ESTI_ITEM_NAME'	, width: 150},
			{dataIndex: 'ESTI_QTY'			, width: 100},
			{dataIndex: 'SALE_PRSN'			, width: 100},
			{dataIndex: 'FILL_UNIT'			, width: 100	, hidden: true},
			{dataIndex: 'PROD_PART'			, width: 100	, hidden: true},
			{dataIndex: 'RES_PART'			, width: 100	, hidden: true},
			{dataIndex: 'ESTI_TYPE'			, width: 100},
			{dataIndex: 'AGREE_PRSN'		, width: 100	, hidden: true},
			{dataIndex: 'BOM_SPEC'			, width: 100	, hidden: true},
			{dataIndex: 'REMARK'			, width: 100	, hidden: true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				searchPopupGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function() {
			record = this.getSelectedRecord();
			panelResult.setValues({
				'DIV_CODE'			: record.get('DIV_CODE'),
				'CUSTOM_CODE'		: record.get('CUSTOM_CODE'),
				'CUSTOM_NAME'		: record.get('CUSTOM_NAME'),
				'ESTI_REQ_DATE'		: record.get('ESTI_REQ_DATE'),
				'ESTI_NUM'			: record.get('ESTI_NUM'),
				'ESTI_ITEM_CODE'	: record.get('ESTI_ITEM_CODE'),
				'ESTI_ITEM_NAME'	: record.get('ESTI_ITEM_NAME'),
				'ESTI_QTY'			: record.get('ESTI_QTY'),
				'SALE_PRSN'			: record.get('SALE_PRSN'),
				'FILL_UNIT'			: record.get('FILL_UNIT'),
				'PROD_PART'			: record.get('PROD_PART'),
				'RES_PART'			: record.get('RES_PART'),
				'ESTI_TYPE'			: record.get('ESTI_TYPE'),
				'AGREE_PRSN'		: record.get('AGREE_PRSN'),
				'BOM_SPEC'			: record.get('BOM_SPEC'),
				'REMARK'			: record.get('REMARK')
			});
		}
	});
	function openSearchInfoWindow() {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '견적의뢰번호 검색',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [searchPopupPanel, searchPopupGrid],
				tbar	:  ['->', {
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						if(!searchPopupPanel.getInvalidMessage()){
							return false;
						}
						searchPopupStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						searchPopupPanel.clearForm();
						searchPopupGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						searchPopupPanel.clearForm();
						searchPopupGrid.reset();
					},
					show: function( panel, eOpts ) {
						searchPopupPanel.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						searchPopupPanel.setValue('FR_ESTI_REQ_DATE', UniDate.get('startOfMonth'));
						searchPopupPanel.setValue('TO_ESTI_REQ_DATE', UniDate.get('today'));
						searchPopupPanel.setValue('CUSTOM_CODE'		, panelResult.getValue('CUSTOM_CODE'));
						searchPopupPanel.setValue('CUSTOM_NAME'		, panelResult.getValue('CUSTOM_NAME'));
						searchPopupPanel.setValue('SALE_PRSN'		, panelResult.getValue('SALE_PRSN'));
						searchPopupPanel.getField('AGREE_YN').setValue('A');
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}




	Unilite.Main({
		id			: 'sea100ukrvApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid, filePanel
			]
		}],
		fnInitBinding : function(params) {
			this.setDefault(params);
		},
		setDefault: function(params) {
			gsInitFlag = true;
			gsRefCode1 = '';
			fileUploadForm.down('#uploadButton').disable();
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('ESTI_REQ_DATE', UniDate.get('today'));

			var field = panelResult.getField('SALE_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, 'DIV_CODE');

			UniAppManager.setToolbarButtons(['newData'], true);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');

			setPanelReadOnly(false);
			panelResult.getField('CUSTOM_CODE').setReadOnly(false);
			panelResult.getField('CUSTOM_NAME').setReadOnly(false);

			//20210526 추가: 초기화 후, 저장버튼 비활성화
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();

			gsInitFlag = false;
//			if(!Ext.isEmpty(params && params.PGM_ID)){
//				this.processParams(params);
//			}
		},
		processParams: function(params) {
/*			if(params.PGM_ID == 's_mba200ukrv_wm') {
				panelResult.setValue('DIV_CODE'				, params.DIV_CODE);
				panelResult.setValue('ESTI_NUM'				, params.ESTI_NUM);
				panelResult.setValue('CUSTOM_CODE'			, '');
				panelResult.setValue('CUSTOM_NAME'			, '');
				panelResult.setValue('SALE_PRSN'			, '');
				panelResult.setValue('HOME_REMARK'			, '');
				panelResult.setValue('CUSTOM_PRSN'			, '');
				panelResult.setValue('RECEIPT_PRSN'			, '');
				panelResult.setValue('ESTI_REQ_DATE'		, '');
				panelResult.setValue('PHONE_NUM'			, '');
				panelResult.setValue('RECEIPT_TYPE'			, '');
				panelResult.setValue('WH_CODE'				, '');
				panelResult.setValue('REPRE_NUM_EXPOS'		, '');
				panelResult.setValue('E_MAIL'				, '');
				panelResult.setValue('BANK_NAME'			, '');
				panelResult.setValue('BANK_ACCOUNT_EXPOS'	, '');
				panelResult.setValue('PRICE_TYPE'			, '');
				panelResult.setValue('ADDR'					, '');
				panelResult.setValue('PICKUP_METHOD'		, '');
				panelResult.setValue('REMARK'				, '');
				panelResult.setValue('PICKUP_DATE'			, '');
				panelResult.setValue('PICKUP_AREA'			, '');
				panelResult.setValue('HOME_TITLE'			, '');
				panelResult.setValue('BANK_ACCOUNT'			, '');
				panelResult.setValue('REPRE_NUM'			, '');
				panelResult.setValue('HOME_PURCHAS_NO'		, '');
				this.onQueryButtonDown();
			}*/
		},
		onQueryButtonDown: function () {
			if(Ext.isEmpty(panelResult.getValue('ESTI_NUM'))) {
				openSearchInfoWindow();
			} else {
				previewForm.down('#preViewField').setHtml('');
				var param = panelResult.getValues();
				panelResult.uniOpt.inLoading = true;
				panelResult.getForm().load({
					params	: param,
					success	: function(form, action){
						detailStore.loadStoreRecords();
						//첨부파일 관련 로드 실행
						var fp = fileUploadForm.down('#fileUploadPanel');
						fileUploadForm.loadForm();
						panelResult.uniOpt.inLoading = false;
						UniAppManager.setToolbarButtons('save', false);
					},
					failure:function(){
						panelResult.uniOpt.inLoading = false;
					}
				});
			}
		},
		onNewDataButtonDown : function() {
			if(!panelResult.getInvalidMessage()){
				return false;
			}
			var seq = detailStore.max('ESTI_SEQ');
			if(!seq) seq = 1;
			else seq += 1;

			if(gsRefCode1 == 'Y') {
				var specGravity = 0;
			} else {
				var specGravity = 1;
			}
			var r = {
				'COMP_CODE'		: UserInfo.compCode,
				'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
				'ESTI_NUM'		: panelResult.getValue('ESTI_NUM'),
				'ESTI_SEQ'		: seq,
				'SPEC_GRAVITY'	: specGravity
			};
			detailGrid.createRow(r, null, detailStore.getCount() - 1);
			setPanelReadOnly(true);
		},
		onDeleteDataButtonDown : function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom == true) {
				detailGrid.deleteSelectedRow();
			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {	//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				detailGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						/*---------삭제전 로직 구현 끝----------*/
						if(deletable){
							masterGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		onSaveDataButtonDown: function (config) {
			if(!panelResult.getInvalidMessage()) return;	//필수체크

			if(detailStore.isDirty()){
				detailStore.saveStore();
			} else if(panelResult.isDirty()) {
				if(detailStore.data.items.length == 0) {
					Unilite.messageBox('내용물 정보를 입력한 후 저장하세요.');
					return false;
				}
				var param = panelResult.getValues();
				panelResult.getForm().submit({
					params	: param,
					success	: function(form, action) {
						if(!Ext.isEmpty(action.result.ESTI_NUM)) {
							panelResult.setValue('ESTI_NUM', action.result.ESTI_NUM);
						}
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();

						UniAppManager.setToolbarButtons('save', false);	
						UniAppManager.updateStatus(Msg.sMB011);

						if(!Ext.isEmpty(action.result.ESTI_NUM)) {
							UniAppManager.app.onQueryButtonDown();
						}
					}
				});
			} else {
				Unilite.messageBox('<t:message code="system.message.common.savecheck2" default="저장할 데이터가 없습니다."/>');
				return false;
			}
		},
		onResetButtonDown: function() {
			previewForm.down('#preViewField').setHtml('');
			fileUploadForm.clearForm();
			fileUploadForm.down('xuploadpanel').reset();
			panelResult.clearForm();
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			detailGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});



	//panelResult readOnly 설정
	function setPanelReadOnly(flag) {
		var fields = panelResult.getForm().getFields();
		Ext.each(fields.items, function(item) {
			if(Ext.isDefined(item.holdable)) {
				if (item.holdable == 'hold') {
					item.setReadOnly(flag);
				}
			}
			if(item.isPopupField) {
				var popupFC = item.up('uniPopupField');
				if(popupFC.holdable == 'hold') {
					popupFC.setReadOnly(flag);
				}
			}
		})
	}
};
</script>