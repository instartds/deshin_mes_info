<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="aba060ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!--사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A001" /> <!--차대계정-->
	<t:ExtComboStore comboType="AU" comboCode="A003" />	<!--매입매출구분 -->
	<t:ExtComboStore comboType="A" comboCode="A012" /> <!--거래유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A037" /> <!--구분-->
	<t:ExtComboStore comboType="AU" comboCode="A043" /> <!--수당/공제구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A045" /> <!--기표구분-->
	<t:ExtComboStore comboType="AU" comboCode="A059" /> <!--개인/회사구분-->
	<t:ExtComboStore comboType="AU" comboCode="A066" /> <!--상여기준금/공제구분-->
	<t:ExtComboStore comboType="A"  comboCode="A082" /> <!--해외 부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="A118" /> <!--소득구분-->
	<t:ExtComboStore comboType="AU" comboCode="A140" /> <!--결제유형-->
	<t:ExtComboStore comboType="AU" comboCode="A215" /> <!--이익손실구분-->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
	<t:ExtComboStore comboType="AU" comboCode="B027" /> <!--제조판관구분-->
	<t:ExtComboStore comboType="AU" comboCode="B027" /> <!--제조판관구분(그리드용) -->
	<t:ExtComboStore comboType="AU" comboCode="B043" /> <!--국내/해외구분-->	
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!--고용형태-->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!--발주형태-->
	<t:ExtComboStore comboType="AU" comboCode="M302" /> <!--매입유형-->
	<t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
	<t:ExtComboStore comboType="A"  comboCode="S024" /> <!--매출(부가세)유형-->	
	<t:ExtComboStore comboType="AU" comboCode="T001" /> <!--무역구분-->
	<t:ExtComboStore comboType="AU" comboCode="T070" /> <!--수출진행구분-->
	<t:ExtComboStore comboType="AU" comboCode="T071" /> <!--수입진행구분-->
	<t:ExtComboStore comboType="AU" comboCode="T072" /> <!--지급유형-->
	<t:ExtComboStore comboType="AU" comboCode="T105" /> <!--배부대상여부-->
	<t:ExtComboStore items="${AC_ITEM_COMBO}" storeId="acItemCombo" /><!--품목계정/매입-->
	<t:ExtComboStore items="${AC_ITEM_COMBO2}" storeId="acItemCombo2" /><!--품목계정/매출-->
	

</t:appConfig>	
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {     
	
	/*var aba060ukrvStore2 = Unilite.createStore('aba060ukrsComboStore',{
		storeId: 'aba060ukrvCombo2',
        fields:[
        	'value',
        	'text'
        ],
        data:[
        	{'value':'00' , text:'상품'},
        	{'value':'10' , text:'제품'},
        	{'value':'20' , text:'반제품'},
        	{'value':'40' , text:'원자재'},
        	{'value':'52' , text:'미착품'},
        	{'value':'53' , text:'렌탈'},        	
        	{'value':'50' , text:'부자재'},
        	{'value':'54' , text:'오퍼'},
        	{'value':'55' , text:'비품'},        	
        	{'value':'56' , text:'태양광전기'},
        	{'value':'Z0' , text:'부가세'}
        ]
	});*/
	
	/*
	 * accntTree060.htm 연결되 있음 
	 * "aba100UKR" '"회계기준설정" 
	 * "aga100UKR" '"매입매출전표"
	 * "aga110UKR" '"급여/상여" 
	 * "aga230UKR" '"기타소득" 
	 * "aga120UKR" '"매출" 
	 * "aga125UKR" '"매출(일집계)" 
	 * "aga130UKR" '"수금" 
	 * "aga140UKR" '"매입" 
	 * "aga220UKR" '"무역경비"
	 * "aga320UKR" '"자산취득" 
	 * "aga210UKR" '"감가상각" 
	 * "aga250UKR" '"미착대체"
	 * "신규추가"	   '"외화환산자동기표방법등록"
	 */
	
	var getStDt = ${getStDt};
	var getChargeCode = ${getChargeCode};

	 Unilite.defineModel('aba060ukrsExportYnfKindModel', {
		// pkGen : user, system(default)
	    fields: [ 
	    	 	 {name: 'value'    			,text:'value'			,type : 'string'} 
	    	 	 ,{name: 'text'    			,text:'text'			,type : 'string'}
	    	 	 ,{name: 'option'    		,text:'option'			,type : 'string'}
	    	 	 ,{name: 'search'    		,text:'search'			,type : 'string'}
	    	 	 ,{name: 'refCode1'    		,text:'refCode1'		,type : 'string'}
	    	 	 ,{name: 'refCode2'    		,text:'refCode2'		,type : 'string'}
	    	 	 ,{name: 'refCode3'    		,text:'refCode3'		,type : 'string'}

	    	 	 ]
	 });
	var ExportYnKindStore = Unilite.createStore('aba060ukrsExportYnfKindStore',{
		model:'aba060ukrsExportYnfKindModel',
        proxy: {
           type: 'direct',
            api: {			
                read: 'aba060ukrsService.getExportYnKind'                	
            }
        },     
        loadStoreRecords: function() {
			var param= panelDetail.down('#tab_SellForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		gridRoadStoreRecords: function(param) {
			
			var grid = panelDetail.down('#aba060ukrs5Grid');
			var record = grid.uniOpt.currentRecord;
			this.load({
				params : param
			});
		}
	});
	
	/* 무역 수출/수입 */
	var TradeDivKindStore = Unilite.createStore('aba060ukrsTradeDivKindStore',{
        proxy: {
           type: 'direct',
            api: {			
                read: 'aba060ukrsService.getTradeDivKind'
            }
        },
        loadStoreRecords: function() {
			var param= panelDetail.down('#tab_Trading_CostForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		gridRoadStoreRecords: function(param) {
			this.load({
				params : param
			});
		}
	});
	
	/* 매입매출구분 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba060ukrsService.selectList2',
				create 	: 'aba060ukrsService.insertDetail2',
				update 	: 'aba060ukrsService.updateDetail2',
				destroy	: 'aba060ukrsService.deleteDetail2',
				syncAll	: 'aba060ukrsService.saveAll2'
			}
	 });
	 
	 
	 /* 급여/상여 */
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba060ukrsService.selectList3',
				create 	: 'aba060ukrsService.insertDetail3',
				update 	: 'aba060ukrsService.updateDetail3',
				destroy	: 'aba060ukrsService.deleteDetail3',
				syncAll	: 'aba060ukrsService.saveAll3'
			}
	 });
	 
	 /* 기타소득 */
	 var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba060ukrsService.selectList4',
				create 	: 'aba060ukrsService.insertDetail4',
				update 	: 'aba060ukrsService.updateDetail4',
				destroy	: 'aba060ukrsService.deleteDetail4',
				syncAll	: 'aba060ukrsService.saveAll4'
			}
	 });
	 
	 /* 매출 */
	 var directProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba060ukrsService.selectList5',
				create 	: 'aba060ukrsService.insertDetail5',
				update 	: 'aba060ukrsService.updateDetail5',
				destroy	: 'aba060ukrsService.deleteDetail5',
				syncAll	: 'aba060ukrsService.saveAll5'
			}
	 });
	 
	 /* 수금 */
	 var directProxy6 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba060ukrsService.selectList6',
				create 	: 'aba060ukrsService.insertDetail6',
				update 	: 'aba060ukrsService.updateDetail6',
				destroy	: 'aba060ukrsService.deleteDetail6',
				syncAll	: 'aba060ukrsService.saveAll6'
			}
	 });
	 
	 /* 매입 */
	 var directProxy7 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba060ukrsService.selectList7',
				create 	: 'aba060ukrsService.insertDetail7',
				update 	: 'aba060ukrsService.updateDetail7',
				destroy	: 'aba060ukrsService.deleteDetail7',
				syncAll	: 'aba060ukrsService.saveAll7'
			}
	 });
	 
	 /* 무역경비 */
	 var directProxy8 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba060ukrsService.selectList8',
				create 	: 'aba060ukrsService.insertDetail8',
				update 	: 'aba060ukrsService.updateDetail8',
				destroy	: 'aba060ukrsService.deleteDetail8',
				syncAll	: 'aba060ukrsService.saveAll8'
			}
	 });
	 
	 /* 고정자산취득 */
	 var directProxy9 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba060ukrsService.selectList9',
				create 	: 'aba060ukrsService.insertDetail9',
				update 	: 'aba060ukrsService.updateDetail9',
				destroy	: 'aba060ukrsService.deleteDetail9',
				syncAll	: 'aba060ukrsService.saveAll9'
			}
	 });
	 
	 /* 감가상각 */
	 var directProxy10 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba060ukrsService.selectList10',
				create 	: 'aba060ukrsService.insertDetail10',
				update 	: 'aba060ukrsService.updateDetail10',
				destroy	: 'aba060ukrsService.deleteDetail10',
				syncAll	: 'aba060ukrsService.saveAll10'
			}
	 });
	 
	 /* 미착대체 */
	 var directProxy11 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba060ukrsService.selectList11',
				create 	: 'aba060ukrsService.insertDetail11',
				update 	: 'aba060ukrsService.updateDetail11',
				destroy	: 'aba060ukrsService.deleteDetail11',
				syncAll	: 'aba060ukrsService.saveAll11'
			}
	 });
	 
	 /* 외화환산자동기표방법등록 (aba060ukrs13.jsp) */
	 var directProxy12 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba060ukrsService.selectList12',
				create 	: 'aba060ukrsService.insertDetail12',
				update 	: 'aba060ukrsService.updateDetail12',
				destroy	: 'aba060ukrsService.deleteDetail12',
				syncAll	: 'aba060ukrsService.saveAll12'
			}
	 });
	 
	 
	 
	 var aba060ukrvStore = Ext.create('Ext.data.Store',{
		storeId: 'aba060ukrvCombo',
        fields:[
        	'value',
        	'text'
        ],
        data:[
        	{'value':'0' , text:'0'},
        	{'value':'1' , text:'0.9'},
        	{'value':'2' , text:'0.99'},
        	{'value':'3' , text:'0.999'},
        	{'value':'4' , text:'0.9999'},
        	{'value':'5' , text:'0.99999'},        	
        	{'value':'6' , text:'0.999999'}
        ]
	});
	 
	
	/**
	 * Model 정의
	 * 
	 * @type
	 */	
	// aba060ukrs2 Model
	Unilite.defineModel('aba060ukrs2Model', {
	    fields: [{name: 'SALE_DIVI'			,text:'매입매출구분'			,type : 'string' ,comboType:"A", comboCode:"A003" , allowBlank: false},
				 {name: 'BUSI_TYPE'			,text:'거래유형'				,type : 'string' ,comboType:"A", comboCode:"A012" , allowBlank: false},
				 {name: 'SLIP_DIVI'			,text:'차대구분'				,type : 'string' ,comboType:"A", comboCode:"A001" , allowBlank: false},
				 {name: 'ACCNT'				,text:'계정코드'				,type : 'string', allowBlank: false},
				 {name: 'ACCNT_NAME'		,text:'계정명'				,type : 'string'},
				 {name: 'DEPT_CODE' 		,text:'부서코드'				,type : 'string'},			//A2
				 {name: 'DEPT_NAME' 		,text:'부서명'				,type : 'string'},			//A2
				 {name: 'P_ACCNT'			,text:'상대계정'				,type : 'string'},
				 {name: 'ITEM_CODE'			,text:'제품코드'				,type : 'string'},			//B1
				 {name: 'ITEM_NAME'			,text:'제품명'				,type : 'string'},			//B1
				 {name: 'PERSON_NUMB'		,text:'사번'					,type : 'string'},			//A6
				 {name: 'NAME'				,text:'사원명'				,type : 'string'},			//A6
				 {name: 'BANK_CODE'			,text:'은행코드'				,type : 'string'},			//A3
				 {name: 'BANK_NAME'			,text:'은행명'				,type : 'string'},			//A3
				 {name: 'SAVE_CODE'			,text:'통장번호'				,type : 'string'},			//O1
				 {name: 'SAVE_NAME'			,text:'통장명'				,type : 'string'},			//O1
				 {name: 'BIZ_GUBUN'			,text:'수입구분'				,type : 'string'},			//E3
				 {name: 'BIZ_GUBUN_NAME'	,text:'수입구분명'				,type : 'string'},			//E3
				 {name: 'PJT_CODE'			,text:'사업코드'				,type : 'string'},			//E1
				 {name: 'PJT_NAME'			,text:'사업명'				,type : 'string'},			//E1
				 {name: 'UPDATE_DB_USER'	,text:'UPDATE_DB_USER'		,type : 'string'},
				 {name: 'UPDATE_DB_TIME'	,text:'UPDATE_DB_TIME'		,type : 'string'},
				 {name: 'COMP_CODE'			,text:'법인코드'				,type : 'string'}
			]
	});	
	// aba060ukrs2 store
	var aba060ukrs2Store = Unilite.createStore('aba060ukrs2Store',{
			model: 'aba060ukrs2Model',
	        autoLoad: false,
	        uniOpt : {
	        	isMaster: true,			// 상위 버튼 연결
	        	editable: true,			// 수정 모드 사용
	        	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
	        },
	        
	        proxy: directProxy2,

	        saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					this.syncAll();			 //syncAllDirect		
				}else {
					panelDetail.down('#aba060ukrs2Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
	        loadStoreRecords : function(){
	        	var param1 = Ext.getCmp('SALE_DIVI2').getValue();
				var param= { SALE_DIVI : param1};    	
		        this.load({
		           params: param
		        });
		    } 
	});

	// aba060ukrs3 Model
	Unilite.defineModel('aba060ukrs3Model', {
	    fields: [{name: 'PAY_GUBUN'				,text:'고용형태'				,type : 'string' ,comboType:"AU", comboCode:"H011" , allowBlank: false},
				 {name: 'DIVI'					,text:'기표구분'				,type : 'string' ,comboType:"AU", comboCode:"A045"},
				 {name: 'ALLOW_TAG_A043'   		,text:'수당/공제구분'			,type : 'string' ,comboType:"AU", comboCode:"A043" /*, allowBlank: false*/},
				 {name: 'ALLOW_TAG_A066'   		,text:'수당/공제구분'			,type : 'string' ,comboType:"AU", comboCode:"A066" /*, allowBlank: false*/},
				 {name: 'ALLOW_CODE'  			,text:'수당/공제코드'			,type : 'string' , allowBlank: false},
				 {name: 'ALLOW_NAME' 			,text:'수당/공제코드명'			,type : 'string'},
				 {name: 'SALE_DIVI'  			,text:'판관제조구분'			,type : 'string' ,comboType:"AU", comboCode:"B027" , allowBlank: false},
				 {name: 'ACCNT'  				,text:'계정코드'				,type : 'string' , allowBlank: false},
				 {name: 'ACCNT_NAME' 			,text:'계정과목'				,type : 'string'},
				 {name: 'UPDATE_DB_USER'		,text:'UPDATE_DB_USER'		,type : 'string'},
				 {name: 'UPDATE_DB_TIME'		,text:'UPDATE_DB_TIME'		,type : 'string'},
				 {name: 'COMP_CODE'				,text:'COMP_CODE'			,type : 'string'}
				 
			]
	});	
	// aba060ukrs3 store
	var aba060ukrs3Store = Unilite.createStore('aba060ukrs3Store',{
			model: 'aba060ukrs3Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy3,    
            
            saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();

				if(inValidRecs.length == 0 )	{
					this.syncAll();			 //syncAllDirect		
				}else {
					panelDetail.down('#aba060ukrs3Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
	        loadStoreRecords : function(){
	        	var param1 = Ext.getCmp('DIVI3').getValue();
            	var param2 = Ext.getCmp('SALE_DIVI3').getValue();
            	var param= { DIVI : param1, SALE_DIVI : param2};    
		        this.load({
		           params: param
		        });
		    }  
	});	
	
	// aba060ukrs4 Model
	Unilite.defineModel('aba060ukrs4Model', {
	    fields: [{name: 'COMP_CODE'			 	,text:'법인코드'				,type : 'string'},
				 {name: 'INCOM_TYPE'			,text:'소득구분'				,type : 'string' ,comboType:"A", comboCode:"A118" , allowBlank: false},
				 {name: 'ETC_INCOM_TYPE'		,text:'계정구분'				,type : 'string' ,comboType:"A", comboCode:"HS15" , allowBlank: false},
				 {name: 'DR_CR'  		 		,text:'차대구분'				,type : 'string' ,comboType:"A", comboCode:"A001" , allowBlank: false},
				 {name: 'PAY_TYPE' 	     		,text:'지급구분'				,type : 'string' ,comboType:"A", comboCode:"A097" , allowBlank: false},
				 {name: 'ACCNT'          		,text:'계정코드'				,type : 'string' , allowBlank: false},
				 {name: 'ACCNT_NAME'     		,text:'계정명'				,type : 'string'},
				 {name: 'UPDATE_DB_USER' 		,text:'UPDATE_DB_USER'		,type : 'string'},
				 {name: 'UPDATE_DB_TIME' 		,text:'UPDATE_DB_TIME'		,type : 'string'}
				 	 
			]
	});	
	// aba060ukrs4 store
	var aba060ukrs4Store = Unilite.createStore('aba060ukrs4Store',{
			model: 'aba060ukrs4Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy4,
            
            saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					this.syncAll();			 //syncAllDirect		
				}else {
					panelDetail.down('#aba060ukrs4Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
	        loadStoreRecords : function(){
	        	var param1 = Ext.getCmp('INCOM_TYPE4').getValue();
            	var param= { INCOM_TYPE : param1};    
		        this.load({
		           params: param
		        });       
		     }
	});
	
	// aba060ukrs5 Model
	Unilite.defineModel('aba060ukrs5Model', {
	    fields: [{name: 'EXPORT_YN'				,text:'국내/해외구분'		,type : 'string' , allowBlank: false ,comboType:"AU", comboCode:"B043"},
				 {name: 'SALE_TYPE'				,text:'부가세유형'			,type : 'string' , store: Ext.data.StoreManager.lookup('aba060ukrsExportYnfKindStore')},
				
				 {name: 'SALE_TYPE_S024'		,text:'국내부가세유형'			,type : 'string' ,comboType:"A", comboCode:"S024"},
				 {name: 'SALE_TYPE_A082'		,text:'해외부가세유형'			,type : 'string' ,comboType:"A", comboCode:"A082"},
				 
				 {name: 'DETAIL_TYPE'			,text:'출고유형'			,type : 'string' ,comboType:"A", comboCode:"S007"},
				 {name: 'DR_CR'  				,text:'차대구분'			,type : 'string' , allowBlank: false ,comboType:"A", comboCode:"A001"},
				 {name: 'ITEM_ACCNT' 			,text:'품목계정'			,type : 'string' , allowBlank: false ,/*comboType:"A", comboCode:"B020"*/ store: Ext.data.StoreManager.lookup('acItemCombo2')},
				 {name: 'ACCNT'  				,text:'계정코드'			,type : 'string' , allowBlank: false},
				 {name: 'ACCNT_NAME' 			,text:'계정과목'			,type : 'string'},
				 {name: 'COMP_CODE'				,text:'법인코드'			,type : 'string'}
				  
			]
	});	
		
	// aba060ukrs5 store
	var aba060ukrs5Store = Unilite.createStore('aba060ukrs5Store',{
			model: 'aba060ukrs5Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy5,
            
            saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					this.syncAll();			 //syncAllDirect		
				}else {
					panelDetail.down('#aba060ukrs5Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
	        loadStoreRecords : function(){
	        	var param1 = Ext.getCmp('EXPORT_YN5').getValue();
	        	var param2 = Ext.getCmp('SALE_TYPE5').getValue();
            	var param= { EXPORT_YN : param1 , SALE_TYPE : param2};    
		        this.load({
		           params: param
		        });  
		     }
	});
	
	// aba060ukrs6 Model
	Unilite.defineModel('aba060ukrs6Model', {
	    fields: [{name: 'EXPORT_YN'			,text:'국내/해외구분'	,type : 'string' , allowBlank: false ,comboType:"A", comboCode:"B043"},
				 {name: 'COLLECT_TYPE'		,text:'수금유형'		,type : 'string' , allowBlank: false ,comboType:"A", comboCode:"S017"},
				 {name: 'DR_CR'  			,text:'차대구분'		,type : 'string' , allowBlank: false ,comboType:"A", comboCode:"A001"},
				 {name: 'ACCNT'  			,text:'계정코드'		,type : 'string' , allowBlank: false},
				 {name: 'ACCNT_NAME' 		,text:'계정과목'		,type : 'string'},
				 {name: 'COMP_CODE'			,text:'법인코드'				,type : 'string'}
				 		 
			]
	});
	// aba060ukrs6 store
	var aba060ukrs6Store = Unilite.createStore('aba060ukrs6Store',{
			model: 'aba060ukrs6Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy6,
            
            saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					this.syncAll();			 //syncAllDirect		
				}else {
					panelDetail.down('#aba060ukrs6Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
	        loadStoreRecords : function(){
	        	var param1 = Ext.getCmp('EXPORT_YN6').getValue();
	        	var param2 = Ext.getCmp('SALE_DIVI6').getValue();
            	var param= { EXPORT_YN : param1 , SALE_DIVI : param2};    
		        this.load({
		           params: param
		        });   
		     }
	});
	
	// aba060ukrs7 Model
	Unilite.defineModel('aba060ukrs7Model', {
	    fields: [{name: 'ORD_TYPE'				,text:'발주형태'		,type : 'string' , allowBlank: false ,comboType:"AU", comboCode:"M001"},
				 {name: 'PURCHASE_TYPE'			,text:'매입유형'		,type : 'string' , allowBlank: false ,comboType:"AU", comboCode:"M302"},
				 {name: 'DR_CR'					,text:'차대구분'		,type : 'string' , allowBlank: false ,comboType:"AU", comboCode:"A001"},
				 {name: 'ITEM_ACCNT'  			,text:'품목계정'		,type : 'string' , allowBlank: false ,/*comboType:"AU", comboCode:"B020",*/store: Ext.data.StoreManager.lookup('acItemCombo')},
				 {name: 'ACCNT'  				,text:'계정코드'		,type : 'string' , allowBlank: false},
				 {name: 'ACCNT_NAME' 			,text:'계정과목'		,type : 'string'},
				 {name: 'COMP_CODE'				,text:'법인코드'		,type : 'string'}
				 
		]			
	});
	
	// aba060ukrs7 store
	var aba060ukrs7Store = Unilite.createStore('aba060ukrs7Store',{
			model: 'aba060ukrs7Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy7,
            
            saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					this.syncAll();			 //syncAllDirect		
				}else {
					panelDetail.down('#aba060ukrs7Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
	        loadStoreRecords : function(){
	        	var param1 = Ext.getCmp('ORDER_TYPE7').getValue();
	        	var param2 = Ext.getCmp('PURCHASE_TYPE7').getValue();
            	var param= { ORDER_TYPE : param1 , PURCHASE_TYPE : param2};    
		        this.load({
		           params: param
		        });   
		     }
	});
	
	// aba060ukrs8 Model
	Unilite.defineModel('aba060ukrs8Model', {
	    fields: [{name: 'TRADE_DIV'					,text:'구분'			,type : 'string' , allowBlank: false ,comboType:"AU", comboCode:"T001"},
				 {name: 'CHARGE_TYPE_E'				,text:'수출진행구분'	,type : 'string' , allowBlank: false ,comboType:"AU", comboCode:"T070"},
				 {name: 'CHARGE_TYPE_I'				,text:'수입진행구분'	,type : 'string' , allowBlank: false ,comboType:"AU", comboCode:"T071"},
				 {name: 'CHARGE_CODE'				,text:'경비'			,type : 'string' , allowBlank: false },
				 {name: 'CHARGE_NAME'				,text:'경비명'		,type : 'string'},
				 {name: 'PAY_TYPE'  				,text:'지급유형'		,type : 'string' , allowBlank: false ,comboType:"AU", comboCode:"T072"},
				 {name: 'COST_DIV'					,text:'배부대상'		,type : 'string' , allowBlank: false ,comboType:"AU", comboCode:"T105"},
				 {name: 'DR_CR'						,text:'차대구분'		,type : 'string' , allowBlank: false ,comboType:"AU", comboCode:"A001"},
				 {name: 'ACCNT'  					,text:'계정코드'		,type : 'string' , allowBlank: false },
				 {name: 'ACCNT_NAME' 				,text:'계정과목'		,type : 'string'},
				 {name: 'COMP_CODE' 				,text:'법인코드'		,type : 'string'}	
			]
	});
	
	// aba060ukrs8 store
	var aba060ukrs8Store = Unilite.createStore('aba060ukrs8Store',{
			model: 'aba060ukrs8Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy8,

            saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					this.syncAll();			 //syncAllDirect		
				}else {
					panelDetail.down('#aba060ukrs8Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
	        loadStoreRecords : function(){
	        	var param1 = Ext.getCmp('TRADE_DIV8').getValue();
	        	var param2 = Ext.getCmp('CHARGE_TYPE8').getValue();
            	var param= { TRADE_DIV : param1 , CHARGE_TYPE : param2};    
		        this.load({
		           params: param
		        });   
		     }
	});
	
	// aba060ukrs9 Model
	Unilite.defineModel('aba060ukrs9Model', {
	    fields: [{name: 'COMP_CODE'	    	,text:'법인코드'		,type : 'string'},
				 {name: 'PAY_TYPE'			,text:'결제유형'		,type : 'string' ,comboType:"AU", comboCode:"A140" , allowBlank: false},
				 {name: 'DR_CR'				,text:'차대구분'		,type : 'string' ,comboType:"AU", comboCode:"A001" , allowBlank: false},
				 {name: 'ACCNT'				,text:'계정코드'		,type : 'string' , allowBlank: false},
				 {name: 'ACCNT_NAME'		,text:'계정명'		,type : 'string'}			  
		]
	});	

	// aba060ukrs9 store
	var aba060ukrs9Store = Unilite.createStore('aba060ukrs9Store',{
			model: 'aba060ukrs9Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy9,
            
            saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					this.syncAll();			 //syncAllDirect		
				}else {
					panelDetail.down('#aba060ukrs9Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
	        loadStoreRecords : function(){
	        	var param1 = Ext.getCmp('PAY_TYPE9').getValue();
            	var param= { PAY_TYPE : param1};    
		        this.load({
		           params: param
		        });   
		     }
	});
	
		// aba060ukrs10 Model
	Unilite.defineModel('aba060ukrs10Model', {
	    fields: [{name: 'DEPT_DIVI'			,text:'구분'			,type : 'string' , allowBlank: false ,comboType:"AU", comboCode:"A037"},				 
				 {name: 'ACCNT'  			,text:'계정코드'		,type : 'string' , allowBlank: false},				 
				 {name: 'ACCNT_NAME' 		,text:'계정과목'		,type : 'string'},				 
				 {name: 'DEP_ACCNT'  		,text:'상각비계정'		,type : 'string' , allowBlank: false},				 
				 {name: 'DEP_ACCNT_NAME'	,text:'상각비계정과목'	,type : 'string'},				 
				 {name: 'APP_ACCNT'  		,text:'누계액계정'		,type : 'string' , allowBlank: false},				 
				 {name: 'APP_ACCNT_NAME'	,text:'누계액계정과목'	,type : 'string'},
				 {name: 'COMP_CODE'			,text:'법인코드'		,type : 'string'}
		]
	});
		
	// aba060ukrs10 store
	var aba060ukrs10Store = Unilite.createStore('aba060ukrs10Store',{
			model: 'aba060ukrs10Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy10,
            
            saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					this.syncAll();			 //syncAllDirect		
				}else {
					panelDetail.down('#aba060ukrs10Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
	        loadStoreRecords : function(){
	        	var param1 = Ext.getCmp('DEPT_DIVI10').getValue();
            	var param= { DEPT_DIVI : param1};    
		        this.load({
		           params: param
		        });   
		     }        
	});
	
	// aba060ukrs11 Model
	Unilite.defineModel('aba060ukrs11Model', {
	    fields: [{name: 'COMP_CODE'			,text:'법인코드'		,type : 'string'},
				 {name: 'ITEM_ACCNT'		,text:'품목계정'		,type : 'string' , allowBlank: false ,comboType:"AU", comboCode:"B020"},
				 {name: 'DR_CR'     		,text:'차대구분'		,type : 'string' , allowBlank: false ,comboType:"AU", comboCode:"A001"},
				 {name: 'ACCNT'				,text:'계정코드'		,type : 'string' , allowBlank: false},
				 {name: 'ACCNT_NAME'		,text:'계정과목명'		,type : 'string'}				  
			]
	});			
	// aba060ukrs11 store
	var aba060ukrs11Store = Unilite.createStore('aba060ukrs11Store',{
			model: 'aba060ukrs11Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy11,
            
            saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					this.syncAll();			 //syncAllDirect		
				}else {
					panelDetail.down('#aba060ukrs11Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},      
            loadStoreRecords : function(){
		        var param =  panelDetail.down('#tab_Alternative_Transit').getValues();
		         this.load({
		            params: param
		         });
		     }  
	});
	
	// aba060ukrs12 Model (외화환산자동기표방법등록 (aba060ukrs13.jsp))
	Unilite.defineModel('aba060ukrs12Model', {
	    fields: [{name: 'ACCNT'			,text:'외화계정코드'	,type : 'string'	, allowBlank: false},
				 {name: 'ACCNT_NAME'	,text:'외화계정과목명'	,type : 'string'},
				 {name: 'GUBUN'     	,text:'구분'			,type : 'string'	, allowBlank: false	 , comboType:"AU", comboCode:"A215"},
				 {name: 'EXG_ACCNT'		,text:'환산계정코드'	,type : 'string'	, allowBlank: false},
				 {name: 'EXG_NAME'		,text:'환산계정과목명'	,type : 'string'}				  
			]
	});			
	// aba060ukrs12 store (외화환산자동기표방법등록 (aba060ukrs13.jsp))
	var aba060ukrs12Store = Unilite.createStore('aba060ukrs12Store',{
		model: 'aba060ukrs12Model',
        autoLoad: false,
        uniOpt : {
        	isMaster	: true,			// 상위 버튼 연결
        	editable	: true,			// 수정 모드 사용
        	deletable	: true,			// 삭제 가능 여부
            useNavi		: false			// prev | next 버튼 사용
        },
        proxy: directProxy12,
        
        saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				this.syncAll();			 //syncAllDirect		
			}else {
				panelDetail.down('#aba060ukrs12Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},      
        loadStoreRecords : function(){
	        var param =  panelDetail.down('#tab_ForeignCurrency_Transit').getValues();
	         this.load({
	            params: param
	         });
	     }  
	});
	
    var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout	: 'fit',
        region	: 'center',
        disabled:false,
	    items	: [{ 
	    	xtype: 'grouptabpanel',
	    	itemId: 'aba060Tab',
	    	activeGroup: 0,
	    	collapsible:true,
	    	items: [{
	    	 	defaults:{
					xtype:'uniDetailForm',
				    disabled:false,
				    border:3,
				    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
					margin: '10 10 10 10'
				},
				items:[
					{
						title:'자동기표방법등록',
						itemId: 'tabTitle01',
						border: false						
					},
					<%@include file="./aba060ukrs2.jsp" %>,	// 매입매출전표
					<%@include file="./aba060ukrs3.jsp" %>, // 급여/상여
					<%@include file="./aba060ukrs4.jsp" %>, // 기타소득
					<%@include file="./aba060ukrs5.jsp" %>, // 매출
					<%@include file="./aba060ukrs6.jsp" %>, // 수금
					<%@include file="./aba060ukrs7.jsp" %>, // 매입
					<%@include file="./aba060ukrs8.jsp" %>, // 무역경비
					<%@include file="./aba060ukrs9.jsp" %>, // 고정자산취득
					<%@include file="./aba060ukrs10.jsp" %>, // 감가상각
					<%@include file="./aba060ukrs11.jsp" %>,  // 미착대체
					<%@include file="./aba060ukrs13.jsp" %>  // 외화환산자동기표
			    ]
	    	 }]
	    	 ,listeners:{
	    	 	tabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{
		    		//var btnRtun = false;
		    		if(Ext.isObject(oldCard))	{
		    			 if(UniAppManager.app._needSave())	{
		    			 	/*Ext.Msg.show({
								title:'확인',
								message: Msg.sMB017 + "\n" + Msg.sMB061,
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(btn) {
									var old = oldCard;
									var newcd = newCard;
									
									
									if (btn === 'yes' ) {
							    		UniAppManager.app.onSaveDataButtonDown();			// *old false *new true
							    		
							    		
										 grouptabPanel.setActiveTab(old);
							    		 btnRtun = true;
								   }else if (btn === 'no') {
										UniAppManager.app.fnInitBinding();
										UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
										
										
										//cancel
										
										UniAppManager.app.loadTabData(newCard, newCard.getItemId());
										btnRtun = false;
								   }else {
								   	   btnRtun = false;
						           } 
							    }
							});*/
		    			 	
		    			 	if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
								UniAppManager.app.onSaveDataButtonDown();
								this.setActiveTab(oldCard);
							}else {
								UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
								UniAppManager.app.loadTabData(newCard, newCard.getItemId());	
							}
		    			 }
		    			 
		    			 else {
	    					 if (newCard.itemId == 'tabTitle01') {
		    					 console.log('tab title clicked! do nothing');
		    					 return false;
	    					 }
	    					 else if(newCard.itemId == 'tab_format'){
	    					 	UniAppManager.setToolbarButtons(['reset', 'excel', 'delete', 'newData'],false);
	    					 }
	    					 else{    			 	
		    			 		UniAppManager.app.fnInitBinding();
		    			 		UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
		    			 	 	UniAppManager.app.loadTabData(newCard, newCard.getItemId());
	    					 }	 	 	
		    			 }
		    		}
		    		//return btnRtun;
		    	},
		    	beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{    		
		    		//var btnRtun = false;
		    		if(Ext.isObject(oldCard))	{
		    			 if(UniAppManager.app._needSave())	{
		    			 	/*Ext.Msg.show({
								title:'확인',
								message: Msg.sMB017 + "\n" + Msg.sMB061,
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(btn) {
									var old = oldCard;
									var newcd = newCard;
									
									
									if (btn === 'yes' ) {
							    		UniAppManager.app.onSaveDataButtonDown();			// *old false *new true
							    		
							    		
										 grouptabPanel.setActiveTab(old);
							    		 btnRtun = true;
								   }else if (btn === 'no') {
										UniAppManager.app.fnInitBinding();
										UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
										
										
										//cancel
										
										UniAppManager.app.loadTabData(newCard, newCard.getItemId());
										btnRtun = false;
								   }else {
								   	   btnRtun = false;
						           } 
							    }
							});*/
		    			 	
		    			 	if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
								UniAppManager.app.onSaveDataButtonDown();
								this.setActiveTab(oldCard);
							}else {
								UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
								UniAppManager.app.loadTabData(newCard, newCard.getItemId());	
							}
		    			 }
		    			 
		    			 else {
	    					 if (newCard.itemId == 'tabTitle01') {
		    					 console.log('tab title clicked! do nothing');
		    					 return false;
	    					 }
	    					 else if(newCard.itemId == 'tab_format'){
	    					 	UniAppManager.setToolbarButtons(['reset', 'excel', 'delete', 'newData'],false);
	    					 }
	    					 else{    			 	
		    			 		UniAppManager.app.fnInitBinding();
		    			 		UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
		    			 	 	UniAppManager.app.loadTabData(newCard, newCard.getItemId());
	    					 }	 	 	
		    			 }
		    		}
		    		//return btnRtun;
		    	}
		    }
	    }]
    });
	
    
	 Unilite.Main( {
		borderItems:[ 
			panelDetail		 	
		], 
		id : 'aba060ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'excel', 'delete'],false);
			UniAppManager.setToolbarButtons(['query' ,'newData'],true);
			
			var activeTab = panelDetail.down('#aba060Tab').getActiveTab();
		},
		checkForNewDetail3:function() { 			
			return panelDetail.down('#tab_payForm').setAllFieldsReadOnly(true);
        },
        checkForNewDetail4:function() { 			
			return panelDetail.down('#tab_Other_IncomeForm').setAllFieldsReadOnly(true);
        },
		checkForNewDetail5:function() { 			
			return panelDetail.down('#tab_SellForm').setAllFieldsReadOnly(true);
		},
		checkForNewDetail6:function() { 			
			return panelDetail.down('#tab_collectionForm').setAllFieldsReadOnly(true);
		},
		checkForNewDetail8:function() { 			
			return panelDetail.down('#tab_Trading_CostForm').setAllFieldsReadOnly(true);
		},
		
		onQueryButtonDown : function()	{	
			var activeTab = panelDetail.down('#aba060Tab').getActiveTab();
			/* 회계기준설정일 경우 기본 데이터 세팅  */
			if (activeTab.getItemId() == 'tab_aba100ukr'){
				var param= panelDetail.down('#tab_aba100ukr').getValues();
				panelDetail.down('#tab_aba100ukr').getForm().load({
					params: param
				})	
				UniAppManager.setToolbarButtons(['reset', 'newData', 'excel', 'delete'],false);
				UniAppManager.setToolbarButtons(['query'],true);
			}
			/*
			 * this.loadTabData(activeTab, activeTab.getItemId(),
			 * activeTab.getSubCode())
			 */
			
			
			/* 매입 매출전표 조회 */
			if (activeTab.getItemId() == 'tab_inoutSlip'){
				UniAppManager.setToolbarButtons(['reset', 'newData', 'delete','query'],true);
				if(!Ext.getCmp('formInoutSlip').getInvalidMessage()){
					return false;
				}
				aba060ukrs2Store.loadStoreRecords();
			}
			
			/* 급여 / 상여 조회 */
			else if (activeTab.getItemId() == 'tab_pay'){
				if(!UniAppManager.app.checkForNewDetail3()) {
					return false;
				}else{
					panelDetail.down('#tab_payForm').getField('DIVI').setReadOnly(true);
					
					if(panelDetail.down('#tab_payForm').getValue('DIVI') == 1 ){
						panelDetail.down('#aba060ukrs3Grid').getColumn('ALLOW_TAG_A043').setVisible(true);
			 			panelDetail.down('#aba060ukrs3Grid').getColumn('ALLOW_TAG_A066').setVisible(false);
					}
			 		else{
			 			panelDetail.down('#aba060ukrs3Grid').getColumn('ALLOW_TAG_A043').setVisible(false);
			 			panelDetail.down('#aba060ukrs3Grid').getColumn('ALLOW_TAG_A066').setVisible(true);
			 		}
					
					UniAppManager.setToolbarButtons(['reset', 'newData', 'delete','query'],true);
					aba060ukrs3Store.loadStoreRecords();
				}
			}
			
			/* 기타소득 */
			else if (activeTab.getItemId() == 'tab_Other_Income'){
				if(!UniAppManager.app.checkForNewDetail4()) {
					return false;
				}else{
					UniAppManager.setToolbarButtons(['reset', 'newData', 'delete','query'],true);
					aba060ukrs4Store.loadStoreRecords();
				}
			}
			
			/* 매출 */
			else if (activeTab.getItemId() == 'tab_Sell'){
				if(!UniAppManager.app.checkForNewDetail5()) {
					return false;
				}else{
					panelDetail.down('#tab_SellForm').getField('EXPORT_YN').setReadOnly(true);
					
					if(panelDetail.down('#tab_SellForm').getValue('EXPORT_YN') == 1 ){
						panelDetail.down('#aba060ukrs5Grid').getColumn('SALE_TYPE_S024').setVisible(true);
			 			panelDetail.down('#aba060ukrs5Grid').getColumn('SALE_TYPE_A082').setVisible(false);
					}
			 		else{
			 			panelDetail.down('#aba060ukrs5Grid').getColumn('SALE_TYPE_S024').setVisible(false);
			 			panelDetail.down('#aba060ukrs5Grid').getColumn('SALE_TYPE_A082').setVisible(true);
			 		}
					
					UniAppManager.setToolbarButtons(['reset', 'newData', 'delete','query'],true);
					aba060ukrs5Store.loadStoreRecords();
				}
					//ExportYnKindStore.gridRoadStoreRecords(param);			/////
			}
			
			/* 수금 */
			else if (activeTab.getItemId() == 'tab_collection'){
				if(!UniAppManager.app.checkForNewDetail6()) {
					return false;
				}else{
					UniAppManager.setToolbarButtons(['reset', 'newData', 'delete','query'],true);
					aba060ukrs6Store.loadStoreRecords();
				}
			}
			
			/* 매입 */
			else if (activeTab.getItemId() == 'tab_buy'){
				UniAppManager.setToolbarButtons(['reset', 'newData', 'delete','query'],true);
				aba060ukrs7Store.loadStoreRecords();
			}
			
			/* 무역경비 */
			else if (activeTab.getItemId() == 'tab_Trading_Cost'){
				if(!UniAppManager.app.checkForNewDetail8()) {
					return false;
				}else{
					panelDetail.down('#tab_Trading_CostForm').getField('TRADE_DIV').setReadOnly(true);
					
					if(panelDetail.down('#tab_Trading_CostForm').getValue('TRADE_DIV') == 'E' ){
						panelDetail.down('#aba060ukrs8Grid').getColumn('CHARGE_TYPE_E').setVisible(true);
			 			panelDetail.down('#aba060ukrs8Grid').getColumn('CHARGE_TYPE_I').setVisible(false);
					}
			 		else{
			 			panelDetail.down('#aba060ukrs8Grid').getColumn('CHARGE_TYPE_E').setVisible(false);
			 			panelDetail.down('#aba060ukrs8Grid').getColumn('CHARGE_TYPE_I').setVisible(true);
			 		}
					
					UniAppManager.setToolbarButtons(['reset', 'newData', 'delete','query'],true);
					aba060ukrs8Store.loadStoreRecords();
				}
			}
			
			/* 고정자산취득 */
			else if (activeTab.getItemId() == 'tab_Acquisition_Assets'){
				UniAppManager.setToolbarButtons(['reset', 'newData', 'delete','query'],true);
				aba060ukrs9Store.loadStoreRecords();
			}
			
			/* 감가상각 */
			else if (activeTab.getItemId() == 'tab_Depreciation'){
				UniAppManager.setToolbarButtons(['reset', 'newData', 'delete','query'],true);
				aba060ukrs10Store.loadStoreRecords();
			}
			
			/* 미착대체 */
			else if (activeTab.getItemId() == 'tab_Alternative_Transit'){
				UniAppManager.setToolbarButtons(['reset', 'newData', 'delete','query'],true);
				aba060ukrs11Store.loadStoreRecords();
			}
			
			/* 외화환산자동기표방법등록 (aba060ukrs13.jsp) */
			else if (activeTab.getItemId() == 'tab_ForeignCurrency_Transit'){
				UniAppManager.setToolbarButtons(['reset', 'newData', 'delete','query'],true);
				aba060ukrs12Store.loadStoreRecords();
			}
			
			/* */
			else if(activeTab.getItemId() == "tab_format"){
				UniAppManager.setToolbarButtons(['newData', 'delete'],false);
				var param= panelDetail.down('#tab_format').getValues();
				panelDetail.down('#tab_format').getForm().load({
					
					params: param
				})
			}
		},
		
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		
		
		onNewDataButtonDown : function()	{
			var activeTab = panelDetail.down('#aba060Tab').getActiveTab();
			
			/* 매입 매출전표 추가 */
			if(activeTab.getId() == 'tab_inoutSlip'){
				var param =  panelDetail.down('#tab_inoutSlipForm').getValues();
				var compCode = UserInfo.compCode
				var r = {
					COMP_CODE : compCode
				}
				panelDetail.down('#aba060ukrs2Grid').createRow(r , 'SALE_DIVI');
				
				UniAppManager.setToolbarButtons(['reset'],true);
			}	
			/* 급여 / 상여 추가 */
			else if(activeTab.getId() == 'tab_pay'){
				
				if(!UniAppManager.app.checkForNewDetail3()) {
					return false;
					
				}else{
					panelDetail.down('#tab_payForm').getField('DIVI').setReadOnly(true);
					
					if(panelDetail.down('#tab_payForm').getValue('DIVI') == 1 ){
						panelDetail.down('#aba060ukrs3Grid').getColumn('ALLOW_TAG_A043').setVisible(true);
			 			panelDetail.down('#aba060ukrs3Grid').getColumn('ALLOW_TAG_A066').setVisible(false);
//					 	panelDetail.down('#aba060ukrs3Grid').getColumn('ALLOW_TAG_A043').setConfig('allowBank', false);
//					 	panelDetail.down('#aba060ukrs3Grid').getColumn('ALLOW_TAG_A066').setConfig('allowBank', true);
					}
			 		else{
			 			panelDetail.down('#aba060ukrs3Grid').getColumn('ALLOW_TAG_A043').setVisible(false);
			 			panelDetail.down('#aba060ukrs3Grid').getColumn('ALLOW_TAG_A066').setVisible(true);
//					 	panelDetail.down('#aba060ukrs3Grid').getColumn('ALLOW_TAG_A043').setConfig('allowBank', true);
//					 	panelDetail.down('#aba060ukrs3Grid').getColumn('ALLOW_TAG_A066').setConfig('allowBank', false);
			 		}

				
					var param =  panelDetail.down('#tab_payForm').getValues();
					var compCode = UserInfo.compCode
					var divi     = param.DIVI
					var r = {
						COMP_CODE : compCode,
						DIVI      : divi
					}
					panelDetail.down('#aba060ukrs3Grid').createRow(r , 'PAY_GUBUN');
					
					UniAppManager.setToolbarButtons(['reset'],true);
				}
			}
			
			/* 기타소득 추가 */
			else if(activeTab.getId() == 'tab_Other_Income'){
				var param =  panelDetail.down('#tab_Other_IncomeForm').getValues();
				var compCode = UserInfo.compCode
				var r = {
					COMP_CODE : compCode
				}
				panelDetail.down('#aba060ukrs4Grid').createRow(r ,'INCOM_TYPE');
				
				UniAppManager.setToolbarButtons(['reset'],true);
			}
			
			
			/* 매출 추가 */
			else if(activeTab.getId() == 'tab_Sell'){
				
				if(!UniAppManager.app.checkForNewDetail5()) {
					return false;
					
				}else{
					panelDetail.down('#tab_SellForm').getField('EXPORT_YN').setReadOnly(true);
					
					if(panelDetail.down('#tab_SellForm').getValue('EXPORT_YN') == 1 ){
						panelDetail.down('#aba060ukrs5Grid').getColumn('SALE_TYPE_S024').setVisible(true);
			 			panelDetail.down('#aba060ukrs5Grid').getColumn('SALE_TYPE_A082').setVisible(false); 
			 			
			 			var param =  panelDetail.down('#tab_SellForm').getValues();
						var compCode = UserInfo.compCode
						var r = {
							COMP_CODE : compCode,
							EXPORT_YN : param.EXPORT_YN
						}
						panelDetail.down('#aba060ukrs5Grid').createRow(r ,'SALE_TYPE_S024');
					}
			 		else{
			 			panelDetail.down('#aba060ukrs5Grid').getColumn('SALE_TYPE_S024').setVisible(false);
			 			panelDetail.down('#aba060ukrs5Grid').getColumn('SALE_TYPE_A082').setVisible(true);
			 			
			 			var param =  panelDetail.down('#tab_SellForm').getValues();
						var compCode = UserInfo.compCode
						var r = {
							COMP_CODE : compCode,
							EXPORT_YN : param.EXPORT_YN
						}
						panelDetail.down('#aba060ukrs5Grid').createRow(r ,'SALE_TYPE_A082');
			 		}
					
					UniAppManager.setToolbarButtons(['reset'],true);
				}
			}
			
			/* 수금 추가 */
			else if(activeTab.getId() == 'tab_collection'){
				var param =  panelDetail.down('#tab_collectionForm').getValues();
				var compCode = UserInfo.compCode
				var r = {
					COMP_CODE : compCode
				}
				panelDetail.down('#aba060ukrs6Grid').createRow(r ,'EXPORT_YN');
				
				UniAppManager.setToolbarButtons(['reset'],true);
			}
			
			/* 매입 추가 */
			else if(activeTab.getId() == 'tab_buy'){
				var param =  panelDetail.down('#tab_buyForm').getValues();
				var compCode = UserInfo.compCode
				var r = {
					COMP_CODE : compCode
				}
				panelDetail.down('#aba060ukrs7Grid').createRow(r ,'ORD_TYPE');
				
				UniAppManager.setToolbarButtons(['reset'],true);
			}
			
			/* 무역경비 추가 */
			else if(activeTab.getId() == 'tab_Trading_Cost'){
				
				if(!UniAppManager.app.checkForNewDetail8()) {
					return false;
					
				}else{
					panelDetail.down('#tab_Trading_CostForm').getField('TRADE_DIV').setReadOnly(true);
					
					if(panelDetail.down('#tab_Trading_CostForm').getValue('TRADE_DIV') == 'E'){
						panelDetail.down('#aba060ukrs8Grid').getColumn('CHARGE_TYPE_E').setVisible(true);
			 			panelDetail.down('#aba060ukrs8Grid').getColumn('CHARGE_TYPE_I').setVisible(false);
			 			
			 			var param =  panelDetail.down('#tab_Trading_CostForm').getValues();
						var compCode = UserInfo.compCode
						var r = {
							COMP_CODE : compCode,
							TRADE_DIV : param.TRADE_DIV
						}
						panelDetail.down('#aba060ukrs8Grid').createRow(r ,'CHARGE_TYPE_E');
					}
			 		else{
			 			panelDetail.down('#aba060ukrs8Grid').getColumn('CHARGE_TYPE_E').setVisible(false);
			 			panelDetail.down('#aba060ukrs8Grid').getColumn('CHARGE_TYPE_I').setVisible(true);
			 			
			 			var param =  panelDetail.down('#tab_Trading_CostForm').getValues();
						var compCode = UserInfo.compCode
						var r = {
							COMP_CODE : compCode,
							TRADE_DIV : param.TRADE_DIV
						}
						panelDetail.down('#aba060ukrs8Grid').createRow(r ,'CHARGE_TYPE_I');
			 		}
					UniAppManager.setToolbarButtons(['reset'],true);
				}
			}
			
			/* 고정자산취득 추가 */
			else if(activeTab.getId() == 'tab_Acquisition_Assets'){
				var param =  panelDetail.down('#tab_Acquisition_AssetsForm').getValues();
				var compCode = UserInfo.compCode
				var r = {
					COMP_CODE : compCode
				}
				panelDetail.down('#aba060ukrs9Grid').createRow(r ,'PAY_TYPE');
				
				UniAppManager.setToolbarButtons(['reset'],true);
			}
			
			/* 감가상각 추가 */
			else if(activeTab.getId() == 'tab_Depreciation'){
				var param =  panelDetail.down('#tab_DepreciationForm').getValues();
				var compCode = UserInfo.compCode
				var r = {
					COMP_CODE : compCode
				}
				panelDetail.down('#aba060ukrs10Grid').createRow(r ,'DEPT_DIVI');
				
				UniAppManager.setToolbarButtons(['reset'],true);
			}
			
			/* 미착대체 추가 */
			else if(activeTab.getId() == 'tab_Alternative_Transit'){
				var param =  panelDetail.down('#tab_Alternative_Transit').getValues();
				var compCode = UserInfo.compCode
				var r = {
					COMP_CODE : compCode
				}
				panelDetail.down('#aba060ukrs11Grid').createRow(r ,'ITEM_ACCNT');
				
				UniAppManager.setToolbarButtons(['reset'],true);
			}
			
			/* 외화환산자동기표방법등록 (aba060ukrs13.jsp) */
			else if(activeTab.getId() == 'tab_ForeignCurrency_Transit'){
				var param =  panelDetail.down('#tab_ForeignCurrency_Transit').getValues();
				var compCode = UserInfo.compCode
				var r = {
					COMP_CODE : compCode
				}
				panelDetail.down('#aba060ukrs12Grid').createRow(r);
				
				UniAppManager.setToolbarButtons(['reset'],true);
			}
		},
		
		onSaveDataButtonDown: function (config) {
			var activeTab = panelDetail.down('#aba060Tab').getActiveTab();

			if (activeTab.getId() == 'tab_aba100ukr'){
				var param= panelDetail.down('#tab_aba100ukr').getValues();
				panelDetail.down('#tab_aba100ukr').getForm().submit({
					 params : param,
						 success : function(actionform, action) {
		 					panelDetail.down('#tab_aba100ukr').getForm().wasDirty = false;
							panelDetail.down('#tab_aba100ukr').resetDirtyStatus();											
							UniAppManager.setToolbarButtons('save', false);	
		            		UniAppManager.updateStatus(Msg.sMB011);
		            		UniAppManager.app.onQueryButtonDown();
//		            		alert("변경된 데이타포맷을 적용하려면 프로그램 종료후 로그인을 다시 하셔야 합니다.");
						 }
				});
			}
			/* 매입 매출전표 저장 */
			else if (activeTab.getId() == 'tab_inoutSlip'){
				aba060ukrs2Store.saveStore(config);
			}
			/* 급여 / 상여 저장 */
			else if (activeTab.getId() == 'tab_pay'){
				var saveFlag = true;
				var insertRecords=aba060ukrs3Store.getNewRecords( );
				var updateRecords=aba060ukrs3Store.getUpdatedRecords( );
				var changedRec = [].concat(insertRecords).concat(updateRecords)
				
				Ext.each(changedRec, function(cRec){
					cRec.DIVI = panelDetail.down('#tab_payForm').getValue('DIVI');
					if(panelDetail.down('#tab_payForm').getValue('DIVI') == 1) {
						if(Ext.isEmpty(cRec.get('ALLOW_TAG_A043')))	{
							saveFlag = false;
							alert("수당/공제구분은 필수 입력 항목 입니다.");
							return false;
						}
					} else {
						if(Ext.isEmpty(cRec.get('ALLOW_TAG_A066')))	{
							saveFlag = false;
							alert("수당/공제구분은 필수 입력 항목 입니다.");
							return false;
						}
					} 
				})
				if (saveFlag) {
					// activeTab.down('#aba060ukrs3Grid').getStore().syncAll();
					aba060ukrs3Store.saveStore(config);
				}
			}
			
			/* 기타소득 저장 */
			else if (activeTab.getId() == 'tab_Other_Income'){
				aba060ukrs4Store.saveStore(config);
			}
			
			/* 매출 저장 */
			else if (activeTab.getId() == 'tab_Sell'){
				aba060ukrs5Store.saveStore(config);
			}
			
			/* 수금 저장 */
			else if (activeTab.getId() == 'tab_collection'){
				aba060ukrs6Store.saveStore(config);
			}
			
			/* 매입 저장 */
			else if (activeTab.getId() == 'tab_buy'){
				aba060ukrs7Store.saveStore(config);
			}
			
			/* 무역경비 저장 */
			else if (activeTab.getId() == 'tab_Trading_Cost'){
				aba060ukrs8Store.saveStore(config);
			}
			
			/* 고정자산취득 저장 */
			else if (activeTab.getId() == 'tab_Acquisition_Assets'){
				aba060ukrs9Store.saveStore(config);
			}
			
			/* 감가상각 저장 */
			else if (activeTab.getId() == 'tab_Depreciation'){
				aba060ukrs10Store.saveStore(config);
			}
			
			/* 미착대체 저장 */
			else if (activeTab.getId() == 'tab_Alternative_Transit'){
				aba060ukrs11Store.saveStore(config);
			}
			
			/* 외화환산자동기표방법등록 (aba060ukrs13.jsp) 저장 */
			else if (activeTab.getId() == 'tab_ForeignCurrency_Transit'){
				aba060ukrs12Store.saveStore(config);
			}
			
			/* 포멧 */
			else if(activeTab.getItemId() == "tab_format"){
				var param= panelDetail.down('#tab_format').getValues();
				panelDetail.down('#tab_format').getForm().submit({
					 params : param,
						 success : function(actionform, action) {
		 					panelDetail.down('#tab_format').getForm().wasDirty = false;
							panelDetail.down('#tab_format').resetDirtyStatus();											
							UniAppManager.setToolbarButtons('save', false);	
		            		UniAppManager.updateStatus(Msg.sMB011);
		            		UniAppManager.app.onQueryButtonDown();
		            		alert("변경된 데이타포맷을 적용하려면 프로그램 종료후 로그인을 다시 하셔야 합니다.");
						 }
				});
			}
		},
		onDeleteDataButtonDown : function()	{
			
			var activeTab = panelDetail.down('#aba060Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_inoutSlip"){	
				var grid = panelDetail.down('#aba060ukrs2Grid');
				var selRow = grid.getSelectionModel().getSelection()[0];
				
				if (selRow.phantom === true)	{
					grid.deleteSelectedRow();
				} 
				else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
						}
					});
				}
			}
			
			else if(activeTab.getItemId() == "tab_pay"){	
				var grid = panelDetail.down('#aba060ukrs3Grid');
				var selRow = grid.getSelectionModel().getSelection()[0];
				
				if (selRow.phantom === true)	{
					grid.deleteSelectedRow();
				} 
				else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
						}
					});
				}
			}
			
			/* 기타소득 삭제 */
			else if(activeTab.getItemId() == "tab_Other_Income"){	
				var grid = panelDetail.down('#aba060ukrs4Grid');
				var selRow = grid.getSelectionModel().getSelection()[0];
				
				if (selRow.phantom === true)	{
					grid.deleteSelectedRow();
				} 
				else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
						}
					});
				}
			}
			
			/* 매출 삭제 */
			else if(activeTab.getItemId() == "tab_Sell"){	
				var grid = panelDetail.down('#aba060ukrs5Grid');
				var selRow = grid.getSelectionModel().getSelection()[0];
				
				if (selRow.phantom === true)	{
					grid.deleteSelectedRow();
				} 
				else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
						}
					});
				}
			}
			
			/* 수금 삭제 */
			else if(activeTab.getItemId() == "tab_collection"){	
				var grid = panelDetail.down('#aba060ukrs6Grid');
				var selRow = grid.getSelectionModel().getSelection()[0];
				
				if (selRow.phantom === true)	{
					grid.deleteSelectedRow();
				} 
				else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
						}
					});
				}
			}
			
			/* 매입 삭제 */
			else if(activeTab.getItemId() == "tab_buy"){	
				var grid = panelDetail.down('#aba060ukrs7Grid');
				var selRow = grid.getSelectionModel().getSelection()[0];
				
				if (selRow.phantom === true)	{
					grid.deleteSelectedRow();
				} 
				else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
						}
					});
				}
			}
			
			/* 무역경비 삭제 */
			else if(activeTab.getItemId() == "tab_Trading_Cost"){	
				var grid = panelDetail.down('#aba060ukrs8Grid');
				var selRow = grid.getSelectionModel().getSelection()[0];
				
				if (selRow.phantom === true)	{
					grid.deleteSelectedRow();
				} 
				else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
						}
					});
				}
			}
			
			/* 고정자산취득 삭제 */
			else if(activeTab.getItemId() == "tab_Acquisition_Assets"){	
				var grid = panelDetail.down('#aba060ukrs9Grid');
				var selRow = grid.getSelectionModel().getSelection()[0];
				
				if (selRow.phantom === true)	{
					grid.deleteSelectedRow();
				} 
				else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
						}
					});
				}
			}
			
			
			/* 감가상각 삭제 */
			else if(activeTab.getItemId() == "tab_Depreciation"){	
				var grid = panelDetail.down('#aba060ukrs10Grid');
				var selRow = grid.getSelectionModel().getSelection()[0];
				
				if (selRow.phantom === true)	{
					grid.deleteSelectedRow();
				} 
				else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
						}
					});
				}
			}
			
			/* 미착대체 삭제 */
			else if(activeTab.getItemId() == "tab_Alternative_Transit"){	
				var grid = panelDetail.down('#aba060ukrs11Grid');
				var selRow = grid.getSelectionModel().getSelection()[0];
				
				if (selRow.phantom === true)	{
					grid.deleteSelectedRow();
				} 
				else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
						}
					});
				}
			}
			
			/* 외화환산자동기표방법등록 (aba060ukrs13.jsp) 삭제 */
			else if(activeTab.getItemId() == "tab_ForeignCurrency_Transit"){	
				var grid = panelDetail.down('#aba060ukrs12Grid');
				var selRow = grid.getSelectionModel().getSelection()[0];
				
				if (selRow.phantom === true)	{
					grid.deleteSelectedRow();
				} 
				else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
						}
					});
				}
			}
			
			
		},
		onResetButtonDown:function() {
			
			var activeTab = panelDetail.down('#aba060Tab').getActiveTab();
			/* 회계기준설정일 경우 기본 데이터 세팅  */
			if (activeTab.getItemId() == 'tab_aba100ukr'){
				
			}
			
			/* 매입 매출전표 조회 */
			if (activeTab.getItemId() == 'tab_inoutSlip'){
				panelDetail.down('#tab_inoutSlipForm').clearForm();
				panelDetail.down('#aba060ukrs2Grid').reset();
				aba060ukrs2Store.loadData({});
			}
			
			/* 급여 / 상여 조회 */
			else if (activeTab.getItemId() == 'tab_pay'){
				panelDetail.down('#tab_payForm').clearForm();
				panelDetail.down('#aba060ukrs3Grid').reset();
				aba060ukrs3Store.loadData({});
				panelDetail.down('#tab_payForm').getField('DIVI').setReadOnly(false);
			}
			
			/* 기타소득 */
			else if (activeTab.getItemId() == 'tab_Other_Income'){
				panelDetail.down('#tab_Other_IncomeForm').clearForm();
				panelDetail.down('#aba060ukrs4Grid').reset();
				aba060ukrs4Store.loadData({});
			}
			
			/* 매출 */
			else if (activeTab.getItemId() == 'tab_Sell'){
				panelDetail.down('#tab_SellForm').clearForm();
				panelDetail.down('#aba060ukrs5Grid').reset();
				aba060ukrs5Store.loadData({});
				panelDetail.down('#tab_SellForm').getField('EXPORT_YN').setReadOnly(false); 
			}
			
			/* 수금 */
			else if (activeTab.getItemId() == 'tab_collection'){
				panelDetail.down('#tab_collectionForm').clearForm();
				panelDetail.down('#aba060ukrs6Grid').reset();
				aba060ukrs6Store.loadData({});
			}
			
			/* 매입 */
			else if (activeTab.getItemId() == 'tab_buy'){
				panelDetail.down('#tab_buyForm').clearForm();
				panelDetail.down('#aba060ukrs7Grid').reset();
				aba060ukrs7Store.loadData({});
			}
			
			/* 무역경비 */
			else if (activeTab.getItemId() == 'tab_Trading_Cost'){
				panelDetail.down('#tab_Trading_CostForm').clearForm();
				panelDetail.down('#aba060ukrs8Grid').reset();
				aba060ukrs8Store.loadData({});
				panelDetail.down('#tab_Trading_CostForm').getField('TRADE_DIV').setReadOnly(false);
			}
			
			/* 고정자산취득 */
			else if (activeTab.getItemId() == 'tab_Acquisition_Assets'){
				panelDetail.down('#tab_Acquisition_AssetsForm').clearForm();
				panelDetail.down('#aba060ukrs9Grid').reset();
				aba060ukrs9Store.loadData({});
			}
			
			/* 감가상각 */
			else if (activeTab.getItemId() == 'tab_Depreciation'){
				panelDetail.down('#tab_DepreciationForm').clearForm();
				panelDetail.down('#aba060ukrs10Grid').reset();
				aba060ukrs10Store.loadData({});
			}
			
			/* 미착대체 */
			else if (activeTab.getItemId() == 'tab_Alternative_Transit'){
				panelDetail.down('#tab_Alternative_Transit').clearForm();
				panelDetail.down('#aba060ukrs11Grid').reset();
				aba060ukrs11Store.loadData({});
			}
			
			/* 외화환산자동기표방법등록 (aba060ukrs13.jsp) */
			else if (activeTab.getItemId() == 'tab_ForeignCurrency_Transit'){
				panelDetail.down('#tab_ForeignCurrency_Transit').clearForm();
				panelDetail.down('#aba060ukrs12Grid').reset();
				aba060ukrs11Store.loadData({});
			}
			
			/* */
			else if(activeTab.getItemId() == "tab_format"){
				UniAppManager.setToolbarButtons(['newData', 'delete', 'save'],false);
				
				var param= panelDetail.down('#tab_format').getValues();
				panelDetail.down('#tab_format').getForm().load({
					
					params: param
				})
			}
			
			
			
			this.fnInitBinding();
		},
		loadTabData: function(tab, itemId){
			if (tab.getItemId() == 'tab_inoutSlip'){
				UniAppManager.setToolbarButtons(['newData', 'delete','query'],true);
				
				var sForm = panelDetail.down('#tab_inoutSlipForm');
				sForm.clearForm();
				
				panelDetail.down('#aba060ukrs2Grid').reset();
				aba060ukrs2Store.loadData({});
				
				sForm.getField('SALE_DIVI').focus(500);
				
			}
			
			/* 급여 / 상여 */
			else if (tab.getItemId() == 'tab_pay'){
				UniAppManager.setToolbarButtons(['newData', 'delete','query'],true);
				var sForm = panelDetail.down('#tab_payForm');
				sForm.clearForm();
				panelDetail.down('#aba060ukrs3Grid').reset();
				aba060ukrs3Store.loadData({});
				sForm.setValue('DIVI', '1');
				sForm.getField('DIVI').setReadOnly(false);
				panelDetail.down('#aba060ukrs3Grid').getColumn('ALLOW_TAG_A043').setVisible(true);
			 	panelDetail.down('#aba060ukrs3Grid').getColumn('ALLOW_TAG_A066').setVisible(false);
			 	
//			 	panelDetail.down('#aba060ukrs3Grid').getColumn('ALLOW_TAG_A043').setConfig('allowBank', false);
//			 	panelDetail.down('#aba060ukrs3Grid').getColumn('ALLOW_TAG_A066').setConfig('allowBank', true);
			 	
				
			 	var focusField = sForm.getField('DIVI');
			 	focusField.focus(500);
			}
			
			/* 기타소득 */
			else if (tab.getItemId() == 'tab_Other_Income'){
				UniAppManager.setToolbarButtons(['newData', 'delete','query'],true);
				
				var sForm = panelDetail.down('#tab_Other_IncomeForm');
				sForm.clearForm();
				
				panelDetail.down('#aba060ukrs4Grid').reset();
				aba060ukrs4Store.loadData({});
				panelDetail.down('#tab_Other_IncomeForm').setValue('INCOM_TYPE', '1');
				
				var focusField = sForm.getField('INCOM_TYPE');
			 	focusField.focus(500);
			}
			
			/* 매출 */
			else if (tab.getItemId() == 'tab_Sell'){
				UniAppManager.setToolbarButtons(['newData', 'delete','query'],true);
				var sForm = panelDetail.down('#tab_SellForm');
				sForm.clearForm();
				panelDetail.down('#aba060ukrs5Grid').reset();
				aba060ukrs5Store.loadData({});
				sForm.getField('EXPORT_YN').setReadOnly(false);  
				panelDetail.down('#aba060ukrs5Grid').getColumn('SALE_TYPE_S024').setVisible(true);
			 	panelDetail.down('#aba060ukrs5Grid').getColumn('SALE_TYPE_A082').setVisible(false);
			 	
			 	var focusField = sForm.getField('EXPORT_YN');
			 	focusField.focus(500);
			}
			
			/* 수금 */
			else if (tab.getItemId() == 'tab_collection'){
				UniAppManager.setToolbarButtons(['newData', 'delete','query'],true);
				var sForm = panelDetail.down('#tab_collectionForm');
				sForm.clearForm();
				panelDetail.down('#aba060ukrs6Grid').reset();
				aba060ukrs6Store.loadData({});
				
				var focusField = sForm.getField('EXPORT_YN');
			 	focusField.focus(500);
			}
			
			/* 매입 */
			else if (tab.getItemId() == 'tab_buy'){
				UniAppManager.setToolbarButtons(['newData', 'delete','query'],true);
				
				var sForm = panelDetail.down('#tab_buyForm');
				sForm.clearForm();
				
				panelDetail.down('#aba060ukrs7Grid').reset();
				aba060ukrs7Store.loadData({});
				
				var focusField = sForm.getField('ORDER_TYPE');
			 	focusField.focus(500);
			}
			
			/* 무역경비 */
			else if (tab.getItemId() == 'tab_Trading_Cost'){
				UniAppManager.setToolbarButtons(['newData', 'delete','query'],true);
				
				var sForm = panelDetail.down('#tab_Trading_CostForm');
				sForm.clearForm();

				panelDetail.down('#aba060ukrs8Grid').reset();
				aba060ukrs8Store.loadData({});
				panelDetail.down('#tab_Trading_CostForm').getField('TRADE_DIV').setReadOnly(false);
				
				var focusField = sForm.getField('TRADE_DIV');
			 	focusField.focus(500);
			}
			
			/* 고정자산취득 */
			else if (tab.getItemId() == 'tab_Acquisition_Assets'){
				UniAppManager.setToolbarButtons(['newData', 'delete','query'],true);
				
				var sForm = panelDetail.down('#tab_Acquisition_AssetsForm');
				sForm.clearForm();

				panelDetail.down('#aba060ukrs9Grid').reset();
				aba060ukrs9Store.loadData({});
				
				var focusField = sForm.getField('PAY_TYPE');
			 	focusField.focus(500);
			}
			
			/* 감가상각 */
			else if (tab.getItemId() == 'tab_Depreciation'){
				UniAppManager.setToolbarButtons(['newData', 'delete','query'],true);
				
				var sForm = panelDetail.down('#tab_DepreciationForm');
				sForm.clearForm();

				panelDetail.down('#aba060ukrs10Grid').reset();
				aba060ukrs10Store.loadData({});
				
				var focusField = sForm.getField('DEPT_DIVI');
			 	focusField.focus(500);
			}
			
			/* 미착대체 */
			else if (tab.getItemId() == 'tab_Alternative_Transit'){
				UniAppManager.setToolbarButtons(['newData', 'delete','query'],true);
				
				var sForm = panelDetail.down('#tab_Alternative_Transit');
				sForm.clearForm();
				
				panelDetail.down('#aba060ukrs11Grid').reset();
				aba060ukrs11Store.loadData({});
			}
			
			/* 외화환산자동기표방법등록 (aba060ukrs13.jsp) */
			else if (tab.getItemId() == 'tab_ForeignCurrency_Transit'){
				UniAppManager.setToolbarButtons(['newData', 'delete','query'],true);
				
				var sForm = panelDetail.down('#tab_ForeignCurrency_Transit');
				sForm.clearForm();
				
				panelDetail.down('#aba060ukrs12Grid').reset();
				aba060ukrs11Store.loadData({});
			}
			
			else if (tab.getItemId() == 'tab_format'){
				UniAppManager.setToolbarButtons(['reset'],true);
				UniAppManager.setToolbarButtons(['newData', 'delete'],false);
				var param= panelDetail.down('#tab_format').getValues();
				panelDetail.down('#tab_format').getForm().load({
					
					params: param
				})
			}
		}
	});
};


</script>
