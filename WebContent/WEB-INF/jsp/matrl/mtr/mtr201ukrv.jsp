<%--
'   프로그램명 : 출고등록(예외출고) (구매재고)
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
<t:appConfig pgmId="mtr201ukrv"  >
   <t:ExtComboStore comboType="BOR120"  />          <!-- 사업장 -->
   <t:ExtComboStore comboType="AU" comboCode="B005" /> <!-- 출고처 구분 -->
   <t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 출고담당 -->
   <t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 재고단위 -->
   <t:ExtComboStore comboType="AU" comboCode="M104" /> <!-- 출고유형 -->
   <t:ExtComboStore comboType="AU" comboCode="B036" /> <!-- 방법 -->
   <t:ExtComboStore comboType="AU" comboCode="B001" /> <!-- 제조처 -->
   <t:ExtComboStore comboType="AU" comboCode="B021" /> <!-- 품목상태 -->
   <t:ExtComboStore comboType="AU" comboCode="B005" /> <!-- 수불처구분 -->
   <t:ExtComboStore comboType="AU" comboCode="B031" /> <!-- 생성경로 -->
   <t:ExtComboStore comboType="AU" comboCode="B083" /> <!-- path정보 -->
   <t:ExtComboStore comboType="AU" comboCode="P106" /> <!-- 진행상태 -->
   <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var SearchInfoWindow;	// 조회버튼 누르면 나오는 조회창

var BsaCodeInfo = {
	gsAutoType:        '${gsAutoType}',
	gsInvstatus:       '${gsInvstatus}',
	gsMoneyUnit:       '${gsMoneyUnit}',
	gsInoutCodeType:   '${gsInoutCodeType}',
	gsManageLotNoYN:   '${gsManageLotNoYN}',
	gsBomPathYN:       '${gsBomPathYN}',
	gsSumTypeCell:     '${gsSumTypeCell}',
	gsOutDetailType:   '${gsOutDetailType}',
    whList :            ${whList}
};

/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);
*/
var outDivCode = UserInfo.divCode;

function appMain() {

	var gsSumTypeCell = false;
    if(BsaCodeInfo.gsSumTypeCell =='N')    {
        gsSumTypeCell = true;
    }

    var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }

    //창고에 따른 창고cell 콤보load..
    var cbStore = Unilite.createStore('hat510ukrsComboStoreGrid',{
        autoLoad: false,
        fields: [
                {name: 'SUB_CODE', type : 'string'},
                {name: 'CODE_NAME', type : 'string'}
                ],
        proxy: {
            type: 'direct',
            api: {
                read: 'salesCommonService.fnRecordCombo'
            }
        },
        loadStoreRecords: function(whCode) {
            var param= panelSearch.getValues();
            param.COMP_CODE= UserInfo.compCode;
//            param.DIV_CODE = UserInfo.divCode;
            param.WH_CODE = whCode;
            param.TYPE = 'BSA225T';
            console.log( param );
            this.load({
                params: param
            });
        }
    });


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mtr201ukrvService.selectList',
			update: 'mtr201ukrvService.updateDetail',
			create: 'mtr201ukrvService.insertDetail',
			destroy: 'mtr201ukrvService.deleteDetail',
			syncAll: 'mtr201ukrvService.saveAll'
		}
	});
   /**
    *   Model 정의
    * @type
    */

	Unilite.defineModel('mtr201ukrvModel', {
		fields: [
			{name: 'INOUT_NUM'				, text: '<t:message code="system.label.purchase.issueno" default="출고번호"/>'		, type: 'string'},
			{name: 'INOUT_SEQ'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'		    , type: 'int'},
			{name: 'INOUT_METH'				, text: '<t:message code="system.label.purchase.method" default="방법"/>'		    , type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		, text: '<t:message code="system.label.purchase.issuetype" default="출고유형"/>'		, type: 'string', comboType: 'AU', comboCode: 'M104', allowBlank: false},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string', comboType: 'BOR120'},
			{name: 'INOUT_CODE'				, text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>'		, type: 'string', allowBlank: false},
			{name: 'INOUT_NAME'				, text: '<t:message code="system.label.purchase.issueplacename" default="출고처명"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('whList')},
			{name: 'INOUT_NAME1'				, text: '<t:message code="system.label.purchase.issueplacename" default="출고처명"/>'		, type: 'string'},
			{name: 'INOUT_NAME2'				, text: '<t:message code="system.label.purchase.issueplacename" default="출고처명"/>'		, type: 'string'},
			{name: 'INOUT_NAME3'				, text: '<t:message code="system.label.purchase.issueplacename" default="출고처명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.purchase.spec" default="규격"/>'		    , type: 'string'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'PATH_CODE'				, text: 'PATH정보'	    , type: 'string'},
			{name: 'NOT_Q'					, text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>'		, type: 'uniQty'},
			{name: 'INOUT_Q'				, text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'		, type: 'uniQty', allowBlank: false},
			{name: 'ITEM_STATUS'			, text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>'		, type: 'string', comboType: 'AU', comboCode: 'B021', allowBlank: false},
			{name: 'ORIGINAL_Q'				, text: '<t:message code="system.label.purchase.issueqtywon" default="출고량(원)"/>'	, type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'			, text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>'		, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'			, text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'		, type: 'uniQty'},
			{name: 'BASIS_NUM'				, text: '<t:message code="system.label.purchase.requestno" default="요청번호"/>'		, type: 'string'},
			{name: 'BASIS_SEQ'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'		    , type: 'int'},
			{name: 'INOUT_TYPE'				, text: '<t:message code="system.label.purchase.type" default="타입"/>'		    , type: 'string'},
			{name: 'INOUT_CODE_TYPE'		, text: '<t:message code="system.label.purchase.tranplacedivision" default="수불처구분"/>'	, type: 'string'},
			{name: 'WH_CODE'				, text: '수불창고'		, type: 'string', store: Ext.data.StoreManager.lookup('whList'), allowBlank: false},
			{name: 'WH_CELL_CODE'			, text: 'CELL창고'	    , type: 'string', allowBlank: gsSumTypeCell, store: cbStore},
			{name: 'INOUT_DATE'				, text: '<t:message code="system.label.purchase.transdate" default="수불일자"/>'		, type: 'uniDate'},
			{name: 'INOUT_P'				, text: '<t:message code="system.label.purchase.tranprice" default="수불단가"/>'		, type: 'uniUnitPrice'},
			{name: 'INOUT_I'				, text: '<t:message code="system.label.purchase.localamount" default="원화금액"/>'		, type: 'uniPrice'},
			{name: 'MONEY_UNIT'				, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'		    , type: 'string'},
			{name: 'INOUT_PRSN'				, text: '<t:message code="system.label.purchase.charger" default="담당자"/>'		, type: 'string'},
			{name: 'ACCOUNT_Q'				, text: '<t:message code="system.label.purchase.billqty" default="계산서량"/>'		, type: 'uniQty'},
			{name: 'ACCOUNT_YNC'			, text: '<t:message code="system.label.purchase.billobject" default="계산서대상"/>'	, type: 'string'},
			{name: 'CREATE_LOC'				, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'		, type: 'string', comboType: 'AU', comboCode: 'B031'},
			{name: 'ORDER_NUM'				, text: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>'	, type: 'string'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'		    , type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'	, type: 'string'},
			{name: 'LOT_NO'					, text: 'LOT NO'		, type: 'string'},
			{name: 'SALE_DIV_CODE'			, text: '<t:message code="system.label.purchase.salesdivision" default="매출사업장"/>'	, type: 'string'},
			{name: 'SALE_CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.salesplace" default="매출처"/>'		, type: 'string'},
			{name: 'BILL_TYPE'				, text: '<t:message code="system.label.purchase.salestype" default="매출유형"/>'		, type: 'string'},
			{name: 'SALE_TYPE'				, text: '<t:message code="system.label.purchase.salesclass" default="매출구분"/>'		, type: 'string'},
			{name: 'COMP_CODE'				, text: 'COMP_CODE'	    , type: 'string'},
			{name: 'OUTSTOCK_NUM'		    , text: '<t:message code="system.label.purchase.requestno" default="요청번호"/>'		, type: 'string'},
			{name: 'REF_WKORD_NUM'	        , text: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>'	, type: 'string'},
			{name: 'ARRAY_OUTSTOCK_REQ_Q'	, text: '<t:message code="system.label.purchase.requestqty" default="요청량"/>'		, type: 'uniQty'},
			{name: 'ARRAY_OUTSTOCK_Q'		, text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'		, type: 'uniQty'},
			{name: 'ARRAY_REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'		    , type: 'string'},
			{name: 'ARRAY_PROJECT_NO'		, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'	, type: 'string'},
			{name: 'ARRAY_LOT_NO'			, text: 'LOT NO'		, type: 'string'},
			{name: 'UPDATE_DB_USER'			, text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>'		, type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '수정한날짜'	, type: 'string'},
            {name: 'LOT_YN'                 , text: 'LOT관리여부'   , type: 'string'}
		]
	});//End of Unilite.defineModel('mtr201ukrvModel', {

	Unilite.defineModel('releaseNoMasterModel', {		//조회버튼 누르면 나오는 조회창
	    fields: [
	    	{name: 'WH_CODE'     		  , text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>'    	, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'WH_CELL_CODE'   	  , text: 'CELL창고'        , type: 'string'},
	    	{name: 'WH_CELL_NAME'   	  , text: 'CELL창고'        , type: 'string'},
	    	{name: 'INOUT_DATE'    		  , text: '<t:message code="system.label.purchase.issuedate" default="출고일"/>'    	    , type: 'uniDate'},
	    	{name: 'INOUT_CODE_TYPE'	  , text: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>'      , type: 'string',comboType: 'AU',comboCode: 'B005'},
	    	{name: 'INOUT_NAME'    		  , text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>'    	    , type: 'string'},
	    	{name: 'INOUT_PRSN' 		  , text: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>'    	, type: 'string'},
	    	{name: 'INOUT_NUM'     		  , text: '<t:message code="system.label.purchase.issueno" default="출고번호"/>'    	, type: 'string'},
	    	{name: 'DIV_CODE' 			  , text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>'    	    , type: 'string',comboType:'BOR120'},
	    	{name: 'LOT_NO' 			  , text: 'LOT NO'          , type: 'string'},
	    	{name: 'PROJECT_NO' 		  , text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'   , type: 'string'},
	    	{name: 'ITEM_CODE' 			  , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'    	, type: 'string'},
	    	{name: 'ITEM_NAME' 			  , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'    	    , type: 'string'}
		]
	});

   /**
    * Store 정의(Service 정의)
    * @type
    */

	var directMasterStore1 = Unilite.createStore('mtr201ukrvMasterStore1',{
        model: 'mtr201ukrvModel',
        autoLoad: false,
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: true,         // 수정 모드 사용
            deletable: true,        // 삭제 가능 여부
            useNavi : false         // prev | next 버튼 사용
        },
        proxy: directProxy,
        loadStoreRecords: function() {
            var param= panelSearch.getValues();
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

			var inoutNum = panelSearch.getValue('INOUT_NUM');
			var isErr = false;
			Ext.each(list, function(record, index) {
				if(record.data['INOUT_NUM'] != inoutNum) {
					record.set('INOUT_NUM', inoutNum);
				}
				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
				    alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + 'LOT NO: 필수 입력값 입니다.');
				    isErr = true;
				    return false;
				}
			});
			if(isErr) return false;

//			var totRecords = directMasterStore1.data.items;
//			Ext.each(totRecords, function(record, index) {
//				record.set('SORT_SEQ', index+1);
//			});
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
					config = {
							params: [paramMaster],
							success: function(batch, option) {
								var master = batch.operations[0].getResultSet();
								panelSearch.setValue("INOUT_NUM", master.INOUT_NUM);
								panelResult.setValue("INOUT_NUM", master.INOUT_NUM);

//								var inoutNum = panelSearch.getValue('INOUT_NUM');
//								Ext.each(list, function(record, index) {
//									if(record.data['INOUT_NUM'] != inoutNum) {
//										record.set('INOUT_NUM', inoutNum);
//									}
//								})
								panelSearch.getForm().wasDirty = false;
								panelSearch.resetDirtyStatus();
								UniAppManager.setToolbarButtons('save', false);
								directMasterStore1.loadStoreRecords();
								if(directMasterStore1.getCount() == 0){
									UniAppManager.app.onResetButtonDown();
								}

							 }
					};
				this.syncAllDirect(config);
			}else{
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
    });//End of var directMasterStore1 = Unilite.createStore('mtr201ukrvMasterStore1',{

	var releaseNoMasterStore = Unilite.createStore('releaseNoMasterStore', {	// 검색팝업창
			model: 'releaseNoMasterModel',
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
                	read    : 'mtr201ukrvService.selectreleaseNoMasterList'
                }
            },
            loadStoreRecords : function()	{
				var param= releaseNoSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});

   /**
    * 검색조건 (Search Panel)
    * @type
    */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items: [{
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
                holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>',
				name: 'INOUT_CODE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B005',
				allowBlank: false,
                holdable: 'hold',
                readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_CODE_TYPE', newValue);
						hiddenColumn();
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
				xtype: 'uniDatefield',
				name:'INOUT_DATE',
				value: UniDate.get('today'),
				allowBlank: false,
                holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024',
                holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
                holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
                fieldLabel: '<t:message code="system.label.purchase.issueno" default="출고번호"/>',
                name: 'INOUT_NUM',
                xtype: 'uniTextfield',
                readOnly: isAutoOrderNum,
                holdable: isAutoOrderNum ? 'readOnly':'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('INOUT_NUM', newValue);
                    }
                }
            }/*,{
				fieldLabel: 'Lot No',
				name: 'LOT_NO',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('LOT_NO', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.manageno" default="관리번호"/>',
				name: 'PROJECT_NO',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PROJECT_NO', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			        	valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						extParam: {'CUSTOM_TYPE': '3'},
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
									panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						}
			  })*/]
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
                        var labelText = invalid.items[0]['fieldLabel']+':';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {



	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
                holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>',
				name: 'INOUT_CODE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B005',
				allowBlank: false,
                holdable: 'hold',
                readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('INOUT_CODE_TYPE', newValue);
						hiddenColumn();
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
				xtype: 'uniDatefield',
				name:'INOUT_DATE',
				value: UniDate.get('today'),
				allowBlank: false,
                holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('INOUT_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024',
                holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('INOUT_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
                holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WH_CODE', newValue);
					}
				}
			},{
                fieldLabel: '<t:message code="system.label.purchase.issueno" default="출고번호"/>',
                name: 'INOUT_NUM',
                xtype: 'uniTextfield',
                readOnly: isAutoOrderNum,
                holdable: isAutoOrderNum ? 'readOnly':'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('INOUT_NUM', newValue);
                    }
                }
            }/*,{
				fieldLabel: 'Lot No',
				name: 'LOT_NO',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('LOT_NO', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.manageno" default="관리번호"/>',
				name: 'PROJECT_NO',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('PROJECT_NO', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			        	valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						extParam: {'CUSTOM_TYPE': '3'},
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
									panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						}
			})*/],
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
                        var labelText = invalid.items[0]['fieldLabel']+':';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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

	var releaseNoSearch = Unilite.createSearchForm('releaseNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 2},
	    trackResetOnLoad: true,
	    items: [{
                fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false
            },{
                fieldLabel: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_INOUT_DATE',
                endFieldName: 'TO_INOUT_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                width: 315,
                allowBlank:false
            },{
                fieldLabel: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>',
                name: 'INOUT_CODE_TYPE',
                xtype: 'uniCombobox',
                readOnly: true,
                comboType: 'AU',
                comboCode: 'B005'
            },{
                fieldLabel: '<t:message code="system.label.purchase.issueplace" default="출고처"/>',
                name: 'INOUT_CODE',
                xtype: 'uniCombobox',
                store: Ext.data.StoreManager.lookup('whList')
            },{
                fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
                name: 'WH_CODE',
                xtype: 'uniCombobox',
                store: Ext.data.StoreManager.lookup('whList'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        cbStore.loadStoreRecords(newValue);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
                name: 'INOUT_PRSN',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B024'
            },{
                fieldLabel: '출고창고 CELL',
                name: 'WH_CELL_CODE',
                xtype: 'uniCombobox',
                store: cbStore
            }]
    }); // createSearchForm

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('mtr201ukrvGrid1', {
       // for tab
		layout: 'fit',
		region:'center',
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'INOUT_NUM'					, width: 66, hidden: true},
			{dataIndex: 'INOUT_SEQ'					, width: 60},
            {dataIndex: 'WH_CODE'                   , width: 85},
            {dataIndex: 'WH_CELL_CODE'              , width: 85, hidden: gsSumTypeCell},
			{dataIndex: 'INOUT_METH'				, width: 46, hidden: true},
			{dataIndex: 'INOUT_TYPE_DETAIL'			, width: 85},
			{dataIndex: 'DIV_CODE'					, width: 80},
			{dataIndex: 'INOUT_CODE'				, width: 53, hidden: true},
			{dataIndex: 'INOUT_NAME'				, width: 150 , hidden: true},
			{dataIndex: 'INOUT_NAME1'				, width: 150 , hidden: true  // 작업장
                ,'editor' : Unilite.popup('WORK_SHOP_G',{textFieldName:'TREE_NAME', textFieldWidth:100, DBtextFieldName: 'TREE_NAME',
		                   	autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        UniAppManager.app.fnWorkShopChange(records);
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    //grdRecord = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
                                    //record = records[0];
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('INOUT_CODE', '');
                                    grdRecord.set('INOUT_NAME1', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelSearch.getValues();
                                    popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
                                }
                            }
                })
            },
            {dataIndex: 'INOUT_NAME2'                , width: 150		//부서
                ,'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    DBtextFieldName: 'REQ_DEPT_CODE',
                    listeners: { 'onSelected': {
                        fn: function(records, type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('INOUT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('INOUT_NAME2',records[0]['TREE_NAME']);

                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('INOUT_CODE','');
                            grdRecord.set('INOUT_NAME2','');
                      },
                        applyextparam: function(popup){
                            var param =  panelSearch.getValues();
                            popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
                        }
                    }
                })
            },{dataIndex: 'INOUT_NAME3'             , width:150, hidden: true,
              'editor': Unilite.popup('AGENT_CUST_G',{
                    textFieldName : 'CUSTOM_CODE',
                    DBtextFieldName : 'CUSTOM_CODE',
                    autoPopup:true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){

                          	  var grdRecord = masterGrid.uniOpt.currentRecord;
                            	    grdRecord.set('INOUT_CODE',records[0]['CUSTOM_CODE']);
		                            grdRecord.set('INOUT_NAME3',records[0]['CUSTOM_NAME']);

                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('INOUT_CODE','');
                            grdRecord.set('INOUT_NAME3','');

                      }
                    }
                })
            },
			{dataIndex: 'ITEM_CODE'					, width: 100,
			editor: Unilite.popup('DIV_PUMOK_G', {
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
																						masterGrid.setItemData(record,false);
																					} else {
																						UniAppManager.app.onNewDataButtonDown();
																						masterGrid.setItemData(record,false);
																					}
																});
															},
														scope: this
														},
													'onClear': function(type) {
																	masterGrid.setItemData(null,true);
													}
										}
								})
			},
			{dataIndex: 'ITEM_NAME'					, width: 120,
			editor: Unilite.popup('DIV_PUMOK_G', {
			 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
		                    			autoPopup: true,
										listeners: {'onSelected': {
														fn: function(records, type) {
											                    console.log('records : ', records);
											                    Ext.each(records, function(record,i) {
																        			if(i==0) {
																						masterGrid.setItemData(record,false);
																        			} else {
																        				UniAppManager.app.onNewDataButtonDown();
																        				masterGrid.setItemData(record,false);
																        			}
																});
															},
														scope: this
														},
													'onClear': function(type) {
																	masterGrid.setItemData(null,true);
																}
															}
								})
			},
			{dataIndex: 'SPEC'						, width: 120},
            {dataIndex: 'LOT_NO'                    , width: 133,
                editor: Unilite.popup('LOTNO_G', {
                    textFieldName: 'LOTNO_CODE',
                    DBtextFieldName: 'LOTNO_CODE',
                    validateBlank: false,
		            autoPopup: true,
                    listeners: {
                    	applyextparam: function(popup){
                            var record = masterGrid.getSelectedRecord();
                            var divCode = panelSearch.getValue('DIV_CODE');
                            var itemCode = record.get('ITEM_CODE');
                            var itemName = record.get('ITEM_NAME');
                            var whCode = record.get('WH_CODE');
                            var whCellCode = record.get('WH_CELL_CODE');
                            var stockYN = 'Y'
                            popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode, 'S_WH_CELL_CODE': whCellCode, 'STOCK_YN': stockYN});
                        },
                    	'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                var rtnRecord;
                                Ext.each(records, function(record,i) {
                                    if(i==0){
                                        rtnRecord = masterGrid.uniOpt.currentRecord
                                    }else{
                                        rtnRecord = masterGrid.getSelectedRecord()
                                    }
                                    rtnRecord.set('LOT_NO',         record['LOT_NO']);
                                    rtnRecord.set('WH_CODE',        record['WH_CODE']);
                                    rtnRecord.set('WH_CELL_CODE',   record['WH_CELL_CODE']);
                                });
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            var rtnRecord = masterGrid.uniOpt.currentRecord;
                            rtnRecord.set('LOT_NO', '');
                        }
                    }
                })
            },
            {dataIndex: 'LOT_YN'                    , width: 90, hidden: false},
			{dataIndex: 'STOCK_UNIT'				, width: 66},
			{dataIndex: 'PATH_CODE'					, width: 113, hidden: true},
			{dataIndex: 'NOT_Q'						, width: 106, hidden: true},
			{dataIndex: 'INOUT_Q'					, width: 106},
			{dataIndex: 'ITEM_STATUS'				, width: 80},
			{dataIndex: 'ORIGINAL_Q'				, width: 93},
			{dataIndex: 'GOOD_STOCK_Q'				, width: 116},
			{dataIndex: 'BAD_STOCK_Q'				, width: 113},
			{dataIndex: 'BASIS_NUM'					, width: 116},
			{dataIndex: 'BASIS_SEQ'					, width: 33, hidden: true},
			{dataIndex: 'INOUT_TYPE'				, width: 33, hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'			, width: 33, hidden: true},
			{dataIndex: 'INOUT_DATE'				, width: 33, hidden: true},
			{dataIndex: 'INOUT_P'					, width: 33, hidden: true},
			{dataIndex: 'INOUT_I'					, width: 106, hidden: true},
			{dataIndex: 'MONEY_UNIT'				, width: 106, hidden: true},
			{dataIndex: 'INOUT_PRSN'				, width: 106, hidden: true},
			{dataIndex: 'ACCOUNT_Q'					, width: 106, hidden: true},
			{dataIndex: 'ACCOUNT_YNC'				, width: 106, hidden: true},
			{dataIndex: 'CREATE_LOC'				, width: 73},
			{dataIndex: 'ORDER_NUM'					, width: 116},
			{dataIndex: 'REMARK'					, width: 133},
			{dataIndex: 'PROJECT_NO'				, width: 133},
			{dataIndex: 'SALE_DIV_CODE'				, width: 66, hidden: true},
			{dataIndex: 'SALE_CUSTOM_CODE'			, width: 66, hidden: true},
			{dataIndex: 'BILL_TYPE'					, width: 66, hidden: true},
			{dataIndex: 'SALE_TYPE'					, width: 66, hidden: true},
			{dataIndex: 'COMP_CODE'					, width: 66, hidden: true},
			{dataIndex: 'OUTSTOCK_NUM'		        , width: 66, hidden: true},
			{dataIndex: 'REF_WKORD_NUM'		        , width: 66, hidden: true},
//			{dataIndex: 'ARRAY_OUTSTOCK_REQ_Q'		, width: 66, hidden: true},
//			{dataIndex: 'ARRAY_OUTSTOCK_Q'			, width: 66, hidden: true},
//			{dataIndex: 'ARRAY_REMARK'				, width: 66, hidden: true},
//			{dataIndex: 'ARRAY_PROJECT_NO'			, width: 66, hidden: true},
//			{dataIndex: 'ARRAY_LOT_NO'				, width: 66, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'			, width: 66, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'			, width: 66, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, 'LOT_NO')){
                    if(Ext.isEmpty(e.record.data.WH_CODE)){
                        alert('출고창고를 입력하십시오.');
                        return false;
                    }
                    if(BsaCodeInfo.gsSumTypeCell == 'Y' && Ext.isEmpty(e.record.data.WH_CELL_CODE)){
                        alert('출고창고 CELL코드를 입력하십시오.');
                        return false;
                    }
                    if(Ext.isEmpty(e.record.data.ITEM_CODE)){
                        alert(Msg.sMS003);
                        return false;
                    }
                }
				if(!e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL', 'INOUT_Q', 'WH_CODE', 'WH_CELL_CODE', 'LOT_NO',
                                                  'ITEM_STATUS', 'REMARK', 'PROJECT_NO']))
                    {
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    /*if(Ext.isEmpty(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME'])))
                    {
                        UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_NAME'])
                        return false;
                    }*/
                    if(UniUtils.indexOf(e.field, ['DIV_CODE', 'SPEC', 'STOCK_UNIT', 'GOOD_STOCK_Q', 'BAD_STOCK_Q',
                                                  'BASIS_NUM', 'CREATE_LOC']))
                    {
                        return false;
                    } else {
                        return true;
                    }
                }
			}
		},
		disabledLinkButtons: function(b) {
       		this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
       		this.down('#procTool').menu.down('#issueLinkBtn').setDisabled(b);
       		this.down('#procTool').menu.down('#saleLinkBtn').setDisabled(b);
		},
		setItemData: function(record, dataClear) {
       		var grdRecord = this.getSelectedRecord();
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'		, "");
       			grdRecord.set('ITEM_NAME'		, "");
				grdRecord.set('SPEC'			, "");
				grdRecord.set('STOCK_UNIT'		, "");
                grdRecord.set('LOT_NO'          , "");
                grdRecord.set('LOT_YN'          , "");
       		} else {
                grdRecord.set('ITEM_CODE'       , record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME'       , record['ITEM_NAME']);
                grdRecord.set('SPEC'            , record['SPEC']);
                grdRecord.set('STOCK_UNIT'      , record['STOCK_UNIT']);
                grdRecord.set('LOT_NO'          , record['LOT_NO']);
                grdRecord.set('LOT_YN'          , record['LOT_YN']);
            }
		}
	});//End of var masterGrid = Unilite.createGrid('mtr201ukrvGrid1', {

	var releaseNoMasterGrid = Unilite.createGrid('mtr201ukrvReleaseNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
        // title: '기본',
        layout : 'fit',
		store: releaseNoMasterStore,
		uniOpt:{
					expandLastColumn: false,
					useRowNumberer: false
		},
        columns:  [
					 { dataIndex: 'WH_CODE'     		    ,  width:120},
					 { dataIndex: 'WH_CELL_CODE'   	    	,  width:120,hidden:true},
					 { dataIndex: 'WH_CELL_NAME'   	    	,  width:120,hidden:true},
					 { dataIndex: 'INOUT_DATE'    		    ,  width:93},
					 { dataIndex: 'INOUT_CODE_TYPE'	    	,  width:120},
					 { dataIndex: 'INOUT_NAME'    		    ,  width:120},
					 { dataIndex: 'INOUT_PRSN' 		    	,  width:100},
					 { dataIndex: 'INOUT_NUM'     		    ,  width:120},
					 { dataIndex: 'DIV_CODE' 			    ,  width:86},
					 { dataIndex: 'LOT_NO' 			    	,  width:86},
					 { dataIndex: 'PROJECT_NO' 		    	,  width:86},
					 { dataIndex: 'ITEM_CODE' 			    ,  width:100},
					 { dataIndex: 'ITEM_NAME' 			    ,  width:133}
          ] ,
          listeners: {
	          onGridDblClick: function(grid, record, cellIndex, colName) {
		          	releaseNoMasterGrid.returnData(record);
		          	UniAppManager.app.onQueryButtonDown();
		          	SearchInfoWindow.hide();
	          }
          },
          returnData: function(record)	{
    			if(Ext.isEmpty(record))	{
    		      		record = this.getSelectedRecord();
    		    }
    	      	panelSearch.setValues({
    	      		'DIV_CODE':record.get('DIV_CODE'),
    	      		'INOUT_NUM':record.get('INOUT_NUM'),
    	      		'INOUT_CODE_TYPE':record.get('INOUT_CODE_TYPE'),
    	      		'WH_CODE':record.get('WH_CODE'),
    	      		'INOUT_DATE':record.get('INOUT_DATE')
              	});
          }
    });

    function openSearchInfoWindow() {			// 조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '출고번호검색',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [releaseNoSearch, releaseNoMasterGrid], //releaseNoDetailGrid],
                tbar:  ['->',
			        {
			        	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							releaseNoMasterStore.loadStoreRecords();
						},
						disabled: false
					}, {
						itemId : 'ReleaseNoCloseBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						releaseNoSearch.clearForm();
						releaseNoMasterGrid.reset();
					},
        			beforeclose: function( panel, eOpts )	{
						releaseNoSearch.clearForm();
						releaseNoMasterGrid.reset();
		 			},
        			show: function( panel, eOpts )	{
        			 	releaseNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
        			 	releaseNoSearch.setValue('INOUT_CODE_TYPE',panelSearch.getValue('INOUT_CODE_TYPE'));
       			 		releaseNoSearch.setValue('FR_INOUT_DATE',UniDate.get('startOfMonth', panelSearch.getValue('INOUT_DATE')));
       			 		releaseNoSearch.setValue('TO_INOUT_DATE',panelSearch.getValue('INOUT_DATE'));
                        releaseNoSearch.setValue('WH_CODE',panelSearch.getValue('WH_CODE'));
        		/*	 	releaseNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
			    		releaseNoSearch.setValue('ORDER_PRSN',panelSearch.getValue('ORDER_PRSN'));
			    		releaseNoSearch.setValue('CUSTOM_CODE',panelSearch.getValue('CUSTOM_CODE'));
			    		releaseNoSearch.setValue('CUSTOM_NAME',panelSearch.getValue('CUSTOM_NAME'));
			    		releaseNoSearch.setValue('ORDER_TYPE',panelSearch.getValue('ORDER_TYPE'));
			    		releaseNoSearch.setValue('FR_ORDER_DATE', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE')));
			    		releaseNoSearch.setValue('TO_ORDER_DATE',panelSearch.getValue('ORDER_DATE'));*/
        			 }
                }
			})
		}
		SearchInfoWindow.show();
		SearchInfoWindow.center();
    }

    function hiddenColumn(){

         	 if(panelResult.getValue('INOUT_CODE_TYPE') == '2') { //창고
                   masterGrid.getColumn('INOUT_NAME').setVisible(true);
                   masterGrid.getColumn('INOUT_NAME1').setVisible(false);
                   masterGrid.getColumn('INOUT_NAME2').setVisible(false);
                   masterGrid.getColumn('INOUT_NAME3').setVisible(false);

               } else if(panelResult.getValue('INOUT_CODE_TYPE') == '3'){//작업장
               	  masterGrid.getColumn('INOUT_NAME').setVisible(false);
                     masterGrid.getColumn('INOUT_NAME1').setVisible(true);
                     masterGrid.getColumn('INOUT_NAME2').setVisible(false);
                     masterGrid.getColumn('INOUT_NAME3').setVisible(false);

               } else if(panelResult.getValue('INOUT_CODE_TYPE') == '1'){ //부서
                   masterGrid.getColumn('INOUT_NAME').setVisible(false);
                   masterGrid.getColumn('INOUT_NAME1').setVisible(false);
                   masterGrid.getColumn('INOUT_NAME2').setVisible(true);
                   masterGrid.getColumn('INOUT_NAME3').setVisible(false);

               } else { //거래처
               	    masterGrid.getColumn('INOUT_NAME').setVisible(false);
                    masterGrid.getColumn('INOUT_NAME1').setVisible(false);
                    masterGrid.getColumn('INOUT_NAME2').setVisible(false);
                    masterGrid.getColumn('INOUT_NAME3').setVisible(true);
               }

    }

    Unilite.Main({
		borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                panelResult,masterGrid
            ]
        },
            panelSearch
        ],
		id: 'mtr201ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			if(panelSearch.setAllFieldsReadOnly(true) == false){
                return false;
            }
			if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
			var inoutNo = panelSearch.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow()
			} else {
				directMasterStore1.loadStoreRecords();
			};
/*
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ",viewLocked);
			console.log("viewNormal: ",viewNormal);
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	*/
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				 var inoutNum = panelSearch.getValue('INOUT_NUM');
				 var seq = directMasterStore1.max('INOUT_SEQ');
            	 if(!seq){
            	 	seq = 1;
            	 }else{
            	 	seq += 1;
            	 }
            	 var inoutType = '2';
            	 var inoutCodeType = panelSearch.getValue('INOUT_CODE_TYPE');
            	 var whCode = panelSearch.getValue('WH_CODE');
            	 var inoutDate = panelSearch.getValue('INOUT_DATE');
            	 var notQ = '0';
            	 var goodStockQ = '0';
            	 var badStockQ = '0';
            	 var inoutQ = '0';
            	 var inoutMeth = '2';
            	 var divCode = panelSearch.getValue('DIV_CODE');
            	 var createLoc = '2';
            	 var inoutPrsn = panelSearch.getValue('INOUT_PRSN');
            	 var itemStatus = '1';
            	 var originalQ = '0';
            	 var inoutTypeDetail = '10';	//gsInoutTypeDetail	??
            	 var whCellCode = '';
            	 /*if(BsaCodeInfo.gsSumTypeCell == 'Y'){
            	 	whCellCode = panelSearch.getValue('WH_CELL_CODE');
            	 }*/
            	 var saleDivCode = '*';
            	 var saleCustomCode = '*';
            	 var saleType = '*';
            	 var billType = '*';
            	 var compCode = UserInfo.compCode;

            	 var r = {
            	    INOUT_NUM: inoutNum,
					INOUT_SEQ: seq,
					INOUT_TYPE: inoutType,
					INOUT_CODE_TYPE: inoutCodeType,
					WH_CODE: whCode,
					INOUT_DATE: inoutDate,
					NOT_Q: notQ,
					GOOD_STOCK_Q: goodStockQ,
					BAD_STOCK_Q: badStockQ,
					INOUT_Q: inoutQ,
					INOUT_METH: inoutMeth,
					DIV_CODE: divCode,
					CREATE_LOC: createLoc,
					INOUT_PRSN: inoutPrsn,
					ITEM_STATUS: itemStatus,
					ORIGINAL_Q: originalQ,
					INOUT_TYPE_DETAIL: inoutTypeDetail,
					WH_CELL_CODE: whCellCode,
					SALE_DIV_CODE: saleDivCode,
            	 	SALE_CUSTOM_CODE: saleCustomCode,
            	 	SALE_TYPE: saleType,
            		BILL_TYPE: billType,
            		COMP_CODE:compCode
		        };
		        cbStore.loadStoreRecords(whCode);
                masterGrid.createRow(r);
				panelSearch.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			},
		onResetButtonDown: function() {
			panelSearch.clearForm();
            panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			this.fnInitBinding();
		},

		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
		},

		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();

			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('ACCOUNT_Q') != 0)
				{
					alert('<t:message code="unilite.msg.sMM008"/>');
				}else{
					masterGrid.deleteSelectedRow();
				}
			}
		},
        checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
        },
        setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.setValue('INOUT_DATE',UniDate.get('today'));
        	panelResult.setValue('INOUT_DATE',UniDate.get('today'));

            panelSearch.getField('INOUT_CODE_TYPE').setReadOnly(false);
            panelResult.getField('INOUT_CODE_TYPE').setReadOnly(false);
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		},
        fnWorkShopChange: function(records) {
            grdRecord = masterGrid.getSelectedRecord();
            record = records[0];
            grdRecord.set('INOUT_CODE', record.TREE_CODE);
            grdRecord.set('INOUT_NAME1', record.TREE_NAME);
            if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
                grdRecord.set('DIV_CODE', record.TYPE_LEVEL);
            }
        }

	});//End of Unilite.Main( {

	Unilite.createValidator('validator01', {
	store: directMasterStore1,
	grid: masterGrid,
	validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
	console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
		var rv = true;
		switch(fieldName) {
			case "INOUT_SEQ":
				if(newValue <= '0'){
					rv='<t:message code="unilite.msg.sMB076"/>';
				}else if(clng(grdsheet1.TextMatrix(lRow,lCol)) != fnCDbl(grdsheet1.TextMatrix(lRow,lCol))){ //?
					rv='<t:message code="unilite.msg.sMB087"/>';
				}

            case "WH_CODE" :
                if(!Ext.isEmpty(newValue)){
                    record.set('WH_CODE', e.column.field.getRawValue());
                    record.set('WH_CELL_CODE', "");
                    record.set('WH_CELL_NAME', "");
                    record.set('LOT_NO', "");
                }else{
                    record.set('WH_CODE', "");
                    record.set('WH_CELL_CODE', "");
                    record.set('WH_CELL_NAME', "");
                    record.set('LOT_NO', "");
                }
                if(!Ext.isEmpty(record.get('ITEM_CODE'))){
                    UniSales.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('DIV_CODE'), record.get('ITEM_STATUS'), record.get('ITEM_CODE'),  newValue);

                }
                //그리드 창고cell콤보 reLoad..
                cbStore.loadStoreRecords(newValue);
                UniAppManager.setToolbarButtons('save', true);
                break;

            case "WH_CELL_CODE" :
                record.set('WH_CELL_CODE', e.column.field.getRawValue());
                break;

				//추가

				if(record.get('CREATE_LOC') != '3'){
					if(newValue > 0 && record.get('BASIS_NUM') > ''){	// ''보다 크면??
						if(record.get('INOUT_Q') > (record.get('ORIGINAL_Q') + record.get('NOT_Q'))){
							rv='<t:message code="unilite.msg.sMM337"/>';
						}
					}
				}
				//추가

/*			case "PROJECT_NO":
				UniAppManager.app.fnPlanNumChange();	//함수생성해야함

			case "LOT_NO":
				//소스분석안됨
			case "ORDER_NUM":
				UniAppManager.app.fnWkPlanChange();		//함수생성해야함
*/
            case "INOUT_NAME" :
                if(!Ext.isEmpty(newValue)){
                    record.set('INOUT_CODE', newValue);
                 }else{
                    record.set('INOUT_CODE', "");
                 }

                break;
		}
			return rv;
					}
		});
};
</script>