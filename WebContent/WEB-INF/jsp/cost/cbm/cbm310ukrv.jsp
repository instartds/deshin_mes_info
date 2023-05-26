<%@page language="java" contentType="text/html; charset=utf-8"%>

	{
		title	: '품목별배부율등록',
		itemId	: 'tab_distRate',
		id		: 'tab_distRate',
		xtype	: 'uniDetailForm',
//		api		: {load: 'cbm050ukrvService.select2'},
		layout	: {type: 'vbox', align:'stretch'},
		items	: [{
			xtype:'container',
			style: {
				color: 'blue'				
			}
		}, {	
			xtype: 'uniGridPanel',
			itemId:'cbm050ukrvsGrid2',
		    store : cbm050ukrvStore2,
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
			columns: [
				{dataIndex: 'COMP_CODE'		, width: 100,		hidden: true},
				{dataIndex: 'DIV_CODE'		, width: 100,		hidden: true},
				{dataIndex: 'WORK_MONTH'	, width: 100,		hidden: true},
				{dataIndex: 'ITEM_ACCOUNT'	, width: 100},
				{dataIndex: 'ITEM_CODE'		, width: 100},
				{dataIndex: 'ITEM_NAME'		, width: 200},
				{dataIndex: 'SPEC'			, width: 200},
				{dataIndex: 'DIST_RATE'		, width: 100},
				{dataIndex: 'REMARK'		, width: 300}
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
