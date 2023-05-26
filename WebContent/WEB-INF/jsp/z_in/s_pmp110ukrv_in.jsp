<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp110ukrv_in"  >
    <t:ExtComboStore comboType="BOR120" pgmId="s_pmp110ukrv_in" />           <!-- 사업장 -->
    <t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
    <t:ExtComboStore comboType="WU" /><!-- 작업장  -->
    <t:ExtComboStore comboType="AU" comboCode="B013"/> <!-- 단위 -->
    <t:ExtComboStore comboType="AU" comboCode="B014"/> <!-- 조달구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A" />   <!-- 가공창고 -->
    <t:ExtComboStore comboType="AU" comboCode="P120"/> <!-- 대체여부 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var searchInfoWindow;   //SearchInfoWindow : 검색창
var referProductionPlanWindow;  //생산계획참조
var sTopWkordNum;
var BsaCodeInfo = {
    gsUseWorkColumnYn   : '${gsUseWorkColumnYn}',   //작업 관련컬럼(작업자, 작업호기, 작업시간, 주야구분) 사용여부
    gsAutoType          : '${gsAutoType}',
    gsAutoNo            : '${gsAutoNo}',                    // 생산자동채번여부
    gsBadInputYN        : '${gsBadInputYN}',                // 자동입고시 불량입고 반영여부
    gsChildStockPopYN   : '${gsChildStockPopYN}',           // 자재부족수량 팝업 호출여부
    gsShowBtnReserveYN  : '${gsShowBtnReserveYN}',          // BOM PATH 관리여부
    gsManageLotNoYN     : '${gsManageLotNoYN}',             // 재고와 작업지시LOT 연계여부

    gsLotNoInputMethod  : '${gsLotNoInputMethod}',          // LOT 연계여부
    gsLotNoEssential    : '${gsLotNoEssential}',
    gsEssItemAccount    : '${gsEssItemAccount}',

    gsLinkPGM           : '${gsLinkPGM}',                    // 등록 PG 내 링크 ID 설정
    gsGoodsInputYN      : '${gsGoodsInputYN}',               // 상품등록 가능여부
    gsSetWorkShopWhYN   : '${gsSetWorkShopWhYN}',            // 작업장의 가공창고 설정여부
    gsMoldCode   : '${gsMoldCode}',             // 작업지시 설비여부
    gsEquipCode  : '${gsEquipCode}',             // 작업지시 금형여부
    gsReportGubun : '${gsReportGubun}'	// 레포트 구분
};
//var output ='';
//for(var key in BsaCodeInfo){
// output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

function appMain() {

    var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }

    var isMoldCode = false;
    if(BsaCodeInfo.gsMoldCode=='N') {
        isMoldCode = true;
    }

    var isEquipCode = false;
    if(BsaCodeInfo.gsEquipCode=='N') {
        isEquipCode = true;
    }

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_pmp110ukrv_inService.selectDetailList',
            update: 's_pmp110ukrv_inService.updateDetail',
            create: 's_pmp110ukrv_inService.insertDetail',
            destroy: 's_pmp110ukrv_inService.deleteDetail',
            syncAll: 's_pmp110ukrv_inService.saveAll'
        }
    });

    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_pmp110ukrv_inService.selectWorkNum'
        }
    });

    //20170517 - 사용 안 함(주석)
/*  var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_pmp110ukrv_inService.selectProgInfo'
        }
    });*/

    var panelResult = Unilite.createSearchForm('panelResultForm', {
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3
//			, tdAttrs: {style: 'border : 1px solid #ced9e7;'}
        },
        padding:'1 1 1 1',
        border:true,
            items: [{
                fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
                name: 'DIV_CODE',
                value : UserInfo.divCode,
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                colspan: 1,
                holdable: 'hold',
                allowBlank: false
            },{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 2},
                items: [{
				    	  	xtype:'button',
				    	  	text:"제조지시서출력",
				    	  	disabled:false,
				    	  	itemId:'btnPrint',
							hidden: false,
							//margin: '0, 0, 0, 400',
				    	  	handler: function(){
				    	  	  if(!panelResult.getInvalidMessage()) return;   //필수체크
				    	  	  sTopWkordNum = panelResult.getValue("WKORD_NUM");
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
							  console.log("BsaCodeInfo.gsReportGubun" + BsaCodeInfo.gsReportGubun);
			      			var win = null;
			                  if(BsaCodeInfo.gsReportGubun == 'CLIP'){
				                  	//param["WKORD_NUM"] = sTopWkordNum;
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
	    	  	},{
			    	  	xtype:'button',
			    	  	text:"출고요청서출력",
			    	  	disabled:false,
			    	  	itemId:'btnPrint1',
						hidden: false,
						//margin: '0, 0, 0, 405',
			    	  	handler: function(){
			    	  	  if(!panelResult.getInvalidMessage()) return;   //필수체크
				   			var param = panelResult.getValues();
				   			var win;

				   			//공통코드에서 설정한 리포트를 가져오기 위한 파라메터 세팅
				        		param.PGM_ID = PGM_ID;  //프로그램ID
				        		param.MAIN_CODE = 'P010' //해당 모듈의 출력정보를 가지고 있는 공통코드
				        		param["RPT_ID"]='pmp220rkrv';
				   			param["PGM_ID"]='pmp220rkrv';
				   			param["sTxtValue2_fileTitle"]='출고요청현황';
				   			param.TOP_wkord_num_p = panelResult.getValue('WKORD_NUM');
				   			param.ITEM_CODE = '';
				        		var reportGubun = BsaCodeInfo.gsReportGubun //초기화 시 가져온 구분값, 값이 없거나 CR이면 크리스탈리포트나 jasper리포트 출력
				   			if(Ext.isEmpty(reportGubun) || reportGubun == 'CR'){
				   				param["sTxtValue2_fileTitle"]='발 주 서';
				   				win = Ext.create('widget.CrystalReport', {
				   	                url: CPATH+'/prodt/pmp220crkrv.do',
				   	                prgID: 'pmp220rkrv',
				   	                extParam: param
				   	            });
				   			}else{
				   				 win = Ext.create('widget.ClipReport', {
				   	                url: CPATH+'/prodt/pmp220clrkrv.do',
				   	                prgID: 'pmp220rkrv',
				   	                extParam: param
				   	            });
				   			}
				   				win.center();
				   				win.show();

							}
		    	  }]
            },{
            xtype: 'container',
            rowspan: 5,
            layout: {type: 'uniTable', columns: 3},
            items: [{
                title: '참고 사항',
                margin: '0 0 0 200',
                xtype: 'uniFieldset',
                itemId:'personalForm_1',
                layout:{type: 'uniTable', columns:1, tableAttrs:{cellpadding:1}, tdAttrs: {valign:'top'}},
                autoScroll:false,
                defaultType:'uniTextfield',
                items:[{
                    xtype: 'container',
                    layout: {type: 'uniTable', columns: 1},
                    items: [{
                                fieldLabel: '<t:message code="system.label.product.sono" default="수주번호"/>',
                                xtype: 'uniTextfield',
                                name: 'ORDER_NUM',
                                readOnly : true
                            },{
                                fieldLabel: '<t:message code="system.label.product.soqty" default="수주량"/>',
                                xtype: 'uniNumberfield',
                                name: 'ORDER_Q',
                                readOnly : true,
                                value: '0.00'
                            },{
                                fieldLabel: '<t:message code="system.label.product.deliverydate" default="납기일"/>',
                                xtype: 'uniDatefield',
                                name: 'DVRY_DATE',
                                readOnly : true
                            },{
                                fieldLabel: '<t:message code="system.label.product.custom" default="거래처"/>',
                                xtype: 'uniTextfield',
                                name: 'CUSTOM',
                                colspan: 1,
                                readOnly : true
                            }

                            ]
                        }]
                    }]
                }
              ,{
                fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
                xtype: 'uniTextfield',
                name: 'WKORD_NUM',
                colspan: 3,
                holdable: 'hold',
                readOnly: isAutoOrderNum,
                holdable: isAutoOrderNum ? 'readOnly':'hold'
            },{
                fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
                name: 'WORK_SHOP_CODE',
                xtype: 'uniCombobox',
                comboType: 'WU',
                holdable: 'hold',
                colspan: 3,
                allowBlank:false,
                listeners: {
                    beforequery:function( queryPlan, eOpts )   {
                           var store = queryPlan.combo.store;
                           store.clearFilter();
                           if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                             store.filterBy(function(record){
                                 return record.get('option') == panelResult.getValue('DIV_CODE');
                            })
                          }else{
                           store.filterBy(function(record){
                               return false;
                          })
                        }
                    }, change: function(field, newValue, oldValue, eOpts) {
						   if(!Ext.isEmpty(panelResult.getValue('PRODT_START_DATE')) && !Ext.isEmpty(panelResult.getValue('ITEM_CODE'))){
							   fnCreateLotno(UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE')), panelResult.getValue('ITEM_CODE'));
						   }
						   var records = detailStore.data.items;
						   Ext.each(records, function(record,i){
                               record.set('WORK_SHOP_CODE', newValue);
                           });
					}
                }
            },
                //{
//                xtype: 'radiogroup',
//                fieldLabel: '<t:message code="system.label.product.reworkorderyn" default="재작업지시여부"/>',
//                id:'rework1',
//                items: [{
//                    boxLabel: '<t:message code="system.label.product.yes" default="예"/>',
//                    width: 70,
//                    name: 'REWORK_YN',
//                    inputValue: 'Y'
//                },{
//                    boxLabel : '<t:message code="system.label.product.no" default="아니오"/>',
//                    width: 70,
//                    name: 'REWORK_YN',
//                    inputValue: 'N',
//                    checked: true
//                }],
//                listeners: {
//                    change: function(field, newValue, oldValue, eOpts) {
//
//                        panelResult.getField('REWORK_YN').setValue(newValue.REWORK_YN);
//
//                        if(Ext.getCmp('reworkRe').getChecked()[0].inputValue =='Y'){
//                            panelSearch.getField('EXCHG_TYPE').setReadOnly( false );
//                            panelSearch.setValue('EXCHG_TYPE', "B");
//
//                            panelResult.getField('EXCHG_TYPE').setReadOnly( false );
//                            panelResult.setValue('EXCHG_TYPE', "B");
//
//                        }else if(Ext.getCmp('reworkRe').getChecked()[0].inputValue =='N'){
//                            panelSearch.setValue('EXCHG_TYPE', "");
//                            panelSearch.getField('EXCHG_TYPE').setReadOnly( true );
//
//                            panelResult.setValue('EXCHG_TYPE', "");
//                            panelResult.getField('EXCHG_TYPE').setReadOnly( true );
//
//                        }
//                    }
//                }
//            },
            {
                xtype: 'container',
                layout: { type: 'uniTable', columns: 2},
                defaultType: 'uniTextfield',
                defaults : {enforceMaxLength: true},
                colspan: 3,
                items:[
                    Unilite.popup('DIV_PUMOK',{
                        fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
                        valueFieldName: 'ITEM_CODE',
                        textFieldName: 'ITEM_NAME',
                        holdable: 'hold',
                        valueFieldWidth:150,
                        textFieldWidth:170,
                        allowBlank:false,
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    panelResult.setValue('SPEC',records[0]["SPEC"]);
                                    panelResult.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);
                                    panelResult.setValue('LOT_NO', '');
                            		panelResult.setValue('EXPIRATION_DAY2', records[0].EXPIRATION_DAY);
									panelResult.setValue('PRODUCT_LDTIME', records[0].PRODUCT_LDTIME);
									var expirationDay = panelResult.getValue('EXPIRATION_DAY2');
									var productLdtime = panelResult.getValue('PRODUCT_LDTIME');
									fnCalDate(expirationDay, productLdtime);
								    fnCreateLotno(UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE')), panelResult.getValue('ITEM_CODE'));
                                },
                                scope: this
                            },
                            onClear: function(type) {

                                panelResult.setValue('SPEC','');
                                panelResult.setValue('PROG_UNIT','');
                                panelResult.setValue('LOT_NO', '');
                            	panelResult.setValue('EXPIRATION_DAY2', '');
                            	panelResult.setValue('PRODUCT_LDTIME', '');
                            	panelResult.setValue('EXPIRATION_DATE','');

                            },
                            applyextparam: function(popup){
                                popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                            }
                        }
               }),{
                    name:'SPEC',
                    xtype:'uniTextfield',
                    holdable: 'hold',
                    readOnly:true
                }]
            }
            ,{
                fieldLabel: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
                xtype: 'uniDatefield',
                name: 'PRODT_WKORD_DATE',
                labelWidth: 90,
//                holdable: 'hold',
                allowBlank:false,
                value: new Date(),
                listeners: {
                	change: function(field, newValue, oldValue, eOpts) {
                            var cgProdtWkordDate = UniDate.getDateStr(field.getValue());
                            if(Ext.isEmpty(cgProdtWkordDate)) return false;
                            var records = detailStore.data.items;
                            Ext.each(records, function(record,i){
                                record.set('PRODT_WKORD_DATE',cgProdtWkordDate);
                            });
                	}
                }
            },{
                fieldLabel: '제조LOT번호',
                xtype:'uniTextfield',
                //labelWidth: 400,
                name: 'LOT_NO',
                colspan: 2,
//                holdable: 'hold',
//                readOnly: isAutoOrderNum,
				listeners: {
                	change: function(field, newValue, oldValue, eOpts) {
                		var cgLotNo = newValue;
                        var records = detailStore.data.items;
                        Ext.each(records, function(record,i){
                            record.set('LOT_NO',cgLotNo);
                        });
                	}
                }
            },{
                fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
                xtype: 'uniDatefield',
                name: 'PRODT_START_DATE',
//                holdable: 'hold',
                allowBlank:false,
                value: new Date(),
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						var workShopCode =  panelResult.getValue('WORK_SHOP_CODE');
						var expirationDay = panelResult.getValue('EXPIRATION_DAY2');
						var productLdtime = panelResult.getValue('PRODUCT_LDTIME');
						var itemCode =  panelResult.getValue('ITEM_CODE');
						var records = detailStore.data.items;

						if(! Ext.isEmpty(workShopCode) && ! Ext.isEmpty(itemCode) && !Ext.isEmpty(newValue)){
							fnCreateLotno(UniDate.getDbDateStr(newValue), itemCode);
						}
						if(!Ext.isEmpty(newValue)){
							if(UniDate.getDbDateStr(newValue).replace(".","").replace(".","").length == 8){
								panelResult.setValue('PRODT_DATE', newValue);
								fnCalDate(expirationDay, productLdtime);
							}
						}

						 var cgProdtStartDate = UniDate.getDateStr(field.getValue());
                         if(Ext.isEmpty(cgProdtStartDate)) return false;
                         var records = detailStore.data.items;
                         Ext.each(records, function(record,i){
                             record.set('PRODT_START_DATE',cgProdtStartDate);
                             record.set('PRODT_END_DATE',cgProdtStartDate);
                             //record.set('LOT_NO',panelResult.getValue('LOT_NO'));
                             record.set('PRODT_DATE',panelResult.getValue('PRODT_DATE'));
                         });
                	}
        		}
            },{
                fieldLabel: '제조일자',
                xtype: 'uniDatefield',
                name: 'PRODT_DATE',
               // labelWidth: 400,
//                holdable: 'hold',
                colspan: 2,
                listeners: {
                    /* blur: function(field, The, eOpts){
                        if(!Ext.isEmpty(panelResult.getValue('ITEM_CODE'))){
                            if(!Ext.isEmpty(field.getValue())){
                                var param = panelResult.getValues();
                                s_pmp110ukrv_inService.selectExpirationdate(param, function(provider, response) {
                                    if(provider != 0){
                                          panelResult.setValue('EXPIRATION_DATE',UniDate.getDbDateStr(UniDate.add(field.getValue(), {months: + provider , days:-1})));
                                    }else{
                                          //alert('유효기간을 설정하지 않은 품목입니다. 유효기간을 설정해주세요.');
                                          panelResult.setValue('EXPIRATION_DATE', '');
                                          panelResult.setValue('PRODT_DATE', panelResult.getValue('PRODT_WKORD_DATE'));
                                    }
                                });
                            }else{
                                panelResult.setValue('PRODT_DATE', panelResult.getValue('PRODT_WKORD_DATE'));
                            }
                        }else{
                            alert('작업지시를 할 품목을 넣어주세요.');
                            panelResult.setValue('PRODT_DATE', panelResult.getValue('PRODT_WKORD_DATE'));
                        }
                    }, */change: function(field, newValue, oldValue, eOpts) {
                    	/* var cgProdtDate = UniDate.getDateStr(field.getValue());
                        if(Ext.isEmpty(cgProdtDate)) return false;
                        var records = detailStore.data.items;
                        Ext.each(records, function(record,i){
                            record.set('PRODT_DATE',cgProdtDate);
                        }); */
            		}
                }
            },{
                fieldLabel: '<t:message code="system.label.product.completiondate" default="완료예정일"/>',
                xtype: 'uniDatefield',
                name: 'PRODT_END_DATE',
//                holdable: 'hold',
                allowBlank:false,
                value: new Date(),
                listeners: {
                	change: function(field, newValue, oldValue, eOpts) {
                		var cgProdtEndDate = UniDate.getDateStr(field.getValue());
                        if(Ext.isEmpty(cgProdtEndDate)) return false;
                        var records = detailStore.data.items;
                        Ext.each(records, function(record,i){
                            record.set('PRODT_END_DATE',cgProdtEndDate);
                        });
                	}
                }
            },{
                fieldLabel: '유통기한',
                xtype: 'uniDatefield',
                name: 'EXPIRATION_DATE',
               // labelWidth: 400,
//                holdable: 'hold',
                colspan: 3,
                listeners: {
                	change: function(field, newValue, oldValue, eOpts) {
                		var cgExporationDate = UniDate.getDateStr(field.getValue());
                        if(Ext.isEmpty(cgExporationDate)) return false;
                        var records = detailStore.data.items;
                        Ext.each(records, function(record,i){
                            record.set('EXPIRATION_DATE',cgExporationDate);
                        });
                	}
                }
            },{
                xtype: 'container',
                layout: { type: 'uniTable', columns: 2},
                defaultType: 'uniTextfield',
                defaults : {enforceMaxLength: true},
                items:[{
                    fieldLabel: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
                    xtype: 'uniNumberfield',
                    name: 'WKORD_Q',
                    value: '0.00',
                    holdable: 'hold',
                    allowBlank:false,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {

                            var cgWkordQ = panelResult.getValue('WKORD_Q');

                            if(Ext.isEmpty(cgWkordQ)) return false;
                            var records = detailStore.data.items;

                            Ext.each(records, function(record,i){
                                record.set('WKORD_Q',(cgWkordQ * record.get("PROG_UNIT_Q")));
                            });
                        }
                    }
                },{
                    name:'PROG_UNIT',
                    xtype:'uniTextfield',
                    holdable: 'hold',
                    width: 50,
                    readOnly:true,
                    fieldStyle: 'text-align: center;'
                }]
            },{
                fieldLabel: '<t:message code="system.label.product.entryuser" default="등록자"/>',
                //labelWidth: 400,
                name: 'WKORD_PRSN',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'P510',
                colspan: 2,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        var store = detailGrid.getStore();
                        Ext.each(store.data.items, function(record, index) {
                            record.set('WKORD_PRSN', newValue);
                        });
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.product.specialremark" default="특기사항"/>',
                xtype:'uniTextfield',
                name: 'ANSWER',
                holdable: 'hold',
                width: 565,
                height: 80,
               //
                rowspan:2,
                autoscroll:true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        var cgRemark = newValue;
                        var records = detailStore.data.items;
                        Ext.each(records, function(record,i){
                            record.set('REMARK',cgRemark);
                        });
                    }
                }
            },{
                xtype: 'radiogroup',
                fieldLabel: '감마',
                colspan:2,
                id:'gamma',
               // labelWidth: 290,
                items: [{
                    boxLabel: '10kGy',
                    width: 60,
                    name: 'GAMMA',
                    inputValue: '10'
                },{
                    boxLabel : '15kGy',
                    width: 60,
                    name: 'GAMMA',
                    inputValue: '15'
                },{
                    boxLabel : 'N/A',
                    width: 60,
                    name: 'GAMMA',
                    inputValue: 'NA',
                    checked: true
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        var cgGamma = newValue.GAMMA;
                        if(Ext.isEmpty(cgGamma)) return false;
                        var records = detailStore.data.items;
                        Ext.each(records, function(record,i){
                            record.set('GAMMA',cgGamma);
                        });
                    }
                }
            },{
            	xtype: 'component'
            },{
                xtype: 'radiogroup',
                fieldLabel: '<t:message code="system.label.product.reworkorderyn" default="재작업지시여부"/>',
                id:'reworkRe',
                margin: '0 0 0 212',
                items: [{
                    boxLabel: '<t:message code="system.label.product.yes" default="예"/>',
                    width: 70,
                    name: 'REWORK_YN',
                    inputValue: 'Y'
                },{
                    boxLabel : '<t:message code="system.label.product.no" default="아니오"/>',
                    width: 70,
                    name: 'REWORK_YN',
                    inputValue: 'N',
                    checked: true
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        if(newValue.REWORK_YN =='Y'){

                            panelResult.getField('EXCHG_TYPE').setReadOnly( false );
                            panelResult.setValue('EXCHG_TYPE', "B");

                        }else if(newValue.REWORK_YN =='N'){

                            panelResult.setValue('EXCHG_TYPE', "");
                            panelResult.getField('EXCHG_TYPE').setReadOnly( true );
                        }
                    }
                }
            },
            Unilite.popup('PROJECT',{
                    fieldLabel: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>',
                    valueFieldName: 'PJT_CODE',
//                    holdable: 'hold',

                    listeners: {
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }
                    }
            }),
            /*Unilite.popup('LOT_NO',{
                    fieldLabel: 'LOT_NO',
                    valueFieldName: 'LOT_NO',
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                panelSearch.setValue('LOT_NO', panelResult.getValue('LOT_NO'));
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('LOT_NO', '');
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                            popup.setExtParam({'ITEM_CODE': panelSearch.getValue('ITEM_CODE')});
                            popup.setExtParam({'ITEM_NAME': panelSearch.getValue('ITEM_NAME')});
                        }
                    }
            })*/{
                xtype: 'radiogroup',
                fieldLabel: '<t:message code="system.label.product.forceclosing" default="강제마감"/>',
                id:'workEndYnRe',
                items: [{
                    boxLabel: '<t:message code="system.label.product.yes" default="예"/>',
                    width: 70,
                    name: 'WORK_END_YN',
                    inputValue: 'Y',
                    readOnly : true
                },{
                    boxLabel : '<t:message code="system.label.product.no" default="아니오"/>',
                    width: 70,
                    name: 'WORK_END_YN',
                    inputValue: 'N',
                    checked: true,
                    readOnly : true
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        if(!panelResult.uniOpt.inLoading)   {
                            var msg = '작업지시를 마감하시겠습니까?';
                            if(newValue.WORK_END_YN == 'N') {
                                msg = '작업지시를 취소하시겠습니까?';
                            }
                            if(confirm(msg)){
                                if(!Ext.isEmpty(panelResult.getValue("DIV_CODE")) && !Ext.isEmpty(panelResult.getValue("WKORD_NUM")))   {
                                    var param = {
                                        'DIV_CODE' : panelResult.getValue("DIV_CODE"),
                                        'WKORD_NUM': panelResult.getValue("WKORD_NUM"),
                                        'WORK_END_YN' : newValue.WORK_END_YN
                                    }
                                    s_pmp110ukrv_inService.closeWok(param, function(respnseText, response){
                                        UniAppManager.app.onQueryButtonDown();
                                    });
                                } else {
                                    alert('<t:message code="system.label.product.division" default="사업장"/>, <t:message code="system.label.product.workorderno" default="작업지시번호"/> 를 입력하세요.')

                                }
                            }
                            else{
                                setTimeout(function() {
                                    panelResult.uniOpt.inLoading = true;
                                    field.setValue({WORK_END_YN:oldValue.WORK_END_YN});
                                    panelResult.uniOpt.inLoading = false;
                                },10);
                            }
                        }
                    }
                }
           },{
                fieldLabel: '<t:message code="system.label.product.inventoryexchangetype" default="재고대체유형"/>',
                labelWidth: 300,
                name:'EXCHG_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU' ,
                comboCode:'P120',
                holdable: 'hold',
                hidden : false,
                readOnly : true
            },{
                xtype: 'component',
                colspan: 3,
                padding: '0 0 0 0',
                height  : 3
//              tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 2px;' }
            }, {
				fieldLabel	: '유효기간2',
				name		: 'EXPIRATION_DAY2',
				xtype		: 'uniNumberfield',
				type			: 'int',
				hidden:true,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {

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

					}
	    		}
			}, {
				fieldLabel	: '계획번호',
				name		: 'WK_PLAN_NUM',
				xtype		: 'uniTextfield',
				hidden	:true,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {

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
                        alert(labelText+Msg.sMB083);
                        invalid.items[0].focus();
                    } else {
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
     * 긴급작업지시 마스터 정보를 가지고 있는 Grid
     */
    Unilite.defineModel('s_pmp110ukrv_inDetailModel', {
        fields: [
            {name: 'LINE_SEQ'               ,text: '<t:message code="system.label.product.routingorder" default="공정순서"/>'           ,type:'int', allowBlank: false},
            {name: 'PROG_WORK_CODE'         ,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'            ,type:'string', allowBlank: false},
            {name: 'PROG_WORK_NAME'         ,text: '<t:message code="system.label.product.routingname" default="공정명"/>'             ,type:'string'},
            {name: 'EQUIP_CODE'             ,text: '<t:message code="system.label.product.facilities" default="설비"/>'           ,type:'string', allowBlank: true},
            {name: 'EQUIP_NAME'             ,text: '<t:message code="system.label.product.facilitiesname" default="설비명"/>'             ,type:'string', allowBlank: true},
            {name: 'EQUIP_CODE2'             ,text: '<t:message code="system.label.product.facilities" default="설비"/>(2)'           ,type:'string'},
            {name: 'EQUIP_NAME2'             ,text: '<t:message code="system.label.product.facilitiesname" default="설비명"/>(2)'             ,type:'string'},
            {name: 'MOLD_CODE'              ,text: '<t:message code="system.label.product.moldcode" default="금형코드"/>'           ,type:'string', allowBlank: true},
            {name: 'MOLD_NAME'              ,text: '<t:message code="system.label.product.moldname" default="금형명"/>'             ,type:'string', allowBlank: true},
            {name: 'PROG_UNIT_Q'            ,text: '<t:message code="system.label.product.originunitqty" default="원단위량"/>'         ,type: 'uniFC', allowBlank: false},
            {name: 'WKORD_Q'                ,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'          ,type:'uniQty', allowBlank: false},
            //20180705(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
            {name: 'PRODT_PRSN'             ,text: '<t:message code="system.label.product.worker" default="작업자"/>'                  ,type:'string',comboType:'AU',comboCode:'P505'},
            {name: 'PRODT_MACH'             ,text: '<t:message code="system.label.product.Workingmachine" default="작업호기"/>'         ,type:'string'  ,comboType:'AU',comboCode:'P506'},
            {name: 'PRODT_TIME'             ,text: '<t:message code="system.label.product.workhour" default="작업시간"/>'               ,type:'string'},
            {name: 'DAY_NIGHT'              ,text: '<t:message code="system.label.product.daynightclass" default="주야구분"/>'          ,type:'string'  ,comboType:'AU',comboCode:'P507'},

            {name: 'PROG_UNIT'              ,text: '<t:message code="system.label.product.unit" default="단위"/>'             ,type:'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value', allowBlank: false},
            {name: 'DIV_CODE'               ,text: '<t:message code="system.label.product.division" default="사업장"/>'                ,type:'string'},
            {name: 'WKORD_NUM'              ,text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'           ,type:'string'},
            {name: 'WORK_SHOP_CODE'         ,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'              ,type:'string' , comboType: 'WU'},
            {name: 'PRODT_START_DATE'       ,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'          ,type:'uniDate'},
            {name: 'PRODT_END_DATE'         ,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'            ,type:'uniDate'},
            {name: 'PRODT_WKORD_DATE'       ,text: '<t:message code="system.label.product.workstartdate" default="작업시작일"/>'         ,type:'uniDate'},
            //{name: 'PRODT_DATE'       ,text: 'PRODT_DATE'         ,type:'uniDate'},
            {name: 'ITEM_CODE'              ,text: '<t:message code="system.label.product.item" default="품목"/>'             ,type:'string'},
            {name: 'REMARK'                 ,text: '<t:message code="system.label.product.remarks" default="비고"/>'              ,type:'string'},
            {name: 'WK_PLAN_NUM'            ,text: '<t:message code="system.label.product.planno" default="계획번호"/>'         ,type:'string'},
            {name: 'LINE_END_YN'            ,text: '<t:message code="system.label.product.lastyn" default="최종여부"/>'         ,type:'string'},
            {name: 'ITEM_NAME'              ,text: '<t:message code="system.label.product.itemname" default="품목명"/>'                ,type:'string'},
            {name: 'SPEC'                   ,text: '<t:message code="system.label.product.spec" default="규격"/>'             ,type:'string'},
            {name: 'WORK_END_YN'            ,text: '<t:message code="system.label.product.closingyn" default="마감여부"/>'          ,type:'string'},
            {name: 'REWORK_YN'              ,text: '<t:message code="system.label.product.reworkorderyn2" default="재작업지시유무"/>'      ,type:'string'},
            {name: 'STOCK_EXCHG_TYPE'       ,text: '<t:message code="system.label.product.inventoryexchangetype" default="재고대체유형"/>'        ,type:'string'},
            {name: 'STD_TIME'               ,text: '표준시간'            ,type:'int'},
            {name: 'CAVIT_BASE_Q'           ,text: 'Cavity 수'        ,type:'int'},
            {name: 'CAPA_HR'                ,text: 'Capa/Hr'         ,type:'int'},
            {name: 'CAPA_DAY'               ,text: 'Capa/Day'        ,type:'int'},

            //Hidden : true
            {name: 'PROJECT_NO'             ,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'        ,type:'string'},
            {name: 'PJT_CODE'               ,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'        ,type:'string'},
            {name: 'LOT_NO'                 ,text: 'LOT_NO'             ,type:'string'},
            {name: 'UPDATE_DB_USER'         ,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'              ,type:'string'},
            {name: 'UPDATE_DB_TIME'         ,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'              ,type:'uniDate'},
            {name: 'COMP_CODE'              ,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'           ,type:'string'},
            {name: 'WKORD_PRSN'             ,text: 'WKORD_PRSN'             ,type:'string'},
            {name: 'EXPIRATION_DATE'       ,text: '<t:message code="system.label.product.expirationdate" default="유통기한"/>'         ,type:'uniDate'},
            {name: 'GAMMA'       ,text: '감마'         ,type:'string'}
        ]
    });


    /**
     * Master Store 정의(Service 정의)
     * @type
     */
    var detailStore = Unilite.createStore('s_pmp110ukrv_inDetailStore', {
        model: 's_pmp110ukrv_inDetailModel',
        autoLoad: false,
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: true,         // 수정 모드 사용
            deletable: true,        // 삭제 가능 여부
            allDeletable: true,      // 전체 삭제 가능 여부
            useNavi : false         // prev | next 버튼 사용
        },
        proxy: directProxy,
        loadStoreRecords: function() {
            var param= panelResult.getValues();
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

            var wkordNum = panelResult.getValue('WKORD_NUM');
            Ext.each(list, function(record, index) {
                if(record.data['WKORD_NUM'] != wkordNum) {
                    record.set('WKORD_NUM', wkordNum);
                }
            })
//          var lotNo = panelSearch.getValue('LOT_NO');
//            Ext.each(list, function(record, index) {
//                if(record.data['LOT_NO'] != lotNo) {
//                    record.set('LOT_NO', lotNo);
//                }
//            })
            console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

            //1. 마스터 정보 파라미터 구성
            var paramMaster= panelResult.getValues();   //syncAll 수정

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
                                panelResult.setValue("WKORD_NUM", master.WKORD_NUM);
                                panelResult.setValue("LOT_NO", master.LOT_NO);

                                panelResult.getForm().wasDirty = false;
                                panelResult.resetDirtyStatus();
                                console.log("set was dirty to false");

                                if (detailStore.count() == 0) {
                                    UniAppManager.app.onResetButtonDown();
                                }else{
                                    detailStore.loadStoreRecords();
                                }
                                UniAppManager.setToolbarButtons('save', false);
                             }
                    };
                //}
                //this.syncAll(config);
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('s_pmp110ukrv_inGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                // alert(Msg.sMB083);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {

                if(records[0] != null){
                	 Ext.each(records, function(record,i){
                		 if(record.get('LINE_END_YN') == 'Y'){//마지막 공정 정보를 마스터 폼에 적용
                			 panelResult.setValues(records[i].data);
                		 }
                	 });
                	panelResult.uniOpt.inLoading = true;
                    panelResult.uniOpt.inLoading = false;
                    detailStore.commitChanges();
                }
            }
        }
    });

    /**
     * Master Grid 정의(Grid Panel)
     * @type
     */

    var detailGrid = Unilite.createGrid('s_pmp110ukrv_inGrid', {
        layout: 'fit',
        region:'center',
        uniOpt: {
            expandLastColumn: true,
            useRowNumberer: false
        },
        tbar: [{
            itemId: 'requestBtn', ////
            text: '<div style="color: blue"><t:message code="system.label.product.productionplanreference" default="생산계획참조"/></div>',
            handler: function() {
                openProductionPlanWindow();
                }
        },'-', {
            itemId: 'reqIssueLinkBtn',
            id: 'reqIssueLinkBtn',
            iconCls: 'icon-link',
            text: '<t:message code="system.label.product.allocationqtyadjust" default="예약량조정"/>',
            handler: function() {
                if(!UniAppManager.app.checkForNewDetail()) return false;
                /* 기본 필수값을 입력하지 않을 경우 팅겨냄*/
                else{
                    if(Ext.isEmpty(panelResult.getValue('WKORD_NUM'))){
                        alert('<t:message code="system.message.product.datacheck002" default="선택된 자료가 없습니다."/>');
                        return false;
                    }
                    else{
                        var params = {
                            'DIV_CODE'          : panelResult.getValue('DIV_CODE'),
                            'WORK_SHOP_CODE'    : panelResult.getValue('WORK_SHOP_CODE'),
                            'PRODT_WKORD_DATE'  : panelResult.getValue('PRODT_WKORD_DATE'),
                            'WKORD_NUM'         : panelResult.getValue('WKORD_NUM')
                        }
                        var rec = {data : {prgID : 'pmp160ukrv', 'text':'예약량조정'}};
                        parent.openTab(rec, '/prodt/pmp160ukrv.do', params);
                    }
                }
            }
        }],
        store: detailStore,
        columns: [
            {dataIndex:'LINE_SEQ'           , width: 120},
            {dataIndex:'PROG_WORK_CODE'     , width: 120 ,locked: false,
                editor: Unilite.popup('PROG_WORK_CODE_G', {
                        textFieldName: 'PROG_WORK_NAME',
                        DBtextFieldName: 'PROG_WORK_NAME',
                        //extParam: {SELMODEL: 'MULTI'},
                        autoPopup: true,
                        listeners: {'onSelected': {
                                        fn: function(records, type) {
                                            Ext.each(records, function(record,i) {
                                                if(i==0) {

                                                    detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
                                                }else{
                                                    UniAppManager.app.onNewDataButtonDown();
                                                    detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
                                                }
                                            });
                                        },
                                        scope: this
                                    },
                                    'onClear': function(type) {
                                        detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
                                    },
                                    applyextparam: function(popup){
                                        popup.setExtParam({'DIV_CODE'       : panelResult.getValue('DIV_CODE')});
                                        popup.setExtParam({'WORK_SHOP_CODE' : panelResult.getValue('WORK_SHOP_CODE')
                                    });
                                }
                    }
                })
            },

            {dataIndex: 'PROG_WORK_NAME'    , width: 206,
                editor: Unilite.popup('PROG_WORK_CODE_G', {
                            textFieldName: 'PROG_WORK_NAME',
                            DBtextFieldName: 'PROG_WORK_NAME',
                            //extParam: {SELMODEL: 'MULTI'},
                            autoPopup: true,
                            listeners: {'onSelected': {
                                            fn: function(records, type) {
                                                Ext.each(records, function(record,i) {
                                                    if(i==0) {
                                                        detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
                                                    }else{
                                                        UniAppManager.app.onNewDataButtonDown();
                                                        detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
                                                    }
                                                });
                                            },
                                            scope: this
                                        },
                                        'onClear': function(type) {
                                            var grdRecord = detailGrid.getSelectedRecord();
                                            detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
                                        },
                                        applyextparam: function(popup){
                                            popup.setExtParam({'DIV_CODE'       : panelResult.getValue('DIV_CODE')});
                                            popup.setExtParam({'WORK_SHOP_CODE' : panelResult.getValue('WORK_SHOP_CODE')
                                        });
                                    }
                        }
                })
            },
            {dataIndex: 'LOT_NO'            , width: 100, hidden: true},
            {dataIndex: 'PROG_UNIT_Q'       , width: 146,format:'0,000.000000',editor:{format:'0,000.000000'}},
            {dataIndex: 'WKORD_Q'           , width: 206},

            //20180705(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
            {dataIndex: 'PRODT_PRSN'        , width: 150},
            {dataIndex: 'PRODT_MACH'        , width: 100},
            {dataIndex: 'PRODT_TIME'        , width: 100},
            {dataIndex: 'DAY_NIGHT'         , width: 100},

            {dataIndex: 'PROG_UNIT'         , width: 50, align: 'center'},
            {dataIndex: 'STD_TIME'          , width: 100},
            {dataIndex: 'EQUIP_CODE'                  ,       width: 110, hidden: false
                ,'editor' : Unilite.popup('EQU_MACH_CODE_G',{
                                textFieldName:'EQU_MACH_NAME',
                                DBtextFieldName: 'EQU_MACH_NAME',
                                autoPopup: true,
                                listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        var grdRecord = detailGrid.uniOpt.currentRecord;
                                        grdRecord.set('EQUIP_CODE',records[0]['EQU_MACH_CODE']);
                                        grdRecord.set('EQUIP_NAME',records[0]['EQU_MACH_NAME']);
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = detailGrid.getSelectedRecord();
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
            {dataIndex: 'EQUIP_NAME'                  ,       width: 200, hidden: false
                ,'editor' : Unilite.popup('EQU_MACH_CODE_G',{
                        textFieldName:'EQU_MACH_NAME',
                        DBtextFieldName: 'EQU_MACH_NAME',
                        autoPopup: true,
                        listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        var grdRecord = detailGrid.uniOpt.currentRecord;
                                        grdRecord.set('EQUIP_CODE',records[0]['EQU_MACH_CODE']);
                                        grdRecord.set('EQUIP_NAME',records[0]['EQU_MACH_NAME']);
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = detailGrid.getSelectedRecord();
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
            {dataIndex: 'EQUIP_CODE2'                  ,       width: 110, hidden: false
                ,'editor' : Unilite.popup('EQU_MACH_CODE_G',{
                                textFieldName:'EQU_MACH_NAME2',
                                DBtextFieldName: 'EQU_MACH_NAME2',
                                autoPopup: true,
                                listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        var grdRecord = detailGrid.uniOpt.currentRecord;
                                        grdRecord.set('EQUIP_CODE2',records[0]['EQU_MACH_CODE']);
                                        grdRecord.set('EQUIP_NAME2',records[0]['EQU_MACH_NAME']);
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = detailGrid.getSelectedRecord();
                                    grdRecord.set('EQUIP_CODE2', '');
                                    grdRecord.set('EQUIP_NAME2', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelResult.getValues();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                }
                            }
                })
            },
            {dataIndex: 'EQUIP_NAME2'                  ,       width: 200, hidden: false
                ,'editor' : Unilite.popup('EQU_MACH_CODE_G',{
                        textFieldName:'EQU_MACH_NAME2',
                        DBtextFieldName: 'EQU_MACH_NAME2',
                        autoPopup: true,
                        listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        var grdRecord = detailGrid.uniOpt.currentRecord;
                                        grdRecord.set('EQUIP_CODE2',records[0]['EQU_MACH_CODE']);
                                        grdRecord.set('EQUIP_NAME2',records[0]['EQU_MACH_NAME']);
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = detailGrid.getSelectedRecord();
                                    grdRecord.set('EQUIP_CODE2', '');
                                    grdRecord.set('EQUIP_NAME2', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelResult.getValues();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                }
                         }
                })
            },
            {dataIndex: 'MOLD_CODE'                  ,       width: 110, hidden: true
                ,'editor' : Unilite.popup('EQU_MOLD_CODE_G',{
                            textFieldName:'EQU_MOLD_NAME',
                            DBtextFieldName: 'EQU_MOLD_NAME',
                            autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        grdRecord = detailGrid.getSelectedRecord();
                                        Ext.each(records, function(record,i) {
                                            grdRecord.set('MOLD_CODE',records[0]['EQU_MOLD_CODE']);
                                            grdRecord.set('MOLD_NAME',records[0]['EQU_MOLD_NAME']);
                                            grdRecord.set('CAVIT_BASE_Q', record.CAVIT_BASE_Q);
                                            if(record.CAVIT_BASE_Q != 0 && record.CYCLE_TIME != 0){
                                                grdRecord.set('CAPA_HR', 3600/record.CYCLE_TIME * record.CAVIT_BASE_Q );
                                                grdRecord.set('CAPA_DAY',(3600/record.CYCLE_TIME * record.CAVIT_BASE_Q)* grdRecord.get('STD_TIME'));
                                            }else{
                                                grdRecord.set('CAPA_HR', 0);
                                                grdRecord.set('CAPA_DAY',0);
                                            }
                                        });
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = detailGrid.getSelectedRecord();
                                    grdRecord.set('MOLD_CODE', '');
                                    grdRecord.set('MOLD_NAME', '');
                                    grdRecord.set('CAVIT_BASE_Q', record.CAVIT_BASE_Q);
                                    grdRecord.set('CAPA_HR' , '');
                                    grdRecord.set('CAPA_DAY','');
                                },
                                applyextparam: function(popup){
                                    var param =  panelResult.getValues();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                }
                            }
                })
            },
            {dataIndex: 'MOLD_NAME'                  ,       width: 200, hidden: true
                ,'editor' : Unilite.popup('EQU_MOLD_CODE_G',{
                            textFieldName:'EQU_MOLD_NAME',
                            DBtextFieldName: 'EQU_MOLD_NAME',
                            autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        grdRecord = detailGrid.getSelectedRecord();
                                        Ext.each(records, function(record,i) {
                                            grdRecord.set('MOLD_CODE',records[0]['EQU_MOLD_CODE']);
                                            grdRecord.set('MOLD_NAME',records[0]['EQU_MOLD_NAME']);
                                            grdRecord.set('CAVIT_BASE_Q', record.CAVIT_BASE_Q);
                                            if(record.CAVIT_BASE_Q != 0 && record.CYCLE_TIME != 0){
                                                grdRecord.set('CAPA_HR', 3600/record.CYCLE_TIME * record.CAVIT_BASE_Q );
                                                grdRecord.set('CAPA_DAY',(3600/record.CYCLE_TIME * record.CAVIT_BASE_Q)* grdRecord.get('STD_TIME'));
                                            }else{
                                                grdRecord.set('CAPA_HR', 0);
                                                grdRecord.set('CAPA_DAY',0);
                                            }
                                        });
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = detailGrid.getSelectedRecord();
                                    grdRecord.set('MOLD_CODE', '');
                                    grdRecord.set('MOLD_NAME', '');
                                    grdRecord.set('CAVIT_BASE_Q', record.CAVIT_BASE_Q);
                                    grdRecord.set('CAPA_HR', '');
                                    grdRecord.set('CAPA_DAY','');
                                },
                                applyextparam: function(popup){
                                    var param =  panelResult.getValues();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                }
                            }
                })
            },
            {dataIndex: 'CAVIT_BASE_Q'          , width: 100 , hidden: true},
            {dataIndex: 'CAPA_HR'          , width: 100  , hidden: true},
            {dataIndex: 'CAPA_DAY'          , width: 100 , hidden: true},
            {dataIndex: 'DIV_CODE'          , width: 100 , hidden: true},
            {dataIndex: 'WKORD_NUM'         , width: 100 , hidden: true},
            {dataIndex: 'WORK_SHOP_CODE'    , width: 100 , hidden: true},
            {dataIndex: 'PRODT_START_DATE'  , width: 100 , hidden: true},
            {dataIndex: 'PRODT_END_DATE'    , width: 100 , hidden: true},
            {dataIndex: 'PRODT_WKORD_DATE'  , width: 100 , hidden: true},
           // {dataIndex: 'PRODT_DATE'  , width: 100 , hidden: true},
            {dataIndex: 'ITEM_CODE'         , width: 100 , hidden: true},
            {dataIndex: 'ITEM_NAME'         , width: 100 , hidden: true},
            {dataIndex: 'REMARK'            , width: 500 },
            {dataIndex: 'WK_PLAN_NUM'       , width: 100 , hidden: true},
            {dataIndex: 'LINE_END_YN'       , width: 100 , hidden: true},
            {dataIndex: 'SPEC'              , width: 100 , hidden: true},
            {dataIndex: 'WORK_END_YN'       , width: 100 , hidden: true},
            {dataIndex: 'REWORK_YN'         , width: 100 , hidden: true},
            {dataIndex: 'STOCK_EXCHG_TYPE'  , width: 100 , hidden: true},
            // ColDate
            {dataIndex: 'PROJECT_NO'        , width: 100 , hidden: true},
            {dataIndex: 'PJT_CODE'          , width: 100 , hidden: true},
            {dataIndex: 'UPDATE_DB_USER'    , width: 100 , hidden: true},
            {dataIndex: 'UPDATE_DB_TIME'    , width: 100 , hidden: true},
            {dataIndex: 'COMP_CODE'         , width: 100 , hidden: true},
            {dataIndex: 'WKORD_PRSN'         , width: 100 , hidden: true},
            {dataIndex: 'EXPIRATION_DATE'         , width: 100 , hidden: true},
            {dataIndex: 'GAMMA'         , width: 100 , hidden: true}
        ],
        listeners: {

            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom || !e.record.phantom)   {
                    if (UniUtils.indexOf(e.field,
                                            ['PROG_UNIT','DIV_CODE', 'WKORD_NUM','WORK_SHOP_CODE','PRODT_START_DATE','PRODT_END_DATE'
                                            ,'PRODT_WKORD_DATE','ITEM_CODE','ITEM_NAME','WK_PLAN_NUM','LINE_END_YN','SPEC','WORK_END_YN'
                                            ,'REWORK_YN','STOCK_EXCHG_TYPE','PROJECT_NO','PJT_CODE'/*,'LOT_NO'*/,'UPDATE_DB_USER','UPDATE_DB_TIME','COMP_CODE'
                                            ]))
                            return false;
                }
                if(!e.record.phantom){
                    if (UniUtils.indexOf(e.field,
                                            ['PROG_WORK_CODE','PROG_WORK_NAME','DIV_CODE', 'WKORD_NUM','WORK_SHOP_CODE','PRODT_START_DATE','PRODT_END_DATE'
                                            ,'PRODT_WKORD_DATE','ITEM_CODE','ITEM_NAME','REMARK','WK_PLAN_NUM','LINE_END_YN','SPEC','WORK_END_YN'
                                            ,'REWORK_YN','STOCK_EXCHG_TYPE','PROJECT_NO','PJT_CODE'/*,'LOT_NO'*/,'UPDATE_DB_USER','UPDATE_DB_TIME','COMP_CODE'
                                            //20180705(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
//                                          , 'PRODT_PRSN', 'PRODT_MACH', 'PRODT_TIME', 'DAY_NIGHT'
                                            ]))
                            return false;
                }
                else{ return true }
            }
        },
        disabledLinkButtons: function(b) {
            //this.detailGrid.down('#reqIssueLinkBtn').setDisabled(b);
            detailGrid.down('#reqIssueLinkBtn').setDisabled(b);
        },
        setItemData: function(record, dataClear, grdRecord) {
            //var grdRecord = detailGrid.uniOpt.currentRecord;
            if(dataClear) {
                grdRecord.set('PROG_WORK_CODE'          , '');
                grdRecord.set('PROG_WORK_NAME'          , '');
                grdRecord.set('PROG_UNIT'               ,  panelResult.getValue('PROG_UNIT'));
                grdRecord.set('STD_TIME'                , '');
            }else{
                grdRecord.set('PROG_WORK_CODE'          , record['PROG_WORK_CODE']);
                grdRecord.set('PROG_WORK_NAME'          , record['PROG_WORK_NAME']);
                grdRecord.set('STD_TIME'                , record['STD_TIME']);
                if(grdRecord.get['PROG_UNIT'] != ''){
                    grdRecord.set('PROG_UNIT'           , record['PROG_UNIT']);
                }
                else{
                    grdRecord.set('PROG_UNIT'           , panelResult.getValue('PROG_UNIT'));
                }
            }
        },
        setEstiData: function(record, dataClear, grdRecord) {
            var grdRecord = detailGrid.getSelectedRecord();
            grdRecord.set('DIV_CODE'          ,  record['DIV_CODE']);
            grdRecord.set('ITEM_CODE'         ,  record['ITEM_CODE']);
            grdRecord.set('LINE_SEQ'          ,  record['LINE_SEQ']);
            grdRecord.set('PROG_WORK_CODE'    ,  record['PROG_WORK_CODE']);
            grdRecord.set('PROG_WORK_NAME'    ,  record['PROG_WORK_NAME']);
            grdRecord.set('PROG_UNIT_Q'       ,  record['PROG_UNIT_Q']);
            grdRecord.set('WKORD_Q'           ,  record['PROG_UNIT_Q'] * panelResult.getValue('WKORD_Q'));
            grdRecord.set('PROG_UNIT'         ,  record['PROG_UNIT']);
        },
        setBeforeNewData: function(record, dataClear, grdRecord) {
            var grdRecord = detailGrid.getSelectedRecord();
            grdRecord.set('DIV_CODE'          ,  record['DIV_CODE']);
            grdRecord.set('ITEM_CODE'         ,  record['ITEM_CODE']);
            grdRecord.set('LINE_SEQ'          ,  record['LINE_SEQ']);
            grdRecord.set('PROG_WORK_CODE'    ,  record['PROG_WORK_CODE']);
            grdRecord.set('PROG_WORK_NAME'    ,  record['PROG_WORK_NAME']);
            grdRecord.set('PROG_UNIT_Q'       ,  record['PROG_UNIT_Q']);
            grdRecord.set('WKORD_Q'           ,  record['PROG_UNIT_Q'] * panelResult.getValue('WKORD_Q'));
            grdRecord.set('PROG_UNIT'         ,  record['PROG_UNIT']);
        }
    });

    /**
     * 작업지시를 검색하기 위한 Search Form, Grid, Inner Window 정의
     */
     //조회창 폼 정의
    var productionNoSearch = Unilite.createSearchForm('productionNoSearchForm', {
        layout: {type: 'uniTable', columns : 2},
        trackResetOnLoad: true,
        items: [{
                fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                hidden:true
            },{
                fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
                name: 'WORK_SHOP_CODE',
                xtype: 'uniCombobox',
                comboType: 'WU',
                allowBlank:true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    },
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        store.clearFilter();

                        if(!Ext.isEmpty(productionNoSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == productionNoSearch.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;
                            });
                        }
                    }
                }
            }, {
                fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_PRODT_DATE',
                endFieldName: 'TO_PRODT_DATE',
                width: 350,
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            },
                Unilite.popup('DIV_PUMOK',{
                        fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
                        valueFieldName: 'ITEM_CODE',
                        textFieldName: 'ITEM_NAME',
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    console.log('records : ', records);

                                },
                                scope: this
                            },
                            onClear: function(type) {

                            },
                            applyextparam: function(popup){
                                popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                            }
                    }
            }),{
                fieldLabel: '<t:message code="system.label.product.lotno" default="LOT번호"/>',
                xtype: 'uniTextfield',
                name:'LOT_NO',
                width:315
            }]
    }); // createSearchForm

    // 조회창 모델 정의
    Unilite.defineModel('productionNoMasterModel', {
        fields: [{name: 'WKORD_NUM'                     , text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'     , type: 'string'},
                 {name: 'ITEM_CODE'                     , text: '<t:message code="system.label.product.item" default="품목"/>'                , type: 'string'},
                 {name: 'ITEM_NAME'                     , text: '<t:message code="system.label.product.itemname" default="품목명"/>'               , type: 'string'},
                 {name: 'SPEC'                          , text: '<t:message code="system.label.product.spec" default="규격"/>'                , type: 'string'},
                 {name: 'PRODT_WKORD_DATE'              , text: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>'        , type: 'uniDate'},
                 {name: 'PRODT_START_DATE'              , text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'     , type: 'uniDate'},
                 {name: 'PRODT_END_DATE'                , text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'       , type: 'uniDate'},
                 {name: 'WKORD_Q'                       , text: '<t:message code="system.label.product. wkordq" default="작지수량"/>'           , type: 'uniQty'},
                 {name: 'WK_PLAN_NUM'                   , text: '<t:message code="system.label.product.planno" default="계획번호"/>'            , type: 'string'},
                 {name: 'DIV_CODE'                      , text: '<t:message code="system.label.product.division" default="사업장"/>'           , type: 'string'},
                 {name: 'WORK_SHOP_CODE'                , text: '<t:message code="system.label.product.workcenter" default="작업장"/>'         , type: 'string' , comboType: 'WU'},
                 {name: 'ORDER_NUM'                     , text: '<t:message code="system.label.product.sono" default="수주번호"/>'          , type: 'string'},
                 {name: 'ORDER_Q'                       , text: '<t:message code="system.label.product.soqty" default="수주량"/>'          , type: 'uniQty'},
                 {name: 'REMARK'                        , text: '<t:message code="system.label.product.remarks" default="비고"/>'             , type: 'string'},
                 {name: 'PRODT_Q'                       , text: '<t:message code="system.label.product.productionqty" default="생산량"/>'          , type: 'uniQty'},
                 {name: 'DVRY_DATE'                     , text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'           , type: 'uniDate'},
                 {name: 'STOCK_UNIT'                    , text: '<t:message code="system.label.product.unit" default="단위"/>'                , type: 'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value'},
                 {name: 'PROJECT_NO'                    , text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'       , type: 'string'},
                 {name: 'PJT_CODE'                      , text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'       , type: 'string'},
                 {name: 'LOT_NO'                        , text: 'LOT_NO'            , type: 'string'},

                 {name: 'WORK_END_YN'                   , text: '<t:message code="system.label.product.forceclosingflag" default="강제마감여부"/>'        , type: 'string'},

                 {name: 'CUSTOM'                        , text: '<t:message code="system.label.product.custom" default="거래처"/>'         , type: 'string'},
                 {name: 'REWORK_YN'                     , text: '<t:message code="system.label.product.reworkorderyn" default="재작업지시여부"/>'      , type: 'string'},
                 {name: 'STOCK_EXCHG_TYPE'              , text: '<t:message code="system.label.product.inventoryexchangetype" default="재고대체유형"/>'       , type: 'string'},
                 {name: 'WKORD_PRSN'              , text: 'WKORD_PRSN'       , type: 'string'}

        ]
    });
    //조회창 스토어 정의
    var productionNoMasterStore = Unilite.createStore('productionNoMasterStore', {
            model: 'productionNoMasterModel',
            autoLoad: false,
            uniOpt : {
                isMaster: false,            // 상위 버튼 연결
                editable: false,            // 수정 모드 사용
                deletable:false,            // 삭제 가능 여부
                useNavi : false         // prev | next 버튼 사용
            },
            proxy: directProxy2
            ,loadStoreRecords : function()  {
                var param= productionNoSearch.getValues();
                console.log( param );
                this.load({
                    params : param
                });
            }
    });

    var productionNoMasterGrid = Unilite.createGrid('s_pmp110ukrv_inproductionNoMasterGrid', {
        // title: '기본',
        layout : 'fit',
        store: productionNoMasterStore,
        uniOpt:{
                    useRowNumberer: false
        },
        columns:  [{ dataIndex: 'WORK_SHOP_CODE'                    ,    width: 120 },
                   { dataIndex: 'WKORD_NUM'                         ,    width: 120 },
                   { dataIndex: 'ITEM_CODE'                         ,    width: 100 },
                   { dataIndex: 'ITEM_NAME'                         ,    width: 166 },
                   { dataIndex: 'SPEC'                              ,    width: 100 },
                   { dataIndex: 'PRODT_WKORD_DATE'                  ,    width: 80 },
                   { dataIndex: 'PRODT_START_DATE'                  ,    width: 80 },
                   { dataIndex: 'PRODT_END_DATE'                    ,    width: 80 },
                   { dataIndex: 'WKORD_Q'                           ,    width: 73 },
                   { dataIndex: 'WK_PLAN_NUM'                       ,    width: 100 ,hidden: true},
                   { dataIndex: 'DIV_CODE'                          ,    width: 0   ,hidden: true},

                   { dataIndex: 'ORDER_NUM'                         ,    width: 0   ,hidden: true},
                   { dataIndex: 'ORDER_Q'                           ,    width: 0   ,hidden: true},
                   { dataIndex: 'REMARK'                            ,    width: 100 },
                   { dataIndex: 'PRODT_Q'                           ,    width: 0   ,hidden: true},
                   { dataIndex: 'DVRY_DATE'                         ,    width: 0   ,hidden: true},
                   { dataIndex: 'STOCK_UNIT'                        ,    width: 33  ,hidden: true},
                   { dataIndex: 'PROJECT_NO'                        ,    width: 100 },
                   { dataIndex: 'PJT_CODE'                          ,    width: 100 },
                   { dataIndex: 'LOT_NO'                            ,    width: 133 },
                   { dataIndex: 'WORK_END_YN'                       ,    width: 100 ,hidden: true},
                   { dataIndex: 'CUSTOM'                            ,    width: 100 ,hidden: true},
                   { dataIndex: 'REWORK_YN'                         ,    width: 100 ,hidden: true},
                   { dataIndex: 'STOCK_EXCHG_TYPE'                  ,    width: 100 ,hidden: true}
          ] ,
          listeners: {
              onGridDblClick: function(grid, record, cellIndex, colName) {
                    this.returnData(record);
                    UniAppManager.app.onQueryButtonDown();
                    searchInfoWindow.hide();
              }
          },
            returnData: function(record)    {
                if(Ext.isEmpty(record)) {
                    record = this.getSelectedRecord();
                }
                panelResult.uniOpt.inLoading = true;
                panelResult.getField('REWORK_YN').setValue(record.get('REWORK_YN'));


                panelResult.setValues({'DIV_CODE':record.get('DIV_CODE'),   /*사업장*/       'WKORD_NUM':record.get('WKORD_NUM'),               /*작업지시번호*/
                                      'WORK_SHOP_CODE':record.get('WORK_SHOP_CODE'), /* 작업장*/'ITEM_CODE':record.get('ITEM_CODE'),                /*품목코드*/
                                      'ITEM_NAME':record.get('ITEM_NAME'),  /*품목명*/       'SPEC':record.get('SPEC'),                         /*규격*/
                                      'PRODT_WKORD_DATE':record.get('PRODT_WKORD_DATE'),      'PRODT_START_DATE':record.get('PRODT_START_DATE'),
                                      'PRODT_END_DATE':record.get('PRODT_END_DATE'),          'LOT_NO':record.get('LOT_NO'),
                                      'WKORD_Q':record.get('WKORD_Q'),                        'PROG_UNIT':record.get('STOCK_UNIT'),
                                      'PROJECT_NO':record.get('PROJECT_NO'),                  'ANSWER':record.get('REMARK'),
                                      'PJT_CODE':record.get('PJT_CODE'),                      'WORK_END_YN':record.get('WORK_END_YN'),
                                      'ORDER_NUM':record.get('ORDER_NUM'),  /* 수주번호*/         'ORDER_Q':record.get('ORDER_Q'),                  /* 수주량*/
                                      'DVRY_DATE':record.get('DVRY_DATE'),  /* 납기일*/          'CUSTOM':record.get('CUSTOM'),
                                      'PROG_UNIT':record.get('STOCK_UNIT'),                   'EXCHG_TYPE':record.get('STOCK_EXCHG_TYPE'),
                                      'WKORD_PRSN' : record.get('WKORD_PRSN'), 'EXPIRATION_DATE':record.get('EXPIRATION_DATE'),
                                      'GAMMA':record.get('GAMMA')
                                      });



                panelResult.getField('DIV_CODE').setReadOnly( true );
                panelResult.getField('WKORD_NUM').setReadOnly( true );
             //   panelResult.getField('WORK_SHOP_CODE').setReadOnly( true );
                panelResult.getField('ITEM_CODE').setReadOnly( true );
                panelResult.getField('ITEM_NAME').setReadOnly( true );
                panelResult.getField('REWORK_YN').setReadOnly( true );
//              panelResult.getField('SPEC').setReadOnly( true );
                panelResult.getField('PROG_UNIT').setReadOnly( true );
                panelResult.getField('WORK_END_YN').setReadOnly( false );

                Ext.getCmp('reworkRe').setReadOnly(true);
                Ext.getCmp('workEndYnRe').setReadOnly(false);

                detailGrid.down('#requestBtn').setDisabled(true); // 데이터 Set 될때 생산계획 참조 Disabled
                panelResult.uniOpt.inLoading = false;
          }
    });

    //조회창 메인
    function opensearchInfoWindow() {
        if(!searchInfoWindow) {
            searchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.product.workorderinfo" default="작업지시정보"/>',
                width: 830,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [productionNoSearch, productionNoMasterGrid],
                tbar:  ['->',
                        {   itemId : 'searchBtn',
                            text: '<t:message code="system.label.product.inquiry" default="조회"/>',
                            handler: function() {
                                if(!productionNoSearch.getInvalidMessage()) {
                                    return false;
                                }
                                productionNoMasterStore.loadStoreRecords();
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
                listeners : {beforehide: function(me, eOpt) {
                                            productionNoSearch.clearForm();
                                            productionNoMasterGrid.reset();
                                        },
                             beforeclose: function( panel, eOpts )  {
                                            productionNoSearch.clearForm();
                                            productionNoMasterGrid.reset();
                                        },
                             show: function( panel, eOpts ) {
                                productionNoSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
                                productionNoSearch.setValue('WORK_SHOP_CODE',panelResult.getValue('WORK_SHOP_CODE'));
                                productionNoSearch.setValue('ITEM_CODE',panelResult.getValue('ITEM_CODE'));
                                productionNoSearch.setValue('ITEM_NAME',panelResult.getValue('ITEM_NAME'));

                                productionNoSearch.setValue('FR_PRODT_DATE',UniDate.get('startOfMonth'));
                                productionNoSearch.setValue('TO_PRODT_DATE',UniDate.get('today'));
                             }
                }
            })
        }
        searchInfoWindow.center();
        searchInfoWindow.show();
    }


    /**
     * 생산계획을 참조하기 위한 Search Form, Grid, Inner Window 정의
     */
    //생산계획 참조 폼 정의
    var productionPlanSearch = Unilite.createSearchForm('productionPlanForm', {
            layout :  {type : 'uniTable', columns : 2},
                items: [{
                    fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
                    name: 'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType: 'BOR120',
                    hidden:true
                },{
                    fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
                    name: 'WORK_SHOP_CODE',
                    xtype: 'uniCombobox',
                    comboType: 'WU'
                },{
                    fieldLabel: '<t:message code="system.label.product.plandate" default="계획일"/>',
                    xtype: 'uniDateRangefield',
                    startFieldName: 'OUTSTOCK_REQ_DATE_FR',
                    endFieldName: 'OUTSTOCK_REQ_DATE_TO',
                    width: 315,
                    startDate: UniDate.get('today'),            /* DB today */
                    endDate: UniDate.get('todayForMonth'),      /* DB today + 1달  */
                    allowBlank:false
                },
                    Unilite.popup('DIV_PUMOK',{
                    fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
                    valueFieldName: 'ITEM_CODE',
                    textFieldName: 'ITEM_NAME',
                    listeners: {
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }
                    }
           })]
    });

//    //생산계획 참조 입력set 데이터용
//    var productionPlanInputForm = Unilite.createSearchForm('productionPlanInputFormForm', {
//        layout :  {type : 'uniTable', columns : 2},
//        items: [{
//            fieldLabel: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
//            xtype: 'uniDatefield',
//            name: 'PRODT_WKORD_DATE',
//            holdable: 'hold',
//            allowBlank:false,
//            value: new Date()
//        },{
//            fieldLabel: 'LOT_NO',
//            xtype:'uniTextfield',
//            labelWidth: 271,
//            name: 'LOT_NO'
//        },{
//            fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
//            xtype: 'uniDatefield',
//            name: 'PRODT_START_DATE',
//            holdable: 'hold',
//            allowBlank:false,
//            value: new Date()
//        },{
//            fieldLabel: '<t:message code="system.label.product.completiondate" default="완료예정일"/>',
//            xtype: 'uniDatefield',
//            name: 'PRODT_END_DATE',
//            holdable: 'hold',
//            labelWidth: 271,
//            allowBlank:false,
//            value: new Date()
//        },{
//            xtype: 'container',
//            layout: { type: 'uniTable', columns: 3},
//            defaultType: 'uniTextfield',
//            defaults : {enforceMaxLength: true},
//            items:[{
//                fieldLabel: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
//                xtype: 'uniNumberfield',
//                name: 'WKORD_Q',
//                value: '0.00',
//                holdable: 'hold',
//                allowBlank:false
//            },{
//                name:'PROG_UNIT',
//                xtype:'uniTextfield',
//                holdable: 'hold',
//                width: 50,
//                readOnly:true,
//                fieldStyle: 'text-align: center;'
//            }]
//        }]
//    });

    Unilite.defineModel('s_pmp110ukrv_inProductionPlanModel', {
        fields: [
            {name: 'GUBUN'                  , text: '<t:message code="system.label.product.selection" default="선택"/>'               , type: 'string'},
            {name: 'DIV_CODE'               , text: '<t:message code="system.label.product.mfgplace" default="제조처"/>'           , type: 'string'},
            {name: 'WORK_SHOP_CODE'         , text: '<t:message code="system.label.product.workcenter" default="작업장"/>'         , type: 'string' , comboType: 'WU'},
            {name: 'WK_PLAN_NUM'            , text: '<t:message code="system.label.product.productionplanno" default="생산계획번호"/>'        , type: 'string'},
            {name: 'PROD_ITEM_CODE'		, text: '<t:message code="system.label.product.goods" default="제품"/>'	, type: 'string'},
            {name: 'ITEM_CODE'              , text: '<t:message code="system.label.product.item" default="품목"/>'            , type: 'string'},
            {name: 'ITEM_NAME'              , text: '<t:message code="system.label.product.itemname" default="품목명"/>'           , type: 'string'},
            {name: 'SPEC'                   , text: '<t:message code="system.label.product.spec" default="규격"/>'            , type: 'string'},
            {name: 'STOCK_UNIT'             , text: '<t:message code="system.label.product.unit" default="단위"/>'            , type: 'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value'},
            {name: 'WK_PLAN_Q'              , text: '<t:message code="system.label.product.planqty" default="계획량"/>'            , type: 'uniQty'},
            {name: 'WKORD_Q'                , text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'          , type: 'uniQty'},
            {name: 'WKORD_REMAIN_Q'         , text: '<t:message code="system.label.product.balanceqty" default="잔량"/>'           , type: 'uniQty'},
            {name: 'PRODUCT_LDTIME'         , text: '<t:message code="system.label.product.mfglt" default="제조 L/T"/>'       , type: 'string'},
            {name: 'PRODT_START_DATE'       , text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'     , type: 'uniDate'},
            {name: 'PRODT_PLAN_DATE'        , text: '<t:message code="system.label.product.planfinisheddate" default="계획완료일"/>'     , type: 'uniDate'},
            {name: 'ORDER_NUM'              , text: '<t:message code="system.label.product.sono" default="수주번호"/>'          , type: 'string'},
            {name: 'ORDER_DATE'             , text: '<t:message code="system.label.product.sodate" default="수주일"/>'         , type: 'string'},
            {name: 'ORDER_Q'                , text: '<t:message code="system.label.product.soqty" default="수주량"/>'          , type: 'uniQty'},
            {name: 'CUSTOM_CODE'            , text: '<t:message code="system.label.product.customname" default="거래처명"/>'            , type: 'string'},
            {name: 'DVRY_DATE'              , text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'           , type: 'uniDate'},
            {name: 'EXPIRATION_DAY'         , text: '제품유효기간'                                                                   , type: 'int'},
            {name: 'PROJECT_NO'             , text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'       , type: 'string'},
            {name: 'PJT_CODE'               , text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'       , type: 'string'},
            {name: 'GAMMA'               , text: '감마'       , type: 'string'}
        ]
    });

    var productionPlanStore = Unilite.createStore('s_pmp110ukrv_inProductionPlanStore', {
            model: 's_pmp110ukrv_inProductionPlanModel',
            autoLoad: false,
            uniOpt : {
                isMaster: false,            // 상위 버튼 연결
                editable: false,            // 수정 모드 사용
                deletable:false,            // 삭제 가능 여부
                useNavi : false         // prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                    read    : 's_pmp110ukrv_inService.selectEstiList'
                }
            },
            loadStoreRecords : function()   {
                var param= productionPlanSearch.getValues();
                console.log( param );
                this.load({
                    params : param
                });
            }
    });

    var productionPlanGrid = Unilite.createGrid('s_pmp110ukrv_inproductionPlanGrid', {
        layout : 'fit',
        store: productionPlanStore,
        selModel: 'rowmodel',
        uniOpt:{
            onLoadSelectFirst : true
        },
        columns: [
            {dataIndex: 'GUBUN'                     , width:0  ,hidden: true},
            {dataIndex: 'DIV_CODE'                  , width:0  ,hidden: true},
            {dataIndex: 'WORK_SHOP_CODE'            , width:100
//                         listeners:{
//                            render:function(elm)    {
//                                var tGrid = elm.getView().ownerGrid;
//                                elm.editor.on('beforequery',function(queryPlan, eOpts)  {
//
//                                    var grid = tGrid;
//                                    var record = grid.uniOpt.currentRecord;
//
//                                    var store = queryPlan.combo.store;
//                                    store.clearFilter();
//                                    store.filterBy(function(item){
//                                        return item.get('option') == record.get('DIV_CODE');
//                                    })
//                                });
//                                elm.editor.on('collapse',function(combo,  eOpts )   {
//                                    var store = combo.store;
//                                    store.clearFilter();
//                                });
//                            }
//                        }
                        },
            {dataIndex: 'WK_PLAN_NUM'               , width:100,hidden: true},
            {dataIndex: 'PROD_ITEM_CODE'                 , width:100},
            {dataIndex: 'ITEM_CODE'                 , width:100},
            {dataIndex: 'ITEM_NAME'                 , width:126},
            {dataIndex: 'SPEC'                      , width:120},
            {dataIndex: 'STOCK_UNIT'                , width:40, align: 'center'},
            {dataIndex: 'WK_PLAN_Q'                 , width:73},
            {dataIndex: 'WKORD_Q'                   , width:100},
            {dataIndex: 'WKORD_REMAIN_Q'            , width:73},
            {dataIndex: 'PRODUCT_LDTIME'            , width:80},
            {dataIndex: 'PRODT_START_DATE'          , width:73},
            {dataIndex: 'PRODT_PLAN_DATE'           , width:73},
            {dataIndex: 'ORDER_NUM'                 , width:93},
            {dataIndex: 'ORDER_DATE'                , width:73},
            {dataIndex: 'ORDER_Q'                   , width:73},
            {dataIndex: 'CUSTOM_CODE'               , width:100},
            {dataIndex: 'DVRY_DATE'                 , width:73 ,hidden: true},
            {dataIndex: 'EXPIRATION_DAY'            , width:73 ,hidden: true},
            {dataIndex: 'PROJECT_NO'                , width:80 ,hidden: true},
            {dataIndex: 'PJT_CODE'                  , width:80 ,hidden: true},
            {dataIndex: 'GAMMA'                  , width:80 ,hidden: true},
        ],
        listeners: {
              onGridDblClick: function(grid, record, cellIndex, colName) {
                   // if(!productionPlanInputForm.getInvalidMessage()) return;
                    productionPlanGrid.returnData(record);
                    referProductionPlanWindow.hide();
                    panelResult.getField('REWORK_YN').setReadOnly( false );
              }
//              selectionchange: function( grid, selected, eOpts ) {
//                    var record = selected[0];
//                    if(record){
//                        productionPlanInputForm.setValue('PRODT_START_DATE',record.get('PRODT_START_DATE'));
//                        productionPlanInputForm.setValue('PRODT_END_DATE',record.get('PRODT_PLAN_DATE'));
//                        productionPlanInputForm.setValue('WKORD_Q',record.get('WKORD_REMAIN_Q'));
//                        productionPlanInputForm.setValue('PROG_UNIT',record.get('STOCK_UNIT'));
//                    }
//              }
          },
            returnData: function(record)    {
                panelResult.uniOpt.inLoading = true;
                if(Ext.isEmpty(record)) {
                    record = this.getSelectedRecord();
                    panelResult.getField('REWORK_YN').setReadOnly( false );
                }
                panelResult.getField('REWORK_YN').setValue(record.get('REWORK_YN'));


                panelResult.setValues({'DIV_CODE':record.get('DIV_CODE'),   /*사업장*/       'WKORD_NUM':record.get('WKORD_NUM'),               /*작업지시번호*/
                                      'WORK_SHOP_CODE':record.get('WORK_SHOP_CODE'), /* 작업장*/'ITEM_CODE':record.get('ITEM_CODE'),                /*품목코드*/
                                      'ITEM_NAME':record.get('ITEM_NAME'),  /*품목명*/       'SPEC':record.get('SPEC'),                         /*규격*/
//                                      'PRODT_START_DATE':productionPlanInputForm.getValue('PRODT_START_DATE'),    'PRODT_WKORD_DATE': productionPlanInputForm.getValue('PRODT_WKORD_DATE'),
//                                      'PRODT_END_DATE':productionPlanInputForm.getValue('PRODT_END_DATE'),        'LOT_NO':productionPlanInputForm.getValue('LOT_NO'),
//                                      'WKORD_Q':productionPlanInputForm.getValue('WKORD_Q'),                      'PROG_UNIT':productionPlanInputForm.getValue('PROG_UNIT'),
                                      'PROJECT_NO':record.get('PROJECT_NO'),                  'ANSWER':record.get('REMARK'),
                                      'PJT_CODE':record.get('PJT_CODE'),                      'WORK_END_YN':record.get('WORK_END_YN'),
                                      'ORDER_NUM':record.get('ORDER_NUM'),  /* 수주번호*/         'ORDER_Q':record.get('ORDER_Q'),                  /* 수주량*/
                                      'DVRY_DATE':record.get('DVRY_DATE'),  /* 납기일*/          'CUSTOM':record.get('CUSTOM_CODE'),
                                      /*'REWORK_YN':record.get('REWORK_YN'),*/                'PROG_UNIT':record.get('STOCK_UNIT'),
                                      'EXCHG_TYPE':record.get('STOCK_EXCHG_TYPE'),            'WKORD_Q':record.get('WKORD_REMAIN_Q'),
                                      'WK_PLAN_NUM':record.get('WK_PLAN_NUM'),                'PRODT_START_DATE':record.get('PRODT_START_DATE'),
                                      'PRODT_WKORD_DATE':new Date(),                          'PRODT_END_DATE':record.get('PRODT_PLAN_DATE'),
                                      'LOT_NO':record.get('LOT_NO'),                          'PROG_UNIT':record.get('STOCK_UNIT'),
                                      'GAMMA':record.get('GAMMA')
                                      });
               /*  if(record.get('EXPIRATION_DAY') != 0){
                    panelResult.setValue('EXPIRATION_DATE',UniDate.getDbDateStr(UniDate.add(panelResult.getValue('PRODT_WKORD_DATE'), {months: +record.get('EXPIRATION_DAY'), days:-1})));
                }else{
                    panelResult.setValue('EXPIRATION_DATE', '');
                } */

                Ext.getCmp('reworkRe').setReadOnly(false);
                Ext.getCmp('workEndYnRe').setReadOnly(true);

                panelResult.getField('DIV_CODE').setReadOnly( true );
                panelResult.getField('WKORD_NUM').setReadOnly( true );
                if(!Ext.isEmpty(panelResult.getValue('WORK_SHOP_CODE'))){
                    //panelResult.getField('WORK_SHOP_CODE').setReadOnly( true );
                    UniAppManager.app.onNewDataButtonDown();
                }else{
                	//panelResult.getField('WORK_SHOP_CODE').setReadOnly( false );
                }
                panelResult.getField('WORK_SHOP_CODE').setReadOnly( false );
                panelResult.getField('ITEM_CODE').setReadOnly( true );
                panelResult.getField('ITEM_NAME').setReadOnly( true );
//              panelResult.getField('SPEC').setReadOnly( true );
                panelResult.getField('EXCHG_TYPE').setReadOnly( true );
                panelResult.getField('PROG_UNIT').setReadOnly( true );
                panelResult.getField('WKORD_Q').setReadOnly( false );
                panelResult.getField('ANSWER').setReadOnly( false );

                detailGrid.down('#requestBtn').setDisabled(true);
                panelResult.uniOpt.inLoading = false;
                fnCreateLotno(UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE')), panelResult.getValue('ITEM_CODE'));

        		panelResult.setValue('EXPIRATION_DAY2', record.get('EXPIRATION_DAY'));
				panelResult.setValue('PRODUCT_LDTIME', record.get('PRODUCT_LDTIME'));
            	var expirationDay = panelResult.getValue('EXPIRATION_DAY2');
				var productLdtime = panelResult.getValue('PRODUCT_LDTIME');
				fnCalDate(expirationDay, productLdtime);
                //20170517 - 사용 안 함(주석)
//                detailGrid.getStore().setProxy(directProxy3);  /* proxy 변경 후 조회 */

                //20170517 - onNewDataButtonDown에서 수행하는 로직이라 주석 처리
//              var param = {
//                    "DIV_CODE"          : record.get('DIV_CODE'),
//                    "ITEM_CODE"         : record.get('ITEM_CODE'),
//                    "WORK_SHOP_CODE"    : record.get('WORK_SHOP_CODE')
//                };
//              s_pmp110ukrv_inService.selectProgInfo(param, function(provider, response) {
//                  var records = response.result;
//                  Ext.each(records, function(record,i){


//                       detailGrid.setEstiData(record);
//                    });
//              });
          }
    });


    function openProductionPlanWindow() {
        if(!referProductionPlanWindow) {
            referProductionPlanWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.product.productionplaninfo" default="생산계획정보"/>',
                width: 830,
                height: 580,
                layout:{type:'vbox', align:'stretch'},

                items: [productionPlanSearch, productionPlanGrid],
                tbar:  ['->',
                                        {   itemId : 'saveBtn',
                                            text: '<t:message code="system.label.product.inquiry" default="조회"/>',
                                            handler: function() {
                                                if(!productionPlanSearch.getInvalidMessage()) return;
                                                productionPlanStore.loadStoreRecords();
                                            },
                                            disabled: false
                                        },
                                        {   itemId : 'confirmBtn',
                                            text: '<t:message code="system.label.product.apply" default="적용"/>',
                                            handler: function() {
                                                //if(!productionPlanInputForm.getInvalidMessage()) return;
                                                productionPlanGrid.returnData();
                                                referProductionPlanWindow.hide();
                                            },
                                            disabled: false
                                        },
                                        {   itemId : 'confirmCloseBtn',
                                            text: '<t:message code="system.label.product.afterapplyclose" default="적용 후 닫기"/>',
                                            handler: function() {
                                                //if(!productionPlanInputForm.getInvalidMessage()) return;
                                                productionPlanGrid.returnData();
                                                referProductionPlanWindow.hide();

                                            },
                                            disabled: false
                                        },{
                                            itemId : 'closeBtn',
                                            text: '<t:message code="system.label.product.close" default="닫기"/>',
                                            handler: function() {
                                                referProductionPlanWindow.hide();
                                            },
                                            disabled: false
                                        }
                                ]
                            ,
                listeners : {beforehide: function(me, eOpt) {
                                            //requestSearch.clearForm();
                                            //requestGrid,reset();
                                        },
                             beforeclose: function( panel, eOpts )  {
                                            //requestSearch.clearForm();
                                            //requestGrid,reset();
                                        },
                             beforeshow: function ( me, eOpts ) {
                                productionPlanSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
                                productionPlanSearch.setValue('WORK_SHOP_CODE',panelResult.getValue('WORK_SHOP_CODE'));
                                productionPlanSearch.setValue('ITEM_CODE',panelResult.getValue('ITEM_CODE'));
                                productionPlanSearch.setValue('ITEM_NAME',panelResult.getValue('ITEM_NAME'));
//                                productionPlanInputForm.setValue('PRODT_WKORD_DATE',panelResult.getValue('PRODT_WKORD_DATE'));
//                                productionPlanInputForm.setValue('PRODT_START_DATE',panelResult.getValue('PRODT_START_DATE'));
//                                productionPlanInputForm.setValue('PRODT_END_DATE',panelResult.getValue('PRODT_END_DATE'));
                                //productionPlanSearch.setValue('OUTSTOCK_REQ_DATE_FR',UniDate.get('today'));
                                //productionPlanSearch.setValue('TO_PRODT_DATE',UniDate.get('todayForMonth'));


                                productionPlanStore.loadStoreRecords();
                             }
                }
            })
        }
        referProductionPlanWindow.center();
        referProductionPlanWindow.show();
    }



   /**
     * main app
     */
    Unilite.Main ({
        borderItems: [{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                panelResult, detailGrid
            ]
        }/*,
        panelSearch*/
        ],
        id: 'pmp100ukrvApp',
        fnInitBinding: function() {
            UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);
            detailGrid.disabledLinkButtons(false);
            this.setDefault();

            var requestBtn = detailGrid.down('#requestBtn')

        },
        onQueryButtonDown: function() {
            var orderNo = panelResult.getValue('WKORD_NUM');
            if(Ext.isEmpty(orderNo)) {
                opensearchInfoWindow();
//              productionNoMasterStore.loadStoreRecords();

            } else {
                //20170517 - 주석
//              detailGrid.getStore().setProxy(directProxy);  /* proxy 변경 후 조회 */
                detailStore.loadStoreRecords();
//                panelSearch.setAllFieldsReadOnly(true);
                panelResult.setAllFieldsReadOnly(true);
                panelResult.getField('WKORD_Q').setReadOnly( false );
                panelResult.getField('ANSWER').setReadOnly( false );

            }
        },
        onNewDataButtonDown: function() {
            if(!this.checkForNewDetail()) return false;
                /**
                 * Detail Grid Default 값 설정
                 */

                var param = panelResult.getValues();
                s_pmp110ukrv_inService.selectProgInfo(param, function(provider, response) {
                    var records = response.result;
                    if(!Ext.isEmpty(provider)) {
                        var count = detailGrid.getStore().getCount();
                        if(count <= 0) {
                            Ext.each(records, function(record,i) {
                                var seq = detailStore.max('SER_NO');
                                 if(!seq) seq = 1;
                                 else  seq += 1;
                                var linSeq = detailStore.max('LINE_SEQ');
                                if(!linSeq) linSeq = 1;
                                else  linSeq += 1;
                                var compCode       = UserInfo.compCode;
                                var divCode        = panelResult.getValue('DIV_CODE');
                                var wkordNum       = panelResult.getValue('WKORD_NUM');
                                var workShopCode   = panelResult.getValue('WORK_SHOP_CODE');
                                var itemCode       = panelResult.getValue('ITEM_CODE');
                                var itemName       = panelResult.getValue('ITEM_NAME');
                                var spec           = panelResult.getValue('SPEC');
                                var prodtStartDate = panelResult.getValue('PRODT_START_DATE');
                                var prodtEndDate   = panelResult.getValue('PRODT_END_DATE');
                                var prodtWkordDate = panelResult.getValue('PRODT_WKORD_DATE');
                                var lotNo          = panelResult.getValue('LOT_NO');
                                var wkordQ         = panelResult.getValue('WKORD_Q');
                                var progUnit       = panelResult.getValue('PROG_UNIT');
                                var projectNo      = panelResult.getValue('PROJECT_NO');
                                var pjtCode        = panelResult.getValue('PJT_CODE');
                                var answer         = panelResult.getValue('ANSWER');
                                var workEndYn      = Ext.getCmp('workEndYnRe').getChecked()[0].inputValue;
                                var exchgType      = panelResult.getValue('EXCHG_TYPE');
                                var reworkYn       = Ext.getCmp('reworkRe').getChecked()[0].inputValue;
                                var progUnitQ      = 1;
                                var wkPlanNum      = panelResult.getValue('WK_PLAN_NUM');
                                var expirationDate      = panelResult.getValue('EXPIRATION_DATE');
                                var gamma      = Ext.getCmp('gamma').getChecked()[0].inputValue;
                                var r = {
                                   SER_NO            : seq,
                                   LINE_SEQ          : linSeq,
                                   COMP_CODE         : compCode,
                                   DIV_CODE          : divCode,
                                   WKORD_NUM         : wkordNum,
                                   WORK_SHOP_CODE    : workShopCode,
                                   ITEM_CODE         : itemCode,
                                   ITEM_NAME         : itemName,
                                   SPEC              : spec,
                                   PRODT_WKORD_DATE  : prodtWkordDate,
                                   PRODT_START_DATE  : prodtStartDate,
                                   PRODT_END_DATE    : prodtEndDate,
                                   LOT_NO            : lotNo,
                                   WKORD_Q           : wkordQ,
                                   PROG_UNIT         : progUnit,
                                   PROJECT_NO        : projectNo,
                                   REMARK            : answer,
                                   PJT_CODE          : pjtCode,
                                   WORK_END_YN       : workEndYn,
                                   STOCK_EXCHG_TYPE  : exchgType,
                                   REWORK_YN         : reworkYn,
                                   PROG_UNIT_Q       : progUnitQ,
                                   WK_PLAN_NUM       : wkPlanNum,
                                   EXPIRATION_DATE  : expirationDate,
                                   GAMMA					: gamma

                                };
                                detailGrid.createRow(r);

                               detailGrid.setBeforeNewData(record);
                            });
                        } else {
                            var seq = detailStore.max('SER_NO');
                             if(!seq) seq = 1;
                             else  seq += 1;
                            var linSeq = detailStore.max('LINE_SEQ');
                            if(!linSeq) linSeq = 1;
                            else  linSeq += 1;
                            var compCode       = UserInfo.compCode;
                            var divCode        = panelResult.getValue('DIV_CODE');
                            var wkordNum       = panelResult.getValue('WKORD_NUM');
                            var workShopCode   = panelResult.getValue('WORK_SHOP_CODE');
                            var itemCode       = panelResult.getValue('ITEM_CODE');
                            var itemName       = panelResult.getValue('ITEM_NAME');
                            var spec           = panelResult.getValue('SPEC');
                            var prodtStartDate = panelResult.getValue('PRODT_WKORD_DATE');
                            var prodtEndDate   = panelResult.getValue('PRODT_START_DATE');
                            var prodtWkordDate = panelResult.getValue('PRODT_END_DATE');
                            var lotNo          = panelResult.getValue('LOT_NO');
                            var wkordQ         = panelResult.getValue('WKORD_Q');
                            var progUnit       = panelResult.getValue('PROG_UNIT');
                            var projectNo      = panelResult.getValue('PROJECT_NO');
                            var pjtCode        = panelResult.getValue('PJT_CODE');
                            var answer         = panelResult.getValue('ANSWER');
                            var workEndYn      = Ext.getCmp('workEndYnRe').getChecked()[0].inputValue;
                            var exchgType      = panelResult.getValue('EXCHG_TYPE');
                            var reworkYn       = Ext.getCmp('reworkRe').getChecked()[0].inputValue;
                            var progUnitQ      = 1;
                            var wkPlanNum      = panelResult.getValue('WK_PLAN_NUM');
                            var gamma      = Ext.getCmp('gamma').getChecked()[0].inputValue;
                            var r = {
                               SER_NO            : seq,
                               LINE_SEQ          : linSeq,
                               COMP_CODE         : compCode,
                               DIV_CODE          : divCode,
                               WKORD_NUM         : wkordNum,
                               WORK_SHOP_CODE    : workShopCode,
                               ITEM_CODE         : itemCode,
                               ITEM_NAME         : itemName,
                               SPEC              : spec,
                               PRODT_WKORD_DATE  : prodtWkordDate,
                               PRODT_START_DATE  : prodtStartDate,
                               PRODT_END_DATE    : prodtEndDate,
                               LOT_NO            : lotNo,
                               WKORD_Q           : wkordQ,
                               PROG_UNIT         : progUnit,
                               PROJECT_NO        : projectNo,
                               REMARK            : answer,
                               PJT_CODE          : pjtCode,
                               WORK_END_YN       : workEndYn,
                               STOCK_EXCHG_TYPE  : exchgType,
                               REWORK_YN         : reworkYn,
                               PROG_UNIT_Q       : progUnitQ,
                               WK_PLAN_NUM       : wkPlanNum,
                               GAMMA					: gamma
                            };
                            detailGrid.createRow(r);
                        }
                    } else {
                        var seq = detailStore.max('SER_NO');
                         if(!seq) seq = 1;
                         else  seq += 1;
                        var linSeq = detailStore.max('LINE_SEQ');
                        if(!linSeq) linSeq = 1;
                        else  linSeq += 1;
                        var compCode       = UserInfo.compCode;
                        var divCode        = panelResult.getValue('DIV_CODE');
                        var wkordNum       = panelResult.getValue('WKORD_NUM');
                        var workShopCode   = panelResult.getValue('WORK_SHOP_CODE');
                        var itemCode       = panelResult.getValue('ITEM_CODE');
                        var itemName       = panelResult.getValue('ITEM_NAME');
                        var spec           = panelResult.getValue('SPEC');
                        var prodtStartDate = panelResult.getValue('PRODT_WKORD_DATE');
                        var prodtEndDate   = panelResult.getValue('PRODT_START_DATE');
                        var prodtWkordDate = panelResult.getValue('PRODT_END_DATE');
                        var lotNo          = panelResult.getValue('LOT_NO');
                        var wkordQ         = panelResult.getValue('WKORD_Q');
                        var progUnit       = panelResult.getValue('PROG_UNIT');
                        var projectNo      = panelResult.getValue('PROJECT_NO');
                        var pjtCode        = panelResult.getValue('PJT_CODE');
                        var answer         = panelResult.getValue('ANSWER');
                        var workEndYn      = Ext.getCmp('workEndYnRe').getChecked()[0].inputValue;
                        var exchgType      = panelResult.getValue('EXCHG_TYPE');
                        var reworkYn       = Ext.getCmp('reworkRe').getChecked()[0].inputValue;
                        var progUnitQ      = 1;
                        var wkPlanNum      = panelResult.getValue('WK_PLAN_NUM');
                        var gamma      = Ext.getCmp('gamma').getChecked()[0].inputValue;

                        var r = {
                           SER_NO            : seq,
                           LINE_SEQ          : linSeq,
                           COMP_CODE         : compCode,
                           DIV_CODE          : divCode,
                           WKORD_NUM         : wkordNum,
                           WORK_SHOP_CODE    : workShopCode,
                           ITEM_CODE         : itemCode,
                           ITEM_NAME         : itemName,
                           SPEC              : spec,
                           PRODT_WKORD_DATE  : prodtWkordDate,
                           PRODT_START_DATE  : prodtStartDate,
                           PRODT_END_DATE    : prodtEndDate,
                           LOT_NO            : lotNo,
                           WKORD_Q           : wkordQ,
                           PROG_UNIT         : progUnit,
                           PROJECT_NO        : projectNo,
                           REMARK            : answer,
                           PJT_CODE          : pjtCode,
                           WORK_END_YN       : workEndYn,
                           STOCK_EXCHG_TYPE  : exchgType,
                           REWORK_YN         : reworkYn,
                           PROG_UNIT_Q       : progUnitQ,
                           WK_PLAN_NUM       : wkPlanNum,
                           GAMMA					: gamma

                        };
                        detailGrid.createRow(r);
                    }
                });
                UniAppManager.app.setReadOnly(true);
                panelResult.getField('WKORD_Q').setReadOnly( false );
                panelResult.getField('ANSWER').setReadOnly( false );
            },
        onResetButtonDown: function() {
            panelResult.uniOpt.inLoading = true;
            this.suspendEvents();
            panelResult.clearForm();
            panelResult.setAllFieldsReadOnly(false);
            detailGrid.reset();
            detailStore.clearData();
            this.fnInitBinding();
            panelResult.getField('WKORD_NUM').focus();

            //20170517 - 아래 setReadOnly 호출하는 부분으로 대체
//          panelSearch.getField('DIV_CODE').setReadOnly( false );
//          panelSearch.getField('WKORD_NUM').setReadOnly( false );
//          panelSearch.getField('WORK_SHOP_CODE').setReadOnly( false );
//          panelSearch.getField('ITEM_CODE').setReadOnly( false );
//          panelSearch.getField('ITEM_NAME').setReadOnly( false );
//          panelSearch.getField('EXCHG_TYPE').setReadOnly( true );

//            panelSearch.getField('PRODT_WKORD_DATE').setReadOnly( false );
//            panelSearch.getField('PRODT_START_DATE').setReadOnly( false );
//            panelSearch.getField('PRODT_END_DATE').setReadOnly( false );
//            panelSearch.getField('LOT_NO').setReadOnly( false );
//            panelSearch.getField('WKORD_Q').setReadOnly( false );
//            panelSearch.getField('ANSWER').setReadOnly( false );
//            panelSearch.getField('PROJECT_NO').setReadOnly( false );
//            panelSearch.getField('PROJECT_CODE').setReadOnly( false );

            //20170517 - 아래 setReadOnly 호출하는 부분으로 대체
//          panelResult.getField('DIV_CODE').setReadOnly( false );
//          panelResult.getField('WKORD_NUM').setReadOnly( false );
//          panelResult.getField('WORK_SHOP_CODE').setReadOnly( false );
//          panelResult.getField('ITEM_CODE').setReadOnly( false );
//          panelResult.getField('ITEM_NAME').setReadOnly( false );
//          panelResult.getField('EXCHG_TYPE').setReadOnly( true );

            //20170517 - setReadOnly 호출도록 변경
            UniAppManager.app.setReadOnly(false);

//            panelResult.getField('PRODT_WKORD_DATE').setReadOnly( false );
//            panelResult.getField('PRODT_START_DATE').setReadOnly( false );
//            panelResult.getField('PRODT_END_DATE').setReadOnly( false );
//            panelResult.getField('LOT_NO').setReadOnly( false );
//            panelResult.getField('WKORD_Q').setReadOnly( false );
//            panelResult.getField('ANSWER').setReadOnly( false );
//            panelResult.getField('PROJECT_NO').setReadOnly( false );
//            panelResult.getField('PROJECT_CODE').setReadOnly( false );

            Ext.getCmp('reworkRe').setReadOnly(false);
            Ext.getCmp('workEndYnRe').setReadOnly(true);

            panelResult.getField('WORK_END_YN').setValue('N');
            panelResult.getField('REWORK_YN').setValue('N')

            this.setDefault();

            detailGrid.down('#requestBtn').setDisabled(false);
            panelResult.uniOpt.inLoading = false;
        },
        onSaveDataButtonDown: function(config) {
            /*var progUnitQ = detailStore.data.items.PROG_UNIT_Q;

            Ext.each(progUnitQ, function(record,i){

                if(record.get('PROG_UNIT_Q',(progUnitQ)) > 1){
                    alret("tttt");
                }

            });*/


            detailStore.saveStore();
//          UniAppManager.app.onQueryButtonDown();
            if(panelResult.getField('WKORD_NUM') != ''){
                //panelSearch.getField('REWORK_YN').setReadOnly( false ); test
//              Ext.getCmp('workEndYn').setReadOnly(true);
                Ext.getCmp('workEndYnRe').setReadOnly(true);
            }
            else{
                //panelSearch.getField('REWORK_YN').setReadOnly( true ); test
//              Ext.getCmp('workEndYn').setReadOnly(false);
                Ext.getCmp('workEndYnRe').setReadOnly(false);
            }
        },
        onDeleteDataButtonDown: function() {
            var selRow = detailGrid.getSelectedRecord();
            if(selRow.phantom === true) {
                detailGrid.deleteSelectedRow();
            }else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
                    detailGrid.deleteSelectedRow();
            }
        },
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
        onDetailButtonDown: function() {
            var as = Ext.getCmp('s_pmp110ukrv_inAdvanceSerch');
            if(as.isHidden())   {
                as.show();
            } else {
                as.hide()
            }
        },
        onPrintButtonDown: function () {
            if(!panelResult.getInvalidMessage()) return;   //필수체크

            if(Ext.isEmpty(panelResult.getValue('WKORD_NUM'))){
                alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
                return;
            }

            var param = panelResult.getValues();

            param["USER_LANG"] = UserInfo.userLang;
            param["PGM_ID"]= PGM_ID;
            param["MAIN_CODE"] = 'P010';  //생산용 공통 코드
            param["sTxtValue2_fileTitle"]='작업지시서';
            var win = null;
            if(BsaCodeInfo.gsReportGubun == 'CLIP'){
	        	win = Ext.create('widget.ClipReport', {
	                url: CPATH+'/prodt/pmp110clrkrv.do',
	                prgID: 's_pmp110ukrv_in',
	                extParam: param
	            });
            }else{
	        	win = Ext.create('widget.CrystalReport', {
	            	url: CPATH + '/prodt/pmp110crkrv.do',
	                extParam: param
	            });
            }

            win.center();
            win.show();
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
        confirmSaveData: function(config)   {
            var fp = Ext.getCmp('s_pmp110ukrv_inFileUploadPanel');
            if(detailStore.isDirty() || fp.isDirty())   {
                if(confirm(Msg.sMB061)) {
                    this.onSaveDataButtonDown(config);
                } else {
                    this.rejectSave();
                }
            }
        },
        setDefault: function() {
            if(Ext.isEmpty(BsaCodeInfo.gsUseWorkColumnYn) || BsaCodeInfo.gsUseWorkColumnYn != 'Y') {
                detailGrid.getColumn('PRODT_PRSN').setHidden(true);
                detailGrid.getColumn('PRODT_MACH').setHidden(true);
                detailGrid.getColumn('PRODT_TIME').setHidden(true);
                detailGrid.getColumn('DAY_NIGHT').setHidden(true);
            }

            panelResult.setValue('DIV_CODE', UserInfo.divCode );
            panelResult.setValue('PRODT_WKORD_DATE',new Date());
            panelResult.setValue('PRODT_START_DATE',new Date());
            panelResult.setValue('PRODT_END_DATE',new Date());
            panelResult.setValue('WKORD_Q',0.00);
            panelResult.setValue('ORDER_Q',0.00);
            panelResult.setValue('PRODT_DATE', panelResult.getValue('PRODT_WKORD_DATE'));


//            panelSearch.getField('SPEC').setReadOnly(true);
//            panelResult.getField('SPEC').setReadOnly(true);
            panelResult.getField('PROG_UNIT').setReadOnly(true);
            panelResult.getField('WORK_END_YN').setReadOnly(true);
            panelResult.getField('GAMMA').setValue('NA');
            panelResult.getForm().wasDirty = false;
            panelResult.resetDirtyStatus();
            UniAppManager.setToolbarButtons('save', false);


            panelResult.getField('DIV_CODE').setReadOnly(true);
            panelResult.getField('WKORD_NUM').setReadOnly(true);
            panelResult.getField('EXCHG_TYPE').setReadOnly(true);

            prodtCommonService.checkReportInfo({"PGM_ID" : PGM_ID}, function(provider, response) {
                if(Ext.isEmpty(provider)){
                    UniAppManager.setToolbarButtons('print', false);
                }else{
                    UniAppManager.setToolbarButtons('print', true);
                }
            });

        },


        setReadOnly: function(flag) {

            panelResult.getField('DIV_CODE').setReadOnly(true);
            panelResult.getField('WKORD_NUM').setReadOnly(true);
            panelResult.getField('WORK_END_YN').setReadOnly(flag);
            panelResult.getField('EXCHG_TYPE').setReadOnly(flag);

            Ext.getCmp('reworkRe').setReadOnly(flag);
        },

        checkForNewDetail:function() {
            if(panelResult.setAllFieldsReadOnly(true)){
                return panelResult.setAllFieldsReadOnly(true);
            }
        }
    });

    function fnCalDate(expirationDay, productLdtime){//유효기간 계산
		var prodtEndDate ;
		var calExpirationDay ;
		if(productLdtime == 1 || productLdtime == 0 || Ext.isEmpty(productLdtime)){
			panelResult.setValue('PRODT_END_DATE', panelResult.getValue('PRODT_START_DATE'));

		}else{
			prodtEndDate = UniDate.add(panelResult.getValue('PRODT_START_DATE'), { days: productLdtime - 1 });
			panelResult.setValue('PRODT_END_DATE', prodtEndDate);

		}
		if(expirationDay == 0 || Ext.isEmpty(expirationDay)){
			//20200507 수정:  유통기한 계산 시, EXPIRATION_DAY가 없거나 0이면 bpr100t의 remark3 컬럼 값을 받아서 (+ 일수) -1일 계산하도록 수정 
//			calExpirationDay = UniDate.add(panelResult.getValue('PRODT_START_DATE'), {months: +3});
//			calExpirationDay = UniDate.add(calExpirationDay, { days: - 1 })
			var param = {
				ITEM_CODE: panelResult.getValue('ITEM_CODE')
			}
			s_pmp110ukrv_inService.fnGetRemark3(param, function(provider, response){
				if(provider != 0) {
					panelResult.setValue('EXPIRATION_DATE', UniDate.add(panelResult.getValue('PRODT_START_DATE'), { days: provider - 1 }));
				}/* else {
					panelResult.setValue('EXPIRATION_DATE','');
					Unilite.messageBox('유통기한을 입력하세요');
				}*/			//20200508 주석
			});
		}else{
			calExpirationDay = UniDate.add(panelResult.getValue('PRODT_START_DATE'), {months: + expirationDay});
			var prodtStMonthLastDay = new Date(panelResult.getValue('PRODT_START_DATE').getYear(), panelResult.getValue('PRODT_START_DATE').getMonth() + 1, 0).getDate();
			var calExpirationMonthLastDay = new Date(calExpirationDay.getYear(), calExpirationDay.getMonth() + 1, 0).getDate();

			/* if(calExpirationDay.getDate() == calExpirationMonthLastDay){
				calExpirationDay = calExpirationDay;
			}else{
				calExpirationDay = UniDate.add(calExpirationDay, { days: - 1 });
			} */
			if(panelResult.getValue('PRODT_START_DATE').getDate() > calExpirationMonthLastDay){
				calExpirationDay = calExpirationDay;
			}else{
				calExpirationDay = UniDate.add(calExpirationDay, { days: - 1 });
			}
			panelResult.setValue('EXPIRATION_DATE',calExpirationDay);
		}
	}

    function fnCreateLotno(startDate, itemCode){//lotno생성
    	var param ;
    	param= panelResult.getValues();
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
    			panelResult.setValue('LOT_NO', autoLotNo);

                var records = detailStore.data.items;
                Ext.each(records, function(record,i){
                    record.set('LOT_NO',autoLotNo);
                });

                return autoLotNo;
    		}
    	});
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
            switch(fieldName) {
                case "PROG_UNIT_Q" : // 원단위량
                    var wkordQ = panelResult.getValue("WKORD_Q");

                    if(newValue <= 0 ){
                        //0보다 큰수만 입력가능합니다.
                        rv='<t:message code="system.message.product.message023" default="입력한 값이 0보다 큰 수이어야 합니다."/>';
                        break;
                    }
                    if(newValue > 0){
                        record.set('WKORD_Q',(newValue * wkordQ));
                        break;
                        // 작업지시량 = 원단위량 * newValue
                    }break;

                case "WKORD_Q", "LINE_SEQ"  : // 작업지시량 , 공정순번

                    if(newValue <= 0 ){
                            //0보다 큰수만 입력가능합니다.
                            rv='<t:message code="system.message.product.message023" default="입력한 값이 0보다 큰 수이어야 합니다."/>';
                            break;
                    }break;
                case "PROG_UNIT" : //
                    // 정확한 코드를 입력하시오 sMB081
            }
            return rv;
        }
    }); // validator

};
</script>