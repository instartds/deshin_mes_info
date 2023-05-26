<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 거래처(거래처분류조건포함)
request.setAttribute("PKGNAME","Unilite.app.popup.DivItemGroupPopup");
%>


<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B020" />			//   품목계정 
<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B014"/>				//   조달구분 
<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B013"/>				//   단위 
<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B019"/>				//   국내외 
<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B039"/>				//   출고방법 
<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							//   사업장 
<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B052"/>				//   검색항목 
<t:ExtComboStore useScriptTag="false" items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />//  대분류
<t:ExtComboStore useScriptTag="false" items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />//  중분류
<t:ExtComboStore useScriptTag="false" items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />//  소분류	
<t:ExtComboStore useScriptTag="false" items="${COMBO_WH_LIST}" storeId="whList" />		//  창고


	/**
	 *   Model 정의 
	 * @type 
	 */

Unilite.defineModel('${PKGNAME}.divItemGroupPopupModel', {
    fields: [ 	{name: 'ITEM_CODE'    		,text:'<t:message code="system.label.common.itemcode" default="품목코드"/>'	,type : 'string'} 
				,{name: 'ITEM_NAME'    		,text:'<t:message code="system.label.common.itemname" default="품목명"/>'	,type : 'string'} 
				,{name: 'SPEC'    			,text:'<t:message code="system.label.common.spec" default="규격"/>'	,type : 'string'} 
				,{name: 'SPEC_NUM'    		,text:'<t:message code="system.label.common.spec" default="규격"/>'	,type : 'int'} 
				,{name: 'STOCK_UNIT'    	,text:'<t:message code="system.label.common.inventoryunit" default="재고단위"/>'	,type : 'string'} 
				,{name: 'ORDER_UNIT'    	,text:'<t:message code="system.label.common.purchaseunit" default="구매단위"/>'	,type : 'string'} 
				,{name: 'TRNS_RATE'    		,text:'<t:message code="system.label.common.conversioncoeff" default="변환계수"/>'	,type : 'uniER'} 
				,{name: 'BASIS_P'    		,text:'<t:message code="system.label.common.inventoryprice" default="재고단가"/>'	,type : 'uniUnitPrice'} 
				,{name: 'SALE_BASIS_P'    	,text:'<t:message code="system.label.common.sellingprice" default="판매단가"/>'	,type : 'uniUnitPrice'} 
				//,{name: 'BARCODE'    		,text:'<t:message code="system.label.common.barcode" default="바코드"/>'	,type : 'string'} 
				,{name: 'SAFE_STOCK_Q'    	,text:'<t:message code="system.label.common.safetystockqty" default="안전재고량"/>'	,type : 'uniUnitPrice'} 
				,{name: 'EXPENSE_RATE'    	,text:'<t:message code="system.label.common.importexpenserate" default="수입부대비용율"/>'	,type : 'uniER'} 
				,{name: 'SPEC_NUM'    		,text:'<t:message code="system.label.common.drawingnumber" default="도면번호"/>'	,type : 'int'} 
				,{name: 'WH_CODE'    		,text:'<t:message code="system.label.common.basiswarehouse" default="기준창고"/>'	,type : 'string', store:Ext.data.StoreManager.lookup('whList')} 
				,{name: 'WORK_SHOP_CODE'    ,text:'<t:message code="system.label.common.mainworkcenter" default="주작업장"/>'	,type : 'string'} 
				,{name: 'DIV_CODE'    		,text:'<t:message code="system.label.common.standarddivision" default="기준사업장"/>'	,type : 'string'} 
				,{name: 'OUT_METH'    		,text:'<t:message code="system.label.common.issuemethod" default="출고방법"/>'	,type : 'string',comboType:'AU', comboCode:'B039'} 
				,{name: 'ITEM_MAKER'    	,text:'<t:message code="system.label.common.mfgmaker" default="제조메이커"/>'	,type : 'string'} 
				,{name: 'ITEM_MAKER_PN'    	,text:'<t:message code="system.label.common.makerpartno" default="메이커 PART NO"/>'	,type : 'string'} 
				,{name: 'PURCH_LDTIME'    	,text:'<t:message code="system.label.common.purchaselt" default="구매 L/T"/>'	,type : 'string'} 
				,{name: 'MINI_PURCH_Q'    	,text:'<t:message code="system.label.common.minumunorderqty" default="최소발주량"/>'	,type : 'uniQty'} 
				,{name: 'UNIT_WGT'    		,text:'<t:message code="system.label.common.unitweight" default="단위중량"/>'	,type : 'string'} 
				,{name: 'WGT_UNIT'    		,text:'<t:message code="system.label.common.weightunit" default="중량단위"/>'	,type : 'string'} 
				,{name: 'ITEM_ACCOUNT'    	,text:'<t:message code="system.label.common.itemaccount" default="품목계정"/>'	,type : 'string',comboType:'AU', comboCode:'B020'} 
				,{name: 'DOM_FORIGN'    	,text:'<t:message code="system.label.common.domesticoverseas" default="국내외"/>'	,type : 'string',comboType:'AU', comboCode:'B019'} 
				,{name: 'SUPPLY_TYPE'    	,text:'<t:message code="system.label.common.procurementclassification" default="조달구분"/>'	,type : 'string',comboType:'AU', comboCode:'B014'} 
				,{name: 'HS_NO'    			,text:'<t:message code="system.label.common.hsno" default="HS번호"/>'	,type : 'string'} 
				,{name: 'HS_NAME'    		,text:'<t:message code="system.label.common.hsname" default="HS명"/>'	,type : 'string'} 
				,{name: 'HS_UNIT'    		,text:'<t:message code="system.label.common.hsunit" default="HS단위"/>'	,type : 'string'} 
				,{name: 'STOCK_UNIT'    	,text:'재고단가'	,type : 'string'} 					
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
		    items: [    { fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>' ,   name:'DIV_CODE'  , xtype: 'uniCombobox' , comboType:'BOR120'  }
		    		   ,{ fieldLabel: '<t:message code="system.label.common.repmodel" default="대표모델"/>' ,  name:'ITEM_GROUP' ,colspan:2 }
		               ,{ fieldLabel: '<t:message code="system.label.common.account" default="계정"/>' ,   name:'ITEM_ACCOUNT'  , xtype: 'uniCombobox' , comboType:'AU' ,comboCode:'B020' , value:'01'}				               
		               ,{ fieldLabel: '<t:message code="system.label.common.majorgroup" default="대분류"/>',     name: 'ITEM_LEVEL1' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve1Store') , child: 'ITEM_LEVEL2',colspan:2}
		               ,{ fieldLabel: '<t:message code="system.label.common.procurementclassification" default="조달구분"/>' ,   name:'SUPPLY_TYPE'  , xtype: 'uniCombobox' , comboType:'AU' ,comboCode:'B014' }
		               ,{ fieldLabel: '<t:message code="system.label.common.middlegroup" default="중분류"/>',     name: 'ITEM_LEVEL2' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve2Store') , child: 'ITEM_LEVEL3',colspan:2}
		               ,{ fieldLabel: '<t:message code="system.label.common.searchitem" default="검색항목"/>' ,   name:'FIND_TYPE'  , xtype: 'uniCombobox' , comboType:'AU' ,comboCode:'B052' }				               
		               ,{ fieldLabel: '<t:message code="system.label.common.minorgroup" default="소분류"/>',     name: 'ITEM_LEVEL3' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve3Store') ,colspan:2}
		               ,{ fieldLabel: '<t:message code="system.label.common.searchword" default="검색어"/>',     name: 'TXT_SEARCH'  }
		               ,{ fieldLabel: '<t:message code="system.label.common.itemcode" default="품목코드"/>' ,   name:'ITEM_SEARCH' }
		               ,{ hideLabel: true,
		                    xtype: 'radiogroup', width: 150, id: 'rdoRadio', name: 'RDO_RADIO',
		                     items:[     {inputValue: '1', boxLabel: '코드순', name: 'RDO', checked: t1},
		                                {inputValue: '2', boxLabel: '이름순',  name: 'RDO', checked: t2} ]
		                    ,listeners : {
		                    	change :  function ( radio, newValue, oldValue, eOpts )	{
		                    		var lblSearch = me.panelSearch.getForm().findField('ITEM_SEARCH');                        		
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
			store: Unilite.createStoreSimple('${PKGNAME}.divItemGroupPopupMasterStore',{
							model: '${PKGNAME}.divItemGroupPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.divItemGroupPopup'
					            }
					        }
					}),
			uniOpt:{
				useRowNumberer: false,
				onLoadSelectFirst : false,
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
		           		 { dataIndex: 'ITEM_CODE',  		width: 120} 
						,{ dataIndex: 'ITEM_NAME',  		width: 240} 
						,{ dataIndex: 'SPEC',  				width: 100} 
						,{ dataIndex: 'SPEC_NUM',  			width: 200} 
				  		,{ dataIndex: 'STOCK_UNIT',  		width: 80} 
				  		,{ dataIndex: 'ORDER_UNIT',  		width: 80	,hidden:true} 
				  		,{ dataIndex: 'TRNS_RATE',  		width: 80	,hidden:true} 
				  		,{ dataIndex: 'BASIS_P',  			width: 90	,hidden:true} 
				 		,{ dataIndex: 'SALE_BASIS_P',  		width: 90	,hidden:true} 
				  		,{ dataIndex: 'SAFE_STOCK_Q',  		width: 80	,hidden:true} 
				  		,{ dataIndex: 'EXPENSE_RATE',  		width: 80	,hidden:true} 
				  		,{ dataIndex: 'SPEC_NUM',  			width: 70	,hidden:true} 
				  		,{ dataIndex: 'WH_CODE',  			width: 100	,hidden:true} 
				  		,{ dataIndex: 'WORK_SHOP_CODE',  	width: 100	,hidden:true} 
				  		,{ dataIndex: 'DIV_CODE',  			width: 100	,hidden:true} 
				  		,{ dataIndex: 'OUT_METH',  			width: 100	,hidden:true} 
				  		,{ dataIndex: 'ITEM_MAKER',  		width: 100	,hidden:true} 
				  		,{ dataIndex: 'ITEM_MAKER_PN',  	width: 100	,hidden:true} 
				  		,{ dataIndex: 'PURCH_LDTIME',  		width: 100	,hidden:true} 
				  		,{ dataIndex: 'MINI_PURCH_Q',  		width: 100	,hidden:true} 
				  		,{ dataIndex: 'UNIT_WGT',  			width: 100	,hidden:true} 
				  		,{ dataIndex: 'WGT_UNIT',  			width: 100	,hidden:true} 
				  		,{ dataIndex: 'ITEM_ACCOUNT',  		width: 100	,hidden:true} 
				  		,{ dataIndex: 'DOM_FORIGN',  		width: 100	,hidden:true} 
				  		,{ dataIndex: 'SUPPLY_TYPE',  		width: 100	,hidden:true} 
				  		,{ dataIndex: 'HS_NO',  			width: 100	,hidden:true} 
				  		,{ dataIndex: 'HS_NAME',  			width: 170	,hidden:true} 
				  		,{ dataIndex: 'HS_UNIT',  			width: 100	,hidden:true} 
				  		,{ dataIndex: 'STOCK_UNIT',  		width: 100	,hidden:true} 
								
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

		if(Ext.isDefined(wParam)) {		
			if(wParam['SELMODEL'] == 'MULTI') {
				me.masterGrid.selModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : false });
			}
		}
    },
	fnInitBinding : function(param) {
		var me = this;
		var frm= me.panelSearch.getForm();
		
		var rdo = frm.findField('rdoRadio');
		var fieldTxt = frm.findField('ITEM_SEARCH');
		                      		
                    		
		if( Ext.isDefined(param)) {
			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
				if(param['POPUP_TYPE'] == 'GRID_CODE')	{
					fieldTxt.setValue(param['ITEM_CODE']);
					fieldTxt.setFieldLabel( '품목코드' );
					rdo.setValue('1');
				}else {
					if(param['TYPE'] == 'VALUE') {
						fieldTxt.setValue(param['ITEM_CODE']);
						fieldTxt.setFieldLabel( '품목코드' );
						rdo.setValue('1');
					} else {
						fieldTxt.setValue(param['ITEM_NAME']);
						fieldTxt.setFieldLabel( '품목명' );
						rdo.setValue('2');
					}
				}
			}
			me.panelSearch.setValues(param);
			var sType = param['sType'];
			if(sType == "T")	{
				me.masterGrid.getColumn("HS_NO").show();
				me.masterGrid.getColumn("HS_NAME").show();
				me.masterGrid.getColumn("HS_UNIT").show();
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
        

