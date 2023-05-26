<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="had840rkr"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="had910rkr" /><!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식-->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 급여지급일구분-->
	<t:ExtComboStore comboType="AU" comboCode="A074" /> <!-- 귀속분기-->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	var getYear = UniHuman.getTaxReturnYear();

 	Ext.create('Ext.data.Store',{storeId: "retrTypeStore",
		data:[
			{text: '중도퇴사', value: 'Y'},
			{text: '연말정산', value: 'N'}
		]
	});
	/* Ext.create('Ext.data.Store',{
		storeId: "retrTypeStore",
		data:[
			{text: '중도퇴사', value: 'Y'},
			{text: '연말정산', value: 'N'}
		]
	}); */

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'west',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items: [{
			xtype: 'radiogroup',
			fieldLabel: '출력선택',
			itemId: 'RADIO4',
			labelWidth: 90,
			items: [{
				boxLabel: '발행자보고용',
				width: 120,
				name: 'OUT_PUT',
				inputValue: '0',
				checked: true
			},{
				boxLabel: '소득자용',
				width: 110,
				name: 'OUT_PUT',
				inputValue: '1'
			},{
				boxLabel: '발행자보관용',
				width: 140,
				name: 'OUT_PUT',
				inputValue: '2'
			}]
		},{
			fieldLabel: '정산구분',
			name:'RETR_TYPE',
			xtype: 'uniCombobox',
			//sMHC08
			store: Ext.data.StoreManager.lookup('retrTypeStore'),
			width:325,
			value:'N',
			allowBlank:false
		},{
			fieldLabel: '정산년도',
			name: 'YEAR_YYYY',
			//xtype: 'uniYearField',
			xtype: 'uniTextfield',
			value: UniHuman.getTaxReturnYear(),
			allowBlank: false,
			fieldStyle: 'text-align: center;',
			width: 195,
			listeners: {
				blur: function(field) {
					newValue = field.getValue();
					if (newValue == ''){
						panelResult.setValue('YEAR_YYYY', UniHuman.getTaxReturnYear());
						return false;
					}else if (newValue <= '2015'){
						alert("정산년도는 2016년 이상만 선택하실 수 있습니다.");
						panelResult.setValue('YEAR_YYYY', UniHuman.getTaxReturnYear());
						return false;
					}
				},
				change: function(field, newValue, oldValue, eOpts) {
					getYear = newValue;
				}
			}
		},{
			fieldLabel:'지급년월',
			xtype:'uniDateRangefield',
			startFieldName:'PAYFRYYMM',
			endFieldName:'PAYTOYYMM',
			width:325
			//allowBlank:false
//			startDate:UniDate.get('startOfMonth'),
//			endDate:UniDate.get('today')
		},{
			fieldLabel:'퇴사일자',
			xtype:'uniDateRangefield',
			startFieldName:'FRRETIREDATE',
			endFieldName:'TORETIREDATE',
			width:325
			//allowBlank:false
//			startDate:UniDate.get('startOfMonth'),
//			endDate:UniDate.get('today')
		},{
			fieldLabel: '영수년월일',
			xtype: 'uniDatefield',
			name: 'RECE_DATE',
			value: UniDate.get('today'),
			allowBlank: false,
			width: 325
		},{
			fieldLabel: '신고사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			width:325,
			multiSelect: false,
			typeAhead: false,
			comboType:'BOR120',
			width: 325
		},
		Unilite.popup('DEPT',{
			colspan: 1,
			fieldLabel: '부서',
			valueFieldName:'FR_DEPT_CODE',
			textFieldName:'FR_DEPT_NAME',
			validateBlank:false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
					panelResult.setValue('FR_DEPT_CODE', '');
					panelResult.setValue('FR_DEPT_NAME', '');
				}
			}
		}),
		Unilite.popup('DEPT',{
			fieldLabel: '~',
			colspan: 1,
			valueFieldName:'TO_DEPT_CODE',
			textFieldName:'TO_DEPT_NAME',
			validateBlank:false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
					panelResult.setValue('TO_DEPT_CODE', '');
					panelResult.setValue('TO_DEPT_NAME', '');
				}
			}
		}),{
			fieldLabel: '급여지급방식',
			name:'PAY_CODE',
			xtype: 'uniCombobox',
			width:325,
			comboType: 'AU',
			comboCode: 'H028'
		},{
			fieldLabel: '지급차수',
			name:'PAY_PROV_FLAG',
			xtype: 'uniCombobox',
			width:325,
			comboType: 'AU',
			comboCode: 'H031'
		},
		Unilite.popup('Employee',{
			fieldLabel: '사원',
			valueFieldName:'PERSON_NUMB',
			textFieldName:'NAME',
			allowBlank: true,
			validateBlank:false,
			autoPopup:true,
			id : 'PERSON_NUMB',
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
					panelResult.setValue('PERSON_NUMB', '');
					panelResult.setValue('NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'BASE_DT': '00000000'});
				}
			}
		}),{
			xtype:'button',
			text:'출	력',
			width:235,
			tdAttrs:{'align':'left', style:'padding-left:95px'},
			handler:function()	{
				if(panelResult.isValid()){
					UniAppManager.app.onPrintButtonDown();
				}
			}
		}]
	});



	Unilite.Main({
		id			: 'had840rkrApp',
		border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult
			]
		}],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
		},
		onPrintButtonDown: function() {
			var param = Ext.getCmp('resultForm').getValues();			// 하단 검색조건
			param.OUTPUT	= param.OUT_PUT;
			//20200708 추가: 직인 이미지 공통코드에서 가져와서 출력하도록 수정 - default = company_steamp.png
			param.PGM_ID	= 'had840rkr';
			param.MAIN_CODE	= 'H184';

			var yy = param.YEAR_YYYY;
			var win;
			if(yy < 2018) {
				win = Ext.create('widget.CrystalReport', {
					url: CPATH+'/human/had840crkr.do',
					prgID: 'had840rkr',
					extParam: param
				});
			}
			else if(yy == 2018) {
				win = Ext.create('widget.ClipReport', {
					url: CPATH+'/human/had840clrkr.do',
					prgID: 'had840rkr',
					extParam: param
				});
			}
			else {
				win = Ext.create('widget.ClipReport', {
					url: CPATH+'/human/had840clrkrv.do',
					prgID: 'had840rkr',
					extParam: param
				});
			}
			win.center();
			win.show();
		}
	}); //End of 	Unilite.Main( {
};
</script>