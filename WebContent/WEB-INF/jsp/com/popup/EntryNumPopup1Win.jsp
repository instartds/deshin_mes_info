<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.EntryNumPopup1");
%>

/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.EntryNumPopup1Model', {
    fields: [
            {name : 'COMP_CODE',            text : '<t:message code="system.label.common.companycode" default="법인코드"/>',       type : 'string'},
            {name : 'DIV_CODE',             	   text : '<t:message code="system.label.common.division" default="사업장"/>',         type : 'string', comboType : "BOR120"},
            {name : 'ENTRY_NUM',            text : '<t:message code="system.label.common.affilcode2" default="관리코드"/>',        type : 'string'},
            {name : 'ENTRY_DATE',            text : '<t:message code="system.label.common.entrydate" default="등록일"/>',        type : 'uniDate'},
            {name : 'DEPT_CODE',              text : '<t:message code="system.label.common.departmencode" default="부서코드"/>',        type : 'string'},
            {name : 'DEPT_NAME',             text : '<t:message code="system.label.common.departmentname" default="부서명"/>',         type : 'string'},
            {name : 'OEM_ITEM_CODE',     text : '<t:message code="system.label.common.itemcode" default="품목코드"/>',          type : 'string'},
            {name : 'ITEM_NAME',            	text : '<t:message code="system.label.common.itemname" default="품목명"/>',          type : 'string'},
            {name : 'MAKE_QTY',             	text : '<t:message code="system.label.common.moldqty" default="금형벌수"/>',        type : 'uniQty'},
            {name : 'MAKE_END_YN',          text : '<t:message code="system.label.common.makeendyn" default="가공완료"/>',        type : 'string'},
            {name : 'CUSTOM_CODE',          text : '<t:message code="system.label.common.suppliercode" default="납품업체"/>',        type : 'string'},
            {name : 'CUSTOM_NAME',          text : '<t:message code="system.label.common.suppliername" default="납품업체명"/>',       type : 'string'}
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
                    allowBlank: false,
                    xtype: 'uniCombobox',
                    comboType:'BOR120',
                    value: UserInfo.divCode
               },{
                    fieldLabel: '<t:message code="system.label.common.entrydate" default="등록일"/>',
                    xtype: 'uniDateRangefield',
                    allowBlank: false,
                    startFieldName: 'FR_DATE',
                    endFieldName: 'TO_DATE',
                    startDate: UniDate.get('startOfMonth'),
                    endDate: UniDate.get('today')
                },{
                    fieldLabel: '<t:message code="system.label.common.affilcode2" default="관리코드"/>',
                    name:'ENTRY_NUM',  
                    xtype: 'uniTextfield'
                },{
                    fieldLabel: '<t:message code="system.label.common.itemcode" default="품목코드"/>',
                    name:'OEM_ITEM_CODE',  
                    xtype: 'uniTextfield'
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
            store: Unilite.createStore('${PKGNAME}.EntryNumPopup1MasterStore',{
                            model: '${PKGNAME}.EntryNumPopup1Model',
                            autoLoad: false,
                            proxy: {
                                type: 'uniDirect',
                                api: {
                                    read: 'popupService.entryNumPopup1'
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
                {dataIndex : 'COMP_CODE',           width : 100, hidden : true},            
                {dataIndex : 'DIV_CODE',            width : 110},
                {dataIndex : 'ENTRY_NUM',           width : 100},
                {dataIndex : 'ENTRY_DATE',          width : 100, align : 'center'},
                {dataIndex : 'DEPT_CODE',           width : 110},
                {dataIndex : 'DEPT_NAME',           width : 150},
                {dataIndex : 'OEM_ITEM_CODE',       width : 120},
                {dataIndex : 'ITEM_NAME',           width : 180},
                {dataIndex : 'MAKE_QTY',            width : 110},
                {dataIndex : 'MAKE_END_YN',         width : 100},
                {dataIndex : 'CUSTOM_CODE',         width : 110},
                {dataIndex : 'CUSTOM_NAME',         width : 180}
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
            var fieldTxt = frm.findField('ENTRY_NUM');
            me.panelSearch.setValue('DIV_CODE', param.DIV_CODE);
            me.panelSearch.setValue('FROM_DATE', UniDate.get('startOfMonth'));
            me.panelSearch.setValue('TO_DATE', UniDate.get('today'));
            me.panelSearch.setValue('ENTRY_NUM', param.ENTRY_NUM);
            
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
