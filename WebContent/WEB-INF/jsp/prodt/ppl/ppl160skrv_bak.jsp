<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ppl160skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 					 	<!-- 사업장 -->  
	<t:ExtComboStore comboType="WU" />                  <!-- 작업장  -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />	<!-- 작업장 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
 <style type="text/css">
	.x-grid-row-yellow table{
    background-color:'#yellow';
	}
</style>
<script type="text/javascript" >


function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Ppl160skrvModel', {
		fields: [
			{name: 'DIV_CODE'      	, text: '<t:message code="system.label.product.division" default="사업장"/>'	, type: 'string'},
			{name: 'ITEM_CODE'     	, text: '<t:message code="system.label.product.item" default="품목"/>'	, type: 'string'},
			{name: 'ITEM_NAME'     	, text: '<t:message code="system.label.product.itemname" default="품목명"/>'	, type: 'string'},
			{name: 'ITEM_INFO'      , text: '<t:message code="system.label.product.itemname" default="품목명"/>' 	, type: 'string'},
			{name: 'STOCK_UNIT'     , text: '<t:message code="system.label.product.unit" default="단위"/>' 	, type: 'string'},
			{name: 'SPEC'		    , text: '<t:message code="system.label.product.spec" default="규격"/>' 	, type: 'string'},
			{name: 'WORK_CODE'      , text: '작업장(H)', type: 'string'},
			{name: 'WORK_SHOP_CODE'	, text: '<t:message code="system.label.product.workcenter" default="작업장"/>' 	, type: 'string'},
			{name: 'GUBUN'          , text: '<t:message code="system.label.product.classfication" default="구분"/>'   , type: 'string'},
			//{name: 'DAY_OF_TheWEEK'	, text: '<t:message code="system.label.product.day2" default="요일"/>' 	, type: 'string'},
			{name: 'TOT_Q'         	, text: '<t:message code="system.label.product.monthlytotal" default="월합계"/>' 	, type: 'uniQty'},
			{name: 'DAY1_Q'         , text: '1일' 	, type: 'uniQty'},
			{name: 'DAY2_Q'        	, text: '2일' 	, type: 'uniQty'},
			{name: 'DAY3_Q'        	, text: '3일' 	, type: 'uniQty'},
			{name: 'DAY4_Q'        	, text: '4일' 	, type: 'uniQty'},
			{name: 'DAY5_Q'        	, text: '5일' 	, type: 'uniQty'},
			{name: 'DAY6_Q'        	, text: '6일' 	, type: 'uniQty'},
			{name: 'DAY7_Q'        	, text: '7일' 	, type: 'uniQty'},
			{name: 'DAY8_Q'        	, text: '8일' 	, type: 'uniQty'},
			{name: 'DAY9_Q'         , text: '9일' 	, type: 'uniQty'},
			{name: 'DAY10_Q'        , text: '10일' 	, type: 'uniQty'},
			{name: 'DAY11_Q'        , text: '11일' 	, type: 'uniQty'},
			{name: 'DAY12_Q'        , text: '12일' 	, type: 'uniQty'},
			{name: 'DAY13_Q'        , text: '13일' 	, type: 'uniQty'},
			{name: 'DAY14_Q'        , text: '14일' 	, type: 'uniQty'},
			{name: 'DAY15_Q'        , text: '15일' 	, type: 'uniQty'},
			{name: 'DAY16_Q'        , text: '16일' 	, type: 'uniQty'},
			{name: 'DAY17_Q'        , text: '17일' 	, type: 'uniQty'},
			{name: 'DAY18_Q'        , text: '18일' 	, type: 'uniQty'},
			{name: 'DAY19_Q'        , text: '19일' 	, type: 'uniQty'},
			{name: 'DAY20_Q'        , text: '20일' 	, type: 'uniQty'},
			{name: 'DAY21_Q'        , text: '21일' 	, type: 'uniQty'},
			{name: 'DAY22_Q'        , text: '22일' 	, type: 'uniQty'},
			{name: 'DAY23_Q'        , text: '23일' 	, type: 'uniQty'},
			{name: 'DAY24_Q'        , text: '24일' 	, type: 'uniQty'},
			{name: 'DAY25_Q'        , text: '25일' 	, type: 'uniQty'},
			{name: 'DAY26_Q'        , text: '26일' 	, type: 'uniQty'},
			{name: 'DAY27_Q'        , text: '27일' 	, type: 'uniQty'},
			{name: 'DAY28_Q'       	, text: '28일' 	, type: 'uniQty'},
			{name: 'DAY29_Q'       	, text: '29일' 	, type: 'uniQty'},
			{name: 'DAY30_Q'       	, text: '30일' 	, type: 'uniQty'},
			{name: 'DAY31_Q'       	, text: '31일' 	, type: 'uniQty'},
			{name: 'ITEM'       	, text: 'ITEM' 	, type: 'uniQty'}
		]                           
	});		//End of Unilite.defineModel('ppl160skrvModel', {
	
	Unilite.defineModel('Ppl160skrvModel2', {
		fields: [
			{name: 'DIV_CODE'      	, text: '<t:message code="system.label.product.division" default="사업장"/>'	, type: 'string'},
			{name: 'WORK_CODE'     	, text: '작업장(H)'	, type: 'string'},
			{name: 'WORK_SHOP_CODE' , text: '<t:message code="system.label.product.workcenter" default="작업장"/>' 	, type: 'string', comboType: 'WU'},
			{name: 'ITEM_CODE'     	, text: '<t:message code="system.label.product.item" default="품목"/>'	, type: 'string'},
			{name: 'ITEM_NAME'     	, text: '<t:message code="system.label.product.itemname" default="품목명"/>'	, type: 'string'},
			{name: 'ITEM_INFO'      , text: '<t:message code="system.label.product.itemname" default="품목명"/>' 	, type: 'string'},
			{name: 'STOCK_UNIT'     , text: '<t:message code="system.label.product.unit" default="단위"/>' 	, type: 'string'},
			{name: 'SPEC'		    , text: '<t:message code="system.label.product.spec" default="규격"/>' 	, type: 'string'},
			{name: 'GUBUN'          , text: '<t:message code="system.label.product.classfication" default="구분"/>'   , type: 'string'},
			//{name: 'DAY_OF_TheWEEK'	, text: '<t:message code="system.label.product.day2" default="요일"/>' 	, type: 'string'},
			{name: 'TOT_Q'         	, text: '<t:message code="system.label.product.monthlytotal" default="월합계"/>' 	, type: 'uniQty'},
			{name: 'DAY1_Q'         , text: '1일' 	, type: 'uniQty'},
			{name: 'DAY2_Q'        	, text: '2일' 	, type: 'uniQty'},
			{name: 'DAY3_Q'        	, text: '3일' 	, type: 'uniQty'},
			{name: 'DAY4_Q'        	, text: '4일' 	, type: 'uniQty'},
			{name: 'DAY5_Q'        	, text: '5일' 	, type: 'uniQty'},
			{name: 'DAY6_Q'        	, text: '6일' 	, type: 'uniQty'},
			{name: 'DAY7_Q'        	, text: '7일' 	, type: 'uniQty'},
			{name: 'DAY8_Q'        	, text: '8일' 	, type: 'uniQty'},
			{name: 'DAY9_Q'         , text: '9일' 	, type: 'uniQty'},
			{name: 'DAY10_Q'        , text: '10일' 	, type: 'uniQty'},
			{name: 'DAY11_Q'        , text: '11일' 	, type: 'uniQty'},
			{name: 'DAY12_Q'        , text: '12일' 	, type: 'uniQty'},
			{name: 'DAY13_Q'        , text: '13일' 	, type: 'uniQty'},
			{name: 'DAY14_Q'        , text: '14일' 	, type: 'uniQty'},
			{name: 'DAY15_Q'        , text: '15일' 	, type: 'uniQty'},
			{name: 'DAY16_Q'        , text: '16일' 	, type: 'uniQty'},
			{name: 'DAY17_Q'        , text: '17일' 	, type: 'uniQty'},
			{name: 'DAY18_Q'        , text: '18일' 	, type: 'uniQty'},
			{name: 'DAY19_Q'        , text: '19일' 	, type: 'uniQty'},
			{name: 'DAY20_Q'        , text: '20일' 	, type: 'uniQty'},
			{name: 'DAY21_Q'        , text: '21일' 	, type: 'uniQty'},
			{name: 'DAY22_Q'        , text: '22일' 	, type: 'uniQty'},
			{name: 'DAY23_Q'        , text: '23일' 	, type: 'uniQty'},
			{name: 'DAY24_Q'        , text: '24일' 	, type: 'uniQty'},
			{name: 'DAY25_Q'        , text: '25일' 	, type: 'uniQty'},
			{name: 'DAY26_Q'        , text: '26일' 	, type: 'uniQty'},
			{name: 'DAY27_Q'        , text: '27일' 	, type: 'uniQty'},
			{name: 'DAY28_Q'       	, text: '28일' 	, type: 'uniQty'},
			{name: 'DAY29_Q'       	, text: '29일' 	, type: 'uniQty'},
			{name: 'DAY30_Q'       	, text: '30일' 	, type: 'uniQty'},
			{name: 'DAY31_Q'       	, text: '31일' 	, type: 'uniQty'},
			{name: 'ITEM'       	, text: 'ITEM' 	, type: 'string'}
		] , setColumnHeader:function(record, grid, indexName, def) {
				var d = record.get(indexName);
				var column = grid.getColumn(indexName);
				alert(column)
				if(Ext.isEmpty(column))  {
					return ;
				}
				if(!Ext.isEmpty(d)) {
					column.setText(d);
				} else {
					column.setText(def);
				}
			}                          
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('ppl160skrvMasterStore',{
		model: 'Ppl160skrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
    		deletable:false,			// 삭제 가능 여부 
        	useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
 		proxy: {
			type: 'direct',
			api: {			
				read: 'ppl160skrvService.selectList'                	
				 }
            },
            loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();			
					console.log( param );
					param.QUERY_TYPE='1';
					this.load({
						params : param
					});
				},
				groupField: ''
	});		//End of var directMasterStore1 = Unilite.createStore('ppl160skrvMasterStore1',{
	
	var MasterStore2 = Unilite.createStore('ppl160skrvMasterStore2',{
		model: 'Ppl160skrvModel2',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
    		deletable:false,			// 삭제 가능 여부 
        	useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
 		proxy: {
			type: 'direct',
			api: {			
				read: 'ppl160skrvService.selectList'                	
				 }
            },
            loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();			
					console.log( param );
					param.QUERY_TYPE='2';
					this.load({
						params : param
					});
				},
				groupField: ''
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items: [{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		 		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		 		name:'DIV_CODE', 
		 		xtype: 'uniCombobox',
		 		comboType:'BOR120',
		 		allowBlank:false,
		 		value : UserInfo.divCode,
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
		 	},{
            	fieldLabel: '<t:message code="system.label.product.planmonth" default="계획월"/>',
            	name: 'FR_DATE',
            	xtype: 'uniMonthfield',
		 		value: UniDate.get('startOfMonth'),
				holdable: 'hold', 
            	allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('FR_DATE', newValue);
						/*var date=Ext.util.Format.date(panelSearch.getValue('FR_DATE'), 'Y-m-d');
						getDate(date);*/
					}
				}
            },{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name:'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('wsList'),
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('WORK_SHOP_CODE', newValue);
						}
					}
			},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					validateBlank:false,
					valueFieldName:'ITEM_CODE',
	        		textFieldName:'ITEM_NAME', 
					listeners: {
						onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
						},
						scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}					
			})]
		}],
		
		setAllFieldsReadOnly: function(b) {
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
																		return !field.validate();
																	});
   	
	   				if(invalid.length > 0) {
						r=false;
	   					var labelText = ''
	   	
						if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});
	
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
		 		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		 		name:'DIV_CODE', 
		 		xtype: 'uniCombobox',
		 		comboType:'BOR120',
		 		allowBlank:false,
		 		value : UserInfo.divCode,
		 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
					}
				}
		 	},{
		 		fieldLabel: '<t:message code="system.label.product.planmonth" default="계획월"/>',
		 		xtype: 'uniMonthfield',
		 		name: 'FR_DATE',
		 		value: UniDate.get('startOfMonth'),
		 		allowBlank:false,
		 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('FR_DATE', newValue);
					/*var date=Ext.util.Format.date(panelSearch.getValue('FR_DATE'), 'Y-m-d');
					getDate(date);*/
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name:'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('wsList'),
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					validateBlank:false,
					valueFieldName:'ITEM_CODE',
	        		textFieldName:'ITEM_NAME', 					
					listeners: {
						onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
							panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));				 																							
						},
						scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}		
			})],
		
		setAllFieldsReadOnly: function(b) {
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
																		return !field.validate();
																	});
   	
	   				if(invalid.length > 0) {
						r=false;
	   					var labelText = ''
	   	
						if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('ppl160skrvGrid', {
        region: 'center' ,
        layout : 'fit',
        store : MasterStore,
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },listeners:{
        	render: function(p,p2) { 
        			
				}
        },viewConfig:{
        		forceFit : true,
                stripeRows: false,//是否隔行换色
                getRowClass : function(record,rowIndex,rowParams,store){
                	var cls = '';
                    if(record.get('GUBUN')=="계획"){
                    	cls = 'x-change-cell_Background_essRow';	
                    }
                    return cls;
                }
            },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
    	],
        	columns: [
        		{dataIndex:'DIV_CODE'        , width: 0,	hidden: true},
        		
        		{dataIndex:'ITEM_CODE'      , width: 86,    locked: true},
        		{dataIndex:'ITEM_NAME'      , width: 86,    locked: true},
        		{dataIndex:'STOCK_UNIT', width : 66 	, summaryType: 'sum' , align: 'center',    locked: true},
//        		{dataIndex:'ITEM_INFO'       , width: 106,  locked: false},
        		{dataIndex:'SPEC', width : 66 	, summaryType: 'sum' , align: 'center',    locked: true},
        		{dataIndex:'WORK_SHOP_CODE'  , width: 89,   locked: true},
        		{dataIndex:'WORK_CODE'  	 , width: 89,   hidden: true},
        		{dataIndex:'GUBUN'			 , width: 89,   locked: true},
        		{dataIndex:'TOT_Q'           , width: 53,   locked: true},
        		{text :'1일',
	        			columns:[ 
	        				{dataIndex:'DAY1_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'2일',
	        			columns:[ 
	        				{dataIndex:'DAY2_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'3일',
	        			columns:[ 
	        				{dataIndex:'DAY3_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'4일',
	        			columns:[ 
	        				{dataIndex:'DAY4_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'5일',
	        			columns:[ 
	        				{dataIndex:'DAY5_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'6일',
	        			columns:[ 
	        				{dataIndex:'DAY6_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'7일',
	        			columns:[ 
	        				{dataIndex:'DAY7_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'8일',
	        			columns:[ 
	        				{dataIndex:'DAY8_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'9일',
	        			columns:[ 
	        				{dataIndex:'DAY9_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'10일',
	        			columns:[ 
	        				{dataIndex:'DAY10_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'11일',
	        			columns:[ 
	        				{dataIndex:'DAY11_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'12일',
	        			columns:[ 
	        				{dataIndex:'DAY12_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'13일',
	        			columns:[ 
	        				{dataIndex:'DAY13_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'14일',
	        			columns:[ 
	        				{dataIndex:'DAY14_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},{text :'15일',
	        			columns:[ 
	        				{dataIndex:'DAY15_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'16일',
	        			columns:[ 
	        				{dataIndex:'DAY16_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'17일',
	        			columns:[ 
	        				{dataIndex:'DAY17_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'18일',
	        			columns:[ 
	        				{dataIndex:'DAY18_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'19일',
	        			columns:[ 
	        				{dataIndex:'DAY19_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'20일',
	        			columns:[ 
	        				{dataIndex:'DAY20_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'21일',
	        			columns:[ 
	        				{dataIndex:'DAY21_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'22일',
	        			columns:[ 
	        				{dataIndex:'DAY22_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'23일',
	        			columns:[ 
	        				{dataIndex:'DAY23_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'24일',
	        			columns:[ 
	        				{dataIndex:'DAY24_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'25일',
	        			columns:[ 
	        				{dataIndex:'DAY25_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'26일',
	        			columns:[ 
	        				{dataIndex:'DAY26_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'27일',
	        			columns:[ 
	        				{dataIndex:'DAY27_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'28일',
	        			columns:[ 
	        				{dataIndex:'DAY28_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'29일',
	        			columns:[ 
	        				{dataIndex:'DAY29_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'30일',
	        			columns:[ 
	        				{dataIndex:'DAY30_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'31일',
	        			columns:[ 
	        				{dataIndex:'DAY31_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{dataIndex:'ITEM'         	 , width: 66,hidden:true}
        		
		]                                    
    });		//End of var masterGrid1 = Unilite.createGrid('ppl160skrvGrid1', {

    var masterGrid2 = Unilite.createGrid('ppl160skrvGrid2', {
        region: 'center' ,
        layout : 'fit',
        store : MasterStore2,
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },listeners:{
        	render: function(p,p2) { 
        			
				}
        },viewConfig:{
        		forceFit : true,
                stripeRows: false,//是否隔行换色
                getRowClass : function(record,rowIndex,rowParams,store){
                	var cls = '';
                    if(record.get('GUBUN')=="계획"){
                    	cls = 'x-change-cell_Background_essRow';	
                    }
                    return cls;
                }
            },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
    	],
        	columns: [
        		{dataIndex:'DIV_CODE'       , width: 0,	hidden: true},
        		{dataIndex:'WORK_CODE'      , width: 86,    hidden: true},
        		{dataIndex:'WORK_SHOP_CODE' , width: 86,    locked: true},
        		{dataIndex:'ITEM_CODE'      , width: 86,    locked: true},
        		{dataIndex:'ITEM_NAME'      , width: 86,    locked: true},
//        		{dataIndex:'ITEM_INFO'       , width: 106,  locked: false},
        		{dataIndex:'STOCK_UNIT', width : 66 	, summaryType: 'sum' , align: 'center',    locked: true},
        		{dataIndex:'SPEC', width : 66 	, summaryType: 'sum' , align: 'center',    locked: true},
        		{dataIndex:'GUBUN'			 , width: 89,   locked: true},
        		{dataIndex:'TOT_Q'           , width: 53,   locked: true},
        		{text :'1일',
	        			columns:[ 
	        				{dataIndex:'DAY1_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'2일',
	        			columns:[ 
	        				{dataIndex:'DAY2_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'3일',
	        			columns:[ 
	        				{dataIndex:'DAY3_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'4일',
	        			columns:[ 
	        				{dataIndex:'DAY4_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'5일',
	        			columns:[ 
	        				{dataIndex:'DAY5_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'6일',
	        			columns:[ 
	        				{dataIndex:'DAY6_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'7일',
	        			columns:[ 
	        				{dataIndex:'DAY7_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'8일',
	        			columns:[ 
	        				{dataIndex:'DAY8_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'9일',
	        			columns:[ 
	        				{dataIndex:'DAY9_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'10일',
	        			columns:[ 
	        				{dataIndex:'DAY10_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'11일',
	        			columns:[ 
	        				{dataIndex:'DAY11_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'12일',
	        			columns:[ 
	        				{dataIndex:'DAY12_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'13일',
	        			columns:[ 
	        				{dataIndex:'DAY13_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'14일',
	        			columns:[ 
	        				{dataIndex:'DAY14_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},{text :'15일',
	        			columns:[ 
	        				{dataIndex:'DAY15_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'16일',
	        			columns:[ 
	        				{dataIndex:'DAY16_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'17일',
	        			columns:[ 
	        				{dataIndex:'DAY17_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'18일',
	        			columns:[ 
	        				{dataIndex:'DAY18_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'19일',
	        			columns:[ 
	        				{dataIndex:'DAY19_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'20일',
	        			columns:[ 
	        				{dataIndex:'DAY20_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'21일',
	        			columns:[ 
	        				{dataIndex:'DAY21_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'22일',
	        			columns:[ 
	        				{dataIndex:'DAY22_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'23일',
	        			columns:[ 
	        				{dataIndex:'DAY23_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'24일',
	        			columns:[ 
	        				{dataIndex:'DAY24_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'25일',
	        			columns:[ 
	        				{dataIndex:'DAY25_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'26일',
	        			columns:[ 
	        				{dataIndex:'DAY26_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'27일',
	        			columns:[ 
	        				{dataIndex:'DAY27_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'28일',
	        			columns:[ 
	        				{dataIndex:'DAY28_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'29일',
	        			columns:[ 
	        				{dataIndex:'DAY29_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'30일',
	        			columns:[ 
	        				{dataIndex:'DAY30_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{text :'31일',
	        			columns:[ 
	        				{dataIndex:'DAY31_Q'	 , width: 66, summaryType: 'sum' , align: 'center'}
	        			]
        		},
        		{dataIndex:'ITEM'         	 , width: 66,hidden:true}
		]                                    
    });
    //创建标签页面板
	var tab = Unilite.createTabPanel('tabPanel',{
        activeTab: 0,
        region: 'center',
        items: [
                 {
                     title: '<t:message code="system.label.product.itemby" default="품목별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[masterGrid]
                     ,id: 'ppl160skrvGridTab'
                 },
                 {
                     title: '출고처별'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[masterGrid2]
                     ,id: 'ppl160skrvGridTab2' 
                 }
        ],
        listeners:  {
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
                var newTabId = newCard.getId();
                console.log("newCard:  " + newCard.getId());
                console.log("oldCard:  " + oldCard.getId());        
                //탭 넘길때마다 초기화
                UniAppManager.setToolbarButtons(['save', 'newData' ], false);
                panelResult.setAllFieldsReadOnly(false);
                var date=Ext.util.Format.date(panelSearch.getValue('FR_DATE'), 'Y-m-d');
				getDate(date);
                var activeTabId = tab.getActiveTab().getId();  
				if(activeTabId == 'ppl160skrvGridTab'){
					panelResult.setAllFieldsReadOnly(false);
			         masterGrid.getStore().loadStoreRecords();
			         UniAppManager.setToolbarButtons('excel',true);
				}
				if(activeTabId == 'ppl160skrvGridTab2' ){
					panelResult.setAllFieldsReadOnly(false);
					 masterGrid2.getStore().loadStoreRecords();
					 UniAppManager.setToolbarButtons('excel',true);
				} 
//              Ext.getCmp('confirm_check').hide(); //확정버튼 hidden
                
            } 
        }
    });
    function day_change()
    {
    	//var date=new Date(d);
    	for (var i = 1; i <= 31; i++) {
    		var column1=masterGrid.getColumn("DAY"+i+"_Q");
    		var column2=masterGrid2.getColumn("DAY"+i+"_Q");
    		console.log("column1.text",column1);
    		if(column1.text=="일"){
	    		column1.style="color:#ff0000";
	    		column2.style="color:#ff0000";
	    	}else if(column1.text=="토"){
	    		column1.style="color:#0000ff";
	    		column2.style="color:#0000ff";
	    	}else{
	    		column1.style="color:#000";
	    		column2.style="color:#000";
	    	}
    	}
    }
    function getDate(d)
	{
	var weekday=new Array(7);
	weekday[0]="일";
	weekday[1]="월";
	weekday[2]="화";
	weekday[3]="수";
	weekday[4]="목";
	weekday[5]="금";
	weekday[6]="토";
	var date=new Date(d);
	//获取年份
    var year = date.getFullYear();
    //获取当前月份
    var mouth = date.getMonth() + 1;
    date.setMonth(date.getMonth() + 1);
	date.setDate(0);
    //定义当月的最后一天；
    var days=date.getDate();
     if(days==31){
     	var column=masterGrid.getColumn("DAY31_Q");
     	var column2=masterGrid.getColumn("DAY30_Q");
     	var column3=masterGrid.getColumn("DAY29_Q");
    	column.show();
    	column2.show();
    	column3.show();
     }
    if(days<31&&days==30){
    	var column=masterGrid.getColumn("DAY31_Q");
    	column.hide();
    }
    if(days<30&&days==29){
    	var column=masterGrid.getColumn("DAY30_Q");
    	var column2=masterGrid.getColumn("DAY31_Q");
    	column.hide();
    	column2.hide();
    }
    if(days<29&&days==28){
    	var column=masterGrid.getColumn("DAY31_Q");
     	var column2=masterGrid.getColumn("DAY30_Q");
     	var column3=masterGrid.getColumn("DAY29_Q");
    	column.hide();
    	column2.hide();
    	column3.hide();
    }
    for(var i=1;i<=days;i++){
    	date.setDate(i);
    	var column1=masterGrid.getColumn("DAY"+i+"_Q");
    	var column2=masterGrid2.getColumn("DAY"+i+"_Q");
    	column1.setText(weekday[date.getDay()]);
    	column2.setText(weekday[date.getDay()]);
    }
	return weekday[date.getDay()];
	}
    Unilite.Main({
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            tab, panelResult
         ]
      },
         panelSearch
      ],
		id : 'ppl160skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			var date=Ext.util.Format.date(panelSearch.getValue('FR_DATE'), 'Y-m-d');
			getDate(date);
			day_change();
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
				}else{
					var date=Ext.util.Format.date(panelSearch.getValue('FR_DATE'), 'Y-m-d');
                	getDate(date);
                	day_change();
				var activeTabId = tab.getActiveTab().getId();  
				if(activeTabId == 'ppl160skrvGridTab'){
					panelResult.setAllFieldsReadOnly(false);
			         masterGrid.getStore().loadStoreRecords();
			         UniAppManager.setToolbarButtons('excel',true);
				}
				if(activeTabId == 'ppl160skrvGridTab2' ){
					panelResult.setAllFieldsReadOnly(false);
					 masterGrid2.getStore().loadStoreRecords();
					 UniAppManager.setToolbarButtons('excel',true);
				} 
/*			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ", viewLocked);
			console.log("viewNormal: ", viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);
*/			}
		},
		
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});		// End of Unilite.Main
};
</script>
