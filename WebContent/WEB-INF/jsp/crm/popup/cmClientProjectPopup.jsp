<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
/**
*	고객 영업기회 팝업
*
*/
%>
<t:appConfig pgmId="crm.pop.cmClientProjectPopup"  >
<t:ExtComboStore comboType="AU" comboCode="B010" />
<t:ExtComboStore comboType="AU" comboCode="CB24" />
</t:appConfig>
<script type="text/javascript" >
function appMain() {

	/**
	 *   Model 정의 
	 * @type 
	 */
	Ext.define('cmClientProjectPopupModel', {
	    extend: 'Ext.data.Model',
	    fields: [ 	 {name:'CLIENT_ID'				,text:'고객 ID' 		,type:'string'	}
					,{name:'CLIENT_NAME'			,text:'고객명' 			,type:'string'	}
					,{name:'TYPE'					,text:'영업기회여부' 	,type:'string'	, comboType:'AU', comboCode:'B010'}
					,{name:'PROJECT_OPT'			,text:'구분' 			,type:'string'	, comboType:'AU', comboCode:'CB24'}
					,{name:'CUSTOM_CODE'			,text:'고객거래처코드' 	,type:'string'	}
					,{name:'CUSTOM_NAME'			,text:'고객거래처명' 	,type:'string'	}
					,{name:'DVRY_CUST_SEQ'			,text:'배송처코드' 		,type:'string'	}
					,{name:'DVRY_CUST_NM'			,text:'배송처명' 		,type:'string'	}    
					,{name:'PROCESS_TYPE'			,text:'공정코드' 		,type:'string'	}       
					,{name:'PROCESS_TYPE_NM'		,text:'공정명' 			,type:'string'	}             
					,{name:'PROJECT_NO'				,text:'영업기회번호' 	,type:'string'	}     
					,{name:'PROJECT_NAME'			,text:'영업기회명' 		,type:'string'	}         
					,{name:'MOBILE_NO'				,text:'휴대폰번호'		,type:'string'	}           
					,{name:'CO_TEL_NO'				,text:'회사전화번호' 	,type:'string'	}     
					,{name:'RANK_NAME'				,text:'직급'			,type:'string'	}                 
					,{name:'DUTY_NAME'				,text:'직책' 			,type:'string'	}         
					,{name:'START_DATE'				,text:'시작일' 			,type:'string'	}       
					,{name:'TARGET_DATE'			,text:'완료목표일' 		,type:'string'	}         
					,{name:'PROJECT_TYPE'			,text:'구분' 			,type:'string'	}             
					,{name:'PROJECT_TYPE_NM'		,text:'구분' 			,type:'string'	}               
					,{name:'CLASS_LEVEL1'			,text:'유형분류(중)' 	,type:'string'	}               
					,{name:'CLASS_LEVEL1_NM'		,text:'유형분류(중)'	,type:'string'	}         
					,{name:'CLASS_LEVEL2'			,text:'유형분류(소)' 	,type:'string'	}     
		          	,{name:'CLASS_LEVEL2_NM'		,text:'유형분류(소)' 	,type:'string'	}       
			        ,{name:'SALE_EMP'				,text:'영업담당' 		,type:'string'	} 
			        ,{name:'DEVELOP_EMP'			,text:'개발담당' 		,type:'string'	}           
			        ,{name:'NATION_CODE'			,text:'업체국가' 		,type:'string'	}     
			        ,{name:'IMPORTANCE_STATUS'		,text:'중요도' 			,type:'string'	}     
			        ,{name:'IMPORTANCE_STATUS_NM'	,text:'중요도' 			,type:'string'	}         
			        ,{name:'PAD_STR'				,text:'경로' 			,type:'string'	}         
			        ,{name:'SLURRY_STR'				,text:'경쟁사' 			,type:'string'	}             
			        ,{name:'MONTH_QUANTITY'			,text:'예상규모' 		,type:'string'	}           
			        ,{name:'CURRENT_DD'				,text:'제품' 		,type:'string'	}       
			        ,{name:'EFFECT_STR'				,text:'효과' 			,type:'string'	}         
			        ,{name:'KEYWORD'				,text:'키워드' 			,type:'string'	}             
			        ,{name:'REMARK'					,text:'비고' 			,type:'string'	}              
			        ,{name:'ITEM_CODE'				,text:'제품코드'	,type:'string'	}                 
			        ,{name:'ITEM_NAME'				,text:'제품' 		,type:'string'	}   
			        ,{name:'EQUIP_TYPE'				,text:'장비코드'		,type:'string'	}           
			        ,{name:'EQUIP_TYPE_NM'			,text:'장비명' 			,type:'string'	}     
			        ,{name:'SALE_EMP_NM'			,text:'영업담당명' 		,type:'string'	}                  
			        ,{name:'DEVELOP_EMP_NM'			,text:'개발담당명' 		,type:'string'	}
			        ,{name: 'PURCHASE_AMT'			,text: '매입액'			,type: 'uniPrice'}
		        	,{name: 'MARGIN_AMT'			,text: '마진액'			,type: 'uniPrice'}
		        	,{name: 'MARGIN_RATE'			,text: '마진율'			,type: 'uniPercent' 	}
		        	,{name: 'SALES_PROJECTION'		,text: '확률'			,type: 'uniPercent' 	}
					
			]
	});
	
  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('cmClientProjectPupupMasterStore',{
			model: 'cmClientProjectPopupModel',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	read: 'cmPopupService.clientProjectList'
                }
            }
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var wParam = window.dialogArguments;
	var t1= false, t2 = true;
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
        width:'100%',
        items: [ { fieldLabel: '거래처명'		,name:'CUSTOM_TEXT'	}
    			 ,{ fieldLabel: '영업기회명'	,name:'PROJECT_TEXT'	}
    			 ,{ fieldLabel: '배송처명'		,name:'DVRY_CUST_TEXT'	, hidden : true}
    			 
    			 ,{ fieldLabel: '영업기회 여부'	,name:'PROJECT_YN' , id:'PROJECT_YN', 
    			 				 xtype : 'uniRadiogroup', comboType:'AU', comboCode:'B010', value:'Y', width:230, allowBlank:false}
    			 ,{ fieldLabel: '공정명'		,name:'PROCESS_TEXT'	, hidden : true}
    			 
    			 ,{
	            	xtype: 'container',
	            	defaultType: 'textfield',
	            	layout : 'anchor',
	            	width:300,
	            	items : [
				            	{ fieldLabel: '시작일자'
					               ,xtype: 'fieldcontainer'
					               ,layout: 'hbox'
					               ,defaults: {flex: 1, hideLabel: true}
					               ,items: [
					                     {fieldLabel: 'Start'	,name:'START_FR_DATE'	,xtype:'uniDatefield', margin: '0 5 0 0', value :''}
					                    ,{fieldLabel: 'End'		,name:'START_TO_DATE'	,xtype:'uniDatefield', value :'' }
					                ]		               
				            	 }
    			 ]}
    			 ,{ fieldLabel: '전화번호'		,name:'TEL_TEXT'	}
    			 ,{ fieldLabel: '영업기회 구분'	,name:'PROJECT_OPT' , 
    			 			xtype : 'uniRadiogroup', comboType:'AU', comboCode:'CB24', value:'2', width:230, allowBlank:false}
    			 ,{
	            	xtype: 'container',
	            	defaultType: 'textfield',
	            	layout : 'anchor',
	            	width:300,
	            	items : [
    			 
					            { fieldLabel: '종료일자'
					               ,xtype: 'fieldcontainer'
					               ,combineErrors: true
					               ,msgTarget : 'side'
					               ,layout: 'hbox'
					               ,defaults: { flex: 1, hideLabel: true}
					               ,items: [
					                     { fieldLabel: 'Start'	,name:'END_FR_DATE'	,xtype:'uniDatefield'	,margin: '0 5 0 0'	}
					                    ,{ fieldLabel: 'End'	,name:'END_TO_DATE'	,xtype:'uniDatefield'	}
					                ]}
					            ]
				 }
				,{ fieldLabel: '조회조건'		,name:'TXT_SEARCH', id:'TXT_SEARCH'	}	            
    			 ,{ fieldLabel: '조회구분', 
    			 	xtype: 'radiogroup', width: 230, id:'rdoRadio',
    			 	items:[	{inputValue: '1', boxLabel:'코드순', name: 'RDO', checked: t1 },
    			 			{inputValue: '2', boxLabel:'이름순',  name: 'RDO', checked: t2} ]
    			 }			   
		        
		]
    });  
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('cmClientProjectPopupGrid', {
    	store: directMasterStore,
        columns:  [        
               		 { dataIndex: 'CLIENT_ID'		,width: 90} 
					,{ dataIndex: 'CLIENT_NAME'		,width: 100 } 
			
					,{ dataIndex: 'TYPE'			,width: 90 } 
					,{ dataIndex: 'PROJECT_OPT'		,width: 90 } 
			
					,{ dataIndex: 'CUSTOM_CODE'		,width: 130 } 
					,{ dataIndex: 'CUSTOM_NAME'		,width: 110 } 
					,{ dataIndex: 'DVRY_CUST_SEQ'	,width: 80 ,hidden:true} 
					,{ dataIndex: 'DVRY_CUST_NM'	,width: 80 ,hidden:true} 
					,{ dataIndex: 'PROCESS_TYPE'	,width: 80 ,hidden:true} 
					,{ dataIndex: 'PROCESS_TYPE_NM'	,width: 80 ,hidden:true} 
					,{ dataIndex: 'PROJECT_NO'		,width: 100 } 
					,{ dataIndex: 'PROJECT_NAME'	,width: 150 } 
					,{ dataIndex: 'MOBILE_NO'		,width: 90 ,hidden:true} 
					,{ dataIndex: 'CO_TEL_NO'		,width: 90 ,hidden:true} 
					,{ dataIndex: 'RANK_NAME'		,width: 80 ,hidden:true} 
					,{ dataIndex: 'DUTY_NAME'		,width: 80 ,hidden:true} 
					,{ dataIndex: 'START_DATE'		,width: 80 ,hidden:true} 
					,{ dataIndex: 'TARGET_DATE'		,width: 80 ,hidden:true} 
					,{ dataIndex: 'PROJECT_TYPE'	,width: 60 ,hidden:true} 
					,{ dataIndex: 'PROJECT_TYPE_NM'	,width: 90 ,hidden:true} 
					,{ dataIndex: 'CLASS_LEVEL1'	,width: 80 ,hidden:true} 
					,{ dataIndex: 'CLASS_LEVEL1_NM'	,width: 90 ,hidden:true} 
					,{ dataIndex: 'CLASS_LEVEL2'	,width: 80 ,hidden:true} 
					,{ dataIndex: 'CLASS_LEVEL2_NM'	,width: 90 ,hidden:true} 
					,{ dataIndex: 'SALE_EMP'		,width: 80 ,hidden:true} 
					,{ dataIndex: 'DEVELOP_EMP'		,width: 80 ,hidden:true} 
					,{ dataIndex: 'NATION_CODE'		,width: 80 ,hidden:true} 
					,{ dataIndex: 'IMPORTANCE_STATUS'		,width: 80 ,hidden:true} 
					,{ dataIndex: 'IMPORTANCE_STATUS_NM'	,width: 80 ,hidden:true} 
					,{ dataIndex: 'PAD_STR'			,width: 80,hidden:true} 
					,{ dataIndex: 'SLURRY_STR'		,width: 80 ,hidden:true} 
					,{ dataIndex: 'MONTH_QUANTITY'	,width: 80 ,hidden:true} 
					,{ dataIndex: 'CURRENT_DD'		,width: 80 ,hidden:true} 
					,{ dataIndex: 'EFFECT_STR'		,width: 80 ,hidden:true} 
					,{ dataIndex: 'KEYWORD'			,width: 80 ,hidden:true} 
					,{ dataIndex: 'ITEM_CODE'		,width: 120 ,hidden:true} 
					,{ dataIndex: 'ITEM_NAME'		,width: 120,hidden:true} 
					,{ dataIndex: 'EQUIP_TYPE'		,width: 100,hidden:true} 
					,{ dataIndex: 'EQUIP_TYPE_NM'	,width: 110	,hidden:true} 
			
					,{ dataIndex: 'SALE_EMP_NM'		,width: 100	} 
					,{ dataIndex: 'DEVELOP_EMP_NM'		,width: 100	} 
					,{ dataIndex: 'REMARK'			,width: 100 , flex:1 } 
			
          ] ,
          listeners: {
          	onGridDblClick:function(grid, record, cellIndex, colName) {
	          	var rv = {
					status : "OK",
					data:[record.raw]
				};
				window.returnValue = rv;
				window.close();
	          }
          } //listeners
    });
    
    
 	    Unilite.PopupMain({
		items : [panelSearch, 	masterGrid],
		id  : 'cmClientProjectsApp',
		fnInitBinding : function() {
			var param = window.dialogArguments;
			var frm= Ext.getCmp('searchForm');
			//var fieldTxt = frm.findField('PROJECT_TEXT')
			//var rdo = frm.findField('rdoRadio');
			//var txtSearch = frm.findField('TXT_SEARCH');
			
			//if( Ext.isDefined(param)) {
			//	if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
					if(param['TYPE'] == 'VALUE') {
						frm.setValue('PROJECT_TEXT', param['PROJECT_NO']);						
						frm.setValue('TXT_SEARCH', param['CLIENT_ID']);
					}  else if(param['TYPE'] == 'TEXT') { 
						frm.setValue('PROJECT_TEXT', param['PROJECT_NAME']);	
						frm.setValue('TXT_SEARCH', param['CLIENT_NAME']);
					}
					
					
				//}
				frm.setValue('PROJECT_YN','Y');
				//frm.child('PROJECT_YN').setValue({PROJECT_YN:'Y'});
				//frm.findField('PROJECT_YN').setValue([false,true]);
			//}
			
			this._dataLoad();
		},
		 onQueryButtonDown : function()	{
			this._dataLoad();
		},
		_dataLoad : function() {
			var me = this;
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			me.isLoading = true;
			masterGrid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
		}
	});

};


</script>
