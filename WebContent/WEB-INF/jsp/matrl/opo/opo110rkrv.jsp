<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="opo110rkrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="opo110rkrv"  /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
</t:appConfig>
<script type="text/javascript" >
	function appMain() {
		var panelSearch = Unilite.createSearchForm('searchForm',{
			region: 'center',
				layout : {type : 'uniTable', columns : 1},
				padding:'1 1 1 1',
				border:true,
				items:[
					{
						fieldLabel:'<t:message code="system.label.purchase.division" default="사업장"/>',
						xtype: 'uniCombobox',
						comboType: 'BOR120',
						name:'DIV_CODE',
						allowBlank:false,
						value: UserInfo.divCode
					},{
						fieldLabel:'<t:message code="system.label.purchase.podate" default="발주일"/>',
	            		xtype: 'uniDateRangefield',
	            		startFieldName: 'FR_DATE',
	            		endFieldName:'TO_DATE',
	            		width:315,
	            		startDate: UniDate.get('startOfMonth'),
						endDate: UniDate.get('today')
					},Unilite.popup('AGENT_CUST',{
						fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
						valueFieldName: 'CUSTOM_CODE',
						listeners:{
							onSelected:{fn: function(records, type) {}},scope: this,
							onClear:{fn: function(type) {}}
						}
					}),Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
						valueFieldName: 'ITEM_CODE',
						listeners:{
							onSelected:{fn: function(records, type) {}},scope: this,
							onClear:{fn: function(type) {}}
						}
					}),{
						fieldLabel:'<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
	            		xtype: 'uniDateRangefield',
	            		startFieldName: 'DVRY_DATE_FR',
	            		endFieldName:'DVRY_DATE_TO',
	            		width:315
					},{
						fieldLabel: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>',
						name:'PROGRESS',
						xtype: 'uniCombobox',
						comboType:'AU',
						comboCode:'M002'
					},{
						fieldLabel: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>',
						name: 'WH_CODE', 
						xtype: 'uniCombobox', 
						store: Ext.data.StoreManager.lookup('whList')
					},{
						fieldLabel: '<t:message code="system.label.purchase.reqcalcuno" default="소요량계산번호"/>',
						name: 'MR_PCN', 
						xtype: 'uniTextfield'
					}
				]
		});
		Unilite.Main({
			borderItems:[{
						region:'center',
						layout: 'border',
						border: true,
						items:[
							panelSearch
						]
					}
				],
				id  : 'opo110rkrvApp',
				fnInitBinding : function() {
					UniAppManager.setToolbarButtons('print',true);
					UniAppManager.setToolbarButtons('query',false);
				},
				onResetButtonDown: function() {
					panelSearch.clearForm();
					this.fnInitBinding();
				},
				onPrintButtonDown: function() {
					if(this.onFormValidate()){
						var param = panelSearch.getValues();
							param["10 sTxtValue2_fileTitle"]='발주현황출력';
							param["RPT_ID"]='opo110rkrv';	
						var win = Ext.create('widget.CrystalReport', {
		                    url: CPATH+'/matrl/opo110crkrv.do',
		                    prgID: 'opo100rkrv',
		                    extParam: param
		                });
							win.center();
							win.show();
		        	}
				},
				onFormValidate: function(){
			    	var r= true
			        var invalid = panelSearch.getForm().getFields().filterBy(
			     		function(field) {
							return !field.validate();
						}
				    );
					if(invalid.length > 0) {
						r=false;
						var labelText = ''
						if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
							var labelText = invalid.items[0]['fieldLabel']+':';
						} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
							var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
						}
					   	alert(labelText+'<t:message code="system.label.purchase.required" default="은(는) 필수입력 사항입니다."/>');
					   	invalid.items[0].focus();
					}
					return r;
			    }
		});
	}
</script>