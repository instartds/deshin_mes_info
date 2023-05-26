<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.EquMachCodePopup");
%>
	/**
	 *   Model 정의 
	 */
	 Unilite.defineModel('${PKGNAME}.EquMachCodePopupModel', {
	    fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'              ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'               ,type: 'string'},
            {name: 'EQU_CODE_TYPE'          ,text:'장비구분'              ,type: 'string'},
            {name: 'EQU_CODE_TYPE_NAME'     ,text:'장비구분'              ,type: 'string'},
            {name: 'EQU_MACH_CODE'          ,text:'설비코드'              ,type: 'string'},
            {name: 'EQU_MACH_NAME'          ,text:'설비명'               ,type: 'string'},
            {name: 'EQU_SPEC'               ,text:'설비규격'              ,type: 'string'},
            {name: 'CUSTOM_CODE'            ,text:'제작처코드'             ,type: 'string'},
            {name: 'CUSTOM_NAME'            ,text:'제작처'               ,type: 'string'},
            {name: 'PRODT_DATE'             ,text:'제작일'               ,type: 'string'},
            {name: 'PRODT_O'                ,text:'제작금액'              ,type: 'uniPrice'},
            //20210602 추가
            {name: 'WORK_SHOP_CODE'         ,text:'작업장'               ,type: 'string'},
            {name: 'PROG_WORK_CODE'         ,text:'공정코드'              ,type: 'string'}
        ]
	});

    
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    autoScroll : true,
	constructor : function(config){
        var me = this;
        if (config) {
            Ext.apply(me, config);
        }
        me.form = Unilite.createSearchForm('', {
                        layout : {type : 'uniTable', columns : 2 },
                        items : [{
                            fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',
                            name:'DIV_CODE',
                            xtype: 'uniCombobox',
                            comboType:'BOR120',
                            allowBlank:false
                        },{
                          fieldLabel : '<t:message code="system.label.common.searchword" default="검색어"/>',
                          name : 'TXT_SEARCH',
                          xtype: 'uniTextfield',
                            listeners:{
                                specialkey: function(field, e){
                                    if (e.getKey() == e.ENTER) {
                                       me.onQueryButtonDown();
                                    }
                                }
                            }
                        }]
                    });
		me.grid = Ext.create('Unilite.com.grid.UniGridPanel',{
			
            store : Unilite.createStoreSimple('${PKGNAME}.EquMachCodePopupMasterStore',{
							model: '${PKGNAME}.EquMachCodePopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.equMachCodePopup'
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
                { dataIndex: 'EQU_CODE_TYPE'                               ,           width: 100,hidden:true},
                { dataIndex: 'EQU_CODE_TYPE_NAME'                          ,           width: 80},
                { dataIndex: 'EQU_MACH_CODE'                               ,           width: 100},
                { dataIndex: 'EQU_MACH_NAME'                               ,           width: 120},
                { dataIndex: 'EQU_SPEC'                                    ,           width: 120},
                { dataIndex: 'CUSTOM_CODE'                                 ,           width: 100},
                { dataIndex: 'CUSTOM_NAME'                                 ,           width: 120},
                { dataIndex: 'PRODT_DATE'                                  ,           width: 80},
                { dataIndex: 'PRODT_O'                                     ,           width: 100},
                //20210602 추가
                { dataIndex: 'WORK_SHOP_CODE'                              ,           width: 100, hidden:true},
                { dataIndex: 'PROG_WORK_CODE'                              ,           width: 100, hidden:true}
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
        config.items = [me.form, me.grid];
        me.callParent(arguments);
	},  //constructor
	initComponent : function(){    
    	var me  = this;
        
        me.grid.focus();
        
    	this.callParent();    	
    },	
	fnInitBinding : function(param) {
		var frm= this.form;
        if(param) {
			
			if(param['DIV_CODE'] && param['DIV_CODE']!='')	frm.setValue('DIV_CODE',   param['DIV_CODE']);
			if(param['EQU_MACH_CODE'] && param['EQU_MACH_CODE']!='')	frm.setValue('TXT_SEARCH', param['EQU_MACH_CODE']);
			if(param['EQU_MACH_NAME'] && param['EQU_MACH_NAME']!='')	frm.setValue('TXT_SEARCH', param['EQU_MACH_NAME']);
		}
		this._dataLoad();
        
	},
    onSubmitButtonDown : function()	{
        var me = this;
		var selectRecord = me.grid.getSelectedRecord();
	 	var rv ;
		if(selectRecord)	{
		 	rv = {
				status : "OK",
				data:[selectRecord.data]
			};
		}
		me.returnData(rv);
	},
	 onQueryButtonDown : function()	{
	 	this._dataLoad();
	},
	_dataLoad : function() {
		var me = this;
		var param= this.form.getValues();
		console.log( param );
        if(param) {
        	me.isLoading = true;
			this.grid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
        }
	}
});