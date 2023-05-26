<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="testskrv001"  >
   <t:ExtComboStore comboType="BOR120" />          <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var BsaCodeInfo = {
//	gsInOutPrsn: '${gsInOutPrsn}'
};
function appMain() {
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('Testskrv001Model', {
		fields: [
		
			{name: ''			    , text: ''				, type: 'string'}
          
		]
	});//End of Unilite.defineModel('Testskrv001Model', {
   
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
	var directMasterStore1 = Unilite.createStore('testskrv001MasterStore1',{
		model: 'Testskrv001Model',
		uniOpt: {
			isMaster: true,         // 상위 버튼 연결 
			editable: false,         // 수정 모드 사용 
			deletable:false,         // 삭제 가능 여부 
			useNavi : false         // prev | newxt 버튼 사용
		},
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {         
					read: 'testskrv001Service.selectList'                   
				}
			},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
	});//End of var directMasterStore1 = Unilite.createStore('testskrv001MasterStore1',{

   /**
    * 검색조건 (Search Panel)
    * @type 
    */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',		
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [
			
			
			]                         
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [
		
		
		]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('testskrv001Grid1', {
       // for tab       
		//layout: 'fit',
		region:'center',
		store: directMasterStore1,
		columns: [
			{dataIndex: ''			    , width: 80}
			
		] 
	});//End of var masterGrid = Unilite.createGrid('testskrv001Grid1', {   

	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id: 'testskrv001App',
		fnInitBinding: function() {
			
		},
		onQueryButtonDown: function() {  
			masterGrid.getStore().loadStoreRecords();
			
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		}
	});//End of Unilite.Main( {
};


</script>