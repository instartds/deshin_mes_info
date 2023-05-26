<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa901rkr"  >
		<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 -->
		<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
		<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
		<t:ExtComboStore comboType="AU" comboCode="H032" /> <!-- 지급구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H181" /> <!-- 사원그룹 -->
		<t:ExtComboStore comboType="CBM600" comboCode="0"/>   		   <!--  Cost Pool        --> 
		<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
		<t:ExtComboStore items="${COMBO_HUMAN_COST_POOL}" storeId="getHumanCostPool" />	<!--차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {


	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.printselection" default="출력선택"/>',						            		
				itemId: 'RADIO4',
				labelWidth: 90,
				items: [{
					boxLabel: '<t:message code="system.label.human.deptsuppledger" default="부서별지급대장"/>', 
					width: 120, 
					name: 'STRTYPE',
					inputValue: '1',
					checked: true  
				},{
					boxLabel: '<t:message code="system.label.human.bydeptsummary" default="부서별집계표"/>', 
					width: 110, 
					name: 'STRTYPE',
					inputValue: '2'
				},{
					boxLabel: '<t:message code="system.label.human.divsuppledger" default="사업장별지급대장"/>', 
					width: 140, 
					name: 'STRTYPE',
					inputValue: '3'
				}/*,{
					boxLabel: '사업장별지급대장2', 
					width: 140, 
					name: 'rdoSelect1',
					inputValue: 'dept4'
				}*/,{
					boxLabel: '<t:message code="system.label.human.payspecification" default="급여명세서"/>', 
					width: 100, 
					name: 'STRTYPE',
					inputValue: '4'
				},{
					boxLabel: '<t:message code="system.label.human.payspecification" default="급여명세서"/>(1/2)', 
					width: 150, 
					name: 'STRTYPE',
					inputValue: '5'
				}]
			},{
            	fieldLabel: '',
            	name: 'CONTAIN_ZERO',
				xtype: 'checkbox',
				labelWidth: 200,
				boxLabel: '&nbsp;<t:message code="system.message.human.message069" default="급여가 0인 금액포함"/>'
    		}]
	});	
	
    var panelResult2 = Unilite.createSearchForm('resultForm2',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'west',
		layout : {type : 'uniTable', columns : 1 },
		padding:'1 1 1 1',
		border:true,
		items: [{
	        	fieldLabel: '<t:message code="system.label.human.suppyyyymm1" default="지급년월"/>', 
				xtype: 'uniMonthRangefield',   
				startFieldName: 'DATE_FR',
				endFieldName: 'DATE_TO',
				startDate: new Date(),
				endDate: new Date(),
				allowBlank: false
	        },{
		        fieldLabel: '<t:message code="system.label.human.supptype" default="지급구분"/>',
		        name:'SUPP_TYPE', 	
		        xtype: 'uniCombobox',
		        comboType: 'AU',
		        comboCode:'H032',
		        value: '1'
		    },{
				fieldLabel	: '<t:message code="system.label.human.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				comboCode	: 'BILL'
			},
			Unilite.popup('DEPT',{
				fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
				valueFieldName:'DEPT_FR',
				textFieldName:'DEPT_NAME' ,
				selectChildren:true,
//				textFieldWidth:89,
				textFieldWidth: 159,
				validateBlank:true,
//				width:300,
				autoPopup:true
			}),
			Unilite.popup('DEPT',{
				fieldLabel: '~',
				valueFieldName:'DEPT_TO',
				textFieldName:'DEPT_NAME' ,
				selectChildren:true,
//				textFieldWidth:89,
				textFieldWidth: 159,
				validateBlank:true,
//				width:300,
				autoPopup:true
			}),{
                fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
                name:'PAY_CODE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H028'
            },{
				fieldLabel: '<t:message code="system.label.human.suppdate" default="지급일"/>',
				xtype: 'uniDatefield',
				name: 'SUPP_DATE',
				hidden:true
//				value: new Date()
			},{
                fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
                name:'PAY_DAY_FLAG', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H031'
            },{
	            fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
	            name:'PAY_GUBUN', 	
	            xtype: 'uniCombobox', 
	            comboType:'AU',
	            comboCode:'H011'
	        },{
                fieldLabel: '<t:message code="system.label.human.employtype" default="사원구분"/>',
                name:'EMPLOY_TYPE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H024'
            },{
                fieldLabel: '<t:message code="system.label.human.employeegroup" default="사원그룹"/>',
                name:'PERSON_GROUP', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H181'
            },{
                fieldLabel: 'Cost Pool',
                name:'COST_KIND', 	
                xtype: 'uniCombobox',
                comboType:'CBM600',
                comboCode:'0'
            },{
                fieldLabel: '<t:message code="system.label.human.serial" default="직렬"/>',
                name:'AFFIL_CODE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H173'
            },
            Unilite.popup('Employee',{
				fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult2.setValue('PERSON_NUMB', '');
                        panelResult2.setValue('NAME', '');
                    }
                }
			}),{
			 	fieldLabel: '<t:message code="system.label.human.reamark" default="적요사항"/>',
			 	xtype: 'textareafield',
			 	name: 'REMARK',
			 	height : 40,
			 	width: 325
			},{
             	xtype:'button',
             	text:'<t:message code="system.label.human.print" default="출력"/>',
             	width:235,
             	tdAttrs:{'align':'center', style:'padding-left:95px'},
             	handler:function()	{
             		UniAppManager.app.onPrintButtonDown();
             	}
            }
			/*,{
				xtype: 'radiogroup',		            		
				fieldLabel: '년차출력여부',	
				labelWidth: 90,
				items: [{
					boxLabel: '예', 
					width: 50, 
					name: 'rdoSelect2',
					inputValue: 'dept',
					checked: true  
				},{
					boxLabel: '아니오',  
					width: 70, 
					name: 'rdoSelect2',
					inputValue: 'dept'
				}]
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '근태출력여부',	
				labelWidth: 90,
				items: [{
					boxLabel: '예', 
					width: 50, 
					name: 'rdoSelect3',
					inputValue: 'dept',
					checked: true  
				},{
					boxLabel: '아니오',  
					width: 70, 
					name: 'rdoSelect3',
					inputValue: 'dept'
				}]
			}*/]
	});		
	
	Unilite.Main({
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, panelResult2
			]	
		}		
		], 
		id: 'hpa901rkrApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			UniAppManager.setToolbarButtons(['query','reset','save'],false);
		},
		onQueryButtonDown : function()	{
		},
		onResetButtonDown: function() {
		},
		onPrintButtonDown: function() {
            var param = Ext.getCmp('resultForm2').getValues();
            var param2 = Ext.getCmp('resultForm').getValues();
//          var startField = panelResult2.getField('DATE_FR');
//          var startDateValue = startField.getStartDate();
//          var endField = panelResult2.getField('DATE_TO');
//          var endDateValue = endField.getEndDate();
//          param['DATE_FR'] = startDateValue;
//          param['DATE_TO'] = endDateValue;
            
            for(var attr in param2)
                param[attr]=param2[attr];  
            if(param['CONTAIN_ZERO'] == null)
                param['CONTAIN_ZERO'] = 'off';
            var win = Ext.create('widget.PDFPrintWindow', {
                url: CPATH+'/hpa/hpa901rkrPrint.do',
                prgID: 'hpa901rkr',
                extParam: param
            });
            win.center();
            win.show();                 
        }
/*		onPrintButtonDown: function() {
			
            if(!panelResult2.getInvalidMessage()){
                return false;
            }
            
            
			var param = Ext.getCmp('resultForm2').getValues();
			var param2 = Ext.getCmp('resultForm').getValues();
// 			var startField = panelResult2.getField('DATE_FR');
//			var startDateValue = startField.getStartDate();
//			var endField = panelResult2.getField('DATE_TO');
//			var endDateValue = endField.getEndDate();
//			param['DATE_FR'] = startDateValue;
//			param['DATE_TO'] = endDateValue;
			
			for(var attr in param2)
                param[attr]=param2[attr];
                
			if(param['CONTAIN_ZERO'] == null){
				param['CONTAIN_ZERO'] = 'off';
			}
				
//			var param = [];	
//            param['sYymm'] = "201701";
//            param['STRTYPE'] = param2['STRTYPE'];
            
//			var win = Ext.create('widget.PDFPrintWindow', {
//				url: CPATH+'/hpa/hpa901rkrPrint.do',
//				prgID: 'hpa901rkr',
//				extParam: param
//			});
//			var param = Ext.getCmp('resultForm2').getValues();
			
//			param['sYymm'] = "201701";
			var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/human/hpa901crkr.do',
                prgID: 'hpa901rkr',
                extParam: param
            });
			
			win.center();
			win.show();   				
		}*/
	}); //End of
};

</script>
