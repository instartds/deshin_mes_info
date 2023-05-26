<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//정비요청
request.setAttribute("PKGNAME","Unilite_app_gme100ukrv");
%>
<t:appConfig pgmId="gme100ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO27"/>				<!-- 작업조  	-->	
	<t:ExtComboStore comboType="AU" comboCode="GO28"/>				<!-- 전문직종  	-->	
	<t:ExtComboStore comboType="AU" comboCode="GO29"/>				<!-- 숙련도  	-->	
	<t:ExtComboStore comboType="AU" comboCode="GO30"/>				<!-- 담당자구분  	-->	
</t:appConfig>
<script type="text/javascript">
var activeGrid;
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
	    fields: [
			 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
			,{name: 'MECHANIC_CODE'    		,text:'사번'			,type : 'string'  ,editable:false } 
			,{name: 'MECHANIC_NAME'    		,text:'성명'			,type : 'string'  ,editable:false }
			,{name: 'SKILL'    				,text:'숙련도'			,type : 'string' ,comboType: 'AU', comboCode:'GO29'} 					
			,{name: 'LATEST_PROMOTION_DATE' ,text:'최근승급일'		,type : 'uniDate' } 	
			,{name: 'WORK_TEAM'    			,text:'작업조'			,type : 'string' ,comboType: 'AU', comboCode:'GO27'}
			,{name: 'SKILL_FIELD'    		,text:'전문직종'		,type : 'string' ,comboType: 'AU', comboCode:'GO28'} 	
			,{name: 'CHARGE_TYPE'    		,text:'담당구분'		,type : 'string' ,comboType: 'AU', comboCode:'GO30'} 	
			,{name: 'CNG_EDU_DATE'    		,text:'CNG교육일'		,type : 'uniDate' }
			,{name: 'REMARK' 				,text:'비고'			,type : 'string' } 
		]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'gme100ukrvService.selectList',
			update	: 'gme100ukrvService.update',
			syncAll	: 'gme100ukrvService.saveAll'
		}
	});
    var masterStore =  Unilite.createStore('${PKGNAME}store',{
        model: '${PKGNAME}Model',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy,
      
			loadStoreRecords: function(record)	{				
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}		
			},
			saveStore:function(config)	{
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0) {
					this.syncAllDirect(config);
				}
			}
            
		});

	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '정비사정보',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '검색조건', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		   			height:160,
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:90
		           	},
			    	items:[{	    
						fieldLabel: '사업장',
						name: 'DIV_CODE',
						xtype:'uniCombobox',
						comboType:'BOR120',
						value: UserInfo.divCode,
						allowBlank:false
					},{	    
						fieldLabel: '성명',
						name: 'MECHANIC_NAME'
					},{	    
						fieldLabel: '작업조',
						name: 'WORK_TEAM',
						xtype:'uniCombobox',
						comboType:'AU',
						comboCode:'GO27'
					},{	    
						fieldLabel: '숙련도',
						name: 'SKILL'	,
						xtype:'uniCombobox',
						comboType:'AU',
						comboCode:'GO29'
					},{	    
						fieldLabel: '담당자구분',
						name: 'CHARGE_TYPE'	,
						xtype:'uniCombobox',
						comboType:'AU',
						comboCode:'GO30'
					}]				
				}]

	});	//end panelSearch    

	var masterGrid = Unilite.createGrid('${PKGNAME}grid', { 
		region:'center',
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
            state: {
			   useState: false,   
			   useStateList: false  
			}
            
        },
    	store: masterStore,
		columns:[
			{dataIndex:'MECHANIC_CODE'			,width: 100},
			{dataIndex:'MECHANIC_NAME'			,width: 100},
			{dataIndex:'WORK_TEAM'				,width: 100},
			{dataIndex:'SKILL_FIELD'			,width: 120},
			{dataIndex:'SKILL'					,width: 100},
			{dataIndex:'LATEST_PROMOTION_DATE'	,width: 100},
			{dataIndex:'CHARGE_TYPE'			,width: 100},
			{dataIndex:'CNG_EDU_DATE'			,width: 100},			
			{dataIndex:'REMARK'					,flex: 1}
		]

   });	
      Unilite.Main({
		borderItems:[
	 		  panelSearch,
	 		  masterGrid
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['print', 'excel', 'newData'],false);
			
		},
		
		onQueryButtonDown : function()	{
			masterStore.loadStoreRecords();
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},	
		onNewDataButtonDown:  function()	{	
			
		},	
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore(config);					
		},
		onDeleteDataButtonDown : function()	{
			
		},
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			masterGrid.reset();
			
			UniAppManager.setToolbarButtons('save',false);
		},
		rejectSave: function() {	
			masterStore.rejectChanges();	
			masterStore.onStoreActionEnable();
		}
	});
}; // main

</script>