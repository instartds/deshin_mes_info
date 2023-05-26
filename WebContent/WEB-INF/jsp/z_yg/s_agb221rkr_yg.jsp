<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_agb221rkr_yg"  >
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL"/> 			<!-- 신고 사업장 --> 
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	
	var panelSearch = Unilite.createForm('s_agb221rkr_ygDetail', {		
		  disabled :false
		, id: 'searchForm'
	    , flex:1        
	    , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	    , defaults: {labelWidth: 100}
	    , items :[{
                    fieldLabel: '신고사업장',
                    name: 'DIV_CODE', 
                    xtype: 'uniCombobox',
                    comboCode: 'BILL', 
                    comboType: 'BOR120',
                    allowBlank: false
                },
	    	{
			fieldLabel: '일자',
			id: 'frToDate',
			xtype: 'uniDatefield',
			name: 'SUBMIT_DATE',                    
			value: new Date(),                    
			allowBlank: false
		},{
	    	xtype: 'container',
	    	padding: '10 0 0 0',
	    	layout: {
	    		type: 'vbox',
				align: 'center',
				pack:'center'
	    	},
	    	items:[{
	    		xtype: 'button',
	    		text: '실행',
	    		width : 100,
	    		id : 'excelDown',
	    		handler: function() {
	    		
	    			/*if(panelSearch.setAllFieldsReadOnly(true) == false){
                        return ;
                    }*/
                    

                    var form = panelFileDown;
                    form.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
                    form.setValue('SUBMIT_DATE', UniDate.getDbDateStr(panelSearch.getValue('SUBMIT_DATE')));
                    
                    /*var toUpdate = directMasterStore.getUpdatedRecords();
                    var budgData = [];
                    if(toUpdate.length > 0){
                        for(var i = 0; i < toUpdate.length; i++){
                            var data = toUpdate[i].data;
                            var itemCode = data.ITEM_CODE;
                            var budgetO = data.BUDGET_O;
                            var budgetP = data.BUDGET_UNIT_O;
                            budgData.push({
                                'ITEM_CODE'     : itemCode,
                                'BUDGET_UNIT_O' : budgetP,
                                'BUDGET_O'      : budgetO
                            });
                        }
                    }*/
                    //form.setValue('BUDG_DATA', JSON.stringify(budgData));
                    var param = form.getValues();
                    param.SUBMIT_DATE = UniDate.getDbDateStr(panelSearch.getValue('SUBMIT_DATE'));
                    form.submit({
                        params: param,
                        success:function()  {
                        },
                        failure: function(form, action){
                        }
                    });
                    
                    
                    
	    		}
	    	}]
	    }]      
	});	
	
	
	   var panelFileDown = Unilite.createForm('FileDownForm', {
        url: CPATH+'/z_yg/s_agb221rkrExcelDown.do',
        colspan: 2,
        layout: {type: 'uniTable', columns: 1},
        height: 30,
        padding: '0 0 0 195',
        disabled:false,
        autoScroll: false,
        standardSubmit: true,  
        items:[{
            xtype: 'uniTextfield',
            name: 'DIV_CODE'
        },{
            xtype: 'uniTextfield',
            name: 'SUBMIT_DATE'
        }]
    });
	
	
	
    Unilite.Main( {
		items:[ 
	 		panelSearch
		],
		id  : 's_agb221rkr_ygApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset', 'query'],false);
		}
	});

};


</script>
