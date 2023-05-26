<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
/**
*	세무서 팝업 
*
*/
%>

<t:appConfig pgmId="crm.pop.SafferTaxPopup"  />
<script type="text/javascript" >
function appMain() {

	/**
	 *   Model 정의 
	 * @type 
	 */
	Ext.define('SafferTaxPopupModel', {
	    extend: 'Ext.data.Model',
	    fields: [ 	 {name: 'SUB_CODE' 		,text:'세무서코드' 	,type:'string'	}
					,{name: 'CODE_NAME' 		,text:'세무서명' 	,type:'string'	}
			]
	});
	
  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore = Unilite.createStore('safferTaxPopupMasterStore',{
			model: 'SafferTaxPopupModel',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	read: 'popupService.safferTaxPopup'
                }
            }
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var wParam = window.dialogArguments;
	
	var panelSearch = {
        xtype: 'uniSearchForm',
        id: 'searchForm',
        layout : {type : 'table', columns : 1, tableAttrs: {
            style: {
                width: '100%'
            }
        }},
        width:'100%',
        items: [ { fieldLabel: '검색어', 	name:'TXT_SEARCH', id:'TXT_SEARCH'} ]
    };  
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('SafferTaxPopupGrid', {
    	store: directMasterStore,
    	uniOpt:{
    		useRowNumberer:false,
        	expandLastColumn: false
        },
        columns:  [        
               		 { dataIndex: 'SUB_CODE'		,width: 140 }  
					,{ dataIndex: 'CODE_NAME'		,width: 140 } 
					
			
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
    });
    
    
 	    Unilite.PopupMain({
		items : [panelSearch, 	masterGrid],
		id  : 'SafferTaxPopupApp',
		fnInitBinding : function() {
			var param = window.dialogArguments;
			var frm= Ext.getCmp('searchForm');

			if(param['TYPE'] == 'VALUE')	{
				frm.setValue('TXT_SEARCH', param['SUB_CODE']);
			}else {
				frm.setValue('TXT_SEARCH', param['CODE_NAME']);
			}
			this._dataLoad();
		},
		 onQueryButtonDown : function()	{
			this._dataLoad();
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
