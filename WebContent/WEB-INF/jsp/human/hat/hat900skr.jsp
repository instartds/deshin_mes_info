<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat900skr">
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="H004" />					<!-- 근무조 -->
	<t:ExtComboStore comboType="AU" comboCode="H033" />					<!-- 근태코드 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {
	//날짜에 따른 요일 가져오기 위한 전역변수 선언
	var gsToday 		= UniDate.getDbDateStr(new Date());
	var gsDayOfTheWeek	= gsToday.substring(0,4)+ "-"+ gsToday.substring(4,6);
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hat900skrModel', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'												,type: 'string'},
			{name: 'DEPT_CODE'			,text: '부서코드'													,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'													,type: 'string'},
			{name: 'PERSON_NAME'		,text: '성명'														,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'													,type: 'string'},
			{name: 'PAY_YYYYMM'			,text: '급여년월'													,type: 'string'},
			{name: 'POST_CODE'			,text: '직책'														,type: 'string'},
			{name: 'JOIN_GB'			,text: '입,퇴'													,type: 'string'},
			{name: 'DUTY_CODE'			,text: '근태구분'													,type: 'string'		,comboType: 'AU'	, comboCode: 'H033'},
			{name: 'DUTY_NAME'			,text: 'DUTY_NAME'												,type: 'string'},
			{name: 'DUTY_01'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '01')				,type: 'uniNumber'},
			{name: 'DUTY_02'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '02')				,type: 'uniNumber'},
			{name: 'DUTY_03'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '03')				,type: 'uniNumber'},
			{name: 'DUTY_04'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '04')				,type: 'uniNumber'},
			{name: 'DUTY_05'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '05')				,type: 'uniNumber'},
			{name: 'DUTY_06'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '06')				,type: 'uniNumber'},
			{name: 'DUTY_07'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '07')				,type: 'uniNumber'},
			{name: 'DUTY_08'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '08')				,type: 'uniNumber'},
			{name: 'DUTY_09'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '09')				,type: 'uniNumber'},
			{name: 'DUTY_10'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '10')			,type: 'uniNumber'},
			{name: 'DUTY_11'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '11')			,type: 'uniNumber'},
			{name: 'DUTY_12'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '12')			,type: 'uniNumber'},
			{name: 'DUTY_13'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '13')			,type: 'uniNumber'},
			{name: 'DUTY_14'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '14')			,type: 'uniNumber'},
			{name: 'DUTY_15'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '15')			,type: 'uniNumber'},
			{name: 'DUTY_16'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '16')			,type: 'uniNumber'},
			{name: 'DUTY_17'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '17')			,type: 'uniNumber'},
			{name: 'DUTY_18'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '18')			,type: 'uniNumber'},
			{name: 'DUTY_19'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '19')			,type: 'uniNumber'},
			{name: 'DUTY_20'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '20')			,type: 'uniNumber'},
			{name: 'DUTY_21'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '21')			,type: 'uniNumber'},
			{name: 'DUTY_22'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '22')			,type: 'uniNumber'},
			{name: 'DUTY_23'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '23')			,type: 'uniNumber'},
			{name: 'DUTY_24'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '24')			,type: 'uniNumber'},
			{name: 'DUTY_25'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '25')			,type: 'uniNumber'},
			{name: 'DUTY_26'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '26')			,type: 'uniNumber'},
			{name: 'DUTY_27'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '27')			,type: 'uniNumber'},
			{name: 'DUTY_28'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '28')			,type: 'uniNumber'},
			{name: 'DUTY_29'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '29')			,type: 'uniNumber'},
			{name: 'DUTY_30'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '30')			,type: 'uniNumber'},
			{name: 'DUTY_31'			,text: getInputDayLabel(gsDayOfTheWeek + "-" + '31')			,type: 'uniNumber'},
			{name: 'DUTY_TOT'			,text: '계'														,type: 'uniNumber'}
		]
	});
	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hat900skrMasterStore1',{
		model	: 'hat900skrModel',
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
					read: 'hat900skrService.selectList'
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
		items	: [{
				fieldLabel	: '근태월',	
				name		: 'DUTY_MONTH', 
				xtype		: 'uniMonthfield',
				id			: 'dutyMonth',				
				value		: new Date(),				
				allowBlank	: false,
				tdAttrs		: {width: 380},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!Ext.isEmpty(newValue)) {
							gsToday 		= UniDate.getDbDateStr(newValue);
							gsDayOfTheWeek	= gsToday.substring(0,4)+ "-"+ gsToday.substring(4,6);
							setColumnText(gsDayOfTheWeek);
						}
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
//			,{
//				fieldLabel	: '근무조',
//				name		: 'WORK_TEAM', 
//				xtype		: 'uniCombobox',
//				comboType	: 'AU',
//				comboCode	: 'H004',
//				listeners: {
//					change: function(field, newValue, oldValue, eOpts) {
//					}
//		 		}
//			}
		]
	});
	
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('hat900skrGrid1', {
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
			{ dataIndex: 'COMP_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'DEPT_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'DEPT_NAME'		, width: 110	/*, hidden: true*/},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'PERSON_NAME'		, width: 110	},
			{ dataIndex: 'POST_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'JOIN_GB'			, width: 110	},
			{ dataIndex: 'DUTY_CODE'		, width: 110	},
			{ dataIndex: 'DUTY_NAME'		, width: 100	, hidden: true},
			{text: '1', 
              	columns:[
					{ dataIndex: 'DUTY_01'			, width: 80	}
			]},
			{text: '2', 
              	columns:[
					{ dataIndex: 'DUTY_02'			, width: 80	}
			]},
			{text: '3', 
              	columns:[
					{ dataIndex: 'DUTY_03'			, width: 80	}
			]},
			{text: '4', 
              	columns:[
					{ dataIndex: 'DUTY_04'			, width: 80	}
			]},
			{text: '5', 
              	columns:[
					{ dataIndex: 'DUTY_05'			, width: 80	}
			]},
			{text: '6', 
              	columns:[
					{ dataIndex: 'DUTY_06'			, width: 80	}
			]},
			{text: '7', 
              	columns:[
					{ dataIndex: 'DUTY_07'			, width: 80	}
			]},
			{text: '8', 
              	columns:[
					{ dataIndex: 'DUTY_08'			, width: 80	}
			]},
			{text: '9', 
              	columns:[
					{ dataIndex: 'DUTY_09'			, width: 80	}
			]},
			{text: '10', 
              	columns:[
					{ dataIndex: 'DUTY_10'			, width: 80	}
			]},
			{text: '11', 
              	columns:[
					{ dataIndex: 'DUTY_11'			, width: 80	}
			]},
			{text: '12', 
              	columns:[
					{ dataIndex: 'DUTY_12'			, width: 80	}
			]},
			{text: '13', 
              	columns:[
					{ dataIndex: 'DUTY_13'			, width: 80	}
			]},
			{text: '14', 
              	columns:[
					{ dataIndex: 'DUTY_14'			, width: 80	}
			]},
			{text: '15', 
              	columns:[
					{ dataIndex: 'DUTY_15'			, width: 80	}
			]},
			{text: '16', 
              	columns:[
					{ dataIndex: 'DUTY_16'			, width: 80	}
			]},
			{text: '17', 
              	columns:[
					{ dataIndex: 'DUTY_17'			, width: 80	}
			]},
			{text: '18', 
              	columns:[
					{ dataIndex: 'DUTY_18'			, width: 80	}
			]},
			{text: '19', 
              	columns:[
					{ dataIndex: 'DUTY_19'			, width: 80	}
			]},
			{text: '20', 
              	columns:[
					{ dataIndex: 'DUTY_20'			, width: 80	}
			]},
			{text: '21', 
              	columns:[
					{ dataIndex: 'DUTY_21'			, width: 80	}
			]},
			{text: '22', 
              	columns:[
					{ dataIndex: 'DUTY_22'			, width: 80	}
			]},
			{text: '23', 
              	columns:[
					{ dataIndex: 'DUTY_23'			, width: 80	}
			]},
			{text: '24', 
              	columns:[
					{ dataIndex: 'DUTY_24'			, width: 80	}
			]},
			{text: '25', 
              	columns:[
					{ dataIndex: 'DUTY_25'			, width: 80	}
			]},
			{text: '26', 
              	columns:[
					{ dataIndex: 'DUTY_26'			, width: 80	}
			]},
			{text: '27', 
              	columns:[
					{ dataIndex: 'DUTY_27'			, width: 80	}
			]},
			{text: '28', 
              	columns:[
					{ dataIndex: 'DUTY_28'			, width: 80	}
			]},
			{text: '29', 
              	columns:[
					{ dataIndex: 'DUTY_29'			, width: 80	}
			]},
			{text: '30', 
              	columns:[
					{ dataIndex: 'DUTY_30'			, width: 80	}
			]},
			{text: '31', 
              	columns:[
					{ dataIndex: 'DUTY_31'			, width: 80	}
			]},
			{ dataIndex: 'DUTY_TOT'			, width: 120	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
 
	
	
	
	Unilite.Main({
		id  : 'hat900skrApp',
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
			panelResult.setValue('DUTY_MONTH'	, new Date());
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			//컬럼명 set
			gsToday 		= UniDate.getDbDateStr(new Date());
			gsDayOfTheWeek	= gsToday.substring(0,4)+ "-"+ gsToday.substring(4,6);
			setColumnText(gsDayOfTheWeek);
			
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DUTY_MONTH');
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
	
	//날짜 입력 받아 요일 구하는 함수
	function getInputDayLabel(date) { 
		var week = new Array('일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'); 
		var today = new Date(date).getDay(); 
		var todayLabel = week[today]; 

		return todayLabel;
	}
	
	//컬럼에 요일 set
	function setColumnText(gsDayOfTheWeek) { 
		masterGrid.getColumn('DUTY_01').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '01')); 
		masterGrid.getColumn('DUTY_02').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '02')); 
		masterGrid.getColumn('DUTY_03').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '03')); 
		masterGrid.getColumn('DUTY_04').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '04')); 
		masterGrid.getColumn('DUTY_05').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '05')); 
		masterGrid.getColumn('DUTY_06').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '06')); 
		masterGrid.getColumn('DUTY_07').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '07')); 
		masterGrid.getColumn('DUTY_08').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '08')); 
		masterGrid.getColumn('DUTY_09').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '09')); 
		masterGrid.getColumn('DUTY_10').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '10')); 
		masterGrid.getColumn('DUTY_11').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '11')); 
		masterGrid.getColumn('DUTY_12').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '12')); 
		masterGrid.getColumn('DUTY_13').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '13')); 
		masterGrid.getColumn('DUTY_14').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '14')); 
		masterGrid.getColumn('DUTY_15').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '15')); 
		masterGrid.getColumn('DUTY_16').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '16')); 
		masterGrid.getColumn('DUTY_17').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '17')); 
		masterGrid.getColumn('DUTY_18').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '18')); 
		masterGrid.getColumn('DUTY_19').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '19')); 
		masterGrid.getColumn('DUTY_20').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '20')); 
		masterGrid.getColumn('DUTY_21').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '21')); 
		masterGrid.getColumn('DUTY_22').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '22')); 
		masterGrid.getColumn('DUTY_23').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '23')); 
		masterGrid.getColumn('DUTY_24').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '24')); 
		masterGrid.getColumn('DUTY_25').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '25')); 
		masterGrid.getColumn('DUTY_26').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '26')); 
		masterGrid.getColumn('DUTY_27').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '27')); 
		masterGrid.getColumn('DUTY_28').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '28')); 
		masterGrid.getColumn('DUTY_29').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '29')); 
		masterGrid.getColumn('DUTY_30').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '30')); 
		masterGrid.getColumn('DUTY_31').setText(getInputDayLabel(gsDayOfTheWeek + "-" + '31'));
	}
};
</script>
