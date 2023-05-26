<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 거래처팝업
request.setAttribute("PKGNAME","Unilite.app.popup.ArtKocisPopup");
%>
/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}ArtKocisPopupModel', {
    fields: [
    	{name: 'ITEM_CODE'      ,text:'<t:message code="system.label.common.itemcode2" default="작품코드"/>' 	,type:'string'  },
		{name: 'ITEM_NAME'      ,text:'<t:message code="system.label.common.itemname2" default="작품명"/>'   	,type:'string'  },
		{name: 'PURCHASE_DATE'  ,text:'<t:message code="system.label.common.acqdate" default="취득일"/>'      ,type:'uniDate' },
		{name: 'AUTHOR'      	,text:'<t:message code="system.label.common.author" default="작가명"/>' 		,type:'string'  },
		{name: 'ITEM_GBN'     	,text:'<t:message code="system.label.common.itemgbn" default="작품구분"/>'    ,type:'string'		, comboType: "AU"	, comboCode: "A396" }
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
        me.panelSearch = Unilite.createSearchForm('panelSearch',{
            layout : {type : 'uniTable', columns : 2, tableAttrs: {
                style: {
                    width: '100%'
                }
            }},
            items: [ { fieldLabel: '<t:message code="system.label.common.itemcodeorname" default="작품코드 또는 명"/>',     name:'TXT_SEARCH', labelWidth: 120,
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                     }
//                   ,{ fieldLabel: '사업자구분', 
//                      xtype: 'radiogroup', width: 230,
//                      items:[ {inputValue: '1', boxLabel:'코드순', name: 'RDO', checked: t1},
//                              {inputValue: '2', boxLabel:'이름순',  name: 'RDO', checked: t2} ]
//                   }
                    ,{ fieldLabel: '<t:message code="system.label.common.addquery" default="추가쿼리관련"/>',     name:'ADD_QUERY',   xtype: 'uniTextfield', hidden: true}
                     
            ]
        });  
        me.masterStore = Unilite.createStoreSimple('${PKGNAME}artKocisPopupMasterStore',{
            model: '${PKGNAME}ArtKocisPopupModel',
            autoLoad: false,
            proxy: {
                type: 'uniDirect',
                api: {
                    read: 'popupService.artKocisPopup'
                }
            }
	    });
        
        /**
         * Master Grid 정의(Grid Panel)
         * @type 
         */
         me.masterGrid = Unilite.createGrid('', {
            store: me.masterStore,
            selModel:'rowmodel',
            uniOpt:{
                state: {
					useState: false,
					useStateList: false	
				},
				pivot : {
					use : false
				}
	        },
            columns: [        
                { dataIndex: 'ITEM_CODE'     ,width: 130},
                { dataIndex: 'ITEM_NAME'     ,width: 200} ,
				{ dataIndex: 'AUTHOR'      	 ,width: 110},
				{ dataIndex: 'ITEM_GBN'      ,width: 110}
            ],
            listeners: {
                onGridDblClick:function(grid, record, cellIndex, colName) {
                    var rv = {
                        status : "OK",
                        data:[record.data]
                    };
                    me.returnData(rv);

                    me.masterStore.commitChanges();
                },
                beforecelldblclick:function  (grid , td , cellIndex , record , tr , rowIndex , e , eOpts ) {                    
                    
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
        
        me.masterGrid.focus();

        this.callParent();      
    },
    fnInitBinding : function(param) {
        var me = this;
        me.param = param;
        
        var frm= me.panelSearch.getForm();
        
        var fieldTxt = frm.findField('TXT_SEARCH');

        frm.setValues(param);
        if( Ext.isDefined(param)) {
            if(!Ext.isEmpty(param['ITEM_CODE'])){
                fieldTxt.setValue(param['ITEM_CODE']);            
            }
            if(!Ext.isEmpty(param['ITEM_NAME'])){
                fieldTxt.setValue(param['ITEM_NAME']);
            }
        }

        
        var tbar = me.masterGrid._getToolBar();
        if(!Ext.isEmpty(tbar)){
            tbar[0].insert(tbar.length + 1, me.decrypBtn);
        }
        
        if(frm.isValid())   {
            this._dataLoad();
        }        
    },
     onQueryButtonDown : function() {
        if(!Ext.getCmp('panelSearch').getInvalidMessage()){
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
        me.close();
    },  
    _dataLoad : function() {
            var me = this;
            var param= me.panelSearch.getValues();
            if(Ext.isEmpty(param.CUSTOM_TYPE) && !Ext.isEmpty(me.param.CUSTOM_TYPE))    {
                param.CUSTOM_TYPE =me.param.CUSTOM_TYPE
            }
            console.log( "_dataLoad: ", param );
            if(me.panelSearch.isValid())    {
            	me.isLoading = true;
                me.masterGrid.getStore().load({
                    params : param,
					callback:function()	{
						me.isLoading = false;
					}
                });
            }
    }
});


