<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum520skr">
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
	//1: 근속년수별
	Unilite.defineModel('hum520skrModel1', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'SORT_GB'			,text: '구분'				,type: 'string'		, comboType: 'AU', comboCode: 'HX08'},
			{name: 'JOIN_01'			,text: '1년미만'			,type: 'uniNumber'},
			{name: 'JOIN_02'			,text: '1-3'			,type: 'uniNumber'},
			{name: 'JOIN_03'			,text: '3-5'			,type: 'uniNumber'},
			{name: 'JOIN_04'			,text: '5-7'			,type: 'uniNumber'},
			{name: 'JOIN_05'			,text: '7-10'			,type: 'uniNumber'},
			{name: 'JOIN_06'			,text: '10년이상'			,type: 'uniNumber'},
			{name: 'JOIN_07'			,text: '합계'				,type: 'uniNumber'}
		]
	});
	
	//2: 연령별
	Unilite.defineModel('hum520skrModel2', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'SORT_GB'			,text: '성별'				,type: 'string'		, comboType: 'AU', comboCode: 'HX08'},
			{name: 'PERSON_AGE_20'		,text: '15~20'			,type: 'uniNumber'},
			{name: 'PERSON_AGE_25'		,text: '21~25'			,type: 'uniNumber'},
			{name: 'PERSON_AGE_30'		,text: '26~30'			,type: 'uniNumber'},
			{name: 'PERSON_AGE_35'		,text: '31~35'			,type: 'uniNumber'},
			{name: 'PERSON_AGE_40'		,text: '36~40'			,type: 'uniNumber'},
			{name: 'PERSON_AGE_45'		,text: '41~45'			,type: 'uniNumber'},
			{name: 'PERSON_AGE_50'		,text: '46~50'			,type: 'uniNumber'},
			{name: 'PERSON_AGE_55'		,text: '51~55'			,type: 'uniNumber'},
			{name: 'PERSON_AGE_56'		,text: '56이상'			,type: 'uniNumber'},
			{name: 'PERSON_AGE_TOT'		,text: '합계'				,type: 'uniNumber'}
		]
	});
	
	//3: 학력별
	Unilite.defineModel('hum520skrModel3', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'SORT_GB'			,text: '성별'				,type: 'string'		, comboType: 'AU', comboCode: 'HX08'},
			{name: 'SCHOOL_01'			,text: '대학원'			,type: 'uniNumber'},
			{name: 'SCHOOL_02'			,text: '대학교'			,type: 'uniNumber'},
			{name: 'SCHOOL_03'			,text: '전문대'			,type: 'uniNumber'},
			{name: 'SCHOOL_04'			,text: '고등학교'			,type: 'uniNumber'},
			{name: 'SCHOOL_05'			,text: '중학교'			,type: 'uniNumber'},
			{name: 'SCHOOL_06'			,text: '초등학교'			,type: 'uniNumber'},
			{name: 'SCHOOL_07'			,text: '기타'				,type: 'uniNumber'},
			{name: 'SCHOOL_08'			,text: '합계'				,type: 'uniNumber'}
		]
	});
	
	//4: 부서별
	Unilite.defineModel('hum520skrModel4', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'POST_CODE'			,text: '직위'				,type: 'string'},
			{name: 'POST_NAME'			,text: '직위명'			,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사원번호'			,type: 'string'},
			{name: 'PERSON_NAME'		,text: '성명'				,type: 'string'},
			{name: 'EMPLOY_TYPE'		,text: '사원구분'			,type: 'string'},
			{name: 'EMPLOY_NAME'		,text: '사원구분명'		,type: 'string'},
			{name: 'JOIN_DATE'			,text: '입사일자'			,type: 'uniDate'},
			{name: 'REPRE_NUM'			,text: '주민번호'			,type: 'string'}
		]
	});
	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */			
	//1: 근속년수별		
	var masterStore1 = Unilite.createStore('hum520skrMasterStore1',{
		model	: 'hum520skrModel1',
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
					read: 'hum520skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			//1: 근속년수별 flag
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
					UniAppManager.setToolbarButtons(['print'], true);
				}else{
					UniAppManager.setToolbarButtons(['print'], false);
				}

			}
		}
	});
	
	//2: 연령별	
	var masterStore2 = Unilite.createStore('hum520skrMasterStore2',{
		model	: 'hum520skrModel2',
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
					read: 'hum520skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			//1: 근속년수별 flag
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
	
	//3: 학력별	
	var masterStore3 = Unilite.createStore('hum520skrMasterStore3',{
		model	: 'hum520skrModel3',
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
					read: 'hum520skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			//1: 근속년수별 flag
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
	
	//4: 부서별
	var masterStore4 = Unilite.createStore('hum520skrMasterStore4',{
		model	: 'hum520skrModel4',
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
					read: 'hum520skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			//4: 부서별 flag
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
				fieldLabel	: '기준일',	
				name		: 'ST_DATE', 
				xtype		: 'uniDatefield',
				id			: 'stDate',				
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
	//1: 근속년수별
	var masterGrid1 = Unilite.createGrid('hum520skrGrid1', {
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
			{ dataIndex: 'DEPT_CODE'		, width: 110	},
			{ dataIndex: 'DEPT_NAME'		, width: 110	},
			{ dataIndex: 'SORT_GB'			, width: 90		},
			{ dataIndex: 'JOIN_01'			, width: 100	},
			{ dataIndex: 'JOIN_02'			, width: 100	},
			{ dataIndex: 'JOIN_03'			, width: 100	},
			{ dataIndex: 'JOIN_04'			, width: 100	},
			{ dataIndex: 'JOIN_05'			, width: 100	},
			{ dataIndex: 'JOIN_06'			, width: 100	},
			{ dataIndex: 'JOIN_07'			, width: 100	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		},
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('DEPT_CODE') == '99999990'){
					cls = 'x-change-cell_normal';
				}
				else if(record.get('DEPT_CODE') == '99999999') {
					cls = 'x-change-cell_dark';
				}/*
				if(record.get('MOD_DIVI') == 'D'){
					cls = 'x-change-celltext_red';	
				}*/
				return cls;
	        }
	    }
	});	
	
	//2: 근속년수별
	var masterGrid2 = Unilite.createGrid('hum520skrGrid2', {
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
		
		tbar: [{
                itemId : 'GWBtn',
                id:'GW2',
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
			{ dataIndex: 'DEPT_CODE'		, width: 110	},
			{ dataIndex: 'DEPT_NAME'		, width: 110	},
			{ dataIndex: 'SORT_GB'			, width: 90		},
			{ dataIndex: 'PERSON_AGE_20'	, width: 100	},
			{ dataIndex: 'PERSON_AGE_25'	, width: 100	},
			{ dataIndex: 'PERSON_AGE_30'	, width: 100	},
			{ dataIndex: 'PERSON_AGE_35'	, width: 100	},
			{ dataIndex: 'PERSON_AGE_40'	, width: 100	},
			{ dataIndex: 'PERSON_AGE_45'	, width: 100	},
			{ dataIndex: 'PERSON_AGE_50'	, width: 100	},
			{ dataIndex: 'PERSON_AGE_55'	, width: 100	},
			{ dataIndex: 'PERSON_AGE_56'	, width: 100	},
			{ dataIndex: 'PERSON_AGE_TOT'	, width: 100	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		},
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('DEPT_CODE') == '99999990'){
					cls = 'x-change-cell_normal';
				}
				else if(record.get('DEPT_CODE') == '99999999') {
					cls = 'x-change-cell_dark';
				}/*
				if(record.get('MOD_DIVI') == 'D'){
					cls = 'x-change-celltext_red';	
				}*/
				return cls;
	        }
	    }
	});		
	
	//3: 학력별
	var masterGrid3 = Unilite.createGrid('hum520skrGrid3', {
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
		
		tbar: [{
                itemId : 'GWBtn',
                id:'GW3',
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
			{ dataIndex: 'DEPT_CODE'		, width: 110	},
			{ dataIndex: 'DEPT_NAME'		, width: 110	},
			{ dataIndex: 'SORT_GB'			, width: 90		},
			{ dataIndex: 'SCHOOL_01'		, width: 100	},
			{ dataIndex: 'SCHOOL_02'		, width: 100	},
			{ dataIndex: 'SCHOOL_03'		, width: 100	},
			{ dataIndex: 'SCHOOL_04'		, width: 100	},
			{ dataIndex: 'SCHOOL_05'		, width: 100	},
			{ dataIndex: 'SCHOOL_06'		, width: 100	},
			{ dataIndex: 'SCHOOL_07'		, width: 100	},
			{ dataIndex: 'SCHOOL_08'		, width: 100	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		},
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('DEPT_CODE') == '99999990'){
					cls = 'x-change-cell_normal';
				}
				else if(record.get('DEPT_CODE') == '99999999') {
					cls = 'x-change-cell_dark';
				}/*
				if(record.get('MOD_DIVI') == 'D'){
					cls = 'x-change-celltext_red';	
				}*/
				return cls;
	        }
	    }
	});	
	
	//4: 부서별
	var masterGrid4 = Unilite.createGrid('hum520skrGrid4', {
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
		
		tbar: [{
                itemId : 'GWBtn',
                id:'GW4',
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
			{ dataIndex: 'COMP_CODE'			, width: 110	, hidden: true},
			{ dataIndex: 'DEPT_CODE'			, width: 110	},
			{ dataIndex: 'DEPT_NAME'			, width: 110	},
			{ dataIndex: 'POST_CODE'			, width: 110	, hidden: true},
			{ dataIndex: 'POST_NAME'			, width: 110	},
			{ dataIndex: 'PERSON_NUMB'			, width: 110	},
			{ dataIndex: 'PERSON_NAME'			, width: 110	},
			{ dataIndex: 'EMPLOY_TYPE'			, width: 110	, hidden: true},
			{ dataIndex: 'EMPLOY_NAME'			, width: 100	},
			{ dataIndex: 'JOIN_DATE'			, width: 100	},
			{ dataIndex: 'REPRE_NUM'			, width: 130	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		},
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('DEPT_CODE') == '99999990'){
					cls = 'x-change-cell_normal';
				}
				else if(record.get('DEPT_CODE') == '99999999') {
					cls = 'x-change-cell_dark';
				}/*
				if(record.get('MOD_DIVI') == 'D'){
					cls = 'x-change-celltext_red';	
				}*/
				return cls;
	        }
	    }
	});	
	
	
	
	var tab = Unilite.createTabPanel('hum520skrTab',{		
		region		: 'center',
		activeTab	: 0,
		border		: false,
		items		: [{
				title	: '근속년수별',
				xtype	: 'container',
				itemId	: 'hum520skrTab1',
				layout	: {type:'vbox', align:'stretch'},
				items	: [
					masterGrid1
				]
			},{
				title	: '연령별',
				xtype	: 'container',
				itemId	: 'hum520skrTab2',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid2
				]
			},{
				title	: '학력별',
				xtype	: 'container',
				itemId	: 'hum520skrTab3',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid3
				]
			},{
				title	: '부서별',
				xtype	: 'container',
				itemId	: 'hum520skrTab4',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid4
				]
			}
		],
		listeners:{
			tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
				if(newCard.getItemId() == 'hum520skrTab1')	{
					masterStore1.loadStoreRecords();
				}else if(newCard.getItemId() == 'hum520skrTab2') {
                    masterStore2.loadStoreRecords();
                }else if(newCard.getItemId() == 'hum520skrTab3') {
                    masterStore3.loadStoreRecords();
                }else {
					masterStore4.loadStoreRecords();
				}
			}
		}
	})
 
	
	
	
	Unilite.Main({
		id  : 'hum520skrApp',
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
			//1: 근속년수별
			if (activeTab == 'hum520skrTab1'){
				masterStore1.loadStoreRecords();

			//2: 연령병
			} else if (activeTab == 'hum520skrTab2'){
				masterStore2.loadStoreRecords();
				
			//3: 학력별 
			} else if (activeTab == 'hum520skrTab3'){
				masterStore3.loadStoreRecords();
				
			//4: 부서별
			} else{
				masterStore4.loadStoreRecords();
			}
			UniAppManager.setToolbarButtons('reset', true);
		},				
				
		onResetButtonDown: function() {		
			panelResult.clearForm();
			masterGrid1.getStore().loadData({});	
			masterGrid2.getStore().loadData({});
			masterGrid3.getStore().loadData({});	
			masterGrid4.getStore().loadData({});
			this.fnInitBinding();	
		}
	});
};


</script>
