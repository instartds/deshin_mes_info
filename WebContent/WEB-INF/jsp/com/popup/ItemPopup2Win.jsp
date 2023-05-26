<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 품목코드 팜업(사용자)
request.setAttribute("PKGNAME","Unilite.app.popup.ItemPopup2");
%>

<t:ExtComboStore  useScriptTag="false"  comboType="AU" comboCode="B014" />	<!--조달구분-->
<t:ExtComboStore  useScriptTag="false"  comboType="AU" comboCode="B020" />	<!--계정(품목계정)-->	
<t:ExtComboStore  useScriptTag="false"  comboType="BOR120"  /> <!-- 사업장 -->
<t:ExtComboStore  useScriptTag="false"  items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
<t:ExtComboStore  useScriptTag="false"  items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
<t:ExtComboStore  useScriptTag="false"  items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
              
/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.ItemPopup2Model', {
    fields: [ 	 {name: 'ITEM_CODE' 	,text:'<t:message code="system.label.common.itemcode" default="품목코드"/>' 		,type:'string'	}
				,{name: 'ITEM_NAME' 	,text:'<t:message code="system.label.common.itemname" default="품목명"/>' 			,type:'string'  }
				,{name: 'SPEC' 			,text:'<t:message code="system.label.common.spec" default="규격"/>' 			,type:'string'	}
				,{name: 'STOCK_UNIT' 	,text:'<t:message code="system.label.common.inventoryunit" default="재고단위"/>' 		,type:'string'	}
				,{name: 'SALE_UNIT' 	,text:'<t:message code="system.label.common.salesunit" default="판매단위"/>' 		,type:'string'	}
				,{name: 'TRNS_RATE' 	,text:'<t:message code="system.label.common.conversioncoeff" default="변환계수"/>' 		,type:'string'	}
				,{name: 'SALE_BASIS_P' 	,text:'<t:message code="system.label.common.sellingprice" default="판매단가"/>' 	,	 type:'uniUnitPrice'	}
				,{name: 'SPEC_NUM' 		,text:'<t:message code="system.label.common.drawingnumber" default="도면번호"/>' 		,type:'string'  }
				,{name: 'ITEM_MAKER' 	,text:'<t:message code="system.label.common.mfgmaker" default="제조메이커"/>' 		,type:'string'	}
				,{name: 'ITEM_MAKER_PN' ,text:'<t:message code="system.label.common.makerpartno" default="메이커 PART NO"/>' 	,type:'string'	}
				,{name: 'UNIT_WGT' 		,text:'<t:message code="system.label.common.unitweight" default="단위중량"/>' 		,type:'string'	}
				,{name: 'WGT_UNIT'		,text:'<t:message code="system.label.common.weightunit" default="중량단위"/>'		,type:'string'	}
				,{name: 'DOM_FORIGN' 	,text:'<t:message code="system.label.common.domesticoverseas" default="국내외"/>' 			,type:'string', comboType:'AU',comboCode:'B019'	}
				,{name: 'SUPPLY_TYPE' 	,text:'<t:message code="system.label.common.procurementclassification" default="조달구분"/>'		,type:'string', comboType:'AU',comboCode:'B014' }
				,{name: 'HS_NO' 		,text:'<t:message code="system.label.common.hsno" default="HS번호"/>' 			,type:'string'	}
				,{name: 'HS_NAME' 		,text:'<t:message code="system.label.common.hsname" default="HS명"/>' 			,type:'string'	}
				,{name: 'HS_UNIT' 		,text:'<t:message code="system.label.common.hsunit" default="HS단위"/>' 			,type:'string'	}
				,{name: 'STOCK_UNIT2' 	,text:'<t:message code="system.label.common.inventoryunit" default="재고단위"/>' 		,type:'string'	}					
				,{name: 'TAX_TYPE' 		,text:'<t:message code="system.label.common.taxabledivision" default="과세구분"/>' 		,type:'string'	}
				,{name: 'STOCK_CARE_YN' ,text:'<t:message code="system.label.common.inventorymanagementyn" default="재고관리여부"/>'	,type:'string'	}	
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
	        if(wParam['TYPE'] == 'VALUE') {
	            t1 = true;
	            t2 = false;			            
	        } else {
	            t1 = false;
	            t2 = true;			            
	        }
	    }
		me.panelSearch = Unilite.createSearchForm('',{
		    layout : {type : 'uniTable', columns : 3, tableAttrs: {
		        style: {
		            width: '100%'
		        }
		    }},
		    items: [   {fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>', name:'DIV_CODE', xtype: 'uniCombobox', comboType:'BOR120', allowBlank:false, readOnly: true }
		    		   ,{ fieldLabel: '<t:message code="system.label.common.repmodel" default="대표모델"/>' ,  name:'TXTITEM_GROUP'  , xtype: 'uniTextfield', colspan: 2 }
		    		   ,{fieldLabel: '<t:message code="system.label.common.account" default="계정"/>', name:'TXT_ACCNT', xtype: 'uniCombobox', comboType:'B020'}
		               ,{ fieldLabel: '<t:message code="system.label.common.majorgroup" default="대분류"/>',     name: 'TXTLV_L1' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve1Store') , child: 'TXTLV_L2', colspan: 2}
		               ,{fieldLabel: '<t:message code="system.label.common.procurementclassification" default="조달구분"/>', name:'TXT_SUPPLY_TYPE', xtype: 'uniCombobox', comboType:'B014'}
		               ,{ fieldLabel: '<t:message code="system.label.common.middlegroup" default="중분류"/>',     name: 'TXTLV_L2' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve2Store') , child: 'TXTLV_L3', colspan: 2}
		               ,{ fieldLabel: '<t:message code="system.label.common.searchitem" default="검색항목"/>' ,   name:'TXTFIND_TYPE'  , xtype: 'uniCombobox' , comboType:'AU' ,comboCode:'B052' , value:'01', allowBlank:false}                   
		               ,{ fieldLabel: '<t:message code="system.label.common.minorgroup" default="소분류"/>',     name: 'TXTLV_L3' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve3Store') , colspan: 2}
		               ,{ fieldLabel: '<t:message code="system.label.common.searchword" default="검색어"/>',     name: 'TXT_SEARCH' , xtype: 'uniTextfield' }                   
		               ,{ fieldLabel: '<t:message code="system.label.common.itemcode" default="품목코드"/>' ,   name:'LBL_SEARCH' ,  xtype: 'uniTextfield' }
		               ,{ fieldLabel: '<t:message code="system.label.common.useyn" default="사용여부"/>' ,   name:'USE_YN' ,  xtype: 'uniTextfield', hidden: true }
		               ,{ fieldLabel: ' ',
		                    xtype: 'radiogroup', width: 230, name: 'rdoRadio',
		                     items:[     {inputValue: '1', boxLabel: '<t:message code="system.label.common.codeinorder" default="코드순"/>', name: 'RDO', checked: t1},
		                                {inputValue: '2', boxLabel: '<t:message code="system.label.common.nameinorder" default="이름순"/>',  name: 'RDO', checked: t2} ]
		                    ,listeners : {
		                    	change :  function ( radio, newValue, oldValue, eOpts )	{
		                    		var lblSearch = panelSearch.getForm().findField('LBL_SEARCH');                        		
		                    		if(newValue.RDO=='2')	{
		                    			lblSearch.setFieldLabel( '품목명' );
		                    		} else if(newValue.RDO=='1'){
		                    			lblSearch.setFieldLabel( '품목코드' );
		                    		}
		                    	}
		                    }
		               }                  
		               
		        ]
		
		});  
		
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		 me.masterGrid = Unilite.createGrid('', {
			store: Unilite.createStoreSimple('${PKGNAME}.itemPopup2MasterStore',{
							model: '${PKGNAME}.ItemPopup2Model',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.itemPopup2'
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
		           		 { dataIndex: 'ITEM_CODE' 		,width: 1700/15 }  
						,{ dataIndex: 'ITEM_NAME' 		,width: 1700/15 } 
						,{ dataIndex: 'SPEC' 			,width: 1500/15 } 
						,{ dataIndex: 'STOCK_UNIT' 		,width: 1500/15}
						,{ dataIndex: 'SALE_UNIT' 		,width: 1500/15 } 
						,{ dataIndex: 'TRNS_RATE' 		,width: 1500/15 } 
						,{ dataIndex: 'SALE_BASIS_P' 	,width: 100 , hidden: true} 
						,{ dataIndex: 'SPEC_NUM' 		,width: 1500/15 } 
						,{ dataIndex: 'ITEM_MAKER' 		,width: 100 , hidden: true} 
						,{ dataIndex: 'ITEM_MAKER_PN'	,width: 100 , hidden: true} 
						,{ dataIndex: 'UNIT_WGT' 		,width: 100 , hidden: true} 
						,{ dataIndex: 'WGT_UNIT'		,width: 100 , hidden: true} 
						,{ dataIndex: 'DOM_FORIGN' 		,width: 100 , hidden: true} 
						,{ dataIndex: 'SUPPLY_TYPE' 	,width: 100 , hidden: true} 
						,{ dataIndex: 'HS_NO' 			,width: 100 , hidden: true} 
						,{ dataIndex: 'HS_NAME' 		,width: 100 , hidden: true} 
						,{ dataIndex: 'HS_UNIT' 		,width: 100 , hidden: true} 
						,{ dataIndex: 'STOCK_UNIT2' 	,width: 1500/15 , hidden: true} 
						,{ dataIndex: 'TAX_TYPE' 		,width: 100 , hidden: true} 
						,{ dataIndex: 'STOCK_CARE_YN'	,width: 100 , hidden: true} 					
				
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
		var frm= me.panelSearch.getForm();
		me.panelSearch.setValue('DIV_CODE',UserInfo.divCode);
		var fieldTxt = frm.findField('LBL_SEARCH')
		var rdo = frm.findField('rdoRadio');
		if( Ext.isDefined(param)) {
			frm.setValues(param);
			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
				if(param['TYPE'] == 'VALUE') {
					fieldTxt.setValue(param['ITEM_CODE']);						
					rdo.setValue('1');
				} else {
					fieldTxt.setValue(param['ITEM_NAME']);
					rdo.setValue('2');
					fieldTxt.setFieldLabel('품목명');
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
		var selectRecord = me.masterGrid.getSelectedRecord();
	 	var rv ;
		if(selectRecord)	{
		 	rv = {
				status : "OK",
				data:[selectRecord.data]
			};
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

