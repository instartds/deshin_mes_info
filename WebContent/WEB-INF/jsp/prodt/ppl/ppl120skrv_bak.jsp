<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ppl120skrv"  >
<t:ExtComboStore comboType="BOR120"  /> 					 	<!-- 사업장 -->  
<t:ExtComboStore comboType="AU" comboCode="B020" /> 		 	<!-- 품목계정 -->
<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />	<!-- 작업장 -->

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {     
		/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Ppl120skrvModel', {
		fields: [
			{name: 'DIV_CODE'      	, text: '<t:message code="system.label.product.division" default="사업장"/>'	, type: 'string'},
			{name: 'ITEM_CODE'     	, text: '<t:message code="system.label.product.item" default="품목"/>'	, type: 'string'},
			{name: 'ITEM_NAME'      , text: '<t:message code="system.label.product.itemname" default="품목명"/>' 	, type: 'string'},
			{name: 'SPEC'           , text: '<t:message code="system.label.product.spec" default="규격"/>' 	, type: 'string'},
			{name: 'WORK_SHOP_CODE'	, text: '<t:message code="system.label.product.workcenter" default="작업장"/>' 	, type: 'string'},
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
			{name: 'DAY31_Q'       	, text: '31일' 	, type: 'uniQty'}
		]                           
	});		//End of Unilite.defineModel('Ppl120skrvModel', {
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */		
	var MasterStore = Unilite.createStore('ppl120skrvMasterStore',{
		model: 'Ppl120skrvModel',
		uniOpt: {
			isMaster: 	true,			// 상위 버튼 연결 
			editable: 	false,			// 수정 모드 사용 
    		deletable:	false,			// 삭제 가능 여부 
        	useNavi : 	false			// prev | next 버튼 사용
		},
		autoLoad: false,
 		proxy: {
			type: 'direct',
			api: {			
				read: 'ppl120skrvService.selectList0'                	
				 }
            },
            loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();			
					console.log( param );
					this.load({
						params : param
					});
				}
	});		//End of var directMasterStore1 = Unilite.createStore('ppl120skrvMasterStore1',{

	var MasterStore1 = Unilite.createStore('ppl120skrvMasterStore1',{
		model: 'Ppl120skrvModel',
		uniOpt: {
			isMaster: 	true,			// 상위 버튼 연결 
			editable: 	false,			// 수정 모드 사용 
    		deletable:	false,			// 삭제 가능 여부 
        	useNavi : 	false			// prev | next 버튼 사용
		},
		autoLoad: false,
 		proxy: {
			type: 'direct',
			api: {			
				read: 'ppl120skrvService.selectList1'                	
				 }
            },
            loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();			
					console.log( param );
					this.load({
						params : param
					});
				}/*,
				groupField: 'ITEM_NAME'*/
	});		//End of var directMasterStore1 = Unilite.createStore('ppl120skrvMasterStore1',{

	var MasterStore2 = Unilite.createStore('ppl120skrvMasterStore2',{
		model: 'Ppl120skrvModel',
		uniOpt: {
			isMaster: 	true,			// 상위 버튼 연결 
			editable: 	false,			// 수정 모드 사용 
    		deletable:	false,			// 삭제 가능 여부 
        	useNavi : 	false			// prev | next 버튼 사용
		},
		autoLoad: false,
 		proxy: {
			type: 'direct',
			api: {			
				read: 'ppl120skrvService.selectList2'                	
				 }
            },
            loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();			
					console.log( param );
					this.load({
						params : param
					});
				}/*,
				groupField: 'WORK_SHOP_CODE'*/
	});		//End of var directMasterStore1 = Unilite.createStore('ppl120skrvMasterStore1',{
	
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
            	allowBlank: false,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('FR_DATE', newValue);
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
			}),{
				fieldLabel: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
				name:'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			}]
		}],
		setAllFieldsReadOnly: function(b) { 								//////////////////////////// 필수값 입력안하고 조회버튼 눌렀을떄 메세지 처리 함수
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
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
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
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name:'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('wsList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('FR_DATE', newValue);
						}
				}
			},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					textFieldWidth:170,
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
			}),{
				fieldLabel: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
				name:'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid= Unilite.createGrid('ppl120skrvGrid', {
    	layout : 'fit',
    	region:'center',
        title: '<t:message code="system.label.product.itembystatus" default="품목별현황"/>',
        store : MasterStore1,
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
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        	columns: [
        		{dataIndex:'DIV_CODE'        , width: 0,	hidden: true},
        		{dataIndex:'ITEM_CODE'       , width: 102,  locked: true, 
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
		    		}
        		},
        		{dataIndex:'ITEM_NAME'       , width: 126,	locked: true},
        		{dataIndex:'SPEC'            , width: 126,	locked: true},
        		{dataIndex:'WORK_SHOP_CODE'	 , width: 100,	locked: true},
        		{dataIndex:'TOT_Q'           , width: 80,	summaryType: 'sum' ,   locked: true},
        		{dataIndex:'DAY1_Q'          , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY2_Q'          , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY3_Q'          , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY4_Q'          , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY5_Q'          , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY6_Q'          , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY7_Q'          , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY8_Q'          , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY9_Q'          , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY10_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY11_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY12_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY13_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY14_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY15_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY16_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY17_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY18_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY19_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY20_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY21_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY22_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY23_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY24_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY25_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY26_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY27_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY28_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY29_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY30_Q'         , width: 66 ,	summaryType: 'sum'},
        		{dataIndex:'DAY31_Q'         , width: 66 ,	summaryType: 'sum'}
		]                                    
    });	
    
    var masterGrid2= Unilite.createGrid('ppl120skrvGrid2', {
    	layout : 'fit',
    	region:'center',
        title: '작업장별현황',
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
        },
    	features: [
    		{id : 'masterGridSubTotal2', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal2' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        	columns: [
				{dataIndex:'WORK_SHOP_CODE'	 , width: 100,  locked: true, 
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
		    		}
				},
	        	{dataIndex:'DIV_CODE'        , width: 0,	hidden: true},
        		{dataIndex:'ITEM_CODE'       , width: 102,  locked: true},
        		{dataIndex:'ITEM_NAME'       , width: 126,  locked: true},
        		{dataIndex:'SPEC'            , width: 126,  locked: true},
        		{dataIndex:'TOT_Q'           , width: 80,	summaryType: 'sum' ,   locked: true},
        		{dataIndex:'DAY1_Q'          , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY2_Q'          , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY3_Q'          , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY4_Q'          , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY5_Q'          , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY6_Q'          , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY7_Q'          , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY8_Q'          , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY9_Q'          , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY10_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY11_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY12_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY13_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY14_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY15_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY16_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY17_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY18_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY19_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY20_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY21_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY22_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY23_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY24_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY25_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY26_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY27_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY28_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY29_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY30_Q'         , width: 66,	summaryType: 'sum'},
        		{dataIndex:'DAY31_Q'         , width: 66,	summaryType: 'sum'}
		]                                    
    });		//End of var masterGrid2 = Unilite.createGrid('ppl120skrvGrid1', {

    var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab:  0,
	    region: 'center',
	    items:  [
	         masterGrid,
	         masterGrid2
	    ]
	});

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
		id : 'ppl120skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			MasterStore.loadStoreRecords();
		},
		onQueryButtonDown: function() {		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}
			else{			
				var activeTabId = tab.getActiveTab().getId();
				var viewNormal = masterGrid.normalGrid.getView();
				var viewLocked = masterGrid.lockedGrid.getView();
				var viewNormal2 = masterGrid2.normalGrid.getView();
				var viewLocked2 = masterGrid2.lockedGrid.getView();
				if(activeTabId == 'ppl120skrvGrid'){				
					MasterStore1.loadStoreRecords();
					console.log("viewNormal : ",viewNormal);
					console.log("viewLocked : ",viewLocked);
			    	viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			    	viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    	viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			    	viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				}
				else if(activeTabId == 'ppl120skrvGrid2'){
					MasterStore2.loadStoreRecords();
					console.log("viewNormal2 : ",viewNormal2);
					console.log("viewLocked2 : ",viewLocked2);
			    	viewNormal2.getFeature('masterGridTotal2').toggleSummaryRow(true);
			    	viewNormal2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
			    	viewLocked2.getFeature('masterGridTotal2').toggleSummaryRow(true);
			    	viewLocked2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
				} 
			}
		},
		
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden()){
				as.show();
			}else {
				as.hide()
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});		// End of Unilite.Main
};
</script>

