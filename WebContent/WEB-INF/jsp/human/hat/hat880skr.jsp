<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat880skr">
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="H004" />					<!-- 근무조 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /> 				<!-- 직책 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hat880skrModel', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'			,type: 'string'},
			{name: 'QUERY_SEQ'			,text: 'SEQ'				,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'				,type: 'string'},
			{name: 'PERSON_NAME'		,text: '성명'					,type: 'string'},
			{name: 'ABIL_CODE'			,text: '직책'					,type: 'string'		, comboType: "AU"	, comboCode: "H006"},
			{name: 'DUTY_TO_H'			,text: '퇴근시간'				,type: 'string'},
			{name: 'OVERTIME_3_H'		,text: '야간근무'				,type: 'string'},
			{name: 'OVERTIME_2_H'		,text: '추가연장'				,type: 'string'},
			{name: 'OVERTIME_1_H'		,text: '기본연장'				,type: 'string'},
			{name: 'CONFIRM'			,text: '본인확인'				,type: 'string'},
			{name: 'REMARK'				,text: '비고'					,type: 'string'},
			{name: 'WORK_TEAM'			,text: '근무조'				,type: 'string'},
			{name: 'DUTY_DATE'			,text: '근태일자'				,type: 'string'}

		]
	});
	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hat880skrMasterStore1',{
		model	: 'hat880skrModel',
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
					read: 'hat880skrService.selectList'
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
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3
//		, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//		, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
				fieldLabel	: '근태일',	
				name		: 'DUTY_DATE', 
				xtype		: 'uniDatefield',			
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
				colspan		: 2,
//				multiSelect	: true, 
//				typeAhead	: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
		 		}
			}, 
			Unilite.popup('Employee',{
				fieldLabel		: '사원',
				valueFieldName	: 'PERSON_NUMB',
				textFieldName	: 'NAME',
				validateBlank	: false,
				autoPopup		: true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
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
			}),  
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
			}),{
				fieldLabel	: '근무조',
				name		: 'WORK_TEAM', 
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H004',
				hidden      : true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
		 		}
			}
		]
	});
	
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('hat880skrGrid1', {
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
	    
	    selModel:'rowmodel',
		
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'QUERY_SEQ'		, width: 110	, hidden: true},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'PERSON_NAME'		, width: 110	},
			{ dataIndex: 'ABIL_CODE'		, width: 90		},
			{ dataIndex: 'DUTY_TO_H'		, width: 100	},
			{ dataIndex: 'OVERTIME_3_H'		, width: 100	},
			{ dataIndex: 'OVERTIME_2_H'		, width: 100	},
			{ dataIndex: 'OVERTIME_1_H'		, width: 100	},
			{ dataIndex: 'CONFIRM'			, width: 90		},
			{ dataIndex: 'REMARK'			, width: 200	},
			{ dataIndex: 'WORK_TEAM'		, width: 110	, hidden: true},
			{ dataIndex: 'DUTY_DATE'		, width: 110	, hidden: true}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
 
	
	
	
	Unilite.Main({
		id  : 'hat880skrApp',
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
			panelResult.setValue('DUTY_DATE'	, new Date());
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DUTY_DATE');
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