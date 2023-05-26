<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.AccntsPopupWithAcCode");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	


	 Unilite.defineModel('${PKGNAME}.AccntsPopupModel', {
	    fields:[ {name: 'ACCNT_CODE' 		,text:'<t:message code="system.label.common.accountcode" default="계정코드"/>' 	,type:'string'	}
				,{name: 'ACCNT_CD_NAME' 	,text:'<t:message code="system.label.common.accountitemname" default="계정과목명"/>' 	,type:'string'	}
				,{name: 'ACCNT_NAME' 		,text:'<t:message code="system.label.common.accountitemname2" default="계정세목명"/>' 	,type:'string'	}
				,{name: 'AC_CODE1'    		,text:'<t:message code="system.label.common.manageitemcode" default="관리항목코드"/>1'		,type : 'string'} 
				,{name: 'AC_CODE2'    		,text:'<t:message code="system.label.common.manageitemcode" default="관리항목코드"/>2'		,type : 'string'} 
				,{name: 'AC_CODE3'    		,text:'<t:message code="system.label.common.manageitemcode" default="관리항목코드"/>3'		,type : 'string'} 
				,{name: 'AC_CODE4'    		,text:'<t:message code="system.label.common.manageitemcode" default="관리항목코드"/>4'		,type : 'string'} 
				,{name: 'AC_CODE5'    		,text:'<t:message code="system.label.common.manageitemcode" default="관리항목코드"/>5'		,type : 'string'} 
				,{name: 'AC_CODE6'    		,text:'<t:message code="system.label.common.manageitemcode" default="관리항목코드"/>6'		,type : 'string'}
				
				,{name: 'AC_NAME1'    		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>1'			,type : 'string'} 
				,{name: 'AC_NAME2'    		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>2'			,type : 'string'} 
				,{name: 'AC_NAME3'    		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>3'			,type : 'string'} 
				,{name: 'AC_NAME4'    		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>4'			,type : 'string'} 
				,{name: 'AC_NAME5'    		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>5'			,type : 'string'} 
				,{name: 'AC_NAME6'    		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>6'			,type : 'string'}
				
				,{name: 'AC_DATA1'    		,text:'<t:message code="system.label.common.manageitemdata" default="관리항목데이터"/>1'		,type : 'string'} 
				,{name: 'AC_DATA2'    		,text:'<t:message code="system.label.common.manageitemdata" default="관리항목데이터"/>2'		,type : 'string'} 
				,{name: 'AC_DATA3'    		,text:'<t:message code="system.label.common.manageitemdata" default="관리항목데이터"/>3'		,type : 'string'} 
				,{name: 'AC_DATA4'    		,text:'<t:message code="system.label.common.manageitemdata" default="관리항목데이터"/>4'		,type : 'string'} 
				,{name: 'AC_DATA5'    		,text:'<t:message code="system.label.common.manageitemdata" default="관리항목데이터"/>5'		,type : 'string'} 
				,{name: 'AC_DATA6'    		,text:'<t:message code="system.label.common.manageitemdata" default="관리항목데이터"/>6'		,type : 'string'}
				
				,{name: 'AC_DATA_NAME1'    	,text:'<t:message code="system.label.common.manageitemdataname" default="관리항목데이터명"/>1'	,type : 'string'} 
				,{name: 'AC_DATA_NAME2'    	,text:'<t:message code="system.label.common.manageitemdataname" default="관리항목데이터명"/>2'	,type : 'string'} 
				,{name: 'AC_DATA_NAME3'    	,text:'<t:message code="system.label.common.manageitemdataname" default="관리항목데이터명"/>3'	,type : 'string'} 
				,{name: 'AC_DATA_NAME4'    	,text:'<t:message code="system.label.common.manageitemdataname" default="관리항목데이터명"/>4'	,type : 'string'} 
				,{name: 'AC_DATA_NAME5'    	,text:'<t:message code="system.label.common.manageitemdataname" default="관리항목데이터명"/>5'	,type : 'string'} 
				,{name: 'AC_DATA_NAME6'    	,text:'<t:message code="system.label.common.manageitemdataname" default="관리항목데이터명"/>6'	,type : 'string'}
				
				,{name: 'BOOK_CODE1'    	,text:'<t:message code="system.label.common.accountbalancecode" default="정잔액코드"/>1'		,type : 'string'} 
				,{name: 'BOOK_CODE2'    	,text:'<t:message code="system.label.common.accountbalancecode" default="정잔액코드"/>2'		,type : 'string'} 
				,{name: 'BOOK_DATA1'       	,text:'<t:message code="system.label.common.accountbalancedata" default="계정잔액데이터"/>1'		,type : 'string'} 
				,{name: 'BOOK_DATA2'    	,text:'<t:message code="system.label.common.accountbalancedata" default="계정잔액데이터"/>2'		,type : 'string'} 
				,{name: 'BOOK_DATA_NAME1'	,text:'<t:message code="system.label.common.accountbalancedataname" default="정잔액데이터명"/>1'	,type : 'string'} 
				,{name: 'BOOK_DATA_NAME2'   ,text:'<t:message code="system.label.common.accountbalancedataname" default="정잔액데이터명"/>2'	,type : 'string'} 
				
				,{name: 'ACCNT_SPEC'   		,text:'<t:message code="system.label.common.accountspec" default="계정특성"/>'			,type : 'string'} 
				,{name: 'SPEC_DIVI'    		,text:'<t:message code="system.label.common.assetliabilityspec" default="자산부채특성"/>'		,type : 'string', comboType:'AU', comboCode:'A016'} 
				,{name: 'PROFIT_DIVI'    	,text:'<t:message code="system.label.common.profitspec" default="손익특성"/>'			,type : 'string'} 
				,{name: 'JAN_DIVI'    		,text:'<t:message code="system.label.common.jandivi" default="잔액변"/>(<t:message code="system.label.common.chassis" default="차대"/>)'		,type : 'string'} 
				,{name: 'PEND_YN'    		,text:'<t:message code="system.label.common.pendyn" default="결관리여부"/>'		,type : 'string'} 
				,{name: 'PEND_CODE'    		,text:'<t:message code="system.label.common.pendcode" default="미결항목"/>'			,type : 'string'} 
				,{name: 'PEND_DATA_CODE'  	,text:'<t:message code="system.label.common.penddatacode" default="미결항목데이터코드"/>'	,type : 'string'} 
				,{name: 'BUDG_YN'    		,text:'<t:message code="system.label.common.budgyn" default="예산사용여부"/>'		,type : 'string'} 
				,{name: 'BUDGCTL_YN'    	,text:'<t:message code="system.label.common.budgctlyn" default="예산통제여부"/>'		,type : 'string'} 
				,{name: 'FOR_YN'     		,text:'<t:message code="system.label.common.foreignyn" default="외화구분"/>'			,type : 'string'} 
				
				,{name: 'AC_CTL1'   		,text:'<t:message code="system.label.common.acctl" default="관리항목필수"/>1'		,type : 'string'} 
				,{name: 'AC_CTL2'   		,text:'<t:message code="system.label.common.acctl" default="관리항목필수"/>2'		,type : 'string'} 
				,{name: 'AC_CTL3'   		,text:'<t:message code="system.label.common.acctl" default="관리항목필수"/>3'		,type : 'string'} 
				,{name: 'AC_CTL4'   		,text:'<t:message code="system.label.common.acctl" default="관리항목필수"/>4'		,type : 'string'} 
				,{name: 'AC_CTL5'    		,text:'<t:message code="system.label.common.acctl" default="관리항목필수"/>5'		,type : 'string'} 
				,{name: 'AC_CTL6'    		,text:'<t:message code="system.label.common.acctl" default="관리항목필수"/>6'		,type : 'string'} 
				
				,{name: 'AC_TYPE1'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>1<t:message code="system.label.common.type" default="유형"/>'		,type : 'string'} 
				,{name: 'AC_TYPE2'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>2<t:message code="system.label.common.type" default="유형"/>'		,type : 'string'} 
				,{name: 'AC_TYPE3'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>3<t:message code="system.label.common.type" default="유형"/>'		,type : 'string'} 
				,{name: 'AC_TYPE4'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>4<t:message code="system.label.common.type" default="유형"/>'		,type : 'string'} 
				,{name: 'AC_TYPE5'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>5<t:message code="system.label.common.type" default="유형"/>'		,type : 'string'} 
				,{name: 'AC_TYPE6'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>6<t:message code="system.label.common.type" default="유형"/>'		,type : 'string'} 
				
				,{name: 'AC_LEN1'    		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>1<t:message code="system.label.common.length" default="길이"/>'		,type : 'string'} 
				,{name: 'AC_LEN2'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>2<t:message code="system.label.common.length" default="길이"/>'		,type : 'string'} 
				,{name: 'AC_LEN3'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>3<t:message code="system.label.common.length" default="길이"/>'		,type : 'string'} 
				,{name: 'AC_LEN4'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>4<t:message code="system.label.common.length" default="길이"/>'		,type : 'string'} 
				,{name: 'AC_LEN5'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>5<t:message code="system.label.common.length" default="길이"/>'		,type : 'string'} 
				,{name: 'AC_LEN6'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>6<t:message code="system.label.common.length" default="길이"/>'		,type : 'string'} 
				
				,{name: 'AC_POPUP1' 		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>1<t:message code="system.label.common.popupyn" default="팝업여부"/>'	,type : 'string'} 
				,{name: 'AC_POPUP2'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>2<t:message code="system.label.common.popupyn" default="팝업여부"/>'	,type : 'string'} 
				,{name: 'AC_POPUP3'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>3<t:message code="system.label.common.popupyn" default="팝업여부"/>'	,type : 'string'} 
				,{name: 'AC_POPUP4'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>4<t:message code="system.label.common.popupyn" default="팝업여부"/>'	,type : 'string'} 
				,{name: 'AC_POPUP5'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>5<t:message code="system.label.common.popupyn" default="팝업여부"/>'	,type : 'string'} 
				,{name: 'AC_POPUP6'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>6<t:message code="system.label.common.popupyn" default="팝업여부"/>'	,type : 'string'} 
				
				,{name: 'AC_FORMAT1'  		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>1<t:message code="system.label.common.format" default="포멧"/>'		,type : 'string'} 
				,{name: 'AC_FORMAT2'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>2<t:message code="system.label.common.format" default="포멧"/>'		,type : 'string'} 
				,{name: 'AC_FORMAT3'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>3<t:message code="system.label.common.format" default="포멧"/>'		,type : 'string'} 
				,{name: 'AC_FORMAT4'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>4<t:message code="system.label.common.format" default="포멧"/>'		,type : 'string'} 
				,{name: 'AC_FORMAT5'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>5<t:message code="system.label.common.format" default="포멧"/>'		,type : 'string'} 
				,{name: 'AC_FORMAT6'   		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>6<t:message code="system.label.common.format" default="포멧"/>'		,type : 'string'}
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
//    var wParam = this.param;
//    var t1= false, t2 = false;
//    if( Ext.isDefined(wParam)) {
//        if(wParam['TYPE'] == 'VALUE') {
//            t1 = true;
//            t2 = false;
//            
//        } else {
//            t1 = false;
//            t2 = true;
//            
//        }
//    }
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
        items: [  { fieldLabel: '<t:message code="system.label.common.useflag" default="사용유무"/>',		name:'USE_YN', hidden:true}
                 ,{ xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
//                 ,{ fieldLabel: ' ', 
//                    xtype: 'radiogroup', width: 230,  
//                    items:[ {inputValue: '1', boxLabel:'<t:message code="system.label.common.codeinorder" default="코드순"/>', name: 'RDO', checked: t1},
//                            {inputValue: '2', boxLabel:'<t:message code="system.label.common.nameinorder" default="이름순"/>',  name: 'RDO', checked: t2} ]
//                 }
                 ,{ xtype: 'uniTextfield',      name:'ADD_QUERY', hidden: true}
                 ,{ xtype: 'uniTextfield',      name:'CHARGE_CODE', hidden: true}
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.custPopupStore',{
							model: '${PKGNAME}.AccntsPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.accntPopupWithAcCode'
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
	                     { dataIndex: 'ACCNT_CODE'	 ,  width: 100 }
	                    ,{ dataIndex: 'ACCNT_CD_NAME',  width: 180 }
	                    ,{ dataIndex: 'ACCNT_NAME' ,  minWidth: 200, flex: 1 }	            
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
//        var me = this;		
//        if(param['TYPE'] == 'VALUE') {
//        	if(!Ext.isEmpty(param['ACCNT_CODE'])){
//        		me.panelSearch.setValue('TXT_SEARCH', param['ACCNT_CODE']);        	
//        	}
//        }else{
//        	if(!Ext.isEmpty(param['ACCNT_NAME'])){
//        		me.panelSearch.setValue('TXT_SEARCH', param['ACCNT_NAME']);
//        	}
//        }
		var me = this;		
		var frm= me.panelSearch.getForm();		
		var fieldTxt = frm.findField('TXT_SEARCH');
		var frm= me.panelSearch.getForm();
		var fieldTxt = frm.findField('TXT_SEARCH');
		me.panelSearch.setValues(param);
		if(param['TYPE'] == 'VALUE') {
        	if(!Ext.isEmpty(param['ACCNT_CODE'])){
        		fieldTxt.setValue(param['ACCNT_CODE']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['ACCNT_CODE'])){
        		fieldTxt.setValue(param['ACCNT_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['ACCNT_NAME'])){
        		fieldTxt.setValue(param['ACCNT_NAME']);
        	}
        }       
        
//		var rdo = frm.findField('RDO');
//		if( Ext.isDefined(param)) {
//			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
//				if(param['TYPE'] == 'VALUE') {
//					fieldTxt.setValue(param['ACCNT_CODE']);
//					rdo.setValue({ RDO : '1'});
//				} else {
//					fieldTxt.setValue(param['ACCNT_NAME']);
//					rdo.setValue({ RDO : '2'});
//				}
//			}
//			me.panelSearch.setValues(param);
//		}
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

