<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb800ukr_kocis"  >
	<t:ExtComboStore comboType="AU" comboCode="A170" />			<!-- 예산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A183"  /> 		<!-- 영수구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A184"  /> 		<!-- 증빙구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A185"  /> 		<!-- 계산서적요 -->
	
    <t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
	<t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
    <t:ExtComboStore items="${COMBO_SAVE_CODE}" storeId="saveCode" /> <!--계좌코드-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_afb800ukrkocisService.selectDetail',
			update: 's_afb800ukrkocisService.updateDetail',
			create: 's_afb800ukrkocisService.insertDetail',
			destroy: 's_afb800ukrkocisService.deleteDetail',
			syncAll: 's_afb800ukrkocisService.saveAll'
		}
	});	
	
	Unilite.defineModel('Afb800ukrModel', {
		fields: [  	 
		    {name: 'COMP_CODE'                  , text: 'COMP_CODE'      ,type: 'string'},
            {name: 'IN_DRAFT_NO'                , text: 'IN_DRAFT_NO'    ,type: 'string'},
            {name: 'SEQ'                        , text: '순번'             ,type: 'int'},
            {name: 'BUDG_CODE'                  , text: '예산과목'          ,type: 'string',allowBlank:false},
            {name: 'BUDG_NAME'                  , text: '예산명'           ,type: 'string',allowBlank:false},
            {name: 'BILL_REMARK'                , text: '계산서적요'         ,type: 'string'},
            {name: 'BILL_DATE'                  , text: '계산서일'          ,type: 'uniDate'},
            {name: 'CUSTOM_CODE'                , text: '거래처'           ,type: 'string',allowBlank:false},
            {name: 'CUSTOM_NAME'                , text: '거래처명'          ,type: 'string',allowBlank:false},
//            {name: 'CURR_RATE'                  , text: '환율'             ,type: 'uniER'},
            {name: 'IN_AMT_I'                   , text: '수입액(현지화)'      ,type: 'float',decimalPrecision: 2, format:'0,000.00',allowBlank:false,maxLength:32},
            {name: 'ACCT_NO'                    , text: '입금계좌'          ,type: 'string',allowBlank:false, store: Ext.data.StoreManager.lookup('saveCode')},
            {name: 'BANK_NUM'                   , text: '계좌번호'          ,type: 'string'},
            {name: 'INOUT_DATE'                 , text: '실입금일'          ,type: 'uniDate'},
            {name: 'REMARK'                     , text: '적요'             ,type: 'string'}
		]
	});	
	
	
	var directMasterStore = Unilite.createStore('Afb800ukrDirectMasterStore',{
        proxy: {
           type: 'direct',
            api: {			
                read: 's_afb800ukrkocisService.selectMaster'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('detailForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		/*if(directMasterStore.getCount() > 0){
           			UniAppManager.setToolbarButtons(['reset','newData','delete','deleteAll'],true);
           		}*/
           		UniAppManager.app.fnDispMasterData('QUERY');
//           		UniAppManager.app.fnMasterDisable(false);
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
		
		
	});
	var directDetailStore = Unilite.createStore('Afb800ukrDirectDetailStore',{
		model: 'Afb800ukrModel',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable: true,			// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
//	        deleteAll:true
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('detailForm').getValues();
//			param.budgNameInfoList = budgNameList;	//예산목록	
//			param.budgNameListLength = budgNameListLength;
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
//			checkMasterOnly = '';
			var paramMaster= detailForm.getValues();
			
			var sumTotAmtI = 0;
            var records = directDetailStore.data.items;
            if(!Ext.isEmpty(records)){
                Ext.each(records, function(record,i){
                    sumTotAmtI = sumTotAmtI + record.get('IN_AMT_I');
                });
            }else{
                sumTotAmtI = 0;
            }
            paramMaster.TOT_AMT_I = sumTotAmtI;
			
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
        	
        	var confRecords = directDetailStore.data.items;
        	if(Ext.isEmpty(detailForm.getValue('IN_DRAFT_NO')) && Ext.isEmpty(confRecords)){
        		Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0456);
        		
        		return false;
        	}
        	var toCreate = this.getNewRecords();	//신규 레코드 왜 안들어오나 확인필요
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
        	
       		
//       		if(Ext.isEmpty(toCreate) && Ext.isEmpty(toUpdate) && Ext.isEmpty(toDelete)){
//       			checkMasterOnly = 'Y';
//       		}
//        	if(checkMasterOnly == 'Y'){
	
       		if(!directDetailStore.isDirty())	{
				if(detailForm.isDirty())	{
		       		detailForm.getForm().submit({
					params : paramMaster,
						success : function(form, action) {
			 				detailForm.getForm().wasDirty = false;
							detailForm.resetDirtyStatus();											
							UniAppManager.setToolbarButtons('save', false);	
			            	UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
	//		            	UniAppManager.app.onQueryButtonDown();
			            	UniAppManager.app.onQueryButtonDown();
	//						directMasterStore.loadStoreRecords();
						
						
						}	
					});
//       		}else{
				}
       		}else{
				if(inValidRecs.length == 0 )	{
					
					config = {
						params: [paramMaster],
						success: function(batch, option) {
							var master = batch.operations[0].getResultSet();
							detailForm.setValue("IN_DRAFT_NO", master.IN_DRAFT_NO);
	//						directMasterStore.loadStoreRecords();
							UniAppManager.app.onQueryButtonDown();
						}
					};
					this.syncAllDirect(config);
				}else {
					detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
       		}
		}
	});
	
	var detailForm = Unilite.createForm('detailForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3,
			tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
        	tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
	
		},
		padding:'1 1 1 1',
		border:true,
		disabled:false,
		items: [{ 
    		fieldLabel: '수입작성일',
    		labelWidth:150,
		    xtype: 'uniDatefield',
//		    id:'draftDatePR',
		    name: 'IN_DATE',
		    value: UniDate.get('today'),
		    allowBlank: false,tdAttrs: {width:700/*align : 'center'*/},                	
            listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
//					detailForm.setValue('SLIP_DATE',newValue);
//					UniAppManager.app.fnApplySlipDate(newValue);
				}
			}
		},
		Unilite.popup('USER', {
			fieldLabel: '수입결의자', 
			labelWidth:150,
			valueFieldName: 'DRAFTER',
    		textFieldName: 'DRAFTER_NAME', 
//		    		validateBlank:false,
//    		autoPopup:true,
    		tdAttrs: {width:'100%'/*,align : 'center'*/}, 
//    		colspan:2,
    		allowBlank:false,
    		readOnly:true
		}),
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			
//				id:'hiddenContainerPR',
			defaults : {enforceMaxLength: true},
			   tdAttrs: {align : 'left',width:120},
			items :[{
	    		xtype: 'button',
	    		text: '결재상신',	
	    		id: 'btnProc',
	    		name: 'PROC',
	    		width: 110,	
				handler : function() {
                    if(detailForm.getValue('IN_DRAFT_NO') == ''){
                        alert('결재상신할 데이터가 없습니다.');
                    }else{
                        if( Ext.getCmp('status').getValue().STATUS == '0' ){
                            openDocDetailTab_GW("2",detailForm.getValue('IN_DRAFT_NO'),null);
                        }else{
                            alert('결재상태를 확인해주십시오.');
                        }
                    }
                }
	    	}]
    	},{ 
            fieldLabel: '수입결의번호',
            labelWidth:150,
            xtype: 'uniTextfield',
            name: 'IN_DRAFT_NO',
            readOnly:true,//,   테스트중
            tdAttrs: {width:700/*align : 'center'*/},
            //tdAttrs: {align : 'center'},
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {      
//                  panelSearch.setValue('IN_DRAFT_NO', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            labelWidth:150,
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            allowBlank: false,
            tdAttrs: {width:'100%',align : 'left'}
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:120,
//              id:'hiddenContainerPR',
            defaults : {enforceMaxLength: true},
               tdAttrs: {align : 'left'},
            items :[{
                xtype: 'button',
                text: '복사', 
                id: 'btnCopy',
                name: 'COPY',
                width: 110, 
                handler : function() {
                    
                    var bReferNum = false;
                    
                    if(detailForm.getValue('IN_DRAFT_NO') == ''){
                        return false;
                    }else{
                    	
                    	detailGrid.reset();
                        directDetailStore.clearData();
                        UniAppManager.app.onNewDataButtonDown();
                        UniAppManager.app.fnDispMasterData("COPY");
                        
                    /*  
                        var records = directDetailStore.data.items;
                        
                        var copyRecords = records;
//                          detailGrid.reset();
//                          directDetailStore.clearData();
                        
                            Ext.each(copyRecords, function(record,i){
//                              if(record.get('REFER_NUM') != '' && Ext.getCmp('rdoStatus').getValue().STATUS != '5'){
//                                  bReferNum = true;
//                              }else{
                                if(!Ext.isEmpty(record.get('SEQ'))){
                                    UniAppManager.app.copyDataCreateRow();
                                    
//                                      UniAppManager.app.onNewDataButtonDown();
                                    detailGrid.setNewDataCopy(record.data);
                                    
                                }
//                              }
                            });
                            alert('ddd');
                            directDetailStore.remove(directDetailStore.data.items);
                            directDetailStore.clearData();*/
                        
/*                        var records = directDetailStore.data.items;
                        Ext.each(records, function(record,i){
                            if(record.get('REFER_NUM') != '' && Ext.getCmp('rdoStatus').getValue().STATUS != '5'){
                                bReferNum = true;
                            }   
                        });
                        if(bReferNum == true){
                            Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0460);  
                        }
                        
                        
                        detailGrid.reset();
                        directDetailStore.clearData();
                        var param = {"IN_DRAFT_NO": detailForm.getValue('IN_DRAFT_NO')
                        };
                        s_afb800ukrkocisService.selectDetail(param, function(provider, response)   {
                            if(!Ext.isEmpty(provider)){
                                Ext.each(provider, function(record,i){
                                    UniAppManager.app.copyDataCreateRow();
                                    detailGrid.setNewDataCopy(record);
                                });
                            }
                            
                            
                            
                        });
                        */
//                      UniAppManager.app.fnDispTotAmt();
                        
                            
//                        UniAppManager.app.fnDispMasterData("COPY");
                        
//                        UniAppManager.app.fnMasterDisable(false);
                        
//                      Call goCnn.SetFrameButtonInfo("NW1:SV1")
//                      If grdSheet1.Rows > csHeaderRowsCnt Then
//                          Call goCnn.SetFrameButtonInfo("DL1:DA1")
//                      End If


                    }
                }
            }]
        },{
            xtype: 'uniCombobox',
            fieldLabel: '회계구분',
            labelWidth:150,
            name: 'AC_GUBUN',
            comboType: 'AU',
            comboCode: 'A390',
            allowBlank: false,
            tdAttrs: {width:700/*align : 'center'*/}
        },{ 
    		fieldLabel: '수입건명',
    		labelWidth:150,
		    xtype: 'uniTextfield',
		    name: 'TITLE',
		    width: 450,
		    allowBlank: false,
            tdAttrs: {width:'100%',align : 'left'},
            colspan:2,
			listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
//		    		panelSearch.setValue('TITLE', newValue);
		      	}
     		}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:600,
//				id:'hiddenContainerPR',
			defaults : {enforceMaxLength: true},
            tdAttrs: {width:700/*align : 'center'*/},
			colspan:3,
			items :[{
				xtype: 'radiogroup',		            		
				fieldLabel: '상태',
				labelWidth:150,
				id:'status',
				items: [{
					boxLabel: '미상신', 
					width: 60,
					name: 'STATUS',
					inputValue: '0',
					readOnly: true,
					checked:true
				},{
					boxLabel: '결재중', 
					width: 60,
					name: 'STATUS',
					inputValue: '1',
					readOnly: true
				},{
					boxLabel: '반려', 
					width: 45,
					name: 'STATUS',
					inputValue: '5',
					readOnly: true
				},{
					boxLabel : '완결', 
					width: 45,
					name: 'STATUS',
					inputValue: '9',
					readOnly: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
//						panelSearch.getField('STATUS').setValue(newValue.STATUS);					
//						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]
    	},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:800,
			id: 'tdTitleDesc',
			defaults : {enforceMaxLength: true},
			colspan:3,
			tdAttrs: {width:800/*align : 'center'*/},
//			   tdAttrs: {align : 'left'},
			items :[{
		    	fieldLabel:'내용',
		    	labelWidth:150,
	//	    	labelAlign : 'top',
		    	xtype:'textarea',
//		    	id: 'titleDescPR',
		    	name:'TITLE_DESC',
		    	width:800,
//		    	colspan:4,
		    	tdAttrs: {width:800/*align : 'center'*/},
		    	listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
	//		    		panelSearch.setValue('TITLE_DESC', newValue);
			      	}
				}
			}]
    	}
    	
    	],
    	api: {
//	 		load: 'atx800ukrService.selectForm'	,
	 		submit: 's_afb800ukrkocisService.syncMaster'	
		},
        listeners : {
            uniOnChange:function( basicForm, dirty, eOpts ) {
                console.log("onDirtyChange");
                if(basicForm.isDirty()) {
                    UniAppManager.setToolbarButtons('save', true);
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }
            }
        }
	});
	
    var detailGrid = Unilite.createGrid('Afb800ukrGrid', {
    	
    	features: [{
			id: 'detailGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false
		},{
			id: 'detailGridTotal',		
			ftype: 'uniSummary',		
			dock:'bottom',
			showSummaryRow: false
		}],
    	layout : 'fit',
        region : 'center',
		store: directDetailStore,
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: true,
			expandLastColumn	: false,
    		dblClickToEdit		: true,
    		onLoadSelectFirst	: true, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			state: {
				useState: true,			
				useStateList: true		
			}
		},
        columns:[
        
            {dataIndex: 'COMP_CODE'               , width: 100,hidden:true},
            {dataIndex: 'IN_DRAFT_NO'             , width: 100,hidden:true},
            {dataIndex: 'SEQ'                     , width: 60},
            {dataIndex: 'BUDG_CODE'               , width: 150,
                editor: Unilite.popup('BUDG_KOCIS_NORMAL_G',{
                    textFieldName: 'BUDG_NAME',
                    DBtextFieldName: 'BUDG_NAME',
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            
                            grdRecord.set('BUDG_CODE'       ,records[0]['BUDG_CODE']);
                            grdRecord.set('BUDG_NAME'       ,records[0]['BUDG_NAME']);
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('BUDG_CODE'       ,'');
                            grdRecord.set('BUDG_NAME'       ,'');
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('IN_DATE')).substring(0, 4),
                                    'DEPT_CODE' : detailForm.getValue('DEPT_CODE'),
                                    'ADD_QUERY' : "B.BUDG_TYPE = '1' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"
                                }
                                popup.setExtParam(param);
                            }
                        }
                    }
                })
            },
            {dataIndex: 'BUDG_NAME'                   , width: 200,
                editor: Unilite.popup('BUDG_KOCIS_NORMAL_G',{
                    textFieldName: 'BUDG_NAME',
                    DBtextFieldName: 'BUDG_NAME',
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            
                            grdRecord.set('BUDG_CODE'       ,records[0]['BUDG_CODE']);
                            grdRecord.set('BUDG_NAME'       ,records[0]['BUDG_NAME']);
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('BUDG_CODE'       ,'');
                            grdRecord.set('BUDG_NAME'       ,'');
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {  
                                    'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('IN_DATE')).substring(0, 4),
                                    'DEPT_CODE' : detailForm.getValue('DEPT_CODE'),
                                    'ADD_QUERY' : "B.BUDG_TYPE = '1' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"
                                }
                                popup.setExtParam(param);
                            }
                        }
                    }
                })
            },
            {dataIndex: 'BILL_REMARK'              , width: 200,hidden:true},
            {dataIndex: 'BILL_DATE'               , width: 100,hidden:true},
            {dataIndex: 'CUSTOM_CODE'             , width: 100,
                editor: Unilite.popup('CUST_KOCIS_G',{
                    textFieldName: 'CUSTOM_NAME',
                    DBtextFieldName: 'CUSTOM_NAME',
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            
                            grdRecord.set('CUSTOM_CODE'       ,records[0]['CUSTOM_CODE']);
                            grdRecord.set('CUSTOM_NAME'       ,records[0]['CUSTOM_NAME']);
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE'       ,'');
                            grdRecord.set('CUSTOM_NAME'       ,'');
                        }
                    }
                })
            },
            {dataIndex: 'CUSTOM_NAME'             , width: 150,
                editor: Unilite.popup('CUST_KOCIS_G',{
                    textFieldName: 'CUSTOM_NAME',
                    DBtextFieldName: 'CUSTOM_NAME',
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            
                            grdRecord.set('CUSTOM_CODE'       ,records[0]['CUSTOM_CODE']);
                            grdRecord.set('CUSTOM_NAME'       ,records[0]['CUSTOM_NAME']);
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE'       ,'');
                            grdRecord.set('CUSTOM_NAME'       ,'');
                        }
                    }
                })
            },
//            {dataIndex: 'CURR_RATE'               , width: 100,hidden:true},
            {dataIndex: 'IN_AMT_I'                , width: 120},
            {dataIndex: 'ACCT_NO'               , width: 100},
            {dataIndex: 'BANK_NUM'            , width: 120},
            {dataIndex: 'INOUT_DATE'              , width: 100},
            {dataIndex: 'REMARK'                  , width: 200}
        
    	],               
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
        		
      	 		if(UniUtils.indexOf(e.field, ['SEQ','BANK_NUM'])){
                    return false;
                }else{
                    return true;
                }
			}
        	/*itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}*/
        },
        
        setNewDataCopy:function(record){
            var grdRecord = this.getSelectedRecord();
			
			
			
			grdRecord.set('COMP_CODE'       ,record['COMP_CODE']);
            grdRecord.set('IN_DRAFT_NO'     ,record['IN_DRAFT_NO']);
            grdRecord.set('SEQ'             ,record['SEQ']);
            grdRecord.set('BUDG_CODE'       ,record['BUDG_CODE']);
            grdRecord.set('BUDG_NAME'       ,record['BUDG_NAME']);
            grdRecord.set('BILL_REMARK'     ,record['BILL_REMARK']);
            grdRecord.set('BILL_DATE'       ,record['BILL_DATE']);
            grdRecord.set('CUSTOM_CODE'     ,record['CUSTOM_CODE']);
            grdRecord.set('CUSTOM_NAME'     ,record['CUSTOM_NAME']);
//            grdRecord.set('CURR_RATE'       ,record['CURR_RATE']);
            grdRecord.set('IN_AMT_I'        ,record['IN_AMT_I']);
            grdRecord.set('ACCT_NO'       ,record['ACCT_NO']);
            grdRecord.set('BANK_NUM'    ,record['BANK_NUM']);
            grdRecord.set('INOUT_DATE'      ,record['INOUT_DATE']);
            grdRecord.set('REMARK'          ,record['REMARK']);
			
        }
		
		/*onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
      		 return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '예산기안(추산)등록 보기',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb600(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAfb600:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 'afb800ukr',
					'AC_DATE' 			: record.data['AC_DATE'],
					'ACCNT_DIV_CODE'	: panelSearch.getValue('ACCNT_DIV_CODE'),
					'ACCNT' 			: record.data['ACCNT'],	
					'ACCNT_NAME' 		: record.data['ACCNT_NAME'],
					'START_DATE'		: panelSearch.getValue('START_DATE')
				}
		  		var rec1 = {data : {prgID : 'afb800ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb800ukr.do', params);
			}
    	}*/
    });   
    
	 Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				detailForm, detailGrid
			]
		}], 
//		panelSearch: dedAmtSearch,
		id : 'Afb800ukrApp',
		fnInitBinding : function(params) {
			
			var param= Ext.getCmp('detailForm').getValues();
//			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
//			detailForm.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DRAFT_DATE', UniDate.get('today'));
//			detailForm.setValue('DRAFT_DATE', UniDate.get('today'));
			UniAppManager.setToolbarButtons(['newData'],true);
			UniAppManager.setToolbarButtons(['query'], false);
			
//			detailForm.getField('DRAFT_TITLE').setDisabled(true);
//			detailForm.getField('PAY_DTL_TITLE').setReadOnly(true);
			this.setDefault(params);
			detailForm.onLoadSelectText('IN_DATE');
		},
		onQueryButtonDown : function()	{
			directMasterStore.loadStoreRecords();
			directDetailStore.loadStoreRecords();
		},
		onNewDataButtonDown: function(copyCheck)	{
//			if(!this.checkForNewDetail()) return false;
            if(!detailForm.getInvalidMessage()) return false;
			
			var compCode      = UserInfo.compCode;
			var inDraftNo     = detailForm.getValue('IN_DRAFT_NO');
			var seq = directDetailStore.max('SEQ');
            	 if(!seq){
            	 	seq = 1;
            	 }else{
            	 	seq += 1;
            	 }
			var billDate      = UniDate.get('today');
			
			
            var r = {
            	COMP_CODE : compCode,     
				IN_DRAFT_NO : inDraftNo,  
				SEQ	 		 : seq,  
				BILL_DATE   : billDate
	        };
	        if(copyCheck == 'Y'){
	        	detailGrid.createRow(r);	
	        }else{
				detailGrid.createRow(r,'BUDG_CODE');
	        }
		},
		copyDataCreateRow: function()	{
			var seq = directDetailStore.max('SEQ');
            	 if(!seq){
            	 	seq = 1;
            	 }else{
            	 	seq += 1;
            	 }
            var r = {  
				SEQ	 		 : seq
	        };
			detailGrid.createRow(r);
		},
		
		onResetButtonDown: function() {		
			detailForm.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			UniAppManager.app.fnInitInputFields();
//			UniAppManager.app.fnMasterDisable(false);
			UniAppManager.setToolbarButtons(['delete','deleteAll','save'], false);
		},
		onSaveDataButtonDown: function(config) {
			if(!detailForm.getInvalidMessage()) return false; 
			directDetailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				
				detailGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			if(confirm('전체삭제 하시겠습니까?')) {
				var param = {
					IN_DRAFT_NO: detailForm.getValue('IN_DRAFT_NO'),
					DRAFTER_PN  : detailForm.getValue('DRAFTER_PN'),
					PASSWORD  : detailForm.getValue('PASSWORD')
				}
				detailForm.getEl().mask('전체삭제 중...','loading-indicator');
				detailGrid.getEl().mask('전체삭제 중...','loading-indicator');
				s_afb800ukrkocisService.afb800ukrDelA(param, function(provider, response)	{							
					if(provider){	
						UniAppManager.updateStatus(Msg.sMB013);
						
						UniAppManager.app.onResetButtonDown();	
					}
					detailForm.getEl().unmask();
					detailGrid.getEl().unmask();
					
				});
			}else{
				return false;	
			}
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 's_afb800skr_KOCIS') {
				
				detailForm.setValue('IN_DRAFT_NO',params.IN_DRAFT_NO);
		
				this.onQueryButtonDown();
			}
		},
		setDefault: function(params){
//			UniAppManager.app.fnInitInputProperties();
			
			if(!Ext.isEmpty(params.IN_DRAFT_NO)){
                UniAppManager.app.fnInitInputFields();  
				this.processParams(params);
			}else{
				UniAppManager.app.fnInitInputFields();	
			}
			
		},
		/**
		 * 입력란의 초기값 설정
		 */
		fnInitInputFields: function(){		//수입결의 완료
			//수입작성일
			detailForm.setValue('IN_DATE', UniDate.get('today'));
			
			//수입작성자
            detailForm.setValue('DRAFTER',UserInfo.userID);
            detailForm.setValue('DRAFTER_NAME',UserInfo.userName);
			
			//계좌입금일
//			detailForm.setValue('SLIP_DATE', UniDate.get('today'));
//			detailForm.setValue('EX_NUM','');
			
			//수입결의번호
			detailForm.setValue('IN_DRAFT_NO','');
			
			//회계구분
//			detailForm.setValue('ACCNT_GUBUN', gsAccntGubun);
			
			//수입건명
			detailForm.setValue('TITLE','');	
			
			//상태(미상신)
			detailForm.getField('STATUS').setValue('0');
			
			//내용
			detailForm.setValue('TITLE_DESC','');
		
			detailForm.setValue('DEPT_CODE',UserInfo.deptCode);
            
            if(!Ext.isEmpty(UserInfo.deptCode)){
                if(UserInfo.deptCode == '01'){
                    detailForm.getField('DEPT_CODE').setReadOnly(false);
                    
                }else{
                    detailForm.getField('DEPT_CODE').setReadOnly(true);
                }
            }else{
                detailForm.getField('DEPT_CODE').setReadOnly(true);
            }
		},
		
		/**
		 * 수입결의 마스터정보 표시
		 */
		fnDispMasterData:function(qryType){		//수입결의 완료
			if(qryType == 'COPY'){
				//수입작성일
				detailForm.setValue('IN_DATE',UniDate.get('today'));
				
				//계좌입금일
//				detailForm.setValue('SLIP_DATE',UniDate.get('today'));
//				detailForm.setValue('EX_NUM','');
				
				//수입결의번호
				detailForm.setValue('IN_DRAFT_NO','');
				
				//상태
				detailForm.getField('STATUS').setValue('0');
			
			}else if(qryType == 'QUERY'){
				if(directMasterStore.getCount() == 0){
					
					//수입작성일
					detailForm.setValue('IN_DATE','');
					

					//계좌입금일
//					detailForm.setValue('SLIP_DATE','');
//					detailForm.setValue('EX_NUM','');
					
					//회계구분
					detailForm.setValue('ACCNT_GUBUN','');
					
					//수입건명
					detailForm.setValue('TITLE','');

					//상태
					detailForm.getField('STATUS').setValue('0');
					
					//내용
					detailForm.setValue('TITLE_DESC','');

					Ext.Msg.alert(Msg.sMB099,Msg.sMB025);
					
					return false;
				}else{
//					,,,,,
					var masterRecord = directMasterStore.data.items[0];
					
					//수입작성일
					detailForm.setValue('IN_DATE',masterRecord.data.IN_DATE);
					
					detailForm.setValue('DEPT_CODE',masterRecord.data.DEPT_CODE);
                    
                    detailForm.setValue('DRAFTER',masterRecord.data.DRAFTER);
                    detailForm.setValue('DRAFTER_NAME',masterRecord.data.DRAFTER_NAME);
                    
                    detailForm.setValue('AC_GUBUN',masterRecord.data.AC_GUBUN);
					//계좌입금일
//					detailForm.setValue('SLIP_DATE',masterRecord.data.SLIP_DATE);
//					detailForm.setValue('EX_NUM',masterRecord.data.EX_NUM);
					
					//수입결의번호
					detailForm.setValue('IN_DRAFT_NO',masterRecord.data.IN_DRAFT_NO);
					
					//상태
					detailForm.getField('STATUS').setValue(masterRecord.data.STATUS);
					
					//수입결의자
//					detailForm.setValue('DRAFTER_PN',masterRecord.data.DRAFTER);
//					detailForm.setValue('DRAFTER_NM',masterRecord.data.DRAFTER_NM);
								
					//회계구분
					detailForm.setValue('ACCNT_GUBUN',masterRecord.data.ACCNT_GUBUN);
					
					//수입건명
					detailForm.setValue('TITLE',masterRecord.data.TITLE);
					
					//내용
					detailForm.setValue('TITLE_DESC',masterRecord.data.TITLE_DESC);
				
				}
			}			
		},
		/**
		 * 결제상신 관련
		 */
		fnApproval: function(){
			Ext.Msg.alert("버튼이 결재상신 일때","빌드중(추후개발예정)");
		}
		


	});
	
	
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ACCT_NO" :
				    var param = {"SAVE_CODE": newValue};
                    kocisCommonService.fnGetBankNum(param, function(provider, response)   {
                        if(!Ext.isEmpty(provider)){
                        	record.set('BANK_NUM',provider.BANK_NUM);
                        }
                    });
					break;
			}
			return rv;
		}
	});	
/*	
	Unilite.createValidator('validator02', {
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case fieldName:
					UniAppManager.setToolbarButtons('save',true);
					break;
			}
			return rv;
		}
	});*/
};
</script>
