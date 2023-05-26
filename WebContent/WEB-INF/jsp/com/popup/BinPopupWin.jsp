<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 부서팝업
request.setAttribute("PKGNAME","Unilite.app.popup.BinPopup");
%>



	/**
	 *   Model 정의 
	 * @type 
	 */
Unilite.defineModel('${PKGNAME}BinPopupModel', {
    extend: 'Ext.data.Model',
    fields: [ 	{name: 'COMP_CODE'		,text: '<t:message code="system.label.common.companycode" default="법인코드"/>'			,type: 'string'},  	 	
		    	{name: 'DIV_CODE'		,text: '<t:message code="system.label.common.division" default="사업장"/>'			,type: 'string',comboType:'BOR120'},  	 	
		    	{name: 'DOC_GUBUN'		,text: '<t:message code="system.label.common.doctypecode" default="문헌구분코드"/>'		,type: 'string'},  	 	
		    	{name: 'DOC_COL'		,text: '<t:message code="system.label.common.doccol" default="순번값"/>'			,type: 'string'},  	 	
		    	{name: 'BIN_NUM'		,text: '<t:message code="system.label.common.shelfnum" default="진열대번호"/>'			,type: 'string'},  	 	
		    	{name: 'DOC_NAME'		,text: '<t:message code="system.label.common.shelfname" default="진열대명"/>(<t:message code="system.label.common.korean" default="국문"/>)'		,type: 'string'},  	 	
		    	{name: 'DOC_NAME_EN'	,text: '<t:message code="system.label.common.shelfname" default="진열대명"/>(<t:message code="system.label.common.english" default="영문"/>)'		,type: 'string'}
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
	        if(wParam['BINTYPE'] == 'DOC') {
	            t1 = true;
	            t2 = false;
	            
	        } else {
	            t1 = false;
	            t2 = true;
	            
	        }
	    }
/**
 * 검색조건 (Search Panel)
 * @type 
 */

		me.panelSearch =  Unilite.createSearchForm('',{
		    layout : {type : 'table', columns : 2, tableAttrs: {
//		        style: {
//		            width: '100%'
//		        }
		    }},
		    items: [{
				fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				value: UserInfo.divCode,
				allowBlank:false,
				holdable: 'hold'
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.common.classfication" default="구분"/>',
				items: [{
					boxLabel: '<t:message code="system.label.common.stack" default="서가"/>', 
					width: 60, 
					name: 'GUBUN', 
					inputValue: 'DOC', 
					checked: t1
				},{
					boxLabel: '<t:message code="system.label.common.shelf" default="진열대"/>', 
					width :60, 
					name: 'GUBUN', 
					inputValue: 'FAN',
					checked: t2
				}]/*,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('GUBUN').setValue(newValue.GUBUN);
							directMasterStore1.loadStoreRecords();
					}
				}*/
			}, {
		    	fieldLabel: '<t:message code="system.label.common.searchword" default="검색어"/>',
		    	name:'TXT_SEARCH',
                listeners:{
                    specialkey: function(field, e){
                        if (e.getKey() == e.ENTER) {
                           me.onQueryButtonDown();
                        }
                    }
                }
            }]
		});  
		
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		me.masterGrid =  Unilite.createGrid('', {
			store: Unilite.createStoreSimple('${PKGNAME}BinPopupMasterStore',{
							model: '${PKGNAME}BinPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.binPopup'
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
	        	{dataIndex:'COMP_CODE'			, width: 88 ,hidden: true},
	        	{dataIndex:'DIV_CODE'			, width: 88, align:'center'},		
	        	{dataIndex:'DOC_GUBUN'			, width: 88, align:'center',hidden: true},	
	        	{dataIndex:'DOC_COL'			, width: 88, align:'center',hidden: true},	
	        	{dataIndex:'BIN_NUM'			, width: 88, align:'center'},	
	        	{dataIndex:'DOC_NAME'			, width: 179},	
	        	{dataIndex:'DOC_NAME_EN'		, width: 179}	        	
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
		if(param['BIN_NUM'] && param['BIN_NUM']!='')	frm.setValue('TXT_SEARCH', param['BIN_NUM']);
		if(param['DOC_NAME'] && param['DOC_NAME']!='')	frm.setValue('TXT_SEARCH', param['DOC_NAME']);
//		if(param['DEPT_CODE'] && param['DEPT_CODE']!='')	frm.setValue('DEPT_CODE',  param['DEPT_CODE']);
		if(param['DIV_CODE'] && param['DIV_CODE']!='')		frm.setValue('DIV_CODE',   param['DIV_CODE']);
		
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
