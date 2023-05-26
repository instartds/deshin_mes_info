<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="axt150ukr">
    <t:ExtComboStore comboType="BOR120"  />                             <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {

var gbLoading = false;

    /**
	 * Model 정의
	 * 
	 * @type
	 */
	Unilite.defineModel('axt150ukrModel', {
		fields: [
			{name: 'REG_DATE'		, text: '기준일'				, type: 'uniDate'},
			
			{name: 'AMT_01'			, text: '현금 - 입금'			, type: 'uniUnitPrice'},
			{name: 'AMT_02'			, text: '현금 - 출금'			, type: 'uniUnitPrice'},
			{name: 'AMT_03'			, text: '현금 - 보통예금계'		, type: 'uniUnitPrice'},
			{name: 'AMT_04'			, text: '현금 - 현금잔고계'		, type: 'uniUnitPrice'},
			
			{name: 'AMT_11'			, text: '받을어음 - 수금'			, type: 'uniUnitPrice'},
			{name: 'AMT_12'			, text: '받을어음 - 당좌'			, type: 'uniUnitPrice'},
			{name: 'AMT_13'			, text: '받을어음 - 결재'			, type: 'uniUnitPrice'},
			{name: 'AMT_14'			, text: '받을어음 - 회사보관'		, type: 'uniUnitPrice'},
			
			{name: 'AMT_21'			, text: '지급어음 - 발행'			, type: 'uniUnitPrice'},
			{name: 'AMT_22'			, text: '지급어음 - 결제'			, type: 'uniUnitPrice'},
			{name: 'AMT_23'			, text: '지급어음 - 잔액'			, type: 'uniUnitPrice'},
			
			{name: 'AMT_31'			, text: '당좌예금 - 현금입금'		, type: 'uniUnitPrice'},
			{name: 'AMT_32'			, text: '당좌예금 - 어음입금'		, type: 'uniUnitPrice'},
			{name: 'AMT_33'			, text: '당좌예금 - 발행'			, type: 'uniUnitPrice'},
			{name: 'AMT_34'			, text: '당좌예금 - 지급어음'		, type: 'uniUnitPrice'},
			{name: 'AMT_35'			, text: '당좌예금 - 대체'			, type: 'uniUnitPrice'},
			{name: 'AMT_36'			, text: '당좌예금 - 은행잔고'		, type: 'uniUnitPrice'},
			{name: 'AMT_37'			, text: '당좌예금 - 회사잔고'		, type: 'uniUnitPrice'},
			
			{name: 'OLD_AMT_04'		, text: '현금 - 기초'			, type: 'uniUnitPrice'},
			{name: 'OLD_AMT_23'		, text: '지급어음 - 전일잔액'		, type: 'uniUnitPrice'},
			{name: 'OLD_AMT_37'		, text: '당좌예금 - 전일잔액'		, type: 'uniUnitPrice'},
			{name: 'OLD_AMT_42'		, text: '합계 - 전일받을어음잔액'		, type: 'uniUnitPrice'},
			
			{name: 'AMT_41'			, text: '합계 - 현금'			, type: 'uniUnitPrice'},
			{name: 'AMT_42'			, text: '합계 - 받을어음'			, type: 'uniUnitPrice'},
			{name: 'AMT_43'			, text: '합계 - 총자금'			, type: 'uniUnitPrice'}
		]
	});
    
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'axt150ukrService.selectList',
			create	: 'axt150ukrService.insertDetail',                
			update	: 'axt150ukrService.updateDetail',
			destroy	: 'axt150ukrService.deleteDetail',
			syncAll	: 'axt150ukrService.saveAll'
		}
	});
    
    /**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */                 
	var masterStore = Unilite.createStore('axt150ukrMasterStore1',{
		model   : 'axt150ukrModel',
		uniOpt  : {
			isMaster    : true,             // 상위 버튼 연결
			editable    : false,            // 수정 모드 사용
			deletable   : true,            // 삭제 가능 여부
			useNavi     : false             // prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords : function()   {
			var param = panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()  {   
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var rv = true;
			
			var paramMaster = panelResult.getValues();   
			if(inValidRecs.length == 0 ) {                                       
				config = {
					params: [paramMaster],
					success: function(batch, option) {   
						//masterStore.loadStoreRecords();
						UniAppManager.app.onQueryButtonDown();
						UniAppManager.setToolbarButtons('save', false);     
					} 
				};                  
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				UniAppManager.setToolbarButtons(['newData', 'reset'], true);
			}
		}
	});
    
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region  : 'north',
		layout  : {type : 'uniTable', columns : 2},
		padding : '1 1 1 1',
		border  : true,
		items   : [{
			fieldLabel  : '사업장',
			name        : 'DIV_CODE', 
			xtype       : 'uniCombobox',
			comboType   : 'BOR120',
			value       : UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('DEPT',{
			fieldLabel      : '부서',
			valueFieldName  : 'DEPT_CODE',
			textFieldName   : 'DEPT_NAME',
			validateBlank   : false,                    
			tdAttrs         : {width: 380},  
			listeners       : {
				onSelected: {
				    fn: function(records, type) {
				    },
				    scope: this
				},
				onClear: function(type) {
				},
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				}
			}
		}),{
			fieldLabel  : '기준년월',    
			name        : 'REG_MONTH', 
			xtype       : 'uniMonthfield',
			id          : 'regMonth',              
			value       : new Date(),               
			allowBlank  : false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('Employee',{
			fieldLabel      : '사원',
			valueFieldName  : 'PERSON_NUMB',
			textFieldName   : 'NAME',
			validateBlank   : false,
			autoPopup       : true,
			tdAttrs         : {width: 380},
			listeners       : {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				}
			}
		})]
	});
    
    /**
	 * Master Grid1 정의(Grid Panel)
	 * 
	 * @type
	 */
	var masterGrid = Unilite.createGrid('axt150ukrGrid1', {
		store   : masterStore,
		region  : 'west',
		flex    : 1,
		uniOpt  : { 
			expandLastColumn    : false,        // 마지막 컬럼 * 사용 여부
			useRowNumberer      : true,         // 첫번째 컬럼 순번 사용 여부
			useLiveSearch       : true,         // 찾기 버튼 사용 여부
			useRowContext       : false,            
			onLoadSelectFirst   : true,
			filter: {                           // 필터 사용 여부
				useFilter   : true,
				autoCreate  : true
			}
		},
		selModel: 'rowmodel',
		features: [ 
			{id: 'masterGridSubTotal'   , ftype: 'uniGroupingsummary'   , showSummaryRow: false},
			{id: 'masterGridTotal'      , ftype: 'uniSummary'           , showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'REG_DATE'     , width: 200	},      //등록일
			
			//현금
			{ dataIndex: 'AMT_01'       , width: 100    , hidden: true},        //현금 - 입금
			{ dataIndex: 'AMT_02'       , width: 100    , hidden: true},        //현금 - 출금
			{ dataIndex: 'AMT_03'       , width: 100    , hidden: true},        //현금 - 보통예금계
			{ dataIndex: 'AMT_04'       , width: 100    , hidden: true},        //현금 - 현금잔고계
			{ dataIndex: 'OLD_AMT_04'   , width: 100    , hidden: true},        //현금 - 현금잔고계
			//받을어음
			{ dataIndex: 'AMT_11'       , width: 100    , hidden: true},        //받을어음 - 수금
			{ dataIndex: 'AMT_12'       , width: 100    , hidden: true},        //받을어음 - 당좌
			{ dataIndex: 'AMT_13'       , width: 100    , hidden: true},        //받을어음 - 결재
			{ dataIndex: 'AMT_14'       , width: 100    , hidden: true},        //받을어음 - 회사보관
			//지급어음
			{ dataIndex: 'AMT_21'       , width: 100    , hidden: true},        //지급어음 - 발행
			{ dataIndex: 'AMT_22'       , width: 100    , hidden: true},        //지급어음 - 결제
			{ dataIndex: 'AMT_23'       , width: 100    , hidden: true},        //지급어음 - 잔액
			{ dataIndex: 'OLD_AMT_23'   , width: 100    , hidden: true},        //지급어음 - 잔액
			//당좌예금
			{ dataIndex: 'AMT_31'       , width: 100    , hidden: true},        //당좌예금 - 현금입금 
			{ dataIndex: 'AMT_32'       , width: 100    , hidden: true},        //당좌예금 - 어음입금 
			{ dataIndex: 'AMT_33'       , width: 100    , hidden: true},        //당좌예금 - 발행 
			{ dataIndex: 'AMT_34'       , width: 100    , hidden: true},        //당좌예금 - 지급어음 
			{ dataIndex: 'AMT_35'       , width: 100    , hidden: true},        //당좌예금 - 대체 
			{ dataIndex: 'AMT_36'       , width: 100    , hidden: true},        //당좌예금 - 은행잔고 
			{ dataIndex: 'AMT_37'       , width: 100    , hidden: true},        //당좌예금 - 회사잔고 
			{ dataIndex: 'OLD_AMT_37'   , width: 100    , hidden: true},        //당좌예금 - 회사잔고 
			//합계
			{ dataIndex: 'AMT_41'       , width: 100    , hidden: true},        //합계 - 현금총계 
			{ dataIndex: 'AMT_42'       , width: 100    , hidden: true},        //합계 - 받을어음계 
			{ dataIndex: 'OLD_AMT_42'   , width: 100    , hidden: true},        //받을어음 - 받을어음잔액(장부액)
			{ dataIndex: 'AMT_43'       , width: 100    , hidden: true}         //합계 - 총자금합계 
		],
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
				alert('Hello');
			},
			selectionchangerecord:function(record)    {
				gbLoading = true;
				
				if(record.phantom) {
					detailForm.getField('REG_DATE').setReadOnly(false);
				}
				else {
					detailForm.getField('REG_DATE').setReadOnly(true);
				}
				detailForm.loadForm(record);
				
				gbLoading = false;
			}
		}
	});
	
	var detailForm = Unilite.createForm('detailForm', {
		masterGrid  : masterGrid,
		region      : 'center',
		flex        : 5,
		autoScroll  : true,
		border      : false,
		padding     : '1 1 1 1',
		defaultType	: 'uniTextfield',
		itemId		: 'basicInfoForm',
		layout		: {type: 'uniTable', columns:'2'},
		width		: 510,
		disabled	: false,
		items:[{
			fieldLabel	: '기준일',
			name		: 'REG_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			hidden		: false,
			colspan		: 2,
			listeners: {
//				blur: function(field, newValue, oldValue, eOpts) {
//					//alert('hello');
//				},
				change: function(field, newValue, oldValue, eOpts) {
					if(gbLoading) {
						return false;
					}
					if(field == oldValue) {
						return false;
					}
					if(field.readOnly) {
						return false;
					}
					if(Ext.isEmpty(newValue) /*|| !grid.getSelectedRecord().phantom*/) {
						return false;
					}
					if(UniDate.extParseDate(newValue) == null) {
						return false;
					}
					
					UniAppManager.app.fnGetJanAmtI();
				}
			}
		},{
			xtype		:'container',
			html		: '<b>&nbsp;&nbsp;&nbsp;&nbsp;◆ 현&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;금</b>',
			colspan     : 2,
			style		: {color: 'blue', margin: '20px 0 0 0'}
		},{
			fieldLabel	: '입금',
			name		: 'AMT_01',
			xtype		: 'uniNumberfield',
			value 		: '0'
		},{
			fieldLabel	: '출금',
			name		: 'AMT_02',
			xtype		: 'uniNumberfield',
			value 		: '0'
		},{
			fieldLabel	: '보통예금계',
			name		: 'AMT_03' , 
			xtype		: 'uniNumberfield',
			value 		: '0'
		},{
			fieldLabel	: '현금잔고계',
			name		: 'AMT_04',
			xtype		: 'uniNumberfield',
			value 		: '0',
			readOnly 	: false
		},{
			xtype		:'container',
			html		: '<b>&nbsp;&nbsp;&nbsp;&nbsp;◆ 받 을 어 음</b>',
			colspan     : 2,
			style		: {color: 'blue', margin: '20px 0 0 0'}
		},{
			fieldLabel	: '수금',
			name		: 'AMT_11', 
			xtype		: 'uniNumberfield',
			value 		: '0'
		},{
			fieldLabel	: '당좌',
			name		: 'AMT_12' , 
			xtype		: 'uniNumberfield',
			value 		: '0'
		},{
			xtype		: 'component',
			name		: ' '
		},{
			fieldLabel	: '결제',
			name		: 'AMT_13', 
			xtype		: 'uniNumberfield',
			value 		: '0'
		},{
			xtype		: 'component',
			name		: ' '
		},{
			fieldLabel	: '회사보관',
			name		: 'AMT_14',
			xtype		: 'uniNumberfield',
			value 		: '0'
		},{
			xtype		: 'container',
			html		: '<b>&nbsp;&nbsp;&nbsp;&nbsp;◆ 지 급 어 음</b>',
			colspan     : 2,
			style		: {color: 'blue', margin: '20px 0 0 0'}
		},{
			fieldLabel	: '발행',
			name		: 'AMT_21' , 
			xtype		: 'uniNumberfield',
			value 		: '0'
		},{
			fieldLabel	: '결제',
			name		: 'AMT_22' ,
			xtype		: 'uniNumberfield',
			value 		: '0'
		},{
			fieldLabel	: '잔액',
			name		: 'AMT_23' , 
			xtype		: 'uniNumberfield',
			value 		: '0',
			readOnly 	: true
		},{
			xtype		: 'component',
			name		: ' '
		},{
			xtype		: 'container',
			html		: '<b>&nbsp;&nbsp;&nbsp;&nbsp;◆ 당 좌 예 금</b>',
			colspan     : 2,
			style		: {color: 'blue', margin: '20px 0 0 0'}
		},{
			fieldLabel	: '현금입금',
			name		: 'AMT_31', 
			xtype		: 'uniNumberfield',
			value 		: '0'
		},{
			xtype		: 'component',
			name		: ' '
		},{
			fieldLabel	: '어음입금',
			name		: 'AMT_32', 
			xtype		: 'uniNumberfield',
			value 		: '0'
		},{
			fieldLabel	: '발행',
			name		: 'AMT_33', 
			xtype		: 'uniNumberfield',
			value 		: '0'
		},{
			fieldLabel	: '지급어음',
			name		: 'AMT_34',
			xtype		: 'uniNumberfield',
			value 		: '0',
			readOnly	: true
		},{
			fieldLabel	: '대체',
			name		: 'AMT_35' , 
			xtype		: 'uniNumberfield',
			value 		: '0'
		},{
			fieldLabel	: '은행잔고',
			name		: 'AMT_36', 
			xtype		: 'uniNumberfield',
			value 		: '0'
		},{
			fieldLabel	: '회사잔고',
			name		: 'AMT_37', 
			xtype		: 'uniNumberfield',
			value 		: '0',
			readOnly 	: false
		},{
			xtype		: 'container',
			html		: '<b>&nbsp;&nbsp;&nbsp;&nbsp;◆ 합&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계</b>',
			colspan		: 2,
			style		: {color: 'blue', margin: '20px 0 0 0'}
		},{
			fieldLabel	: '현금총계',
			name		: 'AMT_41', 
			xtype		: 'uniNumberfield',
			value 		: '0',
			readOnly 	: true
		},{
			fieldLabel	: '받을어음계',
			name		: 'AMT_42',
			xtype		: 'uniNumberfield',
			value 		: '0',
			readOnly 	: true
		},{
			fieldLabel	: '총자금 합계',
			name		: 'AMT_43', 
			xtype		: 'uniNumberfield',
			value 		: '0',
			readOnly 	: true
		},{
			xtype		: 'component',
			name		: ' '
		},{
			xtype		: 'container',
			html		: '<b>&nbsp;&nbsp;&nbsp;&nbsp;◆ 참 고 자 료</b>',
			colspan		: 2,
			style		: {color: 'blue', margin: '20px 0 0 0'},
			hidden 		: true
		},{
			fieldLabel	: '현금잔고_base',
			name		: 'OLD_AMT_04',
			xtype		: 'uniNumberfield',
			value 		: '0',
			readOnly 	: true,
			hidden 		: true
		},{
			fieldLabel	: '전지급어음계',
			name		: 'OLD_AMT_23' , 
			xtype		: 'uniNumberfield',
			value 		: '0',
			readOnly 	: true,
			hidden 		: true
		},{
			fieldLabel	: '전당좌잔액계',
			name		: 'OLD_AMT_37' ,
			xtype		: 'uniNumberfield', 
			value 		: '0',
			readOnly 	: true,
			hidden 		: true
		},{
			fieldLabel	: '전받을어음계',
			name		: 'OLD_AMT_42',
			xtype		: 'uniNumberfield',
			value 		: '0',
			readOnly 	: true,
			hidden 		: true
		}],
		loadForm: function(record)  {
			// window 오픈시 form에 Data load
			this.reset();
			this.setActiveRecord(record || null); 
			this.resetDirtyStatus();
		},
		listeners:{
		}
	});

	Unilite.Main({
		id          : 'axt150ukrApp',
		borderItems : [{
			region  : 'center',
			layout  : 'border',
			border  : false,
			items   : [
				panelResult,
				{
					region  : 'center',
					xtype   : 'container',
					border  : true,
					layout  : {type:'hbox', align:'stretch'},
					items   : [
						masterGrid, detailForm
					]
				}
			]
		}],
		fnInitBinding : function() {
			// 초기화 시, 포커스 설정
			panelResult.onLoadSelectText('REG_MONTH');
			// 버튼 설정
			UniAppManager.setToolbarButtons(['reset', 'newData', 'save'] , false);
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('REG_MONTH',UniDate.get('today'));
			
			detailForm.setValue('REG_DATE', UniDate.get('today'));
			detailForm.setValue('AMT_01', 0);
			detailForm.setValue('AMT_02', 0);
			detailForm.setValue('AMT_03', 0);
			detailForm.setValue('AMT_04', 0);
			
			detailForm.setValue('AMT_11', 0);
			detailForm.setValue('AMT_12', 0);
			detailForm.setValue('AMT_13', 0);
			detailForm.setValue('AMT_14', 0);
			
			detailForm.setValue('AMT_21', 0);
			detailForm.setValue('AMT_22', 0);
			detailForm.setValue('AMT_23', 0);
			
			detailForm.setValue('AMT_31', 0);
			detailForm.setValue('AMT_32', 0);
			detailForm.setValue('AMT_33', 0);
			detailForm.setValue('AMT_34', 0);
			detailForm.setValue('AMT_35', 0);
			detailForm.setValue('AMT_36', 0);
			detailForm.setValue('AMT_37', 0);
			
			detailForm.setValue('AMT_41', 0);
			detailForm.setValue('AMT_42', 0);
			detailForm.setValue('AMT_43', 0);
			
			detailForm.setValue('OLD_AMT_04', 0);
			detailForm.setValue('OLD_AMT_23', 0);
			detailForm.setValue('OLD_AMT_37', 0);
			detailForm.setValue('OLD_AMT_42', 0);
		},
		onQueryButtonDown : function()  {
			// 필수입력값 체크
			if(!this.isValidSearchForm()){
				return false;
			}
			
			masterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {     
			panelResult.clearForm();
			detailForm.clearForm();
			
			masterGrid.getStore().clearData();
			masterGrid.getStore().loadData({});
			
			this.fnInitBinding();
		},
		onSaveDataButtonDown : function() { //저장
			masterGrid.getStore().saveStore();
		},
		onNewDataButtonDown : function() { //행추가
			var record = {
				REG_DATE: UniDate.get('today')
			};
			masterGrid.createRow(record);
			
			this.fnGetJanAmtI();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom){    
				masterGrid.deleteSelectedRow();
			} else {
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid.deleteSelectedRow();
				}
			}
		},
		fnGetJanAmtI: function() {
			var param = {
				REG_DATE : detailForm.getValues().REG_DATE
			};
			
			axt150ukrService.getOldData(param, function(provider, response) {
				if(provider) {
					detailForm.setValue('OLD_AMT_04', provider.OLD_AMT_04);
					detailForm.setValue('OLD_AMT_23', provider.OLD_AMT_23);
					detailForm.setValue('OLD_AMT_37', provider.OLD_AMT_37);
					detailForm.setValue('OLD_AMT_42', provider.OLD_AMT_42);
					
					UniAppManager.app.computeCash();
					UniAppManager.app.computeNote();
					UniAppManager.app.computeAcnt();
				}
			});
		},
		computeCash: function() {
			var amt01 = Number(this.isnull(detailForm.getValue('AMT_01')	, '0'));
			var amt02 = Number(this.isnull(detailForm.getValue('AMT_02')	, '0'));
			var baseI = Number(this.isnull(detailForm.getValue('OLD_AMT_04'), '0'));
			
			detailForm.setValue('AMT_04', baseI + amt01 - amt02);
			
			this.computeTotal();
		},
		computeNote: function() {
			var amt11 = Number(this.isnull(detailForm.getValue('AMT_11')	, '0'));
			var amt13 = Number(this.isnull(detailForm.getValue('AMT_13')	, '0'));
			var amt21 = Number(this.isnull(detailForm.getValue('AMT_21')	, '0'));
			var amt22 = Number(this.isnull(detailForm.getValue('AMT_22')	, '0'));
			var prePI = Number(this.isnull(detailForm.getValue('OLD_AMT_23'), '0'));
			var preRI = Number(this.isnull(detailForm.getValue('OLD_AMT_42'), '0'));
			
			detailForm.setValue('AMT_23', prePI + amt21 - amt22);
			detailForm.setValue('AMT_42', preRI + amt11 - amt13);
			
			this.computeTotal();
		},
		computeAcnt: function() {
			var amt31 = Number(this.isnull(detailForm.getValue('AMT_31')	, '0'));
			var amt32 = Number(this.isnull(detailForm.getValue('AMT_32')	, '0'));
			var amt33 = Number(this.isnull(detailForm.getValue('AMT_33')	, '0'));
			var amt34 = Number(this.isnull(detailForm.getValue('AMT_34')	, '0'));
			var prevI = Number(this.isnull(detailForm.getValue('OLD_AMT_37'), '0'));
			
			detailForm.setValue('AMT_37', prevI + amt31 + amt32 - amt33 - amt34);
			
			this.computeTotal();
		},
		computeTotal: function() {
			var amt03 = Number(this.isnull(detailForm.getValue('AMT_03')	, '0'));
			var amt04 = Number(this.isnull(detailForm.getValue('AMT_04')	, '0'));
			var amt42 = Number(this.isnull(detailForm.getValue('AMT_42')	, '0'));
			
			detailForm.setValue('AMT_41', amt03 + amt04);
			detailForm.setValue('AMT_43', amt03 + amt04 + amt42);
		},
		isnull: function(val, replaceVal) {
			if(val == null || typeof val == 'undefined') {
				return replaceVal;
			}
			
			return val;
		}
	});
	
	Unilite.createValidator('validator02', {
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;
			
			switch(fieldName) {
				//	현금
				case "AMT_01" :	// 입금
					detailForm.setValue('AMT_33', newValue);	//	현금 입금액은 당좌예금 - 발행금액으로 싱크
				case "AMT_02" :	// 출금
					UniAppManager.app.computeCash();
					break;
				
				//	어음
				case "AMT_22" :	// 지급어음 - 결제
					detailForm.setValue('AMT_34', newValue);	//	지급어음 결제금액은 당좌예금 - 지급어음금액으로 싱크
				case "AMT_21" :	// 지급어음 - 발행
				case "AMT_11" :	// 받을어음 - 수금
				case "AMT_13" :	// 받을어음 - 결제
					UniAppManager.app.computeNote();
					//break;
				
				//	당좌예금
				case "AMT_31" :	// 현금입금
				case "AMT_32" :	// 어음입금
				case "AMT_33" :	// 발행
				case "AMT_34" :	// 지급어음
					UniAppManager.app.computeAcnt();
					break;
				
				default:
					UniAppManager.app.computeTotal();
					break;
			}
			
			return rv;
		}
	});
};
</script>
