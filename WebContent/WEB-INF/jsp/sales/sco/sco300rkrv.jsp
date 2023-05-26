<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sco300rkrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="sco300rkrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 --> 
</t:appConfig>
<script type="text/javascript">
	function appMain(){
		var panelSearch = Unilite.createSearchForm('searchForm',{
			region: 'center',
				layout : {type : 'uniTable', columns : 2},
				padding:'1 1 1 1',
				border:true,
				items:[{
						xtype: 'radiogroup',		            		
						fieldLabel: '<t:message code="system.label.sales.reporttype" default="보고서유형"/>',
						colspan:2,
						items:[{
							boxLabel: '<t:message code="system.label.sales.clientby" default="고객별"/>', 
							width: 90, 
							name: 'rdoPrintItem',
							inputValue: '1',
							checked: true
						},{
							boxLabel : '<t:message code="system.label.sales.collectionchargeper" default="수금담당별"/>', 
							width: 120,
							name: 'rdoPrintItem',
							inputValue: '2'
						}]
					},{
						fieldLabel:'<t:message code="system.label.sales.collectiondivision" default="수금사업장"/>',
						xtype: 'uniCombobox',
						comboType: 'BOR120',
						name:'DIV_CODE',
						allowBlank:false,
						value: UserInfo.divCode,
		                colspan:2
					},{
						fieldLabel: '<t:message code="system.label.sales.collectioncharge" default="수금담당"/>' ,
		                name: 'SALE_PRSN',
		                xtype: 'uniCombobox',
		                comboType: 'AU',
		                comboCode: 'S010',
		                colspan:2
					},Unilite.popup('AGENT_CUST',{
						fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>',
						valueFieldName: 'CUSTOM_CODE',
						colspan:2
					}),{
						fieldLabel:'<t:message code="system.label.sales.salesdate" default="매출일"/>',
	            		xtype: 'uniDateRangefield',
	            		startFieldName: 'FR_DATE',
	            		endFieldName:'TO_DATE',
	            		width:315,
	            		colspan:2,
	            		startDate: UniDate.get('startOfMonth'),
						endDate: UniDate.get('today')
					},Unilite.popup('PROJECT',{
						fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
						valueFieldName:'PJT_CODE',
						colspan:2
					}),{
						fieldLabel: '<t:message code="system.label.sales.collectioncharge" default="수금담당"/>' ,
		                name: 'COLLECT_TYPE',
		                xtype: 'uniCombobox',
		                comboType: 'AU',
		                comboCode: 'S017',
		                colspan:2
					},{
						fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>' ,
		                name: 'AGENT_TYPE',
		                xtype: 'uniCombobox',
		                comboType: 'AU',
		                comboCode: 'B055',
		                colspan:2
					},{
						fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
		                name: 'AREA_TYPE',
		                xtype: 'uniCombobox',
		                comboType: 'AU',
		                comboCode: 'B056',
		                colspan:2
					},Unilite.popup('AGENT_CUST',{
						fieldLabel: '<t:message code="system.label.sales.collectionplace" default="수금처"/>',
						valueFieldName:'COLET_CUST_CD',
						colspan:2
					}),Unilite.popup('AGENT_CUST',{
						fieldLabel: '<t:message code="system.label.sales.summarycustomer" default="집계고객"/>',
						valueFieldName:'MANAGE_CUSTOM',
						colspan:2
					}),{
						fieldLabel: '<t:message code="system.label.sales.collectionamount" default="수금액"/>',
						xtype:'uniTextfield',
						name:'FR_AMT' 
					}, {
						fieldLabel: '~',
						xtype:'uniTextfield',
						name:'TO_AMT' ,
						labelWidth:8
					},{
	            		xtype: 'radiogroup',		            		
	            		fieldLabel: '<t:message code="system.label.sales.collectionslipyn" default="수금기표여부"/>',            								            		
	            		items: [{
	            			boxLabel : '<t:message code="system.label.sales.whole" default="전체"/>',
	            			name: 'CFM_FLAG',
	            			inputValue: "A",
	            			checked: true ,
	            			width: 50 
	            		}, {
	            			boxLabel : '<t:message code="system.label.sales.slipposting" default="기표"/>',
	            			name: 'CFM_FLAG',
	            			inputValue: "Y", 
	            			width: 50
	            		}, {
	            			boxLabel : '<t:message code="system.label.sales.notslipposting" default="미기표"/>',
	            			name: 'CFM_FLAG' ,
	            			inputValue: "N", 
	            			width: 70
	            		}]
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
				id  : 'sco300rkrvApp',
				fnInitBinding : function() {
                    panelSearch.setValue('rdoPrintItem','1');
                    panelSearch.setValue('DIV_CODE',UserInfo.divCode);
                    panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth'));
                    panelSearch.setValue('TO_DATE', UniDate.get('today'));
                    panelSearch.setValue('CFM_FLAG','A');
                
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
					if(param.rdoPrintItem=='1'){
						param.sPrintFlag = "CUSTOM";
						param.sPrintFlagStr = "고객계";
						param["sTxtValue2_fileTitle"]='수금현황출력(고객계)';
						param["RPT_ID"]='sco300rkrv1';
					}else if(param.rdoPrintItem=='2'){
						param.sPrintFlag = "PRSN";
						param.sPrintFlagStr = "담당계";
						param["sTxtValue2_fileTitle"]='수금현황출력(담당계)';
						param["RPT_ID"]='sco300rkrv2';
					}	
					var win = Ext.create('widget.CrystalReport', {
	                    url: CPATH+'/sales/sco300crkrv.do',
	                    prgID: 'sco300rkrv',
	                    extParam: param
	                });
						win.center();
						win.show();
				}
		});
	}
</script>