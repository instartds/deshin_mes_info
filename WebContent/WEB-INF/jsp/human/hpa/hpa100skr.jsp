<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa100skr">
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="H024" />					<!-- 사원구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {
	var gsTab1AnuRate = '';
	var gsTab1MedRate = '';
	var gsTab1LciRate = '';
	var gsTab2AnuRate = '';
	var gsTab2MedRate = '';
	var gsTab2LciRate = '';
	
	/** Model 정의 
	 * @type 
	 */
	//국민연금 Model
	Unilite.defineModel('hpa100skrModel', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'DIV_CODE'			,text: 'DIV_CODE'		,type: 'string'		, comboType: 'BOR120'},
			{name: 'PERSON_NAME'		,text: '성명'				,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'			,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민등록번호'		,type: 'string'},
			{name: 'JOIN_DATE'			,text: '취득일자'			,type: 'uniDate'},
			{name: 'DED_AMOUNT_I'		,text: '각출료'			,type: 'uniPrice'},
			{name: 'REMARK'				,text: '비고'				,type: 'string'}
		]
	});
	
	//건강보험 Model
	Unilite.defineModel('hpa100skrModel2', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'DIV_CODE'			,text: 'DIV_CODE'		,type: 'string'		, comboType: 'BOR120'},
			{name: 'PERSON_NAME'		,text: '성명'				,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'			,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민등록번호'		,type: 'string'},
			{name: 'JOIN_DATE'			,text: '취득일자'			,type: 'uniDate'},
			{name: 'MED_AMOUNT_I'		,text: '산출보험료'		,type: 'uniPrice'},
			{name: 'LCI_AMOUNT_I'		,text: '장기요양보험'		,type: 'uniPrice'},
			{name: 'RME_AMOUNT_I'		,text: '정산보험료'		,type: 'uniPrice'},
			{name: 'SUM_AMOUNT_I'		,text: '부과금액(계)'		,type: 'uniPrice'}
		]
	});
	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore1 = Unilite.createStore('hpa100skrMasterStore1',{
		model	: 'hpa100skrModel',
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
					read: 'hpa100skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			//국민연금 flag
			param.WORK_GB = '1'
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid1.getStore().getCount();  
				if(count > 0){
					dataForm.setValue('MED_RATE'	, records[0].data.MED_RATE);
					dataForm.setValue('LCI_RATE'	, records[0].data.LCI_RATE);
					dataForm.setValue('ANU_RATE'	, records[0].data.ANU_RATE);
				}else{
					dataForm.setValue('MED_RATE'	, '');
					dataForm.setValue('LCI_RATE'	, '');
					dataForm.setValue('ANU_RATE'	, '');
				}
			}
		}
	});
	
	var masterStore2 = Unilite.createStore('hpa100skrMasterStore2', {
		model	: 'hpa100skrModel2',
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
				read: 'hpa100skrService.selectList'				
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('panelResultForm').getValues();	
			//건강보험 flag
			param.WORK_GB = '2'		
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid2.getStore().getCount();  
				if(count > 0){
					dataForm.setValue('MED_RATE'	, records[0].data.MED_RATE);
					dataForm.setValue('LCI_RATE'	, records[0].data.LCI_RATE);
					dataForm.setValue('ANU_RATE'	, records[0].data.ANU_RATE);
				}else{
					dataForm.setValue('MED_RATE'	, '');
					dataForm.setValue('LCI_RATE'	, '');
					dataForm.setValue('ANU_RATE'	, '');
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
				fieldLabel	: '급여년월',	
				name		: 'PAY_YYYYMM', 
				xtype		: 'uniMonthfield',
				id			: 'frToDate',				
				value		: new Date(),				
				allowBlank	: false,	  	
				tdAttrs		: {width: 380} 
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
				fieldLabel	: '건강보험율',
				name		: 'MED_RATE',
				xtype		: 'uniTextfield',
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
				fieldLabel	: '요양보험율',
				name		: 'LCI_RATE',
				xtype		: 'uniTextfield',
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
				fieldLabel	: '국민보험율',
				name		: 'ANU_RATE',
				xtype		: 'uniTextfield',
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
	var masterGrid1 = Unilite.createGrid('hpa100skrGrid1', {
		store	: masterStore1,
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
			{id: 'masterGrid1SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGrid1Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 110	, hidden: true},
			{ dataIndex: 'PERSON_NAME'		, width: 110	},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'REPRE_NUM'		, width: 130	},
			{ dataIndex: 'JOIN_DATE'		, width: 100	},
			{ dataIndex: 'DED_AMOUNT_I'		, width: 150	},
			{ dataIndex: 'REMARK'			, width: 230	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
 
	var masterGrid2 = Unilite.createGrid('hpa100skrGrid2', {
		store	: masterStore2,
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
			{id: 'masterGrid1SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGrid1Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 110	, hidden: true},
			{ dataIndex: 'PERSON_NAME'		, width: 110	},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'REPRE_NUM'		, width: 130	},
			{ dataIndex: 'JOIN_DATE'		, width: 100	},
			{ dataIndex: 'MED_AMOUNT_I'		, width: 150	},
			{ dataIndex: 'LCI_AMOUNT_I'		, width: 150	},
			{ dataIndex: 'RME_AMOUNT_I'		, width: 150	},
			{ dataIndex: 'SUM_AMOUNT_I'		, width: 150	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
	
	
	
	var tab = Unilite.createTabPanel('hpa100skrTab',{		
		region		: 'center',
		activeTab	: 0,
		border		: false,
		items		: [{
				title	: '국민연금 명세서',
				xtype	: 'container',
				itemId	: 'hpa100skrTab1',
				layout	: {type:'vbox', align:'stretch'},
				items	: [
					masterGrid1
				]
			},{
				title	: '건강보험 명세서',
				xtype	: 'container',
				itemId	: 'hpa100skrTab2',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid2
				]
			}
		],
		listeners:{
			tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
				if(newCard == oldCard) {
					return false;
				}
				if(newCard.getItemId() == 'hpa100skrTab1')	{
					gsTab2AnuRate = dataForm.getValue('ANU_RATE');
					gsTab2MedRate = dataForm.getValue('MED_RATE');
					gsTab2LciRate = dataForm.getValue('LCI_RATE');
					
					dataForm.setValue('ANU_RATE', gsTab1AnuRate);
					dataForm.setValue('MED_RATE', gsTab1MedRate);
					dataForm.setValue('LCI_RATE', gsTab1LciRate);
					
				} else {
					gsTab1AnuRate = dataForm.getValue('ANU_RATE');
					gsTab1MedRate = dataForm.getValue('MED_RATE');
					gsTab1LciRate = dataForm.getValue('LCI_RATE');
					
					dataForm.setValue('ANU_RATE', gsTab2AnuRate);
					dataForm.setValue('MED_RATE', gsTab2MedRate);
					dataForm.setValue('LCI_RATE', gsTab2LciRate);
				}
			}
		}
	})
	
	
	
	Unilite.Main({
		id  : 'hpa100skrApp',
		borderItems:[{
		  region:'center',
		  layout: {type: 'vbox', align: 'stretch'},
		  border: false,
		  items:[
				panelResult, dataForm, tab 
		  ]}
		], 
		fnInitBinding : function() {
			//초기값 설정
			gsTab1AnuRate = '';
			gsTab1MedRate = '';
			gsTab1LciRate = '';
			gsTab2AnuRate = '';
			gsTab2MedRate = '';
			gsTab2LciRate = '';
			panelResult.setValue('PAY_YYYYMM'	, new Date());
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('PAY_YYYYMM');
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
			
			//활성화 된 탭에 따른 조회로직
			var activeTab = tab.getActiveTab().getItemId();
			/* 건강보험 명세서 */
			if (activeTab == 'hpa100skrTab1'){
//				UniAppManager.setToolbarButtons(['reset'],false);
//				UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
				masterStore1.loadStoreRecords();

			/* 국민연금 명세서 */
			} else {
				masterStore2.loadStoreRecords();
			}
			UniAppManager.setToolbarButtons('reset', true);
		},				
				
		onResetButtonDown: function() {		
			panelResult.clearForm();	
			dataForm.clearForm();
			masterGrid1.getStore().loadData({});	
			masterGrid2.getStore().loadData({});
			this.fnInitBinding();	
		}
	});
};


</script>
