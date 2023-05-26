<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cbm720ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="CD03" />	<!-- 원가담당자 -->	
	<t:ExtComboStore comboType="AU" comboCode="CC05" />	<!-- 재료비적용단가 -->	
	<t:ExtComboStore comboType="AU" comboCode="C101" />	<!-- 간접재료비 배부유형 -->
	<t:ExtComboStore items="${COST_POOL_COMBO}"   storeId="costPoolCombo" />	
</t:appConfig>	
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {     

	
	/* Cost Pool 매핑정보 - Cost Pool 목록 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   	read    : 'cbm720ukrvService.selectList2'
		}
	 });

	//모델 정의
	Unilite.defineModel('cbm720ukrvModel2', {
	    fields: [{name: 'COMP_CODE'					,text:'COMP_CODE'		,type : 'string', defaultValue: UserInfo.compCode},
	             {name: 'DIV_CODE'					,text:'사업장'			,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode},
	    		 {name: 'COST_POOL_CODE'			,text:'부문'				,type : 'string', allowBlank:false},
	    		 {name: 'COST_POOL_NAME'			,text:'부문명'			,type : 'string', allowBlank:false},
	    		 {name: 'REMARK'					,text:'비고'				,type : 'string'}
			]
	});	

	//스토어 정의
	var cbm720ukrvStore2 = Unilite.createStore('cbm720ukrvStore2',{
		model: 'cbm720ukrvModel2',
        autoLoad: false,
        uniOpt : {
           	isMaster: false,			// 상위 버튼 연결 
           	editable: false,			// 수정 모드 사용 
           	deletable:false,			// 삭제 가능 여부 
            useNavi : false				// prev | next 버튼 사용
        },
        proxy: directProxy2,
        loadStoreRecords : function()	{
			this.load({ params : panelResult.getValues()
			});
		}   
	});

	/* Cost Pool 매핑정보 - 작업장 목록 */
	var directProxyRef2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   	read    : 'cbm720ukrvService.selectRefList2',
            update  : 'cbm720ukrvService.updateRef2',
            syncAll : 'cbm720ukrvService.saveAllRef2'
		}
	 });

	//모델 정의
	Unilite.defineModel('cbm720ukrvRefModel2', {
	    fields: [{name: 'COMP_CODE'					,text:'COMP_CODE'			,type : 'string', defaultValue: UserInfo.compCode},
	             {name: 'DIV_CODE'					,text:'사업장'				,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode},
	    		 {name: 'COST_POOL_CODE'			,text:'부문'					,type : 'string', store:Ext.data.StoreManager.lookup('costPoolCombo'), editable:false},
	    		 {name: 'SECTION_CD'				,text:'작업부서코드'			,type : 'string', allowBlank:false},
	    		 {name: 'SECTION_NAME'				,text:'작업부서(작업장그룹)명'	,type : 'string', allowBlank:false},
	    		 {name: 'REMARK'					,text:'비고'					,type : 'string'}
			]
	});	

	//스토어 정의
	var cbm720ukrvRefStore2 = Unilite.createStore('cbm720ukrvRefStore2',{
		model: 'cbm720ukrvRefModel2',
        autoLoad: false,
        uniOpt : {
           	isMaster: true,			// 상위 버튼 연결 
           	editable: false,		// 수정 모드 사용 
           	deletable:false,		// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxyRef2,
        loadStoreRecords : function()	{
        	 
			this.load({ params : panelResult.getValues()
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
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
		    }
		},
		listeners:{
			load:function(store, record)	{
				var selectCostPoolRecord = masterGrid1.getSelectedRecord();
				if(masterGrid2) {
					masterGrid2.selectData(selectCostPoolRecord.get('COST_POOL_CODE'))
				}
			}
		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region:'north',
		items:[{
			xtype:'uniCombobox',
			comboType:'BOR120',
			fieldLabel:'사업장',
			name:'DIV_CODE',
			value:UserInfo.divCode
		}]
	});
	
	var masterGrid1 = Unilite.createGrid('cbm710ukrvGrid1', {	
		region:'west',
		flex:0.4,
		itemId:'cbm720ukrvsGrid2',
	    store : cbm720ukrvStore2,
	    selModel:'rowmodel',
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
		columns: [{dataIndex: 'DIV_CODE'  			, width: 150,		hidden: true},
				  {dataIndex: 'COST_POOL_CODE' 		, width: 100},
				  {dataIndex: 'COST_POOL_NAME' 		, width: 150},
				  {dataIndex: 'REMARK'				, flex:1}
		],
		listeners:{
			select:function(grid, selected)	{
				if(selected)	{
					if(masterGrid2) {
						masterGrid2.selectData(selected.get('COST_POOL_CODE'))
					}
				}
			}
		}
	});
	
	var masterGrid2 = Unilite.createGrid('cbm710ukrvGrid2', {	
		region:'center',
		flex:0.6,
		itemId:'cbm720ukrvsRefGrid2',
	    store : cbm720ukrvRefStore2,
	    selModel:Ext.create("Ext.selection.CheckboxModel", { checkOnly : true }),
	    uniOpt: {			
		    useMultipleSorting	: true,		
		    useLiveSearch		: true,		
		    onLoadSelectFirst	: false,			
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
		columns: [{dataIndex: 'DIV_CODE'  			, width: 150,		hidden: true},
				  {dataIndex: 'COST_POOL_CODE' 		, width: 150},
				  {dataIndex: 'SECTION_CD' 		, width: 150},
				  {dataIndex: 'SECTION_NAME' 		, width: 150},
				  {dataIndex: 'REMARK'				, flex:1}
		],
		listeners:{
			beforeselect: function (grid, record, index, eOpts ) {
				if(masterGrid1) {
					var selectCostPool = masterGrid1.getSelectedRecord();
					if(!selectCostPool)	{
						return false;	
					}
				}
				return true;
			},
			select:function( grid, record, index, eOpts ) {
				if(masterGrid1) {
					var selectCostPool = masterGrid1.getSelectedRecord();
					if(selectCostPool)	{
						if(!Ext.isEmpty(record.get('COST_POOL_CODE')) && record.get('COST_POOL_CODE') != selectCostPool.get("COST_POOL_CODE"))	{
							if(confirm('지정된 Cost Pool 이 있습니다. 수정하시겠습니까?'))	{
								record.set('COST_POOL_CODE',selectCostPool.get("COST_POOL_CODE"));
							}else {
								grid.deselect(record, true, true);
							}
						} else if(Ext.isEmpty(record.get('COST_POOL_CODE')))	{
							record.set('COST_POOL_CODE',selectCostPool.get("COST_POOL_CODE"));
						}
					}
				}
			},
			deselect:function(grid, record, index, eOpts)	{
				if(masterGrid1) {
					var selectCostPool = masterGrid1.getSelectedRecord();
					if(selectCostPool.get("COST_POOL_CODE") == record.get('COST_POOL_CODE'))	{
						if(record.modified)	{
							record.set('COST_POOL_CODE',record.modified.COST_POOL_CODE);
						}else {
							record.set('COST_POOL_CODE','');
						}
					}
				}
			}
			
		},
		selectData:function (costPoolCode)	{
			var refSelection =[] ;
			Ext.each(this.store.getData().items, function(record, idx){
				if(costPoolCode == record.get("COST_POOL_CODE"))	{
					refSelection.push(record);
				}
			});
			if(refSelection)	{
				this.select(refSelection, false, true);
			}
		}
	});

	Unilite.Main( {
		id: 'cbm720ukrvApp',
		borderItems: [ 
			panelResult, masterGrid1, masterGrid2		 	
		], 
		fnInitBinding : function() {				
			UniAppManager.setToolbarButtons(['reset','newData','delete'],false);
			UniAppManager.setToolbarButtons(['query'],true);
		},
		onQueryButtonDown : function()	{		
			
				cbm720ukrvStore2.loadStoreRecords();
				cbm720ukrvRefStore2.loadStoreRecords();
			
		},
		onNewDataButtonDown : function()	{
			
				var llcSeq			= 1;
				var sortSeq			= 1;
				var r = {
					LLC_SEQ			: llcSeq,
					SORT_SEQ		: sortSeq
				}
				masterGrid1.down('#cbm720ukrvsGrid2').createRow(r);
		},
		onDeleteDataButtonDown : function()	{
			masterGrid1.deleteSelectedRow();
		},		
		onSaveDataButtonDown: function () {
			masterGrid2.getStore().saveStore();	
		}
	});
};
</script>
