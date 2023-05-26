<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa950ukr"  >
		<t:ExtComboStore comboType="AU" comboCode="B027" />								<!-- 제조/판관 -->
		<t:ExtComboStore comboType="AU" comboCode="H005" />								<!-- 직위 -->
		<t:ExtComboStore comboType="AU" comboCode="H011" />								<!-- 고용형태 -->
		<t:ExtComboStore comboType="AU" comboCode="H024" opts= '1;2;3;4'/>								<!-- 사원구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H028" />								<!-- 급여지급방식 -->
		//<t:ExtComboStore comboType="AU" comboCode="H031" opts= '${gsList1}' /> 			<!-- 지급차수 -->
		<t:ExtComboStore comboType="AU" comboCode="H031" /> 			<!-- 지급차수 -->
		<t:ExtComboStore comboType="AU" comboCode="H032" opts= '${gsList1}' />								<!-- 지급구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H173" />								<!-- 직렬 -->
		<t:ExtComboStore comboType="AU" comboCode="H181" />								<!-- 사원그룹 -->
		<t:ExtComboStore comboType="BOR120"  />											<!-- 사업장 --> 
		<t:ExtComboStore comboType="BOR120"  comboCode="BILL" />						<!-- 신고사업장 -->
		<t:ExtComboStore items="${COMBO_HUMAN_COST_POOL}" storeId="getHumanCostPool" />	<!--차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	var gsList1 = '${gsList1}';					//지급구분 '1'인 것만 콤보에서 보이도록 설정
	
	var excelWindow1; 
	var excelWindow2; 
	
	//지급차수
	//var gsList1 = '${gsList1}';
	
	//수당
	var colData1 = ${colData1};
	
	//공제
	var colData2 = ${colData2};

	var fields1 = createModelField(colData1);
	var columns1 = createGridColumn(colData1);
	
	var fields2 = createModelField(colData2);
	var columns2 = createGridColumn(colData2);
	
	var fields3 = createModelExcelField(colData1);
	var columns3 = createGridExcelColumn(colData1);
	
	var fields4 = createModelExcelField(colData2);
	var columns4 = createGridExcelColumn(colData2);
	
	var	getCostPoolName = Ext.isEmpty(${getCostPoolName}) ? []: ${getCostPoolName} ;

    
    // 엑셀업로드 모델 필드 생성(수당업로드)
	function createModelExcelField(colData) {
		var fields = [
      		{name: '_EXCEL_JOBID'     , text: 'EXCEL_JOBID' , type: 'string'},
      		{name: 'COMP_CODE'        , text: '법인코드'   	, type: 'string'},      		
      		{name: 'DIV_CODE'         , text: '사업장'   		, type: 'string', comboType:'BOR120'},
      		{name: 'DEPT_CODE'        , text: '부서코드'   	, type: 'string'},
      		{name: 'DEPT_NAME'        , text: '부서명'   		, type: 'string'},
      		{name: 'POST_CODE'        , text: '직위'   		, type: 'string', comboType:'AU', comboCode:'H005'},
      		{name: 'NAME'       	  , text: '사명'   		, type: 'string'},
      		{name: 'PERSON_NUMB'      , text: '사번'   		, type: 'string'},
      		{name: 'JOIN_DATE'        , text: '입사일'   		, type: 'uniDate'},
      		{name: 'PAY_YYYYMM'       , text: '지급년월'   	, type: 'uniDate'},
      		{name: 'SUPP_DATE'        , text: '지급일'   		, type: 'uniDate'},
      		{name: 'SUPP_TYPE'        , text: '지급구분'   	, type: 'string', comboType:'AU', comboCode:'H032'}
      		
		];
		Ext.each(colData, function(item, index){
			fields.push({name: item.WAGES_CODES, text: item.WAGES_NAME, type:'uniPrice' , CODE_GUBUN:item.CODE_GUBUN});
		});
		console.log(fields);
		return fields;
	}
	
	// 엑셀업로드 그리드 컬럼 생성(수당업로드)
	function createGridExcelColumn(colData) {
		var columns = [
			{dataIndex: '_EXCEL_JOBID',		width: 120,  locked: false, hidden: true},
			{dataIndex: 'COMP_CODE',		width: 80,   locked: false, hidden: true},
			{dataIndex: 'DIV_CODE',			width: 100,  locked: false},
			{dataIndex: 'DEPT_CODE',		width: 80,   locked: false},
			{dataIndex: 'DEPT_NAME',		width: 100,  locked: false},
			{dataIndex: 'POST_CODE',		width: 80,   locked: false},
			{dataIndex: 'NAME',				width: 80,   locked: false},
			{dataIndex: 'PERSON_NUMB',		width: 80,   locked: false},
			{dataIndex: 'JOIN_DATE',		width: 80,   locked: false},
	        {dataIndex: 'PAY_YYYYMM',		width: 80,   locked: false},
	        {dataIndex: 'SUPP_DATE',		width: 100,  locked: false}, 
			{dataIndex: 'SUPP_TYPE',		width: 100,  locked: false}
			
		];
		Ext.each(colData, function(item, index){
			columns.push({dataIndex: item.WAGES_CODES,	width: 110, align : 'right'});
		});
		return columns;
	}
	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpa950skrModel1', {
		fields : fields1
	});
	
	Unilite.defineModel('Hpa950skrModel2', {
		fields : fields2
	});
	
	// 엑셀업로드 window의 Grid Model(수당업로드)
    Unilite.Excel.defineModel('excel.hpa950ukr.sheet01', {
        fields : fields3
    });
    
	// 엑셀업로드 window의 Grid Model(공제업로드)
    Unilite.Excel.defineModel('excel.hpa950ukr.sheet02', {
        fields : fields4
    });
    
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'hpa950ukrService.selectList1',
			//destroy: 'hpa950ukrService.deleteHat200',
			create: 'hpa950ukrService.insertList1',
			syncAll: 'hpa950ukrService.saveAll1'
		}
	});	
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'hpa950ukrService.selectList2',
			//destroy: 'hpa950ukrService.deleteHat200',
			create: 'hpa950ukrService.insertList2',
			syncAll: 'hpa950ukrService.saveAll2'
		}
	});	
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore1 = Unilite.createStore('hpa950ukrMasterStore1',{
		model: 'Hpa950skrModel1',
		uniOpt: {
           	isMaster	: true,				// 상위 버튼 연결 
            editable	: false,			// 수정 모드 사용 
            deletable	: false,			// 삭제 가능 여부 
	        useNavi		: false				// prev | newxt 버튼 사용
	            	
        },
        autoLoad: false,
/*        proxy: {
            type: 'direct',
            api: {			
                read: 'hpa950ukrService.selectList1'                	
            }
        },*/
        proxy: directProxy1,
        
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
        
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(store.getCount() == 0){
           			Ext.getCmp('calcBtn').setDisabled(true);
           			Ext.getCmp('calcBtnS').setDisabled(true);
           		} else {
           			Ext.getCmp('calcBtn').setDisabled(false);
           			Ext.getCmp('calcBtnS').setDisabled(false);
           		}
           		
           	}
		}
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore2 = Unilite.createStore('hpa950ukrMasterStore2',{
		model: 'Hpa950skrModel2',
		uniOpt: {
           	isMaster	: true,				// 상위 버튼 연결 
            editable	: false,			// 수정 모드 사용 
            deletable	: false,			// 삭제 가능 여부 
	        useNavi		: false				// prev | newxt 버튼 사용
	            	
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
        
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(store.getCount() == 0){
           			Ext.getCmp('calcBtn').setDisabled(true);
           		} else {
           			Ext.getCmp('calcBtn').setDisabled(false);
           		}
           		
           	}
		}
	});

	/* 검색조건 (Search Panel)
	 * @type 
	 */	
   	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.human.basisinfo" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
	        items: [{
	        	fieldLabel: '지급년월', 
				xtype  : 'uniMonthfield',   
				name   : 'PAY_YYYYMM',
				value  : new Date(),
				allowBlank: false,                	
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_YYYYMM', newValue);
					}
				}
	        },{
		        fieldLabel: '<t:message code="system.label.human.supptype" default="지급구분"/>',
		        name:'SUPP_TYPE', 	
		        xtype: 'uniCombobox',
		        comboType: 'AU',
		        comboCode:'H032',
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('SUPP_TYPE', newValue);
					}
				}
		    },{
		        fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
		        name:'DIV_CODE', 
		        xtype: 'uniCombobox', 
		        comboType:'BOR120',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('DIV_CODE', newValue);
			    	}
	     		}
		    },
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
	                    	panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			}),
			{
	            fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
	            name:'PAY_GUBUN', 	
	            xtype: 'uniCombobox', 
	            comboType:'AU',
	            comboCode:'H011',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('PAY_GUBUN', newValue);
			    	}
	     		}
	        },
		      	Unilite.popup('Employee',{
		      	fieldLabel : '<t:message code="system.label.human.employee" default="사원"/>',
			    valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
//			    validateBlank: false,
			    valueFieldWidth: 79,
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
					}
				}
      		}),
      		{
                fieldLabel: '<t:message code="system.label.human.employtype" default="사원구분"/>',
                name:'EMPLOY_TYPE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H024',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('EMPLOY_TYPE', newValue);
			    	}
	     		}
            },
			{
            xtype: 'button',
            id : 'calcBtnS',
            colspan : 2,
            margin: '0 0 0 0',
//            align: 'right',
            text:' 급여계산 및 반영 ',
            tdAttrs: {align : 'center'},
            
        	handler: function(grid, record, cellIndex, colName) {
        		
        		var activeTabId = tab.getActiveTab().getId();
				//masterStore2.loadStoreRecords();		
				
				if(activeTabId == 'hpa950ukrGrid1'){				
					var records = masterStore1.data.items;
					
				} else if(activeTabId == 'hpa950ukrGrid2'){	
					var records = masterStore2.data.items;
				}
        		var me = this;
        		Ext.getBody().mask('<t:message code="system.message.human.message128" default="생성중..."/>','loading-indicator');
        		
        		var cTaxYn       = Ext.getCmp('CALC_TAX_YN').getChecked()[0].inputValue
				var cHirYn       = Ext.getCmp('CALC_HIR_YN').getChecked()[0].inputValue
				var cIndYn       = Ext.getCmp('CALC_IND_YN').getChecked()[0].inputValue
				var cMedYn       = Ext.getCmp('CALC_MED_YN').getChecked()[0].inputValue
	        	//var record = masterGrid1.getSelectedRecord();
	        	//var records = masterStore1.data.items;
	        	//masterStore1.data.items;
				
	        	var param ;
	        	Ext.each(records, function(record,i){
	        		param = {
						action:'select',
						'PAY_YYYYMM' 	: record.get('PAY_YYYYMM').replace('.',''),
						'SUPP_DATE' 	: UniDate.getDbDateStr(record.get('SUPP_DATE')),
						'SUPP_TYPE' 	: record.get('SUPP_TYPE'),
						'DIV_CODE' 		: record.get('DIV_CODE'),
						'DEPT_CODE' 	: record.get('DEPT_CODE'),
						'PAY_CODE' 		: '',
						'PAY_PROV_FLAG' : '',
						'PERSON_NUMB' 	: record.get('PERSON_NUMB'),					
						'BATCH_YN' 		: 'N',
						'DELETE_YN' 	: 'N',
						
						'CALC_TAX_YN' 	: cTaxYn,
						'CALC_HIR_YN' 	: cHirYn, 
						'CALC_IND_YN' 	: cIndYn,
						'CALC_MED_YN' 	: cMedYn
						
//						'CALC_TAX_YN' 	: 'Y',
//						'CALC_HIR_YN' 	: 'Y',
//						'CALC_IND_YN' 	: 'Y',
//						'CALC_MED_YN' 	: 'Y'
					};
					
//					Ext.getBody().mask();
					hpa950ukrService.payroll(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
							if(records.length-1 == i){
								Ext.getBody().unmask();
								alert("급여계산을 완료하였습니다.");
							}
						}
					});	
	        	});
	        	//var count = masterGrid1.getStore().getCount();
	        }
            
         }
            ]
        }],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
   	   			if(invalid.length > 0) {
					r=false;
	  				var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
	   					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
	   				}
			   		alert(labelText+'<t:message code="system.message.human.message045" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();		    
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
        	fieldLabel: '지급년월', 
			xtype  : 'uniMonthfield',   
			name   : 'PAY_YYYYMM',
			value  : new Date(),
			tdAttrs: {width: 400},  
			allowBlank: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_YYYYMM', newValue);
				}
			}
        },{
	        fieldLabel: '<t:message code="system.label.human.supptype" default="지급구분"/>',
	        name:'SUPP_TYPE', 	
	        xtype: 'uniCombobox',
	        comboType: 'AU',
	        comboCode:'H032',
	        allowBlank: false,
	        tdAttrs: {width: 400},  
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {      
					panelSearch.setValue('SUPP_TYPE', newValue);
				}
			}
	    },{
	        fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
	        name:'DIV_CODE', 
	        xtype: 'uniCombobox', 
	        comboType:'BOR120',
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('DIV_CODE', newValue);
		    	}
     		}
	    },
    	Unilite.treePopup('DEPTTREE',{
			fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
//			textFieldWidth:89,
			textFieldWidth: 159,
			validateBlank:true,
//			width:300,
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
			}
		}),
		{
			xtype: 'container',
			layout: {type : 'uniTable'},
			items :[{
	            fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
	            name:'PAY_GUBUN', 	
	            xtype: 'uniCombobox', 
	            comboType:'AU',
	            comboCode:'H011',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelSearch.setValue('PAY_GUBUN', newValue);
			    	}
	     		}
	        }]
		},
	      	Unilite.popup('Employee',{
	      	fieldLabel : '<t:message code="system.label.human.employee" default="사원"/>',
		    valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
//		    validateBlank: false,
		    valueFieldWidth: 79,
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
				}
			}
  		}),
  		{
            fieldLabel: '<t:message code="system.label.human.employtype" default="사원구분"/>',
            name:'EMPLOY_TYPE', 	
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'H024',
//            colspan: 2,
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('EMPLOY_TYPE', newValue);
		    	}
     		}
        }
        
        
		,{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.human.taxcalculation" default="세액계산"/>',
			labelWidth:110,
			name : 'CALC_TAX_YN',
			id: 'CALC_TAX_YN',
			items : [{
				boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
				width: 50,
				name : 'CALC_TAX_YN',
				inputValue: 'Y'
			},{
				boxLabel: '<t:message code="system.label.human.donot" default="안한다"/>',
				width: 60,
				name : 'CALC_TAX_YN',
				checked: true,
				inputValue: 'N'
			}]
		}
			
		,{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.human.hireinsurtype2" default="고용보험계산"/>',
			name : 'CALC_HIR_YN',
			id: 'CALC_HIR_YN',
			items : [{
				boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
				width: 50,
				name : 'CALC_HIR_YN',
				inputValue: 'Y'
			},{
				boxLabel: '<t:message code="system.label.human.donot" default="안한다"/>',
				width: 60,
				name : 'CALC_HIR_YN',
				checked: true,
				inputValue: 'N'}
		]}
		
		,{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.human.workconpenyn" default="산재보험계산"/>',
			name : 'CALC_IND_YN',
			id: 'CALC_IND_YN',
//			colspan:2,
			items : [{
				boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
				width: 50,
				name : 'CALC_IND_YN',
				inputValue: 'Y'
			},{
				boxLabel: '<t:message code="system.label.human.donot" default="안한다"/>',
				width: 60,
				name : 'CALC_IND_YN',
				checked: true,
				inputValue: 'N'
			}]
		}
		
		,{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.human.anuhealthinsursum" default="국민/건강보험계산"/>',
			name : 'CALC_MED_YN',
			id: 'CALC_MED_YN',
			labelWidth:110,
//			colspan:2,
			items : [{
				boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
				width: 50,
				name : 'CALC_MED_YN',
				inputValue: 'Y'
			},{
				boxLabel: '<t:message code="system.label.human.donot" default="안한다"/>',
				width: 60,
				name : 'CALC_MED_YN',
				checked: true,
				inputValue: 'N'
			}]
		}
        ,
		{
            xtype: 'button',
            id : 'calcBtn',
 //           colspan : 2,
            margin: '0 0 0 0',
//            align: 'right',
            text:' 급여계산 및 반영 ',
            tdAttrs: {align : 'right'},
            
        	handler: function(grid, record, cellIndex, colName) {
        		
        		var activeTabId = tab.getActiveTab().getId();
				//masterStore2.loadStoreRecords();		
				
				if(activeTabId == 'hpa950ukrGrid1'){				
					var records = masterStore1.data.items;
					
				} else if(activeTabId == 'hpa950ukrGrid2'){	
					var records = masterStore2.data.items;
				}
        		var me = this;
        		Ext.getBody().mask('<t:message code="system.message.human.message128" default="생성중..."/>','loading-indicator');
	        	//var record = masterGrid1.getSelectedRecord();
	        	//var records = masterStore1.data.items;
	        	//masterStore1.data.items;
				
				var cTaxYn       = Ext.getCmp('CALC_TAX_YN').getChecked()[0].inputValue
				var cHirYn       = Ext.getCmp('CALC_HIR_YN').getChecked()[0].inputValue
				var cIndYn       = Ext.getCmp('CALC_IND_YN').getChecked()[0].inputValue
				var cMedYn       = Ext.getCmp('CALC_MED_YN').getChecked()[0].inputValue
				
				
	        	var param ;
	        	Ext.each(records, function(record,i){
	        		param = {
						action:'select',
						'PAY_YYYYMM' 	: record.get('PAY_YYYYMM').replace('.',''),
						'SUPP_DATE' 	: UniDate.getDbDateStr(record.get('SUPP_DATE')),
						'SUPP_TYPE' 	: record.get('SUPP_TYPE'),
						'DIV_CODE' 		: record.get('DIV_CODE'),
						'DEPT_CODE' 	: record.get('DEPT_CODE'),
						'PAY_CODE' 		: '',
						'PAY_PROV_FLAG' : '',
						'PERSON_NUMB' 	: record.get('PERSON_NUMB'),					
						'BATCH_YN' 		: 'N',
						'DELETE_YN' 	: 'N',
						'CALC_TAX_YN' 	: cTaxYn,
						'CALC_HIR_YN' 	: cHirYn, 
						'CALC_IND_YN' 	: cIndYn,
						'CALC_MED_YN' 	: cMedYn
						
						//'CALC_TAX_YN' 	: 'Y',
						//'CALC_HIR_YN' 	: 'Y',
						//'CALC_IND_YN' 	: 'Y',
						//'CALC_MED_YN' 	: 'Y'
					};
					hpa950ukrService.payroll(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
							if(records.length-1 == i){
								Ext.getBody().unmask();
								alert("급여계산을 완료하였습니다.");
							}
						}
					});	
	        	});
	        	//var count = masterGrid1.getStore().getCount();
	        }
            
         }]
	});

	/* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid1 = Unilite.createGrid('hpa950ukrGrid1', {
    	title: '수당',
        layout: 'fit',
    	region	: 'center',
    	store	: masterStore1,
        columns	: columns1,
        selModel: 'rowmodel',
        uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		dblClickToEdit		: false,
    		onLoadSelectFirst	: false, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext 		: true,
    		filter: {
				useFilter		: false,
				autoCreate		: false
			}
        },
        
        tbar  : [{
            text    : '수당 업로드',
            id  : 'excelBtn1',
            width   : 120,
            handler : function() {
                if(!panelResult.getInvalidMessage()) return;   //필수체크
                openExcelWindow1();
            }
        }],
        
        features: [{
        	id: 'masterGridSubTotal',
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: false 
        },{
	        id: 'masterGridTotal', 	
	        ftype: 'uniSummary', 
	        showSummaryRow: false
        }],
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}
        },
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
    		//조건에 맞는 링크만 보이게 하기 위해 초기에는 다 숨김 처리
			var param = {
				MAIN_CODE: 'H032',
				SUB_CODE: record.get('SUPP_TYPE'),
				field:'refCode1'
			};
			var sPaycode = UniHuman.fnGetRefCode(param);
    		if(record.get('SUPP_TYPE') == '1' || sPaycode == '1'){
	      		menu.down('#linkHpa610ukr').hide();
	      		menu.down('#linkHbo220ukr').hide();
	      		
				menu.down('#linkHpa330ukr').show();
	      		
    		} else if (record.get('SUPP_TYPE') == 'F'){
				menu.down('#linkHpa330ukr').hide();
	      		menu.down('#linkHbo220ukr').hide();
	      		
	      		menu.down('#linkHpa610ukr').show();
    		} else {
				menu.down('#linkHpa330ukr').hide();
	      		menu.down('#linkHpa610ukr').hide();
	      		
	      		menu.down('#linkHbo220ukr').show();
    		}
    		
      		return true;
			
      	}

    });      
    
	/* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid2 = Unilite.createGrid('hpa950ukrGrid2', {
    	title: '공제',
        layout: 'fit',
    	region	: 'center',
    	store	: masterStore2,
        columns	: columns2,
        selModel: 'rowmodel',
        uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		dblClickToEdit		: false,
    		onLoadSelectFirst	: false, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext 		: true,
    		filter: {
				useFilter		: false,
				autoCreate		: false
			}
        },
        
        tbar  : [{
            text    : '공제 업로드',
            id  	: 'excelBtn2',
            width   : 120,
            handler : function() {
                if(!panelResult.getInvalidMessage()) return;   //필수체크
                openExcelWindow2();
            }
        }],
        
        features: [{
        	id: 'masterGridSubTotal',
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: false 
        },{
	        id: 'masterGridTotal', 	
	        ftype: 'uniSummary', 
	        showSummaryRow: false
        }],
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}
        },
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
    		//조건에 맞는 링크만 보이게 하기 위해 초기에는 다 숨김 처리
			var param = {
				MAIN_CODE: 'H032',
				SUB_CODE: record.get('SUPP_TYPE'),
				field:'refCode1'
			};
			var sPaycode = UniHuman.fnGetRefCode(param);
    		if(record.get('SUPP_TYPE') == '1' || sPaycode == '1'){
	      		menu.down('#linkHpa610ukr').hide();
	      		menu.down('#linkHbo220ukr').hide();
	      		
				menu.down('#linkHpa330ukr').show();
	      		
    		} else if (record.get('SUPP_TYPE') == 'F'){
				menu.down('#linkHpa330ukr').hide();
	      		menu.down('#linkHbo220ukr').hide();
	      		
	      		menu.down('#linkHpa610ukr').show();
    		} else {
				menu.down('#linkHpa330ukr').hide();
	      		menu.down('#linkHpa610ukr').hide();
	      		
	      		menu.down('#linkHbo220ukr').show();
    		}
      		//menu.showAt(event.getXY());
      		return true;
			
      	}
    });
    
	var tab = Ext.create('Ext.tab.Panel',{
            region:'center',
            items: [
                masterGrid1,
                masterGrid2
            ],
            listeners: {
             tabchange: function(){
                var activeTabId = tab.getActiveTab().getId();
                
                if(activeTabId == 'hpa950ukrGrid1'){    
                    
                    
                }else if(activeTabId == 'hpa950ukrGrid2'){      
                    
                }
             }
         }
        });
	
	Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
					tab
			 	  , panelResult
			]	
		},
			panelSearch
		], 
		id : 'hpa950ukrApp',
		fnInitBinding : function() {
	
//			if(!Ext.isEmpty(getCostPoolName)){
//				panelSearch.getField('COST_POOL').setFieldLabel(getCostPoolName[0].REF_CODE2);  			
//				panelResult.getField('COST_POOL').setFieldLabel(getCostPoolName[0].REF_CODE2);
//			}
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('PAY_YYYYMM',UniDate.get('today'));
			panelResult.setValue('PAY_YYYYMM',UniDate.get('today'));
			
			panelSearch.setValue('SUPP_TYPE','1');
			panelResult.setValue('SUPP_TYPE','1');
									
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			
			Ext.getCmp('calcBtn').setDisabled(true);
			Ext.getCmp('calcBtnS').setDisabled(true);
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onQueryButtonDown : function()	{			
			if(!this.isValidSearchForm()){				//조회 전 필수값 입력 여부 체크
				return false;
			}
			var activeTabId = tab.getActiveTab().getId();
			//masterStore2.loadStoreRecords();		
			
			if(activeTabId == 'hpa950ukrGrid1'){				
				masterStore1.loadStoreRecords();
				
			} else if(activeTabId == 'hpa950ukrGrid2'){	
				masterStore2.loadStoreRecords();
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid1.reset();
			masterStore1.clearData();
			masterGrid2.reset();
			masterStore2.clearData();
			this.fnInitBinding();
		},
		onSaveAsExcelButtonDown :function() {
			masterGrid1.downloadExcelXml(false, '<t:message code="system.label.human.title" default="타이틀"/>');
			masterGrid1.getStore().groupField = null;
			masterGrid1.getStore().load();
			
			masterGrid2.downloadExcelXml(false, '<t:message code="system.label.human.title" default="타이틀"/>');
			masterGrid2.getStore().groupField = null;
			masterGrid2.getStore().load();
		},
		onPrintButtonDown : function() {
			//do something!!
		},
		
		onSaveDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'hpa950ukrGrid1'){				
				masterStore1.saveStore();
				
			} else if(activeTabId == 'hpa950ukrGrid2'){	
				masterStore2.saveStore();
			}
			
			UniAppManager.setToolbarButtons('save', false);
			Ext.getCmp('calcBtn').setDisabled(false);
			Ext.getCmp('calcBtnS').setDisabled(false);
		},
		
		fnSetToDate:function(newValue) {
			if(newValue == null){
				return false;
			}else{
				panelSearch.setValue('PAY_YYYYMM', newValue);
		    	panelResult.setValue('PAY_YYYYMM', newValue);
			}
		}
	});
		
	// 모델 필드 생성
	function createModelField(colData) {
		var fields = [
      		{name: 'COMP_CODE'			, text: '<t:message code="system.label.human.compcode"   default="법인코드"/>' 	  	, type:'string'},
      		{name: 'DIV_CODE'			, text: '<t:message code="system.label.human.division"   default="사업장"/>'			, type:'string', comboType:'BOR120'},
      		{name: 'PAY_YYYYMM'			, text: '<t:message code="system.label.human.suppyyyymm" default="급여지급년월"/>'		, type:'string'},
      		{name: 'DEPT_CODE'			, text: '<t:message code="system.label.human.deptcode" 	 default="부서코드"/>' 	  	, type:'string'},
			{name: 'DEPT_NAME'			, text: '<t:message code="system.label.human.department" default="부서"/>'      	  	, type:'string'},
			{name: 'POST_CODE'			, text: '<t:message code="system.label.human.postcode" 	 default="직위"/>'			, type:'string', comboType:'AU', comboCode:'H005'},
			{name: 'NAME'				, text: '<t:message code="system.label.human.name" 		 default="성명"/>'      	  	, type:'string'},
      		{name: 'PERSON_NUMB'		, text: '<t:message code="system.label.human.personnumb" default="사번"/>'			, type:'string'},
      		{name: 'JOIN_DATE'			, text: '<t:message code="system.label.human.joindate" 	 default="입사일"/>'		  	, type:'uniDate'},
      		{name: 'SUPP_TYPE'			, text: '<t:message code="system.label.human.supptype"   default="지급구분"/>'			, type:'string'},
      		{name: 'SUPP_DATE'			, text: '<t:message code="system.label.human.suppdate"   default="지급일"/>'			, type:'uniDate'}
			
		];
		Ext.each(colData, function(item, index){
			fields.push({name: item.WAGES_CODES, text: item.WAGES_NAME, type:'uniPrice' , CODE_GUBUN:item.CODE_GUBUN});
		});
		console.log(fields);
		return fields;
	}
	
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var columns = [
			{dataIndex: 'DIV_CODE',			width: 120,  locked: true  	, hidden: true} ,
			{dataIndex: 'PAY_YYYYMM',		width: 100,  locked: true  	, align : 'center'},
			{dataIndex: 'SUPP_DATE',		width: 80,   locked: true}	,
			{dataIndex: 'SUPP_TYPE',		width: 80,   locked: true	, hidden: true}	,
	        {dataIndex: 'DEPT_CODE',		width: 80,   locked: true} 	,
			{dataIndex: 'DEPT_NAME',		width: 150,  locked: true} 	,
			{dataIndex: 'NAME',				width: 90,   locked: true} 	,
			{dataIndex: 'PERSON_NUMB',		width: 100,  locked: true} 	,
			{dataIndex: 'POST_CODE',		width: 80,   locked: false}	,
			{dataIndex: 'JOIN_DATE',		width: 100,  locked: false}
			
		];
		Ext.each(colData, function(item, index){
			/*columns.push({dataIndex: item.WAGES_CODES,	width: 110, align : 'right',  summaryType: 'sum'});*/
			columns.push({dataIndex: item.WAGES_CODES,	width: 110, align : 'right'});
		});
		return columns;
	}
	

	//엑셀업로드 윈도우 생성 함수
    function openExcelWindow1() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUpload';
        if(!masterStore1.isDirty())  {                                   //화면에 저장할 내용이 있을 경우 저장여부 확인
            //masterStore.loadData({});
        } else {
            if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
                UniAppManager.app.onSaveDataButtonDown();
                return;
            }else {
                masterStore1.loadData({});
            }
        }
        /*if(!Ext.isEmpty(excelWindow)){
            excelWindow.extParam.DIV_CODE       = panelResult.getValue('DIV_CODE');
//          excelWindow.extParam.ISSUE_GUBUN    = Ext.getCmp('rdoSelect0').getChecked()[0].inputValue;
//          excelWindow.extParam.APPLY_YN       = Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue;
        }*/
        if(!excelWindow1) { 
            excelWindow1 = Ext.WindowMgr.get(appName);
            excelWindow1 = Ext.create( appName, {
                excelConfigName: 'hpa950ukr1',
                width   : 600,
                height  : 400,
                modal   : false,
                extParam: { 
                    'PGM_ID'    : 'hpa950ukr1'
                },
                grids: [{                           //팝업창에서 가져오는 그리드
                        itemId      : 'grid01',
                        title       : '엑셀업로드',                             
                        useCheckbox : false,
                        model       : 'excel.hpa950ukr.sheet01',
                        readApi     : 'hpa950ukrService.selectExcelUploadSheet1',
                        columns	: columns3
                    }
                ],
                listeners: {
                    close: function() {
                        this.hide();
                    }
                },

                onApply:function()  {
                    excelWindow1.getEl().mask('로딩중...','loading-indicator');
                    var me      = this;
                    var grid    = this.down('#grid01');
                    var records = grid.getStore().getAt(0); 
                    if (!Ext.isEmpty(records)) {
                        var param   = {
                            "_EXCEL_JOBID"  : records.get('_EXCEL_JOBID')
                        };
                        excelUploadFlag = "Y"
                        
                        masterGrid1.reset();
						masterStore1.clearData();
                        
                        hpa950ukrService.selectExcelUploadSheet1(param, function(provider, response){
                            var store   = masterGrid1.getStore();
                            var records = response.result;
                            console.log("response",response);
                            
                            Ext.each(records, function(record, idx) {
                                record.SEQ  = idx + 1;
                                store.insert(i, record);
                            });
                            
                            UniAppManager.setToolbarButtons('save',true);
                                                        
                            excelWindow1.getEl().unmask();
                            grid.getStore().removeAll();
                            me.hide();
                        });
                        excelUploadFlag = "N"

                    } else {
                        alert (Msg.fSbMsgH0284);
                        this.unmask();  
                    }
                    

                    //버튼세팅
                    //UniAppManager.setToolbarButtons('newData',  true);
                    UniAppManager.setToolbarButtons('delete',   false);
                },
                
                //툴바 세팅
                _setToolBar: function() {
                    var me = this;
                    me.tbar = [
                    '->',
                    {
                        xtype   : 'button',
                        text    : '업로드',
                        tooltip : '업로드', 
                        width   : 60,
                        handler: function() {
                            me.jobID = null;
                            me.uploadFile();
                        }
                    },{
                        xtype   : 'button',
                        text    : '적용',
                        tooltip : '적용',  
                        width   : 60,
                        handler : function() { 
                            var grids   = me.down('grid');
                            var isError = false;
                            if(Ext.isDefined(grids.getEl()))    {
                                grids.getEl().mask();
                            }
                            Ext.each(grids, function(grid, i){   
                                var records = grid.getStore().data.items;
                                return Ext.each(records, function(record, i){   
                                    if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
                                        console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
                                        isError = true;  
                                        return false;
                                    }
                                });
                            }); 
                            if(Ext.isDefined(grids.getEl()))    {
                                grids.getEl().unmask();
                            }
                            if(!isError) {
                                me.onApply();
                            }else {
                                alert("에러가 있는 행은 적용이 불가능합니다.");
                            }
                        }
                    },{
                            xtype: 'tbspacer'   
                    },{
                            xtype: 'tbseparator'    
                    },{
                            xtype: 'tbspacer'   
                    },{
                        xtype: 'button',
                        text : '닫기',
                        tooltip : '닫기', 
                        handler: function() { 
                            var grid = me.down('#grid01');
                            grid.getStore().removeAll();
                            me.hide();
                        }
                    }
                ]}
            });
        }
        excelWindow1.center();
        excelWindow1.show();
    };
    
    
//엑셀업로드 윈도우 생성 함수
    function openExcelWindow2() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUpload';
        if(!masterStore2.isDirty())  {                                   //화면에 저장할 내용이 있을 경우 저장여부 확인
            //masterStore.loadData({});
        } else {
            if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
                UniAppManager.app.onSaveDataButtonDown();
                return;
            }else {
                masterStore2.loadData({});
            }
        }
        /*if(!Ext.isEmpty(excelWindow)){
            excelWindow.extParam.DIV_CODE       = panelResult.getValue('DIV_CODE');
//          excelWindow.extParam.ISSUE_GUBUN    = Ext.getCmp('rdoSelect0').getChecked()[0].inputValue;
//          excelWindow.extParam.APPLY_YN       = Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue;
        }*/
        if(!excelWindow2) { 
            excelWindow2 = Ext.WindowMgr.get(appName);
            excelWindow2 = Ext.create( appName, {
                excelConfigName: 'hpa950ukr2',
                width   : 600,
                height  : 400,
                modal   : false,
                extParam: { 
                    'PGM_ID'    : 'hpa950ukr2'
                    //'DIV_CODE'  : panelResult.getValue('DIV_CODE')
                },
                grids: [{                           //팝업창에서 가져오는 그리드
                        itemId      : 'grid02',
                        title       : '엑셀업로드',                             
                        useCheckbox : false,
                        model       : 'excel.hpa950ukr.sheet02',
                        readApi     : 'hpa950ukrService.selectExcelUploadSheet2',
                        columns	: columns4
                    }
                ],
                listeners: {
                    close: function() {
                        this.hide();
                    }
                },

                onApply:function()  {
                    excelWindow2.getEl().mask('로딩중...','loading-indicator');
                    var me      = this;
                    var grid    = this.down('#grid02');
                    var records = grid.getStore().getAt(0); 
                    if (!Ext.isEmpty(records)) {
                        var param   = {
                            "_EXCEL_JOBID"  : records.get('_EXCEL_JOBID')
                        };
                        excelUploadFlag = "Y"
                        
                        masterGrid2.reset();
						masterStore2.clearData();
                        
                        hpa950ukrService.selectExcelUploadSheet2(param, function(provider, response){
                            var store   = masterGrid2.getStore();
                            var records = response.result;
                            console.log("response",response);
                            
                            Ext.each(records, function(record, idx) {
                                record.SEQ  = idx + 1;
                                store.insert(i, record);
                            });
                            
                            UniAppManager.setToolbarButtons('save',true);
                                                        
                            excelWindow2.getEl().unmask();
                            grid.getStore().removeAll();
                            me.hide();
                        });
                        excelUploadFlag = "N"

                    } else {
                        alert (Msg.fSbMsgH0284);
                        this.unmask();  
                    }
                    

                    //버튼세팅
                    //UniAppManager.setToolbarButtons('newData',  true);
                    UniAppManager.setToolbarButtons('delete',   false);
                },
                
                //툴바 세팅
                _setToolBar: function() {
                    var me = this;
                    me.tbar = [
                    '->',
                    {
                        xtype   : 'button',
                        text    : '업로드',
                        tooltip : '업로드', 
                        width   : 60,
                        handler: function() {
                            me.jobID = null;
                            me.uploadFile();
                        }
                    },{
                        xtype   : 'button',
                        text    : '적용',
                        tooltip : '적용',  
                        width   : 60,
                        handler : function() { 
                            var grids   = me.down('grid');
                            var isError = false;
                            if(Ext.isDefined(grids.getEl()))    {
                                grids.getEl().mask();
                            }
                            Ext.each(grids, function(grid, i){   
                                var records = grid.getStore().data.items;
                                return Ext.each(records, function(record, i){   
                                    if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
                                        console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
                                        isError = true;  
                                        return false;
                                    }
                                });
                            }); 
                            if(Ext.isDefined(grids.getEl()))    {
                                grids.getEl().unmask();
                            }
                            if(!isError) {
                                me.onApply();
                            }else {
                                alert("에러가 있는 행은 적용이 불가능합니다.");
                            }
                        }
                    },{
                            xtype: 'tbspacer'   
                    },{
                            xtype: 'tbseparator'    
                    },{
                            xtype: 'tbspacer'   
                    },{
                        xtype: 'button',
                        text : '닫기',
                        tooltip : '닫기', 
                        handler: function() { 
                            var grid = me.down('#grid02');
                            grid.getStore().removeAll();
                            me.hide();
                        }
                    }
                ]}
            });
        }
        excelWindow2.center();
        excelWindow2.show();
    };
	
	
};
</script>
