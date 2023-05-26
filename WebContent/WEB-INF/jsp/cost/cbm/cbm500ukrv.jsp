<%@page language="java" contentType="text/html; charset=utf-8"%>

	{
		title	: 'Cost Center 정보등록',
		itemId	: 'tab_costCenter',
		id		: 'tab_costCenter',
		xtype	: 'uniDetailForm',
//		api		: {load: 'cbm030ukrvService.select1'},
		layout	: {type: 'vbox', align:'stretch'},
		items	: [{
			xtype:'container',
			style: {
				color: 'blue'				
			}
		}, {	
			xtype: 'uniGridPanel',
			itemId:'cbm030ukrvsGrid1',
		    store : cbm030ukrvStore1,
		    uniOpt: {			
			    useMultipleSorting	: true,		
			    useLiveSearch		: true,		
			    onLoadSelectFirst	: true,			
			    dblClickToEdit		: true,		
			    useGroupSummary		: true,		
				useContextMenu		: false,	
				useRowNumberer		: true,	
				expandLastColumn	: true,		
				useRowContext		: true,	
				copiedRow			: true,
			    filter: {				
					useFilter		: false,
					autoCreate		: false
				}			
			},		        
			columns: [{dataIndex: 'COMP_CODE'			, width: 100,		hidden: true},
					  {dataIndex: 'DIV_CODE'  			, width: 150},
					  {dataIndex: 'COST_CENTER_CODE' 	, width: 100},
					  {dataIndex: 'COST_CENTER_NAME' 	, width: 150},
					  {dataIndex: 'MAKE_SALE' 			, width: 100},
					  {dataIndex: 'COST_POOL_GB' 		, width: 100},
					  {dataIndex: 'SORT_SEQ' 			, width: 80},
					  {dataIndex: 'REMARK'				, width: 200},
					  {dataIndex: 'UPDATE_DB_USER'		, width: 100,		hidden: true},
					  {dataIndex: 'UPDATE_DB_TIME'		, width: 100,		hidden: true}
			],
			listeners:{
				beforeedit  : function( editor, e, eOpts ) {
					if(UniUtils.indexOf(e.field, ['SUB_CODE', 'CODE_NAME', 'USE_YN'])){
						if(e.record.phantom){
							return true;
						}else{
							return false;
						}
					}
				}	
			}
		}]      
	}
