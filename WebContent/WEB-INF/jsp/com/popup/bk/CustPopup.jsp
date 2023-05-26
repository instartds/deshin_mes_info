<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
/**
*	거래처 팝업 
*
*/
%>
<t:appConfig pgmId="crm.pop.CustPopup"  >
	<t:ExtComboStore comboType="AU" comboCode="B015"/>
	<t:ExtComboStore comboType="AU" comboCode="CB25"/>
</t:appConfig>

<script type="text/javascript" >
function appMain() {

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('CustPopupModel', {
	    fields: [ 	 {name: 'CUSTOM_CODE' 		,text:'거래처코드' 	,type:'string'	}
					,{name: 'CUSTOM_NAME' 		,text:'거래처명' 	,type:'string'	}
					,{name: 'COMPANY_NUM' 		,text:'사업자번호' 	,type:'string'	}
					,{name: 'TOP_NAME' 			,text:'대표자' 		,type:'string'	, comboType:'AU',comboCode:'CB25' }
					,{name: 'BUSINESS_TYPE' 	,text:'사업자구분' 	,type:'string'	}
					,{name: 'COMP_CLASS' 		,text:'업종' 		,type:'string'	}
					,{name: 'COMP_TYPE' 		,text:'업태' 		,type:'string'	}
					,{name: 'ADDR1' 			,text:'주소1' 		,type:'string'	}
					,{name: 'ADDR2' 			,text:'주소2' 		,type:'string'	}
					,{name: 'TELEPHON' 			,text:'전화번호' 	,type:'string'	}
					,{name: 'FAX_NUM' 			,text:'팩스번호' 	,type:'string'	}
					,{name: 'MAIL_ID' 			,text:'E_mail' 		,type:'string'	}
					,{name: 'WON_CALC_BAS' 		,text:'원미만계산' 	,type:'string'	}
					,{name: 'TO_ADDRESS' 		,text:'송신주소' 	,type:'string'	}
					,{name: 'TAX_CALC_TYPE' 	,text:'세액계산법' 	,type:'string'	}
					,{name: 'TRANS_CLOSE_DAY'	,text:'거래처마감일',type:'string'	}
					,{name: 'RECEIPT_DAY' 		,text:'결재기간' 	,type:'string'	}
					,{name: 'TAX_TYPE' 			,text:'세액포함여부',type:'string'	}
					,{name: 'VAT_RATE' 			,text:'세율' 		,type:'string'	}
					,{name: 'MONEY_UNIT' 		,text:'화폐' 		,type:'string'	}
					,{name: 'BILL_TYPE' 		,text:'계산서유형' 	,type:'string'	}
					,{name: 'SET_METH' 			,text:'결제방법' 	,type:'string'	}
					,{name: 'CUSTOM_FULL_NAME' 	,text:'거래처전명' 	,type:'string'	}
					,{name: 'TOP_NUM' 			,text:'주민등록번호',type:'string'	}
					,{name: 'BANK_CODE' 		,text:'금융기관' 	,type:'string'	}
					,{name: 'BANK_NAME' 		,text:'금융기관명' 	,type:'string'	}
					,{name: 'REMARK' 			,text:'비고' 		,type:'string'	}
					,{name: 'BANKBOOK_NUM' 		,text:'거래처계좌번호' 	,type:'string'}
					,{name: 'NATION_CODE' 		,text:'국가코드' 	,type:'string'}
					
					
			]
	});
	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('custPopupMasterStore',{
			model: 'CustPopupModel',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	read: 'popupService.custPopup'
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
        layout : {type : 'uniTable', columns : 2, tableAttrs: {
            style: {
                width: '100%'
            }
        }},
        items: [ { fieldLabel: '구분', 	name:'CUSTOM_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B015' }
    			 ,{ fieldLabel: '사업자번호', 	name:'COMPANY_NUM', id:'COMPANY_NUM', xtype: 'uniTextfield'}
    			 ,{ fieldLabel: '조회조건', 	name:'TXT_SEARCH', id:'TXT_SEARCH'}
    			 ,{ fieldLabel: '사업자구분', 
    			 	xtype: 'radiogroup', width: 230, id:'rdoRadio',
    			 	items:[	{inputValue: '1', boxLabel:'코드순', name: 'RDO', checked: t1},
    			 			{inputValue: '2', boxLabel:'이름순',  name: 'RDO', checked: t2} ]
    			 }			   
		        
		]
    });  
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
     var masterGrid = Unilite.createGrid('custPopupGrid', {
    	store: directMasterStore,
        columns:  [        
               		 { dataIndex: 'CUSTOM_CODE'		,width: 80  , locked:true}  
					,{ dataIndex: 'CUSTOM_NAME'		,width: 200 , locked:true} 
					,{ dataIndex: 'COMPANY_NUM'		,width: 120 } 
					,{ dataIndex: 'TOP_NAME'		,width: 80 }
					,{ dataIndex: 'BUSINESS_TYPE'	,width: 100 , hidden: true} 
					,{ dataIndex: 'COMP_CLASS'		,width: 100 , hidden: true} 
					,{ dataIndex: 'COMP_TYPE'		,width: 100 , hidden: true} 
					,{ dataIndex: 'ADDR1'			,width: 100 , hidden: true} 
					,{ dataIndex: 'ADDR2'			,width: 100 , hidden: true} 
					,{ dataIndex: 'TELEPHON'		,width: 100 , hidden: true} 
					,{ dataIndex: 'FAX_NUM'			,width: 100 , hidden: true} 
					,{ dataIndex: 'MAIL_ID'			,width: 100 , hidden: true} 
					,{ dataIndex: 'WON_CALC_BAS'	,width: 100 , hidden: true} 
					,{ dataIndex: 'TO_ADDRESS'		,width: 100 , hidden: true} 
					,{ dataIndex: 'TAX_CALC_TYPE'	,width: 100 , hidden: true} 
					,{ dataIndex: 'TRANS_CLOSE_DAY'	,width: 100 , hidden: true} 
					,{ dataIndex: 'RECEIPT_DAY'		,width: 100 , hidden: true} 
					,{ dataIndex: 'TAX_TYPE'		,width: 100 , hidden: true} 
					,{ dataIndex: 'VAT_RATE'		,width: 100 , hidden: true} 
					,{ dataIndex: 'MONEY_UNIT'		,width: 100 , hidden: true} 
					,{ dataIndex: 'BILL_TYPE'		,width: 100 , hidden: true} 
					,{ dataIndex: 'SET_METH'		,width: 100 , hidden: true} 
					,{ dataIndex: 'CUSTOM_FULL_NAME',width: 100 , hidden: true} 
					,{ dataIndex: 'TOP_NUM'			,width: 100 , hidden: true} 
					,{ dataIndex: 'BANK_CODE'		,width: 100 , hidden: true}
					,{ dataIndex: 'BANK_NAME'		,width: 100 , hidden: true}  
					,{ dataIndex: 'BANKBOOK_NUM'	,width: 100 , hidden: true} 
					,{ dataIndex: 'REMARK'			,width: 100 , flex:1 } 
			
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
		id  : 'custPopupApp',
		fnInitBinding : function() {
			var param = window.dialogArguments;
			var frm= Ext.getCmp('searchForm').getForm();
			
			var rdo = frm.findField('rdoRadio');
			var fieldTxt = frm.findField('TXT_SEARCH');
			var customType = frm.findField('CUSTOM_TYPE');
			var companyNum = frm.findField('COMPANY_NUM');

			if( Ext.isDefined(param)) {
				if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
					if(param['TYPE'] == 'VALUE') {
						fieldTxt.setValue(param['CUSTOM_CODE']);
						rdo.setValue('1');
					} else {
						fieldTxt.setValue(param['CUSTOM_NAME']);
						rdo.setValue('2');
					}
				}
				customType.setValue(param['CUSTOM_TYPE']);  
				companyNum.setValue(param['COMPANY_NUM']);	
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
