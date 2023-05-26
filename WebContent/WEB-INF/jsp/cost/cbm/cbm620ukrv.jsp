<%@page language="java" contentType="text/html; charset=utf-8"%>

	{
		title	: 'Cost Pool 공통정보',
		itemId	: 'tab_cbm620ukrv',
		id		: 'tab_cbm620ukrv',
		xtype	: 'panel',
		layout	: 'border',
		bodyStyle	: {
			'background-color': '#ffffff'
		},
		items	: [{
			xtype: 'uniSearchForm',
			itemId:'cbm040ukrvsSearch3',
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
			itemId:'cbm040ukrvsGrid3',
		    store : cbm040ukrvStore3,
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
						var refGrid = panelDetail.down('#cbm040ukrvsRefGrid3');
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
			itemId:'cbm040ukrvsRefGrid3',
		    store : cbm040ukrvRefStore3,
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
					  {dataIndex: 'DISTR_COST_POOL'		, width: 150},
					  {dataIndex: 'COST_POOL_CODE' 		, width: 150},
					  {dataIndex: 'COST_POOL_NAME' 		, width: 150},
					  {dataIndex: 'APPORTION_SEQ' 		, width: 150},
					  {dataIndex: 'REMARK'				, flex:1}
			],
			listeners:{
				beforeselect: function (grid, record, index, eOpts ) {
					var distrPoolGrid = panelDetail.down('#cbm040ukrvsGrid3');
					if(distrPoolGrid) {
						var selectDistrPool = distrPoolGrid.getSelectedRecord();
						if(!selectDistrPool)	{
							return false;	
						}
					}
					return true;
				},
				select:function( grid, record, index, eOpts ) {
					var distrPoolGrid = panelDetail.down('#cbm040ukrvsGrid3');
					if(distrPoolGrid) {
						var selectDistrPool = distrPoolGrid.getSelectedRecord();
						if(selectDistrPool)	{
							if(!Ext.isEmpty(record.get('DISTR_COST_POOL')) && record.get('DISTR_COST_POOL') != selectDistrPool.get("DISTR_COST_POOL"))	{
								if(confirm('지정된 Cost Pool 이 있습니다. 수정하시겠습니까?'))	{
									record.set('COST_POOL_CODE',selectDistrPool.get("DISTR_COST_POOL"));
								}else {
									grid.deselect(record, true, true);
								}
							} else if(Ext.isEmpty(record.get('DISTR_COST_POOL')))	{
								record.set('DISTR_COST_POOL',selectDistrPool.get("DISTR_COST_POOL"));
							}
						}
					}
				},
				deselect:function(grid, record, index, eOpts)	{
					var distrPoolGrid = panelDetail.down('#cbm040ukrvsGrid3');
					if(distrPoolGrid) {
						var selectDistrPool = distrPoolGrid.getSelectedRecord();
						if(selectDistrPool.get("DISTR_COST_POOL") == record.get('DISTR_COST_POOL'))	{
							if(record.modified)	{
								record.set('DISTR_COST_POOL',record.modified.DISTR_COST_POOL);
							}else {
								record.set('DISTR_COST_POOL','');
							}
						}
					}
				}
				
			},
			selectData:function (distrPoolCode)	{
				var refSelection =[] ;
				Ext.each(this.store.getData().items, function(record, idx){
					if(distrPoolCode == record.get("DISTR_COST_POOL"))	{
						refSelection.push(record);
					}
				});
				if(refSelection)	{
					this.select(refSelection, false, true);
				}
			}
		}]      
	}
