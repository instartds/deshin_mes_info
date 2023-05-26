<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cbm010ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="CC05" />	<!-- 원가 적용단가 -->	
	<t:ExtComboStore comboType="AU" comboCode="CC06" />	<!-- [배부기준 등록방법 -->	
	<t:ExtComboStore comboType="AU" comboCode="C101" />	<!-- 공통재료비 배부유형설정 -->
</t:appConfig>	
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {     

	codeInfo = {
		applyType :'${applyType}',
		applyUnit :'${applyUnit}',
		distKind :'${distKind}'
	}
	/* 조회 데이터 포맷 */
	var cbm900ukrvCombo = Ext.create('Ext.data.Store',{
		storeId: 'cbm900ukrvCombo',
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
	
	/* 기준코드등록 */
	var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout: 'fit',
        region: 'center',
        disabled: false,
	    items: [{ 
	    	xtype: 'grouptabpanel',
	    	itemId: 'cbm010Tab',
	    	activeGroup: 0,
	    	collapsible:true,
	    	items: [{
		    	defaults:{
 					xtype: 'uniDetailForm',
				    disabled: false,
					border: 0,
				    layout: {type: 'uniTable', columns: '1', tdAttrs: {valign:'top'}},		
						margin: '10 10 10 10'
				},
				items:[
					<%@include file="./cbm001ukrv.jsp" %>	//원가기준설정
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
				    <%@include file="./cbm900ukrv.jsp" %>	// 조회데이타포맷설정
			    ]
			}],
			listeners: {
				beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{
					if(Ext.isObject(oldCard))	{
						if(UniAppManager.app._needSave())	{
							if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
								UniAppManager.app.onSaveDataButtonDown();
								this.setActiveTab(oldCard);
							}else {
								UniAppManager.setToolbarButtons('save',false);
								UniAppManager.app.loadTabData(newCard, newCard.getItemId());							
							}
		    			 }else {
							UniAppManager.app.loadTabData(newCard, newCard.getItemId());							
		    			 }
		    		}
		    	},
		    	tabchange:function(tabPanel, newCard, oldCard, eOpts ){
		    		if(oldCard)	{
		    			//UniAppManager.app.onQueryButtonDown();
		    		}
		    	}
		    }
	    }]
    })

	/* 기준코드등록	*/
	Unilite.Main( {
		id: 'cbm010ukrvApp',
		borderItems: [ 
			panelDetail		 	
		], 
		fnInitBinding : function() {				
			UniAppManager.setToolbarButtons(['reset','newData','delete'],false);
			UniAppManager.setToolbarButtons(['query','excel'],true);
		},
		onQueryButtonDown : function()	{		
			var activeTab = panelDetail.down('#cbm010Tab').getActiveTab();

			if (activeTab.getItemId() == 'tab_cbm001ukrv'){
				activeTab.getForm().load({
					success: function(form, action) {
						UniAppManager.setToolbarButtons('save',false);
					}
				});
			} else if (activeTab.getItemId() == 'tab_format'){
				activeTab.getForm().load({
					success: function(form, action) {
						UniAppManager.setToolbarButtons('save',false);
					}
				});
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
		},
		onDeleteDataButtonDown : function()	{
		},		
		onSaveDataButtonDown: function () {
			var activeTab = panelDetail.down('#cbm010Tab').getActiveTab();
			
			if (activeTab.getItemId() == 'tab_cbm001ukrv'){
				activeTab.getForm().submit({
					success:function()	{
						UniAppManager.setToolbarButtons('save',false);
					}
				});
			} else if (activeTab.getItemId() == 'tab_format'){
				activeTab.getForm().submit({
					success:function()	{
						UniAppManager.setToolbarButtons('save',false);
					}
				});
			}
		},
		loadTabData: function(tab, itemId){
			/* Cost Center */
			if (tab.getItemId() == 'tab_cbm001ukrv'){
				UniAppManager.setToolbarButtons(['reset','newData','delete','excel'],false);
				UniAppManager.setToolbarButtons(['query'],true);
			} else if (tab.getItemId() == 'tab_format'){
				UniAppManager.setToolbarButtons(['reset','newData','delete','excel'],false);
				UniAppManager.setToolbarButtons(['query'],true);
			}
		}
	});
};
</script>
