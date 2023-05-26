<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cbm040ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="CD03" />	<!-- 원가담당자 -->	
	<t:ExtComboStore comboType="AU" comboCode="CC05" />	<!-- 재료비적용단가 -->	
	<t:ExtComboStore comboType="AU" comboCode="C101" />	<!-- 간접재료비 배부유형 -->
	<t:ExtComboStore items="${COST_CETNER_COMBO}" storeId="costCenterCombo" />	
	<t:ExtComboStore items="${COST_POOL_COMBO}"   storeId="costPoolCombo" />	
	<t:ExtComboStore items="${DISTR_POOL_COMBO}"  storeId="distrPoolCombo" />	
</t:appConfig>	
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {     

	/* Cost Center 매핑정보 - Cost Center 목록*/
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   	read    : 'cbm040ukrvService.selectList1'
		}
	 });

	//모델 정의
	Unilite.defineModel('cbm040ukrvModel1', {
	    fields: [{name: 'COMP_CODE'					,text:'COMP_CODE'		,type : 'string', defaultValue: UserInfo.compCode},
	             {name: 'DIV_CODE'					,text:'사업장'			,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode},
	    		 {name: 'COST_CENTER_CODE'			,text:'Cost Center'		,type : 'string', allowBlank:false},
	    		 {name: 'COST_CENTER_NAME'			,text:'Cost Center명'	,type : 'string', allowBlank:false},
	    		 {name: 'REMARK'					,text:'비고'				,type : 'string'}
			]
	});	

	//스토어 정의
	var cbm040ukrvStore1 = Unilite.createStore('cbm040ukrvStore1',{
		model: 'cbm040ukrvModel1',
        autoLoad: true,
        uniOpt : {
           	isMaster: false,			// 상위 버튼 연결 
           	editable: false,			// 수정 모드 사용 
           	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxy1,
        loadStoreRecords : function()	{
        	var sForm = panelDetail.down('#cbm040ukrvsSearch1'); 
			this.load({ params : sForm.getValues()
			});
		}   
	});

	/* Cost Center 매핑정보 - 부서 목록 */
	var directProxyDept1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   	read    : 'cbm040ukrvService.selectDeptList1',
            update  : 'cbm040ukrvService.updateDept1',
            syncAll : 'cbm040ukrvService.saveAllDept1'
		}
	 });

	//모델 정의
	Unilite.defineModel('cbm040ukrvDeptModel1', {
	    fields: [{name: 'COMP_CODE'					,text:'COMP_CODE'		,type : 'string', defaultValue: UserInfo.compCode},
	             {name: 'DIV_CODE'					,text:'사업장'			,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode},
	    		 {name: 'COST_CENTER_CODE'			,text:'Cost Center'		,type : 'string', store:Ext.data.StoreManager.lookup('costCenterCombo'), editable:false},
	    		 {name: 'DEPT_CODE'					,text:'부서'				,type : 'string', allowBlank:false},
	    		 {name: 'TREE_NAME'					,text:'부서명'			,type : 'string', allowBlank:false},
	    		 {name: 'REMARK'					,text:'비고'				,type : 'string'}
			]
	});	

	//스토어 정의
	var cbm040ukrvDeptStore1 = Unilite.createStore('cbm040ukrvDeptStore1',{
		model: 'cbm040ukrvDeptModel1',
        autoLoad: false,
        uniOpt : {
           	isMaster: true,			// 상위 버튼 연결 
           	editable: false,		// 수정 모드 사용 
           	deletable:false,		// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxyDept1,
        loadStoreRecords : function()	{
        	var sForm = panelDetail.down('#cbm040ukrvsSearch1'); 
			this.load({ params  : sForm.getValues()
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
				panelDetail.down('#cbm040ukrvsDeptGrid1').uniSelectInvalidColumnAndAlert(inValidRecs);
		    }
		},
		listeners:{
			load:function(store, record)	{
				if(record){
					var costCenterGrid = panelDetail.down('#cbm040ukrvsGrid1');
					var selectCostCenterRecord = costCenterGrid.getSelectedRecord();
					var deptGrid = panelDetail.down('#cbm040ukrvsDeptGrid1');
					if(deptGrid && selectCostCenterRecord) {
						deptGrid.selectData(selectCostCenterRecord.get('COST_CENTER_CODE'))
					}
				}
			}
		}
	});
	
	/* Cost Pool 매핑정보 - Cost Pool 목록 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   	read    : 'cbm040ukrvService.selectList2'
		}
	 });

	//모델 정의
	Unilite.defineModel('cbm040ukrvModel2', {
	    fields: [{name: 'COMP_CODE'					,text:'COMP_CODE'		,type : 'string', defaultValue: UserInfo.compCode},
	             {name: 'DIV_CODE'					,text:'사업장'			,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode},
	    		 {name: 'COST_POOL_CODE'			,text:'Cost Pool'		,type : 'string', allowBlank:false},
	    		 {name: 'COST_POOL_NAME'			,text:'Cost Pool명'		,type : 'string', allowBlank:false},
	    		 {name: 'REMARK'					,text:'비고'				,type : 'string'}
			]
	});	

	//스토어 정의
	var cbm040ukrvStore2 = Unilite.createStore('cbm040ukrvStore2',{
		model: 'cbm040ukrvModel2',
        autoLoad: false,
        uniOpt : {
           	isMaster: false,			// 상위 버튼 연결 
           	editable: false,			// 수정 모드 사용 
           	deletable:false,			// 삭제 가능 여부 
            useNavi : false				// prev | next 버튼 사용
        },
        proxy: directProxy2,
        loadStoreRecords : function()	{
        	var sForm = panelDetail.down('#cbm040ukrvsSearch2'); 
			this.load({ params : sForm.getValues()
			});
		}   
	});

	/* Cost Pool 매핑정보 - 작업장 목록 */
	var directProxyRef2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   	read    : 'cbm040ukrvService.selectRefList2',
            update  : 'cbm040ukrvService.updateRef2',
            syncAll : 'cbm040ukrvService.saveAllRef2'
		}
	 });

	//모델 정의
	Unilite.defineModel('cbm040ukrvRefModel2', {
	    fields: [{name: 'COMP_CODE'					,text:'COMP_CODE'		,type : 'string', defaultValue: UserInfo.compCode},
	             {name: 'DIV_CODE'					,text:'사업장'			,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode},
	    		 {name: 'COST_POOL_CODE'			,text:'Cost Pool'		,type : 'string', store:Ext.data.StoreManager.lookup('costPoolCombo'), editable:false},
	    		 {name: 'WORK_SHOP_CD'				,text:'작업장코드'			,type : 'string', allowBlank:false},
	    		 {name: 'WORK_SHOP_NAME'			,text:'작업장명'			,type : 'string', allowBlank:false},
	    		 {name: 'REMARK'					,text:'비고'				,type : 'string'}
			]
	});	

	//스토어 정의
	var cbm040ukrvRefStore2 = Unilite.createStore('cbm040ukrvRefStore2',{
		model: 'cbm040ukrvRefModel2',
        autoLoad: false,
        uniOpt : {
           	isMaster: true,			// 상위 버튼 연결 
           	editable: false,		// 수정 모드 사용 
           	deletable:false,		// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxyRef2,
        loadStoreRecords : function()	{
        	var sForm = panelDetail.down('#cbm040ukrvsSearch2'); 
			this.load({ params : sForm.getValues()
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
				panelDetail.down('#cbm040ukrvsRefGrid2').uniSelectInvalidColumnAndAlert(inValidRecs);
		    }
		},
		listeners:{
			load:function(store, record)	{
				var costPoolGrid = panelDetail.down('#cbm040ukrvsGrid2');
				var selectCostPoolRecord = costPoolGrid.getSelectedRecord();
				var refGrid = panelDetail.down('#cbm040ukrvsRefGrid2');
				if(refGrid) {
					refGrid.selectData(selectCostPoolRecord.get('COST_POOL_CODE'))
				}
			}
		}
	});
	
	/* Cost Pool 매핑정보 - 공통 Cost Pool 목록 */
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   	read    : 'cbm040ukrvService.selectList3'
		}
	 });

	//모델 정의
	Unilite.defineModel('cbm040ukrvModel3', {
	    fields: [{name: 'COMP_CODE'					,text:'COMP_CODE'		,type : 'string', defaultValue: UserInfo.compCode},
	             {name: 'DIV_CODE'					,text:'사업장'			,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode},
	    		 {name: 'COST_POOL_CODE'			,text:'공통 Cost Pool'	,type : 'string', allowBlank:false},
	    		 {name: 'COST_POOL_NAME'			,text:'공통 Cost Pool명'	,type : 'string', allowBlank:false},
	    		 {name: 'REMARK'					,text:'비고'				,type : 'string'}
			]
	});	

	//스토어 정의
	var cbm040ukrvStore3 = Unilite.createStore('cbm040ukrvStore3',{
		model: 'cbm040ukrvModel3',
        autoLoad: false,
        uniOpt : {
           	isMaster: false,			// 상위 버튼 연결 
           	editable: false,			// 수정 모드 사용 
           	deletable:false,			// 삭제 가능 여부 
            useNavi : false				// prev | next 버튼 사용
        },
        proxy: directProxy3,
        loadStoreRecords : function()	{
        	var sForm = panelDetail.down('#cbm040ukrvsSearch3'); 
			this.load({ params  : sForm.getValues()
			});
		}   
	});

	/* Cost Pool 매핑정보 - Cost Pool 목록 */
	var directProxyRef3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   	read    : 'cbm040ukrvService.selectRefList3',
            update  : 'cbm040ukrvService.updateRef3',
            syncAll : 'cbm040ukrvService.saveAllRef3'
		}
	 });

	//모델 정의
	Unilite.defineModel('cbm040ukrvRefModel3', {
	    fields: [{name: 'COMP_CODE'					,text:'COMP_CODE'		,type : 'string', defaultValue: UserInfo.compCode},
	             {name: 'DIV_CODE'					,text:'사업장'			,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode},
	    		 {name: 'DISTR_COST_POOL'			,text:'공통 Cost Pool'	,type : 'string', store:Ext.data.StoreManager.lookup('distrPoolCombo'), editable:false},
	    		 {name: 'COST_POOL_CODE'			,text:'Cost Pool'		,type : 'string', allowBlank:false},
	    		 {name: 'COST_POOL_NAME'			,text:'Cost Pool명'		,type : 'string', allowBlank:false},
	    		 {name: 'REMARK'					,text:'비고'				,type : 'string'}
			]
	});	

	//스토어 정의
	var cbm040ukrvRefStore3 = Unilite.createStore('cbm040ukrvRefStore3',{
		model: 'cbm040ukrvRefModel3',
        autoLoad: false,
        uniOpt : {
           	isMaster: true,			// 상위 버튼 연결 
           	editable: false,		// 수정 모드 사용 
           	deletable:false,		// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxyRef3,
        loadStoreRecords : function()	{
        	var sForm = panelDetail.down('#cbm040ukrvsSearch3'); 
			this.load({ params : sForm.getValues()
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
				panelDetail.down('#cbm040ukrvsRefGrid3').uniSelectInvalidColumnAndAlert(inValidRecs);
		    }
		},
		listeners:{
			load:function(store, record)	{
				var distrPoolGrid = panelDetail.down('#cbm040ukrvsGrid3');
				var selectDistrPoolRecord = distrPoolGrid.getSelectedRecord();
				var refGrid = panelDetail.down('#cbm040ukrvsRefGrid3');
				if(refGrid && selectDistrPoolRecord) {
					refGrid.selectData(selectDistrPoolRecord.get('COST_POOL_CODE'))
				}
			}
		}
	});
	
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
	    	itemId: 'cbm040Tab',
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
					<%@include file="./cbm002ukrv.jsp" %>	//원가기준설정
				]
	    	 }, {
		    	defaults:{
 					xtype: 'uniDetailForm',
				    disabled: false,
					border: 0,
				    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
						margin: '10 10 10 10'
				},
				items:[{
					title: '매핑정보등록',
					itemId: 'tabTitle01',
					border: false						
				},
					<%@include file="./cbm510ukrv.jsp" %>,	//Cost Center 매핑정보등록
					<%@include file="./cbm610ukrv.jsp" %>,	//Cost Pool 매핑정보등록
					<%@include file="./cbm620ukrv.jsp" %>	//Cost Pool 공통정보등록
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
					else {
						if (newCard.itemId == 'tab_cbm510ukrv') {
							UniAppManager.setToolbarButtons(['reset','newData','delete'],false);
							UniAppManager.setToolbarButtons(['query'],true);
						}
						else if(newCard.itemId == 'tab_cbm610ukrv'){
							UniAppManager.setToolbarButtons(['reset','newData','delete'],false);
							UniAppManager.setToolbarButtons(['query'],true);
						}
						else if(newCard.itemId == 'tab_cbm620ukrv'){
							UniAppManager.setToolbarButtons(['reset','newData','delete'],false);
							UniAppManager.setToolbarButtons(['query'],true);
						}
   					 	else {    			 	
							UniAppManager.setToolbarButtons(['reset'],false);
							UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
						}	 	 	
					}
		    	}
		    }
	    }]
    })

	/* 기준코드등록	*/
	Unilite.Main( {
		id: 'cbm040ukrvApp',
		borderItems: [ 
			panelDetail		 	
		], 
		fnInitBinding : function() {				
			UniAppManager.setToolbarButtons(['reset'],false);
			UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
		},
		onQueryButtonDown : function()	{		
			var activeTab = panelDetail.down('#cbm040Tab').getActiveTab();

			/* Cost Center 매핑정보 */
			if (activeTab.getItemId() == 'tab_cbm510ukrv'){
				cbm040ukrvStore1.loadStoreRecords();
				cbm040ukrvDeptStore1.loadStoreRecords();
			/* Cost Pool 매핑정보*/
			} else if (activeTab.getItemId() == 'tab_cbm610ukrv'){
				cbm040ukrvStore2.loadStoreRecords();
				cbm040ukrvRefStore2.loadStoreRecords();
			/* Cost Pool 공통정보*/
			} else if (activeTab.getItemId() == 'tab_cbm620ukrv'){
				cbm040ukrvStore3.loadStoreRecords();
				cbm040ukrvRefStore3.loadStoreRecords();
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
			var activeTab = panelDetail.down('#cbm040Tab').getActiveTab();

			/* Cost Center 추가버튼 클릭  */
			if(activeTab.getItemId() == "tab_costCenter"){
				var sortSeq			= 1;
				var r = {
					SORT_SEQ		: sortSeq
				}
			}
			/* Cost Pool 추가버튼 클릭  */
			else if(activeTab.getId() == 'tab_costPool'){
				var llcSeq			= 1;
				var sortSeq			= 1;
				var r = {
					LLC_SEQ			: llcSeq,
					SORT_SEQ		: sortSeq
				}
//				panelDetail.down('#cbm040ukrvsGrid2').createRow(r);
			}
		},
		onDeleteDataButtonDown : function()	{
			var activeTab = panelDetail.down('#cbm040Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_costCenter"){
//				panelDetail.down('#cbm040ukrvsGrid1').deleteSelectedRow();
				
			}else if(activeTab.getItemId() == "tab_costPool"){
//				panelDetail.down('#cbm040ukrvsGrid2').deleteSelectedRow();
			}	
		},		
		onSaveDataButtonDown: function () {
			var activeTab = panelDetail.down('#cbm040Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_cbm510ukrv"){
				cbm040ukrvDeptStore1.saveStore();
			}
			else if(activeTab.getItemId() == "tab_cbm610ukrv"){
				cbm040ukrvRefStore2.saveStore();
			}
			else if(activeTab.getItemId() == "tab_cbm620ukrv"){
				cbm040ukrvRefStore3.saveStore();
			}	
		},
		loadTabData: function(tab, itemId){
			/* Cost Center */
			if (tab.getItemId() == 'tab_cbm002ukrv'){
				UniAppManager.setToolbarButtons(['reset','newData','delete','excel'],false);
				UniAppManager.setToolbarButtons(['query'],true);
			} else if (tab.getItemId() == 'tab_cbm510ukrv'){
				UniAppManager.setToolbarButtons(['reset','newData','delete','excel'],false);
				UniAppManager.setToolbarButtons(['query'],true);
			} else if (tab.getItemId() == 'tab_cbm610ukrv'){
				UniAppManager.setToolbarButtons(['reset','newData','delete','excel'],false);
				UniAppManager.setToolbarButtons(['query'],true);
			} else if (tab.getItemId() == 'tab_cbm620ukrv'){
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
