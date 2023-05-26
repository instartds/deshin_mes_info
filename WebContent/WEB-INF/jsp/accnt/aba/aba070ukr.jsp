<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="aba070ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A010" />	<!-- 신용카드종류 -->
	<t:ExtComboStore comboType="AU" comboCode="A004" />	<!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A028" />	<!-- 신용카드회사 -->
	<t:ExtComboStore comboType="AU" comboCode="A098" />	<!-- 카드구분 -->		
	<t:ExtComboStore comboType="AU" comboCode="A049" />	<!--예적금구분-->
	<t:ExtComboStore comboType="AU" comboCode="B004" />	<!--화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="A004" />	<!--사용여부-->
	<t:ExtComboStore comboType="AU" comboCode="A020" />	<!--예/아니오-->
	<t:ExtComboStore comboType="AU" comboCode="A036" />	<!--상각방법-->
</t:appConfig>
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {     
	
	/**
	 *   Model 정의 
	 * @type 
	 */	
	//aba070ukrs1 Model
	Unilite.defineModel('aba070ukrs1Model', {
	    fields: [{name: 'CRDT_NUM'      	,text:'신용카드코드'	,type : 'string'},
				 {name: 'CRDT_NAME'			,text:'카드명'		,type : 'string'},
				 {name: 'CRDT_FULL_NUM'		,text:'신용카드번호'	,type : 'string'},
				 {name: 'PERSON_NUMB'		,text:'사번'			,type : 'string'},
				 {name: 'CRDT_DIVI'     	,text:'법인/개인'	    ,type : 'string'},
				 {name: 'NAME'          	,text:'성명'			,type : 'string'},
				 {name: 'EXPR_DATE'    		,text:'유효년월'		,type : 'string'},
				 {name: 'BANK_CODE'	    	,text:'결제은행'		,type : 'string'},
				 {name: 'BANK_NM'  			,text:'결제은행명'		,type : 'string'},
				 {name: 'ACCOUNT_NUM'   	,text:'결제계좌번호'	,type : 'string'},
				 {name: 'SET_DATE'      	,text:'결제일'		,type : 'string'},
				 {name: 'CRDT_COMP_CD'		,text:'카드사코드'		,type : 'string'},
				 {name: 'CRDT_COMP_NM'		,text:'카드사명'		,type : 'string'},
				 {name: 'UPDATE_DB_USER'	,text:'수정자'		,type : 'string'},
				 {name: 'UPDATE_DB_TIME'	,text:'수정일'		,type : 'string'},
				 {name: 'USE_YN'			,text:'사용유무'		,type : 'string'},
				 {name: 'CRDT_KIND'			,text:'카드종류'		,type : 'string'},
				 {name: 'CANC_DATE'			,text:'해지일'		,type : 'string'},
				 {name: 'REMARK'			,text:'비고'			,type : 'string'},
				 {name: 'LIMIT_AMT'			,text:'한도액'		,type : 'string'},
				 {name: 'CRDT_GBN'			,text:'CRDT_GBN'	,type : 'string'},
				 {name: 'COMP_CODE'			,text:'COMP_CODE'	,type : 'string'}
				
			]
	});
	//aba070ukrs1 store
	var aba070ukrs1Store = Unilite.createStore('aba070ukrs1Store',{
			model: 'aba070ukrs1Model',
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
	
		//aba070ukrs2 Model
	Unilite.defineModel('aba070ukrs2Model', {
	    fields: [{name: 'SAVE_CODE'		  	,text:'통장코드'			,type : 'string'},
				 {name: 'SAVE_NAME'		  	,text:'통장명'			,type : 'string'},
				 {name: 'BANK_CODE'		  	,text:'은행코드'			,type : 'string'},
				 {name: 'BANK_NAME'		  	,text:'은행지점명'			,type : 'string'},
				 {name: 'BANK_ACCOUNT'	  	,text:'계좌번호'			,type : 'string'},
				 {name: 'ACCNT'			  	,text:'계정코드'			,type : 'string'},
				 {name: 'ACCNT_NM'		  	,text:'계정과목'			,type : 'string'},
				 {name: 'BANK_KIND'		  	,text:'계좌종류'			,type : 'string'},
				 {name: 'DIV_CODE'		  	,text:'사업장'			,type : 'string'},
				 {name: 'UPDATE_DB_USER'  	,text:'수정자'			,type : 'string'},
				 {name: 'UPDATE_DB_TIME'  	,text:'수정일'			,type : 'uniDate'},
				 {name: 'USE_YN'		  	,text:'사용유무'			,type : 'string'},
				 {name: 'EXP_AMT_I'		  	,text:'마이너스대출한도액'	,type : 'uniPrice'},
				 {name: 'MAIN_SAVE_YN'	  	,text:'주지급계좌여부'		,type : 'string'},
				 {name: 'IF_YN'			  	,text:'계좌연계부'			,type : 'string'}
				 
			]
	});
	//aba070ukrs2 store
	var aba070ukrs2Store = Unilite.createStore('aba070ukrs2Store',{
			model: 'aba070ukrs2Model',
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
	
		//aba070ukrs3 Model
	Unilite.defineModel('aba070ukrs3Model', {
	    fields: [{name: 'ACCNT'			  	,text:'계정코드'		,type : 'string'},
				 {name: 'ACCNT_NAME' 	  	,text:'계정과목'		,type : 'string'},
				 {name: 'DEP_CTL'  		  	,text:'상각방법'		,type : 'string'},
				 {name: 'GAAP_DRB_YEAR'  	,text:'내용년수'		,type : 'string'},
				 {name: 'IFRS_DRB_YEAR'  	,text:'IFRS내용년수'	,type : 'string'},
				 {name: 'JAN_RATE'		  	,text:'잔존가율'		,type : 'string'},
				 {name: 'PREFIX'         	,text:'채번구분자'		,type : 'string'},
				 {name: 'SEQ_NUM'        	,text:'채번자리수'		,type : 'string'}
			]
	});
	//aba070ukrs3 store
	var aba070ukrs3Store = Unilite.createStore('aba070ukrs3Store',{
			model: 'aba070ukrs3Model',
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
					padding: '10 10 10 10'
				},
				items:[
					<%@include file="./aba070ukrs1.jsp" %>	//신용카드정보등록
			    ]
	    	 }, {
	    	 	defaults:{
					xtype:'uniDetailForm',
				    disabled:false,
				    border:0,
				    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
					padding: '10 10 10 10'
				},
				items:[
					
					<%@include file="./aba070ukrs2.jsp" %>	//통장정보등록
					
			    ]
	    	 }, {
	    	 	defaults:{
					xtype:'uniDetailForm',
				    disabled:false,
				    border:0,
				    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
					padding: '10 10 10 10'
				},
				items:[
					
					<%@include file="./aba070ukrs3.jsp" %>	//고정자산기본정보등록
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
		id : 'aba070ukrApp',
		fnInitBinding : function() {
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'aba070ukrGrid'){				
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
