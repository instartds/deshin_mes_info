<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp200ukrv_kd"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList"/> 	<!-- 작업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P102"/> 				<!-- 적용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"/> 				<!-- 예약마감여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B083"/> 				<!-- BOM PATH 정보 -->
	<t:ExtComboStore comboType="AU" comboCode="P117"/> 				<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="P118"/> 				<!-- 출고요청 승인방식 -->
	<t:ExtComboStore comboType="AU" comboCode="P119"/> 				<!-- 출고요청담당 -->
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
	gsAgreePrsn:		'${gsAgreePrsn}',					//승인자ID 가져오기 (P119)
	gsShowBtnReserveYN: '${gsShowBtnReserveYN}',            //BOM PATH 관리여부
    gsUsePabStockYn:   '${gsUsePabStockYn}'				   //가용재고 사용여부
};

/* BsaCodeInfo 데이터 확인
var output ='';  // 입고내역 셋팅 값 확인 alert
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/

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

var usePabStockYn = true; //가용재고 컬럼 사용여부
if(BsaCodeInfo.gsUsePabStockYn =='Y') {
    usePabStockYn = false;
}
var query02Load = "1";


function appMain() {
	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read:		's_pmp200ukrv_kdService.selectMaster',
			update:		's_pmp200ukrv_kdService.updateDetail',
			create:		's_pmp200ukrv_kdService.insertDetail',
			destroy:	's_pmp200ukrv_kdService.deleteDetail',
			syncAll:	's_pmp200ukrv_kdService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read:		's_pmp200ukrv_kdService.orderApply2'
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
	    dirtychange: function(basicForm, dirty, eOpts) {
				console.log("onDirtyChange");
//				UniAppManager.setToolbarButtons('save', true);
		},
		items: [{
			title: '기본정보',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		        fieldLabel: '사업장',
		        name:'DIV_CODE',
		        xtype: 'uniCombobox',
		        comboType:'BOR120' ,
		        allowBlank:false,
		        value:UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
		    },{
				fieldLabel: '작업장',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('wsList'),
		 		allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			},{
		    	fieldLabel: '출고요청번호',
			 	xtype: 'uniTextfield',
			 	name: 'OUTSTOCK_NUM',
			 	readOnly: true,
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('OUTSTOCK_NUM', newValue);
					}
				}
			},{
				fieldLabel: '출고요청담당',
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
				fieldLabel: '승인여부',
				name: 'AGREE_STATUS',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'P117',
		 		allowBlank:false,
				hidden: hiddenYN,
				value: BsaCodeInfo.gsAutoAgree,
		 		allowBlank: allowBlankYN,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AGREE_STATUS', newValue);
					}
				}
			},{
				fieldLabel: '승인자',
				name: 'AGREE_PRSN',
				xtype: 'uniTextfield',
		 		allowBlank:false,
				hidden: hiddenYN,
				value: BsaCodeInfo.gsAgreePrsn,
		 		allowBlank: allowBlankYN,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AGREE_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '승인일',
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
		 		fieldLabel: '출고요청일',
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
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
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

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
            fieldLabel: '기안여부TEMP',
            name:'GW_TEMP',
            xtype: 'uniTextfield',
            hidden: true
        },{
	        fieldLabel: '사업장',
	        name:'DIV_CODE',
	        xtype: 'uniCombobox',
	        comboType:'BOR120' ,
	        allowBlank:false,
	        value:UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
	    },{
			fieldLabel: '작업장',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('wsList'),
	 		allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				}
			}
		},{
	    	fieldLabel: '출고요청번호',
		 	xtype: 'uniTextfield',
		 	name: 'OUTSTOCK_NUM',
		 	readOnly: true,
		 	listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('OUTSTOCK_NUM', newValue);
				}
			}
		},{
			fieldLabel: '출고요청담당',
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
			fieldLabel: '승인여부',
			name: 'AGREE_STATUS',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'P117',
	 		allowBlank:false,
			hidden: hiddenYN,
	 		allowBlank: allowBlankYN,
            value: BsaCodeInfo.gsAutoAgree,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AGREE_STATUS', newValue);
				}
			}
		},{
			fieldLabel: '승인자',
			name: 'AGREE_PRSN',
			xtype: 'uniTextfield',
	 		allowBlank:false,
			hidden: hiddenYN,
	 		allowBlank: allowBlankYN,
            value: BsaCodeInfo.gsAgreePrsn,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AGREE_PRSN', newValue);
				}
			}
		},{
			fieldLabel: '승인일',
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
	 		fieldLabel: '출고요청일',
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
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
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

	/* Model 정의
	 * @type
	 */
	Unilite.defineModel('s_pmp200ukrv_kdMasterModel', {
	    fields: [
	    	{name: 'COMP_CODE'        	,text: '법인코드'			,type:'string'},
			{name: 'DIV_CODE'         	,text: '사업장'			    ,type:'string'},
			{name: 'ITEM_CODE'        	,text: '품목코드'			,type:'string', allowBlank: false},
			{name: 'ITEM_NAME'         	,text: '품명'				,type:'string'},
			{name: 'SPEC'             	,text: '규격'				,type:'string'},
			{name: 'STOCK_UNIT'       	,text: '단위'				,type:'string'},
			{name: 'PATH_CODE'        	,text: 'PATH정보'			,type:'string'},
			{name: 'OUTSTOCK_REQ_Q'   	,text: '출고요청량'			,type:'uniQty', allowBlank: false},
			{name: 'OUTSTOCK_Q'       	,text: '출고량'			    ,type:'uniQty'},
			{name: 'PAB_STOCK_Q'        ,text: '가용재고'         , type: 'uniQty', editable: false},
			{name: 'OUTSTOCK_REQ_DATE'	,text: '출고요청일'			,type:'uniDate'},
			{name: 'CONTROL_STATUS'   	,text: '진행상태'			,type:'string' , comboType :"AU" , comboCode : "P001", allowBlank: false},
			{name: 'REF_WKORD_NUM'     	,text: '작업지시번호'		,type:'string'},
//            {name: 'WKORD_NUM'          ,text: '작업지시번호'       ,type:'string'},
			{name: 'REMARK'           	,text: '비고'				,type:'string'},
			{name: 'PROJECT_NO'       	,text: '프로젝트번호'		,type:'string'},
//			{name: 'PJT_CODE'         	,text: '프로젝트번호'		,type:'string'},
			{name: 'OUTSTOCK_NUM'       ,text: '출고요청번호'		,type:'string'},
			{name: 'OUTSTOCK_REQ_PRSN'	,text: '출고요청담당'		,type:'string'},
			{name: 'AGREE_STATUS'     	,text: '승인상태'			,type:'string'},
			{name: 'AGREE_PRSN'       	,text: '승인자'			    ,type:'string'},
			{name: 'AGREE_DATE'       	,text: '승인일'			    ,type:'uniDate'},
			{name: 'COUNT_WKORD_NUM'  	,text: '작지유무'			,type:'string'},
            {name: 'WORK_SHOP_CODE'     ,text: '작업장'             ,type:'string'},
			{name: 'UPDATE_DB_USER'   	,text: '수정자'			    ,type:'string'},
			{name: 'UPDATE_DB_TIME'   	,text: '수정일'			    ,type:'uniDate'},
            {name: 'GW_FLAG'            ,text: '기안여부'           ,type: 'string'},
            {name: 'GW_DOC'             ,text: '기안문서'           ,type: 'string'},
            {name: 'DRAFT_NO'           ,text: '기안번호'           ,type: 'string'}
		]
	});

	Unilite.defineModel('s_pmp200ukrv_kdDetailModel', {
	    fields: [
	    	{name: 'WKORD_NUM'     	,text: '작업지시번호'	,type:'string'},
			{name: 'ITEM_CODE'     	,text: '품목코드'		,type:'string'},
			{name: 'ITEM_NAME'     	,text: '품명'			,type:'string'},
			{name: 'SPEC'           ,text: '규격'			,type:'string'},
			{name: 'STOCK_UNIT'    	,text: '단위'			,type:'string'},
			{name: 'LOT_NO'         ,text: 'LOT NO'     ,type:'string'},
			{name: 'ALLOCK_Q'      	,text: '예약량'		    ,type:'uniQty'},
			{name: 'OUTSTOCK_REQ_Q'	,text: '요청누계량'		,type:'uniQty'},
//			{name: 'WKORD_Q'       	,text: '작업지시량'		,type:'string'},
			{name: 'WKORD_Q'       	,text: '작업지시량'		,type:'uniQty'},
//			{name: 'PRODT_Q'       	,text: '생산실적'		,type:'string'},
			{name: 'PRODT_Q'       	,text: '생산실적'		,type:'uniQty'},
			{name: 'REMARK'        	,text: '비고'			,type:'string'},
			{name: 'PROJECT_NO'    	,text: '프로젝트번호'	,type:'string'}
//			{name: 'PJT_CODE'       ,text: '프로젝트번호'	,type:'string'}
		]
	});

    //조회시 출고요청정보 팝업창 모델 정의
	Unilite.defineModel('issueRequestNoMasterModel', {
	    fields: [
            {name: 'DIV_CODE'           , text: '사업장'       , type: 'string'},
            {name: 'WORK_SHOP_CODE'     , text: '작업장'       , type: 'string', store: Ext.data.StoreManager.lookup('wsList')},
            {name: 'SEQ'                , text: '순번'         , type: 'string'},
            {name: 'OUTSTOCK_NUM'       , text: '출고요청번호'   , type: 'string'},
            {name: 'REF_WKORD_NUM'      , text: '작업지시번호'   , type: 'string'},
            {name: 'ITEM_CODE'          , text: '품목코드'      , type: 'string'},
            {name: 'ITEM_NAME'          , text: '품명'        , type: 'string'},
            {name: 'SPEC'               , text: '규격'        , type: 'string'},
            {name: 'STOCK_UNIT'         , text: '단위'        , type: 'string'},
            {name: 'ALLOCK_Q'           , text: '예약량'       , type: 'uniQty'},
            {name: 'OUTSTOCK_REQ_Q'     , text: '출고요청량'    , type: 'uniQty'},
            {name: 'OUTSTOCK_Q'         , text: '출고량'       , type: 'uniQty'},
            {name: 'ISSUE_QTY'          , text: '미출고량'      , type: 'uniQty'},
            {name: 'OUTSTOCK_REQ_DATE'  , text: '출고요청일'    , type: 'uniDate'},
            {name: 'LOT_NO'             , text: 'LOT NO'     , type: 'string'},
            {name: 'REMARK'             , text: '비고'        , type: 'string'},
            {name: 'PROJECT_NO'         , text: '프로젝트 번호'  , type: 'string'},
            {name: 'PJT_CODE'           , text: '프로젝트번호'   , type: 'string'}
        ]
	});

	/* Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('s_pmp200ukrv_kdmasterStore', {
		model: 's_pmp200ukrv_kdMasterModel',
		autoLoad: false,
		uniOpt: {
			isMaster:	true,			// 상위 버튼 연결
			editable:	true,			// 수정 모드 사용
			deletable:	true,		// 삭제 가능 여부
			allDeletable:   true,    //전체삭제 가능 여부
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
        listeners:{
            load: function(store, records, successful, eOpts) {
                if(masterGrid.getStore().getCount() == 0) {
                    Ext.getCmp('GW').setDisabled(true);
                    Ext.getCmp('GW2').setDisabled(true);
                } else if(masterGrid.getStore().getCount() != 0) {
                    Ext.getCmp('GW').setDisabled(false);
                    Ext.getCmp('GW2').setDisabled(false);
                } else {
                    if(masterStore.data.items[0].data.GW_FLAG == 'Y') {
                        UniAppManager.setToolbarButtons(['save', 'newData', 'delete','deleteAll'], false);
                    } else {
                        UniAppManager.setToolbarButtons(['save', 'newData', 'delete','deleteAll'], true);
                    }
                }
            }
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
			paramMaster.MONEY_UNIT = BsaCodeInfo.gsMoneyUnit;

			var isErr = false;
			Ext.each(list, function(record, index) {
                if(BsaCodeInfo.gsUsePabStockYn == "Y" && record.get('OUTSTOCK_REQ_Q') > record.get('PAB_STOCK_Q')){
                    alert('요청량은 가용재고량을 초과할 수 없습니다.');
                    isErr = true;
                    return false;
                }
            });
            if(isErr) return false;

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
						if(masterStore.getCount() == 0){
                            UniAppManager.app.onResetButtonDown();
                        }
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var detailStore = Unilite.createStore('s_pmp200ukrv_kddetailStore', {
		model: 's_pmp200ukrv_kdDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
        proxy: directProxy2,
		loadStoreRecords: function(param) {
//			var param= record;
//			console.log(param);
			this.load({
				params : param
			});
		}/*,
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
					 syncAll 수정
					 * config = {
							success: function() {
											detailForm.getForm().wasDirty = false;
											detailForm.resetDirtyStatus();
											console.log("set was dirty to false");
											UniAppManager.setToolbarButtons('save', false);
									   }
							  };
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
                var grid = Ext.getCmp('s_pmp200ukrv_kdGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				// alert(Msg.sMB083);
			}
		}*/
	});

	//조회시 출고요청정보 팝업창 스토어 정의
	var issueRequestNoMasterStore = Unilite.createStore('issueRequestNoMasterStore', {
			model: 'issueRequestNoMasterModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read    : 's_pmp200ukrv_kdService.selectOrderNumMasterList'
                }
            }
            ,loadStoreRecords : function()	{
				var param = issueRequestNoSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
            groupField: 'OUTSTOCK_NUM'
	});

	/* Grid 정의
	 * @type
	 */
    var masterGrid = Unilite.createGrid('s_pmp200ukrv_kdGrid', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
			useContextMenu: true,
			onSelectFirst: true,
			onLoadSelectFirst : false
        },
        tbar: [{
                itemId : 'GWBtn',
                id:'GW',
                iconCls : 'icon-referance'  ,
                text:'기안',
                handler: function() {
                    var param = panelResult.getValues();
                    param.DRAFT_NO = UserInfo.compCode + panelResult.getValue('OUTSTOCK_NUM');
                    if(confirm('기안 하시겠습니까?')) {
                        s_pmp200ukrv_kdService.selectGwData(param, function(provider, response) {
                            if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
                                panelResult.setValue('GW_TEMP', '기안중');
                                s_pmp200ukrv_kdService.makeDraftNum(param, function(provider2, response)   {
                                    UniAppManager.app.requestApprove();
                                });
                            } else {
                                alert('이미 기안된 자료입니다.');
                                return false;
                            }
                        });
                    }
                    UniAppManager.app.onQueryButtonDown();
                }
            },{
                itemId : 'GWBtn2',
                id:'GW2',
                iconCls : 'icon-referance'  ,
                text:'기안뷰',
                handler: function() {
                    var param = panelResult.getValues();
                    param.DRAFT_NO = UserInfo.compCode + panelResult.getValue('OUTSTOCK_NUM');
                    record = masterGrid.getSelectedRecord();
                    s_pmp200ukrv_kdService.selectDraftNo(param, function(provider, response) {
                        if(Ext.isEmpty(provider[0])) {
                            alert('draft No가 없습니다.');
                            return false;
                        } else {
                            UniAppManager.app.requestApprove2(record);
                        }
                    });
                    UniAppManager.app.onQueryButtonDown();
                }
            },{
    			xtype: 'splitbutton',
               	itemId:'refTool',
    			text: '참조...',
    			iconCls : 'icon-referance',
    			menu: Ext.create('Ext.menu.Menu', {
    				items: [{
    					itemId: 'requestBtn',
    					text: '작업지시참조',
    					handler: function() {
    						if(panelSearch.getValue("OUTSTOCK_NUM") != "" /* && sFlagOutNum */ ){
    							alert('<t:message code="unilite.msg.sMP573"/>');
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
    				}]
    			})
    		}
        ],
        store: masterStore,
    	columns: [
			{dataIndex: 'COMP_CODE'        		, width: 66 		, hidden:true},
			{dataIndex: 'DIV_CODE'         	 	, width: 66 		, hidden:true},
			{dataIndex: 'ITEM_CODE'                     , width: 120,
                editor: Unilite.popup('DIV_PUMOK_G', {
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
                        extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
                        autoPopup:true,
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
                            masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }
                    }
                })
            },
			{dataIndex: 'ITEM_NAME'                      , width: 200,
                editor: Unilite.popup('DIV_PUMOK_G', {
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
                                                    masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                                                }
                                        }
                    })
            },
			{dataIndex: 'SPEC'             		, width: 133},
			{dataIndex: 'STOCK_UNIT'       	 	, width: 100 , align:'center'},
			{dataIndex: 'PATH_CODE'        		, width: 100		, hidden:true},
			{dataIndex: 'OUTSTOCK_REQ_Q'   		, width: 110 },
			{dataIndex: 'OUTSTOCK_Q'       		, width: 110},
			{dataIndex: 'PAB_STOCK_Q'           , width: 110, hidden: usePabStockYn},
			{dataIndex: 'OUTSTOCK_REQ_DATE'	 	, width: 100		, hidden:true},
			{dataIndex: 'CONTROL_STATUS'   		, width: 100},
			{dataIndex: 'REF_WKORD_NUM'    		, width: 113,
              'editor': Unilite.popup('WKORD_NUM_G',{
                    textFieldName : 'WKORD_NUM',
                    DBtextFieldName : 'WKORD_NUM',
			    	autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('REF_WKORD_NUM',records[0]['WKORD_NUM']);
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('REF_WKORD_NUM','');
                      }
                    }
                })
            },
//            {dataIndex: 'WKORD_NUM'             , width: 113},
			{dataIndex: 'REMARK'           		, width: 133},
			{dataIndex: 'PROJECT_NO'       	 	, width: 100,
              'editor': Unilite.popup('PJT_G',{
                    textFieldName : 'PJT_CODE',
                    DBtextFieldName : 'PJT_CODE',
			    	autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('PROJECT_NO',records[0]['PJT_CODE']);
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('PROJECT_NO','');
                      }
                    }
                })
            },
//			{dataIndex: 'PJT_CODE'         		, width: 100},
			{dataIndex: 'OUTSTOCK_NUM'     		, width: 66		, hidden:true},
			{dataIndex: 'OUTSTOCK_REQ_PRSN'		, width: 66		, hidden:true},
			{dataIndex: 'AGREE_STATUS'     	 	, width: 66		, hidden:true},
			{dataIndex: 'AGREE_PRSN'       		, width: 66		, hidden:true},
			{dataIndex: 'AGREE_DATE'       		, width: 66		, hidden:true},
			{dataIndex: 'COUNT_WKORD_NUM'  	 	, width: 66		, hidden:true},
			{dataIndex: 'UPDATE_DB_USER'   		, width: 66		, hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'   		, width: 66		, hidden:true},
            {dataIndex: 'WORK_SHOP_CODE'        , width: 80     , hidden:true},
            {dataIndex: 'OUTSTOCK_REQ_DATE'     , width: 80     , hidden:true},
            {dataIndex: 'GW_FLAG'               , width: 100},
            {dataIndex: 'GW_DOC'                , width: 100},
            {dataIndex: 'DRAFT_NO'              , width: 100}


		],
		listeners: {
			selectionchange:function( model1, selected, eOpts ){
       			if(selected.length > 0)	{
	        		var record = selected[0];
	        		if(record.phantom){ return false;}
	        		this.returnCell(record);
//	        		detailStore.loadData({})
	        		var param = {
                        DIV_CODE        : record.get('DIV_CODE'),
                        WORK_SHOP_CODE  : record.get('WORK_SHOP_CODE'),
                        ITEM_CODE       : record.get('ITEM_CODE'),
                        PATH_CODE       : record.get('PATH_CODE'),
                        REF_WKORD_NUM   : record.get('REF_WKORD_NUM')
                    }
					detailStore.loadStoreRecords(param);
       			}
          	},
          	select: function() {
                var count = masterGrid.getStore().getCount();
                var record = masterGrid.getSelectedRecord();
                if(count > 0) {
//                    UniAppManager.setToolbarButtons(['newData', 'delete'], true);
                }
            },
            cellclick: function() {
                var count = masterGrid.getStore().getCount();
                var record = masterGrid.getSelectedRecord();
                if(count > 0) {
//                    UniAppManager.setToolbarButtons(['newData', 'delete'], true);
                }
            },
			beforeedit  : function( editor, e, eOpts ){
//				if (UniUtils.indexOf(e.field,['OUTSTOCK_REQ_Q','CONTROL_STATUS'])){
//                    /*if(e.record.get('OUTSTOCK_Q') > 0){
//                        alert('출고된 수량이 있어 수정이 불가능합니다.');
//                        return false;
//                    }*/
//                }
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
                if(panelResult.getValue('GW_TEMP') == '기안중') {
                    return false;
                }
				if (UniUtils.indexOf(e.field,
									['OUTSTOCK_REQ_Q','REMARK','CONTROL_STATUS','PROJECT_NO']))
					return true;

				if (UniUtils.indexOf(e.field,
									['COMP_CODE','DIV_CODE','SPEC','STOCK_UNIT','PATH_CODE','OUTSTOCK_Q',
									 'OUTSTOCK_REQ_DATE','REF_WKORD_NUM','OUTSTOCK_NUM','OUTSTOCK_REQ_PRSN',
									 'AGREE_STATUS','AGREE_PRSN','AGREE_DATE','COUNT_WKORD_NUM','UPDATE_DB_USER','UPDATE_DB_TIME', 'ITEM_CODE', 'ITEM_NAME', 'GW_FLAG', 'GW_DOC', 'DRAFT_NO']))
					return false;
			}
       	},
       	returnCell: function(record) {
        	var divCode			= panelSearch.getValue("DIV_CODE");
        	var workShopCode	= panelSearch.getValue("WORK_SHOP_CODE");
        	var itemCode 		= record.get("ITEM_CODE");
        	var pathCode 		= record.get("PATH_CODE");
        	var refWkorkNum    = record.get("REF_WKORD_NUM");
            panelSearch.setValues({'DIV_CODE_TEMP':divCode});
            panelSearch.setValues({'WORK_SHOP_CODE_TEMP':workShopCode});
            panelSearch.setValues({'ITEM_CODE_TEMP':itemCode});
            panelSearch.setValues({'PATH_CODE_TEMP':pathCode});
            panelSearch.setValues({'REF_WKORD_NUM':refWkorkNum});
        },
		setItemData: function(record, dataClear) {
       		var grdRecord = this.getSelectedRecord();
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'		,"");
       			grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
//				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('STOCK_UNIT'		,"");
				grdRecord.set('PAB_STOCK_Q'     , "");
//				grdRecord.set('OUTSTOCK_REQ_Q'  ,"");
//				grdRecord.set('CONTROL_STATUS'  ,"2");

       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('SPEC'				, record['SPEC']);
//				grdRecord.set('ORDER_UNIT'			, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
//				grdRecord.set('OUTSTOCK_REQ_Q'		, "");
//				grdRecord.set('CONTROL_STATUS'		, "2");
				if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
                    UniMatrl.fnStockQ_kd(grdRecord, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, grdRecord.get('DIV_CODE'), UniDate.getDbDateStr(grdRecord.get('OUTSTOCK_REQ_DATE')), grdRecord.get('ITEM_CODE'));
                }
       		}
		},
		setControlStatus: function() {
			alert('setControlStatus');
            var grdRecord = masterGrid.uniOpt.currentRecord;
            grdRecord.set('CONTROL_STATUS'  ,"2");

        },



		setEstiData:function(record) {
       		var grdRecord = this.getSelectedRecord();

       		grdRecord.set('COMP_CODE'			, panelSearch.getValue('COMP_CODE'));
			grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('PATH_CODE'			, record['PATH_CODE']);
			grdRecord.set('OUTSTOCK_REQ_Q'		, record['OUTSTOCK_REQ_Q']);
			grdRecord.set('OUTSTOCK_Q'			, record['OUTSTOCK_Q']);
//			grdRecord.set('OUTSTOCK_REQ_DATE'	, record['OUTSTOCK_REQ_DATE']);
			grdRecord.set('CONTROL_STATUS'		, "2" );
			grdRecord.set('REF_WKORD_NUM'		, record['REF_WKORD_NUM']);
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('OUTSTOCK_NUM'		, record['OUTSTOCK_NUM']);
			grdRecord.set('OUTSTOCK_REQ_PRSN'	, record['OUTSTOCK_REQ_PRSN']);
//			grdRecord.set('AGREE_STATUS'		, record['AGREE_STATUS']);
//			grdRecord.set('AGREE_PRSN'			, record['AGREE_PRSN']);
			grdRecord.set('AGREE_DATE'			, record['AGREE_DATE']);
			grdRecord.set('COUNT_WKORD_NUM'		, record['COUNT_WKORD_NUM']);
			grdRecord.set('PAB_STOCK_Q'         , record['PAB_STOCK_Q']);



            var param = {
                DIV_CODE        : grdRecord.get('DIV_CODE'),
                WORK_SHOP_CODE  : grdRecord.get('WORK_SHOP_CODE'),
                ITEM_CODE       : grdRecord.get('ITEM_CODE'),
                PATH_CODE       : grdRecord.get('PATH_CODE'),
                REF_WKORD_NUM   : grdRecord.get('REF_WKORD_NUM')
            }
            detailStore.loadStoreRecords(param);
//			var record = grdRecord;
//			detailStore.loadStoreRecords(record);
		}
    });

    var detailGrid = Unilite.createGrid('s_pmp200ukrv_kdGrid2', {
    	layout: 'fit',
        region:'south',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
            onLoadSelectFirst: false
        },
    	store: detailStore,
        columns: [
			{dataIndex: 'WKORD_NUM'      	, width: 113},
			{dataIndex: 'ITEM_CODE'      	, width: 100},
			{dataIndex: 'ITEM_NAME'       	, width: 200},
			{dataIndex: 'SPEC'           	, width: 133},
			{dataIndex: 'STOCK_UNIT'     	, width: 100, align:'center'},
			{dataIndex: 'LOT_NO'            , width: 120},
			{dataIndex: 'ALLOCK_Q'       	, width: 110},
			{dataIndex: 'OUTSTOCK_REQ_Q' 	, width: 110 , hidden: true},
			{dataIndex: 'WKORD_Q'        	, width: 110},  // align:'right'},
			{dataIndex: 'PRODT_Q'         	, width: 110}, // align:'right'},
			{dataIndex: 'REMARK'         	, width: 120},
			{dataIndex: 'PROJECT_NO'     	, width: 100}
//			{dataIndex: 'PJT_CODE'       	, width: 100}
		]
    });

	//조회시 출고요청정보 팝업창 그리드 정의
    var issueRequestNoMasterGrid = Unilite.createGrid('s_pmp200ukrv_kdissueRequestNoMasterGrid', {
        // title: '기본',
        layout : 'fit',
		store: issueRequestNoMasterStore,
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false
		},
		features: [
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false}
        ],
        columns:  [
            {dataIndex: 'DIV_CODE'          , width:100 , hidden : true},
            {dataIndex: 'WORK_SHOP_CODE'    , width:110 , hidden : false},
            {dataIndex: 'SEQ'               , width:40  , hidden : true},
            {dataIndex: 'OUTSTOCK_NUM'      , width:120},
            {dataIndex: 'REF_WKORD_NUM'     , width:120},
            {dataIndex: 'ITEM_CODE'         , width:120},
            {dataIndex: 'ITEM_NAME'         , width:180},
            {dataIndex: 'SPEC'              , width:150},
            {dataIndex: 'STOCK_UNIT'        , width:60},
            {dataIndex: 'ALLOCK_Q'          , width:100, hidden:true},
            {dataIndex: 'OUTSTOCK_Q'        , width:100},
            {dataIndex: 'OUTSTOCK_REQ_Q'    , width:100},
            {dataIndex: 'ISSUE_QTY'         , width:100},
            {dataIndex: 'OUTSTOCK_REQ_DATE' , width:90},
            {dataIndex: 'LOT_NO'            , width:120},
            {dataIndex: 'REMARK'            , width:150},
            {dataIndex: 'PROJECT_NO'        , width:120}
//          {dataIndex: 'PJT_CODE'          , width:153}
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
          	panelSearch.setValues({'OUTSTOCK_NUM' : record.get('OUTSTOCK_NUM'), 'OUTSTOCK_REQ_DATE' : record.get('OUTSTOCK_REQ_DATE')});
          }
    });


    //조회시 출고요청정보 팝업창 폼 정의
  	var issueRequestNoSearch = Unilite.createSearchForm('issueRequestNoSearchForm', {
		layout: {type: 'uniTable', columns : 3},
	    trackResetOnLoad: true,
	    items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                hidden : true,
                value: UserInfo.divCode
            },{
                fieldLabel: '작업장',
                name: 'WORK_SHOP_CODE',
                xtype: 'uniCombobox',
                store: Ext.data.StoreManager.lookup('wsList'),
                hidden : true
            },{
                fieldLabel: '요청일',
                xtype: 'uniDateRangefield',
                startFieldName: 'OUTSTOCK_REQ_DATE_FR',
                endFieldName: 'OUTSTOCK_REQ_DATE_TO',
                width: 350,
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            },{
                xtype: 'uniTextfield',
                name: 'OUTSTOCK_NUM',
                fieldLabel: '출고요청번호',
                colspan : 2
            },
                Unilite.popup('DIV_PUMOK',{
                    fieldLabel: '품목코드',
//                    validateBlank:false,
                    listeners: {
                        applyextparam: function(popup){
                            if(Ext.isDefined(panelSearch)){
                                popup.setExtParam({'DIV_CODE': issueRequestNoSearch.getValue("DIV_CODE")});
                                //popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
                            }
                        }
                    }
            }),{
                xtype: 'uniTextfield',
                name: 'REF_WKORD_NUM',
                fieldLabel: '작업지시번호'
            },{
                boxLabel: '미출고',
                xtype:'checkboxfield',
                name: 'IS_ISSUE',
                fieldLabel: ' ',
                checked: false
            }]
    }); // createSearchForm


	//조회창 메인
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '출고요청정보',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [issueRequestNoSearch, issueRequestNoMasterGrid],
                tbar:  ['->',
				        {	itemId : 'searchBtn',
							text: '조회',
							handler: function() {
								issueRequestNoMasterStore.loadStoreRecords();
							},
							disabled: false
						}, {
							itemId : 'closeBtn',
							text: '닫기',
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
		        fieldLabel: '사업장',
		        name:'DIV_CODE',
		        xtype: 'uniCombobox',
		        comboType:'BOR120' ,
		        allowBlank:false,
		        //value:UserInfo.divCode,
		        hidden: true
		    },{
				fieldLabel: '작업장',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('wsList'),
		 		allowBlank:false,
		 		hidden: true
			},
            	Unilite.popup('DIV_PUMOK',{
					fieldLabel: '품목코드',
					textFieldWidth:170,
					validateBlank:false,
					textFieldName: 'ITEM_NAME',
					valueFieldName: 'ITEM_CODE'
			}),{
				fieldLabel: '적용여부',
				name:'APPLY_FLAG',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'P102'
			},{
            	fieldLabel: '생산요청일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'PRODT_START_DATE_FR',
			    endFieldName: 'PRODT_START_DATE_TO',
			    width: 350,
			    startDate: UniDate.get('startOfMonth'),
			    endDate: UniDate.get('today')
	       }]
    });

    // 작업지시 참조 모델 정의
    Unilite.defineModel('s_pmp200ukrv_kdWorkModel', {
    	fields: [
	    	{name: 'GUBUN'             	, text: '선택'			, type: 'string'},
	    	{name: 'COMP_CODE'         	, text: '법인코드' 		, type: 'string'},
		    {name: 'DIV_CODE'          	, text: '사업장'		, type: 'string'},
		    {name: 'WORK_SHOP_CODE'    	, text: '작업장' 		, type: 'string'},
		    {name: 'PROG_WORK_CODE'    	, text: '공정코드' 		, type: 'string'},
		    {name: 'ITEM_CODE'         	, text: '품목코드'		, type: 'string'},
		    {name: 'ITEM_NAME'         	, text: '품명' 			, type: 'string'},
		    {name: 'SPEC'              	, text: '규격' 			, type: 'string'},
		    {name: 'STOCK_UNIT'        	, text: '단위'			, type: 'string'},
	    	{name: 'WKORD_Q'           	, text: '작업지시량' 	, type: 'uniQty'},
		    {name: 'PRODT_START_DATE'  	, text: '착수예정일'	, type: 'uniDate'},
		    {name: 'PRODT_END_DATE'    	, text: '작업완료일' 	, type: 'uniDate'},
		    {name: 'WKORD_NUM'         	, text: '작업지시번호' 	, type: 'string'},
		    {name: 'LOT_NO'		    	, text: 'LOT NO'		, type: 'string'},
		    {name: 'SFLAG'             	, text: '적용여부'		, type: 'string'},
		    {name: 'REMARK'            	, text: '비고' 			, type: 'string'},
		    {name: 'PROJECT_NO'			, text: '프로젝트번호' 	, type: 'string'}
//		    {name: 'PJT_CODE'			, text: '프로젝트번호'		, type: 'string'}
		]
	});

    //작업지시 참조 스토어 정의
	var WorkStore = Unilite.createStore('s_pmp200ukrv_kdWorkStore', {
		model: 's_pmp200ukrv_kdWorkModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read    : 's_pmp200ukrv_kdService.selectEstiList'
            }
        },
        listeners:{
        	load:function(store, records, successful, eOpts)	{
    			if(successful)	{
    			   var masterRecords = masterStore.data.filterBy(masterStore.filterNewOnly);
    			   var estiRecords = new Array();
    			   if(masterRecords.items.length > 0)	{
    			   	console.log("store.items :", store.items);
    			   	console.log("records", records);
						Ext.each(records,
				   			function(item, i)	{
								Ext.each(masterRecords.items, function(record, i)	{
									console.log("record :", record);
									if((record.data['ESTI_NUM'] == item.data['ESTI_NUM']) && (record.data['ESTI_SEQ'] == item.data['ESTI_SEQ'])){
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
	var WorkGrid = Unilite.createGrid('s_pmp200ukrv_kdWorkGrid', {
    	layout : 'fit',
    	store: WorkStore,

        selModel: 'rowmodel',
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
        	{ dataIndex: 'WKORD_NUM'         	   		, width: 100},
        	{ dataIndex: 'LOT_NO'		    	   		, width: 100},
        	{ dataIndex: 'SFLAG'             	   		, width: 66},
        	{ dataIndex: 'REMARK'            	   		, width: 133},
        	{ dataIndex: 'PROJECT_NO'			   		, width: 100}
//        	{ dataIndex: 'PJT_CODE'			   			, width: 100}
		],
		returnData: function(record)	{
			if(Ext.isEmpty(record))  {
                record = this.getSelectedRecord();
            }
            var record = WorkGrid.getSelectedRecords();
            panelSearch.setValue('REF_WKORD_NUM', record[0].get('WKORD_NUM'));
            var param= {
                'DIV_CODE': panelSearch.getValue('DIV_CODE'),
                'REF_WKORD_NUM': panelSearch.getValue('REF_WKORD_NUM'),
                'WORK_SHOP_CODE': panelSearch.getValue('WORK_SHOP_CODE'),
                'OUTSTOCK_REQ_DATE': UniDate.getDbDateStr(panelSearch.getValue('OUTSTOCK_REQ_DATE'))
            }
            s_pmp200ukrv_kdService.orderApply(param, function(provider, response){
                var records = response.result;
                Ext.each(records, function(record,i){
                    UniAppManager.app.onNewDataButtonDown();
                    masterGrid.setEstiData(record);
                });
            });



//       		var records = this.getSelectedRecords();
//
//			Ext.each(records, function(record,i){
//	        	UniAppManager.app.onNewDataButtonDown();
//	        	masterGrid.setEstiData(record.data);
//		    });
//			//this.deleteSelectedRow();
       	},
       	listeners: {
            onGridDblClick:function(grid, record, cellIndex, colName) {
            	WorkGrid.returnData();
            	referWorkOrderWindow.hide();
//            	UniAppManager.setToolbarButtons(['newData'], true);
            }
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
                title: '작업지시참조',
                width: 1080,
                height: 580,
                layout:{type:'vbox', align:'stretch'},

                items: [WorkSearch, WorkGrid],
                tbar:  ['->',
			        {	itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							WorkStore.loadStoreRecords();
						},
						disabled: false
					},
					{	itemId : 'confirmBtn',
						text: '요청적용',
						handler: function() {
							WorkGrid.returnData();

//							var record = WorkGrid.getSelectedRecords();
//							panelSearch.setValue('REF_WKORD_NUM', record[0].get('WKORD_NUM'));
//							var param= {
//								'DIV_CODE': panelSearch.getValue('DIV_CODE'),
//								'REF_WKORD_NUM': panelSearch.getValue('REF_WKORD_NUM'),
//								'WORK_SHOP_CODE': panelSearch.getValue('WORK_SHOP_CODE')
//							}
//							s_pmp200ukrv_kdService.orderApply(param, function(provider, response){
//						    	var records = response.result;
//						    	Ext.each(records, function(record,i){
//                                    UniAppManager.app.onNewDataButtonDown();
//                                    masterGrid.setEstiData(provider);
//                                });
//						    });
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						text: '요청적용 후 닫기',
						handler: function() {
                            WorkGrid.returnData();
							referWorkOrderWindow.hide();
//							UniAppManager.setToolbarButtons(['newData'], true);
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
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
		id: 's_pmp200ukrv_kdApp',
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
			UniAppManager.setToolbarButtons(['reset', 'newData'], true);
//            UniAppManager.setToolbarButtons([], false);
            Ext.getCmp('GW').setDisabled(true);
            Ext.getCmp('GW2').setDisabled(true);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			var orderNo = panelSearch.getValue('OUTSTOCK_NUM');
			var refWkordNum = panelSearch.getValue('REF_WKORD_NUM');
            panelResult.setValue('GW_TEMP', '');
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
//				UniAppManager.setToolbarButtons(['newData'], true);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				 var outstocknum = panelSearch.getValue('OUTSTOCK_NUM')
//				 var seq = masterStore.max('ITEM_CODE');
//				 	if(!seq) seq = 1;
//            	 	else  seq += 1;
            	 var divCode = panelSearch.getValue('DIV_CODE');
            	 var pathCode = '0';
            	 var outsotockReqDate = panelSearch.getValue('OUTSTOCK_REQ_DATE');
                 var workShopCode = panelSearch.getValue('WORK_SHOP_CODE');
            	 var outstockQ = '0';
            	 var countWkordNum = '0';
            	 var controlStatus = '2';
            	 var outstockReqPrsn = panelSearch.getValue('OUTSTOCK_REQ_PRSN');
            	 var agreeStatus = panelSearch.getValue('AGREE_STATUS');
            	 var agreePrsn = panelSearch.getValue('AGREE_PRSN');
            	 var workShopCode = panelSearch.getValue('WORK_SHOP_CODE');
                 var outstockReqDate = panelSearch.getValue('OUTSTOCK_REQ_DATE');

            	 var r = {
				 	 		OUTSTOCK_NUM : outstocknum,
//				 	 		ITEM_CODE: seq,
				 	 		//COMP_CODE: compCode
							DIV_CODE: divCode ,
							PATH_CODE: pathCode,
							OUTSTOCK_REQ_DATE: outsotockReqDate,
							WORK_SHOP_CODE: workShopCode,
							OUTSTOCK_Q: outstockQ,
							COUNT_WKORD_NUM: countWkordNum,
							CONTROL_STATUS: controlStatus,
							OUTSTOCK_REQ_PRSN: outstockReqPrsn,
							AGREE_STATUS: agreeStatus,
							AGREE_PRSN: agreePrsn,
							WORK_SHOP_CODE: workShopCode,
							OUTSTOCK_REQ_DATE: outstockReqDate
						 };
				masterGrid.createRow(r);
				panelSearch.setAllFieldsReadOnly(true);
			},
		onResetButtonDown: function() {
			this.suspendEvents();
			//panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterStore.clearData();
			//panelResult.clearForm();
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
			if(selRow.get('OUTSTOCK_Q') > 0){
                alert('출고된 수량이 있어 삭제가 불가능합니다.');
                return false;
            }
            if(selRow.get('GW_FLAG') == 3){
            	alert('결제를 진행하고있어 삭제가 불가능합니다.');
            	return false;
            }
            if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('INSPEC_Q') > 1)
				{
					alert('<t:message code="unilite.msg.sMT335"/>');
				}else{
					masterGrid.deleteSelectedRow();
				}
			}


			// fnOrderAmtSum 호출(grid summary 이용)
		},
         onDeleteAllButtonDown: function() {
            var records = masterStore.data.items;
            var isNewData = false;
            Ext.each(records, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    isNewData = false;
                    if(confirm('전체삭제 하시겠습니까?')) {
                        var deletable = true;
                        /*---------삭제전 로직 구현 시작----------*/

                        /*---------삭제전 로직 구현 끝-----------*/

                        if(deletable){
                            masterGrid.reset();
                            UniAppManager.app.onSaveDataButtonDown();
                        }
                    }
                    return false;
                }
            });
            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋
                masterGrid.reset();
                UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
            }

        },
		checkForNewDetail:function() {
			if(Ext.isEmpty(panelSearch.getValue('WORK_SHOP_CODE')))	{
				alert('<t:message code="unilite.msg.sMR401" default="작업장"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}
			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onDetailButtonDown: function() {
			var as = Ext.getCmp('s_pmp200ukrv_kdAdvanceSerch');
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
			var fp = Ext.getCmp('s_pmp200ukrv_kdFileUploadPanel');
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
			panelSearch.setValue('AGREE_STATUS', BsaCodeInfo.gsAutoAgree);
            panelResult.setValue('AGREE_STATUS', BsaCodeInfo.gsAutoAgree);


			UniAppManager.setToolbarButtons('save', false);
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
        },
        cbStockQ_kd: function(provider, params)    {
            var rtnRecord = params.rtnRecord;
            var pabStockQ = Unilite.nvl(provider['PAB_STOCK_Q'], 0);//가용재고량
            rtnRecord.set('PAB_STOCK_Q', pabStockQ);
        },
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var outStocNum  = panelResult.getValue('OUTSTOCK_NUM');
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_PMP200UKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + outStocNum + "'";
            var spCall      = encodeURIComponent(spText);

//            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_pmp200ukrv_kd&draft_no=" + UserInfo.compCode + panelResult.getValue('OUTSTOCK_NUM') + "&sp=" + spCall;
            frm.target   = "payviewer";
            frm.method   = "post";
            frm.submit();


        },
        requestApprove2: function(record){     // VIEW
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var outStocNum  = panelResult.getValue('OUTSTOCK_NUM');
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_PMP200UKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + outStocNum + "'";
            var spCall      = encodeURIComponent(spText);

//            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "appr_id=" + record.data.GW_DOC + "&viewMode=docuDraft";
            frm.target   = "payviewer";
            frm.method   = "post";
            frm.submit();


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
			if(record.get('OUTSTOCK_Q') > 0){
                alert('출고된 수량이 있어 수정이 불가능합니다.');
                return false;
            }
			switch(fieldName) {
				case "ITEM_CODE" :
					var itemCode = record.get('ITEM_CODE');
					if(itemCode != "")	{
//						Ext.getBody().mask();
						var param = {'DIV_CODE':newValue, 'ITEM_CODE':itemCode, 'S_COMP_CODE':UserInfo.compCode, 'USELIKE':false, 'TYPE':'VALUE'};
						popupService.divPumokPopup(param, function(provider, response)	{
															if(Ext.isEmpty(provider))	{
																alert(Msg.sMS288);
//																Ext.getBody().unmask();
															} else {
																console.log("provider",provider)
																if(!Ext.isEmpty('provider')) masterGrid.setItemData(provider[0],false);
																else masterGrid.setItemData(null, true);
															}
														});
						outDivCode=newValue;

						break;
					}
					if(Ext.isEmpty(newValue))  record.get("DIV_CODE") =	newValue;

					break;

				case "ITEM_NAME" :
					var itemName = record.get('ITEM_NAME');
					if(itemName != "")	{
//						Ext.getBody().mask();
						var param = {'DIV_CODE':newValue, 'ITEM_NAME':itemName, 'S_COMP_CODE':UserInfo.compCode, 'USELIKE':false, 'TYPE':'VALUE'};
						popupService.divPumokPopup(param, function(provider, response)	{
															if(Ext.isEmpty(provider))	{
																alert(Msg.sMS288);
//																Ext.getBody().unmask();
															} else {
																console.log("provider",provider)
																if(!Ext.isEmpty('provider')) masterGrid.setItemData(provider[0],false);
																else masterGrid.setItemData(null, true);

															}
														});
						outDivCode=newValue;

						break;
					}
					if(Ext.isEmpty(newValue))  record.get("DIV_CODE") =	newValue;

					break;

				case "CONTROL_STATUS" : //진행상태

			    	if (newValue == '2' || newValue == '8'){
//			    		alert('변경가능');

			    	}else{
//			    		alert('oldValue : ' + oldValue)

			    		alert('해당 진행상태로 변경이 불가합니다.')
                        record.set("CONTROL_STATUS", oldValue);
                        return false;

			    	}





				break;


				case "OUTSTOCK_REQ_Q" ://출고요청량
					if(newValue < 0 && !Ext.isEmpty(newValue)) {
                        rv=Msg.sMB076;
                        break;
                    }
                    if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
                        var sInout_q = newValue;    //출고량
                        var sInv_q = record.get('PAB_STOCK_Q'); //가용재고량
                        var sOriginQ = record.get('OUTSTOCK_Q'); //출고량(원)
                        if(sInout_q > sInv_q){
                            rv="요청량은 가용재고량을 초과할 수 없습니다.";
                            break;
                        }
                    }
			}
			return rv;
		}
	}); // validator
}
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>
