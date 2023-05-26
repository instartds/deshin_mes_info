<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum560skr">
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 				<!-- 직위 -->
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
	//1: 입사일별
	Unilite.defineModel('hum560skrModel1', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'JOIN_DATE'			,text: '입사일자'			,type: 'uniDate'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'			,type: 'string'},
			{name: 'PERSON_NAME'		,text: '성명'				,type: 'string'},
			{name: 'POST_CODE'			,text: '직책'				,type: 'string'		,comboType: 'AU'	,comboCode: 'H005'},
			{name: 'POST_NAME'			,text: '직위명'			,type: 'string'},
			{name: 'EMPLOY_TYPE'		,text: '직종'				,type: 'string'		,comboType: 'AU'	,comboCode: 'H024'},
			{name: 'EMPLOY_NAME'		,text: '사원구분명'		,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민번호'			,type: 'string'}
		]
	});
	
	//2: 퇴사일별
	Unilite.defineModel('hum560skrModel2', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'RETR_DATE'			,text: '퇴사일자'			,type: 'uniDate'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'			,type: 'string'},
			{name: 'PERSON_NAME'		,text: '성명'				,type: 'string'},
			{name: 'POST_CODE'			,text: '직책'				,type: 'string'		,comboType: 'AU'	,comboCode: 'H005'},
			{name: 'POST_NAME'			,text: '직위명'			,type: 'string'},
			{name: 'EMPLOY_TYPE'		,text: '직종'				,type: 'string'		,comboType: 'AU'	,comboCode: 'H024'},
			{name: 'EMPLOY_NAME'		,text: '사원구분명'		,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민번호'			,type: 'string'}
		]
	});

	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */			
	//1: 입사일별		
	var masterStore1 = Unilite.createStore('hum560skrMasterStore1',{
		model	: 'hum560skrModel1',
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
					read: 'hum560skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			//1: 입사일별 flag
			param.WORK_GB = '1'
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
//				var count = masterGrid1.getStore().getCount();  
//				if(count > 0){
//					UniAppManager.setToolbarButtons(['print'], true);
//				}else{
//					UniAppManager.setToolbarButtons(['print'], false);
//				}
			}
		}
	});
	
	//2: 퇴사일별	
	var masterStore2 = Unilite.createStore('hum560skrMasterStore2',{
		model	: 'hum560skrModel2',
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
					read: 'hum560skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			//2: 퇴사일별	flag
			param.WORK_GB = '2'
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
//				var count = masterGrid2.getStore().getCount();  
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
    			fieldLabel		: '기준일',
		        xtype			: 'uniDateRangefield',
		        startFieldName	: 'JOIN_FR_DATE',
		        endFieldName	: 'JOIN_TO_DATE',
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
	
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	//1: 입사일별
	var masterGrid1 = Unilite.createGrid('hum560skrGrid1', {
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
		
        tbar: [{
                itemId : 'GWBtn',
                id:'GW1',
                iconCls : 'icon-referance'  ,
                text:'기안',
                handler: function() {
                    var param = panelResult.getValues();
                    
                    if(!UniAppManager.app.isValidSearchForm()){
                        return false;
                    }
                
                    //param.DRAFT_NO = "0";
                    if(confirm('기안 하시겠습니까?')) {
                       UniAppManager.app.requestApprove();
                    }
                    //UniAppManager.app.onQueryButtonDown();
                }
            }
        ],
		
		features: [ 
			{id: 'masterGrid1SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGrid1Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'JOIN_DATE'		, width: 100	},
			{ dataIndex: 'DEPT_CODE'		, width: 110	},
			{ dataIndex: 'DEPT_NAME'		, width: 110	},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'PERSON_NAME'		, width: 110	},
			{ dataIndex: 'POST_CODE'		, width: 110	},
			{ dataIndex: 'POST_NAME'		, width: 100	, hidden: true},
			{ dataIndex: 'EMPLOY_TYPE'		, width: 110	},
			{ dataIndex: 'EMPLOY_NAME'		, width: 100	, hidden: true},
			{ dataIndex: 'REPRE_NUM'		, width: 130	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
	
	//2: 퇴사일별
	var masterGrid2 = Unilite.createGrid('hum560skrGrid2', {
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
		}
		
		features: [ 
			{id: 'masterGrid1SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGrid1Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'RETR_DATE'		, width: 100	},
			{ dataIndex: 'DEPT_CODE'		, width: 110	},
			{ dataIndex: 'DEPT_NAME'		, width: 110	},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'PERSON_NAME'		, width: 110	},
			{ dataIndex: 'POST_CODE'		, width: 110	},
			{ dataIndex: 'POST_NAME'		, width: 100	, hidden: true},
			{ dataIndex: 'EMPLOY_TYPE'		, width: 110	},
			{ dataIndex: 'EMPLOY_NAME'		, width: 100	, hidden: true},
			{ dataIndex: 'REPRE_NUM'		, width: 130	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
	
	
	
	var tab = Unilite.createTabPanel('hum560skrTab',{		
		region		: 'center',
		activeTab	: 0,
		border		: false,
		items		: [{
				title	: '입사일별',
				xtype	: 'container',
				itemId	: 'hum560skrTab1',
				layout	: {type:'vbox', align:'stretch'},
				items	: [
					masterGrid1
				]
			},{
				title	: '퇴사일별',
				xtype	: 'container',
				itemId	: 'hum560skrTab2',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid2
				]
			}
		],
		listeners:{
			tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
				if(newCard.getItemId() == 'agj100ukrvTab1')	{
					
				}else {
					
				}
			}
		}
	})
 
	
	
	
	Unilite.Main({
		id  : 'hum560skrApp',
		borderItems:[{
		  region:'center',
		  layout: {type: 'vbox', align: 'stretch'},
		  border: false,
		  items:[
				panelResult, tab 
		  ]}
		], 
		fnInitBinding : function() {
			//초기값 설정
			panelResult.setValue('JOIN_FR_DATE'	, UniDate.get('startOfMonth'));
			panelResult.setValue('JOIN_TO_DATE'	, UniDate.get('today'));
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('JOIN_FR_DATE');
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
			
			//활성화 된 탭에 따른 조회로직
			var activeTab = tab.getActiveTab().getItemId();
			//1: 입사일별
			if (activeTab == 'hum560skrTab1'){
				masterStore1.loadStoreRecords();

			//2: 퇴사일별
			} else if (activeTab == 'hum560skrTab2'){
				masterStore2.loadStoreRecords();
			}
			
			UniAppManager.setToolbarButtons('reset', true);
		},				
				
		onResetButtonDown: function() {		
			panelResult.clearForm();
			masterGrid1.getStore().loadData({});	
			masterGrid2.getStore().loadData({});
			this.fnInitBinding();	
		}
	});
};


</script>
