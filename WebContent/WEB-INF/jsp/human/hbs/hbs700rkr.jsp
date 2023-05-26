<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="hbs700rkr"  >
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        items: [{
            xtype: 'radiogroup',                            
            fieldLabel: '출력선택',                                         
            id: 'optPrintGb',
            labelWidth: 90,
            items: [{
                boxLabel: '전체', 
                width: 150, 
                name: 'optPrintGb',
                inputValue: '1',
                checked: true  
            },{
                boxLabel: '연봉계약서', 
                width: 150, 
                name: 'optPrintGb',
                inputValue: '2'
            },{
                boxLabel: '연봉산출내역서', 
                width: 150, 
                name: 'optPrintGb',
                inputValue: '3'
            }]
        }]
    }); 
	var panelResult2 = Unilite.createSearchForm('resultForm2', {
		region: 'center',
    	disabled :false,
    	border: true,
    	padding:'1 1 1 1',
    	layout: {
	    	type: 'uniTable',
			columns:1
	    },
	    defaults:{
	    	width:325,
			labelWidth:90
	    },
		width:400,
	    items :[{
            xtype: 'uniYearField',
            fieldLabel: '연봉계약년도',
            name: 'CNRC_YEAR',
            allowBlank:false
        },
        Unilite.popup('DEPT',{
	        fieldLabel: '부서',
		    valueFieldName:'DEPT_CODE_FR',
		    textFieldName:'DEPT_NAME_FR',
		    itemId:'DEPT_CODE_FR',
			autoPopup: true
	    }),
	    Unilite.popup('DEPT',{
	        fieldLabel: '~',
	        itemId:'DEPT_CODE_TO',
		    valueFieldName:'DEPT_CODE_TO',
		    textFieldName:'DEPT_NAME_TO',
			autoPopup: true
	    }),
		Unilite.popup('Employee',{
			fieldLabel: '사원',
		  	valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
			validateBlank:false,
			autoPopup:true,
			id : 'PERSON_NUMB', 
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'BASE_DT': '00000000'}); 
				}
			}
		}),
        {
            xtype:'button',
            text:'출    력',
            width:235,
            tdAttrs:{'align':'center', style:'padding-left:95px'},
            handler:function() {
                if(!panelResult2.getInvalidMessage()) return;   
                
                var param= panelResult2.getValues();
                hbs700rkrService.checkHbs700t(param, function(provider, response)  {
                    if(!Ext.isEmpty(provider)){
                        if(provider == 'Y'){
				            param.PGM_ID = 'hbs700rkr';  //프로그램ID
				            param.sTxtValue2_fileTitle = '연봉계약서';
				            param.PRINT_TYPE = panelResult.getValue('optPrintGb').optPrintGb;
				            param.HOST_URL = CHOST;
				            
							var win = Ext.create('widget.ClipReport', {
								url: CPATH+'/human/hbs700clrkrv.do',
								prgID: 'hbs700rkr',
								extParam: param
							});
				            win.center();
				            win.show();
				            
//                        	param.OPT_PRINT_GB = panelResult.getValue('optPrintGb').optPrintGb;
//                            var win = Ext.create('widget.CrystalReport', {
//                                url: CPATH+'/human/hbs700crkrPrint.do',
//                                prgID: 'hbs700rkr',
//                                extParam: param
//                            });
//                            win.center();
//                            win.show();
                        }else{
                            alert('연봉 확정후에 출력이 가능합니다.');
                        }
                    }
                });    
            }
        }]		
	});

    Unilite.Main( {
        border: false,
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                panelResult, panelResult2
            ]   
        }],
		id  : 'hbs700rkrApp',
		fnInitBinding : function() {
            UniAppManager.setToolbarButtons(['query'], false);
			panelResult2.setValue('CNRC_YEAR',new Date().getFullYear());
		}
	});

};
</script>
			