<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:ExtComboStore comboType="AU" comboCode="CD46" />
<t:ExtComboStore comboType="AU" comboCode="CB23" />
<t:ExtComboStore comboType="AU" comboCode="CB46" />
<t:ExtComboStore comboType="AU" comboCode="CB47" />
<t:ExtComboStore comboType="AU" comboCode="B010" />

<script type="text/javascript" >
Ext.onReady(function() {

	/**
	 *   Model 정의 
	 * @type 
	 */
	Ext.define('Cmd100ukrvModel', {
	    extend: 'Ext.data.Model',
	    fields: [ 	 {name: 'DOC_NO'    			,text:'문서번호'	,type : 'string', allowBlank:false }                      
					,{name: 'PLAN_CUSTOM_CODE'    	,text:''			,type : 'string'	 }  
					,{name: 'PLAN_CUSTOM_NAME'    	,text:''			,type : 'string'	 }  
					,{name: 'PLAN_DVRY_CUST_SEQ'    ,text:''			,type : 'string'	 }  
					,{name: 'PLAN_DVRY_CUST_NM'    	,text:''			,type : 'string'	 }  
					,{name: 'PLAN_CLIENT'    		,text:'계획고객'	,type : 'string'	 }                      
					,{name: 'PLAN_CLIENT_NM'    	,text:''			,type : 'string'	 }
					,{name: 'PLAN_DATE'    			,text:'계획일자'	,type : 'date'	 }                      
					,{name: 'PLAN_TARGET'    		,text:'계획목적'	,type : 'string'	 }                              
					,{name: 'PLAN_GROUP_YN'    		,text:'계획 동반미팅 여부'	,type : 'string'	 }     
					
					,{name: 'RESULT_CLIENT'    		,text:'결과고객 ID'	,type : 'string', allowBlank:false 	 }                   
					,{name: 'RESULT_CLIENT_NM'    	,text:''			,type : 'string', allowBlank:false 	 }
					,{name: 'RESULT_DATE'    		,text:'결과일자'	,type : 'date'	 }                      
					,{name: 'CUSTOM_CODE'    		,text:'고객 업체'	,type : 'string'	 }
					,{name: 'CUSTOM_NAME'    		,text:''			,type : 'string'	 }
					,{name: 'DVRY_CUST_SEQ'    		,text:'배송처'		,type : 'string'	 }
					,{name: 'DVRY_CUST_NM'    		,text:''			,type : 'string'	 }
					,{name: 'PROCESS_TYPE'    		,text:'공정코드유형'	,type : 'string', allowBlank:false 	 }
					,{name: 'PROCESS_TYPE_NM'    	,text:''			,type : 'string', allowBlank:false	 }
					,{name: 'PROJECT_NO'    		,text:'공정코드'	,type : 'string'	 }  
					,{name: 'PROJECT_NO_NM'    		,text:''			,type : 'string'	 }
					,{name: 'SALE_EMP'    			,text:'영업 담당자'	,type : 'string'	 }                   
					,{name: 'SALE_ATTEND'    		,text:'영업 참석자'	,type : 'string'	 }                   
					,{name: 'SUMMARY_STR'    		,text:'현황 요약'	,type : 'string'	 }                     
					,{name: 'CONTENT_STR'    		,text:'결과 내용'	,type : 'string'	 }                     
					,{name: 'REQ_STR'    			,text:'요청사항'	,type : 'string'	 }                      
					,{name: 'OPINION_STR'    		,text:'소견'		,type : 'string'	 }                          
					,{name: 'KEYWORD'    			,text:'키워드'		,type : 'string'	 }                        
					,{name: 'REMARK'    			,text:'비고'		,type : 'string'	 }                          
					,{name: 'FILE_NO'    			,text:'첨부 파일 번호'	,type : 'string'	 }      
					,{name: 'CREATE_EMP'   			,text:'작성자'		,type : 'string'	 }      
					,{name: 'UPDATE_EMP'    		,text:'변경자'		,type : 'string'	 }    
					,{name: 'ITEM_CODE'    			,text:'현 사용제품코드'	,type : 'string'	 }
					,{name: 'ITEM_NAME'    			,text:'현 사용제품'	,type : 'string'	 }
					,{name: 'IMPORTANCE_STATUS'    	,text:''			,type : 'string'	 }
					,{name: 'SALE_TYPE'    			,text:'영업유형'	,type : 'string'	 }
	             ]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = new Ext.data.DirectStore({
			id : 'Cmd100ukrvStore', 
			model: 'Cmd100ukrvModel',
           	autoLoad: false,
        	autoSync: false,
           	proxy: {
               type: 'direct',
               api: {
               	read: 'cmd100ukrvService.select'
               }
            }
	        
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */		
		
	 var panelSearch = {
		xtype : 'uniSearchForm',
		id : 'searchForm',
		items : [  {fieldLabel: '거래처명', id:'CUSTOM_CODE',   name: 'DOC_NO'}
			      ,{fieldLabel: '고객명',    name: 'CLIENT_NAME', id:'TYPE'}
			      ,{fieldLabel: '일자',    name: 'DATE', id:'TYPE'}
			      ]
				
		};

	 
	var cmd100ukrvMasterGrid = Ext.create('Unilite.com.grid.UniGridPanel', {
    	store : directMasterStore,
		id : 'cmd100ukrvGrid',
        items: [
                   	             { dataIndex: 'DOC_NO',  width: 100   , text: '문서번호'	,  hidden: true}                     
								,{ dataIndex: 'PLAN_CUSTOM_CODE',  width: 100   , text: ''	, hidden: true}  
								,{ dataIndex: 'PLAN_CUSTOM_NAME',  width: 100   , text: '거래처'	 }  
								,{ dataIndex: 'PLAN_DVRY_CUST_SEQ',  width: 100   , text: ''	, hidden: true}  
								,{ dataIndex: 'PLAN_DVRY_CUST_NM',  width: 100   , text: '배송처'	 }  
								,{ dataIndex: 'PLAN_CLIENT',  width: 100   , text: '(계획)고객 ID'	, hidden: true}                      
								,{ dataIndex: 'PLAN_CLIENT_NM',  width: 60   , text: '(계획)고객명'	 }
								,{ dataIndex: 'PLAN_DATE',  width: 80   , text: '계획 일자'	}                      
								,{ dataIndex: 'PLAN_TARGET',  width: 250   , text: '계획목적'	 }                              
								,{ dataIndex: 'PLAN_GROUP_YN',  width: 100   , text: '동반미팅여부'	 }
					
								,{ dataIndex: 'RESULT_CLIENT',  width: 100   , text: '결과고객 ID'	, hidden: true}                   
								,{ dataIndex: 'RESULT_CLIENT_NM',  width: 60   , text: '고객'	 	 }
								,{ dataIndex: 'RESULT_DATE',  width: 80   , text: '실행일자'	}                      
								,{ dataIndex: 'CUSTOM_CODE',  width: 100   , text: '고객 업체'	, hidden: true}
								,{ dataIndex: 'CUSTOM_NAME',  width: 100   , text: '거래처'	 }
								,{ dataIndex: 'DVRY_CUST_SEQ',  width: 100   , text: ''	, hidden: true }
								,{ dataIndex: 'DVRY_CUST_NM',  width: 100   , text: '배송처'	 }
								,{ dataIndex: 'PROCESS_TYPE',  width: 100   , text: '상태 코드'		 , hidden: true }
								,{ dataIndex: 'PROCESS_TYPE_NM',  width: 80   , text: '상태'	 	 }
								,{ dataIndex: 'PROJECT_NO',  width: 100   , text: '영업기회번호'	 }  
								,{ dataIndex: 'PROJECT_NO_NM',  width: 200   , text: '영업기회'	 }
								,{ dataIndex: 'SALE_EMP',  width: 100   , text: '영업담당자'	 }                   
								,{ dataIndex: 'SALE_ATTEND',  width: 100   , text: '영업참석자'	 }                   
								,{ dataIndex: 'SUMMARY_STR',  width: 100   , text: '현황 요약'	 }                     
								,{ dataIndex: 'CONTENT_STR',  width: 250   , text: '결과 내용'	, hidden: true  }                     
								,{ dataIndex: 'OPINION_STR',  width: 250   , text: '소견'	, hidden: true  }                     
								
								,{ dataIndex: 'REQ_STR',  width: 200   , text: '요청사항'	 }                          
								,{ dataIndex: 'KEYWORD',  width: 100   , text: '키워드'	 }                        
								,{ dataIndex: 'REMARK',  width: 100   , text: '비고'	 }              
								,{ dataIndex: 'CREATE_EMP',  width: 100   , text: '작성자'	 }      
								,{ dataIndex: 'UPDATE_EMP',  width: 100   , text: '변경자'	 , hidden: true }    
								,{ dataIndex: 'ITEM_CODE',  width: 100   , text: ''	 , hidden: true }
								,{ dataIndex: 'ITEM_NAME',  width: 100   , text: ''	 , hidden: true }
								,{ dataIndex: 'IMPORTANCE_STATUS',  width: 100   , text: ''	, hidden: true  }
								
					
         		 ] 
    });

		
 	var app =  Ext.create('Unilite.com.BaseApp', {
		items : [panelSearch, 	cmd100ukrvDetail],
		id  : 'cmd100ukrvApp',
		fnInitBinding : function() {
			this.setToolbarButtons('reset',true);
		},
		onQueryButtonDown : function()	{
			Ext.getCmp('cmd100ukrvDetail').reset(true);
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			cmd100ukrvDetail.load({				 
				 params : param 				
			});
			
		}
	});

});

</script>