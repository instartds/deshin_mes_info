<%--
'   프로그램명 : 생산계획등록_수주참조 (생산)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ppl111ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ppl111ukrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="WU" />											<!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="P402" /> 						<!-- 참조유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B074" /> 						<!-- 양산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> 						<!-- 매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 						<!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />				<!-- 작업장 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />	<!-- 대분류 -->
   	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />	<!-- 중분류 -->
   	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	<!-- 소분류 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-change-cell3 {
background-color: #fcfac5;
}
</style>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<script type="text/javascript" >

var referOrderInformationWindow;		//수주정보참조
var referSalesPlanWindow;				//판매계획참조
var referItemInformationWindow;         //제품정보팝업
var photoWin;                           //이미지 보여줄 윈도우
var uploadWin;                          //인증서 업로드 윈도우
var fid = '';                           //인증서 ID
var gsNeedPhotoSave = false;
var detailWin;

var BsaCodeInfo = {
	gsManageTimeYN:'${gsManageTimeYN}'
};
//var output ='';
//for(var key in BsaCodeInfo){
//	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

var outDivCode = UserInfo.divCode;

function appMain() {

	var mrpYnStore = Unilite.createStore('ppl111ukrvMRPYnStore', {
		fields: ['text', 'value'],
		data :  [
			{'text':'<t:message code="system.label.product.yes" default="예"/>'		, 'value':'Y'},
			{'text':'<t:message code="system.label.product.no" default="아니오"/>'	, 'value':'N'}
			//ColIndex("MRP_YN"))  = sMBC02  |#Y;예|#N;아니오
			//공통코드 처리필요 MRP연계
		]
	});

	var isAutoTime = false;
	if(BsaCodeInfo.gsAutoType=='Y')	{
		isAutoTime = true;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl111ukrvService.selectDetailList',
			update	: 'ppl111ukrvService.updateDetail',
			create	: 'ppl111ukrvService.insertDetail',
			destroy	: 'ppl111ukrvService.deleteDetail',
			syncAll	: 'ppl111ukrvService.saveAll'
		}
	});

	/* 수주정보 참조 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl111ukrvService.selectEstiList',
			update	: 'ppl111ukrvService.updateEstiDetail',
			create	: 'ppl111ukrvService.insertEstiDetail',
			destroy	: 'ppl111ukrvService.deleteEstiDetail',
			syncAll	: 'ppl111ukrvService.saveRefAll'
		}
	});

	/* 생산계획 참조*/
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl111ukrvService.selectRefList',
			update	: 'ppl111ukrvService.updateRefDetail',
			create	: 'ppl111ukrvService.insertRefDetail',
			destroy	: 'ppl111ukrvService.deleteRefDetail',
			syncAll	: 'ppl111ukrvService.saveRefAll'
		}
	});

	//품목 정보 관련 파일 업로드
    var itemInfoProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read    : 'ppl111ukrvService.getItemInfo',
            update  : 'ppl111ukrvService.itemInfoUpdate',
            create  : 'ppl111ukrvService.itemInfoInsert',
            destroy : 'ppl111ukrvService.itemInfoDelete',
            syncAll : 'ppl111ukrvService.saveAll2'
        }
    });


	Unilite.defineModel('ppl111ukrvMasterModel', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string'},
			{name: 'DIV_CODE'	   	, text: '<t:message code="system.label.product.division" default="사업장"/>' 				, type: 'string'},
			{name: 'ORDER_TYPE'	 	, text: '<t:message code="system.label.product.classfication" default="구분"/>'				, type: 'string'},
			{name: 'PLAN_TYPE'	  	, text: '<t:message code="system.label.product.classfication" default="구분"/>' 				, type: 'string'},
			{name: 'ORDER_NUM'	  	, text: '<t:message code="system.label.product.sono" default="수주번호"/>' 				, type: 'string'},
			{name: 'SEQ'				, text: '<t:message code="system.label.product.seq" default="순번"/>'				, type: 'int'},
			{name: 'ITEM_CODE'	  	, text: '<t:message code="system.label.product.item" default="품목"/>' 				, type: 'string'},
			{name: 'ITEM_NAME'	  	, text: '<t:message code="system.label.product.itemname" default="품목명"/>' 				, type: 'string'},
			{name: 'SPEC'		   	, text: '<t:message code="system.label.product.spec" default="규격"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'	 	, text: '<t:message code="system.label.product.unit" default="단위"/>' 				, type: 'string'},
			{name: 'STOCK_Q'			, text: '<t:message code="system.label.product.onhandstock" default="현재고"/>'				, type: 'uniQty'},
			{name: 'ORDER_DATE'	 	, text: '<t:message code="system.label.product.sodate" default="수주일"/>' 				, type: 'uniDate'},
			{name: 'CUSTOM_CODE' 	, text: '<t:message code="system.label.product.custom" default="거래처"/>' 				, type: 'string'},
			{name: 'CUSTOM_NAME' 	, text: '<t:message code="system.label.product.customname" default="거래처명"/>' 				, type: 'string'},
			{name: 'DVRY_DATE'	  	, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>' 				, type: 'uniDate'},
			{name: 'PROD_END_DATE'  	, text: '<t:message code="system.label.product.productionfinishdate" default="생산완료일"/>'				, type: 'uniDate'},
			{name: 'ORDER_UNIT_Q'   	, text: '<t:message code="system.label.product.soqty" default="수주량"/>' 				, type: 'uniQty'},
			{name: 'PROD_Q'		 	, text: '<t:message code="system.label.product.productionrequestqty" default="생산요청량"/>' 			, type: 'uniQty'},
			{name: 'SUM_WK_PLAN_Q'  	, text: '<t:message code="system.label.product.planqty" default="계획량"/>'				, type: 'uniQty'},
			{name: 'PROJECT_NO'	 	, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>' 			, type: 'string'},
			{name: 'PJT_CODE'	   	, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'WK_PLAN_NUM'		, text: '<t:message code="system.label.product.productionplanno" default="생산계획번호"/>' 			, type: 'string'},
			{name: 'WORK_SHOP_CODE' 	, text: '<t:message code="system.label.product.workcenter" default="작업장"/>' 				, type: 'string'	, comboType: 'WU'},
			{name: 'PRODT_PLAN_DATE'	, text: '<t:message code="system.label.product.plandate" default="계획일"/>'				, type: 'uniDate'},
			{name: 'PRODT_PLAN_TIME'	, text: '<t:message code="system.label.product.plantime" default="계획시간"/>' 				, type: 'string'	, comboType: "AU"	, comboCode: "P504"},
			{name: 'WK_PLAN_Q'	  	, text: '<t:message code="system.label.product.planqty" default="계획량"/>' 				, type: 'uniQty'},
			{name: 'LOT_NO'	  	, text: 'LOT NO' 				, type: 'string'},
			{name: 'PRODT_END_DATE'	  	, text: '<t:message code="system.label.product.prodenddate" default="생산완료확정일"/>' 				, type: 'uniDate'},
			{name: 'REMARK'		 	, text: '<t:message code="system.label.product.remarks" default="비고"/>'				, type: 'string'},
			{name: 'MRP_YN'		 	, text: '<t:message code="system.label.product.mrpconnection" default="MRP연계"/>' 			, type: 'string'	, store: Ext.data.StoreManager.lookup('ppl111ukrvMRPYnStore')},
			{name: 'WKORD_NUM'	  	, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			, type: 'string'},
			{name: 'WKORD_Q'			, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>' 			, type: 'uniQty'},
			{name: 'PRODT_Q'			, text: '<t:message code="system.label.product.productionqty" default="생산량"/>' 				, type: 'uniQty'},
			{name: 'UPDATE_DB_USER' 	, text: 'UPDATE_DB_USER'	, type: 'string'},
			{name: 'UPDATE_DB_TIME' 	, text: 'UPDATE_DB_TIME' 	, type: 'string'},
			{name: 'CAPA_OVER_FLAG' 	, text: 'CAPA_OVER_FLAG' 	, type: 'string'},
			{name: 'DOC_YN' 					, text: 'DOC_YN' 				, type: 'string'},
			{name: 'WEEK_NUM' 				, text: 'WEEK_NUM' 			, type: 'string'}
		]
	});

	//마스터 스토어 정의
	var masterStore = Unilite.createStore('ppl111ukrvmasterStore', {
		model: 'ppl111ukrvMasterModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi : false,			// prev | next 버튼 사용
			allDeletable: true
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
				var grid = Ext.getCmp('ppl111ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});


	var masterForm = Unilite.createSearchPanel('ppl111ukrvMasterForm', {
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
				comboType:'BOR120',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
						masterForm.setValue('WORK_SHOP_CODE','');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.planperiod" default="계획기간"/>',
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
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
				//store: Ext.data.StoreManager.lookup('wsList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					},
                       beforequery:function( queryPlan, eOpts )   {
                           var store = queryPlan.combo.store;
                           var prStore = panelResult.getField('WORK_SHOP_CODE').store;
                           store.clearFilter();
                           prStore.clearFilter();
                           if(!Ext.isEmpty(masterForm.getValue('DIV_CODE'))){
                               store.filterBy(function(record){
                                   return record.get('option') == masterForm.getValue('DIV_CODE');
                               });
                               prStore.filterBy(function(record){
                                   return record.get('option') == masterForm.getValue('DIV_CODE');
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
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					validateBlank:false,
					autoPopup	 :false,
					valueFieldName:'ITEM_CODE',
					textFieldName:'ITEM_NAME',
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08.12 표준화 작업
									masterForm.setValue('ITEM_CODE', newValue);
									panelResult.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										masterForm.setValue('ITEM_NAME', '');
										panelResult.setValue('ITEM_NAME', '');
									}
						},
						onTextFieldChange: function(field, newValue, oldValue){		// 2021.08.12 표준화 작업
									masterForm.setValue('ITEM_NAME', newValue);
									panelResult.setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										masterForm.setValue('ITEM_CODE', '');
										panelResult.setValue('ITEM_CODE', '');
									}
						},
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
				fieldLabel: '<t:message code="system.label.product.productionplanno" default="생산계획번호"/>',
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
			  	 	fieldLabel:'<t:message code="system.label.product.sono" default="수주번호"/>',
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
				fieldLabel: '<t:message code="system.label.product.referencetype" default="참조유형"/>',
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
				fieldLabel: '<t:message code="system.label.product.productiontype" default="양산구분"/>',
				name:'ITEM_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B074',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
					panelResult.setValue('ITEM_TYPE', newValue);
					}
				}
   			}]
		},{
			title: '<t:message code="system.label.product.iteminfo" default="품목정보"/>',
   			itemId: 'search_panel2',
   			collapsed: false,
		   	layout: {type: 'uniTable', columns: 1},
		   	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.product.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'ITEM_LEVEL2'
			},{
				fieldLabel: '<t:message code="system.label.product.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'ITEM_LEVEL3'
			},{
				fieldLabel: '<t:message code="system.label.product.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store')
		},{
			fieldLabel: '<t:message code="system.label.product.temporaryfile" default="임시파일"/>',
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}

					   	Unilite.messageBox(labelText+Msg.sMB083);
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
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
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
						panelResult.setValue('WORK_SHOP_CODE','');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.planperiod" default="계획기간"/>',
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
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('WORK_SHOP_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var psStore = masterForm.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        psStore.clearFilter();
                        if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
                            });
                            psStore.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;
                            });
                            psStore.filterBy(function(record){
                                return false;
                            });
                        }
                    }
				}
			},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					validateBlank:false,
					valueFieldName:'ITEM_CODE',
					textFieldName:'ITEM_NAME',
					autoPopup: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08.12 표준화 작업
									masterForm.setValue('ITEM_CODE', newValue);
									panelResult.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										masterForm.setValue('ITEM_NAME', '');
										panelResult.setValue('ITEM_NAME', '');
									}
						},
						onTextFieldChange: function(field, newValue, oldValue){		// 2021.08.12 표준화 작업
									masterForm.setValue('ITEM_NAME', newValue);
									panelResult.setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										masterForm.setValue('ITEM_CODE', '');
										panelResult.setValue('ITEM_CODE', '');
									}
						},
						onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							masterForm.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
							masterForm.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
						},
						scope: this
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.product.productionplanno" default="생산계획번호"/>',
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
			  	 	fieldLabel:'<t:message code="system.label.product.sono" default="수주번호"/>',
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
				fieldLabel: '<t:message code="system.label.product.referencetype" default="참조유형"/>',
				name:'PLAN_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'P402',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						masterForm.setValue('PLAN_TYPE', newValue);
					}
				}
   			},{
				fieldLabel: '<t:message code="system.label.product.productiontype" default="양산구분"/>',
				name:'ITEM_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B074',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						masterForm.setValue('ITEM_TYPE', newValue);
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}

					   	Unilite.messageBox(labelText+Msg.sMB083);
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

	var masterGrid = Unilite.createGrid('ppl111ukrvGrid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
			expandLastColumn: true,
			useRowNumberer: false,
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			}
		},
		tbar: [{
			itemId: 'requestBtn',
			text: '<div style="color: blue"><t:message code="system.label.product.soinforeference" default="수주정보참조"/></div>',
			handler: function() {
				openOrderInformationWindow();
				}
		},'-', {
			itemId: 'refBtn',
			text: '<div style="color: blue"><t:message code="system.label.product.salesplanreference" default="판매계획참조"/></div>',
			handler: function() {
				openSalesPlanWindow();
				}
		}/*, {  프로세스 임시 제거
			xtype: 'splitbutton',
		   	itemId:'procTool',
			text: '<t:message code="system.label.product.processbutton" default="프로세스..."/>',  iconCls: 'icon-link',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'reqIssueLinkBtn',
					text: '월생산계획',
					handler: function() {
						}
				}]
			})
		}*/],
        features: [{
            id: 'masterGridSubTotal',
            ftype: 'uniGroupingsummary',
            showSummaryRow: false
        },{
            id: 'masterGridTotal',
            ftype: 'uniSummary',
            showSummaryRow: false
        }],
		store: masterStore,
		columns: [
			{ dataIndex: 'COMP_CODE'		 		, width: 20 , hidden: true},
			{ dataIndex: 'DIV_CODE'		  		, width: 20 , hidden: true},
			{ dataIndex: 'ORDER_TYPE'				, width: 80 },
				{ text : '<t:message code="system.label.product.soinfo" default="수주정보"/>' ,
					columns: [
						{ dataIndex: 'PLAN_TYPE'		 		, width: 20 , hidden: true},
						{ dataIndex: 'ORDER_NUM'		 		, width: 120},
						{ dataIndex: 'SEQ'			   			, width: 66	, align:'center'},
						{ dataIndex: 'ITEM_CODE'		 		, width: 100,
						editor: Unilite.popup('DIV_PUMOK_G', {
			 							textFieldName: 'ITEM_CODE',
			 							DBtextFieldName: 'ITEM_CODE',
			 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
				  						autoPopup: true,
										listeners: {'onSelected': {
														fn: function(records, type) {
																console.log('records : ', records);
																Ext.each(records, function(record,i) {
																					//console.log('record',record);
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
																	masterGrid.setItemData(null,true);
																}
										}
								})
						},
						{ dataIndex: 'ITEM_NAME'		 		, width: 150,
							editor: Unilite.popup('DIV_PUMOK_G', {
			 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
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
																	masterGrid.setItemData(null,true);
																}
															}
								})
						},
						{ dataIndex: 'SPEC'					, width: 93},
						{ dataIndex: 'STOCK_UNIT'			, width: 40},
						{ dataIndex: 'STOCK_Q'				, width: 100},
						{ dataIndex: 'ORDER_DATE'			, width: 80},
						{ dataIndex: 'CUSTOM_CODE'			, width: 80,	hidden: true},
			            { dataIndex: 'CUSTOM_NAME'			, width: 110},
						{ dataIndex: 'DVRY_DATE'			, width: 80},
						{ dataIndex: 'PROD_END_DATE'		, width: 80},
						{ dataIndex: 'ORDER_UNIT_Q'			, width: 66},
						{ dataIndex: 'PROD_Q'				, width: 66},
						{ dataIndex: 'SUM_WK_PLAN_Q'		, width: 66},
						{ dataIndex: 'PROJECT_NO'			, width: 100,
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
						}
						//,{ text:'제품정보' , dataIndex:'service', width: 128,
						,{
                            text: '제품정보',
                            width: 150,
                            xtype: 'widgetcolumn',
                            widget: {
                                xtype: 'button',
                                text: '제품정보 확인',
                                listeners: {
                                  buffer:1,
                                  click: function(button, event, eOpts) {
                                        var record = event.record.data;
                                        itemInfoStore.loadStoreRecords(record.ITEM_CODE);
                                        openItemInformationWindow();
                                  }
                                }
                            }
                        },{
                            text: '수주정보',
                            width: 150,
                            xtype: 'widgetcolumn',
                            widget: {
                                xtype: 'button',
                                text: '수주정보 확인',
                                listeners: {
                                  buffer:1,
                                  click: function(button, event, eOpts) {
                                  	    var record = event.record.data;
                                        openDetailWindow(record);
                                  }/* ,afterrender: function(chb) {
		       	                		   var rec = chb.getWidgetRecord();
		    	                		   if(rec.get('DOC_YN') == 'Y'){
		    									this.setText('<div style="color: red">수주정보 확인</div>');
		    	                		   }else{
		    	                			   this.setText('<div style="color: black">수주정보 확인</div>');
		    	                		   }
    	                		  } */
                                }
                            },
                            onWidgetAttach: function(column, widget, record) {
                            	widget.setText(record.get('DOC_YN') == 'Y'?'<div style="color: red">수주정보 확인</div>':'<div style="color: black">수주정보 확인</div>');
                            }
                        },
						{ dataIndex: 'PJT_CODE'		  		, width: 93, hidden: true,
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
				{ text : '<t:message code="system.label.product.planinfo" default="계획정보"/>' ,
					columns: [
						{ dataIndex: 'WK_PLAN_NUM'			, width: 120},
						{ dataIndex: 'WORK_SHOP_CODE'		, width: 93 ,tdCls:'x-change-cell3',
							listeners:{
								render:function(elm)
								 	{ elm.editor.on('beforequery',function(queryPlan, eOpts)  {
			                              var store = queryPlan.combo.store;
			                              var selRecord =  masterGrid.uniOpt.currentRecord;
			                             	 store.clearFilter();
				                              if(!Ext.isEmpty(selRecord.get('DIV_CODE'))){
				                                  store.filterBy(function(record){
				                                      return record.get('option') == selRecord.get('DIV_CODE');
				                                  });

				                              }else{
				                                  store.filterBy(function(record){
				                                      return false;
				                                  });
				                              }
		                           })
							}
	                      }},
						{ dataIndex: 'PRODT_PLAN_DATE'		, width: 80 ,tdCls:'x-change-cell3'},
						{ dataIndex: 'PRODT_PLAN_TIME'		, width: 66, hidden: isAutoTime},
						{ dataIndex: 'WK_PLAN_Q'			, width: 66 ,tdCls:'x-change-cell3'},
						{ dataIndex: 'LOT_NO'		, width: 120},
						{ dataIndex: 'PRODT_END_DATE'		, width: 100},
						{ dataIndex: 'REMARK'				, width: 100}
				]
			},
				{ text : '<t:message code="system.label.product.connectinfo" default="연계정보"/>' ,
					columns: [
						{ dataIndex: 'MRP_YN'				, width: 66},
						{ dataIndex: 'WKORD_NUM'			, width: 120},
						{ dataIndex: 'WKORD_Q'				, width: 100},
						{ dataIndex: 'PRODT_Q'				, width: 66}
				]
			},
			{ dataIndex: 'UPDATE_DB_USER'			, width: 100 , hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'			, width: 100 , hidden: true},
			{ dataIndex: 'CAPA_OVER_FLAG'			, width: 100 , hidden: true},
			{ dataIndex: 'DOC_YN'						, width: 50   , hidden: true},
			{ dataIndex: 'WEEK_NUM'					, width: 50   , hidden: true}
		],
		listeners: {
			/*afterrender: function(grid) {
					//useContextMenu:true 설정으로 툴바 우측 버튼은 자동 생성되며 그 외 추가할 메뉴  작성
					this.contextMenu.add(
						{
							xtype: 'menuseparator'
						},{
							text: '<t:message code="system.label.product.iteminfo" default="품목정보"/>',   iconCls : '',
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
										 'PROD_Q','SUM_WK_PLAN_Q', 'PROJECT_NO','PJT_CODE','CUSTOM_CODE','CUSTOM_NAME',
										 /* 계획정보 */
										 'WK_PLAN_NUM',
										 /* 연계정보 */
										 'MRP_YN','WKORD_NUM','WKORD_Q','PRODT_Q',
										 'UPDATE_DB_USER','UPDATE_DB_TIME','CAPA_OVER_FLAG','DOC_YN'
										 ]))
							return false;
				}

				else if(!e.record.phantom){
					if(e.record.data.WKORD_NUM == '' || e.record.data.MRP_YN == 'Y'){
						if (UniUtils.indexOf(e.field,
										['WORK_SHOP_CODE','PRODT_PLAN_DATE','PRODT_PLAN_TIME','WK_PLAN_Q','ITEM_CODE','REMARK','ITEM_NAME','DOC_YN','CUSTOM_CODE','CUSTOM_NAME']) )
							return false;
					}
				}


				else if(e.record.phantom){					/* 신규일 때 */
					if (UniUtils.indexOf(e.field,
										[/* 수주정보 */
										 'COMP_CODE','DIV_CODE','ORDER_TYPE','PLAN_TYPE','ORDER_NUM','SEQ',//'ITEM_NAME',
										 'SPEC','STOCK_UNIT','STOCK_Q','ORDER_DATE','DVRY_DATE','PROD_END_DATE','ORDER_UNIT_Q',
										 'PROD_Q','SUM_WK_PLAN_Q','CUSTOM_CODE','CUSTOM_NAME',
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
	   		var itemCode	= record.get('ITEM_CODE');
	   		var itemName	= record.get('ITEM_NAME');
	  		var orderNum	= record.get('ORDER_NUM');
	  		var wkPlanNum   = record.get('WK_PLAN_NUM');
	  		var seq   		= record.get('SEQ');
	  		var wkordNum	= record.get('WKORD_NUM');


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
		setItemData: function(record, dataClear,grdRecord) {
//	   		var grdRecord = masterGrid.uniOpt.currentRecord;
	   		if(dataClear) {
	   			grdRecord.set('ITEM_CODE'		,"");
	   			grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('STOCK_UNIT'		,"");
				grdRecord.set('OUTSTOCK_REQ_Q'  ,"");
				grdRecord.set('CONTROL_STATUS'  ,"");
				grdRecord.set('STOCK_Q'  ,"");
	   		} else {
	   			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
	   			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('ORDER_UNIT'			, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('OUTSTOCK_REQ_Q'		, "");
				grdRecord.set('CONTROL_STATUS'		, 2);
				grdRecord.set('STOCK_Q'   ,record['STOCK_Q']);
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
	//품목 정보 관련 파일업로드
    Unilite.defineModel('itemInfoModel', {
        fields: [
            {name: 'COMP_CODE'          ,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'           ,type: 'string'},
            {name: 'ITEM_CODE'          ,text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'          ,type: 'string'},
            //공통코드 생성 (B702 - 01:제품사진, 02:도면, 03:승인원)
            {name: 'FILE_TYPE'          ,text: '<t:message code="system.label.base.classfication" default="구분"/>'               ,type: 'string'     , allowBlank: false     , comboType: 'AU'   , comboCode: 'B702'},
            {name: 'MANAGE_NO'          ,text: '<t:message code="system.label.base.manageno" default="관리번호"/>'          ,type: 'string'     , allowBlank: false},
            {name: 'REMARK'             ,text: '<t:message code="system.label.base.remarks" default="비고"/>'             ,type: 'string'},
            {name: 'CERT_FILE'          ,text: '<t:message code="system.label.base.filename" default="파일명"/>'           ,type: 'string'},
            {name: 'FILE_ID'            ,text: '<t:message code="system.label.base.savedfilename" default="저장된 파일명"/>'      ,type: 'string'},
            {name: 'FILE_PATH'          ,text: '<t:message code="system.label.base.savedfilepath" default="저장된 파일경로"/>'     ,type: 'string'},
            {name: 'FILE_EXT'           ,text: '<t:message code="system.label.base.savedfileextension" default="저장된 파일확장자"/>'       ,type: 'string'}
        ]
    });
    var itemInfoStore = Unilite.createStore('itemInfoStore',{
        model   : 'itemInfoModel',
        autoLoad: false,
        uniOpt  : {
            isMaster    : false,        // 상위 버튼 연결
            editable    : true,         // 수정 모드 사용
            deletable   : true,         // 삭제 가능 여부
            useNavi     : false         // prev | next 버튼 사용
        },

        proxy: itemInfoProxy,

        loadStoreRecords : function(itemCOde){
            var param= Ext.getCmp('resultForm').getValues();
            param.ITEM_CODE = itemCOde

            console.log( param );
            this.load({
                params : param
            });
        },

        saveStore : function(config) {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);
            if(inValidRecs.length == 0 )     {
                config = {
                    success : function(batch, option) {
                        if(gsNeedPhotoSave){
                            fnPhotoSave();
                        }
                    }
                };
                this.syncAllDirect(config);
            }else {
                itemInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },

        listeners: {
            update:function( store, record, operation, modifiedFieldNames, eOpts ){
            },
            metachange:function( store, meta, eOpts ){
            }
        }

//        _onStoreUpdate: function (store, eOpt) {
//            console.log("Store data updated save btn enabled !");
//            this.setToolbarButtons('sub_save4', true);
//        }, // onStoreUpdate
//
//        _onStoreLoad: function ( store, records, successful, eOpts ) {
//            console.log("onStoreLoad");
//            if (records) {
//                this.setToolbarButtons('sub_save4', false);
//            }
//        },
//        _onStoreDataChanged: function( store, eOpts ) {
//            console.log("_onStoreDataChanged store.count() : ", store.count());
//            if(store.count() == 0){
//                this.setToolbarButtons(['sub_delete4'], false);
//                Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':false}});
//            }else {
//                if(this.uniOpt.deletable)   {
//                    this.setToolbarButtons(['sub_delete4'], true);
//                    Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':true}});
//                }
//            }
//            if(store.isDirty()) {
//                this.setToolbarButtons(['sub_save4'], true);
//            }else {
//                this.setToolbarButtons(['sub_save4'], false);
//            }
//        },

//        setToolbarButtons: function( btnName, state)     {
//            var toolbar = itemInfoGrid.getDockedItems('toolbar[dock="top"]');
//            var obj = toolbar[0].getComponent(btnName);
//            if(obj) {
//                (state) ? obj.enable():obj.disable();
//            }
//        }
    });
    var itemInfoGrid = Unilite.createGrid('itemInfoGrid', {
        store   : itemInfoStore,
        border  : true,
        height  : 180,
        width   : 865,
        padding : '0 0 5 0',
        sortableColumns : false,
        excelTitle: '<t:message code="system.label.base.referfile" default="관련파일"/>',
        uniOpt  :{
            onLoadSelectFirst   : false,
            expandLastColumn    : false,
            useRowNumberer      : true,
            useMultipleSorting  : false
//          enterKeyCreateRow: true                         //마스터 그리드 추가기능 삭제
        },
//        dockedItems : [{
//            xtype   : 'toolbar',
//            dock    : 'top',
//            items   : [{
//                xtype   : 'uniBaseButton',
//                text    : '<t:message code="system.label.base.inquiry" default="조회"/>',
//                tooltip : '<t:message code="system.label.base.inquiry" default="조회"/>',
//                iconCls : 'icon-query',
//                width   : 26,
//                height  : 26,
//                itemId  : 'sub_query4',
//                handler: function() {
//                    //if( me._needSave()) {
//                    var toolbar = itemInfoGrid.getDockedItems('toolbar[dock="top"]');
//                    var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
//                    var record  = masterGrid.getSelectedRecord();
//                    if (needSave) {
//                        Ext.Msg.show({
//                            title   : '<t:message code="system.label.base.confirm" default="확인"/>',
//                            msg     : Msg.sMB017 + "\n" + Msg.sMB061,
//                            buttons : Ext.Msg.YESNOCANCEL,
//                            icon    : Ext.Msg.QUESTION,
//                            fn      : function(res) {
//                                //console.log(res);
//                                if (res === 'yes' ) {
//                                    var saveTask =Ext.create('Ext.util.DelayedTask', function(){
//                                        itemInfoStore.saveStore();
//                                    });
//                                    saveTask.delay(500);
//                                } else if(res === 'no') {
//                                        itemInfoStore.loadStoreRecords(record.get('ITEM_CODE'));
//                                }
//                            }
//                        });
//                    } else {
//                        itemInfoStore.loadStoreRecords(record.get('ITEM_CODE'));
//                    }
//                }
//            },{
//                xtype   : 'uniBaseButton',
//                text    : '<t:message code="system.label.base.reset" default="신규"/>',
//                tooltip : '<t:message code="system.label.base.reset2" default="초기화"/>',
//                iconCls : 'icon-reset',
//                width   : 26,
//                height  : 26,
//                itemId  : 'sub_reset4',
//                handler: function() {
//                    var toolbar = itemInfoGrid.getDockedItems('toolbar[dock="top"]');
//                    var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
//                    if(needSave) {
//                            Ext.Msg.show({
//                                title:'<t:message code="system.label.base.confirm" default="확인"/>',
//                                msg: Msg.sMB017 + "\n" + Msg.sMB061,
//                                buttons: Ext.Msg.YESNOCANCEL,
//                                icon: Ext.Msg.QUESTION,
//                                fn: function(res) {
//                                    console.log(res);
//                                    if (res === 'yes' ) {
//                                            var saveTask =Ext.create('Ext.util.DelayedTask', function(){
//                                                itemInfoStore.saveStore();
//                                            });
//                                            saveTask.delay(500);
//                                    } else if(res === 'no') {
//                                            itemInfoGrid.reset();
//                                            itemInfoStore.clearData();
//                                            itemInfoStore.setToolbarButtons('sub_save4', false);
//                                            itemInfoStore.setToolbarButtons('sub_delete4', false);
//                                    }
//                                }
//                            });
//                    } else {
//                            itemInfoGrid.reset();
//                            itemInfoStore.clearData();
//                            itemInfoStore.setToolbarButtons('sub_save4', false);
//                            itemInfoStore.setToolbarButtons('sub_delete4', false);
//                    }
//                }
//            },{
//                xtype   : 'uniBaseButton',
//                text    : '<t:message code="system.label.base.add" default="추가"/>',
//                tooltip : '<t:message code="system.label.base.add" default="추가"/>',
//                iconCls : 'icon-new',
//                width   : 26,
//                height  : 26,
//                itemId  : 'sub_newData4',
//                handler: function() {
//                    var record      = masterGrid.getSelectedRecord();
//                    var compCode    = UserInfo.compCode;
//                    var itemCode    = record.get('ITEM_CODE');
//                    var r = {
//                        COMP_CODE       :   compCode,
//                        ITEM_CODE       :   itemCode
//                    };
//                    itemInfoGrid.createRow(r);
//                }
//            },{
//                xtype       : 'uniBaseButton',
//                text        : '<t:message code="system.label.base.delete" default="삭제"/>',
//                tooltip     : '<t:message code="system.label.base.delete" default="삭제"/>',
//                iconCls     : 'icon-delete',
//                disabled    : true,
//                width       : 26,
//                height      : 26,
//                itemId      : 'sub_delete4',
//                handler : function() {
//                    var selRow = itemInfoGrid.getSelectedRecord();
//                    if(!Ext.isEmpty(selRow)) {
//                        if(selRow.phantom === true) {
//                            itemInfoGrid.deleteSelectedRow();
//                        }else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
//                            itemInfoGrid.deleteSelectedRow();
//                        }
//                    } else {
//                        alert(Msg.sMA0256);
//                        return false;
//                    }
//                }
//            },{
//                xtype       : 'uniBaseButton',
//                text        : '<t:message code="system.label.base.save" default="저장 "/>',
//                tooltip     : '<t:message code="system.label.base.save" default="저장 "/>',
//                iconCls     : 'icon-save',
//                disabled    : true,
//                width       : 26,
//                height      : 26,
//                itemId      : 'sub_save4',
//                handler : function() {
//                    var inValidRecs = itemInfoStore.getInvalidRecords();
//                    if(inValidRecs.length == 0 )     {
//                        var saveTask =Ext.create('Ext.util.DelayedTask', function(){
//                            itemInfoStore.saveStore();
//                        });
//                        saveTask.delay(500);
//                    } else {
//                        itemInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
//                    }
//                }
//            }]
//        }],

        columns:[
                { dataIndex : 'COMP_CODE'           , width: 80     ,hidden:true},
                { dataIndex : 'ITEM_CODE'           , width: 80     ,hidden:true},
                { dataIndex : 'FILE_TYPE'           , width: 100 },
                { dataIndex : 'MANAGE_NO'           , width: 150},
                { text      : '<t:message code="system.label.base.photo" default="사진"/>',
                    columns:[
                        { dataIndex : 'CERT_FILE'   , width: 230        , align: 'center'   ,
                            renderer: function (val, meta, record) {
                                if (!Ext.isEmpty(record.data.CERT_FILE)) {
                                    return '<font color = "blue" >' + val + '</font>';

                                } else {
                                    return '';
                                }
                            }
                        }
                    ]
                },
                { dataIndex : 'REMARK'              , flex: 1   , minWidth: 30}/*,
                {
                  text      : '등록 버튼으로 구현 한 것',
                  align : 'center',
                  width : 50,
                  renderer  : function(value, meta, record) {
                        var id = Ext.id();
                        Ext.defer(function(){
                            new Ext.Button({
                                text    : '등록',
                                margin  : '-2 0 2 0',
                                handler : function(btn, e) {
                                    itemInfoGrid.getSelectionModel().select(record);
                                    openUploadWindow();
                                }
                            }).render(document.body, id);
                        },50);
                        return Ext.String.format('<div id="{0}"></div>', id);
                    }
                }*/
        ],

        listeners: {
            beforeedit: function( editor, e, eOpts ) {
                if(!e.record.phantom) {                 //
                    if (UniUtils.indexOf(e.field, ['FILE_TYPE', 'MANAGE_NO', 'CERT_FILE'])){
                        return false;
                    }

                } else {
                    if (UniUtils.indexOf(e.field, ['CERT_FILE'])){
                        return false;
                    }
                }
            },
            select: function(grid, selectRecord, index, rowIndex, eOpts ){
            },
            cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
                if(cellIndex == 5 && !Ext.isEmpty(record.get('CERT_FILE'))) {
                    fid = record.data.FILE_ID
                    var fileExtension   = record.get('CERT_FILE').lastIndexOf( "." );
                    var fileExt         = record.get('CERT_FILE').substring( fileExtension + 1 );

                    if(fileExt == 'pdf') {
                        var win = Ext.create('widget.CrystalReport', {
                            url     : CPATH+'/fileman/downloadItemInfoImage/' + fid,
                            prgID   : 'ppl111ukrv'
                        });
                        win.center();
                        win.show();

                    } else {
                        openPhotoWindow();
                    }
                }
            }
        }
    });
    //미리보기 관련 윈도우
    function openPhotoWindow() {
        photoWin = Ext.create('widget.uniDetailWindow', {
            title       : '<t:message code="system.label.base.preview" default="미리보기"/>',
            modal       : true,
            resizable   : true,
            closable    : false,
            width       : '80%',
            height      : '100%',
            layout      : {
                type    : 'fit'
            },
            closeAction : 'destroy',
            items       : [{
                xtype       : 'uniDetailForm',
                itemId      : 'downForm',
                url         : CPATH + "/fileman/downloadItemInfoImage/" + fid,
                layout      : {type: 'uniTable', columns:'1'},
                standardSubmit: true,
                disabled    : false,
                autoScroll  : true,
                items       : [{
                    xtype   : 'image',
                    itemId  : 'photView',
                    autoEl  : {
                        tag: 'img',
                        src: CPATH+'/resources/images/human/noPhoto.png'
                    }
                }]
            }],
            listeners : {
                beforeshow: function( window, eOpts)    {
                    window.down('#photView').setSrc(CPATH+'/fileman/downloadItemInfoImage/' + fid);
                },
                show: function( window, eOpts)  {
                    window.center();
                }
            },
            tbar:['->',{
                xtype   : 'button',
                text    : '<t:message code="system.label.base.download" default="다운로드"/>',
                handler : function() {
                    photoWin.down('#downForm').submit({
                        success:function(comp, action)  {
                            Ext.getBody().unmask();
                        },
                        failure: function(form, action){
                            Ext.getBody().unmask();
                        }
                    });
                }
            },{
                xtype   : 'button',
                text    : '<t:message code="system.label.base.close" default="닫기"/>',
                handler : function()    {
                    photoWin.down('#downForm').clearForm();
                    photoWin.close();
                    photoWin.hide();
                }
            }]
        });
        photoWin.show();
    }
    var photoForm = Ext.create('Unilite.com.form.UniDetailForm',{
        xtype       : 'uniDetailForm',
        disabled    : false,
        fileUpload  : true,
        itemId      : 'photoForm',
        api         : {
            submit  : bpr300ukrvService.photoUploadFile
        },
        items       : [{
                xtype       : 'filefield',
                buttonOnly  : false,
                fieldLabel  : '<t:message code="system.label.base.photo" default="사진"/>',
                flex        : 1,
                name        : 'photoFile',
                id          : 'photoFile',
                buttonText  : '<t:message code="system.label.base.selectfile" default="파일선택"/>',
                width       : 270,
                labelWidth  : 70
            }
        ]
    });
    function fnPhotoSave() {                //이미지 등록
        //조건에 맞는 내용은 적용 되는 로직
        var record      = itemInfoGrid.getSelectedRecord();
        var photoForm   = uploadWin.down('#photoForm').getForm();
        var param       = {
            ITEM_CODE   : record.data.ITEM_CODE,
            MANAGE_NO   : record.data.MANAGE_NO,
            FILE_TYPE   : record.data.FILE_TYPE
        }

        photoForm.submit({
            params  : param,
            waitMsg : 'Uploading your files...',
            success : function(form, action)    {
                uploadWin.afterSuccess();
                gsNeedPhotoSave = false;
            }
        });
    }
    function openUploadWindow() {
        if(!uploadWin) {
            uploadWin = Ext.create('Ext.window.Window', {
                title       : '<t:message code="system.label.base.uploadphoto" default="사진등록"/>',
                closable    : false,
                closeAction : 'hide',
                modal       : true,
                resizable   : true,
                width       : 300,
                height      : 100,
                layout      : {
                    type    : 'fit'
                },
                items       : [
                    photoForm,
                    {
                        xtype       : 'uniDetailForm',
                        itemId      : 'photoForm',
                        disabled    : false,
                        fileUpload  : true,
                        api         : {
                            submit: bpr300ukrvService.photoUploadFile
                        },
                        items       :[{
                            xtype       : 'filefield',
                            fieldLabel  : '<t:message code="system.label.base.photo" default="사진"/>',
                            name        : 'photoFile',
                            buttonText  : '<t:message code="system.label.base.selectfile" default="파일선택"/>',
                            buttonOnly  : false,
                            labelWidth  : 70,
                            flex        : 1,
                            width       : 270
                        }]
                    }
                ],
                listeners : {
                    beforeshow: function( window, eOpts)    {
                        var toolbar = itemInfoGrid.getDockedItems('toolbar[dock="top"]');
                        var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
                        var record  = itemInfoGrid.getSelectedRecord();

                        if (needSave) {
                            if(Ext.isEmpty(record.data.FILE_TYPE) || Ext.isEmpty(record.data.MANAGE_NO)){
                                Unilite.messageBox('<t:message code="system.message.human.message002" default="필수입력사항을 입력하신 후 사진을 올려주세요."/>');
                                return false;
                            }
                        } else {
                            if (Ext.isEmpty(record)) {
                                Unilite.messageBox('<t:message code="system.message.base.message004" default="품목 관련 정보를 입력하신 후, 사진을 업로드 하시기 바랍니다."/>');
                                return false;
                            }
                        }
                    },
                    show: function( window, eOpts)  {
                        window.center();
                    }
                },
                afterSuccess: function()    {
                    var record  = masterGrid.getSelectedRecord();
                    itemInfoStore.loadStoreRecords(record.get('ITEM_CODE'));
                    this.afterSavePhoto();
                },
                afterSavePhoto: function()  {
                    var photoForm = uploadWin.down('#photoForm');
                    photoForm.clearForm();
                    uploadWin.hide();
                },
                tbar:['->',{
                    xtype   : 'button',
                    text    : '<t:message code="system.label.base.upload" default="올리기"/>',
                    handler : function()    {
                        var photoForm   = uploadWin.down('#photoForm');
                        var toolbar     = itemInfoGrid.getDockedItems('toolbar[dock="top"]');
                        var needSave    = !toolbar[0].getComponent('sub_save4').isDisabled();

                        if (Ext.isEmpty(photoForm.getValue('photoFile'))) {
                            Unilite.messageBox('<t:message code="system.message.base.message002" default="업로드 할 파일을 선택하십시오."/>');
                            return false;
                        }

                        //jpg파일만 등록 가능
                        var filePath        = photoForm.getValue('photoFile');
                        var fileExtension   = filePath.lastIndexOf( "." );
                        var fileExt         = filePath.substring( fileExtension + 1 );

                        if(fileExt != 'jpg' && fileExt != 'png' && fileExt != 'bmp' && fileExt != 'pdf') {
                            Unilite.messageBox('<t:message code="system.message.base.message001" default="이미지 파일(jpg, png, bmp) 또는 pdf파일만 업로드 할 수 있습니다."/>');
                            return false;
                        }


                        if(needSave)    {
                            gsNeedPhotoSave = needSave;
                            itemInfoStore.saveStore();

                        } else {
                            fnPhotoSave();
                        }
                    }
                },{
                    xtype   : 'button',
                    text    : '<t:message code="system.label.base.close" default="닫기"/>',
                    handler : function()    {
//                      var photoForm = uploadWin.down('#photoForm').getForm();
//                      if(photoForm.isDirty()) {
//                          if(confirm('사진이 변경되었습니다. 저장하시겠습니까?'))   {
//                              var config = {
//                                  success : function()    {
//                                      // TODO: fix it!!!
//                                      uploadWin.afterSavePhoto();
//                                  }
//                              }
//                              UniAppManager.app.onSaveDataButtonDown(config);
//
//                          }else{
                                // TODO: fix it!!!
                                uploadWin.afterSavePhoto();
//                          }
//
//                      } else {
                            uploadWin.hide();
//                      }
                    }
                }]
            });
        }
        uploadWin.show();
    }
    //제품정보 메인
    function openItemInformationWindow() {
        if(!UniAppManager.app.checkForNewDetail()) return false;

        if(!referItemInformationWindow) {
            referItemInformationWindow = Ext.create('widget.uniDetailWindow', {
                title: '제품정보 확인',
                width: 1200,
                height: 580,
                layout:{type:'vbox', align:'stretch'},
                items: [itemInfoGrid],
                tbar:  ['->',{
                              itemId : 'closeBtn',
                              id:'closeBtn2',
                              text: '<t:message code="system.label.product.close" default="닫기"/>',
                              handler: function() {
                                     referItemInformationWindow.hide();
                                  },
                                  disabled: false
                              }
                       ]
                })
        }
        referItemInformationWindow.show();
        referItemInformationWindow.center();
    }
    var detailForm = Unilite.createForm('ppl111ukrvDetail', {
        autoScroll:true,
        layout : 'fit',
        layout: {type: 'uniTable', columns: 4,tdAttrs: {valign:'top'}},
        defaults:{labelWidth:60},
        disabled:false,
        items :[{
                    xtype:'xuploadpanel',
                    id : 'ppl111ukrvFileUploadPanel',
                    itemId:'fileUploadPanel',
                    flex:1,
                    width: 975,
                    height:300,
                    listeners : {
                    }
                }
         ]
                 ,loadForm: function(record)    {
                    // window 오픈시 form에 Data load
                    this.reset();
//                    this.setActiveRecord(record || null);
                    this.resetDirtyStatus();

                    //첨부파일
                    var fp = Ext.getCmp('ppl111ukrvFileUploadPanel');
                    var ordernum = record.ORDER_NUM;
                    if(!Ext.isEmpty(ordernum)) {
                    	ppl111ukrvService.getFileList({DOC_NO : ordernum},
                                                            function(provider, response) {
                                                                fp.loadData(response.result.data);
                                                            }
                                                         )
                    }else {
                        fp.clear(); //  fp.loadData() 실행 시 데이타 삭제됨.
                    }
                }
    });  // detailForm


        function openDetailWindow(record) {
        	detailForm.loadForm(record);
            if(!detailWin) {
                detailWin = Ext.create('widget.uniDetailWindow', {
                    title: '수주정보',
                    width: 1000,
                    height: 370,
                    isNew: false,
                    x:0,
                    y:0,
                    layout:{type:'vbox', align:'stretch'},
                    items: [detailForm],
                    tbar:  ['->',
//                    	{   itemId : 'confirmBtn',
//                                            text: '문서저장',
//                                            handler: function() {
//                                                var ordernum = panelResult.getValue('ORDER_NUM');
//                                                var fp = Ext.getCmp('sof100ukrvFileUploadPanel');
//                                                var addFiles = fp.getAddFiles();
//                                                console.log("addFiles : " , addFiles.length)
//
//                                                if(addFiles.length > 0) {
//                                                    detailSearch.setValue('ADD_FIDS', addFiles );
//                                                } else {
//                                                    detailSearch.setValue('ADD_FIDS', '' );
//                                                }
//                                                var param = {
//                                                    DOC_NO : ordernum,
//                                                    ADD_FIDS : detailSearch.getValue('ADD_FIDS')
//                                                }
//                                                sof100ukrvService.insertSOF102(param , function(provider, response){})
//                                            },
//                                            disabled: false
//                                        },
//                                        {   itemId : 'confirmCloseBtn',
//                                            text: '문저저장 후 닫기',
//                                            handler: function() {
//                                                var ordernum = panelResult.getValue('ORDER_NUM');
//                                                var fp = Ext.getCmp('sof100ukrvFileUploadPanel');
//                                                var addFiles = fp.getAddFiles();
//                                                console.log("addFiles : " , addFiles.length)
//
//                                                if(addFiles.length > 0) {
//                                                    detailSearch.setValue('ADD_FIDS', addFiles );
//                                                } else {
//                                                    detailSearch.setValue('ADD_FIDS', '' );
//                                                }
//                                                var param = {
//                                                    DOC_NO : ordernum,
//                                                    ADD_FIDS : detailSearch.getValue('ADD_FIDS')
//                                                }
//                                                sof100ukrvService.insertSOF102(param , function(provider, response){})
//
//                                                detailWin.hide();
//                                            },
//                                            disabled: false
//                                        },{   itemId : 'DeleteBtn',
//                                            text: '삭제',
//                                            handler: function() {
//                                                var fp = Ext.getCmp('sof100ukrvFileUploadPanel');
//                                                var delFiles = fp.getRemoveFiles();
//                                                if(delFiles.length > 0) {
//                                                   detailSearch.setValue('DEL_FIDS', delFiles );
//                                                } else {
//                                                   detailSearch.setValue('DEL_FIDS', '' );
//                                                }
//                                                if(!Ext.isEmpty(detailSearch.getValue('DEL_FIDS'))){
//                                                    if(confirm('문서를 삭제 하시겠습니까?')) {
//                                                        var param = {
//                                                            DEL_FIDS : detailSearch.getValue('DEL_FIDS')
//                                                        }
//                                                        sof100ukrvService.deleteSOF102(param , function(provider, response){})
//                                                    }
//                                                }else{
//                                                    alert('삭제할 문서가 없습니다.');
//                                                    return false;
//                                                }
//                                            },
//                                            disabled: false
//                                        },
                                        {
                                            itemId : 'closeBtn',
                                            text: '<t:message code="system.label.sales.close" default="닫기"/>',
                                            handler: function() {
                                                detailWin.hide();
                                            },
                                            disabled: false
                                        }
                                ],
                    listeners : {
                                 show:function( window, eOpts)  {
                                    detailForm.body.el.scrollTo('top',0);
                                 }
                    }
                })
            }

            detailWin.show();
            detailWin.center();

    }
	//수주참조 참조 메인
	function openOrderInformationWindow() {
  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		OrderSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
		OrderSearch.setValue('PROD_END_DATE_FR', masterForm.getValue('PRODT_PLAN_DATE_FR'));
  		OrderSearch.setValue('PROD_END_DATE_TO', masterForm.getValue('PRODT_PLAN_DATE_TO'));


		if(!referOrderInformationWindow) {
			referOrderInformationWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.product.soinforeference" default="수주정보참조"/>',
				width: 1200,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [OrderSearch, OrderGrid],
				tbar:  ['->',
										{	itemId : 'saveBtn',
											id:'saveBtn1',
											text: '<t:message code="system.label.product.inquiry" default="조회"/>',
											handler: function() {
												OrderStore.loadStoreRecords();
											},
											disabled: false
										},
										{	itemId : 'confirmBtn',
											id:'confirmBtn1',
											text: '<t:message code="system.label.product.productionplancalcu" default="생산계획계산"/>',
											handler: function() { /////
												masterForm.setValue('COM',"적용");
												OrderStore.saveStore();  /* 저장된 후 조회 */
											},
											disabled: false
										},
										{	itemId : 'confirmCloseBtn',
											id:'confirmCloseBtn1',
											text: '<t:message code="system.label.product.productionplancalcuapplyclose" default="생산계획계산적용후 닫기"/>',
											handler: function() {
												masterForm.setValue('COM',"적용후닫기");
												masterForm.setValue('PRODT_PLAN_DATE_FR',OrderSearch.getValue('PROD_END_DATE_FR'));
                                                masterForm.setValue('PRODT_PLAN_DATE_TO',OrderSearch.getValue('PROD_END_DATE_TO'));
												panelResult.setValue('PRODT_PLAN_DATE_FR',OrderSearch.getValue('PROD_END_DATE_FR'));
												panelResult.setValue('PRODT_PLAN_DATE_TO',OrderSearch.getValue('PROD_END_DATE_TO'));
												OrderStore.saveStore();
												referOrderInformationWindow.hide();
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											id:'closeBtn1',
											text: '<t:message code="system.label.product.close" default="닫기"/>',
											handler: function() {
												masterStore.saveStore();
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
	Unilite.defineModel('ppl111ukrvOrderModel', {
		fields: [
			{name: 'GUBUN'		 		, text: '<t:message code="system.label.product.selection" default="선택"/>'					 , type: 'string'},
			{name: 'PLAN_TYPE'	 		, text: '<t:message code="system.label.product.typecode" default="유형코드"/>' 				 , type: 'string'},
			{name: 'PLANTYPE_NAME' 		, text: '<t:message code="system.label.product.type" default="유형"/>'					 , type: 'string'},
			{name: 'ITEM_CODE'	 		, text: '<t:message code="system.label.product.item" default="품목"/>' 				 , type: 'string'},
			{name: 'ITEM_NAME'	 		, text: '<t:message code="system.label.product.itemname" default="품목명"/>' 					 , type: 'string'},
			{name: 'SPEC'		  		, text: '<t:message code="system.label.product.spec" default="규격"/>'					 , type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>' 					 , type: 'string'},
			{name: 'PROD_Q'				, text: '<t:message code="system.label.product.productionrequestqty" default="생산요청량"/>' 			 , type: 'uniQty'},
			{name: 'NOTREF_Q'	  		, text: '<t:message code="system.label.product.noplanqty" default="미계획량"/>'				 , type: 'uniQty'},
			{name: 'PROD_END_DATE' 		, text: '<t:message code="system.label.product.productionrequestdate" default="생산요청일"/>' 			 , type: 'uniDate'},
			{name: 'DVRY_DATE'	 		, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'				 , type: 'uniDate'},
			{name: 'ORDER_DATE'			, text: '<t:message code="system.label.product.sodate" default="수주일"/>' 				 , type: 'uniDate'},
			{name: 'ORDER_Q'	   		, text: '<t:message code="system.label.product.soqty" default="수주량"/>' 				 , type: 'uniQty'},
			{name: 'CUSTOM_NAME'   		, text: '<t:message code="system.label.product.custom" default="거래처"/>'				 , type: 'string'},
			{name: 'SER_NO'				, text: '<t:message code="system.label.product.soseq" default="수주순번"/>'				 , type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>' 				 , type: 'string' , comboType: 'WU'},
			{name: 'ORDER_NUM'	 		, text: '<t:message code="system.label.product.sono" default="수주번호"/>' 				 , type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				 , type: 'string'},
			{name: 'PJT_CODE'	  		, text: '<t:message code="system.label.product.projectcode" default="프로젝트코드"/>' 			 , type: 'string'},
			{name: 'USER_NAME'			, text: '등록자'				 , type: 'string'},
			{name: 'INSERT_DB_TIME'	    , text: '등록일시' 			 , type: 'string'},
			/* 파라미터 */
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'				 , type: 'string'},
			{name: 'PAD_STOCK_YN'	  	, text: '<t:message code="system.label.product.availableinventoryapplyyn" default="가용재고 반영여부"/>' 	 , type: 'string'},
			{name: 'CHECK_YN'	  		, text: '그리드선택 여부' 		 , type: 'string'}  // 선택 했을때 체크하는 값 (그리드 데이터랑 관련없음)

		]
	});

	//수주정보 참조 스토어 정의
	var OrderStore = Unilite.createStore('ppl111ukrvOrderStore', {
		model: 'ppl111ukrvOrderModel',
			autoLoad: false,
			uniOpt : {
				isMaster: true,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false			// prev | next 버튼 사용
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
				var grid = Ext.getCmp('ppl111ukrvOrderGrid');
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
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120'
			}, {
				fieldLabel: '<t:message code="system.label.product.productionrequestdate" default="생산요청일"/>',
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
						boxLabel:'<t:message code="system.label.product.whole" default="전체"/>',
						name:'PLAN_TYPE',
						inputValue:'',
						checked:true,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								OrderStore.loadStoreRecords();
							}
						}
					},{
						boxLabel:'<t:message code="system.label.product.salesorder" default="수주"/>',
						name:'PLAN_TYPE',
						inputValue:'S',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								OrderStore.loadStoreRecords();
							}
						}
					},{
						boxLabel:'<t:message code="system.label.product.tradeso" default="무역S/O"/>',
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
				 fieldLabel: '<t:message code="system.label.product.sono" default="수주번호"/>',
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
				 fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
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
						fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
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
						fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
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
				fieldLabel: '<t:message code="system.label.product.sentence001" default="※ 생산계획계산시 가용재고(현재고+입고예정-출고예정-안전재고)반영여부"/>',
				xtype: 'uniRadiogroup',
				labelWidth:420,
				//width: 235,
				colspan:2,
				name:'PAD_STOCK_YN',
				id:'padStockYn',
				items: [{
						boxLabel:'<t:message code="system.label.product.yes" default="예"/>',
						width:70,
						name:'PAD_STOCK_YN',
						inputValue:'Y'
					},{
						boxLabel:'<t:message code="system.label.product.no" default="아니오"/>',
						width:70,
						name:'PAD_STOCK_YN',
						inputValue:'N' ,
						checked:true
				}]
		}, {
				fieldLabel: '비고',
				//labelWidth: 60,
				width:325,
				name: 'REMARK',
				xtype: 'uniTextfield',
				allowBlank: true,
				margin:'0 0 0 -98'
		}]

	});


	/* 수주정보 그리드 */
	 var OrderGrid = Unilite.createGrid('ppl111ukrvOrderGrid', {
		layout : 'fit',
		store: OrderStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
			uniOpt:{
				onLoadSelectFirst : false
			},
		columns: [
			{ dataIndex: 'GUBUN'					, width: 40,  hidden: true},
			{ dataIndex: 'CHECK_YN'					, width: 40 , hidden: true},
			{ dataIndex: 'PLAN_TYPE'				, width: 40 , hidden: true},
			{ dataIndex: 'PLANTYPE_NAME'			, width: 80},
			{ dataIndex: 'ITEM_CODE'				, width: 120},
			{ dataIndex: 'ITEM_NAME'				, width: 140},
			{ dataIndex: 'SPEC'			 		    , width: 126},
			{ dataIndex: 'STOCK_UNIT'	   		    , width: 44},
			{ dataIndex: 'CUSTOM_NAME'              , width: 120},
		    { dataIndex: 'ORDER_NUM'                , width: 100},
		    { dataIndex: 'PROD_Q'		   		    , width: 120},
			{ dataIndex: 'NOTREF_Q'		 		    , width: 80 ,tdCls:'x-change-cell3'},
			{ dataIndex: 'PROD_END_DATE'			, width: 80},
			{ dataIndex: 'DVRY_DATE'				, width: 80},
			{ dataIndex: 'ORDER_DATE'	   		    , width: 80},
			{ dataIndex: 'ORDER_Q'		  		    , width: 66},
			{ dataIndex: 'SER_NO'		   		    , width: 100  , hidden: true},
			{ dataIndex: 'WORK_SHOP_CODE'   		, width: 100  , hidden: true},
			{ dataIndex: 'PROJECT_NO'	   		    , width: 100 , hidden: true},
			{ dataIndex: 'PJT_CODE'		 		    , width: 100 , hidden: true},
			{ dataIndex: 'USER_NAME'	   		    , width: 80 },
			{ dataIndex: 'INSERT_DB_TIME'		 	, width: 120}
			],
		listeners: {
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
		SalesPlanSearch.setValue('PROD_END_DATE_FR', UniDate.get('startOfMonth', masterForm.getValue('PRODT_PLAN_DATE_FR')));
  		SalesPlanSearch.setValue('PROD_END_DATE_TO',masterForm.getValue('PRODT_PLAN_DATE_FR'));

		if(!referSalesPlanWindow) {
			referSalesPlanWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.product.salesplanreference" default="판매계획참조"/>',
				width: 1200,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [SalesPlanSearch, SalesPlanGrid],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.product.inquiry" default="조회"/>',
						handler: function() {
							SalesPlanStore.loadStoreRecords();
						},
						disabled: false
					},
					{	itemId : 'confirmBtn',
						id:'confirmBtn2',
						text: '<t:message code="system.label.product.productionplancalcu" default="생산계획계산"/>',
						handler: function() {
							masterForm.setValue('COM',"적용");
							SalesPlanStore.saveStore();
						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						id:'confirmCloseBtn2',
						text: '<t:message code="system.label.product.productionplancalcuapplyclose" default="생산계획계산적용후 닫기"/>',
						handler: function() {
							masterForm.setValue('COM',"적용후닫기");
							SalesPlanStore.saveStore();
							referSalesPlanWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							masterStore.saveStore();
							referSalesPlanWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
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
	Unilite.defineModel('ppl111ukrvSalesPlanModel', {
		fields: [
			{name: 'GUBUN'				, text: '<t:message code="system.label.product.selection" default="선택"/>'		, type: 'string'},
			{name: 'PLAN_TYPE'			, text: '<t:message code="system.label.product.typecode" default="유형코드"/>'		, type: 'string'},
			{name: 'PLANTYPE_NAME'		, text: '<t:message code="system.label.product.type" default="유형"/>'		, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.product.itemaccount" default="품목계정"/>'		, type: 'string' , comboType:'AU', comboCode:'B020'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'PLAN_QTY'			, text: '<t:message code="system.label.product.planqty" default="계획량"/>'		, type: 'uniQty'},
			{name: 'NOTREF_Q'			, text: '<t:message code="system.label.product.noplanqty" default="미계획량"/>'		, type: 'uniQty'},
			{name: 'BASE_DATE'			, text: '<t:message code="system.label.product.basisdate" default="기준일"/>'		, type: 'uniDate'},
			{name: 'SALE_TYPE'			, text: '<t:message code="system.label.product.salestype" default="판매유형"/>'		, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'		, type: 'string'},
			{name: 'SER_NO'				, text: '<t:message code="system.label.product.soseq" default="수주순번"/>'		, type: 'string'},
			{name: 'ORDER_Q'	 		, text: '<t:message code="system.label.product.soqty" default="수주량"/>'		, type: 'uniQty'}
		]
	});

	//판매계획 참조 스토어 정의
	var SalesPlanStore = Unilite.createStore('ppl111ukrvSalesPlanStore', {
		model: 'ppl111ukrvSalesPlanModel',
		autoLoad: false,
			uniOpt : {
				isMaster	: false,			// 상위 버튼 연결
				editable	: false,			// 수정 모드 사용
				deletable	: false,			// 삭제 가능 여부
				useNavi		: false				// prev | next 버튼 사용
			},
			proxy: directProxy3
			,loadStoreRecords : function()	{
				var param= SalesPlanSearch.getValues();
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
				var grid = Ext.getCmp('ppl111ukrvSalesPlanGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	/**
	 * 판매계획을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//판매계획 참조 폼 정의
	var SalesPlanSearch = Unilite.createSearchForm('ppl111ukrvSalesPlanForm', {
		layout :  {type : 'uniTable', columns : 4},
		items :[{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120'
			}, {
				fieldLabel: '<t:message code="system.label.product.planperiod" default="계획기간"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FROM_MONTH',
				endFieldName: 'TO_MONTH',
				width: 350,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')/*,
				allowBlank:false*/		/// 계획기간 폼 만들기 전까지 필수조건 제거
		   }, {
				fieldLabel: '<t:message code="system.label.product.salestype" default="판매유형"/>',
				name:'SALE_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:''
		   }, {
				fieldLabel: '<t:message code="system.label.product.repmodel" default="대표모델"/>',
				name:'ITEM_GROUP',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:''
		   },{
				fieldLabel: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
				name:'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B020'
		   },{
				fieldLabel: '<t:message code="system.label.product.majorgroup" default="대분류"/>',
				name: 'TXTLV_L1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'TXTLV_L2'
			},{
				fieldLabel: '<t:message code="system.label.product.middlegroup" default="중분류"/>',
				name: 'TXTLV_L2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'TXTLV_L3'
			},{
				fieldLabel: '<t:message code="system.label.product.minorgroup" default="소분류"/>',
				name: 'TXTLV_L3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store')
			},{
				fieldLabel: '<t:message code="system.label.product.sentence001" default="※ 생산계획계산시 가용재고(현재고+입고예정-출고예정-안전재고)반영여부"/>',
				xtype: 'uniRadiogroup',
				labelWidth:450,
				width: 235,
				colspan:3,
				items: [{
						boxLabel:'<t:message code="system.label.product.yes" default="예"/>',
						width:70,
						name:'PAD_STOCK_YN',
						inputValue:'Y'
					},{
						boxLabel:'<t:message code="system.label.product.no" default="아니오"/>',
						width:70,
						name:'PAD_STOCK_YN',
						inputValue:'N' ,
						checked:true
				}]
			}]
	});

	//판매계획 참조 그리드 정의

	var SalesPlanGrid = Unilite.createGrid('ppl111ukrvSalesPlanGrid', {
		// title: '기본',
		layout : 'fit',
		region:'center',
		store: SalesPlanStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
			uniOpt:{
				onLoadSelectFirst : false
			},
		columns: [
			{ dataIndex: 'GUBUN'				, width: 40 , hidden: true},
			{ dataIndex: 'CHECK_YN'				, width: 40 , hidden: true},
			{ dataIndex: 'PLAN_TYPE'			, width: 40 , hidden: true},
			{ dataIndex: 'PLANTYPE_NAME'		, width: 100},
			{ dataIndex: 'ITEM_ACCOUNT'			, width: 66 },
			{ dataIndex: 'ITEM_CODE'			, width: 100},
			{ dataIndex: 'ITEM_NAME'			, width: 146},
			{ dataIndex: 'STOCK_UNIT'			, width: 66 },
			{ dataIndex: 'PLAN_QTY'				, width: 120},
			{ dataIndex: 'NOTREF_Q'				, width: 120},
			{ dataIndex: 'BASE_DATE'			, width: 100},
			{ dataIndex: 'SALE_TYPE'			, width: 100},
			{ dataIndex: 'WORK_SHOP_CODE'		, width: 66  , hidden: true},
			{ dataIndex: 'DIV_CODE'				, width: 100 , hidden: true},
			{ dataIndex: 'ORDER_NUM'			, width: 100 , hidden: true},
			{ dataIndex: 'SER_NO'				, width: 100 , hidden: true},
			{ dataIndex: 'ORDER_Q'				, width: 100 , hidden: true}
		]
		,listeners: {
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
		id: 'ppl111ukrvApp',
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
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'/*,'deleteAll'*/], true);
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

				var seq = masterStore.max('SER_NO');
				if(!seq) seq = 1;
				else  seq += 1;

				var compCode		= UserInfo.compCode
				var divCode		= masterForm.getValue('DIV_CODE');
				var workShopCode   = masterForm.getValue('WORK_SHOP_CODE');
				var prodtPlanDate  = UniDate.get('today');
				var wkPlanQ		= '0';
				var updateDbUser   = 'UserInfo.UserID';
				var updateDbTime   = UniDate.get('today');

				var stockQ			= '';
				var orderUnitQ		= '';
				var prodQ			= '';
				var sumWkPlanQ		= '';
				var wkordQ			= '';
				var prodtQ			= '';

				var r = {
					SER_NO			: seq,			/* 순번 */
					COMP_CODE		: compCode,		/* 법인코드*/
					DIV_CODE		: divCode,		/* 사업장*/
					WORK_SHOP_CODE  : workShopCode,	/* 작업장 */
					PRODT_PLAN_DATE : prodtPlanDate,/* 계획정보 - 계획일 */
					WK_PLAN_Q		: wkPlanQ,		/* 계획량 */
					UPDATE_DB_USER	: updateDbUser,	/* 수정자 */
					UPDATE_DB_TIME	: updateDbTime,	/* 수정일 */

					STOCK_Q			:stockQ,		/* 수주정보 - 현재고 */
					ORDER_UNIT_Q	:orderUnitQ,	/* 수주정보 - 수주량 */
					PROD_Q			:prodQ,			/* 수주정보 - 생산요청량 */
					SUM_WK_PLAN_Q	:sumWkPlanQ,	/* 수주정보 - 계획량 */
					WKORD_Q			:wkordQ,		/* 연계정보 - 작업지시량 */
					PRODT_Q			:prodtQ			/* 연계정보 - 생산량 */
				};

				masterGrid.createRow(r, '', -1);
				masterForm.setAllFieldsReadOnly(false);
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			masterForm.clearForm();
			panelResult.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			masterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('WKORD_NUM') != '') {
					Unilite.messageBox('<t:message code="system.message.product.message020" default="삭제할 수 없습니다."/>');

				}else if(selRow.get('MRP_YN') == 'Y'){
					Unilite.messageBox('<t:message code="system.message.product.message020" default="삭제할 수 없습니다."/>');
				//														  신텍스 에러 발생

				}else {
					masterGrid.deleteSelectedRow();
				}
			}

		},
		onDeleteAllButtonDown: function() {
			var records = masterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('<t:message code="system.message.product.confirm002" default="전체삭제 하시겠습니까?"/>')) {
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
			var as = Ext.getCmp('ppl111ukrvAdvanceSerch');
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
			var fp = Ext.getCmp('ppl111ukrvFileUploadPanel');
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
			masterForm.setValue('PRODT_PLAN_DATE_FR',UniDate.get('mondayOfWeek'));
			masterForm.setValue('PRODT_PLAN_DATE_TO',UniDate.get('endOfWeek'));

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('PRODT_PLAN_DATE_FR',UniDate.get('mondayOfWeek'));
			panelResult.setValue('PRODT_PLAN_DATE_TO',UniDate.get('endOfWeek'));

			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		},
		checkForNewDetail:function() {
			if(Ext.isEmpty(masterForm.getValue('PRODT_PLAN_DATE_FR')) || Ext.isEmpty(masterForm.getValue('PRODT_PLAN_DATE_TO')))	{
				Unilite.messageBox('<t:message code="system.message.product.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}

			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return masterForm.setAllFieldsReadOnly(true);
		}/*,
		fnCheckNum: function(value, record, fieldName) {
			var r = true;
			if(record.get("PRICE_YN") == "1" || record.get("ACCOUNT_YNC")=="N")	{
				r = true;
			} else if(record.get("PRICE_YN") == "2" )	{
				if(value < 0)	{
					alert(Msg.sMB076);
					r=false;
					return r;
				}else if(value == 0)	{
					if(fieldName == "ORDER_TAX_O")	{
						if(BsaCodeInfo.gsVatRate != 0)	{
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
