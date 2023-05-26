<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp102ukrv_in"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmp102ukrv_in" /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"  /> <!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B014"  /> <!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A" /> 	<!-- 가공창고 -->
	<t:ExtComboStore comboType="WU" />    <!--작업장(사용여부 Y) -->
	<t:ExtComboStore comboType="W" />     <!--작업장(전체) -->

</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var searchInfoWindow;	// searchInfoWindow : 조회창
var referProductionPlanWindow;	// 생산계획참조
var refWindow;	// 생산계획참조
var sWkordNum;
var workShopCodeCount = 1;
var sTopWkordNum;
var BsaCodeInfo = {
	gsAutoType:        '${gsAutoType}',            // "P005"	'생산자동채번여부
	gsChildStockPopYN : '${gsChildStockPopYN}',     //'자재부족수량 팝업 호출여부
	gsShowBtnReserveYN: '${gsShowBtnReserveYN}',	//'BOM PATH 관리여부
	gsManageLotNoYN   : '${gsManageLotNoYN}',       //'재고와 작업지시LOT 연계여부
	grsManageLotNo    : '${grsManageLotNo}',        // LOT 연계여부
	gsLotNoInputMethod : '${gsLotNoInputMethod}',   // grsManageLotNo(0)
    gsLotNoEssential   : '${gsLotNoEssential}',     // grsManageLotNo(1)
    gsEssItemAccount   : '${gsEssItemAccount}',      // grsManageLotNo(2)
    gsMoldCode   : '${gsMoldCode}',             // 작업지시 금형여부
    gsEquipCode  : '${gsEquipCode}',
    gsReportGubun : '${gsReportGubun}'	// 레포트 구분
};

var isMoldCode = false;

if(BsaCodeInfo.gsMoldCode=='N') {
    isMoldCode = true;
}

var isEquipCode = false;
if(BsaCodeInfo.gsEquipCode=='N') {
    isEquipCode = true;
}

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pmp102ukrv_inService.selectDetailList',
			update: 's_pmp102ukrv_inService.updateDetail',
			create: 's_pmp102ukrv_inService.insertDetail',
			destroy: 's_pmp102ukrv_inService.deleteDetail',
			syncAll: 's_pmp102ukrv_inService.saveAll'
		}
	});

	var masterForm = Unilite.createSearchPanel('s_pmp102ukrv_inMasterForm', {
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        hidden:true,
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        },
	        dirtychange: function(basicForm, dirty, eOpts) {
				console.log("onDirtyChange");
			}
        },
		items: [{
			title: '기본정보',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		      xtype: 'uniTextfield',
		      name: 'WK_PLAN_NUM',
		      hidden: false
		    },{
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		holdable: 'hold',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
						panelResult.setValue('WORK_SHOP_CODE', '');
						masterForm.setValue('WORK_SHOP_CODE', '');
					}
        		}
			},{
				fieldLabel: '작업장',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				holdable: 'hold',
				comboType: 'WU',
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					}
        		}
			},
				Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '품목코드',
			        	valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						holdable: 'hold',
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									var expirationDay = records[0]["EXPIRATION_DAY"] * 30 - 1;
									panelResult.setValue('ITEM_CODE', masterForm.getValue('ITEM_CODE'));
									panelResult.setValue('ITEM_NAME', masterForm.getValue('ITEM_NAME'));
									panelResult.setValue('SPEC', records[0].SPEC);
									panelResult.setValue('PROG_UNIT', records[0].STOCK_UNIT);
									panelResult.setValue('EXPIRATION_DAY',Ext.Date.add(panelResult.getValue('PRODT_START_DATE'),Ext.Date.DAY,expirationDay));
									masterForm.setValue('SPEC', records[0].SPEC);
									masterForm.setValue('PROG_UNIT', records[0].STOCK_UNIT);
									masterForm.setValue('EXPIRATION_DAY',Ext.Date.add(panelResult.getValue('PRODT_START_DATE'),Ext.Date.DAY,expirationDay));
									masterForm.setValue('EXPIRATION_DAY2', records[0].EXPIRATION_DAY);
									masterForm.setValue('PRODUCT_LDTIME', records[0].PRODUCT_LDTIME);
									panelResult.setValue('EXPIRATION_DAY2', records[0].EXPIRATION_DAY);
									panelResult.setValue('PRODUCT_LDTIME', records[0].PRODUCT_LDTIME);

		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_NAME', '');
								panelResult.setValue('SPEC', '');
								panelResult.setValue('PROG_UNIT', '');
								panelResult.setValue('EXPIRATION_DAY', '');
								masterForm.setValue('SPEC', '');
								masterForm.setValue('PROG_UNIT', '');
								masterForm.setValue('EXPIRATION_DAY', '');
								masterForm.setValue('EXPIRATION_DAY2', '');
								masterForm.setValue('PRODUCT_LDTIME', '');
								panelResult.setValue('EXPIRATION_DAY2','');
								panelResult.setValue('PRODUCT_LDTIME', '');
							}
						}
			}),{
				fieldLabel : ' ',
				name:'SPEC',
				xtype:'uniTextfield',
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SPEC', newValue);
					}
        		}
			},{
		 		fieldLabel: '작업지시일',
		 		xtype: 'uniDatefield',
		 		name: 'START_WKORD_DATE',
		 		value: new Date(),
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('START_WKORD_DATE', newValue);
					}
        		}
			},{
		    	fieldLabel: '작업지시량',
			 	xtype: 'uniTextfield',
			 	name: 'WKORD_Q',
			 	holdable: 'hold',
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WKORD_Q', newValue);
					}
        		}
			},{
				fieldLabel : ' ',
				name:'PROG_UNIT',
				xtype:'uniTextfield',
				holdable: 'hold',
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PROG_UNIT', newValue);
					}
        		}
			},{
		 		fieldLabel: '착수예정일',
		 		xtype: 'uniDatefield',
		 		name: 'PRODT_START_DATE',
		 		value: new Date(),
		 		holdable: 'hold',
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PRODT_START_DATE', newValue);

					}
        		}
			},{
		 		fieldLabel: '완료예정일',
		 		xtype: 'uniDatefield',
		 		name: 'PRODT_END_DATE',
		 		value: new Date(),
		 		holdable: 'hold',
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PRODT_END_DATE', newValue);
					}
        		}
			},
				Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '관리번호',
			        	valueFieldName: 'TEST_CODE',
						textFieldName: 'TEST_NAME',
						holdable: 'hold',
						hidden:true,
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('TEST_CODE', masterForm.getValue('TEST_CODE'));
									panelResult.setValue('TEST_NAME', masterForm.getValue('TEST_NAME'));
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('TEST_CODE', '');
								panelResult.setValue('TEST_NAME', '');
							}
						}
			}),
				Unilite.popup('PROJECT',{
			        	fieldLabel: '프로젝트',
			        	valueFieldName: 'PJT_CODE',
						textFieldName: 'PROJECT_NO',
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('PJT_CODE', masterForm.getValue('PJT_CODE'));
									panelResult.setValue('PROJECT_NO', masterForm.getValue('PROJECT_NO'));
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('PJT_CODE', '');
								panelResult.setValue('PROJECT_NO', '');
							}
						}
			}),{
				fieldLabel	: '유효기간',
				name		: 'EXPIRATION_DAY',
				xtype		: 'uniDatefield',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EXPIRATION_DAY', newValue);
					}
        		}
			},
				Unilite.popup('LOT_NO',{
			        	fieldLabel: 'LOT_NO',
			        	validateBlank :false,
			        	allowBlank: false,
			        	valueFieldName: 'LOT_CODE',
						textFieldName: 'LOT_NAME',
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('LOT_CODE', masterForm.getValue('LOT_CODE'));
									panelResult.setValue('LOT_NAME', masterForm.getValue('LOT_NAME'));
		                    	},
								scope: this
							},
							onClear: function(type)	{
							}
						}
			}),{
		    	fieldLabel: '비고',
			 	xtype: 'uniTextfield',
			 	name: 'REMARK',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('REMARK', newValue);
					}
        		}
			}]
		},{
			title: '참고사항',
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		    	fieldLabel: '수주번호',
			 	xtype: 'uniTextfield',
			 	name: 'ORDER_NUM',
			 	readOnly: true
			},{
		    	fieldLabel: '수주량',

			 	name: 'ORDER_Q',
			 	xtype: 'uniNumberfield',
				decimalPrecision:0,
			 	readOnly: true
			},{
		    	fieldLabel: '납기일',
			 	xtype: 'uniDatefield',
			 	name: 'DVRY_DATE',
			 	readOnly: true
			},{
		    	fieldLabel: '거래처',
			 	xtype: 'uniTextfield',
			 	name: 'CUSTOM_CODE',
			 	readOnly: true
			}]
	    }, {
			fieldLabel	: '유효기간2',
			name		: 'EXPIRATION_DAY2',
			xtype		: 'uniNumberfield',
			type			: 'int',
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('EXPIRATION_DAY2', newValue);
				}
    		}
		}, {
			fieldLabel	: '제조리드타임',
			name		: 'PRODUCT_LDTIME',
			xtype		: 'uniNumberfield',
			type			: 'int',
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('PRODUCT_LDTIME', newValue);
				}
    		}
		}],
		fnCreditCheck: function() {
			if(BsaCodeInfo.gsCustCrYn=='Y' && BsaCodeInfo.gsCreditYn=='Y') {
				if(this.getValue('TOT_ORDER_AMT') > this.getValue('REMAIN_CREDIT')) {
					alert('<t:message code="unilite.msg.sMS284" default="해당 업체에 대한 여신액이 부족합니다. 추가여신액 설정을 선행하시고 작업하시기 바랍니다."/>');
					return false;
				}
			}
			return true;
		},
	    setAllFieldsReadOnly: function(b,c) {
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
                	if(c){
	                    var fields = this.getForm().getFields();
	                    Ext.each(fields.items, function(item) {
	                        if(Ext.isDefined(item.holdable) )   {
	                            if (item.holdable == 'hold') {
	                                item.setReadOnly(true);
	                            }
	                        }
	                        if(item.isPopupField)   {
	                            var popupFC = item.up('uniPopupField')  ;
	                            if(popupFC.holdable == 'hold') {
	                                popupFC.setReadOnly(true);
	                            }
	                        }
	                    })
                	}
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;
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
		layout : {type : 'uniTable', columns : 3},//,tableAttrs:{width:'100%'}
		padding:'1 1 1 1',
		border:true,
	    	items: [{
		      xtype: 'uniTextfield',
		      name: 'WK_PLAN_NUM',
		      hidden: true
		    },{
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		holdable: 'hold',
        		colspan:1,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('DIV_CODE', newValue);
						panelResult.setValue('WORK_SHOP_CODE', '');
						masterForm.setValue('WORK_SHOP_CODE', '');
					}
        		}
			},{
              xtype: 'component'
            },{
	    	  xtype: 'container',
	    	  layout:{type:'uniTable',columns:4},
	    	  colspan:1,
	    	  items:[
		    	  {
		    	  	xtype:'button',
		    	  	text:"생산계획참조",
		    	  	itemId:'btnWorkPlan',
		    	  	handler: function(){
						openProductionPlanWindow();
		    	  	}
		    	  },{
		    	  	xtype:'button',
		    	  	margin: '0 0 0 2',
		    	  	text:"일괄작지전개",
		    	  	itemId:'btnExp',
		    	  	handler: function(){
						UniAppManager.app.onQueryButtonDown();
		    	  	}
		    	  },{
		    	  	xtype:'button',
		    	  	text:"작지분할",
		    	  	disabled:true,
		    	  	itemId:'btnPart',
		    	  	hidden: true,
		    	  	margin: '0 0 0 4',
		    	  	handler: function(){
						openRefWindow();
		    	  	}
		    	  },{
		    	  	xtype:'button',
		    	  	text:"제조지시서출력",
		    	  	disabled:false,
		    	  	itemId:'btnPrint',
					hidden: false,
		    	  	margin: '0 0 0 6',
		    	  	handler: function(){
		    	  	  if(!panelResult.getInvalidMessage()) return;   //필수체크

                      if(Ext.isEmpty(sTopWkordNum)){
                          alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
                          return;
                      }

                      var param = panelResult.getValues();

                      param["printGubun"] = '1';
                      param["USER_LANG"] = UserInfo.userLang;

                      param["sTxtValue2_fileTitle"]='작업지시서';
                      param["PGM_ID"]= PGM_ID;
                      param["MAIN_CODE"] = 'P010';  //생산용 공통 코드

          			var win = null;
                      if(BsaCodeInfo.gsReportGubun == 'CLIP'){
                      	param["WKORD_NUM"] = sTopWkordNum;
				            win = Ext.create('widget.ClipReport', {
				                url: CPATH+'/prodt/pmp110clrkrv.do',
				                prgID: 'pmp100ukrv',
				                extParam: param
				            });
			            }else{
                      	param["sTopWkordNum"] = sTopWkordNum;
					    	win = Ext.create('widget.CrystalReport', {
	                    		url: CPATH+'/prodt/pmp100crkrv.do',
	                            extParam: param
	                        });
			            }

			            win.center();
			            win.show();

					}
		    	  }]
	    	},{
				fieldLabel: '작업장',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
		 		allowBlank:false,
		 		holdable: 'hold',
		 		colspan:2,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('WORK_SHOP_CODE', newValue);
					   if(!Ext.isEmpty(panelResult.getValue('PRODT_START_DATE')) && !Ext.isEmpty(panelResult.getValue('ITEM_CODE'))){
						   fnCreateLotno(UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE')), panelResult.getValue('ITEM_CODE'));
					   }
					}
        		}
			},{
				xtype:'label',
				html:'<div style="color:#0033CC;font-weight: bold">[ 참고 사항 ]</div>'
			},{
    			xtype: 'container',
    			layout: { type: 'uniTable', columns: 3},
    			defaultType: 'uniTextfield',
    			defaults : {enforceMaxLength: true},
    			colspan:2,
    			items:[
    				Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '품목코드',
			        	valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						holdable: 'hold',
						allowBlank:false,
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									console.log('[EXPIRATION_DAY] : ', records[0]["EXPIRATION_DAY"]);
									//var expirationDay = records[0]["EXPIRATION_DAY"] * 30 - 1;
									masterForm.setValue('EXPIRATION_DAY2', records[0].EXPIRATION_DAY);
									masterForm.setValue('PRODUCT_LDTIME', records[0].PRODUCT_LDTIME);
									panelResult.setValue('EXPIRATION_DAY2', records[0].EXPIRATION_DAY);
									panelResult.setValue('PRODUCT_LDTIME', records[0].PRODUCT_LDTIME);

									var expirationDay = panelResult.getValue('EXPIRATION_DAY2');
									var productLdtime = panelResult.getValue('PRODUCT_LDTIME');

									masterForm.setValue('SPEC',records[0]["SPEC"]);
									panelResult.setValue('SPEC',records[0]["SPEC"]);
									masterForm.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);
									panelResult.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);

									//masterForm.setValue('EXPIRATION_DAY',Ext.Date.add(panelResult.getValue('PRODT_START_DATE'),Ext.Date.DAY,expirationDay));
									//panelResult.setValue('EXPIRATION_DAY',Ext.Date.add(panelResult.getValue('PRODT_START_DATE'),Ext.Date.DAY,expirationDay));
									masterForm.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
									masterForm.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
									fnCalDate(expirationDay, productLdtime);
								    fnCreateLotno(UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE')), panelResult.getValue('ITEM_CODE'));

		                    	},
								scope: this
							},
							onClear: function(type)	{
								masterForm.setValue('ITEM_CODE', '');
								masterForm.setValue('ITEM_NAME', '');
								masterForm.setValue('SPEC','');
								masterForm.setValue('PROG_UNIT','');
								masterForm.setValue('EXPIRATION_DAY','');
								panelResult.setValue('SPEC','');
								panelResult.setValue('PROG_UNIT','');
								panelResult.setValue('EXPIRATION_DAY','');
								masterForm.setValue('EXPIRATION_DAY2', '');
								masterForm.setValue('PRODUCT_LDTIME', '');
								panelResult.setValue('EXPIRATION_DAY2','');
								panelResult.setValue('PRODUCT_LDTIME', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							}
						}
			   }),{
					name:'SPEC',
					xtype:'uniTextfield',
					readOnly:true,
					holdable: 'hold',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							masterForm.setValue('SPEC', newValue);
						}
	        		}
				}]
	    	},{
 			xtype:'container',
           	layout: {type: 'uniTable', columns: 1},
           	rowspan:4,
           	border:true,
           	defaultType: 'uniTextfield',
		    items: [{
		    	fieldLabel: '수주번호',
			 	xtype: 'uniTextfield',
			 	name: 'ORDER_NUM',
			 	readOnly: true
			},{
		    	fieldLabel: '수주량',
			 	xtype: 'uniTextfield',
			 	name: 'ORDER_Q',
			 	xtype: 'uniNumberfield',
				decimalPrecision:0,
			 	readOnly: true
			},{
		    	fieldLabel: '납기일',
			 	xtype: 'uniDatefield',
			 	name: 'DVRY_DATE',
			 	readOnly: true
			},{
		    	fieldLabel: '거래처',
			 	xtype: 'uniTextfield',
			 	name: 'CUSTOM_CODE',
			 	readOnly: true
			}]
	    },{
		 		fieldLabel: '작업지시일',
		 		xtype: 'uniDatefield',
		 		value: new Date(),
		 		name: 'START_WKORD_DATE',
		 		allowBlank:false,
		 		//holdable: 'hold',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('START_WKORD_DATE', newValue);
					}
        		}
			},{
    			xtype: 'container',
    			layout: { type: 'uniTable', columns: 3},
    			defaultType: 'uniTextfield',
    			defaults : {enforceMaxLength: true},
    			colspan:1,
    			items:[{
			    	fieldLabel: '작업지시량',
				 	xtype: 'uniNumberfield',
				 	name: 'WKORD_Q',
				 	value: '0.00',
				 	holdable: 'hold',
				 	allowBlank:false,
				 	listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							masterForm.setValue('WKORD_Q', newValue);
						}
	        		}
				},{
					name:'PROG_UNIT',
					xtype:'uniTextfield',
					width: 50,
					readOnly:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							masterForm.setValue('PROG_UNIT', newValue);
						}
	        		}
				}]
	    	},{
		 		fieldLabel: '착수예정일',
		 		xtype: 'uniDatefield',
		 		value: new Date(),
		 		name: 'PRODT_START_DATE',
		 		allowBlank:false,
		 		holdable: 'hold',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {


						var workShopCode =  panelResult.getValue('WORK_SHOP_CODE');
						var expirationDay = panelResult.getValue('EXPIRATION_DAY2');
						var productLdtime = panelResult.getValue('PRODUCT_LDTIME');
						var itemCode =  panelResult.getValue('ITEM_CODE');
						if(! Ext.isEmpty(workShopCode) && ! Ext.isEmpty(itemCode)){
							fnCreateLotno(UniDate.getDbDateStr(newValue), itemCode);
						}
						if(!Ext.isEmpty(newValue)){
							if(UniDate.getDbDateStr(newValue).replace(".","").replace(".","").length == 8){
								masterForm.setValue('PRODT_START_DATE', newValue);
								fnCalDate(expirationDay, productLdtime);
							}
						}
					}
        		}
			},{
    			xtype: 'container',
    			layout: { type: 'uniTable', columns: 3},
    			defaultType: 'uniTextfield',
    			defaults : {enforceMaxLength: true},
    			colspan:1,
    			items:[
				Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '관리번호',
			        	valueFieldName: 'TEST_CODE',
						textFieldName: 'TEST_NAME',
						hidden:true,
						holdable: 'hold',
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									masterForm.setValue('TEST_CODE', panelResult.getValue('TEST_CODE'));
									masterForm.setValue('TEST_NAME', panelResult.getValue('TEST_NAME'));
		                    	},
								scope: this
							},
							onClear: function(type)	{
								masterForm.setValue('TEST_CODE', '');
								masterForm.setValue('TEST_NAME', '');
							}
						}
			}),
				Unilite.popup('PROJECT',{
			        	fieldLabel: '프로젝트',
			        	width: 245,
			        	validateBlnak :false,
			        	valueFieldName: 'PJT_CODE',
						textFieldName: 'PROJECT_NO',
						//holdable: 'hold',
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									masterForm.setValue('PJT_CODE', panelResult.getValue('PJT_CODE'));
									masterForm.setValue('PROJECT_NO', panelResult.getValue('PROJECT_NO'));
		                    	},
								scope: this
							},
							onClear: function(type)	{
								masterForm.setValue('PJT_CODE', '');
								masterForm.setValue('PROJECT_NO', '');
							}
						}
			}),{
				fieldLabel	: '유효기간',
				name		: 'EXPIRATION_DAY',
				xtype		: 'uniDatefield',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('EXPIRATION_DAY', newValue);
					}
        		}
			}]
			},{
		 		fieldLabel: '완료예정일',
		 		xtype: 'uniDatefield',
		 		value: new Date(),
		 		name: 'PRODT_END_DATE',
		 		holdable: 'hold',
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('PRODT_END_DATE', newValue);
					}
        		}
			},{
    			xtype: 'container',
    			layout: { type: 'uniTable', columns: 2},
    			defaultType: 'uniTextfield',
    			defaults : {enforceMaxLength: true},
    			colspan:1,
    			//autoPopup: true,
    			items:[
				Unilite.popup('LOT_NO',{
			        	fieldLabel: 'LOT_NO',
			        	valueFieldName: 'LOT_CODE',
						textFieldName: 'LOT_NAME',
						validateBlank :false,
						//holdable: 'hold',
						allowBlank: false,
			        	 listeners: {
						 	onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									masterForm.setValue('LOT_CODE', panelResult.getValue('LOT_CODE'));
									masterForm.setValue('LOT_NAME', panelResult.getValue('LOT_NAME'));


		                    	},
								scope: this
							},
							onClear: function(type)	{
								masterForm.setValue('LOT_CODE', '');
								masterForm.setValue('LOT_NAME', '');
							}
						}
			}),{
		    	fieldLabel: '비고',
			 	xtype: 'uniTextfield',
			 	name: 'REMARK',
			 	//holdable: 'hold',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('REMARK', newValue);
					}
        		}
			}]
			}, {
				fieldLabel	: '유효기간2',
				name		: 'EXPIRATION_DAY2',
				xtype		: 'uniNumberfield',
				type			: 'int',
				hidden:true,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('EXPIRATION_DAY2', newValue);
					}
	    		}
			}, {
				fieldLabel	: '제조리드타임',
				name		: 'PRODUCT_LDTIME',
				xtype		: 'uniNumberfield',
				type			: 'int',
				hidden:true,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('PRODUCT_LDTIME', newValue);
					}
	    		}
			}],
			setAllFieldsReadOnly: function(b,c) {
            var r= true
            if(b) {
                var invalid = this.getForm().getFields().filterBy(function(field) {
                    return !field.validate();
                });
                if(invalid.length > 0) {
                } else {
                	if(c){
	                    var fields = this.getForm().getFields();
	                    Ext.each(fields.items, function(item) {
	                        if(Ext.isDefined(item.holdable) )   {
	                            if (item.holdable == 'hold') {
	                                item.setReadOnly(true);
	                            }
	                        }
	                        if(item.isPopupField)   {
	                            var popupFC = item.up('uniPopupField')  ;
	                            if(popupFC.holdable == 'hold') {
	                                popupFC.setReadOnly(true);
	                            }
	                        }
	                    })
                	}
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        }
	});

	/**
	 * Model 정의
	 *
	 * @type
	 */
	Unilite.defineModel('s_pmp102ukrv_inDetailModel', {
	    fields: [
	    	{name: 'GUBUN'									,text: '선택'				,type:'string'},
			{name: 'DIV_CODE'							,text: '사업장'			,type:'string'},
			{name: 'WORK_SHOP_CODE'			,text: '작업장'			,type:'string',comboType:'WU'},
			{name: 'ITEM_CODE'			 				,text: '품목코드'			,type:'string'},
			{name: 'ITEM_NAME'						,text: '품명'				,type:'string'},
			{name: 'SPEC'										,text: '규격'				,type:'string'},
			{name: 'STOCK_UNIT'		  				,text: '단위'				,type:'string'},
			{name: 'PRODT_START_DATE'			,text: '착수예정일'			,type:'uniDate'},
			{name: 'PRODT_END_DATE'				,text: '완료예정일'			,type:'uniDate'},
			{name: 'WKORD_Q'							,text: '작업지시량'			,type:'uniQty'},
			{name: 'SUPPLY_TYPE'						,text: '조달구분'			,type:'string',comboType:'AU',comboCode:'B014'},
			{name: 'WKORD_NUM'			 			,text: '작지번호'			,type:'string'},
			{name: 'WK_PLAN_NUM'					,text: '생산계획번호'		,type:'string'},
			{name: 'PRODUCT_LDTIME'				,text: '제조L/T'			,type:'string'},
			{name: 'SEQ_NO'			   		,text: '번호'				,type:'uniQty'},
			{name: 'REF_GUBUN'			  	,text: '반영구분'			,type:'string'},
			{name: 'PROJECT_NO'			,text: '프로젝트 번호'		,type:'string'},
			{name: 'PJT_CODE'				,text: '프로젝트번호'		,type:'string'},
			{name: 'REMARK'					,text: '비고'				,type:'string'},
			{name: 'LOT_NO'					,text: 'LOT_NO'			,type:'string'},
		    {name: 'CHECK_YN'	    		,text: '是否选中'	    	,type: 'string'}



		]
	});

	Unilite.defineModel('s_pmp102ukrv_inDetailModel2', {
	    fields: [
	    	{name: 'LINE_SEQ'        					,text: '공정순서'			,type:'string'},
			{name: 'PROG_WORK_CODE'  		,text: '공정코드'			,type:'string'},
			{name: 'PROG_WORK_NAME'  	,text: '공정명'			    ,type:'string'},
			{name: 'PROG_UNIT_Q'      			,text: '원단위량'			,type: 'float', decimalPrecision:6,format: "0,000,000.000000"},
			{name: 'WKORD_Q'         				,text: '작업지시량'			,type: 'float', decimalPrecision:6,format: "0,000,000.000000"},
			{name: 'PROG_UNIT'       				,text: '단위'				,type:'string',comboType:'AU',comboCode:'B013'},
			{name: 'PROG_RATE'       				,text: '공정진척율'			,type:'string'},
			{name: 'DIV_CODE'       				 	,text: '사업장'			    ,type:'string'},
			{name: 'WKORD_NUM'       			,text: '작지번호'			,type:'string'},
			{name: 'WORK_SHOP_CODE'  		,text: '작업장'			    ,type:'string'},
			{name: 'PRODT_START_DATE'		,text: '차수예정일'			,type:'uniDate'},
			{name: 'PRODT_END_DATE'   		,text: '완료예정일'			,type:'uniDate'},
			{name: 'PRODT_WKORD_DATE'	,text: '작업시작일'			,type:'uniDate'},
			{name: 'ITEM_CODE'       				,text: '품목'				,type:'string'},
			{name: 'REMARK'        				  	,text: '비고'				,type:'string'},
			{name: 'LOT_NO'           			 	,text: 'LOT_NO'			    ,type:'string'},
			{name: 'WK_PLAN_NUM'    		 	,text: '계획번호'			,type:'string'},
			{name: 'LINE_END_YN'  			   	,text: '최종공정여부'		,type:'string'},
			{name: 'ITEM_NAME'      			 	,text: '품명'				,type:'string'},
			{name: 'SPEC'              					,text: '규격'				,type:'string'},
			{name: 'WORK_END_YN'    		 	,text: '마감여부'			,type:'string'},
			{name: 'PROJECT_NO'					,text: '프로젝트 번호'		,type:'string'},
			{name: 'PJT_CODE'						,text: '프로젝트번호'		,type:'string'},
			{name: 'SEQ_NO'			   				,text: '번호'				,type:'uniQty'},
			{name: 'EQUIP_CODE'					,text: '설비'			,type:'string', allowBlank: true},
			{name: 'EQUIP_NAME'					,text: '설비명'		,type:'string' , allowBlank: true},
			{name: 'MOLD_CODE'   				,text: '금형코드'			,type:'string' , allowBlank: true},
			{name: 'MOLD_NAME'					,text: '금형명'		,type:'string' , allowBlank: true}


		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var detailStore = Unilite.createStore('s_pmp102ukrv_inDetailStore', {
		model: 's_pmp102ukrv_inDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		listeners: {
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			selectionchange:function(selected, eOpts ) {
                        var record = detailGrid.getSelectedRecord();
                        UniAppManager.app.fnFindProgWork(record.data);
            }
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();
			console.log(param);
			param.TYPE='1';
			this.load({
				params : param,
				callback: function(records, operation, success) {
					console.log(records);
					if(records != null && records.length>0){
						UniAppManager.app.fnDisable();
						detailStore2.loadStoreRecords(records[0].data);
					}
			    }
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
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			// 1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	// syncAll 수정\
			if(inValidRecs.length == 0) {
				var  records 	 =  detailStore.data.items;
				Ext.getCmp('s_pmp102ukrv_inGrid').getSelectionModel().selectAll();
				Ext.each(records, function(item, i){
					if(item.get("CHECK_YN") == 'Y'){
						refGubun = item.set("REF_GUBUN", "Y");
					}
			 	})
				var toCreate = this.getNewRecords();
       		    var toUpdate = this.getUpdatedRecords();
       		    var list = [].concat(toUpdate, toCreate);
       		    var masterRecords = list;
       		    detailStore2.clearFilter();
				var detailRecords = detailGrid2.getStore().getData().items;
				var masterArray = [];
				var detailArray = [];
				if(masterRecords != null && masterRecords.length > 0){
					masterRecords.forEach(function(e){
						var dataObj = e.data;
						if(dataObj.CHECK_YN == 'Y'){
							dataObj.PRODT_START_DATE1=UniDate.getDateStr(dataObj.PRODT_START_DATE)	;
							dataObj.PRODT_END_DATE1=UniDate.getDateStr(dataObj.PRODT_END_DATE)	;
							dataObj.LOT_NO = panelResult.getValue('LOT_NAME')
							dataObj.PJT_CODE = masterForm.getValue('PJT_CODE');
							dataObj.PROJECT_NO = masterForm.getValue('PROJECT_NO');
							dataObj.REMARK = masterForm.getValue('REMARK');
							masterArray.push(dataObj);
							if(detailRecords != null && detailRecords.length > 0){
								for(var i = 0; i<detailRecords.length;i++){
									var dataObj2 = detailRecords[i].data;
									if(dataObj.SEQ_NO == dataObj2.SEQ_NO){
										dataObj2.PRODT_START_DATE1=UniDate.getDateStr(dataObj2.PRODT_START_DATE)	;
										dataObj2.PRODT_END_DATE1=UniDate.getDateStr(dataObj2.PRODT_END_DATE)	;
										dataObj2.PRODT_WKORD_DATE1=UniDate.getDateStr(masterForm.getValue('START_WKORD_DATE'));//입력조건의 작업지시일
										dataObj2.LOT_NO = panelResult.getValue('LOT_NAME')
										dataObj2.PJT_CODE = masterForm.getValue('PJT_CODE');
										dataObj2.PROJECT_NO = masterForm.getValue('PROJECT_NO');
										dataObj2.REMARK = masterForm.getValue('REMARK');
										dataObj2.EXPIRATION_DAY = UniDate.getDateStr(panelResult.getValue('EXPIRATION_DAY'));
										detailArray.push(dataObj2);
									}
								}
							}
						}
					});
				}
				paramMaster.masterArray = masterArray;
				paramMaster.detailArray = detailArray;
				paramMaster.sWkordNum	= null;
			Ext.getBody().mask('로딩중...','loading-indicator');
	         config = {
						params: [paramMaster],
						success: function(batch, option) {
							var master = batch.operations[0].getResultSet();
							sWkordNum = master.sWkordNum;
							sTopWkordNum = master.sTopWkordNum;
							topLotno =master.topLotno;
							panelResult.setValue('LOT_NAME',topLotno);
							masterForm.setValue('LOT_NAME',topLotno);
							detailStore.saveAfterOper();
						 }
					};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('s_pmp102ukrv_inGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		saveAfterOper: function(){
       		var masterRecords = detailGrid.getStore().getData().items;
			var detailRecords = detailGrid2.getStore().getData().items;

			if(masterRecords != null && masterRecords.length > 0){
				for(var  i = 0; i < masterRecords.length; i++){
					var e = masterRecords[i];
					var dataObj = e.data;
					if(dataObj.CHECK_YN == 'Y'){
						if(sWkordNum && sWkordNum.hasOwnProperty(dataObj.SEQ_NO)){
							e.set('WKORD_NUM',sWkordNum[dataObj.SEQ_NO]);
							if(detailRecords != null && detailRecords.length > 0){
								for(var j = 0; j<detailRecords.length;j++){
									var dataObj2 = detailRecords[j].data;
									if(dataObj.SEQ_NO == dataObj2.SEQ_NO){
										detailRecords[j].set('WKORD_NUM',sWkordNum[dataObj.SEQ_NO]);
										detailRecords[j].commit();
									}
								}
							}
					 	}
					 	e.set('REF_GUBUN','Y');
					 	detailGrid.getSelectionModel().deselect(e);
						e.commit();
					}
				}
				UniAppManager.app.fnFindProgWork(masterRecords[0].data);
				if(sWkordNum && JSON.stringify(sWkordNum) !== "{}"){
					panelResult.down('#btnPrint').setDisabled(false);
					UniAppManager.setToolbarButtons('save', false);
				}else{
					panelResult.down('#btnPrint').setDisabled(true);
				}
				panelResult.down('#btnPart').setDisabled(true);
			}
		}
	});

	var detailStore2 = Unilite.createStore('s_pmp102ukrv_inDetailStore2', {
		model: 's_pmp102ukrv_inDetailModel2',
		autoLoad: false,
		uniOpt: {
			//isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function(p) {
			var param= masterForm.getValues();
			param.TYPE='2';
			param.MRP_CONTROL_NUM = p.MRP_CONTROL_NUM;
			console.log(param);
			this.load({
				params : param,
				callback: function(records, operation, success) {
					console.log(records);
					if(records != null && records.length>0){
						UniAppManager.app.fnFindProgWork(p);
					}
			    }
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
			var orderNum = masterForm.getValue('ORDER_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['ORDER_NUM'] != orderNum) {
					record.set('ORDER_NUM', orderNum);
				}
			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			// 1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	// syncAll 수정

			if(inValidRecs.length == 0) {
					config = {
							params: [paramMaster],
							success: function(batch, option) {
								// 2.마스터 정보(Server 측 처리 시 가공)
								var master = batch.operations[0].getResultSet();
								masterForm.setValue("ORDER_NUM", master.ORDER_NUM);
								// 3.기타 처리
								masterForm.getForm().wasDirty = false;
								masterForm.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);
							 }
					};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('s_pmp102ukrv_inGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

    var detailGrid = Unilite.createGrid('s_pmp102ukrv_inGrid', {
    	layout: 'fit',
        region:'north',
        uniOpt: {
			expandLastColumn: true,
			useRowNumberer: false,
			onLoadSelectFirst : false
        },
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'refTool',
			text: '참조...',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'requestBtn',
					text: '생산계획참조',
					handler: function() {
						openProductionPlanWindow();
					}
				},{
					itemId: 'workBtn',
					text: '일괄작지전개',
					handler: function() {
					}
				},{
					itemId: 'dismemberBtn',
					text: '작지분할',
					handler: function() {
					}
				}]
			})
		}],
    	selModel : Ext.create("Ext.selection.CheckboxModel", {
		        	singleSelect : true ,
		        	checkOnly : false,showHeaderCheckbox :true,
		            listeners: {
		    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
		    				console.log(selectRecord);
		    				UniAppManager.app.fnFindProgWork(selectRecord.data);
		    				if(selectRecord.get("CHECK_YN")=='Y'){
		    					selectRecord.set("CHECK_YN",'N');
		    				}else{
		    					selectRecord.set("CHECK_YN",'Y');
		    				}
		    			},
			    		deselect:  function(grid, selectRecord, index, eOpts ){
			    			if(selectRecord.get("CHECK_YN")=='Y'){
		    					selectRecord.set("CHECK_YN",'N');
		    				}else{
		    					selectRecord.set("CHECK_YN",'Y');
		    				}
			    		}
		    		}
		        }),
    	store: detailStore,
    	uniOpt:{
            onLoadSelectFirst : false
        },
        columns: [
			{dataIndex: 'GUBUN'					, width: 40  , hidden: true},
			{dataIndex: 'DIV_CODE'				, width: 80  , hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	 	, width: 113},
			{dataIndex: 'ITEM_CODE'				, width: 120},
			{dataIndex: 'ITEM_NAME'				, width: 140},
			{dataIndex: 'SPEC'					, width: 140},
			{dataIndex: 'STOCK_UNIT'			, width: 100},
			{dataIndex: 'PRODT_START_DATE'		, width: 100},
			{dataIndex: 'PRODT_END_DATE'		, width: 100},
			{dataIndex: 'WKORD_Q'				, width: 100},
			{dataIndex: 'SUPPLY_TYPE'			, width: 75},
			{dataIndex: 'WKORD_NUM'				, width: 130},
			{dataIndex: 'WK_PLAN_NUM'			, width: 115},
			{dataIndex: 'PRODUCT_LDTIME'		, width: 66 , hidden: true},
			{dataIndex: 'SEQ_NO'				, width: 66 , hidden: true},
			{dataIndex: 'REF_GUBUN'				, width: 53 , hidden: true},
			{dataIndex: 'PROJECT_NO'			, width: 66 , hidden: true},
			{dataIndex: 'PJT_CODE'				, width: 66 , hidden: true},
			{dataIndex: 'REMARK'				, width: 66 , hidden: true},
			{dataIndex: 'LOT_NO'				, width: 66 , hidden: true}
		],
		listeners: {
			beforeselect  : function( grid, record, index, eOpts ) {
				if(record.data.REF_GUBUN == 'Y'){
					return false;
				}
			},
          	beforeedit  : function( editor, e, eOpts ) {
				if(e.record.data.REF_GUBUN == 'Y'){
					return false;
				}
				if(UniUtils.indexOf(e.field, ['PRODT_START_DATE','PRODT_END_DATE','WKORD_Q','SUPPLY_TYPE','WORK_SHOP_CODE'])){
					return true;
				}
				else{
					return false;
				}
			}
       	},
		disabledLinkButtons: function(b) {
		},
		setEstiData:function(record) {},
		setRefData: function(record) {}
    });


    var detailGrid2 = Unilite.createGrid('s_pmp102ukrv_inGrid2', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: true,
			useRowNumberer: false
        },

    	store: detailStore2,
        columns: [
			{dataIndex: 'LINE_SEQ'        	, width: 100},
			{dataIndex: 'PROG_WORK_CODE'  	, width: 120},
			{dataIndex: 'PROG_WORK_NAME'   	, width: 150},
			{dataIndex: 'PROG_UNIT_Q'     	, width: 120},
			{dataIndex: 'WKORD_Q'         	, width: 140},
			{dataIndex: 'PROG_UNIT'       	, width: 140},
			{dataIndex: 'PROG_RATE'       	, width: 53 , hidden: true},
			{dataIndex: 'DIV_CODE'        	, width: 73 , hidden: true},
			{dataIndex: 'WKORD_NUM'       	, width: 130 , hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'  	, width: 80 , hidden: true},
			{dataIndex: 'PRODT_START_DATE'	, width: 75 , hidden: true},
			{dataIndex: 'PRODT_END_DATE'  	, width: 100, hidden: true},
			{dataIndex: 'PRODT_WKORD_DATE'	, width: 140, hidden: true},
			{dataIndex: 'ITEM_CODE'       	, width: 140, hidden: true},
			{dataIndex: 'REMARK'          	, width: 53 , hidden: true},
			{dataIndex: 'LOT_NO'          	, width: 73 , hidden: true},
			{dataIndex: 'WK_PLAN_NUM'     	, width: 115, hidden: true},
			{dataIndex: 'LINE_END_YN'     	, width: 66 , hidden: true},
			{dataIndex: 'ITEM_NAME'       	, width: 66 , hidden: true},
			{dataIndex: 'SPEC'            	, width: 53 , hidden: true},
			{dataIndex: 'WORK_END_YN'     	, width: 66 , hidden: true},
			{dataIndex: 'PROJECT_NO'     	, width: 66 , hidden: true},
			{dataIndex: 'PJT_CODE'     	, width: 66 , hidden: true},
			{dataIndex: 'SEQ_NO'     	, width: 66 , hidden: true},
			{dataIndex: 'TOP_WKORD_NUM'   	, width: 66 , hidden: true},
			{dataIndex: 'EQUIP_CODE'                  ,       width: 110, hidden: isEquipCode
				 ,'editor' : Unilite.popup('EQU_MACH_CODE_G',{
		                     textFieldName:'EQU_MACH_NAME',
		                     DBtextFieldName: 'EQU_MACH_NAME',
		                     autoPopup: true,
		                     listeners: {'onSelected': {
		                         fn: function(records, type) {
		                             var grdRecord = detailGrid2.uniOpt.currentRecord;
		                             grdRecord.set('EQUIP_CODE',records[0]['EQU_MACH_CODE']);
		                             grdRecord.set('EQUIP_NAME',records[0]['EQU_MACH_NAME']);
		                         },
		                         scope: this
		                     },
		                     'onClear': function(type) {
		                         grdRecord = detailGrid2.getSelectedRecord();
		                         grdRecord.set('EQUIP_CODE', '');
		                         grdRecord.set('EQUIP_NAME', '');
		                     },
		                     applyextparam: function(popup){
		                         var param =  panelResult.getValues();
		                         popup.setExtParam({'DIV_CODE': param.DIV_CODE});
		                     }
		                 }
		     })
			},
            {dataIndex: 'EQUIP_NAME'                  ,       width: 200, hidden: isEquipCode
				 ,'editor' : Unilite.popup('EQU_MACH_CODE_G',{
                     textFieldName:'EQU_MACH_NAME',
                     DBtextFieldName: 'EQU_MACH_NAME',
                     autoPopup: true,
                     listeners: {'onSelected': {
                                 fn: function(records, type) {
                                     var grdRecord = detailGrid2.uniOpt.currentRecord;
                                     grdRecord.set('EQUIP_CODE',records[0]['EQU_MACH_CODE']);
                                     grdRecord.set('EQUIP_NAME',records[0]['EQU_MACH_NAME']);
                                 },
                                 scope: this
                             },
                             'onClear': function(type) {
                                 grdRecord = detailGrid2.getSelectedRecord();
                                 grdRecord.set('EQUIP_CODE', '');
                                 grdRecord.set('EQUIP_NAME', '');
                             },
                             applyextparam: function(popup){
                                 var param =  panelResult.getValues();
                                 popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                             }
                      }
             })
            },
            {dataIndex: 'MOLD_CODE'                  ,       width: 110, hidden: true, autoPopup: true
                ,'editor' : Unilite.popup('MOLD_CODE_G',{textFieldName:'MOLD_CODE', textFieldWidth:100, DBtextFieldName: 'MOLD_CODE',
			    			autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        grdRecord = detailGrid2.getSelectedRecord();
                                        Ext.each(records, function(record,i) {
                                            grdRecord.set('MOLD_CODE', record.MOLD_CODE);
                                            grdRecord.set('MOLD_NAME', record.MOLD_NAME);
                                        });
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = detailGrid2.getSelectedRecord();
                                    grdRecord.set('MOLD_CODE', '');
                                    grdRecord.set('MOLD_NAME', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelResult.getValues();
                                    record = detailGrid2.getSelectedRecord();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                    if(Ext.isEmpty(record.get('PROG_WORK_CODE'))) {
                                        popup.setExtParam({'ITEM_CODE': param.ITEM_CODE});
                                        popup.setExtParam({'PROG_WORK_CODE': record.get('PROG_WORK_CODE')});
                                    }
                                }
                            }
                })
            },
            {dataIndex: 'MOLD_NAME'                  ,       width: 200, hidden: true, autoPopup: true
                ,'editor' : Unilite.popup('MOLD_CODE_G',{textFieldName:'MOLD_NAME', textFieldWidth:100, DBtextFieldName: 'MOLD_NAME',
			    			autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        grdRecord = detailGrid2.getSelectedRecord();
                                        Ext.each(records, function(record,i) {
                                            grdRecord.set('MOLD_CODE', record.MOLD_CODE);
                                            grdRecord.set('MOLD_NAME', record.MOLD_NAME);
                                        });
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = detailGrid2.getSelectedRecord();
                                    grdRecord.set('MOLD_CODE', '');
                                    grdRecord.set('MOLD_NAME', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelResult.getValues();
                                    record = detailGrid2.getSelectedRecord();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                    if(Ext.isEmpty(record.get('PROG_WORK_CODE'))) {
                                        popup.setExtParam({'ITEM_CODE': param.ITEM_CODE});
                                        popup.setExtParam({'PROG_WORK_CODE': record.get('PROG_WORK_CODE')});
                                    }
                                }
                            }
                })
            }
		],listeners: {
			beforeedit  : function( editor, e, eOpts ) {
			 	var  refGubun  = '';
			 	var  records 	 =  detailStore.data.items;
			 	var  seqNo		 = '';
			 	grdRecord = detailGrid2.getSelectedRecord();
			 	seqNo = grdRecord.data.SEQ_NO;

			 	Ext.each(records, function(item, i){
					if(item.get("SEQ_NO") == seqNo){
						refGubun = item.get("REF_GUBUN");
					}
			 	})
				if(refGubun == 'N'){
					if (UniUtils.indexOf(e.field,['EQUIP_CODE','EQUIP_NAME','MOLD_CODE','MOLD_NAME'])){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}
			}
       	},
		disabledLinkButtons: function(b) {
		},
		setItemData: function(record, dataClear) {},
		setEstiData:function(record) {},
		setRefData: function(record) {}
    });

    // 생산계획 참조
    var productionPlanSearch = Unilite.createSearchForm('productionPlanForm', {
            layout :  {type : 'uniTable', columns : 2},
			    items: [{
		        	fieldLabel: '사업장',
		        	name: 'DIV_CODE',
		        	xtype: 'uniCombobox',
		        	comboType: 'BOR120',
		        	hidden:true
		        },{
		        	fieldLabel: '작업장',
		        	name: 'WORK_SHOP_CODE',
		        	xtype: 'uniCombobox',
		        	comboType:'WU'
		        },{
		        	fieldLabel: '계획일자',
		            xtype: 'uniDateRangefield',
		            startFieldName: 'PRODT_PLAN_DATE_FR',
					endFieldName: 'PRODT_PLAN_DATE_TO',
		            width: 315,
		            startDate: UniDate.get('startOfMonth'),
		            endDate: UniDate.get('endOfMonth'),
		        	allowBlank:false
				},
					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '품목',
						validateBlank:false,
						autoPopup: true,
						valueFieldName: 'ITEM_CODE',
		        		textFieldName:'ITEM_NAME'
			})]
	});

    Unilite.defineModel('s_pmp102ukrv_inProductionPlanModel', {
    	fields: [
	    	{name: 'GUBUN'        			, text: '선택'			, type: 'string'},
	    	{name: 'DIV_CODE'				, text: '제조처'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'			, text: '작업장'			, type: 'string' , comboType: 'W'},
			{name: 'WK_PLAN_NUM'			, text: '생산계획번호'		, type: 'string'},
			{name: 'PROD_ITEM_CODE'		, text: '제품'		, type: 'string'},
			{name: 'ITEM_CODE' 				, text: '품목'			, type: 'string'},
			{name: 'ITEM_NAME' 				, text: '품목명'			, type: 'string'},
			{name: 'SPEC' 					, text: '규격'			, type: 'string'},
			{name: 'STOCK_UNIT'				, text: '단위'			, type: 'string'},
			{name: 'WK_PLAN_Q' 				, text: '계획량'			, type: 'uniQty'},
			{name: 'PRODUCT_LDTIME'			, text: '제조L/T'			, type: 'string'},
			{name: 'PRODT_START_DATE'		, text: '착수예정일'		, type: 'uniDate'},
			{name: 'PRODT_PLAN_DATE'		, text: '계획완료일'		, type: 'uniDate'},
			{name: 'ORDER_NUM'	 			, text: '수주번호'			, type: 'string'},
			{name: 'ORDER_DATE' 			, text: '수주일'			, type: 'string'},
			{name: 'ORDER_Q' 				, text: '수주량'			, type: 'uniQty'},
			{name: 'CUSTOM_CODE'	 		, text: '거래처명'			, type: 'string'},
			{name: 'DVRY_DATE' 				, text: '납기일'			, type: 'uniDate'},
			{name: 'PROJECT_NO' 			, text: '프로젝트 번호'			, type: 'string'},
			{name: 'PJT_CODE' 				, text: '프로젝트번호'		, type: 'string'},
			{name: 'EXPIRATION_DAY' 				, text: '유효기간'		, type: 'int'}
		]
	});

	var productionPlanStore = Unilite.createStore('s_pmp102ukrv_inProductionPlanStore', {
			model: 's_pmp102ukrv_inProductionPlanModel',
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
                	read    : 's_pmp102ukrv_inService.selectEstiList'
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
				var param= productionPlanSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});


	var productionPlanGrid = Unilite.createGrid('s_pmp102ukrv_inproductionPlanGrid', {
    	layout : 'fit',
    	store: productionPlanStore,
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
			uniOpt:{
	        	onLoadSelectFirst : false
	        },
        columns: [
        	{dataIndex: 'GUBUN'        		      	, width:0  ,hidden: true},
			{dataIndex: 'DIV_CODE'			      	, width:0  ,hidden: true},
	        {dataIndex: 'WORK_SHOP_CODE'		    , width:105},
	        {dataIndex: 'WK_PLAN_NUM'		      	, width:100,hidden: true},
	        {dataIndex: 'PROD_ITEM_CODE' 			    , width:100},
	        {dataIndex: 'ITEM_CODE' 			    , width:100},
	        {dataIndex: 'ITEM_NAME' 			    , width:126},
	        {dataIndex: 'SPEC' 				      	, width:120},
	        {dataIndex: 'STOCK_UNIT'			    , width:40},
	        {dataIndex: 'WK_PLAN_Q' 			    , width:73},
	        {dataIndex: 'PRODUCT_LDTIME'		    , width:65},
	        {dataIndex: 'PRODT_START_DATE'      	, width:80},
	        {dataIndex: 'PRODT_PLAN_DATE'	      	, width:80},
	        {dataIndex: 'ORDER_NUM'	 		      	, width:115},
	        {dataIndex: 'ORDER_DATE' 		      	, width:80},
	        {dataIndex: 'ORDER_Q' 			      	, width:73},
	        {dataIndex: 'CUSTOM_CODE'	       		, width:100},
	        {dataIndex: 'DVRY_DATE' 			    , width:80 ,hidden: true},
	        {dataIndex: 'PROJECT_NO' 		      	, width:80 ,hidden: true},
	        {dataIndex: 'PJT_CODE' 			      	, width:80 ,hidden: true},
	        {dataIndex: 'EXPIRATION_DAY' 			, width:80 ,hidden: false}
		],
		listeners: {
	          onGridDblClick: function(grid, record, cellIndex, colName) {
		          	this.returnData(record);
		          	referProductionPlanWindow.hide();
	          }
          },
          	returnData: function(record)	{
	          	if(Ext.isEmpty(record))	{
	          		record = this.getSelectedRecord();
	          		if(Ext.isEmpty(record))	{
	          			return false;
	          		}
	          	}
	          	var year = UniDate.getDbDateStr(record.get('PRODT_START_DATE')).substring(2,4);
				var day = UniDate.getDbDateStr(record.get('PRODT_START_DATE')).substring(4,2);
				 panelResult.setValue('EXPIRATION_DAY2', record.get('EXPIRATION_DAY'));
				 panelResult.setValue('PRODUCT_LDTIME', record.get('PRODUCT_LDTIME'));
				var expirationDay = panelResult.getValue('EXPIRATION_DAY2');
				var productLdtime = panelResult.getValue('PRODUCT_LDTIME');
			//	var LOT_NO = year + this.returnMonth() + day;

	          	masterForm.setValues({'DIV_CODE':record.get('DIV_CODE'),   /*사업장*/		    			 /*작업지시번호*/
	          						  'WORK_SHOP_CODE':record.get('WORK_SHOP_CODE'), /* 작업장*/'ITEM_CODE':record.get('ITEM_CODE'),				 /*품목코드*/
	          						  'ITEM_NAME':record.get('ITEM_NAME'),	/*품목명*/		  'SPEC':record.get('SPEC'), 						 /*규격*/
	          						  'PRODT_START_DATE':record.get('PRODT_START_DATE'),
	          						  'PRODT_END_DATE':record.get('PRODT_PLAN_DATE'),
	          						  'WKORD_Q':record.get('WK_PLAN_Q'),					  'PROG_UNIT':record.get('STOCK_UNIT'),
	          						  'PROJECT_NO':record.get('PROJECT_NO'),
	          						  'PJT_CODE':record.get('PJT_CODE'),
	          						  'ORDER_NUM':record.get('ORDER_NUM'), 	/* 수주번호*/		  'ORDER_Q':record.get('ORDER_Q'),  				/* 수주량*/
	          						  'DVRY_DATE':record.get('DVRY_DATE'),  /* 납기일*/		  'CUSTOM_CODE':record.get('CUSTOM_CODE')
	          						  ,'WK_PLAN_NUM':record.get('WK_PLAN_NUM')
	          						  ,'START_WKORD_DATE':productionPlanSearch.getValue('PRODT_PLAN_DATE_FR')
	          						  });

				panelResult.setValues({'DIV_CODE':record.get('DIV_CODE'),   /*사업장*/		    			 /*작업지시번호*/
	          						  'WORK_SHOP_CODE':record.get('WORK_SHOP_CODE'), /* 작업장*/'ITEM_CODE':record.get('ITEM_CODE'),				 /*품목코드*/
	          						  'ITEM_NAME':record.get('ITEM_NAME'),	/*품목명*/		  'SPEC':record.get('SPEC'), 						 /*규격*/
	          						  'PRODT_START_DATE':record.get('PRODT_START_DATE'),
	          						  'PRODT_END_DATE':record.get('PRODT_PLAN_DATE'),
	          						  'WKORD_Q':record.get('WK_PLAN_Q'),					  'PROG_UNIT':record.get('STOCK_UNIT'),
	          						  'PROJECT_NO':record.get('PROJECT_NO'),
	          						  'PJT_CODE':record.get('PJT_CODE'),
	          						  'ORDER_NUM':record.get('ORDER_NUM'), 	/* 수주번호*/		  'ORDER_Q':record.get('ORDER_Q'),  				/* 수주량*/
	          						  'DVRY_DATE':record.get('DVRY_DATE'),  /* 납기일*/		  'CUSTOM_CODE':record.get('CUSTOM_CODE'),
	          						  'WK_PLAN_NUM':record.get('WK_PLAN_NUM'),                'START_WKORD_DATE':productionPlanSearch.getValue('PRODT_PLAN_DATE_FR')
	          						  });
				fnCreateLotno(UniDate.getDbDateStr(record.get('PRODT_START_DATE')), record.get('ITEM_CODE'));
				fnCalDate(expirationDay, productLdtime)
	          	masterForm.getField('DIV_CODE').setReadOnly( true );
				//masterForm.getField('WORK_SHOP_CODE').setReadOnly( true );
				masterForm.getField('ITEM_CODE').setReadOnly( true );
				masterForm.getField('ITEM_NAME').setReadOnly( true );
				masterForm.getField('SPEC').setReadOnly( true );
				masterForm.getField('PROG_UNIT').setReadOnly( true );

				panelResult.getField('DIV_CODE').setReadOnly( true );
				//panelResult.getField('WORK_SHOP_CODE').setReadOnly( true );
				panelResult.getField('ITEM_CODE').setReadOnly( true );
				panelResult.getField('ITEM_NAME').setReadOnly( true );
				panelResult.getField('SPEC').setReadOnly( true );
				panelResult.getField('PROG_UNIT').setReadOnly( true );
          },
	      returnMonth : function(){
	      	if(new Date().getMonth()+1 == '1'){
	      		return 'A';
	      	}else if(new Date().getMonth()+1 == '2'){
	      		return 'B';
	      	}else if(new Date().getMonth()+1 == '3'){
	      		return 'C';
	      	}else if(new Date().getMonth()+1 == '4'){
	      		return 'D';
	      	}else if(new Date().getMonth()+1 == '5'){
	      		return 'E';
	      	}else if(new Date().getMonth()+1 == '6'){
	      		return 'F';
	      	}else if(new Date().getMonth()+1 == '7'){
	      		return 'G';
	      	}else if(new Date().getMonth()+1 == '8'){
	      		return 'H';
	      	}else if(new Date().getMonth()+1 == '9'){
	      		return 'J';
	      	}else if(new Date().getMonth()+1 == '10'){
	      		return 'K';
	      	}else if(new Date().getMonth()+1 == '11'){
	      		return 'L';
	      	}else if(new Date().getMonth()+1 == '12'){
	      		return 'M';
	      	}else{
	      		return false;
	      	}
	      }
    });


	function openProductionPlanWindow() {
		productionPlanSearch.setValue('DIV_CODE', masterForm.getValue('DIV_CODE'));
		if(!referProductionPlanWindow) {
			referProductionPlanWindow = Ext.create('widget.uniDetailWindow', {
                title: '생산계획정보',
                width: 1080,
                height: 580,
                layout:{type:'vbox', align:'stretch'},
                items: [productionPlanSearch, productionPlanGrid],
                tbar:  ['->',
								        {	itemId : 'saveBtn',
											text: '조회',
											handler: function() {
												productionPlanStore.loadStoreRecords();
											},
											disabled: false
										},
										{	itemId : 'confirmBtn',
											text: '생산계획적용',
											handler: function() {
												productionPlanGrid.returnData();
											},
											disabled: false
										},
										{	itemId : 'confirmCloseBtn',
											text: '생산계획적용 후 닫기',
											handler: function() {
												productionPlanGrid.returnData();
												referProductionPlanWindow.hide();
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											text: '닫기',
											handler: function() {
												referProductionPlanWindow.hide();
											},
											disabled: false
										}],
                listeners : {beforehide: function(me, eOpt)	{
                						},
                			 beforeclose: function( panel, eOpts )	{
                			 			},
                			 beforeshow: function ( me, eOpts )	{
                			 	productionPlanStore.loadStoreRecords();
                			 }
                }
			})
		}

		referProductionPlanWindow.show();
		referProductionPlanWindow.center();
    }

      Unilite.Main ({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		panelResult, detailGrid, detailGrid2
         	]
      	},
      	masterForm
      	],
		id: 's_pmp102ukrv_inApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['query', 'newData'], false);
			detailGrid.disabledLinkButtons(false);
			panelResult.down('#btnWorkPlan').setDisabled(false);
        	panelResult.down('#btnExp').setDisabled(false);
        	panelResult.down('#btnPart').setDisabled(true);
        	panelResult.down('#btnPrint').setDisabled(true);
			this.setDefault();
		},
		fnProgSeqInfo: function(record){
				if(!record.get("ITEM_CODE")){
					return false;
				}
				var param= record.data;

				pmp110ukrvService.selectProgInfo(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
							if(provider && provider.length > 0){
								provider.forEach(function(e){
									var r = e;
									if(!r.PROG_UNIT){
										r.PROG_UNIT = masterForm.getValue("PROG_UNIT");
									}
									r.WKORD_Q = record.get("WKORD_Q");
									r.PROG_RATE = 0;
									r.DIV_CODE = masterForm.getValue("DIV_CODE");
									r.WKORD_NUM = '';
									r.WORK_SHOP_CODE = record.get("WORK_SHOP_CODE");
									r.PRODT_START_DATE = record.get("PRODT_START_DATE");
									r.PRODT_END_DATE = record.get("PRODT_END_DATE");
									r.PRODT_WKORD_DATE = record.get("PRODT_START_DATE");
									r.ITEM_CODE = record.get("ITEM_CODE");
									r.REMARK = masterForm.getValue("REMARK");
									r.WK_PLAN_NUM = masterForm.getValue("WK_PLAN_NUM");
									r.LINE_END_YN = 'Y';
									r.ITEM_NAME = masterForm.getValue("ITEM_NAME");
									r.SPEC = masterForm.getValue("SPEC");
									r.WORK_END_YN = 'N';
									r.PROJECT_NO = masterForm.getValue("PROJECT_NO");
									r.PJT_CODE = masterForm.getValue("PJT_CODE");
									r.LOT_NO = masterForm.getValue("LOT_NO");
									r.SEQ_NO = record.get("SEQ_NO");
									r.TOP_WKORD_NUM = '';
									detailStore2.insert(detailStore2.getCount(), r);
									UniAppManager.app.fnFindProgWork(record.data);
								})
							}
						}
				});
		},
		onQueryButtonDown: function() {
			if(masterForm.setAllFieldsReadOnly(true)){
				if(masterForm.getValue("PRODT_START_DATE")>masterForm.getValue("PRODT_END_DATE")){
					alert("착수예정일이  완료예정일보다 클수는 없습니다.");
					return false;
				}
				if(masterForm.getValue("PRODT_START_DATE")<masterForm.getValue("START_WKORD_DATE")){

					alert("작업지시일이 착수예정일보다 클수는 없습니다.");
					return false;
				}
				if(masterForm.getValue("WKORD_Q")< 0){
					alert("0보다 큰수만 입력가능합니다.");
					return false;
				}
				detailGrid.getStore().loadStoreRecords();
			}
		},
		onNewDataButtonDown: function(p)	{
			var record = detailGrid.getSelectedRecord();
			var store = detailGrid.getStore()
			var index = store.getCount();
			if(record){
				index = detailGrid.getStore().indexOf(record)+1;
			}
			var r = {};
			if(p){
				r = p;
			}
			store.insert(index,r);
			detailGrid.getSelectionModel().selectNext();
		},
		onResetButtonDown: function() {
			sWkordNum = null;
			masterForm.clearForm();
			panelResult.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailGrid2.reset();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('ISSUE_REQ_Q') > 0 || selRow.get('OUTSTOCK_Q') > 0 ) {
					alert('<t:message code="unilite.msg.sMS216" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
				}else {
					detailGrid.deleteSelectedRow();
				}
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('s_pmp102ukrv_inAdvanceSerch');
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
			var fp = Ext.getCmp('s_pmp102ukrv_inFileUploadPanel');
        	if(detailStore.isDirty() || fp.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
        	masterForm.setValue('DIV_CODE',UserInfo.divCode);
        	masterForm.setValue('ORDER_DATE',new Date());
        	masterForm.setValue('TAX_TYPE','1');
        	masterForm.setValue('STATUS','1');
        	masterForm.setValue('START_WKORD_DATE',new Date());
        	masterForm.setValue('PRODT_START_DATE',new Date());
        	masterForm.setValue('PRODT_END_DATE',new Date());
        	masterForm.setValue('WKORD_Q',0);
        	panelResult.setValue('START_WKORD_DATE',new Date());
        	panelResult.setValue('PRODT_START_DATE',new Date());
        	panelResult.setValue('PRODT_END_DATE',new Date());
        	panelResult.setValue('WKORD_Q',0);
        	masterForm.getField('DIV_CODE').setReadOnly( false );
			masterForm.getField('WORK_SHOP_CODE').setReadOnly( false );
			masterForm.getField('ITEM_CODE').setReadOnly( false );
			masterForm.getField('ITEM_NAME').setReadOnly( false );
			panelResult.getField('DIV_CODE').setReadOnly( false );
			panelResult.getField('WORK_SHOP_CODE').setReadOnly( false );
			panelResult.getField('ITEM_CODE').setReadOnly( false );
			panelResult.getField('ITEM_NAME').setReadOnly( false );
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		},
        checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('CUSTOM_CODE')))	{
				alert('<t:message code="unilite.msg.sMSR213" default="거래처"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}

			/**
			 * 여신한도 확인
			 */
			if(!masterForm.fnCreditCheck())	{
				return false;
			}

			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return masterForm.setAllFieldsReadOnly(true);
        },
        fnDisable:function() {
        	masterForm.setAllFieldsReadOnly(true,true);
        	panelResult.setAllFieldsReadOnly(true,true);
        	panelResult.down('#btnWorkPlan').setDisabled(true);
        	panelResult.down('#btnExp').setDisabled(true);
        	panelResult.down('#btnPart').setDisabled(false);

        },
        fnFindProgWork:function(p) {
        	detailStore2.clearFilter();
        	detailStore2.filterBy (function(record){
        		if(p.SEQ_NO == record.get('SEQ_NO')){
        			return true;
        		}else{
        			return false;
        		}
        	});
        },
        setDetailRecordFilter: function(record,fieldName,newValue){
        	var detailRecords = detailGrid2.getStore().getData().items;
			if(detailRecords != null && detailRecords.length > 0){
				detailRecords.forEach(function(e){
						var dataObj = e.data;
						if(dataObj.SEQ_NO == record.get("SEQ_NO")){
							e.set(fieldName,newValue);
						}
				});
			}
        }
	});

    function fnCreateLotno(startDate, itemCode){
    	var param ;
    	param= masterForm.getValues();
    	month = startDate.substring(4,6);
    	lotMonth = '';
    	if(month == '01'){
    		lotMonth = 'A';
    	}else if(month == '02'){
    		lotMonth = 'B';
    	}else if(month == '03'){
    		lotMonth = 'C';
    	}else if(month == '04'){
    		lotMonth = 'D';
    	}else if(month == '05'){
    		lotMonth = 'E';
    	}else if(month == '06'){
    		lotMonth = 'F';
    	}else if(month == '07'){
    		lotMonth = 'G';
    	}else if(month == '08'){
    		lotMonth = 'H';
    	}else if(month == '09'){
    		lotMonth = 'I';
    	}else if(month == '10'){
    		lotMonth = 'J';
    	}else if(month == '11'){
    		lotMonth = 'K';
    	}else if(month == '12'){
    		lotMonth = 'L';
    	}

    	s_pmp102ukrv_inService.selectWhline(param, function(provider, response){
    		if(!Ext.isEmpty(provider)){
    			var autoLotNo ;
    			autoLotNo = startDate.substring(2,4) + lotMonth +  startDate.substring(6,8) + provider[0].LINE + itemCode.slice(-3);
    			panelResult.setValue('LOT_NAME', autoLotNo);
				masterForm.setValue('LOT_NAME', autoLotNo);
    			return autoLotNo;
    		}
    	});
    }

    function fnCalDate(expirationDay, productLdtime){
		var prodtEndDate ;
		var calExpirationDay ;
		if(productLdtime == 1 || productLdtime == 0 || Ext.isEmpty(productLdtime)){
			panelResult.setValue('PRODT_END_DATE', panelResult.getValue('PRODT_START_DATE'));
			masterForm.setValue('PRODT_END_DATE', panelResult.getValue('PRODT_START_DATE'));
		}else{
			prodtEndDate = UniDate.add(panelResult.getValue('PRODT_START_DATE'), { days: productLdtime - 1 });
			panelResult.setValue('PRODT_END_DATE', prodtEndDate);
			masterForm.setValue('PRODT_END_DATE', prodtEndDate);
		}
		if(expirationDay == 0 || Ext.isEmpty(expirationDay)){
			calExpirationDay = UniDate.add(panelResult.getValue('PRODT_START_DATE'), {months: +3});
			calExpirationDay = UniDate.add(calExpirationDay, { days: - 1 })
			masterForm.setValue('EXPIRATION_DAY',calExpirationDay);
			panelResult.setValue('EXPIRATION_DAY',calExpirationDay);
		}else{
			calExpirationDay = UniDate.add(panelResult.getValue('PRODT_START_DATE'), {months: + expirationDay});
			calExpirationDay = UniDate.add(calExpirationDay, { days: - 1 });
			masterForm.setValue('EXPIRATION_DAY',calExpirationDay);
			panelResult.setValue('EXPIRATION_DAY',calExpirationDay);
		}

    }
    /**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if(newValue == oldValue){
				return rv;
			}
			console.log(newValue +"+"+ oldValue);
			switch(fieldName) {
				case "WORK_SHOP_CODE":
					if(workShopCodeCount==1){
    					var param={
						"DIV_CODE":masterForm.getValue("DIV_CODE"),
						"WORK_SHOP_CODE":newValue,
						"ITEM_CODE":record.get("ITEM_CODE")
						}
						Ext.Ajax.request({
				            url     : CPATH+'/prodt/selectProgInfo.do',
				            params  : param,
				            async   : false,
				            success : function(response){
				                if(response.status == "200"){
				                  var provider = JSON.parse(response.responseText);
				                  if(provider && provider.length > 0){

				                  	var records = detailStore2.data.items;
				                  	for(var i = records.length-1; i>=0; i--){
				                  		var e = records[i];
										if(e && e.get("SEQ_NO") == record.get("SEQ_NO")){
											detailStore2.remove(e);
										}
				                  	}
				                  	provider.forEach(function(e){
										var r = e;
										if(!r.PROG_UNIT){
											r.PROG_UNIT = masterForm.getValue("PROG_UNIT");
										}
										r.WKORD_Q = record.get("WKORD_Q");
										r.PROG_RATE = 0;
										r.DIV_CODE = masterForm.getValue("DIV_CODE");
										r.WKORD_NUM = '';
										r.WORK_SHOP_CODE = record.get("WORK_SHOP_CODE");
										r.PRODT_START_DATE = record.get("PRODT_START_DATE");
										r.PRODT_END_DATE = record.get("PRODT_END_DATE");
										r.PRODT_WKORD_DATE = record.get("PRODT_START_DATE");
										r.ITEM_CODE = record.get("ITEM_CODE");
										r.REMARK = masterForm.getValue("REMARK");
										r.WK_PLAN_NUM = masterForm.getValue("WK_PLAN_NUM");
										r.LINE_END_YN = 'Y';
										r.ITEM_NAME = masterForm.getValue("ITEM_NAME");
										r.SPEC = masterForm.getValue("SPEC");
										r.WORK_END_YN = 'N';
										r.PROJECT_NO = masterForm.getValue("PROJECT_NO");
										r.PJT_CODE = masterForm.getValue("PJT_CODE");
										r.LOT_NO = masterForm.getValue("LOT_NO");
										r.SEQ_NO = record.get("SEQ_NO");
										r.TOP_WKORD_NUM = '';
										detailStore2.insert(detailStore2.getCount(), r);
										UniAppManager.app.fnFindProgWork(record.obj.data);
									})
				                  }else{
				                  	rv='해당 작업장에 대한 공정정보가 없습니다.'+'\n'+'공정수순등록에서  공정정보를 입력하세요';
				                  }
				                }
				            }
				        });
					}
					workShopCodeCount++;
					if(workShopCodeCount==4){
						workShopCodeCount=1
					}
					if(rv != true){
						workShopCodeCount=1;
					}
				break;

				case  "PRODT_START_DATE" :
					var sPlWkordDt = newValue;
	                var sEnWkordDt = record.get("PRODT_END_DATE");
	                var sEnMasterDt = masterForm.getValue("PRODT_END_DATE");
	                var txtStWkordDt = masterForm.getValue("PRODT_START_DATE");
					if(sPlWkordDt >　sEnWkordDt){
						rv='착수예정일이  완료예정일보다 클수는 없습니다.';
						break;
					}else if(sEnWkordDt >　sEnMasterDt){
						rv='완료예정일이 범위를 초과했습니다. ';
						break;
					}else if(txtStWkordDt >　sPlWkordDt){
						rv='착수예정일은 작업지시일보다 이후 잘짜이어야 합니다.';
						break;
					}
					UniAppManager.app.setDetailRecordFilter(record,fieldName,newValue);
				break;

				case  "PRODT_END_DATE" :
					var sPlWkordDt = record.get("PRODT_START_DATE");
	                var sEnWkordDt = newValue;
	                var sEnMasterDt = masterForm.getValue("PRODT_END_DATE");
	                var txtStWkordDt = masterForm.getValue("PRODT_START_DATE");
					if(sPlWkordDt >　sEnWkordDt){
						rv='착수예정일이  완료예정일보다 클수는 없습니다.';
						break;
					}else if(sEnWkordDt >　sEnMasterDt){
						rv='완료예정일이 범위를 초과했습니다. ';
						break;
					}else if(txtStWkordDt >　sPlWkordDt){
						rv='착수예정일은 작업지시일보다 이후 잘짜이어야 합니다.';
						break;
					}
					UniAppManager.app.setDetailRecordFilter(record,fieldName,newValue);
				break;

				case "WKORD_Q" :
					if(newValue <= 0){
						rv=Msg.sMB074;
						break;
					}
					var records = detailStore2.data.items;
					Ext.each(records, function(r,i){
						if(r.get("SEQ_NO") == record.get("SEQ_NO")){
							r.set('WKORD_Q',(newValue * r.get("PROG_UNIT_Q")));
						}
					});
				break;

				default:
				break;
			}
			return rv;
		}
	}); // validator
}
</script>