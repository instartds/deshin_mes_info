<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cbm700ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A020" />	<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="CD20" /> <!-- 제조/판관 -->
	<t:ExtComboStore comboType="AU" comboCode="CD21" /> <!-- CostPool구분(직접/간접) -->
	<t:ExtComboStore comboType="AU" comboCode="CD27" /> <!-- 공통CostPool구분(전체공통/직과공통) -->
	<t:ExtComboStore comboType="AU" comboCode="CD22" /> <!-- 공통CostPool배부유형 -->
</t:appConfig>	
<script type="text/javascript" >

function appMain() {     

	/* Cost Pool 정보 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read    : 'cbm700ukrvService.selectList2',
			create  : 'cbm700ukrvService.insertDetail2',
			update  : 'cbm700ukrvService.updateDetail2',
			destroy : 'cbm700ukrvService.deleteDetail2',
			syncAll : 'cbm700ukrvService.saveAll2'
		}
 	});	

	/* Cost Pool 정보 */
	//모델 정의
	Unilite.defineModel('cbm700ukrvModel2', {
	    fields: [{name: 'COMP_CODE'					,text:'COMP_CODE'		,type : 'string', defaultValue: UserInfo.compCode},
	             {name: 'DIV_CODE'					,text:'사업장'			,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode},
	    		 {name: 'COST_POOL_CODE'			,text:'부문'				,type : 'string', allowBlank:false},
	    		 {name: 'COST_POOL_NAME'			,text:'부문명'			,type : 'string', allowBlank:false},
	    		 {name: 'COST_POOL_GB'				,text:'부문구분'			,type : 'string', allowBlank:false, comboType:'AU', comboCode:'CD21'},
	    		 {name: 'ALLOCATION_YN'				,text:'배부대상여부'		,type : 'string', comboType:'AU', comboCode:'A020', defaultValue:'N'},
				 {name: 'SUMMARY_YN'				,text:'간접비집계포함'		,type : 'string', comboType:'AU', comboCode:'A020', defaultValue:'N'},
				 {name: 'USE_YN'					,text:'사용여부'			,type : 'string', comboType:'AU', comboCode:'A020', defaultValue:'Y'},
				 {name: 'SORT_SEQ'					,text:'정렬순서'			,type : 'int'},
	    		 {name: 'REMARK'					,text:'비고'				,type : 'string'}
			]
	});	

	//스토어 정의
	var cbm700ukrvStore2 = Unilite.createStore('cbm700ukrvStore2',{
		model: 'cbm700ukrvModel2',
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
						UniAppManager.setToolbarButtons('save', false);   
					} 
				};     
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
		    }
		}    
	});

	var masterGrid = Unilite.createGrid('cbm700ukrvGrid', {
		itemId:'cbm700ukrvsGrid2',
	    store : cbm700ukrvStore2,
	    layout:'fit',
	    region:'center',
	    uniOpt: {			
		    useMultipleSorting	: true,		
		    useLiveSearch		: true,		
		    onLoadSelectFirst	: true,			
		    dblClickToEdit		: true,		
		    useGroupSummary		: false,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
			useRowContext		: true,	
			copiedRow			: true,
		    filter: {				
				useFilter		: false,
				autoCreate		: false
			}			
		},		        
		columns: [{dataIndex: 'COMP_CODE'			, width: 100,		hidden: true},
				  {dataIndex: 'DIV_CODE'  			, width: 150},
				  {dataIndex: 'COST_POOL_CODE' 		, width: 100},
				  {dataIndex: 'COST_POOL_NAME' 		, width: 150},
				  {dataIndex: 'COST_POOL_GB' 		, width: 100},  
				  {dataIndex: 'ALLOCATION_YN' 		, width: 120},  
				  {dataIndex: 'SUMMARY_YN' 			, width: 120},  
				  {dataIndex: 'SORT_SEQ' 			, width: 80},
				  {dataIndex: 'USE_YN' 				, width: 80},
				  {dataIndex: 'REMARK'				, width: 200}
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if(e.field == 'COST_POOL_CODE'){
					if(e.record.phantom){
						return true;
					}else{
						return false;
					}
				}
			}	
		}
	});

	/* 기준코드등록	*/
	Unilite.Main( {
		id 			: 'cbm700ukrvApp',
		borderItems : [ 
			masterGrid		 	
		], 
		fnInitBinding : function() {				
			UniAppManager.setToolbarButtons(['reset'],false);
			UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
		},
		onQueryButtonDown : function()	{		
			cbm700ukrvStore2.loadStoreRecords();
		},
		onNewDataButtonDown : function()	{
			var sortSeq			= 1;
			var costPoolGb      = '02';
			
			var r = {
				SORT_SEQ		: sortSeq,
				COST_POOL_GB    : costPoolGb
			}
			masterGrid.createRow(r);
		
		},
		onDeleteDataButtonDown : function()	{
			masterGrid.deleteSelectedRow();
		},		
		onSaveDataButtonDown: function () {
			cbm700ukrvStore2.saveStore();
		}
	});
	Unilite.createValidator('validator01', {
		store : cbm700ukrvStore2,
		grid:  masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, ePanel, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var sAccnt = record.get("ACCNT");
			
			if(fieldName=='SUMMARY_CODE')	{
				if(newValue != '')	{
					if( newValue != "51" ) {					
						record.set("SUM_DEFINE_CODE", "");			//SUMMARY_CODE가 51인 경우만 입력
					}
					if(newValue == "06") {
						record.set("ID_GB", "1");
					} else {
						record.set("ID_GB", "2");
					}
				}
			} else if( fieldName == 'ALLOCATION_CODE' ) {
				if(newValue != '')	{
					if( newValue != "51" ) {					
						record.set("ALL_DEFINE_CODE", "");			//ALLOCATION_CODE가 51인 경우만 입력
					}
				}
			}
			return rv;
		}
	});
};
</script>