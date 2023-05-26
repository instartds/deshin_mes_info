<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum102rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /> <!-- 직책-->
</t:appConfig>
<script type="text/javascript" >


function appMain() {   
	var panelSearch = Unilite.createSearchForm('hum102rkrForm', {
		region: 'center',
    	disabled :false,
    	border: false,
    	flex:1,
    	layout: {
	    	type: 'uniTable',
			columns:1
	    },
	    defaults:{
	    	width:325,
			labelWidth:90
	    },
		defaultType: 'uniTextfield',
		padding:'20 0 0 0',
		width:400,
		items : [{
                fieldLabel: '사업장',
                name:'DIV_CODE', 
                xtype: 'uniCombobox',
                multiSelect: true, 
                typeAhead: false,
                comboType:'BOR120',
                allowBlank: false
            },
            Unilite.popup('Employee',{
                fieldLabel: '사원',
                valueFieldName:'PERSON_NUMB',
                textFieldName:'PERSON_NAME',
                validateBlank:false,
                autoPopup:true
            }),{ 
                fieldLabel: '입사일',
                xtype: 'uniDateRangefield',
                startFieldName: 'JOIN_DATE_FR',
                endFieldName: 'JOIN_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank: false
            },
    		Unilite.popup('DEPT',{
                    fieldLabel: '부서',
                    valueFieldName:'DEPT_CODE',
                    textFieldName:'DEPT_NAME',
                    autoPopup: true
            }),{
                fieldLabel: '직책',
                name: 'ABIL_CODE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H006'
            },{
                xtype:'button',
                text:'출    력',
                width:235,
                tdAttrs:{'align':'center', style:'padding-left:95px'},
                handler:function()  {
                    UniAppManager.app.onPrintButtonDown();
                }
             }
		]
	});
	
   
   
    
	 Unilite.Main( {
	 	border: false,
	 	items:[
	 		panelSearch
	 		],
	 
		id : 'hum102rkrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('JOIN_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('JOIN_DATE_TO', UniDate.get('today'));
//            var param= Ext.getCmp('hum102rkrForm').getValues(); 
//            hum102rkrService.selectList(param);
			
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('print',false);
		},
		onQueryButtonDown : function()	{
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
//			var param= Ext.getCmp('searchForm').getValues();
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/hum/hum102rkrPrint.do',
				prgID: 'hum102rkr',
				extParam: {
					DIV_CODE		: panelSearch.getValue('DIV_CODE'),
					PERSON_NUMB		: panelSearch.getValue('PERSON_NUMB'),
					DEPT_CODE       : panelSearch.getValue('DEPT_CODE'),
					ABIL_CODE       : panelSearch.getValue('ABIL_CODE'),
					JOIN_DATE_FR    : UniDate.getDbDateStr(panelSearch.getValue('JOIN_DATE_FR')),
					JOIN_DATE_TO	: UniDate.getDbDateStr(panelSearch.getValue('JOIN_DATE_TO'))
				}
			});
			win.center();
			win.show();   				
		}
		
	});
};


</script>
