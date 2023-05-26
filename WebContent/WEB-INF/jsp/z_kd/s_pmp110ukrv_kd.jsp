<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp110ukrv_kd"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmp110ukrv_kd" /> 			<!-- 사업장 -->
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
var searchInfoWindow;	//SearchInfoWindow : 검색창
var referProductionPlanWindow;  //생산계획참조

var BsaCodeInfo = {
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
    gsEquipCode  : '${gsEquipCode}'             // 작업지시 금형여부
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
			read: 's_pmp110ukrv_kdService.selectDetailList',
			update: 's_pmp110ukrv_kdService.updateDetail',
			create: 's_pmp110ukrv_kdService.insertDetail',
			destroy: 's_pmp110ukrv_kdService.deleteDetail',
			syncAll: 's_pmp110ukrv_kdService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pmp110ukrv_kdService.selectWorkNum'
		}
	});

	//20170517 - 사용 안 함(주석)
/*	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pmp110ukrv_kdService.selectProgInfo'
		}
	});*/

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
		items: [{
			title: '기본정보',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
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
		    	fieldLabel: '작업지시번호',
			 	xtype: 'uniTextfield',
			 	name: 'WKORD_NUM',
                holdable: 'hold',
                readOnly: isAutoOrderNum,
                holdable: isAutoOrderNum ? 'readOnly':'hold',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WKORD_NUM', newValue);
					}
        		}
			},{
				fieldLabel: '작업장',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
                holdable: 'hold',
				store: Ext.data.StoreManager.lookup('wsList'),
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
					allowBlank:false,
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelSearch.setValue('SPEC',records[0]["SPEC"]);
								panelResult.setValue('SPEC',records[0]["SPEC"]);
								panelSearch.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);
								panelResult.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);

								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
							panelResult.setValue('SPEC', '');
							panelResult.setValue('PROG_UNIT', '');

							panelSearch.setValue('SPEC', '');
							panelSearch.setValue('PROG_UNIT', '');


						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
		   }),{
				fieldLabel : ' ',
				name:'SPEC',
				xtype:'uniTextfield',
				readOnly:true,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SPEC', newValue);
					}
        		}
			},{
		 		fieldLabel: '작업지시일',
		 		xtype: 'uniDatefield',
		 		name: 'PRODT_WKORD_DATE',
                holdable: 'hold',
		 		allowBlank:false,
		 		value: new Date(),
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PRODT_WKORD_DATE', newValue);
//						if(newValue > panelSearch.getValue('PRODT_START_DATE')) {
//						      alert("작업지시일은 착수예정일보다 클수 없습니다.");
//                            panelResult.setValue('PRODT_WKORD_DATE', getValue('PRODT_START_DATE'));
//						}
					}
        		}
			},{
		 		fieldLabel: '착수예정일',
		 		xtype: 'uniDatefield',
		 		name: 'PRODT_START_DATE',
                holdable: 'hold',
		 		allowBlank:false,
		 		value: new Date(),
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PRODT_START_DATE', newValue);
//                        if(newValue > panelSearch.getValue('PRODT_END_DATE')) {
//                            alert("착수예정일은 완료예정일보다 클수 없습니다.");
//                            panelResult.setValue('PRODT_START_DATE', panelSearch.getValue('PRODT_END_DATE'));
//                        }
					}
        		}
			},{
		 		fieldLabel: '완료예정일',
		 		xtype: 'uniDatefield',
		 		name: 'PRODT_END_DATE',
                holdable: 'hold',
		 		allowBlank:false,
		 		value: new Date(),
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PRODT_END_DATE', newValue);
//                        if(newValue < panelSearch.getValue('PRODT_WKORD_DATE')) {
//                            alert("완료예정일은 작업지시일보다 작을수 없습니다.");
//                            panelResult.setValue('PRODT_END_DATE', panelSearch.getValue('PRODT_WKORD_DATE'));
//                        } else if( newValue < panelSearch.getValue('PRODT_START_DATE')) {
//                            alert("완료예정일은 착수예정일보다 작을수 없습니다.");
//                            panelResult.setValue('PRODT_END_DATE', panelSearch.getValue('PRODT_START_DATE'));
//                        }
					}
        		}
			},{
                fieldLabel: 'LOT_NO',
                xtype:'uniTextfield',
                name: 'LOT_NO',
//                readOnly: isAutoOrderNum,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('LOT_NO', newValue);
                        var store = detailGrid.getStore();
                        UniAppManager.app.suspendEvents();
                        Ext.each(store.data.items, function(record, index) {
                            record.set('LOT_NO', panelSearch.getValue('LOT_NO'));
                        });
                    }
                }
            }
				/*Unilite.popup('LOT_NO',{
			        	fieldLabel: 'LOT_NO',
			        	valueFieldName: 'LOT_NO',
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('LOT_NO', panelSearch.getValue('LOT_NO'));
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('LOT_NO', '');
							}
							,applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								popup.setExtParam({'ITEM_CODE': panelSearch.getValue('ITEM_CODE')});
								popup.setExtParam({'ITEM_NAME': panelSearch.getValue('ITEM_NAME')});
							}
						}
			})*/,{
		    	fieldLabel: '작업지시량',
			 	xtype: 'uniNumberfield',
			 	name: 'WKORD_Q',
			 	value: '0.00',
                holdable: 'hold',
			 	allowBlank:false,
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WKORD_Q', newValue);

						var cgWkordQ = panelSearch.getValue('WKORD_Q');

						//var test = detailGrid.get("PROG_UNIT_Q");

						if(Ext.isEmpty(cgWkordQ)) return false;
						var records = detailStore.data.items;

						Ext.each(records, function(record,i){
							record.set('WKORD_Q',(cgWkordQ * record.get("PROG_UNIT_Q")));
						});
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
			},
				Unilite.popup('PROJECT',{
			        	fieldLabel: '관리번호',
			        	valueFieldName: 'PROJECT_NO',
                        holdable: 'hold',
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('PROJECT_NO', panelSearch.getValue('PROJECT_NO'));
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('PROJECT_NO', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
			}),{
		    	fieldLabel: '특기사항',
			 	xtype:'textarea',
			 	name: 'ANSWER',
                holdable: 'hold',
			 	height: 50,
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ANSWER', newValue);

						var cgRemark = panelSearch.getValue('ANSWER');
						if(Ext.isEmpty(cgRemark)) return false;
							var records = detailStore.data.items;

						Ext.each(records, function(record,i){
							record.set('REMARK',cgRemark);
						});
					}
        		}
			},
				Unilite.popup('PJT',{
			        	fieldLabel: '프로젝트번호',
			        	valueFieldName: 'PROJECT_CODE',
                        holdable: 'hold',
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('PROJECT_CODE', panelSearch.getValue('PROJECT_CODE'));
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('PROJECT_CODE', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
			}),{
				xtype: 'radiogroup',
				fieldLabel: '강제마감',
				id:'workEndYn',
				items: [{
					boxLabel: '예',
					width: 70,
					name: 'WORK_END_YN',
					inputValue: 'Y',
					readOnly : false
				},{
					boxLabel : '아니오',
					width: 70,
					name: 'WORK_END_YN',
					inputValue: 'N',
					checked: true,
					readOnly : false
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);

						if(Ext.getCmp('workEndYn').getChecked()[0].inputValue =='Y'){
							if(confirm('작업지시를 마감하시겠습니까?')){
								alert("SP 또는 로직을 추가 해야합니다.")
							}
							else{
								panelResult.getField('WORK_END_YN').setValue('N')
							}
						}
					}
				}
			}]
		},{
			title: '참고사항',
   			itemId: 'search_panel2',
   			collapsed: false,
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		    	fieldLabel: '수주번호',
			 	xtype: 'uniTextfield',
			 	name: 'ORDER_NUM',
			 	readOnly : true
			},{
		    	fieldLabel: '수주량',
			 	xtype: 'uniNumberfield',
			 	name: 'ORDER_Q',
			 	readOnly : true,
			 	value: '0.00'
			},{
		    	fieldLabel: '납기일',
			 	xtype: 'uniDatefield',
			 	name: 'DVRY_DATE',
			 	readOnly : true
			},{
		    	fieldLabel: '거래처',
			 	xtype: 'uniTextfield',
			 	name: 'CUSTOM',
			 	readOnly : true
			},{
				xtype: 'radiogroup',
				fieldLabel: '재작업지시',
				id:'rework',
				items: [{
					boxLabel: '예',
					width: 70,
					name: 'REWORK_YN',
					inputValue: 'Y',
					readOnly: false
				},{
					boxLabel : '아니오',
					width: 70,
					name: 'REWORK_YN',
					inputValue: 'N',
					checked: true,
					readOnly: false
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

						panelResult.getField('REWORK_YN').setValue(newValue.REWORK_YN);

						if(Ext.getCmp('rework').getChecked()[0].inputValue =='Y'){
							panelSearch.getField('EXCHG_TYPE').setReadOnly( false );
							panelSearch.setValue('EXCHG_TYPE', "B");

							panelResult.getField('EXCHG_TYPE').setReadOnly( false );
							panelResult.setValue('EXCHG_TYPE', "B");

						}else if(Ext.getCmp('rework').getChecked()[0].inputValue =='N'){
							panelSearch.setValue('EXCHG_TYPE', "");
							panelSearch.getField('EXCHG_TYPE').setReadOnly( true );

							panelResult.setValue('EXCHG_TYPE', "");
							panelResult.getField('EXCHG_TYPE').setReadOnly( true );

						}
					}
				}
			},{
		        fieldLabel: '재고대체유형',
		        name:'EXCHG_TYPE',
		        xtype: 'uniCombobox',
		        comboType:'AU' ,
		        comboCode:'P120',
		        readOnly : true,
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EXCHG_TYPE', newValue);
					}
        		}
		    },{
		      xtype: 'uniTextfield',
		      name: 'WK_PLAN_NUM',
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

	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
                holdable: 'hold',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
        		}
	    	},{
	    	  xtype: 'component'
	    	},{
              xtype: 'component'
            },{
		    	fieldLabel: '작업지시번호',
			 	xtype: 'uniTextfield',
			 	name: 'WKORD_NUM',
                holdable: 'hold',
                readOnly: isAutoOrderNum,
                holdable: isAutoOrderNum ? 'readOnly':'hold',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WKORD_NUM', newValue);
					}
        		}
			},{
              xtype: 'component'
            },{
              xtype: 'component'
            },{
				fieldLabel: '작업장',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
                holdable: 'hold',
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WORK_SHOP_CODE', newValue);
					}
        		}
			},{
              xtype: 'component'
            },{
              xtype: 'component'
            },{
    			xtype: 'container',
    			layout: { type: 'uniTable', columns: 3},
    			defaultType: 'uniTextfield',
    			defaults : {enforceMaxLength: true},
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
									panelSearch.setValue('SPEC',records[0]["SPEC"]);
									panelResult.setValue('SPEC',records[0]["SPEC"]);
									panelSearch.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);
									panelResult.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);

									panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
									panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));

									if(panelResult.getField('ITEM_CODE').readOnly == true) return false;

									panelSearch.setValue('LOT_NO', '');
									panelResult.setValue('LOT_NO', '');
									if(records[0]["LOT_YN"] == "Y"){
									   panelSearch.getField('LOT_NO').setReadOnly(false);
									   panelResult.getField('LOT_NO').setReadOnly(false);
									}else{
									   panelSearch.getField('LOT_NO').setReadOnly(true);
									   panelResult.getField('LOT_NO').setReadOnly(true);
									}
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
								panelSearch.setValue('SPEC','');
								panelSearch.setValue('PROG_UNIT','');
								panelSearch.setValue('LOT_NO', '');

								panelResult.setValue('SPEC','');
								panelResult.setValue('PROG_UNIT','');
								panelResult.setValue('LOT_NO', '');

							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
			   }),{
					name:'SPEC',
					xtype:'uniTextfield',
                    holdable: 'hold',
					readOnly:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('SPEC', newValue);
						}
	        		}
				}]
	    	},{
              xtype: 'component'
            },{
              xtype: 'component'
            },{
		 		fieldLabel: '작업지시일',
		 		xtype: 'uniDatefield',
		 		name: 'PRODT_WKORD_DATE',
                holdable: 'hold',
		 		allowBlank:false,
		 		value: new Date(),
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('PRODT_WKORD_DATE', newValue);
//                        if(newValue > panelSearch.getValue('PRODT_START_DATE')) {
//                          alert("작업지시일은 착수예정일보다 클수 없습니다.");
//                          panelSearch.setValue('PRODT_WKORD_DATE', panelSearch.getValue('PRODT_START_DATE'));
//                        }
					}
        		}
			},{
                fieldLabel: 'LOT_NO',
                xtype:'uniTextfield',
                name: 'LOT_NO',
                holdable: 'hold',
//                readOnly: isAutoOrderNum,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('LOT_NO', newValue);
                        var store = detailGrid.getStore();
                        UniAppManager.app.suspendEvents();
                        Ext.each(store.data.items, function(record, index) {
                            record.set('LOT_NO', panelSearch.getValue('LOT_NO'));
                        });
                    }
                }
            },{
              xtype: 'component'
            },{
                fieldLabel: '착수예정일',
                xtype: 'uniDatefield',
                name: 'PRODT_START_DATE',
                holdable: 'hold',
                allowBlank:false,
                value: new Date(),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('PRODT_START_DATE', newValue);
//                        if(newValue > panelSearch.getValue('PRODT_END_DATE')) {
//                            alert("착수예정일은 완료예정일보다 클수 없습니다.");
//                            panelSearch.setValue('PRODT_START_DATE', panelSearch.getValue('PRODT_END_DATE'));
//                        }
                    }
                }
            },{
                fieldLabel: '완료예정일',
                xtype: 'uniDatefield',
                name: 'PRODT_END_DATE',
                holdable: 'hold',
                allowBlank:false,
                value: new Date(),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('PRODT_END_DATE', newValue);
//                        if(newValue < panelSearch.getValue('PRODT_WKORD_DATE')) {
//                            alert("완료예정일은 작업지시일보다 작을수 없습니다.");
//                            panelSearch.setValue('PRODT_END_DATE', panelSearch.getValue('PRODT_WKORD_DATE'));
//                        } else if( newValue < panelSearch.getValue('PRODT_START_DATE')) {
//                            alert("완료예정일은 착수예정일보다 작을수 없습니다.");
//                            panelSearch.setValue('PRODT_END_DATE', panelSearch.getValue('PRODT_START_DATE'));
//                        }
                    }
                }
            },
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
                fieldLabel: '강제마감',
                id:'workEndYnRe',
                items: [{
                    boxLabel: '예',
                    width: 70,
                    name: 'WORK_END_YN',
                    inputValue: 'Y',
                    readOnly : false
                },{
                    boxLabel : '아니오',
                    width: 70,
                    name: 'WORK_END_YN',
                    inputValue: 'N',
                    checked: true,
                    readOnly : false
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);

                    }
                }
           },{
    			xtype: 'container',
    			layout: { type: 'uniTable', columns: 3},
    			defaultType: 'uniTextfield',
    			defaults : {enforceMaxLength: true},
    			items:[{
			    	fieldLabel: '작업지시량',
				 	xtype: 'uniNumberfield',
				 	name: 'WKORD_Q',
				 	value: '0.00',
                    holdable: 'hold',
				 	allowBlank:false,
				 	listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('WKORD_Q', newValue);

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
					fieldStyle: 'text-align: center;',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('PROG_UNIT', newValue);
						}
	        		}
				}]
	    	},
            Unilite.popup('PROJECT',{
                    fieldLabel: '프로젝트번호',
                    valueFieldName: 'PJT_CODE',
                    holdable: 'hold',
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                panelSearch.setValue('PROJECT_CODE', panelResult.getValue('PROJECT_CODE'));
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('PROJECT_CODE', '');
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                        }
                    }
            }),{
                xtype: 'radiogroup',
                fieldLabel: '재작업지시',
                id:'reworkRe',
                items: [{
                    boxLabel: '예',
                    width: 70,
                    name: 'REWORK_YN',
                    inputValue: 'Y',
                    readOnly : false
                },{
                    boxLabel : '아니오',
                    width: 70,
                    name: 'REWORK_YN',
                    inputValue: 'N',
                    checked: true,
                    readOnly : false
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.getField('REWORK_YN').setValue(newValue.REWORK_YN);

                        if(Ext.getCmp('reworkRe').getChecked()[0].inputValue =='Y'){
                            panelSearch.getField('EXCHG_TYPE').setReadOnly( false );
                            panelSearch.setValue('EXCHG_TYPE', "B");

                            panelResult.getField('EXCHG_TYPE').setReadOnly( false );
                            panelResult.setValue('EXCHG_TYPE', "B");

                        }else if(Ext.getCmp('reworkRe').getChecked()[0].inputValue =='N'){
                            panelSearch.setValue('EXCHG_TYPE', "");
                            panelSearch.getField('EXCHG_TYPE').setReadOnly( true );

                            panelResult.setValue('EXCHG_TYPE', "");
                            panelResult.getField('EXCHG_TYPE').setReadOnly( true );
                        }
                    }
                }
            },{
                fieldLabel: '특기사항',
                xtype:'uniTextfield',
                name: 'ANSWER',
                holdable: 'hold',
                width: 500,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('ANSWER', newValue);

                        var cgRemark = panelResult.getValue('ANSWER');
                        if(Ext.isEmpty(cgRemark)) return false;
                            var records = detailStore.data.items;

                        Ext.each(records, function(record,i){
                            record.set('REMARK',cgRemark);
                        });
                    }
                }
            }/*,
            Unilite.popup('PROJECT',{
                    fieldLabel: '관리번호',
                    valueFieldName: 'PROJECT_NO',
                    holdable: 'hold',
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                panelSearch.setValue('PROJECT_NO', panelResult.getValue('PROJECT_NO'));
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('PROJECT_NO', '');
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                        }
                    }
            })*/,{
                fieldLabel: '재고대체유형',
                name:'EXCHG_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU' ,
                comboCode:'P120',
                holdable: 'hold',
                readOnly : true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('EXCHG_TYPE', newValue);
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
	Unilite.defineModel('s_pmp110ukrv_kdDetailModel', {
	    fields: [
	    	{name: 'LINE_SEQ' 		   		,text: '공정순서'			,type:'int', allowBlank: false},
			{name: 'PROG_WORK_CODE'   		,text: '공정코드'			,type:'string', allowBlank: false},
			{name: 'PROG_WORK_NAME'   		,text: '공정명'			    ,type:'string'},
            {name: 'EQUIP_CODE'             ,text: '설비코드'           ,type:'string', allowBlank: true},
            {name: 'EQUIP_NAME'             ,text: '설비명'             ,type:'string', allowBlank: true},
            {name: 'MOLD_CODE'              ,text: '금형코드'           ,type:'string', allowBlank: true},
            {name: 'MOLD_NAME'              ,text: '금형명'             ,type:'string', allowBlank: true},
			{name: 'PROG_UNIT_Q'    		,text: '원단위량'			,type:'uniQty', allowBlank: false},
			{name: 'WKORD_Q'  		   		,text: '작업지시량'			,type:'uniQty', allowBlank: false},
			{name: 'PROG_UNIT' 				,text: '단위'				,type:'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value', allowBlank: false},
			{name: 'DIV_CODE'  				,text: '사업장'			    ,type:'string'},
			{name: 'WKORD_NUM'  			,text: '작지번호'			,type:'string'},
			{name: 'WORK_SHOP_CODE'   		,text: '작업장'			    ,type:'string' , comboType: 'WU'},
			{name: 'PRODT_START_DATE' 		,text: '차수예정일'			,type:'uniDate'},
			{name: 'PRODT_END_DATE' 		,text: '완료예정일'			,type:'uniDate'},
			{name: 'PRODT_WKORD_DATE' 	 	,text: '작업시작일'			,type:'uniDate'},
			{name: 'ITEM_CODE'   	   		,text: '품목'				,type:'string'},
			{name: 'REMARK'   		   		,text: '비고'				,type:'string'},
			{name: 'WK_PLAN_NUM'    		,text: '계획번호'			,type:'string'},
			{name: 'LINE_END_YN'  	   		,text: '최종여부'			,type:'string'},
			{name: 'ITEM_NAME' 				,text: '품명'				,type:'string'},
			{name: 'SPEC'  				 	,text: '규격'				,type:'string'},
			{name: 'WORK_END_YN'  	   		,text: '마감여부'			,type:'string'},
			{name: 'REWORK_YN'  			,text: '재작업지시여부'		,type:'string'},
			{name: 'STOCK_EXCHG_TYPE'  		,text: '재고대체유형'		,type:'string'},
			//Hidden : true
			{name: 'PROJECT_NO'  	   		,text: '프로젝트번호'		,type:'string'},
			{name: 'PJT_CODE' 				,text: '프로젝트번호'		,type:'string'},
			{name: 'LOT_NO'  				,text: 'LOT_NO'			    ,type:'string'},
			{name: 'UPDATE_DB_USER'  		,text: '수정자'			    ,type:'string'},
			{name: 'UPDATE_DB_TIME'  		,text: '수정일'			    ,type:'uniDate'},
			{name: 'COMP_CODE'  			,text: '회사코드'			,type:'string'}
		]
	});


	/**
	 * Master Store 정의(Service 정의)
	 * @type
	 */
	var detailStore = Unilite.createStore('s_pmp110ukrv_kdDetailStore', {
		model: 's_pmp110ukrv_kdDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			allDeletable: true,      // 전체 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
//           	load: function(store, records, successful, eOpts) {
//           		if(records[0] != null){
//           			var PanelWkordQ = panelSearch.getValue('WKORD_Q');
//      				Ext.each(records, function(record, index) {
//						record.set('WKORD_Q', PanelWkordQ);
//					})
//           		}
//           	}
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var wkordNum = panelSearch.getValue('WKORD_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['WKORD_NUM'] != wkordNum) {
					record.set('WKORD_NUM', wkordNum);
				}
			})
//			var lotNo = panelSearch.getValue('LOT_NO');
//            Ext.each(list, function(record, index) {
//                if(record.data['LOT_NO'] != lotNo) {
//                    record.set('LOT_NO', lotNo);
//                }
//            })
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
								var master = batch.operations[0].getResultSet();
                                panelSearch.setValue("WKORD_NUM", master.WKORD_NUM);
                                panelResult.setValue("WKORD_NUM", master.WKORD_NUM);
                                panelSearch.setValue("LOT_NO", master.LOT_NO);
                                panelResult.setValue("LOT_NO", master.LOT_NO);

								panelSearch.getForm().wasDirty = false;
								panelSearch.resetDirtyStatus();
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
                var grid = Ext.getCmp('s_pmp110ukrv_kdGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				// alert(Msg.sMB083);
			}
		}
	});

    /**
     * Master Grid 정의(Grid Panel)
     * @type
     */

    var detailGrid = Unilite.createGrid('s_pmp110ukrv_kdGrid', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: true,
			useRowNumberer: false
        },
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'refTool',
			text: '참조...',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'requestBtn', ////
					text: '생산계획참조',
					handler: function() {
						openProductionPlanWindow();
						}
				}]
			})
		}, {
			xtype: 'splitbutton',
           	itemId:'procTool',
			text: '프로세스...',  iconCls: 'icon-link',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'reqIssueLinkBtn',
					text: '예약량조정',
					handler: function() {
						if(!UniAppManager.app.checkForNewDetail()) return false;
						/* 기본 필수값을 입력하지 않을 경우 팅겨냄*/
						else{
							if(Ext.isEmpty(panelSearch.getValue('WKORD_NUM'))){
								alert('작업지시번호를 선택해야합니다.');
								return false;
							}
							else{
								var params = {
									'DIV_CODE' 			: panelSearch.getValue('DIV_CODE'),
									'WORK_SHOP_CODE' 	: panelSearch.getValue('WORK_SHOP_CODE'),
									'PRODT_WKORD_DATE'  : panelSearch.getValue('PRODT_WKORD_DATE'),
									'WKORD_NUM' 		: panelSearch.getValue('WKORD_NUM')
								}
								var rec = {data : {prgID : 'pmp160ukrv', 'text':'예약량조정'}};
								parent.openTab(rec, '/prodt/pmp160ukrv.do', params);
							}
						}
					}
				}]
			})
        }],
    	store: detailStore,
        columns: [
			{dataIndex:'LINE_SEQ' 		  	, width: 120},
			{dataIndex:'PROG_WORK_CODE'		, width: 120 ,locked: false,
        		editor: Unilite.popup('PROG_WORK_CODE_G', {
	  					textFieldName: 'PROG_WORK_NAME',
	 	 				DBtextFieldName: 'PROG_WORK_NAME',
			    		autoPopup: true,
	 	 				//extParam: {SELMODEL: 'MULTI'},
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
										popup.setExtParam({'DIV_CODE'		: panelSearch.getValue('DIV_CODE')});
										popup.setExtParam({'WORK_SHOP_CODE' : panelSearch.getValue('WORK_SHOP_CODE')});
//                                        popup.setExtParam({'ITEM_CODE' : panelSearch.getValue('ITEM_CODE')});
								    }
		 			}
				})
			},

			{dataIndex: 'PROG_WORK_NAME'   	, width: 206,
				editor: Unilite.popup('PROG_WORK_CODE_G', {
		  					textFieldName: 'PROG_WORK_NAME',
		 	 				DBtextFieldName: 'PROG_WORK_NAME',
			    			autoPopup: true,
		 	 				//extParam: {SELMODEL: 'MULTI'},
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
											popup.setExtParam({'DIV_CODE'		: panelSearch.getValue('DIV_CODE')});
											popup.setExtParam({'WORK_SHOP_CODE' : panelSearch.getValue('WORK_SHOP_CODE')
										});
									}
			 			}
				})
			},
            {dataIndex: 'LOT_NO'            , width: 100, hidden: true},
			{dataIndex: 'PROG_UNIT_Q'    	, width: 146},
			{dataIndex: 'WKORD_Q'  		  	, width: 206},
			{dataIndex: 'PROG_UNIT' 		, width: 50, align: 'center'},
            {dataIndex: 'EQUIP_CODE'                  ,       width: 110, hidden: isEquipCode, autoPopup: true
                ,'editor' : Unilite.popup('EQUIP_CODE_G',{textFieldName:'EQUIP_CODE', textFieldWidth:100, DBtextFieldName: 'EQUIP_CODE',
			    			autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        grdRecord = detailGrid.getSelectedRecord();
                                        Ext.each(records, function(record,i) {
                                            grdRecord.set('EQUIP_CODE', record.EQUIP_CODE);
                                            grdRecord.set('EQUIP_NAME', record.EQUIP_NAME);
                                        });
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = detailGrid.getSelectedRecord();
                                    grdRecord.set('EQUIP_CODE', '');
                                    grdRecord.set('EQUIP_NAME', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelSearch.getValues();
                                    record = detailGrid.getSelectedRecord();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                    if(Ext.isEmpty(record.get('PROG_WORK_CODE'))) {
                                        popup.setExtParam({'ITEM_CODE': param.ITEM_CODE});
                                        popup.setExtParam({'PROG_WORK_CODE': record.get('PROG_WORK_CODE')});
                                    }
                                }
                            }
                })
            },
            {dataIndex: 'EQUIP_NAME'                  ,       width: 200, hidden: isEquipCode, autoPopup: true
                ,'editor' : Unilite.popup('EQUIP_CODE_G',{textFieldName:'EQUIP_NAME', textFieldWidth:100, DBtextFieldName: 'EQUIP_NAME',
			    			autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        grdRecord = detailGrid.getSelectedRecord();
                                        Ext.each(records, function(record,i) {
                                            grdRecord.set('EQUIP_CODE', record.EQUIP_CODE);
                                            grdRecord.set('EQUIP_NAME', record.EQUIP_NAME);
                                        });
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = detailGrid.getSelectedRecord();
                                    grdRecord.set('EQUIP_CODE', '');
                                    grdRecord.set('EQUIP_NAME', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelSearch.getValues();
                                    record = detailGrid.getSelectedRecord();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                    if(Ext.isEmpty(record.get('PROG_WORK_CODE'))) {
                                        popup.setExtParam({'ITEM_CODE': param.ITEM_CODE});
                                        popup.setExtParam({'PROG_WORK_CODE': record.get('PROG_WORK_CODE')});
                                    }
                                }
                            }
                })
            },
            {dataIndex: 'MOLD_CODE'                  ,       width: 110, hidden: isMoldCode, autoPopup: true
                ,'editor' : Unilite.popup('MOLD_CODE_G',{textFieldName:'MOLD_CODE', textFieldWidth:100, DBtextFieldName: 'MOLD_CODE',
			    			autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        grdRecord = detailGrid.getSelectedRecord();
                                        Ext.each(records, function(record,i) {
                                            grdRecord.set('MOLD_CODE', record.MOLD_CODE);
                                            grdRecord.set('MOLD_NAME', record.MOLD_NAME);
                                        });
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = detailGrid.getSelectedRecord();
                                    grdRecord.set('MOLD_CODE', '');
                                    grdRecord.set('MOLD_NAME', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelSearch.getValues();
                                    record = detailGrid.getSelectedRecord();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                    if(Ext.isEmpty(record.get('PROG_WORK_CODE'))) {
                                        popup.setExtParam({'ITEM_CODE': param.ITEM_CODE});
                                        popup.setExtParam({'PROG_WORK_CODE': record.get('PROG_WORK_CODE')});
                                    }
                                }
                            }
                })
            },
            {dataIndex: 'MOLD_NAME'                  ,       width: 200, hidden: isMoldCode, autoPopup: true
                ,'editor' : Unilite.popup('MOLD_CODE_G',{textFieldName:'MOLD_NAME', textFieldWidth:100, DBtextFieldName: 'MOLD_NAME',
			    			autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        grdRecord = detailGrid.getSelectedRecord();
                                        Ext.each(records, function(record,i) {
                                            grdRecord.set('MOLD_CODE', record.MOLD_CODE);
                                            grdRecord.set('MOLD_NAME', record.MOLD_NAME);
                                        });
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = detailGrid.getSelectedRecord();
                                    grdRecord.set('MOLD_CODE', '');
                                    grdRecord.set('MOLD_NAME', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelSearch.getValues();
                                    record = detailGrid.getSelectedRecord();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                    if(Ext.isEmpty(record.get('PROG_WORK_CODE'))) {
                                        popup.setExtParam({'ITEM_CODE': param.ITEM_CODE});
                                        popup.setExtParam({'PROG_WORK_CODE': record.get('PROG_WORK_CODE')});
                                    }
                                }
                            }
                })
            },
			{dataIndex: 'DIV_CODE'  		, width: 100 , hidden: true},
			{dataIndex: 'WKORD_NUM'  		, width: 100 , hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'  	, width: 100 , hidden: true},
			{dataIndex: 'PRODT_START_DATE'	, width: 100 , hidden: true},
			{dataIndex: 'PRODT_END_DATE' 	, width: 100 , hidden: true},
			{dataIndex: 'PRODT_WKORD_DATE'	, width: 100 , hidden: true},
			{dataIndex: 'ITEM_CODE'   	  	, width: 100 , hidden: true},
			{dataIndex: 'ITEM_NAME' 		, width: 100 , hidden: true},
			{dataIndex: 'REMARK'   		   	, width: 100 , hidden: true},
			{dataIndex: 'WK_PLAN_NUM'    	, width: 100 , hidden: true},
			{dataIndex: 'LINE_END_YN'  	  	, width: 100 , hidden: true},
			{dataIndex: 'SPEC'  			, width: 100 , hidden: true},
			{dataIndex: 'WORK_END_YN'  	  	, width: 100 , hidden: true},
			{dataIndex: 'REWORK_YN'  		, width: 100 , hidden: true},
			{dataIndex: 'STOCK_EXCHG_TYPE'	, width: 100 , hidden: true},
			// ColDate
			{dataIndex: 'PROJECT_NO'    	, width: 100 , hidden: true},
			{dataIndex: 'PJT_CODE'  	  	, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'  	, width: 100 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'  	, width: 100 , hidden: true},
			{dataIndex: 'COMP_CODE'  	  	, width: 100 , hidden: true}
		],
    	listeners: {
    		/*afterrender: function(grid) {
					//useContextMenu:true 설정으로 툴바 우측 버튼은 자동 생성되며 그 외 추가할 메뉴  작성
					this.contextMenu.add(
						{
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
									CUSTOM_CODE : panelSearch.getValue('CUSTOM_CODE'),
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

					var orderNum = panelSearch.getValue('WKORD_NUM')

				 var seq = detailStore.max('SER_NO');
            	 if(!seq) seq = 1;
            	 else  seq += 1;

            	 var divCode  	    = panelSearch.getValue('DIV_CODE');
            	 var workShopCode   = panelSearch.getValue('WORK_SHOP_CODE');
            	 var wkordNum       = panelSearch.getValue('WKORD_NUM');
            	 var itemCode       = panelSearch.getValue('ITEM_CODE');
            	 var progUnitQ      = '1';
            	 var wkordQ         = panelSearch.getValue('WKORD_Q');
            	 var prodtStartDate = panelSearch.getValue('PRODT_START_DATE');
            	 var prodtEndDate   = panelSearch.getValue('PRODT_END_DATE');
            	 var prodtWkordDate = panelSearch.getValue('PRODT_WKORD_DATE');
            	 var wkPlanNum      = panelSearch.getValue('WK_PLAN_NUM');
            	 var projectNo      = panelSearch.getValue('PROJECT_NO');
            	 var pjtCode        = panelSearch.getValue('PJT_CODE');
            	 var lotNo          = panelSearch.getValue('LOT_NO');

            	 var r = {
					ORDER_NUM         : orderNum,
					SER_NO            : seq,

					DIV_CODE          : divCode,
					WORK_SHOP_CODE    : workShopCode,
					WKORD_NUM 	      : wkordNum,
					ITEM_CODE 	      : itemCode,
					PROG_UNIT_Q 	  : progUnitQ,
					WKORD_Q 		  : wkordQ,
					PRODT_START_DATE  : prodtStartDate,
					PRODT_END_DATE    : prodtEndDate,
					PRODT_WKORD_DATE  : prodtWkordDate,
					WK_PLAN_NUM	      : wkPlanNum,
					PROJECT_NO	      : projectNo,
					PJT_CODE		  : pjtCode,
					LOT_NO		      : lotNo
					//COMP_CODE		  : compCode
		        };
//				detailGrid.createRow(r, 'ITEM_CODE', -1);
//				panelSearch.setAllFieldsReadOnly(false);
	          		return true;
	          	},
	          	//contextMenu의 복사한 행 삽입 실행 후
	          	afterPasteRecord: function(rowIndex, record) {
	          		panelSearch.setAllFieldsReadOnly(false);
	          	},*/
    		beforeedit  : function( editor, e, eOpts ) {
      		  	if(e.record.phantom || !e.record.phantom)	{
					if (UniUtils.indexOf(e.field,
											['WKORD_Q','PROG_UNIT','DIV_CODE', 'WKORD_NUM','WORK_SHOP_CODE','PRODT_START_DATE','PRODT_END_DATE'
											,'PRODT_WKORD_DATE','ITEM_CODE','ITEM_NAME','REMARK','WK_PLAN_NUM','LINE_END_YN','SPEC','WORK_END_YN'
											,'REWORK_YN','STOCK_EXCHG_TYPE','PROJECT_NO','PJT_CODE'/*,'LOT_NO'*/,'UPDATE_DB_USER','UPDATE_DB_TIME','COMP_CODE']))
							return false;
				}
				if(!e.record.phantom){
					if (UniUtils.indexOf(e.field,
											['PROG_WORK_CODE','PROG_WORK_NAME','DIV_CODE', 'WKORD_NUM','WORK_SHOP_CODE','PRODT_START_DATE','PRODT_END_DATE'
											,'PRODT_WKORD_DATE','ITEM_CODE','ITEM_NAME','REMARK','WK_PLAN_NUM','LINE_END_YN','SPEC','WORK_END_YN'
											,'REWORK_YN','STOCK_EXCHG_TYPE','PROJECT_NO','PJT_CODE'/*,'LOT_NO'*/,'UPDATE_DB_USER','UPDATE_DB_TIME','COMP_CODE']))
							return false;
				}
				else{ return true }
			}
       	},
		disabledLinkButtons: function(b) {
       		this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
		},
		setItemData: function(record, dataClear, grdRecord) {
       		//var grdRecord = detailGrid.uniOpt.currentRecord;
       		if(dataClear) {
				grdRecord.set('PROG_WORK_CODE'  	    , '');
				grdRecord.set('PROG_WORK_NAME'  	    , '');
				grdRecord.set('PROG_UNIT'  	    		,  panelSearch.getValue('PROG_UNIT'));
       		}else{
				grdRecord.set('PROG_WORK_CODE'  	    , record['PROG_WORK_CODE']);
				grdRecord.set('PROG_WORK_NAME'  	    , record['PROG_WORK_NAME']);
	       		if(grdRecord.get['PROG_UNIT'] != ''){
	       			grdRecord.set('PROG_UNIT'    		, record['PROG_UNIT']);
	       		}
	       		else{
	       			grdRecord.set('PROG_UNIT'    		, panelSearch.getValue('PROG_UNIT'));
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
            grdRecord.set('WKORD_Q'           ,  record['PROG_UNIT_Q'] * panelSearch.getValue('WKORD_Q'));
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
            grdRecord.set('WKORD_Q'           ,  record['PROG_UNIT_Q'] * panelSearch.getValue('WKORD_Q'));
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
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		hidden:true
			},{
				fieldLabel: '작업장',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
		 		allowBlank:false
			}, {
				fieldLabel: '착수예정일',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_PRODT_DATE',
				endFieldName: 'TO_PRODT_DATE',
				width: 350,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},
				Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '품목코드',
			        	valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);

		                    	},
								scope: this
							},
							onClear: function(type)	{

							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
					}
			}),{
				fieldLabel: 'LOT번호',
				xtype: 'uniTextfield',
				name:'LOT_NO',
				width:315
			}]
    }); // createSearchForm

    // 조회창 모델 정의
    Unilite.defineModel('productionNoMasterModel', {
	    fields: [{name: 'WKORD_NUM'						, text: '작업지시번호'    	, type: 'string'},
				 {name: 'ITEM_CODE'						, text: '품목'    			, type: 'string'},
				 {name: 'ITEM_NAME'						, text: '품명'    			, type: 'string'},
				 {name: 'SPEC'							, text: '규격'    			, type: 'string'},
				 {name: 'PRODT_WKORD_DATE'				, text: '작업지시일'    	, type: 'uniDate'},
				 {name: 'PRODT_START_DATE'				, text: '착수예정일'    	, type: 'uniDate'},
				 {name: 'PRODT_END_DATE'				, text: '완료예정일'    	, type: 'uniDate'},
				 {name: 'WKORD_Q'						, text: '지시수량'    		, type: 'uniQty'},
				 {name: 'WK_PLAN_NUM'					, text: '계획번호'    		, type: 'string'},
				 {name: 'DIV_CODE'						, text: '사업장'    		, type: 'string'},
				 {name: 'WORK_SHOP_CODE'				, text: '작업장'    		, type: 'string' , comboType: 'WU'},
				 {name: 'ORDER_NUM'						, text: '수주번호'    		, type: 'string'},
				 {name: 'ORDER_Q'						, text: '수주량'    		, type: 'uniQty'},
				 {name: 'REMARK'						, text: '비고'    			, type: 'string'},
				 {name: 'PRODT_Q'						, text: '생산량'    		, type: 'uniQty'},
				 {name: 'DVRY_DATE'						, text: '납기일'    		, type: 'uniDate'},
				 {name: 'STOCK_UNIT'					, text: '단위'    			, type: 'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value'},
				 {name: 'PROJECT_NO'					, text: '프로젝트번호'    	, type: 'string'},
				 {name: 'PJT_CODE'						, text: '프로젝트번호'    	, type: 'string'},
				 {name: 'LOT_NO'						, text: 'LOT_NO'    		, type: 'string'},

				 {name: 'WORK_END_YN'					, text: '강제마감여부'    	, type: 'string'},

				 {name: 'CUSTOM'						, text: '거래처'    		, type: 'string'},
				 {name: 'REWORK_YN'						, text: '재작업지시'    	, type: 'string'},
				 {name: 'STOCK_EXCHG_TYPE'				, text: '재고대체유형'    	, type: 'string'}

		]
	});
    //조회창 스토어 정의
	var productionNoMasterStore = Unilite.createStore('productionNoMasterStore', {
			model: 'productionNoMasterModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            proxy: directProxy2
            ,loadStoreRecords : function()	{
				var param= productionNoSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});

	var productionNoMasterGrid = Unilite.createGrid('s_pmp110ukrv_kdproductionNoMasterGrid', {
        // title: '기본',
        layout : 'fit',
		store: productionNoMasterStore,
		uniOpt:{
					useRowNumberer: false
		},
        columns:  [{ dataIndex: 'WKORD_NUM'							,	 width: 120 },
          		   { dataIndex: 'ITEM_CODE'							,	 width: 100 },
          		   { dataIndex: 'ITEM_NAME'							,	 width: 166 },
          		   { dataIndex: 'SPEC'								,	 width: 100 },
          		   { dataIndex: 'PRODT_WKORD_DATE'					,	 width: 73  ,hidden: true},
          		   { dataIndex: 'PRODT_START_DATE'					,	 width: 73 },
          		   { dataIndex: 'PRODT_END_DATE'					,	 width: 73 },
          		   { dataIndex: 'WKORD_Q'							,	 width: 53 },
          		   { dataIndex: 'WK_PLAN_NUM'						,	 width: 100 ,hidden: true},
          		   { dataIndex: 'DIV_CODE'							,	 width: 0   ,hidden: true},
          		   { dataIndex: 'WORK_SHOP_CODE'					,	 width: 0   ,hidden: true},
          		   { dataIndex: 'ORDER_NUM'							,	 width: 0   ,hidden: true},
          		   { dataIndex: 'ORDER_Q'							,	 width: 0   ,hidden: true},
          		   { dataIndex: 'REMARK'							,	 width: 100 },
          		   { dataIndex: 'PRODT_Q'							,	 width: 0   ,hidden: true},
          		   { dataIndex: 'DVRY_DATE'							,	 width: 0   ,hidden: true},
          		   { dataIndex: 'STOCK_UNIT'						,	 width: 33  ,hidden: true},
          		   { dataIndex: 'PROJECT_NO'						,	 width: 100 },
          		   { dataIndex: 'PJT_CODE'							,	 width: 100 },
          		   { dataIndex: 'LOT_NO'							,	 width: 133 },
				   { dataIndex: 'WORK_END_YN'						,	 width: 100 ,hidden: true},
          		   { dataIndex: 'CUSTOM'							,	 width: 100 ,hidden: true},
          		   { dataIndex: 'REWORK_YN'							,	 width: 100 ,hidden: true},
          		   { dataIndex: 'STOCK_EXCHG_TYPE'					,	 width: 100 ,hidden: true}
          ] ,
          listeners: {
	          onGridDblClick: function(grid, record, cellIndex, colName) {
		          	this.returnData(record);
		          	UniAppManager.app.onQueryButtonDown();
		          	searchInfoWindow.hide();
	          }
          },
          	returnData: function(record)	{
	          	if(Ext.isEmpty(record))	{
	          		record = this.getSelectedRecord();
	          	}
	          	panelSearch.setValues({'DIV_CODE':record.get('DIV_CODE'),   /*사업장*/		  'WKORD_NUM':record.get('WKORD_NUM'),  			 /*작업지시번호*/
	          						  'WORK_SHOP_CODE':record.get('WORK_SHOP_CODE'), /* 작업장*/'ITEM_CODE':record.get('ITEM_CODE'),				 /*품목코드*/
	          						  'ITEM_NAME':record.get('ITEM_NAME'),	/*품목명*/		  'SPEC':record.get('SPEC'), 						 /*규격*/
	          						  'PRODT_WKORD_DATE':record.get('PRODT_WKORD_DATE'),	  'PRODT_START_DATE':record.get('PRODT_START_DATE'),
	          						  'PRODT_END_DATE':record.get('PRODT_END_DATE'),		  'LOT_NO':record.get('LOT_NO'),
	          						  'WKORD_Q':record.get('WKORD_Q'),						  'PROG_UNIT':record.get('STOCK_UNIT'),
	          						  'PROJECT_NO':record.get('PROJECT_NO'),				  'ANSWER':record.get('REMARK'),
	          						  'PJT_CODE':record.get('PJT_CODE'),					  'WORK_END_YN':record.get('WORK_END_YN'),
	          						  'ORDER_NUM':record.get('ORDER_NUM'), 	/* 수주번호*/		  'ORDER_Q':record.get('ORDER_Q'),  				/* 수주량*/
	          						  'DVRY_DATE':record.get('DVRY_DATE'),  /* 납기일*/		  'CUSTOM':record.get('CUSTOM'),
	          						  /*'REWORK_YN':record.get('REWORK_YN'),*/				  'PROG_UNIT':record.get('STOCK_UNIT'),
	          						  'EXCHG_TYPE':record.get('STOCK_EXCHG_TYPE')
	          						  });
	          	panelSearch.getField('REWORK_YN').setValue(record.get('REWORK_YN'));
	          	panelResult.getField('REWORK_YN').setValue(record.get('REWORK_YN'));


				panelResult.setValues({'ITEM_CODE':record.get('ITEM_CODE'),	/*품목*/		 'ITEM_NAME':record.get('ITEM_NAME'),
									   'SPEC':record.get('SPEC'),
									   'PROJECT_NO':record.get('PROJECT_NO'),			 'LOT_NO':record.get('LOT_NO'),
									   'PJT_CODE':record.get('PJT_CODE'),				 'WORK_END_YN':record.get('WORK_END_YN')
	          						   });


	          	panelSearch.getField('DIV_CODE').setReadOnly( true );
				panelSearch.getField('WKORD_NUM').setReadOnly( true );
				panelSearch.getField('WORK_SHOP_CODE').setReadOnly( true );
				panelSearch.getField('ITEM_CODE').setReadOnly( true );
				panelSearch.getField('ITEM_NAME').setReadOnly( true );
//				panelSearch.getField('SPEC').setReadOnly( true );
				panelSearch.getField('EXCHG_TYPE').setReadOnly( true );
				panelSearch.getField('PROG_UNIT').setReadOnly( true );
				panelSearch.getField('WORK_END_YN').setReadOnly( false );

				Ext.getCmp('rework').setReadOnly(true);
				Ext.getCmp('workEndYn').setReadOnly(false);

				panelResult.getField('DIV_CODE').setReadOnly( true );
				panelResult.getField('WKORD_NUM').setReadOnly( true );
				panelResult.getField('WORK_SHOP_CODE').setReadOnly( true );
				panelResult.getField('ITEM_CODE').setReadOnly( true );
				panelResult.getField('ITEM_NAME').setReadOnly( true );
				panelResult.getField('REWORK_YN').setReadOnly( true );
//				panelResult.getField('SPEC').setReadOnly( true );
				panelResult.getField('PROG_UNIT').setReadOnly( true );

				Ext.getCmp('reworkRe').setReadOnly(true);
				Ext.getCmp('workEndYnRe').setReadOnly(false);

				detailGrid.down('#refTool').menu.down('#requestBtn').setDisabled(true); // 데이터 Set 될때 생산계획 참조 Disabled
          }
    });

    //조회창 메인
	function opensearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '작업지시정보',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [productionNoSearch, productionNoMasterGrid],
                tbar:  ['->',
				        {	itemId : 'searchBtn',
							text: '조회',
							handler: function() {
								if(!productionNoSearch.getInvalidMessage()) {
									return false;
								}
								productionNoMasterStore.loadStoreRecords();
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
				listeners : {beforehide: function(me, eOpt)	{
											productionNoSearch.clearForm();
											productionNoMasterGrid.reset();
                						},
                			 beforeclose: function( panel, eOpts )	{
											productionNoSearch.clearForm();
											productionNoMasterGrid.reset();
                			 			},
                			 show: function( panel, eOpts )	{
                			 	productionNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
                			 	productionNoSearch.setValue('WORK_SHOP_CODE',panelSearch.getValue('WORK_SHOP_CODE'));
                			 	productionNoSearch.setValue('ITEM_CODE',panelSearch.getValue('ITEM_CODE'));
                			 	productionNoSearch.setValue('ITEM_NAME',panelSearch.getValue('ITEM_NAME'));

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
		        	fieldLabel: '사업장',
		        	name: 'DIV_CODE',
		        	xtype: 'uniCombobox',
		        	comboType: 'BOR120',
		        	hidden:true
		        },{
		        	fieldLabel: '작업장',
		        	name: 'WORK_SHOP_CODE',
		        	xtype: 'uniCombobox',
		        	comboType: 'WU'
		        },{
		        	fieldLabel: '계획일자',
		            xtype: 'uniDateRangefield',
		            startFieldName: 'OUTSTOCK_REQ_DATE_FR',
					endFieldName: 'OUTSTOCK_REQ_DATE_TO',
		            width: 315,
		            startDate: UniDate.get('today'),			/* DB today */
		            endDate: UniDate.get('todayForMonth'),		/* DB today + 1달  */
		        	allowBlank:false
				},
					Unilite.popup('DIV_PUMOK',{
		        	fieldLabel: '품목코드',
		        	valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
		        	listeners: {
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
		   })]
	});

	//생산계획 참조 입력set 데이터용
    var productionPlanInputForm = Unilite.createSearchForm('productionPlanInputFormForm', {
        layout :  {type : 'uniTable', columns : 2},
        items: [{
            fieldLabel: '작업지시일',
            xtype: 'uniDatefield',
            name: 'PRODT_WKORD_DATE',
            holdable: 'hold',
            allowBlank:false,
            value: new Date()
        },{
            fieldLabel: 'LOT_NO',
            xtype:'uniTextfield',
            labelWidth: 271,
            name: 'LOT_NO'
        },{
            fieldLabel: '착수예정일',
            xtype: 'uniDatefield',
            name: 'PRODT_START_DATE',
            holdable: 'hold',
            allowBlank:false,
            value: new Date()
        },{
            fieldLabel: '완료예정일',
            xtype: 'uniDatefield',
            name: 'PRODT_END_DATE',
            holdable: 'hold',
            labelWidth: 271,
            allowBlank:false,
            value: new Date()
        },{
            xtype: 'container',
            layout: { type: 'uniTable', columns: 3},
            defaultType: 'uniTextfield',
            defaults : {enforceMaxLength: true},
            items:[{
                fieldLabel: '작업지시량',
                xtype: 'uniNumberfield',
                name: 'WKORD_Q',
                value: '0.00',
                holdable: 'hold',
                allowBlank:false
            },{
                name:'PROG_UNIT',
                xtype:'uniTextfield',
                holdable: 'hold',
                width: 50,
                readOnly:true,
                fieldStyle: 'text-align: center;'
            }]
        }]
    });

	Unilite.defineModel('s_pmp110ukrv_kdProductionPlanModel', {
    	fields: [
	    	{name: 'GUBUN'        			, text: '선택'			    , type: 'string'},
	    	{name: 'DIV_CODE'				, text: '제조처'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'			, text: '작업장'			, type: 'string' , comboType: 'WU'},
			{name: 'WK_PLAN_NUM'			, text: '생산계획번호'		, type: 'string'},
			{name: 'ITEM_CODE' 				, text: '품목'			, type: 'string'},
			{name: 'ITEM_NAME' 				, text: '품목명'		    , type: 'string'},
			{name: 'SPEC' 					, text: '규격'		    , type: 'string'},
			{name: 'STOCK_UNIT'				, text: '단위'		    , type: 'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value'},
			{name: 'WK_PLAN_Q' 				, text: '계획량'			, type: 'uniQty'},
			{name: 'WKORD_Q'                , text: '지시량'          , type: 'uniQty'},
			{name: 'WKORD_REMAIN_Q'         , text: '잔량'           , type: 'uniQty'},
			{name: 'PRODUCT_LDTIME'			, text: '제조L/T'			, type: 'string'},
			{name: 'PRODT_START_DATE'		, text: '착수예정일'		, type: 'uniDate'},
			{name: 'PRODT_PLAN_DATE'		, text: '계획완료일'		, type: 'uniDate'},
			{name: 'ORDER_NUM'	 			, text: '수주번호'			, type: 'string'},
			{name: 'ORDER_DATE' 			, text: '수주일'			, type: 'string'},
			{name: 'ORDER_Q' 				, text: '수주량'			, type: 'uniQty'},
			{name: 'CUSTOM_CODE'	 		, text: '거래처명'			, type: 'string'},
			{name: 'DVRY_DATE' 				, text: '납기일'			, type: 'uniDate'},
			{name: 'PROJECT_NO' 			, text: '프로젝트번호'		, type: 'string'},
			{name: 'PJT_CODE' 				, text: '프로젝트번호'		, type: 'string'}
		]
	});

	var productionPlanStore = Unilite.createStore('s_pmp110ukrv_kdProductionPlanStore', {
			model: 's_pmp110ukrv_kdProductionPlanModel',
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
                	read    : 's_pmp110ukrv_kdService.selectEstiList'
                }
            },
            loadStoreRecords : function()	{
				var param= productionPlanSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});

	var productionPlanGrid = Unilite.createGrid('s_pmp110ukrv_kdproductionPlanGrid', {
    	layout : 'fit',
    	store: productionPlanStore,
        selModel: 'rowmodel',
        uniOpt:{
            onLoadSelectFirst : true
        },
        columns: [
        	{dataIndex: 'GUBUN'        		      	, width:0  ,hidden: true},
			{dataIndex: 'DIV_CODE'			      	, width:0  ,hidden: true},
	        {dataIndex: 'WORK_SHOP_CODE'		    , width:100},
	        {dataIndex: 'WK_PLAN_NUM'		      	, width:100,hidden: true},
	        {dataIndex: 'ITEM_CODE' 			    , width:100},
	        {dataIndex: 'ITEM_NAME' 			    , width:126},
	        {dataIndex: 'SPEC' 				      	, width:120},
	        {dataIndex: 'STOCK_UNIT'			    , width:40, align: 'center'},
	        {dataIndex: 'WK_PLAN_Q' 			    , width:73},
	        {dataIndex: 'WKORD_Q'                   , width:73},
	        {dataIndex: 'WKORD_REMAIN_Q'            , width:73},
	        {dataIndex: 'PRODUCT_LDTIME'		    , width:53},
	        {dataIndex: 'PRODT_START_DATE'      	, width:73},
	        {dataIndex: 'PRODT_PLAN_DATE'	      	, width:73},
	        {dataIndex: 'ORDER_NUM'	 		      	, width:93},
	        {dataIndex: 'ORDER_DATE' 		      	, width:73},
	        {dataIndex: 'ORDER_Q' 			      	, width:73},
	        {dataIndex: 'CUSTOM_CODE'	       		, width:100},
	        {dataIndex: 'DVRY_DATE' 			    , width:73 ,hidden: true},
	        {dataIndex: 'PROJECT_NO' 		      	, width:80 ,hidden: true},
	        {dataIndex: 'PJT_CODE' 			      	, width:80 ,hidden: true}
		],
		listeners: {
	          onGridDblClick: function(grid, record, cellIndex, colName) {
	          	    if(!productionPlanInputForm.getInvalidMessage()) return;
		          	productionPlanGrid.returnData(record);
		          	referProductionPlanWindow.hide();
		          	panelSearch.getField('REWORK_YN').setReadOnly( false );
		          	panelResult.getField('REWORK_YN').setReadOnly( false );
	          },
              selectionchange: function( grid, selected, eOpts ) {
                    var record = selected[0];
                    if(record){
                        productionPlanInputForm.setValue('PRODT_START_DATE',record.get('PRODT_START_DATE'));
                        productionPlanInputForm.setValue('PRODT_END_DATE',record.get('PRODT_PLAN_DATE'));
                        productionPlanInputForm.setValue('WKORD_Q',record.get('WKORD_REMAIN_Q'));
                        productionPlanInputForm.setValue('PROG_UNIT',record.get('STOCK_UNIT'));
                    }
              }
          },
          	returnData: function(record)	{
	          	if(Ext.isEmpty(record))	{
	          		record = this.getSelectedRecord();
	          		panelSearch.getField('REWORK_YN').setReadOnly( false );
	          		panelResult.getField('REWORK_YN').setReadOnly( false );
	          	}
	          	panelSearch.setValues({'DIV_CODE':record.get('DIV_CODE'),   /*사업장*/		  'WKORD_NUM':record.get('WKORD_NUM'),  			 /*작업지시번호*/
	          						  'WORK_SHOP_CODE':record.get('WORK_SHOP_CODE'), /* 작업장*/'ITEM_CODE':record.get('ITEM_CODE'),				 /*품목코드*/
	          						  'ITEM_NAME':record.get('ITEM_NAME'),	/*품목명*/		  'SPEC':record.get('SPEC'), 						 /*규격*/
	          						  'PRODT_START_DATE':productionPlanInputForm.getValue('PRODT_START_DATE'),    'PRODT_WKORD_DATE': productionPlanInputForm.getValue('PRODT_WKORD_DATE'),
	          						  'PRODT_END_DATE':productionPlanInputForm.getValue('PRODT_END_DATE'),		  'LOT_NO':productionPlanInputForm.getValue('LOT_NO'),
	          						  'WKORD_Q':productionPlanInputForm.getValue('WKORD_Q'),					  'PROG_UNIT':productionPlanInputForm.getValue('PROG_UNIT'),
	          						  'PROJECT_NO':record.get('PROJECT_NO'),				  'ANSWER':record.get('REMARK'),
	          						  'PJT_CODE':record.get('PJT_CODE'),					  'WORK_END_YN':record.get('WORK_END_YN'),
	          						  'ORDER_NUM':record.get('ORDER_NUM'), 	/* 수주번호*/		  'ORDER_Q':record.get('ORDER_Q'),  				/* 수주량*/
	          						  'DVRY_DATE':record.get('DVRY_DATE'),  /* 납기일*/		  'CUSTOM':record.get('CUSTOM_CODE'),
	          						  /*'REWORK_YN':record.get('REWORK_YN'),*/				  'PROG_UNIT':record.get('STOCK_UNIT'),
	          						  'EXCHG_TYPE':record.get('STOCK_EXCHG_TYPE'),
	          						  'WK_PLAN_NUM':record.get('WK_PLAN_NUM')
	          						  });
	          	panelSearch.getField('REWORK_YN').setValue(record.get('REWORK_YN'));
	          	panelResult.getField('REWORK_YN').setValue(record.get('REWORK_YN'));


				panelResult.setValues({'ITEM_CODE':record.get('ITEM_CODE'),	/*품목*/		 'ITEM_NAME':record.get('ITEM_NAME'),
									   'PROJECT_NO':record.get('PROJECT_NO'),
									   'PJT_CODE':record.get('PJT_CODE'),				 'WORK_END_YN':record.get('WORK_END_YN'),
									   'WKORD_Q':record.get('WK_PLAN_Q'),
									   'PRODT_START_DATE':productionPlanInputForm.getValue('PRODT_START_DATE'),    'PRODT_WKORD_DATE': productionPlanInputForm.getValue('PRODT_WKORD_DATE'),
                                       'PRODT_END_DATE':productionPlanInputForm.getValue('PRODT_END_DATE'),        'LOT_NO':productionPlanInputForm.getValue('LOT_NO'),
                                       'WKORD_Q':productionPlanInputForm.getValue('WKORD_Q'),                      'PROG_UNIT':productionPlanInputForm.getValue('PROG_UNIT')
	          						   });
	          	panelSearch.getField('DIV_CODE').setReadOnly( true );
				panelSearch.getField('WKORD_NUM').setReadOnly( true );
				panelSearch.getField('WORK_SHOP_CODE').setReadOnly( true );
				panelSearch.getField('ITEM_CODE').setReadOnly( true );
				panelSearch.getField('ITEM_NAME').setReadOnly( true );
				panelSearch.getField('SPEC').setReadOnly( true );
				panelSearch.getField('EXCHG_TYPE').setReadOnly( true );
				panelSearch.getField('PROG_UNIT').setReadOnly( true );

				Ext.getCmp('rework').setReadOnly(false);
				Ext.getCmp('workEndYn').setReadOnly(true);

				Ext.getCmp('reworkRe').setReadOnly(false);
				Ext.getCmp('workEndYnRe').setReadOnly(true);

				panelResult.getField('DIV_CODE').setReadOnly( true );
				panelResult.getField('WKORD_NUM').setReadOnly( true );
				panelResult.getField('WORK_SHOP_CODE').setReadOnly( true );
				panelResult.getField('ITEM_CODE').setReadOnly( true );
				panelResult.getField('ITEM_NAME').setReadOnly( true );
//				panelResult.getField('SPEC').setReadOnly( true );
				panelResult.getField('PROG_UNIT').setReadOnly( true );

				detailGrid.down('#refTool').menu.down('#requestBtn').setDisabled(true);

				//20170517 - 사용 안 함(주석)
//                detailGrid.getStore().setProxy(directProxy3);  /* proxy 변경 후 조회 */

                //20170517 - onNewDataButtonDown에서 수행하는 로직이라 주석 처리
//				var param = {
//                    "DIV_CODE"          : record.get('DIV_CODE'),
//                    "ITEM_CODE"         : record.get('ITEM_CODE'),
//                    "WORK_SHOP_CODE"    : record.get('WORK_SHOP_CODE')
//                };
//				s_pmp110ukrv_kdService.selectProgInfo(param, function(provider, response) {
//				    var records = response.result;
//				    Ext.each(records, function(record,i){
                       UniAppManager.app.onNewDataButtonDown();
//                       detailGrid.setEstiData(record);
//                    });
//				});
          }
    });


	function openProductionPlanWindow() {
  		//if(!UniAppManager.app.checkForNewDetail()) return false;

/*  	requestSearch.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
  		requestSearch.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
  		requestSearch.setValue('FR_ESTI_DATE', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE')) );
  		requestSearch.setValue('TO_ESTI_DATE', panelSearch.getValue('ORDER_DATE'));
  		requestSearch.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
  		divPrsnStore.loadStoreRecords(); // 사업장별 영업사원 콤보
*/

		if(!referProductionPlanWindow) {
			referProductionPlanWindow = Ext.create('widget.uniDetailWindow', {
                title: '생산계획정보',
                width: 1080,
                height: 580,
                layout:{type:'vbox', align:'stretch'},

                items: [productionPlanSearch, productionPlanInputForm, productionPlanGrid],
                tbar:  ['->',
								        {	itemId : 'saveBtn',
											text: '조회',
											handler: function() {
												if(!productionPlanSearch.getInvalidMessage()) return;
												productionPlanStore.loadStoreRecords();
											},
											disabled: false
										},
										{	itemId : 'confirmBtn',
											text: '적용',
											handler: function() {
												if(!productionPlanInputForm.getInvalidMessage()) return;
												productionPlanGrid.returnData();
												referProductionPlanWindow.hide();
											},
											disabled: false
										},
										{	itemId : 'confirmCloseBtn',
											text: '적용 후 닫기',
											handler: function() {
												if(!productionPlanInputForm.getInvalidMessage()) return;
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
										}
							    ]
							,
                listeners : {beforehide: function(me, eOpt)	{
                							//requestSearch.clearForm();
                							//requestGrid,reset();
                						},
                			 beforeclose: function( panel, eOpts )	{
											//requestSearch.clearForm();
                							//requestGrid,reset();
                			 			},
                			 beforeshow: function ( me, eOpts )	{
                			 	productionPlanSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
                			 	productionPlanSearch.setValue('WORK_SHOP_CODE',panelSearch.getValue('WORK_SHOP_CODE'));
                			 	productionPlanSearch.setValue('ITEM_CODE',panelSearch.getValue('ITEM_CODE'));
                			 	productionPlanSearch.setValue('ITEM_NAME',panelSearch.getValue('ITEM_NAME'));
                			 	productionPlanInputForm.setValue('PRODT_WKORD_DATE',panelSearch.getValue('PRODT_WKORD_DATE'));
                			 	productionPlanInputForm.setValue('PRODT_START_DATE',panelSearch.getValue('PRODT_START_DATE'));
                			 	productionPlanInputForm.setValue('PRODT_END_DATE',panelSearch.getValue('PRODT_END_DATE'));
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

			var requestBtn = detailGrid.down('#refTool').menu.down('#requestBtn')

		},
		onQueryButtonDown: function() {
			var orderNo = panelSearch.getValue('WKORD_NUM');
			if(Ext.isEmpty(orderNo)) {
				opensearchInfoWindow();
//				productionNoMasterStore.loadStoreRecords();

			} else {
				//20170517 - 주석
//				detailGrid.getStore().setProxy(directProxy);  /* proxy 변경 후 조회 */
				detailStore.loadStoreRecords();
                panelSearch.setAllFieldsReadOnly(true);
                panelResult.setAllFieldsReadOnly(true);
                panelSearch.getField('rework').setReadOnly( false );
                panelResult.getField('reworkRe').setReadOnly( false );
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
			/*	DIV_CODE 사업장
				WKROD_NUM 작업지시번호
				WORK_SHOP_CODE 작업장
				ITEM_CODE	품목
				ITEM_NAME	품명
				SPEC		규격
				PRODT_WKORD_DATE 작업지시일
				PRODT_START_DATE 착수예정일
				PRODT_END_DATE	 완료예정일
				LOT_NO	 LOT_NO
				WKORD_Q		 작업지시량
				PROG_UNIT	 단위
				PROJECT_NO	 관리번호
				ANSWER		 특기사항
				PJT_CODE	 프로젝트번호
				WORK_END_YN	 마감여부
				EXCHG_TYPE	 재고대체유형
				REWORK_YN	 재작업지시
			*/
//				 var seq = detailStore.max('SER_NO');
//            	 if(!seq) seq = 1;
//            	 else  seq += 1;
//			     var linSeq = detailStore.max('LINE_SEQ');
//                 if(!linSeq) linSeq = 1;
//                 else  linSeq += 1;
//				 var compCode		= UserInfo.compCode;
//				 var divCode  	    = panelSearch.getValue('DIV_CODE');
//				 var wkordNum		= panelSearch.getValue('WKORD_NUM');
//				 var workShopCode   = panelSearch.getValue('WORK_SHOP_CODE');
//				 var itemCode       = panelSearch.getValue('ITEM_CODE');
//            	 var itemName		= panelSearch.getValue('ITEM_NAME');
//				 var spec			= panelSearch.getValue('SPEC');
//				 var prodtStartDate = panelSearch.getValue('PRODT_WKORD_DATE');
//            	 var prodtEndDate   = panelSearch.getValue('PRODT_START_DATE');
//            	 var prodtWkordDate = panelSearch.getValue('PRODT_END_DATE');
//            	 var lotNo          = panelSearch.getValue('LOT_NO');
//            	 var wkordQ         = panelSearch.getValue('WKORD_Q');
//            	 var progUnit      	= panelSearch.getValue('PROG_UNIT');
//            	 var projectNo      = panelSearch.getValue('PROJECT_NO');
//            	 var pjtCode        = panelSearch.getValue('PJT_CODE');
//            	 var answer         = panelSearch.getValue('ANSWER');
//            	 var workEndYn      = Ext.getCmp('workEndYn').getChecked()[0].inputValue;
//            	 var exchgType 		= panelSearch.getValue('EXCHG_TYPE');
//            	 var reworkYn		= Ext.getCmp('rework').getChecked()[0].inputValue;
//            	 var progUnitQ		= 1;
//
//
//            	 var r = {
//            	 	SER_NO            : seq,
//            	 	LINE_SEQ          : linSeq,
//            	 	COMP_CODE		  : compCode,
//            	 	DIV_CODE 		  : divCode,
//					WKORD_NUM 		  : wkordNum,
//					WORK_SHOP_CODE	  : workShopCode,
//					ITEM_CODE		  : itemCode,
//					ITEM_NAME		  : itemName,
//					SPEC			  : spec,
//					PRODT_WKORD_DATE  : prodtWkordDate,
//					PRODT_START_DATE  : prodtStartDate,
//					PRODT_END_DATE	  : prodtEndDate,
//					LOT_NO		  : lotNo,
//					WKORD_Q			  : wkordQ,
//					PROG_UNIT		  : progUnit,
//					PROJECT_NO	      : projectNo,
//					REMARK			  : answer,
//					PJT_CODE		  : pjtCode,
//					WORK_END_YN	      : workEndYn,
//					EXCHG_TYPE		  : exchgType,
//					REWORK_YN		  : reworkYn,
//					PROG_UNIT_Q		  : progUnitQ
//
//		        };
//				detailGrid.createRow(r);

				var param = panelSearch.getValues();
                s_pmp110ukrv_kdService.selectProgInfo(param, function(provider, response) {
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
                                var divCode        = panelSearch.getValue('DIV_CODE');
                                var wkordNum       = panelSearch.getValue('WKORD_NUM');
                                var workShopCode   = panelSearch.getValue('WORK_SHOP_CODE');
                                var itemCode       = panelSearch.getValue('ITEM_CODE');
                                var itemName       = panelSearch.getValue('ITEM_NAME');
                                var spec           = panelSearch.getValue('SPEC');
                                var prodtStartDate = panelSearch.getValue('PRODT_START_DATE');
                                var prodtEndDate   = panelSearch.getValue('PRODT_END_DATE');
                                var prodtWkordDate = panelSearch.getValue('PRODT_WKORD_DATE');
                                var lotNo          = panelSearch.getValue('LOT_NO');
                                var wkordQ         = panelSearch.getValue('WKORD_Q');
                                var progUnit       = panelSearch.getValue('PROG_UNIT');
                                var projectNo      = panelSearch.getValue('PROJECT_NO');
                                var pjtCode        = panelSearch.getValue('PJT_CODE');
                                var answer         = panelSearch.getValue('ANSWER');
                                var workEndYn      = Ext.getCmp('workEndYn').getChecked()[0].inputValue;
                                var exchgType      = panelSearch.getValue('EXCHG_TYPE');
                                var reworkYn       = Ext.getCmp('rework').getChecked()[0].inputValue;
                                var progUnitQ      = 1;
                                var wkPlanNum      = panelSearch.getValue('WK_PLAN_NUM');

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
                                   LOT_NO          : lotNo,
                                   WKORD_Q           : wkordQ,
                                   PROG_UNIT         : progUnit,
                                   PROJECT_NO        : projectNo,
                                   REMARK            : answer,
                                   PJT_CODE          : pjtCode,
                                   WORK_END_YN       : workEndYn,
                                   EXCHG_TYPE        : exchgType,
                                   REWORK_YN         : reworkYn,
                                   PROG_UNIT_Q       : progUnitQ,
                                   WK_PLAN_NUM       : wkPlanNum

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
                            var divCode        = panelSearch.getValue('DIV_CODE');
                            var wkordNum       = panelSearch.getValue('WKORD_NUM');
                            var workShopCode   = panelSearch.getValue('WORK_SHOP_CODE');
                            var itemCode       = panelSearch.getValue('ITEM_CODE');
                            var itemName       = panelSearch.getValue('ITEM_NAME');
                            var spec           = panelSearch.getValue('SPEC');
                            var prodtStartDate = panelSearch.getValue('PRODT_WKORD_DATE');
                            var prodtEndDate   = panelSearch.getValue('PRODT_START_DATE');
                            var prodtWkordDate = panelSearch.getValue('PRODT_END_DATE');
                            var lotNo          = panelSearch.getValue('LOT_NO');
                            var wkordQ         = panelSearch.getValue('WKORD_Q');
                            var progUnit       = panelSearch.getValue('PROG_UNIT');
                            var projectNo      = panelSearch.getValue('PROJECT_NO');
                            var pjtCode        = panelSearch.getValue('PJT_CODE');
                            var answer         = panelSearch.getValue('ANSWER');
                            var workEndYn      = Ext.getCmp('workEndYn').getChecked()[0].inputValue;
                            var exchgType      = panelSearch.getValue('EXCHG_TYPE');
                            var reworkYn       = Ext.getCmp('rework').getChecked()[0].inputValue;
                            var progUnitQ      = 1;
                            var wkPlanNum      = panelSearch.getValue('WK_PLAN_NUM');

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
                               LOT_NO          : lotNo,
                               WKORD_Q           : wkordQ,
                               PROG_UNIT         : progUnit,
                               PROJECT_NO        : projectNo,
                               REMARK            : answer,
                               PJT_CODE          : pjtCode,
                               WORK_END_YN       : workEndYn,
                               EXCHG_TYPE        : exchgType,
                               REWORK_YN         : reworkYn,
                               PROG_UNIT_Q       : progUnitQ,
                               WK_PLAN_NUM       : wkPlanNum
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
                        var divCode        = panelSearch.getValue('DIV_CODE');
                        var wkordNum       = panelSearch.getValue('WKORD_NUM');
                        var workShopCode   = panelSearch.getValue('WORK_SHOP_CODE');
                        var itemCode       = panelSearch.getValue('ITEM_CODE');
                        var itemName       = panelSearch.getValue('ITEM_NAME');
                        var spec           = panelSearch.getValue('SPEC');
                        var prodtStartDate = panelSearch.getValue('PRODT_WKORD_DATE');
                        var prodtEndDate   = panelSearch.getValue('PRODT_START_DATE');
                        var prodtWkordDate = panelSearch.getValue('PRODT_END_DATE');
                        var lotNo          = panelSearch.getValue('LOT_NO');
                        var wkordQ         = panelSearch.getValue('WKORD_Q');
                        var progUnit       = panelSearch.getValue('PROG_UNIT');
                        var projectNo      = panelSearch.getValue('PROJECT_NO');
                        var pjtCode        = panelSearch.getValue('PJT_CODE');
                        var answer         = panelSearch.getValue('ANSWER');
                        var workEndYn      = Ext.getCmp('workEndYn').getChecked()[0].inputValue;
                        var exchgType      = panelSearch.getValue('EXCHG_TYPE');
                        var reworkYn       = Ext.getCmp('rework').getChecked()[0].inputValue;
                        var progUnitQ      = 1;
                        var wkPlanNum      = panelSearch.getValue('WK_PLAN_NUM');


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
                           EXCHG_TYPE        : exchgType,
                           REWORK_YN         : reworkYn,
                           PROG_UNIT_Q       : progUnitQ,
                           WK_PLAN_NUM       : wkPlanNum

                        };
                        detailGrid.createRow(r);
                    }
                });
				UniAppManager.app.setReadOnly(true);
//                panelSearch.setAllFieldsReadOnly(true);
//                panelResult.setAllFieldsReadOnly(true);
			},
		onResetButtonDown: function() {
			this.suspendEvents();
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.clearForm();
            panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitBinding();
			panelSearch.getField('WKORD_NUM').focus();

			//20170517 - 아래 setReadOnly 호출하는 부분으로 대체
//			panelSearch.getField('DIV_CODE').setReadOnly( false );
//			panelSearch.getField('WKORD_NUM').setReadOnly( false );
//			panelSearch.getField('WORK_SHOP_CODE').setReadOnly( false );
//			panelSearch.getField('ITEM_CODE').setReadOnly( false );
//			panelSearch.getField('ITEM_NAME').setReadOnly( false );
//			panelSearch.getField('EXCHG_TYPE').setReadOnly( true );

//            panelSearch.getField('PRODT_WKORD_DATE').setReadOnly( false );
//            panelSearch.getField('PRODT_START_DATE').setReadOnly( false );
//            panelSearch.getField('PRODT_END_DATE').setReadOnly( false );
//            panelSearch.getField('LOT_NO').setReadOnly( false );
//            panelSearch.getField('WKORD_Q').setReadOnly( false );
//            panelSearch.getField('ANSWER').setReadOnly( false );
//            panelSearch.getField('PROJECT_NO').setReadOnly( false );
//            panelSearch.getField('PROJECT_CODE').setReadOnly( false );

			//20170517 - 아래 setReadOnly 호출하는 부분으로 대체
//			panelResult.getField('DIV_CODE').setReadOnly( false );
//			panelResult.getField('WKORD_NUM').setReadOnly( false );
//			panelResult.getField('WORK_SHOP_CODE').setReadOnly( false );
//			panelResult.getField('ITEM_CODE').setReadOnly( false );
//			panelResult.getField('ITEM_NAME').setReadOnly( false );
//			panelResult.getField('EXCHG_TYPE').setReadOnly( true );

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

			Ext.getCmp('rework').setReadOnly(false);
			Ext.getCmp('workEndYn').setReadOnly(true);

			Ext.getCmp('reworkRe').setReadOnly(false);
			Ext.getCmp('workEndYnRe').setReadOnly(true);

			panelResult.getField('WORK_END_YN').setValue('N');
			panelResult.getField('REWORK_YN').setValue('N')

			this.setDefault();

			detailGrid.down('#refTool').menu.down('#requestBtn').setDisabled(false);
		},
		onSaveDataButtonDown: function(config) {
			/*var progUnitQ = detailStore.data.items.PROG_UNIT_Q;

			Ext.each(progUnitQ, function(record,i){

				if(record.get('PROG_UNIT_Q',(progUnitQ)) > 1){
					alret("tttt");
				}

			});*/


			detailStore.saveStore();
//			UniAppManager.app.onQueryButtonDown();
			if(panelSearch.getField('WKORD_NUM') != ''){
				//panelSearch.getField('REWORK_YN').setReadOnly( false ); test
				Ext.getCmp('workEndYn').setReadOnly(true);
				Ext.getCmp('workEndYnRe').setReadOnly(true);
			}
			else{
				//panelSearch.getField('REWORK_YN').setReadOnly( true ); test
				Ext.getCmp('workEndYn').setReadOnly(false);
				Ext.getCmp('workEndYnRe').setReadOnly(false);
			}
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
            var records = detailStore.data.items;
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
			var as = Ext.getCmp('s_pmp110ukrv_kdAdvanceSerch');
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
			var fp = Ext.getCmp('s_pmp110ukrv_kdFileUploadPanel');
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
        	panelSearch.setValue('PRODT_WKORD_DATE',new Date());
        	panelSearch.setValue('PRODT_START_DATE',new Date());
        	panelSearch.setValue('PRODT_END_DATE',new Date());
        	panelSearch.setValue('WKORD_Q',0.00);
        	panelSearch.setValue('ORDER_Q',0.00);

        	panelResult.setValue('PRODT_WKORD_DATE',new Date());
        	panelResult.setValue('PRODT_START_DATE',new Date());
        	panelResult.setValue('PRODT_END_DATE',new Date());
        	panelResult.setValue('WKORD_Q',0.00);
        	panelResult.setValue('ORDER_Q',0.00);


            panelSearch.getField('SPEC').setReadOnly(true);
            panelSearch.getField('PROG_UNIT').setReadOnly(true);
            panelSearch.getField('WORK_END_YN').setReadOnly(true);
            //panelResult.getField('SPEC').setReadOnly(true);
            panelResult.getField('PROG_UNIT').setReadOnly(true);
            panelResult.getField('WORK_END_YN').setReadOnly(true);

			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
			this.setReadOnly();
		},

		setReadOnly: function(flag) {
        	panelSearch.getField('DIV_CODE').setReadOnly(flag);
//        	panelSearch.getField('WKORD_NUM').setReadOnly(true);
        	panelSearch.getField('WORK_SHOP_CODE').setReadOnly(flag);
        	panelSearch.getField('ITEM_CODE').setReadOnly(flag);
        	panelSearch.getField('ITEM_NAME').setReadOnly(flag);
//        	panelSearch.getField('SPEC').setReadOnly(true);
//        	panelSearch.getField('PROG_UNIT').setReadOnly(true);
        	panelSearch.getField('WORK_END_YN').setReadOnly(true);
        	panelSearch.getField('EXCHG_TYPE').setReadOnly(flag);
//        	panelSearch.getField('').setReadOnly(flag);

        	panelResult.getField('DIV_CODE').setReadOnly(flag);
//        	panelResult.getField('WKORD_NUM').setReadOnly(true);
        	panelResult.getField('WORK_SHOP_CODE').setReadOnly(flag);
        	panelResult.getField('ITEM_CODE').setReadOnly(flag);
        	panelResult.getField('ITEM_NAME').setReadOnly(flag);
//        	panelSearch.getField('SPEC').setReadOnly(true);
//        	panelSearch.getField('PROG_UNIT').setReadOnly(true);
        	panelSearch.getField('WORK_END_YN').setReadOnly(true);
        	panelSearch.getField('EXCHG_TYPE').setReadOnly(flag);
//        	panelSearch.getField('').setReadOnly(flag);

//			panelSearch.getForm().wasDirty = false;
//			panelSearch.resetDirtyStatus();
//			UniAppManager.setToolbarButtons('save', false);
		},

		checkForNewDetail:function() {
            if(panelSearch.setAllFieldsReadOnly(true)){
                return panelResult.setAllFieldsReadOnly(true);
            }
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
				case "PROG_UNIT_Q" : // 원단위량
					var wkordQ = panelSearch.getValue("WKORD_Q");

					if(newValue <= 0 ){
						//0보다 큰수만 입력가능합니다.
						rv='<t:message code="unilite.msg.sMP570"/>';
						break;
					}
					if(newValue > 0){
						record.set('WKORD_Q',(newValue * wkordQ));
						break;
						// 작업지시량 = 원단위량 * newValue
					}break;

				case "WKORD_Q", "LINE_SEQ"	: // 작업지시량 , 공정순번

					if(newValue <= 0 ){
							//0보다 큰수만 입력가능합니다.
							rv='<t:message code="unilite.msg.sMP570"/>';
							break;
					}break;
				case "PROG_UNIT" : //
					// 정확한 코드를 입력하시오 sMB081
			}
			return rv;
		}
	}); // validator


	/*Unilite.createValidator('validator02', {
		forms: {'formA:':panelSearch},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "WKORD_Q" :  // 환율
					var progUnitQ = detailGrid.get("PROG_UNIT_Q");

					if(newValue > 0){
						detailGrid.set("WKORD_Q", (newValue * progUnitQ) );
						break;
					}

					break;

			}
			return rv;
		}
	}); // validator02
*/};
</script>