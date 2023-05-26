<%@page language="java" contentType="text/html; charset=utf-8"%>

	{
		title	: 'Cost Pool 매핑정보',
		itemId	: 'tab_cbm610ukrv',
		id		: 'tab_cbm610ukrv',
		xtype	: 'panel',
		layout	: 'border',
		bodyStyle	: {
			'background-color': '#ffffff'
		},
		items	: [{
			xtype: 'uniSearchForm',
			itemId:'cbm040ukrvsSearch2',
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
			itemId:'cbm040ukrvsGrid2',
		    store : cbm040ukrvStore2,
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
						var refGrid = panelDetail.down('#cbm040ukrvsRefGrid2');
						if(refGrid) {
							refGrid.selectData(selected.get('COST_POOL_CODE'))
						}
					}
				}
			}
		},{	
			xtype: 'uniGridPanel',
			region:'center',
			flex:0.6,
			itemId:'cbm040ukrvsRefGrid2',
		    store : cbm040ukrvRefStore2,
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
					  {dataIndex: 'WORK_SHOP_CD' 		, width: 150},
					  {dataIndex: 'WORK_SHOP_NAME' 		, width: 150},
					  {dataIndex: 'REMARK'				, flex:1}
			],
			listeners:{
				beforeselect: function (grid, record, index, eOpts ) {
					var costPoolGrid = panelDetail.down('#cbm040ukrvsGrid2');
					if(costPoolGrid) {
						var selectCostPool = costPoolGrid.getSelectedRecord();
						if(!selectCostPool)	{
							return false;	
						}
					}
					return true;
				},
				select:function( grid, record, index, eOpts ) {
					var costPoolGrid = panelDetail.down('#cbm040ukrvsGrid2');
					if(costPoolGrid) {
						var selectCostPool = costPoolGrid.getSelectedRecord();
						if(selectCostPool)	{
							if(!Ext.isEmpty(record.get('COST_POOL_CODE')) && record.get('COST_POOL_CODE') != selectCostCenter.get("COST_POOL_CODE"))	{
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
					var costPoolGrid = panelDetail.down('#cbm040ukrvsGrid2');
					if(costPoolGrid) {
						var selectCostPool = costPoolGrid.getSelectedRecord();
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
		}]      
	}
