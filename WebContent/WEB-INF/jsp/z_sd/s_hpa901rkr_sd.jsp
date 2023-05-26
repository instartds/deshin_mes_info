<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hpa901rkr_sd"  >
		<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 -->
		<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
		<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
		<t:ExtComboStore comboType="AU" comboCode="H032" opts= '1;2;5;6;8;9'/> <!-- 지급구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H181" /> <!-- 사원그룹 -->
		<t:ExtComboStore comboType="CBM600" comboCode="0"/> <!--  Cost Pool --> 
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
		},
		padding:'1 1 1 1',
		border:true,
		hidden:true,
		items: [{
				xtype: 'radiogroup',		            		
				fieldLabel: '출력선택',						            		
				itemId: 'RADIO4',
				labelWidth: 90,
				items: [{
					boxLabel: '부서별지급대장', 
					width: 120, 
					name: 'STRTYPE',
					inputValue: '1',
					checked: true  
				},{
					boxLabel: '부서별집계표', 
					width: 110, 
					name: 'STRTYPE',
					inputValue: '2'
				},{
					boxLabel: '사업장별지급대장', 
					width: 140, 
					name: 'STRTYPE',
					inputValue: '3'
				},{
					boxLabel: '급여명세서', 
					width: 100, 
					name: 'STRTYPE',
					inputValue: '4'
				},{
					boxLabel: '급여명세서(1/2)', 
					width: 150, 
					name: 'STRTYPE',
					inputValue: '5'
				}]
			},{
            	fieldLabel: '',
            	name: 'CONTAIN_ZERO',
				xtype: 'checkbox',
				labelWidth: 200,
				boxLabel: '&nbsp;급여가 0인 금액포함'
    		}]
	});	
	
    var panelResult2 = Unilite.createSearchForm('resultForm2',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'west',
		layout : {type : 'uniTable', columns : 1 },
		padding:'1 1 1 1',
		border:true,
		items: [{
	        	fieldLabel: '지급년월', 
				xtype: 'uniMonthRangefield',   
				startFieldName: 'DATE_FR',
				endFieldName: 'DATE_TO',
				startDate: UniDate.get('startOfYear'),
				endDate: UniDate.get('endOfYear'),
				allowBlank: false
	        },{
		        fieldLabel: '지급구분',
		        name:'SUPP_TYPE', 	
		        xtype: 'uniCombobox',
		        comboType: 'AU',
		        comboCode:'H032',
		        value: '1',
		        allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						//alert(newValue);
						if (newValue == '1'){
							Ext.getCmp('printGubun').enable();
						}else{
							Ext.getCmp('printGubun').disable();
						}
					},
					beforequery:function(queryPlan, eOpts){ 
                        var store = queryPlan.combo.store.data.items; 
					      Ext.each(store, function(record, i) { 
					       if(record.data.value == '2') { 
					        record.data.text = '기타복리후생비'; 
					       	} 
					      }) 
                    } 
        		}
		    },
		    {
                xtype: 'radiogroup',                            
                fieldLabel: '직급보조,급식,효도휴가비 출력',
                id:'printGubun',
                items: [{
                    boxLabel: '한다', 
                    width: 50, 
                    name: 'rdoSelect',
                    inputValue: 'Y',
                    checked: true
                },{
                    boxLabel : '안한다', 
                    width: 60,
                    name: 'rdoSelect',
                    inputValue: 'N' 
                }]
                
            }
		    ,{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				comboCode	: 'BILL'
			},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT_FR',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
//				textFieldWidth:89,
				textFieldWidth: 159,
				validateBlank:true,
//				width:300,
				autoPopup:true
			}),
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '~',
				valueFieldName:'DEPT_TO',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
//				textFieldWidth:89,
				textFieldWidth: 159,
				validateBlank:true,
//				width:300,
				autoPopup:true
			}),{
                fieldLabel: '급여지급방식',
                name:'PAY_CODE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H028'
            },{
				fieldLabel: '지급일',
				xtype: 'uniDatefield',
				name: 'SUPP_DATE',
				hidden:true
//				value: new Date()
			},{
                fieldLabel: '지급차수',
                name:'PAY_DAY_FLAG', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H031'
            },{
	            fieldLabel: '고용형태',
	            name:'PAY_GUBUN', 	
	            xtype: 'uniCombobox', 
	            comboType:'AU',
	            comboCode:'H011'
	        },{
                fieldLabel: '사원구분',
                name:'EMPLOY_TYPE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H024'
            },{
                fieldLabel: '사원그룹',
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
                fieldLabel: '직렬',
                name:'AFFIL_CODE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H173'
            },
            Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true
			}),{
			 	fieldLabel: '적요사항',
			 	xtype: 'textareafield',
			 	name: 'REMARK',
			 	height : 40,
			 	width: 325
			},{
             	xtype:'button',
             	text:'출    력',
             	width:235,
             	tdAttrs:{'align':'center', style:'padding-left:95px'},
             	handler:function()	{
             		UniAppManager.app.onPrintButtonDown();
             	}
            }
		]
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
		id: 's_hpa901rkr_sdApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			UniAppManager.setToolbarButtons(['query','reset','save'],false);
		},
		onQueryButtonDown : function()	{
		},
		onResetButtonDown: function() {
		},
		
/*		onPrintButtonDown: function() {
            var param = Ext.getCmp('resultForm2').getValues();
            var param2 = Ext.getCmp('resultForm').getValues();

            
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
        }*/
        
		onPrintButtonDown: function() {
			
            if(!panelResult2.getInvalidMessage()){
                return false;
            }
            
            
			var param = Ext.getCmp('resultForm2').getValues();
			var param2 = Ext.getCmp('resultForm').getValues();

			
			for(var attr in param2)
                param[attr]=param2[attr];
                
			if(param['CONTAIN_ZERO'] == null){
				param['CONTAIN_ZERO'] = 'off';
			}
			
			if (param['SUPP_TYPE'] == '1'){
				if (Ext.getCmp('printGubun').getChecked()[0].inputValue == 'Y'){
					param['SUPP_TYPE'] = "1";
				} else {
					param['SUPP_TYPE'] = "4";
				}
			} else {
					//alert('ccc');
			}
			
			//Ext.getCmp('workGb').getChecked()[0].inputValue
			//(Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '2')
				
//			var param = [];	
//            param['sYymm'] = "201701";
//            param['STRTYPE'] = param2['STRTYPE'];
            
//			var win = Ext.create('widget.PDFPrintWindow', {
//				url: CPATH+'/hpa/hpa901rkrPrint.do',
//				prgID: 'hpa901rkr',
//				extParam: param
//			});
//			var param = Ext.getCmp('resultForm2').getValues();
			
			param['format_i'] = "0";
			
			Ext.getBody().mask("Loading...");
            s_hpa901rkr_sdService.createReportData(param, function(){
            	Ext.getBody().unmask();
				var win = Ext.create('widget.CrystalReport', {
	                url: CPATH+'/z_sd/s_hpa901crkr_sd.do',
	                prgID: 's_hpa901crkr_sd',
	                extParam: param
	            });
				
				win.center();
				win.show();
			});
		}
	}); //End of
};

</script>
