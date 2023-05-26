<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//행사등록
request.setAttribute("PKGNAME","Unilite_app_prm100ukrv");
%>
<t:appConfig pgmId="prm100ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="prm100ukrv"/>							<!-- 사업장   	-->  
</t:appConfig>
<script type="text/javascript">
var excelWindow;
function appMain() {
	
	 Ext.create('Ext.data.Store', {
		storeId:"promoClassStore",
	    fields: ['text', 'value'],
	    data : [
	        {text:"단품할인",   value:"1"},
	        {text:"혼합할인", 	value:"2"}
	    ]
	});

	Ext.create('Ext.data.Store', {
		storeId:"mixMatchType",
	    fields: ['text', 'value'],
	    data : [
	        {text:"구매",   value:"1"},
	        {text:"할인", 	value:"2"},
	        {text:"교차", 	value:"3"}
	    ]
	});
	
	Ext.create('Ext.data.Store', {
		storeId:"threTypeStore",
	    fields: ['text', 'value'],
	    data : [
	        {text:"부분구매",   value:"1"},
	        {text:"전체구매", 	value:"2"}
	    ]
	});
	
	Unilite.defineModel('${PKGNAME}Model', {
	    fields: [
			 {name: 'DIV_CODE'   			,text:'사업장'		,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode , isPk:true, pkGen:'user', allowBlank:false} 
			,{name: 'PROMO_CLASS'    		,text:'행사분류'		,type : 'string' ,store: Ext.data.StoreManager.lookup('promoClassStore') , isPk:true, pkGen:'user', allowBlank:false}
			,{name: 'PROMO_YYYY'    		,text:'행사년도'		,type : 'string'  , isPk:true, pkGen:'user', allowBlank:false}			
			,{name: 'PROMO_CD'    			,text:'행사코드'		,type : 'string', editable:false} 
			,{name: 'PROMO_NM'    			,text:'행사명'		,type : 'string'  }
			,{name: 'COND_SEQ'    			,text:'조건순번'		,type : 'int'	,defaultValue:1, editable:false, allowBlank:false} 
			,{name: 'ITEM_CODE'    			,text:'품목코드'		,type : 'string' } 
			,{name: 'ITEM_NAME'    			,text:'품목명'		,type : 'string'  } 

			,{name: 'MIX_MATCH_TYPE'    	,text:'구매/증정구분'	,type : 'string' ,store: Ext.data.StoreManager.lookup('mixMatchType')} 
			,{name: 'SALE_BASIS_P'    		,text:'판매단가'		,type : 'uniPrice'  } 
			,{name: 'DC_VALUE'    			,text:'행사할인율'		,type : 'uniPercent'  } 
			
			,{name: 'PROMO_START_DATE'    	,text:'시작일자'		,type : 'uniDate' ,defaultValue:UniDate.today() , allowBlank:false}
			,{name: 'PROMO_END_DATE'    	,text:'종료일자'		,type : 'uniDate' ,defaultValue:UniDate.today() , allowBlank:false} 
			,{name: 'THRE_TYPE'    			,text:'행사종류'		,type : 'string'  ,store: Ext.data.StoreManager.lookup('threTypeStore')}
			,{name: 'COND_AMT'    			,text:'조건수량'		,type : 'uniQty'} 
			,{name: 'DC_RATE'    			,text:'할인율'		,type : 'uniPercent'  }
			,{name: 'REMARK'    			,text:'비고'			,type : 'string'} 
			
		]
	});
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read 	: 'prm100ukrvService.selectPromo',
			create  : 'prm100ukrvService.insert',
			update  : 'prm100ukrvService.update',
			destroy : 'prm100ukrvService.delete',
			syncAll	: 'prm100ukrvService.saveAll'
		}
	});
	var promoStore = Unilite.createStore('${PKGNAME}Store',{
        model: '${PKGNAME}Model',
         autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy1,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}SearchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			},
			saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					var chk = true;
					Ext.each(this.data.items, function(record, idx){
						console.log("record :", record);
						if(record.get('PROMO_CLASS') =='2' )	{
							if(record.get('THRE_TYPE') =='') {
								chk = false;
								alert('행사종류는 필수 입력입니다.');
							}
							if(record.get('COND_AMT') =='') {
								chk = false;
								alert('조건수량은 필수 입력입니다.');
							}
							if(record.get('DC_VALUE') =='') {
								chk = false;
								alert('할인율은 필수 입력입니다.');
							}
						}
					})
					if(chk)	{
						this.syncAllDirect(config);
					}
				}else {
					var grid = Ext.getCmp('${PKGNAME}Grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
			,listeners:{
				update:function(store)	{
					store.onSaveButton();
					
				},
				add:function(store)	{
					store.onSaveButton();
				},
				remove:function(store)	{
					store.onSaveButton();
				},
				load:function(store)	{
					UniAppManager.setToolbarButtons('save', false);
					if(store.getCount() > 0 ) UniAppManager.setToolbarButtons('delete', true);
				}
			},
			onSaveButton:function()		{
				var me = this;
				if(me.isDirty()){
					UniAppManager.setToolbarButtons('save', true);
					if(me.getCount() > 0 && promoGrid.isVisible()) UniAppManager.setToolbarButtons('delete', true);
					else if(masterStore.getCount() < 1 && promoGrid.isHidden()) UniAppManager.setToolbarButtons('delete', false);
				}else {
					if(!masterStore.isDirty())	{
						UniAppManager.setToolbarButtons('save', false);
					}
				}
			}
		});
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read 	: 'prm100ukrvService.selectList',
			create  : 'prm100ukrvService.insert',
			update  : 'prm100ukrvService.update',
			destroy : 'prm100ukrvService.delete',
			syncAll	: 'prm100ukrvService.saveAll'
		}
	});
	
    var masterStore =  Unilite.createStore('${PKGNAME}Store',{
        model: '${PKGNAME}Model',
         autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy2,
            saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				
				if(inValidRecs.length == 0 )	{
					var chk = true;
					Ext.each(this.data.items, function(record, idx){
						if(record.get('PROMO_CLASS') =='1')	{
							if(record.get('SALE_BASIS_P') == 0) {
								chk = false;
								alert('판매단가는 필수 입력입니다.');
							}
							if(record.get('DC_VALUE') == 0) {
								chk = false;
								alert('할인단가는 필수 입력입니다.');
							}
						}
					})
					if(chk)	{
						this.syncAllDirect();
					}
				}else {
					var grid = Ext.getCmp('${PKGNAME}Grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			loadStoreRecords: function(record)	{
				var param= {
					'DIV_CODE':record.get('DIV_CODE'),
					'PROMO_CD':record.get('PROMO_CD')
				}
				this.load({params: param});
			},
			listeners:{
				update:function(store)	{
					store.onSaveButton();
					
				},
				add:function(store)	{
					store.onSaveButton();
				},
				remove:function(store)	{
					store.onSaveButton();
				},
				load:function(store)	{
					store.onSaveButton();
				}
			},
			onSaveButton:function()		{
				var me = this;
				if(me.isDirty()){
					UniAppManager.setToolbarButtons('save', true);
					if(me.getCount() > 0 && promoGrid.isHidden()) UniAppManager.setToolbarButtons('delete', true);
					else if(promoStore.getCount() < 1 && promoGrid.isVisible()) UniAppManager.setToolbarButtons('delete', false);
				}else {
					if(!promoStore.isDirty())	{
						UniAppManager.setToolbarButtons('save', false);
					}
				}
			}
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '행사등록',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '검색조건', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:80
		           	},
			    	items:[{	    
						fieldLabel: '사업장',
						name: 'DIV_CODE',
						xtype:'uniCombobox',
						comboType: 'BOR120',
						value:UserInfo.divCode,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('DIV_CODE', newValue);
							}
						}
					},{	    
						fieldLabel: '행사년도',
						name: 'PROMO_YYYY',
						xtype: 'uniYearField',
						value: UniDate.today(),
						minValue: '2015',
   						maxValue: '2025',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('PROMO_YYYY', newValue);
							}
						}
					},{	    
						fieldLabel: '행사명',
						name: 'PROMO_NM',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('PROMO_NM', newValue);
							}
						}
					}]				
				}]
		
	});	//end panelSearch    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	weight:-100,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [
			{	    
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype:'uniCombobox',
				comboType: 'BOR120',
				value:UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{	    
				fieldLabel: '행사년도',
				name: 'PROMO_YYYY',
				xtype: 'uniYearField',
				value: UniDate.today(),
				minValue: '2015',
				maxValue: '2025',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PROMO_YYYY', newValue);
					}
				}
			},{	    
				fieldLabel: '행사명',
				name: 'PROMO_NM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PROMO_NM', newValue);
					}
				}
			}
		]
    });		
    
    
    var masterForm = Unilite.createForm('${PKGNAME}masterForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		disabled:false,
		masterGrid:promoGrid,
		items: [
			{	    
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype:'uniCombobox',
				comboType: 'BOR120',
				value:UserInfo.divCode,
				allowBlank:false
			},{	    
				fieldLabel: '행사분류',
				name: 'PROMO_CLASS',
				xtype:'uniCombobox',
				allowBlank:false,
				value:'1',
				store: Ext.data.StoreManager.lookup('promoClassStore'),
				listeners:{
					change:function(field, newValue, oldValue)	{
						if(newValue == '1')	{
//							masterForm.down('#singleSale').show();
//							masterForm.down('#multiSale').hide();
//							masterGrid.getColumn('SALE_BASIS_P').show();
//							masterGrid.getColumn('DC_VALUE').show();
//							masterGrid.getColumn('MIX_MATCH_TYPE').hide();
							
							masterForm.down('#singleSale').hide();
							masterForm.down('#multiSale').hide();
							masterGrid.getColumn('SALE_BASIS_P').show();
							masterGrid.getColumn('DC_VALUE').show();
							masterGrid.getColumn('MIX_MATCH_TYPE').hide();
						}else {
							masterForm.down('#singleSale').hide();
							masterForm.down('#multiSale').show();
							masterGrid.getColumn('SALE_BASIS_P').hide();
							masterGrid.getColumn('DC_VALUE').hide();
							masterGrid.getColumn('MIX_MATCH_TYPE').show();
						}
					}
				}
			},{	    
				fieldLabel: '행사년도',
				name: 'PROMO_YYYY',
				xtype: 'uniYearField',
				value: UniDate.today(),
				minValue: '2015',
				maxValue: '2025',
				allowBlank:false
			},{	    
				fieldLabel: '행사코드',
				name: 'PROMO_CD',
				readOnly:true
			},{	    
				fieldLabel: '행사명',
				name: 'PROMO_NM',
				colspan:2
			},{	    
				fieldLabel: '행사시작일',
				name: 'PROMO_START_DATE',
				xtype:'uniDatefield',				
				allowBlank:false
			},{	    
				fieldLabel: '행사종료일',
				name: 'PROMO_END_DATE',
				xtype:'uniDatefield',
				colspan:2,
				allowBlank:false
			},{
				xtype:'container',
				itemId:'multiSale',
				colspan:3,
				layout : {type : 'uniTable', columns : 3},
				defaultType:'uniTextfield',
				hidden:true,
				items:[
					{
						fieldLabel:'행사종류',
						name:'THRE_TYPE',
						xtype:'uniCombobox',
						store: Ext.data.StoreManager.lookup('threTypeStore')
					},{
						fieldLabel:'조건수량',
						name:'COND_AMT',
						xtype:'uniNumberfield'
					},{
						fieldLabel:'할인율',	
						name:'DC_VALUE', 
						xtype: 'uniNumberfield', 
						minValue:0, 
						maxValue:100, 
						decimalPrecision:2,
						suffixTpl:'&nbsp;%'
					}
				]
			},{
				xtype:'container',
				itemId:'singleSale',
				colspan:3,
				layout : {type : 'uniTable', columns : 4},
				defaultType:'uniTextfield',
				items:[
					{
						fieldLabel:'할인율적용'	,	
						name:'DC_RATE', 
						xtype: 'uniNumberfield', 
						minValue:0, 
						maxValue:100, 
						width:245,
						decimalPrecision:2,
						suffixTpl:'&nbsp;%'
					},{
						fieldLabel:'끝단위'	,
						name:'COND_DC',
						xtype:'uniNumberfield',
						width:245,
						value:1,
						suffixTpl:'&nbsp;원'
					},{
						hideLabel:'true',
						xtype:'uniRadiogroup',
						name:'price',
						width:130,
						items: [
            				{ boxLabel: '버림', name: 'price', inputValue: 'floor' },
            				{ boxLabel: '반올림', name: 'price', inputValue: 'round' , checked:true}
            			]
					},{
						xtype:'button',
						width:115,
						text:'할인가격적용',
						handler:function()	{
							masterForm.changeDC();
						}
					}
				]
			}
			],
			changeDC : function(value)	{
				var me = this;
				if(me.getValue('PROMO_CLASS') == '1')	{
					
					Ext.each(masterStore.data.items, function(record, idx){
						var orgPrice = record.get('SALE_BASIS_P');
						var condDc = me.getValue('COND_DC');
						var dcRate = me.getValue('DC_RATE');
						var rv =  orgPrice;
						if( me.getValue('price').price == 'floor')	{
							rv = Math.floor((orgPrice/condDc) - (orgPrice/condDc*(dcRate/100)))*condDc
						} else {
							rv = Math.round((orgPrice/condDc) - (orgPrice/condDc*(dcRate/100)))*condDc
						}
						record.set('DC_VALUE', rv);
					})
				}
			}
    });
    var promoGrid =  Unilite.createGrid('${PKGNAME}PromoGrid', {
        layout : 'fit',      
    	store: promoStore,
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
		columns:[
			{dataIndex:'PROMO_CD'			,width: 80, hideable:false, isLink:true},
			{dataIndex:'PROMO_NM'			,width: 150},
			{dataIndex:'PROMO_YYYY'			,width: 80},
			{dataIndex:'PROMO_CLASS'		,width: 100},
			{dataIndex:'PROMO_START_DATE'	,width: 100},
			{dataIndex:'PROMO_END_DATE'		,width: 100},
			{dataIndex:'REMARK'				,flex: 1}
		] , 
         listeners: {          	
          	selectionchangerecord:function(selected)	{
          		masterForm.setActiveRecord(selected);
          		masterStore.loadStoreRecords(selected);
          	},
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(!record.phantom) {
	      			switch(colName)	{
					case 'PROMO_CD' :
							UniAppManager.app.changePanelView('form');
							break;		
					default:
							break;
	      			}
          		}
          	}
         }
   });
     var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
        layout : 'fit',        
    	region:'center',
    	store: masterStore,
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
		columns:[
			{dataIndex:'PROMO_CD'			,width: 100},
			{dataIndex:'COND_SEQ'		,width: 80},
			{dataIndex:'PROMO_CLASS'		,width: 100, hidden:false},
			{dataIndex:'ITEM_CODE'		,width: 150 ,
			editor: Unilite.popup('DIV_PUMOK_G', {
						textFieldName:'ITEM_CODE',
			    		DBtextFieldName: 'ITEM_CODE',
						listeners: {
							'onSelected': {
								fn: function(records, type) {
					                   console.log('records : ', records);
					                   Ext.getBody().mask();
					                   var param = {
					                   	 'DIV_CODE': masterGrid.uniOpt.currentRecord.get('DIV_CODE'),
					                   	 'PROMO_YYYY': masterGrid.uniOpt.currentRecord.get('PROMO_YYYY'),
					                   	 'PROMO_CD':masterGrid.uniOpt.currentRecord.get('PROMO_CD'),
					                   	 'ITEM_CODE': records[0].ITEM_CODE,
					                   	 'PROMO_START_DATE': UniDate.getDateStr(masterGrid.uniOpt.currentRecord.get('PROMO_START_DATE')),
					                   	 'PROMO_END_DATE': UniDate.getDateStr(masterGrid.uniOpt.currentRecord.get('PROMO_END_DATE'))
					                   }
					                   prm100ukrvService.chkItem(param, function(response, provider){
					                   	console.log("provider:",provider)
					                   	if(!provider.result)	{
						                   masterGrid.uniOpt.currentRecord.set('ITEM_CODE', records[0].ITEM_CODE);
						                   masterGrid.uniOpt.currentRecord.set('ITEM_NAME', records[0].ITEM_NAME);
						                   masterGrid.uniOpt.currentRecord.set('SALE_BASIS_P', records[0].SALE_BASIS_P);
						                   masterGrid.uniOpt.currentRecord.set('SALE_BASIS_P', records[0].SALE_BASIS_P);
					                   	}else {
					                   		alert('행사코드 '+provider.result['PROMO_CD']+'에서 사용중인 품목입니다.');
					                   		masterGrid.uniOpt.currentRecord.set('ITEM_CODE', '');
					                   		masterGrid.uniOpt.currentRecord.set('ITEM_NAME', '');
					                   		masterGrid.uniOpt.currentRecord.set('SALE_BASIS_P', '');
					                  		masterGrid.uniOpt.currentRecord.set('SALE_BASIS_P', '');			
					                   	}
					                   	 Ext.getBody().unmask()
					                   })
									},
								scope: this
								},
							'onClear': function(type) {
 									  	masterGrid.uniOpt.currentRecord.set('ITEM_CODE', '');
				                   		masterGrid.uniOpt.currentRecord.set('ITEM_NAME', '');
				                   		masterGrid.uniOpt.currentRecord.set('SALE_BASIS_P', '');
				                  		masterGrid.uniOpt.currentRecord.set('SALE_BASIS_P', '');				
							},
							applyextparam: function(popup){						
								popup.setExtParam({'DIV_CODE': Unilite.nvl(masterForm.getValue('DIV_CODE'), UserInfo.divCode)});
							}			
						}
					})
			},
			{dataIndex:'ITEM_NAME'		,width: 150 ,
			 editor: Unilite.popup('DIV_PUMOK_G', {
						listeners: {
							'onSelected': {
								fn: function(records, type) {
					                   console.log('records : ', records);
					                   masterGrid.uniOpt.currentRecord.set('ITEM_CODE', records[0].ITEM_CODE);
					                   masterGrid.uniOpt.currentRecord.set('ITEM_NAME', records[0].ITEM_NAME);
					                   masterGrid.uniOpt.currentRecord.set('SALE_BASIS_P', records[0].SALE_BASIS_P);
					                   masterGrid.uniOpt.currentRecord.set('SALE_BASIS_P', records[0].SALE_BASIS_P);
									},
								scope: this
								},
							'onClear': function(type) {
 											
										},
							applyextparam: function(popup){						
								popup.setExtParam({'DIV_CODE': Unilite.nvl(masterForm.getValue('DIV_CODE'), UserInfo.divCode)});
							}			
						}
					})
			},
			{dataIndex:'MIX_MATCH_TYPE'		,width: 100},
			{dataIndex:'SALE_BASIS_P'	,width: 110},
			{dataIndex:'DC_VALUE'		,width: 80, summaryType: 'sum'},
			{dataIndex:'REMARK'				,flex: 1}
		] 
   });
   
	
      Unilite.Main({
		borderItems:[
	 		  panelSearch,
	 		  panelResult,
	 		  {	region:'center',
				//layout : 'border',
				title:'행사정보',
				layout : {type:'vbox', align:'stretch'},
				flex:1,
				autoScroll:true,
				tools: [
					{
						type: 'hum-grid',					            
			            handler: function () {
			            	UniAppManager.app.changePanelView('grid');
			            }
					},{
			
						type: 'hum-photo',					            
			            handler: function () {
			  			 	UniAppManager.app.changePanelView('form');
			            }
					}
				],
				items:[		
						  promoGrid,
				 		  {
				 		  	flex:1,
				 		  	hidden:true,
				 		  	itemId:'detailForm',
				 		  	region:'center',
				 		  	xtype:'panel',
				 		  	layout:'border',
				 		  	items:[
				 		  		masterForm
				 		  		,masterGrid
				 		  	]
				 		  
				 		  }
				 ]
	 		  }
	 		 
	 		 
		],
		id  : 'prm100ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'newData' ],true);
		},
		
		onQueryButtonDown : function()	{
			this.changePanelView('grid');
			UniAppManager.app.changePanelView('grid');
			promoStore.loadStoreRecords();
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},	
		onNewDataButtonDown:  function()	{
			if(promoGrid.isVisible())	{
				UniAppManager.app.changePanelView('form', true);
			}else {
				var param=masterForm.getValues();
				if(masterForm.isValid())	{
					
						masterForm.getField('PROMO_CLASS').setReadOnly(true);
						masterForm.getField('PROMO_YYYY').setReadOnly(true);
						masterForm.getField('DIV_CODE').setReadOnly(true);
						param['COND_SEQ'] = isNaN(masterStore.max('COND_SEQ')) ? 1:masterStore.max('COND_SEQ')+1;
						masterGrid.createRow(param);
				}
			}
		},	
		
		onSaveDataButtonDown: function (config) {
			if(promoStore.isDirty())	{
				
				var paramMaster = masterForm.getValues()
				var config={
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						var promoCd	= master.PROMO_CD;
								
						
						if(masterStore.isDirty()){
								
								
								Ext.each(masterStore.data.items, function(record, idx){
									record.set('PROMO_CD', promoCd);
								})
							masterForm.setValue('PROMO_CD', promoCd)	;
							//masterForm.setActiveRecord(promoGrid.getSelectedRecord());
							masterStore.saveStore();
							
						}
					}
				}
				promoStore.saveStore(config);
			}else if(masterStore.isDirty())	{
				masterStore.saveStore();
			}
					
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(promoGrid.isHidden())	{
					masterGrid.deleteSelectedRow();
					if(masterStore.getCount() == 0 && promoGrid.getSelectedRecord().phantom)	{
						masterForm.getField('PROMO_CLASS').setReadOnly(false);
						masterForm.getField('PROMO_YYYY').setReadOnly(false);
						masterForm.getField('DIV_CODE').setReadOnly(false);
					}
				}
				else {
					promoGrid.deleteSelectedRow();		
				}
			}
		},
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			masterStore.loadData({});
			promoStore.loadData({});
			masterForm.clearForm()
			UniAppManager.setToolbarButtons('save',false);
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		},
		changePanelView:function(type, isNew)	{
			if(type == 'grid')	{
            	if(!masterStore.isDirty()){
					var detailForm = UniAppManager.app.down('#detailForm');
	            	detailForm.hide();
	                promoGrid.show();
	                //promoStore.uniOpt.isMaster = true;
	                if(promoStore.getCount() > 0) UniAppManager.setToolbarButtons('delete', true);
					else UniAppManager.setToolbarButtons('delete', false);
	            }else {
	            	alert('먼저 저장하세요.');
	            }
			}else {
				if(!promoStore.isDirty())	{
					var detailForm = UniAppManager.app.down('#detailForm');
	            	detailForm.show();
	                promoGrid.hide();
	                //masterStore.uniOpt.isMaster = true;
	                if(masterStore.getCount() > 0) UniAppManager.setToolbarButtons('delete', true);
					else UniAppManager.setToolbarButtons('delete', false);
	                if(isNew)  promoGrid.createRow();
				}else {
	            	alert('먼저 저장하세요.');
	            }
			}
		}
	});

	
	
}; // main
  
</script>