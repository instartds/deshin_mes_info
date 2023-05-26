<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
/**
*	부서 팝업 
*
*/
%>

<t:appConfig pgmId="crm.pop.DeptPopup"  />
<script type="text/javascript" >
function appMain() {

	/**
	 *   Model 정의 
	 * @type 
	 */
	Ext.define('DeptPopupModel', {
	    extend: 'Ext.data.Model',
	    fields: [ 	 {name: 'TREE_CODE' 		,text:'부서코드' 	,type:'string'	}
					,{name: 'TREE_NAME' 		,text:'부서명' 	,type:'string'	}
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
	var directMasterStore = Unilite.createStore('DeptPopupMasterStore',{
			model: 'DeptPopupModel',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	read: 'popupService.deptPopup'
                }
            }
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

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
      var masterGrid =  Unilite.createGrid('DeptPopupGrid', {
    	store: directMasterStore,
        columns:  [        
               		 { dataIndex: 'TREE_CODE'		,width: 140 }  
					,{ dataIndex: 'TREE_NAME'		,width: 140 } 			
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
		id  : 'DeptPopupApp',
		fnInitBinding : function() {
			var param = window.dialogArguments;
			var frm= Ext.getCmp('searchForm');
			if(param['TREE_CODE'] && param['TREE_CODE']!='')	frm.setValue('TXT_SEARCH', param['TREE_CODE']);
			if(param['TREE_NAME'] && param['TREE_NAME']!='')	frm.setValue('TXT_SEARCH', param['TREE_NAME']);
			
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
