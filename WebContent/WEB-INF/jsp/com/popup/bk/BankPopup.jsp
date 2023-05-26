<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
/**
*	은행 팝업 
*
*/
%>

<t:appConfig pgmId="crm.pop.BankPopup"  />
<script type="text/javascript" >
function appMain() {

	/**
	 *   Model 정의 
	 * @type 
	 */
	Ext.define('BankPopupModel', {
	    extend: 'Ext.data.Model',
	    fields: [ 	 {name: 'BANK_CODE' 		,text:'은행코드' 	,type:'string'	}
					,{name: 'BANK_NAME' 		,text:'은행명' 	,type:'string'	}
			]
	});
	
  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore = Unilite.createStore('bankPopupMasterStore',{
			model: 'BankPopupModel',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	read: 'popupService.bankPopup'
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
    var masterGrid = Unilite.createGrid('BankPopupGrid', {
    	store: directMasterStore,
        columns:  [        
               		 { dataIndex: 'BANK_CODE'		,width: 140 }  
					,{ dataIndex: 'BANK_NAME'		,width: 140 } 
					
			
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
		id  : 'BankPopupApp',
		fnInitBinding : function() {
			var param = window.dialogArguments;
			var frm= Ext.getCmp('searchForm');

			if(param['TYPE'] == 'VALUE')	{
				frm.setValue('TXT_SEARCH', param['BANK_CODE']);
			}else {
				frm.setValue('TXT_SEARCH', param['BANK_NAME']);
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
