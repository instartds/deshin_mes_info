<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb700ukr_kocis"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_afb700ukr_kocis" /> 	<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A170" opts='1;2'/>			<!-- 예산구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A390" />         <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" />         <!-- 원인행위 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" />         <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" /> 		<!-- 예/아니오 -->
    <t:ExtComboStore comboType="AU" comboCode="A395" />        <!-- 지급방법 -->
    
    <t:ExtComboStore comboType="AU" comboCode="A394" />        <!-- 계약구분 -->
    
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
    
    
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

	
function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_afb700ukrkocisService.selectDetail',
			update: 's_afb700ukrkocisService.updateDetail',
			create: 's_afb700ukrkocisService.insertDetail',
			destroy: 's_afb700ukrkocisService.deleteDetail',
			syncAll: 's_afb700ukrkocisService.saveAll'
		}
	});	
	Unilite.defineModel('Afb700ukrModel', {
        fields: [
            {name: 'COMP_CODE'          , text: '법인코드'         ,type: 'string'},
            {name: 'DEPT_CODE'          , text: '기관코드'         ,type: 'string'},
            {name: 'SEQ'                , text: '순번'         ,type: 'int'},
            {name: 'PAY_DRAFT_NO'       , text: '지출결의번호'   ,type: 'string'},
            {name: 'BUDG_CODE'          , text: '예산과목'      ,type: 'string',allowBlank:false},
            {name: 'BUDG_NAME'          , text: '예산명'       ,type: 'string'},
            {name: 'ACCT_NO'            , text: '출금계좌코드'    ,type: 'string',allowBlank:false},
            {name: 'SAVE_NAME'          , text: '출금계좌'       ,type: 'string'},
            {name: 'BANK_ACCOUNT'       , text: '출금계좌번호'    ,type: 'string'},
            {name: 'BUDG_I'             , text: '예산사용금액'    ,type: 'uniUnitPrice'},//'float',decimalPrecision: 2, format:'0,000.00'},
            {name: 'PAY_DIVI'           , text: '지급방법'       ,type: 'string',comboType:'AU', comboCode:'A395',allowBlank:false},
            {name: 'CUSTOM_CODE'        , text: '거래처코드'      ,type: 'string',allowBlank:false},
            {name: 'CUSTOM_NAME'        , text: '거래처명'        ,type: 'string',allowBlank:false},
            {name: 'CHECK_NO'           , text: '수표번호'        ,type: 'string'},
            {name: 'CURR_UNIT'          , text: '화폐단위'       ,type: 'string'},
            {name: 'LOC_AMT_I'          , text: '금액'         ,type: 'uniUnitPrice',allowBlank:false},//'float',decimalPrecision: 2, format:'0,000.00',allowBlank:false},     
            {name: 'CURR_RATE'          , text: '환율'         ,type: 'uniER'},
            {name: 'TOT_AMT_I'          , text: '지급액'        ,type: 'uniUnitPrice',allowBlank:false},//'float',decimalPrecision: 2, format:'0,000.00',allowBlank:false},   
            {name: 'BUDG_GUBUN'         , text: '예산구분'       ,type: 'string'}
        ]
	});	
	  
	var directMasterStore = Unilite.createStore('Afb700ukrDirectMasterStore',{
        proxy: {
           type: 'direct',
            api: {
                read: 's_afb700ukrkocisService.selectMaster'
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
           		if(directMasterStore.getCount() > 0){
           			UniAppManager.setToolbarButtons(['reset','newData','delete'/*,'deleteAll'*/],true);
           		}
           		UniAppManager.app.fnDispMasterData('QUERY');
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
		
		
	});
	
	var directDetailStore = Unilite.createStore('Afb700ukrDirectDetailStore',{
		model: 'Afb700ukrModel',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable: true,			// 삭제 가능 여부
	        useNavi : false,				// prev | newxt 버튼 사용
	        deleteAll:true
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
			var paramMaster= detailForm.getValues();
			
			var sumTotAmtI = 0;
			var records = directDetailStore.data.items;
			if(!Ext.isEmpty(records)){
				Ext.each(records, function(record,i){
					sumTotAmtI = sumTotAmtI + record.get('TOT_AMT_I');
                });
			}else{
				sumTotAmtI = 0;
			}
			
			paramMaster.TOT_AMT_I = sumTotAmtI;
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
        	
        	var confRecords = directDetailStore.data.items;
        	if(Ext.isEmpty(detailForm.getValue('PAY_DRAFT_NO')) && Ext.isEmpty(confRecords)){
        		Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0443);
        		
        		return false;
        	}
        	var toCreate = this.getNewRecords();
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
			            	UniAppManager.app.onQueryButtonDown();
			            	
	//						directMasterStore.loadStoreRecords();
						
						}	
					});
				}
       		}else{
       		
				if(inValidRecs.length == 0 )	{
					
					config = {
						params: [paramMaster],
						success: function(batch, option) {
							var master = batch.operations[0].getResultSet();
							detailForm.setValue("PAY_DRAFT_NO", master.PAY_DRAFT_NO);
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
			tableAttrs: { width: '100%'},
        	tdAttrs: {/*style: 'border : 1px solid #ced9e7;'/*align : 'left',*/width: '100%'}
		},
		padding:'1 1 1 1',
		border:true,
		disabled:false,
		items: [{
            xtype: 'container',
            layout: {type: 'uniTable', columns: 2},    
            tdAttrs: {width:1000},
            items: [{
        		fieldLabel: '지출작성일',
        		labelWidth:150,
    		    xtype: 'uniDatefield',
    //		    id:'draftDatePR',
    		    name: 'PAY_DATE',
    		    value: UniDate.get('today'),
    		    allowBlank: false  
    		},{
                xtype: 'uniCheckboxgroup',  
                fieldLabel: '',
                items: [{
                    boxLabel: '13월분',
                    width: 60,
                    xtype:'checkbox',
                    name: 'NEXT_GUBUN'
                }]
            }]
		},
		Unilite.popup('USER', {
			fieldLabel: '지출작성자', 
			labelWidth:150,
			valueFieldName: 'PAY_USER',
    		textFieldName: 'PAY_USER_NAME',
    		tdAttrs: {width:'100%',align : 'left'}, 
            allowBlank: false,
            readOnly:true
//		    		validateBlank:false,
//    		autoPopup:true
		}),
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
//			width:100,
//				id:'hiddenContainerPR',
			defaults : {enforceMaxLength: true},
			tdAttrs: {align : 'left',width:120},
//			   tdAttrs: {align : 'left'},
			items :[{
	    		xtype: 'button',
	    		text: '결재상신',	
	    		id: 'btnProcPR',
	    		name: 'PROC',
	    		width: 110,	
				handler : function() {
					if(detailForm.getValue('PAY_DRAFT_NO') == ''){
						alert('결재상신할 데이터가 없습니다.');
					}else{
						if( Ext.getCmp('status').getValue().STATUS == '0' ){
							openDocDetailTab_GW("1",detailForm.getValue('PAY_DRAFT_NO'),null);
						}else{
                            alert('결재상태를 확인해주십시오.');
						}
					}
				}
	    	}]
    	},{
    		fieldLabel: '지출결의번호',
    		labelWidth:150,
		    xtype: 'uniTextfield',
		    name: 'PAY_DRAFT_NO',
		    readOnly:true,
		    tdAttrs: {width:1000}
		    //tdAttrs: {align : 'center'},
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
			tdAttrs: {align : 'left',width:120},
//				id:'hiddenContainerPR',
			defaults : {enforceMaxLength: true},
//			   tdAttrs: {align : 'left'},
			items :[{
	    		xtype: 'button',
	    		text: '복사',	
	    		id: 'btnCopyPR',
	    		name: 'COPY',
	    		width: 110,	
				handler : function() {
					if(detailForm.getValue('PAY_DRAFT_NO') == ''){
						return false;
					}else{
						
						detailGrid.reset();
						directDetailStore.clearData();
						UniAppManager.app.onNewDataButtonDown();
				/*		var param = {"PAY_DRAFT_NO": detailForm.getValue('PAY_DRAFT_NO')};
						s_afb700ukrkocisService.selectDetail(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								Ext.each(provider, function(record,i){
									UniAppManager.app.onNewDataButtonDown('Y');
					        		detailGrid.setNewDataCopy(record);	
								});
							}
						});*/
						
//						UniAppManager.app.fnDispTotAmt();
						
						UniAppManager.app.fnDispMasterData("COPY");
						
//						UniAppManager.app.fnMasterDisable(false);
						
//						Call goCnn.SetFrameButtonInfo("NW1:SV1")
//						If grdSheet1.Rows > csHeaderRowsCnt Then
//							Call goCnn.SetFrameButtonInfo("DL1:DA1")
//						End If


					}
				}
	    	}]
    	},{
			fieldLabel: '예산구분',
			labelWidth:150,
			name:'BUDG_GUBUN',	
			xtype: 'uniCombobox',
		    comboType:'AU',
			comboCode:'A170', 
		    allowBlank: false,
		    tdAttrs: {width:1000}
	        //value:UserInfo.divCode
		},{
            xtype: 'uniCombobox',
            fieldLabel: '회계구분',
            labelWidth:150,
            name: 'AC_GUBUN',
            comboType: 'AU',
            comboCode: 'A390',
            allowBlank: false,
            tdAttrs: {width:'100%',align : 'left'}
        },{
            xtype:'component'
        },{ 
    		fieldLabel: '지출제목',
    		labelWidth:150,
		    xtype: 'uniTextfield',
		    name: 'TITLE',
		    width: 500,
		    allowBlank: false,
		    tdAttrs: {width:1000/*align : 'center'*/}
		    //tdAttrs: {align : 'center'},
		
		},{
            xtype: 'uniCombobox',
            fieldLabel: '계약구분',
            labelWidth:150,
            name: 'CONTRACT_GUBUN',
            comboType: 'AU',
            comboCode: 'A394',
            allowBlank: false,
            tdAttrs: {width:'100%',align : 'left'}
        },{
    		xtype:'component'
		},{
    		fieldLabel: '원인행위',
    		labelWidth:150,
		    name: 'AC_TYPE',
		    xtype: 'uniCombobox',
		    comboType:'AU',
			comboCode:'A391',
		    allowBlank: false,
		    tdAttrs: {width:1000}
		},{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:500,
//              id:'hiddenContainerPR',
            tdAttrs: {width:'100%',align : 'left'}, 
            defaults : {enforceMaxLength: true},
             tdAttrs: {align : 'left'},
          colspan:2,
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
//                      detailForm.getField('STATUS').setValue(newValue.STATUS);                    
//                      UniAppManager.app.onQueryButtonDown();
                    }
                }
            }]
        },{
            xtype: 'component',  
            html:'※ 조회된 예산사용금액은 지출 당시 예산사용금액 입니다.',
            tdAttrs: {width:1000},
            margin: '0 0 0 90',
            style: {
                marginTop: '3px !important',
                font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
                color: 'red'
            }
        }],
    	api: {
//	 		load: 'atx600ukrService.selectForm'	,
	 		submit: 's_afb700ukrkocisService.syncMaster'	
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
        /*,	
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}*/
	});
	
    /* Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var detailGrid = Unilite.createGrid('Afb700ukrGrid', {
    	features: [{
			id: 'detailGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false
		},{
			id: 'detailGridTotal',		
			ftype: 'uniSummary',		
			dock:'bottom',
			showSummaryRow: true,
            dock:'bottom'
		}],
    	layout : 'fit',
        region : 'center',
		store: directDetailStore,
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: true,
			expandLastColumn	: true,
			onLoadSelectFirst 	: false,
    		dblClickToEdit		: true, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			state: {
				useState: false,			
				useStateList: false		
			}
		},
        columns:[
            {dataIndex: 'COMP_CODE'                   , width: 100,hidden:true},
            {dataIndex: 'DEPT_CODE'                   , width: 100,hidden:true},
            {dataIndex: 'SEQ'                         , width: 60},
            {dataIndex: 'PAY_DRAFT_NO'                , width: 100,hidden:true},
            {dataIndex: 'BUDG_CODE'                   , width: 150,
                editor: Unilite.popup('BUDG_KOCIS_G',{
                    textFieldName: 'BUDG_NAME',
                    DBtextFieldName: 'BUDG_NAME',
                    autoPopup: true,
                    listeners:{ 
                        scope:this,
                        onSelected:function(records, type ) {
                            
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            
                            grdRecord.set('BUDG_CODE'       ,records[0]['BUDG_CODE']);
                            grdRecord.set('BUDG_NAME'       ,records[0]['BUDG_NAME']);
                            grdRecord.set('ACCT_NO'         ,records[0]['ACCT_NO']);
                            grdRecord.set('SAVE_NAME'       ,records[0]['SAVE_NAME']);
                            grdRecord.set('BANK_ACCOUNT'    ,records[0]['BANK_ACCOUNT']);
                            grdRecord.set('BUDG_I'          ,records[0]['BUDG_I']);
                            grdRecord.set('CURR_UNIT'       ,records[0]['CURR_UNIT']);
                            grdRecord.set('CURR_RATE'       ,records[0]['CURR_RATE']);
                            
                      /*      
                            var param = {"BUDG_YYYYMM": UniDate.getDbDateStr(detailForm.getValue('PAY_DATE')).substring(0, 6),
                                    "DEPT_CODE": detailForm.getValue('DEPT_CODE'),
                                    "BUDG_CODE": grdRecord.get('BUDG_CODE'),
                                    "BUDG_GUBUN": detailForm.getValue('BUDG_GUBUN'),
                                    "ACCT_NO": records[0]['ACCT_NO']
                                    };
                            kocisCommonService.fnGetBudgetPossAmt_Kocis(param, function(provider, response)   {
            
                                if(!Ext.isEmpty(provider)){
                                    grdRecord.set('BUDG_I', provider.BUDG_I);
                                }else{
                                    grdRecord.set('BUDG_I', 0);
                                }
                            });*/
                            
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('BUDG_CODE'       ,'');
                            grdRecord.set('BUDG_NAME'       ,'');
                            grdRecord.set('ACCT_NO'         ,'');
                            grdRecord.set('SAVE_NAME'       ,'');
                            grdRecord.set('BANK_ACCOUNT'    ,'');
                            grdRecord.set('BUDG_I'          ,'');
                            grdRecord.set('CURR_UNIT'       ,'');
                            grdRecord.set('CURR_RATE'       ,'');

//                            grdRecord.set('BUDG_I'   ,'');
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('PAY_DATE')).substring(0, 4),
                                    'DEPT_CODE' : detailForm.getValue('DEPT_CODE'),
                                    'NEXT_GUBUN' : detailForm.getValue('NEXT_GUBUN') == true ? '1' : '2',
                                    'BUDG_GUBUN' : detailForm.getValue('BUDG_GUBUN'),
                                    
                                    'SAVE_CODE_GUBUN' : '1'
//                                    'ADD_QUERY' : gsCommonA171_Ref6 == '1' ? "GROUP_YN = 'N' " +
//                                                "AND USE_YN = 'Y'" : "BUDG_TYPE = '2' AND GROUP_YN = 'N' AND USE_YN = 'Y'"
                                }
                                popup.setExtParam(param);
                            }
                        }
                    }
                })
            },
            {dataIndex: 'BUDG_NAME'                   , width: 150,
                editor: Unilite.popup('BUDG_KOCIS_G',{
                    textFieldName: 'BUDG_NAME',
                    DBtextFieldName: 'BUDG_NAME',
                    autoPopup: true,
                    listeners:{ 
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            
                            grdRecord.set('BUDG_CODE'       ,records[0]['BUDG_CODE']);
                            grdRecord.set('BUDG_NAME'       ,records[0]['BUDG_NAME']);
                            grdRecord.set('ACCT_NO'         ,records[0]['ACCT_NO']);
                            grdRecord.set('SAVE_NAME'       ,records[0]['SAVE_NAME']);
                            grdRecord.set('BANK_ACCOUNT'    ,records[0]['BANK_ACCOUNT']);
                            grdRecord.set('BUDG_I'          ,records[0]['BUDG_I']);
                            grdRecord.set('CURR_UNIT'       ,records[0]['CURR_UNIT']);
                            grdRecord.set('CURR_RATE'       ,records[0]['CURR_RATE']);
                            
                   /*         var param = {"BUDG_YYYYMM": UniDate.getDbDateStr(detailForm.getValue('PAY_DATE')).substring(0, 6),
                                    "DEPT_CODE": detailForm.getValue('DEPT_CODE'),
                                    "BUDG_CODE": grdRecord.get('BUDG_CODE'),
                                    "BUDG_GUBUN": detailForm.getValue('BUDG_GUBUN'),
                                    "ACCT_NO": records[0]['ACCT_NO']
                                    };
                            kocisCommonService.fnGetBudgetPossAmt_Kocis(param, function(provider, response)   {
            
                                if(!Ext.isEmpty(provider)){
                                    grdRecord.set('BUDG_I', provider.BUDG_I);
                                }else{
                                    grdRecord.set('BUDG_I', 0);
                                }
                            });
                            */
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('BUDG_CODE'       ,'');
                            grdRecord.set('BUDG_NAME'       ,'');
                            grdRecord.set('ACCT_NO'         ,'');
                            grdRecord.set('SAVE_NAME'       ,'');
                            grdRecord.set('BANK_ACCOUNT'    ,'');
                            grdRecord.set('BUDG_I'          ,'');
                            grdRecord.set('CURR_UNIT'       ,'');
                            grdRecord.set('CURR_RATE'       ,'');
                            
//                            grdRecord.set('BUDG_I'   ,'');
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('PAY_DATE')).substring(0, 4),
                                    'DEPT_CODE' : detailForm.getValue('DEPT_CODE'),
                                    'NEXT_GUBUN' : detailForm.getValue('NEXT_GUBUN') == true ? '1' : '2',
                                    'BUDG_GUBUN' : detailForm.getValue('BUDG_GUBUN'),
                                    
                                    'SAVE_CODE_GUBUN' : '1'
//                                    'ADD_QUERY' : gsCommonA171_Ref6 == '1' ? "GROUP_YN = 'N' " +
//                                                "AND USE_YN = 'Y'" : "BUDG_TYPE = '2' AND GROUP_YN = 'N' AND USE_YN = 'Y'"
                                }
                                popup.setExtParam(param);
                            }
                        }
                    }
                })
            },
            {dataIndex: 'ACCT_NO'                   , width: 100,hidden:true},
            {dataIndex: 'SAVE_NAME'                   , width: 100},
            {dataIndex: 'BANK_ACCOUNT'                , width: 120},
            {dataIndex: 'BUDG_I'                      , width: 120},
            {dataIndex: 'PAY_DIVI'                    , width: 100},
            {dataIndex: 'CUSTOM_CODE'                 , width: 120, hidden:true,
                editor: Unilite.popup('CUST_KOCIS_G',{
                    textFieldName: 'CUSTOM_NAME',
                    DBtextFieldName: 'CUSTOM_NAME',
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                            grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                            
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE','');
                            grdRecord.set('CUSTOM_NAME','');
                          
                        }
                    }
                })
            },
            {dataIndex: 'CUSTOM_NAME'                 , width: 150,
                editor: Unilite.popup('CUST_KOCIS_G',{
                    textFieldName: 'CUSTOM_NAME',
                    DBtextFieldName: 'CUSTOM_NAME',
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                            grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                            
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE','');
                            grdRecord.set('CUSTOM_NAME','');
                          
                        }
                    }
                })
            },            
            {dataIndex: 'CHECK_NO'                  , width: 100},
            {dataIndex: 'CURR_UNIT'                 , width: 80},
            {dataIndex: 'LOC_AMT_I'                 , width: 120},
            {dataIndex: 'CURR_RATE'                 , width: 100},
            {dataIndex: 'TOT_AMT_I'                 , width: 120},
            {dataIndex: 'BUDG_GUBUN'                 , width: 120,hidden:true}
        
        
        
        
        
        
        
        /*
        
        
        
        
        
        
            { dataIndex: 'COMP_CODE'                    ,width:100,hidden:true},
            { dataIndex: 'PAY_DRAFT_NO'                     ,width:100,hidden:true},
            { dataIndex: 'DRAFT_SEQ'                    ,width:60,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
            },
            { dataIndex: 'BUDG_CODE'                    ,width:150,
                editor: Unilite.popup('BUDG_KOCIS_G',{
                    textFieldName: 'BUDG_NAME',
                    DBtextFieldName: 'BUDG_NAME',
                    autoPopup: true,
                    listeners:{ 
                        scope:this,
                        onSelected:function(records, type ) {
                            
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            
                            grdRecord.set('BUDG_CODE'       ,records[0]['BUDG_CODE']);
                            grdRecord.set('BUDG_NAME'       ,records[0]['BUDG_NAME']);
                            grdRecord.set('CURR_UNIT'       ,records[0]['CURR_UNIT']);
                            grdRecord.set('CURR_RATE'       ,records[0]['CURR_RATE']);
                            
                            var param = {"BUDG_YYYYMM": UniDate.getDbDateStr(detailForm.getValue('PAY_DATE')).substring(0, 6),
                                    "DEPT_CODE": detailForm.getValue('DEPT_CODE'),
                                    "BUDG_CODE": grdRecord.get('BUDG_CODE'),
                                    "BUDG_GUBUN": detailForm.getValue('BUDG_GUBUN'),
                                    "ACCT_NO": records[0]['ACCT_NO']
                                    };
                            kocisCommonService.fnGetBudgetPossAmt_Kocis(param, function(provider, response)   {
            
                                if(!Ext.isEmpty(provider)){
                                    grdRecord.set('BUDG_I', provider.BUDG_I);
                                }else{
                                    grdRecord.set('BUDG_I', 0);
                                }
                            });
                            
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('BUDG_CODE'       ,'');
                            grdRecord.set('BUDG_NAME'       ,'');
                            grdRecord.set('CURR_UNIT'       ,'');
                            grdRecord.set('CURR_RATE'       ,'');

//                            grdRecord.set('BUDG_I'   ,'');
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('PAY_DATE')).substring(0, 4),
                                    'DEPT_CODE' : detailForm.getValue('DEPT_CODE')
//                                    'ADD_QUERY' : gsCommonA171_Ref6 == '1' ? "GROUP_YN = 'N' " +
//                                                "AND USE_YN = 'Y'" : "BUDG_TYPE = '2' AND GROUP_YN = 'N' AND USE_YN = 'Y'"
                                }
                                popup.setExtParam(param);
                            }
                        }
                    }
                })
            },
            { dataIndex: 'BUDG_NAME'                    ,width:200,
                editor: Unilite.popup('BUDG_KOCIS_G',{
                    textFieldName: 'BUDG_NAME',
                    DBtextFieldName: 'BUDG_NAME',
                    autoPopup: true,
                    listeners:{ 
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            
                            grdRecord.set('BUDG_CODE'       ,records[0]['BUDG_CODE']);
                            grdRecord.set('BUDG_NAME'       ,records[0]['BUDG_NAME']);
                            grdRecord.set('CURR_UNIT'       ,records[0]['CURR_UNIT']);
                            grdRecord.set('CURR_RATE'       ,records[0]['CURR_RATE']);
                            
                            var param = {"BUDG_YYYYMM": UniDate.getDbDateStr(detailForm.getValue('PAY_DATE')).substring(0, 6),
                                    "DEPT_CODE": detailForm.getValue('DEPT_CODE'),
                                    "BUDG_CODE": grdRecord.get('BUDG_CODE'),
                                    "BUDG_GUBUN": detailForm.getValue('BUDG_GUBUN'),
                                    "ACCT_NO": records[0]['ACCT_NO']
                                    };
                            kocisCommonService.fnGetBudgetPossAmt_Kocis(param, function(provider, response)   {
            
                                if(!Ext.isEmpty(provider)){
                                    grdRecord.set('BUDG_I', provider.BUDG_I);
                                }else{
                                    grdRecord.set('BUDG_I', 0);
                                }
                            });
                            
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('BUDG_CODE'       ,'');
                            grdRecord.set('BUDG_NAME'       ,'');
                            grdRecord.set('CURR_UNIT'       ,'');
                            grdRecord.set('CURR_RATE'       ,'');
                            
//                            grdRecord.set('BUDG_I'   ,'');
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('PAY_DATE')).substring(0, 4),
                                    'DEPT_CODE' : detailForm.getValue('DEPT_CODE')
//                                    'ADD_QUERY' : gsCommonA171_Ref6 == '1' ? "GROUP_YN = 'N' " +
//                                                "AND USE_YN = 'Y'" : "BUDG_TYPE = '2' AND GROUP_YN = 'N' AND USE_YN = 'Y'"
                                }
                                popup.setExtParam(param);
                            }
                        }
                    }
                })
            },
            { dataIndex: 'BUDG_I'                ,width:120},
            { dataIndex: 'CURR_UNIT'                    ,width:100},
            { dataIndex: 'CURR_RATE'                    ,width:100},
            { dataIndex: 'WON_AMT'                      ,width:120,summaryType:'sum'},
            { dataIndex: 'BUDG_AMT'                     ,width:120,summaryType:'sum'},
            { dataIndex: 'DRAFT_REMIND_AMT'             ,width:120,summaryType:'sum'},
            { dataIndex: 'CLOSE_YN'                     ,width:100}*/
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['BUDG_CODE','BUDG_NAME','PAY_DIVI','CUSTOM_CODE','CUSTOM_NAME','LOC_AMT_I','CHECK_NO'])){//추후 추가 필요 
					return true;	
				}else{
					return false;	
				}
			}
        },
        
        setNewDataCopy:function(record){
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('COMP_CODE'       	,record['COMP_CODE']);
//			grdRecord.set('PAY_DRAFT_NO'        	,record['PAY_DRAFT_NO']);
			grdRecord.set('DRAFT_SEQ'       	,record['DRAFT_SEQ']);
			grdRecord.set('BUDG_CODE'       	,record['BUDG_CODE']);
			grdRecord.set('BUDG_NAME'       	,record['BUDG_NAME']);
			grdRecord.set('BUDG_I'   	,record['BUDG_I']);
			grdRecord.set('CURR_UNIT'       	,record['CURR_UNIT']);
			grdRecord.set('CURR_RATE'       	,record['CURR_RATE']);
			grdRecord.set('WON_AMT'         	,record['WON_AMT']);
			grdRecord.set('BUDG_AMT'        	,record['BUDG_AMT']);
			grdRecord.set('DRAFT_REMIND_AMT'	,record['DRAFT_REMIND_AMT']);
			grdRecord.set('CLOSE_YN'        	,'Y');
		}
    });   
    
	 Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				detailGrid, detailForm
			]
		}], 
		id : 'Afb700ukrApp',
		fnInitBinding : function(params) {
			
			var param= Ext.getCmp('detailForm').getValues();
//			param.budgNameInfoList = budgNameList;	//예산목록
//			detailForm.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
//			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
//			detailForm.setValue('PAY_DATE', UniDate.get('today'));
//			panelResult.setValue('PAY_DATE', UniDate.get('today'));
			UniAppManager.setToolbarButtons(['newData'],true);
			UniAppManager.setToolbarButtons(['query'],false);

			this.setDefault(params);
//			this.processParams(params);
			detailForm.onLoadSelectText('PAY_DATE');
		},
		onQueryButtonDown : function()	{
			directMasterStore.loadStoreRecords();
			directDetailStore.loadStoreRecords();
//			setTimeout("edit.completeEdit()", 1000);
			
//			setTimeout(function(){
//				UniAppManager.app.fnDispMasterData('QUERY');
//			}
//				, 5000
//				
//			)
//			alert('ssss');
			
		},
		onNewDataButtonDown: function(copyCheck) {
			if(!detailForm.getInvalidMessage()) return false;
			
//			var compCode   = UserInfo.compCode;
			var draftNo	   = detailForm.getValue('PAY_DRAFT_NO');
			
			var seq = directDetailStore.max('SEQ');
            	 if(!seq){
            	 	seq = 1;
            	 }else{
            	 	seq += 1;
            	 }
			var budgGubun  = detailForm.getValue('BUDG_GUBUN');
			var closeYn	   = detailForm.getValue('CLOSE_YN');
			
            var r = {
//        	 	COMP_CODE    : compCode,
        	 	PAY_DRAFT_NO	 : draftNo,
        	 	SEQ	 : seq,
        	 	BUDG_GUBUN	 : budgGubun,
				CLOSE_YN     : closeYn
	        };
	        if(copyCheck == 'Y'){
	        	
	        	
	        	
	        	
	        	detailGrid.createRow(r);	
	        }else{
				detailGrid.createRow(r,'BUDG_CODE');
	        }
				
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
					PAY_DRAFT_NO: detailForm.getValue('PAY_DRAFT_NO'),
					PAY_USER  : detailForm.getValue('PAY_USER'),
					PASSWORD  : detailForm.getValue('PASSWORD')
				}
				detailForm.getEl().mask('전체삭제 중...','loading-indicator');
				detailGrid.getEl().mask('전체삭제 중...','loading-indicator');
				s_afb700ukrkocisService.afb700ukrDelA(param, function(provider, response)	{							
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
			if(params.PGM_ID == 's_afb700skr_KOCIS') {
				
				detailForm.setValue('PAY_DRAFT_NO',params.PAY_DRAFT_NO);
				
				this.onQueryButtonDown();
			}/* else if(params.PGM_ID == 'afb555skr') {
				detailForm.setValue('PAY_DRAFT_NO',params.PAY_DRAFT_NO);
				this.onQueryButtonDown();
			}*/
		},
		setDefault: function(params){
			
//			UniAppManager.app.fnInitInputProperties();
			
			if(!Ext.isEmpty(params.PAY_DRAFT_NO)){
                UniAppManager.app.fnInitInputFields();
				this.processParams(params);
			}else{
				UniAppManager.app.fnInitInputFields();	
			}
			
		},
		/**
		 * 입력란의 속성 설정 (입력가능여부 등)
		 */
		fnInitInputProperties: function() {
//		'프로그램의 사업장권한이 전체(멀티)권한이 아닌 경우, 사업장 비활성화 처리	
//			If gsAuParam(0) <> "N" Then
//        cboDivCode.disabled = True
//        btnDivCode.disabled = True
//    End If
			
			
		},

		/**
		 * 입력란의 초기값 설정
		 */
		fnInitInputFields: function(){
			detailForm.setValue('PAY_DATE', UniDate.get('today'));
			
			
			
			detailForm.setValue('PAY_USER',UserInfo.userID);
			detailForm.setValue('PAY_USER_NAME',UserInfo.userName);
			
			detailForm.setValue('PAY_DRAFT_NO','');
			
			detailForm.setValue('PASSWORD','');
			
			detailForm.setValue('BUDG_GUBUN','1');
			
//			detailForm.setValue('PAY_USER_PN',gsDrafter);
//			detailForm.setValue('PAY_USER_NM',gsDrafterNm);
			
//			detailForm.setValue('DIV_CODE',gsDivCode);
			
			detailForm.setValue('ACCNT_GUBUN','6');
			
//			UniAppManager.app.fnGetA171RefCode();
			
//			detailForm.setValue('DEPT_CODE',gsDeptCode);
//			detailForm.setValue('DEPT_NAME',gsDeptName);
			
			detailForm.setValue('TITLE','');
			
            detailForm.setValue('AC_TYPE','01');  
            detailForm.setValue('CLOSE_YN','Y');
			
			detailForm.setValue('HDD_CONFIRM_YN','N');	
			
			detailForm.setValue('HDD_CLOSE_YN','N');
			detailForm.setValue('HDD_INSERT_DB_USER','');
			detailForm.setValue('HDD_SAVE_TYPE','N');
			detailForm.setValue('HDD_COPY_DATA','');
			
			
			
			
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
		 * 예산기안 마스터정보 표시
		 */
		fnDispMasterData:function(qryType){
			if(qryType == 'COPY'){
				detailForm.setValue('PAY_DATE',UniDate.get('today'));
//				panelResult.setValue('PAY_DATE',UniDate.get('today'));
				
				
//				detailForm.setValue('DRAFTER',gsDrafter);
//				detailForm.setValue('DRAFT_NAME',gsDrafterNm);
				
				detailForm.setValue('PAY_DRAFT_NO','');
				
			}else if(qryType == 'QUERY'){
				if(directMasterStore.getCount() == 0){
					detailForm.setValue('PAY_DATE','');
					
//					detailForm.setValue('PAY_USER','');
//					detailForm.setValue('PAY_USER_NAME','');
					
                    detailForm.setValue('PAY_DRAFT_NO','');
					detailForm.setValue('BUDG_GUBUN','');
					
				
					
					detailForm.setValue('TITLE','');
					
					detailForm.setValue('NEXT_GUBUN','false');
                    detailForm.setValue('AC_GUBUN','');
                    detailForm.setValue('AC_TYPE','01');
					
                    detailForm.setValue('CONTRACT_GUBUN','');
                    
                 
				}else{
					/*detailForm.setValue('PAY_DATE','20160101');
					panelResult.setValue('PAY_DATE','20160101');
					*/
					var masterRecord = directMasterStore.data.items[0];	
					
					detailForm.setValue('PAY_DATE',masterRecord.data.PAY_DATE);
					
                    detailForm.setValue('DEPT_CODE',masterRecord.data.DEPT_CODE);
                    
					detailForm.setValue('PAY_USER',masterRecord.data.PAY_USER);
					detailForm.setValue('PAY_USER_NAME',masterRecord.data.PAY_USER_NAME);
					
					detailForm.setValue('PAY_DRAFT_NO',masterRecord.data.PAY_DRAFT_NO);
					
					detailForm.getField('STATUS').setValue(masterRecord.data.STATUS);
					
					detailForm.setValue('BUDG_GUBUN',masterRecord.data.BUDG_GUBUN);
					
				
					detailForm.setValue('TITLE',masterRecord.data.TITLE);
			
					detailForm.setValue('NEXT_GUBUN',masterRecord.data.NEXT_GUBUN);
					detailForm.setValue('AC_GUBUN',masterRecord.data.AC_GUBUN);
					detailForm.setValue('AC_TYPE',masterRecord.data.AC_TYPE);
					
					detailForm.setValue('CONTRACT_GUBUN',masterRecord.data.CONTRACT_GUBUN);
					
//				
				}
			}			
		},
		
		/**
		 * 결재상신 관련
		 */
		fnApproval: function(){
			
			openDocDetailWin_GW("3","2",null);
			
//			Ext.Msg.alert("버튼이 결재상신 일때","빌드중(추후개발예정)");
			
//		var url = CHOST + CPATH + '/accnt/afs100ukr.do?COMP_CODE='+ UserInfo.compCode;// + '&KEY_VALUE='+gwKeyValue;
//		window.open(url,"_blank ","width=730,height=500.location=yes,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no");
		}
		

	/*	
		fnConfirm: function(){
			var param= Ext.getCmp('detailForm').getValues();
			posAmtStore.load({
				params : param,
				callback : function(records, operation, success) {
					if(success)	{
						pro1Store.load({
							params : param,
							callback : function(records, operation, success) {
								if(success)	{
									detailForm.setValue('HDD_CONFIRM_YN',records[0].data.CONFIRM_YN);
									if(gsLinkedGW == 'N'){
										if(detailForm.getValue('HDD_CONFIRM_YN') == 'Y'){
											detailForm.down('#btnProcPR').setText(Msg.fSbMsgA0433);
										}else{
											detailForm.down('#btnProcPR').setText(Msg.fSbMsgA0434);	
										}
									}
									if(gsConfirm == 'Y'){
										if(detailForm.getValue('HDD_CONFIRM_YN') == 'Y'){
											detailForm.down('#btnConfirmPR').setText(Msg.fSbMsgA0433);
											
											detailForm.getField('STATUS').setValue('9');
											
											Ext.getCmp('btnProcPR').setDisabled(true);	
											Ext.getCmp('btnReCancelPR').setDisabled(true);	
										}else{
											detailForm.down('#btnConfirmPR').setText(Msg.fSbMsgA0511);
											
											detailForm.getField('STATUS').setValue('0');
											
											Ext.getCmp('btnProcPR').setDisabled(false);	
											Ext.getCmp('btnReCancelPR').setDisabled(false);	
										}
									}
									Ext.Msg.alert("확인",Msg.sMB021);	
								}else{
									return false;
								}
							}
						});					
					}else{
						return false;
					}
				}
			}); 
		}*/
	});
	
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "LOC_AMT_I" :
                    if(newValue < 0) {
                        rv='<t:message code = "unilite.msg.sMP570"/>';
                        break;
                    }
                    
					record.set('TOT_AMT_I', newValue * record.get('CURR_RATE'));
					break;
			}
			return rv;
		}
	});	
/*	Unilite.createValidator('validator02', {
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
