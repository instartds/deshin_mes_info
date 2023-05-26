<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa590rkrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="ssa590rkrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 --> 
</t:appConfig>
<script type="text/javascript">
	function appMain(){
		var panelSearch = Unilite.createSearchForm('searchForm',{
				region: 'center',
				layout : {type : 'uniTable', columns : 1},
				padding:'1 1 1 1',
				border:true,
				items:[
					{
						fieldLabel:'<t:message code="system.label.sales.division" default="사업장"/>',
						xtype: 'uniCombobox',
						comboType: 'BOR120',
						name:'DIV_CODE',
						allowBlank:false,
						value: UserInfo.divCode
					},{
						fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>' ,
		                name: 'SALE_PRSN',
		                xtype: 'uniCombobox',
		                comboType: 'AU',
		                comboCode: 'S010'
					},{
						fieldLabel:'<t:message code="system.label.sales.salesdate" default="매출일"/>',
	            		xtype: 'uniDateRangefield',
	            		startFieldName: 'FR_DATE',
	            		endFieldName:'TO_DATE',
	            		width:315,
	            		startDate: UniDate.get('startOfMonth'),
						endDate: UniDate.get('today')
					},Unilite.popup('AGENT_CUST',{
						fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>',
						valueFieldName: 'CUSTOM_CODE'
					}),{
						fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>' ,
		                name: 'AGENT_TYPE',
		                xtype: 'uniCombobox',
		                comboType: 'AU',
		                comboCode: 'B055'
					},{
						fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
		                name: 'AREA_TYPE',
		                xtype: 'uniCombobox',
		                comboType: 'AU',
		                comboCode: 'B056'
					}
				]
			
			})
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
			id  : 'ssa590rkrvApp',
			fnInitBinding : function() {
			    panelSearch.setValue('DIV_CODE',UserInfo.divCode);
                panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth'));
                panelSearch.setValue('TO_DATE', UniDate.get('today'));
				UniAppManager.setToolbarButtons('print',true);
				UniAppManager.setToolbarButtons('query',false);
			},
			onResetButtonDown: function() {
				panelSearch.clearForm();
				this.fnInitBinding();
			},
			onPrintButtonDown: function() {
                if(!panelSearch.getInvalidMessage()) return;   //필수체크
					var param = panelSearch.getValues();
					 
						param["sTxtValue2_fileTitle"]='세금계산서 미발행현황';
						param["RPT_ID"]='ssa590rkrv';	
					var win = Ext.create('widget.CrystalReport', {
	                    url: CPATH+'/sales/ssa590crkrv.do',
	                    prgID: 'ssa590rkrv',
	                    extParam: param
	                });
						win.center();
						win.show();
	        	
			}
		});
	}
</script>