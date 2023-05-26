<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb165rkr">
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A077"/>	<!-- 미결구분 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>

<script type="text/javascript">

///////////////////////////////// 페이지 개발 전 확인사항 /////////////////////////////////
// 계정과목 팝업 선택시 미결항목 팝업이 유동적으로 변함(구현이 안되있어서 거래처 팝업으로 대체함.)
// 마스터그리드에서 조건에 따라서 페이지 링크가 달라짐(534Line & 595Line 확인해서 링크로 넘어간 페이지 파라미터 받을것.)

var gsChargeCode = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};	//ChargeCode 관련 전역변수
var BsaCodeInfo	= {
	gsReportGubun: '${gsReportGubun}'	//20200804 추가: clip report 추가
};

function appMain() {
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('resultForm',{
		region	: 'center',
		layout	: {type : 'uniTable', columns : 1},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			padding	: '20 0 0 0',
			items	: [{ 
				fieldLabel	: '발생일',
				xtype		: 'uniDatefield',
//				value		: UniDate.get('startOfMonth'),
				width		: 197,
				name		: 'FR_DATE',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '~',
				allowBlank	: false,
				xtype		: 'uniDatefield',
				width		: 127,
				labelWidth	: 18,
				name		: 'TO_DATE',
				value		: UniDate.get('today'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		},{
			fieldLabel	: '사업장',
			name		: 'ACCNT_DIV_CODE',
			xtype		: 'uniCombobox',
			multiSelect	: true, 
			typeAhead	: false,
			value		: UserInfo.divCode,
			comboType	: 'BOR120',
			width		: 325,
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('ACCNT',{
			fieldLabel		: '계정과목',
//			validateBlank	: false,	 
			valueFieldName	: 'ACCNT_CODE',
			textFieldName	: 'ACCNT_NAME',
			child			: 'ITEM',
			autoPopup		: true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
						accntCommonService.fnGetAccntInfo(param, function(provider, response) {
							var dataMap = provider;
							var opt = '1';	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
							UniAccnt.addMadeFields(panelSearch, dataMap, panelSearch, opt);
							UniAccnt.addMadeFields(panelSearch, dataMap, panelSearch, opt);

							panelSearch.down('#formFieldArea1').show();
							panelSearch.down('#serach_ViewPopup1').hide();
						});
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.down('#formFieldArea1').hide();
					panelSearch.down('#serach_ViewPopup1').show();
				},
				applyExtParam:{
					scope	: this,
					fn		: function(popup){
						var param = {
							'ADD_QUERY'		: "SLIP_SW = 'Y' AND GROUP_YN = 'N' AND PEND_YN = 'Y'",
							'CHARGE_CODE'	: (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
						}
						popup.setExtParam(param);
					}
				}
			}
		}),{
			xtype	: 'container',
			itemId	: 'conArea1',
			items	: [{
				xtype	: 'container',
				colspan	: 1,
				itemId	: 'formFieldArea1',
				layout	: {
					type	: 'table', 
					columns	: 1,
					itemCls	: 'table_td_in_uniTable',
					tdAttrs	: {
						width: 350
					}
				}
			}]
		},{
			xtype	: 'container',
			colspan	: 1,
			itemId	: 'serach_ViewPopup1',
			layout	: {
				type	: 'table', 
				columns	: 1,
				itemCls	: 'table_td_in_uniTable',
				tdAttrs	: {
					width: 350
				}
			},
			items:[
				Unilite.popup('ACCNT_PRSN',{
				readOnly		: true,
				fieldLabel		: '미결항목',
				validateBlank	: false
			})]
		 },{
			fieldLabel	: 'ACCNT',
			xtype		: 'uniTextfield',
			name		: 'ACCNT_TEMP',
			hidden		: true
		},{
			fieldLabel	: 'ORG_AC_DATE',
			xtype		: 'uniTextfield',
			name		: 'ORG_AC_DATE_TEMP',
			hidden		: true
		},{
			fieldLabel	: 'ORG_SLIP_NUM',
			xtype		: 'uniTextfield',
			name		: 'ORG_SLIP_NUM_TEMP',
			hidden		: true
		},{
			fieldLabel	: 'ORG_SLIP_SEQ',
			xtype		: 'uniTextfield',
			name		: 'ORG_SLIP_SEQ_TEMP',
			hidden		: true
		},{
			fieldLabel	: 'PEND_DATA_CODE',
			xtype		: 'uniTextfield',
			name		: 'PEND_DATA_CODE_TEMP',
			hidden		: true
		},{
			fieldLabel	: 'J_DATE_FR',
			xtype		: 'uniDatefield',
			name		: 'J_DATE_FR_TEMP',
			hidden		: true
		},{
			fieldLabel	: 'J_DATE_TO',
			xtype		: 'uniDatefield',
			name		: 'J_DATE_TO_TEMP',
			hidden		: true
		},{
			fieldLabel	: '미결구분',
			name		: 'PEND_YN', 
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'A077'
		},{
			fieldLabel		: '반제일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'J_DATE_FR',
			endFieldName	: 'J_DATE_TO',
			width			: 470
		},
		Unilite.popup('DEPT',{
			fieldLabel		: '부서',
			valueFieldName	: 'DEPT_CODE',
			textFieldName	: 'DEPT_NAME'
		}),
		Unilite.popup('DEPT',{
			fieldLabel		: '~',
			valueFieldName	: 'PEND_DEPT_CODE',
			textFieldName	: 'PEND_DEPT_NAME'
		}),{
			fieldLabel	: '잔액기준',
			xtype		: 'checkboxgroup', 
			width		: 400, 
			items		: [{
				boxLabel	: '발생일기준',
				name		: 'CHK_JAN',
				inputValue	: 'Y'
			}]
		},{
			xtype		: 'uniCheckboxgroup',
			fieldLabel	: '출력조건',
			id			: 'printKind',
			items		: [{
				boxLabel		: '계정별 페이지 처리',
				name			: 'CHECK',
				inputValue		: 'Y',
				uncheckedValue	: 'N',
				width			: 150
			}]
		},{
			xtype		: 'button',
			text		: '출력',
			width		: 235,
			tdAttrs		: {'align': 'left', style:'padding-left:95px'},
			handler		: function() {
				UniAppManager.app.onPrintButtonDown();
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
							var popupFC = item.up('uniPopupField') ;
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
						var popupFC = item.up('uniPopupField') ; 
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});



	Unilite.Main({
		id			: 'agb165rkrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelSearch
			]
		}],
		fnInitBinding : function(params) {
			//20200804 추가
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
				//20200804 추가: 미결항목 동적팝업 control로직 추가
				var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
				accntCommonService.fnGetAccntInfo(param, function(provider, response) {
					var dataMap = provider;
					var opt = '1'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
					UniAccnt.addMadeFields(panelSearch, dataMap, null, opt);
					if(!Ext.isEmpty(params.PEND_CODE)){
						panelSearch.setValue('PEND_CODE', params.PEND_CODE);
						panelSearch.setValue('PEND_NAME', params.PEND_NAME);

						panelSearch.down('#formFieldArea1').show();
						panelSearch.down('#serach_ViewPopup1').hide();
					}
				})
			} else {
				this.setDefault();
			}
		},
		setDefault: function() {		// 기본값
			panelSearch.setValue('ACCNT_DIV_CODE', UserInfo.divCode);
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset'	, false);
			UniAppManager.setToolbarButtons('save'	, false);
			panelSearch.onLoadSelectText('FR_DATE');
		},
		//20200804 추가: 링크로 넘어오는 params 받는 부분 
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'agb165skr') {
				panelSearch.setValue('FR_DATE'			, params.FR_DATE);
				panelSearch.setValue('TO_DATE'			, params.TO_DATE);
				panelSearch.setValue('ACCNT_DIV_CODE'	, params.ACCNT_DIV_CODE);
				panelSearch.setValue('ACCNT_CODE'		, params.ACCNT_CODE);
				panelSearch.setValue('ACCNT_NAME'		, params.ACCNT_NAME);
				panelSearch.setValue('PEND_YN'			, params.PEND_YN);
				panelSearch.setValue('J_DATE_FR'		, params.J_DATE_FR);
				panelSearch.setValue('J_DATE_TO'		, params.J_DATE_TO);
				panelSearch.setValue('DEPT_CODE'		, params.DEPT_CODE);
				panelSearch.setValue('DEPT_NAME'		, params.DEPT_NAME);
				panelSearch.setValue('PEND_DEPT_CODE'	, params.PEND_DEPT_CODE);
				panelSearch.setValue('PEND_DEPT_NAME'	, params.PEND_DEPT_NAME);
				panelSearch.getField('CHK_JAN').setValue(params.CHK_JAN);
				panelSearch.getField('CHECK').setValue(params.CHECK);
			}
		},
		onPrintButtonDown: function() {		// 출력 파라미터 넘김
			//20200804 추가: clip report 추가
			if(!this.isValidSearchForm()){
				return false;
			}
			var reportGubun = BsaCodeInfo.gsReportGubun;
			if(reportGubun.toUpperCase() == 'CLIP'){
				var param			= panelSearch.getValues();
				param.PGM_ID		= 'agb165rkr';
				param.MAIN_CODE		= 'A126';
				param.ACCNT_DIV_NAME= panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
				if(Ext.isEmpty(param.ACCNT_DIV_NAME)) {
					param.ACCNT_DIV_NAME = '전체사업장';
				}
				if(!Ext.isEmpty(panelSearch.getValue('ACCNT_DIV_CODE'))) {
					var items = '';
					var divCode = panelSearch.getValue('ACCNT_DIV_CODE');
					Ext.each(divCode, function(item, i) {
						if(i == 0) {
							items = item;
						} else {
							items = items + ',' + item;
						}
					});
					param.ACCNT_DIV_CODE = items;
					param.item = items;
				}
				var win = Ext.create('widget.ClipReport', {
					url			: CPATH+'/accnt/agb165clrkrPrint.do',
					prgID		: 'agb165rkr',
					extParam	: param,
					submitType	: 'POST'
				});
				win.center();
				win.show();
			} else {
				//기존 출력 로직
//				var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
				var params	= Ext.getCmp('resultForm').getValues();
				var divName	= '';
				var prgId	= '';
				if(panelSearch.getValue('ACCNT_DIV_CODE') == '' || panelSearch.getValue('ACCNT_DIV_CODE') == null ){
					divName = Msg.sMAW002;  // 전체
				}else{
					divName = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
				}
	 			if(panelSearch.getValue('CHECK') == 'Y') {
					prgId	  = 'agb166rkr'; 
				} else {
					prgId	  = 'agb165rkr';
				}
				var win = Ext.create('widget.PDFPrintWindow', {
					url		: CPATH+'/agb/agb165rkr.do',
					prgID	: prgId,
					extParam: {
						COMP_CODE		: UserInfo.compCode,
						FR_DATE			: params.FR_DATE,
						TO_DATE			: params.TO_DATE,
						ACCNT_DIV_CODE	: params.ACCNT_DIV_CODE,
						ACCNT_DIV_NAME	: divName,
						ACCNT_CODE		: params.ACCNT_CODE,
						ACCNT_NAME		: params.ACCNT_NAME,
						ACCNT_PRSN		: params.ACCNT_PRSN,
						PEND_YN			: params.PEND_YN,
						J_DATE_FR		: params.J_DATE_FR,
						J_DATE_TO		: params.J_DATE_TO,
						DEPT_CODE		: params.DEPT_CODE,
						DEPT_NAME		: params.DEPT_NAME,
						PEND_DEPT_CODE	: params.PEND_DEPT_CODE,
						PEND_DEPT_NAME	: params.PEND_DEPT_NAME,
						CHECK			: params.CHECK
					}
				});
				win.center();
				win.show();
			}
		}
	});
};
</script>