<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="pbs060ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!--사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="P005" />	<!--자동채번정보 -->
	<t:ExtComboStore comboType="AU" comboCode="P100" /> <!--기표구분-->
	<t:ExtComboStore comboType="AU" comboCode="P107" /> <!--생산계획기간(일) -->
	<t:ExtComboStore comboType="AU" comboCode="P104" /> <!--일일생산량관리-->
	<t:ExtComboStore comboType="AU" comboCode="P112" /> <!-- -->
	<t:ExtComboStore comboType="AU" comboCode="P109" /> <!--출고요청정보자동생성관리-->
	<t:ExtComboStore comboType="AU" comboCode="P111" /> <!--접수검사정보자동생성여부-->
	<t:ExtComboStore comboType="AU" comboCode="P110" /> <!--자재출고량관리-실적등록시출고량확인여부-->

	<t:ExtComboStore comboType="AU" comboCode="" /> <!--수량-->
	<t:ExtComboStore comboType="AU" comboCode="" /> <!--단가-->
	<t:ExtComboStore comboType="AU" comboCode="" /> <!--자국화폐금액-->
	<t:ExtComboStore comboType="AU" comboCode="" /> <!--외화화폐금액-->
	<t:ExtComboStore comboType="AU" comboCode="" /> <!--환율-->	
	

</t:appConfig>	
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {

var gsButtonFlag = true;
	
	 var pbs060ukrvStore = Ext.create('Ext.data.Store',{
		storeId: 'pbs060ukrvCombo',
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
	
    <%@include file="./pbs060ukrvs1.jsp" %>	// 생산업무설정
	<%@include file="./pbs060ukrvs2.jsp" %>	// 조회데이타포멧설정
	
    var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled:false,
	    items : [{ 
	    	xtype: 'grouptabpanel',
	    	itemId: 'pbs060Tab',
	    	cls:'human-panel',
	    	activeGroup: 0,
	    	collapsible:true,
	    	items: [
				operating_Criteria,	  // 생산업무설정
				reference_Data  	  // 조회데이타포멧설정
	    	],
	    
    		listeners:{
	    	 	beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{
		    		//var btnRtun = false;
		    		if(Ext.isObject(oldCard))	{
		    			 if(UniAppManager.app._needSave())	{
		    			 	if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
								UniAppManager.app.onSaveDataButtonDown();
								this.setActiveTab(oldCard);
								
							}else {
//		    			 		UniAppManager.app.fnInitBinding();
								UniAppManager.app.loadTabData(newCard, newCard.getItemId());	
							}
		    			 }
		    			 
		    			 else {
	    			 	 	UniAppManager.app.loadTabData(newCard, newCard.getItemId());
		    			 }

    			 	}/* else {
    					if (newCard.itemId == 'tab_format'){
//	    			 		UniAppManager.app.fnInitBinding();
	    			 	 	UniAppManager.app.loadTabData(newCard, newCard.getItemId());
    					}
    					else{    			 	
//	    			 		UniAppManager.app.fnInitBinding();
	    			 	 	UniAppManager.app.loadTabData(newCard, newCard.getItemId());
    					}	 	 	
	    			 }*/
		    		UniAppManager.setToolbarButtons(['reset', 'excel', 'delete', 'newData', 'save'],false);
		    		//return btnRtun;
		    	}
	    	}
	    }]
    });	
	

    
	 Unilite.Main( {
		borderItems:[ 
			panelDetail		 	
		], 
		id : 'pbs060ukrvApp',
		fnInitBinding : function() {
		 	UniAppManager.setToolbarButtons(['reset', 'excel', 'delete', 'newData', 'save'], false);
			
			var param= panelDetail.down('#tab_operating').getValues();
			panelDetail.down('#tab_operating').getForm().load({
				params: param
			})	
		},
		onQueryButtonDown : function()	{	
			var activeTab = panelDetail.down('#pbs060Tab').getActiveTab();
			
			panelDetail.down('#tab_operating').clearForm();
			panelDetail.down('#tab_format').clearForm();
			
			if(activeTab.getItemId() == "tab_operating"){
				gsButtonFlag = false;	
				var param= panelDetail.down('#tab_operating').getValues();
				panelDetail.down('#tab_operating').getForm().load({
					params: param,
					success : function(actionform, action) {
                        setTimeout( function() { gsButtonFlag = true }, 200 );
					}
				})	
				
			} else if(activeTab.getItemId() == "tab_format"){
				gsButtonFlag = false;	
				var param= panelDetail.down('#tab_format').getValues();
				panelDetail.down('#tab_format').getForm().load({
					params: param,
					success : function(actionform, action) {
                        setTimeout( function() { gsButtonFlag = true }, 200 );
					}
				})
			}	
		},
		onSaveDataButtonDown: function(config) {
			var activeTab = panelDetail.down('#pbs060Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_operating"){
				if(!Ext.isEmpty(panelDetail.down('#tab_operating').getValue('P107_1'))) {
					if (panelDetail.down('#tab_operating').getValue('P107_1') > 60) {
						alert ('생산계획기간은 60일을 넘을 수 없습니다.');
						return false;
					}
					var param= panelDetail.down('#tab_operating').getValues();
					panelDetail.down('#tab_operating').getForm().submit({
						params : param,
						success : function(actionform, action) {
		 					panelDetail.down('#tab_operating').getForm().wasDirty = false;
							panelDetail.down('#tab_operating').resetDirtyStatus();											
							UniAppManager.setToolbarButtons('save', false);	
		            		UniAppManager.updateStatus(Msg.sMB011);

							panelDetail.down('#tab_operating').clearForm();
							panelDetail.down('#tab_format').clearForm();
		            		UniAppManager.app.onQueryButtonDown();							
						 },
						 failure: function(){
							gsButtonFlag = true;
							alert('저장 중 오류가 발생했습니다.');	
						 }
					});
				} else {
					gsButtonFlag = true;
					alert ('생산계획기간은 필수입력 입니다.');
					return false;
				}
				
			} else if(activeTab.getItemId() == "tab_format"){
				var param= panelDetail.down('#tab_format').getValues();
				panelDetail.down('#tab_format').getForm().submit({
					params : param,
					success : function(actionform, action) {
	 					panelDetail.down('#tab_format').getForm().wasDirty = false;
						panelDetail.down('#tab_format').resetDirtyStatus();											
						UniAppManager.setToolbarButtons('save', false);	
	            		UniAppManager.updateStatus(Msg.sMB011);

						panelDetail.down('#tab_operating').clearForm();
						panelDetail.down('#tab_format').clearForm();
	            		UniAppManager.app.onQueryButtonDown();
	            		
//                        setTimeout( function() { gsButtonFlag = true }, 200 );
					 },
					 failure: function(){
						gsButtonFlag = true;
						alert('저장 중 오류가 발생했습니다.');	
					 }
				});
			}
		},
		
		loadTabData: function(tab, itemId){
			/* 생산기준설정 */
			gsButtonFlag = false;		
			var param1= panelDetail.down('#tab_operating').getValues();
			panelDetail.down('#tab_operating').getForm().load({
				params: param1,
				success : function(actionform, action) {
 					panelDetail.down('#tab_operating').getForm().wasDirty = false;
					panelDetail.down('#tab_operating').resetDirtyStatus();	
                    setTimeout( function() { gsButtonFlag = true }, 200 );
				 }
			})
			
			//조회데이터포맷설정 조회
			gsButtonFlag = false;		
			var param2= panelDetail.down('#tab_format').getValues();
			panelDetail.down('#tab_format').getForm().load({
				params: param2,
				success : function(actionform, action) {
 					panelDetail.down('#tab_format').getForm().wasDirty = false;
					panelDetail.down('#tab_format').resetDirtyStatus();		
                    setTimeout( function() { gsButtonFlag = true }, 200 );
	 				UniAppManager.setToolbarButtons(['reset', 'excel', 'delete', 'newData', 'save'],false);
				}
			})
		}
	});
};


</script>
