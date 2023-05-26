<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.EarnerPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	


	 Unilite.defineModel('${PKGNAME}.EarnerPopupModel', {
	    fields: [
//	    		 {name: 'DED_TYPE' 			,text:'DED_TYPE' 	,type:'string'	},
				 {name: 'EARNER_CODE' 		,text:'<t:message code="system.label.common.personnumb" default="사번"/>' 			,type:'string'	},
				 {name: 'EARNER_NAME' 		,text:'<t:message code="system.label.common.name2" default="성명"/>' 			,type:'string'	},
//				 {name: 'DED_CODE' 			,text:'DED_CODE' 	,type:'string'	},
				 {name: 'DED_NAME' 			,text:'<t:message code="system.label.common.incometype" default="소득구분"/>' 		,type:'string'	},
				 {name: 'DEPT_CODE' 		,text:'<t:message code="system.label.common.departmencode" default="부서코드"/>' 		,type:'string'	},
				 {name: 'DEPT_NAME' 		,text:'<t:message code="system.label.common.departmentname" default="부서명"/>' 		,type:'string'	},
//				 {name: 'DIV_CODE' 			,text:'소속사업장' 		,type:'string'	},
//				 {name: 'SECT_CODE' 		,text:'신고사업장' 		,type:'string'	},
//				 {name: 'BUSINESS_TYPE' 	,text:'법인/개인' 		,type:'string'	},
//				 {name: 'DWELLING_YN' 		,text:'거주구분' 		,type:'string'	},
				 {name: 'REPRE_NUM_MASK'    ,text:'<t:message code="system.label.common.reprenum" default="주민등록번호"/>'  ,type: 'string' , defaultValue:'***************' },
				 {name: 'REPRE_NUM_VAL'     ,text:'<t:message code="system.label.common.reprenum" default="주민등록번호"/>(<t:message code="system.label.common.decodingtype" default="유형별복호화"/>)'  ,type: 'string' },
				 {name: 'REPRE_NUM_EXPOS'	,text:'<t:message code="system.label.common.reprenum" default="주민등록번호"/>(<t:message code="system.label.common.decryption" default="복호화"/>)'	,type: 'string'},
				 {name: 'REPRE_NUM'			,text:'<t:message code="system.label.common.reprenum" default="주민등록번호"/>(DB)'	,type: 'string'},
				 {name: 'EXEDEPT_CODE' 		,text:'<t:message code="system.label.common.exedeptcode" default="비용집행부서코드"/>' 	,type:'string'	},
				 {name: 'EXEDEPT_NAME' 		,text:'<t:message code="system.label.common.exedeptname" default="비용집행부서명"/>' 	,type:'string'	},
				 {name: 'EXPS_PERCENT' 		,text:'<t:message code="system.label.human.expspercent" default="경비세율"/>' 	,type:'string'	},
				 {name: 'REMARK' 			,text:'<t:message code="system.label.common.remarks" default="비고"/>' 			,type:'string'	}
			]
	});

    
var isDecYn = 'N';  //복호화 조회 여부    
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
        items: [  { fieldLabel: '사용유무',		name:'USE_YN', hidden:true}
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
//                    items:[ {inputValue: '1', boxLabel:'코드순', name: 'RDO', checked: t1},
//                            {inputValue: '2', boxLabel:'이름순',  name: 'RDO', checked: t2} ]
//                 }
                 ,{ xtype: 'uniTextfield',      name:'DED_TYPE', hidden: true}
                 ,{ xtype: 'uniTextfield',      name:'BILL_DIV_CODE', hidden: true}
                , {               
                        //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                        name:'DEC_FLAG', 
                        xtype: 'uniTextfield',
                        hidden: true
                    }
        ]
    });    
    me.masterStore =  Unilite.createStoreSimple('${PKGNAME}.custPopupStore',{
            model: '${PKGNAME}.EarnerPopupModel',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                    read: 'popupService.earnerPopup'
                }
            }
    })
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: me.masterStore,
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
//	                     { dataIndex: 'DED_TYPE' 			,width: 100 }
	                     { dataIndex: 'EARNER_CODE' 		,width: 100 }
	                    ,{ dataIndex: 'EARNER_NAME' 		,width: 100 }
//	                    ,{ dataIndex: 'DED_CODE' 			,width: 200 }
	                    ,{ dataIndex: 'DED_NAME' 			,width: 180 }
	                    ,{ dataIndex: 'DEPT_CODE' 			,width: 70 }
	                    ,{ dataIndex: 'DEPT_NAME' 			,width: 100 }
//	                    ,{ dataIndex: 'DIV_CODE' 			,width: 200 }
//	                    ,{ dataIndex: 'SECT_CODE' 			,width: 200 }
//	                    ,{ dataIndex: 'BUSINESS_TYPE' 		,width: 200 }
//	                    ,{ dataIndex: 'DWELLING_YN' 		,width: 200 }
			        	, {dataIndex: 'REPRE_NUM'			,width: 100, hidden: true}
						,{ dataIndex: 'REPRE_NUM_EXPOS'		,width: 100, hidden: true}
						,{ dataIndex: 'REPRE_NUM_MASK'       ,width: 110}
	                    ,{ dataIndex: 'EXEDEPT_CODE' 		,width: 110 }
	                    ,{ dataIndex: 'EXEDEPT_NAME' 		,width: 120 }
	                    ,{ dataIndex: 'EXPS_PERCENT' 		,width: 120 }
	                    ,{ dataIndex: 'REMARK' 				,minWidth: 150, flex: 1 }
	        ],
			listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {
	          		if(colName =="REPRE_NUM_MASK") {
	          			record.set('REPRE_NUM_MASK',record.data['REPRE_NUM_EXPOS']);
//						grid.ownerGrid.openCryptRepreNoPopup(record);
						
	          		} else {
						var rv = {
							status : "OK",
							data:[record.data]
						};
						me.returnData(rv);
	          		}
	          		me.masterStore.commitChanges();
				},
                beforecelldblclick:function  (grid , td , cellIndex , record , tr , rowIndex , e , eOpts ) {                    
                    var records = me.masterGrid.store.data.items;
                    Ext.each(records, function(record,i) {
                        if(isDecYn == 'N'){//일반조회
                            record.set('REPRE_NUM_MASK','***************');
                        }else{//복호화 조회
                            record.set('REPRE_NUM_MASK', record.get('REPRE_NUM_VAL'));//복호화 조회되었던 값으로 세팅
                        }
                    });
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
			}/*,
	    	openCryptRepreNoPopup:function( record )	{
			  	if(record)	{
					var params = {'REPRE_NO': record.get('REPRE_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'N'}
					Unilite.popupCipherComm('grid', record, 'REPRE_NUM_EXPOS', 'REPRE_NUM', params);
				}
			}*/
	    });
	     //복호화 버튼 정의
        me.decrypBtn = Ext.create('Ext.Button',{
            text:'복호화',
            width: 80,
            handler: function() {
        //        var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
        //        if(needSave){
        //           alert(Msg.sMB154); //먼저 저장하십시오.
        //           return false;
        //        }
                me.panelSearch.setValue('DEC_FLAG', 'Y');
                isDecYn = 'Y';
                me._dataLoad();
                me.panelSearch.setValue('DEC_FLAG', '');                
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
        	if(!Ext.isEmpty(param['EARNER_CODE'])){
        		fieldTxt.setValue(param['EARNER_CODE']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['EARNER_CODE'])){
        		fieldTxt.setValue(param['EARNER_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['EARNER_NAME'])){
        		fieldTxt.setValue(param['EARNER_NAME']);
        	}
        }
        var tbar = me.masterGrid._getToolBar();
        if(!Ext.isEmpty(tbar)){
            tbar[0].insert(tbar.length + 1, me.decrypBtn);
        }
//        var me = this;
//		
//		var frm= me.panelSearch.getForm();
//		
//		var rdo = frm.findField('RDO');
//		var fieldTxt = frm.findField('TXT_SEARCH');
//
//		if( Ext.isDefined(param)) {
//			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
//				if(param['TYPE'] == 'VALUE') {
//					fieldTxt.setValue(param['EARNER_CODE']);
//					rdo.setValue({ RDO : '1'});
//				} else {
//					fieldTxt.setValue(param['EARNER_NAME']);
//					rdo.setValue({ RDO : '2'});
//				}
//			}
//			me.panelSearch.setValues(param);
//		}
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
		isDecYn = 'N';
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

