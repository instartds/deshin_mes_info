<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cbm710ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="CD03" />	<!-- 원가담당자 -->	
	<t:ExtComboStore comboType="AU" comboCode="CC05" />	<!-- 재료비적용단가 -->	
	<t:ExtComboStore comboType="AU" comboCode="C101" />	<!-- 간접재료비 배부유형 -->
	<t:ExtComboStore items="${COST_POOL_COMBO}"   storeId="costPoolCombo" />	
</t:appConfig>	
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {     
	/* Cost Center 매핑정보 - Cost Center 목록*/
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   	read    : 'cbm710ukrvService.selectList1'
		}
	 });

	//모델 정의
	Unilite.defineModel('cbm710ukrvModel1', {
	    fields: [{name: 'COMP_CODE'					,text:'COMP_CODE'		,type : 'string', defaultValue: UserInfo.compCode},
	             {name: 'DIV_CODE'					,text:'사업장'			,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode},
	    		 {name: 'COST_POOL_CODE'			,text:'부문'			,type : 'string', allowBlank:false},
	    		 {name: 'COST_POOL_NAME'			,text:'부문명'			,type : 'string', allowBlank:false},
	    		 {name: 'REMARK'					,text:'비고'				,type : 'string'}
			]
	});	

	//스토어 정의
	var cbm710ukrvStore1 = Unilite.createStore('cbm040ukrvStore1',{
		model: 'cbm710ukrvModel1',
        autoLoad: true,
        uniOpt : {
           	isMaster: false,			// 상위 버튼 연결 
           	editable: false,			// 수정 모드 사용 
           	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxy1,
        loadStoreRecords : function()	{
			this.load({ params : panelResult.getValues()
			});
		}   
	});

	/* Cost Center 매핑정보 - 부서 목록 */
	var directProxyDept1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   	read    : 'cbm710ukrvService.selectDeptList1',
            update  : 'cbm710ukrvService.updateDept1',
            syncAll : 'cbm710ukrvService.saveAllDept1'
		}
	 });

	//모델 정의
	Unilite.defineModel('cbm710ukrvDeptModel1', {
	    fields: [{name: 'COMP_CODE'					,text:'COMP_CODE'		,type : 'string', defaultValue: UserInfo.compCode},
	             {name: 'DIV_CODE'					,text:'사업장'			,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode},
	    		 {name: 'COST_POOL_CODE'			,text:'부문'				,type : 'string', store:Ext.data.StoreManager.lookup('costPoolCombo'), editable:false},
	    		 {name: 'DEPT_CODE'					,text:'부서'				,type : 'string', allowBlank:false},
	    		 {name: 'TREE_NAME'					,text:'부서명'			,type : 'string', allowBlank:false},
	    		 {name: 'REMARK'					,text:'비고'				,type : 'string'}
			]
	});	

	//스토어 정의
	var cbm710ukrvDeptStore1 = Unilite.createStore('cbm710ukrvDeptStore1',{
		model: 'cbm710ukrvDeptModel1',
        autoLoad: true,
        uniOpt : {
           	isMaster: true,			// 상위 버튼 연결 
           	editable: false,		// 수정 모드 사용 
           	deletable:false,		// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxyDept1,
        loadStoreRecords : function()	{
			this.load({ params  : panelResult.getValues()
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
				if(record){
					var selectCostCenterRecord = masterGrid1.getSelectedRecord();
					//var deptGrid = panelDetail.down('#cbm710ukrvsDeptGrid1');
					if(masterGrid2 && selectCostCenterRecord) {
						masterGrid2.selectData(selectCostCenterRecord.get('COST_POOL_CODE'))
					}
				}
			}
		}
	});
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
			
			itemId:'cbm040ukrvsSearch1',
			region:'north',
			layout : {type : 'uniTable', columns : 3},
			padding:'1 1 1 1',
			border:true,
			items:[{
				xtype:'uniCombobox',
				comboType:'BOR120',
				fieldLabel:'사업장',
				name:'DIV_CODE',
				value:UserInfo.divCode
			}]
		});
	var masterGrid1 = Unilite.createGrid('cbm710ukrvGrid1', {	
			region:'center',
			flex:0.4,
			itemId:'cbm710ukrvGrid1',
		    store : cbm710ukrvStore1,
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
					  {dataIndex: 'COST_POOL_CODE' 	, width: 150},
					  {dataIndex: 'COST_POOL_NAME' 	, width: 150},
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
		var masterGrid2= Unilite.createGrid('cbm710ukrvGrid2', {	
			region:'east',
			flex:0.6,
			itemId:'cbm710ukrvsDeptGrid1',
		    store : cbm710ukrvDeptStore1,
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
					  {dataIndex: 'DEPT_CODE' 	, width: 150},
					  {dataIndex: 'TREE_NAME' 	, width: 150},
					  {dataIndex: 'COST_POOL_CODE' 	, width: 150},
					  {dataIndex: 'REMARK'				, flex:1}
			],
			listeners:{
				beforeselect: function (grid, record, index, eOpts ) {
					if(masterGrid1) {
						var selectCostCenter = masterGrid1.getSelectedRecord();
						if(!selectCostCenter)	{
							return false;	
						}
					}
					return true;
				},
				select:function( grid, record, index, eOpts ) {
					if(masterGrid1) {
						var selectCostCenter = masterGrid1.getSelectedRecord();
						if(selectCostCenter)	{
							if(!Ext.isEmpty(record.get('COST_POOL_CODE')) && record.get('COST_POOL_CODE') != selectCostCenter.get("COST_POOL_CODE"))	{
								if(confirm('지정된 부문이 있습니다. 수정하시겠습니까?'))	{
									record.set('COST_POOL_CODE',selectCostCenter.get("COST_POOL_CODE"));
								}else {
									grid.deselect(record, true, true);
								}
							} else if(Ext.isEmpty(record.get('COST_POOL_CODE')))	{
								record.set('COST_POOL_CODE',selectCostCenter.get("COST_POOL_CODE"));
							}
						}
					}
				},
				deselect:function(grid, record, index, eOpts)	{
					if(masterGrid1) {
						var selectCostCenter = masterGrid1.getSelectedRecord();
						if(selectCostCenter.get("COST_POOL_CODE") == record.get('COST_POOL_CODE'))	{
							if(record.modified)	{
								record.set('COST_POOL_CODE',record.modified.COST_POOL_CODE);
							}else {
								record.set('COST_POOL_CODE','');
							}
						}
					}
				}
				
			},
			selectData:function (costCenterCode)	{
				var deptSelection =[] ;
				Ext.each(this.store.getData().items, function(record, idx){
					if(costCenterCode == record.get("COST_POOL_CODE"))	{
						deptSelection.push(record);
					}
				});
				if(deptSelection)	{
					this.select(deptSelection, false, true);
				}
			}
		});

	/* 기준코드등록	*/
	Unilite.Main( {
		id: 'cbm710ukrvApp',
		borderItems: [ 
			panelResult, masterGrid1, masterGrid2		 	
		], 
		fnInitBinding : function() {				
			UniAppManager.setToolbarButtons(['reset','newData','delete'],false);
			UniAppManager.setToolbarButtons(['query'],true);
		},
		onQueryButtonDown : function()	{		

			cbm710ukrvStore1.loadStoreRecords();
			cbm710ukrvDeptStore1.loadStoreRecords();
			
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
			var llcSeq			= 1;
			var sortSeq			= 1;
			var r = {
				LLC_SEQ			: llcSeq,
				SORT_SEQ		: sortSeq
			}
			masterGrid2.createRow(r);
		},
		onDeleteDataButtonDown : function()	{
			masterGrid2.deleteSelectedRow();
		},		
		onSaveDataButtonDown: function () {
			masterGrid2.getStore().saveStore();
				
		}
	});
};
</script>
