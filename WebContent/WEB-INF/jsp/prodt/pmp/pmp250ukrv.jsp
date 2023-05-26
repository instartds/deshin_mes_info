<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp250ukrv"  >
<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->  
<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> 	<!-- 작업장 --> 
<t:ExtComboStore comboType="AU" comboCode="P102"/> 				<!-- 적용여부 -->  
<t:ExtComboStore comboType="AU" comboCode="P106"/> 				<!-- 예약마감여부 -->  
<t:ExtComboStore comboType="AU" comboCode="B083"/> 				<!-- BOM PATH정보 -->  
<t:ExtComboStore comboType="AU" comboCode="P117"/> 				<!-- 승인여부 -->
<t:ExtComboStore comboType="AU" comboCode="P118"/> 				<!-- 출고요청 승인방식 -->
<t:ExtComboStore comboType="AU" comboCode="P119"/>				<!-- 출고요청담당 -->
<t:ExtComboStore comboType="WU" />        <!-- 작업장-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript">

var BsaCodeInfo = {
	gsBomPathYN: '${gsBomPathYN}'							//'BOM PATH 관리여부
};

//var output ='';
//for(var key in BsaCodeInfo){
//	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);												

var outDivCode = UserInfo.divCode;
//																??

var checkDraftStatus = false;
//																??

function appMain() {  
	var isAutoPath = true;
	if(BsaCodeInfo.gsBomPathYN=='Y'){
		isAutoPath = false;
	}
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 		'pmp250ukrvService.selectDetailList',
			update: 	'pmp250ukrvService.updateDetail',
//			create: 	'pmp250ukrvService.insertDetail',
//			destroy:	'pmp250ukrvService.deleteDetail',
			syncAll:	'pmp250ukrvService.saveAll'
		}
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {
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
	        // dirtychange : 조회된 그리드에 data등의 변경이 일어났을 경우 자동으로 실행되는 패널, 이 프로그램에서는 필요없음
	        /*dirtychange: function(basicForm, dirty, eOpts) {
				UniAppManager.setToolbarButtons('save', true);
			}*/
	    },
		items: [{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
        		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
        	},
		    	Unilite.popup('ITEM',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					validateBlank:false,
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
		        allowBlank:false,
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			},{ 
		        fieldLabel: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>', 
				xtype: 'uniDateRangefield', 
				startFieldName: 'REQ_DATE_FR',
				endFieldName: 'REQ_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('REQ_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('REQ_DATE_TO',newValue);			    		
			    	}
			    }
			},{
		        fieldLabel: '<t:message code="system.label.product.approveyesno" default="승인여부"/>',
		        name:'AGREE_STATUS', 
		        xtype: 'uniCombobox', 
		        comboType:'AU' ,
		        comboCode:'P117',
		        allowBlank:false,
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AGREE_STATUS', newValue);
					}
				}
		    },{
		        fieldLabel: '<t:message code="system.label.product.issuerequestcharge" default="출고요청담당"/>',
		        name:'OUT_REQ_PRSN', 
		        xtype: 'uniCombobox', 
		        comboType:'AU' ,
		        comboCode:'P119',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('OUT_REQ_PRSN', newValue);
					}
				}
		    },{
		    	fieldLabel: '<t:message code="system.label.product.approvaluser" default="승인자"/>',
			 	xtype: 'uniTextfield',
			 	value: UserInfo.userName,
			 	readOnly:true,
			 	name : 'USER_NAME',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('USER_NAME', newValue);
					}
				}
			},{
		    	fieldLabel: '',
			 	xtype: 'uniTextfield',           // hidden: true ID 값만 받아오기
			 	name: 'AGREE_PRSN',
			 	//readOnly:true,
			 	value: UserInfo.userID,
			 	hidden: true,
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AGREE_PRSN', newValue);
					}
				}
			},{
		 		fieldLabel: '<t:message code="system.label.product.approvaldate" default="승인일"/>',
		 		xtype: 'uniDatefield',
		 		name: 'AGREE_DATE',
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AGREE_DATE', newValue);
						var record = detailGrid.getStore().data.items;
						record.set('AGREE_DATE', newValue);
					}
				}
			}/*,{
		 		fieldLabel: '승인일Grid용',
		 		xtype: 'uniDatefield',
		 		name: 'AGREE_DATE1',
		 		hidden:false
			}*/]		            			 
	    }],
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
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
        	},
		    	Unilite.popup('ITEM',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					validateBlank:false,
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					colspan:2,
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
		        allowBlank:false,
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			},{ 
		        fieldLabel: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>', 
				xtype: 'uniDateRangefield', 
				startFieldName: 'REQ_DATE_FR',
				endFieldName: 'REQ_DATE_TO',
				colspan:2,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('REQ_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('REQ_DATE_TO',newValue);			    		
			    	}
			    }
			},{
		        fieldLabel: '<t:message code="system.label.product.approveyesno" default="승인여부"/>',
		        name:'AGREE_STATUS', 
		        xtype: 'uniCombobox', 
		        comboType:'AU' ,
		        comboCode:'P117',
		        allowBlank:false,
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AGREE_STATUS', newValue);
					}
				}
		    },{
		        fieldLabel: '<t:message code="system.label.product.issuerequestcharge" default="출고요청담당"/>',
		        name:'OUT_REQ_PRSN', 
		        xtype: 'uniCombobox', 
		        comboType:'AU' ,
		        comboCode:'P119',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('OUT_REQ_PRSN', newValue);
					}
				}
		    },{
		    	fieldLabel: '<t:message code="system.label.product.approvaluser" default="승인자"/>',
			 	xtype: 'uniTextfield',
			 	value: UserInfo.userName,
			 	readOnly:true,
			 	name : 'USER_NAME',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('USER_NAME', newValue);
					}
				}
			},{
		    	fieldLabel: '',
			 	xtype: 'uniTextfield',           // hidden: true ID 값만 받아오기
			 	name: 'AGREE_PRSN',
			 	value: UserInfo.userID,
			 	hidden: true,
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AGREE_PRSN', newValue);
					}
				}
			},{
		 		fieldLabel: '<t:message code="system.label.product.approvaldate" default="승인일"/>',
		 		xtype: 'uniDatefield',
		 		name: 'AGREE_DATE',
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AGREE_DATE', newValue);
					}
				}
			}]
    });
	
	/**
	 *   Model 정의 
	 * @type  
	 */
	Unilite.defineModel('pmp250ukrvDetailModel', {
	    fields: [  	 
	    	{name: 'CHOICE'           	  	,text: '<t:message code="system.label.product.selection" default="선택"/>'				,type:'string'},
			{name: 'AGREE_STATUS'     	 	,text: '<t:message code="system.label.product.approvalstatus" default="승인상태"/>'			,type:'string' , comboType: 'AU', comboCode: 'P117' ,defaultValue:'1'},
			{name: 'DIV_CODE'         		,text: '<t:message code="system.label.product.division" default="사업장"/>'			,type:'string'},
			{name: 'ITEM_CODE'        	  	,text: '<t:message code="system.label.product.item" default="품목"/>'			,type:'string'},
			{name: 'ITEM_NAME'        		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type:'string'},
			{name: 'SPEC'             		,text: '<t:message code="system.label.product.spec" default="규격"/>'				,type:'string'},
			{name: 'STOCK_UNIT'       		,text: '<t:message code="system.label.product.unit" default="단위"/>'				,type:'string'},
			{name: 'PATH_CODE'        	 	,text: '<t:message code="system.label.product.pathinfo" default="PATH정보"/>'			,type:'string' , comboType: 'AU', comboCode: 'B083'},
			{name: 'OUTSTOCK_REQ_Q'   		,text: '<t:message code="system.label.product.issuerequestqty" default="출고요청량"/>'			,type:'uniQty'},
			{name: 'OUTSTOCK_Q'       		,text: '<t:message code="system.label.product.issueqty" default="출고량"/>'			,type:'uniQty'},
			{name: 'REQ_DATE'				,text: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>'			,type:'uniDate'},
			{name: 'CONTROL_STATUS'   	  	,text: '<t:message code="system.label.product.processstatus" default="진행상태"/>'			,type:'string' , comboType: 'AU', comboCode: 'P106'},
			{name: 'REF_WKORD_NUM'    		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string'},	
			{name: 'REMARK'           		,text: '<t:message code="system.label.product.remarks" default="비고"/>'				,type:'string'},
			{name: 'PROJECT_NO'       	  	,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
//			{name: 'PJT_CODE'         		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type:'string'},
			{name: 'OUTSTOCK_NUM'     		,text: '<t:message code="system.label.product.issuerequestno" default="출고요청번호"/>'		,type:'string'},
			{name: 'OUTSTOCK_REQ_PRSN'	  	,text: '<t:message code="system.label.product.issuerequestcharge" default="출고요청담당"/>'		,type:'string' , comboType: 'AU', comboCode: 'P119'},
			{name: 'AGREE_PRSN'       	 	,text: '<t:message code="system.label.product.approvaluser" default="승인자"/>'			,type:'string' , defaultValue:UserInfo.UserID},
			{name: 'AGREE_DATE'       	 	,text: '<t:message code="system.label.product.approvaldate" default="승인일"/>'			,type:'uniDate'},
			{name: 'AGREE_DATE_TEMP'       	,text: '<t:message code="system.label.product.approvaldate" default="승인일"/>TEMP'		,type:'uniDate'},
			{name: 'UPDATE_DB_USER'   		,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'			,type:'string'},
			{name: 'UPDATE_DB_TIME'   	  	,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'			,type:'uniDate'}
		]
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var detailStore = Unilite.createStore('pmp250ukrvDetailStore', {
		model: 'pmp250ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: 	true,			// 상위 버튼 연결
			editable: 	false,			// 수정 모드 사용
			deletable:	false,			// 삭제 가능 여부 (공통에서 제어하는 버튼은 Store에서 컨트롤 해야 함)
			useNavi : 	false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		/*listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(!Ext.isEmpty(records)){
           			//panelSearch.getField('AGREE_DATE').setReadOnly( true ); // data 없을 때 AGREE_DATE 읽기전용 설정				  
           		}
           		UniAppManager.setToolbarButtons(['newData','delete'], false);
           	},
           	add: function(store, records, index, eOpts) {	
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		},*/
		loadStoreRecords: function(store, records, successful, eOpts) {
			var param= panelSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		},
		
		saveStore: function() {	
			var inValidRecs = this.getInvalidRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	if(inValidRecs.length == 0 )	{										
				config = {
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);	
						UniAppManager.app.onQueryButtonDown();
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var detailGrid = Unilite.createGrid('pmp250ukrvGrid', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
			onLoadSelectFirst : false
        },
    	store: detailStore,
    	selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: false,
        	listeners: {        		
        		select: function(grid, record, index, eOpts, newValue, oldValue ){
					UniAppManager.setToolbarButtons('save', true);
					record.set('AGREE_DATE_TEMP' , panelSearch.getValue('AGREE_DATE')); 
	          	},
				deselect:  function(grid, record, index, eOpts, newValue, oldValue ){	
					record.set('AGREE_DATE_TEMP' , ''); 
					UniAppManager.setToolbarButtons('save', false);
        		}
        	}
        }), 
		uniOpt:{
	        onLoadSelectFirst : false
//																		??	        
	    },
        columns: [        		
			{dataIndex: 'CHOICE'            	, width: 33 , hidden: true}, 							
			{dataIndex: 'AGREE_STATUS'      	, width: 66 , locked: true}, 							
			{dataIndex: 'COMP_CODE'          	, width: 66 , hidden: true}, 								
			{dataIndex: 'DIV_CODE'         		, width: 66 , hidden: true}, 												
			{dataIndex: 'ITEM_CODE'         	, width: 100, locked: true},
			{dataIndex: 'ITEM_NAME'         	, width: 166, locked: true}, 							
			{dataIndex: 'SPEC'              	, width: 133}, 							
			{dataIndex: 'STOCK_UNIT'         	, width: 66}, 								
			{dataIndex: 'PATH_CODE'        		, width: 66 , hidden: isAutoPath}, 												
			{dataIndex: 'OUTSTOCK_REQ_Q'    	, width: 80},
			{dataIndex: 'OUTSTOCK_Q'        	, width: 80}, 							
			{dataIndex: 'REQ_DATE' 				, width: 66 , hidden: true}, 							
			{dataIndex: 'CONTROL_STATUS'     	, width: 73}, 								
			{dataIndex: 'REF_WKORD_NUM'    		, width: 113}, 												
			{dataIndex: 'REMARK'            	, width: 133},
			{dataIndex: 'PROJECT_NO'        	, width: 100}, 							
//			{dataIndex: 'PJT_CODE'          	, width: 100}, 							
			{dataIndex: 'OUTSTOCK_NUM'       	, width: 66 , hidden: true}, 								
			{dataIndex: 'OUTSTOCK_REQ_PRSN'		, width: 66 , hidden: true}, 												
			{dataIndex: 'AGREE_PRSN'        	, width: 66 , hidden: true},
			{dataIndex: 'AGREE_DATE'        	, width: 80 , hidden: true}, 	
			{dataIndex: 'AGREE_DATE_TEMP'       , width: 80 , hidden: true}, 						
			{dataIndex: 'UPDATE_DB_USER'    	, width: 66 , hidden: true}, 							
			{dataIndex: 'UPDATE_DB_TIME'     	, width: 66 , hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(checkDraftStatus)	{
					return false;
				}else if(!e.record.phantom) {
					if (UniUtils.indexOf(e.field)) {
						return false;
					}
				}
			}/*,
			selectionchange:function( model1, selected, eOpts ){
	       		if(selected.length > 0)	{
	       			var record = selected[0];
	        		this.returnCell(record);  
	       		}
	       	}*/
		},
       	/*returnCell: function(record) {
       		var agreeDate	= record.get("AGREE_DATE");
       		panelSearch.setValues({'AGREE_DATE1':agreeDate});
       	},*/
			disabledLinkButtons: function(b) {
			}
    });
    
	Unilite.Main ({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		detailGrid, panelResult
         	]	
      	},
      	panelSearch     
      	],	
		id: 'pmp250ukrvApp',		
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['prev', 'next'], true);
			UniAppManager.setToolbarButtons(['reset', 'newData','delete'], false);
			detailGrid.disabledLinkButtons(false);
			this.setDefault();
		},
		
		onQueryButtonDown: function() {
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			var param= panelSearch.getValues();
			detailStore.loadStoreRecords();	
			UniAppManager.setToolbarButtons(['newData','delete'], false);
			//UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('reset', true);
		},		
		
		onSaveDataButtonDown: function(config) {
			var DefaultDate = panelSearch.getValue('AGREE_DATE');
			if (DefaultDate == ''){
				alert('<t:message code="system.message.product.datacheck001" default="필수입력 항목입니다."/>');
				panelSearch.getField('AGREE_DATE').focus();
			}
			detailStore.saveStore();
		},

		onResetButtonDown: function() {
			this.suspendEvents();
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			detailGrid.reset();
		
			this.fnInitBinding();
			//panelSearch.getField('AGREE_DATE').setReadOnly( false );
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('pmp250ukrvAdvanceSerch');	
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
			var fp = Ext.getCmp('pmp250ukrvFileUploadPanel');
        	if(detailStore.isDirty() || fp.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('AGREE_STATUS', '1');
			panelResult.setValue('AGREE_STATUS', '1');
			
			panelSearch.setValue('AGREE_DATE',new Date());
			panelResult.setValue('AGREE_DATE',new Date());
			panelSearch.setValue('USER_NAME',UserInfo.userName);
        	
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);	
		},
        checkForNewDetail:function() { 
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelSearch.getValue('CUSTOM_CODE')))	{
				alert('<t:message code="system.label.product.custom" default="거래처"/>:<t:message code="system.message.product.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			/**
			 * 여신한도 확인
			 */ 
			if(!panelSearch.fnCreditCheck())	{
				return false;
			}
			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return panelSearch.setAllFieldsReadOnly(true);
        },
        
        fnCheckNum: function(value, record, fieldName) {
        	var r = true;
        	if(record.get("PRICE_YN") == "1" || record.get("ACCOUNT_YNC")=="N")	{
        		r = true;
        	} else if(record.get("PRICE_YN") == "2" )	{
        		if(value < 0)	{
        			alert(Msg.sMB076);
        			r=false;
        			return r;
        		}else if(value == 0)	{
        			if(fieldName == "ORDER_TAX_O")	{
        				if(BsaCodeInfo.gsVatRate != 0)	{            				
    						alert(Msg.sMB083);
    						r=false;          
        				}
        			}else {
        				alert(Msg.sMB083);
    					r=false;
        			}
        		}
        	}
        	return r;
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
			}
			return rv;
		}
	}); // validator
	
	Unilite.createValidator('validator02', {
		forms: {'formA:':panelSearch},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			var agreeStatus = form.getField('AGREE_STATUS').getSubmitValue();  // 승인여부
			//var agreeDate = form.getField('AGREE_DATE').getSubmitValue();  	   // 승인일

			//alert(newValue)
			switch(fieldName) {				
				case "AGREE_STATUS" : // 승인여부
//					if(newValue == 1)
//					{

//						break;
//						//출고요청내역을 승인하겠습니까?
//					}
//					else if(newValue == 2)
//					{

//						break;
//						//출고요청내역을 승인 취소하겠습니까?
//					}
//					alert(agreeStatus);
//					if(agreeStatus == '2'){
//						panelSearch.getField('AGREE_DATE').setReadOnly( true );
//						//field.agreeDate.setReadOnly(true);\						
//					}
//					else{
//	보류					panelSearch.getField('AGREE_DATE').setReadOnly( false );						
//					}
//					break;
//				case "WORK_SHOP_CODE" :
//					alert(newValue);
//					break;		
			}
			return rv;
		}
	}); // validator02
}
</script>
