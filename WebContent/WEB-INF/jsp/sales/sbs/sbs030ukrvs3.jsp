<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'적요등록',
        xtype: 'uniDetailFormSimple',
        itemId: 'sbs030ukrvs3Tab',
        id: 'sbs030ukrvs3Tab',
        layout: {type: 'vbox', align:'stretch'},
        padding: '0 0 0 0',
        items:[{
                xtype: 'container',   
//                region: 'north',
                layout: {type: 'uniTable', columns: 2},        
                items : [{
					fieldLabel: '적요구분',
					name:'REMARK_TYPE', 
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'B058',
					value: '11',
					allowBlank: false
				}, 
			    Unilite.popup('REMARK_DISTRIBUTION',{
					fieldLabel: '적요코드', 
                    valueFieldName: 'REMARK_CD', 
                    textFieldName: 'REMARK_NAME',
                    listeners: {
                        applyextparam: function(popup){                         
                            popup.setExtParam({'REMARK_TYPE': panelDetail.down('#sbs030ukrvs3Tab').getValue('REMARK_TYPE')});
                        }
                    }
				})]
			}, {
                xtype: 'uniGridPanel',     
                region: 'center',
                itemId:'sbs030ukrvs3Grid',
                id:'sbs030ukrvs3Grid',
                store : sbs030ukrvs3Store,
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
                	{dataIndex: 'REMARK_TYPE'		 		,		width: 133, hidden: true},
					{dataIndex: 'REMARK_CD'				    ,		width: 100},
					{dataIndex: 'REMARK_NAME'				,		width: 300},
                    {dataIndex: 'COMP_CODE'                 ,       width: 153, hidden: true} 					  	  
			    ],
                listeners: {
                    beforeedit  : function( editor, e, eOpts ) {
                        if(!e.record.phantom) {
                            if(UniUtils.indexOf(e.field, ['REMARK_NAME'])) { 
                                return true;
                            } else {
                                return false;
                            }
                        } else {
                            return true; 
                        }
                    }
                }
		    }
        ],
         setAllFieldsReadOnly3 : function(b) {
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