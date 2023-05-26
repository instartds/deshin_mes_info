<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum500skr">
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
	Unilite.defineModel('hum500skrModel', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'			,type: 'string'},
			{name: 'NAME'				,text: '성명'				,type: 'string'},
			{name: 'ANNOUNCE_DATE'		,text: '발령일자'			,type: 'uniDate'},
			{name: 'ANNOUNCE_CODE'		,text: '발령코드'			,type: 'string'},
			{name: 'ANNOUNCE_NAME'		,text: '발령명'			,type: 'string'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'WAGES_AMT_01'		,text: '기본급'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_02'		,text: '시간외'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_03'		,text: '직책수당'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_04'		,text: '기술수당'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_05'		,text: '가족수당'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_06'		,text: '생산장려'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_07'		,text: '반장수당'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_08'		,text: '연구수당'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_09'		,text: '기타수당1'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_10'		,text: '기타수당2'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_11'		,text: '운전수당'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_12'		,text: '연수수당'			,type: 'uniPrice'}
		]
	});
	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hum500skrMasterStore1',{
		model	: 'hum500skrModel',
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
					read: 'hum500skrService.selectList'
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
				var count = masterGrid.getStore().getCount();  
				if(count > 0){
					//UniAppManager.setToolbarButtons(['print'], true);
				}else{
					//UniAppManager.setToolbarButtons(['print'], false);
				}

			}
		},
		group: 'DEPT_CODE'
	});
	
	
	
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
//		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3
//		, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//		, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [
			Unilite.popup('Employee',{
				fieldLabel		: '사원',
				valueFieldName	: 'PERSON_NUMB',
				textFieldName	: 'NAME',
				validateBlank	: false,
				autoPopup		: true,
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
			}),{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				colspan		: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
		 		}
			},{	    
				fieldLabel	: '재직구분',
				name		: 'WORK_GB',
				id			: 'workGb',
				xtype		: 'uniRadiogroup',
				width		: 300,
				items		: [{
					boxLabel	: '전체',
					name		: 'WORK_GB',
					inputValue	: ''							
				},{
					boxLabel	: '재직',
					name		: 'WORK_GB',
					inputValue	: '1'								
				},{
					boxLabel	: '퇴직',
					name		: 'WORK_GB',
					inputValue	: '2'
				}],	
				value		: '1'
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
	
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('hum500skrGrid1', {
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
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		 	, width: 110	, hidden: true},
			{ dataIndex: 'PERSON_NUMB'			, width: 110	},
			{ dataIndex: 'NAME'					, width: 110	},
			{ dataIndex: 'ANNOUNCE_DATE'		, width: 100	},
			{ dataIndex: 'ANNOUNCE_CODE'		, width: 80		},
			{ dataIndex: 'ANNOUNCE_NAME'		, width: 110	},
			{ dataIndex: 'DEPT_CODE'			, width: 110	},
			{ dataIndex: 'DEPT_NAME'			, width: 110	},
			{ dataIndex: 'WAGES_AMT_01'			, width: 100	},
			{ dataIndex: 'WAGES_AMT_02'			, width: 100	},
			{ dataIndex: 'WAGES_AMT_03'			, width: 100	},
			{ dataIndex: 'WAGES_AMT_04'			, width: 100	},
			{ dataIndex: 'WAGES_AMT_05'			, width: 100	},
			{ dataIndex: 'WAGES_AMT_06'			, width: 100	},
			{ dataIndex: 'WAGES_AMT_07'			, width: 100	},
			{ dataIndex: 'WAGES_AMT_08'			, width: 100	},
			{ dataIndex: 'WAGES_AMT_09'			, width: 100	},
			{ dataIndex: 'WAGES_AMT_10'			, width: 100	},
			{ dataIndex: 'WAGES_AMT_11'			, width: 100	},
			{ dataIndex: 'WAGES_AMT_12'			, width: 100	}
		],
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
 
	
	
	
	Unilite.Main({
		id  : 'hum500skrApp',
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
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			Ext.getCmp('workGb').setValue('1');

			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('PERSON_NUMB');
			//버튼 설정
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		
		onQueryButtonDown : function()	{
			//필수입력값 체크
			if(!this.isValidSearchForm()){
				return false;
			}
			
			masterStore.loadStoreRecords();
			//초기화 버튼 활성화
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
