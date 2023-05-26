<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biz120ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

var outDivCode = UserInfo.divCode;

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'biz120ukrvService.selectMaster',
			update: 'biz120ukrvService.updateDetail',
			create: 'biz120ukrvService.insertDetail',
			destroy: 'biz120ukrvService.deleteDetail',
			syncAll: 'biz120ukrvService.saveAll'
		}
	});

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		items: [{
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('CUST',{
				fieldLabel: '<t:message code="system.label.inventory.subcontractor" default="외주처"/>',
				textFieldWidth: 170,
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				allowBlank:false,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelResult.setValue('CUSTOM_CODE'	, panelSearch.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME'	, panelSearch.getValue('CUSTOM_NAME'));

						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				}
			}),
			Unilite.popup('COUNT_DATE_OUT', {
				fieldLabel: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>',
				colspan: 2,
				//fieldStyle: 'text-align: center;',
				allowBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var countDATE = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
							countDATE = countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
							panelResult.setValue('COUNT_DATE', countDATE);
							panelSearch.setValue('COUNT_DATE', panelResult.getValue('COUNT_DATE'));
							panelResult.setValue('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
							panelResult.setValue('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
							panelSearch.setValue('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
							panelSearch.setValue('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
							panelResult.setValue('COUNT_DATE2', records[0]['COUNT_CONT_DATE']);
							panelSearch.setValue('COUNT_DATE2', panelResult.getValue('COUNT_DATE2'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('COUNT_DATE', '');
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('COUNT_DATE2', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')});
					}
				}
			}),{
    			fieldLabel: '<t:message code="system.label.inventory.stockcountingapplydate" default="실사반영일"/>',
    			name:'COUNT_DATE2',
    			xtype: 'uniDatefield',
    			readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('COUNT_DATE2', newValue);
					}
				}
    		},{
				fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
				name:'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1' ,
				xtype: 'uniCombobox' ,
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'ITEM_LEVEL2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'ITEM_LEVEL3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL3', newValue);
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
					this.mask();
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm',


	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{	fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				},
				Unilite.popup('CUST',{
					fieldLabel: '<t:message code="system.label.inventory.subcontractor" default="외주처"/>',
					textFieldWidth: 170,
					valueFieldName: 'CUSTOM_CODE',
					textFieldName: 'CUSTOM_NAME',
					allowBlank:false,
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelSearch.setValue('CUSTOM_CODE'	, panelResult.getValue('CUSTOM_CODE'));
								panelSearch.setValue('CUSTOM_NAME'	, panelResult.getValue('CUSTOM_NAME'));

							},
							scope: this
						},
						onClear: function(type) {
							panelSearch.setValue('CUSTOM_CODE', '');
							panelSearch.setValue('CUSTOM_NAME', '');
						}
					}
				}),
				Unilite.popup('COUNT_DATE_OUT', {
					fieldLabel: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>',
					colspan: 2,
					//fieldStyle: 'text-align: center;',
					allowBlank: false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var countDATE = UniDate.getDbDateStr(records[0]['COUNT_DATE']).substring(0, 8);
								countDATE = countDATE.substring(0,4) + '.' + countDATE.substring(4,6) + '.' + countDATE.substring(6,8);
								panelResult.setValue('COUNT_DATE', countDATE);
								panelSearch.setValue('COUNT_DATE', panelResult.getValue('COUNT_DATE'));
								panelResult.setValue('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
								panelResult.setValue('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
								panelSearch.setValue('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
								panelSearch.setValue('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
								panelResult.setValue('COUNT_DATE2', records[0]['COUNT_CONT_DATE']);
								panelSearch.setValue('COUNT_DATE2', panelResult.getValue('COUNT_DATE2'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('COUNT_DATE', '');
							panelSearch.setValue('CUSTOM_CODE', '');
							panelSearch.setValue('COUNT_DATE2', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
						}
					}
				}),{
					fieldLabel: '<t:message code="system.label.inventory.stockcountingapplydate" default="실사반영일"/>',
					name:'COUNT_DATE2',
					xtype: 'uniDatefield',
					readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('COUNT_DATE2', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
					name:'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
					name: 'ITEM_LEVEL1' ,
					xtype: 'uniCombobox' ,
					store: Ext.data.StoreManager.lookup('itemLeve1Store'),
					child: 'ITEM_LEVEL2',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('ITEM_LEVEL1', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
					name: 'ITEM_LEVEL2',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve2Store'),
					child: 'ITEM_LEVEL3',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('ITEM_LEVEL2', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
					name: 'ITEM_LEVEL3',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve3Store'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('ITEM_LEVEL3', newValue);
						}
					}
				}
		],
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
	});


	Unilite.defineModel('Biz120ukrvModel', {	// 메인
	    fields: [
	    	{name: 'DIV_CODE'			          		   ,text: '<t:message code="system.label.inventory.division" default="사업장"/>' 			,type: 'string'},
	    	{name: 'CUSTOM_CODE'		          		   ,text: '<t:message code="system.label.inventory.custom" default="거래처"/>' 			,type: 'string'},
	    	{name: 'COUNT_DATE'			          		   ,text: '<t:message code="system.label.inventory.stockcountingdate" default="실사일"/>' 			,type: 'uniDate'},
	    	{name: 'ITEM_ACCOUNT'		          		   ,text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>' 			,type: 'string', comboType:'AU', comboCode:'B020'},
	    	{name: 'ITEM_LEVEL1'		          		   ,text: '<t:message code="system.label.inventory.large" default="대"/>' 				,type: 'string'},
	    	{name: 'ITEM_LEVEL2'		          		   ,text: '<t:message code="system.label.inventory.middle" default="중"/>' 				,type: 'string'},
	    	{name: 'ITEM_LEVEL3'		          		   ,text: '<t:message code="system.label.inventory.small" default="소"/>' 				,type: 'string'},
	    	{name: 'ITEM_CODE'			          		   ,text: '<t:message code="system.label.inventory.item" default="품목"/>' 			,type: 'string'},
	    	{name: 'ITEM_NAME'			          		   ,text: '<t:message code="system.label.inventory.itemname" default="품목명"/>' 			,type: 'string'},
	    	{name: 'SPEC'				          		   ,text: '<t:message code="system.label.inventory.spec" default="규격"/>' 				,type: 'string'},
	    	{name: 'STOCK_UNIT'			          		   ,text: '<t:message code="system.label.inventory.unit" default="단위"/>' 				,type: 'string'},
	    	{name: 'GOOD_STOCK_BOOK_Q' 	          		   ,text: '<t:message code="system.label.inventory.good" default="양품"/>' 				,type: 'uniQty'},
	    	{name: 'BAD_STOCK_BOOK_Q' 	          		   ,text: '<t:message code="system.label.inventory.defect" default="불량"/>' 				,type: 'uniQty'},
	    	{name: 'GOOD_STOCK_Q' 		          		   ,text: '<t:message code="system.label.inventory.good" default="양품"/>' 				,type: 'uniQty'},
	    	{name: 'BAD_STOCK_Q' 		          		   ,text: '<t:message code="system.label.inventory.defect" default="불량"/>' 				,type: 'uniQty'},
	    	{name: 'COUNT_FLAG'			          		   ,text: 'COUNT_FLAG' 		,type: 'string'},
	    	{name: 'COUNT_CONT_DATE'	          		   ,text: '<t:message code="system.label.inventory.applyyearmonth" default="반영년월"/>' 			,type: 'string'},
	    	{name: 'REMARK'				          		   ,text: '<t:message code="system.label.inventory.remarks" default="비고"/>' 				,type: 'string'},
	    	{name: 'COMP_CODE'			          		   ,text: 'COMP_CODE' 		,type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('biz120ukrvMasterStore1',{
			model: 'Biz120ukrvModel',
			uniOpt: {
				isMaster: true,		// 상위 버튼 연결
            	editable: true,		// 수정 모드 사용
            	deletable: true,	// 삭제 가능 여부
	        	useNavi : false		// prev | newxt 버튼 사용
			},
            autoLoad: false,
            proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
       		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						/*var master = batch.operations[0].getResultSet();
						panelSearch.setValue("ORDER_NUM", master.ORDER_NUM);*/
						//3.기타 처리
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('biz120ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});	//End of var directMasterStore1 = Unilite.createStore('biz120ukrvMasterStore1',{

    var masterGrid = Unilite.createGrid('biz120ukrvGrid1', {
    	// for tab
        layout : 'fit',
        region:'center',
    	uniOpt: {
			expandLastColumn: false,
		 	useRowNumberer: false,
		 	useContextMenu: true
        },
        tbar: [/* {
        	text:'<t:message code="system.label.purchase.detailsview" default="상세보기"/>',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        } */],
    	store: directMasterStore1,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [
               		 { dataIndex: 'DIV_CODE'			  , 	width:80,hidden:true},
               		 { dataIndex: 'CUSTOM_CODE'		      , 	width:80,hidden:true},
               		 { dataIndex: 'COUNT_DATE'			  , 	width:80,hidden:true},
               		 { dataIndex: 'ITEM_ACCOUNT'		  , 	width:66},
               		 {text:'<t:message code="system.label.inventory.itemgroup" default="품목분류"/>',
               		 	columns:[
               		 		{ dataIndex: 'ITEM_LEVEL1'		      , 	width:80},
               		 		{ dataIndex: 'ITEM_LEVEL2'		      , 	width:80},
               		 		{ dataIndex: 'ITEM_LEVEL3'		      , 	width:80}
               		 	]
               		 },
               		 {dataIndex: 'ITEM_CODE'			        ,   width: 93,
						editor: Unilite.popup('DIV_PUMOK_G', {
					 		textFieldName: 'ITEM_CODE',
					 		DBtextFieldName: 'ITEM_CODE',
					 		//20200402 수정: applyextparam에서 적용
//					 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
							autoPopup: true,
							listeners: {'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										Ext.each(records, function(record,i) {
											console.log('record',record);
											if(i==0) {
												masterGrid.setItemData(record,false);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setItemData(record,false);
											}
										});
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid.setItemData(null,true);
								},
								//20200402 추가: 외주의 경우 OUT_CUSTOM_CODE 같이 넘기도록 수정
								applyextparam: function(popup){
									popup.setExtParam({SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE', OUT_CUSTOM_CODE: panelSearch.getValue('CUSTOM_CODE')});
								}
							}
						})
					},
					{dataIndex: 'ITEM_NAME'			        ,   width: 120,
						editor: Unilite.popup('DIV_PUMOK_G', {
					 		//20200402 수정: applyextparam에서 적용
//					 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
							autoPopup: true,
							listeners: {'onSelected': {
									fn: function(records, type) {
							    	    console.log('records : ', records);
									    Ext.each(records, function(record,i) {
											if(i==0) {
												masterGrid.setItemData(record,false);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setItemData(record,false);
											}
										});
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid.setItemData(null,true);
								},
								//20200402 추가: 외주의 경우 OUT_CUSTOM_CODE 같이 넘기도록 수정
								applyextparam: function(popup){
									popup.setExtParam({SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE', OUT_CUSTOM_CODE: panelSearch.getValue('CUSTOM_CODE')});
								}
							}
						})
					},
               		 { dataIndex: 'SPEC'				  , 	width:100},
               		 { dataIndex: 'STOCK_UNIT'			  , 	width:53},
               		 {text:'<t:message code="system.label.inventory.systemqty" default="전산수량"/>',
               		 	columns:[
               		 		{ dataIndex: 'GOOD_STOCK_BOOK_Q' 	  , 	width:80},
               				{ dataIndex: 'BAD_STOCK_BOOK_Q' 	  , 	width:80}
               		 	]
               		 },
               		 {text:'<t:message code="system.label.inventory.stockcountingqty" default="실사수량"/>',
               		 	columns:[
               		 		{ dataIndex: 'GOOD_STOCK_Q' 	, 	width:80},
               		 		{ dataIndex: 'BAD_STOCK_Q' 		, 	width:80}
               		 	]
               		 },
               		 { dataIndex: 'COUNT_FLAG'			  , 	width:0,hidden:true},
               		 { dataIndex: 'COUNT_CONT_DATE'	      , 	width:0,hidden:true},
               		 { dataIndex: 'REMARK'				  , 	width:100},
               		 { dataIndex: 'COMP_CODE'			  , 	width:66,hidden:true}
        ],

		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(e.record.phantom == false) {
	        		if(UniUtils.indexOf(e.field, ['GOOD_STOCK_Q', 'BAD_STOCK_Q', 'REMARK']))
					{
						return true;
      				} else {
      					return false;
      				}
	        	} else {
	        		if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'GOOD_STOCK_Q', 'BAD_STOCK_Q', 'REMARK']))
					{
						return true;
      				} else {
      					return false;
      				}
	        	}
	        }
		},

		////품목정보 팝업에서 선택된 데이타가 그리드에 추가되는 함수, 품목팝업의 onSelected/onClear 이벤트가 일어날때 호출됨
		setItemData: function(record, dataClear) {
       		var grdRecord = this.getSelectedRecord();
       		if(dataClear) {
       			grdRecord.set('ITEM_ACCOUNT'			, "ITEM_ACCOUNT");

       			//grdRecord.set('GOOD_STOCK_BOOK_Q'		, 0);


       		} else {
       			grdRecord.set('ITEM_ACCOUNT'			, record['ITEM_ACCOUNT']);
       			grdRecord.set('ITEM_CODE'				, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'				, record['ITEM_NAME']);
       			grdRecord.set('SPEC'					, record['SPEC']);
       			grdRecord.set('STOCK_UNIT'				, record['STOCK_UNIT']);
       			grdRecord.set('GOOD_STOCK_BOOK_Q'		, 0);
       			grdRecord.set('GOOD_STOCK_Q'			, 0);
       			grdRecord.set('BAD_STOCK_BOOK_Q'		, 0);
       			grdRecord.set('BAD_STOCK_Q'				, 0);
       			if(grdRecord > '0') {
       				if(record['ITEM_LEVEL1'] != null) {
       					grdRecord.set('ITEM_LEVEL1'			, record['ITEM_LEVEL1']);
       				}
       				if(record['ITEM_LEVEL2'] != null) {
       					grdRecord.set('ITEM_LEVEL2'			, record['ITEM_LEVEL2']);
       				}
       				if(record['ITEM_LEVEL3'] != null) {
       					grdRecord.set('ITEM_LEVEL3'			, record['ITEM_LEVEL3']);
       				}
       				if(record['STOCK_Q'] != null) {
       					grdRecord.set('GOOD_STOCK_BOOK_Q'	, record['STOCK_Q']);
       					grdRecord.set('GOOD_STOCK_Q'		, record['STOCK_Q']);
       				}
       				if(record['BAD_Q'] != null) {
       					grdRecord.set('BAD_STOCK_BOOK_Q'	, record['BAD_Q']);
       					grdRecord.set('BAD_STOCK_Q'			, record['BAD_Q']);
       				}
       			}
       			/*if(Unilite.nvl(record['ITEM_LEVEL1'],0) != 0) {
       				grdRecord.set('ITEM_LEVEL1'			, record['ITEM_LEVEL1']);
       			}
       			if(Unilite.nvl(record['ITEM_LEVEL2'],0) != 0) {
       				grdRecord.set('ITEM_LEVEL2'			, record['ITEM_LEVEL2']);
       			}
       			if(Unilite.nvl(record['ITEM_LEVEL3'],0) != 0) {
       				grdRecord.set('ITEM_LEVEL3'			, record['ITEM_LEVEL3']);
       			}
       			if(Unilite.nvl(record['STOCK_Q'],0) != 0) {
       				grdRecord.set('GOOD_STOCK_BOOK_Q'	, record['STOCK_Q']);
       				grdRecord.set('GOOD_STOCK_Q'		, record['STOCK_Q']);
       			}
       			if(Unilite.nvl(record['BAD_Q'],0) != 0) {
       				grdRecord.set('BAD_STOCK_BOOK_Q'	, record['BAD_Q']);
       				grdRecord.set('BAD_STOCK_Q'			, record['BAD_Q']);
       			}*/

				//UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('WH_CODE'));
       		}
		}
    });	//End of var masterGrid = Unilite.createGrid('biv120ukrvGrid1', {

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
		id: 'biz120ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			this.setDefault();
		},
		onQueryButtonDown: function() {    	// 조회버튼 눌렀을떄
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore1.loadStoreRecords();
			UniAppManager.setToolbarButtons('newData', true);
		},
		setDefault: function() {		// 기본값
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.getForm().wasDirty = false;
        	panelSearch.resetDirtyStatus();
         	UniAppManager.setToolbarButtons('save', false);
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterGrid.getStore().clearData();
			this.fnInitBinding();
			panelSearch.getField('CUSTOM_CODE').focus();
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore1.saveStore();
		},
		rejectSave: function() {	// 저장
			var rowIndex = masterGrid.getSelectedRowIndex();
			masterGrid.select(rowIndex);
			directMasterStore1.rejectChanges();

			if(rowIndex >= 0){
				masterGrid.getSelectionModel().select(rowIndex);
				var selected = masterGrid.getSelectedRecord();

				var selected_doc_no = selected.data['DOC_NO'];
  				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {
					}
				);
			}
			directMasterStore1.onStoreActionEnable();
		},
		confirmSaveData: function(config)	{	// 저장하기전 원복 시키는 작업
			var fp = Ext.getCmp('biv120ukrvFileUploadPanel');
        	if(masterStore.isDirty() || fp.isDirty()) {
				if(confirm('<t:message code="system.message.purchase.message025" default="변경된 내용을 저장하시겠습니까?"/>'))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			var selRow1 = masterGrid.getSelectedRecord();
			if(selRow1.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onNewDataButtonDown: function()	{		// 행추가
			//var compCode =
			var divCode 		= panelSearch.getValue('DIV_CODE');
			var customCode 		= panelSearch.getValue('CUSTOM_CODE');
			var countDate		= panelSearch.getValue('COUNT_DATE');
			var countConDate	= UniDate.getDbDateStr(panelSearch.getValue('COUNT_DATE2'));
			if(Ext.isEmpty(countConDate)){
				countConDate = '00000000'
			}

			var r = {
				//COMP_CODE: compCode,
				DIV_CODE: 		divCode,
				CUSTOM_CODE: 	customCode,
				COUNT_DATE:		countDate,
				COUNT_CONT_DATE: countConDate
			};
			masterGrid.createRow(r);
			panelSearch.setAllFieldsReadOnly(true);
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

	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "GOOD_STOCK_Q" :
					if(newValue < 0) {
						rv= '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
					}
					break;

				case "BAD_STOCK_Q" :
					if(newValue < 0) {
						rv= '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
					}
					break;

			}
			return rv;
		}
	});
};

</script>