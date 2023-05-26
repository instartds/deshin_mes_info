<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="gba240skrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B046" /> <!--완료구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장				 -->
</t:appConfig>
	<script type="text/javascript">
		function appMain(){
			Unilite.defineModel('gba240skrvModel', {
				 fields: [
				 	{name:'CUSTOM_NAME',	text:'고객',		type:'string'},
				 	{name:'PROJECT_NO',		text:'프로젝트',	type:'string'},
				 	{name:'PJT_NAME',		text:'프로젝트명',	type:'string'},
				 	{name:'ORDER_NUM',		text:'수주번호',	type:'string'},
				 	{name:'DIVI',			text:'완료구분',	type:'string', comboType:'AU', comboCode:'B046'},
				 	{name:'ORDER_DATE',		text:'수주일',		type:'uniDate'},
				 	{name:'DVRY_DATE',		text:'납기일',		type:'uniDate'},
				 	{name:'ISSUE_REQ_DATE',	text:'출하예정일',	type:'uniDate'},
				 	{name:'INOUT_DATE',		text:'납품일',		type:'uniDate'},
				 	{name:'PJT_AMT',		text:'계약금액',	type:'uniPrice'},
				 	{name:'TOT_ORDER_AMT',	text:'수주금액',	type:'uniPrice'},
				 	{name:'TOT_SALE_AMT',	text:'매출금액',	type:'uniPrice'},
				 	{name:'COLLECT_AMT',	text:'수금액',		type:'uniPrice'},
				 	{name:'REMAIN_AMT',		text:'잔액',		type:'uniPrice'},
				 	{name:'TAX_REGDATE',	text:'계산서발행액',type:'uniPrice'},
				 	{name:'ORDER_PRSN',		text:'영업담당',	type:'string', comboType:'AU', comboCode:'S010'},
				 	{name:'REMARK',			text:'<t:message code="system.label.base.remarks" default="비고"/>',		type:'string'},
				 	{name: 'DIV_CODE' ,		text: '<t:message code="system.label.base.division" default="사업장"/>',		type: 'string'},
				 	{name: 'BUDGET_O' ,		text: '예산금액',	type:'uniPrice'}

				 ]
			});
			Unilite.defineModel('gba240skrvModel2', {
				 fields: [
				 	{name:'ITEM_CODE',		text:'<t:message code="system.label.base.itemcode" default="품목코드"/>',		type:'string'},
				 	{name:'ITEM_NAME',		text:'<t:message code="system.label.base.itemname" default="품목명"/>',			type:'string'},
				 	{name:'ORDER_Q',		text:'수주수량',		type:'uniQty'},
				 	{name:'DVRY_DATE',		text:'납기일',			type:'uniDate'},
				 	{name:'INOUT_DATE',		text:'출고일',			type:'uniDate'},
				 	{name:'ORDER_UNIT_Q',	text:'출고수량',		type:'uniQty'},
				 	{name:'REMAIN_Q',		text:'잔량',			type:'uniQty'},
				 	{name:'PROCESS_RATE',	text:'진행률(%)',			type:'uniPercent'}
				 ]
			});
			var directProxys = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
				  api: {
				    	read   : 'gba240skrvService.selectList'
				  	}
			});
			var directProxys2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
				  api: {
				    	read   : 'gba240skrvService.selectList2'
				  	}
			});
			var gba240skrvStore=Unilite.createStore('gba240skrvStore',{
				model:'gba240skrvModel',
				autoload:false,
				uniOpt    : {
	            	isMaster  : true,
	            	editable  : true,
	            	deletable : false,
		            useNavi   : false
            	},
            	proxy: directProxys,
            	loadStoreRecords: function(index){
            	var panelSearch = Ext.getCmp('searchForm');
            	if(panelSearch.isValid())	{
					var param= Ext.getCmp('searchForm').getValues();
					this.load({
						params: param,
						callback:function(records, operation, success)	{
							if(success){
								if(!Ext.isEmpty(index)){
										 Ext.getCmp('gba240skrvMasterGrid').getSelectionModel().select(index);
									}else{
									 	Ext.getCmp('gba240skrvMasterGrid').getSelectionModel().select(0);
									}
								}
							}
						});
            		}
				}
			});
			var gba240skrvStore2=Unilite.createStore('gba240skrvStore2',{
				model:'gba240skrvModel2',
				autoload:false,
				uniOpt    : {
	            	isMaster  : true,
	            	editable  : true,
	            	deletable : false,
		            useNavi   : false
            	},
            	proxy: directProxys2,
            	loadStoreRecords: function(record){
				var param= Ext.getCmp('searchForm').getValues();
					param.ORDER_NUM=record.ORDER_NUM;
					this.load({
						params: param
					});
				}
			});
			var masterGrid = Unilite.createGrid('gba240skrvMasterGrid', {
				itemId : 'gba240skrvMasterGrid',
		    	id: 'gba240skrvMasterGrid',
		    	store  : gba240skrvStore,
		    	uniOpt : {
			    	expandLastColumn: false,
					useRowNumberer: false,
	                useMultipleSorting:false
			    },
			    features:  [ {id:  'masterGridSubTotal', ftype:  'uniGroupingsummary', showSummaryRow:  true },
    	           	{id:  'masterGridTotal', 	ftype:  'uniSummary', 	  showSummaryRow:  true} ],
			    columns:[
			    	{dataIndex:'CUSTOM_NAME',			width:150,
			    		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              				return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');}
			    	},
					{dataIndex:'PROJECT_NO',			width:80},
					{dataIndex:'PJT_NAME',				width:150},
					{dataIndex:'ORDER_NUM',				width:120},
					{dataIndex:'DIVI',					width:66, align: 'center'},
					{dataIndex:'ORDER_DATE',			width:80},
					{dataIndex:'DVRY_DATE',				width:80},
					{dataIndex:'ISSUE_REQ_DATE',		width:80},
					{dataIndex:'INOUT_DATE',			width:100},
					{dataIndex:'PJT_AMT',				width:120, summaryType: 'sum'},
					{dataIndex:'TOT_ORDER_AMT',			width:120, summaryType: 'sum'},
					{dataIndex:'TOT_SALE_AMT',			width:120, summaryType: 'sum'}	,
					{dataIndex:'COLLECT_AMT',			width:120, summaryType: 'sum'},
					{dataIndex:'REMAIN_AMT',			width:120, summaryType: 'sum'},
					{dataIndex:'BUDGET_O',			width:120, summaryType: 'sum'},
					{dataIndex:'TAX_REGDATE',			width:120, summaryType: 'sum'},
					{dataIndex:'ORDER_PRSN',			width:80, align: 'center'},
					{dataIndex:'REMARK',				width:150}
			    ],
			    listeners:{
			    	selectionchange : function(grid, selected, eOpts) {
		    		this.setDetailGrd( selected, eOpts)	;
		    		}
			    },
			    setDetailGrd : function (selected, eOpts) {
			    	if(selected.length > 0)	{
			    		var record = selected[0];
			    			detailGrid.getStore().loadStoreRecords(record.data);
			    		}
			   		}
			});
			var detailGrid = Unilite.createGrid('gba240skrvdetailGrid', {
				itemId : 'gba240skrvdetailGrid',
		        id     : 'gba240skrvdetailGrid',
		        store  : gba240skrvStore2,
		        uniOpt:{
		        	expandLastColumn: false,
					useRowNumberer: false,
	                useMultipleSorting:false
		        },
			    features:  [ {id:  'detailGridSubTotal', ftype:  'uniGroupingsummary', showSummaryRow:  true },
    	           	{id:  'detailGridTotal', 	ftype:  'uniSummary', 	  showSummaryRow:  true} ],
			    columns:[
			    	{dataIndex:'ITEM_CODE',			width:100,
			    		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              				return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');}
			    	},
					{dataIndex:'ITEM_NAME',			width:200},
					{dataIndex:'ORDER_Q',			width:100, summaryType: 'sum'},
					{dataIndex:'DVRY_DATE',			width:100},
					{dataIndex:'INOUT_DATE',		width:100},
					{dataIndex:'ORDER_UNIT_Q',		width:100, summaryType: 'sum'},
					{dataIndex:'REMAIN_Q',			width:100, summaryType: 'sum'},
					{dataIndex:'PROCESS_RATE',		width:100}
		        ]
			});
			var panelSearch=Unilite.createSearchForm('searchForm',{
				layout: {type : 'uniTable' , columns: 3, tableAttrs: {width: '100%'}},
				items:[
					{
						fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				        xtype: 'uniCombobox',
				        comboType:'BOR120',
				        name:'DIV_CODE',
				        value:'01',
				        allowBlank:false
					}, {
		                fieldLabel: '수주일',
		                startFieldName: 'FR_DATE',
		                endFieldName: 'TO_DATE',
		                xtype: 'uniDateRangefield',
		                width: 315
		            },{
		            	fieldLabel: '완료구분',
				        xtype: 'uniCombobox',
				        comboType:'AU',
				        comboCode:'B046',
				        name:'STATE'
		            },{
		            	fieldLabel: '영업담당',
				        xtype: 'uniCombobox',
				        comboType:'AU',
				        comboCode:'S010',
				        name:'SALE_PRSN'
		            },
		            	Unilite.popup('AGENT_CUST',{
		            	fieldLabel:'고객',
		            	textFieldWidth:130,
		            	valueFieldName:'CUSTOM_CODE',
		            	textFieldName:'CUSTOM_NAME' ,
		            	listeners: {
		                        onSelected: {
		                            fn: function(records, type) {
		                            },
		                            scope: this
		                        },
		                        onClear: function(type) {
		                        }
		                    }
		            	}),
						Unilite.popup('PROJECT',{
							fieldLabel: '프로젝트번호',
							valueFieldName:'PJT_CODE',
						    textFieldName:'PJT_NAME',
				       		DBvalueFieldName: 'PJT_CODE',
						    DBtextFieldName: 'PJT_NAME',
						    textFieldOnly: false,
						    validateBlank:false
						})
				]
			});
			Unilite.Main({
				items:[panelSearch,{
					xtype    : 'container',
					flex     : 1,
					layout   : 'border',
					defaults : {
						collapsible : false
					},
					items : [ {
						region : 'center',
						xtype  : 'container',
						layout : 'fit',
						height : '30%',
						items  : [ masterGrid ]
					}, {
						region : 'south',
						xtype  : 'container',
						layout : 'fit',
						height : '50%',
						items  : [detailGrid]
					} ]
				}],
				id : 'gba240skrvApp',
				fnInitBinding : function(){
					panelSearch.setValue("FR_DATE",UniDate.get('startOfMonth'));
        			panelSearch.setValue("TO_DATE",UniDate.get('today'));
					UniAppManager.setToolbarButtons(['reset'],true);
				},
				onQueryButtonDown : function() {
					if(!panelSearch.getInvalidMessage()){
						return false;
					};
					var store = masterGrid.getStore();
			 		var record = masterGrid.getSelectedRecord();
			 		store.loadStoreRecords(gba240skrvStore.indexOf(record));
				},
				onResetButtonDown:function() {
					panelSearch.clearForm();
					masterGrid.reset();
					detailGrid.reset();
					this.fnInitBinding();
					UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
				}
			});
		}
	</script>