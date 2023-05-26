<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//카드수입금 파일등록(정산일)
request.setAttribute("PKGNAME","Unilite_app_gcd300ukrv");
%>
<t:appConfig pgmId="gcd300ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장   	-->  
	
</t:appConfig>
<script type="text/javascript">
var excelWindow;
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
		//--사업장	운행일	노선그룹	노선	차량	노선코드	노선	현금
	    fields: [
			 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode } 
			,{name: 'CALCULATE_DATE'    	,text:'정산일자'		,type : 'uniDate' ,defaultValue: UniDate.add(UniDate.extParseDate(UniDate.get('startOfMonth')),{days:14})} 
			,{name: 'TOTAL_AMOUNT'    		,text:'총금액 합계'		,type : 'uniPrice'}
			,{name: 'TOTAL_COUNT'    		,text:'총수량'			,type : 'uniQty'}
			,{name: 'REMARK'  				,text:'비고'			,type : 'string'} 
			,{name: 'COMP_CODE'  			,text:'법인코드'		,type : 'string'   ,defaultValue: UserInfo.compCode} 
		]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read 	: 'gcd300ukrvService.selectList',
			create  : 'gcd300ukrvService.insertList',
			update  : 'gcd300ukrvService.updateList',
			destroy  : 'gcd300ukrvService.deleteList',
			syncAll	: 'gcd300ukrvService.saveAll'
		}
	});
    var masterStore =  Unilite.createStore('${PKGNAME}Store',{
        model: '${PKGNAME}Model',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy,
            saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				
				if(inValidRecs.length == 0 )	{
					
						this.syncAllDirect();
				
				}else {
					var grid = Ext.getCmp('${PKGNAME}Grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}SearchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '펀드폴',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '검색조건', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:80
		           	},
			    	items:[{	    
						fieldLabel: '사업장',
						name: 'DIV_CODE',
						hidden:true,
						value:UserInfo.divCode
					},{	    
						fieldLabel: '정산일',
						name: 'CALCULATE_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'CALCULATE_DATE_FR',
			            endFieldName: 'CALCULATE_DATE_TO',	
			            startDate: UniDate.get('today'),
			            endDate: UniDate.get('today'),
			            width:320,
						allowBlank:false
					}]				
				}]
		
	});	//end panelSearch    
	
     var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
        layout : 'fit',        
    	region:'center',
    	store: masterStore,
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
       
		columns:[
			{dataIndex:'DIV_CODE'			,width: 150},
			{dataIndex:'CALCULATE_DATE'		,width: 150},
			{dataIndex:'TOTAL_COUNT'		,width: 150, summaryType: 'sum'},
			{dataIndex:'TOTAL_AMOUNT'		,width: 150, summaryType: 'sum'},
			{dataIndex:'REMARK'				,flex: 1}
		] 
   });
   
	
      Unilite.Main({
		borderItems:[
	 		  panelSearch
	 		 ,masterGrid
		],
		id  : 'gcd300ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'newData', 'delete' ],true);
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
			masterGrid.createRow();
		},	
		
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore();
					
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();				
			}
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