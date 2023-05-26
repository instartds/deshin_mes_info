<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.BudgKocisNormalPopup");
%>

	 Unilite.defineModel('${PKGNAME}.BudgKocisNormalPopupModel', {
	    fields: [
            {name: 'DEPT_CODE'          , text: '기관코드'          , type: 'string'},
            {name: 'DEPT_NAME'          , text: '기관명'           , type: 'string'},
    	    {name: 'BUDG_CODE'          , text: '예산코드'          , type: 'string'},
            {name: 'BUDG_NAME'          , text: '예산명'          , type: 'string'},
            {name: 'USE_YN'             , text: '사용여부'          , type: 'string',comboType:'AU', comboCode:'A020'}
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
        items: [
        	{ xtype: 'uniTextfield',      fieldLabel: '조회조건',     name:'TXT_SEARCH'},
            { xtype: 'uniTextfield',      name:'ADD_QUERY', hidden: true},
            { xtype: 'uniTextfield',      name:'AC_YYYY', hidden: true},
            { xtype: 'uniTextfield',      name:'DEPT_CODE', hidden: true},
            
            { xtype: 'uniTextfield',      name:'AC_GUBUN', hidden: true}
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.budgKocisNormalPopupStore',{
							model: '${PKGNAME}.BudgKocisNormalPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.budgKocisNormalPopup'
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
	        columns:[    
                { dataIndex: 'DEPT_CODE'            ,width: 150 , hidden:true},
                { dataIndex: 'DEPT_NAME'            ,width: 150 },
                { dataIndex: 'BUDG_CODE'            ,width: 170 ,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                    }
                },
                { dataIndex: 'BUDG_NAME'            ,width: 150 },            
                { dataIndex: 'USE_YN'               ,width: 150 , hidden:true}
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
		var frm= me.panelSearch.getForm();		
		var fieldTxt = frm.findField('TXT_SEARCH');
		me.panelSearch.setValues(param);
		if(param['TYPE'] == 'VALUE') {
        	if(!Ext.isEmpty(param['BUDG_CODE'])){
        		fieldTxt.setValue(param['BUDG_CODE']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['BUDG_CODE'])){
        		fieldTxt.setValue(param['BUDG_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['BUDG_NAME'])){
        		fieldTxt.setValue(param['BUDG_NAME']);
        	}
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

