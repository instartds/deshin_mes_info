<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat851skr_kva">
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="H024" />					<!-- 사원구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hat851skr_kvaModel', {
		fields: [
			{name: 'COMP_CODE'		,text: 'COMP_CODE'		,type: 'string'},
			{name: 'DEPT_CODE'		,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'		,text: '부서명'			,type: 'string'},
			{name: 'PERSON_NUMB'	,text: '사원번호'			,type: 'string'},
			{name: 'PERSON_NAME'	,text: '성명'				,type: 'string'},
			{name: 'POST_CODE'		,text: '직위'				,type: 'string'},
			{name: 'POST_NAME'		,text: '직책'				,type: 'string'},
			{name: 'DUTY_CNT'		,text: '근무일'			,type: 'string'},
			{name: 'DUTY_21_CNT'	,text: '결근'				,type: 'string'},
			{name: 'DUTY_61_CNT'	,text: '연차/월차'			,type: 'string'},
			{name: 'DUTY_07_CNT'	,text: '조퇴'				,type: 'string'},
			{name: 'DUTY_06_CNT'	,text: '기타'				,type: 'string'},
			{name: 'DUTY_FR_RANK'	,text: '순위'				,type: 'string'},
			{name: 'DUTY_FR_AVG'	,text: '평균'				,type: 'string'},
			{name: 'DUTY_FR_MIN'	,text: '빠름'				,type: 'string'},
			{name: 'DUTY_FR_MAX'	,text: '늦음'				,type: 'string'},
			{name: 'DUTY_TO_RANK'	,text: '순위'				,type: 'string'},
			{name: 'DUTY_TO_AVG'	,text: '평균'				,type: 'string'},
			{name: 'DUTY_TO_MIN'	,text: '빠름'				,type: 'string'},
			{name: 'DUTY_TO_MAX'	,text: '늦음'				,type: 'string'},
			{name: 'DUTY_FR_0800'	,text: '~08:30'			,type: 'string'},
			{name: 'DUTY_FR_0815'	,text: '~08:45'			,type: 'string'},
			{name: 'DUTY_FR_0820'	,text: '08:45~'			,type: 'string'},
			{name: 'DUTY_FR_1900'	,text: '~19:00'			,type: 'string'},
			{name: 'DUTY_FR_1930'	,text: '~19:30'			,type: 'string'},
			{name: 'DUTY_FR_1940'	,text: '19:30~'			,type: 'string'}
		]
	});
	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('s_hat851skr_kvaMasterStore1',{
		model	: 's_hat851skr_kvaModel',
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
					read: 's_hat851skr_kvaService.selectList'
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
					dataForm.setValue('TOT_WORKING_DAY'		, records[0].data.TOT_DATE);
					dataForm.setValue('ACTUAL_WORKING_DAY'	, records[0].data.DUTY_DATE);
				}else{
					dataForm.setValue('TOT_WORKING_DAY'		, '');
					dataForm.setValue('ACTUAL_WORKING_DAY'	, '');
				}

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
    			fieldLabel		: '근태기간',
		        xtype			: 'uniDateRangefield',
		        startFieldName	: 'DUTY_FR_DATE',
		        endFieldName	: 'DUTY_TO_DATE',
		        startDate		: UniDate.get('startOfMonth'),
		        endDate			: UniDate.get('today'),
		        allowBlank		: false,	  	
				tdAttrs			: {width: 380}, 
//		        width			: 470,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				},
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
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
			}, 
			Unilite.popup('Employee',{
				fieldLabel		: '사원',
				valueFieldName	: 'PERSON_NUMB',
				textFieldName	: 'NAME',
//				colspan			: 2,
				validateBlank	: false,
				autoPopup		: true,
//				allowBlank		: false,
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
			})
		]
	});
	
	var dataForm = Unilite.createSearchForm('panelDetailForm',{
		padding:'0 1 0 1',
		layout : {type : 'uniTable', columns : 4},
		border:true,
		region: 'center',
		items: [{ 
				fieldLabel	: '총근무일수',
				name		: 'TOT_WORKING_DAY',
				xtype		: 'uniNumberfield',
				readOnly	: true,
				focusable	: false,	  	
				tdAttrs		: {width: 380},
				listeners:{
					afterrender:function(field)	{
//						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick:function(event, elm)	{					
//					detailForm.openCryptRepreNoPopup();
				}
			},{ 
				fieldLabel	: '실근무일수',
				name		: 'ACTUAL_WORKING_DAY',
				xtype		: 'uniNumberfield',
				readOnly	: true,
				focusable	: false,	  	
				tdAttrs		: {width: 380},
				listeners:{
					afterrender:function(field)	{
//						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick:function(event, elm)	{					
//					detailForm.openCryptRepreNoPopup();
				}
			}]
	});
	
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_hat851skr_kvaGrid1', {
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
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'	, width: 110	, hidden: true},
			{ dataIndex: 'DEPT_CODE'	, width: 110	},
			{ dataIndex: 'DEPT_NAME'	, width: 110	},
			{ dataIndex: 'PERSON_NUMB'	, width: 110	},
			{ dataIndex: 'PERSON_NAME'	, width: 110	},
			{ dataIndex: 'POST_CODE'	, width: 100	, hidden: true},
			{ dataIndex: 'POST_NAME'	, width: 150	},
			{ dataIndex: 'DUTY_CNT'		, width: 100	},
			{ dataIndex: 'DUTY_21_CNT'	, width: 100	},
			{ dataIndex: 'DUTY_61_CNT'	, width: 100	},
			{ dataIndex: 'DUTY_07_CNT'	, width: 100	},
			{ dataIndex: 'DUTY_06_CNT'	, width: 100	},
			{text: '출근시간', 
              	columns:[
					{ dataIndex: 'DUTY_FR_RANK'	, width: 100	},
					{ dataIndex: 'DUTY_FR_AVG'	, width: 100	},
					{ dataIndex: 'DUTY_FR_MIN'	, width: 100	},
					{ dataIndex: 'DUTY_FR_MAX'	, width: 100	}
			]},
			{text: '퇴근시간', 
              	columns:[
					{ dataIndex: 'DUTY_TO_RANK'	, width: 100	},
					{ dataIndex: 'DUTY_TO_AVG'	, width: 100	},
					{ dataIndex: 'DUTY_TO_MIN'	, width: 100	},
					{ dataIndex: 'DUTY_TO_MAX'	, width: 100	}
			]},
			{text: '출근시간 분포', 
              	columns:[
					{ dataIndex: 'DUTY_FR_0800'	, width: 100	},
					{ dataIndex: 'DUTY_FR_0815'	, width: 100	},
					{ dataIndex: 'DUTY_FR_0820'	, width: 100	}
			]},
			{text: '퇴근시간 분포', 
              	columns:[
					{ dataIndex: 'DUTY_FR_1900'	, width: 100	},
					{ dataIndex: 'DUTY_FR_1930'	, width: 100	},
					{ dataIndex: 'DUTY_FR_1940'	, width: 100	}
			]}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
	
	
	
	Unilite.Main({
		id  : 's_hat851skr_kvaApp',
		borderItems:[{
		  region:'center',
		  layout: {type: 'vbox', align: 'stretch'},
		  border: false,
		  items:[
				panelResult, dataForm, masterGrid 
		  ]}
		], 
		fnInitBinding : function() {
			//초기값 설정
			panelResult.setValue('DUTY_FR_DATE'	, UniDate.get('startOfMonth'));
			panelResult.setValue('DUTY_TO_DATE'	, UniDate.get('today'));
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DUTY_FR_DATE');
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
			UniAppManager.setToolbarButtons('reset', true);
		},				
				
		onResetButtonDown: function() {		
			panelResult.clearForm();	
			dataForm.clearForm();
			masterGrid.getStore().loadData({});	
			this.fnInitBinding();	
		}		
	});
};
</script>
