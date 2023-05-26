<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="acm200ukr"  > 
	<t:ExtComboStore comboType="BOR120" /><!-- 사업장	-->  
	<t:ExtComboStore comboType="AU" comboCode="A011" />   
	<t:ExtComboStore comboType="AU" comboCode="A005" />		
	<t:ExtComboStore comboType="AU" comboCode="A022" /><!-- 매입증빙유형-->
	<t:ExtComboStore comboType="AU" comboCode="B004" />	 
	<t:ExtComboStore comboType="AU" comboCode="A003" />  

	<t:ExtComboStore comboType="AU" comboCode="A014" /><!--승인상태-->  
	<t:ExtComboStore comboType="AU" comboCode="A012" />	
	<t:ExtComboStore comboType="AU" comboCode="B013" />
	<t:ExtComboStore comboType="AU" comboCode="A058" />
	<t:ExtComboStore comboType="AU" comboCode="A149" />	
	<t:ExtComboStore comboType="AU" comboCode="A070" />
	<t:ExtComboStore comboType="AU" comboCode="A084" />
</t:appConfig>
<script type="text/javascript" >
var detailWin;
var csINPUT_DIVI	 = "1";		//1:결의전표/2:결의전표(전표번호별)
var csSLIP_TYPE		 = "1";		//1:회계전표/2:결의전표
var csSLIP_TYPE_NAME = "회계전표";
var csINPUT_PATH	 = 'C1';
var gsInputPath, gsInputDivi, gsDraftYN	;
var tab;
var postitWindow;				// 각주팝업
var creditNoWin;				// 신용카드번호 & 현금영수증 팝업
var comCodeWin ;				// A070 증빙유형팝업
var creditWIn;					// 신용카드팝업
var printWin;					//전표출력팝업
var foreignWindow;				//외화금액입력
var gsBankBookNum ,gsBankName;
var taxWindow;
var autoAccntPopupWin;			//자동분개팝업
var asstInfoWindow;
var addLoading = false;			// 전표번호 생성 flag
var slipNumMessageWin;
var gsNewData;

function appMain() {
	
	var gsSlipNum 		= "";	// 링크로 넘어오는 Slip_NUM
	var gsProcessPgmId	= "";	// Store 에서 링크로 넘어온 Data 값 체크 하기 위해 전역변수 사용
	
	var baseInfo = {
		gsLocalMoney		: '${gsLocalMoney}',
		gsBillDivCode		: '${gsBillDivCode}',
		gsPendYn			: '${gsPendYn}',
		gsChargePNumb		: '${gsChargePNumb}',
		gsChargePName		: '${gsChargePName}',
		gbAutoMappingA6		: '${gbAutoMappingA6}',		// '결의전표 관리항목 사번에 로그인정보 자동매핑함
		gsDivChangeYN		: '${gsDivChangeYN}',		// '귀속부서 입력시 사업장 자동 변경 사용여부
		gsRemarkCopy		: '${gsRemarkCopy}',		// '전표_적요 copy방식_적요 빈 값 상태에서
		gsDivUseYN			: '${gsDivUseYN}',			// 사업장 입력조건 사용여부
		gsAmtEnter			: '${gsAmtEnter}',			// '전표_금액이 0이면 마지막 행에서
		gsAmtPoint			:  ${gsAmtPoint},			// 외화금액 format
		gsChargeDivi		: '${gsChargeDivi}',
		customCodeCopy		: '${customCodeCopy}',
		customCodeAutoPopup	: '${customCodeAutoPopup}' == 'Y' ? true : false,
		profitEarnAccnt		: '${profitEarnAccnt}',
		profitLossAccnt		: '${profitLossAccnt}'
	}
	
	var hideDivCode = true;
	if(baseInfo.gsDivUseYN =="Y") {
		hideDivCode = false;
	}
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			  read : 'acm200ukrService.selectList'
			, update : 'acm200ukrService.update'
			, create : 'acm200ukrService.insert'
			, destroy:'acm200ukrService.delete'
			, syncAll:'acm200ukrService.saveAll'
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
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
			items:[
				{		
					fieldLabel: '승인일',
					xtype: 'uniDateRangefield',
					startFieldName: 'AP_DATE_FR',
					endFieldName: 'AP_DATE_TO',
					startDate:UniDate.get('yesterday'),	// '20130801', //
					endDate: UniDate.get('today'),		// '20130808', //
					allowBlank:false,				 
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('AP_DATE_FR', newValue);
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('AP_DATE_TO', newValue);
						}
					}
				},{
					fieldLabel:'카드번호/카드명',
					name : 'CREDIT_NUM',
					xtype: 'uniTextfield' ,
					width:300,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('CREDIT_NUM', newValue);
						}
					}
				},{
					fieldLabel:'기표구분',
					//name : 'SLIP_YN',
					xtype: 'radiogroup',
					fieldLabel: '조회구분',
					items: [{
						boxLabel: '전체', 
						width: 50, 
						name: 'SLIP_YN',
						inputValue: 'A'
					},{
						boxLabel : '미기표', 
						width: 70,
						name: 'SLIP_YN',
						inputValue: 'N'
					},{
						boxLabel : '기표', 
						width: 70,
						name: 'SLIP_YN',
						inputValue: 'Y'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							//panelResult.setValue('SLIP_YN', newValue);
							panelResult.getField('SLIP_YN').setValue(newValue.SLIP_YN);
						}
					}
				},{
					fieldLabel: '입력경로',
					name: 'INPUT_PATH',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'A011',
					hidden:true,
					readOnly: true,
					value:'C1',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('INPUT_PATH', newValue);
						},
						specialkey: function(elm, e){
							lastFieldSpacialKey(elm, e);
						}
					}
					
				},Unilite.popup('ACCNT_PRSN', {
					fieldLabel: '입력자',
					valueFieldName:'CHARGE_CODE',
					textFieldName:'CHARGE_NAME',
					allowBlank:false,
					textFieldWidth:150,
					hidden:true,
					readOnly: true,
					showValue:false
				}),{
					fieldLabel: '사업장',
					name: 'IN_DIV_CODE',	 
					xtype: 'uniCombobox' ,
					comboType: 'BOR120',
					value : UserInfo.divCode,
					hidden:hideDivCode,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						},
						specialkey: function(elm, e){
							lastFieldSpacialKey(elm, e)
						}
					}
				},{
					fieldLabel: '회계담당자',
					name: 'AUTHORITY',	
					value:baseInfo.gsChargeDivi,
					hidden:true
				},{
					fieldLabel:'결의부서',
					name : 'IN_DEPT_CODE',
					hidden:true,
					value:UserInfo.deptCode,
					width:150
				}
			]
		}]
	});	//end panelSearch
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:0,
		border:true,
		items: [{
			fieldLabel: '승인일',
			xtype: 'uniDateRangefield',
			startFieldName: 'AP_DATE_FR',
			endFieldName: 'AP_DATE_TO',
			startDate:  UniDate.get('yesterday'),	//'20130801', //
			endDate:  UniDate.get('today'),			//'20130831', //
			width: 350,
			allowBlank:false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('AP_DATE_FR', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('AP_DATE_TO', newValue);
				}
			}
		},{
			fieldLabel:'카드번호/카드명',
			name : 'CREDIT_NUM',
			xtype: 'uniTextfield' ,
			width:300,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CREDIT_NUM', newValue);
				}
			}
		},{
			fieldLabel:'기표구분',
			//name : 'SLIP_YN',
			
			xtype: 'radiogroup',
			fieldLabel: '조회구분',
			items: [{
				boxLabel: '전체', 
				width: 50, 
				name: 'SLIP_YN',
				inputValue: 'A'
			},{
				boxLabel : '미기표', 
				width: 70,
				name: 'SLIP_YN',
				inputValue: 'N'
			},{
				boxLabel : '기표', 
				width: 70,
				name: 'SLIP_YN',
				inputValue: 'Y'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelSearch.setValue('SLIP_YN', newValue);
					panelSearch.getField('SLIP_YN').setValue(newValue.SLIP_YN);
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'table', columns : 2},
			tdAttrs	: {align: 'right'},
			width	: 150,
			items	: [{
				xtype	: 'button',
				text	: '<div style="color: blue">매핑</div>',
				width	: 60,
				handler	: function(){
					if(panelSearch.getForm().isValid()) {
						var param = panelSearch.getValues();
						var me = this;
						Ext.app.REMOTING_API['timeout'] = 600;	// milliseconds
						panelSearch.getEl().mask('<t:message code="system.label.inventory.loading" default="로딩중..."/>','loading-indicator');
						acm200ukrService.fnAcmcarMapping(param, function(provider, response) {
							Unilite.messageBox('매핑작업이 완료 되었습니다.');
							panelSearch.getEl().unmask()
						});
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]
		},{
			fieldLabel: '입력경로',
			name: 'INPUT_PATH',		
			xtype: 'uniCombobox' ,
			comboType: 'AU',
			comboCode: 'A011',
			value:'C1',
			hidden:true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INPUT_PATH', newValue);
				},
				specialkey: function(elm, e){
					lastFieldSpacialKey(elm, e);
				}
			}
			
		},Unilite.popup('ACCNT_PRSN', {
			fieldLabel: '입력자',
			valueFieldName:'CHARGE_CODE',
			textFieldName:'CHARGE_NAME',
			allowBlank:false,
			textFieldWidth:150,
			readOnly: true,
			showValue:false,
			hidden:true
		}),{
			fieldLabel: '사업장',
			name: 'IN_DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			value : UserInfo.divCode,
			hidden:hideDivCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				},
				specialkey: function(elm, e){
					lastFieldSpacialKey(elm, e)
				}
			}
		},{
			fieldLabel: '회계담당자',
			name: 'AUTHORITY' ,	
			value:baseInfo.gsChargeDivi,
			hidden:true
		},{
			fieldLabel:'결의부서',
			name : 'IN_DEPT_CODE',
			hidden:true,
			value:UserInfo.deptCode,
			width:150
		}]
	});	//end panelSearch  

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
					if((hideDivCode && elm.name == 'INPUT_PATH') || elm.name == 'DIV_CODE'){
						var grid = UniAppManager.app.getActiveGrid();
						var record = grid.getStore().getAt(0);
						if(record) {
							e.stopEvent();
							grid.editingPlugin.startEdit(record,grid.getColumn('AC_DAY'))
						}else {
							UniAppManager.app.onNewDataButtonDown();
						}
					}else {
						if(e.shiftKey && !e.ctrlKey && !e.altKey) {
							Unilite.focusPrevField(elm, true, e);
						}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
							Unilite.focusNextField(elm, true, e);
						}
					}
				}
			}
		
	}
	
	
//차대변 구분 전표
<%@include file="./acmSlip.jsp" %> 
<%@include file="./acmGridConfig.jsp" %> 	
	/**
	 * 매입매출전표  Store
	 */
	var activeGrid = 'acm200ukrSalesGrid'
	var directMasterStore2 = Unilite.createStore('acm200ukrMasterStore2',getStoreConfig('acm200ukrGrid2','acm200ukrSaleDetailForm'));
		
	/**
	 * 매입매출전표  Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid2 = Unilite.createGrid('acm200ukrGrid2', getGridConfig(directMasterStore2, 'acm200ukrGrid2','acm200ukrSaleDetailForm', 0.25, false,'3'));

	var detailForm1 = Unilite.createForm('acm200ukrDetailForm1',  getAcFormConfig('acm200ukrDetailForm1',salesGrid ));
	
	/**
	* 매출/매입 전표 Detail 정보 모델
	*/
	Unilite.defineModel('acm200ukrSaleModel', {
		// pkGen : user, system(default)
		fields: [ 		
				  {name: 'AC_DAY'			,text:'일자'			,type : 'string'}
				, {name: 'SLIP_YN'			,text:'생성여부'		,type : 'string', editable:false}
				,{name: 'CRDT_NAME'			,text:'카드명'			,type : 'string', editable:false}
				,{name: 'CRDT_NUM'			,text:'법인카드'		,type : 'string', editable:false}
				,{name: 'PERSON_NUMB'		,text:'사번'			,type : 'string', editable:false}
				,{name: 'NAME'				,text:'성명'			,type : 'string', editable:false}
				,{name: 'CREDIT_NUM'		,text:'카드번호'		,type : 'string', editable:false}
				,{name: 'CREDIT_NUM_EXPOS'	,text:'카드번호'		,type : 'string', editable:false, defaultValue:'***************'}
				,{name: 'CREDIT_NUM_MASK'	,text:'카드번호'		,type : 'string', editable:false, defaultValue:'***************'}
				,{name: 'PUB_DATE'			,text:'승인일'			,type : 'uniDate', editable:false}
				,{name: 'APPR_TIME'			,text:'승인시간'		,type : 'string', editable:false}
				,{name: 'CANCEL_YN'			,text:'취소여부'		,type : 'string', editable:false}
				,{name: 'CHAIN_NAME'		,text:'가맹점명'		,type : 'string', editable:false}
				,{name: 'SUPPLY_AMT_I'		,text:'공급가액'		,type : 'uniPrice', defaultValue:0, editable:false}
				,{name: 'TAX_AMT_I'			,text:'부가세'			,type : 'uniPrice', defaultValue:0, editable:false}
				,{name: 'APPR_AMT_I'		,text:'합계금액'		,type : 'uniPrice', defaultValue:0, editable:false}
				,{name: 'DR_ACCNT'			,text:'차변계정코드'		,type : 'string', allowBlank:false}
				,{name: 'DR_ACCNT_NAME'		,text:'차변계정과목명'		,type : 'string', allowBlank:false}
				,{name: 'CR_ACCNT'			,text:'대변계정코드'		,type : 'string', allowBlank:false}
				,{name: 'CR_ACCNT_NAME'		,text:'대변계정과목명'		,type : 'string', allowBlank:false}
				,{name: 'CUSTOM_CODE'		,text:'거래처'			,type : 'string', allowBlank:false}
				,{name: 'CUSTOM_NAME'		,text:'거래처명'		,type : 'string', allowBlank:false}
				,{name: 'PROOF_KIND_NM'		,text:'증빙유형명'		,type : 'string'}
				,{name: 'PROOF_KIND'		,text:'증빙유형'		,type : 'string', comboType:'AU', comboCode:'A022'}
				,{name: 'DEPT_CODE'			,text:'귀속부서'		,type : 'string', defaultValue: UserInfo.deptCode, allowBlank:false}
				,{name: 'DEPT_NAME'			,text:'귀속부서'		,type : 'string', defaultValue: UserInfo.deptName}
				,{name: 'DIV_CODE'			,text:'귀속사업장'		,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode, allowBlank:false}
				,{name: 'AC_DATE'			,text:'회계전표일자'		,type : 'uniDate', editable:false}
				,{name: 'SLIP_NUM'			,text:'전표번호'		,type : 'int', editable:false}
				,{name: 'SLIP_SEQ'			,text:'순번'			,type : 'int', editable:false}
				,{name: 'SALE_DIVI'			,text:'매입'			,type : 'string', allowBlank:false ,comboType: 'AU',	comboCode: 'A003'}
				,{name: 'REASON_CODE'		,text:'불공제사유코드'		,type : 'string'}
				,{name: 'REMARK'			,text:'적요'			,type : 'string' }
				,{name: 'BILL_DIV_CODE'		,text:'신고사업장코드'		,type : 'string', defaultValue: UserInfo.divCode}
				,{name: 'OLD_AC_DATE'		,text:'OLD_AC_DATE'	,type : 'uniDate'}
				,{name: 'OLD_SLIP_NUM'		,text:''			,type : 'int'}
				,{name: 'OLD_PUB_DATE'		,text:''			,type : 'uniDate'}
				,{name: 'IN_DIV_CODE'		,text:'결의사업장코드'		,type : 'string', defaultValue: UserInfo.divCode}
				,{name: 'IN_DEPT_CODE'		,text:'결의부서코드'		,type : 'string', defaultValue: UserInfo.deptCode}
				,{name: 'IN_DEPT_NAME'		,text:'결의부서명'		,type : 'string', defaultValue: UserInfo.deptName}
				,{name: 'APPR_NO'			,text:'APPR_NO'		,type : 'string'}		//20210728 추가
				// 20210708 추가
				,{name: 'SLIP_CUSTOM_CODE'	,text:'거래처'			,type : 'string'}
				,{name: 'SLIP_CUSTOM_NAME'	,text:'거래처명'		,type : 'string'}
		]
	});
	
	/**
	 * 매입매출전표  Store
	 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'acm200ukrService.selectSalesList',
			update : 'acm200ukrService.update',
			create : 'acm200ukrService.insert',
			destroy:'acm200ukrService.delete',
			syncAll:'acm200ukrService.saveAll'
		}
	});
	var salesStore = Unilite.createStore('acm200ukrSalesStore',{
			model: 'acm200ukrSaleModel',
			autoLoad: false,
			uniOpt : {
				isMaster: false,		// 상위 버튼 연결 
				editable: true,			// 수정 모드 사용 
//				allDeletable:true,			// 삭제 가능 여부 
				useNavi : true			// prev | next 버튼 사용
			},
			proxy: directProxy2
			
			// Store 관련 BL 로직
			// 검색 조건을 통해 DB에서 데이타 읽어 오기 
			,loadStoreRecords : function(params) {
				if(Ext.isEmpty(params)){
					var param= Ext.getCmp('searchForm').getValues();
				}else{
					var param = params	
				}
				
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
					Unilite.messageBox(Msg.sMB083);
				}
			}
//			,
//			listeners:{
//				update:function( store, record, operation, modifiedFieldNames, details, eOpts) {
//					if(!directMasterStore2.isDirty()) {
//						UniAppManager.setToolbarButtons('save', false);
//					}
//				}
//			}
		});
		
	/**
	 *  매출/매입 전표 Detail  Grid 정의(Grid Panel)
	 * @type 
	 */
	var salesGrid = Unilite.createGrid('acm200ukrSalesGrid', {
		region		: 'center',
//		region:'north',
//		width		: '100%',
//		height		: '50%',
		itemId: 'acm200ukrSalesGrid',
		uniOpt:{
			expandLastColumn: false,
			useMultipleSorting: false,
			useNavigationModel:false,
			nonTextSelectedColumns:['REMARK']
		},
		border:true,
		store: salesStore,
		features:  [ 
			{id:  'masterGridSubTotal', ftype:  'uniGroupingsummary', showSummaryRow:  true },
			{id:  'masterGridTotal', 	ftype:  'uniSummary'		, showSummaryRow:  true} 
		],
		columns:[
			{
				xtype:'actioncolumn',
				text:'전표생성',
				width:80,
				align:'center',
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
						var model = grid.getSelectionModel();
						
						if(record.get('SLIP_YN') == 'Y') {
							alert('이미 전표가 생성되었습니다.');
							return;
						}
						
						gsNewData = rowIndex;
						
						if(masterGrid2.getStore().getCount() > 0) {
							//masterGrid2.getStore().removeAll();
							directMasterStore2.loadData({});
							saleDetailForm.clearForm();
							saleDetailForm.down('#formFieldArea1').removeAll();
						}
						
						if(record.isValid()) {
							var param = record.getData();
							param.INPUT_PATH = panelSearch.getValue('INPUT_PATH');
							param.AC_DATE =  UniDate.getDateStr(param.PUB_DATE);
							
							Ext.getBody().mask();
							acm200ukrService.fnGetAutoMethod(param, function(provider, response){
							
								if(provider.length > 0) {
									//masterGrid2.getStore().removeAll();
									var salesRecord = record;
									salesRecord.set("SLIP_NUM", provider[0].SLIP_NUM);
									
									Ext.each(provider, function(providerRec, idx) {
										
										var r = {
											'AC_DATE':salesRecord.get('PUB_DATE'),
											'AC_DAY':salesRecord.get('AC_DAY'),
											'SLIP_NUM' : providerRec.SLIP_NUM,
											'SLIP_SEQ' : idx+1,
											
											'IN_DIV_CODE':(baseInfo.gsDivUseYN =="Y") ? panelSearch.getValue('DIV_CODE') : UserInfo.divCode,
											'IN_DEPT_CODE':UserInfo.deptCode,
											'IN_DEPT_NAME':UserInfo.deptName,
											
											'SLIP_DIVI':providerRec.SLIP_DIVI == '1' ? '3':'4',
											'DR_CR':providerRec.SLIP_DIVI == '1' ? '1':'2',
											'AP_STS':'1',
											'DIV_CODE':panelSearch.getValue('DIV_CODE'),
											'DEPT_CODE':UserInfo.deptCode,
											'DEPT_NAME':UserInfo.deptName,
											'POSTIT_YN':'N',
											'INPUT_PATH':csINPUT_PATH,
											'INPUT_USER_ID':UserInfo.userID,
											'CHARGE_CODE':panelSearch.getValue('CHARGE_CODE'),
											'AP_DATE':UniDate.get('today'),
											'AP_USER_ID':UserInfo.userID,
											'AP_CHARGE_CODE':panelSearch.getValue('CHARGE_CODE'),
											
											'OLD_AC_DATE':UniDate.getDateStr(salesRecord.get('AC_DATE')),
											'OLD_SLIP_NUM' : providerRec.SLIP_NUM,
											'OLD_SLIP_SEQ' :idx+1,
											
											'CUSTOM_CODE' : providerRec.SLIP_DIVI == '1' ? salesRecord.get('CUSTOM_CODE') : salesRecord.get('SLIP_CUSTOM_CODE'),
											'CUSTOM_NAME' : providerRec.SLIP_DIVI == '1' ? salesRecord.get('CUSTOM_NAME') : salesRecord.get('SLIP_CUSTOM_NAME')
										};
										masterGrid2.createRow(r);
										var newRecord = masterGrid2.getSelectedRecord();
										UniAppManager.app.loadDataAccntInfo(newRecord, saleDetailForm, providerRec);
										
										
										/* newRecord.set('CUSTOM_CODE', salesRecord.get('CUSTOM_CODE'));
										newRecord.set('CUSTOM_NAME', salesRecord.get('CUSTOM_NAME')); */
										
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
										if(["54", "61", "70", "71"].indexOf(salesRecord.get('PROOF_KIND')) >= 0) {
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
//											newRecord.set("ASST_SUPPLY_AMT_I", salesRecord.get("ASST_SUPPLY_AMT_I"));
//											newRecord.set("ASST_TAX_AMT_I", salesRecord.get("ASST_TAX_AMT_I"));
//											newRecord.set("ASST_DIVI", salesRecord.get("ASST_DIVI"));
											newRecord.set("ASST_SUPPLY_AMT_I", 0);
											newRecord.set("ASST_TAX_AMT_I", 0);
											newRecord.set("ASST_DIVI", 0);
										}
										newRecord.set("REMARK", salesRecord.get("CHAIN_NAME")); // 20210728 REMARK(적요) => CHAIN_NAME(가맹점명
										
										newRecord.set("DIV_CODE", salesRecord.get("DIV_CODE"));
										newRecord.set("DEPT_CODE", salesRecord.get("DEPT_CODE"));
										newRecord.set("DEPT_NAME", salesRecord.get("DEPT_NAME"));
										newRecord.set("BILL_DIV_CODE", salesRecord.get("BILL_DIV_CODE"));
										
										UniAppManager.app.fnSetAcCode(newRecord, "A4",  salesRecord.get("CUSTOM_CODE"),  salesRecord.get("CUSTOM_NAME"));
										
										UniAppManager.app.fnSetAcCode(newRecord, "I1",  salesRecord.get("SUPPLY_AMT_I"));
										UniAppManager.app.fnSetAcCode(newRecord, "I2",  salesRecord.get("BILL_DIV_CODE"));
										UniAppManager.app.fnSetAcCode(newRecord, "I3",  UniDate.getDateStr(salesRecord.get("PUB_DATE")));
										UniAppManager.app.fnSetAcCode(newRecord, "I6",  salesRecord.get("TAX_AMT_I"));
										
										UniAppManager.app.fnSetAcCode(newRecord, "G5",  salesRecord.get("CRDT_NUM")		, salesRecord.get("CRDT_NAME"));
										UniAppManager.app.fnSetAcCode(newRecord, "A6",  salesRecord.get("PERSON_NUMB")	, salesRecord.get("NAME"));
										
										//증빙유형의 참조코드1에 따라 전자발행여부 기본값 설정
										UniAppManager.app.fnSetDefaultAcCodeI7(newRecord);
										
									})
								}
								Ext.getBody().unmask();
							})
						}else {
							salesGrid.uniSelectInvalidColumnAndAlert([record]);
						}
						
					}
				}
				]
			}
			, { dataIndex: 'SLIP_YN'		, width: 70		, align:'center'}
			, { dataIndex: 'AC_DAY'			, width: 50		, align:'center', hidden:true} 
			, { dataIndex: 'CRDT_NAME'		, width: 150 } 
			, { dataIndex: 'PUB_DATE'		, width: 100	, align:'center' } 
			, { dataIndex: 'CHAIN_NAME'		, width: 120 } 
			, { dataIndex: 'SUPPLY_AMT_I'	, width: 100	, summaryType: 'sum'}
			, { dataIndex: 'TAX_AMT_I'		, width: 80		, summaryType: 'sum'}
			, { dataIndex: 'APPR_AMT_I'		, width: 100	, summaryType: 'sum'}
			, { dataIndex: 'SALE_DIVI'		, width: 100	, hidden:true }
			, { dataIndex: 'SLIP_NUM'		, width: 100	, hidden:true}
			, { dataIndex: 'DR_ACCNT'		, width: 100	, align:'center',
					editor:Unilite.popup('ACCNT_AC_G', {
						autoPopup: true,
						textFieldName:'DR_ACCNT',
						DBtextFieldName: 'DR_ACCNT_CODE',
						listeners:{
							scope:this,
							onSelected:function(records, type ) {	
								salesGrid.uniOpt.currentRecord.set('DR_ACCNT', records[0].ACCNT_CODE);
								salesGrid.uniOpt.currentRecord.set('DR_ACCNT_NAME', records[0].ACCNT_NAME);
								
//								UniAppManager.app.loadDataAccntInfo(salesGrid.uniOpt.currentRecord, detailForm1, records[0]);
							},
							onClear:function(type)  {
								UniAppManager.app.clearAccntInfo(salesGrid.uniOpt.currentRecord, detailForm1);
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
									var param = {
										'RDO': '3',
										'TXT_SEARCH': popup.textField.getValue(),
										'CHARGE_CODE':panelSearch.getValue('CHARGE_CODE'),
										'ADD_QUERY':"SLIP_SW = N'Y' AND GROUP_YN = N'N'"
									}
									popup.setExtParam(param);
								}
							}
						}
					})
			}
			, { dataIndex: 'DR_ACCNT_NAME'	,width: 130 ,
					editor:Unilite.popup('ACCNT_AC_G', {
						autoPopup: true,
						listeners:{
							scope:this,
							onSelected:function(records, type ) {
								salesGrid.uniOpt.currentRecord.set('DR_ACCNT', records[0].ACCNT_CODE);
								salesGrid.uniOpt.currentRecord.set('DR_ACCNT_NAME', records[0].ACCNT_NAME);
//								UniAppManager.app.loadDataAccntInfo(salesGrid.uniOpt.currentRecord, detailForm1, records[0]);
							},
							onClear:function(type)  {
								UniAppManager.app.clearAccntInfo(salesGrid.uniOpt.currentRecord, detailForm1);
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
							
								var param = {
									'RDO': '4',
									'TXT_SEARCH': popup.textField.getValue(),
									'CHARGE_CODE':panelSearch.getValue('CHARGE_CODE'),
									'ADD_QUERY':"SLIP_SW = N'Y' AND GROUP_YN = N'N'"
								}
								popup.setExtParam(param);
								}
							}
						}
						
					})
			}
			, { dataIndex: 'CR_ACCNT'		,width: 100 , align:'center',
					editor:Unilite.popup('ACCNT_AC_G', {
						autoPopup: true,
						textFieldName:'CR_ACCNT',
						DBtextFieldName: 'CR_ACCNT_CODE',
						listeners:{
							scope:this,
							onSelected:function(records, type ) {
								
								salesGrid.uniOpt.currentRecord.set('CR_ACCNT', records[0].ACCNT_CODE);
								salesGrid.uniOpt.currentRecord.set('CR_ACCNT_NAME', records[0].ACCNT_NAME);
								
//								UniAppManager.app.loadDataAccntInfo(salesGrid.uniOpt.currentRecord, detailForm1, records[0]);
							},
							onClear:function(type)  {
								UniAppManager.app.clearAccntInfo(salesGrid.uniOpt.currentRecord, detailForm1);
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
									var param = {
										'RDO': '3',
										'TXT_SEARCH': popup.textField.getValue(),
										'CHARGE_CODE':panelSearch.getValue('CHARGE_CODE'),
										'ADD_QUERY':"SLIP_SW = N'Y' AND GROUP_YN = N'N'"
									}
									popup.setExtParam(param);
								}
							}
						}
					})
			}
			, { dataIndex: 'CR_ACCNT_NAME'	,width: 130 ,
					editor:Unilite.popup('ACCNT_AC_G', {
						autoPopup: true,
						listeners:{
							scope:this,
							onSelected:function(records, type ) {
								salesGrid.uniOpt.currentRecord.set('CR_ACCNT', records[0].ACCNT_CODE);
								salesGrid.uniOpt.currentRecord.set('CR_ACCNT_NAME', records[0].ACCNT_NAME);
//								UniAppManager.app.loadDataAccntInfo(salesGrid.uniOpt.currentRecord, detailForm1, records[0]);
							},
							onClear:function(type)  {
								UniAppManager.app.clearAccntInfo(salesGrid.uniOpt.currentRecord, detailForm1);
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
							
								var param = {
									'RDO': '4',
									'TXT_SEARCH': popup.textField.getValue(),
									'CHARGE_CODE':panelSearch.getValue('CHARGE_CODE'),
									'ADD_QUERY':"SLIP_SW = N'Y' AND GROUP_YN = N'N'"
								}
								popup.setExtParam(param);
								}
							}
						}
						
					})} 					
			, { dataIndex: 'CUSTOM_CODE',  width: 80 ,
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
						}
					})
			} 
			, { dataIndex: 'CUSTOM_NAME',  width: 130 ,
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
						}
					})
			}
			, { dataIndex: 'PROOF_KIND',  width: 110, 
			 		editor:{
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
			, { dataIndex: 'CREDIT_NUM_MASK',  width: 130 } 
			, { dataIndex: 'CREDIT_NUM',  width: 130 , hidden:true}
			, { dataIndex: 'REMARK',  width: 150 , hidden:true,
					editor:Unilite.popup('REMARK_G',{
						textFieldName:'REMARK',
						validateBlank:false,
		 				autoPopup: false,
						listeners:{
							'onSelected':function(records, type) {
								var selectedRec = salesGrid.getSelectedRecord();
								selectedRec.set('REMARK', records[0].REMARK_NAME);
								
							},
							'onClear':function(type) {
								var selectedRec = salesGrid.getSelectedRecord();
							}
						}
					})
				}
			, { dataIndex: 'DEPT_NAME',  width: 100 ,
					editor:Unilite.popup('DEPT_G',{
						showValue:false,
						autoPopup: true,
						listeners:{
							'onSelected':function(records, type) {
								
								var selectedRec = salesGrid.getSelectedRecord();
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
			, { dataIndex: 'DIV_CODE',  width: 120 }
		],
		listeners:{
			beforedeselect: function (grid, record, index, eOpts) {
				var updateRecords=salesStore.getUpdatedRecords( );
				var removedRecords=salesStore.getRemovedRecords( );
				var changedRec = [].concat(updateRecords).concat(removedRecords)
				if(directMasterStore2.isDirty()) {
					if(confirm('저장할 데이타가 있습니다. 저장하시겠습까?')) {
						UniApp.app.onSaveDataButtonDown();
						//return false;
					}
					return true;
				}
				else if(changedRec.length > 0 ) {
					if(confirm('저장할 데이타가 있습니다. 저장하시겠습까?')) {
						UniApp.app.onSaveDataButtonDown();
						//return false;
					} 
					return true;
				}
			},
			selectionChange: function( gird, selected, eOpts ) {
				if(selected && selected.length > 0 && !selected[0].phantom) {
					var param = {
						'INPUT_PATH'	:panelSearch.getValue('INPUT_PATH'),
						//'CHARGE_CODE'	:panelSearch.getValue('CHARGE_CODE'),
						'IN_DEPT_CODE'	:panelSearch.getValue('IN_DEPT_CODE'),
						'IN_DIV_CODE'	:panelSearch.getValue('IN_DIV_CODE'),
						'AC_DATE_FR'	:UniDate.getDbDateStr(selected[0].get('AC_DATE')),
						'AC_DATE_TO'	:UniDate.getDbDateStr(selected[0].get('AC_DATE')),
						'SLIP_NUM'		:selected[0].get('SLIP_NUM')
					}
					directMasterStore2.loadStoreRecords(param);
				} else if(selected && selected.length > 0 && selected[0].phantom) {
					directMasterStore2.loadData({});
					saleDetailForm.clearForm();
					saleDetailForm.down('#formFieldArea1').removeAll();
				}
			},
			render: function(grid, eOpts){
				grid.getEl().on('click', function(e, t, eOpt) {
					activeGrid = grid.getItemId();
//					if(salesStore.getData().items.length > 0) {
//						UniAppManager.setToolbarButtons('deleteAll',true);
//					}
				});
			}, 
			celldblclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				
				if(cellIndex==8) {
					creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null, "CREDIT_NUM", null, null, null, 'VALUE','acm200ukrSalesGrid');			
				}
			},
			cellkeydown:function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {					
				if(e.getKey() == 13) {
					enterNavigation(e);
				}
				
			},
			edit:function() {
				if(!directMasterStore2.isDirty()) {
					UniAppManager.setToolbarButtons('save', false);
					salesStore.commitChanges();
				}
			}
		}
	});
	
	
	var saleDetailForm = Unilite.createForm('acm200ukrSaleDetailForm',  getAcFormConfig('acm200ukrSaleDetailForm',masterGrid2) );
	
	Unilite.Main({
		borderItems:[ 
			panelSearch,
			{
			 	region:'center',
			 	layout: 'border',
			 	border: false,
			 	items:[
			 		panelResult, salesGrid,masterGrid2, saleDetailForm
			 	]	
			}
		],
		id  : 'acm200ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['reset', 'detail'],true);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AP_DATE_FR');
			
			panelSearch.setValue('CHARGE_CODE'	, '${chargeCode}');
			panelSearch.setValue('CHARGE_NAME'	, '${chargeName}');
			panelResult.setValue('CHARGE_CODE'	, '${chargeCode}');
			panelResult.setValue('CHARGE_NAME'	, '${chargeName}');

			panelSearch.setValue('AP_DATE_FR'	, UniDate.get('startOfYear'));
			panelSearch.setValue('AP_DATE_TO'	, UniDate.get('endOfYear'));
			//panelSearch.setValue('AP_DATE_FR'	, UniDate.get('yesterday'));
			//panelSearch.setValue('AP_DATE_TO'	, UniDate.get('today'));
			panelSearch.setValue('AUTHORITY'	, baseInfo.gsChargeDivi);
			panelSearch.setValue('IN_DEPT_CODE'	, UserInfo.deptCode);
			panelSearch.setValue('IN_DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('AP_DATE_FR'	, UniDate.get('startOfYear'));
			panelResult.setValue('AP_DATE_TO'	, UniDate.get('endOfYear'));
			//panelResult.setValue('AP_DATE_FR'	, UniDate.get('yesterday'));
			//panelResult.setValue('AP_DATE_TO'	, UniDate.get('today'));
			panelResult.setValue('AUTHORITY'	, baseInfo.gsChargeDivi);
			panelResult.setValue('IN_DEPT_CODE'	, UserInfo.deptCode);
			panelResult.setValue('IN_DIV_CODE'	, UserInfo.divCode);

			panelSearch.setValue('SLIP_YN'	, 'A');
			panelResult.setValue('SLIP_YN'	, 'A');
			
			if(Ext.isEmpty('${chargeCode}')) {
				Unilite.messageBox('회계담당자정보가 없습니다. 먼저 담당자 정보를 입력해주세요.');
			}

			if(params && params.PGM_ID) {
				this.processParams(params);
			}
		},

		onQueryButtonDown : function() {
			if(Ext.isEmpty('${chargeCode}')) {
				Unilite.messageBox('회계담당자정보가 없습니다. 먼저 담당자 정보를 입력해주세요.');
				return false;
			}
			if(!panelSearch.getInvalidMessage()) return;	//필수체크

				directMasterStore2.loadData({});
				saleDetailForm.down('#formFieldArea1').removeAll();
				salesStore.loadStoreRecords();
			
		},
		onSaveDataButtonDown: function (config) {
				directMasterStore2.saveStore(config);

		},
//		onDeleteDataButtonDown : function() {
//					masterGrid2.deleteSelectedRow();
//		},
		onDeleteAllButtonDown:function() {
			if(panelSearch.getValue('INPUT_PATH') != csINPUT_PATH) {
				Unilite.messageBox(Msg.sMA0353);
				return
			}
			if(confirm("같은 전표번호를 모두 삭제하시겠습니까?")) {
					var sel = masterGrid2.getSelectedRecord();
					var store = masterGrid2.getStore()
					var data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY')== sel.get('AC_DAY') && record.get('SLIP_NUM') == sel.get('SLIP_NUM')) } ).items);
					store.remove(data);
					salesGrid.getSelectedRecord().set("OPR_FLAG", "D");
//					var sm = salesGrid.getSelectionModel();
//					salesGrid.getStore().remove(sm.getSelection());
					saleDetailForm.down('#formFieldArea1').removeAll();
			}
		},
		onResetButtonDown:function() {
			gsSlipNum = "";
			gsProcessPgmId ="";
			
			masterGrid2.reset();
			masterGrid2.getStore().commitChanges();
			salesGrid.reset();
			salesGrid.getStore().commitChanges();
			saleDetailForm.clearForm();
			saleDetailForm.down('#formFieldArea1').removeAll();
			slipGrid1.reset();
			slipGrid2.reset();
			panelSearch.clearForm();
			panelResult.clearForm();
			params = {};
			this.fnInitBinding();
			this.setSearchReadOnly(false);
			panelSearch.getField('INPUT_PATH').setValue(csINPUT_PATH);
			panelResult.getField('INPUT_PATH').setValue(csINPUT_PATH);
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
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
				if(salesStore.isDirty() || directMasterStore2.isDirty()) {
					if(confirm(Msg.sMB061)) {
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
			
		},

		setSearchReadOnly:function(b) {

			panelSearch.getField('INPUT_PATH').setReadOnly(b);	
			panelResult.getField('INPUT_PATH').setReadOnly(b);
		},
		/** 
		 * 계정코드 선택 후 관련값 셋팅
		 */
		setAccntInfo:function(record, detailForm) {
			Ext.getBody().mask();
			var accnt = record.get('ACCNT');
			//UniAccnt.fnIsCostAccnt(accnt, true);
			if(!chkAcCode) {
				var slipDivi = rtnRecord.get('SLIP_DIVI');
				if(slipDivi == '1' || slipDivi == '2') {
					if(rtnRecord.get('SPEC_DIVI') == 'A') {
						Unilite.messageBox(Msg.sMA0040);
						this.clearAccntInfo(rtnRecord, detailForm);
					}
				}
			}else {
				this.loadDataAccntInfo(rtnRecord, detailForm, provider)
			}
		},
		loadDataAccntInfo:function(rtnRecord, detailForm, provider) {
			//관리항목 유무 
			var chkAcCode = false;
			for(var i=1; i <= 6 ; i++) {
				if(!Ext.isEmpty(rtnRecord.get('AC_CODE'+i.toString()))) {
					chkAcCode = true;
				}
			}
			if(!chkAcCode) {
				var slipDivi = rtnRecord.get('SLIP_DIVI');
				if(slipDivi == '1' || slipDivi == '2') {
					if(rtnRecord.get('SPEC_DIVI') == 'A') {
						Unilite.messageBox(Msg.sMA0040);
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
			UniAppManager.app.fnSetAcCode(rtnRecord, "I6", 0, null)	
			
			var dataMap = rtnRecord.data;
			UniAccnt.addMadeFields(detailForm, dataMap, detailForm, '', rtnRecord);
			detailForm.setActiveRecord(rtnRecord||null);
			if(rtnRecord.get("CUSTOM_CODE")) {
				this.fnSetAcCode(rtnRecord, "A4", rtnRecord.get("CUSTOM_CODE"), rtnRecord.get("CUSTOM_NAME"))
			}
			UniAppManager.app.fnCheckPendYN(rtnRecord, detailForm);
			UniAppManager.app.fnSetBillDate(rtnRecord)
			UniAppManager.app.fnSetDefaultAcCodeI7(rtnRecord);
			UniAppManager.app.fnSetDefaultAcCodeI5(rtnRecord);
		
		},
		/**
		 * 계정코드 값 삭제시 관련 값 삭제
		 */
		clearAccntInfo:function(record, detailForm){
			Ext.getBody().mask();
			record.set("ACCNT", "");
			record.set("ACCNT_NAME", "");
			/* record.set("CUSTOM_CODE", "");
			record.set("CUSTOM_NAME", ""); */ // 20210728 유영신이사님 요청사항으로 주석
			
			record.set("AC_CODE1", "");
			record.set("AC_CODE2", "");
			record.set("AC_CODE3", "");
			record.set("AC_CODE4", "");
			record.set("AC_CODE5", "");
			record.set("AC_CODE6", "");
			
			record.set("AC_NAME1", "");
			record.set("AC_NAME2", "");
			record.set("AC_NAME3", "");
			record.set("AC_NAME4", "");
			record.set("AC_NAME5", "");
			record.set("AC_NAME6", "");
			
			record.set("AC_DATA1", "");
			record.set("AC_DATA2", "");
			record.set("AC_DATA3", "");
			record.set("AC_DATA4", "");
			record.set("AC_DATA5", "");
			record.set("AC_DATA6", "");
			
			record.set("AC_DATA_NAME1", "");
			record.set("AC_DATA_NAME2", "");
			record.set("AC_DATA_NAME3", "");
			record.set("AC_DATA_NAME4", "");
			record.set("AC_DATA_NAME5", "");
			record.set("AC_DATA_NAME6", "");
			
			record.set("BOOK_CODE1", "");
			record.set("BOOK_CODE2", "");
			record.set("BOOK_DATA1", "");
			record.set("BOOK_DATA2", "");
			record.set("BOOK_DATA_NAME1", "");
			record.set("BOOK_DATA_NAME2", "");
			
			record.set("AC_CTL1", "");
			record.set("AC_CTL2", "");
			record.set("AC_CTL3", "");
			record.set("AC_CTL4", "");
			record.set("AC_CTL5", "");
			record.set("AC_CTL6", "");
			
			record.set("AC_TYPE1", "");
			record.set("AC_TYPE2", "");
			record.set("AC_TYPE3", "");
			record.set("AC_TYPE4", "");
			record.set("AC_TYPE5", "");
			record.set("AC_TYPE6", "");
			
			record.set("AC_LEN1", "");
			record.set("AC_LEN2", "");
			record.set("AC_LEN3", "");
			record.set("AC_LEN4", "");
			record.set("AC_LEN5", "");
			record.set("AC_LEN6", "");
			
			record.set("AC_POPUP1", "");
			record.set("AC_POPUP2", "");
			record.set("AC_POPUP3", "");
			record.set("AC_POPUP4", "");
			record.set("AC_POPUP5", "");
			record.set("AC_POPUP6", "");
			
			record.set("AC_FORMAT1", "");
			record.set("AC_FORMAT2", "");
			record.set("AC_FORMAT3", "");
			record.set("AC_FORMAT4", "");
			record.set("AC_FORMAT5", "");
			record.set("AC_FORMAT6", "");
		
			record.set("MONEY_UNIT", "");
			
			record.set("EXCHG_RATE_O", 0);
			record.set("FOR_AMT_I", 0);
			
			record.set("ACCNT_SPEC", "");
			record.set("SPEC_DIVI", "");
			record.set("PROFIT_DIVI", "");
			record.set("JAN_DIVI", "");
			
			record.set("PEND_YN", "");
			record.set("PEND_CODE", "");
			record.set("BUDG_YN", "");
			record.set("BUDGCTL_YN", "");
			record.set("FOR_YN", "");
			
			record.set("PROOF_KIND", "");
			record.set("PROOF_KIND_NM", "");
			
//			record.set("CREDIT_NUM", "");			//20210729 주석
//			record.set("CREDIT_CODE", "");			//20210729 주석
			record.set("REASON_CODE", "");
			detailForm.down('#formFieldArea1').removeAll();
			Ext.getBody().unmask();
		},
		getActiveForm:function() {
			var form;
			form = saleDetailForm;
			return form

		},
		getActiveGrid:function() {
			var grid;
			grid = masterGrid2;
			return grid
		},
		needNewSlipNum:function(grid, isAddRow) {
			var needNewSlipNum = false;
			var store = grid.getStore();
			var selectedRecord = grid.getSelectedRecord();
			var nextRecordIndex = store.indexOf(selectedRecord)+1;
			var nextRecord = store.getAt(nextRecordIndex);
			
			if((isAddRow && store.getCount() == 0 )) {	// 처름 행 추가 한
																	// 경우
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
			addLoading = true;
			
			var grid = this.getActiveGrid();
			var store = grid.getStore();
			
			var needNewSlipNum = UniAppManager.app.needNewSlipNum(grid, true);
			var selectedRecord = grid.getSelectedRecord();
			var nextRecordIndex = store.indexOf(selectedRecord)+1;
			var nextRecord = store.getAt(nextRecordIndex);
		
			var r = {};
			if(selectedRecord && !needNewSlipNum) {
				
				// 순번 생성
				var slipSeq = 1;
				var tAcDay = selectedRecord.get('AC_DAY');
				var tSlipNum = selectedRecord.get('SLIP_NUM');
				var slipArr = Ext.Array.push(store.data.filterBy(function(record) {
						return (	record.get('AC_DAY')== tAcDay  && record.get('SLIP_NUM')== tSlipNum ) 
					} ).items);
				if(slipArr.length > 0) {
					//Max SLIP_SEQ 를 구하기 위해 sort
					slipArr.sort(function(a,b){return b.get('SLIP_SEQ')-a.get('SLIP_SEQ') ;})	;
					slipSeq = slipArr[0].get('SLIP_SEQ') +1;
				} 
				// 순번 생성 End
				
				r = {
					'AC_DATE':selectedRecord.get('AC_DATE'),
					'AC_DAY':selectedRecord.get('AC_DAY'),
					'SLIP_NUM':selectedRecord.get('SLIP_NUM'),
					'SLIP_SEQ': slipSeq,
					
					'OLD_AC_DATE':selectedRecord.get('AC_DATE'),
					'OLD_SLIP_NUM':selectedRecord.get('SLIP_NUM'),
					'OLD_SLIP_SEQ': slipSeq,
					
					'IN_DIV_CODE':Ext.isEmpty(selectedRecord) ? UserInfo.divCode:selectedRecord.get("IN_DIV_CODE"),
					'IN_DEPT_CODE':Ext.isEmpty(selectedRecord) ? UserInfo.deptCode:selectedRecord.get("IN_DEPT_CODE"),
					'IN_DEPT_NAME':Ext.isEmpty(selectedRecord) ? UserInfo.deptName:selectedRecord.get("IN_DEPT_NAME"),
					
					'SLIP_DIVI':selectedRecord.get('SLIP_DIVI'),
					'DR_CR':selectedRecord.get('DR_CR'),
					
					'AP_STS':'1',
					'DIV_CODE':selectedRecord.get('DIV_CODE'),
					'DEPT_CODE':selectedRecord.get('DEPT_CODE'),
					'DEPT_NAME':selectedRecord.get('DEPT_NAME'),
					'DRAFT_YN':selectedRecord.get('DRAFT_YN'),
					'AGREE_YN':selectedRecord.get('AGREE_YN'),
					'CUSTOM_CODE'	: (Ext.isEmpty(selectedRecord) || baseInfo.customCodeCopy == "N" ) ? '': selectedRecord.get('CUSTOM_CODE'),
					'CUSTOM_NAME'	: (Ext.isEmpty(selectedRecord) || baseInfo.customCodeCopy == "N" ) ? '': selectedRecord.get('CUSTOM_NAME'),
					'POSTIT_YN':'N',
					'INPUT_PATH'	: Ext.isEmpty(selectedRecord) ? csINPUT_PATH : selectedRecord.get('INPUT_PATH'),
					'INPUT_USER_ID'	: UserInfo.userID,//Ext.isEmpty(selectedRecord) ? UserInfo.userID : selectedRecord.get('INPUT_USER_ID'),
					//'INPUT_DATE'	: Ext.isEmpty(selectedRecord) ? UniDate.get('today'): selectedRecord.get('INPUT_DATE'),
					'CHARGE_CODE'	: panelSearch.getValue("CHARGE_CODE"), //Ext.isEmpty(selectedRecord) ? '${chargeCode}' :selectedRecord.get('CHARGE_CODE'),
					
					'AP_DATE': Ext.isEmpty(selectedRecord) ? UniDate.get('today'):selectedRecord.get('AP_DATE'),
					'AP_USER_ID': Ext.isEmpty(selectedRecord) ? UserInfo.userID: selectedRecord.get('AP_USER_ID'),
					'AP_CHARGE_CODE':panelSearch.getValue("CHARGE_CODE")
					
				};
				
			}else {

					var salesRecord = salesGrid.getSelectedRecord();
					r = {
						'AC_DATE':UniDate.getDbDateStr(salesRecord.get('AC_DATE')),
						'AC_DAY': Ext.Date.format(salesRecord.get('AC_DATE'),'d'),
						
						'OLD_AC_DATE':UniDate.getDateStr(salesRecord.get('AC_DATE')),
						
						'IN_DIV_CODE':UserInfo.divCode,
						'IN_DEPT_CODE':UserInfo.deptCode,//panelSearch.getValue('DEPT_CODE'),
						'IN_DEPT_NAME':UserInfo.deptName,//panelSearch.getValue('DEPT_NAME'),
						
						'SLIP_DIVI':'3',
						'DR_CR':'1',
						'AP_STS':'1',
						'CUSTOM_CODE': (Ext.isEmpty(salesRecord) || baseInfo.customCodeCopy == "N" ) ? '':salesRecord.get('CUSTOM_CODE'),
						'CUSTOM_NAME': (Ext.isEmpty(salesRecord) || baseInfo.customCodeCopy == "N" ) ? '':salesRecord.get('CUSTOM_NAME'),
						'DIV_CODE':UserInfo.divCode,
						'DEPT_CODE':UserInfo.deptCode,
						'DEPT_NAME':UserInfo.deptName,
						'POSTIT_YN':'N',
						'INPUT_PATH':csINPUT_PATH,
						'INPUT_DIVI':csINPUT_DIVI,
						'INPUT_USER_ID':UserInfo.userID,
						'CHARGE_CODE':panelSearch.getValue("CHARGE_CODE"),
						'AP_DATE':UniDate.get('today'),
						'AP_USER_ID':UserInfo.userID,
						'AP_CHARGE_CODE':panelSearch.getValue("CHARGE_CODE")
					};
				} 
			
			
			
			if(!needNewSlipNum && selectedRecord   ) {
				// 전표번호는 선택된 record의 전표번호 사용
				grid.createRow(r, 'AC_DAY');

				addLoading = false;
				
			}else if(needNewSlipNum) {	
				Ext.getBody().mask('Loading');
				// 전표번호 생성
				acm200ukrService.getSlipNum({'AC_DATE':UniDate.getDbDateStr(r.AC_DATE)}, function(provider, result ) {
					var aGrid = grid;
					var store = grid.getStore();
					var maxSlipNum = store.max('SLIP_NUM')
					if(provider.SLIP_NUM) {
						r.SLIP_NUM = Ext.isDefined(maxSlipNum) && (maxSlipNum >= provider.SLIP_NUM) ? maxSlipNum+1:provider.SLIP_NUM;
						r.SLIP_SEQ = 1;
						r.DIV_CODE = UserInfo.divCode;
						r.INPUT_PATH = csINPUT_PATH;
						r.OLD_SLIP_NUM = provider.SLIP_NUM;
						r.OLD_SLIP_SEQ = 1;
					}
					aGrid.createRow(r, 'AC_DAY');
					Ext.getBody().unmask();
					addLoading = false;
					
				});	
			}				
			
		}
		,fnSetBillDate: function(record) {
			
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
					form.setValue('AC_DATA_NAME'+i.toString(), sNameValue);
				}
			}
		},
		fnFindInputDivi:function(record) {
			var grid = this.getActiveGrid()
			var fRecord = grid.getStore().getAt(grid.getStore().findBy(function(rec){
																				return (rec.get('AC_DATE') == record.get('AC_DATE') 
																						&& rec.get('SLIP_NUM') == record.get('SLIP_NUM') 
																						&& rec.get('SLIP_SEQ') != record.get('SLIP_SEQ')) ;
																			})
												);
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
					if( record.get('DR_CR') != record.get('JAN_DIVI') ) {
						Unilite.messageBox(Msg.sMA0278);
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
						UniAppManager.app.loadDataAccntInfo(rtnRecord, detailForm, provider);
					}else {
						Unilite.messageBox(Msg.sMA0006);
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
				if(defaultValue == 'A' ||  defaultValue == 'C' || defaultValue == 'D' || defaultValue == 'B') {
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
		fnSetDefaultAcCodeI5:function(record, newValue) {
			var form = this.getActiveForm();
			var proofKind = newValue ? newValue : record.get("PROOF_KIND");
			for(var i =1 ; i <= 6; i++) {
				if(record.get('AC_CODE'+i.toString()) == "I5" ) {
					if(Ext.isEmpty(record.get('AC_DATA'+i.toString())) && !Ext.isEmpty(proofKind)) {
						record.set('AC_DATA'+i.toString(), proofKind);
						form.setValue('AC_DATA'+i.toString(), proofKind);
					} else if(!Ext.isEmpty(record.get('AC_DATA'+i.toString())) &&Ext.isEmpty(proofKind)) {
						record.set("PROOF_KIND", record.get('AC_DATA'+i.toString()));
						record.set("REASON_CODE", '');
						record.set("CREDIT_NUM", '');
						record.set("CREDIT_NUM_EXPOS", '');
					} else {
						record.set('AC_DATA'+i.toString(), proofKind);
						form.setValue('AC_DATA'+i.toString(), proofKind);
						record.set("PROOF_KIND", proofKind);
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
			var activeForm = this.getActiveForm();
			//VAT 표시
			var suppAmtField = activeForm.getField("AC_DATA"+UniAccnt.findAcCode(record, "I1"))
			if(suppAmtField) suppAmtField.showVAT(suppAmtField, record);
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
		
			//고정자산
			if(proofKind == "55" || proofKind == "61" || proofKind == "68" || proofKind == "69" ) {
				openAsstInfo(record);
			}
			
			//매입세액불공제/고정자산매입(불공)
			if(proofKind == "54" || proofKind == "61" ) {
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');
				
			
			//신용카드매입/신용카드매입(고정자산)/신용카드(의제매입)/신용카드(불공제)
			}else if(proofKind == "53" || proofKind == "68" || proofKind == "64") {				
				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null, "CREDIT_NUM",null, null, null, 'VALUE', gridId);			
				
		
			//현금영수증매입/현금영수증(고정자산)/현금영수증(불공제)
			}else if (proofKind == '62' ||proofKind == '69' ) {				
				openCrediNotWin(record);				
				
			//신용카드매입(불공제)
			}else if (proofKind == "70" ) {			
				//openCrediNotWin(record);		
				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null,"CREDIT_NUM", null, null, null,  'VALUE', gridId);			
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');
				
			
			//현금영수증(불공제)
			} else if(proofKind == "71" ) {			
				openCrediNotWin(record);	
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');
				
			
				//creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_NUM'), "CREDIT_NUM", null, null, null, null,  'VALUE');			
		
			//카드과세/면세/영세
			} else if( proofKind >= "13" && proofKind <= "17") {				
				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null, "CREDIT_NUM", null, null, null,  'VALUE', gridId);				
				
			}
			UniAppManager.app.fnSetDefaultAcCodeI5(record, newValue);
		},
		cbGetTaxAmt:function(taxRate,  record) {
			var intTaxRate = Ext.isNumber(taxRate) ? dTaxAmt: parseInt(taxRate);
			if(intTaxRate != 0){
				var dTaxAmt=0;
				if(record.get("DR_CR")== "1") {
					dTaxAmt = record.get("DR_AMT_I");
				}else {
					dTaxAmt = record.get("CR_AMT_I");
				}
				dSupplyAmt = dTaxAmt * intTaxRate;
				
				this.fnSetAcCode(record, "I1", dSupplyAmt)	// 공급가액
				this.fnSetAcCode(record, "I6", dTaxAmt)		// 세액'
			}
		},
		
		cbGetTaxAmtForSales:function(taxRate,  record) {
			var dSupplyAmt=record.get("SUPPLY_AMT_I"), sProofKind=record.get("PROOF_KIND");
			var dTmpSupplyAmt, dTaxAmt;
			var taxRateNum = Ext.isNumber(taxRate) ? dTaxAmt: parseInt(taxRate);
			if(sProofKind == "24" || sProofKind == "13" || sProofKind == "14" ) {
				var divider =Unilite.multiply((100 + taxRateNum), 0.01);
				dTmpSupplyAmt = Unilite.divisionFormat(dSupplyAmt, divider); //dSupplyAmt / divider;
				dTaxAmt = Math.floor(Unilite.multiply(dTmpSupplyAmt , Unilite.multiply(taxRateNum , 0.01)));
				dSupplyAmt = dSupplyAmt - dTaxAmt;
				record.set("SUPPLY_AMT_I",dSupplyAmt);
				record.set("TAX_AMT_I",dTaxAmt);
			}else {
				dTaxAmt = Math.floor(Unilite.multiply(Unilite.multiply(dSupplyAmt , taxRateNum) , 0.01));
				record.set("TAX_AMT_I",dTaxAmt);
			}	
		},
		cbGetExistsSlipNum:function(provider, fieldName, newValue, oldValue, record) {
			if(provider.CNT != 0) {
				Unilite.messageBox(Msg.sMA0306);
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
							Unilite.messageBox(Msg.sMA0330);
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
							Unilite.messageBox(Msg.sMA0332);
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
	

	
	Unilite.createValidator('validator02', {
		store : directMasterStore2,
		grid: masterGrid2,
		forms: {'formA:':saleDetailForm},
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
					var acDate = UniDate.getMonthStr(panelSearch.getValue('AP_DATE_TO'))+sDate;
					if(acDate.length == 8 && Ext.Date.isValid(parseInt(acDate.substring(0,4)), parseInt(acDate.substring(4,6)),parseInt(acDate.substring(6,8)))) {
						if(newValue != sDate) record.set(fieldName, sDate);
						record.set('AC_DATE', UniDate.extParseDate(acDate));
						
						var isNew=false;
						if(directMasterStore1.getCount() == 1 && record.obj.phantom) {
							isNew=true;
						}

							
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
						}							
//					}
					else {
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
						UniAccnt.fnFForeignPopUp(record);
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
					record.set('CREDIT_NUM', '');	
					record.set('CREDIT_NUM_EXPOS', '');
					record.set("REASON_CODE", '');
//					UniAppManager.app.fnProofKindPopUp(record, newValue, this.grid.getId());
					UniAppManager.app.fnSetTaxAmt(record)
					// 증빙유형의 참조코드1에 따라 전자발행여부 기본값 설정
					UniAppManager.app.fnSetDefaultAcCodeI7(record, newValue)
					break;
				case 'DIV_CODE':
					UniAccnt.fnGetBillDivCode(UniAppManager.app.cbGetBillDivCode, record, newValue);
					break;
				case 'MONEY_UNIT':
					if(newValue != oldValue){
						if(!Ext.isEmpty(newValue))  {
							var agrid = this.grid
							agrid.mask();
							accntCommonService.fnGetExchgRate({
								'AC_DATE':  UniDate.getDbDateStr(record.get('AC_DATE')),
								'MONEY_UNIT':newValue
							}, 
							function(provider, response){
								agrid.unmask();
								if(!Ext.isEmpty(provider['BASE_EXCHG'])) {
									record.set('EXCHG_RATE_O',provider['BASE_EXCHG'])
									var amtField = "DR_AMT_I";
									if(record.get("DR_CR") == '2') {
										amtField = "CR_AMT_I";
									}
									setForeignAmt(record.obj, newValue, provider['BASE_EXCHG'], record.get("FOR_AMT_I"), amtField)  ;
								}
							})
						}
					}
					break;
				case 'EXCHG_RATE_O':
						var amtField = "DR_AMT_I";
						if(record.get("DR_CR") == '2') {
							amtField = "CR_AMT_I";
						}
						setForeignAmt(record.obj, record.get("MONEY_UNIT") , newValue, record.get("FOR_AMT_I"), amtField)  ;
					break;
				case 'FOR_AMT_I':
						var amtField = "DR_AMT_I";
						if(record.get("DR_CR") == '2') {
							amtField = "CR_AMT_I";
						}
						setForeignAmt(record.obj, record.get("MONEY_UNIT") , record.get("EXCHG_RATE_O"),  newValue, amtField)  ;
						break;
				default:
					break;
			}
			return rv;
			
		}
	}); // validator02
	
	Unilite.createValidator('validator03', {
		store : salesStore,
		grid: salesGrid,
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
					var acDate = UniDate.getMonthStr(panelSearch.getValue('AP_DATE_TO'))+sDate;
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
							rec.set('AC_DATE',  UniDate.extParseDate(acDate));
						})
						
					} else {
						rv =Msg.sMA0076 ;
					}
					
				break;
				case 'PUB_DATE' :
					if(record.obj.phantom) {
						record.set('OLD_PUB_DATE',UniDate.extParseDate(newValue));
					}
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
//					record.set('CREDIT_NUM', '');	
//					record.set('CREDIT_NUM_EXPOS', '');
//					record.set("REASON_CODE", '');
//					UniAppManager.app.fnProofKindPopUp(record, newValue, this.grid.getId());
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
	}); // validator03
}
</script>