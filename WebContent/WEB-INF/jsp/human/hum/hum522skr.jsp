<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum522skr">
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="HX08" />					<!-- 성별 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {

	/** Model 정의 
	 * @type 
	 */
	//1: 전체
	Unilite.defineModel('hum522skrModel1', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'LABOR_UNON_CODE'	,text: '노조명'			,type: 'string', comboType:'AU',comboCode:'H201'},
			{name: 'DIV_CODE'			,text: '사업장'			,type: 'string', comboType:'BOR120'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'POST_CODE'			,text: '직위'				,type: 'string', comboType:'AU',comboCode:'H005'},
			{name: 'ABIL_CODE'			,text: '직급'				,type: 'string', comboType:'AU',comboCode:'H006'},
			{name: 'PERSON_NUMB'		,text: '사번'				,type: 'string'},
			{name: 'NAME'				,text: '이름'				,type: 'string'},
			{name: 'SEX_CODE'			,text: '성별'				,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민번호'			,type: 'string'},
			{name: 'JOIN_DATE'			,text: '입사일'			,type: 'uniDate'},
			{name: 'JOIN_CODE'			,text: '입사방식'			,type: 'string', comboType:'AU',comboCode:'H012'},
			{name: 'PAY_CODE'			,text: '급여지급방식'		,type: 'string', comboType:'AU',comboCode:'H028'},
			{name: 'PAY_GUBUN'			,text: '고용형태'			,type: 'string', comboType:'AU',comboCode:'H011'},
			{name: 'EMPLOY_TYPE'		,text: '사원구분'			,type: 'string', comboType:'AU',comboCode:'H024'},
			{name: 'RETR_DATE'			,text: '퇴사일'			,type: 'uniDate'},
			{name: 'PHONE_NO'			,text: '연락처'			,type: 'string'},
			{name: 'EMAIL_ADDR'			,text: '이메일 주소'		,type: 'string'},
			{name: 'LABOR_UNON_YN'		,text: '노조가입여부'		,type: 'string'}
		]
	});
	
	//2: 공사노조
	Unilite.defineModel('hum522skrModel2', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'LABOR_UNON_CODE'	,text: '노조명'			,type: 'string', comboType:'AU',comboCode:'H201'},
			{name: 'DIV_CODE'			,text: '사업장'			,type: 'string', comboType:'BOR120'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'POST_CODE'			,text: '직위'				,type: 'string', comboType:'AU',comboCode:'H005'},
			{name: 'ABIL_CODE'			,text: '직급'				,type: 'string', comboType:'AU',comboCode:'H006'},
			{name: 'PERSON_NUMB'		,text: '사번'				,type: 'string'},
			{name: 'NAME'				,text: '이름'				,type: 'string'},
			{name: 'SEX_CODE'			,text: '성별'				,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민번호'			,type: 'string'},
			{name: 'JOIN_DATE'			,text: '입사일'			,type: 'uniDate'},
			{name: 'JOIN_CODE'			,text: '입사방식'			,type: 'string', comboType:'AU',comboCode:'H012'},
			{name: 'PAY_CODE'			,text: '급여지급방식'		,type: 'string', comboType:'AU',comboCode:'H028'},
			{name: 'PAY_GUBUN'			,text: '고용형태'			,type: 'string', comboType:'AU',comboCode:'H011'},
			{name: 'EMPLOY_TYPE'		,text: '사원구분'			,type: 'string', comboType:'AU',comboCode:'H024'},
			{name: 'RETR_DATE'			,text: '퇴사일'			,type: 'uniDate'},
			{name: 'PHONE_NO'			,text: '연락처'			,type: 'string'},
			{name: 'EMAIL_ADDR'			,text: '이메일 주소'		,type: 'string'},
			{name: 'LABOR_UNON_YN'		,text: '노조가입여부'		,type: 'string'}
		]
	});
	
	//3: 우리민주
	Unilite.defineModel('hum522skrModel3', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'LABOR_UNON_CODE'	,text: '노조명'			,type: 'string', comboType:'AU',comboCode:'H201'},
			{name: 'DIV_CODE'			,text: '사업장'			,type: 'string', comboType:'BOR120'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'POST_CODE'			,text: '직위'				,type: 'string', comboType:'AU',comboCode:'H005'},
			{name: 'ABIL_CODE'			,text: '직급'				,type: 'string', comboType:'AU',comboCode:'H006'},
			{name: 'PERSON_NUMB'		,text: '사번'				,type: 'string'},
			{name: 'NAME'				,text: '이름'				,type: 'string'},
			{name: 'SEX_CODE'			,text: '성별'				,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민번호'			,type: 'string'},
			{name: 'JOIN_DATE'			,text: '입사일'			,type: 'uniDate'},
			{name: 'JOIN_CODE'			,text: '입사방식'			,type: 'string', comboType:'AU',comboCode:'H012'},
			{name: 'PAY_CODE'			,text: '급여지급방식'		,type: 'string', comboType:'AU',comboCode:'H028'},
			{name: 'PAY_GUBUN'			,text: '고용형태'			,type: 'string', comboType:'AU',comboCode:'H011'},
			{name: 'EMPLOY_TYPE'		,text: '사원구분'			,type: 'string', comboType:'AU',comboCode:'H024'},
			{name: 'RETR_DATE'			,text: '퇴사일'			,type: 'uniDate'},
			{name: 'PHONE_NO'			,text: '연락처'			,type: 'string'},
			{name: 'EMAIL_ADDR'			,text: '이메일 주소'		,type: 'string'},
			{name: 'LABOR_UNON_YN'		,text: '노조가입여부'		,type: 'string'}
		]
	});
	
	//4: 기타
	Unilite.defineModel('hum522skrModel4', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'LABOR_UNON_CODE'	,text: '노조명'			,type: 'string', comboType:'AU',comboCode:'H201'},
			{name: 'DIV_CODE'			,text: '사업장'			,type: 'string', comboType:'BOR120'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'POST_CODE'			,text: '직위'				,type: 'string', comboType:'AU',comboCode:'H005'},
			{name: 'ABIL_CODE'			,text: '직급'				,type: 'string', comboType:'AU',comboCode:'H006'},
			{name: 'PERSON_NUMB'		,text: '사번'				,type: 'string'},
			{name: 'NAME'				,text: '이름'				,type: 'string'},
			{name: 'SEX_CODE'			,text: '성별'				,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민번호'			,type: 'string'},
			{name: 'JOIN_DATE'			,text: '입사일'			,type: 'uniDate'},
			{name: 'JOIN_CODE'			,text: '입사방식'			,type: 'string', comboType:'AU',comboCode:'H012'},
			{name: 'PAY_CODE'			,text: '급여지급방식'		,type: 'string', comboType:'AU',comboCode:'H028'},
			{name: 'PAY_GUBUN'			,text: '고용형태'			,type: 'string', comboType:'AU',comboCode:'H011'},
			{name: 'EMPLOY_TYPE'		,text: '사원구분'			,type: 'string', comboType:'AU',comboCode:'H024'},
			{name: 'RETR_DATE'			,text: '퇴사일'			,type: 'uniDate'},
			{name: 'PHONE_NO'			,text: '연락처'			,type: 'string'},
			{name: 'EMAIL_ADDR'			,text: '이메일 주소'		,type: 'string'},
			{name: 'LABOR_UNON_YN'		,text: '노조가입여부'		,type: 'string'}
		]
	});
	
	//5: 미가입
	Unilite.defineModel('hum522skrModel5', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'LABOR_UNON_CODE'	,text: '노조명'			,type: 'string'},
			{name: 'DIV_CODE'			,text: '사업장'			,type: 'string', comboType:'BOR120'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'POST_CODE'			,text: '직위'				,type: 'string', comboType:'AU',comboCode:'H005'},
			{name: 'ABIL_CODE'			,text: '직급'				,type: 'string', comboType:'AU',comboCode:'H006'},
			{name: 'PERSON_NUMB'		,text: '사번'				,type: 'string'},
			{name: 'NAME'				,text: '이름'				,type: 'string'},
			{name: 'SEX_CODE'			,text: '성별'				,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민번호'			,type: 'string'},
			{name: 'JOIN_DATE'			,text: '입사일'			,type: 'uniDate'},
			{name: 'JOIN_CODE'			,text: '입사방식'			,type: 'string', comboType:'AU',comboCode:'H012'},
			{name: 'PAY_CODE'			,text: '급여지급방식'		,type: 'string', comboType:'AU',comboCode:'H028'},
			{name: 'PAY_GUBUN'			,text: '고용형태'			,type: 'string', comboType:'AU',comboCode:'H011'},
			{name: 'EMPLOY_TYPE'		,text: '사원구분'			,type: 'string', comboType:'AU',comboCode:'H024'},
			{name: 'RETR_DATE'			,text: '퇴사일'			,type: 'uniDate'},
			{name: 'PHONE_NO'			,text: '연락처'			,type: 'string'},
			{name: 'EMAIL_ADDR'			,text: '이메일 주소'		,type: 'string'},
			{name: 'LABOR_UNON_YN'		,text: '노조가입여부'		,type: 'string'}
		]
	});
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */			
	//1: 전체
	var masterStore1 = Unilite.createStore('hum522skrMasterStore1',{
		model	: 'hum522skrModel1',
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
					read: 'hum522skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();

			param.WORK_GB = '1'
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'LABOR_UNON_CODE',
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid1.getStore().getCount();  
				if(count > 0){
					UniAppManager.setToolbarButtons(['print'], true);
				}else{
					UniAppManager.setToolbarButtons(['print'], false);
				}

			}
		}
	});
	
	//2: 공사노조	
	var masterStore2 = Unilite.createStore('hum522skrMasterStore2',{
		model	: 'hum522skrModel2',
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
					read: 'hum522skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();

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
					UniAppManager.setToolbarButtons(['print'], true);
				}else{
					UniAppManager.setToolbarButtons(['print'], false);
				}

			}
		}
	});
	
	//3: 우리민주
	var masterStore3 = Unilite.createStore('hum522skrMasterStore3',{
		model	: 'hum522skrModel3',
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
					read: 'hum522skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();

			param.WORK_GB = '3'
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid3.getStore().getCount();  
				if(count > 0){
					UniAppManager.setToolbarButtons(['print'], true);
				}else{
					UniAppManager.setToolbarButtons(['print'], false);
				}

			}
		}
	});
	
	//4: 기타
	var masterStore4 = Unilite.createStore('hum522skrMasterStore4',{
		model	: 'hum522skrModel4',
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
					read: 'hum522skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();

			param.WORK_GB = '4'
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid4.getStore().getCount();  
				if(count > 0){
					UniAppManager.setToolbarButtons(['print'], true);
				}else{
					UniAppManager.setToolbarButtons(['print'], false);
				}

			}
		}
	});
	
	//5: 미가입
	var masterStore5 = Unilite.createStore('hum522skrMasterStore5',{
		model	: 'hum522skrModel5',
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
					read: 'hum522skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			//3: 미가입
			param.WORK_GB = '5'
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid5.getStore().getCount();  
				if(count > 0){
					UniAppManager.setToolbarButtons(['print'], true);
				}else{
					UniAppManager.setToolbarButtons(['print'], false);
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
				fieldLabel	: '기준일',	
				name		: 'ST_DATE', 
				xtype		: 'uniDatefield',
				id			: 'stDate',				
				value		: new Date(),				
				//allowBlank	: false,	  	
				tdAttrs		: {width: 380} 
			}
//			,{
//				xtype		: 'component',
//				width		: 200
//			}
			,  
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
//				textFieldWidth:89,
				textFieldWidth: 159,
				validateBlank:true,
//				width:300,
				autoPopup:true,
				useLike:true,
				listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	//panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	//panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			}),
			
            Unilite.popup('Employee',{
            fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
            valueFieldName:'PERSON_NUMB',
            textFieldName:'NAME',
            validateBlank:false,
            autoPopup:true,
            listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
                            //panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
                            //panelResult.setValue('NAME', panelSearch.getValue('NAME'));                                                                                                             
                        },
                        scope: this
                    },
                    onClear: function(type)    {
                        panelResult.setValue('PERSON_NUMB', '');
                        panelResult.setValue('NAME', '');
                    },
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('PERSON_NUMB', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('NAME', newValue);                
                    }
                }
            }),
            
            {
                xtype: 'radiogroup',                            
                fieldLabel: '<t:message code="system.label.human.sexcode" default="성별"/>',                    
                items: [{
                    boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
                    width: 70, 
                    name: 'SEX_CODE',
                    inputValue: '',
                    checked: true  
                },{
                    boxLabel : '<t:message code="system.label.human.male" default="남"/>', 
                    width: 70,
                    name: 'SEX_CODE',
                    inputValue: 'M'
                },{
                    boxLabel: '<t:message code="system.label.human.female" default="여"/>', 
                    width: 70, 
                    name: 'SEX_CODE',
                    inputValue: 'F' 
                }]
            },
            {
                xtype: 'radiogroup',                            
                fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',           
                items: [{
                    boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
                    width: 70, 
                    name: 'RDO_TYPE',
                    inputValue: ''  
                },{
                    boxLabel : '<t:message code="system.label.human.incumbent" default="재직"/>', 
                    width: 70,
                    name: 'RDO_TYPE',
                    inputValue: 'Z',
                    checked: true
                },{
                    boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>', 
                    width: 70, 
                    name: 'RDO_TYPE',
                    inputValue: '00000000'  
                }]
            }
			
		]
	});
	
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	//1: 전체
	var masterGrid1 = Unilite.createGrid('hum522skrGrid1', {
		store	: masterStore1,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {	
			expandLastColumn	: true,			//마지막 컬럼 * 사용 여부
			useRowNumberer		: true,			//첫번째 컬럼 순번 사용 여부
			useLiveSearch		: true,			//찾기 버튼 사용 여부
			useRowContext		: false,			
			onLoadSelectFirst	: true,
			
			excel: {
				useExcel      : true,		//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
			},
			
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
			{ dataIndex: 'LABOR_UNON_CODE'	, width: 110	},
			{ dataIndex: 'DIV_CODE'			, width: 150	},
			{ dataIndex: 'DEPT_CODE'		, width: 110	},
			{ dataIndex: 'DEPT_NAME'		, width: 180	},
			{ dataIndex: 'POST_CODE'		, width: 110	},
			{ dataIndex: 'ABIL_CODE'		, width: 110	},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'NAME'				, width: 110	},
			{ dataIndex: 'SEX_CODE'			, width: 110	},
			{ dataIndex: 'REPRE_NUM'		, width: 130	},
			{ dataIndex: 'JOIN_DATE'		, width: 110	},
			{ dataIndex: 'JOIN_CODE'		, width: 110	},
			{ dataIndex: 'PAY_CODE'			, width: 110	},
			{ dataIndex: 'PAY_GUBUN'		, width: 110	},
			{ dataIndex: 'EMPLOY_TYPE'		, width: 110	},
			{ dataIndex: 'RETR_DATE'		, width: 110	},
			{ dataIndex: 'PHONE_NO'			, width: 130	},
			{ dataIndex: 'EMAIL_ADDR'		, width: 200	},
			{ dataIndex: 'LABOR_UNON_YN'	, width: 110	, hidden: true}
			
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
	
	//2: 공사노조
	var masterGrid2 = Unilite.createGrid('hum522skrGrid2', {
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
			{id: 'masterGrid2SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGrid2Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'LABOR_UNON_CODE'	, width: 110	},
			{ dataIndex: 'DIV_CODE'			, width: 150	},
			{ dataIndex: 'DEPT_CODE'		, width: 110	},
			{ dataIndex: 'DEPT_NAME'		, width: 180	},
			{ dataIndex: 'POST_CODE'		, width: 110	},
			{ dataIndex: 'ABIL_CODE'		, width: 110	},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'NAME'				, width: 110	},
			{ dataIndex: 'SEX_CODE'			, width: 110	},
			{ dataIndex: 'REPRE_NUM'		, width: 130	},
			{ dataIndex: 'JOIN_DATE'		, width: 110	},
			{ dataIndex: 'JOIN_CODE'		, width: 110	},
			{ dataIndex: 'PAY_CODE'			, width: 110	},
			{ dataIndex: 'PAY_GUBUN'		, width: 110	},
			{ dataIndex: 'EMPLOY_TYPE'		, width: 110	},
			{ dataIndex: 'RETR_DATE'		, width: 110	},
			{ dataIndex: 'PHONE_NO'			, width: 130	},
			{ dataIndex: 'EMAIL_ADDR'		, width: 200	},
			{ dataIndex: 'LABOR_UNON_YN'	, width: 110	, hidden: true}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});		
	
	//3: 우리민주
	var masterGrid3 = Unilite.createGrid('hum522skrGrid3', {
		store	: masterStore3,
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
			{id: 'masterGrid3SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGrid3Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'LABOR_UNON_CODE'	, width: 110	},
			{ dataIndex: 'DIV_CODE'			, width: 150	},
			{ dataIndex: 'DEPT_CODE'		, width: 110	},
			{ dataIndex: 'DEPT_NAME'		, width: 180	},
			{ dataIndex: 'POST_CODE'		, width: 110	},
			{ dataIndex: 'ABIL_CODE'		, width: 110	},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'NAME'				, width: 110	},
			{ dataIndex: 'SEX_CODE'			, width: 110	},
			{ dataIndex: 'REPRE_NUM'		, width: 130	},
			{ dataIndex: 'JOIN_DATE'		, width: 110	},
			{ dataIndex: 'JOIN_CODE'		, width: 110	},
			{ dataIndex: 'PAY_CODE'			, width: 110	},
			{ dataIndex: 'PAY_GUBUN'		, width: 110	},
			{ dataIndex: 'EMPLOY_TYPE'		, width: 110	},
			{ dataIndex: 'RETR_DATE'		, width: 110	},
			{ dataIndex: 'PHONE_NO'			, width: 130	},
			{ dataIndex: 'EMAIL_ADDR'		, width: 200	},
			{ dataIndex: 'LABOR_UNON_YN'	, width: 110	, hidden: true}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
	
	//4: 기타
	var masterGrid4 = Unilite.createGrid('hum522skrGrid4', {
		store	: masterStore4,
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
			{id: 'masterGrid4SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGrid4Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'LABOR_UNON_CODE'	, width: 110	},
			{ dataIndex: 'DIV_CODE'			, width: 150	},
			{ dataIndex: 'DEPT_CODE'		, width: 110	},
			{ dataIndex: 'DEPT_NAME'		, width: 180	},
			{ dataIndex: 'POST_CODE'		, width: 110	},
			{ dataIndex: 'ABIL_CODE'		, width: 110	},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'NAME'				, width: 110	},
			{ dataIndex: 'SEX_CODE'			, width: 110	},
			{ dataIndex: 'REPRE_NUM'		, width: 130	},
			{ dataIndex: 'JOIN_DATE'		, width: 110	},
			{ dataIndex: 'JOIN_CODE'		, width: 110	},
			{ dataIndex: 'PAY_CODE'			, width: 110	},
			{ dataIndex: 'PAY_GUBUN'		, width: 110	},
			{ dataIndex: 'EMPLOY_TYPE'		, width: 110	},
			{ dataIndex: 'RETR_DATE'		, width: 110	},
			{ dataIndex: 'PHONE_NO'			, width: 130	},
			{ dataIndex: 'EMAIL_ADDR'		, width: 200	},
			{ dataIndex: 'LABOR_UNON_YN'	, width: 110	, hidden: true}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
	
	//5: 미가입
	var masterGrid5 = Unilite.createGrid('hum522skrGrid5', {
		store	: masterStore5,
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
			{id: 'masterGrid5SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGrid5Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'LABOR_UNON_CODE'	, width: 110	},
			{ dataIndex: 'DIV_CODE'			, width: 150	},
			{ dataIndex: 'DEPT_CODE'		, width: 110	},
			{ dataIndex: 'DEPT_NAME'		, width: 180	},
			{ dataIndex: 'POST_CODE'		, width: 110	},
			{ dataIndex: 'ABIL_CODE'		, width: 110	},
			{ dataIndex: 'PERSON_NUMB'		, width: 110	},
			{ dataIndex: 'NAME'				, width: 110	},
			{ dataIndex: 'SEX_CODE'			, width: 110	},
			{ dataIndex: 'REPRE_NUM'		, width: 130	},
			{ dataIndex: 'JOIN_DATE'		, width: 110	},
			{ dataIndex: 'JOIN_CODE'		, width: 110	},
			{ dataIndex: 'PAY_CODE'			, width: 110	},
			{ dataIndex: 'PAY_GUBUN'		, width: 110	},
			{ dataIndex: 'EMPLOY_TYPE'		, width: 110	},
			{ dataIndex: 'RETR_DATE'		, width: 110	},
			{ dataIndex: 'PHONE_NO'			, width: 130	},
			{ dataIndex: 'EMAIL_ADDR'		, width: 200	},
			{ dataIndex: 'LABOR_UNON_YN'	, width: 110	, hidden: true}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
	
	
	
	var tab = Unilite.createTabPanel('hum522skrTab',{		
		region		: 'center',
		activeTab	: 0,
		border		: false,
		items		: [{
				title	: '노조(전체)',
				xtype	: 'container',
				itemId	: 'hum522skrTab1',
				layout	: {type:'vbox', align:'stretch'},
				items	: [
					masterGrid1
				]
			},{
				title	: '공사노조',
				xtype	: 'container',
				itemId	: 'hum522skrTab2',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid2
				]
			},{
				title	: '우리민주',
				xtype	: 'container',
				itemId	: 'hum522skrTab3',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid3
				]
			},{
				title	: '기타',
				xtype	: 'container',
				itemId	: 'hum522skrTab4',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid4
				]
			},{
				title	: '미가입',
				xtype	: 'container',
				itemId	: 'hum522skrTab5',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid5
				]
			}
		],
		listeners:{
			tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
				if(newCard.getItemId() == 'hum522skrTab1')	{
					masterStore1.loadStoreRecords();
				}else if(newCard.getItemId() == 'hum522skrTab2') {
                    masterStore2.loadStoreRecords();
                }else if(newCard.getItemId() == 'hum522skrTab3') {
                    masterStore3.loadStoreRecords();
                }else if(newCard.getItemId() == 'hum522skrTab4') {
                    masterStore4.loadStoreRecords();
                }else if(newCard.getItemId() == 'hum522skrTab5') {
                    masterStore5.loadStoreRecords();
                }
			}
		}
	})
 
	
	Unilite.Main({
		id  : 'hum522skrApp',
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
			panelResult.setValue('ST_DATE'		, new Date());
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('ST_DATE');
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
			//1: 전체
			if (activeTab == 'hum522skrTab1'){
				masterStore1.loadStoreRecords();

			//2: 공사노조
			} else if (activeTab == 'hum522skrTab2'){
				masterStore2.loadStoreRecords();
				
			//3: 우리민주
			} else if (activeTab == 'hum522skrTab3'){
				masterStore3.loadStoreRecords();
			
			//4: 기타
			} else if (activeTab == 'hum522skrTab4'){
				masterStore4.loadStoreRecords();
				
			//5: 미가입
			} else {
				masterStore5.loadStoreRecords();
			}
			UniAppManager.setToolbarButtons('reset', true);
		},				
				
		onResetButtonDown: function() {		
			panelResult.clearForm();
			masterGrid1.getStore().loadData({});	
			masterGrid2.getStore().loadData({});
			masterGrid3.getStore().loadData({});
			masterGrid4.getStore().loadData({});
			masterGrid5.getStore().loadData({});
			
			this.fnInitBinding();	
		}
	});
};


</script>
