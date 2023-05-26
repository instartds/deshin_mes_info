<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ppl111ukrv_kd"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_ppl111ukrv_kd"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="WU" />					<!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="P402" /> <!-- 참조유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!-- 매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /> <!-- 대분류 -->
   	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /> <!-- 중분류 -->
   	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /> <!-- 소분류 -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-change-cell3 {
background-color: #fcfac5;
}
</style>
<script type="text/javascript" >

var referOrderInformationWindow;		//수주정보참조
var referSalesPlanWindow;				//판매계획참조

var BsaCodeInfo = {
	gsManageTimeYN:'${gsManageTimeYN}'
};

var ManageTimeYN = true; //재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
if(BsaCodeInfo.gsManageTimeYN =='Y') {
    ManageTimeYN = false;
}
//var output ='';
//for(var key in BsaCodeInfo){
//	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

var outDivCode  = UserInfo.divCode;
var gsFrWeekList = ${frWeekList};
var gsToWeekList = ${toWeekList};

function appMain() {

	var mrpYnStore = Unilite.createStore('s_ppl111ukrv_kdMRPYnStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'예'		, 'value':'Y'},
			        {'text':'아니오'	, 'value':'N'}
			        //ColIndex("MRP_YN"))  = sMBC02  |#Y;예|#N;아니오
			        //공통코드 처리필요 MRP연계
	    		]
	});


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_ppl111ukrv_kdService.selectDetailList',
			update: 's_ppl111ukrv_kdService.updateDetail',
			create: 's_ppl111ukrv_kdService.insertDetail',
			destroy: 's_ppl111ukrv_kdService.deleteDetail',
			syncAll: 's_ppl111ukrv_kdService.saveAll'
		}
	});

	/* 수주정보 참조 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_ppl111ukrv_kdService.selectEstiList',
			update: 's_ppl111ukrv_kdService.updateEstiDetail',
			create: 's_ppl111ukrv_kdService.insertEstiDetail',
			destroy: 's_ppl111ukrv_kdService.deleteEstiDetail',
			syncAll: 's_ppl111ukrv_kdService.saveRefAll'
		}
	});

	/* 생산계획 참조*/
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_ppl111ukrv_kdService.selectRefList',
			update: 's_ppl111ukrv_kdService.updateRefDetail',
			create: 's_ppl111ukrv_kdService.insertRefDetail',
			destroy: 's_ppl111ukrv_kdService.deleteRefDetail',
			syncAll: 's_ppl111ukrv_kdService.saveRefAll'
		}
	});


	Unilite.defineModel('s_ppl111ukrv_kdMasterModel', {
	    fields: [
	    	{name: 'COMP_CODE'      	, text: 'COMP_CODE'			, type: 'string'},
	    	{name: 'DIV_CODE'       	, text: '사업장' 			, type: 'string'},
		    {name: 'ORDER_TYPE'     	, text: '구분'				, type: 'string'},
		    {name: 'PLAN_TYPE'      	, text: '구분코드' 			, type: 'string'},
		    {name: 'ORDER_NUM'      	, text: '수주번호' 			, type: 'string'},
		    {name: 'SEQ'            	, text: '순번'				, type: 'int'},
		    {name: 'ITEM_CODE'      	, text: '품목코드' 			, type: 'string'},
		    {name: 'ITEM_NAME'      	, text: '품명' 				, type: 'string'},
		    {name: 'SPEC'           	, text: '규격'				, type: 'string'},
	    	{name: 'STOCK_UNIT'     	, text: '단위' 				, type: 'string'},
		    {name: 'STOCK_Q'        	, text: '현재고'			, type: 'uniQty'},
		    {name: 'ORDER_DATE'     	, text: '수주일' 			, type: 'uniDate'},
		    {name: 'DVRY_DATE'      	, text: '납기일' 			, type: 'uniDate'},
		    {name: 'PROD_END_DATE'  	, text: '생산요청일'		, type: 'uniDate'},
		    {name: 'ORDER_UNIT_Q'   	, text: '수주량' 			, type: 'uniQty'},
		    {name: 'PROD_Q'         	, text: '생산요청량' 		, type: 'uniQty'},
		    {name: 'SUM_WK_PLAN_Q'  	, text: '계획량'			, type: 'uniQty'},
	    	{name: 'PROJECT_NO'     	, text: '프로젝트번호' 		, type: 'string'},
		    {name: 'PJT_CODE'       	, text: '프로젝트번호'		, type: 'string'},
		    {name: 'WK_PLAN_NUM'    	, text: '생산계획번호' 		, type: 'string'},
		    {name: 'WORK_SHOP_CODE' 	, text: '작업장' 			, type: 'string' , comboType: 'WU'},
		    {name: 'PRODT_PLAN_DATE'	, text: '계획일'			, type: 'uniDate'},
		    {name: 'PRODT_PLAN_TIME'	, text: '계획시간' 		, type: 'string'},
		    {name: 'WK_PLAN_Q'      	, text: '계획량' 			, type: 'uniQty'},
		    {name: 'REMARK'         	, text: '비고'				, type: 'string'},
	    	{name: 'MRP_YN'         	, text: 'MRP연계' 			, type: 'string' ,store: Ext.data.StoreManager.lookup('s_ppl111ukrv_kdMRPYnStore')},
		    {name: 'WKORD_NUM'      	, text: '작업지시번호'		, type: 'string'},
		    {name: 'WKORD_Q'        	, text: '작업지시량' 		, type: 'uniQty'},
		    {name: 'PRODT_Q'        	, text: '생산량' 			, type: 'uniQty'},
		    {name: 'UPDATE_DB_USER' 	, text: 'UPDATE_DB_USER'	, type: 'string'},
		    {name: 'UPDATE_DB_TIME' 	, text: 'UPDATE_DB_TIME' 	, type: 'string'},
		    {name: 'CAPA_OVER_FLAG' 	, text: 'CAPA_OVER_FLAG' 	, type: 'string'}
		]
	});

	//마스터 스토어 정의
	var masterStore = Unilite.createStore('s_ppl111ukrv_kdmasterStore', {
		model: 's_ppl111ukrv_kdMasterModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
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

/*			var orderNum = masterForm.getValue('ORDER_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['ORDER_NUM'] != orderNum) {
					record.set('ORDER_NUM', orderNum);
				}
			})*/
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
					config = {
							params: [paramMaster],
							success: function(batch, option) {
								masterForm.getForm().wasDirty = false;
								masterForm.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);
								if (masterStore.count() == 0) {
									UniAppManager.app.onResetButtonDown();
								}else{
									masterStore.loadStoreRecords();
								}
							 }
					};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('s_ppl111ukrv_kdGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});


	var masterForm = Unilite.createSearchPanel('s_ppl111ukrv_kdMasterForm', {
		title: '검색조건',
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
			title: '기본정보',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	        	fieldLabel: '사업장',
	        	name:'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType:'BOR120',
	        	allowBlank:false,
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
	        },{
	        	fieldLabel: '계획기간',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_PLAN_DATE_FR',
	        	endFieldName:'PRODT_PLAN_DATE_TO',
				startDate: UniDate.get('mondayOfWeek'),
				endDate: UniDate.get('endOfWeek'),
				allowBlank:false,
				width: 315,
				textFieldWidth:170,
				 onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('PRODT_PLAN_DATE_FR',newValue);

	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('PRODT_PLAN_DATE_TO',newValue);
				    	}
				    }
			},{
				fieldLabel: '작업장',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
				store: Ext.data.StoreManager.lookup('wsList'),
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '품목코드',
					validateBlank:false,
					valueFieldName:'ITEM_CODE',
	        		textFieldName:'ITEM_NAME',
		        	listeners: {
						onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
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
				fieldLabel: '생산계획번호',
				name: 'WK_PLAN_NUM',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('WK_PLAN_NUM', newValue);
					}
				}
			},{
		    	xtype:'container',
		    	defaultType:'uniTextfield',
		    	layout:{type:'hbox', align:'stretch'},
		    	items:[{
	    	  	 	fieldLabel:'수주번호',
				 	name : 'ORDER_NUM',
					width:245,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_NUM', newValue);
						}
					}
			    },{
					fieldLabel: '',
					xtype:'uniNumberfield',
				    name:'ORDER_SEQ',
				 	hideLabel:true,
				 	width:50,
				 	listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_SEQ', newValue);
						}
					}
				}]
			 },{
	        	fieldLabel: '참조유형',
	        	name:'PLAN_TYPE',
	        	xtype: 'uniCombobox',
	        	comboType:'AU',
	        	comboCode:'P402',
		    	listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
					panelResult.setValue('PLAN_TYPE', newValue);
					}
				}
   			},{
   			    fieldLabel: '자동조회여부',
   			    id: 'TXT_SEARCH',
   			    xtype: 'uniTextfield',
   			    hidden:true
   		    }]
		},{
			title: '품목정보',
   			itemId: 'search_panel2',
   			collapsed: false,
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		    	fieldLabel: '대분류',
		    	name: 'ITEM_LEVEL1',
		    	xtype: 'uniCombobox',
		    	store: Ext.data.StoreManager.lookup('itemLeve1Store'),
		    	child: 'ITEM_LEVEL2'
			},{
			    fieldLabel: '중분류',
			    name: 'ITEM_LEVEL2',
			    xtype: 'uniCombobox',
			    store: Ext.data.StoreManager.lookup('itemLeve2Store'),
			    child: 'ITEM_LEVEL3'
			},{
			    fieldLabel: '소분류',
			    name: 'ITEM_LEVEL3',
			    xtype: 'uniCombobox',
			    store: Ext.data.StoreManager.lookup('itemLeve3Store')
	    },{
		    fieldLabel: '임시파일',
		    name: 'COM',
		    xtype: 'uniTextfield',
		    hidden:true
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
	   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
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
	});	//end panelSearch

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
	        	fieldLabel: '사업장',
	        	name:'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType:'BOR120',
	        	allowBlank:false,
	        	listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
//						combo.changeDivCode(combo, newValue, oldValue, eOpts);
//						var field = panelResult.getField('INOUT_PRSN');
//						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
	        },{
	        	fieldLabel: '계획기간',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_PLAN_DATE_FR',
	        	endFieldName:'PRODT_PLAN_DATE_TO',
				startDate: UniDate.get('mondayOfWeek'),
				endDate: UniDate.get('endOfWeek'),
				allowBlank:false,
				width: 315,
				textFieldWidth:170,
				 onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(masterForm) {
							masterForm.setValue('PRODT_PLAN_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();

	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(masterForm) {
				    		masterForm.setValue('PRODT_PLAN_DATE_TO',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
				    	}
				    }
			},{
				fieldLabel: '작업장',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('wsList'),
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '품목코드',
					validateBlank:false,
					valueFieldName:'ITEM_CODE',
	        		textFieldName:'ITEM_NAME',
		        	listeners: {
						onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
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
				fieldLabel: '생산계획번호',
				name: 'WK_PLAN_NUM',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('WK_PLAN_NUM', newValue);
					}
				}
			},{
		    	xtype:'container',
		    	defaultType:'uniTextfield',
		    	layout:{type:'hbox', align:'stretch'},
		    	items:[{
	    	  	 	fieldLabel:'수주번호',
				 	name : 'ORDER_NUM',
					width:200,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('ORDER_NUM', newValue);
						}
					}
			    },{
					fieldLabel: '',
					xtype:'uniNumberfield',
				    name:'ORDER_SEQ',
				 	hideLabel:true,
				 	width:45,
				 	listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('ORDER_SEQ', newValue);
						}
					}
				}]
			 },{
	        	fieldLabel: '참조유형',
	        	name:'PLAN_TYPE',
	        	xtype: 'uniCombobox',
	        	comboType:'AU',
	        	comboCode:'P402',
	        	listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						masterForm.setValue('PLAN_TYPE', newValue);
					}
				}
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
	   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
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
	});	//end panelSearch

	/**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('s_ppl111ukrv_kdGrid', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'refTool',
			text: '참조...',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'requestBtn',
					text: '수주정보참조',
					handler: function() {
						openOrderInformationWindow();
						}
				}, {
					itemId: 'refBtn',
					text: '판매계획참조',
		        	handler: function() {
			        	openSalesPlanWindow();
		        		}
				}]
			})
		}/*, {  프로세스 임시 제거
			xtype: 'splitbutton',
           	itemId:'procTool',
			text: '프로세스...',  iconCls: 'icon-link',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'reqIssueLinkBtn',
					text: '월생산계획',
					handler: function() {
						}
				}]
			})
        }*/],
    	store: masterStore,
        columns: [
        	{ dataIndex: 'COMP_CODE'         		, width: 20 , hidden: true},
        	{ dataIndex: 'DIV_CODE'          		, width: 20 , hidden: true},
        	{ dataIndex: 'ORDER_TYPE'        		, width: 120 },
                { text : '계획정보' ,
                    columns: [
                        { dataIndex: 'WK_PLAN_NUM'              , width: 110},
                        { dataIndex: 'WORK_SHOP_CODE'           , width: 95 ,tdCls:'x-change-cell3'},
                        { dataIndex: 'PRODT_PLAN_DATE'          , width: 80 ,tdCls:'x-change-cell3'},
                        { dataIndex: 'PRODT_PLAN_TIME'          , width: 85, hidden: ManageTimeYN, align: 'center'/*,
                            renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                                if(!Ext.isEmpty(val)){
                                    return  val.substring(0,2) + ':' + val.substring(2,4) + ':' + val.substring(4,6);
                                }
                            }*/
                        },
                        { dataIndex: 'WK_PLAN_Q'                , width: 90 ,tdCls:'x-change-cell3'},
                        { dataIndex: 'REMARK'                   , width: 100}
                ]
            },
	        	{ text : '수주정보' ,
	        		columns: [
			        	{ dataIndex: 'PLAN_TYPE'         		, width: 20 , hidden: true},
			        	{ dataIndex: 'ORDER_NUM'         		, width: 120},
			        	{ dataIndex: 'SEQ'               		, width: 60},
			        	{ dataIndex: 'ITEM_CODE'         		, width: 100,
		        	            editor: Unilite.popup('DIV_PUMOK_G', {
			 							textFieldName: 'ITEM_CODE',
			 							DBtextFieldName: 'ITEM_CODE',
			 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
			    						autoPopup: true,
										listeners: {'onSelected': {
														fn: function(records, type) {
																console.log('records : ', records);
																Ext.each(records, function(record,i) {
																	if(i==0) {
																		masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
																	} else {
																		UniAppManager.app.onNewDataButtonDown();
																		masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
																	}
																});
															},
														scope: this
														},
													'onClear': function(type) {
														masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
													},
                                                    applyextparam: function(popup){
                                                        var divCode = masterForm.getValue('DIV_CODE');
                                                        popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode});
                                                    }
										}
								})
					},
			        	{ dataIndex: 'ITEM_NAME'         		, width: 130,
			        	        editor: Unilite.popup('DIV_PUMOK_G', {
			    						autoPopup: true,
										listeners: {'onSelected': {
                                                    fn: function(records, type) {
                                                            console.log('records : ', records);
                                                            Ext.each(records, function(record,i) {
                                                                if(i==0) {
                                                                    masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
                                                                } else {
                                                                    UniAppManager.app.onNewDataButtonDown();
                                                                    masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
                                                                }
                                                            });
                                                        },
                                                    scope: this
                                                    },
												'onClear': function(type) {
													masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
												},
                                                applyextparam: function(popup){
                                                    var divCode = masterForm.getValue('DIV_CODE');
                                                    popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode});
                                                }
										}
								})
					},
			        	{ dataIndex: 'SPEC'              		, width: 120},
			        	{ dataIndex: 'STOCK_UNIT'        		, width: 45},
			        	{ dataIndex: 'STOCK_Q'           		, width: 80},
			        	{ dataIndex: 'ORDER_DATE'        		, width: 75},
			        	{ dataIndex: 'DVRY_DATE'         		, width: 75},
			        	{ dataIndex: 'PROD_END_DATE'     		, width: 75},
			        	{ dataIndex: 'ORDER_UNIT_Q'      		, width: 90},
			        	{ dataIndex: 'PROD_Q'            		, width: 90},
			        	{ dataIndex: 'SUM_WK_PLAN_Q'     		, width: 90},
			        	{ dataIndex: 'PROJECT_NO'        		, width: 100,
			        	editor: Unilite.popup('PROJECT_G', {
			 							textFieldName: 'PJT_CODE',
			 							DBtextFieldName: 'PJT_NAME',
			 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
			    						autoPopup: true,
										listeners: {'onSelected': {
														fn: function(records, type) {
																console.log('records : ', records);
																Ext.each(records, function(record,i) {
																					console.log('record',record);
																					if(i==0) {
																						masterGrid.setProjectData(record,false);
																					} else {
																						UniAppManager.app.onNewDataButtonDown();
																						masterGrid.setProjectData(record,false);
																					}
																});
															},
														scope: this
														},
													'onClear': function(type) {
																	masterGrid.setProjectData(null,true);
																}
										}
								})
					},
			        	{ dataIndex: 'PJT_CODE'          		, width: 93,
			        	editor: Unilite.popup('PJT_G', {
			 							textFieldName: 'PJT_CODE',
			 							DBtextFieldName: 'PJT_NAME',
			 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
			    						autoPopup: true,
										listeners: {'onSelected': {
														fn: function(records, type) {
																console.log('records : ', records);
																Ext.each(records, function(record,i) {
																					console.log('record',record);
																					if(i==0) {
																						masterGrid.setPjtData(record,false);
																					} else {
																						UniAppManager.app.onNewDataButtonDown();
																						masterGrid.setPjtData(record,false);
																					}
																});
															},
														scope: this
														},
													'onClear': function(type) {
																	masterGrid.setPjtData(null,true);
																}
										}
								})
					}
	        	]
	        },
	        	{ text : '연계정보' ,
	        		columns: [
	        			{ dataIndex: 'MRP_YN'            		, width: 66},
			        	{ dataIndex: 'WKORD_NUM'         		, width: 100},
			        	{ dataIndex: 'WKORD_Q'           		, width: 90},
			        	{ dataIndex: 'PRODT_Q'           		, width: 66}
	        	]
	        },
        	{ dataIndex: 'UPDATE_DB_USER'    		, width: 100 , hidden: true},
        	{ dataIndex: 'UPDATE_DB_TIME'    		, width: 100 , hidden: true},
        	{ dataIndex: 'CAPA_OVER_FLAG'    		, width: 100 , hidden: true}
		],
		listeners: {
			 edit: function(editor, e) { console.log(e);
			 var newValue = e.value;
			 if (e.originalValue != newValue && !Ext.isEmpty(newValue)) {
                var fieldName = e.field;
                var num_check = /[0-9]/;
                if (fieldName == 'PRODT_PLAN_TIME') {
                    if (!num_check.test(newValue)) {
                        Ext.Msg.alert('확인', '숫자형식이 잘못되었습니다.');
                        e.record.set(fieldName, e.originalValue);
                        return false;
                    }
                    if(newValue.length != 6 || newValue.substring(0,2) > 24 || newValue.substring(2,4) >= 60 || newValue.substring(4,6) >= 60 ){
                        Ext.Msg.alert('확인', '정확한 시간를 입력하십시오.');
                        e.record.set(fieldName, e.originalValue);
                        return false;
                    }
                    e.record.set(fieldName, newValue.substring(0,2) + ':' + newValue.substring(2,4) + ':' + newValue.substring(4,6));
                }
			 }else{
			     return false;
			 }

//                    if (e.originalValue != newValue && !Ext.isEmpty(newValue)) {
//                        UniAppManager.setToolbarButtons('save', true);
//                    } else {
//    //                          UniAppManager.setToolbarButtons('save', false);
//                    }
                },
			/*afterrender: function(grid) {
					//useContextMenu:true 설정으로 툴바 우측 버튼은 자동 생성되며 그 외 추가할 메뉴  작성
					this.contextMenu.add(
						{
					        xtype: 'menuseparator'
					    },{
					    	text: '품목정보',   iconCls : '',
		                	handler: function(menuItem, event) {
		                		var record = grid.getSelectedRecord();
								var params = {
									ITEM_CODE : record.get('ITEM_CODE')
								}
								var rec = {data : {prgID : 'bpr100ukrv', 'text':''}};
								parent.openTab(rec, '/base/bpr100ukrv.do', params);
		                	}
		            	},{
		            		text: '거래처정보',   iconCls : '',
		                	handler: function(menuItem, event) {
								var params = {
									CUSTOM_CODE : masterForm.getValue('CUSTOM_CODE'),
									COMP_CODE : UserInfo.compCode
								}
								var rec = {data : {prgID : 'bcm100ukrv', 'text':''}};
								parent.openTab(rec, '/base/bcm100ukrv.do', params);
		                	}
		            	}
	       			)
				},*/
			beforePasteRecord: function(rowIndex, record) {
					if(!UniAppManager.app.checkForNewDetail()) return false;

					var seq = masterStore.max('SER_NO');
	            	if(!seq) seq = 1;
	            	else  seq += 1;
	          		record.SER_NO = seq;

	          		return true;
	          	},
	          	//contextMenu의 복사한 행 삽입 실행 후
	          	afterPasteRecord: function(rowIndex, record) {
	          		masterForm.setAllFieldsReadOnly(true);
	          	},
			beforeedit : function( editor, e, eOpts ) {
				/*if(!e.record.phantom || e.record.phantom){
					if(e.record.data.PLAN_TYPE != 'P'){
						if (UniUtils.indexOf(e.field, ['SEQ']))
							return false;
					}
				}*/

				if(!e.record.phantom){					/* 신규가 아닐 때*/
					if (UniUtils.indexOf(e.field,
										[/* 수주정보 */
										 'COMP_CODE','DIV_CODE','ORDER_TYPE','PLAN_TYPE','ORDER_NUM','SEQ','ITEM_CODE','ITEM_NAME',
										 'SPEC','STOCK_UNIT','STOCK_Q','ORDER_DATE','DVRY_DATE','PROD_END_DATE','ORDER_UNIT_Q',
										 'PROD_Q','SUM_WK_PLAN_Q', 'PROJECT_NO','PJT_CODE',
										 /* 계획정보 */
										 'WK_PLAN_NUM',
										 /* 연계정보 */
										 'MRP_YN','WKORD_NUM','WKORD_Q','PRODT_Q',
										 'UPDATE_DB_USER','UPDATE_DB_TIME','CAPA_OVER_FLAG'
										 ]))
							return false;
				}

				else if(!e.record.phantom){
					if(e.record.data.WKORD_NUM == '' || e.record.data.MRP_YN == 'Y'){
						if (UniUtils.indexOf(e.field,
										['WORK_SHOP_CODE','PRODT_PLAN_DATE','PRODT_PLAN_TIME','WK_PLAN_Q','ITEM_CODE','REMARK','ITEM_NAME']) )
							return false;
					}
				}


				else if(e.record.phantom){					/* 신규일 때 */
					if (UniUtils.indexOf(e.field,
										[/* 수주정보 */
										 'COMP_CODE','DIV_CODE','ORDER_TYPE','PLAN_TYPE','ORDER_NUM','SEQ',
										 'SPEC','STOCK_UNIT','STOCK_Q','ORDER_DATE','DVRY_DATE','PROD_END_DATE','ORDER_UNIT_Q',
										 'PROD_Q','SUM_WK_PLAN_Q',
										 /* 계획정보 */
										 'WK_PLAN_NUM',
										 /* 연계정보 */
										 'MRP_YN','WKORD_NUM','WKORD_Q','PRODT_Q',
										 'UPDATE_DB_USER','UPDATE_DB_TIME','CAPA_OVER_FLAG'
										 ]))
							return false;
				}

		},
		onGridDblClick: function(grid, record, cellIndex, colName) {
	          	masterGrid.returnData(record);
	          	//UniAppManager.app.onQueryButtonDown();
	          	if(!record.phantom){
	          		this.returnCell(record, colName);
	          	}
          	}
       	},
        returnData: function(record){
			if(Ext.isEmpty(record)){
          		record = this.getSelectedRecord();
        	}
       	},
       	returnCell: function(record, colName){
       		var cellValue   = record.get(colName);
       		var itemCode    = record.get('ITEM_CODE');
       		var itemName    = record.get('ITEM_NAME');
      		var orderNum    = record.get('ORDER_NUM');
      		var wkPlanNum   = record.get('WK_PLAN_NUM');
      		var seq   		= record.get('SEQ');
      		var wkordNum    = record.get('WKORD_NUM');


       		if(itemCode == cellValue){
          		masterForm.setValues({'ITEM_CODE':itemCode});
          		panelResult.setValues({'ITEM_CODE':itemCode});
       		}
       		if(itemName == cellValue){
          		masterForm.setValues({'ITEM_CODE':itemCode});
          		panelResult.setValues({'ITEM_CODE':itemCode});
       		}
       		if(orderNum == cellValue){
       			masterForm.setValues({'ORDER_NUM':orderNum});
       			panelResult.setValues({'ORDER_NUM':orderNum});
       		}
       		if(wkPlanNum == cellValue){
       			masterForm.setValues({'WK_PLAN_NUM':wkPlanNum});
       			panelResult.setValues({'WK_PLAN_NUM':wkPlanNum});
       		}
       		if(seq == cellValue){
       			masterForm.setValues({'ORDER_SEQ':seq});
       			panelResult.setValues({'ORDER_SEQ':seq});
       		}
     		if(wkordNum == cellValue){								/* FORM 조건에 없음 */
       			masterForm.setValues({'WKORD_NUM':wkordNum});
       			panelResult.setValues({'WKORD_NUM':wkordNum});
       		}

       	},
		/*disabledLinkButtons: function(b) {
       		this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
		},*/
		setItemData: function(record, dataClear, grdRecord) {
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'		,"");
       			grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('STOCK_UNIT'		,"");
				grdRecord.set('OUTSTOCK_REQ_Q'  ,"");
				grdRecord.set('CONTROL_STATUS'  ,"");

       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('ORDER_UNIT'			, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('OUTSTOCK_REQ_Q'		, "");
				grdRecord.set('CONTROL_STATUS'		, 2);
       		}
		},

		setProjectData: function(record, dataClear) {			/* 관리번호 Grid Popup */
       		var grdRecord = masterGrid.uniOpt.currentRecord;
       		if(dataClear) {
       			grdRecord.set('PROJECT_NO'		,"");

       		} else {
       			grdRecord.set('PROJECT_NO'		, record['PJT_CODE']);
       		}
		},

		setPjtData: function(record, dataClear) {			/* 프로젝트 Grid Popup */
       		var grdRecord = masterGrid.uniOpt.currentRecord;
       		if(dataClear) {
       			grdRecord.set('PJT_CODE'		,"");

       		} else {
       			grdRecord.set('PJT_CODE'		, record['PJT_CODE']);
       		}
		},

		setEstiData:function(record) {
       		var grdRecord = masterGrid.uniOpt.currentRecord;
		},


		setRefData: function(record) {
       		var grdRecord = this.getSelectedRecord();

			grdRecord.set('PLAN_TYPE'			, record['PLAN_TYPE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_TYPE'			, record['PLANTYPE_NAME']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('PROD_END_DATE'		, record['PROD_END_DATE']);
			grdRecord.set('DVRY_DATE'			, record['DVRY_DATE']);
			grdRecord.set('ORDER_DATE'			, record['ORDER_DATE']);
			grdRecord.set('ORDER_UNIT_Q'		, record['ORDER_Q']);
			grdRecord.set('PROD_Q'				, record['PROD_Q']);
			//grdRecord.set('SUM_WK_PLAN_Q'		, record['PROD_Q']);

			grdRecord.set('REMARK'				, record['CUSTOM_NAME']);
			grdRecord.set('WORK_SHOP_CODE'		, record['WORK_SHOP_CODE']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('PJT_CODE'			, record['PJT_CODE']);
       }
    });

    //수주참조 참조 메인
    function openOrderInformationWindow() {
  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		OrderSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
		OrderSearch.setValue('PROD_END_DATE_FR', masterForm.getValue('PRODT_PLAN_DATE_FR'));
  		OrderSearch.setValue('PROD_END_DATE_TO', masterForm.getValue('PRODT_PLAN_DATE_TO'));
  		masterForm.setValue('TXT_SEARCH','');

		if(!referOrderInformationWindow) {

			referOrderInformationWindow = Ext.create('widget.uniDetailWindow', {
                title: '수주정보참조',
                width: 1080,
                height: 580,
                layout:{type:'vbox', align:'stretch'},

                items: [OrderSearch, OrderGrid],
                tbar:  ['->',
								        {	itemId : 'saveBtn',
								        	id:'saveBtn1',
											text: '조회',
											handler: function() {
												OrderStore.loadStoreRecords();
											},
											disabled: false
										},
										{	itemId : 'confirmBtn',
											id:'confirmBtn1',
											text: '생산계획계산',
											handler: function() { /////
												masterForm.setValue('COM',"적용");
												OrderStore.saveStore();  /* 저장된 후 조회 */
											},
											disabled: false
										},
										{	itemId : 'confirmCloseBtn',
											id:'confirmCloseBtn1',
											text: '생산계획계산 적용 후 닫기',
											handler: function() {
												masterForm.setValue('COM',"적용후닫기");
												OrderStore.saveStore();
												referOrderInformationWindow.hide();
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											id:'closeBtn1',
											text: '닫기',
											handler: function() {
//												masterStore.saveStore();
												var searchYn = masterForm.getValue('TXT_SEARCH');
												if(searchYn == 'Y'){

													masterStore.loadStoreRecords();

												}
												referOrderInformationWindow.hide();

											},
											disabled: false
										}
							    ]
							,
                listeners : {beforehide: function(me, eOpt)	{
                						},
                			 beforeclose: function( panel, eOpts )	{
                			 			},
                			 beforeshow: function ( me, eOpts )	{
                			 	OrderStore.loadStoreRecords();
                			 }
                }
			})
		}
		referOrderInformationWindow.show();
		referOrderInformationWindow.center();
    }

    // 수주정보 참조 모델 정의
	Unilite.defineModel('s_ppl111ukrv_kdOrderModel', {
	    fields: [
	    	{name: 'GUBUN'         		, text: '선택'			         , type: 'string'},
	    	{name: 'PLAN_TYPE'     		, text: '유형코드' 		         , type: 'string'},
		    {name: 'PLANTYPE_NAME' 		, text: '유형'			         , type: 'string'},
		    {name: 'ITEM_CODE'     		, text: '품목코드' 		         , type: 'string'},
		    {name: 'ITEM_NAME'     		, text: '품명' 			         , type: 'string'},
		    {name: 'SPEC'          		, text: '규격'			         , type: 'string'},
		    {name: 'STOCK_UNIT'    		, text: '단위' 			         , type: 'string'},
		    {name: 'PROD_Q'        		, text: '생산요청량' 		     , type: 'uniQty'},
            {name: 'NOTREF_Q2'          , text: '미계획량'               , type: 'uniQty'},
		    {name: 'NOTREF_Q'      		, text: '생산계획량'		     , type: 'uniQty'},
            {name: 'PROD_END_DATE'      , text: '생산계획일'            , type: 'uniDate'},
	    	{name: 'PROD_END_DATE2' 	, text: '생산요청일' 		     , type: 'uniDate'},
		    {name: 'DVRY_DATE'     		, text: '납기일'			     , type: 'uniDate'},
		    {name: 'ORDER_DATE'    		, text: '수주일' 			     , type: 'uniDate'},
		    {name: 'ORDER_Q'       		, text: '수주수량' 		         , type: 'uniQty'},
		    {name: 'CUSTOM_NAME'   		, text: '거래처'			     , type: 'string'},
		    {name: 'SER_NO'        		, text: '수주순번'			     , type: 'string'},
		    {name: 'WORK_SHOP_CODE'		, text: '주작업장' 		         , type: 'string' , comboType: 'WU'},
		    {name: 'ORDER_NUM'     		, text: '수주번호' 		         , type: 'string'},
		    {name: 'PROJECT_NO'    		, text: '프로젝트번호'			 , type: 'string'},
		    {name: 'PJT_CODE'      		, text: '프로젝트코드' 		     , type: 'string'},
            {name: 'STOCK_Q'            , text: '현재고량'             , type: 'uniQty'},
			/* 파라미터 */
		    {name: 'DIV_CODE'    		, text: '사업장'			     , type: 'string'},
		    {name: 'PAD_STOCK_YN'      	, text: '가용재고 반영여부' 	 , type: 'string'},
		    {name: 'CHECK_YN'      		, text: '그리드선택 여부' 	     , type: 'string'}  // 선택 했을때 체크하는 값 (그리드 데이터랑 관련없음)

		]
	});

	//수주정보 참조 스토어 정의
	var OrderStore = Unilite.createStore('s_ppl111ukrv_kdOrderStore', {
		model: 's_ppl111ukrv_kdOrderModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            proxy: directProxy2
            ,loadStoreRecords : function()	{
				var param= OrderSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
			saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);

			var paramMaster= OrderSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {

						if(masterForm.getValue('COM') == "적용"){
							OrderStore.loadStoreRecords();
							masterForm.setValue('COM', '');
							masterForm.setValue('TXT_SEARCH','Y');

						}
						else if(masterForm.getValue('COM') == "적용후닫기"){
							//OrderStore.loadStoreRecords();
							masterStore.loadStoreRecords();
							masterForm.setValue('COM', '');
						}
					}
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('s_ppl111ukrv_kdOrderGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

    /**
	 * 수주정보참조을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//수주정보 참조 폼 정의
	 var OrderSearch = Unilite.createSearchForm('OrderForm', {
            layout :  {type : 'uniTable', columns : 3},
            items :[{
	        	fieldLabel: '사업장',
	        	name:'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType:'BOR120'
	        }, {
            	fieldLabel: '생산요청일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'PROD_END_DATE_FR',
			    endFieldName: 'PROD_END_DATE_TO',
			    width: 350,
			    startDate: UniDate.get('mondayOfWeek'),
			    endDate: UniDate.get('endOfWeek')
	       }, {
				xtype: 'uniRadiogroup',
				width: 235,
				items: [{
						boxLabel:'전체',
						name:'PLAN_TYPE',
						inputValue:'',
						checked:true,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								OrderStore.loadStoreRecords();
							}
						}
					},{
						boxLabel:'수주',
						name:'PLAN_TYPE',
						inputValue:'S',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								OrderStore.loadStoreRecords();
							}
						}
					},{
						boxLabel:'무역 S/O',
						name:'PLAN_TYPE',
						inputValue:'T',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								OrderStore.loadStoreRecords();
							}
						}
					}
  			]}, {
                 xtype: 'fieldcontainer',
                 fieldLabel: '수주번호',
                 combineErrors: true,
                 msgTarget : 'side',
                 layout: {type : 'table', columns : 3},
                 defaults: {
                     flex: 1,
                     hideLabel: true
                 },
                 defaultType : 'textfield',
                 items: [
                 	Unilite.popup('ORDER_NUM',{
			        	fieldLabel: '',
			        	valueFieldName: 'FROM_NUM',
			        	textFieldName: 'FROM_NUM',
						allowBlank:false,
			        	listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
							}
						}
			   		}),
                 	{xtype:  'displayfield', value:'&nbsp;~&nbsp;'},
                 	Unilite.popup('ORDER_NUM',{
			        	fieldLabel: '',
			        	valueFieldName: 'TO_NUM',
			        	textFieldName: 'TO_NUM',
						allowBlank:false,
			        	listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
							}
						}
			   		})
                   ]
               },{
                 xtype: 'fieldcontainer',
                 fieldLabel: '품목코드',
                 combineErrors: true,
                 msgTarget : 'side',
                 colspan:2,
                 layout: {type : 'table', columns : 3},
                 defaults: {
                     flex: 1,
                     hideLabel: true
                 },
                 defaultType : 'textfield',
                 items: [
	                 Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '품목코드',
			        	valueFieldName: 'ITEM_CODE_FR',
						textFieldName: 'ITEM_NAME_FR',
						allowBlank:false,
			        	listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
							}
						}
			   		}),
                 	{xtype:  'displayfield', value:'&nbsp;~&nbsp;'},
                 	Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '품목코드',
			        	valueFieldName: 'ITEM_CODE_TO',
						textFieldName: 'ITEM_NAME_TO',
						allowBlank:false,
			        	listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
							}
						}
			   		})
                   ]
               },{
				fieldLabel: '※ 생산계획계산시 가용재고(현재고+입고예정-출고예정-안전재고)반영여부 ',
				xtype: 'uniRadiogroup',
				labelWidth:450,
				width: 235,
				colspan:3,
				name:'PAD_STOCK_YN',
				id:'padStockYn',
				items: [{
						boxLabel:'예',
						width:70,
						name:'PAD_STOCK_YN',
						inputValue:'Y'
					},{
						boxLabel:'아니오',
						width:70,
						name:'PAD_STOCK_YN',
						inputValue:'N' ,
						checked:true
				}]
		}]

    });


	/* 수주정보 그리드 */
	 var OrderGrid = Unilite.createGrid('s_ppl111ukrv_kdOrderGrid', {
    	layout : 'fit',
    	store: OrderStore,
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
			uniOpt:{
	        	onLoadSelectFirst : false,
                editable: true            // 수정 모드 사용

	        },
        columns: [
        	{ dataIndex: 'GUBUN'            		, width: 40,  hidden: true},
        	{ dataIndex: 'CHECK_YN'            		, width: 40 , hidden: true},
        	{ dataIndex: 'PLAN_TYPE'        		, width: 40 , hidden: true},
        	{ dataIndex: 'PLANTYPE_NAME'    		, width: 80},
        	{ dataIndex: 'ITEM_CODE'        		, width: 120},
        	{ dataIndex: 'ITEM_NAME'        		, width: 140},
        	{ dataIndex: 'SPEC'             		, width: 126},
        	{ dataIndex: 'STOCK_UNIT'       		, width: 44, align:'center'},
        	{ dataIndex: 'PROD_Q'           		, width: 90},
            { dataIndex: 'NOTREF_Q2'                , width: 90},
        	{ dataIndex: 'NOTREF_Q'         		, width: 90},
            { dataIndex: 'PROD_END_DATE'            , width: 80},
        	{ dataIndex: 'PROD_END_DATE2'    		, width: 80},
        	{ dataIndex: 'DVRY_DATE'        		, width: 80},
        	{ dataIndex: 'ORDER_DATE'       		, width: 80},
        	{ dataIndex: 'ORDER_Q'          		, width: 90},
            { dataIndex: 'STOCK_Q'                  , width: 90},
        	{ dataIndex: 'CUSTOM_NAME'      		, width: 120},
        	{ dataIndex: 'SER_NO'           		, width: 100  , hidden: true},
        	{ dataIndex: 'WORK_SHOP_CODE'   		, width: 100  , hidden: true},
        	{ dataIndex: 'ORDER_NUM'        		, width: 100},
        	{ dataIndex: 'PROJECT_NO'       		, width: 100 , hidden: true},
        	{ dataIndex: 'PJT_CODE'         		, width: 100 , hidden: true}
		]
		,listeners: {
            beforeedit: function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['NOTREF_Q', 'PROD_END_DATE'])) {
                   return true;
                }
                else {
                    return false;
                }
            },
        	onGridDblClick:function(grid, record, cellIndex, colName) {
  			},
	       	deselect: function( model, record, index, eOpts ){
				record.set('CHECK_YN', '')
			},
			select: function( model, record, index, eOpts ){
				record.set('CHECK_YN', 'S')
			}
		}
    });


	//판매계획 참조 메인
	function openSalesPlanWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;

  		SalesPlanSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
		SalesPlanSearch.setValue('FROM_MONTH', masterForm.getValue('PRODT_PLAN_DATE_FR'));
  		SalesPlanSearch.setValue('TO_MONTH',masterForm.getValue('PRODT_PLAN_DATE_FR'));
//  		UniAppManager.app.fnCheckMonthPlanWeek();
		masterForm.setValue('TXT_SEARCH','');
		if(!referSalesPlanWindow) {
			referSalesPlanWindow = Ext.create('widget.uniDetailWindow', {
                title: '판매계획참조',
                width: 1080,
                height: 580,
                layout:{type:'vbox', align:'stretch'},

                items: [SalesPlanSearch, SalesPlanGrid],
                tbar:  ['->',
								        {	itemId : 'saveBtn',
											text: '조회',
											handler: function() {
												SalesPlanStore.loadStoreRecords();
											},
											disabled: false
										},
										{	itemId : 'confirmBtn',
											id:'confirmBtn2',
											text: '생산계획계산',
											handler: function() {
												masterForm.setValue('COM',"적용");
												SalesPlanStore.saveStore();

											},
											disabled: false
										},
										{	itemId : 'confirmCloseBtn',
											id:'confirmCloseBtn2',
											text: '생산계획계산적용 후 닫기',
											handler: function() {
												masterForm.setValue('COM',"적용후닫기");
												SalesPlanStore.saveStore();
												referSalesPlanWindow.hide();
//												UniAppManager.app.onQueryButtonDown();
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											text: '닫기',
											handler: function() {
//												masterStore.saveStore();
												var searchYn = masterForm.getValue('TXT_SEARCH');
												referSalesPlanWindow.hide();
												if(searchYn == 'Y'){

													masterStore.loadStoreRecords();

												}
											},
											disabled: false
										}
							    ]
							,
                listeners : {beforehide: function(me, eOpt)	{
                							//SalesOrderSearch.clearForm();
                							//SalesOrderGrid.reset();
                						},
                			 beforeclose: function( panel, eOpts )	{
											//SalesOrderSearch.clearForm();
                							//SalesOrderGrid.reset();
                			 			},
                			  beforeshow: function ( me, eOpts )	{
                			 	SalesPlanStore.loadStoreRecords();
                			 }
                }
			})
		}
		referSalesPlanWindow.show();
		referSalesPlanWindow.center();
    }

    //판매계획 참조 모델 정의
	Unilite.defineModel('s_ppl111ukrv_kdSalesPlanModel', {
	    fields: [
	    	{name: 'GUBUN'         		, text: '선택'			, type: 'string'},
	    	{name: 'PLAN_TYPE'     		, text: '유형코드' 		, type: 'string'},
		    {name: 'PLANTYPE_NAME' 		, text: '유형'			, type: 'string'},
		    {name: 'ITEM_ACCOUNT'  		, text: '품목계정' 		, type: 'string' , comboType:'AU', comboCode:'B020'},
		    {name: 'ITEM_CODE'     		, text: '품목코드' 		, type: 'string'},
		    {name: 'ITEM_NAME'     		, text: '품명'			, type: 'string'},
		    {name: 'SPEC'           	, text: '규격'				, type: 'string'},
		    {name: 'STOCK_UNIT'    		, text: '재고단위' 		, type: 'string'},
		    {name: 'PLAN_QTY'      		, text: '계획량' 		, type: 'uniQty'},
            {name: 'NOTREF_Q2'          , text: '미계획량'    , type: 'uniQty'},
		    {name: 'NOTREF_Q'      		, text: '생산계획량'	, type: 'uniQty'},
	    	{name: 'BASE_DATE'     		, text: '생산계획일'   , type: 'uniDate'},
		    {name: 'SALE_TYPE'     		, text: '판매유형'		, type: 'string'},
		    {name: 'WORK_SHOP_CODE'		, text: '작업장코드' 	, type: 'string'},
		    {name: 'DIV_CODE'      		, text: '작업장' 		, type: 'string'},
		    {name: 'ORDER_NUM'     		, text: '수주번호'		, type: 'string'},
		    {name: 'SER_NO'        		, text: '수주순번'		, type: 'string'},
		    {name: 'ORDER_Q'       		, text: '수주수량'		, type: 'uniQty'},
            {name: 'STOCK_Q'            , text: '현재고량'    , type: 'uniQty'}
		]
	});

	//판매계획 참조 스토어 정의
	var SalesPlanStore = Unilite.createStore('s_ppl111ukrv_kdSalesPlanStore', {
		model: 's_ppl111ukrv_kdSalesPlanModel',
		autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            proxy: directProxy3
            ,loadStoreRecords : function()	{
				var param= SalesPlanSearch.getValues();
				param.FROM_MONTH = UniDate.getDbDateStr(SalesPlanSearch.getValue('FROM_MONTH')).substring(0, 6);
                param.TO_MONTH = UniDate.getDbDateStr(SalesPlanSearch.getValue('TO_MONTH')).substring(0, 6);
				console.log( param );
				this.load({
					params : param
				});
			},
			saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);

			var paramMaster= SalesPlanSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {

						if(masterForm.getValue('COM') == "적용"){
							OrderStore.loadStoreRecords();
							masterForm.setValue('COM', '');
							masterForm.setValue('TXT_SEARCH', 'Y');
						}
						else if(masterForm.getValue('COM') == "적용후닫기"){
							//OrderStore.loadStoreRecords();
							masterStore.loadStoreRecords();
							masterForm.setValue('COM', '');
						}
					}
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('s_ppl111ukrv_kdSalesPlanGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	/**
	 * 판매계획을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
    //판매계획 참조 폼 정의
	var SalesPlanSearch = Unilite.createSearchForm('s_ppl111ukrv_kdSalesPlanForm', {
        layout :  {type : 'uniTable', columns :4},
        items :[{
	        	fieldLabel: '사업장',
	        	name:'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType:'BOR120'
	    	}, {
	        	fieldLabel: '계획기간',
			    xtype: 'uniMonthRangefield',
			    startFieldName: 'FROM_MONTH',
			    endFieldName: 'TO_MONTH',
			    startDate: UniDate.get('startOfMonth'),
			    endDate: UniDate.get('today'),
		        allowBlank:false,
//                reaOnly: true,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(SalesPlanSearch) {
//                    	var frDate = UniDate.getDbDateStr(SalesPlanSearch.getValue('FROM_MONTH')).substring(0, 4) + '1231'
//                    	SalesPlanSearch.setValue('FROM_MONTH2', frDate);
//                        ///////////////////////////////////////////////////////////////////////////////////// 주차함수
//                    	UniAppManager.app.fnCheckMonthPlanWeek();
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(SalesPlanSearch) {
//                    	var toDate = UniDate.getDbDateStr(SalesPlanSearch.getValue('TO_MONTH')).substring(0, 4) + '1231'
//                        SalesPlanSearch.setValue('TO_MONTH2', toDate);
//                        ///////////////////////////////////////////////////////////////////////////////////// 주차함수
//                        UniAppManager.app.fnCheckMonthPlanWeek();
                    }
                }
	       }/*, {
                fieldLabel: '계획기간HIDDEN',
                xtype: 'uniDateRangefield',
                hidden: true,
                startFieldName: 'FROM_MONTH2',
                endFieldName: 'TO_MONTH2'
           }*/, {
	        	fieldLabel: '판매유형',
	        	name:'SALE_TYPE',
	        	xtype: 'uniCombobox',
	        	comboType:'AU',
	        	comboCode:'S002'
		   }, {
	        	fieldLabel: '대표모델',
	        	name:'ITEM_GROUP',
	        	xtype: 'uniTextfield'
		   },{
               xtype: 'fieldcontainer',
               fieldLabel: '품목코드',
               combineErrors: true,
               msgTarget : 'side',
               colspan:4,
               layout: {type : 'table', columns :4},
               defaults: {
                   flex: 1,
                   hideLabel: true
               },
               defaultType : 'textfield',
               items: [
	                 Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '품목코드',
			        	valueFieldName: 'ITEM_CODE_FR',
						textFieldName: 'ITEM_NAME_FR',
						allowBlank:false,
			        	listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': SalesPlanSearch.getValue('DIV_CODE')});
							}
						}
			   		}),
               	{xtype:  'displayfield', value:'&nbsp;~&nbsp;'},
               	Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '품목코드',
			        	valueFieldName: 'ITEM_CODE_TO',
						textFieldName: 'ITEM_NAME_TO',
						allowBlank:false,
			        	listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': SalesPlanSearch.getValue('DIV_CODE')});
							}
						}
			   		})
                 ]
             },{
	        	fieldLabel: '품목계정',
	        	name:'ITEM_ACCOUNT',
	        	xtype: 'uniCombobox',
	        	comboType:'AU',
	        	comboCode:'B020'
		   }/*,{
                xtype: 'container',
                items:[{
                    xtype: 'container',
                    defaultType: 'uniTextfield',
                    layout: {type: 'uniTable', columns: 2},
                    width: 250,
                    items: [{
                        fieldLabel: '계획주차',
                        allowBlank:false,
                        //suffixTpl: '&nbsp;~&nbsp;',
                        width: 195,
                        name: 'FROM_WEEK',
                        maxLength: 8,
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                            	var frDate = SalesPlanSearch.getValue('FROM_WEEK').substring(0, 4) + '1231'
                                SalesPlanSearch.setValue('FROM_MONTH2', frDate);
                                ////////////////////////////////////////////////////////// 계획주차 함수
                            	UniAppManager.app.fnCheckPlanWeek();
                            }
                        }
                    }, {
                        name: 'TO_WEEK',
                        width: 120,
                        fieldLabel: '~',
                        maxLength: 8,
                        labelWidth: 15,
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                var toDate = SalesPlanSearch.getValue('TO_WEEK').substring(0, 4) + '1231'
                                SalesPlanSearch.setValue('TO_MONTH2', toDate);
                                ////////////////////////////////////////////////////////// 계획주차 함수
                                UniAppManager.app.fnCheckPlanWeek();
                            }
                        }
                    }]
                }]
            }*/,{
		    	fieldLabel: '대분류',
		    	name: 'TXTLV_L1',
		    	xtype: 'uniCombobox',
		    	store: Ext.data.StoreManager.lookup('itemLeve1Store'),
		    	child: 'TXTLV_L2'
			},{
			    fieldLabel: '중분류',
			    name: 'TXTLV_L2',
			    xtype: 'uniCombobox',
			    store: Ext.data.StoreManager.lookup('itemLeve2Store'),
			    child: 'TXTLV_L3'
			},{
			    fieldLabel: '소분류',
			    name: 'TXTLV_L3',
			    xtype: 'uniCombobox',
			    store: Ext.data.StoreManager.lookup('itemLeve3Store')
	    	},{
			    fieldLabel: '맞춤용',
			    name: 'TXT_SET',
			    xtype: 'uniCombobox',
			    hidden:true,
			    store: Ext.data.StoreManager.lookup('itemLeve3Store')
	    	},{
				fieldLabel: '※ 생산계획계산시 가용재고(현재고+입고예정-출고예정-안전재고)반영여부 ',
				xtype: 'uniRadiogroup',
				labelWidth:450,
				width: 235,
				colspan:3,
				items: [{
						boxLabel:'예',
						width:70,
						name:'PAD_STOCK_YN',
						inputValue:'Y'
					},{
						boxLabel:'아니오',
						width:70,
						name:'PAD_STOCK_YN',
						inputValue:'N' ,
						checked:true
				}]
			}]
    });

	//판매계획 참조 그리드 정의

    var SalesPlanGrid = Unilite.createGrid('s_ppl111ukrv_kdSalesPlanGrid', {
    	// title: '기본',
        layout : 'fit',
        region:'center',
    	store: SalesPlanStore,
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
			uniOpt:{
	        	onLoadSelectFirst : false,
                editable: true            // 수정 모드 사용
	        },
        columns: [
        	{ dataIndex: 'GUBUN'           		, width: 40,  hidden: true},
        	{ dataIndex: 'CHECK_YN'            	, width: 40 ,  hidden: true},
        	{ dataIndex: 'PLAN_TYPE'       		, width: 40 , hidden: true},
        	{ dataIndex: 'PLANTYPE_NAME'   		, width: 100},
        	{ dataIndex: 'ITEM_ACCOUNT'    		, width: 66 },
        	{ dataIndex: 'ITEM_CODE'       		, width: 100},
        	{ dataIndex: 'ITEM_NAME'       		, width: 146},
        	{ dataIndex: 'SPEC'       		    , width: 146},
        	{ dataIndex: 'STOCK_UNIT'      		, width: 66 },
        	{ dataIndex: 'PLAN_QTY'        		, width: 120},
            { dataIndex: 'NOTREF_Q2'            , width: 120},
        	{ dataIndex: 'NOTREF_Q'        		, width: 120},
        	{ dataIndex: 'BASE_DATE'       		, width: 100},
        	{ dataIndex: 'SALE_TYPE'       		, width: 100},
            { dataIndex: 'STOCK_Q'              , width: 100},
        	{ dataIndex: 'WORK_SHOP_CODE'  		, width: 66 , hidden: true},
        	{ dataIndex: 'DIV_CODE'        		, width: 100 , hidden: true},
        	{ dataIndex: 'ORDER_NUM'       		, width: 100 , hidden: true},
        	{ dataIndex: 'SER_NO'          		, width: 100 , hidden: true},
        	{ dataIndex: 'ORDER_Q'         		, width: 100 , hidden: true}
		]
		,listeners: {
            beforeedit: function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['NOTREF_Q', 'BASE_DATE'])) {
                   return true;
                }
                else {
                    return false;
                }
            },
        	onGridDblClick:function(grid, record, cellIndex, colName) {
  			},
	       	deselect: function( model, record, index, eOpts ){
				record.set('CHECK_YN', '')
			},
			select: function( model, record, index, eOpts ){
				record.set('CHECK_YN', 'M')
			}
		}
    });



	 /**
	 * main app
	 */
    Unilite.Main({
		id: 's_ppl111ukrv_kdApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			masterForm
		],
		fnInitBinding: function() {
//			var dt = masterForm.getValue('PRODT_PLAN_DATE_TO');
//            alert(Ext.Date.getWeekOfYear(dt));
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
			//masterGrid.disabledLinkButtons(false);
			this.setDefault();
		},
		onQueryButtonDown: function() {

			if(masterForm.setAllFieldsReadOnly(true) == false)   // 필수값을 체크
			{
        		return false;
			}
			else
			{
				masterStore.loadStoreRecords();
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;

				 var seq = masterStore.max('SEQ');
            	 if(!seq) seq = 1;
            	 else  seq += 1;

            	 var compCode		= UserInfo.compCode
            	 var divCode        = masterForm.getValue('DIV_CODE');
            	 var workShopCode   = masterForm.getValue('WORK_SHOP_CODE');
            	 var prodtPlanDate  = UniDate.get('today');
            	 var wkPlanQ        = '0';
            	 var updateDbUser   = 'UserInfo.UserID';
            	 var updateDbTime   = UniDate.get('today');

            	 var stockQ			= '';
            	 var orderUnitQ		= '';
            	 var prodQ			= '';
            	 var sumWkPlanQ		= '';
            	 var wkordQ			= '';
            	 var prodtQ			= '';


            	 var r = {
            	 	SEQ             : seq,			/* 순번 */
            	 	COMP_CODE	    : compCode,		/* 법인코드*/
					DIV_CODE        : divCode,		/* 사업장*/
					WORK_SHOP_CODE  : workShopCode,	/* 작업장 */
					PRODT_PLAN_DATE : prodtPlanDate,/* 계획정보 - 계획일 */
					WK_PLAN_Q       : wkPlanQ,		/* 계획량 */
					UPDATE_DB_USER  : updateDbUser, /* 수정자 */
					UPDATE_DB_TIME  : updateDbTime  /* 수정일 */

				   ,STOCK_Q			:stockQ,		/* 수주정보 - 현재고 */
					ORDER_UNIT_Q	:orderUnitQ,	/* 수주정보 - 수주량 */
					PROD_Q			:prodQ,			/* 수주정보 - 생산요청량 */
					SUM_WK_PLAN_Q	:sumWkPlanQ,	/* 수주정보 - 계획량 */
					WKORD_Q			:wkordQ,		/* 연계정보 - 작업지시량 */
					PRODT_Q			:prodtQ			/* 연계정보 - 생산량 */
		        };

				masterGrid.createRow(r);
				masterForm.setAllFieldsReadOnly(false);
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			masterForm.clearForm();
			panelResult.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			masterGrid.reset();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			masterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('WKORD_NUM') != '') {
					alert('<t:message code="unilite.msg.sMP689" default= "작업지시번호 존재할 경우 해당건에 대해 수정 또는 삭제 할 수 없습니다."/>');

				}else if(selRow.get('MRP_YN') == 'Y'){
					alert("MRP연계 'Y'일 경우 해당건에 대해 수정 또는 삭제 할 수 없습니다.");
				//                                                          신텍스 에러 발생

				}else {
					masterGrid.deleteSelectedRow();
				}
			}

		},
		onDeleteAllButtonDown: function() {
			var records = MasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){
							masterGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
						isNewData = false;
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('s_ppl111ukrv_kdAdvanceSerch');
			if(as.isHidden())	{
				as.show();
			} else {
				as.hide()
			}
		},
		rejectSave: function() {
			var rowIndex = masterGrid.getSelectedRowIndex();
			masterGrid.select(rowIndex);
			masterStore.rejectChanges();

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
			masterStore.onStoreActionEnable();

		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('s_ppl111ukrv_kdFileUploadPanel');
        	if(masterStore.isDirty() || fp.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
        	masterForm.setValue('DIV_CODE',UserInfo.divCode);
        	masterForm.setValue('PRODT_PLAN_DATE_FR', UniDate.get('today'));
        	masterForm.setValue('PRODT_PLAN_DATE_TO', UniDate.get('endOfMonth'));

        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('PRODT_PLAN_DATE_FR', UniDate.get('today'));
        	panelResult.setValue('PRODT_PLAN_DATE_TO', UniDate.get('endOfMonth'));

			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		},
        checkForNewDetail:function() {
			if(Ext.isEmpty(masterForm.getValue('PRODT_PLAN_DATE_FR')) || Ext.isEmpty(masterForm.getValue('PRODT_PLAN_DATE_TO')))	{
				alert('<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}

			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return masterForm.setAllFieldsReadOnly(true);
        }
//        fnCheckMonthPlanWeek: function(value, record, fieldName) {
//        	if(UniDate.getDbDateStr(SalesPlanSearch.getValue('FROM_MONTH')).length >= 8)    {
//                var sFrPlanWeek = UniDate.getDbDateStr(SalesPlanSearch.getValue('FROM_MONTH'));
//                var integerWeek = parseInt(Ext.Date.getWeekOfYear(SalesPlanSearch.getValue('FROM_MONTH2')));
//                if (integerWeek < 10) {
//                        integerWeek = '0' + integerWeek
//                } else {
//                    integerWeek
//                }
//                var sFrLastweek = sFrPlanWeek.substring(0, 4) + '0' + parseInt(integerWeek + parseInt(gsFrWeekList[0].REF_CODE1) + parseInt(gsToWeekList[0].REF_CODE1));
//                var weekCal1 = '000' + integerWeek;
//                var integerWeek2 = parseInt(parseInt(weekCal1.substring(2, 6)) + parseInt(gsFrWeekList[0].REF_CODE1));
//                if(integerWeek2 < 10) {
//                    integerWeek2 = '00' + integerWeek2
//                } else {
//                    integerWeek2 = '0' + integerWeek2
//                }
//                if(sFrPlanWeek.substring(0, 4) +  integerWeek2 > parseInt(sFrLastweek)) {
//                    if(gsFrWeekList[0].REF_CODE1 == '0') {
//                        SalesPlanSearch.setValue('FROM_WEEK', parseInt(parseInt(sFrLastweek) + parseInt('1')) + '001')
//                    } else {
//                        SalesPlanSearch.setValue('FROM_WEEK', parseInt(parseInt(sFrLastweek) + parseInt('1')) + '000')
//                    }
//                } else {
//                    SalesPlanSearch.setValue('FROM_WEEK', sFrPlanWeek.substring(0, 4) +  integerWeek2)
//                }
//            } else if(SalesPlanSearch.getValue('FROM_MONTH').length < 8) {
//
//            }
//
//            if(SalesPlanSearch.getValue('TO_MONTH').length >= 8)    {
//                var sToPlanWeek = UniDate.getDbDateStr(SalesPlanSearch.getValue('TO_MONTH'));
//                var integerWeek = parseInt(Ext.Date.getWeekOfYear(SalesPlanSearch.getValue('TO_MONTH2')));
//                if (integerWeek < 10) {
//                        integerWeek = '0' + integerWeek
//                } else {
//                    integerWeek
//                }
//                var sToLastweek = sToPlanWeek.substring(0, 4) + '0' + parseInt(integerWeek + parseInt(gsFrWeekList[0].REF_CODE1) + parseInt(gsToWeekList[0].REF_CODE1));
//                var weekCal1 = '000' + integerWeek;
//                var integerWeek2 = parseInt(parseInt(weekCal1.substring(2, 6)) + parseInt(gsToWeekList[0].REF_CODE1));
//                if(integerWeek2 < 10) {
//                    integerWeek2 = '00' + integerWeek2
//                } else {
//                    integerWeek2 = '0' + integerWeek2
//                }
//                if(sToPlanWeek.substring(0, 4) +  integerWeek2 > parseInt(sToLastweek)) {
//                    if(gsFrWeekList[0].REF_CODE1 == '0') {
//                        SalesPlanSearch.setValue('TO_WEEK', parseInt(parseInt(sFrLastweek) + parseInt('1')) + '001')
//                    } else {
//                        SalesPlanSearch.setValue('TO_WEEK', parseInt(parseInt(sFrLastweek) + parseInt('1')) + '000')
//                    }
//                } else {
//                    SalesPlanSearch.setValue('TO_WEEK', sToPlanWeek.substring(0, 4) +  integerWeek2)
//                }
//            } else if(SalesPlanSearch.getValue('TO_MONTH').length < 8) {
//
//            }
//        },
//        fnCheckPlanWeek: function(value, record, fieldName) {
//        	// FROM_MONTH & FROM_WEEK 계산
//            if(SalesPlanSearch.getValue('FROM_WEEK').length >= 8)    {
//                var sFrPlanWeek = SalesPlanSearch.getValue('FROM_WEEK');
//                var integerWeek = parseInt(Ext.Date.getWeekOfYear(SalesPlanSearch.getValue('FROM_MONTH2')));
//                if (integerWeek < 10) {
//                    	integerWeek = '0' + integerWeek
//                } else {
//                	integerWeek
//                }
//                var sFrLastweek = sFrPlanWeek.substring(0, 4) + '0' + parseInt(integerWeek + parseInt(gsFrWeekList[0].REF_CODE1) + parseInt(gsToWeekList[0].REF_CODE1));
//                var weekCal1 = '000' + integerWeek;
//                var integerWeek2 = parseInt(parseInt(weekCal1.substring(2, 6)) + parseInt(gsFrWeekList[0].REF_CODE1));
//                if(integerWeek2 < 10) {
//                	integerWeek2 = '00' + integerWeek2
//                } else {
//                	integerWeek2 = '0' + integerWeek2
//                }
//                if(sFrPlanWeek.substring(0, 4) +  integerWeek2 > parseInt(sFrLastweek)) {
//                	if(gsFrWeekList[0].REF_CODE1 == '0') {
//                		SalesPlanSearch.setValue('FROM_WEEK', parseInt(parseInt(sFrLastweek) + parseInt('1')) + '001')
//                	} else {
//                	   	SalesPlanSearch.setValue('FROM_WEEK', parseInt(parseInt(sFrLastweek) + parseInt('1')) + '000')
//                	}
//                } else {
//                	SalesPlanSearch.setValue('FROM_WEEK', sFrPlanWeek.substring(0, 4) +  integerWeek2)
//                }
//            } else if(SalesPlanSearch.getValue('FROM_WEEK').length == 7) {
//            	var sFrSysDate = UniDate.get('today');
//            	var sFrPlanWeek = SalesPlanSearch.getValue('FROM_WEEK');
//                var integerWeek = parseInt(Ext.Date.getWeekOfYear(SalesPlanSearch.getValue('FROM_MONTH2')));
//                if (integerWeek < 10) {
//                        integerWeek = '0' + integerWeek
//                } else {
//                    integerWeek
//                }
//            	var sFrLastweek = sFrPlanWeek.substring(0, 4) + '0' + parseInt(integerWeek + parseInt(gsFrWeekList[0].REF_CODE1) + parseInt(gsToWeekList[0].REF_CODE1));
//            	if(parseInt(parseInt(sFrPlanWeek) + parseInt(gsFrWeekList[0].REF_CODE1)) >= sFrLastweek) {
//            	   	SalesPlanSearch.setValue('FROM_MONTH', sFrSysDate.substring(0, 6))
//            	   	alert(Msg.fSbMsgS0062);
//            	   	if(gsFrWeekList[0].REF_CODE1 == '0') {
//            	   		SalesPlanSearch.setValue('FROM_WEEK', parseInt(sFrSysDate.substring(0, 4)) + parseInt('1') + '001')
//            	   	} else {
//            	   		SalesPlanSearch.setValue('FROM_WEEK', parseInt(sFrSysDate.substring(0, 4)) + parseInt('1') + '000')
//            	   	}
//            	} else if(gsFrWeekList[0].REF_CODE1 == '0' && UniDate.getDbDateStr(SalesPlanSearch.getValue('FROM_WEEK')).substring(5, 7) == '000') {
//            		alert(Msg.fSbMsgS0062);
//            		SalesPlanSearch.setValue('FROM_MONTH', sFrSysDate.substring(0, 6))
//            		SalesPlanSearch.setValue('FROM_WEEK', parseInt(sFrSysDate.substring(0, 4)) + parseInt('1') + '001')
//            	} else {
//            	   	var param = {
//            	   	   CAL_NO : parseInt(parseInt(SalesPlanSearch.getValue('FROM_WEEK')) - parseInt(gsFrWeekList[0].REF_CODE1)),
//                       CAL_DATE : parseInt(parseInt(SalesPlanSearch.getValue('FROM_WEEK')) - parseInt(gsFrWeekList[0].REF_CODE1))
//            	   	}
//            	   	s_ppl111ukrv_kdService.selectMonth(param, function(provider, response){
//                        if(Ext.isEmpty(provider)) {
//                            alert(Msg.sMB004);
//                        } else {
//                            SalesPlanSearch.setValue('FROM_MONTH', provider[0].CAL_MONTH)
//                        }
//                    });
//            	}
//            } else if(SalesPlanSearch.getValue('FROM_WEEK').length < 8 && SalesPlanSearch.getValue('FROM_WEEK').length != 7) {
//
//            } else {
//                var sFrSysDate = UniDate.get('today');
//                var integerWeek = parseInt(Ext.Date.getWeekOfYear(UniDate.get('today')));
//                if (integerWeek < 10) {
//                        integerWeek = '0' + integerWeek
//                } else {
//                    integerWeek
//                }
//                var sFrLastweek = parseInt(parseInt(sFrSysDate.substring(0, 4) + '0' + integerWeek) + parseInt(gsFrWeekList[0].REF_CODE1) + parseInt(gsToWeekList[0].REF_CODE1));
//                if(parseInt(sFrSysDate.substring(0, 4) + parseInt('000' + integerWeek).substring(3, 5) + parseInt(gsFrWeekList[0].REF_CODE1)) > parseInt(gsToWeekList[0].REF_CODE1)) {
//                	if(gsFrWeekList[0].REF_CODE1 == '0') {
//                        SalesPlanSearch.setValue('FROM_WEEK', parseInt(UniDate.getDbDateStr(sFrLastweek).substring(0, 4) + parseInt('1')) + '001')
//                    } else {
//                        SalesPlanSearch.setValue('FROM_WEEK', parseInt(UniDate.getDbDateStr(sFrLastweek).substring(0, 4) + parseInt('1')) + '000')
//                    }
//                } else {
//                    SalesPlanSearch.setValue('FROM_WEEK', parseInt(parseInt('000' + integerWeek).substring(3, 5) + parseInt(gsFrWeekList[0].REF_CODE1)))
//                }
//            }
//
//
//            // TO_MONTH & TO_WEEK 계산
//            if(SalesPlanSearch.getValue('TO_WEEK').length >= 8)    {
//                var sToPlanWeek = SalesPlanSearch.getValue('TO_WEEK');
//                var integerWeek = parseInt(Ext.Date.getWeekOfYear(SalesPlanSearch.getValue('TO_MONTH2')));
//                if (integerWeek < 10) {
//                        integerWeek = '0' + integerWeek
//                } else {
//                    integerWeek
//                }
//                var sToLastweek = sToPlanWeek.substring(0, 4) + '0' + parseInt(integerWeek + parseInt(gsFrWeekList[0].REF_CODE1) + parseInt(gsToWeekList[0].REF_CODE1));
//                var weekCal1 = '000' + integerWeek;
//                var integerWeek2 = parseInt(parseInt(weekCal1.substring(2, 6)) + parseInt(gsToWeekList[0].REF_CODE1));
//                if(integerWeek2 < 10) {
//                    integerWeek2 = '00' + integerWeek2
//                } else {
//                    integerWeek2 = '0' + integerWeek2
//                }
//                if(sToPlanWeek.substring(0, 4) +  integerWeek2 > parseInt(sToLastweek)) {
//                    if(gsFrWeekList[0].REF_CODE1 == '0') {
//                        SalesPlanSearch.setValue('TO_WEEK', parseInt(parseInt(sFrLastweek) + parseInt('1')) + '001')
//                    } else {
//                        SalesPlanSearch.setValue('TO_WEEK', parseInt(parseInt(sFrLastweek) + parseInt('1')) + '000')
//                    }
//                } else {
//                    SalesPlanSearch.setValue('TO_WEEK', sToPlanWeek.substring(0, 4) +  integerWeek2)
//                }
//            } else if(SalesPlanSearch.getValue('TO_WEEK').length == 7) {
//                var sToSysDate = UniDate.get('today');
//                var integerWeek = parseInt(Ext.Date.getWeekOfYear(SalesPlanSearch.getValue('TO_MONTH2')));
//                if (integerWeek < 10) {
//                        integerWeek = '0' + integerWeek
//                } else {
//                    integerWeek
//                }
//                var sToLastweek = SalesPlanSearch.getValue('TO_WEEK').substring(0, 4) + '0' + parseInt(integerWeek + parseInt(gsFrWeekList[0].REF_CODE1) + parseInt(gsToWeekList[0].REF_CODE1));
//                if(parseInt(parseInt(SalesPlanSearch.getValue('TO_WEEK')) + parseInt(gsFrWeekList[0].REF_CODE1)) >= sFrLastweek) {
//                    SalesPlanSearch.setValue('FROM_MONTH', sFrSysDate.substring(0, 6))
//                    alert(Msg.fsbMsgP0083);
//                    if(gsFrWeekList[0].REF_CODE1 == '0') {
//                        SalesPlanSearch.setValue('TO_WEEK', parseInt(sToSysDate.substring(0, 4)) + parseInt('1') + '001')
//                    } else {
//                        SalesPlanSearch.setValue('FROM_WEEK', parseInt(sToSysDate.substring(0, 4)) + parseInt('1') + '000')
//                    }
//                } else if(gsFrWeekList[0].REF_CODE1 == '0' && UniDate.getDbDateStr(SalesPlanSearch.getValue('TO_WEEK')).substring(5, 7) == '000') {
//                    alert(Msg.fsbMsgP0083);
//                    SalesPlanSearch.setValue('TO_MONTH', sToSysDate.substring(0, 6))
//                    SalesPlanSearch.setValue('TO_WEEK', parseInt(sToSysDate.substring(0, 4)) + parseInt('1') + '001')
//                } else {
//                    var param = {
//                       CAL_NO : parseInt(parseInt(SalesPlanSearch.getValue('TO_WEEK')) - parseInt(gsFrWeekList[0].REF_CODE1)),
//                       CAL_DATE : parseInt(parseInt(SalesPlanSearch.getValue('TO_WEEK')) - parseInt(gsFrWeekList[0].REF_CODE1))
//                    }
//                    s_ppl111ukrv_kdService.selectMonth(param, function(provider, response){
//                        if(Ext.isEmpty(provider)) {
//                            alert(Msg.sMB004);
//                        } else {
//                            SalesPlanSearch.setValue('TO_MONTH', provider[0].CAL_MONTH)
//                        }
//                    });
//                }
//            } else if(SalesPlanSearch.getValue('TO_WEEK').length < 8 && SalesPlanSearch.getValue('TO_WEEK').length != 7) {
//
//            } else {
//                var sToSysDate = UniDate.get('today');
//                var integerWeek = parseInt(Ext.Date.getWeekOfYear(UniDate.get('today')));
//                if (integerWeek < 10) {
//                        integerWeek = '0' + integerWeek
//                } else {
//                    integerWeek
//                }
//                var sToLastweek = parseInt(parseInt(sToSysDate.substring(0, 4) + '0' + integerWeek) + parseInt(gsFrWeekList[0].REF_CODE1) + parseInt(gsToWeekList[0].REF_CODE1));
//                if(parseInt(sToSysDate.substring(0, 4) + parseInt('000' + integerWeek).substring(3, 5) + parseInt(gsFrWeekList[0].REF_CODE1)) > parseInt(gsToWeekList[0].REF_CODE1)) {
//                    if(gsFrWeekList[0].REF_CODE1 == '0') {
//                        SalesPlanSearch.setValue('TO_WEEK', parseInt(UniDate.getDbDateStr(sToSysDate).substring(0, 4) + parseInt('1')) + '001')
//                    } else {
//                        SalesPlanSearch.setValue('FROM_WEEK', parseInt(UniDate.getDbDateStr(sToSysDate).substring(0, 4) + parseInt('1')) + '000')
//                    }
//                } else {
//                    SalesPlanSearch.setValue('TO_WEEK', UniDate.getDbDateStr(sToSysDate).substring(0, 4) + parseInt(parseInt('000' + integerWeek).substring(3, 5) + parseInt(gsFrWeekList[0].REF_CODE1)))
//                }
//            }
//        }


        /*,
        fnCheckNum: function(value, record, fieldName) {
            var r = true;
            if(record.get("PRICE_YN") == "1" || record.get("ACCOUNT_YNC")=="N") {
                r = true;
            } else if(record.get("PRICE_YN") == "2" )   {
                if(value < 0)   {
                    alert(Msg.sMB076);
                    r=false;
                    return r;
                }else if(value == 0)    {
                    if(fieldName == "ORDER_TAX_O")  {
                        if(BsaCodeInfo.gsVatRate != 0)  {
                            alert(Msg.sMB083);
                            r=false;
                        }
                    }else {
                        alert(Msg.sMB083);
                        r=false;
                    }
                }
            }
            return r;
        }*/
	});

    /**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store: masterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "WORK_SHOP_CODE" : //작업장
			}
			return rv;
		}
	}); // validator
}
</script>
