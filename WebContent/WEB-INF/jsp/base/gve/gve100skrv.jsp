<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//차량정보 등록
request.setAttribute("PKGNAME","Unilite_app_gve100ukrv");
%>
<t:appConfig pgmId="gve100ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO13"/>				<!-- 운행/폐지 구분  	-->	
</t:appConfig>
<script type="text/javascript">
function appMain() {

	
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'<t:message code="system.label.base.division" default="사업장"/>'			,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
					,{name: 'VEHICLE_CODE'    		,text:'차량코드'		,type : 'string'  ,editable:false} 
					,{name: 'VEHICLE_NAME'    		,text:'차량명'			,type : 'string' ,allowBlank:false} 					
					,{name: 'VEHICLE_REGIST_NO'    	,text:'차량등록번호'	,type : 'string' ,allowBlank:false } 
					,{name: 'VEHICLE_TYPE'    		,text:'차종'			,type : 'string' ,comboType: 'AU' ,comboCode: 'GO06'} 					
					,{name: 'VEHICLE_MODEL'    		,text:'차명'			,type : 'string' }
					,{name: 'PERIODIC_INSPEC_DATE'  ,text:'정기검사일'		,type : 'uniDate' }
					,{name: 'ROUTINE_CHECK_DATE'    ,text:'정기점검일'		,type : 'uniDate' } 					
					,{name: 'MID_INSPEC_DATE'    	,text:'중간점검일'		,type : 'uniDate' }
					,{name: 'CNG_INSPEC_DATE'    	,text:'CNG검사일'		,type : 'uniDate' } 
					,{name: 'REMARK'  				,text:'<t:message code="system.label.base.remarks" default="비고"/>'			,type : 'string'} 
					,{name: 'COMP_CODE'  			,text:'<t:message code="system.label.base.companycode" default="법인코드"/>'		,type : 'string'  ,allowBlank:false ,defaultValue: UserInfo.compCode} 
			]
	});


    var masterStore =  Unilite.createStore('${PKGNAME}store',{
        model: '${PKGNAME}model',
         autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
            	type: 'direct',
            	api: {
					read 	: 'gve100skrvService.selectList'
            	}
			},
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
            
		});
	Ext.create('Ext.data.Store', {
		storeId:"CHECK_GUBUN",
	    fields: ['text', 'value'],
	    data : [
	        {text:"정기검사",   value:"PERIODIC"},
	        {text:"정기점검일", value:"ROUTINE"},
	        {text:"정기검사",   value:"MID"},
	        {text:"정기점검일", value:"CNG"}
	    ]
	});

				
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '검사대상차량',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:90
		           	},
			    	items:[{	    
						fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
						name: 'DIV_CODE',
						xtype:'uniCombobox',
						comboType:'BOR120',
						value: UserInfo.divCode,
						allowBlank:false
					},{	    
						fieldLabel: '차량코드',
						name: 'VEHICLE_CODE'	
					},{	    
						fieldLabel: '차량명',
						name: 'VEHICLE_NAME'	
					},{	    
						fieldLabel: '차량등록번호',
						name: 'VEHICLE_REGIST_NO'	
					},{
						fieldLabel: '검사구분',
						name: 'CHECK_GUBUN'	,
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('CHECK_GUBUN'),
						multiSelect: true,
						typeAhead: false
					
					},{	    
						fieldLabel: '검사일',
						name: 'INSPEC_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'INSPEC_DATE_FR',
			            endFieldName: 'INSPEC_DATE_TO',	
			            startDate: UniDate.get('today'),
			            endDate: UniDate.get('today'),
			            width:320,
						allowBlank:false,
						height:22
					}]				
				}]

	});	//end panelSearch    
	
     var masterGrid = Unilite.createGrid('${PKGNAME}grid', {
        layout : 'fit',        
    	region:'center',
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
    	store: masterStore,
		columns:[
			{dataIndex:'DIV_CODE'				,width: 100},
			{dataIndex:'VEHICLE_CODE'			,width: 80},
			{dataIndex:'VEHICLE_NAME'			,width: 80 },
			{dataIndex:'VEHICLE_REGIST_NO'		,width: 120 },
			{dataIndex:'VEHICLE_TYPE'			,width: 60},
			{dataIndex:'VEHICLE_MODEL'			,width: 140},
			{dataIndex:'PERIODIC_INSPEC_DATE'	,width: 100},
			{dataIndex:'ROUTINE_CHECK_DATE'		,width: 100},
			{dataIndex:'MID_INSPEC_DATE'		,width: 100},
			{dataIndex:'CNG_INSPEC_DATE'		,width: 100},
			{dataIndex:'REMARK'					,flex: 1}
			
		] 
     })
     
      Unilite.Main({
		borderItems:[
	 		  panelSearch
	 		 ,masterGrid
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'newData', 'excel' ],true);
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
			masterStore.saveStore();
					
		},
		onDeleteDataButtonDown : function()	{
			
		},
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			masterGrid.reset();
			UniAppManager.setToolbarButtons('save',false);
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		}
	});

	
	
}; // main
  
</script>