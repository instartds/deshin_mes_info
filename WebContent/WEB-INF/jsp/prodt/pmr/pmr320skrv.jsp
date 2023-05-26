<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr320skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B039"  /> 	<!-- 출고방식 -->
	<t:ExtComboStore comboType="AU" comboCode="B023"  /> 	<!-- 생산입고방식 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('pmr320skrvModel', {
	    fields: [
			{name: 'ORDER_NUM'       	, text: '수주번호'		,type: 'string'},
	    	{name: 'ITEM_CODE'       	, text: '<t:message code="system.label.product.item" default="품목"/>'		,type: 'string'},
		    {name: 'ITEM_NAME'       	, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		    ,type: 'string'},
		    {name: 'SPEC'            	, text: '<t:message code="system.label.product.spec" default="규격"/>'		    ,type: 'string'},
		    {name: 'OUT_METH'        	, text: '<t:message code="system.label.product.issuemethod" default="출고방법"/>'		,type: 'string' , comboType:'AU', comboCode:'B039'},
		    {name: 'RESULT_YN'       	, text: '<t:message code="system.label.product.receiptmethod" default="입고방법"/>'		,type: 'string' , comboType:'AU', comboCode:'B023'},
		    {name: 'WORK_SHOP_CODE'  	, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		,type: 'string', comboType:'W'},
		    {name: 'PROG_WORK_NAME'       	, text: '공정명'	,type: 'string'},
		    {name: 'PRODT_WKORD_DATE' , text: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>'       ,type: 'uniDate'},
		    {name: 'WKORD_NUM'       	, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	,type: 'string'},
		    {name: 'LOT_NO'          	, text: '<t:message code="system.label.product.lotno" default="LOT NO"/>'	    ,type: 'string'},
		    {name: 'PRODT_START_DATE'	, text: '<t:message code="system.label.product.startdate" default="시작일"/>'		,type: 'uniDate'},
		    {name: 'PRODT_END_DATE'  	, text: '<t:message code="system.label.product.workenddate" default="작업완료일"/>'		,type: 'uniDate'},
		    {name: 'WKORD_Q'         	, text: '<t:message code="system.label.product.orderqty" default="오더량"/>'		,type: 'uniQty'},
		    {name: 'PRODT_Q'         	, text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'	,type: 'uniQty'},
		    {name: 'WK_RATE'         	, text: '<t:message code="system.label.product.progresspercent" default="진척율(%)"/>'	    ,type: 'string'},
		    {name: 'BAL_Q'           	, text: '<t:message code="system.label.product.estimatedbalanceqty" default="예산잔량"/>'		,type: 'uniQty'},
		    {name: 'RECEIPT_Q'       	, text: '<t:message code="system.label.product.receiptqty2" default="접수량"/>'		,type: 'uniQty'},
		    {name: 'INSPEC_Q'        	, text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'		,type: 'uniQty'},
		    {name: 'GOOD_INSPEC_Q'   	, text: '<t:message code="system.label.product.passqty" default="합격수량"/>'	,type: 'uniQty'},
		    {name: 'BAD_INSPEC_Q'    	, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'		,type: 'uniQty'},
		    {name: 'NOT_INSPEC_Q'    	, text: '<t:message code="system.label.product.inspectbalanceqty" default="검사잔량"/>'		,type: 'uniQty'},
		    {name: 'IN_STOCK_Q'      	, text: '<t:message code="system.label.product.receiptqty" default="입고량"/>'		,type: 'uniQty'},
		    {name: 'EXPIRATION_DATE'       	, text: '유통기한'		,type: 'uniDate'},
		    {name: 'INIT_DVRY_DATE'  	, text: '납품요청일'		,type: 'uniDate'},
		    {name: 'DVRY_DATE'  	, text: '납기변경일'		,type: 'uniDate'},
		    {name: 'HAZARD_DATE'  	, text: '유해물질의뢰일'		,type: 'uniDate'},
		    {name: 'MICROBE_DATE'  	, text: '미생물의뢰일'		,type: 'uniDate'},
		    {name: 'CUSTOM_CODE'       	, text: '거래처'		,type: 'string'},
		    {name: 'CUSTOM_NAME'       	, text: '거래처명'		,type: 'string'},
		    {name: 'BAD_WORK_Q'         	, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'		,type: 'uniQty'},
		    {name: 'SAVING_Q'           	, text: '<t:message code="system.label.product.manageqty" default="관리수량"/>'		,type: 'uniQty'},
		    {name: 'LOSS_Q'           		, text: 'LOSS_Q'		,type: 'uniQty'},
		    {name: 'ETC_Q'           			, text: '<t:message code="system.label.product.etcqty" default="기타수량"/>'		,type: 'uniQty'},
		    
		    {name: 'MAN_HOUR'           		, text: '투입공수'		,type: 'uniQty'},	//투입공수
		    {name: 'WORK_TIME_SUM'           		, text: '작업시간'		,type: 'string'},	//작업시간
		    {name: 'MAN_CNT'           		, text: '투입인원'		,type: 'int'}	//투입인원
		]
	});

	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('pmr320skrvMasterStore1',{
		model: 'pmr320skrvModel',
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
                read: 'pmr320skrvService.selectList'
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
 		groupField: 'ORDER_NUM',
		groupDir  : 'DESC'
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
	            topSearch.show();
	        },
	        expand: function() {
	        	topSearch.hide();
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
							topSearch.setValue('DIV_CODE', newValue);
							panelSearch.setValue('WORK_SHOP_CODE','');
						}
					}
			},{
	        	fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
	        	endFieldName:'PRODT_START_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false,
				width: 315,
				textFieldWidth:170,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(topSearch) {
							topSearch.setValue('PRODT_START_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();

	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(topSearch) {
				    		topSearch.setValue('PRODT_START_DATE_TO',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
				    	}
				    }
			},
				Unilite.popup('DIV_PUMOK',{
			    	fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
			    	textFieldWidth: 170,
			    	validateBlank: false,
			    	valueFieldName: 'ITEM_CODE_FR',
	        		textFieldName:'ITEM_NAME_FR',
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								topSearch.setValue('ITEM_CODE_FR', panelSearch.getValue('ITEM_CODE_FR'));
								topSearch.setValue('ITEM_NAME_FR', panelSearch.getValue('ITEM_NAME_FR'));
							},
							scope: this
						},
						onClear: function(type)	{
							topSearch.setValue('ITEM_CODE_FR', '');
							topSearch.setValue('ITEM_NAME_FR', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('DIV_PUMOK',{
			    	fieldLabel: '~',
			    	textFieldWidth: 170,
			    	validateBlank: false,
			    	valueFieldName: 'ITEM_CODE_TO',
	        		textFieldName:'ITEM_NAME_TO',
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								topSearch.setValue('ITEM_CODE_TO', panelSearch.getValue('ITEM_CODE_TO'));
								topSearch.setValue('ITEM_NAME_TO', panelSearch.getValue('ITEM_NAME_TO'));
							},
							scope: this
						},
						onClear: function(type)	{
							topSearch.setValue('ITEM_CODE_TO', '');
							topSearch.setValue('ITEM_NAME_TO', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
	            fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
	            name: 'WORK_SHOP_CODE',
	            xtype: 'uniCombobox',
	            comboType:'W',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						topSearch.setValue('WORK_SHOP_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = topSearch.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;
                            });
                            prStore.filterBy(function(record){
                                return false;
                            });
                        }
                    }
				}
	        },
	        	Unilite.popup('WKORD_NUM',{
			    	fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			   	 	textFieldName:'WKORD_NUM_FR',
			   	 	listeners: {
			   	 		onSelected: {
							fn: function(records, type) {
								topSearch.setValue('WKORD_NUM_FR', panelSearch.getValue('WKORD_NUM_FR'));
							},
							scope: this
						},
						onClear: function(type)	{
							topSearch.setValue('WKORD_NUM_FR', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': topSearch.getValue('DIV_CODE')});
							popup.setExtParam({'WORK_SHOP_CODE': topSearch.getValue('WORK_SHOP_CODE')});
						}
					}
			}),
				Unilite.popup('WKORD_NUM',{
				    	fieldLabel: '~',
				   	 	textFieldName:'WKORD_NUM_TO',
				   	 	listeners: {
				   	 		onSelected: {
								fn: function(records, type) {
									topSearch.setValue('WKORD_NUM_TO', panelSearch.getValue('WKORD_NUM_TO'));
								},
								scope: this
							},
							onClear: function(type)	{
								topSearch.setValue('WKORD_NUM_TO', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': topSearch.getValue('DIV_CODE')});
								popup.setExtParam({'WORK_SHOP_CODE': topSearch.getValue('WORK_SHOP_CODE')});
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

    var topSearch = Unilite.createSimpleForm('topSearchForm', {
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
					panelSearch.setValue('DIV_CODE', newValue);;
					topSearch.setValue('WORK_SHOP_CODE','');
					}
				}
			},{
	        	fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
	        	endFieldName:'PRODT_START_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false,
				width: 315,
				textFieldWidth:170,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('PRODT_START_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();

	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('PRODT_START_DATE_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
			    	}
			    }
			},
			Unilite.popup('DIV_PUMOK',{
		    	fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
		    	textFieldWidth: 170,
		    	validateBlank: false,
		    	valueFieldName: 'ITEM_CODE_FR',
        		textFieldName:'ITEM_NAME_FR',
        		listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ITEM_CODE_FR', topSearch.getValue('ITEM_CODE_FR'));
							panelSearch.setValue('ITEM_NAME_FR', topSearch.getValue('ITEM_NAME_FR'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ITEM_CODE_FR', '');
						panelSearch.setValue('ITEM_NAME_FR', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
				Unilite.popup('DIV_PUMOK',{
			    	fieldLabel: '~',
			    	textFieldWidth: 170,
			    	labelWidth: 15,
			    	validateBlank: false,
			    	valueFieldName: 'ITEM_CODE_TO',
	        		textFieldName:'ITEM_NAME_TO',
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ITEM_CODE_TO', topSearch.getValue('ITEM_CODE_TO'));
								panelSearch.setValue('ITEM_NAME_TO', topSearch.getValue('ITEM_NAME_TO'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE_TO', '');
							panelSearch.setValue('ITEM_NAME_TO', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
	            fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
	            name: 'WORK_SHOP_CODE',
	            xtype: 'uniCombobox',
	            comboType:'W',
	            listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(topSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == topSearch.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == topSearch.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;
                            });
                            prStore.filterBy(function(record){
                                return false;
                            });
                        }
                    }
				}
	        },
	        	Unilite.popup('WKORD_NUM',{
			    	fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			   	 	textFieldName:'WKORD_NUM_FR',
			   	 	listeners: {
			   	 		onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('WKORD_NUM_FR', topSearch.getValue('WKORD_NUM_FR'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('WKORD_NUM_FR', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': topSearch.getValue('DIV_CODE')});
							popup.setExtParam({'WORK_SHOP_CODE': panelSearch.getValue('WORK_SHOP_CODE')});
						}
					}
			}),
				Unilite.popup('WKORD_NUM',{
				    	fieldLabel: '~',
				   	 	textFieldName:'WKORD_NUM_TO',
				   	 	listeners: {
				   	 		onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('WKORD_NUM_TO', topSearch.getValue('WKORD_NUM_TO'));
								},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('WKORD_NUM_TO', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': topSearch.getValue('DIV_CODE')});
								popup.setExtParam({'WORK_SHOP_CODE': panelSearch.getValue('WORK_SHOP_CODE')});
							}
						}
				})]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid1 = Unilite.createGrid('pmr320skrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1,
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
/*        tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],*/
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false}
    	],
        columns: [
			{dataIndex: 'ORDER_NUM'       	, width: 80,  hidden:true},
			{dataIndex: 'WORK_SHOP_CODE'  	, width: 100, locked: true},
            {dataIndex: 'PROG_WORK_NAME'    , width: 100, locked: true},
			{dataIndex: 'ITEM_CODE'       	, width: 80,  locked: true},
			{dataIndex: 'ITEM_NAME'       	, width: 150, locked: true},
			{dataIndex: 'SPEC'            	, width: 50},
			{dataIndex: 'CUSTOM_NAME'  		, width: 150},
            {dataIndex: 'INIT_DVRY_DATE'    , width: 88},
            {dataIndex: 'DVRY_DATE'    		, width: 88},

			{dataIndex: 'WKORD_NUM'       	, width: 120},
			{dataIndex: 'LOT_NO'          	, width: 100},
			{dataIndex: 'EXPIRATION_DATE'   , width: 88},

			{dataIndex: 'WKORD_Q'         	, width: 80},
			{dataIndex: 'PRODT_Q'        	, width: 80},
			{dataIndex: 'WK_RATE'        	, width: 80 , align:"right"},
			{dataIndex: 'BAL_Q'          	, width: 80},
			{dataIndex: 'BAD_WORK_Q'   	, width: 80},
			{dataIndex: 'SAVING_Q'        	, width: 80},
			{dataIndex: 'LOSS_Q'          	, width: 80},
			{dataIndex: 'ETC_Q'          	, width: 80},
			{dataIndex: 'RECEIPT_Q'       	, width: 80},
			{dataIndex: 'INSPEC_Q'        	, width: 80},
			{dataIndex: 'GOOD_INSPEC_Q'   	, width: 80},
			{dataIndex: 'BAD_INSPEC_Q'    	, width: 80},
			{dataIndex: 'NOT_INSPEC_Q'    	, width: 80},
			{dataIndex: 'IN_STOCK_Q'      	, width: 80},

            {dataIndex: 'PRODT_WKORD_DATE'    , width: 88},
			{dataIndex: 'PRODT_START_DATE'	, width: 88},
			{dataIndex: 'PRODT_END_DATE'  	, width: 88},

			{dataIndex: 'HAZARD_DATE'    , width: 100},
            {dataIndex: 'MICROBE_DATE'    , width: 100},


			{dataIndex: 'OUT_METH'        	, width: 80},
			{dataIndex: 'RESULT_YN'       	, width: 80},

			{dataIndex: 'CUSTOM_CODE'	, width: 73},
			
            {dataIndex: 'MAN_HOUR'    , width: 88,  summaryType: 'sum'},
			{dataIndex: 'WORK_TIME_SUM'	, width: 88},
			{dataIndex: 'MAN_CNT'  	, width: 88}
  


		]
    });

    /**
     * Master Grid2 정의(Grid Panel)
     * @type
     */
	Unilite.Main( {
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            masterGrid1, topSearch
         ]
      },
         panelSearch
      ],
		id : 'pmr320skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{

			masterGrid1.getStore().loadStoreRecords();
			/*var viewNormal = masterGrid1.normalGrid.getView();
			var viewLocked = masterGrid1.lockedGrid.getView();

			console.log("viewNormal : ",viewNormal);
			console.log("viewLocked : ",viewLocked);

			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);*/
		    UniAppManager.setToolbarButtons('excel',true);
			}
		},

		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
};


</script>
