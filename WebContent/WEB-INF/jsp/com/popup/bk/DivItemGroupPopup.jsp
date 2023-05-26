<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
/**
*	거래처(거래처분류조건포함)
*
*/
%>
<t:appConfig pgmId="crm.pop.DivItemGroupPopup"  >
	<t:ExtComboStore comboType="AU" comboCode="B020" />	<!-- '품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B014"/>				<!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>				<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B019"/>				<!-- 국내외 -->
	<t:ExtComboStore comboType="AU" comboCode="B039"/>				<!-- 출고방법 -->
	<t:ExtComboStore comboType="BOR120" />				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B052"/>				<!-- 검색항목 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /><!--대분류-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /><!--중분류-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /><!--소분류-->	
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />		<!--창고-->
</t:appConfig>
<script type="text/javascript" >
function appMain() {

	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('divItemGroupPopupModel', {
	    fields: [ 	{name: 'ITEM_CODE'    		,text:'품목코드'	,type : 'string'} 
					,{name: 'ITEM_NAME'    		,text:'품목명'	,type : 'string'} 
					,{name: 'SPEC'    			,text:'규격'	,type : 'string'} 
					,{name: 'SPEC_NUM'    		,text:'규격'	,type : 'int'} 
					,{name: 'STOCK_UNIT'    	,text:'재고단위'	,type : 'string'} 
					,{name: 'ORDER_UNIT'    	,text:'구매단위'	,type : 'string'} 
					,{name: 'TRNS_RATE'    		,text:'변환계수'	,type : 'uniER'} 
					,{name: 'BASIS_P'    		,text:'재고단가'	,type : 'uniUnitPrice'} 
					,{name: 'SALE_BASIS_P'    	,text:'판매단가'	,type : 'uniUnitPrice'} 
					//,{name: 'BARCODE'    		,text:'바코드'	,type : 'string'} 
					,{name: 'SAFE_STOCK_Q'    	,text:'안전재고량'	,type : 'uniUnitPrice'} 
					,{name: 'EXPENSE_RATE'    	,text:'수입부대비용율'	,type : 'uniER'} 
					,{name: 'SPEC_NUM'    		,text:'도면번호'	,type : 'int'} 
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
					,{name: 'ITEM_ACCOUNT'    	,text:'품목계정'	,type : 'string',comboType:'AU', comboCode:'B020'} 
					,{name: 'DOM_FORIGN'    	,text:'국내외'	,type : 'string',comboType:'AU', comboCode:'B019'} 
					,{name: 'SUPPLY_TYPE'    	,text:'조달구분'	,type : 'string',comboType:'AU', comboCode:'B014'} 
					,{name: 'HS_NO'    			,text:'HS번호'	,type : 'string'} 
					,{name: 'HS_NAME'    		,text:'HS명'	,type : 'string'} 
					,{name: 'HS_UNIT'    		,text:'HS단위'	,type : 'string'} 
					,{name: 'STOCK_UNIT'    	,text:'재고단가'	,type : 'string'} 					
			]
	});
	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('divItemGroupPopupMasterStore',{
			model: 'divItemGroupPopupModel',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	read: 'popupService.divItemGroupPopup'
                }
            }
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var wParam = window.dialogArguments;
	var t1= false, t2 = false;
	if( Ext.isDefined(wParam)) {
		if(wParam['POPUP_TYPE'] == 'GRID_CODE')	{
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
	var panelSearch = Unilite.createSearchForm('searchForm',{
        layout : {type : 'uniTable', columns : 3, tableAttrs: {
            style: {
                width: '100%'
            }
        }},
        items: [    { fieldLabel: '사업장' ,   name:'DIV_CODE'  , xtype: 'uniCombobox' , comboType:'BOR120'  }
        		   ,{ fieldLabel: '대표모델' ,  name:'ITEM_GROUP' ,colspan:2 }
                   ,{ fieldLabel: '계정' ,   name:'ITEM_ACCOUNT'  , xtype: 'uniCombobox' , comboType:'AU' ,comboCode:'B020' , value:'01'}
                   
                   ,{ fieldLabel: '대분류',     name: 'ITEM_LEVEL1' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve1Store') , child: 'ITEM_LEVEL2',colspan:2}
                   ,{ fieldLabel: '조달구분' ,   name:'SUPPLY_TYPE'  , xtype: 'uniCombobox' , comboType:'AU' ,comboCode:'B014' }
                   ,{ fieldLabel: '중분류',     name: 'ITEM_LEVEL2' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve2Store') , child: 'ITEM_LEVEL3',colspan:2}
                   ,{ fieldLabel: '검색항목' ,   name:'FIND_TYPE'  , xtype: 'uniCombobox' , comboType:'AU' ,comboCode:'B052' }
                   
                   ,{ fieldLabel: '소분류',     name: 'ITEM_LEVEL3' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve3Store') ,colspan:2}
                   ,{ fieldLabel: '검색어',     name: 'TXT_SEARCH'  }
                   ,{ fieldLabel: '품목코드' ,   name:'ITEM_SEARCH' }
                   ,{ hideLabel: true,
                        xtype: 'radiogroup', width: 150, id: 'rdoRadio',
                         items:[     {inputValue: '1', boxLabel: '코드순', name: 'RDO', checked: t1},
                                    {inputValue: '2', boxLabel: '이름순',  name: 'RDO', checked: t2} ]
                        ,listeners : {
                        	change :  function ( radio, newValue, oldValue, eOpts )	{
                        		var lblSearch = panelSearch.getForm().findField('ITEM_SEARCH');                        		
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
   
     var masterGridConfig = {
    	store: directMasterStore,
    	uniOpt:{
    				 useRowNumberer: false
        },
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
				window.returnValue = rv;
				window.close();
	          }
          }
    };
    
    if(Ext.isDefined(wParam)) {		
		if(wParam['SELMODEL'] == 'MULTI') {
			masterGridConfig.selModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : false });
  		}
    }
    
    var masterGrid = Unilite.createGrid('divItemGroupPopupGrid', masterGridConfig);
    
   	    Unilite.PopupMain({
		items : [panelSearch, 	masterGrid],
		fnInitBinding : function() {
			var param = window.dialogArguments;
			var frm= Ext.getCmp('searchForm').getForm();
			
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
				panelSearch.setValues(param);
				var sType = param['sType'];
				if(sType == "T")	{
					masterGrid.getColumn("HS_NO").show();
					masterGrid.getColumn("HS_NAME").show();
					masterGrid.getColumn("HS_UNIT").show();
				}
			}
			
			
			
			this._dataLoad();
		},
		 onQueryButtonDown : function()	{
			this._dataLoad();
		},
		onSubmitButtonDown : function()	{
			var selectRecords = masterGrid.getSelectedRecords();
			var rvRecs= new Array();
			Ext.each(selectRecords, function(record, i)	{
				rvRecs[i] = record.data;
			})
		 	var rv = {	
				status : "OK",
				data:rvRecs
			};
			window.returnValue = rv;
			window.close();
		},
		_dataLoad : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			masterGrid.getStore().load({
				params : param
			});
		}
	});

};


</script>
