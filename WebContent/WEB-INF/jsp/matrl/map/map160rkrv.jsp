<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map160rkrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="map160rkrv"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
</t:appConfig>
<script type="text/javascript" >
	function appMain() {
		var panelSearch = Unilite.createSearchForm('searchForm',{
			region: 'center',
			layout : {type : 'uniTable', columns : 1},
			padding:'1 1 1 1',
			border:true,
			items:[{
				fieldLabel:'<t:message code="system.label.purchase.purchasedivision" default="매입사업장"/>',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				name:'DIV_CODE',
				allowBlank:false,
				value: UserInfo.divCode
			},{
				fieldLabel:'<t:message code="system.label.purchase.salesdate" default="매출일"/>',
        		xtype: 'uniDateRangefield',
        		startFieldName: 'FR_DATE',
        		endFieldName:'TO_DATE',
        		width:315,
        		startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_CODE', '');
								}
							},
				            applyextparam: function(popup){
				                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				            	}
					}
			}),{
				fieldLabel:'<t:message code="system.label.purchase.exdate" default="결의일"/>',
        		xtype: 'uniDateRangefield',
        		startFieldName: 'BASIS_DT_FA',
        		endFieldName:'BASIS_DT_TO',
        		width:315
			},
			Unilite.popup('DEPT',{
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
				valueFieldName: 'DEPT_CODE',
                textFieldName: 'DEPT_NAME'
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>', 
				name: 'ORDER_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M001'
			},{
        		xtype: 'radiogroup',		            		
        		fieldLabel: '<t:message code="system.label.purchase.autoslipyn" default="자동기표여부"/>',            								            		
        		items: [{
        			boxLabel : '<t:message code="system.label.purchase.whole" default="전체"/>',
        			name: 'rdoSelect',
        			inputValue: "A",
        			checked: true ,
        			width: 50 
        		}, {
        			boxLabel : '<t:message code="system.label.purchase.slipposting" default="기표"/>',
        			name: 'rdoSelect',
        			inputValue: "Y", 
        			width: 50
        		}, {
        			boxLabel : '<t:message code="system.label.purchase.notslipposting" default="미기표"/>',
        			name: 'rdoSelect' ,
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
			}],
			id  : 'map160rkrvApp',
			fnInitBinding : function() {
                panelSearch.setValue('DIV_CODE',UserInfo.divCode);
                panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth'));
                panelSearch.setValue('TO_DATE', UniDate.get('today'));
                panelSearch.setValue('rdoSelect','A');
            
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
					param["sTxtValue2_fileTitle"]='<t:message code="system.label.purchase.creditpurchasetotal" default="외상매입금집계"/>';
					param["RPT_ID"]='map160rkrv';	
				var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/matrl/map160crkrv.do',
                    prgID: 'map160rkrv',
                    extParam: param
                });
					win.center();
					win.show();
        	}
			
		});
	}
</script>