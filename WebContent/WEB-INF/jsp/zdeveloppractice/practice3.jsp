<%--
'   프로그램명 : 거래처별 입고금액 (practice3)
'   작   성   자 : 시너지시스템즈개발실
'   작   성   일 : 2020.03.12
'   최종수정자 :
'   최종수정일 :
'   버	  전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="practice3" >
	<t:ExtComboStore comboType="BOR120" pgmId="practice3"/>		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>			<!-- 단위-->
	<t:ExtComboStore comboType="AU" comboCode="B131"/>			<!-- 예/아니오-->  <%-- 테이블에서 combo값 가져올 때는 store 사용: controller에서 데이터 만들어서 페이지 상단에서 받아서 사용 --%>

	
	

</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >


function appMain() {
	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		//왼쪽
		title		: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: true,
		listeners	: {							//리스너: 이벤트 핸들러
			collapse: function () {
				panelResult.show();			//왼쪽 검색 조건이 닫히면 상단의 검색패널 열림
			},
			expand: function() {
				panelResult.hide();			// 왼쪽 검색 조건이 열리면 상단의 검색패널 닫힘
			}
		},
		items: [{
			title		: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
					fieldLabel: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'ISSUE_REQ_DATE_FR',					// 시작 날짜
					endFieldName: 'ISSUE_REQ_DATE_TO',						// 끝나는 날짜
					startDate: UniDate.get('startOfMonth'),					// 시작 날짜는 이번달 1일
					endDate: UniDate.get('today'),							// 끝나는 날짜는 현재일
					allowBlank	: false,									// 필수 입력사항
					onStartDateChange: function(field, newValue, oldValue, eOpts) {		// 왼쪽 검색조건 시작 날짜가 바뀌면
						if(panelResult) {
							panelResult.setValue('ISSUE_REQ_DATE_FR',newValue);			// 상단 검색 날짜 시작 날짜 값 변경
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();

						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {		// 왼쪽 검색조건 끝나는 날짜가 바뀌면
						if(panelResult) {
							panelResult.setValue('ISSUE_REQ_DATE_TO',newValue);			// 상단 검색 날짜 끝나는 값 변경
							//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
						}
					}
				},{
				fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S002',			//운영자 공동코드 등록 -> 종합코드에서 해당 코드 기입
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
//			autoPopup		: true,					//등록에서 사용 --필수 입력시
			validateBlank	: false,				//조회에서 사용 (부분조회 like)
			listeners		: {
				onValueFieldChange: function(field, newValue){				//validateBlank	: false일 때 사용 -부분 값
					panelResult.setValue('CUSTOM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('CUSTOM_NAME', newValue);
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){				//validateBlank	: false일 때 사용
					panelResult.setValue('CUSTOM_NAME', newValue);
//				},
//				onSelected: {												//autoPopup		: true,일 때 사용
//					fn: function(records, type) {
//						panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
//						panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
//					},
//					scope: this
//				},
//				onClear: function(type) {									//autoPopup		: true,일 때 사용
//					panelResult.setValue('CUSTOM_CODE', '');
//					panelResult.setValue('CUSTOM_NAME', '');
				}
			}
		}),Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
//			autoPopup		: true,
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelResult.setValue('ITEM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('ITEM_NAME', newValue);
						panelResult.setValue('ITEM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
					panelResult.setValue('ITEM_NAME', newValue);
//				},
//				onSelected: {
//					fn: function(records, type) {
//						panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
//						panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
//					},
//					scope: this
//				},
//				onClear: function(type) {
//					panelResult.setValue('CUSTOM_CODE', '');
//					panelResult.setValue('CUSTOM_NAME', '');
				}
			}
		  })]
	   }]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{		//상단
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 3},					//columns: 한줄에 정렬되는 항목 수
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false, 				// 필수 입력사항
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ISSUE_REQ_DATE_FR',
			endFieldName: 'ISSUE_REQ_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank	: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ISSUE_REQ_DATE_FR',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ISSUE_REQ_DATE_TO',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
				}
			}
		},{
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
			},Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
//			autoPopup		: true,						//등록에서 사용
			validateBlank	: false,					//조회에서 사용
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);
					if(Ext.isEmpty(newValue)) { 
						panelSearch.setValue('CUSTOM_NAME', newValue);
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);
//				},
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
//						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
//					},
//					scope: this
//				},
//				onClear: function(type) {
//					panelSearch.setValue('CUSTOM_CODE', '');
//					panelSearch.setValue('CUSTOM_NAME', '');
				}
			}
		}), Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
//			autoPopup		: true,
			validateBlank	: false,				// 부분 입력 조회
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('ITEM_NAME', newValue);
						panelResult.setValue('ITEM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
//				},
//				onSelected: {
//					fn: function(records, type) {
//						panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
//						panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
//					},
//					scope: this
//				},
//				onClear: function(type) {
//					panelResult.setValue('CUSTOM_CODE', '');
//					panelResult.setValue('CUSTOM_NAME', '');
				}
			}
			}),{
			xtype	: 'button',
			text	: '출력버튼',
			handler	: function() {
				//버튼 눌렀을 때 이벤트	
				var param			= panelResult.getValues();
				param.PGM_ID		= 'practice3';
				param.MAIN_CODE		= 'Z012';

				var win = Ext.create('widget.ClipReport', {
					url			: CPATH+'/base/practiceClip3.do',
					prgID		: 'practice3',
					extParam	: param,
					submitType	: 'POST'
				});
				win.center();
				win.show();
			}
		}]
	});



	/** Model 정의 
	 * @type
	 */
	Unilite.defineModel('practice3Model', {
		//'<t:message code="system.label.sales.seq" default="순번"/>'  다국어 처리
		fields: [
		    {name: 'ISSUE_REQ_NUM'	,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'				,type: 'string'},
			{name: 'ISSUE_REQ_SEQ'	,text: '<t:message code="system.label.sales.seq" default="순번"/>'								,type: 'integer'},
			{name: 'ISSUE_REQ_DATE'	,text: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'				,type: 'uniDate'},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'							,type: 'string'},
			{name: 'CUSTOM_NAME'    ,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'    				,type: 'string'},
	    	{name: 'ITEM_CODE'    	,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'    					,type: 'string'},
	    	{name: 'ITEM_NAME'      ,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'    					,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.purchase.spec" default="규격"/>'    						,type: 'string'},
			{name: 'ORDER_UNIT'		,text: '<t:message code="system.label.sales.unit" default="단위"/>'								,type: 'string'},
	    	{name: 'TRANS_RATE'		,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'						,type: 'uniQty'},
	    	{name: 'MONEY_UNIT'		,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'					,type: 'string'},	
	    	{name: 'ISSUE_REQ_QTY'	,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'				,type: 'uniQty'},		
	    	{name: 'ORDER_NUM'		,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'							,type: 'string'},
	    	{name: 'SER_NO'			,text:'<t:message code="system.label.sales.soseq" default="수주순번"/>'							,type: 'string'},
	    	{name: 'ORDER_Q'		,text: '<t:message code="system.label.sales.soqty" default="수주량"/>'							,type: 'uniQty'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('practice3MasterStore1', {
		model	: 'practice3Model',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'zDevelopPracticeService.selectList3'				//서비스 호출
			}
		},
		loadStoreRecords: function(){									//조회에서 사용
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});	
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {								//추가
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {		//수정
			},
			remove: function(store, record, index, isMove, eOpts) {						//삭제
			}
		}
	});


	/** Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('practice3Grid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: false,
			onLoadSelectFirst	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ 
			{id: 'masterGridSubTotal1'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},			//소계 기능
			{id: 'masterGridTotal1'		, ftype: 'uniSummary'			, showSummaryRow: false}			//총계 기능(디폴트: 그리드 하단에 표시)
		],
		selModel: 'rowmodel',
		tbar	: [{									//그리드에 버튼기능 필요할 때 사용: 출력, 다른 프로그램으로 링크 시 사용
			itemId	: 'reqBtn',
			text	: '그리드 버튼',
			width	: 170,
			handler	: function() {
				//버튼 눌렀을 때 이벤트	
				var param			= panelResult.getValues();
				param.PGM_ID		= 'practice3';
				param.MAIN_CODE		= 'Z012';

				var win = Ext.create('widget.ClipReport', {
					url			: CPATH+'/base/practiceClip3.do',
					prgID		: 'practice3',
					extParam	: param,
					submitType	: 'POST'
				});
				win.center();
				win.show();
			}
		}],
		columns	: [						
			{dataIndex: 'ISSUE_REQ_NUM'		, width: 110},
			{dataIndex: 'ISSUE_REQ_SEQ'	 	, width: 80},
			{dataIndex: 'ISSUE_REQ_DATE'	 	, width: 110},
			{dataIndex: 'CUSTOM_CODE'		, width: 100, align: 'center'},
			{dataIndex: 'CUSTOM_NAME'     	, width: 100},
			{dataIndex: 'ITEM_CODE'    		, width: 100},
			{dataIndex: 'ITEM_NAME'      		, width: 100},
			{dataIndex: 'SPEC'			, width: 100},
			{dataIndex: 'ORDER_UNIT'			, width: 100},
			{dataIndex: 'TRANS_RATE'				, width: 100},
			{dataIndex: 'MONEY_UNIT'			, width: 100},
			{dataIndex: 'ISSUE_REQ_QTY'		, width: 100},
			{dataIndex: 'ORDER_NUM'			, width: 100},
			{dataIndex: 'SER_NO'				, width: 100},
			{dataIndex: 'ORDER_Q'			, width: 100}
		],
		listeners:{
			onGridDblClick:function(grid, record, cellIndex, colName) {					//그리드 더블클릭 이벤트: 링크 등에 사용
			}
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
//				var cls = '';
//				if(record.get('TEMP_GUBUN1') == '발주'){
//					if(record.get('GUBUN1') == '구분계'){
//						cls = 'x-change-cell_row2';
//					}
//				} else if(record.get('TEMP_GUBUN1') == '입고'){
//					if(record.get('GUBUN1') == '구분계'){
//						cls = 'x-change-cell_row3';
//					}
//				}
//				return cls;
			}
		}
	});



	Unilite.Main({							//전체 화면 배치 정의: 버튼 배치 확인
		id			: 'practice3App',
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
		fnInitBinding: function() {							//화면 열렸을 때 초기설정
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('FR_DATE'		, UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE'		, UniDate.get('today'));
			panelSearch.getField('CLOSE_YN', '');
			
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('FR_DATE'		, UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE'		, UniDate.get('today'));
			panelResult.getField('CLOSE_YN', '');

			//초기화 시 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
			// UniAppManager - 버튼
			UniAppManager.setToolbarButtons('reset', true);		//신규 버튼 활성화
			UniAppManager.setToolbarButtons('print', true);		//프린트 버튼 활성화
		},
		onQueryButtonDown: function() {							//조회버튼
			if(!this.isValidSearchForm()){						//필수조건 체크
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {						   //신규버튼
			panelSearch.clearForm();						   //panel 필드 초기화: 공백 값으로 변경
			panelResult.clearForm();						   //panel 필드 초기화: 공백 값으로 변경
			masterGrid.getStore().loadData({});				   //그리드 초기화: 빈 데이터 load
			this.fnInitBinding();							   //초기화 값 세팅
		},
		onPrintButtonDown: function() {							//프린트(출력)
			var param			= panelResult.getValues();		//출력에 필요한 parameter 정의
			param.PGM_ID		= 'practice3';					//parameter에 추가로 필요한 데이터 정의: PGM_ID는 필수 - 공통코드에서 해당 출력에 대한 설정 읽어옴
			param.MAIN_CODE		= 'Z012';						//parameter에 추가로 필요한 데이터 정의: MAIN_CODE는 필수 - 공통코드에서 해당 출력에 대한 설정 읽어옴

			var win = Ext.create('widget.ClipReport', {
				url			: CPATH+'/base/practiceClip3.do',	//출력 시 호출할 url 정의
				prgID		: 'practice3',
				extParam	: param,
				submitType	: 'POST'							//대용량 데이터 통신의 경우, post 방식으로 호출: 기본값으로 사용하면 됨
			});
			win.center();
			win.show();
		}
	});
	
//	/*  panel 필드 */
//	panelResult.getValue('필드명');			//panelResult에 있는 필드의 vale를 가져옴
//	panelResult.setValue('필드명', 값);		//panelResult에 있는 필드에 값을 입력함
//	
//	/* grid 컬럼 */
//	detailGrid.get('필드명');					//grid에 있는 컬럼의 vale를 가져옴
//	detailGrid.set('필드명', 값);				//grid에 있는 컬럼에 값을 입력
};
</script>