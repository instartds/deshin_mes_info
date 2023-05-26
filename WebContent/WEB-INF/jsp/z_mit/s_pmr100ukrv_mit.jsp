<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr100ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />	<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />	<!-- 단위   -->
	<t:ExtComboStore comboType="AU" comboCode="B014" />	<!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B023" />	<!-- 실적입고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="B039" />	<!-- 출고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" />	<!-- 세구분  -->
	<t:ExtComboStore comboType="AU" comboCode="B061" />	<!-- 발주방침 -->
	<t:ExtComboStore comboType="OU" />					<!-- 창고   -->
	<t:ExtComboStore comboType="WU" />					<!-- 작업장  -->
</t:appConfig>

<style type="text/css">
	.x-change-cell {
		background-color: #FFFFC6;
	}
</style>

<script type="text/javascript" >

var BsaCodeInfo = {
	gsManageLotNoYN	: '${gsManageLotNoYN}',		// 작업지시와 생산실적 LOT 연계여부 설정 값
	gsChkProdtDateYN: '${gsChkProdtDateYN}',	// 착수예정일 체크여부
	glEndRate		: '${glEndRate}',
	gsSumTypeCell	: '${gsSumTypeCell}',		// 재고합산유형 : 창고 Cell 합산
	gsLunchFr		: '${gsLunchFr}',			// 점심시간시작
	gsLunchTo		: '${gsLunchTo}'			// 점심시간종료
};
var tabChangeCheck = 'Y';

function appMain() {
	var workProgressWindow;				//20200317 추가: 진척이력 윈도우
	var colData = ${colData};	//불량유형 공통코드 데이터 가져오기
	var fields	= createModelField(colData);
	var columns	= createGridColumn(colData);

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 's_pmr100ukrv_mitService.selectList',
			create	: 's_pmr100ukrv_mitService.insertDetail',
			update	: 's_pmr100ukrv_mitService.updateDetail',
			destroy	: 's_pmr100ukrv_mitService.deleteDetail',
			syncAll	: 's_pmr100ukrv_mitService.saveAll'
		}
	});
	var tab2DirectProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 특기사항 등록
		api: {
			read	: 's_pmr100ukrv_mitService.selectListTab2',
			update	: 's_pmr100ukrv_mitService.updateTab2',
			create	: 's_pmr100ukrv_mitService.insertTab2',
			destroy	: 's_pmr100ukrv_mitService.deleteTab2',
			syncAll	: 's_pmr100ukrv_mitService.saveAllTab2'
		}
	});
	var directProxy10 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 자재불량내역
		api: {
			read	: 's_pmr100ukrv_mitService.selectDetailList10',
			update	: 's_pmr100ukrv_mitService.updateDetail10',
			create	: 's_pmr100ukrv_mitService.insertDetail10',
			destroy	: 's_pmr100ukrv_mitService.deleteDetail10',
			syncAll	: 's_pmr100ukrv_mitService.saveAll10'
		}
	});
	var tab3DirectProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 생산불량내역 등록
		api: {
			read	: 's_pmr100ukrv_mitService.selectDetailList5',
			update	: 's_pmr100ukrv_mitService.updateDetail5',
//			create	: 's_pmr100ukrv_mitService.insertDetail5',
			destroy	: 's_pmr100ukrv_mitService.deleteDetail5',
			syncAll	: 's_pmr100ukrv_mitService.saveAll5'
		}
	});
	var tab4DirectProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{//생산현황
		api: {
			read	: 's_pmr100ukrv_mitService.selectDetailList4',
			update	: 's_pmr100ukrv_mitService.updateDetail4',
			create	: 's_pmr100ukrv_mitService.insertDetail4',
			destroy	: 's_pmr100ukrv_mitService.deleteDetail4',
			syncAll	: 's_pmr100ukrv_mitService.saveAll4'
		}
	});

	var progWordComboStore = new Ext.data.Store({
		storeId	: 'pmr100ukrvProgWordComboStore',
		fields	: ['value', 'text','refCode1','option'],
		proxy	: {
			type: 'direct',
			api	: {
				read: 'UniliteComboServiceImpl.getPmp100tProgWorkCode'
			}
		},
		loadStoreRecords: function(record)	{
			var param		= panelSearch.getValues();
			param.WKORD_NUM	= record.get('WKORD_NUM');
			this.load({
				params : param
			});
		}
	});



	Unilite.defineModel('detailModel', {
		fields: [
			{name: 'WORK_SHOP_CODE'	,text: '작업장'			,type: 'string', comboType:'WU'},
			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'				,type: 'string'},
			{name: 'ITEM_CODE'		,text: '품목코드'			,type: 'string'},
			{name: 'ITEM_NAME'		,text: 'ITEM_NAME'		,type: 'string'},
			{name: 'SPEC'			,text: '규격'				,type: 'string'},
			{name: 'LOT_NO'			,text: 'LOT NO'			,type: 'string'},
			{name: 'PRODT_END_DATE'	,text: '완료예정일'			,type:'uniDate'	, allowBlank:false},
			{name: 'SEQ'			,text: '<t:message code="system.label.product.seq" default="순번"/>'							,type:'string'},
			{name: 'PROG_WORK_NAME'	,text: '<t:message code="system.label.product.routingname" default="공정명"/>'					,type:'string'},
			{name: 'PROG_UNIT'		,text: '<t:message code="system.label.product.unit" default="단위"/>'							,type:'string'},
			{name: 'PROG_WKORD_Q'	,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'				,type:'uniQty'},
			{name: 'SUM_Q'			,text: '<t:message code="system.label.product.productiontotal2" default="생산누계"/>'			,type:'uniQty'},
			{name: 'PRODT_DATE'		,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'				,type:'uniDate'	, allowBlank:false},
			{name: 'WORK_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'				,type:'uniQty'	, allowBlank:true},
			{name: 'GOOD_WORK_Q'	,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'					,type:'uniQty'	, allowBlank:true},
			{name: 'BAD_WORK_Q'		,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'					,type:'uniQty'},
			{name: 'DAY_NIGHT'		,text: '<t:message code="system.label.product.workteam" default="작업조"/>'					,type:'string', comboType: 'AU', comboCode: 'P507', defaultValue:'1' },
			{name: 'MAN_HOUR'		,text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'					,type:'uniQty'},
			{name: 'FR_TIME'		,text: '<t:message code="system.label.product.workhourfrom" default="시작시간"/>'				,type:'uniTime' , format:'Hi'},
			{name: 'TO_TIME'		,text: '<t:message code="system.label.product.workhourto" default="종료시간"/>'					,type:'uniTime' , format:'Hi'},
			{name: 'JAN_Q'			,text: '<t:message code="system.label.product.productionleftqty" default="생산잔량"/>'			,type:'uniQty'},
//			{name: 'LOT_NO'			,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'						,type:'string',maxLength: 6},
			{name: 'FR_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(시작)'				,type:'string'},
			{name: 'TO_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(종료)'				,type:'string'},
			{name: 'REMARK'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'						,type:'string'},
			//Hidden: true
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'					,type:'string'},
			{name: 'PROG_WORK_CODE'	,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'				,type:'string'},
			{name: 'PASS_Q'			,text: '<t:message code="system.label.product.productionqty" default="양품생산량"/>'				,type:'uniQty'},
//			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'				,type:'string'},
			{name: 'LINE_END_YN'	,text: '<t:message code="system.label.product.lastyn" default="최종여부"/>'						,type:'string'},
			{name: 'WK_PLAN_NUM'	,text: '<t:message code="system.label.product.planno" default="계획번호"/>'						,type:'string'},
			{name: 'PRODT_NUM'		,text: ''				,type:'string'},
			{name: 'CONTROL_STATUS'	,text: ''				,type:'string'},
			{name: 'UPDATE_DB_USER'	,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'					,type:'string'},
			{name: 'UPDATE_DB_TIME'	,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'					,type:'uniDate'},
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'				,type:'string'},
			{name: 'GOOD_WH_CODE'	,text: '<t:message code="system.label.product.goodreceiptwarehouse" default="양품입고창고"/>'		,type:'string'},
			{name: 'GOOD_PRSN'		,text: '<t:message code="system.label.product.goodreceiptincharge" default="양품입고담당"/>'		,type:'string'},
			{name: 'BAD_WH_CODE'	,text: '<t:message code="system.label.product.defectreceiptwarehouse" default="불량입고창고"/>'	,type:'string'},
			{name: 'BAD_PRSN'		,text: '<t:message code="system.label.product.defectreceiptincharge" default="불량입고담당"/>'	,type:'string'},
			{name: 'MOLD_CODE'		,text: 'MOLD_CODE'		,type:'string'},
			{name: 'CAVIT_BASE_Q'	,text: 'CAVIT_BASE_Q'	,type:'uniQty'},
			{name: 'EQUIP_CODE'		,text: '<t:message code="system.label.product.facilities" default="설비"/>'					,type:'string'},
			{name: 'EQUIP_NAME'		,text: '<t:message code="system.label.product.facilitiesname" default="설비명"/>'				,type:'string'},
			{name: 'PRODT_PRSN'		,text: '<t:message code="system.label.product.worker" default="작업자"/>'						,type:'string', comboType: 'AU', comboCode: 'P505'},
			{name: 'EXPIRATION_DATE',text: '<t:message code="system.label.product.expirationdate" default="유통기한"/>'				,type:'uniDate'	, allowBlank:true},
			{name: 'BOX_TRNS_RATE'	,text: 'BOX입수'			,type:'float'	, decimalPrecision: 0, format:'0,0000'	, allowBlank:true},
			{name: 'BOX_Q'			,text: 'BOX수량'			,type:'float'	, decimalPrecision: 0, format:'0,0000'	, allowBlank:true},
			{name: 'SAVING_Q'		,text: '관리수량'			,type:'float'	, decimalPrecision: 0, format:'0,0000'	, allowBlank:true},
			{name: 'MAN_CNT'		,text: '작업인원'			,type:'float'	, decimalPrecision: 0, format:'0,0000'	, allowBlank:true},
			{name: 'HAZARD_CHECK'	,text: '유해물질검사요청'		,type:'bool'	, allowBlank:true},
			{name: 'MICROBE_CHECK'	,text: '미생물검사요청'		,type:'bool'	, allowBlank:true},
			{name: 'LUNCH_CHK'		,text: '점심시간제외'			,type: 'boolean'},
			{name: 'PIECE'			,text: '<t:message code="system.label.product.piece" default="낱개"/>'						,type:'float', decimalPrecision: 0, format:'0,0000'	},
			{name: 'LOSS_Q'			,text: 'LOSS량'			,type:'uniQty'},
			{name: 'YIELD'			,text: '<t:message code="system.label.product.yield" default="수율(%)"/>'						,type:'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'ETC_Q'			,text: '<t:message code="system.label.product.etcqty" default="기타수량"/>'						,type:'float', decimalPrecision: 0, format:'0,0000'},
			{name: 'GOOD_WH_CELL_CODE'	,text: '<t:message code="system.label.product.goodwarehousecell" default="양품창고cell"/>'	,type:'string'},
			{name: 'BAD_WH_CELL_CODE'	,text: '<t:message code="system.label.product.badwarehousecell" default="불량창고cell"/>'	,type:'string'},
			//20200317 추가: 완성율, 완성일(오늘), 작업월(진척이력 조회용)
			{name: 'WORK_PROGRESS'	,text: '진척율'			,type:'float'},
			{name: 'DUE_DATE'		,text: 'DUE_DATE'		,type:'uniDate'},
			{name: 'WORK_MONTH'		,text: '실적월'			,type:'string' , editable: false},
			{name: 'MAN_HOUR_150'	,text: 'MAN_HOUR_150'	,type:'string' , editable: false}
		]
	});	

	/** 특기사항등록
	 * @type
	 */
	Unilite.defineModel('tab2Model', {
		fields: [
			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string'},
			{name: 'PROG_WORK_CODE'	,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'				,type:'string', allowBlank:false },
			{name: 'PROG_WORK_NAME'	,text: '<t:message code="system.label.product.routingname" default="공정명"/>'				,type:'string'},
			{name: 'PRODT_DATE'		,text: '<t:message code="system.label.product.occurreddate" default="발생일"/>'			,type:'uniDate', allowBlank:false},
			{name: 'CTL_CD1'		,text: '<t:message code="system.label.product.specialremarkclass" default="특기사항 분류"/>'	,type:'string', allowBlank:false, comboType: 'AU', comboCode: 'P002'},
			{name: 'TROUBLE_TIME'	,text: '<t:message code="system.label.product.occurredtime" default="발생시간"/>'			,type:'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'TROUBLE'		,text: '<t:message code="system.label.product.summary" default="요약"/>'				,type:'string'},
			{name: 'TROUBLE_CS'		,text: '<t:message code="system.label.product.reason" default="원인"/>'				,type:'string'},
			{name: 'ANSWER'			,text: '<t:message code="system.label.product.action" default="조치"/>'				,type:'string'},
			{name: 'SEQ'			,text: ''				,type:'int'},
			//Hidden : true
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'		,type:'string'},
			{name: 'WORK_SHOP_CODE' ,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'		,type:'string'},
			//{name: 'PROG_WORK_CODE' ,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'},
			{name: 'UPDATE_DB_USER' ,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'			,type:'string'},
			{name: 'UPDATE_DB_TIME'	,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'			,type:'uniDate'},
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'			,type:'string'},
			{name: 'FR_TIME'		,text: '<t:message code="system.label.product.workhourfrom" default="시작"/>'					,type:'uniTime' , format:'Hi'},
			{name: 'TO_TIME'		,text: '<t:message code="system.label.product.workhourto" default="종료"/>'					,type:'uniTime' , format:'Hi'}
		]
	});

	Unilite.defineModel('tab3Model', {
		fields: [
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string', allowBlank:false},
			{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string', allowBlank:false}, //store: Ext.data.StoreManager.lookup('pmr100ukrvProgWordComboStore') , allowBlank:false },
			{name: 'PROG_WORK_NAME'		,text: '<t:message code="system.label.product.routingname" default="공정명"/>'			,type:'string'},
			{name: 'PRODT_DATE'			,text: '<t:message code="system.label.product.occurreddate" default="발생일"/>'			,type:'uniDate', allowBlank:false},
			{name: 'BAD_CODE'			,text: '<t:message code="system.label.product.defecttype" default="불량유형"/>'			,type:'string', allowBlank:false, comboType: 'AU', comboCode: 'P003'},
			{name: 'BAD_Q'				,text: '<t:message code="system.label.product.qty" default="수량"/>'				,type:'uniQty', allowBlank:false},
			{name: 'REMARK'				,text: '<t:message code="system.label.product.issueandmeasures" default="문제점 및 대책"/>'		,type:'string'},
			//Hidden : true
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'			,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'			,type:'string'},
			//{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type:'string'},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'			,type:'string'},
			{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'			,type:'uniDate'},
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'			,type:'string'}
		]
	});
	//자재불량내역 모델 필드 생성
	function createModelField(colData) {
		var fields = [
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'	,type: 'string'},
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'	,type: 'string'},
			{name: 'ITEM_CODE'	,text: '<t:message code="system.label.product.item" default="품목"/>'			,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'	,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'			 ,type:'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'				, type: 'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value'},
			{name: 'CUSTOM_CODE'				, text: '<t:message code="system.label.product.custom" default="거래처코드"/>'		 , type: 'string'},
			{name: 'CUSTOM_NAME'				, text: '<t:message code="system.label.product.customname" default="거래처 명"/>'		 , type: 'string'},
			{name: 'WORK_SHOP_CODE' ,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'		,type:'string'},
			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string'},
			{name: 'PRODT_NUM'		,text: '<t:message code="system.label.product.productionno" default="생산번호"/>'			,type:'string'},
			{name: 'SEQ'			,text: '<t:message code="system.label.product.seq" default="순번"/>'						,type:'string'},
			{name: 'SAVE_FLAG'			,text: 'SAVE_FLAG'						,type:'string'}
		];
		//동적 컬럼 모델 push
		Ext.each(colData, function(item, index){
			fields.push({name: 'BAD_' + item.SUB_CODE, type:'uniQty' });
		});
		console.log(fields);
		return fields;
	}

	//자재불량내역 그리드 컬럼 생성
	function createGridColumn(colData) {
		var array1  = new Array();
		var columns = [
			{dataIndex: 'SAVE_FLAG'			, width: 66		, hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'SEQ'			, width: 40, align:'center', hidden: false, locked: true},
			{dataIndex: 'WKORD_NUM'			, width: 66		, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'PRODT_NUM'			, width: 66		, hidden: true},
			{dataIndex: 'ITEM_CODE'	, width: 90		, locked: true},
			{dataIndex: 'ITEM_NAME'			, width: 250	, locked: true},
			{dataIndex: 'SPEC'		, width: 70		, locked: false, align:'center'},
			{dataIndex: 'STOCK_UNIT'			, width: 50, align:'center'	, locked: false},
			{dataIndex: 'CUSTOM_CODE'		, width: 70	, locked: false, hidden: true,
				editor: Unilite.popup('AGENT_CUST_G',{
                    autoPopup: true,
                    listeners:{ 'onSelected': {
                                    fn: function(records, type  ){
                                        // var grdRecord =
                                        // Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                    	   if(gsPopupChk == 'RESULT'){
                                        	   var grdRecord = masterGrid12.uniOpt.currentRecord;
                                           }else{
                                        	   var grdRecord = masterGrid10.uniOpt.currentRecord;
                                           }
                                        grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                                        grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                                    },
                                    scope: this
                                  },
                                  'onClear' : function(type)    {
                                        // var grdRecord =
                                        // Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                	   if(gsPopupChk == 'RESULT'){
                                    	   var grdRecord = masterGrid12.uniOpt.currentRecord;
                                       }else{
                                    	   var grdRecord = masterGrid10.uniOpt.currentRecord;
                                       }
                                        grdRecord.set('CUSTOM_CODE','');
                                        grdRecord.set('CUSTOM_NAME','');
                                  }
                                }
                    } )
			},
			{dataIndex: 'CUSTOM_NAME'				, width: 150		, locked: false,
				editor: Unilite.popup('AGENT_CUST_G',{
                    autoPopup: true,
                    listeners:{ 'onSelected': {
                                    fn: function(records, type  ){
                                        // var grdRecord =
                                        // Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                       if(gsPopupChk == 'RESULT'){
                                    	   var grdRecord = masterGrid12.uniOpt.currentRecord;
                                       }else{
                                    	   var grdRecord = masterGrid10.uniOpt.currentRecord;
                                       }

                                        grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                                        grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                                    },
                                    scope: this
                                  },
                                  'onClear' : function(type)    {
                                        // var grdRecord =
                                        // Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                	  if(gsPopupChk == 'RESULT'){
                                   	   var grdRecord = masterGrid12.uniOpt.currentRecord;
                                      }else{
                                   	   var grdRecord = masterGrid10.uniOpt.currentRecord;
                                      }
                                        grdRecord.set('CUSTOM_CODE','');
                                        grdRecord.set('CUSTOM_NAME','');
                                  }
                                }
                    } )
             }
		];
		Ext.each(colData, function(item, index){
			if(index == 0){
				gsBadQtyInfo = item.SUB_CODE;
			} else {
				gsBadQtyInfo += ',' + item.SUB_CODE;
			}
			array1[index] = Ext.applyIf({dataIndex: 'BAD_' + item.SUB_CODE	, text: item.CODE_NAME	, flex:1},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty });
		});
		columns.push(
			{text: '<t:message code="system.label.product.defectinfo" default="불량정보"/>',
				columns: array1
			}
		);
 		console.log(columns);
		return columns;
	}

	Unilite.defineModel('pmr100ukrvModel10', {
		fields: fields
	});

	Unilite.defineModel('tab4Model', {	//생산현황
		fields: [
			{name: 'PRODT_NUM'		,text: '<t:message code="system.label.product.productionno" default="생산번호"/>'				,type:'string'},
			{name: 'PRODT_DATE'		,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'				,type:'uniDate'},
			{name: 'WORK_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'				,type:'uniQty'},
			{name: 'GOOD_WORK_Q'	,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'				,type:'uniQty'},
			{name: 'BAD_WORK_Q'		,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'					,type:'uniQty'},
			{name: 'DAY_NIGHT'		,text: '<t:message code="system.label.product.workteam" default="작업조"/>'					,type:'string', comboType: 'AU', comboCode: 'P507', defaultValue:'1' },
			{name: 'MAN_HOUR'		,text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'					,type:'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'FR_TIME'		,text: '<t:message code="system.label.product.workhourfrom" default="시작"/>'					,type:'uniTime' , format:'Hi'},
			{name: 'TO_TIME'		,text: '<t:message code="system.label.product.workhourto" default="종료"/>'					,type:'uniTime' , format:'Hi'},
			{name: 'IN_STOCK_Q'		,text: '<t:message code="system.label.product.receiptqty" default="입고량"/>'					,type:'uniQty'},
			{name: 'LOT_NO'			,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'						,type:'string'},
			{name: 'FR_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(시작)'			,type:'string'},
			{name: 'TO_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(종료)'			,type:'string'},
			{name: 'REMARK'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'						,type:'string'},
			//Hidden: true
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'					,type:'string'},
			{name: 'PROG_WKORD_Q'	,text: ''				,type:'uniQty'},
			{name: 'PASS_Q'		,text: ''				,type:'uniQty'},
			{name: 'PROG_WORK_CODE'	,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'				,type:'string'},
			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			,type:'string'},
			{name: 'WK_PLAN_NUM'	,text: '<t:message code="system.label.product.planno" default="계획번호"/>'					,type:'string'},
			{name: 'LINE_END_YN'	,text: '<t:message code="system.label.product.lastyn" default="최종여부"/>'					,type:'string'},
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'				,type:'string'},
			{name: 'CONTROL_STATUS'	,text: ''				,type:'string'},
			{name: 'GOOD_WH_CODE'	,text: '<t:message code="system.label.product.goodreceiptwarehouse" default="양품입고창고"/>'	,type:'string'},
			{name: 'GOOD_PRSN'		,text: '<t:message code="system.label.product.goodreceiptincharge" default="양품입고담당"/>'	,type:'string'},
			{name: 'BAD_WH_CODE'	,text: '<t:message code="system.label.product.defectreceiptwarehouse" default="불량입고창고"/>'	,type:'string'},
			{name: 'BAD_PRSN'		,text: '<t:message code="system.label.product.defectreceiptincharge" default="불량입고담당"/>'	,type:'string'},
			{name: 'EXPIRATION_DATE',text: '<t:message code="system.label.product.expirationdate" default="유통기한"/>'			,type:'uniDate'	, allowBlank:true},
			{name: 'BOX_TRNS_RATE'	,text: 'BOX입수'		,type:'float'	 , decimalPrecision: 0, format:'0,000'	, allowBlank:true},
			{name: 'BOX_Q'			,text: 'BOX수량'			,type:'float', decimalPrecision: 0, format:'0,000'	, allowBlank:true},
			{name: 'SAVING_Q'		,text: '관리수량'			,type:'uniQty'	, allowBlank:true},
			{name: 'MAN_CNT'		,text: '작업인원'			,type:'uniQty'	, allowBlank:true},
			{name: 'HAZARD_CHECK'	,text: '유해물질검사요청'	,type:'bool'	, allowBlank:true},
			{name: 'MICROBE_CHECK'	,text: '미생물검사요청'		,type:'bool'	, allowBlank:true},
			{name: 'PIECE'          , text: '<t:message code="system.label.product.piece" default="낱개"/>'     ,type:'float', decimalPrecision: 0, format:'0,000'},
			{name: 'LOSS_Q'         , text:  'LOSS량'      ,type:'uniQty'},
			{name: 'YIELD'          , text: '<t:message code="system.label.product.yield" default="수율(%)"/>'     ,type:'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'ETC_Q'         , text: '<t:message code="system.label.product.etcqty" default="기타수량"/>'      ,type:'float', decimalPrecision: 0, format:'0,0000'},
			{name: 'EQUIP_CODE'		,text: '<t:message code="system.label.product.facilities" default="설비"/>'					,type:'string'},
			{name: 'EQUIP_NAME'		,text: '<t:message code="system.label.product.facilitiesname" default="설비명"/>'				,type:'string'},
			{name: 'PRODT_PRSN'		,text: '<t:message code="system.label.product.worker" default="작업자"/>'						,type:'string', comboType: 'AU', comboCode: 'P505'}
		]
	});


	var detailStore = Unilite.createStore('detailStore',{
		model: 'detailModel',
		proxy: directProxy,
		autoLoad: false,
		uniOpt: {
			isMaster: true,	// 상위 버튼 연결 
			editable: false,	// 수정 모드 사용 
			deletable: false,	// 삭제 가능 여부 
			useNavi: false	// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
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
			var paramMaster= masterForm.getValues();	//syncAll 수정

			//2. 초과실적 체크로직
			if(inValidRecs.length == 0) {
				var detailRecord = detailGrid.getSelectedRecord();
				var saveFlag= true;
				var fnCal	= 0;
				Ext.each(list, function(record,i) {
					var prodtSum	= record.get('SUM_Q') + record.get('WORK_Q');
					var A = record.get('PROG_WKORD_Q');			//작업지시량
					var D = record.get('LINE_END_YN');

					if(D == 'Y') {
						fnCal = ( prodtSum / A ) * 100
					} else {
						fnCal = 0;
					}
					if(fnCal > (100 * (BsaCodeInfo.glEndRate / 100))) {
						saveFlag	= false;
						Unilite.messageBox('<t:message code="system.message.product.message009" default="초과 생산 실적 범위를 벗어났습니다."/>');
						return false;
					}
					if (D == 'Y') {
						record.set('CONTROL_STATUS', '9');	//무조건 완료처리로 변경
						
//						if(fnCal >= '95'/* || ((fnCal < '95') && detailRecord.get('CONTROL_STATUS') == '9')*/) {
//							if(confirm('<t:message code="system.message.product.confirm004" default="완료하시겠습니까?"/>')) {
//								record.set('CONTROL_STATUS', '9');
//							} else {
//								if(detailRecord.get('CONTROL_STATUS') == '9') {
//									record.set('CONTROL_STATUS', '3');
//								}
//							}
//						}else{
//							if(detailRecord.get('CONTROL_STATUS') == '9') {
//								record.set('CONTROL_STATUS', '3');
//							}
//						}
						
					}
				});

				if (!saveFlag) {
					return false;
				}

				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						var record = detailGrid.getSelectedRecord();
					/*	if(!Ext.isEmpty(master.PRODT_NUM)) {
							gsProdtNum = master.PRODT_NUM;
							if(directMasterStore10.isDirty()){
								directMasterStore10.saveStore();
							}
						}*/
						if(!Ext.isEmpty(master.CONTROL_STATUS)) {
							record.set("CONTROL_STATUS", master.CONTROL_STATUS);
							detailStore.commitChanges();
						}

						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						
						panelSearch.setValue('WKORD_NUM',masterForm.getValue('WKORD_NUM'));
						panelSearch.setValue('CONTROL_STATUS','1');
						
						setTimeout( function() {
							detailStore.loadStoreRecords();
							tab4Store.loadStoreRecords(record);
							
							panelSearch.getField('WKORD_NUM_INPUT').focus();
//							panelSearch.getField('WKORD_NUM').selectText();
						}, 50 );
					}
				};
				this.syncAllDirect(config);
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var sm = detailGrid.getSelectionModel();
				var selRecords = detailGrid.getSelectionModel().getSelection();
			
				var records = detailStore.data.items;
			     
			    Ext.each(records, function(record, index){
					if(record.get('WKORD_NUM') == masterForm.getValue('WKORD_NUM') &&
						record.get('PROG_WORK_CODE') == masterForm.getValue('PROG_WORK_CODE')){
						selRecords.push(record);
					}
				});
			    sm.select(selRecords);
			    
				tabChangeCheck = 'Y';
				
				var sm = detailGrid.getSelectionModel();
				var selRecords = detailGrid.getSelectionModel().getSelection();
//				var records = detailStore.data.items;
				if(records.length == 1){
					selRecords.push(records[0]);	
					sm.select(selRecords);
					
					panelSearch.setValue('MSG_F','');
				}else if(records.length == 0){
					masterForm.clearForm();
					tab1Form.clearForm();
					panelSearch.setValue('MSG_F','※ 조회된 데이터가 없습니다.');
				}else{
					panelSearch.setValue('MSG_F','');
				}
				//20200312 포커스 워치 로직 위치 변경
setTimeout( function() {
				panelSearch.getField('WKORD_NUM_INPUT').focus();
}, 50 );
			},
			datachanged : function(store,  eOpts) {
                if( store.isDirty() )   {
                    UniAppManager.setToolbarButtons('save', true);  
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }
            }
		}
	});

	var tab3Store = Unilite.createStore('tab3Store',{
		model: 'tab3Model',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: tab3DirectProxy,
		loadStoreRecords : function(record)	{
			var param= panelSearch.getValues();
			if(!Ext.isEmpty(record)) {
				param.WORK_SHOP_CODE	= record.get('WORK_SHOP_CODE');
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.WKORD_Q			= record.get('WKORD_Q');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
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
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
					/*	var master = batch.operations[0].getResultSet();
						masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
						*/
						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						var record = detailGrid.getSelectedRecord();
						tab3Store.loadStoreRecords(record);
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('tab3Grid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{

			}
		}
	});
	var tab4Store = Unilite.createStore('tab4Store',{
		model: 'tab4Model',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,		// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: tab4DirectProxy,
		loadStoreRecords : function(record)	{
			var param= panelSearch.getValues();
			if(!Ext.isEmpty(record)) {
				param.WORK_SHOP_CODE	= record.get('WORK_SHOP_CODE');
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.WKORD_Q			= record.get('WKORD_Q');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
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
			var list = [].concat(toUpdate, toCreate, toDelete);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			var detailGridRecord = detailGrid.getSelectedRecord();
			paramMaster.MOLD_CODE = detailGridRecord.get('MOLD_CODE');
			paramMaster.CAVIT_BASE_Q = detailGridRecord.get('CAVIT_BASE_Q');
			if(inValidRecs.length == 0) {
				var saveFlag	= true;
				var fnCal		= 0;
				var prodtSum	= this.sumBy(function(record, id){
					return true
				  }, ['WORK_Q']);

				Ext.each(list, function(record,i) {
					var detailRecord = detailGrid.getSelectedRecord();
					var A = detailRecord.get('WKORD_Q');			//작업지시량
					var D = record.get('LINE_END_YN');

					if(D == 'Y') {
						fnCal = ( prodtSum.WORK_Q / A ) * 100
					} else {
						fnCal = 0;
					}
					if(fnCal > (100 * (BsaCodeInfo.glEndRate / 100))) {
						saveFlag	= false;
						Unilite.messageBox('<t:message code="system.message.product.message009" default="초과 생산 실적 범위를 벗어났습니다."/>');
						return false;
					}
					if (D == 'Y') {
						if(fnCal >= '95'/* || ((fnCal < '95') && detailRecord.get('CONTROL_STATUS') == '9')*/) {
							if(confirm('<t:message code="system.message.product.confirm004" default="완료하시겠습니까?"/>')) {
								record.set('CONTROL_STATUS', '9');

							} else {
								if(detailRecord.get('CONTROL_STATUS') == '9') {
									record.set('CONTROL_STATUS', '3');
								}
							}
						}else{
							if(detailRecord.get('CONTROL_STATUS') == '9') {
								record.set('CONTROL_STATUS', '3');
							}
						}
					}
				});

				if (!saveFlag) {
					return false;
				}


				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						var record = detailGrid.getSelectedRecord();
						if(!Ext.isEmpty(master.CONTROL_STATUS)) {
							record.set("CONTROL_STATUS", master.CONTROL_STATUS);
							detailGrid.getStore().commitChanges();
						}
						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						detailStore.loadStoreRecords();
						tab4Store.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('tab4Grid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
           	load:function(store, records, successful, eOpts) {
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 'tab4') {
					UniAppManager.setToolbarButtons(['delete'], true);
				}else{
					UniAppManager.setToolbarButtons(['delete'], false);
				}
				setTimeout( function() {
					
					var selectedRecord	= detailGrid.getSelectedRecord();
					if(!Ext.isEmpty(selectedRecord)){
						if(selectedRecord.get('WORK_Q')==0 && selectedRecord.get('JAN_Q') > 0){
							if(selectedRecord.get('CONTROL_STATUS') != '9' || selectedRecord.get('CONTROL_STATUS') != '8'){
								UniAppManager.setToolbarButtons(['save'], true);
							}
						}
					}
				}, 50 );
			}
		}
	});
	var tab2Store = Unilite.createStore('tab2Store',{
		model: 'tab2Model',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: tab2DirectProxy,
		loadStoreRecords : function(record)	{
			var param= panelSearch.getValues();
			if(!Ext.isEmpty(record)) {
				param.WORK_SHOP_CODE	= record.get('WORK_SHOP_CODE');
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.WKORD_Q			= record.get('WKORD_Q');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
			}else{
				var record	= detailGrid.getSelectedRecord();
				
				param.WORK_SHOP_CODE	= record.get('WORK_SHOP_CODE');
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.WKORD_Q			= record.get('WKORD_Q');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
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
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
					/*	var master = batch.operations[0].getResultSet();
						masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
						*/
						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						tab2Store.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('tab2Grid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{

			}
		},_onStoreUpdate: function (store, eOpt) {
			console.log("Store data updated save btn enabled !");
			this.setToolbarButtons('sub_save4', true);
		}, // onStoreUpdate

		_onStoreLoad: function ( store, records, successful, eOpts ) {
			console.log("onStoreLoad");
			if (records) {
				this.setToolbarButtons('sub_save4', false);
			}
		},
		_onStoreDataChanged: function( store, eOpts ) {
			console.log("_onStoreDataChanged store.count() : ", store.count());
			if(store.count() == 0){
				this.setToolbarButtons(['sub_delete4'], false);
				Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':false}});
			}else {
				if(this.uniOpt.deletable)	{
					this.setToolbarButtons(['sub_delete4'], true);
					Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':true}});
				}
			}
			if(store.isDirty()) {
				this.setToolbarButtons(['sub_save4'], true);
			}else {
				this.setToolbarButtons(['sub_save4'], false);
			}
		},
		setToolbarButtons: function( btnName, state)	 {
			var toolbar = tab2Grid.getDockedItems('toolbar[dock="top"]');

			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
		}
	});

	/***생산 실적 팝업의 자재불량 스토어***/
	var directMasterStore10 = Unilite.createStore('pmr100ukrvMasterStore10',{
		model: 'pmr100ukrvModel10',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy10,
		loadStoreRecords : function(badQtyArray)	{
			var param	= masterForm.getValues();
			var record	= detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
			}
			if(!Ext.isEmpty(badQtyArray)) {
				param.badQtyArray = badQtyArray;
			}
			param.POPUP_CHK = gsPopupChk;
			param.PRODT_NUM = gsProdtNum;
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
			var paramMaster= masterForm.getValues();	//syncAll 수정
			var badQtyArray = new Array();
			badQtyArray = gsBadQtyInfo.split(',');
			if(!Ext.isEmpty(badQtyArray)) {
				paramMaster.badQtyArray = badQtyArray;
			}
			
			var record	= detailGrid.getSelectedRecord();
			paramMaster.PRODT_NUM = gsProdtNum;
			paramMaster.PRODT_DATE =  record.get('PRODT_DATE');
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
					/*	var master = batch.operations[0].getResultSet();
						masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
						*/
						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						directMasterStore10.loadStoreRecords(badQtyArray);
					},
	                 failure: function(batch, option) {
	                	 directMasterStore10.loadStoreRecords(badQtyArray);
	                 }
				};
				this.syncAllDirect(config);
			} else {
				if(gsPopupChk == 'WKORD'){
					var grid = Ext.getCmp('pmr100ukrvGrid10');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}else{
					var grid = Ext.getCmp('pmr100ukrvGrid12');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		},
		listeners:{
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{

			}
		},_onStoreUpdate: function (store, eOpt) {
			if(gsPopupChk == 'RESULT'){
				console.log("Store data updated save btn enabled !");
				this.setToolbarButtons('sub_save12', true);
			}
		}, // onStoreUpdate

		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(gsPopupChk == 'RESULT'){
				console.log("onStoreLoad");
				if (records) {
					this.setToolbarButtons('sub_save12', false);
				}
			}
		},
		_onStoreDataChanged: function( store, eOpts ) {
			if(gsPopupChk == 'RESULT'){
				console.log("_onStoreDataChanged store.count() : ", store.count());
				if(store.count() == 0){
					this.setToolbarButtons(['sub_delete12'], false);
					Ext.apply(this.uniOpt.state, {'btn':{'sub_delete12':false}});
				}else {
					if(this.uniOpt.deletable)	{
						this.setToolbarButtons(['sub_delete12'], true);
						Ext.apply(this.uniOpt.state, {'btn':{'sub_delete12':true}});
					}
				}
				if(store.isDirty()) {
					this.setToolbarButtons(['sub_save12'], true);
				}else {
					this.setToolbarButtons(['sub_save12'], false);
				}
			}
		},

		setToolbarButtons: function( btnName, state)	 {
			var toolbar = masterGrid12.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
		}
	});



	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region:'north',
		layout: {type : 'uniTable', columns :4},
//			tableAttrs: {width: '100%'}
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
//		},
		padding: '1 1 1 1',
		border: true,
		items: [{
			fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value : UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//20200317 추가
					if(newValue == '02') {
						//fnSetTab1Form(false);
						fnSetTab1Form(true);	/* 임시 히든형태로 변경 */
					} else {
						fnSetTab1Form(true);
					}
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.completiondate" default="완료예정일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'PRODT_END_DATE_FR',
			endFieldName: 'PRODT_END_DATE_TO',
			width: 315,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType:'WU',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();

					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelSearch.getValue('DIV_CODE');
						});
					} else{
						store.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: ' ',
			id: 'rdoSelect1',
			items: [{
				boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
				width: 60,
				name: 'CONTROL_STATUS',
				inputValue: '1'
			},{
				boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
				width: 60,
				name: 'CONTROL_STATUS',
				inputValue: '2',
				checked: true
			},{
				boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
				width: 60,
				name: 'CONTROL_STATUS',
				inputValue: '8'
			},{
				boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
				width: 60,
				name: 'CONTROL_STATUS',
				inputValue: '9'
			}]
		},
		{
			fieldLabel:'바코드',
			name:'WKORD_NUM_INPUT',
			xtype:'uniTextfield',
			listeners: {
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						var newValue = panelSearch.getValue('WKORD_NUM_INPUT').toUpperCase();
						if(!Ext.isEmpty(newValue)) {
							var detailSR = detailGrid.getSelectedRecord();
							
							if(newValue.substring(2,3) == '$'){
								if(detailStore.getCount() == 1 && !Ext.isEmpty(detailSR) && !UniAppManager.app.getTopToolbar().getComponent('save').disabled){
									if(newValue.substring(0,2) == 'S2'){
										panelSearch.setValue('WKORD_NUM',newValue);
										panelSearch.setValue('WKORD_NUM_INPUT','');
										tab1Form.setValue('PRODT_PRSN',newValue.substring(3));
										
										panelSearch.getField('WKORD_NUM_INPUT').focus();
//										panelSearch.getField('WKORD_NUM').selectText();
									}else if(newValue == 'S3$COMPLETE'){
										panelSearch.setValue('WKORD_NUM',newValue);
										panelSearch.setValue('WKORD_NUM_INPUT','');
										UniAppManager.app.onSaveDataButtonDown();
									}
								}
							}else{
								panelSearch.setValue('CONTROL_STATUS','1');
								
								panelSearch.setValue('WKORD_NUM',newValue);
								panelSearch.setValue('WKORD_NUM_INPUT','');
								
								setTimeout( function() {
									detailStore.loadStoreRecords();
									//20200312 포커스 워치 로직 위치 변경
//									panelSearch.getField('WKORD_NUM_INPUT').focus();
//									panelSearch.getField('WKORD_NUM').selectText();
									 
								}, 50 );
							
							}
						}
					
						
					}
				}
						
						
				
			}
		},{
			fieldLabel:'바코드 값',
			name:'WKORD_NUM',
			xtype:'uniTextfield',
			readOnly:true,
			hidden:true,
			listeners: {
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {/*
						var newValue = panelSearch.getValue('WKORD_NUM').toUpperCase();
						if(!Ext.isEmpty(newValue)) {
							var detailSR = detailGrid.getSelectedRecord();
							
							if(newValue.substring(2,3) == '$'){
								if(detailStore.getCount() == 1 && !Ext.isEmpty(detailSR) && !UniAppManager.app.getTopToolbar().getComponent('save').disabled){
									if(newValue.substring(0,2) == 'S2'){
										tab1Form.setValue('PRODT_PRSN',newValue.substring(3));
										
										panelSearch.getField('WKORD_NUM').focus();
										panelSearch.getField('WKORD_NUM').selectText();
									}else if(newValue == 'S3$COMPLETE'){
										UniAppManager.app.onSaveDataButtonDown();
									}
								}
							}else{
								panelSearch.setValue('CONTROL_STATUS','1');
								
								setTimeout( function() {
									detailStore.loadStoreRecords();
									panelSearch.getField('WKORD_NUM').focus();
									panelSearch.getField('WKORD_NUM').selectText();
									 
								}, 50 );
							
							}
						}
					*/}
				}
			}
		},{
			xtype: 'displayfield',
	        fieldLabel: ' ',
	        name: 'MSG_F',
	        value: '',
	        margin:'10 0 0 0',
            fieldStyle: 'color: red;'
        },{
            fieldLabel: 'GS_FR_TIME',
            name:'GS_FR_TIME',
            xtype:'timefield',
            format: 'H:i',
            increment: 10,
            width: 185,
            readOnly: false,
            hidden:true,
            fieldStyle: 'text-align: center;'
		},{
	        fieldLabel: 'GS_TO_TIME',
	        name:'GS_TO_TIME',
	        xtype:'timefield',
	        format: 'H:i',
	        increment: 10,
	        width: 185,
	        readOnly: false,
	        hidden:true,
	        fieldStyle: 'text-align: center;'
		}]
	});



	var detailGrid = Unilite.createGrid('detailGrid', {
		layout: 'fit',
		region:'west',
		split: true,
		flex:2,
		uniOpt: {
//			userToolbar:false,
			expandLastColumn: false,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: false,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			}
		},
		store: detailStore,
		selModel:'rowmodel',
		columns: [
			{dataIndex: 'WORK_SHOP_CODE'	, width: 120},
			{dataIndex: 'WKORD_NUM'			, width: 120},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'LOT_NO'			, width: 80},
			{dataIndex: 'PRODT_END_DATE'	, width: 80},
			{dataIndex: 'PROG_WORK_NAME'	, width: 120, hidden: true},
			{dataIndex: 'PROG_UNIT'			, width: 50, hidden: true},
			{dataIndex: 'PROG_WKORD_Q'		, width: 100, hidden: true},
			{dataIndex: 'SUM_Q'				, width: 88, hidden: true},
			{dataIndex: 'PRODT_DATE'		, width: 86, hidden: true},
			{dataIndex: 'WORK_Q'			, width: 88, hidden: true},
			{dataIndex: 'GOOD_WORK_Q'		, width: 88, hidden: true},
			{dataIndex: 'BAD_WORK_Q'		, width: 88, hidden: true},
			{dataIndex: 'YIELD'				, width: 66	, hidden: true},
			{dataIndex: 'SAVING_Q'			, width: 80	, hidden: true},
			{dataIndex: 'LOSS_Q'			, width: 80	, hidden: true},
			{dataIndex: 'ETC_Q'				, width: 80	, hidden: true},
			{dataIndex: 'BOX_Q'				, width: 80	, hidden: true},
			{dataIndex: 'BOX_TRNS_RATE'		, width: 80	, hidden: true},
			{dataIndex: 'PIECE'				, width: 80	, hidden: true},
			{dataIndex: 'JAN_Q'				, width: 80, hidden: false},
			{dataIndex: 'DAY_NIGHT'			, width: 66, hidden: true},
			{dataIndex: 'MAN_CNT'			, width: 80	, hidden: true},
			{dataIndex: 'FR_TIME'			, width: 93, hidden: true},
			{dataIndex: 'TO_TIME'			, width: 93, hidden: true},
			{dataIndex: 'LUNCH_CHK'                  , width:85, xtype: 'checkcolumn', hidden: true,
				listeners:{
                    checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
                    	if(checked == true){
                    		var grdRecord = directMasterStore3.getAt(rowIndex);
                    		var  diffTime = (grdRecord.get('TO_TIME') -grdRecord.get('FR_TIME')) / 60000  / 60 ;
                    		if((grdRecord.get('TO_TIME') >= panelSearch.getValue('GS_TO_TIME')) && (grdRecord.get('FR_TIME')  <=  panelSearch.getValue('GS_FR_TIME'))){
	                        	  diffTime = diffTime - 1;
	                        	  var manCnt = grdRecord.get('MAN_CNT');
								  grdRecord.set('MAN_HOUR', manCnt * diffTime);
                    		}
                    	}else{
                    		var grdRecord = directMasterStore3.getAt(rowIndex);
	                        var diffTime = (grdRecord.get('TO_TIME') - grdRecord.get('FR_TIME')) / 60000  / 60 ;

							var manCnt = grdRecord.get('MAN_CNT');
							if((grdRecord.get('TO_TIME') >= panelSearch.getValue('GS_TO_TIME')) && (grdRecord.get('FR_TIME')  <=  panelSearch.getValue('GS_FR_TIME'))){
								grdRecord.set('MAN_HOUR', manCnt * diffTime);
							}
                    	}
                    }
                }
			},
			{dataIndex: 'MAN_HOUR'			, width: 90, hidden: true},
//			{dataIndex: 'LOT_NO'			, width: 93},
			{dataIndex: 'FR_SERIAL_NO'		, width: 120, hidden: true},
			{dataIndex: 'TO_SERIAL_NO'		, width: 120, hidden: true},
			{dataIndex: 'EXPIRATION_DATE'	, width: 80	, hidden: true},
			{dataIndex: 'HAZARD_CHECK'		, width: 100, xtype: 'checkcolumn'	, hidden: true},
			{dataIndex: 'MICROBE_CHECK'		, width: 100, xtype: 'checkcolumn'	, hidden: true},
			{dataIndex: 'REMARK'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 10	, hidden: true},
			{dataIndex: 'PROG_WORK_CODE'	, width: 10	, hidden: true},
			{dataIndex: 'PASS_Q'			, width: 10	, hidden: true},
//			{dataIndex: 'WKORD_NUM'			, width: 10	, hidden: true},
			{dataIndex: 'LINE_END_YN'		, width: 10	, hidden: true},
			{dataIndex: 'WK_PLAN_NUM'		, width: 10	, hidden: true},
			{dataIndex: 'PRODT_NUM'			, width: 10	, hidden: true},
			{dataIndex: 'CONTROL_STATUS'	, width: 10	, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width: 10	, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 10	, hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 10	, hidden: true},
			{dataIndex: 'GOOD_WH_CODE'		, width: 80	, hidden: true},
			{dataIndex: 'GOOD_WH_CELL_CODE'	, width: 80, hidden: true},
			{dataIndex: 'GOOD_PRSN'			, width: 80	, hidden: true},
			{dataIndex: 'BAD_WH_CODE'		, width: 80	, hidden: true},
			{dataIndex: 'BAD_WH_CELL_CODE'	, width: 80, hidden: true},
			{dataIndex: 'BAD_PRSN'			, width: 80	, hidden: true},
			{dataIndex: 'EQUIP_CODE'		, width: 80	, hidden: true},
			{dataIndex: 'EQUIP_NAME'		, width: 80	, hidden: true},
			{dataIndex: 'PRODT_PRSN'		, width: 80	},
			//20200317 추가: 완성율
			{dataIndex: 'WORK_PROGRESS'		, width: 80	, hidden: false},
			{dataIndex: 'DUE_DATE'			, width: 80	, hidden: true}
		],
		listeners: {
			beforeselect: function(grid, record, index, eOpts){
				if(detailStore.isDirty()){
					if(confirm('변경된 데이터가 있습니다. 저장하시겠습니까?')) {
						UniAppManager.app.onSaveDataButtonDown();
						return false;
					}else{
						UniAppManager.app.onQueryButtonDown();
						return false;
					}
				}
			},
			
			selectionchangerecord:function(selected)	{
				tabChangeCheck = 'N';
				tab.setActiveTab('tab1');
				
				masterForm.setValue('WORK_SHOP_CODE',selected.data.WORK_SHOP_CODE);
				masterForm.setValue('WKORD_NUM',selected.data.WKORD_NUM);
				masterForm.setValue('ITEM_CODE',selected.data.ITEM_CODE);
				masterForm.setValue('ITEM_NAME',selected.data.ITEM_NAME);
				masterForm.setValue('PROG_WKORD_Q',selected.data.PROG_WKORD_Q);
				masterForm.setValue('PROG_UNIT',selected.data.PROG_UNIT);
				masterForm.setValue('PROG_WORK_CODE',selected.data.PROG_WORK_CODE);

				tab1Form.setActiveRecord(selected || null);
				
				
				
//				if(selected.get('CONTROL_STATUS') != '9' || selected.get('CONTROL_STATUS') != '8'){
//					tab1Form.setValue('WORK_Q',selected.data.JAN_Q,false);
//				}
				
//				tab2Store.loadStoreRecords(selected);
				tab3Store.loadStoreRecords(selected);
				tab4Store.loadStoreRecords(selected);
				progWordComboStore.loadStoreRecords(selected);
				setTimeout( function() {
//					var activeTabId = tab.getActiveTab().getId();
//					if(activeTabId == 'tab4') {
//						if(tab4Store.count() > 0) {
//							UniAppManager.setToolbarButtons(['delete'], true);
//						}else{
//							UniAppManager.setToolbarButtons(['delete'], false);
//						}
//					}else{
					UniAppManager.setToolbarButtons(['delete'], false);
//					}
					tabChangeCheck = 'Y';
					//20200312 추가
setTimeout( function() {
				panelSearch.getField('WKORD_NUM_INPUT').focus();
}, 50 );
				}, 50 );
				
			},
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					UniAppManager.setToolbarButtons(['newData','delete'], false);
				});
			}
			
		}
			
			
			/*
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom == true){
					return true;
				} else {
					if (UniUtils.indexOf(e.field, ['ITEM_ACCOUNT'])) {
						return false;
					} else {
						return true;
					}
				}
			}
		}*/
	});


	var tab2Grid = Unilite.createGrid('tab2Grid', {
		layout : 'fit',
		region:'center',
		width:960,
		border:false,
		store : tab2Store,
		uniOpt:{	
			expandLastColumn: false,
			useRowNumberer: false,
			onLoadSelectFirst: false,
			useMultipleSorting: true
		},
		sortableColumns: false,
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary', 		showSummaryRow: false}
		],
		dockedItems : [{
			xtype	: 'toolbar',
			dock	: 'top',
			items	: [{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.inquiry" default="조회"/>',
				tooltip	: '<t:message code="system.label.base.inquiry" default="조회"/>',
				iconCls	: 'icon-query',
				width	: 26,
				height	: 26,
				itemId	: 'sub_query4',
				handler: function() {
					//if( me._needSave()) {
					var toolbar	= tab2Grid.getDockedItems('toolbar[dock="top"]');
					var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
					var record	= detailGrid.getSelectedRecord();
					if (needSave) {
						Ext.Msg.show({
							title	: '<t:message code="system.label.base.confirm" default="확인"/>',
							msg		: Msg.sMB017 + "\n" + Msg.sMB061,
							buttons	: Ext.Msg.YESNOCANCEL,
							icon	: Ext.Msg.QUESTION,
							fn		: function(res) {
								//console.log(res);
								if (res === 'yes' ) {
									var saveTask =Ext.create('Ext.util.DelayedTask', function(){
										tab2Store.saveStore();
									});
									saveTask.delay(500);
								} else if(res === 'no') {
									tab2Store.loadStoreRecords();
								}
							}
						});
					} else {
						tab2Store.loadStoreRecords();
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.reset" default="신규"/>',
				tooltip	: '<t:message code="system.label.base.reset2" default="초기화"/>',
				iconCls	: 'icon-reset',
				width	: 26,
				height	: 26,
				itemId	: 'sub_reset4',
				handler: function() {
					var toolbar	= tab2Grid.getDockedItems('toolbar[dock="top"]');
					var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
					if(needSave) {
						Ext.Msg.show({
							title:'<t:message code="system.label.base.confirm" default="확인"/>',
							msg: Msg.sMB017 + "\n" + Msg.sMB061,
							buttons: Ext.Msg.YESNOCANCEL,
							icon: Ext.Msg.QUESTION,
							fn: function(res) {
								console.log(res);
								if (res === 'yes' ) {
									var saveTask =Ext.create('Ext.util.DelayedTask', function(){
										tab2Store.saveStore();
									});
									saveTask.delay(500);
								} else if(res === 'no') {
									tab2Grid.reset();
									tab2Store.clearData();
									tab2Store.setToolbarButtons('sub_save4', false);
									tab2Store.setToolbarButtons('sub_delete4', false);
								}
							}
						});
					} else {
							tab2Grid.reset();
							tab2Store.clearData();
							tab2Store.setToolbarButtons('sub_save4', false);
							tab2Store.setToolbarButtons('sub_delete4', false);
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.add" default="추가"/>',
				tooltip	: '<t:message code="system.label.base.add" default="추가"/>',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
				itemId	: 'sub_newData4',
				handler: function() {
					var record = detailGrid.getSelectedRecord();
//					var progWorkRecord = masterGrid3.getSelectedRecord();
					var divCode = record.get('DIV_CODE');
					var prodtDate = UniDate.get('today');
					var workShopCode = record.get('WORK_SHOP_CODE');
					var wkordNum = record.get('WKORD_NUM');
					var itemCode = record.get('ITEM_CODE');
					var progWorkCode = record.get('PROG_WORK_CODE');
					var progWorkName = record.get('PROG_WORK_NAME');
					
					var ctlCd1 = '';
					var troubleTime	= '';
					var trouble	= '';
					var troubleCs = '';
					var answer = '';
					var seq = 0;
					seq = tab2Store.max('SEQ');

					if(Ext.isEmpty(seq)){
						seq = 1;
					}else{
						seq = seq + 1;
					}
					var r = {
						DIV_CODE		: divCode,
						PRODT_DATE		: prodtDate,
						WORK_SHOP_CODE	: workShopCode,
						WKORD_NUM		: wkordNum,
						ITEM_CODE		: itemCode,
						CTL_CD1			: ctlCd1,
						TROUBLE_TIME	: troubleTime,
						TROUBLE			: trouble,
						TROUBLE_CS		: troubleCs,
						ANSWER			: answer,
						PROG_WORK_CODE  : progWorkCode,
						PROG_WORK_NAME  : progWorkName,
						SEQ				: seq
					};
					tab2Grid.createRow(r);
				}
			},{
				xtype		: 'uniBaseButton',
				text		: '<t:message code="system.label.base.delete" default="삭제"/>',
				tooltip		: '<t:message code="system.label.base.delete" default="삭제"/>',
				iconCls		: 'icon-delete',
				disabled	: true,
				width		: 26,
				height		: 26,
				itemId		: 'sub_delete4',
				handler	: function() {
					var selRow = tab2Grid.getSelectedRecord();
					if(!Ext.isEmpty(selRow)) {
						if(selRow.phantom == true) {
							tab2Grid.deleteSelectedRow();
						}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
							tab2Grid.deleteSelectedRow();
						}
					} else {
						Unilite.messageBox(Msg.sMA0256);
						return false;
					}
				}
			},{
				xtype		: 'uniBaseButton',
				text		: '<t:message code="system.label.base.save" default="저장 "/>',
				tooltip		: '<t:message code="system.label.base.save" default="저장 "/>',
				iconCls		: 'icon-save',
				disabled	: true,
				width		: 26,
				height		: 26,
				itemId		: 'sub_save4',
				handler	: function() {
					var selectDetailRecord = detailGrid.getSelectedRecord();
					var param = {
						'DIV_CODE' : selectDetailRecord.get('DIV_CODE'),
						'WKORD_NUM' : selectDetailRecord.get('WKORD_NUM'),
						'PROG_WORK_CODE' : selectDetailRecord.get('PROG_WORK_CODE')
					}
					s_pmr100ukrv_mitService.checkWorkEnd(param, function(provider, response) {
						if(!Ext.isEmpty(provider)){
							if(provider.WORK_END_YN == 'Y'){
								Unilite.messageBox('마감된 작업지시입니다.');
								return false;
							}else{
								tab2Store.saveStore();
							}
						}
					});
				}
			}]
		}],
		columns: [
			{dataIndex: 'WKORD_NUM'			, width: 120 , hidden: true},
			{dataIndex: 'PROG_WORK_CODE'		, width: 100,hidden:true},
			{dataIndex: 'PROG_WORK_NAME'		, width: 100},
			{dataIndex: 'PRODT_DATE'			, width: 100},
			{dataIndex: 'CTL_CD1'			, width: 145},
			{dataIndex: 'FR_TIME'			, width: 70, align:'center'
				,editor: {
					xtype: 'timefield',
					format: 'H:i',
				//	submitFormat: 'Hi', //i tried with and without this config
					increment: 10
			 	}
			},
			{dataIndex: 'TO_TIME'			, width: 70, align:'center'
				,editor: {
					xtype: 'timefield',
					format: 'H:i',
				//	submitFormat: 'Hi', //i tried with and without this config
					increment: 10
			 	}
			},
			{dataIndex: 'TROUBLE_TIME'		, width:70},
			{dataIndex: 'TROUBLE'			, width: 120},
			{dataIndex: 'TROUBLE_CS'			, width: 120},
			{dataIndex: 'ANSWER'				, width: 150},
			{dataIndex: 'SEQ'				, width: 100, hidden:true},
			//Hidden : true
			{dataIndex: 'DIV_CODE'			, width: 0 , hidden:true},
			{dataIndex: 'WORK_SHOP_CODE'		, width: 0 , hidden:true},
			//{dataIndex: 'PROG_WORK_CODE'		, width: 0 , hidden:true},
			{dataIndex: 'UPDATE_DB_USER'		, width: 0 , hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 0 , hidden:true},
			{dataIndex: 'COMP_CODE'			, width: 0 , hidden:true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if (UniUtils.indexOf(e.field,
											['PROG_WORK_CODE','PROG_WORK_NAME','PRODT_DATE','CTL_CD1']))
						return false
				}if(!e.record.phantom||e.record.phantom){
					if (UniUtils.indexOf(e.field,
											['WKORD_NUM','PROG_WORK_CODE','PROG_WORK_NAME']))
						return false
				}
			}
	/*		render: function(grid, eOpts) {
				grid.getEl().on('click', function(e, t, eOpt) {
					UniAppManager.setToolbarButtons(['newData'], true);
					if(grid.getStore().count() > 0) {
						UniAppManager.setToolbarButtons(['delete'], true);
					} else {
						UniAppManager.setToolbarButtons(['delete'], false);
					}
				});
			}*/
		}
	});

	var tab3Grid = Unilite.createGrid('tab3Grid', {
		layout : 'fit',
		region:'center',
		store : tab3Store,
		uniOpt:{	expandLastColumn: false,
					useRowNumberer: true,
					useMultipleSorting: true
		},
		sortableColumns: false,
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary', 		showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'WKORD_NUM'		, width: 120},
			{dataIndex: 'PROG_WORK_CODE'	, width: 80},
			{dataIndex: 'PROG_WORK_NAME'	, width: 150},
			{dataIndex: 'PRODT_DATE'		, width: 100},
			{dataIndex: 'BAD_CODE'		, width: 150},
			{dataIndex: 'BAD_Q'			, width: 100},
			{dataIndex: 'REMARK'			, width: 800},

			{dataIndex: 'DIV_CODE'			, width: 0 , hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 0 , hidden: true},
			//{dataIndex: 'PROG_WORK_CODE' 	, width: 0 , hidden: true},
			{dataIndex: 'ITEM_CODE'		, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER' 	, width: 0 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 0 , hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 0 , hidden: true}
		]
		,
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if (UniUtils.indexOf(e.field,
											['PROG_WORK_CODE','PROG_WORK_NAME','BAD_CODE']))
						return false
				}if(!e.record.phantom||e.record.phantom){
					if (UniUtils.indexOf(e.field,
											['WKORD_NUM']))
						return false
				}
			},
			render: function(grid, eOpts) {
				grid.getEl().on('click', function(e, t, eOpt) {
//					UniAppManager.setToolbarButtons(['newData'], true);
					if(grid.getStore().count() > 0) {
						UniAppManager.setToolbarButtons(['delete'], true);
					} else {
						UniAppManager.setToolbarButtons(['delete'], false);
					}
				});
			}
		}
	});
	/*생산실적 등록 팝업 자재불량그리드*/
	var masterGrid10 = Unilite.createGrid('pmr100ukrvGrid10', {
		store	: directMasterStore10,
		layout	: 'fit',
		region	: 'center',
		border:false,
		uniOpt	:{
			expandLastColumn	: false,
			useLiveSearch		: true,
			//useContextMenu		: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useRowNumberer		: false,
			onLoadSelectFirst: false,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		sortableColumns : false,
		userToolbar :false,
		columns	: columns,
        listeners: {
            beforeedit: function(editor, e){
            	if(UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE' ,'ITEM_CODE' ,'ITEM_NAME', 'SPEC', 'STOCK_UNIT','CUSTOM_CODE','CUSTOM_NAME'])) {
                   return false
                }
            }
        }

	});
	
	
	
	
	var tab4Grid = Unilite.createGrid('tab4Grid', {
		split: true,
		layout : 'fit',
		selModel: 'rowmodel',
		region:'center',
		flex: 5,
		title : '<t:message code="system.label.product.resultsstatus" default="실적현황"/>',
		store : tab4Store,
		uniOpt:{
			userToolbar:false,
			expandLastColumn: false,
			useRowNumberer: true,
			onLoadSelectFirst: false,
			useMultipleSorting: true
		},
		sortableColumns: false,
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary', 		showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'PRODT_NUM'			, width: 100, hidden: true},
			{dataIndex: 'PRODT_DATE'		, width: 90,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
			},
			//20190508 위치 변경 (FR_TIME, TO_TIME)
			{dataIndex: 'FR_TIME'			, width: 70		, align:'center'},
			{dataIndex: 'TO_TIME'			, width: 70		, align:'center'},
			{dataIndex: 'WORK_Q'			, width: 88		, summaryType: 'sum'},
			{dataIndex: 'GOOD_WORK_Q'		, width: 100		, summaryType: 'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'BAD_WORK_Q'		, width: 88		, summaryType: 'sum'},
			{dataIndex: 'YIELD'				, width: 80	, hidden: false},
			{dataIndex: 'SAVING_Q'			, width: 80 	, hidden: false},
			{dataIndex: 'LOSS_Q'				, width: 80	, hidden: false},
			{dataIndex: 'ETC_Q'				, width: 86	, hidden: false},
			{dataIndex: 'BOX_Q'				, width: 80		, hidden: false},
			{dataIndex: 'BOX_TRNS_RATE'		, width: 80		, hidden: false},
			{dataIndex: 'PIECE'				, width: 80	, hidden: false},
			{dataIndex: 'DAY_NIGHT'			, width: 66	, align:'center'	},
			{dataIndex: 'MAN_CNT'			, width: 80		},
			{dataIndex: 'MAN_HOUR'			, width: 76		, summaryType: 'sum'},
			{dataIndex: 'PRODT_PRSN'			, width: 80	, align:'center'	},
			//20190508 위치 변경 (FR_TIME, TO_TIME)
//			{dataIndex: 'FR_TIME'			, width: 100	, align:'center'},
//			{dataIndex: 'TO_TIME'			, width: 100	, align:'center'},
			{dataIndex: 'EQUIP_CODE'			, width: 80	},
			{dataIndex: 'EQUIP_NAME'			, width: 150		},
			{dataIndex: 'IN_STOCK_Q'		, width: 76		, summaryType: 'sum'},
			//20190508 LOT_NO 컬럼 보이도록 수정
			{dataIndex: 'LOT_NO'			, width: 80		, hidden: false},
			{dataIndex: 'FR_SERIAL_NO'		, width: 120	, hidden: true},
			{dataIndex: 'TO_SERIAL_NO'		, width: 120	, hidden: true},
			{dataIndex: 'REMARK'			, width: 80		, hidden: true},

			{dataIndex: 'DIV_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'PROG_WKORD_Q'		, width: 66		, hidden: true},
			{dataIndex: 'PASS_Q'		, width: 66		, hidden: true},
			{dataIndex: 'PROG_WORK_CODE'	, width: 66		, hidden: true},
			{dataIndex: 'WKORD_NUM'			, width: 66		, hidden: true},
			{dataIndex: 'WK_PLAN_NUM'		, width: 80		, hidden: true},
			{dataIndex: 'LINE_END_YN'		, width: 106	, hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 106	, hidden: true},
			{dataIndex: 'GOOD_WH_CODE'		, width: 80		, hidden: true},
			{dataIndex: 'GOOD_PRSN'			, width: 80		, hidden: true},
			{dataIndex: 'BAD_WH_CODE'		, width: 80		, hidden: true},
			{dataIndex: 'BAD_PRSN'			, width: 80		, hidden: true},
			{dataIndex: 'EXPIRATION_DATE'	, width: 80		, hidden: false},

			{dataIndex: 'HAZARD_CHECK'		, width: 100	, xtype: 'checkcolumn'	, hidden: false, disabled: true, disabledCls : '' },
			{dataIndex: 'MICROBE_CHECK'		, width: 100	, xtype: 'checkcolumn'	, hidden: false, disabled: true, disabledCls : ''},
			{
		            text: '출력',
		            width: 120,
		            xtype: 'widgetcolumn',
		            widget: {
		                xtype: 'button',
		                text: '검사의뢰서 출력',
		                listeners: {
		                	buffer:1,
		                	click: function(button, event, eOpts) {
		                        var gsSelRecord = event.record.data;
		                        tab4Grid.printBtn(gsSelRecord);
		                	}
		                }
		            }
		        },
			{
		            text: '라벨',
		            width: 120,
		            xtype: 'widgetcolumn',
		            widget: {
		                xtype: 'button',
		                text: '라벨 출력',
		                listeners: {
		                	buffer:1,
		                	click: function(button, event, eOpts) {
		                        var gsSelRecord = event.record.data;
		                        tab4Grid.printLabelBtn(gsSelRecord);
		                	}
		                }
		            }
		        }
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {},
			render: function(grid, eOpts) {
					grid.getEl().on('click', function(e, t, eOpt) {
						UniAppManager.setToolbarButtons(['newData'], false);
						if(grid.getStore().count() > 0) {
							UniAppManager.setToolbarButtons(['delete'], true);
						}
					});
			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
					gsProdtDate = record.get('PRODT_DATE');
				}
			}
//			onGridDblClick:function(grid, record, cellIndex, colName) {
//				var detailRecord = detailGrid.getSelectedRecord();
//	   				 openResultsUpdateWindow();
//			}
		},
		setOutouProdtSave: function(grdRecord) {
			grdRecord.set('GOOD_WH_CODE'	, outouProdtSaveSearch.getValue('GOOD_WH_CODE'));
			grdRecord.set('GOOD_WH_CELL_CODE'	, outouProdtSaveSearch.getValue('GOOD_WH_CELL_CODE'));
			grdRecord.set('GOOD_PRSN'		, outouProdtSaveSearch.getValue('GOOD_PRSN'));
			grdRecord.set('BAD_WH_CODE'		, outouProdtSaveSearch.getValue('BAD_WH_CODE'));
			grdRecord.set('BAD_WH_CELL_CODE'	, outouProdtSaveSearch.getValue('BAD_WH_CELL_CODE'));
			grdRecord.set('BAD_PRSN'		, outouProdtSaveSearch.getValue('BAD_PRSN'));
		},
        printBtn:function(gsSelRecord){

      		var selectedDetailRecords = detailGrid.getSelectedRecords();
/*               if(Ext.isEmpty(selectedRecords)){
                  alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
                  return;
              } */
              var param = panelResult.getValues();
            	   param["PRODT_NUM"]= gsSelRecord.PRODT_NUM;

              Ext.each(selectedDetailRecords, function(record, idx) {
            	  param["WKORD_NUM"]=  record.get('WKORD_NUM');
            	  param["STD_ITEM_ACCOUNT"]=  record.get('STD_ITEM_ACCOUNT');
            	  param["ITEM_LEVEL1"]=  record.get('ITEM_LEVEL1');
            	  param["ITEM_CODE"]=  record.get('ITEM_CODE');
	            });


              param["sTxtValue2_fileTitle"]='검사성적서';
              param["RPT_ID"]='pmr100clrkrv';
              param["PGM_ID"]='pmr100ukrv';
              param["MAIN_CODE"]='P010';

              var win  = Ext.create('widget.ClipReport', {
 		                url: CPATH+'/prodt/pmr100clrkrv.do',
 		                prgID: 'pmr100ukrv',
 		                extParam: param
 		            });
 					win.center();
 					win.show();
     	},
        printLabelBtn:function(gsSelRecord){

      		var selectedDetailRecords = detailGrid.getSelectedRecords();
/*               if(Ext.isEmpty(selectedRecords)){
                  alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
                  return;
              } */
              var param = panelResult.getValues();
            	   param["PRODT_NUM"]= gsSelRecord.PRODT_NUM;

              Ext.each(selectedDetailRecords, function(record, idx) {
            	  param["WKORD_NUM"]=  record.get('WKORD_NUM');
            	  param["STD_ITEM_ACCOUNT"]=  record.get('STD_ITEM_ACCOUNT');
            	  param["ITEM_LEVEL1"]=  record.get('ITEM_LEVEL1');
            	  param["ITEM_CODE"]=  record.get('ITEM_CODE');
	            });


              param["sTxtValue2_fileTitle"]='라벨 출력';
              param["RPT_ID"]='pmr100clrkrv_3';
              param["PGM_ID"]='pmr100ukrv';
              param["MAIN_CODE"]='P010';

              var win  = Ext.create('widget.ClipReport', {
 		                url: CPATH+'/prodt/pmr100clrkrv_label.do',
 		                prgID: 'pmr100ukrv',
 		                extParam: param
 		            });
 					win.center();
 					win.show();
     	}
	});
	
	
	var masterForm = Unilite.createForm('masterForm', {
    	disabled :false,
    	border:true,
//	    split: true,
    	region:'north',
	    padding: '1 1 1 1',
        layout : {type : 'uniTable', columns : 2},
        defaults: {readOnly:true},
        title:'작업지시정보',
		items: [
//						{
//			layout: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
//			defaultType: 'uniFieldset',
//			defaults: { padding: '10 15 15 15'},
//			items: [
			/*				{
				xtype: 'uniFieldset',
				title: '<t:message code="system.label.product.workorderinfo" default="작업지시정보"/>',
				layout: { type: 'uniTable', columns: 1},
//				defaults: {readOnly:true},
//				margin: '10 0 15 15',
//				width:1010,
				padding: '10 15 15 15',
				items: [*/
				{
					fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
					xtype: 'uniTextfield',
					name: 'WKORD_NUM',
					width: 300,
					fieldStyle: 'text-align: center;'
				},{	
					itemId: 'linkBtn',
					xtype:'button',
					text: '<t:message code="system.label.product.allocationqtyadjust" default="예약량조정"/>',
					width:150,
					margin:'0 0 0 50',
					handler: function() {
						
						var selectDetailRecord = detailGrid.getSelectedRecord();
						if(Ext.isEmpty(selectDetailRecord)){
							alert('<t:message code="system.message.product.datacheck002" default="선택된 자료가 없습니다."/>');
							return false;
						}else{
							var params = {
								'DIV_CODE'			: selectDetailRecord.get('DIV_CODE'),
								'WORK_SHOP_CODE'	: selectDetailRecord.get('WORK_SHOP_CODE'),
								'WKORD_NUM'			: selectDetailRecord.get('WKORD_NUM')
							}
							var rec = {data : {prgID : 'pmp160ukrv', 'text':'<t:message code="system.label.product.allocationqtyadjust" default="예약량조정"/>'}};
							parent.openTab(rec, '/prodt/pmp160ukrv.do', params);
						}
					}
				},{
	                fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
	                name:'ITEM_CODE',
	                xtype: 'uniTextfield',
	                width: 300,
	                fieldStyle: 'text-align: center;',
	                colspan:2

	            },{
	                fieldLabel: '<t:message code="system.label.product.itemname2" default="품명"/>',
	                name:'ITEM_NAME',
	                width: 600,
	                xtype: 'uniTextfield',
	                colspan:2
	            },{
					xtype: 'container',
					layout:{type:'uniTable',columns:2},
					defaults: {readOnly:true},
					colspan:2,
					items:[{
		                fieldLabel: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
		                name:'PROG_WKORD_Q',
		                xtype: 'uniNumberfield'
//		                type:'uniQty'

		            },{
		                fieldLabel: '<t:message code="system.label.product.unit" default="단위"/>',
		                name:'PROG_UNIT',
		                xtype: 'uniTextfield',
		                width: 150,
		                fieldStyle: 'text-align: center;'
		            }]
	            },
	            {
	            	xtype:'uniTextfield',
	            	name :'PROG_WORK_CODE',
	            	hidden:true
	            }
	            
	            ]
//			}]
//		}]
	});

	
	var tab1Form = Unilite.createForm('tab1Form', {
		masterGrid	: detailGrid,
    	disabled :false,
//    	border:true,
//	    split: true,
    	region:'north',
	    padding: '1 1 1 1',
        layout: {type : 'uniTable', columns : 4},
		items: [{
			fieldLabel: '<t:message code="system.label.product.routingname" default="공정명"/>',
			name:'PROG_WORK_NAME',
			xtype: 'uniTextfield',
			readOnly: true,
			colspan:4
		},{
            fieldLabel: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
            name:'PROG_WKORD_Q',
            xtype: 'uniNumberfield',
	        decimalPrecision: 1,				//20200326 소숫점 1자리까지 입력 되도록 수정
//            type:'uniQty',
            readOnly: true
        },{
            fieldLabel: '<t:message code="system.label.product.unit" default="단위"/>',
            name:'PROG_UNIT',
            xtype: 'uniTextfield',
            width: 150,
            readOnly: true,
            fieldStyle: 'text-align: center;',
			colspan:3
		},{
          	fieldLabel: '<t:message code="system.label.product.productionleftqty" default="생산잔량"/>',
            name:'JAN_Q',
            xtype: 'uniNumberfield',
	        decimalPrecision: 1,				//20200326 소숫점 1자리까지 입력 되도록 수정
//            type:'uniQty',
            readOnly: true

        },{
          	fieldLabel: '<t:message code="system.label.product.productiontotal" default="생산누계"/>',
            name:'SUM_Q',
            xtype: 'uniNumberfield',
	        decimalPrecision: 1,				//20200326 소숫점 1자리까지 입력 되도록 수정
//            type:'uniQty',
            readOnly: true
        },{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			colspan: 2,
			items:[{
				fieldLabel: '벌크품목',
				xtype: 'uniTextfield',
	            name: 'REF_ITEM_CODE',
				width: 200,
				listeners: {
					render: function(component) {
                        component.getEl().on('dblclick', function( event, el ) {
                             openRefItemWindow();
                        });
                    }
				}
			},{
				fieldLabel: '',
				xtype: 'uniTextfield',
	            name: 'REF_ITEM_NAME',
	            width: 150,
				listeners: {
					render: function(component) {
                        component.getEl().on('dblclick', function( event, el ) {
                             openRefItemWindow();
                        });
                    }
				}
			}]
		},{
      		fieldLabel: '<t:message code="system.label.product.productiondate" default="생산일"/>',
			xtype: 'uniDatefield',
			name: 'PRODT_DATE',
			value:UniDate.get('today'),
			fieldStyle: 'text-align: center;background-color: yellow; background-image: none;',
			readOnly : false,
			allowBlank:false
		},{
			fieldLabel: 'LOT_NO',
			xtype: 'uniTextfield',
			name: 'LOT_NO',
			readOnly : false,
			fieldStyle: 'text-align: center;'
		},{
          	fieldLabel: '<t:message code="system.label.product.expirationdate" default="유통기한"/>',
			xtype: 'uniDatefield',
			name: 'EXPIRATION_DATE',
			value:UniDate.get('today'),
			readOnly : false,
			allowBlank:true,
			colspan:2
			
   		 },{
			fieldLabel: '<t:message code="system.label.product.productionqty" default="생산량"/>',
            name:'WORK_Q',
            xtype: 'uniNumberfield',
            decimalPrecision: 1,				//20200326 소숫점 1자리까지 입력 되도록 수정
            fieldStyle: 'background-color: yellow; background-image: none;',
            readOnly: false,
            allowBlank:true,
            listeners: {
          		change: function(field, newValue, oldValue, eOpts) {
					if(newValue < 0){
						Unilite.messageBox('생산량에는 양수만 가능합니다.');
						tab1Form.setValue('WORK_Q', oldValue);
						return false;
					}
					calPassQMethod = 'A';
					resultFormQtyClear('WORK_Q');//생산량 입력시 전체 수량 클리어
					fn_resultQtyCalc(calPassQMethod, 'WORK_Q', newValue);
				}
			}
		},{
	        fieldLabel: '관리수량',
	        name:'SAVING_Q',
	        xtype: 'uniNumberfield',
	        decimalPrecision: 1,				//20200326 소숫점 1자리까지 입력 되도록 수정
	        readOnly: false,
	        listeners: {
		      	change: function(field, newValue, oldValue, eOpts) {
					if(newValue < 0){
						return false;
					}
					fn_resultQtyCalc(calPassQMethod, 'SAVING_Q', newValue);
				}
			}
		},{ 	
			fieldLabel: '수율',
		    name:'YIELD',
		    xtype: 'uniNumberfield',
		    decimalPrecision: 2,
		    suffixTpl:'&nbsp;%',
		    readOnly: false,
			colspan:2,
		    listeners: {
	      		change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{    
			fieldLabel: '<t:message code="system.label.product.gooditemqty" default="양품량"/>',
            name:'GOOD_WORK_Q',
            id:'goodWorkQ',
            xtype: 'uniNumberfield',
            decimalPrecision: 1,				//20200326 소숫점 1자리까지 입력 되도록 수정
            listeners: {
              	change: function(field, newValue, oldValue, eOpts) {
              		if(newValue < 0){
						Unilite.messageBox('양품량에는 양수만 가능합니다.');
						tab1Form.setValue('GOOD_WORK_Q', oldValue);
						return false;
					}
					calPassQMethod = 'B';
//					resultFormQtyClear('GOOD_WORK_Q');//양품량 입력시 전체 수량 클리어
					fn_resultQtyCalc(calPassQMethod, 'GOOD_WORK_Q', newValue);
				}
			}
  		},{
            fieldLabel: '<t:message code="system.label.product.defectqty" default="불량수량"/>',
            name:'BAD_WORK_Q',
            xtype: 'uniNumberfield',
            decimalPrecision: 1,				//20200326 소숫점 1자리까지 입력 되도록 수정
            readOnly: false,
            listeners: {
	        	change: function(field, newValue, oldValue, eOpts) {
					if(newValue < 0){
						return false;
					}else if(newValue > tab1Form.getValue('JAN_Q')){
						Unilite.messageBox('불량수량이 생산잔량을 초과할 수 없습니다.');
						tab1Form.setValue('BAD_WORK_Q',0,false);
						return false;
					}
					calPassQMethod = 'D';
					fn_resultQtyCalc(calPassQMethod, 'BAD_WORK_Q', newValue);
//					tab1Form.setValue('GOOD_WORK_Q',tab1Form.getValue('JAN_Q') - newValue);
				}
			}
		},{ 	
			fieldLabel: 'LOSS량',
            name:'LOSS_Q',
            xtype: 'uniNumberfield',
            decimalPrecision: 1,				//20200326 소숫점 1자리까지 입력 되도록 수정
            readOnly: false,
            listeners: {
              	change: function(field, newValue, oldValue, eOpts) {
              		fn_resultQtyCalc(calPassQMethod, 'LOSS_Q', newValue);
				}
			}
		},{ 	
			fieldLabel: '<t:message code="system.label.product.etcqty" default="기타수량"/>',
            name:'ETC_Q',
            xtype: 'uniNumberfield',
            decimalPrecision: 1,				//20200326 소숫점 1자리까지 입력 되도록 수정
            readOnly: false,
            listeners: {
              	change: function(field, newValue, oldValue, eOpts) {
              		fn_resultQtyCalc(calPassQMethod, 'ETC_Q', newValue);
				}
			}
		},{ 
			fieldLabel: '박스수량',
            name:'BOX_Q',
            xtype: 'uniNumberfield',
            decimalPrecision: 0,
            readOnly: false ,
            hidden:true,
            listeners: {
              	change: function(field, newValue, oldValue, eOpts) {/*
              		if(newValue < 0){
						tab1Form.setValue('BOX_Q',oldValue );
						return false;
					}
              	   	calPassQMethod = 'C';
					resultFormQtyClear('BOX_Q');//박스수량 입력시 전체 수량 클리어
					fn_resultQtyCalc(calPassQMethod, 'BOX_Q', newValue);
				*/}
			}
		},{ 	
			fieldLabel: '박스입수',
            name:'BOX_TRNS_RATE',
            xtype: 'uniNumberfield',
            decimalPrecision: 0,
            readOnly: false,
            hidden:true,
            listeners: {
              	change: function(field, newValue, oldValue, eOpts) {/*
					if(newValue < 0){
						tab1Form.setValue('BOX_TRNS_RATE',oldValue );
						return false;
					}
					calPassQMethod = 'C';
					fn_resultQtyCalc(calPassQMethod,'BOX_TRNS_RATE',newValue)
				*/}
			}
		},{    
			fieldLabel: '낱개',
            name:'PIECE',
            xtype: 'uniNumberfield',
            decimalPrecision: 0,
            readOnly: false,
            hidden:true,
			colspan:2,
            listeners: {
              	change: function(field, newValue, oldValue, eOpts) {/*
              		if(newValue < 0){
						tab1Form.setValue('PIECE',oldValue );
						return false;
					}
              		calPassQMethod = 'C';
              		fn_resultQtyCalc(calPassQMethod,'PIECE',newValue)
				*/}
			}
		},{  
			fieldLabel: '작업인원',
			name:'MAN_CNT',
			xtype: 'uniNumberfield',
			suffixTpl:'&nbsp;명',
			decimalPrecision: 1,
			readOnly: false,
			listeners: {
			/*	change: function(field, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(UniDate.getHHMI(tab1Form.getValue('FR_TIME')))
						&& !Ext.isEmpty(UniDate.getHHMI(tab1Form.getValue('TO_TIME')))){

						 var diffTime = (tab1Form.getValue('TO_TIME') - tab1Form.getValue('FR_TIME')) / 60000  / 60 ;
						 var manCnt = newValue;
						 if(Ext.isEmpty(diffTime) || diffTime == 0){
							 tab1Form.setValue('MAN_HOUR', 0);
						 }else{
								if(tab1Form.getValue('LUNCH_CHK') == true){
									if(tab1Form.getValue('TO_TIME') >= panelSearch.getValue('GS_TO_TIME')){
										diffTime = diffTime - 1
									}
								}
							 tab1Form.setValue('MAN_HOUR', manCnt * diffTime);
						 }

					 }
				},
				*/
				
	  			blur: function(field, event, eOpts ){
					if(!Ext.isEmpty(UniDate.getHHMI(tab1Form.getValue('FR_TIME')))
						&& !Ext.isEmpty(UniDate.getHHMI(tab1Form.getValue('TO_TIME')))){

						 var diffTime = (tab1Form.getValue('TO_TIME') - tab1Form.getValue('FR_TIME')) / 60000  / 60 ;
						 var manCnt = field.lastValue;
						 if(Ext.isEmpty(diffTime) || diffTime == 0){
							 tab1Form.setValue('MAN_HOUR', 0);
						 }else{
								if(tab1Form.getValue('LUNCH_CHK') == true){
									if(tab1Form.getValue('TO_TIME') >= panelSearch.getValue('GS_TO_TIME')){
										diffTime = diffTime - 1
									}
								}
							 tab1Form.setValue('MAN_HOUR', manCnt * diffTime);
						 }
						 
						field.originalValue = field.lastValue;
					 }
				}
			}
		},{ 
			xtype: 'container',
			layout:{type:'uniTable',columns:4},
			colspan: 3,
			items:[{
	            fieldLabel: '<t:message code="system.label.product.workhour" default="작업시간"/>',
	            name:'FR_TIME',
	            xtype:'timefield',
	            format: 'H:i',
	            increment: 10,
	            width: 166,
	            readOnly: false,
	            fieldStyle: 'text-align: center;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					blur: function(field, event, eOpts ) {
						if(!Ext.isEmpty(UniDate.getHHMI(tab1Form.getValue('TO_TIME')))){
							if(UniDate.getHHMI(field.lastValue) > UniDate.getHHMI(tab1Form.getValue('TO_TIME'))){
								Unilite.messageBox('작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.');
								tab1Form.setValue('FR_TIME', field.originalValue);
								return false;
							}
							 var diffTime = (tab1Form.getValue('TO_TIME') - field.lastValue) / 60000  / 60 ;
							 var manCnt = tab1Form.getValue('MAN_CNT');
							 if(Ext.isEmpty(diffTime)|| diffTime == 0){
								 tab1Form.setValue('MAN_HOUR', 0);
							 }else{
								 if(tab1Form.getValue('LUNCH_CHK') == true){
									 if((tab1Form.getValue('TO_TIME') >= panelSearch.getValue('GS_TO_TIME')) && (field.lastValue  <=  panelSearch.getValue('GS_FR_TIME'))){
									 	diffTime = diffTime - 1
									 }
								 }
								 tab1Form.setValue('MAN_HOUR', manCnt * diffTime);
							 }
							 field.originalValue = field.lastValue;
						}
					}
				}
			},{
				xtype:'component',
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
                fieldLabel: '',
                name:'TO_TIME',
                xtype:'timefield',
                format: 'H:i',
                increment: 10,
                width: 70,
                readOnly: false,
                fieldStyle: 'text-align: center;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

					},blur: function(field, event, eOpts ) {
						if(!Ext.isEmpty(UniDate.getHHMI(tab1Form.getValue('FR_TIME')))){
							if(UniDate.getHHMI(tab1Form.getValue('FR_TIME')) > UniDate.getHHMI(field.lastValue)){
								Unilite.messageBox('작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.');
								tab1Form.setValue('TO_TIME', field.originalValue);
								return false;
							}
						/* 	if(Ext.isEmpty(tab1Form.getValue('MAN_CNT')) || tab1Form.getValue('MAN_CNT') == 0){
								alert('작업인원을 입력해주세요.');
								tab1Form.setValue('TO_TIME', UniDate.getHHMI(field.originalValue));
								tab1Form.getField('MAN_CNT').focus();
								return false;
							} */
							var diffTime = (field.lastValue - tab1Form.getValue('FR_TIME')) / 60000  / 60 ;
							var manCnt = tab1Form.getValue('MAN_CNT');
							if(Ext.isEmpty(diffTime)|| diffTime == 0){
								 tab1Form.setValue('MAN_HOUR', 0);
							 }else{
								 if(tab1Form.getValue('LUNCH_CHK') == true){
									if((field.lastValue >= panelSearch.getValue('GS_TO_TIME')) &&  (tab1Form.getValue('FR_TIME') <=  panelSearch.getValue('GS_FR_TIME'))){
										 diffTime = diffTime - 1;
									}
								  }
								 tab1Form.setValue('MAN_HOUR', manCnt * diffTime);
							 }
							field.originalValue = field.lastValue;
						}
					}
				}
	  		},{
		  		xtype: 'uniCheckboxgroup',
		  		fieldLabel: '점심시간 제외',
		  		labelWidth: 100,
		  		id: 'LUNCH_CHK1',
		  		items: [{
		  			boxLabel: '',
		  			width: 100,
		  			name: 'LUNCH_CHK',
		  			checked:true,
		  			inputValue: 'Y'
		  	/*		listeners: {
		  				blur: function(field, event, eOpts ){
		  				if(field.lastValue == 'Y'){
							var diffTime = (tab1Form.getValue('TO_TIME') - tab1Form.getValue('FR_TIME')) / 60000  / 60 ;
							if((tab1Form.getValue('TO_TIME') >= panelSearch.getValue('GS_TO_TIME')) && (tab1Form.getValue('FR_TIME') <=  panelSearch.getValue('GS_FR_TIME'))){
									  diffTime = diffTime - 1;
							}
							var manCnt = tab1Form.getValue('MAN_CNT');
							if(Ext.isEmpty(diffTime)|| diffTime == 0){
								 tab1Form.setValue('MAN_HOUR', 0);
							 }else{
								 tab1Form.setValue('MAN_HOUR', manCnt * diffTime);
							 }
						}else{
							var diffTime = (tab1Form.getValue('TO_TIME') - tab1Form.getValue('FR_TIME')) / 60000  / 60 ;
							var manCnt = tab1Form.getValue('MAN_CNT');
							if(Ext.isEmpty(diffTime)|| diffTime == 0){
								 tab1Form.setValue('MAN_HOUR', 0);
							 }else{
								 tab1Form.setValue('MAN_HOUR', manCnt * diffTime);
							 }
						}
						field.originalValue = field.lastValue;
		  			}
		  			}*/
		  		}],
		  		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(tabChangeCheck != 'N'){
							if(newValue.LUNCH_CHK == 'Y'){
								var diffTime = (tab1Form.getValue('TO_TIME') - tab1Form.getValue('FR_TIME')) / 60000  / 60 ;
								if((tab1Form.getValue('TO_TIME') >= panelSearch.getValue('GS_TO_TIME')) && (tab1Form.getValue('FR_TIME') <=  panelSearch.getValue('GS_FR_TIME'))){
										  diffTime = diffTime - 1;
								}
								var manCnt = tab1Form.getValue('MAN_CNT');
								if(Ext.isEmpty(diffTime)|| diffTime == 0){
									 tab1Form.setValue('MAN_HOUR', 0);
								 }else{
									 tab1Form.setValue('MAN_HOUR', manCnt * diffTime);
								 }
							}else{
								var diffTime = (tab1Form.getValue('TO_TIME') - tab1Form.getValue('FR_TIME')) / 60000  / 60 ;
								var manCnt = tab1Form.getValue('MAN_CNT');
								if(Ext.isEmpty(diffTime)|| diffTime == 0){
									 tab1Form.setValue('MAN_HOUR', 0);
								 }else{
									 tab1Form.setValue('MAN_HOUR', manCnt * diffTime);
								 }
							}
						}
					}
		  			/*blur: function(field, event, eOpts ){
		  				if(field.lastValue == 'Y'){
							var diffTime = (tab1Form.getValue('TO_TIME') - tab1Form.getValue('FR_TIME')) / 60000  / 60 ;
							if((tab1Form.getValue('TO_TIME') >= panelSearch.getValue('GS_TO_TIME')) && (tab1Form.getValue('FR_TIME') <=  panelSearch.getValue('GS_FR_TIME'))){
									  diffTime = diffTime - 1;
							}
							var manCnt = tab1Form.getValue('MAN_CNT');
							if(Ext.isEmpty(diffTime)|| diffTime == 0){
								 tab1Form.setValue('MAN_HOUR', 0);
							 }else{
								 tab1Form.setValue('MAN_HOUR', manCnt * diffTime);
							 }
						}else{
							var diffTime = (tab1Form.getValue('TO_TIME') - tab1Form.getValue('FR_TIME')) / 60000  / 60 ;
							var manCnt = tab1Form.getValue('MAN_CNT');
							if(Ext.isEmpty(diffTime)|| diffTime == 0){
								 tab1Form.setValue('MAN_HOUR', 0);
							 }else{
								 tab1Form.setValue('MAN_HOUR', manCnt * diffTime);
							 }
						}
						field.originalValue = field.lastValue;
		  			}
		  			*/
		      	}
      		}]
		},{  
			fieldLabel: '<t:message code="system.label.product.inputtime" default="투입공수"/>',
			name:'MAN_HOUR',
			xtype: 'uniNumberfield',
			suffixTpl:'&nbsp;M/H',
			decimalPrecision: 1,
			readOnly: false
		},{
			fieldLabel: '<t:message code="system.label.product.workteam" default="작업조"/>',
			name: 'DAY_NIGHT',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'P507',
			colspan: 3,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.worker" default="작업자"/>',
			name: 'PRODT_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'P505',
			colspan:4,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
	    },
		Unilite.popup('EQU_MACH_CODE',{
			fieldLabel: '<t:message code="system.label.product.facilities" default="설비"/>',
			valueFieldName: 'EQUIP_CODE',
			textFieldName: 'EQUIP_NAME',
			valueFieldWidth:100,
			textFieldWidth:170,
			colspan:3,
			//20200318 hidden
			hidden:true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						tab1Form.setValue('EQUIP_CODE',records[0]['EQU_MACH_CODE']);
						tab1Form.setValue('EQUIP_NAME',records[0]['EQU_MACH_NAME']);
					},
					scope: this
				},
				onClear: function(type) {

					tab1Form.setValue('EQUIP_CODE','');
					tab1Form.setValue('EQUIP_NAME','');

				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		{ 
			xtype: 'container',
			layout:{type:'uniTable',columns:3},
			colspan:4,
			items:[{
                fieldLabel: '<t:message code="system.label.product.serialno" default="시리얼번호"/>',
                name:'FR_SERIAL_NO',
                xtype: 'uniTextfield',
                width: 230,
                readOnly: false,
                hidden:true
      		},{
				xtype:'component',
				html:'~',
				hidden:true,
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
                fieldLabel: '',
                name:'TO_SERIAL_NO',
                width: 150,
                xtype: 'uniTextfield',
                hidden:true,
                readOnly: false
      		}]
		},{
	  		xtype: 'uniCheckboxgroup',
	  		fieldLabel: '유해물질검사요청',
	  		labelWidth: 100,
	  		hidden:true,
	  		items: [{
	  			boxLabel: '',
	  			width: 100,
	  			name: 'HAZARD_CHECK',
	  			checked:true,
	  			inputValue: 'Y'
	  		}],
	  		listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				}
	      	}
  		},{
  	  		xtype: 'uniCheckboxgroup',
  	  		fieldLabel: '미생물검사요청',
  	  		labelWidth: 100,
			colspan:3,
			hidden:true,
  	  		items: [{
  	  			boxLabel: '',
  	  			width: 100,
  	  			name: 'MICROBE_CHECK',
  	  			checked:true,
  	  			inputValue: 'Y'
  	  		}],
  	  		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
  	      	}
        },{
            fieldLabel: '<t:message code="system.label.product.remarks" default="비고"/>',
            name:'REMARK',
            xtype: 'textareafield',
            width: 490,
            height: 117,
			colspan:2
  		},{
			xtype	: 'container',
			colspan	: 2,
			items	: [{
				title	: '진척율 정보',
				xtype	: 'uniFieldset',
				itemId	: 'FIELD_SET',
				defaults: {type: 'uniTextfield', enforceMaxLength: true},
				layout	: {type: 'uniTable', columns: 2},
				margin	: '0 0 0 15',
				height	: 110,
				items	: [{
					xtype	: 'container',
					layout	: {type: 'uniTable', columns: 2},
					colspan	: 2,
					items	: [{
						fieldLabel	: '완성율',
						xtype		: 'uniNumberfield',
						suffixTpl	: '%',
						name		: 'WORK_PROGRESS',
						listeners	: {
							specialkey: function(elm, e){
								if (e.getKey() == e.ENTER) {
									tab1Form.getField('DUE_DATE').focus();
								}
							}
						}
					},{
						fieldLabel	: '완성일',
						xtype		: 'uniDatefield',
						name		: 'DUE_DATE',
						value		: UniDate.get('today')
					},{
						fieldLabel	: '<t:message code="system.label.product.inputtime" default="투입공수"/>',
						name		: 'MAN_HOUR_150',
						xtype		: 'uniNumberfield',
						suffixTpl	: '&nbsp;M/H',
						colspan		: 2,
						decimalPrecision: 2
					},{
						xtype	: 'button',
						text	: '진척율 저장',
						itemId	: 'SAVE_WORK_PROGRESS',
						margin	: '5 0 0 135',
						width	: 100,
						handler	: function() {
							var selectDetailRecord = detailGrid.getSelectedRecord();
							if(!selectDetailRecord) {
								Unilite.messageBox('선택된 데이터가 없습니다.');
								return false;
							}
							tab.mask();
							var param = {
								DIV_CODE		: '02',
								WORK_SHOP_CODE	: selectDetailRecord.get('WORK_SHOP_CODE'),
								WKORD_NUM		: selectDetailRecord.get('WKORD_NUM'),
								DUE_DATE		: UniDate.getDbDateStr(tab1Form.getValue('DUE_DATE')),
								WORK_PROGRESS	: tab1Form.getValue('WORK_PROGRESS'),
								MAN_HOUR		: tab1Form.getValue('MAN_HOUR_150')
							}
							s_pmr100ukrv_mitService.updatePmp150(param, function(provider, response) {
								UniAppManager.updateStatus('<t:message code="system.message.sales.message033" default="저장되었습니다."/>');
								tab.unmask();
							});
						}
					},{
						xtype	: 'button',
						text	: '진척이력',
						itemId	: 'HISTORY_WORK_PROGRESS',
						margin	: '5 0 0 25',
						width	: 100,
						handler	: function() {
							var detailRecord = detailGrid.getSelectedRecord();
							if(!detailRecord) {
								Unilite.messageBox('선택된 데이터가 없습니다.');
								return false;
							}
							openworkProgressWindow();
						}
					}]
				}]
			}]
		}]
	});
	
	
	
	
	var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab: 0,
	    region: 'center',
	    items: [{
	    	title: '생산실적등록',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[tab1Form],
	    	id: 'tab1'
	    },/*{
	    	title: '특기사항등록',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
		    items : [tab2Grid],
	        id:'tab2',
	        hidden:true
	    },*//*{
	    	title: '자재불량내역',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[masterGrid10],
	    	id: 'tab3' 
	    },*/{
	    	title: '생산불량내역',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[tab3Grid],
	    	id: 'tab3' 
	    },{
	    	title: '생산현황',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[tab4Grid],
	    	id: 'tab4' 
	    }],
		listeners : {
			beforetabchange : function ( tabPanel, newCard, oldCard, eOpts )  {
				
				if(tabChangeCheck == 'Y'){
					if(!panelSearch.getInvalidMessage()) return false;   // 필수체크
					var selectRecord = detailGrid.getSelectedRecord();
					if(Ext.isEmpty(selectRecord))   {
					   Unilite.messageBox('작업지시정보를 선택해 주십시오.');
					   return false;
					}
//					if(UniAppManager.app._needSave())   {
//					   alert('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
//					   return false;
//					}
				}
				
			},
			tabChange : function ( tabPanel, newCard, oldCard, eOpts )  {
				tabChangeCheck = 'Y';
				var newTabId = newCard.getId();
				UniAppManager.setToolbarButtons('save', false);
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 'tab1') {
					
					if(detailStore.isDirty()){
						UniAppManager.setToolbarButtons('save', true);
					}
					UniAppManager.setToolbarButtons(['newData','delete'], false);
				}else if(activeTabId == 'tab3') {
//					UniAppManager.setToolbarButtons(['newData'], true);
					if(tab3Store.count() > 0) {
						UniAppManager.setToolbarButtons(['delete'], true);
					}else{
						UniAppManager.setToolbarButtons(['delete'], false);
					}
					
					if(tab3Store.isDirty()){
						UniAppManager.setToolbarButtons('save', true);
					}
				}else if(activeTabId == 'tab4') {
					UniAppManager.setToolbarButtons(['newData'], false);
					if(tab4Store.count() > 0) {
						UniAppManager.setToolbarButtons(['delete'], true);
					}else{
						UniAppManager.setToolbarButtons(['delete'], false);
					}
					
					if(tab4Store.isDirty()){
						UniAppManager.setToolbarButtons('save', true);
					}
				}else{
					UniAppManager.setToolbarButtons(['newData','delete'], false);
				}
//				UniAppManager.app.onQueryButtonDown();
			}
	    }
	});
	/*
	var outouProdtSaveSearch = Unilite.createSearchForm('outouProdtSaveForm', {		// 생산실적 자동입고
		layout: {type : 'uniTable', columns : 2},
		items:[
			{
				xtype: 'container',
				html: '※ <t:message code="system.label.product.goodreceipt" default="양품입고"/>',
				colspan: 2,
				style: {
					color: 'blue'
				}
			},{
				fieldLabel: '<t:message code="system.label.product.goodreceiptwarehouse" default="양품입고창고"/>',
				name:'GOOD_WH_CODE',
				allowBlank: false,
				xtype: 'uniCombobox',
				comboType   : 'OU',
				child: 'GOOD_WH_CELL_CODE',
				colspan: 1,
				listeners: {
					beforequery:function( queryPlan, eOpts )   {
                    	var store = queryPlan.combo.store;
                    	store.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                        	store.filterBy(function(record){
                            	return record.get('option') == panelSearch.getValue('DIV_CODE');
                            })
                        }else{
                        	store.filterBy(function(record){
                            	return false;
							})
                        }
                    },
					change: function(combo, newValue, oldValue, eOpts) {
						outouProdtSaveSearch.setValue('BAD_WH_CODE',newValue);
					}
				}
			},{
                fieldLabel: '<t:message code="system.label.product.goodwarehousecell" default="양품창고cell"/>',
                name: 'GOOD_WH_CELL_CODE',
                xtype:'uniCombobox',
                disabled:sumTypeChk,
                store: Ext.data.StoreManager.lookup('whCellList'),
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {

                    }
                }
            },{
				fieldLabel: '<t:message code="system.label.product.receiptcharger" default="입고담당자"/>',
				name:'GOOD_PRSN',
				allowBlank: false,
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				listeners: {
					beforequery:function( queryPlan, eOpts )   {
                    	var store = queryPlan.combo.store;
                    	store.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                        	store.filterBy(function(record){
                            	return record.get('refCode1') == panelSearch.getValue('DIV_CODE');
                            })
                        }else{
                        	store.filterBy(function(record){
                            	return false;
							})
                        }
                    },
					change: function(combo, newValue, oldValue, eOpts) {
						outouProdtSaveSearch.setValue('BAD_PRSN',newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.gooditemqty" default="양품량"/>',
				name:'GOOD_Q',
				xtype: 'uniNumberfield'
			},{
				xtype: 'container',
				html: '※ <t:message code="system.label.product.defectreceipt" default="불량입고"/>',
				colspan: 2,
				style: {
					color: 'blue'
				}
			},{
				fieldLabel: '<t:message code="system.label.product.defectreceiptwarehouse" default="불량입고창고"/>',
				name:'BAD_WH_CODE',
				child: 'BAD_WH_CELL_CODE',
				allowBlank: true,
				xtype: 'uniCombobox',
				comboType   : 'OU',
				colspan: 1
			},{
                fieldLabel: '<t:message code="system.label.product.badwarehousecell" default="불량창고cell"/>',
                name: 'BAD_WH_CELL_CODE',
                xtype:'uniCombobox',
                disabled:sumTypeChk,
                store: Ext.data.StoreManager.lookup('whCellList2'),
                listeners: {
                	 render: function(combo, eOpts){

                    }
                }

            },{
				fieldLabel: '<t:message code="system.label.product.receiptcharger" default="입고담당자"/>',
				name:'BAD_PRSN',
				allowBlank: true,
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				listeners: {
					beforequery:function( queryPlan, eOpts )   {
                    	var store = queryPlan.combo.store;
                    	store.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                        	store.filterBy(function(record){
                            	return record.get('refCode1') == panelSearch.getValue('DIV_CODE');
                            })
                        }else{
                        	store.filterBy(function(record){
                            	return false;
							})
                        }
                    }
				}
			},{
				fieldLabel: '<t:message code="system.label.product.defectqty" default="불량수량"/>',
				name:'BAD_Q',
				xtype: 'uniNumberfield'
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
			outouProdtSave = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.product.productionautoinput" default="생산실적 자동입고"/>',
				width: 550,
				height: 230,
				layout: {type:'vbox', align:'stretch'},
				items: [outouProdtSaveSearch],
				tbar:  ['->',
					{itemId : 'saveBtn',
					text: '<t:message code="system.label.product.confirm" default="확인"/>',
					handler: function() {
						var activeTabId = tab.getActiveTab().getId();
						if(activeTabId == 'pmr100ukrvGrid3_1') {	// 공정별 등록
							if(outouProdtSaveSearch.setAllFieldsReadOnly(true) == false){
								return false;
							} else {
								//공정별등록 그리드 관련 로직
								if(BsaCodeInfo.gsSumTypeCell == 'Y'){//cell을 사용하고 있을 경우
									if(Ext.isEmpty(outouProdtSaveSearch.getValue('GOOD_WH_CELL_CODE'))){
											alert('<t:message code="system.message.product.message066" default="양품 입고창고cell을 선택해 주십시오."/>');
											return false;
									}
								}
								if(!Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_Q')) && outouProdtSaveSearch.getValue('BAD_Q') > 0){
									if(BsaCodeInfo.gsSumTypeCell == 'Y'){//cell을 사용하고 있을 경우
										if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_WH_CODE'))){
											alert('불량 입고창고를 선택해 주십시오.');
											return false;
										}else if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_PRSN'))){
											alert('불량 입고담당자를 선택해 주십시오.');
											return false;
										}else if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_WH_CELL_CODE'))){
											alert('<t:message code="system.message.product.message065" default="불량 입고창고cell을 선택해 주십시오."/>');
											return false;
										}

									}else{
										if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_WH_CODE'))){
											alert('불량 입고창고를 선택해 주십시오.');
											return false;
										}else if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_PRSN'))){
											alert('불량 입고담당자를 선택해 주십시오.');
											return false;
										}
									}


								}
								var updateData = masterGrid3.getStore().getUpdatedRecords();
								if(!Ext.isEmpty(updateData)) {
									Ext.each(updateData, function(updateRecord,i) {
										if(updateRecord.get('LINE_END_YN') == 'Y'){
											masterGrid3.setOutouProdtSave(updateRecord);
										}
									});
									outouProdtSave.hide();
									directMasterStore3.saveStore();
								}

								//실적현황 그리드 관련 로직
								var deleteData = tab4Grid.getStore().getRemovedRecords();	//실적현황 그리드의 삭제된 데이터
								if(!Ext.isEmpty(deleteData)) {
									Ext.each(deleteData, function(deleteRecord,i) {
										if(deleteRecord.get('LINE_END_YN') == 'Y'){
											tab4Grid.setOutouProdtSave(deleteRecord);
										}
									});
									outouProdtSave.hide();
									tab4Store.saveStore();
								}

							}
						}
					},
					disabled: false
					}, {
						itemId : 'CloseBtn',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							outouProdtSave.hide();
						}
					}
				],
				listeners: {
					beforehide: function(me, eOpt) {
						outouProdtSaveSearch.clearForm();
					},
					beforeshow: function( panel, eOpts )	{
						var activeTabId = tab.getActiveTab().getId();
						var detailRecord = detailGrid.getSelectedRecord();
						if(activeTabId == 'pmr100ukrvGrid3_1') {	// 공정 등록
							var records = directMasterStore3.data.items;

							Ext.each(records, function(record,i) {
								if(record.get('LINE_END_YN') == 'Y'){

									outouProdtSaveSearch.setValue('GOOD_Q',record.get('GOOD_WORK_Q'));
									outouProdtSaveSearch.setValue('BAD_Q',record.get('BAD_WORK_Q'));

									outouProdtSaveSearch.setValue('GOOD_WH_CODE',detailRecord.get('WH_CODE'));

									if(!Ext.isEmpty(record.get('BAD_WORK_Q'))){
										outouProdtSaveSearch.setValue('BAD_WH_CODE',detailRecord.get('WH_CODE'));

									}
								}
							});

						}
					}
				}
			})
		}
		outouProdtSave.center();
		outouProdtSave.show();
	}
	*/
	Unilite.Main({
		id: 's_pmr100ukrv_mitApp',
		borderItems: [{
			id: 'pageAll',
			region: 'center',
			layout: 'border',
			border: false,
			items: [
				panelSearch, detailGrid,
				{
                    region: 'center',
                    xtype: 'container',
                    layout: 'fit',
                    layout: {type:'vbox', align:'stretch'},
                    flex: 4,
                    items: [ masterForm, tab]
                }
				/*{
					xtype: 'container',
					layout: {type: 'vbox'},
					region: 'center',
					items:[
						masterForm, tab
					]
				}*/
			]
		}],
		fnInitBinding: function() {
			this.fnInitInputFields();
		},
		onResetButtonDown: function() {
			tabChangeCheck = 'N';
			panelSearch.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			masterForm.clearForm();
			tab1Form.clearForm();
			tab3Grid.reset();
			tab3Store.clearData();
			tab4Grid.reset();
			tab4Store.clearData();
			
			this.fnInitInputFields();
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
			panelSearch.getField('DIV_CODE').setReadOnly(true);
			tabChangeCheck = 'N';
			tab.setActiveTab('tab1');
			
			detailGrid.reset();
			detailStore.clearData();
			masterForm.clearForm();
			tab1Form.clearForm();
			tab3Grid.reset();
			tab3Store.clearData();
			tab4Grid.reset();
			tab4Store.clearData();
			
			detailStore.loadStoreRecords();
			UniAppManager.setToolbarButtons(['print','newData','delete','save'], false);
		},
		onNewDataButtonDown: function()	{
			if(!panelSearch.getInvalidMessage()) return;	//필수체크

			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'tab3') {
				 var record			= detailGrid.getSelectedRecord();
				 var divCode		= record.get('DIV_CODE');
				 var prodtDate		= UniDate.get('today');
				 var workShopcode	= record.get('WORK_SHOP_CODE');
				 var wkordNum		= record.get('WKORD_NUM');
				 var itemCode		= record.get('ITEM_CODE');
				 var badCode		= '';
				 var badQ			= 0;
				 var remark			= '';
				 
				 var r = {
					DIV_CODE			: divCode,
					PRODT_DATE			: prodtDate,
					WORK_SHOP_CODE		: workShopcode,
					WKORD_NUM			: wkordNum,
					ITEM_CODE			: itemCode,
					BAD_CODE			: badCode,
					BAD_Q				: badQ,
					REMARK				: remark
				};
				tab3Grid.createRow(r);
			}
		},
		onDeleteDataButtonDown: function() {
			var selGrid = null;
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'tab3') {
				var selGrid = tab3Grid;
			}else if(activeTabId == 'tab4') {
				var selGrid = tab4Grid;
			}
			
			var selRow = selGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)){
				if(selRow.phantom === true)	{
					selGrid.deleteSelectedRow();
				}else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					selGrid.deleteSelectedRow();
				}
			}
		},
		onSaveDataButtonDown: function(config) {
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
			
			var activeTabId = tab.getActiveTab().getId();
			var selectDetailRecord = detailGrid.getSelectedRecord();
					
			if(selectDetailRecord.get('WORK_Q')==0 && selectDetailRecord.get('JAN_Q') > 0){
				if(selectDetailRecord.get('CONTROL_STATUS') != '9' || selectDetailRecord.get('CONTROL_STATUS') != '8'){
					tab1Form.setValue('WORK_Q',selectDetailRecord.get('JAN_Q',false));
					tab1Form.setValue('GOOD_WORK_Q',selectDetailRecord.get('JAN_Q',false));
				}
			}
			var param = {
				'DIV_CODE' : selectDetailRecord.get('DIV_CODE'),
				'WKORD_NUM' : selectDetailRecord.get('WKORD_NUM'),
				'PROG_WORK_CODE' : selectDetailRecord.get('PROG_WORK_CODE')
			}
			s_pmr100ukrv_mitService.checkWorkEnd(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.WORK_END_YN == 'Y'){
						Unilite.messageBox('마감된 작업지시입니다.');
						return false;
					}else{
						if(activeTabId == 'tab1') {
							detailStore.saveStore();
						}else if(activeTabId == 'tab3') {
							tab3Store.saveStore();
						}else if(activeTabId == 'tab4') {
							tab4Store.saveStore();
						}
						
		/*				var inValidRecs1	= detailStore.getInvalidRecords();
						var inValidRecs2	= tab4Store.getInvalidRecords();//생산현황탭 관련 스토어로 변경 필요
						var updateData		= detailStore.getUpdatedRecords();
						var deleteData		= tab4Store.getRemovedRecords();//생산현황탭 관련 스토어로 변경 필요

						//공정별 등록 그리드의 수정된 데이터 관련 로직
						if(inValidRecs1.length == 0) {
							if(updateData && updateData.length > 0) {
								if(selectDetailRecord.get('RESULT_YN') == '2'){
									var cnt = 0;
									Ext.each(updateData, function(updateRecord,i) {
										if(updateRecord.get('LINE_END_YN') == 'Y'){
											cnt = cnt + 1;
										}
									});
									if(cnt > 0){
										openoutouProdtSave();
									}else{
										detailStore.saveStore();

									}
								}else{
									detailStore.saveStore();
								}
								detailStore.saveStore();
							}
						} else {
							var grid = Ext.getCmp('detailGrid');
							grid.uniSelectInvalidColumnAndAlert(inValidRecs1);
						}

						//실적현황 그리드의 삭제된 데이터 관련 로직
						if(inValidRecs2.length == 0) {
							if(deleteData && deleteData.length > 0) {
								tab4Store.saveStore();	//생산현황탭 관련 스토어로 변경 필요
							}
						} else {
							var grid = Ext.getCmp('tab4Grid');
							grid.uniSelectInvalidColumnAndAlert(inValidRecs2);
						}
			*/
						
					}
				}
			})
			
			
		},
		fnInitInputFields: function(){
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			
			panelSearch.setValue('PRODT_END_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('PRODT_END_DATE_TO',UniDate.get('today'));
			
			panelSearch.setValue('GS_FR_TIME', BsaCodeInfo.gsLunchFr);
			panelSearch.setValue('GS_TO_TIME', BsaCodeInfo.gsLunchTo);
			
			panelSearch.setValue('CONTROL_STATUS','2');
			
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','delete','save'], false);
			
			tab.setActiveTab('tab1');
			setTimeout( function() {
				panelSearch.getField('WKORD_NUM_INPUT').focus();
				
				tabChangeCheck = 'Y';
			}, 50 );

			//20200317 추가
			if(UserInfo.divCode == '02') {
				//fnSetTab1Form(false);
				fnSetTab1Form(true);
			} else {
				fnSetTab1Form(true);
			}
		}
	});





	//20200317 추가
	function fnSetTab1Form(flag) {
		tab1Form.getField('WORK_PROGRESS').setHidden(flag);
		tab1Form.getField('DUE_DATE').setHidden(flag);
		tab1Form.getField('MAN_HOUR_150').setHidden(flag);
		tab1Form.down('#SAVE_WORK_PROGRESS').setHidden(flag);
		tab1Form.down('#HISTORY_WORK_PROGRESS').setHidden(flag);
		
		tab1Form.down('#FIELD_SET').setHidden(flag);

		tab1Form.setValue('WORK_PROGRESS'	, 0);
		tab1Form.setValue('MAN_HOUR_150'	, 1);
		tab1Form.setValue('DUE_DATE'		, UniDate.get('today'));
	}


	//20200317 추가: 진척이력 윈도우
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 's_pmr100ukrv_mitService.selectWorkProgressList',
//			create	: 's_pmr100ukrv_mitService.insertDetail',
			update	: 's_pmr100ukrv_mitService.updateWorkProgress',
//			destroy	: 's_pmr100ukrv_mitService.deleteDetail',
			syncAll	: 's_pmr100ukrv_mitService.savetWorkProgress'
		}
	});
	Unilite.defineModel('workProgressModel', {
		fields: [
			//20200317 추가: 완성율, 완성일(오늘), 작업월(진척이력 조회용)
			{name: 'WORK_PROGRESS'	,text: '진척율'			,type:'float' , allowBlank: false},
			{name: 'WORK_MONTH'		,text: '실적월'			,type:'string' , editable: false},
			{name: 'MAN_HOUR'		,text: '투입공수'			,type:'uniQty', allowBlank: false}
		]
	});	
	var workProgressStore = Unilite.createStore('s_pmr100ukrv_mitWorkProgressStore',{
		model	: 'workProgressModel',
		proxy	: directProxy2,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var detailRecord	= detailGrid.getSelectedRecord();
			var param			= masterForm.getValues();
			param.DIV_CODE		= panelSearch.getValue('DIV_CODE');
			param.WORK_SHOP_CODE= detailRecord.get('WORK_SHOP_CODE');
			param.WKORD_NUM		= detailRecord.get('WKORD_NUM');

			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {
					}
				}
			});
		},
		saveStore: function() {
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var inValidRecs = this.getInvalidRecords();

			// 1. 마스터 정보 파라미터 구성
			var paramMaster				= masterForm.getValues();	// syncAll 수정
			var detailRecord			= detailGrid.getSelectedRecord();
			paramMaster.DIV_CODE		= panelSearch.getValue('DIV_CODE');
			paramMaster.WORK_SHOP_CODE	= detailRecord.get('WORK_SHOP_CODE');
			paramMaster.WKORD_NUM		= detailRecord.get('WKORD_NUM');

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						workProgressStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr100ukrv_mitWorkProgressGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	var workProgressGrid = Unilite.createGrid('s_pmr100ukrv_mitWorkProgressGrid', {
		store	: workProgressStore,
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: true
		},
		columns : [
			{ dataIndex: 'WORK_MONTH'		, width: 150 , align: 'center' },
			{ dataIndex: 'MAN_HOUR'			, width: 200},
			{ dataIndex: 'WORK_PROGRESS'	, flex: 1}
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function(record) {
		}
	});
	var workProgressPanel = Unilite.createSearchForm('workProgressPanel', {
		layout	: {type: 'uniTable', columns : 3},
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			readOnly	: true
		},{
			xtype: 'component',
			width: 30
		},{
			fieldLabel	: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			xtype		: 'uniTextfield',
			name		: 'WKORD_NUM',
			allowBlank	: false,
			readOnly	: true
		}]
	});
	function openworkProgressWindow() {
		if(!workProgressWindow) {
			workProgressWindow = Ext.create('widget.uniDetailWindow', {
				title	: '진척이력 조회',
				width	: 650,
				height	: 300,
				layout	: {type:'vbox', align:'stretch'},
				items	: [workProgressPanel, workProgressGrid],
				tbar	:['->',{
					itemId  : 'queryBtn',
					text	: '조회',
					handler : function() {
						if(!workProgressPanel.getInvalidMessage()) return;	//필수체크
						workProgressStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId  : 'saveBtn',
					text	: '저장',
					handler : function() {
						workProgressStore.saveStore();
					},
					disabled: false
				},{
					itemId  : 'closeBtn',
					text	: '<t:message code="system.label.sales.confirm" default="확인"/>',
					handler : function() {
						workProgressWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						workProgressGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						workProgressGrid.reset();
					},
					show: function( panel, eOpts ) {
						workProgressPanel.setValue('DIV_CODE'	, panelSearch.getValue('DIV_CODE'));
						workProgressPanel.setValue('WKORD_NUM'	, masterForm.getValue('WKORD_NUM'));

						if(!workProgressPanel.getInvalidMessage()) return;	//필수체크
						workProgressStore.loadStoreRecords();
					}
				}
			})
		}
		workProgressWindow.center();
		workProgressWindow.show();
	};

	function resultFormQtyClear(fieldName){
	   var fieldArry = new Array(); //배열선언
	   fieldArry[0]= 'SAVING_Q';
	   fieldArry[1]='GOOD_WORK_Q';
       fieldArry[2]= 'BOX_TRNS_RATE';
       fieldArry[3]= 'BOX_Q';
       fieldArry[4]= 'PIECE';
       fieldArry[5]= 'BAD_WORK_Q';
       fieldArry[6]= 'YIELD';
       fieldArry[7]= 'LOSS_Q';
       fieldArry[8]= 'ETC_Q';

       for(var i=0; i < fieldArry.length; i++){
    	   if(fieldArry[i] != fieldName && fieldArry[i] != 'BOX_TRNS_RATE'){
    		   tab1Form.setValue(fieldArry[i],'');
    	   }else if(fieldArry[i] == 'BOX_TRNS_RATE'){
    		   tab1Form.setValue(fieldArry[i],'');
    	   }
       }

	}
	/*실적 팝업 계산 로직*/
    function fn_resultQtyCalc(calPassQMethod, fieldName, newValue){
    	var workQ = tab1Form.getValue('WORK_Q');
		var badWorkQ = tab1Form.getValue('BAD_WORK_Q');
		var lossQ = tab1Form.getValue('LOSS_Q');
		var savingQ = tab1Form.getValue('SAVING_Q');
		var goodWorkQ = tab1Form.getValue('GOOD_WORK_Q');
		var boxQ   =  tab1Form.getValue('BOX_Q');
		var boxTrnsRate = 	tab1Form.getValue('BOX_TRNS_RATE');
		var piece = tab1Form.getValue('PIECE');
		var etcQ = tab1Form.getValue('ETC_Q');
		var resultBoxCase = 0.00 ;
		var calYield = 0.00;
		var calBoxQty = 0.00;
		//현재 수정한 필드에 따라 값 세팅
		if(fieldName == 'SAVING_Q'){
			goodWorkQ 			=  workQ - newValue - badWorkQ - lossQ - etcQ;
			resultBoxCase     =  (boxQ * boxTrnsRate + piece) + newValue + badWorkQ + lossQ + etcQ;
			calBoxQty   		=  (boxQ * boxTrnsRate + piece) ;

		}else if (fieldName == 'WORK_Q'){
			goodWorkQ = newValue - savingQ - badWorkQ - lossQ - etcQ;
			tab1Form.setValue('GOOD_WORK_Q', goodWorkQ);
			tab1Form.setValue('PASS_Q', goodWorkQ);
			calYield = (goodWorkQ / newValue) * 100; // 수율 = 양품량 /생산량
			tab1Form.setValue('YIELD', calYield);

		}else if (fieldName == 'GOOD_WORK_Q'){
			  workQ = 	newValue + savingQ + badWorkQ + lossQ + etcQ ;
			  var calYield = (newValue / workQ) * 100; // 수율 = 양품량 /생산량
    		  tab1Form.setValue('WORK_Q',  workQ);
			  tab1Form.setValue('YIELD', calYield);

		}else if(fieldName == 'BAD_WORK_Q'){
			workQ = tab1Form.getValue('JAN_Q');
			if(Unilite.nvl(tab1Form.getValue('WORK_Q'),0) == 0/* && Unilite.nvl(tab1Form.getValue('GOOD_WORK_Q'),0) == 0*/){
				
				goodWorkQ = tab1Form.getValue('JAN_Q') - newValue;
				
			}else{
				goodWorkQ 			=  workQ - savingQ - newValue - lossQ - etcQ;
			}
			resultBoxCase     =  (boxQ * boxTrnsRate + piece) + savingQ + newValue + lossQ + etcQ;
			calBoxQty   		=  (boxQ * boxTrnsRate + piece) ;

		}else if(fieldName == 'LOSS_Q'){
			goodWorkQ	 	  =	  workQ - savingQ - badWorkQ - newValue - etcQ;
			resultBoxCase     =  (boxQ * boxTrnsRate + piece) + savingQ + badWorkQ + newValue + etcQ;
			calBoxQty   		=  (boxQ * boxTrnsRate + piece) ;

		}else if(fieldName == 'ETC_Q'){
			goodWorkQ	 	  =	  workQ - savingQ - badWorkQ - lossQ - newValue;
			resultBoxCase     =  (boxQ * boxTrnsRate + piece) + savingQ + badWorkQ + lossQ + newValue;
			calBoxQty   		=  (boxQ * boxTrnsRate + piece) ;

		}else if(fieldName == 'BOX_Q'){
			 calBoxQty = newValue *  boxTrnsRate +  piece;
			 workQ = calBoxQty + savingQ + badWorkQ + lossQ + etcQ;
			 calYield = (calBoxQty / workQ) * 100; // 수율 = 양품량 /생산량
			 tab1Form.setValue('YIELD', calYield);
			 tab1Form.setValue('GOOD_WORK_Q',  calBoxQty);
			 tab1Form.setValue('PASS_Q',  calBoxQty);
		     tab1Form.setValue('WORK_Q', workQ);

		}else if(fieldName == 'BOX_TRNS_RATE'){
			calBoxQty = newValue * boxQ +  piece;

		}else if(fieldName == 'PIECE'){

			calBoxQty = boxTrnsRate * boxQ +  newValue;
		}

  		if(calPassQMethod == 'A' && (fieldName != 'WORK_Q' && fieldName != 'GOOD_WORK_Q' && fieldName != 'BOX_Q')){//직전에 생산량을 입력했을 경우

    		tab1Form.setValue('GOOD_WORK_Q', goodWorkQ);
    		tab1Form.setValue('PASS_Q', goodWorkQ);
			calYield = (goodWorkQ / workQ) * 100; // 수율 = 양품량 /생산량
			tab1Form.setValue('YIELD', calYield);

    	}else if(calPassQMethod == 'B' && (fieldName != 'WORK_Q' && fieldName != 'GOOD_WORK_Q' && fieldName != 'BOX_Q')){//직전에 양품량을 입력했을 경우
    		tab1Form.setValue('WORK_Q', resultBoxCase + goodWorkQ);
		    calYield =  (goodWorkQ / (resultBoxCase + goodWorkQ)) * 100; // 수율 = 양품량 /생산량
			tab1Form.setValue('YIELD', calYield);

    	}else if(calPassQMethod == 'C' && (fieldName != 'WORK_Q' && fieldName != 'GOOD_WORK_Q' && fieldName != 'BOX_Q')){//직전에 박스 수량을 입력했을 경우
			tab1Form.setValue('GOOD_WORK_Q',  calBoxQty);
			tab1Form.setValue('PASS_Q',  calBoxQty);
			tab1Form.setValue('WORK_Q', calBoxQty + badWorkQ +savingQ + lossQ + etcQ );
			calYield = (calBoxQty / (calBoxQty + badWorkQ +savingQ + lossQ + etcQ)) * 100; // 수율 = 양품량 /생산량
			tab1Form.setValue('YIELD', calYield);
    	}else if(calPassQMethod == 'D'){
			tab1Form.setValue('WORK_Q', workQ);
			tab1Form.setValue('GOOD_WORK_Q', goodWorkQ);
		    calYield =  (goodWorkQ / (resultBoxCase + goodWorkQ)) * 100; // 수율 = 양품량 /생산량
			tab1Form.setValue('YIELD', calYield);
    	}
    }
};
</script>