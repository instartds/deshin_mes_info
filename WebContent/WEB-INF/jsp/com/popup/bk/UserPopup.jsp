<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
/**
*	사용자 팝업 
*
*/
%>

<t:appConfig pgmId="crm.pop.UserPopup"  />
<script type="text/javascript" >
function appMain() {

	/**
	 *   Model 정의 
	 * @type 
	 */
	Ext.define('UserPopupModel', {
	    extend: 'Ext.data.Model',
	    
	    fields: [ 	 {name: 'USER_ID' 			,text:'사용자ID' 	,type:'string'	}
					,{name: 'USER_NAME' 		,text:'사용자명' 	,type:'string'	}
	    			,{name: 'DEPT_CODE' 		,text:'부서코드' 	,type:'string'	}
					,{name: 'DEPT_NAME' 		,text:'부서명' 	,type:'string'	}
					,{name: 'DIV_CODE' 			,text:'사업장' 	,type:'string'	}
					,{name: 'BILL_DIV_CODE' 	,text:'신고사업장코드' 	,type:'string'	}
					,{name: 'BILL_DIV_NAME' 	,text:'신고사업장명' 	,type:'string'	}
					,{name: 'SECTION_CODE' 		,text:'사업부코드' 	,type:'string'	}
					,{name: 'SECTION_NAME' 		,text:'사업부명' 	,type:'string'	}
			]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('UserPopupMasterStore',{
			model: 'UserPopupModel',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	read: 'popupService.userPopup'
                }
            }
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var wParam = window.dialogArguments;
	
	var panelSearch =  Unilite.createSearchForm('searchForm',{
        layout : {type : 'table', columns : 1, tableAttrs: {
            style: {
                width: '100%'
            }
        }},
        items: [ { fieldLabel: '검색어', 	name:'TXT_SEARCH', id:'TXT_SEARCH'} ]
    });  
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
      var masterGrid =  Unilite.createGrid('UserPopupGrid', {
    	store: directMasterStore,
        columns:  [        
               		 { dataIndex: 'USER_ID'		,width: 100 }  
					,{ dataIndex: 'USER_NAME'		,width: 140 } 		
					,{ dataIndex: 'DEPT_CODE'		,width: 80 } 
					,{ dataIndex: 'DEPT_NAME'		,width: 100 } 		
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
		id  : 'UserPopupApp',
		fnInitBinding : function() {
			var param = window.dialogArguments;
			var frm= Ext.getCmp('searchForm');
			if(param['TYPE'] == 'VALUE')	{
				frm.setValue('TXT_SEARCH', param['USER_ID']);
			}else {
				frm.setValue('TXT_SEARCH', param['USER_NAME']);
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
