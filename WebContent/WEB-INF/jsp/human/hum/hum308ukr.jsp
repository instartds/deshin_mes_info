<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum308ukr"  >
	<t:ExtComboStore comboType="BOR120"	pgmId="hum308ukr"/> 			<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 				<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H181" /> 				<!-- 사원그룹 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> 				<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> 				<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> 				<!-- 급여지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 				<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H094" /> 				<!-- 발령코드 -->
	<t:ExtComboStore comboType="AU" comboCode="GO01" /> 				<!-- 영업소 -->
	<t:ExtComboStore comboType="AU" comboCode="GO16" /> 				<!-- 노선그룹 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /> 				<!-- 직책 -->
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
	Unilite.Excel.defineModel('excel.hum308.sheet01', {
	    fields: [
	    	{name: 'COMP_CODE'					,text:'법인코드'			,type:'string' },
	    	{name: 'PERSON_NUMB'				,text:'사번'				,type:'string' },
	    	{name: 'NAME'						,text:'성명'				,type:'string' , allowBlank: false},
			
	    	{name: 'ANNOUNCE_DATE'  			,text:'발령일자'			,type:'uniDate', allowBlank: false},
	    	{name: 'ANNOUNCE_CODE'				,text:'발령코드'			,type:'string' , allowBlank: false},
	    	{name: 'BE_DIV_NAME'				,text:'발령전사업장'		,type:'string' },
	    	{name: 'AF_DIV_NAME'				,text:'발령후사업장'		,type:'string' , allowBlank: false},
	    	{name: 'BE_DEPT_CODE'				,text:'발령전부서코드'		,type:'string'},
	    	{name: 'BE_DEPT_NAME'				,text:'발령전부서명'		,type:'string'},
	    	{name: 'AF_DEPT_CODE'				,text:'발령후부서코드'		,type:'string' , allowBlank: false},
	    	{name: 'AF_DEPT_NAME'				,text:'발령후부서명'		,type:'string' , allowBlank: false},
	    	{name: 'POST_CODE2'					,text:'직위'				,type:'string'},
	    	{name: 'ABIL_CODE'					,text:'직책'				,type:'string'},
	    	{name: 'ANNOUNCE_REASON'			,text:'발령사유'			,type:'string' ,maxLength:50},
	    	{name: 'PAY_GRADE_01'				,text:'호봉(급)'			,type:'string' ,maxLength:3},
	    	{name: 'PAY_GRADE_02'				,text:'호봉(호)'			,type:'string' ,maxLength:3},
	    	{name: 'PAY_GRADE_BASE'				,text:'승급기준'			,type:'string'},
	    	{name: 'YEAR_GRADE'					,text:'근속(년)'			,type:'string'},
	    	{name: 'YEAR_GRADE_BASE'			,text:'승급기준(근속)'		,type:'string'},
	    	{name: 'COST_KIND'					,text:'사업명'			,type:'string'},
	    	{name: 'WAGES_STD_I'				,text:'호봉급여급'			,type:'uniPrice',maxLength:10},
	    	{name: 'ANNUAL_SALARY_I'			,text:'연봉'				,type:'uniPrice',maxLength:10},
	    	{name: 'OFFICE_CODE'				,text:'영업소'			,type:'string' ,maxLength:20},
	    	{name: 'ROUTE_GROUP'				,text:'소속그룹'			,type:'string' ,maxLength:20},
	    	{name: 'EMPLOY_TYPE'				,text:'사원그룹'			,type:'string'}, 
	    	
	    	{name: 'INSERT_DB_USER'				,text:'입력자'			,type:'string' },
	    	{name: 'INSERT_DB_TIME'				,text:'입력일'			,type:'uniDate'},
	    	{name: 'UPDATE_DB_USER'				,text:'수정자'			,type:'string' },
	    	{name: 'UPDATE_DB_TIME'				,text:'수정일'			,type:'uniDate'}
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
                		excelConfigName: 'hum308',
                        grids: [{
                        		itemId: 'grid01',
                        		title: '인사변동(발령)등록 양식',                        		
                        		useCheckbox: false,
                        		model : 'excel.hum308.sheet01',
                        		readApi: 'hum308ukrService.selectExcelUploadSheet1',
                        		columns: [        
									{dataIndex: 'PERSON_NUMB'		, width: 100}, 	
									{dataIndex: 'NAME'				, width: 100}, 	
									{dataIndex: 'ANNOUNCE_DATE'  	, width: 120}, 	
									{dataIndex: 'ANNOUNCE_CODE'		, width: 100}, 	
									{dataIndex: 'BE_DIV_NAME'		, width: 100}, 	
									{dataIndex: 'AF_DIV_NAME'		, width: 100}, 	
									{dataIndex: 'BE_DEPT_CODE'		, width: 100}, 	
									{dataIndex: 'BE_DEPT_NAME'		, width: 100}, 	
									{dataIndex: 'AF_DEPT_CODE'		, width: 100}, 	
									{dataIndex: 'AF_DEPT_NAME'		, width: 100}, 	
									{dataIndex: 'POST_CODE2'		, width: 100}, 	
									{dataIndex: 'ABIL_CODE'			, width: 100}, 	
									{dataIndex: 'ANNOUNCE_REASON'	, width: 100}, 	
									{dataIndex: 'PAY_GRADE_01'		, width: 100}, 	
									{dataIndex: 'PAY_GRADE_02'		, width: 100}, 	
									{dataIndex: 'PAY_GRADE_BASE'	, width: 100}, 	
									{dataIndex: 'YEAR_GRADE'		, width: 100}, 	
									{dataIndex: 'YEAR_GRADE_BASE'	, width: 100}, 	
									{dataIndex: 'COST_KIND'			, width: 100}, 	
									{dataIndex: 'WAGES_STD_I'		, width: 100}, 	
									{dataIndex: 'ANNUAL_SALARY_I'	, width: 100}, 	
									{dataIndex: 'OFFICE_CODE'		, width: 100}, 	
									{dataIndex: 'ROUTE_GROUP'		, width: 100}, 	
									{dataIndex: 'EMPLOY_TYPE'		, width: 100},
									
									{dataIndex: 'UPDATE_DB_USER'	, width: 0, hidden: true}, 				
									{dataIndex: 'UPDATE_DB_TIME'	, width: 0, hidden: true}
									
								]
                        }],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
                        },
                        onApply:function()	{
							excelWindow.getEl().mask('로딩중...','loading-indicator');		///////// 엑셀업로드 최신로직
                        	var me = this;
                        	var grid = this.down('#grid01');
                			var records = grid.getStore().getAt(0);	
				        	var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
							hum308ukrService.selectExcelUploadApply(param, function(provider, response){
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
        	read : 'hum308ukrService.selectList',
        	update: 'hum308ukrService.updateDetail',
			create: 'hum308ukrService.insertDetail',
			destroy: 'hum308ukrService.deleteDetail',
			syncAll: 'hum308ukrService.saveAll'
        }
	});
	
	var ReportYNStore = Unilite.createStore('hum308ukrReportYNStore', {  // 그리드 상 Report 제출여부 Y : 1 , N : 2  
	    fields: ['text', 'value'],
		data :  [
			        {'text':'예'		, 'value':'1'},
			        {'text':'아니오'	, 'value':'2'}
	    		]
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum308ukrModel', {
	    fields: [
	    	{name: 'COMP_CODE'					,text:'법인코드'			,type:'string' },
	    	{name: 'DIV_CODE'					,text:'사업장'			,type:'string' , comboType: 'BOR120'},
	    	{name: 'DEPT_NAME'					,text:'부서'				,type:'string' },
	    	{name: 'POST_CODE2'					,text:'직위'				,type:'string' , comboType:'AU', comboCode:'H005'},
	    	{name: 'NAME'						,text:'성명'				,type:'string' },
	    	{name: 'PERSON_NUMB'				,text:'사번'				,type:'string'  , allowBlank: false},
			
	    	{name: 'ANNOUNCE_DATE'  			,text:'발령일자'			,type:'uniDate', allowBlank: false},
	    	{name: 'ANNOUNCE_CODE'				,text:'발령코드'			,type:'string' , allowBlank: false , comboType:'AU', comboCode:'H094'},
	    	{name: 'BE_DIV_NAME'				,text:'발령전사업장'		,type:'string' , comboType: 'BOR120'},
	    	{name: 'AF_DIV_NAME'				,text:'발령후사업장'		,type:'string' , allowBlank: false , comboType: 'BOR120' },
	    	{name: 'BE_DEPT_CODE'				,text:'발령전부서코드'		,type:'string'},
	    	{name: 'BE_DEPT_NAME'				,text:'발령전부서명'		,type:'string'},
	    	{name: 'AF_DEPT_CODE'				,text:'발령후부서코드'		,type:'string' , allowBlank: false},
	    	{name: 'AF_DEPT_NAME'				,text:'발령후부서명'		,type:'string' , allowBlank: false},
	    	{name: 'POST_CODE'					,text:'직위'				,type:'string' , comboType:'AU', comboCode:'H005'},
	    	{name: 'ABIL_CODE'					,text:'직책'				,type:'string' , comboType:'AU', comboCode:'H006'},
	    	{name: 'ANNOUNCE_REASON'			,text:'발령사유'			,type:'string'},
	    	{name: 'PAY_GRADE_01'				,text:'호봉(급)'			,type:'string'},
	    	{name: 'PAY_GRADE_02'				,text:'호봉(호)'			,type:'string'},
	    	{name: 'PAY_GRADE_BASE'				,text:'승급기준'			,type:'string'},
	    	{name: 'YEAR_GRADE'					,text:'근속(년)'			,type:'string'},
	    	{name: 'YEAR_GRADE_BASE'			,text:'승급기준(근속)'		,type:'string'},
	    	{name: 'COST_KIND'					,text:'사업명'			,type:'string' , store: Ext.data.StoreManager.lookup('getHumanCostPool')},
	    	{name: 'WAGES_STD_I'				,text:'호봉급여급'			,type:'uniPrice'},
	    	{name: 'ANNUAL_SALARY_I'			,text:'연봉'				,type:'uniPrice'},
	    	{name: 'OFFICE_CODE'				,text:'영업소'			,type:'string' , comboType:'AU', comboCode:'GO01'},
	    	{name: 'ROUTE_GROUP'				,text:'소속그룹'			,type:'string' , comboType:'AU', comboCode:'GO16'},
	    	{name: 'EMPLOY_TYPE'				,text:'사원그룹'			,type:'string' , comboType:'AU', comboCode:'H024'},    
	    	{name: 'CODE_CHECK'					,text:'메세지'			,type:'string'},
	    	
	    	{name: 'INSERT_DB_USER'				,text:'입력자'			,type:'string' },
	    	{name: 'INSERT_DB_TIME'				,text:'입력일'			,type:'uniDate'},
	    	{name: 'UPDATE_DB_USER'				,text:'수정자'			,type:'string' },
	    	{name: 'UPDATE_DB_TIME'				,text:'수정일'			,type:'uniDate'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hum308ukrMasterStore',{
			model: 'hum308ukrModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            proxy: directProxy							
			,loadStoreRecords : function()	{
				var param= panelSearch.getValues();			
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
				
				var paramMaster= panelSearch.getValues();	//syncAll 수정
				
				if(panelSearch.getValue('CHKCNT') == true){
					paramMaster.CHKCNT = 'Y';
				}
				else{
					paramMaster.CHKCNT = 'N';
				}
					 
    			if(inValidRecs.length == 0 )	{
    				config = {
    					params: [paramMaster],
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
	

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
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
			itemId: 'search_panel1',
			layout : {type : 'uniTable', columns : 1},
			items:[{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
        	Unilite.treePopup('DEPTTREE',{
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
				}
			}),
				Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					/*onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					}*/
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '재직구분',
				items: [{
					boxLabel: '전체', 
					width: 70, 
					name: 'RDO_TYPE',
					inputValue: '' 
				},{
					boxLabel : '재직', 
					width: 70,
					name: 'RDO_TYPE',
					inputValue: 'A',
					checked: true
					
				},{
					boxLabel: '퇴사', 
					width: 70, 
					name: 'RDO_TYPE',
					inputValue: 'B'	
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
					}
				}
			},{
				fieldLabel: '발령코드',
				name:'ANNOUNCE_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H094',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ANNOUNCE_CODE', newValue);
					}
				}
			},{	    
				fieldLabel: '발령일자',
				xtype: 'uniDateRangefield',
	            startFieldName: 'ANNOUNCE_FR_DATE',
	            endFieldName: 'ANNOUNCE_TO_DATE',
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ANNOUNCE_FR_DATE', newValue);						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ANNOUNCE_TO_DATE', newValue);				    		
			    	}
			    }
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '성별',
				items: [{
					boxLabel: '전체', 
					width: 70, 
					name: 'SEX_CODE',
					inputValue: '',
					checked: true 
				},{
					boxLabel : '남', 
					width: 70,
					name: 'SEX_CODE',
					inputValue: 'M'
				},{
					boxLabel: '여', 
					width: 70, 
					name: 'SEX_CODE',
					inputValue: 'F'	
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('SEX_CODE').setValue(newValue.SEX_CODE);
					}
				}
			},{
            	fieldLabel: '인사마스터반영',
            	name: 'CHKCNT',	
				xtype: 'checkbox',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CHKCNT', newValue);
					}
				}
    		}]
		},{
				title:'추가정보',
   				id: 'search_panel2',
				itemId:'search_panel2',
        		defaultType: 'uniTextfield',
        		layout : {type : 'uniTable', columns : 1},
        		defaultType: 'uniTextfield',
        		
        		items:[{
					fieldLabel: '고용형태',
					name:'PAY_GUBUN',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H011'
				},{
					fieldLabel: '사원구분',
					name:'EMPLOY_GUBUN',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H024'
				},{
					fieldLabel: '급여지급방식',
					name:'PAY_CODE',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H028'
				},{
					fieldLabel: '사업명',
					name:'COST_POOL',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('getHumanCostPool')
				},{
					fieldLabel: '급여차수',
					name:'PAY_PROV_FLAG',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H031'
				},{
					fieldLabel: '사원그룹',
					name:'PERSON_GROUP',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H181'
				}]				
		}]
	}); 
	
	var panelResult = Unilite.createSimpleForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},
        	Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				selectChildren:true,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				textFieldWidth:89,
				validateBlank:true,
				width:300,
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
			}),{
	        	fieldLabel: '인사마스터반영',
	        	name: 'CHKCNT',
				xtype: 'checkbox',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('CHKCNT', newValue);
					}
				}
			},
			Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				colspan:2,
				validateBlank:false,
				autoPopup:true,
				listeners: {
					/*onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
							panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
					}*/
					
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('NAME', newValue);				
					}
				}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '재직구분',
				colspan:2,
				items: [{
					boxLabel: '전체', 
					width: 70, 
					name: 'RDO_TYPE',
					inputValue: '' 
				},{
					boxLabel : '재직', 
					width: 70,
					name: 'RDO_TYPE',
					inputValue: 'A',
					checked: true
					
				},{
					boxLabel: '퇴사', 
					width: 70, 
					name: 'RDO_TYPE',
					inputValue: 'B'	
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
					}
				}
			},{
				fieldLabel: '발령코드',
				name:'ANNOUNCE_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H094',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ANNOUNCE_CODE', newValue);
					}
				}
			},{	    
				fieldLabel: '발령일자',
				xtype: 'uniDateRangefield',
	            startFieldName: 'ANNOUNCE_FR_DATE',
	            endFieldName: 'ANNOUNCE_TO_DATE',
	            width: 350,         	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('ANNOUNCE_FR_DATE', newValue);						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('ANNOUNCE_TO_DATE', newValue);				    		
			    	}
			    }
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '성별',
				colspan:2,
				items: [{
					boxLabel: '전체', 
					width: 70, 
					name: 'SEX_CODE',
					inputValue: '',
					checked: true 
				},{
					boxLabel : '남', 
					width: 70,
					name: 'SEX_CODE',
					inputValue: 'M'
				},{
					boxLabel: '여', 
					width: 70, 
					name: 'SEX_CODE',
					inputValue: 'F'	
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('SEX_CODE').setValue(newValue.SEX_CODE);
					}
				}
			}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum308ukrGrid1', {
    	region: 'center',
        layout: 'fit',
        uniOpt: {
    		expandLastColumn: false,
		 	copiedRow: true
//		 	useContextMenu: true,
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
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'refTool',
			text: '참조...',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'excelBtn',
					text: '엑셀참조',
		        	handler: function() {
			        	openExcelWindow();
			        }
				}]
			})
		}],
        store: directMasterStore,
        columns:  [  
        		//{ dataIndex: 'COMP_CODE'					, width: 100},
        		{ dataIndex: 'DIV_CODE'						, width: 120},
        		{ dataIndex: 'DEPT_NAME'					, width: 160},
        		{ dataIndex: 'POST_CODE2'					, width: 88},
        		{ dataIndex: 'NAME'							, width: 78,
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
			 								var grdRecord = Ext.getCmp('hum308ukrGrid1').uniOpt.currentRecord;
			  								grdRecord.set('PERSON_NUMB','');
			  								grdRecord.set('NAME','');
			  								
			  								grdRecord.set('DIV_CODE','');
			  								grdRecord.set('DEPT_NAME','');
			  								grdRecord.set('POST_CODE','');			
 										}
			 				}
						})
				},
        		{ dataIndex: 'PERSON_NUMB'					, width: 78,
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
										var grdRecord = Ext.getCmp('hum308ukrGrid1').uniOpt.currentRecord;
		  								grdRecord.set('PERSON_NUMB','');
		  								grdRecord.set('NAME','');
		  								
		  								grdRecord.set('DIV_CODE','');
		  								grdRecord.set('DEPT_NAME','');
		  								grdRecord.set('POST_CODE','');			
		 							}
		 				}
					})
				},
				{ dataIndex: 'ANNOUNCE_DATE'  				, width: 100},
        		{ dataIndex: 'ANNOUNCE_CODE'				, width: 100},
        		{ dataIndex: 'BE_DIV_NAME'					, width: 120},
        		{ dataIndex: 'AF_DIV_NAME'					, width: 120},
        		{ dataIndex: 'BE_DEPT_CODE'					, width: 120 ,hidden:true},
        		{ dataIndex: 'BE_DEPT_NAME'					, width: 150,
        		'editor' : Unilite.popup('DEPT_G',{
						validateBlank : true,
			  			autoPopup: true,
		  				listeners: {'onSelected':   function(records, type) {
			 								var grdRecord = Ext.getCmp('hum308ukrGrid1').uniOpt.currentRecord;
			 								grdRecord.set('BE_DEPT_CODE',records[0]['TREE_CODE']);
					                    	grdRecord.set('BE_DEPT_NAME',records[0]['TREE_NAME']);
			 							},
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('hum309ukrGrid1').uniOpt.currentRecord;
			 								grdRecord.set('BE_DEPT_CODE','');
			  								grdRecord.set('BE_DEPT_NAME','');
 										}
			 				}
						})
				},
        		{ dataIndex: 'AF_DEPT_CODE'					, width: 120 ,hidden:true},
        		{ dataIndex: 'AF_DEPT_NAME'					, width: 150,
        		'editor' : Unilite.popup('DEPT_G',{
						validateBlank : true,
			  			autoPopup: true,
		  				listeners: {'onSelected':   function(records, type) {
			 								var grdRecord = Ext.getCmp('hum308ukrGrid1').uniOpt.currentRecord;
			 								grdRecord.set('AF_DEPT_CODE',records[0]['TREE_CODE']);
					                    	grdRecord.set('AF_DEPT_NAME',records[0]['TREE_NAME']);
			 							},
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('hum309ukrGrid1').uniOpt.currentRecord;
			 								grdRecord.set('AF_DEPT_CODE','');
			  								grdRecord.set('AF_DEPT_NAME','');
 										}
			 				}
						})
				},
        		{ dataIndex: 'POST_CODE'					, width: 100},
        		{ dataIndex: 'ABIL_CODE'					, width: 100},
        		{ dataIndex: 'ANNOUNCE_REASON'				, width: 300},
        		{ dataIndex: 'PAY_GRADE_01'					, width: 100},
        		{ dataIndex: 'PAY_GRADE_02'					, width: 100},
        		{ dataIndex: 'PAY_GRADE_BASE'				, width: 100},
        		{ dataIndex: 'YEAR_GRADE'					, width: 100},
        		{ dataIndex: 'YEAR_GRADE_BASE'				, width: 100},
        		{ dataIndex: 'COST_KIND'					, width: 100},
        		{ dataIndex: 'WAGES_STD_I'					, width: 100},
        		{ dataIndex: 'ANNUAL_SALARY_I'				, width: 100},
        		{ dataIndex: 'OFFICE_CODE'					, width: 100},
        		{ dataIndex: 'ROUTE_GROUP'					, width: 100},
        		{ dataIndex: 'EMPLOY_TYPE'					, width: 100},
        		{ dataIndex: 'CODE_CHECK'					, width: 100}
        		
        		//{ dataIndex: 'INSERT_DB_USER'				, width: 120},
        		//{ dataIndex: 'INSERT_DB_TIME'				, width: 120},
        		//{ dataIndex: 'UPDATE_DB_USER'				, width: 120},
        		//{ dataIndex: 'UPDATE_DB_TIME'				, width: 120}
        	],
        	listeners: {
	    		beforeedit: function( editor, e, eOpts ) {
		        	/*if(e.record.phantom == true) {		// 신규일 때
		        		if(UniUtils.indexOf(e.field, ['OCCUR_DATE'])) {
							return false;
						}
		        	}*/
		        	if(!e.record.phantom == true) { // 신규가 아닐 때
		        		if(UniUtils.indexOf(e.field, ['NAME', 'PERSON_NUMB' ,'ANNOUNCE_DATE' ,'ANNOUNCE_CODE'])) {
							return false;
						}
		        	}
		        	if(!e.record.phantom == true || e.record.phantom == true) { 	// 신규이던 아니던
		        		if(UniUtils.indexOf(e.field, ['DIV_CODE', 'DEPT_NAME', 'POST_CODE2', 'CODE_CHECK'])) {
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
	     },
	         panelSearch
	    ], 
		id  : 'hum308ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			if(!Ext.isEmpty(gsCostPool)){
				panelSearch.getField('COST_POOL').setFieldLabel(gsCostPool);  
			}
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PERSON_NUMB');
			
			panelSearch.setValue('CHKCNT', true);
			panelResult.setValue('CHKCNT', true);
			
			panelSearch.getField('RDO_TYPE').setValue('A');
			panelResult.getField('RDO_TYPE').setValue('A');
			
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
        		COMP_CODE			: compCode
        	};
            //param = {'SEQ':seq}
	        masterGrid.createRow(r , 'NAME');
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
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
        fnHumanCheck: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			grdRecord.set('PERSON_NUMB', record.PERSON_NUMB);
			grdRecord.set('NAME', record.NAME);
			grdRecord.set('DIV_CODE', record.SECT_CODE);
			grdRecord.set('DEPT_NAME', record.DEPT_NAME);
			grdRecord.set('POST_CODE2', record.POST_CODE);
			grdRecord.set('NAME', record.NAME);
		}
	});
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			switch(fieldName) {
				
				case "ANNOUNCE_DATE" : // 발령일자
					if( 18891231 > UniDate.getDbDateStr(newValue) ){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					if ( UniDate.getDbDateStr(newValue) > 30000101){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					break;
			}
			return rv;
		}
		
	});
};

</script>
