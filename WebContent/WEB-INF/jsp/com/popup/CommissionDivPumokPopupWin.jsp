<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<% 
	request.setAttribute("PKGNAME","Unilite.app.popup.CommissionDivPumokPopup");
%>
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B020" />	// '품목계정
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B014"/>	// 조달구분
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B013"/>	// 단위
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B019"/>	// 국내외
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B039"/>	// 출고방법
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />				// 사업장 
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B052"/>				// 검색항목 -->
	<t:ExtComboStore useScriptTag="false" items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />//대분류
	<t:ExtComboStore useScriptTag="false" items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />//중분류
	<t:ExtComboStore useScriptTag="false" items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />//소분류	
	<t:ExtComboStore useScriptTag="false" items="${COMBO_WH_LIST}" storeId="whList" />		// 창고


	/**
	 *   Model 정의 
	 */
	Unilite.defineModel('${PKGNAME}.commissiondivPumokPopupModel', {
	    fields: [ 	{name: 'ITEM_CODE'    		,text:'<t:message code="system.label.common.itemcode" default="품목코드"/>'	,type : 'string'} 
					,{name: 'ITEM_NAME'    		,text:'<t:message code="system.label.common.itemname" default="품목명"/>'	,type : 'string'} 
					,{name: 'SPEC'    					,text:'<t:message code="system.label.common.spec" default="규격"/>'	,type : 'string'} 
					,{name: 'SPEC_NUM'    			,text:'<t:message code="system.label.common.spec" default="규격"/>'	,type : 'int'} 
					,{name: 'STOCK_UNIT'    		,text:'<t:message code="system.label.common.inventoryunit" default="재고단위"/>'	,type : 'string'} 
					,{name: 'ORDER_UNIT'    		,text:'<t:message code="system.label.common.purchaseunit" default="구매단위"/>'	,type : 'string'} 
					,{name: 'TRNS_RATE'    			,text:'<t:message code="system.label.common.conversioncoeff" default="변환계수"/>'	,type : 'uniER'} 
					,{name: 'BASIS_P'    				,text:'<t:message code="system.label.common.inventoryprice" default="재고단가"/>'	,type : 'uniUnitPrice'} 
					,{name: 'SALE_BASIS_P'    		,text:'<t:message code="system.label.common.sellingprice" default="판매단가"/>'	,type : 'uniUnitPrice'} 
					,{name: 'BARCODE'    			,text:'<t:message code="system.label.common.barcode" default="바코드"/>'	,type : 'string'} 
					,{name: 'SAFE_STOCK_Q'    	,text:'<t:message code="system.label.common.safetystockqty" default="안전재고량"/>'	,type : 'uniUnitPrice'} 
					,{name: 'EXPENSE_RATE'    	,text:'<t:message code="system.label.common.importexpenserate" default="수입부대비용율"/>'	,type : 'uniER'} 
					,{name: 'SPEC_NUM'    			,text:'<t:message code="system.label.common.drawingnumber" default="도면번호"/>'	,type : 'string'} 
					,{name: 'WH_CODE'    			,text:'<t:message code="system.label.common.basiswarehouse" default="기준창고"/>'	,type : 'string', store:Ext.data.StoreManager.lookup('whList')} 
					,{name: 'WORK_SHOP_CODE'    ,text:'<t:message code="system.label.common.mainworkcenter" default="주작업장"/>'	,type : 'string'} 
					,{name: 'DIV_CODE'    			,text:'<t:message code="system.label.common.standarddivision" default="기준사업장"/>'	,type : 'string'} 
					,{name: 'OUT_METH'    			,text:'<t:message code="system.label.common.issuemethod" default="출고방법"/>'	,type : 'string',comboType:'AU', comboCode:'B039'} 
					,{name: 'ITEM_MAKER'    		,text:'<t:message code="system.label.common.mfgmaker" default="제조메이커"/>'	,type : 'string'} 
					,{name: 'ITEM_MAKER_PN'   ,text:'<t:message code="system.label.common.makerpartno" default="메이커 PART NO"/>'	,type : 'string'} 
					,{name: 'PURCH_LDTIME'    	,text:'<t:message code="system.label.common.purchaselt" default="구매 L/T"/>'	,type : 'string'} 
					,{name: 'MINI_PURCH_Q'    	,text:'<t:message code="system.label.common.minumunorderqty" default="최소발주량"/>'	,type : 'uniQty'} 
					,{name: 'UNIT_WGT'    			,text:'<t:message code="system.label.common.unitweight" default="단위중량"/>'	,type : 'string'} 
					,{name: 'WGT_UNIT'    			,text:'<t:message code="system.label.common.weightunit" default="중량단위"/>'	,type : 'string'} 
					,{name: 'ITEM_ACCOUNT'    	,text:'<t:message code="system.label.common.account" default="계정"/>'	,type : 'string',comboType:'AU', comboCode:'B020'} 
					,{name: 'DOM_FORIGN'    	,text:'<t:message code="system.label.common.domesticoverseas" default="국내외"/>'	,type : 'string',comboType:'AU', comboCode:'B019'} 
					,{name: 'SUPPLY_TYPE'    		,text:'<t:message code="system.label.common.procurementclassification" default="조달구분"/>'	,type : 'string',comboType:'AU', comboCode:'B014'} 
					,{name: 'HS_NO'    					,text:'<t:message code="system.label.common.hsno" default="HS번호"/>'	,type : 'string'} 
					,{name: 'HS_NAME'    			,text:'<t:message code="system.label.common.hsname" default="HS명"/>'	,type : 'string'} 
					,{name: 'HS_UNIT'    				,text:'<t:message code="system.label.common.hsunit" default="HS단위"/>'	,type : 'string'} 
					,{name: 'STOCK_UNIT'    		,text:'<t:message code="system.label.common.inventoryunit" default="재고단위"/>'	,type : 'string'} 
					,{name: 'TAX_TYPE'    			,text:'<t:message code="system.label.common.taxabledivision" default="과세구분"/>'	,type : 'string'} 
					,{name: 'STOCK_CARE_YN'    ,text:'<t:message code="system.label.common.inventorymanagementyn" default="재고관리여부"/>'	,type : 'string'} 
					,{name: 'SALE_UNIT'    			,text:'<t:message code="system.label.common.salesunit" default="판매단위"/>'	,type : 'string'} 
					,{name: 'ITEM_GROUP'    		,text:'<t:message code="system.label.common.repmodel" default="대표모델"/>'	,type : 'string'} 
					,{name: 'ITEM_GROUP_NAME'   ,text:'<t:message code="system.label.common.repmodelname" default="대표모델명"/>'	,type : 'string'} 
					,{name: 'ITEM_LEVEL1'    		,text:'<t:message code="system.label.common.majorgroup" default="대분류"/>'	,type : 'string'} 
					,{name: 'ITEM_LEVEL_NAME1'  ,text:'<t:message code="system.label.common.majorgroupname" default="대분류명"/>'	,type : 'string'} 
					,{name: 'ITEM_LEVEL2'    		,text:'<t:message code="system.label.common.middlegroup" default="중분류"/>'	,type : 'string'} 
					,{name: 'ITEM_LEVEL_NAME2'  ,text:'<t:message code="system.label.common.middlegroupname" default="중분류명"/>'	,type : 'string'} 
					,{name: 'ITEM_LEVEL3'    		,text:'<t:message code="system.label.common.minorgroup" default="소분류"/>'	,type : 'string'} 
					,{name: 'ITEM_LEVEL_NAME3'  ,text:'<t:message code="system.label.common.minorgroupname" default="소분류명"/>'	,type : 'string'} 
					,{name: 'LOT_SIZING_Q'    	,text:'<t:message code="system.label.common.minimumlotsizeqty" default="최소LotSize수량"/>'	,type : 'uniQty'} 
					,{name: 'MAX_PRODT_Q'    	,text:'<t:message code="system.label.common.maximumproductqty" default="최대생산량"/>'	,type : 'uniQty'} 
					,{name: 'STAN_PRODT_Q'    	,text:'<t:message code="system.label.common.standardproductionqty" default="표준생산량"/>'	,type : 'uniQty'} 
					,{name: 'TOTAL_ITEM'    		,text:'<t:message code="system.label.common.summaryitemcode2" default="집계품목"/>'	,type : 'string'} 
			]
	});
	
	
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    constructor : function(config){
        var me = this;
        if (config) {
            Ext.apply(me, config);
        }
        // -----------------------
        
	    /**
	     * 검색조건 (Search Panel)
	     * @type 
	     */
	    var wParam = this.param;
	    var t1= false, t2 = false;
	    if( Ext.isDefined(wParam)) {
	        if(wParam['POPUP_TYPE'] == 'GRID_CODE') {
	            t1 = true;
	            t2 = false;
	        }else {
	            if(wParam['TYPE'] == 'VALUE') {
	                t1 = true;
	                t2 = false;
	                
	            } else {
	                t1 = false;
	                t2 = true;
	                
	            }
	        }
	    }
	    me.panelSearch = Unilite.createSearchForm('',{
	        layout : {type : 'uniTable', columns : 3, tableAttrs: {
	            style: {
	                width: '100%'
	            }
	        }},
	        items: [   { fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>' ,   name:'DIV_CODE'  , xtype: 'uniCombobox' , comboType:'BOR120', readOnly: true }
	                   ,{ fieldLabel: '<t:message code="system.label.common.repmodel" default="대표모델"/>' ,  name:'ITEM_GROUP' ,colspan:2 }
	                   ,{ fieldLabel: '<t:message code="system.label.common.account" default="계정"/>' ,   name:'ITEM_ACCOUNT'  , xtype: 'uniCombobox' , comboType:'AU' ,comboCode:'B020', value: '04', allowBlank: false, readOnly: true, /*multiSelect : true, typeAhead: false,*/
		                    listeners:{
								beforequery: function(queryPlan, eOpts )	{
									var fValue = me.panelSearch.getValue('ITEM_ACCOUNT_FILTER');
									var store = queryPlan.combo.getStore();
									if(!Ext.isEmpty(fValue) )	{
										store.clearFilter(true);
										queryPlan.combo.queryFilter = null;	
										console.log("fValue :",fValue);
										store.filterBy(function(record, id){
											console.log("record :",record.get('value'),fValue.indexOf(record.get('value')));
											return fValue.indexOf(record.get('value')) > -1 ? record:null;
										});
									} else {
										store.clearFilter(true);
										queryPlan.combo.queryFilter = null;	
										store.loadRawData(store.proxy.data);
									}
								}
							}	
	                    }
	                   
	                   ,{ fieldLabel: '<t:message code="system.label.common.majorgroup" default="대분류"/>',     name: 'ITEM_LEVEL1' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve1Store') , child: 'ITEM_LEVEL2',colspan:2}
	                   ,{ fieldLabel: '<t:message code="system.label.common.procurementclassification" default="조달구분"/>' ,   name:'SUPPLY_TYPE'  , xtype: 'uniCombobox' , comboType:'AU' ,comboCode:'B014' }
	                   ,{ fieldLabel: '<t:message code="system.label.common.middlegroup" default="중분류"/>',     name: 'ITEM_LEVEL2' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve2Store') , child: 'ITEM_LEVEL3',colspan:2}
	                   ,{ fieldLabel: '<t:message code="system.label.common.searchitem" default="검색항목"/>' ,   name:'FIND_TYPE'  , xtype: 'uniCombobox' , comboType:'AU' ,comboCode:'B052' , value:'01'  }
	                   
	                   ,{ fieldLabel: '<t:message code="system.label.common.minorgroup" default="소분류"/>',     name: 'ITEM_LEVEL3' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve3Store') ,colspan:2}
	                   ,{ fieldLabel: '<t:message code="system.label.common.searchword" default="검색어"/>',     name: 'TXT_SEARCH'  ,
                            listeners:{
                                specialkey: function(field, e){
                                    if (e.getKey() == e.ENTER) {
                                       me.onQueryButtonDown();
                                    }
                                }
                            }
                        }
	                   ,{ fieldLabel: '<t:message code="system.label.common.itemcode" default="품목코드"/>' ,   name:'ITEM_SEARCH' , allowBlank:true}
	                   ,{ fieldLabel: '<t:message code="system.label.common.ㅍagentcustomfiltertype" default="검색제외구분"/>', name:'ITEM_EXCLUDE' , hidden:true} // (DIV_CODE:BPR500T 해당 사업장에 이미등록된코드 제외, PROD_ITEM_CODE: BPR500T 해당 사업장에 검색하는 등록된 코드 제외)
	                   ,{ fieldLabel: '<t:message code="system.label.common.agentcustomfilter" default="검색제외"/>', name:'PROD_ITEM_CODE' , hidden:true} 
	                   ,{ fieldLabel: '<t:message code="system.label.common.agentcustomfilter" default="검색제외"/>', name:'CHILD_ITEM_CODE' , hidden:true} 
	                   ,{ fieldLabel: '<t:message code="system.label.common.agentcustomfilter" default="검색제외"/>', name:'ITEM_ACCOUNT_FILTER' , hidden:true} 
	                   ,{ fieldLabel: '<t:message code="system.label.common.useflag" default="사용유무"/>',		name:'USE_YN', hidden:true}
	                   ,{ hideLabel: true,
	                        xtype: 'radiogroup', width: 150, id: 'rdoRadio',
	                         items:[     {inputValue: '1', boxLabel: '<t:message code="system.label.common.codeinorder" default="코드순"/>', name: 'RDO', checked: t1},
	                                    {inputValue: '2', boxLabel: '<t:message code="system.label.common.nameinorder" default="이름순"/>',  name: 'RDO', checked: t2} ]
	                        ,listeners : {
	                            change :  function ( radio, newValue, oldValue, eOpts ) {
	                                var lblSearch = me.panelSearch.getForm().findField('ITEM_SEARCH');                             
	                                if(newValue.RDO=='2')   {
	                                    lblSearch.setFieldLabel( '<t:message code="system.label.common.itemname" default="품목명"/>' );
	                                } else if(newValue.RDO=='1'){
	                                    lblSearch.setFieldLabel( '<t:message code="system.label.common.itemcode" default="품목코드"/>' );
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
	   
	     var masterGridConfig = {
            store : Unilite.createStoreSimple('${PKGNAME}.commissiondivPumokPopupMasterStore',{
							model: '${PKGNAME}.commissiondivPumokPopupModel',
				            autoLoad: false,
				            proxy: {
				                type: 'direct',
				                api: {
				                	read: 'popupService.commissionDivPumokPopup'
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
	                     { dataIndex: 'ITEM_CODE',          width: 120} 
	                    ,{ dataIndex: 'ITEM_NAME',          width: 240} 
	                    ,{ dataIndex: 'SPEC',               width: 100}  
	                    ,{ dataIndex: 'STOCK_UNIT',         width: 80} 
	                    ,{ dataIndex: 'ORDER_UNIT',         width: 80   ,hidden:true} 
	                    ,{ dataIndex: 'TRNS_RATE',          width: 80   ,hidden:true} 
	                    ,{ dataIndex: 'BASIS_P',            width: 90   ,hidden:true} 
	                    ,{ dataIndex: 'SALE_BASIS_P',       width: 90   ,hidden:true} 
	                    ,{ dataIndex: 'BARCODE',            width: 130  ,hidden:true} 
	                    ,{ dataIndex: 'SAFE_STOCK_Q',       width: 80   ,hidden:true} 
	                    ,{ dataIndex: 'EXPENSE_RATE',       width: 80   ,hidden:true} 
	                    ,{ dataIndex: 'SPEC_NUM',           width: 70   ,hidden:true} 
	                    ,{ dataIndex: 'WH_CODE',            width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'WORK_SHOP_CODE',     width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'DIV_CODE',           width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'OUT_METH',           width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'ITEM_MAKER',         width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'ITEM_MAKER_PN',      width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'PURCH_LDTIME',       width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'MINI_PURCH_Q',       width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'UNIT_WGT',           width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'WGT_UNIT',           width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'ITEM_ACCOUNT',       width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'DOM_FORIGN',         width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'SUPPLY_TYPE',        width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'HS_NO',              width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'HS_NAME',            width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'HS_UNIT',            width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'STOCK_UNIT',         width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'TAX_TYPE',           width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'STOCK_CARE_YN',      width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'SALE_UNIT',          width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'ITEM_GROUP',         width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'ITEM_GROUP_NAME',    width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'ITEM_LEVEL1',        width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'ITEM_LEVEL_NAME1',   width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'ITEM_LEVEL2',        width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'ITEM_LEVEL_NAME2',   width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'ITEM_LEVEL3',        width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'ITEM_LEVEL_NAME3',   width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'LOT_SIZING_Q',       width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'MAX_PRODT_Q',        width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'STAN_PRODT_Q',       width: 100  ,hidden:true} 
	                    ,{ dataIndex: 'TOTAL_ITEM',         width: 100  ,hidden:true}       
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
	    };
	    
	    if(Ext.isDefined(wParam)) {     
	        if(wParam['SELMODEL'] == 'MULTI') {
	            masterGridConfig.selModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : false });
	        }
	    }
	    
	    me.masterGrid = Unilite.createGrid('', masterGridConfig);
		                    
        
        // -----------------------
		config.items = [me.panelSearch, me.masterGrid];
		me.callParent(arguments);
    }, //constructor
	initComponent : function(){    
    	var me  = this;
        
        me.masterGrid.focus();
        
    	this.callParent();    	
    },    
	fnInitBinding : function(param) {
		//var param = window.dialogArguments;
        var me = this,
            masterGrid = me.masterGrid,
            panelSearch = me.panelSearch;
		var frm= panelSearch.getForm();
		
		var rdo = frm.findField('rdoRadio');
		var fieldTxt = frm.findField('ITEM_SEARCH');
		                      		
                    		
		if( Ext.isDefined(param)) {
			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
				if(param['POPUP_TYPE'] == 'GRID_CODE')	{
					fieldTxt.setValue(param['ITEM_CODE']);
					fieldTxt.setFieldLabel( '<t:message code="system.label.common.itemcode" default="품목코드"/>' );
					rdo.setValue('1');
				}else {
					if(param['TYPE'] == 'VALUE') {
						fieldTxt.setValue(param['ITEM_CODE']);
						fieldTxt.setFieldLabel( '<t:message code="system.label.common.itemcode" default="품목코드"/>' );
						rdo.setValue('1');
					} else {
						fieldTxt.setValue(param['ITEM_NAME']);
						fieldTxt.setFieldLabel( '품목명' );
						rdo.setValue('2');
					}
				}
				if(param['DIV_CODE'])	{
					frm.findField('DIV_CODE').setValue(param['DIV_CODE']); 
				}
				if(param['ITEM_ACCOUNT'])	{
					frm.findField('ITEM_ACCOUNT').setValue(param['ITEM_ACCOUNT']); 
				}
				if(param['ITEM_EXCLUDE'])	{
					frm.findField('ITEM_EXCLUDE').setValue(param['ITEM_EXCLUDE']); 
				}
				if(param['PROD_ITEM_CODE'])	{
					frm.findField('PROD_ITEM_CODE').setValue(param['PROD_ITEM_CODE']); 
				}
				if(param['CHILD_ITEM_CODE'])	{
					frm.findField('CHILD_ITEM_CODE').setValue(param['CHILD_ITEM_CODE']); 
				}
				if(param['DEFAULT_ITEM_ACCOUNT'])	{
					frm.findField('ITEM_ACCOUNT').setValue(param['DEFAULT_ITEM_ACCOUNT']); 
				}
				
				if(param['ITEM_CODE'] || param['ITEM_NAME'])	{
					this._dataLoad();
				}
			}
			frm.setValues(param);
			
			var sType = param['sType'];
			if(sType == "T")	{
				masterGrid.getColumn("HS_NO").show();
				masterGrid.getColumn("HS_NAME").show();
				masterGrid.getColumn("HS_UNIT").show();
			}
			this._dataLoad();
		}
		
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        var me = this,
            masterGrid = me.masterGrid,
            panelSearch = me.panelSearch;
		var selectRecords = masterGrid.getSelectedRecords();
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
        var me = this,
            masterGrid = me.masterGrid,
            panelSearch = me.panelSearch;
        if(panelSearch.isValid())	{
			var param= panelSearch.getValues();
			console.log( param );
			me.isLoading = true;
			masterGrid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
        }
	}
});


