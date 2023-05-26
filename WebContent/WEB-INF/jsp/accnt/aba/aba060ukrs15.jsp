<%@page language="java" contentType="text/html; charset=utf-8"%>
{
	title:'감가상각(IFRS)',
	border: false,
	itemId: 'tab_Asst_Dep_IFRS',
	id:'tab_Asst_Dep_IFRS',
	xtype: 'container',
	layout: {type: 'vbox', align: 'stretch'},
	items:[{
		xtype: 'uniDetailForm',
		disabled:false,
		itemId: 'tab_Asst_Dep_IFRS_Form',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		items: [{
				fieldLabel: '구분',
				name:'DEPT_DIVI', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A037'
			}]
		},{
			xtype: 'uniGridPanel',
			id:'aiga210ukrvGrid',
			itemId:'aiga210ukrvGrid',
			excelTitle: '감가상각비자동기표방법등록',
			uniOpt: {
	    		useGroupSummary: false,
	    		useLiveSearch: true,
				useContextMenu: false,
				useMultipleSorting: true,
				useRowNumberer: false,
				expandLastColumn: true,
				useRowContext: true,
				onLoadSelectFirst: true,
	    		state: {
					useState: true,			
					useStateList: true		
				}
	        },
			features: [{
				id: 'aiga210ukrvGridSubTotal', 
				ftype: 'uniGroupingsummary', 
				showSummaryRow: false
			},{
				id: 'aiga210ukrvGridTotal', 
				ftype: 'uniSummary', 
				showSummaryRow: false
			}],
			store: aiga210ukrvStore,
			columns: [        
	        	{ dataIndex: 'DEPT_DIVI'				,width:100}, 
	        	{ dataIndex: 'ACCNT'					,width:100,
					editor:Unilite.popup('ACCNT_G', {
						autoPopup: true,
						textFieldName:'ACCNT',
						DBtextFieldName: 'ACCNT_CODE',
						listeners:{
							scope:this,
							onSelected:function(records, type )	{
								var grdRecord = panelDetail.down("#aiga210ukrvGrid").uniOpt.currentRecord;
							   	grdRecord.set('ACCNT'		, records[0].ACCNT_CODE);
								grdRecord.set('ACCNT_NAME'	, records[0].ACCNT_NAME);
							},
							onClear:function(type)	{
								var grdRecord = panelDetail.down("#aiga210ukrvGrid").uniOpt.currentRecord;
								grdRecord.set('ACCNT'		, '');
								grdRecord.set('ACCNT_NAME'	, '');
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
									var param = {
										'ADD_QUERY' : "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'",
										'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
									}
									popup.setExtParam(param);
								}
							}
						}
					})
	        	}, 
	        	{ dataIndex: 'ACCNT_NAME'				,width:200,
	        		editor:Unilite.popup('ACCNT_G', {
						autoPopup: true,
						textFieldName:'ACCNT_NAME',
						DBtextFieldName: 'ACCNT_NAME',
						listeners:{
							scope:this,
							onSelected:function(records, type )	{
								var grdRecord = panelDetail.down("#aiga210ukrvGrid").uniOpt.currentRecord;
							   	grdRecord.set('ACCNT'		, records[0].ACCNT_CODE);
								grdRecord.set('ACCNT_NAME'	, records[0].ACCNT_NAME);
							},
							onClear:function(type)	{
								var grdRecord = panelDetail.down("#aiga210ukrvGrid").uniOpt.currentRecord;
								grdRecord.set('ACCNT'		, '');
								grdRecord.set('ACCNT_NAME'	, '');
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
									var param = {
										'ADD_QUERY' : "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'",
										'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
									}
									popup.setExtParam(param);
								}
							}
						}
					})
	        	}, 
	        	{ dataIndex: 'DEP_ACCNT'				,width:100,
	        		editor:Unilite.popup('ACCNT_G', {
						autoPopup: true,
						textFieldName:'DEP_ACCNT',
						DBtextFieldName: 'ACCNT_CODE',
						listeners:{
							scope:this,
							onSelected:function(records, type )	{
								var grdRecord = panelDetail.down("#aiga210ukrvGrid").uniOpt.currentRecord;
							   	grdRecord.set('DEP_ACCNT'		, records[0].ACCNT_CODE);
								grdRecord.set('DEP_ACCNT_NAME'	, records[0].ACCNT_NAME);
							},
							onClear:function(type)	{
								var grdRecord = panelDetail.down("#aiga210ukrvGrid").uniOpt.currentRecord;
								grdRecord.set('DEP_ACCNT'		, '');
								grdRecord.set('DEP_ACCNT_NAME'	, '');
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
									var param = {
										'ADD_QUERY' : "SLIP_SW = 'Y' AND GROUP_YN = 'N'",
										'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
									}
									popup.setExtParam(param);
								}
							}
						}
					})
	        	}, 
	        	{ dataIndex: 'DEP_ACCNT_NAME'			,width:200,
	        		editor:Unilite.popup('ACCNT_G', {
						autoPopup: true,
						textFieldName:'DEP_ACCNT_NAME',
						DBtextFieldName: 'ACCNT_NAME',
						listeners:{
							scope:this,
							onSelected:function(records, type )	{
								var grdRecord = panelDetail.down("#aiga210ukrvGrid").uniOpt.currentRecord;
							   	grdRecord.set('DEP_ACCNT'		, records[0].ACCNT_CODE);
								grdRecord.set('DEP_ACCNT_NAME'	, records[0].ACCNT_NAME);
							},
							onClear:function(type)	{
								var grdRecord = panelDetail.down("#aiga210ukrvGrid").uniOpt.currentRecord;
								grdRecord.set('DEP_ACCNT'		, '');
								grdRecord.set('DEP_ACCNT_NAME'	, '');
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
									var param = {
										'ADD_QUERY' : "SLIP_SW = 'Y' AND GROUP_YN = 'N'",
										'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
									}
									popup.setExtParam(param);
								}
							}
						}
					})
	        	}, 
	        	{ dataIndex: 'APP_ACCNT'				,width:100,
	        		editor:Unilite.popup('ACCNT_G', {
						autoPopup: true,
						textFieldName:'APP_ACCNT',
						DBtextFieldName: 'ACCNT_CODE',
						listeners:{
							scope:this,
							onSelected:function(records, type )	{
								var grdRecord = panelDetail.down("#aiga210ukrvGrid").uniOpt.currentRecord;
							   	grdRecord.set('APP_ACCNT'		, records[0].ACCNT_CODE);
								grdRecord.set('APP_ACCNT_NAME'	, records[0].ACCNT_NAME);
							},
							onClear:function(type)	{
								var grdRecord = panelDetail.down("#aiga210ukrvGrid").uniOpt.currentRecord;
								grdRecord.set('APP_ACCNT'		, '');
								grdRecord.set('APP_ACCNT_NAME'	, '');
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
									var param = {
										'ADD_QUERY' : "SLIP_SW = 'Y' AND GROUP_YN = 'N'",
										'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
									}
									popup.setExtParam(param);
								}
							}
						}
					})
	        	}, 
	        	{ dataIndex: 'APP_ACCNT_NAME'			,width:200,
	        		editor:Unilite.popup('ACCNT_G', {
						autoPopup: true,
						textFieldName:'APP_ACCNT_NAME',
						DBtextFieldName: 'ACCNT_NAME',
						listeners:{
							scope:this,
							onSelected:function(records, type )	{
								var grdRecord = panelDetail.down("#aiga210ukrvGrid").uniOpt.currentRecord;
							   	grdRecord.set('APP_ACCNT'		, records[0].ACCNT_CODE);
								grdRecord.set('APP_ACCNT_NAME'	, records[0].ACCNT_NAME);
							},
							onClear:function(type)	{
								var grdRecord = panelDetail.down("#aiga210ukrvGrid").uniOpt.currentRecord;
								grdRecord.set('APP_ACCNT'		, '');
								grdRecord.set('APP_ACCNT_NAME'	, '');
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
									var param = {
										'ADD_QUERY' : "SLIP_SW = 'Y' AND GROUP_YN = 'N'",
										'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
									}
									popup.setExtParam(param);
								}
							}
						}
					})
	        	}, 
	        	{ dataIndex: 'COMP_CODE'				,width:100,hidden:true}, 
	        	{ dataIndex: 'INSERT_DB_USER'			,width:100,hidden:true}, 
	        	{ dataIndex: 'INSERT_DB_TIME'			,width:100,hidden:true}, 
	        	{ dataIndex: 'UPDATE_DB_USER'			,width:100,hidden:true}, 
	        	{ dataIndex: 'UPDATE_DB_TIME'			,width:100,hidden:true}
	        ],
	        listeners: {
				beforeedit : function( editor, e, eOpts ) {
					if(e.record.phantom == true){
						if(UniUtils.indexOf(e.field, ['COMP_CODE','INSERT_DB_USER','INSERT_DB_TIME','UPDATE_DB_USER','UPDATE_DB_TIME'])){
							return false;
						}else{
							return true;	
						}
					}else{
						if(UniUtils.indexOf(e.field, ['DEPT_DIVI','ACCNT','ACCNT_NAME','COMP_CODE','INSERT_DB_USER','INSERT_DB_TIME','UPDATE_DB_USER','UPDATE_DB_TIME'])){
							return false;
						}else{
							return true;	
						}	
					}
				}
			}
	    }]
	}