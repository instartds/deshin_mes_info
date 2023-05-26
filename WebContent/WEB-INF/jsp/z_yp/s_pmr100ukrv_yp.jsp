<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr100ukrv_yp"  >
	<t:ExtComboStore comboType="BOR120"  /> 								<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>						<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>						<!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"/>						<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="P002"/>						<!-- 특기사항 분류 -->
	<t:ExtComboStore comboType="AU" comboCode="P003"/>						<!-- 불량유형 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />			<!-- 작업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />			<!--창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >



var BsaCodeInfo = {
	gsManageLotNoYN	: '${gsManageLotNoYN}',		// 작업지시와 생산실적 LOT 연계여부 설정 값
	gsChkProdtDateYN: '${gsChkProdtDateYN}',	// 착수예정일 체크여부
	glEndRate		: '${glEndRate}',
	gsSumTypeCell	: '${gsSumTypeCell}',		// 재고합산유형 : 창고 Cell 합산
	gsMoldCode		: '${gsMoldCode}',			// 작업지시 설비여부
	gsEquipCode		: '${gsEquipCode}'			// 작업지시 금형여부
};
var activeGridId		= '';
var outDivCode			= UserInfo.divCode;
var checkDraftStatus	= false;
var masterSelectIdx		= 0;
var detailSelectIdx		= 0;
var outouProdtSave;								// 생산실적 자동입고
var gsProdtDate			= new Date()			// 생산일자 전역변수
var gsLotNo				= '';					// LOT_NO 채번관련 전역변수
var gsFlag				= true;

function appMain() {

	var isMoldCode = false;
	if(BsaCodeInfo.gsMoldCode=='N') {
		isMoldCode = true;
	}

	var isEquipCode = false;
	if(BsaCodeInfo.gsEquipCode=='N') {
		isEquipCode = true;
	}

	var gsSumTypeCell = false;
	if(BsaCodeInfo.gsSumTypeCell =='N')	{
		gsSumTypeCell = true;
	}


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 작업실적 등록
		api: {
			read: 's_pmr100ukrv_ypService.selectDetailList'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 제품
		api: {
			read	: 's_pmr100ukrv_ypService.selectDetailList2',
			update	: 's_pmr100ukrv_ypService.updateDetail2',
			create	: 's_pmr100ukrv_ypService.insertDetail2',
			destroy	: 's_pmr100ukrv_ypService.deleteDetail2',
			syncAll	: 's_pmr100ukrv_ypService.saveAll2'
		}
	});

	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 원재료
		api: {
			read	: 's_pmr100ukrv_ypService.selectDetailList3'//,
//			update	: 's_pmr100ukrv_ypService.updateDetail3',
//			create	: 's_pmr100ukrv_ypService.insertDetail3',
//			destroy	: 's_pmr100ukrv_ypService.deleteDetail3',
//			syncAll	: 's_pmr100ukrv_ypService.saveAll3'
		}
	});

	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 부산물
		api: {
			read	: 's_pmr100ukrv_ypService.selectDetailList4',
			update	: 's_pmr100ukrv_ypService.updateDetail4',
			create	: 's_pmr100ukrv_ypService.insertDetail4',
			destroy	: 's_pmr100ukrv_ypService.deleteDetail4',
			syncAll	: 's_pmr100ukrv_ypService.saveAll4'
		}
	});

	var directProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 상세
		api: {
			read	: 's_pmr100ukrv_ypService.selectDetailList5',
			update	: 's_pmr100ukrv_ypService.updateDetail5',
//			create	: 's_pmr100ukrv_ypService.insertDetail5',
			destroy	: 's_pmr100ukrv_ypService.deleteDetail5',
			syncAll	: 's_pmr100ukrv_ypService.saveAll5'
		}
	});





	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120' ,
			allowBlank	: false,
			holdable	: 'hold',
			value		: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
			 	}
			}
		},{
			fieldLabel		: '착수예정일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'PRODT_START_DATE_FR',
			endFieldName	: 'PRODT_START_DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			holdable		: 'hold',
			width			: 315,
			textFieldWidth	: 170,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},{
            fieldLabel  : '<t:message code="unilite.msg.sMS832" default="판매유형"/>',
            name        : 'ORDER_TYPE',
            comboType   : 'AU',
            comboCode   : 'S002',
            labelWidth  : 130,
            xtype       : 'uniCombobox',
            holdable    : 'hold',
            listeners   : {
                change: function(field, newValue, oldValue, eOpts) {
                    panelResult.setValue('ORDER_TYPE', newValue);
                }
            }
        },{
			xtype		: 'radiogroup',
			fieldLabel	: '상태',
			id			: 'rdoSelect2',
			labelWidth	: 130,
			colspan		: 2,
			items		: [{
				boxLabel	: '전체',
				name		: 'CONTROL_STATUS',
				holdable	: 'hold',
				inputValue	: '',
//				checked		: true,
				width		: 60
			},{
				boxLabel	: '진행',
				name		: 'CONTROL_STATUS',
				holdable	: 'hold',
				inputValue	: '2',
				width		: 60
			},{
				boxLabel	: '마감',
				name		: 'CONTROL_STATUS',
				holdable	: 'hold',
				inputValue	: '8',
				width		: 60
			},{
				boxLabel	: '완료',
				name		: 'CONTROL_STATUS',
				holdable	: 'hold',
				inputValue	: '9',
				width		: 60
			}],
			listeners: {
			}
		},{
			fieldLabel	: '작업장',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('wsList'),
	 		allowBlank	: false,
			holdable	: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
			 	}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '품목코드',
			textFieldName	: 'ITEM_NAME',
			valueFieldName	: 'ITEM_CODE',
			holdable		: 'hold',
			//validateBlank	: false,
			autoPopup : true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
					},
					scope: this
				},
				onClear: function(type)	{
					panelResult.setValue('ITEM_CODE', '');
					panelResult.setValue('ITEM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '작업지시번호(통합)',
			xtype		: 'uniTextfield',
			name		: 'TOP_WKORD_NUM',
			labelWidth	: 130,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype:'button',
			text:'일괄 작업실적 완료',
			margin :'0 0 2 50',
			handler:function()	{
				var inValidRecs2 = directMasterStore2.getInvalidRecords();
				var inValidRecs4 = directMasterStore4.getInvalidRecords();
				var inValidRecs5 = directMasterStore5.getInvalidRecords();

				var toCreate = directMasterStore2.getNewRecords();
				var toUpdate = directMasterStore2.getUpdatedRecords();

				if(directMasterStore2.isDirty() || directMasterStore4.isDirty() || directMasterStore5.isDirty() || UniAppManager.app._needSave()) {
					if(toCreate.length != 0 || toUpdate.length != 0) {
						var config = {
							batch:true
						};
						UniAppManager.app.onSaveDataButtonDown(config);
					}
				} else {
					alert('일괄 처리할 내용이 없습니다.');
				}
			}
		},{
			fieldLabel	: '작업지시번호(개별)',
			xtype		: 'uniTextfield',
			name		: 'WKORD_NUM',
			hidden		: true
		},{
			fieldLabel	: '작업지시량',
			xtype		: 'uniTextfield',
			name		: 'WKORD_Q',
			holdable	: 'hold',
			hidden		: true
		},{
			fieldLabel	: '공정코드',
			xtype		: 'uniTextfield',
			name		: 'PROG_WORK_CODE',
			holdable	: 'hold',
			hidden		: true
		},{
			fieldLabel	: '품목코드',
			xtype		: 'uniTextfield',
			name		: 'ITEM_CODE1',
			holdable	: 'hold',
			hidden		: true
		},{
			fieldLabel	: '생산실적번호',
			xtype		: 'uniTextfield',
			name		: 'PRODT_NUM',
			holdable	: 'hold',
			hidden		: true
		},{
			fieldLabel	: 'RESULT_TYPE',
			xtype		: 'uniTextfield',
			name		: 'RESULT_TYPE',
			hidden		: true
		},{
			fieldLabel	: 'RESULT_YN',
			xtype		: 'uniTextfield',
			name		: 'RESULT_YN',
			hidden		: true
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





	Unilite.defineModel('s_pmr100ukrv_ypDetailModel', {
		fields: [
			{name: 'CONTROL_STATUS'		,text: '상태'			,type:'string'		, comboType:"AU", comboCode:"P001"},
			{name: 'TOP_WKORD_NUM'		,text: '통합작지번호'		,type:'string'},
			{name: 'WKORD_NUM'			,text: '작업지시번호'		,type:'string'},
			{name: 'ITEM_CODE'			,text: '품목코드'		,type:'string'},
			{name: 'ITEM_NAME'			,text: '품목명'		,type:'string'},
			{name: 'SPEC'				,text: '규격'			,type:'string'},
			{name: 'STOCK_UNIT'			,text: '단위'			,type:'string'		, comboType: 'AU', comboCode: 'B013'},
			{name: 'WKORD_Q'			,text: '작업지시량'		,type:'uniQty'},
			{name: 'PRODT_START_DATE'	,text: '착수예정일'		,type:'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '작업완료일'		,type:'uniDate'},
			{name: 'REMARK'				,text: '비고'			,type:'string'},
			{name: 'PROJECT_NO'			,text: '프로젝트번호'		,type:'string'},
//			{name: 'PJT_CODE'			,text: '프로젝트번호'		,type:'string'},
			//Hidden: true
			{name: 'PROG_WORK_CODE'		,text: '공정코드'		,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '작업장코드'		,type:'string'},
			{name: 'WORK_Q'				,text: '작업량'		,type:'uniQty'},
			{name: 'PRODT_Q'			,text: '생산량'		,type:'uniQty'},
			{name: 'WK_PLAN_NUM'		,text: '작업계획번호'		,type:'string'},
			{name: 'LINE_END_YN'		,text: '최종공정유무'		,type:'string'},
			{name: 'WORK_END_YN'		,text: '마감여부'		,type:'string'},
			{name: 'LINE_SEQ'			,text: '공정순서'		,type:'string'},
			{name: 'PROG_UNIT'			,text: '공정실적단위'		,type:'string'		, comboType: 'AU', comboCode: 'B013'},
			{name: 'PROG_UNIT_Q'		,text: '공정원단위량'		,type:'uniQty'},
			{name: 'OUT_METH'			,text: '출고방법'		,type:'string'},
			{name: 'AB'					,text: ' '			,type:'string'},
			{name: 'LOT_NO'				,text: 'LOT NO'		,type:'string'},
			{name: 'RESULT_YN'			,text: '입고방법'		,type:'string'},
			{name: 'INSPEC_YN'			,text: '출하검사방법'		,type:'string'},
			{name: 'WH_CODE'			,text: '기준창고'		,type:'string'},
			{name: 'BASIS_P'			,text: '재고금액'		,type:'string'},
			{name: 'DIV_CODE'			,text: 'DIV_CODE'	,type:'string'}
		]
	});

	var directMasterStore = Unilite.createStore('s_pmr100ukrv_ypdirectMasterStore', {
		model	: 's_pmr100ukrv_ypDetailModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				masterGrid.getSelectionModel().select(masterSelectIdx);
				if(!Ext.isEmpty(records)) {
					panelResult.setAllFieldsReadOnly(true)
				}else {
					directMasterStore2.clearData();
					directMasterStore3.clearData();
					directMasterStore4.clearData();
					directMasterStore5.clearData();
				}
			 }
		},
		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				console.log("onStoreLoad");
				if(records) {
					if(records.length > 0){
						if (directMasterStore.isDirty() || directMasterStore2.isDirty() ||directMasterStore5.isDirty()) {
							UniAppManager.setToolbarButtons('save', true);
						}
						var msg = records.length + Msg.sMB001; 								//'건이 조회되었습니다.';
						UniAppManager.updateStatus(msg, true);
					}
				}
			}
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_pmr100ukrv_ypGrid', {
		store	: directMasterStore,
		itemId	: 's_pmr100ukrv_ypGrid',
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
			onLoadSelectFirst	: true,
			useRowNumberer		: true
		},
		selModel: 'rowmodel',
		columns	: [
			{dataIndex: 'CONTROL_STATUS'	, width: 80 },
			{dataIndex: 'TOP_WKORD_NUM'		, width: 120},
			{dataIndex: 'WKORD_NUM'			, width: 120},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 120},
			{dataIndex: 'SPEC'				, width: 120},
			{dataIndex: 'STOCK_UNIT'		, width: 80 },
			{dataIndex: 'WKORD_Q'			, width: 100},
			{dataIndex: 'PRODT_START_DATE'	, width: 100},
			{dataIndex: 'PRODT_END_DATE'	, width: 100},
			{dataIndex: 'REMARK'			, width: 160},

			{dataIndex: 'PROJECT_NO'		, width: 133	,hidden:true},
//			{dataIndex: 'PJT_CODE'			, width: 133	,hidden:true},
			{dataIndex: 'PROG_WORK_CODE'	, width: 100	,hidden:true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100	,hidden:true},
			{dataIndex: 'WORK_Q'			, width: 100	,hidden:true},
			{dataIndex: 'PRODT_Q'			, width: 100	,hidden:true},
			{dataIndex: 'WK_PLAN_NUM'		, width: 100	,hidden:true},
			{dataIndex: 'LINE_END_YN'		, width: 100	,hidden:true},
			{dataIndex: 'WORK_END_YN'		, width: 100	,hidden:true},
			{dataIndex: 'LINE_SEQ'			, width: 100	,hidden:true},
			{dataIndex: 'PROG_UNIT'			, width: 100	,hidden:true},
			{dataIndex: 'PROG_UNIT_Q'		, width: 100	,hidden:true},
			{dataIndex: 'OUT_METH'			, width: 100	,hidden:true},
			{dataIndex: 'AB'				, width: 100	,hidden:true},
			{dataIndex: 'LOT_NO'			, width: 133	,hidden:true},
			{dataIndex: 'RESULT_YN'			, width: 100	,hidden:true},
			{dataIndex: 'INSPEC_YN'			, width: 100	,hidden:true},
			{dataIndex: 'WH_CODE'			, width: 100	,hidden:true},
			{dataIndex: 'BASIS_P'			, width: 100	,hidden:true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
				 	return false;
				} else {
					return false;
				}
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ){
				if(!Ext.isEmpty(selectRecord)) {
					var record = selectRecord.data;
//					this.returnCell(record);

					directMasterStore2.loadStoreRecords(record);
					directMasterStore3.loadStoreRecords(record);
					directMasterStore4.loadStoreRecords(record);
					directMasterStore5.loadStoreRecords(record);
				}
				masterSelectIdx = index;
//				detailSelectIdx = 0;
		  	},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				UniAppManager.setToolbarButtons(['delete', 'newData'], false);
			},
			render: function(grid, eOpts) {
				var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					activeGridId = girdNm;
					UniAppManager.setToolbarButtons(['delete', 'newData'], false);
				});
			}
		},
		returnCell: function(record){
			if(record) {
//				var topWkordNum		= record.TOP_WKORD_NUM;
//				var wkordNum		= record.WKORD_NUM;
//				var wkordQ			= record.WKORD_Q;
//				var progWorkCode	= record.PROG_WORK_CODE;
//				var itemCode		= record.ITEM_CODE;
//				var prodtNum		= record.PRODT_NUM;
//				var resultYn		= record.RESULT_YN;

//				panelResult.setValue('TOP_WKORD_NUM'	, topWkordNum);
//				panelResult.setValue('WKORD_NUM'		, wkordNum);
//				panelResult.setValue('WKORD_Q'			, wkordQ);
//				panelResult.setValue('PROG_WORK_CODE'	, progWorkCode);
//				panelResult.setValue('ITEM_CODE1'		, itemCode);
//				panelResult.setValue('PRODT_NUM'		, prodtNum);
//				panelResult.setValue('RESULT_YN'		, resultYn);
			}
		}
	});





	/** 제품 정의
	 * @type
	 */
	Unilite.defineModel('s_pmr100ukrv_ypModel2', {								//PMP100T
		fields: [
			{name: 'CONTROL_STATUS'		,text: '상태'				,type:'string'		, comboType:"AU", comboCode:"P001"},
			{name: 'PRODT_DATE'			,text: '생산일'			,type:'uniDate'},
			{name: 'ITEM_CODE'			,text: '품목코드'			,type:'string'},
			{name: 'ITEM_NAME'			,text: '품목명'			,type:'string'},
			{name: 'SPEC'				,text: '규격'				,type:'string'},
			{name: 'PASS_Q'				,text: '생산량'			,type:'uniQty'},
			{name: 'SUM_Q'				,text: '생산량'			,type:'uniQty'		, allowBlank:false},
			{name: 'GOOD_WORK_Q'		,text: '양품량'			,type:'uniQty'		, allowBlank:false},
			{name: 'BAD_WORK_Q'			,text: '불량량'			,type:'uniQty'		/*, allowBlank:false*/},
			{name: 'JAN_Q'				,text: '생산잔량'			,type:'uniQty'},
			{name: 'IN_STOCK_Q'			,text: '입고수량'			,type:'uniQty'		, allowBlank:true},
			{name: 'LOT_NO'				,text: 'LOT NO'			,type:'string'},
			//Hidden:true
			{name: 'MAN_HOUR'			,text: '투입공수'			,type:'uniQty'},
			{name: 'PROG_WKORD_Q'		,text: '작업지시량'			,type:'uniQty'},
			{name: 'PRODT_SUM'			,text: '생산누계'			,type:'uniQty'},
			{name: 'REMARK'				,text: '비고'				,type:'string'},
			{name: 'PROJECT_NO'			,text: '관리번호'			,type:'string'},
			{name: 'PJT_CODE'			,text: '프로젝트번호'			,type:'string'},
			{name: 'FR_SERIAL_NO'		,text: 'SERIAL NO(FR)'	,type:'string'},
			{name: 'TO_SERIAL_NO'		,text: 'SERIAL NO(TO)'	,type:'string'},
			{name: 'TOP_WKORD_NUM'		,text: '(통합)작업지시번호'	,type:'string'},
			{name: 'WKORD_NUM'			,text: '작업지시번호'			,type:'string'},
			{name: 'PRODT_NUM'			,text: '생산실적번호'			,type:'string'},
			{name: 'PROG_WORK_CODE'		,text: '공정코드'			,type:'string'},
			{name: 'UPDATE_DB_USER'		,text: '수정자'			,type:'string'},
			{name: 'UPDATE_DB_TIME'		,text: '수정일'			,type:'uniDate'},
			{name: 'COMP_CODE'			,text: '회사코드'			,type:'string'},
			{name: 'DIV_CODE' 			,text: '사업장'			,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '작업장'			,type:'string'},
			{name: 'ITEM_CODE'			,text: '품목코드'			,type:'string'},
			{name: 'CONTROL_STATUS' 	,text: 'CONTROL_STATUS'	,type:'string'},
			{name: 'GOOD_WH_CODE'		,text: '양품입고창고'			,type:'string'		, allowBlank:false		, store: Ext.data.StoreManager.lookup('whList')},
			{name: 'GOOD_PRSN' 			,text: '양품입고담당'			,type:'string'		, allowBlank:false		, comboType:"AU", comboCode:"B024"},
			{name: 'BAD_WH_CODE' 		,text: '불량입고창고'			,type:'string'		, allowBlank:false		, store: Ext.data.StoreManager.lookup('whList')},
			{name: 'BAD_PRSN'			,text: '불량입고담당'			,type:'string'		, allowBlank:false		, comboType:"AU", comboCode:"B024"},
			{name: 'LINE_END_YN'		,text: '최종공정여부'			,type:'string'},
			{name: 'RESULT_YN'			,text: '입고방법'			,type:'string'}
		]
	});

	/** 원재료
	 * @type
	 */
	Unilite.defineModel('s_pmr100ukrv_ypModel3', {								//S_PMP201T_YP
		fields: [
			{name: 'FLAG'				,text: 'FLAG'			,type:'string'},
			{name: 'CONTROL_STATUS'		,text: '상태'				,type:'string'		, comboType:"AU", comboCode:"P001"},
			{name: 'COMP_CODE'			,text: 'COMP_CODE'		,type:'string'},
			{name: 'DIV_CODE'			,text: 'DIV_CODE'		,type:'string'},
			{name: 'TOP_WKORD_NUM'		,text: '(통합)작업지시번호'	,type:'string'},
			{name: 'WKORD_NUM'			,text: '작업지시번호'			,type:'string'},

			{name: 'ITEM_CODE'			,text: '품목코드'			,type:'string'},
			{name: 'ITEM_NAME'			,text: '품목명'			,type:'string'},
			{name: 'SPEC'				,text: '규격'				,type:'string'},
			{name: 'STOCK_UNIT'			,text: '단위'				,type:'string'		, comboType: 'AU', comboCode: 'B013'},

			{name: 'REF_TYPE'			,text: '요청구분'			,type:'string'},
			{name: 'PATH_CODE'			,text: 'BOM path'		,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '작업장'			,type:'string'},
			{name: 'ALLOCK_Q'			,text: '예약량'			,type:'uniQty'},
			{name: 'OUTSTOCK_REQ_DATE'	,text: '출고요청일'			,type:'uniDate'},
			{name: 'OUTSTOCK_REQ_Q'		,text: '출고요청량'			,type:'uniQty'},
			{name: 'UNIT_Q'				,text: '원단위량'			,type:'uniQty'},
			{name: 'LOSS_RATE'			,text: 'LOSS율'			,type:'uniPercent'},
			{name: 'OUTSTOCK_NUM'		,text: '출고요청번호'			,type:'string'},
			{name: 'OUT_METH'			,text: '출고방법'			,type:'string'},
			{name: 'REF_ITEM_CODE'		,text: '참조품목코드'			,type:'string'},
			{name: 'EXCHG_YN'			,text: '대체품여부'			,type:'string'},
			{name: 'REMARK'				,text: '비고'				,type:'string'},
			{name: 'PROJECT_NO'			,text: '프로젝트 번호'		,type:'string'},
			{name: 'PJT_CODE'			,text: '프로젝트 코드'		,type:'string'},
			{name: 'LOT_NO'				,text: 'LOT NO'			,type:'string'},
			{name: 'GRANT_TYPE'			,text: '사급구분'			,type:'string'},
			{name: 'WH_CODE'			,text: '가공창고'			,type:'string'},
			{name: 'INOUT_Q'            ,text: '생산출고 수량'        ,type:'uniQty'},
			{name: 'PRODT_Q'			,text: '생산잔량'	     	,type:'uniQty'},
			{name: 'ONHAND_Q'			,text: '현재고량'			,type:'uniQty'},
			{name: 'IN_PLAN_Q'			,text: '입고예정량'			,type:'uniQty'},
			{name: 'OUT_PLAN_Q'			,text: '출고예정량'			,type:'uniQty'},
			{name: 'PREV_ALLOCK_Q'		,text: '이전 예약량'			,type:'uniQty'},
			{name: 'PRODT_YEAR'			,text: '생산년도'			,type:'string'},
			{name: 'EXP_DATE'			,text: '유통기한'			,type:'uniDate'},

//			{name: 'WKORD_Q'			,text: '수량'				,type:'uniQty'},
			{name: 'LOT_NO'				,text: 'LOT'			,type:'string'}
		]
	});

	/** 부산물
	 * @type
	 */
	Unilite.defineModel('s_pmr100ukrv_ypModel4', {
		fields: [
			{name: 'COMP_CODE'			,text: 'COMP_CODE'			,type:'string'		, allowBlank: false},
			{name: 'DIV_CODE'			,text: '사업장'				,type:'string'		, allowBlank: false},
			{name: 'PRODT_SEQ'			,text: '실적순번'				,type:'int'   },
			{name: 'WORK_SHOP_CODE'		,text: '작업장코드'				,type:'string'		, allowBlank: false},
			{name: 'TOP_WKORD_NUM'		,text: '통합작지번호'				,type:'string'		, allowBlank: false},
			{name: 'WKORD_NUM'			,text: '작지번호'				,type:'string'},
			{name: 'ITEM_CODE'			,text: '품목코드'				,type:'string'		, allowBlank: false},
			{name: 'ITEM_NAME'			,text: '품목명'				,type:'string'		, allowBlank: false},
			{name: 'SPEC'				,text: '규격'					,type:'string'},
			{name: 'STOCK_UNIT'			,text: '단위'					,type:'string'		, comboType: 'AU', comboCode: 'B013'},
			{name: 'PRODT_DATE'			,text: '생산일자'				,type:'uniDate'		, allowBlank: false},
			{name: 'PRODT_Q'			,text: '수량'					,type:'uniQty'		, allowBlank: false},		//작업실적량
			{name: 'GOOD_PRODT_Q'		,text: '양품실적량'				,type:'uniQty'},
			{name: 'BAD_PRODT_Q'		,text: '불량실적량'				,type:'uniQty'},
			{name: 'CONTROL_STATUS'		,text: '진행상태'				,type:'string'},
			{name: 'IN_STOCK_Q'			,text: '부산물입고수량'			,type:'uniQty'},
			{name: 'REMARK'				,text: '비고'					,type:'string'},
			{name: 'WH_CODE'			,text: '양품입고창고'				,type:'string'		, allowBlank: false		, store: Ext.data.StoreManager.lookup('whList')},
			{name: 'PROJECT_NO'			,text: 'Project No.'		,type:'string'},
			{name: 'PJT_CODE'			,text: '프로젝트 코드'			,type:'string'},
			{name: 'LOT_NO'				,text: 'LOT No.'			,type:'string'},
			{name: 'FR_SERIAL_NO'		,text: 'Serial No.(FROM)'	,type:'string'},
			{name: 'TO_SERIAL_NO'		,text: 'Serial No.(TO)'		,type:'string'},
			{name: 'INOUT_NUM'			,text: '수불번호'				,type:'string'},
			{name: 'INOUT_SEQ'			,text: '수불순번'				,type:'string'}
		]
	});

	/** 상세
	 * @type
	 */
	Unilite.defineModel('s_pmr100ukrv_ypModel5', {								//PMP200T
		fields: [
			{name: 'FLAG'				,text: 'FLAG'			,type:'string'},
			{name: 'CONTROL_STATUS'		,text: '상태'				,type:'string'		, comboType:"AU", comboCode:"P001"},
			{name: 'COMP_CODE'			,text: 'COMP_CODE'		,type:'string'},
			{name: 'DIV_CODE'			,text: 'DIV_CODE'		,type:'string'},
			{name: 'TOP_WKORD_NUM'		,text: '(통합)작업지시번호'	,type:'string'},
			{name: 'WKORD_NUM'			,text: '작업지시번호'			,type:'string'},

			{name: 'ITEM_CODE'			,text: '품목코드'			,type:'string'},
			{name: 'ITEM_NAME'			,text: '품목명'			,type:'string'},
			{name: 'SPEC'				,text: '규격'				,type:'string'},
			{name: 'STOCK_UNIT'			,text: '단위'				,type:'string'		, comboType: 'AU', comboCode: 'B013'},

			{name: 'REF_TYPE'			,text: '요청구분'			,type:'string'},
			{name: 'PATH_CODE'			,text: 'BOM path'		,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '작업장'			,type:'string'},
			{name: 'ALLOCK_Q'			,text: '예약량'			,type:'uniQty'},
			{name: 'OUTSTOCK_REQ_DATE'	,text: '출고요청일'			,type:'uniDate'},
			{name: 'OUTSTOCK_REQ_Q'		,text: '수량'				,type:'uniQty'},		//출고요청량
			{name: 'UNIT_Q'				,text: '원단위량'			,type:'uniQty'},
			{name: 'LOSS_RATE'			,text: 'LOSS율'			,type:'uniPercent'},
			{name: 'OUTSTOCK_NUM'		,text: '출고요청번호'			,type:'string'},
			{name: 'OUT_METH'			,text: '출고방법'			,type:'string'},
			{name: 'REF_ITEM_CODE'		,text: '참조품목코드'			,type:'string'},
			{name: 'EXCHG_YN'			,text: '대체품여부'			,type:'string'},
			{name: 'REMARK'				,text: '비고'				,type:'string'},
			{name: 'PROJECT_NO'			,text: '프로젝트 번호'		,type:'string'},
			{name: 'PJT_CODE'			,text: '프로젝트 코드'		,type:'string'},
			{name: 'LOT_NO'				,text: 'LOT NO'			,type:'string'},
			{name: 'GRANT_TYPE'			,text: '사급구분'			,type:'string'},
			{name: 'WH_CODE'			,text: '가공창고'			,type:'string'},
			{name: 'PRODT_Q'			,text: '생산출고 수량'		,type:'uniQty'},
			{name: 'ONHAND_Q'			,text: '재고수량'			,type:'uniQty'},		//자재예약시 현재고량
			{name: 'IN_PLAN_Q'			,text: '입고예정량'			,type:'uniQty'},
			{name: 'OUT_PLAN_Q'			,text: '출고예정량'			,type:'uniQty'},
			{name: 'PREV_ALLOCK_Q'		,text: '이전 예약량'			,type:'uniQty'},
			{name: 'PRODT_YEAR'			,text: '생산년도'			,type:'string'},
			{name: 'EXP_DATE'			,text: '유통기한'			,type:'uniDate'},
			{name: 'INOUT_DATE'			,text: '수불발생일'			,type:'uniDate'},

			{name: 'LABEL_Q'			,text: '라벨수량'			,type:'uniQty'},
			{name: 'TMP_TIME'			,text: 'TMP_TIME'		,type:'string'}
		]
	});





	var directMasterStore2 = Unilite.createStore('s_pmr100ukrv_ypMasterStore2',{
		model	: 's_pmr100ukrv_ypModel2',
		proxy	: directProxy2,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},

		autoLoad: false,
		loadStoreRecords : function(record)	{
			var param= panelResult.getValues();
			param.TOP_WKORD_NUM	= record.TOP_WKORD_NUM
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			paramMaster.KEY_VALUE = config;

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						directMasterStore3.commitChanges();

						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.app.onQueryButtonDown();
					},
					failure: function(batch, option) {
						var records = directMasterStore5.data.items
						Ext.each(records, function(record,i) {
							record.set('TMP_TIME', new Date())
						});
					}
				};
				Ext.getBody().mask('저장중...');
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr100ukrv_ypGrid2');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				if(records) {
					Ext.each(records, function(record,i) {
						//LOT_NO 없으면 채번하여 입력
						if (Ext.isEmpty(record.get('LOT_NO'))) {
							gsLotNo = fnCreateLotNo(UniDate.getDbDateStr(new Date()));
							record.set('LOT_NO', gsLotNo);
						};
						if(record.get('CONTROL_STATUS') == '2' && record.get('JAN_Q') > '0') {
							var janQ = record.get('JAN_Q');
							record.set('SUM_Q', janQ);
							record.set('GOOD_WORK_Q', janQ);
							record.set('JAN_Q', 0);
						};
					});
				}
			}
		},

		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				console.log("onStoreLoad");
				if(records) {
					if(records.length > 0){
						if (directMasterStore.isDirty() || directMasterStore2.isDirty() ||directMasterStore5.isDirty()) {
							UniAppManager.setToolbarButtons('save'	, true);
							UniAppManager.setToolbarButtons('delete', false);
						}
					}
				}
			}
		}
	});

	var directMasterStore3 = Unilite.createStore('s_pmr100ukrv_ypMasterStore3',{
		model	: 's_pmr100ukrv_ypModel3',
		proxy	: directProxy3,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function(record)	{
			var param			= panelResult.getValues();
			param.TOP_WKORD_NUM	= record.TOP_WKORD_NUM
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						/*var records = masterGrid3.getStore().getData();
						Ext.each(records, function(record,i) {
							masterGrid3.setOutouProdtSave(record);
						});*/
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr100ukrv_ypGrid3');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			 load: function(store, records, successful, eOpts) {
			 	if(records) {
					Ext.each(records, function(record,i) {
						if(record.get('CONTROL_STATUS') == '2' && record.get('PRODT_Q') > '0') {
							record.set('FLAG', 'N');
//							record.phantom = true;
						}
					});
				}
				masterGrid3.getSelectionModel().select(detailSelectIdx);
			}
		},

		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				console.log("onStoreLoad");
				if(records) {
					if(records.length > 0){
						if (directMasterStore.isDirty() || directMasterStore2.isDirty() ||directMasterStore5.isDirty()) {
							UniAppManager.setToolbarButtons('save'	, true);
							UniAppManager.setToolbarButtons('delete', false);
						}
					}
				}
			}
		}
	});

	var directMasterStore4 = Unilite.createStore('s_pmr100ukrv_ypMasterStore4',{
		model	: 's_pmr100ukrv_ypModel4',
		proxy	: directProxy4,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function(record)	{
			var param= panelResult.getValues();
			param.TOP_WKORD_NUM	= record.TOP_WKORD_NUM
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
//				var record = masterGrid3.getSelectedRecord();
//				if(store.data.length == '0') {
//					record.set('FLAG', 'N');
//				} else if(record.get('JAN_Q') != 0 && store.data.length != '0') {
//					record.set('FLAG', 'U');
//				} else {
//					record.set('FLAG', '');
//				}
			}
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();

			//1. 마스터 정보 파라미터 구성
			var paramMaster			= panelResult.getValues();	//syncAll 수정
			//부산물이 추가되었을 경우, 수불번호 자동채번을 위한 생산일자 변수처리
			if(directMasterStore4.data.length > 0) {
				paramMaster.PRODT_DATE	= UniDate.getDbDateStr(directMasterStore4.data.items[0].data.PRODT_DATE);
			}

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						if(directMasterStore5.isDirty()) {			// 원재료(자재예약 table)
							directMasterStore5.saveStore();

						} else if(directMasterStore2.isDirty()) {	// 제품
							directMasterStore2.saveStore();

						} else {
							UniAppManager.setToolbarButtons('save', false);
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr100ukrv_ypGrid4');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},

		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				console.log("onStoreLoad");
				if(records) {
					if (directMasterStore.isDirty() || directMasterStore2.isDirty() ||directMasterStore5.isDirty()) {
						UniAppManager.setToolbarButtons('save'	, true);
						UniAppManager.setToolbarButtons('delete', false);
					}
				}
			}
		}
	});

	var directMasterStore5 = Unilite.createStore('s_pmr100ukrv_ypMasterStore5',{
		model: 's_pmr100ukrv_ypModel5',
		proxy: directProxy5,
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function(record)	{
			var param= panelResult.getValues();
			param.TOP_WKORD_NUM	= record.TOP_WKORD_NUM
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					useSavedMessage : false,
					success	: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						var KeyValue = master.KEY_VALUE;

						if(directMasterStore2.isDirty()) {	// 자재예약
							directMasterStore2.saveStore(KeyValue);

							if(!gsFlag) {
								var records = directMasterStore5.data.items
								Ext.each(records, function(record,i) {
									record.set('TMP_TIME', new Date())
								});
								flag = true;
							}

						} else {
							//3.기타 처리
							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							console.log("set was dirty to false");
							directMasterStore3.commitChanges();
							UniAppManager.setToolbarButtons('save', false);
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr100ukrv_ypGrid5');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			 load: function(store, records, successful, eOpts) {
			 	if(records) {
					Ext.each(records, function(record,i) {
						if(record.get('CONTROL_STATUS') == '2' && record.get('PRODT_Q') > '0') {
							record.set('FLAG', 'N');

							//생산실적과 동일한 작업지시 row 저장되도록 강제 처리
							var d2records = directMasterStore2.data.items;
							Ext.each(d2records, function(d2record,i) {
								if(record.get('TOP_WKORD_NUM') == d2record.get('TOP_WKORD_NUM') && record.get('WKORD_NUM') == d2record.get('WKORD_NUM')/*UniAppManager.app._needSave()*/)	{
									d2record.set('UPDATE_DB_TIME', new Date());
								}
							});
						}
					});

				}
				masterGrid3.getSelectionModel().select(detailSelectIdx);
			}
		},

		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				console.log("onStoreLoad");
				if(records) {
					if(records.length > 0){
						if (directMasterStore.isDirty() || directMasterStore2.isDirty() ||directMasterStore5.isDirty()) {
							UniAppManager.setToolbarButtons('save'	, true);
							UniAppManager.setToolbarButtons('delete', false);
						}
					}
				}
			}
		}
	});





	//제품
	var masterGrid2 = Unilite.createGrid('s_pmr100ukrv_ypGrid2', {
		store	: directMasterStore2,
		itemId	: 's_pmr100ukrv_ypGrid2',
		layout	: 'fit',
		region	: 'center',
		title	: '제품',
		flex	: 1.2,
		uniOpt:{
			expandLastColumn	: false,
			useRowNumberer		: true,
			onLoadSelectFirst	: false,
			useMultipleSorting	: true
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'PRODT_DATE'		, width: 80,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
				}
			},
			{dataIndex: 'WKORD_NUM'			, width: 115},
			{dataIndex: 'COMP_CODE'			, width: 80		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 80		, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'ITEM_NAME'			, width: 120	, hidden: false},
			{dataIndex: 'SPEC'				, width: 93		, hidden: true},
			{dataIndex: 'PROG_WKORD_Q'      , width: 93     , hidden: true},
			{dataIndex: 'PASS_Q'            , width: 93     , hidden: true},
			{dataIndex: 'SUM_Q'				, width: 93		, summaryType:'sum'},
			{dataIndex: 'GOOD_WORK_Q'		, width: 93		, summaryType:'sum'},
			{dataIndex: 'BAD_WORK_Q'		, width: 93		, summaryType:'sum'},
			{dataIndex: 'MAN_HOUR'			, width: 93		, hidden: true},
			{dataIndex: 'PROG_WKORD_Q'		, width: 93		, hidden: true},
			{dataIndex: 'PRODT_SUM'			, width: 93		, hidden: true},
			{dataIndex: 'JAN_Q'				, width: 93		, summaryType:'sum'},
			{dataIndex: 'IN_STOCK_Q'		, width: 93},
			{dataIndex: 'LOT_NO'			, width: 133},
			{dataIndex: 'REMARK'			, width: 133	, hidden: true},
			{dataIndex: 'PROJECT_NO'		, width: 93		, hidden: true},
			{dataIndex: 'PJT_CODE'	 		, width: 93		, hidden: true},
			{dataIndex: 'FR_SERIAL_NO'		, width: 105	, hidden: true},
			{dataIndex: 'TO_SERIAL_NO'		, width: 105	, hidden: true},
			{dataIndex: 'PRODT_NUM'			, width: 90		, hidden: true},
			{dataIndex: 'PROG_WORK_CODE'	, width: 80		, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width: 80		, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 80		, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 80		, hidden: true},
			{dataIndex: 'CONTROL_STATUS'	, width: 80		, hidden: true},
			{dataIndex: 'GOOD_WH_CODE'		, width: 80		, hidden: false},
			{dataIndex: 'GOOD_PRSN'			, width: 80		, hidden: false},
			{dataIndex: 'BAD_WH_CODE'		, width: 80		, hidden: false},
			{dataIndex: 'BAD_PRSN'			, width: 80		, hidden: false},
			{dataIndex: 'RESULT_YN'			, width: 80		, hidden: false},
			{dataIndex: 'TOP_WKORD_NUM'		, width: 80		, hidden: true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.data.CONTROL_STATUS == '2') {
					if(UniUtils.indexOf(e.field, ['PRODT_DATE', 'SUM_Q', 'GOOD_WORK_Q', 'BAD_WORK_Q', 'GOOD_WH_CODE', 'GOOD_PRSN', 'BAD_WH_CODE', 'BAD_PRSN'/*, 'JAN_Q', 'IN_STOCK_Q'*/])){
						return true;
					} else {
						return false;
					}
				} else {
					return false;
				}
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				masterGrid5.getNavigationModel().setPosition(rowIndex, 0);
				masterGrid5.getSelectionModel().select(rowIndex);
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ) {
				UniAppManager.setToolbarButtons([/*'newData', */'delete'], true);
			},
			render: function(grid, eOpts) {
				var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					activeGridId = girdNm;
					UniAppManager.setToolbarButtons([/*'newData', */'delete'], true);
				});
			},
			edit : function( editor, context, eOpts ) {
				if (UniUtils.indexOf(context.field, ['PRODT_DATE'])) {
					if(context.value == context.originalValue) return false;

					//생산일자 변경에 따른 LOT_NO 재생성 / 생산일자, LOT_NO 변경 작업
					gsProdtDate	= context.record.get('PRODT_DATE')
//					gsLotNo		= fnCreateLotNo(UniDate.getDbDateStr(gsProdtDate));

					//masterGrid2(원자재 그리드) 값 변경
					var records2 = directMasterStore2.data.items;
					Ext.each(records2, function(record2, i) {
						record2.set('PRODT_DATE'	, gsProdtDate);
//						record2.set('LOT_NO'		, gsLotNo);
					});

					//masterGrid4(부산물 그리드) 값 변경
					var records4 = directMasterStore4.data.items;
					Ext.each(records4, function(record4, i) {
						record4.set('PRODT_DATE'	, gsProdtDate);
//						record4.set('LOT_NO'		, gsLotNo);
					});

					//자품목 그리드 값 변경
					var records5 = directMasterStore5.data.items;
					Ext.each(records5, function(record5, i) {
//						if(record5.data.WKORD_NUM == context.record.get('WKORD_NUM')) {
							record5.set('INOUT_DATE'	, gsProdtDate);
//						}
					});
				}
			}
		},
		setOutouProdtSave: function(grdRecord) {
			grdRecord.set('GOOD_WH_CODE'	, outouProdtSaveSearch.getValue('GOOD_WH_CODE'));
			grdRecord.set('GOOD_PRSN' 		, outouProdtSaveSearch.getValue('GOOD_PRSN'));
			grdRecord.set('BAD_WH_CODE' 	, outouProdtSaveSearch.getValue('BAD_WH_CODE'));
			grdRecord.set('BAD_PRSN'		, outouProdtSaveSearch.getValue('BAD_PRSN'));
		}
	});

	//원재료
	var masterGrid3 = Unilite.createGrid('s_pmr100ukrv_ypGrid3', {
		store	: directMasterStore3,
		itemId	: 's_pmr100ukrv_ypGrid3',
		layout	: 'fit',
		region	: 'center',
		title	: '원재료',
		flex	: 1,
		uniOpt	:{
			expandLastColumn	: true,
			useRowNumberer		: true,
			onLoadSelectFirst	: false,
			useMultipleSorting	: true
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'FLAG'				, width: 35			, hidden: true},
//			{dataIndex: 'CAVITY'			, width: 35, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 120},
			{dataIndex: 'SPEC'				, width: 93},
			{dataIndex: 'STOCK_UNIT'		, width: 80 },
			{dataIndex: 'INOUT_Q'           , width: 100},
			{dataIndex: 'PRODT_Q'			, width: 100},
			{dataIndex: 'ALLOCK_Q'			, width: 100		, hidden: true},
			{dataIndex: 'PREV_ALLOCK_Q'		, width: 100		, hidden: true},
			{dataIndex: 'LOT_NO'			, width: 133},
			{dataIndex: 'TOP_WKORD_NUM'		, width: 100		, hidden: true},
			{dataIndex: 'CONTROL_STATUS'	, width: 80			, hidden: true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.data.CONTROL_STATUS == '2') {
					/* if(UniUtils.indexOf(e.field, ['PRODT_Q'])){
						return true;
					} else {
						return false;
					} */
					return false;
				} else {
					return false;
				}
			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
				}
		  	},
			select: function(grid, selectRecord, index, rowIndex, eOpts ){
				detailSelectIdx = index;
				UniAppManager.setToolbarButtons(['newData', 'delete'], false);
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			},
			render: function(grid, eOpts) {
				var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					activeGridId = girdNm;
					UniAppManager.setToolbarButtons(['newData', 'delete'], false);
				});
			}
		},
		setOutouProdtSave: function(record) {
//			record.set('GOOD_WH_CODE'  			, outouProdtSaveSearch.getValue('GOOD_WH_CODE'));
//			record.set('GOOD_WH_CELL_CODE'	 , outouProdtSaveSearch.getValue('GOOD_WH_CELL_CODE'));
//			record.set('GOOD_PRSN' 				, outouProdtSaveSearch.getValue('GOOD_PRSN'));
//			record.set('BAD_WH_CODE' 			, outouProdtSaveSearch.getValue('BAD_WH_CODE'));
//			record.set('BAD_WH_CELL_CODE'	  , outouProdtSaveSearch.getValue('BAD_WH_CELL_CODE'));
//			record.set('BAD_PRSN'				, outouProdtSaveSearch.getValue('BAD_PRSN'));
			record.set('PRODT_TYPE'			, '1');
		},
		returnCell: function(record) {
		}
	});

	//부산물
	var masterGrid4 = Unilite.createGrid('s_pmr100ukrv_ypGrid4', {
		store	: directMasterStore4,
		itemId	: 's_pmr100ukrv_ypGrid4',
		split	: true,
		layout	: 'fit',
		region	: 'center',
		title	: '부산물',
		flex	: 1,
//		id: 's_pmr100ukrv_ypGrid4',
		uniOpt:{
			expandLastColumn	: true,
			dblClickToEdit		: true,
			useRowNumberer		: true,
			onLoadSelectFirst	: false,
			useMultipleSorting	: true
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 80		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 80		, hidden: true},
			{dataIndex: 'PRODT_SEQ'			, width: 80		, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 80		, hidden: true},
			{dataIndex: 'TOP_WKORD_NUM'		, width: 80		, hidden: true},
			{dataIndex: 'WKORD_NUM'			, width: 80		, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 100	,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName		: 'ITEM_CODE',
					DBtextFieldName		: 'ITEM_CODE',
					useBarcodeScanner	: true,
					autoPopup			: true,
					listeners			: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid4.uniOpt.currentRecord;
								Ext.each(records, function(record,i) {
									if(i==0) {
										masterGrid4.setItemData(record,false, masterGrid4.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid4.setItemData(record,false, masterGrid4.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid4.setItemData(null,true, masterGrid4.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				 })
			},
			{dataIndex: 'ITEM_NAME'			, width: 120	,
				editor: Unilite.popup('DIV_PUMOK_G', {
					autoPopup			: true,
					listeners			: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid4.uniOpt.currentRecord;
								Ext.each(records, function(record,i) {
									if(i==0) {
										masterGrid4.setItemData(record,false, masterGrid4.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid4.setItemData(record,false, masterGrid4.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid4.setItemData(null,true, masterGrid4.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				 })
			},
			{dataIndex: 'SPEC'				, width: 93},
			{dataIndex: 'STOCK_UNIT'		, width: 80		, hidden: true},
			{dataIndex: 'PRODT_DATE'		, width: 80		, hidden: true},
			{dataIndex: 'PRODT_Q'			, width: 100},
			{dataIndex: 'GOOD_PRODT_Q'		, width: 80		, hidden: true},
			{dataIndex: 'BAD_PRODT_Q'		, width: 80		, hidden: true},
			{dataIndex: 'CONTROL_STATUS'	, width: 80		, hidden: true},
			{dataIndex: 'IN_STOCK_Q'		, width: 80		, hidden: true},
			{dataIndex: 'REMARK'			, width: 80		, hidden: true},
			{dataIndex: 'WH_CODE'			, width: 120},
			{dataIndex: 'PROJECT_NO'		, width: 80		, hidden: true},
			{dataIndex: 'PJT_CODE'			, width: 80		, hidden: true},
			{dataIndex: 'LOT_NO'			, width: 80		, hidden: true},
			{dataIndex: 'FR_SERIAL_NO'		, width: 80		, hidden: true},
			{dataIndex: 'TO_SERIAL_NO'		, width: 80		, hidden: true},
			{dataIndex: 'INOUT_NUM'			, width: 80		, hidden: true},
			{dataIndex: 'INOUT_SEQ'			, width: 80		, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
//				if(e.record.data.CONTROL_STATUS == '2') {
					if(e.record.phantom == true) {
						if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'PRODT_Q', 'WH_CODE'])){
							return true;
						} else {
							return false;
						}
					} else {
						if(UniUtils.indexOf(e.field, ['PRODT_Q', 'WH_CODE'])){
							return true;
						} else {
							return false;
						}
					}
//				} else {
//					return false;
//				}
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				UniAppManager.setToolbarButtons(['newData', 'delete'], false);
			},
			render: function(grid, eOpts) {
				var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					activeGridId = girdNm;
					UniAppManager.setToolbarButtons(['newData', 'delete'], true);
				});
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			//var grdRecord = masterGrid.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, "");
				grdRecord.set('ITEM_NAME'		, "");
				grdRecord.set('SPEC'			, "");
				grdRecord.set('STOCK_UNIT'		, "");

			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
			}
		}
	});

	//상세
	var masterGrid5 = Unilite.createGrid('s_pmr100ukrv_ypGrid5', {
		store : directMasterStore5,
		itemId: 's_pmr100ukrv_ypGrid5',
		layout : 'fit',
		region: 'south',
		title : '상세',
		flex: 0.5,
		id: 's_pmr100ukrv_ypGrid5',
		uniOpt:{
			expandLastColumn	: false,
			useRowNumberer		: true,
			onLoadSelectFirst	: false,
			useMultipleSorting	: true
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'FLAG'				, width: 35			, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 120},
			{dataIndex: 'SPEC'				, width: 93},
			{dataIndex: 'PRODT_Q'			, width: 100},
			{dataIndex: 'ALLOCK_Q'			, width: 100},
			{dataIndex: 'LOT_NO'			, width: 133},
			{dataIndex: 'LABEL_Q'			, width: 100},
			{dataIndex: 'ONHAND_Q'			, width: 100},
			{dataIndex: 'WKORD_NUM'			, width: 120},
			{dataIndex: 'INOUT_DATE'		, width: 80			, hidden: true},
			{dataIndex: 'WH_CODE'			, width: 80			, hidden: true},
			{dataIndex: 'CONTROL_STATUS'	, width: 80			, hidden: true},
			{dataIndex: 'UNIT_Q'			, width: 80			, hidden: true},
			{dataIndex: 'TMP_TIME'			, width: 80			, hidden: true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
				return false
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				UniAppManager.setToolbarButtons(['delete', 'newData'], false);
			},
			render: function(grid, eOpts) {
				var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					activeGridId = girdNm;
					UniAppManager.setToolbarButtons(['delete', 'newData'], false);
				});
			}
		}
	});





	// 생산실적 자동입고
	var outouProdtSaveSearch = Unilite.createSearchForm('outouProdtSaveForm', {
		layout: {type : 'uniTable', columns : 2},
		items:[{
				xtype	: 'container',
				html	: '※ 양품입고',
				colspan	: 2,
				style	: {
					color: 'blue'
				}
			},{
				fieldLabel	: '입고창고',
				name		: 'GOOD_WH_CODE',
//				allowBlank	: false,
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				child		: 'GOOD_WH_CELL_CODE',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
//						cbStore.loadStoreRecords(newValue);
					}
				}
			},{
				fieldLabel	: '입고CELL창고',
				name		: 'GOOD_WH_CELL_CODE',
//				allowBlank	: gsSumTypeCell,
				store		: Ext.data.StoreManager.lookup('whCellList'),
				xtype		: 'uniCombobox',
				hidden		: gsSumTypeCell
			},{
				fieldLabel	: '입고담당',
				name		: 'GOOD_PRSN',
//				allowBlank	: false,
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B024'
			},{
				fieldLabel	: '양품수량',
				name		: 'GOOD_Q',
				xtype		: 'uniTextfield',
				colspan		: 2,
				readOnly	: true
			},{
				xtype		: 'container',
				html		: '※ 불량입고',
				colspan		: 2,
				style		: {
					color: 'blue'
				},
				margin		: '20 5 5 5'
			},{
				fieldLabel	: '입고창고',
				name		: 'BAD_WH_CODE',
//				allowBlank	: false,
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				child		: 'BAD_WH_CELL_CODE',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
//						cbStore2.loadStoreRecords(newValue);
					}
				}
			},{
				fieldLabel	: '입고CELL창고',
				name		: 'BAD_WH_CELL_CODE',
				store		: Ext.data.StoreManager.lookup('whCellList'),
//				allowBlank	: gsSumTypeCell,
				xtype		: 'uniCombobox',
//				store: cbStore2,
				hidden		: gsSumTypeCell
			},{
				fieldLabel	: '입고담당',
				name		: 'BAD_PRSN',
//				allowBlank	: false,
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B024'
			},{
				fieldLabel	: '불량수량',
				name		: 'BAD_Q',
				xtype		: 'uniTextfield',
				colspan		: 2,
				readOnly	: true
			},{
				xtype		: 'component',
				width		: 10,
				height		: 10,
				colspan		: 2,
				style		: {
					color: 'blue'
				}
			}
		],
		beforeshow: function( panel, eOpts )	{
			var record = masterGrid2.getSelectedRecord();
			outouProdtSaveSearch.setValue('GOOD_WH_CODE'		, record.data.GOOD_WH_CODE);
			outouProdtSaveSearch.setValue('GOOD_WH_CELL_CODE'	, record.data.GOOD_WH_CELL_CODE);
			outouProdtSaveSearch.setValue('GOOD_PRSN'			, record.data.GOOD_PRSN);
			outouProdtSaveSearch.setValue('GOOD_Q'				, record.data.GOOD_WORK_Q);
			outouProdtSaveSearch.setValue('BAD_WH_CODE'			, record.data.BAD_WH_CODE);
			outouProdtSaveSearch.setValue('BAD_WH_CELL_CODE'	, record.data.BAD_WH_CELL_CODE);
			outouProdtSaveSearch.setValue('BAD_PRSN'			, record.data.BAD_PRSN);
			outouProdtSaveSearch.setValue('BAD_Q'				, record.data.BAD_WORK_Q);
		},
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r= false;
					var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
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

	function openoutouProdtSave() { 	// 생산실적 자동입고
		if(!outouProdtSave) {
			var record = masterGrid2.getSelectedRecord();
			outouProdtSaveSearch.setValue('GOOD_Q'				,record.get('GOOD_WORK_Q'));
			outouProdtSaveSearch.setValue('BAD_Q'				,record.get('BAD_WORK_Q'));
			outouProdtSaveSearch.setValue('GOOD_WH_CODE'		,record.get('GOOD_WH_CODE'));
			outouProdtSaveSearch.setValue('GOOD_WH_CELL_CODE'	,record.get('GOOD_WH_CELL_CODE'));
			outouProdtSaveSearch.setValue('GOOD_PRSN'			,record.get('GOOD_PRSN'));
			outouProdtSaveSearch.setValue('BAD_WH_CODE'			,record.get('BAD_WH_CODE'));
			outouProdtSaveSearch.setValue('BAD_WH_CELL_CODE'	,record.get('BAD_WH_CELL_CODE'));
			outouProdtSaveSearch.setValue('BAD_PRSN'			,record.get('BAD_PRSN'));

			outouProdtSave = Ext.create('widget.uniDetailWindow', {
				title	: '생산실적 자동입고',
				width	: 580,
				height	: 250,
				layout	: {type:'vbox', align:'stretch'},
				items	: [outouProdtSaveSearch],
				tbar	:  [
					'->',
					{
					itemId	: 'saveBtn',
					text	: '확인',
					handler	: function() {
						if(!Ext.isEmpty(outouProdtSaveSearch.getValue('GOOD_Q'))){
							if(Ext.isEmpty(outouProdtSaveSearch.getValue('GOOD_WH_CODE'))){
								alert('입고창고는 필수 입니다.');
								return false;
							}
							if(!gsSumTypeCell && Ext.isEmpty(outouProdtSaveSearch.getValue('GOOD_WH_CELL_CODE'))){
								alert('입고CELL창고는 필수 입니다.');
								return false;
							}
							if(Ext.isEmpty(outouProdtSaveSearch.getValue('GOOD_PRSN'))){
								alert('입고담당자는 필수 입니다.');
								return false;
							}
						}

						if(!Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_Q'))){
							if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_WH_CODE'))){
								alert('입고창고는 필수 입니다.');
								return false;
							}
							if(!gsSumTypeCell && Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_WH_CELL_CODE'))){
								alert('입고CELL창고는 필수 입니다.');
								return false;
							}
							if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_PRSN'))){
								alert('입고담당자는 필수 입니다.');
								return false;
							}
						}
						var record = masterGrid2.getSelectedRecord();

						var goodWhCode		= outouProdtSaveSearch.getValue('GOOD_WH_CODE');
						var goodWhCellCode	= outouProdtSaveSearch.getValue('GOOD_WH_CELL_CODE');
						var goodPrsn		= outouProdtSaveSearch.getValue('GOOD_PRSN');
						var badWhCode		= outouProdtSaveSearch.getValue('BAD_WH_CODE');
						var badWhCellCode	= outouProdtSaveSearch.getValue('BAD_WH_CELL_CODE');
						var badPrsn			= outouProdtSaveSearch.getValue('BAD_PRSN');

						record.set('GOOD_WH_CODE'		, goodWhCode);
						record.set('GOOD_WH_CELL_CODE'	, goodWhCellCode);
						record.set('GOOD_PRSN'			, goodPrsn);
						record.set('BAD_WH_CODE'		, badWhCode);
						record.set('BAD_WH_CELL_CODE'	, badWhCellCode);
						record.set('BAD_PRSN'			, badPrsn);

						if(outouProdtSaveSearch.setAllFieldsReadOnly(true) == false){
							return false;
						} else {
							outouProdtSave.hide();
							directMasterStore2.saveStore();
						}
					},
					disabled: false
					},{
							xtype: 'tbspacer'
					},{
							xtype: 'tbseparator'
					},{
							xtype: 'tbspacer'
					},{
						itemId	: 'CloseBtn',
						text	: '닫기',
						handler	: function() {
							outouProdtSave.hide();
						}
					}
				],
				listeners: {
					beforehide: function(me, eOpt){
						outouProdtSaveSearch.clearForm();
					},
					beforeshow: function( panel, eOpts )	{
						var record = masterGrid2.getSelectedRecord();
						outouProdtSaveSearch.setValue('GOOD_Q'				,record.get('GOOD_WORK_Q'));
						outouProdtSaveSearch.setValue('BAD_Q'				,record.get('BAD_WORK_Q'));
						outouProdtSaveSearch.setValue('GOOD_WH_CODE'		,record.get('GOOD_WH_CODE'));
						outouProdtSaveSearch.setValue('GOOD_WH_CELL_CODE'	,record.get('GOOD_WH_CELL_CODE'));
						outouProdtSaveSearch.setValue('GOOD_PRSN'			,record.get('GOOD_PRSN'));
						outouProdtSaveSearch.setValue('BAD_WH_CODE'			,record.get('BAD_WH_CODE'));
						outouProdtSaveSearch.setValue('BAD_WH_CELL_CODE'	,record.get('BAD_WH_CELL_CODE'));
						outouProdtSaveSearch.setValue('BAD_PRSN'			,record.get('BAD_PRSN'));
					}
				}
			})
		}
		outouProdtSave.center();
		outouProdtSave.show();
	}





	Unilite.Main( {
		id			: 's_pmr100ukrv_ypApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult,
				{
					region	: 'west',
					xtype	: 'container',
					layout	: 'fit',
					split	: true,
					width	: '58%',
					items	: [ masterGrid ]
				}, {
					region	: 'center',
					xtype	: 'container',
					layout	: {type:'vbox', align:'stretch'},
					items	: [masterGrid2, masterGrid3, masterGrid4]
				}
//				, masterGrid5				//데이터 확인 시 주석 해제
			]
		}],

		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'/*, 'prev', 'next'*/], true);
			UniAppManager.setToolbarButtons(['newData'], false);

			this.setDefault();
		},

		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterSelectIdx = 0;
			directMasterStore.loadStoreRecords();
		},

		onNewDataButtonDown: function()	{
			if(!this.isValidSearchForm()) return false;
			if(activeGridId == 's_pmr100ukrv_ypGrid4') {
				var record	= masterGrid3.getSelectedRecord();
				var divCode	= panelResult.getValue('DIV_CODE');
				var lotNo	= fnCreateLotNo(UniDate.getDbDateStr(new Date()));

				if(record) {
					var divCode			= record.get('DIV_CODE');
					var topWkordNum		= record.get('TOP_WKORD_NUM');
					var seq				= directMasterStore4.max('PRODT_SEQ');
					if(!seq) {
						seq = 1;
					} else {
						seq += 1;
					}
					var workShopCode	= record.get('WORK_SHOP_CODE');
					var controlStatus	= record.get('CONTROL_STATUS');

					var r = {
						"COMP_CODE"		: UserInfo.compCode,
						"DIV_CODE"		: divCode,
						"TOP_WKORD_NUM"	: topWkordNum,
						"PRODT_SEQ"		: seq,
						"WORK_SHOP_CODE": workShopCode,
						"PRODT_DATE"	: gsProdtDate,
						"LOT_NO"		: lotNo,
						"WH_CODE"		: '',
						"CONTROL_STATUS": controlStatus
					}
					masterGrid4.createRow(r, null, directMasterStore4.getCount() - 1);

				} else {
					alert("원재료 정보가 없습니다.");
					return false;
				}

			}
			panelResult.setAllFieldsReadOnly(false);
		},

		onResetButtonDown: function() {		// 새로고침 버튼
			this.suspendEvents();
			panelResult.reset();
			panelResult.setAllFieldsReadOnly(false);
			panelResult.setValue("ITEM_CODE", '');
			panelResult.setValue("ITEM_NAME", '');
			masterGrid.reset();
			masterGrid2.reset();
			masterGrid3.reset();
			masterGrid4.reset();
			masterGrid5.reset();
			this.fnInitBinding();
			directMasterStore.clearData();
			directMasterStore2.clearData();
			directMasterStore3.clearData();
			directMasterStore4.clearData();
			directMasterStore5.clearData();
		},

		onDeleteDataButtonDown: function() {
			if(activeGridId == 's_pmr100ukrv_ypGrid4') {
				var selRow = masterGrid4.getSelectedRecord();
				if(selRow.phantom === true)	{
					masterGrid4.deleteSelectedRow();
				}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid4.deleteSelectedRow();
				}

			} else if(activeGridId == 's_pmr100ukrv_ypGrid2') {
				var selRow = masterGrid2.getSelectedRecord();
				if(selRow.get('CONTROL_STATUS') == '9' || selRow.get('IN_STOCK_Q') > 0) {
					if(selRow.phantom === true)	{
						masterGrid2.deleteSelectedRow();
					}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						var selRow = masterGrid2.getSelectedRecord();
//						var variQ  = 0;
						//원재료 행 삭제
						masterGrid5.deleteSelectedRow();
						//원재료 보여주는 그리드 수량 변경
//						var detailData3 = directMasterStore3.data.items;
//						Ext.each(detailData3, function(data3, i) {
//							if(data3.data.TOP_WKORD_NUM == selRow.get('TOP_WKORD_NUM')) {
//								data3.set('PRODT_Q', data3.get('PRODT_Q') - variQ);
//							}
//						});

						masterGrid2.deleteSelectedRow();
					}
				} else {
					alert(Msg.sMC018);
					return false;
				}
			} else {
				alert(Msg.sMA0256);
				return false;
			}
		},
		onSaveDataButtonDown: function(config) {
			var inValidRecs2 = directMasterStore2.getInvalidRecords();
			var inValidRecs4 = directMasterStore4.getInvalidRecords();
			var inValidRecs5 = directMasterStore5.getInvalidRecords();

			var toCreate = directMasterStore2.getNewRecords();
			var toUpdate = directMasterStore2.getUpdatedRecords();

			if(inValidRecs2.length == 0 && inValidRecs4.length == 0 && inValidRecs5.length == 0) {
				if(toCreate.length != 0 || toUpdate.length != 0) {
					var records = directMasterStore2.data.items;
					Ext.each(records, function(record2,i) {
						var fnCal = 0;

						var A = record2.get('PROG_WKORD_Q');	//작업지시량
						var B = record2.get('SUM_Q');			//생산량
						var C = record2.get('PASS_Q');
						var D = record2.get('LINE_END_YN');
                          if( A > C ){
        						if(D == 'Y') {
        							fnCal = ((B + C) / A) * 100
        						} else {
        							fnCal = 0;
        						}
        						if(fnCal > (100 * (BsaCodeInfo.glEndRate / 100))) {
        							alert('초과 생산 실적 범위를 벗어났습니다.');
        							gsFlag = false;
        							return false;
        						}
        
        						if((fnCal >= '95') || ((fnCal < '95') && record2.get('CONTROL_STATUS') == '9')) {
        							if(config && config.batch)	{		// 일괄 작업실적 완료 (메세지 확인 없이 저장 진행됨)
        								record2.set('CONTROL_STATUS', '9');
        								//부산물 상태값 변경
        								var records4 = directMasterStore4.data.items;
        								Ext.each(records4, function(record4, i) {
        									record4.set('CONTROL_STATUS', '9');
        								});
        								return true;
        							}else if(confirm('완료하시겠습니까?')) {
        								record2.set('CONTROL_STATUS', '9');
        								//부산물 상태값 변경
        								var records4 = directMasterStore4.data.items;
        								Ext.each(records4, function(record4, i) {
        									record4.set('CONTROL_STATUS', '9');
        								});
        								return true;
        							} else {
        								if(record2.get('CONTROL_STATUS') == '9') {
        									record2.set('CONTROL_STATUS', '3');
        								}
        								//부산물 상태값 변경
        								var records4 = directMasterStore4.data.items;
        								Ext.each(records4, function(record4, i) {
        									if(records4.get('CONTROL_STATUS') == '9') {
        										records4.set('CONTROL_STATUS', '3');
        									}
        								});
        								return false;
        							}
        						}
                          }
					});

					if(!gsFlag) {
						gsFlag = true;
						return false;
					}
				}

				if(directMasterStore4.isDirty()) {				// 부산물
					directMasterStore4.saveStore();
				} else {
					if(directMasterStore5.isDirty()) {			// 원재료(자재예약 table)
						directMasterStore5.saveStore();

					} else if(directMasterStore2.isDirty()) {	// 제품
						directMasterStore2.saveStore();
					}
				}
			} else {
				if(inValidRecs5.length != 0) {
					var grid = Ext.getCmp('s_pmr100ukrv_ypGrid5');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs5);

				} else if(inValidRecs4.length != 0) {
					var grid = Ext.getCmp('s_pmr100ukrv_ypGrid4');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs4);

				} else {
					var grid = Ext.getCmp('s_pmr100ukrv_ypGrid2');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs2);
				}
			}
		},

		setDefault: function() {
			panelResult.setValue('DIV_CODE'				, UserInfo.divCode);
			panelResult.setValue('PRODT_START_DATE_FR'	, UniDate.get('startOfMonth'));
			panelResult.setValue('PRODT_START_DATE_TO'	, UniDate.get('today'));
			panelResult.setValue('CONTROL_STATUS'		, '2');
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		}
	});







	function fnCreateLotNo(date) {
		if(!date) {
			var date = UniDate.getDbDateStr(new Date());
		}
		var charater	= new Array('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L');

		var year		= date.substring(2,4);
		var month		= charater[(date.substring(4,6) - 1)];
		var day			= date.substring(6,8);
		var lotNo		= 'YP' + day + month + year + '000';

		return lotNo
	}







	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store	: directMasterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {

			}
			return rv;
		}
	}); // validator

	Unilite.createValidator('validator02', {
		store	: directMasterStore2,
		grid	: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "SUM_Q" :						// 생산량
					if(newValue < '0') {
						rv= Msg.sMB076;
						break;
					}
//					if(record.get('JAN_Q') < newValue) {
//						rv= "생산량이 생산잔량보다 클 수 없습니다.";
//						break;
//					}
					var variQ		= 0;
					var oldVariQ	= 0;

					record.set('PRODT_Q'		, newValue);
					record.set('GOOD_WORK_Q'	, newValue);
					record.set('BAD_WORK_Q'		, 0);
					record.set('JAN_Q'			, record.get('JAN_Q') - newValue + oldValue);

					//생산량 변경에 따른 원재료 량 변경
//					var param = {
//						COMP_CODE		: UserInfo.compCode,
//						DIV_CODE		: record.get('DIV_CODE'),
//						ITEM_CODE		: record.get('ITEM_CODE'),
//						PRESENT_DATE	: UniDate.getDbDateStr(record.get('PRODT_DATE')),
//						WORK_SHOP_CODE	: record.get('WORK_SHOP_CODE'),
//						WKORD_Q			: newValue - oldValue
//					}
//					s_pmp110ukrv_ypService.getPMP200T(param, function(provider, response){
//						if(!Ext.isEmpty(provider)){
							//pmp200t에 수량 update
							var detailData5 = directMasterStore5.data.items;
							Ext.each(detailData5, function(data5, i) {
								if(data5.data.WKORD_NUM == record.get('WKORD_NUM')) {
									variQ		= (newValue/* - oldValue*/) * data5.data.UNIT_Q;
									oldVariQ	= (oldValue) * data5.data.UNIT_Q;
									var prodtQ5	= data5.data.PRODT_Q + variQ - oldVariQ;
									data5.set('PRODT_Q', prodtQ5);
								}
							});

							//원재료 수량 update
							var detailData3 = directMasterStore3.data.items;
							Ext.each(detailData3, function(data3, i) {
								var prodQ	= data3.data.PRODT_Q + variQ - oldVariQ;
								data3.set('PRODT_Q', prodQ);
							});
//						}
//					});
				break;

				case "GOOD_WORK_Q" :					// 양품량
					if(newValue < '0') {
						rv= Msg.sMB076;
						break;
					}
					if(newValue > record.get('SUM_Q')) {
						rv = "양품량은 생산량보다 클 수 없습니다.";
						break;
					}
					record.set('BAD_WORK_Q'		, record.get('SUM_Q') - newValue);
					record.set('JAN_Q'			, record.get('JAN_Q') - newValue + oldValue);
				break;

				case "BAD_WORK_Q" :					// 불량량
					if(newValue < '0') {
						rv= Msg.sMB076;
						break;
					}
					if(newValue > record.get('SUM_Q')) {
						rv = "불량량은 생산량보다 클 수 없습니다.";
						break;
					}
					record.set('GOOD_WORK_Q'	, record.get('SUM_Q') - newValue);
					record.set('JAN_Q'			, record.get('JAN_Q') + newValue - oldValue);
				break;

				case "JAN_Q" :							// 생산잔량
					if(newValue < '0') {
						rv= Msg.sMB076;
						return;
					}
				break;
			}
			return rv;
		}
	}); // validator

	Unilite.createValidator('validator03', {
		store	: directMasterStore3,
		grid	: masterGrid3,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PRODT_Q" :	// 생산출고수량
					if(newValue <= 0 ){
						//0보다 큰수만 입력가능합니다.
						alert(Msg.sMB100);
						return false;
					}

					//detailGrid5에 데이터 입력
					var totalQ		= 0;							//detailGrid5의 수량 합계
					var leftQ		= 0;							//남은 수량
					var maxItemSeq	= '';							//수량이 가장 큰 seq에 남은 값을 넣기 위해서
					var maxVal		= 0;							//수량이 가장 큰 seq에 남은 값을 넣기 위해서

					//detailGrid3의 일력에 따른 detailGrid2 임의로 UPDATE 상태로 만드는 로직
					var detailData2	= directMasterStore2.data.items;
					Ext.each(detailData2, function(data2, i) {
						if (data2.data.TOP_WKORD_NUM == record.obj.data.TOP_WKORD_NUM) {
							data2.set('UPDATE_DB_USER', UserInfo.userID);
						}
					});

					//detailGrid3의 일력에 따른 detailGrid5의 수량 합계 / 가장 큰 수량 record 조건 확인
					var detailData5	= directMasterStore5.data.items;
					Ext.each(detailData5, function(data5, i) {
						if (data5.data.TOP_WKORD_NUM == record.obj.data.TOP_WKORD_NUM) {
							totalQ = totalQ + data5.data.PRODT_Q;
							//수량 가장 큰 seq 구하기
							if(data5.data.PRODT_Q > maxVal){
								maxItemSeq	= data5.data.WKORD_NUM;
								maxVal		= data5.data.PRODT_Q
							}
						}
					});

//					if (newValue < totalQ) {
//						alert('기예약된 양보다 작은 수를 입력할 수 없습니다.');
//						return false;
//					}

					leftQ = newValue - oldValue;
					//비율에 맞게 추가된 값 분배
					Ext.each(detailData5, function(data5, i) {
						if (data5.data.TOP_WKORD_NUM == record.obj.data.TOP_WKORD_NUM) {
							var addQ	= 0
//								if (masterDatum.data.DETAIL_ITEM_CODE == record.obj.data.ITEM_CODE && masterDatum.data.SEQ == data2.data.SEQ) {
//									addQ	= Math.floor((newValue - oldValue) * (data5.data.PRODT_Q / totalQ));
									addQ	= (newValue - oldValue) * (data5.data.PRODT_Q / totalQ);
//								}
							leftQ = leftQ - addQ;
							data5.set('PRODT_Q', data5.get('PRODT_Q') + addQ);
						}
//						alert(leftQ);																//남은수량 확인용
					});

					//남은 수량을 최대수량에 더하는 로직
					Ext.each(detailData5, function(data5, i) {
						if (data5.data.WKORD_NUM == maxItemSeq) {
							data5.set('PRODT_Q', data5.data.PRODT_Q + leftQ);
						}
					});
				break;
			}
			return rv;
		}
	});
}
</script>