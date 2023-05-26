<%@page language="java" contentType="text/html; charset=utf-8"%>


	<t:ExtComboStore comboType="AU" comboCode="B014" />	<!--조달구분-->
	<t:ExtComboStore comboType="AU" comboCode="B020" />	<!--계정(품목계정)-->	
	<t:ExtComboStore comboType="BOR120"  /> <!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
	
<t:appConfig pgmId="crm.pop.ItemPopup2" />
<script type="text/javascript" >
function appMain() {

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('ItemPopup2Model', {
	    fields: [ 	 {name: 'ITEM_CODE' 	,text:'품목코드' 		,type:'string'	}
					,{name: 'ITEM_NAME' 	,text:'품목명' 			,type:'string'  }
					,{name: 'SPEC' 			,text:'규격' 			,type:'string'	}
					,{name: 'STOCK_UNIT' 	,text:'재고단위' 		,type:'string'	}
					,{name: 'SALE_UNIT' 	,text:'판매단위' 		,type:'string'	}
					,{name: 'TRNS_RATE' 	,text:'변환계수' 		,type:'string'	}
					,{name: 'SALE_BASIS_P' 	,text:'판매단가' 	,	 type:'uniUnitPrice'	}
					,{name: 'SPEC_NUM' 		,text:'도면번호' 		,type:'string'  }
					,{name: 'ITEM_MAKER' 	,text:'제조메이커' 		,type:'string'	}
					,{name: 'ITEM_MAKER_PN' ,text:'메이커PART NO' 	,type:'string'	}
					,{name: 'UNIT_WGT' 		,text:'단위중량' 		,type:'string'	}
					,{name: 'WGT_UNIT'		,text:'중량단위'		,type:'string'	}
					,{name: 'DOM_FORIGN' 	,text:'국내외' 			,type:'string', comboType:'AU',comboCode:'B019'	}
					,{name: 'SUPPLY_TYPE' 	,text:'조달구분'		,type:'string', comboType:'AU',comboCode:'B014' }
					,{name: 'HS_NO' 		,text:'HS번호' 			,type:'string'	}
					,{name: 'HS_NAME' 		,text:'HS명' 			,type:'string'	}
					,{name: 'HS_UNIT' 		,text:'HS단위' 			,type:'string'	}
					,{name: 'STOCK_UNIT2' 	,text:'재고단위' 		,type:'string'	}					
					,{name: 'TAX_TYPE' 		,text:'과세구분' 		,type:'string'	}
					,{name: 'STOCK_CARE_YN' ,text:'재고관리여부'	,type:'string'	}	
			]
	});
	
  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('itemPopup2MasterStore',{
			model: 'ItemPopup2Model',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	read: 'popupService.itemPopup2'
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
		if(wParam['TYPE'] == 'VALUE') {
			t1 = true;
			t2 = false;
			
		} else {
			t1 = false;
			t2 = true;
			
		}
	}
	var panelSearch = Unilite.createSearchForm('searchForm',{
        layout : {type : 'uniTable', columns : 3, tableAttrs: {
            style: {
                width: '100%'
            }
        }},
        items: [   {fieldLabel: '사업장', name:'DIV_CODE', xtype: 'uniCombobox', comboType:'BOR120', allowBlank:false, readOnly: true }
        		   ,{ fieldLabel: '대표모델' ,  name:'TXTITEM_GROUP' , id:'TXTITEM_GROUP' , xtype: 'uniTextfield', colspan: 2 }
        		   ,{fieldLabel: '계정', name:'TXT_ACCNT', xtype: 'uniCombobox', comboType:'B020'}
                   ,{ fieldLabel: '대분류',     name: 'TXTLV_L1' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve1Store') , child: 'TXTLV_L2', colspan: 2}
                   ,{fieldLabel: '조달구분', name:'TXT_SUPPLY_TYPE', xtype: 'uniCombobox', comboType:'B014'}
                   ,{ fieldLabel: '중분류',     name: 'TXTLV_L2' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve2Store') , child: 'TXTLV_L3', colspan: 2}
                   ,{ fieldLabel: '검색항목' ,   name:'TXTFIND_TYPE' , id:'TXTFIND_TYPE' , xtype: 'uniCombobox' , comboType:'AU' ,comboCode:'B052' , value:'01', allowBlank:false}                   
                   ,{ fieldLabel: '소분류',     name: 'TXTLV_L3' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve3Store') , colspan: 2}
                   ,{ fieldLabel: '검색어',     name: 'TXT_SEARCH', id:'TXT_SEARCH' , xtype: 'uniTextfield' }                   
                   ,{ fieldLabel: '품목코드' ,   name:'LBL_SEARCH' ,  xtype: 'uniTextfield' }
                   ,{ fieldLabel: ' ',
                        xtype: 'radiogroup', width: 230, id: 'rdoRadio',
                         items:[     {inputValue: '1', boxLabel: '코드순', name: 'RDO', checked: t1},
                                    {inputValue: '2', boxLabel: '이름순',  name: 'RDO', checked: t2} ]
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
     var masterGrid = Unilite.createGrid('itemPopup2Grid', {
    	store: directMasterStore,
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
				window.returnValue = rv;
				window.close();
	          }
          } // listeners
    });
    
    
   	    Unilite.PopupMain({
		items : [panelSearch, 	masterGrid],
		id  : 'itemPopup2App',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			var param = window.dialogArguments;
			var frm= Ext.getCmp('searchForm').getForm();
			var fieldTxt = frm.findField('LBL_SEARCH')
			var rdo = frm.findField('rdoRadio');
			if( Ext.isDefined(param)) {
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
			var selectRecord = masterGrid.getSelectedRecord();
		 	var rv = {
				status : "OK",
				data:[selectRecord.data]
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
