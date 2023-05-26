<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa580rkrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="ssa580rkrv"/> 			<!-- 사업장 -->
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
				fieldLabel:'<t:message code="system.label.sales.division" default="사업장"/>',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				name:'DIV_CODE',
				allowBlank:false,
				value: UserInfo.divCode,
				colspan:2
			},{
				fieldLabel:'<t:message code="system.label.sales.issuedate" default="출고일"/>',
        		xtype: 'uniDateRangefield',
        		startFieldName: 'FR_DATE',
        		endFieldName:'TO_DATE',
        		width:315,
        		startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				colspan:2
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>',
				valueFieldName: 'CUSTOM_CODE',
				colspan:2
			}),
			{
				fieldLabel: '<t:message code="system.label.sales.billtype" default="계산서종류"/>' ,
                name: 'BILL_TYPE',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B066',
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
			},
			Unilite.popup('CUST',{
				fieldLabel: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>',
				valueFieldName:'MANAGE_CUSTOM',
				textFieldName:'MCUSTOM_NAME',
			    DBvalueFieldName:'CUSTOM_CODE',
			    DBtextFieldName:'CUSTOM_NAME',	
			    colspan:2
		  	}),
		  	{
				xtype: 'uniNumberfield',
				fieldLabel: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'	,
				name: 'FROM_AMT' 
			}, {
				xtype: 'uniNumberfield',
	 	    	fieldLabel: '~',
	 	    	name: 'TO_AMT',
	 	    	labelWidth:8
	 	    },{
        		xtype: 'radiogroup',		            		
        		fieldLabel: '<t:message code="system.label.sales.autoslipyn" default="자동기표여부"/>',            								            		
        		items: [{
        			boxLabel : '<t:message code="system.label.sales.whole" default="전체"/>',
        			name: 'SLIP_YN',
        			inputValue: "A",
        			checked: true ,
        			width: 50 
        		}, {
        			boxLabel : '<t:message code="system.label.sales.slipposting" default="기표"/>',
        			name: 'SLIP_YN',
        			inputValue: "Y", 
        			width: 50
        		}, {
        			boxLabel : '<t:message code="system.label.sales.notslipposting" default="미기표"/>',
        			name: 'SLIP_YN' ,
        			inputValue: "N", 
        			width: 70
        		}]
        	}]
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
			id  : 'ssa580rkrvApp',
			fnInitBinding : function() {
                panelSearch.setValue('DIV_CODE',UserInfo.divCode);
                panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth'));
                panelSearch.setValue('TO_DATE', UniDate.get('today'));
                panelSearch.setValue('SLIP_YN','A');
                
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
					param["sTxtValue2_fileTitle"]='<t:message code="system.label.sales.taxinvoiceissuedstatus" default="세금계산서발행현황"/>';
					param["RPT_ID"]='ssa580rkrv';	
				var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/sales/ssa580crkrv.do',
                    prgID: 'ssa580rkrv',
                    extParam: param
                });
					win.center();
					win.show();
			}
		});
	}
</script>