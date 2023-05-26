<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hrt900ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="hrt900ukr"  /> 	<!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="H008" /> 		<!-- 담당업무-->
    <t:ExtComboStore comboType="AU" comboCode="H217" /> 		<!-- 퇴직연금종류-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >


function appMain() {
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read:    'hrt900ukrService.selectList1',
            update:  'hrt900ukrService.updateDetail',
            create:  'hrt900ukrService.insertDetail',
            destroy: 'hrt900ukrService.deleteDetail',
            syncAll: 'hrt900ukrService.saveAll'
        }
    });
    
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read:    'hrt900ukrService.selectList2',
            update:  'hrt900ukrService.updateDetail',
            create:  'hrt900ukrService.insertDetail',
            destroy: 'hrt900ukrService.deleteDetail',
            syncAll: 'hrt900ukrService.saveAll'
        }
    });
	

	Unilite.defineModel('hrt900ukrModel1', {
        fields: [
			 {name: 'COMP_CODE'     		,text: '법인코드'       	,type: 'string'   	,allowBlank: false}
			,{name: 'PERSON_NUMB'   		,text: '사원코드'       	,type: 'string'   	,allowBlank: false} 
			,{name: 'NAME'   				,text: '사원명'       	,type: 'string'   	,allowBlank: false}
            ,{name: 'JOIN_DATE'    			,text: '가입일자'       	,type: 'uniDate'   	}
            
			,{name: 'ANN_KIND'      		,text: '연금종류'       	,type: 'string'  	, comboType:'AU', comboCode:'H217' ,allowBlank: false}
            ,{name: 'SAVING_YEAR'			,text: '적립년도'	      	,type: 'string'		}
			,{name: 'SAVING_AMT'    		,text: '(기)적립금액'      ,type: 'uniPrice' 	}
			,{name: 'EST_TOTAL_AMT'    		,text: '추계총액'       	,type: 'uniPrice'}
			,{name: 'TOTAL_ORI_RETR_ANNU_I' ,text: '퇴직금총액'       	,type: 'uniPrice'}
			,{name: 'BE_CALC_FR_DATE'    	,text: '부터'       		,type: 'uniDate'}
			,{name: 'BE_CALC_TO_DATE'    	,text: '까지 '       		,type: 'uniDate'}
			,{name: 'RETIRE_CALC_FR_DATE'	,text: '부터'       		,type: 'uniDate'}
			,{name: 'RETIRE_CALC_TO_DATE'   ,text: '까지'       		,type: 'uniDate'}
			
			,{name: 'DC_PAY_AMT'    		,text: '금액'       		,type: 'uniPrice'}
			,{name: 'DC_PAY_DATE'    		,text: '일자'       		,type: 'uniDate'}
			,{name: 'QUARTER_1'    			,text: '1/4분기'       	,type: 'uniPrice'}
			,{name: 'QUARTER_2'    			,text: '2/4분기'       	,type: 'uniPrice'}
			,{name: 'QUARTER_3'    			,text: '3/4분기'       	,type: 'uniPrice'}
			,{name: 'QUARTER_4'    			,text: '4/4분기'       	,type: 'uniPrice'}
			
			,{name: 'ACCOUNT_CUSTOM_CODE_1' ,text: '취급자코드'      	,type: 'string'}
			,{name: 'CUSTOM_NAME_1' 		,text: '취급자명'       	,type: 'string'}
			,{name: 'SAVING_START_MONTH_1'  ,text: '적립시작년월'      ,type: 'uniDate'}
			,{name: 'REMARK'                ,text: '비고'       		,type: 'string'}
			
        ]
    });
    
	Unilite.defineModel('hrt900ukrModel2', {
        fields: [
			 {name: 'COMP_CODE'     		,text: '법인코드'       	,type: 'string'   	,allowBlank: false}
			,{name: 'PERSON_NUMB'   		,text: '사원코드'       	,type: 'string'   	,allowBlank: false} 
			,{name: 'NAME'   				,text: '사원명'       	,type: 'string'   	,allowBlank: false}
            ,{name: 'JOIN_DATE'    			,text: '가입일자'       	,type: 'uniDate'   	}
            
			,{name: 'ANN_KIND'      		,text: '연금종류'       	,type: 'string'  	, comboType:'AU', comboCode:'H217' ,allowBlank: false}
            ,{name: 'SAVING_YEAR'			,text: '적립년도'	      	,type: 'string'		}
			,{name: 'SAVING_AMT'    		,text: '(기)적립금액'      ,type: 'uniPrice' 	}
			,{name: 'EST_TOTAL_AMT'    		,text: '추계총액'       	,type: 'uniPrice'}
			,{name: 'TOTAL_ORI_RETR_ANNU_I' ,text: '퇴직금총액'       	,type: 'uniPrice'}
			,{name: 'BE_CALC_FR_DATE'    	,text: '부터'       		,type: 'uniDate'}
			,{name: 'BE_CALC_TO_DATE'    	,text: '까지 '       		,type: 'uniDate'}
			,{name: 'RETIRE_CALC_FR_DATE'	,text: '부터'       		,type: 'uniDate'}
			,{name: 'RETIRE_CALC_TO_DATE'   ,text: '까지'       		,type: 'uniDate'}
			
			,{name: 'DC_PAY_AMT'    		,text: '금액'       		,type: 'uniPrice'}
			,{name: 'DC_PAY_DATE'    		,text: '일자'       		,type: 'uniDate'}
			,{name: 'QUARTER_1'    			,text: '1/4분기'       	,type: 'uniPrice'}
			,{name: 'QUARTER_2'    			,text: '2/4분기'       	,type: 'uniPrice'}
			,{name: 'QUARTER_3'    			,text: '3/4분기'       	,type: 'uniPrice'}
			,{name: 'QUARTER_4'    			,text: '4/4분기'       	,type: 'uniPrice'}
			
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore1 = Unilite.createStore('hrt900ukrStore1', {
        model: 'hrt900ukrModel1',
        uniOpt: {
            isMaster     : true,         // 상위 버튼 연결 
            editable     : true,         // 수정 모드 사용 
            deletable    : true,         // 삭제 가능 여부 
            allDeletable : false,
            useNavi      : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy1,
        saveStore : function(config)    {
            var inValidRecs = this.getInvalidRecords();
            var paramMaster= panelSearch.getValues();   //syncAll 수정
            
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    
                    success: function(batch, option) {
                        panelSearch.getForm().wasDirty = false;
                        panelSearch.resetDirtyStatus();
                        console.log("set was dirty to false");
                        
                        UniAppManager.setToolbarButtons('save', false); 
                        UniAppManager.app.onQueryButtonDown();
                        }
                    
                };
                this.syncAllDirect(config);
            } else {
                masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        },
        loadStoreRecords: function() {
            var param = Ext.getCmp('panelSearch').getValues();
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
    
    var directMasterStore2 = Unilite.createStore('hrt900ukrStore2', {
        model: 'hrt900ukrModel2',
        uniOpt: {
            isMaster     : true,         // 상위 버튼 연결 
            editable     : false,         // 수정 모드 사용 
            deletable    : false,         // 삭제 가능 여부 
            allDeletable : false,
            useNavi      : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        saveStore : function(config)    {
            var inValidRecs = this.getInvalidRecords();
            var paramMaster= panelSearch.getValues();   //syncAll 수정
            
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    
                    success: function(batch, option) {
                        panelSearch.getForm().wasDirty = false;
                        panelSearch.resetDirtyStatus();
                        console.log("set was dirty to false");
                        
                        UniAppManager.setToolbarButtons('save', false); 
                        UniAppManager.app.onQueryButtonDown();
                        }
                    
                };
                this.syncAllDirect(config);
            } else {
                masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        },
        loadStoreRecords: function() {
            var param = Ext.getCmp('panelSearch').getValues();
            console.log( param );
            this.load({
                params: param
            });
        },
        groupField: 'PERSON_NUMB'
    }); 
	
	var panelSearch = Unilite.createSearchForm('panelSearch',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        items: [
	        	{	        		
	        		fieldLabel: '조회년도',
	        		xtype: 'uniYearField',
	        		name: 'PAY_YYYY',
                    value: new Date().getFullYear(),
                    allowBlank:false
		        },
/*		        {
	        		fieldLabel: '정산일',
	        		name: 'RETR_DATE',
                    xtype: 'uniDateRangefield',
                    startFieldName : 'FR_DATE',
                    endFieldName   : 'TO_DATE',
                    allowBlank:false
		        },*/
		       	{
		       		fieldLabel: '사업장',
    				xtype : 'uniCombobox',
    				name  : 'DIV_CODE',
    				comboType: 'BOR120'
		        },
		        Unilite.popup('DEPT',{
					fieldLabel: '부서',
					valueFieldName: 'DEPT_CODE',
			    	textFieldName : 'DEPT_NAME',
					validateBlank : false					
				})
				,
				Unilite.popup('Employee',{ 
					fieldLabel: '사원',
					valueFieldName: 'PERSON_NUMB',
					validateBlank: false
				})
	        ]
    });
    
	var masterGrid1 = Unilite.createGrid('hrt900ukrGrid1', {
        title: '년도별 조회',
        layout: 'fit',
        region: 'center',
        store: directMasterStore1,
        selModel:'rowmodel',
        height:300,
        uniOpt: {
            useGroupSummary    : true,
            useLiveSearch      : true,
            useContextMenu     : false,
            useMultipleSorting : true,
            onLoadSelectFirst  : false,
            useRowNumberer     : true,
            expandLastColumn   : true,
            useRowContext      : false,
            state: {
                useState     : true,         
                useStateList : true      
            }
        },
        features: [{
            id: 'masterGrid1SubTotal', 
            ftype: 'uniGroupingsummary', 
            showSummaryRow: true
        },{
            id: 'masterGrid1Total', 
            ftype: 'uniSummary', 
            showSummaryRow: true,
            dock:'bottom'
        }],
        columns: [
            { dataIndex: 'COMP_CODE'   , width:100, hidden:true, align:'center', locked:true},
            { dataIndex: 'PERSON_NUMB' , width:100, locked:true,
    			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.human.subtotal" default="소계"/>', '<t:message code="system.label.human.total" default="총계"/>');
    			},
                     'editor' : Unilite.popup('Employee_G',{
                        validateBlank : true,
                        autoPopup:true,
                        listeners: {
                            'onSelected': {
                                fn: function(records, type) {
                                    var grdRecord = masterGrid1.uniOpt.currentRecord;
                                    grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);   //사번
                                    grdRecord.set('NAME', records[0].NAME);                 //성명

                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                var grdRecord = masterGrid1.uniOpt.currentRecord;
                                grdRecord.set('PERSON_NUMB','');
                                grdRecord.set('NAME','');

                            },
                            applyextparam: function(popup){ 
                            }
                        }
                    })
            },
            { dataIndex: 'NAME' , width:100, locked:true,
                     'editor' : Unilite.popup('Employee_G',{
                        validateBlank : true,
                        autoPopup:true,
                        listeners: {
                            'onSelected': {
                                fn: function(records, type) {
                                    var grdRecord = masterGrid1.uniOpt.currentRecord;
                                    grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);   //사번
                                    grdRecord.set('NAME', records[0].NAME);                 //성명

                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                var grdRecord = masterGrid1.uniOpt.currentRecord;
                                grdRecord.set('PERSON_NUMB','');
                                grdRecord.set('NAME','');

                            },
                            applyextparam: function(popup){ 
                            }
                        }
                    })
            },
            { dataIndex: 'JOIN_DATE'     			, width:100, align:'center', locked:true},
            { dataIndex: 'ANN_KIND'        			, width:120, locked:true},
            { dataIndex: 'SAVING_YEAR'      		, width:100, align:'center'},
            { dataIndex: 'SAVING_AMT'       		, width:120,summaryType: 'sum'},
            { dataIndex: 'EST_TOTAL_AMT'    		, width:120,summaryType: 'sum'},
            { dataIndex: 'TOTAL_ORI_RETR_ANNU_I'    , width:120,summaryType: 'sum'},
            
            {text:'퇴직급여 기정산기간', 
                columns:[
		            { dataIndex: 'BE_CALC_FR_DATE'		, width:100},
		            { dataIndex: 'BE_CALC_TO_DATE'      , width:100}
	        	]
            },
            {text:'퇴직추계액 산출기간', 
                columns:[
		            { dataIndex: 'RETIRE_CALC_FR_DATE'  , width:100},
		            { dataIndex: 'RETIRE_CALC_TO_DATE'  , width:100}
	        	]
            },

            {text:'DC적립액 중도인출', 
                columns:[
		            { dataIndex: 'DC_PAY_AMT'        , width:120 ,summaryType: 'sum',
			              renderer : function(val, metaData, record, rowIndex, colIndex, store, view) {
								if(record.get("ANN_KIND") == "DB"){
									metaData.tdCls = 'x-close-cell_dark';

								}else if(record.get("ANN_KIND") == "DC") {
									metaData.tdCls = 'x-change-cell';
									
								}else if(record.get("ANN_KIND") == "N") {
									metaData.tdCls = 'x-close-cell_dark';
									
									//var grdRecord = detailGrid.uniOpt.currentRecord;
									
									//grdRecord.set('DC_PAY_AMT', '0');
									//var val = '';
									//return val;
									//return Ext.util.Format.number(val, '0,000');
								}
								return Ext.util.Format.number(val, '0,000');
							}
		            },
		            { dataIndex: 'DC_PAY_DATE'       , width:100, 
			            renderer : function(val, metaData, record, rowIndex, colIndex, store, view) {
								if(record.get("ANN_KIND") == "DB"){
									metaData.tdCls = 'x-close-cell_dark';
									//return val;
								}else if(record.get("ANN_KIND") == "DC") {
									metaData.tdCls = 'x-change-cell';
									//if(!Ext.isEmpty(val)){
									//	return UniDate.getDbDateStr(val).substring(0, 4) + '.' + UniDate.getDbDateStr(val).substring(4, 6) + '.' + UniDate.getDbDateStr(val).substring(6, 8);
									//}
								}else if(record.get("ANN_KIND") == "N") {
									metaData.tdCls = 'x-close-cell_dark';
									//return val;
								}
								if(!Ext.isEmpty(val)){
									return UniDate.getDbDateStr(val).substring(0, 4) + '.' + UniDate.getDbDateStr(val).substring(4, 6) + '.' + UniDate.getDbDateStr(val).substring(6, 8);
								}
								
							}	
		            }
	        	]
            },
            {text:'추계액', 
		        columns:[
		            { dataIndex: 'QUARTER_1'        , width:110,summaryType: 'sum', 
			            renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
								if(record.get("ANN_KIND") == "DB"){
									metaData.tdCls = 'x-close-cell_dark';
								}else if(record.get("ANN_KIND") == "DC") {
									metaData.tdCls = 'x-change-cell';
								}else if(record.get("ANN_KIND") == "N") {
									metaData.tdCls = 'x-close-cell_dark';
								}
								return Ext.util.Format.number(val, '0,000');
							}	
		            },
		            { dataIndex: 'QUARTER_2'        , width:110,summaryType: 'sum',
			            renderer : function(val, metaData,record, rowIndex, colIndex, store, view) {
								if(record.get("ANN_KIND") == "DB"){
									metaData.tdCls = 'x-close-cell_dark';
								}else if(record.get("ANN_KIND") == "DC") {
									metaData.tdCls = 'x-change-cell';
								}else if(record.get("ANN_KIND") == "N") {
									metaData.tdCls = 'x-close-cell_dark';
								}
								return Ext.util.Format.number(val, '0,000');
							}	
		            },
		            { dataIndex: 'QUARTER_3'        , width:110,summaryType: 'sum', 
			            renderer : function(val, metaData, record, rowIndex, colIndex, store, view) {
								if(record.get("ANN_KIND") == "DB"){
									metaData.tdCls = 'x-close-cell_dark';
								}else if(record.get("ANN_KIND") == "DC") {
									metaData.tdCls = 'x-change-cell';
								}else if(record.get("ANN_KIND") == "N") {
									metaData.tdCls = 'x-close-cell_dark';
								}
								return Ext.util.Format.number(val, '0,000');
							}	
		            },
		            { dataIndex: 'QUARTER_4'        , width:110,summaryType: 'sum', 
			            renderer : function(val, metaData, record, rowIndex, colIndex, store, view) {
			            	
/*								if(record.get("ANN_KIND") == "DB"){
									metaData.tdCls = 'x-close-cell_dark';
								}else if(record.get("ANN_KIND") == "DC") {
									metaData.tdCls = 'x-change-cell';
								}else if(record.get("ANN_KIND") == "N") {
									metaData.tdCls = 'x-close-cell_dark';
								}
*/
								return Ext.util.Format.number(val, '0,000');
							}	
		            }
	        	]
            },
            {text:'연금계좌', 
		        columns:[
		            { dataIndex: 'ACCOUNT_CUSTOM_CODE_1'       , width:100, 
		            
		                'editor' : Unilite.popup('CUST_G',{
		   	 			autoPopup: true,	
						listeners:{ 
							'onSelected': {
		                    	fn: function(records, type  ){
		                    		var grdRecord = masterGrid1.uniOpt.currentRecord;
									grdRecord.set('ACCOUNT_CUSTOM_CODE_1', records[0]['CUSTOM_CODE']);
									grdRecord.set('CUSTOM_NAME_1', records[0]['CUSTOM_NAME']);
		                    	},
	                    		scope: this
              	   			},
							'onClear' : function(type)	{
								var grdRecord = masterGrid1.uniOpt.currentRecord;
								grdRecord.set('ACCOUNT_CUSTOM_CODE_1', '');
								grdRecord.set('CUSTOM_NAME_1', '');
		                  	},
                            'applyextparam': function(popup){
                                popup.setExtParam({'CUSTOM_TYPE'        : ['4']});
                            }
						}
					}),
		            renderer : function(val, metaData, record, rowIndex, colIndex, store, view) {
							if(record.get("ANN_KIND") == "DB"){
								metaData.tdCls = 'x-close-cell_dark';
							}else if(record.get("ANN_KIND") == "DC") {
								metaData.tdCls = 'x-change-cell';
							}else if(record.get("ANN_KIND") == "N") {
								metaData.tdCls = 'x-close-cell_dark';
							}
							return val;
						}	
		            },
		            
		            { dataIndex: 'CUSTOM_NAME_1'       , width:150, 
		            
		                editor: Unilite.popup('CUST_G',{
		   	 			autoPopup: true,	
						listeners:{ 
							'onSelected': {
		                    	fn: function(records, type  ){
		                    		var grdRecord = masterGrid1.uniOpt.currentRecord;
									grdRecord.set('ACCOUNT_CUSTOM_CODE_1', records[0]['CUSTOM_CODE']);
									grdRecord.set('CUSTOM_NAME_1', records[0]['CUSTOM_NAME']);
		                    	},
	                    		scope: this
              	   			},
							'onClear' : function(type)	{
								var grdRecord = masterGrid1.uniOpt.currentRecord;
								grdRecord.set('ACCOUNT_CUSTOM_CODE_1', '');
								grdRecord.set('CUSTOM_NAME_1', '');
		                  	},
                            'applyextparam': function(popup){
                                popup.setExtParam({'CUSTOM_TYPE'        : ['4']});
                            }
						}
					}),
		            
		            renderer : function(val, metaData, record, rowIndex, colIndex, store, view) {
							if(record.get("ANN_KIND") == "DB"){
								metaData.tdCls = 'x-close-cell_dark';
							}else if(record.get("ANN_KIND") == "DC") {
								metaData.tdCls = 'x-change-cell';
							}else if(record.get("ANN_KIND") == "N") {
								metaData.tdCls = 'x-close-cell_dark';
							}
							return val;
						}	
		            },
		            { dataIndex: 'SAVING_START_MONTH_1'        , width:100,
		            xtype:'uniMonthColumn',
                    editor:{xtype:'uniMonthfield', format: 'Y.m' },
			            renderer : function(val, metaData, record, rowIndex, colIndex, store, view) {
								if(record.get("ANN_KIND") == "DB"){
									metaData.tdCls = 'x-close-cell_dark';
								}else if(record.get("ANN_KIND") == "DC") {
									metaData.tdCls = 'x-change-cell';
									if(!Ext.isEmpty(val)){
										return UniDate.getDbDateStr(val).substring(0, 4) + '.' + UniDate.getDbDateStr(val).substring(4, 6) ;
									}
									
								}else if(record.get("ANN_KIND") == "N") {
									metaData.tdCls = 'x-close-cell_dark';
								}
								//return val;
								if(!Ext.isEmpty(val)){
									return UniDate.getDbDateStr(val).substring(0, 4) + '.' + UniDate.getDbDateStr(val).substring(4, 6) ;
								}
							}	
		            }
	        	]
            },            
            { dataIndex: 'REMARK'        , width:200}
        ],
        
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {       
        		if(e.record.get('ANN_KIND') == "DB" || e.record.get('ANN_KIND') == "N") {
                		
        			if(UniUtils.indexOf(e.field, ['COMP_CODE'])
                	  || UniUtils.indexOf(e.field, ['PERSON_NUMB'])
                	  || UniUtils.indexOf(e.field, ['NAME'])
                	  || UniUtils.indexOf(e.field, ['JOIN_DATE'])
                	  || UniUtils.indexOf(e.field, ['ANN_KIND'])
                	  || UniUtils.indexOf(e.field, ['SAVING_YEAR'])
                	  || UniUtils.indexOf(e.field, ['SAVING_AMT'])
                	  || UniUtils.indexOf(e.field, ['EST_TOTAL_AMT'])
                	  || UniUtils.indexOf(e.field, ['TOTAL_ORI_RETR_ANNU_I'])
                	  || UniUtils.indexOf(e.field, ['BE_CALC_FR_DATE'])
                	  || UniUtils.indexOf(e.field, ['BE_CALC_TO_DATE'])
                	  || UniUtils.indexOf(e.field, ['RETIRE_CALC_FR_DATE'])
                	  || UniUtils.indexOf(e.field, ['RETIRE_CALC_TO_DATE'])
                	  || UniUtils.indexOf(e.field, ['DC_PAY_AMT'])                	  
                	  || UniUtils.indexOf(e.field, ['DC_PAY_DATE'])
                	  || UniUtils.indexOf(e.field, ['QUARTER_1'])
                	  || UniUtils.indexOf(e.field, ['QUARTER_2'])
                	  || UniUtils.indexOf(e.field, ['QUARTER_3'])
                	  || UniUtils.indexOf(e.field, ['QUARTER_4'])
                	  || UniUtils.indexOf(e.field, ['ACCOUNT_CUSTOM_CODE_1'])
                	  || UniUtils.indexOf(e.field, ['CUSTOM_NAME_1'])
                	  || UniUtils.indexOf(e.field, ['SAVING_START_MONTH_1'])
                	  ){
                		return false;
                	}
        		} else {
        			if(UniUtils.indexOf(e.field, ['COMP_CODE'])
                	  || UniUtils.indexOf(e.field, ['PERSON_NUMB'])
                	  || UniUtils.indexOf(e.field, ['NAME'])
                	  || UniUtils.indexOf(e.field, ['JOIN_DATE'])
                	  || UniUtils.indexOf(e.field, ['ANN_KIND'])
                	  || UniUtils.indexOf(e.field, ['SAVING_YEAR'])
                	  || UniUtils.indexOf(e.field, ['SAVING_AMT'])
                	  || UniUtils.indexOf(e.field, ['EST_TOTAL_AMT'])
                	  || UniUtils.indexOf(e.field, ['TOTAL_ORI_RETR_ANNU_I'])
                	  || UniUtils.indexOf(e.field, ['BE_CALC_FR_DATE'])
                	  || UniUtils.indexOf(e.field, ['BE_CALC_TO_DATE'])
                	  || UniUtils.indexOf(e.field, ['RETIRE_CALC_FR_DATE'])
                	  || UniUtils.indexOf(e.field, ['RETIRE_CALC_TO_DATE'])
                	  || UniUtils.indexOf(e.field, ['QUARTER_1'])
                	  || UniUtils.indexOf(e.field, ['QUARTER_2'])
                	  || UniUtils.indexOf(e.field, ['QUARTER_3'])
                	  || UniUtils.indexOf(e.field, ['QUARTER_4'])
                	  ){
                		return false;
                	}
        		}
	                    	
				if(e.record.get('ACCOUNT_CUSTOM_CODE_1') == "") {
            		
            			if(UniUtils.indexOf(e.field, ['SAVING_START_MONTH_1'])){
            				alert("연금계좌1의 취급자를 먼저 입력하십시오.");
                    		return false;
                    	}
            		}
                	
        },
    	viewConfig: {
	        /*getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('ANN_KIND') == 'N') {
					cls = 'x-change-cell_light';
				} else if(record.get('ANN_KIND') == 'DC') { 
					//cls = 'x-change-cell_normal';
					cls = 'x-change-cell_Background_essRow';
				} else if(record.get('ANN_KIND') == 'DB') {
					//cls = 'x-change-cell_dark';
					cls = 'x-close-cell_dark';
				}
				return cls;
	        }*/
	    	} 
        }
    });
    
	var masterGrid2 = Unilite.createGrid('hrt900ukrGrid2', {
        title: '사원별 조회',
        layout: 'fit',
        region: 'center',
        store: directMasterStore2,
        selModel:'rowmodel',
        height:300,
        uniOpt: {
            useGroupSummary    : false,
            useLiveSearch      : true,
            useContextMenu     : false,
            useMultipleSorting : true,
            onLoadSelectFirst  : false,
            useRowNumberer     : true,
            expandLastColumn   : true,
            useRowContext      : false,
            state: {
                useState     : true,         
                useStateList : true      
            }
        },
        features: [{
            id: 'masterGrid2SubTotal', 
            ftype: 'uniGroupingsummary', 
            showSummaryRow: true
        },{
            id: 'masterGrid2Total', 
            ftype: 'uniSummary', 
            showSummaryRow: true
        }],
        columns: [
            { dataIndex: 'COMP_CODE'   , width:100, hidden:true, align:'center', locked:true},
            { dataIndex: 'PERSON_NUMB' , width:100, locked:true,
            
                	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	                    return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.human.subtotal" default="소계"/>', '<t:message code="system.label.human.total" default="총계"/>');
	    			},
	            
                     'editor' : Unilite.popup('Employee_G',{
                        validateBlank : true,
                        autoPopup:true,
                        listeners: {
                            'onSelected': {
                                fn: function(records, type) {
                                    var grdRecord = masterGrid2.uniOpt.currentRecord;
                                    grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);   //사번
                                    grdRecord.set('NAME', records[0].NAME);                 //성명

                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                var grdRecord = masterGrid2.uniOpt.currentRecord;
                                grdRecord.set('PERSON_NUMB','');
                                grdRecord.set('NAME','');

                            },
                            applyextparam: function(popup){ 
                            }
                        }
                    })
            },
            { dataIndex: 'NAME' , width:100, locked:true,
                     'editor' : Unilite.popup('Employee_G',{
                        validateBlank : true,
                        autoPopup:true,
                        listeners: {
                            'onSelected': {
                                fn: function(records, type) {
                                    var grdRecord = masterGrid2.uniOpt.currentRecord;
                                    grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);   //사번
                                    grdRecord.set('NAME', records[0].NAME);                 //성명

                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                var grdRecord = masterGrid2.uniOpt.currentRecord;
                                grdRecord.set('PERSON_NUMB','');
                                grdRecord.set('NAME','');

                            },
                            applyextparam: function(popup){ 
                            }
                        }
                    })
            },
            { dataIndex: 'JOIN_DATE'     			, width:100, align:'center', locked:true},
            { dataIndex: 'ANN_KIND'        			, width:120, locked:true},
            { dataIndex: 'SAVING_YEAR'      		, width:100, align:'center'},
            { dataIndex: 'SAVING_AMT'       		, width:120, width:120 },
            { dataIndex: 'EST_TOTAL_AMT'    		, width:120, width:120 },
            { dataIndex: 'TOTAL_ORI_RETR_ANNU_I'    , width:120, width:120 },
            
            {text:'퇴직급여 기정산기간', 
                columns:[
		            { dataIndex: 'BE_CALC_FR_DATE'		, width:100},
		            { dataIndex: 'BE_CALC_TO_DATE'      , width:100}
	        	]
            },
            {text:'퇴직추계액 산출기간', 
                columns:[
		            { dataIndex: 'RETIRE_CALC_FR_DATE'  , width:100},
		            { dataIndex: 'RETIRE_CALC_TO_DATE'  , width:100}
	        	]
            },

            {text:'DC적립액 중도인출', 
                columns:[
		            { dataIndex: 'DC_PAY_AMT'        , width:120 ,summaryType: 'sum' ,
			              renderer : function(val, metaData, record, rowIndex, colIndex, store, view) {
								if(record.get("ANN_KIND") == "DB"){
									metaData.tdCls = 'x-close-cell_dark';

								}else if(record.get("ANN_KIND") == "DC") {
									metaData.tdCls = 'x-change-cell';
									
								}else if(record.get("ANN_KIND") == "N") {
									metaData.tdCls = 'x-close-cell_dark';
									
									//var grdRecord = detailGrid.uniOpt.currentRecord;
									
									//grdRecord.set('DC_PAY_AMT', '0');
									//var val = '';
									//return val;
									//return Ext.util.Format.number(val, '0,000');
								}
								return Ext.util.Format.number(val, '0,000');
							}
		            },
		            { dataIndex: 'DC_PAY_DATE'       , width:100, 
			            renderer : function(val, metaData, record, rowIndex, colIndex, store, view) {
								if(record.get("ANN_KIND") == "DB"){
									metaData.tdCls = 'x-close-cell_dark';
									//return val;
								}else if(record.get("ANN_KIND") == "DC") {
									metaData.tdCls = 'x-change-cell';
									//if(!Ext.isEmpty(val)){
									//	return UniDate.getDbDateStr(val).substring(0, 4) + '.' + UniDate.getDbDateStr(val).substring(4, 6) + '.' + UniDate.getDbDateStr(val).substring(6, 8);
									//}
								}else if(record.get("ANN_KIND") == "N") {
									metaData.tdCls = 'x-close-cell_dark';
									//return val;
								}
								if(!Ext.isEmpty(val)){
									return UniDate.getDbDateStr(val).substring(0, 4) + '.' + UniDate.getDbDateStr(val).substring(4, 6) + '.' + UniDate.getDbDateStr(val).substring(6, 8);
								}
								
							}	
		            }
	        	]
            },
            {text:'추계액', 
		        columns:[
		            { dataIndex: 'QUARTER_1'        , width:110, summaryType: 'sum',
			            renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
								if(record.get("ANN_KIND") == "DB"){
									metaData.tdCls = 'x-close-cell_dark';
								}else if(record.get("ANN_KIND") == "DC") {
									metaData.tdCls = 'x-change-cell';
								}else if(record.get("ANN_KIND") == "N") {
									metaData.tdCls = 'x-close-cell_dark';
								}
								return Ext.util.Format.number(val, '0,000');
							}	
		            },
		            { dataIndex: 'QUARTER_2'        , width:110, summaryType: 'sum',
			            renderer : function(val, metaData,record, rowIndex, colIndex, store, view) {
								if(record.get("ANN_KIND") == "DB"){
									metaData.tdCls = 'x-close-cell_dark';
								}else if(record.get("ANN_KIND") == "DC") {
									metaData.tdCls = 'x-change-cell';
								}else if(record.get("ANN_KIND") == "N") {
									metaData.tdCls = 'x-close-cell_dark';
								}
								return Ext.util.Format.number(val, '0,000');
							}	
		            },
		            { dataIndex: 'QUARTER_3'        , width:110, summaryType: 'sum',
			            renderer : function(val, metaData, record, rowIndex, colIndex, store, view) {
								if(record.get("ANN_KIND") == "DB"){
									metaData.tdCls = 'x-close-cell_dark';
								}else if(record.get("ANN_KIND") == "DC") {
									metaData.tdCls = 'x-change-cell';
								}else if(record.get("ANN_KIND") == "N") {
									metaData.tdCls = 'x-close-cell_dark';
								}
								return Ext.util.Format.number(val, '0,000');
							}	
		            },
		            { dataIndex: 'QUARTER_4'        , width:110, summaryType: 'sum',
			            renderer : function(val, metaData, record, rowIndex, colIndex, store, view) {
			            	
/*								if(record.get("ANN_KIND") == "DB"){
									metaData.tdCls = 'x-close-cell_dark';
								}else if(record.get("ANN_KIND") == "DC") {
									metaData.tdCls = 'x-change-cell';
								}else if(record.get("ANN_KIND") == "N") {
									metaData.tdCls = 'x-close-cell_dark';
								}
*/
								return Ext.util.Format.number(val, '0,000');
							}	
		            }
	        	]
            }
        ],
        
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {       
        	if(UniUtils.indexOf(e.field, ['COMP_CODE'])
                	  || UniUtils.indexOf(e.field, ['PERSON_NUMB'])
                	  || UniUtils.indexOf(e.field, ['NAME'])
                	  || UniUtils.indexOf(e.field, ['JOIN_DATE'])
                	  || UniUtils.indexOf(e.field, ['ANN_KIND'])
                	  || UniUtils.indexOf(e.field, ['SAVING_YEAR'])
                	  || UniUtils.indexOf(e.field, ['SAVING_AMT'])
                	  || UniUtils.indexOf(e.field, ['EST_TOTAL_AMT'])
                	  || UniUtils.indexOf(e.field, ['TOTAL_ORI_RETR_ANNU_I'])
                	  || UniUtils.indexOf(e.field, ['BE_CALC_FR_DATE'])
                	  || UniUtils.indexOf(e.field, ['BE_CALC_TO_DATE'])
                	  || UniUtils.indexOf(e.field, ['RETIRE_CALC_FR_DATE'])
                	  || UniUtils.indexOf(e.field, ['RETIRE_CALC_TO_DATE'])
                	  || UniUtils.indexOf(e.field, ['DC_PAY_AMT'])                	  
                	  || UniUtils.indexOf(e.field, ['DC_PAY_DATE'])
                	  || UniUtils.indexOf(e.field, ['QUARTER_1'])
                	  || UniUtils.indexOf(e.field, ['QUARTER_2'])
                	  || UniUtils.indexOf(e.field, ['QUARTER_3'])
                	  || UniUtils.indexOf(e.field, ['QUARTER_4'])
                	  ){
                		return false;
                	}	
                	
        },
    	viewConfig: {
	        /*getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('ANN_KIND') == 'N') {
					cls = 'x-change-cell_light';
				} else if(record.get('ANN_KIND') == 'DC') { 
					//cls = 'x-change-cell_normal';
					cls = 'x-change-cell_Background_essRow';
				} else if(record.get('ANN_KIND') == 'DB') {
					//cls = 'x-change-cell_dark';
					cls = 'x-close-cell_dark';
				}
				return cls;
	        }*/
	    	} 
        }
    }); 
    
	var tab = Ext.create('Ext.tab.Panel',{
            region:'center',
            items: [
                masterGrid1,
                masterGrid2
            ],
            listeners: {
             beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{
		    		if(Ext.isObject(oldCard))	{
		    			 if(UniAppManager.app._needSave())	{
		    				if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
								UniAppManager.app.onSaveDataButtonDown();
								this.setActiveTab(oldCard);
							}else {
								var activeTabId = tab.getActiveTab().getId();
                
				                if(activeTabId == 'hrt900ukrGrid1'){
				                    //panelSearch.getField('RETR_DATE').setHidden(true);
				                    //panelSearch.getField('PAY_YYYY').setHidden(false);           
				                }else if(activeTabId == 'hrt900ukrGrid2'){      
				                	//panelSearch.getField('RETR_DATE').setHidden(false);
				                	//panelSearch.getField('PAY_YYYY').setHidden(true);
				                }
							}
		    			 }else {
		    			 	var activeTabId = tab.getActiveTab().getId();
                
			                if(activeTabId == 'hrt900ukrGrid1'){
			                    //panelSearch.getField('RETR_DATE').setHidden(true);
			                    //panelSearch.getField('PAY_YYYY').setHidden(false);           
			                }else if(activeTabId == 'hrt900ukrGrid2'){      
			                	//panelSearch.getField('RETR_DATE').setHidden(false);
			                	//panelSearch.getField('PAY_YYYY').setHidden(true);
			                }
		    			 }
		    		}
		    	},
             tabchange: function(){
                var activeTabId = tab.getActiveTab().getId();
                
                if(activeTabId == 'hrt900ukrGrid1'){
                    //panelSearch.getField('RETR_DATE').setHidden(true);
                    //panelSearch.getField('PAY_YYYY').setHidden(false);           
                }else if(activeTabId == 'hrt900ukrGrid2'){      
                	//panelSearch.getField('RETR_DATE').setHidden(false);
                	//panelSearch.getField('PAY_YYYY').setHidden(true);
                }
                
                UniAppManager.setToolbarButtons(['save'], false);
                UniAppManager.setToolbarButtons(['delete'], false);
             }
         }
        });

    Unilite.Main( {
    	borderItems:[{
            region: 'center',
            //layout: {type: 'vbox', align: 'stretch'},
            layout: 'border',
            border: false,
            autoScroll: true,
            id:'pageAll',
            items: [
            	panelSearch, tab
            ]
        }],
		id  : 'hrt900ukrApp',
		fnInitBinding: function(){
            UniAppManager.app.fnInitInputFields();
			UniAppManager.setToolbarButtons(['save','print'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
            
            //panelSearch.getField('RETR_DATE').setHidden(true);
        	//panelSearch.getField('PAY_YYYY').setHidden(false);
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
//			panelSearch.getField('PAY_GRADE_YYYY').setReadOnly(true);//조회 버튼 클릭 시 기준 년도 버튼 readOnly true
			
			var activeTabId = tab.getActiveTab().getId();
			
			if(activeTabId == 'hrt900ukrGrid1'){				
				directMasterStore1.loadStoreRecords();
				
			} else if(activeTabId == 'hrt900ukrGrid2'){	
				//UniAppManager.setToolbarButtons(['delete'], false);
				directMasterStore2.loadStoreRecords();
				
			}
            //directMasterStore1.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
		
		 	 var compCode = UserInfo.compCode;
		     
        	 var r = {
				COMP_CODE: compCode
				
	        }; 
        	 
			//masterGrid1.createRow(r); 
		},
		onSaveDataButtonDown: function() {
            directMasterStore1.saveStore();
        },
        onDeleteDataButtonDown: function() {
            var selRow = masterGrid1.getSelectedRecord();
            if(!Ext.isEmpty(selRow)){
                if(selRow.phantom === true) {
                    masterGrid1.deleteSelectedRow();
                }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')){
                    masterGrid1.deleteSelectedRow();   
                }
            }
                     
        },
		onResetButtonDown: function() {
			
			var activeTabId = tab.getActiveTab().getId();
			
			if(activeTabId == 'hrt900ukrGrid1'){				
				masterGrid1.reset();
				directMasterStore1.clearData();
				
			} else if(activeTabId == 'hrt900ukrGrid2'){	
				masterGrid2.reset();
				directMasterStore2.clearData();
			}
			
            panelSearch.clearForm();
			UniAppManager.app.fnInitInputFields();
			UniAppManager.setToolbarButtons(['save','delete'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
		},
		fnInitInputFields: function(){
			panelSearch.setValue('PAY_YYYY', new Date().getFullYear());
			//panelSearch.setValue('FR_DATE',  UniDate.get('startOfMonth'));
            //panelSearch.setValue('TO_DATE',  UniDate.get('today'));
            panelSearch.setValue('DIV_CODE', UserInfo.divCode);
		}

	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid1,
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case "ANN_KIND" : 
					if(newValue != 'DC') {
						record.set('DC_PAY_AMT', '0');	//DC적립액 중도인출(금액)
						record.set('DC_PAY_DATE', '');	//DC적립액 중도인출(일자)
						
						record.set('QUARTER_1', '0');	//추계액(1분기)
						record.set('QUARTER_2', '0');	//추계액(2분기)
						record.set('QUARTER_3', '0');	//추계액(3분기)
						record.set('QUARTER_4', '0');	//추계액(4분기)
						
						
						record.set('ACCOUNT_CUSTOM_CODE_1', '');	//연금계좌1(취급자코드)
						record.set('CUSTOM_NAME_1', '');			//연금계좌1(취급자명)
						record.set('SAVING_START_MONTH_1', '');		//연금계좌1(적립시작일)
						break;
					}
					break;
				case "DC_PAY_AMT" :
					var accnt = record.get('TOTAL_ORI_RETR_ANNU_I')		
					
					if(record.get('TOTAL_ORI_RETR_ANNU_I') < newValue) {
						//alert("중도인출금액이 퇴직금총액보다 클 수 없습니다.");
						//record.set('DC_PAY_AMT', 1234);
						rv='<t:message code="" default="중도인출금액이 퇴직금총액보다 클 수 없습니다."/>';
						break;
					}
					break;
					
				case "SAVING_YEAR" :
					if(isNaN(newValue)|| newValue.length > 4){
						rv='<t:message code = "unilite.msg.sMB070"/>';
					}else{
						if(1900 > newValue || newValue > 2999){
							rv='<t:message code = "unilite.msg.sMB069"/>';
						}
					}
					break;
					
				case "SAVING_START_MONTH_1":
					if(record.get("ACCOUNT_CUSTOM_CODE_1") == ""){
						rv = '연금계좌1의 취급자를 먼저 입력하십시오.';
					}
					break;
					
		/*		case "SAVING_START_MONTH_2":
					if(record.get("ACCOUNT_CUSTOM_CODE_2") == ""){
						rv = '연금계좌2의 취급자를 먼저 입력하십시오.';
					}
					break;
					
				case "SAVING_START_MONTH_3":
					if(record.get("ACCOUNT_CUSTOM_CODE_3") == ""){
						rv = '연금계좌3의 취급자를 먼저 입력하십시오.';
					}
					break;
					
				case "SAVING_START_MONTH_4":
					if(record.get("ACCOUNT_CUSTOM_CODE_4") == ""){
						rv = '연금계좌4의 취급자를 먼저 입력하십시오.';
					}
					break;*/
					
			}
			return rv;
		}
	});
	
};

</script>
