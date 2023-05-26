<%@page language="java" contentType="text/html; charset=utf-8"%>

		{
			xtype: 'container',
			title:'<t:message code="system.label.human.dutycodeupload" default="근태코드등록"/>',
			id:'hbs020ukrTab2',
			itemId: 'hbs020ukrTab2',
			subCode:'H033',
			getSubCode: function()	{
				return this.subCode;
			},
			padding: '0 0 0 0',
			layout: {type: 'vbox', align: 'stretch'},
			items:[{				
				xtype: 'uniGridPanel',
				itemId:'uniGridPanel2',
			    store : hbs020ukrs2Store,
			    uniOpt: {
			    	expandLastColumn: false,
			        useRowNumberer: true,
			        useMultipleSorting: false,
			        copiedRow: true,
					excel: {
						useExcel: true,			//엑셀 다운로드 사용 여부
						exportGroup : false, 		//group 상태로 export 여부
						onlyData:false
					}			        
				},
		    	features: [{
		    		id: 'masterGridSubTotal',
		    		ftype: 'uniGroupingsummary', 
		    		showSummaryRow: false 
		    	},{
		    		id: 'masterGridTotal', 	
		    		ftype: 'uniSummary', 	  
		    		showSummaryRow: false
		    	}],		        
				columns: [
					{dataIndex: 'MAIN_CODE'			,		width: 0, hidden: true},
					{dataIndex: 'SUB_CODE'			,		width: 100},
					{dataIndex: 'CODE_NAME_EN'		,		width: 333, hidden: true},
					{dataIndex: 'CODE_NAME_JP'		,		width: 333, hidden: true},
					{dataIndex: 'CODE_NAME_CN'		,		width: 333, hidden: true},
					{dataIndex: 'CODE_NAME'			,		width: 333},
					{dataIndex: 'REF_CODE1'			,		width: 100, xtype : 'checkcolumn'},
					{dataIndex: 'REF_CODE2'			,		width: 86},
					{dataIndex: 'REF_CODE11'        ,       width: 113, align: 'center', hidden: true},
					{dataIndex: 'REF_CODE3'			,		width: 113, align: 'center'},
					{dataIndex: 'REF_CODE4'			,		width: 86},
					{dataIndex: 'REF_CODE5'			,		width: 86, hidden: true},
					{dataIndex: 'SUB_LENGTH'		,		width: 66, hidden: true},
					{dataIndex: 'USE_YN'			,		minWidth: 186, flex: 1},
					{dataIndex: 'SORT_SEQ'			,		width: 66, hidden: true},
					{dataIndex: 'SYSTEM_CODE_YN'	,		width: 66, hidden: true},
					{dataIndex: 'UPDATE_DB_USER'	,		width: 66, hidden: true},
					{dataIndex: 'UPDATE_DB_TIME'	,		width: 66, hidden: true},
					{dataIndex: 'COMP_CODE'			,		width: 66, hidden: true}
				],
				listeners: {
					beforeedit  : function( editor, e, eOpts ) {
						if(!e.record.phantom){						
							if (UniUtils.indexOf(e.field, ['SUB_CODE','CODE_NAME'])){
								return false;
							}else{
								return true;
							}	
						}					
					},
					edit: function(editor, e) {
						if(e.field == 'SUB_CODE'){
							if(e.value.length > e.record.get('SUB_LENGTH')){
								Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message093" default="길이를 확인해 주세요."/>');
								e.record.set(e.field, e.originalValue);
							}
						}
					}
				}
			}]
		}
