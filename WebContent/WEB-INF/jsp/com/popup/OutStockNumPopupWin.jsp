<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 출고요청번호 팝업
request.setAttribute("PKGNAME","Unilite.app.popup.OutStockNum");
%>

/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}OutStockNumPopupModel', {
    fields: [ 	 {name: 'OUTSTOCK_NUM' 		,text:'<t:message code="system.label.common.requestno" default="요청번호"/>' 				,type:'string'	}
    			,{name: 'OUTSTOCK_REQ_DATE' ,text:'<t:message code="system.label.common.requestdate" default="요청일"/>' 				,type:'uniDate'	}
    			,{name: 'REMARK' 							,text:'<t:message code="system.label.common.remarks" default="비고"/>' 					,type:'string'	}
    			,{name: 'PROJECT_NO' 					,text:'<t:message code="system.label.common.projectno" default="프로젝트번호"/>' 				,type:'string'	}
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

	me.panelSearch = Unilite.createSearchForm('',{
	    layout : {type : 'uniTable', columns : 2, tableAttrs: {
	        style: {
	            width: '100%'
	        }
	    }},
	    items: [ { fieldLabel: '<t:message code="system.label.common.companycode" default="법인코드"/>', name: 'COMP_CODE' 		, xtype: 'uniTextfield' , hidden:true}
	    		,{
		        	fieldLabel: '<t:message code="system.label.common.requestdate" default="요청일"/>', 
		            xtype: 'uniDateRangefield',   
		            startFieldName: 'OUTSTOCK_REQ_DATE_FR',
					endFieldName: 'OUTSTOCK_REQ_DATE_TO',
		            width: 315,
		            startDate: UniDate.get('startOfMonth'),
		            endDate: UniDate.get('today'),
		            colspan:2
				},{ fieldLabel: '<t:message code="system.label.common.remarks" default="비고"/>',   	 name: 'REMARK' 			, xtype: 'uniTextfield'}
				 ,{ fieldLabel: '<t:message code="system.label.common.projectno" default="프로젝트번호"/>',     name: 'PROJECT_NO' 		, xtype: 'uniTextfield'}
	             ,{ fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',   	 name: 'DIV_CODE' 		, xtype: 'uniTextfield', hidden: true}
	             ,{ fieldLabel: '<t:message code="system.label.common.workcentercode" default="작업장코드"/>',    name: 'WORK_SHOP_CODE' 	, xtype: 'uniTextfield', hidden: true}               
	               
	        ]
	
	});  

/**
 * Master Grid 정의(Grid Panel)
 * @type 
 */
	 me.masterGrid = Unilite.createGrid('', {
		store: Unilite.createStore('${PKGNAME}.OutStockNumStore',{
						model: '${PKGNAME}OutStockNumPopupModel',
				        autoLoad: false,
				        proxy: {
				            type: 'direct',
				            api: {
				            	read: 'popupService.outStockNum'
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
	           		 { dataIndex: 'OUTSTOCK_NUM' 			,width: 120  }  
					,{ dataIndex: 'OUTSTOCK_REQ_DATE' 		,width: 100 }  
					,{ dataIndex: 'REMARK' 					,width: 140 }  
					,{ dataIndex: 'PROJECT_NO' 				,width: 120  }
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
		var frm= me.panelSearch;
		if(param) {
			frm.setValue('DIV_CODE', param['DIV_CODE']);
			frm.setValue('WORK_SHOP_CODE', param['WORK_SHOP_CODE']);
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

