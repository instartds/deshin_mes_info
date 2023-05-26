<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp130rkrv">
	<t:ExtComboStore comboType="BOR120" />
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore comboType="W"/> <!-- 작업장 (전체)-->
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
			region: 'center',
			layout: { 
				type: 'uniTable',
				columns: 1
			},
			padding: '1 1 1 1',
			border: true,
			items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE','');
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType:'W',
//				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						store.clearFilter();

						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == panelResult.getValue('DIV_CODE');
							});
						}else{
							store.filterBy(function(record){
								return false;   
							});
						}
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE',
				endFieldName: 'PRODT_END_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank: false
			},
				//{
//				fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
//				xtype: 'uniTextfield',
//				name: 'WKORD_NUM'
//			},
			Unilite.popup('WKORD_NUM',{ 
					fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
					textFieldName:'WKORD_NUM',
					listeners: {
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							popup.setExtParam({'WORK_SHOP_CODE': panelResult.getValue('WORK_SHOP_CODE')});
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.product.productionplanno" default="생산계획번호"/>',
				xtype: 'uniTextfield',
				name: 'WK_PLAN_NUM'
			}, {
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.product.processstatus" default="진행상태"/>',
				id: 'rdoSelect',
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 70,
					name: 'CONTROL_STATUS',
					inputValue: '1'
				}, {
					boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
					width: 70,
					inputValue: '2',
					name: 'CONTROL_STATUS',
					checked: true
				}, {
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
					width: 70,
					inputValue: '9',
					name: 'CONTROL_STATUS'
				}, {
					boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
					width: 70,
					inputValue: '8',
					name: 'CONTROL_STATUS'
				}]
			},{
				xtype: 'radiogroup',
				fieldLabel: '구분',
				id: 'PRINT_GUBUN',
				items: [{
					boxLabel: '작지별',
					width: 70,
					name: 'selectedValue',
					inputValue: '1',
					checked: true
				}, {
					boxLabel: '작업장별',
					width: 70,
					inputValue: '2',
					name: 'selectedValue'
				}]
			}]
		});


		Unilite.Main({
			id: 'pmp130rkrvApp',
			borderItems: [{
				region: 'center',
				layout: 'border',
				border: false,
				items: [
					panelResult
				]
			}],
			fnInitBinding: function () {
				panelResult.setValue('DIV_CODE', UserInfo.divCode);
				panelResult.setValue('PRODT_START_DATE', UniDate.get('today'));
				panelResult.setValue('PRODT_END_DATE', UniDate.get('today'));
				//panelResult.getField('sPrintFlag').setValue("WKORDNUM");
				panelResult.getField('rdoSelect').setValue("2");
				UniAppManager.setToolbarButtons('print', true);
				UniAppManager.setToolbarButtons('query', false);
			},
			onResetButtonDown: function () {
				panelResult.clearForm();
				this.fnInitBinding();
			},
			onPrintButtonDown: function () {
				if(!panelResult.getInvalidMessage()) return;   //필수체크
				
				if(panelResult.getValue('selectedValue') == '1'){
					if(Ext.isEmpty(panelResult.getValue('WORK_SHOP_CODE'))){
						Unilite.messageBox('작업장은(는) 필수입력 항목입니다.');
						return;
					}
				}
				var param = panelResult.getValues();
				
				param["USER_LANG"] = UserInfo.userLang;
				param["PGM_ID"]= PGM_ID;
				param["MAIN_CODE"] = 'P010';  //생산용 공통 코드
				param["sTxtValue2_fileTitle"]='작업지시서';
				
				var win = null;
				if(BsaCodeInfo.gsReportGubun == 'CLIP'){
					if(panelResult.getValue("PRINT_GUBUN").selectedValue == "2") {
						param["sTxtValue2_fileTitle"]='작 업 지 시 서';
						
						win = Ext.create('widget.ClipReport', {
							url: CPATH+'/prodt/pmp130clrkrv_2.do',
							prgID: 'pmp130rkrv',
							extParam: param
						});
					}else {
						win = Ext.create('widget.ClipReport', {
							url: CPATH+'/prodt/pmp130clrkrv.do',
							prgID: 'pmp130rkrv',
							extParam: param
						});
					}
				}else{
					win = Ext.create('widget.CrystalReport', {
						url: CPATH + '/prodt/pmp130crkrv.do',
						prgID: 'pmp130rkrv',
						extParam: param
					});
				}
	
				win.center();
				win.show();
			}
		});
	};
</script>