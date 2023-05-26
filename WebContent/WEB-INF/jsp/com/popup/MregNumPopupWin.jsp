<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.MregNumPopup");
%>

/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.MregNumPopupModel', {
    fields: [
            {name : 'COMP_CODE',            text : '<t:message code="system.label.common.companycode" default="법인코드"/>',          type : 'string'},
            {name : 'DIV_CODE',             text : '<t:message code="system.label.common.businessnumber" default="사업자번호"/>',         type : 'string'},
            {name : 'EQDOC_CODE',           text : '<t:message code="system.label.common.eqdoccode" default="장비대장번호"/>',       type : 'string'},
            {name : 'MGM_DEPT_CODE',        text : '관리부서',          type : 'string'},
            {name : 'MGM_DEPT_NAME',        text : '관리부서',         type : 'string'},
            {name : 'INS_DEPT_CODE',        text : '설치부서',          type : 'string'},
            {name : 'INS_DEPT_NAME',        text : '설치부서',         type : 'string'},
            {name : 'BUY_DATE',             text : '<t:message code="system.label.common.purchasedate" default="구입일"/>',          type : 'uniDate'},
            {name : 'ITEM_NAME',            text : '<t:message code="system.label.base.goodsname" default="제품명"/>',            type : 'string'}, 
            {name : 'EQDOC_TYPE',           text : '<t:message code="system.label.common.equiptype" default="장비구분"/>',          type : 'string', comboType : 'AU', comboCode : 'WZ10'},
            {name : 'EQDOC_SPEC',           text : '<t:message code="system.label.common.spec" default="규격"/>',             type : 'string'},
            {name : 'MAKE_COMP',            text : '<t:message code="system.label.common.makecomp" default="제조업체"/>',          type : 'string'},
            {name : 'MODEL_NO',             text : '<t:message code="system.label.common.model" default="모델"/>No',           type : 'string'},
            {name : 'SERIAL_NO',            text : 'Serial_No',       type : 'string'},
            {name : 'REMARK',               text : '비고',       type : 'string'},
            {name : 'M_REG_NUM',            text : '<t:message code="system.label.common.mregnum" default="모니터등록"/> No',      type : 'string'}
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
                    value: UserInfo.divCode,
                    hidden:true
               },{
                    fieldLabel: '규격',
                    name:'EQDOC_SPEC',
                    xtype: 'uniTextfield'
                },{
                    fieldLabel: '모델명',
                    name:'MODEL_NO',
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
            store: Unilite.createStore('${PKGNAME}.MregNumPopupMasterStore',{
                            model: '${PKGNAME}.MregNumPopupModel',
                            autoLoad: false,
                            proxy: {
                                type: 'uniDirect',
                                api: {
                                    read: 'popupService.mRegNumPopup'
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
            {dataIndex : 'COMP_CODE',                   width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',                    width : 130, hidden : true},
            
            {dataIndex : 'EQDOC_CODE',                       width : 100},
            {dataIndex : 'MGM_DEPT_CODE',                    width : 100, hidden : true},
            {dataIndex : 'MGM_DEPT_NAME',                    width : 100},
            {dataIndex : 'INS_DEPT_CODE',                    width : 100, hidden : true},
            {dataIndex : 'INS_DEPT_NAME',                    width : 100},
            {dataIndex : 'BUY_DATE',                         width : 100},
            {dataIndex : 'ITEM_NAME',                        width : 100},
            {dataIndex : 'EQDOC_TYPE',                       width : 100},
            {dataIndex : 'EQDOC_SPEC',                       width : 100},
            {dataIndex : 'MAKE_COMP',                        width : 100},
            {dataIndex : 'MODEL_NO',                         width : 100},
            {dataIndex : 'SERIAL_NO',                        width : 100},
            {dataIndex : 'REMARK',                           width : 100},
            {dataIndex : 'M_REG_NUM',                   width : 120, hidden : true}
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
            var fieldTxt = frm.findField('M_REG_NUM');
            me.panelSearch.setValue('DIV_CODE', param.DIV_CODE);
            me.panelSearch.setValue('M_REG_NUM', param.M_REG_NUM);
            
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
