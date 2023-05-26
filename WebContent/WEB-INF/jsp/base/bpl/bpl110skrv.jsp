<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpl110skrv"  >
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장				 -->  
</t:appConfig>
<script type="text/javascript">
		function appMain(){
			Unilite.defineModel('Bpl110skrvModel', {
			    fields: [
			        {name:'ITEM_CODE',		text:'<t:message code="system.label.base.itemcode" default="품목코드"/>',		type:'string' },
			        {name:'ITEM_NAME',		text:'<t:message code="system.label.base.itemname" default="품목명"/>',		type:'string' },
			        {name:'SPEC',			text:'<t:message code="system.label.base.spec" default="규격"/>',			type:'string' },
			        {name:'STOCK_UNIT',		text:'단위',			type:'string' },
			        {name:'ITEM_ACCOUNT',	text:'<t:message code="system.label.base.itemaccount" default="품목계정"/>',		type:'string' },
			        {name:'SUPPLY_TYPE',	text:'<t:message code="system.label.base.procurementclassification" default="조달구분"/>',		type:'string' },
			        {name:'PL_QTY',			text:'원단위량',	 	type:'float', decimalPrecision: 4, format:'0,000.0000' },
			        {name:'PL_COST',		text:'재료비',		type:'uniPrice' },
			        {name:'PL_AMOUNT',		text:'외주가공비',		type:'uniPrice' },
			        {name:'PL_A',			text:'합계금액',		type:'uniPrice' },
			        {name:'CALC_DATE',		text:'기준월',		type:'string' }
			    ]
			});//MODEL结束
			
			Unilite.defineModel('Bpl110skrvModel2', {
			    fields: [
			        {name:'CHILD_ITEM_CODE',	text:'<t:message code="system.label.base.itemcode" default="품목코드"/>',	type:'string' },
			        {name:'ITEM_NAME',			text:'<t:message code="system.label.base.itemname" default="품목명"/>',	type:'string' },
			        {name:'SPEC',				text:'<t:message code="system.label.base.spec" default="규격"/>',		type:'string' },
			        {name:'STOCK_UNIT',			text:'단위',		type:'string' },
			        {name:'ITEM_ACCOUNT',		text:'<t:message code="system.label.base.itemaccount" default="품목계정"/>',	type:'string' },
			        {name:'SUPPLY_TYPE',		text:'<t:message code="system.label.base.procurementclassification" default="조달구분"/>',	type:'string' },
			        {name:'PL_QTY',				text:'원단위량',	type: 'float', decimalPrecision: 4, format:'0,000.0000' },
			        {name:'ORDER_UNIT',			text:'<t:message code="system.label.base.purchaseunit" default="구매단위"/>',	type:'string' },
			        {name:'CHILD_PRICE',		text:'단가',		type:'uniUnitPrice' },
			        {name:'CHILD_AMOUNT',		text:'금액',		type:'uniPrice' }
			    ]
			});//MODEL结束
			var directProxys = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
				  api: {
				    	read   : 'bpl110skrvService.selectList'
				  	}
			});//读取路径
			var directProxys2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
				  api: {
				    	read   : 'bpl110skrvService.selectList2'
				  	}
			});//读取路径
			var bpl110skrvStore=Unilite.createStore('bpl110skrvStore',{
				model:'Bpl110skrvModel',
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
							//查询后，默认选中之前那条 mod by zhongshl
							if(success){
								if(!Ext.isEmpty(index)){
										 Ext.getCmp('bpl110skrvMasterGrid').getSelectionModel().select(index);
									}else{
									 	Ext.getCmp('bpl110skrvMasterGrid').getSelectionModel().select(0);
									}
								}
							}
						});
            		}
				}
			});//第一个store
			var bpl110skrvStore2=Unilite.createStore('bpl110skrvStore2',{
				model:'Bpl110skrvModel2',
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
					param.ITEM_CODE=record.ITEM_CODE;
					this.load({
						params: param
				});
			}
			});
			
			/*Ext.create('Ext.data.Store', {
			storeId:'UNI_STORE',
		    fields: ['text', 'value'],
		    data : [
		        {text:"1주차",   value:"1"},
		        {text:"2주차", 	 value:"2"},
		        {text:"3주차", 	 value:"3"},
		        {text:"4주차", 	 value:"4"},
		        {text:"5주차", 	 value:"5"}
		    	]
			});*///下拉框自定义的store
		var masterGrid = Unilite.createGrid('bpl110skrvMasterGrid', {
			itemId : 'bpl110skrvMasterGrid',
	    	id: 'bpl110skrvMasterGrid',
	    	store  : bpl110skrvStore,
	    	uniOpt : {
		    	expandLastColumn: false,
				useRowNumberer: false,
                useMultipleSorting:false	
		    },
		    columns:[
		    	{dataIndex:'ITEM_CODE',			width:120},
				{dataIndex:'ITEM_NAME',			width:200},
				{dataIndex:'SPEC',				width:200},
				{dataIndex:'STOCK_UNIT',		width:80 , align:'center'},
				{dataIndex:'ITEM_ACCOUNT',		width:80 , align:'center'},
				{dataIndex:'SUPPLY_TYPE',		width:80 , align:'center'},
				{dataIndex:'PL_QTY',			width:100},
				{dataIndex:'PL_COST',			width:100},
				{dataIndex:'PL_AMOUNT',			width:100},
				{dataIndex:'PL_A',				width:100}
		    ],
		    listeners:{
		    	selectionchange : function(grid, selected, eOpts) {
	    		this.setDetailGrd( selected, eOpts)	;	//选中时的事件					
	    		}
		    },
		    setDetailGrd : function (selected, eOpts) {
		    	if(selected.length > 0)	{
		    		var record = selected[0];
		    			detailGrid.getStore().loadStoreRecords(record.data);
		    		}
		   		 }
		});
		
		
		var detailGrid = Unilite.createGrid('bpl110skrvdetailGrid', {
			itemId : 'bpl110skrvdetailGrid',
	        id     : 'bpl110skrvdetailGrid',
	        store  : bpl110skrvStore2,
	        uniOpt:{
	        	expandLastColumn: false,
				useRowNumberer: false,
                useMultipleSorting:false
	        },
	        columns:[
	        	{dataIndex:'CHILD_ITEM_CODE',	width:120},
				{dataIndex:'ITEM_NAME',			width:200},
				{dataIndex:'SPEC',				width:200},
				{dataIndex:'STOCK_UNIT',		width:80 , align:'center'},
				{dataIndex:'ITEM_ACCOUNT',		width:80 , align:'center'},
				{dataIndex:'SUPPLY_TYPE',		width:80 , align:'center'},
				{dataIndex:'PL_QTY',			width:100},
				{dataIndex:'ORDER_UNIT',		width:100, align:'center'},
				{dataIndex:'CHILD_PRICE',		width:100},
				{dataIndex:'CHILD_AMOUNT',		width:100}
	        ]
		});//详情的grid结束
		
		var panelSearch=Unilite.createSearchForm('searchForm',{
			layout: {type : 'uniTable' , columns: 4/*, tableAttrs: {width: '100%'}*/},
			items:[
				{
					fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
			        xtype: 'uniCombobox', 
			        comboType:'BOR120',
			        name:'DIV_CODE',
			        value: UserInfo.divCode,
			        allowBlank:false
				},{
	        	fieldLabel: '기준월',
				xtype: 'uniMonthfield',
				name: 'FR_DATE',
		 		value: UniDate.get('today'),
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
				},{
					fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
			        xtype: 'uniCombobox', 
			        comboType:'AU',
			        comboCode:'B020',
			        name:'ITEM_ACCOUNT',
			        allowBlank:true
				}
				/*,{
					fieldLabel: '기준년도',
					 xtype:'uniMonthfield',
					 name : 'YEAR_MONTH',
					 maxLength:16,
					 allowBlank:false
				}	*/
				/*,{
					fieldLabel: ' 주차 ',
			        xtype: 'uniCombobox', 
			        store: Ext.data.StoreManager.lookup('UNI_STORE'),
			        name:'WEEK',
			        value:'1',
			        width:200
				}*/
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
					//width  : '75%',
					height : '50%',
					items  : [detailGrid]
				} ]
			}], 
			id : 'bpl110skrvApp',
			fnInitBinding : function(){
				UniAppManager.setToolbarButtons(['reset'],true);
				panelSearch.setValue("WEEK",'1');
			},
			onQueryButtonDown : function() {
				if(!panelSearch.getInvalidMessage()){
					return false;		
				};
				//directMasterStore.loadStoreRecords();
				var store = masterGrid.getStore();
		 		var record = masterGrid.getSelectedRecord();
		 		store.loadStoreRecords(bpl110skrvStore.indexOf(record));
				},
			onResetButtonDown:function() {
				/*var masterGrid = Ext.getCmp('bpl100skrvGrid');
				Ext.getCmp('searchForm').getForm().reset();*/
				panelSearch.clearForm();
				masterGrid.reset();
				//masterGrid.getStore().clearData();
				detailGrid.reset();
				this.fnInitBinding();
				UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
			}
		});
	}
</script>