<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa560rkrv" >
	<t:ExtComboStore comboType="BOR120" /> 				<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="S010"/>	<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!--지역-->
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	var panelResult = Unilite.createSearchForm('ssa560rkrvForm', {
		region: 'center',
		padding:'1 1 1 1',
		border:false,
	 	layout : {type : 'uniTable', columns : 1},
    	items :[{
			fieldLabel: '<t:message code="system.label.sales.itemmarkmethod" default="품목표시방법"/>'	,
			xtype: 'uniRadiogroup',
			allowBlank: false,
			width: 235,
			items: [{
				boxLabel:'<t:message code="system.label.sales.eachmark" default="개별표시"/>',
				name:'ITEM_TYPE',
				inputValue:'11',
				checked:true,
				width:100
			}, {
				boxLabel:'<t:message code="system.label.sales.sameitemmutimark" default="동일품목 합하여 표시"/>',
				name:'ITEM_TYPE',
				inputValue:'20',
				width:200
			}]
		},{
			fieldLabel: '<t:message code="system.label.sales.billtype" default="계산서종류"/>'	,
			xtype: 'uniRadiogroup',
			allowBlank: false,
			width: 235,
			items: [{
				boxLabel:'<t:message code="system.label.sales.taxinvoice" default="세금계산서"/>',
				name:'BILL_TYPE',
				inputValue:'11',
				checked:true,
				width:100
			}, {
				boxLabel:'<t:message code="system.label.sales.bill" default="계산서"/>',
				name:'BILL_TYPE',
				inputValue:'20',
				width:100
			}]
		},{
			fieldLabel: '<t:message code="system.label.sales.formuseyn" default="양품양식지사용여부"/>'	,
    		xtype: 'uniRadiogroup',
    		allowBlank: false,
    		width: 235,
    		items: [{
    			boxLabel: '<t:message code="system.label.sales.no" default="아니오"/>',
    			width: 100,
    			name: 'FORM_USE_YN',
    			inputValue: 'N',
    			checked:true
    		}, {
    			boxLabel: '<t:message code="system.label.sales.yes" default="예"/>',
    			width: 100,
    			name: 'FORM_USE_YN',
    			inputValue: 'Y'
    		}]
        },{ 
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			allowBlank  : false,
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.publishdate" default="발행일"/>',
			allowBlank  : false,
            xtype		: 'uniDateRangefield',
            startFieldName: 'FR_PUB_DATE',
            endFieldName: 'TO_PUB_DATE',
            startDate: UniDate.get('startOfLastMonth'),
            endDate: UniDate.get('endOfLastMonth'),
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelResult.setValue('FR_PUB_DATE', newValue);						
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelResult.setValue('TO_PUB_DATE', newValue);				    		
		    	}
		    }
     	},{
			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name:'SALE_PRSN',	
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'S010',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('SALE_PRSN', newValue);
				}
			}
		},{
    		fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
	    	name:'AGENT_TYPE',
	    	comboType:'AU',
	    	xtype: 'uniCombobox', 
	    	comboCode:'B055'
		}, {
	 		fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
	 		name: 'AREA_TYPE',
	 		xtype: 'uniCombobox',
	 		comboType: 'AU',
	 		comboCode: 'B056'
	 	}, { 
            xtype: 'container',
            layout: {type: 'hbox', align: 'stretch'},
            width: 325,
            defaultType: 'uniTextfield',                                            
            items: [{
                fieldLabel: '<t:message code="system.label.sales.billno" default="계산서번호"/>',
                suffixTpl: '&nbsp;~&nbsp;',
                name: 'PUB_FR_NUM',
                width: 218
            }, {
	            hideLabel: true,
	            name: 'PUB_TO_NUM',
	            width: 107
            }] 
        },Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>',
			valueFieldName: 'CUSTOM_CODE'
		})]
	});
	
	Unilite.Main( {
		border: false,
	 	items: [panelResult],
		id : 'ssa560rkrvApp',
		fnInitBinding : function(param) {
            panelResult.setValue('ITEM_TYPE','11');
            panelResult.setValue('BILL_TYPE','11');
            panelResult.setValue('FORM_USE_YN','N');
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('FR_PUB_DATE', UniDate.get('startOfLastMonth'));
            panelResult.setValue('TO_PUB_DATE', UniDate.get('endOfLastMonth'));
			
			UniAppManager.setToolbarButtons('print',true);
			UniAppManager.setToolbarButtons('query',false);
		},
		onResetButtonDown : function() {
			panelResult.clearForm();
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
			var param = panelResult.getValues();
			if(param.FORM_USE_YN == 'Y') {
				if(param.BILL_TYPE == '11'){
					param["RPT_ID"]='ssa560rkrv1';
				} else { //BILL_TYPE == 20
					param["RPT_ID"]='ssa560rkrv2';
				}
			} else { //FORM_USE_YN == N
				if(param.BILL_TYPE == '11'){
					param["RPT_ID"]='ssa560rkrv3';
				} else { //BILL_TYPE == 20
					param["RPT_ID"]='ssa560rkrv4';
				}
			}
			
			param.FR_DATE = UniDate.get('startOfMonth', param.BASIS_YYYYMM + '01'); //계획일(FROM)
			param.TO_DATE = UniDate.get('endOfMonth', param.BASIS_YYYYMM + '01');	//계획일(TO)
			var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/sales/ssa560crkrv.do',
                prgID: 'ssa560rkrv',
                extParam: param
            });
			win.center();
			win.show();
        	
		}
		
	});
};


</script>
