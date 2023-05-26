<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.NegoIncomNoPopup");
%>
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 

	 Unilite.defineModel('${PKGNAME}.NegoIncomNoPopupModel', {
	    fields: [
	        {name: 'NEGO_INCOM_NO'         ,text:'<t:message code="system.label.common.amountmanageno" default="대금관리번호"/>'                ,type:'string'},
            {name: 'NEGO_DIV'                   	 ,text:'<t:message code="system.label.common.division" default="사업장"/>'                    ,type:'string', comboType: "BOR120"},
            {name: 'NEGO_DATE'                   	,text:'<t:message code="system.label.common.suppdate" default="지급일"/>'                    ,type:'uniDate'},
            {name: 'NEGO_NM'                     	,text:'<t:message code="system.label.common.charger" default="담당자"/>'                    ,type:'string'},
            {name: 'PAY_BANK'                    	,text:'<t:message code="system.label.common.suppbank" default="지급은행"/>'                   ,type:'string'},
            {name: 'EXPORTER'                    	,text:'<t:message code="system.label.common.exporter" default="수출자"/>'                    ,type:'string'},
            {name: 'EXPORTER_NM'               ,text:'<t:message code="system.label.common.exporter" default="수출자"/>'                    ,type:'string'},
            {name: 'DIV_CODE'                    	, text: 'DIV_CODE'              , type: 'string'},
            {name: 'PROJECT_NO'                  , text: 'PROJECT_NO'            , type: 'string'}
        ]
	});

    
    
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
    me.panelSearch = Unilite.createSearchForm('',{
        layout: {
        	type: 'uniTable', 
        	columns: 2, 
        	tableAttrs: {
	            style: {
	                width: '100%'
	            }
	        }
	    },
        items: [{
            fieldLabel: '<t:message code="system.label.common.manageno" default="관리번호"/>',
            xtype: 'uniTextfield',
            name: 'NEGO_SER_NO',
            colspan: 2
        },{
			fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>'  ,
			name: 'DIV_CODE',
			xtype:'uniCombobox',
			comboType:'BOR120',
			readOnly: true,
			value: UserInfo.divCode
		},{
            fieldLabel: '<t:message code="system.label.common.tradetype" default="무역종류"/>',
            name: 'TRADE_TYPE',
            xtype: 'uniCombobox',               
            comboType: 'AU',
            comboCode: 'T002'
        }, {
			fieldLabel: '<t:message code="system.label.common.suppdate" default="지급일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'PAY_DATE_FR',
			endFieldName: 'PAY_DATE_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today')			
		}]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.negoIncomNoPopupStore',{
							model: '${PKGNAME}.NegoIncomNoPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.negoIncomNoPopup'
					            }
					        }
					}),
	        uniOpt:{
                 expandLastColumn: false
                ,useRowNumberer: false,
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
                 { dataIndex: 'NEGO_INCOM_NO'               , width: 120 },
                 { dataIndex: 'NEGO_DIV'                    , width: 120 },
                 { dataIndex: 'NEGO_DATE'                   , width: 120 },
                 { dataIndex: 'NEGO_NM'                     , width: 120 },
                 { dataIndex: 'PAY_BANK'                    , width: 120 },
                 { dataIndex: 'EXPORTER'                    , width: 120, hidden: true },
                 { dataIndex: 'EXPORTER_NM'                 , width: 120 }
	        ],
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
	    
		config.items = [me.panelSearch, 	me.masterGrid];
      	me.callParent(arguments);
    },
    initComponent : function(){    
    	var me  = this;
        
        me.masterGrid.focus();
        
    	this.callParent();    	
    },
	fnInitBinding : function(param) {
        var me = this;
//		
//		var frm= me.panelSearch.getForm();
//		
//		var rdo = frm.findField('RDO');
//		var fieldTxt = frm.findField('TXT_SEARCH');
//		me.panelSearch.setValue('PAY_DATE_FR', new Date());
//		me.panelSearch.setValue('PAY_DATE_TO', UniDate.get('startOfMonth', me.panelSearch.getValue('BL_DATE_TO')));
		if( Ext.isDefined(param)) {
//			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
//				if(param['TYPE'] == 'VALUE') {
//					fieldTxt.setValue(param['ASSET_CODE']);
//					rdo.setValue({ RDO : '1'});
//				} else {
//					fieldTxt.setValue(param['ASSET_NAME']);
//					rdo.setValue({ RDO : '2'});
//				}
//			}
			me.panelSearch.setValues(param);
		}
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        var me = this;
		var selectRecord = me.masterGrid.getSelectedRecord();
		var rv ;
		if(selectRecord)	{
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

