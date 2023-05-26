<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title	: '매입매출거래유형',
		itemId	: 'tab_busiType',
		id		: 'tab_busiType',
		xtype	: 'container',
		layout	: {type: 'vbox', align: 'stretch'},
		border	: false,
		items	: [{
			id		: 'tab_busiTypeForm',
			xtype	: 'uniDetailForm',
			layout	: {type: 'uniTable', columns: 1},
			disabled: false,
			items:[{	
				fieldLabel: '매입매출구분',
				name: 'SALE_DIVI',
				xtype: 'uniCombobox',
				allowBlank: false,
				comboType: 'AU',
				comboCode: 'A003'
			}]			
		}, {				
			xtype: 'uniGridPanel',
			itemId:'aba050ukrsGrid2',
		    store : aba050ukrStore2,
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
			columns: [//{dataIndex: 'MAIN_CODE'						,		width: 100,		hidden: true},
					  {dataIndex: 'SUB_CODE'						,		width: 100},
					  {dataIndex: 'CODE_NAME'						,		width: 300},
					  //{dataIndex: 'CODE_NAME_EN'					,		width: 100,		hidden: true},
					  //{dataIndex: 'CODE_NAME_CN'					,		width: 100,		hidden: true},
//					  {dataIndex: 'CODE_NAME_JP'					,		width: 100,		hidden: true},
//					  {dataIndex: 'USER_NAME'						,		width: 100,		hidden: true},
//					  {dataIndex: 'SYSTEM_CODE_YN'					,		width: 100,		hidden: true},
					  {dataIndex: 'REF_CODE1'						,		width: 200}
//					  {dataIndex: 'REF_CODE2'						,		width: 100,		hidden: true},
//					  {dataIndex: 'REF_CODE3'						,		width: 100,		hidden: true},
//					  {dataIndex: 'REF_CODE4'						,		width: 100,		hidden: true},
//					  {dataIndex: 'REF_CODE5'						,		width: 100,		hidden: true},
//					  {dataIndex: 'SUB_LENGTH'						,		width: 100,		hidden: true},
//					  {dataIndex: 'USE_YN'							,		width: 100,		hidden: true},
//					  {dataIndex: 'SORT_SEQ'						,		width: 100,		hidden: true}					  
			],
			listeners:{
				beforeedit  : function( editor, e, eOpts ) {
					if(UniUtils.indexOf(e.field, ['SUB_CODE'])){
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