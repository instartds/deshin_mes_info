<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.PayGradePopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	var payGradeNameList = ${payGradeNameList};
	var fields	= createModelField(payGradeNameList);
	var columns	= createGridColumn(payGradeNameList);


	 Unilite.defineModel('${PKGNAME}.PayGradePopupModel', {
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
	    selModel:'rowmodel',
        items: [  { xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.payGradePopupStore',{
							model: '${PKGNAME}.PayGradePopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.payGradePopup'
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
	        columns:columns,  // 동적 columns
	        
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
		var frm= me.panelSearch.getForm();
		var fieldTxt = frm.findField('TXT_SEARCH');
		me.panelSearch.setValues(param);
		if(param['TYPE'] == 'VALUE') {
        	if(!Ext.isEmpty(param['PAY_GRADE_01'])){
        		fieldTxt.setValue(param['PAY_GRADE_01']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['PAY_GRADE_01'])){
        		fieldTxt.setValue(param['PAY_GRADE_01']);        	
        	}
        	if(!Ext.isEmpty(param['PAY_GRADE_02'])){
        		fieldTxt.setValue(param['PAY_GRADE_02']);
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


// 모델필드 생성
function createModelField(payGradeNameList) {
	var fields = [
		
		{name: 'PAY_GRADE_01'		, text: '급'			, type: 'string'},
		{name: 'PAY_GRADE_02'		, text: '호'			, type: 'string'}
		// 수당명(쿼리읽어서 컬럼 셋팅 WAGES_KIND= 1 인 조건 )
    ];
				
	Ext.each(payGradeNameList, function(item, index) {
		var name = 'STD'+payGradeNameList[index].WAGES_CODE;
		fields.push({name: name, text: payGradeNameList[index].WAGES_NAME, type:'uniPrice' });
	});
	console.log(fields);
	return fields;
}

// 그리드 컬럼 생성
function createGridColumn(payGradeNameList) {
	var columns = [        
    	{dataIndex: 'PAY_GRADE_01'					, width: 60}, 	
    	{dataIndex: 'PAY_GRADE_02'					, width: 60} 	
		// 수당명(쿼리읽어서 컬럼 셋팅)
	];
	// 수당명(쿼리읽어서 컬럼 셋팅)
	Ext.each(payGradeNameList, function(item, index) {
		var dataIndex = 'STD'+payGradeNameList[index].WAGES_CODE;
		columns.push({dataIndex: dataIndex,		width: 100});	
	});
	return columns;
}
