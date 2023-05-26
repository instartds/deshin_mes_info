<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aba060ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!--사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A003" />	<!--매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A045" /> <!--기표구분-->
	<t:ExtComboStore comboType="AU" comboCode="A043" /> <!--수당/공제구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A140" /> <!--결제유형-->
	<t:ExtComboStore comboType="AU" comboCode="A066" /> <!--상여기준금/공제구분-->
	<t:ExtComboStore comboType="AU" comboCode="A059" /> <!--개인/회사구분-->
	<t:ExtComboStore comboType="AU" comboCode="A037" /> <!--구분-->
	<t:ExtComboStore comboType="AU" comboCode="B027" /> <!--제조판관구분-->
	<t:ExtComboStore comboType="AU" comboCode="A118" /> <!--소득구분-->
	<t:ExtComboStore comboType="AU" comboCode="A001" /> <!--차대계정-->
	<t:ExtComboStore comboType="AU" comboCode="A082" /> <!--해외 부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="B027" /> <!--제조판관구분(그리드용) -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
	<t:ExtComboStore comboType="AU" comboCode="B043" /> <!--국내/해외구분-->	
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!--고용형태-->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> <!--매출(부가세)유형-->
	<t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!--발주형태-->
	<t:ExtComboStore comboType="AU" comboCode="M302" /> <!--매입유형-->	
	<t:ExtComboStore comboType="AU" comboCode="T001" /> <!--무역구분-->
	<t:ExtComboStore comboType="AU" comboCode="T070" /> <!--수출진행구분-->
	<t:ExtComboStore comboType="AU" comboCode="T071" /> <!--수입진행구분-->
	<t:ExtComboStore comboType="AU" comboCode="T072" /> <!--지급유형-->
	<t:ExtComboStore comboType="AU" comboCode="T105" /> <!--배부대상여부-->
	

</t:appConfig>	
<style type= "text/css">
.x-grid-cell {
    border-left: 0px !important;
    border-right: 0px !important;
}
.x-tree-icon-leaf {
    background-image:none;
}
.search-hr {
	height: 1px;
	border: 0;
	color: #fff;
	background-color: #330;
	width: 98%;
}
.x-grid-item-focused  .x-grid-cell-inner:before {
    border: 0px; 
}
</style>
<script type="text/javascript" >

function appMain() {     
	
	/**
	 *   Model 정의 
	 * @type 
	 */	
	//aba060ukrs2 Model
	Unilite.defineModel('aba060ukrs2Model', {
	    fields: [{name: 'SALE_DIVI'			,text:'매입매출구분'			,type : 'string'},
				 {name: 'BUSI_TYPE'			,text:'거래구분'				,type : 'string'},
				 {name: 'CODE_NAME'			,text:'거래유형'				,type : 'string'},
				 {name: 'SLIP_DIVI'			,text:'차대구분'				,type : 'string'},
				 {name: 'ACCNT'				,text:'계정코드'				,type : 'string'},
				 {name: 'ACCNT_NM'			,text:'계정명'				,type : 'string'},
				 {name: 'UPDATE_DB_USER'	,text:'UPDATE_DB_USER'		,type : 'string'},
				 {name: 'UPDATE_DB_TIME'	,text:'UPDATE_DB_TIME'		,type : 'string'}
			]
	});	
	//aba060ukrs2 store
	var aba060ukrs2Store = Unilite.createStore('aba060ukrs2Store',{
			model: 'aba060ukrs2Model',
            autoLoad: true,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read : 'hum100ukrService.familyList'
                }
            }            
            
	});

	//aba060ukrs3 Model
	Unilite.defineModel('aba060ukrs3Model', {
	    fields: [{name: 'PAY_GUBUN'				,text:'고용형태'				,type : 'string'},
				 {name: 'DIVI'					,text:'기표구분'				,type : 'string'},
				 {name: 'ALLOW_TAG'   			,text:'수당/공제구분'			,type : 'string'},
				 {name: 'ALLOW_CODE'  			,text:'수당/공제코드'			,type : 'string'},
				 {name: 'ALLOW_NAME' 			,text:'수당/공제코드명'			,type : 'string'},
				 {name: 'SALE_DIVI'  			,text:'판관제조구분'			,type : 'string'},
				 {name: 'ACCNT'  				,text:'계정코드'				,type : 'string'},
				 {name: 'ACCNT_NAME' 			,text:'계정과목'				,type : 'string'},
				 {name: 'UPDATE_DB_USER'		,text:'UPDATE_DB_USER'		,type : 'string'},
				 {name: 'UPDATE_DB_TIME'		,text:'UPDATE_DB_TIME'		,type : 'string'},
				 {name: 'COMP_CODE'				,text:'COMP_CODE'			,type : 'string'}
				 
			]
	});	
	//aba060ukrs3 store
	var aba060ukrs3Store = Unilite.createStore('aba060ukrs3Store',{
			model: 'aba060ukrs3Model',
            autoLoad: true,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read : 'hum100ukrService.familyList'
                }
            }            
            
	});	//aba060ukrs4 Model
	Unilite.defineModel('aba060ukrs4Model', {
	    fields: [{name: 'COMP_CODE'			 	,text:'법인코드'				,type : 'string'},
				 {name: 'INCOM_TYPE'			,text:'소득구분'				,type : 'string'},
				 {name: 'ETC_INCOM_TYPE'		,text:'기타소득구분'			,type : 'string'},
				 {name: 'DR_CR'  		 		,text:'차대구분'				,type : 'string'},
				 {name: 'PAY_TYPE' 	     		,text:'지급구분'				,type : 'string'},
				 {name: 'ACCNT'          		,text:'계정코드'				,type : 'string'},
				 {name: 'ACCNT_NAME'     		,text:'계정명'				,type : 'string'},
				 {name: 'UPDATE_DB_USER' 		,text:'UPDATE_DB_USER'		,type : 'string'},
				 {name: 'UPDATE_DB_TIME' 		,text:'UPDATE_DB_TIME'		,type : 'string'}
				 	 
			]
	});	
	//aba060ukrs4 store
	var aba060ukrs4Store = Unilite.createStore('aba060ukrs4Store',{
			model: 'aba060ukrs4Model',
            autoLoad: true,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read : 'hum100ukrService.familyList'
                }
            }            
            
	});
	
		//aba060ukrs5 Model
	Unilite.defineModel('aba060ukrs5Model', {
	    fields: [{name: 'EXPORT_YN'				,text:'국내/해외구분'		,type : 'string'},
				 {name: 'SALE_TYPE'				,text:'SALE_TYPE'		,type : 'string'},
				 {name: 'SALE_NAME'				,text:'부가세유형'			,type : 'string'},
				 {name: 'DETAIL_TYPE'			,text:'출고유형'			,type : 'string'},
				 {name: 'DR_CR'  				,text:'차대구분'			,type : 'string'},
				 {name: 'ITEM_ACCNT' 			,text:'품목계정'			,type : 'string'},
				 {name: 'ACCNT'  				,text:'계정코드'			,type : 'string'},
				 {name: 'ACCNT_NAME' 			,text:'계정과목'			,type : 'string'}
				  
			]
	});	
		
	//aba060ukrs5 store
	var aba060ukrs5Store = Unilite.createStore('aba060ukrs5Store',{
			model: 'aba060ukrs5Model',
            autoLoad: true,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read : 'hum100ukrService.familyList'
                }
            }            
            
	});
	
		//aba060ukrs6 Model
	Unilite.defineModel('aba060ukrs6Model', {
	    fields: [{name: 'EXPORT_YN'			,text:'국내/해외구분'	,type : 'string'},
				 {name: 'COLLECT_TYPE'		,text:'수금유형'		,type : 'string'},
				 {name: 'DR_CR'  			,text:'차대구분'		,type : 'string'},
				 {name: 'ACCNT'  			,text:'계정코드'		,type : 'string'},
				 {name: 'ACCNT_NAME' 		,text:'계정과목'		,type : 'string'}
				 		 
			]
	});
	//aba060ukrs6 store
	var aba060ukrs6Store = Unilite.createStore('aba060ukrs6Store',{
			model: 'aba060ukrs6Model',
            autoLoad: true,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read : 'hum100ukrService.familyList'
                }
            }            
            
	});
	
		//aba060ukrs7 Model
	Unilite.defineModel('aba060ukrs7Model', {
	    fields: [{name: 'ORD_TYPE'				,text:'발주형태'		,type : 'string'},
				 {name: 'PURCHASE_TYPE'			,text:'매입유형'		,type : 'string'},
				 {name: 'ITEM_ACCNT'			,text:'차대구분'		,type : 'string'},
				 {name: 'DR_CR'  				,text:'품목계정'		,type : 'string'},
				 {name: 'ACCNT'  				,text:'계정코드'		,type : 'string'},
				 {name: 'ACCNT_NAME' 			,text:'계정과목'		,type : 'string'}
				 
		]			
	});
	
	//aba060ukrs7 store
	var aba060ukrs7Store = Unilite.createStore('aba060ukrs7Store',{
			model: 'aba060ukrs7Model',
            autoLoad: true,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read : 'hum100ukrService.familyList'
                }
            }
	});
	
		//aba060ukrs8 Model
	Unilite.defineModel('aba060ukrs8Model', {
	    fields: [{name: 'TRADE_DIV'					,text:'구분'			,type : 'string'},
				 {name: 'CHARGE_TYPE'				,text:'진행구분'		,type : 'string'},
				 {name: 'CHARGE_TYPE_NAME'			,text:'진행구분'		,type : 'string'},
				 {name: 'CHARGE_CODE'				,text:'경비'			,type : 'string'},
				 {name: 'CHARGE_NAME'				,text:'경비명'		,type : 'string'},
				 {name: 'PAY_TYPE'  				,text:'지급유형'		,type : 'string'},
				 {name: 'COST_DIV'					,text:'배부대상'		,type : 'string'},
				 {name: 'DR_CR'						,text:'차대구분'		,type : 'string'},
				 {name: 'ACCNT'  					,text:'계정코드'		,type : 'string'},
				 {name: 'ACCNT_NAME' 				,text:'계정과목'		,type : 'string'}				 
			]
	});
	
	//aba060ukrs8 store
	var aba060ukrs8Store = Unilite.createStore('aba060ukrs8Store',{
			model: 'aba060ukrs8Model',
            autoLoad: true,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read : 'hum100ukrService.familyList'
                }
            }            
            
	});
	
		//aba060ukrs9 Model
	Unilite.defineModel('aba060ukrs9Model', {
	    fields: [{name: 'COMP_CODE'	    	,text:'법인코드'		,type : 'string'},
				 {name: 'PAY_TYPE'			,text:'결제유형'		,type : 'string'},
				 {name: 'DR_CR'				,text:'차대구분'		,type : 'string'},
				 {name: 'ACCNT'				,text:'계정코드'		,type : 'string'},
				 {name: 'ACCNT_NAME'		,text:'계정명'		,type : 'string'},
				 {name: 'INSERT_DB_USER'	,text:'입력자'		,type : 'string'},
				 {name: 'INSERT_DB_TIME'	,text:'입력일'		,type : 'string'},
				 {name: 'UPDATE_DB_USER'	,text:'수정자'		,type : 'string'},
				 {name: 'UPDATE_DB_TIME'	,text:'수정일'		,type : 'string'}				  
		]
	});	

	//aba060ukrs9 store
	var aba060ukrs9Store = Unilite.createStore('aba060ukrs9Store',{
			model: 'aba060ukrs9Model',
            autoLoad: true,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },            
            proxy: {
                type: 'direct',
                api: {
                	   read : 'hum100ukrService.familyList'
                }
            }            
            
	});
	
		//aba060ukrs10 Model
	Unilite.defineModel('aba060ukrs10Model', {
	    fields: [{name: 'DEPT_DIVI'			,text:'구분'			,type : 'string'},				 
				 {name: 'ACCNT'  			,text:'계정코드'		,type : 'string'},				 
				 {name: 'ACCNT_NAME' 		,text:'계정과목'		,type : 'string'},				 
				 {name: 'DEP_ACCNT'  		,text:'상각비계정'		,type : 'string'},				 
				 {name: 'DEP_ACCNT_NAME'	,text:'상각비계정과목'	,type : 'string'},				 
				 {name: 'APP_ACCNT'  		,text:'누계액계정'		,type : 'string'},				 
				 {name: 'APP_ACCNT_NAME'	,text:'누계액계정과목'	,type : 'string'}			 
		]
	});
		
	//aba060ukrs10 store
	var aba060ukrs10Store = Unilite.createStore('aba060ukrs10Store',{
			model: 'aba060ukrs10Model',
            autoLoad: true,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read : 'hum100ukrService.familyList'
                }
            }            
            
	});
	
		//aba060ukrs11 Model
	Unilite.defineModel('aba060ukrs11Model', {
	    fields: [{name: 'COMP_CODE'			,text:'법인코드'		,type : 'string'},
				 {name: 'ITEM_ACCNT'		,text:'품목계정'		,type : 'string'},
				 {name: 'DR_CR'     		,text:'차대구분'		,type : 'string'},
				 {name: 'ACCNT'				,text:'계정코드'		,type : 'string'},
				 {name: 'ACCNT_NAME'		,text:'계정과목명'		,type : 'string'}				  
			]
	});			
	//aba060ukrs11 store
	var aba060ukrs11Store = Unilite.createStore('aba060ukrs11Store',{
			model: 'aba060ukrs11Model',
            autoLoad: true,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read : 'hum100ukrService.familyList'
                }
            } 
	});
	
    var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled:false,
	    items : [{ 
	    	xtype: 'grouptabpanel',
	    	activeGroup: 0,
	    	collapsible:true,
	    	items: [{
	    	 	defaults:{
					xtype:'uniDetailForm',
				    disabled:false,
				    border:0,
				    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
					margin: '10 10 10 10'
				},
				items:[
					<%@include file="./aba060ukrs1.jsp" %>	//회계기준설정
			    ]
	    	 }, {
	    	 	defaults:{
					xtype:'uniDetailForm',
				    disabled:false,
				    border:3,
				    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
					margin: '10 10 10 10'
				},
				items:[
					<%@include file="./aba060ukrs2.jsp" %>,	//매입매출전표
					<%@include file="./aba060ukrs3.jsp" %>, //급여/상여
					<%@include file="./aba060ukrs4.jsp" %>, //기타소득
					<%@include file="./aba060ukrs5.jsp" %>, //매출
					<%@include file="./aba060ukrs6.jsp" %>, //수금
					<%@include file="./aba060ukrs7.jsp" %>, //매입
					<%@include file="./aba060ukrs8.jsp" %>, //무역경비
					<%@include file="./aba060ukrs9.jsp" %>, //고정자산취득
					<%@include file="./aba060ukrs10.jsp" %>, //감가상각
					<%@include file="./aba060ukrs11.jsp" %>  //미착대체
			    ]
	    	 }, {
	    	 	defaults:{
					xtype:'uniDetailForm',
				    disabled:false,
				    border:0,
				    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
					margin: '10 10 10 10'
				},
				items:[
				    <%@include file="./aba060ukrs12.jsp" %>	//조회데이타포맷설정
			    ]
	    	 }]
	    }],
	    listeners: {
		       		beforetabchange: function ( grouptabPanel, newCard, oldCard, eOpts )	{
		       			if(Ext.isObject(oldCard))	{
			       			var personNum = oldCard.getValue('PERSON_NUMB');
			       			if(!Ext.isEmpty( personNum) )	{
				       			newCard.loadData(personNum);
								newCard.down('#EmpImg').setSrc(CPATH+'/resources/images/human/'+personNum+'.jpg');
			       			}
		       			}
		       		}
		       }
    })
	
    
	 Unilite.Main( {
		borderItems:[ 
			panelDetail		 	
		], 
		id : 'aba060ukrApp',
		fnInitBinding : function() {
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'aba060ukrGrid'){				
				directMasterStore1.loadStoreRecords();				
			}
			var viewLocked = tab.getActiveTab().lockedGrid.getView();
			var viewNormal = tab.getActiveTab().normalGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};


</script>
