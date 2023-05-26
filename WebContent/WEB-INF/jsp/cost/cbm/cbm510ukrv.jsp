<%@page language="java" contentType="text/html; charset=utf-8"%>

	{
		title	: 'Cost Center 매핑정보',
		itemId	: 'tab_cbm510ukrv',
		id		: 'tab_cbm510ukrv',
		xtype	: 'panel',
		layout	: 'border',
		bodyStyle	: {
			'background-color': '#ffffff'
		},
		items	: [{
			xtype: 'uniSearchForm',
			itemId:'cbm040ukrvsSearch1',
			region:'north',
			
			items:[{
				xtype:'uniCombobox',
				comboType:'BOR120',
				fieldLabel:'사업장',
				name:'DIV_CODE',
				value:UserInfo.divCode
			}]
		},{	
			xtype: 'uniGridPanel',
			region:'west',
			flex:0.4,
			itemId:'cbm040ukrvsGrid1',
		    store : cbm040ukrvStore1,
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
					  {dataIndex: 'COST_CENTER_CODE' 	, width: 100},
					  {dataIndex: 'COST_CENTER_NAME' 	, width: 150},
					  {dataIndex: 'REMARK'				, flex:1}
			],
			listeners:{
				select:function(grid, selected)	{
					if(selected)	{
						var deptGrid = panelDetail.down('#cbm040ukrvsDeptGrid1');
						if(deptGrid) {
							deptGrid.selectData(selected.get('COST_CENTER_CODE'))
						}
					}
				}
			}
		},{	
			xtype: 'uniGridPanel',
			region:'center',
			flex:0.6,
			itemId:'cbm040ukrvsDeptGrid1',
		    store : cbm040ukrvDeptStore1,
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
					  {dataIndex: 'COST_CENTER_CODE' 	, width: 150},
					  {dataIndex: 'REMARK'				, flex:1}
			],
			listeners:{
				beforeselect: function (grid, record, index, eOpts ) {
					var costCenterGrid = panelDetail.down('#cbm040ukrvsGrid1');
					if(costCenterGrid) {
						var selectCostCenter = costCenterGrid.getSelectedRecord();
						if(!selectCostCenter)	{
							return false;	
						}
					}
					return true;
				},
				select:function( grid, record, index, eOpts ) {
					var costCenterGrid = panelDetail.down('#cbm040ukrvsGrid1');
					if(costCenterGrid) {
						var selectCostCenter = costCenterGrid.getSelectedRecord();
						if(selectCostCenter)	{
							if(!Ext.isEmpty(record.get('COST_CENTER_CODE')) && record.get('COST_CENTER_CODE') != selectCostCenter.get("COST_CENTER_CODE"))	{
								if(confirm('지정된 Cost Center 가 있습니다. 수정하시겠습니까?'))	{
									record.set('COST_CENTER_CODE',selectCostCenter.get("COST_CENTER_CODE"));
								}else {
									grid.deselect(record, true, true);
								}
							} else if(Ext.isEmpty(record.get('COST_CENTER_CODE')))	{
								record.set('COST_CENTER_CODE',selectCostCenter.get("COST_CENTER_CODE"));
							}
						}
					}
				},
				deselect:function(grid, record, index, eOpts)	{
					var costCenterGrid = panelDetail.down('#cbm040ukrvsGrid1');
					if(costCenterGrid) {
						var selectCostCenter = costCenterGrid.getSelectedRecord();
						if(selectCostCenter.get("COST_CENTER_CODE") == record.get('COST_CENTER_CODE'))	{
							if(record.modified)	{
								record.set('COST_CENTER_CODE',record.modified.COST_CENTER_CODE);
							}else {
								record.set('COST_CENTER_CODE','');
							}
						}
					}
				}
				
			},
			selectData:function (costCenterCode)	{
				var deptSelection =[] ;
				Ext.each(this.store.getData().items, function(record, idx){
					if(costCenterCode == record.get("COST_CENTER_CODE"))	{
						deptSelection.push(record);
					}
				});
				if(deptSelection)	{
					this.select(deptSelection, false, true);
				}
			}
		}]      
	}
