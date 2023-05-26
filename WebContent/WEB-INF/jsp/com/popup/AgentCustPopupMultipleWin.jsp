<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 거래처(거래처분류조건포함)
request.setAttribute("PKGNAME","Unilite.app.popup.AgentCustPopup2");
%>

	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B015"/>				// '거래처구분
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B016"/>				// 사업자구분 
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B055"/>				// 거래처분류 
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B056"/>				// 지역 
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="S010"/>				// 영업담당 
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B010"/>				


	 Unilite.defineModel('${PKGNAME}.AgentPopupModel', {
	    fields: [ 	 {name: 'CUSTOM_CODE' 		,text:'<t:message code="system.label.common.customcode" default="거래처코드"/>' 	,type:'string'	}
					,{name: 'CUSTOM_NAME' 		,text:'<t:message code="system.label.common.customname" default="거래처명"/>' 	,type:'string'	}
					,{name: 'COMPANY_NUM' 		,text:'<t:message code="system.label.common.businessnumber" default="사업자번호"/>' 	,type:'string'	}
					,{name: 'TOP_NAME' 			,text:'<t:message code="system.label.common.representativename" default="대표자명"/>' 		,type:'string'	 }
					,{name: 'BUSINESS_TYPE' 	,text:'<t:message code="system.label.common.businessdivisiontype" default="사업자구분"/>' 	,type:'string'	, comboType:'AU',comboCode:'B016'}
					,{name: 'COMP_CLASS' 		,text:'<t:message code="system.label.common.businesstype" default="업종"/>' 		,type:'string'	}
					,{name: 'COMP_TYPE' 		,text:'<t:message code="system.label.common.businessconditions" default="업태"/>' 		,type:'string'	}
					,{name: 'ADDR1' 			,text:'<t:message code="system.label.common.address1" default="주소1"/>' 		,type:'string'	}
					,{name: 'ADDR2' 			,text:'<t:message code="system.label.common.address2" default="주소2"/>' 		,type:'string'	}
					,{name: 'TELEPHON' 			,text:'<t:message code="system.label.common.telephone" default="전화번호"/>' 	,type:'string'	}
					,{name: 'FAX_NUM' 			,text:'<t:message code="system.label.common.faxno" default="팩스번호"/>' 	,type:'string'	}
					,{name: 'MAIL_ID' 			,text:'<t:message code="system.label.common.emailaddr" default="이메일주소"/>' 		,type:'string'	}
					,{name: 'WON_CALC_BAS' 		,text:'<t:message code="system.label.common.decimalcalculation" default="원미만계산"/>' 	,type:'string'	}
					,{name: 'TO_ADDRESS' 		,text:'<t:message code="system.label.common.sendaddress" default="송신주소"/>' 	,type:'string'	}
					,{name: 'TAX_CALC_TYPE' 	,text:'<t:message code="system.label.common.taxcalculationmethod" default="세액계산법"/>' 	,type:'string'	}
					,{name: 'TRANS_CLOSE_DAY'	,text:'<t:message code="system.label.common.customclosingdate" default="거래처마감일"/>',type:'string'	}
					,{name: 'RECEIPT_DAY' 		,text:'<t:message code="system.label.common.apprperiod" default="결재기간"/>' 	,type:'string'	}
					,{name: 'TAX_TYPE' 			,text:'<t:message code="system.label.common.taxincludedflag" default="세액포함여부"/>',type:'string'	}
					,{name: 'VAT_RATE' 			,text:'<t:message code="system.label.common.taxrate" default="세율"/>' 		,type:'string'	}
					,{name: 'MONEY_UNIT' 		,text:'<t:message code="system.label.common.currency" default="화폐 "/>' 		,type:'string'	}
					,{name: 'BILL_TYPE' 		,text:'<t:message code="system.label.common.billtype" default="계산서유형"/>' 	,type:'string'	}
					,{name: 'SET_METH' 			,text:'<t:message code="system.label.common.payingterm" default="결제방법"/>' 	,type:'string'	}
					
					,{name: 'AGENT_TYPE' 		,text:'<t:message code="system.label.common.customclass" default="거래처분류"/>' 	,type:'string'	, comboType:'AU',comboCode:'B055'}
					,{name: 'AREA_TYPE' 		,text:'<t:message code="system.label.common.areatype" default="지역분류"/>',type:'string'	, comboType:'AU',comboCode:'B056'}
					,{name: 'CREDIT_YN' 		,text:'<t:message code="system.label.common.creditmanageyn" default="여신관리여부"/>' 	,type:'string'	}
					,{name: 'TOT_CREDIT_AMT' 	,text:'<t:message code="system.label.common.creditamount2" default="여신액"/>' 	,type:'string'	}
					,{name: 'CREDIT_AMT' 		,text:'<t:message code="system.label.common.additionalcreditamount" default="추가여신액"/>' 		,type:'string'	}
					,{name: 'CREDIT_YMD' 		,text:'<t:message code="system.label.common.additionalcreditduedate" default="추가여신만기일"/>' 	,type:'uniDate'}
					,{name: 'BUSI_PRSN' 		,text:'<t:message code="system.label.common.mainsalescharger" default="주영업담당자"/>' 	,type:'string', comboType:'AU',comboCode:'S010'}
					,{name: 'COLLECTOR_CP' 		,text:'<t:message code="system.label.common.collectioncustomer" default="수금거래처"/>' 	,type:'string'	}
					,{name: 'COLLECTOR_NM' 		,text:'<t:message code="system.label.common.collectioncustomername" default="수금거래처명"/>' 		,type:'string'	}
					,{name: 'COLLECT_DAY' 		,text:'<t:message code="system.label.common.collectionschdate" default="수금예정일"/>' 	,type:'string'}
					,{name: 'COLLECT_CARE' 		,text:'<t:message code="system.label.common.armanagemethod" default="미수관리방법"/>' 	,type:'string'}
					,{name: 'REMARK' 			,text:'<t:message code="system.label.common.remarks" default="비고"/>' 	,type:'string'	}
					,{name: 'TOP_NUM' 			,text:'<t:message code="system.label.common.representativenumber" default="대표자주민번호"/>',type:'string'	}
					,{name: 'CREDIT_OVER_YN' 	,text:'<t:message code="system.label.common.creditoverdeliveryyn" default="여신초과여부"/>' 	,type:'string'	}
					,{name: 'BILL_DIV_CODE' 	,text:'<t:message code="system.label.common.declaredivisioncode" default="신고사업장"/>' 	,type:'string'	}
					,{name: 'SERVANT_COMPANY_NUM' 	,text:'<t:message code="system.label.common.bureaubusinessnumber" default="종사업장번호"/>' 		,type:'string'	}

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
    var t1= true, t2 = false;
    if( Ext.isDefined(wParam)) {
    	if(wParam['POPUP_TYPE'] == 'GRID_CODE') {
	            t1 = true;
	            t2 = false;
        }else{ 
//        if(wParam['TYPE'] == 'VALUE') {
//            t1 = true;
//            t2 = false;
//            
//        } else {
//            t1 = false;
//            t2 = true;
//        }
        }
    }
    me.panelSearch = Unilite.createSearchForm('',{
        layout: {
        	type: 'uniTable', 
        	columns: 3, 
        	tableAttrs: {
	            style: {
	                width: '100%'
	            }
	        }
	    },
        items: [ { fieldLabel: '<t:message code="system.label.common.classfication" default="구분"/>',    name:'CUSTOM_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B015' }
                 ,{ fieldLabel: '<t:message code="system.label.common.businessnumber" default="사업자번호"/>',    name:'COMPANY_NUM', /*id:'COMPANY_NUM',*/ xtype: 'uniTextfield' ,colspan:2}//ID 중복시 오류, itemId로 사용
                 ,{ fieldLabel: '<t:message code="system.label.common.customclass" default="거래처분류"/>',    name:'AGENT_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B055' }
                 ,{ fieldLabel: '<t:message code="system.label.common.areatype" default="지역분류"/>',     name:'AREA_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B056' }
                 ,{  fieldLabel: '<t:message code="system.label.common.useflag" default="사용유무"/>',    name:'USE_YN',  xtype: 'uniRadiogroup', comboType:'AU',comboCode:'B010' , allowBlank:false, value:'Y', width:230}
                 ,{ fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH', colspan:2, width:518,
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
                 ,{ fieldLabel: '<t:message code="system.label.common.businessdivisiontype" default="사업자구분"/>', 
                    xtype: 'radiogroup', width: 230, id:'rdoRadio', 
                    items:[ {inputValue: '1', boxLabel:'<t:message code="system.label.common.codeinorder" default="코드순"/>', name: 'RDO', checked: t1},
                            {inputValue: '2', boxLabel:'<t:message code="system.label.common.nameinorder" default="이름순"/>',  name: 'RDO', checked: t2} ]
                 }             
                
        ]
    });                
    var masterGridConfig = {
            store: Unilite.createStoreSimple('${PKGNAME}.custPopupStore',{
							model: '${PKGNAME}.AgentPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.agentCustPopup'
					            }
					        }
					}),
			selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 

	        uniOpt:{
	        		onLoadSelectFirst : false
	        		,expandLastColumn: false
	               ,useRowNumberer: false,
	                state: {
						useState: false,
						useStateList: false	
					},
					pivot : {
						use : false
					}
	        },
	        columns:  [        
	                     { dataIndex: 'CUSTOM_CODE',  width: 100 }
	                    ,{ dataIndex: 'CUSTOM_NAME',  width: 100 }
	                    ,{ dataIndex: 'COMPANY_NUM',  width: 100 }
	                    ,{ dataIndex: 'TOP_NAME',  width: 80 } 
	                    ,{ dataIndex: 'BUSINESS_TYPE',  width: 100 } 
	                    ,{ dataIndex: 'COMP_CLASS',  width: 100 } 
	                    ,{ dataIndex: 'COMP_TYPE',  width: 100 } 
	                    ,{ dataIndex: 'ADDR1',  width: 100 } 
	                    ,{ dataIndex: 'ADDR2',  width: 100 } 
	                    ,{ dataIndex: 'TELEPHON',  width: 100 } 
	                    ,{ dataIndex: 'FAX_NUM',  width: 100 } 
	                    ,{ dataIndex: 'MAIL_ID',  width: 100 } 
	                    ,{ dataIndex: 'WON_CALC_BAS',  width: 100   } 
	                    ,{ dataIndex: 'TO_ADDRESS',  width: 100 } 
	                    ,{ dataIndex: 'TAX_CALC_TYPE',  width: 100 } 
	                    ,{ dataIndex: 'TRANS_CLOSE_DAY',  width: 100    } 
	                    ,{ dataIndex: 'RECEIPT_DAY',  width: 100    } 
	                    ,{ dataIndex: 'TAX_TYPE',  width: 100   } 
	                    ,{ dataIndex: 'VAT_RATE',  width: 100 } 
	                    ,{ dataIndex: 'MONEY_UNIT',  width: 100 } 
	                    ,{ dataIndex: 'BILL_TYPE',  width: 100  } 
	                    ,{ dataIndex: 'SET_METH',  width: 100   } 
	                    ,{ dataIndex: 'AGENT_TYPE',  width: 100 } 
	                    ,{ dataIndex: 'AREA_TYPE',  width: 100  } 
	                    ,{ dataIndex: 'CREDIT_YN',  width: 100  } 
	                    ,{ dataIndex: 'TOT_CREDIT_AMT',  width: 100 } 
	                    ,{ dataIndex: 'CREDIT_AMT',  width: 100 } 
	                    ,{ dataIndex: 'CREDIT_YMD',  width: 100 } 
	                    ,{ dataIndex: 'BUSI_PRSN',  width: 100  } 
	                    ,{ dataIndex: 'COLLECTOR_CP',  width: 100   } 
	                    ,{ dataIndex: 'COLLECTOR_NM',  width: 100   } 
	                    ,{ dataIndex: 'COLLECT_DAY',  width: 100    } 
	                    ,{ dataIndex: 'COLLECT_CARE',  width: 100   } 
	                    ,{ dataIndex: 'REMARK',  width: 100 } 
	                    ,{ dataIndex: 'TOP_NUM',  width: 100    } 
	                    ,{ dataIndex: 'CREDIT_OVER_YN',  width: 100  } 
	                    ,{ dataIndex: 'BILL_DIV_CODE',  width: 100  } 
	                    ,{ dataIndex: 'SERVANT_COMPANY_NUM',  width: 100  } 
	            
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
	    };
	    if(Ext.isDefined(wParam)) {     
	        if(wParam['SELMODEL'] == 'MULTI') {
	            masterGridConfig.selModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : false });
	        }
	    }
	    
	    me.masterGrid = Unilite.createGrid('', masterGridConfig);
	    
	    
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
		
		var rdo = frm.findField('rdoRadio');
		var fieldTxt = frm.findField('TXT_SEARCH');
		me.panelSearch.setValues(param);

		if( Ext.isDefined(param)) {
			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
				if(!Ext.isEmpty(param['CUSTOM_CODE'])) {
					fieldTxt.setValue(param['CUSTOM_CODE']);
					rdo.setValue('1');
					
				} else if(!Ext.isEmpty(param['CUSTOM_NAME'])){
					fieldTxt.setValue(param['CUSTOM_NAME']);
					rdo.setValue('2');
				}
			}
		}
		//조회 조건이 있을 때만 팝업 열리면서 조회 되도록 
		if (!Ext.isEmpty(me.panelSearch.getValue('TXT_SEARCH'))) {
			this._dataLoad();
		}
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

