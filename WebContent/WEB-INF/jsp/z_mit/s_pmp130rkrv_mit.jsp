<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp130rkrv_mit">
	<t:ExtComboStore comboType="BOR120" />
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />	<!-- 작업장 -->
	<t:ExtComboStore comboType="W"/>								<!-- 작업장 (전체)-->

	<style type="text/css">
		#search_panel1 .x-panel-header-text-container-default {
			color: #333333;
			font-weight: normal;
			padding: 1px 2px;
		}
	</style>
</t:appConfig>

<script type="text/javascript">
var BsaCodeInfo = {
	gsReportGubun : '${gsReportGubun}'	// 레포트 구분
};
function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm', {
		region	: 'center',
		layout	: { 
			type	: 'uniTable',
			columns	: 1
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_SHOP_CODE','');
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'W',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts )   {
					var store = queryPlan.combo.store;
					store.clearFilter();

					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
					} else {
						store.filterBy(function(record){
							return false;   
						});
					}
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'PRODT_START_DATE',
			endFieldName	: 'PRODT_END_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			width			: 315,
			allowBlank		: false
		},
		//20200302 수정: 팝업으로 변경
		Unilite.popup('WKORD_NUM',{ 
			fieldLabel		: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			textFieldName	: 'WKORD_NUM',
			listeners		: {
				applyextparam: function(popup){
					if(!panelResult.getInvalidMessage()) return false;	//필수체크
					popup.setExtParam({'DIV_CODE'		: panelResult.getValue('DIV_CODE')});
					popup.setExtParam({'WORK_SHOP_CODE'	: panelResult.getValue('WORK_SHOP_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.product.productionplanno" default="생산계획번호"/>',
			xtype		: 'uniTextfield',
			name		: 'WK_PLAN_NUM'
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.product.processstatus" default="진행상태"/>',
			id			: 'rdoSelect',
			items		: [{
				boxLabel	: '<t:message code="system.label.product.whole" default="전체"/>',
				width		: 70,
				name		: 'rdoSelect',
				inputValue	: '1'
			},{
				boxLabel	: '<t:message code="system.label.product.process" default="진행"/>',
				width		: 70,
				inputValue	: '2',
				name		: 'rdoSelect',
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.product.completion" default="완료"/>',
				width		: 70,
				inputValue	: '3',
				name		: 'rdoSelect'
			},{
				boxLabel	: '<t:message code="system.label.product.closing" default="마감"/>',
				width		: 70,
				inputValue	: '4',
				name		: 'rdoSelect'
			}],
			listeners: {
				change: function (field, newValue, oldValue, eOpts) {
					if (newValue.rdoSelect == "1") {
						panelResult.setValue("WORK_END_YN"		, '')
						panelResult.setValue("CONTROL_STATUS"	, '')
					}
					if (newValue.rdoSelect == "2") {
						panelResult.setValue("WORK_END_YN"		, 'N')
						panelResult.setValue("CONTROL_STATUS"	, '2')
					}
					if (newValue.rdoSelect == "3") {
						panelResult.setValue("WORK_END_YN"		, 'Y')
						panelResult.setValue("CONTROL_STATUS"	, '9')
					}
					if (newValue.rdoSelect == "4") {
						panelResult.setValue("WORK_END_YN"		, 'N')
						panelResult.setValue("CONTROL_STATUS"	, '8')
					}
				}
			}
		},{
			fieldLabel	: ' ',
			xtype		: 'uniTextfield',
			name		: 'WORK_END_YN',
			hidden		: true
		},{
			fieldLabel	: ' ',
			xtype		: 'uniTextfield',
			name		: 'CONTROL_STATUS',
			hidden		: true
		},{
			xtype		: 'button',
			text		: '작업지시서출력',
			disabled	: false,
			width		: 190,
			margin		: '0 0 0 95',
			handler		: function(){
				if(!panelResult.getInvalidMessage()) return;   //필수체크

				var param = panelResult.getValues();
				s_pmp110ukrv_mitService.dataCheck(param, function(provider, response){
					if(Ext.isEmpty(provider)){
						Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
					} else {
						param["USER_LANG"] = UserInfo.userLang;
						param["PGM_ID"]= PGM_ID;
						param["MAIN_CODE"] = 'P010';  //생산용 공통 코드
						param["sTxtValue2_fileTitle"]='작업지시서';
						
						var win = null;
					
						s_pmp110ukrv_mitService.selectFormType(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								if(provider.FORM_TYPE == 'S'){	//사이트용
									param["SHIFT_CD"] = provider.SHIFT_CD; //작업조코드
									win = Ext.create('widget.ClipReport', {
										url: CPATH+'/z_mit/s_pmp110clukrv_mit.do',
										prgID: 's_pmp110ukrv_mit',
										extParam: param
									});
									win.center();
									win.show();
								} else {	//정규
									if(BsaCodeInfo.gsReportGubun == 'CLIP'){
										win = Ext.create('widget.ClipReport', {
											url: CPATH+'/prodt/pmp110clrkrv.do',
											prgID: 'pmp110ukrv',
											extParam: param
										});
									} else {
										win = Ext.create('widget.CrystalReport', {
											url: CPATH + '/prodt/pmp110crkrv.do',
											extParam: param
										});
									}
									win.center();
									win.show();
								}
							} else {
								//정규
								if(BsaCodeInfo.gsReportGubun == 'CLIP'){
									win = Ext.create('widget.ClipReport', {
										url: CPATH+'/prodt/pmp110clrkrv.do',
										prgID: 'pmp110ukrv',
										extParam: param
									});
								} else {
									win = Ext.create('widget.CrystalReport', {
										url: CPATH + '/prodt/pmp110crkrv.do',
										extParam: param
									});
								}
								win.center();
								win.show();
							}
						});	
						
					}
				});
			}
		},{
			xtype	: 'button',
			text	: '태그출력',
			disabled: false,
			width	: 190,
			margin	: '0 0 0 95',
			handler	: function(){
				if(!panelResult.getInvalidMessage()) return;   //필수체크
				var param = panelResult.getValues();
				s_pmp110ukrv_mitService.dataCheck(param, function(provider, response){
					if(Ext.isEmpty(provider)){
						Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
					} else {
						param["USER_LANG"]	= UserInfo.userLang;
						param["ARR_GUBUN"]	= "N";
						param["PGM_ID"]		= PGM_ID;
						param["MAIN_CODE"]	= 'P010';  //생산용 공통 코드
						param["sTxtValue2_fileTitle"]='';
						var win = null;
						win = Ext.create('widget.ClipReport', {
							url: CPATH+'/z_mit/s_pmp110clukrv2_mit.do',
							prgID: 's_pmp110ukrv_mit',
							extParam: param
						});
						win.center();
						win.show();
					}
				});
			}  
		}]
	});


	Unilite.Main({
		id			: 's_pmp130rkrv_mitApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult
			]
		}],
		fnInitBinding: function () {
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('PRODT_START_DATE'	, UniDate.get('today'));
			panelResult.setValue('PRODT_END_DATE'	, UniDate.get('today'));
			//panelResult.getField('sPrintFlag').setValue("WKORDNUM");
			panelResult.getField('rdoSelect').setValue("2");
			panelResult.getField('CONTROL_STATUS').setValue("2");
			panelResult.getField('WORK_END_YN').setValue("N");
			UniAppManager.setToolbarButtons('print', false);
			UniAppManager.setToolbarButtons('query', false);
		},
		onResetButtonDown: function () {
			panelResult.clearForm();
			this.fnInitBinding();
		},
		onPrintButtonDown: function () {
			if(!panelResult.getInvalidMessage()) return;   //필수체크
			var param = panelResult.getValues();
			
			param["USER_LANG"] = UserInfo.userLang;
			param["PGM_ID"]= PGM_ID;
			param["MAIN_CODE"] = 'P010';  //생산용 공통 코드
			param["sTxtValue2_fileTitle"]='작업지시서';
			
			var win = null;
			s_pmp110ukrv_mitService.selectFormType(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					if(provider.FORM_TYPE == 'S'){	//사이트용
						param["SHIFT_CD"] = provider.SHIFT_CD; //작업조코드
						win = Ext.create('widget.ClipReport', {
							url: CPATH+'/z_mit/s_pmp110clukrv_mit.do',
							prgID: 's_pmp110ukrv_mit',
							extParam: param
						});
						win.center();
						win.show();
					} else {	//정규
						if(BsaCodeInfo.gsReportGubun == 'CLIP'){
							win = Ext.create('widget.ClipReport', {
								url: CPATH+'/prodt/pmp110clrkrv.do',
								prgID: 'pmp110ukrv',
								extParam: param
							});
						} else {
							win = Ext.create('widget.CrystalReport', {
								url: CPATH + '/prodt/pmp110crkrv.do',
								extParam: param
							});
						}
						win.center();
						win.show();
					}
				} else {
					//정규
					if(BsaCodeInfo.gsReportGubun == 'CLIP'){
						win = Ext.create('widget.ClipReport', {
							url: CPATH+'/prodt/pmp110clrkrv.do',
							prgID: 'pmp110ukrv',
							extParam: param
						});
					} else {
						win = Ext.create('widget.CrystalReport', {
							url: CPATH + '/prodt/pmp110crkrv.do',
							extParam: param
						});
					}
					win.center();
					win.show();
				}
			});	
			
		},
		onDirectPrintButtonDown: function() { // 인쇄 버튼 handler : 미리보기 없이 인쇄
			if(!panelResult.getInvalidMessage()) return;	//필수체크

			if(Ext.isEmpty(panelResult.getValue('WKORD_NUM'))){
				Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
				return;
			}
			var param = panelResult.getValues();
			s_pmp110ukrv_mitService.selectFormType(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					if(provider.FORM_TYPE == 'S'){	//사이트용
						param["SHIFT_CD"] = provider.SHIFT_CD; //작업조코드
						win = Ext.create('widget.ClipReport', {
							url: CPATH+'/z_mit/s_pmp110clukrv_mit.do',
							prgID: 's_pmp110ukrv_mit',
							uniOpt:{
								directPrint:true
							},
							extParam: param
						});
						
						win.center();
						win.show();
					} else {	//정규
						win = Ext.create('widget.ClipReport', {
							url: CPATH+'/prodt/pmp110clrkrv.do',
							prgID: 'pmp110ukrv',
							uniOpt:{
								directPrint:true
							},
							extParam: param
						});
						win.center();
						win.show();
					}
				} else {
					//정규
					win = Ext.create('widget.ClipReport', {
						url: CPATH+'/prodt/pmp110clrkrv.do',
						prgID: 'pmp110ukrv',
						uniOpt:{
							directPrint:true
						},
						extParam: param
					});
					win.center();
					win.show();
				}
			});
		}
	});  
};
</script>