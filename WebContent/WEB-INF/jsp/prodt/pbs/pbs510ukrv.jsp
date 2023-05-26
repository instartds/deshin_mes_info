<%--
'   프로그램명 : 작업지시현황(공정달력) (생산)
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'   최종수정자 :
'   최종수정일 :
'   버      전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pbs510ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pbs510ukrv" /> 					  	<!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="P001"  />							<!-- 초과유무 -->
    <t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> 					<!-- 작업장 -->
    <t:ExtComboStore comboType="W" />     <!--작업장(전체) -->
    <t:ExtComboStore comboType="AU" comboCode="P202" storeId="timeStore" />			<!-- 가동시간(컬럼) -->

</t:appConfig>

	
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/app-dark.css"/>" id="dark-style" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/app.css"/>" id="light-style" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/datatables/buttons.bootstrap4.min.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/common.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/vendor/jquery-jvectormap-1.2.2.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/icons.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/datatables/dataTables.bootstrap4.min.css"/>" />
	
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor.js" ></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/app.js" ></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor/jquery-jvectormap-1.2.2.min.js" ></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor/jquery-ui.min.js" ></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/common/util.js"></script>

<script type="text/javascript" >

function appMain() {

	var period_gubn = {	// WEEK, MONTH 구분값
		week : 'WEEK',
		month : 'MONTH'
	};

	var timeValue = {	// 공통코드(P202) 설정 된 오전,오후, 야근 시간
	time1 : 0.0,
	time2 : 0.0,
	time3 : 0.0,
	time4 : 0.0,
	time5 : 0.0
	};

	var BsaCodeInfo = {
		std_dayofweek	: '${STD_DAYOFWEEK}'.substring(0,3)	// 주차 시작요일 (code : B604) ex) '월요일', '일용'
	};

	var period_param = period_gubn.week;	// 화면 초기화 defalt "WEEK"
	var std_date = new Date();				// 기준일 초기화(조회조건)
	var select_date = null;					// 선택 된 그리드 기준
	var addModel = null;					// 동적으로 생성 된 실제 model
	var addStore = null;					// 동적으로 생성 된 실제 store
	var g_dates = createPeriodDate();		// 기준일 기준 기간 컬럼
	var fields = createModelField();
	var columns = createGridColumn();

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pbs510ukrvService.selectList',
			update: 'pbs510ukrvService.saveAll',
			syncAll: 'pbs510ukrvService.saveAll'
		}
	});

	Unilite.defineModel('Pbs510ukrvModel', {
		fields: fields
	});

	var OpeningTimeStore = Unilite.createStore('pbs510ukrvOpeningTimeStore',{	// 시업시간 조회
		autoLoad: true,
		fields : ['OpeningTime'],
		proxy: {
			type: 'direct',
			api: {
				read: 'pbs510ukrvService.selectOpeningTime'
			}
		},
		loadStoreRecords : function()	{
			/*
			 * 1. 첫 로딩 시 default 날짜 기준 조회
			 * 2. 동적 헤더 클릭시 선택 된 날짜
			 * */
			var param= panelResult.getValues();
			param["STD_DATE"] = std_date;

			this.load({
				params : param,
				callback: function(records,options,success) {	// 조회 된 후 처리되는 로직
					if(success) {
						if(records.length > 0){	// 동적컬럼이 아닌 컬럼을 선택했을 경우 기준일 데이터가 빈값으로 조회 된 데이터 없음
							panelResult.setValue('OPENING_TIME', OpeningTimeStore.getData().items[0].data.OPENING_TIME);	// 시업시간 재설정
						}
					}
				}
			});
		}
	});

	var TimeInfoStore = Unilite.createStore('pbs510ukrvTimeInfoStore',{	// 오전1, 오전2, 오후1, 오후2 조회
		autoLoad: true,
		fields : ['SELECT_ALL','PROG_WORK_CODE' ,'EQU_CODE' ,'REAL_TIME' ,'TIME1' ,'TIME2' ,'TIME3' ,'TIME4' ,'TIME5', 'REMARK'],
		proxy: {
			type: 'direct',
			api: {
				read: 'pbs510ukrvService.selectTimeInfoStore'
			}
		},
		loadStoreRecords : function() {
			/*
			 * 1. 첫 로딩 시 default 날짜 기준 조회
			 * 2. 동적 헤더 클릭시 선택 된 날짜
			 * */
			var param= panelResult.getValues();
			param["STD_DATE"] = std_date;

			this.load({
				params : param,
				callback: function(records,options,success) {	// 조회 된 후 처리되는 로직
					if(success) {
						if(records.length > 0){	// 동적컬럼이 아닌 컬럼을 선택했을 경우 기준일 데이터가 빈값으로 조회 된 데이터 없음
							var grdRecords = addStore.data.items;        // addStore 모든 데이터
							Ext.each(grdRecords, function(grdRecord, i) {
								Ext.each(records, function(record, j) {			// records = 조회 된 data
									if(grdRecord.data.EQU_CODE == record.data.EQU_CODE){				// 설비코드
										grdRecord.set('SELECT_ALL' , record.data.SELECT_ALL);
										grdRecord.set('REAL_TIME' , record.data.REAL_TIME);
										grdRecord.set('TIME1' , record.data.TIME1 == 'true' ? true : false);
										grdRecord.set('TIME2' , record.data.TIME2 == 'true' ? true : false);
										grdRecord.set('TIME3' , record.data.TIME3 == 'true' ? true : false);
										grdRecord.set('TIME4' , record.data.TIME4 == 'true' ? true : false);
										grdRecord.set('TIME5' , record.data.TIME5 == 'true' ? true : false);
										grdRecord.set('REMARK' , record.data.REMARK);
									};
								});
							});
							addStore.commitChanges();    // addStore 상태 nomal 변경 => added, updated, deleted 상태 없음으로
						}
					}
				}
			});
		},
		listeners: {
			/** ▼cf. loadingbar 생성 방법
			 * Ext.getBody().mask('Loading...');
			 * Ext.getBody().unmask();
			 **/
			beforeload: function() {
				Ext.getBody().mask('로딩 중...');
			},
			load: function() {
				Ext.getBody().unmask();
			}
		}

	});

	var directMasterStore = Unilite.createStore('pbs510ukrvMasterStore',{	// 그리드 초기화 진행 후에 동적 컬럼 생성 위해 재 생성 됨
		model: 'Pbs510ukrvModel',
		uniOpt: {
			isMaster: true,				// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false				// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			param["PERIOD_PARAM"] = period_param;
			param["STD_DAYOFWEEK"] = BsaCodeInfo.std_dayofweek;
//			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'ITEM_CODE',
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	 Ext.each(records, function(record,i) {
           		var wkordQ = record.data.WKORD_Q;
    			var prodtQ = record.data.PRODT_Q;
				record.set('TARGET_RATE',Number.parseInt((prodtQ/wkordQ)*100) + '%');
				});
         	store.commitChanges();
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});//End of var directMasterStore

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout	: {type : 'uniTable', columns : 4, tableAttrs: {width: '99.5%'}},
	//	padding:'2 2 2 2',
		border:true,
		items:[{
    		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
    		name: 'DIV_CODE',
    		value : UserInfo.divCode,
    		xtype: 'uniCombobox',
    		comboType: 'BOR120',
    		allowBlank: false,
    		tdAttrs		: {width: 270},
    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				}
    		}
		},{
			fieldLabel	: '기준일',
			name		: 'STD_DATE',
			xtype		: 'uniDatefield',
			value		: std_date,
			allowBlank	: false,
			tdAttrs		: {width: 270},
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					g_dates = createPeriodDate();	// 기준일 기준 기간 컬럼 재 설정
					createModelStore();				// 기준일 변경되면 그리드 동적 컬럼 reset
					dayChange(masterGrid);			// 그리드 날짜 색상 변경
				},
				blur : function (e, event, eOpts) {

				}
			}
		},{ fieldLabel: '시업시간',
            name:'OPENING_TIME',
            xtype:'timefield',
            format: 'H:i',
            increment: 10,
            width: 200,
            tdAttrs		: {width: 270},
            readOnly: false,
            fieldStyle: 'text-align: center;',
    		colspan:2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				},blur: function(field, event, eOpts ) {

				}
			}
  		},/*{
			xtype: 'container',
			layout:{type:'uniTable',columns:3},
			tdAttrs	: {align: 'right'},
			items:[{
				text:'WEEK',
				xtype: 'button',
				margin: '0 0 0 5',
				hidden: false,
				handler: function(){
					period_param = period_gubn.week;
				}
//					},{
//						text	: 'MONTH',
//						xtype	: 'button',
//						margin	: '0 0 0 5',
//						handler	: function(){
//							period_param = period_gubn.month;
//						}
//					},{
//						text	: '설정',
//						xtype	: 'button',
//						margin	: '0 0 0 5',
//						handler	: function(){
//
//						}
			}]
		},*/{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType: 'W',
			allowBlank: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				}
			}
		},{
			xtype: 'container',
			layout:{type:'uniTable',columns:2},
			tdAttrs	: {align: 'center'},
			items:[{
				text:'일괄선택',
				xtype: 'button',
				width: 100,
				margin: '0 0 0 5',
				hidden: false,
				handler: function(){
					
//						AlertsUtil.kioskWarning_3("정상");
					
					var chkStore = addStore;
					if(Ext.isEmpty(chkStore)){
						alert('일괄선택 할 데이터가 없습니다.');
					}else{
						var records = addStore.data.items;
						if(Ext.isEmpty(records)){
							alert('일괄선택 할 데이터가 없습니다.');
						}else{
							Ext.each(records,function(record,index ){
							
								checkAll(index, true);
							})
							
							
						}
					}
					
					
				
				}
			},{
				text:'일괄선택해제',
				xtype: 'button',
				width: 100,
				margin: '0 0 0 5',
				hidden: false,
				handler: function(){
					
//						AlertsUtil.kioskWarning_3("정상");
					
					var chkStore = addStore;
					if(Ext.isEmpty(chkStore)){
						alert('일괄선택해제 할 데이터가 없습니다.');
					}else{
						var records = addStore.data.items;
						if(Ext.isEmpty(records)){
							alert('일괄선택해제 할 데이터가 없습니다.');
						}else{
							Ext.each(records,function(record,index ){
							
								checkAll(index, false);
							})
							
							
						}
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
				   	Unilite.messageBox(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
   				}
	  		} else {
				this.unmask();
			}
			return r;
		}
    });		// end of var panelResult

	var masterGrid = Unilite.createGrid('pbs510ukrvGrid', {
		layout: 'fit',
		region: 'center',
		uniOpt:{
        	expandLastColumn: false,	// 그리드 컬럼 크기 화면 채움
    		useLiveSearch: true,
//			useContextMenu: true,		// 오른쪽마우스 클릭
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			state: {
		    	useState: false,	//그리드 설정 버튼 사용 여부
		   		useStateList: false	//그리드 설정 목록 사용 여부
			}
        },
		/** ▼EVENT selModel 선택 되지 않은 행 중에서 오른쪽 버튼 클릭했을 때 타는 이벤트
		 *
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,	// 그리드 row checkbox
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					debugger;
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					debugger;
				}
			}
		}),*/
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		store: directMasterStore,
		columns:  columns,	// 동적 생성 위함
		listeners: {
			headerclick :function( ct, column, e, t, eOpts ) {	// 그리드 header 선택 시
				if(!addStore){	// 조회가 되지 않은 상태 = 그리드 데이터 없는 상태, 실제 조회 store : addStore
					return;
				}
				/* 1. createPeriodDate() 내에 있는 값이랑 그리드 선택 된 값이랑 비교
				 * 2. 있으면 조회 조건 기준일 변경 및 실가동시간, TIME1~5, 비고(특이사항) 변경
				 */
//				if(addStore.isDirty()){	// store CRUD 상태 확인
//					Ext.MessageBox.show({
//						msg : '저장되지 않은 수정 된 데이터가 있습니다. 그래도 계속 진행하시겠습니까?',
//						icon: Ext.Msg.WARNING,
//						buttons : Ext.MessageBox.OKCANCEL,
//						fn : function(buttonId) {
//							switch (buttonId) {
//								case 'cancel' :	// 그냥 두기 또는 재 조회
//									return;
//									break;
//								case 'ok' :		// 저장 시키기
//							}
//						},
//						scope : this
//					}); // MessageBox End
//				}
//				}else {
					var grdRecords = addStore.data.items;        //addStore 모든 데이터

					if(column.gridDataColumns){	// 분할 된 컬럼 선택 시 undefined 뜨기 때문
					/**▼cf. 컬럼명 가져오는 방법
						 * eOpts.headerclick.arguments[1].columnManager.headerCt.gridDataColumns[0].initialConfig.dataIndex	// WORK_DATE_20210601
						 * column.gridDataColumns[0].dataIndex	// WORK_DATE_20210601
						 * t.textContent	// 06월01일
						 */
					/**▼cf. 이벤트 발생 그리드 컬럼 탐색 방법
					 * ct.columnManager.columns.forEach(function (value, index, array) {	// 이벤트 발생 그리드 컬럼 탐색
					 * if(value.dataIndex)	return;// "", null, undefined, 0, NaN 일 경우 false
					 * console.log(value.dataIndex);
					});
					*/
						std_date = new Date(column.gridDataColumns[0].dataIndex.substring(10, 14)
											+ '-' + column.gridDataColumns[0].dataIndex.substring(14, 16)
											+ '-' + column.gridDataColumns[0].dataIndex.substring(16, 18));	// 선택 한 컬럼 날짜만 추출해서 Date 형식으로 변환 후 설정
						OpeningTimeStore.loadStoreRecords();	// 선택 된 컬럼 날짜에 해당하는 OpeningTime 재조회

						if(masterGrid.getColumn(column.gridDataColumns[0].dataIndex)){
							var clickColName = masterGrid.getColumn(column.gridDataColumns[0].dataIndex).dataIndex;	// 현재 그리드 컬럼에서 선택 된 컬럼 get

							g_dates.forEach(function (value, index, array) {
								if(value.name != clickColName){	// 동적 컬럼 데이터만 실가동시간 컬럼으로 set
									masterGrid.getColumn(value.name).setStyle('background-color', '#edebeb');	// 기준일 아닌 컬럼 defalut 색으로 변경
								}else{
									var colToday = UniDate.getDbDateStr(clickColName.substring(10, 18));		// 기준일과 동일한 그리드 컬럼
									masterGrid.getColumn(value.name).setStyle('background-color', '#62CEDB');	// 기준일 색 변경
									panelResult.setValue('STD_DATE', colToday); // 선택한 컬럼 날짜를 기준일로 설정

									TimeInfoStore.loadStoreRecords();		// 선택 된 컬럼 날짜에 해당하는 오전1, 오전2, 오후1, 오후2, 야근, 비고(특이사항)
								}
							});
						}
//					}
				}
			}
		}
	});//End of var masterGrid

	Unilite.Main( {	// 화면 시작
			borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[

					masterGrid, panelResult
				]
			}
		],
		id: 'pbs510ukrvApp',
		fnInitBinding: function(){
			UniAppManager.setToolbarButtons(['reset','detail', 'save'], false);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('OPENING_TIME', '08:30');	// 조회 전 기본값
			dayChange(masterGrid);
		},
		onQueryButtonDown: function() { // 조회 버튼
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				addModel = null;
				createModelStore(); // 동적
			}
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			/*var progUnitQ = detailStore.data.items.PROG_UNIT_Q;

			Ext.each(progUnitQ, function(record,i){

				if(record.get('PROG_UNIT_Q',(progUnitQ)) > 1){
					alret("tttt");
				}

			});*/

			addStore.saveStore();
////			UniAppManager.app.onQueryButtonDown();
//			if(panelResult.getField('WKORD_NUM') != ''){
//				//panelSearch.getField('REWORK_YN').setReadOnly( false ); test
////			Ext.getCmp('workEndYn').setReadOnly(true);
//				Ext.getCmp('workEndYnRe').setReadOnly(true);
//			}
//			else{
//				//panelSearch.getField('REWORK_YN').setReadOnly( true ); test
////				Ext.getCmp('workEndYn').setReadOnly(false);
//				Ext.getCmp('workEndYnRe').setReadOnly(false);
//			}
		},
//		onResetButtonDown: function() {
//			panelResult.clearForm();
//			panelResult.setValue('BASIS_YYYYMM',UniDate.get('startOfMonth'));
//			masterGrid.reset();
//			directMasterStore.clearData();
//			this.fnInitBinding();
//		},
		checkForNewDetail:function() {
			if(panelResult.setAllFieldsReadOnly(true))
				return panelResult.setAllFieldsReadOnly(true);
			else return false;
		},
		fnCalcSelectedTime: function(CheckColumn, rowIndex, checked, eOpts){	// 오전1,2, 오후1,2, 야근 셀 체크 시 실 가동시간 자동 계산 로직
			var number = 0.0;
			if(checked == true){	// 체크 된 상태면 (+)
				number = Number(CheckColumn.text);
			}else{	// 체크 해제 상태면 (-)
				number = Number('-' + CheckColumn.text);
			};
			var selectColName = 'WORK_DATE_' + UniDate.getDbDateStr(moment(std_date).format('YYYYMMDD'));
			// 선택 된 기준일 가동시간 계산
			eOpts.set(selectColName, (Number(eOpts.get(selectColName)) + number).toFixed(2));    // JavaScript 버그 방지
			eOpts.set('REAL_TIME', (eOpts.get('REAL_TIME') + number).toFixed(2));        // JavaScript 버그 방지 8.8 - 3 = 5.3000000001 이렇게 나옴
		}
	});//End of Unilite.Main

	function createPeriodDate() {	// 그리드 컬럼 기간(동적) 생성

		var beforeConvertFr;
		var beforeConvertTo;

		var format = "YYYYMMDD"; //사이트별로 설정?

		var dates = [];

		if(panelResult){
			std_date = new Date(panelResult.getValue('STD_DATE'));
		}
		else{
			std_date = new Date();	// 조회조건 '기준일' 초기화 값
		}

		switch(period_param){
			case period_gubn.week :
				monday = new Date(moment(std_date).startOf("week").add('day',1));	// 기준일이 포함 된 주의 월
				sunday = new Date(moment(std_date).endOf("week").add('day',1));		// 기준일이 포함 된 주의 일

				switch(BsaCodeInfo.std_dayofweek){
					case '일요일':
						beforeConvertFr = UniDate.getDbDateStr(moment(monday).add('day',-1).format(format));	// 월 - 1 = 일
						beforeConvertTo = UniDate.getDbDateStr(moment(sunday).add('day',-1).format(format));	// 일 - 1 = 토
					break;

					default:	// default '월'
						beforeConvertFr = UniDate.getDbDateStr(moment(monday).format(format));
						beforeConvertTo = UniDate.getDbDateStr(moment(sunday).format(format));
					break;
				}
			break;

			case period_gubn.month :
				// 구현 예정
			break;
		}

		var startDate = new Date(UniDate.getDbDateStr(beforeConvertFr).substring(0,4)	// YYYY
				  + '/' + UniDate.getDbDateStr(beforeConvertFr).substring(4,6)			// MM
				  + '/' + UniDate.getDbDateStr(beforeConvertFr).substring(6,8));		// DD

		var endDate = new Date(UniDate.getDbDateStr(beforeConvertTo).substring(0,4)
				  + '/' + UniDate.getDbDateStr(beforeConvertTo).substring(4,6)
				  + '/' + UniDate.getDbDateStr(beforeConvertTo).substring(6,8));

		var interval = moment(endDate).diff(moment(startDate), "days");	// From ~ To 기간

		for(var i = 0; i <= interval; i++){ // From ~ To 기간 만큼
			var date = moment(startDate).day(i);

			dates.push({ name: 'WORK_DATE_' + date.format(format)	//ex) WORK_DATE20210531
						,text: date.format(format).substring(4,6) + '월' + date.format(format).substring(6,8) + '일' // ex) 05월31일
						,weekday : date.format("ddd")		// ex) Sun Mon...
						,stdDay : UniDate.getDbDateStr(std_date)	// 설정 된 기준일
						});
		}

		return dates;

	}

	function createGridColumn() {
		var columns = [
			{dataIndex: 'SELECT_ALL'     	, xtype: 'checkcolumn',	id:'chkSelectAll', disabledCls : ''	, width: 70, style: {textAlign: 'center' },	locked: false
				,sortable: false
				,listeners: {
					checkchange: function(CheckColumn, rowIndex, checked, eOpts){
						checkAll(rowIndex, checked);
				/*		var selectRecord = addStore.data.items[rowIndex];
						var selectColName = 'WORK_DATE_' + UniDate.getDbDateStr(moment(std_date).format('YYYYMMDD'));
						
						if(checked){
							var timeStore=  Ext.data.StoreManager.lookup('timeStore');	// 오전, 오후, 야근 시간 공통코드 컬럼
							var timeAll = 0.0;
							if(!Ext.isEmpty(timeStore)){
								Ext.each(timeStore.data.items, function(comboData, idx) {
									if(!Ext.isEmpty(comboData)){
										if((typeof parseFloat(comboData.get('refCode1'))) == "number"){
											if(!isNaN(parseFloat(comboData.get('refCode1')))){
												timeAll += (comboData.get('refCode1') / 60);
											}
										}
									}
								});
							}
							selectRecord.set('TIME1',true);
							selectRecord.set('TIME2',true);
							selectRecord.set('TIME3',true);
							selectRecord.set('TIME4',true);
							selectRecord.set('TIME5',true);
							
							// 선택 된 기준일 가동시간 계산
							selectRecord.set(selectColName, timeAll.toFixed(2));
							selectRecord.set('REAL_TIME', timeAll.toFixed(2)); 
						}else{
							selectRecord.set('TIME1',false);
							selectRecord.set('TIME2',false);
							selectRecord.set('TIME3',false);
							selectRecord.set('TIME4',false);
							selectRecord.set('TIME5',false);
							
							selectRecord.set(selectColName, 0);
							selectRecord.set('REAL_TIME', 0); 
						}
			*/
					}
				}
			},
			{dataIndex: 'OVER_TIME_YN'     	, width: 40		, locked: false , hidden: true},
			{dataIndex: 'PROG_WORK_CODE'  	, width: 70		, hidden: true},
			{dataIndex: 'PROG_WORK_NAME'  	, width: 100	, locked: false,  style: {textAlign: 'center' }},
			{dataIndex: 'EQU_CODE'       	, width: 90		, locked: false,  style: {textAlign: 'center' }},
			{dataIndex: 'EQU_NAME'       	, width: 150	, locked: false,  style: {textAlign: 'center' }},
			{dataIndex: 'REAL_TIME'       	, width: 100	, locked: false,  align : 'right'},
			{text :'오전1',
				columns:[
							{dataIndex: 'TIME1', xtype: 'checkcolumn',id:'chkTime1', disabledCls : '', width: 70, style: {textAlign: 'center' }, locked: false
							,sortable: false
							,listeners: {
								checkchange: function(CheckColumn, rowIndex, checked, eOpts){
									/**▼cf. 선택 컬럼 수정 여부
									 * eOpts.modified.컬럼명
									 */
									/**▼cf. select 행 데이터 가져오는 법
									* grdRecord.data.WORK_DATE_20210606
									* grdRecord.get('WORK_DATE_20210606') = '데이터' // 바로 set 가능
									*/
										UniAppManager.app.fnCalcSelectedTime(CheckColumn, rowIndex, checked, eOpts);	// 자동 계산 로직
									}
								}
							}
						]
			},
			{text :'오전2',
				columns:[
							{dataIndex: 'TIME2', xtype: 'checkcolumn',id:'chkTime2', disabledCls : '', width: 70, style: {textAlign: 'center'}, locked: false,sortable: false
                            ,listeners: {
								checkchange: function(CheckColumn, rowIndex, checked, eOpts){
										UniAppManager.app.fnCalcSelectedTime(CheckColumn, rowIndex, checked, eOpts);	// 자동 계산 로직
									}
								}
							}
						]
			},
			{text :'오후1',
				columns:[
							{dataIndex: 'TIME3', xtype: 'checkcolumn',id:'chkTime3', disabledCls : '', width: 70, style: {textAlign: 'center'}, locked: false,sortable: false
                            ,listeners: {
								checkchange: function(CheckColumn, rowIndex, checked, eOpts){
										UniAppManager.app.fnCalcSelectedTime(CheckColumn, rowIndex, checked, eOpts);	// 자동 계산 로직
									}
								}
							}
						]
			},
			{text :'오후2',
				columns:[
							{dataIndex: 'TIME4', xtype: 'checkcolumn',id:'chkTime4', disabledCls : '', width: 70, style: {textAlign: 'center'}, locked: false,sortable: false
                            ,listeners: {
								checkchange: function(CheckColumn, rowIndex, checked, eOpts){
										UniAppManager.app.fnCalcSelectedTime(CheckColumn, rowIndex, checked, eOpts);	// 자동 계산 로직
									}
								}
							}
						]
			},
			{text :'야근',
				columns:[
							{dataIndex: 'TIME5', xtype: 'checkcolumn',id:'chkTime5', disabledCls : '', width: 70, style: {textAlign: 'center'}, locked: false,sortable: false
                            ,listeners: {
								checkchange: function(CheckColumn, rowIndex, checked, eOpts){
										UniAppManager.app.fnCalcSelectedTime(CheckColumn, rowIndex, checked, eOpts);	// 자동 계산 로직
									}
								}
							}
						]
			},
			{dataIndex: 'REMARK'		, width: 150	, locked: false,	style: {textAlign: 'center' }},
			{dataIndex: 'OPENING_TIME'	, width: 80		, hidden: true }
		];

		g_dates = createPeriodDate();	 // 기준일 기준 기간 컬럼
		g_dates.forEach(function (value, index, array) {
			columns.push(
				{	text :value.text,
					columns:[
						{ dataIndex: value.name ,text: getDate(value.weekday) ,width: 76 ,align : 'center', sortable: false	// 요일 명칭 가운데 정렬
						 ,renderer: function(value, metaData, record) {
						 		return	 '<div style="text-align:right">' + Ext.util.Format.number(value, '0,000.0') + '</div>';	// 동적컬럼 셀 right 정렬 추가
							}
						}
					]
				}
			);
		});

		return columns;
	};

	function createModelField() {

	var fields = [
		{name: 'SELECT_ALL'		,text: '선택',	type: 'boolean'},
					{name: 'OVER_TIME_YN'		,text: '<t:message code="system.label.product.status" default="초과유무"/>'		,type: 'string'	,comboType:'AU'	,comboCode:'P001'},
					{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'	,type: 'string'},
					{name: 'PROG_WORK_NAME'		,text: '<t:message code="system.label.product.routingname" default="공정명"/>'	,type: 'string'},
					{name: 'EQU_CODE'			,text: '설비'				,type: 'string'},
					{name: 'EQU_NAME'			,text: '설비명'			,type: 'string'},
					{name: 'REAL_TIME'			,text: '실가동시간'			,type: 'float'		,decimalPrecision:2	,format:'0,000.0'	,defaultValue: 0.0},
					{name: 'REMARK'				,text: '비고(특이사항)'		,type: 'string'},
					{name: 'OPENING_TIME'		,text: '시업시간'			,type: 'uniTime'	,format:'H:i'}
			 ];

		var timeStore=  Ext.data.StoreManager.lookup('timeStore');	// 오전, 오후, 야근 시간 공통코드 컬럼
		Ext.each(timeStore.data.items, function(comboData, idx) {
			var hour = (comboData.get('refCode1') / 60);
			fields.push({name: 'TIME'+ (idx + 1)	,text: hour			,type: 'boolean'});

			switch('TIME'+ (idx + 1)){
				case 'TIME1':
				timeValue.time1 = comboData.get('refCode1');
				break;
				case 'TIME2':
				timeValue.time2 = comboData.get('refCode1');
				break;
				case 'TIME3':
				timeValue.time3 = comboData.get('refCode1');
				break;
				case 'TIME4':
				timeValue.time4 = comboData.get('refCode1');
				break;
				case 'TIME5':
				timeValue.time5 = comboData.get('refCode1');
				break;
			}

		});

		g_dates = createPeriodDate(); // 기준일 기준 기간 컬럼
		g_dates.forEach(function (value, index, array) {
			fields.push({name: value.name			,text: value.text	,type: 'float'		,decimalPrecision:2	,format:'0,000.0'	,defaultValue: 0.0});
		});

		return fields;
	};

	function createModelStore() {

		var fields = createModelField();
		var addColumn = createGridColumn();
		var tempModelName = new Date().toString();

		addModel = Unilite.defineModel(tempModelName, {
			fields: fields
		});

		addStore = Unilite.createStore('pbs510ukrvaddStore', {
			model: tempModelName,
			uniOpt: {
				isMaster: true,			// 상위 버튼 연결
				editable: true,		// 수정 모드 사용
				deletable: false,		// 삭제 가능 여부
				useNavi: false			// prev | newxt 버튼 사용
			},
			autoLoad: false,
			proxy: directProxy,
			/**★direct, Unilite.com.data.proxy.UniDirectProxy 랑 이거 차이가 뭔지 알아보기!!!!
			 **/
//				{
//				type: 'direct',
//				api: {
//					read: 'pbs510ukrvService.selectList',
//					syncAll	: 'pbs510ukrvService.saveAll'
//				}
//			},
			loadStoreRecords: function(){
				var param= panelResult.getValues();
				param["PERIOD_PARAM"] = period_param;
				param["STD_DAYOFWEEK"] = BsaCodeInfo.std_dayofweek;
//				console.log(param);
				this.load({
					params: param
				});
			},
			saveStore: function() {

				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);

//				var toCreate = this.getNewRecords();		// 추가
				var toUpdate = this.getUpdatedRecords();	// 수정
//				var toDelete = this.getRemovedRecords();	// 삭제
				var list = [].concat(toUpdate);	// 저장 버튼이니까 CRUD 중 CR 데이터 연결

				console.log("list:", list);
				console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

				//1. 마스터 정보 파라미터 구성
				var paramMaster= panelResult.getValues();	//syncAll 수정 => SearchPanel 사용 할 경우

				Ext.each(list, function(record,index) {
				// 저장 전처리 로직
					record.data.TIME1 = record.data.TIME1 == true ? timeValue.time1 : 0.0;
					record.data.TIME2 = record.data.TIME2 == true ? timeValue.time2 : 0.0;
					record.data.TIME3 = record.data.TIME3 == true ? timeValue.time3 : 0.0;
					record.data.TIME4 = record.data.TIME4 == true ? timeValue.time4 : 0.0;

					record.data.OVER_TIME_YN = record.data.TIME5 == true ? 'Y' : 'N';	// TIME5 값 재설정 전에 확인
					record.data.TIME5 = record.data.TIME5 == true ? timeValue.time5 : 0.0;
				});

				if(inValidRecs.length == 0) {
					config = {
						params: [paramMaster],
						useSavedMessage : true,
						success: function(batch, option) {

							addStore.loadStoreRecords();

							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);
						}
					};
					this.syncAllDirect(config);
				} else {
					var grid = Ext.getCmp('pbs510ukrvGrid');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},	// End of saveStore()
			listeners: {
		          	load: function(store, records, successful, eOpts) {
		          		setColumnText();
		          		dayChange(masterGrid);
		          		console.log(this.records);
		          	},
		          	add: function(store, records, index, eOpts) {
		          	},
		          	update: function(store, record, operation, modifiedFieldNames, eOpts) {
		          	},
		          	remove: function(store, record, index, isMove, eOpts) {
		          	}
			},
			groupField: 'PROG_WORK_NAME'
		});
		addStore.loadStoreRecords();
		masterGrid.setColumnInfo(masterGrid, addColumn, fields);
		masterGrid.reconfigure(addStore, addColumn);	// Re create
	};

	function setColumnText() {
		masterGrid.getColumn("SELECT_ALL").setText("선택");
		masterGrid.getColumn("OVER_TIME_YN").setText("초과유무");
		masterGrid.getColumn("PROG_WORK_CODE").setText("공정코드");
		masterGrid.getColumn("PROG_WORK_NAME").setText("공정명");
		masterGrid.getColumn("EQU_CODE").setText("설비");
		masterGrid.getColumn("EQU_NAME").setText("설비명");
		masterGrid.getColumn("REAL_TIME").setText("실가동시간");

		var timeStore=  Ext.data.StoreManager.lookup('timeStore');	// 오전, 오후, 야근 시간 공통코드 컬럼
		Ext.each(timeStore.data.items, function(comboData, idx) {
			var hour = (comboData.get('refCode1') / 60);	// 분 -> 시간으로 표기
			masterGrid.getColumn("TIME"+ (idx + 1)).setText(hour);
		});

		masterGrid.getColumn("REMARK").setText("비고(특이사항)");
		masterGrid.getColumn("OPENING_TIME").setText("시업시간");
	};

	function getDate(weekDay){	// 다국어처리
		var weekdays=new Array(7);
		weekdays[0]='<t:message code="system.label.product.sunday" default="일"/>';
		weekdays[1]='<t:message code="system.label.product.monday" default="월"/>';
		weekdays[2]='<t:message code="system.label.product.tuesday" default="화"/>';
		weekdays[3]='<t:message code="system.label.product.wednesday" default="수"/>';
		weekdays[4]='<t:message code="system.label.product.Thursday" default="목"/>';
		weekdays[5]='<t:message code="system.label.product.Friday" default="금"/>';
		weekdays[6]='<t:message code="system.label.product.saturday" default="토"/>';
		switch(weekDay){
		case "Sun" :
			weekDay = weekdays[0];
		break;
		case "Mon" :
			weekDay = weekdays[1];
		break;
		case "Tue" :
			weekDay = weekdays[2];
		break;
		case "Wed" :
			weekDay = weekdays[3];
		break;
		case "Thu" :
			weekDay = weekdays[4];
		break;
		case "Fri" :
			weekDay = weekdays[5];
		break;
		case "Sat" :
			weekDay = weekdays[6];
		break;
		}
		return weekDay;
	};

	function dayChange(masterGrid){

		g_dates = createPeriodDate(); // 기준일 기준 기간 컬럼
		g_dates.forEach(function (value, index, array) {

			switch(masterGrid.getColumn(value.name).text){	// ex) value.name = "WORK_DATE_20210602" : 동적컬럼 name
				case "일" :
					masterGrid.getColumn(value.name).setStyle('color', 'red');
				break;

				case "토" :
					masterGrid.getColumn(value.name).setStyle('color', 'blue');
				break;
			}

			var colToday = UniDate.getDbDateStr(masterGrid.getColumn(value.name).dataIndex.substring(10, 18));	// 기준일과 동일한 그리드 컬럼
			if(colToday == value.stdDay){	// ex) value.stdDay = "20210602" : 조회 조건에 설정 된 기준일
				masterGrid.getColumn(value.name).setStyle('background-color', '#62CEDB');	// 기준일 색 변경
			}
		});
    };
    
    /**
     * 로우별 선택, 일괄선택 버튼, 일괄선택해제 버튼 공용
     */
    function checkAll(rowIndex, checked){
    	var selectRecord = addStore.data.items[rowIndex];
		var selectColName = 'WORK_DATE_' + UniDate.getDbDateStr(moment(std_date).format('YYYYMMDD'));
		
		if(checked){
			var timeStore=  Ext.data.StoreManager.lookup('timeStore');	// 오전, 오후, 야근 시간 공통코드 컬럼
			var timeAll = 0.0;
			if(!Ext.isEmpty(timeStore)){
				Ext.each(timeStore.data.items, function(comboData, idx) {
					if(!Ext.isEmpty(comboData)){
						if(comboData.get('value')!='T5'){ //야근 제외
							if((typeof parseFloat(comboData.get('refCode1'))) == "number"){
								if(!isNaN(parseFloat(comboData.get('refCode1')))){
									timeAll += (comboData.get('refCode1') / 60);
								}
							}
						}
					}
				});
			}
			selectRecord.set('TIME1',true);
			selectRecord.set('TIME2',true);
			selectRecord.set('TIME3',true);
			selectRecord.set('TIME4',true);
//			selectRecord.set('TIME5',true); //야근 제외
			
			selectRecord.set('SELECT_ALL',true);
			
			// 선택 된 기준일 가동시간 계산
			selectRecord.set(selectColName, timeAll.toFixed(2));
			selectRecord.set('REAL_TIME', timeAll.toFixed(2)); 
		}else{
			selectRecord.set('TIME1',false);
			selectRecord.set('TIME2',false);
			selectRecord.set('TIME3',false);
			selectRecord.set('TIME4',false);
//			selectRecord.set('TIME5',false); //야근 제외
			
			selectRecord.set('SELECT_ALL',false);
			
			selectRecord.set(selectColName, 0);
			selectRecord.set('REAL_TIME', 0); 
		}
    }
    
}
</script>
