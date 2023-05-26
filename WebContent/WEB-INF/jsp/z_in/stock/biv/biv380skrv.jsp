<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv380skrv"  >

	<t:ExtComboStore comboType="BOR120" pgmId="biv380skrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 				<!-- 계정구분 -->
	//<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>		<!--창고-->
	<t:ExtComboStore comboType="O" storeId="whList" />   				<!--창고(전체) -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의
	 * @type
	 */

	Unilite.defineModel('Biv380skrvModel', {
	    fields: [
	    	{name: 'ITEM_ACCOUNT_NAME', text:'<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',	 		type:'string'},
	    	{name: 'ACCOUNT1',			text:'<t:message code="system.label.inventory.itemaccountcode" default="품목계정코드"/>', 		type:'string'},
	    	{name: 'ITEM_LEVEL1_NAME',	text:'<t:message code="system.label.inventory.majorgroup" default="대분류"/>',	 	type:'string'},
	    	{name: 'ITEM_LEVEL2_NAME',	text:'<t:message code="system.label.inventory.middlegroup" default="중분류"/>',	 	type:'string'},
	    	{name: 'ITEM_LEVEL3_NAME',	text:'<t:message code="system.label.inventory.minorgroup" default="소분류"/>',	 	type:'string'},
	    	{name: 'ITEM_CODE',			text:'<t:message code="system.label.inventory.item" default="품목"/>', 		type:'string'},
	    	{name: 'ITEM_NAME',			text:'<t:message code="system.label.inventory.itemname" default="품목명"/>',	 	type:'string'},
	    	{name: 'SPEC',				text:'<t:message code="system.label.inventory.spec" default="규격"/>',	 		type:'string'},
	    	{name: 'STOCK_UNIT',		text:'<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>', 		type:'string'},
	    	{name: 'STOCK_P',			text:'<t:message code="system.label.inventory.inventoryprice" default="재고단가"/>', 		type:'uniUnitPrice'},
	    	{name: 'WGT_UNIT',			text:'<t:message code="system.label.inventory.weightunit" default="중량단위"/>', 		type:'string'},
	    	{name: 'UNIT_WGT',			text:'<t:message code="system.label.inventory.unitweight" default="단위중량"/>', 		type:'string'},
	    	{name: 'PACK_UNIT',			text:'<t:message code="system.label.inventory.packagingunit" default="포장단위"/>', 		type:'string'},
	    	{name: 'TRANS_RATE',		text:'<t:message code="system.label.inventory.packagingcontainedqty" default="포장입수"/>',	 	type:'string'},
	    	{name: 'INOUT_DATE',		text:'<t:message code="system.label.inventory.tranyearmonth" default="수불년월"/>', 		type:'string'},
	    	{name: 'BOX_BASIS_Q',		text:'<t:message code="system.label.inventory.packingqty" default="포장수량"/>', 		type:'uniQty'},
	    	{name: 'EA_BASIS_Q',		text:'<t:message code="system.label.inventory.Individualqty" default="낱개수량"/>', 		type:'uniQty'},
	    	{name: 'BASIS_Q',			text:'<t:message code="system.label.inventory.qty" default="수량"/>',	 		type:'uniQty'},
	    	{name: 'BASIS_WGT_Q',		text:'<t:message code="system.label.inventory.weight" default="중량"/>',	 		type:'string'},
	    	{name: 'BASIS_I',			text:'<t:message code="system.label.inventory.amount" default="금액"/>',	 		type:'uniPrice'},
	    	{name: 'BOX_INSTOCK_Q',		text:'<t:message code="system.label.inventory.packingqty" default="포장수량"/>', 		type:'uniQty'},
	    	{name: 'EA_INSTOCK_Q',		text:'<t:message code="system.label.inventory.Individualqty" default="낱개수량"/>', 		type:'uniQty'},
	    	{name: 'INSTOCK_Q',			text:'<t:message code="system.label.inventory.qty" default="수량"/>',	 		type:'uniQty'},
	    	{name: 'INSTOCK_WGT_Q',		text:'<t:message code="system.label.inventory.weight" default="중량"/>',	 		type:'string'},
	    	{name: 'INSTOCK_I',			text:'<t:message code="system.label.inventory.amount" default="금액"/>',	 		type:'uniPrice'},
	    	{name: 'BOX_OUTSTOCK_Q',	text:'<t:message code="system.label.inventory.packingqty" default="포장수량"/>', 		type:'uniQty'},
	    	{name: 'EA_OUTSTOCK_Q',		text:'<t:message code="system.label.inventory.Individualqty" default="낱개수량"/>', 		type:'uniQty'},
	    	{name: 'OUTSTOCK_Q',		text:'<t:message code="system.label.inventory.qty" default="수량"/>',	 		type:'uniQty'},
	    	{name: 'OUTSTOCK_WGT_Q',	text:'<t:message code="system.label.inventory.weight" default="중량"/>',	 		type:'string'},
	    	{name: 'OUTSTOCK_I',		text:'<t:message code="system.label.inventory.amount" default="금액"/>',	 		type:'uniPrice'},
	    	{name: 'BOX_STOCK_Q',		text:'<t:message code="system.label.inventory.packingqty" default="포장수량"/>', 		type:'uniQty'},
	    	{name: 'EA_STOCK_Q',		text:'<t:message code="system.label.inventory.Individualqty" default="낱개수량"/>', 		type:'uniQty'},
	    	{name: 'STOCK_Q',			text:'<t:message code="system.label.inventory.qty" default="수량"/>',	 		type:'uniQty'},
            {name: 'STOCK_WGT_Q',		text:'<t:message code="system.label.inventory.weight" default="중량"/>',	 		type:'string'},
            {name: 'STOCK_I',			text:'<t:message code="system.label.inventory.amount" default="금액"/>',	 		type:'uniPrice'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('biv380skrvMasterStore1',{
			model: 'Biv380skrvModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'biv380skrvService.selectList'
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});

			},
			groupField: 'ITEM_ACCOUNT_NAME',
			listeners:{
				load:function( store, records, successful, operation, eOpts )	{
					if(records && records.length > 0){
						masterGrid.setShowSummaryRow(true);
					}
				}
	        }

	});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			    items: [{
						fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
						name:'DIV_CODE',
						xtype: 'uniCombobox',
						comboType:'BOR120',
						comboCode:'B001',
						child:'WH_CODE',
						allowBlank:false,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('DIV_CODE', newValue);
							}
						}
					},{
						fieldLabel: '<t:message code="system.label.inventory.account" default="계정"/>',
						name:'ITEM_ACCOUNT',
						xtype: 'uniCombobox',
						comboType:'AU',
//						allowBlank:false,
						comboCode:'B020',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('ITEM_ACCOUNT', newValue);
							}

						}
					},{
						fieldLabel: '<t:message code="system.label.inventory.tranyearmonth" default="수불년월"/>',
		 		        width: 315,
//						allowBlank:false,
		                xtype: 'uniMonthRangefield',
		                startFieldName: 'FR_INOUT_DATE',
		                endFieldName: 'TO_INOUT_DATE',
		                startDate: UniDate.get('today'),
		                endDate: UniDate.get('today'),
		                onStartDateChange: function(field, newValue, oldValue, eOpts) {
		                	if(panelResult) {
								panelResult.setValue('FR_INOUT_DATE',newValue);
		                	}
					    },
					    onEndDateChange: function(field, newValue, oldValue, eOpts) {
					    	if(panelResult) {
					    		panelResult.setValue('TO_INOUT_DATE',newValue);
					    	}
					    }
		            },{
 						fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
 						name:'WH_CODE',
 						xtype: 'uniCombobox',
// 						allowBlank: false,
 						store: Ext.data.StoreManager.lookup('whList'),
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('WH_CODE', newValue);
							}
						}
 					},
	 					Unilite.popup('DIV_PUMOK',{
							fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
							valueFieldName: 'ITEM_CODE',
							textFieldName: 'ITEM_NAME',
							listeners: {
								'onValueFieldChange': function(field, newValue, oldValue  ){
                                     panelResult.setValue('ITEM_CODE',newValue);
                                 },
                                'onTextFieldChange':  function( field, newValue, oldValue  ){
                                     panelResult.setValue('ITEM_NAME',newValue);
                                },
								applyextparam: function(popup){
									popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								}
							}
					})]
			},{
				title: '<t:message code="system.label.inventory.additionalinfo" default="추가정보"/>',
				itemId: 'search_panel2',
		       	layout: {type: 'uniTable', columns: 1},
		       	defaultType: 'uniTextfield',
				    items: [{
						xtype: 'radiogroup',
						fieldLabel: '<t:message code="system.label.inventory.movementyn" default="이동포함여부"/>',
						labelWidth:90,
						items : [{
							boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
							width: 60,
							name: 'MOVE_FLAG',
							inputValue: 'Y',
							checked: true
						},{
							boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
							width: 60,
							name: 'MOVE_FLAG' ,
							inputValue: 'N'
						}]
					},{
						xtype: 'radiogroup',
						fieldLabel: '<t:message code="system.label.inventory.stockcountingyn" default="실사포함여부"/>',
						labelWidth:90,
						items : [{
							boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
							width: 60,
							name: 'EVAL_FLAG',
							inputValue: 'Y',
							checked: true
						},{
							boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
							width: 60,
							name: 'EVAL_FLAG' ,
							inputValue: 'N'
						}]
					},{
						xtype: 'radiogroup',
						fieldLabel: '<t:message code="system.label.inventory.inventorymanageobject" default="재고관리대상"/>',
						//
						labelWidth:90,
						items : [{
							boxLabel: '<t:message code="system.label.inventory.whole" default="전체"/>',
							width: 60,
							name: 'STOCK_CARE_YN',
							inputValue: 'A'
						},{
							boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
							width: 60,
							name: 'STOCK_CARE_YN' ,
							inputValue: 'Y',
							checked: true
						},{
							boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
							width: 60,
							name: 'STOCK_CARE_YN' ,
							inputValue: 'N'
						}]
					},{
						xtype: 'radiogroup',
						fieldLabel: '<t:message code="system.label.inventory.system.label.inventory.subcontractincludeyesornot" default="사급포함여부"/>',
						labelWidth:90,
						items : [{
							boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
							width: 60,
							name: 'INCLUDE_FLAG',
							inputValue: 'Y',
							checked: true
						},{
							boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
							width: 60,
							name: 'INCLUDE_FLAG' ,
							inputValue: 'N'
						}]
					},{
	            		fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
	            		name: 'ITEM_LEVEL1',
	            		xtype: 'uniCombobox' ,
	            		store: Ext.data.StoreManager.lookup('itemLeve1Store'),
	            		child: 'ITEM_LEVEL2'
	            	},{
	            		fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>' ,
	            		name: 'ITEM_LEVEL2' , xtype:
	            		'uniCombobox' ,
	            		store: Ext.data.StoreManager.lookup('itemLeve2Store'),
	            		child: 'ITEM_LEVEL3',	labelWidth:90
	            	},{
	            		fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
	            		name: 'ITEM_LEVEL3',
	            		xtype: 'uniCombobox',
	            		store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				        parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
				        levelType:'ITEM'
	            	}
				]
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
			   		alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

    var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
					fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					comboCode:'B001',
					child:'WH_CODE',
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.account" default="계정"/>',
					name:'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
//					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.tranyearmonth" default="수불년월"/>',
	 		        width: 315,
//					allowBlank:false,
	                xtype: 'uniMonthRangefield',
	                startFieldName: 'FR_INOUT_DATE',
	                endFieldName: 'TO_INOUT_DATE',
	                startDate: UniDate.get('today'),
	                endDate: UniDate.get('today'),
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelSearch.setValue('FR_INOUT_DATE',newValue);
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelSearch.setValue('TO_INOUT_DATE',newValue);
				    	}
				    }
	            },{
					fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
					name:'WH_CODE',
					xtype: 'uniCombobox',
//					allowBlank:false,
					store: Ext.data.StoreManager.lookup('whList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('WH_CODE', newValue);
						}
					}
				},
 					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
						valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						listeners: {
							'onValueFieldChange': function(field, newValue, oldValue  ){
                                   panelSearch.setValue('ITEM_CODE',newValue);
                            },
                            'onTextFieldChange':  function( field, newValue, oldValue  ){
                                   panelSearch.setValue('ITEM_NAME',newValue);
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
			   		alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('biv130skrvGrid1', {
    	region: 'center' ,
        layout : 'fit',
        store : directMasterStore1,
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
    	store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns:  [
        	{dataIndex:  'ITEM_ACCOUNT_NAME', width:73,  locked:true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.classficationtotal" default="분류계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
            }},
			{dataIndex:  'ACCOUNT1',		  width:73,  hidden:true},
			{dataIndex:  'ITEM_LEVEL1_NAME',  width:73,  locked:true},
			{dataIndex:  'ITEM_LEVEL2_NAME',  width:73,  locked:true},
			{dataIndex:  'ITEM_LEVEL3_NAME',  width:73,  locked:true},
			{dataIndex:  'ITEM_CODE',		  width:106, locked:true},
			{dataIndex:  'ITEM_NAME',		  width:133, locked:true},
			{dataIndex:  'SPEC',			  width:150, locked:true},
			{dataIndex:  'STOCK_UNIT',		  width:66},
			{dataIndex:  'STOCK_P',			  width:66},
			{dataIndex:  'WGT_UNIT',		  width:66},
			{dataIndex:  'UNIT_WGT',		  width:66},
			{dataIndex:  'PACK_UNIT',		  width:66},
			{dataIndex:  'TRANS_RATE',		  width:66},
			{dataIndex:  'INOUT_DATE',		  width:73},
			{
				text:'<t:message code="system.label.inventory.basic" default="기초"/>',
           		columns:[
	             	{dataIndex:'BOX_BASIS_Q', width:100, summaryType:'sum', hidden: true},
	             	{dataIndex:'EA_BASIS_Q',  width:100, summaryType:'sum', hidden: true},
	              	{dataIndex:'BASIS_Q',     width:100, summaryType:'sum'},
	               	{dataIndex:'BASIS_WGT_Q', width:100, summaryType:'sum', hidden: true},
	               	{dataIndex:'BASIS_I',     width:100, summaryType:'sum'}
	            ]
          	},{
          		text:'<t:message code="system.label.inventory.receipt" default="입고"/>',
           		columns:[
             		{dataIndex:'BOX_INSTOCK_Q',  width:100, summaryType:'sum', hidden: true},
             		{dataIndex:'EA_INSTOCK_Q',   width:100, summaryType:'sum', hidden: true},
              		{dataIndex:'INSTOCK_Q',      width:100, summaryType:'sum'},
               		{dataIndex:'INSTOCK_WGT_Q',  width:100, summaryType:'sum', hidden: true},
               		{dataIndex:'INSTOCK_I',      width:100, summaryType:'sum'}
                ]
          	},{
          		text:'<t:message code="system.label.inventory.issue" default="출고"/>',
           		columns:[
             		{dataIndex:'BOX_OUTSTOCK_Q', width:100, summaryType:'sum', hidden: true},
             		{dataIndex:'EA_OUTSTOCK_Q',  width:100, summaryType:'sum', hidden: true},
              		{dataIndex:'OUTSTOCK_Q',     width:100, summaryType:'sum'},
               		{dataIndex:'OUTSTOCK_WGT_Q', width:100, summaryType:'sum', hidden: true},
               		{dataIndex:'OUTSTOCK_I',     width:100, summaryType:'sum'}
                ]
          	},{
          		text:'<t:message code="system.label.inventory.inventory" default="재고"/>',
           		columns:[
             		{dataIndex:'BOX_STOCK_Q', width:100, summaryType:'sum', hidden: true},
             		{dataIndex:'EA_STOCK_Q',  width:100, summaryType:'sum', hidden: true},
              		{dataIndex:'STOCK_Q',     width:100, summaryType:'sum'},
               		{dataIndex:'STOCK_WGT_Q', width:100, summaryType:'sum', hidden: true},
               		{dataIndex:'STOCK_I',     width:100, summaryType:'sum'}
                 ]
          	}
		]
    });


    Unilite.Main( {
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
		id  : 'biv380skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
			biv380skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
		},
		onQueryButtonDown : function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.reset();
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
			panelSearch.getField('ITEM_ACCOUNT').focus();
			panelResult.getField('ITEM_ACCOUNT').focus();
			directMasterStore1.clearData();
			panelSearch.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_INOUT_DATE', UniDate.get('today'));
			panelResult.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('TO_INOUT_DATE', UniDate.get('today'));
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>
