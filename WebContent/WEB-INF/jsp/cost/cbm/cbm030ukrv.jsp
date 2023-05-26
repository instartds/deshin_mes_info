<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cbm030ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="B010" />	<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="CD20" /> <!-- 제조/판관 -->
	<t:ExtComboStore comboType="AU" comboCode="CD21" /> <!-- CostPool구분(직접/간접) -->
	<t:ExtComboStore comboType="AU" comboCode="CD27" /> <!-- 공통CostPool구분(전체공통/직과공통) -->
	<t:ExtComboStore comboType="AU" comboCode="CD22" /> <!-- 공통CostPool배부유형 -->
</t:appConfig>	
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {     

	/* Cost Center 정보 */
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   	read    : 'cbm030ukrvService.selectList1',
        	create  : 'cbm030ukrvService.insertDetail1',
            update  : 'cbm030ukrvService.updateDetail1',
            destroy : 'cbm030ukrvService.deleteDetail1',
            syncAll : 'cbm030ukrvService.saveAll1'
		}
	 });
	 
	/* Cost Pool 정보 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read    : 'cbm030ukrvService.selectList2',
			create  : 'cbm030ukrvService.insertDetail2',
			update  : 'cbm030ukrvService.updateDetail2',
			destroy : 'cbm030ukrvService.deleteDetail2',
			syncAll : 'cbm030ukrvService.saveAll2'
		}
 	});
	 
	/* Model 정의 
	 * @type 
	 */	
	/* Cost Center 정보 */
	//모델 정의
	Unilite.defineModel('cbm030ukrvModel1', {
	    fields: [{name: 'COMP_CODE'					,text:'COMP_CODE'		,type : 'string', defaultValue: UserInfo.compCode},
	             {name: 'DIV_CODE'					,text:'사업장'			,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode},
	    		 {name: 'COST_CENTER_CODE'			,text:'Cost Center'		,type : 'string', allowBlank:false},
	    		 {name: 'COST_CENTER_NAME'			,text:'Cost Center명'	,type : 'string', allowBlank:false},
	    		 {name: 'MAKE_SALE'					,text:'제조/판관'			,type : 'string', allowBlank:false, comboType:'AU', comboCode:'CD20'},
	    		 {name: 'COST_POOL_GB'				,text:'직접/간접'			,type : 'string', allowBlank:false, comboType:'AU', comboCode:'CD21'},
				 {name: 'SORT_SEQ'					,text:'정렬순서'			,type : 'int'},
	    		 {name: 'REMARK'					,text:'비고'				,type : 'string'},
	    		 {name: 'UPDATE_DB_USER'			,text:'UPDATE_DB_USER'	,type : 'string'},
	    		 {name: 'UPDATE_DB_TIME'			,text:'UPDATE_DB_TIME'	,type : 'string'}
			]
	});	

	//스토어 정의
	var cbm030ukrvStore1 = Unilite.createStore('cbm030ukrvStore1',{
		model: 'cbm030ukrvModel1',
        autoLoad: true,
        uniOpt : {
           	isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxy1,
        loadStoreRecords : function()	{
			this.load({
			});
		},
		saveStore : function(config){
			var inValidRecs = this.getInvalidRecords();
		
			var rv = true;
		        
			if(inValidRecs.length == 0 ) {          
				config = {
					success: function(batch, option) {        
//					panelDetail.resetDirtyStatus();
					UniAppManager.setToolbarButtons('save', false);   
					} 
				};     
				this.syncAllDirect(config);
			}else {
				panelDetail.down('#cbm030ukrvsGrid1').uniSelectInvalidColumnAndAlert(inValidRecs);
		    }
		}    
	});

	/* Cost Pool 정보 */
	//모델 정의
	Unilite.defineModel('cbm030ukrvModel2', {
	    fields: [{name: 'COMP_CODE'					,text:'COMP_CODE'		,type : 'string', defaultValue: UserInfo.compCode},
	             {name: 'DIV_CODE'					,text:'사업장'			,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode},
	    		 {name: 'COST_POOL_CODE'			,text:'Cost Pool'		,type : 'string', allowBlank:false},
	    		 {name: 'COST_POOL_NAME'			,text:'Cost Pool 명'		,type : 'string', allowBlank:false},
	    		 {name: 'COST_POOL_GB'				,text:'직접/간접'			,type : 'string', allowBlank:false, comboType:'AU', comboCode:'CD21'},
	    		 {name: 'SAVE_CODE'                 ,text:'통장번호'                ,type : 'string'},          //O1
                 {name: 'SAVE_NAME'                 ,text:'통장명'             ,type : 'string'},          //O1
                 {name: 'BANK_CODE'                 ,text:'은행코드'                ,type : 'string'},          //A3
                 {name: 'BANK_NAME'                 ,text:'은행명'             ,type : 'string'},          //A3
                 {name: 'BANK_ACCOUNT'              ,text:'계좌번호'             ,type : 'string'},          
	    		 {name: 'PRODT_CP_GB'				,text:'제품생산'			,type : 'string', allowBlank:false, comboType:'AU', comboCode:'B010'},
				 {name: 'APPORTION_YN'				,text:'공통여부'			,type : 'string', allowBlank:false, comboType:'AU', comboCode:'B010'},
				 {name: 'APPORTION_GB'				,text:'공통구분'			,type : 'string', comboType:'AU', comboCode:'CD27'},
				 {name: 'APPORTION_LEVEL'			,text:'공통레벨'			,type : 'int'},
				 {name: 'COST_POOL_DISTR'			,text:'공통배부유형'		,type : 'string', comboType:'AU', comboCode:'CD22'},
				 {name: 'LLC_SEQ'					,text:'적상순서'			,type : 'int'},
				 {name: 'SORT_SEQ'					,text:'정렬순서'			,type : 'int'},
	    		 {name: 'REMARK'					,text:'비고'				,type : 'string'},
	    		 {name: 'UPDATE_DB_USER'			,text:'UPDATE_DB_USER'	,type : 'string'},
				 {name: 'UPDATE_DB_TIME'			,text:'UPDATE_DB_TIME'	,type : 'string'}
			]
	});	

	//스토어 정의
	var cbm030ukrvStore2 = Unilite.createStore('cbm030ukrvStore2',{
		model: 'cbm030ukrvModel2',
        autoLoad: true,
        uniOpt : {
           	isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxy2,
        loadStoreRecords : function()	{
			this.load({
			});
		},
		saveStore : function(config){
			var inValidRecs = this.getInvalidRecords();
		
			var rv = true;
		        
			if(inValidRecs.length == 0 ) {          
				config = {
					success: function(batch, option) {        
//					panelDetail.resetDirtyStatus();
					UniAppManager.setToolbarButtons('save', false);   
					} 
				};     
				this.syncAllDirect(config);
			}else {
				panelDetail.down('#cbm030ukrvsGrid2').uniSelectInvalidColumnAndAlert(inValidRecs);
		    }
		}    
	});

	/* 기준코드등록 */
	var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled : false,
	    items : [{ 
	    	xtype: 'grouptabpanel',
	    	itemId: 'cbm030Tab',
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
						<%@include file="./cbm500ukrv.jsp" %>	//Cost Center정보
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
						<%@include file="./cbm600ukrv.jsp" %>	//Cost Pool정보
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
					else {
						if (newCard.itemId == 'tab_costCenter') {
							UniAppManager.setToolbarButtons(['reset'],false);
							UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
							cbm030ukrvStore1.loadStoreRecords();
						}
						else if(newCard.itemId == 'tab_costPool'){
							UniAppManager.setToolbarButtons(['reset'],false);
							UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
							cbm030ukrvStore2.loadStoreRecords();
						}
					 }
		    	}
		    }
	    }]
    })

	/* 기준코드등록	*/
	Unilite.Main( {
		id 			: 'cbm030ukrvApp',
		borderItems : [ 
			panelDetail		 	
		], 
		fnInitBinding : function() {				
			UniAppManager.setToolbarButtons(['reset'],false);
			UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
		},
		onQueryButtonDown : function()	{		
			var activeTab = panelDetail.down('#cbm030Tab').getActiveTab();
			/* Cost Center */
			if (activeTab.getItemId() == 'tab_costCenter'){
				UniAppManager.setToolbarButtons(['reset'],false);
				UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
				cbm030ukrvStore1.loadStoreRecords();
			/* Cost Pool */
			} else if(activeTab.getItemId() == 'tab_costPool'){
				UniAppManager.setToolbarButtons(['reset'],false);
				UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
				cbm030ukrvStore2.loadStoreRecords();
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
			var activeTab = panelDetail.down('#cbm030Tab').getActiveTab();
			/* Cost Center 추가버튼 클릭  */
			if(activeTab.getItemId() == "tab_costCenter"){
				var sortSeq			= 1;
				var r = {
					SORT_SEQ		: sortSeq
				}
				panelDetail.down('#cbm030ukrvsGrid1').createRow(r);
			}
			/* Cost Pool 추가버튼 클릭  */
			else if(activeTab.getId() == 'tab_costPool'){
				var llcSeq			= 1;
				var sortSeq			= 1;
				var costPoolGb      = '02';
                var prodtCpGb       = 'N';
                var apportionYn     = 'N';
				
				var r = {
					LLC_SEQ			: llcSeq,
					SORT_SEQ		: sortSeq,
					
					COST_POOL_GB    : costPoolGb,
					PRODT_CP_GB     : prodtCpGb,
					APPORTION_YN    : apportionYn
					
					
				}
				panelDetail.down('#cbm030ukrvsGrid2').createRow(r);
			}
		},
		onDeleteDataButtonDown : function()	{
			var activeTab = panelDetail.down('#cbm030Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_costCenter"){
				panelDetail.down('#cbm030ukrvsGrid1').deleteSelectedRow();
				
			}else if(activeTab.getItemId() == "tab_costPool"){
				panelDetail.down('#cbm030ukrvsGrid2').deleteSelectedRow();
			}	
		},		
		onSaveDataButtonDown: function () {
			var activeTab = panelDetail.down('#cbm030Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_costCenter"){
				cbm030ukrvStore1.saveStore();
			}
			else if(activeTab.getItemId() == "tab_costPool"){
				cbm030ukrvStore2.saveStore();
			}	
		},
		loadTabData: function(tab, itemId){
			/* Cost Center */
			if (tab.getItemId() == 'tab_costCenter'){
				UniAppManager.setToolbarButtons(['reset'],false);
				UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
				panelDetail.down('#cbm030ukrvsGrid1').getStore().loadData({});
				cbm030ukrvStore1.loadStoreRecords();
			}
			/* Cost Pool */
			else if (tab.getItemId() == 'tab_costPool'){
				UniAppManager.setToolbarButtons(['reset'],false);
				UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
				panelDetail.down('#cbm030ukrvsGrid2').getStore().loadData({});
				cbm030ukrvStore2.loadStoreRecords();
			}
		}
	});
};
</script>
