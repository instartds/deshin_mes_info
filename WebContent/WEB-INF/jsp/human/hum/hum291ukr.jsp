<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum291ukr"  >
	<t:ExtComboStore comboType="BOR120"	pgmId="hum291ukr"/> 			<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 				<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H181" /> 				<!-- 사원그룹 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> 				<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> 				<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> 				<!-- 급여지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 				<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" />                 <!-- 직급 -->
	<t:ExtComboStore comboType="AU" comboCode="H089" /> 				<!-- 교육기관 -->
	<t:ExtComboStore comboType="AU" comboCode="H090" /> 				<!-- 교육국가 --> 
	<t:ExtComboStore comboType="AU" comboCode="B012" /> 				<!-- 국가코드 -->
	<t:ExtComboStore comboType="AU" comboCode="H091" /> 				<!-- 교육구분 -->
	<t:ExtComboStore comboType="AU" comboCode="HE81" /> 				<!-- 교육과정 -->
	
	<t:ExtComboStore comboType="AU" comboCode="HE33" /> 				<!-- 학습유형 -->
	<t:ExtComboStore comboType="AU" comboCode="HE34" /> 				<!-- 학습방법 -->
	<t:ExtComboStore comboType="AU" comboCode="HE35" /> 				<!-- 학습분야 -->
	
	<t:ExtComboStore comboType="AU" comboCode="A020" /> <!-- 동의여부 Y/N -->
	<t:ExtComboStore items="${COMBO_HUMAN_COST_POOL}" storeId="getHumanCostPool" />	<!--사업명-->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var excelWindow;	// 엑셀참조

function appMain() {
	
	var gsCostPool = '${CostPool}';  // H175 subCode 10의 Y/N 에 따라 값이 바뀜
	
	// 엑셀참조
	Unilite.Excel.defineModel('excel.hum291ukr.sheet01', {
	    fields: [
	    	{name: '_EXCEL_JOBID'			,text: 'EXCEL_JOBID'	, type: 'string'},
	    	{name: 'COMP_CODE'				,text:'<t:message code="system.label.human.compcode" 	 default="법인코드"/>'			,type:'string'},
	    	{name: 'PERSON_NUMB'			,text:'<t:message code="system.label.human.personnumb" 	 default="사번"/>'			,type:'string'    ,allowBlank: false},
	    	{name: 'NAME'					,text:'<t:message code="system.label.human.name" 		 default="성명"/>'			,type:'string'},
	    	{name: 'POST_CODE'				,text:'직위' 																			,type:'string', comboType:'AU',comboCode:'H005'},
	    	{name: 'DEPT_NAME'				,text:'부서' 																			,type:'string'},
	    	{name: 'PAY_GRADE_01'			,text:'급' 																			,type:'string'},
	    	{name: 'PAY_GRADE_02'			,text:'호' 																			,type:'string'},
	    	
	    	{name: 'MERITS_GUBUN'			,text:'평과구분'																		,type:'string'},
	    	{name: 'MERITS_YEARS'			,text:'평과년도' 																		,type:'string' ,allowBlank: false},
	    	{name: 'MERITS_GRADE'			,text:'평가결과'																		,type: 'float' , decimalPrecision: 3  , format:'0,000.000'},
	    	{name: 'AVG_JOB_GRADE'			,text:'직급평균'																		,type: 'float' , decimalPrecision: 3  , format:'0,000.000'}
	    	
	    	//, type: 'float' , decimalPrecision: 2  , format:'0,000.00'

		]
	});
	
	function openExcelWindow() {
		
			var me = this;
	        var vParam = {};
//	        var appName = 'Unilite.com.excel.ExcelUploadWin';    //예전 엑셀업로드
	        var appName = 'Unilite.com.excel.ExcelUpload';     //신규 엑셀 업로드
            
            if(!excelWindow) {
            	excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
                		modal: false,
                		excelConfigName: 'hum291ukr',
                		extParam: { 
                            'PGM_ID'    : 'hum291ukr'
//                            'DIV_CODE'  : panelResult.getValue('DIV_CODE')
                        },
                        grids: [{
                        		itemId: 'grid01',
                        		title: '평가점수 양식',                        		
                        		useCheckbox: false,
                        		model : 'excel.hum291ukr.sheet01',
                        		readApi: 'hum291ukrService.selectExcelUploadSheet1',
                        		columns: [        		
									{dataIndex: '_EXCEL_JOBID'			, width: 100}, 	
									{dataIndex: 'COMP_CODE'	        	, width: 100}, 	
									{dataIndex: 'PERSON_NUMB'		    , width: 120}, 	
									{dataIndex: 'NAME'		        	, width: 120},
									{dataIndex: 'POST_CODE'		        , width: 120},
									{dataIndex: 'DEPT_NAME'		        , width: 120},
									{dataIndex: 'PAY_GRADE_01'	        , width: 120},
									{dataIndex: 'PAY_GRADE_02'	        , width: 120},
									
									{dataIndex: 'MERITS_GUBUN'	        , width: 120},
									{dataIndex: 'MERITS_YEARS'	        , width: 120},
									{dataIndex: 'MERITS_GRADE'	        , width: 100}, 	
									{dataIndex: 'AVG_JOB_GRADE'	 	    , width: 100}
								
								]
                        }],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
                        },
                        onApply:function()	{
							excelWindow.getEl().mask('<t:message code="system.label.human.loading" default="로딩중..."/>','loading-indicator');		///////// 엑셀업로드 최신로직
                        	var me = this;
                        	var grid = this.down('#grid01');
                			var records = grid.getStore().getAt(0);	
                			if(Ext.isEmpty(records)) {
                                excelWindow.getEl().unmask();
                                return false;
                            }
                			
                			
				        	var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
							hum291ukrService.selectExcelUploadSheet1(param, function(provider, response){
								var store = masterGrid.getStore();
						    	var records = response.result;
						    	
						    	store.insert(0, records);
						    	console.log("response",response)
								excelWindow.getEl().unmask();
								grid.getStore().removeAll();
								me.hide();
						    });
                		}
                 });
            }
            excelWindow.center();
            excelWindow.show();
	}
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read :   'hum291ukrService.selectList',
        	update:  'hum291ukrService.updateDetail',
			create:  'hum291ukrService.insertDetail',
			destroy: 'hum291ukrService.deleteDetail',
			syncAll: 'hum291ukrService.saveAll'
        }
	});
	
	var ReportYNStore = Unilite.createStore('hum291ukrReportYNStore', {  // 그리드 상 Report 제출여부 Y : 1 , N : 2  
	    fields: ['text', 'value'],
		data :  [
			        {'text':'<t:message code="system.label.human.no" default="아니오"/>'	, 'value':'2'},
			        {'text':'<t:message code="system.label.human.yes" default="예"/>'	, 'value':'1'}
	    		]
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum291ukrModel', {
	    fields: [
	    	{name: 'COMP_CODE'		,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type:'string' },
	    	{name: 'PERSON_NUMB'	,text:'<t:message code="system.label.human.personnumb" default="사번"/>'		,type:'string'  , allowBlank: false},
	    	{name: 'NAME'			,text:'<t:message code="system.label.human.name" default="성명"/>'			,type:'string' },
	    	{name: 'POST_CODE'	    ,text:'직위'			,type:'string', comboType:'AU',comboCode:'H005'},
	    	{name: 'DEPT_NAME'		,text:'<t:message code="system.label.human.department" default="부서"/>'		,type:'string' },
	    	{name: 'PAY_GRADE_01'	,text:'급'			,type:'string' },
	    	{name: 'PAY_GRADE_02'	,text:'호'			,type:'string' },
	    	
	    	{name: 'MERITS_YEARS'	,text:'평과년도'		,type:'string', allowBlank: false},
	    	{name: 'MERITS_GUBUN'	,text:'평과구분'		,type:'string'},
	    	{name: 'MERITS_GRADE'	,text:'평가결과'	    ,type: 'float' , decimalPrecision: 3  , format:'0,000.000'},
	    	{name: 'AVG_JOB_GRADE'	,text:'직급평균'		,type: 'float' , decimalPrecision: 3  , format:'0,000.000'}
	    	 
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hum291ukrMasterStore',{
			model: 'hum291ukrModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
            	allDeletable: true,
	            useNavi : false			// prev | newxt 버튼 사용
            },
            proxy: directProxy							
			,loadStoreRecords : function()	{
				var param= panelResult.getValues();			
				console.log( param );
				this.load({ params : param});
			},
			// 수정/추가/삭제된 내용 DB에 적용 하기
			saveStore : function()	{				
    			var inValidRecs = this.getInvalidRecords();
    			console.log("inValidRecords : ", inValidRecs);
    			var toCreate = this.getNewRecords();
	       		var toUpdate = this.getUpdatedRecords(); 
	       		var list = [].concat(toUpdate, toCreate);
				console.log("list:", list);

				var paramMaster= panelResult.getValues();   //syncAll 수정 
    			if(inValidRecs.length == 0 )	{
    				config = {
    					params: [paramMaster],//
						success: function(batch, option) {
							panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);		
							masterGrid.getStore().loadStoreRecords();
						 } 
					};	
    				this.syncAllDirect(config);		
    			}else {
    				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
    			}
            }
	});
	
	var panelResult = Unilite.createSimpleForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        comboType:'BOR120',
				width: 300,
				value:'01',
				
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
			},
			
			{
                fieldLabel: '평가년도',
                name: 'MERITS_YEARS',
                xtype: 'uniYearField',
                value: new Date().getFullYear(),
                allowBlank: false
            },
            
			Unilite.treePopup('DEPTTREE',{
                fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
                valueFieldName:'DEPT',
                textFieldName:'DEPT_NAME' ,
                valuesName:'DEPTS' ,
                selectChildren:true,
                DBvalueFieldName:'TREE_CODE',
                DBtextFieldName:'TREE_NAME',
                textFieldWidth:160,
                validateBlank:true,
                autoPopup:true,
                useLike:true,
                listeners: {
                    
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                    },
                    'onValuesChange':  function( field, records){
                    }
                }
            }),
            Unilite.popup('Employee',{
                fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
                valueFieldName:'PERSON_NUMB',
                textFieldName:'NAME',
                textFieldWidth:130,
                validateBlank:true,
                autoPopup:true,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),
            {
                xtype: 'component',
                colspan: 1,
                height: 7
            }   
			]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum291ukrGrid1', {
    	region: 'center',
        layout: 'fit',
        store: directMasterStore,
        uniOpt: {
//		 	copiedRow: true
            useMultipleSorting  : true,     
            useLiveSearch       : false,    
            onLoadSelectFirst   : false,        
            useGroupSummary     : true, 
            useContextMenu      : false,    
            useRowNumberer      : true, 
            expandLastColumn    : true,     
            useRowContext       : false,    
            filter: {           
                useFilter       : false,    
                autoCreate      : false  
            }           
        		 	
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
        tbar  : [{
            text    : '엑셀 업로드',
            id  : 'excelBtn',
            width   : 130,
            handler : function() {
                if(!panelResult.getInvalidMessage()) return;   //필수체크
                openExcelWindow();
            }
        }],
        

//        selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: false, toggleOnClick: false,
//            listeners: {  
//                beforeselect : function(grid, selectRecord, index, eOpts ){
//                },
//               deselect:  function(grid, selectRecord, index, eOpts ){
//                }
//            }
//        }),
        
        columns:  [  
        		{ dataIndex: 'COMP_CODE'					, width: 100, hidden:true},
        		{ dataIndex: 'PERSON_NUMB'					, width: 120,
        		'editor' : Unilite.popup('Employee_G',{
						textFieldName:'PERSON_NUMB',
						DBtextFieldName: 'PERSON_NUMB', 
						validateBlank : true,
						autoPopup:true,
	   					listeners: {'onSelected': {
		 								fn: function(records, type) {
		 									UniAppManager.app.fnHumanCheck(records);	
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
										var grdRecord = Ext.getCmp('hum291ukrGrid1').uniOpt.currentRecord;
		  								grdRecord.set('PERSON_NUMB','');
		  								grdRecord.set('NAME','');
		  								grdRecord.set('POST_CODE','');
		  								grdRecord.set('DEPT_NAME','');
		  								grdRecord.set('PAY_GRADE_01','');
		  								grdRecord.set('PAY_GRADE_02','');
		  								          
		 							}
		 				}
					})
				},
        		
        		{ dataIndex: 'NAME'							, width: 130, 
        		'editor' : Unilite.popup('Employee_G',{
						validateBlank : true,
						autoPopup:true,
		  				listeners: {'onSelected': {
			 								fn: function(records, type) {
			 									UniAppManager.app.fnHumanCheck(records);	
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('hum291ukrGrid1').uniOpt.currentRecord;
			  								grdRecord.set('PERSON_NUMB','');
			  								grdRecord.set('NAME','');
			  								grdRecord.set('POST_CODE','');
			  								grdRecord.set('DEPT_NAME','');
			  								grdRecord.set('PAY_GRADE_01','');
		  									grdRecord.set('PAY_GRADE_02','');
		
 										}
			 				}
						})
				},
				{ dataIndex: 'POST_CODE'					, width: 120},
				{ dataIndex: 'DEPT_NAME'					, width: 150},
        		{ dataIndex: 'PAY_GRADE_01'					, width: 80},
        		{ dataIndex: 'PAY_GRADE_02'					, width: 80},
				{ dataIndex: 'MERITS_GUBUN'					, width: 100, hidden : true},
        		{ dataIndex: 'MERITS_YEARS'					, width: 80, align:'center', hidden : true},
        		{ dataIndex: 'MERITS_GRADE'					, width: 120, align:'right'},
        		{ dataIndex: 'AVG_JOB_GRADE'				, width: 120, align:'right'}
        		//{ dataIndex: 'COST_POOL_NAME'				, width: 100 , hidden:true}

        		
        		
        	],
        	listeners: {
	    		beforeedit: function( editor, e, eOpts ) {
		        	/*if(e.record.phantom == true) {		// 신규일 때
		        		if(UniUtils.indexOf(e.field, ['OCCUR_DATE'])) {
							return false;
						}
		        	}*/
		        	if(!e.record.phantom == true) { // 신규가 아닐 때
		        		if(UniUtils.indexOf(e.field, ['NAME', 'PERSON_NUMB' ])) {
							return false;
						}
		        	}
		        	if(!e.record.phantom == true || e.record.phantom == true) { 	// 신규이던 아니던 
		        		if(UniUtils.indexOf(e.field, ['DIV_CODE', 'DEPT_NAME', 'POST_CODE', 'ABIL_CODE'])) {
							return false;
						}
		        	}
		        }
		    }
    });   
	
    Unilite.Main({
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            	masterGrid, panelResult
	     	]
	     }
	    ], 
		id  : 'hum291ukrApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			if(!Ext.isEmpty(gsCostPool)){
			 }
						
			//panelResult.setValue('MERITS_YEARS', new Date().getFullYear() -1);
			panelResult.setValue('MERITS_YEARS', new Date().getFullYear());
			
			UniAppManager.setToolbarButtons(['reset', 'newData'],true);
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onNewDataButtonDown: function()	{
			var compCode		 = UserInfo.compCode;
        	
        	var r ={
        		COMP_CODE			: compCode,
        		
        		MERITS_YEARS	: UniDate.getDbDateStr(panelResult.getValue('MERITS_YEARS'))
        		
        		//MERITS_YEARS		: compCode
        	};
            //param = {'SEQ':seq}
	        masterGrid.createRow(r , 'NAME');
		},
		onResetButtonDown:function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});

			this.fnInitBinding();
		},
		onSaveDataButtonDown: function (config) {
			directMasterStore.saveStore(config);
		},
		onDeleteDataButtonDown : function()	{
			masterGrid.deleteSelectedRow();	
		},  
		onDeleteAllButtonDown : function()	{
			if(confirm("전체 삭제 하시겠습니까?"))	{
				directMasterStore.removeAll();
			}
		},
        fnHumanCheck: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			grdRecord.set('PERSON_NUMB', 	record.PERSON_NUMB);
			grdRecord.set('NAME', 			record.NAME);
			grdRecord.set('DEPT_NAME', 		record.DEPT_NAME);
			grdRecord.set('POST_CODE', 		record.POST_CODE);
			grdRecord.set('PAY_GRADE_01', 	record.PAY_GRADE_01);
			grdRecord.set('PAY_GRADE_02', 	record.PAY_GRADE_02);
		}
	});
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			switch(fieldName) {
				
				case "EDU_FR_DATE" : // 교육기간 시작일
					if( 18891231 > UniDate.getDbDateStr(newValue) ){
						rv='<t:message code="system.message.human.message023" default="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다."/>';
						break;
					}
					if ( UniDate.getDbDateStr(newValue) > 30000101){
						rv='<t:message code="system.message.human.message023" default="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다."/>';
						break;
					}
					break;
				
				case "EDU_TO_DATE" : // 교육기간 종료일
					if( 18891231 > UniDate.getDbDateStr(newValue) ){
						rv='<t:message code="system.message.human.message023" default="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다."/>';
						break;
					}
					if ( UniDate.getDbDateStr(newValue) > 30000101){
						rv='<t:message code="system.message.human.message023" default="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다."/>';
						break;
					}
					break;
					
			}
			return rv;
		}
		
	});
};

</script>
