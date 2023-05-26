<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
	//  사업장별 품목 'Unilite.app.popup.DivPumokPopup_YP' 
	request.setAttribute("PKGNAME","Unilite.app.popup.DivPumokPopup_YP");
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
	Unilite.defineModel('${PKGNAME}.divPumokPopup_YPModel', {
	    fields: [ 	{name: 'ITEM_CODE'    		,text:'품목코드'	,type : 'string'} 
					,{name: 'ITEM_NAME'    		,text:'품목명'	,type : 'string'} 
					,{name: 'SPEC'    			,text:'규격'	,type : 'string'} 
					,{name: 'SPEC_NUM'    		,text:'규격'	,type : 'int'} 
					,{name: 'STOCK_UNIT'    	,text:'재고단위'	,type : 'string'} 
					,{name: 'ORDER_UNIT'    	,text:'구매단위'	,type : 'string'} 
					,{name: 'TRNS_RATE'    		,text:'변환계수'	,type : 'uniER'} 
					,{name: 'BASIS_P'    		,text:'재고단가'	,type : 'uniUnitPrice'} 
					,{name: 'SALE_BASIS_P'    	,text:'판매단가'	,type : 'uniUnitPrice'} 
					,{name: 'BARCODE'    		,text:'바코드'	,type : 'string'} 
					,{name: 'SAFE_STOCK_Q'    	,text:'안전재고량'	,type : 'uniUnitPrice'} 
					,{name: 'EXPENSE_RATE'    	,text:'수입부대비용율'	,type : 'uniER'} 
					,{name: 'SPEC_NUM'    		,text:'도면번호'	,type : 'string'} 
					,{name: 'WH_CODE'    		,text:'기준창고'	,type : 'string', store:Ext.data.StoreManager.lookup('whList')} 
					,{name: 'WORK_SHOP_CODE'    ,text:'주작업장'	,type : 'string'} 
					,{name: 'DIV_CODE'    		,text:'기준사업장'	,type : 'string'} 
					,{name: 'OUT_METH'    		,text:'출고방법'	,type : 'string',comboType:'AU', comboCode:'B039'} 
					,{name: 'ITEM_MAKER'    	,text:'제조메이커'	,type : 'string'} 
					,{name: 'ITEM_MAKER_PN'    	,text:'메이커PART NO'	,type : 'string'} 
					,{name: 'PURCH_LDTIME'    	,text:'구매 L/T'	,type : 'string'} 
					,{name: 'MINI_PURCH_Q'    	,text:'최소발주량'	,type : 'uniQty'} 
					,{name: 'UNIT_WGT'    		,text:'단위중량'	,type : 'string'} 
					,{name: 'WGT_UNIT'    		,text:'중량단위'	,type : 'string'} 
					,{name: 'ITEM_ACCOUNT'    	,text:'계정'	,type : 'string',comboType:'AU', comboCode:'B020'} 
					,{name: 'DOM_FORIGN'    	,text:'국내외'	,type : 'string',comboType:'AU', comboCode:'B019'} 
					,{name: 'SUPPLY_TYPE'    	,text:'조달구분'	,type : 'string',comboType:'AU', comboCode:'B014'} 
					,{name: 'HS_NO'    			,text:'HS번호'	,type : 'string'} 
					,{name: 'HS_NAME'    		,text:'HS명'	,type : 'string'} 
					,{name: 'HS_UNIT'    		,text:'HS단위'	,type : 'string'} 
					,{name: 'STOCK_UNIT'    	,text:'재고단위'	,type : 'string'} 
					,{name: 'TAX_TYPE'    		,text:'과세구분'	,type : 'string'} 
					,{name: 'STOCK_CARE_YN'    	,text:'재고관리여부'	,type : 'string'} 
					,{name: 'SALE_UNIT'    		,text:'판매단위'	,type : 'string'} 
					,{name: 'ITEM_GROUP'    	,text:'대표모델'	,type : 'string'} 
					,{name: 'ITEM_GROUP_NAME'   ,text:'대표모델명'	,type : 'string'} 
					,{name: 'ITEM_LEVEL1'    	,text:'대분류'	,type : 'string'} 
					,{name: 'ITEM_LEVEL_NAME1'  ,text:'대분류명'	,type : 'string'} 
					,{name: 'ITEM_LEVEL2'    	,text:'중분류'	,type : 'string'} 
					,{name: 'ITEM_LEVEL_NAME2'  ,text:'중분류명'	,type : 'string'} 
					,{name: 'ITEM_LEVEL3'    	,text:'소분류'	,type : 'string'} 
					,{name: 'ITEM_LEVEL_NAME3'  ,text:'소분류명'	,type : 'string'} 
					,{name: 'LOT_SIZING_Q'    	,text:'최소 LOT SIZING 수량'	,type : 'uniQty'} 
					,{name: 'MAX_PRODT_Q'    	,text:'최대생산량'	,type : 'uniQty'} 
					,{name: 'STAN_PRODT_Q'    	,text:'표준생산량'	,type : 'uniQty'} 
					,{name: 'TOTAL_ITEM'    	,text:'집계품목'	,type : 'string'}  
                    ,{name: 'MAIN_CUSTOM_CODE'  ,text:'거래처'   ,type : 'string'} 
                    ,{name: 'MAIN_CUSTOM_NAME'  ,text:'거래처명'    ,type : 'string'} 
                    ,{name: 'LOT_YN'            ,text:'LOT관리여부'    ,type : 'string'}
                    ,{name: 'OEM_ITEM_CODE'     ,text:'품번'    ,type : 'string'}
                    ,{name: 'INSPEC_YN'         ,text:'품질대상여부'    ,type : 'string'}
//                    ,{name: 'CAR_TYPE'          ,text:'차종'      ,type : 'string'}
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
//	    var t1= false, t2 = false;
//	    if( Ext.isDefined(wParam)) {
//	        if(wParam['POPUP_TYPE'] == 'GRID_CODE') {
//	            t1 = true;
//	            t2 = false;
//	        }else {
//	            if(wParam['TYPE'] == 'VALUE') {
//	                t1 = true;
//	                t2 = false;
//	                
//	            } else {
//	                t1 = false;
//	                t2 = true;
//	                
//	            }
//	        }
//	    }
	    if(Ext.isDefined(wParam)) {  
            var isReadOnly = false;   
            if(wParam['SUPPLY_TYPE_READONLY'] == 'supplyReadOnly') {
            	isReadOnly = true;
            }
	    }
	    
	    me.panelSearch = Unilite.createSearchForm('',{
	        layout : {type : 'uniTable', columns : 3, tableAttrs: {
	            style: {
	                width: '100%'
	            }
	        }},
	        items: [   { fieldLabel: '사업장' ,   name:'DIV_CODE'  , xtype: 'uniCombobox' , comboType:'BOR120', readOnly: true }
	                   ,{ fieldLabel: '대표모델' ,  name:'ITEM_GROUP' ,colspan:2 }
	                   ,{ fieldLabel: '계정' ,   name:'ITEM_ACCOUNT'  , xtype: 'uniCombobox' , comboType:'AU' ,comboCode:'B020', value: '01'/*, allowBlank: false*/, /*multiSelect : true, typeAhead: false,*/
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
	                   
	                   ,{ fieldLabel: '대분류',     name: 'ITEM_LEVEL1' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve1Store') , child: 'ITEM_LEVEL2',colspan:2}
	                   ,{ fieldLabel: '조달구분' ,   name:'SUPPLY_TYPE'  , xtype: 'uniCombobox' , comboType:'AU' ,comboCode:'B014', readOnly: isReadOnly }
	                   ,{ fieldLabel: '중분류',     name: 'ITEM_LEVEL2' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve2Store') , child: 'ITEM_LEVEL3',colspan:2}
	                   ,{ fieldLabel: '검색항목' ,   name:'FIND_TYPE'  , xtype: 'uniCombobox' , comboType:'AU' ,comboCode:'B052' , value:'01'  }
	                   
	                   ,{ fieldLabel: '소분류',     name: 'ITEM_LEVEL3' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve3Store'), parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'], levelType:'ITEM'  ,colspan:2}
	                   ,{ fieldLabel: '검색어',     name: 'TXT_SEARCH'  }
//	                   ,{ fieldLabel: '품목코드' ,   name:'ITEM_SEARCH' /*, allowBlank:false*/}
	                   ,{ xtype: 'uniTextfield', fieldLabel: '조회조건',     name:'TXT_SEARCH2', colspan: 2}
//	                   ,{ fieldLabel: '품번' ,  name:'OEM_ITEM_CODE' }
	                   ,{ fieldLabel: '검색제외구분', name:'ITEM_EXCLUDE' , hidden:true} // (DIV_CODE:BPR500T 해당 사업장에 이미등록된코드 제외, PROD_ITEM_CODE: BPR500T 해당 사업장에 검색하는 등록된 코드 제외)
	                   ,{ fieldLabel: '검색제외', name:'PROD_ITEM_CODE' , hidden:true} 
	                   ,{ fieldLabel: '검색제외', name:'CHILD_ITEM_CODE' , hidden:true} 
	                   ,{ fieldLabel: '검색제외', name:'ITEM_ACCOUNT_FILTER' , hidden:true} 
	                   ,{ fieldLabel: '사용유무',		name:'USE_YN', hidden:true}
                       ,{ fieldLabel: '추가쿼리관련1',    name:'ADD_QUERY1',   xtype: 'uniTextfield', hidden: true}
                       ,{ fieldLabel: '추가쿼리관련2',    name:'ADD_QUERY2',   xtype: 'uniTextfield', hidden: true}
                       ,{ fieldLabel: '추가쿼리관련3',    name:'ADD_QUERY3',   xtype: 'uniTextfield', hidden: true}
                       ,{ fieldLabel: '내수/수입' ,   name:'DOM_FORIGN'  , xtype: 'uniTextfield', hidden: true }
	                   ,{ fieldLabel: '거래처' ,  name:'CUSTOM_CODE'   , xtype: 'uniTextfield', hidden: true }
	                   ,{ 
	                        xtype: 'radiogroup', width: 150, id: 'rdo_DivPumokPopup_YP',fieldLabel: ' ',
	                         items:[     {inputValue: '1', boxLabel: '견적', name: 'RDO', width: 70, checked: true},
	                                    {inputValue: '2', boxLabel: '일반',  name: 'RDO', width: 80} ]
	                   },
	                   { fieldLabel: '기준일자'  ,  name:'ORDER_DATE'   , xtype: 'uniDatefield', hidden: true },
	                   { fieldLabel: 'PGM_ID',  name:'PGM_ID'       , xtype: 'uniTextfield', hidden: true }
	                   
	                
	        ]
	    });
        
        
	    /**
	     * Master Grid 정의(Grid Panel)
	     * @type 
	     */
	   
	     var masterGridConfig = {
            store : Unilite.createStoreSimple('${PKGNAME}.divPumokPopup_YPMasterStore',{
							model: '${PKGNAME}.divPumokPopup_YPModel',
				            autoLoad: false,
				            proxy: {
				                type: 'direct',
				                api: {
				                	read: 'popupService.divPumokPopup_YP'
				                }
				            },listeners : {
                                load: function(store, records, successful, eOpts) {
                                    me.masterGrid.focus();
//                                  if(me.masterGrid.getStore().count() > 0){
//                                      me.masterGrid.getView().focusRow(0);
//                                  }
                                    
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
	                    ,{ dataIndex: 'MAIN_CUSTOM_NAME',   width: 130  }
                        ,{ dataIndex: 'INSPEC_YN',          width: 100} 
//                        ,{ dataIndex: 'CAR_TYPE',           width: 100} 
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
                        ,{ dataIndex: 'MAIN_CUSTOM_CODE',   width: 100  ,hidden:true}
                        ,{ dataIndex: 'LOT_YN',             width: 100  ,hidden:false}      
                        ,{ dataIndex: 'OEM_ITEM_CODE',      width: 100  ,hidden:false}
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
		var fieldTxt = frm.findField('TXT_SEARCH2');
		                      		
                    		
		if( Ext.isDefined(param)) {
			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
//				if(param['POPUP_TYPE'] == 'GRID_CODE')	{
//					fieldTxt.setValue(param['ITEM_CODE']);
//					fieldTxt.setFieldLabel( '품목코드' );
//					rdo.setValue('1');
//				}else {
//					if(param['TYPE'] == 'VALUE') {
//						fieldTxt.setValue(param['ITEM_CODE']);
//						fieldTxt.setFieldLabel( '품목코드' );
//						rdo.setValue('1');
//					} else {
//						fieldTxt.setValue(param['ITEM_NAME']);
//						fieldTxt.setFieldLabel( '품목명' );
//						rdo.setValue('2');
//					}
//				}
				var me = this;		
				var frm= me.panelSearch.getForm();		
				var fieldTxt = frm.findField('TXT_SEARCH2');
				var frm= me.panelSearch.getForm();
				var fieldTxt = frm.findField('TXT_SEARCH2');
				me.panelSearch.setValues(param);
				if(param['TYPE'] == 'VALUE') {
		        	if(!Ext.isEmpty(param['ITEM_CODE'])){
		        		fieldTxt.setValue(param['ITEM_CODE']);        	
		        	}
		        }else{
		        	if(!Ext.isEmpty(param['ITEM_CODE'])){
		        		fieldTxt.setValue(param['ITEM_CODE']);        	
		        	}
		        	if(!Ext.isEmpty(param['ITEM_NAME'])){
		        		fieldTxt.setValue(param['ITEM_NAME']);
		        	}
		        }
		        //거래처 받아와서 조회
				if(param['CUSTOM_CODE'])	{
					frm.findField('CUSTOM_CODE').setValue(param['CUSTOM_CODE']); 
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
				if(param['ORDER_DATE'])   {
                    frm.findField('ORDER_DATE').setValue(param['ORDER_DATE']); 
                }
				if(param['PGM_ID'])   {
                    frm.findField('PGM_ID').setValue(param['PGM_ID']); 
                }
			}
			frm.setValues(param);
			
			var sType = param['sType'];
			if(sType == "T")	{
				masterGrid.getColumn("HS_NO").show();
				masterGrid.getColumn("HS_NAME").show();
				masterGrid.getColumn("HS_UNIT").show();
			}
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
			param.ORDER_DATE = UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE'));
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


