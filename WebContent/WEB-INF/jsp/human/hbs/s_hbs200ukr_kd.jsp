<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hbs200ukr_kd"  >
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 --> 
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="H181" /> <!-- 사원그룹 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var excelWindow;	// 엑셀참조

function appMain() {

	// ---- 급호봉등록 사용 변수 시작 ----
	var colDataTab11 = ${colDataTab11};
	console.log(colDataTab11);
	
	var fieldsTab11 = createModelField(colDataTab11, 's_hbs200ukr_kdTab11');
	var columnsTab11 = createGridColumn(colDataTab11, 's_hbs200ukr_kdTab11');
	// ---- 급호봉등록 사용 변수 끝 ----	

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('S_hbs200ukr_kdModel', {
		fields: fieldsTab11
									
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 's_hbs200ukr_kdService.insertList',				
			read: 's_hbs200ukr_kdService.selectList',
			update: 's_hbs200ukr_kdService.updateList',
			destroy: 's_hbs200ukr_kdService.deleteList',
			syncAll: 's_hbs200ukr_kdService.saveAll'
		}
	});	
    
	var directMasterStore = Unilite.createStore('s_hbs200ukr_kdMasterStore', {
		model: 'S_hbs200ukr_kdModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
		},   		
        saveStore : function(config)	{               
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            console.log("list:", list);

            console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
            
            //1. 마스터 정보 파라미터 구성
            var paramMaster= panelSearch.getValues();   //syncAll 수정
            
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        
                        panelSearch.getForm().wasDirty = false;
                        panelSearch.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);     
                     } 
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('s_hbs200ukr_kdGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
		listeners: {
			load: function() {
				if (this.getCount() > 0) {
//	              	UniAppManager.setToolbarButtons('delete', true);
	                } else {
//	              	  	UniAppManager.setToolbarButtons('delete', false);
	                }  
			}
		}
	});	

	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',		
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
				fieldLabel: '급호',
				xtype: 'uniTextfield',
				name: 'PAY_GRADE_01',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_GRADE_01', newValue);
					}
				}				
			},{
				fieldLabel: '호봉',
				xtype: 'uniTextfield',
				name: 'PAY_GRADE_02',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_GRADE_02', newValue);
					}
				}				
			}]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '급호',
			xtype: 'uniTextfield',
			name: 'PAY_GRADE_01',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_GRADE_01', newValue);
				}
			}			
		},{
			fieldLabel: '호봉',
			xtype: 'uniTextfield',
			name: 'PAY_GRADE_02',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_GRADE_02', newValue);
				}
			}				
		}]
    });
    

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_hbs200ukr_kdGrid', {
        layout: 'fit',    
        region : 'center',   
    	store: directMasterStore,
        uniOpt:{
        	expandLastColumn: false,
        	useRowNumberer: true,
            useMultipleSorting: true
    	},
    	tbar: [{
        	xtype:'button',
        	text:'엑셀참조',
        	handler:function()	{
        		openExcelWindow();
        		}
		}],
//    	features: [{
//    		id: 'masterGridSubTotal',
//    		ftype: 'uniGroupingsummary', 
//    		showSummaryRow: false 
//    	},{
//    		id: 'masterGridTotal', 	
//    		ftype: 'uniSummary', 	  
//    		showSummaryRow: false
//    	}],	
		listeners: {
			beforeedit: function(editor, e) {
				if (!e.record.phantom) {
					if (UniUtils.indexOf(e.field, ['PAY_GRADE_01','PAY_GRADE_02'])){
						return false;
					}
					
				}
			}, 
			edit: function(editor, e) {
					var fieldName = e.field;
					if((fieldName == 'PAY_GRADE_01' || fieldName == 'PAY_GRADE_02') && isNaN(e.value)){
						Ext.Msg.alert('확인', '숫자형식이 잘못되었습니다.');
						e.record.set(fieldName, e.originalValue);
						return false;
					}
				}
		},
    	columns:  [         				
				{dataIndex: 'PAY_GRADE_01',		width: 80},				  
				{dataIndex: 'PAY_GRADE_02',		width: 80},				  
				{dataIndex: 'FLAG100',			width: 80, 	hidden: true},				  
				{dataIndex: 'CODE100',			width: 100, hidden: true},				  
				{dataIndex: 'STD100',			width: 100},
				{dataIndex: 'WAGES_CODE',		width: 100, hidden: true},
				{dataIndex: 'WAGES_I',			width: 100, hidden: true}     				     		
          ]

    }); //End of var masterGrid = Unilite.createGrid('s_hbs200ukr_kdGrid1', {   

	Unilite.Main( {
		 borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id: 's_hbs200ukr_kdApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			//panelSearch.setValue('DUTY_YYYYMMDD', UniDate.get('today'));
			//panelResult.setValue('DUTY_YYYYMMDD', UniDate.get('today'));
			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('newData', true);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			//activeSForm.onLoadSelectText('DUTY_YYYYMMDD');
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}

			masterGrid.getStore().loadStoreRecords();

		},
		onNewDataButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			panelSearch.getForm().getFields().each(function(field) {
			      field.setReadOnly(true);
			});
			panelResult.getForm().getFields().each(function(field) {
			      field.setReadOnly(true);
			});
			var record = {
					USER_ID: UserInfo.userID

			};
			masterGrid.createRow(record);
//			UniAppManager.setToolbarButtons('delete', true);
//			UniAppManager.setToolbarButtons('save', true);
		},			
		onSaveDataButtonDown : function() {
			if (masterGrid.getStore().isDirty()) {
				// 입력데이터 validation
				if (!checkValidaionGrid(masterGrid.getStore())) {
					return false;
				}	
				directMasterStore.saveStore();
//				masterGrid.getStore().saveStore();
//				masterGrid.getStore().sync({						
//					success: function(response) {
//						UniAppManager.setToolbarButtons('save', false); 
//		            },
//		            failure: function(response) {
//		            	UniAppManager.setToolbarButtons('save', true); 
//		            }
//				});
			}
			
		},
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectionModel().getSelection()[0];
			if (selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			} else {
				Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
					if (btn == 'yes') {
						masterGrid.deleteSelectedRow();		
						UniAppManager.setToolbarButtons('save', true);
					}
				});
			}
		},
		onDeleteAllButtonDown : function() {
			Ext.Msg.confirm('삭제', '전체 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
				if (btn == 'yes') {
					masterGrid.reset();			
					UniAppManager.app.onSaveDataButtonDown();
//					Ext.getCmp('hat420ukrGrid1').getStore().removeAll();
//					Ext.getCmp('hat420ukrGrid1').getStore().sync({
//						success: function(response) {
//							Ext.Msg.alert('확인', '삭제 되었습니다.');
//							UniAppManager.setToolbarButtons('delete', false);
//							UniAppManager.setToolbarButtons('deleteAll', false);
//							UniAppManager.setToolbarButtons('excel', false);
//				           },
//				           failure: function(response) {
//				           }
//			           });
					
				}
			});
		}
	});//End of Unilite.Main( {
		
	// 엑셀참조
	Unilite.Excel.defineModel('excel.s_hbs200_kd.sheet01', {
		fields: [
			{name: 'PAY_GRADE_01'		, text: '급호'			, type: 'string'},
			{name: 'PAY_GRADE_02'    		, text: '호봉'				, type: 'string'},
    		
    			{name: 'FLAG100'			,text:'기본급'		,type : 'string'},
    		{name: 'CODE100'			,text:'기본급'		,type : 'string'},
    		{name: 'STD100'				,text:'기본급'		,type : 'string'},
			{name: 'WAGES_CODE'    		, text: '근무조명'			, type: 'string'},			
			{name: 'WAGES_I'    		, text: '부서코드'			, type: 'string'},
//			{name: 'POST_CODE'    		, text: '직위코드'			, type: 'string'},
//			{name: 'POST_NAME'    		, text: '직위명'			, type: 'string'},			
//			{name: 'DEPT_NAME'    		, text: '부서명'			, type: 'string'},
			
			{name: 'DIV_CODE'     		, text: '사업장'			, type: 'string', comboType:'BOR120', hidden: true}
		]
	});	
	
	function openExcelWindow() {
		
			var me = this;
	        var vParam = {};
	        var appName = 'Unilite.com.excel.ExcelUploadWin';

            
            if(!excelWindow) {
            	excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
                		modal: false,
                		excelConfigName: 's_hbs200_kd',
                		/*extParam: { 
                			'DIV_CODE': masterForm.getValue('DIV_CODE'),
                			'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE')
                		},*/
                        grids: [{
                        		itemId: 'grid01',
                        		title: '급호봉등록',                        		
                        		useCheckbox: false,
                        		model : 'excel.s_hbs200_kd.sheet01',
                        		readApi: 's_hbs200ukr_kdService.selectExcelUploadSheet1',
                        		columns: [{dataIndex: 'PAY_GRADE_01' 		 		 	, 		width: 80},
                        				  {dataIndex: 'PAY_GRADE_02'         	  	, width: 66},
                        				  {dataIndex: 'STD100'         	  	, width: 96},

										  {dataIndex: 'UPDATE_DB_USER' 		 		,		width: 66, hidden: true },
										  {dataIndex: 'UPDATE_DB_TIME' 		 		,		width: 66, hidden: true }
							  		  
								]
                        }],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
                        },
                        onApply:function()	{
							/*excelWindow.getEl().mask('로딩중...','loading-indicator');
                        	var grid = this.down('#grid01');
                			var records = grid.getSelectionModel().getSelection();       		
							Ext.each(records, function(record,i){	
						        	UniAppManager.app.onNewDataButtonDown();
						        	masterGrid.setExcelData(record.data);
						        	//masterGrid.fnCulcSet(record.data);
						    }); 
							grid.getStore().remove(records);*/
							excelWindow.getEl().mask('로딩중...','loading-indicator');		///////// 엑셀업로드 최신로직
                        	var me = this;
                        	var grid = this.down('#grid01');
                			var records = grid.getStore().getAt(0);	
				        	var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
						 	s_hbs200ukr_kdService.selectExcelUploadSheet1(param, function(provider, response){
						    	var store = masterGrid.getStore();
						    	var records = response.result;
//						    	var countDate = UniDate.getDbDateStr(masterForm.getValue('DUTY_FR_DHM')).substring(0, 6);
//								var monthDate = countDate.substring(0,4) + '.' + countDate.substring(4,6);              
//								for(var i=0; i<records.length; i++) { 
//									records[i].DUTY_FR_H = monthDate;                                                
//								} 
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
	
	// insert, update 전 입력값  검증(시작/종료 시간)
	 function checkValidaionGrid() {
		 // 시작시간/종료시간 검증
		 var rightTimeInputed = true;
		 // 필수 입력항목 입력 여부 검증
		 var necessaryFieldInputed = true;
		 var MsgTitle = '확인';
		 var MsgErr01 = '시작시간이 종료 시간 보다 클 수 없습니다.';
		 var MsgErr02 = '은(는) 필수 입력 항목 입니다.';

		 var selectedModel = masterGrid.getStore().getRange();
		 Ext.each(selectedModel, function(record,i){
			 
//		 	var date_fr = parseInt(dateChange(record.data.DUTY_FR_D));
//		 	var date_to = parseInt(dateChange(record.data.DUTY_TO_D));
		 	var date_fr = parseInt(record.data.DUTY_FR_D);
		 	var date_to = parseInt(record.data.DUTY_TO_D);		 	
		 	var fr_time = parseInt(record.data.DUTY_FR_H + record.data.DUTY_FR_M);
			var to_time = parseInt(record.data.DUTY_TO_H + record.data.DUTY_TO_M);
		 
			 if ( (date_fr != '' && date_to == '') || (date_fr == '' && date_to != '') ) {
				 rightTimeInputed = false;
				 return;
			 } else if (date_fr != '' && date_to != '') {
				 if ((date_fr > date_to)) {
					 rightTimeInputed = false;
					 return;
				 } else {
					if (date_fr == date_to && fr_time >= to_time) {
						rightTimeInputed = false;
						return;
					}
				 }
			 }		 
		 });
		 if (!rightTimeInputed) {
			 Ext.Msg.alert(MsgTitle, MsgErr01);
			 return rightTimeInputed;
		 }
		 if (!necessaryFieldInputed) {
			 Ext.Msg.alert(MsgTitle, MsgErr02);
			 return necessaryFieldInputed;
		 }
		 return true;
	 }

	 // insert 될 data를 초기화함(급호봉등록)
	 function initData(record) {
		 var data = new Object();
		 data['S_COMP_CODE'] = "${loginVO.compCode}";
		 data['PAY_GRADE_01'] = record.data.PAY_GRADE_01;
		 data['PAY_GRADE_02'] = record.data.PAY_GRADE_02;
		 data['S_USER_ID'] = "${loginVO.userID}";
		 return data;
	 }
	 
	//급호봉 등록 모델 필드 생성
	 function createModelField(colData, tabId) {
	 	var fields;
	 	if (tabID = 's_hbs200ukr_kdTab11') {
	 		fields = [
	 					{name: 'PAY_GRADE_01'			,text:'급'			,type : 'string', allowBlank: false},
	 		    		{name: 'PAY_GRADE_02'			,text:'호'			,type : 'string', allowBlank: false},
	 		    		{name: 'FLAG100'				,text:'기본급'		,type : 'uniPrice'},
	 		    		{name: 'CODE100'				,text:'기본급'		,type : 'uniPrice'},
	 		    		{name: 'STD100'					,text:'기본급'		,type : 'uniPrice'}
	 				];
	 		Ext.each(colData, function(item, index){
	 			fields.push({name: 'FLAG' + item.WAGES_CODE, text: item.WAGES_NAME, type:'uniPrice' });
	 			fields.push({name: 'CODE' + item.WAGES_CODE, text: item.WAGES_NAME, type:'uniPrice' });
	 			fields.push({name: 'STD' + item.WAGES_CODE,  text: item.WAGES_NAME, type:'uniPrice' });
	 		});
	 		console.log(fields);	
	 	}		
	 	return fields;
	 }

	 //급호봉 등록  그리드 컬럼 생성
	 function createGridColumn(colData, tabId) {
	 	var columns;
	 	if (tabID = 's_hbs200ukr_kdTab11') {
	 		columns = [
	 						{dataIndex: 'PAY_GRADE_01',		width: 80},				  
	 						{dataIndex: 'PAY_GRADE_02',		width: 80},				  
	 						{dataIndex: 'FLAG100',			width: 80, 	hidden: true},				  
	 						{dataIndex: 'CODE100',			width: 100, hidden: true},				  
	 						{dataIndex: 'STD100',			width: 100},
	 						{dataIndex: 'WAGES_CODE',		width: 100, hidden: true},
	 						{dataIndex: 'WAGES_I',			width: 100, hidden: true}
	 				  ];	
	 	}
	 	Ext.each(colData, function(item, index){
	 		columns.push({dataIndex: 'FLAG' + item.WAGES_CODE, width: 80, 	hidden: true});
	 		columns.push({dataIndex: 'CODE' + item.WAGES_CODE, width: 100, 	hidden: true});
	 		columns.push({dataIndex: 'STD' + item.WAGES_CODE, width: 100});
	 	});
	 	console.log(columns);
	 	return columns;
	 } 	 
};


</script>
