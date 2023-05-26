<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
/**
*	거래처(거래처분류조건포함)
*
*/
%>
<t:appConfig pgmId="crm.pop.CustPopup"  >
	<t:ExtComboStore comboType="AU" comboCode="B015" opts="1;3"/>	<!-- '거래처구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B016"/>				<!-- 사업자구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B055"/>				<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B056"/>				<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>				<!-- 영업담당 -->
	<t:ExtComboStore comboType="BOR120" />				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B010"/>				<!--  -->
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
					,{name: 'TOP_NAME' 			,text:'대표자' 		,type:'string'	 }
					,{name: 'BUSINESS_TYPE' 	,text:'사업자구분' 	,type:'string'	, comboType:'AU',comboCode:'B016'}
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
					
					,{name: 'AGENT_TYPE' 		,text:'거래처분류' 	,type:'string'	, comboType:'AU',comboCode:'B055'}
					,{name: 'AREA_TYPE' 		,text:'지역구분',type:'string'	, comboType:'AU',comboCode:'B056'}
					,{name: 'CREDIT_YN' 		,text:'여신관리여부' 	,type:'string'	}
					,{name: 'TOT_CREDIT_AMT' 	,text:'여신액' 	,type:'string'	}
					,{name: 'CREDIT_AMT' 		,text:'추가여신액' 		,type:'string'	}
					,{name: 'CREDIT_YMD' 		,text:'추가여신만기일' 	,type:'uniDate'}
					,{name: 'BUSI_PRSN' 		,text:'주영업담당자' 	,type:'string', comboType:'AU',comboCode:'S010'}
					,{name: 'COLLECTOR_CP' 		,text:'수금거래처' 	,type:'string'	}
					,{name: 'COLLECTOR_NM' 		,text:'수금거래처명' 		,type:'string'	}
					,{name: 'COLLECT_DAY' 		,text:'수금예정일' 	,type:'string'}
					,{name: 'COLLECT_CARE' 		,text:'미수관리방법' 	,type:'string'}
					,{name: 'REMARK' 			,text:'비고' 	,type:'string'	}
					,{name: 'TOP_NUM' 			,text:'대표자주민번호',type:'string'	}
					,{name: 'CREDIT_OVER_YN' 	,text:'여신초과여부' 	,type:'string'	}
					,{name: 'BILL_DIV_CODE' 	,text:'신고사업장' 	,type:'string'	}
					,{name: 'SERVANT_COMPANY_NUM' 	,text:'종사업장번호' 		,type:'string'	}

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
                	read: 'popupService.agentCustPopup'
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
        items: [ { fieldLabel: '구분', 	name:'CUSTOM_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B015' }
    			 ,{ fieldLabel: '사업자번호', 	name:'COMPANY_NUM', id:'COMPANY_NUM', xtype: 'uniTextfield' ,colspan:2}
    			 ,{ fieldLabel: '거래처분류', 	name:'AGENT_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B055' }
    			 ,{ fieldLabel: '지역구분', 	name:'AREA_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B056' }
    			 ,{  fieldLabel: '사용유무', 	name:'USE_YN',  xtype: 'uniRadiogroup', comboType:'AU',comboCode:'B010' , allowBlank:false, value:'Y', width:230}
    			 ,{ fieldLabel: '조회조건', 	name:'TXT_SEARCH', id:'TXT_SEARCH', colspan:2, width:518}
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
     var masterGrid = Unilite.createGrid('agentCustPopupGrid', {
    	store: directMasterStore,
    	uniOpt:{
    				 expandLastColumn: false
    				,useRowNumberer: false
        },
        columns:  [        
               		 { dataIndex: 'CUSTOM_CODE',  width: 100 }
					,{ dataIndex: 'CUSTOM_NAME',  width: 100 }
					,{ dataIndex: 'COMPANY_NUM',  width: 100 }
					,{ dataIndex: 'TOP_NAME',  width: 80 } 
					,{ dataIndex: 'BUSINESS_TYPE',  width: 100 } 
					,{ dataIndex: 'COMP_CLASS',  width: 100 } 
					,{ dataIndex: 'COMP_TYPE',  width: 100 } 
					,{ dataIndex: 'ADDR1',  width: 100 } 
					,{ dataIndex: 'ADDR2',  width: 100 } 
					,{ dataIndex: 'TELEPHON',  width: 100 } 
					,{ dataIndex: 'FAX_NUM',  width: 100 } 
					,{ dataIndex: 'MAIL_ID',  width: 100 } 
					,{ dataIndex: 'WON_CALC_BAS',  width: 100	} 
					,{ dataIndex: 'TO_ADDRESS',  width: 100	} 
					,{ dataIndex: 'TAX_CALC_TYPE',  width: 100 } 
					,{ dataIndex: 'TRANS_CLOSE_DAY',  width: 100	} 
					,{ dataIndex: 'RECEIPT_DAY',  width: 100	} 
					,{ dataIndex: 'TAX_TYPE',  width: 100	} 
					,{ dataIndex: 'VAT_RATE',  width: 100 } 
					,{ dataIndex: 'MONEY_UNIT',  width: 100 } 
					,{ dataIndex: 'BILL_TYPE',  width: 100	} 
					,{ dataIndex: 'SET_METH',  width: 100	} 
					,{ dataIndex: 'AGENT_TYPE',  width: 100	} 
					,{ dataIndex: 'AREA_TYPE',  width: 100	} 
					,{ dataIndex: 'CREDIT_YN',  width: 100	} 
					,{ dataIndex: 'TOT_CREDIT_AMT',  width: 100	} 
					,{ dataIndex: 'CREDIT_AMT',  width: 100	} 
					,{ dataIndex: 'CREDIT_YMD',  width: 100	} 
					,{ dataIndex: 'BUSI_PRSN',  width: 100	} 
					,{ dataIndex: 'COLLECTOR_CP',  width: 100	} 
					,{ dataIndex: 'COLLECTOR_NM',  width: 100	} 
					,{ dataIndex: 'COLLECT_DAY',  width: 100	} 
					,{ dataIndex: 'COLLECT_CARE',  width: 100	} 
					,{ dataIndex: 'REMARK',  width: 100	} 
					,{ dataIndex: 'TOP_NUM',  width: 100	} 
					,{ dataIndex: 'CREDIT_OVER_YN',  width: 100  } 
					,{ dataIndex: 'BILL_DIV_CODE',  width: 100  } 
					,{ dataIndex: 'SERVANT_COMPANY_NUM',  width: 100  } 
			
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
				panelSearch.setValues(param);
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
