<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb950ukr_kocis"  >
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
    <t:ExtComboStore comboType="AU" comboCode="HE24" /> <!-- 월 -->
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
	<t:ExtComboStore items="${COMBO_SAVE_CODE}" storeId="saveCode" /> <!--계좌코드-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >

var SAVE_FLAG = '';

function appMain() {
	
	Unilite.defineModel('afb950ukrModel', {
        fields: [
            {name: 'DOC_NO'             ,text: 'DOC_NO'             ,type: 'string'},
            {name: 'AC_GUBUN'           ,text: 'AC_GUBUN'           ,type: 'string'},
            {name: 'ACCT_NO'            ,text: 'ACCT_NO'            ,type: 'string'},
            {name: 'ACC_YYYY'           ,text: '회계년도'              ,type: 'string'},
            {name: 'ACC_MM'             ,text: '발생월'               ,type: 'string'},
            {name: 'REAL_WON_BAL'       ,text: '은행잔고증명서에 의한 잔액'  ,type: 'uniUnitPrice'},
            {name: 'WON_BAL'            ,text: '출납공무원 지불 한도 잔액'   ,type: 'uniUnitPrice'},
            {name: 'DIFF_AMT'           ,text: '차액'                 ,type: 'uniUnitPrice'},
            {name: 'REMARK'             ,text: '차액내역'              ,type: 'string'}      
        ]
    });
  
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var searchStore = Unilite.createStore('afb950ukrSearchStore', {
        model: 'afb950ukrModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 's_afb950ukrkocisService.selectList'                 
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
            var param = Ext.getCmp('panelResult').getValues();
            
   /*         var startField = panelSearch.getField('AC_DATE_FR');
            var startDateValue = startField.getStartDate();
            var endField = panelSearch.getField('AC_DATE_TO');
            var endDateValue = endField.getEndDate(); 
            
            param.AC_DATE_FR = startDateValue;
            param.AC_DATE_TO = endDateValue;*/
            
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
	
	
	var panelSearch = Unilite.createSearchPanel('panelSearch', {          
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
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',
            items: [{
                xtype: 'uniCombobox',
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '회계구분',
                name: 'AC_GUBUN',
                comboType: 'AU',
                comboCode: 'A390',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_GUBUN', newValue);
                    }
                }
            },{
                xtype: 'uniYearField',
                fieldLabel: '회계년도',
                name: 'ACC_YYYY',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('ACC_YYYY', newValue);
                        
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '발생월',
                name: 'ACC_MM',
                comboType: 'AU',
                comboCode: 'HE24',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('ACC_MM', newValue);
                    }
                }
            }]
        }]
	});
	
	var panelResult = Unilite.createSearchForm('panelResult',{
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DEPT_CODE', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '회계구분',
            name: 'AC_GUBUN',
            comboType: 'AU',
            comboCode: 'A390',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_GUBUN', newValue);
                }
            }
        },
        	
        {
            xtype: 'uniYearField',
            fieldLabel: '회계년도',
            name: 'ACC_YYYY',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('ACC_YYYY', newValue);
                    
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '발생월',
            name: 'ACC_MM',
            comboType: 'AU',
            comboCode: 'HE24',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('ACC_MM', newValue);
                }
            }
        }]
    });
	
	var searchGrid = Unilite.createGrid('afb950ukrGrid', {
//      split:true,
        layout: 'fit',
        region: 'center',
        excelTitle: '관서운영경비잔액내역서',
        height:300,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: false,
            useRowNumberer: true,
            expandLastColumn: true,
            useRowContext: false,
            state: {
                useState: true,         
                useStateList: true      
            }
        },
        features: [{
            id: 'detailGridSubTotal', 
            ftype: 'uniGroupingsummary', 
            showSummaryRow: false
        },{
            id: 'detailGridTotal', 
            ftype: 'uniSummary', 
            showSummaryRow: true,
            dock:'bottom'
        }],
        store: searchStore,
        selModel:'rowmodel',
        columns: [
            { dataIndex: 'DOC_NO'                     ,width:150,hidden:true},
            { dataIndex: 'AC_GUBUN'                   ,width:150,hidden:true},
            { dataIndex: 'ACCT_NO'                    ,width:150,hidden:true},
            { dataIndex: 'ACC_YYYY'                   ,width:80},
            { dataIndex: 'ACC_MM'                     ,width:60},
            { dataIndex: 'REAL_WON_BAL'               ,width:200},
            { dataIndex: 'WON_BAL'                    ,width:200},
            { dataIndex: 'DIFF_AMT'                   ,width:150},
            { dataIndex: 'REMARK'                     ,width:250}
        ],
        listeners: {
            selectionchangerecord:function(selected){
            },
            select: function(grid, selectRecord, index, rowIndex, eOpts ){
                SAVE_FLAG= 'U';
                
                detailForm.clearForm();
                detailForm.getForm().getFields().each(function(field){
                    if (
                        field.name == 'REMARK' 
                    ){
                        field.setReadOnly(false);
                    }else{
                        field.setReadOnly(true);
                    }
                });
                detailForm.down('#calcButton').setDisabled(true);
                
                detailForm.setValue('DOC_NO',selectRecord.get('DOC_NO')); 
                detailForm.setValue('AC_GUBUN',selectRecord.get('AC_GUBUN'));           // 회계구분
                detailForm.setValue('ACC_YYYY',selectRecord.get('ACC_YYYY'));           // 회계년도
                detailForm.setValue('ACC_MM',selectRecord.get('ACC_MM'));               // 발생월
                detailForm.setValue('ACCT_NO',selectRecord.get('ACCT_NO'));             //계좌
                detailForm.setValue('WON_BAL',selectRecord.get('WON_BAL'));             //출납공무원 지불 한도잔액
                detailForm.setValue('REAL_WON_BAL',selectRecord.get('REAL_WON_BAL'));   //은행잔고증명서에 의한 잔액
                detailForm.setValue('DIFF_AMT',selectRecord.get('DIFF_AMT'));           //차액
                detailForm.setValue('REMARK',selectRecord.get('REMARK'));               //차액내역
            }
        }
    });   
	
	
	var detailForm = Unilite.createForm('resultForm',{
        title:'● 예산(수입)결의 수정',
        region: 'center',
        height:240,
//        flex:1,
        layout : {type : 'uniTable', columns : 3
//        trAttrs:{height:'100%'}
//        tableAttrs: {/* style: 'border : 1.5px solid #ced9e7;'*/height:'100%'}
//            tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},//'100%'}
//          tdAttrs: {style: 'border : 1px solid #ced9e7;',width: '100%'}//width: '100%'/*,align : 'left'*/}
    
        },
        padding:'1 1 1 1',
        border:true,
        disabled:false,
//    anchor:'100% 100%',
        tbar:[/*'->',*/{
            xtype:'button',
            itemId:'resetButton',
            text:'초기화',
            handler: function() {
                detailForm.clearForm();
                UniAppManager.app.fnInitInputFieldsDetailForm();
                SAVE_FLAG = 'N';
            }
        },{
            
            xtype:'button',
            itemId:'printButton',
            text:'인쇄',
            handler: function() {
            
            }
        },{
            xtype:'button',
            itemId:'saveButton',
            text:'저장',
            handler: function() {
                
                //필수 체크 관련 확인필요
                if(!detailForm.getInvalidMessage()){
                    return;
                }/*else{
                        
                }*/
                Ext.getCmp('pageAll').getEl().mask('저장 중...','loading-indicator');
                var param = detailForm.getValues();
                param.SAVE_FLAG = SAVE_FLAG;
                detailForm.getForm().submit({
                params : param,
                    success : function(form, action) {
                        detailForm.getForm().wasDirty = false;
                        detailForm.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false);
                        UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
//                            if(SAVE_FLAG == ''){
//                                detailForm.setValue('DOC_NO',action.result.DOC_NO);
//                            }
                        detailForm.setValue('DOC_NO',action.result.DOC_NO);
                        Ext.getCmp('pageAll').getEl().unmask();  
                        UniAppManager.app.onQueryButtonDown();
                        SAVE_FLAG = 'U';
                        
                        detailForm.getForm().getFields().each(function(field){
                            if (
                                field.name == 'REMARK' 
                            ){
                                field.setReadOnly(false);
                            }else{
                                field.setReadOnly(true);
                            }
                        });
                       
                        detailForm.down('#calcButton').setDisabled(true);
                    },
                    failure: function(){
                        Ext.getCmp('pageAll').getEl().unmask();  
                    }
                });
            }
        },{
            xtype:'button',
            itemId:'deleteButton',
            text:'삭제',
            handler: function() {
                if(!Ext.isEmpty(detailForm.getValue('DOC_NO'))){
                    if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        var param = detailForm.getValues();
                        param.SAVE_FLAG = 'D';
                        detailForm.getForm().submit({
                            params : param,
                            success : function(form, action) {
                                detailForm.getForm().wasDirty = false;
                                detailForm.resetDirtyStatus();                                          
        //                      UniAppManager.setToolbarButtons(['delete','save'],false);
                                UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
                                
                                detailForm.clearForm();
                                UniAppManager.app.fnInitInputFieldsDetailForm();
                                searchStore.loadStoreRecords(); 
                                
                                SAVE_FLAG = '';
                                
                            }   
                        });
                    }
                }else{
                    alert('삭제할 데이터가 없습니다.');
                }
            }
        }],
        items: [{
        	xtype: 'uniTextfield',
        	fieldLabel: 'DOC_NO',
        	name: 'DOC_NO',
        	hidden:true,
        	colspan:3
        },{
            xtype: 'uniCombobox',
            fieldLabel: '회계구분',
            labelWidth:120,
            name:'AC_GUBUN',   
            comboType:'AU',
            comboCode:'A390',
            allowBlank:false,
//            tdAttrs: {width:500/*align : 'center'*/},
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    detailForm.setValue('ACCT_NO', '');
                    detailForm.setValue('WON_BAL', '');
                    detailForm.setValue('REAL_WON_BAL', '');
                    detailForm.setValue('DIFF_AMT', '');
                }
            }
        },{
            xtype: 'uniYearField',
            fieldLabel: '회계년도',
            labelWidth:120,
            name: 'ACC_YYYY',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    detailForm.setValue('ACCT_NO', '');
                    detailForm.setValue('WON_BAL', '');
                    detailForm.setValue('REAL_WON_BAL', '');
                    detailForm.setValue('DIFF_AMT', '');
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '발생월',
            name: 'ACC_MM',
            comboType: 'AU',
            comboCode: 'HE24',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                   
                }
            }
        },{
            xtype: 'container',
            layout: {type: 'uniTable', columns: 2},
            padding:'0 0 0 0',
            items: [{
                xtype: 'uniCombobox',
                fieldLabel: '출납공무원 지불</br>한도잔액(계좌)',
                labelWidth:120,
                name: 'ACCT_NO',
                store: Ext.data.StoreManager.lookup('saveCode'),
//                allowBlank:false,
                listeners: {
                	 beforequery:function(queryPlan, eOpts){
                        var store = queryPlan.combo.store;
                            store.clearFilter();
                        store.filterBy(function(record){
                            return record.get('refCode1') == detailForm.getValue('AC_GUBUN');
                        })
                    },
                    collapse:function(field, eOpts){
                        field.getStore().clearFilter();
                    },
                    
                	
                    change: function(field, newValue, oldValue, eOpts) {
                    	if(SAVE_FLAG != 'U'){
                            if(!Ext.isEmpty(detailForm.getValue('ACCT_NO'))){
                        	
                            	if(Ext.isEmpty(detailForm.getValue('AC_GUBUN'))){
                            		alert('회계구분 값을 확인해 주십시오.');
                            		detailForm.setValue('ACCT_NO', '');
                            		return false;
                            	}else if(Ext.isEmpty(detailForm.getValue('ACC_YYYY'))){
                                    alert('회계년도 값을 확인해 주십시오.');
                                    detailForm.setValue('ACCT_NO', '');
                                    return false;
                            	}else{
                            	   	var param = {
                                        "AC_GUBUN": detailForm.getValue('AC_GUBUN'),
                                        "ACC_YYYY": detailForm.getValue('ACC_YYYY'),
                                        "ACCT_NO": detailForm.getValue('ACCT_NO')
                                    };
                                    s_afb950ukrkocisService.fnGetBudgTotI(param, function(provider, response){
                                        if(!Ext.isEmpty(provider)){
                                            detailForm.setValue('WON_BAL',provider.BUDG_TOT_I);
                                        } else{
                                            detailForm.setValue('WON_BAL',0);
                                        }
                                    })
                                    
                                    detailForm.setValue('REAL_WON_BAL', 0);
                                    detailForm.setValue('DIFF_AMT', 0);
                                    
                                }
                            }
                        }
                    }
                }
            },{
                xtype: 'uniNumberfield',
                fieldLabel: '(잔액)',
                name: 'WON_BAL',
                labelWidth:40,
                decimalPrecision: 2,
                allowBlank:false,
                readOnly:true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    	
                    }
                }
            }]
        },{
            
            xtype: 'container',
            layout: {type: 'uniTable', columns: 2},
            padding:'0 0 0 0',
            items: [{
                xtype: 'uniNumberfield',
                fieldLabel: '은행잔고증명서에</br>의한 잔액',
                labelWidth:120,
                name: 'REAL_WON_BAL',
                decimalPrecision: 2,
                allowBlank:false
            /*    ,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    	
                    }
                }*/
            },{
                xtype:'button',
                itemId:'calcButton',
                text:'차액계산',
                handler: function() {
                	if(Ext.isEmpty(detailForm.getValue('WON_BAL'))){
                		alert('출납공무원 지불 한도잔액을 확인해 주십시오.');
                	}else{
                        detailForm.setValue('DIFF_AMT', detailForm.getValue('REAL_WON_BAL') - detailForm.getValue('WON_BAL'));
                	}
                }
            }]
        
        	
        },{
            xtype: 'uniNumberfield',
            fieldLabel: '차액',
            name: 'DIFF_AMT',
            decimalPrecision: 2,
            allowBlank:false
        },{
            xtype: 'textareafield',
            fieldLabel: '차액내역',
            labelWidth:120,
            name: 'REMARK',
            width: 1100,
            height: 100,
            grow: true,
            colspan:3
        }
        
        ],
        api: {
//            load: 's_afb950ukrkocisService.selectForm' ,
            submit: 's_afb950ukrkocisService.syncMaster'   
        },
        listeners : {
            uniOnChange:function( basicForm, dirty, eOpts ) {
                console.log("onDirtyChange");
            /*    if(basicForm.isDirty()) {
                    if(requestFlag == 'Y'){
                        UniAppManager.setToolbarButtons('save', false);
                    }else{ 
                        UniAppManager.setToolbarButtons('save', true);
                    }
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }*/
            }
        }
    });
	
	
	
	
	
	
	
	
	
	
	
    
    
    Unilite.Main( {
		/*borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			id:'pageAll',
			items:[
				detailForm, subForm1, subForm2, detailGrid
			]	
		}],*/
    	borderItems:[{
            region: 'center',
            layout: {type: 'vbox', align: 'stretch'},
            border: false,
            autoScroll: true,
            id:'pageAll',
            
            items: [panelResult, searchGrid, detailForm]
     /*       items: [{
                region: 'north',
                xtype: 'container',
                layout: {type:'vbox', align: 'stretch'},
                items: [panelResult, searchGrid]
            },{
                region: 'center',
                xtype: 'container',
//                padding:'5 1 1 1',
//                border:true,
//                layout: {type: 'vbox', align: 'stretch'},
                layout:'fit',
                flex:1,
                items:[detailForm]
            }]*/
        },
        panelSearch],
		id  : 'afb950ukrApp',
		fnInitBinding: function(params){
			var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            UniAppManager.app.fnInitInputFields();
            UniAppManager.app.fnInitInputFieldsDetailForm();
//            activeSForm.onLoadSelectText('GL_DATE_FR');   
			
//			this.setDefault(params);
			UniAppManager.setToolbarButtons(['newData','save','print'], false);
            UniAppManager.setToolbarButtons(['reset'/*,'print'*/], true);
            
//            detailForm.onLoadSelectText('RECE_DATE');
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;   //필수체크
            searchStore.loadStoreRecords();
			
	/*
				var param= detailForm.getValues();
				
				detailForm.getForm().load({
					params: param,
					success: function(form, action) {
						
						SAVE_FLAG = action.result.data.SAVE_FLAG;
						
						
//						detailForm.unmask();
						
						
						subForm1.getForm().load({
							params: param,
							success: function(form, action) {
						
//								subForm1.unmask();
						
							},
							failure: function(form, action) {
//								subForm1.unmask();
							}
						})
						
						
						
						if(SAVE_FLAG == 'U'){
							UniAppManager.setToolbarButtons('delete',true);	
						}
						detailForm.getField('RECE_DATE').focus();  
					},
					failure: function(form, action) {
//						detailForm.unmask();
//						subForm1.unmask();
					}
				});
				searchStore.loadStoreRecords();	
				
				UniAppManager.setToolbarButtons('reset',true);
//				panelResult.setAllFieldsReadOnly(true);
				
//			}
				
				*/
		},
/*		onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;	//필수체크
		
//			 var compCode = UserInfo.compCode;
        	 
        	 var r = {
			
//				COMP_CODE: compCode
	        };
			detailGrid.createRow(r);
		},*/
		onResetButtonDown: function() {
//			panelSearch.clearForm();
            panelSearch.clearForm();
            panelResult.clearForm();
			detailForm.clearForm();
			searchGrid.reset();
			searchStore.clearData();
			UniAppManager.app.fnInitInputFields();
            UniAppManager.app.fnInitInputFieldsDetailForm();
			UniAppManager.setToolbarButtons(['newData','save','delete'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
			
			SAVE_FLAG = 'N';
			
		},
		
		/*onDeleteAllButtonDown: function() {			
			var records = directDetailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){		
							detailGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},*/
/*		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('resultForm').getValues();
	         
	         var prgId = '';
	         
	         
//	         if(라디오 값에따라){
//	         	prgId = 'arc100rkr';	
//	         }else if{
//	         	prgId = 'abh221rkr';
//	         }
	         
	         
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/abh/arc100rkrPrint.do',
//	            prgID:prgId,
	            prgID: 'arc100rkr',
	               extParam: {
	                    COMP_CODE:       	param.COMP_CODE       
//						INOUT_SEQ:  	    param.INOUT_SEQ,  	 
//						INOUT_NUM:          param.INOUT_NUM,      
//						DIV_CODE:           param.DIV_CODE, 
//						INOUT_CODE:         param.INOUT_CODE,      
//						INOUT_DATE:         param.INOUT_DATE,      
//						ITEM_CODE:          param.ITEM_CODE,       
//						INOUT_Q:            param.INOUT_Q,         
//						INOUT_P:            param.INOUT_P,         
//						INOUT_I:            param.INOUT_I,
//						INOUT_DATE_FR:      param.INOUT_DATE_FR,      
//						INOUT_DATE_TO:      param.INOUT_DATE_TO  
	               }
	            });
	            win.center();
	            win.show();
	               
	      }*/
		
		fnInitInputFields: function(){
			panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			
			if(!Ext.isEmpty(UserInfo.deptCode)){
				if(UserInfo.deptCode == '01'){
                    panelSearch.getField('DEPT_CODE').setReadOnly(false);
                    panelResult.getField('DEPT_CODE').setReadOnly(false);
                    
                    detailForm.setHidden(true);
				}else{
					panelSearch.getField('DEPT_CODE').setReadOnly(true);
                    panelResult.getField('DEPT_CODE').setReadOnly(true);
                    detailForm.setHidden(false);
				}
			}else{
                panelSearch.getField('DEPT_CODE').setReadOnly(true);
                panelResult.getField('DEPT_CODE').setReadOnly(true);
			}
			
			panelSearch.setValue('ACC_YYYY',new Date().getFullYear());
			panelResult.setValue('ACC_YYYY',new Date().getFullYear());
            panelSearch.setValue('ACC_MM',(new Date().getMonth()+1) < 10 ? '0'+ (new Date().getMonth()+1) : (new Date().getMonth()+1));
            panelResult.setValue('ACC_MM',(new Date().getMonth()+1) < 10 ? '0'+ (new Date().getMonth()+1) : (new Date().getMonth()+1));
//            panelSearch.setValue('ACC_MM_TO',(new Date().getMonth()+1) < 10 ? '0'+ (new Date().getMonth()+1) : (new Date().getMonth()+1));
//            panelResult.setValue('ACC_YYYY',new Date().getFullYear());
//            panelResult.setValue('ACC_MM',(new Date().getMonth()+1) < 10 ? '0'+ (new Date().getMonth()+1) : (new Date().getMonth()+1));
//            panelResult.setValue('ACC_MM_TO',(new Date().getMonth()+1) < 10 ? '0'+ (new Date().getMonth()+1) : (new Date().getMonth()+1));
			
            
		/*	panelSearch.setValue('AC_DATE_FR',UniDate.get('today'));
			panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
			panelResult.setValue('AC_DATE_FR',UniDate.get('today'));
            panelResult.setValue('AC_DATE_TO',UniDate.get('today'));*/
			
			/*
			detailForm.setValue('RECE_DATE',UniDate.get('today'));
			
			detailForm.setValue('DRAFTER',UserInfo.personNumb);
			detailForm.setValue('DRAFTER_NAME',personName);
			
			detailForm.setValue('GW_STATUS','0');*/
		},
		fnInitInputFieldsDetailForm: function(){
			detailForm.setValue('ACC_YYYY',new Date().getFullYear());
            detailForm.setValue('ACC_MM',(new Date().getMonth()+1) < 10 ? '0'+ (new Date().getMonth()+1) : (new Date().getMonth()+1));
			detailForm.getForm().getFields().each(function(field){
                if (
                    field.name == 'WON_BAL' || 
                    field.name == 'DIFF_AMT'
                ){
                    field.setReadOnly(true);
                }else{
                    field.setReadOnly(false);
                }
            });
            
            detailForm.down('#calcButton').setDisabled(false);
		},
		
		onPrintButtonDown: function() {
             //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
            var param = Ext.getCmp('panelResult').getValues();
//    OZPrintWindow
            var win = Ext.create('widget.OZPrintWindow', {
               /* url: CPATH+'/atx/atx550rkrPrint.do',
                prgID: 'atx550rkr',
                extParam: param 
//                    {
//                      COMP_CODE     : UserInfo.compCode,
//                      TERM_DIVI     : param["TERM_DIVI"],
//                      AC_YYYY       : param["AC_YYYY"],
//                      BILL_DIV_CODE : param["BILL_DIV_CODE"]
//                   }
                   */
            	
            /*	loadUserConfigInfo: function() {
                    var me = this;
                    var paramTag = new Array();
             
                     paramTag[paramTag.length] = '<OBJECT id = "OZViewerControl"  CLASSID="CLSID:0DEF32F8-170F-46f8-B1FF-4BF7443F5F25" width = "100%" height = "100%">';
                     paramTag[paramTag.length] = '<param name="viewer.focus_doc_index" value="3">'; 
                     paramTag[paramTag.length] = '<param name="viewer.childcount" value="0">';  
                     paramTag[paramTag.length] = '<param name="viewer.showtree" value="false">'; 
                     paramTag[paramTag.length] = '<param name="print.alldocument" value="true">'; 
                     paramTag[paramTag.length] = '<param name="global.concatpage" value="true">';   
                     paramTag[paramTag.length] = '<param name="connection.servlet" value="http://211.241.199.190:8080/oz70/server">';
                     paramTag[paramTag.length] = '<param name="connection.reportname" value="'+'test'+'.ozr">';
                    // paramTag[paramTag.length] = '<param name="connection.reportname" value="'+<%= request.getParameter("pre") %>+<%= request.getParameter("reportname") %>+'.ozr">';
                     paramTag[paramTag.length] = '<param name="applet.configmode" value="html">';
                     paramTag[paramTag.length] = '<param name="applet.isframe"        value="false">';
                     paramTag[paramTag.length] = '<param name="connection.pcount"     value="1">';
                     paramTag[paramTag.length] = '<param name="connection.args1" value="ciseq=230">';
                     paramTag[paramTag.length] = '<param name="applet.isapplet"       value="false">';
                     paramTag[paramTag.length] = '<param name="odi.odinames" value="'+<%= request.getParameter("reportname") %>+'">'; 
                     paramTag[paramTag.length] = '<param name="odi.REPAIRREQENDVIEW.pcount" value="2">';
                     paramTag[paramTag.length] = '<param name="odi.REPAIRREQENDVIEW.args2" value="owner_name=special">';
                     paramTag[paramTag.length] = '<param name="odi.REPAIRREQENDVIEW.args1" value="args1='+<%= request.getParameter("args1") %>+'">';
                       
                     paramTag[paramTag.length] = '</OBJECT>';
                     me.oz_activex_build(paramTag);
                
                }*/
            });
            win.center();
            win.show();
            
            alert('aaaa');
            
/*             var paramTag = new Array();
 
 paramTag[paramTag.length] = '<OBJECT id = "OZViewerControl"  CLASSID="CLSID:0DEF32F8-170F-46f8-B1FF-4BF7443F5F25" width = "100%" height = "100%">';
 paramTag[paramTag.length] = '<param name="viewer.focus_doc_index" value="3">'; 
 paramTag[paramTag.length] = '<param name="viewer.childcount" value="0">';  
 paramTag[paramTag.length] = '<param name="viewer.showtree" value="false">'; 
 paramTag[paramTag.length] = '<param name="print.alldocument" value="true">'; 
 paramTag[paramTag.length] = '<param name="global.concatpage" value="true">';   
 paramTag[paramTag.length] = '<param name="connection.servlet" value="http://211.241.199.190:8080/oz70/server">';
 paramTag[paramTag.length] = '<param name="connection.reportname" value="'+'test'+'.ozr">';
// paramTag[paramTag.length] = '<param name="connection.reportname" value="'+<%= request.getParameter("pre") %>+<%= request.getParameter("reportname") %>+'.ozr">';
 paramTag[paramTag.length] = '<param name="applet.configmode" value="html">';
 paramTag[paramTag.length] = '<param name="applet.isframe"        value="false">';
 paramTag[paramTag.length] = '<param name="connection.pcount"     value="1">';
 paramTag[paramTag.length] = '<param name="connection.args1" value="ciseq=230">';
 paramTag[paramTag.length] = '<param name="applet.isapplet"       value="false">';
 paramTag[paramTag.length] = '<param name="odi.odinames" value="'+<%= request.getParameter("reportname") %>+'">'; 
 paramTag[paramTag.length] = '<param name="odi.REPAIRREQENDVIEW.pcount" value="2">';
 paramTag[paramTag.length] = '<param name="odi.REPAIRREQENDVIEW.args2" value="owner_name=special">';
 paramTag[paramTag.length] = '<param name="odi.REPAIRREQENDVIEW.args1" value="args1='+<%= request.getParameter("args1") %>+'">';
   
 paramTag[paramTag.length] = '</OBJECT>';
 oz_activex_build(paramTag);
 
 */
        }
	});
/*	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			
			}
				return rv;
						}
			});	*/
/*	Unilite.createValidator('validator02', {
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case fieldName:
//				    if(newValue != lastValidValue){
//					   UniAppManager.setToolbarButtons('save',true);
//				    }
					break;
			}
			return rv;
		}
	});		*/
};

</script>
