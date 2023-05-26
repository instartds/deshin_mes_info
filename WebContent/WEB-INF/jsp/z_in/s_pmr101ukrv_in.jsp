<%--
'   프로그램명 : 공정불량 Touch
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_pmr101ukrv_in">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>	<!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="P003"/>	<!-- 불량유형 -->
	<t:ExtComboStore comboType="AU" comboCode="P002"/>	<!-- 특기사항 분류 -->
	<t:ExtComboStore comboType="AU" comboCode="P507"/>	<!-- 작업조 -->
	<t:ExtComboStore comboType="OU"/>					<!-- 창고-->
	<t:ExtComboStore comboType="WU"/>					<!-- 작업장-->
	<t:ExtComboStore comboType="AU" comboCode="ZP11"/>	<!-- 생산라인 -->
	<t:ExtComboStore comboType="AU" comboCode="ZP12"/>	<!-- 진행상태 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-change-cell_size {
		font-size: 15px;
		padding-top: 11px;
	}
	.x-change-cell_size2 {
		font-size: 15px;
		height: 50px;
		padding-top: 10px;
	}
	.x-change-cell_size3 {
		font-size: 20px;
		height: 60px;
		padding-top: 15px;
	}
</style>
<script type="text/javascript" >

var needSave		= false;
var checkNewData	= false;
var getSelected		= false;
var ProgressWindow;			//ProgressWindow : 검색창
var ProdtLineWindow;		//ProdtLineWindow: 검색창 버튼 실행 시 공정 그리드 show
var gsSelectedRecord

function appMain() {
	var cbStore = Unilite.createStore('s_pmr101ukrv_inComboStoreGrid',{
		autoLoad: false,
		uniOpt	: {
			isMaster: false	
		},
		fields: [
			{name: 'SUB_CODE'	, type : 'string'},
			{name: 'CODE_NAME '	, type : 'string'}
		],
		proxy: {
			type: 'direct',
			api	: {
				read: 's_pmr101ukrv_inService.fnRecordCombo'
			}
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pmr101ukrv_inService.selectDetailList'
		}
	});

	var directProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_pmr101ukrv_inService.selectDetailList5',
			update	: 's_pmr101ukrv_inService.updateDetail5',
			create	: 's_pmr101ukrv_inService.insertDetail5',
			destroy	: 's_pmr101ukrv_inService.deleteDetail5',
			syncAll	: 's_pmr101ukrv_inService.saveAll5'
		}
	});

	Unilite.defineModel('s_pmr101ukrv_inDetailModel', {
		fields: [
			{name: 'CONTROL_STATUS'		,text: '<t:message code="system.label.product.status" default="상태"/>'					,type:'string' , comboType:"AU", comboCode:"P001"},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			,type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'						,type:'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'						,type:'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>'						,type:'string'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'			,type:'uniQty'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'		,type:'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.workenddate" default="작업완료일"/>'			,type:'uniDate'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
			{name: 'PJT_CODE'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.product.remarks" default="비고"/>'					,type:'string'},
			{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'			,type:'string' ,comboType: 'WU'},
			{name: 'WORK_Q'				,text: '<t:message code="system.label.product.workqty" default="작업량"/>'					,type:'uniQty'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'			,type:'uniQty'},
			{name: 'WK_PLAN_NUM'		,text: '<t:message code="system.label.product.workplanno" default="작업계획번호"/>'			,type:'string'},
			{name: 'LINE_END_YN'		,text: '<t:message code="system.label.product.lastroutingexistyn" default="최종공정유무"/>'	,type:'string'},
			{name: 'WORK_END_YN'		,text: '<t:message code="system.label.product.closingyn" default="마감여부"/>'				,type:'string'},
			{name: 'LINE_SEQ'			,text: '<t:message code="system.label.product.routingorder" default="공정순서"/>'			,type:'string'},
			{name: 'PROG_UNIT'			,text: '<t:message code="system.label.product.routingresultunit" default="공정실적단위"/>'	,type:'string'},
			{name: 'PROG_UNIT_Q'		,text: '<t:message code="system.label.product.routingunitqty" default="공정원단위량"/>'		,type:'uniQty'},
			{name: 'OUT_METH'			,text: '<t:message code="system.label.product.issuemethod" default="출고방법"/>'			,type:'string'},
			{name: 'AB'					,text: ' '			,type:'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'					,type:'string'},
			{name: 'RESULT_YN'			,text: '<t:message code="system.label.product.receiptmethod" default="입고방법"/>'			,type:'string'},
			{name: 'INSPEC_YN'			,text: '<t:message code="system.label.product.receiptmethod" default="입고방법"/>'			,type:'string'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.product.basiswarehouse" default="기준창고"/>'			,type:'string'},
			{name: 'BASIS_P'			,text: '<t:message code="system.label.product.inventoryamount" default="재고금액"/>'		,type:'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'				,type:'string'},
			//20200406 추가: MES 데이터 연동위한 컬럼 추가
			{name: 'PRODT_LINE'			,text: '생산라인'		,type:'string' , comboType:"AU", comboCode:"ZP11"},
			{name: 'Progrs_Kind_Cd'		,text: '진행상태'		,type:'string' , comboType:"AU", comboCode:"ZP12"},
			{name: 'WKORD_Q'			,text: '작업지시량'		,type:'uniQty'},
			{name: 'PROG_UNIT'			,text: '공정실적단위'		,type:'string'},
			//20200514 추가: PACK_QTY
			{name: 'PACK_QTY'			,text: 'PACK_QTY'	,type:'uniQty'}
		]
	});

	/** 불량내역등록
	 * @type
	 */
	Unilite.defineModel('s_pmr101ukrv_inModel5', {
		fields: [
			{name: 'CHECK_VALUE'		,text: 'CHECK_VALUE'	,type:'string'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			,type:'string', allowBlank:false},
			{name: 'PROG_WORK_NAME'		,text: '<t:message code="system.label.product.routingname" default="공정명"/>'				,type:'string', allowBlank:false},
			{name: 'PRODT_DATE'			,text: '<t:message code="system.label.product.occurreddate" default="발생일"/>'			,type:'uniDate', allowBlank:false},
			{name: 'BAD_CODE'			,text: '<t:message code="system.label.product.defecttype" default="불량유형"/>'				,type:'string', comboType: 'AU', comboCode: 'P003'},
			{name: 'BAD_Q'				,text: '<t:message code="system.label.product.qty" default="수량"/>'						,type:'uniQty'},
			{name: 'REMARK'				,text: '<t:message code="system.label.product.issueandmeasures" default="문제점 및 대책"/>'	,type:'string'},
			//Hidden : true
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'				,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'			,type:'string'},
			{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type:'string'},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'				,type:'string'},
			{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'				,type:'uniDate'},
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'			,type:'string'},
			{name: 'INPUT_Q'			,text: '입력값'			,type:'int' , defaultValue: 1}
		]
	});

	var detailStore = Unilite.createStore('s_pmr101ukrv_inDetailStore', {
		model	: 's_pmr101ukrv_inDetailModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
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
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)) {
					panelResult.getField('DIV_CODE').setReadOnly(true);
//					UniAppManager.setToolbarButtons(['newData', 'delete'], false);
				} else {
//					UniAppManager.app.onResetButtonDown();
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	var directMasterStore5 = Unilite.createStore('s_pmr101ukrv_inMasterStore5',{
		model	: 's_pmr101ukrv_inModel5',
		proxy	: directProxy5,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function()	{
			var param	= panelResult.getValues();
			var record	= detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.WKORD_NUM	= record.get('WKORD_NUM');
				param.WKORD_Q	= record.get('WKORD_Q');
			}
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
			var list = [].concat(toUpdate, toCreate);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					useSavedMessage : false,
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						/* var master = batch.operations[0].getResultSet();
						masterForm.setValue("INOUT_NUM", master.T0T_BAD);
						Ext.getCmp('TOT_BAD').setValue(master.T0T_BAD);  */

						//3.기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr101ukrv_inGrid5');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				var tot = 0;
				Ext.each(records, function(record,i) {
					if(Ext.isEmpty(record.data.CHECK_VALUE)) {
						record.set('CHECK_VALUE', 'N');
						checkNewData = true;
					}
					tot = tot + record.data.BAD_Q;
				});
				UniAppManager.setToolbarButtons(['save'], false);
				Ext.getCmp('TOT_BAD').setValue(tot);
			  },
			update:function( store, records, operation, modifiedFieldNames, eOpts )	{
				checkNewData = false;
			},
			add: function(store, records, index, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5/*,
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}*/
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{//20200416 추가: panel 아래, 위 간격 추가
			xtype	: 'component',
			width	: 100,
			height	: 20,
			colspan	: 5
		},{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120' ,
			value		: UserInfo.divCode,
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '생산일',
			name		: 'PRODT_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			allowBlank	: false,
			tdCls		: 'x-change-cell_size',
			//20200416 추가
			height		: 30,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '공정',
			name		: 'PROG_WORK_CODE',
			xtype		: 'uniCombobox',
			//20200409 주석: 전체 line_end_yn = 'y'가 나오도록
//			allowBlank	: false,
			store		: cbStore,
			width		: 280,
			//20200416 추가
			height		: 30,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
//					//20200409 수정
//					if(getSelected){
//						directMasterStore5.loadStoreRecords();
//					}
					if(!Ext.isEmpty(detailGrid.getSelectedRecord())) {
						if(Ext.isEmpty(panelResult.getValue('PROG_WORK_CODE'))) {
							Unilite.messageBox('공정정보를 입력하세요');
							panelResult.getField('PROG_WORK_CODE').focus();
							return false;
						}
						directMasterStore5.loadStoreRecords();
					} else {
						masterGrid5.getStore().loadData({});
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'WU',
			width		: 280,
			//20200416 추가
			height		: 30,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '진행상태',
			name		: 'Progrs_Kind_Cd',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZP12',
			//20200416 추가
			height		: 30,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 2},
			margin	: '0 0 8 100',
			items	: [{
				text	: '조회',
				itemId	: 'btnSearch',
				width	: 100,
				height	: 50,
				xtype	: 'button',
				handler	: function(){
					UniAppManager.app.onQueryButtonDown();
				}
			}/*,{
				text	: '생산완료',
				itemId	: 'btnFinish',
				width	: 160,
				height	: 50,
				margin	: '0 0 0 20',
				xtype	: 'button',
				handler	: function(){
				}
			},{
				text	: 'OPEN',
				itemId	: 'btnFinish',
				width	: 100,
				height	: 50,
				xtype	: 'button',
				handler	: function(){
					window.open('s_pmr101ukrv_in.do','_blank','width=1000,height=600');
				}
			}*/]
		},{	//20200416 추가: panel 아래, 위 간격 추가
			xtype	: 'component',
			width	: 100,
			height	: 20,
			colspan	: 5
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

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var detailGrid = Unilite.createGrid('s_pmr101ukrv_inGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		flex	: 0.55,				//20200428 수정: 0.6 -> 0.55
		uniOpt	: {
			expandLastColumn	: false,
			onLoadSelectFirst	: false,
			useRowNumberer		: false,
			userToolbar			: false,
			state				: {
				useState	: false,
				useStateList: false
			}
		},
		columns: [
			{dataIndex: 'CONTROL_STATUS'	, width: 53 , hidden:true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 120, hidden:true},
			{dataIndex: 'WKORD_NUM'			, width: 140, align: 'center' ,tdCls:'x-change-cell_size2', hidden:true},		//20200428 추가: , hidden:true
			{dataIndex: 'ITEM_CODE'			, width: 110, tdCls:'x-change-cell_size2', hidden:true},						//20200428 추가: , hidden:true
			{dataIndex: 'ITEM_NAME'			, width: 245, tdCls:'x-change-cell_size2'},
			{dataIndex: 'SPEC'				, width: 150, hidden:true},
			{dataIndex: 'STOCK_UNIT'		, width: 53 , hidden:true},
			{dataIndex: 'WKORD_Q'			, width: 100, hidden:true},
			{dataIndex: 'PRODT_START_DATE'	, width: 86 , hidden:true},
			{dataIndex: 'PRODT_END_DATE'	, width: 86 , hidden:true},
			{dataIndex: 'LOT_NO'			, width: 120, tdCls:'x-change-cell_size2' },
			{dataIndex: 'PROJECT_NO'		, width: 120, hidden:true},
			{dataIndex: 'REMARK'			, width: 180, hidden:true},
			{dataIndex: 'PROG_WORK_CODE'	, width: 80 , hidden:true},
			{dataIndex: 'WORK_Q'			, width: 80 , hidden:true},
			{dataIndex: 'PRODT_Q'			, width: 80 , hidden:true},
			{dataIndex: 'WK_PLAN_NUM'		, width: 80 , hidden:true},
			{dataIndex: 'LINE_END_YN'		, width: 80 , hidden:true},
			{dataIndex: 'WORK_END_YN'		, width: 80 , hidden:true},
			{dataIndex: 'LINE_SEQ'			, width: 80 , hidden:true},
			{dataIndex: 'PROG_UNIT'			, width: 80 , hidden:true},
			{dataIndex: 'PROG_UNIT_Q'		, width: 80 , hidden:true},
			{dataIndex: 'OUT_METH'			, width: 80 , hidden:true},
			{dataIndex: 'AB'				, width: 80 , hidden:true},
			{dataIndex: 'RESULT_YN'			, width: 10 , hidden:true},
			{dataIndex: 'INSPEC_YN'			, width: 80 , hidden:true},
			{dataIndex: 'WH_CODE'			, width: 80 , hidden:true},
			{dataIndex: 'BASIS_P'			, width: 80 , hidden:true},
			{dataIndex: 'DIV_CODE'			, width: 10 , hidden:true},
			{dataIndex: 'PACK_QTY'			, width: 10 , hidden:true},		//20200514 추가: PACK_QTY
			//20200406 추가: MES 데이터 연동위한 컬럼 추가
			{dataIndex: 'PRODT_LINE'		, width: 100, hight: 50, tdCls:'x-change-cell_size2'},
			{dataIndex: 'Progrs_Kind_Cd'	, width: 100, align: 'center' , tdCls:'x-change-cell_size2'},
			{	//20200406 추가: MES 데이터 연동위한 버튼 추가
				text	: '진행',
				xtype	: 'widgetcolumn',
				width	: 80,
				widget	: {
					xtype	: 'button',
					text	: '진행',
					height	: 50,
					listeners: {
						buffer	: 1,
						click	: function(button, event, eOpts) {
							//20200416 추가: 진행 버튼에서 윈도우 show로 로직 이동 / gsProdtLineFlag삭제(콤보에서 버튼으로 변경)
/*							gsProdtLineFlag = false;
							ProgressPanel.setValue('DIV_CODE'		, UserInfo.divCode);
							ProgressPanel.setValue('WKORD_NUM'		, event.record.get('WKORD_NUM'));
							ProgressPanel.setValue('ITEM_CODE'		, event.record.get('ITEM_CODE'));
							ProgressPanel.setValue('ITEM_NAME'		, event.record.get('ITEM_NAME'));
							ProgressPanel.setValue('LOT_NO'			, event.record.get('LOT_NO'));
							ProgressPanel.setValue('PROG_WORK_CODE'	, panelResult.getValue('PROG_WORK_CODE'));
							ProgressPanel.setValue('WKORD_Q'		, event.record.get('WKORD_Q'));
							ProgressPanel.setValue('Progrs_Kind_Cd'	, event.record.get('Progrs_Kind_Cd'));
							ProgressPanel.setValue('PROG_UNIT'		, event.record.get('PROG_UNIT'));
							ProgressPanel.setValue('PRODT_DATE'		, UniDate.getDbDateStr(panelResult.getValue('PRODT_DATE')));
							//20200416 주석: 콤보->버튼으로 변경 후 로직 수정(실제값은 hidden된 textfield에 입력)
//							ProgressPanel.setValue('PRODT_LINE'		, event.record.get('PRODT_LINE'));
							var prodtLineTxt = '';
							if(Ext.isEmpty(event.record.get('PRODT_LINE'))) {
								prodtLineTxt	= "<span style='width: 250px; height: 100px; line-height: 100px; font-size: 25px;'>라인선택<span>";
							} else {
								var prodtLineStore	= Ext.data.StoreManager.lookup('CBS_AU_ZP11')
								Ext.each(prodtLineStore.data.items, function(comboData, idx) {//lotno팝업에서 선택한 창고가 사용중인 창고이면 선택한 창고로 세팅
									if(comboData.get('value') == event.record.get('PRODT_LINE')){
										prodtLineTxt = "<span style='width: 250px; height: 100px; line-height: 100px; font-size: 25px;'>" + comboData.get('text') + "<span>";
									}
								});
							}
							ProgressPanel.down('#prodtLine').setHtml(prodtLineTxt);
							ProgressPanel.setValue('PRODT_LINE'		, event.record.get('PRODT_LINE'));
							//20200408 추가: 팝업에 해당 데이터 정보 표시
							ProgressPanel.down('#TXT_WKORD_NUM').setHtml("<span style='width: 150px; height: 40px; line-height: 40px; font-size: 20px;'>" + event.record.get('WKORD_NUM') + "<span>");
							ProgressPanel.down('#TXT_ITEM_CODE').setHtml("<span style='width: 150px; height: 40px; line-height: 40px; font-size: 20px;'>" + event.record.get('ITEM_CODE') + "<span>");
							ProgressPanel.down('#TXT_ITEM_NAME').setHtml("<span style='width: 150px; height: 40px; line-height: 40px; font-size: 20px;'>" + event.record.get('ITEM_NAME') + "<span>");
							ProgressPanel.down('#TXT_LOT_NO').setHtml("<span style='width: 150px; height: 40px; line-height: 40px; font-size: 20px;'>" + event.record.get('LOT_NO') + "<span>");
							gsProdtLineFlag = true;*/

							gsSelectedRecord = event.record;
							openProgressPopup();
						}
					}
				}
			}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
					return false;
				} else {
					return false;
				}
			},
			deselect:	function(grid, record, index, eOpts ){
				var a = 0;
			},
			beforeselect: function(grid, record, index, eOpts){
				if(directMasterStore5.isDirty()&&needSave == true && !checkNewData){
					if(confirm('내용이 변경되었습니다. 변경된 내용을 저장하시곘습니까?')){
						UniAppManager.app.onSaveDataButtonDown();
						return false;
					}
				}
			},	
			select: function(grid, selectRecord, index, rowIndex, eOpts ) {
				if(Ext.isEmpty(panelResult.getValue('PROG_WORK_CODE'))) {
					Unilite.messageBox('공정정보를 입력하세요');
					panelResult.getField('PROG_WORK_CODE').focus();
					return false;
				}
				//20200409 추가: selectionchange -> select로 이동
				if(!Ext.isEmpty(selectRecord)){
					Ext.getCmp('MAIN_WKORD_NUM').setValue(selectRecord.data.WKORD_NUM);
					Ext.getCmp('MAIN_ITEM_CODE').setValue(selectRecord.data.ITEM_NAME);
				}
				directMasterStore5.loadStoreRecords();
			},
			selectionchange:function( model1, selected, eOpts ){
				//20200409 주석: selectionchange -> select로 이동
//				if(!Ext.isEmpty(selected)){
//					Ext.getCmp('MAIN_WKORD_NUM').setValue(selected[0].data.WKORD_NUM);
//					Ext.getCmp('MAIN_ITEM_CODE').setValue(selected[0].data.ITEM_NAME);
//				}
//				directMasterStore5.loadStoreRecords();
			}
		},
		returnCell: function(record){
			var itemCode = record.get("ITEM_CODE");
			var prodtNum = record.get("PRODT_NUM");
			masterForm.setValues({'ITEM_CODE1'	: itemCode});
			masterForm.setValues({'PRODT_NUM'	: prodtNum});
		},
		disabledLinkButtons: function(b){
		}
	});

	var masterGrid5 = Unilite.createGrid('s_pmr101ukrv_inGrid5', {
		store	: directMasterStore5,
		layout	: 'fit',
		region	: 'center',
		flex	: 0.45,				//20200428 수정: 0.4 -> 0.45
		tbar: [
		{
			fieldLabel	:'작지번호',
			xtype		: 'uniTextfield',
			id			: 'MAIN_WKORD_NUM',
			labelWidth	: 80,
			width		: 200,
			readOnly	: true
		},{
			xtype		: 'component',
			width		: 30
		},{
			fieldLabel	:'생산품목',
			xtype		: 'uniTextfield',
			id			: 'MAIN_ITEM_CODE',
			labelWidth	: 80,
			width		: 200,
			readOnly	: true
		},{
			xtype		: 'component',
			width		: 30
		},{
			fieldLabel	: '불량합계',
			xtype		: 'uniNumberfield',
			id			: 'TOT_BAD',
			width		: 150,
			value		: 0,
			labelWidth	: 80,
			readOnly	: true
		}],
		uniOpt:{
			expandLastColumn	: false,
			useRowNumberer		: false,
			useMultipleSorting	: true,
			userToolbar			: false,
			onLoadSelectFirst	: false,
			state				: {
				useState	: false,
				useStateList: false
			}
		},
		sortableColumns: false,
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'CHECK_VALUE'		, width: 60 , hidden: true},
			{dataIndex: 'WKORD_NUM'			, width: 120, hidden:true},
			{dataIndex: 'PROG_WORK_NAME'	, width: 166, hidden:true,
				'editor': Unilite.popup('PROG_WORK_CODE_G',{
					textFieldName	: 'PROG_WORK_NAME',
					DBtextFieldName	: 'PROG_WORK_NAME',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid5.uniOpt.currentRecord;
								grdRecord.set('PROG_WORK_CODE', records[0]['PROG_WORK_CODE']);
								grdRecord.set('PROG_WORK_NAME', records[0]['PROG_WORK_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = masterGrid5.uniOpt.currentRecord;
							grdRecord.set('PROG_WORK_CODE', '');
							grdRecord.set('PROG_WORK_NAME', '');
						},
						applyextparam: function(popup){
							var param =  panelResult.getValues();
							record = detailGrid.getSelectedRecord();
							popup.setExtParam({'DIV_CODE'		: param.DIV_CODE});
							popup.setExtParam({'ITEM_CODE'		: record.get('ITEM_CODE')});
							popup.setExtParam({'WORK_SHOP_CODE'	: record.get('WORK_SHOP_CODE')});
						}
					}
				})
			},
			{dataIndex: 'PRODT_DATE'		, width: 100, hidden:true},
			{dataIndex: 'BAD_CODE'			, width: 200, tdCls:'x-change-cell_size'},
			{dataIndex: 'INPUT_Q'			, width: 80, tdCls:'x-change-cell_size'},		//20200428 수정: 100 -> 80
			{dataIndex: 'BAD_Q'				, width: 80, tdCls:'x-change-cell_size'},		//20200428 수정: 100 -> 80
			{dataIndex: 'REMARK'			, width: 600, hidden:true},
			{dataIndex: 'DIV_CODE'			, width: 80 , hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 80 , hidden: true},
			{dataIndex: 'PROG_WORK_CODE'	, width: 80 , hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 80 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width: 80 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 80 , hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 80 , hidden: true},
			{ text:'+' , dataIndex:'service', width: 88,									//20200428 수정: 100 -> 88
				renderer:function(value,cellmeta){
					return "<input type='button'  style= 'background-color: #ececec; border-style: groove; border-color: #f1f1f1; width: 80px; height: 40px;' value='  +  ' >"
				},
				listeners:{
					click:function(val,metaDate,record,rowIndex,colIndex,store,view){
						var tempQ = store.get('INPUT_Q') + store.get('BAD_Q');
						var tempTotQ = Ext.getCmp('TOT_BAD').getValue();
						store.set('BAD_Q',tempQ);
						Ext.getCmp('TOT_BAD').setValue(tempTotQ + store.get('INPUT_Q'));
						store.set('INPUT_Q',1);
						UniAppManager.app.onSaveDataButtonDown();
					}
				}
			},
			{ text:'-' , dataIndex:'service', width: 88,									//20200428 수정: 100 -> 88
				renderer:function(value,cellmeta){
					return "<input type='button'  style= 'background-color: #ececec; border-style: groove; border-color: #f1f1f1; width: 80px; height: 40px;' value='  -  ' >"
				},
				listeners:{
					click:function(val,metaDate,record,rowIndex,colIndex,store,view){
						var tempQ;
						var temp;
						if(store.get('INPUT_Q') > store.get('BAD_Q')){
							tempQ = 0;
							temp = store.get('BAD_Q');
						} else{
							tempQ = store.get('BAD_Q') - store.get('INPUT_Q');
							temp = store.get('INPUT_Q');
						}
						var tempTotQ = Ext.getCmp('TOT_BAD').getValue();
						store.set('BAD_Q',tempQ);
						Ext.getCmp('TOT_BAD').setValue(tempTotQ - temp);
						store.set('INPUT_Q',1);
						UniAppManager.app.onSaveDataButtonDown();	
					}
				}
			}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if (UniUtils.indexOf(e.field, ['BAD_CODE','BAD_Q']))
						return false
				}
				if(!e.record.phantom||e.record.phantom){
					if (UniUtils.indexOf(e.field, ['BAD_CODE','BAD_Q']))
						return false
				}
			},
			render: function(grid, eOpts) {
				grid.getEl().on('click', function(e, t, eOpt) {
					//UniAppManager.setToolbarButtons(['newData'], true);
					if(grid.getStore().count() > 0) {
						UniAppManager.setToolbarButtons(['delete'], true);
					} else {
						UniAppManager.setToolbarButtons(['delete'], false);
					}
				});
			}
		}
	});



	//20200406 추가
	var ProgressPanel = Unilite.createSearchForm('ProgressPanelForm', {
		layout			: {type: 'uniTable', columns : 3,
			tdAttrs: {/*style: 'border : 1px solid #ced9e7;', */align : 'center', width: '100%'}
		},
		trackResetOnLoad: true,
		height			: 515,
		items			: [{
			xtype	: 'container',
			layout	: {type : 'hbox', columns : 1,
				tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ align : 'left'}, width: '100%'},
			colspan	: 3,
			items	: [{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 2,
					tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'left'}
				},
				//20200416 추가
				padding	: '0 0 0 5',
				items	: [{
					xtype	: 'component',
					html	: "<span style='width: 150px; height: 40px; line-height: 40px; font-size: 20px;'>작업지시번호<span>",
					width	: 150,
					//20200416 추가
					padding	: '0 0 0 5',
					height	: 40
				},{
					xtype	: 'component',
					itemId	: 'TXT_WKORD_NUM',
					//20200416 추가
					padding	: '0 0 0 5',
					width	: 250
				},{
					xtype	: 'component',
					html	: "<span style='width: 150px; height: 40px; line-height: 40px; font-size: 20px;'>품목코드<span>",
					width	: 150,
					//20200416 추가
					padding	: '0 0 0 5',
					height	: 40
				},{
					xtype	: 'component',
					itemId	: 'TXT_ITEM_CODE',
					//20200416 추가
					padding	: '0 0 0 5',
					width	: 250
				},{
					xtype	: 'component',
					html	: "<span style='width: 150px; height: 40px; line-height: 40px; font-size: 20px;'>품목명<span>",
					padding	: '0 0 0 10',
					width	: 150,
					//20200416 추가
					padding	: '0 0 0 5',
					height	: 40
				},{
					xtype	: 'component',
					itemId	: 'TXT_ITEM_NAME',
					//20200416 추가
					padding	: '0 0 0 5',
					width	: 250
				},{
					xtype	: 'component',
					html	: "<span style='width: 150px; height: 40px; line-height: 40px; font-size: 20px;'>Lot No.<span>",
					width	: 150,
					//20200416 추가
					padding	: '0 0 0 5',
					height	: 40
				},{
					xtype	: 'component',
					itemId	: 'TXT_LOT_NO',
					//20200416 추가
					padding	: '0 0 0 5',
					width	: 250
				}]
			}]
		},{
			xtype	: 'component',
			colspan	: 3,
			width	: 100,
			height	: 20
		},{
			xtype	: 'component',
			width	: 10,
			height	: 100
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', align : 'center', columns : 3,
				tdAttrs: {align : 'center', valign: 'middle'}
			},
			items	: [/*{
				fieldLabel	: '',
				name		: 'PRODT_LINE',
				xtype		: 'component',
//				comboType	: 'AU',
//				comboCode	: 'ZP11',
				layout		: {style: 'border : 1px solid #ced9e7;'},
					html	: "<span style='width: 150px; height: 40px; line-height: 40px; font-size: 20px;'>Lot No.<span>",
				width		: 100,
				height		: 40,
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						var progCode = ProgressPanel.getValue('Progrs_Kind_Cd');
						if(newValue && gsProdtLineFlag) {
							var param = {
								COMP_CODE		: UserInfo.compCode,
								DIV_CODE		: ProgressPanel.getValue('DIV_CODE'),
								WKORD_NUM		: ProgressPanel.getValue('WKORD_NUM'),		//작업지시번호
								PROG_WORK_CODE	: ProgressPanel.getValue('PROG_WORK_CODE'),	//공정
								PRODT_LINE		: newValue,									//생산라인
								Progrs_Kind_Cd	: '00'										//진행상태코드
							}
							//생산라인 사용 중 확인
							s_pmr101ukrv_inService.fnCheckProgressCode(param, function(provider, response) {
								if(!Ext.isEmpty(provider) && provider == 'Y'){
									Unilite.messageBox('동일한 생산라인에서 작업이 진행 중입니다.')
									gsProdtLineFlag = false;
									ProgressPanel.setValue('PRODT_LINE', oldValue);
									gsProdtLineFlag = true;
									return false;
								} else {
									//진행상태가 "종료"일 경우에는 생산라인 변경해서 생산시작할 수 있도록 로직구현
									if(progCode == '03') {
										if(confirm('작업지시번호 [' + ProgressPanel.getValue('WKORD_NUM') + '], 생산수량 [' + ProgressPanel.getValue('WKORD_Q') + ']개의 진행상태를 "00-대기"로 변경하시겠습니까?')) {
											s_pmr101ukrv_inService.fnUpdateProgress(param, function(provider2, response) {
												if(!Ext.isEmpty(provider2) && provider2 == 'success'){
													ProgressPanel.setValue('Progrs_Kind_Cd', '00');
													fnButtonControl();
													Unilite.messageBox('진행상태가 "00-대기"로 변경되어 생산을 시작할 수 있습니다.');
												}
											});
										} else {
											gsProdtLineFlag = false;
											ProgressPanel.setValue('PRODT_LINE', oldValue);
											gsProdtLineFlag = true;
											Unilite.messageBox('생산라인 변경이 취소되었습니다.');
											return false;
										}
									}
								}
							});
						}
						gsProdtLineFlag = true;
					}
				}
			},{
				xtype	: 'component',
				width	: 10
			},*/{
				xtype	: 'button',
				itemId	: 'prodtLine',
				html	: '',
				width	: 250,
				height	: 100,
				handler	: function() {
					openProdtLinePopup();
				}
			},{
				fieldLabel	: 'PRODT_LINE',
				xtype		: 'uniTextfield',
				name		: 'PRODT_LINE',
				allowBlank	: false,
				hidden		: true,
				width		: 325
			}]
		},{
			xtype	: 'component',
			width	: 10,
			height	: 100
		},{
			xtype	: 'component',
			colspan	: 3,
			width	: 100,
			height	: 20
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', align : 'center', columns : 5,
				tdAttrs: {align : 'center'}
			},
			colspan	: 3,
			items	: [{
				xtype	: 'button',
				text	: "<span style='width: 150px; height: 100px; line-height: 100px; font-size: 25px;'>시작<span>",
				itemId	: 'startButton',
				width	: 150,
				height	: 100,
				handler	: function() {
					//20200408 수정: 필수 체크 수정
					if(Ext.isEmpty(ProgressPanel.getValue('PRODT_LINE'))) {
						Unilite.messageBox('생산라인은(는) 필수입력 항목입니다.');
						return false;
					}
//					if(!ProgressPanel.getInvalidMessage()) return false;
					var progCode	= ProgressPanel.getValue('Progrs_Kind_Cd');
					var startMessage= '작업지시번호 [' + ProgressPanel.getValue('WKORD_NUM') + '], 생산수량 [' + ProgressPanel.getValue('WKORD_Q') + ']개';
					if(progCode == '01') {
						Unilite.messageBox(startMessage + '가 이미 생산 시작되었습니다.');
						return false;
					} else if(progCode == '03') {
						if(confirm(startMessage + '는 이미 생산 종료되었습니다.' + '\n' + '재시작하시겠습니까?')) {
							fnRunProdtLine('01');
						}
					} else if(progCode == '00' || progCode == '02') {
						if(confirm(startMessage + '를 시작하시겠습니까?.')) {
							fnRunProdtLine('01');
						}
					}
				}
			},{
				xtype	: 'component',
				width	: 10
			},{
				xtype	: 'button',
				text	: "<span style='width: 150px; height: 100px; line-height: 100px; font-size: 25px;'>중지<span>",
				itemId	: 'stopButton',
				width	: 150,
				height	: 100,
				handler	: function() {
					//20200408 수정: 필수 체크 수정
					if(Ext.isEmpty(ProgressPanel.getValue('PRODT_LINE'))) {
						Unilite.messageBox('생산라인은(는) 필수입력 항목입니다.');
						return false;
					}
//					if(!ProgressPanel.getInvalidMessage()) return false;
					var progCode	= ProgressPanel.getValue('Progrs_Kind_Cd');
					var stopMessage	= '작업지시번호 [' + ProgressPanel.getValue('WKORD_NUM') + '], 생산수량 [' + ProgressPanel.getValue('WKORD_Q') + ']개';
					if(progCode == '01') {
						if(confirm(stopMessage + '를 생산 중지하시겠습니까?')) {
							fnRunProdtLine('02');
						}
					} else {
						Unilite.messageBox(stopMessage + '의 진행상태가 시작인 경우만 중지할 수 있습니다.');
					}
				}
			},{
				xtype	: 'component',
				width	: 10
			},{
				xtype	: 'button',
				text	: "<span style='width: 150px; height: 100px; line-height: 100px; font-size: 25px;'>종료<span>",
				itemId	: 'endButton',
				width	: 150,
				height	: 100,
				handler	: function() {
					//20200408 수정: 필수 체크 수정
					if(Ext.isEmpty(ProgressPanel.getValue('PRODT_LINE'))) {
						Unilite.messageBox('생산라인은(는) 필수입력 항목입니다.');
						return false;
					}
//					if(!ProgressPanel.getInvalidMessage()) return false;
					var progCode	= ProgressPanel.getValue('Progrs_Kind_Cd');
					var endMessage	= '작업지시번호 [' + ProgressPanel.getValue('WKORD_NUM') + '], 생산수량 [' + ProgressPanel.getValue('WKORD_Q') + ']개';
					if(progCode == '01' || progCode == '02') {
						if(confirm(endMessage + '를 생산 종료하시겠습니까?')) {
							fnRunProdtLine('03');
						}
					} else {
						Unilite.messageBox(endMessage + '는 종료 대상이 아닙니다.');
					}
				}
			}]
		},{
			fieldLabel	: 'DIV_CODE',
			xtype		: 'uniTextfield',
			name		: 'DIV_CODE',
			allowBlank	: false,
			hidden		: true,
			width		: 325
		},{
			fieldLabel	: 'WKORD_NUM',
			xtype		: 'uniTextfield',
			name		: 'WKORD_NUM',
			allowBlank	: false,
			hidden		: true,
			width		: 325
		},{
			fieldLabel	: 'ITEM_CODE',
			xtype		: 'uniTextfield',
			name		: 'ITEM_CODE',
			allowBlank	: false,
			hidden		: true,
			width		: 325
		},{
			fieldLabel	: 'ITEM_NAME',
			xtype		: 'uniTextfield',
			name		: 'ITEM_NAME',
			allowBlank	: false,
			hidden		: true,
			width		: 325
		},{
			fieldLabel	: 'LOT_NO',
			xtype		: 'uniTextfield',
			name		: 'LOT_NO',
			allowBlank	: false,
			hidden		: true,
			width		: 325
		},{
			fieldLabel	: 'PROG_WORK_CODE',
			xtype		: 'uniTextfield',
			name		: 'PROG_WORK_CODE',
			allowBlank	: false,
			hidden		: true,
			width		: 325
		},{
			fieldLabel	: 'WKORD_Q',
			xtype		: 'uniNumberfield',
			name		: 'WKORD_Q',
			allowBlank	: false,
			hidden		: true,
			width		: 325
		},{
			fieldLabel	: 'Progrs_Kind_Cd',
			xtype		: 'uniTextfield',
			name		: 'Progrs_Kind_Cd',
			allowBlank	: false,
			hidden		: true,
			width		: 325
		},{
			fieldLabel	: 'PROG_UNIT',
			xtype		: 'uniTextfield',
			name		: 'PROG_UNIT',
			allowBlank	: false,
			hidden		: true,
			width		: 325
		},{
			fieldLabel	: 'PRODT_DATE',
			xtype		: 'uniTextfield',
			name		: 'PRODT_DATE',
			allowBlank	: false,
			hidden		: true,
			width		: 325
		},{	//20200514 추가: PACK_QTY
			fieldLabel	: 'PACK_QTY',
			xtype		: 'uniNumberfield',
			name		: 'PACK_QTY',
			type		: 'uniQty',
			allowBlank	: false,
			hidden		: true,
			width		: 325
		}]
	});

	function openProgressPopup() {
		if(!ProgressWindow) {
			ProgressWindow = Ext.create('widget.uniDetailWindow', {
				title	: '생산라인 관리',
				width	: 900,			//800
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [ProgressPanel],
				tbar	: ['->', {
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						ProgressWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						ProgressPanel.clearForm();
						UniAppManager.app.onQueryButtonDown();
					},
					beforeclose: function( panel, eOpts ) {
						ProgressPanel.clearForm();
						UniAppManager.app.onQueryButtonDown();
					},
					show: function( panel, eOpts ) {
						//20200416 추가: 진행 버튼에서 여기로 로직 이동
						ProgressPanel.setValue('DIV_CODE'		, UserInfo.divCode);
						ProgressPanel.setValue('WKORD_NUM'		, gsSelectedRecord.get('WKORD_NUM'));
						ProgressPanel.setValue('ITEM_CODE'		, gsSelectedRecord.get('ITEM_CODE'));
						ProgressPanel.setValue('ITEM_NAME'		, gsSelectedRecord.get('ITEM_NAME'));
						ProgressPanel.setValue('LOT_NO'			, gsSelectedRecord.get('LOT_NO'));
						ProgressPanel.setValue('PROG_WORK_CODE'	, panelResult.getValue('PROG_WORK_CODE'));
						ProgressPanel.setValue('WKORD_Q'		, gsSelectedRecord.get('WKORD_Q'));
						ProgressPanel.setValue('Progrs_Kind_Cd'	, gsSelectedRecord.get('Progrs_Kind_Cd'));
						ProgressPanel.setValue('PROG_UNIT'		, gsSelectedRecord.get('PROG_UNIT'));
						ProgressPanel.setValue('PRODT_DATE'		, UniDate.getDbDateStr(panelResult.getValue('PRODT_DATE')));
						//20200514 추가: PACK_QTY
						ProgressPanel.setValue('PACK_QTY'		, gsSelectedRecord.get('PACK_QTY'));
						//20200416 주석: 콤보->버튼으로 변경 후 로직 수정(실제값은 hidden된 textfield에 입력)
//						ProgressPanel.setValue('PRODT_LINE'		, event.record.get('PRODT_LINE'));
						var prodtLineTxt = '';
						if(Ext.isEmpty(gsSelectedRecord.get('PRODT_LINE'))) {
							prodtLineTxt	= "<span style='width: 250px; height: 100px; line-height: 100px; font-size: 25px;'>라인선택<span>";
						} else {
							var prodtLineStore	= Ext.data.StoreManager.lookup('CBS_AU_ZP11')
							Ext.each(prodtLineStore.data.items, function(comboData, idx) {//lotno팝업에서 선택한 창고가 사용중인 창고이면 선택한 창고로 세팅
								if(comboData.get('value') == gsSelectedRecord.get('PRODT_LINE')){
									prodtLineTxt = "<span style='width: 250px; height: 100px; line-height: 100px; font-size: 25px;'>" + comboData.get('text') + "<span>";
								}
							});
						}
						ProgressPanel.down('#prodtLine').setHtml(prodtLineTxt);
						ProgressPanel.setValue('PRODT_LINE'		, gsSelectedRecord.get('PRODT_LINE'));
						//20200408 추가: 팝업에 해당 데이터 정보 표시
						ProgressPanel.down('#TXT_WKORD_NUM').setHtml("<span style='width: 150px; height: 40px; line-height: 40px; font-size: 20px;'>" + gsSelectedRecord.get('WKORD_NUM') + "<span>");
						ProgressPanel.down('#TXT_ITEM_CODE').setHtml("<span style='width: 150px; height: 40px; line-height: 40px; font-size: 20px;'>" + gsSelectedRecord.get('ITEM_CODE') + "<span>");
						ProgressPanel.down('#TXT_ITEM_NAME').setHtml("<span style='width: 150px; height: 40px; line-height: 40px; font-size: 20px;'>" + gsSelectedRecord.get('ITEM_NAME') + "<span>");
						ProgressPanel.down('#TXT_LOT_NO').setHtml("<span style='width: 150px; height: 40px; line-height: 40px; font-size: 20px;'>" + gsSelectedRecord.get('LOT_NO') + "<span>");
						fnButtonControl();
					}
				}
			})
		}
		ProgressWindow.center();
		ProgressWindow.show();
	}



	//20200416 추가: 공정라인 팝업
	//공정라인 스토어
	Unilite.defineModel('ProdtLineModel', {
		fields: [
			{name: 'SUB_CODE'	, text:'코드'			, type: 'string'},
			{name: 'CODE_NAME'	, text:'공정라인명'		, type: 'string'}
		]
	});
	var ProdtLineStore = Unilite.createStore('ProdtLineStore', {
		model	: 'ProdtLineModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		}
	});
	//공정라인 그리드
	var ProdtLineGrid = Unilite.createGrid('sof100ukrvProdtLineGrid', {
		store	: ProdtLineStore,
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: false
		},
		selModel: 'rowmodel',
		columns	: [
			{dataIndex: 'SUB_CODE'	, width: 80 , align: 'center', tdCls:'x-change-cell_size3'},
			{dataIndex: 'CODE_NAME'	, width: 250, tdCls:'x-change-cell_size3'},
			{	//20200406 추가: MES 데이터 연동위한 버튼 추가
				text	: '',
				xtype	: 'widgetcolumn',
				flex	: 1,
				widget	: {
					xtype	: 'button',
					text	: '선택',
					height	: 60,
					listeners: {
						buffer	: 1,
						click	: function(button, event, eOpts) {
							ProdtLineGrid.returnData(event.record)
							ProdtLineWindow.hide();
						}
					}
				}
			}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
//				ProdtLineGrid.returnData(record)
//				ProdtLineWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			var progCode = ProgressPanel.getValue('Progrs_Kind_Cd');
			var newValue = record.get('SUB_CODE');
			if(newValue) {
				var param = {
					COMP_CODE		: UserInfo.compCode,
					DIV_CODE		: ProgressPanel.getValue('DIV_CODE'),
					WKORD_NUM		: ProgressPanel.getValue('WKORD_NUM'),		//작업지시번호
					PROG_WORK_CODE	: ProgressPanel.getValue('PROG_WORK_CODE'),	//공정
					PRODT_LINE		: newValue,									//생산라인
					Progrs_Kind_Cd	: '00'										//진행상태코드
				}
				//생산라인 사용 중 확인
				s_pmr101ukrv_inService.fnCheckProgressCode(param, function(provider, response) {
					if(!Ext.isEmpty(provider) && provider == 'Y'){
						Unilite.messageBox('동일한 생산라인에서 작업이 진행 중입니다.')
						return false;
					} else {
						//진행상태가 "종료"일 경우에는 생산라인 변경해서 생산시작할 수 있도록 로직구현
						if(progCode == '03') {
							if(confirm('작업지시번호 [' + ProgressPanel.getValue('WKORD_NUM') + '], 생산수량 [' + ProgressPanel.getValue('WKORD_Q') + ']개의 진행상태를 "00-대기"로 변경하시겠습니까?')) {
								s_pmr101ukrv_inService.fnUpdateProgress(param, function(provider2, response) {
									if(!Ext.isEmpty(provider2) && provider2 == 'success'){
										ProgressPanel.setValue('Progrs_Kind_Cd', '00');
										fnButtonControl();
										Unilite.messageBox('진행상태가 "00-대기"로 변경되어 생산을 시작할 수 있습니다.');
									}
								});
							} else {
								Unilite.messageBox('생산라인 변경이 취소되었습니다.');
								return false;
							}
						}
						ProgressPanel.down('#prodtLine').setHtml("<span style='width: 250px; height: 100px; line-height: 100px; font-size: 25px;'>" + record.get('CODE_NAME') + "<span>");
						ProgressPanel.setValue('PRODT_LINE', record.get('SUB_CODE'));
					}
				});
			}
		}
	});
	function openProdtLinePopup() {
		if(!ProdtLineWindow) {
			ProdtLineWindow = Ext.create('widget.uniDetailWindow', {
				title	: '생산라인',
				width	: 500,
				height	: 500,
				layout	: {type:'vbox', align:'stretch'},
				items	: [ProdtLineGrid],
				tbar	: ['->', {
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						ProdtLineWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					show: function( panel, eOpts ) {
						var newDetailRecords= new Array();
						var prodtLineStore	= Ext.data.StoreManager.lookup('CBS_AU_ZP11')
						Ext.each(prodtLineStore.data.items, function(comboData, idx) {
							newDetailRecords[idx] = ProdtLineStore.model.create();
							newDetailRecords[idx].set('SUB_CODE'	, comboData.get('value'));
							newDetailRecords[idx].set('CODE_NAME'	, comboData.get('text'));
						});
						ProdtLineStore.loadData(newDetailRecords);
						ProdtLineStore.commitChanges();
					}
				}
			})
		}
		ProdtLineWindow.center();
		ProdtLineWindow.show();
	}




	Unilite.Main({
		id		: 's_pmr101ukrv_inApp',
		items	: [ panelResult,{
			xtype	: 'container',
			flex	: 1,
			layout	: {
				type	: 'hbox',
				align	: 'stretch'
			},
			items : [ detailGrid, masterGrid5 ]
		}],
		uniOpt: {
			showToolbar: false
		},
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			detailGrid.disabledLinkButtons(false);
			MODIFY_AUTH = true;
			this.setDefault();
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
			Ext.getCmp('TOT_BAD').setValue('0');
			Ext.getCmp('MAIN_WKORD_NUM').setValue('');
			Ext.getCmp('MAIN_ITEM_CODE').setValue('');
			directMasterStore5.loadData({})
			detailStore.loadStoreRecords();
			UniAppManager.setToolbarButtons(['delete'], false);
		},
		onNewDataButtonDown: function()	{
			var selectedDetailGrid = detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(selectedDetailGrid)) {
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 's_pmr101ukrv_inGrid5') {
					 var record			= detailGrid.getSelectedRecord();
					 var divCode		= masterForm.getValue('DIV_CODE');
					 var prodtDate		= UniDate.get('today');
					 var workShopcode	= record.get('WORK_SHOP_CODE');
					 var wkordNum		= record.get('WKORD_NUM');
					 var itemCode		= record.get('ITEM_CODE');
					 var progWorkName	= '';
					 var badCode		= '';
					 var badQ			= 0;
					 var remark			= '';

					 var r = {
						DIV_CODE			: divCode,
						PRODT_DATE			: prodtDate,
						WORK_SHOP_CODE		: workShopcode,
						WKORD_NUM			: wkordNum,
						ITEM_CODE			: itemCode,
						PROG_WORK_NAME		: progWorkName,
						BAD_CODE			: badCode,
						BAD_Q				: badQ,
						REMARK				: remark
					};
					masterGrid5.createRow(r);
				}
				masterForm.setAllFieldsReadOnly(false);
			} else {
				alert(Msg.sMA0256);
				return false;
			}
		},
		onResetButtonDown: function() {		// 새로고침 버튼
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			masterGrid5.reset();
			detailStore.clearData();
			directMasterStore5.clearData();
			this.fnInitBinding();
		},
		onDeleteDataButtonDown: function() {
			var selectedDetailGrid = detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(selectedDetailGrid)) {
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 's_pmr101ukrv_inGrid5') {
					var selRow = masterGrid5.getSelectedRecord();
					if(selRow.phantom === true)	{
						masterGrid5.deleteSelectedRow();
					} else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						masterGrid5.deleteSelectedRow();
					}
				}
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('s_pmr101ukrv_inAdvanceSerch');
			if(as.isHidden())	{
				as.show();
			} else {
				as.hide()
			}
		},
		onSaveDataButtonDown: function(config) {
			var selectDetailRecord = detailGrid.getSelectedRecord();
				directMasterStore5.saveStore();
				needSave = false;
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('PRODT_DATE',UniDate.get('today'));
			Ext.getCmp('TOT_BAD').setValue('0');
			Ext.getCmp('MAIN_WKORD_NUM').setValue('');
			Ext.getCmp('MAIN_ITEM_CODE').setValue('');
			getSelected = false;
			cbStore.loadStoreRecords();
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		}
	});




	Unilite.createValidator('validator05', {
		store: directMasterStore5,
		grid: masterGrid5,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			case "BAD_Q" :	// 수량
				if(newValue < 0) {
					rv= '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
					break;
				}
				record.set('CHECK_VALUE','C');
				needSave = true;
				if(newValue < oldValue){
					Ext.getCmp('TOT_BAD').setValue(parseInt(Ext.getCmp('TOT_BAD').getValue()) - (oldValue-newValue) );
				} else if(newValue > oldValue){
					if(Ext.getCmp('TOT_BAD').getValue()==0){
						Ext.getCmp('TOT_BAD').setValue((newValue-oldValue));
					} else{
						Ext.getCmp('TOT_BAD').setValue(parseInt(Ext.getCmp('TOT_BAD').getValue()) + (newValue-oldValue) );
					}
				}
				if(!Ext.isEmpty(record.obj.getModified('BAD_Q'))){
					if(record.obj.modified.BAD_Q == newValue){
						record.set('CHECK_VALUE',record.obj.getModified('CHECK_VALUE'));
					}
				}
				break;
			}
			return rv;
		}
	});



	function fnButtonControl() {
		if(ProgressPanel.getValue('Progrs_Kind_Cd') == '00') {
			ProgressPanel.down('#prodtLine').enable();
			ProgressPanel.down('#startButton').enable();
			ProgressPanel.down('#stopButton').disable();
			ProgressPanel.down('#endButton').disable();
		} else if(ProgressPanel.getValue('Progrs_Kind_Cd') == '01') {
			ProgressPanel.down('#prodtLine').disable();
			ProgressPanel.down('#startButton').disable();
			ProgressPanel.down('#stopButton').enable();
			ProgressPanel.down('#endButton').enable();
		} else if(ProgressPanel.getValue('Progrs_Kind_Cd') == '02') {
			ProgressPanel.down('#prodtLine').disable();
			ProgressPanel.down('#startButton').enable();
			ProgressPanel.down('#stopButton').disable();
			ProgressPanel.down('#endButton').enable();
		} else if(ProgressPanel.getValue('Progrs_Kind_Cd') == '03') {
			ProgressPanel.down('#prodtLine').enable();
			ProgressPanel.down('#startButton').enable();
			ProgressPanel.down('#stopButton').disable();
			ProgressPanel.down('#endButton').disable();
		}
	}

	function fnRunProdtLine(buttonFlag) {
		var param = {
			COMP_CODE		: UserInfo.compCode,
			DIV_CODE		: ProgressPanel.getValue('DIV_CODE'),
			PRODT_DATE		: ProgressPanel.getValue('PRODT_DATE'),		//생산실적일
			WKORD_NUM		: ProgressPanel.getValue('WKORD_NUM'),		//작업지시번호
			PROG_WORK_CODE	: ProgressPanel.getValue('PROG_WORK_CODE'),	//공정
			ITEM_CODE		: ProgressPanel.getValue('ITEM_CODE'),		//품목코드
			ITEM_NAME		: ProgressPanel.getValue('ITEM_NAME'),		//품목명
			LOT_NO			: ProgressPanel.getValue('LOT_NO'),			//LOT번호
			WKORD_Q			: ProgressPanel.getValue('WKORD_Q'),		//작지수량
			PRODT_LINE		: ProgressPanel.getValue('PRODT_LINE'),		//생산라인
			PROG_UNIT		: ProgressPanel.getValue('PROG_UNIT'),		//공정실적단위
			PACK_QTY		: ProgressPanel.getValue('PACK_QTY'),		//20200514 추가: PACK_QTY
			Progrs_Kind_Cd	: buttonFlag								//진행상태코드
		}
		s_pmr101ukrv_inService.fnRunProdtLine(param, function(provider, response) {
			if(!Ext.isEmpty(provider) && provider =='success'){
				if(buttonFlag == '01') {
					Unilite.messageBox('작업지시번호 [' + ProgressPanel.getValue('WKORD_NUM') + '], 생산수량 [' + ProgressPanel.getValue('WKORD_Q') + ']개를 생산 시작하였습니다.')
				} else if(buttonFlag == '02') {
					Unilite.messageBox('작업지시번호 [' + ProgressPanel.getValue('WKORD_NUM') + '], 생산수량 [' + ProgressPanel.getValue('WKORD_Q') + ']개가 생산 중지되었습니다.')
				} else if(buttonFlag == '03') {
					Unilite.messageBox('작업지시번호 [' + ProgressPanel.getValue('WKORD_NUM') + '], 생산수량 [' + ProgressPanel.getValue('WKORD_Q') + ']개가 생산 종료되었습니다.')
				}
				//20200408 수정: 작업완료 팝업을 닫으면 메인 팝업도 닫히도록 로직 변경
				ProgressWindow.hide();
//				ProgressPanel.setValue('Progrs_Kind_Cd', buttonFlag);
//				fnButtonControl();
			}
		});
	}
}
</script>