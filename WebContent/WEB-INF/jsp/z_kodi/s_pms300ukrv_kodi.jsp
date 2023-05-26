<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pms300ukrv_kodi"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="Q023" /> <!-- 접수담당-->
	<t:ExtComboStore comboType="WU" />        <!-- 작업장-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var referProductionWindow;	//생산량참조

var BsaCodeInfo = {

};
//alert(output);

var outDivCode = UserInfo.divCode;
var checkDraftStatus = false;
var gsprodtNums = "";
var activeGridId = 's_pms300ukrv_kodiGrid';
var masterSelectIdx;

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pms300ukrv_kodiService.selectMaster',
			update: 's_pms300ukrv_kodiService.updateDetail',
			create: 's_pms300ukrv_kodiService.insertDetail',
			destroy: 's_pms300ukrv_kodiService.deleteDetail',
			syncAll: 's_pms300ukrv_kodiService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_pms300ukrv_kodiService.selectDetailList'
		}
	});

	var masterForm = Unilite.createSearchPanel('s_pms300ukrv_kodiMasterForm', {
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
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
		items: [{
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		        fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		        name:'DIV_CODE',
		        xtype: 'uniCombobox',
		        comboType:'BOR120' ,
		        allowBlank:false,
		        holdable: 'hold',
		        value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
		    },{
			 	fieldLabel: '접수기준일',
			 	xtype: 'uniDatefield',
			 	name: 'RECEIPT_DATE',
			 	allowBlank:false,
				value: UniDate.get('today'),
		        holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('RECEIPT_DATE', newValue);
					}
				}
			},{
		    	fieldLabel: '<t:message code="system.label.product.receiptdate" default="접수일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'RECEIPT_DATE_FR',
	        	endFieldName:'RECEIPT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('RECEIPT_DATE_FR',newValue);
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('RECEIPT_DATE_TO',newValue);
				    	}
				    }
			},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					textFieldWidth: 170,
					validateBlank: false,
					valueFieldName: 'ITEM_CODE',
	        		textFieldName:'ITEM_NAME',
					width: 380,
		        	holdable: 'hold',
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ITEM_CODE', masterForm.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', masterForm.getValue('ITEM_NAME'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						}
					}
			}),{
		        fieldLabel: '<t:message code="system.label.product.receiptcharger2" default="접수담당자"/>',
		        name:'RECEIPT_PRSN',
		        xtype: 'uniCombobox',
		        comboType:'AU' ,
		        comboCode:'Q023',
//		        allowBlank:false,
		        holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('RECEIPT_PRSN', newValue);
					}
				}
	    	},{
				fieldLabel: 'Lot No.',
				name: 'LOT_NO',
				xtype: 'uniTextfield',
		        holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('LOT_NO', newValue);
					}
				}
			},{
		    	fieldLabel: '<t:message code="system.label.product.productiondate" default="생산일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_DATE_FR',
	        	endFieldName:'PRODT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('PRODT_DATE_FR',newValue);
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('PRODT_DATE_TO',newValue);
				    	}
				    }
			},{
				name		: 'ITEM_ACCOUNT',
				fieldLabel	: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
				fieldLabel: '검사번호Grid용',
				name: 'RECEIPT_NUM_TEMP',
				xtype: 'uniTextfield',
				readOnly : true,
				hidden: true
			},{
				fieldLabel: '순번Grid용',
				name: 'RECEIPT_SEQ_TEMP',
				xtype: 'uniTextfield',
				readOnly : true,
				hidden: true
			},{
				fieldLabel: '아이템코드Grid용',
				name: 'ITEM_CODE_TEMP',
				xtype: 'uniTextfield',
				readOnly : true,
				hidden: true
			}
		]}],
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
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {
			hidden: !UserInfo.appOption.collapseLeftSearch,
			region: 'north',
			layout : {type : 'uniTable', columns : 4},
			padding:'1 1 1 1',
			border:true,
			items: [{
			        fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			        name:'DIV_CODE',
			        xtype: 'uniCombobox',
			        comboType:'BOR120' ,
			        allowBlank:false,
			        holdable: 'hold',
			        value: UserInfo.divCode,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							masterForm.setValue('DIV_CODE', newValue);
						}
					}
			    },{
				 	fieldLabel: '접수기준일',
				 	xtype: 'uniDatefield',
				 	name: 'RECEIPT_DATE',
				 	allowBlank:false,
					value: UniDate.get('today'),
			        holdable: 'hold',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							masterForm.setValue('RECEIPT_DATE', newValue);
						}
					}
				},{
		    	fieldLabel: '<t:message code="system.label.product.receiptdate" default="접수일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'RECEIPT_DATE_FR',
	        	endFieldName:'RECEIPT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							masterForm.setValue('RECEIPT_DATE_FR',newValue);
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		masterForm.setValue('RECEIPT_DATE_TO',newValue);
				    	}
				    }
			},
					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
						textFieldWidth: 170,
						validateBlank: false,
						valueFieldName: 'ITEM_CODE',
		        		textFieldName:'ITEM_NAME',
						width: 380,
			        	holdable: 'hold',
		        		listeners: {
							onSelected: {
								fn: function(records, type) {
									masterForm.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
									masterForm.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
								},
								scope: this
							},
							onClear: function(type)	{
								masterForm.setValue('ITEM_CODE', '');
								masterForm.setValue('ITEM_NAME', '');
							},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
						}
				}),{
			        fieldLabel: '<t:message code="system.label.product.receiptcharger2" default="접수담당자"/>',
			        name:'RECEIPT_PRSN',
			        xtype: 'uniCombobox',
			        comboType:'AU' ,
			        comboCode:'Q023',
//			        allowBlank:false,
			        holdable: 'hold',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							masterForm.setValue('RECEIPT_PRSN', newValue);
						}
					}
		    	},{
					fieldLabel: 'Lot No.',
					name: 'LOT_NO',
					xtype: 'uniTextfield',
			        holdable: 'hold',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							masterForm.setValue('LOT_NO', newValue);

						}
					}
				},{
		    	fieldLabel: '<t:message code="system.label.product.productiondate" default="생산일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_DATE_FR',
	        	endFieldName:'PRODT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							masterForm.setValue('PRODT_DATE_FR',newValue);
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		masterForm.setValue('PRODT_DATE_TO',newValue);
				    	}
				    }
			},{
				name		: 'ITEM_ACCOUNT',
				fieldLabel	: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('ITEM_ACCOUNT', newValue);
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
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('s_pms300ukrv_kodiDetailModel', {
	    fields: [
	    	{name:'COMP_CODE'           ,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'           ,type:'string' },
	    	{name:'DIV_CODE'       		,text: '<t:message code="system.label.product.division" default="사업장"/>'			    ,type:'string' ,comboType: 'BOR120', defaultValue: UserInfo.divCode ,editable:false},
			{name:'RECEIPT_DATE'   		,text: '<t:message code="system.label.product.receiptdate" default="접수일"/>'			    ,type:'uniDate', allowBlank: false},
			{name:'RECEIPT_NUM'  		,text: '<t:message code="system.label.product.receiptno" default="접수번호"/>'			,type:'string' },
			{name:'RECEIPT_SEQ'    		,text: '<t:message code="system.label.product.seq" default="순번"/>'				,type:'int'    },
			{name:'ITEM_CODE'      		,text: '<t:message code="system.label.product.item" default="품목"/>'			,type:'string' },
			{name:'ITEM_NAME'      		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			    ,type:'string' },
			{name:'SPEC'           		,text: '<t:message code="system.label.product.spec" default="규격"/>'				,type:'string' },
			{name:'STOCK_UNIT'     		,text: '<t:message code="system.label.product.unit" default="단위"/>'				,type:'string' },
			{name:'LOT_NO'         		,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			    ,type:'string' },
			{name:'PRODT_Q'  			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'			,type:'uniQty' },
			{name:'GOOD_PRODT_Q'  		,text: '<t:message code="system.label.product.goodoutputqty" default="양품생산량"/>'			,type:'uniQty' },
			{name:'NOT_RECEIPT_Q'  		,text: '<t:message code="system.label.product.notreceiveqty" default="미접수량"/>'			,type:'uniQty' },
			{name:'RECEIPT_Q'      		,text: '<t:message code="system.label.product.receiptqty2" default="접수량"/>'			    ,type:'uniQty', allowBlank: false },
			{name:'INSPEC_Q'       		,text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'			    ,type:'uniQty' },
			{name:'RECEIPT_PRSN'   		,text: '<t:message code="system.label.product.receiptcharger2" default="접수담당자"/>'			,type:'string' ,comboType: 'AU', comboCode: 'Q023'},
			{name:'PRODT_DATE'   		,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'			    ,type:'uniDate'},
			{name:'PRODT_NUM'      		,text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'			,type:'string' },
			{name:'WKORD_NUM'      		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string' },
			{name:'PROJECT_NO'     		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type:'string' },
			{name:'PJT_CODE'       		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type:'string' },
			{name:'REMARK'         		,text: '<t:message code="system.label.product.remarks" default="비고"/>'				,type:'string' }

		]
	});

	Unilite.defineModel('s_pms300ukrv_kodiDetailModel2', {
	    fields: [
	    	{name:'PRODT_DATE'   		,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'			    ,type:'uniDate'},
			{name:'PRODT_NUM'      		,text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'			,type:'string' },
			{name:'WKORD_NUM'      		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string' },
			{name:'ITEM_CODE'      		,text: '<t:message code="system.label.product.item" default="품목"/>'			,type:'string' },
			{name:'ITEM_NAME'      		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			    ,type:'string' },
			{name:'SPEC'           		,text: '<t:message code="system.label.product.spec" default="규격"/>'				,type:'string' },
			{name:'STOCK_UNIT'     		,text: '<t:message code="system.label.product.unit" default="단위"/>'				,type:'string' },
			{name:'LOT_NO'         		,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			    ,type:'string' },
			{name:'PRODT_Q'  			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'			,type:'uniQty' },
			{name:'GOOD_PRODT_Q'  		,text: '<t:message code="system.label.product.goodoutputqty" default="양품생산량"/>'			,type:'uniQty' },
			{name:'PROJECT_NO'     		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type:'string' },
			{name:'REMARK'         		,text: '<t:message code="system.label.product.remarks" default="비고"/>'				,type:'string' },
			{name:'RECEIPT_NUM'  		,text: '<t:message code="system.label.product.receiptno" default="접수번호"/>'			,type:'string' },
			{name:'RECEIPT_SEQ'    		,text: '<t:message code="system.label.product.seq" default="순번"/>'				,type:'int'    }

		]
	});


	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var detailStore = Unilite.createStore('s_pms300ukrv_kodiDetailStore', {
		model: 's_pms300ukrv_kodiDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			allDeletable:   true,    //전체삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= masterForm.getValues();
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
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			paramMaster.PRODT_NUMS = gsprodtNums;

			if(inValidRecs.length == 0) {
					config = {
							params: [paramMaster],
							success: function(batch, option) {
                                var master = batch.operations[0].getResultSet();
								masterForm.getForm().wasDirty = false;
								masterForm.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);

								detailStore.loadStoreRecords();
								if(detailStore.getCount() == 0){
									UniAppManager.app.onResetButtonDown();
								}
							 }
					};
				this.syncAllDirect(config);
			} else {
                detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var store = detailGrid.getStore();
				if(records != null && records.length > 0 ){
					UniAppManager.setToolbarButtons(['delete','deleteAll'], true);
				}
				//detailGrid에 포커스
				detailGrid.getNavigationModel().setPosition(0, 0);
				detailGrid.getSelectionModel().select(masterSelectIdx);
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function(store,  eOpts) {
				if( detailStore2.isDirty() || store.isDirty() ) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			},
			remove : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				if(store.getCount() == 0) {
					UniAppManager.setToolbarButtons(['delete','deleteAll'], false);
				}
			}
		}
	});

	var detailStore2 = Unilite.createStore('s_pms300ukrv_kodiDetailStore2', {
		model: 's_pms300ukrv_kodiDetailModel2',
		autoLoad: false,
		uniOpt: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: directProxy2,
		loadStoreRecords: function(record) {
			var param = record.data;

			param.PRODT_NUMS = gsprodtNums;

			console.log(param);

			this.load({
				params : param
			});
		}
	});

    var detailGrid = Unilite.createGrid('s_pms300ukrv_kodiGrid', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
			useContextMenu: true
        },
        tbar: [{
			itemId: 'requestBtn',
			text: '<div style="color: blue"><t:message code="system.label.product.productionqtyrefer" default="생산량참조"/></div>',
			handler: function() {
							if(UniAppManager.app._needSave()) {
								Unilite.messageBox('먼저 저장 후 다시 작업을 진행하십시오.');
								return false;
							}else{
									openProductionWindow();
							}


				}
		},'-'],
    	store: detailStore,
        columns: [
        	{dataIndex: 'COMP_CODE'         , width: 0 , hidden:true},
        	{dataIndex: 'DIV_CODE'     		, width: 100 , hidden: true},
        	{dataIndex: 'RECEIPT_DATE' 		, width: 100,align:'center'},
			{dataIndex: 'RECEIPT_NUM'   	, width: 120,align:'center'},
			{dataIndex: 'RECEIPT_SEQ'  		, width: 50,align:'center'},
			{dataIndex: 'ITEM_CODE'    		, width: 100} ,
			{dataIndex: 'ITEM_NAME'     	, width: 150},
			{dataIndex: 'SPEC'         		, width: 100 },
			{dataIndex: 'STOCK_UNIT'   		, width: 80 ,align:'center' },
			{dataIndex: 'LOT_NO'       		, width: 90},
			{dataIndex: 'PRODT_Q'    		, width: 100},
			{dataIndex: 'GOOD_PRODT_Q'    	, width: 100},
			{dataIndex: 'NOT_RECEIPT_Q'		, width: 100  , hidden: true},
			{dataIndex: 'RECEIPT_Q'    		, width: 100},
			{dataIndex: 'INSPEC_Q'      	, width: 100},
			{dataIndex: 'RECEIPT_PRSN' 		, width: 80},
			{dataIndex: 'PRODT_DATE' 		, width: 100},
			{dataIndex: 'PRODT_NUM'    		, width: 120},
			{dataIndex: 'WKORD_NUM'    		, width: 120},
			{dataIndex: 'PROJECT_NO'    	, width: 120},
			{dataIndex: 'REMARK'       		, width: 150}

		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
					UniAppManager.setToolbarButtons('newData', false);
				});
			},
			cellclick: function() {
				selectedGrid = 's_pms300ukrv_kodiGrid';
				selectedMasterGrid = 's_pms300ukrv_kodiGrid';

				if( detailStore.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
				if(detailStore.getCount() > 0)  {
					UniAppManager.setToolbarButtons(['delete','deleteAll'], true);
				}else {
					UniAppManager.setToolbarButtons(['delete','deleteAll'], false);
				}
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ){
				masterSelectIdx = index;
			},

			beforeedit  : function( editor, e, eOpts ) {
      			if(checkDraftStatus)	{
      				return false;
      			}else if(e.record.phantom )	{
					if (UniUtils.indexOf(e.field,
											['RECEIPT_NUM','RECEIPT_SEQ','ITEM_CODE','ITEM_NAME','SPEC','STOCK_UNIT','RECEIPT_Q','INSPEC_Q','PRODT_Q','GOOD_PRODT_Q',
											 'PRODT_DATE','PRODT_NUM','WKORD_NUM','PROJECT_NO','LOT_NO']) )
							return false;
				}else if(!e.record.phantom)
				{
					if(e.record.data.RECEIPT_Q == e.record.data.INSPEC_Q){  // 접수량과 검사량이 같을 때 행 전체 수정 불가
						return false;
					}
					else {
//						if (UniUtils.indexOf(e.field,
//											['RECEIPT_NUM','RECEIPT_SEQ','ITEM_CODE','ITEM_NAME','SPEC','STOCK_UNIT','RECEIPT_Q','INSPEC_Q','PRODT_Q','GOOD_PRODT_Q',
//											 'PRODT_DATE','PRODT_NUM','WKORD_NUM','PROJECT_NO','LOT_NO']) )
							return false;
					}
				}
			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0) {
					var record = selected[0];
					detailStore2.loadStoreRecords(record);
				}
			}
		},

		disabledLinkButtons: function(b) {
		},

		setEstiData:function(record) {
       		var grdRecord = this.getSelectedRecord();

       		grdRecord.set('COMP_CODE'			, masterForm.getValue('COMP_CODE'));
			grdRecord.set('RECEIPT_NUM'			, '');
			grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));
       		grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('PRODT_Q'				, record['PRODT_Q_TOT']);
			grdRecord.set('GOOD_PRODT_Q'		, record['GOOD_Q_TOT']);
			grdRecord.set('RECEIPT_Q'			, record['NOT_RECEIPT_Q_TOT']);
			grdRecord.set('NOT_RECEIPT_Q'		, record['NOT_RECEIPT_Q_TOT']);
			grdRecord.set('PRODT_DATE'			, record['PRODT_DATE_MIN']);
			grdRecord.set('PRODT_NUM'			, record['PRODT_NUM_MIN']);
			grdRecord.set('WKORD_NUM'			, record['WKORD_NUM']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO_MIN']);
			grdRecord.set('PJT_CODE'			, '');
			grdRecord.set('LOT_NO'				, record['WK_LOT_NO']);
			grdRecord.set('RECEIPT_PRSN'		, masterForm.getValue('RECEIPT_PRSN'));
			grdRecord.set('RECEIPT_DATE'        , masterForm.getValue('RECEIPT_DATE'));
			grdRecord.set('INSPEC_Q'            , 0 );
		}
	});


	var detailGrid2 = Unilite.createGrid('s_pms300ukrv_kodiGrid2', {
		layout: 'fit',
		region:'south',
		uniOpt: {
			expandLastColumn: false
		},
		store: detailStore2,
		columns: [
        	{dataIndex: 'PRODT_DATE' 		, width: 100},
			{dataIndex: 'PRODT_NUM'    		, width: 120},
			{dataIndex: 'WKORD_NUM'    		, width: 120},
			{dataIndex: 'ITEM_CODE'    		, width: 120} ,
			{dataIndex: 'ITEM_NAME'     	, width: 200},
			{dataIndex: 'SPEC'         		, width: 100 },
			{dataIndex: 'STOCK_UNIT'   		, width: 80 ,align:'center' },
			{dataIndex: 'LOT_NO'       		, width: 90},
			{dataIndex: 'PRODT_Q'    		, width: 100},
			{dataIndex: 'GOOD_PRODT_Q'    	, width: 100},
			{dataIndex: 'PROJECT_NO'    	, width: 120},
			{dataIndex: 'REMARK'       		, width: 200},
			{dataIndex: 'RECEIPT_NUM'   	, width: 120,align:'center'},
			{dataIndex: 'RECEIPT_SEQ'  		, width: 50,align:'center'}
		]
	});


    //생산량 참조 폼 정의
	 var productionSearch = Unilite.createSearchForm('productionForm', {
            layout :  {type : 'uniTable', columns : 3},
            items :[{
            	fieldLabel: '<t:message code="system.label.product.productiondate" default="생산일"/>',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'PRODT_DATE_FR',
			    endFieldName: 'PRODT_DATE_TO',
			    width: 350,
			    startDate: UniDate.get('startOfMonth'),
			    endDate: UniDate.get('today')
	       },
            	Unilite.popup('DIV_PUMOK',{
            	fieldLabel:'<t:message code="system.label.product.item" default="품목"/>' ,
            	valueFieldWidth:80,
            	textFieldWidth:140,
            	validateBlank: false,
            	valueFieldName:'ITEM_CODE',
			   		textFieldName:'ITEM_NAME'
            }),{
	       		fieldLabel: 'Lot No.',
	       		xtype: 'uniTextfield',
	       		name:'LOT_NO'
	       },{
	            fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
	            name: 'WORK_SHOP_CODE',
	            xtype: 'uniCombobox',
	            comboType: 'WU'
	        },{
	       		fieldLabel: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>',
	       		xtype: 'uniTextfield',
	       		name:'PROJECT_NO'
	       }]
    });

    //생산량 참조 모델 정의
	Unilite.defineModel('s_pms300ukrv_kodiProductionModel', {
	    fields: [{name: 'PRODT_DATE'     		,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'					, type: 'uniDate'},
				 {name: 'ITEM_CODE'      		,text: '<t:message code="system.label.product.item" default="품목"/>'					, type: 'string'},
				 {name: 'ITEM_NAME'      		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'						, type: 'string'},
				 {name: 'SPEC'           		,text: '<t:message code="system.label.product.spec" default="규격"/>'						, type: 'string'},
				 {name: 'STOCK_UNIT'     		,text: '<t:message code="system.label.product.unit" default="단위"/>'						, type: 'string'},
				 {name: 'PRODT_Q'        		,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'					, type: 'uniQty'},
				 {name: 'GOOD_PRODT_Q'        	,text: '<t:message code="system.label.product.goodoutputqty" default="양품생산량"/>'					, type: 'uniQty'},
				 {name: 'NOT_RECEIPT_Q'  		,text: '<t:message code="system.label.product.notreceiveqty" default="미접수량"/>'					, type: 'uniQty'},
				 {name: 'PRODT_NUM'      		,text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'					, type: 'string'},
				 {name: 'WKORD_NUM'     		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'				, type: 'string'},
				 {name: 'PROJECT_NO'     		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'					, type: 'string'},
				 {name: 'PJT_CODE'       		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				, type: 'string'},
				 {name: 'WK_LOT_NO'      		,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'					, type: 'string'},
				 {name: 'ITEM_LOT'      		,text: 'ITEM_LOT'					, type: 'string'},
				 {name: 'PRODT_Q_TOT'      		,text: 'PRODT_Q_TOT'					, type: 'uniQty'},
				 {name: 'GOOD_Q_TOT'      		,text: 'GOOD_Q_TOT'					, type: 'uniQty'},
				 {name: 'NOT_RECEIPT_Q_TOT'     ,text: 'NOT_RECEIPT_Q_TOT'					, type: 'uniQty'},
				 {name: 'PRODT_DATE_MIN'      		,text: 'PRODT_DATE_MIN'					, type: 'string'},
				 {name: 'PRODT_NUM_MIN'      		,text: 'PRODT_NUM_MIN'					, type: 'string'},
				 {name: 'WKORD_NUM_MIN'      		,text: 'WKORD_NUM_MIN'					, type: 'string'},
				 {name: 'PROJECT_NO_MIN'      		,text: 'PROJECT_NO_MIN'					, type: 'string'}
		]
	});

    var productionStore = Unilite.createStore('s_pms300ukrv_kodiProductionStore', {
			model: 's_pms300ukrv_kodiProductionModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read    : 's_pms300ukrv_kodiService.selectEstiList'
                }
            },
            loadStoreRecords : function()	{
				var param= productionSearch.getValues();
				param.DIV_CODE = masterForm.getValue('DIV_CODE');
				console.log( param );
				this.load({
					params : param
				});
			}
	});

	//생산량 참조 그리드 정의
    var productionGrid = Unilite.createGrid('s_pms300ukrv_kodiProductionGrid', {
        // title: '기본',
        layout : 'fit',
    	store: productionStore,
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { showHeaderCheckbox: false, checkOnly : true, toggleOnClick:false,
 			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
					var beforeSelectedRecord	= productionGrid.getSelectionModel().getSelection()[0]
					if(!Ext.isEmpty(beforeSelectedRecord)) {
						if (beforeSelectedRecord.get('ITEM_LOT') == record.get('ITEM_LOT')) {
							return true;
						} else {
							Unilite.messageBox('선택된 품목+Lot No.외에 다른 품목 또는 다른 작업지시의  Lot No.를 선택할 수 없습니다.');
							return false;
						}
					}
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){

					var records = productionStore.data.items;
					data = new Object();
					data.records = [];
					Ext.each(records, function(record, i){
						if(selectRecord.get('ITEM_LOT') == record.get('ITEM_LOT') || productionGrid.getSelectionModel().isSelected(record) == true) {
							data.records.push(record);
						}
					});
					productionGrid.getSelectionModel().select(data.records);
				},
				deselect:  function(grid, selectRecord, index, eOpts ){

					var records = productionStore.data.items;
					data = new Object();
					data.records = [];
					Ext.each(records, function(record, i){
						if(selectRecord.get('ITEM_LOT') == record.get('ITEM_LOT')) {
							data.records.push(record);
						}
					});
					productionGrid.getSelectionModel().deselect(data.records);
				}

			}
    	}),
			uniOpt:{
	        	onLoadSelectFirst : false
	        },
        columns:  [{ dataIndex: 'ITEM_LOT'      	,  width: 120,hidden: true},
        		   { dataIndex: 'ITEM_CODE'       	,  width: 100},
        		   { dataIndex: 'ITEM_NAME'       	,  width: 146 },
        		   { dataIndex: 'SPEC'            	,  width: 120 },
        		   { dataIndex: 'STOCK_UNIT'      	,  width: 53 ,align:'center' },
        		   { dataIndex: 'WK_LOT_NO'      	,  width: 80},
        		   { dataIndex: 'PRODT_DATE'      	,  width: 80},
        		   { dataIndex: 'PRODT_Q'         	,  width: 86},
        		   { dataIndex: 'GOOD_PRODT_Q'      ,  width: 86},
        		   { dataIndex: 'NOT_RECEIPT_Q'   	,  width: 86},
        		   { dataIndex: 'PRODT_NUM'       	,  width: 120},
        		   { dataIndex: 'WKORD_NUM'      	,  width: 120},
        		   { dataIndex: 'PROJECT_NO'      	,  width: 120}
          ]
       ,listeners: {

       		}
       	,returnData: function()	{

			var records = this.getSelectedRecords();
			var prodtNums = "";
			Ext.each(records, function(record,i){
				prodtNums = prodtNums + ',' + record.get("PRODT_NUM");
			});
			gsprodtNums = prodtNums;

			UniAppManager.app.onNewDataButtonDown();
			detailGrid.setEstiData(records[0].data);

			this.getStore().remove(records);
       	}
    });


        function openProductionWindow() {           // 참조
//        if(!UniAppManager.app.checkForNewDetail()) return false;

        if(!referProductionWindow) {
            referProductionWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.product.productionqtyrefer" default="생산량참조"/>',
                width: 1080,
                height: 580,
                layout:{type:'vbox', align:'stretch'},
                items: [productionSearch, productionGrid],

                tbar:  ['->',
                    {   itemId : 'saveBtn',
                        text: '<t:message code="system.label.product.inquiry" default="조회"/>',
                        handler: function() {
                            productionStore.loadStoreRecords();
                        },
                        disabled: false
                    },{ itemId : 'confirmBtn',
                        text: '<t:message code="system.label.product.apply" default="적용"/>',
                        handler: function() {
                            productionGrid.returnData();
                        },
                        disabled: false
                    },{ itemId : 'confirmCloseBtn',
                        text: '<t:message code="system.label.product.afterapplyclose" default="적용 후 닫기"/>',
                        handler: function() {
                            productionGrid.returnData();
                            referProductionWindow.hide();
                        },
                        disabled: false
                    },{
                        itemId : 'closeBtn',
                        text: '<t:message code="system.label.product.close" default="닫기"/>',
                        handler: function() {
                            referProductionWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                        productionSearch.clearForm();
                    },
                    beforeclose: function( panel, eOpts )   {
                        productionSearch.clearForm();
                    },
                    beforeshow: function( panel, eOpts )  {
                        productionSearch.setValue('PRODT_DATE_TO', UniDate.get('today'));
                        productionSearch.setValue('PRODT_DATE_FR', UniDate.get('startOfMonth'));
                    }
                }
            })
        }
        referProductionWindow.show();
        referProductionWindow.center();
    }



	Unilite.Main({
		id: 's_pms300ukrv_kodiApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				detailGrid, detailGrid2, panelResult
			]
		},
			masterForm
		],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			detailGrid.disabledLinkButtons(false);
			this.setDefault();
			gsprodtNums = "";

		},
		onQueryButtonDown: function() {
			masterForm.setAllFieldsReadOnly(false);

			var param= masterForm.getValues();

			detailGrid2.getStore().loadData({});

			detailStore.loadStoreRecords();

			var rowIndex = detailStore.getCount();

            if (rowIndex == 0 ){
                 UniAppManager.setToolbarButtons('save', false);
            }

		},

		onNewDataButtonDown: function() {
			 var receipt_num = '';
			 var seq = 1;

			 var r = {
			 	 		RECEIPT_NUM : receipt_num,
			 	 		RECEIPT_SEQ : seq
					 };
			detailGrid.createRow(r);
			masterForm.setAllFieldsReadOnly(false);
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			masterForm.clearForm();
			panelResult.clearForm();
//			detailGrid.reset();
//			detailStore.clearData();
//			detailGrid2.reset();
//			detailStore2.clearData();
			detailGrid.getStore().loadData({});
			detailGrid2.getStore().loadData({});
            masterForm.setAllFieldsReadOnly(false);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();

			var rowIndex = detailStore.getCount();

             productionStore.clearData(); //
             productionGrid.reset();

		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('INSPEC_Q') > 1)
				{
					alert('<t:message code="system.message.product.message038" default="검사진행된 품목입니다. 삭제 할 수 없습니다."/>');

				}else{
					detailGrid.deleteSelectedRow();
				}
			}
		},

		//전체삭제
         onDeleteAllButtonDown: function() {
            var records = detailStore.data.items;
            var isNewData = false;
            Ext.each(records, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    isNewData = false;
                    if(confirm('<t:message code="system.message.product.confirm002" default="전체삭제 하시겠습니까?"/>')) {
                        var deletable = true;
                        /*---------삭제전 로직 구현 시작----------*/


                        /*---------삭제전 로직 구현 끝-----------*/

                        if(deletable){
                            detailGrid.reset();
                            UniAppManager.app.onSaveDataButtonDown();
                        }
                    }
                    return false;
                }
            });
            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋
                detailGrid.reset();
                detailGrid2.reset();
                UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
            }

        },

		fnInspecQtyCheck: function(rtnRecord, fieldName, oldValue, divCode, receiptNum, receiptSeq)	{
			var param = {
				'DIV_CODE':divCode,
				'RECEIPT_NUM':receiptNum,
				'RECEIPT_SEQ':receiptSeq
			}
			s_pms300ukrv_kodiService.inspecQtyCheck(param, function(provider, response)	{
				if(!Ext.isEmpty(provider) && provider.length > 0 )	{
					alert('<t:message code="system.message.product.message058" default="검사된 수량이 존재합니다. 데이터를 수정할 수 없습니다."/>');
					rtnRecord.set(fieldName, oldValue);
					UniAppManager.app.onQueryButtonDown();
				}
			})
		},
		setDefault: function() {
        	masterForm.setValue('DIV_CODE', UserInfo.divCode);
        	masterForm.setValue('RECEIPT_DATE', UniDate.get('today'));
        	masterForm.setValue('RECEIPT_DATE_FR', UniDate.get('startOfMonth'));
        	masterForm.setValue('RECEIPT_DATE_TO', UniDate.get('today'));
        	masterForm.setValue('PRODT_DATE_FR', UniDate.get('startOfMonth'));
        	masterForm.setValue('PRODT_DATE_TO', UniDate.get('today'));
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('RECEIPT_DATE', UniDate.get('today'));
        	panelResult.setValue('RECEIPT_DATE_FR', UniDate.get('startOfMonth'));
        	panelResult.setValue('RECEIPT_DATE_TO', UniDate.get('today'));
        	panelResult.setValue('PRODT_DATE_FR', UniDate.get('startOfMonth'));
        	panelResult.setValue('PRODT_DATE_TO', UniDate.get('today'));
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		}
	});


}
</script>