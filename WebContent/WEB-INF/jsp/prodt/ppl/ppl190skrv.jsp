<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ppl190skrv"  >
	<t:ExtComboStore comboType="BOR120" /> 					 	 <!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /><!-- 작업장 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('Ppl190skrvModel', {
	    fields: [
	    	{name: 'BASE_DATE'				, text: '<t:message code="system.label.product.date" default="일자"/>'			, type: 'uniDate'},
	    	{name: 'WEEK_DAY'				, text: '<t:message code="system.label.product.day2" default="요일"/>'			, type: 'string'},
	    	{name: 'WORK_SHOP_CODE'			, text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'		, type: 'string'},
	    	{name: 'WORK_SHOP_CODE_NAME'	, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			, type: 'string'},
	    	{name: 'HOLY_TYPE'				, text: '<t:message code="system.label.product.workingtypecode" default="근무유형코드"/>'		, type: 'string'},
	    	{name: 'HOLY_TYPE_NAME'			, text: '<t:message code="system.label.product.workingtype" default="근무유형"/>'		, type: 'string'},
	    	{name: 'STD_CAPACITY'			, text: '<t:message code="system.label.product.realworkingtime" default="실가동시간"/>'		, type: 'uniQty'},
	    	{name: 'ALLOC_CAPACITY'			, text: '<t:message code="system.label.product.allocationhour" default="할당시간"/>'			, type: 'uniQty'},
	    	{name: 'IDLE_CAPACITY'			, text: '<t:message code="system.label.product.sparetime" default="여유시간"/>'		, type: 'uniQty'},
	    	{name: 'WK_PLAN_COUNT'			, text: '<t:message code="system.label.product.count" default="개수"/>'			, type: 'uniQty'},    // '생산계획개수'
	    	{name: 'WK_PLAN_ALLOC'			, text: '<t:message code="system.label.product.allocationhour" default="할당시간"/>'			, type: 'uniQty'},    // '생산계획할당시간'
	    	{name: 'WKORD_COUNT'			, text: '<t:message code="system.label.product.count" default="개수"/>'			, type: 'uniQty'},    // '작업지시개수'
	    	{name: 'WKORD_ALLOC'			, text: '<t:message code="system.label.product.allocationhour" default="할당시간"/>'			, type: 'uniQty'}     // '작업지시할당시간'
	    ]
	});		//End of Unilite.defineModel('Ppl190skrvModel', {


	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var MasterStore = Unilite.createStore('ppl190skrvMasterStore',{
			model: 'Ppl190skrvModel',
			uniOpt : {
            	isMaster: 	true,			// 상위 버튼 연결
            	editable: 	false,			// 수정 모드 사용
            	deletable:	false,			// 삭제 가능 여부
	            useNavi:	false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'ppl190skrvService.selectList'
                }
            },
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			},
   			listeners: {
                load: function(store, records, successful, eOpts) {
    				if(records[0].data != null){
    					if(records[0].get('STD_CAPACITY') == '63003' && records[0].get('ALLOC_CAPACITY') == '-9999'){
    						masterGrid.reset();
    						alert('해당 사업장이 존재하지 않습니다.\r\n\r\n' + records[0].get('BASE_DATE'));  // 경고창 안에서 줄바꾸기 -> \r\n
    						MasterStore.clearData();
    						panelSearch.setValue('DIV_CODE',UserInfo.divCode);
    						panelResult.setValue('DIV_CODE',UserInfo.divCode);
    						panelSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfWeek'));
    						panelSearch.setValue('ORDER_DATE_TO', UniDate.get('startOfNextWeek'));
    						panelResult.setValue('ORDER_DATE_FR', UniDate.get('startOfWeek'));
    						panelResult.setValue('ORDER_DATE_TO', UniDate.get('startOfNextWeek'));
    						UniAppManager.setToolbarButtons('reset',false);
    					}
    				}
    			}
            },
            groupField: 'BASE_DATE'
	});		// End of var directMasterStore1 = Unilite.createStore('ppl190skrvMasterStore1',{

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
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
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
			},{
				fieldLabel: '기간',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfWeek'),
				endDate: UniDate.get('startOfNextWeek'),
				allowBlank:false,
				width: 315,
				textFieldWidth: 200,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('ORDER_DATE_FR',newValue);
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('ORDER_DATE_TO',newValue);
				    	}
				    }
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('wsList'),
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WORK_SHOP_CODE', newValue);
						}
					}
			}]
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
    });		//End of var panelSearch = Unilite.createSearchForm('searchForm',{


    var panelResult = Unilite.createSearchForm('panelResultForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '기간',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfWeek'),
				endDate: UniDate.get('startOfNextWeek'),
				allowBlank:false,
				width: 315,
				textFieldWidth: 200,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_FR',newValue);
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('ORDER_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('wsList'),
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			}]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('ppl190skrvGrid', {
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
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
    	],
        columns:  [
        	{dataIndex: 'BASE_DATE'				, width: 100},
			{dataIndex: 'WEEK_DAY'				, width: 100},
			{dataIndex: 'WORK_SHOP_CODE'		, width: 120,	hidden: true},
			{dataIndex: 'WORK_SHOP_CODE_NAME'	, width: 120},
			{dataIndex: 'HOLY_TYPE'				, width: 100,	hidden: true},
			{dataIndex: 'HOLY_TYPE_NAME'		, width: 80},
			{dataIndex: 'STD_CAPACITY'			, width: 100,	align: 'right'},
			{dataIndex: 'ALLOC_CAPACITY'		, width: 88,	align: 'right'},
			{dataIndex: 'IDLE_CAPACITY'			, width: 88,	align: 'right'},
			{dataIndex: 'WK_PLAN_COUNT'			, width: 80,	hidden: true  },
			{dataIndex: 'WK_PLAN_ALLOC'			, width: 67,	hidden: true  },
			{dataIndex: 'WKORD_COUNT'			, width: 80,	hidden: true  },
			{dataIndex: 'WKORD_ALLOC'			, width: 70,	hidden: true  },
			{text: '생산계획',
				columns:[{dataIndex: 'WK_PLAN_COUNT',	width: 75, align: 'right'},
						 {dataIndex: 'WK_PLAN_ALLOC',	width: 95, align: 'right'}
						]},
			{text: '<t:message code="system.label.product.workorderstatus" default="작업지시현황"/>',
				columns:[{dataIndex: 'WKORD_COUNT',		width: 75, align: 'right'},
						 {dataIndex: 'WKORD_ALLOC',		width: 95, align: 'right'}
						]}
			]
    });		//End of var masterGrid1 = Unilite.createGrid('ppl190skrvGrid1', {

    Unilite.Main({
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            masterGrid, panelResult
         ]
      },
         panelSearch
      ],
		id : 'ppl190skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',false);
		},

		onQueryButtonDown: function(){
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}else{
				MasterStore.loadStoreRecords();
			}
			UniAppManager.setToolbarButtons('reset', true);
		},

		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
			MasterStore.clearData();
			panelSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfWeek'));
			panelSearch.setValue('ORDER_DATE_TO', UniDate.get('startOfNextWeek'));
			panelResult.setValue('ORDER_DATE_FR', UniDate.get('startOfWeek'));
			panelResult.setValue('ORDER_DATE_TO', UniDate.get('startOfNextWeek'));
		}
	});		// End of Unilite.Main( {
};
</script>

