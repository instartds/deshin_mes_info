<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.BudgPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	var budgNameList = ${budgNameList};
	var fields	= createModelField(budgNameList);
	var columns	= createGridColumn(budgNameList);


	 Unilite.defineModel('${PKGNAME}.BudgPopupModel', {
	    fields:fields
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
        items: [  { xtype: 'uniTextfield', 		fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
                 ,{ xtype: 'uniTextfield',      name:'ADD_QUERY', hidden: true}
                 ,{ xtype: 'uniTextfield',      name:'AC_YYYY', hidden: true}
                 ,{ xtype: 'uniTextfield',      name:'DEPT_CODE', hidden: true}
                 ,{ xtype: 'uniTextfield',      name:'ACCNT', hidden: true}
                 ,{ xtype: 'uniTextfield',      name:'BUDG_TYPE', hidden:true}
                 ,{ xtype: 'uniTextfield',      name:'DIV_CODE', hidden:true}
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.budgPopupStore',{
							model: '${PKGNAME}.BudgPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.budgPopup'
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
	        columns:columns,
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
//		param.budgNameInfoList = budgNameList;	//예산목록	
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

// 모델필드 생성
function createModelField(budgNameList) {
	var fields = [
		{name: 'BUDG_CODE'			, text: '<t:message code="system.label.common.budgcode" default="예산코드"/>'			, type: 'string'},
		// 예산명(쿼리읽어서 컬럼 셋팅)
		{name: 'BUDG_NAME'			, text: '<t:message code="system.label.common.budgname" default="예산명"/>'			, type: 'string'},
		{name: 'ACCNT'						, text: '<t:message code="system.label.common.accountcode" default="계정코드"/>'			, type: 'string'},
		{name: 'ACCNT_NAME'			, text: '<t:message code="system.label.common.accountname" default="계정명"/>'			, type: 'string'},
		{name: 'DEPT_CODE'				, text: '<t:message code="system.label.common.departmencode" default="부서코드"/>'			, type: 'string'},
		{name: 'DEPT_NAME'			, text: '<t:message code="system.label.common.departmentname" default="부서명"/>'			, type: 'string'},
		{name: 'USE_YN'					, text: '<t:message code="system.label.common.useyn" default="사용여부"/>'			, type: 'string'},
		{name: 'GROUP_YN'				, text: '<t:message code="system.label.common.groupyn" default="그룹여부"/>'			, type: 'string'},
		{name: 'CODE_LEVEL'			, text: '<t:message code="system.label.common.budgcodelevel" default="예산코드레벨"/>'		, type: 'string'},
		{name: 'PJT_CODE'				, text: '<t:message code="system.label.common.projectcode" default="프로젝트코드"/>'		, type: 'string'},
		{name: 'PJT_NAME'				, text: '<t:message code="system.label.common.projectname" default="프로젝트명"/>'		, type: 'string'},
		{name: 'SAVE_CODE'				, text: '<t:message code="system.label.common.bankbookcode" default="통장코드"/>'			, type: 'string'},
		{name: 'SAVE_NAME'			, text: '<t:message code="system.label.common.bankbook" default="통장명"/>'			, type: 'string'},
		{name: 'BANK_ACCOUNT'	, text: '<t:message code="system.label.common.bankaccount" default="계좌번호"/>'			, type: 'string'},
		{name: 'BANK_CODE'			, text: '<t:message code="system.label.common.bankcode" default="은행코드"/>'			, type: 'string'},
		{name: 'BANK_NAME'			, text: '<t:message code="system.label.common.bankname" default="은행명"/>'			, type: 'string'},
		{name: 'BUDG_TYPE'				, text: '<t:message code="system.label.common.budgtype" default="수지구분"/>'			, type: 'string'}
    ];
				
	Ext.each(budgNameList, function(item, index) {
		var name = 'BUDG_NAME_L'+(index + 1);
		fields.push({name: name, text: item.CODE_NAME, type:'string' });
	});
	console.log(fields);
	return fields;
}

// 그리드 컬럼 생성
function createGridColumn(budgNameList) {
	var columns = [        
    	{dataIndex: 'BUDG_CODE'					, width: 133},
    	{dataIndex: 'BUDG_NAME'					, width: 133} 	 	
		// 예산명(쿼리읽어서 컬럼 셋팅)
	];
	// 예산명(쿼리읽어서 컬럼 셋팅)
	Ext.each(budgNameList, function(item, index) {
		var dataIndex = 'BUDG_NAME_L'+(index + 1);
		columns.push({dataIndex: dataIndex,		width: 110});	
	});
	columns.push({dataIndex: 'ACCNT'				, width: 85, hidden: true}); 	
	columns.push({dataIndex: 'ACCNT_NAME'			, width: 133, hidden: true}); 	
	columns.push({dataIndex: 'DEPT_CODE'			, width: 66, hidden: true}); 	
	columns.push({dataIndex: 'DEPT_NAME'			, width: 100, hidden: true}); 	
	columns.push({dataIndex: 'USE_YN'				, width: 100, hidden: true}); 	
	columns.push({dataIndex: 'GROUP_YN'				, width: 100, hidden: true});	
	columns.push({dataIndex: 'CODE_LEVEL'			, width: 100, hidden: true}); 	
	columns.push({dataIndex: 'PJT_CODE'				, width: 200, hidden: true}); 	
	columns.push({dataIndex: 'PJT_NAME'				, width: 66, hidden: true}); 	
	columns.push({dataIndex: 'SAVE_CODE'			, width: 66, hidden: true}); 	
	columns.push({dataIndex: 'SAVE_NAME'			, width: 66, hidden: true}); 	
	columns.push({dataIndex: 'BANK_ACCOUNT'			, width: 66, hidden: true}); 	
	columns.push({dataIndex: 'BANK_CODE'			, width: 80, hidden: true}); 	
	columns.push({dataIndex: 'BANK_NAME'			, width: 80, hidden: true}); 	
	columns.push({dataIndex: 'BUDG_TYPE'			, width: 80, hidden: true}); 
	return columns;
}

