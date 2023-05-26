<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'거래처기초잔액등록',
        xtype: 'uniDetailFormSimple',
        itemId: 'sbs030ukrvs4Tab',
        id: 'sbs030ukrvs4Tab',
        layout: {type: 'vbox', align:'stretch'},
        padding: '0 0 0 0',
        items:[{
                xtype: 'container',   
//                region: 'north',
                layout: {type: 'uniTable', columns: 2},        
                items : [{ 
    					fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
    					name: 'DIV_CODE',
    					xtype: 'uniCombobox',
                        value: UserInfo.divCode,
    					comboType: 'BOR120',
    					allowBlank: false
    				}, {
    					xtype: 'uniMonthfield',
    					fieldLabel: '기초년월',
    					name:'BASIS_YYYYMM',
    					value		: UniDate.get('today'),
    					allowBlank: false
    				}, {
    					fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
    					name:'AGENT_TYPE',
    					xtype: 'uniCombobox', 
    					comboType:'AU',
    					comboCode:'B055'
    				},
    				Unilite.popup('AGENT_CUST',{
    					fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>', 
                        valueFieldName: 'CUSTOM_CODE', 
                        textFieldName: 'CUSTOM_NAME',
                        validateBlank	: false,
                        listeners       : {
                        onValueFieldChange: function(field, newValue, oldValue){
                                if(!Ext.isObject(oldValue)) {
                                    panelDetail.down('#sbs030ukrvs4Tab').setValue('CUSTOM_NAME','');
                                }
                            },
                            onTextFieldChange: function(field, newValue, oldValue){
                                if(!Ext.isObject(oldValue)) {
                                    panelDetail.down('#sbs030ukrvs4Tab').setValue('CUSTOM_CODE','');
                                }
                            },
                            applyextparam: function(popup){
                                popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','3']});
                                popup.setExtParam({'CUSTOM_TYPE'        : ['1','3']});
                            }
                        }
				    })
				]
			}, {
                xtype: 'uniGridPanel',     
                region: 'center',
                itemId:'sbs030ukrvs4Grid',
                id:'sbs030ukrvs4Grid',
                store : sbs030ukrvs4Store,
                padding: '0 0 0 0',
                dockedItems: [{
                    xtype: 'toolbar',
                    dock: 'top',
                    padding:'0px',
                    border:0
                }],
                uniOpt: {
                    expandLastColumn: true,
                    useRowNumberer: true,
                    onLoadSelectFirst: true,
                    useMultipleSorting: false
                },              
                columns: [
                	{dataIndex: 'DIV_CODE'			    ,		width: 100, hidden: true },				  	  
					{dataIndex: 'CUSTOM_CODE'		    ,		width: 100 ,
                      'editor': Unilite.popup('AGENT_CUST_G',{
                            textFieldName   : 'CUSTOM_CODE',
                            DBtextFieldName : 'CUSTOM_CODE',
                            allowBlank      : false,
                            autoPopup       : true,
                            listeners       : { 
                                'onSelected': {
                                    fn: function(records, type  ){
                                        var grdRecord = panelDetail.down('#sbs030ukrvs4Grid').uniOpt.currentRecord;
                                        grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                                        grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                                    },
                                    scope: this
                                },
                                'onClear' : function(type)  {
                                    var grdRecord = panelDetail.down('#sbs030ukrvs4Grid').uniOpt.currentRecord;
                                    grdRecord.set('CUSTOM_CODE','');
                                    grdRecord.set('CUSTOM_NAME','');
                                },
                                'applyextparam': function(popup){
                                    popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','3']});
                                    popup.setExtParam({'CUSTOM_TYPE'        : ['1','3']});
                                }
                            }
                        })
                    },
                    {dataIndex: 'CUSTOM_NAME'         ,   width: 166,
                      'editor': Unilite.popup('AGENT_CUST_G',{
                            allowBlank      : false,
                            autoPopup       : true,
                            listeners       : {
                                'onSelected': {
                                    fn: function(records, type  ){
                                        var grdRecord = panelDetail.down('#sbs030ukrvs4Grid').uniOpt.currentRecord;
                                        grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                                        grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                                    },
                                    scope: this
                                },
                                'onClear' : function(type)  {
                                    var grdRecord = panelDetail.down('#sbs030ukrvs4Grid').uniOpt.currentRecord;
                                    grdRecord.set('CUSTOM_CODE','');
                                    grdRecord.set('CUSTOM_NAME','');
                                },
                                'applyextparam': function(popup){
                                    popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','3']});
                                    popup.setExtParam({'CUSTOM_TYPE'        : ['1','3']});
                                }
                            }
                        })
                    },				  	  
					{dataIndex: 'MONEY_UNIT'		    ,		width: 100 },				  	  
					{dataIndex: 'BASIS_AMT_O'		    ,		width: 200 },				  	  
					{dataIndex: 'BASIS_YYYYMM'		    ,		width: 100, hidden: true },				  	  
					{dataIndex: 'CREATE_LOC'		    ,		width: 66, hidden: true },	                 
                    {dataIndex: 'UPDATE_DB_USER'        ,       width: 66, hidden: true },                
                    {dataIndex: 'UPDATE_DB_TIME'        ,       width: 66, hidden: true },                
                    {dataIndex: 'COMP_CODE'             ,       width: 66, hidden: true }
			   ],
               listeners: {
                    beforeedit  : function( editor, e, eOpts ) {
                        if(!e.record.phantom) {
                            if(UniUtils.indexOf(e.field, ['CUSTOM_CODE','CUSTOM_NAME', 'MONEY_UNIT'])) { 
                                return false;
                            } else {
                                return true;
                            }
                        } else {
                            return true; 
                        }
                    }
               }
            }
        ],
         setAllFieldsReadOnly4 : function(b) {
                var r= true
                if(b) {
                    var invalid = this.getForm().getFields().filterBy(function(field) {
                                                                        return !field.validate();
                                                                    });
    
                    if(invalid.length > 0) {
                        r=false;
                        var labelText = ''
        
                        if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                            var labelText = invalid.items[0]['fieldLabel']+' : ';
                        } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                            var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                        }
    
                        Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
                        invalid.items[0].focus();
                    } else {
                    //  this.mask();            
                    }
                } else {
                    this.unmask();
                }
                return r;
            }
    }