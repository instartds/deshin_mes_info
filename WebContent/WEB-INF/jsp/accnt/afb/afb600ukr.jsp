<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb600ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb600ukr" /> 	<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A170" />			<!-- 예산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A171"  /> 		<!-- 문서서식구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A020"  /> 		<!-- 예/아니오 -->
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
			read: 'afb600ukrService.selectDetail',
			update: 'afb600ukrService.updateDetail',
			create: 'afb600ukrService.insertDetail',
			destroy: 'afb600ukrService.deleteDetail',
			syncAll: 'afb600ukrService.saveAll'
		}
	});	
	Unilite.defineModel('Afb600ukrModel', {
		fields:fields
	});	
	  
	var directMasterStore = Unilite.createStore('Afb600ukrDirectMasterStore',{
        proxy: {
           type: 'direct',
            api: {			
                read: 'afb600ukrService.selectMaster'                	
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
	//		            	UniAppManager.app.onQueryButtonDown();
			            	
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
                read: 'afb600ukrService.posAmt'                	
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
                read: 'afb600ukrService.pro1'                	
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
                read: 'afb600ukrService.reCancel'                	
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
                read: 'afb600ukrService.pro2'                	
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
        	tdAttrs: {/*style: 'border : 1px solid #ced9e7;',/*align : 'left',*/width: '100%'}
		
		},
		padding:'1 1 1 1',
		border:true,
		disabled:false,
		items: [{ 
    		fieldLabel: '기안일',
    		labelWidth:150,
		    xtype: 'uniDatefield',
//		    id:'draftDatePR',
		    name: 'DRAFT_DATE',
		    value: UniDate.get('today'),
		    allowBlank: false,         
		    tdAttrs: {width:1000}
		},
		Unilite.popup('Employee', {
			fieldLabel: '기안자', 
			labelWidth:150,
			valueFieldName: 'DRAFTER',
    		textFieldName: 'DRAFT_NAME',
    		tdAttrs: {width:'100%',align : 'left'}, 
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
					if(detailForm.getValue('DRAFT_NO') == ''){
						Ext.Msg.alert("확인",Msg.fSbMsgA0199);
					}else{
						if(gsLinkedGW == 'Y'){
							UniAppManager.app.fnApproval();
						}else{
							UniAppManager.app.fnConfirm();
						}
					}
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
		   xtype: 'container',
		   layout: {type : 'uniTable', columns : 2},
		   width:500,
		   id:'hiddenContainerPR',
		   defaults : {enforceMaxLength: true},
		   tdAttrs: {width:'100%',align : 'left'}, 
//			   tdAttrs: {align : 'left'},
		   items :[{
				fieldLabel:'비밀번호',
				labelWidth:150,
				xtype: 'uniTextfield',
				id:'passWordPR',
				name: 'PASSWORD',
				inputType: 'password',
				maxLength : 7,
				holdable: 'hold',
				allowBlank:false
//					tdAttrs: {width: 250}
			},{ 
	    		xtype: 'component',  
	    		html:'※ 주민번호 뒤 7자리 입력',
	    		id:'hiddenHtmlPR',
	    		style: {
		           marginTop: '3px !important',
		           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
		           color: 'blue'
				},
	    		tdAttrs: {align : 'left'}
			}]
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
						afb600ukrService.selectDetail(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								Ext.each(provider, function(record,i){
									UniAppManager.app.onNewDataButtonDown('Y');
					        		detailGrid.setNewDataCopy(record);	
								});
							}
						});
						
//						UniAppManager.app.fnDispTotAmt();
						
						UniAppManager.app.fnDispMasterData("COPY");
						
						UniAppManager.app.fnMasterDisable(false);
						
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
		},
		Unilite.popup('Employee', {
			fieldLabel: '사용자', 
			labelWidth:150,
			valueFieldName: 'PAY_USER_PN',
    		textFieldName: 'PAY_USER_NM',
    		tdAttrs: {width:'100%',align : 'left'}, 
//				validateBlank:false,
    		autoPopup:true
			
		}),
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			tdAttrs: {align : 'left',width:120},
//				id:'hiddenContainerPR',
			defaults : {enforceMaxLength: true},
//			   tdAttrs: {align : 'left'},
			items :[{
	    		xtype: 'button',
	    		text: '비연계확정',	
	    		id: 'btnConfirmPR',
	    		name: 'CONFIRM',
	    		width: 110,	
				handler : function() {
					if(detailForm.getValue('DRAFT_NO') == ''){
						Ext.Msg.alert("확인",Msg.fSbMsgA0199);
						return false;
					}
					if(gsConfirm == 'Y'){
						UniAppManager.app.fnConfirm();
					}
				}
	    	}]
    	},{
			fieldLabel: '사업장',
			labelWidth:150,
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
	        comboType:'BOR120',
	        allowBlank:false,
	        tdAttrs: {width:1000}
	        //value:UserInfo.divCode,
		},
		Unilite.popup('DEPT',{ 
	    	fieldLabel: '예산부서', 
	    	labelWidth:150,
	    	valueFieldName: 'DEPT_CODE',
			textFieldName: 'DEPT_NAME',
			tdAttrs: {width:'100%',align : 'left'}, 
//				validateBlank:false,
	    	autoPopup:true
		}),
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			tdAttrs: {align : 'left',width:120},
//				id:'hiddenContainerPR',
			defaults : {enforceMaxLength: true},
//			   tdAttrs: {align : 'left'},
			items :[{
				xtype: 'button',
	    		text: '임의반려',	
	    		id: 'btnReCancelPR',
	    		name: 'RECANCEL',
		    	//inputValue: '1',
	    		width: 110,	
				handler : function() {
					if(detailForm.getValue('DRAFT_NO') == ''){
						return false;	
					}
					if(directDetailStore.getCount() == 0){
						Ext.Msg.alert("확인",Msg.fSbMsgA0515);
						return false;
					}
					if(confirm(Msg.fSbMsgA0529)) {
						var param= Ext.getCmp('detailForm').getValues();
						reCancelStore.load({
							params : param,
							callback : function(records, operation, success) {
								if(success)	{
									Ext.Msg.alert("확인",Msg.fSbMsgA0516);
									detailForm.setValue('HDD_STATUS',records[0].data.STATUS);
									
									detailForm.getField('STATUS').setValue(records[0].data.STATUS);
																	
									UniAppManager.app.fnMasterDisable(true);
									
//									Ext.Msg.alert("확인",Msg.sMA0328);	goCnn.SetMessage(sMA0328)이건뭔가???
								}else{
									return false;	
								}
							}
						})
					}
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
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			tdAttrs: {align : 'left',width:120},
//				id:'hiddenContainerPR',
			defaults : {enforceMaxLength: true},
//			   tdAttrs: {align : 'left'},
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
								if(success)	{
									
//				이거뭐여				grdSheet1.Cell(0, csHeaderRowsCnt, grdSheet1.ColIndex("CLOSE_YN")
//									,grdSheet1.Rows-1, grdSheet1.ColIndex("CLOSE_YN")) = oRs("CLOSE_YN")
									
									detailForm.setValue('HDD_CLOSE_YN',records[0].data.CLOSE_YN);
									
									Ext.getCmp('btnClosePR').setDisabled(true);	
									UniAppManager.app.onQueryButtonDown();
//									Ext.Msg.alert("확인",Msg.sMB021);	
								}else{
									return false;
								}
							}
						});	
					}
//					,,,,
				}
	    	}]
    	},{ 
    		fieldLabel: '문서서식구분',
    		labelWidth:150,
		    name: 'ACCNT_GUBUN',
		    xtype: 'uniCombobox',
		    comboType:'AU',
			comboCode:'A171',
		    allowBlank: false,	
		    colspan:3
		},{
		   xtype: 'container',
		   layout: {type : 'uniTable', columns : 7},
		   width:500,
		   colspan:3,
		   defaults : {width:200,labelWidth:130},
		   tdAttrs: {width:'100%'/*align : 'center'*/},
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
	 		submit: 'afb600ukrService.syncMaster'	
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
			showSummaryRow: true
		}],
    	layout : 'fit',
        region : 'center',
		store: directDetailStore,
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: true,
			expandLastColumn	: false,
			onLoadSelectFirst 	: false,
    		dblClickToEdit		: true,
    		onLoadSelectFirst	: true, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			state: {
				useState: false,			
				useStateList: false		
			}
		},
        columns:columns,
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['BUDG_CODE','BUDG_NAME','PJT_CODE','PJT_NAME','BUDG_AMT'])){
					return true;	
				}else{
					return false;	
				}
			}
        	/*itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}*/
        },
        
        setNewDataCopy:function(record){
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('COMP_CODE'			,record['COMP_CODE']);
			grdRecord.set('DRAFT_SEQ'			,record['DRAFT_SEQ']);
			grdRecord.set('BUDG_CODE'			,record['BUDG_CODE']);
			grdRecord.set('BUDG_NAME'			,record['BUDG_NAME']);
			
			
			Ext.each(budgNameList, function(item, index) {
				var name = 'BUDG_NAME_'+(index + 1);
				grdRecord.set(name			,record[name]);
			});
			
			
			grdRecord.set('PJT_CODE'			,record['PJT_CODE']);
			grdRecord.set('PJT_NAME'			,record['PJT_NAME']);
			grdRecord.set('BUDG_GUBUN'			,record['BUDG_GUBUN']);
			grdRecord.set('BUDG_POSS_AMT'		,record['BUDG_POSS_AMT']);
			grdRecord.set('BUDG_AMT'			,record['BUDG_AMT']);
			grdRecord.set('EXPEN_REQ_AMT'		,record['EXPEN_REQ_AMT']);
			grdRecord.set('PAY_DRAFT_AMT'		,0);
			grdRecord.set('DRAFT_REMIND_AMT'	,record['BUDG_AMT']);
			grdRecord.set('CLOSE_YN'			,'N');			
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
	            		detailGrid.gotoAfb600(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAfb600:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 'afb600ukr',
					'AC_DATE' 			: record.data['AC_DATE'],
					'ACCNT_DIV_CODE'	: detailForm.getValue('ACCNT_DIV_CODE'),
					'ACCNT' 			: record.data['ACCNT'],	
					'ACCNT_NAME' 		: record.data['ACCNT_NAME'],
					'START_DATE'		: detailForm.getValue('START_DATE')
				}
		  		var rec1 = {data : {prgID : 'afb600ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb600ukr.do', params);
			}
    	}*/
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
		onNewDataButtonDown: function(copyCheck)	{
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
			var closeYn	   = 'N';
			
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
			UniAppManager.app.fnMasterDisable(false);
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
				afb600ukrService.afb600ukrDelA(param, function(provider, response)	{							
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
			
			
			if(gsIdMapping == 'Y'){
				detailForm.getField('DRAFTER').setReadOnly(true);
				detailForm.getField('DRAFT_NAME').setReadOnly(true);
				
				
				Ext.getCmp('passWordPR').setHidden(true);
				Ext.getCmp('hiddenHtmlPR').setHidden(true);
				detailForm.getField("PASSWORD").setConfig('allowBlank',true);
				
				
				
//				Ext.getCmp('hiddenContainerPR').setHidden(true);
//				Ext.getCmp('hiddenComponent').setHidden(false);
//				
				
			}else{
				detailForm.getField('DRAFTER').setReadOnly(false);
				detailForm.getField('DRAFT_NAME').setReadOnly(false);
				
				
				Ext.getCmp('passWordPR').setHidden(false);
				Ext.getCmp('hiddenHtmlPR').setHidden(false);
				detailForm.getField("PASSWORD").setConfig('allowBlank',false);
				
				
//				Ext.getCmp('hiddenContainerPR').setHidden(false);
//				Ext.getCmp('hiddenComponent').setHidden(true);
				
			}
			
			if(gsLinkedGW == 'Y'){
				
				detailForm.down('#btnProcPR').setText(Msg.fSbMsgA0437);
				
				Ext.getCmp('statusPR').setHidden(false);
				
				
				if(gsAmender == 'Y'){
					Ext.getCmp('btnReCancelPR').setHidden(false);
				}else{
					Ext.getCmp('btnReCancelPR').setHidden(true);
				}
			}else{
				detailForm.down('#btnProcPR').setText(Msg.fSbMsgA0434);
				
				Ext.getCmp('statusPR').setHidden(true);
				
				Ext.getCmp('btnReCancelPR').setHidden(true);
				
			}
			
			if(gsConfirm == 'Y'){
				Ext.getCmp('btnConfirmPR').setHidden(false);
			}else{
				Ext.getCmp('btnConfirmPR').setHidden(true);
			}
			
			if(gsConButtonYN == 'N'){
				if(gsConfirmer == 'Y'){
					Ext.getCmp('btnProcPR').setHidden(false);
				}else{
					Ext.getCmp('btnProcPR').setHidden(true);
				}
			}
			
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
			
			UniAppManager.app.fnGetA171RefCode();
			
			detailForm.setValue('DEPT_CODE',gsDeptCode);
			detailForm.setValue('DEPT_NAME',gsDeptName);
			
			detailForm.setValue('TITLE','');
			
			detailForm.setValue('HDD_CONFIRM_YN','N');	
			
			if(gsLinkedGW == 'N'){
				detailForm.down('#btnProcPR').setText(Msg.fSbMsgA0434);
			}
			
			if(gsConfirm == 'Y'){
				detailForm.down('#btnConfirmPR').setText(Msg.fSbMsgA0511);
				detailForm.getField('STATUS').setValue('0');
			}
			detailForm.setValue('HDD_CLOSE_YN','N');
			detailForm.setValue('HDD_INSERT_DB_USER','');
			detailForm.setValue('HDD_SAVE_TYPE','N');
			detailForm.setValue('HDD_COPY_DATA','');
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
				
				if(gsLinkedGW == 'N'){
					detailForm.down('#btnProcPR').setText(Msg.fSbMsgA0434);
				
				}
				
				if(gsConfirm == 'Y'){
					detailForm.down('#btnConfirmPR').setText(Msg.fSbMsgA0511);
					detailForm.getField('STATUS').setValue('0');
					
					Ext.getCmp('btnConfirmPR').enable();
				}
				
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
					
					detailForm.setValue('HDD_CONFIRM_YN','N');
					
					detailForm.setValue('HDD_GW_STATUS','');
					
					if(gsLinkedGW == 'N'){
						detailForm.down('#btnConfirmPR').setText(Msg.fSbMsgA0434);
					}
					
					if(gsConfirm == 'Y'){
						detailForm.down('#btnConfirmPR').setText(Msg.fSbMsgA0511);	
						detailForm.getField('STATUS').setValue('0');
						
						Ext.getCmp('btnConfirmPR').enable();
					}
					
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
					
					UniAppManager.app.fnGetA171RefCode();
					
					detailForm.setValue('HDD_CONFIRM_YN',masterRecord.data.CONFIRM_YN);
					
					detailForm.setValue('HDD_GW_STATUS',masterRecord.data.GW_STATUS);
					
					if(gsLinkedGW == 'N'){
						if(detailForm.getValue('HDD_CONFIRM_YN') == 'Y'){
							detailForm.down('#btnProcPR').setText(Msg.fSbMsgA0433);
						}else{
							detailForm.down('#btnProcPR').setText(Msg.fSbMsgA0434);
						}
					}else{
						if(detailForm.getValue('HDD_GW_STATUS') == ''){
							Ext.getCmp('btnProcPR').enable();
							
							Ext.getCmp('btnConfirmPR').enable();
							
							Ext.getCmp('btnReCancelPR').disable();
							
							
//							Ext.getCmp('btnProcPS').setDisabled(false);
//							Ext.getCmp('btnProcPR').setDisabled(false);
//							
//							Ext.getCmp('btnConfirmPS').setDisabled(false);
//							Ext.getCmp('btnConfirmPR').setDisabled(false);
//							
//							Ext.getCmp('btnReCancelPS').setDisabled(true);
//							Ext.getCmp('btnReCancelPR').setDisabled(true);
//							,,,
							
						}else{
							Ext.getCmp('btnProcPR').disable();
							
							Ext.getCmp('btnConfirmPR').disable();
							
							Ext.getCmp('btnReCancelPR').enable();
							
//							Ext.getCmp('btnProcPS').setDisabled(true);
//							Ext.getCmp('btnProcPR').setDisabled(true);
//							
//							Ext.getCmp('btnConfirmPS').setDisabled(true);
//							Ext.getCmp('btnConfirmPR').setDisabled(true);
//							
//							Ext.getCmp('btnReCancelPS').setDisabled(false);
//							Ext.getCmp('btnReCancelPR').setDisabled(false);
						}
					}
					
					if(detailForm.getValue('HDD_GW_STATUS') == ''){
						if(gsConfirm == 'Y'){
							if(detailForm.getValue('HDD_CONFIRM_YN') == 'Y'){
								detailForm.down('#btnConfirmPR').setText(Msg.fSbMsgA0433);
								
								detailForm.getField('STATUS').setValue('9');
							}else{
								detailForm.down('#btnConfirmPR').setText(Msg.fSbMsgA0511);
								
								detailForm.getField('STATUS').setValue('0');	
							}
						}
					}
					
					detailForm.setValue('HDD_CLOSE_YN',masterRecord.data.CLOSE_YN);
					if(detailForm.getValue('HDD_CLOSE_YN') == 'Y'){
						Ext.getCmp('btnClosePR').disable();
					}else{
						Ext.getCmp('btnClosePR').enable();	
					}
					
					detailForm.setValue('HDD_INSERT_DB_USER',masterRecord.data.INSERT_DB_USER);
					
					detailForm.setValue('HDD_SAVE_TYPE','');
					
					detailForm.setValue('HDD_COPY_DATA','');
				}
			}			
		},
		/**
		 * 프리폼 입력제어 처리
		 */
		fnMasterDisable:function(bBool){
			var bExcept;
			
			bExcept = false;
			
			if(detailForm.getValue('HDD_CONFIRM_YN') == 'Y' || Ext.getCmp('statusPR').getValue().STATUS != '0'){
				bBool = true;
			}
			if(Ext.getCmp('statusPR').getValue().STATUS != '5'){
				if(bBool == true){
					bExcept = true;
					bBool = false;
				}
			}
			
			detailForm.getField('DRAFT_DATE').setReadOnly(bBool);
			
//			Ext.getCmp('draftDatePS').setDisabled(bBool);
//			Ext.getCmp('draftDatePR').setDisabled(bBool);
//			
			if(gsIdMapping == 'Y'){
				detailForm.getField('DRAFTER').setReadOnly(true);
				detailForm.getField('DRAFT_NAME').setReadOnly(true);	
			}else{
				detailForm.getField('DRAFTER').setReadOnly(bBool);
				detailForm.getField('DRAFT_NAME').setReadOnly(bBool);		
			}
			
			detailForm.getField('BUDG_GUBUN').setReadOnly(bBool);
			
			detailForm.getField('PAY_USER_PN').setReadOnly(bBool);
			detailForm.getField('PAY_USER_NM').setReadOnly(bBool);
			
			detailForm.getField('DIV_CODE').setReadOnly(bBool);
			
			detailForm.getField('DEPT_CODE').setReadOnly(bBool);
			detailForm.getField('DEPT_NAME').setReadOnly(bBool);
			
			detailForm.getField('TITLE').setReadOnly(bBool);
			
			if(bBool == true){
				UniAppManager.setToolbarButtons(['newData','delete','deleteAll'],false);	
			}else{
				UniAppManager.setToolbarButtons(['newData'],true);	
				if(directMasterStore.getCount() > 0 && bExcept == false){
					UniAppManager.setToolbarButtons(['delete','deleteAll'],true);		
				}else{
					UniAppManager.setToolbarButtons('delete',false);		
					UniAppManager.setToolbarButtons('deleteAll',true);
				}
			}
			
			if(detailForm.getValue('HDD_CONFIRM_YN') == 'Y' && gsLinkedGW == 'N'){
				Ext.getCmp('btnProcPR').setDisabled(false);
				detailForm.down('#btnProcPR').setText(Msg.fSbMsgA0433);
			}else if(detailForm.getValue('HDD_CONFIRM_YN') == 'N' && gsLinkedGW == 'N'){
				Ext.getCmp('btnProcPR').setDisabled(false);
				detailForm.down('#btnProcPR').setText(Msg.fSbMsgA0434);	
				
			}else if(Ext.getCmp('statusPR').getValue().STATUS != '0'){
				Ext.getCmp('btnProcPR').setDisabled(true);
				
			}else{
				Ext.getCmp('btnProcPR').setDisabled(bBool);
			}
			
			if(detailForm.getValue('HDD_GW_STATUS') == ''){
				if(detailForm.getValue('HDD_CONFIRM_YN') == 'Y' && gsConfirm == 'Y'){
					detailForm.down('#btnConfirmPR').setText(Msg.fSbMsgA0433);
					detailForm.getField('STATUS').setValue('9');
					
					Ext.getCmp('btnConfirmPR').setDisabled(false);
					
				}else if(detailForm.getValue('HDD_CONFIRM_YN') == 'N' && gsConfirm == 'Y'){
					detailForm.down('#btnConfirmPR').setText(Msg.fSbMsgA0511);
					detailForm.getField('STATUS').setValue('0');
					
					Ext.getCmp('btnConfirmPR').setDisabled(false);	
				}
			}
			
			if(gsLinkedGW == 'Y'){
				if(detailForm.getValue('HDD_GW_STATUS') == ''){
					Ext.getCmp('btnProcPR').setDisabled(false);	
					Ext.getCmp('btnConfirmPR').setDisabled(false);	
				}else{
					Ext.getCmp('btnProcPR').setDisabled(true);	
					Ext.getCmp('btnConfirmPR').setDisabled(true);	
				}
			}
			
			if(gsAmender == 'Y' && (Ext.getCmp('statusPR').getValue().STATUS == '1' || Ext.getCmp('statusPR').getValue().STATUS == '9')){
				Ext.getCmp('btnReCancelPR').setDisabled(false);	
			}else{
				Ext.getCmp('btnReCancelPR').setDisabled(true);		
			}
		},
		
		/**
		 * 공통코드 A171의  REF_CODE6
		 */
		fnGetA171RefCode: function(){
			var param = {"MAIN_CODE": 'A171',
					"SUB_CODE": detailForm.getValue('ACCNT_GUBUN'),
					"field":'refCode6'
				};
				
				if(!Ext.isEmpty(UniAccnt.fnGetRefCode(param))){
					gsCommonA171_Ref6 = UniAccnt.fnGetRefCode(param);
				}else{
					gsCommonA171_Ref6 = '';	
				}
				
//			return gsCommonA171_Ref6;
		},
		/**
		 * 결제상신 관련
		 */
		fnApproval: function(){
			Ext.Msg.alert("버튼이 결재상신 일때","빌드중(추후개발예정)");
		},

		/**
		 * 예산확정 관련
		 */
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
		}
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
