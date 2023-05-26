<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
/**
*	부서 팝업 
*
*/
%>

<t:appConfig pgmId="crm.pop.shopPopup"  />
<script type="text/javascript" >
function appMain() {

	/**
	 *   Model 정의 
	 * @type 
	 */
	Ext.define('ShopPopupModel', {
	    fields: [ 	 
	    	{name: 'DIV_CODE' 				, text: '사업장코드' 			, type: 'string'},
	    	{name: 'SHOP_CODE'				, text: '매장코드'				, type: 'string'},
		    {name: 'SHOP_NAME'				, text: '매장명'				, type: 'string'},
			{name: 'WH_CODE'				, text: '주창고'				, type: 'string'},
		    {name: 'BRAND_CODE'				, text: '브랜드(분류)'			, type: 'string'},
			{name: 'DEPT_CODE'				, text: '부서'				, type: 'string'},
		    {name: 'DEPT_NAME'				, text: '부서명'				, type: 'string'},
			{name: 'STAFF_ID'				, text: '담당자'				, type: 'string'},
			{name: 'PHONE_NUMBER'			, text: '전화번호'				, type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('shopPopupMasterStore',{
			model: 'ShopPopupModel',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	read: 'popupService.shopPopup'
                }
            }
	});
	
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
      var masterGrid =  Unilite.createGrid('shopPopupGrid', {
    	store: directMasterStore,
        columns:  [        
       		 { dataIndex: 'DIV_CODE' 			,width: 100 }, 
       		 { dataIndex: 'SHOP_CODE'			,width: 100 }, 
       		 { dataIndex: 'SHOP_NAME'			,width: 170 }, 
       		 { dataIndex: 'WH_CODE'				,width: 120 }, 
       		 { dataIndex: 'BRAND_CODE'			,width: 90 }, 
       		 { dataIndex: 'DEPT_CODE'			,width: 100 }, 
       		 { dataIndex: 'DEPT_NAME'			,width: 170 }, 
       		 { dataIndex: 'STAFF_ID'			,width: 80 }, 
       		 { dataIndex: 'PHONE_NUMBER'		,width: 115 }
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
		id  : 'shopPopupApp',
		fnInitBinding : function() {
			var param = window.dialogArguments;
			var frm= Ext.getCmp('searchForm').getForm();
			var fieldTxt = frm.findField('TXT_SEARCH');

			if( Ext.isDefined(param)) {
				if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
					if(param['TYPE'] == 'VALUE') {
						fieldTxt.setValue(param['SHOP_CODE']);
						rdo.setValue('1');
					} else {
						fieldTxt.setValue(param['SHOP_NAME']);
						rdo.setValue('2');
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
