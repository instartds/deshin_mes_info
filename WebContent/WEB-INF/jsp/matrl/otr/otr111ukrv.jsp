<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="otr111ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> 	<!-- 출고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M104" /> 	<!--출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="B022" /> 	<!--재고상태관리-->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>		<!--창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" /><!--창고Cell-->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

var SearchInfoWindow; // 검색창
var ReservationWindow; // 예약참조
var ReturnReservationWindow; // 반품가능예약참조

var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	//gsInvstatus: 		'${gsInvstatus}',
	gsSumTypeLot:		'${gsSumTypeLot}',     //'Y'
	gsSumTypeCell:		'${gsSumTypeCell}',    //'N'
	gsBaseWhCode:    	'${gsBaseWhCode}',     //B095코드가 없음.
	gsBaseWhCodeCell:	'${gsBaseWhCodeCell}', //B095코드가 없음.
	gsDefaultMoney:     '${gsDefaultMoney}',    //'KRW'
	gsLotNoInputMethod: '${gsLotNoInputMethod}',
	gsLotNoEssential:   '${gsLotNoEssential}',
	gsEssItemAccount:   '${gsEssItemAccount}',
    gsUsePabStockYn:   '${gsUsePabStockYn}'
};

var outDivCode = UserInfo.divCode;

var usePabStockYn = true; //가용재고 컬럼 사용여부
if(BsaCodeInfo.gsUsePabStockYn =='Y') {
    usePabStockYn = false;
}
var output =''; 	// 출고내역 셋팅 값 확인 alert
for(var key in BsaCodeInfo){
	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
//alert(output);

function appMain() {
	var sumtypeCell = BsaCodeInfo.gsSumTypeCell =='Y'?false:true;	//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
    var lotNoEssential = BsaCodeInfo.gsLotNoEssential == "Y"?true:false;
    var lotNoInputMethod = BsaCodeInfo.gsLotNoInputMethod == "Y"?true:false;

    //창고에 따른 창고cell 콤보load..
//    var cbStore = Unilite.createStore('hat510ukrsComboStoreGrid',{
//        autoLoad: false,
//        uniOpt: {
//            isMaster: false         // 상위 버튼 연결
//        },
//        fields: [
//                {name: 'SUB_CODE', type : 'string'},
//                {name: 'CODE_NAME', type : 'string'}
//                ],
//        proxy: {
//            type: 'direct',
//            api: {
//                read: 'salesCommonService.fnRecordCombo'
//            }
//        },
//        loadStoreRecords: function(whCode) {
//            var param= masterForm.getValues();
//            param.COMP_CODE= UserInfo.compCode;
////            param.DIV_CODE = UserInfo.divCode;
//            param.WH_CODE = whCode;
//            param.TYPE = 'BSA225T';
//            console.log( param );
//            this.load({
//                params: param
//            });
//        }
//    });


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read    : 'otr111ukrvService.selectMaster',
			update  : 'otr111ukrvService.updateDetail',
			create  : 'otr111ukrvService.insertDetail',
			destroy : 'otr111ukrvService.deleteDetail',
			syncAll : 'otr111ukrvService.saveAll'
		}
	});

	function setAllFieldsReadOnly(b){
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
				}else{
					var fields = this.getForm().getFields();
				    Ext.each(fields.items, function(item) {
				    	if(Ext.isDefined(item.holdable) )	{
				    	 	if (item.holdable == 'hold') {
				    			item.setReadOnly(true);
				    		}
				    	}
				    	if(item.isPopupField)	{
				    		var popupFC = item.up('uniPopupField')	;
				    		if(popupFC.holdable == 'hold') {
				    			popupFC.setReadOnly(true);
				    		}
				    	}
				    });
				}
	  		} else {
				this.unmask();
			}
			return r;
	}

    var searchForm = Unilite.createSearchForm('otr111ukrvSearchForm', {	// 메인
		title   : '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        region  : 'north',
        layout  : {type : 'uniTable', columns : 3},
		padding : '1 1 1 1',
		border  : true,
		items: [
		    //营业区
		    {
				fieldLabel : '<t:message code="system.label.purchase.division" default="사업장"/>',
				name       : 'DIV_CODE',
				xtype      : 'uniCombobox',
				comboType  : 'BOR120',
				holdable   : 'hold',
				allowBlank : false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},
			//外包单位
		    Unilite.popup('AGENT_CUST',{
		    	fieldLabel     : '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
		    	valueFieldName : 'CUSTOM_CODE',
		    	textFieldName  : 'CUSTOM_NAME',
		    	textFieldWidth : 170,
		    	holdable       : 'hold',
		    	allowBlank     : false,
		    	listeners: {
		    	    onSelected: {
					    fn: function(records, type) {
				    		masterForm.setValue('CUSTOM_CODE', searchForm.getValue('CUSTOM_CODE'));
				    		masterForm.setValue('CUSTOM_NAME', searchForm.getValue('CUSTOM_NAME'));
				    	},
				    	scope: this
				    },
				    onClear: function(type)	{
				    	masterForm.setValue('CUSTOM_CODE', '');
				    	masterForm.setValue('CUSTOM_NAME', '');
				    }
		        }
		    }),
		    //出库日期
			{
				fieldLabel : '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
				name       : 'INOUT_DATE',
				xtype      : 'uniDatefield',
				value      : new Date(),
				holdable   : 'hold',
				allowBlank : false,
				listeners: {
		    	    change: function(field, newValue, oldValue, eOpts) {
		    	    	masterForm.setValue('INOUT_DATE', newValue);
		    	    }
		        }
			},
			//出库编号
			{
    			fieldLabel : '<t:message code="system.label.purchase.issueno" default="출고번호"/>',
    			name       : 'INOUT_NUM',
    			xtype      : 'uniTextfield',
    			readOnly   : true,
    			listeners: {
		    	    change: function(field, newValue, oldValue, eOpts) {
		    	    	masterForm.setValue('INOUT_NUM', newValue);
		    	    }
		        }
    		},
    		//出库主管
    		{
				fieldLabel : '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
				name       : 'INOUT_PRSN',
				xtype      : 'uniCombobox',
				holdable   : 'hold',
				comboType  : 'AU',
				comboCode  : 'B024',
				listeners: {
		    	    change: function(field, newValue, oldValue, eOpts) {
		    	    	masterForm.setValue('INOUT_PRSN', newValue);
		    	    }
		        }
			},{
		    	xtype   : 'container',
		    	padding : '0 0 0 0',
		    	layout: {
		    		type  : 'hbox',
					align : 'center',
					pack  :'center'
		    	},
		    	items:[{
		    		xtype : 'button',
		    		text  : '전표출력', //凭证输出,
		    		hidden: true
		    	}]
		},{
            fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
            name: 'WH_CODE',
            xtype:'uniCombobox',
            store: Ext.data.StoreManager.lookup('whList'),
            child: 'WH_CELL_CODE',
            holdable: 'hold',
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    masterForm.setValue('WH_CODE', newValue);
                }
            }
        },{
            fieldLabel: '출고창고Cell',
            name: 'WH_CELL_CODE',
            xtype:'uniCombobox',
            store: Ext.data.StoreManager.lookup('whCellList'),
            holdable: 'hold',
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    masterForm.setValue('WH_CELL_CODE', newValue);
                }
            }
        }],
		setAllFieldsReadOnly: setAllFieldsReadOnly
	});

	var masterForm = Unilite.createSearchPanel('otr111ukrvMasterForm', {	// 메인
		title       : '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType : 'uniSearchSubPanel',
        collapsed   : true,
        listeners: {
	        collapse: function () {
	        	searchForm.show();
	        },
	        expand: function() {
	        	searchForm.hide();
	        }
	    },
		items: [{
			title  : '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
   			itemId : 'search_panel1',
           	layout : {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items  : [
		    //营业区
		    {
				fieldLabel : '<t:message code="system.label.purchase.division" default="사업장"/>',
				name       : 'DIV_CODE',
				xtype      : 'uniCombobox',
				comboType  : 'BOR120',
				holdable   : 'hold',
				allowBlank : false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						searchForm.setValue('DIV_CODE', newValue);
					}
				}

			},
			//外包单位
		    Unilite.popup('AGENT_CUST',{
		    	fieldLabel     : '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
		    	valueFieldName : 'CUSTOM_CODE',
		    	textFieldName  : 'CUSTOM_NAME',
		    	textFieldWidth : 170,
		    	holdable       : 'hold',
		    	allowBlank     : false,
		    	listeners: {
		    	    onSelected: {
					    fn: function(records, type) {
				    		searchForm.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
				    		searchForm.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
				    	},
				    	scope: this
				    },
				    onClear: function(type)	{
				    	searchForm.setValue('CUSTOM_CODE', '');
				    	searchForm.setValue('CUSTOM_NAME', '');
				    }
		        }
		    }),
		    //出库日期
			{
				fieldLabel : '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
				name       : 'INOUT_DATE',
				xtype      : 'uniDatefield',
				value      : new Date(),
				holdable   : 'hold',
				allowBlank : false,
				listeners: {
		    	    change : function(field, newValue, oldValue, eOpts) {
		    	   	    searchForm.setValue('INOUT_DATE', newValue);
		    	    }
		        }
			},
			//出库编号
			{
    			fieldLabel : '<t:message code="system.label.purchase.issueno" default="출고번호"/>',
    			name       : 'INOUT_NUM',
    			xtype      : 'uniTextfield',
    			readOnly   : true,
    			listeners: {
		    	    change : function(field, newValue, oldValue, eOpts) {
		    	   	    searchForm.setValue('INOUT_NUM', newValue);
		    	    }
		        }
    		},
    		//出库主管
    		{
				fieldLabel : '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
				name       : 'INOUT_PRSN',
				xtype      : 'uniCombobox',
				holdable   : 'hold',
				comboType  : 'AU',
				comboCode  : 'B024',
				listeners: {
		    	    change : function(field, newValue, oldValue, eOpts) {
		    	   	    searchForm.setValue('INOUT_PRSN', newValue);
		    	    }
		        }
			},{
    			xtype  : 'component',
    			autoEl : {
        			html: '<hr width="350px">'
    			}
			},{
		    	xtype   : 'container',
		    	padding : '10 0 0 0',
		    	layout: {
		    		type  : 'hbox',
					align : 'center',
					pack  : 'center'
		    	},
		    	items:[
		    	{
		    		xtype : 'button',
		    		text  : '전표출력',//凭证输出
		    		hidde: true
		    	}]
		    },{
                fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
                name: 'WH_CODE',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('whList'),
                child: 'WH_CELL_CODE',
                holdable: 'hold',
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                    	searchForm.setValue('WH_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '출고창고Cell',
                name: 'WH_CELL_CODE',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('whCellList'),
                holdable: 'hold',
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                    	searchForm.setValue('WH_CELL_CODE', newValue);
                    }
                }
            }]
		}],
		setAllFieldsReadOnly: setAllFieldsReadOnly
	});

	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {	// 검색 팝업창
		layout: {type: 'uniTable', columns : 2},
	    trackResetOnLoad: true,
	    items: [
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
				textFieldWidth: 170
			}),{
				fieldLabel: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false
			},{
 				fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
 				name:'WH_CODE',
 				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
 			},{
				fieldLabel: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
				name:'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024'
			}
		],
		setAllFieldsReadOnly: setAllFieldsReadOnly
    });

    /**
     * 预约参考
     */
    var otherorderSearch = Unilite.createSearchForm('otherorderForm', {		//예약참조
            layout :  {type : 'uniTable', columns : 3},
            items :[
            	{
					fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_INOUT_DATE',
					endFieldName: 'TO_INOUT_DATE',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today')
				},{
					xtype: 'radiogroup',
					fieldLabel: '외주발주마감',
					id: 'rdoSelect',
					NAME: 'CLOSING_YN',
					items: [{
						boxLabel: '포함',
						width:  60,
						name: 'CLOSING_YN',
						inputValue: 'A',
						checked: true
					},{
						boxLabel: '미포함',
						width :60,
						name: 'CLOSING_YN',
						inputValue: 'Y'
					}]
				},{
				    xtype: 'uniTextfield',
				    name: 'SPEC',
				    fieldLabel: '<t:message code="system.label.purchase.spec" default="규격"/>'
				},
				Unilite.popup('IDIV_PUMOK',{
					fieldLabel: '발주품목',
					validateBlank: false,
					textFieldName: 'ORDER_ITEM_NAME',
                    valueFieldName: 'ORDER_ITEM_CODE'
				}),
				Unilite.popup('IDIV_PUMOK',{
					fieldLabel: '예약품목',
					textFieldWidth: 170,
					validateBlank: false,
					textFieldName: 'ITEM_NAME',
                    valueFieldName: 'ITEM_CODE'
				}),{
					fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
					xtype: 'uniTextfield',
					name: 'CUSTOM_CODE',
					hidden: true
				},{
					fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
					xtype: 'uniTextfield',
					name: 'DIV_CODE',
					hidden: true
				}
			]
    });

    /**
     * 可退货预约参考
     */
    var otherorderSearch2 = Unilite.createSearchForm('otherorderForm2', {		//반품가능예약참조
            layout :  {type : 'uniTable', columns : 2},
            items : [
            	{
					fieldLabel     : '<t:message code="system.label.purchase.podate" default="발주일"/>',
					xtype          : 'uniDateRangefield',
					startFieldName : 'FR_ORDER_DATE',
					endFieldName   : 'TO_ORDER_DATE',
					startDate      : UniDate.get('startOfMonth'),
					endDate        : UniDate.get('today'),
					width          : 315
				},{
				    fieldLabel : '<t:message code="system.label.purchase.division" default="사업장"/>',
				    name       : 'DIV_CODE',
				    xtype      : 'uniTextfield',
				    hidden     : true,
				    readOnly   : true
				},{
				    fieldLabel : '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
				    name       : 'CUSTOM_CODE',
				    xtype      : 'uniTextfield',
				    hidden     : true,
				    readOnly   : true
				}
			]
    });

	Unilite.defineModel('Otr111ukrvModel', {		// 메인
	    fields: [
	    	{name: 'INOUT_NUM'			         ,text: '<t:message code="system.label.purchase.tranno" default="수불번호"/>' 		,type: 'string'},
	    	{name: 'INOUT_SEQ'			         ,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 			,type: 'int',maxLength:3},
	    	{name: 'INOUT_TYPE'			         ,text: '<t:message code="system.label.purchase.type" default="타입"/>' 			,type: 'string', defaultValue: '2'},
	    	{name: 'INOUT_METH'			         ,text: '<t:message code="system.label.purchase.method" default="방법"/>' 			,type: 'string'},
	    	{name: 'INOUT_TYPE_DETAIL'			 ,text: '<t:message code="system.label.purchase.issuetype" default="출고유형"/>'      ,type: 'string', comboType: 'AU', comboCode: 'M104', defaultValue: "10", allowBlank: false}, ////defaultValue:콤보의 첫번쨰Value로 해야함
	    	{name: 'INOUT_CODE_TYPE'	         ,text: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>' 	,type: 'string'},
	    	{name: 'INOUT_CODE'			         ,text: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>' 		,type: 'string'},
	    	{name: 'INOUT_NAME'			         ,text: '<t:message code="system.label.purchase.subcontractorname" default="외주처명"/>' 		,type: 'string'},
	    	{name: 'ITEM_CODE'			         ,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>' 		,type: 'string', allowBlank: false},
	    	{name: 'ITEM_NAME'			         ,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>' 		,type: 'string', allowBlank: false},
	    	{name: 'SPEC'				         ,text: '<t:message code="system.label.purchase.spec" default="규격"/>' 			,type: 'string'},
	    	{name: 'STOCK_UNIT'			         ,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>' 		,type: 'string'},
	    	// 출고창고 WH_CODE / WH_NAME 조회할때 CODE로 하면 출고창고 값 출력, NAME으로 하면 출고창고 값이 안나옴.
	    	{name: 'WH_CODE'			         ,text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>' 		,type: 'string', store: Ext.data.StoreManager.lookup('whList'), child: 'WH_CELL_CODE', allowBlank: false},
	    	{name: 'WH_NAME'                   	 ,text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>' 		,type: 'string'},
	    	// 출고창고 WH_CODE / WH_NAME 조회할때 CODE로 하면 출고창고 값 출력, NAME으로 하면 출고창고 값이 안나옴.
	    	{name: 'WH_CELL_CODE'                , text:'출고창고 Cell'          , type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','DIV_CODE']},
	    	{name: 'WH_CELL_NAME'		         ,text: '출고창고Cell' 	,type: 'string',maxLength:20},
	    	{name: 'ALLOC_Q'			         ,text: '<t:message code="system.label.purchase.allocationqty" default="예약량"/>' 		,type: 'uniQty'},
	    	{name: 'NOT_OUTSTOCK_Q'		         ,text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>' 		,type: 'uniQty'},
	    	{name: 'INOUT_Q'			         ,text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>' 		,type: 'uniQty', allowBlank: false},
	    	{name: 'ITEM_STATUS'		         ,text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>' 		,type: 'string', comboType: 'AU', comboCode: 'B021'},
	    	{name: 'ORIGINAL_Q'			         ,text: '<t:message code="system.label.purchase.existingoutqty" default="기존출고량"/>' 	,type: 'uniQty'},
	    	{name: 'PAB_STOCK_Q'                 , text: '<t:message code="system.label.purchase.availableinventoryqty" default="가용재고량"/>'   , type: 'uniQty'},
	    	{name: 'GOOD_STOCK_Q'		         ,text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>' 		,type: 'uniQty'},
	    	{name: 'BAD_STOCK_Q'		         ,text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>' 		,type: 'uniQty'},
	    	{name: 'INOUT_DATE'			         ,text: '<t:message code="system.label.purchase.issuedate" default="출고일"/>' 		,type: 'uniDate'},
	    	{name: 'COMP_CODE'			         ,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>' 		,type: 'string'},
	    	{name: 'DIV_CODE'			         ,text: '<t:message code="system.label.purchase.division" default="사업장"/>' 		,type: 'string', child: 'WH_CODE'},
	    	{name: 'INOUT_P'			         ,text: '<t:message code="system.label.purchase.tranprice" default="수불단가"/>' 		,type: 'uniUnitPrice'},
	    	{name: 'INOUT_I'			         ,text: '<t:message code="system.label.purchase.localamount" default="원화금액"/>' 		,type: 'uniPrice'},
	    	{name: 'EXPENSE_I'			         ,text: '<t:message code="system.label.purchase.expenseamount" default="경비금액"/>' 		,type: 'uniPrice'},
	    	{name: 'MONEY_UNIT'			         ,text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>' 		,type: 'string'},
	    	{name: 'INOUT_FOR_P'		         ,text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>' 		,type: 'uniUnitPrice'},
	    	{name: 'INOUT_FOR_O'		         ,text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>' 		,type: 'uniFC'},
	    	{name: 'EXCHG_RATE_O'		         ,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>' 			,type: 'uniER'},
	    	{name: 'ORDER_TYPE'			         ,text: '<t:message code="system.label.purchase.potype" default="발주형태"/>' 		,type: 'string'},
	    	{name: 'ORDER_NUM'			         ,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>' 		,type: 'string'},
	    	{name: 'ORDER_SEQ'			         ,text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>' 		,type: 'int'},
	    	{name: 'LC_NUM'				         ,text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>' 		,type: 'string'},
	    	{name: 'BL_NUM'				         ,text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>' 		,type: 'string'},
	    	{name: 'INOUT_PRSN'			         ,text: '<t:message code="system.label.purchase.trancharge" default="수불담당"/>' 		,type: 'string',comboType: 'AU', comboCode: 'B024'},
	    	{name: 'BASIS_NUM'			         ,text: '<t:message code="system.label.purchase.basisno" default="근거번호"/>' 		,type: 'string'},
	    	{name: 'BASIS_SEQ'			         ,text: '<t:message code="system.label.purchase.basisseq" default="근거순번"/>' 		,type: 'string'},
	    	{name: 'ACCOUNT_YNC'		         ,text: '<t:message code="system.label.purchase.billobject" default="계산서대상"/>' 	,type: 'string'},
	    	{name: 'ACCOUNT_Q'			         ,text: '<t:message code="system.label.purchase.billqty" default="계산서량"/>' 		,type: 'uniQty'},
	    	{name: 'CREATE_LOC'			         ,text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>' 		,type: 'string'},
	    	{name: 'SALE_C_YN'			         ,text: '<t:message code="system.label.purchase.notbillingclosingyn" default="미매출마감여부"/>',type: 'string'},
	    	{name: 'SALE_C_DATE'		         ,text: '<t:message code="system.label.purchase.notbillingclosingdate" default="미매출마감일자"/>',type: 'uniDate'},
	    	{name: 'SALE_C_REMARK'		         ,text: '<t:message code="system.label.purchase.notbillingclosingreason" default="미매출마감사유"/>',type: 'string'},
	    	{name: 'GRANT_TYPE'		         	 ,text: 'GRANT_TYPE' 	,type: 'string'},
	    	{name: 'REMARK'				         ,text: '<t:message code="system.label.purchase.remarks" default="비고"/>' 			,type: 'string',maxLength:200},
	    	{name: 'PROJECT_NO'  		         ,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>' 		,type: 'string',maxLength:20},
	    	{name: 'SALE_DIV_CODE'               ,text: '<t:message code="system.label.purchase.salesdivision" default="매출사업장"/>' 	,type: 'string'},
	    	{name: 'SALE_CUSTOM_CODE'            ,text: '<t:message code="system.label.purchase.salesplace" default="매출처"/>' 		,type: 'string'},
	    	{name: 'BILL_TYPE'                   ,text: '<t:message code="system.label.purchase.salestype" default="매출유형"/>' 		,type: 'string'},
	    	{name: 'SALE_TYPE'                   ,text: '<t:message code="system.label.purchase.salesclass" default="매출구분"/>' 		,type: 'string'},
	    	{name: 'UPDATE_DB_USER'              ,text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>' 		,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'              ,text: '수정한 날짜' 	,type: 'uniDate'},
	    	{name: 'ITEM_ACCOUNT'                ,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>' 		,type: 'string'},
	    	{name: 'STOCK_CARE_YN'               ,text: '재고관리여부' 	,type: 'string'},
	    	{name: 'LOT_NO'  			         ,text: 'LOT NO' 		,type: 'string', allowBlank:lotNoInputMethod || !lotNoEssential},
        {name: 'LOT_YN'                      ,text: 'LOT관리여부'   ,type: 'string'},

        {name: 'ORDER_ITEM_CODE'                      ,text: '외주오더품목'   ,type: 'string'},
        {name: 'ORDER_ITEM_NAME'                      ,text: '외주오더품명'   ,type: 'string'},
        {name: 'S_GUBUN_KD'                      ,text: '오더차수'   ,type: 'string'}
		]
	});

	Unilite.defineModel('orderNoMasterModel', {		// 검색조회창
	    fields: [
	    	{name: 'INOUT_DATE'			, text: '<t:message code="system.label.purchase.issuedate" default="출고일"/>'			, type: 'string'},
	    	{name: 'INOUT_CODE'			, text: '<t:message code="system.label.purchase.subcontractorcode" default="외주처코드"/>'		, type: 'string'},
	    	{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.subcontractorname" default="외주처명"/>'			, type: 'string'},
	    	{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>'			, type: 'string'},
	    	{name: 'INOUT_PRSN'			, text: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>'			, type: 'string',comboType: 'AU', comboCode: 'B024'},
	    	{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.issueno" default="출고번호"/>'			, type: 'string'},
	    	{name: 'LOT_NO'				, text: 'LOT_NO'		    , type: 'string'}
		]
	});

	Unilite.defineModel('Otr111ukrvOTHERModel', {	//예약참조
	    fields: [
	    	{name: 'ORDER_NUM'		 	    	, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'    		, type: 'string'},
	    	{name: 'ORDER_DATE'			    	, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'    		, type: 'uniDate'},
	    	{name: 'ITEM_CODE'		 	    	, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'    		, type: 'string'},
	    	{name: 'ITEM_NAME'		 	    	, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'    		, type: 'string'},
	    	{name: 'SPEC'					    , text: '<t:message code="system.label.purchase.spec" default="규격"/>'    		, type: 'string'},
	    	{name: 'ALLOC_Q'				    , text: '<t:message code="system.label.purchase.allocationqty" default="예약량"/>'    		, type: 'uniQty'},
	    	{name: 'OUTSTOCK_Q'			    	, text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'    		, type: 'uniQty'},
	    	{name: 'NOT_OUTSTOCK'			    , text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>'    		, type: 'uniQty'},
	    	{name: 'AVERAGE_P'				    , text: '<t:message code="system.label.purchase.price" default="단가"/>'    		, type: 'uniUnitPrice'},
	    	{name: 'STOCK_UNIT'			    	, text: '<t:message code="system.label.purchase.unit" default="단위"/>'    		, type: 'string'},
	    	{name: 'WH_CODE'				    , text: '<t:message code="system.label.purchase.mainwarehouse" default="주창고"/>'    		, type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'STOCK_Q'				    , text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'    		, type: 'uniQty'},
	    	{name: 'CUSTOM_CODE'			    , text: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>'    		, type: 'string'},
	    	{name: 'CUSTOM_NAME'			    , text: '<t:message code="system.label.purchase.subcontractorname" default="외주처명"/>'    		, type: 'string'},
	    	{name: 'MONEY_UNIT'			    	, text: '회폐'    		, type: 'string'},
	    	{name: 'COMP_CODE'				    , text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'    		, type: 'string'},
	    	{name: 'DIV_CODE'				    , text: '<t:message code="system.label.purchase.division" default="사업장"/>'    		, type: 'string'},
	    	{name: 'GRANT_TYPE'			    	, text: '사급구분'    		, type: 'string'},
	    	{name: 'REMARK'				    	, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'    		, type: 'string'},
	    	{name: 'PROJECT_NO'			    	, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'    		, type: 'string'},
	    	{name: 'STOCK_CARE_YN'  	    	, text: '재고관리여부'    	, type: 'string'},
	    	{name: 'LOT_YN'                      ,text: 'LOT관리여부'   ,type: 'string'},
	    	{name: 'S_GUBUN_KD'                      ,text: '오더차수'   ,type: 'string'}
		]
	});

	Unilite.defineModel('Otr111ukrvOTHERModel2', {	//반품가능예약참조
	    fields: [
	    	{name: 'ORDER_NUM'		 			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'    		, type: 'string'},
	    	{name: 'ORDER_SEQ'		 			, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'    		, type: 'string'},
	    	{name: 'ORDER_DATE'					, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'    		, type: 'uniDate'},
	    	{name: 'ORDER_ITEM_CODE'			, text: '<t:message code="system.label.purchase.poitemcode" default="발주품목코드"/>'    	, type: 'string'},
	    	{name: 'ORDER_ITEM_NAME'			, text: '<t:message code="system.label.purchase.poitemname" default="발주품목명"/>'    	, type: 'string'},
	    	{name: 'ITEM_CODE'		 			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'    		, type: 'string'},
	    	{name: 'ITEM_NAME'		 			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'    		, type: 'string'},
	    	{name: 'SPEC'						, text: '<t:message code="system.label.purchase.spec" default="규격"/>'    		, type: 'string'},
	    	{name: 'WH_CODE'					, text: '<t:message code="system.label.purchase.mainwarehouse" default="주창고"/>'    		, type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'ALLOC_Q'					, text: '<t:message code="system.label.purchase.allocationqty" default="예약량"/>'    		, type: 'uniQty'},
	    	{name: 'NOTOUTSTOCK_Q'				, text: '<t:message code="system.label.purchase.returnavaiableqty" default="반품가능량"/>'    	, type: 'uniQty'},
	    	{name: 'OUTSTOCK_Q'					, text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'    		, type: 'uniQty'},
	    	{name: 'NOT_OUTSTOCK'				, text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>'    		, type: 'uniQty'},
	    	{name: 'AVERAGE_P'					, text: '<t:message code="system.label.purchase.price" default="단가"/>'    		, type: 'uniUnitPrice'},
	    	{name: 'STOCK_UNIT'					, text: '<t:message code="system.label.purchase.unit" default="단위"/>'    		, type: 'string'},
	    	{name: 'STOCK_Q'					, text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'    		, type: 'uniQty'},
	    	{name: 'CUSTOM_CODE'				, text: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>'    		, type: 'string'},
	    	{name: 'CUSTOM_NAME'				, text: '<t:message code="system.label.purchase.subcontractorname" default="외주처명"/>'    		, type: 'string'},
	    	{name: 'MONEY_UNIT'					, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'    		, type: 'string'},
	    	{name: 'COMP_CODE'					, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'    		, type: 'string'},
	    	{name: 'DIV_CODE'					, text: '<t:message code="system.label.purchase.division" default="사업장"/>'    		, type: 'string'},
	    	{name: 'GRANT_TYPE'					, text: '사급구분'    		, type: 'string'},
	    	{name: 'REMARK'						, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'    		, type: 'string'},
	    	{name: 'PROJECT_NO'					, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'    		, type: 'string'},
	    	{name: 'STOCK_CARE_YN'  			, text: '재고관리여부'    	, type: 'string'},
	    	{name: 'LOT_YN'                      ,text: 'LOT관리여부'   ,type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('Otr111ukrvMasterStore1',{		// 메인
		model: 'Otr111ukrvModel',
		uniOpt: {
           	isMaster: true,		// 상위 버튼 연결
           	editable: true,		// 수정 모드 사용
           	deletable: true,	// 삭제 가능 여부
           	allDeletable: true,     // 전체 삭제 가능 여부
	        useNavi : false		// prev | newxt 버튼 사용
        },
        autoLoad: false,
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
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
       		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
            var isErr = false;
            Ext.each(list, function(record, index) {
            	if(BsaCodeInfo.gsUsePabStockYn == "Y" && record.get('INOUT_Q') > record.get('PAB_STOCK_Q') + record.get('ORIGINAL_Q')){
                    alert('출고량은 가용재고량을 초과할 수 없습니다.');
                    isErr = true;
                    return false;
                }
                if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
                    alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + 'LOT NO: 필수 입력값 입니다.');
                    isErr = true;
                    return false;
                }
            });
            if(isErr) return false;

			var inoutNum = masterForm.getValue('INOUT_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['INOUT_NUM'] != inoutNum) {
					record.set('INOUT_NUM', inoutNum);
				}
			})
			//console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var result = batch.operations[0].getResultSet();
						masterForm.setValue("INOUT_NUM", result["INOUT_NUM"]);
						searchForm.setValue("INOUT_NUM", result["INOUT_NUM"]);
						masterForm.getForm().wasDirty = false;
						searchForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						searchForm.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.app.onQueryButtonDown();
						if(directMasterStore1.getCount() == 0){
                            UniAppManager.app.onResetButtonDown();
                        }
					 }
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('otr111ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	// 검색버튼 조회창
			model: 'orderNoMasterModel',
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
                	read: 'otr111ukrvService.selectDetail'
                }
            },
            loadStoreRecords : function()	{
				var param= orderNoSearch.getValues();
				this.load({
					params : param
				});
			}
	});

	var otherOrderStore = Unilite.createStore('otr111ukrvOtherOrderStore', {	//예약참조
			model: 'Otr111ukrvOTHERModel',
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
                	read : 'otr111ukrvService.selectDetail2'
                }
            },
            listeners:{
            	load:function(store, records, successful, eOpts) {
            		if(successful)	{
            		   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
            		   var refRecords = new Array();
            		   if(masterRecords.items.length > 0) {
            		   		console.log("store.items :", store.items);
            		   		console.log("records", records);
            		   		Ext.each(records,
	            		   		function(item, i) {
			   						Ext.each(masterRecords.items, function(record, i) {
			   								if((record.data['ORDER_NUM'] == item.data['ORDER_NUM'])
			   								&& (record.data['ORDER_SEQ'] == item.data['ORDER_SEQ'])
			   								){
			   									refRecords.push(item);
			   								}
			   							}
			   						);
	            			   	}
	            			);
	            			store.remove(refRecords);
            			}
            		}
            	}
            },
            loadStoreRecords : function()	{
				var param= otherorderSearch.getValues();
				this.load({
					params : param
				});
			}
	});

	var otherOrderStore2 = Unilite.createStore('otr111ukrvotherOrderStore2', {//반품가능예약참조
			model: 'Otr111ukrvOTHERModel2',
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
                	read    : 'otr111ukrvService.selectDetail3'
                }
            },
            listeners:{
            	load:function(store, records, successful, eOpts) {
            		if(successful)	{
            		   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
            		   var refRecords = new Array();
            		   if(masterRecords.items.length > 0) {
            		   		console.log("store.items :", store.items);
            		   		console.log("records", records);
            		   		Ext.each(records,
	            		   		function(item, i) {
			   						Ext.each(masterRecords.items, function(record, i) {
			   							console.log("record :", record);

			   								if((record.data['ORDER_NUM'] == item.data['ORDER_NUM'])
			   								&& (record.data['ORDER_SEQ'] == item.data['ORDER_SEQ'])
			   								){
			   									refRecords.push(item);
			   								}
			   							}
			   						);
	            			   	}
	            			);
	            			store.remove(refRecords);
            			}
            		}
            	}
            },
            loadStoreRecords : function()	{
				var param= otherorderSearch2.getValues();
				this.load({
					params : param
				});
			}
	});

    var masterGrid = Unilite.createGrid('otr111ukrvGrid', {		// 메인
    	// for tab
        layout : 'fit',
        region : 'center',
    	uniOpt: {
    		useLiveSearch    : true,
			expandLastColumn : false,
		 	useRowNumberer   : false,
		 	useContextMenu   : true
        },
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'orderTool',
			text: '<t:message code="system.label.purchase.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'ReservationBtn',
					text: '예약참조',
					handler: function() {
						if(masterForm.setAllFieldsReadOnly(true)){
							searchForm.setAllFieldsReadOnly(true);
		        			openReservationWindow();
		        		}
					}
				}/* , {
					itemId: 'ReturnReservationBtn',
					text: '반품가능예약참조',
		        	handler: function() {
		        		if(masterForm.setAllFieldsReadOnly(true)){
		        			searchForm.setAllFieldsReadOnly(true);
		        			openReturnReservationWindow();
		        		}
			        }
				} */]
			})
		}],
		features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false}
    	],
    	store: directMasterStore1,
        columns:  [
               		 { dataIndex: 'INOUT_NUM'			    , 	width:66, hidden: true},
               		 { dataIndex: 'INOUT_SEQ'			    , 	width:50, align: 'center'},
               		 { dataIndex: 'INOUT_TYPE'			    , 	width:80, hidden: true},
               		 { dataIndex: 'INOUT_METH'			    , 	width:66, hidden: true},
               		 { dataIndex: 'INOUT_TYPE_DETAIL'       , 	width:76},
               		 { dataIndex: 'INOUT_CODE_TYPE'	        , 	width:76, hidden: true},
               		 { dataIndex: 'INOUT_CODE'			    , 	width:80, hidden: true},
               		 { dataIndex: 'INOUT_NAME'			    , 	width:150, hidden: true},
               		 { dataIndex: 'ITEM_CODE'			    ,   width:130 ,
						editor: Unilite.popup('DIV_PUMOK_G', {
					 		textFieldName: 'ITEM_CODE',
					 		DBtextFieldName: 'ITEM_CODE',
					 		extParam: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
		       			    autoPopup: true,
							listeners: {
								'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										Ext.each(records, function(record,i) {
											console.log('record',record);
											if(i==0) {
												masterGrid.setItemData(record,false);
												UniAppManager.app.checkStockPrice(record);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setItemData(record,false);
												UniAppManager.app.checkStockPrice(record);
											}
										});
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid.setItemData(null,true);
								},
								applyextparam: function(popup){
							        popup.setExtParam({'SELMODEL': 'MULTI'});
							        popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
							        popup.setExtParam({'DIV_CODE': Ext.getCmp("otr111ukrvMasterForm").getValue("DIV_CODE")});
					            }
							}
						})
					 },
					 {dataIndex: 'ITEM_NAME'			        , width: 180,
						editor: Unilite.popup('DIV_PUMOK_G', {
					 		extParam: {SELMODEL: 'MULTI'},
		       			    autoPopup: true,
							listeners: {
								'onSelected': {
									fn: function(records, type) {
							    	    console.log('records : ', records);
									    Ext.each(records, function(record,i) {
											if(i==0) {
												masterGrid.setItemData(record,false);
												UniAppManager.app.checkStockPrice(record);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setItemData(record,false);
												UniAppManager.app.checkStockPrice(record);
											}
										});
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid.setItemData(null,true);
								},
								applyextparam: function(popup){
							        popup.setExtParam({'SELMODEL': 'MULTI'});
							        popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
							        popup.setExtParam({'DIV_CODE': Ext.getCmp("otr111ukrvMasterForm").getValue("DIV_CODE")});
					            }
							}
						})
					 },
                     { dataIndex: 'LOT_NO'                  ,   width:120,
                        editor: Unilite.popup('LOTNO_G', {
                            textFieldName: 'LOT_CODE',
                            DBtextFieldName: 'LOT_CODE',
                            validateBlank: false,
		         			autoPopup: true,
                            listeners: {
                                applyextparam: function(popup){
                                    var record = masterGrid.getSelectedRecord();
                                    var divCode = masterForm.getValue('DIV_CODE');
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
                     {dataIndex: 'LOT_YN'                   ,   width:120, hidden: true },
               		 { dataIndex: 'SPEC'				    , 	width:180},
               		 { dataIndex: 'STOCK_UNIT'			    , 	width:90, align: 'center'},
               		 { dataIndex: 'WH_CODE'			        , 	width:110},
               		 { dataIndex: 'WH_NAME'                 , 	width:93, hidden: true},
               		 { dataIndex: 'WH_CELL_CODE'		    , 	width:100, hidden: sumtypeCell},
               		 { dataIndex: 'WH_CELL_NAME'		    , 	width:100, hidden: true},
               		 { dataIndex: 'ALLOC_Q'			        , 	width:96},
               		 { dataIndex: 'NOT_OUTSTOCK_Q'		    , 	width:96},
               		 { dataIndex: 'INOUT_Q'			        , 	width:96},
               		 { dataIndex: 'ITEM_STATUS'		        , 	width:96, align: 'center'},
               		 { dataIndex: 'ORIGINAL_Q'			    , 	width:96, hidden: true},
       		         { dataIndex: 'PAB_STOCK_Q'             , width: 100, hidden: usePabStockYn},
               		 { dataIndex: 'GOOD_STOCK_Q'		    , 	width:96},
               		 { dataIndex: 'BAD_STOCK_Q'		        , 	width:96},
               		 { dataIndex: 'INOUT_DATE'			    , 	width:100, hidden: true},
               		 { dataIndex: 'COMP_CODE'			    , 	width:100, hidden: true},
               		 { dataIndex: 'DIV_CODE'			    , 	width:60,  hidden: true},
               		 { dataIndex: 'INOUT_P'			        , 	width:100, hidden: true},
               		 { dataIndex: 'INOUT_I'			        , 	width:100, hidden: true},
               		 { dataIndex: 'EXPENSE_I'			    , 	width:100, hidden: true},
               		 { dataIndex: 'MONEY_UNIT'			    , 	width:100, hidden: true},
               		 { dataIndex: 'INOUT_FOR_P'		        , 	width:100, hidden: true},
               		 { dataIndex: 'INOUT_FOR_O'		        , 	width:100, hidden: true},
               		 { dataIndex: 'EXCHG_RATE_O'		    , 	width:100, hidden: true},
               		 { dataIndex: 'ORDER_TYPE'			    , 	width:100, hidden: true},
               		 { dataIndex: 'ORDER_NUM'			    , 	width:100, hidden: true},
               		 { dataIndex: 'ORDER_SEQ'			    , 	width:100, hidden: true},
               		 { dataIndex: 'LC_NUM'				    , 	width:100, hidden: true},
               		 { dataIndex: 'BL_NUM'				    , 	width:100, hidden: true},
               		 { dataIndex: 'INOUT_PRSN'			    , 	width:100, hidden: true},
               		 { dataIndex: 'BASIS_NUM'			    , 	width:100, hidden: true},
               		 { dataIndex: 'BASIS_SEQ'			    , 	width:100, hidden: true},
               		 { dataIndex: 'ACCOUNT_YNC'		        , 	width:100, hidden: true},
               		 { dataIndex: 'ACCOUNT_Q'			    , 	width:100, hidden: true},
               		 { dataIndex: 'CREATE_LOC'			    , 	width:100, hidden: true},
               		 { dataIndex: 'SALE_C_YN'			    , 	width:100, hidden: true},
               		 { dataIndex: 'SALE_C_DATE'		        , 	width:100, hidden: true},
               		 { dataIndex: 'SALE_C_REMARK'		    , 	width:100, hidden: true},
               		 { dataIndex: 'GRANT_TYPE'		    	, 	width:100, hidden: true},
               		 { dataIndex: 'REMARK'				    , 	width:200},
               		 { dataIndex: 'PROJECT_NO'  		    , 	width:120},
               		 { dataIndex: 'SALE_DIV_CODE'           , 	width:133, hidden: true},
               		 { dataIndex: 'SALE_CUSTOM_CODE'        , 	width:66, hidden: true},
               		 { dataIndex: 'BILL_TYPE'               , 	width:66, hidden: true},
               		 { dataIndex: 'SALE_TYPE'               , 	width:66, hidden: true},
               		 { dataIndex: 'UPDATE_DB_USER'          , 	width:66, hidden: true},
               		 { dataIndex: 'UPDATE_DB_TIME'          , 	width:66, hidden: true},
               		 { dataIndex: 'ITEM_ACCOUNT'           , 	width:66, hidden: true},
               		 { dataIndex: 'STOCK_CARE_YN'           , 	width:66, hidden: true},
               		 { dataIndex: 'ORDER_ITEM_CODE'           , 	width:120},
               		 { dataIndex: 'ORDER_ITEM_NAME'           , 	width:120},
               		 { dataIndex: 'S_GUBUN_KD'           , 	width:120, hidden: true}
        ],
        listeners: {
			afterrender: function(grid) {	//useContextMenu:true 설정으로 툴바 우측 버튼은 자동 생성되며 그 외 추가할 메뉴  작성
				this.contextMenu.add({
					xtype: 'menuseparator'
				},{
					text: '품목정보',   iconCls : '',
		        	handler: function(menuItem, event) {
		        		var record = grid.getSelectedRecord();
						var params = {
							ITEM_CODE : record.get('ITEM_CODE')
						}
						var rec = {data : {prgID : 'bpr100ukrv', 'text':''}};
						parent.openTab(rec, '/base/bpr100ukrv.do', params);
		        	}
		        },{
		        	text: '거래처정보',   iconCls : '',
		            handler: function(menuItem, event) {
						var params = {
							CUSTOM_CODE : masterForm.getValue('CUSTOM_CODE'),
							COMP_CODE : UserInfo.compCode
						}
						var rec = {data : {prgID : 'bcm100ukrv', 'text':''}};
						parent.openTab(rec, '/base/bcm100ukrv.do', params);
		            }
		        })
			},
			//contextMenu의 복사한 행 삽입 실행 전
			beforePasteRecord: function(rowIndex, record) {
				if(!UniAppManager.app.checkForNewDetail()) return false;
					var seq = directMasterStore1.max('INOUT_SEQ');
	            	if(!seq) seq = 1;
	            	else  seq += 1;
	          		record.INOUT_SEQ = seq;

	          		return true;
	        },
	        //contextMenu의 복사한 행 삽입 실행 후
	        afterPasteRecord: function(rowIndex, record) {
	        	masterForm.setAllFieldsReadOnly(true);
	        }
        },
	    listeners: {
			beforeedit: function( editor, e, eOpts ) {
	        	if(e.record.phantom == false) {		// 신규데이터가 아닌것.
	        		if(UniUtils.indexOf(e.field, ['LOT_NO'])){
	        			if(Ext.isEmpty(e.record.data.ITEM_CODE)){
                            alert(Msg.sMS003);
                            return false;
                        }
                        if(Ext.isEmpty(e.record.data.WH_CODE) && BsaCodeInfo.gsManageLotNoYN == 'Y' ){
                            alert('출고창고를 입력하십시오.');
                            return false;
                        }
                        if(BsaCodeInfo.gsSumTypeCell == 'Y' && Ext.isEmpty(e.record.data.WH_CELL_CODE)){
                            alert('출고창고 CELL코드를 입력하십시오.');
                            return false;
                        }
	        		}
  					if(UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL', 'WH_NAME', 'WH_CELL_CODE', 'LOT_NO',
												  'INOUT_Q', 'ITEM_STATUS', 'REMARK', 'PROJECT_NO'])) {
						return true;
      				} else {
      					return false;
      				}
				} else {
					if (UniUtils.indexOf(e.field, 'LOT_NO')){
                        if(Ext.isEmpty(e.record.data.ITEM_CODE)){
                            alert(Msg.sMS003);
                            return false;
                        }
                        if(Ext.isEmpty(e.record.data.WH_CODE) && BsaCodeInfo.gsManageLotNoYN == 'Y' ){
                            alert('출고창고를 입력하십시오.');
                            return false;
                        }
                        if(BsaCodeInfo.gsSumTypeCell == 'Y' && Ext.isEmpty(e.record.data.WH_CELL_CODE)){
                            alert('출고창고 CELL코드를 입력하십시오.');
                            return false;
                        }
                    }
					if(UniUtils.indexOf(e.field, ['INOUT_SEQ', 'INOUT_TYPE_DETAIL', 'ITEM_CODE', 'ITEM_NAME', 'WH_CODE', 'WH_CELL_CODE',
												  'LOT_NO', 'INOUT_Q', 'ITEM_STATUS', 'REMARK', 'PROJECT_NO']))
				   	{
						return true;
      				} else {
      					return false;
      				}
				}
			}
		},
		setReservationData: function(record) {						// 예약참조 셋팅
       		var grdRecord = this.getSelectedRecord();
			grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));
//			grdRecord.set('INOUT_DATE'			, record['ORDER_DATE']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_STATUS'			, '1');
			grdRecord.set('WH_CODE'				, record['WH_CODE']);
			grdRecord.set('INOUT_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('INOUT_NAME'			, record['CUSTOM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('NOT_OUTSTOCK_Q'		, record['NOT_OUTSTOCK']);
			grdRecord.set('ORIGINAL_Q'			, '0');
			grdRecord.set('ALLOC_Q'				, record['ALLOC_Q']);
			grdRecord.set('INOUT_Q'				, record['NOT_OUTSTOCK']);
			grdRecord.set('EXPENSE_I'			, '');
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('INOUT_FOR_P'			, '');
			grdRecord.set('INOUT_FOR_O'			, '');
			grdRecord.set('EXCHG_RATE_O'		, '');
			grdRecord.set('ORDER_TYPE'			, '4');
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('LC_NUM'				, '');
			grdRecord.set('BL_NUM'				, '');
			grdRecord.set('INOUT_PRSN'			, masterForm.getValue('INOUT_PRSN'));
			grdRecord.set('BASIS_NUM'			, '');
			grdRecord.set('BASIS_SEQ'			, '');
			grdRecord.set('ACCOUNT_YNC'			, '');
			grdRecord.set('ACCOUNT_Q'			, '0');
			grdRecord.set('CREATE_LOC'			, '2');
			grdRecord.set('SALE_C_YN'			, 'N');
			grdRecord.set('SALE_C_DATE'			, '');
			grdRecord.set('SALE_C_REMARK'		, '');
			grdRecord.set('WH_NAME'				, record['WH_CODE']);
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('GRANT_TYPE'			, record['GRANT_TYPE']);
			grdRecord.set('STOCK_CARE_YN'		, record['STOCK_CARE_YN']);
			grdRecord.set('LOT_YN'        , record['LOT_YN']);
			grdRecord.set('S_GUBUN_KD'		, record['S_GUBUN_KD']);
			//UniStock.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('GOOD_STOCK_Q'), null, grdRecord.get('BAD_STOCK_Q'));
			//grdRecord.set('GOOD_STOCK_Q'		,
			//grdRecord.set('BAD_STOCK_Q'			,
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');

			if(grdRecord.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
                UniMatrl.fnStockQ_kd(grdRecord, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, grdRecord.get('DIV_CODE'), UniDate.getDbDateStr(grdRecord.get('INOUT_DATE')), grdRecord.get('ITEM_CODE'));
            }
		},
		setReturnReservationData: function(record) {		// 반품가능 예약참조 셋팅
       		var grdRecord = this.getSelectedRecord();
       		grdRecord.set('INOUT_NUM'			, masterForm.getValue('INOUT_NUM'));
       		grdRecord.set('INOUT_TYPE'			, '2');
       		grdRecord.set('INOUT_METH'			, '1');
       		grdRecord.set('INOUT_TYPE_DETAIL'	, '10');
       		grdRecord.set('INOUT_CODE_TYPE'		, '5');
       		grdRecord.set('INOUT_CODE'			, record['CUSTOM_CODE']);
       		grdRecord.set('INOUT_NAME'			, record['CUSTOM_NAME']);
       		grdRecord.set('WH_CODE'				, record['WH_CODE']);
       		grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
       		grdRecord.set('INOUT_DATE'			, masterForm.getValue('INOUT_DATE'));
       		grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       		grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
       		grdRecord.set('ITEM_STATUS'			, '1');
       		grdRecord.set('SPEC'				, record['SPEC']);
       		grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
       		grdRecord.set('NOT_OUTSTOCK_Q'		, record['NOT_OUTSTOCK']);
       		grdRecord.set('ORIGINAL_Q'			, '0');
       		grdRecord.set('ALLOC_Q'				, record['ALLOC_Q']);
       		grdRecord.set('INOUT_Q'				, record['NOTOUTSTOCK_Q']);
       		grdRecord.set('EXPENSE_I'			, '');
       		grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
       		grdRecord.set('INOUT_FOR_P'			, '');
       		grdRecord.set('INOUT_FOR_O'			, '');
       		grdRecord.set('EXCHG_RATE_O'		, '');
       		grdRecord.set('ORDER_TYPE'			, '4');
       		grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
       		grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
       		grdRecord.set('LC_NUM'				, '');
       		grdRecord.set('BL_NUM'				, '');
       		grdRecord.set('INOUT_PRSN'			, masterForm.getValue('INOUT_PRSN'));
       		grdRecord.set('BASIS_NUM'			, '');
       		grdRecord.set('BASIS_SEQ'			, '');
       		grdRecord.set('ACCOUNT_YNC'			, '');
       		grdRecord.set('ACCOUNT_Q'			, '0');
       		grdRecord.set('CREATE_LOC'			, '2');
       		grdRecord.set('SALE_C_YN'			, 'N');
       		grdRecord.set('SALE_C_DATE'			, '');
       		grdRecord.set('SALE_C_REMARK'		, '');
       		grdRecord.set('REMARK'				, '');
       		grdRecord.set('GRANT_TYPE'			, record['GRANT_TYPE']);
       		grdRecord.set('STOCK_CARE_YN'		, record['STOCK_CARE_YN']);
       		grdRecord.set('LOT_YN'        , record['LOT_YN']);
       		//UniStock.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('GOOD_STOCK_Q'), null, grdRecord.get('BAD_STOCK_Q'));
       		//grdRecord.set('GOOD_STOCK_Q'		,
			//grdRecord.set('BAD_STOCK_Q'			,
       		grdRecord.set('SALE_DIV_CODE'		, '*');
       		grdRecord.set('SALE_CUSTOM_CODE'	, '*');
       		grdRecord.set('SALE_TYPE'			, '*');
       		grdRecord.set('BILL_TYPE'			, '*');
		},
		setItemData: function(record, dataClear) {
       		var grdRecord = this.getSelectedRecord();
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'		,"");
       			grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('WH_CODE'			,"");
				grdRecord.set('STOCK_UNIT'		,"");
				grdRecord.set('ACCOUNT_Q'		,0);
				grdRecord.set('NOT_OUTSTOCK_Q'	,0);
				grdRecord.set('INOUT_Q'		    ,0);
				grdRecord.set('ORIGINAL_Q'		,0);
				grdRecord.set('GOOD_STOCK_Q'	,0);
				grdRecord.set('BAD_STOCK_Q'		,0);
				grdRecord.set('STOCK_Q'			,0);
				grdRecord.set('DISCOUNT_RATE'	,0);
				grdRecord.set('LOT_NO'		    ,'');
				grdRecord.set('WH_NAME'		    ,'');
				grdRecord.set('WH_CELL_CODE'    ,'');
				grdRecord.set('WH_CELL_NAME'	,'');
				grdRecord.set('ITEM_STATUS'	    ,'');
                grdRecord.set('LOT_YN'          , '');
       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
       			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('WH_CODE'				, record['WH_CODE']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));
                grdRecord.set('LOT_YN'              , record['LOT_YN']);

                if(grdRecord.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
                    UniMatrl.fnStockQ_kd(grdRecord, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, grdRecord.get('DIV_CODE'), UniDate.getDbDateStr(grdRecord.get('INOUT_DATE')), grdRecord.get('ITEM_CODE'));
                }
//                UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'), grdRecord.get('WH_CODE'));

       		}
		}
    });

    function getLotPopupEditor(gsLotNoInputMethod){

    	var editField;
    	if(gsLotNoInputMethod == "E" || gsLotNoInputMethod == "Y"){

    		    	 editField = Unilite.popup('LOTNO_G',{
			        	             textFieldName: 'LOTNO_CODE',
		 							 DBtextFieldName: 'LOTNO_CODE',
		 							 width:1000,
		   					         autoPopup: true,
			        	             listeners: {
						             	'onSelected': {
						             		fn: function(record, type) {
						             			var selectRec = masterGrid.getSelectedRecord()
						             			if(selectRec){
						             				selectRec.set('LOT_NO', record[0]["LOT_NO"]);
						             				selectRec.set('WH_CODE', record[0]["WH_CODE"]);
						             				selectRec.set('WH_NAME', record[0]["WH_NAME"]);
						             				selectRec.set('WH_CELL_CODE', record[0]["WH_CELL_CODE"]);
						             				selectRec.set('WH_CELL_NAME', record[0]["WH_CELL_NAME"]);
						             				selectRec.set('GOOD_STOCK_Q', record[0]["GOOD_STOCK_Q"]);
						             				selectRec.set('BAD_STOCK_Q', record[0]["BAD_STOCK_Q"]);
						             			}
		                                 	},
						             		scope: this
						             	},
						             	'onClear': {
						             		fn: function(record, type) {
						             			var selectRec = masterGrid.getSelectedRecord()
						             			if(selectRec){
						             				selectRec.set('LOT_NO', '');
						             				selectRec.set('WH_CELL_CODE', '');
						             				selectRec.set('WH_CELL_NAME', '');
						             				selectRec.set('GOOD_STOCK_Q', 0);
						             				selectRec.set('BAD_STOCK_Q', 0);
						             				UniAppManager.app.checkStockPrice(selectRec.data);
						             			}
		                                 	},
						             		scope: this
						             	},
						             	applyextparam: function(popup){
						             		var selectRec = masterGrid.getSelectedRecord();
						             		if(selectRec){
						             			popup.setExtParam({'DIV_CODE':  selectRec.get('DIV_CODE')});
						             		    popup.setExtParam({'ITEM_CODE': selectRec.get('ITEM_CODE')});
						             		    popup.setExtParam({'ITEM_NAME': selectRec.get('ITEM_NAME')});
						             		    popup.setExtParam({'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE')});
						             		    popup.setExtParam({'CUSTOM_NAME': masterForm.getValue('CUSTOM_NAME')});
						             		    popup.setExtParam({'WH_CODE': selectRec.get('WH_CODE')});
						             		    popup.setExtParam({'WH_CELL_CODE': selectRec.get('WH_CELL_CODE')});
						             		    popup.setExtParam({'stockYN': 'Y'});
						             		}
						             	}
						             }
			                    });
    	}else if(gsLotNoInputMethod == "N"){
    		editField = {xtype : 'textfield', maxLength:20}
    	}

	    var editor = Ext.create('Ext.grid.CellEditor', {
        	ptype: 'cellediting',
			clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
			autoCancel : false,
			selectOnFocus:true,
            field: editField
        });

	    return editor;
    }

    var orderNoMasterGrid = Unilite.createGrid('otr111ukrvOrderNoMasterGrid', {		// 검색팝업창
        // title: '기본',
        layout : 'fit',
		store: orderNoMasterStore,
		uniOpt:{
			useLiveSearch : true,
			useRowNumberer: false
		},
        columns:  [
					 { dataIndex: 'INOUT_DATE'	        ,  width: 100, align:"center"},
					 { dataIndex: 'INOUT_CODE'	        ,  width: 133, hidden: true},
					 { dataIndex: 'CUSTOM_NAME'        	,  width: 173},
					 { dataIndex: 'WH_CODE'	        	,  width: 153},
					 { dataIndex: 'INOUT_PRSN'	        ,  width: 120},
					 { dataIndex: 'INOUT_NUM'	        ,  width: 166},
					 { dataIndex: 'LOT_NO'		        ,  width: 86}
        ] ,
        listeners: {
	        onGridDblClick: function(grid, record, cellIndex, colName) {
		         orderNoMasterGrid.returnData(record);
		         UniAppManager.app.onQueryButtonDown();
		         SearchInfoWindow.hide();
	        }
        },
        returnData: function(record)	{
        	if(Ext.isEmpty(record))	{
          		record = this.getSelectedRecord();
          	}
          	masterForm.setValues({
          		'INOUT_NUM'    : record.get('INOUT_NUM') ,
          		'CUSTOM_CODE'  : record.get('INOUT_CODE'),
          		'CUSTOM_NAME'  : record.get('CUSTOM_NAME'),
          		'INOUT_DATE'   : record.get('INOUT_DATE'),
          		'INOUT_PRSN'   : record.get('INOUT_PRSN')
          	});
          	searchForm.setValues({
          		'INOUT_NUM'    : record.get('INOUT_NUM') ,
          		'CUSTOM_CODE'  : record.get('INOUT_CODE'),
          		'CUSTOM_NAME'  : record.get('CUSTOM_NAME'),
          		'INOUT_DATE'   : record.get('INOUT_DATE'),
          		'INOUT_PRSN'   : record.get('INOUT_PRSN')
          	});
        }
    });

    //预定参考
    var otherorderGrid = Unilite.createGrid('otr111ukrvotherorderGrid', {	//예약참조
        // title: '기본',
        layout : 'fit',
    	store: otherOrderStore,
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
			uniOpt:{
	        	onLoadSelectFirst : false
	        },
        columns:  [
					 { dataIndex: 'ORDER_NUM'			    ,  width: 66, hidden: true},
					 { dataIndex: 'ORDER_DATE'			    ,  width: 90},
					 { dataIndex: 'ITEM_CODE'			    ,  width: 120},
					 { dataIndex: 'ITEM_NAME'			    ,  width: 150},
					 { dataIndex: 'SPEC'				    ,  width: 150},
					 { dataIndex: 'ALLOC_Q'			    	,  width: 96},
					 { dataIndex: 'OUTSTOCK_Q'			    ,  width: 96},
					 { dataIndex: 'NOT_OUTSTOCK'		    ,  width: 96},
					 { dataIndex: 'AVERAGE_P'			    ,  width: 66, hidden: true},
					 { dataIndex: 'STOCK_UNIT'			    ,  width: 66, hidden: true},
					 { dataIndex: 'WH_CODE'			    	,  width: 100},
					 { dataIndex: 'STOCK_Q'			    	,  width: 96},
					 { dataIndex: 'CUSTOM_CODE'		    	,  width: 66, hidden: true},
					 { dataIndex: 'CUSTOM_NAME'		    	,  width: 120},
					 { dataIndex: 'MONEY_UNIT'			    ,  width: 66, hidden: true},
					 { dataIndex: 'COMP_CODE'			    ,  width: 66, hidden: true},
					 { dataIndex: 'DIV_CODE'			    ,  width: 66, hidden: true},
					 { dataIndex: 'GRANT_TYPE'			    ,  width: 66, hidden: true},
					 { dataIndex: 'REMARK'				    ,  width: 200},
					 { dataIndex: 'PROJECT_NO'			    ,  width: 120},
					 { dataIndex: 'STOCK_CARE_YN'  	    	,  width: 66, hidden: true},
					 { dataIndex: 'LOT_YN'                  ,  width: 66, hidden: true},
					 { dataIndex: 'S_GUBUN_KD'                  ,  width: 66, hidden: true}
          ],
        listeners: {
          	onGridDblClick:function(grid, record, cellIndex, colName) {}
       	},
       	returnData: function(record) {
       		var records = this.getSelectedRecords();
       		Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setReservationData(record.data);
				UniAppManager.app.checkStockPrice(record.data);
			});
			this.deleteSelectedRow();
       	}
    });

    //退货可能预定参考
    var otherorderGrid2 = Unilite.createGrid('otr111ukrvotherorderGrid2', {  //반품가능예약참조
        // title: '기본',
        layout : 'fit',
    	store: otherOrderStore2,
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
			uniOpt:{
	        	onLoadSelectFirst : false
	        },
        columns:  [
					 { dataIndex: 'ORDER_NUM'			    ,  width: 66, hidden: true},
					 { dataIndex: 'ORDER_SEQ'			    ,  width: 66, hidden: true},
					 { dataIndex: 'ORDER_DATE'			    ,  width: 90},
					 { dataIndex: 'ORDER_ITEM_CODE'	    	,  width: 120},
					 { dataIndex: 'ORDER_ITEM_NAME'	    	,  width: 150},
					 { dataIndex: 'ITEM_CODE'			    ,  width: 120},
					 { dataIndex: 'ITEM_NAME'			    ,  width: 150},
					 { dataIndex: 'SPEC'				    ,  width: 150},
					 { dataIndex: 'WH_CODE'			    	,  width: 106},
					 { dataIndex: 'ALLOC_Q'			    	,  width: 106, hidden: true},
					 { dataIndex: 'NOTOUTSTOCK_Q'		    ,  width: 96},
					 { dataIndex: 'OUTSTOCK_Q'			    ,  width: 96},
					 { dataIndex: 'NOT_OUTSTOCK'		    ,  width: 96},
					 { dataIndex: 'AVERAGE_P'			    ,  width: 66, hidden: true},
					 { dataIndex: 'STOCK_UNIT'			    ,  width: 66, hidden: true},
					 { dataIndex: 'STOCK_Q'			    	,  width: 66, hidden: true},
					 { dataIndex: 'CUSTOM_CODE'		    	,  width: 66, hidden: true},
					 { dataIndex: 'CUSTOM_NAME'		    	,  width: 66, hidden: true},
					 { dataIndex: 'MONEY_UNIT'			    ,  width: 66, hidden: true},
					 { dataIndex: 'COMP_CODE'			    ,  width: 66, hidden: true},
					 { dataIndex: 'DIV_CODE'			    ,  width: 66, hidden: true},
					 { dataIndex: 'GRANT_TYPE'			    ,  width: 66, hidden: true},
					 { dataIndex: 'REMARK'					,  width: 133, hidden: true},
					 { dataIndex: 'PROJECT_NO'				,  width: 133, hidden: true},
					 { dataIndex: 'STOCK_CARE_YN'  			,  width: 66, hidden: true},
                     { dataIndex: 'LOT_YN'                  ,  width: 66, hidden: true}
          ],
        listeners: {
          	onGridDblClick:function(grid, record, cellIndex, colName) {}
       	},
       	returnData: function(record) {
       		var records = this.getSelectedRecords();
       		Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setReturnReservationData(record.data);
				UniAppManager.app.checkStockPrice(record.data);
			});
			this.getStore().remove(records);
       	}
    });

    function openSearchInfoWindow() {		// 검색팝업창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '출고번호검색',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [orderNoSearch, orderNoMasterGrid], //orderNomasterGrid],
                tbar:  ['->',
					{ itemId : 'saveBtn',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						if(orderNoSearch.setAllFieldsReadOnly(true)){
							orderNoMasterStore.loadStoreRecords();
						}
					},
					disabled: false
					}, {
						itemId : 'OrderNoCloseBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
				    beforehide: function(me, eOpt){
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
                	},
                	beforeclose: function( panel, eOpts )	{
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
                	},
                	show: function( panel, eOpts )	{
                		orderNoSearch.setValue('CUSTOM_CODE',masterForm.getValue('CUSTOM_CODE'));
                		orderNoSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
                		orderNoSearch.setValue('INOUT_PRSN',masterForm.getValue('INOUT_PRSN'));
                		if(Ext.isDate(masterForm.getValue('INOUT_DATE'))){
                			orderNoSearch.setValue('FR_INOUT_DATE',UniDate.get("startOfMonth", masterForm.getValue('INOUT_DATE')));
                			orderNoSearch.setValue('TO_INOUT_DATE',masterForm.getValue('INOUT_DATE'));
                		}
                	}
                }
			})
		}
		SearchInfoWindow.show();
		SearchInfoWindow.center();
    }

    function openReservationWindow() {    		//예약참조

  		if(!ReservationWindow) {
			ReservationWindow = Ext.create('widget.uniDetailWindow', {
                title: '예약참조',
                width: 1080,
                height: 580,
                layout:{type:'vbox', align:'stretch'},

                items: [otherorderSearch, otherorderGrid],
                tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							otherOrderStore.loadStoreRecords();
						},
						disabled: false
					},{	itemId : 'confirmBtn',
						text: '출고적용',
						handler: function() {
							otherorderGrid.returnData();
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						text: '출고적용 후 닫기',
						handler: function() {
							otherorderGrid.returnData();
							ReservationWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							ReservationWindow.hide();
						},
						disabled: false
					}
				],
                listeners : {
                    beforehide: function(me, eOpt)	{
                		//otherorderSearch.clearForm();
                		//otherorderGrid,reset();
                	},
                	beforeclose: function( panel, eOpts )	{
						//otherorderSearch.clearForm();
                		//otherorderGrid,reset();
                	},
                	beforeshow: function ( me, eOpts )	{
                		otherorderSearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
                		otherorderSearch.setValue('DIV_CODE', masterForm.getValue('DIV_CODE'));
                		otherorderSearch.setValue("FR_INOUT_DATE" , UniDate.get('startOfMonth',masterForm.getValue("INOUT_DATE")));
                		otherorderSearch.setValue("TO_INOUT_DATE" , masterForm.getValue("INOUT_DATE"));
                		otherOrderStore.loadStoreRecords();
                	}
                }
			})
		}

		ReservationWindow.show();
		ReservationWindow.center();
    }

/*     function openReturnReservationWindow() {    		//반품가능예약참조

  		if(!ReturnReservationWindow) {
			ReturnReservationWindow = Ext.create('widget.uniDetailWindow', {
                title: '반품가능예약참조',
                width: 1080,
                height: 580,
                layout:{type:'vbox', align:'stretch'},

                items: [otherorderSearch2, otherorderGrid2],
                tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							otherOrderStore2.loadStoreRecords();
						},
						disabled: false
					},{	itemId : 'confirmBtn',
						text: '출고적용',
						handler: function() {
							otherorderGrid2.returnData();
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						text: '출고적용 후 닫기',
						handler: function() {
							otherorderGrid2.returnData();
							ReturnReservationWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							ReturnReservationWindow.hide();
						},
						disabled: false
					}
				],
                listeners : {
                    beforehide: function(me, eOpt)	{
                		//otherorderSearch.clearForm();
                		//otherorderGrid2,reset();
                	},
                	beforeclose: function( panel, eOpts )	{
						//otherorderSearch.clearForm();
                		//otherorderGrid2,reset();
                	},
                	beforeshow: function ( me, eOpts )	{
                		otherorderSearch2.setValue("DIV_CODE"    , masterForm.getValue("DIV_CODE"));
                		otherorderSearch2.setValue("CUSTOM_CODE" , masterForm.getValue("CUSTOM_CODE"));
                		otherorderSearch2.setValue("FR_ORDER_DATE" , UniDate.get('startOfMonth',masterForm.getValue("INOUT_DATE")));
                		otherorderSearch2.setValue("TO_ORDER_DATE" , masterForm.getValue("INOUT_DATE"));
                		otherOrderStore2.loadStoreRecords();
                	}
                }
			})
		}
		ReturnReservationWindow.show();
		ReturnReservationWindow.center();
    } */

    Unilite.Main({
		border: false,
		borderItems:[{
			region: 'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid,searchForm
			]
		},masterForm],
		id: 'otr111ukrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
			UniAppManager.setToolbarButtons('save', false);

//            cbStore.loadStoreRecords();
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
        	searchForm.setValue('DIV_CODE',UserInfo.divCode);
        	masterForm.setValue('INOUT_DATE',new Date());
        	searchForm.setValue('INOUT_DATE',new Date());
        	masterForm.getForm().wasDirty = false;
        	searchForm.getForm().wasDirty = false;
         	masterForm.resetDirtyStatus();
         	searchForm.resetDirtyStatus();
//            cbStore.loadStoreRecords();
		},
		onQueryButtonDown: function()	{		// 조회버튼 눌렀을때
			masterForm.setAllFieldsReadOnly(false);
			var inoutNo = masterForm.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow()
			} else {
		//		var param= masterForm.getValues();
				directMasterStore1.loadStoreRecords();
			};
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();

			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			searchForm.clearForm();
			searchForm.setAllFieldsReadOnly(false);

			masterGrid.reset();
			masterGrid.getStore().clearData();
			this.fnInitBinding();

			searchForm.getField('CUSTOM_CODE').setReadOnly(false);
			searchForm.getField('CUSTOM_NAME').setReadOnly(false);
			searchForm.getField('DIV_CODE').setReadOnly(false);
			searchForm.getField('INOUT_DATE').setReadOnly(false);
			searchForm.getField('INOUT_PRSN').setReadOnly(false);
			searchForm.getField('WH_CODE').setReadOnly(false);
            searchForm.getField('WH_CELL_CODE').setReadOnly(false);

			masterForm.getField('CUSTOM_CODE').setReadOnly(false);
			masterForm.getField('CUSTOM_NAME').setReadOnly(false);
			masterForm.getField('DIV_CODE').setReadOnly(false);
			masterForm.getField('INOUT_DATE').setReadOnly(false);
			masterForm.getField('INOUT_PRSN').setReadOnly(false);
			masterForm.getField('WH_CODE').setReadOnly(false);
            masterForm.getField('WH_CELL_CODE').setReadOnly(false);

			masterForm.getField('CUSTOM_CODE').focus();
			searchForm.getField('CUSTOM_CODE').focus();

		},
		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
         onDeleteAllButtonDown: function() {
            var records = directMasterStore1.data.items;
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
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore1.saveStore();
		},
		rejectSave: function() {	// 저장
			var rowIndex = masterGrid.getSelectedRowIndex();
			masterGrid.select(rowIndex);
			directMasterStore1.rejectChanges();

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
			directMasterStore1.onStoreActionEnable();
		},
		confirmSaveData: function(config)	{	// 저장하기전 원복 시키는 작업
			var fp = Ext.getCmp('otr111ukrvFileUploadPanel');
        	if(masterStore.isDirty() || fp.isDirty()) {
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
        cbStockQ_kd: function(provider, params)    {
            var rtnRecord = params.rtnRecord;
            var pabStockQ = Unilite.nvl(provider['PAB_STOCK_Q'], 0);//가용재고량
            rtnRecord.set('PAB_STOCK_Q', pabStockQ);
        },
		onNewDataButtonDown: function()	{		// 행추가
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
			var inoutNum        = masterForm.getValue('INOUT_NUM');
			var seq             = !directMasterStore1.max('INOUT_SEQ')?1: directMasterStore1.max('INOUT_SEQ') + 1;
            // var inoutType    = '2';
            var inoutMeth       ='2';
            var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_M104').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
            var inoutCodeType   = '5';
            var inoutCode       = masterForm.getValue('CUSTOM_CODE');
            var whCode          = masterForm.getValue('WH_CODE');
            var whCellCode      = masterForm.getValue('WH_CELL_CODE');
            var divCode         = masterForm.getValue('DIV_CODE');
            var inoutDate       = masterForm.getValue('INOUT_DATE');
            var itemCode        = '';
            var itemName        = '';
            var itemStatus      = '1';
            var Spec            = '';
            var stockUnit       = '';
            var notOutstockQ    = '0';
            var originalQ       = '0';
            var allocQ          = '0';
            var inoutQ          = '0';
            var expenseI        = '0';
            var moneyUnit       = '';
            var inoutForP       = '';
            var inoutForO       = '';
            var exchgRateO      = '4';
            var orderType       = '';
            var orderNum        = '';
            var orderSeq        = '';
            var lcNum           = '';
            var blNum           = '';
            var inoutPrsn       = masterForm.getValue('INOUT_PRSN');
            var basisNum        = '';
            var basisSeq        = '';
            var accountYnc      = '';
            var accountQ        = '0';
            var createLoc       = '2';
            var saleCYn         = 'N';
            var saleCDate       = '';
            var saleCRemark     = '';
            var grantTytpe      = '2';
            var Remark          = '';
            var whCellName      = '';
            var saleDivCode     = '*';
            var saleCustomCode  = '*';
            var saleType        = '*';
            var billType        = '*';

            var r = {
            	//COMP_CODE: compCode,
				INOUT_NUM         : inoutNum,
				INOUT_SEQ         : seq,
				//INOUT_TYPE      : inoutType,
				INOUT_METH        : inoutMeth,
				INOUT_TYPE_DETAIL : inoutTypeDetail,
				INOUT_CODE_TYPE   : inoutCodeType,
				INOUT_CODE        : inoutCode,
				WH_CODE           : whCode,
				DIV_CODE          : divCode,
				INOUT_DATE        : inoutDate,
				ITEM_CODE         : itemCode,
				ITEM_NAME         : itemName,
				ITEM_STATUS       : itemStatus,
				SPEC              : Spec,
				STOCK_UNIT        : stockUnit,
				NOT_OUTSTOCK_Q    : notOutstockQ,
				ORIGINAL_Q        : originalQ,
				ALLOC_Q           : allocQ,
				INOUT_Q           : inoutQ,
				EXPENSE_I         : expenseI,
				MONEY_UNIT        : moneyUnit,
				INOUT_FOR_P       : inoutForP,
				INOUT_FOR_O       : inoutForO,
				EXCHG_RATE_O      : exchgRateO,
				ORDER_TYPE        : orderType,
				ORDER_NUM         : orderNum,
				ORDER_SEQ         : orderSeq,
				LC_NUM            : lcNum,
				BL_NUM            : blNum,
				INOUT_PRSN        : inoutPrsn,
				BASIS_NUM         : basisNum,
				BASIS_SEQ         : basisSeq,
				ACCOUNT_YNC       : accountYnc,
				ACCOUNT_Q         : accountQ,
				CREATE_LOC        : createLoc,
				SALE_C_YN         : saleCYn,
				SALE_C_DATE       : saleCDate,
				SALE_C_REMARK     : saleCRemark,
				GRANT_TYPE        : grantTytpe,
				REMARK            : Remark,
				WH_CELL_CODE      : whCellCode,
				WH_CELL_NAME      : whCellName,
				SALE_DIV_CODE     : saleDivCode,
				SALE_CUSTOM_CODE  : saleCustomCode,
				SALE_TYPE         : saleType,
				BILL_TYPE         : billType
		    };

//            cbStore.loadStoreRecords(whCode);
			masterGrid.createRow(r, 'ITEM_CODE', seq-2);
			masterForm.setAllFieldsReadOnly(false);
			searchForm.setAllFieldsReadOnly(false);
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('INOUT_NUM')))	{
				alert('<t:message code="unilite.msg.sMS533" default="수주번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}
			searchForm.setAllFieldsReadOnly(true);
			return masterForm.setAllFieldsReadOnly(true);
        },
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		checkStockPrice:function(record){
			if(record){
				var param = {
					"ITEM_CODE":record["ITEM_CODE"],
					"WH_CODE"  :record["WH_CODE"]
				}
				Ext.Ajax.request({
				    url     : CPATH+'/otr/otr111SelectProductNumInWh.do',
				    params  : param,
				    async   : false,
				    success : function(response){
				        if(response.status == "200"){
				        	var provider = JSON.parse(response.responseText);
				        	var selectRecord = Ext.getCmp("otr111ukrvGrid").getSelectedRecord();
						    if(selectRecord){
						    	selectRecord.set("AVERAGE_P", provider["AVERAGE_P"]);
						        selectRecord.set("BAD_STOCK_Q", provider["BAD_STOCK_Q"]);
						        selectRecord.set("GOOD_STOCK_Q", provider["GOOD_STOCK_Q"]);
						        selectRecord.set("STOCK_Q", provider["STOCK_Q"]);
						    }
				        }
				    },
				    callback: function()	{
				    	Ext.getBody().unmask();
				    }
				});
			}
		}
	});
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "INOUT_SEQ" :	// 순번
					if(newValue <= '0') {
						rv= Msg.sMB076;
						break;
					}
					break;

				case "INOUT_Q" :	// 출고량
					if(newValue < 0 && !Ext.isEmpty(newValue))  {
                        rv=Msg.sMB076;
                        break;
                    }
                    if(record.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
                        var sInout_q = newValue;    //출고량
                        var sInv_q = record.get('PAB_STOCK_Q'); //가용재고량
                        var sOriginQ = record.get('ORIGINAL_Q'); //출고량(원)
                        if(sInout_q > (sInv_q + sOriginQ)){
                            rv="출고량은 가용재고량을 초과할 수 없습니다.";  //출고량은 재고량을 초과할 수 없습니다.
                            break;
                        }
                    }
                    var sInout_q = newValue;    //출고량
                    var sInv_q = record.get('ITEM_STATUS') == "1"? record.get('GOOD_STOCK_Q') : record.get('BAD_STOCK_Q');  //재고량
                    var sOriginQ = record.get('ORIGINAL_Q'); //출고량(원)

                    if(sInout_q > (sInv_q + sOriginQ)){
                        rv=Msg.sMS210;  //출고량은 재고량을 초과할 수 없습니다.
                        break;
                    }
                    break;
				case "WH_CODE":
				    var data ={
				    	"ITEM_CODE": record.get("ITEM_CODE"),
				    	"WH_CODE"  : newValue
				    }
                    //그리드 창고cell콤보 reLoad..
//                    cbStore.loadStoreRecords(newValue);
				    UniAppManager.app.checkStockPrice(data);

				    if(!Ext.isEmpty(record.get('ITEM_CODE'))){
                        if(record.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
                            UniMatrl.fnStockQ_kd(record, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, record.get('DIV_CODE'), UniDate.getDbDateStr(record.get('INOUT_DATE')), record.get('ITEM_CODE'));
                        }
//                        UniMatrl.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('DIV_CODE'), null, record.get('ITEM_CODE'), newValue );
                    }
				    break;
			}
			return rv;
		}
	});
};
</script>