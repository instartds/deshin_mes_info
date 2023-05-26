<%--
'   프로그램명 : 수주대응 등록 (영업)
'
'   작  성  자 :
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sof150ukrv_kodi"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_sof150ukrv_kodi"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />				<!--화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="B020" />				<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5' />	<!--생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="B055" />				<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" />				<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" />				<!--과세구분-->
	<t:ExtComboStore comboType="AU" comboCode="S002" />				<!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="S010" />				<!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S011" />				<!--마감유형-->
	<t:ExtComboStore comboType="AU" comboCode="S161" />				<!--마감사유-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel3 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel4 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var gsInit			= true;		//초기화 사업장코드 변경될 때 오류 수정용
var gsOutDivCode	= '';		//알람정보 update를 위한 값
var noActionReasonWindow;		//미대응사유입력 팝업
var stockQueryWindow;			//자재소요량 및 현재고 조회 팝업(품목)
var stockQueryWindow2;			//자재소요량 및 현재고 조회 팝업(내용물)
var stockQueryWindow3;			//자재소요량 및 현재고 조회 팝업(내용물, 반제품)
var stockQueryWindow4;			//자재소요량 및 현재고 조회 팝업(내용물, 반제품)
var currencyWindow;				//유통10종 팝업
//20191107 품목정보 팝업 관련로직 추가
var referItemInformationWindow;	//제품정보팝업


function appMain() {
/* type:
 * uniQty		- 수량
 * uniUnitPrice	- 단가
 * uniPrice		- 금액(자사화폐)
 * uniPercent	- 백분율(00.00)
 * uniFC		- 금액(외화화폐)
 * uniER		- 환율
 * uniDate		- 날짜(2999.12.31)
 * maxLength	: 입력가능한 최대 길이
 * editable		: 수정가능 여부
 * allowBlank	: 필수 여부
 * defaultValue	: 기본값
 * comboType	:'AU', comboCode: 'B014' : 그리드 콤보 사용시
 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_sof150ukrv_kodiService.selectList',
			update	: 's_sof150ukrv_kodiService.updateList',
			create	: 's_sof150ukrv_kodiService.insertList',
			destroy	: 's_sof150ukrv_kodiService.deleteList',
			syncAll	: 's_sof150ukrv_kodiService.saveAll'
		}
	});

	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_sof150ukrv_kodiService.selectList1'
		}
	});

	//20191107 품목정보 팝업 관련로직 추가
	var itemInfoProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{	//품목 정보 관련 파일 업로드
		api: {
			read	: 'ppl113ukrvService.getItemInfo',
			update	: 'ppl113ukrvService.itemInfoUpdate',
			create	: 'ppl113ukrvService.itemInfoInsert',
			destroy	: 'ppl113ukrvService.itemInfoDelete',
			syncAll	: 'ppl113ukrvService.saveAll2'
		}
	});



	Unilite.defineModel('s_sof150ukrv_kodiModel', {
		fields: [
			{name: 'COMP_CODE'			,text:'COMP_CODE'		,type:'string'},
			{name: 'DIV_CODE'			,text:'<t:message code="system.label.sales.division" default="사업장"/>'				,type:'string',comboType: 'BOR120'},
			//20190607 춝고사업장(OUT_DIV_CODE) 추가
			{name: 'OUT_DIV_CODE'		,text:'<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'		,type:'string',comboType: 'BOR120'},
			{name: 'ORDER_NUM'			,text:'<t:message code="system.label.sales.sono" default="수주번호"/>'					,type:'string'},
			{name: 'SER_NO'				,text:'<t:message code="system.label.sales.seq" default="순번"/>'						,type:'string'},
			{name: 'CUSTOM_CODE'		,text:'<t:message code="system.label.sales.custom" default="거래처"/>'					,type:'string'},
			{name: 'CUSTOM_NAME'		,text:'<t:message code="system.label.sales.customname" default="거래처명"/>'			,type:'string'},
			{name: 'ITEM_CODE'			,text:'<t:message code="system.label.sales.item" default="품목"/>'					,type:'string'},
			{name: 'ITEM_NAME'			,text:'<t:message code="system.label.sales.itemname" default="품목명"/>'				,type:'string'},
			{name: 'ORDER_DATE'			,text:'<t:message code="system.label.sales.sodate" default="수주일"/>'					,type:'uniDate'},
			//20190617 단가 추가
			{name: 'ORDER_P'			,text:'<t:message code="system.label.sales.price" default="단가"/>'					,type:'uniUnitPrice'},
			{name: 'ORDER_Q'			,text:'<t:message code="system.label.sales.soqty" default="수주량"/>'					,type:'int'},
			{name: 'ORDER_REM_Q'		,text:'<t:message code="system.label.sales.undeliveryqty" default="미납량"/>'			,type:'int'},
			{name: 'INIT_DVRY_DATE'		,text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'			,type:'uniDate'},
			{name: 'DVRY_DATE'			,text:'<t:message code="system.label.sales.changeddeliverydate" default="납기변경일"/>'	,type:'uniDate'},
			{name: 'DVRY_WEEK_NUM'			,text:'납기주차'	,type:'string'},
			//20190613 계획주차(WEEK_NUM) 추가
			{name: 'WEEK_NUM'			,text:'<t:message code="system.label.sales.planweeknum" default="계획주차"/>'			,type:'string'},
			{name: 'REASON1'			,text:'<t:message code="system.message.sales.message126" default="미대응 사유"/> - <t:message code="system.label.sales.contents" default="내용물"/>'	,type:'string'},
			{name: 'REASON2'			,text:'<t:message code="system.message.sales.message126" default="미대응 사유"/> - <t:message code="system.label.sales.submaterial" default="부자재"/>'	,type:'string'},
			{name: 'CHILD_ITEM_CODE'	,text:'<t:message code="system.label.sales.contents" default="내용물"/><t:message code="system.label.sales.code" default="코드"/>'					,type:'string'},
			{name: 'LOT_NO'				,text:'LOT NO'			,type:'string'},
			{name: 'COMPLETE_Q'			,text:'<t:message code="system.label.sales.completionQty" default="완료량"/>'			,type:'int'},
			{name: 'REASON3'			,text:'<t:message code="system.message.sales.message126" default="미대응 사유"/> - <t:message code="system.label.sales.rawmaterial" default="원료"/>'	,type:'string'},
			{name: 'REASON4'			,text:'<t:message code="system.message.sales.message126" default="미대응 사유"/> - <t:message code="system.label.sales.etc" default="기타"/>'			,type:'string'},
			{name: 'REASON'				,text:'<t:message code="system.label.sales.deliverydatereason" default="납기변경사유"/>'	,type:'string'},
			//내용물 실제필요수량 계산: (${ORDER_REM_Q} * (D.UNIT_Q / D.PROD_UNIT_Q)) * (100 / D.SET_QTY)
			{name: 'CHILD_ITEM_NAME'	,text: 'CHILD_ITEM_NAME',type:'string'},
			{name: 'UNIT_Q'				,text: 'UNIT_Q'			,type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'PROD_UNIT_Q'		,text: 'PROD_UNIT_Q'	,type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'SET_QTY'			,text: 'SET_QTY'		,type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			//20190611 생산계획번호 추가
			{name: 'WK_PLAN_NUM'		,text: '<t:message code="system.label.sales.productionplanno" default="생산계획번호"/>'	,type: 'string'},
			//20190620 계획량, 미생물의뢰일, 완료예상일 추가
			{name: 'WK_PLAN_Q'			,text: '<t:message code="system.label.sales.productionplanqty" default="생산계획량"/>'	,type: 'int'},
			// 20200716 제조진행현황(g), 충전진행현황(ea), 포장진행현황(ea), 충전진행율, 포장진행율 칼럼추가
			{name: 'QTYCOUNT_A'			,text: '제조진행현황(g)'	,type: 'uniQty'},
			{name: 'QTYCOUNT_B'			,text: '충전진행현황(ea)'	,type: 'uniQty'},
			{name: 'QTYCOUNT_C'			,text: '포장진행현황(ea)'	,type: 'uniQty'},
			{name: 'WORK_RATE_B'		,text: '충전진행율(%)'	,type: 'uniPercent'},
			{name: 'WORK_RATE_C'		,text: '포장진행율(%)'	,type: 'uniPercent'},
			//20201022 검사정보에서 의뢰일(MIN~MAX), 예산완료일(MIN~MAX)가져오기
			{name: 'MICROBE_DATE_MIN'		,text: '의뢰일(미생물)Fr'			,type: 'uniDate'},
			{name: 'MICROBE_DATE_MAX'		,text: '의뢰일(미생물)To'			,type: 'uniDate'},
			{name: 'EXPECTED_END_DATE_MIN'	,text: '완료예상일(미생물)Fr'			,type: 'uniDate'},
			{name: 'EXPECTED_END_DATE_MAX'	,text: '완료예상일(미생물)To'			,type: 'uniDate'},
			// 20190627 마감여부 추가
			{name: 'CLOSE_YN'			,text: '마감여부'			,type: 'string'		,comboType: 'AU' ,comboCode: 'S011'},
			{name: 'CLOSE_REASON'			,text: '마감사유'			,type: 'string'		,comboType: 'AU' ,comboCode: 'S161'},
			{name: 'PO_NUM'				,text: '<t:message code="system.label.sales.pono2" default="PO 번호"/>'	,type: 'string'},
			{name: 'REASON1_OLD'		,text: 'REASON1_OLD'			,type: 'string'},
			{name: 'REASON2_OLD'		,text: 'REASON2_OLD'			,type: 'string'},
			{name: 'REASON3_OLD'		,text: 'REASON3_OLD'			,type: 'string'},
			{name: 'REASON4_OLD'		,text: 'REASON4_OLD'			,type: 'string'}
		]
	});


	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_sof150ukrv_kodiMasterStore1', {
		model	: 's_sof150ukrv_kodiModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼,상태바 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: directProxy,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			//20190730 알람 데이터 update를 위한 키값 set
			if(!Ext.isEmpty(gsOutDivCode)) {
				param.OUT_DIV_CODE = gsOutDivCode;
			}
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			this.load({
				params: param
			});
		},
		saveStore: function() {
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);
			var isErr		= false;
			console.log("list:", list);

			// 20200716 마가마일경우 마감사유 입력체크 로직 추가
			Ext.each(list, function(record, index) {
				if(record.get('CLOSE_YN') == 'Y'){
					if(Ext.isEmpty(record.get('CLOSE_REASON'))){
							Unilite.messageBox('마감일 경우 마감사유는 필수이력항목입니다.마감사유를 입력해주세요.');
	                        isErr = true;
	                        return false;
                	}
				}
			})
			if(isErr) {
            	return false;
            }
			// 20191014 수정내용 뱃지에 표시 하기 위한 로직 추가
			var colums = Ext.getCmp('s_sof150ukrv_kodiGrid1').getColumns();
			Ext.each(toUpdate, function(record, index) {
				var flag = true;
				var changedColumns = record.getChanges();
				Ext.each(colums, function(colum, index) {
					var columnName = colum.dataIndex;
					if(!Ext.isEmpty(columnName)) {
						columnName = columnName.toString();
						if(Ext.isDefined(changedColumns[columnName])) {
							record.set('CHANGES', colum.config.text);
							flag = false;
							return true;
						}
					}
					if(!flag) return true;
				});
			});
			// 1. 마스터 정보 파라미터 구성
			var paramMaster = panelSearch.getValues();	// syncAll 수정

			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						if(directMasterStore1.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						} else {
							UniAppManager.app.onQueryButtonDown();
						}
					}
				};
				this.syncAllDirect(config);

			} else {
				var grid = Ext.getCmp('s_sof150ukrv_kodiGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				//20190730 알람 데이터 update를 위한 키값 초기화
				if(!Ext.isEmpty(gsOutDivCode)) {
					panelSearch.setValue('LINK_FLAG', '');
					gsOutDivCode = '';
				}
			}
		}
//		, groupField: 'ITEM_CODE'
	});

	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,//true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name        : 'DIV_CODE',
				xtype       : 'uniCombobox',
				comboType   : 'BOR120',
				allowBlank  : false,
				multiSelect : true,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						if(!gsInit) {
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							var field = panelResult.getField('ORDER_PRSN');
							field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				xtype: 'uniDateRangefield',
				width: 315,
//				startDate: UniDate.get('startOfMonth'),
//				endDate: UniDate.get('today'),
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
			}, {
				fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'DVRY_DATE_FR',
				endFieldName: 'DVRY_DATE_TO',
				width: 315,
				colspan: 2,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DVRY_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DVRY_DATE_TO',newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name:'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S002',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S010',
				multiSelect: true,
				typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				},

				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					// 사업장 변경시
					if(eOpts){
						// 값 초기화
						panelResult.setValue('ORDER_PRSN', '');
		            	panelSearch.setValue('ORDER_PRSN', '');

						// 초기화
						var store = combo.store;
	                    store.clearFilter();

	                    // 사업장 존재시 해당사업장의 영업담당을 filtering
		                if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
		                	store.filterBy(function(record){
		                    	return panelResult.getValue('DIV_CODE').indexOf(record.get('refCode1')) !== -1 ;
		               	 	});
		               	// 사업장이 없는 경우
		                } else {
		                	store.filterBy(function(record){
		                    	return false;
		               		});
		            	}

	            	// 초기 화면 오픈시
					} else {
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
				},
				Unilite.popup('PROJECT',{
					fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
					valueFieldName:'PJT_CODE',
					textFieldName:'PJT_NAME',
					DBvalueFieldName: 'PJT_CODE',
					DBtextFieldName: 'PJT_NAME',
					validateBlank: false,
	//				allowBlank:false,
					textFieldOnly: false,
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('PJT_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('PJT_NAME', newValue);
						}
					}
				}),{
					//20190607 춝고사업장(OUT_DIV_CODE) 추가
					fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
					name		: 'OUT_DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					multiSelect : true,
					value: UserInfo.divCode,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('OUT_DIV_CODE', newValue);
						}
					}
				}
			]
		}, {
			title:'<t:message code="system.label.sales.custominfo" default="거래처정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items:[
				Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				extParam: {'CUSTOM_TYPE':['1','3']},
				validateBlank: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);
					},
					applyextparam: function(popup) {
						popup.setExtParam({'CUSTOM_TYPE':['1','3']});
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
				name:'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B055'
			}, {
				fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
				name:'AREA_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B056'
			}]
		}, {
			title:'<t:message code="system.label.sales.iteminfo" default="품목정보"/>',
			defaultType: 'uniTextfield',
			id: 'search_panel3',
			itemId:'search_panel3',
			layout: {type: 'uniTable', columns: 1},
			items:[
				 Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				validateBlank: false,
				autoPopup:false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),
				Unilite.popup('ITEM_GROUP',{
				fieldLabel: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
				valueFieldName: 'ITEM_GROUP',
				textFieldName: 'ITEM_GROUP_NAME',
				validateBlank:false,
				popupWidth: 710,
				colspan: 2
			}),{
				fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name: 'TXTLV_L1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'TXTLV_L2'
			}, {
				fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name: 'TXTLV_L2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'TXTLV_L3'
			}, {
				fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name: 'TXTLV_L3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['TXTLV_L1','TXTLV_L2'],
				levelType:'ITEM'
			}]
		}, {
			title:'<t:message code="system.label.sales.soinfo" default="수주정보"/>',
			id: 'search_panel4',
			itemId:'search_panel4',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				xtype: 'container',
				defaultType: 'uniNumberfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'<t:message code="system.label.sales.soqty" default="수주량"/>',
					suffixTpl:'&nbsp;~&nbsp;',
					name: 'FR_ORDER_QTY',
					width:218
				}, {
					name: 'TO_ORDER_QTY',
					width:107
				}]
			}, {
				xtype: 'container',
				defaultType: 'uniNumberfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'<t:message code="system.label.sales.sono" default="수주번호"/>',
					xtype: 'uniTextfield',
					suffixTpl:'&nbsp;~&nbsp;',
					name: 'FR_ORDER_NUM',
					width:218
				}, {
					name: 'TO_ORDER_NUM',
					xtype: 'uniTextfield',
					width:107
				}, {
					name: 'SER_NO',
					hidden: true,
					width:107
				}, {
					name: 'LINK_FLAG',
					xtype: 'uniTextfield',
					hidden: true,
					width:107
				}]
			}, {
				fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
				name:'TXT_CREATE_LOC',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B031'
			}, {
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.sales.closingyn" default="마감여부"/>',
				id: 'ORDER_STATUS',
//				name: 'ORDER_STATUS',
				items: [{
					boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
					width: 50,
					name: 'ORDER_STATUS',
					inputValue: '%',
					checked: true
				}, {
					boxLabel: '<t:message code="system.label.sales.closing" default="마감"/>',
					width: 60, name: 'ORDER_STATUS',
					inputValue: 'Y'
				}, {
					boxLabel: '<t:message code="system.label.sales.noclosing" default="미마감"/>',
					width: 80, name: 'ORDER_STATUS',
					inputValue: 'N'
				}]
			}, {
				fieldLabel: '<t:message code="system.label.sales.status" default="상태"/>',
				xtype: 'radiogroup',
				id: 'rdoSelect2',
//				name: 'rdoSelect2',
				items: [{
					boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
					width: 50,
					name: 'rdoSelect2',
					inputValue: 'A',
					checked: true
				}, {
					boxLabel: '<t:message code="system.label.sales.unapproved" default="미승인"/>',
					width: 60, name: 'rdoSelect2',
					inputValue: 'N'
				}, {
					boxLabel: '<t:message code="system.label.sales.approved" default="승인"/>',
					width: 50, name: 'rdoSelect2',
					inputValue: '6'
				}, {
					boxLabel: '<t:message code="system.label.sales.giveback" default="반려"/>',
					width: 50, name: 'rdoSelect2',
					inputValue: '5'
				}]
			},{
				fieldLabel: '<t:message code="system.label.sales.remarks" default="비고"/>',
				xtype: 'uniTextfield',
				name:'REMARK'
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

					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				}
			}
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
				fieldLabel  : '<t:message code="system.label.sales.division" default="사업장"/>',
				name        : 'DIV_CODE',
				xtype       : 'uniCombobox',
				comboType   : 'BOR120',
				allowBlank  : false,
				multiSelect : true,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						if(!gsInit) {
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							var field = panelSearch.getField('ORDER_PRSN');
							field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				xtype: 'uniDateRangefield',
				width: 315,
//				startDate: UniDate.get('startOfMonth'),
//				endDate: UniDate.get('today'),
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
			}, {
				fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'DVRY_DATE_FR',
				endFieldName: 'DVRY_DATE_TO',
				width: 315,
				colspan: 2,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('DVRY_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('DVRY_DATE_TO',newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name:'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S002',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ORDER_TYPE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S010',
				multiSelect: true,
				typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ORDER_PRSN', newValue);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					// 사업장 변경시
					if(eOpts){
						// 값 초기화
						panelResult.setValue('ORDER_PRSN', '');
		            	panelSearch.setValue('ORDER_PRSN', '');

						// 초기화
						var store = combo.store;
	                    store.clearFilter();

	                    // 사업장 존재시 해당사업장의 영업담당을 filtering
		                if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
		                	store.filterBy(function(record){
		                    	return panelResult.getValue('DIV_CODE').indexOf(record.get('refCode1')) !== -1 ;
		               	 	});
		               	// 사업장이 없는 경우
		                } else {
		                	store.filterBy(function(record){
		                    	return false;
		               		});
		            	}

	            	// 초기 화면 오픈시
					} else {
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},
			Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
				valueFieldName:'PJT_CODE',
				textFieldName:'PJT_NAME',
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName: 'PJT_NAME',
				validateBlank: false,
	//				allowBlank:false,
				textFieldOnly: false,
				autoPopup: true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('PJT_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('PJT_NAME', newValue);
					}
				}
			}),
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
				extParam: {'CUSTOM_TYPE':'3'},
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				autoPopup: true,
				validateBlank: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_NAME', newValue);
					},
					applyextparam: function(popup) {
						popup.setExtParam({'CUSTOM_TYPE':'3'});
					}
				}
			}),
			Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				validateBlank: false,
				autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),{
				//20190607 춝고사업장(OUT_DIV_CODE) 추가
				fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
				name		: 'OUT_DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				multiSelect : true,
				value: UserInfo.divCode,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('OUT_DIV_CODE', newValue);
					}
				}
			}
		]
	});


	/** Master Grid1 정의(Grid Panel),
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_sof150ukrv_kodiGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		selModel: 'cellmodel',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			},
			excel: {
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: true, 	//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			},
			state: {
				useState: true,			//그리드 설정 버튼 사용 여부
				useStateList: true		//그리드 설정 목록 사용 여부
			}
		},
		tbar:[{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.message.sales.message125" default="해당 라인을 더블클릭"/>',
			id			: 'showPopup',
			labelWidth	: 120,
			items		: [{
				boxLabel	: '<t:message code="system.message.sales.message126" default="미대응 사유"/>',
				name		: 'POPUP_CASE',
				inputValue	: '1',
				width		: 100,
				checked		: true
			}, {
				boxLabel	: '<t:message code="system.message.sales.message127" default="자재소요량 및 현재고"/>',
				name		: 'POPUP_CASE',
				inputValue	: '2',
				width		: 150
			}/*, {
				boxLabel: '<t:message code="system.message.sales.message128" default="유통10종"/>',
				name		: 'POPUP_CASE',
				inputValue	: '3',
				width		: 100
			}*/]
		},'->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->'/*,{
			fieldLabel		: '<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>',
			xtype			: 'uniNumberfield',
			itemId			: 'selectionSummary',
			format			: '0,000.0000',
			decimalPrecision: 4,
			value			: 0,
			labelWidth		: 110,
			readOnly		: true
		}*/],
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: false
		}],
		selModel: 'rowmodel',
		columns	: [
//			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
//			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'OUT_DIV_CODE'		, width: 100},
			{dataIndex: 'CUSTOM_CODE'		, width: 100, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 120, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 250},
			{dataIndex: 'ORDER_NUM'			, width: 120},
			{dataIndex: 'SER_NO'			, width: 66 , align: 'center'},
			{dataIndex: 'ORDER_DATE'		, width: 90 },
			{dataIndex: 'ORDER_P'			, width: 100},
			{dataIndex: 'ORDER_Q'			, width: 100},
			//20190620 생산계획량 추가
			{dataIndex: 'WK_PLAN_Q'			, width: 100},
			// 20200715 제조진행현황(g), 충전진행현황(ea), 포장진행현황(ea)칼럼추가
			{dataIndex: 'QTYCOUNT_A'			, width: 115},
			{dataIndex: 'QTYCOUNT_B'			, width: 115},
			{dataIndex: 'QTYCOUNT_C'			, width: 115},
			{dataIndex: 'WORK_RATE_B'			, width: 105},
			{dataIndex: 'WORK_RATE_C'			, width: 105},

			{dataIndex: 'ORDER_REM_Q'		, width: 100},
			//20190627 마감여부 추가
			{dataIndex: 'CLOSE_YN'			, width: 70 , align: 'center'},
			{dataIndex: 'CLOSE_REASON'			, width: 150},
			{dataIndex: 'INIT_DVRY_DATE'	, width: 90 },
			{dataIndex: 'DVRY_DATE'			, width: 90 },
			{dataIndex: 'DVRY_WEEK_NUM'		, width: 80 , align: 'center'},
			//20190613 계획주차(WEEK_NUM) 추가
			{dataIndex: 'WEEK_NUM'			, width: 80 , align: 'center'},
			{dataIndex: 'REASON1'			, width: 150},
			{dataIndex: 'REASON2'			, width: 150},
			{dataIndex: 'CHILD_ITEM_CODE'	, width: 100},
			{dataIndex: 'COMPLETE_Q'		, width: 100},

			{dataIndex: 'LOT_NO'			, width: 150},
			{dataIndex: 'MICROBE_DATE_MIN'		, width: 150},
			{dataIndex: 'MICROBE_DATE_MAX'		, width: 150},
			{dataIndex: 'EXPECTED_END_DATE_MIN'	, width: 150},
			{dataIndex: 'EXPECTED_END_DATE_MAX'	, width: 150},

			{dataIndex: 'REASON3'			, width: 150},
			{dataIndex: 'REASON4'			, width: 150},
			{dataIndex: 'REASON'			, width: 150},
			//20190611 생산계획번호 추가
			{dataIndex: 'WK_PLAN_NUM'		, width: 120},
			//20200131 PO 번호 추가
			{dataIndex: 'PO_NUM'			, width: 120},
			{dataIndex: 'REASON1_OLD'			, width: 150, hidden: true},
			{dataIndex: 'REASON2_OLD'			, width: 150, hidden: true},
			{dataIndex: 'REASON3_OLD'			, width: 150, hidden: true},
			{dataIndex: 'REASON4_OLD'			, width: 150, hidden: true},
			//20191107 품목정보 팝업 관련로직 추가
			{
				text	: '제품정보',
				xtype	: 'widgetcolumn',
				width	: 150,
				widget	: {
					text		: '제품정보 확인',
					xtype		: 'button',
					listeners	: {
						buffer	: 1,
						click	: function(button, event, eOpts) {
							var record = event.record.data;
							itemInfoStore.loadStoreRecords(record.ITEM_CODE);
							openItemInformationWindow();
						}
					}
				}
			}
		],
		listeners:{
			edit : function( editor, context, eOpts ) {
				if (UniUtils.indexOf(context.field, ['MICROBE_DATE'])) {
					//20190620 미생물의뢰일 입력 시, 값이 비어있지 않으면 완료예상일에 미생물의뢰일 + 5일 입력
					var microbeDate = context.record.get('MICROBE_DATE');
					if(Ext.isEmpty(microbeDate)) {
						context.record.set('EXPECTED_END_DATE', '');
					} else {
						context.record.set('EXPECTED_END_DATE', UniDate.add(microbeDate, {days: 5}));
					}
				}
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['CLOSE_YN', 'CLOSE_REASON'])) {
					return true;
				} else {
					return false;
				}
			},
			onGridDblClick: function(grid, record, cellIndex, colName) {
				//더블클릭한 필드가 미생물의뢰일, 완료예상일이 아닐때만 팝업 생성 - 미생물의뢰일, 완료예상일일 때 팝업 뜨면 사용시 불편
				if(colName != 'MICROBE_DATE' && colName != 'EXPECTED_END_DATE') {
					var popupFlag = Ext.getCmp('showPopup').getChecked()[0].inputValue;
					if(popupFlag == '1') {
						openNoActionReasonWindow();
//						Unilite.messageBox('미대응 사유팝업');
					} else if(popupFlag == '2') {
						//품목명 컬럼 더블클릭하면,
						if(colName == 'ITEM_CODE' || colName == 'ITEM_NAME') {
							openStockQueryWindow();

						//내용물 컬럼 더블클릭하면,
						} else if(colName == 'CHILD_ITEM_CODE') {
							openStockQueryWindow2();
						}
//						Unilite.messageBox('자재소요량 및 현재고 조회');
					} else {
//						Unilite.messageBox('유통10종');
					}
				}
			}
		}
	});

	Unilite.defineModel('s_sof150ukrv_kodiModel1', {
		fields: [
			{name: 'LOT_NO'				,text:'LOT NO'			,type:'string'},
			{name: 'MICROBE_DATE'		,text: '의뢰일(미생물)'			,type: 'uniDate'},
			{name: 'EXPECTED_END_DATE'	,text: '완료예상일(미생물)'			,type: 'uniDate'}
		]
	});

	var noActionReasonStore = Unilite.createStore('s_sof150ukrv_kodinoActionReason', {
		model	: 's_sof150ukrv_kodiModel1',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼,상태바 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: directProxy1,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();

			var record = masterGrid.getSelectedRecord();

			param.OUT_DIV_CODE = record.get('OUT_DIV_CODE');
			param.ORDER_NUM =  record.get('ORDER_NUM');
			param.SER_NO =  record.get('SER_NO');

			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			this.load({
				params: param
			});
		}
	});

	var noActionReasonGrid = Unilite.createGrid('s_sof150ukrv_kodinoActionReasonGrid', {
		store	: noActionReasonStore,
		layout	: 'fit',
		region	: 'center',
		selModel: 'cellmodel',
//		tbar:[{hidden:true
//		}],
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			userToolbar :false,
			expandLastColumn	: false
		},
		selModel: 'rowmodel',
		columns	: [
				{dataIndex: 'LOT_NO'			, width: 150},
				{dataIndex: 'MICROBE_DATE'		, width: 120},
				{dataIndex: 'EXPECTED_END_DATE'	, width: 120}
		]
	});

	/** 미대응 사유 팝업
	 */
	var noActionReasonForm = Unilite.createSearchForm('noActionReasonForm', {
		layout		: {type : 'uniTable', columns : 3},
		height		: 330,
		width		: 590,
		region		: 'center',
		autoScroll	: true,
		border		: true,
		padding		: '0 0 0 0',
		xtype		: 'container',
		defaultType	: 'container',
		items:[{
			layout		: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
			defaultType	: 'uniFieldset',
			defaults	: { padding: '10 15 15 15'},
			items		: [{
				title	: '',
				layout	: { type: 'uniTable', columns: 2},
				items	: [{
					fieldLabel	: '<t:message code="system.label.sales.sono" default="수주번호"/>',
					xtype		: 'uniTextfield',
					name		: 'ORDER_NUM',
					holdable	: 'hold',
					colspan		: 2,
					readOnly	: true,
					fieldStyle	: 'text-align: center;',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.product.item" default="품목"/>',
					name		:'ITEM_CODE',
					xtype		: 'uniTextfield',
					readOnly	: true,
					fieldStyle	: 'text-align: center;'

				},{
					fieldLabel	: '',
					name		: 'ITEM_NAME',
					width		: 300,
					xtype		: 'uniTextfield',
					readOnly	: true
				},{
					fieldLabel	: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
					xtype		: 'uniDatefield',
					name		: 'DVRY_DATE',
					readOnly	: true
				},{
					fieldLabel	: '<t:message code="system.label.sales.soqty" default="수주량"/>',
					name		: 'ORDER_Q',
					xtype		: 'uniNumberfield',
					type		: 'uniQty',
					labelWidth	: 145,
					readOnly	: true
				}]},{
					title	: '<t:message code="system.message.sales.message126" default="미대응 사유"/>',
					layout	: { type: 'uniTable', columns: 1},
					items	: [{
						fieldLabel	: '<t:message code="system.label.sales.contents" default="내용물"/>',
						name		: 'REASON1',
						xtype		: 'uniTextfield',
						width		: 535
					},{
						fieldLabel	: '<t:message code="system.label.sales.submaterial" default="부자재"/>',
						name		: 'REASON2',
						xtype		: 'uniTextfield',
						width		: 535
					},{
						fieldLabel	: '<t:message code="system.label.sales.rawmaterial" default="원료"/>',
						name		: 'REASON3',
						xtype		: 'uniTextfield',
						width		: 535
					},{
						fieldLabel	: '<t:message code="system.label.sales.etc" default="기타"/>',
						name		: 'REASON4',
						xtype		: 'uniTextfield',
						width		: 535
					}]
				}]}
			],
			setAllFieldsReadOnly: setAllFieldsReadOnly
	});

	function openNoActionReasonWindow() {
		if(!noActionReasonWindow) {
			noActionReasonWindow = Ext.create('widget.uniDetailWindow', {
				title		: '<t:message code="system.message.sales.message126" default="미대응 사유"/>',
				height		: 700,
				width		: 590,
				tabDirection: 'left-right',
				resizable	: false,
				layout		: {type:'vbox', align:'stretch'},
				items		: [noActionReasonForm, noActionReasonGrid],
				tbar		: [{
					itemId	: 'deleteButton',
					text	: '<t:message code="system.label.sales.delete" default="삭제"/>',
					handler : function() {
						var record = masterGrid.getSelectedRecord();
						record.set('REASON1', '');
						record.set('REASON2', '');
						record.set('REASON3', '');
						record.set('REASON4', '');
						noActionReasonForm.clearForm();
						noActionReasonWindow.hide();
					}
				},'->', {
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.confirm" default="확인"/>',
					handler	: function() {
						var record = masterGrid.getSelectedRecord();
						record.set('REASON1', noActionReasonForm.getValue('REASON1'));
						record.set('REASON2', noActionReasonForm.getValue('REASON2'));
						record.set('REASON3', noActionReasonForm.getValue('REASON3'));
						record.set('REASON4', noActionReasonForm.getValue('REASON4'));
						noActionReasonForm.clearForm();
						noActionReasonWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'cancelBtn',
					text	: '<t:message code="system.label.sales.cancel" default="취소"/>',
					handler	: function() {
						noActionReasonForm.clearForm();
						noActionReasonWindow.hide();
					},
					disabled: false
					}
				],
				listeners: {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function( panel, eOpts ) {
						var record = masterGrid.getSelectedRecord();
						noActionReasonForm.setValue('ORDER_NUM'	, record.get('ORDER_NUM'));
						noActionReasonForm.setValue('ITEM_CODE'	, record.get('ITEM_CODE'));
						noActionReasonForm.setValue('ITEM_NAME'	, record.get('ITEM_NAME'));
						noActionReasonForm.setValue('DVRY_DATE'	, record.get('DVRY_DATE'));
						noActionReasonForm.setValue('ORDER_Q'	, record.get('ORDER_Q'));

						noActionReasonForm.setValue('REASON1'	, record.get('REASON1'));
						noActionReasonForm.setValue('REASON2'	, record.get('REASON2'));
						noActionReasonForm.setValue('REASON3'	, record.get('REASON3'));
						noActionReasonForm.setValue('REASON4'	, record.get('REASON4'));

						noActionReasonStore.loadStoreRecords();
					}
				}
			})
		}
		noActionReasonWindow.center();
		noActionReasonWindow.show();
	}



	/** 자재소요량 및 현재고 (품목)
	 */
	var stockForm = Unilite.createSearchForm('stockForm', {
		layout		: {type : 'uniTable', columns : 3},
//		height		: 370,
//		width		: 800,
		region		: 'center',
		autoScroll	: true,
		border		: true,
		padding		: '0 0 0 0',
		xtype		: 'container',
		defaultType	: 'container',
		items:[{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			xtype		: 'uniTextfield',
			name		: 'DIV_CODE',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
			xtype		: 'uniTextfield',
			name		: 'OUT_DIV_CODE',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_CODE',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.customname" default="거래처명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_NAME',
			readOnly	: true,
			fieldStyle	: 'text-align: center;',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.sodate" default="수주일"/>',
			name		: 'ORDER_DATE',
			xtype		: 'uniDatefield',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			name		: 'DVRY_DATE',
			xtype		: 'uniDatefield',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.item" default="품목"/>',
			name		:'ITEM_CODE',
			xtype		: 'uniTextfield',
			readOnly	: true,
			fieldStyle	: 'text-align: center;'

		},{
			fieldLabel	: '',
			name		: 'ITEM_NAME',
			width		: 490,
			xtype		: 'uniTextfield',
			colspan		: 2,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.soqty" default="수주량"/>',
			name		: 'ORDER_Q',
			xtype		: 'uniNumberfield',
			type		: 'uniQty',
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.completionQty" default="완료량"/>',
			name		: 'COMPLETE_Q',
			xtype		: 'uniNumberfield',
			type		: 'uniQty',
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.undeliveryqty" default="미납량"/>',
			name		: 'ORDER_REM_Q',
			xtype		: 'uniNumberfield',
			type		: 'uniQty',
			readOnly	: true
		}],
		setAllFieldsReadOnly: setAllFieldsReadOnly
	});

	Unilite.defineModel('stockModel', {
		fields: [
			{name: 'SEQ'			, text: '순번'		, type: 'string'},
			{name: 'ITEM_ACCOUNT'	, text: '자재구분'		, type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'ITEM_CODE'		, text: '자재코드'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '자재명'		, type: 'string'},
			{name: 'STOCK_UNIT'		, text: '단위'		, type: 'string'},
			{name: 'USAGE'			, text: 'Usage'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'USAGE_RATE'		, text: '실사용률'		, type: 'uniPercent'},
			{name: 'NEED_Q'			, text: '필요량'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'REAL_NEED_Q'	, text: '실필요량'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'GOOD_STOCK_Q'	, text: '재고량'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'MATR_CUSTOM_CODE'		, text: '거래처'		, type: 'string'},
			{name: 'MATR_CUSTOM_NAME'		, text: '거래처명'		, type: 'string'}
		]
	});

	var stockStore = Unilite.createStore('stockStore', {
		model	: 'stockModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 's_sof150ukrv_kodiService.stockList'
			}
		},
		loadStoreRecords: function() {
			var param = stockForm.getValues();
			console.log(param);
			this.load({
				params: param
			});
		}
	});

	var stockGrid = Unilite.createGrid('stockGrid', {
		store	: stockStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: true
		},
		columns: [
			{ dataIndex: 'SEQ'			, width: 50 },
			{ dataIndex: 'ITEM_ACCOUNT'	, width: 100},
			{ dataIndex: 'ITEM_CODE'	, width: 100},
			{ dataIndex: 'ITEM_NAME'	, width: 250},
			{ dataIndex: 'STOCK_UNIT'	, width: 70 , align: 'center'},
			{ dataIndex: 'USAGE'		, width: 80 },
			{ dataIndex: 'USAGE_RATE'	, width: 80 },
			{ dataIndex: 'NEED_Q'		, width: 100},
			{ dataIndex: 'REAL_NEED_Q'	, width: 100},
			{ dataIndex: 'GOOD_STOCK_Q'	, width: 100, hidden: true},
			{ dataIndex: 'MATR_CUSTOM_CODE'	, width: 100},
			{ dataIndex: 'MATR_CUSTOM_NAME'	, width: 250}
		],
		selModel: 'rowmodel',
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			var sItemAccount = record.get('ITEM_ACCOUNT');
			if(sItemAccount == '30' || sItemAccount == '50'|| sItemAccount == '20' ){
					openStockQueryWindow3();
			}

			}
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';

				if(record.get('REAL_NEED_Q') > record.get('GOOD_STOCK_Q')){
					cls = 'x-change-celltext_red';
				}
				return cls;
			}
		}
	});

	function openStockQueryWindow() {
		if(!stockQueryWindow) {
			stockQueryWindow = Ext.create('widget.uniDetailWindow', {
				title		: '<t:message code="system.message.sales.message127" default="자재소요량 및 현재고"/>',
				height		: 500,
				width		: 800,
				resizable	: false,
				layout		: {type:'vbox', align:'stretch'},
				items		: [stockForm, stockGrid],
				tbar		: ['->', {
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.confirm" default="확인"/>',
					handler	: function() {
						stockForm.clearForm();
						stockQueryWindow.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function( panel, eOpts ) {
						var record = masterGrid.getSelectedRecord();
						stockForm.setValue('DIV_CODE'		, record.get('DIV_CODE'));
						stockForm.setValue('OUT_DIV_CODE'	, record.get('OUT_DIV_CODE'));
						stockForm.setValue('CUSTOM_CODE'	, record.get('CUSTOM_CODE'));
						stockForm.setValue('CUSTOM_NAME'	, record.get('CUSTOM_NAME'));
						stockForm.setValue('ORDER_DATE'		, record.get('ORDER_DATE'));
						stockForm.setValue('DVRY_DATE'		, record.get('DVRY_DATE'));
						stockForm.setValue('ITEM_CODE'		, record.get('ITEM_CODE'));
						stockForm.setValue('ITEM_NAME'		, record.get('ITEM_NAME'));
						stockForm.setValue('ORDER_Q'		, record.get('ORDER_Q'));
						stockForm.setValue('COMPLETE_Q'		, record.get('COMPLETE_Q'));
						stockForm.setValue('ORDER_REM_Q'	, record.get('ORDER_REM_Q'));
						stockStore.loadStoreRecords();
					}
				}
			})
		}
		stockQueryWindow.center();
		stockQueryWindow.show();
	}



	/** 자재소요량 및 현재고 (내용물)
	 */
	var stockForm2 = Unilite.createSearchForm('stockForm2', {
		layout		: {type : 'uniTable', columns : 3},
//		height		: 370,
//		width		: 800,
		region		: 'center',
		autoScroll	: true,
		border		: true,
		padding		: '0 0 0 0',
		xtype		: 'container',
		defaultType	: 'container',
		items:[{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			xtype		: 'uniTextfield',
			name		: 'DIV_CODE',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
			xtype		: 'uniTextfield',
			name		: 'OUT_DIV_CODE',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_CODE',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.customname" default="거래처명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_NAME',
			readOnly	: true,
			fieldStyle	: 'text-align: center;',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.sodate" default="수주일"/>',
			name		: 'ORDER_DATE',
			xtype		: 'uniDatefield',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			name		: 'DVRY_DATE',
			xtype		: 'uniDatefield',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.item" default="품목"/>',
			name		:'ITEM_CODE',
			xtype		: 'uniTextfield',
			readOnly	: true,
			fieldStyle	: 'text-align: center;'

		},{
			fieldLabel	: '',
			name		: 'ITEM_NAME',
			width		: 490,
			xtype		: 'uniTextfield',
			colspan		: 2,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.soqty" default="수주량"/>',
			name		: 'ORDER_Q',
			xtype		: 'uniNumberfield',
			type		: 'float',
			decimalPrecision: 6 ,
			format		: '0,000.000000',
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.completionQty" default="완료량"/>',
			name		: 'COMPLETE_Q',
			xtype		: 'uniNumberfield',
			type		: 'float',
			decimalPrecision: 6 ,
			format		: '0,000.000000',
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.undeliveryqty" default="미납량"/>',
			name		: 'ORDER_REM_Q',
			xtype		: 'uniNumberfield',
			type		: 'float',
			decimalPrecision: 6 ,
			format		: '0,000.000000',
			readOnly	: true
		}],
		setAllFieldsReadOnly: setAllFieldsReadOnly
	});

	/** 자재소요량 및 현재고 (내용물, 반제품)
	 */
	var stockForm3 = Unilite.createSearchForm('stockForm3', {
		layout		: {type : 'uniTable', columns : 3},
//		height		: 370,
//		width		: 800,
		region		: 'center',
		autoScroll	: true,
		border		: true,
		padding		: '0 0 0 0',
		xtype		: 'container',
		defaultType	: 'container',
		items:[{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			xtype		: 'uniTextfield',
			name		: 'DIV_CODE',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
			xtype		: 'uniTextfield',
			name		: 'OUT_DIV_CODE',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_CODE',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.customname" default="거래처명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_NAME',
			readOnly	: true,
			fieldStyle	: 'text-align: center;',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.sodate" default="수주일"/>',
			name		: 'ORDER_DATE',
			xtype		: 'uniDatefield',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			name		: 'DVRY_DATE',
			xtype		: 'uniDatefield',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.item" default="품목"/>',
			name		:'ITEM_CODE',
			xtype		: 'uniTextfield',
			readOnly	: true,
			fieldStyle	: 'text-align: center;'

		},{
			fieldLabel	: '',
			name		: 'ITEM_NAME',
			width		: 490,
			xtype		: 'uniTextfield',
			colspan		: 2,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.soqty" default="수주량"/>',
			name		: 'ORDER_Q',
			xtype		: 'uniNumberfield',
			type		: 'float',
			decimalPrecision: 6 ,
			format		: '0,000.000000',
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.completionQty" default="완료량"/>',
			name		: 'COMPLETE_Q',
			xtype		: 'uniNumberfield',
			type		: 'float',
			decimalPrecision: 6 ,
			format		: '0,000.000000',
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.undeliveryqty" default="미납량"/>',
			name		: 'ORDER_REM_Q',
			xtype		: 'uniNumberfield',
			type		: 'float',
			decimalPrecision: 6 ,
			format		: '0,000.000000',
			readOnly	: true
		}],
		setAllFieldsReadOnly: setAllFieldsReadOnly
	});

	/** 자재소요량 및 현재고 (내용물, 반제품)
	 */
	var stockForm4 = Unilite.createSearchForm('stockForm4', {
		layout		: {type : 'uniTable', columns : 3},
//		height		: 370,
//		width		: 800,
		region		: 'center',
		autoScroll	: true,
		border		: true,
		padding		: '0 0 0 0',
		xtype		: 'container',
		defaultType	: 'container',
		items:[{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			xtype		: 'uniTextfield',
			name		: 'DIV_CODE',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
			xtype		: 'uniTextfield',
			name		: 'OUT_DIV_CODE',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_CODE',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.customname" default="거래처명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_NAME',
			readOnly	: true,
			fieldStyle	: 'text-align: center;',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.sodate" default="수주일"/>',
			name		: 'ORDER_DATE',
			xtype		: 'uniDatefield',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			name		: 'DVRY_DATE',
			xtype		: 'uniDatefield',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.item" default="품목"/>',
			name		:'ITEM_CODE',
			xtype		: 'uniTextfield',
			readOnly	: true,
			fieldStyle	: 'text-align: center;'

		},{
			fieldLabel	: '',
			name		: 'ITEM_NAME',
			width		: 490,
			xtype		: 'uniTextfield',
			colspan		: 2,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.soqty" default="수주량"/>',
			name		: 'ORDER_Q',
			xtype		: 'uniNumberfield',
			type		: 'float',
			decimalPrecision: 6 ,
			format		: '0,000.000000',
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.completionQty" default="완료량"/>',
			name		: 'COMPLETE_Q',
			xtype		: 'uniNumberfield',
			type		: 'float',
			decimalPrecision: 6 ,
			format		: '0,000.000000',
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.undeliveryqty" default="미납량"/>',
			name		: 'ORDER_REM_Q',
			xtype		: 'uniNumberfield',
			type		: 'float',
			decimalPrecision: 6 ,
			format		: '0,000.000000',
			readOnly	: true
		}],
		setAllFieldsReadOnly: setAllFieldsReadOnly
	});

	Unilite.defineModel('stockModel2', {
		fields: [
			{name: 'SEQ'			, text: '순번'		, type: 'string'},
			{name: 'ITEM_ACCOUNT'	, text: '자재구분'		, type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'ITEM_CODE'		, text: '자재코드'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '자재명'		, type: 'string'},
			{name: 'STOCK_UNIT'		, text: '단위'		, type: 'string'},
			{name: 'USAGE'			, text: 'Usage'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'USAGE_RATE'		, text: '실사용률'		, type: 'uniPercent'},
			{name: 'NEED_Q'			, text: '필요량'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'REAL_NEED_Q'	, text: '실필요량'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'GOOD_STOCK_Q'	, text: '재고량'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'MATR_CUSTOM_CODE'		, text: '거래처'		, type: 'string'},
			{name: 'MATR_CUSTOM_NAME'		, text: '거래처명'		, type: 'string'}
		]
	});

	Unilite.defineModel('stockModel3', {
		fields: [
			{name: 'SEQ'			, text: '순번'		, type: 'string'},
			{name: 'ITEM_ACCOUNT'	, text: '자재구분'		, type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'ITEM_CODE'		, text: '자재코드'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '자재명'		, type: 'string'},
			{name: 'STOCK_UNIT'		, text: '단위'		, type: 'string'},
			{name: 'USAGE'			, text: 'Usage'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'USAGE_RATE'		, text: '실사용률'		, type: 'uniPercent'},
			{name: 'NEED_Q'			, text: '필요량'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'REAL_NEED_Q'	, text: '실필요량'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'GOOD_STOCK_Q'	, text: '재고량'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'MATR_CUSTOM_CODE'		, text: '거래처'		, type: 'string'},
			{name: 'MATR_CUSTOM_NAME'		, text: '거래처명'		, type: 'string'}
		]
	});

	Unilite.defineModel('stockModel4', {
		fields: [
			{name: 'SEQ'			, text: '순번'		, type: 'string'},
			{name: 'ITEM_ACCOUNT'	, text: '자재구분'		, type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'ITEM_CODE'		, text: '자재코드'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '자재명'		, type: 'string'},
			{name: 'STOCK_UNIT'		, text: '단위'		, type: 'string'},
			{name: 'USAGE'			, text: 'Usage'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'USAGE_RATE'		, text: '실사용률'		, type: 'uniPercent'},
			{name: 'NEED_Q'			, text: '필요량'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'REAL_NEED_Q'	, text: '실필요량'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'GOOD_STOCK_Q'	, text: '재고량'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'MATR_CUSTOM_CODE'		, text: '거래처'		, type: 'string'},
			{name: 'MATR_CUSTOM_NAME'		, text: '거래처명'		, type: 'string'}
		]
	});

	var stockStore2 = Unilite.createStore('stockStore2', {
		model	: 'stockModel2',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 's_sof150ukrv_kodiService.stockList'
			}
		},
		loadStoreRecords: function() {
			var param = stockForm2.getValues();
			console.log(param);
			this.load({
				params: param
			});
		}
	});

	var stockStore3 = Unilite.createStore('stockStore3', {
		model	: 'stockModel3',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 's_sof150ukrv_kodiService.stockList'
			}
		},
		loadStoreRecords: function() {
			var param = stockForm3.getValues();
			console.log(param);
			this.load({
				params: param
			});
		}
	});

	var stockStore4 = Unilite.createStore('stockStore4', {
		model	: 'stockModel4',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 's_sof150ukrv_kodiService.stockList'
			}
		},
		loadStoreRecords: function() {
			var param = stockForm4.getValues();
			console.log(param);
			this.load({
				params: param
			});
		}
	});

	var stockGrid2 = Unilite.createGrid('stockGrid2', {
		store	: stockStore2,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: true
		},
		columns: [
			{ dataIndex: 'SEQ'			, width: 50 },
			{ dataIndex: 'ITEM_ACCOUNT'	, width: 100},
			{ dataIndex: 'ITEM_CODE'	, width: 100},
			{ dataIndex: 'ITEM_NAME'	, width: 250},
			{ dataIndex: 'STOCK_UNIT'	, width: 70 , align: 'center'},
			{ dataIndex: 'USAGE'		, width: 80 },
			{ dataIndex: 'USAGE_RATE'	, width: 80 },
			{ dataIndex: 'NEED_Q'		, width: 100},
			{ dataIndex: 'REAL_NEED_Q'	, width: 100},
			{ dataIndex: 'GOOD_STOCK_Q'	, width: 100, hidden: true},
			{ dataIndex: 'MATR_CUSTOM_CODE'	, width: 100},
			{ dataIndex: 'MATR_CUSTOM_NAME'	, width: 250}
		],
		selModel: 'rowmodel',
		listeners: {
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';

				if(record.get('REAL_NEED_Q') > record.get('GOOD_STOCK_Q')){
					cls = 'x-change-celltext_red';
				}
				return cls;
			}
		}
	});

	var stockGrid3 = Unilite.createGrid('stockGrid3', {
		store	: stockStore3,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: true
		},
		columns: [
			{ dataIndex: 'SEQ'			, width: 50 },
			{ dataIndex: 'ITEM_ACCOUNT'	, width: 100},
			{ dataIndex: 'ITEM_CODE'	, width: 100},
			{ dataIndex: 'ITEM_NAME'	, width: 250},
			{ dataIndex: 'STOCK_UNIT'	, width: 70 , align: 'center'},
			{ dataIndex: 'USAGE'		, width: 80 },
			{ dataIndex: 'USAGE_RATE'	, width: 80 },
			{ dataIndex: 'NEED_Q'		, width: 100},
			{ dataIndex: 'REAL_NEED_Q'	, width: 100},
			{ dataIndex: 'GOOD_STOCK_Q'	, width: 100, hidden: true},
			{ dataIndex: 'MATR_CUSTOM_CODE'	, width: 100},
			{ dataIndex: 'MATR_CUSTOM_NAME'	, width: 250}
		],
		selModel: 'rowmodel',
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			var sItemAccount = record.get('ITEM_ACCOUNT');
			if(sItemAccount == '30' || sItemAccount == '50'|| sItemAccount == '20'){
					openStockQueryWindow4();
			}

			}
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';

				if(record.get('REAL_NEED_Q') > record.get('GOOD_STOCK_Q')){
					cls = 'x-change-celltext_red';
				}
				return cls;
			}
		}
	});

	var stockGrid4 = Unilite.createGrid('stockGrid4', {
		store	: stockStore4,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: true
		},
		columns: [
			{ dataIndex: 'SEQ'			, width: 50 },
			{ dataIndex: 'ITEM_ACCOUNT'	, width: 100},
			{ dataIndex: 'ITEM_CODE'	, width: 100},
			{ dataIndex: 'ITEM_NAME'	, width: 250},
			{ dataIndex: 'STOCK_UNIT'	, width: 70 , align: 'center'},
			{ dataIndex: 'USAGE'		, width: 80 },
			{ dataIndex: 'USAGE_RATE'	, width: 80 },
			{ dataIndex: 'NEED_Q'		, width: 100},
			{ dataIndex: 'REAL_NEED_Q'	, width: 100},
			{ dataIndex: 'GOOD_STOCK_Q'	, width: 100, hidden: true},
			{ dataIndex: 'MATR_CUSTOM_CODE'	, width: 100},
			{ dataIndex: 'MATR_CUSTOM_NAME'	, width: 250}
		],
		selModel: 'rowmodel',
		listeners: {


		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';

				if(record.get('REAL_NEED_Q') > record.get('GOOD_STOCK_Q')){
					cls = 'x-change-celltext_red';
				}
				return cls;
			}
		}
	});

	function openStockQueryWindow2() {
		if(!stockQueryWindow2) {
			stockQueryWindow2 = Ext.create('widget.uniDetailWindow', {
				title		: '<t:message code="system.message.sales.message127" default="자재소요량 및 현재고"/>',
				height		: 500,
				width		: 800,
				resizable	: false,
				layout		: {type:'vbox', align:'stretch'},
				items		: [stockForm2, stockGrid2],
				tbar		: ['->', {
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.confirm" default="확인"/>',
					handler	: function() {
						stockForm2.clearForm();
						stockQueryWindow2.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function( panel, eOpts ) {
						var record = masterGrid.getSelectedRecord();
						//품목에 대한 내용물의 실제 필요수량을 계산해서 set하기 위한 데이터
						var realQ = Unilite.multiply((record.get('UNIT_Q') / record.get('PROD_UNIT_Q')), (record.get('SET_QTY') / 100))
						stockForm2.setValue('DIV_CODE'		, record.get('DIV_CODE'));
						stockForm2.setValue('OUT_DIV_CODE'	, record.get('OUT_DIV_CODE'));
						stockForm2.setValue('CUSTOM_CODE'	, record.get('CUSTOM_CODE'));
						stockForm2.setValue('CUSTOM_NAME'	, record.get('CUSTOM_NAME'));
						stockForm2.setValue('ORDER_DATE'	, record.get('ORDER_DATE'));
						stockForm2.setValue('DVRY_DATE'		, record.get('DVRY_DATE'));
						stockForm2.setValue('ITEM_CODE'		, record.get('CHILD_ITEM_CODE'));
						stockForm2.setValue('ITEM_NAME'		, record.get('CHILD_ITEM_NAME'));
						stockForm2.setValue('ORDER_Q'		, Unilite.multiply(record.get('ORDER_Q')	, realQ));
						stockForm2.setValue('COMPLETE_Q'	, Unilite.multiply(record.get('COMPLETE_Q')	, realQ));
						stockForm2.setValue('ORDER_REM_Q'	, Unilite.multiply(record.get('ORDER_REM_Q'), realQ));
						stockStore2.loadStoreRecords();
					}
				}
			})
		}
		stockQueryWindow2.center();
		stockQueryWindow2.show();
	}

	function openStockQueryWindow3() {
		if(!stockQueryWindow3) {
			stockQueryWindow3 = Ext.create('widget.uniDetailWindow', {
				title		: '<t:message code="system.message.sales.message127" default="자재소요량 및 현재고"/>',
				height		: 500,
				width		: 800,
				resizable	: false,
				layout		: {type:'vbox', align:'stretch'},
				items		: [stockForm3, stockGrid3],
				tbar		: ['->', {
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.confirm" default="확인"/>',
					handler	: function() {
						stockForm3.clearForm();
						stockQueryWindow3.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function( panel, eOpts ) {
						var record = masterGrid.getSelectedRecord();
						var record2 = stockGrid.getSelectedRecord();
						//품목에 대한 내용물의 실제 필요수량을 계산해서 set하기 위한 데이터
						var realQ = Unilite.multiply((record.get('UNIT_Q') / record.get('PROD_UNIT_Q')), (record.get('SET_QTY') / 100))
						stockForm3.setValue('DIV_CODE'		, record.get('DIV_CODE'));
						stockForm3.setValue('OUT_DIV_CODE'	, record.get('OUT_DIV_CODE'));
						stockForm3.setValue('CUSTOM_CODE'	, record.get('CUSTOM_CODE'));
						stockForm3.setValue('CUSTOM_NAME'	, record.get('CUSTOM_NAME'));
						stockForm3.setValue('ORDER_DATE'	, record.get('ORDER_DATE'));
						stockForm3.setValue('DVRY_DATE'		, record.get('DVRY_DATE'));
						stockForm3.setValue('ITEM_CODE'		, record2.get('ITEM_CODE'));
						stockForm3.setValue('ITEM_NAME'		, record2.get('ITEM_NAME'));
						stockForm3.setValue('ORDER_Q'		, Unilite.multiply(record.get('ORDER_Q')	, realQ));
						stockForm3.setValue('COMPLETE_Q'	, Unilite.multiply(record.get('COMPLETE_Q')	, realQ));
						stockForm3.setValue('ORDER_REM_Q'	, Unilite.multiply(record.get('ORDER_REM_Q'), realQ));
						stockStore3.loadStoreRecords();
					}
				}
			})
		}
		stockQueryWindow3.center();
		stockQueryWindow3.show();
	}

	function openStockQueryWindow4() {
		if(!stockQueryWindow4) {
			stockQueryWindow4 = Ext.create('widget.uniDetailWindow', {
				title		: '<t:message code="system.message.sales.message127" default="자재소요량 및 현재고"/>',
				height		: 500,
				width		: 800,
				resizable	: false,
				layout		: {type:'vbox', align:'stretch'},
				items		: [stockForm4, stockGrid4],
				tbar		: ['->', {
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.confirm" default="확인"/>',
					handler	: function() {
						stockForm4.clearForm();
						stockQueryWindow4.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function( panel, eOpts ) {
						var record = masterGrid.getSelectedRecord();
						var record1 = stockGrid3.getSelectedRecord();
						//품목에 대한 내용물의 실제 필요수량을 계산해서 set하기 위한 데이터
						var realQ = Unilite.multiply((record.get('UNIT_Q') / record.get('PROD_UNIT_Q')), (record.get('SET_QTY') / 100))
						stockForm4.setValue('DIV_CODE'		, record.get('DIV_CODE'));
						stockForm4.setValue('OUT_DIV_CODE'	, record.get('OUT_DIV_CODE'));
						stockForm4.setValue('CUSTOM_CODE'	, record.get('CUSTOM_CODE'));
						stockForm4.setValue('CUSTOM_NAME'	, record.get('CUSTOM_NAME'));
						stockForm4.setValue('ORDER_DATE'	, record.get('ORDER_DATE'));
						stockForm4.setValue('DVRY_DATE'		, record.get('DVRY_DATE'));
						stockForm4.setValue('ITEM_CODE'		, record1.get('ITEM_CODE'));
						stockForm4.setValue('ITEM_NAME'		, record1.get('ITEM_NAME'));
						stockForm4.setValue('ORDER_Q'		, Unilite.multiply(record.get('ORDER_Q')	, realQ));
						stockForm4.setValue('COMPLETE_Q'	, Unilite.multiply(record.get('COMPLETE_Q')	, realQ));
						stockForm4.setValue('ORDER_REM_Q'	, Unilite.multiply(record.get('ORDER_REM_Q'), realQ));
						stockStore4.loadStoreRecords();
					}
				}
			})
		}
		stockQueryWindow4.center();
		stockQueryWindow4.show();
	}

	/** 품목정보 메인 - 20191107 품목정보 팝업 관련로직 추가
	 */
	Unilite.defineModel('itemInfoModel', {
		fields: [
			{name: 'COMP_CODE'	,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				,type: 'string'},
			{name: 'ITEM_CODE'	,text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'					,type: 'string'},
			//공통코드 생성 (B702 - 01:제품사진, 02:도면, 03:승인원)
			{name: 'FILE_TYPE'	,text: '<t:message code="system.label.base.classfication" default="구분"/>'				,type: 'string'	, allowBlank: false, comboType: 'AU', comboCode: 'B702'},
			{name: 'MANAGE_NO'	,text: '<t:message code="system.label.base.manageno" default="관리번호"/>'		 			,type: 'string'	, allowBlank: false},
			{name: 'REMARK'		,text: '<t:message code="system.label.base.remarks" default="비고"/>'			 			,type: 'string'},
			{name: 'CERT_FILE'	,text: '<t:message code="system.label.base.filename" default="파일명"/>'		 			,type: 'string'},
			{name: 'FILE_ID'	,text: '<t:message code="system.label.base.savedfilename" default="저장된 파일명"/>'			,type: 'string'},
			{name: 'FILE_PATH'	,text: '<t:message code="system.label.base.savedfilepath" default="저장된 파일경로"/>'	 		,type: 'string'},
			{name: 'FILE_EXT'	,text: '<t:message code="system.label.base.savedfileextension" default="저장된 파일확장자"/>'	,type: 'string'}
		]
	});

	var itemInfoStore = Unilite.createStore('itemInfoStore',{
		model	: 'itemInfoModel',
		proxy	: itemInfoProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function(itemCOde){
			var param= panelSearch.getValues();
			param.ITEM_CODE = itemCOde
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	 {
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
	});

	var itemInfoGrid = Unilite.createGrid('itemInfoGrid', {
		store	: itemInfoStore,
		border	: true,
		height	: 180,
		width	: 865,
		padding	: '0 0 5 0',
		sortableColumns : false,
		excelTitle: '<t:message code="system.label.base.referfile" default="관련파일"/>',
		uniOpt	:{
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false
//			enterKeyCreateRow	: true		//마스터 그리드 추가기능 삭제
		},
		columns:[
			{ dataIndex : 'COMP_CODE'	, width: 80	,hidden:true},
			{ dataIndex : 'ITEM_CODE'	, width: 80	,hidden:true},
			{ dataIndex : 'FILE_TYPE'	, width: 100},
			{ dataIndex : 'MANAGE_NO'	, width: 150},
			{ text	  : '<t:message code="system.label.base.photo" default="사진"/>',
				columns:[
					{ dataIndex : 'CERT_FILE'   , width: 230		, align: 'center'   ,
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
			{ dataIndex : 'REMARK'		, flex: 1	, minWidth: 30}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
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
					fid					= record.data.FILE_ID
					var fileExtension	= record.get('CERT_FILE').lastIndexOf( "." );
					var fileExt			= record.get('CERT_FILE').substring( fileExtension + 1 );
					if(fileExt == 'pdf') {
						var win = Ext.create('widget.CrystalReport', {
							url		: CPATH+'/fileman/downloadItemInfoImage/' + fid,
							prgID	: 'ppl113ukrv'
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

	function openItemInformationWindow() {
		if(!panelSearch.getInvalidMessage()) return;	//필수체크
		if(!referItemInformationWindow) {
			referItemInformationWindow = Ext.create('widget.uniDetailWindow',{
				title	: '제품정보 확인',
				layout	: {type:'vbox', align:'stretch'},
				items	: [itemInfoGrid],
				width	: 1200,
				height	: 580,
				tbar	: ['->',{
					text	: '<t:message code="system.label.product.close" default="닫기"/>',
					itemId	: 'closeBtn',
					id		: 'closeBtn2',
					handler	: function() {
						referItemInformationWindow.hide();
					},
					disabled: false
				}]
			})
		}
		referItemInformationWindow.show();
		referItemInformationWindow.center();
	}



	/** 품목정보 미리보기 - 20191107 품목정보 팝업 관련로직 추가
	 */
	function openPhotoWindow() {
		photoWin = Ext.create('widget.uniDetailWindow', {
			title		: '<t:message code="system.label.base.preview" default="미리보기"/>',
			modal		: true,
			resizable	: true,
			closable	: false,
			width		: '80%',
			height		: '100%',
			layout		: {
				type	: 'fit'
			},
			closeAction	: 'destroy',
			items		: [{
				xtype		: 'uniDetailForm',
				itemId		: 'downForm',
				url			: CPATH + "/fileman/downloadItemInfoImage/" + fid,
				layout		: {type: 'uniTable', columns:'1'},
				standardSubmit: true,
				disabled	: false,
				autoScroll	: true,
				items		: [{
					xtype	: 'image',
					itemId	: 'photView',
					autoEl	: {
						tag: 'img',
						src: CPATH+'/resources/images/human/noPhoto.png'
					}
				}]
			}],
			listeners : {
				beforeshow: function( window, eOpts) {
					window.down('#photView').setSrc(CPATH+'/fileman/downloadItemInfoImage/' + fid);
				},
				show: function( window, eOpts)  {
					window.center();
				}
			},
			tbar:['->',{
				xtype	: 'button',
				text	: '<t:message code="system.label.base.download" default="다운로드"/>',
				handler	: function() {
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
				xtype	: 'button',
				text	: '<t:message code="system.label.base.close" default="닫기"/>',
				handler	: function() {
					photoWin.down('#downForm').clearForm();
					photoWin.close();
					photoWin.hide();
				}
			}]
		});
		photoWin.show();
	}

	var photoForm = Ext.create('Unilite.com.form.UniDetailForm',{
		xtype		: 'uniDetailForm',
		disabled	: false,
		fileUpload	: true,
		itemId		: 'photoForm',
		api			: {
			submit : bpr300ukrvService.photoUploadFile
		},
		items		: [{
				xtype		: 'filefield',
				buttonOnly	: false,
				fieldLabel	: '<t:message code="system.label.base.photo" default="사진"/>',
				flex		: 1,
				name		: 'photoFile',
				id			: 'photoFile',
				buttonText	: '<t:message code="system.label.base.selectfile" default="파일선택"/>',
				width		: 270,
				labelWidth	: 70
			}
		]
	});

	function fnPhotoSave() {				//이미지 등록
		//조건에 맞는 내용은 적용 되는 로직
		var record		= itemInfoGrid.getSelectedRecord();
		var photoForm	= uploadWin.down('#photoForm').getForm();
		var param		= {
			ITEM_CODE	: record.data.ITEM_CODE,
			MANAGE_NO	: record.data.MANAGE_NO,
			FILE_TYPE	: record.data.FILE_TYPE
		}
		photoForm.submit({
			params	: param,
			waitMsg	: 'Uploading your files...',
			success	: function(form, action) {
				uploadWin.afterSuccess();
				gsNeedPhotoSave = false;
			}
		});
	}

	function openUploadWindow() {
		if(!uploadWin) {
			uploadWin = Ext.create('Ext.window.Window', {
				title		: '<t:message code="system.label.base.uploadphoto" default="사진등록"/>',
				closable	: false,
				closeAction : 'hide',
				modal		: true,
				resizable	: true,
				width		: 300,
				height		: 100,
				layout		: {
					type	: 'fit'
				},
				items		: [
					photoForm, {
						xtype		: 'uniDetailForm',
						itemId		: 'photoForm',
						disabled	: false,
						fileUpload	: true,
						api			: {
							submit: bpr300ukrvService.photoUploadFile
						},
						items		:[{
							xtype		: 'filefield',
							fieldLabel	: '<t:message code="system.label.base.photo" default="사진"/>',
							name		: 'photoFile',
							buttonText	: '<t:message code="system.label.base.selectfile" default="파일선택"/>',
							buttonOnly	: false,
							labelWidth	: 70,
							flex		: 1,
							width		: 270
						}]
					}
				],
				listeners : {
					beforeshow: function( window, eOpts) {
						var toolbar	= itemInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
						var record	= itemInfoGrid.getSelectedRecord();

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
				afterSuccess: function() {
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
					xtype	: 'button',
					text	: '<t:message code="system.label.base.upload" default="올리기"/>',
					handler : function() {
						var photoForm	= uploadWin.down('#photoForm');
						var toolbar		= itemInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave	= !toolbar[0].getComponent('sub_save4').isDisabled();

						if (Ext.isEmpty(photoForm.getValue('photoFile'))) {
							Unilite.messageBox('<t:message code="system.message.base.message002" default="업로드 할 파일을 선택하십시오."/>');
							return false;
						}
						//jpg파일만 등록 가능
						var filePath		= photoForm.getValue('photoFile');
						var fileExtension	= filePath.lastIndexOf( "." );
						var fileExt			= filePath.substring( fileExtension + 1 );
						if(fileExt != 'jpg' && fileExt != 'png' && fileExt != 'bmp' && fileExt != 'pdf') {
							Unilite.messageBox('<t:message code="system.message.base.message001" default="이미지 파일(jpg, png, bmp) 또는 pdf파일만 업로드 할 수 있습니다."/>');
							return false;
						}
						if(needSave) {
							gsNeedPhotoSave = needSave;
							itemInfoStore.saveStore();
						} else {
							fnPhotoSave();
						}
					}
				},{
					xtype	: 'button',
					text	: '<t:message code="system.label.base.close" default="닫기"/>',
					handler : function() {
						uploadWin.afterSavePhoto();
						uploadWin.hide();
					}
				}]
			});
		}
		uploadWin.show();
	}




	Unilite.Main({
		id			: 's_sof150ukrv_kodiApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function(param) {
			if(param && !Ext.isEmpty(param.ORDER_NUM) && !Ext.isEmpty(param.ORDER_DATE)) {
				gsOutDivCode = param.OUT_DIV_CODE
				panelSearch.setValue('DIV_CODE'		, param.DIV_CODE);
				panelSearch.setValue('ORDER_DATE_FR', param.ORDER_DATE);
				panelSearch.setValue('ORDER_DATE_TO', param.ORDER_DATE);
				panelSearch.setValue('FR_ORDER_NUM'	, param.ORDER_NUM);
				panelSearch.setValue('TO_ORDER_NUM'	, param.ORDER_NUM);
				panelSearch.setValue('SER_NO'		, param.SER_NO);
				panelSearch.setValue('LINK_FLAG'	, "Y");

				panelResult.setValue('DIV_CODE'		, param.DIV_CODE);
				panelResult.setValue('ORDER_DATE_FR', param.ORDER_DATE);
				panelResult.setValue('ORDER_DATE_TO', param.ORDER_DATE);
				panelResult.setValue('FR_ORDER_NUM'	, param.ORDER_NUM);
				panelResult.setValue('TO_ORDER_NUM'	, param.ORDER_NUM);
				panelResult.setValue('SER_NO'		, param.SER_NO);

				UniAppManager.app.onQueryButtonDown();
			} else {
				panelSearch.setValue('DIV_CODE',UserInfo.divCode);
				panelResult.setValue('DIV_CODE',UserInfo.divCode);
			}
			panelSearch.setValue('DIV_CODE','00');//수주미대응은 사업장 본사로 초기화
			panelResult.setValue('DIV_CODE','00')
			var pCombo	= panelSearch.getField('DIV_CODE');
			var combo 	= panelSearch.getField('ORDER_PRSN').filterByRefCode('refCode1', pCombo.getValue(), pCombo);

			var field = panelSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			gsInit = false;
		},
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function() {
			directMasterStore1.saveStore();
		}
	});



	function setAllFieldsReadOnly(b) {
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
				Unilite.messageBox(labelText+Msg.sMB083);
				invalid.items[0].focus();
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(true);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField')	;
						if(popupFC.holdable == 'hold') {
							popupFC.setReadOnly(true);
						}
					}
				})
			}
		} else {
			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) ) {
					if (item.holdable == 'hold') {
						item.setReadOnly(false);
					}
				}
				if(item.isPopupField) {
					var popupFC = item.up('uniPopupField')	;
					if(popupFC.holdable == 'hold' ) {
						item.setReadOnly(false);
					}
				}
			})
		}
		return r;
	}

	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			//Unilite.messageBox(type+ ' : ' + fieldName+ ' : ' +newValue+ ' : ' +oldValue+ ' : ' +record)
			var rv = true;

				switch(fieldName) {
					case "CLOSE_REASON" :
						if(!Ext.isEmpty(newValue))	{
							record.set('CLOSE_YN', 'Y');
							break;
						}else{
							record.set('CLOSE_YN', 'N');
							break;
						}
						break;

					case "CLOSE_YN" :
						break;
				}
			return rv;
		}
	}); // validator
};
</script>
