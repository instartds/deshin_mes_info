<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa970rkr"  >
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
    	region: 'west',
		layout : {type : 'uniTable', columns : 1
		},
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
	        },
           Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				allowBlank: false,
				listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('PERSON_NUMB', '');
                        panelResult.setValue('NAME', '');
                    }
                }
			}),
			{
				fieldLabel: '발급번호'	,
				name:'PRINT_NUM', 
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
	    	},
	    	{
				fieldLabel: '사용목적'	,
				name:'OBJECTS', 
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
	    	},
	    	{
				fieldLabel: '제출처'	,
				name:'JECHUL', 
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
	    	},
	    	{
				fieldLabel: '소요수량'	,
				name:'SOJONUM', 
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
	    	},{
				fieldLabel: '발급일',
				xtype: 'uniDatefield',
				name: 'ISSUE_DATE',                    
				value: new Date()
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '구분',						            		
				itemId: 'ISSU_DIVI',
				labelWidth: 90,
				items: [{
					boxLabel: '회사발급용', 
					width: 120, 
					name: 'ISSU_DIVI',
					inputValue: '0',
					checked: true  
				},{
					boxLabel: '세무대리인용', 
					width: 110, 
					name: 'ISSU_DIVI',
					inputValue: '1'
				}]
			},
	    	
            {
             	xtype:'button',
             	text:'출    력',
             	width:235,
             	tdAttrs:{'align':'center', style:'padding-left:65px'},
             	handler:function()	{
             		UniAppManager.app.onPrintButtonDown();
             	}
            }],
            setAllFieldsReadOnly: function(b) {
            var r= true
            if(b) {
                var invalid = this.getForm().getFields().filterBy(function(field) {
                    return !field.validate();
                });
                      if(invalid.length > 0) {
                    r=false;
                      var labelText = ''
                    if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                           var labelText = invalid.items[0]['fieldLabel']+'은(는)';
                       } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                           var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
                       }
                       alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
                    //this.mask();            
                   }
              } else {
                  this.unmask();
              }
            return r;
          }
	});		
	
	Unilite.Main({
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult
			]	
		}		
		], 
		id: 'hpa901rkrApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		checkForNewDetail:function() { 			
			return panelResult.setAllFieldsReadOnly(true);
        },
		onQueryButtonDown : function()	{
		
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.clearForm();
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
			if(!UniAppManager.app.checkForNewDetail()){
                return false;
            }else{
			var param = Ext.getCmp('resultForm').getValues();
//			var win = Ext.create('widget.PDFPrintWindow', {
//				url: CPATH+'/hpa/hpa970rkrPrint.do',
//				prgID: 'hpa970rkr',
//				extParam: param
//			});
			
			
			
            param.PGM_ID = 'hpa970rkr';  //프로그램ID
            param.sTxtValue2_fileTitle = "갑종근로소득에 대한 소득세 원천징수확인서";
            
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/human/hpa970clrkrv.do',
				prgID: 'hpa970rkr',
					extParam: param
				});
			win.center();
			win.show();   				
			}
		}
	}); //End of
};

</script>
