<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum290ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H095" /> <!-- 근무평가 구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var checkNum = '';

function appMain() {
	colData = ${colData};
// 	console.log('colData',colData);

	var fields1 = createModelField1(colData);
	var columns1 = createGridColumn1(colData);
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hum290ukrService.selectList1'
			/*update	: 'hum290ukrService.updateList1',
			create	: 'hum290ukrService.insertList1',
			destroy	: 'hum290ukrService.deleteList1',
			syncAll	: 'hum290ukrService.saveAll1'*/
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hum290ukrService.selectList2'
			/*update	: 'hum290ukrService.updateList2',
			create	: 'hum290ukrService.insertList2',
			destroy	: 'hum290ukrService.deleteList2',
			syncAll	: 'hum290ukrService.saveAll2'*/
		}
	});
	
	var rdoSelect = Unilite.createSearchForm('subForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			xtype: 'radiogroup',					            		
			id: 'rdoSelect',
			items: [{
				boxLabel: '근무성적평정', 
				width: 150, 
				name: 'rdo',
				inputValue: '1',
				checked: true
			},{
				boxLabel : '경력평정', 
				width: 150,
				name: 'rdo',							
				inputValue: '2' 
			},{
				boxLabel : '훈련평정', 
				width: 150,
				name: 'rdo',							
				inputValue: '3' 
			},{
				boxLabel : '포상 및 자격', 
				width: 150,
				name: 'rdo',								
				inputValue: '4' 
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					gubunChange(Ext.getCmp('rdoSelect').getChecked()[0].inputValue);
					var store =  Ext.data.StoreManager.lookup('CBS_AU_H095');
				}
			}
		}]
	});	
	
	Unilite.defineModel('Hum290ukrModel1', {
		fields: fields1
	});
		
	
	Unilite.defineModel('Hum290ukrModel1_2', {
		fields: [
			{name: 'SEQ'				, text: '순번'			, type: 'string'},
			{name: 'DEPT_CODE'			, text: '부서코드'			, type: 'string'},
			{name: 'DEPT_NAME'			, text: '부서'			, type: 'string'},
			{name: 'PAY_GRADE_01'		, text: '급'				, type: 'string'},
			{name: 'PAY_GRADE_02'		, text: '호'				, type: 'string',comboType: 'AU', comboCode:'H005'},
			{name: 'PERSON_NUMB'		, text: '사번'			, type: 'string'},
			{name: 'NAME'				, text: '성명'			, type: 'string'},
			
			//{name: 'MERITS_DATE'		, text: '기준일'			, type: 'string'},
			{name: 'POST_CODE'			, text: '직위코드'			, type: 'string'},
			{name: 'POST_NAME'			, text: '직위'			, type: 'string'},
			/* 경력평정 */
			{name: 'BAS_CAREER'			, text: '기본경력'			, type: 'string'},
			{name: 'EXC_CAREER'			, text: '초과경력'			, type: 'string'},
			{name: 'VALID_MONTHS'		, text: '제외경력'			, type: 'string'},
			{name: 'DEFER_MONTHS'		, text: '제외경력'			, type: 'string'},
			{name: 'CAREER_GRADE'		, text: '점수'			, type: 'string'},			
			/* 경력평정 */
			
			/* 훈련평정 */
			{name: 'EDU_TIME'			, text: '교육시간'			, type: 'string'},
			{name: 'EDU_TIME_LIMIT'		, text: '최저목표시간'		, type: 'string'},
			{name: 'EDU_PERCENT'		, text: '달성율'			, type: 'string'},
			/* 훈련평정 */
			
			/* 포상및자격 */
			{name: 'QUAL_NAME'			, text: '자격명'			, type: 'string'},
			{name: 'PRIZE_PENALTY_NAME'	, text: '포상'			, type: 'string'},
			/* 포상및자격 */
			{name: 'MERITS_GRADE'		, text: '등급'			, type: 'string'},
			{name: 'MERITS_CLASS'		, text: '등급'			, type: 'string'},
			{name: 'GRADE_PERSON_NUMB'	, text: '평정자코드'		, type: 'string'},
			{name: 'GRADE_PERSON_NAME'	, text: '평정자명'			, type: 'string'},
			{name: 'GRADE_PERSON_NUMB2'	, text: '확인자코드'		, type: 'string'},
			{name: 'GRADE_PERSON_NAME2'	, text: '확인자명'			, type: 'string'},
			{name: 'REMARK'				, text: '비고'			, type: 'string'}
		]
	});
	
	Unilite.defineModel('Hum290ukrModel2', {
		fields: [
				{name: 'SEQ'			, text: '순번'			, type: 'string'},
				{name: 'SYNTHETIC_EVAL'	, text: 'RANK_NUM'		, type: 'string'},
				{name: 'DEPT_NAME'		, text: '부서'			, type: 'string'},
				{name: 'PAY_GRADE_01'	, text: '급'				, type: 'string'},
				{name: 'PAY_GRADE_02'	, text: '호'				, type: 'string'},
				{name: 'PERSON_NUMB'	, text: '사번'			, type: 'string'},
				{name: 'NAME'			, text: '성명'			, type: 'string'},
				{name: 'POST_CODE'		, text: '직위'			, type: 'string'},
				/*근무성적평정*/
				{name: 'AVG1'			, text: '최근1년이내평점평균'	, type: 'string'},
				{name: 'AVG2'			, text: '1년전2년이내평점평균', type: 'string'},
				{name: 'AVG3'			, text: '2년전3년이내평점평균', type: 'string'},
				{name: 'AVGTOT'			, text: '소계'			, type: 'string'},
				{name: 'GTOT'			, text: '경력평정'			, type: 'string'},
				/*훈련평정*/
				{name: 'HAVG1'			, text: '최근1년이내평점평균'	, type: 'string'},
				{name: 'HAVG2'			, text: '1년전2년이내평점평균', type: 'string'},
				{name: 'HAVG3'			, text: '2년전3년이내평점평균', type: 'string'},
				{name: 'HTOT'			, text: '소계'			, type: 'string'},	
				
				{name: 'PTOT'			, text: '포상 및 자격'		, type: 'string'},
				{name: 'MERITS_GRADE'	, text: '평정합계'			, type: 'string'},
				{name: 'RANKNAME'		, text: '종합평가'			, type: 'string'},
				
				{name: 'GRADE_PERSON_NUMB'	, text: '평정자코드'	, type: 'string'},
				{name: 'GRADE_PERSON_NAME'	, text: '평정자명'		, type: 'string'},
				{name: 'GRADE_PERSON_NUMB2'	, text: '확인자코드'	, type: 'string'},
				{name: 'GRADE_PERSON_NAME2'	, text: '확인자명'		, type: 'string'},
				
				{name: 'UPDATE_TYPE'	, text: ''				, type: 'string'},
				{name: 'COMP_CODE'		, text: ''				, type: 'string'},
				{name: 'MERITS_GUBUN'	, text: ''				, type: 'string'},
				{name: 'INSERT_DB_USER'	, text: ''				, type: 'string'},
				{name: 'INSERT_DB_TIME'	, text: ''				, type: 'string'},
				{name: 'UPDATE_DB_USER'	, text: ''				, type: 'string'},
				{name: 'UPDATE_DB_TIME'	, text: ''				, type: 'string'}
		]
	});
	
	var directMasterStore1 = Unilite.createStore('hum290ukrMasterStore1', {
		model: 'Hum290ukrModel1',
		uniOpt: {
        	isMaster	: true,			// 상위 버튼 연결 
        	editable	: true,			// 수정 모드 사용 
        	deletable	: true,			// 삭제 가능 여부 
            useNavi		: false			// prev | newxt 버튼 사용
        },
		autoLoad: false,
		proxy: directProxy,
		saveStore : function()	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	if(inValidRecs.length == 0 )	{										
				config = {
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        loadStoreRecords: function()	{	
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		}
	});
	
	var directMasterStore1_2 = Unilite.createStore('hum290ukrMasterStore1_2', {
		model: 'Hum290ukrModel1_2',
		uniOpt: {
        	isMaster	: true,			// 상위 버튼 연결 
        	editable	: true,			// 수정 모드 사용 
        	deletable	: true,			// 삭제 가능 여부 
            useNavi		: false			// prev | newxt 버튼 사용
        },
		autoLoad: false,
		proxy: directProxy,
		saveStore : function()	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	if(inValidRecs.length == 0 )	{										
				config = {
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        loadStoreRecords: function()	{	
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		}
	});
	
	var directMasterStore2 = Unilite.createStore('hum290ukrMasterStore2', {
		model: 'Hum290ukrModel2',
		uniOpt: {
        	isMaster	: true,			// 상위 버튼 연결 
        	editable	: true,			// 수정 모드 사용 
        	deletable	: true,			// 삭제 가능 여부 
            useNavi		: false			// prev | newxt 버튼 사용
        },
		autoLoad: false,
		proxy: directProxy2,
        saveStore : function()	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	if(inValidRecs.length == 0 )	{										
				config = {
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        loadStoreRecords: function()	{
			console.log(tab.getActiveTab().getId());
			//panelSearch.setValue('ACTIVE_TAB','2');
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		}
	});
	
	
	var masterGrid1 = Unilite.createGrid('hum290ukrGrid1', {
    	// for tab 
		layout : 'fit',
    	store: directMasterStore1,    	
    	uniOpt:{	expandLastColumn: false, isMaster: true},
		columns: columns1
	});
	
	var masterGrid1_2 = Unilite.createGrid('hum290ukrGrid1_2', {
    	// for tab 
		layout : 'fit',
    	store: directMasterStore1_2,
    	hidden: true,
    	uniOpt:{	expandLastColumn: false, isMaster: true},
		columns: [
			{dataIndex: 'SEQ'					, width: 66},			//순번
			{dataIndex: 'DEPT_CODE'				, width: 100},			//부서
			{dataIndex: 'DEPT_NAME'				, width: 150},			//부서
			{dataIndex: 'PAY_GRADE_01'			, width: 66},			//급
			{dataIndex: 'PAY_GRADE_02'			, width: 66},			//호
			{dataIndex: 'PERSON_NUMB'			, width: 130},			//사번
			{dataIndex: 'NAME'					, width: 100},			//성명
			{dataIndex: 'POST_CODE'				, width: 80},			//직위코드
			{dataIndex: 'POST_NAME'				, width: 80},			//직위

			{text: '근무평정점수', 
              	columns:[
				{dataIndex: 'BAS_CAREER'		, width: 100},			//기본경력
				{dataIndex: 'EXC_CAREER'		, width: 100},			//초과경력
				{dataIndex: 'VALID_MONTHS'		, width: 100},			//제외경력
				{dataIndex: 'DEFER_MONTHS'		, width: 100, hidden: true},	//제외경력
				{dataIndex: 'CAREER_GRADE'		, width: 100}			//점수
			]},
			{dataIndex: 'EDU_TIME'				, width: 100},
			{dataIndex: 'EDU_TIME_LIMIT'		, width: 100},
			{dataIndex: 'EDU_PERCENT'			, width: 100},
						
			{dataIndex: 'QUAL_NAME'				, width: 100},
			{dataIndex: 'PRIZE_PENALTY_NAME'	, width: 100},
					
			{dataIndex: 'MERITS_GRADE'			, width: 100},
			{dataIndex: 'MERITS_CLASS'			, width: 100, hidden: true},	//등급			
			{dataIndex: 'GRADE_PERSON_NUMB'		, width: 100, hidden: true},	//평정자코드	
			{dataIndex: 'GRADE_PERSON_NAME'		, width: 100},					//평정자명
			{dataIndex: 'GRADE_PERSON_NUMB2'	, width: 100, hidden: true},	//확인자코드
			{dataIndex: 'GRADE_PERSON_NAME2'	, width: 100},					//확인자명		
			{dataIndex: 'REMARK'				, width: 100}					//비고
		]
	});
	
	var masterGrid2 = Unilite.createGrid('hum290ukrGrid2', {
    	region: 'center',
        layout: 'fit',
        uniOpt: {
    		expandLastColumn: false,
		 	copiedRow: true
        },
        features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        store: directMasterStore2,
		columns: [
			{dataIndex: 'SEQ'					, width: 100},	//순번			
			{dataIndex: 'SYNTHETIC_EVAL'		, width: 100, hidden: true},	//RANKNUM
			{dataIndex: 'DEPT_NAME'				, width: 150},	//부서
			{dataIndex: 'PAY_GRADE_01'			, width: 100},	//급
			{dataIndex: 'PAY_GRADE_02'			, width: 100},	//호
			{dataIndex: 'PERSON_NUMB'			, width: 100},	//사번
			{dataIndex: 'NAME'					, width: 100},	//성명
			{dataIndex: 'POST_CODE'				, width: 100},	//직위
			{text: '근무성적평정', 
              	columns:[
					{dataIndex: 'AVG1'					, width: 140},	//최근1년이내평점평균
					{dataIndex: 'AVG2'					, width: 140},	//1년전2년이내평점평균
					{dataIndex: 'AVG3'					, width: 140},	//2년전3년이내평점평균
					{dataIndex: 'AVGTOT'				, width: 100}	//소계
			]},
			{dataIndex: 'GTOT'					, width: 100},	//경력평정
			{text: '훈련평정', 
              	columns:[
					{dataIndex: 'HAVG1'					, width: 140},	//최근1년이내평점평균
					{dataIndex: 'HAVG2'					, width: 140},	//1년전2년이내평점평균
					{dataIndex: 'HAVG3'					, width: 140},	//2년전3년이내평점평균
					{dataIndex: 'HTOT'					, width: 100}	//소계
			]},
			{dataIndex: 'PTOT'					, width: 100},	//포상및자격
			{dataIndex: 'MERITS_GRADE'			, width: 100},	//평정합계
			{dataIndex: 'RANKNAME'				, width: 100},	//종합평가
				
			{dataIndex: 'GRADE_PERSON_NUMB'		, width: 100, hidden: true},	//평정자코드			
			{dataIndex: 'GRADE_PERSON_NAME'		, width: 100},					//평정자명
			{dataIndex: 'GRADE_PERSON_NUMB2'	, width: 100, hidden: true},	//확인자코드
			{dataIndex: 'GRADE_PERSON_NAME2'	, width: 100}					//확인자명
		]
	});
	
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',		
        defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },		
		items: [{	
			title: '기본정보', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
		        fieldLabel: '기준년도',
		        name:'DUTY_YYYY', 
		        xtype: 'uniYearField', 
		        allowBlank:false,
//		        allowBlank:true,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('DUTY_YYYY', newValue);
			    	}
	     		}
		    },{
		        fieldLabel: '구분',
		        name:'MERITS_GUBUN', 
		        xtype: 'uniCombobox', 
		        //store:Ext.data.StoreManager.lookup('subject'),
		        comboType:'AU',
				comboCode:'H095',
		        allowBlank:false,
		        value :1,
//		        allowBlank:true,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('MERITS_GUBUN', newValue);
			    	},
			    	beforequery:function( queryPlan, eOpts )	{
			    		var activeTabId = tab.getActiveTab().getId();
			    				    		
			    		if(activeTabId == 'hum290ukrTab1'){
							checkNum = Ext.getCmp('rdoSelect').getChecked()[0].inputValue;
			    		}
			    		else if(activeTabId == 'hum290ukrTab2'){
			    			checkNum = '9'
			    		}
						/*var store = queryPlan.combo.getStore();
						store.clearFilter();
						store.filterBy(function(record){
							return record.get('refCode10') == checkNum;
						});*/
					}	
	     		}
		    },{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        //multiSelect: true, 
		        typeAhead: false,
		        comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
		        fieldLabel: '급여지급방식',
		        name:'PAY_CODE', 
		        xtype: 'uniCombobox', 
		        comboType:'AU',
		        comboCode:'H028',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('PAY_CODE', newValue);
			    	}
	     		}
		    },
		    /*Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true,
				listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}*/
		    
		    Unilite.popup('DEPT',{ 
                    fieldLabel: '부서', 
                    valueFieldName:'DEPT_CODE_FROM',
                    textFieldName:'DEPT_NAME_FROM',
                    textFieldWidth: 130, 
                    validateBlank: false, 
                    popupWidth: 400,
                    listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    panelResult.setValue('DEPT_CODE_FROM', panelSearch.getValue('DEPT_CODE_FROM'));
                                    panelResult.setValue('DEPT_NAME_FROM', panelSearch.getValue('DEPT_NAME_FROM'));                                                                                                         
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelResult.setValue('DEPT_CODE_FROM', '');
                                panelResult.setValue('DEPT_NAME_FROM', '');
                            },
                            onValueFieldChange: function(field, newValue){
                                panelResult.setValue('DEPT_CODE_FROM', newValue);                              
                            },
                            onTextFieldChange: function(field, newValue){
                                panelResult.setValue('DEPT_NAME_FROM', newValue);             
                            }
                        }
            }),     
                Unilite.popup('DEPT',{ 
                    fieldLabel: '~', 
                    valueFieldName:'DEPT_CODE_TO',
                    textFieldName:'DEPT_NAME_TO',
                    textFieldWidth: 130, 
                    validateBlank: false, 
                    popupWidth: 400,
                    listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    panelResult.setValue('DEPT_CODE_TO', panelSearch.getValue('DEPT_CODE_TO'));
                                    panelResult.setValue('DEPT_NAME_TO', panelSearch.getValue('DEPT_NAME_TO'));                                                                                                         
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelResult.setValue('DEPT_CODE_TO', '');
                                panelResult.setValue('DEPT_NAME_TO', '');
                            },
                            onValueFieldChange: function(field, newValue){
                                panelResult.setValue('DEPT_CODE_TO', newValue);                              
                            },
                            onTextFieldChange: function(field, newValue){
                                panelResult.setValue('DEPT_NAME_TO', newValue);             
                            }
                        }
		    
			}),
			Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
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
				Unilite.popup('PAY_GRADE',{
					fieldLabel: '급호',
				  	valueFieldName:'PAY_GRADE_01',
				    textFieldName:'PAY_GRADE_02',
					validateBlank:false,
					listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PAY_GRADE_01', panelSearch.getValue('PAY_GRADE_01'));
							panelResult.setValue('PAY_GRADE_02', panelSearch.getValue('PAY_GRADE_02'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PAY_GRADE_01', '');
						panelResult.setValue('PAY_GRADE_02', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PAY_GRADE_01', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('PAY_GRADE_02', newValue);				
					}
				}
			}),{
		        fieldLabel: '직위',
		        name:'POST_CODE', 
		        xtype: 'uniCombobox', 
		        comboType:'AU',
		        comboCode:'H005',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('POST_CODE', newValue);
			    	}
	     		}
		    },{
		        fieldLabel: '기준일자',
		        name:'BASE_DATE', 
		        xtype: 'uniDatefield', 
//		        value     : new Date(),
		        value     : UniDate.get('today'),
		        allowBlank:false
			   /* listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			    		
			    	    if(newValue == null){
                            this.setValue(UniDate.get('today'));
                            return false;
                        }
			    		panelResult.setValue('BASE_DATE', newValue);
			    	}
	     		}*/
		    },
		    Unilite.popup('Employee',{
				fieldLabel: '평정자',
			  	valueFieldName:'PERSON_NUMB1',
			    textFieldName:'NAME1',
				validateBlank:false,
				autoPopup:true,
				//allowBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB1', panelSearch.getValue('PERSON_NUMB1'));
							panelResult.setValue('NAME1', panelSearch.getValue('NAME1'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB1', '');
						panelResult.setValue('NAME1', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB1', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME1', newValue);				
					}
				}
			}),
			Unilite.popup('Employee',{
				fieldLabel: '확인자',
			  	valueFieldName:'PERSON_NUMB2',
			    textFieldName:'NAME2',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB2', panelSearch.getValue('PERSON_NUMB2'));
							panelResult.setValue('NAME2', panelSearch.getValue('NAME2'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB2', '');
						panelResult.setValue('NAME2', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB2', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME2', newValue);				
					}
				}
			})]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
	        fieldLabel: '기준년도',
	        name:'DUTY_YYYY', 
	        xtype: 'uniYearField', 
	        allowBlank:false,
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('DUTY_YYYY', newValue);
		    	}
     		}
	    },{
	        fieldLabel: '구분',
	        name:'MERITS_GUBUN', 
	        xtype: 'uniCombobox', 
	        //store:Ext.data.StoreManager.lookup('subject'),
	        comboType:'AU',
			comboCode:'H095',
	        allowBlank:false,
	        value :1,
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('MERITS_GUBUN', newValue);
		    	},
		    	beforequery:function( queryPlan, eOpts )	{
		    		var activeTabId = tab.getActiveTab().getId();
		    				    		
		    		if(activeTabId == 'hum290ukrTab1'){
						checkNum = Ext.getCmp('rdoSelect').getChecked()[0].inputValue;
		    		}
		    		else if(activeTabId == 'hum290ukrTab2'){
		    			checkNum = '9'
		    		}
					/*var store = queryPlan.combo.getStore();
					store.clearFilter();
					store.filterBy(function(record){
						return record.get('refCode10') == checkNum;
					});*/
				}	
     		}
	    },{
			fieldLabel: '사업장',
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
	        //multiSelect: true, 
	        typeAhead: false,
	        comboType:'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
	        fieldLabel: '급여지급방식',
	        name:'PAY_CODE', 
	        xtype: 'uniCombobox', 
	        comboType:'AU',
	        comboCode:'H028',
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('PAY_CODE', newValue);
		    	}
     		}
	    },
	   /* Unilite.treePopup('DEPTTREE',{
			fieldLabel: '부서',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth:89,
			validateBlank:true,
			width:300,
			colspan:2,
			autoPopup:true,
			useLike:true,
			listeners: {
                'onValueFieldChange': function(field, newValue, oldValue  ){
                    	panelSearch.setValue('DEPT',newValue);
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
                    	panelSearch.setValue('DEPT_NAME',newValue);
                },
                'onValuesChange':  function( field, records){
                    	var tagfield = panelSearch.getField('DEPTS') ;
                    	tagfield.setStoreData(records)
                }
			}*/
	    
	    Unilite.popup('DEPT',{ 
                    fieldLabel: '부서', 
                    valueFieldName:'DEPT_CODE_FROM',
                    textFieldName:'DEPT_NAME_FROM',
                    textFieldWidth: 130, 
                    validateBlank: false, 
                    popupWidth: 400,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelSearch.setValue('DEPT_CODE_FROM', panelResult.getValue('DEPT_CODE_FROM'));
                                panelSearch.setValue('DEPT_NAME_FROM', panelResult.getValue('DEPT_NAME_FROM'));                                                                                                         
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('DEPT_CODE_FROM', '');
                            panelSearch.setValue('DEPT_NAME_FROM', '');
                        },
                        onValueFieldChange: function(field, newValue){
                            panelSearch.setValue('DEPT_CODE_FROM', newValue);                              
                        },
                        onTextFieldChange: function(field, newValue){
                            panelSearch.setValue('DEPT_NAME_FROM', newValue);             
                        }
                    }
            }),     
                Unilite.popup('DEPT',{ 
                    fieldLabel: '~', 
                    valueFieldName:'DEPT_CODE_TO',
                    textFieldName:'DEPT_NAME_TO',
                    textFieldWidth: 130, 
                    validateBlank: false, 
                    popupWidth: 400, 
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelSearch.setValue('DEPT_CODE_TO', panelResult.getValue('DEPT_CODE_TO'));
                                panelSearch.setValue('DEPT_NAME_TO', panelResult.getValue('DEPT_NAME_TO'));                                                                                                         
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('DEPT_CODE_TO', '');
                            panelSearch.setValue('DEPT_NAME_TO', '');
                        },
                        onValueFieldChange: function(field, newValue){
                            panelSearch.setValue('DEPT_CODE_TO', newValue);                              
                        },
                        onTextFieldChange: function(field, newValue){
                            panelSearch.setValue('DEPT_NAME_TO', newValue);             
                        }
                    }
	    
		}),
		Unilite.popup('Employee',{
			fieldLabel: '사원',
		  	valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
			validateBlank:false,
			autoPopup:true,
			colspan:2,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		}),
			Unilite.popup('PAY_GRADE',{
				fieldLabel: '급호',
			  	valueFieldName:'PAY_GRADE_01',
			    textFieldName:'PAY_GRADE_02',
				validateBlank:false,
				textFieldWidth: 130, 
				colspan:2,
				listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PAY_GRADE_01', panelResult.getValue('PAY_GRADE_01'));
						panelSearch.setValue('PAY_GRADE_02', panelResult.getValue('PAY_GRADE_02'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PAY_GRADE_01', '');
					panelSearch.setValue('PAY_GRADE_02', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PAY_GRADE_01', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('PAY_GRADE_02', newValue);				
				}
			}
		}),{
	        fieldLabel: '직위',
	        name:'POST_CODE', 
	        xtype: 'uniCombobox', 
	        comboType:'AU',
	        comboCode:'H005',
	        colspan:2,
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('POST_CODE', newValue);
		    	}
     		}
	    },{
	        fieldLabel: '기준일자',
	        name:'BASE_DATE', 
	        xtype: 'uniDatefield', 
//	        value      : new Date(),
	        value     : UniDate.get('today'),
	        allowBlank:false
		    /*listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {
		    		if(newValue == null){
		    		    this.setValue(UniDate.get('today'));
		    		    return false;
		    		}
		    		panelSearch.setValue('BASE_DATE', newValue);
		    	}
     		}*/
	    },
	    Unilite.popup('Employee',{
			fieldLabel: '평정자',
		  	valueFieldName:'PERSON_NUMB1',
		    textFieldName:'NAME1',
			validateBlank:false,
			autoPopup:true,
			textFieldWidth: 130, 
			//allowBlank:false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB1', panelResult.getValue('PERSON_NUMB1'));
						panelSearch.setValue('NAME1', panelResult.getValue('NAME1'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PERSON_NUMB1', '');
					panelSearch.setValue('NAME1', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB1', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME1', newValue);				
				}
			}
		}),
		Unilite.popup('Employee',{
			fieldLabel: '확인자',
		  	valueFieldName:'PERSON_NUMB2',
		    textFieldName:'NAME2',
			validateBlank:false,
			autoPopup:true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB2', panelResult.getValue('PERSON_NUMB2'));
						panelSearch.setValue('NAME2', panelResult.getValue('NAME2'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PERSON_NUMB2', '');
					panelSearch.setValue('NAME2', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB2', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME2', newValue);				
				}
			}
		})]
	});
	
	var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab: 0,
	    region: 'center',
	    border: false,
	    items: 
	    	[
		    	{
			    	layout:{type: 'vbox', align: 'stretch', pack  : 'start'},
			    	title: '개별평정',
			    	xtype: 'container',
			    	id: 'hum290ukrTab1',
			    	items:[rdoSelect, masterGrid1, masterGrid1_2]
		    	}
			    ,{	
					layout:{type: 'hbox', align: 'stretch', pack  : 'start'},
					title: '종합평정',
					xtype: 'container',
					id: 'hum290ukrTab2',
			    	items:[ masterGrid2 ]
				}
			],
			listeners: {
				tabchange: function(){
					var activeTabId = tab.getActiveTab().getId();
// 	 				panelSearch.removeAll();					
// 					Ext.getCmp('menu2').removeAll();
					
// 	 				panelSearch.add(baseMenu);
	 				
	 				/*if(activeTabId == 'hum290ukrTab1'){
// 	 					panelSearch.add(menu1);
						//Ext.getCmp('menu2').setVisible(false);
	 					Ext.getCmp('DIV_CODE').setReadOnly(false);
	 					Ext.getCmp('PAY_CODE').setReadOnly(false);
	 					Ext.getCmp('DEPT_CODE1').setReadOnly(false);
	 					Ext.getCmp('DEPT_CODE2').setReadOnly(false);
	 					Ext.getCmp('PERSON_NUMB').setReadOnly(false);
	 					Ext.getCmp('PAY_GRADE_02').setReadOnly(false);
	 				 }else if(activeTabId == 'hum290ukrTab2'){ 					
// 	 					panelSearch.add(menu2);
						//Ext.getCmp('menu2').setVisible(true);
	 					Ext.getCmp('DIV_CODE').setReadOnly(true);
	 					Ext.getCmp('PAY_CODE').setReadOnly(true);
	 					Ext.getCmp('DEPT_CODE1').setReadOnly(true);
	 					Ext.getCmp('DEPT_CODE2').setReadOnly(true);
	 					Ext.getCmp('PERSON_NUMB').setReadOnly(true);
	 					Ext.getCmp('PAY_GRADE_02').setReadOnly(true);
	 				 }
	 				panelSearch.doLayout();*/
				}
			}
		
     });
	
	function gubunChange(gubun){
		if(gubun=='1'){	//근무성적평정
			Ext.getCmp('hum290ukrGrid1').setVisible(true);
			Ext.getCmp('hum290ukrGrid1_2').setVisible(false);			
		}else if(gubun=='2'){	//경력평정
			Ext.getCmp('hum290ukrGrid1_2').setVisible(true);
			Ext.getCmp('hum290ukrGrid1').setVisible(false);			
			//masterGrid1_2.getColumn('SEQ').setVisible(true);
			
			for(var i=10;i<21;i++){
				masterGrid1_2.columns[i].setVisible(false);
			}
			masterGrid1_2.columns[10].setVisible(true);
			masterGrid1_2.columns[11].setVisible(true);			
			masterGrid1_2.columns[12].setVisible(true);
			masterGrid1_2.columns[13].setVisible(true);
		}else if(gubun=='3'){	//훈련평정
			
			Ext.getCmp('hum290ukrGrid1_2').setVisible(true);
			Ext.getCmp('hum290ukrGrid1').setVisible(false);
			for(var i=10;i<21;i++){
				masterGrid1_2.columns[i].setVisible(false);
			}						
			masterGrid1_2.columns[15].setVisible(true);
			masterGrid1_2.columns[16].setVisible(true);
			masterGrid1_2.columns[17].setVisible(true);	
		}else if(gubun=='4'){	//포상 및 자격
			
			Ext.getCmp('hum290ukrGrid1_2').setVisible(true);
			Ext.getCmp('hum290ukrGrid1').setVisible(false);
			for(var i=10;i<21;i++){
				masterGrid1_2.columns[i].setVisible(false);
			}
			masterGrid1_2.columns[18].setVisible(true);
			masterGrid1_2.columns[19].setVisible(true);			
		}
	}	

	Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]	
		},
		panelSearch
		], 
		id: 'hum290ukrApp',
		fnInitBinding: function() {
			//panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DUTY_YYYY', new Date().getFullYear());
			panelResult.setValue('DUTY_YYYY', new Date().getFullYear());
			
//			panelSearch.setValue('BASE_DATE', UniDate.getDateStr(new Date()));
//            panelResult.setValue('BASE_DATE', UniDate.getDateStr(new Date()));
			
			UniAppManager.setToolbarButtons('reset', false);
// 			UniAppManager.setToolbarButtons('save', true);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DUTY_YYYY');
		},
		onQueryButtonDown: function() {
//			if(!this.isValidSearchForm()){
//				return false;
//			}
			if(!panelSearch.getInvalidMessage()){
                return false;
            }
			
			var activeTabId = tab.getActiveTab().getItemId();
			if(activeTabId == 'hum290ukrTab1'){				
				masterGrid1.getStore().loadStoreRecords();			
			}
			if(activeTabId == 'hum290ukrTab2'){				
				masterGrid2.getStore().loadStoreRecords();		
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid1.reset();
			masterGrid2.reset();
			directMasterStore1.clearData();
			directMasterStore2.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'hpa960ukrGrid1'){				
				masterStore.saveStore();
				
			} else if(activeTabId == 'hpa960ukrGrid2'){	
				masterStore2.saveStore();
			}
			UniAppManager.setToolbarButtons('save', false);
		},
		
		onDeleteDataButtonDown : function()	{
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'hpa960ukrGrid1'){				
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid1.deleteSelectedRow();
				}
			} else if(activeTabId == 'hpa960ukrGrid2'){
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid2.deleteSelectedRow();
				}
			}
		}
		
		
	});//End of Unilite.Main( {
		
	// 모델 필드 생성 grid1
	function createModelField1(colData) {
		var fields = [
						{name: 'SEQ'				, text: '순번'			, type: 'string'},
						{name: 'DEPT_CODE'			, text: '부서코드'			, type: 'string'},
						{name: 'DEPT_NAME'			, text: '부서'			, type: 'string'},
						{name: 'PAY_GRADE_01'		, text: '급'				, type: 'string'},
						{name: 'PAY_GRADE_02'		, text: '호'				, type: 'string',comboType: 'AU', comboCode:'H005'},
						{name: 'PERSON_NUMB'		, text: '사번'			, type: 'string'},
						{name: 'NAME'				, text: '성명'			, type: 'string'},
						{name: 'MERITS_DATE'		, text: '기준일'			, type: 'uniDate'},
						{name: 'POST_CODE'			, text: '직위코드'			, type: 'string'},
						{name: 'POST_NAME'			, text: '직위'			, type: 'string'},
												
						{name: 'BAS_CAREER'			, text: '기본경력'			, type: 'string'},
						{name: 'EXC_CAREER'			, text: '초과경력'			, type: 'string'},
						{name: 'VALID_MONTHS'		, text: '제외경력'			, type: 'string'},
						{name: 'DEFER_MONTHS'		, text: '제외경력'			, type: 'string'},
						{name: 'CAREER_GRADE'		, text: '점수'			, type: 'string'},
						
						{name: 'WORK_GRADE'			, text: '합계'			, type: 'string'},			
						{name: 'MERITS_CLASS'		, text: '등급'			, type: 'string'},
						{name: 'GRADE_PERSON_NUMB'	, text: '평정자코드'		, type: 'string'},
						{name: 'GRADE_PERSON_NAME'	, text: '평정자명'			, type: 'string'},
						{name: 'GRADE_PERSON_NUMB2'	, text: '확인자코드'		, type: 'string'},
						{name: 'GRADE_PERSON_NAME2'	, text: '확인자명'			, type: 'string'},
						{name: 'REMARK'				, text: '비고'			, type: 'string'}
					];
							
		Ext.each(colData, function(item, index){
			var realGrade = 'REAL_GRADE'+(item.SUB_CODE);
			var convGrade = 'CONV_GRADE'+(item.SUB_CODE);
			
			fields.push({name: realGrade, text: '점수', type:'string' });
			fields.push({name: convGrade, text: item.REF_CODE1+'%', type:'string' });
		});
		console.log('fields',fields);
		return fields;
	}
	
	// 그리드 컬럼 생성 grid1
	function createGridColumn1(colData) {
		var columns = [
		   			{dataIndex: 'SEQ'					, width: 100},		//순번
		   			{dataIndex: 'DEPT_CODE'				, width: 100},		//부서
					{dataIndex: 'DEPT_NAME'				, width: 150},		//부서
					{dataIndex: 'PAY_GRADE_01'			, width: 100},		//급
					{dataIndex: 'PAY_GRADE_02'			, width: 100},		//호
					{dataIndex: 'PERSON_NUMB'			, width: 130},		//사번
					{dataIndex: 'NAME'					, width: 100},		//성명		
					{dataIndex: 'MERITS_DATE'			, width: 100},		//기준일
					{dataIndex: 'POST_CODE'				, width: 100},		//직위코드	
					{dataIndex: 'POST_NAME'				, width: 100}		//직위	
				];
			var Title = '근무평정점수';
			var array 	 = new Array();
			var columnsArray  = new Array();
			var midTitle = new Array();
			
			
			
			Ext.each(colData, function(item, i){
				
				var realGrade = 'REAL_GRADE'+(item.SUB_CODE);
				var convGrade = 'CONV_GRADE'+(item.SUB_CODE);
				midTitle[i]  = item.CODE_NAME;
				
				columnsArray[i] = {text:midTitle[i], columns: [{dataIndex: realGrade, width: 66, style: 'text-align: center', align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price},
														 	   {dataIndex: convGrade, width: 66, style: 'text-align: center', align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price}
														 	  ]
								  }
			});
			
			array[0] = {dataIndex: 'WORK_GRADE'			, width: 100}
			
			var test = [].concat(columnsArray, array)
			
			columns.push(
				{text:Title,
					columns: test
				}
			);
		//columns.push({dataIndex: 'WORK_GRADE'			, width: 100});		//합계
		columns.push({dataIndex: 'MERITS_CLASS'			, width: 100});		//등급
		columns.push({dataIndex: 'GRADE_PERSON_NUMB'	, width: 100 , hidden : true});		//평정자코드
		columns.push({dataIndex: 'GRADE_PERSON_NAME'	, width: 100});		//평정자명
		columns.push({dataIndex: 'GRADE_PERSON_NUMB2'	, width: 100 , hidden : true});		//확인자코드
		columns.push({dataIndex: 'GRADE_PERSON_NAME2'	, width: 100});		//확인자명
		columns.push({dataIndex: 'REMARK'				, width: 100});		//확인자명

// 		console.log(columns);
		return columns;
	}
};


</script>