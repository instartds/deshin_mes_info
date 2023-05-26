<%--
'   프로그램명 : 출고요청등록(생산)
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
<t:appConfig pgmId="pmp200ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList"/> 	<!-- 작업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P102"/> 				<!-- 적용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"/> 				<!-- 예약마감여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B083"/> 				<!-- BOM PATH 정보 -->
	<t:ExtComboStore comboType="AU" comboCode="P117"/> 				<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="P118"/> 				<!-- 출고요청 승인방식 -->
	<t:ExtComboStore comboType="AU" comboCode="P119"/> 				<!-- 출고요청담당 -->
	<t:ExtComboStore comboType="AU" comboCode="P106"/> 				<!-- 진행상태 -->
	<t:ExtComboStore comboType="WU" />        <!-- 작업장-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var searchInfoWindow;										// issueRequest 조회창
var referWorkOrderWindow;  									// 작업지시참조 팝업
var outDivCode = UserInfo.divCode;
var checkDraftStatus = false;

var BsaCodeInfo = {
	gsAutoAgree:		'${gsAutoAgree}',					//출고요청 승인방식(수동/자동승인) 공통코드에서 가져오기(P118) - SubCode 값 리턴(수동:1, 자동:2)
	gsAutoType:			'${gsAutoType}',					//자동채번유무 공통코드에서 가져오기(P005) - Refcode에 있는 Y(자동채번)또는 N(또는 ''(수동채번)) 리턴
	//gsAgreePrsn:		'${gsAgreePrsn}',					//승인자ID 가져오기 (P119)
	gsShowBtnReserveYN: '${gsShowBtnReserveYN}',				//BOM PATH 관리여부
	gsReportGubun: '${gsReportGubun}'
};

//자동승인 여부에 따라 컬럼 hidden처리 위해 변수 정의
var hiddenYN 		= true
var allowBlankYN 	= true
	if (BsaCodeInfo.gsAutoAgree == 2)  {
		hiddenYN 		= true,
		allowBlankYN 	= true
	}else if(BsaCodeInfo.gsAutoAgree != 2){
		hiddenYN 		= false,
		allowBlankYN 	= false
	}
var query02Load = "1";


function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read:		'pmp200ukrvService.selectMaster',
			update:		'pmp200ukrvService.updateDetail',
			create:		'pmp200ukrvService.insertDetail',
			destroy:	'pmp200ukrvService.deleteDetail',
			syncAll:	'pmp200ukrvService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read:		'pmp200ukrvService.orderApply2'
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
		        value:UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
						panelSearch.setValue('WORK_SHOP_CODE','');
					}
				}
		    },{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
		 		allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelResult.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;   
                            });
                            prStore.filterBy(function(record){
                                return false;   
                            });
                        }
                    }
				}
			},{
		    	fieldLabel: '<t:message code="system.label.product.issuerequestno" default="출고요청번호"/>',
			 	xtype: 'uniTextfield',
			 	name: 'OUTSTOCK_NUM',
			 	readOnly: true,
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('OUTSTOCK_NUM', newValue);
						
						if(!Ext.isEmpty(newValue)){
							UniAppManager.setToolbarButtons(['print'], true);
						}else{
							UniAppManager.setToolbarButtons(['print'], false);
						}
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.issuerequestcharge" default="출고요청담당"/>',
				name: 'OUT_REQ_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'P119',
				hidden: hiddenYN,
		 		allowBlank: allowBlankYN,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('OUT_REQ_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.approveyesno" default="승인여부"/>',
				name: 'AGREE_YN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'P117',
		 		allowBlank:false,
				hidden: hiddenYN,
		 		allowBlank: allowBlankYN,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AGREE_YN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.approvaluser" default="승인자"/>',
				name: 'AGREE_PRSN',
				xtype: 'uniTextfield',
		 		allowBlank:false,
				hidden: hiddenYN,
		 		allowBlank: allowBlankYN,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AGREE_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.approvaldate" default="승인일"/>',
				name: 'AGREE_DATE',
				xtype: 'uniTextfield',
				hidden: hiddenYN,
		 		allowBlank: allowBlankYN,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AGREE_DATE', newValue);
					}
				}
			},{
		 		fieldLabel: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>',
		 		xtype: 'uniDatefield',
		 		name: 'OUTSTOCK_REQ_DATE',
		 		value: UniDate.get('today'),
		 		allowBlank:false,
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('OUTSTOCK_REQ_DATE', newValue);
						}
					}
			},{
				fieldLabel: '참조 작지번호 SET용',
				name: 'REF_WKORD_NUM',
				xtype: 'uniTextfield',
				hidden: true
			},{
				fieldLabel: '사업장 SET용',
				name: 'DIV_CODE_TEMP',
				xtype: 'uniTextfield',
				hidden: true
			}
			,{
				fieldLabel: '작업장 SET용',
				name: 'WORK_SHOP_CODE_TEMP',
				xtype: 'uniTextfield',
				hidden: true
			}
			,{
				fieldLabel: '품목 SET용',
				name: 'ITEM_CODE_TEMP',
				xtype: 'uniTextfield',
				hidden: true
			}
			,{
				fieldLabel: 'PATH정보 SET용',
				name: 'PATH_CODE_TEMP',
				xtype: 'uniTextfield',
				hidden: true
			}]
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
					Unilite.messageBox(labelText+Msg.sMB083);
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

	var panelResult = Unilite.createSearchForm('resultForm',{
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
	        value:UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
					panelResult.setValue('WORK_SHOP_CODE','');
				}
			}
	    },{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType: 'WU',
	 		allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				},
				beforequery:function( queryPlan, eOpts )   {
                    var store = queryPlan.combo.store;
                    var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
                    store.clearFilter();
                    prStore.clearFilter();
                    if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                        store.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        });
                        prStore.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        });
                    }else{
                        store.filterBy(function(record){
                            return false;   
                        });
                        prStore.filterBy(function(record){
                            return false;   
                        });
                    }
                }
			}
		},{
	    	fieldLabel: '<t:message code="system.label.product.issuerequestno" default="출고요청번호"/>',
		 	xtype: 'uniTextfield',
		 	name: 'OUTSTOCK_NUM',
		 	readOnly: true,
		 	listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('OUTSTOCK_NUM', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.issuerequestcharge" default="출고요청담당"/>',
			name: 'OUT_REQ_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'P119',
	 		allowBlank:false,
			hidden: hiddenYN,
	 		allowBlank: allowBlankYN,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('OUT_REQ_PRSN', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.approveyesno" default="승인여부"/>',
			name: 'AGREE_YN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'P117',
	 		allowBlank:false,
			hidden: hiddenYN,
	 		allowBlank: allowBlankYN,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AGREE_YN', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.approvaluser" default="승인자"/>',
			name: 'AGREE_PRSN',
			xtype: 'uniTextfield',
	 		allowBlank:false,
			hidden: hiddenYN,
	 		allowBlank: allowBlankYN,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AGREE_PRSN', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.approvaldate" default="승인일"/>',
			name: 'AGREE_DATE',
			xtype: 'uniTextfield',
			hidden: hiddenYN,
	 		allowBlank: allowBlankYN,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AGREE_DATE', newValue);
				}
			}
		},{
	 		fieldLabel: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>',
	 		xtype: 'uniDatefield',
	 		name: 'OUTSTOCK_REQ_DATE',
	 		value: UniDate.get('today'),
	 		allowBlank:false,
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('OUTSTOCK_REQ_DATE', newValue);
				}
			}
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
					Unilite.messageBox(labelText+Msg.sMB083);
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

	/* Model 정의
	 * @type
	 */
	Unilite.defineModel('pmp200ukrvMasterModel', {
	    fields: [
	    	{name: 'COMP_CODE'        	,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'			,type:'string'},
			{name: 'DIV_CODE'         	,text: '<t:message code="system.label.product.division" default="사업장"/>'			,type:'string'},
			{name: 'ITEM_CODE'        	,text: '<t:message code="system.label.product.item" default="품목"/>'			,type:'string'},
			{name: 'ITEM_NAME'         	,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type:'string'},
			{name: 'SPEC'             	,text: '<t:message code="system.label.product.spec" default="규격"/>'				,type:'string'},
			{name: 'STOCK_UNIT'       	,text: '<t:message code="system.label.product.unit" default="단위"/>'				,type:'string'},
			{name: 'PATH_CODE'        	,text: '<t:message code="system.label.product.pathinfo" default="PATH정보"/>'			,type:'string'},
			{name: 'OUTSTOCK_REQ_Q'   	,text: '<t:message code="system.label.product.issuerequestqty" default="출고요청량"/>'		,type:'uniQty'},
			{name: 'OUTSTOCK_Q'       	,text: '<t:message code="system.label.product.issueqty" default="출고량"/>'			,type:'uniQty'},
			{name: 'OUTSTOCK_REQ_DATE'	,text: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>'		,type:'uniDate'},
			{name: 'CONTROL_STATUS'   	,text: '<t:message code="system.label.product.processstatus" default="진행상태"/>'			,type:'string' , comboType :"AU" , comboCode : "P106"},
			{name: 'REF_WKORD_NUM'     	,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string'},
			{name: 'REMARK'           	,text: '<t:message code="system.label.product.remarks" default="비고"/>'				,type:'string'},
			{name: 'PROJECT_NO'       	,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
//			{name: 'PJT_CODE'         	,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
			{name: 'OUTSTOCK_NUM'       ,text: '<t:message code="system.label.product.issuerequestno" default="출고요청번호"/>'			,type:'string'},
			{name: 'OUTSTOCK_REQ_PRSN'	,text: '<t:message code="system.label.product.issuerequestcharge" default="출고요청담당"/>'			,type:'string'},
			{name: 'AGREE_STATUS'     	,text: '<t:message code="system.label.product.approvalstatus" default="승인상태"/>'			,type:'string'},
			{name: 'AGREE_PRSN'       	,text: '<t:message code="system.label.product.approvaluser" default="승인자"/>'			,type:'string'},
			{name: 'AGREE_DATE'       	,text: '<t:message code="system.label.product.approvaldate" default="승인일"/>'			,type:'uniDate'},
			{name: 'COUNT_WKORD_NUM'  	,text: '<t:message code="system.label.product.workorderyn" default="작지유무"/>'			,type:'string'},
			{name: 'UPDATE_DB_USER'   	,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'			,type:'string'},
			{name: 'UPDATE_DB_TIME'   	,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'			,type:'uniDate'}
		]
	});

	Unilite.defineModel('pmp200ukrvDetailModel', {
	    fields: [
	    	{name: 'WKORD_NUM'     	,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	,type:'string'},
			{name: 'ITEM_CODE'     	,text: '<t:message code="system.label.product.item" default="품목"/>'		,type:'string'},
			{name: 'ITEM_NAME'     	,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type:'string'},
			{name: 'SPEC'           ,text: '<t:message code="system.label.product.spec" default="규격"/>'			,type:'string'},
			{name: 'STOCK_UNIT'    	,text: '<t:message code="system.label.product.unit" default="단위"/>'			,type:'string'},
			{name: 'ALLOCK_Q'      	,text: '<t:message code="system.label.product.allocationqty" default="예약량"/>'		,type:'uniQty'},
			{name: 'OUTSTOCK_REQ_Q'	,text: '<t:message code="system.label.product.requesttotalqty" default="요청누계량"/>'		,type:'uniQty'},
			{name: 'WKORD_Q'       	,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		,type:'uniQty'},
			{name: 'PRODT_Q'       	,text: '<t:message code="system.label.product.productionresult" default="생산실적"/>'	,type:'uniQty'},
			{name: 'REMARK'        	,text: '<t:message code="system.label.product.remarks" default="비고"/>'			,type:'string'},
			{name: 'PROJECT_NO'    	,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type:'string'}
//			{name: 'PJT_CODE'       ,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'	,type:'string'}
		]
	});

    //조회시 출고요청정보 팝업창 모델 정의
	Unilite.defineModel('issueRequestNoMasterModel', {
	    fields: [{name: 'OUTSTOCK_NUM'				, text: '<t:message code="system.label.product.requestno" default="요청번호"/>'    			, type: 'string'},
				 {name: 'OUTSTOCK_REQ_DATE'			, text: '<t:message code="system.label.product.requestdate" default="요청일"/>'    			, type: 'uniDate'},
				 {name: 'REMARK'	       			, text: '<t:message code="system.label.product.remarks" default="비고"/>'    			, type: 'string'},
				 {name: 'PROJECT_NO'	   			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'    			, type: 'string'}
		]
	});

	/* Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('pmp200ukrvmasterStore', {
		model: 'pmp200ukrvMasterModel',
		autoLoad: false,
		uniOpt: {
			isMaster:	true,			// 상위 버튼 연결
			editable:	true,			// 수정 모드 사용
			deletable:	true,		// 삭제 가능 여부
			useNavi:	false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
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
       		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			paramMaster.WORK_SHOP_CODE = panelResult.getValue('WORK_SHOP_CODE');
			paramMaster.OUTSTOCK_REQ_DATE = UniDate.getDbDateStr(panelResult.getValue('OUTSTOCK_REQ_DATE'));


			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],

					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						panelSearch.setValue("OUTSTOCK_NUM", master.OUTSTOCK_NUM);
						panelResult.setValue("OUTSTOCK_NUM", master.OUTSTOCK_NUM);
						//3.기타 처리
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						if (masterStore.count() == 0) {
							UniAppManager.app.onResetButtonDown();
						}else{
							masterStore.loadStoreRecords();
							UniAppManager.setToolbarButtons(['print'], true);
						}
					}
				};
				this.syncAllDirect(config);
			} else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}/*,
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(Ext.isEmpty(panelSearch.getValue('REF_WKORD_NUM'))) {
           			if(query02Load == "1") {
		           		masterStore.loadStoreRecords();
						query02Load = "2";
           			}
           		} else {
           			query02Load = "1";
           			var param= panelSearch.getValues();
           			pmp200ukrvService.orderApply(param, function(provider, response) {
           				var store = masterGrid.getStore();
						var records = response.result;
						var refWkordNum = panelSearch.getValue('REF_WKORD_NUM');
						for(var i=0; i<records.length; i++) {
							records[i].WKORD_NUM_TEMP = refWkordNum;
						}
						store.insert(0, records);
           			});
           		}
           	}
		}*/
	});

	var detailStore = Unilite.createStore('pmp200ukrvdetailStore', {
		model: 'pmp200ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false	,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
        proxy: directProxy2,
		loadStoreRecords: function(record) {
			var param= Ext.getCmp('searchForm').getValues();
			param.REF_WKORD_NUM = record.get('REF_WKORD_NUM');
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

			var orderNum = panelSearch.getValue('ORDER_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['ORDER_NUM'] != orderNum) {
					record.set('ORDER_NUM', orderNum);
				}
			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정

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
								panelSearch.getForm().wasDirty = false;
								panelSearch.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);
							 }
					};
				//}
				//this.syncAll(config);
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('pmp200ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				// alert(Msg.sMB083);
			}
		}
	});

	//조회시 출고요청정보 팝업창 스토어 정의
	var issueRequestNoMasterStore = Unilite.createStore('issueRequestNoMasterStore', {
			model: 'issueRequestNoMasterModel',
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
                	read    : 'pmp200ukrvService.selectOrderNumMasterList'
                }
            }
            ,loadStoreRecords : function()	{
				var param= issueRequestNoSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});

	/* Grid 정의
	 * @type
	 */
    var masterGrid = Unilite.createGrid('pmp200ukrvGrid', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
			useContextMenu: true,
			onLoadSelectFirst : true
        },
        tbar: [{
			itemId: 'requestBtn',
			text: '<div style="color: blue"><t:message code="system.label.product.workorderrefer" default="작업지시참조"/></div>',
			handler: function() {
				if(panelSearch.getValue("OUTSTOCK_NUM") != "" /* && sFlagOutNum */ ){
					Unilite.messageBox('<t:message code="system.message.product.message054" default="출고요청정보가 등록된 자료는 작업지시 참조가 불가능합니다."/>');
					//출고요청정보가 등록된 자료는 작업지시 참조가 불가능합니다.
				}
				else if(panelSearch.setAllFieldsReadOnly(true) == false)   // 필수 값(작업장)을 체크
				{
        			return false;
				}
				else
				{
					openWorkOrderWindow();
					panelSearch.setAllFieldsReadOnly(false);
				}
			}
		}],
        store: masterStore,
    	columns: [
			{dataIndex: 'COMP_CODE'        		, width: 66 		, hidden:true},
			{dataIndex: 'DIV_CODE'         	 	, width: 66 		, hidden:true},
			{dataIndex: 'ITEM_CODE'				, width: 120		, editor:
				Unilite.popup('DIV_PUMOK_G', {
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
		            autoPopup: true,
					listeners: {'onSelected': {
									fn: function(records, type) {
											console.log('records : ', records);
											Ext.each(records, function(record,i) {
												console.log('record',record);
												if(i==0) {
													masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
												} else {
													UniAppManager.app.onNewDataButtonDown();
													masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
												}
											});
										},
									scope: this
								},
								'onClear': function(type) {
									masterGrid.setItemData(null,true,masterGrid.getSelectedRecord());
								}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'				, width: 166		, editor:
				Unilite.popup('DIV_PUMOK_G', {
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
		            autoPopup: true,
					listeners: {'onSelected': {
									fn: function(records, type) {
					                    console.log('records : ', records);
					                    Ext.each(records, function(record,i) {
						        			if(i==0) {
												masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
						        			} else {
						        				UniAppManager.app.onNewDataButtonDown();
						        				masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
						        			}
										});
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid.setItemData(null,true,masterGrid.getSelectedRecord());
								}
					}
				})
			},
			{dataIndex: 'SPEC'             		, width: 166},
			{dataIndex: 'STOCK_UNIT'       	 	, width: 66 , align:'center'},
			{dataIndex: 'PATH_CODE'        		, width: 73		, hidden:true},
			{dataIndex: 'OUTSTOCK_REQ_Q'   		, width: 100 },
			{dataIndex: 'OUTSTOCK_Q'       		, width: 100},
			{dataIndex: 'OUTSTOCK_REQ_DATE'	 	, width: 66		, hidden:true},
			{dataIndex: 'CONTROL_STATUS'   		, width: 73, align:'center'},
			{dataIndex: 'REF_WKORD_NUM'    		, width: 113},
			{dataIndex: 'REMARK'           		, width: 200},
			{dataIndex: 'PROJECT_NO'       	 	, width: 120},
//			{dataIndex: 'PJT_CODE'         		, width: 100},
			{dataIndex: 'OUTSTOCK_NUM'     		, width: 66		, hidden:true},
			{dataIndex: 'OUTSTOCK_REQ_PRSN'		, width: 66		, hidden:true},
			{dataIndex: 'AGREE_STATUS'     	 	, width: 66		, hidden:true},
			{dataIndex: 'AGREE_PRSN'       		, width: 66		, hidden:true},
			{dataIndex: 'AGREE_DATE'       		, width: 66		, hidden:true},
			{dataIndex: 'COUNT_WKORD_NUM'  	 	, width: 66		, hidden:true},
			{dataIndex: 'UPDATE_DB_USER'   		, width: 66		, hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'   		, width: 66		, hidden:true}
		],
		listeners: {
			selectionchange:function( model1, selected, eOpts ){
       			if(selected.length > 0)	{
	        		var record = selected[0];
	        		this.returnCell(record);
//	        		detailStore.loadData({})
					detailStore.loadStoreRecords(record);
       			}else{
					detailGrid.reset();
					detailStore.clearData();
       			}
          	},
			beforeedit  : function( editor, e, eOpts ){
				if(checkDraftStatus){
					return false;
				}else if(e.record.data.COUNT_WKORD_NUM == '0'){
					if(e.record.phantom){
						if(e.field=='ITEM_CODE') 		return true;
						if(e.field=='ITEM_NAME') 		return true;
					}else {
						if(e.field=='ITEM_CODE') 		return false;
						if(e.field=='ITEM_NAME') 		return false;
					}
				}
				if (UniUtils.indexOf(e.field,
									['OUTSTOCK_REQ_Q','REMARK','CONTROL_STATUS','PROJECT_NO']))
					return true;

				if (UniUtils.indexOf(e.field,
									['COMP_CODE','DIV_CODE','SPEC','STOCK_UNIT','PATH_CODE','OUTSTOCK_Q',
									 'OUTSTOCK_REQ_DATE','REF_WKORD_NUM','OUTSTOCK_NUM','OUTSTOCK_REQ_PRSN',
									 'AGREE_STATUS','AGREE_PRSN','AGREE_DATE','COUNT_WKORD_NUM','UPDATE_DB_USER','UPDATE_DB_TIME']))
					return false;
			}
       	},
       	returnCell: function(record) {
        	var divCode			= record.get("DIV_CODE");
        	var workShopCode	= panelResult.getValue("WORK_SHOP_CODE");
        	var itemCode 		= record.get("ITEM_CODE");
        	var pathCode 		= record.get("PATH_CODE");
            panelSearch.setValues({'DIV_CODE_TEMP':divCode});
            panelSearch.setValues({'WORK_SHOP_CODE_TEMP':workShopCode});
            panelSearch.setValues({'ITEM_CODE_TEMP':itemCode});
            panelSearch.setValues({'PATH_CODE_TEMP':pathCode});
        } ,
		disabledLinkButtons: function(b) {
		},
		setItemData: function(record, dataClear, grdRecord) {
       		if(dataClear && record == null) {
       			grdRecord.set('ITEM_CODE'		,"");
       			grdRecord.set('ITEM_NAME'		,"");
       			grdRecord.set('SPEC'			,"");
				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('STOCK_UNIT'		,"");
				grdRecord.set('OUTSTOCK_REQ_Q'  ,"");
				grdRecord.set('CONTROL_STATUS'  ,"");

		    } else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('ORDER_UNIT'			, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('OUTSTOCK_REQ_Q'		, "");
				grdRecord.set('CONTROL_STATUS'		, 2);
       		}
		},
		setEstiData:function(record) {
       		var grdRecord = masterGrid.uniOpt.currentRecord;

       		grdRecord.set('COMP_CODE'			, panelSearch.getValue('COMP_CODE'));
			grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('PATH_CODE'			, record['PATH_CODE']);
			grdRecord.set('OUTSTOCK_REQ_Q'		, record['OUTSTOCK_REQ_Q']);
			grdRecord.set('OUTSTOCK_Q'			, record['OUTSTOCK_Q']);
			grdRecord.set('OUTSTOCK_REQ_DATE'	, record['OUTSTOCK_REQ_DATE']);
			grdRecord.set('CONTROL_STATUS'		, "2" );
			grdRecord.set('REF_WKORD_NUM'		, record['REF_WKORD_NUM']);
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('OUTSTOCK_NUM'		, record['OUTSTOCK_NUM']);
			grdRecord.set('OUTSTOCK_REQ_PRSN'	, record['OUTSTOCK_REQ_PRSN']);
			grdRecord.set('AGREE_STATUS'		, record['AGREE_STATUS']);
			grdRecord.set('AGREE_PRSN'			, record['AGREE_PRSN']);
			grdRecord.set('AGREE_DATE'			, record['AGREE_DATE']);
			grdRecord.set('COUNT_WKORD_NUM'		, record['COUNT_WKORD_NUM']);
		}
    });

    var detailGrid = Unilite.createGrid('pmp200ukrvGrid2', {
    	layout: 'fit',
        region:'south',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
    	store: detailStore,
        columns: [
			{dataIndex: 'WKORD_NUM'      	, width: 120},
			{dataIndex: 'ITEM_CODE'      	, width: 120},
			{dataIndex: 'ITEM_NAME'       	, width: 200},
			{dataIndex: 'SPEC'           	, width: 166},
			{dataIndex: 'STOCK_UNIT'     	, width: 73, align:'center'},
			{dataIndex: 'ALLOCK_Q'       	, width: 100},
			{dataIndex: 'OUTSTOCK_REQ_Q' 	, width: 100 , hidden: true},
			{dataIndex: 'WKORD_Q'        	, width: 100},
			{dataIndex: 'PRODT_Q'         	, width: 100},
			{dataIndex: 'REMARK'         	, width: 120},
			{dataIndex: 'PROJECT_NO'     	, width: 100}
//			{dataIndex: 'PJT_CODE'       	, width: 100}
		],
		listeners: {

       	},
		disabledLinkButtons: function(b) {
       		this.down('#procTool').menu.down('#temporarySaveBtn').setDisabled(b);
       		this.down('#procTool').menu.down('#selectAllBtn').setDisabled(b);
		}
    });

	//조회시 출고요청정보 팝업창 그리드 정의
    var issueRequestNoMasterGrid = Unilite.createGrid('pmp200ukrvissueRequestNoMasterGrid', {
        // title: '기본',
        layout : 'fit',
		store: issueRequestNoMasterStore,
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false
		},
        columns:  [{ dataIndex: 'OUTSTOCK_NUM'				,	 width:133 },
          		   { dataIndex: 'OUTSTOCK_REQ_DATE'			,	 width:80 },
          		   { dataIndex: 'REMARK'	       			,	 width:166 },
          		   { dataIndex: 'PROJECT_NO'	   			,	 width:166 }
          ],
          listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				issueRequestNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				searchInfoWindow.hide();
			}
          }, // listeners
          returnData: function(record)	{ /////
          	if(Ext.isEmpty(record))	{
          		record = this.getSelectedRecord();
          	}
          	panelSearch.setValues({'OUTSTOCK_NUM':record.get('OUTSTOCK_NUM'),'OUTSTOCK_REQ_DATE':record.get('OUTSTOCK_REQ_DATE')});
          }
    });


    //조회시 출고요청정보 팝업창 폼 정의
  	var issueRequestNoSearch = Unilite.createSearchForm('issueRequestNoSearchForm', {
		layout: {type: 'uniTable', columns : 2},
	    trackResetOnLoad: true,
	    items: [{
			fieldLabel: '<t:message code="system.label.product.requestdate" default="요청일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'OUTSTOCK_REQ_DATE_FR',
			endFieldName: 'OUTSTOCK_REQ_DATE_TO',
			width: 350,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
		    labelWidth: 100
		},
		{
			fieldLabel: '요청번호',
			xtype: 'uniTextfield',
			name:'OUTSTOCK_NUM',
			width:315,
		    labelWidth: 100
		},{
			fieldLabel: '<t:message code="system.label.product.remarks" default="비고"/>',
			xtype: 'uniTextfield',
			name:'REMARK',
			width:315,
		    labelWidth: 100
		},{
			fieldLabel: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>',
			xtype: 'uniTextfield',
			name:'PROJECT_NO',
			width:315,
		    labelWidth: 100
		},{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			xtype: 'uniTextfield',
			name:'DIV_CODE',
			hidden:true
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			xtype: 'uniTextfield',
			name:'WORK_SHOP_CODE',
			hidden:true
		}]
    }); // createSearchForm


	//조회창 메인
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.product.issuerequestinfo" default="출고요청정보"/>',
               width: 830,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [issueRequestNoSearch, issueRequestNoMasterGrid],
                tbar:  ['->',
				        {	itemId : 'searchBtn',
							text: '<t:message code="system.label.product.inquiry" default="조회"/>',
							handler: function() {
								issueRequestNoMasterStore.loadStoreRecords();
							},
							disabled: false
						}, {
							itemId : 'closeBtn',
							text: '<t:message code="system.label.product.close" default="닫기"/>',
							handler: function() {
								searchInfoWindow.hide();
							},
							disabled: false
						}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						issueRequestNoSearch.clearForm();
						issueRequestNoMasterGrid.reset();
                	},
        			 beforeclose: function( panel, eOpts )	{
						issueRequestNoSearch.clearForm();
						issueRequestNoMasterGrid.reset();
		 			},
        			 show: function( panel, eOpts )	{
			    		issueRequestNoSearch.setValue('OUTSTOCK_REQ_DATE_FR',UniDate.get('startOfMonth'));
			    		issueRequestNoSearch.setValue('OUTSTOCK_REQ_DATE_TO',UniDate.get('today'));
			    		issueRequestNoSearch.setValue('REMARK',panelSearch.getValue('REMARK'));
			    		issueRequestNoSearch.setValue('PROJECT_NO',panelSearch.getValue('PROJECT_NO'));
			    		issueRequestNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
			    		issueRequestNoSearch.setValue('WORK_SHOP_CODE',panelSearch.getValue('WORK_SHOP_CODE'));
        			 }
                }
			})
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
    }

    //작업지시 참조 폼 정의
    var WorkSearch = Unilite.createSearchForm('WorkForm', {
    	layout :  {type : 'uniTable', columns : 2},
            items :[{
		        fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		        name:'DIV_CODE',
		        xtype: 'uniCombobox',
		        comboType:'BOR120' ,
		        allowBlank:false,
		        //value:UserInfo.divCode,
		        hidden: true
		    },{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
		 		allowBlank:false,
		 		hidden: true
			},
            	Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					textFieldWidth:170,
					validateBlank:false,
					textFieldName: 'ITEM_NAME',
					valueFieldName: 'ITEM_CODE'
			}),{
				fieldLabel: '<t:message code="system.label.product.applyys" default="적용여부"/>',
				name:'APPLY_FLAG',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'P102'
			},{
            	fieldLabel: '<t:message code="system.label.product.productionrequestdate" default="생산요청일"/>',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'PRODT_START_DATE_FR',
			    endFieldName: 'PRODT_START_DATE_TO',
			    width: 350,
			    startDate: UniDate.get('startOfMonth'),
			    endDate: UniDate.get('today')
	       }]
    });

    // 작업지시 참조 모델 정의
    Unilite.defineModel('pmp200ukrvWorkModel', {
    	fields: [
	    	{name: 'GUBUN'             	, text: '<t:message code="system.label.product.selection" default="선택"/>'			, type: 'string'},
	    	{name: 'COMP_CODE'         	, text: '<t:message code="system.label.product.compcode" default="법인코드"/>' 			, type: 'string'},
		    {name: 'DIV_CODE'          	, text: '<t:message code="system.label.product.division" default="사업장"/>'			, type: 'string'},
		    {name: 'WORK_SHOP_CODE'    	, text: '<t:message code="system.label.product.workcenter" default="작업장"/>' 			, type: 'string'},
		    {name: 'PROG_WORK_CODE'    	, text: '<t:message code="system.label.product.routingcode" default="공정코드"/>' 			, type: 'string'},
		    {name: 'ITEM_CODE'         	, text: '<t:message code="system.label.product.item" default="품목"/>'			, type: 'string'},
		    {name: 'ITEM_NAME'         	, text: '<t:message code="system.label.product.itemname" default="품목명"/>' 			, type: 'string'},
		    {name: 'SPEC'              	, text: '<t:message code="system.label.product.spec" default="규격"/>' 			, type: 'string'},
		    {name: 'STOCK_UNIT'        	, text: '<t:message code="system.label.product.unit" default="단위"/>'			, type: 'string'},
	    	{name: 'WKORD_Q'           	, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>' 		, type: 'uniQty'},
		    {name: 'PRODT_START_DATE'  	, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'			, type: 'uniDate'},
		    {name: 'PRODT_END_DATE'    	, text: '<t:message code="system.label.product.workenddate" default="작업완료일"/>' 		, type: 'uniDate'},
		    {name: 'WKORD_NUM'         	, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>' 		, type: 'string'},
		    {name: 'TOP_WKORD_NUM'      , text: 'TOP<t:message code="system.label.product.workorderno" default="작업지시번호"/>' 		, type: 'string'},
		    {name: 'LOT_NO'		    	, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'		, type: 'string'},
		    {name: 'SFLAG'             	, text: '<t:message code="system.label.product.applyys" default="적용여부"/>'			, type: 'string'},
		    {name: 'REMARK'            	, text: '<t:message code="system.label.product.remarks" default="비고"/>' 			, type: 'string'},
		    {name: 'PROJECT_NO'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>' 			, type: 'string'}
//		    {name: 'PJT_CODE'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'}
		]
	});

    //작업지시 참조 스토어 정의
	var WorkStore = Unilite.createStore('pmp200ukrvWorkStore', {
		model: 'pmp200ukrvWorkModel',
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
            	read    : 'pmp200ukrvService.selectEstiList'
            }
        },
        listeners:{
        	load:function(store, records, successful, eOpts)	{
    			if(successful)	{
    			   var masterRecords = masterStore.data.filterBy(masterStore.filterNewOnly);
    			   var estiRecords = new Array();
    			   if(masterRecords.items.length > 0)	{
//    			   	console.log("store.items :", store.items);
//    			   	console.log("records", records);
						Ext.each(records,
				   			function(item, i)	{
								Ext.each(masterRecords.items, function(record, i)	{
//									console.log("record :", record);
									if((record.data['REF_WKORD_NUM'] == item.data['WKORD_NUM'])){
										estiRecords.push(item);
									}
								});
			   				}
						);
					store.remove(estiRecords);
    			   }
    			}
        	}
        },
        loadStoreRecords : function()	{
			var param= WorkSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	// 작업지시 그리드
	var WorkGrid = Unilite.createGrid('pmp200ukrvWorkGrid', {
    	layout : 'fit',
    	store: WorkStore,
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
			uniOpt:{
	        	onLoadSelectFirst : false
	        },
		itemId: 'grid01',
        columns: [
        	{ dataIndex: 'GUBUN'             	   		, width: 40 , hidden: true},
        	{ dataIndex: 'COMP_CODE'         	   		, width: 66 , hidden: true},
        	{ dataIndex: 'DIV_CODE'          	   		, width: 66 , hidden: true},
        	{ dataIndex: 'WORK_SHOP_CODE'    	   		, width: 66 , hidden: true},
        	{ dataIndex: 'PROG_WORK_CODE'    	   		, width: 66 , hidden: true},
        	{ dataIndex: 'ITEM_CODE'         	   		, width: 100},
        	{ dataIndex: 'ITEM_NAME'         	   		, width: 140},
        	{ dataIndex: 'SPEC'              	   		, width: 100},
        	{ dataIndex: 'STOCK_UNIT'        	   		, width: 53},
        	{ dataIndex: 'WKORD_Q'           	   		, width: 100},
        	{ dataIndex: 'PRODT_START_DATE'  	   		, width: 80},
        	{ dataIndex: 'PRODT_END_DATE'    	   		, width: 80},
        	{ dataIndex: 'WKORD_NUM'         	   		, width: 120},
        	{ dataIndex: 'TOP_WKORD_NUM'         	   	, width: 130},
        	{ dataIndex: 'LOT_NO'		    	   		, width: 100},
        	{ dataIndex: 'SFLAG'             	   		, width: 66},
        	{ dataIndex: 'REMARK'            	   		, width: 133},
        	{ dataIndex: 'PROJECT_NO'			   		, width: 100}
//        	{ dataIndex: 'PJT_CODE'			   			, width: 100}
		],
		listeners: {
      		onGridDblClick:function(grid, record, cellIndex, colName) {
			}
   		},
   		returnData: function()	{
       		var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
	        	UniAppManager.app.onNewDataButtonDown();
	        	masterGrid.setEstiData(record.data);
		    });
			this.getStore().remove(records);
       	}
    });

    //작업지시 참조 메인
    function openWorkOrderWindow() {
  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		WorkSearch.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
  		WorkSearch.setValue('WORK_SHOP_CODE', panelSearch.getValue('WORK_SHOP_CODE'));
  		WorkSearch.setValue('PRODT_START_DATE_FR', panelSearch.getValue('OUTSTOCK_REQ_DATE'));
  		WorkSearch.setValue('PRODT_START_DATE_TO', panelSearch.getValue('OUTSTOCK_REQ_DATE'));

		if(!referWorkOrderWindow) {
			referWorkOrderWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.product.workorderrefer" default="작업지시참조"/>',
                width: 830,
                height: 580,
                layout:{type:'vbox', align:'stretch'},

                items: [WorkSearch, WorkGrid],
                tbar:  ['->',
			        {	itemId : 'saveBtn',
						text: '<t:message code="system.label.product.inquiry" default="조회"/>',
						handler: function() {
							WorkStore.loadStoreRecords();
						},
						disabled: false
					},
					{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.product.requestapply" default="요청적용"/>',
						handler: function() {

//							WorkGrid.returnData();


							var records = WorkGrid.getSelectedRecords();
							if(Ext.isEmpty(records)){
								return false;
							}
							var refWkordNumArr = [];

							Ext.each(records,function(record, i){
								refWkordNumArr.push(record.get('WKORD_NUM'));

							});


//							panelSearch.setValue('REF_WKORD_NUM', record[0].get('WKORD_NUM'));
							var param= {
								'DIV_CODE': panelSearch.getValue('DIV_CODE'),
								'REF_WKORD_NUM': refWkordNumArr,
								'WORK_SHOP_CODE': panelSearch.getValue('WORK_SHOP_CODE')
							}
							pmp200ukrvService.orderApply(param, function(provider, response){
						    	var store = masterGrid.getStore();
						    	var records = response.result;
						    	store.insert(0, records);
								//grid.getStore().removeAll();
						    });
							WorkGrid.deleteSelectedRow();



						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.product.requestapplyclose" default="요청적용후 닫기"/>',
						handler: function() {

//							WorkGrid.returnData();


							var records = WorkGrid.getSelectedRecords();
							if(Ext.isEmpty(records)){
								return false;
							}
							var refWkordNumArr = [];

							Ext.each(records,function(record, i){
								refWkordNumArr.push(record.get('WKORD_NUM'));
							});


		//							panelSearch.setValue('REF_WKORD_NUM', record[0].get('WKORD_NUM'));
							var param= {
								'DIV_CODE': panelSearch.getValue('DIV_CODE'),
								'REF_WKORD_NUM': refWkordNumArr,
								'WORK_SHOP_CODE': panelSearch.getValue('WORK_SHOP_CODE')
							}
							pmp200ukrvService.orderApply(param, function(provider, response){
						    	var store = masterGrid.getStore();
						    	var records = response.result;
						    	store.insert(0, records);
								//grid.getStore().removeAll();
						    });
							WorkGrid.deleteSelectedRow();

							referWorkOrderWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							referWorkOrderWindow.hide();
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{
					//requestSearch.clearForm();
					//requestGrid,reset();
					},
					beforeclose: function( panel, eOpts )	{
									//requestSearch.clearForm();
					//requestGrid,reset();
					},
					beforeshow: function ( me, eOpts )	{
						WorkStore.loadStoreRecords();
					}
				}
			})
		}
		referWorkOrderWindow.center();
		referWorkOrderWindow.show();
    }

    Unilite.Main({
		id: 'pmp200ukrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				 masterGrid, panelResult, detailGrid
			]},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.getField('WORK_SHOP_CODE').focus();
			UniAppManager.setToolbarButtons(['reset','newData','delete','deleteAll'], true);
			UniAppManager.setToolbarButtons(['print'], false);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			var orderNo = panelSearch.getValue('OUTSTOCK_NUM');
			var refWkordNum = panelSearch.getValue('REF_WKORD_NUM');
			if(Ext.isEmpty(orderNo) && Ext.isEmpty(refWkordNum)) {
				if(panelSearch.setAllFieldsReadOnly(true) == false)   // 필수값을 체크
				{
            		return false;
				}
				openSearchInfoWindow();
				issueRequestNoMasterStore.loadStoreRecords();
			} else {
				masterStore.loadStoreRecords();
				panelSearch.setAllFieldsReadOnly(false);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;


				/**
				 * Detail Grid Default 값 설정
				 */
		/*		 var outstocknum = panelSearch.getValue('OUTSTOCK_NUM')
				 var seq = masterStore.max('ITEM_CODE');
				 	if(!seq) seq = 1;
            	 	else  seq += 1;
            	 var divCode = panelSearch.getValue('DIV_CODE');
            	 var pathCode = '0';
            	 var outstockNum = panelSearch.getValue('OUTSTOCK_NUM');
            	 var outsotockReqDate = panelSearch.getValue('OUTSTOCK_NUM');
            	 var outstockQ = '0';
            	 var countWkordNum = '0';
            	 var controlStatus = '2';
            	 var outstockReqPrsn = panelSearch.getValue('OUTSTOCK_REQ_PRSN');
            	 var agreeStatus = panelSearch.getValue('AGREE_STATUS');
            	 var agreePrsn = panelSearch.getValue('AGREE_PRSN');

            	 var r = {
				 	 		OUTSTOCK_NUM : outstocknum,
				 	 		ITEM_CODE: seq,
				 	 		//COMP_CODE: compCode
							DIV_CODE: divCode ,
							PATH_CODE: pathCode     ,
							OUTSTOCK_NUM: outstockNum ,
							OUTSTOCK_REQ_DATE: outsotockReqDate,
							OUTSTOCK_Q: outstockQ  ,
							COUNT_WKORD_NUM: countWkordNum,
							CONTROL_STATUS: controlStatus,
							OUTSTOCK_REQ_PRSN: outstockReqPrsn,
							AGREE_STATUS: agreeStatus  ,
							AGREE_PRSN: agreePrsn
						 };
				masterGrid.createRow(r, 'ITEM_CODE');*/

			var compCode = UserInfo.compCode;
			var divCode = panelResult.getValue('DIV_CODE');
			var outstockReqDate = panelResult.getValue('OUTSTOCK_REQ_DATE');
			var controlStatus = '2';
			var outstockNum = panelResult.getValue('OUTSTOCK_NUM');

		var r = {
			COMP_CODE         : compCode, 			//'<t:message code="system.label.product.compcode" default="법인코드"/>'
			DIV_CODE          : divCode, 			//'<t:message code="system.label.product.division" default="사업장"/>'
			//ITEM_CODE         : itemCode, 			//'<t:message code="system.label.product.item" default="품목"/>'
			//ITEM_NAME         : itemName, 			//'<t:message code="system.label.product.itemname" default="품목명"/>'
			//SPEC              : spec, 				//'<t:message code="system.label.product.spec" default="규격"/>'
			//STOCK_UNIT        : stockUnit,				//'<t:message code="system.label.product.unit" default="단위"/>'
			//PATH_CODE         : pathCode, 			//'<t:message code="system.label.product.pathinfo" default="PATH정보"/>'
			//OUTSTOCK_REQ_Q    : outstockReqQ, 		//'<t:message code="system.label.product.issuerequestqty" default="출고요청량"/>'
			//OUTSTOCK_Q        : outstockQ, 			//'<t:message code="system.label.product.issueqty" default="출고량"/>'
			OUTSTOCK_REQ_DATE : outstockReqDate, 	//'<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>'
			CONTROL_STATUS    : controlStatus, 		//'<t:message code="system.label.product.processstatus" default="진행상태"/>'
			//REF_WKORD_NUM     : refWkordNum, 		//'<t:message code="system.label.product.workorderno" default="작업지시번호"/>'
			//REMARK            : remark, 			//'<t:message code="system.label.product.remarks" default="비고"/>'
			//PROJECT_NO        : projectNo, 			//'<t:message code="system.label.product.projectno" default="프로젝트번호"/>'
			//PJT_CODE          : pjtCode, 			//'<t:message code="system.label.product.projectno" default="프로젝트번호"/>'
			OUTSTOCK_NUM      : outstockNum 		//출고요청번호'
			//OUTSTOCK_REQ_PRSN : outstockReqPrsn, 	//'<t:message code="system.label.product.issuerequestcharge" default="출고요청담당"/>'
			//AGREE_STATUS      : agreeStatus, 		//'<t:message code="system.label.product.approvalstatus" default="승인상태"/>'
			//AGREE_PRSN        : agreePrsn, 			//'<t:message code="system.label.product.approvaluser" default="승인자"/>'
			//AGREE_DATE        : agreeDate, 			//'<t:message code="system.label.product.approvaldate" default="승인일"/>'
			//COUNT_WKORD_NUM   : countWkordNum 		//'<t:message code="system.label.product.workorderyn" default="작지유무"/>'
		}


			masterGrid.createRow(r);
			panelSearch.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterStore.clearData();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitBinding();

			panelSearch.getField('DIV_CODE').setReadOnly( false );
			panelSearch.getField('WORK_SHOP_CODE').setReadOnly( false );
		},
		onSaveDataButtonDown: function(config) {
			masterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)){

				if(selRow.phantom === true)	{
					masterGrid.deleteSelectedRow();
				}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
	//				if(selRow.get('INSPEC_Q') > 1)
	//				{

	//				}else{
						masterGrid.deleteSelectedRow();
	//				}
				}
			}
			// fnOrderAmtSum 호출(grid summary 이용)
		},
		onDeleteAllButtonDown: function() {
			var records = masterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('<t:message code="system.message.product.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						masterGrid.reset();
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
			}
			masterStore.saveStore();
			masterGrid.reset();
		},
		
		onPrintButtonDown: function() {
			
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            
            if(Ext.isEmpty(panelResult.getValue('OUTSTOCK_NUM'))){
            	Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
            	return;
            }
            var win;
			var param = panelResult.getValues();
			var reportGubun = BsaCodeInfo.gsReportGubun;
			param["USER_LANG"] = UserInfo.userLang;
			param["sTxtValue2_fileTitle"]='출고요청서';
			param["PGM_ID"]= PGM_ID;
			param["MAIN_CODE"] = 'P010';  //생산용 공통 코드
			param["OUTSTOCK_NUM"] = panelResult.getValue('OUTSTOCK_NUM');
			if(Ext.isEmpty(reportGubun) || reportGubun == 'CR'){
				win = Ext.create('widget.CrystalReport', {
	                url: CPATH+'/prodt/pmp200crkrv.do',
	                extParam: param
	            });
			}else{
				win = Ext.create('widget.ClipReport', {
	                url: CPATH+'/prodt/pmp200clukrv.do',
	                prgID: 'pmp200ukrv',
	                extParam: param
	            });
			}
			
			
			win.center();
			win.show();
		
			
		},
		
		
		checkForNewDetail:function() {
			if(Ext.isEmpty(panelSearch.getValue('WORK_SHOP_CODE')))	{
				Unilite.messageBox('<t:message code="system.label.product.workcenter" default="작업장"/>:<t:message code="system.message.product.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onDetailButtonDown: function() {
			var as = Ext.getCmp('pmp200ukrvAdvanceSerch');
			if(as.isHidden())	{
				as.show();
			} else {
				as.hide()
			}
		},
		rejectSave: function() {
			var rowIndex = masterGrid.getSelectedRowIndex();
			masterGrid.select(rowIndex);
			masterStore.rejectChanges();

			if(rowIndex >= 0){
				masterGrid.getSelectionModel().select(rowIndex);
				var selected = masterGrid.getSelectedRecord();

				var selected_doc_no = selected.data['DOC_NO'];
  				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {
					}
				);
			}
			masterStore.onStoreActionEnable();
		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('pmp200ukrvFileUploadPanel');
        	if(masterStore.isDirty() || fp.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.setValue('OUTSTOCK_REQ_DATE',new Date());
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('OUTSTOCK_REQ_DATE',new Date());
			panelSearch.getForm().wasDirty = false;
			panelResult.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		},
        fnCheckNum: function(value, record, fieldName) {
        	var r = true;
        	if(record.get("PRICE_YN") == "1" || record.get("ACCOUNT_YNC")=="N")	{
        		r = true;
        	} else if(record.get("PRICE_YN") == "2" )	{
        		if(value < 0)	{
        			Unilite.messageBox(Msg.sMB076);
        			r=false;
        			return r;
        		}else if(value == 0)	{
        			if(fieldName == "ORDER_TAX_O")	{
        				if(BsaCodeInfo.gsVatRate != 0)	{
    						Unilite.messageBox(Msg.sMB083);
    						r=false;
        				}
        			}else {
        				Unilite.messageBox(Msg.sMB083);
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
		store: masterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ITEM_CODE" :
					var itemCode = record.get('ITEM_CODE');
					if(itemCode != "")	{
						Ext.getBody().mask();
						var param = {'DIV_CODE':newValue, 'ITEM_CODE':itemCode, 'S_COMP_CODE':UserInfo.compCode, 'USELIKE':false, 'TYPE':'VALUE'};
						popupService.divPumokPopup(param, function(provider, response)	{
															if(Ext.isEmpty(provider))	{
																Unilite.messageBox(Msg.sMS288);
																Ext.getBody().unmask();
															} else {
																console.log("provider",provider)
																if(!Ext.isEmpty('provider')) masterGrid.setItemData(provider[0],false);
																else masterGrid.setItemData(null, true);
															}
														});
						outDivCode=newValue;

						break;
					}
					if(Ext.isEmpty(newValue))  newValue = record.get("DIV_CODE");

					break;

				case "ITEM_NAME" :
					var itemName = record.get('ITEM_NAME');
					if(itemName != "")	{
						Ext.getBody().mask();
						var param = {'DIV_CODE':newValue, 'ITEM_NAME':itemName, 'S_COMP_CODE':UserInfo.compCode, 'USELIKE':false, 'TYPE':'VALUE'};
						popupService.divPumokPopup(param, function(provider, response)	{
															if(Ext.isEmpty(provider))	{
																Unilite.messageBox(Msg.sMS288);
																Ext.getBody().unmask();
															} else {
																console.log("provider",provider)
																if(!Ext.isEmpty('provider')) masterGrid.setItemData(provider[0],false);
																else masterGrid.setItemData(null, true);

															}
														});
						outDivCode=newValue;

						break;
					}
					if(Ext.isEmpty(newValue))  newValue = record.get("DIV_CODE");
					
					break;
			/*
				case "CONTROL_STATUS" : //진행상태

				case "OUTSTOCK_REQ_Q" ://출고요청량

					if(newValue < 1 ){

					

						break;
					}*/
			}
			return rv;
		}
	}); // validator
}
</script>