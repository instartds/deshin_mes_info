<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str400rkrv_kd"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_str400rkrv_kd" /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위-->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />		<!--창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    

.x-change-cell_light_Yellow {
background-color: #FFFFA1;
}

.x-change-cell_yellow {
background-color: #FAED7D;
}

</style>
<script type="text/javascript" >

function appMain() {   
	
	var panelSearch = Unilite.createSearchForm('s_str400rkrv_kdForm', {
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
			labelWidth:120
	    },
		defaultType: 'uniTextfield',
		padding:'20 0 0 0',
		width:400,
		items : [
			{
				fieldLabel: '<t:message code="unilite.msg.sMR047" default="출고일"/>'  ,
				name: 'INOUT_DATE',
				xtype:'uniDatefield',
				value:new Date(),
				holdable: 'hold',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {					
					}
				}
		     },
		     {	    
		    	fieldLabel: '사업장',
		    	name:'DIV_CODE',
		    	xtype: 'uniCombobox', 
		    	comboType:'BOR120', 
		    	allowBlank:false,
		    	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						
					}
				}
	    	},
	    	{
	        	fieldLabel: '출고창고',
	        	name: 'WH_CODE',
	        	xtype:'uniCombobox',
	        	comboType:'AU',
	        	store: Ext.data.StoreManager.lookup('whList')	        	
	        },
	        {
				fieldLabel: '<t:message code="unilite.msg.sMRBW144" default="출고번호"/>',
				xtype: 'uniTextfield',
				name: 'INOUT_NUM', 
				holdable: 'hold'
			},
			{
				fieldLabel: '고객분류',
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU', 
				comboCode: 'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
			},
			{
    			fieldLabel: '지역'	,
    			name:'AREA_TYPE', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'B056'
    		},
    		Unilite.popup('AGENT_CUST', {
				fieldLabel: '고객',
				valueFieldName: 'CUSTOM_CODE', //EXPORTER
				textFieldName: 'CUSTOM_NAME', 
				textFieldWidth:175, 
				popupWidth: 710,
				listeners: {
						onSelected: {
							fn: function(records, type) {
							},
							scope: this
						},
						onClear: function(type)	{
						}
			   }
			}),
			{ 
				fieldLabel: '단가/금액출력여부',
    		 	xtype: 'radiogroup',
    		 	itemId: 'PRINT_YN',
    		 	width: 300,
    		 	items:[{
    		 		boxLabel:'예',
    		 		name: 'PRINT_YN',
    		 		inputValue: 'Y'
    		 		
    		 	},{
    		 		boxLabel:'아니오',
    		 		name:'PRINT_YN',
    		 		inputValue: 'N',
    		 		checked: true
    		 	}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
    		 	
    		},
    		{ 
				fieldLabel: '출고인쇄구분',
    		 	xtype: 'radiogroup',
    		 	itemId: 'PRINT_CUST',
    		 	width: 300,
    		 	items:[{
    		 		boxLabel:'고객별',
    		 		name: 'PRINT_KIND',
    		 		inputValue: 'CUST', 
    		 		checked: true
    		 	},{
    		 		boxLabel:'배송처별',
    		 		name:'PRINT_KIND',
    		 		inputValue: 'DVRY'
    		 	}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
    		 	
    		},{
                xtype:'button',           //필드 타입
                text: '기안',
                margin: '0 0 2 120',
//                margin: '0 0 0 0',
                width: 80,            
                handler : function() {
                    if(panelResult.setAllFieldsReadOnly(true) == false){
                        return false;
                    }
                    else {
                        alert('SP실행'); 
                    }
                }
            }
	]				
	
	});
	
   
   
    
	 Unilite.Main( {
	 	border: false,
	 	items:[
	 		panelSearch
	 		],
	 
		id : 's_str400rkrv_kdApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('INOUT_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('print',true);
			
			if(!Ext.isEmpty(params && params.PGM_ID)){
                this.processParams(params);
            }
			
			
		},
        //링크로 넘어오는 params 받는 부분 (Agj100skr)
        processParams: function(params) {
            this.uniOpt.appParams = params;
            if(params.PGM_ID == 'str103ukrv') {
                panelSearch.setValue('INOUT_CODE'       , params.INOUT_CODE);
                panelSearch.setValue('INOUT_NUM'       , params.INOUT_NUM);
                panelSearch.setValue('DIV_CODE'       , params.DIV_CODE);
                panelSearch.setValue('INOUT_DATE'       , params.INOUT_DATE);
                panelSearch.setValue('CUSTOM_CODE'       , params.CUSTOM_CODE);
                panelSearch.setValue('CUSTOM_NAME'       , params.CUSTOM_NAME);
            }
        },
		onQueryButtonDown : function()	{
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
			if(this.onFormValidate()){
				var param= panelSearch.getValues();
				param.ACCNT_DIV_NAME = panelSearch.getField('DIV_CODE').getRawValue();
				var win = Ext.create('widget.PDFPrintWindow', {
					url: CPATH+'/str/s_str400rkrv_kdPrint1.do',
					prgID: 's_str400rkrv_kd',
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
					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				}
	
			   	alert(labelText+Msg.sMB083);
			   	invalid.items[0].focus();
			}
			return r;
	    }
		
	});
};


</script>
