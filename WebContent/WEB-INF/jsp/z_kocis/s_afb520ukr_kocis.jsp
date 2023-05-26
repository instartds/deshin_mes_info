<%@page language="java" contentType="text/html; charset=utf-8"%> 
	<t:appConfig pgmId="s_afb520ukr_kocis"  >
	<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A128" /> 		<!-- 예산과목구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" />			<!-- 수지구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A133" />			<!-- 조정구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A134" />         <!-- 결재상태 -->
	
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_afb520ukrkocisService.selectList'
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_afb520ukrkocisService.selectDetailList',
			update: 's_afb520ukrkocisService.updateDetail',
			create: 's_afb520ukrkocisService.insertDetail',
			destroy: 's_afb520ukrkocisService.deleteDetail',
			syncAll: 's_afb520ukrkocisService.saveAll'
		}
	});
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('masterModel', {
	   fields:[
           {name: 'COMP_CODE'               , text: '법인코드'       , type: 'string'},
           {name: 'DEPT_CODE'               , text: '기관'          , type: 'string'},
           {name: 'ACCT_NO'                 , text: '계좌코드'       , type: 'string'},
           {name: 'ACCT_NAME'               , text: '계좌명'       , type: 'string'},
           {name: 'BUDG_CODE'               , text: '예산과목'       , type: 'string'},
           {name: 'BUDG_YYYY'               , text: '예산년도'        , type: 'string'},
           {name: 'BUDG_NAME_1'             , text: '부문'          , type: 'string'},
           {name: 'BUDG_NAME_4'             , text: '세부사업'       , type: 'string'},
           {name: 'BUDG_NAME_6'             , text: '세목'          , type: 'string'},
           {name: 'BUDG_I'                  , text: '조정가능금액'     , type: 'uniUnitPrice'},
           
           {name: 'AC_GUBUN'                , text: '회계구분'     , type: 'string'}
       ]
	});		
	
	Unilite.defineModel('detailModel', {
	   fields: [
	       {name: 'COMP_CODE'                  , text: '법인코드'          , type: 'string'},
	       {name: 'DEPT_CODE'                  , text: '기관'             , type: 'string'},
           {name: 'AP_STS'                     , text: '결재상태'          , type: 'string', comboType: 'AU', comboCode: 'A134'},
           {name: 'ACCT_NO'                    , text: '계좌코드'          , type: 'string'},
	       {name: 'BUDG_YYYYMM'                , text: '예산년월'          , type: 'string', allowBlank: false},
	       {name: 'DIVERT_DIVI'                , text: '조정구분'          , type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'A133'},
           {name: 'DIVERT_YYYYMM'              , text: '조정년월'          , type: 'string', allowBlank: false, maxLength: 6},
           {name: 'BUDG_CODE'                  , text: '세목조정할 예산과목'   , type: 'string', allowBlank: false},
//           {name: 'BUDG_I'                     , text: '조정가능금액'       , type: 'uniPrice', allowBlank: false, maxLength: 30},
           {name: 'DIVERT_BUDG_CODE'           , text: '조정예산과목'       , type: 'string', maxLength: 30, allowBlank: false},
           {name: 'DIVERT_BUDG_NAME'           , text: '조정예산과목명'      , type: 'string', maxLength: 100},
           {name: 'DIVERT_BUDG_I'              , text: '조정금액'          , type: 'uniUnitPrice', allowBlank: false, maxLength: 30},
           {name: 'REMARK'                     , text: '비고'             , type: 'string', maxLength: 50},
           
           {name: 'SEQ'                        , text: 'SEQ'             , type: 'int'},
           {name: 'AC_GUBUN'                   , text: '회계구분'     , type: 'string'},
           {name: 'DOC_NO'                     , text: 'DOC_NO'     , type: 'string'}
              
	    ]
	});
	
	var directMasterStore = Unilite.createStore('masterStore1',{
		model: 'masterModel',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결 
            editable: false,				// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('panelResultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directDetailStore = Unilite.createStore('detailStore1',{
		model: 'detailModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        loadStoreRecords: function(param) {
        	if(param)	{
				this.load({
					params : param
				});
			}	
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
       		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);	
						
						
						
						
						
						
//						var selectMasterRecord = masterGrid.getSelectedRecord();
						var selectDetailRecord = detailGrid.getSelectedRecord();
						
						if(!Ext.isEmpty(selectDetailRecord)){
							
							panelResult.setValue('BUDG_CODE_FR',selectDetailRecord.get('BUDG_CODE'));
                            panelResult.setValue('BUDG_CODE_TO',selectDetailRecord.get('BUDG_CODE'));
                            panelResult.setValue('ACCT_NO',selectDetailRecord.get('ACCT_NO'));
							
							
							UniAppManager.app.onQueryButtonDown();
							
                            panelResult.setValue('BUDG_CODE_FR','');
                            panelResult.setValue('BUDG_CODE_TO','');
                            panelResult.setValue('ACCT_NO','');
						/*
						    var calcI = selectMasterRecord.get('BUDG_I');
						
    						Ext.getCmp('BUDG_I').setValue(calcI - selectDetailRecord.get('DIVERT_BUDG_I'));
    						var param = {
                                'BUDG_YYYY'           : selectDetailRecord.get('BUDG_YYYYMM').substring(0, 4),
                                'DEPT_CODE'         : selectDetailRecord.get('DEPT_CODE'),
                                'BUDG_CODE'         : selectDetailRecord.get('BUDG_CODE')
                            }
                            directDetailStore.loadStoreRecords(param);*/
						}
					}
				};
				this.syncAllDirect(config);
			} else {
                detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
            load: function(store, records, successful, eOpts) {
//                if(store.count() == 0) {
//                    UniAppManager.app.onNewDataButtonDown();
//                }else{
                	
                UniAppManager.app.onNewDataButtonDown(records);
//                }
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        }
		
		
		
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
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
	            xtype: 'uniYearField',
	            name: 'AC_YYYY',
	            fieldLabel: '예산년도',
	            value: new Date().getFullYear(),
	            fieldStyle: 'text-align: center;',
	            allowBlank:false,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AC_YYYY', newValue);
					}
				}
	         },{
                xtype: 'uniCombobox',
                fieldLabel: '회계구분',
                name: 'AC_GUBUN',
                comboType: 'AU',
                comboCode: 'A390',  
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('AC_GUBUN', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                    }
                }
            },
	        Unilite.popup('BUDG_KOCIS_NORMAL',{
                fieldLabel: '예산과목',
                valueFieldName:'BUDG_CODE_FR',
                textFieldName:'BUDG_NAME_FR',
                //validateBlank:false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE_FR', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME_FR', newValue);             
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': panelResult.getValue('AC_YYYY')}),
                        popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                        popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                    }
                }
            }),
	        Unilite.popup('BUDG_KOCIS_NORMAL',{
                fieldLabel: '~',
                valueFieldName:'BUDG_CODE_TO',
                textFieldName:'BUDG_NAME_TO',
                //validateBlank:false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE_TO', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME_TO', newValue);             
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': panelResult.getValue('AC_YYYY')}),
                        popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                        popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                    }
                }
            })]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2,
            tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
            tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
		},
		padding:'1 1 1 1',
		border:true,
    	items: [{
            xtype: 'uniYearField',
            name: 'AC_YYYY',
            fieldLabel: '예산년도',
            value: new Date().getFullYear(),
            fieldStyle: 'text-align: center;',
            allowBlank:false,    
            tdAttrs: {width:500}, 
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('AC_YYYY', newValue);
                }
            }
         },{
            xtype: 'uniCombobox',
            fieldLabel: '회계구분',
            name: 'AC_GUBUN',
            comboType: 'AU',
            comboCode: 'A390', 
            allowBlank:false,
            tdAttrs: {width:'100%',align : 'left'},  
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {      
                    panelSearch.setValue('AC_GUBUN', newValue);
                }
            }
        },/*{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            defaults : {enforceMaxLength: true},
            tdAttrs: {align : 'left',width:120},
            items :[{
                xtype: 'button',
                text: '결재상신',   
//                    id: 'btnProc',
                name: 'PROC',
                width: 110, 
                handler : function() {
                    if(detailForm.getValue('PAY_DRAFT_NO') == ''){
                        Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0199);
                    }else{
                        openDocDetailWin_GW("3","2",null);
                    
                    }
                }
            }]
        },*/{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            tdAttrs: {width:500}, 
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DEPT_CODE', newValue);
                }
            }
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2,
                tdAttrs: {width:'100%',align : 'left'}
            },
            width:400,
            items :[
            Unilite.popup('BUDG_KOCIS_NORMAL',{
                fieldLabel: '예산과목',
                valueFieldName:'BUDG_CODE_FR',
                textFieldName:'BUDG_NAME_FR',
                //validateBlank:false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelSearch.setValue('BUDG_CODE_FR', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelSearch.setValue('BUDG_NAME_FR', newValue);             
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': panelResult.getValue('AC_YYYY')}),
                        popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                        popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                    }
                }
            }),
            Unilite.popup('BUDG_KOCIS_NORMAL',{
                fieldLabel: '~',
                labelWidth: 15,
                valueFieldName:'BUDG_CODE_TO',
                textFieldName:'BUDG_NAME_TO',
                //validateBlank:false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelSearch.setValue('BUDG_CODE_TO', newValue);
                    },
                    onTextFieldChange: function(field, newValue){
                        panelSearch.setValue('BUDG_NAME_TO', newValue);
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': panelResult.getValue('AC_YYYY')}),
                        popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                        popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                    }
                }
            })]
        },{
            xtype:'uniTextfield',
            name:'ACCT_NO',
            colspan:2,
            hidden:true
           	
        }
        
        
        ]
	});
	
	var masterGrid = Unilite.createGrid('afb520Grid1', {
    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	
    		dock: 'top',
    		showSummaryRow: false
    	}],
    	uniOpt: {
			useMultipleSorting	: true,			
		    useLiveSearch		: false,			
		    onLoadSelectFirst	: true,				
		    dblClickToEdit		: false,			
		    useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: false,			
			useRowContext		: false,		
		    filter: {					
				useFilter		: false,	
				autoCreate		: false	
			}
        },
        selModel: 'rowmodel',
        columns: [
            {dataIndex: 'COMP_CODE'         , width: 120,hidden:true},
            {dataIndex: 'DEPT_CODE'         , width: 120,hidden:true},
            {dataIndex: 'ACCT_NO'           , width: 100,hidden:true},
            {dataIndex: 'ACCT_NAME'         , width: 120}, 
            {dataIndex: 'BUDG_CODE'         , width: 200,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                }
            },
            {dataIndex: 'BUDG_YYYY'         , width: 120,hidden:true},
            {dataIndex: 'BUDG_NAME_1'       , width: 150},
            {dataIndex: 'BUDG_NAME_4'       , width: 200},
            {dataIndex: 'BUDG_NAME_6'       , width: 150},
            {dataIndex: 'BUDG_I'            , width: 150},
            {dataIndex: 'AC_GUBUN'          , width: 250,hidden:true}
        ],
        
        listeners: {
        	selectionchange: function( grid, selected, eOpts) {
        		if(!Ext.isEmpty(selected) && selected.length > 0)	{
	        		var param = {
	        			'BUDG_YYYY'			: selected[0].data.BUDG_YYYY,
	        			'DEPT_CODE'			: selected[0].data.DEPT_CODE,
	        			'BUDG_CODE'			: selected[0].data.BUDG_CODE,
                        'ACCT_NO'           : selected[0].data.ACCT_NO
	        		}
	        		directDetailStore.loadStoreRecords(param);		
                    Ext.getCmp('BUDG_I').setValue(selected[0].data.BUDG_I);
        		}
        		
        		
        	},
        	
/*            select: function(grid, selectRecord, index, rowIndex, eOpts ){
            	if(!Ext.isEmpty(selected) && selected.length > 0)  {
                    var param = {
                        'BUDG_YYYY'         : selected[0].data.BUDG_YYYY,
                        'DEPT_CODE'         : selected[0].data.DEPT_CODE,
                        'BUDG_CODE'         : selected[0].data.BUDG_CODE
                    }
                    directDetailStore.loadStoreRecords(param);      
                }
                
                Ext.getCmp('BUDG_I').setValue(selected[0].data.BUDG_I);
            },*/
        	
        	beforeedit:function( editor, context, eOpts )	{
        		if(context.field)	{
        			return false;
        		}
        	},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
//				UniAppManager.setToolbarButtons(['newData', 'delete'], false);
			},
			render: function(grid, eOpts) {
			 	var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	selectedMasterGrid = 'afb520Grid1';
			    	UniAppManager.setToolbarButtons(['newData', 'delete'], false);
			    });
			}
        }
    });
    
    var detailGrid = Unilite.createGrid('afb520Grid2', {
    	layout : 'fit',
        region : 'south',
        title: '세목조정',
		store: directDetailStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: true 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	
    		dock: 'top',
    		showSummaryRow: true
    	}],
		tbar: ['->',{
            xtype: 'uniNumberfield',
            fieldLabel: '조정가능금액 ',
            id:'BUDG_I',
            decimalPrecision:2,
            width:250,
            readOnly:true
        },'-',{
            xtype: 'button',
            text: '결재상신',   
//                id: 'btnProc',
            margin: '0 0 0 100',
            name: 'PROC',
            handler : function() {
                var selectRecord = detailGrid.getSelectedRecord();
                if(!Ext.isEmpty(selectRecord)){
                    if(selectRecord.get('AP_STS') == '0'){
                        openDocDetailTab_GW("4",selectRecord.get('DOC_NO'),null);
                   }else{
                        alert('결재상태를 확인해주십시오.');
                   }
                }else{
                    alert('결재상신할 데이터가 없습니다.');
                }
            }
        }],
    	uniOpt: {
			useMultipleSorting	: true,			
		    useLiveSearch		: false,			
		    onLoadSelectFirst	: true,				
		    dblClickToEdit		: true,			
		    useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: false,			
			useRowContext		: false,		
		    filter: {					
				useFilter		: false,	
				autoCreate		: false	
			}
        },
        columns: [
            {dataIndex: 'COMP_CODE'                       , width: 100,hidden:true},
            {dataIndex: 'DEPT_CODE'                       , width: 100,hidden:true},
            
            {dataIndex: 'AP_STS'                          , width: 100}, 
            {dataIndex: 'ACCT_NO'                         , width: 100,hidden:true}, 
            
            {dataIndex: 'BUDG_YYYYMM'                     , width: 100
                /*summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }*/
            },
            {dataIndex: 'DIVERT_DIVI'                     , width: 100},
            {dataIndex: 'DIVERT_YYYYMM'                   , width: 100},
            {dataIndex: 'BUDG_CODE'                       , width: 200,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                }
            },
            
//            {dataIndex: 'BUDG_I'                          , width: 150},
            
            {dataIndex: 'DIVERT_BUDG_CODE'                , width: 200,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                },
                editor: Unilite.popup('BUDG_KOCIS_NORMAL_G',{
                    textFieldName: 'BUDG_NAME',
                    DBtextFieldName: 'BUDG_NAME',
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            
                            if(records[0]['BUDG_CODE'] == grdRecord.get('BUDG_CODE')) {
                                alert("세목조정할 예산과목와 조정예산과목이 같을 수 없습니다.");
                                
                                grdRecord.set('DIVERT_BUDG_CODE'        ,'');
                                grdRecord.set('DIVERT_BUDG_NAME'        ,'');
                            }else{
                            	
                                grdRecord.set('DIVERT_BUDG_CODE'        ,records[0]['BUDG_CODE']);
                                grdRecord.set('DIVERT_BUDG_NAME'        ,records[0]['BUDG_NAME']);
                            }
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('DIVERT_BUDG_CODE'        ,'');
                            grdRecord.set('DIVERT_BUDG_NAME'        ,'');
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var grdRecord = detailGrid.uniOpt.currentRecord;
                                var param = {
                                    'AC_YYYY' : grdRecord.get('BUDG_YYYYMM').substring(0, 4),
                                    'DEPT_CODE' : grdRecord.get('DEPT_CODE'),
                                    'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'",
                                    
                                    'AC_GUBUN' : grdRecord.get('AC_GUBUN')
                                }
                                popup.setExtParam(param);
                            }
                        }
                    }
                })
            },
            {dataIndex: 'DIVERT_BUDG_NAME'                , width: 150,
                editor: Unilite.popup('BUDG_KOCIS_NORMAL_G',{
                    textFieldName: 'BUDG_NAME',
                    DBtextFieldName: 'BUDG_NAME',
                    autoPopup: true,
                    listeners:{ 
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            
                            if(records[0]['BUDG_CODE'] == grdRecord.get('BUDG_CODE')) {
                                alert("세목조정할 예산과목와 조정예산과목이 같을 수 없습니다.");
                                
                                grdRecord.set('DIVERT_BUDG_CODE'        ,'');
                                grdRecord.set('DIVERT_BUDG_NAME'        ,'');
                            }else{
                            
                                grdRecord.set('DIVERT_BUDG_CODE'        ,records[0]['BUDG_CODE']);
                                grdRecord.set('DIVERT_BUDG_NAME'        ,records[0]['BUDG_NAME']);
                            }
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('DIVERT_BUDG_CODE'        ,'');
                            grdRecord.set('DIVERT_BUDG_NAME'        ,'');
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var grdRecord = detailGrid.uniOpt.currentRecord;
                                var param = {
                                    'AC_YYYY' : grdRecord.get('BUDG_YYYYMM').substring(0, 4),
                                    'DEPT_CODE' : grdRecord.get('DEPT_CODE'),
                                    'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'",
                                    
                                    'AC_GUBUN' : grdRecord.get('AC_GUBUN')
                                }
                                popup.setExtParam(param);
                            }
                        }
                    }
                })
            },
            {dataIndex: 'DIVERT_BUDG_I'                   , width: 120/*, summaryType: 'sum'*/},
            {dataIndex: 'REMARK'                          , width: 250},
            {dataIndex: 'SEQ'                             , width: 250,hidden:true},
            {dataIndex: 'AC_GUBUN'                        , width: 250,hidden:true},
            {dataIndex: 'DOC_NO'                        , width: 250,hidden:true}
            
        ],
        listeners: {
        	cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
        		var count = detailGrid.getStore().getCount();
        		if(count > 0) {
    				UniAppManager.setToolbarButtons(['newData', 'delete'], true);
        		} else {
    				UniAppManager.setToolbarButtons(['newData'], true);
        		}
			},
			render: function(grid, eOpts) {
			 	var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	selectedMasterGrid = 'afb520Grid2';
			    /*	var count = detailGrid.getStore().getCount();
			    	if(count > 0){
                        UniAppManager.setToolbarButtons(['delete'], true);
			    	}
			    	*/
			    	var records = directDetailStore.data.items;
			    	
			    	if(Ext.isEmpty(records)){
                        UniAppManager.setToolbarButtons(['newData'], true);
                        UniAppManager.setToolbarButtons(['delete'], false);
			    	    
			    	}else{
                        UniAppManager.setToolbarButtons(['newData'], false);
                        UniAppManager.setToolbarButtons(['delete'], true);
			    		
			    	}
			    	
			    	
	        	/*	if(count == 0) {
	    				UniAppManager.setToolbarButtons(['newData', 'delete'], true);
	        		} else if(count == 1){
                        UniAppManager.setToolbarButtons(['delete'], true);
                        UniAppManager.setToolbarButtons(['newData'], false);
                    }else{
                        UniAppManager.setToolbarButtons(['newData', 'delete'], false);
                    }*/
			    });
			},
			beforeedit: function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['DIVERT_BUDG_CODE','DIVERT_BUDG_NAME','DIVERT_BUDG_I','REMARK'])) 
                    { 
                        return true;
                    } else {
                        return false;
                    }
				
	        /*	if(!e.record.phantom) {
	        		if(UniUtils.indexOf(e.field, ['DIVERT_BUDG_I', 'REMARK'])) 
					{ 
						return true;
      				} else {
      					return false;
      				}
	        	} else {
	        		if(UniUtils.indexOf(e.field, ['BUDG_YYYYMM', 'DIVERT_DIVI']))
				   	{
						return false;
      				} else {
      					return true;
      				}
	        	}
	        	*/
	        	
	        }
        }
    });
	
    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
				masterGrid, detailGrid, panelResult
			]	
		}, panelSearch
		],
		id: 's_afb520ukr_kocisApp',
		fnInitBinding : function() {
			
            UniAppManager.app.fnInitInputFields();
		},
		onQueryButtonDown : function()	{
			if(!panelResult.getInvalidMessage()) return;   //필수체크
			
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			detailGrid.reset();
			directMasterStore.clearData();
            directDetailStore.clearData();
            UniAppManager.app.fnInitInputFields();
		},
		onSaveDataButtonDown: function() {
			
            directDetailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			
            var selRow = detailGrid.getSelectedRecord();
            if(!Ext.isEmpty(selRow)){
                if(selRow.phantom === true) {
                    detailGrid.deleteSelectedRow();
                }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')){
                    detailGrid.deleteSelectedRow();   
                }
            }
            
            var count = detailGrid.getStore().getCount();
            if(count == 0) {
                UniAppManager.setToolbarButtons(['newData', 'delete'], true);
            } else if(count == 1){
                UniAppManager.setToolbarButtons(['delete'], true);
                UniAppManager.setToolbarButtons(['newData'], false);
            }else{
                UniAppManager.setToolbarButtons(['newData', 'delete'], false);
            }
		},
		onNewDataButtonDown: function(records)	{
			
//			var cnt = detailGrid.getStore().getCount();
//			
//			if(cnt == 1) return;
			
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            if(Ext.isEmpty(panelResult.getValue('DEPT_CODE'))){
                alert('기관을 선택해 주십시오.');
            	return   //필수체크
            }
			var record = masterGrid.getSelectedRecord();
			
			if(Ext.isEmpty(record)) {
				alert('세목조정할 데이터가 없습니다.');
			    return
            }  //필수체크
			
			
			var budgYyyyMm			= record.data.BUDG_YYYY + '01';
			var divertYyyyMm        = record.data.BUDG_YYYY + UniDate.getDbDateStr(UniDate.get('today')).substring(4, 6); 
			var divertDivi			= '1';
            var acctNo              = record.data.ACCT_NO;
			var apSts				= '0';
//            var budgI               = record.data.BUDG_I;
//			var acYyyy				= record.data.AC_YYYY;
			var deptCode			= record.data.DEPT_CODE;
			var budgCode			= record.data.BUDG_CODE;
            var acGubun             = record.data.AC_GUBUN;
			
			
			var r = {
				'BUDG_YYYYMM'			: budgYyyyMm,
				'DIVERT_YYYYMM'         : divertYyyyMm,
				'DIVERT_DIVI'			: divertDivi,
				'ACCT_NO'               : acctNo,
				'AP_STS'				: apSts,
//                'BUDG_I'                : budgI,
//				'AC_YYYY'				: acYyyy,
				'DEPT_CODE'				: deptCode,
				'BUDG_CODE'				: budgCode,
                'AC_GUBUN'              : acGubun,
                
                'DOC_NO'                : !Ext.isEmpty(records) ? records[0].get('DOC_NO') : ''
//                
//                if(!Ext.isEmpty(records)){
//                    ,'DOC_NO' : records.get	
//                }
				
			}
			detailGrid.createRow(r);
			
			
            var count = detailGrid.getStore().getCount();
            if(count == 0) {
                UniAppManager.setToolbarButtons(['newData', 'delete'], true);
            } else if(count == 1){
                UniAppManager.setToolbarButtons(['delete'], true);
                UniAppManager.setToolbarButtons(['newData'], false);
            }
            
//            else{
//                UniAppManager.setToolbarButtons(['newData', 'delete'], false);
//            }
		},
		checkForNewDetail:function() { 			
			return panelSearch.setFieldsReadOnly(true);
			return panelResult.setFieldsReadOnly(true);
        },
        fnInitInputFields: function(){
        	var activeSForm;
            if(!UserInfo.appOption.collapseLeftSearch) {
                activeSForm = panelSearch;
            } else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('AC_YYYY');
            panelSearch.setValue('AC_YYYY',new Date().getFullYear());
            panelResult.setValue('AC_YYYY',new Date().getFullYear());
            
            panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
            panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
            
            if(!Ext.isEmpty(UserInfo.deptCode)){
                if(UserInfo.deptCode == '01'){
                    panelSearch.getField('DEPT_CODE').setReadOnly(false);
                    panelResult.getField('DEPT_CODE').setReadOnly(false);
                }else{
                    panelSearch.getField('DEPT_CODE').setReadOnly(true);
                    panelResult.getField('DEPT_CODE').setReadOnly(true);
                }
            }else{
                panelSearch.getField('DEPT_CODE').setReadOnly(true);
                panelResult.getField('DEPT_CODE').setReadOnly(true);
            }
            
            UniAppManager.setToolbarButtons(['reset'], true);
            UniAppManager.setToolbarButtons(['newData','delete','save'], false);
        }

	});
	
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "DIVERT_BUDG_I" :			// 조정금액
					if(newValue < 0) {
                        rv='<t:message code = "unilite.msg.sMP570"/>';
						break;
					}
					if(newValue > Ext.getCmp('BUDG_I').getValue()){
                        rv= "조정금액은 조정가능금액을 초과할 수 없습니다."; 
                        break;
                    }
                    
				break;
				
              /*  case "DIVERT_BUDG_CODE" : 
                    if(newValue == record.get('BUDG_CODE')) {
                        rv="세목조정할 예산과목와 조정예산과목이 같을 수 없습니다.";
                        
                        record.set('DIVERT_BUDG_CODE','');
                        break;
                    }
                break;*/
			}
			return rv;
		}
	});
};

</script>
