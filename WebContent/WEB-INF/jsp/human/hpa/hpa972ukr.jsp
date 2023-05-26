<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="hpa972ukr"  >
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore items="${getBussOfficeCode}" storeId="getBussOfficeCode" />
</t:appConfig>

<script type="text/javascript" >

function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm', {		
		region : 'center',
		layout : {type : 'uniTable', columns : 1},
		padding: '1 1 1 1',
		border : true,
		defaults: {labelWidth: 110},
		url: CPATH+'/human/hpa972ukrFileDown.do',
		standardSubmit: true,
		items: [{
			html:'&nbsp;',
			xtype: 'component'
		},{
			fieldLabel	: '신고사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			comboCode	: 'BILL',
			allowBlank	: false
		},{
			fieldLabel	: '소속지점',
			name		: 'BUSS_OFFICE_CODE', 
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('getBussOfficeCode')
		},{
			fieldLabel	: '귀속년월',
			xtype		: 'uniMonthfield',
			name		: 'PAY_YYYYMM',
			value		: UniDate.get('today'),
			allowBlank	: false
		},{
			fieldLabel	: '지급년월',
			xtype		: 'uniMonthfield',
			name		: 'SUPP_YYYYMM',
			value		: UniDate.get('today'),
			allowBlank	: false
		},{
			fieldLabel	: '제출일자',
			name		: 'SUBMIT_DATE',
			xtype		: 'uniDatefield',
	    	value		: UniDate.get('today'),
			allowBlank	: false
		},{
			fieldLabel	: '홈택스 ID',
			name		: 'HOMETAX_ID',
	    	xtype		: 'uniTextfield',
			allowBlank	: true,
			hidden		: true
		},{
	    	xtype		: 'button',
	    	text		: '자료생성',
	    	width		: 150,
	    	margin		: '0 0 0 115',
	    	handler 	: function() {
	    		var panel = Ext.getCmp('resultForm');
				if(!panel.getInvalidMessage()){
					return false;
				}
				
				var param = panel.getValues();
				hpa972ukrService.fnCheckData(param, function(provider, response) {
					if(provider && provider.length > 0) {
						panel.submit({
							params : param
						});
					}
					if(provider && provider.length == 0) { 
						alert('자료생성 할 데이터가 없습니다.');
					}
				});
	    	}
		}]
	});
	
	Unilite.Main( {
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
		id		: 'hpa972ukrApp',
		
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('SUBMIT_DATE',String(UniDate.get('startOfNextMonth')).substring(0, 6) + "10");	//startOfNextMonth
			UniAppManager.setToolbarButtons(['detail', 'reset'], false);
			
			//초기 버튼 위치 세팅
			//panelResult.onLoadSelectText('DIV_CODE');
		}
	});
};

</script>
