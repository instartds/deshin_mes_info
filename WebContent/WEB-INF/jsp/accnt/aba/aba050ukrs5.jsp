<%@page language="java" contentType="text/html; charset=utf-8"%>

	{
		title	: '경비유형',
		itemId	: 'tab_categoryExpense',
		id	: 'tab_categoryExpense',
		xtype	: 'uniDetailForm',
		layout	: {type: 'vbox', align:'stretch'},
		items	: [/*{
			xtype:'container',
			html: '※ 항목코드는 기초등록-집계항목설정 메뉴의 손익계산서와 제조원가명세서에 정의된 항목코드를 입력합니다. 예)1160 : 기말원재료재고액',
			style: {
				color: 'blue'				
			}
		},*/ {	
			xtype: 'uniGridPanel',
			itemId:'aba050ukrsGrid5',
		    store : aba050ukrStore5,
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
			columns: [{dataIndex: 'MAIN_CODE'			, width: 100,		hidden: true},
					  {dataIndex: 'SUB_CODE'  			, width: 100},
					  {dataIndex: 'CODE_NAME' 			, width: 180},
					  {dataIndex: 'CODE_NAME_EN' 		, width: 100,		hidden: true},
					  {dataIndex: 'CODE_NAME_CN' 		, width: 100,		hidden: true},
					  {dataIndex: 'CODE_NAME_JP' 		, width: 100,		hidden: true},
					  {dataIndex: 'REF_CODE1'  			, width: 150,		hidden: true},
					  {dataIndex: 'REF_CODE2'			, width: 100,		hidden: true},
					  {dataIndex: 'REF_CODE3'			, width: 100,		hidden: true},
					  {dataIndex: 'REF_CODE4'			, width: 100,		hidden: true},
					  {dataIndex: 'REF_CODE5'			, width: 100,		hidden: true},
					  {dataIndex: 'SUB_LENGTH'			, width: 100,		hidden: true},
					  {dataIndex: 'USE_YN'				, width: 100},
					  {dataIndex: 'SORT_SEQ'			, width: 100,		hidden: true},
					  {dataIndex: 'SYSTEM_CODE_YN'		, width: 100,		hidden: true}
			],
			listeners:{
				beforeedit  : function( editor, e, eOpts ) {
					if(UniUtils.indexOf(e.field, ['SUB_CODE', 'CODE_NAME'])){
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
