<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum530skr">
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
	Unilite.defineModel('hum530skrModel', {
		fields: [
			{name: 'COMP_CODE'			,text: 'COMP_CODE'					,type: 'string'},
			{name: 'DEPT_CODE'			,text: '부서코드'						,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'						,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'						,type: 'string'},
			{name: 'PERSON_NAME'		,text: '성명'							,type: 'string'},
			{name: 'NAME_PRIZE_PENALTY'	,text: '구분'							,type: 'string'},
			{name: 'OCCUR_DATE'			,text: '상벌일자'						,type: 'string'},
			{name: 'REASON'				,text: '상벌내용'						,type: 'string'},
			{name: 'RELATION_ORGAN'		,text: '시행처'						,type: 'string'},
			{name: 'PRIZE_BASIS'		,text: '상벌근거'						,type: 'string'},
			{name: 'REMARK'				,text: '비고'							,type: 'string'}
		]
	});
	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hum530skrMasterStore1',{
		model	: 'hum530skrModel',
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
					read: 'hum530skrService.selectList'
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
//, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
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
	var masterGrid = Unilite.createGrid('hum530skrGrid1', {
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
        selModel: 'rowmodel',
		features: [ 
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'			, width: 110	, hidden: true},
			{ dataIndex: 'DEPT_CODE'			, width: 110	},
			{ dataIndex: 'DEPT_NAME'			, width: 110	},
			{ dataIndex: 'PERSON_NUMB'			, width: 110	},
			{ dataIndex: 'PERSON_NAME'			, width: 110	},
			{ dataIndex: 'NAME_PRIZE_PENALTY'	, width: 80		},
			{ dataIndex: 'OCCUR_DATE'			, width: 90		},
			{ dataIndex: 'REASON'				, width: 150	},
			{ dataIndex: 'RELATION_ORGAN'		, width: 100	},
			{ dataIndex: 'PRIZE_BASIS'			, width: 150	},
			{ dataIndex: 'REMARK'				, width: 200	}
		],
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	

	
	
	
	Unilite.Main({
		id  		: 'hum530skrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		}], 
		fnInitBinding : function() {
			//초기값 설정
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			Ext.getCmp('workGb').setValue('1');

			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('PERSON_NUMB');
			//버튼 설정
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
