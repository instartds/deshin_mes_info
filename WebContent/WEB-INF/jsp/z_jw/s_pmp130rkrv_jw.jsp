<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp130rkrv_jw">
	<t:ExtComboStore comboType="BOR120" />
	<t:ExtComboStore comboType="WU" />	<!-- 작업장  -->
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
		gsReportGubun: '${gsReportGubun}'//클립리포트 추가로 인한 리포트 출력 방식 설정(CR:크리스탈 또는 jasper CLIP:클립리포트)
}

function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm', {
		region: 'center',
		layout: { 
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
			value		: UserInfo.divCode
		}, {
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'WU'/*,
			allowBlank	: false*/
		}, {
			fieldLabel		: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_PRODT_WKORD_DATE',
			endFieldName	: 'TO_PRODT_WKORD_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			width			: 315
		},/* {
			fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			xtype: 'uniTextfield',
			name: 'TOP_WKORD_NUM'
		}, */
		Unilite.popup('WKORD_NUM_JW',{
			fieldLabel		: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			valueFieldName	: 'TOP_WKORD_NUM',
			textFieldName	: 'TOP_WKORD_NUM',
			allowBlank		: false,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('DIV_CODE'				, records[0]["DIV_CODE"]);
						panelResult.setValue('WORK_SHOP_CODE'		, records[0]["WORK_SHOP_CODE"]);
						panelResult.setValue('FR_PRODT_WKORD_DATE'	, records[0]["PRODT_WKORD_DATE"]);
						panelResult.setValue('TO_PRODT_WKORD_DATE'	, records[0]["PRODT_WKORD_DATE"]);
						panelResult.setValue('WK_PLAN_NUM'			, records[0]["WK_PLAN_NUM"]);
					},
					scope: this
				},
				onClear: function(type)	{
//						panelResult.setValue('TOP_WKORD_NUM', '');
//						panelResult.setValue('DIV_CODE', UserInfo.divCode);
//						panelResult.setValue('WORK_SHOP_CODE', '');
//						panelResult.setValue('FR_PRODT_WKORD_DATE', '');
//						panelResult.setValue('TO_PRODT_WKORD_DATE', '');
//						panelResult.setValue('WK_PLAN_NUM', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE'			: panelResult.getValue('DIV_CODE')});
					popup.setExtParam({'WORK_SHOP_CODE'		: panelResult.getValue('WORK_SHOP_CODE')});
					popup.setExtParam({'FR_PRODT_WKORD_DATE': UniDate.getDbDateStr(panelResult.getValue('FR_PRODT_WKORD_DATE'))});
					popup.setExtParam({'TO_PRODT_WKORD_DATE': UniDate.getDbDateStr(panelResult.getValue('TO_PRODT_WKORD_DATE'))});
					popup.setExtParam({'TOP_WKORD_NUM'		: panelResult.getValue('TOP_WKORD_NUM')});
				}
			}
		}),
		{
			fieldLabel	: '<t:message code="system.label.product.productionplanno" default="생산계획번호"/>',
			xtype		: 'uniTextfield',
			name		: 'WK_PLAN_NUM'
		}, {
			xtype		: 'radiogroup',
			fieldLabel	: ' ',
			id			: 'printGubun',
			items		: [{
				boxLabel	: '<t:message code="system.label.product.mfgorderprint" default="제조지시서출력"/>',
				name		: 'printGubun',
				inputValue	: '1',
				width		: 120,
				checked		: true
			}, {
				boxLabel	: '<t:message code="system.label.product.issuerequestprint" default="출고요청서출력"/>',
				name		: 'printGubun',
				inputValue	: '2',
				width		: 120
			}]
		}]
	});


	Unilite.Main({
		id			: 's_pmp130rkrv_jwApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult
			]
		}],
		fnInitBinding: function () {
			panelResult.setValue('DIV_CODE'				, UserInfo.divCode);
			panelResult.setValue('FR_PRODT_WKORD_DATE'	, UniDate.get('startOfMonth'));
			panelResult.setValue('TO_PRODT_WKORD_DATE'	, UniDate.get('today'));
			panelResult.getField('printGubun').setValue("1");
			UniAppManager.setToolbarButtons('print', true);
			UniAppManager.setToolbarButtons('query', false);
		},
		onResetButtonDown: function () {
			panelResult.clearForm();
			this.fnInitBinding();
		},
		onPrintButtonDown: function () {
			if(!panelResult.getInvalidMessage()) return;   //필수체크
			var param = panelResult.getValues();
			var reportGubun = BsaCodeInfo.gsReportGubun;
			var win;
			param["USER_LANG"] = UserInfo.userLang;
			param["PGM_ID"]= PGM_ID;
			param["MAIN_CODE"]= 'Z012';
			param["STXTVALUE2_FILETITLE"]= '작업지시서';
			
			if(Ext.isEmpty(reportGubun) || reportGubun == 'CR'){
				win = Ext.create('widget.CrystalReport', {
					url: CPATH + '/z_jw/s_pmp130crkrv_jw.do',
					prgID: 's_pmp130rkrv_jw',
					extParam: param
				});
			}else if(panelResult.getValue('printGubun').printGubun == '1'){
				win = Ext.create('widget.ClipReport', {
	                url: CPATH+'/z_jw/s_pmp130rkrv1_jw.do',
	                prgID: 's_pmp130rkrv_jw',
	                extParam: param
	            });
			}else if(panelResult.getValue('printGubun').printGubun == '2'){
				win = Ext.create('widget.ClipReport', {
	                url: CPATH+'/z_jw/s_pmp130rkrv2_jw.do',
	                prgID: 's_pmp130rkrv_jw',
	                extParam: param
	            });
			}
			
			
			win.center();
			win.show();
		}
	});
};
</script>