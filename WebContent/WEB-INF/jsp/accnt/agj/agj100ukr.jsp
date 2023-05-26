<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agj100ukr">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="A" comboCode="A011"/>
	<t:ExtComboStore items="${comboInputPath}" storeId="comboInputPath" />
	<t:ExtComboStore comboType="AU" comboCode="A005"/>
	<t:ExtComboStore comboType="AU" comboCode="A022"/>	<!-- 매입증빙유형-->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>
	<t:ExtComboStore comboType="AU" comboCode="A003"/>
	<t:ExtComboStore comboType="AU" comboCode="A022"/>
	<t:ExtComboStore comboType="AU" comboCode="A014"/>	<!--승인상태-->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>
	<t:ExtComboStore comboType="AU" comboCode="A058"/>
	<t:ExtComboStore comboType="AU" comboCode="A149"/>
	<t:ExtComboStore comboType="AU" comboCode="A016"/>
	<t:ExtComboStore comboType="AU" comboCode="A012"/>
	<t:ExtComboStore comboType="AU" comboCode="A070"/>
	<t:ExtComboStore comboType="AU" comboCode="A127"/>	<!--분개구분-->
	<t:ExtComboStore comboType="AU" comboCode="A084"/>
</t:appConfig>

<script type="text/javascript" >
var detailWin;
var csINPUT_DIVI	= "1";		// 1:결의전표/2:결의전표(전표번호별)
var csSLIP_TYPE		= "2";		// 1:회계전표/2:결의전표
var csSLIP_TYPE_NAME= "결의전표";
var csINPUT_PATH	= 'Z1';
var gsInputPath, gsInputDivi, gsDraftYN	;
var postitWindow;				// 각주팝업
var creditNoWin;				// 신용카드번호 & 현금영수증 팝업
var comCodeWin ;				// A070 증빙유형팝업
var creditWIn;					// 신용카드팝업
var printWin;					//전표출력팝업
var foreignWindow;				//외화금액입력
var gsBankBookNum ,gsBankName;
var tab;
var taxWindow;					//부가세 정보 팝업
var autoAccntPopupWin;  		//자동분개팝업
var asstInfoWindow;
var addLoading = false;			// 전표번호 생성 flag
var slipNumMessageWin;

function appMain() {
	var gsSlipNum 		=""; // 링크로 넘어오는 Slip_NUM
	var gsProcessPgmId	=""; // Store 에서 링크로 넘어온 Data 값 체크 하기 위해 전역변수 사용

var baseInfo = {
	gsLocalMoney		: '${gsLocalMoney}',
	gsBillDivCode		: '${gsBillDivCode}',
	gsPendYn			: '${gsPendYn}',
	gsChargePNumb		: '${gsChargePNumb}',
	gsChargePName		: '${gsChargePName}',
	gbAutoMappingA6		: '${gbAutoMappingA6}',	// '결의전표 관리항목 사번에 로그인정보 자동매핑함
	gsDivChangeYN		: '${gsDivChangeYN}',		// '귀속부서 입력시 사업장 자동 변경 사용여부
	gsRemarkCopy		: '${gsRemarkCopy}',		// '전표_적요 copy방식_적요 빈 값 상태에서 Enter칠 때 copy
	gsAmtEnter			: '${gsAmtEnter}',			// '전표_금액이 0이면 마지막 행에서 Enter안넘어감(부가세 제외)
	gsAmtPoint			: ${gsAmtPoint},			// 외화금액 format
	reasonGbn			: '${reasonGbn}',
	gsChargeDivi		: '${gsChargeDivi}',			// 1:회계부서, 2:현업부서
	customCodeCopy		: '${customCodeCopy}',
	customCodeAutoPopup	: '${customCodeAutoPopup}' == 'Y' ? true : false,
	profitEarnAccnt		: '${profitEarnAccnt}',
	profitLossAccnt		: '${profitLossAccnt}',
	gsDeptCode			: '${gsDeptCode}',
	gsDeptName			: '${gsDeptName}',
	inDeptCodeBlankYN   : '${inDeptCodeBlankYN}' // 귀속부서 팝업창 오픈시 검색어 공백 처리(A165, 75)
}

	/**
	 * 일반전표 Store 정의(Service 정의)
	 * @type
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'agj100ukrService.selectList',
			update	: 'agj100ukrService.update',
			create	: 'agj100ukrService.insert',
			destroy	: 'agj100ukrService.delete',
			syncAll	: 'agj100ukrService.saveAll'
		}
	});

	<%@include file="./accntGridConfig.jsp" %>
	var directMasterStore1 = Unilite.createStore('agj100ukrMasterStore1',getStoreConfig('agj100ukrGrid1','agj100ukrDetailForm1'));

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title		: '검색조건',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items		: [{
			title		: '기본정보',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel		: '전표일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'AC_DATE_FR',
				endFieldName	: 'AC_DATE_TO',
				startDate		: UniDate.get('today'),// '20130801', //
				endDate			: UniDate.get('today'),// '20130808', //
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('AC_DATE_TO', newValue);
					}
					if(panelResult) {
						panelResult.setValue('AC_DATE_FR', newValue);
						panelResult.setValue('AC_DATE_TO', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
//					if(panelSearch && Ext.isDate(newValue)) {
//						if(UniDate.extFormatMonth(panelSearch.getValue('AC_DATE_FR')) != UniDate.extFormatMonth(newValue)) {
//							alert('동일한 월만 조회가 가능합니다.');
//							field.setValue(oldValue)
//							return ;
//						}
//					}
					if(panelResult) {
						panelResult.setValue('AC_DATE_TO', newValue);
					}
				}
			},{
				fieldLabel	: '입력경로',
				name		: 'INPUT_PATH',
				xtype		: 'uniCombobox' ,
				store		: Ext.data.StoreManager.lookup('comboInputPath'),
				value		: 'Z1',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INPUT_PATH', newValue);
						UniAppManager.app.setEditableGrid( newValue, true);
					}
				}
			},{
				fieldLabel	: '사업장',
				name		: 'IN_DIV_CODE',
				xtype		: 'uniCombobox' ,
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('IN_DIV_CODE', newValue);
					}
				}
			},{
				xtype		: 'container',
				defaultType	: 'uniTextfield',
				layout		: {type:'hbox', align:'stretch'},
				items		: [{
					fieldLabel	:'결의부서',
					name		: 'IN_DEPT_CODE',
					readOnly	: true,
					value		: baseInfo.gsDeptCode,
					width		: 150
				},{
					fieldLabel	: '결의부서명',
					name		: 'IN_DEPT_NAME',
					value		: baseInfo.gsDeptName,
					readOnly	: true,
					hideLabel	: true
				}]
			},
			Unilite.popup('ACCNT_PRSN', {
				fieldLabel		: '입력자ID',
				valueFieldName	: 'CHARGE_CODE',
				textFieldName	: 'CHARGE_NAME',
				textFieldWidth	: 150,
				readOnly		: true,
				showValue		: false
			}),{
				fieldLabel	: '승인상태',
				name		: 'AP_STS' ,
				xtype		: 'uniCombobox' ,
				comboType	: 'AU',
				comboCode	: 'A014' ,
				value		: '1',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AP_STS', newValue);
					},
					specialkey: function(elm, e){
						lastFieldSpacialKey(elm, e)
					}
				}
			},{
				fieldLabel	: '전표번호',
				name		: 'EX_NUM' ,
				hidden		: false
			},/*{
				fieldLabel	: '회계부서',
				name		: 'IN_DEPT_CODE' ,
				value		: UserInfo.deptCode,
				hidden		: true
			},*/{
				fieldLabel	: '회계담당자',
				name		: 'AUTHORITY' ,
				value		: baseInfo.gsChargeDivi,
				hidden		: true
			}]
		}]
	});	// end panelSearch

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel		: '전표일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'AC_DATE_FR',
			endFieldName	: 'AC_DATE_TO',
			startDate		: UniDate.get('today'),//'20130801', //
			endDate			: UniDate.get('today'),//'20130831', //
			width			: 350,
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelResult.setValue('AC_DATE_TO', newValue);
				}
				if(panelSearch) {
					panelSearch.setValue('AC_DATE_FR', newValue);
					panelSearch.setValue('AC_DATE_TO', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
//				if(panelResult && Ext.isDate(newValue)) {
//					if(UniDate.extFormatMonth(panelResult.getValue('AC_DATE_FR')) != UniDate.extFormatMonth(newValue)) {
//						alert('동일한 월만 조회가 가능합니다.');
//						field.setValue(oldValue)
//						return ;
//					}
//				}
				if(panelSearch) {
					panelSearch.setValue('AC_DATE_TO', newValue);
				}
			}
		},{
			fieldLabel	: '입력경로',
			name		: 'INPUT_PATH',
			xtype		: 'uniCombobox' ,
			store		: Ext.data.StoreManager.lookup('comboInputPath'),
			value		:'Z1',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INPUT_PATH', newValue);
					UniAppManager.app.setEditableGrid( newValue, true);
				}
			}
		},{
			fieldLabel	: '사업장',
			name		: 'IN_DIV_CODE',
			xtype		: 'uniCombobox' ,
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('IN_DIV_CODE', newValue);
				}
			}
		},{
			xtype		: 'container',
			defaultType	: 'uniTextfield',
			layout		: {type:'hbox', align:'stretch'},
			items		: [{
				fieldLabel	: '결의부서',
				name		: 'IN_DEPT_CODE',
				readOnly	: true,
				//value		: UserInfo.deptCode,
				value		: baseInfo.gsDeptCode,
				//
				width		: 150
			},{
				fieldLabel	: '결의부서명',
				name		: 'IN_DEPT_NAME',
				//value		: UserInfo.deptName,
				value		: baseInfo.gsDeptName,
				readOnly	: true,
				hideLabel	: true
			}]
		},
		Unilite.popup('ACCNT_PRSN', {
			fieldLabel		: '입력자',
			valueFieldName	: 'CHARGE_CODE',
			textFieldName	: 'CHARGE_NAME',
			textFieldWidth	: 150,
			readOnly		: true,
			showValue		: false
		}),{
			fieldLabel	: '승인상태',
			name		: 'AP_STS' ,
			xtype		: 'uniCombobox' ,
			comboType	: 'AU',
			comboCode	: 'A014' ,
			value		:'1',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AP_STS', newValue);
				},
				specialkey: function(elm, e){
					lastFieldSpacialKey(elm, e)
				}
			}
		}/*,{
			fieldLabel: '회계부서',
			name: 'IN_DEPT_CODE' ,
			value:UserInfo.deptCode,
			hidden:true
		}*/,{
			fieldLabel: '회계담당자',
			name: 'AUTHORITY' ,
			value:baseInfo.gsChargeDivi,
			hidden:true
		}]
	});

	function lastFieldSpacialKey(elm, e) {
		if( e.getKey() == Ext.event.Event.ENTER) {
			if(elm.isExpanded) {
				var picker = elm.getPicker();
				if(picker) {
					var view = picker.selectionModel.view;
					if(view && view.highlightItem) {
						picker.select(view.highlightItem);
					}
				}
			}else {
				var grid = UniAppManager.app.getActiveGrid();
				var record = grid.getStore().getAt(0);
				if(record) {
					e.stopEvent();
					grid.editingPlugin.startEdit(record,grid.getColumn('AC_DAY'))
				}else {
					UniAppManager.app.onNewDataButtonDown();
				}
			}
		}
	}

	/**
	 * 일발전표 Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('agj100ukrGrid1', getGridConfig(directMasterStore1,'agj100ukrGrid1','agj100ukrDetailForm1', 0.65, true,'1'));
	var detailForm1 = Unilite.createForm('agj100ukrDetailForm1',  getAcFormConfig('agj100ukrDetailForm1',masterGrid1 ));

	// 차대변 구분 전표
	<%@include file="./agjSlip.jsp" %>

	/**
	 * 매입매출전표 Store
	 */
	var activeGrid = 'agj100ukrSalesGrid'
	var directMasterStore2 = Unilite.createStore('agj100ukrMasterStore2',getStoreConfig('agj100ukrGrid2','agj100ukrSaleDetailForm'));

	/**
	 * 매입매출전표 Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid2 = Unilite.createGrid('agj100ukrGrid2', getGridConfig(directMasterStore2, 'agj100ukrGrid2','agj100ukrSaleDetailForm', 0.25, false,'1'));
	var saleDetailForm = Unilite.createForm('agj100ukrSaleDetailForm',  getAcFormConfig('agj100ukrSaleDetailForm',masterGrid2 ));

	/**
	 * 매출/매입 전표 Detail 정보 모델
	 */
	Unilite.defineModel('agj100ukrSaleModel', {
		// pkGen : user, system(default)
		fields: [
				 {name: 'AC_DAY'			,text:'일자'			,type : 'string', allowBlank:false}
				,{name: 'PUB_DATE'			,text:'계산서일'		,type : 'uniDate', allowBlank:false}
				,{name: 'SALE_DIVI'			,text:'매입/매출'		,type : 'string', allowBlank:false,comboType: 'AU',	comboCode: 'A003'}
				,{name: 'BUSI_TYPE'		,text:'거래유형'			,type : 'string', allowBlank:false,comboType: 'AU',	comboCode: 'A012'}
				,{name: 'CUSTOM_CODE'		,text:'거래처'			,type : 'string', allowBlank:false}
				,{name: 'CUSTOM_NAME'		,text:'거래처명'		,type : 'string'}
				,{name: 'PROOF_KIND_NM'		,text:'증빙유형명'		,type : 'string'}
				,{name: 'PROOF_KIND'		,text:'증빙유형'		,type : 'string', allowBlank:false, comboType:'AU', comboCode:'A022'}

				,{name: 'SUPPLY_AMT_I'		,text:'공급가액'		,type : 'uniPrice', defaultValue:0}
				,{name: 'TAX_AMT_I'			,text:'세액'			,type : 'uniPrice', defaultValue:0}
				,{name: 'REMARK'			,text:'적요'			,type : 'string'}
				//,{name: 'DEPT_NAME'			,text:'귀속부서'		,type : 'string', allowBlank:false, defaultValue: UserInfo.deptName}
				,{name: 'DEPT_NAME'			,text:'귀속부서'		,type : 'string', allowBlank:false, defaultValue: baseInfo.gsDeptName}
				,{name: 'DIV_CODE'			,text:'사업장'			,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode}
				,{name: 'OLD_AC_DATE' 		,text:'OLD_AC_DATE' 	,type : 'uniDate'}
				,{name: 'OLD_SLIP_NUM' 		,text:'OLD_SLIP_NUM' 	,type : 'int'}

				,{name: 'OLD_PUB_DATE' ,text:'' ,type : 'uniDate'}
				,{name: 'OLD_PUB_NUM' ,text:'' ,type : 'int'}
				,{name: 'AC_DATE'			,text:'회계전표일자'	,type : 'uniDate', allowBlank:false}
				,{name: 'SLIP_NUM'			,text:'전표번호'		,type : 'int'}
				,{name: 'PUB_NUM'			,text:'계산서일자'		,type : 'int'}
				,{name: 'AP_CHARGE_NAME'	,text:'승인담당자코드'	,type : 'string'}
				,{name: 'IN_DIV_CODE'		,text:'결의사업장코드'	,type : 'string', defaultValue: UserInfo.divCode}
				,{name: 'IN_DEPT_CODE'		,text:'결의부서코드'	,type : 'string', defaultValue: baseInfo.gsDeptCode}
				,{name: 'IN_DEPT_NAME'		,text:'결의부서명'		,type : 'string', defaultValue: baseInfo.gsDeptName}
				,{name: 'DEPT_CODE'			,text:'귀속부서코드'	,type : 'string', defaultValue: baseInfo.gsDeptCode}
				
				//,{name: 'IN_DEPT_CODE'		,text:'결의부서코드'	,type : 'string', defaultValue: UserInfo.deptCode}
				//,{name: 'IN_DEPT_NAME'		,text:'결의부서명'		,type : 'string', defaultValue: UserInfo.deptName}
				//,{name: 'DEPT_CODE'			,text:'귀속부서코드'	,type : 'string', defaultValue: UserInfo.deptCode}
				
				,{name: 'BILL_DIV_CODE'		,text:'신고사업장코드'	,type : 'string', defaultValue: baseInfo.gsBillDivCode}
				,{name: 'CREDIT_CODE'		,text:'신용카드사코드'	,type : 'string'}
				,{name: 'REASON_CODE'		,text:'불공제사유코드'	,type : 'string'}
				,{name: 'CREDIT_NUM'		,text:'카드번호/현금영수증(DB)'	,type : 'string', editable:false}
				,{name: 'CREDIT_NUM_EXPOS'  ,text:'카드번호/현금영수증'	,type : 'string', editable:false, defaultValue:'***************'}
				,{name: 'CREDIT_NUM_MASK'   ,text:'카드번호/현금영수증'	,type : 'string', editable:false, defaultValue:'***************'}
				,{name: 'AP_STS'			,text:'승인여부'		,type : 'string'}
				,{name: 'COMP_CODE'			,text:'법인코드'		,type : 'string', defaultValue: UserInfo.compCode}
				,{name: 'DRAFT_YN'			,text:'DRAFT_YN'		,type : 'string'}
				,{name: 'ASST_SUPPLY_AMT_I' ,text:'고정자산과표'	   ,type : 'uniPrice'} 
				,{name: 'ASST_TAX_AMT_I'	,text:'고정자산세액'		,type : 'uniPrice'} 
				,{name: 'ASST_DIVI'		 ,text:'자산구분'			,type : 'string'		,comboType:'AU', comboCode:'A084'} 
		]
	})

	/**
	 * 매입매출전표 Store
	 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'agj100ukrService.selectCustomList',
			update : 'agj100ukrService.update',
			create : 'agj100ukrService.insert',
			destroy:'agj100ukrService.delete',
			syncAll:'agj100ukrService.saveAll'
		}
	});
	var salesStore = Unilite.createStore('agj100ukrSalesStore',{
		model: 'agj100ukrSaleModel',
		autoLoad: false,
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : true			// prev | next 버튼 사용
		},
		proxy: directProxy2  // proxy

		// Store 관련 BL 로직
		// 검색 조건을 통해 DB에서 데이타 읽어 오기
		,loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
		// 수정/추가/삭제된 내용 DB에 적용 하기
		,saveStore : function(config) {
			
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 ) {
				this.syncAll(config);
			}else {
				salesGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			update:function(store, record, operation, modifiedFieldNames, details, eOpts ) {
				var acDay = record.get('AC_DAY');
				var slipNum = record.get('SLIP_NUM');
				var grid = UniAppManager.app.getActiveGrid();
				var accntStore = grid.getStore();
				Ext.each(accntStore.data.items, function(rec, idx){
					if(rec.get('AC_DAY') == acDay && rec.get('SLIP_NUM') == slipNum) {
						if(rec.set("OPR_FLAG"),"U");
					}
				})
			}
		}
	});

	/**
	 * 매출/매입 전표 Detail Grid 정의(Grid Panel)
	 * @type
	 */
	var salesGrid = Unilite.createGrid('agj100ukrSalesGrid', {
		flex: 0.45,
		itemId: 'agj100ukrSalesGrid',
		uniOpt:{
			expandLastColumn: false,
			useMultipleSorting: false,
			useNavigationModel:false,
			nonTextSelectedColumns:['REMARK']
		},
		border:true,
		store: salesStore,
		features:  [ 
			{id: 'salesGridSubTotal', ftype: 'uniGroupingsummary'	, showSummaryRow: true },
			{id: 'salesGridTotal'	, ftype: 'uniSummary'		, showSummaryRow: true}
		],
		columns:[
			 { dataIndex: 'AC_DAY',  width: 50 , align:'center'}
			,{ dataIndex: 'PUB_DATE',  width: 100 }
			,{ dataIndex: 'SALE_DIVI',  width: 100 }
			,{ dataIndex: 'BUSI_TYPE',  width: 100 ,editor:{
						xtype:'uniCombobox',
						store:Ext.data.StoreManager.lookup('CBS_AU_A012'),
						listeners:{
							beforequery:function(queryPlan, value) {
								this.store.clearFilter();
								var saleDivi = salesGrid.uniOpt.currentRecord.get('SALE_DIVI') ;
								this.store.filterBy(function(record){return record.get('refCode1') == saleDivi},this)
							}
						}
					}
			}
			,{ dataIndex: 'CUSTOM_CODE'		,width: 80,
				'editor' : Unilite.popup('CUST_G',{
					textFieldName:'CUSTOM_CODE',
					DBtextFieldName:'CUSTOM_CODE',
					extParam:{"CUSTOM_TYPE":['1','2','3']},
					autoPopup:true,
					listeners: {
						'onSelected':  function(records, type  ){
								var grdRecord = salesGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);

								gsBankBookNum = records[0]['BANKBOOK_NUM'];
								gsBankName	= records[0]['BANK_NAME'];

								UniAppManager.app.fnGetProofKind(grdRecord,  records[0]['BILL_TYPE']);
						},
						'onClear':  function( type  ){
								var grdRecord = salesGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_NAME','');
								grdRecord.set('CUSTOM_CODE','');
								gsBankBookNum = '';
								gsBankName	= '';
						}
					} // listeners
				})
			 }
			,{ dataIndex: 'CUSTOM_NAME'		,width: 120 ,
				'editor' : Unilite.popup('CUST_G',{
					textFieldName:'CUSTOM_NAME',
					extParam:{"CUSTOM_TYPE":['1','2','3']},
					autoPopup:true,
					listeners: {
						'onSelected':  function(records, type  ){
								var grdRecord = salesGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);

								gsBankBookNum = records[0]['BANKBOOK_NUM'];
								gsBankName	= records[0]['BANK_NAME'];

								UniAppManager.app.fnGetProofKind(grdRecord,  records[0]['BILL_TYPE']);

						},
						'onClear':  function( type  ){
								var grdRecord = salesGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_NAME','');
								grdRecord.set('CUSTOM_CODE','');
								gsBankBookNum = '';
								gsBankName	= '';

						}
					} // listeners
				})
			 }
			,{ dataIndex: 'PROOF_KIND',  width: 110
				,editor:{
						xtype:'uniCombobox',
						store:Ext.data.StoreManager.lookup('CBS_AU_A022'),
						listeners:{
							beforequery:function(queryPlan, value) {
								this.store.clearFilter();
								var saleDivi = salesGrid.uniOpt.currentRecord.get('SALE_DIVI') ;
								this.store.filterBy(function(record){return record.get('refCode3') == saleDivi},this)
							}
						}
					}
			}
			,{ dataIndex: 'CREDIT_NUM_MASK',  width: 130 }

			,{ dataIndex: 'SUPPLY_AMT_I',  width: 100 ,summaryType:'sum'}
			,{ dataIndex: 'TAX_AMT_I',  width: 80 ,summaryType:'sum'}
			,{ dataIndex: 'REMARK',  width: 150 ,
				editor:Unilite.popup('REMARK_G',{
									textFieldName:'REMARK',
									validateBlank:false,
									autoPopup:false,
									listeners:{
										'onSelected':function(records, type) {
											var selectedRec = salesGrid.getSelectedRecord();// masterGrid1.uniOpt.currentRecord;
											selectedRec.set('REMARK', records[0].REMARK_NAME);
										},
										'onClear':function(type) {
											var selectedRec = salesGrid.getSelectedRecord();
										}

									}

								})}
			,{ dataIndex: 'DEPT_NAME',  width: 100 ,
				editor:Unilite.popup('DEPT_G',{
									showValue:false,
									autoPopup:true,
									listeners:{
										'onSelected':function(records, type) {

											var selectedRec = salesGrid.getSelectedRecord();// masterGrid1.uniOpt.currentRecord;
											selectedRec.set('DEPT_NAME', records[0].TREE_NAME);
											selectedRec.set('DEPT_CODE', records[0].TREE_CODE);
											selectedRec.set('DIV_CODE', records[0].DIV_CODE);
											selectedRec.set('BILL_DIV_CODE', records[0].BILL_DIV_CODE);
										},
										'onClear':function(type) {
											var selectedRec = salesGrid.getSelectedRecord();
											selectedRec.set('DEPT_NAME', '');
											selectedRec.set('DEPT_CODE', '');
											selectedRec.set('DIV_CODE', '');
											selectedRec.set('BILL_DIV_CODE', '');
										}

									}

								})
			  }

			,{ dataIndex: 'DIV_CODE',  flex: 1 , minWidth:60}
			,{
				xtype:'actioncolumn',
				text:'전표생성',
				width:80,
				align:'center',
				hideable:false,
				items: [{
					icon: CPATH+'/resources/css/icons/upload_add.png',
					itemId:'createSlip',
					/*isDisabled:function(view , rowIndex, colIndex ,item, record ) {
						if(record.phantom || record.isModified()) {
							return false;
						}
					},*/
					tooltip: '전표생성',
					handler: function(grid, rowIndex, colIndex) {
						var store = grid.getStore();
						var record = store.getAt(rowIndex);
						if(record.isValid()) {
							var param = record.getData();
							param.INPUT_PATH = panelSearch.getValue('INPUT_PATH');
							param.EX_DATE =  UniDate.getDateStr(param.AC_DATE);

							Ext.getBody().mask();
							accntCommonService.fnGetAutoMethod(param, function(provider, response){

								if(provider.length > 0) {
									masterGrid2.getStore().removeAll();
									var salesRecord = record;
									salesRecord.set("SLIP_NUM", provider[0].SLIP_NUM);
									
									Ext.each(provider, function(providerRec, idx) {

										var r = {
											'AC_DATE':UniDate.getDbDateStr(salesRecord.get('AC_DATE')),
											'AC_DAY': Ext.Date.format(UniDate.extParseDate(salesRecord.get('AC_DATE')),'d'),
											'SLIP_NUM' : providerRec.SLIP_NUM,
											'SLIP_SEQ' : idx+1,


											'IN_DIV_CODE':panelSearch.getValue('IN_DIV_CODE'),
											'IN_DEPT_CODE':panelSearch.getValue('IN_DEPT_CODE'),
											'IN_DEPT_NAME':panelSearch.getValue('IN_DEPT_NAME'),

											'SLIP_DIVI':providerRec.SLIP_DIVI == '1' ? '3':'4',
											'DR_CR':providerRec.SLIP_DIVI == '1' ? '1':'2',
											'AP_STS':'1',
											'DIV_CODE':panelSearch.getValue('IN_DIV_CODE'),
											'DEPT_CODE':baseInfo.gsDeptCode,
											'DEPT_NAME':baseInfo.gsDeptName,
											
											//'DEPT_CODE':UserInfo.deptCode,
											//'DEPT_NAME':UserInfo.deptName,
											
											'POSTIT_YN':'N',
											'INPUT_PATH':csINPUT_PATH,
											'INPUT_DIVI':csINPUT_DIVI,
											'INPUT_USER_ID':UserInfo.userID,
											'CHARGE_CODE':UserInfo.depeCode,

											'DIV_CODE' : panelSearch.getValue('IN_DIV_CODE'),
											'INPUT_PATH' : csINPUT_PATH,

											'OLD_AC_DATE':UniDate.getDateStr(salesRecord.get('AC_DATE')),
											'OLD_SLIP_NUM' : providerRec.SLIP_NUM,
											'OLD_SLIP_SEQ' :idx+1
										};
										masterGrid2.createRow(r,'AC_DAY');
										var newRecord = masterGrid2.getSelectedRecord();
										UniAppManager.app.loadDataAccntInfo(newRecord, saleDetailForm, providerRec);


										newRecord.set('CUSTOM_CODE', salesRecord.get('CUSTOM_CODE'));
										newRecord.set('CUSTOM_NAME', salesRecord.get('CUSTOM_NAME'));

										 var 	proofGbn='', refparam = {};
										 if(!Ext.isEmpty(salesRecord.get('PROOF_KIND'))) {

											refparam = {
														'MAIN_CODE':'A022'
													   ,'SUB_CODE':salesRecord.get('PROOF_KIND')
													   ,'field':'refCode5'
											 }
											 proofGbn =	UniAccnt.fnGetRefCode(refparam);
											 var proofKindParam = {
														'MAIN_CODE':'A022'
													   ,'SUB_CODE':salesRecord.get('PROOF_KIND')
													   ,'field':'text'
											 }
											 var proofkindName =	UniAccnt.fnGetRefCode(proofKindParam);
											 newRecord.set('PROOF_KIND_NM', proofkindName);
											 for(var i =1 ; i <= 6; i++) {
												 if(newRecord.get('AC_CODE'+i.toString()) == "I5" ) {
													newRecord.set('AC_DATA'+i.toString(), salesRecord.get('PROOF_KIND'));
													newRecord.set('AC_DATA_NAME'+i.toString(), proofkindName);	
												}
											 }
										 }
										var reasonGbn2='', refParam2 ={};
										if(!Ext.isEmpty(salesRecord.get('PROOF_KIND'))) {

											refparam2 = {
														'MAIN_CODE':'A070'
													   ,'SUB_CODE':salesRecord.get('REASON_CODE')
													   ,'field':'refCode2'
											 }
											 reasonGbn2 =	UniAccnt.fnGetRefCode(refparam2);
										 }

										var dTaxAmt=0, dSupplyAmt=0;
										if(proofGbn == 'Y' && baseInfo.reasonGbn == 'Y' && reasonGbn2 == 'Y') {
											dTaxAmt = salesRecord.get("TAX_AMT_I");
											dSupplyAmt = salesRecord.get("SUPPLY_AMT_I");
										}else if(["54", "61", "70", "71"].indexOf(salesRecord.get('PROOF_KIND')) >= 0) {
											dTaxAmt = salesRecord.get("TAX_AMT_I");
											dSupplyAmt = salesRecord.get("SUPPLY_AMT_I");
											if(dTaxAmt == null) dTaxAmt = 0;
											if(dSupplyAmt == null) dSupplyAmt = 0;
											dSupplyAmt = dTaxAmt + dSupplyAmt;
											dTaxAmt = 0
										}else if(salesRecord.get('PROOF_KIND') == "56") {
											dTaxAmt = salesRecord.get("TAX_AMT_I");
											dSupplyAmt = 0;
										}else {
											dTaxAmt = salesRecord.get("TAX_AMT_I");
											dSupplyAmt = salesRecord.get("SUPPLY_AMT_I");
										}
										
										if(dTaxAmt == null)  dTaxAmt = 0;
										if(dSupplyAmt == null) dSupplyAmt = 0;


										//	매입일 경우
										if(salesRecord.get("SALE_DIVI") == "1") {
											if(newRecord.get("DR_CR") == "1") {
												if(newRecord.get("SPEC_DIVI")== "F1") {
													newRecord.set("DR_AMT_I", dTaxAmt);
													newRecord.set("AMT_I", dTaxAmt);
													newRecord.set("PROOF_KIND", salesRecord.get("PROOF_KIND"));
													newRecord.set("PROOF_KIND_NM", salesRecord.get("PROOF_KIND_NM"));
												}else {
													newRecord.set("DR_AMT_I", dSupplyAmt);
													newRecord.set("AMT_I", dSupplyAmt);
												}
											}else {

												var amt = dSupplyAmt + dTaxAmt;
												newRecord.set("CR_AMT_I", amt);
												newRecord.set("AMT_I",amt);
											}

										//	매출일 경우
										}else {
											if(newRecord.get("DR_CR") == "2") {
												if(newRecord.get("SPEC_DIVI") == "F2") {
													newRecord.set("CR_AMT_I", dTaxAmt);
													newRecord.set("AMT_I", dTaxAmt);
													newRecord.set("PROOF_KIND", salesRecord.get("PROOF_KIND"));
													newRecord.set("PROOF_KIND_NM", salesRecord.get("PROOF_KIND_NM"));
												}else {
													newRecord.set("CR_AMT_I", dSupplyAmt);
													newRecord.set("AMT_I", dSupplyAmt);
												}
											} else {
												var amt = dSupplyAmt + dTaxAmt;
												newRecord.set("DR_AMT_I", amt);
												newRecord.set("AMT_I",amt);
											}
										}

										if(newRecord.get("SPEC_DIVI") == "F1" && newRecord.get("DR_CR")  == "1") {

											newRecord.set("CREDIT_CODE", "");
											newRecord.set("REASON_CODE", salesRecord.get("REASON_CODE"));
											newRecord.set("CREDIT_NUM", salesRecord.get("CREDIT_NUM"));

										} else if(newRecord.get("SPEC_DIVI") == "F2" && newRecord.get("DR_CR") == "2") {

											newRecord.set("CREDIT_CODE", salesRecord.get("CREDIT_CODE"));
											newRecord.set("REASON_CODE", "");

										} else {
											newRecord.set("CREDIT_CODE", "");
											newRecord.set("REASON_CODE", "");
										}
										if(["55", "61", "68", "69"].indexOf(salesRecord.get('PROOF_KIND')) >= 0 && ["55", "61", "68", "69"].indexOf(newRecord.get('PROOF_KIND')) >= 0) {
											newRecord.set("ASST_SUPPLY_AMT_I", salesRecord.get("ASST_SUPPLY_AMT_I"));
											newRecord.set("ASST_TAX_AMT_I", salesRecord.get("ASST_TAX_AMT_I"));
											newRecord.set("ASST_DIVI", salesRecord.get("ASST_DIVI"));
										}
										newRecord.set("REMARK", salesRecord.get("REMARK"));

										newRecord.set("DIV_CODE", salesRecord.get("DIV_CODE"));
										newRecord.set("DEPT_CODE", salesRecord.get("DEPT_CODE"));
										newRecord.set("DEPT_NAME", salesRecord.get("DEPT_NAME"));
										newRecord.set("BILL_DIV_CODE", salesRecord.get("BILL_DIV_CODE"));

										UniAppManager.app.fnSetAcCode(newRecord, "A4",  salesRecord.get("CUSTOM_CODE"),  salesRecord.get("CUSTOM_NAME"));

										UniAppManager.app.fnSetAcCode(newRecord, "I1",  salesRecord.get("SUPPLY_AMT_I"));
										UniAppManager.app.fnSetAcCode(newRecord, "I2",  salesRecord.get("BILL_DIV_CODE"));
										UniAppManager.app.fnSetAcCode(newRecord, "I3",  UniDate.getDateStr(salesRecord.get("PUB_DATE")));
										UniAppManager.app.fnSetAcCode(newRecord, "I6",  salesRecord.get("TAX_AMT_I"));

										//증빙유형의 참조코드1에 따라 전자발행여부 기본값 설정
										UniAppManager.app.fnSetDefaultAcCodeI7(newRecord);

									})
								}else {
									alert('자동기표 방법이 등록되지 않았습니다.');
								}
								Ext.getBody().unmask();
							})
						}else {
							salesGrid.uniSelectInvalidColumnAndAlert([record]);
						}

					}
				}
				]/*,
				renderer:function(value, metaData, record) {
					if(record.phantom) {
						metaData.column.items[0].disable(false);
					}
				}*/
			  }

		],
		listeners:{
			beforedeselect: function (grid, record, index, eOpts) {
					var updateRecords=salesStore.getUpdatedRecords( );
					var removedRecords=salesStore.getRemovedRecords( );
					var changedRec = [].concat(updateRecords).concat(removedRecords);
					
					if(directMasterStore2.isDirty() ) {
						if(confirm('저장할 데이터가 있습니다. 저장하시겠습니까?')) {
							UniApp.app.onSaveDataButtonDown()
							return false;
						}
						return false;
					}else if(changedRec.length > 0 ) {
						if(confirm('저장할 데이터가 있습니다. 저장하시겠습니까?')) {
							UniApp.app.onSaveDataButtonDown()
							return false;
						}
						return false;
					}
			},
			selectionChange: function( gird, selected, eOpts ) {
				if(selected && selected.length > 0 && !selected[0].phantom) {
					var param = {
						'INPUT_PATH'	:panelSearch.getValue('INPUT_PATH'),
						//'CHARGE_CODE'	:panelSearch.getValue('CHARGE_CODE'),
						'AP_STS'		:panelSearch.getValue('AP_STS'),
						'DEPT_CODE'		:panelSearch.getValue('IN_DEPT_CODE'),
						'DIV_CODE'		:panelSearch.getValue('IN_DIV_CODE'),
						'AC_DATE_FR'	:UniDate.getDbDateStr(selected[0].get('OLD_AC_DATE')),
						'AC_DATE_TO'	:UniDate.getDbDateStr(selected[0].get('OLD_AC_DATE')),
						'EX_NUM'		:selected[0].get('SLIP_NUM')
					}
					directMasterStore2.loadStoreRecords(param);
				}else if(selected && selected.length > 0 && selected[0].phantom) {
					directMasterStore2.loadData({});
					saleDetailForm.clearForm();
					saleDetailForm.down('#formFieldArea1').removeAll();
				}
			},
			render: function(grid, eOpts){
				grid.getEl().on('click', function(e, t, eOpt) {
					activeGrid = grid.getItemId();
					if(salesStore.getData().items.length > 0) {
						UniAppManager.setToolbarButtons('delete',true);
					}
				});
			},
			celldblclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(e.position.column.dataIndex=='PROOF_KIND')   {
					UniAppManager.app.fnProofKindPopUp(record, null,'agj100ukrSalesGrid' );
				} 
				if(cellIndex==8) {
					creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null, "CREDIT_NUM",null, null, null, 'VALUE', 'agj100ukrSalesGrid');
				}
			},
			cellkeydown:function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(e.getKey() == 13) {
					enterNavigation(e);
				}

			}
		}
	});



	tab = Unilite.createTabPanel('agj100ukrvTab',{
		region:'center',
		activeTab: 0,
		border: false,
		items:[
			{
				title: '일반전표',
				xtype: 'panel',
				itemId: 'agjTab1',
				layout:{type:'vbox', align:'stretch'},
				items:[
					masterGrid1,
					detailForm1,
					slipContainer
				]
			},{
				title: '매입/매출전표',
				xtype:'container',
				itemId: 'agjTab2',
				layout:{type:'vbox', align:'stretch'},
				defaults:{
					style:{left:'1px !important'}
				},
				items:[
					salesGrid,
					masterGrid2,
					saleDetailForm
				]
			}
		],
		listeners:{
			beforetabchange:function( tabPanel, newCard, oldCard, eOpts ) {
				if(oldCard.getItemId() == 'agjTab1') {
					if(directMasterStore1.isDirty()) {
						console.log("directMasterStore1.isDirty() : "+ directMasterStore1.isDirty());
						Unilite.messageBox('저장할 데이터가 있습니다. 저장 후 이동하여 주세요.');
						return false;
					}else {
						//검색 조건은 reset 안함
						//masterGrid1.getStore().uniOpt.isMaster=true;
						//masterGrid1.getStore().uniOpt.editable=true;
						masterGrid1.reset();
						masterGrid1.getStore().commitChanges();
						detailForm1.clearForm();
						detailForm1.down('#formFieldArea1').removeAll();

						masterGrid2.reset();
						masterGrid2.getStore().commitChanges();
						salesGrid.reset();
						salesGrid.getStore().commitChanges();

						saleDetailForm.clearForm();
						saleDetailForm.down('#formFieldArea1').removeAll();
						drSum = 0; crSum = 0;
						slipGrid1.reset();
						slipGrid2.reset();
						UniAppManager.app.setSearchReadOnly(false);
						UniAppManager.setToolbarButtons('save',false);
					}
				}else {
					if(salesStore.isDirty() || directMasterStore2.isDirty()) {
						console.log("salesStore.isDirty()  : "+ salesStore.isDirty() );
						console.log("directMasterStore2.isDirty() : "+ directMasterStore2.isDirty());
						Unilite.messageBox('저장할 데이터가 있습니다. 저장 후 이동하여 주세요.');
						return false;
					}else {
						//검색 조건은 reset 안함
						//masterGrid1.getStore().uniOpt.isMaster=true;
						//masterGrid1.getStore().uniOpt.editable=true;
						masterGrid1.reset();
						masterGrid1.getStore().commitChanges();
						detailForm1.clearForm();
						detailForm1.down('#formFieldArea1').removeAll();

						masterGrid2.reset();
						masterGrid2.getStore().commitChanges();
						salesGrid.reset();
						salesGrid.getStore().commitChanges();

						saleDetailForm.clearForm();
						saleDetailForm.down('#formFieldArea1').removeAll();
						drSum = 0; crSum = 0;
						slipGrid1.reset();
						slipGrid2.reset();
						UniAppManager.app.setSearchReadOnly(false);
						UniAppManager.setToolbarButtons('save',false);
					}
				}
			},
			tabchange: function( tabPanel, newCard, oldCard, eOpts ) {
				if(Ext.isEmpty(panelSearch.getValue('CHARGE_NAME'))) {
					alert('회계담당자정보가 없습니다. 먼저 담당자 정보를 입력해주세요.');
					return false;
				}
				if(newCard.getItemId() == 'agjTab1') {
					csINPUT_PATH = "Z1"
					gsInputPath = "Z1";
					panelSearch.setValue('INPUT_PATH',csINPUT_PATH );
					panelResult.setValue('INPUT_PATH',csINPUT_PATH );

					panelSearch.getField('INPUT_PATH').setReadOnly(false);
					panelResult.getField('INPUT_PATH').setReadOnly(false);
					UniAppManager.app.setSearchReadOnly(false);
					UniAppManager.app.setEditableGrid(csINPUT_PATH, true);
				}else {
					csINPUT_PATH = "Y1";
					gsInputPath = "Y1";
					panelSearch.setValue('INPUT_PATH',csINPUT_PATH );
					panelResult.setValue('INPUT_PATH',csINPUT_PATH );
					activeGrid = 'agj100ukrSalesGrid'
					UniAppManager.app.setSearchReadOnly(false);
					panelSearch.getField('INPUT_PATH').setReadOnly(true);
					panelResult.getField('INPUT_PATH').setReadOnly(true);

					UniAppManager.setToolbarButtons([ 'newData'],true);
					directMasterStore1.uniOpt.isMaster = true;
					directMasterStore1.uniOpt.editable =  true;
					directMasterStore1.uniOpt.deletable =  true;
				}
			}
		}
	})



	Unilite.Main({
		borderItems: [{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		},
		panelSearch
		],
		panelSearch : panelSearch,
		panelResult : panelResult,
		id  : 'agj100ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons([ 'newData','reset'],true);
			panelSearch.setValue('CHARGE_CODE','${chargeCode}');
			panelSearch.setValue('CHARGE_NAME','${chargeName}');
			panelResult.setValue('CHARGE_CODE','${chargeCode}');
			panelResult.setValue('CHARGE_NAME','${chargeName}');

			if(Ext.isEmpty(panelSearch.getValue('CHARGE_NAME'))) {
				alert('회계담당자정보가 없습니다. 먼저 담당자 정보를 입력해주세요.');
			}
			var sInputPath = !Ext.isEmpty(params) && !Ext.isEmpty(params.INPUT_PATH) ? params.INPUT_PATH : 'Z1' ;
			UniAppManager.app.setEditableGrid(sInputPath, true);
			
			//20200721 추가: processParams으로 넘어가는 조건 추가
			if(params && params.PGM_ID) {
				this.processParams(params);
			}

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE_FR');
		},
		onQueryButtonDown : function() {
			var activeTab = tab.getActiveTab();
			var activeTabId = activeTab.getItemId();
			
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
			if(Ext.isEmpty(panelSearch.getValue('CHARGE_NAME'))) {
				alert('회계담당자정보가 없습니다. 먼저 담당자 정보를 입력해주세요.');
				return false;
			}
			if(UniDate.extFormatMonth(panelSearch.getValue('AC_DATE_FR')) != UniDate.extFormatMonth(panelSearch.getValue('AC_DATE_TO'))) {
				alert('동일한 월만 조회가 가능합니다.');
				var activeSForm ;
				if(!UserInfo.appOption.collapseLeftSearch) {
					activeSForm = panelSearch;
				}else {
					activeSForm = panelResult;
				}
				panelSearch.setValue('AC_DATE_TO','');
				panelResult.setValue('AC_DATE_TO','');
				activeSForm.getField('AC_DATE_TO').focus();
				return ;
			}
			if(activeTabId == 'agjTab1' ) {
				directMasterStore1.loadStoreRecords();
				var sInputPath = panelSearch.getValue('INPUT_PATH')
				this.setEditableGrid(sInputPath, true);
			}else {
				directMasterStore2.loadData({});
				saleDetailForm.down('#formFieldArea1').removeAll();
				salesStore.loadStoreRecords();
			}
		},
		onNewDataButtonDown : function() {
			if(!this.toolbar.down("#newData").isDisabled()) {
				var activeTab = tab.getActiveTab();
				var activeTabId = activeTab.getItemId();

				if(activeTabId == 'agjTab1' ) {
					if(Ext.isEmpty(panelSearch.getValue('CHARGE_NAME'))) {
						alert('회계담당자정보가 없습니다. 먼저 담당자 정보를 입력해주세요.');
						return false;
					}
					this.fnAddSlipRecord();
					UniAppManager.app.setSearchReadOnly(true);
				} else if(activeTabId == 'agjTab2' ) {
					if(Ext.isEmpty(panelSearch.getValue('CHARGE_NAME'))) {
						alert('회계담당자정보가 없습니다. 먼저 담당자 정보를 입력해주세요.');
						return false;
					}
					if(activeGrid=='agj100ukrSalesGrid') {
						if(!salesStore.isDirty() && !directMasterStore2.isDirty()) {
							Ext.getBody().mask();
							agj100ukrService.getPubNum({'PUB_DATE':UniDate.getDateStr(panelSearch.getValue('AC_DATE_TO'))}, function(provider, result ) {
								var pDate = panelSearch.getValue('AC_DATE_TO');
								var selectedRecord = salesGrid.getSelectedRecord();
								var rec={
									'AC_DATE'		: UniDate.getDateStr(pDate),
									'AC_DAY'		: Ext.Date.format(pDate,'j'),
									'PUB_DATE'		: UniDate.getDateStr(pDate),
									'PUB_NUM'		: provider.PUB_NUM,
									'SALE_DIVI'		: '1',
									'AP_STS'		: '1',
									'SUPPLY_AMT_I'	: 0,
									'TAX_AMT_I'		: 0,
									'REMARK'		: (selectedRecord) ? selectedRecord.get('REMARK'):'',
									'OLD_AC_DATE'	: UniDate.getDateStr(pDate),
									'OLD_SLIP_NUM'	: 0,
									'OLD_PUB_DATE'	: UniDate.getDateStr(pDate),
									'OLD_PUB_NUM'	: provider.PUB_NUM
								};
								salesGrid.createRow(rec, 'AC_DAY');
								directMasterStore2.loadData({});
								saleDetailForm.clearForm();
								saleDetailForm.down('#formFieldArea1').removeAll();
								UniAppManager.app.setSearchReadOnly(true);
								UniAppManager.setToolbarButtons('delete',true);
								Ext.getBody().unmask();
							});
						}
					} else {
						if(salesGrid.getSelectedRecord()) {
							this.fnAddSlipRecord();
							UniAppManager.app.setSearchReadOnly(true);
						}
					}
				}
			}
		},
		onSaveDataButtonDown: function (config) {
			var activeTab = tab.getActiveTab();
			var activeTabId = activeTab.getItemId();
			if(activeTabId == 'agjTab1' ) {
				if(Ext.isEmpty(panelSearch.getValue('CHARGE_NAME'))) {
					alert('회계담당자정보가 없습니다. 먼저 담당자 정보를 입력해주세요.');
					return false;
				}
				directMasterStore1.saveStore(config);
			} else  if(activeTabId == 'agjTab2' ) {
				//salesStore.saveStore(config);
				if(Ext.isEmpty(panelSearch.getValue('CHARGE_NAME'))) {
					alert('회계담당자정보가 없습니다. 먼저 담당자 정보를 입력해주세요.');
					return false;
				}
				directMasterStore2.saveStore(config);
			}
		},
		onDeleteDataButtonDown : function() {
			var activeTab = tab.getActiveTab();
			var activeTabId = activeTab.getItemId();
			if(Ext.isEmpty(panelSearch.getValue('CHARGE_NAME'))) {
				alert('회계담당자정보가 없습니다. 먼저 담당자 정보를 입력해주세요.');
				return false;
			}
			if(activeTabId == 'agjTab1' ) {
				masterGrid1.deleteSelectedRow();
			}else  if(activeTabId == 'agjTab2' ) {
				if(activeGrid=='agj100ukrSalesGrid'){
					//salesGrid.deleteSelectedRow();
					this.onDeleteAllButtonDown()
				}else {
					masterGrid2.deleteSelectedRow();
					if(masterGrid2.store.count() == 0) {
						//this.onDeleteAllButtonDown();
						salesGrid.getSelectedRecord().set("OPR_FLAG", "D");
						var sm = salesGrid.getSelectionModel();
						salesGrid.getStore().remove(sm.getSelection());
						saleDetailForm.down('#formFieldArea1').removeAll();
					}
				}
			}
		},
		onDeleteAllButtonDown:function() {
			if(Ext.isEmpty(panelSearch.getValue('CHARGE_NAME'))) {
				alert('회계담당자정보가 없습니다. 먼저 담당자 정보를 입력해주세요.');
				return false;
			}
			if(panelSearch.getValue('INPUT_PATH') != csINPUT_PATH) {
				alert(Msg.sMA0353);
				return
			}
			if(confirm("같은 전표번호를 모두 삭제하시겠습니까?")) {
				var activeTab = tab.getActiveTab();
				var activeTabId = activeTab.getItemId();
				if(activeTabId == 'agjTab1' ) {
					var sel = masterGrid1.getSelectedRecord();
					var store = masterGrid1.getStore();
					var data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY')== sel.get('AC_DAY') && record.get('SLIP_NUM') == sel.get('SLIP_NUM')) } ).items);
					store.remove(data);
				}else  if(activeTabId == 'agjTab2' ) {
					var sel = masterGrid2.getSelectedRecord();
					var store = masterGrid2.getStore()
					var data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY')== sel.get('AC_DAY') && record.get('SLIP_NUM') == sel.get('SLIP_NUM')) } ).items);
					store.remove(data);
					salesGrid.getSelectedRecord().set("OPR_FLAG", "D");
					var sm = salesGrid.getSelectionModel();
					salesGrid.getStore().remove(sm.getSelection());
					saleDetailForm.down('#formFieldArea1').removeAll();
				}
			}
		},
		onResetButtonDown:function() {
			gsSlipNum = "";
			gsProcessPgmId ="";

			masterGrid1.getSelectionModel().deselectAll();
			
			//var masterGrid1 = Ext.getCmp('agj100ukrGrid1');
			// panelSearch.reset();
			//masterGrid1.getStore().uniOpt.isMaster=true;
			//masterGrid1.getStore().uniOpt.editable=true;
			masterGrid1.getStore().loadData({});
			tempEditMode = true;
			detailForm1.clearForm();
			detailForm1.down('#formFieldArea1').removeAll();

			masterGrid2.getStore().loadData({});
			salesGrid.getStore().loadData({});

			saleDetailForm.clearForm();
			saleDetailForm.down('#formFieldArea1').removeAll();
			drSum = 0; crSum = 0;
			slipGrid1.reset();
			slipGrid1.getStore().clearData();
			slipGrid2.reset();
			slipGrid2.getStore().clearData();

			this.setSearchReadOnly(false);

			//20200721 추가: 초기화 시 set하는 로직 추가
//			panelSearch.setValue('AC_DATE_FR'	, UniDate.get('today'));
//			panelSearch.setValue('AC_DATE_TO'	, UniDate.get('today'));
//			panelSearch.setValue('AUTHORITY'	, baseInfo.gsChargeDivi);
//			panelSearch.setValue('IN_DEPT_CODE'	, baseInfo.gsDeptCode);
//			panelSearch.setValue('IN_DEPT_NAME'	, baseInfo.gsDeptName);
//			
//			//panelSearch.setValue('IN_DEPT_CODE'	, UserInfo.deptCode);
//			//panelSearch.setValue('IN_DEPT_NAME'	, UserInfo.deptName);
			
			panelSearch.setValue('IN_DIV_CODE'	, UserInfo.divCode);
			panelSearch.setValue('AP_STS'		, '1');

//			panelResult.setValue('AC_DATE_FR'	, UniDate.get('today'));
//			panelResult.setValue('AC_DATE_TO'	, UniDate.get('today'));
//			panelResult.setValue('AUTHORITY'	, baseInfo.gsChargeDivi);
//			panelResult.setValue('IN_DEPT_CODE'	, baseInfo.gsDeptCode);
//			panelResult.setValue('IN_DEPT_NAME'	, baseInfo.gsDeptName);
//			
//			//panelResult.setValue('IN_DEPT_CODE'	, UserInfo.deptCode);
//			//panelResult.setValue('IN_DEPT_NAME'	, UserInfo.deptName);
			
			panelResult.setValue('IN_DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('AP_STS'		, '1');

			panelSearch.getField('INPUT_PATH').setValue(csINPUT_PATH);
			panelResult.getField('INPUT_PATH').setValue(csINPUT_PATH);
			
			panelSearch.setValue('EX_NUM'		, '');
			panelResult.setValue('EX_NUM'		, '');
			panelSearch.setValue('CHARGE_CODE'	, '${chargeCode}');
			panelSearch.setValue('CHARGE_NAME'	, '${chargeName}');
			panelResult.setValue('CHARGE_CODE'	, '${chargeCode}');
			panelResult.setValue('CHARGE_NAME'	, '${chargeName}');
			UniAppManager.setToolbarButtons(['newData','reset'],true);
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);

			this.setEditableGrid(csINPUT_PATH, true);
//			this.fnInitBinding(null);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		rejectSave: function() {
			directMasterStore1.rejectChanges();
			directMasterStore2.rejectChanges();
			salesStore.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
		},
		confirmSaveData: function() {
			var activeTab = tab.getActiveTab();
			var activeTabId = activeTab.getItemId();
			if(activeTabId == 'agjTab1' ) {
				if(directMasterStore1.isDirty()) {
					if(confirm(Msg.sMB061)) {
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
			} else  if(activeTabId == 'agjTab2' ) {
				if(salesStore.isDirty() || directMasterStore2.isDirty()) {
					if(confirm(Msg.sMB061)) {
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
			}
		},
		setEditableGrid:function(sInputPath, btnReset ) {
			var activeTab = tab.getActiveTab();
			var activeTabId = activeTab.getItemId();
			var grid = UniAppManager.app.getActiveGrid();

			if(activeTabId == 'agjTab1' ) {
				var inputPahtStore =  Ext.data.StoreManager.lookup('comboInputPath') ;// panelSearch.getField('INPUT_PATH').getStore();
				var record = grid.getSelectedRecord();
				if(record && record.get('AP_STS') == "2")		{
					UniAppManager.setToolbarButtons([ 'newData','deleteAll'],false);
					tempEditMode = false;
					directMasterStore1.uniOpt.deletable =  false;
					detailForm1.setReadOnly(true);
					var tMenu1 = grid.contextMenu.down('#copyRecord');
					var tMenu2 = grid.contextMenu.down('#pasteRecord');
					tMenu1.disable();
					tMenu2.disable();
					return;
				}

				if(sInputPath != null ) {
					Ext.each(inputPahtStore.data.items, function(item, idx) {
						if(sInputPath == item.get('value')) {
							gsInputPath = item.get('refCode3');
						}
					});
				}
				if (
					(gsInputPath != csINPUT_PATH && gsInputPath != "Y") ||
					(gsInputPath ==  csINPUT_PATH && gsDraftYN	== "Y")
				) {
					if(btnReset) {
						UniAppManager.setToolbarButtons([ 'newData','deleteAll'],false);
					}
					tempEditMode = false;
					directMasterStore1.uniOpt.deletable =  false;
					detailForm1.setReadOnly(true);
					var tMenu1 = grid.contextMenu.down('#copyRecord');
					var tMenu2 = grid.contextMenu.down('#pasteRecord');
					if(tMenu1) tMenu1.disable();
					if(tMenu2) tMenu2.disable();
				}else {
					if(btnReset) {
						UniAppManager.setToolbarButtons([ 'newData'],true);
					}
					gsInputPath = sInputPath;
					tempEditMode = true;
					directMasterStore1.uniOpt.deletable =  true;
					detailForm1.setReadOnly(false);
					var tMenu1 = grid.contextMenu.down('#copyRecord');
					var tMenu2 = grid.contextMenu.down('#pasteRecord');
					if(tMenu1) tMenu1.enable();
					if(tMenu2) tMenu2.enable();
				}
			} else {
				if(btnReset) {
					UniAppManager.setToolbarButtons([ 'newData'],true);
				}
				tempEditMode = true;
				directMasterStore1.uniOpt.deletable =  true;
				detailForm1.setReadOnly(false);
			}
		},
		setSearchReadOnly:function(b) {
			panelSearch.getField('AC_DATE_FR').setReadOnly(b);
			panelSearch.getField('AC_DATE_TO').setReadOnly(b);
			panelSearch.getField('INPUT_PATH').setReadOnly(b);

			panelResult.getField('AC_DATE_FR').setReadOnly(b);
			panelResult.getField('AC_DATE_TO').setReadOnly(b);
			panelResult.getField('INPUT_PATH').setReadOnly(b);
		},
		// 링크로 넘어오는 params 받는 부분 (Agj240skr)
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'agj230ukr') {
				if(params.INPUT_PATH == 'Y1'){
					tab.setActiveTab(tab.down('#agjTab2'));
					panelSearch.setValue('AC_DATE_FR',params.AC_DATE_FR);
					panelSearch.setValue('AC_DATE_TO',params.AC_DATE_TO);
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					panelSearch.setValue('CHARGE_CODE',params.CHARGE_CODE);
					panelSearch.setValue('CHARGE_NAME',params.CHARGE_NAME);
					panelSearch.setValue('IN_DIV_CODE',params.DIV_CODE);
					panelSearch.setValue('IN_DEPT_CODE',params.DEPT_CODE);
					panelSearch.setValue('IN_DEPT_NAME',params.DEPT_NAME);
					
					panelResult.setValue('AC_DATE_FR',params.AC_DATE_FR);
					panelResult.setValue('AC_DATE_TO',params.AC_DATE_FR);
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					panelResult.setValue('CHARGE_CODE',params.CHARGE_CODE);
					panelResult.setValue('CHARGE_NAME',params.CHARGE_NAME);
					panelResult.setValue('IN_DIV_CODE',params.DIV_CODE);
					panelResult.setValue('IN_DEPT_CODE',params.DEPT_CODE);
					panelResult.setValue('IN_DEPT_NAME',params.DEPT_NAME);
					
					gsProcessPgmId	= params.PGM_ID;
					gsSlipNum 		= params.SLIP_NUM;
					
					var params = panelSearch.getValues();
					params.SLIP_NUM = gsSlipNum;
					salesGrid.getStore().loadStoreRecords(params);
					
				}else{
					
					tab.setActiveTab(tab.down('#agjTab1'));
					panelSearch.setValue('AC_DATE_FR',params.AC_DATE_FR);
					panelSearch.setValue('AC_DATE_TO',params.AC_DATE_TO);
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					panelSearch.setValue('CHARGE_CODE',params.CHARGE_CODE);
					panelSearch.setValue('CHARGE_NAME',params.CHARGE_NAME);
					panelSearch.setValue('IN_DIV_CODE',params.DIV_CODE);
					panelSearch.setValue('IN_DEPT_CODE',params.DEPT_CODE);
					panelSearch.setValue('IN_DEPT_NAME',params.DEPT_NAME);
					
					panelResult.setValue('AC_DATE_FR',params.AC_DATE_FR);
					panelResult.setValue('AC_DATE_TO',params.AC_DATE_TO);
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					panelResult.setValue('CHARGE_CODE',params.CHARGE_CODE);
					panelResult.setValue('CHARGE_NAME',params.CHARGE_NAME);
					panelResult.setValue('IN_DIV_CODE',params.DIV_CODE);
					panelResult.setValue('IN_DEPT_CODE',params.DEPT_CODE);
					panelResult.setValue('IN_DEPT_NAME',params.DEPT_NAME);
					
					gsProcessPgmId	= params.PGM_ID;
					masterGrid1.getStore().loadStoreRecords();
				}
				
			} else if(params.PGM_ID == 'agj240skr') {
				if(params.INPUT_PATH == 'Y1'){
					tab.setActiveTab(tab.down('#agjTab2'));
					panelSearch.setValue('AC_DATE_FR',params.AC_DATE_FR);
					panelSearch.setValue('AC_DATE_TO',params.AC_DATE_TO);
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					panelSearch.setValue('CHARGE_CODE',params.CHARGE_CODE);
					panelSearch.setValue('CHARGE_NAME',params.CHARGE_NAME);
					panelSearch.setValue('IN_DIV_CODE',params.DIV_CODE);
					panelSearch.setValue('IN_DEPT_CODE',params.DEPT_CODE);
					panelSearch.setValue('IN_DEPT_NAME',params.DEPT_NAME);
					
					panelResult.setValue('AC_DATE_FR',params.AC_DATE_FR);
					panelResult.setValue('AC_DATE_TO',params.AC_DATE_TO);
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					panelResult.setValue('CHARGE_CODE',params.CHARGE_CODE);
					panelResult.setValue('CHARGE_NAME',params.CHARGE_NAME);
					panelResult.setValue('IN_DIV_CODE',params.DIV_CODE);
					panelResult.setValue('IN_DEPT_CODE',params.DEPT_CODE);
					panelResult.setValue('IN_DEPT_NAME',params.DEPT_NAME);
					
					gsProcessPgmId	= params.PGM_ID;
					gsSlipNum 		= params.SLIP_NUM;
					
					var params = panelSearch.getValues();
					params.SLIP_NUM = gsSlipNum;
					salesGrid.getStore().loadStoreRecords(params);
				}else{
					tab.setActiveTab(tab.down('#agjTab1'));
					panelSearch.setValue('AC_DATE_FR',params.AC_DATE_FR);
					panelSearch.setValue('AC_DATE_TO',params.AC_DATE_TO);
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					panelSearch.setValue('CHARGE_CODE',params.CHARGE_CODE);
					panelSearch.setValue('CHARGE_NAME',params.CHARGE_NAME);
					panelSearch.setValue('IN_DIV_CODE',params.DIV_CODE);
					panelSearch.setValue('IN_DEPT_CODE',params.DEPT_CODE);
					panelSearch.setValue('IN_DEPT_NAME',params.DEPT_NAME);
					
					panelResult.setValue('AC_DATE_FR',params.AC_DATE_FR);
					panelResult.setValue('AC_DATE_TO',params.AC_DATE_FR);
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					panelResult.setValue('CHARGE_CODE',params.CHARGE_CODE);
					panelResult.setValue('CHARGE_NAME',params.CHARGE_NAME);
					panelResult.setValue('IN_DIV_CODE',params.DIV_CODE);
					panelResult.setValue('IN_DEPT_CODE',params.DEPT_CODE);
					panelResult.setValue('IN_DEPT_NAME',params.DEPT_NAME);
					
					gsProcessPgmId	= params.PGM_ID;
					masterGrid1.getStore().loadStoreRecords();
				}
			} else if(params.PGM_ID == 'agj245skr') {
				if(params.INPUT_PATH == 'Y1'){
					tab.setActiveTab(tab.down('#agjTab2'));
					
					panelSearch.setValue('AC_DATE_FR',params.AC_DATE_FR);
					panelSearch.setValue('AC_DATE_TO',params.AC_DATE_TO);
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					panelSearch.setValue('CHARGE_CODE',params.CHARGE_CODE);
					panelSearch.setValue('CHARGE_NAME',params.CHARGE_NAME);
					
					panelResult.setValue('AC_DATE_FR',params.AC_DATE_FR);
					panelResult.setValue('AC_DATE_TO',params.AC_DATE_FR);
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					panelResult.setValue('CHARGE_CODE',params.CHARGE_CODE);
					panelResult.setValue('CHARGE_NAME',params.CHARGE_NAME);
			
					gsProcessPgmId	= params.PGM_ID;
					gsSlipNum 		= params.SLIP_NUM;
					
					var params = panelSearch.getValues();
					params.SLIP_NUM = gsSlipNum;
					salesGrid.getStore().loadStoreRecords(params);
				}else{
					
					tab.setActiveTab(tab.down('#agjTab1'));
					panelSearch.setValue('AC_DATE_FR',params.AC_DATE_FR);
					panelSearch.setValue('AC_DATE_TO',params.AC_DATE_TO);
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					panelSearch.setValue('CHARGE_CODE',params.CHARGE_CODE);
					panelSearch.setValue('CHARGE_NAME',params.CHARGE_NAME);
					
					panelResult.setValue('AC_DATE_FR',params.AC_DATE_FR);
					panelResult.setValue('AC_DATE_TO',params.AC_DATE_FR);
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					panelResult.setValue('CHARGE_CODE',params.CHARGE_CODE);
					panelResult.setValue('CHARGE_NAME',params.CHARGE_NAME);
			
					gsProcessPgmId	= params.PGM_ID;
					masterGrid1.getStore().loadStoreRecords();
				}
			} else if(params.PGM_ID == 'agj270skr') {
				if(params.INPUT_PATH == 'Y1'){
					tab.setActiveTab(tab.down('#agjTab2'));
					panelSearch.setValue('AC_DATE_FR',params.AC_DATE_FR);
					panelSearch.setValue('AC_DATE_TO',params.AC_DATE_TO);
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					
					panelResult.setValue('AC_DATE_FR',params.AC_DATE_FR);
					panelResult.setValue('AC_DATE_TO',params.AC_DATE_FR);
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					
					if(params.DIV_CODE ) {
						panelSearch.setValue('IN_DIV_CODE',params.DIV_CODE);
						panelResult.setValue('IN_DIV_CODE',params.DIV_CODE);
					}
					gsProcessPgmId	= params.PGM_ID;
					gsSlipNum 		= params.SLIP_NUM;
					
					var params = panelSearch.getValues();
					params.SLIP_NUM = gsSlipNum;
					salesGrid.getStore().loadStoreRecords(params);
					
				}else{
					tab.setActiveTab(tab.down('#agjTab1'));
					panelSearch.setValue('AC_DATE_FR',params.AC_DATE_FR);
					panelSearch.setValue('AC_DATE_TO',params.AC_DATE_TO);
					
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					
					panelResult.setValue('AC_DATE_FR',params.AC_DATE_FR);
					panelResult.setValue('AC_DATE_TO',params.AC_DATE_TO);
					
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					
					if(params.DIV_CODE ) {
						panelSearch.setValue('IN_DIV_CODE',params.DIV_CODE);
						panelResult.setValue('IN_DIV_CODE',params.DIV_CODE);
					}
					gsProcessPgmId	= params.PGM_ID;
					masterGrid1.getStore().loadStoreRecords();
				}
			}
		},
		setAccntInfo:function(record, detailForm) {
			Ext.getBody().mask();
			var accnt = record.get('ACCNT');
			//UniAccnt.fnIsCostAccnt(accnt, true);
			if(accnt) {
				accntCommonService.fnGetAccntInfo({'ACCNT_CD':accnt}, function(provider, response){
					var rtnRecord = record;
					if(provider){
						UniAppManager.app.loadDataAccntInfo(rtnRecord, detailForm, provider)
					}else {
						var slipDivi = rtnRecord.get('SLIP_DIVI');
						if(slipDivi == '1' || slipDivi == '2') {
							if(rtnRecord.get('SPEC_DIVI') == 'A') {
								alert(Msg.sMA0040);
								this.clearAccntInfo(rtnRecord, detailForm);
							}
						}
						/*alert(Msg.sMA0006);
						if(fieldName) {
							record.set(fieldName, '');
						}*/
					}
					Ext.getBody().unmask();
				})
			}
		},
		loadDataAccntInfo:function(rtnRecord, detailForm, provider) {
			//관리항목 유무
			var chkAcCode = false;
			for(var i=1; i <= 6 ; i++) {
				if(!Ext.isEmpty(provider['AC_CODE'+i.toString()])) {
					chkAcCode = true;
				}
			}
			if(!chkAcCode) {
				var slipDivi = rtnRecord.get('SLIP_DIVI');
				if(slipDivi == '1' || slipDivi == '2') {
					if(rtnRecord.get('SPEC_DIVI') == 'A') {
						alert(Msg.sMA0040);
						this.clearAccntInfo(rtnRecord, detailForm);
						return;
					}
				}
			}
			if(!Ext.isEmpty(provider.ACCNT_CODE)) {
				rtnRecord.set("ACCNT", provider.ACCNT_CODE);
			}else if(!Ext.isEmpty(provider.ACCNT)) {
				rtnRecord.set("ACCNT", provider.ACCNT);	//이전행에서 복사한 경우
			}
			detailForm.clearForm();
			rtnRecord.set("ACCNT_NAME", provider.ACCNT_NAME);
			//rtnRecord.set("CUSTOM_CODE", "");
			//rtnRecord.set("CUSTOM_NAME", "");

			rtnRecord.set("AC_CODE1", provider.AC_CODE1);
			rtnRecord.set("AC_CODE2", provider.AC_CODE2);
			rtnRecord.set("AC_CODE3", provider.AC_CODE3);
			rtnRecord.set("AC_CODE4", provider.AC_CODE4);
			rtnRecord.set("AC_CODE5", provider.AC_CODE5);
			rtnRecord.set("AC_CODE6", provider.AC_CODE6);

			rtnRecord.set("AC_NAME1", provider.AC_NAME1);
			rtnRecord.set("AC_NAME2", provider.AC_NAME2);
			rtnRecord.set("AC_NAME3", provider.AC_NAME3);
			rtnRecord.set("AC_NAME4", provider.AC_NAME4);
			rtnRecord.set("AC_NAME5", provider.AC_NAME5);
			rtnRecord.set("AC_NAME6", provider.AC_NAME6);
			
			rtnRecord.set("AC_DATA1", "");
			rtnRecord.set("AC_DATA2", "");
			rtnRecord.set("AC_DATA3", "");
			rtnRecord.set("AC_DATA4", "");
			rtnRecord.set("AC_DATA5", "");
			rtnRecord.set("AC_DATA6", "");

			rtnRecord.set("AC_DATA_NAME1", "");
			rtnRecord.set("AC_DATA_NAME2", "");
			rtnRecord.set("AC_DATA_NAME3", "");
			rtnRecord.set("AC_DATA_NAME4", "");
			rtnRecord.set("AC_DATA_NAME5", "");
			rtnRecord.set("AC_DATA_NAME6", "");

			rtnRecord.set("BOOK_CODE1", provider.BOOK_CODE1);
			rtnRecord.set("BOOK_CODE2", provider.BOOK_CODE2);
			rtnRecord.set("BOOK_DATA1", "");
			rtnRecord.set("BOOK_DATA2", "");
			rtnRecord.set("BOOK_DATA_NAME1", "");
			rtnRecord.set("BOOK_DATA_NAME2", "");

			if(rtnRecord.get("DR_CR") == "1") {
				rtnRecord.set("AC_CTL1", provider.DR_CTL1);
				rtnRecord.set("AC_CTL2", provider.DR_CTL2);
				rtnRecord.set("AC_CTL3", provider.DR_CTL3);
				rtnRecord.set("AC_CTL4", provider.DR_CTL4);
				rtnRecord.set("AC_CTL5", provider.DR_CTL5);
				rtnRecord.set("AC_CTL6", provider.DR_CTL6);
			}else if(rtnRecord.get("DR_CR") == "2") {
				rtnRecord.set("AC_CTL1", provider.CR_CTL1);
				rtnRecord.set("AC_CTL2", provider.CR_CTL2);
				rtnRecord.set("AC_CTL3", provider.CR_CTL3);
				rtnRecord.set("AC_CTL4", provider.CR_CTL4);
				rtnRecord.set("AC_CTL5", provider.CR_CTL5);
				rtnRecord.set("AC_CTL6", provider.CR_CTL6);
			}
			rtnRecord.set("AC_TYPE1", provider.AC_TYPE1);
			rtnRecord.set("AC_TYPE2", provider.AC_TYPE2);
			rtnRecord.set("AC_TYPE3", provider.AC_TYPE3);
			rtnRecord.set("AC_TYPE4", provider.AC_TYPE4);
			rtnRecord.set("AC_TYPE5", provider.AC_TYPE5);
			rtnRecord.set("AC_TYPE6", provider.AC_TYPE6);

			rtnRecord.set("AC_LEN1", provider.AC_LEN1);
			rtnRecord.set("AC_LEN2", provider.AC_LEN2);
			rtnRecord.set("AC_LEN3", provider.AC_LEN3);
			rtnRecord.set("AC_LEN4", provider.AC_LEN4);
			rtnRecord.set("AC_LEN5", provider.AC_LEN5);
			rtnRecord.set("AC_LEN6", provider.AC_LEN6);

			rtnRecord.set("AC_POPUP1", provider.AC_POPUP1);
			rtnRecord.set("AC_POPUP2", provider.AC_POPUP2);
			rtnRecord.set("AC_POPUP3", provider.AC_POPUP3);
			rtnRecord.set("AC_POPUP4", provider.AC_POPUP4);
			rtnRecord.set("AC_POPUP5", provider.AC_POPUP5);
			rtnRecord.set("AC_POPUP6", provider.AC_POPUP6);

			rtnRecord.set("AC_FORMAT1", provider.AC_FORMAT1);
			rtnRecord.set("AC_FORMAT2", provider.AC_FORMAT2);
			rtnRecord.set("AC_FORMAT3", provider.AC_FORMAT3);
			rtnRecord.set("AC_FORMAT4", provider.AC_FORMAT4);
			rtnRecord.set("AC_FORMAT5", provider.AC_FORMAT5);
			rtnRecord.set("AC_FORMAT6", provider.AC_FORMAT6);

			//rtnRecord.set("MONEY_UNIT", "");

			rtnRecord.set("ACCNT_SPEC", provider.ACCNT_SPEC);
			rtnRecord.set("SPEC_DIVI", provider.SPEC_DIVI);
			rtnRecord.set("PROFIT_DIVI", provider.PROFIT_DIVI);
			rtnRecord.set("JAN_DIVI", provider.JAN_DIVI);

			rtnRecord.set("PEND_YN", provider.PEND_YN);
			rtnRecord.set("PEND_CODE", provider.PEND_CODE);
			rtnRecord.set("BUDG_YN", provider.BUDG_YN);
			rtnRecord.set("BUDGCTL_YN", provider.BUDGCTL_YN);
			rtnRecord.set("FOR_YN", provider.FOR_YN);

			UniAppManager.app.fnGetProofKind(rtnRecord, provider.ACCNT_CODE);

			rtnRecord.set("CREDIT_NUM", "");
			rtnRecord.set("CREDIT_CODE", "");
			rtnRecord.set("REASON_CODE", "");
			UniAppManager.app.fnSetAcCode(rtnRecord, "I6", 0, null)	;
			
			var dataMap = rtnRecord.data;

			var prevRecord, grid = this.getActiveGrid();
			var store = grid.getStore();
			selectedIdx = store.indexOf(rtnRecord)
			if(selectedIdx >0) prevRecord = store.getAt(selectedIdx-1);
			
			UniAccnt.addMadeFields(detailForm, dataMap, detailForm, '', rtnRecord, prevRecord);
			detailForm.setActiveRecord(rtnRecord||null);
			
			if(rtnRecord.get("CUSTOM_CODE")) {
				this.fnSetAcCode(rtnRecord, "A4", rtnRecord.get("CUSTOM_CODE"), rtnRecord.get("CUSTOM_NAME"))
			}
			UniAppManager.app.fnCheckPendYN(rtnRecord, detailForm);
			UniAppManager.app.fnSetBillDate(rtnRecord)
			UniAppManager.app.fnSetDefaultAcCodeI7(rtnRecord);
			UniAppManager.app.fnSetDefaultAcCodeA6(rtnRecord);
			UniAppManager.app.fnSetDefaultAcCodeI5(rtnRecord);
		},
		clearAccntInfo:function(record, detailForm){
			Ext.getBody().mask();
			record.set("ACCNT"			, "");
			record.set("ACCNT_NAME"		, "");
			record.set("CUSTOM_CODE"	, "");
			record.set("CUSTOM_NAME"	, "");
			record.set("AC_CODE1"		, "");
			record.set("AC_CODE2"		, "");
			record.set("AC_CODE3"		, "");
			record.set("AC_CODE4"		, "");
			record.set("AC_CODE5"		, "");
			record.set("AC_CODE6"		, "");
			record.set("AC_NAME1"		, "");
			record.set("AC_NAME2"		, "");
			record.set("AC_NAME3"		, "");
			record.set("AC_NAME4"		, "");
			record.set("AC_NAME5"		, "");
			record.set("AC_NAME6"		, "");
			record.set("AC_DATA1"		, "");
			record.set("AC_DATA2"		, "");
			record.set("AC_DATA3"		, "");
			record.set("AC_DATA4"		, "");
			record.set("AC_DATA5"		, "");
			record.set("AC_DATA6"		, "");
			record.set("AC_DATA_NAME1"	, "");
			record.set("AC_DATA_NAME2"	, "");
			record.set("AC_DATA_NAME3"	, "");
			record.set("AC_DATA_NAME4"	, "");
			record.set("AC_DATA_NAME5"	, "");
			record.set("AC_DATA_NAME6"	, "");
			record.set("BOOK_CODE1"		, "");
			record.set("BOOK_CODE2"		, "");
			record.set("BOOK_DATA1"		, "");
			record.set("BOOK_DATA2"		, "");
			record.set("BOOK_DATA_NAME1", "");
			record.set("BOOK_DATA_NAME2", "");
			record.set("AC_CTL1"		, "");
			record.set("AC_CTL2"		, "");
			record.set("AC_CTL3"		, "");
			record.set("AC_CTL4"		, "");
			record.set("AC_CTL5"		, "");
			record.set("AC_CTL6"		, "");
			record.set("AC_TYPE1"		, "");
			record.set("AC_TYPE2"		, "");
			record.set("AC_TYPE3"		, "");
			record.set("AC_TYPE4"		, "");
			record.set("AC_TYPE5"		, "");
			record.set("AC_TYPE6"		, "");
			record.set("AC_LEN1"		, "");
			record.set("AC_LEN2"		, "");
			record.set("AC_LEN3"		, "");
			record.set("AC_LEN4"		, "");
			record.set("AC_LEN5"		, "");
			record.set("AC_LEN6"		, "");
			record.set("AC_POPUP1"		, "");
			record.set("AC_POPUP2"		, "");
			record.set("AC_POPUP3"		, "");
			record.set("AC_POPUP4"		, "");
			record.set("AC_POPUP5"		, "");
			record.set("AC_POPUP6"		, "");
			record.set("AC_FORMAT1"		, "");
			record.set("AC_FORMAT2"		, "");
			record.set("AC_FORMAT3"		, "");
			record.set("AC_FORMAT4"		, "");
			record.set("AC_FORMAT5"		, "");
			record.set("AC_FORMAT6"		, "");
			record.set("MONEY_UNIT"		, "");
			record.set("EXCHG_RATE_O"	, 0);
			record.set("FOR_AMT_I"		, 0);
			record.set("ACCNT_SPEC"		, "");
			record.set("SPEC_DIVI"		, "");
			record.set("PROFIT_DIVI"	, "");
			record.set("JAN_DIVI"		, "");
			record.set("PEND_YN"		, "");
			record.set("PEND_CODE"		, "");
			record.set("BUDG_YN"		, "");
			record.set("BUDGCTL_YN"		, "");
			record.set("FOR_YN"			, "");
			record.set("PROOF_KIND"		, "");
			record.set("PROOF_KIND_NM"	, "");
			record.set("CREDIT_CODE"	, "");
			record.set("CREDIT_NUM"		, "");
			record.set("REASON_CODE"	, "");
			detailForm.down('#formFieldArea1').removeAll();
			Ext.getBody().unmask();
		},
		getActiveForm:function() {
			var form;
			if(tab) {
				var activeTab = tab.getActiveTab();
				var activeTabId = activeTab.getItemId();

				if(activeTabId == 'agjTab1' ) {
					form = detailForm1;
				}else {
					form = saleDetailForm;
				}
			}else {
				form = detailForm1;
			}
			return form;
		},
		getActiveGrid:function() {
			var grid;
			if(tab) {
				var activeTab = tab.getActiveTab();
				var activeTabId = activeTab.getItemId();

				if(activeTabId == 'agjTab1' ) {
					grid = masterGrid1;
				}else {
					grid = masterGrid2;
				}
			}else {
				grid = masterGrid1;
			}
			return grid;
		},
		needNewSlipNum:function(grid, isAddRow) {
			var needNewSlipNum = false;
			var store = grid.getStore();
			var selectedRecord = grid.getSelectedRecord();
			var nextRecordIndex = store.indexOf(selectedRecord)+1;
			var nextRecord = store.getAt(nextRecordIndex);

			if((isAddRow && store.getCount() == 0 )) {	// 처름 행 추가 한 경우
				needNewSlipNum = true
			}else if(!isAddRow && store.getCount() == 1 ) { // 수정할 경우 다음행 없는 경우
				needNewSlipNum = true
			}else {
				var checkAmt = false;
				var drSum = slipStore1.sum('AMT_I');
				var crSum = slipStore2.sum('AMT_I');

				if( nextRecord ) {
					if(UniDate.getDateStr(selectedRecord.get('AC_DATE')) == UniDate.getDateStr(nextRecord.get('AC_DATE') )
						&& selectedRecord.get('SLIP_NUM') == nextRecord.get('SLIP_NUM')
					) {
						// 같은 전표번호 사이를 선택한 경우 선택된 전표번호 사용
						needNewSlipNum = false;
					}else if((drSum+crSum) != 0 && (drSum-crSum) == 0) {
						// 같은 전표번호 마지막 row 선택한 경우 차대변 합이 0 인 경우 전표번호 생성
						needNewSlipNum = true;
					}
				}else {
					if((drSum+crSum) != 0 && (drSum-crSum) == 0) {
						needNewSlipNum = true;
					}else {
						needNewSlipNum = false;
					}
				}
			}
			return needNewSlipNum;
		},
		fnAddSlipRecord:function(){
			if(addLoading) {
				Ext.getBody().mask();
				fnAddSlipMessageWin();
				return;
			}
			addLoading			= true;
			var activeTab		= tab.getActiveTab();
			var activeTabId		= activeTab.getItemId();
			var grid			= this.getActiveGrid();
			var store			= grid.getStore();
			var needNewSlipNum	= UniAppManager.app.needNewSlipNum(grid, true);
			var selectedRecord	= grid.getSelectedRecord(grid);
			var nextRecordIndex	= store.indexOf(selectedRecord)+1;
			var nextRecord		= store.getAt(nextRecordIndex);

			var r = {};
			if(selectedRecord && !needNewSlipNum) {
				// 순번 생성
				var slipSeq = 1;
				var tAcDate = selectedRecord.get('AC_DATE');
				var tSlipNum = selectedRecord.get('SLIP_NUM');
				var slipArr = Ext.Array.push(store.data.filterBy(function(record) {
						return (	UniDate.getDateStr(record.get('AC_DATE'))== UniDate.getDateStr(tAcDate)  && record.get('SLIP_NUM')== tSlipNum )
					} ).items);
				if(slipArr.length > 0) {
					//Max SLIP_SEQ 를 구하기 위해 sort
					slipArr.sort(function(a,b){return b.get('SLIP_SEQ')-a.get('SLIP_SEQ') ;})	;
					slipSeq = slipArr[0].get('SLIP_SEQ') +1;
				}
				// 순번 생성 End
				/*r = {
					'AC_DATE':selectedRecord.get('AC_DATE'),
					'AC_DAY':selectedRecord.get('AC_DAY'),
					'SLIP_NUM':selectedRecord.get('SLIP_NUM'),
					'SLIP_SEQ': slipSeq,
					'OLD_AC_DATE':selectedRecord.get('AC_DATE'),
					'OLD_SLIP_NUM':selectedRecord.get('SLIP_NUM'),
					'OLD_SLIP_SEQ': slipSeq,
					'IN_DIV_CODE':panelSearch.getValue('IN_DIV_CODE'),
					'IN_DEPT_CODE':panelSearch.getValue('IN_DEPT_CODE'),
					'IN_DEPT_NAME':panelSearch.getValue('IN_DEPT_NAME'),
					'SLIP_DIVI':selectedRecord.get('SLIP_DIVI'),
					'DR_CR':selectedRecord.get('DR_CR'),
					'AP_STS':'1',
					'DIV_CODE':selectedRecord.get('DIV_CODE'),
					'DEPT_CODE':selectedRecord.get('DEPT_CODE'),
					'DEPT_NAME':selectedRecord.get('DEPT_NAME'),
					'DRAFT_YN':selectedRecord.get('DRAFT_YN'),
					'AGREE_YN':selectedRecord.get('AGREE_YN'),
					'REMARK':selectedRecord.get('REMARK'),
					'POSTIT_YN':'N',
					'INPUT_PATH':csINPUT_PATH,
					'INPUT_USER_ID':UserInfo.userID,
					'CHARGE_CODE':UserInfo.depeCode
				};*/
				r = {
					'AC_DATE'		: selectedRecord.get('AC_DATE'),
					'AC_DAY'		: selectedRecord.get('AC_DAY'),
					'SLIP_NUM'		: selectedRecord.get('SLIP_NUM'),
					'SLIP_SEQ'		: slipSeq,
					'OLD_AC_DATE'	: selectedRecord.get('AC_DATE'),
					'OLD_SLIP_NUM'	: selectedRecord.get('SLIP_NUM'),
					'OLD_SLIP_SEQ'	: slipSeq,
					'IN_DIV_CODE'	: selectedRecord.get('IN_DIV_CODE'),
					'IN_DEPT_CODE'	: selectedRecord.get('IN_DEPT_CODE'),
					'IN_DEPT_NAME'	: selectedRecord.get('IN_DEPT_NAME'),
					'SLIP_DIVI'		: selectedRecord.get('SLIP_DIVI'),
					'DR_CR'			: selectedRecord.get('DR_CR'),
					'AP_STS'		: Ext.isEmpty(selectedRecord)  ? '1' :selectedRecord.get('AP_STS'),
					'DIV_CODE'		: selectedRecord.get('DIV_CODE'),
					'DEPT_CODE'		: selectedRecord.get('DEPT_CODE'),
					'DEPT_NAME'		: selectedRecord.get('DEPT_NAME'),
					'DRAFT_YN'		: selectedRecord.get('DRAFT_YN'),
					'AGREE_YN'		: selectedRecord.get('AGREE_YN'),
					'CUSTOM_CODE'	: (baseInfo.customCodeCopy == "Y") ? selectedRecord.get('CUSTOM_CODE'):'',
					'CUSTOM_NAME'	: (baseInfo.customCodeCopy == "Y") ? selectedRecord.get('CUSTOM_NAME'):'',
					'REMARK'		: selectedRecord.get('REMARK'),
					'POSTIT_YN'		: 'N',
					'INPUT_PATH'	: selectedRecord.get('INPUT_PATH'),
					'INPUT_USER_ID'	: selectedRecord.get('INPUT_USER_ID'),
					'CHARGE_CODE'	: panelSearch.getValue('CHARGE_CODE'),//selectedRecord.get('CHARGE_CODE'),
					'INPUT_DIVI'	: selectedRecord.get('INPUT_DIVI'),
					'AUTO_SLIP_NUM'	: selectedRecord.get('AUTO_SLIP_NUM'),
					'CLOSE_FG'		: selectedRecord.get('CLOSE_FG'),
					'INPUT_DATE'	: selectedRecord.get('INPUT_DATE'),
					'AP_DATE'		: selectedRecord.get('AP_DATE'),
					'AP_USER_ID'	: selectedRecord.get('AP_USER_ID'),
					'AP_CHARGE_CODE': selectedRecord.get('AP_CHARGE_CODE')
				};
			}else {
				if(activeTabId == 'agjTab1' ) {
					r = {
						'AC_DATE'		: selectedRecord ? selectedRecord.get('AC_DATE') : panelSearch.getValue('AC_DATE_TO'),
						'AC_DAY'		: selectedRecord ? selectedRecord.get('AC_DAY') : Ext.Date.format(panelSearch.getValue('AC_DATE_TO'),'d'),
						'OLD_AC_DATE'	: selectedRecord ? selectedRecord.get('AC_DATE') : panelSearch.getValue('AC_DATE_TO'),
						'IN_DIV_CODE'	: panelSearch.getValue('IN_DIV_CODE'),
						'IN_DEPT_CODE'	: panelSearch.getValue('IN_DEPT_CODE'),
						'IN_DEPT_NAME'	: panelSearch.getValue('IN_DEPT_NAME'),
						'SLIP_DIVI'		: Ext.isEmpty(selectedRecord) ? '3' : selectedRecord.get("SLIP_DIVI"),
						'DR_CR'			: Ext.isEmpty(selectedRecord) ? '1': selectedRecord.get("DR_CR"),
						'AP_STS'		: '1',
						'DIV_CODE'		: UserInfo.divCode,	//panelSearch.getValue('IN_DIV_CODE'),
						'DEPT_CODE'		: baseInfo.gsDeptCode,
						'DEPT_NAME'		: baseInfo.gsDeptName,
						
						//'DEPT_CODE'		: UserInfo.deptCode,
						//'DEPT_NAME'		: UserInfo.deptName,
						
						'POSTIT_YN'		: 'N',
						'CUSTOM_CODE'	: (selectedRecord && baseInfo.customCodeCopy == "Y") ? selectedRecord.get('CUSTOM_CODE'):'',
						'CUSTOM_NAME'	: (selectedRecord && baseInfo.customCodeCopy == "Y") ? selectedRecord.get('CUSTOM_NAME'):'',
						'INPUT_PATH'	: Ext.isEmpty(selectedRecord) ? csINPUT_PATH :selectedRecord.get('INPUT_PATH'),
						'INPUT_USER_ID'	: Ext.isEmpty(selectedRecord) ? UserInfo.userID : selectedRecord.get('INPUT_USER_ID'),
						'CHARGE_CODE'	: panelSearch.getValue('CHARGE_CODE'),//Ext.isEmpty(selectedRecord) ? '${chargeCode}' :selectedRecord.get('CHARGE_CODE'),
						'INPUT_DIVI'	: Ext.isEmpty(selectedRecord) ? csINPUT_DIVI : selectedRecord.get('INPUT_DIVI'),
						'AUTO_SLIP_NUM'	: Ext.isEmpty(selectedRecord) ? '': selectedRecord.get('AUTO_SLIP_NUM'),
						'CLOSE_FG'		: Ext.isEmpty(selectedRecord) ? '': selectedRecord.get('CLOSE_FG'),
						'INPUT_DATE'	: Ext.isEmpty(selectedRecord) ? '': selectedRecord.get('INPUT_DATE'),
						'AP_DATE'		: Ext.isEmpty(selectedRecord) ? '': selectedRecord.get('AP_DATE'),
						'AP_USER_ID'	: Ext.isEmpty(selectedRecord) ? '': selectedRecord.get('AP_USER_ID'),
						'AP_CHARGE_CODE': Ext.isEmpty(selectedRecord) ? '': selectedRecord.get('AP_CHARGE_CODE'),
						'DRAFT_YN'		: Ext.isEmpty(selectedRecord) ? '': selectedRecord.get('DRAFT_YN'),
						'AGREE_YN'		: Ext.isEmpty(selectedRecord) ? '': selectedRecord.get('AGREE_YN')
					};
				}else {
					var salesRecord = salesGrid.getSelectedRecord();
					r = {
						'AC_DATE'		: UniDate.getDbDateStr(salesRecord.get('AC_DATE')),
						'AC_DAY'		: Ext.Date.format(salesRecord.get('AC_DATE'),'d'),
						'OLD_AC_DATE'	: UniDate.getDateStr(salesRecord.get('AC_DATE')),
						'IN_DIV_CODE'	: panelSearch.getValue('IN_DIV_CODE'),
						'IN_DEPT_CODE'	: panelSearch.getValue('IN_DEPT_CODE'),
						'IN_DEPT_NAME'	: panelSearch.getValue('IN_DEPT_NAME'),
						'SLIP_DIVI'		: '3',
						'DR_CR'			: '1',
						'AP_STS'		: '1',
						'CUSTOM_CODE'	: (salesRecord && baseInfo.customCodeCopy == "Y" ) ? salesRecord.get('CUSTOM_CODE'):'',
						'CUSTOM_NAME'	: (salesRecord && baseInfo.customCodeCopy == "Y" ) ? salesRecord.get('CUSTOM_NAME'):'',
						'DIV_CODE'		: UserInfo.divCode,//panelSearch.getValue('IN_DIV_CODE'),
						'DEPT_CODE'		: baseInfo.gsDeptCode,
						'DEPT_NAME'		: baseInfo.gsDeptName,
						
						//'DEPT_CODE'		: UserInfo.deptCode,
						//'DEPT_NAME'		: UserInfo.deptName,
						
						'POSTIT_YN'		: 'N',
						'INPUT_PATH'	: csINPUT_PATH,
						'INPUT_DIVI'	: csINPUT_DIVI,
						'INPUT_USER_ID'	: UserInfo.userID,
						'CHARGE_CODE'	: '${chargeCode}'
					};
				}
			}
			if(!needNewSlipNum && selectedRecord   ) {
				// 전표번호는 선택된 record의 전표번호 사용
				grid.createRow(r,'AC_DAY');
				if(activeTabId == 'agjTab2' ) {
					var aGrid = this.getActiveGrid();
					var rec = aGrid.getSelectedRecord();
					rec.set('SLIP_NUM', r.SLIP_NUM);
				}
				addLoading = false;
			}else if(needNewSlipNum) {
				Ext.getBody().mask('Loading');
				// 전표번호 생성
				agj100ukrService.getSlipNum({'EX_DATE':UniDate.getDbDateStr(r.AC_DATE)}, function(provider, result ) {
					var aGrid = grid;
					var store = grid.getStore();
					var fiteredData = Ext.Array.push(store.data.filterBy(function(record){return UniDate.getDbDateStr(record.get('AC_DAY')) == UniDate.getDbDateStr((r.AC_DAY)) }).items);
					console.log("fiteredData : ", fiteredData);
					var maxData = Ext.Array.max(fiteredData, function(a,b) { return b.get('SLIP_NUM')-a.get('SLIP_NUM') ;})
					//console.log("maxData : ", maxData);
					var maxSlipNum = Ext.isEmpty(maxData) ? 1: maxData.get('SLIP_NUM')+1;
					if(provider.SLIP_NUM) {
						r.SLIP_NUM = maxSlipNum >= provider.SLIP_NUM ? maxSlipNum+1:provider.SLIP_NUM;
						r.SLIP_SEQ = 1;
						r.DIV_CODE = UserInfo.divCode;//panelSearch.getValue('IN_DIV_CODE');
						r.INPUT_PATH = csINPUT_PATH;
						r.OLD_SLIP_NUM = provider.SLIP_NUM;
						r.OLD_SLIP_SEQ = 1;
					}
					aGrid.createRow(r,'AC_DAY');
					if(activeTabId == 'agjTab2' ) {
						var aGrid = UniAppManager.app.getActiveGrid();
						var rec = aGrid.getSelectedRecord();
						rec.set('SLIP_NUM', r.SLIP_NUM);
					}
					Ext.getBody().unmask();
					addLoading = false;
				});
			}
		},
		fnSetBillDate: function(record) {
			var sExDate   = UniDate.getDbDateStr(record.get('AC_DATE'));
			var sSpecDivi =  record.get('SPEC_DIVI');
			if( sSpecDivi == "F1" || sSpecDivi == "F2" ) {
				this.fnSetAcCode(record, "I3", sExDate)
			}
		},
		fnSetAcCode:function(record, acCode, acValue, acNameValue) {
			var sValue =  !Ext.isEmpty(acValue)  ? acValue.toString(): "";
			var sNameValue = !Ext.isEmpty(acNameValue)  ? acNameValue.toString():"";
			var form = this.getActiveForm();
			for(var i=1 ; i <= 6; i++) {
				if( record.get('AC_CODE'+i.toString()) == acCode) {
					if(record.get('AC_TYPE'+i.toString()) == 'N'){
						if(isNaN(sValue)) sValue = 0;
					}
					record.set('AC_DATA'+i.toString(), sValue);
					record.set('AC_DATA_NAME'+i.toString(), sNameValue);
					form.setActiveRecord(record);
					form.setValue('AC_DATA'+i.toString(), sValue);
					var dataField = form.getField('AC_DATA'+i.toString());
					if(dataField) dataField.fireEvent('blur', dataField, sValue)
					form.setValue('AC_DATA_NAME'+i.toString(), sNameValue);
					var dataNameField = form.getField('AC_DATA_NAME'+i.toString());
					if(dataNameField) dataNameField.fireEvent('change', dataNameField, sNameValue)
				}
			}
		},
		fnFindInputDivi:function(record) {
			var grid = this.getActiveGrid()
			var fRecord = grid.getStore().getAt(grid.getStore().findBy(function(rec){
							return (rec.get('AC_DATE') == record.get('AC_DATE')
									&& rec.get('SLIP_NUM') == record.get('SLIP_NUM')
									&& rec.get('SLIP_SEQ') != record.get('SLIP_SEQ')) ;
						}));
			if(fRecord) {
				gsInputDivi = fRecord.get('INPUT_DIVI');
			}
		},
		fnGetProofKind:function(record, billType) {
			var sSaleDivi, sProofKindSet, sBillType = billType;

			if(record.get("DR_CR") == "1" && record.get("SPEC_DIVI") == "F1") {
				sSaleDivi = "1"	;	// 매입
				if(sBillType == "")  sBillType = "51";

			}else if(record.get("DR_CR") == "2" && record.get("SPEC_DIVI") == "F2") {
				sSaleDivi = "2"		// 매출
				if(sBillType == "" ) sBillType == "11";

			}else {
				record.set("PROOF_KIND", "");
				record.set("PROOF_KIND_NM", "");
				return;
			}
			sProofKindSet = this.fnGetProofKindName(sBillType, sSaleDivi)

			record.set('PROOF_KIND', sProofKindSet.sBillType);
			record.set('PROOF_KIND_NM', sProofKindSet.sProofKindNm);
		},
		fnGetProofKindName:function(sBillType, sSaleDivi) {
			var sProofKindNm;
			var store = Ext.StoreManager.lookup("CBS_AU_A022");
			var selRecordIdx = store.findBy(function(record){return (record.get("value") == sBillType && record.get("refCode3")==sSaleDivi)});
			var selRecord = store.getAt(selRecordIdx);
			if(selRecord) sProofKindNm = 	selRecord.get("text");

			if(!sProofKindNm || sProofKindNm == "") {
				if(sSaleDivi == "2") {
					sBillType = "11"
				}else {
					sBillType = "51"
				}
				selRecordIdx = store.findBy(function(record){return (record.get("value") == sBillType && record.get("refCode3")==sSaleDivi)});
				selRecord = store.getAt(selRecordIdx);
				if(selRecord) sProofKindNm = selRecord.get("text");
			}
			return {"sBillType":sBillType, "sProofKindNm":sProofKindNm};
		},
		fnCheckPendYN: function(record, form) {
			if(baseInfo.gsPendYn == "1") {
				if(record.get('PEND_YN') == 'Y') {
					if(record.get('DR_CR') != record.get('JAN_DIVI') ) {
						alert(Msg.sMA0278);
						this.clearAccntInfo(record, form);
					}
				}
			}
		},
		fnChangeAcEssInput:function(record) {
			Ext.getBody().mask();
			var accnt = record.get('ACCNT');
			UniAccnt.fnIsCostAccnt(accnt, true);
			if(accnt) {
				accntCommonService.fnGetAccntInfo({'ACCNT_CD':accnt}, function(provider, response){
					var rtnRecord = record.obj ? record.obj:record;
					if(provider ){
						var detailForm = UniAppManager.app.getActiveForm();
						UniAppManager.app.loadDataAccntInfo(rtnRecord, detailForm, provider)
					}else {
						alert(Msg.sMA0006);
					}
					Ext.getBody().unmask();
				})
			}
		},
		fnSetDefaultAcCodeI7:function(record, newValue) {
			var specDivi = record.get("SPEC_DIVI");
			if(specDivi != "F1" && specDivi != "F2" ) {
				return;
			}

			// 증빙유형의 참조코드1 설정값 가져오기
			if(record.get('PROOF_KIND') != "") {
				var defaultValue, defaultValueName;
				var param = {
					'MAIN_CODE':'A022',
					'SUB_CODE' : Ext.isEmpty(newValue) ? record.get('PROOF_KIND'):newValue,
					'field' : 'refCode1'
				};

				defaultValue = UniAccnt.fnGetRefCode(param);
				if(defaultValue == 'A' ||  defaultValue == 'C' || defaultValue == 'D' || defaultValue == 'B' ) {
						defaultValue = "Y"
				} else {
						defaultValue = "N"
				}

				var param2 = {
					'MAIN_CODE':'A149',
					'SUB_CODE' : defaultValue,
					'field' : 'text'
				};
				defaultValueName = UniAccnt.fnGetRefCode(param2);
				var form = this.getActiveForm();
				// 전자발행여부 default 설정
				for(var i =1 ; i <= 6; i++) {
					if(record.get('AC_CODE'+i.toString()) == "I7" ) {
						record.set('AC_DATA'+i.toString(), defaultValue);
						record.set('AC_DATA_NAME'+i.toString(), defaultValueName);
						form.setValue('AC_DATA'+i.toString(), defaultValue);
						form.setValue('AC_DATA_NAME'+i.toString(), defaultValueName);
					}
				};

			}
		},
		fnSetDefaultAcCodeA6:function(record) {
			if(baseInfo.gbAutoMappingA6 != "Y" ) {
				return;
			}
			var form = this.getActiveForm();
			for(var i =1 ; i <= 6; i++) {
				if(record.get('AC_CODE'+i.toString()) == "A6" ) {
					record.set('AC_DATA'+i.toString(), baseInfo.gsChargePNumb);
					record.set('AC_DATA_NAME'+i.toString(), baseInfo.gsChargePName);
					form.setValue('AC_DATA'+i.toString(), baseInfo.gsChargePNumb);
					form.setValue('AC_DATA_NAME'+i.toString(), baseInfo.gsChargePName);
				}
			}
		},
		fnSetDefaultAcCodeI5:function(record, newValue) {
			var form = this.getActiveForm();
			var proofKind = newValue ? newValue : record.get("PROOF_KIND");
			for(var i =1 ; i <= 6; i++) {
				if(record.get('AC_CODE'+i.toString()) == "I5" ) {
					if(Ext.isEmpty(record.get('AC_DATA'+i.toString())) && !Ext.isEmpty(proofKind)) {
						record.set('AC_DATA'+i.toString(), proofKind);
						form.setValue('AC_DATA'+i.toString(), proofKind);
					} else if(!Ext.isEmpty(record.get('AC_DATA'+i.toString())) && Ext.isEmpty(proofKind)) {
						record.set("PROOF_KIND", record.get('AC_DATA'+i.toString()));
						record.set("REASON_CODE", '');
						record.set("CREDIT_NUM", '');
						record.set("CREDIT_NUM_EXPOS", '');
						
					}else {
						record.set('AC_DATA'+i.toString(), proofKind);
						form.setValue('AC_DATA'+i.toString(), proofKind);
						record.set("PROOF_KIND", proofKind);
						record.set("REASON_CODE", '');
						record.set("CREDIT_NUM", '');
						record.set("CREDIT_NUM_EXPOS", '');
					}
					var defaultValue = record.get('AC_DATA'+i.toString())
					var param = {
						'MAIN_CODE':'A022',
						'SUB_CODE' : defaultValue,
						'field' : 'text'
					};
					defaultValueName = UniAccnt.fnGetRefCode(param);
					record.set('AC_DATA_NAME'+i.toString(), defaultValueName);
					form.setValue('AC_DATA_NAME'+i.toString(), defaultValueName);
				}
			}
		},
		fnCheckNoteAmt:function(grid, record, damt, dOldAmt) {
			var lAcDataCol;
			var sSpecDivi, sDrCr;
			var isNew = false;
			var activeTab = tab.getActiveTab();
			var activeTabId = activeTab.getItemId();

			if(activeTabId == 'agjTab1' ) {
				for(var i =1 ; i <= 6 ; i++) {
					if('C2' == record.get('AC_CODE'+i.toString())) {
						lAcDataCol = "AC_DATA"+i.toString()
					}
				}
				// 부도어음일 때 어음번호를 관리하지 않을 수 있다.
				if(Ext.isEmpty(lAcDataCol)) {
					isNew = true;
					this.fnSetTaxAmt(record);
					return
				}

			}
			if(Ext.isEmpty(record.get(lAcDataCol))) {
				isNew = true;
				this.fnSetTaxAmt(record);
				return;
			}
			sSpecDivi = record.get('SPEC_DIVI');
			sDrCr =  record.get('DR_CR');
			var noteNum = record.get(lAcDataCol);
			UniAccnt.fnGetNoteAmt(UniAppManager.app.cbCheckNoteAmt,noteNum, 0,0, record.get('PROOF_KIND'), damt, dOldAmt, record )
		},
		fnSetTaxAmt:function(record, taxRate, proofKind, amt_i) {
			return;
			var dSupplyAmt, sProofKind, dTaxRate, dTaxAmt=0;
			if(record.get('SPEC_DIVI') != 'F1' && record.get('SPEC_DIVI') != 'F2') {
				return;
			}

			if(amt_i) {
				dTaxAmt = amt_i;
			}else if(record.get("DR_CR")== "1") {
				dTaxAmt = record.get("DR_AMT_I");
			}else {
				dTaxAmt = record.get("CR_AMT_I");
			}

			if(taxRate) {
				dTaxRate = taxRate
			}else {
				var param={
					'MAIN_CODE':'A022',
					'SUB_CODE':proofKind ? proofKind:record.get('PROOF_KIND'),
					'field':'refCode2'
				}
				dTaxRate = UniAccnt.fnGetRefCode(param);
			}
			if(dTaxRate != 0){
				dSupplyAmt = dTaxAmt * parseInt(dTaxRate);
				this.fnSetAcCode(record, "I1", dSupplyAmt)	// 공급가액
				this.fnSetAcCode(record, "I6", dTaxAmt)		// 세액'
			}
		},
		fnCalTaxAmt:function(record) {
			UniAccnt.fnGetTaxRate(UniAppManager.app.cbGetTaxAmtForSales, record)
		},
		fnProofKindPopUp:function(record, newValue, gridId) {
			var proofKind = newValue ? newValue : record.get("PROOF_KIND");
			// 증빙유형 - 증빙사유 코드 팝업
			//comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입불공제사유', 'AU', 'A070', 'VALUE');
			//creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null, null, null, null,  'VALUE')
			//openCrediNotWin(record);
			
			//고정자산
			if(proofKind == "55" || proofKind == "61" || proofKind == "68" || proofKind == "69" ) {
				openAsstInfo(record);
			}
			//매입세액불공제/고정자산매입(불공)
			if(proofKind == "54" || proofKind == "61" ) {
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');
				record.set('CREDIT_NUM', '');

			//신용카드매입/신용카드매입(고정자산)/신용카드(의제매입)/신용카드(불공제)
			}else if(proofKind == "53" || proofKind == "68" || proofKind == "64") {
				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null, "CREDIT_NUM",  null, null, null, 'VALUE', gridId);
				record.set("REASON_CODE",  "");

			//현금영수증매입/현금영수증(고정자산)/현금영수증(불공제)
			}else if (proofKind == '62' ||proofKind == '69' ) {
				openCrediNotWin(record);
				record.set("REASON_CODE", '');
				
			//신용카드매입(불공제)
			}else if (proofKind == "70" ) {
				//openCrediNotWin(record);
				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null,  "CREDIT_NUM", null, null, null,  'VALUE', gridId);
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');

			//현금영수증(불공제)
			} else if(proofKind == "71" ) {
				openCrediNotWin(record);
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');
				//creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_NUM'), "CREDIT_NUM", null, null, null, null,  'VALUE');

			//카드과세/면세/영세
			} else if( proofKind >= "13" && proofKind <= "17") {
				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null, "CREDIT_NUM", null, null, null, 'VALUE', gridId);
				record.set("REASON_CODE", '');
			//고정자산정보
			} else if(proofKind == "55"  ) {
				//상단에서 호출
				//openAsstInfo(record);
			}else {
				record.set("REASON_CODE", '');
				record.set("CREDIT_NUM", '');
			}
			this.fnSetDefaultAcCodeI5(record, newValue);
		},
		cbGetTaxAmt:function(taxRate,  record) {
			if(taxRate != 0){
				var dTaxAmt=0;
				if(record.get("DR_CR")== "1") {
					dTaxAmt = record.get("DR_AMT_I");
				}else {
					dTaxAmt = record.get("CR_AMT_I");
				}
				dSupplyAmt = dTaxAmt * dTaxRate;

				this.fnSetAcCode(record, "I1", dSupplyAmt)	// 공급가액
				this.fnSetAcCode(record, "I6", dTaxAmt)		// 세액'
			}
		},
		cbGetTaxAmtForSales:function(taxRate,  record) {
			var dSupplyAmt=record.get("SUPPLY_AMT_I"), sProofKind=record.get("PROOF_KIND");
			var dTmpSupplyAmt, dTaxAmt;

			if(sProofKind == "24" || sProofKind == "13" || sProofKind == "14" ) {
				dTmpSupplyAmt = dSupplyAmt / ((100 + taxRate) * 0.01)
				dTaxAmt = Math.floor(dTmpSupplyAmt * taxRate * 0.01);
				dSupplyAmt = dSupplyAmt - dTaxAmt;
				record.set("SUPPLY_AMT_I",dSupplyAmt);
				record.set("TAX_AMT_I",dTaxAmt);
			}else {
				dTaxAmt = Math.floor(dSupplyAmt * taxRate * 0.01);
				record.set("TAX_AMT_I",dTaxAmt);
			}
		},
		cbGetExistsSlipNum:function(provider, fieldName, newValue, oldValue, record) {
			if(provider.CNT != 0) {
				alert(Msg.sMA0306);
				record.set('SLIP_NUM', oldValue);
				UniAppManager.app.fnFindInputDivi(record);
			}
		},
		cbCheckNoteAmt: function (rtn, newAmt,  oldAmt, record, fidleName) {
			var sSpecDivi = record.get("SPEC_DIVI");
			var sDrCr = record.get("DR_CR");
			var isNew = false;
			var aBankCd, aBankNm, aCustCd, aCustNm, aExpDate

			if(record) {
				var bankIdx = UniAccnt.findAcCode(record, "A3");
				 aBankCd = "AC_DATA"+bankIdx;
				 aBankNm = "AC_DATA_NAME"+bankIdx;

				var custIdx = UniAccnt.findAcCode(record, "A4");
				 aCustCd = "AC_DATA"+custIdx;
				 aCustNm = "AC_DATA_NAME"+custIdx;

				var expDateIdx = UniAccnt.findAcCode(record, "C3");
				 aExpDate = "AC_DATA"+expDateIdx;
			}

			if(rtn) {
				if(rtn.NOTE_AMT == 0 ) {
					if( !( (sSpecDivi == "D1" && sDrCr == "1")
							|| (sSpecDivi == "D3" && sDrCr == "2")
						 )
					){
						record.set(fidleName, oldAmt);
						/*if(!Ext.isEmpty(aBankCd) ) record.set(aBankCd, '');
						if(!Ext.isEmpty(aBankNm) ) record.set(aBankNm, '');
						if(!Ext.isEmpty(aCustCd) ) record.set(aCustCd, '');
						if(!Ext.isEmpty(aCustNm) ) record.set(aCustNm, '');
						if(!Ext.isEmpty(aExpDate) ) record.set(aExpDate, '');*/
					}else {
						isNew = true;
					}
				}else {
					// 받을어음이 대변에 오고 결제금액을 입력하지 않았을때
					// 선택한 어음의 발행금액을 금액에 넣어준다.'
					if(Ext.isEmpty(newAmt)) {
						newAmt = 0;
					}
					if( (sSpecDivi == "D1" &&  sDrCr == "2") && newAmt ==0 ) {
						record.set("AMT_I", rtn.OC_AMT_I);
						isNew = true;
					}
					// 지급어음 or 부도어음이 차변에 오고 결제금액을 입력하지 않았을때
					// 선택한 어음의 발행금액을 금액에 넣어준다.
					else if( ((sSpecDivi == "D3" || sSpecDivi == "D4") && sDrCr == "1") && newAmt == 0 ) {
						record.set("AMT_I", rtn.OC_AMT_I);
						isNew = true;
					}
					// 받을어음, 부도어음이 차변에 오면 금액은 발행금액만 비교한다
					else if( (sSpecDivi == "D1" || sSpecDivi == "D4") && sDrCr == "1" ) {
						if(  rtn.OC_AMT_I != newAmt) {
							alert(Msg.sMA0330);
							record.set(fidleName, oldAmt);
							/*if(!Ext.isEmpty(aBankCd) ) record.set(aBankCd, '');
							if(!Ext.isEmpty(aBankNm) ) record.set(aBankNm, '');
							if(!Ext.isEmpty(aCustCd) ) record.set(aCustCd, '');
							if(!Ext.isEmpty(aCustNm) ) record.set(aCustNm, '');
							if(!Ext.isEmpty(aExpDate) ) record.set(aExpDate, '');*/
							return false;
						}else {
							isNew = true;
						}
					}else {
						// 어음 미결제 잔액 계산 (발행금액 - 반제금액)
						var dNoteAmtI = rtn.OC_AMT_I - rtn.J_AMT_I;
						// 반결제여부 확인
						if((dNoteAmtI - newAmt) > 0) {
							if(!confirm(Msg.sMA0330+'\n'+Msg.sMA0333)) {
								record.set(fidleName, oldAmt);
								/*if(!Ext.isEmpty(aBankCd) ) record.set(aBankCd, '');
								if(!Ext.isEmpty(aBankNm) ) record.set(aBankNm, '');
								if(!Ext.isEmpty(aCustCd) ) record.set(aCustCd, '');
								if(!Ext.isEmpty(aCustNm) ) record.set(aCustNm, '');
								if(!Ext.isEmpty(aExpDate) ) record.set(aExpDate, '');*/
								return false;
							}else {
								isNew = true;
							}
						}else if ((dNoteAmtI - newAmt)  < 0 ) {
							alert(Msg.sMA0332);
							record.set(fidleName, oldAmt);
							/*if(!Ext.isEmpty(aBankCd) ) record.set(aBankCd, '');
							if(!Ext.isEmpty(aBankNm) ) record.set(aBankNm, '');
							if(!Ext.isEmpty(aCustCd) ) record.set(aCustCd, '');
							if(!Ext.isEmpty(aCustNm) ) record.set(aCustNm, '');
							if(!Ext.isEmpty(aExpDate) ) record.set(aExpDate, '');*/
							return false;
						}else {
							isNew = true;
						}
					}
				}
				if(isNew){
					UniAppManager.app.fnSetTaxAmt(record, rtn.TAX_RATE);
				}
			}
			return true;
		},
		cbGetBillDivCode:function(billDivCode, record) {
			record.set('BILL_DIV_CODE', billDivCode)
		}
	});	// Main

	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid1,
		forms	: {'formA:':detailForm1},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(oldValue == newValue) {
				return true;
			}
			var rv = true;
			switch(fieldName) {
				case 'AC_DAY':
					if(Ext.isNumber(newValue)) {
						rv = Msg.sMA0076;
						return rv;
					}
					var sDate = newValue.length == 1 ? '0'+newValue : newValue;
					var acDate = UniDate.getMonthStr(panelSearch.getValue('AC_DATE_TO'))+sDate;
					if(acDate.length == 8 && Ext.Date.isValid(parseInt(acDate.substring(0,4)), parseInt(acDate.substring(4,6)),parseInt(acDate.substring(6,8)))) {
						if(newValue != sDate) record.set(fieldName, sDate);
						record.set('AC_DATE', UniDate.extParseDate(acDate));
						//var isNew=false;
						//if(directMasterStore1.getCount() == 1 && record.obj.phantom) {
						//	isNew=true;
						//}
						//if(UniAppManager.app.needNewSlipNum(this.grid, isNew) ) {
							Ext.getBody().mask();
							agj100ukrService.getSlipNum({'EX_DATE':acDate}, function(provider, result) {
								var rec = record;
								var tAcDate = acDate;
								var tSDate = sDate;
								if(provider.SLIP_NUM) {
									rec.set('SLIP_NUM', provider.SLIP_NUM);
									// 수정된 데이타의 경우 이전 전표번호가 같은 데이타인 경우 변견된 전표일자와
									// 전표번호로 변경해 준다.
									Ext.each(directMasterStore1.data.items, function(item, idx) {
										if(!Ext.isEmpty(rec.get('OLD_SLIP_NUM')) && UniDate.getDateStr( rec.get('OLD_AC_DATE')) == UniDate.getDateStr(item.get('OLD_AC_DATE')) && rec.get('OLD_SLIP_NUM') == item.get('OLD_SLIP_NUM')) {
											item.set('AC_DATE',tAcDate);
											item.set('AC_DAY',tSDate);
											item.set('SLIP_NUM',provider.SLIP_NUM);

											if(item.phantom) {
												item.set('OLD_AC_DATE',tAcDate);
												item.set('OLD_AC_DATE',tAcDate);
											}
										}
									})
								}
								if(record.obj.phantom) {
									record.set('OLD_AC_DATE', record.get('AC_DATE'));
								}
								UniAppManager.app.fnSetBillDate(record);
								UniAppManager.app.fnFindInputDivi(record);
								record.set('INPUT_DIVI',gsInputDivi);
								Ext.getBody().unmask();
							});
						/*}else {
							// 수정된 데이타의 경우 이전 전표번호가 같은 데이타인 경우 변견된 전표일자와 전표번호로
							// 변경해 준다.
							Ext.each(directMasterStore1.data.items, function(item, idx) {
								if(Ext.isEmpty(record.get('OLD_SLIP_NUM')) && record.get('OLD_SLIP_NUM') == item.get('OLD_SLIP_NUM')) {
									item.set('AC_DATE',acDate);
									item.set('AC_DAY',sDate);
									item.set('SLIP_NUM',record.get('SLIP_NUM'));

									if(item.phantom) {
										item.set('OLD_AC_DATE',tAcDate);
										item.set('OLD_AC_DATE',tAcDate);
									}
								}
							})
							if(record.obj.phantom) {
								record.set('OLD_AC_DATE', record.get('AC_DATE'));
							}
							UniAppManager.app.fnSetBillDate(record);
							UniAppManager.app.fnFindInputDivi(record);
							record.set('INPUT_DIVI', gsInputDivi);
						}*/
					} else {
						rv =Msg.sMA0076 ;
					}
				break;
				case 'SLIP_NUM' :
					if(oldValue != newValue) {
						if(!record.obj.phantom ) {
							UniAccnt.fnGetExistSlipNum(UniAppManager.app.cbGetExistsSlipNum, record, csSLIP_TYPE, record.get('AC_DATE'), newValue, oldValue);
						}else {
							record.set('OLD_SLIP_NUM', newValue);
						}
					}
				break;
				case 'SLIP_SEQ' :
					if(record.obj.phantom) {
						record.set('OLD_SLIP_SEQ', newValue);
					}
				break;
				case 'SLIP_DIVI':
					if(oldValue == newValue) {
						return rv;
					}
					if(newValue == "" ) {
						rv = false;
						return rv;
					}
					if(cashInfo && !Ext.isDefined(cashInfo.ACCNT) && (newValue == "1" || newValue =="2")) {
						rv = "현금계정이 없어 입금, 출금을 선택 할 수 없습니다.";
						return rv;
					}
					if (newValue == '2' || newValue == '3') {
						record.set('DR_CR','1');
						record.set('DR_AMT_I',record.get('CR_AMT_I'));
						record.set('CR_AMT_I',0);
						record.set('AMT_I',record.get('DR_AMT_I'));
					}else{
						record.set('DR_CR','2');
						record.set('CR_AMT_I',record.get('DR_AMT_I'));
						record.set('DR_AMT_I',0);
						record.set('AMT_I',record.get('CR_AMT_I'));
						sAccnt = record.get('ACCNT');
						UniAccnt.fnIsCostAccnt(sAccnt, false);
					}
					console.log("SLIP_DIVI change :", record)
					UniAppManager.app.fnCheckPendYN(record, detailForm1);
					record.set('PROOF_KIND','');
					record.set('PROOF_KIND_NM','');
					UniAppManager.app.fnChangeAcEssInput(record)

					if (oldValue == "3" || oldValue == "4" ) {
						if (newValue == "1" || newValue == "2") {
							record.set('ACCNT', '');
							record.set('ACCNT_NAME', '');
						}
					}
					if(newValue =="1") {
					} else if(newValue =="2") {
					}
					UniAppManager.app.fnSetBillDate(record);
					// 증빙유형의 참조코드1에 따라 전자발행여부 기본값 설정
					 UniAppManager.app.fnSetDefaultAcCodeI7(record)
					// 입력자의 사번을 이용해 관리항목(사번) 기본값 설정
					UniAppManager.app.fnSetDefaultAcCodeA6(record)
				break;
				case 'DR_AMT_I' :
					if(record.get('SLIP_DIVI') == '1' || record.get('SLIP_DIVI') == '4' ) {
						rv =false;
						return rv;
					}
					var specDivi = record.get("SPEC_DIVI");
					if(specDivi && specDivi.substring(0,1) == "D" ) {
						UniAppManager.app.fnCheckNoteAmt(this.grid, record, newValue, oldValue)
					}
					if(record.get('DR_CR') == '1') {
						record.set('AMT_I', newValue);
					}
					UniAppManager.app.fnSetTaxAmt(record, null, null, newValue)
				break;
				case 'CR_AMT_I' :
					if(record.get('SLIP_DIVI') == '2' || record.get('SLIP_DIVI') == '3' ) {
						rv =false;
						return rv;
					}
					var specDivi = record.get("SPEC_DIVI");
					if(specDivi && specDivi.substring(0,1) == "D" ) {
						UniAppManager.app.fnCheckNoteAmt(this.grid, record, newValue, oldValue)
					}
					if(record.get('DR_CR') == '2') {
						record.set('AMT_I', newValue);
					}
					UniAppManager.app.fnSetTaxAmt(record, null, null, newValue)
				break;
				case 'PROOF_KIND':
					record.set("REASON_CODE", '');
					record.set("CREDIT_NUM", '');
					record.set("CREDIT_NUM_EXPOS", '');
					UniAppManager.app.fnProofKindPopUp(record, newValue);
					UniAppManager.app.fnSetTaxAmt(record, null, newValue)
					// 증빙유형의 참조코드1에 따라 전자발행여부 기본값 설정
					UniAppManager.app.fnSetDefaultAcCodeI7(record, newValue)
				break;
				case 'DIV_CODE':
					UniAccnt.fnGetBillDivCode(UniAppManager.app.cbGetBillDivCode, record, newValue);
				break;
				case 'MONEY_UNIT':
					if(newValue != oldValue){
						if(!Ext.isEmpty(newValue)) {
							var agrid = this.grid
							agrid.mask();
							accntCommonService.fnGetExchgRate({
									'AC_DATE'	: UniDate.getDbDateStr(record.get('AC_DATE')),
									'MONEY_UNIT': newValue
								}, 
								function(provider, response){
									agrid.unmask();
									if(!Ext.isEmpty(provider['BASE_EXCHG'])) {
										record.set('EXCHG_RATE_O',provider['BASE_EXCHG'])
										var amtField = "DR_AMT_I";
										if(record.get("DR_CR") == '2') {
											amtField = "CR_AMT_I";
										}
										setForeignAmt(record.obj, newValue, provider['BASE_EXCHG'], record.get("FOR_AMT_I"), amtField);
									}
								}
							)
						}
					}
				break;
				case 'EXCHG_RATE_O':
						var amtField = "DR_AMT_I";
						if(record.get("DR_CR") == '2') {
						  amtField = "CR_AMT_I";
						}
						setForeignAmt(record.obj, record.get("MONEY_UNIT") , newValue, record.get("FOR_AMT_I"), amtField);
				break;
				case 'FOR_AMT_I':
						var amtField = "DR_AMT_I";
						if(record.get("DR_CR") == '2') {
						  amtField = "CR_AMT_I";
						}
						setForeignAmt(record.obj, record.get("MONEY_UNIT") , record.get("EXCHG_RATE_O"),  newValue, amtField);
				break;
				default:
				break;
			}
			return rv;
		}
	}); // validator01

	Unilite.createValidator('validator02', {
		store	: directMasterStore2,
		grid	: masterGrid2,
		forms	: {'formA:':saleDetailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(oldValue == newValue) {
				return true;
			}
			var rv = true;
			switch(fieldName) {
				case 'AC_DAY':
					if(!UniAccnt.isNumberString(newValue)) {
						rv = Msg.sMA0076;
						return rv;
					}
					var sDate = newValue.length == 1 ? '0'+newValue : newValue;
					var acDate = UniDate.getMonthStr(panelSearch.getValue('AC_DATE_TO'))+sDate;
					if(acDate.length == 8 && Ext.Date.isValid(parseInt(acDate.substring(0,4)), parseInt(acDate.substring(4,6)),parseInt(acDate.substring(6,8)))) {
						if(newValue != sDate) record.set(fieldName, sDate);
						record.set('AC_DATE', UniDate.extParseDate(acDate));

						var isNew=false;
						if(directMasterStore1.getCount() == 1 && record.obj.phantom) {
							isNew=true;
						}
						if(UniAppManager.app.needNewSlipNum(this.grid, isNew) ) {
							Ext.getBody().mask();
							agj100ukrService.getSlipNum({'EX_DATE':acDate}, function(provider, result) {
								var rec = record;
								var tAcDate = acDate;
								var tSDate = sDate;
								if(provider.SLIP_NUM) {
									rec.set('SLIP_NUM', provider.SLIP_NUM);
									// 수정된 데이타의 경우 이전 전표번호가 같은 데이타인 경우 변견된 전표일자와
									// 전표번호로 변경해 준다.
									Ext.each(directMasterStore1.data.items, function(item, idx) {
										if(Ext.isEmpty(rec.get('OLD_SLIP_NUM')) && rec.get('OLD_SLIP_NUM') == item.get('OLD_SLIP_NUM')) {
											item.set('AC_DATE',tAcDate);
											item.set('AC_DAY',tSDate);
											item.set('SLIP_NUM',provider.SLIP_NUM);

											if(item.phantom) {
												item.set('OLD_AC_DATE',tAcDate);
												item.set('OLD_AC_DATE',tAcDate);
											}
										}
									})
								}
								if(record.obj.phantom) {
									record.set('OLD_AC_DATE', record.get('AC_DATE'));
								}
								UniAppManager.app.fnSetBillDate(record);
								UniAppManager.app.fnFindInputDivi(record);
								record.set('INPUT_DIVI',gsInputDivi);
								Ext.getBody().unmask();
							});
						}else {
							// 수정된 데이타의 경우 이전 전표번호가 같은 데이타인 경우 변견된 전표일자와 전표번호로
							// 변경해 준다.
							Ext.each(directMasterStore1.data.items, function(item, idx) {
								if(Ext.isEmpty(record.get('OLD_SLIP_NUM')) && record.get('OLD_SLIP_NUM') == item.get('OLD_SLIP_NUM')) {
									item.set('AC_DATE',acDate);
									item.set('AC_DAY',sDate);
									item.set('SLIP_NUM',record.get('SLIP_NUM'));
									if(item.phantom) {
										item.set('OLD_AC_DATE',tAcDate);
									}
								}
							})
							if(record.obj.phantom) {
								record.set('OLD_AC_DATE', record.get('AC_DATE'));
							}
							UniAppManager.app.fnSetBillDate(record);
							UniAppManager.app.fnFindInputDivi(record);
							record.set('INPUT_DIVI', gsInputDivi);
						}
					} else {
						rv =Msg.sMA0076 ;
					}
				break;
				case 'SLIP_NUM' :
					if(!record.obj.phantom) {
						UniAccnt.fnGetExistSlipNum(UniAppManager.app.cbGetExistsSlipNum, record, csSLIP_TYPE, record.get('AC_DATE'), newValue, oldValue);
					}else {
						record.set('OLD_SLIP_NUM', newValue);
					}
				break;
				case 'SLIP_SEQ' :
					if(record.obj.phantom) {
						record.set('OLD_SLIP_SEQ', newValue);
					}
				break;
				case 'SLIP_DIVI':
					if(oldValue == newValue) {
						return rv;
					}
					if(newValue == "" ) {
						rv = false;
						return rv;
					}
					if (newValue == '2' || newValue == '3') {
						record.set('DR_CR','1');
						record.set('DR_AMT_I',record.get('CR_AMT_I'));
						record.set('CR_AMT_I',0);
						record.set('AMT_I',record.get('DR_AMT_I'));
					}else{
						record.set('DR_CR','2');
						record.set('CR_AMT_I',record.get('DR_AMT_I'));
						record.set('DR_AMT_I',0);
						record.set('AMT_I',record.get('CR_AMT_I'));
						sAccnt = record.get('ACCNT');
						UniAccnt.fnIsCostAccnt(sAccnt, false);
					}
					console.log("SLIP_DIVI change :", record)
					UniAppManager.app.fnCheckPendYN(record, this.forms.formA);
					record.set('PROOF_KIND','');
					record.set('PROOF_KIND_NM','');
					UniAppManager.app.fnChangeAcEssInput(record)

					if (oldValue == "3" || oldValue == "4" ) {
						if (newValue == "1" || newValue == "2") {
							record.set('ACCNT', '');
							record.set('ACCNT_NAME', '');
						}
					}
					if(newValue =="1") {
					} else if(newValue =="2") {
					}
					UniAppManager.app.fnSetBillDate(record);
					// 증빙유형의 참조코드1에 따라 전자발행여부 기본값 설정
					 UniAppManager.app.fnSetDefaultAcCodeI7(record)
					// 입력자의 사번을 이용해 관리항목(사번) 기본값 설정
					UniAppManager.app.fnSetDefaultAcCodeA6(record)
				break;
				case 'DR_AMT_I' :
					if(record.get('SLIP_DIVI') == '1' || record.get('SLIP_DIVI') == '4' ) {
						rv =false;
						return rv;
					}
					var specDivi = record.get("SPEC_DIVI");
					if(specDivi && specDivi.substring(0,1) == "D" ) {
						UniAppManager.app.fnCheckNoteAmt(this.grid, record, newValue, oldValue)
					}
					if(record.get('DR_CR') == '1') {
						record.set('AMT_I', newValue);
					}
					if(record.get("FOR_YN") =="Y") {
						//UniAppManager.app.fnForeignPopUp(record);
					}
					UniAppManager.app.fnSetTaxAmt(record);
				break;
				case 'CR_AMT_I' :
					if(record.get('SLIP_DIVI') == '2' || record.get('SLIP_DIVI') == '3' ) {
						rv =false;
						return rv;
					}
					var specDivi = record.get("SPEC_DIVI");
					if(specDivi && specDivi.substring(0,1) == "D" ) {
						UniAppManager.app.fnCheckNoteAmt(this.grid, record, newValue, oldValue)
					}
					if(record.get('DR_CR') == '2') {
						record.set('AMT_I', newValue);
					}
					UniAppManager.app.fnSetTaxAmt(record);
				break;
				case 'PROOF_KIND':
					record.set("REASON_CODE", '');
					record.set("CREDIT_NUM", '');
					record.set("CREDIT_NUM_EXPOS", '');
					UniAppManager.app.fnProofKindPopUp(record, newValue, this.grid.getId());
					UniAppManager.app.fnSetTaxAmt(record)
					// 증빙유형의 참조코드1에 따라 전자발행여부 기본값 설정
					UniAppManager.app.fnSetDefaultAcCodeI7(record, newValue)
				break;
				case 'DIV_CODE':
					UniAccnt.fnGetBillDivCode(UniAppManager.app.cbGetBillDivCode, record, newValue);
				break;
				case 'MONEY_UNIT':
					if(newValue != oldValue){
						if(!Ext.isEmpty(newValue)) {
							var agrid = this.grid
							agrid.mask();
							accntCommonService.fnGetExchgRate({
									'AC_DATE'	: UniDate.getDbDateStr(record.get('AC_DATE')),
									'MONEY_UNIT': newValue
								}, 
								function(provider, response){
									agrid.unmask();
									if(!Ext.isEmpty(provider['BASE_EXCHG'])) {
										record.set('EXCHG_RATE_O',provider['BASE_EXCHG'])
										var amtField = "DR_AMT_I";
										if(record.get("DR_CR") == '2') {
											amtField = "CR_AMT_I";
										}
										setForeignAmt(record.obj, newValue, provider['BASE_EXCHG'], record.get("FOR_AMT_I"), amtField);
									}
								}
							)
						}
					}
					break;
				case 'EXCHG_RATE_O':
						var amtField = "DR_AMT_I";
						if(record.get("DR_CR") == '2') {
						  amtField = "CR_AMT_I";
						}
						setForeignAmt(record.obj, record.get("MONEY_UNIT") , newValue, record.get("FOR_AMT_I"), amtField);
				break;
				case 'FOR_AMT_I':
						var amtField = "DR_AMT_I";
						if(record.get("DR_CR") == '2') {
							amtField = "CR_AMT_I";
						}
						setForeignAmt(record.obj, record.get("MONEY_UNIT") , record.get("EXCHG_RATE_O"),  newValue, amtField);
				break;
				default:
				break;
			}
			return rv;
		}
	}); // validator02

	Unilite.createValidator('validator03', {
		store	: salesStore,
		grid	: salesGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(oldValue == newValue) {
				return true;
			}
			var rv = true;
			switch(fieldName) {
				case 'AC_DAY':
					if(!UniAccnt.isNumberString(newValue)) {
						rv = Msg.sMA0076;
						return rv;
					}
					var sDate = newValue.length == 1 ? '0'+newValue : newValue;
					var acDate = UniDate.getMonthStr(panelSearch.getValue('AC_DATE_TO'))+sDate;
					if(acDate.length == 8 && Ext.Date.isValid(parseInt(acDate.substring(0,4)), parseInt(acDate.substring(4,6)),parseInt(acDate.substring(6,8)))) {
						if(newValue != sDate) {
							record.set(fieldName, sDate);
						}
						record.set('AC_DATE', UniDate.extParseDate(acDate));
						if(record.obj.phantom) {
								record.set('OLD_AC_DATE',UniDate.getDateStr(UniDate.extParseDate(acDate)));
							}
						if(Ext.isEmpty(record.get('PUB_DATE'))) {
							record.set('PUB_DATE',UniDate.extParseDate(acDate));
							if(record.obj.phantom) {
								record.set('OLD_PUB_DATE',UniDate.getDateStr(UniDate.extParseDate(acDate)));
							}
						}
						var aGrid = UniAppManager.app.getActiveGrid();
						Ext.each(aGrid.getStore().data.items, function(rec, idx){
							rec.set('AC_DAY', newValue);
							rec.set('AC_DATE',UniDate.extParseDate(acDate));
						})
					} else {
						rv =Msg.sMA0076 ;
					}
				break;
				case 'PUB_DATE' :
					if(record.obj.phantom) {
						record.set('OLD_PUB_DATE',UniDate.extParseDate(newValue));
					}
					Ext.getBody().mask();
					agj100ukrService.getPubNum({'PUB_DATE':UniDate.getDateStr(newValue)}, function(provider, result ) {
						var record = salesGrid.getSelectedRecord();
						record.set("PUB_NUM", provider.PUB_NUM);
						Ext.getBody().unmask();
					});
				break;
				case 'SALE_DIVI' :
					if(oldValue != newValue) {
						record.set('PROOF_KIND','');
						record.set('PROOF_KIND_NM','');
						record.set('BUSI_TYPE','');
						record.set('BUSI_TYPE_NM','');
					}
				break;
				case 'SUPPLY_AMT_I':
					if(oldValue != newValue) {
						UniAppManager.app.fnCalTaxAmt(record)
					}
				break;
				case 'PROOF_KIND':
					record.set("REASON_CODE", '');
					record.set("CREDIT_NUM", '');
					record.set("CREDIT_NUM_EXPOS", '');
					UniAppManager.app.fnProofKindPopUp(record, newValue, this.grid.getId());
					UniAppManager.app.fnSetTaxAmt(record, null, newValue)
					// 증빙유형의 참조코드1에 따라 전자발행여부 기본값 설정
					UniAppManager.app.fnSetDefaultAcCodeI7(record, newValue)
				break;
				case 'DIV_CODE':
					UniAccnt.fnGetBillDivCode(UniAppManager.app.cbGetBillDivCode, record, newValue);
				break;
				default:
				break;
			}
			return rv;
		}
	}); // validator02
}; // main
</script>