<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.SwCodePopup");
%>

/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.SwCodePopupModel', {
    fields: [
            {name : 'MAIN_CODE',            text : 'SW<t:message code="system.label.common.code" default="코드"/>',        type : 'string'},
            {name : 'MAIN_NAME',            text : 'SW<t:message code="system.label.common.name" default="명"/>',          type : 'string'},
            {name : 'SW_CODE',              		text : 'SW<t:message code="system.label.common.code" default="코드"/>',        type : 'string'},
            {name : 'SW_NAME',              	text : 'SW<t:message code="system.label.common.name" default="명"/>',          type : 'string'}
        ]
});


/**
 * 검색조건 (Search Panel)
 * @type 
 */
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    constructor : function(config) {
        var me = this;
        if (config) {
            Ext.apply(me, config);
        }
        /**
         * 검색조건 (Search Panel)
         * @type 
         */
        var wParam = this.param;
        var t1= false, t2 = false;
        if( Ext.isDefined(wParam)) {
            if(wParam['TYPE'] == 'VALUE') {
                t1 = true;
                t2 = false;
                
            } else {
                t1 = false;
                t2 = true;
                
            }
        }
        
        me.panelSearch =  Unilite.createSearchForm('',{
            layout : {type : 'table', columns : 2},
            items: [{
                    fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',
                    name:'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType:'BOR120',
                    value: UserInfo.divCode,
                    hidden: true
               },{
                    fieldLabel: '<t:message code="system.label.common.software" default="소프트웨어"/>',
                    name:'MAIN_CODE',
                    allowBlank: false,
                    readOnly: true,
                    xtype: 'uniCombobox', 
                    comboType:'AU',
                    comboCode:'WZ20',
                    holdable: 'hold'
                }
            ],
            setAllFieldsReadOnly : function(b) { 
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
/**
 * Master Grid 정의(Grid Panel)
 * @type 
 */
         me.masterGrid = Unilite.createGrid('', {
            store: Unilite.createStore('${PKGNAME}.SwCodePopupMasterStore',{
                            model: '${PKGNAME}.SwCodePopupModel',
                            autoLoad: false,
                            proxy: {
                                type: 'uniDirect',
                                api: {
                                    read: 'popupService.swCodePopup'
                                }
                            },
                            saveStore : function(config)    {               
                                var inValidRecs = this.getInvalidRecords();
                                if(inValidRecs.length == 0 )    {
                                    //this.syncAll(config);
                                    this.syncAllDirect(config);
                                }else {
                                    alert(Msg.sMB083);
                                }
                            }
                    }),
            uniOpt:{
                state: {
					useState: false,
					useStateList: false	
	            },
				pivot : {
					use : false
				}
		    },
            selModel:'rowmodel',
            columns:  [ 
            {dataIndex : 'MAIN_CODE',               width : 100, hidden : true},
            {dataIndex : 'MAIN_NAME',               width : 130, hidden : true},
            {dataIndex : 'SW_CODE',                 width : 100},
            {dataIndex : 'SW_NAME',                 width : 200}
        ] ,
                listeners: {
                    onGridDblClick:function(grid, record, cellIndex, colName) {
                        var rv = {
                            status : "OK",
                            data:[record.data]
                        };
                        me.returnData(rv);
                    },
                    onGridKeyDown: function(grid, keyCode, e) {
                        if(e.getKey() == Ext.EventObject.ENTER) {
                            var selectRecord = grid.getSelectedRecord();
                            var rv = {
                                status : "OK",
                                data:[selectRecord.data]
                            };
                            me.returnData(rv);
                        }
                    }
                }
            });
            config.items = [me.panelSearch, me.masterGrid];
            me.callParent(arguments);
        },
        initComponent : function(){    
            var me  = this;
//          me.masterGrid.focus();
            this.callParent();      
        },    
        fnInitBinding : function(param) {
            var me = this;
            me.param = param;
            var frm= me.panelSearch.getForm();
            var fieldTxt = frm.findField('MAIN_CODE');
            me.panelSearch.setValue('DIV_CODE', param.DIV_CODE);
            me.panelSearch.setValue('MAIN_CODE', param.MAIN_CODE);
            
            frm.findField('DIV_CODE').setReadOnly(true);

            this._dataLoad();
        },
         onQueryButtonDown : function() {
            var me = this;
            
            if(me.panelSearch.setAllFieldsReadOnly(true) == false){
                return false;
            }
            this._dataLoad();
        },
        onSubmitButtonDown : function() {
            var me = this;
            var selectRecord = me.masterGrid.getSelectedRecord();
            var rv ;
            if(selectRecord)    {
                rv = {
                    status : "OK",
                    data:[selectRecord.data]
                };
            }
            me.returnData(rv);
        },
        _dataLoad : function() {
                var me = this;
                var param= me.panelSearch.getValues();
                console.log( "_dataLoad: ", param );
                me.isLoading = true;
                me.masterGrid.getStore().load({
                    params : param,
					callback:function()	{
						me.isLoading = false;
					}
                });
        }
    });
