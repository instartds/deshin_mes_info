<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mpo150rkrv_jw"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_mpo150rkrv_jw"  /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var BsaCodeInfo = {
		gsReportGubun: '${gsReportGubun}'//클립리포트 추가로 인한 리포트 출력 방식 설정(CR:크리스탈 또는 jasper CLIP:클립리포트)
}
function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'center',
//    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items: [{
	    	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
	    	name:'DIV_CODE',
	    	xtype: 'uniCombobox',
	    	comboType:'BOR120',
	    	allowBlank:false,
	    	value: UserInfo.divCode
    	},{
    		fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
    		xtype: 'uniDateRangefield',
    		startFieldName: 'ORDER_DATE_FR',
    		endFieldName: 'ORDER_DATE_TO',
    		startDate: UniDate.get('startOfMonth'),
    		endDate: UniDate.get('today'),
    		width:315
		},{
	    	fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
	    	name:'ORDER_TYPE',
	    	xtype: 'uniCombobox',
	    	comboType:'AU',
	    	comboCode:'M001',

	    	value: UserInfo.divCode
    	},
    	Unilite.popup('CUST',{
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			textFieldWidth: 130
		}),
		Unilite.popup('DIV_PUMOK', {
			fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			textFieldWidth: 130
//					validateBlank: false,
		}),
		{
        	fieldLabel: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
        	xtype: 'uniDateRangefield',
        	startFieldName: 'DVRY_DATE_FR',
        	endFieldName: 'DVRY_DATE_TO',
        	width: 315
		},{
			fieldLabel: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>',
			name:'CONTROL_STATUS',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M002'
		},{
			fieldLabel: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('whList')
		},{
			fieldLabel: '<t:message code="system.label.purchase.pono" default="발주번호"/>',
			xtype:'uniTextfield',
			name:'ORDER_NUM'
		}]
    });


    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult
			]
		}
		],
		id  : 's_mpo150rkrv_jwApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO',UniDate.get('today'));
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			UniAppManager.setToolbarButtons('print',true);
			UniAppManager.setToolbarButtons('query',false);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			this.fnInitBinding();
		},
        onPrintButtonDown: function() {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
			var param = panelResult.getValues();
			
            param["USER_LANG"] = UserInfo.userLang;
            param["PGM_ID"]= PGM_ID;
            param["MAIN_CODE"] = 'M030';  //구매용 공통 코드
            param["sTxtValue2_fileTitle"]='발 주 서';
            var win = null;
            if(BsaCodeInfo.gsReportGubun == 'CLIP'){
	        	win = Ext.create('widget.ClipReport', {
	                url: CPATH+'/z_jw/s_mpo150clrkrv_jw.do',
	                prgID: 's_mpo150rkrv_jw',
	                extParam: param
	            });
            }else{
	        	win = Ext.create('widget.CrystalReport', {
	            	url: CPATH+'/matrl/mpo150crkrv.do',
	            	prgID: 's_mpo150rkrv_jw',
	            	extParam: param
				});
            }
			win.center();
			win.show(); 	
		}
	});
};

</script>
