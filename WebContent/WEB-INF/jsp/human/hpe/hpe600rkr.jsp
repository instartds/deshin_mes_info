<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="hpe600rkr">
	<t:ExtComboStore comboType="BOR120"	pgmId="hpe600rkr"/>			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU"  	comboCode="H222"/>			<!-- 전산매체유형 -->
</t:appConfig>

<script type="text/javascript" >
function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm', {		
		region : 'center',
		layout : {type : 'uniTable', columns : 1},
		padding: '1 1 1 1',
		border : true,
        defaults: {labelWidth: 100},
		items: [{
			html:'&nbsp;',
			xtype: 'component'
		},{
			fieldLabel: '출력선택',
			name:'PRINT_OPT',
			xtype: 'uniRadiogroup',
			allowBlank:false,
			items: [{
				boxLabel: '지급자보관용',
				width: 110,
				inputValue: '1',
				checked: true
			},{
				boxLabel : '지급자제출용',
				width: 100,
				inputValue: '2'
			}]
		},{
			fieldLabel: '명세서 종류',
			name:'PRINT_TYPE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'H222',
			allowBlank:false
		},{
			fieldLabel: '정산년도',
			xtype: 'uniYearField',
			name: 'YEAR_YYYY',
			allowBlank:false
		},{
			xtype: 'radiogroup',
			fieldLabel: '반기구분',
			id:'rdoHalfYearR',
			allowBlank:false,
			items: [{
				boxLabel: '상반기',
				width: 70,
				name: 'HALF_YEAR',
				inputValue: '1'
			},{
				boxLabel : '하반기',
				width: 70,
				name: 'HALF_YEAR',
				inputValue: '2'
			}]
		},{
			fieldLabel: '신고사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120'
		},{
			fieldLabel: '제출일',
			name:'SUBMIT_DATE',
			xtype: 'uniDatefield',
			allowBlank:false,
	    	value: UniDate.get('today')
		},{
	    	xtype: 'button',
	    	text: '출력',
	    	width: 150,
	    	margin: '0 0 0 105',
	    	handler : function() {
	    		UniAppManager.app.onPrintButtonDown();
	    	}
		}]
	});
	
	
	Unilite.Main({
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult
			]}
		],
		uniOpt: {
			//showToolbar: false
		},
		id : 'hpe600rkrApp',
		fnInitBinding : function() {
			panelResult.setValue('PRINT_TYPE', '1');
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('YEAR_YYYY', UniDate.add(UniDate.today(),{'months':-1} ).getFullYear());
			
			var month = Ext.Date.format(UniDate.add(UniDate.today(),{'months':-1} ),'n');
			var halfYear = "1";
			if(month > 6)	{
				halfYear="2";
			}
			panelResult.getField('HALF_YEAR').setValue(halfYear);
			
			UniAppManager.setToolbarButtons(['query','reset'],false);
		},
		onResetButtonDown: function() {
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
    		var panel = Ext.getCmp('resultForm');
    		
			if(!panel.getInvalidMessage()){
				return false;
			}
			var param = panel.getValues();
			
            param.PGM_ID = 'hpe600rkr';  //프로그램ID
            param.sTxtValue2_fileTitle = '근로소득간이지급명세서';
            
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/human/hpe600clrkrv.do',
				prgID: 'hpe600rkr',
				extParam: param
			});
            win.center();
            win.show();
		}
	});
}
</script>
