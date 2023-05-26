<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_tix901ukrv_kd"  >
	<t:ExtComboStore comboType="BOR120"  /> 				            <!-- 사업장 -->   
    <t:ExtComboStore comboType="AU" comboCode="T005" />                 <!-- 가격조건  -->
    <t:ExtComboStore comboType="AU" comboCode="T071" />                 <!-- 진행구분-->
    <t:ExtComboStore comboType="AU" comboCode="WT01" />                 <!-- 원가산출운임,CFS-->

<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {     
    gsDefaultMoney      : '${gsDefaultMoney}'
};

var queryLoad = "N";

function appMain() {
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_tix901ukrv_kdModel', {
	    fields: [
	    	{name: 'COMP_CODE'          ,text: '법인코드' 		    ,type: 'string'},
	    	{name: 'DIV_CODE'           ,text: '사업장'             ,type: 'string'},
            {name: 'OFFER_NO'           ,text: 'OFFER번호'          ,type: 'string'},
            {name: 'SEQ'                ,text: '정렬순번'           ,type: 'int', allowBlank: false},
            {name: 'CHARGE_TYPE'        ,text: '경비구분'           ,type: 'string', allowBlank: false, comboType: "AU", comboCode: "T071"},
            {name: 'CHARGE_CODE'        ,text: '경비코드'           ,type: 'string', allowBlank: false},
            {name: 'CHARGE_NAME'        ,text: '수입경비명'         ,type: 'string'},
            {name: 'MONEY_UNIT'         ,text: '화폐단위'           ,type: 'string'},
            {name: 'EXCHG_RATE_O'       ,text: '환율'               ,type: 'uniER'},
            {name: 'AMT_FOR_CHARGE'     ,text: '외화금액'           ,type: 'uniFC'},
            {name: 'AMT_CHARGE'         ,text: '자사금액'           ,type: 'uniPrice'},
            {name: 'ENTRY_DATE'         ,text: '입력일자'           ,type: 'uniDate'},
            {name: 'REMARK'             ,text: '비고'               ,type: 'string'},
            {name: 'INSERT_DB_USER'     ,text: 'INSERT_DB_USER'     ,type: 'string'},
            {name: 'INSERT_DB_TIME'     ,text: 'INSERT_DB_TIME'     ,type: 'uniDate'},
            {name: 'UPDATE_DB_USER'     ,text: 'UPDATE_DB_USER'     ,type: 'string'},
            {name: 'UPDATE_DB_TIME'     ,text: 'UPDATE_DB_TIME'     ,type: 'uniDate'}
		]
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
        api:{
            load:'s_tix901ukrv_kdService.selectFormMaster'
        },
	    items :[{                  
                fieldLabel: '사업장',
                name:'DIV_CODE',    
                xtype: 'uniCombobox',
                comboType:'BOR120',
                holdable: 'hold',
                allowBlank: false
            },
            Unilite.popup('INCOM_OFFER', {     //수입 OFFER 관리번호
                fieldLabel: 'OFFER번호',
                id: 'INCOM_OFFER2',
                holdable: 'hold',
                allowBlank: false,
                colspan: 3,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            UniAppManager.app.onQueryButtonDown();
                        },
                        scope: this
                    },
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE':  panelResult.getValue('DIV_CODE')});
                    }
                }
            }),{
                xtype: 'component',
                tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' },
                colspan: 4
            },
            Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                valueFieldName:'CUSTOM_CODE',
                textFieldName:'CUSTOM_NAME',
                holdable: 'hold',
                readOnly: true,
                extParam: {'CUSTOM_TYPE': ['1','2']}
            }),{
                fieldLabel: 'OFFER일자',
                name: 'DATE_DEPART',
                xtype: 'uniDatefield',
                value: UniDate.get('today'),
                holdable: 'hold',
                readOnly: true
            },{
                fieldLabel: '화폐', 
                name: 'MONEY_UNIT', 
                xtype: 'uniCombobox', 
                comboType: 'AU', 
                comboCode: 'B004',
                displayField: 'value',
                holdable: 'hold',
                readOnly: true
            },{
                name: 'SO_AMT',
                fieldLabel: '화폐금액',
                xtype:'uniNumberfield',
                flex: 2,
                value: 0,
                holdable: 'hold',
                readOnly: true
            },{ 
                name: 'TERMS_PRICE',         
                fieldLabel: '가격조건',      
                xtype:'uniCombobox',   
                comboType:'AU', 
                comboCode:'T005',
                holdable: 'hold',
                readOnly: true
            },{
                fieldLabel: '입고예정일',
                name: 'DELIVERY_DATE',
                xtype: 'uniDatefield',
                value: UniDate.get('today'),
                holdable: 'hold',
                readOnly: true
            },{
                fieldLabel: '환율',
                name:'EXCHG_RATE_O',
                xtype: 'uniNumberfield',
                holdable: 'hold',
                readOnly: true,
                decimalPrecision: 4,
                value: 1
            },{
                name: 'SO_AMT_WON',
                fieldLabel: '자사금액',
                xtype:'uniNumberfield',
                flex: 2,
                value: 0,
                holdable: 'hold',
                readOnly: true
            }
        ],
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
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});

    var inputTable = Unilite.createSearchForm('inputTable', { //createForm
        layout : {type : 'uniTable', columns : 3},
        disabled: false,
        border:true,
        padding:'1 1 1 1',
        region: 'center',
        autoScroll: true,
        items: [
            {
                name: 'SO_AMT_WON',
                fieldLabel: 'OFFER금액',
                xtype:'uniNumberfield',
                readOnly: true
            },{
                name: 'IMPORT_TAX_RATE',
                fieldLabel: '수입세율',
                xtype:'uniNumberfield',
                labelWidth: 170,
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        inputTable.setValue('CAL_MUL_DAE', inputTable.getValue('SO_AMT_WON') * newValue);
                        inputTable.setValue('CAL_DUTY_FEE', inputTable.getValue('CAL_MUL_DAE') * newValue);
                    }
                } 
            },{
                name: 'UNLOAD_PLACE',
                fieldLabel: '하역지',
                xtype:'uniCombobox', 
                comboType:'AU', 
                comboCode:'WT01',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {  
                    	var param = inputTable.getValues();
                        s_tix901ukrv_kdService.selectUnloadPlace(param, 
                            function(provider, response) {
                                if(provider.length != 0) {  
                                    inputTable.setValue('CAL_UNIM',  provider[0].REF_CODE1);  
                                    inputTable.setValue('CAL_CFS',  provider[0].REF_CODE2);             
                                } else {
                                	inputTable.setValue('CAL_UNIM',  0);  
                                    inputTable.setValue('CAL_CFS',  0);          
                                }
                            }
                        )
                    }
                } 
            },{
                name: 'EXCHG_RATE_O',
                fieldLabel: '환율',
                xtype:'uniNumberfield',
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        inputTable.setValue('CAL_SUNIM', newValue * inputTable.getValue('FOB_FOR_AMT') * inputTable.getValue('CBM'));
                    }
                }  
            },{
                name: 'CAL_DUTY_FEE',
                fieldLabel: '관세',
                labelWidth: 170,
                xtype:'uniNumberfield',
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        inputTable.setValue('CAL_TAX_AMT', (newValue + inputTable.getValue('CAL_MUL_DAE')) * (10/100));
                        inputTable.setValue('CAL_STOCK_AMT', ((newValue + inputTable.getValue('CAL_MUL_DAE')) * (0.84/1000)) + (630 * inputTable.getValue('CBM')));
                        var JxCx2t1000 = (newValue + inputTable.getValue('CAL_MUL_DAE')) * 2 / 1000;
                        var int30000 = 30000;
                        if(JxCx2t1000 > int30000) {
                            inputTable.setValue('CAL_CLEAR_AMT', int30000);    
                        } else {
                            inputTable.setValue('CAL_CLEAR_AMT', JxCx2t1000);  
                        }
                    }
                }  
            },{
                name: 'CAL_UNIM',
                fieldLabel: '운임',
                xtype:'uniNumberfield',
                readOnly: true
            },{
                name: 'CAL_MUL_DAE',
                fieldLabel: '물대',
                xtype:'uniNumberfield',
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        inputTable.setValue('CAL_TAX_AMT', (newValue + inputTable.getValue('CAL_DUTY_FEE')) * (10/100));
                        inputTable.setValue('CAL_STOCK_AMT', ((newValue + inputTable.getValue('CAL_DUTY_FEE')) * (0.84/1000)) + (630 * inputTable.getValue('CBM')));
                        var JxCx2t1000 = (newValue + inputTable.getValue('CAL_DUTY_FEE')) * 2 / 1000;
                        var int30000 = 30000;
                        if(JxCx2t1000 > int30000) {
                            inputTable.setValue('CAL_CLEAR_AMT', int30000);    
                        } else {
                            inputTable.setValue('CAL_CLEAR_AMT', JxCx2t1000);  
                        }
                    }
                }  
            },{
                name: 'CAL_TAX_AMT',
                fieldLabel: '부가세',
                labelWidth: 170,
                xtype:'uniNumberfield',
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        inputTable.setValue('CAL_RETURN', newValue);
                    }
                }  
            },{
                name: 'CAL_CFS',
                fieldLabel: 'C.F.S',
                xtype:'uniNumberfield',
                readOnly: true
            },{
                name: 'LC_RATE',
                fieldLabel: 'L/C요율',
                xtype:'uniNumberfield',
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        inputTable.setValue('CAL_LC_FEE', inputTable.getValue('CAL_MUL_DAE') * newValue);
                    }
                } 
            },{
                name: 'UNLOAD_AMT',
                fieldLabel: '하역기준료',
                labelWidth: 170,
                xtype:'uniNumberfield',
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {   
                    	var LxG = inputTable.getValue('UNLOAD_AMT') * inputTable.getValue('CBM');
                    	var int20000 = 20000;
                    	if(LxG > int20000) {
                    	    inputTable.setValue('CAL_UNLOAD_AMT', int20000);	
                    	} else {
                    		inputTable.setValue('CAL_UNLOAD_AMT', LxG);  
                    	}
                    }
                }  
            },{
                name: 'ETC_AMT',
                fieldLabel: '기타',
                xtype:'uniNumberfield',
                allowBlank: false
            },{
                name: 'CAL_LC_FEE',
                fieldLabel: 'L/C수수료',
                xtype:'uniNumberfield',
                readOnly: true
            },{
                name: 'CAL_UNLOAD_AMT',
                fieldLabel: '하역료',
                labelWidth: 170,
                xtype:'uniNumberfield',
                readOnly: true
            },{
                name: 'CAL_RETURN',
                fieldLabel: '환급',
                xtype:'uniNumberfield',
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        inputTable.setValue('CAL_TAX_AMT', newValue);
                    }
                }  
            },{
                name: 'FOB_FOR_AMT',
                fieldLabel: 'FOB가격',
                xtype:'uniNumberfield',
                value: 6600,
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        inputTable.setValue('CAL_SUNIM', inputTable.getValue('EXCHG_RATE_O') * newValue * inputTable.getValue('CBM'));
                    }
                }  
            },{
                name: 'CAL_STOCK_AMT',
                fieldLabel: '보관료',
                labelWidth: 170,
                xtype:'uniNumberfield',
                readOnly: true,
                colspan: 2
            },{
                name: 'CBM',
                fieldLabel: 'CBM',
                xtype:'uniNumberfield',
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        inputTable.setValue('CAL_SUNIM', inputTable.getValue('EXCHG_RATE_O') * inputTable.getValue('FOB_FOR_AMT') * newValue);
                        var LxG = inputTable.getValue('UNLOAD_AMT') * inputTable.getValue('CBM');
                        var int20000 = 20000;
                        if(LxG > int20000) {
                            inputTable.setValue('CAL_UNLOAD_AMT', int20000);    
                        } else {
                            inputTable.setValue('CAL_UNLOAD_AMT', LxG);  
                        }
                        inputTable.setValue('CAL_STOCK_AMT', ((inputTable.getValue('CAL_MUL_DAE') + inputTable.getValue('CAL_DUTY_FEE')) * (0.84/1000)) + (630 * newValue));
                        var Gx28770 = newValue * 28770;
                        var int30000 = 30000;
                        if(Gx28770 > int30000) {
                            inputTable.setValue('CAL_WORK_AMT', int30000);    
                        } else {
                            inputTable.setValue('CAL_WORK_AMT', Gx28770);  
                        }
                    }
                }  
            },{
                name: 'CAL_WORK_AMT',
                fieldLabel: '작업료',
                xtype:'uniNumberfield',
                readOnly: true,
                labelWidth: 170,
                colspan: 2
            },{
                name: 'CAL_SUNIM',
                fieldLabel: '선임',
                xtype:'uniNumberfield',
                readOnly: true
            },{
                name: 'CAL_CLEAR_AMT',
                fieldLabel: '통관료',
                xtype:'uniNumberfield',
                readOnly: true,
                labelWidth: 170,
                colspan: 2
            },{
                name: 'COMP_CODE',
                fieldLabel: 'COMP_CODE', 
                hidden:true, 
                value:UserInfo.compCode
            },{
                name: 'REMARK',
                fieldLabel: 'REMARK', 
                hidden:true
            },{
                name: 'S_USER_ID',
                fieldLabel: 'S_USER_ID', 
                hidden:true, 
                value:UserInfo.userID
            }
        ], 
        api: {
            load: 's_tix901ukrv_kdService.selectFormDetail',
            submit: 's_tix901ukrv_kdService.syncMaster'             
        }, 
        listeners : {
            uniOnChange:function( basicForm, dirty, eOpts ) {
                console.log("onDirtyChange");
                queryLoad = "N";
                if(basicForm.isDirty() && queryLoad == "N") {
                    UniAppManager.setToolbarButtons('save', true);
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }
            },
            beforeaction:function(basicForm, action, eOpts) {
                console.log("action : ",action);
                console.log("action.type : ",action.type);
                if(action.type =='directsubmit')    {
                    var invalid = this.getForm().getFields().filterBy(function(field) {
                            return !field.validate();
                    });
                        
                    if(invalid.length > 0)  {
                        r=false;
                        var labelText = ''
                        
                        if(Ext.isDefined(invalid.items[0]['fieldLabel']))   {
                            var labelText = invalid.items[0]['fieldLabel']+'은(는)';
                        }else if(Ext.isDefined(invalid.items[0].ownerCt))   {
                            var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
                        }
                        alert(labelText+Msg.sMB083);
                        invalid.items[0].focus();
                    }                                                                                                   
                }
            }
        },
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
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) ) {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true); 
                            }
                        } 
                        if(item.isPopupField) {
                            var popupFC = item.up('uniPopupField') ;       
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                //this.unmask();
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) ) {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    } 
                    if(item.isPopupField) {
                        var popupFC = item.up('uniPopupField') ; 
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        },
        setLoadRecord: function(record) {
            var me = this;   
            me.uniOpt.inLoading=false;
            me.setAllFieldsReadOnly(true);
        }
    });
	
    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
				inputTable, panelResult
			]	
		  }
		],
		id  : 's_tix901ukrv_kdApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
            this.setDefault();
		},
		onQueryButtonDown : function()	{	
			if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            
            
            inputTable.setValue('S_USER_ID', UserInfo.userID);
            inputTable.setValue('COMP_CODE', UserInfo.compCode); 
            inputTable.setValue('SO_AMT_WON', 0);     
            inputTable.setValue('EXCHG_RATE_O', 0);
            inputTable.getField('EXCHG_RATE_O').setReadOnly(true);
            inputTable.setValue('CAL_MUL_DAE', 0);    
            inputTable.setValue('LC_RATE', 0);  
            inputTable.getField('LC_RATE').setReadOnly(true);      
            inputTable.setValue('CAL_LC_FEE', 0);     
            inputTable.setValue('FOB_FOR_AMT', 6600);  
            inputTable.getField('FOB_FOR_AMT').setReadOnly(true);    
            inputTable.setValue('CBM', 0);      
            inputTable.getField('CBM').setReadOnly(true);        
            inputTable.setValue('CAL_SUNIM', 0);      
            inputTable.setValue('IMPORT_TAX_RATE', 0);
            inputTable.getField('IMPORT_TAX_RATE').setReadOnly(true); 
            inputTable.setValue('CAL_DUTY_FEE', 0);   
            inputTable.setValue('CAL_TAX_AMT', 0);    
            inputTable.setValue('UNLOAD_AMT', 12508);
            inputTable.getField('UNLOAD_AMT').setReadOnly(true);     
            inputTable.setValue('CAL_UNLOAD_AMT', 0); 
            inputTable.setValue('CAL_STOCK_AMT', 0);  
            inputTable.setValue('CAL_WORK_AMT', 0);   
            inputTable.setValue('CAL_CLEAR_AMT', 0); 
            inputTable.setValue('UNLOAD_PLACE', 0);  
            inputTable.getField('UNLOAD_PLACE').setReadOnly(true);  
            inputTable.setValue('CAL_UNIM', 0);      
            inputTable.setValue('CAL_CFS', 0);       
            inputTable.setValue('ETC_AMT', 0);   
            inputTable.getField('ETC_AMT').setReadOnly(true);      
            inputTable.setValue('CAL_RETURN', 0);    
            panelResult.getForm().wasDirty = false;
            panelResult.resetDirtyStatus();                            
            UniAppManager.setToolbarButtons(['save', 'newData', 'reset'], false); 
            
            
			var param = panelResult.getValues();
            panelResult.uniOpt.inLoading = true;
            Ext.getBody().mask('로딩중...','loading-indicator');
            panelResult.getForm().load({
                    params:param,
                    success:function(form, action)  {
                        console.log(action.result.data);
                        //var
                        //not syn
                        if(action.result.data){
//                            panelResult.setValues({
//                                'CUSTOM_CODE'   : panelResult.getValue('CUSTOM_CODE'),
//                                'CUSTOM_NAME'   : panelResult.getValue('CUSTOM_NAME'),
//                                'DATE_DEPART'   : panelResult.getValue('DATE_DEPART'),
//                                'MONEY_UNIT'    : panelResult.getValue('MONEY_UNIT'),
//                                'SO_AMT'        : panelResult.getValue('SO_AMT'),
//                                'TERMS_PRICE'   : panelResult.getValue('TERMS_PRICE'),
//                                'DELIVERY_DATE' : panelResult.getValue('DELIVERY_DATE'),
//                                'EXCHG_RATE_O'  : panelResult.getValue('EXCHG_RATE_O'),
//                                'SO_AMT_WON'    : panelResult.getValue('SO_AMT_WON')                                
//                            });
                            inputTable.getField('ETC_AMT').setReadOnly(false); 
                            inputTable.getField('UNLOAD_PLACE').setReadOnly(false); 
                            inputTable.getField('UNLOAD_AMT').setReadOnly(false); 
                            inputTable.getField('IMPORT_TAX_RATE').setReadOnly(false); 
                            inputTable.getField('FOB_FOR_AMT').setReadOnly(false); 
                            inputTable.getField('CBM').setReadOnly(false);      
                            inputTable.getField('LC_RATE').setReadOnly(false);  
                            inputTable.getField('EXCHG_RATE_O').setReadOnly(false);
                            inputTable.getForm().load({
                                params:param
                            });
                            queryLoad = "Y";
                            UniAppManager.setToolbarButtons(['save'], false); 
                        }else{
                        	
                        }
                        Ext.getBody().unmask();
                        panelResult.uniOpt.inLoading = false;
                    },
                    failure:function(batch, option){
                        Ext.getBody().unmask();
                        panelResult.uniOpt.inLoading = false;
                    }                   
            });
			UniAppManager.setToolbarButtons(['reset'], true); 
		},
		onResetButtonDown: function() {     // 초기화
            this.suspendEvents();
            panelResult.clearForm();
            inputTable.clearForm();
            panelResult.setAllFieldsReadOnly(false);
            this.setDefault();
        },
        setDefault: function() {        // 기본값
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('MONEY_UNIT', BsaCodeInfo.gsDefaultMoney);
            panelResult.setValue('DATE_DEPART', UniDate.get('today'));
            panelResult.setValue('DELIVERY_DATE', UniDate.get('today'));
            panelResult.setValue('SO_AMT', '0');
            panelResult.setValue('SO_AMT_WON', '0');
            
            inputTable.setValue('S_USER_ID', UserInfo.userID);
            inputTable.setValue('COMP_CODE', UserInfo.compCode); 
            inputTable.setValue('SO_AMT_WON', 0);     
            inputTable.setValue('EXCHG_RATE_O', 0);
            inputTable.getField('EXCHG_RATE_O').setReadOnly(true);
            inputTable.setValue('CAL_MUL_DAE', 0);    
            inputTable.setValue('LC_RATE', 0);  
            inputTable.getField('LC_RATE').setReadOnly(true);      
            inputTable.setValue('CAL_LC_FEE', 0);     
            inputTable.setValue('FOB_FOR_AMT', 6600);  
            inputTable.getField('FOB_FOR_AMT').setReadOnly(true);    
            inputTable.setValue('CBM', 0);      
            inputTable.getField('CBM').setReadOnly(true);        
            inputTable.setValue('CAL_SUNIM', 0);      
            inputTable.setValue('IMPORT_TAX_RATE', 0);
            inputTable.getField('IMPORT_TAX_RATE').setReadOnly(true); 
            inputTable.setValue('CAL_DUTY_FEE', 0);   
            inputTable.setValue('CAL_TAX_AMT', 0);    
            inputTable.setValue('UNLOAD_AMT', 12508);
            inputTable.getField('UNLOAD_AMT').setReadOnly(true);     
            inputTable.setValue('CAL_UNLOAD_AMT', 0); 
            inputTable.setValue('CAL_STOCK_AMT', 0);  
            inputTable.setValue('CAL_WORK_AMT', 0);   
            inputTable.setValue('CAL_CLEAR_AMT', 0); 
            inputTable.setValue('UNLOAD_PLACE', 0);  
            inputTable.getField('UNLOAD_PLACE').setReadOnly(true);  
            inputTable.setValue('CAL_UNIM', 0);      
            inputTable.setValue('CAL_CFS', 0);       
            inputTable.setValue('ETC_AMT', 0);   
            inputTable.getField('ETC_AMT').setReadOnly(true);      
            inputTable.setValue('CAL_RETURN', 0);    
            panelResult.getForm().wasDirty = false;
            panelResult.resetDirtyStatus();                            
            UniAppManager.setToolbarButtons(['save', 'newData', 'reset'], false); 
        },
        checkForNewDetail:function() { 
            if(panelResult.setAllFieldsReadOnly(true)){
                panelResult.setAllFieldsReadOnly(true);
                return true;
            }
            return false;
        },
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			if(inputTable.setAllFieldsReadOnly(true) == false || panelResult.setAllFieldsReadOnly(true) == false) {
                return false;
            } else {
    			var param= inputTable.getValues();
    			param.OFFER_NO = panelResult.getValue('OFFER_NO');
                param.DIV_CODE = panelResult.getValue('DIV_CODE');
                Ext.getBody().mask('로딩중...','loading-indicator');
                inputTable.getForm().submit({
                     params : param,
                     success : function(form, action) {
                        Ext.getBody().unmask();
                        inputTable.getForm().wasDirty = false;
                        inputTable.resetDirtyStatus();                                          
                        UniAppManager.setToolbarButtons('save', false); 
                        UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
                        UniAppManager.app.onQueryButtonDown();
                     }  
                });
            }
		}/*,
        fnExchngRateO:function(isIni) {
            var param = {
                "AC_DATE"    : UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE')),
                "MONEY_UNIT" : panelResult.getValue('MONEY_UNIT')
            };            
            salesCommonService.fnExchgRateO(param, function(provider, response) {   
                if(!Ext.isEmpty(provider)){
                    if(provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(panelResult.getValue('MONEY_UNIT')) && panelResult.getValue('MONEY_UNIT') != "KRW"){
                        alert('환율정보가 없습니다.')
                    }
                    panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
                    panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
                }
                
            });
        }*/
	});
};
		
</script>