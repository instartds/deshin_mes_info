<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum760ukr"  >
	<t:ExtComboStore comboType="BOR120"	pgmId="hum760ukr"/> 			<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="H094" /> 				<!-- 발령코드 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 				<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /> 				<!-- 직책 -->
	<t:ExtComboStore comboType="AU" comboCode="H008" />                 <!--직무구분-->
	<t:ExtComboStore comboType="AU" comboCode="H174" />                 <!--호봉승급기준-->
	<t:ExtComboStore comboType="AU" comboCode="H072" />                 <!--직종-->
	
	<t:ExtComboStore comboType="AU" comboCode="H174" opts='1;2'/>   <!--호봉승급기준 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" opts='0;1;4'/>   <!--사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H096" />                <!-- 상벌종류 -->
	 
	<t:ExtComboStore items="${COMBO_HUMAN_COST_POOL}" storeId="getHumanCostPool" />	<!--사업명-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var excelWindow;	// 엑셀참조

function appMain() {
	
	var editWindow; // 자동승급발령
	var gsCostPool = '${CostPool}';  // H175 subCode 10의 Y/N 에 따라 값이 바뀜
	
	// 엑셀참조
	Unilite.Excel.defineModel('excel.hum760.sheet01', {
	    fields: [
	    	{name: 'DIV_CODE'                ,text: '사업장'           ,type: 'string', editable: false, comboType: 'BOR120'},
            {name: 'PERSON_NUMB'             ,text: '사번'             ,type: 'string', allowBlank: false},
            {name: 'NAME'                    ,text: '성명'             ,type: 'string', editable: false},
            {name: 'ANNOUNCE_DATE'           ,text: '발령일자'           ,type: 'uniDate', allowBlank: false},
            {name: 'MAX_ANNOUNCE_DATE'       ,text: 'MAX발령일자'       ,type:'uniDate'},
            {name: 'ANNOUNCE_CODE'           ,text: '발령코드'           ,type: 'string', comboType:'AU',comboCode:'H094', allowBlank: false},
            {name: 'AF_DEPT_CODE'            ,text: '발령 후 부서코드'     ,type: 'string', editable: false},
            {name: 'AF_DEPT_NAME'            ,text: '발령 후 부서명'      ,type: 'string', editable: false},
            {name: 'POST_CODE'               ,text: '직위'            ,type: 'string',  comboType:'AU',comboCode:'H005'},            
            {name: 'ABIL_CODE'               ,text: '직책'            ,type: 'string', comboType:'AU',comboCode:'H006'},
            {name: 'KNOC'                    ,text: '직종'         ,type: 'string', comboType:'AU',comboCode:'H072'},       //직종추가
            {name: 'YEAR_GRADE'              ,text: '근속호봉'         ,type: 'string'},
            {name: 'YEAR_GRADE_BASE'         ,text: '승급기준(근속)'           ,type: 'string', comboType:'AU',comboCode:'H174'},
            {name: 'PAY_GRADE_01'            ,text: '직급'            ,type: 'string'},
            {name: 'PAY_GRADE_02'            ,text: '호봉'            ,type: 'string'},
            {name: 'PAY_GRADE_BASE'          ,text: '승급기준(호봉)'           ,type: 'string', comboType:'AU',comboCode:'H174'},
            {name: 'COST_KIND'               ,text: '회계부서'           ,type: 'string', store: Ext.data.StoreManager.lookup('getHumanCostPool')},
            {name: 'TEMPC_01'                ,text: '담당업무'           ,type: 'string', comboType:'AU',comboCode:'H008'},
            {name: 'TEMPC_02'                ,text: '비고'              ,type: 'string'}
		]
	});
	
	function openExcelWindow() {
		
			var me = this;
	        var vParam = {};
	        var appName = 'Unilite.com.excel.ExcelUpload';
            if(!excelWindow) {
            	excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
                		modal: false,
                		excelConfigName: 'hum760ukr',
                        extParam: { 
                            'PGM_ID'    : 'hum760ukr'
                        },
                        grids: [{
                        		itemId: 'grid01',
                        		title: '발령등록(인사발령등록)양식',                        		
                        		useCheckbox: false,
                        		model : 'excel.hum760.sheet01',
                        		readApi: 'hum760ukrService.selectExcelUploadSheet1',
                        		columns: [        
									{dataIndex: 'DIV_CODE'                , width: 100}, 	
									{dataIndex: 'PERSON_NUMB'             , width: 100}, 	
									{dataIndex: 'NAME'                    , width: 100}, 	
									{dataIndex: 'ANNOUNCE_DATE'           , width: 100}, 	
									{dataIndex: 'MAX_ANNOUNCE_DATE'       , width: 100, hidden: true},
									{dataIndex: 'ANNOUNCE_CODE'           , width: 100},
                                    {dataIndex: 'AF_DEPT_CODE'            , width: 100, hidden: true},	
									{dataIndex: 'AF_DEPT_NAME'            , width: 100}, 	
									{dataIndex: 'POST_CODE'               , width: 100}, 	
									{dataIndex: 'ABIL_CODE'               , width: 100},//, hidden: true}, 	
									{dataIndex: 'KNOC'                     , width: 100}, //직종 	
									{dataIndex: 'YEAR_GRADE'              , width: 100}, 	
									{dataIndex: 'YEAR_GRADE_BASE'         , width: 100}, 	
									{dataIndex: 'PAY_GRADE_01'            , width: 100}, 	
									{dataIndex: 'PAY_GRADE_02'            , width: 100}, 	
									{dataIndex: 'PAY_GRADE_BASE'          , width: 100},
									{dataIndex: 'COST_KIND'               , width: 100},  
                                    {dataIndex: 'TEMPC_01'                , width: 100},
                                    {dataIndex: 'TEMPC_02'                , width: 100}
//                                    ,
//									{dataIndex: 'UPDATE_DB_USER'	      , width: 0, hidden: true}, 				
//									{dataIndex: 'UPDATE_DB_TIME'	      , width: 0, hidden: true}									
								]
                        }],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
                        },
                        onApply:function()	{
							excelWindow.getEl().mask('로딩중...','loading-indicator');		// 엑셀업로드 최신로직
                        	var me = this;
                        	var grid = this.down('#grid01');
                			var records = grid.getStore().getAt(0);	
                			if(Ext.isEmpty(records)) {
                				excelWindow.getEl().unmask();
                                return false;
                			}
				        	var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
							hum760ukrService.selectExcelUploadApply(param, function(provider, response){
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
        	read : 'hum760ukrService.selectList',
        	update: 'hum760ukrService.updateDetail',
			create: 'hum760ukrService.insertDetail',
			destroy: 'hum760ukrService.deleteDetail',
			syncAll: 'hum760ukrService.saveAll'
        }
	});
	
	var directHum100tProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'hum760ukrService.insertHum100tDetail',
            syncAll: 'hum760ukrService.saveHum100t'
        }
    });
	
	var ReportYNStore = Unilite.createStore('hum760ukrReportYNStore', {  // 그리드 상 Report 제출여부 Y : 1 , N : 2  
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
	Unilite.defineModel('hum760ukrModel', {
	    fields: [        
            {name: 'DIV_CODE'                ,text: '사업장'            ,type: 'string', editable: false, comboType: 'BOR120'},
            {name: 'PERSON_NUMB'             ,text: '사번'             ,type: 'string', allowBlank: false},
            {name: 'NAME'                    ,text: '성명'             ,type: 'string'/*, editable: false*/},
            {name: 'ANNOUNCE_DATE'           ,text: '발령일자'           ,type: 'uniDate', allowBlank: false},
            {name: 'MAX_ANNOUNCE_DATE'       ,text: 'MAX발령일자'        ,type:'uniDate'},
            {name: 'ANNOUNCE_CODE'           ,text: '발령코드'           ,type: 'string', comboType:'AU',comboCode:'H094', allowBlank: false},
            {name: 'AF_DEPT_CODE'            ,text: '발령 후 부서코드'       ,type: 'string', editable: false},
            {name: 'AF_DEPT_NAME'            ,text: '발령 후 부서명'        ,type: 'string', editable: false},
            {name: 'POST_CODE'               ,text: '직위'             ,type: 'string',  comboType:'AU',comboCode:'H005'},            
            {name: 'ABIL_CODE'               ,text: '직책'             ,type: 'string', comboType:'AU',comboCode:'H006'},
            {name: 'KNOC'                    ,text: '직종'           ,type: 'string', comboType:'AU',comboCode:'H072'},
            {name: 'YEAR_GRADE'              ,text: '근속호봉'           ,type: 'string'},
            {name: 'YEAR_GRADE_BASE'         ,text: '승급기준(근속)'           ,type: 'string', comboType:'AU',comboCode:'H174'},
            {name: 'PAY_GRADE_01'            ,text: '직급'             ,type: 'string'},
            {name: 'PAY_GRADE_02'            ,text: '호봉'             ,type: 'string'},
            {name: 'PAY_GRADE_BASE'          ,text: '승급기준(호봉)'           ,type: 'string', comboType:'AU',comboCode:'H174'},
            {name: 'COST_KIND'               ,text: '회계부서'           ,type: 'string', store: Ext.data.StoreManager.lookup('getHumanCostPool')},
            {name: 'TEMPC_01'                ,text: '담당업무'           ,type: 'string', comboType:'AU',comboCode:'H008'},
            {name: 'TEMPC_02'                ,text: '비고'             ,type: 'string'}
            
        ]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hum760ukrMasterStore',{
			model: 'hum760ukrModel',
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
				
				var paramMaster= panelResult.getValues();	//syncAll 수정				
    			if(inValidRecs.length == 0 )	{
    				config = {
    					params: [paramMaster],
						success: function(batch, option) {		
							var saveHum100Tlist = masterGrid.getSelectedRecords();     
							if(saveHum100Tlist.length > 0){
                                Ext.each(saveHum100Tlist, function(record, index) {
                                	record.phantom = true;
                                });
                                directHum100tStore.saveStore();
							}else{
							}
                                directMasterStore.loadStoreRecords();
                            
						 } 
					};	
    				this.syncAllDirect(config);		
    			}else {
    				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
    			}
            }
	});
	
    var directHum100tStore = Unilite.createStore('hum760ukrDirectHum100tStore',{
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결
                editable: true,         // 수정 모드 사용
                deletable:true,         // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: directHum100tProxy,
            saveStore : function()  {               
                var inValidRecs = this.getInvalidRecords();
                console.log("inValidRecords : ", inValidRecs);                
                var toCreate = this.getNewRecords();
                var toUpdate = this.getUpdatedRecords();                 
                var list = [].concat(toUpdate, toCreate);
                console.log("list:", list);
                
                var paramMaster= panelResult.getValues();   //syncAll 수정                
                if(inValidRecs.length == 0 )    {
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
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
    			fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				holdable: 'hold',
				allowBlank:false
    		},
            Unilite.popup('DEPT', {
                fieldLabel: '부서', 
                valueFieldName: 'DEPT_CODE',
                textFieldName: 'DEPT_NAME',
                listeners: {                
                    applyextparam: function(popup){
                    	
                    }
                }
            }),
            Unilite.popup('Employee',{
                fieldLabel: '사원',
                valueFieldName:'PERSON_NUMB',
                textFieldName:'NAME',
                validateBlank:false,
                listeners: {
                    applyextparam: function(popup){ 
                    }
                }
            }), {
                fieldLabel: '발령일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'ANNOUNCE_DATE_FR',
                endFieldName: 'ANNOUNCE_DATE_TO'   
           },{
                fieldLabel: '발령코드',
                name:'ANNOUNCE_CODE', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H094'
            },{
                fieldLabel: '회계부서',
                xtype: 'uniCombobox',
                name:'COST_KIND',
                valueWidth: 60, 
                width: 325,
                store: Ext.data.StoreManager.lookup('getHumanCostPool')
            },
            {
            	
                xtype: 'radiogroup',                            
                fieldLabel: '재직구분',
                colspan:1,
                items: [{
                    boxLabel: '전체', 
                    width: 70, 
                    name: 'RDO_TYPE',
                    inputValue: '',
                    checked: true
                },{
                    boxLabel : '재직', 
                    width: 70,
                    name: 'RDO_TYPE',
                    inputValue: 'A'
                    
                },{
                    boxLabel: '퇴사', 
                    width: 70, 
                    name: 'RDO_TYPE',
                    inputValue: 'B' 
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            
            },
            {
                xtype: 'radiogroup',                            
                fieldLabel: '성별',
                colspan:1,
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
                    }
                }
            
            },
            {
                xtype: 'component',
                colspan: 3,
                height: 7
            }, 
            {
                xtype:'label',
                html: '<b>※선택한 Data(최근 발령일자만 선택 가능)는 인사 마스터에 자동 반영됩니다.</b>',
                name: '',
                style: 'font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;',
                padding: '0 0 0 40',
                colspan: 3
            }
            ],
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
						alert(labelText+Msg.sMB083);
			        	invalid.items[0].focus();
			     	} else {
			      		//this.mask();
			      		var fields = this.getForm().getFields();
			      		Ext.each(fields.items, function(item) {
			       			if(Ext.isDefined(item.holdable) ) {
			         			if (item.holdable == 'hold') {
			         				item.setReadOnly(true); 
			        			}
			       			} 
			       			if(item.isPopupField) {
			        			var popupFC = item.up('uniPopupField') ;       
			        			if(popupFC.holdable == 'hold') {
			         				popupFC.setReadOnly(true);
			        			}
			       			}
			      		})
			       	}
			    } else {
			    	//this.unmask();
			       	var fields = this.getForm().getFields();
			     	Ext.each(fields.items, function(item) {
			      		if(Ext.isDefined(item.holdable) ) {
			        		if (item.holdable == 'hold') {
			        			item.setReadOnly(false);
			       			}
			      		} 
			      		if(item.isPopupField) {
			       			var popupFC = item.up('uniPopupField') ; 
			       			if(popupFC.holdable == 'hold' ) {
			        			item.setReadOnly(false);
			      			}
			      		}
			     	})
			    }
			    return r;
			},
			setLoadRecord: function(record) {
				var me = this;   
			   	me.uniOpt.inLoading=false;
			    me.setAllFieldsReadOnly(true);
			}
	});
	
	//자동승급발령
    var editForm = Unilite.createSearchForm('gop200ukrvDetailForm', {
        layout: {type: 'uniTable', columns : 2},
        defaults:{
            labelWidth:80,
            width:240
        },
        defaultType:'textfield',
        items: [
            {
                xtype:'container',
                html: '<font color=blue size=5><b>&nbsp;&nbsp;&nbsp;◆&nbsp;자&nbsp;동&nbsp;승&nbsp;급&nbsp;발&nbsp;령&nbsp;관&nbsp;리&nbsp;</b></font>',
                colspan     : 2
            },
            {
                xtype:'container',
                html: '<font color=red size=2><b>&nbsp;</b></font>',
                colspan     : 2
            },
    
            {
                fieldLabel: '호봉승급기준',
                name: 'PAY_GRADE_BASE',
                xtype: 'uniCombobox',
                margin: '0 0 5 10',
                value: '1',
                
                comboType:'AU',
                comboCode:'H174',
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    	
                    	if(newValue == '1'){
                            editForm.setValue('ANNOUNCE', (new Date().getFullYear() + 1) + '0101'); 
                    	}else if (newValue == '2'){
                    	    editForm.setValue('AUTO_GRD_DT', new Date().getFullYear() + '0701');
                    		
                    	}
                    	
                    }
                }
             },
             {
                name: 'AUTO_GRD_DT',
                width:100,
                margin: '0 0 5 10',
                readOnly: true,
                listeners: {
                }
            },

             {
                fieldLabel: '사원구분',
                name:'MERITS_PAY_GUBUN', 
                xtype: 'uniCombobox',
                margin: '0 0 5 10',
                comboType:'AU',
                comboCode:'H024',
                allowBlank:false,
                value:'0',
                colspan     : 2
             },
             
             {
                xtype: 'radiogroup',                            
                fieldLabel: '휴직자 포함',
                margin: '0 0 5 10',
                colspan:2,
                items: [{
                    boxLabel: '한다', 
                    width: 80, 
                    name: 'RDO_TYPE1',
                    inputValue: '1'
                },{
                    boxLabel : '안한다', 
                    width: 80,
                    name: 'RDO_TYPE1',
                    inputValue: '2',
                    checked: true
                    
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            
            },
             {
                xtype: 'radiogroup',                            
                fieldLabel: '징계처분 포함',
                margin: '0 0 5 10',
                colspan:2,
                items: [{
                    boxLabel: '한다', 
                    width: 80, 
                    name: 'RDO_TYPE2',
                    inputValue: '1'
                    
                },{
                    boxLabel : '안한다', 
                    width: 80,
                    name: 'RDO_TYPE2',
                    inputValue: '2',
                    checked: true
                    
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            
            },
             {
                
                xtype: 'radiogroup',                            
                fieldLabel: '감봉 포함',
                margin: '0 0 5 10',
                colspan:2,
                items: [{
                    boxLabel: '한다', 
                    width: 80, 
                    name: 'RDO_TYPE3',
                    inputValue: '1'
                    
                },{
                    boxLabel : '안한다', 
                    width: 80,
                    name: 'RDO_TYPE3',
                    inputValue: '2',
                    checked: true
                    
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            
            },
             {
                
                xtype: 'radiogroup',                            
                fieldLabel: '정직 포함',
                margin: '0 0 5 10',
                colspan:2,
                items: [{
                    boxLabel: '한다', 
                    width: 80, 
                    name: 'RDO_TYPE4',
                    inputValue: '1'
                },{
                    boxLabel : '안한다', 
                    width: 80,
                    name: 'RDO_TYPE4',
                    inputValue: '2',
                    checked: true
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            
            },
             {
                
                xtype: 'radiogroup',                            
                fieldLabel: '직위해제 포함',
                margin: '0 0 5 10',
                colspan:2,
                items: [{
                    boxLabel: '한다', 
                    width: 80, 
                    name: 'RDO_TYPE5',
                    inputValue: '1'
                    
                },{
                    boxLabel : '안한다', 
                    width: 80,
                    name: 'RDO_TYPE5',
                    inputValue: '2',
                    checked: true
                    
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            
            },

            {
            
                fieldLabel: '계산',
                xtype: 'button',
                text: '자동승급대상자 반영',
                width: 150,
                margin: '5 0 5 120',
                name: 'CALC_BTN',
                handler: function() {
                    
                    var param = editForm.getValues();
                        hum760ukrService.selectAutoGrade(param, function(provider, response){
                            var records = response.result;
                            
                            directMasterStore.insert(0, records);
                            console.log("response",response)
                            editWindow.hide();
                        });

                }
            }
 
        ]
    });
    
    function openWindow() {
        if(!editWindow) {
            editWindow = Ext.create('widget.uniDetailWindow', {
                title: '자동승급발령 POPUP',
                width: 400,                         
                height: 370,
                layout: {type:'box', align:'stretch'},                 
                items: [editForm],
                tbar:  [
                        '->',
                        {
                            itemId : 'closeBtn',
                            text: '닫기',
                            handler: function() {
                                editWindow.hide();
                            }
                        }
                ],
                listeners : {beforehide: function(me, eOpt) {
                                editForm.clearForm();
                                editForm.reset();
                            },
                             beforeclose: function( panel, eOpts )  {
                                editForm.clearForm();
                                editForm.reset();
                            },
                             show: function( panel, eOpts ) {
                                editForm.setValue('PAY_YEARS', '1'); //호봉승급기준
                                editForm.setValue('AUTO_GRD_DT', (new Date().getFullYear() + 1) + '0101'); //호봉승급기준일자
                                editForm.setValue('MERITS_PAY_GUBUN', '0'); //사원구분
                                
                                editWindow.center();
                             }
                }       
            })
        }
        editWindow.show();
    };
	
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum760ukrGrid1', {
    	region: 'center',
        layout: 'fit',
        uniOpt: {
    		expandLastColumn: true,
		 	copiedRow: false,
		 	onLoadSelectFirst: false
        },
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
		},
		{
            itemId:'autoGrade',
            id:'autoGrade',
             text: '자동승급발령',
            disabled:false,
            handler: function() {
               if(directMasterStore.isDirty())  {
                    if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {                       
                        UniAppManager.app.onSaveDataButtonDown();
                        openWindow();
                    }
                    return false;
                }               
                openWindow();
            }
        }
		
		
		],
        store: directMasterStore,
        selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: false,
            listeners: {  
                beforeselect : function(grid, selectRecord, index, eOpts ){
                	var maxDate = UniDate.getDbDateStr(selectRecord.get('MAX_ANNOUNCE_DATE'));
                	var announceDate = UniDate.getDbDateStr(selectRecord.get('ANNOUNCE_DATE'));
                	if(announceDate < maxDate){
//                	   alert('이전 발령일자는 반영할 수 없습니다.');
                	   return false;
                	}
                	selectRecord.set('CHKCNT', 'Y');
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                	selectRecord.set('CHKCNT', 'N');
                }
            }
        }),
        columns: [
                {dataIndex: 'DIV_CODE'               , width: 120/*, hidden: true*/  }, 
                {dataIndex: 'PERSON_NUMB'             , width: 90,
                    'editor' : Unilite.popup('Employee_G',{
                        validateBlank : true,
                        autoPopup:true,
                        listeners: {
                            'onSelected': {
                                fn: function(records, type) {
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);   //사번
                                    grdRecord.set('NAME', records[0].NAME);                 //성명
                                    grdRecord.set('AF_DEPT_CODE', records[0].DEPT_CODE);       //발령전부서코드
                                    grdRecord.set('AF_DEPT_NAME', records[0].DEPT_NAME);       //발령전부서명
                                    grdRecord.set('POST_CODE', records[0].POST_CODE);       //발령후 직위명
                                    grdRecord.set('ABIL_CODE', records[0].ABIL_CODE);       //발령후 직책
                                    grdRecord.set('KNOC', records[0].KNOC);       //발령후 직종
                                    grdRecord.set('PAY_GRADE_01', records[0].PAY_GRADE_01);       //현직급
                                    grdRecord.set('PAY_GRADE_02', records[0].PAY_GRADE_02);       //현호봉
                                    grdRecord.set('COST_KIND', records[0].COST_KIND);       //현회계부서
                                    grdRecord.set('TEMPC_01', records[0].JOB_CODE);       //현회계부서
                                    grdRecord.set('YEAR_GRADE', records[0].YEAR_GRADE);       //근속년(근속호봉)
                                    grdRecord.set('PAY_GRADE_BASE', records[0].PAY_GRADE_BASE);       //승급기준(호봉)
                                    grdRecord.set('YEAR_GRADE_BASE', records[0].YEAR_GRADE_BASE);       //승급기준(근속)
                                    
                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('PERSON_NUMB','');
                                grdRecord.set('NAME','');
                                grdRecord.set('AF_DEPT_CODE', '');       //발령전부서코드
                                grdRecord.set('AF_DEPT_NAME', '');       //발령전부서명
                                grdRecord.set('POST_CODE', '');
                                grdRecord.set('ABIL_CODE', '');       //발령후 직책
                                grdRecord.set('KNOC', '');       //발령후 직종
                                grdRecord.set('PAY_GRADE_01', '');       //현직급
                                grdRecord.set('PAY_GRADE_02', '');       //현호봉
                                grdRecord.set('COST_KIND', '');       //현회계부서
                                grdRecord.set('TEMPC_01', '');       //현담당업무
                                grdRecord.set('YEAR_GRADE', '');       //근속년(근속호봉)
                                grdRecord.set('PAY_GRADE_BASE', '');       //승급기준(호봉)
                                grdRecord.set('YEAR_GRADE_BASE', '');       //승급기준(근속)
                            },
                            applyextparam: function(popup){ 
                            }
                        }
                    })
                }, 
                {dataIndex: 'NAME'                    , width: 80  ,
                'editor' : Unilite.popup('Employee_G',{
                        validateBlank : true,
                        autoPopup:true,
                        listeners: {
                            'onSelected': {
                                fn: function(records, type) {
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);   //사번
                                    grdRecord.set('NAME', records[0].NAME);                 //성명
                                    grdRecord.set('AF_DEPT_CODE', records[0].DEPT_CODE);       //발령전부서코드
                                    grdRecord.set('AF_DEPT_NAME', records[0].DEPT_NAME);       //발령전부서명
                                    grdRecord.set('POST_CODE', records[0].POST_CODE);       //발령후 직위명
                                    grdRecord.set('ABIL_CODE', records[0].ABIL_CODE);       //발령후 직책
                                    grdRecord.set('KNOC', records[0].KNOC);       //발령후 직종
                                    grdRecord.set('PAY_GRADE_01', records[0].PAY_GRADE_01);       //현직급
                                    grdRecord.set('PAY_GRADE_02', records[0].PAY_GRADE_02);       //현호봉
                                    grdRecord.set('COST_KIND', records[0].COST_KIND);       //현회계부서
                                    grdRecord.set('TEMPC_01', records[0].JOB_CODE);       //현회계부서
                                    grdRecord.set('YEAR_GRADE', records[0].YEAR_GRADE);       //근속년(근속호봉)
                                    grdRecord.set('PAY_GRADE_BASE', records[0].PAY_GRADE_BASE);       //승급기준(호봉)
                                    grdRecord.set('YEAR_GRADE_BASE', records[0].YEAR_GRADE_BASE);       //승급기준(근속)                                  
                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('PERSON_NUMB','');
                                grdRecord.set('NAME','');
                                grdRecord.set('AF_DEPT_CODE', '');       //발령전부서코드
                                grdRecord.set('AF_DEPT_NAME', '');       //발령전부서명
                                grdRecord.set('POST_CODE', '');
                                grdRecord.set('ABIL_CODE', '');       //발령후 직책
                                grdRecord.set('KNOC', '');       //발령후 직종
                                grdRecord.set('PAY_GRADE_01', '');       //현직급
                                grdRecord.set('PAY_GRADE_02', '');       //현호봉
                                grdRecord.set('COST_KIND', '');       //현회계부서
                                grdRecord.set('TEMPC_01', '');       //현담당업무
                                grdRecord.set('YEAR_GRADE', '');       //근속년(근속호봉)
                                grdRecord.set('PAY_GRADE_BASE', '');       //승급기준(호봉)
                                grdRecord.set('YEAR_GRADE_BASE', '');       //승급기준(근속)
                            },
                            applyextparam: function(popup){ 
                            }
                        }
                    })
                    }, 
                {dataIndex: 'ANNOUNCE_DATE'             , width: 100  }, 
                {dataIndex: 'MAX_ANNOUNCE_DATE'         , width: 100, hidden: true  },
                {dataIndex: 'ANNOUNCE_CODE'             , width: 100  }, 
                {dataIndex: 'AF_DEPT_CODE'              , width: 100, hidden: true  }, 
                {dataIndex: 'AF_DEPT_NAME'              , width: 130,
                    editor:Unilite.popup('DEPT_G',{
                        textFieldName:'DEPT_CODE',
                        DBtextFieldName: 'TREE_CODE',
                        validateBlank : true,
                        autoPopup: true,
                        listeners:{
                            scope:this,
                            onSelected:{
                                fn:function(records, type){
                                    var rtnRecord = masterGrid.uniOpt.currentRecord; 
                                    rtnRecord.set('AF_DEPT_CODE', records[0]["TREE_CODE"]);
                                    rtnRecord.set('AF_DEPT_NAME', records[0]["TREE_NAME"]);                          
                                } 
//                                scope: this
                            },
                            onClear:function(type)  {
                                var rtnRecord = masterGrid.uniOpt.currentRecord; 
                                    
                                rtnRecord.set('AF_DEPT_CODE', '');
                                rtnRecord.set('AF_DEPT_NAME', '');
                            }
                        }
                    })
                }, 
                {dataIndex: 'POST_CODE'                 , width: 100  }, 
                {dataIndex: 'ABIL_CODE'                 , width: 100  }, 
                {dataIndex: 'KNOC'                      , width: 100  }, 
                {dataIndex: 'YEAR_GRADE'                , width: 70  }, 
                {dataIndex: 'YEAR_GRADE_BASE'           , width: 105  },
                {dataIndex: 'PAY_GRADE_01'              , width: 70,
                'editor' : Unilite.popup('PAY_GRADE_G',{
                    validateBlank : true,
                    autoPopup:true,
                    listeners: {'onSelected': {
                                fn: function(records, type) {
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    record = records[0];
                                    grdRecord.set('PAY_GRADE_01', record.PAY_GRADE_01);
                                    grdRecord.set('PAY_GRADE_02', record.PAY_GRADE_02);
                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('PAY_GRADE_01','');
                                grdRecord.set('PAY_GRADE_02','');
                            }
                        }
                    })
                }, 
                {dataIndex: 'PAY_GRADE_02'              , width: 70,
                'editor' : Unilite.popup('PAY_GRADE_G',{
                    validateBlank : true,
                    autoPopup:true,
                    listeners: {'onSelected': {
                                fn: function(records, type) {
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    record = records[0];
                                    grdRecord.set('PAY_GRADE_01', record.PAY_GRADE_01);
                                    grdRecord.set('PAY_GRADE_02', record.PAY_GRADE_02);
                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('PAY_GRADE_01','');
                                grdRecord.set('PAY_GRADE_02','');
                            }
                        }
                    })
                }, 
                {dataIndex: 'PAY_GRADE_BASE'            , width: 105  }, 
                {dataIndex: 'COST_KIND'                 , width: 130  }, 
                {dataIndex: 'TEMPC_01'                  , width: 130  }, 
                {dataIndex: 'TEMPC_02'                  , width: 100  },
                {dataIndex: 'CHK_FLAG'                  , width: 100, hidden: true  }
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
	        		if(UniUtils.indexOf(e.field, ['DIV_CODE'/*, 'DEPT_NAME',*/ /*'POST_CODE2',*/ /*'CODE_CHECK'*/])) {
						return false;
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
		id  : 'hum760ukrApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ANNOUNCE_DATE_TO', UniDate.get('today'));
			panelResult.setValue('ANNOUNCE_DATE_FR', UniDate.get('startOfMonth', panelResult.getValue('ANNOUNCE_DATE_TO')));
			panelResult.setValue('RDO_TYPE', '1');
			
			
			if(!Ext.isEmpty(gsCostPool)){
				panelResult.getField('COST_KIND').setFieldLabel(gsCostPool);  
			}
			var activeSForm ;
			activeSForm = panelResult;
			activeSForm.onLoadSelectText('PERSON_NUMB');
			
			
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
        	var divCode          = panelResult.getValue('DIV_CODE');
        	var r ={
        		COMP_CODE			: compCode,
        		DIV_CODE            : divCode
        	};
            //param = {'SEQ':seq}
//	        masterGrid.createRow(r , 'NAME');
//	        masterGrid.createRow(r , 'DEPT_NAME');
	        masterGrid.createRow(r);
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
