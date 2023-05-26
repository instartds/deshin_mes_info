<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms131ukrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="mms131ukrv"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> 			<!-- 품목계정 -->
</t:appConfig>
</script>
<style type="text/css">
.x-form-item-label {
    font: bold 20px 맑은 고딕, arial, verdana, sans-serif;
	padding-top: 0px;	
	margin-top: 0px !important;
}
.x-panel-body-default {
    background: #e8ebe9;
}

.x-form-text-default.x-form-textarea {
    line-height: 20px;
    min-height: 56px;
}

</style>

<script type="text/javascript" >
/*.x-box-inner {
    position: absolute;
    left: 50%;
    top: 50%;
    transform:translate(-50%, -50%);
}*/
function appMain() {
	var chkinterval = null;
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'center',
        layout: {
        	type : 'vbox',
        	align: 'middle'
//        		tableAttrs: {width: '100%',width: '100%'/*, align : 'left'*/}//,
////				tdAttrs: {style: 'border : 1px solid #ced9e7;',width:300/*, align : 'center'*/}
        },
         bodyStyle:{"background-color":"#e8ebe9"}, 
        padding:'1 1 1 1',
//        bodyPadding: '200 440 280 440',
        bodyPadding: '220 0 0 0',
        border:true,
        flex:1,
//        
//            height: 400,
//            width: 500,
        items: [
        	
        	{
			xtype: 'container',
			layout: { 
				type: 'vbox',
        		align: 'middle'
        	},
            height: 550,
            width: 400,
			padding:"0 0 0 0",
			
         	style:{"background-color":"#fff"}, 
			items:[	
        			
        				{
            xtype: 'image',
            height: 90,
            width: 280,
            margin: '30 0 0 0',
            src: CPATH+'/resources/images/inno_logo1.png'
        },{
	        xtype: 'displayfield',
	        name: '',
	        value: '업체접수프로그램',
			padding: "25 0 0 0",
			fieldStyle: {
			    'fontSize': '25px',
			    'font-family': '맑은 고딕',
				'font-weight': 'bolder'
		   }
        },{
			xtype: 'container',
			layout: { 
				type: 'vbox',
        		align: 'middle'
        	},
            height: 300,
            width: 400,
			padding:"0 0 0 0",
			items:[{
				fieldLabel: '바코드',
				labelAlign:'top',
				xtype: 'uniTextfield',
				name: 'BARCODE',
				padding: "50 0 0 0",
				labelWidth:75,
				width:280,
				fieldStyle: {
					'fontSize': '20px',
					'font-family': '맑은 고딕, arial, verdana, sans-serif'
				},
				listeners: {
					specialkey:function(field, event)	{
						if(event.getKey() == event.ENTER) {
						var newValue = panelResult.getValue('BARCODE');
							
							if(!Ext.isEmpty(newValue)) {
								Ext.getBody().mask('저장중...', 'loading');
								var param= {
									BARCODE : newValue
								}
								mms131ukrvService.mms131ukrvSave(param , function(provider, response){
									if(!Ext.isEmpty(provider))	{
									
			            				UniAppManager.updateStatus('정상처리 되었습니다.');
			            				
			            				panelResult.setValue('RESULT',provider.V_CNT + '건 접수등록 되었습니다.'+ '\n\n공급처 : '+ provider.V_CUSTOM_NAME + '\n납품번호 : '+ provider.BARCODE + '\n접수번호 : '+ provider.RECEIPT_NUM);
										Ext.getBody().unmask();
									}
									
									panelResult.setValue('BARCODE','');
	        						panelResult.getField('BARCODE').focus();
						        	
									Ext.getBody().unmask();
								})
							}
						}
					}
				}
			},{
				name: 'RESULT',
				xtype: 'textarea',
				height: 150,
				padding: "25 0 0 0",
				readOnly:true,
				width:280,
				fieldStyle: {
			    	'fontSize': '20px',
					'font-family': '맑은 고딕, arial, verdana, sans-serif'
				}	
			}
		]}, {
			xtype: 'container',
			layout: { 
				type: 'vbox',
        		align: 'middle'
        	},
			padding:"30 0 0 0",
            height: 50,
            width: 300,
			items:[{
		        xtype: 'displayfield',
		        name: 'COPYRIGHT',
		        value: 'Copyrightⓒ2021 SynergySystems All rights reserved.',
					fieldStyle: {
					    'fontSize': '12px',
					    'font-family': 'bold 맑은 고딕, arial, verdana, sans-serif'
				   }
		        }
			]
		}
		
		
		]}
		
		]
    });

    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[panelResult]
        }],
		uniOpt:{showKeyText:false,
				showToolbar: false
//        	forceToolbarbutton:true
		},
        id  : 'mms131ukrvApp',
        fnInitBinding : function() {
            this.setDefault();
        },
        onQueryButtonDown : function()  {},
        onResetButtonDown: function() {
            panelResult.clearForm();
            this.setDefault();
        },
        
        onSaveDataButtonDown: function() {},
        setDefault: function() {
            UniAppManager.setToolbarButtons(['query','save','newData', 'delete', 'deleteAll','reset'],false);
            
    		setTimeout( function() {
        		panelResult.getField('BARCODE').focus();
			}, 50 );
        }
    });
}
</script>