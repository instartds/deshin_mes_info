<%@page language="java" contentType="text/html; charset=utf-8"%>

	{
		title:'자산변동(IFRS)',
		border: false,
		itemId: 'tab_Asst_Change_IFRS',
		id:'tab_Asst_Change_IFRS',
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'uniDetailForm',
			itemId: 'tab_Asst_Change_IFRS_Form',
			disabled:false,
			autoScroll: false,
			layout: {type: 'uniTable', columns: 2},
			items: [{
				fieldLabel: '자산구분',
				name:'ASST_DIVI', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A042'
			},
			
			Unilite.popup('ACCNT',{
				fieldLabel: '계정과목', 
				valueFieldName:'ASST_ACCNT',
			    textFieldName:'ASST_ACCNT_NAME',
			    listeners: {
					
	                applyExtParam:{
	                    scope:this,
	                    fn:function(popup){
	                        var param = {
	                            'ADD_QUERY' : "SPEC_DIVI IN ('K', 'K2')",
	                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
	                        }
	                        popup.setExtParam(param);
	                    }
	                }
				}
			}),
			{
				fieldLabel: '변동구분',
				name:'ALTER_DIVI', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A142'
			}]
	    }, {		
			xtype: 'uniGridPanel',
			id:'aiga240ukrvGrid',
			itemId:'aiga240ukrvGrid',
			excelTitle: '감가상각비자동기표방법등록',
			uniOpt: {
	    		useGroupSummary: false,
	    		useLiveSearch: true,
				useContextMenu: false,
				useMultipleSorting: true,
				useRowNumberer: false,
				expandLastColumn: false,
				useRowContext: true,
				onLoadSelectFirst: true,
				copiedRow: true,
	    		state: {
					useState: true,			
					useStateList: true		
				}
	        },
			features: [{
				id: 'aiga240ukrvGridSubTotal', 
				ftype: 'uniGroupingsummary', 
				showSummaryRow: false
			},{
				id: 'aiga240ukrvGridTotal', 
				ftype: 'uniSummary', 
				showSummaryRow: false
			}],
			store: aiga240ukrvDetailStore,
			columns: [     
	        	{ dataIndex: 'COMP_CODE'						,width:100, hidden:true},
	        	{ dataIndex: 'ASST_DIVI'						,width:100,align:'center'},
	        	{ dataIndex: 'ASST_ACCNT'						,width:100,
	        		editor:Unilite.popup('ACCNT_G', {
						autoPopup: true,
						textFieldName:'ASST_ACCNT',
						DBtextFieldName: 'ACCNT_NAME',
						listeners:{
							scope:this,
							onSelected:function(records, type )	{
								var grdRecord = panelDetail.down("#aiga240ukrvGrid").uniOpt.currentRecord;
							   	grdRecord.set('ASST_ACCNT'		, records[0].ACCNT_CODE);
								grdRecord.set('ASST_ACCNT_NAME'	, records[0].ACCNT_NAME);
							},
							onClear:function(type)	{
								var grdRecord = panelDetail.down("#aiga240ukrvGrid").uniOpt.currentRecord;
								grdRecord.set('ASST_ACCNT'		, '');
								grdRecord.set('ASST_ACCNT_NAME'	, '');
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
									var grdRecord = panelDetail.down("#aiga240ukrvGrid").uniOpt.currentRecord;
									var param = {
										"ADD_QUERY" : grdRecord.get('ASST_DIVI') == '1' ? "SPEC_DIVI = 'K'" : "SPEC_DIVI = 'K2'",
										'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
									}
									popup.setExtParam(param);
								}
							}
						}
					})
	        	},
	        	{ dataIndex: 'ASST_ACCNT_NAME'				,width:200,
	        		editor:Unilite.popup('ACCNT_G', {
						autoPopup: true,
						textFieldName:'ASST_ACCNT_NAME',
						DBtextFieldName: 'ACCNT_NAME',
						listeners:{
							scope:this,
							onSelected:function(records, type )	{
								var grdRecord = panelDetail.down("#aiga240ukrvGrid").uniOpt.currentRecord;
							   	grdRecord.set('ASST_ACCNT'		, records[0].ACCNT_CODE);
								grdRecord.set('ASST_ACCNT_NAME'	, records[0].ACCNT_NAME);
							},
							onClear:function(type)	{
								var grdRecord = panelDetail.down("#aiga240ukrvGrid").uniOpt.currentRecord;
								grdRecord.set('ASST_ACCNT'		, '');
								grdRecord.set('ASST_ACCNT_NAME'	, '');
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
									var grdRecord = panelDetail.down("#aiga240ukrvGrid").uniOpt.currentRecord;
									var param = {
										"ADD_QUERY" : grdRecord.get('ASST_DIVI') == '1' ? "SPEC_DIVI = 'K'" : "SPEC_DIVI = 'K2'",
										'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
									}
									popup.setExtParam(param);
								}
							}
						}
					})
	        	},
	        	{ dataIndex: 'ALTER_DIVI'						,width:150},
	        	{ dataIndex: 'SET_DIVI'						,width:150,
	        		listeners:{
		        		render:function(elm)	{
		        			var tGrid = elm.getView().ownerGrid;
		        			elm.editor.on('beforequery',function(queryPlan, eOpts)	{
		        				var grid = tGrid;
		        				var record = grid.uniOpt.currentRecord;
								var store = queryPlan.combo.store;
								store.clearFilter();
								store.filterBy(function(item){
									if(record.get('ALTER_DIVI') == '10' || record.get('ALTER_DIVI') == '21' || record.get('ALTER_DIVI') == '22'){
										return item.get('value').substring(0, 4) == 'A140';
									}else if(record.get('ALTER_DIVI') == '30'){
										return item.get('value').substring(0, 4) == 'A143';
									}else{
										return item.get('value') == '*';
									}
								})
		        			});
		        			elm.editor.on('collapse',function(combo,  eOpts )	{
								var store = combo.store;
								store.clearFilter();
		        			});
		        		}
		        	}
	        	},
	        	{ dataIndex: 'DR_CR'							,width:100,align:'center'},
	        	{ dataIndex: 'AMT_DIVI'						,width:150,
	        		listeners:{
		        		render:function(elm)	{
		        			var tGrid = elm.getView().ownerGrid;
		        			elm.editor.on('beforequery',function(queryPlan, eOpts)	{
		        				var grid = tGrid;
		        				var record = grid.uniOpt.currentRecord;
								var store = queryPlan.combo.store;
								store.clearFilter();
								store.filterBy(function(item){
									if(record.get('ALTER_DIVI') == '10' || record.get('ALTER_DIVI') == '21' || record.get('ALTER_DIVI') == '22'){
										return item.get('value').substring(0, 4) == 'A144';
									}else if(record.get('ALTER_DIVI') == '30' || record.get('ALTER_DIVI') == '40'){
										return item.get('value').substring(0, 4) == 'A145';
									}else{
										return item.get('value') == '';
									}
								})
		        			});
		        			elm.editor.on('collapse',function(combo,  eOpts )	{
								var store = combo.store;
								store.clearFilter();
		        			});
		        		}
		        	}
	        	},
	        	{ dataIndex: 'REVERSE_YN'						,width:100,align:'center'},
	        	{ dataIndex: 'ACCNT'							,width:100,
	        		editor:Unilite.popup('ACCNT_G', {
						autoPopup: true,
						textFieldName:'ACCNT_NAME',
						DBtextFieldName: 'ACCNT_NAME',
						listeners:{
							scope:this,
							onSelected:function(records, type )	{
								var grdRecord = panelDetail.down("#aiga240ukrvGrid").uniOpt.currentRecord;
							   	grdRecord.set('ACCNT'		, records[0].ACCNT_CODE);
								grdRecord.set('ACCNT_NAME'	, records[0].ACCNT_NAME);
							},
							onClear:function(type)	{
								var grdRecord = panelDetail.down("#aiga240ukrvGrid").uniOpt.currentRecord;
								grdRecord.set('ACCNT'		, '');
								grdRecord.set('ACCNT_NAME'	, '');
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
									var param = {
	//									'ADD_QUERY' : "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'",
										'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
									}
									popup.setExtParam(param);
								}
							}
						}
					})
	        	},
	        	{ dataIndex: 'ACCNT_NAME'						,width:200,
	        		editor:Unilite.popup('ACCNT_G', {
						autoPopup: true,
						textFieldName:'ACCNT_NAME',
						DBtextFieldName: 'ACCNT_NAME',
						listeners:{
							scope:this,
							onSelected:function(records, type )	{
								var grdRecord = panelDetail.down("#aiga240ukrvGrid").uniOpt.currentRecord;
							   	grdRecord.set('ACCNT'		, records[0].ACCNT_CODE);
								grdRecord.set('ACCNT_NAME'	, records[0].ACCNT_NAME);
							},
							onClear:function(type)	{
								var grdRecord = panelDetail.down("#aiga240ukrvGrid").uniOpt.currentRecord;
								grdRecord.set('ACCNT'		, '');
								grdRecord.set('ACCNT_NAME'	, '');
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
									var param = {
	//									'ADD_QUERY' : "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'",
										'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
									}
									popup.setExtParam(param);
								}
							}
						}
					})
	        	},
	        	{ dataIndex: 'REMARK'							,width:250},
	        	{ dataIndex: 'INSERT_DB_USER'					,width:100,hidden:true},
	        	{ dataIndex: 'INSERT_DB_TIME'					,width:100,hidden:true},
	        	{ dataIndex: 'UPDATE_DB_USER'					,width:100,hidden:true},
	        	{ dataIndex: 'UPDATE_DB_TIME'					,width:100,hidden:true}
	        ],
	        listeners: {
				beforeedit : function( editor, e, eOpts ) {
					if(UniUtils.indexOf(e.field, ['ASST_DIVI', 'ASST_ACCNT', 'ASST_ACCNT_NAME', 'DR_CR', 'AMT_DIVI', 'REVERSE_YN', 'ACCNT', 'ACCNT_NAME'])){
						if(e.record.phantom == false){
							return false;
						}else{
							return true;
						}
					}else if(UniUtils.indexOf(e.field, ['ALTER_DIVI'])){
						if(e.record.phantom == false || e.record.data.ASST_DIVI == '2'){
							return false;
						}else{
							return true;
						}
					}else if(UniUtils.indexOf(e.field, ['SET_DIVI'])){
						if(e.record.phantom == false || e.record.data.ALTER_DIVI == '40'){
							return false;
						}else{
							return true;
						}
					}else if(UniUtils.indexOf(e.field, ['REMARK'])){
						return true;
					}else{
						return false;
					}
				}
			}
	    }]
	}
