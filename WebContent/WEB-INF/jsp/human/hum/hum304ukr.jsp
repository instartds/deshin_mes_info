<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum304ukr"  >
	<t:ExtComboStore comboType="BOR120"	pgmId="hum304ukr"/> 			<!-- 사업장  -->
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
	
	<t:ExtComboStore comboType="AU" comboCode="HE03" opts="0;1;8;9;C;" /> 				<!-- 결재상태 -->
	
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
	Unilite.Excel.defineModel('excel.hum304.sheet01', {
	    fields: [
			{name: 'DOC_ID'					,text:'DOC_ID'																	,type:'string'},
	    	{name: 'COMP_CODE'				,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'			,type:'string'},
	    	{name: 'NAME'					,text:'<t:message code="system.label.human.name" default="성명"/>'				,type:'string'},
	    	{name: 'PERSON_NUMB'			,text:'<t:message code="system.label.human.personnumb" default="사번"/>'			,type:'string'    	,allowBlank: false},
	    	{name: 'DOC_NUM'				,text:'<t:message code="system.label.human.docnum" default="문서번호"/>'			,type:'string'},
	    	{name: 'EDU_TITLE'				,text:'<t:message code="system.label.human.edutitle" default="교육명"/>'			,type:'string'    	,allowBlank: false},
	    	{name: 'EDU_CLASS'				,text:'<t:message code="system.label.human.educlass" default="교육과정"/>'			,type: 'string'		,comboType:'AU'		,comboCode:'HE81'},
	    	{name: 'EDU_GUBUN1'				,text:'<t:message code="system.label.human.edugubun1" default="학습유형"/>'		,type: 'string'		,comboType:'AU'		,comboCode:'HE33'},
	    	{name: 'EDU_GUBUN2'				,text:'<t:message code="system.label.human.edugubun2" default="학습방법"/>'		,type: 'string'		,comboType:'AU'		,comboCode:'HE34'},
	    	{name: 'EDU_GUBUN3'				,text:'<t:message code="system.label.human.edugubun3" default="학습분야"/>'		,type: 'string'		,comboType:'AU'		,comboCode:'HE35'},
	    	{name: 'EDU_FR_DATE'			,text:'<t:message code="system.label.human.edufrdate" default="교육시작기간"/>'		,type:'uniDate'    ,allowBlank: false},
	    	{name: 'EDU_TO_DATE'			,text:'<t:message code="system.label.human.edutodate" default="교육종료기간"/>'		,type:'uniDate'    ,allowBlank: false},
	    	{name: 'EDU_TIME'				,text:'<t:message code="system.label.human.edutime" default="교육시간"/>'			,type:'string'     ,allowBlank: false},
	    	{name: 'EDU_NATION'				,text:'<t:message code="system.label.human.edunation" default="교육국가"/>'		,type:'string'},
	    	{name: 'EDU_ORGAN'				,text:'<t:message code="system.label.human.eduorgan" default="교육기관"/>'			,type:'string'},
	    	{name: 'EDU_AMT'				,text:'<t:message code="system.label.human.eduusei" default="교육비"/>'			,type:'uniPrice'},
	    	{name: 'COST_POOL_CODE'     	,text:'<t:message code="system.label.human.costpoolname" default="회계부서"/>'    ,type:'string'},  //추가
	    	//{name: 'COST_POOL_NAME'     ,text:'회계명'             ,type:'string',editable:false },  //추가
	    	{name: 'SDC_ACD_YN'				,text:'<t:message code="system.label.human.sdcacdyn" default="SDC아카데미여부"/>'	,type:'string'},
	    	{name: 'LAW_EDU_YN'				,text:'<t:message code="system.label.human.laweduyn" default="법정의무교육여부"/>'	,type:'string'},
	    	{name: 'REPORT_YN'				,text:'<t:message code="system.label.human.reportyn1" default="교육결과보고서"/>'   	,type:'string'},
	    	{name: 'REMARK'					,text:'<t:message code="system.label.human.remark" default="비고"/>'	            ,type:'string'},
	    	
	    	{name: 'EDU_BASIS_NUM'		,text:'대사우교육실적근거번호'	            ,type:'string'}
//	    	{name: 'DRAFT_DATE'			,text:'승인일자'	            ,type:'string'}
	    	
	    	
//	    	{name: 'INSERT_DB_USER'				,text:'입력자'			,type:'string' },
//	    	{name: 'INSERT_DB_TIME'				,text:'입력일'			,type:'uniDate'},
//	    	{name: 'UPDATE_DB_USER'				,text:'수정자'			,type:'string' },
//	    	{name: 'UPDATE_DB_TIME'				,text:'수정일'			,type:'uniDate'}
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
                		excelConfigName: 'hum304ukr',
                		extParam: { 
                            'PGM_ID'    : 'hum304ukr'
//                            'DIV_CODE'  : panelResult.getValue('DIV_CODE')
                        },
                        grids: [{
                        		itemId: 'grid01',
                        		title: '<t:message code="system.label.human.edumanagform" default="교육실적관리양식"/>',                        		
                        		useCheckbox: false,
                        		model : 'excel.hum304.sheet01',
                        		readApi: 'hum304ukrService.selectExcelUploadSheet1',
                        		columns: [        
						        	//{dataIndex: 'DIV_CODE'		, width: 100, hidden: true}, 				
									//{dataIndex: 'DEPT_NAME'		, width: 100, hidden: true}, 			
									//{dataIndex: 'POST_CODE'		, width: 100}, 				
									{dataIndex: 'NAME'			        , width: 100}, 	
									{dataIndex: 'PERSON_NUMB'	        , width: 100}, 	
									{dataIndex: 'DOC_NUM'		        , width: 120}, 	
									{dataIndex: 'EDU_TITLE'		        , width: 120},
									{dataIndex: 'EDU_CLASS'		        , width: 120},
									{dataIndex: 'EDU_GUBUN1'	        , width: 120},
									{dataIndex: 'EDU_GUBUN2'	        , width: 120},
									{dataIndex: 'EDU_GUBUN3'	        , width: 120},
									{dataIndex: 'EDU_FR_DATE'	        , width: 100}, 	
									{dataIndex: 'EDU_TO_DATE'	        , width: 100}, 	
									{dataIndex: 'EDU_TIME'	 	        , width: 100}, 	
									{dataIndex: 'EDU_NATION'	        , width: 100}, 	
									{dataIndex: 'EDU_ORGAN'		        , width: 100}, 	
									{dataIndex: 'EDU_AMT'		        , width: 100}, 	
									{dataIndex: 'COST_POOL_CODE'        , width: 100},
									//{dataIndex: 'COST_POOL_NAME'        , width: 100},
									{dataIndex: 'SDC_ACD_YN'	        , width: 100}, 	
									{dataIndex: 'LAW_EDU_YN'	        , width: 100}, 	
									{dataIndex: 'REPORT_YN'		        , width: 100}, 	
									{dataIndex: 'REMARK'		        , width: 100} 	
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
							hum304ukrService.selectExcelUploadApply(param, function(provider, response){
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
        	read : 'hum304ukrService.selectListProcedure',
        	update: 'hum304ukrService.updateDetailProcedure',
			create: 'hum304ukrService.insertDetailProcedure',
			destroy: 'hum304ukrService.deleteDetailProcedure',
			syncAll: 'hum304ukrService.saveAllProcedure'
        }
	});
	
	var ReportYNStore = Unilite.createStore('hum304ukrReportYNStore', {  // 그리드 상 Report 제출여부 Y : 1 , N : 2  
	    fields: ['text', 'value'],
		data :  [
			        {'text':'<t:message code="system.label.human.no" default="아니오"/>'	, 'value':'2'},
			        {'text':'<t:message code="system.label.human.yes" default="예"/>'		, 'value':'1'}
	    		]
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum304ukrModel', {
	    fields: [
	   		{name: 'DOC_ID'						,text:'DOC_ID'			,type:'string' },
	    	{name: 'COMP_CODE'					,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'			,type:'string' },
	    	{name: 'DIV_CODE'					,text:'<t:message code="system.label.human.division" default="사업장"/>'			,type:'string' , comboType: 'BOR120'},
	    	{name: 'DEPT_NAME'					,text:'<t:message code="system.label.human.department" default="부서"/>'			,type:'string' },
	    	{name: 'POST_CODE'					,text:'<t:message code="system.label.human.postcode" default="직위"/>'			,type:'string' , comboType:'AU', comboCode:'H005'}, 
	    	{name: 'ABIL_CODE'					,text:'<t:message code="system.label.human.abilcode" default="직책코드"/>'			,type:'string' , comboType:'AU', comboCode:'H006'},
	    	{name: 'PERSON_NUMB'				,text:'<t:message code="system.label.human.personnumb" default="사번"/>'			,type:'string'  , allowBlank: false},
	    	{name: 'NAME'						,text:'<t:message code="system.label.human.name" default="성명"/>'				,type:'string' },
	    	{name: 'DOC_NUM'					,text:'<t:message code="system.label.human.docnum" default="문서번호"/>'		    ,type:'string' },
	    	{name: 'EDU_TITLE'					,text:'<t:message code="system.label.human.edutitle" default="교육명"/>'			,type:'string'  , allowBlank: false},
	    	{name: 'EDU_CLASS'					,text:'<t:message code="system.label.human.type" default="구분"/>(<t:message code="system.label.human.educlass" default="교육과정"/>)'	    ,type:'string', comboType: 'AU', comboCode:'HE81'}, //추가
	    	{name: 'EDU_GUBUN1'					,text:'<t:message code="system.label.human.edugubun1" default="학습유형"/>'		,type:'string'	, comboType: 'AU', comboCode:'HE33'/*, allowBlank: false*/},
	    	{name: 'EDU_GUBUN2'					,text:'<t:message code="system.label.human.edugubun2" default="학습방법"/>'		,type:'string'	, comboType: 'AU', comboCode:'HE34'/*, allowBlank: false*/},
	    	{name: 'EDU_GUBUN3'					,text:'<t:message code="system.label.human.edugubun3" default="학습분야"/>'		,type:'string'	, comboType: 'AU', comboCode:'HE35'/*, allowBlank: false*/},
	    	{name: 'EDU_FR_DATE'				,text:'<t:message code="system.label.human.edufromdate1" default="교육시작일"/>'	,type:'uniDate' , allowBlank: false},
	    	{name: 'EDU_TO_DATE'				,text:'<t:message code="system.label.human.edutodate1" default="교육종료일"/>'		,type:'uniDate' , allowBlank: false},
	    	{name: 'EDU_TIME'					,text:'<t:message code="system.label.human.edutime" default="교육시간"/>'			,type:'string' , allowBlank: false},
	    	{name: 'EDU_NATION'					,text:'<t:message code="system.label.human.edunation" default="교육국가"/>'		,type:'string' , comboType: 'AU', comboCode:'B012'},
	    	{name: 'EDU_ORGAN'					,text:'<t:message code="system.label.human.eduorgan" default="교육기관"/>'			,type:'string'},
	    	{name: 'EDU_AMT'					,text:'<t:message code="system.label.human.eduusei" default="교육비"/>'			,type:'uniPrice' },
	    	{name: 'COST_POOL_CODE'				,text:'<t:message code="system.label.human.accountcode" default="회계코드"/>'		,type:'string', store: Ext.data.StoreManager.lookup('getHumanCostPool'),editable:true },  //추가
	    	{name: 'COST_POOL_NAME'				,text:'<t:message code="system.label.human.accpuntname" default="회계명"/>'		,type:'string', editable:false },  
	    	{name: 'SDC_ACD_YN'					,text:'<t:message code="system.label.human.sdcacdyn" default="SDC아카데미여부"/>'	,type:'string' ,comboType: 'AU', comboCode:'A020'},  
	    	{name: 'LAW_EDU_YN'					,text:'<t:message code="system.label.human.laweduyn" default="법정의무교육여부"/>'	,type:'string' ,comboType: 'AU', comboCode:'A020'},  
//	    	{name: 'REPORT_YN'					,text:'교육결과보고서'	,type:'string' , store: Ext.data.StoreManager.lookup('hum304ukrReportYNStore')},
	    	{name: 'REPORT_YN'					,text:'<t:message code="system.label.human.reportyn1" default="교육결과보고서"/>'	,type:'string' ,comboType: 'AU', comboCode:'A020'},
	    	{name: 'REMARK'                     ,text:'<t:message code="system.label.human.remark" default="비고"/>'             ,type:'string' },
            {name: 'EDU_BASIS_NUM'              ,text:'<t:message code="system.label.human.edubasisnum" default="대사우교육실적근거번호"/>'    ,type:'string' , editable:false},
            {name: 'DRAFT_DATE'                 ,text:'<t:message code="system.label.human.approvaldate" default="승인일"/>'      ,type:'string' , editable:false},
            {name: 'DRAFT_STATUS'               ,text:'결재상태'            														,type:'string',comboType: 'AU', comboCode:'HE03'},
            {name: 'CHOICE'						,text:'선택'																		,type:'bool'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hum304ukrMasterStore',{
			model: 'hum304ukrModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            proxy: directProxy							
			,loadStoreRecords : function()	{
				var param= panelResult.getValues();
				if(param.DEPTS instanceof Array)
					param.DEPT_LIST = param.DEPTS.join('|');
				else
					param.DEPT_LIST = param.DEPTS.split(',').join('|');
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
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
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
                xtype: 'radiogroup',
                fieldLabel: '<t:message code="system.label.base.status" default="상태"/>',
                id:'rdoDraftStatus',
                items: [{
                    boxLabel : '전체', 
                    width: 70,
                    name: 'DRAFT_STATUS',
                    inputValue: '',
                    checked: true
                    
                },{
                    boxLabel : '미승인', 
                    width: 70,
                    name: 'DRAFT_STATUS',
                    inputValue: '0'//,
                    //checked: true
                    
                },{
                    boxLabel: '승인', 
                    width: 70, 
                    name: 'DRAFT_STATUS',
                    inputValue: '9' 
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },
            {
                fieldLabel: '<t:message code="system.label.human.educlass" default="교육과정"/>',
                name:'EDU_CLASS', 
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'HE81',
                width: 300
            },
            {       
                fieldLabel: '<t:message code="system.label.human.edudate" default="교육기간"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'EDU_FR_DATE',
                endFieldName: 'EDU_TO_DATE',
                startDate: UniDate.get('startOfYear'),
                endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                },
                listeners: {
                }
            },
            {       
                fieldLabel: '<t:message code="system.label.human.approvaldate" default="승인일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'DRAFT_FR_DATE',
                endFieldName: 'DRAFT_TO_DATE',
//                startDate: UniDate.get('startOfYear'),
//                endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                },
                listeners: {
                }
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
                    inputValue: 'A',
                    checked: true
                    
                },{
                    boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>', 
                    width: 70, 
                    name: 'RDO_TYPE',
                    inputValue: 'B' 
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            }
			]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum304ukrGrid1', {
    	region: 'center',
        layout: 'fit',
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
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'refTool',
			text: '<t:message code="system.label.human.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'excelBtn',
					text: '<t:message code="system.label.human.excelrefer" default="엑셀참조"/>',
		        	handler: function() {
			        	openExcelWindow();
			        }
				}]
			})
		}],
        store: directMasterStore,

//        selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: false, toggleOnClick: false,
//            listeners: {  
//                beforeselect : function(grid, selectRecord, index, eOpts ){
//                },
//                deselect:  function(grid, selectRecord, index, eOpts ){
//                }
//            }
//        }),
        
        columns:  [  
        		{ dataIndex: 'CHOICE'						, width: 60, xtype:'checkcolumn',
        			listeners:{
                		beforecheckchange:function()	{
                			return true;
                		},
                		checkchange:function(column, rowIndex, checked, record, e, eOpts)	{
                			//alert(checked);
                			var newVal = '';
                			var draftStatus = Ext.getCmp('panelResultForm').getField('rdoDraftStatus').getChecked()[0].inputValue;
                			if(checked) {
                				if(draftStatus == '0')
                					newVal = '9';
                				else
                					newVal = 'C';
                				
                				record.set('DRAFT_STATUS', newVal);
                			}
                			else {
                				var oldVal = record.getModified('DRAFT_STATUS');
                				
                				if((oldVal !== undefined)) {
                					record.set('DRAFT_STATUS', oldVal);
                				}
                			}
                		}
                	}
        		},
        		{ dataIndex: 'DRAFT_STATUS'					, width: 120},
          		{ dataIndex: 'DOC_ID'						, width: 100, hidden:true},
        		{ dataIndex: 'COMP_CODE'					, width: 100, hidden:true},
        		{ dataIndex: 'DIV_CODE'						, width: 120},
        		{ dataIndex: 'DEPT_NAME'					, width: 150},
        		{ dataIndex: 'POST_CODE'					, width: 80},
        		{ dataIndex: 'ABIL_CODE'					, width: 80},
        		{ dataIndex: 'NAME'							, width: 80, 
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
			 								var grdRecord = Ext.getCmp('hum304ukrGrid1').uniOpt.currentRecord;
			  								grdRecord.set('PERSON_NUMB','');
			  								grdRecord.set('NAME','');
			  								
			  								grdRecord.set('DIV_CODE','');
			  								grdRecord.set('DEPT_NAME','');
			  								grdRecord.set('POST_CODE','');			
			  								grdRecord.set('ABIL_CODE','');			
 										}
			 				}
						})
				},
        		{ dataIndex: 'PERSON_NUMB'					, width: 100,
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
										var grdRecord = Ext.getCmp('hum304ukrGrid1').uniOpt.currentRecord;
		  								grdRecord.set('PERSON_NUMB','');
		  								grdRecord.set('NAME','');
		  								
		  								grdRecord.set('DIV_CODE','');
		  								grdRecord.set('DEPT_NAME','');
		  								grdRecord.set('POST_CODE','');			
		  								grdRecord.set('ABIL_CODE','');			
		 							}
		 				}
					})
				},
				{ dataIndex: 'DOC_NUM'					, width: 100},
				{ dataIndex: 'EDU_TITLE'					, width: 250},
				{ dataIndex: 'EDU_CLASS'					, width: 100},
				{ dataIndex: 'EDU_GUBUN1'					, width: 100},
				{ dataIndex: 'EDU_GUBUN2'					, width: 100},
				{ dataIndex: 'EDU_GUBUN3'					, width: 100},
        		{ dataIndex: 'EDU_FR_DATE'					, width: 100},
        		{ dataIndex: 'EDU_TO_DATE'					, width: 100},
        		{ dataIndex: 'EDU_TIME'						, width: 80 , align:'right'},
        		{ dataIndex: 'EDU_NATION'					, width: 100},
        		{ dataIndex: 'EDU_ORGAN'					, width: 120},
        		{ dataIndex: 'EDU_AMT'						, width: 80},
        		{ dataIndex: 'COST_POOL_CODE'				, width: 100},
        		{ dataIndex: 'COST_POOL_NAME'				, width: 100 , hidden:true},
        		{ dataIndex: 'SDC_ACD_YN'					, width: 120, hidden:true},
        		{ dataIndex: 'LAW_EDU_YN'					, width: 120},
        		{ dataIndex: 'REPORT_YN'					, width: 120},
        		{ dataIndex: 'REMARK'						, width: 120},

        		{dataIndex: 'EDU_BASIS_NUM'      , width: 220 , hidden:true},
                {dataIndex: 'DRAFT_DATE'         , width: 100 } //, hidden:true}
        		
        		
        	],
        	listeners: {
	    		beforeedit: function( editor, e, eOpts ) {
		        	/*if(e.record.phantom == true) {		// 신규일 때
		        		if(UniUtils.indexOf(e.field, ['OCCUR_DATE'])) {
							return false;
						}
		        	}*/
		        	if(!e.record.phantom == true) { // 신규가 아닐 때
//		        		if(UniUtils.indexOf(e.field, ['NAME', 'PERSON_NUMB' ,'EDU_TITLE','EDU_TITLE' ,'EDU_FR_DATE', 'EDU_TIME' ])) {
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
		id  : 'hum304ukrApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			if(!Ext.isEmpty(gsCostPool)){
			 }
			
			
//			panelResult.setValue('EDU_FR_DATE',UniDate.get('startOfYear'));
			panelResult.setValue('EDU_FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('EDU_TO_DATE',UniDate.get('today'));
			
//			panelResult.setValue('DRAFT_FR_DATE',UniDate.get('startOfYear'));
//			panelResult.setValue('DRAFT_FR_DATE','20170101');
//          panelResult.setValue('DRAFT_TO_DATE',UniDate.get('today'));
			
			
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
			panelResult.clearForm();
			masterGrid.getStore().loadData({});

			this.fnInitBinding();
		},
		onSaveDataButtonDown: function (config) {
			directMasterStore.saveStore(config);
		},
		onDeleteDataButtonDown : function()	{
			
			var selRow = masterGrid.getSelectedRecord();
			
			if (selRow.get("DRAFT_STATUS") == '9' || selRow.get("DRAFT_STATUS") == '8'){
				alert('결재처리가 완료된 교육실적은 삭제할 수 없습니다.');
			} else {
				masterGrid.deleteSelectedRow();	
			};				
			
		},   
        fnHumanCheck: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			grdRecord.set('PERSON_NUMB', record.PERSON_NUMB);
			grdRecord.set('NAME', record.NAME);
			grdRecord.set('DIV_CODE', record.SECT_CODE);
			grdRecord.set('DEPT_NAME', record.DEPT_NAME);
			grdRecord.set('POST_CODE', record.POST_CODE);
			grdRecord.set('ABIL_CODE', record.ABIL_CODE);
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
				case "DRAFT_FR_DATE" : // 승인일자 시작일
                    if( 18891231 > UniDate.getDbDateStr(newValue) ){
                        rv='<t:message code="system.message.human.message023" default="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다."/>';
                        break;
                    }
                    if ( UniDate.getDbDateStr(newValue) > 30000101){
                        rv='<t:message code="system.message.human.message023" default="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다."/>';
                        break;
                    }
                    break;
                
                case "DRAFT_TO_DATE" : // 승인일자 종료일
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
