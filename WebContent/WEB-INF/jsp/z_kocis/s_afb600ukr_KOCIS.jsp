<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb600ukr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_afb600ukr_KOCIS" /> 	<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A170" />			<!-- 예산구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A020"  /> 		<!-- 예/아니오 -->
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

	var budgNameList = ${budgNameList};
	var budgNameListLength = budgNameList.length;
	
	var gsIdMapping = '${gsIdMapping}';
	var gsLinkedGW = '${gsLinkedGW}';
	var gsConfirm = '${gsConfirm}';
	var gsConButtonYN = '${gsConButtonYN}';
	var gsLineCopy = '${gsLineCopy}';
	
	var gsDrafter = '${gsDrafter}';
	var gsDrafterNm = '${gsDrafterNm}';
	var gsDeptCode = '${gsDeptCode}';
	var gsDeptName = '${gsDeptName}';
	var gsDivCode = '${gsDivCode}';
	
	var gsPathInfo1 = '${gsPathInfo1}';
	var gsPathInfo2 = '${gsPathInfo2}';
	var gsPathInfo3 = '${gsPathInfo3}';
	
	var selectCheck4 = '${selectCheck4}';
	var selectCheck5 = '${selectCheck5}';
	
	var gsConfirmer = "";
	var gsAmender = "";
	
	if(selectCheck4 == ""){
		gsConfirmer = "N";
	}else{
		gsConfirmer = "Y";
	}
	
	if(selectCheck5 == ""){
		gsAmender = "N";
	}else{
		gsAmender = "Y";
	}
	
	
	var gsCommonA171_Ref6 = "";
	
function appMain() {
	var fields	= createModelField(budgNameList);
	var columns	= createGridColumn(budgNameList);
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_afb600ukrService_KOCIS.selectDetail',
			update: 's_afb600ukrService_KOCIS.updateDetail',
			create: 's_afb600ukrService_KOCIS.insertDetail',
			destroy: 's_afb600ukrService_KOCIS.deleteDetail',
			syncAll: 's_afb600ukrService_KOCIS.saveAll'
		}
	});	
	Unilite.defineModel('Afb600ukrModel', {
        fields: [
            {name: 'COMP_CODE'          , text: '법인코드'              , type: 'string'},
            {name: 'DRAFT_NO'           , text: 'DRAFT_NO'           , type: 'string'},
            {name: 'DRAFT_SEQ'          , text: '순번'                , type: 'uniNumber'},
            {name: 'BUDG_CODE'          , text: '예산과목'              , type: 'string',allowBlank:false},
            {name: 'BUDG_NAME'          , text: '예산명'               , type: 'string',allowBlank:false},
            {name: 'BUDG_POSS_AMT'      , text: '예산사용금액'           , type: 'uniPrice'},
            {name: 'CURR_UNIT'          , text: '적용화폐단위'           , type: 'string',comboType:'AU', comboCode:'B004'},
            {name: 'CURR_RATE'          , text: '환율'                , type: 'uniER'},
            {name: 'WON_AMT'            , text: '금액'                , type: 'uniPrice',allowBlank:false},
            {name: 'BUDG_AMT'           , text: '기안예산금액'           , type: 'uniPrice',allowBlank:false},
            {name: 'DRAFT_REMIND_AMT'   , text: '기안잔액'              , type: 'uniPrice'},
            {name: 'CLOSE_YN'           , text: '마감여부'              , type: 'string',allowBlank:false,comboType:'AU', comboCode:'A020'}
            
        ]
	});	
	  
	var directMasterStore = Unilite.createStore('Afb600ukrDirectMasterStore',{
        proxy: {
           type: 'direct',
            api: {			
                read: 's_afb600ukrService_KOCIS.selectMaster'                	
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
           			UniAppManager.setToolbarButtons(['reset','newData','delete','deleteAll'],true);
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
	
	var directDetailStore = Unilite.createStore('Afb600ukrDirectDetailStore',{
		model: 'Afb600ukrModel',
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
			param.budgNameInfoList = budgNameList;	//예산목록	
			param.budgNameListLength = budgNameListLength;
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
//			checkMasterOnly = '';
			var paramMaster= detailForm.getValues();
			paramMaster.RETURN_CODE = gsCommonA171_Ref6;
			if(detailForm.getValue('NEXT_MONTH') == false){
                paramMaster.NEXT_MONTH = 'N';
			}
				
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
        	
        	var confRecords = directDetailStore.data.items;
        	if(Ext.isEmpty(detailForm.getValue('DRAFT_NO')) && Ext.isEmpty(confRecords)){
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
							detailForm.setValue("DRAFT_NO", master.DRAFT_NO);
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
	
	var posAmtStore = Unilite.createStore('Afb600ukrPosAmtStore',{
		proxy: {
           type: 'direct',
            api: {			
                read: 's_afb600ukrService_KOCIS.posAmt'                	
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
 /*          		if(testStore.getCount() > 0){
           			Ext.Msg.alert("확인",Msg.sMB022);
           			
//           			return false;
           		}*/
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	var pro1Store = Unilite.createStore('Afb600ukrPro1Store',{
		proxy: {
           type: 'direct',
            api: {			
                read: 's_afb600ukrService_KOCIS.pro1'                	
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
 /*          		if(testStore.getCount() > 0){
           			Ext.Msg.alert("확인",Msg.sMB022);
           			
//           			return false;
           		}*/
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	var reCancelStore = Unilite.createStore('Afb600ukrReCancelStore',{
		proxy: {
           type: 'direct',
            api: {			
                read: 's_afb600ukrService_KOCIS.reCancel'                	
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
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	
	var pro2Store = Unilite.createStore('Afb600ukrPro2Store',{
		proxy: {
           type: 'direct',
            api: {			
                read: 's_afb600ukrService_KOCIS.pro2'                	
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
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
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
        		fieldLabel: '기안일',
        		labelWidth:150,
    		    xtype: 'uniDatefield',
    //		    id:'draftDatePR',
    		    name: 'DRAFT_DATE',
    		    value: UniDate.get('today'),
    		    allowBlank: false  
    		},{
                xtype: 'uniCheckboxgroup',  
                fieldLabel: '',
                items: [{
                    boxLabel: '13월분',
                    width: 60,
                    name: 'NEXT_MONTH',
                    inputValue: 'Y',
                    checked: true
                }]
            }]
		},
		Unilite.popup('Employee', {
			fieldLabel: '기안자', 
			labelWidth:150,
			valueFieldName: 'DRAFTER',
    		textFieldName: 'DRAFT_NAME',
    		tdAttrs: {width:'100%',align : 'left'}, 
            allowBlank: false,
//		    		validateBlank:false,
    		autoPopup:true
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
//					if(detailForm.getValue('DRAFT_NO') == ''){
//						Ext.Msg.alert("확인",Msg.fSbMsgA0199);
//					}else{
//							UniAppManager.app.fnApproval();
//					}
				}
	    	}]
    	},{ 
    		fieldLabel: '기안번호',
    		labelWidth:150,
		    xtype: 'uniTextfield',
		    name: 'DRAFT_NO',
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
					if(detailForm.getValue('DRAFT_NO') == ''){
						return false;
					}else{
						
						detailGrid.reset();
						directDetailStore.clearData();
						
						var param = {"DRAFT_NO": detailForm.getValue('DRAFT_NO'),
								
								"budgNameInfoList": budgNameList,
								"budgNameListLength": budgNameListLength
						};
						s_afb600ukrService_KOCIS.selectDetail(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								Ext.each(provider, function(record,i){
									UniAppManager.app.onNewDataButtonDown('Y');
					        		detailGrid.setNewDataCopy(record);	
								});
							}
						});
						
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
        },
		{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            tdAttrs: {align : 'left',width:120},
//              id:'hiddenContainerPR',
            defaults : {enforceMaxLength: true},
//             tdAttrs: {align : 'left'},
            items :[{
                xtype: 'button',
                text: '기안마감',   
                id: 'btnClosePR',
                name: 'CLOSE',
                width: 110, 
                handler : function() {
                    if(detailForm.getValue('DRAFT_NO') == ''){
                        return false;   
                    }
                    if(confirm(Msg.fSbMsgA0530)) {
                        var param= Ext.getCmp('detailForm').getValues();
                        pro2Store.load({
                            params : param,
                            callback : function(records, operation, success) {
                                if(success) {
                                    
//              이거뭐여                grdSheet1.Cell(0, csHeaderRowsCnt, grdSheet1.ColIndex("CLOSE_YN")
//                                  ,grdSheet1.Rows-1, grdSheet1.ColIndex("CLOSE_YN")) = oRs("CLOSE_YN")
                                    
                                    detailForm.setValue('HDD_CLOSE_YN',records[0].data.CLOSE_YN);
                                    
                                    Ext.getCmp('btnClosePR').setDisabled(true); 
                                    UniAppManager.app.onQueryButtonDown();
//                                  Ext.Msg.alert("확인",Msg.sMB021); 
                                }else{
                                    return false;
                                }
                            }
                        }); 
                    }
//                  ,,,,
                }
            }]
        },{ 
    		fieldLabel: '기안제목',
    		labelWidth:150,
		    xtype: 'uniTextfield',
		    name: 'TITLE',
		    width: 500,
		    allowBlank: false,
		    tdAttrs: {width:1000/*align : 'center'*/}
		    //tdAttrs: {align : 'center'},
		
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:500,
//				id:'hiddenContainerPR',
			tdAttrs: {width:'100%',align : 'left'}, 
			defaults : {enforceMaxLength: true},
//			   tdAttrs: {align : 'left'},
//			colspan:2,
			items :[{
				xtype: 'radiogroup',		            		
				fieldLabel: '상태',
				labelWidth:150,
				id:'statusPR',
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
//						detailForm.getField('STATUS').setValue(newValue.STATUS);					
//						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]
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
            fieldLabel: '마감여부(자동)',
            labelWidth:150,
            name: 'CLOSE_YN',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'A020',
            allowBlank: false,
            tdAttrs: {width:'100%',align : 'left'}
//           colspan:2
        },{
            xtype:'component'
        },{
		   xtype: 'container',
		   layout: {type : 'uniTable', columns : 7},
		   width:500,
		   colspan:3,
		   defaults : {width:200,labelWidth:130},
		   items :[{
	    		fieldLabel: '예산확정여부(HDD_CONFIRM_YN)',
			    xtype: 'uniTextfield',
			    name: 'HDD_CONFIRM_YN',
			    hidden:true
	    	},{
	    		fieldLabel: '상태(HDD_STATUS)',
			    xtype: 'uniTextfield',
			    name: 'HDD_STATUS',
			    hidden:true
	    	},{
	    		fieldLabel: '기안마감여부(HDD_CLOSE_YN)',
			    xtype: 'uniTextfield',
			    name: 'HDD_CLOSE_YN',
			    hidden:true
	    	},{
	    		fieldLabel: '최초입력자(HDD_INSERT_DB_USER)',
			    xtype: 'uniTextfield',
			    name: 'HDD_INSERT_DB_USER',
			    hidden:true
	    	},{
	    		fieldLabel: '저장유형(HDD_SAVE_TYPE)',
			    xtype: 'uniTextfield',
			    name: 'HDD_SAVE_TYPE',
			    hidden:true
	    	},{
	    		fieldLabel: '복사자료(HDD_COPY_DATA)',
			    xtype: 'uniTextfield',
			    name: 'HDD_COPY_DATA',
			    hidden:true
	    	},{
	    		fieldLabel: '전자결재 연동상태(HDD_GW_STATUS)',
			    xtype: 'uniTextfield',
			    name: 'HDD_GW_STATUS',
			    hidden:true
	    	}]
    	}],
    	api: {
//	 		load: 'atx600ukrService.selectForm'	,
	 		submit: 's_afb600ukrService_KOCIS.syncMaster'	
		}/*,	
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}*/
	});
	
    /* Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var detailGrid = Unilite.createGrid('Afb600ukrGrid', {
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
            { dataIndex: 'COMP_CODE'                    ,width:100,hidden:true},
            { dataIndex: 'DRAFT_NO'                     ,width:100,hidden:true},
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
                            
                            var param = {"BUDG_YYYYMM": UniDate.getDbDateStr(detailForm.getValue('DRAFT_DATE')).substring(0, 6),
                                    "DEPT_CODE": detailForm.getValue('DEPT_CODE'),
                                    "BUDG_CODE": grdRecord.get('BUDG_CODE'),
                                    "BUDG_GUBUN": detailForm.getValue('BUDG_GUBUN'),
                                    "ACCT_NO": records[0]['ACCT_NO']
                                    };
                            kocisCommonService.fnGetBudgetPossAmt_Kocis(param, function(provider, response)   {
            
                                if(!Ext.isEmpty(provider)){
                                    grdRecord.set('BUDG_POSS_AMT', provider.BUDG_POSS_AMT);
                                }else{
                                    grdRecord.set('BUDG_POSS_AMT', 0);
                                }
                            });
                            
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('BUDG_CODE'       ,'');
                            grdRecord.set('BUDG_NAME'       ,'');
                            grdRecord.set('CURR_UNIT'       ,'');
                            grdRecord.set('CURR_RATE'       ,'');

//                            grdRecord.set('BUDG_POSS_AMT'   ,'');
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('DRAFT_DATE')).substring(0, 4),
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
                            
                            var param = {"BUDG_YYYYMM": UniDate.getDbDateStr(detailForm.getValue('DRAFT_DATE')).substring(0, 6),
                                    "DEPT_CODE": detailForm.getValue('DEPT_CODE'),
                                    "BUDG_CODE": grdRecord.get('BUDG_CODE'),
                                    "BUDG_GUBUN": detailForm.getValue('BUDG_GUBUN'),
                                    "ACCT_NO": records[0]['ACCT_NO']
                                    };
                            kocisCommonService.fnGetBudgetPossAmt_Kocis(param, function(provider, response)   {
            
                                if(!Ext.isEmpty(provider)){
                                    grdRecord.set('BUDG_POSS_AMT', provider.BUDG_POSS_AMT);
                                }else{
                                    grdRecord.set('BUDG_POSS_AMT', 0);
                                }
                            });
                            
                            
                            
                        /*    var param = {"BUDG_YYYYMM": UniDate.getDbDateStr(detailForm.getValue('DRAFT_DATE')).substring(0, 6),
                                    "DEPT_CODE": detailForm.getValue('DEPT_CODE'),
                                    "BUDG_CODE": grdRecord.get('BUDG_CODE'),
                                    "BUDG_GUBUN": grdRecord.get('BUDG_GUBUN')
                                    };
                            accntCommonService.fnGetBudgetPossAmt(param, function(provider, response)   {
            
                                if(!Ext.isEmpty(provider)){
                                    grdRecord.set('BUDG_POSS_AMT', provider.BUDG_POSS_AMT);
                                }else{
                                    grdRecord.set('BUDG_POSS_AMT', 0);
                                }
                            });
                            */
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('BUDG_CODE'       ,'');
                            grdRecord.set('BUDG_NAME'       ,'');
                            grdRecord.set('CURR_UNIT'       ,'');
                            grdRecord.set('CURR_RATE'       ,'');
                            
//                            grdRecord.set('BUDG_POSS_AMT'   ,'');
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('DRAFT_DATE')).substring(0, 4),
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
            { dataIndex: 'BUDG_POSS_AMT'                ,width:120},
            { dataIndex: 'CURR_UNIT'                    ,width:100},
            { dataIndex: 'CURR_RATE'                    ,width:100},
            { dataIndex: 'WON_AMT'                      ,width:120,summaryType:'sum'},
            { dataIndex: 'BUDG_AMT'                     ,width:120,summaryType:'sum'},
            { dataIndex: 'DRAFT_REMIND_AMT'             ,width:120,summaryType:'sum'},
            { dataIndex: 'CLOSE_YN'                     ,width:100}
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['BUDG_CODE','BUDG_NAME','WON_AMT','BUDG_AMT','CLOSE_YN'])){//추후 추가 필요 
					return true;	
				}else{
					return false;	
				}
			}
        },
        
        setNewDataCopy:function(record){
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('COMP_CODE'       	,record['COMP_CODE']);
//			grdRecord.set('DRAFT_NO'        	,record['DRAFT_NO']);
			grdRecord.set('DRAFT_SEQ'       	,record['DRAFT_SEQ']);
			grdRecord.set('BUDG_CODE'       	,record['BUDG_CODE']);
			grdRecord.set('BUDG_NAME'       	,record['BUDG_NAME']);
			grdRecord.set('BUDG_POSS_AMT'   	,record['BUDG_POSS_AMT']);
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
		id : 'Afb600ukrApp',
		fnInitBinding : function(params) {
			
			var param= Ext.getCmp('detailForm').getValues();
			param.budgNameInfoList = budgNameList;	//예산목록
//			detailForm.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
//			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
//			detailForm.setValue('DRAFT_DATE', UniDate.get('today'));
//			panelResult.setValue('DRAFT_DATE', UniDate.get('today'));
			UniAppManager.setToolbarButtons(['newData'],true);
			UniAppManager.setToolbarButtons(['query'],false);

			this.setDefault(params);
//			this.processParams(params);
			detailForm.onLoadSelectText('DRAFT_DATE');
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
			
			var compCode   = UserInfo.compCode;
			var draftNo	   = detailForm.getValue('DRAFT_NO');
			
			var seq = directDetailStore.max('DRAFT_SEQ');
            	 if(!seq){
            	 	seq = 1;
            	 }else{
            	 	seq += 1;
            	 }
			var budgGubun  = detailForm.getValue('BUDG_GUBUN');
			var closeYn	   = detailForm.getValue('CLOSE_YN');
			
            var r = {
        	 	COMP_CODE    : compCode,
        	 	DRAFT_NO	 : draftNo,
        	 	DRAFT_SEQ	 : seq,
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
					DRAFT_NO: detailForm.getValue('DRAFT_NO'),
					DRAFTER  : detailForm.getValue('DRAFTER'),
					PASSWORD  : detailForm.getValue('PASSWORD')
				}
				detailForm.getEl().mask('전체삭제 중...','loading-indicator');
				detailGrid.getEl().mask('전체삭제 중...','loading-indicator');
				s_afb600ukrService_KOCIS.afb600ukrDelA(param, function(provider, response)	{							
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
			
			if(params.PGM_ID == 'afb600skr') {
				
				detailForm.setValue('DRAFT_NO',params.DRAFT_NO);
				
				
//				detailForm.setValue('AC_DATE_FR',params.AC_DATE);
//				detailForm.setValue('AC_DATE_TO',params.AC_DATE);
//				detailForm.setValue('INPUT_PATH',params.INPUT_PATH);
//				detailForm.setValue('DIV_CODE',params.DIV_CODE);
//				
//				panelResult.setValue('AC_DATE_FR',params.AC_DATE);
//				panelResult.setValue('AC_DATE_TO',params.AC_DATE);
//				panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
//				panelResult.setValue('DIV_CODE',params.DIV_CODE);
				
				this.onQueryButtonDown();
			} else if(params.PGM_ID == 'afb555skr') {
				detailForm.setValue('DRAFT_NO',params.DRAFT_NO);
//				detailForm.setValue('DRAFT_DATE',params.DRAFT_DATE);
//				panelResult.setValue('DRAFT_DATE',params.DRAFT_DATE);
//				detailForm.setValue('TITLE',params.DRAFT_TITLE);
//				panelResult.setValue('TITLE',params.DRAFT_TITLE);
				this.onQueryButtonDown();
			}
		},
		setDefault: function(params){
			
			UniAppManager.app.fnInitInputProperties();
			
			if(!Ext.isEmpty(params.DRAFT_NO)){
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
			detailForm.setValue('DRAFT_DATE', UniDate.get('today'));
			
			detailForm.setValue('DRAFTER',gsDrafter);
			detailForm.setValue('DRAFT_NAME',gsDrafterNm);
			
			detailForm.setValue('DRAFT_NO','');
			
			detailForm.setValue('PASSWORD','');
			
			detailForm.setValue('BUDG_GUBUN','1');
			
			detailForm.setValue('PAY_USER_PN',gsDrafter);
			detailForm.setValue('PAY_USER_NM',gsDrafterNm);
			
			detailForm.setValue('DIV_CODE',gsDivCode);
			
			detailForm.setValue('ACCNT_GUBUN','6');
			
//			UniAppManager.app.fnGetA171RefCode();
			
			detailForm.setValue('DEPT_CODE',gsDeptCode);
			detailForm.setValue('DEPT_NAME',gsDeptName);
			
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
				detailForm.setValue('DRAFT_DATE',UniDate.get('today'));
//				panelResult.setValue('DRAFT_DATE',UniDate.get('today'));
				
				
				detailForm.setValue('DRAFTER',gsDrafter);
				detailForm.setValue('DRAFT_NAME',gsDrafterNm);
				
				detailForm.setValue('DRAFT_NO','');
				
				detailForm.setValue('HDD_CONFIRM_YN','N');
				
				detailForm.setValue('HDD_GW_STATUS','');
				
				
				detailForm.setValue('HDD_CLOSE_YN','N');
				Ext.getCmp('btnClosePR').enable();
				detailForm.setValue('HDD_INSERT_DB_USER','');
				detailForm.setValue('HDD_SAVE_TYPE','N');
				detailForm.setValue('HDD_COPY_DATA','Y');
				
			}else if(qryType == 'QUERY'){
				if(directMasterStore.getCount() == 0){
					detailForm.setValue('DRAFT_DATE','');
					
					detailForm.setValue('DRAFTER','');
					detailForm.setValue('DRAFT_NAME','');
					
					detailForm.setValue('BUDG_GUBUN','');
					
					detailForm.setValue('PAY_USER_PN','');
					detailForm.setValue('PAY_USER_NM','');
					
					detailForm.setValue('DIV_CODE','');
					
					detailForm.setValue('DEPT_CODE','');
					detailForm.setValue('DEPT_NAME','');
					
					detailForm.setValue('TITLE','');
					
					detailForm.setValue('NEXT_MONTH','');
                    detailForm.setValue('AC_GUBUN','');
                    detailForm.setValue('AC_TYPE','01');
                    detailForm.setValue('CLOSE_YN','Y');
					detailForm.setValue('HDD_CONFIRM_YN','N');
					
					detailForm.setValue('HDD_GW_STATUS','');
					
					
					detailForm.setValue('HDD_CLOSE_YN','N');
					Ext.getCmp('btnClosePR').enable();
					
					detailForm.setValue('HDD_INSERT_DB_USER','');
					
					detailForm.setValue('HDD_SAVE_TYPE','N');
					
					detailForm.setValue('HDD_COPY_DATA','');
					
				}else{
					
					/*detailForm.setValue('DRAFT_DATE','20160101');
					panelResult.setValue('DRAFT_DATE','20160101');
					*/
					var masterRecord = directMasterStore.data.items[0];	
					
					detailForm.setValue('DRAFT_DATE',masterRecord.data.DRAFT_DATE);
					
					detailForm.setValue('DRAFTER',masterRecord.data.DRAFTER);
					detailForm.setValue('DRAFT_NAME',masterRecord.data.DRAFTER_NM);
					
					detailForm.setValue('DRAFT_NO',masterRecord.data.DRAFT_NO);
					
					detailForm.getField('STATUS').setValue(masterRecord.data.STATUS);
					
					detailForm.setValue('BUDG_GUBUN',masterRecord.data.BUDG_GUBUN);
					
					detailForm.setValue('PAY_USER_PN',masterRecord.data.PAY_USER);
					detailForm.setValue('PAY_USER_NM',masterRecord.data.PAY_USER_NM);
					
					detailForm.setValue('DIV_CODE',masterRecord.data.DIV_CODE);
					
					detailForm.setValue('DEPT_CODE',masterRecord.data.DEPT_CODE);
					detailForm.setValue('DEPT_NAME',masterRecord.data.DEPT_NAME);
					
					detailForm.setValue('TITLE',masterRecord.data.TITLE);
					
					detailForm.setValue('ACCNT_GUBUN',masterRecord.data.ACCNT_GUBUN);
					
					
					detailForm.setValue('NEXT_MONTH',masterRecord.data.NEXT_MONTH);
					detailForm.setValue('AC_GUBUN',masterRecord.data.AC_GUBUN);
					detailForm.setValue('AC_TYPE',masterRecord.data.AC_TYPE);
                    detailForm.setValue('CLOSE_YN',masterRecord.data.CLOSE_YN);
					
//					UniAppManager.app.fnGetA171RefCode();
					
					detailForm.setValue('HDD_CONFIRM_YN',masterRecord.data.CONFIRM_YN);
					
					detailForm.setValue('HDD_GW_STATUS',masterRecord.data.GW_STATUS);
					
					detailForm.setValue('HDD_CLOSE_YN',masterRecord.data.CLOSE_YN);
					
					detailForm.setValue('HDD_INSERT_DB_USER',masterRecord.data.INSERT_DB_USER);
					
					detailForm.setValue('HDD_SAVE_TYPE','');
					
					detailForm.setValue('HDD_COPY_DATA','');
				}
			}			
		},
		
		/**
		 * 결제상신 관련
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
	
	
	/**
	 * 모델필드 생성
	 */
	function createModelField(budgNameList) {
		var fields = [
			{name: 'COMP_CODE'			, text: '법인코드'				, type: 'string'},
			{name: 'DRAFT_NO'			, text: 'DRAFT_NO'			, type: 'string'},
			{name: 'DRAFT_SEQ'			, text: '순번'				, type: 'uniNumber'},
			{name: 'BUDG_CODE'			, text: '예산과목'				, type: 'string',allowBlank:false},
			{name: 'BUDG_NAME'			, text: '예산명'				, type: 'string',allowBlank:false},
			// 예산명(쿼리읽어서 컬럼 셋팅)
			{name: 'PJT_CODE'			, text: '프로젝트코드'			, type: 'string'},
			{name: 'PJT_NAME'			, text: '프로젝트명'			, type: 'string'},
			{name: 'BUDG_GUBUN'			, text: 'BUDG_GUBUN'		, type: 'string'},
			{name: 'BUDG_POSS_AMT'		, text: '예산사용가능금액'		, type: 'uniPrice'},
			{name: 'BUDG_AMT'			, text: '기안예산금액'			, type: 'uniPrice',allowBlank:false},
			{name: 'REMARK'				, text: '세부내역'				, type: 'string'},
			{name: 'EXPEN_REQ_AMT'		, text: '지출요청금액'			, type: 'uniPrice'},
			{name: 'PAY_DRAFT_AMT'		, text: '지출결의금액'			, type: 'uniPrice'},
			{name: 'DRAFT_REMIND_AMT'	, text: '기안잔액'				, type: 'uniPrice'},
			{name: 'CLOSE_YN'			, text: '마감여부'				, type: 'string',allowBlank:false,comboType:'AU', comboCode:'A020'},
			{name: 'INSERT_DB_USER'		, text: '입력자'				, type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: '입력일'				, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: '수정자'				, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '수정일'				, type: 'string'}
	    ];
					
		Ext.each(budgNameList, function(item, index) {
			var name = 'BUDG_NAME_'+(index + 1);
			fields.push({name: name, text: item.CODE_NAME, type:'string' });
		});
		console.log(fields);
		return fields;
	}
	
	/**
	 * 그리드 컬럼 생성
	 */
	function createGridColumn(budgNameList) {
		var columns = [        
        	{dataIndex: 'COMP_CODE'				, width: 88, hidden: true},
        	{dataIndex: 'DRAFT_NO'				, width: 88, hidden: true},
        	{dataIndex: 'DRAFT_SEQ'				, width: 66,align:'center', hidden: false},
        	{dataIndex: 'BUDG_CODE'				, width: 150,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	},
            	editor: Unilite.popup('BUDG_G',{
	        		textFieldName: 'BUDG_NAME_L1',
					DBtextFieldName: 'BUDG_NAME_L1',
					autoPopup: true,
	        		listeners:{ 
	        			scope:this,
						onSelected:function(records, type )	{
							var budgName = "BUDG_NAME_L"+records[0]["CODE_LEVEL"];
                    		
                    		var grdRecord = detailGrid.uniOpt.currentRecord;
                    		
                    		grdRecord.set('BUDG_CODE'		,records[0]['BUDG_CODE']);
							grdRecord.set('BUDG_NAME'		,records[0][budgName]);
							grdRecord.set('PJT_CODE'		,records[0]['PJT_CODE']);
							grdRecord.set('PJT_NAME'		,records[0]['PJT_NAME']);
							Ext.each(budgNameList, function(item, index) {
								var dataIndex = 'BUDG_NAME_'+(index + 1);
								var budgNm = 'BUDG_NAME_L' + (index + 1);
								grdRecord.set(dataIndex		,records[0][budgNm]);
							});
//							UniAppManager.app.fnGetBudgPossAmt(grdRecord);
							var param = {"BUDG_YYYYMM": UniDate.getDbDateStr(detailForm.getValue('DRAFT_DATE')).substring(0, 6),
									"DEPT_CODE": detailForm.getValue('DEPT_CODE'),
									"BUDG_CODE": grdRecord.get('BUDG_CODE'),
									"BUDG_GUBUN": grdRecord.get('BUDG_GUBUN')
									};
							accntCommonService.fnGetBudgetPossAmt(param, function(provider, response)	{
			
								if(!Ext.isEmpty(provider)){
									grdRecord.set('BUDG_POSS_AMT', provider.BUDG_POSS_AMT);
								}else{
									grdRecord.set('BUDG_POSS_AMT', 0);
								}
							});
							
                    	},
						onClear:function(type)	{
	                  		var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('BUDG_CODE'		,'');
							grdRecord.set('BUDG_NAME'		,'');
							Ext.each(budgNameList, function(item, index) {
								var dataIndex = 'BUDG_NAME_'+(index + 1);
								grdRecord.set(dataIndex		,'');
							});
            				grdRecord.set('PJT_CODE'		,'');
            				grdRecord.set('PJT_NAME'		,'');
            				grdRecord.set('BUDG_POSS_AMT'	,'');
	                  	},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('DRAFT_DATE')).substring(0, 4),
							   		'DEPT_CODE' : detailForm.getValue('DEPT_CODE'),
							   		'ADD_QUERY' : gsCommonA171_Ref6 == '1' ? "GROUP_YN = 'N' " +
							   					"AND USE_YN = 'Y'" : "BUDG_TYPE = '2' AND GROUP_YN = 'N' AND USE_YN = 'Y'"
								}
								popup.setExtParam(param);
							}
						}
					}
	        	})
        	},	
        	{dataIndex: 'BUDG_NAME'				, width: 150,
        		editor: Unilite.popup('BUDG_G',{
	        		textFieldName: 'BUDG_NAME_L1',
					DBtextFieldName: 'BUDG_NAME_L1',
					autoPopup: true,
	        		listeners:{ 
	        			scope:this,
						onSelected:function(records, type )	{
							var budgName = "BUDG_NAME_L"+records[0]["CODE_LEVEL"];
                    		
                    		var grdRecord = detailGrid.uniOpt.currentRecord;
                    		
                    		grdRecord.set('BUDG_CODE'		,records[0]['BUDG_CODE']);
							grdRecord.set('BUDG_NAME'		,records[0][budgName]);
							grdRecord.set('PJT_CODE'		,records[0]['PJT_CODE']);
							grdRecord.set('PJT_NAME'		,records[0]['PJT_NAME']);
							Ext.each(budgNameList, function(item, index) {
								var dataIndex = 'BUDG_NAME_'+(index + 1);
								var budgNm = 'BUDG_NAME_L' + (index + 1);
								grdRecord.set(dataIndex		,records[0][budgNm]);
							});
//							UniAppManager.app.fnGetBudgPossAmt(grdRecord);
							var param = {"BUDG_YYYYMM": UniDate.getDbDateStr(detailForm.getValue('DRAFT_DATE')).substring(0, 6),
									"DEPT_CODE": detailForm.getValue('DEPT_CODE'),
									"BUDG_CODE": grdRecord.get('BUDG_CODE'),
									"BUDG_GUBUN": grdRecord.get('BUDG_GUBUN')
									};
							accntCommonService.fnGetBudgetPossAmt(param, function(provider, response)	{
			
								if(!Ext.isEmpty(provider)){
									grdRecord.set('BUDG_POSS_AMT', provider.BUDG_POSS_AMT);
								}else{
									grdRecord.set('BUDG_POSS_AMT', 0);
								}
							});
							
                    	},
						onClear:function(type)	{
	                  		var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('BUDG_CODE'		,'');
							grdRecord.set('BUDG_NAME'		,'');
							Ext.each(budgNameList, function(item, index) {
								var dataIndex = 'BUDG_NAME_'+(index + 1);
								grdRecord.set(dataIndex		,'');
							});
            				grdRecord.set('PJT_CODE'		,'');
            				grdRecord.set('PJT_NAME'		,'');
            				grdRecord.set('BUDG_POSS_AMT'	,'');
	                  	},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('DRAFT_DATE')).substring(0, 4),
							   		'DEPT_CODE' : detailForm.getValue('DEPT_CODE'),
							   		'ADD_QUERY' : gsCommonA171_Ref6 == '1' ? "GROUP_YN = 'N' " +
							   					"AND USE_YN = 'Y'" : "BUDG_TYPE = '2' AND GROUP_YN = 'N' AND USE_YN = 'Y'"
								}
								popup.setExtParam(param);
							}
						}
					}
	        	})
        	}	
			// 예산명(쿼리읽어서 컬럼 셋팅)
		];
		// 예산명(쿼리읽어서 컬럼 셋팅)
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_'+(index + 1);
			columns.push({dataIndex: dataIndex,		width: 120});	
		});
		columns.push({dataIndex: 'PJT_CODE'				, width: 110,
						editor: Unilite.popup('AC_PROJECT_G',{
			        		textFieldName: 'AC_PROJECT_CODE',
							DBtextFieldName: 'AC_PROJECT_CODE',
							autoPopup: true,
			        		listeners:{ 
								'onSelected': {
			                    	fn: function(records, type  ){
			                    		var grdRecord = detailGrid.uniOpt.currentRecord;
										grdRecord.set('PJT_CODE',records[0]['AC_PROJECT_CODE']);
										grdRecord.set('PJT_NAME',records[0]['AC_PROJECT_NAME']);
			                    	},
			                		scope: this
			      	   			},
								'onClear' : function(type)	{
			                  		var grdRecord = detailGrid.uniOpt.currentRecord;
									grdRecord.set('PJT_CODE','');
									grdRecord.set('PJT_NAME','');
			                  	}
							}
			        	})
		}); 	
		columns.push({dataIndex: 'PJT_NAME'				, width: 120,
						editor: Unilite.popup('AC_PROJECT_G',{
			        		textFieldName: 'AC_PROJECT_NAME',
							DBtextFieldName: 'AC_PROJECT_NAME',
							autoPopup: true,
			        		listeners:{ 
								'onSelected': {
			                    	fn: function(records, type  ){
			                    		var grdRecord = detailGrid.uniOpt.currentRecord;
										grdRecord.set('PJT_CODE',records[0]['AC_PROJECT_CODE']);
										grdRecord.set('PJT_NAME',records[0]['AC_PROJECT_NAME']);
			                    	},
			                		scope: this
			      	   			},
								'onClear' : function(type)	{
			                  		var grdRecord = detailGrid.uniOpt.currentRecord;
									grdRecord.set('PJT_CODE','');
									grdRecord.set('PJT_NAME','');
			                  	}
							}
			        	})
		}); 		
		columns.push({dataIndex: 'BUDG_GUBUN'			, width: 88, hidden: true}); 		
		columns.push({dataIndex: 'BUDG_POSS_AMT'		, width: 120}); 		
		columns.push({dataIndex: 'BUDG_AMT'				, width: 120,summaryType: 'sum'}); 		
		columns.push({dataIndex: 'REMARK'				, width: 200, hidden: true}); 		
		columns.push({dataIndex: 'EXPEN_REQ_AMT'		, width: 100, hidden: true}); 		
		columns.push({dataIndex: 'PAY_DRAFT_AMT'		, width: 100}); 		
		columns.push({dataIndex: 'DRAFT_REMIND_AMT'		, width: 100,summaryType: 'sum'}); 		
		columns.push({dataIndex: 'CLOSE_YN'				, width: 120}); 		
		columns.push({dataIndex: 'INSERT_DB_USER'		, width: 88, hidden: true}); 		
		columns.push({dataIndex: 'INSERT_DB_TIME'		, width: 88, hidden: true}); 		
		columns.push({dataIndex: 'UPDATE_DB_USER'		, width: 88, hidden: true}); 		
		columns.push({dataIndex: 'UPDATE_DB_TIME'		, width: 88, hidden: true}); 	
		return columns;
	}	
	
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "BUDG_AMT" :
					record.set('DRAFT_REMIND_AMT', newValue);
					break;
			}
			return rv;
		}
	});	
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
	});
};
</script>
