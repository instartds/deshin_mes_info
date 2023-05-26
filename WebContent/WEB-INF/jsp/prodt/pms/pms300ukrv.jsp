<%--
'   프로그램명 : 접수등록 (출하)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pms300ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="Q023" /> <!-- 접수담당-->
	<t:ExtComboStore comboType="WU" />        <!-- 작업장-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var searchReceptionHistory;	// 접수내역
var referProductionWindow;	//생산량참조

var BsaCodeInfo = {
	
};
//alert(output);

var outDivCode = UserInfo.divCode;
var checkDraftStatus = false;

function appMain() {     

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pms300ukrvService.selectMaster',
			update: 'pms300ukrvService.updateDetail',
			create: 'pms300ukrvService.insertDetail',
			destroy: 'pms300ukrvService.deleteDetail',
			syncAll: 'pms300ukrvService.saveAll'
		}
	});
	var masterForm = Unilite.createSearchPanel('pms300ukrvMasterForm', {
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		        fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		        name:'DIV_CODE', 
		        xtype: 'uniCombobox', 
		        comboType:'BOR120' ,
		        allowBlank:false,
		        holdable: 'hold',
		        value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
		    },{
			 	fieldLabel: '<t:message code="system.label.product.receiptdate" default="접수일"/>',
			 	xtype: 'uniDatefield',
			 	name: 'RECEIPT_DATE',
				value: UniDate.get('today'),
		        holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RECEIPT_DATE', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					textFieldWidth: 170, 
					validateBlank: false,
					valueFieldName: 'ITEM_CODE',
	        		textFieldName:'ITEM_NAME',
					width: 380,
		        	holdable: 'hold',
	        		listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								masterForm.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								masterForm.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						}
					}
			}),{
		        fieldLabel: '<t:message code="system.label.product.receiptcharger2" default="접수담당자"/>',
		        name:'RECEIPT_PRSN', 
		        xtype: 'uniCombobox', 
		        comboType:'AU' ,
		        comboCode:'Q023',
		        allowBlank:false,
		        holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RECEIPT_PRSN', newValue);
					}
				}
	    	},{
				fieldLabel: '<t:message code="system.label.product.receiptno" default="접수번호"/>',
				name: 'RECEIPT_NUM',
				xtype: 'uniTextfield',
				readOnly : true,
		        holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RECEIPT_NUM', newValue);
					}
				}
			}
		]}],
		api: {
			load: 'pms300ukrvService.selectMaster',
			submit: 'pms300ukrvService.syncMaster'				
		},
		listeners: {
			dirtychange: function(basicForm, dirty, eOpts) {
				console.log("onDirtyChange");
//				UniAppManager.setToolbarButtons('save', true);
			}
		},
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
						this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
			hidden: !UserInfo.appOption.collapseLeftSearch,
			region: 'north',
			layout : {type : 'uniTable', columns : 3},
			padding:'1 1 1 1',
			border:true,
			items: [{
			        fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			        name:'DIV_CODE', 
			        xtype: 'uniCombobox', 
			        comboType:'BOR120' ,
			        allowBlank:false,
			        holdable: 'hold',
			        value: UserInfo.divCode,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('DIV_CODE', newValue);
						}
					}
			    },{
				 	fieldLabel: '<t:message code="system.label.product.receiptdate" default="접수일"/>',
				 	xtype: 'uniDatefield',
				 	name: 'RECEIPT_DATE',
					value: UniDate.get('today'),
			        holdable: 'hold',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('RECEIPT_DATE', newValue);
						}
					}
				},
					Unilite.popup('DIV_PUMOK',{ 
						fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
						textFieldWidth: 170, 
						validateBlank: false,
						valueFieldName: 'ITEM_CODE',
		        		textFieldName:'ITEM_NAME',
						width: 380,
			        	holdable: 'hold',
		        		listeners: {
							onValueFieldChange: function( elm, newValue, oldValue ) {
								masterForm.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('ITEM_NAME', '');
									masterForm.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function( elm, newValue, oldValue ) {
								masterForm.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('ITEM_CODE', '');
									masterForm.setValue('ITEM_CODE', '');
								}
							},
							applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
						}
				}),{
			        fieldLabel: '<t:message code="system.label.product.receiptcharger2" default="접수담당자"/>',
			        name:'RECEIPT_PRSN', 
			        xtype: 'uniCombobox', 
			        comboType:'AU' ,
			        comboCode:'Q023',
			        allowBlank:false,
			        holdable: 'hold',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('RECEIPT_PRSN', newValue);
						}
					}
		    	},{
					fieldLabel: '<t:message code="system.label.product.receiptno" default="접수번호"/>',
					name: 'RECEIPT_NUM',
					xtype: 'uniTextfield',
					readOnly : true,
			        holdable: 'hold',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('RECEIPT_NUM', newValue);
							
						}
					}
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
		   						var labelText = invalid.items[0]['fieldLabel']+' : ';
		   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
		   					}
		
						   	alert(labelText+Msg.sMB083);
						   	invalid.items[0].focus();
						} else {
						//	this.mask();		    
		   				}
			  		} else {
	  					this.unmask();
	  				}
					return r;
	  			}  
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('pms300ukrvDetailModel', {
	    fields: [  	  
	    	{name:'DIV_CODE'       		,text: '<t:message code="system.label.product.division" default="사업장"/>'			    ,type:'string' ,comboType: 'BOR120', defaultValue: UserInfo.divCode ,editable:false},
			{name:'RECEIPT_NUM'  		,text: '<t:message code="system.label.product.receiptno" default="접수번호"/>'			,type:'string' },
			{name:'RECEIPT_SEQ'    		,text: '<t:message code="system.label.product.seq" default="순번"/>'				,type:'int'    },
			{name:'RECEIPT_DATE'   		,text: '<t:message code="system.label.product.receiptdate" default="접수일"/>'			    ,type:'uniDate'},
			{name:'ITEM_CODE'      		,text: '<t:message code="system.label.product.item" default="품목"/>'			,type:'string' },
			{name:'ITEM_NAME'      		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			    ,type:'string' },
			{name:'SPEC'           		,text: '<t:message code="system.label.product.spec" default="규격"/>'				,type:'string' },
			{name:'STOCK_UNIT'     		,text: '<t:message code="system.label.product.unit" default="단위"/>'				,type:'string' },
			{name:'NOT_RECEIPT_Q'  		,text: '<t:message code="system.label.product.notreceiveqty" default="미접수량"/>'			,type:'uniQty' },
			{name:'RECEIPT_Q'      		,text: '<t:message code="system.label.product.receiptqty2" default="접수량"/>'			    ,type:'uniQty', allowBlank: false },
			{name:'INSPEC_Q'       		,text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'			    ,type:'uniQty' },
			{name:'RECEIPT_PRSN'   		,text: '<t:message code="system.label.product.receiptcharger2" default="접수담당자"/>'			,type:'string' ,comboType: 'AU', comboCode: 'Q023' , allowBlank: false},
			{name:'LOT_NO'         		,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			    ,type:'string' },
			{name:'PRODT_NUM'      		,text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'			,type:'string' },
			{name:'WKORD_NUM'      		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string' },
			{name:'PROJECT_NO'     		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type:'string' },
			{name:'PJT_CODE'       		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type:'string' },
			{name:'REMARK'         		,text: '<t:message code="system.label.product.remarks" default="비고"/>'				,type:'string' },
			{name:'COMP_CODE'           ,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'           ,type:'string' }
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var detailStore = Unilite.createStore('pms300ukrvDetailStore', {
		model: 'pms300ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			allDeletable:   true,    //전체삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		/* syncAll 수정
		 * proxy: {
			type: 'direct',
			api: {
				read: 'pms300ukrvService.selectDetailList',
				update: 'pms300ukrvService.updateDetail',
				create: 'pms300ukrvService.insertDetail',
				destroy: 'pms300ukrvService.deleteDetail',
				syncAll: 'pms300ukrvService.syncAll'
			}
		},*/
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= masterForm.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var receiptNum = masterForm.getValue('RECEIPT_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['RECEIPT_NUM'] != receiptNum) {
					record.set('RECEIPT_NUM', receiptNum);
				}
			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				//if(config==null) {
					/* syncAll 수정
					 * config = {
							success: function() {
											detailForm.getForm().wasDirty = false;
											detailForm.resetDirtyStatus();
											console.log("set was dirty to false");
											UniAppManager.setToolbarButtons('save', false);						
									   } 
							  };*/
					config = {
							params: [paramMaster],
							success: function(batch, option) {
                                var master = batch.operations[0].getResultSet();
                                masterForm.setValue("RECEIPT_NUM", master.RECEIPT_NUM);
                                panelResult.setValue("RECEIPT_NUM", master.RECEIPT_NUM);
								masterForm.getForm().wasDirty = false;
								masterForm.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);		
								
								detailStore.loadStoreRecords();
							 } 
					};
				//}
				//this.syncAll(config);
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('pms300ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				// alert(Msg.sMB083);
			}
		}
	});

    var detailGrid = Unilite.createGrid('pms300ukrvGrid', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
			useContextMenu: true
        },
        tbar: [{
			itemId: 'requestBtn',
			text: '<div style="color: blue"><t:message code="system.label.product.productionqtyrefer" default="생산량참조"/></div>',
			handler: function() {
				openProductionWindow();
				}
		},'-'],
    	store: detailStore,
        columns: [        
        	{dataIndex: 'DIV_CODE'     		, width: 100 , hidden: true}, 							 							
			{dataIndex: 'RECEIPT_NUM'   	, width: 66  , hidden: true}, 								
			{dataIndex: 'RECEIPT_SEQ'  		, width: 60}, 												
			{dataIndex: 'RECEIPT_DATE' 		, width: 80  , hidden: true},
			{dataIndex: 'ITEM_CODE'    		, width: 166} ,
			{dataIndex: 'ITEM_NAME'     	, width: 125},
			{dataIndex: 'SPEC'         		, width: 120 }, 
			{dataIndex: 'STOCK_UNIT'   		, width: 80 ,align:'center' }, 												
			{dataIndex: 'NOT_RECEIPT_Q'		, width: 66  , hidden: true},
			{dataIndex: 'RECEIPT_Q'    		, width: 66},
			{dataIndex: 'INSPEC_Q'      	, width: 100}, 								
			{dataIndex: 'RECEIPT_PRSN' 		, width: 80}, 	
			{dataIndex: 'LOT_NO'       		, width: 133}, 												
			{dataIndex: 'PRODT_NUM'    		, width: 133},
			{dataIndex: 'WKORD_NUM'    		, width: 100},
			{dataIndex: 'PROJECT_NO'    	, width: 133}, 								
//			{dataIndex: 'PJT_CODE'     		, width: 133}, 	
			{dataIndex: 'REMARK'       		, width: 100},
			{dataIndex: 'COMP_CODE'         , width: 0 , hidden:true}
		], 
		listeners: {
			afterrender: function(grid) {
					//useContextMenu:true 설정으로 툴바 우측 버튼은 자동 생성되며 그 외 추가할 메뉴  작성					
					this.contextMenu.add(
						{
					        xtype: 'menuseparator'
					    },{	
					    	text: '<t:message code="system.label.product.iteminfo" default="품목정보"/>',   iconCls : '',
		                	handler: function(menuItem, event) {	
		                		var record = grid.getSelectedRecord();
								var params = {
									ITEM_CODE : record.get('ITEM_CODE')
								}
								var rec = {data : {prgID : 'bpr100ukrv', 'text':''}};									
								parent.openTab(rec, '/base/bpr100ukrv.do', params);
		                	}
		            	},{	
		            		text: '<t:message code="system.label.product.custominfo" default="거래처정보"/>',   iconCls : '',
		                	handler: function(menuItem, event) {				                		
								var params = {
									CUSTOM_CODE : masterForm.getValue('CUSTOM_CODE'),
									COMP_CODE : UserInfo.compCode
								}
								var rec = {data : {prgID : 'bcm100ukrv', 'text':''}};									
								parent.openTab(rec, '/base/bcm100ukrv.do', params);
		                	}
		            	}
	       			)
				},
				//contextMenu의 복사한 행 삽입 실행 전
				beforePasteRecord: function(rowIndex, record) {					
					if(!UniAppManager.app.checkForNewDetail()) return false;
					 
					var seq = detailStore.max('RECEIPT_SEQ');
	            	if(!seq) seq = 1;
	            	else  seq += 1;
	          		record.RECEIPT_SEQ = seq;
	          		return true;
	          	},
	          	//contextMenu의 복사한 행 삽입 실행 후
	          	afterPasteRecord: function(rowIndex, record) {
	          		masterForm.setAllFieldsReadOnly(false);  //// default  true
	          	},
			beforeedit  : function( editor, e, eOpts ) {
      			if(checkDraftStatus)	{
      				return false;
      			}else if(e.record.phantom )	{
					if (UniUtils.indexOf(e.field, 
											['RECEIPT_SEQ','ITEM_CODE','ITEM_NAME','SPEC','STOCK_UNIT','INSPEC_Q',
											 'PRODT_NUM','WKORD_NUM','PROJECT_NO','PJT_CODE']) )
							return false;
				}else if(!e.record.phantom)
				{
					if(e.record.data.RECEIPT_Q == e.record.data.INSPEC_Q){  // 접수량과 검사량이 같을 때 행 전체 수정 불가
						return false;
					}
					else {
						if (UniUtils.indexOf(e.field, 
											['RECEIPT_SEQ','ITEM_CODE','ITEM_NAME','SPEC','STOCK_UNIT','INSPEC_Q',
											 'PRODT_NUM','WKORD_NUM','PROJECT_NO','PJT_CODE']) )
							return false;
					}
				}
			}
		},
		disabledLinkButtons: function(b) {
		},
		
		setEstiData:function(record) {		
       		var grdRecord = this.getSelectedRecord();
       
       		grdRecord.set('COMP_CODE'			, masterForm.getValue('COMP_CODE'));
			grdRecord.set('RECEIPT_NUM'			, masterForm.getValue('RECEIPT_NUM'));
			grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));	
       		grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);	
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);	
			grdRecord.set('SPEC'				, record['SPEC']);	
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('RECEIPT_Q'			, record['NOT_RECEIPT_Q']);
			grdRecord.set('NOT_RECEIPT_Q'		, record['NOT_RECEIPT_Q']);
			grdRecord.set('PRODT_NUM'			, record['PRODT_NUM']);
			grdRecord.set('WKORD_NUM'			, record['WKORD_NUM']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('PJT_CODE'			, record['PJT_CODE']);
			//grdRecord.set('REMARK'			, record['REMARK']);
			grdRecord.set('LOT_NO'				, record['WK_LOT_NO']);
//			grdRecord.set('RECEIPT_PRSN'		, record['RECEIPT_PRSN']);
			grdRecord.set('RECEIPT_PRSN'		, masterForm.getValue('RECEIPT_PRSN'));
			grdRecord.set('RECEIPT_DATE'        , masterForm.getValue('RECEIPT_DATE'));
			grdRecord.set('INSPEC_Q'            , 0 );
		}
	});
		
    //조회창 폼 정의
  	var receptionNoSearch = Unilite.createSearchForm('receptionNoSearchForm', {
    	layout: {type: 'uniTable', columns : 2},
	    trackResetOnLoad: true,
	    items: [{
	        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	        	name:'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120',
	        	allowBlank:false ,
	        	value: UserInfo.divCode,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {		
						receptionNoSearch.setValue('WORK_SHOP_CODE','');
					}
        		}
			},{ 
	        	fieldLabel: '<t:message code="system.label.product.receiptdate" default="접수일"/>',
				xtype: 'uniDateRangefield',  
				startFieldName: 'RECEIPT_DATE_FR',
	        	endFieldName:'RECEIPT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				textFieldWidth:170
			},
				Unilite.popup('DIV_PUMOK',{ 
			    	fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>', 
			    	textFieldWidth	: 170,
			    	validateBlank	: false,
			    	popupWidth		: 500,
			    	valueFieldName	: 'ITEM_CODE',
			   		textFieldName	: 'ITEM_NAME',
					listeners		: {
					onValueFieldChange: function( elm, newValue, oldValue ) {
						if(!Ext.isObject(oldValue)) {
							receptionNoSearch.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						if(!Ext.isObject(oldValue)) {
							receptionNoSearch.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.product.lotno" default="LOT번호"/>',
				xtype: 'uniTextfield',
				name:'LOT_NO',
				width:315
			},{
	            fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
	            name: 'WORK_SHOP_CODE', 
	            xtype: 'uniCombobox', 
	            comboType: 'WU',
				listeners: {
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        store.clearFilter();
                        if(!Ext.isEmpty(receptionNoSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == receptionNoSearch.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;   
                            });
                        }
                    }
				}
	        }]
    });
    
    // 접수조회창 모델 정의
    Unilite.defineModel('receptionNoMasterModel', {
    	fields: [{name: 'RECEIPT_NUM'  				, text: '<t:message code="system.label.product.receiptno" default="접수번호"/>'    		, type: 'string'},         
				 {name: 'RECEIPT_DATE' 				, text: '<t:message code="system.label.product.receiptdate" default="접수일"/>'    		, type: 'uniDate'},         
				 {name: 'ITEM_CODE'    				, text: '<t:message code="system.label.product.item" default="품목"/>'    		, type: 'string'},         
				 {name: 'ITEM_NAME'    				, text: '<t:message code="system.label.product.itemname" default="품목명"/>'    		, type: 'string'},         
				 {name: 'SPEC'         				, text: '<t:message code="system.label.product.spec" default="규격"/>'    			, type: 'string'},         
				 {name: 'STOCK_UNIT'   				, text: '<t:message code="system.label.product.unit" default="단위"/>'    			, type: 'string'},         
				 {name: 'PRODT_Q'      				, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'    		, type: 'uniQty'},         
			
				 {name: 'RECEIPT_Q'    				, text: '<t:message code="system.label.product.receiptqty2" default="접수량"/>'    		, type: 'uniQty'},         
				 {name: 'NOT_RECEIPT_Q'				, text: '<t:message code="system.label.product.notreceiveqty" default="미접수량"/>'    		, type: 'uniQty'},         
				 {name: 'RECEIPT_PRSN' 				, text: '<t:message code="system.label.product.receiptcharger2" default="접수담당자"/>'    	, type: 'string' ,comboType: 'AU', comboCode: 'Q023'},         
				 {name: 'LOT_NO'       				, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'    		, type: 'string'},         
				 {name: 'PRODT_NUM'    				, text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'    		, type: 'string'},         
				 {name: 'WKORD_NUM'    				, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'    	, type: 'string'},         
				 {name: 'PROJECT_NO'   				, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'    	, type: 'string'},         
				 {name: 'PJT_CODE'     				, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'    	, type: 'string'}
		]
	});
	
	//조회창 스토어 정의
	var receptionNoMasterStore = Unilite.createStore('receptionNoMasterStore', {
			model: 'receptionNoMasterModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read    : 'pms300ukrvService.selectOrderNumMasterList'
                }
            }
            ,loadStoreRecords : function()	{
				var param= receptionNoSearch.getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	
	var receptionNoMasterGrid = Unilite.createGrid('pms300ukrvReceptionNoMasterGrid', {
        // title: '기본',
        layout : 'fit',       
		store: receptionNoMasterStore,
		uniOpt:{
					expandLastColumn: false,
					useRowNumberer: false
		},
        columns:  [{ dataIndex: 'RECEIPT_NUM'  	  , width: 106},             
				   { dataIndex: 'RECEIPT_DATE' 	  , width: 80 },             
				   { dataIndex: 'ITEM_CODE'    	  , width: 66 },             
				   { dataIndex: 'ITEM_NAME'    	  , width: 146 },             
				   { dataIndex: 'SPEC'            , width: 106},             
				   { dataIndex: 'STOCK_UNIT'   	  , width: 106 , align:'center' },             
				   { dataIndex: 'PRODT_Q'      	  , width: 60},             
				   { dataIndex: 'RECEIPT_Q'    	  , width: 60},             
				   { dataIndex: 'NOT_RECEIPT_Q'	  , width: 66},             
				   { dataIndex: 'RECEIPT_PRSN' 	  , width: 80},             
				   { dataIndex: 'LOT_NO'       	  , width: 86},             
				   { dataIndex: 'PRODT_NUM'       , width: 106},             
				   { dataIndex: 'WKORD_NUM'       , width: 106},             
				   { dataIndex: 'PROJECT_NO'      , width: 93}             
//				   { dataIndex: 'PJT_CODE'        , width: 93}
          ] ,
          listeners: {
	          onGridDblClick: function(grid, record, cellIndex, colName) {
		          	receptionNoMasterGrid.returnData(record);
		          	UniAppManager.app.onQueryButtonDown();
		          	searchReceptionHistory.hide();
	          }
          } // listeners
          ,returnData: function(record)	{
          	if(Ext.isEmpty(record))	{
          		record = this.getSelectedRecord();
          	}
          	masterForm.setValues({'RECEIPT_NUM':record.get('RECEIPT_NUM') , 'RECEIPT_DATE':record.get('RECEIPT_DATE')});
          }
    });
	
    //조회창 메인
	function opensearchReceptionHistory() {
		if(!searchReceptionHistory) {
			searchReceptionHistory = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.product.receiptnosearch" default="접수번호검색"/>',
                width: 1080,				                
                height: 580,
                layout: {type:'vbox', align:'stretch'},	                
                items: [receptionNoSearch, receptionNoMasterGrid],
                tbar:  ['->',
				        {	itemId : 'searchBtn',
							text: '<t:message code="system.label.product.inquiry" default="조회"/>',
							handler: function() {												
								receptionNoMasterStore.loadStoreRecords();												
							},
							disabled: false
						}, {
							itemId : 'closeBtn',
							text: '<t:message code="system.label.product.close" default="닫기"/>',
							handler: function() {
								searchReceptionHistory.hide();
							},
							disabled: false
						}
				],
				listeners : {beforehide: function(me, eOpt)	{
											receptionNoSearch.clearForm();
											receptionNoMasterGrid.reset();                							
                						},
                			 beforeclose: function( panel, eOpts )	{
											receptionNoSearch.clearForm();
											receptionNoMasterGrid.reset();
                			 			},
                			 show: function( panel, eOpts )	{
                			 	receptionNoSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
					    		receptionNoSearch.setValue('WORK_SHOP_CODE',masterForm.getValue('WORK_SHOP_CODE'));
					    		receptionNoSearch.setValue('ITEM_CODE',masterForm.getValue('ITEM_CODE'));
					    		receptionNoSearch.setValue('ITEM_NAME',masterForm.getValue('ITEM_NAME'));
					    		receptionNoSearch.setValue('LOT_NO',masterForm.getValue('LOT_NO'));
					    		receptionNoSearch.setValue('RECEIPT_DATE_FR', UniDate.get('startOfMonth', masterForm.getValue('RECEIPT_DATE')));
					    		receptionNoSearch.setValue('RECEIPT_DATE_TO',masterForm.getValue('RECEIPT_DATE'));						
                			 }
                }		
			})
		}
		searchReceptionHistory.show();
		searchReceptionHistory.center();
    }
    
    //생산량 참조 폼 정의
	 var productionSearch = Unilite.createSearchForm('productionForm', {
            layout :  {type : 'uniTable', columns : 2},
            items :[{
            	fieldLabel: '<t:message code="system.label.product.productiondate" default="생산일"/>',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'PRODT_DATE_FR',
			    endFieldName: 'PRODT_DATE_TO',	
			    width: 350,
			    startDate: UniDate.get('startOfMonth'),
			    endDate: UniDate.get('today')
	       },
            	Unilite.popup('DIV_PUMOK',{
            	fieldLabel		:'<t:message code="system.label.product.item" default="품목"/>' , 
            	valueFieldWidth	: 80,
            	textFieldWidth	: 140,
            	validateBlank	: false,
            	valueFieldName	:'ITEM_CODE',
				textFieldName	:'ITEM_NAME',
				listeners		: {
					onValueFieldChange: function( elm, newValue, oldValue ) {
						if(!Ext.isObject(oldValue)) {
							productionSearch.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						if(!Ext.isObject(oldValue)) {
							productionSearch.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}
				}
            }),{
	            fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
	            name: 'WORK_SHOP_CODE', 
	            xtype: 'uniCombobox', 
	            comboType: 'WU'
	        },{
	       		fieldLabel: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>',
	       		xtype: 'uniTextfield',
	       		name:'PROJECT_NO'
	       }]
    });
    
    //생산량 참조 모델 정의
	Unilite.defineModel('pms300ukrvProductionModel', {
	    fields: [{name: 'CHK'            		,text: '<t:message code="system.label.product.selection" default="선택"/>'						, type: 'string'},
				 {name: 'PRODT_DATE'     		,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'					, type: 'uniDate'},
				 {name: 'ITEM_CODE'      		,text: '<t:message code="system.label.product.item" default="품목"/>'					, type: 'string'},
				 {name: 'ITEM_NAME'      		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'						, type: 'string'},
				 {name: 'SPEC'           		,text: '<t:message code="system.label.product.spec" default="규격"/>'						, type: 'string'},
				 {name: 'STOCK_UNIT'     		,text: '<t:message code="system.label.product.unit" default="단위"/>'						, type: 'string'},
				 {name: 'PRODT_Q'        		,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'					, type: 'uniQty'},
				 {name: 'NOT_RECEIPT_Q'  		,text: '<t:message code="system.label.product.notreceiveqty" default="미접수량"/>'					, type: 'uniQty'},
				 {name: 'PRODT_NUM'      		,text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'					, type: 'string'},
				 {name: 'WKORD_NUM'     		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'				, type: 'string'},
				 {name: 'PROJECT_NO'     		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'					, type: 'string'},
				 {name: 'PJT_CODE'       		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				, type: 'string'},
				 {name: 'WK_LOT_NO'      		,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'					, type: 'string'}
		]
	});
    
    var productionStore = Unilite.createStore('pms300ukrvProductionStore', {
			model: 'pms300ukrvProductionModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read    : 'pms300ukrvService.selectEstiList'
                }
            },
            listeners:{
            	load:function(store, records, successful, eOpts)	{
            			if(successful)	{
            			   var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);  
            			   var estiRecords = new Array();
            			   
            			   if(masterRecords.items.length > 0)	{
            			   	console.log("store.items :", store.items);
            			   	console.log("records", records);
            			   	
	            			   Ext.each(records, 
	            			   			function(item, i)	{           			   								
			   								Ext.each(masterRecords.items, function(record, i)	{
			   										console.log("record :", record);
			   										
			   										if( (record.data['ESTI_NUM'] == item.data['ESTI_NUM']) 
			   											&& (record.data['ESTI_SEQ'] == item.data['ESTI_SEQ'])
			   											)	
			   										{
			   												estiRecords.push(item);
			   										}
			   								});
	            			   								
	            			   			});
	            			   store.remove(estiRecords);
            			   }
            			}
            	}
            }
            ,loadStoreRecords : function()	{
				var param= productionSearch.getValues();
				param.DIV_CODE = masterForm.getValue('DIV_CODE');
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	
	//생산량 참조 그리드 정의
    var productionGrid = Unilite.createGrid('pms300ukrvProductionGrid', {
        // title: '기본',
        layout : 'fit',
    	store: productionStore,
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
			uniOpt:{
	        	onLoadSelectFirst : false
	        },
        columns:  [{ dataIndex: 'CHK'             	,  width: 33 ,hidden: true},
        		   { dataIndex: 'PRODT_DATE'      	,  width: 80},
        		   { dataIndex: 'ITEM_CODE'       	,  width: 66},
        		   { dataIndex: 'ITEM_NAME'       	,  width: 146 },
        		   { dataIndex: 'SPEC'            	,  width: 120 },
        		   { dataIndex: 'STOCK_UNIT'      	,  width: 53 ,align:'center' },
        		   { dataIndex: 'PRODT_Q'         	,  width: 86},
        		   { dataIndex: 'NOT_RECEIPT_Q'   	,  width: 86},
        		   { dataIndex: 'PRODT_NUM'       	,  width: 133},
        		   { dataIndex: 'WKORD_NUM'      	,  width: 133},
        		   { dataIndex: 'PROJECT_NO'      	,  width: 133},
//        		   { dataIndex: 'PJT_CODE'        	,  width: 133},
        		   { dataIndex: 'WK_LOT_NO'       	,  width: 133}        		   
          ] 
       ,listeners: {	
          		onGridDblClick:function(grid, record, cellIndex, colName) {
  				}
       		}
       	,returnData: function()	{
       		var records = this.getSelectedRecords();
       		
			Ext.each(records, function(record,i){	
							        	UniAppManager.app.onNewDataButtonDown();
							        	detailGrid.setEstiData(record.data);								        
								    }); 
			//this.deleteSelectedRow();
			this.getStore().remove(records);
       	}  
    });
    
    //생산량 참조 메인
//    function openProductionWindow() {    		
//  		if(!UniAppManager.app.checkForNewDetail()) return false;
//  	 
//	  	productionSearch.setValue('PRODT_DATE_FR', UniDate.get('startOfMonth', masterForm.getValue('RECEIPT_DATE')));
//  		productionSearch.setValue('PRODT_DATE_TO',masterForm.getValue('RECEIPT_DATE'));
//  		// 화면 처음 구동시, 생산량 참조를 눌렀을 때 만 날짜 데이터 값 받아오는 로직 필요.
//  		
//  		productionSearch.setValue('ITEM_CODE',masterForm.getValue('ITEM_CODE'));
//  		productionSearch.setValue('ITEM_NAME',masterForm.getValue('ITEM_NAME'));
//  		productionSearch.setValue('WORK_SHOP_CODE',masterForm.getValue('WORK_SHOP_CODE'));
//  		productionSearch.setValue('PROJECT_NO',masterForm.getValue('PROJECT_NO'));
//  		
//		if(!referProductionWindow) {
//			referProductionWindow = Ext.create('widget.uniDetailWindow', {
//                title: '<t:message code="system.label.product.productionqtyrefer" default="생산량참조"/>',
//                width: 830,				                
//                height: 580,
//                layout:{type:'vbox', align:'stretch'},
//                
//                items: [productionSearch, productionGrid],
//                tbar:  [
//								        {	itemId : 'saveBtn',
//											text: '<t:message code="system.label.product.inquiry" default="조회"/>',
//											handler: function() {
//												productionStore.loadStoreRecords();
//											},
//											disabled: false
//										}, 
//										{	itemId : 'confirmBtn',
//											text: '<t:message code="system.label.product.apply" default="적용"/>',
//											handler: function() {
//												productionGrid.returnData();
//											},
//											disabled: false
//										},
//										{	itemId : 'confirmCloseBtn',
//											text: '<t:message code="system.label.product.afterapplyclose" default="적용 후 닫기"/>',
//											handler: function() {
//												productionGrid.returnData();
////												alert(11);
//												referProductionWindow.hide();
////												alert(22);
//											},
//											disabled: false
//										},'->',{
//											itemId : 'closeBtn',
//											text: '<t:message code="system.label.product.close" default="닫기"/>',
//											handler: function() {
//												referProductionWindow.hide();
//											},
//											disabled: false
//										}
//							    ]
//							,
//                listeners : {beforehide: function(me, eOpt)	{
//                							//requestSearch.clearForm();
////                							productionGrid.reset();
//                							alert(33);
//                						},
//                			 beforeclose: function( panel, eOpts )	{
//											//requestSearch.clearForm();
//                							//requestGrid,reset();
//                			 			},
//                			 beforeshow: function ( me, eOpts )	{
//                			 	productionStore.clearData();
//                			 	productionGrid.reset();
//                			 	productionStore.loadStoreRecords();
//                			 }
//                }
//			})
//		}
//		referProductionWindow.show();
//    }

        function openProductionWindow() {           // 참조
        if(!UniAppManager.app.checkForNewDetail()) return false;
        
        if(!referProductionWindow) {
            referProductionWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.product.productionqtyrefer" default="생산량참조"/>',
                width: 1080,                             
                height: 580,
                layout:{type:'vbox', align:'stretch'},             
                items: [productionSearch, productionGrid], 

                tbar:  ['->',
                    {   itemId : 'saveBtn',
                        text: '<t:message code="system.label.product.inquiry" default="조회"/>',
                        handler: function() {
                            productionStore.loadStoreRecords();
                        },
                        disabled: false
                    },{ itemId : 'confirmBtn',
                        text: '<t:message code="system.label.product.apply" default="적용"/>',
                        handler: function() {
                            productionGrid.returnData();
                        },
                        disabled: false
                    },{ itemId : 'confirmCloseBtn',
                        text: '<t:message code="system.label.product.afterapplyclose" default="적용 후 닫기"/>',
                        handler: function() {
                            productionGrid.returnData();
                            referProductionWindow.hide();
//                            referProductionWindow.close();
//                            UniAppManager.setToolbarButtons('reset', true)
                        },
                        disabled: false
                    },{
                        itemId : 'closeBtn',
                        text: '<t:message code="system.label.product.close" default="닫기"/>',
                        handler: function() {
                            referProductionWindow.hide();
//                            referProductionWindow.close();
//                            UniAppManager.setToolbarButtons('reset', true)
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                        productionSearch.clearForm();
//                        productionStore.clearData(); //
//                        productionGrid.reset();                                            
                    },
                    beforeclose: function( panel, eOpts )   {
                        productionSearch.clearForm();
//                        productionStore.clearData(); //
//                        productionGrid.reset();
                    },
                    beforeshow: function( panel, eOpts )  {
                        productionSearch.setValue('PRODT_DATE_TO',	UniDate.get('today'));
                        productionSearch.setValue('PRODT_DATE_FR',	UniDate.get('startOfMonth'));
                        productionSearch.setValue('ITEM_CODE',		masterForm.getValue('ITEM_CODE'));
                        productionSearch.setValue('ITEM_NAME',		masterForm.getValue('ITEM_NAME'));
                    }
                }       
            })
        }
        referProductionWindow.show();
        referProductionWindow.center();
    }
    
    
    
    
    
    
	Unilite.Main({
		id: 'pms300ukrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				detailGrid, panelResult
			]
		},
			masterForm  
		],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			detailGrid.disabledLinkButtons(false);
			if(Ext.isEmpty(params)){
				this.setDefault();
			}else{
				this.processParams(params);
			}
		},
		onQueryButtonDown: function() {
			masterForm.setAllFieldsReadOnly(false);
			var orderNo = masterForm.getValue('RECEIPT_NUM');
			if(Ext.isEmpty(orderNo)) {
				opensearchReceptionHistory() 
			} else {
				var param= masterForm.getValues();
				detailStore.loadStoreRecords();	
			}
			
			var rowIndex = detailStore.getCount();
            
//			alert('rowIndex' + rowIndex);
            
            if (rowIndex == 0 ){
                 UniAppManager.setToolbarButtons('save', false);
            }
            
            
            
            
            
			
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				 var receipt_num = masterForm.getValue('RECEIPT_NUM')
				 var seq = detailStore.max('RECEIPT_SEQ');
				 if(!seq) seq = 1;
            	 else  seq += 1;
				 
				 var r = { 
				 	 		RECEIPT_NUM : receipt_num,
				 	 		RECEIPT_SEQ : seq
						 };
			detailGrid.createRow(r, 'RECEIPT_SEQ', seq-2);
			masterForm.setAllFieldsReadOnly(false);
		},
			
		onResetButtonDown: function() {
			this.suspendEvents();
			masterForm.clearForm();			
			panelResult.clearForm();
			detailGrid.reset();
			detailStore.clearData();
            masterForm.setAllFieldsReadOnly(false);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
			
			var rowIndex = detailStore.getCount();
            
//            alert('rowIndex' + rowIndex);
            if(rowIndex ==0){
                masterForm.setValue('RECEIPT_NUM', '');
                panelResult.setValue('RECEIPT_NUM', '');
            }
            
             productionStore.clearData(); //
             productionGrid.reset(); 
            
			
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('INSPEC_Q') > 1)
				{
					alert('<t:message code="system.message.product.message038" default="검사진행된 품목입니다. 삭제 할 수 없습니다."/>');
					
				}else{
					detailGrid.deleteSelectedRow();
				}
			}
			
			
			
			// fnOrderAmtSum 호출(grid summary 이용)
		},
		
		//전체삭제
        /*onDeleteAllButtonDown: function() {         
            var records = directMasterStore1.data.items;
            //var records = detailStore.data.items;
            var isNewData = false;
            Ext.each(records, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    if(confirm('전체삭제 하시겠습니까?')) {
                        var deletable = true;
                        if(deletable){      
                            masterGrid.reset();         
                            UniAppManager.app.onSaveDataButtonDown();   
                        }                                                   
                        isNewData = false;
                    }
                    return false;
                }
            });
            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋          
                masterGrid.reset();
                UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
            }
            
            
            if(confirm(Msg.sMH1353 + "\n" + Msg.sMB064)) {  
                detailGrid.reset();
                UniAppManager.setToolbarButtons('deleteAll', false);
            }
        
            UniAppManager.setToolbarButtons('save', false);     
            
        },*/
         onDeleteAllButtonDown: function() {            
            var records = detailStore.data.items;
            var isNewData = false;
            Ext.each(records, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    isNewData = false;
                    if(confirm('<t:message code="system.message.product.confirm002" default="전체삭제 하시겠습니까?"/>')) {
                        var deletable = true;
                        /*---------삭제전 로직 구현 시작----------*/
                        
                        
                        /*---------삭제전 로직 구현 끝-----------*/
                        
                        if(deletable){      
                            detailGrid.reset();         
                            UniAppManager.app.onSaveDataButtonDown();   
                        }                                                   
                    }
                    return false;
                }
            });
            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋          
                detailGrid.reset();
                UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
            }
            
        },
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'pms300skrv') {
				
				masterForm.clearForm();
				panelResult.clearForm();
				detailGrid.reset();
				detailStore.clearData();
				
				masterForm.setValue('DIV_CODE',params.DIV_CODE);
				panelResult.setValue('DIV_CODE',params.DIV_CODE);
				
	        	masterForm.setValue('RECEIPT_DATE', UniDate.get('today'));
	            panelResult.setValue('RECEIPT_DATE', UniDate.get('today'));
				
	            
	            
	            
	            
	            
				var r = { 
				 	 		DIV_CODE : params.DIV_CODE,
				 	 		RECEIPT_SEQ : 1,
				 	 		RECEIPT_DATE : UniDate.get('today'),
				 	 
							ITEM_CODE:    params.ITEM_CODE,
							ITEM_NAME:    params.ITEM_NAME,
							SPEC:         params.SPEC,
							STOCK_UNIT:   '',
							NOT_RECEIPT_Q:params.NOTRECEIPT_Q,
							RECEIPT_Q:    params.RECEIPT_Q,
							INSPEC_Q:     0,
							RECEIPT_PRSN: params.RECEIPT_PRSN,
							LOT_NO:       params.LOT_NO,
							PRODT_NUM:    params.PRODT_NUM,
							WKORD_NUM:    '',
							PROJECT_NO:   '',
							PJT_CODE:     '',
							REMARK:       params.RECEIPT_REMARK,
							COMP_CODE:    UserInfo.compCode
				 	 		
				 	 		
				 	 		
				 	 		
						 };
				detailGrid.createRow(r);
				
			}
		},
		
		checkForNewDetail:function() { 
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('RECEIPT_NUM')))	{
				alert('<t:message code="system.label.product.sono" default="수주번호"/>:<t:message code="system.message.product.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return masterForm.setAllFieldsReadOnly(true);
        },
		onDetailButtonDown: function() {
			var as = Ext.getCmp('pms300ukrvAdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			} else {
				as.hide()
			}
		},
		rejectSave: function() {
			var rowIndex = detailGrid.getSelectedRowIndex();
			detailGrid.select(rowIndex);
			detailStore.rejectChanges();
			
			if(rowIndex >= 0){
				detailGrid.getSelectionModel().select(rowIndex);
				var selected = detailGrid.getSelectedRecord();
				
				var selected_doc_no = selected.data['DOC_NO'];
  				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {															
					}
				);
			}
			detailStore.onStoreActionEnable();
		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('pms300ukrvFileUploadPanel');
        	if(detailStore.isDirty() || fp.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		fnInspecQtyCheck: function(rtnRecord, fieldName, oldValue, divCode, receiptNum, receiptSeq)	{
			var param = {
				'DIV_CODE':divCode,
				'RECEIPT_NUM':receiptNum,
				'RECEIPT_SEQ':receiptSeq	
			}
			pms300ukrvService.inspecQtyCheck(param, function(provider, response)	{
				if(!Ext.isEmpty(provider) && provider.length > 0 )	{
					alert('<t:message code="system.message.product.message058" default="검사된 수량이 존재합니다. 데이터를 수정할 수 없습니다."/>');
					rtnRecord.set(fieldName, oldValue);
					UniAppManager.app.onQueryButtonDown();
				}
			})
		},
		setDefault: function() {
        	masterForm.setValue('DIV_CODE', UserInfo.divCode);
        	masterForm.setValue('RECEIPT_DATE', UniDate.get('today'));
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('RECEIPT_DATE', UniDate.get('today'));
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);		
		}
	});
		
    /**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "RECEIPT_Q" ://접수량
				//var itemCode = newValue
			/*		if(newValue == 0 || newValue == ''){
						rv=' 라인의 접수량이 0이거나 데이터가 없습니다. ';
		
						break;
					}*/
					if(newValue < 1 ){

//						alert("old:" + oldValue);
						rv='<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
						//record.
						//record.set('RECEIPT_Q',oldValue);
						 //접수량이 1보다 작거나 데이터가 없습니다.
						break;
					}
				/*	if(record.get('RECEIPT_Q'))
					{
						var receipt = record.get('RECEIPT_Q');
						
						if (receipt = ''){
		
							break;
						}
						else if (receipt = 0){
	
							break;
						}
					}
					*/
					if(Ext.isNumeric(record.get('NOT_RECEIPT_Q')))
					{
						var notreceiptQ = record.get('NOT_RECEIPT_Q');

						if(notreceiptQ < newValue ){
							rv='<t:message code="system.message.product.message039" default="접수수량은 잔량보다 적어야 합니다."/>';
							//접수수량은 잔량보다 적어야 합니다.				
						}
						break;
					}
				if(record.phantom == false)
				{
					var divCode = masterForm.getValue('DIV_CODE');
					var receiptNum = record.get('RECEIPT_NUM');
					var receiptSeq = record.get('RECEIPT_SEQ');
					UniAppManager.app.fnInspecQtyCheck(record, fieldName, oldValue, divCode, receiptNum, receiptSeq );
				}
				break;
			}
			return rv;
		}
	}); // validator
}
</script>