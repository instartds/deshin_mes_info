<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 작업장 팜업
request.setAttribute("PKGNAME","Unilite.app.popup.TreeCodePopup");
%>


/**
 *   Model 정의
 * @type
 */
Unilite.defineModel('${PKGNAME}.TreeCodePopupModel', {
    fields: [ 	 {name: 'COMP_CODE' 		,text:'<t:message code="system.label.common.companycode" default="법인코드"/>' 		,type:'string'	}
    			,{name:'TREE_CODE'     		,text: '<t:message code="system.label.common.treecode" default="공구코드"/>'		,type:'string'	, allowBlank: false}
				,{name:'TREE_NAME'      	,text: '<t:message code="system.label.common.treename" default="공구명"/>'			,type:'string'	, allowBlank: false}
				,{name:'SPEC'       				,text: '<t:message code="system.label.common.spec" default="규격"/>'			,type:'string'		}
				,{name:'BASE_P'					,text: '<t:message code="system.label.common.basisprice" default="기준단가"/>'		,type: 'uniUnitPrice'}
				,{name:'USE_YN'					,text:'<t:message code="system.label.common.useyn" default="사용여부"/>'		,type : 'string',	comboType: "AU", comboCode: "A004"}
				,{name:'REMARK'     			,text: '<t:message code="system.label.common.remark" default="적요"/>'			,type:'string'}
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
    	console.log("wParam::::::::",wParam['TYPE']);
    	console.log("wParam::::::::",wParam['TYPE']);
    	console.log("wParam::::::::",wParam['TYPE']);
    	console.log("wParam::::::::",wParam['TYPE']);
    	console.log("wParam::::::::",wParam['TYPE']);
    	console.log("wParam::::::::",wParam['TYPE']);
        if(wParam['TYPE'] == 'VALUE') {
            t1 = true;
            t2 = false;
        } else {
            t1 = false;
            t2 = true;
        }
    }
	me.panelSearch = Unilite.createSearchForm('',{
	    layout : {type : 'uniTable', columns : 2, tableAttrs: {
	        style: {
	            width: '100%'
	        }
	    }},
	    items: [ { fieldLabel: '<t:message code="system.label.common.searchword" default="검색어"/>',   	name: 'TXT_SEARCH' 		, xtype: 'uniTextfield' ,
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
	            ,{ fieldLabel: '<t:message code="system.label.common.treecode" default="공구코드"/>',   name: 'TREE_CODE' 		, xtype: 'uniTextfield', hidden: true }
	            ,{ fieldLabel: '<t:message code="system.label.common.treename" default="공구명"/>',   	 name: 'TREE_NAME' 		, xtype: 'uniTextfield', hidden: true }
	            ,{ fieldLabel: ' ',
	                    xtype: 'radiogroup', width: 230, name: 'rdoRadio',
	                     items:[    {inputValue: '1', boxLabel: '<t:message code="system.label.common.codeinorder" default="코드순"/>', name: 'RDO', checked: t1},
	                                {inputValue: '2', boxLabel: '<t:message code="system.label.common.nameinorder" default="이름순"/>',  name: 'RDO', checked: t2} ]
	               }

	        ]

	});

/**
 * Master Grid 정의(Grid Panel)
 * @type
 */
	 var masterGridConfig = {
		store: Unilite.createStore('${PKGNAME}.TreeCodePopupMasterStore',{
						model: '${PKGNAME}.TreeCodePopupModel',
				        autoLoad: false,
				        proxy: {
				            type: 'direct',
				            api: {
				            	read: 'popupService.treeCodePopup'
				            }
				        }
				}),

        uniOpt:{
//            useRowNumberer: false,
            onLoadSelectFirst : false  ,
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
	           		 { dataIndex: 'COMP_CODE' 	 		,width: 120, hidden: true }
					,{ dataIndex: 'TREE_CODE' 	 		,width: 120 }
					,{ dataIndex: 'TREE_NAME' 	 		,width: 150 }
					,{ dataIndex: 'SPEC' 		 		,width: 120, hidden: false }
					,{ dataIndex: 'BASE_P' 		 		,width: 120, hidden: false }
					,{ dataIndex: 'USE_YN' 		 		,width: 120, hidden: false }
					,{ dataIndex: 'REMARK' 		 		,width: 120, hidden: false }

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
	    };
	    if(Ext.isDefined(wParam)) {
			 if(wParam['SELMODEL'] == 'MULTI') {
			  masterGridConfig.selModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : false });
			 }
		 }
		 me.masterGrid = Unilite.createGrid('', masterGridConfig);

		config.items = [me.panelSearch,	me.masterGrid];
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
		var rdo = frm.findField('rdoRadio');
		var fieldTxt=frm.findField('TXT_SEARCH');
		if( Ext.isDefined(param)) {
			frm.setValues(param);
			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
				debugger;
				if(param['TYPE'] == 'VALUE') {
					fieldTxt.setValue(param['TREE_CODE']);
					rdo.setValue('1');
				} else {
					fieldTxt.setValue(param['TREE_NAME']);
					rdo.setValue('2');
					fieldTxt.setFieldLabel('공구명');
				}
			}
		}
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        var me = this;
		var selectRecords = me.masterGrid.getSelectedRecords();
		var rvRecs= new Array();
		Ext.each(selectRecords, function(record, i)	{
			rvRecs[i] = record.data;
		})
	 	var rv = {
			status : "OK",
			data:rvRecs
		};
		me.returnData(rv);
	},
	_dataLoad : function() {
		var me = this;
		if(me.panelSearch.isValid())	{
			var param= me.panelSearch.getValues();
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

