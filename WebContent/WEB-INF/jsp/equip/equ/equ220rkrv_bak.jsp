<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="equ220rkr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="equ220rkr" /> 			<!-- 사업장 --> 	
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
	
	var panelSearch = Unilite.createSearchForm('equ220rkrForm', {
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
		items : [
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
		        fieldLabel: '제작년월',
		        xtype: 'uniDateRangefield',  
				startFieldName: 'FROM_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('aMonthAgo'),
				endDate: UniDate.get('today'),
				
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	}
			    
			},
	        {
				fieldLabel: '장비번호',
				xtype: 'uniTextfield',
				name: 'INOUT_NUM', 
				holdable: 'hold'
			},
			{
				fieldLabel: '자산번호',
				xtype: 'uniTextfield',
				name: 'ASSET_NUM', 
				holdable: 'hold'
			},
				Unilite.popup('CUST', { 
					fieldLabel: '보관처', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
	                    	},
							scope: this
						},
						onClear: function(type)	{
						}
					}
			})

		]				
	
	});
	
   
   
    
	 Unilite.Main( {
	 	border: false,
	 	items:[
	 		panelSearch
	 		],
	 
		id : 'equ220rkrApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('INOUT_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('print',true);
			
			if(!Ext.isEmpty(params && params.PGM_ID)){
                this.processParams(params);
            }
			
			
		},
        //링크로 넘어오는 params 받는 부분 (Agj100skr)
//        processParams: function(params) {
//            this.uniOpt.appParams = params;
//            if(params.PGM_ID == 'str103ukrv' || params.PGM_ID == 'str104ukrv') {
//                panelSearch.setValue('INOUT_CODE'       , params.INOUT_CODE);
//                panelSearch.setValue('INOUT_NUM'       , params.INOUT_NUM);
//                panelSearch.setValue('DIV_CODE'       , params.DIV_CODE);
//                panelSearch.setValue('INOUT_DATE'       , params.INOUT_DATE);
//                panelSearch.setValue('CUSTOM_CODE'       , params.CUSTOM_CODE);
//                panelSearch.setValue('CUSTOM_NAME'       , params.CUSTOM_NAME);
//            }
//        },
		onQueryButtonDown : function()	{
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
			if(this.onFormValidate()){
				var param= panelSearch.getValues();
				param.ACCNT_DIV_NAME = panelSearch.getField('DIV_CODE').getRawValue();
				var win = Ext.create('widget.PDFPrintWindow', {
					url: CPATH+'/str/equ220rkrPrint1.do',
					prgID: 'equ220rkr',
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
