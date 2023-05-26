<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa990skr">
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hpa990skrModel', {
		fields: [
			{name: 'COMP_CODE'		 		,text: 'COMP_CODE'		,type: 'string'},
			{name: 'PAY_YYYYMM'				,text: '급여년월'			,type: 'string'},
			{name: 'DEPT_CODE'				,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'				,text: '부서명'			,type: 'string'},
			{name: 'DEPT_PERSON_CNT'		,text: '인원'				,type: 'string'},
			{name: 'WAGES_100'				,text: '기본급'			,type: 'uniPrice'},
			{name: 'WAGES_300'				,text: '시외수당'			,type: 'uniPrice'},
			{name: 'WAGES_110'				,text: '직책수당'			,type: 'uniPrice'},
			{name: 'WAGES_120'				,text: '기술수당'			,type: 'uniPrice'},
			{name: 'WAGES_130'				,text: '가족수당'			,type: 'uniPrice'},
			{name: 'WAGES_140'				,text: '차량관리'			,type: 'uniPrice'},
			{name: 'WAGES_150'				,text: '생산장려'			,type: 'uniPrice'},
			{name: 'WAGES_160'				,text: '반장수당'			,type: 'uniPrice'},
			{name: 'WAGES_170'				,text: '생산수당'			,type: 'uniPrice'},
			{name: 'WAGES_180'				,text: '연구수당'			,type: 'uniPrice'},
			{name: 'WAGES_190'				,text: '연수수당'			,type: 'uniPrice'},
			{name: 'WAGES_200'				,text: '착오비과'			,type: 'uniPrice'},
			{name: 'WAGES_210'				,text: '감봉액'			,type: 'uniPrice'},
			{name: 'DUTY_01_TIME'			,text: '정상시간'			,type: 'uniNumber'},
			{name: 'DUTY_02_DAY'			,text: '주휴일수'			,type: 'uniNumber'},
			{name: 'DUTY_03_TIME'			,text: '기본연장'			,type: 'uniNumber'},
			{name: 'DUTY_01_AMOUNT_I'		,text: '정상금액'			,type: 'uniPrice'},
			{name: 'DUTY_02_AMOUNT_I'		,text: '주휴금액'			,type: 'uniPrice'},
			{name: 'DUTY_03_AMOUNT_I'		,text: '연장금액'			,type: 'uniPrice'},
			{name: 'DUTY_04_TIME'			,text: '추가연장'			,type: 'uniNumber'},
			{name: 'DUTY_05_TIME'			,text: '야간시간'			,type: 'uniNumber'},
			{name: 'DUTY_06_TIME'			,text: '특근시간'			,type: 'uniNumber'},
			{name: 'DUTY_04_AMOUNT_I'		,text: '추가금액'			,type: 'uniPrice'},
			{name: 'DUTY_05_AMOUNT_I'		,text: '야간금액'			,type: 'uniPrice'},
			{name: 'DUTY_06_AMOUNT_I'		,text: '특근금액'			,type: 'uniPrice'},
			{name: 'DUTY_07_AMOUNT_I'		,text: '특근수당'			,type: 'uniPrice'},
			{name: 'DUTY_08_AMOUNT_I'		,text: '년월차액'			,type: 'uniPrice'},
			{name: 'DUTY_09_AMOUNT_I'		,text: '주휴차감'			,type: 'uniPrice'},
			{name: 'SUPP_TOTAL_I'			,text: '급여총액'			,type: 'uniPrice'},
			{name: 'WAGES_997'				,text: '상여금'			,type: 'uniPrice'},//기본값 0을 보여주기 위한 컬럼
			{name: 'WAGES_998'				,text: '퇴직금'			,type: 'uniPrice'},//기본값 0을 보여주기 위한 컬럼
			{name: 'WAGES_999'				,text: '증권저축'			,type: 'uniPrice'},//기본값 0을 보여주기 위한 컬럼
			{name: 'DED_RLC'				,text: '정산보료'			,type: 'uniPrice'},//요양보험정산(DED_RLC)
			{name: 'DED_MED'				,text: '건강보험'			,type: 'uniPrice'},
			{name: 'DED_ANU'				,text: '국민연금'			,type: 'uniPrice'},
			{name: 'DED_INC'				,text: '갑근세'			,type: 'uniPrice'},//소득세(DED_INC)
			{name: 'DED_LOC'				,text: '주민세'			,type: 'uniPrice'},
			{name: 'DED_S03'				,text: '가지급금'			,type: 'uniPrice'},
			{name: 'DED_S04'				,text: '식대'				,type: 'uniPrice'},
			{name: 'DED_HIR'				,text: '고용보험'			,type: 'uniPrice'},
			{name: 'DED_S90'				,text: '기타공제'			,type: 'uniPrice'},
			{name: 'DED_TOTAL_I'			,text: '공제합계'			,type: 'uniPrice'},
			{name: 'REAL_AMOUNT_I'			,text: '실지급액'			,type: 'uniPrice'},
			{name: 'REMARK'					,text: '비고'				,type: 'string'}
		]
	});


	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */			
	var masterStore = Unilite.createStore('hpa990skrmasterStore',{
		model	: 'hpa990skrModel',
		uniOpt	: {
			isMaster	: true,				// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 
			deletable	: false,			// 삭제 가능 여부 
			useNavi		: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {			
					read: 'hpa990skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
//				var count = masterGrid.getStore().getCount();  
//				if(count > 0){
//					UniAppManager.setToolbarButtons(['print'], true);
//				}else{
//					UniAppManager.setToolbarButtons(['print'], false);
//				}
			}
		}
	});

	
	
	
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
//		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2
//		, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//		, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
				fieldLabel	: '급여년월',	
				name		: 'PAY_YYYYMM', 
				xtype		: 'uniMonthfield',		
				value		: new Date(),				
				allowBlank	: false,
				tdAttrs		: {width: 380},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
		 		}
			},{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
//				multiSelect	: true, 
//				typeAhead	: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
		 		}
			},{
				xtype		: 'component',
				width		: 200
			},  
			Unilite.popup('DEPT',{
				fieldLabel		: '부서',
				valueFieldName	: 'DEPT_CODE',
				textFieldName	: 'DEPT_NAME',
				validateBlank	: false,					
				tdAttrs			: {width: 380},  
				listeners		: {
					onSelected: {
						fn: function(records, type) {
//							dataForm.setValue('S_DEPT_CODE', records[0].DEPT_CODE);
						},
						scope: this
					},
					onClear: function(type)	{
					},
					onValueFieldChange: function(field, newValue){
					},
					onTextFieldChange: function(field, newValue){
					}
				}
			})
		]
	});
	
	
	
	
	/** Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('hpa990skrGrid1', {
		store	: masterStore,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {	
			expandLastColumn	: true,			//마지막 컬럼 * 사용 여부
			useRowNumberer		: true,			//첫번째 컬럼 순번 사용 여부
			useLiveSearch		: true,			//찾기 버튼 사용 여부
			useRowContext		: false,			
			onLoadSelectFirst	: true,
			filter: {							//필터 사용 여부
				useFilter	: true,
				autoCreate	: true
			}
		},
		features: [ 
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		 	, width: 110	, hidden: true},
			{ dataIndex: 'PAY_YYYYMM'			, width: 100	, hidden: true},
			{ dataIndex: 'DEPT_CODE'			, width: 110	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
				}
			},
			{ dataIndex: 'DEPT_NAME'			, width: 110	},
			{ dataIndex: 'DEPT_PERSON_CNT'		, width: 110	},
			{ dataIndex: 'WAGES_100'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'WAGES_300'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'WAGES_110'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'WAGES_120'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'WAGES_130'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'WAGES_140'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'WAGES_150'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'WAGES_160'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'WAGES_170'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'WAGES_180'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'WAGES_190'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'WAGES_200'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'WAGES_210'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DUTY_01_TIME'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DUTY_02_DAY'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DUTY_03_TIME'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DUTY_01_AMOUNT_I'		, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DUTY_02_AMOUNT_I'		, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DUTY_03_AMOUNT_I'		, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DUTY_04_TIME'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DUTY_05_TIME'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DUTY_06_TIME'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DUTY_04_AMOUNT_I'		, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DUTY_05_AMOUNT_I'		, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DUTY_06_AMOUNT_I'		, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DUTY_07_AMOUNT_I'		, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DUTY_08_AMOUNT_I'		, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DUTY_09_AMOUNT_I'		, width: 110	,summaryType:'sum'},
			{ dataIndex: 'SUPP_TOTAL_I'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'WAGES_997'			, width: 110	,summaryType:'sum'},      //상여금(그냥 0)
			{ dataIndex: 'WAGES_998'			, width: 110	,summaryType:'sum'},      //퇴직금(그냥 0)
			{ dataIndex: 'WAGES_999'			, width: 110	,summaryType:'sum'},		//증권저축(그냥 0)
			{ dataIndex: 'DED_RLC'				, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DED_MED'				, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DED_ANU'				, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DED_INC'				, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DED_LOC'				, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DED_S03'				, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DED_S04'				, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DED_HIR'				, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DED_S90'				, width: 110	,summaryType:'sum'},
			{ dataIndex: 'DED_TOTAL_I'			, width: 110	,summaryType:'sum'},
			{ dataIndex: 'REAL_AMOUNT_I'		, width: 110	,summaryType:'sum'},
			{ dataIndex: 'REMARK'				, flex: 1		, minWidth: 200	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	

 
	
	
	
	Unilite.Main({
		id  : 'hpa990skrApp',
		borderItems:[{
		  region:'center',
		  layout: {type: 'vbox', align: 'stretch'},
		  border: false,
		  items:[
				panelResult, masterGrid 
		  ]}
		], 
		fnInitBinding : function() {
			//초기값 설정
			panelResult.setValue('PAY_YYYYMM'	, new Date());
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('PAY_YYYYMM');
			//버튼 설정
			UniAppManager.setToolbarButtons('print'	, false);
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset'	, false);
			UniAppManager.setToolbarButtons('save'	, false);
		},
		
		onQueryButtonDown : function()	{
			//필수입력값 체크
			if(!this.isValidSearchForm()){
				return false;
			}
			
			masterStore.loadStoreRecords();
			
			UniAppManager.setToolbarButtons('reset', true);
		},				
				
		onResetButtonDown: function() {		
			panelResult.clearForm();
			masterGrid.getStore().loadData({});	
			this.fnInitBinding();	
		}		
	});
};


</script>
